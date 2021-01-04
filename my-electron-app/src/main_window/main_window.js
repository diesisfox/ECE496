const { app, BrowserWindow, Menu, ipcMain} = require('electron')

const file_manager = require('../components/file_management/file_manager.js')
const python_terminal = require('../components/python_terminal/python_terminal.js')

// -------------- DEBUG --------------

function setupDebug () {
  ipcMain.on("debug", function(event, arg){
    console.log("debug: " + arg)
  })
}

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

// toolbar menu
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

// icon menu
function addMenuListeners(){
  ipcMain.on('open file', function (event, arg) {
    console.log("filePath: " + file_manager.openFileDialog(win)())
    console.log("open file clicked")
  })
  ipcMain.on('save file', function(event, arg) {
    console.log("saving file is still unimplemented")
  })
}
  
function createMainWindow () {
  setupDebug()

  win = createWindow()

  addMenuListeners()
  //createMenu()
  win.setMenu(null)

  python_terminal.initializePythonProcess(ipcMain)
}

module.exports = {
  createMainWindow,
}