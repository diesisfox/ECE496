const {ipcRenderer} = require('electron')

const CONSTANTS = require("../constants.js")
const python_terminal_renderer = require('../components/python_terminal/python_terminal_renderer.js')
const gra_rep_renderer = require('../components/graphical_representation_backbone/graphical_representation_renderer.js')
const toolbox_renderer = require("../components/toolbox/toolbox_renderer.js")

// -------- HTML ELEMENTS --------

// left menu
const open_button = document.getElementById("open-button")
const new_button = document.getElementById("new-button")
const save_button = document.getElementById("save-button")
const save_as_button = document.getElementById("save-as-button")
const add_button = document.getElementById("add-button")
const val_button = document.getElementById("val-button")
const generate_button = document.getElementById("generate-button")
const about_button = document.getElementById("about-button")

// button listeners
function addButtonListeners(){
    // left menu
    open_button.addEventListener('click', function() {
        ipcRenderer.send('open file', "")
    })
    new_button.addEventListener('click', function() {
        ipcRenderer.send('new file', "")
    })
    save_button.addEventListener('click', function() {
        ipcRenderer.send('save file', "")
    })
    save_as_button.addEventListener('click', function() {
        ipcRenderer.send('save as file', "")
    })
    add_button.addEventListener('click', function() {
        toolbox_renderer.toggle_toolbox_visibility()
    })
    val_button.addEventListener('click', function() {
        ipcRenderer.sendSync('console-input-reading', 'validate()')
    })
    generate_button.addEventListener('click', function() {
        //ipcRenderer.send('generate', "")
        ipcRenderer.sendSync('console-input-reading', 'generate()')
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
    toolbox_renderer.initToolbox(ipcRenderer)
    
    displayJSON(ipcRenderer.sendSync('get-save',''))
}

initialize()