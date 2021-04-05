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

uint32_t lastSw = 0;

volatile Vga_t* vgaHandle = (void*) 0x80000000;
volatile uint32_t* sw = (void*) 0x80010004;

int processSw();

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
    for(; iters < maxIters; iters++){
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

void paintBigPixel(uint32_t x, uint32_t y, uint8_t p, uint8_t pow){
    for(uint8_t j = 0; j < 1<<pow; j++){
        vgaHandle->yAddr = y + j;
        vgaHandle->xAddr = x;
        for(uint8_t i =0; i < 1<<pow; i++){
            vgaHandle->pxlData = p;
        }
    }
}

int drawMandelInterlaced(void){
    int32_t dx = DX_SCALE[scale];
    int32_t itersAccum = 0;

    int32_t y0 = yStart;
    for(size_t j = 0; j < 480>>5; j++){
        int32_t x0 = xStart;
        for(size_t i = 0; i < 640>>5; i++){
            uint8_t iters = getIters(x0, y0);
            itersAccum += iters;
            if(itersAccum > 4096){
                if(processSw()) return 1;
                itersAccum = 0;
            }
            paintBigPixel(i<<5, j<<5, iters, 5);
            x0 += dx<<5;
        }
        y0 += dx<<5;
    }

    for(int l = 4; l; l--){
        int32_t y0 = yStart;
        for(size_t j = 0; j < 480>>l; j++){
            int32_t x0 = xStart;
            for(size_t i = 0; i < 640>>l; i++){
                if((j&1)|(i&i)){
                    uint8_t iters = getIters(x0, y0);
                    paintBigPixel(i<<l, j<<l, iters, l);
                    itersAccum += iters;
                    if(itersAccum > 4096){
                        if(processSw()) return 1;
                        itersAccum = 0;
                    }
                }
                x0 += dx<<l;
            }
            y0 += dx<<l;
        }
    }

    y0 = yStart;
    for(size_t j = 0; j < 480; j++){
        int32_t x0 = xStart;
        vgaHandle->yAddr = j;
        for(size_t i = 0; i < 640; i++){
            if((j&1)|(i&i)){
                uint8_t iters = getIters(x0, y0);
                itersAccum += iters;
                vgaHandle->pxlData = iters;
                if(itersAccum > 4096){
                    if(processSw()) return 1;
                    itersAccum = 0;
                }
            }else{
                vgaHandle->xAddr = i+1;
            }
            x0 += dx;
        }
        y0 += dx;
    }
    return 0;
}

void setPalette0(void){ // greyscale
    // set palette address
    vgaHandle->pAddr = 0;
    for(int i = 255; i >= 0; i--){
        vgaHandle->pltData = i << 16 | i << 8 | i;
    }
}

void setPalette1(void){ // cherenkov
    // predefined data
    static uint32_t palette[256] = {0x9d4200,0x9d4300,0x9e4401,0x9e4401,0x9f4502,0x9f4602,0xa04702,0xa04803,0xa14803,0xa14904,0xa14a04,0xa24b04,0xa24c05,0xa34c05,0xa34d05,0xa44e06,0xa44f06,0xa44f07,0xa55007,0xa55107,0xa65208,0xa65308,0xa75309,0xa75409,0xa85509,0xa8560a,0xa8570a,0xa9570b,0xa9580b,0xaa590b,0xaa5a0c,0xab5b0c,0xab5b0d,0xab5c0d,0xac5d0d,0xac5e0e,0xad5f0e,0xad5f0e,0xae600f,0xae610f,0xaf6210,0xaf6310,0xaf6310,0xb06411,0xb06511,0xb16612,0xb16612,0xb26712,0xb26813,0xb26913,0xb36a14,0xb36a14,0xb46b14,0xb46c15,0xb56d15,0xb56e16,0xb66e16,0xb66f16,0xb67017,0xb77117,0xb77217,0xb87218,0xb87318,0xb97419,0xb97519,0xba7619,0xba761a,0xba771a,0xbb781b,0xbb791b,0xbc791b,0xbc7a1c,0xbd7b1c,0xbd7c1d,0xbd7d1d,0xbe7d1d,0xbe7e1e,0xbf7f1e,0xbf801f,0xc0811f,0xc0811f,0xc18220,0xc18320,0xc18420,0xc28521,0xc28621,0xc38622,0xc38722,0xc48822,0xc48923,0xc58a23,0xc58a24,0xc58b24,0xc68c24,0xc68d25,0xc78e25,0xc78e26,0xc88f26,0xc89026,0xc99127,0xc99227,0xc99228,0xca9328,0xca9428,0xcb9529,0xcb9629,0xcc962a,0xcc972a,0xcd982a,0xcd992b,0xcd9a2b,0xce9a2c,0xce9b2c,0xcf9c2c,0xcf9d2d,0xd09e2d,0xd09f2e,0xd19f2e,0xd1a02e,0xd2a12f,0xd2a22f,0xd2a330,0xd3a330,0xd3a430,0xd4a531,0xd4a631,0xd5a732,0xd5a732,0xd6a832,0xd6a933,0xd7aa33,0xd7ab34,0xd7ac34,0xd8ac34,0xd8ad35,0xd9ae35,0xd9af36,0xdab036,0xdab137,0xdbb137,0xdbb237,0xdcb338,0xdcb438,0xdcb539,0xddb639,0xddb639,0xdeb73a,0xdeb83a,0xdfb93b,0xdfba3b,0xe0ba3b,0xe0bb3c,0xe1bc3c,0xe1bd3d,0xe1be3d,0xe2bf3d,0xe2bf3e,0xe3c03e,0xe3c13f,0xe4c23f,0xe4c340,0xe5c440,0xe5c440,0xe6c541,0xe6c641,0xe7c742,0xe7c842,0xe7c942,0xe8c943,0xe8ca43,0xe9cb44,0xe9cc44,0xeacd44,0xeace45,0xebcf45,0xebcf46,0xecd046,0xecd147,0xedd247,0xedd347,0xeed448,0xeed448,0xeed549,0xefd649,0xefd749,0xf0d84a,0xf0d94a,0xf1d94b,0xf1da4b,0xf2db4c,0xf2dc4c,0xf3dd4c,0xf3de4d,0xf4df4d,0xf4df4e,0xf5e04e,0xf5e14e,0xf5e24f,0xf6e34f,0xf6e450,0xf7e550,0xf7e551,0xf8e651,0xf8e751,0xf9e852,0xf9e952,0xfaea53,0xfaeb53,0xfbeb54,0xfbec54,0xfced54,0xfcee55,0xfdef55,0xfdf056,0xfef056,0xfef156,0xfef257,0xfff357,0xfff45c,0xfff462,0xfff468,0xfff56d,0xfff572,0xfff677,0xfff67c,0xfff680,0xfff785,0xfff789,0xfff88e,0xfff892,0xfff896,0xfff99b,0xfff99f,0xfff9a2,0xfffaa7,0xfffaaa,0xfffaae,0xfffab2,0xfffbb6,0xfffbb9,0xfffbbd,0xfffcc1,0xfffcc4,0xfffcc7,0xfffccb,0xfffdce,0xfffdd2,0xfffdd5,0xfffdd8,0xfffedb,0xfffede,0xfffee2,0xffffe5,0xffffe8,0xffffeb};
    // set palette address
    vgaHandle->pAddr = 0;
    for(size_t i = 0; i < 256; i++){
        vgaHandle->pltData = palette[i];
    }
}

void setPalette2(void){
    static uint32_t palette[256] = {0x598dfc,0x5a8efc,0x5b8ffc,0x5b90fc,0x5c91fc,0x5d91fc,0x5e92fc,0x5f93fc,0x5f94fc,0x6095fc,0x6196fc,0x6297fc,0x6398fc,0x6399fc,0x649afc,0x659afc,0x669bfc,0x679cfc,0x679dfc,0x689efc,0x699ffc,0x6aa0fc,0x6ba1fd,0x6ba2fd,0x6ca2fd,0x6da3fd,0x6ea4fd,0x6fa5fd,0x6fa6fd,0x70a7fd,0x71a8fd,0x72a9fd,0x73aafd,0x73abfd,0x74abfd,0x75acfd,0x76adfd,0x77aefd,0x77affd,0x78b0fd,0x79b1fd,0x7ab2fd,0x7bb3fd,0x7bb3fd,0x7cb4fd,0x7db5fd,0x7eb6fd,0x7fb7fd,0x7fb8fd,0x80b9fd,0x81bafd,0x82bbfd,0x83bbfd,0x83bcfd,0x84bdfd,0x85befd,0x86bffd,0x87c0fd,0x87c1fd,0x88c2fd,0x89c3fd,0x8ac4fd,0x8bc4fd,0x8bc5fd,0x8cc6fe,0x8dc7fe,0x8ec8fe,0x8fc9fe,0x8fcafe,0x90cbfe,0x91ccfe,0x92ccfe,0x93cdfe,0x93cefe,0x94cffe,0x95d0fe,0x96d1fe,0x97d2fe,0x97d3fe,0x98d4fe,0x99d5fe,0x9ad5fe,0x9bd6fe,0x9bd7fe,0x9cd8fe,0x9dd9fe,0x9edafe,0x9fdbfe,0x9fdcfe,0xa0ddfe,0xa1ddfe,0xa2defe,0xa3dffe,0xa3e0fe,0xa4e1fe,0xa5e2fe,0xa6e3fe,0xa7e4fe,0xa7e5fe,0xa8e6fe,0xa9e6fe,0xaae7fe,0xabe8fe,0xabe9fe,0xaceafe,0xadebfe,0xaeecfe,0xafedff,0xafeeff,0xb0eeff,0xb1efff,0xb2f0ff,0xb3f1ff,0xb3f2ff,0xb4f3ff,0xb5f4ff,0xb6f5ff,0xb7f6ff,0xb7f7ff,0xb8f7ff,0xb9f8ff,0xbaf9ff,0xbbfaff,0xbbfbff,0xbcfcff,0xbdfdff,0xbefeff,0xbfffff,0xbfffff,0xbefffe,0xbefefd,0xbefefc,0xbdfefb,0xbdfdfb,0xbdfdfa,0xbcfdf9,0xbcfcf8,0xbcfcf7,0xbbfcf7,0xbbfbf6,0xbbfbf5,0xbafbf4,0xbafaf3,0xbafaf3,0xb9faf2,0xb9f9f1,0xb9f9f0,0xb8f9ef,0xb8f8ef,0xb8f8ee,0xb7f8ed,0xb7f7ec,0xb7f7eb,0xb6f7eb,0xb6f6ea,0xb6f6e9,0xb5f6e8,0xb5f5e7,0xb5f5e7,0xb4f5e6,0xb4f4e5,0xb4f4e4,0xb3f4e3,0xb3f3e3,0xb3f3e2,0xb2f3e1,0xb2f2e0,0xb2f2df,0xb1f2df,0xb1f1de,0xb1f1dd,0xb0f1dc,0xb0f0db,0xb0f0db,0xaff0da,0xafefd9,0xafefd8,0xaeefd7,0xaeeed7,0xaeeed6,0xadeed5,0xadedd4,0xadedd3,0xacedd3,0xacecd2,0xacecd1,0xabecd0,0xabebcf,0xabebcf,0xaaebce,0xaaeacd,0xaaeacc,0xa9eacb,0xa9e9cb,0xa9e9ca,0xa8e9c9,0xa8e8c8,0xa8e8c7,0xa7e8c7,0xa7e7c6,0xa7e7c5,0xa6e7c4,0xa6e6c3,0xa6e6c3,0xa5e6c2,0xa5e5c1,0xa5e5c0,0xa4e5bf,0xa4e4bf,0xa4e4be,0xa3e4bd,0xa3e3bc,0xa3e3bb,0xa2e3bb,0xa2e3ba,0xa1e2b9,0xa1e2b8,0xa1e2b7,0xa0e1b7,0xa0e1b6,0xa0e1b5,0x9fe0b4,0x9fe0b3,0x9fe0b3,0x9edfb2,0x9edfb1,0x9edfb0,0x9ddeaf,0x9ddeaf,0x9ddeae,0x9cddad,0x9cddac,0x9cddab,0x9bdcab,0x9bdcaa,0x9bdca9,0x9adba8,0x9adba7,0x9adba7,0x99daa6,0x99daa5,0x99daa4,0x98d9a3,0x98d9a3,0x98d9a2,0x97d8a1,0x97d8a0,0x97d89f,0x96d79f,0x96d79e,0x96d79d,0x95d69c,0x95d69b,0x95d69b,0x94d59a,0x94d599};
    // set palette address
    vgaHandle->pAddr = 0;
    for(size_t i = 0; i < 256; i++){
        vgaHandle->pltData = palette[i];
    }
}

int processSw(){
    uint32_t newSw = *sw;
    int ret = 0;
    if(newSw != lastSw){
        uint32_t changes = newSw & ~lastSw;
        if(changes&0xf){
            ret = 1;
            moveFrame(changes&0xf);
        }
        if(changes&0x10){
            ret = 1;
            zoomIn();
        }
        if(changes & 0x20){
            ret = 1;
            zoomOut();
        }
        uint32_t flips = newSw ^ lastSw;
        if((flips >> 6) & 0xf){
            ret = 0;
            switch((newSw >> 6) & 0xf){
                case 0: setPalette0(); break;
                case 1: setPalette1(); break;
                case 2: setPalette2(); break;
                default: setPalette0(); break;
            }
        }
    }else ret = 0;
    lastSw = newSw;
    return ret;
}

int main(void){
    // enable video
    vgaHandle->en = 1;
    // set palette
    setPalette1();
    // set pixel address to 0
    // vgaHandle->xAddr = 0;
    // vgaHandle->yAddr = 0;
    // draw
    for(;;){
        int update = drawMandelInterlaced();
        if(!update){
            while(!processSw());
        }
    }
    return 0;
}
