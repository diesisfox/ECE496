const {ipcRenderer} = require('electron')

const python_terminal_renderer = require('../components/python_terminal/python_terminal_renderer.js')
const graphical_representation_renderer = require('../components/graphical_representation/graphical_representation_renderer.js')

function initialize(){
    python_terminal_renderer.init(ipcRenderer)

    graphical_representation_renderer.init(ipcRenderer)
}

initialize()