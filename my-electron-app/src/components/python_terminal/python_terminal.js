const child_process = require('child_process')
const file_manager = require('../file_management/file_manager.js')

var python_instance = null;

function initializePythonProcess (ipcMain) {
    var initial_output = ""

    python_instance = child_process.spawn('python', ['-i'])
    var init_file_content = file_manager.readFile("./src/components/python_terminal/python_init.py")
    python_instance.stdin.write(init_file_content + "\n")
    python_instance.stdout.once('data', (data)=>{
        initial_output = data.toString()
    })

    //throw away first message
    python_instance.stderr.once('data', function (data) {/*do nothing*/})

    ipcMain.on('get-python-version', (event,arg)=>{
        event.returnValue = initial_output
    })
    ipcMain.on('console-input-reading', (event,arg) => {
        python_instance.stdin.write(arg+"\n")

        python_instance.stdout.removeAllListeners('data')

        python_instance.stdout.once('data', function (data) {
            event.reply('console-message', data.toString())
        })

        python_instance.stderr.removeAllListeners('data')  

        python_instance.stderr.once('data', function (data) {
            let datastr = data.toString()
            event.reply('console-message', datastr.slice(0, datastr.length - 4))
        })

    })
    ipcMain.on('system-message', (event,arg) => {
        event.reply('console-message', "\n[System]: " + arg)
    })
}

module.exports = {
    initializePythonProcess,
}