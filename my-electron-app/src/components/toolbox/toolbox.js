const CONSTANTS = require("../../constants.js")
const theme = require("../theme.js")

const diagram_div = document.getElementById("model-diagram-display")
const toolbox_div = document.getElementById("module-toolbox")
const tb_div_width = toolbox_div.clientWidth
const tb_icon_num_per_row = 3 //number of modules per row
const tb_rect_width = 80
const tb_rect_height = 100

// --------- Toolbox ---------

function createModuleIcon (ipcRenderer, type, margin, rect_width, rect_height){
    let module_type_attr = CONSTANTS.IP_database[type]
    var moduleIcon = document.createElement("div")
    moduleIcon.className = 'module-toolbox-icon'
  
    var text = document.createElement('p')
    text.style.textAlign = 'center'
    moduleIcon.appendChild(text)
  
    moduleIcon.style.width = rect_width + "px"
    moduleIcon.style.height = rect_height + "px"
    moduleIcon.style.margin = margin + "px"
  
    moduleIcon.draggable = true
    moduleIcon.ondragstart = function(ev) {
      //ev.preventDefault()
      ev.dataTransfer.setData('type_id', type)
      ev.dataTransfer.effectAllowed = 'copy'
      //remove 'ghost image' by replacing it with a transparent image
      //var img = new Image();
      //img.src = 'data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=';
      //ev.dataTransfer.setDragImage(img, 0, 0)
    }
  
    // add in module type details
    text.textContent = type
    if (CONSTANTS.NON_PERIPHERAL_COLOR in CONSTANTS.IP_database[type]){
      moduleIcon.style.backgroundColor = CONSTANTS.IP_database[type][CONSTANTS.NON_PERIPHERAL_COLOR]
    } else {
      moduleIcon.style.backgroundColor = theme.light_blue_color
    }
  
    return moduleIcon
}
  
function initToolbox (ipcRenderer){
    const margin = (tb_div_width - tb_rect_width * tb_icon_num_per_row) / (tb_icon_num_per_row) / 2

    // add a toolbar objects
    for (var type in CONSTANTS.IP_database){
        toolbox_div.appendChild(createModuleIcon(ipcRenderer, type, margin, tb_rect_width, tb_rect_height))
    }
    ipcRenderer.send('debug', "test")

    // set drag handlers
    toolbox_div.ondragover = function (ev) {
        ev.preventDefault()
        ev.dataTransfer.dropEffect = 'copy'

    }
    diagram_div.ondragover = function (ev) {
        ev.preventDefault()
        ev.dataTransfer.dropEffect = 'copy'
    }
    diagram_div.ondrop = function (ev) {
        ev.preventDefault()
        ipcRenderer.send('system-message', "module type " + ev.dataTransfer.getData('type_id') + " received, however module adding is " + 
        "not implemented in the back")
    }
}



module.exports = {
    initToolbox,
}