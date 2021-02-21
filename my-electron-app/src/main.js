const { app, ipcMain } = require('electron')

const main_windows = require('./main_window/main_window.js')
const file_manager = require('./components/file_management/file_manager.js')

function init(){
  file_manager.loadDummy()
  file_manager.initMain(ipcMain)
  file_manager.setBasePath(app.getAppPath())
  main_windows.createMainWindow(ipcMain)

  // add listeners for change, to be moved into python backend section
  ipcMain.on('module-edit', (event, data) => {
    event.reply('system-message', "received instruction to edit with " + data + ", but still unimplemented")
  })
  ipcMain.on('module-delete', (event, UUID) => {
    event.reply('system-message', "received instruction to delete with " + UUID + ", but still unimplemented")
  })
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