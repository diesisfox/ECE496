var fs = require('fs');

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
    readFile,
}