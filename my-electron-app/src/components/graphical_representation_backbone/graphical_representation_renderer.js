const toolbox = require("../toolbox/toolbox.js")
const theme = require("../theme.js")

const diagram_div = document.getElementById("model-diagram-display")
const rect_width = 80
const rect_height = 30
let model = null
let graph = null
let panningHandler = null

let totalNum = 1



// --------- Display Methods ---------

// unfinished, needs JSON schema for completion
function displayJSON(json){
    let i = 0
    for (i = 0; i < totalNum; i++){
        var module = document.createElement("div")
        module.className = 'module-box-main'

        module.style.backgroundColor = theme.light_blue_color

        diagram_div.appendChild(module)
    }


}

// ------------ Handlers ------------


// ------------ Initialization Code ------------
function init (ipcRenderer) {

    toolbox.initToolbox(ipcRenderer)

  //displayTests()
  //wipeGraphicalDisplay()
    displayJSON("blab")
}







module.exports = {
  displayJSON,
  init,
}