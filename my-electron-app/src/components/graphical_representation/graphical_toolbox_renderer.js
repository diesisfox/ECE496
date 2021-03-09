const { ipcRenderer } = require("electron")

const mxgraph = require("mxgraph")({
    mxImageBasePath: "../../../../node_modules/mxgraph/javascript/src/images",
    mxBasePath: "../../../../node_modules/mxgraph/javascript/src"
})

const theme_style = getComputedStyle(document.body)
const light_blue_color = getHexFromRGB(theme_style.getPropertyValue("--button-hover-border"))

const diagram_div = document.getElementById("module-toolbox")
const div_width = diagram_div.clientWidth
const div_height = diagram_div.clientHeight
const num_per_row = 2 //number of modules per row
const rect_width = 100
const rect_height = 30
let model = null
let graph = null


//// *IMPORTANT* Currently this file is unused

// --------- Helper Functions ---------

// returns 1 if positive, -1 if negative, and 0 if 0
function getSign(x){
    return (x / Math.max(1,Math.abs(x)))
}

function getHexFromRGB(rgb_string){
    // get R,G,B
    var three_integers = rgb_string.split("(")[1].split(")")[0]
    
    // convert base 10 to base 16
    var hex_string = three_integers.split(",").map(function(x){
    x = parseInt(x).toString(16);
    return (x.length==1) ? "0"+x : x; // add a 0 if there is only one number
    })

    return "#"+hex_string.join("")
}

// --------- Methods ---------

function initGraph() {
    model = new mxgraph.mxGraphModel()
    graph = new mxgraph.mxGraph(diagram_div, model)

    // styles
    let edge_style = graph.getStylesheet().getDefaultEdgeStyle()
    edge_style[mxgraph.mxConstants.STYLE_ENDARROW] = ""
    edge_style[mxgraph.mxConstants.STYLE_STROKECOLOR] = light_blue_color
    graph.getStylesheet().putDefaultEdgeStyle(edge_style)
    let vertex_style = graph.getStylesheet().getDefaultVertexStyle()
    vertex_style[mxgraph.mxConstants.STYLE_ROUNDED] = 1
    vertex_style[mxgraph.mxConstants.STYLE_ARCSIZE] = 30
    vertex_style[mxgraph.mxConstants.STYLE_STROKECOLOR] = light_blue_color
    vertex_style[mxgraph.mxConstants.STYLE_FILLCOLOR] = light_blue_color
    vertex_style[mxgraph.mxConstants.STYLE_FONTCOLOR] = 'black'
    graph.getStylesheet().putDefaultVertexStyle(vertex_style)
    mxgraph.mxConstants.EDGE_SELECTION_COLOR = light_blue_color
    mxgraph.mxConstants.LOCKED_HANDLE_FILLCOLOR = 'white'
    mxgraph.mxConstants.VERTEX_SELECTION_COLOR = 'black'
    mxgraph.mxConstants.VERTEX_SELECTION_STROKEWIDTH = 2
    //let cell_style = graph.getStylesheet().getCellStyle()
    //cell_style[mxgraph.mxConstants.EDGE_SELECTION_COLOR] = light_blue_color
    //graph.getStylesheet().putCellStyle(cell_style)
  
    graph.selectionModel.setSingleSelection(true)
  
    //graph.setPanning(true)
    //graph.setEnabled(false)
    graph.setCellsCloneable(false)
    graph.setCellsDeletable(false)
    //graph.setCellsMovable(false)
    graph.setVertexLabelsMovable(false)
    graph.setConnectableEdges(false)
    graph.setCellsResizable(false)
    //graph.setCellsBendable(false) //unsure if needed
    graph.setCellsEditable(false) // TODO: add feature so that this rename is connected to what's happening with the internal representation
    graph.setCellsDisconnectable(false)
    graph.setConnectable(false)
}

// TODO: add different shapes/color for each kind of module
function initModules(ipcRenderer){
    const totalNum = 13 //change to number of modules in total
    const horizontal_spacing = (div_width - rect_width * num_per_row) / (num_per_row+1)
    const vertical_spacing = rect_height / 3
  
    let parentCell = graph.getDefaultParent()
  
    // wipe old vertices and edges
    graph.removeCells(graph.getChildCells(parentCell))
  
    let i = 0
    let curr_x = horizontal_spacing
    let curr_y = vertical_spacing
    
    

    for (i = 0; i < totalNum; i++){
        // display rectangle
        model.beginUpdate()
        try
        {
            ipcRenderer.send('debug', "added new module")
            let v1 = graph.insertVertex(parentCell, null, 'Hello', curr_x, curr_y, rect_width, rect_height)
        } 
        catch (err) {
            return
        }
        finally{
            // Updates the display
            model.endUpdate()
        }
  
        curr_x += rect_width + horizontal_spacing
        if (curr_x + rect_width >= div_width) {
            curr_x = horizontal_spacing
            curr_y += vertical_spacing + rect_height
        }
    }

    
    
}

function init(ipcRenderer) {
    ipcRenderer.send('debug', "starting init")

    initGraph()

    initModules(ipcRenderer)
}

module.exports = {
    init,
}