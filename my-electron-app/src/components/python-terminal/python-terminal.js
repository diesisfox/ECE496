
const {PythonShell} = require('python-shell')


function addPythonHandlers (ipcMain) {
    ipcMain.on('get-python-version', (event,arg)=>{
        const version = PythonShell.getVersionSync()
        event.returnValue = version
    })
    ipcMain.on('console-input-reading', (event,arg) => {
        let python_instance = PythonShell.runString(arg, null, function (err) {
            if (err) {
                console.log(err)
                event.reply('console-message', err)
            }
        })
        python_instance.on('message', function (message) {
            event.reply('console-message', message)
        })
    })
}

/*
Idea: write python script with code that imports all required libraries and etc. 
Write controller script.
Create a temp copy of it and append user code. 
Reload the temp copy in the controller script and create pipe between two scripts, run the user function. 
Pass new state of systems to controller to do whatever with. 
*/
function initializePythonProcess (ipcMain) {
    addPythonHandlers(ipcMain)
}

module.exports = {
    initializePythonProcess,
}