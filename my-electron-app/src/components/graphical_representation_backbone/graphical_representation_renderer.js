const toolbox = require("../toolbox/toolbox.js")
const theme = require("../theme.js")
const CONSTANTS = require("../../constants.js")

const ns = "http://www.w3.org/2000/svg"
const diagram_div = document.getElementById("model-diagram-display")
const rect_width = 80
const rect_height = 30
let model = null
let graph = null
let panningHandler = null

let totalNum = 1



// --------- Display Methods ---------

function createHtmlModuleRep (){
  var wrapper = document.createElement('div')
  wrapper.style.width = rect_width
  wrapper.style.height = rect_height+10
  diagram_div.appendChild(wrapper)

  var text = document.createElement('p')
  text.style.textAlign = 'center'
  text.textContent = '||'
  wrapper.appendChild(text)

  var module = document.createElement('div')
  module.className = 'module-box-main'
  module.style.width = rect_width
  module.style.height = rect_height
  wrapper.appendChild(module)

  module.style.backgroundColor = theme.light_blue_color
}

function createSVGModuleRep (ipcRenderer) {
  
  let svg_diagram = document.createElementNS(ns, "svg")
  svg_diagram.setAttributeNS(null, "width", '100%')
  svg_diagram.setAttributeNS(null, "height", '100%')
  svg_diagram.style.backgroundColor = theme.light_blue_color
  diagram_div.appendChild(svg_diagram)

  let i = 0
  for (i = 0; i < totalNum; i++){
    ipcRenderer.send('debug', '1')
    let element = document.createElementNS(ns, 'rect')
    element.setAttribute("x",100);
    element.setAttribute("y",100);
    element.setAttribute("width",100);
    element.setAttribute("height",100);
    element.setAttribute("fill",'yellow');
    element.style.backgroundColor = 'white'
    svg_diagram.appendChild(element)
    ipcRenderer.send('debug', '2')
  }
}

// unfinished, needs JSON schema for completion
function displayJSON(ipcRenderer,json){
  createSVGModuleRep(ipcRenderer)


}

// ------------ Handlers ------------


// ------------ Initialization Code ------------
function init (ipcRenderer) {

    toolbox.initToolbox(ipcRenderer)

  //displayTests()
  //wipeGraphicalDisplay()
    displayJSON(ipcRenderer, "blab")

    ipcRenderer.send('debug', 'finished')
}







module.exports = {
  displayJSON,
  init,
}