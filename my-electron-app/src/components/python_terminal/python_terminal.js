const child_process = require('child_process')
const file_manager = require('../file_management/file_manager.js')
const path = require('path');
const CONSTANTS = require("../../constants.js");
const {fileURLToPath} = require('url')

var python_instance = null;
var is_ecf = false
var initial_output = ""
var lock = false

function process_backend_modify_output(ipcMain, event, process, exit_value){
    if (exit_value[0] == '0'){
        console.log("got here")
        file_manager.updateSave(process.stdout_data.toString())
        event.reply('update-renderer', file_manager.getSave())
        event.reply('console-message', "\nCommand successful\n")
    } else {
        console.log("got here")
        if (process.stdout_data.length != 0)
            event.reply('console-message', process.stdout_data.toString())
        if (process.stderr_data.length != 0)
            event.reply('system-message', process.stderr_data.toString())
    }
}

function process_backend_validate_output(ipcMain, event, process, exit_value){
    if (process.stdout_data.length != 0)
        event.reply('system-message', process.stdout_data.toString())
    if (process.stderr_data.length != 0)
        event.reply('system-message', process.stderr_data.toString())
}

function process_backend_generation_output(ipcMain, event, process, exit_value){
    if (exit_value[0] == '0'){
        event.reply('system-message', "Generation successful\n")
    } else {
        event.reply('system-message', process.stderr_data.toString())
    }
}

function call_backend(ipcMain, str_data, event){
    let data_array = str_data.split(CONSTANTS.MGK)
    let target_folder = "default"
    let filepath =  path.join("..", "generator", data_array[2])
    
    console.log("test")
    console.log(filepath)

    // find verilog function arguments
    let arg_arr = []
    arg_arr.push(filepath)
    arg_arr.push(JSON.stringify(file_manager.getSave()))
    for (let i = 3; i < data_array.length; i++){
        arg_arr.push(data_array[i])
    }

    // choose destination folder, if generating
    if (parseInt(data_array[1]) == 0){
        target_folder = file_manager.openFolderDialog(undefined)
        console.log("chose: " + target_folder)
        if (target_folder == undefined) {
            event.reply('system-message', "Generation cancelled\n")
            return
        } else {
            arg_arr.push(path.join(target_folder[0],"\\"))
        }
    }
    console.log(arg_arr)

    let options = {cwd:path.join(__dirname,"..","..","..", "resources", "generator")}

    // run backend python
    let process = child_process.spawn(path.join(__dirname,"python",'python.exe'), arg_arr, options)

    process.stderr_data = ""
    process.stdout_data = ""
    
    // remember process type
    process.type = parseInt(data_array[1])

    // set listener for stdout and stderr
    process.stderr.on('data', (data) => {
        console.log("Error from child_process: " + data.toString())
        process.stderr_data += data
    })
    process.stdout.on('data', (data) => {
        console.log("received data: " + data.toString())
        process.stdout_data += data
    })

    // process the return value or error
    process.once('close', (data) => {
        console.log("exit value: " + data.toString())
        
        // if modify, then expect json string returns
        if (process.type == 2){
            process_backend_modify_output(ipcMain, event, process, data.toString())
        } else if (process.type == 1){
            process_backend_validate_output(ipcMain, event, process, data.toString())
        } else if (process.type == 0){
            process_backend_generation_output(ipcMain, event, process, data.toString())
        }
        
        event.returnValue = "done"
    })
}

function tryPythonSpawn(ipcMain, args, options){
    var test_python_instance = child_process.spawn(path.join('.','python','python.exe'), args, options)

    // use python_init.py to initialize it
    var init_file_content = file_manager.readFile(path.join(__dirname, "python_init.py"))

    test_python_instance.stdin.write(init_file_content + "\n")   

    test_python_instance.stdout.once('data', (data)=>{
        initial_output = data.toString()
        
        python_instance = test_python_instance
        
        // show initial output of python initialization
        ipcMain.on('get-python-version', (event,arg)=>{
            event.returnValue = initial_output
        })

        ipcMain.on('console-input-reading', (event,arg) => {
            python_instance.stdout.removeAllListeners('data')
            
            // deal with data that comes back
            python_instance.stdout.once('data', function (data) {
                let str_data = undefined
                
                str_data = data.toString().slice(0, data.toString().length - 2)
                
                // not a special message
                if (str_data.slice(0, CONSTANTS.MGK.length) != (CONSTANTS.MGK)){
                    event.reply('console-message', str_data)
                    event.returnValue = "done"
                } else {
                    // process what comes back
                    // format: [MGK] [filename] [MGK] [parameters]
                    var split_data = str_data.split("\n")
                    console.log("test10491:" + split_data)
                    let i = 0
                    for (i = 0; i < split_data.length; i++){
                        console.log("test3949419: " + split_data[i])
                        if (split_data[i] == undefined)
                            continue
                        call_backend(ipcMain, split_data[i], event)
                    }
                    // call_backend(ipcMain, str_data, event)
                }
            })

            python_instance.stderr.removeAllListeners('data')  

            python_instance.stderr.once('data', function (data) {
                let datastr = data.toString()
                event.reply('console-message', datastr.slice(0, datastr.length - 4))
                setTimeout(() => {event.returnValue = "done"},50); // times out and allows further input
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
        cwd:path.join(__dirname)
    }
    tryPythonSpawn(ipcMain, ['-i'], options)
}

module.exports = {
    initializePythonProcess,
}