var fs = require('fs')
const {dialog} = require('electron')


const filter_list = [
    {name: 'Custom File Type', extensions: ['as']},
    {name: 'Images', extensions: ['jpg', 'png', 'gif']},
    {name: 'All Files', extensions: ['*']}
]

fs.mkdirSync("saves", { recursive: true })

// TODO: simplify this so that it doesn't use a nested function

function openFileDialog (win){
    return function(e){

        let options = {
        title : "Choose File", 

        defaultPath : "C:\\",

        buttonLabel : "Open",

        filters : filter_list,
        properties: ['openFile']
        }

        //Synchronous
        let filePaths = dialog.showOpenDialogSync(win, options)

        return filePaths
    }
}

function openSaveDialog(win){
    let options = {
        title : "Save As", 

        defaultPath : "C:\\",

        buttonLabel : "Save",

        filters : filter_list,
        properties: ['createDirectory', 'showOverwriteConfirmation']
    }

    //Synchronous
    let filePaths = dialog.showSaveDialogSync(win, options)

    return filePaths
}

function readFile (filepath){
    try {
        var data = fs.readFileSync(filepath, 'utf8');  
    } catch(e) {
        console.log('Error:', e.stack);
    }
    return data
}

module.exports = {
    openFileDialog,
    openSaveDialog,
    readFile,
}