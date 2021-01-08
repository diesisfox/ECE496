const { crashReporter} = require("electron");

const mxgraph = require("mxgraph")({
    mxImageBasePath: "../../../../node_modules/mxgraph/javascript/src/images",
    mxBasePath: "../../../../node_modules/mxgraph/javascript/src"
})

const theme = require("../theme.js")

// --------- Files Variables & Constants ---------
//ipcRenderer.send("debug", variable)

const diagram_div = document.getElementById("model-diagram-display")
const toolbox_div = document.getElementById("module-toolbox")
const tb_div_width = toolbox_div.clientWidth
const tb_div_height = toolbox_div.clientHeight
const tb_icon_num_per_row = 2 //number of modules per row
const tb_rect_width = 80
const tb_rect_height = 50
const rect_width = 80
const rect_height = 30
let model = null
let graph = null

let totalNum = 1

// --------- Helper Functions ---------

// returns 1 if positive, -1 if negative, and 0 if 0
function getSign(x){
  return (x / Math.max(1,Math.abs(x)))
}


// --------- Toolbox ---------

function createModuleIcon (ipcRenderer, index, margin, rect_width, rect_height){
  var moduleIcon = document.createElement("div")
  moduleIcon.className = 'module-toolbox-icon'

  moduleIcon.style.width = rect_width
  moduleIcon.style.height = rect_height
  //moduleIcon.style.left = x + "px"
  //moduleIcon.style.top = y + "px"
  moduleIcon.style.margin = margin + "px"

  moduleIcon.draggable = true
  moduleIcon.ondragstart = function(ev) {
    ev.dataTransfer.setData('type_id', index)
  }

  return moduleIcon
}

function initToolbox (ipcRenderer){
  const totalNum = 13 // later, change so that we use an array of modules types instead
  const margin = (tb_div_width - tb_rect_width * tb_icon_num_per_row) / (tb_icon_num_per_row) / 2

  // add a toolbar objects
  let i = 0
  
  for (i = 0; i < totalNum; i++){
    toolbox_div.appendChild(createModuleIcon(ipcRenderer, i, margin, rect_width, rect_height))
  }

  // set drag handlers
  toolbox_div.ondragover = function (ev) {
    ev.preventDefault()
  }

  diagram_div.ondragover = function (ev) {
    ev.preventDefault()
  }
  diagram_div.ondrop = function (ev) {
    ev.preventDefault()
    ipcRenderer.send('debug', ev.dataTransfer.getData('type_id'))
  }
}
/*
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

      // var pt = graph.getPointForEvent(evt)
      // var vertex = graph.getModel().cloneCell(prototype)
      // vertex.geometry.x = pt.x
      // vertex.geometry.y = pt.y

      // ipcRenderer.send('debug', pt.x + ", "+ pt.y)
      
      // graph.setSelectionCells(graph.importCells([vertex], 0, 0, cell));
      
      totalNum += 1
      displayJSON("")

      ipcRenderer.send('debug', "totalNum: " + totalNum)
  }

  // Creates the image which is used as the drag icon (preview)
  var img = toolbox.addMode("hello", image, funct, null)
  mxgraph.mxUtils.makeDraggable(img, graph, funct)
}

function initToolbox(ipcRenderer, graph, model) {
  const totalNum = 13 // later, change so that we use an array of modules types instead
  const horizontal_spacing = (tb_div_width - tb_rect_width * tb_icon_num_per_row) / (tb_icon_num_per_row+1)
  const vertical_spacing = tb_rect_height / 3

  tb_graph = new mxgraph.mxGraph(toolbox_div, new mxgraph.mxGraphModel())

  let parentCell = graph.getDefaultParent()

  toolbox = new mxgraph.mxToolbar(toolbox_div)
  toolbox.enabled = false

  graph.setDropEnabled(true)

  // called whenever mouse drags a toolbar object
  mxgraph.mxDragSource.prototype.getDropTarget = function(graph, x, y){
      var cell = graph.getCellAt(x, y)
        
      if (!graph.isValidDropTarget(cell))
      {
          cell = null;
      }
      
      return cell;
  }

  // add a toolbar objects
  let i = 0
  let curr_x = horizontal_spacing
  let curr_y = vertical_spacing
  
  for (i = 0; i < totalNum; i++){
      // display rectangle
      model.beginUpdate()
      try
      {
          //let v1 = graph.insertVertex(parentCell, null, 'Hello', curr_x, curr_y, rect_width, rect_height)
          addVertex(ipcRenderer, "../../resources/images/mxGraph/empty.png", 40, 40, 'shape=rhombus')
      } 
      catch (err) {
          return
      }
      finally{
          // Updates the display
          model.endUpdate()
      }

      curr_x += tb_rect_width + horizontal_spacing
      if (curr_x + tb_rect_width >= tb_div_width) {
          curr_x = horizontal_spacing
          curr_y += vertical_spacing + tb_rect_height
      }
  }

  ipcRenderer.send('debug', toolbox.container.nodeName)
}*/

// --------- Graph Methods ---------

function initGraph() {
  model = new mxgraph.mxGraphModel()
  graph = new mxgraph.mxGraph(diagram_div, model)

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
  graph.setCellsEditable(false) // TODO: add feature so that this rename is connected to what's happening with the internal representation
  graph.setCellsDisconnectable(false)
  graph.setConnectable(false)

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

// unused
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
  initGraph()

  // enable ability to zoom in and out using the scrollwheel
  diagram_div.addEventListener('wheel', scrollHandler)
  
  
  initToolbox(ipcRenderer)

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