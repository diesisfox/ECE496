const { crashReporter} = require("electron");

const mxgraph = require("mxgraph")({
    mxImageBasePath: "../../../../node_modules/mxgraph/javascript/src/images",
    mxBasePath: "../../../../node_modules/mxgraph/javascript/src"
})

// --------- Files Variables & Constants ---------

const theme_style = getComputedStyle(document.body)
const variable = theme_style.getPropertyValue("--button-hover-border")
//ipcRenderer.send("debug", variable)

const div = document.getElementById("model-diagram-display")
const rect_width = 80
const rect_height = 30
let model = new mxgraph.mxGraphModel()
let graph = new mxgraph.mxGraph(div, model)
let zoom = 1;

// --------- Methods ---------

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
  graph.removeCells(graph.getChildCells(graph.getDefaultParent()))
  //model.endUpdate()
}

// unfinished, needs JSON schema for completion
function displayJSON(json){
  const totalNum = 20 //change to number of modules in total
  const angle = 2*Math.PI/totalNum
  const radius = Math.max(rect_width * 3, 140*totalNum / (2 * Math.PI))
  let curr_angle = 0
  let center = null

  var parentCell = graph.getDefaultParent()

  // wipe old vertices and edges
  graph.removeCells(graph.getChildCells(parentCell))

  model.beginUpdate()
  try
  {
    center = graph.insertVertex(parentCell, null, 'Center', 0, 0, rect_width, rect_height)
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
    let corner_x = Math.round(Math.abs(center_x) - rect_width / 2) * getSign(center_x)
    let corner_y = Math.round(Math.abs(center_y) - rect_height / 2) * getSign(center_y)

    // display rectangle
    model.beginUpdate()
    try
    {
      let v1 = graph.insertVertex(parentCell, null, 'Hello', corner_x, corner_y, rect_width, rect_height)
      var e1 = graph.insertEdge(parentCell, null, '', v1, center)
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

// returns 1 if positive, -1 if negative, and 0 if 0
function getSign(x){
  return (x / Math.max(1,Math.abs(x)))
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
  ipcRenderer.send("debug", variable)
  div.addEventListener('wheel', scrollHandler)

  displayTests()
  //wipeGraphicalDisplay()
  displayJSON("blab")

  graph.setPanning(true)
  graph.setEnabled(false)
}







module.exports = {
  wipeGraphicalDisplay,
  displayJSON,
  init,
}