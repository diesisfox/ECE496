#ifndef _VGA_H
#define _VGA_H

#include <stdint.h>

typedef struct{
    uint32_t         :31;
    uint32_t en      :1;
    uint32_t         :21;
    uint32_t xAddr   :11;
    uint32_t         :22;
    uint32_t yAddr   :10;
    uint32_t         :8;
    uint32_t pxlData :24;
    uint32_t         :24;
    uint32_t pAddr   :8;
    uint32_t         :8;
    uint32_t pltData :24;
    uint32_t         :32;
    uint32_t         :22;
    uint32_t scanLine:10;
} __attribute__((packed)) Vga_t;

#endif // _VGA_H