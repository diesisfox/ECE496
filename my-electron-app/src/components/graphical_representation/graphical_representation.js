const mxgraph = require("mxgraph")({
    mxImageBasePath: "../../../../node_modules/mxgraph/javascript/src/images",
    mxBasePath: "../../../../node_modules/mxgraph/javascript/src"
})

const div = document.getElementById("model-diagram-display")

var model = new mxgraph.mxGraphModel();
var graph = new mxgraph.mxGraph(div, model);

var parent = graph.getDefaultParent();

// Adds cells to the model in a single step
model.beginUpdate();
try
{
  var v1 = graph.insertVertex(parent, null, 'Hello,', 20, 20, 80, 30);
  var v2 = graph.insertVertex(parent, null, 'World!', 200, 150, 80, 30);
  var e1 = graph.insertEdge(parent, null, '', v1, v2);

//   graph.setEnabled(false)
}
finally
{
  // Updates the display
  model.endUpdate();
}