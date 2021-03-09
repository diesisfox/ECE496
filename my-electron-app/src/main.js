const { app, ipcMain } = require('electron')

const main_windows = require('./main_window/main_window.js')

function init(){
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