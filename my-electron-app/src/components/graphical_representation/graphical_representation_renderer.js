const mxgraph = require("mxgraph")({
    mxImageBasePath: "../../../../node_modules/mxgraph/javascript/src/images",
    mxBasePath: "../../../../node_modules/mxgraph/javascript/src"
})

// --------- Globals ---------
const div = document.getElementById("model-diagram-display")
var model = new mxgraph.mxGraphModel();
var graph = new mxgraph.mxGraph(div, model);

graph.setPanning(true)
graph.setEnabled(false)


function displayTests(){

  var parentCell = graph.getDefaultParent()

  // wipe old vertices and edges
  graph.removeCells(graph.getChildCells(parentCell))

  // Adds cells to the model in a single step
  model.beginUpdate()
  try
  {
    var v1 = graph.insertVertex(parentCell, null, 'Hello,', 20, 20, 80, 30)
    var v2 = graph.insertVertex(parentCell, null, 'World!', 200, 150, 80, 30)
    var e1 = graph.insertEdge(parentCell, null, '', v1, v2)
    var v3 = graph.insertVertex(parentCell, null, 'Default,', 300, 250, 80, 30)
    var v4 = graph.insertVertex(parentCell, null, 'Graph!', 700, 400, 80, 30)
    var e2 = graph.insertEdge(parentCell, null, '', v3, v4)
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

function displayJSON(json){

}

// ------------ Handlers ------------

const scrollUpHandler = function(){
  //graph.zoomin
}

displayTests()
wipeGraphicalDisplay()

module.exports = {
  wipeGraphicalDisplay,
  displayJSON,
}