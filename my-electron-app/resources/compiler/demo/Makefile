CFLAGS = -march=rv32im -mabi=ilp32 -g -ffreestanding -O0 -Wl,--gc-sections -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,../riscv32.ld ../crt0.s
TOOLCHAIN_PREFIX = riscv64-unknown-elf-

mandel: mandel.c vga.h
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) $^ -o mandel.elf
	$(TOOLCHAIN_PREFIX)objdump -S -d -l mandel.elf > mandel.s
	$(TOOLCHAIN_PREFIX)objcopy -O verilog mandel.elf mandel_bytes.vh
	python ../endian_flip.py mandel_bytes.vh mandel.vh

clean:
	rm mandel.s mandel.elf mandel.vh mandel_bytes.vh

.PHONY: test clean
