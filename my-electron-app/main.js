const { app } = require('electron')

const main_windows = require('./windows/main_window/main_window.js')

function init(){
  main_windows.createMainWindow()
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