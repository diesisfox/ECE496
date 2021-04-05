CFLAGS = -march=rv32im -mabi=ilp32 -g -ffreestanding -fstrict-volatile-bitfields -Wl,--gc-sections -nostartfiles -nostdlib -nodefaultlibs -Wl,-T,../riscv32.ld ../crt0.s
TOOLCHAIN_PREFIX = riscv64-unknown-elf-

mandel: mandel.c vga.h
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -O3 $^ -o mandel.elf
	$(TOOLCHAIN_PREFIX)objdump -S -d -l mandel.elf > mandel.s
	$(TOOLCHAIN_PREFIX)objcopy -O verilog mandel.elf mandel_bytes.vh
	python ../endian_flip.py mandel_bytes.vh mandel.vh
	gsed -i -E 's/\b([0-9a-f]{2})\s([0-9a-f]{2})\s([0-9a-f]{2})\s([0-9a-f]{2})\b/\4\3\2\1/gi' mandel.vh
	python ../hex_to_mif.py mandel.vh

mandel_O3: mandel.c vga.h
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -O3 $^ -o mandel_O3.elf
	$(TOOLCHAIN_PREFIX)objdump -S -d -l mandel_O3.elf > mandel_O3.s
	$(TOOLCHAIN_PREFIX)objcopy -O verilog mandel_O3.elf mandel_O3_bytes.vh
	python ../endian_flip.py mandel_O3_bytes.vh mandel_O3.vh
	gsed -i -E 's/\b([0-9a-f]{2})\s([0-9a-f]{2})\s([0-9a-f]{2})\s([0-9a-f]{2})\b/\4\3\2\1/gi' mandel_O3.vh
	python ../hex_to_mif.py mandel_O3.vh

clean:
	rm mandel.s mandel.elf mandel.vh mandel_bytes.vh mandel_O3.s mandel_O3.elf mandel_O3.vh mandel_O3_bytes.vh

.PHONY: test clean
