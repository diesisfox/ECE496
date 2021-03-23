const child_process = require('child_process')
const file_manager = require('../file_management/file_manager.js')
const path = require('path');
const CONSTANTS = require("../../constants.js");
//const { ipcRenderer } = require('electron');

var python_instance = null;

// for call_backend
var stderr_data = undefined
var stdout_data = undefined

// TODO: delete, unused
function sanitize_str(string){
    for (let i = 0; i < string.length;i++){
        if (string[i] == '\n'){
            string = string.substring(0,i) + "\\n" + string.substring(i+1)
        } else if (string[i] == '\"'){
            string = string.substring(0,i) + "\\\"" + string.substring(i+1)
        }
    }

    return string
}

function process_backend_output(ipcMain){
    if (stderr_data != undefined && stdout_data != undefined){
        console.log("time to process the data!")
    } else {
        console.log("waiting!")
    }
}

function call_backend(ipcMain, str_data, event){
    let data_array = str_data.split(CONSTANTS.MGK)
    
    let filepath =  path.join(__dirname, "..", "..", "..", "resources", "generator", data_array[1])
    
    console.log(filepath)

    // find verilog function arguments
    let arg_arr = []
    arg_arr.push(filepath)
    arg_arr.push(JSON.stringify(file_manager.getSave()))
    for (let i = 2; i < data_array.length; i++){
        arg_arr.push(data_array[i])
    }

    //console.log(arg_arr[])

    // run backend python
    let process = child_process.spawn('python', arg_arr)

    stderr_data = undefined
    stdout_data = undefined

    // set listener for stdout and stderr
    process.stderr.once('data', (data) => {
        console.log("Error from child_process: " + data.toString())
        stderr_data = data
    })
    
    process.stdout.once('data', (data) => {
        console.log("received data: " + data.toString())
        stdout_data = data

        let str_data_process = data.toString()

        let data_array_process = str_data_process.split(CONSTANTS.MGK)

        if (data_array_process.length > 2 && data_array_process[1].localeCompare("SUCCESS") == 0){
            file_manager.updateSave(data.toString())
        } else {
            event.reply('console-message', str_data_process)
        }
    })

    process.once('close', (data) => {
        console.log("called: " + data.toString())
        process_backend_output(ipcMain)
    })

    // process.stderr.once('close', (data) => {
    //     console.log("closed: " + data.toString())
    //     if (stderr_data == undefined){
    //         stderr_data = 0
    //     }
    //     process_backend_output(ipcMain)
    // })

    // process.stdout.once('close', (data) => {
    //     console.log("closed: " + data.toString())
    //     if (stdout_data == undefined){
    //         stderr_data = 0
    //     }
    //     process_backend_output(ipcMain)
    // })
}

function initializePythonProcess (ipcMain) {
    var initial_output = ""

    // initialize python process
    python_instance = child_process.spawn('python', ['-i'])

    // use python_init.py to initialize it
    var init_file_content = file_manager.readFile(path.join(__dirname, "python_init.py"))

    python_instance.stdout.once('data', (data)=>{
        initial_output = data.toString()
        
        python_instance.stdin.write(__dirname + "\n")
        // python_instance.stdout.once('data', (data)=>{
        //     initial_output += data.toString()
        //     console.log("received")
        // })
    })
    
    //throw away first message
    python_instance.stderr.once('data', function (data) {/*do nothing*/})

    python_instance.stdin.write(init_file_content + "\n")    

    // show initial output of python initialization
    ipcMain.on('get-python-version', (event,arg)=>{
        event.returnValue = initial_output
    })

    ipcMain.on('console-input-reading', (event,arg) => {
        python_instance.stdout.removeAllListeners('data')
        
        // deal with data that comes back
        python_instance.stdout.once('data', function (data) {
            let str_data = data.toString().slice(1, data.toString().length - 3)
            
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
}

module.exports = {
    initializePythonProcess,
}