const {ipcRenderer} = require('electron')

const python_terminal_renderer = require('../components/python_terminal/python_terminal_renderer.js')
const graphical_representation_renderer = require('../components/graphical_representation/graphical_representation_renderer.js')

// const

const open_button = document.getElementById("open-button")
const save_button = document.getElementById("save-button")
const save_as_button = document.getElementById("save-as-button")
const about_button = document.getElementById("about-button")


// button listeners

function addButtonListeners(){
    open_button.addEventListener('click', function() {
        ipcRenderer.send('open file', "")
    })
    save_button.addEventListener('click', function() {
        ipcRenderer.send('save file', "")
    })
    save_as_button.addEventListener('click', function() {
        ipcRenderer.send('save as file', "")
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
}

initialize()