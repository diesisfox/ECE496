#include <stdint.h>
#include <stddef.h>
#include "vga.h"

// fixed s5.26

#define QP_4 268435456L
#define QP_2 134217728L
#define QP_NEG_1_5 -100663296L
#define QP_0_75 50331648L
#define QP_INV_640 104858L

volatile Vga_t* vgaHandle = (void*) 0x80000000;

int32_t qmul(int32_t a, int32_t b){
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
}

uint8_t getIters(int32_t x0, int32_t y0){
    uint16_t maxIters = 255;
    int32_t x = 0;
    int32_t y = 0;
    uint16_t iters = 0;
    for(; iters <= maxIters; iters++){
        int32_t xx = qmul(x, x);
        int32_t yy = qmul(y, y);
        if(xx + yy > QP_4) break;
        int32_t newX = xx - yy + x0;
        int32_t newY = (qmul(x, y) << 1) + y0;
        x = newX;
        y = newY;
    }
    return iters;
}

void drawMandel(int32_t xMin, int32_t xMax, int32_t yMin, int32_t yMax){
    int32_t dx = qmul(xMax - xMin, QP_INV_640);
    int32_t xStart = xMin + (dx >> 1);
    int32_t yStart = yMin + (dx >> 1);
    int32_t y0 = yStart;
    for(size_t j = 0; j < 480; j++){
        int32_t x0 = xStart;
        for(size_t i = 0; i < 640; i++){
            uint8_t iters = getIters(x0, y0);
            vgaHandle->pxlData = iters;
            x0 += dx;
        }
        y0 += dx;
    }
}

void setPalette0(){
    // set palette address
    vgaHandle->pAddr = 0;
    for(size_t i = 0; i < 255; i++){
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
    }
}

int main(){
    // enable video
    vgaHandle->en = 1;
    // set palette
    setPalette0();
    // set pixel address to 0
    vgaHandle->xAddr = 0;
    vgaHandle->yAddr = 0;
    // draw
    int32_t xMin = QP_NEG_1_5;
    int32_t xMax = QP_0_75;
    int32_t ySpan = ((xMax - xMin) * 3) >> 2;
    int32_t yMin = -(ySpan >> 1);
    int32_t yMax = ySpan >> 1;
    drawMandel(xMin, xMax, yMin, yMax);
    for(;;){
    }
    return 0;
}