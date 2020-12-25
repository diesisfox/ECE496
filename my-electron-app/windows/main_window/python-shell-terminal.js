const {ipcRenderer} = require('electron')

var input_box = document.getElementById("console-input")
var text_box = document.getElementById("console-text")

const addToTextBox = function(e){
    if (e.key === 'Enter'){
        ipcRenderer.send('console-message', input_box.value);
        text_box.textContent = text_box.textContent + "\r\n>>> " + input_box.value;
        input_box.value = ""
    }
}

input_box.addEventListener('keydown', addToTextBox)