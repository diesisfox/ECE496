const { Menu, dialog} = require('electron')
//const Swal = require('sweetalert2')
const prompt = require('electron-multi-prompt')

const file_manager = require('../components/file_management/file_manager.js')
const python_terminal = require('../components/python_terminal/python_terminal.js')
const window_manager = require('../components/windom_management/window_manager.js')

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

function showAboutDialog (win) {
  const options = {
    message: 'Hello. This tool is made through the hard work of Andrew Uderian, Zhonglin Huang, and James Liu.\n'
      + 'Please do not message us if you have any questions.\n'
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
    console.log("filePath: " + file_manager.openFileDialog(main_win)())
    console.log("open file clicked")
  })
  ipcMain.on('save file', function(event, arg) {
    console.log("saving file is still unimplemented")
  })
  ipcMain.on('save as file', function(event, arg) {
    console.log("filePath: " + file_manager.openSaveDialog(main_win))
  })
  // ipcMain.on('toggle module bar', function(event, arg) {
  //   console.log("adding module is not fully implemented")
  //   // Swal.fire({
  //   //   title: "Add Module",
  //   //   html:
  //   //     '<input id="mod-name" class="swal2-input">' + 
  //   //     '<input id="mod-type" class="swal2-input">' + 
  //   //     '<input id="mod-address" class="swal2-input">',
  //   //   focusConfirm: false,
  //   //   preConfirm: () => {
  //   //     console.log(document.getElementById('mod-name').value)
  //   //   }
  //   // })
  //   // prompt({
  //   //   title: 'Prompt example',
  //   //   type: 'multi-input',
  //   //   height: 300,
  //   //   alwaysOnTop: true,
  //   //   inputArray: [
  //   //     {
  //   //       key: 'name',
  //   //       label: 'label',
  //   //       value: 'init value',
  //   //       attributes: {
  //   //         placeholder: 'placeholder',
  //   //         required: true,
  //   //         type: "text"
  //   //       }
  //   //     }
  //   //   ]
  //   // }, main_win)
  //   // .then((r) => {
  //   //     if(r === null) {
  //   //         console.log('user cancelled');
  //   //     } else {
  //   //         console.log('result', r);
  //   //     }
  //   // })
  //   // .catch(console.error);
  // })
  ipcMain.on('remove module', function(event, arg) {
    console.log("removing a module is not fully implemented")
  })
  ipcMain.on('generate', function(event, arg) {
    console.log("generate is not fully implemented")
  })
  ipcMain.on('about', function(event, arg) {
    showAboutDialog(main_win)
  })
  ipcMain.on('add module', function(event, arg) {
    console.log("Received: " + arg.name + ", " + arg.type + ", " + arg.address)
    console.log("adding module not fully implemented")
  })
}

// main window creation function

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