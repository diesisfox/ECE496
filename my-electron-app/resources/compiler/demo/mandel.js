canvas = document.querySelector("#canvas");
ctx = canvas.getContext('2d');

// all fixed s2.29

function imul(a,b){
    return ((a*b)>>29)&0xffffffff;
}

function getIters(x, y){
    iterations = 0n;
}