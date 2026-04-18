#ifndef VGA_H
#define VGA_H

#include <stdint.h>

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_MEM    ((uint16_t*)0xB8000)

uint16_t vga_entry(char c, uint8_t color);
void vga_clear(uint8_t color);
void vga_print(const char *s, int row, int col, uint8_t color);

#endif
