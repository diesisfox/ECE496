canvas = document.querySelector("#canvas");
ctx = canvas.getContext('2d');

highestSqNorm = 0;
highestSqNormFixed = 0n;

function getItersFloat(x0, y0){
    maxIters = 255;
    iterations = 0;
    x = 0;
    y = 0;
    while(x*x + y*y <= 4 && iterations < maxIters){
        newX = x*x - y*y + x0;
        newY = 2*x*y + y0;
        x = newX;
        y = newY;
        iterations++;
    }
    highestSqNorm = Math.max(x*x + y*y, highestSqNorm);
    return iterations;
}

function yeetFloat(){
    xmin = -1.5;
    xmax = 0.75;
    yspan = (xmax-xmin)*3/4
    ymin = -yspan/2;
    ymax = yspan/2;
    
    dx = (xmax-xmin)/640;
    dy = (ymax-ymin)/480;
    xStart = xmin + dx/2;
    yStart = ymin + dy/2;
    
    imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    data = imageData.data
    for(i = 0; i < 640; i++){
        for(j = 0; j < 480; j++){
            x0 = xStart + dx * i;
            y0 = yStart + dy * j;
            iters = getItersFloat(x0, y0);
            data[j*640*4+i*4+0] = data[j*640*4+i*4+1] = data[j*640*4+i*4+2] = 255-iters;
            data[j*640*4+i*4+3] = 255;
        }
    }
    ctx.putImageData(imageData, 0, 0);
}



// fixed s5.26

function imul(a,b){
    return BigInt.asIntN(32, (a*b)>>26n);
}

function iadd(a,b){
    return BigInt.asIntN(32, a+b);
}

function makeNum(x){
    return BigInt.asIntN(32, BigInt(Math.round(x*2**26)))
}

function getItersFixed(x0, y0){
    maxIters = 255;
    iterations = 0;
    x = 0n;
    y = 0n;
    while(iadd(imul(x,x), imul(y,y)) <= 268435456n && iterations < maxIters){
        newX = iadd(iadd(imul(x,x), -imul(y,y)), x0);
        newY = iadd(imul(imul(134217728n,x),y), y0);
        x = newX;
        y = newY;
        iterations++;
    }
    highestSqNorm = (iadd(imul(x,x), imul(y,y)) > highestSqNorm) ? iadd(imul(x,x), imul(y,y)) : highestSqNorm;
    return iterations;
}

function yeetFixed(){
    xmin = -100663296n;
    xmax = 50331648n;
    yspan = (iadd(xmax,-xmin)*3n)>>2n;
    ymin = -(yspan>>1n);
    ymax = yspan>>1n;
    
    dx = iadd(xmax,-xmin)/640n;
    xStart = iadd(xmin, dx>>1n);
    yStart = iadd(ymin, dx>>1n);
    
    imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    data = imageData.data;
    y0 = yStart;
    for(j = 0; j < 480; j++){
        x0 = xStart;
        for(i = 0; i < 640; i++){
            iters = getItersFixed(x0, y0);
            data[j*640*4+i*4+0] = data[j*640*4+i*4+1] = data[j*640*4+i*4+2] = 255-iters;
            data[j*640*4+i*4+3] = 255;
            x0 = iadd(x0, dx);
        }
        y0 = iadd(y0, dx);
        console.log(j);
    }
    ctx.putImageData(imageData, 0, 0);
}

// yeetFixed()

console.log(highestSqNorm);