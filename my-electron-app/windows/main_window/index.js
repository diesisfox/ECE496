const { app, BrowserWindow, Menu, ipcMain} = require('electron')

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
    win_temp.loadFile('./windows/main_window/index.html')

    win_temp.once('ready-to-show', () => {
        win_temp.show()
    })

    //win.webContents.openDevTools()
    win_temp.on('closed', () => {
        win = null;
    });
    
    return win_temp
  }
  
  function createMainWindow () {
    win = createWindow()
  
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
  
  module.exports = {
      createMainWindow,
  }