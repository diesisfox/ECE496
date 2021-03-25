const { Menu, dialog} = require('electron')
const prompt = require('electron-multi-prompt')

const file_manager = require('../components/file_management/file_manager.js')
const python_terminal = require('../components/python_terminal/python_terminal.js')
const toolbox = require("../components/toolbox/toolbox.js")
const window_manager = require('../components/windom_management/window_manager.js')

//const main_renderer = require('./main_renderer.js')

// -------------- GLOBAL VARIABLES -------------

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

function sendDisplayJSONCommd(){
  main_win.webContents.send('displayJSON', file_manager.getSave())
}

function showAboutDialog (win) {
  const options = {
    message: 'Hello. This tool is made through the hard work of Andrew Uderian, Zhonglin Huang, and James Liu.\n'
      + 'Feel free to NOT message us if you have any questions.\n'
      + '\nThis application uses images from Icons8. Link: https://icons8.com',
    title: "About",
    type: 'none'
  }

  const response = dialog.showMessageBox(win, options)
}

// icon menu
// TODO: incomplete
function addMenuListeners(ipcMain){
  ipcMain.on('open file', function (event, arg) {
    let filepath = file_manager.openFileDialog(main_win)()
    if (filepath != undefined){
      filepath = filepath.join("")
      console.log("filePath: " + filepath)
      console.log("open file clicked")
      file_manager.loadSave(filepath)
      event.reply('update-renderer', file_manager.getSave())
    }
  })
  ipcMain.on('new file', function (event, arg) {
    let filepath = file_manager.openNewDialog(main_win)
    if (filepath != undefined){
      console.log("filePath: " + filepath)
      console.log("new file clicked")
      file_manager.updateSave("[]")
      file_manager.changeSavePath(filepath)
      if (file_manager.writeJSONToFile(filepath, file_manager.getSave())){
        event.reply('system-message', "attempted to save as: successful")
      } else {
        event.reply('system-message', "attempted to save as: failed")
      }
      event.reply('update-renderer', file_manager.getSave())
    }
  })
  ipcMain.on('save file', function(event, arg) {
    event.reply('system-message', "attempted to save")
    if (file_manager.saveSave()){
      event.reply('system-message', "attempted to save: successful")
    } else {
      event.reply('system-message', "attempted to save: failed")
    }
  })
  ipcMain.on('save as file', function(event, arg) {
    let filepath = file_manager.openSaveDialog(main_win)
    if (filepath != undefined){
      console.log("filePath: " + filepath)
      if (file_manager.writeJSONToFile(filepath, file_manager.getSave())){
        file_manager.changeSavePath(filepath)
        event.reply('system-message', "attempted to save as: successful")
      } else {
        event.reply('system-message', "attempted to save as: failed")
      }
    }
  })
  // ipcMain.on('remove module', function(event, arg) {
  //   console.log("attempting to remove cell: " + arg + ", name: " + arg.value + ", uid: " + arg.uid)
  //   event.reply('system-message', "removing a module is not fully implemented")
  // })
  // ipcMain.on('generate', function(event, arg) {
  //   event.reply('system-message', "generate is not fully implemented")
  // })
  ipcMain.on('about', function(event, arg) {
    showAboutDialog(main_win)
  })
  // ipcMain.on('add module', function(event, arg) {
  //   event.reply('system-message', "Received: " + arg.name + ", " + arg.type + ", " + arg.address)
  //   event.reply('system-message', "adding module not fully implemented")
  // })
}

// main window creation function

function createMainWindow (ipcMain) {
  setupDebug(ipcMain)

  main_win = window_manager.createWindow('./src/main_window/main_window.html', 800, 600)

  addMenuListeners(ipcMain)
  main_win.setMenu(null)

  python_terminal.initializePythonProcess(ipcMain)

  toolbox.initEditBoxMain(ipcMain)

  ipcMain.on('system-message', (event,arg) => {
    event.reply('system-message', arg)
  })
}



module.exports = {
  createMainWindow,
  sendDisplayJSONCommd,
}