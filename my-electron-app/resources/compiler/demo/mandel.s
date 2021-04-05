
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
   4:	cc018193          	addi	gp,gp,-832 # cc0 <__global_pointer$>
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
  14:	3c00006f          	j	3d4 <main>

Disassembly of section .text:

00000018 <qmul>:
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:15
#define QP_0_75 50331648L
#define QP_INV_640 104858L

volatile Vga_t* vgaHandle = (void*) 0x80000000;

int32_t qmul(int32_t a, int32_t b){
  18:	fe010113          	addi	sp,sp,-32
  1c:	00812e23          	sw	s0,28(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	feb42423          	sw	a1,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
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
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:17
}
  80:	00078513          	mv	a0,a5
  84:	01c12403          	lw	s0,28(sp)
  88:	02010113          	addi	sp,sp,32
  8c:	00008067          	ret

00000090 <getIters>:
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:19

uint8_t getIters(int32_t x0, int32_t y0){
  90:	fc010113          	addi	sp,sp,-64
  94:	02112e23          	sw	ra,60(sp)
  98:	02812c23          	sw	s0,56(sp)
  9c:	04010413          	addi	s0,sp,64
  a0:	fca42623          	sw	a0,-52(s0)
  a4:	fcb42423          	sw	a1,-56(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:20
    uint16_t maxIters = 255;
  a8:	0ff00793          	li	a5,255
  ac:	fef41223          	sh	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:21
    int32_t x = 0;
  b0:	fe042623          	sw	zero,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:22
    int32_t y = 0;
  b4:	fe042423          	sw	zero,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:23
    uint16_t iters = 0;
  b8:	fe041323          	sh	zero,-26(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
  bc:	08c0006f          	j	148 <getIters+0xb8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:25
        int32_t xx = qmul(x, x);
  c0:	fec42583          	lw	a1,-20(s0)
  c4:	fec42503          	lw	a0,-20(s0)
  c8:	f51ff0ef          	jal	ra,18 <qmul>
  cc:	fea42023          	sw	a0,-32(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:26
        int32_t yy = qmul(y, y);
  d0:	fe842583          	lw	a1,-24(s0)
  d4:	fe842503          	lw	a0,-24(s0)
  d8:	f41ff0ef          	jal	ra,18 <qmul>
  dc:	fca42e23          	sw	a0,-36(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:27
        if(xx + yy > QP_4) break;
  e0:	fe042703          	lw	a4,-32(s0)
  e4:	fdc42783          	lw	a5,-36(s0)
  e8:	00f70733          	add	a4,a4,a5
  ec:	100007b7          	lui	a5,0x10000
  f0:	06e7c463          	blt	a5,a4,158 <getIters+0xc8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:28
        int32_t newX = xx - yy + x0;
  f4:	fe042703          	lw	a4,-32(s0)
  f8:	fdc42783          	lw	a5,-36(s0)
  fc:	40f707b3          	sub	a5,a4,a5
 100:	fcc42703          	lw	a4,-52(s0)
 104:	00f707b3          	add	a5,a4,a5
 108:	fcf42c23          	sw	a5,-40(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:29
        int32_t newY = (qmul(x, y) << 1) + y0;
 10c:	fe842583          	lw	a1,-24(s0)
 110:	fec42503          	lw	a0,-20(s0)
 114:	f05ff0ef          	jal	ra,18 <qmul>
 118:	00050793          	mv	a5,a0
 11c:	00179793          	slli	a5,a5,0x1
 120:	fc842703          	lw	a4,-56(s0)
 124:	00f707b3          	add	a5,a4,a5
 128:	fcf42a23          	sw	a5,-44(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:30
        x = newX;
 12c:	fd842783          	lw	a5,-40(s0)
 130:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:31
        y = newY;
 134:	fd442783          	lw	a5,-44(s0)
 138:	fef42423          	sw	a5,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 13c:	fe645783          	lhu	a5,-26(s0)
 140:	00178793          	addi	a5,a5,1 # 10000001 <__stack_top+0xfff0001>
 144:	fef41323          	sh	a5,-26(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24 (discriminator 1)
 148:	fe645703          	lhu	a4,-26(s0)
 14c:	fe445783          	lhu	a5,-28(s0)
 150:	f6e7f8e3          	bgeu	a5,a4,c0 <getIters+0x30>
 154:	0080006f          	j	15c <getIters+0xcc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:27
        if(xx + yy > QP_4) break;
 158:	00000013          	nop
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:33
    }
    return iters;
 15c:	fe645783          	lhu	a5,-26(s0)
 160:	0ff7f793          	andi	a5,a5,255
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:34
}
 164:	00078513          	mv	a0,a5
 168:	03c12083          	lw	ra,60(sp)
 16c:	03812403          	lw	s0,56(sp)
 170:	04010113          	addi	sp,sp,64
 174:	00008067          	ret

00000178 <drawMandel>:
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:36

void drawMandel(int32_t xMin, int32_t xMax, int32_t yMin, int32_t yMax){
 178:	fc010113          	addi	sp,sp,-64
 17c:	02112e23          	sw	ra,60(sp)
 180:	02812c23          	sw	s0,56(sp)
 184:	04010413          	addi	s0,sp,64
 188:	fca42623          	sw	a0,-52(s0)
 18c:	fcb42423          	sw	a1,-56(s0)
 190:	fcc42223          	sw	a2,-60(s0)
 194:	fcd42023          	sw	a3,-64(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:37
    int32_t dx = qmul(xMax - xMin, QP_INV_640);
 198:	fc842703          	lw	a4,-56(s0)
 19c:	fcc42783          	lw	a5,-52(s0)
 1a0:	40f70733          	sub	a4,a4,a5
 1a4:	0001a7b7          	lui	a5,0x1a
 1a8:	99a78593          	addi	a1,a5,-1638 # 1999a <__stack_top+0x999a>
 1ac:	00070513          	mv	a0,a4
 1b0:	e69ff0ef          	jal	ra,18 <qmul>
 1b4:	fca42e23          	sw	a0,-36(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:38
    int32_t xStart = xMin + (dx >> 1);
 1b8:	fdc42783          	lw	a5,-36(s0)
 1bc:	4017d793          	srai	a5,a5,0x1
 1c0:	fcc42703          	lw	a4,-52(s0)
 1c4:	00f707b3          	add	a5,a4,a5
 1c8:	fcf42c23          	sw	a5,-40(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    int32_t yStart = yMin + (dx >> 1);
 1cc:	fdc42783          	lw	a5,-36(s0)
 1d0:	4017d793          	srai	a5,a5,0x1
 1d4:	fc442703          	lw	a4,-60(s0)
 1d8:	00f707b3          	add	a5,a4,a5
 1dc:	fcf42a23          	sw	a5,-44(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:40
    int32_t y0 = yStart;
 1e0:	fd442783          	lw	a5,-44(s0)
 1e4:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41
    for(size_t j = 0; j < 480; j++){
 1e8:	fe042423          	sw	zero,-24(s0)
 1ec:	0dc0006f          	j	2c8 <drawMandel+0x150>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:42
        int32_t x0 = xStart;
 1f0:	fd842783          	lw	a5,-40(s0)
 1f4:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
        for(size_t i = 0; i < 640; i++){
 1f8:	fe042023          	sw	zero,-32(s0)
 1fc:	0a40006f          	j	2a0 <drawMandel+0x128>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44 (discriminator 3)
            uint8_t iters = getIters(x0, y0);
 200:	fec42583          	lw	a1,-20(s0)
 204:	fe442503          	lw	a0,-28(s0)
 208:	e89ff0ef          	jal	ra,90 <getIters>
 20c:	00050793          	mv	a5,a0
 210:	fcf409a3          	sb	a5,-45(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45 (discriminator 3)
            vgaHandle->pxlData = iters;
 214:	4c002783          	lw	a5,1216(zero) # 4c0 <vgaHandle>
 218:	fd344703          	lbu	a4,-45(s0)
 21c:	010006b7          	lui	a3,0x1000
 220:	fff68693          	addi	a3,a3,-1 # ffffff <__stack_top+0xfeffff>
 224:	00d77733          	and	a4,a4,a3
 228:	0ff77593          	andi	a1,a4,255
 22c:	00d7c683          	lbu	a3,13(a5)
 230:	0006f693          	andi	a3,a3,0
 234:	00068613          	mv	a2,a3
 238:	00058693          	mv	a3,a1
 23c:	00d666b3          	or	a3,a2,a3
 240:	00d786a3          	sb	a3,13(a5)
 244:	00875693          	srli	a3,a4,0x8
 248:	0ff6f593          	andi	a1,a3,255
 24c:	00e7c683          	lbu	a3,14(a5)
 250:	0006f693          	andi	a3,a3,0
 254:	00068613          	mv	a2,a3
 258:	00058693          	mv	a3,a1
 25c:	00d666b3          	or	a3,a2,a3
 260:	00d78723          	sb	a3,14(a5)
 264:	01075713          	srli	a4,a4,0x10
 268:	0ff77613          	andi	a2,a4,255
 26c:	00f7c703          	lbu	a4,15(a5)
 270:	00077713          	andi	a4,a4,0
 274:	00070693          	mv	a3,a4
 278:	00060713          	mv	a4,a2
 27c:	00e6e733          	or	a4,a3,a4
 280:	00e787a3          	sb	a4,15(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46 (discriminator 3)
            x0 += dx;
 284:	fe442703          	lw	a4,-28(s0)
 288:	fdc42783          	lw	a5,-36(s0)
 28c:	00f707b3          	add	a5,a4,a5
 290:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43 (discriminator 3)
        for(size_t i = 0; i < 640; i++){
 294:	fe042783          	lw	a5,-32(s0)
 298:	00178793          	addi	a5,a5,1
 29c:	fef42023          	sw	a5,-32(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43 (discriminator 1)
 2a0:	fe042703          	lw	a4,-32(s0)
 2a4:	27f00793          	li	a5,639
 2a8:	f4e7fce3          	bgeu	a5,a4,200 <drawMandel+0x88>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48 (discriminator 2)
        }
        y0 += dx;
 2ac:	fec42703          	lw	a4,-20(s0)
 2b0:	fdc42783          	lw	a5,-36(s0)
 2b4:	00f707b3          	add	a5,a4,a5
 2b8:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 2bc:	fe842783          	lw	a5,-24(s0)
 2c0:	00178793          	addi	a5,a5,1
 2c4:	fef42423          	sw	a5,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41 (discriminator 1)
 2c8:	fe842703          	lw	a4,-24(s0)
 2cc:	1df00793          	li	a5,479
 2d0:	f2e7f0e3          	bgeu	a5,a4,1f0 <drawMandel+0x78>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    }
}
 2d4:	00000013          	nop
 2d8:	00000013          	nop
 2dc:	03c12083          	lw	ra,60(sp)
 2e0:	03812403          	lw	s0,56(sp)
 2e4:	04010113          	addi	sp,sp,64
 2e8:	00008067          	ret

000002ec <setPalette0>:
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52

void setPalette0(){
 2ec:	fe010113          	addi	sp,sp,-32
 2f0:	00812e23          	sw	s0,28(sp)
 2f4:	02010413          	addi	s0,sp,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
    // set palette address
    vgaHandle->pAddr = 0;
 2f8:	4c002783          	lw	a5,1216(zero) # 4c0 <vgaHandle>
 2fc:	000789a3          	sb	zero,19(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:55
    for(size_t i = 0; i < 255; i++){
 300:	fe042623          	sw	zero,-20(s0)
 304:	0b00006f          	j	3b4 <setPalette0+0xc8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56 (discriminator 3)
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
 308:	0ff00713          	li	a4,255
 30c:	fec42783          	lw	a5,-20(s0)
 310:	40f707b3          	sub	a5,a4,a5
 314:	01079713          	slli	a4,a5,0x10
 318:	0ff00693          	li	a3,255
 31c:	fec42783          	lw	a5,-20(s0)
 320:	40f687b3          	sub	a5,a3,a5
 324:	00879793          	slli	a5,a5,0x8
 328:	00f76733          	or	a4,a4,a5
 32c:	0ff00693          	li	a3,255
 330:	fec42783          	lw	a5,-20(s0)
 334:	40f687b3          	sub	a5,a3,a5
 338:	00f766b3          	or	a3,a4,a5
 33c:	4c002783          	lw	a5,1216(zero) # 4c0 <vgaHandle>
 340:	01000737          	lui	a4,0x1000
 344:	fff70713          	addi	a4,a4,-1 # ffffff <__stack_top+0xfeffff>
 348:	00e6f733          	and	a4,a3,a4
 34c:	0ff77593          	andi	a1,a4,255
 350:	0157c683          	lbu	a3,21(a5)
 354:	0006f693          	andi	a3,a3,0
 358:	00068613          	mv	a2,a3
 35c:	00058693          	mv	a3,a1
 360:	00d666b3          	or	a3,a2,a3
 364:	00d78aa3          	sb	a3,21(a5)
 368:	00875693          	srli	a3,a4,0x8
 36c:	0ff6f593          	andi	a1,a3,255
 370:	0167c683          	lbu	a3,22(a5)
 374:	0006f693          	andi	a3,a3,0
 378:	00068613          	mv	a2,a3
 37c:	00058693          	mv	a3,a1
 380:	00d666b3          	or	a3,a2,a3
 384:	00d78b23          	sb	a3,22(a5)
 388:	01075713          	srli	a4,a4,0x10
 38c:	0ff77613          	andi	a2,a4,255
 390:	0177c703          	lbu	a4,23(a5)
 394:	00077713          	andi	a4,a4,0
 398:	00070693          	mv	a3,a4
 39c:	00060713          	mv	a4,a2
 3a0:	00e6e733          	or	a4,a3,a4
 3a4:	00e78ba3          	sb	a4,23(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:55 (discriminator 3)
    for(size_t i = 0; i < 255; i++){
 3a8:	fec42783          	lw	a5,-20(s0)
 3ac:	00178793          	addi	a5,a5,1
 3b0:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:55 (discriminator 1)
 3b4:	fec42703          	lw	a4,-20(s0)
 3b8:	0fe00793          	li	a5,254
 3bc:	f4e7f6e3          	bgeu	a5,a4,308 <setPalette0+0x1c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:58
    }
}
 3c0:	00000013          	nop
 3c4:	00000013          	nop
 3c8:	01c12403          	lw	s0,28(sp)
 3cc:	02010113          	addi	sp,sp,32
 3d0:	00008067          	ret

000003d4 <main>:
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60

int main(){
 3d4:	fd010113          	addi	sp,sp,-48
 3d8:	02112623          	sw	ra,44(sp)
 3dc:	02812423          	sw	s0,40(sp)
 3e0:	03010413          	addi	s0,sp,48
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    // enable video
    vgaHandle->en = 1;
 3e4:	4c002783          	lw	a5,1216(zero) # 4c0 <vgaHandle>
 3e8:	0037c703          	lbu	a4,3(a5)
 3ec:	f8076713          	ori	a4,a4,-128
 3f0:	00e781a3          	sb	a4,3(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    // set palette
    setPalette0();
 3f4:	ef9ff0ef          	jal	ra,2ec <setPalette0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:66
    // set pixel address to 0
    vgaHandle->xAddr = 0;
 3f8:	4c002783          	lw	a5,1216(zero) # 4c0 <vgaHandle>
 3fc:	0067c703          	lbu	a4,6(a5)
 400:	01f77713          	andi	a4,a4,31
 404:	00e78323          	sb	a4,6(a5)
 408:	0077c703          	lbu	a4,7(a5)
 40c:	00077713          	andi	a4,a4,0
 410:	00e783a3          	sb	a4,7(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
    vgaHandle->yAddr = 0;
 414:	4c002783          	lw	a5,1216(zero) # 4c0 <vgaHandle>
 418:	00a7c703          	lbu	a4,10(a5)
 41c:	03f77713          	andi	a4,a4,63
 420:	00e78523          	sb	a4,10(a5)
 424:	00b7c703          	lbu	a4,11(a5)
 428:	00077713          	andi	a4,a4,0
 42c:	00e785a3          	sb	a4,11(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:69
    // draw
    int32_t xMin = QP_NEG_1_5;
 430:	fa0007b7          	lui	a5,0xfa000
 434:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:70
    int32_t xMax = QP_0_75;
 438:	030007b7          	lui	a5,0x3000
 43c:	fef42423          	sw	a5,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:71
    int32_t ySpan = ((xMax - xMin) * 3) >> 2;
 440:	fe842703          	lw	a4,-24(s0)
 444:	fec42783          	lw	a5,-20(s0)
 448:	40f70733          	sub	a4,a4,a5
 44c:	00070793          	mv	a5,a4
 450:	00179793          	slli	a5,a5,0x1
 454:	00e787b3          	add	a5,a5,a4
 458:	4027d793          	srai	a5,a5,0x2
 45c:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
    int32_t yMin = -(ySpan >> 1);
 460:	fe442783          	lw	a5,-28(s0)
 464:	4017d793          	srai	a5,a5,0x1
 468:	40f007b3          	neg	a5,a5
 46c:	fef42023          	sw	a5,-32(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:73
    int32_t yMax = ySpan >> 1;
 470:	fe442783          	lw	a5,-28(s0)
 474:	4017d793          	srai	a5,a5,0x1
 478:	fcf42e23          	sw	a5,-36(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:74
    drawMandel(xMin, xMax, yMin, yMax);
 47c:	fdc42683          	lw	a3,-36(s0)
 480:	fe042603          	lw	a2,-32(s0)
 484:	fe842583          	lw	a1,-24(s0)
 488:	fec42503          	lw	a0,-20(s0)
 48c:	cedff0ef          	jal	ra,178 <drawMandel>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:75 (discriminator 1)
    for(;;){
 490:	0000006f          	j	490 <main+0xbc>
