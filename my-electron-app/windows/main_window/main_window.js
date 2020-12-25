const { app, BrowserWindow, Menu, ipcMain} = require('electron')

const {PythonShell} = require('python-shell')

const file_manager = require('../file_management/file_manager')

let win = null;

function createWindow () {
  const win_temp = new BrowserWindow({
    width: 800,
    height: 600,
    show: false,
    webPreferences: {
      nodeIntegration: true
    }
  })
  
  // Root is CAPSTONE/my-electron-app for some reason
  win_temp.loadFile('./windows/main_window/main_window.html')

  win_temp.setResizable(false);

  win_temp.once('ready-to-show', () => {
      win_temp.show()
  })

  //win.webContents.openDevTools()
  win_temp.on('closed', () => {
      win = null;
  });
  
  return win_temp
}

function createMenu () {
  //Create Menu
  const menuTemplate = [
    {
      label: 'File',
      submenu: [
        {
          label: 'Open',
          click: file_manager.openFileDialog(win)
        },
        {
          label: 'Save'
        }
      ]
    },
    {
      label: 'Edit',
      submenu: [
        { role: 'undo' },
        { role: 'redo' }
      ]
    }
  ]

  const menu = Menu.buildFromTemplate(menuTemplate)
  Menu.setApplicationMenu(menu)
}
  
function createMainWindow () {
  win = createWindow()

  createMenu();
}

// -------------- PYTHON SHELL --------------

ipcMain.on('get-python-version', (event,arg)=>{
  const version = PythonShell.getVersionSync()
  event.returnValue = version
})

/*
Idea: write python script with code that imports all required libraries and etc. 
Write controller script.
Create a temp copy of it and append user code. 
Reload the temp copy in the controller script and create pipe between two scripts, run the user function. 
Pass new state of systems to controller to do whatever with. 
 */
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

  
module.exports = {
  createMainWindow,
}