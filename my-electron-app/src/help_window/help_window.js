
const window_manager = require('../components/windom_management/window_manager.js')

let help_win = null

// DEPRECATED

function createHelpWindow (ipcMain) {
  help_win = window_manager.createWindow('./src/help_window/help_window.html', 800, 600, 20, 20)

  help_win.setMenu(null)

}


module.exports = {
    createHelpWindow,
}