// --------- Constants ----------
const CONSTANTS = require("../../constants.js")
const theme = require("../theme.js")

const diagram_div = document.getElementById("model-diagram-display")
const toolbox_div = document.getElementById("module-toolbox")

// add module bar
const add_module_bar = document.getElementById("add-module-bar")
const add_module_button = document.getElementById("add-module-button")
const add_module_name = document.getElementById("add-module-name")
const add_module_type = document.getElementById("add-module-type")
const add_module_address = document.getElementById("add-module-address")

// toolbox icons
const tb_icon_num_per_row = 3 //number of modules per row
const tb_rect_width = 80
const tb_rect_height = 100

// animation vars
const anim_speed = 400 // in ms
const offscreen_offset = 10 
const tb_offscreen_offset = ((toolbox_div.offsetHeight + offscreen_offset) * -1) + "px"
const bar_offscreen_offset = ((add_module_bar.offsetHeight + offscreen_offset) * -1) + "px"
const onscreen_offset = 5
const all_onscreen_offset = onscreen_offset + "px"

// --------- Global Vars ---------
let shown = false;

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
    const margin = (toolbox_div.clientWidth - tb_rect_width * tb_icon_num_per_row) / (tb_icon_num_per_row) / 2

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

    // edit module bar
    add_module_button.addEventListener('click', function() {
        ipcRenderer.send('add module', {
            name: add_module_name.value,
            type: add_module_type.value,
            address: add_module_address.value
        })
    })
}

function toggle_visibility () {
    // if shown, then unshow
    if (shown){ 
        let animation = add_module_bar.animate({top: bar_offscreen_offset}, anim_speed)
        animation.onfinish = function() {
            add_module_bar.style.top = bar_offscreen_offset
        }
        animation = toolbox_div.animate({top: tb_offscreen_offset}, anim_speed)
        animation.onfinish = function() {
            toolbox_div.style.top = tb_offscreen_offset
        }

        shown = !shown
    }
    // if unshown, then show
    else {
        let animation = add_module_bar.animate({top: all_onscreen_offset}, anim_speed)
        animation.onfinish = function() {
            add_module_bar.style.top = all_onscreen_offset
        }
        animation = toolbox_div.animate({top: all_onscreen_offset}, anim_speed)
        animation.onfinish = function() {
            toolbox_div.style.top = all_onscreen_offset
        }

        shown = !shown
    }
}



module.exports = {
    initToolbox,
    toggle_visibility,
}