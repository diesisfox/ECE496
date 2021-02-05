const {ipcRenderer} = require('electron')

const CONSTANTS = require("../constants.js")
const python_terminal_renderer = require('../components/python_terminal/python_terminal_renderer.js')
const graphical_representation_renderer = require('../components/graphical_representation_backbone/graphical_representation_renderer.js')
const toolbox = require("../components/toolbox/toolbox.js")

// -------- HTML ELEMENTS --------

// left menu
const open_button = document.getElementById("open-button")
const save_button = document.getElementById("save-button")
const save_as_button = document.getElementById("save-as-button")
const add_button = document.getElementById("add-button")
const remove_button = document.getElementById("remove-button")
const generate_button = document.getElementById("generate-button")
const about_button = document.getElementById("about-button")

// button listeners
function addButtonListeners(){
    // left menu
    open_button.addEventListener('click', function() {
        ipcRenderer.send('open file', "")
    })
    save_button.addEventListener('click', function() {
        ipcRenderer.send('save file', "")
    })
    save_as_button.addEventListener('click', function() {
        ipcRenderer.send('save as file', "")
    })
    add_button.addEventListener('click', function() {
        toolbox.toggle_visibility()
    })
    remove_button.addEventListener('click', function() {
        // let cell = graphical_representation_renderer.getSelected()
        // if (cell != null && cell.isVertex()){
        //     ipcRenderer.send('remove module', cell)
        // } else {
        //     ipcRenderer.send('debug', "invalid module")
        //     ipcRenderer.send('system-message', "Invalid selection, please click on a valid module before clicking this button.")
        // }
        let is_module = false

        let focused = graphical_representation_renderer.getSelected()
        let prefix_len = CONSTANTS.MOD_ID_PREFIX.length
        if (focused != null && focused.id.length > prefix_len && focused.id.slice(0,prefix_len) == CONSTANTS.MOD_ID_PREFIX){
            ipcRenderer.send('system-message', "Tried to remove: " + focused.id)
            ipcRenderer.send('system-message', "not fully implemented")
        } else {
            ipcRenderer.send('system-message', "Invalid selection, please click on a valid module before clicking this button.")
        }
    })
    generate_button.addEventListener('click', function() {
        ipcRenderer.send('generate', "")
    })
    about_button.addEventListener('click', function() {
        ipcRenderer.send('about', "")
    })
}

// ----------- INITIALIZE --------------

function initialize(){
    addButtonListeners()
    python_terminal_renderer.init(ipcRenderer)
    graphical_representation_renderer.init(ipcRenderer)
    toolbox.initToolbox(ipcRenderer)
    //graphical_toolbox_renderer.init(ipcRenderer)
}

initialize()