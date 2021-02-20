var fs = require('fs')
const C = require("../../constants.js")
const {dialog} = require('electron')

// -------------- CONSTANTS & GLOBALS -------------
const dummy_save_path = './src/components/graphical_representation_backbone/dummy.json'
const filter_list = [
    {name: '', extensions: ['sdj']}, // system description json
    {name: 'All Files', extensions: ['*']}
]

var base_path = false
var save_json = false

// -------------- INIT -----------------
function initMain(ipcMain){
    ipcMain.on('get-save', (event, data) => {
        event.returnValue = getSave()
    })
}
fs.mkdirSync("saves", { recursive: true })

// -------------- MAIN METHODS ----------------

// TODO: simplify these two so that it doesn't use a nested function
function openFileDialog (win){
    return function(e){

        let options = {
        title : "Choose File", 

        defaultPath : base_path + '\\saves',

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

        defaultPath : base_path + '\\saves',

        buttonLabel : "Save",

        filters : filter_list,
        properties: ['createDirectory', 'showOverwriteConfirmation']
    }

    //Synchronous
    let filePaths = dialog.showSaveDialogSync(win, options)

    return filePaths
}

function loadSave(filepath){
    save_json = readJSONFile(filepath)
}
  
function loadDummy(){
    loadSave(dummy_save_path)
}

function getSave(){
    return save_json
}

function getModuleDict(id) {
    if (save_json == false){
        return false
    } 

    let i
    for (i = 0; i < save_json.length; i++){
        if (save_json[i][C.UUID] == id){
            break
        }
    }
    if (i != save_json.length){
        return save_json[i]
    } else {
        return false
    }
}

// --------------- HELPER FUNCTIONS ----------------

function setBasePath (path){
    if (base_path != false){
        console.log('Error: base path set a second time')
    } else {
        base_path = path
    }
}

function readFile (filepath){
    try {
        var data = fs.readFileSync(filepath, 'utf8');  
    } catch(e) {
        console.log('Error:', e.stack);
    }
    return data
}

function readJSONFile (filepath){
    try {
        var data = fs.readFileSync(filepath, 'utf8');  
        data = JSON.parse(data)
    } catch(e) {
        console.log('Error:', e.stack);
    }
    return data
}

function writeFile (filepath, output){
    try {
        fs.writeFileSync(filepath, output);  
        return true
    } catch(e) {
        console.log('Error:', e.stack);
    }
    return false
}

function writeJSONToFile (filepath, output){
    try {
        let data = JSON.stringify(output)
        fs.writeFileSync(filepath, data);  
        return true
    } catch(e) {
        console.log('Error:', e.stack);
    }
    return false
}

module.exports = {
    initMain,
    setBasePath,
    openFileDialog,
    openSaveDialog,
    readFile,
    readJSONFile,
    writeFile,
    writeJSONToFile,
    loadDummy,
    loadSave,
    getSave,
    getModuleDict,
}