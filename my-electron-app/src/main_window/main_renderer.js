const {ipcRenderer} = require('electron')

const python_terminal_renderer = require('../components/python_terminal/python_terminal_renderer.js')
const graphical_representation_renderer = require('../components/graphical_representation/graphical_representation_renderer.js')
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
        if (add_module_bar.style.bottom === '5px'){
            let animation = add_module_bar.animate({bottom: '-50px'}, 400)
            animation.onfinish = function() {
                add_module_bar.style.bottom = '-50px'
            }
        } else {
            let animation = add_module_bar.animate({bottom: '5px'}, 400)
            animation.onfinish = function() {
                add_module_bar.style.bottom = '5px'
            }
        }
    })
    remove_button.addEventListener('click', function() {
        let cell = graphical_representation_renderer.getSelected()
        if (cell != null && cell.isVertex()){
            ipcRenderer.send('remove module', cell)
        } else {
            ipcRenderer.send('debug', "invalid module")
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