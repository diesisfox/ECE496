const {ipcRenderer} = require('electron')
//const Swal = require('electron-alert')

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
    add_module_bar.style.visibility = 'hidden'
    add_button.addEventListener('click', function() {
        ipcRenderer.send('debug', add_module_bar.style.visibility)
        add_module_bar.style.visibility = add_module_bar.style.visibility === 'visible' ? 'hidden' : 'visible'
        //ipcRenderer.send('toggle module bar', "")
        // Swal.fire({
        //     title: "Add Module",
        //     html:
        //         '<input id="mod-name" class="swal2-input">' + 
        //         '<input id="mod-type" class="swal2-input">' + 
        //         '<input id="mod-address" class="swal2-input">',
        //     focusConfirm: false,
        //     preConfirm: () => {
        //         console.log(document.getElementById('mod-name').value)
        //     }
        // })
    })
    remove_button.addEventListener('click', function() {
        let cell = graphical_representation_renderer.getSelected()
        if (cell != null && cell.isVertex()){
            ipcRenderer.send('remove module', cell)
        } else {
            ipcRenderer.send('debug', "invalid module")
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