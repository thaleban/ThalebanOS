#include <stdint.h>

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_MEM    ((uint16_t*)0xB8000)

static inline uint16_t vga_entry(char c, uint8_t color) {
	return (uint16_t)c | ((uint16_t)color << 8);
}

static void vga_clear(uint8_t color) {
	for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++)
		VGA_MEM[i] = vga_entry(' ', color);
}

static void vga_print(const char *s, int row, int col, uint8_t color) {
	for (int i = 0; s[i]; i++)
		VGA_MEM[row * VGA_WIDTH + col + i] = vga_entry(s[i], color);
}

void kernel_main(uint32_t multiboot_magic, void *mbi) {
	(void)mbi;

	vga_clear(0x00);
	vga_print("ThalebanOS", 11, 35, 0x0F);

	if (multiboot_magic == 0x36d76289)
		vga_print("[multiboot2 OK]", 12, 32, 0x0A);
	else
		vga_print("[bad magic]",     12, 34, 0x0C);

	for (;;) __asm__ volatile ("hlt");
}
