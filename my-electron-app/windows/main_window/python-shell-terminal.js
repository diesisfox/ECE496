const {ipcRenderer} = require('electron')

var input_box = document.getElementById("console-input")
var text_box = document.getElementById("console-text")

text_box.textContent = ipcRenderer.sendSync('get-python-version', '')

const addToTextBox = function(e){
    if (e.key === 'Enter'){
        ipcRenderer.send('console-input-reading', input_box.value);
        text_box.textContent = text_box.textContent + "\r\n>>> " + input_box.value;
        input_box.value = ""
    }
}

ipcRenderer.on('console-message', (event,arg) => {
    text_box.textContent = text_box.textContent + "\r\n" + arg
})

input_box.addEventListener('keydown', addToTextBox)