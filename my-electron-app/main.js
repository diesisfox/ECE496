const { app, BrowserWindow, Menu } = require('electron')

function createWindow () {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true
    }
  })

  win.loadFile('index.html')
  //win.webContents.openDevTools()
  
  return win
}

function openFileDialog (win){
  return function(e){

    const {dialog} = require('electron')

    let options = {
      title : "Choose File", 

      defaultPath : "C:\\",

      buttonLabel : "Open",

      filters :[
        {name: 'Custom File Type', extensions: ['as']},
        {name: 'Images', extensions: ['jpg', 'png', 'gif']},
        {name: 'All Files', extensions: ['*']}
      ],
      properties: ['openFile','multiSelections']
    }

    //Synchronous
    let filePaths = dialog.showOpenDialogSync(win, options)
    console.log(filePaths)

     
  }
}

function createMainWindow () {
  let win = createWindow()

  

  //Create Menu
  const menuTemplate = [
    {
      label: 'File',
      submenu: [
        {
          label: 'Open',
          click: openFileDialog(win)
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

app.whenReady().then(createMainWindow)

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow()
  }
})