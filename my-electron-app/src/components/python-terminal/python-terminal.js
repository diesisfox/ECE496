const {PythonShell} = require('python-shell')
const child_process = require('child_process')

var python_instance = null;

/*
Idea: write python script with code that imports all required libraries and etc. 
Write controller script.
Create a temp copy of it and append user code. 
Reload the temp copy in the controller script and create pipe between two scripts, run the user function. 
Pass new state of systems to controller to do whatever with. 
*/
function initializePythonProcess (ipcMain) {
    python_instance = child_process.spawn('python', ['-i'])
    python_instance.stdin.write("print(\"test\")\n")
    python_instance.stdout.once('data', (data)=>{
        console.log(data.toString())
    })

    ipcMain.on('get-python-version', (event,arg)=>{
        const version = PythonShell.getVersionSync()
        event.returnValue = version
    })
    ipcMain.on('console-input-reading', (event,arg) => {
        python_instance.stdin.write(arg+"\n")

        python_instance.stdout.once('data', function (data) {
            event.reply('console-message', data.toString())
        })
    })
}

module.exports = {
    initializePythonProcess,
}