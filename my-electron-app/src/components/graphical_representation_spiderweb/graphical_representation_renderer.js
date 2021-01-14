const mxgraph = require("mxgraph")({
    mxImageBasePath: "../../../../node_modules/mxgraph/javascript/src/images",
    mxBasePath: "../../../../node_modules/mxgraph/javascript/src"
})
const toolbox = require("../toolbox/toolbox.js")
const theme = require("../theme.js")

// --------- Files Variables & Constants ---------
const NON_PERIPHERAL_COLOR = "non_peripheral_color"
const module_types = [
  {
    type: 'user-defined',
    non_peripheral_color: '#f2f2f2', //if not a peripheral, include a color
  },
  {
    type: 'CPU',
    non_peripheral_color: '#ffffcc', //if not a peripheral, include a color
  },
  {
    type: 'Memory',
    non_peripheral_color: '#e5ffcc', //if not a peripheral, include a color
  }, 
  {type: 'SPI'},
  {type: 'GPIO'},
  {type: 'VGA'},
  {type: 'UART'},
  {type: 'ADC'},
  {type: 'I2C'},
  {type: 'Duplex SAI and CODEC'},
  {type: 'PS/2'},
  {type: 'Composite Video'},
  {type: 'On-Chip Memory'}
]

const diagram_div = document.getElementById("model-diagram-display")
const rect_width = 80
const rect_height = 30
let model = null
let graph = null
let panningHandler = null

let totalNum = 1

// --------- Graph Methods ---------

function initGraph(ipcRenderer) {
  model = new mxgraph.mxGraphModel()
  graph = new mxgraph.mxGraph(diagram_div, model)
  panningHandler = new mxgraph.mxPanningHandler(graph)

  // styles
  let edge_style = graph.getStylesheet().getDefaultEdgeStyle()
  edge_style[mxgraph.mxConstants.STYLE_ENDARROW] = ""
  edge_style[mxgraph.mxConstants.STYLE_STROKECOLOR] = theme.light_blue_color
  graph.getStylesheet().putDefaultEdgeStyle(edge_style)
  let vertex_style = graph.getStylesheet().getDefaultVertexStyle()
  vertex_style[mxgraph.mxConstants.STYLE_ROUNDED] = 1
  vertex_style[mxgraph.mxConstants.STYLE_ARCSIZE] = 30
  vertex_style[mxgraph.mxConstants.STYLE_STROKECOLOR] = theme.light_blue_color
  vertex_style[mxgraph.mxConstants.STYLE_STROKEWIDTH] = 3
  vertex_style[mxgraph.mxConstants.STYLE_FILLCOLOR] = 'white'
  vertex_style[mxgraph.mxConstants.STYLE_FONTCOLOR] = 'black'
  graph.getStylesheet().putDefaultVertexStyle(vertex_style)
  mxgraph.mxConstants.EDGE_SELECTION_COLOR = theme.light_blue_color
  mxgraph.mxConstants.LOCKED_HANDLE_FILLCOLOR = 'white'
  mxgraph.mxConstants.VERTEX_SELECTION_COLOR = 'white'
  mxgraph.mxConstants.VERTEX_SELECTION_STROKEWIDTH = 2
  //let cell_style = graph.getStylesheet().getCellStyle()
  //cell_style[mxgraph.mxConstants.EDGE_SELECTION_COLOR] = light_blue_color
  //graph.getStylesheet().putCellStyle(cell_style)

  graph.selectionModel.setSingleSelection(true)

  graph.setPanning(true)
  graph.setCellsCloneable(false)
  graph.setCellsDeletable(false)
  graph.setCellsMovable(false)
  graph.setVertexLabelsMovable(false)
  graph.setConnectableEdges(false)
  graph.setCellsResizable(false)
  //graph.setCellsBendable(false) //unsure if needed
  //graph.setCellsEditable(false) // TODO: add feature so that this rename is connected to what's happening with the internal representation
  graph.setCellsDisconnectable(false)
  graph.setConnectable(false)

  panningHandler.useLeftButtonForPanning = true
  panningHandler.ignoreCell = true

  // add edit event listener
  model.valueForCellChanged = function(cell, value){
    ipcRenderer.send('debug', "woah, edited? That's rude, because we haven't done JSON yet!")
    var previous = cell.value;
    cell.value = value;

    return previous;
  };

  graph.center()
}

function displayTests(){

  var parentCell = graph.getDefaultParent()

  // wipe old vertices and edges
  graph.removeCells(graph.getChildCells(parentCell))

  // Adds cells to the model in a single step
  model.beginUpdate()
  try
  {
    //note that x and y are the coordinates of the top left corner of the rectangle
    var v1 = graph.insertVertex(parentCell, null, 'Hello,', 20, 20, 80, 30)
    var v2 = graph.insertVertex(parentCell, null, 'T', 20, 20, 20, 30)
    var v2 = graph.insertVertex(parentCell, null, 'World!', 200, 150, 80, 30)
    var e1 = graph.insertEdge(parentCell, null, '', v1, v2)
    var v3 = graph.insertVertex(parentCell, null, 'Default,', 300, 250, 80, 30)
    var v4 = graph.insertVertex(parentCell, null, 'Graph!', 700, 400, 80, 30)
    var e2 = graph.insertEdge(parentCell, null, '', v3, v4)
    //graph.center()
  }
  finally
  {
    // Updates the display
    model.endUpdate()
  }
}

function wipeGraphicalDisplay(){
  //model.beginUpdate()
  graph.setCellsDeletable(true)
  graph.removeCells(graph.getChildCells(graph.getDefaultParent()))
  graph.setCellsDeletable(false)
  //model.endUpdate()
}

// unfinished, needs JSON schema for completion
function displayJSON(json){
  const angle = 2*Math.PI/totalNum
  const radius = Math.max(rect_width * 3, 140*totalNum / (2 * Math.PI))
  let curr_angle = 0
  let center = null

  var parentCell = graph.getDefaultParent()

  // wipe old vertices and edges

  model.beginUpdate()
  try
  {
    wipeGraphicalDisplay()
    center = graph.insertVertex(parentCell, null, '', 0, 0, 0, 0,
      'defaultVertex;arcSize=50')
  } catch (err){
    return
  }
  finally
  {
    // Updates the display
    model.endUpdate()
  }

  let i = 0
  for (i = 0; i < totalNum; i++){
    // get position of center of the rectangle
    let center_x = Math.cos(curr_angle) * radius
    let center_y = Math.sin(curr_angle) * radius

    // get posiition of top left corner of rectangle
    let corner_x = Math.round(center_x - rect_width / 2)
    let corner_y = Math.round(center_y - rect_height / 2)

    // display rectangle
    model.beginUpdate()
    try
    {
      let v1 = graph.insertVertex(parentCell, null, 'Hello'+i, corner_x, corner_y, rect_width, rect_height)
      v1.uid = i
      let e1 = graph.insertEdge(parentCell, null, '', v1, center)//, 'defaultEdge;endArrow='
    } 
    catch (err) {
      return
    }
    finally
    {
      // Updates the display
      model.endUpdate()
    }

    curr_angle += angle
  }
}

function getSelected() {
  return graph.getSelectionCell()
}

// ------------ Handlers ------------

const scrollHandler = function(event){
  if (event.deltaY >=0){
    graph.zoomOut()
  } else {
    graph.zoomIn()
  }
};

// ------------ Initialization Code ------------
function init (ipcRenderer) {
  initGraph(ipcRenderer)

  // enable ability to zoom in and out using the scrollwheel
  diagram_div.addEventListener('wheel', scrollHandler)
  
  
  toolbox.initToolbox(ipcRenderer)

  //displayTests()
  //wipeGraphicalDisplay()
  displayJSON("blab")
}







module.exports = {
  wipeGraphicalDisplay,
  displayJSON,
  getSelected,
  init,
}