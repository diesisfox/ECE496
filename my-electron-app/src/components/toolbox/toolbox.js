const file_manager = require('../file_management/file_manager.js')

function initEditBoxMain (ipcMain) {
    ipcMain.on('selected-module-changed', (event, id) => {
        event.reply('edit-box-change', file_manager.getModuleDict(id))
    })
}

module.exports = {
    initEditBoxMain,
}