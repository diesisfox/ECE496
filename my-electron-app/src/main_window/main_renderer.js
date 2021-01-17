const {ipcRenderer} = require('electron')

const CONSTANTS = require("../constants.js")
const python_terminal_renderer = require('../components/python_terminal/python_terminal_renderer.js')
const graphical_representation_renderer = require('../components/graphical_representation_backbone/graphical_representation_renderer.js')
//const graphical_toolbox_renderer = require('../components/graphical_representation/graphical_toolbox_renderer.js')

// -------- HTML ELEMENTS --------

// left menu
const open_button = document.getElementById("open-button")
const save_button = document.getElementById("save-button")
const save_as_button = document.getElementById("save-as-button")
const add_button = document.getElementById("add-button")
const remove_button = document.getElementById("remove-button")
const generate_button = document.getElementById("generate-button")
const about_button = document.getElementById("about-button")

// add module bar
const add_module_bar = document.getElementById("add-module-bar")
const add_module_button = document.getElementById("add-module-button")
const add_module_name = document.getElementById("add-module-name")
const add_module_type = document.getElementById("add-module-type")
const add_module_address = document.getElementById("add-module-address")

// module toolbox
const module_toolbox = document.getElementById("module-toolbox")

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
    add_module_bar.displayed = false
    module_toolbox.displayed = false
    add_button.addEventListener('click', function() {
        // add module bar
        if (add_module_bar.displayed == true){
            add_module_bar.displayed = false
            let animation = add_module_bar.animate({top: '-150px'}, 400)
            animation.onfinish = function() {
                add_module_bar.style.top = '-150px'
            }
        } else {
            add_module_bar.displayed = true
            let animation = add_module_bar.animate({top: '5px'}, 400)
            animation.onfinish = function() {
                add_module_bar.style.top = '5px'
            }
        }
        // toolbox
        if (module_toolbox.displayed == true){
            module_toolbox.displayed = false
            let animation = module_toolbox.animate({top: '-225px'}, 400)
            animation.onfinish = function() {
                module_toolbox.style.top = '-225px'
            }
        } else {
            module_toolbox.displayed = true
            let animation = module_toolbox.animate({top: '5px'}, 400)
            animation.onfinish = function() {
                module_toolbox.style.top = '5px'
            }
        }
    })
    remove_button.addEventListener('click', function() {
        // let cell = graphical_representation_renderer.getSelected()
        // if (cell != null && cell.isVertex()){
        //     ipcRenderer.send('remove module', cell)
        // } else {
        //     ipcRenderer.send('debug', "invalid module")
        //     ipcRenderer.send('system-message', "Invalid selection, please click on a valid module before clicking this button.")
        // }
        let focused_id = graphical_representation_renderer.getSelected().id
        let prefix_len = CONSTANTS.MOD_ID_PREFIX.length
        if (focused_id.length > prefix_len && focused_id.slice(0,prefix_len) == CONSTANTS.MOD_ID_PREFIX){
            ipcRenderer.send('system-message', "Tried to remove: " + focused_id)
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

    // add button bar
    add_module_button.addEventListener('click', function() {
        ipcRenderer.send('add module', {
            name: add_module_name.value,
            type: add_module_type.value,
            address: add_module_address.value
        })
    })
}

// ----------- INITIALIZE --------------

function initialize(){
    addButtonListeners()
    python_terminal_renderer.init(ipcRenderer)
    graphical_representation_renderer.init(ipcRenderer)
    //graphical_toolbox_renderer.init(ipcRenderer)
}

initialize()