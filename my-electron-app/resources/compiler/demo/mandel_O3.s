
mandel_O3.elf:     file format elf32-littleriscv


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
   4:	b6018193          	addi	gp,gp,-1184 # b60 <__global_pointer$>
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
  14:	0040006f          	j	18 <main>

Disassembly of section .text:

00000018 <main>:
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    }
}

int main(){
    // enable video
    vgaHandle->en = 1;
  18:	36002703          	lw	a4,864(zero) # 360 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:58
int main(){
  1c:	ff010113          	addi	sp,sp,-16
  20:	00112623          	sw	ra,12(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    vgaHandle->en = 1;
  24:	00374783          	lbu	a5,3(a4)
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
  28:	01000537          	lui	a0,0x1000
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    vgaHandle->pAddr = 0;
  2c:	0ff00693          	li	a3,255
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    vgaHandle->en = 1;
  30:	f807e793          	ori	a5,a5,-128
  34:	00f701a3          	sb	a5,3(a4)
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
  38:	fff50513          	addi	a0,a0,-1 # ffffff <__stack_top+0xfeffff>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    vgaHandle->pAddr = 0;
  3c:	000709a3          	sb	zero,19(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
  40:	01069613          	slli	a2,a3,0x10
  44:	00869793          	slli	a5,a3,0x8
  48:	00c7e7b3          	or	a5,a5,a2
  4c:	00d7e7b3          	or	a5,a5,a3
  50:	00a7f7b3          	and	a5,a5,a0
  54:	0ff7f593          	andi	a1,a5,255
  58:	0087d613          	srli	a2,a5,0x8
  5c:	01574803          	lbu	a6,21(a4)
  60:	0ff67613          	andi	a2,a2,255
  64:	00b70aa3          	sb	a1,21(a4)
  68:	01674583          	lbu	a1,22(a4)
  6c:	0107d793          	srli	a5,a5,0x10
  70:	00c70b23          	sb	a2,22(a4)
  74:	01774603          	lbu	a2,23(a4)
  78:	0ff7f793          	andi	a5,a5,255
  7c:	00f70ba3          	sb	a5,23(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:53
    for(size_t i = 0; i < 255; i++){
  80:	fff68693          	addi	a3,a3,-1
  84:	fa069ee3          	bnez	a3,40 <main+0x28>
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    // set palette
    setPalette0();
    // set pixel address to 0
    vgaHandle->xAddr = 0;
  88:	00674783          	lbu	a5,6(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
    int32_t xMin = QP_NEG_1_5;
    int32_t xMax = QP_0_75;
    int32_t ySpan = ((xMax - xMin) * 3) >> 2;
    int32_t yMin = -(ySpan >> 1);
    int32_t yMax = ySpan >> 1;
    drawMandel(xMin, xMax, yMin, yMax);
  8c:	036006b7          	lui	a3,0x3600
  90:	fca00637          	lui	a2,0xfca00
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    vgaHandle->xAddr = 0;
  94:	01f7f793          	andi	a5,a5,31
  98:	00f70323          	sb	a5,6(a4)
  9c:	00774783          	lbu	a5,7(a4)
  a0:	000703a3          	sb	zero,7(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    vgaHandle->yAddr = 0;
  a4:	00a74783          	lbu	a5,10(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
    drawMandel(xMin, xMax, yMin, yMax);
  a8:	030005b7          	lui	a1,0x3000
  ac:	fa000537          	lui	a0,0xfa000
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    vgaHandle->yAddr = 0;
  b0:	03f7f793          	andi	a5,a5,63
  b4:	00f70523          	sb	a5,10(a4)
  b8:	00b74783          	lbu	a5,11(a4)
  bc:	000705a3          	sb	zero,11(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
    drawMandel(xMin, xMax, yMin, yMax);
  c0:	0bc000ef          	jal	ra,17c <drawMandel>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:73 (discriminator 1)
    for(;;){
  c4:	0000006f          	j	c4 <main+0xac>

000000c8 <getIters>:
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:19
uint8_t getIters(int32_t x0, int32_t y0){
  c8:	00050e13          	mv	t3,a0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
  cc:	00000813          	li	a6,0
  d0:	00000713          	li	a4,0
  d4:	00000893          	li	a7,0
  d8:	00000613          	li	a2,0
  dc:	00000313          	li	t1,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:21
    uint8_t iters = 0;
  e0:	00000513          	li	a0,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    while(qmul(x, x) + qmul(y, y) <= QP_4 && iters < maxIters){
  e4:	10000eb7          	lui	t4,0x10000
  e8:	0ff00f13          	li	t5,255
  ec:	0080006f          	j	f4 <getIters+0x2c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24 (discriminator 1)
  f0:	09e50463          	beq	a0,t5,178 <getIters+0xb0>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
  f4:	00575693          	srli	a3,a4,0x5
  f8:	01b71713          	slli	a4,a4,0x1b
  fc:	00669693          	slli	a3,a3,0x6
 100:	01a75793          	srli	a5,a4,0x1a
 104:	00f6e7b3          	or	a5,a3,a5
 108:	41f7d693          	srai	a3,a5,0x1f
 10c:	02f30333          	mul	t1,t1,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:25
        int32_t newX = qmul(x, x) - qmul(y, y) + x0;
 110:	41180833          	sub	a6,a6,a7
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 114:	01c80733          	add	a4,a6,t3
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:29
        iters++;
 118:	00150513          	addi	a0,a0,1 # fa000001 <__stack_top+0xf9ff0001>
 11c:	0ff57513          	andi	a0,a0,255
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 120:	02c686b3          	mul	a3,a3,a2
 124:	02c7b833          	mulhu	a6,a5,a2
 128:	006686b3          	add	a3,a3,t1
 12c:	02c787b3          	mul	a5,a5,a2
 130:	010686b3          	add	a3,a3,a6
 134:	00669693          	slli	a3,a3,0x6
 138:	01a7d793          	srli	a5,a5,0x1a
 13c:	00f6e7b3          	or	a5,a3,a5
 140:	00f58633          	add	a2,a1,a5
 144:	02e706b3          	mul	a3,a4,a4
 148:	41f65313          	srai	t1,a2,0x1f
 14c:	02e71833          	mulh	a6,a4,a4
 150:	01a6d693          	srli	a3,a3,0x1a
 154:	02c607b3          	mul	a5,a2,a2
 158:	00681813          	slli	a6,a6,0x6
 15c:	00d86833          	or	a6,a6,a3
 160:	02c618b3          	mulh	a7,a2,a2
 164:	01a7d793          	srli	a5,a5,0x1a
 168:	00689893          	slli	a7,a7,0x6
 16c:	00f8e8b3          	or	a7,a7,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    while(qmul(x, x) + qmul(y, y) <= QP_4 && iters < maxIters){
 170:	010887b3          	add	a5,a7,a6
 174:	f6fedee3          	bge	t4,a5,f0 <getIters+0x28>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:32
}
 178:	00008067          	ret

0000017c <drawMandel>:
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 17c:	0001a2b7          	lui	t0,0x1a
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:35
    int32_t dx = qmul(xMax - xMin, QP_INV_640);
 180:	40a587b3          	sub	a5,a1,a0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 184:	99a28293          	addi	t0,t0,-1638 # 1999a <__stack_top+0x999a>
 188:	025786b3          	mul	a3,a5,t0
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
            vgaHandle->pxlData = iters;
 18c:	36002f03          	lw	t5,864(zero) # 360 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:34
void drawMandel(int32_t xMin, int32_t xMax, int32_t yMin, int32_t yMax){
 190:	ff010113          	addi	sp,sp,-16
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
            vgaHandle->pxlData = iters;
 194:	010003b7          	lui	t2,0x1000
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:34
void drawMandel(int32_t xMin, int32_t xMax, int32_t yMin, int32_t yMax){
 198:	00812623          	sw	s0,12(sp)
 19c:	00912423          	sw	s1,8(sp)
 1a0:	01212223          	sw	s2,4(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
            vgaHandle->pxlData = iters;
 1a4:	1e000493          	li	s1,480
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    while(qmul(x, x) + qmul(y, y) <= QP_4 && iters < maxIters){
 1a8:	10000e37          	lui	t3,0x10000
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 1ac:	025792b3          	mulh	t0,a5,t0
 1b0:	01a6d693          	srli	a3,a3,0x1a
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    while(qmul(x, x) + qmul(y, y) <= QP_4 && iters < maxIters){
 1b4:	0ff00e93          	li	t4,255
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
            vgaHandle->pxlData = iters;
 1b8:	fff38393          	addi	t2,t2,-1 # ffffff <__stack_top+0xfeffff>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 1bc:	00629293          	slli	t0,t0,0x6
 1c0:	00d2e2b3          	or	t0,t0,a3
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:36
    int32_t xStart = xMin + dx >> 1;
 1c4:	00550733          	add	a4,a0,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:37
    int32_t yStart = yMin + dx >> 1;
 1c8:	00560333          	add	t1,a2,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:36
    int32_t xStart = xMin + dx >> 1;
 1cc:	40175413          	srai	s0,a4,0x1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:37
    int32_t yStart = yMin + dx >> 1;
 1d0:	40135313          	srai	t1,t1,0x1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:40
        int32_t x0 = xStart;
 1d4:	00040893          	mv	a7,s0
 1d8:	28000f93          	li	t6,640
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:21
    uint8_t iters = 0;
 1dc:	00000813          	li	a6,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 1e0:	00000593          	li	a1,0
 1e4:	00000913          	li	s2,0
 1e8:	00000713          	li	a4,0
 1ec:	00000513          	li	a0,0
 1f0:	00000613          	li	a2,0
 1f4:	0080006f          	j	1fc <drawMandel+0x80>
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    while(qmul(x, x) + qmul(y, y) <= QP_4 && iters < maxIters){
 1f8:	0dd80a63          	beq	a6,t4,2cc <drawMandel+0x150>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 1fc:	00575693          	srli	a3,a4,0x5
 200:	01b71713          	slli	a4,a4,0x1b
 204:	00669693          	slli	a3,a3,0x6
 208:	01a75793          	srli	a5,a4,0x1a
 20c:	00f6e7b3          	or	a5,a3,a5
 210:	41f7d693          	srai	a3,a5,0x1f
 214:	02f90933          	mul	s2,s2,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:25
        int32_t newX = qmul(x, x) - qmul(y, y) + x0;
 218:	40a60633          	sub	a2,a2,a0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 21c:	01160733          	add	a4,a2,a7
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:29
        iters++;
 220:	00180813          	addi	a6,a6,1
 224:	0ff87813          	andi	a6,a6,255
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 228:	02b686b3          	mul	a3,a3,a1
 22c:	02b7b633          	mulhu	a2,a5,a1
 230:	012686b3          	add	a3,a3,s2
 234:	02b787b3          	mul	a5,a5,a1
 238:	00c686b3          	add	a3,a3,a2
 23c:	00669693          	slli	a3,a3,0x6
 240:	01a7d793          	srli	a5,a5,0x1a
 244:	00f6e7b3          	or	a5,a3,a5
 248:	00f305b3          	add	a1,t1,a5
 24c:	02e706b3          	mul	a3,a4,a4
 250:	41f5d913          	srai	s2,a1,0x1f
 254:	02e71633          	mulh	a2,a4,a4
 258:	01a6d693          	srli	a3,a3,0x1a
 25c:	02b587b3          	mul	a5,a1,a1
 260:	00661613          	slli	a2,a2,0x6
 264:	00d66633          	or	a2,a2,a3
 268:	02b59533          	mulh	a0,a1,a1
 26c:	01a7d793          	srli	a5,a5,0x1a
 270:	00651513          	slli	a0,a0,0x6
 274:	00f56533          	or	a0,a0,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    while(qmul(x, x) + qmul(y, y) <= QP_4 && iters < maxIters){
 278:	00a607b3          	add	a5,a2,a0
 27c:	f6fe5ee3          	bge	t3,a5,1f8 <drawMandel+0x7c>
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
            vgaHandle->pxlData = iters;
 280:	00787833          	and	a6,a6,t2
 284:	0ff87813          	andi	a6,a6,255
 288:	00df4783          	lbu	a5,13(t5)
 28c:	010f06a3          	sb	a6,13(t5)
 290:	00ef4783          	lbu	a5,14(t5)
 294:	000f0723          	sb	zero,14(t5)
 298:	00ff4783          	lbu	a5,15(t5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41
        for(size_t i = 0; i < 640; i++){
 29c:	ffff8f93          	addi	t6,t6,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
            vgaHandle->pxlData = iters;
 2a0:	000f07a3          	sb	zero,15(t5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
            x0 += dx;
 2a4:	005888b3          	add	a7,a7,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41
        for(size_t i = 0; i < 640; i++){
 2a8:	f20f9ae3          	bnez	t6,1dc <drawMandel+0x60>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 2ac:	fff48493          	addi	s1,s1,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46 (discriminator 2)
        y0 += dx;
 2b0:	00530333          	add	t1,t1,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 2b4:	f20490e3          	bnez	s1,1d4 <drawMandel+0x58>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48
}
 2b8:	00c12403          	lw	s0,12(sp)
 2bc:	00812483          	lw	s1,8(sp)
 2c0:	00412903          	lw	s2,4(sp)
 2c4:	01010113          	addi	sp,sp,16
 2c8:	00008067          	ret
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48
 2cc:	0ff00813          	li	a6,255
 2d0:	fb5ff06f          	j	284 <drawMandel+0x108>

000002d4 <setPalette0>:
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    vgaHandle->pAddr = 0;
 2d4:	36002703          	lw	a4,864(zero) # 360 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
 2d8:	01000537          	lui	a0,0x1000
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    vgaHandle->pAddr = 0;
 2dc:	0ff00693          	li	a3,255
 2e0:	000709a3          	sb	zero,19(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
 2e4:	fff50513          	addi	a0,a0,-1 # ffffff <__stack_top+0xfeffff>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54 (discriminator 3)
 2e8:	01069613          	slli	a2,a3,0x10
 2ec:	00869793          	slli	a5,a3,0x8
 2f0:	00c7e7b3          	or	a5,a5,a2
 2f4:	00d7e7b3          	or	a5,a5,a3
 2f8:	00a7f7b3          	and	a5,a5,a0
 2fc:	0ff7f593          	andi	a1,a5,255
 300:	0087d613          	srli	a2,a5,0x8
 304:	01574803          	lbu	a6,21(a4)
 308:	0ff67613          	andi	a2,a2,255
 30c:	00b70aa3          	sb	a1,21(a4)
 310:	01674583          	lbu	a1,22(a4)
 314:	0107d793          	srli	a5,a5,0x10
 318:	00c70b23          	sb	a2,22(a4)
 31c:	01774603          	lbu	a2,23(a4)
 320:	0ff7f793          	andi	a5,a5,255
 324:	00f70ba3          	sb	a5,23(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:53 (discriminator 3)
    for(size_t i = 0; i < 255; i++){
 328:	fff68693          	addi	a3,a3,-1 # 35fffff <__stack_top+0x35effff>
 32c:	fa069ee3          	bnez	a3,2e8 <setPalette0+0x14>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
}
 330:	00008067          	ret
