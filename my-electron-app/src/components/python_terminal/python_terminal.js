const child_process = require('child_process')
const file_manager = require('../file_management/file_manager.js')
const path = require('path');
const CONSTANTS = require("../../constants.js");
//const { ipcRenderer } = require('electron');

var python_instance = null;
var is_ecf = false
var initial_output = ""
var python_instance1 = undefined
var python_instance2 = undefined

function process_backend_modify_output(ipcMain, event, process, exit_value){
    if (exit_value[0] == '0'){
        file_manager.updateSave(process.stdout_data.toString())
        event.reply('update-renderer', file_manager.getSave())
        event.reply('console-message', "\nCommand successful")
    } else {
        event.reply('system-message', process.stderr_data.toString())
    }
}

function process_backend_generation_output(ipcMain, event, process, exit_value){
    if (exit_value[0] == '0'){
        let save_path = file_manager.openSaveDialog(undefined, true)
        if (save_path != undefined){
            file_manager.writeFile(save_path, process.stdout_data.toString())
            event.reply('console-message', "\nGeneration successful")
        } else {
            event.reply('console-message', "\nGeneration cancelled")
        }
        
    } else {
        event.reply('system-message', process.stderr_data.toString())
    }
}

function call_backend(ipcMain, str_data, event){
    let data_array = str_data.split(CONSTANTS.MGK)
    
    let filepath =  path.join(__dirname, "..", "..", "..", "resources", "generator", data_array[2])
    
    console.log(filepath)

    // find verilog function arguments
    let arg_arr = []
    arg_arr.push(filepath)
    arg_arr.push(JSON.stringify(file_manager.getSave()))
    for (let i = 3; i < data_array.length; i++){
        arg_arr.push(data_array[i])
    }

    let options = {cwd:path.join(__dirname,"..","..","..", "resources", "generator")}

    // run backend python
    let process = child_process.spawn('py', arg_arr, options)

    process.stderr_data = undefined
    process.stdout_data = undefined
    
    // remember process type
    process.type = parseInt(data_array[1])

    // set listener for stdout and stderr
    process.stderr.once('data', (data) => {
        console.log("Error from child_process: " + data.toString())
        process.stderr_data = data
    })
    process.stdout.once('data', (data) => {
        console.log("received data: " + data.toString())
        process.stdout_data = data
    })

    // process the return value or error
    process.once('close', (data) => {
        console.log("exit value: " + data.toString())
        
        // if modify, then expect json string returns
        if (process.type == 2){
            process_backend_modify_output(ipcMain, event, process, data.toString())
        } // TODO: finish for validation
        else if (process.type == 0){
            process_backend_generation_output(ipcMain, event, process, data.toString())
        }
    })
}

function tryPythonSpawn(ipcMain, args, options, is_ecf_option){
    var test_python_instance = child_process.spawn('py', args, options)

    // use python_init.py to initialize it
    var init_file_content = file_manager.readFile(path.join(__dirname, "python_init.py"))

    test_python_instance.stdin.write(init_file_content + "\n")   

    test_python_instance.stdout.once('data', (data)=>{
        initial_output = data.toString()
        
        python_instance = test_python_instance
        is_ecf = is_ecf_option
        
        // show initial output of python initialization
        ipcMain.on('get-python-version', (event,arg)=>{
            event.returnValue = initial_output
        })

        ipcMain.on('console-input-reading', (event,arg) => {
            python_instance.stdout.removeAllListeners('data')
            
            // deal with data that comes back
            python_instance.stdout.once('data', function (data) {
                let str_data = undefined
                
                if (is_ecf){
                    str_data = data.toString().slice(0, data.toString().length - 4)
                } else {
                    str_data = data.toString().slice(0, data.toString().length - 2)
                }
                
                // not a special message
                if (str_data.slice(0, CONSTANTS.MGK.length) != (CONSTANTS.MGK)){
                    event.reply('console-message', str_data)
                } else {
                    // process what comes back
                    // format: [MGK] [filename] [MGK] [parameters each separated by |]
                    // TODO: fix problem with final argument
                    call_backend(ipcMain, str_data, event)
                }
            })

            python_instance.stderr.removeAllListeners('data')  

            python_instance.stderr.once('data', function (data) {
                let datastr = data.toString()
                event.reply('console-message', datastr.slice(0, datastr.length - 4))
            })

            python_instance.stdin.write(arg+"\n")
        })
    })
    
    //throw away first message
    test_python_instance.stderr.once('data', function (data) {console.log(data.toString())})
}

// external functions
function initializePythonProcess (ipcMain) {
    let options = {
        cwd:path.join(__dirname,"..")
    }
    tryPythonSpawn(ipcMain, [], options, true)
    tryPythonSpawn(ipcMain, ['-i'], options, false)
}

function isECF(){
    return is_ecf
}

module.exports = {
    initializePythonProcess,
    isECF,
}