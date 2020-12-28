const { app, BrowserWindow, Menu, ipcMain} = require('electron')

const file_manager = require('../components/file_management/file_manager.js')
const python_terminal = require('../components/python-terminal/python-terminal.js')

// -------------- WINDOW --------------

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
  win_temp.loadFile('./src/main_window/main_window.html')

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

  createMenu()

  python_terminal.initializePythonProcess(ipcMain)
}

module.exports = {
  createMainWindow,
}