const mxgraph = require("mxgraph")({
    mxImageBasePath: "../../../../node_modules/mxgraph/javascript/src/images",
    mxBasePath: "../../../../node_modules/mxgraph/javascript/src"
})

const theme = require("../theme.js")

const toolbox_div = document.getElementById("module-toolbox")
const div_width = toolbox_div.clientWidth
const div_height = toolbox_div.clientHeight
const num_per_row = 2 //number of modules per row
const rect_width = 100
const rect_height = 30
let model = null
let graph = null

let toolbox = null


// *IMPORTANT* Currently this file is unused

// --------- Helper Functions ---------

function addVertex (ipcRenderer, icon, w, h, style){

    var vertex = new mxgraph.mxCell(null, new mxgraph.mxGeometry(0, 0, w, h), style)
    vertex.setVertex(true)

    addToolbarItem(ipcRenderer, graph, vertex, icon)
}

function addToolbarItem(ipcRenderer, graph, prototype, image)
{
    // Function that is executed when the image is dropped on
    // the graph. The cell argument points to the cell under
    // the mousepointer if there is one.

    var funct = function(graph, evt, cell)
    {
        graph.stopEditing(false)

        graph.setCellsResizable(true)

        var pt = graph.getPointForEvent(evt)
        var vertex = graph.getModel().cloneCell(prototype)
        vertex.geometry.x = pt.x
        vertex.geometry.y = pt.y

        ipcRenderer.send('debug', pt.x + ", "+ pt.y)
        
        graph.setSelectionCells(graph.importCells([vertex], 0, 0, cell));
    }

    // Creates the image which is used as the drag icon (preview)
    var img = toolbox.addMode(null, image, funct)
    mxgraph.mxUtils.makeDraggable(img, graph, funct)
}

// --------- Methods ---------

function initToolbox(ipcRenderer, graph, model) {

    toolbox = new mxgraph.mxToolbar(toolbox_div)
    toolbox.enabled = false

    graph.setDropEnabled(true)

    mxgraph.mxConstants.VERTEX_SELECTION_COLOR = 'black'

    mxgraph.mxDragSource.prototype.getDropTarget = function(graph, x, y){
        ipcRenderer.send('debug', "Test")
        var cell = graph.getCellAt(x, y);
					
        if (!graph.isValidDropTarget(cell))
        {
            cell = null;
        }
        
        return cell;
    }
    
    // Enables new connections in the graph
    //graph.setConnectable(true)
    //graph.setMultigraph(false)

    // Stops editing on enter or escape keypress
    // var keyHandler = new mxgraph.mxKeyHandler(graph)
    // var rubberband = new mxgraph.mxRubberband(graph)

    addVertex(ipcRenderer, "../../resources/images/mxGraph/rhombus.gif", 40, 40, 'shape=rhombus');

    ipcRenderer.send('debug', "toolbox init finished")
}

// TODO: add different shapes/color for each kind of module
// function initModules(ipcRenderer){
//     const totalNum = 13 //change to number of modules in total
//     const horizontal_spacing = (div_width - rect_width * num_per_row) / (num_per_row+1)
//     const vertical_spacing = rect_height / 3
  
//     let parentCell = graph.getDefaultParent()
  
//     // wipe old vertices and edges
//     graph.removeCells(graph.getChildCells(parentCell))
  
//     let i = 0
//     let curr_x = horizontal_spacing
//     let curr_y = vertical_spacing
    
    

//     for (i = 0; i < totalNum; i++){
//         // display rectangle
//         model.beginUpdate()
//         try
//         {
//             ipcRenderer.send('debug', "added new module")
//             let v1 = graph.insertVertex(parentCell, null, 'Hello', curr_x, curr_y, rect_width, rect_height)
//         } 
//         catch (err) {
//             return
//         }
//         finally{
//             // Updates the display
//             model.endUpdate()
//         }
  
//         curr_x += rect_width + horizontal_spacing
//         if (curr_x + rect_width >= div_width) {
//             curr_x = horizontal_spacing
//             curr_y += vertical_spacing + rect_height
//         }
//     }

    
    
// }

module.exports = {
    initToolbox,
}