var div = document.getElementById("model-diagram-display")

let pos = { top: 0, left: 0, x: 0, y: 0 };
let mousedown = false; //mouse dragging on img

const mouseUpHandler = function() {
    div.style.cursor = 'grab';
    
    mousedown = false;
};

const mouseMoveHandler = function(e) {
    if (mousedown){
        // How far the mouse has been moved
        const dx = e.clientX - pos.x
        const dy = e.clientY - pos.y

        // Scroll the element
        div.scrollTop = pos.top - dy
        div.scrollLeft = pos.left - dx
    }
};

const mouseDownHandler = function(e) {
    div.style.cursor = 'grabbing';
    
    pos = {
        // The current scroll 
        left: div.scrollLeft,
        top: div.scrollTop,
        // Get the current mouse position
        x: e.clientX,
        y: e.clientY,
    };

    mousedown = true;

    div.addEventListener('mousemove', mouseMoveHandler)
    document.addEventListener('mouseup', mouseUpHandler)
};

div.addEventListener('mousedown', mouseDownHandler)