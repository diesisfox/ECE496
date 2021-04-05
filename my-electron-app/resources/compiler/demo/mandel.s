
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
   0:	00002197          	auipc	gp,0x2
   4:	a1418193          	addi	gp,gp,-1516 # 1a14 <__global_pointer$>
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
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:205
    }
}

int main(void){
    // enable video
    vgaHandle->en = 1;
  18:	000017b7          	lui	a5,0x1
  1c:	2147a683          	lw	a3,532(a5) # 1214 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:203
int main(void){
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:205
    vgaHandle->en = 1;
  28:	00100793          	li	a5,1
  2c:	00f6a023          	sw	a5,0(a3)
setPalette2():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:197
    vgaHandle->pAddr = 0;
  30:	000017b7          	lui	a5,0x1
  34:	de878793          	addi	a5,a5,-536 # de8 <palette.0>
  38:	0006a823          	sw	zero,16(a3)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:198
    for(size_t i = 0; i < 256; i++){
  3c:	40078613          	addi	a2,a5,1024
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:199
        vgaHandle->pltData = palette[i];
  40:	0007a703          	lw	a4,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:198
    for(size_t i = 0; i < 256; i++){
  44:	00478793          	addi	a5,a5,4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:199
        vgaHandle->pltData = palette[i];
  48:	00e6aa23          	sw	a4,20(a3)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:198
    for(size_t i = 0; i < 256; i++){
  4c:	fec79ae3          	bne	a5,a2,40 <main+0x28>
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:212
    setPalette2();
    // set pixel address to 0
    // vgaHandle->xAddr = 0;
    // vgaHandle->yAddr = 0;
    // draw
    drawMandelInterlaced();
  50:	4b8000ef          	jal	ra,508 <drawMandelInterlaced>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:213 (discriminator 1)
    for(;;);
  54:	0000006f          	j	54 <main+0x3c>

00000058 <qmul>:
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
  58:	02b507b3          	mul	a5,a0,a1
  5c:	02b51533          	mulh	a0,a0,a1
  60:	01a7d793          	srli	a5,a5,0x1a
  64:	00651513          	slli	a0,a0,0x6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:40
}
  68:	00f56533          	or	a0,a0,a5
  6c:	00008067          	ret

00000070 <zoomIn>:
zoomIn():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:43
    if(scale == MAX_SCALING - 1) return;
  70:	80c1c683          	lbu	a3,-2036(gp) # 1220 <scale>
  74:	01200793          	li	a5,18
  78:	04f68c63          	beq	a3,a5,d0 <zoomIn+0x60>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    int32_t dx = DX_SCALE[scale];
  7c:	000017b7          	lui	a5,0x1
  80:	00269713          	slli	a4,a3,0x2
  84:	99c78793          	addi	a5,a5,-1636 # 99c <DX_SCALE>
  88:	00e787b3          	add	a5,a5,a4
  8c:	0007a603          	lw	a2,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
    xStart = xStart + 160 * dx;
  90:	00001837          	lui	a6,0x1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
    yStart = yStart + 120 * dx;
  94:	00001537          	lui	a0,0x1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
    xStart = xStart + 160 * dx;
  98:	21c82303          	lw	t1,540(a6) # 121c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
    yStart = yStart + 120 * dx;
  9c:	21852883          	lw	a7,536(a0) # 1218 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
    xStart = xStart + 160 * dx;
  a0:	00261713          	slli	a4,a2,0x2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
    yStart = yStart + 120 * dx;
  a4:	00461793          	slli	a5,a2,0x4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
    xStart = xStart + 160 * dx;
  a8:	00c70733          	add	a4,a4,a2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
    yStart = yStart + 120 * dx;
  ac:	40c787b3          	sub	a5,a5,a2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
    xStart = xStart + 160 * dx;
  b0:	00571713          	slli	a4,a4,0x5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
    yStart = yStart + 120 * dx;
  b4:	00379793          	slli	a5,a5,0x3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
    xStart = xStart + 160 * dx;
  b8:	00670733          	add	a4,a4,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
    yStart = yStart + 120 * dx;
  bc:	011787b3          	add	a5,a5,a7
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:47
    scale++;
  c0:	00168693          	addi	a3,a3,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
    xStart = xStart + 160 * dx;
  c4:	20e82e23          	sw	a4,540(a6)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:46
    yStart = yStart + 120 * dx;
  c8:	20f52c23          	sw	a5,536(a0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:47
    scale++;
  cc:	80d18623          	sb	a3,-2036(gp) # 1220 <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48
}
  d0:	00008067          	ret

000000d4 <zoomOut>:
zoomOut():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    if(scale == 0) return;
  d4:	80c1c783          	lbu	a5,-2036(gp) # 1220 <scale>
  d8:	0c078a63          	beqz	a5,1ac <zoomOut+0xd8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    scale --;
  dc:	fff78793          	addi	a5,a5,-1
  e0:	0ff7f793          	andi	a5,a5,255
  e4:	80f18623          	sb	a5,-2036(gp) # 1220 <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:53
    if(scale == 0){
  e8:	0c078463          	beqz	a5,1b0 <zoomOut+0xdc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:58
    int32_t dx = DX_SCALE[scale];
  ec:	00001737          	lui	a4,0x1
  f0:	99c70713          	addi	a4,a4,-1636 # 99c <DX_SCALE>
  f4:	00279793          	slli	a5,a5,0x2
  f8:	00f707b3          	add	a5,a4,a5
  fc:	0007a683          	lw	a3,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:59
    xStart = xStart - 160 * dx;
 100:	000018b7          	lui	a7,0x1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    yStart = yStart - 120 * dx;
 104:	00001837          	lui	a6,0x1
 108:	21882503          	lw	a0,536(a6) # 1218 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:59
    xStart = xStart - 160 * dx;
 10c:	21c8a583          	lw	a1,540(a7) # 121c <xStart>
 110:	00269713          	slli	a4,a3,0x2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    yStart = yStart - 120 * dx;
 114:	00469793          	slli	a5,a3,0x4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:59
    xStart = xStart - 160 * dx;
 118:	00d70733          	add	a4,a4,a3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    yStart = yStart - 120 * dx;
 11c:	40f68633          	sub	a2,a3,a5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:59
    xStart = xStart - 160 * dx;
 120:	00571313          	slli	t1,a4,0x5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    yStart = yStart - 120 * dx;
 124:	00361613          	slli	a2,a2,0x3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 128:	00771713          	slli	a4,a4,0x7
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:59
    xStart = xStart - 160 * dx;
 12c:	406585b3          	sub	a1,a1,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    yStart = yStart - 120 * dx;
 130:	00a60633          	add	a2,a2,a0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 134:	40d70733          	sub	a4,a4,a3
 138:	02fc6537          	lui	a0,0x2fc6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:59
    xStart = xStart - 160 * dx;
 13c:	20b8ae23          	sw	a1,540(a7)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
    yStart = yStart - 120 * dx;
 140:	20c82c23          	sw	a2,536(a6)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 144:	00b70733          	add	a4,a4,a1
 148:	66650513          	addi	a0,a0,1638 # 2fc6666 <__stack_top+0x2fb6666>
 14c:	00e55a63          	bge	a0,a4,160 <zoomOut+0x8c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:62 (discriminator 1)
 150:	d8100593          	li	a1,-639
 154:	02b685b3          	mul	a1,a3,a1
 158:	00a585b3          	add	a1,a1,a0
 15c:	20b8ae23          	sw	a1,540(a7)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:63
    if(yStart + 479 * dx > QP_Y_MAX) yStart = QP_Y_MAX - 479 * dx;
 160:	40d787b3          	sub	a5,a5,a3
 164:	00579793          	slli	a5,a5,0x5
 168:	40d787b3          	sub	a5,a5,a3
 16c:	035c6737          	lui	a4,0x35c6
 170:	00c787b3          	add	a5,a5,a2
 174:	66670713          	addi	a4,a4,1638 # 35c6666 <__stack_top+0x35b6666>
 178:	00f75a63          	bge	a4,a5,18c <zoomOut+0xb8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:63 (discriminator 1)
 17c:	e2100793          	li	a5,-479
 180:	02f686b3          	mul	a3,a3,a5
 184:	00e68633          	add	a2,a3,a4
 188:	20c82c23          	sw	a2,536(a6)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    if(xStart < QP_X_MIN) xStart = QP_X_MIN;
 18c:	fa03a7b7          	lui	a5,0xfa03a
 190:	99a78793          	addi	a5,a5,-1638 # fa03999a <__stack_top+0xfa02999a>
 194:	00f5d463          	bge	a1,a5,19c <zoomOut+0xc8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65 (discriminator 1)
 198:	20f8ae23          	sw	a5,540(a7)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:66
    if(yStart < QP_Y_MIN) yStart = QP_Y_MIN;
 19c:	fca3a7b7          	lui	a5,0xfca3a
 1a0:	99a78793          	addi	a5,a5,-1638 # fca3999a <__stack_top+0xfca2999a>
 1a4:	00f65463          	bge	a2,a5,1ac <zoomOut+0xd8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:66 (discriminator 1)
 1a8:	20f82c23          	sw	a5,536(a6)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
}
 1ac:	00008067          	ret
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:54
        xStart = QP_X_MIN;
 1b0:	fa03a7b7          	lui	a5,0xfa03a
 1b4:	00001737          	lui	a4,0x1
 1b8:	99a78793          	addi	a5,a5,-1638 # fa03999a <__stack_top+0xfa02999a>
 1bc:	20f72e23          	sw	a5,540(a4) # 121c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:55
        yStart = QP_Y_MIN;
 1c0:	fca3a7b7          	lui	a5,0xfca3a
 1c4:	00001737          	lui	a4,0x1
 1c8:	99a78793          	addi	a5,a5,-1638 # fca3999a <__stack_top+0xfca2999a>
 1cc:	20f72c23          	sw	a5,536(a4) # 1218 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
        return;
 1d0:	00008067          	ret

000001d4 <moveFrame>:
moveFrame():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:70
    int32_t dx = DX_SCALE[scale];
 1d4:	80c1c783          	lbu	a5,-2036(gp) # 1220 <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
        yStart += dx << MOVEPOWER;
 1d8:	000015b7          	lui	a1,0x1
 1dc:	2185a803          	lw	a6,536(a1) # 1218 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:70
    int32_t dx = DX_SCALE[scale];
 1e0:	00279713          	slli	a4,a5,0x2
 1e4:	000017b7          	lui	a5,0x1
 1e8:	99c78793          	addi	a5,a5,-1636 # 99c <DX_SCALE>
 1ec:	00e787b3          	add	a5,a5,a4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:71
    if(dirs & UP){
 1f0:	00257713          	andi	a4,a0,2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:70
    int32_t dx = DX_SCALE[scale];
 1f4:	0007a783          	lw	a5,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:71
    if(dirs & UP){
 1f8:	0c070463          	beqz	a4,2c0 <moveFrame+0xec>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
        yStart += dx << MOVEPOWER;
 1fc:	00679713          	slli	a4,a5,0x6
 200:	00e80833          	add	a6,a6,a4
 204:	2105ac23          	sw	a6,536(a1)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:77
        xStart += dx << MOVEPOWER;
 208:	000018b7          	lui	a7,0x1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:76
    if(dirs & RIGHT){
 20c:	00157713          	andi	a4,a0,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:77
        xStart += dx << MOVEPOWER;
 210:	21c8a683          	lw	a3,540(a7) # 121c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:76
    if(dirs & RIGHT){
 214:	08070a63          	beqz	a4,2a8 <moveFrame+0xd4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:77
        xStart += dx << MOVEPOWER;
 218:	00679713          	slli	a4,a5,0x6
 21c:	00e686b3          	add	a3,a3,a4
 220:	20d8ae23          	sw	a3,540(a7)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:82
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 224:	00279713          	slli	a4,a5,0x2
 228:	00f70733          	add	a4,a4,a5
 22c:	00771713          	slli	a4,a4,0x7
 230:	40f70733          	sub	a4,a4,a5
 234:	02fc6637          	lui	a2,0x2fc6
 238:	00d70733          	add	a4,a4,a3
 23c:	66660613          	addi	a2,a2,1638 # 2fc6666 <__stack_top+0x2fb6666>
 240:	00e65a63          	bge	a2,a4,254 <moveFrame+0x80>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:82 (discriminator 1)
 244:	d8100693          	li	a3,-639
 248:	02d786b3          	mul	a3,a5,a3
 24c:	00c686b3          	add	a3,a3,a2
 250:	20d8ae23          	sw	a3,540(a7)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:83
    if(yStart + 479 * dx > QP_Y_MAX) yStart = QP_Y_MAX - 479 * dx;
 254:	00479713          	slli	a4,a5,0x4
 258:	40f70733          	sub	a4,a4,a5
 25c:	00571713          	slli	a4,a4,0x5
 260:	40f70733          	sub	a4,a4,a5
 264:	035c6637          	lui	a2,0x35c6
 268:	01070733          	add	a4,a4,a6
 26c:	66660613          	addi	a2,a2,1638 # 35c6666 <__stack_top+0x35b6666>
 270:	00e65a63          	bge	a2,a4,284 <moveFrame+0xb0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:83 (discriminator 1)
 274:	e2100713          	li	a4,-479
 278:	02e787b3          	mul	a5,a5,a4
 27c:	00c78833          	add	a6,a5,a2
 280:	2105ac23          	sw	a6,536(a1)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:85
    if(xStart < QP_X_MIN) xStart = QP_X_MIN;
 284:	fa03a737          	lui	a4,0xfa03a
 288:	99a70713          	addi	a4,a4,-1638 # fa03999a <__stack_top+0xfa02999a>
 28c:	00e6d463          	bge	a3,a4,294 <moveFrame+0xc0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:85 (discriminator 1)
 290:	20e8ae23          	sw	a4,540(a7)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:86
    if(yStart < QP_Y_MIN) yStart = QP_Y_MIN;
 294:	fca3a737          	lui	a4,0xfca3a
 298:	99a70713          	addi	a4,a4,-1638 # fca3999a <__stack_top+0xfca2999a>
 29c:	00e85463          	bge	a6,a4,2a4 <moveFrame+0xd0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:86 (discriminator 1)
 2a0:	20e5ac23          	sw	a4,536(a1)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:87
}
 2a4:	00008067          	ret
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:78
    }else if(dirs & LEFT){
 2a8:	00857513          	andi	a0,a0,8
 2ac:	f6050ce3          	beqz	a0,224 <moveFrame+0x50>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:79
        xStart -= dx << MOVEPOWER;
 2b0:	00679713          	slli	a4,a5,0x6
 2b4:	40e686b3          	sub	a3,a3,a4
 2b8:	20d8ae23          	sw	a3,540(a7)
 2bc:	f69ff06f          	j	224 <moveFrame+0x50>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:73
    }else if(dirs & DOWN){
 2c0:	00457713          	andi	a4,a0,4
 2c4:	f40702e3          	beqz	a4,208 <moveFrame+0x34>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:74
        yStart -= dx << MOVEPOWER;
 2c8:	00679713          	slli	a4,a5,0x6
 2cc:	40e80833          	sub	a6,a6,a4
 2d0:	2105ac23          	sw	a6,536(a1)
 2d4:	f35ff06f          	j	208 <moveFrame+0x34>

000002d8 <getIters>:
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:89
uint8_t getIters(int32_t x0, int32_t y0){
 2d8:	00050e13          	mv	t3,a0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:93
    uint16_t iters = 0;
 2dc:	00000313          	li	t1,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 2e0:	00000713          	li	a4,0
 2e4:	00000613          	li	a2,0
 2e8:	00000f93          	li	t6,0
 2ec:	00000813          	li	a6,0
 2f0:	00000793          	li	a5,0
 2f4:	00000693          	li	a3,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 2f8:	10000e93          	li	t4,256
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 2fc:	10000f37          	lui	t5,0x10000
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 300:	02ff8fb3          	mul	t6,t6,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 304:	00130313          	addi	t1,t1,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
        int32_t newX = xx - yy + x0;
 308:	41070733          	sub	a4,a4,a6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 30c:	01031313          	slli	t1,t1,0x10
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
        int32_t newX = xx - yy + x0;
 310:	01c70733          	add	a4,a4,t3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 314:	01035313          	srli	t1,t1,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 318:	02c686b3          	mul	a3,a3,a2
 31c:	02c7b533          	mulhu	a0,a5,a2
 320:	01f686b3          	add	a3,a3,t6
 324:	41f75f93          	srai	t6,a4,0x1f
 328:	02c787b3          	mul	a5,a5,a2
 32c:	00a686b3          	add	a3,a3,a0
 330:	00669693          	slli	a3,a3,0x6
 334:	00070613          	mv	a2,a4
 338:	01a7d793          	srli	a5,a5,0x1a
 33c:	00f6e7b3          	or	a5,a3,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
        int32_t newY = (qmul(x, y) << 1) + y0;
 340:	00179793          	slli	a5,a5,0x1
 344:	00b787b3          	add	a5,a5,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 348:	05d30063          	beq	t1,t4,388 <getIters+0xb0>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 34c:	02c60533          	mul	a0,a2,a2
 350:	41f7d693          	srai	a3,a5,0x1f
 354:	02c61733          	mulh	a4,a2,a2
 358:	01a55513          	srli	a0,a0,0x1a
 35c:	02f788b3          	mul	a7,a5,a5
 360:	00671713          	slli	a4,a4,0x6
 364:	00a76733          	or	a4,a4,a0
 368:	02f79833          	mulh	a6,a5,a5
 36c:	01a8d893          	srli	a7,a7,0x1a
 370:	00681813          	slli	a6,a6,0x6
 374:	01186833          	or	a6,a6,a7
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 378:	00e80533          	add	a0,a6,a4
 37c:	f8af52e3          	bge	t5,a0,300 <getIters+0x28>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
    return iters;
 380:	0ff37513          	andi	a0,t1,255
 384:	00008067          	ret
 388:	00000513          	li	a0,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:104
}
 38c:	00008067          	ret

00000390 <drawMandel>:
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:107
    int32_t dx = DX_SCALE[scale];
 390:	80c1c783          	lbu	a5,-2036(gp) # 1220 <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:106
void drawMandel(void){
 394:	ff010113          	addi	sp,sp,-16
 398:	00812623          	sw	s0,12(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:107
    int32_t dx = DX_SCALE[scale];
 39c:	00279713          	slli	a4,a5,0x2
 3a0:	000017b7          	lui	a5,0x1
 3a4:	99c78793          	addi	a5,a5,-1636 # 99c <DX_SCALE>
 3a8:	00e787b3          	add	a5,a5,a4
 3ac:	0007af83          	lw	t6,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:108
    int32_t y0 = yStart;
 3b0:	000017b7          	lui	a5,0x1
 3b4:	2187a303          	lw	t1,536(a5) # 1218 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:110
        int32_t x0 = xStart;
 3b8:	000017b7          	lui	a5,0x1
 3bc:	21c7a403          	lw	s0,540(a5) # 121c <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:113
            vgaHandle->pxlData = iters;
 3c0:	000017b7          	lui	a5,0x1
 3c4:	2147a283          	lw	t0,532(a5) # 1214 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:106
void drawMandel(void){
 3c8:	00912423          	sw	s1,8(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:113
            vgaHandle->pxlData = iters;
 3cc:	1e000393          	li	t2,480
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 3d0:	10000e13          	li	t3,256
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 3d4:	10000eb7          	lui	t4,0x10000
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:110
        int32_t x0 = xStart;
 3d8:	00040893          	mv	a7,s0
 3dc:	28000f13          	li	t5,640
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:93
    uint16_t iters = 0;
 3e0:	00000513          	li	a0,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 3e4:	00000593          	li	a1,0
 3e8:	00000793          	li	a5,0
 3ec:	00000693          	li	a3,0
 3f0:	00000713          	li	a4,0
 3f4:	00000613          	li	a2,0
 3f8:	00000813          	li	a6,0
 3fc:	02f80833          	mul	a6,a6,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
        int32_t newX = xx - yy + x0;
 400:	40b70733          	sub	a4,a4,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 404:	00150513          	addi	a0,a0,1
 408:	01051513          	slli	a0,a0,0x10
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
        int32_t newX = xx - yy + x0;
 40c:	01170733          	add	a4,a4,a7
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 410:	01055513          	srli	a0,a0,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 414:	02c686b3          	mul	a3,a3,a2
 418:	02c7b5b3          	mulhu	a1,a5,a2
 41c:	010686b3          	add	a3,a3,a6
 420:	41f75813          	srai	a6,a4,0x1f
 424:	02c787b3          	mul	a5,a5,a2
 428:	00b686b3          	add	a3,a3,a1
 42c:	00669693          	slli	a3,a3,0x6
 430:	00070613          	mv	a2,a4
 434:	01a7d793          	srli	a5,a5,0x1a
 438:	00f6e7b3          	or	a5,a3,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
        int32_t newY = (qmul(x, y) << 1) + y0;
 43c:	00179793          	slli	a5,a5,0x1
 440:	006787b3          	add	a5,a5,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 444:	07c50263          	beq	a0,t3,4a8 <drawMandel+0x118>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 448:	02c605b3          	mul	a1,a2,a2
 44c:	41f7d693          	srai	a3,a5,0x1f
 450:	02c61733          	mulh	a4,a2,a2
 454:	01a5d593          	srli	a1,a1,0x1a
 458:	00671713          	slli	a4,a4,0x6
 45c:	00b76733          	or	a4,a4,a1
 460:	02f784b3          	mul	s1,a5,a5
 464:	02f795b3          	mulh	a1,a5,a5
 468:	01a4d493          	srli	s1,s1,0x1a
 46c:	00659593          	slli	a1,a1,0x6
 470:	0095e5b3          	or	a1,a1,s1
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 474:	00b704b3          	add	s1,a4,a1
 478:	f89ed2e3          	bge	t4,s1,3fc <drawMandel+0x6c>
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:113
            vgaHandle->pxlData = iters;
 47c:	00a2a623          	sw	a0,12(t0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111
        for(size_t i = 0; i < 640; i++){
 480:	ffff0f13          	addi	t5,t5,-1 # fffffff <__stack_top+0xffeffff>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:114
            x0 += dx;
 484:	01f888b3          	add	a7,a7,t6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111
        for(size_t i = 0; i < 640; i++){
 488:	f40f1ce3          	bnez	t5,3e0 <drawMandel+0x50>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:109 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 48c:	fff38393          	addi	t2,t2,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:116 (discriminator 2)
        y0 += dx;
 490:	01f30333          	add	t1,t1,t6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:109 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 494:	f40392e3          	bnez	t2,3d8 <drawMandel+0x48>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:118
}
 498:	00c12403          	lw	s0,12(sp)
 49c:	00812483          	lw	s1,8(sp)
 4a0:	01010113          	addi	sp,sp,16
 4a4:	00008067          	ret
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:118
 4a8:	00000513          	li	a0,0
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:113
            vgaHandle->pxlData = iters;
 4ac:	00a2a623          	sw	a0,12(t0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111
        for(size_t i = 0; i < 640; i++){
 4b0:	ffff0f13          	addi	t5,t5,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:114
            x0 += dx;
 4b4:	01f888b3          	add	a7,a7,t6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111
        for(size_t i = 0; i < 640; i++){
 4b8:	f20f14e3          	bnez	t5,3e0 <drawMandel+0x50>
 4bc:	fd1ff06f          	j	48c <drawMandel+0xfc>

000004c0 <paintBigPixel>:
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121
    for(uint8_t j = 0; j < 1<<pow; j++){
 4c0:	00100793          	li	a5,1
 4c4:	00d796b3          	sll	a3,a5,a3
 4c8:	02d05e63          	blez	a3,504 <paintBigPixel+0x44>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:122
        vgaHandle->yAddr = y + j;
 4cc:	000017b7          	lui	a5,0x1
 4d0:	2147a703          	lw	a4,532(a5) # 1214 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121
    for(uint8_t j = 0; j < 1<<pow; j++){
 4d4:	00000813          	li	a6,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:122
        vgaHandle->yAddr = y + j;
 4d8:	00b807b3          	add	a5,a6,a1
 4dc:	00f72423          	sw	a5,8(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:123
        vgaHandle->xAddr = x;
 4e0:	00a72223          	sw	a0,4(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:124
        for(uint8_t i =0; i < 1<<pow; i++){
 4e4:	00000793          	li	a5,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:124 (discriminator 3)
 4e8:	00178793          	addi	a5,a5,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:125 (discriminator 3)
            vgaHandle->pxlData = p;
 4ec:	00c72623          	sw	a2,12(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:124 (discriminator 3)
        for(uint8_t i =0; i < 1<<pow; i++){
 4f0:	0ff7f793          	andi	a5,a5,255
 4f4:	fed7cae3          	blt	a5,a3,4e8 <paintBigPixel+0x28>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121 (discriminator 2)
    for(uint8_t j = 0; j < 1<<pow; j++){
 4f8:	00180813          	addi	a6,a6,1
 4fc:	0ff87813          	andi	a6,a6,255
 500:	fcd84ce3          	blt	a6,a3,4d8 <paintBigPixel+0x18>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:128
}
 504:	00008067          	ret

00000508 <drawMandelInterlaced>:
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:131
    int32_t dx = DX_SCALE[scale];
 508:	80c1c783          	lbu	a5,-2036(gp) # 1220 <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:130
void drawMandelInterlaced(void){
 50c:	fd010113          	addi	sp,sp,-48
 510:	01812623          	sw	s8,12(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:131
    int32_t dx = DX_SCALE[scale];
 514:	00279713          	slli	a4,a5,0x2
 518:	000017b7          	lui	a5,0x1
 51c:	99c78793          	addi	a5,a5,-1636 # 99c <DX_SCALE>
 520:	00e787b3          	add	a5,a5,a4
 524:	0007a503          	lw	a0,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:133
    int32_t y0 = yStart;
 528:	000017b7          	lui	a5,0x1
 52c:	2187a703          	lw	a4,536(a5) # 1218 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:135
        int32_t x0 = xStart;
 530:	000017b7          	lui	a5,0x1
 534:	21c7ac03          	lw	s8,540(a5) # 121c <xStart>
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:122
        vgaHandle->yAddr = y + j;
 538:	000017b7          	lui	a5,0x1
 53c:	2147a783          	lw	a5,532(a5) # 1214 <vgaHandle>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:130
void drawMandelInterlaced(void){
 540:	02812623          	sw	s0,44(sp)
 544:	02912423          	sw	s1,40(sp)
 548:	03212223          	sw	s2,36(sp)
 54c:	03312023          	sw	s3,32(sp)
 550:	01412e23          	sw	s4,28(sp)
 554:	01512c23          	sw	s5,24(sp)
 558:	01612a23          	sw	s6,20(sp)
 55c:	01712823          	sw	s7,16(sp)
 560:	01912423          	sw	s9,8(sp)
 564:	01a12223          	sw	s10,4(sp)
 568:	01b12023          	sw	s11,0(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:139
            x0 += dx<<5;
 56c:	00551f13          	slli	t5,a0,0x5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:133
    int32_t y0 = yStart;
 570:	00070813          	mv	a6,a4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:139
            x0 += dx<<5;
 574:	02000e93          	li	t4,32
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 578:	10000893          	li	a7,256
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 57c:	10000337          	lui	t1,0x10000
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:136
        for(size_t i = 0; i < 640>>5; i++){
 580:	28000f93          	li	t6,640
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:134
    for(size_t j = 0; j < 480>>5; j++){
 584:	20000393          	li	t2,512
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:138
            paintBigPixel(i<<5, j<<5, iters, 5);
 588:	fe0e8293          	addi	t0,t4,-32 # fffffe0 <__stack_top+0xffeffe0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:135
        int32_t x0 = xStart;
 58c:	000c0593          	mv	a1,s8
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:138
            paintBigPixel(i<<5, j<<5, iters, 5);
 590:	00000e13          	li	t3,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:93
    uint16_t iters = 0;
 594:	00000413          	li	s0,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 598:	00000613          	li	a2,0
 59c:	00000693          	li	a3,0
 5a0:	00000a13          	li	s4,0
 5a4:	00000913          	li	s2,0
 5a8:	00000493          	li	s1,0
 5ac:	00000993          	li	s3,0
 5b0:	02d989b3          	mul	s3,s3,a3
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
        int32_t newX = xx - yy + x0;
 5b4:	40c90633          	sub	a2,s2,a2
 5b8:	00b60633          	add	a2,a2,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 5bc:	00140413          	addi	s0,s0,1
 5c0:	01041413          	slli	s0,s0,0x10
 5c4:	01045413          	srli	s0,s0,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 5c8:	029a0a33          	mul	s4,s4,s1
 5cc:	02d4b933          	mulhu	s2,s1,a3
 5d0:	014989b3          	add	s3,s3,s4
 5d4:	02d486b3          	mul	a3,s1,a3
 5d8:	00060493          	mv	s1,a2
 5dc:	01298633          	add	a2,s3,s2
 5e0:	00661613          	slli	a2,a2,0x6
 5e4:	41f4d993          	srai	s3,s1,0x1f
 5e8:	01a6d693          	srli	a3,a3,0x1a
 5ec:	00d666b3          	or	a3,a2,a3
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
        int32_t newY = (qmul(x, y) << 1) + y0;
 5f0:	00169693          	slli	a3,a3,0x1
 5f4:	010686b3          	add	a3,a3,a6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 5f8:	2f140a63          	beq	s0,a7,8ec <drawMandelInterlaced+0x3e4>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 5fc:	02948b33          	mul	s6,s1,s1
 600:	41f6da13          	srai	s4,a3,0x1f
 604:	02949633          	mulh	a2,s1,s1
 608:	01ab5b13          	srli	s6,s6,0x1a
 60c:	00661613          	slli	a2,a2,0x6
 610:	01666933          	or	s2,a2,s6
 614:	02d68ab3          	mul	s5,a3,a3
 618:	02d69633          	mulh	a2,a3,a3
 61c:	01aada93          	srli	s5,s5,0x1a
 620:	00661613          	slli	a2,a2,0x6
 624:	01566633          	or	a2,a2,s5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 628:	00c90ab3          	add	s5,s2,a2
 62c:	f95352e3          	bge	t1,s5,5b0 <drawMandelInterlaced+0xa8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121
    for(uint8_t j = 0; j < 1<<pow; j++){
 630:	00028613          	mv	a2,t0
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:122
        vgaHandle->yAddr = y + j;
 634:	00c7a423          	sw	a2,8(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:123
        vgaHandle->xAddr = x;
 638:	01c7a223          	sw	t3,4(a5)
 63c:	02000693          	li	a3,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:124
        for(uint8_t i =0; i < 1<<pow; i++){
 640:	fff68693          	addi	a3,a3,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:125
            vgaHandle->pxlData = p;
 644:	0087a623          	sw	s0,12(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:124
        for(uint8_t i =0; i < 1<<pow; i++){
 648:	0ff6f693          	andi	a3,a3,255
 64c:	fe069ae3          	bnez	a3,640 <drawMandelInterlaced+0x138>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121
    for(uint8_t j = 0; j < 1<<pow; j++){
 650:	00160613          	addi	a2,a2,1
 654:	fece90e3          	bne	t4,a2,634 <drawMandelInterlaced+0x12c>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:136 (discriminator 3)
        for(size_t i = 0; i < 640>>5; i++){
 658:	020e0e13          	addi	t3,t3,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:139 (discriminator 3)
            x0 += dx<<5;
 65c:	01e585b3          	add	a1,a1,t5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:136 (discriminator 3)
        for(size_t i = 0; i < 640>>5; i++){
 660:	f3fe1ae3          	bne	t3,t6,594 <drawMandelInterlaced+0x8c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:134 (discriminator 2)
    for(size_t j = 0; j < 480>>5; j++){
 664:	020e8e93          	addi	t4,t4,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:141 (discriminator 2)
        y0 += dx<<5;
 668:	01e80833          	add	a6,a6,t5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:134 (discriminator 2)
    for(size_t j = 0; j < 480>>5; j++){
 66c:	f07e9ee3          	bne	t4,t2,588 <drawMandelInterlaced+0x80>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:144
    for(int l = 4; l; l--){
 670:	00400a13          	li	s4,4
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 674:	10000393          	li	t2,256
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 678:	10000437          	lui	s0,0x10000
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:146
        for(size_t j = 0; j < 480>>l; j++){
 67c:	1e000693          	li	a3,480
 680:	4146dab3          	sra	s5,a3,s4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:148
            for(size_t i = 0; i < 640>>l; i++){
 684:	28000693          	li	a3,640
 688:	4146d9b3          	sra	s3,a3,s4
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121
    for(uint8_t j = 0; j < 1<<pow; j++){
 68c:	00100693          	li	a3,1
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:153
                x0 += dx<<l;
 690:	014512b3          	sll	t0,a0,s4
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121
    for(uint8_t j = 0; j < 1<<pow; j++){
 694:	014698b3          	sll	a7,a3,s4
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:145
        int32_t y0 = yStart;
 698:	00070e13          	mv	t3,a4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:146
        for(size_t j = 0; j < 480>>l; j++){
 69c:	00000913          	li	s2,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:151
                    paintBigPixel(i<<l, j<<l, iters, l);
 6a0:	01491eb3          	sll	t4,s2,s4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:149
                if((j&1)|(i&i)){
 6a4:	00197493          	andi	s1,s2,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:147
            int32_t x0 = xStart;
 6a8:	000c0b13          	mv	s6,s8
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:148
            for(size_t i = 0; i < 640>>l; i++){
 6ac:	00000b93          	li	s7,0
 6b0:	00c0006f          	j	6bc <drawMandelInterlaced+0x1b4>
 6b4:	000f0b93          	mv	s7,t5
 6b8:	000f8b13          	mv	s6,t6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:149
                if((j&1)|(i&i)){
 6bc:	009be6b3          	or	a3,s7,s1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:148
            for(size_t i = 0; i < 640>>l; i++){
 6c0:	001b8f13          	addi	t5,s7,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:153
                x0 += dx<<l;
 6c4:	01628fb3          	add	t6,t0,s6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:149
                if((j&1)|(i&i)){
 6c8:	fe0686e3          	beqz	a3,6b4 <drawMandelInterlaced+0x1ac>
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:93
    uint16_t iters = 0;
 6cc:	00000593          	li	a1,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 6d0:	00000613          	li	a2,0
 6d4:	00000693          	li	a3,0
 6d8:	00000c93          	li	s9,0
 6dc:	00000d13          	li	s10,0
 6e0:	00000813          	li	a6,0
 6e4:	00000313          	li	t1,0
 6e8:	030c8cb3          	mul	s9,s9,a6
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
        int32_t newX = xx - yy + x0;
 6ec:	40cd0633          	sub	a2,s10,a2
 6f0:	01660633          	add	a2,a2,s6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 6f4:	00158593          	addi	a1,a1,1
 6f8:	01059593          	slli	a1,a1,0x10
 6fc:	0105d593          	srli	a1,a1,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 700:	02d30333          	mul	t1,t1,a3
 704:	0306bd33          	mulhu	s10,a3,a6
 708:	006c8333          	add	t1,s9,t1
 70c:	030686b3          	mul	a3,a3,a6
 710:	00060813          	mv	a6,a2
 714:	01a30633          	add	a2,t1,s10
 718:	00661613          	slli	a2,a2,0x6
 71c:	41f85313          	srai	t1,a6,0x1f
 720:	01a6d693          	srli	a3,a3,0x1a
 724:	00d666b3          	or	a3,a2,a3
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
        int32_t newY = (qmul(x, y) << 1) + y0;
 728:	00169693          	slli	a3,a3,0x1
 72c:	01c686b3          	add	a3,a3,t3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 730:	1c758263          	beq	a1,t2,8f4 <drawMandelInterlaced+0x3ec>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 734:	03080633          	mul	a2,a6,a6
 738:	41f6dc93          	srai	s9,a3,0x1f
 73c:	03081d33          	mulh	s10,a6,a6
 740:	01a65613          	srli	a2,a2,0x1a
 744:	006d1d13          	slli	s10,s10,0x6
 748:	00cd6d33          	or	s10,s10,a2
 74c:	02d68db3          	mul	s11,a3,a3
 750:	02d69633          	mulh	a2,a3,a3
 754:	01addd93          	srli	s11,s11,0x1a
 758:	00661613          	slli	a2,a2,0x6
 75c:	01b66633          	or	a2,a2,s11
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 760:	00cd0db3          	add	s11,s10,a2
 764:	f9b452e3          	bge	s0,s11,6e8 <drawMandelInterlaced+0x1e0>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:151
                    paintBigPixel(i<<l, j<<l, iters, l);
 768:	014b9bb3          	sll	s7,s7,s4
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121
    for(uint8_t j = 0; j < 1<<pow; j++){
 76c:	00000613          	li	a2,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:122
        vgaHandle->yAddr = y + j;
 770:	01d606b3          	add	a3,a2,t4
 774:	00d7a423          	sw	a3,8(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:123
        vgaHandle->xAddr = x;
 778:	0177a223          	sw	s7,4(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:124
        for(uint8_t i =0; i < 1<<pow; i++){
 77c:	00000693          	li	a3,0
 780:	00168693          	addi	a3,a3,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:125
            vgaHandle->pxlData = p;
 784:	00b7a623          	sw	a1,12(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:124
        for(uint8_t i =0; i < 1<<pow; i++){
 788:	0ff6f693          	andi	a3,a3,255
 78c:	ff16cae3          	blt	a3,a7,780 <drawMandelInterlaced+0x278>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121
    for(uint8_t j = 0; j < 1<<pow; j++){
 790:	00160613          	addi	a2,a2,1
 794:	0ff67613          	andi	a2,a2,255
 798:	fd164ce3          	blt	a2,a7,770 <drawMandelInterlaced+0x268>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:148 (discriminator 2)
            for(size_t i = 0; i < 640>>l; i++){
 79c:	f13f6ce3          	bltu	t5,s3,6b4 <drawMandelInterlaced+0x1ac>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:146 (discriminator 2)
        for(size_t j = 0; j < 480>>l; j++){
 7a0:	00190913          	addi	s2,s2,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:155 (discriminator 2)
            y0 += dx<<l;
 7a4:	005e0e33          	add	t3,t3,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:146 (discriminator 2)
        for(size_t j = 0; j < 480>>l; j++){
 7a8:	ef591ce3          	bne	s2,s5,6a0 <drawMandelInterlaced+0x198>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:144 (discriminator 2)
    for(int l = 4; l; l--){
 7ac:	fffa0a13          	addi	s4,s4,-1
 7b0:	ec0a16e3          	bnez	s4,67c <drawMandelInterlaced+0x174>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:160
    for(size_t j = 0; j < 480; j++){
 7b4:	00000493          	li	s1,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:168
                vgaHandle->xAddr = i+1;
 7b8:	00100393          	li	t2,1
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 7bc:	10000e13          	li	t3,256
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 7c0:	10000eb7          	lui	t4,0x10000
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:163
        for(size_t i = 0; i < 640; i++){
 7c4:	28000413          	li	s0,640
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:160
    for(size_t j = 0; j < 480; j++){
 7c8:	1e000913          	li	s2,480
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:163
        for(size_t i = 0; i < 640; i++){
 7cc:	00000f13          	li	t5,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
            if((j&1)|(i&i)){
 7d0:	0014f293          	andi	t0,s1,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:161
        int32_t x0 = xStart;
 7d4:	000c0313          	mv	t1,s8
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
            if((j&1)|(i&i)){
 7d8:	005f66b3          	or	a3,t5,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:162
        vgaHandle->yAddr = j;
 7dc:	0097a423          	sw	s1,8(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:170
            x0 += dx;
 7e0:	00650fb3          	add	t6,a0,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:163
        for(size_t i = 0; i < 640; i++){
 7e4:	001f0f13          	addi	t5,t5,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
            if((j&1)|(i&i)){
 7e8:	00069e63          	bnez	a3,804 <drawMandelInterlaced+0x2fc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:168
                vgaHandle->xAddr = i+1;
 7ec:	0077a223          	sw	t2,4(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:163
        for(size_t i = 0; i < 640; i++){
 7f0:	000f8313          	mv	t1,t6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
            if((j&1)|(i&i)){
 7f4:	005f66b3          	or	a3,t5,t0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:170
            x0 += dx;
 7f8:	00650fb3          	add	t6,a0,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:163
        for(size_t i = 0; i < 640; i++){
 7fc:	001f0f13          	addi	t5,t5,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
            if((j&1)|(i&i)){
 800:	fe0686e3          	beqz	a3,7ec <drawMandelInterlaced+0x2e4>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 804:	00000613          	li	a2,0
 808:	00000993          	li	s3,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:93
    uint16_t iters = 0;
 80c:	00000893          	li	a7,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 810:	00000693          	li	a3,0
 814:	00000a93          	li	s5,0
 818:	00000813          	li	a6,0
 81c:	00000a13          	li	s4,0
 820:	02da0a33          	mul	s4,s4,a3
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
        int32_t newX = xx - yy + x0;
 824:	40c98633          	sub	a2,s3,a2
 828:	00660633          	add	a2,a2,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 82c:	00188893          	addi	a7,a7,1
 830:	01089893          	slli	a7,a7,0x10
 834:	0108d893          	srli	a7,a7,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 838:	030a8ab3          	mul	s5,s5,a6
 83c:	02d835b3          	mulhu	a1,a6,a3
 840:	015a0a33          	add	s4,s4,s5
 844:	02d806b3          	mul	a3,a6,a3
 848:	00060813          	mv	a6,a2
 84c:	00ba0633          	add	a2,s4,a1
 850:	00661613          	slli	a2,a2,0x6
 854:	41f85a13          	srai	s4,a6,0x1f
 858:	01a6d693          	srli	a3,a3,0x1a
 85c:	00d666b3          	or	a3,a2,a3
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
        int32_t newY = (qmul(x, y) << 1) + y0;
 860:	00169693          	slli	a3,a3,0x1
 864:	00e686b3          	add	a3,a3,a4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
    for(; iters <= maxIters; iters++){
 868:	09c88a63          	beq	a7,t3,8fc <drawMandelInterlaced+0x3f4>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:39
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 86c:	030805b3          	mul	a1,a6,a6
 870:	41f6da93          	srai	s5,a3,0x1f
 874:	030819b3          	mulh	s3,a6,a6
 878:	01a5d593          	srli	a1,a1,0x1a
 87c:	00699993          	slli	s3,s3,0x6
 880:	00b9e9b3          	or	s3,s3,a1
 884:	02d68633          	mul	a2,a3,a3
 888:	02d695b3          	mulh	a1,a3,a3
 88c:	01a65613          	srli	a2,a2,0x1a
 890:	00659593          	slli	a1,a1,0x6
 894:	00c5e633          	or	a2,a1,a2
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:97
        if(xx + yy > QP_4) break;
 898:	00c985b3          	add	a1,s3,a2
 89c:	f8bed2e3          	bge	t4,a1,820 <drawMandelInterlaced+0x318>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:166
                vgaHandle->pxlData = iters;
 8a0:	0117a623          	sw	a7,12(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:163
        for(size_t i = 0; i < 640; i++){
 8a4:	f48f16e3          	bne	t5,s0,7f0 <drawMandelInterlaced+0x2e8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:160 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 8a8:	00148493          	addi	s1,s1,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:172 (discriminator 2)
        y0 += dx;
 8ac:	00a70733          	add	a4,a4,a0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:160 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 8b0:	f1249ee3          	bne	s1,s2,7cc <drawMandelInterlaced+0x2c4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:174
}
 8b4:	02c12403          	lw	s0,44(sp)
 8b8:	02812483          	lw	s1,40(sp)
 8bc:	02412903          	lw	s2,36(sp)
 8c0:	02012983          	lw	s3,32(sp)
 8c4:	01c12a03          	lw	s4,28(sp)
 8c8:	01812a83          	lw	s5,24(sp)
 8cc:	01412b03          	lw	s6,20(sp)
 8d0:	01012b83          	lw	s7,16(sp)
 8d4:	00c12c03          	lw	s8,12(sp)
 8d8:	00812c83          	lw	s9,8(sp)
 8dc:	00412d03          	lw	s10,4(sp)
 8e0:	00012d83          	lw	s11,0(sp)
 8e4:	03010113          	addi	sp,sp,48
 8e8:	00008067          	ret
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:174
 8ec:	00000413          	li	s0,0
 8f0:	d41ff06f          	j	630 <drawMandelInterlaced+0x128>
 8f4:	00000593          	li	a1,0
 8f8:	e71ff06f          	j	768 <drawMandelInterlaced+0x260>
 8fc:	00000893          	li	a7,0
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:166
                vgaHandle->pxlData = iters;
 900:	0117a623          	sw	a7,12(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:163
        for(size_t i = 0; i < 640; i++){
 904:	ee8f16e3          	bne	t5,s0,7f0 <drawMandelInterlaced+0x2e8>
 908:	fa1ff06f          	j	8a8 <drawMandelInterlaced+0x3a0>

0000090c <setPalette0>:
setPalette0():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:178
    vgaHandle->pAddr = 0;
 90c:	000017b7          	lui	a5,0x1
 910:	2147a603          	lw	a2,532(a5) # 1214 <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:179
    for(int i = 255; i >= 0; i--){
 914:	fff00593          	li	a1,-1
 918:	0ff00793          	li	a5,255
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:178
    vgaHandle->pAddr = 0;
 91c:	00062823          	sw	zero,16(a2)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:180 (discriminator 3)
        vgaHandle->pltData = i << 16 | i << 8 | i;
 920:	01079713          	slli	a4,a5,0x10
 924:	00879693          	slli	a3,a5,0x8
 928:	00d76733          	or	a4,a4,a3
 92c:	00f76733          	or	a4,a4,a5
 930:	00e62a23          	sw	a4,20(a2)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:179 (discriminator 3)
    for(int i = 255; i >= 0; i--){
 934:	fff78793          	addi	a5,a5,-1
 938:	feb794e3          	bne	a5,a1,920 <setPalette0+0x14>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:182
}
 93c:	00008067          	ret

00000940 <setPalette1>:
setPalette1():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:188
    vgaHandle->pAddr = 0;
 940:	000017b7          	lui	a5,0x1
 944:	2147a603          	lw	a2,532(a5) # 1214 <vgaHandle>
 948:	000016b7          	lui	a3,0x1
 94c:	99c68693          	addi	a3,a3,-1636 # 99c <DX_SCALE>
 950:	04c68793          	addi	a5,a3,76
 954:	00062823          	sw	zero,16(a2)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:189
    for(size_t i = 0; i < 256; i++){
 958:	44c68693          	addi	a3,a3,1100
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:190 (discriminator 3)
        vgaHandle->pltData = palette[i];
 95c:	0007a703          	lw	a4,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:189 (discriminator 3)
    for(size_t i = 0; i < 256; i++){
 960:	00478793          	addi	a5,a5,4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:190 (discriminator 3)
        vgaHandle->pltData = palette[i];
 964:	00e62a23          	sw	a4,20(a2)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:189 (discriminator 3)
    for(size_t i = 0; i < 256; i++){
 968:	fed79ae3          	bne	a5,a3,95c <setPalette1+0x1c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:192
}
 96c:	00008067          	ret

00000970 <setPalette2>:
setPalette2():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:197
    vgaHandle->pAddr = 0;
 970:	000017b7          	lui	a5,0x1
 974:	2147a683          	lw	a3,532(a5) # 1214 <vgaHandle>
 978:	000017b7          	lui	a5,0x1
 97c:	de878793          	addi	a5,a5,-536 # de8 <palette.0>
 980:	0006a823          	sw	zero,16(a3)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:198
    for(size_t i = 0; i < 256; i++){
 984:	40078613          	addi	a2,a5,1024
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:199 (discriminator 3)
        vgaHandle->pltData = palette[i];
 988:	0007a703          	lw	a4,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:198 (discriminator 3)
    for(size_t i = 0; i < 256; i++){
 98c:	00478793          	addi	a5,a5,4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:199 (discriminator 3)
        vgaHandle->pltData = palette[i];
 990:	00e6aa23          	sw	a4,20(a3)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:198 (discriminator 3)
    for(size_t i = 0; i < 256; i++){
 994:	fec79ae3          	bne	a5,a2,988 <setPalette2+0x18>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:201
}
 998:	00008067          	ret
