const { app, ipcMain } = require('electron')

const main_windows = require('./main_window/main_window.js')
const file_manager = require('./components/file_management/file_manager.js')

function init(){
  
  file_manager.setBasePath(app.getAppPath())

  file_manager.initMain(ipcMain)
  main_windows.createMainWindow(ipcMain)
  
}

app.whenReady().then(init)

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    init()
  }
})