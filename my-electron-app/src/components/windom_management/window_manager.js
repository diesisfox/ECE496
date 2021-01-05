const {BrowserWindow} = require('electron')

function createWindow (html_path, w, h) {
    const win_temp = new BrowserWindow({
        width: w,
        height: h,
        show: false,
        webPreferences: {
        nodeIntegration: true
        }
    })

    // Root is CAPSTONE/my-electron-app for some reason
    win_temp.loadFile(html_path)

    win_temp.setResizable(false);

    win_temp.once('ready-to-show', () => {
        win_temp.show()
    })

    //win.webContents.openDevTools()
    win_temp.on('closed', () => {
        main_win = null;
    });

    return win_temp
}


module.exports = {
    createWindow,
}
