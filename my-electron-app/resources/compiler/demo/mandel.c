#include <stdint.h>
#include <stddef.h>
#include "vga.h"

// fixed s5.26

#define QP_4 268435456L
#define QP_2 134217728L
#define QP_NEG_1_5 -100663296L
#define QP_0_75 50331648L
#define QP_INV_640 104858L
#define QP_X_MIN -100427366L
#define QP_X_MAX 50095718L
#define QP_Y_MIN -56387174L
#define QP_Y_MAX 56387174L

#define RIGHT 0b0001
#define UP 0b0010
#define DOWN 0b0100
#define LEFT 0b1000
#define MOVEPOWER 6

#define MAX_SCALING 19
const int32_t DX_SCALE[MAX_SCALING] = {
    235930L, 117965L, 58982L, 29491L,
    14746L, 7373L, 3686L, 1843L,
    922L, 461L, 230L, 115L,
    58L, 29L, 14L, 7L,
    4L, 2L, 1L
};

int32_t xStart = QP_X_MIN;
int32_t yStart = QP_Y_MIN;
uint8_t scale = 0;

volatile Vga_t* vgaHandle = (void*) 0x80000000;

int32_t qmul(int32_t a, int32_t b){
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
}

void zoomIn(void){
    if(scale == MAX_SCALING - 1) return;
    int32_t dx = DX_SCALE[scale];
    xStart = xStart + 160 * dx;
    yStart = yStart + 120 * dx;
    scale++;
}

void zoomOut(void){
    if(scale == 0) return;
    scale --;
    if(scale == 0){
        xStart = QP_X_MIN;
        yStart = QP_Y_MIN;
        return;
    }
    int32_t dx = DX_SCALE[scale];
    xStart = xStart - 160 * dx;
    yStart = yStart - 120 * dx;
    // check max bounds
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
    if(yStart + 479 * dx > QP_Y_MAX) yStart = QP_Y_MAX - 479 * dx;
    // check min bounds
    if(xStart < QP_X_MIN) xStart = QP_X_MIN;
    if(yStart < QP_Y_MIN) yStart = QP_Y_MIN;
}

void moveFrame(uint8_t dirs){
    int32_t dx = DX_SCALE[scale];
    if(dirs & UP){
        yStart += dx << MOVEPOWER;
    }else if(dirs & DOWN){
        yStart -= dx << MOVEPOWER;
    }
    if(dirs & RIGHT){
        xStart += dx << MOVEPOWER;
    }else if(dirs & LEFT){
        xStart -= dx << MOVEPOWER;
    }
    // check max bounds
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
    if(yStart + 479 * dx > QP_Y_MAX) yStart = QP_Y_MAX - 479 * dx;
    // check min bounds
    if(xStart < QP_X_MIN) xStart = QP_X_MIN;
    if(yStart < QP_Y_MIN) yStart = QP_Y_MIN;
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

void drawMandel(void){
    int32_t dx = DX_SCALE[scale];
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

void setPalette0(void){ // greyscale
    // set palette address
    vgaHandle->pAddr = 0;
    for(size_t i = 0; i < 255; i++){
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
    }
}

void setPalette1(void){ // cherenkov
    // predefined data
    
    // set palette address
    vgaHandle->pAddr = 0;
    for(size_t i = 0; i < 255; i++){
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
    }
}

int main(void){
    // enable video
    vgaHandle->en = 1;
    // set palette
    setPalette0();
    // set pixel address to 0
    vgaHandle->xAddr = 0;
    vgaHandle->yAddr = 0;
    // draw
    drawMandel();
    for(;;);
    return 0;
}