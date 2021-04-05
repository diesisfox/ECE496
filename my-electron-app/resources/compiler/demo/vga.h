#ifndef _VGA_H
#define _VGA_H

#include <stdint.h>

typedef volatile struct{
    volatile uint32_t en :32;
    volatile uint32_t xAddr :32;
    volatile uint32_t yAddr :32;
    volatile uint32_t pxlData :32;
    volatile uint32_t pAddr :32;
    volatile uint32_t pltData :32;
    volatile uint32_t :32;
    volatile uint32_t scanLine :32;
} Vga_t;

#endif // _VGA_H