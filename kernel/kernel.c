#include <drivers/vga.h>

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
