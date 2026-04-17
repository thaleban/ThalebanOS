CC      := gcc
AS      := gcc
LD      := ld

CFLAGS  := -m32 -ffreestanding -fno-stack-protector -fno-pic -O2 -Wall -Wextra
ASFLAGS := -m32
LDFLAGS := -m elf_i386 -T linker.ld --oformat elf32-i386

KERNEL  := iso/boot/kernel.elf
ISO     := ThalebanOS.iso

OBJS    := boot/boot.o kernel/kernel.o

.PHONY: all iso run clean

all: $(KERNEL)

$(KERNEL): $(OBJS) linker.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

boot/boot.o: boot/boot.S
	$(AS) $(ASFLAGS) -c $< -o $@

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

iso: $(KERNEL)
	grub-mkrescue -o $(ISO) iso/

run: iso
	qemu-system-i386 -cdrom $(ISO) -m 32M

clean:
	rm -f $(OBJS) $(KERNEL) $(ISO)
