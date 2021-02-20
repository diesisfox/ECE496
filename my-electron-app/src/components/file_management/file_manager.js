var fs = require('fs')
const {dialog} = require('electron')

// -------------- CONSTANTS & GLOBALS -------------

const dummy_save_path = './src/components/graphical_representation_backbone/dummy.json'
const filter_list = [
    {name: 'Custom File Type', extensions: ['as']},
    {name: 'Images', extensions: ['jpg', 'png', 'gif']},
    {name: 'All Files', extensions: ['*']}
]

var save_json = false

// -------------- INIT -----------------

fs.mkdirSync("saves", { recursive: true })

// -------------- MAIN METHODS ----------------

// TODO: simplify these two so that it doesn't use a nested function
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

function loadSave(filepath){
    save_json = readJSONFile(filepath)
}
  
function loadDummy(){
    loadSave(dummy_save_path)
}

function getSave(){
    return save_json
}

// --------------- HELPER FUNCTIONS ----------------

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
    openFileDialog,
    openSaveDialog,
    readFile,
    readJSONFile,
    writeFile,
    writeJSONToFile,
    loadDummy,
    loadSave,
    getSave,
}