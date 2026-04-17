/* Multiboot2 header + entry point */
.set MULTIBOOT2_MAGIC,    0xe85250d6
.set MULTIBOOT2_ARCH_I386, 0
.set HEADER_LENGTH,       (multiboot2_header_end - multiboot2_header)
.set CHECKSUM,            -(MULTIBOOT2_MAGIC + MULTIBOOT2_ARCH_I386 + HEADER_LENGTH)

.section .multiboot2, "a"
.align 8
multiboot2_header:
	.long MULTIBOOT2_MAGIC
	.long MULTIBOOT2_ARCH_I386
	.long HEADER_LENGTH
	.long CHECKSUM
	/* end tag */
	.short 0
	.short 0
	.long  8
multiboot2_header_end:

	.section .bss, "aw", @nobits
	.align 16
stack_bottom:
	.skip 16384
stack_top:

	.section .text
	.global _start
	.type _start, @function
_start:
	mov $stack_top, %esp
	push %ebx       /* multiboot2 info pointer */
	push %eax       /* multiboot2 magic */
	call kernel_main
1:  hlt
	jmp 1b
