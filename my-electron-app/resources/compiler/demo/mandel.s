
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
   4:	cd818193          	addi	gp,gp,-808 # cd8 <__global_pointer$>
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
  14:	3d80006f          	j	3ec <main>

Disassembly of section .text:

00000018 <qmul>:
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:15
#define QP_0_75 50331648L
#define QP_INV_640 104858L

volatile Vga_t* vgaHandle = (void*) 0x80000000;

static inline int32_t qmul(int32_t a, int32_t b){
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
  9c:	02912a23          	sw	s1,52(sp)
  a0:	04010413          	addi	s0,sp,64
  a4:	fca42623          	sw	a0,-52(s0)
  a8:	fcb42423          	sw	a1,-56(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:20
    uint8_t maxIters = 255;
  ac:	fff00793          	li	a5,-1
  b0:	fef401a3          	sb	a5,-29(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:21
    uint8_t iters = 0;
  b4:	fe0407a3          	sb	zero,-17(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:22
    int32_t x = 0;
  b8:	fe042423          	sw	zero,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:23
    int32_t y = 0;
  bc:	fe042223          	sw	zero,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    while(qmul(x, x) + qmul(y, y) <= QP_4 && iters < maxIters){
  c0:	07c0006f          	j	13c <getIters+0xac>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:25
        int32_t newX = qmul(x, x) - qmul(y, y) + x0;
  c4:	fe842583          	lw	a1,-24(s0)
  c8:	fe842503          	lw	a0,-24(s0)
  cc:	f4dff0ef          	jal	ra,18 <qmul>
  d0:	00050493          	mv	s1,a0
  d4:	fe442583          	lw	a1,-28(s0)
  d8:	fe442503          	lw	a0,-28(s0)
  dc:	f3dff0ef          	jal	ra,18 <qmul>
  e0:	00050793          	mv	a5,a0
  e4:	40f487b3          	sub	a5,s1,a5
  e8:	fcc42703          	lw	a4,-52(s0)
  ec:	00f707b3          	add	a5,a4,a5
  f0:	fcf42e23          	sw	a5,-36(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:26
        int32_t newY = qmul(qmul(QP_2, x), y) + y0;
  f4:	fe842583          	lw	a1,-24(s0)
  f8:	08000537          	lui	a0,0x8000
  fc:	f1dff0ef          	jal	ra,18 <qmul>
 100:	00050793          	mv	a5,a0
 104:	fe442583          	lw	a1,-28(s0)
 108:	00078513          	mv	a0,a5
 10c:	f0dff0ef          	jal	ra,18 <qmul>
 110:	00050713          	mv	a4,a0
 114:	fc842783          	lw	a5,-56(s0)
 118:	00e787b3          	add	a5,a5,a4
 11c:	fcf42c23          	sw	a5,-40(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:27
        x = newX;
 120:	fdc42783          	lw	a5,-36(s0)
 124:	fef42423          	sw	a5,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:28
        y = newY;
 128:	fd842783          	lw	a5,-40(s0)
 12c:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:29
        iters++;
 130:	fef44783          	lbu	a5,-17(s0)
 134:	00178793          	addi	a5,a5,1
 138:	fef407a3          	sb	a5,-17(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    while(qmul(x, x) + qmul(y, y) <= QP_4 && iters < maxIters){
 13c:	fe842583          	lw	a1,-24(s0)
 140:	fe842503          	lw	a0,-24(s0)
 144:	ed5ff0ef          	jal	ra,18 <qmul>
 148:	00050493          	mv	s1,a0
 14c:	fe442583          	lw	a1,-28(s0)
 150:	fe442503          	lw	a0,-28(s0)
 154:	ec5ff0ef          	jal	ra,18 <qmul>
 158:	00050793          	mv	a5,a0
 15c:	00f48733          	add	a4,s1,a5
 160:	100007b7          	lui	a5,0x10000
 164:	00e7c863          	blt	a5,a4,174 <getIters+0xe4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24 (discriminator 1)
 168:	fef44703          	lbu	a4,-17(s0)
 16c:	fe344783          	lbu	a5,-29(s0)
 170:	f4f76ae3          	bltu	a4,a5,c4 <getIters+0x34>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:31
    }
    return iters;
 174:	fef44783          	lbu	a5,-17(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:32
}
 178:	00078513          	mv	a0,a5
 17c:	03c12083          	lw	ra,60(sp)
 180:	03812403          	lw	s0,56(sp)
 184:	03412483          	lw	s1,52(sp)
 188:	04010113          	addi	sp,sp,64
 18c:	00008067          	ret

00000190 <drawMandel>:
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:34

void drawMandel(int32_t xMin, int32_t xMax, int32_t yMin, int32_t yMax){
 190:	fc010113          	addi	sp,sp,-64
 194:	02112e23          	sw	ra,60(sp)
 198:	02812c23          	sw	s0,56(sp)
 19c:	04010413          	addi	s0,sp,64
 1a0:	fca42623          	sw	a0,-52(s0)
 1a4:	fcb42423          	sw	a1,-56(s0)
 1a8:	fcc42223          	sw	a2,-60(s0)
 1ac:	fcd42023          	sw	a3,-64(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:35
    int32_t dx = qmul(xMax - xMin, QP_INV_640);
 1b0:	fc842703          	lw	a4,-56(s0)
 1b4:	fcc42783          	lw	a5,-52(s0)
 1b8:	40f70733          	sub	a4,a4,a5
 1bc:	0001a7b7          	lui	a5,0x1a
 1c0:	99a78593          	addi	a1,a5,-1638 # 1999a <__stack_top+0x999a>
 1c4:	00070513          	mv	a0,a4
 1c8:	e51ff0ef          	jal	ra,18 <qmul>
 1cc:	fca42e23          	sw	a0,-36(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:36
    int32_t xStart = xMin + dx >> 1;
 1d0:	fcc42703          	lw	a4,-52(s0)
 1d4:	fdc42783          	lw	a5,-36(s0)
 1d8:	00f707b3          	add	a5,a4,a5
 1dc:	4017d793          	srai	a5,a5,0x1
 1e0:	fcf42c23          	sw	a5,-40(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:37
    int32_t yStart = yMin + dx >> 1;
 1e4:	fc442703          	lw	a4,-60(s0)
 1e8:	fdc42783          	lw	a5,-36(s0)
 1ec:	00f707b3          	add	a5,a4,a5
 1f0:	4017d793          	srai	a5,a5,0x1
 1f4:	fcf42a23          	sw	a5,-44(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:38
    int32_t y0 = yStart;
 1f8:	fd442783          	lw	a5,-44(s0)
 1fc:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    for(size_t j = 0; j < 480; j++){
 200:	fe042423          	sw	zero,-24(s0)
 204:	0dc0006f          	j	2e0 <drawMandel+0x150>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:40
        int32_t x0 = xStart;
 208:	fd842783          	lw	a5,-40(s0)
 20c:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41
        for(size_t i = 0; i < 640; i++){
 210:	fe042023          	sw	zero,-32(s0)
 214:	0a40006f          	j	2b8 <drawMandel+0x128>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:42 (discriminator 3)
            uint8_t iters = getIters(x0, y0);
 218:	fec42583          	lw	a1,-20(s0)
 21c:	fe442503          	lw	a0,-28(s0)
 220:	e71ff0ef          	jal	ra,90 <getIters>
 224:	00050793          	mv	a5,a0
 228:	fcf409a3          	sb	a5,-45(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43 (discriminator 3)
            vgaHandle->pxlData = iters;
 22c:	4d802783          	lw	a5,1240(zero) # 4d8 <vgaHandle>
 230:	fd344703          	lbu	a4,-45(s0)
 234:	010006b7          	lui	a3,0x1000
 238:	fff68693          	addi	a3,a3,-1 # ffffff <__stack_top+0xfeffff>
 23c:	00d77733          	and	a4,a4,a3
 240:	0ff77593          	andi	a1,a4,255
 244:	00d7c683          	lbu	a3,13(a5)
 248:	0006f693          	andi	a3,a3,0
 24c:	00068613          	mv	a2,a3
 250:	00058693          	mv	a3,a1
 254:	00d666b3          	or	a3,a2,a3
 258:	00d786a3          	sb	a3,13(a5)
 25c:	00875693          	srli	a3,a4,0x8
 260:	0ff6f593          	andi	a1,a3,255
 264:	00e7c683          	lbu	a3,14(a5)
 268:	0006f693          	andi	a3,a3,0
 26c:	00068613          	mv	a2,a3
 270:	00058693          	mv	a3,a1
 274:	00d666b3          	or	a3,a2,a3
 278:	00d78723          	sb	a3,14(a5)
 27c:	01075713          	srli	a4,a4,0x10
 280:	0ff77613          	andi	a2,a4,255
 284:	00f7c703          	lbu	a4,15(a5)
 288:	00077713          	andi	a4,a4,0
 28c:	00070693          	mv	a3,a4
 290:	00060713          	mv	a4,a2
 294:	00e6e733          	or	a4,a3,a4
 298:	00e787a3          	sb	a4,15(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44 (discriminator 3)
            x0 += dx;
 29c:	fe442703          	lw	a4,-28(s0)
 2a0:	fdc42783          	lw	a5,-36(s0)
 2a4:	00f707b3          	add	a5,a4,a5
 2a8:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41 (discriminator 3)
        for(size_t i = 0; i < 640; i++){
 2ac:	fe042783          	lw	a5,-32(s0)
 2b0:	00178793          	addi	a5,a5,1
 2b4:	fef42023          	sw	a5,-32(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41 (discriminator 1)
 2b8:	fe042703          	lw	a4,-32(s0)
 2bc:	27f00793          	li	a5,639
 2c0:	f4e7fce3          	bgeu	a5,a4,218 <drawMandel+0x88>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46 (discriminator 2)
        }
        y0 += dx;
 2c4:	fec42703          	lw	a4,-20(s0)
 2c8:	fdc42783          	lw	a5,-36(s0)
 2cc:	00f707b3          	add	a5,a4,a5
 2d0:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 2d4:	fe842783          	lw	a5,-24(s0)
 2d8:	00178793          	addi	a5,a5,1
 2dc:	fef42423          	sw	a5,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39 (discriminator 1)
 2e0:	fe842703          	lw	a4,-24(s0)
 2e4:	1df00793          	li	a5,479
 2e8:	f2e7f0e3          	bgeu	a5,a4,208 <drawMandel+0x78>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48
    }
}
 2ec:	00000013          	nop
 2f0:	00000013          	nop
 2f4:	03c12083          	lw	ra,60(sp)
 2f8:	03812403          	lw	s0,56(sp)
 2fc:	04010113          	addi	sp,sp,64
 300:	00008067          	ret

00000304 <setPalette0>:
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50

void setPalette0(){
 304:	fe010113          	addi	sp,sp,-32
 308:	00812e23          	sw	s0,28(sp)
 30c:	02010413          	addi	s0,sp,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    // set palette address
    vgaHandle->pAddr = 0;
 310:	4d802783          	lw	a5,1240(zero) # 4d8 <vgaHandle>
 314:	000789a3          	sb	zero,19(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:53
    for(size_t i = 0; i < 255; i++){
 318:	fe042623          	sw	zero,-20(s0)
 31c:	0b00006f          	j	3cc <setPalette0+0xc8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54 (discriminator 3)
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
 320:	0ff00713          	li	a4,255
 324:	fec42783          	lw	a5,-20(s0)
 328:	40f707b3          	sub	a5,a4,a5
 32c:	01079713          	slli	a4,a5,0x10
 330:	0ff00693          	li	a3,255
 334:	fec42783          	lw	a5,-20(s0)
 338:	40f687b3          	sub	a5,a3,a5
 33c:	00879793          	slli	a5,a5,0x8
 340:	00f76733          	or	a4,a4,a5
 344:	0ff00693          	li	a3,255
 348:	fec42783          	lw	a5,-20(s0)
 34c:	40f687b3          	sub	a5,a3,a5
 350:	00f766b3          	or	a3,a4,a5
 354:	4d802783          	lw	a5,1240(zero) # 4d8 <vgaHandle>
 358:	01000737          	lui	a4,0x1000
 35c:	fff70713          	addi	a4,a4,-1 # ffffff <__stack_top+0xfeffff>
 360:	00e6f733          	and	a4,a3,a4
 364:	0ff77593          	andi	a1,a4,255
 368:	0157c683          	lbu	a3,21(a5)
 36c:	0006f693          	andi	a3,a3,0
 370:	00068613          	mv	a2,a3
 374:	00058693          	mv	a3,a1
 378:	00d666b3          	or	a3,a2,a3
 37c:	00d78aa3          	sb	a3,21(a5)
 380:	00875693          	srli	a3,a4,0x8
 384:	0ff6f593          	andi	a1,a3,255
 388:	0167c683          	lbu	a3,22(a5)
 38c:	0006f693          	andi	a3,a3,0
 390:	00068613          	mv	a2,a3
 394:	00058693          	mv	a3,a1
 398:	00d666b3          	or	a3,a2,a3
 39c:	00d78b23          	sb	a3,22(a5)
 3a0:	01075713          	srli	a4,a4,0x10
 3a4:	0ff77613          	andi	a2,a4,255
 3a8:	0177c703          	lbu	a4,23(a5)
 3ac:	00077713          	andi	a4,a4,0
 3b0:	00070693          	mv	a3,a4
 3b4:	00060713          	mv	a4,a2
 3b8:	00e6e733          	or	a4,a3,a4
 3bc:	00e78ba3          	sb	a4,23(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:53 (discriminator 3)
    for(size_t i = 0; i < 255; i++){
 3c0:	fec42783          	lw	a5,-20(s0)
 3c4:	00178793          	addi	a5,a5,1
 3c8:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:53 (discriminator 1)
 3cc:	fec42703          	lw	a4,-20(s0)
 3d0:	0fe00793          	li	a5,254
 3d4:	f4e7f6e3          	bgeu	a5,a4,320 <setPalette0+0x1c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
    }
}
 3d8:	00000013          	nop
 3dc:	00000013          	nop
 3e0:	01c12403          	lw	s0,28(sp)
 3e4:	02010113          	addi	sp,sp,32
 3e8:	00008067          	ret

000003ec <main>:
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:58

int main(){
 3ec:	fd010113          	addi	sp,sp,-48
 3f0:	02112623          	sw	ra,44(sp)
 3f4:	02812423          	sw	s0,40(sp)
 3f8:	03010413          	addi	s0,sp,48
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    // enable video
    vgaHandle->en = 1;
 3fc:	4d802783          	lw	a5,1240(zero) # 4d8 <vgaHandle>
 400:	0037c703          	lbu	a4,3(a5)
 404:	f8076713          	ori	a4,a4,-128
 408:	00e781a3          	sb	a4,3(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    // set palette
    setPalette0();
 40c:	ef9ff0ef          	jal	ra,304 <setPalette0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    // set pixel address to 0
    vgaHandle->xAddr = 0;
 410:	4d802783          	lw	a5,1240(zero) # 4d8 <vgaHandle>
 414:	0067c703          	lbu	a4,6(a5)
 418:	01f77713          	andi	a4,a4,31
 41c:	00e78323          	sb	a4,6(a5)
 420:	0077c703          	lbu	a4,7(a5)
 424:	00077713          	andi	a4,a4,0
 428:	00e783a3          	sb	a4,7(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    vgaHandle->yAddr = 0;
 42c:	4d802783          	lw	a5,1240(zero) # 4d8 <vgaHandle>
 430:	00a7c703          	lbu	a4,10(a5)
 434:	03f77713          	andi	a4,a4,63
 438:	00e78523          	sb	a4,10(a5)
 43c:	00b7c703          	lbu	a4,11(a5)
 440:	00077713          	andi	a4,a4,0
 444:	00e785a3          	sb	a4,11(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
    // draw
    int32_t xMin = QP_NEG_1_5;
 448:	fa0007b7          	lui	a5,0xfa000
 44c:	fef42623          	sw	a5,-20(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:68
    int32_t xMax = QP_0_75;
 450:	030007b7          	lui	a5,0x3000
 454:	fef42423          	sw	a5,-24(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:69
    int32_t ySpan = ((xMax - xMin) * 3) >> 2;
 458:	fe842703          	lw	a4,-24(s0)
 45c:	fec42783          	lw	a5,-20(s0)
 460:	40f70733          	sub	a4,a4,a5
 464:	00070793          	mv	a5,a4
 468:	00179793          	slli	a5,a5,0x1
 46c:	00e787b3          	add	a5,a5,a4
 470:	4027d793          	srai	a5,a5,0x2
 474:	fef42223          	sw	a5,-28(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:70
    int32_t yMin = -(ySpan >> 1);
 478:	fe442783          	lw	a5,-28(s0)
 47c:	4017d793          	srai	a5,a5,0x1
 480:	40f007b3          	neg	a5,a5
 484:	fef42023          	sw	a5,-32(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:71
    int32_t yMax = ySpan >> 1;
 488:	fe442783          	lw	a5,-28(s0)
 48c:	4017d793          	srai	a5,a5,0x1
 490:	fcf42e23          	sw	a5,-36(s0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
    drawMandel(xMin, xMax, yMin, yMax);
 494:	fdc42683          	lw	a3,-36(s0)
 498:	fe042603          	lw	a2,-32(s0)
 49c:	fe842583          	lw	a1,-24(s0)
 4a0:	fec42503          	lw	a0,-20(s0)
 4a4:	cedff0ef          	jal	ra,190 <drawMandel>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:73 (discriminator 1)
    for(;;){
 4a8:	0000006f          	j	4a8 <main+0xbc>
