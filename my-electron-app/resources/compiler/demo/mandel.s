
mandel.elf:     file format elf32-littleriscv


Disassembly of section .init:

00000000 <_start>:
_start():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/../crt0.s:8
_start:
    .cfi_startproc
    .cfi_undefined ra
    .option push
    .option norelax
    la gp, __global_pointer$
   0:	00001197          	auipc	gp,0x1
   4:	07c18193          	addi	gp,gp,124 # 107c <__global_pointer$>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/../crt0.s:10
    .option pop
    la sp, __stack_top
   8:	00010117          	auipc	sp,0x10
   c:	ff810113          	addi	sp,sp,-8 # 10000 <__stack_top>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/../crt0.s:11
    add s0, sp, zero
  10:	00010433          	add	s0,sp,zero
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/../crt0.s:12
    jal zero, main
  14:	7ac0006f          	j	7c0 <main>

Disassembly of section .text:

00000018 <qmul>:
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:38
int32_t yStart = QP_Y_MIN;
uint8_t scale = 0;

volatile Vga_t* vgaHandle = (void*) 0x80000000;

int32_t qmul(int32_t a, int32_t b){
  18:	fe010113          	addi	sp,sp,-32
  1c:	00812e23          	sw	s0,28(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	feb42423          	sw	a1,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
  2c:	fec42583          	lw	a1,-20(s0)
  30:	00058813          	mv	a6,a1
  34:	41f5d593          	srai	a1,a1,0x1f
  38:	00058893          	mv	a7,a1
  3c:	fe842583          	lw	a1,-24(s0)
  40:	00058613          	mv	a2,a1
  44:	41f5d593          	srai	a1,a1,0x1f
  48:	00058693          	mv	a3,a1
  4c:	02c88533          	mul	a0,a7,a2
  50:	030685b3          	mul	a1,a3,a6
  54:	00b505b3          	add	a1,a0,a1
  58:	02c80533          	mul	a0,a6,a2
  5c:	02c837b3          	mulhu	a5,a6,a2
  60:	00050713          	mv	a4,a0
  64:	00f586b3          	add	a3,a1,a5
  68:	00068793          	mv	a5,a3
  6c:	00679693          	slli	a3,a5,0x6
  70:	01a75313          	srli	t1,a4,0x1a
  74:	0066e333          	or	t1,a3,t1
  78:	41a7d393          	srai	t2,a5,0x1a
  7c:	00030793          	mv	a5,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:40
}
  80:	00078513          	mv	a0,a5
  84:	01c12403          	lw	s0,28(sp)
  88:	02010113          	addi	sp,sp,32
  8c:	00008067          	ret

00000090 <zoomIn>:
zoomIn():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:42

void zoomIn(void){
  90:	fe010113          	addi	sp,sp,-32
  94:	00812e23          	sw	s0,28(sp)
  98:	02010413          	addi	s0,sp,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
    if(scale == MAX_SCALING - 1) return;
  9c:	80c1c703          	lbu	a4,-2036(gp) # 888 <scale>
  a0:	01200793          	li	a5,18
  a4:	08f70863          	beq	a4,a5,134 <zoomIn+0xa4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    int32_t dx = DX_SCALE[scale];
  a8:	80c1c783          	lbu	a5,-2036(gp) # 888 <scale>
  ac:	00078693          	mv	a3,a5
  b0:	000017b7          	lui	a5,0x1
  b4:	80478713          	addi	a4,a5,-2044 # 804 <DX_SCALE>
  b8:	00269793          	slli	a5,a3,0x2
  bc:	00f707b3          	add	a5,a4,a5
  c0:	0007a783          	lw	a5,0(a5)
  c4:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
    xStart = xStart + 160 * dx;
  c8:	fec42703          	lw	a4,-20(s0)
  cc:	00070793          	mv	a5,a4
  d0:	00279793          	slli	a5,a5,0x2
  d4:	00e787b3          	add	a5,a5,a4
  d8:	00579793          	slli	a5,a5,0x5
  dc:	00078713          	mv	a4,a5
  e0:	000017b7          	lui	a5,0x1
  e4:	87c7a783          	lw	a5,-1924(a5) # 87c <xStart>
  e8:	00f70733          	add	a4,a4,a5
  ec:	000017b7          	lui	a5,0x1
  f0:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
    yStart = yStart + 120 * dx;
  f4:	fec42703          	lw	a4,-20(s0)
  f8:	00070793          	mv	a5,a4
  fc:	00479793          	slli	a5,a5,0x4
 100:	40e787b3          	sub	a5,a5,a4
 104:	00379793          	slli	a5,a5,0x3
 108:	00078713          	mv	a4,a5
 10c:	000017b7          	lui	a5,0x1
 110:	8807a783          	lw	a5,-1920(a5) # 880 <yStart>
 114:	00f70733          	add	a4,a4,a5
 118:	000017b7          	lui	a5,0x1
 11c:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:47
    scale++;
 120:	80c1c783          	lbu	a5,-2036(gp) # 888 <scale>
 124:	00178793          	addi	a5,a5,1
 128:	0ff7f713          	andi	a4,a5,255
 12c:	80e18623          	sb	a4,-2036(gp) # 888 <scale>
 130:	0080006f          	j	138 <zoomIn+0xa8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
    if(scale == MAX_SCALING - 1) return;
 134:	00000013          	nop
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48
}
 138:	01c12403          	lw	s0,28(sp)
 13c:	02010113          	addi	sp,sp,32
 140:	00008067          	ret

00000144 <zoomOut>:
zoomOut():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50

void zoomOut(void){
 144:	fe010113          	addi	sp,sp,-32
 148:	00812e23          	sw	s0,28(sp)
 14c:	02010413          	addi	s0,sp,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    if(scale == 0) return;
 150:	80c1c783          	lbu	a5,-2036(gp) # 888 <scale>
 154:	1a078263          	beqz	a5,2f8 <zoomOut+0x1b4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    scale --;
 158:	80c1c783          	lbu	a5,-2036(gp) # 888 <scale>
 15c:	fff78793          	addi	a5,a5,-1
 160:	0ff7f713          	andi	a4,a5,255
 164:	80e18623          	sb	a4,-2036(gp) # 888 <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:53
    if(scale == 0){
 168:	80c1c783          	lbu	a5,-2036(gp) # 888 <scale>
 16c:	02079463          	bnez	a5,194 <zoomOut+0x50>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
        xStart = QP_X_MIN;
 170:	000017b7          	lui	a5,0x1
 174:	fa03a737          	lui	a4,0xfa03a
 178:	99a70713          	addi	a4,a4,-1638 # fa03999a <__stack_top+0xfa02999a>
 17c:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:55
        yStart = QP_Y_MIN;
 180:	000017b7          	lui	a5,0x1
 184:	fca3a737          	lui	a4,0xfca3a
 188:	99a70713          	addi	a4,a4,-1638 # fca3999a <__stack_top+0xfca2999a>
 18c:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
        return;
 190:	16c0006f          	j	2fc <zoomOut+0x1b8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:58
    }
    int32_t dx = DX_SCALE[scale];
 194:	80c1c783          	lbu	a5,-2036(gp) # 888 <scale>
 198:	00078693          	mv	a3,a5
 19c:	000017b7          	lui	a5,0x1
 1a0:	80478713          	addi	a4,a5,-2044 # 804 <DX_SCALE>
 1a4:	00269793          	slli	a5,a3,0x2
 1a8:	00f707b3          	add	a5,a4,a5
 1ac:	0007a783          	lw	a5,0(a5)
 1b0:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:59
    xStart = xStart - 160 * dx;
 1b4:	fec42703          	lw	a4,-20(s0)
 1b8:	00070793          	mv	a5,a4
 1bc:	00279793          	slli	a5,a5,0x2
 1c0:	00e787b3          	add	a5,a5,a4
 1c4:	00579793          	slli	a5,a5,0x5
 1c8:	40f00733          	neg	a4,a5
 1cc:	000017b7          	lui	a5,0x1
 1d0:	87c7a783          	lw	a5,-1924(a5) # 87c <xStart>
 1d4:	00f70733          	add	a4,a4,a5
 1d8:	000017b7          	lui	a5,0x1
 1dc:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    yStart = yStart - 120 * dx;
 1e0:	fec42703          	lw	a4,-20(s0)
 1e4:	00070793          	mv	a5,a4
 1e8:	00471713          	slli	a4,a4,0x4
 1ec:	40e787b3          	sub	a5,a5,a4
 1f0:	00379793          	slli	a5,a5,0x3
 1f4:	00078713          	mv	a4,a5
 1f8:	000017b7          	lui	a5,0x1
 1fc:	8807a783          	lw	a5,-1920(a5) # 880 <yStart>
 200:	00f70733          	add	a4,a4,a5
 204:	000017b7          	lui	a5,0x1
 208:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    // check max bounds
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 20c:	fec42703          	lw	a4,-20(s0)
 210:	00070793          	mv	a5,a4
 214:	00279793          	slli	a5,a5,0x2
 218:	00e787b3          	add	a5,a5,a4
 21c:	00779793          	slli	a5,a5,0x7
 220:	40e78733          	sub	a4,a5,a4
 224:	000017b7          	lui	a5,0x1
 228:	87c7a783          	lw	a5,-1924(a5) # 87c <xStart>
 22c:	00f70733          	add	a4,a4,a5
 230:	02fc67b7          	lui	a5,0x2fc6
 234:	66678793          	addi	a5,a5,1638 # 2fc6666 <__stack_top+0x2fb6666>
 238:	02e7d263          	bge	a5,a4,25c <zoomOut+0x118>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62 (discriminator 1)
 23c:	fec42703          	lw	a4,-20(s0)
 240:	d8100793          	li	a5,-639
 244:	02f70733          	mul	a4,a4,a5
 248:	02fc67b7          	lui	a5,0x2fc6
 24c:	66678793          	addi	a5,a5,1638 # 2fc6666 <__stack_top+0x2fb6666>
 250:	00f70733          	add	a4,a4,a5
 254:	000017b7          	lui	a5,0x1
 258:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:63
    if(yStart + 479 * dx > QP_Y_MAX) yStart = QP_Y_MAX - 479 * dx;
 25c:	fec42703          	lw	a4,-20(s0)
 260:	00070793          	mv	a5,a4
 264:	00479793          	slli	a5,a5,0x4
 268:	40e787b3          	sub	a5,a5,a4
 26c:	00579793          	slli	a5,a5,0x5
 270:	40e78733          	sub	a4,a5,a4
 274:	000017b7          	lui	a5,0x1
 278:	8807a783          	lw	a5,-1920(a5) # 880 <yStart>
 27c:	00f70733          	add	a4,a4,a5
 280:	035c67b7          	lui	a5,0x35c6
 284:	66678793          	addi	a5,a5,1638 # 35c6666 <__stack_top+0x35b6666>
 288:	02e7d263          	bge	a5,a4,2ac <zoomOut+0x168>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:63 (discriminator 1)
 28c:	fec42703          	lw	a4,-20(s0)
 290:	e2100793          	li	a5,-479
 294:	02f70733          	mul	a4,a4,a5
 298:	035c67b7          	lui	a5,0x35c6
 29c:	66678793          	addi	a5,a5,1638 # 35c6666 <__stack_top+0x35b6666>
 2a0:	00f70733          	add	a4,a4,a5
 2a4:	000017b7          	lui	a5,0x1
 2a8:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    // check min bounds
    if(xStart < QP_X_MIN) xStart = QP_X_MIN;
 2ac:	000017b7          	lui	a5,0x1
 2b0:	87c7a703          	lw	a4,-1924(a5) # 87c <xStart>
 2b4:	fa03a7b7          	lui	a5,0xfa03a
 2b8:	99a78793          	addi	a5,a5,-1638 # fa03999a <__stack_top+0xfa02999a>
 2bc:	00f75a63          	bge	a4,a5,2d0 <zoomOut+0x18c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65 (discriminator 1)
 2c0:	000017b7          	lui	a5,0x1
 2c4:	fa03a737          	lui	a4,0xfa03a
 2c8:	99a70713          	addi	a4,a4,-1638 # fa03999a <__stack_top+0xfa02999a>
 2cc:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:66
    if(yStart < QP_Y_MIN) yStart = QP_Y_MIN;
 2d0:	000017b7          	lui	a5,0x1
 2d4:	8807a703          	lw	a4,-1920(a5) # 880 <yStart>
 2d8:	fca3a7b7          	lui	a5,0xfca3a
 2dc:	99a78793          	addi	a5,a5,-1638 # fca3999a <__stack_top+0xfca2999a>
 2e0:	00f75e63          	bge	a4,a5,2fc <zoomOut+0x1b8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:66 (discriminator 1)
 2e4:	000017b7          	lui	a5,0x1
 2e8:	fca3a737          	lui	a4,0xfca3a
 2ec:	99a70713          	addi	a4,a4,-1638 # fca3999a <__stack_top+0xfca2999a>
 2f0:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
 2f4:	0080006f          	j	2fc <zoomOut+0x1b8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    if(scale == 0) return;
 2f8:	00000013          	nop
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
}
 2fc:	01c12403          	lw	s0,28(sp)
 300:	02010113          	addi	sp,sp,32
 304:	00008067          	ret

00000308 <moveFrame>:
moveFrame():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:69

void moveFrame(uint8_t dirs){
 308:	fd010113          	addi	sp,sp,-48
 30c:	02812623          	sw	s0,44(sp)
 310:	03010413          	addi	s0,sp,48
 314:	00050793          	mv	a5,a0
 318:	fcf40fa3          	sb	a5,-33(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:70
    int32_t dx = DX_SCALE[scale];
 31c:	80c1c783          	lbu	a5,-2036(gp) # 888 <scale>
 320:	00078693          	mv	a3,a5
 324:	000017b7          	lui	a5,0x1
 328:	80478713          	addi	a4,a5,-2044 # 804 <DX_SCALE>
 32c:	00269793          	slli	a5,a3,0x2
 330:	00f707b3          	add	a5,a4,a5
 334:	0007a783          	lw	a5,0(a5)
 338:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:71
    if(dirs & UP){
 33c:	fdf44783          	lbu	a5,-33(s0)
 340:	0027f793          	andi	a5,a5,2
 344:	02078263          	beqz	a5,368 <moveFrame+0x60>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
        yStart += dx << MOVEPOWER;
 348:	fec42783          	lw	a5,-20(s0)
 34c:	00679713          	slli	a4,a5,0x6
 350:	000017b7          	lui	a5,0x1
 354:	8807a783          	lw	a5,-1920(a5) # 880 <yStart>
 358:	00f70733          	add	a4,a4,a5
 35c:	000017b7          	lui	a5,0x1
 360:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
 364:	02c0006f          	j	390 <moveFrame+0x88>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:73
    }else if(dirs & DOWN){
 368:	fdf44783          	lbu	a5,-33(s0)
 36c:	0047f793          	andi	a5,a5,4
 370:	02078063          	beqz	a5,390 <moveFrame+0x88>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:74
        yStart -= dx << MOVEPOWER;
 374:	000017b7          	lui	a5,0x1
 378:	8807a703          	lw	a4,-1920(a5) # 880 <yStart>
 37c:	fec42783          	lw	a5,-20(s0)
 380:	00679793          	slli	a5,a5,0x6
 384:	40f70733          	sub	a4,a4,a5
 388:	000017b7          	lui	a5,0x1
 38c:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:76
    }
    if(dirs & RIGHT){
 390:	fdf44783          	lbu	a5,-33(s0)
 394:	0017f793          	andi	a5,a5,1
 398:	02078263          	beqz	a5,3bc <moveFrame+0xb4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:77
        xStart += dx << MOVEPOWER;
 39c:	fec42783          	lw	a5,-20(s0)
 3a0:	00679713          	slli	a4,a5,0x6
 3a4:	000017b7          	lui	a5,0x1
 3a8:	87c7a783          	lw	a5,-1924(a5) # 87c <xStart>
 3ac:	00f70733          	add	a4,a4,a5
 3b0:	000017b7          	lui	a5,0x1
 3b4:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
 3b8:	02c0006f          	j	3e4 <moveFrame+0xdc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:78
    }else if(dirs & LEFT){
 3bc:	fdf44783          	lbu	a5,-33(s0)
 3c0:	0087f793          	andi	a5,a5,8
 3c4:	02078063          	beqz	a5,3e4 <moveFrame+0xdc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:79
        xStart -= dx << MOVEPOWER;
 3c8:	000017b7          	lui	a5,0x1
 3cc:	87c7a703          	lw	a4,-1924(a5) # 87c <xStart>
 3d0:	fec42783          	lw	a5,-20(s0)
 3d4:	00679793          	slli	a5,a5,0x6
 3d8:	40f70733          	sub	a4,a4,a5
 3dc:	000017b7          	lui	a5,0x1
 3e0:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:82
    }
    // check max bounds
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 3e4:	fec42703          	lw	a4,-20(s0)
 3e8:	00070793          	mv	a5,a4
 3ec:	00279793          	slli	a5,a5,0x2
 3f0:	00e787b3          	add	a5,a5,a4
 3f4:	00779793          	slli	a5,a5,0x7
 3f8:	40e78733          	sub	a4,a5,a4
 3fc:	000017b7          	lui	a5,0x1
 400:	87c7a783          	lw	a5,-1924(a5) # 87c <xStart>
 404:	00f70733          	add	a4,a4,a5
 408:	02fc67b7          	lui	a5,0x2fc6
 40c:	66678793          	addi	a5,a5,1638 # 2fc6666 <__stack_top+0x2fb6666>
 410:	02e7d263          	bge	a5,a4,434 <moveFrame+0x12c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:82 (discriminator 1)
 414:	fec42703          	lw	a4,-20(s0)
 418:	d8100793          	li	a5,-639
 41c:	02f70733          	mul	a4,a4,a5
 420:	02fc67b7          	lui	a5,0x2fc6
 424:	66678793          	addi	a5,a5,1638 # 2fc6666 <__stack_top+0x2fb6666>
 428:	00f70733          	add	a4,a4,a5
 42c:	000017b7          	lui	a5,0x1
 430:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:83
    if(yStart + 479 * dx > QP_Y_MAX) yStart = QP_Y_MAX - 479 * dx;
 434:	fec42703          	lw	a4,-20(s0)
 438:	00070793          	mv	a5,a4
 43c:	00479793          	slli	a5,a5,0x4
 440:	40e787b3          	sub	a5,a5,a4
 444:	00579793          	slli	a5,a5,0x5
 448:	40e78733          	sub	a4,a5,a4
 44c:	000017b7          	lui	a5,0x1
 450:	8807a783          	lw	a5,-1920(a5) # 880 <yStart>
 454:	00f70733          	add	a4,a4,a5
 458:	035c67b7          	lui	a5,0x35c6
 45c:	66678793          	addi	a5,a5,1638 # 35c6666 <__stack_top+0x35b6666>
 460:	02e7d263          	bge	a5,a4,484 <moveFrame+0x17c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:83 (discriminator 1)
 464:	fec42703          	lw	a4,-20(s0)
 468:	e2100793          	li	a5,-479
 46c:	02f70733          	mul	a4,a4,a5
 470:	035c67b7          	lui	a5,0x35c6
 474:	66678793          	addi	a5,a5,1638 # 35c6666 <__stack_top+0x35b6666>
 478:	00f70733          	add	a4,a4,a5
 47c:	000017b7          	lui	a5,0x1
 480:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:85
    // check min bounds
    if(xStart < QP_X_MIN) xStart = QP_X_MIN;
 484:	000017b7          	lui	a5,0x1
 488:	87c7a703          	lw	a4,-1924(a5) # 87c <xStart>
 48c:	fa03a7b7          	lui	a5,0xfa03a
 490:	99a78793          	addi	a5,a5,-1638 # fa03999a <__stack_top+0xfa02999a>
 494:	00f75a63          	bge	a4,a5,4a8 <moveFrame+0x1a0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:85 (discriminator 1)
 498:	000017b7          	lui	a5,0x1
 49c:	fa03a737          	lui	a4,0xfa03a
 4a0:	99a70713          	addi	a4,a4,-1638 # fa03999a <__stack_top+0xfa02999a>
 4a4:	86e7ae23          	sw	a4,-1924(a5) # 87c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:86
    if(yStart < QP_Y_MIN) yStart = QP_Y_MIN;
 4a8:	000017b7          	lui	a5,0x1
 4ac:	8807a703          	lw	a4,-1920(a5) # 880 <yStart>
 4b0:	fca3a7b7          	lui	a5,0xfca3a
 4b4:	99a78793          	addi	a5,a5,-1638 # fca3999a <__stack_top+0xfca2999a>
 4b8:	00f75a63          	bge	a4,a5,4cc <moveFrame+0x1c4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:86 (discriminator 1)
 4bc:	000017b7          	lui	a5,0x1
 4c0:	fca3a737          	lui	a4,0xfca3a
 4c4:	99a70713          	addi	a4,a4,-1638 # fca3999a <__stack_top+0xfca2999a>
 4c8:	88e7a023          	sw	a4,-1920(a5) # 880 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:87
}
 4cc:	00000013          	nop
 4d0:	02c12403          	lw	s0,44(sp)
 4d4:	03010113          	addi	sp,sp,48
 4d8:	00008067          	ret

000004dc <getIters>:
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:89

uint8_t getIters(int32_t x0, int32_t y0){
 4dc:	fc010113          	addi	sp,sp,-64
 4e0:	02112e23          	sw	ra,60(sp)
 4e4:	02812c23          	sw	s0,56(sp)
 4e8:	04010413          	addi	s0,sp,64
 4ec:	fca42623          	sw	a0,-52(s0)
 4f0:	fcb42423          	sw	a1,-56(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:90
    uint16_t maxIters = 255;
 4f4:	0ff00793          	li	a5,255
 4f8:	fef41223          	sh	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:91
    int32_t x = 0;
 4fc:	fe042623          	sw	zero,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:92
    int32_t y = 0;
 500:	fe042423          	sw	zero,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:93
    uint16_t iters = 0;
 504:	fe041323          	sh	zero,-26(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 508:	08c0006f          	j	594 <getIters+0xb8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:95
        int32_t xx = qmul(x, x);
 50c:	fec42583          	lw	a1,-20(s0)
 510:	fec42503          	lw	a0,-20(s0)
 514:	b05ff0ef          	jal	ra,18 <qmul>
 518:	fea42023          	sw	a0,-32(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:96
        int32_t yy = qmul(y, y);
 51c:	fe842583          	lw	a1,-24(s0)
 520:	fe842503          	lw	a0,-24(s0)
 524:	af5ff0ef          	jal	ra,18 <qmul>
 528:	fca42e23          	sw	a0,-36(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 52c:	fe042703          	lw	a4,-32(s0)
 530:	fdc42783          	lw	a5,-36(s0)
 534:	00f70733          	add	a4,a4,a5
 538:	100007b7          	lui	a5,0x10000
 53c:	06e7c463          	blt	a5,a4,5a4 <getIters+0xc8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
        int32_t newX = xx - yy + x0;
 540:	fe042703          	lw	a4,-32(s0)
 544:	fdc42783          	lw	a5,-36(s0)
 548:	40f707b3          	sub	a5,a4,a5
 54c:	fcc42703          	lw	a4,-52(s0)
 550:	00f707b3          	add	a5,a4,a5
 554:	fcf42c23          	sw	a5,-40(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
        int32_t newY = (qmul(x, y) << 1) + y0;
 558:	fe842583          	lw	a1,-24(s0)
 55c:	fec42503          	lw	a0,-20(s0)
 560:	ab9ff0ef          	jal	ra,18 <qmul>
 564:	00050793          	mv	a5,a0
 568:	00179793          	slli	a5,a5,0x1
 56c:	fc842703          	lw	a4,-56(s0)
 570:	00f707b3          	add	a5,a4,a5
 574:	fcf42a23          	sw	a5,-44(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:100
        x = newX;
 578:	fd842783          	lw	a5,-40(s0)
 57c:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:101
        y = newY;
 580:	fd442783          	lw	a5,-44(s0)
 584:	fef42423          	sw	a5,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 588:	fe645783          	lhu	a5,-26(s0)
 58c:	00178793          	addi	a5,a5,1 # 10000001 <__stack_top+0xfff0001>
 590:	fef41323          	sh	a5,-26(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94 (discriminator 1)
 594:	fe645703          	lhu	a4,-26(s0)
 598:	fe445783          	lhu	a5,-28(s0)
 59c:	f6e7f8e3          	bgeu	a5,a4,50c <getIters+0x30>
 5a0:	0080006f          	j	5a8 <getIters+0xcc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 5a4:	00000013          	nop
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
    }
    return iters;
 5a8:	fe645783          	lhu	a5,-26(s0)
 5ac:	0ff7f793          	andi	a5,a5,255
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:104
}
 5b0:	00078513          	mv	a0,a5
 5b4:	03c12083          	lw	ra,60(sp)
 5b8:	03812403          	lw	s0,56(sp)
 5bc:	04010113          	addi	sp,sp,64
 5c0:	00008067          	ret

000005c4 <drawMandel>:
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:106

void drawMandel(void){
 5c4:	fd010113          	addi	sp,sp,-48
 5c8:	02112623          	sw	ra,44(sp)
 5cc:	02812423          	sw	s0,40(sp)
 5d0:	03010413          	addi	s0,sp,48
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:107
    int32_t dx = DX_SCALE[scale];
 5d4:	80c1c783          	lbu	a5,-2036(gp) # 888 <scale>
 5d8:	00078693          	mv	a3,a5
 5dc:	000017b7          	lui	a5,0x1
 5e0:	80478713          	addi	a4,a5,-2044 # 804 <DX_SCALE>
 5e4:	00269793          	slli	a5,a3,0x2
 5e8:	00f707b3          	add	a5,a4,a5
 5ec:	0007a783          	lw	a5,0(a5)
 5f0:	fcf42e23          	sw	a5,-36(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:108
    int32_t y0 = yStart;
 5f4:	000017b7          	lui	a5,0x1
 5f8:	8807a783          	lw	a5,-1920(a5) # 880 <yStart>
 5fc:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:109
    for(size_t j = 0; j < 480; j++){
 600:	fe042423          	sw	zero,-24(s0)
 604:	0800006f          	j	684 <drawMandel+0xc0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:110
        int32_t x0 = xStart;
 608:	000017b7          	lui	a5,0x1
 60c:	87c7a783          	lw	a5,-1924(a5) # 87c <xStart>
 610:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111
        for(size_t i = 0; i < 640; i++){
 614:	fe042023          	sw	zero,-32(s0)
 618:	0440006f          	j	65c <drawMandel+0x98>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:112 (discriminator 3)
            uint8_t iters = getIters(x0, y0);
 61c:	fec42583          	lw	a1,-20(s0)
 620:	fe442503          	lw	a0,-28(s0)
 624:	eb9ff0ef          	jal	ra,4dc <getIters>
 628:	00050793          	mv	a5,a0
 62c:	fcf40da3          	sb	a5,-37(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:113 (discriminator 3)
            vgaHandle->pxlData = iters;
 630:	000017b7          	lui	a5,0x1
 634:	8847a783          	lw	a5,-1916(a5) # 884 <vgaHandle>
 638:	fdb44703          	lbu	a4,-37(s0)
 63c:	00e7a623          	sw	a4,12(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:114 (discriminator 3)
            x0 += dx;
 640:	fe442703          	lw	a4,-28(s0)
 644:	fdc42783          	lw	a5,-36(s0)
 648:	00f707b3          	add	a5,a4,a5
 64c:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111 (discriminator 3)
        for(size_t i = 0; i < 640; i++){
 650:	fe042783          	lw	a5,-32(s0)
 654:	00178793          	addi	a5,a5,1
 658:	fef42023          	sw	a5,-32(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111 (discriminator 1)
 65c:	fe042703          	lw	a4,-32(s0)
 660:	27f00793          	li	a5,639
 664:	fae7fce3          	bgeu	a5,a4,61c <drawMandel+0x58>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:116 (discriminator 2)
        }
        y0 += dx;
 668:	fec42703          	lw	a4,-20(s0)
 66c:	fdc42783          	lw	a5,-36(s0)
 670:	00f707b3          	add	a5,a4,a5
 674:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:109 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 678:	fe842783          	lw	a5,-24(s0)
 67c:	00178793          	addi	a5,a5,1
 680:	fef42423          	sw	a5,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:109 (discriminator 1)
 684:	fe842703          	lw	a4,-24(s0)
 688:	1df00793          	li	a5,479
 68c:	f6e7fee3          	bgeu	a5,a4,608 <drawMandel+0x44>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:118
    }
}
 690:	00000013          	nop
 694:	00000013          	nop
 698:	02c12083          	lw	ra,44(sp)
 69c:	02812403          	lw	s0,40(sp)
 6a0:	03010113          	addi	sp,sp,48
 6a4:	00008067          	ret

000006a8 <setPalette0>:
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:120

void setPalette0(void){ // greyscale
 6a8:	fe010113          	addi	sp,sp,-32
 6ac:	00812e23          	sw	s0,28(sp)
 6b0:	02010413          	addi	s0,sp,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:122
    // set palette address
    vgaHandle->pAddr = 0;
 6b4:	000017b7          	lui	a5,0x1
 6b8:	8847a783          	lw	a5,-1916(a5) # 884 <vgaHandle>
 6bc:	0007a823          	sw	zero,16(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:123
    for(size_t i = 0; i < 255; i++){
 6c0:	fe042623          	sw	zero,-20(s0)
 6c4:	0500006f          	j	714 <setPalette0+0x6c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:124 (discriminator 3)
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
 6c8:	0ff00713          	li	a4,255
 6cc:	fec42783          	lw	a5,-20(s0)
 6d0:	40f707b3          	sub	a5,a4,a5
 6d4:	01079713          	slli	a4,a5,0x10
 6d8:	0ff00693          	li	a3,255
 6dc:	fec42783          	lw	a5,-20(s0)
 6e0:	40f687b3          	sub	a5,a3,a5
 6e4:	00879793          	slli	a5,a5,0x8
 6e8:	00f766b3          	or	a3,a4,a5
 6ec:	0ff00713          	li	a4,255
 6f0:	fec42783          	lw	a5,-20(s0)
 6f4:	40f70733          	sub	a4,a4,a5
 6f8:	000017b7          	lui	a5,0x1
 6fc:	8847a783          	lw	a5,-1916(a5) # 884 <vgaHandle>
 700:	00e6e733          	or	a4,a3,a4
 704:	00e7aa23          	sw	a4,20(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:123 (discriminator 3)
    for(size_t i = 0; i < 255; i++){
 708:	fec42783          	lw	a5,-20(s0)
 70c:	00178793          	addi	a5,a5,1
 710:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:123 (discriminator 1)
 714:	fec42703          	lw	a4,-20(s0)
 718:	0fe00793          	li	a5,254
 71c:	fae7f6e3          	bgeu	a5,a4,6c8 <setPalette0+0x20>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126
    }
}
 720:	00000013          	nop
 724:	00000013          	nop
 728:	01c12403          	lw	s0,28(sp)
 72c:	02010113          	addi	sp,sp,32
 730:	00008067          	ret

00000734 <setPalette1>:
setPalette1():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:128

void setPalette1(void){ // cherenkov
 734:	fe010113          	addi	sp,sp,-32
 738:	00812e23          	sw	s0,28(sp)
 73c:	02010413          	addi	s0,sp,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:132
    // predefined data
    
    // set palette address
    vgaHandle->pAddr = 0;
 740:	000017b7          	lui	a5,0x1
 744:	8847a783          	lw	a5,-1916(a5) # 884 <vgaHandle>
 748:	0007a823          	sw	zero,16(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:133
    for(size_t i = 0; i < 255; i++){
 74c:	fe042623          	sw	zero,-20(s0)
 750:	0500006f          	j	7a0 <setPalette1+0x6c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:134 (discriminator 3)
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
 754:	0ff00713          	li	a4,255
 758:	fec42783          	lw	a5,-20(s0)
 75c:	40f707b3          	sub	a5,a4,a5
 760:	01079713          	slli	a4,a5,0x10
 764:	0ff00693          	li	a3,255
 768:	fec42783          	lw	a5,-20(s0)
 76c:	40f687b3          	sub	a5,a3,a5
 770:	00879793          	slli	a5,a5,0x8
 774:	00f766b3          	or	a3,a4,a5
 778:	0ff00713          	li	a4,255
 77c:	fec42783          	lw	a5,-20(s0)
 780:	40f70733          	sub	a4,a4,a5
 784:	000017b7          	lui	a5,0x1
 788:	8847a783          	lw	a5,-1916(a5) # 884 <vgaHandle>
 78c:	00e6e733          	or	a4,a3,a4
 790:	00e7aa23          	sw	a4,20(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:133 (discriminator 3)
    for(size_t i = 0; i < 255; i++){
 794:	fec42783          	lw	a5,-20(s0)
 798:	00178793          	addi	a5,a5,1
 79c:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:133 (discriminator 1)
 7a0:	fec42703          	lw	a4,-20(s0)
 7a4:	0fe00793          	li	a5,254
 7a8:	fae7f6e3          	bgeu	a5,a4,754 <setPalette1+0x20>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:136
    }
}
 7ac:	00000013          	nop
 7b0:	00000013          	nop
 7b4:	01c12403          	lw	s0,28(sp)
 7b8:	02010113          	addi	sp,sp,32
 7bc:	00008067          	ret

000007c0 <main>:
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:138

int main(void){
 7c0:	ff010113          	addi	sp,sp,-16
 7c4:	00112623          	sw	ra,12(sp)
 7c8:	00812423          	sw	s0,8(sp)
 7cc:	01010413          	addi	s0,sp,16
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:140
    // enable video
    vgaHandle->en = 1;
 7d0:	000017b7          	lui	a5,0x1
 7d4:	8847a783          	lw	a5,-1916(a5) # 884 <vgaHandle>
 7d8:	00100713          	li	a4,1
 7dc:	00e7a023          	sw	a4,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:142
    // set palette
    setPalette0();
 7e0:	ec9ff0ef          	jal	ra,6a8 <setPalette0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:144
    // set pixel address to 0
    vgaHandle->xAddr = 0;
 7e4:	000017b7          	lui	a5,0x1
 7e8:	8847a783          	lw	a5,-1916(a5) # 884 <vgaHandle>
 7ec:	0007a223          	sw	zero,4(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:145
    vgaHandle->yAddr = 0;
 7f0:	000017b7          	lui	a5,0x1
 7f4:	8847a783          	lw	a5,-1916(a5) # 884 <vgaHandle>
 7f8:	0007a423          	sw	zero,8(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:147
    // draw
    drawMandel();
 7fc:	dc9ff0ef          	jal	ra,5c4 <drawMandel>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:148 (discriminator 1)
    for(;;);
 800:	0000006f          	j	800 <main+0x40>
