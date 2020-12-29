const mxgraph = require("mxgraph")({
    mxImageBasePath: "../../../../node_modules/mxgraph/javascript/src/images",
    mxBasePath: "../../../../node_modules/mxgraph/javascript/src"
})

// --------- Files Variables & Constants ---------

const div = document.getElementById("model-diagram-display")
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
    var v1 = graph.insertVertex(parentCell, null, 'Hello,', 20, 20, 80, 30)
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

function displayJSON(json){

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
div.addEventListener('wheel', scrollHandler)

displayTests()
//wipeGraphicalDisplay()

graph.setPanning(true)
graph.setEnabled(false)




module.exports = {
  wipeGraphicalDisplay,
  displayJSON,
}