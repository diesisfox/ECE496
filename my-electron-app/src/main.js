const { app, ipcMain } = require('electron')

const main_windows = require('./main_window/main_window.js')
const file_manager = require('./components/file_management/file_manager.js')

function init(){
  main_windows.createMainWindow(ipcMain)

  // load in dummy save
  file_manager.loadDummy()
  //console.log('test', file_manager.getSave().length)
  //main_windows.sendDisplayJSONCommd()
  //ipcMain.once('get')
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