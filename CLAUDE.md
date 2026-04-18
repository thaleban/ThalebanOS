# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make          # build kernel ELF
make iso      # build bootable ISO
make run      # build ISO and launch in QEMU (qemu-system-i386)
make bear     # regenerate compile_commands.json for clangd
make clean    # remove build/
```

All artifacts land in `build/`. The source tree is never written to during a build.

## Architecture

ThalebanOS is a bare-metal x86 (32-bit) hobby kernel booted via Multiboot2.

**Boot sequence**
1. GRUB loads `build/iso/boot/kernel.elf` using the `multiboot2` protocol.
2. `boot/boot.S` — Multiboot2 header, 16 KiB BSS stack, `_start` entry point. Pushes the Multiboot2 magic and MBI pointer onto the stack, then calls `kernel_main`.
3. `kernel/kernel.c` — `kernel_main(uint32_t multiboot_magic, void *mbi)` receives those two arguments, sets up the display, and halts.

**Memory layout** (`linker.ld`)
- Kernel loaded at 1 MiB.
- Sections in order: `.multiboot2`, `.text`, `.rodata`, `.data`, `.bss`.
- Each section is 4 KiB aligned.

**Driver convention**
- Headers live under `kernel/include/<subsystem>/`, e.g. `kernel/include/drivers/vga.h`.
- Implementations live under `kernel/<subsystem>/`, e.g. `kernel/drivers/vga.c`.
- `CFLAGS` includes `-I kernel/include`, so includes are written as `#include <drivers/vga.h>`.

**Build system**
- The Makefile auto-detects all `*.c` and `*.S` files under `kernel/` and `boot/` via `find` — no manual `OBJS` updates needed when adding files.
- Object paths mirror source paths inside `build/` (e.g. `kernel/drivers/vga.c` → `build/kernel/drivers/vga.c.o`).

**Target machine**: `i386`, `-ffreestanding`, no stdlib, no stack protector, no PIC.
