const {ipcRenderer} = require('electron')

const CONSTANTS = require("../constants.js")
const python_terminal_renderer = require('../components/python_terminal/python_terminal_renderer.js')
const gra_rep_renderer = require('../components/graphical_representation_backbone/graphical_representation_renderer.js')
const toolbox = require("../components/toolbox/toolbox.js")
const file_manager = require('../components/file_management/file_manager.js')

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
        toolbox.toggle_toolbox_visibility()
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

        let focused = gra_rep_renderer.getSelected()
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

// ----------- MAIN FUNCTIONS ------------
function displayTESTJSON (){
    displayJSON(ipcRenderer, dummy_save)
}
  
function displayJSON(json_object){
    gra_rep_renderer.createSVGModuleRep(ipcRenderer, json_object)
}

// ----------- INITIALIZE --------------

function initialize(){
    addButtonListeners()
    python_terminal_renderer.init(ipcRenderer)
    gra_rep_renderer.init(ipcRenderer)
    toolbox.initToolbox(ipcRenderer)
    //graphical_toolbox_renderer.init(ipcRenderer)

    
    // ipcRenderer.on('displayJSON', (event, json_object) => {
    //     ipcRenderer.send('debug', 'received!')
    //     displayJSON(json_object)
    // })
    file_manager.loadDummy()
    displayJSON(file_manager.getSave())
}

initialize()