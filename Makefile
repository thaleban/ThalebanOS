CC      := gcc
AS      := gcc
LD      := ld

CFLAGS  := -m32 -ffreestanding -fno-stack-protector -fno-pic -O2 -Wall -Wextra -I kernel/include
ASFLAGS := -m32
LDFLAGS := -m elf_i386 -T linker.ld --oformat elf32-i386

BUILD   := build
KERNEL  := $(BUILD)/iso/boot/kernel.elf
ISO     := $(BUILD)/ThalebanOS.iso

C_SRCS  := $(shell find kernel boot -name '*.c')
S_SRCS  := $(shell find kernel boot -name '*.S')
OBJS    := $(patsubst %,$(BUILD)/%.o,$(C_SRCS) $(S_SRCS))

.PHONY: all iso run clean bear

all: $(KERNEL)

$(BUILD)/%.c.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/%.S.o: %.S
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

$(KERNEL): $(OBJS) linker.ld
	@mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

iso: $(KERNEL)
	cp -r iso/boot/grub $(BUILD)/iso/boot/
	grub-mkrescue -o $(ISO) $(BUILD)/iso/

run: iso
	qemu-system-i386 -cdrom $(ISO) -m 32M

bear:
	bear -- $(MAKE) clean all

clean:
	rm -rf $(BUILD)
