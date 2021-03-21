const theme = require("../theme.js")
const CONSTANTS = require("../../constants.js")

const ns = "http://www.w3.org/2000/svg"
const diagram_div = document.getElementById("model-diagram-display")
const rect_width = 200
const rect_height = 200
const rect_left_margin = 20
const rect_corner_radius = 10
const rect_y = 200
const padding = 20

const SEMI_TRANSPARENT = "0.5"
const NOT_TRANSPARENT = "1"

// mouse
let pos = { top: 0, left: 0, x: 0, y: 0 };
let mousedown = false; //mouse dragging on img

// for selection
let selected_module_element = null

// current svg
let svg_diagram = false



// --------- Display Methods ---------

function createHtmlModuleRep (){
  var wrapper = document.createElement('div')
  wrapper.style.width = rect_width
  wrapper.style.height = rect_height+10
  diagram_div.appendChild(wrapper)

  var text = document.createElement('p')
  text.style.textAlign = 'center'
  text.textContent = '||'
  wrapper.appendChild(text)

  var module = document.createElement('div')
  module.className = 'module-box-main'
  module.style.width = rect_width
  module.style.height = rect_height
  wrapper.appendChild(module)

  module.style.backgroundColor = theme.light_blue_color
}

function createSingleSVGModule(ipcRenderer, pos_x, module_json){
  
  let element = document.createElementNS(ns, 'g')
  element.style.cursor = 'pointer'
  
  let line = document.createElementNS(ns, 'line')
  line.setAttribute("x1", Math.round(pos_x + rect_width / 2))
  line.setAttribute("y1",rect_y + rect_height)
  line.setAttribute("x2",Math.round(pos_x + rect_width / 2))
  line.setAttribute("y2", 600)
  line.setAttribute('stroke', 'gray')
  line.setAttribute('stroke-width', '4')
  line.style.cursor = 'grab'
  element.appendChild(line)

  let main_body = document.createElementNS(ns, 'rect')
  main_body.id = CONSTANTS.MOD_ID_PREFIX + module_json[CONSTANTS.UUID]
  main_body.setAttribute("x",pos_x)
  main_body.setAttribute("y",rect_y)
  main_body.setAttribute("rx",rect_corner_radius)
  main_body.setAttribute("ry",rect_corner_radius)
  main_body.setAttribute("width",rect_width)
  main_body.setAttribute("height",rect_height)
  //background.setAttribute('stroke', 'gray')
  //background.setAttribute('fill', 'white')
  main_body.setAttribute('fill-opacity', 0.15)
  main_body.setAttribute('stroke-width', '4')
  main_body.setAttribute('stroke-opacity', 0.5)
  // set to special color if it's noted in module_json, else use default
  let module_type = module_json[CONSTANTS.MODULE_TYPE]
  if (module_type in CONSTANTS.IP_database && CONSTANTS.NON_PERIPHERAL_COLOR in CONSTANTS.IP_database[module_type]){
    main_body.setAttribute("fill", CONSTANTS.IP_database[module_type][CONSTANTS.NON_PERIPHERAL_COLOR])
    main_body.setAttribute("stroke", CONSTANTS.IP_database[module_type][CONSTANTS.NON_PERIPHERAL_COLOR])
  } else {
    main_body.setAttribute("stroke",theme.light_blue_color)
    main_body.setAttribute("fill",theme.light_blue_color)
  }

  main_body.addEventListener('focus', (ev) => {
    if (selected_module_element != null) {resetHighlighted(selected_module_element)}
    setHighlighted(main_body)
    selected_module_element = main_body
    
    // send message about selected module changing
    ipcRenderer.send('selected-module-changed', main_body.id.slice(CONSTANTS.MOD_ID_PREFIX.length))
  })
  main_body.addEventListener('focusout', (ev) => {
    //main_body.style.outlineStyle = 'none'
  })

  element.appendChild(main_body)

  let nick = document.createElementNS(ns, 'text')
  nick.setAttribute('x', pos_x + padding)
  nick.setAttribute('y', rect_y + padding * 2)
  nick.setAttribute('font-weight', 'bold')
  nick.textContent = module_json[CONSTANTS.PARAMETERS][CONSTANTS.INSTANCE_NAME]
  nick.addEventListener('focus', (ev) => {
    main_body.focus()
  })
  element.appendChild(nick)

  // write other parameters
  let param_y = rect_y + rect_width - padding
  for (var key in module_json[CONSTANTS.PARAMETERS]){
    if (key == CONSTANTS.INSTANCE_NAME){ continue }

    let param = document.createElementNS(ns, 'text')
    param.setAttribute('x', pos_x + padding)
    param.setAttribute('y', param_y)
    param.textContent = key + ": " + module_json[CONSTANTS.PARAMETERS][key]
    param.setAttribute('fill', 'gray')
    param.addEventListener('focus', (ev) => {
      main_body.focus()
    })
    //param.style.color = 'red'
    element.appendChild(param)
    param_y -= padding
  }

  return element
}

function createSVGModuleRep (ipcRenderer, json_object) {
  let total = json_object.length
  ipcRenderer.send('debug', "total: " + total)
  
  if (svg_diagram != false){
    diagram_div.removeChild(svg_diagram)
  }

  svg_diagram = document.createElementNS(ns, "svg")
  svg_diagram.setAttributeNS(null, "width", (rect_width + rect_left_margin) * total + rect_left_margin)
  svg_diagram.setAttributeNS(null, "height", '100%')
  svg_diagram.style.fontFamily = theme.normal_font
  svg_diagram.style.overflow = 'visible'
  svg_diagram.style.outline = 'none'

  svg_diagram.addEventListener('focus', (ev) => {
    if (selected_module_element != null) {resetHighlighted(selected_module_element)}
    selected_module_element = null
    ipcRenderer.send('edit_box_visibility', false)
  })

  diagram_div.appendChild(svg_diagram)

  let i = 0
  let pos_x = rect_left_margin
  for (i = 0; i < total; i++){
    svg_diagram.appendChild(createSingleSVGModule(ipcRenderer, pos_x, json_object[i]))
    pos_x += rect_width + rect_left_margin
  }
}

// ------------ Selection ------------

function getSelected(){
  return selected_module_element
}

// ------------ SVG ------------
function createSVGRect(id, x, y, corner_r, width, height, fill_opacity, stroke_width, stroke_opacity){
  let rect = document.createElementNS(ns, 'rect')
  rect.id = id
  rect.setAttribute("x",x)
  rect.setAttribute("y",y)
  rect.setAttribute("rx",corner_r)
  rect.setAttribute("ry",corner_r)
  rect.setAttribute("width",width)
  rect.setAttribute("height",height)
  //background.setAttribute('stroke', 'gray')
  //background.setAttribute('fill', 'white')
  rect.setAttribute('fill-opacity', fill_opacity)
  rect.setAttribute('stroke-width', stroke_width)
  rect.setAttribute('stroke-opacity', stroke_opacity)

  return rect
}

function setSemiTransparency(val){
  if (val){
    val = SEMI_TRANSPARENT
  } else {
    val = NOT_TRANSPARENT
  }

  for (let i = 0; i < diagram_div.childNodes[0].childNodes.length; i++){
    diagram_div.childNodes[0].childNodes[i].style.opacity = val
  }
}

function setHighlighted(rect_element){
  rect_element.style.outline = "2px dashed " + theme.light_blue_color

  setSemiTransparency(true)
  rect_element.parentNode.style.opacity = NOT_TRANSPARENT
}

function resetHighlighted(rect_element){
  rect_element.style.outline = 'none'

  setSemiTransparency(false)
}


// ------------ Handlers ------------
function addPanningHandlers (ipcRenderer) {
  diagram_div.addEventListener('mousemove', mouseMoveHandler)
  diagram_div.addEventListener('mousedown', mouseDownHandler)
  diagram_div.addEventListener('wheel', mouseWheelHandler)
  document.addEventListener('mouseup', mouseUpHandler)
}

const mouseUpHandler = function() {
  diagram_div.style.cursor = 'grab';
  
  mousedown = false;
};

const mouseMoveHandler = function(e) {
  if (mousedown){
    // How far the mouse has been moved
    const dx = e.clientX - pos.x
    //const dy = e.clientY - pos.y

    // Scroll the element
    //diagram_div.scrollTop = pos.top - dy
    diagram_div.scrollLeft = pos.left - dx
  }
};

const mouseDownHandler = function(e) {
  diagram_div.style.cursor = 'grabbing';
  
  pos = {
    // The current scroll 
    left: diagram_div.scrollLeft,
    //top: diagram_div.scrollTop,
    // Get the current mouse position
    x: e.clientX,
    //y: e.clientY,
  };

  mousedown = true;

    
};

const mouseWheelHandler = function(e) {
  e.preventDefault()

  diagram_div.scrollLeft += e.deltaY * 0.7
}

// ------------ Initialization Code ------------
function init (ipcRenderer) {
  addPanningHandlers(ipcRenderer)

  ipcRenderer.on('update-renderer', (event, data) => {
    createSVGModuleRep(ipcRenderer, data)
    ipcRenderer.send('debug', "received update graphical rep command")
  })
}







module.exports = {
  getSelected,
  createSVGModuleRep,
  init,
}