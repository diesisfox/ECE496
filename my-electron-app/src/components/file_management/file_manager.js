var fs = require('fs')
const C = require("../../constants.js")
const {dialog} = require('electron')
const path = require('path');

// -------------- CONSTANTS & GLOBALS -------------
// const dummy_save_path = path.join(__dirname, '..', 'graphical_representation_backbone', 'dummy.json')
const dummy_save_path = path.join(__dirname, '..', '..', '..', "resources", 'example-project.json')
const filter_list = [
    {name: '', extensions: ['json']}, // system description json
    {name: 'All Files', extensions: ['*']}
]

// app path
var base_path = false

// save state
var save_json = false // dictionary
var save_file_path = false

// -------------- INIT -----------------
function initMain(ipcMain){
    fs.mkdirSync("saves", { recursive: true })
    ipcMain.on('get-save', (event, data) => {
        event.returnValue = getSave()
    })
}

// -------------- MAIN METHODS ----------------

// TODO: simplify these two so that it doesn't use a nested function
function openFileDialog (win){
    return function(e){

        let options = {
        title : "Choose File", 

        defaultPath : path.join(base_path, 'saves'),

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

        defaultPath : path.join(base_path, 'saves'),

        buttonLabel : "Save",

        filters : filter_list,
        properties: ['createDirectory', 'showOverwriteConfirmation']
    }

    //Synchronous
    let filePaths = dialog.showSaveDialogSync(win, options)

    return filePaths
}

function loadSave(filepath, dummy = false){
    let data = readJSONFile(filepath)
    if (data != false){
        save_json = readJSONFile(filepath)

        //save path if not dummy
        if (dummy){
            save_file_path = false
        } else {
            save_file_path = filepath
        }
        return true
    } else {
        return false
    }
}

function saveSave(){
    if (save_file_path != false){
        writeJSONToFile(save_file_path, save_json)
        return true
    } else {
        console.log("Error: either save is dummy, or no save loaded")
        return false
    }
}
  
function loadDummy(){
    return loadSave(dummy_save_path, true)
}

function getSave(){
    return save_json
}

function updateSave(new_json_str){
    save_json = JSON.parse(new_json_str)
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

// TODO: probably unneeded
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
        return data
    } catch(e) {
        console.log('Error:', e.stack);
    }
    return false
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
    saveSave,
    getSave,
    updateSave,
    getModuleDict,
}