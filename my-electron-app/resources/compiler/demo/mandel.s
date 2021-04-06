
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
   0:	00003197          	auipc	gp,0x3
   4:	48818193          	addi	gp,gp,1160 # 3488 <__global_pointer$>
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
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:240
    return ret;
}

int main(void){
    // enable video
    vgaHandle->en = 1;
  18:	000037b7          	lui	a5,0x3
  1c:	c8c7a603          	lw	a2,-884(a5) # 2c8c <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:238
int main(void){
  20:	ff010113          	addi	sp,sp,-16
  24:	000017b7          	lui	a5,0x1
  28:	bf078793          	addi	a5,a5,-1040 # bf0 <DX_SCALE>
  2c:	00112623          	sw	ra,12(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:240
    vgaHandle->en = 1;
  30:	00100713          	li	a4,1
  34:	06c78593          	addi	a1,a5,108
  38:	00e62023          	sw	a4,0(a2)
setPalette():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:211
    else for(int i = 255; i >= 0; i--) vgaHandle->pltData = palette[i];
  3c:	46878793          	addi	a5,a5,1128
  40:	0007a683          	lw	a3,0(a5)
  44:	00078713          	mv	a4,a5
  48:	ffc78793          	addi	a5,a5,-4
  4c:	00d62a23          	sw	a3,20(a2)
  50:	fee598e3          	bne	a1,a4,40 <main+0x28>
main():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:248
    // set pixel address to 0
    // vgaHandle->xAddr = 0;
    // vgaHandle->yAddr = 0;
    // draw
    for(;;){
        int update = drawMandelInterlaced();
  54:	6bc000ef          	jal	ra,710 <drawMandelInterlaced>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:249
        if(!update){
  58:	fe051ee3          	bnez	a0,54 <main+0x3c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:250 (discriminator 1)
            while(!processSw());
  5c:	50c000ef          	jal	ra,568 <processSw>
  60:	fe051ae3          	bnez	a0,54 <main+0x3c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:250
  64:	504000ef          	jal	ra,568 <processSw>
  68:	fe050ae3          	beqz	a0,5c <main+0x44>
  6c:	fe9ff06f          	j	54 <main+0x3c>

00000070 <qmul>:
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
  70:	02b507b3          	mul	a5,a0,a1
  74:	02b51533          	mulh	a0,a0,a1
  78:	01a7d793          	srli	a5,a5,0x1a
  7c:	00651513          	slli	a0,a0,0x6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:45
}
  80:	00f56533          	or	a0,a0,a5
  84:	00008067          	ret

00000088 <zoomIn>:
zoomIn():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48
    if(scale == MAX_SCALING - 1) return;
  88:	8141c683          	lbu	a3,-2028(gp) # 2c9c <scale>
  8c:	01200793          	li	a5,18
  90:	04f68a63          	beq	a3,a5,e4 <zoomIn+0x5c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:49
    int32_t dx = DX_SCALE[scale];
  94:	000017b7          	lui	a5,0x1
  98:	00269713          	slli	a4,a3,0x2
  9c:	bf078793          	addi	a5,a5,-1040 # bf0 <DX_SCALE>
  a0:	00e787b3          	add	a5,a5,a4
  a4:	0007a603          	lw	a2,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
  a8:	00003537          	lui	a0,0x3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
  ac:	80c1a303          	lw	t1,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
  b0:	c9052883          	lw	a7,-880(a0) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
  b4:	00261713          	slli	a4,a2,0x2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
  b8:	00461793          	slli	a5,a2,0x4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
  bc:	00c70733          	add	a4,a4,a2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
  c0:	40c787b3          	sub	a5,a5,a2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
  c4:	00571713          	slli	a4,a4,0x5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
  c8:	00379793          	slli	a5,a5,0x3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
  cc:	00670733          	add	a4,a4,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
  d0:	011787b3          	add	a5,a5,a7
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    scale++;
  d4:	00168693          	addi	a3,a3,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
  d8:	80e1a623          	sw	a4,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
  dc:	c8f52823          	sw	a5,-880(a0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    scale++;
  e0:	80d18a23          	sb	a3,-2028(gp) # 2c9c <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:53
}
  e4:	00008067          	ret

000000e8 <zoomOut>:
zoomOut():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:56
    if(scale == 0) return;
  e8:	8141c783          	lbu	a5,-2028(gp) # 2c9c <scale>
  ec:	0c078863          	beqz	a5,1bc <zoomOut+0xd4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:57
    scale --;
  f0:	fff78793          	addi	a5,a5,-1
  f4:	0ff7f793          	andi	a5,a5,255
  f8:	80f18a23          	sb	a5,-2028(gp) # 2c9c <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:58
    if(scale == 0){
  fc:	0c078263          	beqz	a5,1c0 <zoomOut+0xd8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:63
    int32_t dx = DX_SCALE[scale];
 100:	00001737          	lui	a4,0x1
 104:	bf070713          	addi	a4,a4,-1040 # bf0 <DX_SCALE>
 108:	00279793          	slli	a5,a5,0x2
 10c:	00f707b3          	add	a5,a4,a5
 110:	0007a683          	lw	a3,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    yStart = yStart - 120 * dx;
 114:	00003837          	lui	a6,0x3
 118:	c9082503          	lw	a0,-880(a6) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    xStart = xStart - 160 * dx;
 11c:	80c1a583          	lw	a1,-2036(gp) # 2c94 <xStart>
 120:	00269713          	slli	a4,a3,0x2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    yStart = yStart - 120 * dx;
 124:	00469793          	slli	a5,a3,0x4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    xStart = xStart - 160 * dx;
 128:	00d70733          	add	a4,a4,a3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    yStart = yStart - 120 * dx;
 12c:	40f68633          	sub	a2,a3,a5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    xStart = xStart - 160 * dx;
 130:	00571313          	slli	t1,a4,0x5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    yStart = yStart - 120 * dx;
 134:	00361613          	slli	a2,a2,0x3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 138:	00771713          	slli	a4,a4,0x7
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    xStart = xStart - 160 * dx;
 13c:	406585b3          	sub	a1,a1,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    yStart = yStart - 120 * dx;
 140:	00a60633          	add	a2,a2,a0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 144:	40d70733          	sub	a4,a4,a3
 148:	02fc6537          	lui	a0,0x2fc6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:64
    xStart = xStart - 160 * dx;
 14c:	80b1a623          	sw	a1,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:65
    yStart = yStart - 120 * dx;
 150:	c8c82823          	sw	a2,-880(a6)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 154:	00b70733          	add	a4,a4,a1
 158:	66650513          	addi	a0,a0,1638 # 2fc6666 <__stack_top+0x2fb6666>
 15c:	00e55a63          	bge	a0,a4,170 <zoomOut+0x88>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:67 (discriminator 1)
 160:	d8100593          	li	a1,-639
 164:	02b685b3          	mul	a1,a3,a1
 168:	00a585b3          	add	a1,a1,a0
 16c:	80b1a623          	sw	a1,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:68
    if(yStart + 479 * dx > QP_Y_MAX) yStart = QP_Y_MAX - 479 * dx;
 170:	40d787b3          	sub	a5,a5,a3
 174:	00579793          	slli	a5,a5,0x5
 178:	40d787b3          	sub	a5,a5,a3
 17c:	035c6737          	lui	a4,0x35c6
 180:	00c787b3          	add	a5,a5,a2
 184:	66670713          	addi	a4,a4,1638 # 35c6666 <__stack_top+0x35b6666>
 188:	00f75a63          	bge	a4,a5,19c <zoomOut+0xb4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:68 (discriminator 1)
 18c:	e2100793          	li	a5,-479
 190:	02f686b3          	mul	a3,a3,a5
 194:	00e68633          	add	a2,a3,a4
 198:	c8c82823          	sw	a2,-880(a6)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:70
    if(xStart < QP_X_MIN) xStart = QP_X_MIN;
 19c:	fa03a7b7          	lui	a5,0xfa03a
 1a0:	99a78793          	addi	a5,a5,-1638 # fa03999a <__stack_top+0xfa02999a>
 1a4:	00f5d463          	bge	a1,a5,1ac <zoomOut+0xc4>
 1a8:	80f1a623          	sw	a5,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:71
    if(yStart < QP_Y_MIN) yStart = QP_Y_MIN;
 1ac:	fca3a7b7          	lui	a5,0xfca3a
 1b0:	99a78793          	addi	a5,a5,-1638 # fca3999a <__stack_top+0xfca2999a>
 1b4:	00f65463          	bge	a2,a5,1bc <zoomOut+0xd4>
 1b8:	c8f82823          	sw	a5,-880(a6)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:72
}
 1bc:	00008067          	ret
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:59
        xStart = QP_X_MIN;
 1c0:	fa03a7b7          	lui	a5,0xfa03a
 1c4:	99a78793          	addi	a5,a5,-1638 # fa03999a <__stack_top+0xfa02999a>
 1c8:	80f1a623          	sw	a5,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:60
        yStart = QP_Y_MIN;
 1cc:	fca3a7b7          	lui	a5,0xfca3a
 1d0:	00003737          	lui	a4,0x3
 1d4:	99a78793          	addi	a5,a5,-1638 # fca3999a <__stack_top+0xfca2999a>
 1d8:	c8f72823          	sw	a5,-880(a4) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:61
        return;
 1dc:	00008067          	ret

000001e0 <moveFrame>:
moveFrame():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:75
    int32_t dx = DX_SCALE[scale];
 1e0:	8141c783          	lbu	a5,-2028(gp) # 2c9c <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:77
        yStart += dx << MOVEPOWER;
 1e4:	000035b7          	lui	a1,0x3
 1e8:	c905a803          	lw	a6,-880(a1) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:75
    int32_t dx = DX_SCALE[scale];
 1ec:	00279713          	slli	a4,a5,0x2
 1f0:	000017b7          	lui	a5,0x1
 1f4:	bf078793          	addi	a5,a5,-1040 # bf0 <DX_SCALE>
 1f8:	00e787b3          	add	a5,a5,a4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:76
    if(dirs & UP){
 1fc:	00257713          	andi	a4,a0,2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:75
    int32_t dx = DX_SCALE[scale];
 200:	0007a783          	lw	a5,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:76
    if(dirs & UP){
 204:	0c070263          	beqz	a4,2c8 <moveFrame+0xe8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:77
        yStart += dx << MOVEPOWER;
 208:	00679713          	slli	a4,a5,0x6
 20c:	00e80833          	add	a6,a6,a4
 210:	c905a823          	sw	a6,-880(a1)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:81
    if(dirs & RIGHT){
 214:	00157713          	andi	a4,a0,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:82
        xStart += dx << MOVEPOWER;
 218:	80c1a683          	lw	a3,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:81
    if(dirs & RIGHT){
 21c:	08070a63          	beqz	a4,2b0 <moveFrame+0xd0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:82
        xStart += dx << MOVEPOWER;
 220:	00679713          	slli	a4,a5,0x6
 224:	00e686b3          	add	a3,a3,a4
 228:	80d1a623          	sw	a3,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:87
    if(xStart + 639 * dx > QP_X_MAX) xStart = QP_X_MAX - 639 * dx;
 22c:	00279713          	slli	a4,a5,0x2
 230:	00f70733          	add	a4,a4,a5
 234:	00771713          	slli	a4,a4,0x7
 238:	40f70733          	sub	a4,a4,a5
 23c:	02fc6637          	lui	a2,0x2fc6
 240:	00d70733          	add	a4,a4,a3
 244:	66660613          	addi	a2,a2,1638 # 2fc6666 <__stack_top+0x2fb6666>
 248:	00e65a63          	bge	a2,a4,25c <moveFrame+0x7c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:87 (discriminator 1)
 24c:	d8100693          	li	a3,-639
 250:	02d786b3          	mul	a3,a5,a3
 254:	00c686b3          	add	a3,a3,a2
 258:	80d1a623          	sw	a3,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:88
    if(yStart + 479 * dx > QP_Y_MAX) yStart = QP_Y_MAX - 479 * dx;
 25c:	00479713          	slli	a4,a5,0x4
 260:	40f70733          	sub	a4,a4,a5
 264:	00571713          	slli	a4,a4,0x5
 268:	40f70733          	sub	a4,a4,a5
 26c:	035c6637          	lui	a2,0x35c6
 270:	01070733          	add	a4,a4,a6
 274:	66660613          	addi	a2,a2,1638 # 35c6666 <__stack_top+0x35b6666>
 278:	00e65a63          	bge	a2,a4,28c <moveFrame+0xac>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:88 (discriminator 1)
 27c:	e2100713          	li	a4,-479
 280:	02e787b3          	mul	a5,a5,a4
 284:	00c78833          	add	a6,a5,a2
 288:	c905a823          	sw	a6,-880(a1)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:90
    if(xStart < QP_X_MIN) xStart = QP_X_MIN;
 28c:	fa03a737          	lui	a4,0xfa03a
 290:	99a70713          	addi	a4,a4,-1638 # fa03999a <__stack_top+0xfa02999a>
 294:	00e6d463          	bge	a3,a4,29c <moveFrame+0xbc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:90 (discriminator 1)
 298:	80e1a623          	sw	a4,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:91
    if(yStart < QP_Y_MIN) yStart = QP_Y_MIN;
 29c:	fca3a737          	lui	a4,0xfca3a
 2a0:	99a70713          	addi	a4,a4,-1638 # fca3999a <__stack_top+0xfca2999a>
 2a4:	00e85463          	bge	a6,a4,2ac <moveFrame+0xcc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:91 (discriminator 1)
 2a8:	c8e5a823          	sw	a4,-880(a1)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:92
}
 2ac:	00008067          	ret
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:83
    }else if(dirs & LEFT){
 2b0:	00857513          	andi	a0,a0,8
 2b4:	f6050ce3          	beqz	a0,22c <moveFrame+0x4c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:84
        xStart -= dx << MOVEPOWER;
 2b8:	00679713          	slli	a4,a5,0x6
 2bc:	40e686b3          	sub	a3,a3,a4
 2c0:	80d1a623          	sw	a3,-2036(gp) # 2c94 <xStart>
 2c4:	f69ff06f          	j	22c <moveFrame+0x4c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:78
    }else if(dirs & DOWN){
 2c8:	00457713          	andi	a4,a0,4
 2cc:	f40704e3          	beqz	a4,214 <moveFrame+0x34>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:79
        yStart -= dx << MOVEPOWER;
 2d0:	00679713          	slli	a4,a5,0x6
 2d4:	40e80833          	sub	a6,a6,a4
 2d8:	c905a823          	sw	a6,-880(a1)
 2dc:	f39ff06f          	j	214 <moveFrame+0x34>

000002e0 <getIters>:
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:94
uint8_t getIters(int32_t x0, int32_t y0){
 2e0:	00050e13          	mv	t3,a0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
    uint16_t iters = 0;
 2e4:	00000313          	li	t1,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 2e8:	00000713          	li	a4,0
 2ec:	00000613          	li	a2,0
 2f0:	00000f93          	li	t6,0
 2f4:	00000813          	li	a6,0
 2f8:	00000793          	li	a5,0
 2fc:	00000693          	li	a3,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 300:	0ff00e93          	li	t4,255
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 304:	10000f37          	lui	t5,0x10000
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 308:	02ff8fb3          	mul	t6,t6,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 30c:	00130313          	addi	t1,t1,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
        int32_t newX = xx - yy + x0;
 310:	41070733          	sub	a4,a4,a6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 314:	01031313          	slli	t1,t1,0x10
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
        int32_t newX = xx - yy + x0;
 318:	01c70733          	add	a4,a4,t3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 31c:	01035313          	srli	t1,t1,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 320:	02c686b3          	mul	a3,a3,a2
 324:	02c7b533          	mulhu	a0,a5,a2
 328:	01f686b3          	add	a3,a3,t6
 32c:	41f75f93          	srai	t6,a4,0x1f
 330:	02c787b3          	mul	a5,a5,a2
 334:	00a686b3          	add	a3,a3,a0
 338:	00669693          	slli	a3,a3,0x6
 33c:	00070613          	mv	a2,a4
 340:	01a7d793          	srli	a5,a5,0x1a
 344:	00f6e7b3          	or	a5,a3,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:104
        int32_t newY = (qmul(x, y) << 1) + y0;
 348:	00179793          	slli	a5,a5,0x1
 34c:	00b787b3          	add	a5,a5,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 350:	05d30063          	beq	t1,t4,390 <getIters+0xb0>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 354:	02c60533          	mul	a0,a2,a2
 358:	41f7d693          	srai	a3,a5,0x1f
 35c:	02c61733          	mulh	a4,a2,a2
 360:	01a55513          	srli	a0,a0,0x1a
 364:	02f788b3          	mul	a7,a5,a5
 368:	00671713          	slli	a4,a4,0x6
 36c:	00a76733          	or	a4,a4,a0
 370:	02f79833          	mulh	a6,a5,a5
 374:	01a8d893          	srli	a7,a7,0x1a
 378:	00681813          	slli	a6,a6,0x6
 37c:	01186833          	or	a6,a6,a7
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 380:	00e80533          	add	a0,a6,a4
 384:	f8af52e3          	bge	t5,a0,308 <getIters+0x28>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:108
    return iters;
 388:	0ff37513          	andi	a0,t1,255
 38c:	00008067          	ret
 390:	0ff00513          	li	a0,255
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:109
}
 394:	00008067          	ret

00000398 <drawMandel>:
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:112
    int32_t dx = DX_SCALE[scale];
 398:	8141c783          	lbu	a5,-2028(gp) # 2c9c <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111
void drawMandel(void){
 39c:	ff010113          	addi	sp,sp,-16
 3a0:	00812623          	sw	s0,12(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:112
    int32_t dx = DX_SCALE[scale];
 3a4:	00279713          	slli	a4,a5,0x2
 3a8:	000017b7          	lui	a5,0x1
 3ac:	bf078793          	addi	a5,a5,-1040 # bf0 <DX_SCALE>
 3b0:	00e787b3          	add	a5,a5,a4
 3b4:	0007af83          	lw	t6,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:113
    int32_t y0 = yStart;
 3b8:	000037b7          	lui	a5,0x3
 3bc:	c907a303          	lw	t1,-880(a5) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:115
        int32_t x0 = xStart;
 3c0:	80c1a403          	lw	s0,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:118
            vgaHandle->pxlData = iters;
 3c4:	000037b7          	lui	a5,0x3
 3c8:	c8c7a283          	lw	t0,-884(a5) # 2c8c <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:111
void drawMandel(void){
 3cc:	00912423          	sw	s1,8(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:118
            vgaHandle->pxlData = iters;
 3d0:	1e000393          	li	t2,480
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 3d4:	0ff00e13          	li	t3,255
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 3d8:	10000eb7          	lui	t4,0x10000
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:115
        int32_t x0 = xStart;
 3dc:	00040893          	mv	a7,s0
 3e0:	28000f13          	li	t5,640
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
    uint16_t iters = 0;
 3e4:	00000513          	li	a0,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 3e8:	00000593          	li	a1,0
 3ec:	00000793          	li	a5,0
 3f0:	00000693          	li	a3,0
 3f4:	00000713          	li	a4,0
 3f8:	00000613          	li	a2,0
 3fc:	00000813          	li	a6,0
 400:	02f80833          	mul	a6,a6,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
        int32_t newX = xx - yy + x0;
 404:	40b70733          	sub	a4,a4,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 408:	00150513          	addi	a0,a0,1
 40c:	01051513          	slli	a0,a0,0x10
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
        int32_t newX = xx - yy + x0;
 410:	01170733          	add	a4,a4,a7
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 414:	01055513          	srli	a0,a0,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 418:	02c686b3          	mul	a3,a3,a2
 41c:	02c7b5b3          	mulhu	a1,a5,a2
 420:	010686b3          	add	a3,a3,a6
 424:	41f75813          	srai	a6,a4,0x1f
 428:	02c787b3          	mul	a5,a5,a2
 42c:	00b686b3          	add	a3,a3,a1
 430:	00669693          	slli	a3,a3,0x6
 434:	00070613          	mv	a2,a4
 438:	01a7d793          	srli	a5,a5,0x1a
 43c:	00f6e7b3          	or	a5,a3,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:104
        int32_t newY = (qmul(x, y) << 1) + y0;
 440:	00179793          	slli	a5,a5,0x1
 444:	006787b3          	add	a5,a5,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 448:	07c50263          	beq	a0,t3,4ac <drawMandel+0x114>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 44c:	02c605b3          	mul	a1,a2,a2
 450:	41f7d693          	srai	a3,a5,0x1f
 454:	02c61733          	mulh	a4,a2,a2
 458:	01a5d593          	srli	a1,a1,0x1a
 45c:	00671713          	slli	a4,a4,0x6
 460:	00b76733          	or	a4,a4,a1
 464:	02f784b3          	mul	s1,a5,a5
 468:	02f795b3          	mulh	a1,a5,a5
 46c:	01a4d493          	srli	s1,s1,0x1a
 470:	00659593          	slli	a1,a1,0x6
 474:	0095e5b3          	or	a1,a1,s1
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 478:	00b704b3          	add	s1,a4,a1
 47c:	f89ed2e3          	bge	t4,s1,400 <drawMandel+0x68>
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:118
            vgaHandle->pxlData = iters;
 480:	00a2a623          	sw	a0,12(t0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:116
        for(size_t i = 0; i < 640; i++){
 484:	ffff0f13          	addi	t5,t5,-1 # fffffff <__stack_top+0xffeffff>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:119
            x0 += dx;
 488:	01f888b3          	add	a7,a7,t6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:116
        for(size_t i = 0; i < 640; i++){
 48c:	f40f1ce3          	bnez	t5,3e4 <drawMandel+0x4c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:114 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 490:	fff38393          	addi	t2,t2,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:121 (discriminator 2)
        y0 += dx;
 494:	01f30333          	add	t1,t1,t6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:114 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 498:	f40392e3          	bnez	t2,3dc <drawMandel+0x44>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:123
}
 49c:	00c12403          	lw	s0,12(sp)
 4a0:	00812483          	lw	s1,8(sp)
 4a4:	01010113          	addi	sp,sp,16
 4a8:	00008067          	ret
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:123
 4ac:	0ff00513          	li	a0,255
drawMandel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:118
            vgaHandle->pxlData = iters;
 4b0:	00a2a623          	sw	a0,12(t0)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:116
        for(size_t i = 0; i < 640; i++){
 4b4:	ffff0f13          	addi	t5,t5,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:119
            x0 += dx;
 4b8:	01f888b3          	add	a7,a7,t6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:116
        for(size_t i = 0; i < 640; i++){
 4bc:	f20f14e3          	bnez	t5,3e4 <drawMandel+0x4c>
 4c0:	fd1ff06f          	j	490 <drawMandel+0xf8>

000004c4 <paintBigPixel>:
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126
    for(uint8_t j = 0; j < 1<<pow; j++){
 4c4:	00100793          	li	a5,1
 4c8:	00d796b3          	sll	a3,a5,a3
 4cc:	02d05e63          	blez	a3,508 <paintBigPixel+0x44>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:127
        vgaHandle->yAddr = y + j;
 4d0:	000037b7          	lui	a5,0x3
 4d4:	c8c7a703          	lw	a4,-884(a5) # 2c8c <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126
    for(uint8_t j = 0; j < 1<<pow; j++){
 4d8:	00000813          	li	a6,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:127
        vgaHandle->yAddr = y + j;
 4dc:	00b807b3          	add	a5,a6,a1
 4e0:	00f72423          	sw	a5,8(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:128
        vgaHandle->xAddr = x;
 4e4:	00a72223          	sw	a0,4(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:129
        for(uint8_t i =0; i < 1<<pow; i++){
 4e8:	00000793          	li	a5,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:129 (discriminator 3)
 4ec:	00178793          	addi	a5,a5,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:130 (discriminator 3)
            vgaHandle->pxlData = p;
 4f0:	00c72623          	sw	a2,12(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:129 (discriminator 3)
        for(uint8_t i =0; i < 1<<pow; i++){
 4f4:	0ff7f793          	andi	a5,a5,255
 4f8:	fed7cae3          	blt	a5,a3,4ec <paintBigPixel+0x28>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126 (discriminator 2)
    for(uint8_t j = 0; j < 1<<pow; j++){
 4fc:	00180813          	addi	a6,a6,1
 500:	0ff87813          	andi	a6,a6,255
 504:	fcd84ce3          	blt	a6,a3,4dc <paintBigPixel+0x18>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:133
}
 508:	00008067          	ret

0000050c <setPalette>:
setPalette():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:209
    uint32_t const * const palette = palettes[sw>>1];
 50c:	00155793          	srli	a5,a0,0x1
 510:	00279713          	slli	a4,a5,0x2
 514:	000017b7          	lui	a5,0x1
 518:	bf078793          	addi	a5,a5,-1040 # bf0 <DX_SCALE>
 51c:	00e787b3          	add	a5,a5,a4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:210
    if(dir) for(int i = 0; i < 256; i++) vgaHandle->pltData = palette[i];
 520:	00157513          	andi	a0,a0,1
 524:	00003737          	lui	a4,0x3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:209
    uint32_t const * const palette = palettes[sw>>1];
 528:	04c7a783          	lw	a5,76(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:210
    if(dir) for(int i = 0; i < 256; i++) vgaHandle->pltData = palette[i];
 52c:	c8c72683          	lw	a3,-884(a4) # 2c8c <vgaHandle>
 530:	00050e63          	beqz	a0,54c <setPalette+0x40>
 534:	40078613          	addi	a2,a5,1024
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:210 (discriminator 4)
 538:	0007a703          	lw	a4,0(a5)
 53c:	00478793          	addi	a5,a5,4
 540:	00e6aa23          	sw	a4,20(a3)
 544:	fef61ae3          	bne	a2,a5,538 <setPalette+0x2c>
 548:	00008067          	ret
 54c:	3fc78713          	addi	a4,a5,1020
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:211 (discriminator 3)
    else for(int i = 255; i >= 0; i--) vgaHandle->pltData = palette[i];
 550:	00072583          	lw	a1,0(a4)
 554:	00070613          	mv	a2,a4
 558:	ffc70713          	addi	a4,a4,-4
 55c:	00b6aa23          	sw	a1,20(a3)
 560:	fec798e3          	bne	a5,a2,550 <setPalette+0x44>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:212
}
 564:	00008067          	ret

00000568 <processSw>:
processSw():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:215
    uint32_t newSw = *sw;
 568:	000037b7          	lui	a5,0x3
 56c:	c887a703          	lw	a4,-888(a5) # 2c88 <sw>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:214
int processSw(){
 570:	ff010113          	addi	sp,sp,-16
 574:	01212023          	sw	s2,0(sp)
 578:	00912223          	sw	s1,4(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:217
    if(newSw != lastSw){
 57c:	8101a783          	lw	a5,-2032(gp) # 2c98 <lastSw>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:215
    uint32_t newSw = *sw;
 580:	00072483          	lw	s1,0(a4)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:214
int processSw(){
 584:	00112623          	sw	ra,12(sp)
 588:	00812423          	sw	s0,8(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:216
    int ret = 0;
 58c:	00000513          	li	a0,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:217
    if(newSw != lastSw){
 590:	08978c63          	beq	a5,s1,628 <processSw+0xc0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:218
        uint32_t changes = newSw & ~lastSw;
 594:	fff7c793          	not	a5,a5
 598:	0097f433          	and	s0,a5,s1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:219
        if(changes&0xf){
 59c:	00f47793          	andi	a5,s0,15
 5a0:	0a079263          	bnez	a5,644 <processSw+0xdc>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:223
        if(changes&0x10){
 5a4:	01047793          	andi	a5,s0,16
 5a8:	06078263          	beqz	a5,60c <processSw+0xa4>
zoomIn():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48
    if(scale == MAX_SCALING - 1) return;
 5ac:	8141c683          	lbu	a3,-2028(gp) # 2c9c <scale>
 5b0:	01200793          	li	a5,18
processSw():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:224
            ret = 1;
 5b4:	00100513          	li	a0,1
zoomIn():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:48
    if(scale == MAX_SCALING - 1) return;
 5b8:	04f68a63          	beq	a3,a5,60c <processSw+0xa4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:49
    int32_t dx = DX_SCALE[scale];
 5bc:	000017b7          	lui	a5,0x1
 5c0:	00269713          	slli	a4,a3,0x2
 5c4:	bf078793          	addi	a5,a5,-1040 # bf0 <DX_SCALE>
 5c8:	00e787b3          	add	a5,a5,a4
 5cc:	0007a603          	lw	a2,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
 5d0:	00003837          	lui	a6,0x3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
 5d4:	80c1ae03          	lw	t3,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
 5d8:	c9082303          	lw	t1,-880(a6) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
 5dc:	00261713          	slli	a4,a2,0x2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
 5e0:	00461793          	slli	a5,a2,0x4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
 5e4:	00c70733          	add	a4,a4,a2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
 5e8:	40c787b3          	sub	a5,a5,a2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
 5ec:	00571713          	slli	a4,a4,0x5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
 5f0:	00379793          	slli	a5,a5,0x3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
 5f4:	01c70733          	add	a4,a4,t3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
 5f8:	006787b3          	add	a5,a5,t1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    scale++;
 5fc:	00168693          	addi	a3,a3,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:50
    xStart = xStart + 160 * dx;
 600:	80e1a623          	sw	a4,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:51
    yStart = yStart + 120 * dx;
 604:	c8f82823          	sw	a5,-880(a6)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:52
    scale++;
 608:	80d18a23          	sb	a3,-2028(gp) # 2c9c <scale>
processSw():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:227
        if(changes & 0x20){
 60c:	02047413          	andi	s0,s0,32
 610:	0a041663          	bnez	s0,6bc <processSw+0x154>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:231
        uint32_t flips = newSw ^ lastSw;
 614:	8101a783          	lw	a5,-2032(gp) # 2c98 <lastSw>
 618:	00f4c7b3          	xor	a5,s1,a5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:232
        if((flips >> 6) & 0xf) setPalette((newSw >> 6) & 0xf);
 61c:	0067d793          	srli	a5,a5,0x6
 620:	00f7f793          	andi	a5,a5,15
 624:	02079c63          	bnez	a5,65c <processSw+0xf4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:236
}
 628:	00c12083          	lw	ra,12(sp)
 62c:	00812403          	lw	s0,8(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:234
    lastSw = newSw;
 630:	8091a823          	sw	s1,-2032(gp) # 2c98 <lastSw>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:236
}
 634:	00412483          	lw	s1,4(sp)
 638:	00012903          	lw	s2,0(sp)
 63c:	01010113          	addi	sp,sp,16
 640:	00008067          	ret
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:221
            moveFrame(changes&0xf);
 644:	00078513          	mv	a0,a5
 648:	b99ff0ef          	jal	ra,1e0 <moveFrame>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:223
        if(changes&0x10){
 64c:	01047793          	andi	a5,s0,16
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:220
            ret = 1;
 650:	00100513          	li	a0,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:223
        if(changes&0x10){
 654:	fa078ce3          	beqz	a5,60c <processSw+0xa4>
 658:	f55ff06f          	j	5ac <processSw+0x44>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:232 (discriminator 1)
        if((flips >> 6) & 0xf) setPalette((newSw >> 6) & 0xf);
 65c:	0064d793          	srli	a5,s1,0x6
 660:	0ff7f793          	andi	a5,a5,255
setPalette():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:209 (discriminator 1)
    uint32_t const * const palette = palettes[sw>>1];
 664:	00179693          	slli	a3,a5,0x1
 668:	01c6f713          	andi	a4,a3,28
 66c:	000016b7          	lui	a3,0x1
 670:	bf068693          	addi	a3,a3,-1040 # bf0 <DX_SCALE>
 674:	00e686b3          	add	a3,a3,a4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:210 (discriminator 1)
    if(dir) for(int i = 0; i < 256; i++) vgaHandle->pltData = palette[i];
 678:	0017f713          	andi	a4,a5,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:209 (discriminator 1)
    uint32_t const * const palette = palettes[sw>>1];
 67c:	04c6a783          	lw	a5,76(a3)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:210 (discriminator 1)
    if(dir) for(int i = 0; i < 256; i++) vgaHandle->pltData = palette[i];
 680:	000036b7          	lui	a3,0x3
 684:	c8c6a683          	lw	a3,-884(a3) # 2c8c <vgaHandle>
 688:	04070a63          	beqz	a4,6dc <processSw+0x174>
 68c:	40078613          	addi	a2,a5,1024
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:210
 690:	0007a703          	lw	a4,0(a5)
 694:	00478793          	addi	a5,a5,4
 698:	00e6aa23          	sw	a4,20(a3)
 69c:	fef61ae3          	bne	a2,a5,690 <processSw+0x128>
processSw():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:236
}
 6a0:	00c12083          	lw	ra,12(sp)
 6a4:	00812403          	lw	s0,8(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:234
    lastSw = newSw;
 6a8:	8091a823          	sw	s1,-2032(gp) # 2c98 <lastSw>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:236
}
 6ac:	00412483          	lw	s1,4(sp)
 6b0:	00012903          	lw	s2,0(sp)
 6b4:	01010113          	addi	sp,sp,16
 6b8:	00008067          	ret
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:229
            zoomOut();
 6bc:	a2dff0ef          	jal	ra,e8 <zoomOut>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:231
        uint32_t flips = newSw ^ lastSw;
 6c0:	8101a783          	lw	a5,-2032(gp) # 2c98 <lastSw>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:228
            ret = 1;
 6c4:	00100513          	li	a0,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:231
        uint32_t flips = newSw ^ lastSw;
 6c8:	00f4c7b3          	xor	a5,s1,a5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:232
        if((flips >> 6) & 0xf) setPalette((newSw >> 6) & 0xf);
 6cc:	0067d793          	srli	a5,a5,0x6
 6d0:	00f7f793          	andi	a5,a5,15
 6d4:	f4078ae3          	beqz	a5,628 <processSw+0xc0>
 6d8:	f85ff06f          	j	65c <processSw+0xf4>
 6dc:	3fc78713          	addi	a4,a5,1020
setPalette():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:211
    else for(int i = 255; i >= 0; i--) vgaHandle->pltData = palette[i];
 6e0:	00072583          	lw	a1,0(a4)
 6e4:	00070613          	mv	a2,a4
 6e8:	ffc70713          	addi	a4,a4,-4
 6ec:	00b6aa23          	sw	a1,20(a3)
 6f0:	fec798e3          	bne	a5,a2,6e0 <processSw+0x178>
processSw():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:236
}
 6f4:	00c12083          	lw	ra,12(sp)
 6f8:	00812403          	lw	s0,8(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:234
    lastSw = newSw;
 6fc:	8091a823          	sw	s1,-2032(gp) # 2c98 <lastSw>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:236
}
 700:	00412483          	lw	s1,4(sp)
 704:	00012903          	lw	s2,0(sp)
 708:	01010113          	addi	sp,sp,16
 70c:	00008067          	ret

00000710 <drawMandelInterlaced>:
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:136
    int32_t dx = DX_SCALE[scale];
 710:	8141c783          	lbu	a5,-2028(gp) # 2c9c <scale>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:135
int drawMandelInterlaced(void){
 714:	fb010113          	addi	sp,sp,-80
 718:	05212023          	sw	s2,64(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:136
    int32_t dx = DX_SCALE[scale];
 71c:	00279713          	slli	a4,a5,0x2
 720:	000017b7          	lui	a5,0x1
 724:	bf078793          	addi	a5,a5,-1040 # bf0 <DX_SCALE>
 728:	00e787b3          	add	a5,a5,a4
 72c:	0007a783          	lw	a5,0(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:139
    int32_t y0 = yStart;
 730:	00003737          	lui	a4,0x3
 734:	c9072903          	lw	s2,-880(a4) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:135
int drawMandelInterlaced(void){
 738:	03412c23          	sw	s4,56(sp)
 73c:	03612823          	sw	s6,48(sp)
 740:	03712623          	sw	s7,44(sp)
 744:	03812423          	sw	s8,40(sp)
 748:	04112623          	sw	ra,76(sp)
 74c:	04812423          	sw	s0,72(sp)
 750:	04912223          	sw	s1,68(sp)
 754:	03312e23          	sw	s3,60(sp)
 758:	03512a23          	sw	s5,52(sp)
 75c:	03912223          	sw	s9,36(sp)
 760:	03a12023          	sw	s10,32(sp)
 764:	01b12e23          	sw	s11,28(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:136
    int32_t dx = DX_SCALE[scale];
 768:	00f12023          	sw	a5,0(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:150
            x0 += dx<<5;
 76c:	00579c13          	slli	s8,a5,0x5
 770:	02000b13          	li	s6,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:137
    int32_t itersAccum = 0;
 774:	00000513          	li	a0,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 778:	10000a37          	lui	s4,0x10000
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:127
        vgaHandle->yAddr = y + j;
 77c:	00003bb7          	lui	s7,0x3
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:141
        int32_t x0 = xStart;
 780:	80c1a483          	lw	s1,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:149
            paintBigPixel(i<<5, j<<5, iters, 5);
 784:	fe0b0d13          	addi	s10,s6,-32
 788:	00000a93          	li	s5,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 78c:	0ff00993          	li	s3,255
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:145
            if(itersAccum > 4096){
 790:	00001cb7          	lui	s9,0x1
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
    uint16_t iters = 0;
 794:	00000413          	li	s0,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 798:	00000613          	li	a2,0
 79c:	00000793          	li	a5,0
 7a0:	00000813          	li	a6,0
 7a4:	00000713          	li	a4,0
 7a8:	00000693          	li	a3,0
 7ac:	00000593          	li	a1,0
 7b0:	02f585b3          	mul	a1,a1,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
        int32_t newX = xx - yy + x0;
 7b4:	40c70733          	sub	a4,a4,a2
 7b8:	00970733          	add	a4,a4,s1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 7bc:	00140413          	addi	s0,s0,1
 7c0:	01041413          	slli	s0,s0,0x10
 7c4:	01045413          	srli	s0,s0,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 7c8:	02d80833          	mul	a6,a6,a3
 7cc:	02f6b633          	mulhu	a2,a3,a5
 7d0:	010585b3          	add	a1,a1,a6
 7d4:	02f687b3          	mul	a5,a3,a5
 7d8:	00070693          	mv	a3,a4
 7dc:	00c58733          	add	a4,a1,a2
 7e0:	00671713          	slli	a4,a4,0x6
 7e4:	41f6d593          	srai	a1,a3,0x1f
 7e8:	01a7d793          	srli	a5,a5,0x1a
 7ec:	00f767b3          	or	a5,a4,a5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:104
        int32_t newY = (qmul(x, y) << 1) + y0;
 7f0:	00179793          	slli	a5,a5,0x1
 7f4:	012787b3          	add	a5,a5,s2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 7f8:	37340e63          	beq	s0,s3,b74 <drawMandelInterlaced+0x464>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 7fc:	02d68633          	mul	a2,a3,a3
 800:	41f7d813          	srai	a6,a5,0x1f
 804:	02d69733          	mulh	a4,a3,a3
 808:	01a65613          	srli	a2,a2,0x1a
 80c:	00671713          	slli	a4,a4,0x6
 810:	00c76733          	or	a4,a4,a2
 814:	02f788b3          	mul	a7,a5,a5
 818:	02f79633          	mulh	a2,a5,a5
 81c:	01a8d893          	srli	a7,a7,0x1a
 820:	00661613          	slli	a2,a2,0x6
 824:	01166633          	or	a2,a2,a7
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 828:	00c708b3          	add	a7,a4,a2
 82c:	f91a52e3          	bge	s4,a7,7b0 <drawMandelInterlaced+0xa0>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:144
            itersAccum += iters;
 830:	00040793          	mv	a5,s0
 834:	00f50533          	add	a0,a0,a5
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:145
            if(itersAccum > 4096){
 838:	2eacc863          	blt	s9,a0,b28 <drawMandelInterlaced+0x418>
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:127 (discriminator 2)
        vgaHandle->yAddr = y + j;
 83c:	c8cba783          	lw	a5,-884(s7) # 2c8c <vgaHandle>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:130 (discriminator 2)
            vgaHandle->pxlData = p;
 840:	000d0693          	mv	a3,s10
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:127
        vgaHandle->yAddr = y + j;
 844:	00d7a423          	sw	a3,8(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:128
        vgaHandle->xAddr = x;
 848:	0157a223          	sw	s5,4(a5)
 84c:	02000713          	li	a4,32
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:129
        for(uint8_t i =0; i < 1<<pow; i++){
 850:	fff70713          	addi	a4,a4,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:130
            vgaHandle->pxlData = p;
 854:	0087a623          	sw	s0,12(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:129
        for(uint8_t i =0; i < 1<<pow; i++){
 858:	0ff77713          	andi	a4,a4,255
 85c:	fe071ae3          	bnez	a4,850 <drawMandelInterlaced+0x140>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126
    for(uint8_t j = 0; j < 1<<pow; j++){
 860:	00168693          	addi	a3,a3,1
 864:	fedb10e3          	bne	s6,a3,844 <drawMandelInterlaced+0x134>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:142 (discriminator 2)
        for(size_t i = 0; i < 640>>5; i++){
 868:	020a8a93          	addi	s5,s5,32
 86c:	28000713          	li	a4,640
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:150 (discriminator 2)
            x0 += dx<<5;
 870:	018484b3          	add	s1,s1,s8
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:142 (discriminator 2)
        for(size_t i = 0; i < 640>>5; i++){
 874:	f2ea90e3          	bne	s5,a4,794 <drawMandelInterlaced+0x84>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:140 (discriminator 2)
    for(size_t j = 0; j < 480>>5; j++){
 878:	020b0b13          	addi	s6,s6,32
 87c:	20000713          	li	a4,512
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:152 (discriminator 2)
        y0 += dx<<5;
 880:	01890933          	add	s2,s2,s8
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:140 (discriminator 2)
    for(size_t j = 0; j < 480>>5; j++){
 884:	eeeb1ee3          	bne	s6,a4,780 <drawMandelInterlaced+0x70>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:155
    for(int l = 4; l; l--){
 888:	00400c13          	li	s8,4
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 88c:	0ff00993          	li	s3,255
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 890:	10000a37          	lui	s4,0x10000
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:156
        int32_t y0 = yStart;
 894:	00003737          	lui	a4,0x3
 898:	c9072903          	lw	s2,-880(a4) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:169
                x0 += dx<<l;
 89c:	00012703          	lw	a4,0(sp)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:157
        for(size_t j = 0; j < 480>>l; j++){
 8a0:	00000593          	li	a1,0
 8a4:	1e000893          	li	a7,480
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:169
                x0 += dx<<l;
 8a8:	01871cb3          	sll	s9,a4,s8
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:159
            for(size_t i = 0; i < 640>>l; i++){
 8ac:	28000813          	li	a6,640
 8b0:	000c0713          	mv	a4,s8
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126
    for(uint8_t j = 0; j < 1<<pow; j++){
 8b4:	00100413          	li	s0,1
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:157
        for(size_t j = 0; j < 480>>l; j++){
 8b8:	4188d8b3          	sra	a7,a7,s8
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:159
            for(size_t i = 0; i < 640>>l; i++){
 8bc:	41885833          	sra	a6,a6,s8
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126
    for(uint8_t j = 0; j < 1<<pow; j++){
 8c0:	01841433          	sll	s0,s0,s8
 8c4:	001c9d13          	slli	s10,s9,0x1
 8c8:	00058c13          	mv	s8,a1
 8cc:	00070593          	mv	a1,a4
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:159
            for(size_t i = 0; i < 640>>l; i++){
 8d0:	80c1a483          	lw	s1,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
                    if(itersAccum > 4096){
 8d4:	00080713          	mv	a4,a6
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:162
                    paintBigPixel(i<<l, j<<l, iters, l);
 8d8:	00bc1b33          	sll	s6,s8,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:160
                if((j&1)|(i&i)){
 8dc:	001c7d93          	andi	s11,s8,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
                    if(itersAccum > 4096){
 8e0:	000c0813          	mv	a6,s8
 8e4:	009c84b3          	add	s1,s9,s1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:160
                if((j&1)|(i&i)){
 8e8:	00100a93          	li	s5,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
                    if(itersAccum > 4096){
 8ec:	00001337          	lui	t1,0x1
 8f0:	00070c13          	mv	s8,a4
 8f4:	00c0006f          	j	900 <drawMandelInterlaced+0x1f0>
 8f8:	009d04b3          	add	s1,s10,s1
 8fc:	001a8a93          	addi	s5,s5,1
 900:	fffa8e93          	addi	t4,s5,-1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:160
                if((j&1)|(i&i)){
 904:	01dde733          	or	a4,s11,t4
 908:	419484b3          	sub	s1,s1,s9
 90c:	fe0706e3          	beqz	a4,8f8 <drawMandelInterlaced+0x1e8>
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
    uint16_t iters = 0;
 910:	00000e13          	li	t3,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 914:	00000693          	li	a3,0
 918:	00000713          	li	a4,0
 91c:	00000f93          	li	t6,0
 920:	00000293          	li	t0,0
 924:	00000613          	li	a2,0
 928:	00000f13          	li	t5,0
 92c:	02ef0f33          	mul	t5,t5,a4
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
        int32_t newX = xx - yy + x0;
 930:	40d286b3          	sub	a3,t0,a3
 934:	009686b3          	add	a3,a3,s1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 938:	001e0e13          	addi	t3,t3,1
 93c:	010e1e13          	slli	t3,t3,0x10
 940:	010e5e13          	srli	t3,t3,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 944:	02cf8fb3          	mul	t6,t6,a2
 948:	02e632b3          	mulhu	t0,a2,a4
 94c:	01ff0f33          	add	t5,t5,t6
 950:	02e60733          	mul	a4,a2,a4
 954:	00068613          	mv	a2,a3
 958:	005f06b3          	add	a3,t5,t0
 95c:	00669693          	slli	a3,a3,0x6
 960:	41f65f13          	srai	t5,a2,0x1f
 964:	01a75713          	srli	a4,a4,0x1a
 968:	00e6e733          	or	a4,a3,a4
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:104
        int32_t newY = (qmul(x, y) << 1) + y0;
 96c:	00171713          	slli	a4,a4,0x1
 970:	01270733          	add	a4,a4,s2
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 974:	233e0a63          	beq	t3,s3,ba8 <drawMandelInterlaced+0x498>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 978:	02c606b3          	mul	a3,a2,a2
 97c:	41f75f93          	srai	t6,a4,0x1f
 980:	02c612b3          	mulh	t0,a2,a2
 984:	01a6d693          	srli	a3,a3,0x1a
 988:	00629293          	slli	t0,t0,0x6
 98c:	00d2e2b3          	or	t0,t0,a3
 990:	02e703b3          	mul	t2,a4,a4
 994:	02e716b3          	mulh	a3,a4,a4
 998:	01a3d393          	srli	t2,t2,0x1a
 99c:	00669693          	slli	a3,a3,0x6
 9a0:	0076e6b3          	or	a3,a3,t2
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 9a4:	00d283b3          	add	t2,t0,a3
 9a8:	f87a52e3          	bge	s4,t2,92c <drawMandelInterlaced+0x21c>
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:130
            vgaHandle->pxlData = p;
 9ac:	000e0693          	mv	a3,t3
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:162
                    paintBigPixel(i<<l, j<<l, iters, l);
 9b0:	00be9eb3          	sll	t4,t4,a1
paintBigPixel():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126
    for(uint8_t j = 0; j < 1<<pow; j++){
 9b4:	00000613          	li	a2,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:127
        vgaHandle->yAddr = y + j;
 9b8:	01660733          	add	a4,a2,s6
 9bc:	00e7a423          	sw	a4,8(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:128
        vgaHandle->xAddr = x;
 9c0:	01d7a223          	sw	t4,4(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:129
        for(uint8_t i =0; i < 1<<pow; i++){
 9c4:	00000713          	li	a4,0
 9c8:	00170713          	addi	a4,a4,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:130
            vgaHandle->pxlData = p;
 9cc:	00d7a623          	sw	a3,12(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:129
        for(uint8_t i =0; i < 1<<pow; i++){
 9d0:	0ff77713          	andi	a4,a4,255
 9d4:	fe874ae3          	blt	a4,s0,9c8 <drawMandelInterlaced+0x2b8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:126
    for(uint8_t j = 0; j < 1<<pow; j++){
 9d8:	00160613          	addi	a2,a2,1
 9dc:	0ff67613          	andi	a2,a2,255
 9e0:	fc864ce3          	blt	a2,s0,9b8 <drawMandelInterlaced+0x2a8>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:163
                    itersAccum += iters;
 9e4:	01c50533          	add	a0,a0,t3
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:164
                    if(itersAccum > 4096){
 9e8:	18a34a63          	blt	t1,a0,b7c <drawMandelInterlaced+0x46c>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:159 (discriminator 2)
            for(size_t i = 0; i < 640>>l; i++){
 9ec:	f18ae6e3          	bltu	s5,s8,8f8 <drawMandelInterlaced+0x1e8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:157 (discriminator 2)
        for(size_t j = 0; j < 480>>l; j++){
 9f0:	000c0713          	mv	a4,s8
 9f4:	00080c13          	mv	s8,a6
 9f8:	001c0c13          	addi	s8,s8,1
 9fc:	00070813          	mv	a6,a4
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:171 (discriminator 2)
            y0 += dx<<l;
 a00:	01990933          	add	s2,s2,s9
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:157 (discriminator 2)
        for(size_t j = 0; j < 480>>l; j++){
 a04:	ed1c16e3          	bne	s8,a7,8d0 <drawMandelInterlaced+0x1c0>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:155 (discriminator 2)
    for(int l = 4; l; l--){
 a08:	fff58c13          	addi	s8,a1,-1
 a0c:	e80c14e3          	bnez	s8,894 <drawMandelInterlaced+0x184>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:175
    y0 = yStart;
 a10:	00012c83          	lw	s9,0(sp)
 a14:	00003737          	lui	a4,0x3
 a18:	c9072483          	lw	s1,-880(a4) # 2c90 <yStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:176
    for(size_t j = 0; j < 480; j++){
 a1c:	00000a93          	li	s5,0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:189
                vgaHandle->xAddr = i+1;
 a20:	00100d13          	li	s10,1
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 a24:	10000937          	lui	s2,0x10000
 a28:	001c9b13          	slli	s6,s9,0x1
 a2c:	01812023          	sw	s8,0(sp)
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:177
        int32_t x0 = xStart;
 a30:	80c1a403          	lw	s0,-2036(gp) # 2c94 <xStart>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:178
        vgaHandle->yAddr = j;
 a34:	0157a423          	sw	s5,8(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:180
            if((j&1)|(i&i)){
 a38:	001afd93          	andi	s11,s5,1
 a3c:	01940433          	add	s0,s0,s9
 a40:	00100a13          	li	s4,1
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 a44:	0ff00993          	li	s3,255
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:184
                if(itersAccum > 4096){
 a48:	00001837          	lui	a6,0x1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:179
        for(size_t i = 0; i < 640; i++){
 a4c:	28000c13          	li	s8,640
 a50:	0100006f          	j	a60 <drawMandelInterlaced+0x350>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:189
                vgaHandle->xAddr = i+1;
 a54:	01a7a223          	sw	s10,4(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:179
        for(size_t i = 0; i < 640; i++){
 a58:	008b0433          	add	s0,s6,s0
 a5c:	001a0a13          	addi	s4,s4,1 # 10000001 <__stack_top+0xfff0001>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:180
            if((j&1)|(i&i)){
 a60:	fffa0713          	addi	a4,s4,-1
 a64:	01b76733          	or	a4,a4,s11
 a68:	41940433          	sub	s0,s0,s9
 a6c:	fe0704e3          	beqz	a4,a54 <drawMandelInterlaced+0x344>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 a70:	00000693          	li	a3,0
 a74:	00000e93          	li	t4,0
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:98
    uint16_t iters = 0;
 a78:	00000593          	li	a1,0
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 a7c:	00000713          	li	a4,0
 a80:	00000e13          	li	t3,0
 a84:	00000613          	li	a2,0
 a88:	00000313          	li	t1,0
 a8c:	02e30333          	mul	t1,t1,a4
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:103
        int32_t newX = xx - yy + x0;
 a90:	40de86b3          	sub	a3,t4,a3
 a94:	008686b3          	add	a3,a3,s0
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 a98:	00158593          	addi	a1,a1,1
 a9c:	01059593          	slli	a1,a1,0x10
 aa0:	0105d593          	srli	a1,a1,0x10
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 aa4:	02ce0e33          	mul	t3,t3,a2
 aa8:	02e63eb3          	mulhu	t4,a2,a4
 aac:	01c30333          	add	t1,t1,t3
 ab0:	02e60733          	mul	a4,a2,a4
 ab4:	00068613          	mv	a2,a3
 ab8:	01d306b3          	add	a3,t1,t4
 abc:	00669693          	slli	a3,a3,0x6
 ac0:	41f65313          	srai	t1,a2,0x1f
 ac4:	01a75713          	srli	a4,a4,0x1a
 ac8:	00e6e733          	or	a4,a3,a4
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:104
        int32_t newY = (qmul(x, y) << 1) + y0;
 acc:	00171713          	slli	a4,a4,0x1
 ad0:	00970733          	add	a4,a4,s1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:99
    for(; iters < maxIters; iters++){
 ad4:	11358463          	beq	a1,s3,bdc <drawMandelInterlaced+0x4cc>
qmul():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:44
    return (int32_t)(((int64_t)a * (int64_t)b) >> 26);
 ad8:	02c606b3          	mul	a3,a2,a2
 adc:	41f75e13          	srai	t3,a4,0x1f
 ae0:	02c61eb3          	mulh	t4,a2,a2
 ae4:	01a6d693          	srli	a3,a3,0x1a
 ae8:	006e9e93          	slli	t4,t4,0x6
 aec:	00deeeb3          	or	t4,t4,a3
 af0:	02e70f33          	mul	t5,a4,a4
 af4:	02e716b3          	mulh	a3,a4,a4
 af8:	01af5f13          	srli	t5,t5,0x1a
 afc:	00669693          	slli	a3,a3,0x6
 b00:	01e6e6b3          	or	a3,a3,t5
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:102
        if(xx + yy > QP_4) break;
 b04:	00de8f33          	add	t5,t4,a3
 b08:	f9e952e3          	bge	s2,t5,a8c <drawMandelInterlaced+0x37c>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:183
                vgaHandle->pxlData = iters;
 b0c:	00058713          	mv	a4,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:182
                itersAccum += iters;
 b10:	00b50533          	add	a0,a0,a1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:183
                vgaHandle->pxlData = iters;
 b14:	00e7a623          	sw	a4,12(a5)
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:184
                if(itersAccum > 4096){
 b18:	08a84e63          	blt	a6,a0,bb4 <drawMandelInterlaced+0x4a4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:179 (discriminator 2)
        for(size_t i = 0; i < 640; i++){
 b1c:	0b8a0463          	beq	s4,s8,bc4 <drawMandelInterlaced+0x4b4>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:189
                vgaHandle->xAddr = i+1;
 b20:	c8cba783          	lw	a5,-884(s7)
 b24:	f35ff06f          	j	a58 <drawMandelInterlaced+0x348>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:146
                if(processSw()) return 1;
 b28:	a41ff0ef          	jal	ra,568 <processSw>
 b2c:	d00508e3          	beqz	a0,83c <drawMandelInterlaced+0x12c>
 b30:	00100c13          	li	s8,1
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:196
}
 b34:	04c12083          	lw	ra,76(sp)
 b38:	04812403          	lw	s0,72(sp)
 b3c:	04412483          	lw	s1,68(sp)
 b40:	04012903          	lw	s2,64(sp)
 b44:	03c12983          	lw	s3,60(sp)
 b48:	03812a03          	lw	s4,56(sp)
 b4c:	03412a83          	lw	s5,52(sp)
 b50:	03012b03          	lw	s6,48(sp)
 b54:	02c12b83          	lw	s7,44(sp)
 b58:	02412c83          	lw	s9,36(sp)
 b5c:	02012d03          	lw	s10,32(sp)
 b60:	01c12d83          	lw	s11,28(sp)
 b64:	000c0513          	mv	a0,s8
 b68:	02812c03          	lw	s8,40(sp)
 b6c:	05010113          	addi	sp,sp,80
 b70:	00008067          	ret
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:196
 b74:	0ff00793          	li	a5,255
 b78:	cbdff06f          	j	834 <drawMandelInterlaced+0x124>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:165
                        if(processSw()) return 1;
 b7c:	00b12623          	sw	a1,12(sp)
 b80:	01112423          	sw	a7,8(sp)
 b84:	01012223          	sw	a6,4(sp)
 b88:	9e1ff0ef          	jal	ra,568 <processSw>
 b8c:	fa0512e3          	bnez	a0,b30 <drawMandelInterlaced+0x420>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:178
        vgaHandle->yAddr = j;
 b90:	c8cba783          	lw	a5,-884(s7)
 b94:	00c12583          	lw	a1,12(sp)
 b98:	00812883          	lw	a7,8(sp)
 b9c:	00412803          	lw	a6,4(sp)
 ba0:	00001337          	lui	t1,0x1
 ba4:	e49ff06f          	j	9ec <drawMandelInterlaced+0x2dc>
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:178
 ba8:	0ff00693          	li	a3,255
 bac:	0ff00e13          	li	t3,255
 bb0:	e01ff06f          	j	9b0 <drawMandelInterlaced+0x2a0>
drawMandelInterlaced():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:185
                    if(processSw()) return 1;
 bb4:	9b5ff0ef          	jal	ra,568 <processSw>
 bb8:	00001837          	lui	a6,0x1
 bbc:	f6051ae3          	bnez	a0,b30 <drawMandelInterlaced+0x420>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:179
        for(size_t i = 0; i < 640; i++){
 bc0:	f78a10e3          	bne	s4,s8,b20 <drawMandelInterlaced+0x410>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:176 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 bc4:	001a8a93          	addi	s5,s5,1
 bc8:	1e000793          	li	a5,480
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:193 (discriminator 2)
        y0 += dx;
 bcc:	019484b3          	add	s1,s1,s9
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:176 (discriminator 2)
    for(size_t j = 0; j < 480; j++){
 bd0:	00fa8c63          	beq	s5,a5,be8 <drawMandelInterlaced+0x4d8>
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:178
        vgaHandle->yAddr = j;
 bd4:	c8cba783          	lw	a5,-884(s7)
 bd8:	e59ff06f          	j	a30 <drawMandelInterlaced+0x320>
getIters():
/Users/jamesliu/Development/ECE496/ECE496/my-electron-app/resources/compiler/demo/mandel.c:178
 bdc:	0ff00713          	li	a4,255
 be0:	0ff00593          	li	a1,255
 be4:	f2dff06f          	j	b10 <drawMandelInterlaced+0x400>
 be8:	00012c03          	lw	s8,0(sp)
 bec:	f49ff06f          	j	b34 <drawMandelInterlaced+0x424>
