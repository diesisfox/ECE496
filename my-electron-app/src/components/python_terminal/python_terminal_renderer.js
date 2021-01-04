var input_box;
var text_box;
var text_wrapper;

//Deal with console inputs and outputs. 
const addToTextBox = function(e){
    if (e.key === 'Enter'){
        if (input_box.value === 'clear'){
            text_box.textContent = ""
            input_box.value = ""
        } else {
            ipcRenderer.send('console-input-reading', input_box.value);
            text_box.textContent = text_box.textContent + "\r\n>>> " + input_box.value + "\r\n";
            input_box.value = ""
            text_wrapper.scrollTop = text_wrapper.scrollHeight
        }
    }
}


function init(ipcRenderer){

    input_box = document.getElementById("console-input")
    text_box = document.getElementById("console-text")
    text_wrapper = document.getElementById("console-text-wrapper")

    //Start console with python version displayed.
    text_box.textContent = ipcRenderer.sendSync('get-python-version', '') + 
    "\r\nType 'clear' without apostrophes to clear."

    ipcRenderer.on('console-message', (event,arg) => {
        text_box.textContent = text_box.textContent + arg
        text_wrapper.scrollTop = text_wrapper.scrollHeight
    })
    
    input_box.addEventListener('keydown', addToTextBox)
}



module.exports = {
    init,
}

