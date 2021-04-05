
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
   4:	b8018193          	addi	gp,gp,-1152 # b80 <__global_pointer$>
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
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    }
}

int main(){
    // enable video
    vgaHandle->en = 1;
  18:	38002703          	lw	a4,896(zero) # 380 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
int main(){
  1c:	ff010113          	addi	sp,sp,-16
  20:	00112623          	sw	ra,12(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    vgaHandle->en = 1;
  24:	00374783          	lbu	a5,3(a4)
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
  28:	01000537          	lui	a0,0x1000
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
    vgaHandle->pAddr = 0;
  2c:	0ff00693          	li	a3,255
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    vgaHandle->en = 1;
  30:	f807e793          	ori	a5,a5,-128
  34:	00f701a3          	sb	a5,3(a4)
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
  38:	fff50513          	addi	a0,a0,-1 # ffffff <__stack_top+0xfeffff>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
    vgaHandle->pAddr = 0;
  3c:	000709a3          	sb	zero,19(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
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
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:55
    for(size_t i = 0; i < 255; i++){
  80:	fff68693          	addi	a3,a3,-1
  84:	fa069ee3          	bnez	a3,40 <main+0x28>
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:66
    // set palette
    setPalette0();
    // set pixel address to 0
    vgaHandle->xAddr = 0;
  88:	00674783          	lbu	a5,6(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:74
    int32_t xMin = QP_NEG_1_5;
    int32_t xMax = QP_0_75;
    int32_t ySpan = ((xMax - xMin) * 3) >> 2;
    int32_t yMin = -(ySpan >> 1);
    int32_t yMax = ySpan >> 1;
    drawMandel(xMin, xMax, yMin, yMax);
  8c:	036006b7          	lui	a3,0x3600
  90:	fca00637          	lui	a2,0xfca00
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:66
    vgaHandle->xAddr = 0;
  94:	01f7f793          	andi	a5,a5,31
  98:	00f70323          	sb	a5,6(a4)
  9c:	00774783          	lbu	a5,7(a4)
  a0:	000703a3          	sb	zero,7(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
    vgaHandle->yAddr = 0;
  a4:	00a74783          	lbu	a5,10(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:74
    drawMandel(xMin, xMax, yMin, yMax);
  a8:	030005b7          	lui	a1,0x3000
  ac:	fa000537          	lui	a0,0xfa000
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
    vgaHandle->yAddr = 0;
  b0:	03f7f793          	andi	a5,a5,63
  b4:	00f70523          	sb	a5,10(a4)
  b8:	00b74783          	lbu	a5,11(a4)
  bc:	000705a3          	sb	zero,11(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:74
    drawMandel(xMin, xMax, yMin, yMax);
  c0:	0d8000ef          	jal	ra,198 <drawMandel>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:75 (discriminator 1)
    for(;;){
  c4:	0000006f          	j	c4 <main+0xac>

000000c8 <qmul>:
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
  c8:	02b507b3          	mul	a5,a0,a1
  cc:	02b51533          	mulh	a0,a0,a1
  d0:	01a7d793          	srli	a5,a5,0x1a
  d4:	00651513          	slli	a0,a0,0x6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:17
}
  d8:	00f56533          	or	a0,a0,a5
  dc:	00008067          	ret

000000e0 <getIters>:
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:19
uint8_t getIters(int32_t x0, int32_t y0){
  e0:	00050e13          	mv	t3,a0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:23
    uint16_t iters = 0;
  e4:	00000313          	li	t1,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
  e8:	00000713          	li	a4,0
  ec:	00000613          	li	a2,0
  f0:	00000f93          	li	t6,0
  f4:	00000813          	li	a6,0
  f8:	00000793          	li	a5,0
  fc:	00000693          	li	a3,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 100:	10000e93          	li	t4,256
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:27
        if(xx + yy > QP_4) break;
 104:	10000f37          	lui	t5,0x10000
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 108:	02ff8fb3          	mul	t6,t6,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 10c:	00130313          	addi	t1,t1,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:28
        int32_t newX = xx - yy + x0;
 110:	41070733          	sub	a4,a4,a6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 114:	01031313          	slli	t1,t1,0x10
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:28
        int32_t newX = xx - yy + x0;
 118:	01c70733          	add	a4,a4,t3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 11c:	01035313          	srli	t1,t1,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 120:	02c686b3          	mul	a3,a3,a2
 124:	02c7b533          	mulhu	a0,a5,a2
 128:	01f686b3          	add	a3,a3,t6
 12c:	41f75f93          	srai	t6,a4,0x1f
 130:	02c787b3          	mul	a5,a5,a2
 134:	00a686b3          	add	a3,a3,a0
 138:	00669693          	slli	a3,a3,0x6
 13c:	00070613          	mv	a2,a4
 140:	01a7d793          	srli	a5,a5,0x1a
 144:	00f6e7b3          	or	a5,a3,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:29
        int32_t newY = (qmul(x, y) << 1) + y0;
 148:	00179793          	slli	a5,a5,0x1
 14c:	00b787b3          	add	a5,a5,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 150:	05d30063          	beq	t1,t4,190 <getIters+0xb0>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 154:	02c60533          	mul	a0,a2,a2
 158:	41f7d693          	srai	a3,a5,0x1f
 15c:	02c61733          	mulh	a4,a2,a2
 160:	01a55513          	srli	a0,a0,0x1a
 164:	02f788b3          	mul	a7,a5,a5
 168:	00671713          	slli	a4,a4,0x6
 16c:	00a76733          	or	a4,a4,a0
 170:	02f79833          	mulh	a6,a5,a5
 174:	01a8d893          	srli	a7,a7,0x1a
 178:	00681813          	slli	a6,a6,0x6
 17c:	01186833          	or	a6,a6,a7
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:27
        if(xx + yy > QP_4) break;
 180:	00e80533          	add	a0,a6,a4
 184:	f8af52e3          	bge	t5,a0,108 <getIters+0x28>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:33
    return iters;
 188:	0ff37513          	andi	a0,t1,255
 18c:	00008067          	ret
 190:	00000513          	li	a0,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:34
}
 194:	00008067          	ret

00000198 <drawMandel>:
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 198:	0001a2b7          	lui	t0,0x1a
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:37
    int32_t dx = qmul(xMax - xMin, QP_INV_640);
 19c:	40a587b3          	sub	a5,a1,a0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 1a0:	99a28293          	addi	t0,t0,-1638 # 1999a <__stack_top+0x999a>
 1a4:	02578733          	mul	a4,a5,t0
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
            vgaHandle->pxlData = iters;
 1a8:	38002f03          	lw	t5,896(zero) # 380 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:36
void drawMandel(int32_t xMin, int32_t xMax, int32_t yMin, int32_t yMax){
 1ac:	ff010113          	addi	sp,sp,-16
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
            vgaHandle->pxlData = iters;
 1b0:	010003b7          	lui	t2,0x1000
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:36
void drawMandel(int32_t xMin, int32_t xMax, int32_t yMin, int32_t yMax){
 1b4:	00812623          	sw	s0,12(sp)
 1b8:	00912423          	sw	s1,8(sp)
 1bc:	01212223          	sw	s2,4(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
            vgaHandle->pxlData = iters;
 1c0:	1e000493          	li	s1,480
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 1c4:	10000e13          	li	t3,256
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 1c8:	025792b3          	mulh	t0,a5,t0
 1cc:	01a75713          	srli	a4,a4,0x1a
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:27
        if(xx + yy > QP_4) break;
 1d0:	10000eb7          	lui	t4,0x10000
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
            vgaHandle->pxlData = iters;
 1d4:	fff38393          	addi	t2,t2,-1 # ffffff <__stack_top+0xfeffff>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 1d8:	00629293          	slli	t0,t0,0x6
 1dc:	00e2e2b3          	or	t0,t0,a4
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:38
    int32_t xStart = xMin + (dx >> 1);
 1e0:	4012d313          	srai	t1,t0,0x1
 1e4:	00a30433          	add	s0,t1,a0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    int32_t yStart = yMin + (dx >> 1);
 1e8:	00c30333          	add	t1,t1,a2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:42
        int32_t x0 = xStart;
 1ec:	00040893          	mv	a7,s0
 1f0:	28000f93          	li	t6,640
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:23
    uint16_t iters = 0;
 1f4:	00000513          	li	a0,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 1f8:	00000593          	li	a1,0
 1fc:	00000793          	li	a5,0
 200:	00000693          	li	a3,0
 204:	00000713          	li	a4,0
 208:	00000613          	li	a2,0
 20c:	00000813          	li	a6,0
 210:	02f80833          	mul	a6,a6,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:28
        int32_t newX = xx - yy + x0;
 214:	40b70733          	sub	a4,a4,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 218:	00150513          	addi	a0,a0,1 # fa000001 <__stack_top+0xf9ff0001>
 21c:	01051513          	slli	a0,a0,0x10
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:28
        int32_t newX = xx - yy + x0;
 220:	01170733          	add	a4,a4,a7
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 224:	01055513          	srli	a0,a0,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 228:	02c686b3          	mul	a3,a3,a2
 22c:	02c7b5b3          	mulhu	a1,a5,a2
 230:	010686b3          	add	a3,a3,a6
 234:	41f75813          	srai	a6,a4,0x1f
 238:	02c787b3          	mul	a5,a5,a2
 23c:	00b686b3          	add	a3,a3,a1
 240:	00669693          	slli	a3,a3,0x6
 244:	00070613          	mv	a2,a4
 248:	01a7d793          	srli	a5,a5,0x1a
 24c:	00f6e7b3          	or	a5,a3,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:29
        int32_t newY = (qmul(x, y) << 1) + y0;
 250:	00179793          	slli	a5,a5,0x1
 254:	006787b3          	add	a5,a5,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:24
    for(; iters <= maxIters; iters++){
 258:	09c50a63          	beq	a0,t3,2ec <drawMandel+0x154>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:16
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 25c:	02c605b3          	mul	a1,a2,a2
 260:	41f7d693          	srai	a3,a5,0x1f
 264:	02c61733          	mulh	a4,a2,a2
 268:	01a5d593          	srli	a1,a1,0x1a
 26c:	00671713          	slli	a4,a4,0x6
 270:	00b76733          	or	a4,a4,a1
 274:	02f78933          	mul	s2,a5,a5
 278:	02f795b3          	mulh	a1,a5,a5
 27c:	01a95913          	srli	s2,s2,0x1a
 280:	00659593          	slli	a1,a1,0x6
 284:	0125e5b3          	or	a1,a1,s2
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:27
        if(xx + yy > QP_4) break;
 288:	00b70933          	add	s2,a4,a1
 28c:	f92ed2e3          	bge	t4,s2,210 <drawMandel+0x78>
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
            vgaHandle->pxlData = iters;
 290:	00757533          	and	a0,a0,t2
 294:	0ff57713          	andi	a4,a0,255
 298:	00855793          	srli	a5,a0,0x8
 29c:	00df4683          	lbu	a3,13(t5) # 1000000d <__stack_top+0xfff000d>
 2a0:	0ff7f793          	andi	a5,a5,255
 2a4:	00ef06a3          	sb	a4,13(t5)
 2a8:	00ef4703          	lbu	a4,14(t5)
 2ac:	01055513          	srli	a0,a0,0x10
 2b0:	00ff0723          	sb	a5,14(t5)
 2b4:	00ff4783          	lbu	a5,15(t5)
 2b8:	0ff57513          	andi	a0,a0,255
 2bc:	00af07a3          	sb	a0,15(t5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
        for(size_t i = 0; i < 640; i++){
 2c0:	ffff8f93          	addi	t6,t6,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
            x0 += dx;
 2c4:	005888b3          	add	a7,a7,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
        for(size_t i = 0; i < 640; i++){
 2c8:	f20f96e3          	bnez	t6,1f4 <drawMandel+0x5c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 2cc:	fff48493          	addi	s1,s1,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48 (discriminator 2)
        y0 += dx;
 2d0:	00530333          	add	t1,t1,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:41 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 2d4:	f0049ce3          	bnez	s1,1ec <drawMandel+0x54>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
}
 2d8:	00c12403          	lw	s0,12(sp)
 2dc:	00812483          	lw	s1,8(sp)
 2e0:	00412903          	lw	s2,4(sp)
 2e4:	01010113          	addi	sp,sp,16
 2e8:	00008067          	ret
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
 2ec:	00000513          	li	a0,0
 2f0:	fa5ff06f          	j	294 <drawMandel+0xfc>

000002f4 <setPalette0>:
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
    vgaHandle->pAddr = 0;
 2f4:	38002703          	lw	a4,896(zero) # 380 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
 2f8:	01000537          	lui	a0,0x1000
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
    vgaHandle->pAddr = 0;
 2fc:	0ff00693          	li	a3,255
 300:	000709a3          	sb	zero,19(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
        vgaHandle->pltData = (255 - i) << 16 | (255 - i) << 8 | (255 - i);
 304:	fff50513          	addi	a0,a0,-1 # ffffff <__stack_top+0xfeffff>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56 (discriminator 3)
 308:	01069613          	slli	a2,a3,0x10
 30c:	00869793          	slli	a5,a3,0x8
 310:	00c7e7b3          	or	a5,a5,a2
 314:	00d7e7b3          	or	a5,a5,a3
 318:	00a7f7b3          	and	a5,a5,a0
 31c:	0ff7f593          	andi	a1,a5,255
 320:	0087d613          	srli	a2,a5,0x8
 324:	01574803          	lbu	a6,21(a4)
 328:	0ff67613          	andi	a2,a2,255
 32c:	00b70aa3          	sb	a1,21(a4)
 330:	01674583          	lbu	a1,22(a4)
 334:	0107d793          	srli	a5,a5,0x10
 338:	00c70b23          	sb	a2,22(a4)
 33c:	01774603          	lbu	a2,23(a4)
 340:	0ff7f793          	andi	a5,a5,255
 344:	00f70ba3          	sb	a5,23(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:55 (discriminator 3)
    for(size_t i = 0; i < 255; i++){
 348:	fff68693          	addi	a3,a3,-1 # 35fffff <__stack_top+0x35effff>
 34c:	fa069ee3          	bnez	a3,308 <setPalette0+0x14>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:58
}
 350:	00008067          	ret
