const { Menu} = require('electron')

const file_manager = require('../components/file_management/file_manager.js')
const python_terminal = require('../components/python_terminal/python_terminal.js')
const window_manager = require('../components/windom_management/window_manager.js')
const help_window = require('../help_window/help_window.js')

// -------------- DEBUG --------------

function setupDebug (ipcMain) {
  ipcMain.on("debug", function(event, arg){
    console.log("debug: " + arg)
  })
}

// -------------- WINDOW --------------

let main_win = null;

// toolbar menu DEPRECATED
function createMenu () {
  //Create Menu
  const menuTemplate = [
    {
      label: 'File',
      submenu: [
        {
          label: 'Open',
          click: file_manager.openFileDialog(main_win)
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
function addMenuListeners(ipcMain){
  ipcMain.on('open file', function (event, arg) {
    console.log("filePath: " + file_manager.openFileDialog(main_win)())
    console.log("open file clicked")
  })
  ipcMain.on('save file', function(event, arg) {
    console.log("saving file is still unimplemented")
  })
  ipcMain.on('about', function(event, arg) {
    help_window.createHelpWindow(ipcMain)
  })
}
  
function createMainWindow (ipcMain) {
  setupDebug(ipcMain)

  main_win = window_manager.createWindow('./src/main_window/main_window.html', 800, 600)

  addMenuListeners(ipcMain)
  //createMenu()
  main_win.setMenu(null)

  python_terminal.initializePythonProcess(ipcMain)
}



module.exports = {
  createMainWindow,
}