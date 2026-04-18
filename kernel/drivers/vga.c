#include <drivers/vga.h>

uint16_t vga_entry(char c, uint8_t color) {
	return (uint16_t)c | ((uint16_t)color << 8);
}

void vga_clear(uint8_t color) {
	for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++)
		VGA_MEM[i] = vga_entry(' ', color);
}

void vga_print(const char *s, int row, int col, uint8_t color) {
	for (int i = 0; s[i]; i++)
		VGA_MEM[row * VGA_WIDTH + col + i] = vga_entry(s[i], color);
}
