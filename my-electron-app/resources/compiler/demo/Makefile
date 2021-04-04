CFLAGS = -march=rv32im -mabi=ilp32 -g -ffreestanding -Wl,--gc-sections -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,../riscv32.ld ../crt0.s
TOOLCHAIN_PREFIX = riscv64-unknown-elf-

mandel: mandel.c vga.h
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -O0 $^ -o mandel.elf
	$(TOOLCHAIN_PREFIX)objdump -S -d -l mandel.elf > mandel.s
	$(TOOLCHAIN_PREFIX)objcopy -O verilog mandel.elf mandel_bytes.vh
	python ../endian_flip.py mandel_bytes.vh mandel.vh

mandel_O3: mandel.c vga.h
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -O3 $^ -o mandel_O3.elf
	$(TOOLCHAIN_PREFIX)objdump -S -d -l mandel_O3.elf > mandel_O3.s
	$(TOOLCHAIN_PREFIX)objcopy -O verilog mandel_O3.elf mandel_O3_bytes.vh
	python ../endian_flip.py mandel_O3_bytes.vh mandel_O3.vh

clean:
	rm mandel.s mandel.elf mandel.vh mandel_bytes.vh mandel_O3.s mandel_O3.elf mandel_O3.vh mandel_O3_bytes.vh

.PHONY: test clean
