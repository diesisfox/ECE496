// --------- Constants ----------
const C = require("../../constants.js")
const theme = require("../theme.js")

const diagram_div = document.getElementById("model-diagram-display")
const toolbox_div = document.getElementById("module-toolbox")
const edit_module_box_div = document.getElementById("edit-module-box")

// edit module box
//const edit_module_button = document.getElementById("edit-module-button")
//const edit_module_name = document.getElementById("edit-module-name")
//const edit_module_type = document.getElementById("edit-module-type")
//const edit_module_address = document.getElementById("edit-module-address")
const emb_num_per_row = 2
const emb_rect_width = 110
const emb_rect_height = 20

// toolbox icons
const tb_icon_num_per_row = 4 //number of modules per row
const tb_rect_width = 80
const tb_rect_height = 100

// animation vars
const anim_speed = 400 // in ms
const offscreen_offset = 10 
const tb_offscreen_offset = ((toolbox_div.offsetHeight + offscreen_offset) * -1) + "px"
const bar_offscreen_offset = ((edit_module_box_div.offsetHeight + offscreen_offset) * -1) + "px"
const onscreen_offset = 5
const all_onscreen_offset = onscreen_offset + "px"

// --------- Global Vars ---------
let toolbox_shown = false;
let edit_box_shown = false;

// --------- Toolbox ---------

function createModuleIcon (ipcRenderer, type, margin, rect_width, rect_height){
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
    if (C.NON_PERIPHERAL_COLOR in C.IP_database[type]){
      moduleIcon.style.backgroundColor = C.IP_database[type][C.NON_PERIPHERAL_COLOR]
    } else {
      moduleIcon.style.backgroundColor = theme.light_blue_color
    }
  
    return moduleIcon
}

function createEditInput (ipcRenderer, field_name, saved_value, margin, rect_width, rect_height){
    var input_field = document.createElement("input")
    input_field.className = 'edit-module-input'
    input_field.style.width = rect_width + "px"
    input_field.style.height = rect_height + "px"
    input_field.style.marginLeft = margin + "px"
    //input_field.style.marginRight = margin + "px"
    input_field.placeholder = field_name
    input_field.value = saved_value
  
    return input_field
}

// initialize
function initToolbox (ipcRenderer){
    const margin = (toolbox_div.clientWidth - tb_rect_width * tb_icon_num_per_row) / (tb_icon_num_per_row) / 2

    // add a toolbar objects
    for (var type in C.IP_database){
        toolbox_div.appendChild(createModuleIcon(ipcRenderer, type, margin, tb_rect_width, tb_rect_height))
    }

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

    
    ipcRenderer.on('edit-box-change', (event, module_json) => {
        setEditBox(ipcRenderer, module_json)
    })
}

function setEditBox (ipcRenderer, module_json){
    const margin = (edit_module_box_div.clientWidth - emb_rect_width * emb_num_per_row) / (emb_num_per_row) / 2

    let module_type = module_json[C.MODULE_TYPE]

    ipcRenderer.send('debug', C.IP_database[module_type][C.PARAMETERS])

    // clear existing objects
    while (edit_module_box_div.firstChild) {
        edit_module_box_div.removeChild(edit_module_box_div.lastChild);
    }

    // add a toolbar objects
    let params = C.IP_database[module_type][C.PARAMETERS]
    for (let i = 0; i < params.length; i++){
        ipcRenderer.send('debug', params[i])
        // check for existence of key
        if (!(C.PARAMNAME in params[i]) || !(C.PARAMTYPE in params[i])){
            ipcRenderer.send('debug', 'ERROR: IP_database entry not complete for type ' + module_type)
            break
        }
        // look for same parameter in module
        if (!(params[i][C.PARAMNAME] in module_json[C.PARAMETERS])){
            ipcRenderer.send('debug', "ERROR: module entry in save not complete for type " + module_type)
            break
        }
        let val = module_json[C.PARAMETERS][params[i][C.PARAMNAME]]
        
        edit_module_box_div.appendChild(createEditInput(ipcRenderer, params[i][C.PARAMNAME], val, margin, emb_rect_width, emb_rect_height))
    }

    toggle_edit_module_box_visibility(true)
}

function toggle_toolbox_visibility () {
    // if shown, then unshow
    if (toolbox_shown){ 
        animation = toolbox_div.animate({top: tb_offscreen_offset}, anim_speed)
        animation.onfinish = function() {
            toolbox_div.style.top = tb_offscreen_offset
        }

        toolbox_shown = !toolbox_shown
    }
    // if unshown, then show
    else {
        animation = toolbox_div.animate({top: all_onscreen_offset}, anim_speed)
        animation.onfinish = function() {
            toolbox_div.style.top = all_onscreen_offset
        }

        toolbox_shown = !toolbox_shown
    }
}

function toggle_edit_module_box_visibility (val) {
    if (val != undefined){
        edit_box_shown = !val // flips the target state, since the following if statement expect the opposite
    }

    // if shown, then unshow
    if (edit_box_shown){ 
        let animation = edit_module_box_div.animate({top: bar_offscreen_offset}, anim_speed)
        animation.onfinish = function() {
            edit_module_box_div.style.top = bar_offscreen_offset
        }

        edit_box_shown = !edit_box_shown
    }
    // if unshown, then show
    else {
        let animation = edit_module_box_div.animate({top: all_onscreen_offset}, anim_speed)
        animation.onfinish = function() {
            edit_module_box_div.style.top = all_onscreen_offset
        }

        edit_box_shown = !edit_box_shown
    }
}



module.exports = {
    initToolbox,
    setEditBox,
    toggle_toolbox_visibility,
    toggle_edit_module_box_visibility,
}