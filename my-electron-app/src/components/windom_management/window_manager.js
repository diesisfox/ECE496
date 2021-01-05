const {BrowserWindow} = require('electron')

function createWindow (html_path, w, h, x_offset = -1, y_offset = -1) {
    let win_options = {
        width: w,
        height: h,
        show: false,
        webPreferences: {
        nodeIntegration: true
        }
    }

    // use offset if given, otherwise, center window
    if (x_offset != -1 || y_offset != -1){
        win_options.x = x_offset
        win_options.y = y_offset
    }

    const win_temp = new BrowserWindow(win_options)

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
