
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	6bf0a0ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0200066:	209000ef          	jal	ra,ffffffffc0200a6e <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	3b658593          	addi	a1,a1,950 # ffffffffc020b420 <etext+0x4>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	3ce50513          	addi	a0,a0,974 # ffffffffc020b440 <etext+0x24>
ffffffffc020007a:	0b0000ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020007e:	25c000ef          	jal	ra,ffffffffc02002da <print_kerninfo>
ffffffffc0200082:	4ca000ef          	jal	ra,ffffffffc020054c <dtb_init>
ffffffffc0200086:	3c9010ef          	jal	ra,ffffffffc0201c4e <pmm_init>
ffffffffc020008a:	2ff000ef          	jal	ra,ffffffffc0200b88 <pic_init>
ffffffffc020008e:	519000ef          	jal	ra,ffffffffc0200da6 <idt_init>
ffffffffc0200092:	054030ef          	jal	ra,ffffffffc02030e6 <vmm_init>
ffffffffc0200096:	7af060ef          	jal	ra,ffffffffc0207044 <sched_init>
ffffffffc020009a:	507060ef          	jal	ra,ffffffffc0206da0 <proc_init>
ffffffffc020009e:	2ed000ef          	jal	ra,ffffffffc0200b8a <ide_init>
ffffffffc02000a2:	720050ef          	jal	ra,ffffffffc02057c2 <fs_init>
ffffffffc02000a6:	17f000ef          	jal	ra,ffffffffc0200a24 <clock_init>
ffffffffc02000aa:	4f1000ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02000ae:	6bf060ef          	jal	ra,ffffffffc0206f6c <cpu_idle>

ffffffffc02000b2 <strdup>:
ffffffffc02000b2:	1101                	addi	sp,sp,-32
ffffffffc02000b4:	ec06                	sd	ra,24(sp)
ffffffffc02000b6:	e822                	sd	s0,16(sp)
ffffffffc02000b8:	e426                	sd	s1,8(sp)
ffffffffc02000ba:	e04a                	sd	s2,0(sp)
ffffffffc02000bc:	892a                	mv	s2,a0
ffffffffc02000be:	5c10a0ef          	jal	ra,ffffffffc020ae7e <strlen>
ffffffffc02000c2:	842a                	mv	s0,a0
ffffffffc02000c4:	0505                	addi	a0,a0,1
ffffffffc02000c6:	6fc030ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02000ca:	84aa                	mv	s1,a0
ffffffffc02000cc:	c901                	beqz	a0,ffffffffc02000dc <strdup+0x2a>
ffffffffc02000ce:	8622                	mv	a2,s0
ffffffffc02000d0:	85ca                	mv	a1,s2
ffffffffc02000d2:	9426                	add	s0,s0,s1
ffffffffc02000d4:	69f0a0ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc02000d8:	00040023          	sb	zero,0(s0)
ffffffffc02000dc:	60e2                	ld	ra,24(sp)
ffffffffc02000de:	6442                	ld	s0,16(sp)
ffffffffc02000e0:	6902                	ld	s2,0(sp)
ffffffffc02000e2:	8526                	mv	a0,s1
ffffffffc02000e4:	64a2                	ld	s1,8(sp)
ffffffffc02000e6:	6105                	addi	sp,sp,32
ffffffffc02000e8:	8082                	ret

ffffffffc02000ea <cputch>:
ffffffffc02000ea:	1141                	addi	sp,sp,-16
ffffffffc02000ec:	e022                	sd	s0,0(sp)
ffffffffc02000ee:	e406                	sd	ra,8(sp)
ffffffffc02000f0:	842e                	mv	s0,a1
ffffffffc02000f2:	18b000ef          	jal	ra,ffffffffc0200a7c <cons_putc>
ffffffffc02000f6:	401c                	lw	a5,0(s0)
ffffffffc02000f8:	60a2                	ld	ra,8(sp)
ffffffffc02000fa:	2785                	addiw	a5,a5,1
ffffffffc02000fc:	c01c                	sw	a5,0(s0)
ffffffffc02000fe:	6402                	ld	s0,0(sp)
ffffffffc0200100:	0141                	addi	sp,sp,16
ffffffffc0200102:	8082                	ret

ffffffffc0200104 <vcprintf>:
ffffffffc0200104:	1101                	addi	sp,sp,-32
ffffffffc0200106:	872e                	mv	a4,a1
ffffffffc0200108:	75dd                	lui	a1,0xffff7
ffffffffc020010a:	86aa                	mv	a3,a0
ffffffffc020010c:	0070                	addi	a2,sp,12
ffffffffc020010e:	00000517          	auipc	a0,0x0
ffffffffc0200112:	fdc50513          	addi	a0,a0,-36 # ffffffffc02000ea <cputch>
ffffffffc0200116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020011a:	ec06                	sd	ra,24(sp)
ffffffffc020011c:	c602                	sw	zero,12(sp)
ffffffffc020011e:	6fd0a0ef          	jal	ra,ffffffffc020b01a <vprintfmt>
ffffffffc0200122:	60e2                	ld	ra,24(sp)
ffffffffc0200124:	4532                	lw	a0,12(sp)
ffffffffc0200126:	6105                	addi	sp,sp,32
ffffffffc0200128:	8082                	ret

ffffffffc020012a <cprintf>:
ffffffffc020012a:	711d                	addi	sp,sp,-96
ffffffffc020012c:	02810313          	addi	t1,sp,40 # ffffffffc0213028 <boot_page_table_sv39+0x28>
ffffffffc0200130:	8e2a                	mv	t3,a0
ffffffffc0200132:	f42e                	sd	a1,40(sp)
ffffffffc0200134:	75dd                	lui	a1,0xffff7
ffffffffc0200136:	f832                	sd	a2,48(sp)
ffffffffc0200138:	fc36                	sd	a3,56(sp)
ffffffffc020013a:	e0ba                	sd	a4,64(sp)
ffffffffc020013c:	00000517          	auipc	a0,0x0
ffffffffc0200140:	fae50513          	addi	a0,a0,-82 # ffffffffc02000ea <cputch>
ffffffffc0200144:	0050                	addi	a2,sp,4
ffffffffc0200146:	871a                	mv	a4,t1
ffffffffc0200148:	86f2                	mv	a3,t3
ffffffffc020014a:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020014e:	ec06                	sd	ra,24(sp)
ffffffffc0200150:	e4be                	sd	a5,72(sp)
ffffffffc0200152:	e8c2                	sd	a6,80(sp)
ffffffffc0200154:	ecc6                	sd	a7,88(sp)
ffffffffc0200156:	e41a                	sd	t1,8(sp)
ffffffffc0200158:	c202                	sw	zero,4(sp)
ffffffffc020015a:	6c10a0ef          	jal	ra,ffffffffc020b01a <vprintfmt>
ffffffffc020015e:	60e2                	ld	ra,24(sp)
ffffffffc0200160:	4512                	lw	a0,4(sp)
ffffffffc0200162:	6125                	addi	sp,sp,96
ffffffffc0200164:	8082                	ret

ffffffffc0200166 <cputchar>:
ffffffffc0200166:	1170006f          	j	ffffffffc0200a7c <cons_putc>

ffffffffc020016a <getchar>:
ffffffffc020016a:	1141                	addi	sp,sp,-16
ffffffffc020016c:	e406                	sd	ra,8(sp)
ffffffffc020016e:	163000ef          	jal	ra,ffffffffc0200ad0 <cons_getc>
ffffffffc0200172:	dd75                	beqz	a0,ffffffffc020016e <getchar+0x4>
ffffffffc0200174:	60a2                	ld	ra,8(sp)
ffffffffc0200176:	0141                	addi	sp,sp,16
ffffffffc0200178:	8082                	ret

ffffffffc020017a <readline>:
ffffffffc020017a:	715d                	addi	sp,sp,-80
ffffffffc020017c:	e486                	sd	ra,72(sp)
ffffffffc020017e:	e0a6                	sd	s1,64(sp)
ffffffffc0200180:	fc4a                	sd	s2,56(sp)
ffffffffc0200182:	f84e                	sd	s3,48(sp)
ffffffffc0200184:	f452                	sd	s4,40(sp)
ffffffffc0200186:	f056                	sd	s5,32(sp)
ffffffffc0200188:	ec5a                	sd	s6,24(sp)
ffffffffc020018a:	e85e                	sd	s7,16(sp)
ffffffffc020018c:	c901                	beqz	a0,ffffffffc020019c <readline+0x22>
ffffffffc020018e:	85aa                	mv	a1,a0
ffffffffc0200190:	0000b517          	auipc	a0,0xb
ffffffffc0200194:	2b850513          	addi	a0,a0,696 # ffffffffc020b448 <etext+0x2c>
ffffffffc0200198:	f93ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020019c:	4481                	li	s1,0
ffffffffc020019e:	497d                	li	s2,31
ffffffffc02001a0:	49a1                	li	s3,8
ffffffffc02001a2:	4aa9                	li	s5,10
ffffffffc02001a4:	4b35                	li	s6,13
ffffffffc02001a6:	00091b97          	auipc	s7,0x91
ffffffffc02001aa:	ebab8b93          	addi	s7,s7,-326 # ffffffffc0291060 <buf>
ffffffffc02001ae:	3fe00a13          	li	s4,1022
ffffffffc02001b2:	fb9ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001b6:	00054a63          	bltz	a0,ffffffffc02001ca <readline+0x50>
ffffffffc02001ba:	00a95a63          	bge	s2,a0,ffffffffc02001ce <readline+0x54>
ffffffffc02001be:	029a5263          	bge	s4,s1,ffffffffc02001e2 <readline+0x68>
ffffffffc02001c2:	fa9ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001c6:	fe055ae3          	bgez	a0,ffffffffc02001ba <readline+0x40>
ffffffffc02001ca:	4501                	li	a0,0
ffffffffc02001cc:	a091                	j	ffffffffc0200210 <readline+0x96>
ffffffffc02001ce:	03351463          	bne	a0,s3,ffffffffc02001f6 <readline+0x7c>
ffffffffc02001d2:	e8a9                	bnez	s1,ffffffffc0200224 <readline+0xaa>
ffffffffc02001d4:	f97ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001d8:	fe0549e3          	bltz	a0,ffffffffc02001ca <readline+0x50>
ffffffffc02001dc:	fea959e3          	bge	s2,a0,ffffffffc02001ce <readline+0x54>
ffffffffc02001e0:	4481                	li	s1,0
ffffffffc02001e2:	e42a                	sd	a0,8(sp)
ffffffffc02001e4:	f83ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc02001e8:	6522                	ld	a0,8(sp)
ffffffffc02001ea:	009b87b3          	add	a5,s7,s1
ffffffffc02001ee:	2485                	addiw	s1,s1,1
ffffffffc02001f0:	00a78023          	sb	a0,0(a5)
ffffffffc02001f4:	bf7d                	j	ffffffffc02001b2 <readline+0x38>
ffffffffc02001f6:	01550463          	beq	a0,s5,ffffffffc02001fe <readline+0x84>
ffffffffc02001fa:	fb651ce3          	bne	a0,s6,ffffffffc02001b2 <readline+0x38>
ffffffffc02001fe:	f69ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc0200202:	00091517          	auipc	a0,0x91
ffffffffc0200206:	e5e50513          	addi	a0,a0,-418 # ffffffffc0291060 <buf>
ffffffffc020020a:	94aa                	add	s1,s1,a0
ffffffffc020020c:	00048023          	sb	zero,0(s1)
ffffffffc0200210:	60a6                	ld	ra,72(sp)
ffffffffc0200212:	6486                	ld	s1,64(sp)
ffffffffc0200214:	7962                	ld	s2,56(sp)
ffffffffc0200216:	79c2                	ld	s3,48(sp)
ffffffffc0200218:	7a22                	ld	s4,40(sp)
ffffffffc020021a:	7a82                	ld	s5,32(sp)
ffffffffc020021c:	6b62                	ld	s6,24(sp)
ffffffffc020021e:	6bc2                	ld	s7,16(sp)
ffffffffc0200220:	6161                	addi	sp,sp,80
ffffffffc0200222:	8082                	ret
ffffffffc0200224:	4521                	li	a0,8
ffffffffc0200226:	f41ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc020022a:	34fd                	addiw	s1,s1,-1
ffffffffc020022c:	b759                	j	ffffffffc02001b2 <readline+0x38>

ffffffffc020022e <__panic>:
ffffffffc020022e:	00096317          	auipc	t1,0x96
ffffffffc0200232:	63a30313          	addi	t1,t1,1594 # ffffffffc0296868 <is_panic>
ffffffffc0200236:	00033e03          	ld	t3,0(t1)
ffffffffc020023a:	715d                	addi	sp,sp,-80
ffffffffc020023c:	ec06                	sd	ra,24(sp)
ffffffffc020023e:	e822                	sd	s0,16(sp)
ffffffffc0200240:	f436                	sd	a3,40(sp)
ffffffffc0200242:	f83a                	sd	a4,48(sp)
ffffffffc0200244:	fc3e                	sd	a5,56(sp)
ffffffffc0200246:	e0c2                	sd	a6,64(sp)
ffffffffc0200248:	e4c6                	sd	a7,72(sp)
ffffffffc020024a:	020e1a63          	bnez	t3,ffffffffc020027e <__panic+0x50>
ffffffffc020024e:	4785                	li	a5,1
ffffffffc0200250:	00f33023          	sd	a5,0(t1)
ffffffffc0200254:	8432                	mv	s0,a2
ffffffffc0200256:	103c                	addi	a5,sp,40
ffffffffc0200258:	862e                	mv	a2,a1
ffffffffc020025a:	85aa                	mv	a1,a0
ffffffffc020025c:	0000b517          	auipc	a0,0xb
ffffffffc0200260:	1f450513          	addi	a0,a0,500 # ffffffffc020b450 <etext+0x34>
ffffffffc0200264:	e43e                	sd	a5,8(sp)
ffffffffc0200266:	ec5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020026a:	65a2                	ld	a1,8(sp)
ffffffffc020026c:	8522                	mv	a0,s0
ffffffffc020026e:	e97ff0ef          	jal	ra,ffffffffc0200104 <vcprintf>
ffffffffc0200272:	0000c517          	auipc	a0,0xc
ffffffffc0200276:	2ce50513          	addi	a0,a0,718 # ffffffffc020c540 <commands+0xe78>
ffffffffc020027a:	eb1ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020027e:	4501                	li	a0,0
ffffffffc0200280:	4581                	li	a1,0
ffffffffc0200282:	4601                	li	a2,0
ffffffffc0200284:	48a1                	li	a7,8
ffffffffc0200286:	00000073          	ecall
ffffffffc020028a:	317000ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020028e:	4501                	li	a0,0
ffffffffc0200290:	174000ef          	jal	ra,ffffffffc0200404 <kmonitor>
ffffffffc0200294:	bfed                	j	ffffffffc020028e <__panic+0x60>

ffffffffc0200296 <__warn>:
ffffffffc0200296:	715d                	addi	sp,sp,-80
ffffffffc0200298:	832e                	mv	t1,a1
ffffffffc020029a:	e822                	sd	s0,16(sp)
ffffffffc020029c:	85aa                	mv	a1,a0
ffffffffc020029e:	8432                	mv	s0,a2
ffffffffc02002a0:	fc3e                	sd	a5,56(sp)
ffffffffc02002a2:	861a                	mv	a2,t1
ffffffffc02002a4:	103c                	addi	a5,sp,40
ffffffffc02002a6:	0000b517          	auipc	a0,0xb
ffffffffc02002aa:	1ca50513          	addi	a0,a0,458 # ffffffffc020b470 <etext+0x54>
ffffffffc02002ae:	ec06                	sd	ra,24(sp)
ffffffffc02002b0:	f436                	sd	a3,40(sp)
ffffffffc02002b2:	f83a                	sd	a4,48(sp)
ffffffffc02002b4:	e0c2                	sd	a6,64(sp)
ffffffffc02002b6:	e4c6                	sd	a7,72(sp)
ffffffffc02002b8:	e43e                	sd	a5,8(sp)
ffffffffc02002ba:	e71ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002be:	65a2                	ld	a1,8(sp)
ffffffffc02002c0:	8522                	mv	a0,s0
ffffffffc02002c2:	e43ff0ef          	jal	ra,ffffffffc0200104 <vcprintf>
ffffffffc02002c6:	0000c517          	auipc	a0,0xc
ffffffffc02002ca:	27a50513          	addi	a0,a0,634 # ffffffffc020c540 <commands+0xe78>
ffffffffc02002ce:	e5dff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002d2:	60e2                	ld	ra,24(sp)
ffffffffc02002d4:	6442                	ld	s0,16(sp)
ffffffffc02002d6:	6161                	addi	sp,sp,80
ffffffffc02002d8:	8082                	ret

ffffffffc02002da <print_kerninfo>:
ffffffffc02002da:	1141                	addi	sp,sp,-16
ffffffffc02002dc:	0000b517          	auipc	a0,0xb
ffffffffc02002e0:	1b450513          	addi	a0,a0,436 # ffffffffc020b490 <etext+0x74>
ffffffffc02002e4:	e406                	sd	ra,8(sp)
ffffffffc02002e6:	e45ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002ea:	00000597          	auipc	a1,0x0
ffffffffc02002ee:	d6058593          	addi	a1,a1,-672 # ffffffffc020004a <kern_init>
ffffffffc02002f2:	0000b517          	auipc	a0,0xb
ffffffffc02002f6:	1be50513          	addi	a0,a0,446 # ffffffffc020b4b0 <etext+0x94>
ffffffffc02002fa:	e31ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002fe:	0000b597          	auipc	a1,0xb
ffffffffc0200302:	11e58593          	addi	a1,a1,286 # ffffffffc020b41c <etext>
ffffffffc0200306:	0000b517          	auipc	a0,0xb
ffffffffc020030a:	1ca50513          	addi	a0,a0,458 # ffffffffc020b4d0 <etext+0xb4>
ffffffffc020030e:	e1dff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200312:	00091597          	auipc	a1,0x91
ffffffffc0200316:	d4e58593          	addi	a1,a1,-690 # ffffffffc0291060 <buf>
ffffffffc020031a:	0000b517          	auipc	a0,0xb
ffffffffc020031e:	1d650513          	addi	a0,a0,470 # ffffffffc020b4f0 <etext+0xd4>
ffffffffc0200322:	e09ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200326:	00096597          	auipc	a1,0x96
ffffffffc020032a:	5ea58593          	addi	a1,a1,1514 # ffffffffc0296910 <end>
ffffffffc020032e:	0000b517          	auipc	a0,0xb
ffffffffc0200332:	1e250513          	addi	a0,a0,482 # ffffffffc020b510 <etext+0xf4>
ffffffffc0200336:	df5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020033a:	00097597          	auipc	a1,0x97
ffffffffc020033e:	9d558593          	addi	a1,a1,-1579 # ffffffffc0296d0f <end+0x3ff>
ffffffffc0200342:	00000797          	auipc	a5,0x0
ffffffffc0200346:	d0878793          	addi	a5,a5,-760 # ffffffffc020004a <kern_init>
ffffffffc020034a:	40f587b3          	sub	a5,a1,a5
ffffffffc020034e:	43f7d593          	srai	a1,a5,0x3f
ffffffffc0200352:	60a2                	ld	ra,8(sp)
ffffffffc0200354:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200358:	95be                	add	a1,a1,a5
ffffffffc020035a:	85a9                	srai	a1,a1,0xa
ffffffffc020035c:	0000b517          	auipc	a0,0xb
ffffffffc0200360:	1d450513          	addi	a0,a0,468 # ffffffffc020b530 <etext+0x114>
ffffffffc0200364:	0141                	addi	sp,sp,16
ffffffffc0200366:	b3d1                	j	ffffffffc020012a <cprintf>

ffffffffc0200368 <print_stackframe>:
ffffffffc0200368:	1141                	addi	sp,sp,-16
ffffffffc020036a:	0000b617          	auipc	a2,0xb
ffffffffc020036e:	1f660613          	addi	a2,a2,502 # ffffffffc020b560 <etext+0x144>
ffffffffc0200372:	04e00593          	li	a1,78
ffffffffc0200376:	0000b517          	auipc	a0,0xb
ffffffffc020037a:	20250513          	addi	a0,a0,514 # ffffffffc020b578 <etext+0x15c>
ffffffffc020037e:	e406                	sd	ra,8(sp)
ffffffffc0200380:	eafff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200384 <mon_help>:
ffffffffc0200384:	1141                	addi	sp,sp,-16
ffffffffc0200386:	0000b617          	auipc	a2,0xb
ffffffffc020038a:	20a60613          	addi	a2,a2,522 # ffffffffc020b590 <etext+0x174>
ffffffffc020038e:	0000b597          	auipc	a1,0xb
ffffffffc0200392:	22258593          	addi	a1,a1,546 # ffffffffc020b5b0 <etext+0x194>
ffffffffc0200396:	0000b517          	auipc	a0,0xb
ffffffffc020039a:	22250513          	addi	a0,a0,546 # ffffffffc020b5b8 <etext+0x19c>
ffffffffc020039e:	e406                	sd	ra,8(sp)
ffffffffc02003a0:	d8bff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003a4:	0000b617          	auipc	a2,0xb
ffffffffc02003a8:	22460613          	addi	a2,a2,548 # ffffffffc020b5c8 <etext+0x1ac>
ffffffffc02003ac:	0000b597          	auipc	a1,0xb
ffffffffc02003b0:	24458593          	addi	a1,a1,580 # ffffffffc020b5f0 <etext+0x1d4>
ffffffffc02003b4:	0000b517          	auipc	a0,0xb
ffffffffc02003b8:	20450513          	addi	a0,a0,516 # ffffffffc020b5b8 <etext+0x19c>
ffffffffc02003bc:	d6fff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003c0:	0000b617          	auipc	a2,0xb
ffffffffc02003c4:	24060613          	addi	a2,a2,576 # ffffffffc020b600 <etext+0x1e4>
ffffffffc02003c8:	0000b597          	auipc	a1,0xb
ffffffffc02003cc:	25858593          	addi	a1,a1,600 # ffffffffc020b620 <etext+0x204>
ffffffffc02003d0:	0000b517          	auipc	a0,0xb
ffffffffc02003d4:	1e850513          	addi	a0,a0,488 # ffffffffc020b5b8 <etext+0x19c>
ffffffffc02003d8:	d53ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003dc:	60a2                	ld	ra,8(sp)
ffffffffc02003de:	4501                	li	a0,0
ffffffffc02003e0:	0141                	addi	sp,sp,16
ffffffffc02003e2:	8082                	ret

ffffffffc02003e4 <mon_kerninfo>:
ffffffffc02003e4:	1141                	addi	sp,sp,-16
ffffffffc02003e6:	e406                	sd	ra,8(sp)
ffffffffc02003e8:	ef3ff0ef          	jal	ra,ffffffffc02002da <print_kerninfo>
ffffffffc02003ec:	60a2                	ld	ra,8(sp)
ffffffffc02003ee:	4501                	li	a0,0
ffffffffc02003f0:	0141                	addi	sp,sp,16
ffffffffc02003f2:	8082                	ret

ffffffffc02003f4 <mon_backtrace>:
ffffffffc02003f4:	1141                	addi	sp,sp,-16
ffffffffc02003f6:	e406                	sd	ra,8(sp)
ffffffffc02003f8:	f71ff0ef          	jal	ra,ffffffffc0200368 <print_stackframe>
ffffffffc02003fc:	60a2                	ld	ra,8(sp)
ffffffffc02003fe:	4501                	li	a0,0
ffffffffc0200400:	0141                	addi	sp,sp,16
ffffffffc0200402:	8082                	ret

ffffffffc0200404 <kmonitor>:
ffffffffc0200404:	7115                	addi	sp,sp,-224
ffffffffc0200406:	ed5e                	sd	s7,152(sp)
ffffffffc0200408:	8baa                	mv	s7,a0
ffffffffc020040a:	0000b517          	auipc	a0,0xb
ffffffffc020040e:	22650513          	addi	a0,a0,550 # ffffffffc020b630 <etext+0x214>
ffffffffc0200412:	ed86                	sd	ra,216(sp)
ffffffffc0200414:	e9a2                	sd	s0,208(sp)
ffffffffc0200416:	e5a6                	sd	s1,200(sp)
ffffffffc0200418:	e1ca                	sd	s2,192(sp)
ffffffffc020041a:	fd4e                	sd	s3,184(sp)
ffffffffc020041c:	f952                	sd	s4,176(sp)
ffffffffc020041e:	f556                	sd	s5,168(sp)
ffffffffc0200420:	f15a                	sd	s6,160(sp)
ffffffffc0200422:	e962                	sd	s8,144(sp)
ffffffffc0200424:	e566                	sd	s9,136(sp)
ffffffffc0200426:	e16a                	sd	s10,128(sp)
ffffffffc0200428:	d03ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020042c:	0000b517          	auipc	a0,0xb
ffffffffc0200430:	22c50513          	addi	a0,a0,556 # ffffffffc020b658 <etext+0x23c>
ffffffffc0200434:	cf7ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200438:	000b8563          	beqz	s7,ffffffffc0200442 <kmonitor+0x3e>
ffffffffc020043c:	855e                	mv	a0,s7
ffffffffc020043e:	351000ef          	jal	ra,ffffffffc0200f8e <print_trapframe>
ffffffffc0200442:	0000bc17          	auipc	s8,0xb
ffffffffc0200446:	286c0c13          	addi	s8,s8,646 # ffffffffc020b6c8 <commands>
ffffffffc020044a:	0000b917          	auipc	s2,0xb
ffffffffc020044e:	23690913          	addi	s2,s2,566 # ffffffffc020b680 <etext+0x264>
ffffffffc0200452:	0000b497          	auipc	s1,0xb
ffffffffc0200456:	23648493          	addi	s1,s1,566 # ffffffffc020b688 <etext+0x26c>
ffffffffc020045a:	49bd                	li	s3,15
ffffffffc020045c:	0000bb17          	auipc	s6,0xb
ffffffffc0200460:	234b0b13          	addi	s6,s6,564 # ffffffffc020b690 <etext+0x274>
ffffffffc0200464:	0000ba17          	auipc	s4,0xb
ffffffffc0200468:	14ca0a13          	addi	s4,s4,332 # ffffffffc020b5b0 <etext+0x194>
ffffffffc020046c:	4a8d                	li	s5,3
ffffffffc020046e:	854a                	mv	a0,s2
ffffffffc0200470:	d0bff0ef          	jal	ra,ffffffffc020017a <readline>
ffffffffc0200474:	842a                	mv	s0,a0
ffffffffc0200476:	dd65                	beqz	a0,ffffffffc020046e <kmonitor+0x6a>
ffffffffc0200478:	00054583          	lbu	a1,0(a0)
ffffffffc020047c:	4c81                	li	s9,0
ffffffffc020047e:	e1bd                	bnez	a1,ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc0200480:	fe0c87e3          	beqz	s9,ffffffffc020046e <kmonitor+0x6a>
ffffffffc0200484:	6582                	ld	a1,0(sp)
ffffffffc0200486:	0000bd17          	auipc	s10,0xb
ffffffffc020048a:	242d0d13          	addi	s10,s10,578 # ffffffffc020b6c8 <commands>
ffffffffc020048e:	8552                	mv	a0,s4
ffffffffc0200490:	4401                	li	s0,0
ffffffffc0200492:	0d61                	addi	s10,s10,24
ffffffffc0200494:	2330a0ef          	jal	ra,ffffffffc020aec6 <strcmp>
ffffffffc0200498:	c919                	beqz	a0,ffffffffc02004ae <kmonitor+0xaa>
ffffffffc020049a:	2405                	addiw	s0,s0,1
ffffffffc020049c:	0b540063          	beq	s0,s5,ffffffffc020053c <kmonitor+0x138>
ffffffffc02004a0:	000d3503          	ld	a0,0(s10)
ffffffffc02004a4:	6582                	ld	a1,0(sp)
ffffffffc02004a6:	0d61                	addi	s10,s10,24
ffffffffc02004a8:	21f0a0ef          	jal	ra,ffffffffc020aec6 <strcmp>
ffffffffc02004ac:	f57d                	bnez	a0,ffffffffc020049a <kmonitor+0x96>
ffffffffc02004ae:	00141793          	slli	a5,s0,0x1
ffffffffc02004b2:	97a2                	add	a5,a5,s0
ffffffffc02004b4:	078e                	slli	a5,a5,0x3
ffffffffc02004b6:	97e2                	add	a5,a5,s8
ffffffffc02004b8:	6b9c                	ld	a5,16(a5)
ffffffffc02004ba:	865e                	mv	a2,s7
ffffffffc02004bc:	002c                	addi	a1,sp,8
ffffffffc02004be:	fffc851b          	addiw	a0,s9,-1
ffffffffc02004c2:	9782                	jalr	a5
ffffffffc02004c4:	fa0555e3          	bgez	a0,ffffffffc020046e <kmonitor+0x6a>
ffffffffc02004c8:	60ee                	ld	ra,216(sp)
ffffffffc02004ca:	644e                	ld	s0,208(sp)
ffffffffc02004cc:	64ae                	ld	s1,200(sp)
ffffffffc02004ce:	690e                	ld	s2,192(sp)
ffffffffc02004d0:	79ea                	ld	s3,184(sp)
ffffffffc02004d2:	7a4a                	ld	s4,176(sp)
ffffffffc02004d4:	7aaa                	ld	s5,168(sp)
ffffffffc02004d6:	7b0a                	ld	s6,160(sp)
ffffffffc02004d8:	6bea                	ld	s7,152(sp)
ffffffffc02004da:	6c4a                	ld	s8,144(sp)
ffffffffc02004dc:	6caa                	ld	s9,136(sp)
ffffffffc02004de:	6d0a                	ld	s10,128(sp)
ffffffffc02004e0:	612d                	addi	sp,sp,224
ffffffffc02004e2:	8082                	ret
ffffffffc02004e4:	8526                	mv	a0,s1
ffffffffc02004e6:	2250a0ef          	jal	ra,ffffffffc020af0a <strchr>
ffffffffc02004ea:	c901                	beqz	a0,ffffffffc02004fa <kmonitor+0xf6>
ffffffffc02004ec:	00144583          	lbu	a1,1(s0)
ffffffffc02004f0:	00040023          	sb	zero,0(s0)
ffffffffc02004f4:	0405                	addi	s0,s0,1
ffffffffc02004f6:	d5c9                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc02004f8:	b7f5                	j	ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc02004fa:	00044783          	lbu	a5,0(s0)
ffffffffc02004fe:	d3c9                	beqz	a5,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200500:	033c8963          	beq	s9,s3,ffffffffc0200532 <kmonitor+0x12e>
ffffffffc0200504:	003c9793          	slli	a5,s9,0x3
ffffffffc0200508:	0118                	addi	a4,sp,128
ffffffffc020050a:	97ba                	add	a5,a5,a4
ffffffffc020050c:	f887b023          	sd	s0,-128(a5)
ffffffffc0200510:	00044583          	lbu	a1,0(s0)
ffffffffc0200514:	2c85                	addiw	s9,s9,1
ffffffffc0200516:	e591                	bnez	a1,ffffffffc0200522 <kmonitor+0x11e>
ffffffffc0200518:	b7b5                	j	ffffffffc0200484 <kmonitor+0x80>
ffffffffc020051a:	00144583          	lbu	a1,1(s0)
ffffffffc020051e:	0405                	addi	s0,s0,1
ffffffffc0200520:	d1a5                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200522:	8526                	mv	a0,s1
ffffffffc0200524:	1e70a0ef          	jal	ra,ffffffffc020af0a <strchr>
ffffffffc0200528:	d96d                	beqz	a0,ffffffffc020051a <kmonitor+0x116>
ffffffffc020052a:	00044583          	lbu	a1,0(s0)
ffffffffc020052e:	d9a9                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200530:	bf55                	j	ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc0200532:	45c1                	li	a1,16
ffffffffc0200534:	855a                	mv	a0,s6
ffffffffc0200536:	bf5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020053a:	b7e9                	j	ffffffffc0200504 <kmonitor+0x100>
ffffffffc020053c:	6582                	ld	a1,0(sp)
ffffffffc020053e:	0000b517          	auipc	a0,0xb
ffffffffc0200542:	17250513          	addi	a0,a0,370 # ffffffffc020b6b0 <etext+0x294>
ffffffffc0200546:	be5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020054a:	b715                	j	ffffffffc020046e <kmonitor+0x6a>

ffffffffc020054c <dtb_init>:
ffffffffc020054c:	7119                	addi	sp,sp,-128
ffffffffc020054e:	0000b517          	auipc	a0,0xb
ffffffffc0200552:	1c250513          	addi	a0,a0,450 # ffffffffc020b710 <commands+0x48>
ffffffffc0200556:	fc86                	sd	ra,120(sp)
ffffffffc0200558:	f8a2                	sd	s0,112(sp)
ffffffffc020055a:	e8d2                	sd	s4,80(sp)
ffffffffc020055c:	f4a6                	sd	s1,104(sp)
ffffffffc020055e:	f0ca                	sd	s2,96(sp)
ffffffffc0200560:	ecce                	sd	s3,88(sp)
ffffffffc0200562:	e4d6                	sd	s5,72(sp)
ffffffffc0200564:	e0da                	sd	s6,64(sp)
ffffffffc0200566:	fc5e                	sd	s7,56(sp)
ffffffffc0200568:	f862                	sd	s8,48(sp)
ffffffffc020056a:	f466                	sd	s9,40(sp)
ffffffffc020056c:	f06a                	sd	s10,32(sp)
ffffffffc020056e:	ec6e                	sd	s11,24(sp)
ffffffffc0200570:	bbbff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200574:	00014597          	auipc	a1,0x14
ffffffffc0200578:	a8c5b583          	ld	a1,-1396(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc020057c:	0000b517          	auipc	a0,0xb
ffffffffc0200580:	1a450513          	addi	a0,a0,420 # ffffffffc020b720 <commands+0x58>
ffffffffc0200584:	ba7ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200588:	00014417          	auipc	s0,0x14
ffffffffc020058c:	a8040413          	addi	s0,s0,-1408 # ffffffffc0214008 <boot_dtb>
ffffffffc0200590:	600c                	ld	a1,0(s0)
ffffffffc0200592:	0000b517          	auipc	a0,0xb
ffffffffc0200596:	19e50513          	addi	a0,a0,414 # ffffffffc020b730 <commands+0x68>
ffffffffc020059a:	b91ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020059e:	00043a03          	ld	s4,0(s0)
ffffffffc02005a2:	0000b517          	auipc	a0,0xb
ffffffffc02005a6:	1a650513          	addi	a0,a0,422 # ffffffffc020b748 <commands+0x80>
ffffffffc02005aa:	120a0463          	beqz	s4,ffffffffc02006d2 <dtb_init+0x186>
ffffffffc02005ae:	57f5                	li	a5,-3
ffffffffc02005b0:	07fa                	slli	a5,a5,0x1e
ffffffffc02005b2:	00fa0733          	add	a4,s4,a5
ffffffffc02005b6:	431c                	lw	a5,0(a4)
ffffffffc02005b8:	00ff0637          	lui	a2,0xff0
ffffffffc02005bc:	6b41                	lui	s6,0x10
ffffffffc02005be:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005c2:	0187969b          	slliw	a3,a5,0x18
ffffffffc02005c6:	0187d51b          	srliw	a0,a5,0x18
ffffffffc02005ca:	0105959b          	slliw	a1,a1,0x10
ffffffffc02005ce:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02005d2:	8df1                	and	a1,a1,a2
ffffffffc02005d4:	8ec9                	or	a3,a3,a0
ffffffffc02005d6:	0087979b          	slliw	a5,a5,0x8
ffffffffc02005da:	1b7d                	addi	s6,s6,-1
ffffffffc02005dc:	0167f7b3          	and	a5,a5,s6
ffffffffc02005e0:	8dd5                	or	a1,a1,a3
ffffffffc02005e2:	8ddd                	or	a1,a1,a5
ffffffffc02005e4:	d00e07b7          	lui	a5,0xd00e0
ffffffffc02005e8:	2581                	sext.w	a1,a1
ffffffffc02005ea:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc02005ee:	10f59163          	bne	a1,a5,ffffffffc02006f0 <dtb_init+0x1a4>
ffffffffc02005f2:	471c                	lw	a5,8(a4)
ffffffffc02005f4:	4754                	lw	a3,12(a4)
ffffffffc02005f6:	4c81                	li	s9,0
ffffffffc02005f8:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005fc:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200600:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200604:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200608:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020060c:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200610:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200614:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200618:	0105959b          	slliw	a1,a1,0x10
ffffffffc020061c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200620:	8d71                	and	a0,a0,a2
ffffffffc0200622:	01146433          	or	s0,s0,a7
ffffffffc0200626:	0086969b          	slliw	a3,a3,0x8
ffffffffc020062a:	010a6a33          	or	s4,s4,a6
ffffffffc020062e:	8e6d                	and	a2,a2,a1
ffffffffc0200630:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200634:	8c49                	or	s0,s0,a0
ffffffffc0200636:	0166f6b3          	and	a3,a3,s6
ffffffffc020063a:	00ca6a33          	or	s4,s4,a2
ffffffffc020063e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200642:	8c55                	or	s0,s0,a3
ffffffffc0200644:	00fa6a33          	or	s4,s4,a5
ffffffffc0200648:	1402                	slli	s0,s0,0x20
ffffffffc020064a:	1a02                	slli	s4,s4,0x20
ffffffffc020064c:	9001                	srli	s0,s0,0x20
ffffffffc020064e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0200652:	943a                	add	s0,s0,a4
ffffffffc0200654:	9a3a                	add	s4,s4,a4
ffffffffc0200656:	00ff0c37          	lui	s8,0xff0
ffffffffc020065a:	4b8d                	li	s7,3
ffffffffc020065c:	0000b917          	auipc	s2,0xb
ffffffffc0200660:	13c90913          	addi	s2,s2,316 # ffffffffc020b798 <commands+0xd0>
ffffffffc0200664:	49bd                	li	s3,15
ffffffffc0200666:	4d91                	li	s11,4
ffffffffc0200668:	4d05                	li	s10,1
ffffffffc020066a:	0000b497          	auipc	s1,0xb
ffffffffc020066e:	12648493          	addi	s1,s1,294 # ffffffffc020b790 <commands+0xc8>
ffffffffc0200672:	000a2703          	lw	a4,0(s4)
ffffffffc0200676:	004a0a93          	addi	s5,s4,4
ffffffffc020067a:	0087569b          	srliw	a3,a4,0x8
ffffffffc020067e:	0187179b          	slliw	a5,a4,0x18
ffffffffc0200682:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200686:	0106969b          	slliw	a3,a3,0x10
ffffffffc020068a:	0107571b          	srliw	a4,a4,0x10
ffffffffc020068e:	8fd1                	or	a5,a5,a2
ffffffffc0200690:	0186f6b3          	and	a3,a3,s8
ffffffffc0200694:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200698:	8fd5                	or	a5,a5,a3
ffffffffc020069a:	00eb7733          	and	a4,s6,a4
ffffffffc020069e:	8fd9                	or	a5,a5,a4
ffffffffc02006a0:	2781                	sext.w	a5,a5
ffffffffc02006a2:	09778c63          	beq	a5,s7,ffffffffc020073a <dtb_init+0x1ee>
ffffffffc02006a6:	00fbea63          	bltu	s7,a5,ffffffffc02006ba <dtb_init+0x16e>
ffffffffc02006aa:	07a78663          	beq	a5,s10,ffffffffc0200716 <dtb_init+0x1ca>
ffffffffc02006ae:	4709                	li	a4,2
ffffffffc02006b0:	00e79763          	bne	a5,a4,ffffffffc02006be <dtb_init+0x172>
ffffffffc02006b4:	4c81                	li	s9,0
ffffffffc02006b6:	8a56                	mv	s4,s5
ffffffffc02006b8:	bf6d                	j	ffffffffc0200672 <dtb_init+0x126>
ffffffffc02006ba:	ffb78ee3          	beq	a5,s11,ffffffffc02006b6 <dtb_init+0x16a>
ffffffffc02006be:	0000b517          	auipc	a0,0xb
ffffffffc02006c2:	15250513          	addi	a0,a0,338 # ffffffffc020b810 <commands+0x148>
ffffffffc02006c6:	a65ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02006ca:	0000b517          	auipc	a0,0xb
ffffffffc02006ce:	17e50513          	addi	a0,a0,382 # ffffffffc020b848 <commands+0x180>
ffffffffc02006d2:	7446                	ld	s0,112(sp)
ffffffffc02006d4:	70e6                	ld	ra,120(sp)
ffffffffc02006d6:	74a6                	ld	s1,104(sp)
ffffffffc02006d8:	7906                	ld	s2,96(sp)
ffffffffc02006da:	69e6                	ld	s3,88(sp)
ffffffffc02006dc:	6a46                	ld	s4,80(sp)
ffffffffc02006de:	6aa6                	ld	s5,72(sp)
ffffffffc02006e0:	6b06                	ld	s6,64(sp)
ffffffffc02006e2:	7be2                	ld	s7,56(sp)
ffffffffc02006e4:	7c42                	ld	s8,48(sp)
ffffffffc02006e6:	7ca2                	ld	s9,40(sp)
ffffffffc02006e8:	7d02                	ld	s10,32(sp)
ffffffffc02006ea:	6de2                	ld	s11,24(sp)
ffffffffc02006ec:	6109                	addi	sp,sp,128
ffffffffc02006ee:	bc35                	j	ffffffffc020012a <cprintf>
ffffffffc02006f0:	7446                	ld	s0,112(sp)
ffffffffc02006f2:	70e6                	ld	ra,120(sp)
ffffffffc02006f4:	74a6                	ld	s1,104(sp)
ffffffffc02006f6:	7906                	ld	s2,96(sp)
ffffffffc02006f8:	69e6                	ld	s3,88(sp)
ffffffffc02006fa:	6a46                	ld	s4,80(sp)
ffffffffc02006fc:	6aa6                	ld	s5,72(sp)
ffffffffc02006fe:	6b06                	ld	s6,64(sp)
ffffffffc0200700:	7be2                	ld	s7,56(sp)
ffffffffc0200702:	7c42                	ld	s8,48(sp)
ffffffffc0200704:	7ca2                	ld	s9,40(sp)
ffffffffc0200706:	7d02                	ld	s10,32(sp)
ffffffffc0200708:	6de2                	ld	s11,24(sp)
ffffffffc020070a:	0000b517          	auipc	a0,0xb
ffffffffc020070e:	05e50513          	addi	a0,a0,94 # ffffffffc020b768 <commands+0xa0>
ffffffffc0200712:	6109                	addi	sp,sp,128
ffffffffc0200714:	bc19                	j	ffffffffc020012a <cprintf>
ffffffffc0200716:	8556                	mv	a0,s5
ffffffffc0200718:	7660a0ef          	jal	ra,ffffffffc020ae7e <strlen>
ffffffffc020071c:	8a2a                	mv	s4,a0
ffffffffc020071e:	4619                	li	a2,6
ffffffffc0200720:	85a6                	mv	a1,s1
ffffffffc0200722:	8556                	mv	a0,s5
ffffffffc0200724:	2a01                	sext.w	s4,s4
ffffffffc0200726:	7be0a0ef          	jal	ra,ffffffffc020aee4 <strncmp>
ffffffffc020072a:	e111                	bnez	a0,ffffffffc020072e <dtb_init+0x1e2>
ffffffffc020072c:	4c85                	li	s9,1
ffffffffc020072e:	0a91                	addi	s5,s5,4
ffffffffc0200730:	9ad2                	add	s5,s5,s4
ffffffffc0200732:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200736:	8a56                	mv	s4,s5
ffffffffc0200738:	bf2d                	j	ffffffffc0200672 <dtb_init+0x126>
ffffffffc020073a:	004a2783          	lw	a5,4(s4)
ffffffffc020073e:	00ca0693          	addi	a3,s4,12
ffffffffc0200742:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200746:	01879a9b          	slliw	s5,a5,0x18
ffffffffc020074a:	0187d61b          	srliw	a2,a5,0x18
ffffffffc020074e:	0107171b          	slliw	a4,a4,0x10
ffffffffc0200752:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200756:	00caeab3          	or	s5,s5,a2
ffffffffc020075a:	01877733          	and	a4,a4,s8
ffffffffc020075e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200762:	00eaeab3          	or	s5,s5,a4
ffffffffc0200766:	00fb77b3          	and	a5,s6,a5
ffffffffc020076a:	00faeab3          	or	s5,s5,a5
ffffffffc020076e:	2a81                	sext.w	s5,s5
ffffffffc0200770:	000c9c63          	bnez	s9,ffffffffc0200788 <dtb_init+0x23c>
ffffffffc0200774:	1a82                	slli	s5,s5,0x20
ffffffffc0200776:	00368793          	addi	a5,a3,3
ffffffffc020077a:	020ada93          	srli	s5,s5,0x20
ffffffffc020077e:	9abe                	add	s5,s5,a5
ffffffffc0200780:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200784:	8a56                	mv	s4,s5
ffffffffc0200786:	b5f5                	j	ffffffffc0200672 <dtb_init+0x126>
ffffffffc0200788:	008a2783          	lw	a5,8(s4)
ffffffffc020078c:	85ca                	mv	a1,s2
ffffffffc020078e:	e436                	sd	a3,8(sp)
ffffffffc0200790:	0087d51b          	srliw	a0,a5,0x8
ffffffffc0200794:	0187d61b          	srliw	a2,a5,0x18
ffffffffc0200798:	0187971b          	slliw	a4,a5,0x18
ffffffffc020079c:	0105151b          	slliw	a0,a0,0x10
ffffffffc02007a0:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02007a4:	8f51                	or	a4,a4,a2
ffffffffc02007a6:	01857533          	and	a0,a0,s8
ffffffffc02007aa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007ae:	8d59                	or	a0,a0,a4
ffffffffc02007b0:	00fb77b3          	and	a5,s6,a5
ffffffffc02007b4:	8d5d                	or	a0,a0,a5
ffffffffc02007b6:	1502                	slli	a0,a0,0x20
ffffffffc02007b8:	9101                	srli	a0,a0,0x20
ffffffffc02007ba:	9522                	add	a0,a0,s0
ffffffffc02007bc:	70a0a0ef          	jal	ra,ffffffffc020aec6 <strcmp>
ffffffffc02007c0:	66a2                	ld	a3,8(sp)
ffffffffc02007c2:	f94d                	bnez	a0,ffffffffc0200774 <dtb_init+0x228>
ffffffffc02007c4:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200774 <dtb_init+0x228>
ffffffffc02007c8:	00ca3783          	ld	a5,12(s4)
ffffffffc02007cc:	014a3703          	ld	a4,20(s4)
ffffffffc02007d0:	0000b517          	auipc	a0,0xb
ffffffffc02007d4:	fd050513          	addi	a0,a0,-48 # ffffffffc020b7a0 <commands+0xd8>
ffffffffc02007d8:	4207d613          	srai	a2,a5,0x20
ffffffffc02007dc:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02007e0:	42075593          	srai	a1,a4,0x20
ffffffffc02007e4:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02007e8:	0186581b          	srliw	a6,a2,0x18
ffffffffc02007ec:	0187941b          	slliw	s0,a5,0x18
ffffffffc02007f0:	0107d89b          	srliw	a7,a5,0x10
ffffffffc02007f4:	0187d693          	srli	a3,a5,0x18
ffffffffc02007f8:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02007fc:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200800:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200804:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200808:	010f6f33          	or	t5,t5,a6
ffffffffc020080c:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200810:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200814:	01837333          	and	t1,t1,s8
ffffffffc0200818:	01c46433          	or	s0,s0,t3
ffffffffc020081c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200820:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200824:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200828:	0107581b          	srliw	a6,a4,0x10
ffffffffc020082c:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200830:	8361                	srli	a4,a4,0x18
ffffffffc0200832:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200836:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020083a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020083e:	00cb7633          	and	a2,s6,a2
ffffffffc0200842:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200846:	0085959b          	slliw	a1,a1,0x8
ffffffffc020084a:	00646433          	or	s0,s0,t1
ffffffffc020084e:	0187f7b3          	and	a5,a5,s8
ffffffffc0200852:	01fe6333          	or	t1,t3,t6
ffffffffc0200856:	01877c33          	and	s8,a4,s8
ffffffffc020085a:	0088989b          	slliw	a7,a7,0x8
ffffffffc020085e:	011b78b3          	and	a7,s6,a7
ffffffffc0200862:	005eeeb3          	or	t4,t4,t0
ffffffffc0200866:	00c6e733          	or	a4,a3,a2
ffffffffc020086a:	006c6c33          	or	s8,s8,t1
ffffffffc020086e:	010b76b3          	and	a3,s6,a6
ffffffffc0200872:	00bb7b33          	and	s6,s6,a1
ffffffffc0200876:	01d7e7b3          	or	a5,a5,t4
ffffffffc020087a:	016c6b33          	or	s6,s8,s6
ffffffffc020087e:	01146433          	or	s0,s0,a7
ffffffffc0200882:	8fd5                	or	a5,a5,a3
ffffffffc0200884:	1702                	slli	a4,a4,0x20
ffffffffc0200886:	1b02                	slli	s6,s6,0x20
ffffffffc0200888:	1782                	slli	a5,a5,0x20
ffffffffc020088a:	9301                	srli	a4,a4,0x20
ffffffffc020088c:	1402                	slli	s0,s0,0x20
ffffffffc020088e:	020b5b13          	srli	s6,s6,0x20
ffffffffc0200892:	0167eb33          	or	s6,a5,s6
ffffffffc0200896:	8c59                	or	s0,s0,a4
ffffffffc0200898:	893ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020089c:	85a2                	mv	a1,s0
ffffffffc020089e:	0000b517          	auipc	a0,0xb
ffffffffc02008a2:	f2250513          	addi	a0,a0,-222 # ffffffffc020b7c0 <commands+0xf8>
ffffffffc02008a6:	885ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02008aa:	014b5613          	srli	a2,s6,0x14
ffffffffc02008ae:	85da                	mv	a1,s6
ffffffffc02008b0:	0000b517          	auipc	a0,0xb
ffffffffc02008b4:	f2850513          	addi	a0,a0,-216 # ffffffffc020b7d8 <commands+0x110>
ffffffffc02008b8:	873ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02008bc:	008b05b3          	add	a1,s6,s0
ffffffffc02008c0:	15fd                	addi	a1,a1,-1
ffffffffc02008c2:	0000b517          	auipc	a0,0xb
ffffffffc02008c6:	f3650513          	addi	a0,a0,-202 # ffffffffc020b7f8 <commands+0x130>
ffffffffc02008ca:	861ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02008ce:	0000b517          	auipc	a0,0xb
ffffffffc02008d2:	f7a50513          	addi	a0,a0,-134 # ffffffffc020b848 <commands+0x180>
ffffffffc02008d6:	00096797          	auipc	a5,0x96
ffffffffc02008da:	f887bd23          	sd	s0,-102(a5) # ffffffffc0296870 <memory_base>
ffffffffc02008de:	00096797          	auipc	a5,0x96
ffffffffc02008e2:	f967bd23          	sd	s6,-102(a5) # ffffffffc0296878 <memory_size>
ffffffffc02008e6:	b3f5                	j	ffffffffc02006d2 <dtb_init+0x186>

ffffffffc02008e8 <get_memory_base>:
ffffffffc02008e8:	00096517          	auipc	a0,0x96
ffffffffc02008ec:	f8853503          	ld	a0,-120(a0) # ffffffffc0296870 <memory_base>
ffffffffc02008f0:	8082                	ret

ffffffffc02008f2 <get_memory_size>:
ffffffffc02008f2:	00096517          	auipc	a0,0x96
ffffffffc02008f6:	f8653503          	ld	a0,-122(a0) # ffffffffc0296878 <memory_size>
ffffffffc02008fa:	8082                	ret

ffffffffc02008fc <ramdisk_write>:
ffffffffc02008fc:	00856703          	lwu	a4,8(a0)
ffffffffc0200900:	1141                	addi	sp,sp,-16
ffffffffc0200902:	e406                	sd	ra,8(sp)
ffffffffc0200904:	8f0d                	sub	a4,a4,a1
ffffffffc0200906:	87ae                	mv	a5,a1
ffffffffc0200908:	85b2                	mv	a1,a2
ffffffffc020090a:	00e6f363          	bgeu	a3,a4,ffffffffc0200910 <ramdisk_write+0x14>
ffffffffc020090e:	8736                	mv	a4,a3
ffffffffc0200910:	6908                	ld	a0,16(a0)
ffffffffc0200912:	07a6                	slli	a5,a5,0x9
ffffffffc0200914:	00971613          	slli	a2,a4,0x9
ffffffffc0200918:	953e                	add	a0,a0,a5
ffffffffc020091a:	6580a0ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc020091e:	60a2                	ld	ra,8(sp)
ffffffffc0200920:	4501                	li	a0,0
ffffffffc0200922:	0141                	addi	sp,sp,16
ffffffffc0200924:	8082                	ret

ffffffffc0200926 <ramdisk_read>:
ffffffffc0200926:	00856783          	lwu	a5,8(a0)
ffffffffc020092a:	1141                	addi	sp,sp,-16
ffffffffc020092c:	e406                	sd	ra,8(sp)
ffffffffc020092e:	8f8d                	sub	a5,a5,a1
ffffffffc0200930:	872a                	mv	a4,a0
ffffffffc0200932:	8532                	mv	a0,a2
ffffffffc0200934:	00f6f363          	bgeu	a3,a5,ffffffffc020093a <ramdisk_read+0x14>
ffffffffc0200938:	87b6                	mv	a5,a3
ffffffffc020093a:	6b18                	ld	a4,16(a4)
ffffffffc020093c:	05a6                	slli	a1,a1,0x9
ffffffffc020093e:	00979613          	slli	a2,a5,0x9
ffffffffc0200942:	95ba                	add	a1,a1,a4
ffffffffc0200944:	62e0a0ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0200948:	60a2                	ld	ra,8(sp)
ffffffffc020094a:	4501                	li	a0,0
ffffffffc020094c:	0141                	addi	sp,sp,16
ffffffffc020094e:	8082                	ret

ffffffffc0200950 <ramdisk_init>:
ffffffffc0200950:	1101                	addi	sp,sp,-32
ffffffffc0200952:	e822                	sd	s0,16(sp)
ffffffffc0200954:	842e                	mv	s0,a1
ffffffffc0200956:	e426                	sd	s1,8(sp)
ffffffffc0200958:	05000613          	li	a2,80
ffffffffc020095c:	84aa                	mv	s1,a0
ffffffffc020095e:	4581                	li	a1,0
ffffffffc0200960:	8522                	mv	a0,s0
ffffffffc0200962:	ec06                	sd	ra,24(sp)
ffffffffc0200964:	e04a                	sd	s2,0(sp)
ffffffffc0200966:	5ba0a0ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc020096a:	4785                	li	a5,1
ffffffffc020096c:	06f48b63          	beq	s1,a5,ffffffffc02009e2 <ramdisk_init+0x92>
ffffffffc0200970:	4789                	li	a5,2
ffffffffc0200972:	00090617          	auipc	a2,0x90
ffffffffc0200976:	69e60613          	addi	a2,a2,1694 # ffffffffc0291010 <arena>
ffffffffc020097a:	0001b917          	auipc	s2,0x1b
ffffffffc020097e:	39690913          	addi	s2,s2,918 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200982:	08f49563          	bne	s1,a5,ffffffffc0200a0c <ramdisk_init+0xbc>
ffffffffc0200986:	06c90863          	beq	s2,a2,ffffffffc02009f6 <ramdisk_init+0xa6>
ffffffffc020098a:	412604b3          	sub	s1,a2,s2
ffffffffc020098e:	86a6                	mv	a3,s1
ffffffffc0200990:	85ca                	mv	a1,s2
ffffffffc0200992:	167d                	addi	a2,a2,-1
ffffffffc0200994:	0000b517          	auipc	a0,0xb
ffffffffc0200998:	ee450513          	addi	a0,a0,-284 # ffffffffc020b878 <commands+0x1b0>
ffffffffc020099c:	f8eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02009a0:	57fd                	li	a5,-1
ffffffffc02009a2:	1782                	slli	a5,a5,0x20
ffffffffc02009a4:	0785                	addi	a5,a5,1
ffffffffc02009a6:	0094d49b          	srliw	s1,s1,0x9
ffffffffc02009aa:	e01c                	sd	a5,0(s0)
ffffffffc02009ac:	c404                	sw	s1,8(s0)
ffffffffc02009ae:	01243823          	sd	s2,16(s0)
ffffffffc02009b2:	02040513          	addi	a0,s0,32
ffffffffc02009b6:	0000b597          	auipc	a1,0xb
ffffffffc02009ba:	f1a58593          	addi	a1,a1,-230 # ffffffffc020b8d0 <commands+0x208>
ffffffffc02009be:	4f60a0ef          	jal	ra,ffffffffc020aeb4 <strcpy>
ffffffffc02009c2:	00000797          	auipc	a5,0x0
ffffffffc02009c6:	f6478793          	addi	a5,a5,-156 # ffffffffc0200926 <ramdisk_read>
ffffffffc02009ca:	e03c                	sd	a5,64(s0)
ffffffffc02009cc:	00000797          	auipc	a5,0x0
ffffffffc02009d0:	f3078793          	addi	a5,a5,-208 # ffffffffc02008fc <ramdisk_write>
ffffffffc02009d4:	60e2                	ld	ra,24(sp)
ffffffffc02009d6:	e43c                	sd	a5,72(s0)
ffffffffc02009d8:	6442                	ld	s0,16(sp)
ffffffffc02009da:	64a2                	ld	s1,8(sp)
ffffffffc02009dc:	6902                	ld	s2,0(sp)
ffffffffc02009de:	6105                	addi	sp,sp,32
ffffffffc02009e0:	8082                	ret
ffffffffc02009e2:	0001b617          	auipc	a2,0x1b
ffffffffc02009e6:	32e60613          	addi	a2,a2,814 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc02009ea:	00013917          	auipc	s2,0x13
ffffffffc02009ee:	62690913          	addi	s2,s2,1574 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc02009f2:	f8c91ce3          	bne	s2,a2,ffffffffc020098a <ramdisk_init+0x3a>
ffffffffc02009f6:	6442                	ld	s0,16(sp)
ffffffffc02009f8:	60e2                	ld	ra,24(sp)
ffffffffc02009fa:	64a2                	ld	s1,8(sp)
ffffffffc02009fc:	6902                	ld	s2,0(sp)
ffffffffc02009fe:	0000b517          	auipc	a0,0xb
ffffffffc0200a02:	e6250513          	addi	a0,a0,-414 # ffffffffc020b860 <commands+0x198>
ffffffffc0200a06:	6105                	addi	sp,sp,32
ffffffffc0200a08:	f22ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0200a0c:	0000b617          	auipc	a2,0xb
ffffffffc0200a10:	e9460613          	addi	a2,a2,-364 # ffffffffc020b8a0 <commands+0x1d8>
ffffffffc0200a14:	03200593          	li	a1,50
ffffffffc0200a18:	0000b517          	auipc	a0,0xb
ffffffffc0200a1c:	ea050513          	addi	a0,a0,-352 # ffffffffc020b8b8 <commands+0x1f0>
ffffffffc0200a20:	80fff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200a24 <clock_init>:
ffffffffc0200a24:	02000793          	li	a5,32
ffffffffc0200a28:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200a2c:	c0102573          	rdtime	a0
ffffffffc0200a30:	67e1                	lui	a5,0x18
ffffffffc0200a32:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200a36:	953e                	add	a0,a0,a5
ffffffffc0200a38:	4581                	li	a1,0
ffffffffc0200a3a:	4601                	li	a2,0
ffffffffc0200a3c:	4881                	li	a7,0
ffffffffc0200a3e:	00000073          	ecall
ffffffffc0200a42:	0000b517          	auipc	a0,0xb
ffffffffc0200a46:	e9e50513          	addi	a0,a0,-354 # ffffffffc020b8e0 <commands+0x218>
ffffffffc0200a4a:	00096797          	auipc	a5,0x96
ffffffffc0200a4e:	e207bb23          	sd	zero,-458(a5) # ffffffffc0296880 <ticks>
ffffffffc0200a52:	ed8ff06f          	j	ffffffffc020012a <cprintf>

ffffffffc0200a56 <clock_set_next_event>:
ffffffffc0200a56:	c0102573          	rdtime	a0
ffffffffc0200a5a:	67e1                	lui	a5,0x18
ffffffffc0200a5c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200a60:	953e                	add	a0,a0,a5
ffffffffc0200a62:	4581                	li	a1,0
ffffffffc0200a64:	4601                	li	a2,0
ffffffffc0200a66:	4881                	li	a7,0
ffffffffc0200a68:	00000073          	ecall
ffffffffc0200a6c:	8082                	ret

ffffffffc0200a6e <cons_init>:
ffffffffc0200a6e:	4501                	li	a0,0
ffffffffc0200a70:	4581                	li	a1,0
ffffffffc0200a72:	4601                	li	a2,0
ffffffffc0200a74:	4889                	li	a7,2
ffffffffc0200a76:	00000073          	ecall
ffffffffc0200a7a:	8082                	ret

ffffffffc0200a7c <cons_putc>:
ffffffffc0200a7c:	1101                	addi	sp,sp,-32
ffffffffc0200a7e:	ec06                	sd	ra,24(sp)
ffffffffc0200a80:	100027f3          	csrr	a5,sstatus
ffffffffc0200a84:	8b89                	andi	a5,a5,2
ffffffffc0200a86:	4701                	li	a4,0
ffffffffc0200a88:	ef95                	bnez	a5,ffffffffc0200ac4 <cons_putc+0x48>
ffffffffc0200a8a:	47a1                	li	a5,8
ffffffffc0200a8c:	00f50b63          	beq	a0,a5,ffffffffc0200aa2 <cons_putc+0x26>
ffffffffc0200a90:	4581                	li	a1,0
ffffffffc0200a92:	4601                	li	a2,0
ffffffffc0200a94:	4885                	li	a7,1
ffffffffc0200a96:	00000073          	ecall
ffffffffc0200a9a:	e315                	bnez	a4,ffffffffc0200abe <cons_putc+0x42>
ffffffffc0200a9c:	60e2                	ld	ra,24(sp)
ffffffffc0200a9e:	6105                	addi	sp,sp,32
ffffffffc0200aa0:	8082                	ret
ffffffffc0200aa2:	4521                	li	a0,8
ffffffffc0200aa4:	4581                	li	a1,0
ffffffffc0200aa6:	4601                	li	a2,0
ffffffffc0200aa8:	4885                	li	a7,1
ffffffffc0200aaa:	00000073          	ecall
ffffffffc0200aae:	02000513          	li	a0,32
ffffffffc0200ab2:	00000073          	ecall
ffffffffc0200ab6:	4521                	li	a0,8
ffffffffc0200ab8:	00000073          	ecall
ffffffffc0200abc:	d365                	beqz	a4,ffffffffc0200a9c <cons_putc+0x20>
ffffffffc0200abe:	60e2                	ld	ra,24(sp)
ffffffffc0200ac0:	6105                	addi	sp,sp,32
ffffffffc0200ac2:	ace1                	j	ffffffffc0200d9a <intr_enable>
ffffffffc0200ac4:	e42a                	sd	a0,8(sp)
ffffffffc0200ac6:	2da000ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0200aca:	6522                	ld	a0,8(sp)
ffffffffc0200acc:	4705                	li	a4,1
ffffffffc0200ace:	bf75                	j	ffffffffc0200a8a <cons_putc+0xe>

ffffffffc0200ad0 <cons_getc>:
ffffffffc0200ad0:	1101                	addi	sp,sp,-32
ffffffffc0200ad2:	ec06                	sd	ra,24(sp)
ffffffffc0200ad4:	100027f3          	csrr	a5,sstatus
ffffffffc0200ad8:	8b89                	andi	a5,a5,2
ffffffffc0200ada:	4801                	li	a6,0
ffffffffc0200adc:	e3d5                	bnez	a5,ffffffffc0200b80 <cons_getc+0xb0>
ffffffffc0200ade:	00091697          	auipc	a3,0x91
ffffffffc0200ae2:	98268693          	addi	a3,a3,-1662 # ffffffffc0291460 <cons>
ffffffffc0200ae6:	07f00713          	li	a4,127
ffffffffc0200aea:	20000313          	li	t1,512
ffffffffc0200aee:	a021                	j	ffffffffc0200af6 <cons_getc+0x26>
ffffffffc0200af0:	0ff57513          	zext.b	a0,a0
ffffffffc0200af4:	ef91                	bnez	a5,ffffffffc0200b10 <cons_getc+0x40>
ffffffffc0200af6:	4501                	li	a0,0
ffffffffc0200af8:	4581                	li	a1,0
ffffffffc0200afa:	4601                	li	a2,0
ffffffffc0200afc:	4889                	li	a7,2
ffffffffc0200afe:	00000073          	ecall
ffffffffc0200b02:	0005079b          	sext.w	a5,a0
ffffffffc0200b06:	0207c763          	bltz	a5,ffffffffc0200b34 <cons_getc+0x64>
ffffffffc0200b0a:	fee793e3          	bne	a5,a4,ffffffffc0200af0 <cons_getc+0x20>
ffffffffc0200b0e:	4521                	li	a0,8
ffffffffc0200b10:	2046a783          	lw	a5,516(a3)
ffffffffc0200b14:	02079613          	slli	a2,a5,0x20
ffffffffc0200b18:	9201                	srli	a2,a2,0x20
ffffffffc0200b1a:	2785                	addiw	a5,a5,1
ffffffffc0200b1c:	9636                	add	a2,a2,a3
ffffffffc0200b1e:	20f6a223          	sw	a5,516(a3)
ffffffffc0200b22:	00a60023          	sb	a0,0(a2)
ffffffffc0200b26:	fc6798e3          	bne	a5,t1,ffffffffc0200af6 <cons_getc+0x26>
ffffffffc0200b2a:	00091797          	auipc	a5,0x91
ffffffffc0200b2e:	b207ad23          	sw	zero,-1222(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200b32:	b7d1                	j	ffffffffc0200af6 <cons_getc+0x26>
ffffffffc0200b34:	2006a783          	lw	a5,512(a3)
ffffffffc0200b38:	2046a703          	lw	a4,516(a3)
ffffffffc0200b3c:	4501                	li	a0,0
ffffffffc0200b3e:	00f70f63          	beq	a4,a5,ffffffffc0200b5c <cons_getc+0x8c>
ffffffffc0200b42:	0017861b          	addiw	a2,a5,1
ffffffffc0200b46:	1782                	slli	a5,a5,0x20
ffffffffc0200b48:	9381                	srli	a5,a5,0x20
ffffffffc0200b4a:	97b6                	add	a5,a5,a3
ffffffffc0200b4c:	20c6a023          	sw	a2,512(a3)
ffffffffc0200b50:	20000713          	li	a4,512
ffffffffc0200b54:	0007c503          	lbu	a0,0(a5)
ffffffffc0200b58:	00e60763          	beq	a2,a4,ffffffffc0200b66 <cons_getc+0x96>
ffffffffc0200b5c:	00081b63          	bnez	a6,ffffffffc0200b72 <cons_getc+0xa2>
ffffffffc0200b60:	60e2                	ld	ra,24(sp)
ffffffffc0200b62:	6105                	addi	sp,sp,32
ffffffffc0200b64:	8082                	ret
ffffffffc0200b66:	00091797          	auipc	a5,0x91
ffffffffc0200b6a:	ae07ad23          	sw	zero,-1286(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200b6e:	fe0809e3          	beqz	a6,ffffffffc0200b60 <cons_getc+0x90>
ffffffffc0200b72:	e42a                	sd	a0,8(sp)
ffffffffc0200b74:	226000ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0200b78:	60e2                	ld	ra,24(sp)
ffffffffc0200b7a:	6522                	ld	a0,8(sp)
ffffffffc0200b7c:	6105                	addi	sp,sp,32
ffffffffc0200b7e:	8082                	ret
ffffffffc0200b80:	220000ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0200b84:	4805                	li	a6,1
ffffffffc0200b86:	bfa1                	j	ffffffffc0200ade <cons_getc+0xe>

ffffffffc0200b88 <pic_init>:
ffffffffc0200b88:	8082                	ret

ffffffffc0200b8a <ide_init>:
ffffffffc0200b8a:	1141                	addi	sp,sp,-16
ffffffffc0200b8c:	00091597          	auipc	a1,0x91
ffffffffc0200b90:	b2c58593          	addi	a1,a1,-1236 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200b94:	4505                	li	a0,1
ffffffffc0200b96:	e022                	sd	s0,0(sp)
ffffffffc0200b98:	00091797          	auipc	a5,0x91
ffffffffc0200b9c:	ac07a823          	sw	zero,-1328(a5) # ffffffffc0291668 <ide_devices>
ffffffffc0200ba0:	00091797          	auipc	a5,0x91
ffffffffc0200ba4:	b007ac23          	sw	zero,-1256(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200ba8:	00091797          	auipc	a5,0x91
ffffffffc0200bac:	b607a023          	sw	zero,-1184(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200bb0:	00091797          	auipc	a5,0x91
ffffffffc0200bb4:	ba07a423          	sw	zero,-1112(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200bb8:	e406                	sd	ra,8(sp)
ffffffffc0200bba:	00091417          	auipc	s0,0x91
ffffffffc0200bbe:	aae40413          	addi	s0,s0,-1362 # ffffffffc0291668 <ide_devices>
ffffffffc0200bc2:	d8fff0ef          	jal	ra,ffffffffc0200950 <ramdisk_init>
ffffffffc0200bc6:	483c                	lw	a5,80(s0)
ffffffffc0200bc8:	cf99                	beqz	a5,ffffffffc0200be6 <ide_init+0x5c>
ffffffffc0200bca:	00091597          	auipc	a1,0x91
ffffffffc0200bce:	b3e58593          	addi	a1,a1,-1218 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200bd2:	4509                	li	a0,2
ffffffffc0200bd4:	d7dff0ef          	jal	ra,ffffffffc0200950 <ramdisk_init>
ffffffffc0200bd8:	0a042783          	lw	a5,160(s0)
ffffffffc0200bdc:	c785                	beqz	a5,ffffffffc0200c04 <ide_init+0x7a>
ffffffffc0200bde:	60a2                	ld	ra,8(sp)
ffffffffc0200be0:	6402                	ld	s0,0(sp)
ffffffffc0200be2:	0141                	addi	sp,sp,16
ffffffffc0200be4:	8082                	ret
ffffffffc0200be6:	0000b697          	auipc	a3,0xb
ffffffffc0200bea:	d1a68693          	addi	a3,a3,-742 # ffffffffc020b900 <commands+0x238>
ffffffffc0200bee:	0000b617          	auipc	a2,0xb
ffffffffc0200bf2:	d2a60613          	addi	a2,a2,-726 # ffffffffc020b918 <commands+0x250>
ffffffffc0200bf6:	45c5                	li	a1,17
ffffffffc0200bf8:	0000b517          	auipc	a0,0xb
ffffffffc0200bfc:	d3850513          	addi	a0,a0,-712 # ffffffffc020b930 <commands+0x268>
ffffffffc0200c00:	e2eff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0200c04:	0000b697          	auipc	a3,0xb
ffffffffc0200c08:	d4468693          	addi	a3,a3,-700 # ffffffffc020b948 <commands+0x280>
ffffffffc0200c0c:	0000b617          	auipc	a2,0xb
ffffffffc0200c10:	d0c60613          	addi	a2,a2,-756 # ffffffffc020b918 <commands+0x250>
ffffffffc0200c14:	45d1                	li	a1,20
ffffffffc0200c16:	0000b517          	auipc	a0,0xb
ffffffffc0200c1a:	d1a50513          	addi	a0,a0,-742 # ffffffffc020b930 <commands+0x268>
ffffffffc0200c1e:	e10ff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200c22 <ide_device_valid>:
ffffffffc0200c22:	478d                	li	a5,3
ffffffffc0200c24:	00a7ef63          	bltu	a5,a0,ffffffffc0200c42 <ide_device_valid+0x20>
ffffffffc0200c28:	00251793          	slli	a5,a0,0x2
ffffffffc0200c2c:	953e                	add	a0,a0,a5
ffffffffc0200c2e:	0512                	slli	a0,a0,0x4
ffffffffc0200c30:	00091797          	auipc	a5,0x91
ffffffffc0200c34:	a3878793          	addi	a5,a5,-1480 # ffffffffc0291668 <ide_devices>
ffffffffc0200c38:	953e                	add	a0,a0,a5
ffffffffc0200c3a:	4108                	lw	a0,0(a0)
ffffffffc0200c3c:	00a03533          	snez	a0,a0
ffffffffc0200c40:	8082                	ret
ffffffffc0200c42:	4501                	li	a0,0
ffffffffc0200c44:	8082                	ret

ffffffffc0200c46 <ide_device_size>:
ffffffffc0200c46:	478d                	li	a5,3
ffffffffc0200c48:	02a7e163          	bltu	a5,a0,ffffffffc0200c6a <ide_device_size+0x24>
ffffffffc0200c4c:	00251793          	slli	a5,a0,0x2
ffffffffc0200c50:	953e                	add	a0,a0,a5
ffffffffc0200c52:	0512                	slli	a0,a0,0x4
ffffffffc0200c54:	00091797          	auipc	a5,0x91
ffffffffc0200c58:	a1478793          	addi	a5,a5,-1516 # ffffffffc0291668 <ide_devices>
ffffffffc0200c5c:	97aa                	add	a5,a5,a0
ffffffffc0200c5e:	4398                	lw	a4,0(a5)
ffffffffc0200c60:	4501                	li	a0,0
ffffffffc0200c62:	c709                	beqz	a4,ffffffffc0200c6c <ide_device_size+0x26>
ffffffffc0200c64:	0087e503          	lwu	a0,8(a5)
ffffffffc0200c68:	8082                	ret
ffffffffc0200c6a:	4501                	li	a0,0
ffffffffc0200c6c:	8082                	ret

ffffffffc0200c6e <ide_read_secs>:
ffffffffc0200c6e:	1141                	addi	sp,sp,-16
ffffffffc0200c70:	e406                	sd	ra,8(sp)
ffffffffc0200c72:	08000793          	li	a5,128
ffffffffc0200c76:	04d7e763          	bltu	a5,a3,ffffffffc0200cc4 <ide_read_secs+0x56>
ffffffffc0200c7a:	478d                	li	a5,3
ffffffffc0200c7c:	0005081b          	sext.w	a6,a0
ffffffffc0200c80:	04a7e263          	bltu	a5,a0,ffffffffc0200cc4 <ide_read_secs+0x56>
ffffffffc0200c84:	00281793          	slli	a5,a6,0x2
ffffffffc0200c88:	97c2                	add	a5,a5,a6
ffffffffc0200c8a:	0792                	slli	a5,a5,0x4
ffffffffc0200c8c:	00091817          	auipc	a6,0x91
ffffffffc0200c90:	9dc80813          	addi	a6,a6,-1572 # ffffffffc0291668 <ide_devices>
ffffffffc0200c94:	97c2                	add	a5,a5,a6
ffffffffc0200c96:	0007a883          	lw	a7,0(a5)
ffffffffc0200c9a:	02088563          	beqz	a7,ffffffffc0200cc4 <ide_read_secs+0x56>
ffffffffc0200c9e:	100008b7          	lui	a7,0x10000
ffffffffc0200ca2:	0515f163          	bgeu	a1,a7,ffffffffc0200ce4 <ide_read_secs+0x76>
ffffffffc0200ca6:	1582                	slli	a1,a1,0x20
ffffffffc0200ca8:	9181                	srli	a1,a1,0x20
ffffffffc0200caa:	00d58733          	add	a4,a1,a3
ffffffffc0200cae:	02e8eb63          	bltu	a7,a4,ffffffffc0200ce4 <ide_read_secs+0x76>
ffffffffc0200cb2:	00251713          	slli	a4,a0,0x2
ffffffffc0200cb6:	60a2                	ld	ra,8(sp)
ffffffffc0200cb8:	63bc                	ld	a5,64(a5)
ffffffffc0200cba:	953a                	add	a0,a0,a4
ffffffffc0200cbc:	0512                	slli	a0,a0,0x4
ffffffffc0200cbe:	9542                	add	a0,a0,a6
ffffffffc0200cc0:	0141                	addi	sp,sp,16
ffffffffc0200cc2:	8782                	jr	a5
ffffffffc0200cc4:	0000b697          	auipc	a3,0xb
ffffffffc0200cc8:	c9c68693          	addi	a3,a3,-868 # ffffffffc020b960 <commands+0x298>
ffffffffc0200ccc:	0000b617          	auipc	a2,0xb
ffffffffc0200cd0:	c4c60613          	addi	a2,a2,-948 # ffffffffc020b918 <commands+0x250>
ffffffffc0200cd4:	02200593          	li	a1,34
ffffffffc0200cd8:	0000b517          	auipc	a0,0xb
ffffffffc0200cdc:	c5850513          	addi	a0,a0,-936 # ffffffffc020b930 <commands+0x268>
ffffffffc0200ce0:	d4eff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0200ce4:	0000b697          	auipc	a3,0xb
ffffffffc0200ce8:	ca468693          	addi	a3,a3,-860 # ffffffffc020b988 <commands+0x2c0>
ffffffffc0200cec:	0000b617          	auipc	a2,0xb
ffffffffc0200cf0:	c2c60613          	addi	a2,a2,-980 # ffffffffc020b918 <commands+0x250>
ffffffffc0200cf4:	02300593          	li	a1,35
ffffffffc0200cf8:	0000b517          	auipc	a0,0xb
ffffffffc0200cfc:	c3850513          	addi	a0,a0,-968 # ffffffffc020b930 <commands+0x268>
ffffffffc0200d00:	d2eff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200d04 <ide_write_secs>:
ffffffffc0200d04:	1141                	addi	sp,sp,-16
ffffffffc0200d06:	e406                	sd	ra,8(sp)
ffffffffc0200d08:	08000793          	li	a5,128
ffffffffc0200d0c:	04d7e763          	bltu	a5,a3,ffffffffc0200d5a <ide_write_secs+0x56>
ffffffffc0200d10:	478d                	li	a5,3
ffffffffc0200d12:	0005081b          	sext.w	a6,a0
ffffffffc0200d16:	04a7e263          	bltu	a5,a0,ffffffffc0200d5a <ide_write_secs+0x56>
ffffffffc0200d1a:	00281793          	slli	a5,a6,0x2
ffffffffc0200d1e:	97c2                	add	a5,a5,a6
ffffffffc0200d20:	0792                	slli	a5,a5,0x4
ffffffffc0200d22:	00091817          	auipc	a6,0x91
ffffffffc0200d26:	94680813          	addi	a6,a6,-1722 # ffffffffc0291668 <ide_devices>
ffffffffc0200d2a:	97c2                	add	a5,a5,a6
ffffffffc0200d2c:	0007a883          	lw	a7,0(a5)
ffffffffc0200d30:	02088563          	beqz	a7,ffffffffc0200d5a <ide_write_secs+0x56>
ffffffffc0200d34:	100008b7          	lui	a7,0x10000
ffffffffc0200d38:	0515f163          	bgeu	a1,a7,ffffffffc0200d7a <ide_write_secs+0x76>
ffffffffc0200d3c:	1582                	slli	a1,a1,0x20
ffffffffc0200d3e:	9181                	srli	a1,a1,0x20
ffffffffc0200d40:	00d58733          	add	a4,a1,a3
ffffffffc0200d44:	02e8eb63          	bltu	a7,a4,ffffffffc0200d7a <ide_write_secs+0x76>
ffffffffc0200d48:	00251713          	slli	a4,a0,0x2
ffffffffc0200d4c:	60a2                	ld	ra,8(sp)
ffffffffc0200d4e:	67bc                	ld	a5,72(a5)
ffffffffc0200d50:	953a                	add	a0,a0,a4
ffffffffc0200d52:	0512                	slli	a0,a0,0x4
ffffffffc0200d54:	9542                	add	a0,a0,a6
ffffffffc0200d56:	0141                	addi	sp,sp,16
ffffffffc0200d58:	8782                	jr	a5
ffffffffc0200d5a:	0000b697          	auipc	a3,0xb
ffffffffc0200d5e:	c0668693          	addi	a3,a3,-1018 # ffffffffc020b960 <commands+0x298>
ffffffffc0200d62:	0000b617          	auipc	a2,0xb
ffffffffc0200d66:	bb660613          	addi	a2,a2,-1098 # ffffffffc020b918 <commands+0x250>
ffffffffc0200d6a:	02900593          	li	a1,41
ffffffffc0200d6e:	0000b517          	auipc	a0,0xb
ffffffffc0200d72:	bc250513          	addi	a0,a0,-1086 # ffffffffc020b930 <commands+0x268>
ffffffffc0200d76:	cb8ff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0200d7a:	0000b697          	auipc	a3,0xb
ffffffffc0200d7e:	c0e68693          	addi	a3,a3,-1010 # ffffffffc020b988 <commands+0x2c0>
ffffffffc0200d82:	0000b617          	auipc	a2,0xb
ffffffffc0200d86:	b9660613          	addi	a2,a2,-1130 # ffffffffc020b918 <commands+0x250>
ffffffffc0200d8a:	02a00593          	li	a1,42
ffffffffc0200d8e:	0000b517          	auipc	a0,0xb
ffffffffc0200d92:	ba250513          	addi	a0,a0,-1118 # ffffffffc020b930 <commands+0x268>
ffffffffc0200d96:	c98ff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200d9a <intr_enable>:
ffffffffc0200d9a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200d9e:	8082                	ret

ffffffffc0200da0 <intr_disable>:
ffffffffc0200da0:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200da4:	8082                	ret

ffffffffc0200da6 <idt_init>:
ffffffffc0200da6:	14005073          	csrwi	sscratch,0
ffffffffc0200daa:	00000797          	auipc	a5,0x0
ffffffffc0200dae:	43a78793          	addi	a5,a5,1082 # ffffffffc02011e4 <__alltraps>
ffffffffc0200db2:	10579073          	csrw	stvec,a5
ffffffffc0200db6:	000407b7          	lui	a5,0x40
ffffffffc0200dba:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200dbe:	8082                	ret

ffffffffc0200dc0 <print_regs>:
ffffffffc0200dc0:	610c                	ld	a1,0(a0)
ffffffffc0200dc2:	1141                	addi	sp,sp,-16
ffffffffc0200dc4:	e022                	sd	s0,0(sp)
ffffffffc0200dc6:	842a                	mv	s0,a0
ffffffffc0200dc8:	0000b517          	auipc	a0,0xb
ffffffffc0200dcc:	c0050513          	addi	a0,a0,-1024 # ffffffffc020b9c8 <commands+0x300>
ffffffffc0200dd0:	e406                	sd	ra,8(sp)
ffffffffc0200dd2:	b58ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200dd6:	640c                	ld	a1,8(s0)
ffffffffc0200dd8:	0000b517          	auipc	a0,0xb
ffffffffc0200ddc:	c0850513          	addi	a0,a0,-1016 # ffffffffc020b9e0 <commands+0x318>
ffffffffc0200de0:	b4aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200de4:	680c                	ld	a1,16(s0)
ffffffffc0200de6:	0000b517          	auipc	a0,0xb
ffffffffc0200dea:	c1250513          	addi	a0,a0,-1006 # ffffffffc020b9f8 <commands+0x330>
ffffffffc0200dee:	b3cff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200df2:	6c0c                	ld	a1,24(s0)
ffffffffc0200df4:	0000b517          	auipc	a0,0xb
ffffffffc0200df8:	c1c50513          	addi	a0,a0,-996 # ffffffffc020ba10 <commands+0x348>
ffffffffc0200dfc:	b2eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e00:	700c                	ld	a1,32(s0)
ffffffffc0200e02:	0000b517          	auipc	a0,0xb
ffffffffc0200e06:	c2650513          	addi	a0,a0,-986 # ffffffffc020ba28 <commands+0x360>
ffffffffc0200e0a:	b20ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e0e:	740c                	ld	a1,40(s0)
ffffffffc0200e10:	0000b517          	auipc	a0,0xb
ffffffffc0200e14:	c3050513          	addi	a0,a0,-976 # ffffffffc020ba40 <commands+0x378>
ffffffffc0200e18:	b12ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e1c:	780c                	ld	a1,48(s0)
ffffffffc0200e1e:	0000b517          	auipc	a0,0xb
ffffffffc0200e22:	c3a50513          	addi	a0,a0,-966 # ffffffffc020ba58 <commands+0x390>
ffffffffc0200e26:	b04ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e2a:	7c0c                	ld	a1,56(s0)
ffffffffc0200e2c:	0000b517          	auipc	a0,0xb
ffffffffc0200e30:	c4450513          	addi	a0,a0,-956 # ffffffffc020ba70 <commands+0x3a8>
ffffffffc0200e34:	af6ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e38:	602c                	ld	a1,64(s0)
ffffffffc0200e3a:	0000b517          	auipc	a0,0xb
ffffffffc0200e3e:	c4e50513          	addi	a0,a0,-946 # ffffffffc020ba88 <commands+0x3c0>
ffffffffc0200e42:	ae8ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e46:	642c                	ld	a1,72(s0)
ffffffffc0200e48:	0000b517          	auipc	a0,0xb
ffffffffc0200e4c:	c5850513          	addi	a0,a0,-936 # ffffffffc020baa0 <commands+0x3d8>
ffffffffc0200e50:	adaff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e54:	682c                	ld	a1,80(s0)
ffffffffc0200e56:	0000b517          	auipc	a0,0xb
ffffffffc0200e5a:	c6250513          	addi	a0,a0,-926 # ffffffffc020bab8 <commands+0x3f0>
ffffffffc0200e5e:	accff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e62:	6c2c                	ld	a1,88(s0)
ffffffffc0200e64:	0000b517          	auipc	a0,0xb
ffffffffc0200e68:	c6c50513          	addi	a0,a0,-916 # ffffffffc020bad0 <commands+0x408>
ffffffffc0200e6c:	abeff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e70:	702c                	ld	a1,96(s0)
ffffffffc0200e72:	0000b517          	auipc	a0,0xb
ffffffffc0200e76:	c7650513          	addi	a0,a0,-906 # ffffffffc020bae8 <commands+0x420>
ffffffffc0200e7a:	ab0ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e7e:	742c                	ld	a1,104(s0)
ffffffffc0200e80:	0000b517          	auipc	a0,0xb
ffffffffc0200e84:	c8050513          	addi	a0,a0,-896 # ffffffffc020bb00 <commands+0x438>
ffffffffc0200e88:	aa2ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e8c:	782c                	ld	a1,112(s0)
ffffffffc0200e8e:	0000b517          	auipc	a0,0xb
ffffffffc0200e92:	c8a50513          	addi	a0,a0,-886 # ffffffffc020bb18 <commands+0x450>
ffffffffc0200e96:	a94ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e9a:	7c2c                	ld	a1,120(s0)
ffffffffc0200e9c:	0000b517          	auipc	a0,0xb
ffffffffc0200ea0:	c9450513          	addi	a0,a0,-876 # ffffffffc020bb30 <commands+0x468>
ffffffffc0200ea4:	a86ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ea8:	604c                	ld	a1,128(s0)
ffffffffc0200eaa:	0000b517          	auipc	a0,0xb
ffffffffc0200eae:	c9e50513          	addi	a0,a0,-866 # ffffffffc020bb48 <commands+0x480>
ffffffffc0200eb2:	a78ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200eb6:	644c                	ld	a1,136(s0)
ffffffffc0200eb8:	0000b517          	auipc	a0,0xb
ffffffffc0200ebc:	ca850513          	addi	a0,a0,-856 # ffffffffc020bb60 <commands+0x498>
ffffffffc0200ec0:	a6aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ec4:	684c                	ld	a1,144(s0)
ffffffffc0200ec6:	0000b517          	auipc	a0,0xb
ffffffffc0200eca:	cb250513          	addi	a0,a0,-846 # ffffffffc020bb78 <commands+0x4b0>
ffffffffc0200ece:	a5cff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ed2:	6c4c                	ld	a1,152(s0)
ffffffffc0200ed4:	0000b517          	auipc	a0,0xb
ffffffffc0200ed8:	cbc50513          	addi	a0,a0,-836 # ffffffffc020bb90 <commands+0x4c8>
ffffffffc0200edc:	a4eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ee0:	704c                	ld	a1,160(s0)
ffffffffc0200ee2:	0000b517          	auipc	a0,0xb
ffffffffc0200ee6:	cc650513          	addi	a0,a0,-826 # ffffffffc020bba8 <commands+0x4e0>
ffffffffc0200eea:	a40ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200eee:	744c                	ld	a1,168(s0)
ffffffffc0200ef0:	0000b517          	auipc	a0,0xb
ffffffffc0200ef4:	cd050513          	addi	a0,a0,-816 # ffffffffc020bbc0 <commands+0x4f8>
ffffffffc0200ef8:	a32ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200efc:	784c                	ld	a1,176(s0)
ffffffffc0200efe:	0000b517          	auipc	a0,0xb
ffffffffc0200f02:	cda50513          	addi	a0,a0,-806 # ffffffffc020bbd8 <commands+0x510>
ffffffffc0200f06:	a24ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f0a:	7c4c                	ld	a1,184(s0)
ffffffffc0200f0c:	0000b517          	auipc	a0,0xb
ffffffffc0200f10:	ce450513          	addi	a0,a0,-796 # ffffffffc020bbf0 <commands+0x528>
ffffffffc0200f14:	a16ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f18:	606c                	ld	a1,192(s0)
ffffffffc0200f1a:	0000b517          	auipc	a0,0xb
ffffffffc0200f1e:	cee50513          	addi	a0,a0,-786 # ffffffffc020bc08 <commands+0x540>
ffffffffc0200f22:	a08ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f26:	646c                	ld	a1,200(s0)
ffffffffc0200f28:	0000b517          	auipc	a0,0xb
ffffffffc0200f2c:	cf850513          	addi	a0,a0,-776 # ffffffffc020bc20 <commands+0x558>
ffffffffc0200f30:	9faff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f34:	686c                	ld	a1,208(s0)
ffffffffc0200f36:	0000b517          	auipc	a0,0xb
ffffffffc0200f3a:	d0250513          	addi	a0,a0,-766 # ffffffffc020bc38 <commands+0x570>
ffffffffc0200f3e:	9ecff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f42:	6c6c                	ld	a1,216(s0)
ffffffffc0200f44:	0000b517          	auipc	a0,0xb
ffffffffc0200f48:	d0c50513          	addi	a0,a0,-756 # ffffffffc020bc50 <commands+0x588>
ffffffffc0200f4c:	9deff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f50:	706c                	ld	a1,224(s0)
ffffffffc0200f52:	0000b517          	auipc	a0,0xb
ffffffffc0200f56:	d1650513          	addi	a0,a0,-746 # ffffffffc020bc68 <commands+0x5a0>
ffffffffc0200f5a:	9d0ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f5e:	746c                	ld	a1,232(s0)
ffffffffc0200f60:	0000b517          	auipc	a0,0xb
ffffffffc0200f64:	d2050513          	addi	a0,a0,-736 # ffffffffc020bc80 <commands+0x5b8>
ffffffffc0200f68:	9c2ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f6c:	786c                	ld	a1,240(s0)
ffffffffc0200f6e:	0000b517          	auipc	a0,0xb
ffffffffc0200f72:	d2a50513          	addi	a0,a0,-726 # ffffffffc020bc98 <commands+0x5d0>
ffffffffc0200f76:	9b4ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f7a:	7c6c                	ld	a1,248(s0)
ffffffffc0200f7c:	6402                	ld	s0,0(sp)
ffffffffc0200f7e:	60a2                	ld	ra,8(sp)
ffffffffc0200f80:	0000b517          	auipc	a0,0xb
ffffffffc0200f84:	d3050513          	addi	a0,a0,-720 # ffffffffc020bcb0 <commands+0x5e8>
ffffffffc0200f88:	0141                	addi	sp,sp,16
ffffffffc0200f8a:	9a0ff06f          	j	ffffffffc020012a <cprintf>

ffffffffc0200f8e <print_trapframe>:
ffffffffc0200f8e:	1141                	addi	sp,sp,-16
ffffffffc0200f90:	e022                	sd	s0,0(sp)
ffffffffc0200f92:	85aa                	mv	a1,a0
ffffffffc0200f94:	842a                	mv	s0,a0
ffffffffc0200f96:	0000b517          	auipc	a0,0xb
ffffffffc0200f9a:	d3250513          	addi	a0,a0,-718 # ffffffffc020bcc8 <commands+0x600>
ffffffffc0200f9e:	e406                	sd	ra,8(sp)
ffffffffc0200fa0:	98aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fa4:	8522                	mv	a0,s0
ffffffffc0200fa6:	e1bff0ef          	jal	ra,ffffffffc0200dc0 <print_regs>
ffffffffc0200faa:	10043583          	ld	a1,256(s0)
ffffffffc0200fae:	0000b517          	auipc	a0,0xb
ffffffffc0200fb2:	d3250513          	addi	a0,a0,-718 # ffffffffc020bce0 <commands+0x618>
ffffffffc0200fb6:	974ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fba:	10843583          	ld	a1,264(s0)
ffffffffc0200fbe:	0000b517          	auipc	a0,0xb
ffffffffc0200fc2:	d3a50513          	addi	a0,a0,-710 # ffffffffc020bcf8 <commands+0x630>
ffffffffc0200fc6:	964ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fca:	11043583          	ld	a1,272(s0)
ffffffffc0200fce:	0000b517          	auipc	a0,0xb
ffffffffc0200fd2:	d4250513          	addi	a0,a0,-702 # ffffffffc020bd10 <commands+0x648>
ffffffffc0200fd6:	954ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fda:	11843583          	ld	a1,280(s0)
ffffffffc0200fde:	6402                	ld	s0,0(sp)
ffffffffc0200fe0:	60a2                	ld	ra,8(sp)
ffffffffc0200fe2:	0000b517          	auipc	a0,0xb
ffffffffc0200fe6:	d3e50513          	addi	a0,a0,-706 # ffffffffc020bd20 <commands+0x658>
ffffffffc0200fea:	0141                	addi	sp,sp,16
ffffffffc0200fec:	93eff06f          	j	ffffffffc020012a <cprintf>

ffffffffc0200ff0 <interrupt_handler>:
ffffffffc0200ff0:	11853783          	ld	a5,280(a0)
ffffffffc0200ff4:	472d                	li	a4,11
ffffffffc0200ff6:	0786                	slli	a5,a5,0x1
ffffffffc0200ff8:	8385                	srli	a5,a5,0x1
ffffffffc0200ffa:	06f76c63          	bltu	a4,a5,ffffffffc0201072 <interrupt_handler+0x82>
ffffffffc0200ffe:	0000b717          	auipc	a4,0xb
ffffffffc0201002:	dda70713          	addi	a4,a4,-550 # ffffffffc020bdd8 <commands+0x710>
ffffffffc0201006:	078a                	slli	a5,a5,0x2
ffffffffc0201008:	97ba                	add	a5,a5,a4
ffffffffc020100a:	439c                	lw	a5,0(a5)
ffffffffc020100c:	97ba                	add	a5,a5,a4
ffffffffc020100e:	8782                	jr	a5
ffffffffc0201010:	0000b517          	auipc	a0,0xb
ffffffffc0201014:	d8850513          	addi	a0,a0,-632 # ffffffffc020bd98 <commands+0x6d0>
ffffffffc0201018:	912ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc020101c:	0000b517          	auipc	a0,0xb
ffffffffc0201020:	d5c50513          	addi	a0,a0,-676 # ffffffffc020bd78 <commands+0x6b0>
ffffffffc0201024:	906ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201028:	0000b517          	auipc	a0,0xb
ffffffffc020102c:	d1050513          	addi	a0,a0,-752 # ffffffffc020bd38 <commands+0x670>
ffffffffc0201030:	8faff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201034:	0000b517          	auipc	a0,0xb
ffffffffc0201038:	d2450513          	addi	a0,a0,-732 # ffffffffc020bd58 <commands+0x690>
ffffffffc020103c:	8eeff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201040:	1141                	addi	sp,sp,-16
ffffffffc0201042:	e406                	sd	ra,8(sp)
ffffffffc0201044:	a13ff0ef          	jal	ra,ffffffffc0200a56 <clock_set_next_event>
ffffffffc0201048:	00096717          	auipc	a4,0x96
ffffffffc020104c:	83870713          	addi	a4,a4,-1992 # ffffffffc0296880 <ticks>
ffffffffc0201050:	631c                	ld	a5,0(a4)
ffffffffc0201052:	0785                	addi	a5,a5,1
ffffffffc0201054:	e31c                	sd	a5,0(a4)
ffffffffc0201056:	2fe060ef          	jal	ra,ffffffffc0207354 <run_timer_list>
ffffffffc020105a:	a77ff0ef          	jal	ra,ffffffffc0200ad0 <cons_getc>
ffffffffc020105e:	60a2                	ld	ra,8(sp)
ffffffffc0201060:	0141                	addi	sp,sp,16
ffffffffc0201062:	5000706f          	j	ffffffffc0208562 <dev_stdin_write>
ffffffffc0201066:	0000b517          	auipc	a0,0xb
ffffffffc020106a:	d5250513          	addi	a0,a0,-686 # ffffffffc020bdb8 <commands+0x6f0>
ffffffffc020106e:	8bcff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201072:	bf31                	j	ffffffffc0200f8e <print_trapframe>

ffffffffc0201074 <exception_handler>:
ffffffffc0201074:	11853783          	ld	a5,280(a0)
ffffffffc0201078:	1141                	addi	sp,sp,-16
ffffffffc020107a:	e022                	sd	s0,0(sp)
ffffffffc020107c:	e406                	sd	ra,8(sp)
ffffffffc020107e:	473d                	li	a4,15
ffffffffc0201080:	842a                	mv	s0,a0
ffffffffc0201082:	0af76b63          	bltu	a4,a5,ffffffffc0201138 <exception_handler+0xc4>
ffffffffc0201086:	0000b717          	auipc	a4,0xb
ffffffffc020108a:	f1270713          	addi	a4,a4,-238 # ffffffffc020bf98 <commands+0x8d0>
ffffffffc020108e:	078a                	slli	a5,a5,0x2
ffffffffc0201090:	97ba                	add	a5,a5,a4
ffffffffc0201092:	439c                	lw	a5,0(a5)
ffffffffc0201094:	97ba                	add	a5,a5,a4
ffffffffc0201096:	8782                	jr	a5
ffffffffc0201098:	0000b517          	auipc	a0,0xb
ffffffffc020109c:	e5850513          	addi	a0,a0,-424 # ffffffffc020bef0 <commands+0x828>
ffffffffc02010a0:	88aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02010a4:	10843783          	ld	a5,264(s0)
ffffffffc02010a8:	60a2                	ld	ra,8(sp)
ffffffffc02010aa:	0791                	addi	a5,a5,4
ffffffffc02010ac:	10f43423          	sd	a5,264(s0)
ffffffffc02010b0:	6402                	ld	s0,0(sp)
ffffffffc02010b2:	0141                	addi	sp,sp,16
ffffffffc02010b4:	59e0606f          	j	ffffffffc0207652 <syscall>
ffffffffc02010b8:	0000b517          	auipc	a0,0xb
ffffffffc02010bc:	e5850513          	addi	a0,a0,-424 # ffffffffc020bf10 <commands+0x848>
ffffffffc02010c0:	6402                	ld	s0,0(sp)
ffffffffc02010c2:	60a2                	ld	ra,8(sp)
ffffffffc02010c4:	0141                	addi	sp,sp,16
ffffffffc02010c6:	864ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc02010ca:	0000b517          	auipc	a0,0xb
ffffffffc02010ce:	e6650513          	addi	a0,a0,-410 # ffffffffc020bf30 <commands+0x868>
ffffffffc02010d2:	b7fd                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc02010d4:	0000b517          	auipc	a0,0xb
ffffffffc02010d8:	e7c50513          	addi	a0,a0,-388 # ffffffffc020bf50 <commands+0x888>
ffffffffc02010dc:	b7d5                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc02010de:	0000b517          	auipc	a0,0xb
ffffffffc02010e2:	e8a50513          	addi	a0,a0,-374 # ffffffffc020bf68 <commands+0x8a0>
ffffffffc02010e6:	bfe9                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc02010e8:	0000b517          	auipc	a0,0xb
ffffffffc02010ec:	e9850513          	addi	a0,a0,-360 # ffffffffc020bf80 <commands+0x8b8>
ffffffffc02010f0:	bfc1                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc02010f2:	0000b517          	auipc	a0,0xb
ffffffffc02010f6:	d1650513          	addi	a0,a0,-746 # ffffffffc020be08 <commands+0x740>
ffffffffc02010fa:	b7d9                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc02010fc:	0000b517          	auipc	a0,0xb
ffffffffc0201100:	d2c50513          	addi	a0,a0,-724 # ffffffffc020be28 <commands+0x760>
ffffffffc0201104:	bf75                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc0201106:	0000b517          	auipc	a0,0xb
ffffffffc020110a:	d4250513          	addi	a0,a0,-702 # ffffffffc020be48 <commands+0x780>
ffffffffc020110e:	bf4d                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc0201110:	0000b517          	auipc	a0,0xb
ffffffffc0201114:	d5050513          	addi	a0,a0,-688 # ffffffffc020be60 <commands+0x798>
ffffffffc0201118:	b765                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc020111a:	0000b517          	auipc	a0,0xb
ffffffffc020111e:	d5650513          	addi	a0,a0,-682 # ffffffffc020be70 <commands+0x7a8>
ffffffffc0201122:	bf79                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc0201124:	0000b517          	auipc	a0,0xb
ffffffffc0201128:	d6c50513          	addi	a0,a0,-660 # ffffffffc020be90 <commands+0x7c8>
ffffffffc020112c:	bf51                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc020112e:	0000b517          	auipc	a0,0xb
ffffffffc0201132:	daa50513          	addi	a0,a0,-598 # ffffffffc020bed8 <commands+0x810>
ffffffffc0201136:	b769                	j	ffffffffc02010c0 <exception_handler+0x4c>
ffffffffc0201138:	8522                	mv	a0,s0
ffffffffc020113a:	6402                	ld	s0,0(sp)
ffffffffc020113c:	60a2                	ld	ra,8(sp)
ffffffffc020113e:	0141                	addi	sp,sp,16
ffffffffc0201140:	b5b9                	j	ffffffffc0200f8e <print_trapframe>
ffffffffc0201142:	0000b617          	auipc	a2,0xb
ffffffffc0201146:	d6660613          	addi	a2,a2,-666 # ffffffffc020bea8 <commands+0x7e0>
ffffffffc020114a:	0b100593          	li	a1,177
ffffffffc020114e:	0000b517          	auipc	a0,0xb
ffffffffc0201152:	d7250513          	addi	a0,a0,-654 # ffffffffc020bec0 <commands+0x7f8>
ffffffffc0201156:	8d8ff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020115a <trap>:
ffffffffc020115a:	1101                	addi	sp,sp,-32
ffffffffc020115c:	e822                	sd	s0,16(sp)
ffffffffc020115e:	00095417          	auipc	s0,0x95
ffffffffc0201162:	76240413          	addi	s0,s0,1890 # ffffffffc02968c0 <current>
ffffffffc0201166:	6018                	ld	a4,0(s0)
ffffffffc0201168:	ec06                	sd	ra,24(sp)
ffffffffc020116a:	e426                	sd	s1,8(sp)
ffffffffc020116c:	e04a                	sd	s2,0(sp)
ffffffffc020116e:	11853683          	ld	a3,280(a0)
ffffffffc0201172:	cf1d                	beqz	a4,ffffffffc02011b0 <trap+0x56>
ffffffffc0201174:	10053483          	ld	s1,256(a0)
ffffffffc0201178:	0a073903          	ld	s2,160(a4)
ffffffffc020117c:	f348                	sd	a0,160(a4)
ffffffffc020117e:	1004f493          	andi	s1,s1,256
ffffffffc0201182:	0206c463          	bltz	a3,ffffffffc02011aa <trap+0x50>
ffffffffc0201186:	eefff0ef          	jal	ra,ffffffffc0201074 <exception_handler>
ffffffffc020118a:	601c                	ld	a5,0(s0)
ffffffffc020118c:	0b27b023          	sd	s2,160(a5) # 400a0 <_binary_bin_swap_img_size+0x383a0>
ffffffffc0201190:	e499                	bnez	s1,ffffffffc020119e <trap+0x44>
ffffffffc0201192:	0b07a703          	lw	a4,176(a5)
ffffffffc0201196:	8b05                	andi	a4,a4,1
ffffffffc0201198:	e329                	bnez	a4,ffffffffc02011da <trap+0x80>
ffffffffc020119a:	6f9c                	ld	a5,24(a5)
ffffffffc020119c:	eb85                	bnez	a5,ffffffffc02011cc <trap+0x72>
ffffffffc020119e:	60e2                	ld	ra,24(sp)
ffffffffc02011a0:	6442                	ld	s0,16(sp)
ffffffffc02011a2:	64a2                	ld	s1,8(sp)
ffffffffc02011a4:	6902                	ld	s2,0(sp)
ffffffffc02011a6:	6105                	addi	sp,sp,32
ffffffffc02011a8:	8082                	ret
ffffffffc02011aa:	e47ff0ef          	jal	ra,ffffffffc0200ff0 <interrupt_handler>
ffffffffc02011ae:	bff1                	j	ffffffffc020118a <trap+0x30>
ffffffffc02011b0:	0006c863          	bltz	a3,ffffffffc02011c0 <trap+0x66>
ffffffffc02011b4:	6442                	ld	s0,16(sp)
ffffffffc02011b6:	60e2                	ld	ra,24(sp)
ffffffffc02011b8:	64a2                	ld	s1,8(sp)
ffffffffc02011ba:	6902                	ld	s2,0(sp)
ffffffffc02011bc:	6105                	addi	sp,sp,32
ffffffffc02011be:	bd5d                	j	ffffffffc0201074 <exception_handler>
ffffffffc02011c0:	6442                	ld	s0,16(sp)
ffffffffc02011c2:	60e2                	ld	ra,24(sp)
ffffffffc02011c4:	64a2                	ld	s1,8(sp)
ffffffffc02011c6:	6902                	ld	s2,0(sp)
ffffffffc02011c8:	6105                	addi	sp,sp,32
ffffffffc02011ca:	b51d                	j	ffffffffc0200ff0 <interrupt_handler>
ffffffffc02011cc:	6442                	ld	s0,16(sp)
ffffffffc02011ce:	60e2                	ld	ra,24(sp)
ffffffffc02011d0:	64a2                	ld	s1,8(sp)
ffffffffc02011d2:	6902                	ld	s2,0(sp)
ffffffffc02011d4:	6105                	addi	sp,sp,32
ffffffffc02011d6:	7730506f          	j	ffffffffc0207148 <schedule>
ffffffffc02011da:	555d                	li	a0,-9
ffffffffc02011dc:	6df040ef          	jal	ra,ffffffffc02060ba <do_exit>
ffffffffc02011e0:	601c                	ld	a5,0(s0)
ffffffffc02011e2:	bf65                	j	ffffffffc020119a <trap+0x40>

ffffffffc02011e4 <__alltraps>:
ffffffffc02011e4:	14011173          	csrrw	sp,sscratch,sp
ffffffffc02011e8:	00011463          	bnez	sp,ffffffffc02011f0 <__alltraps+0xc>
ffffffffc02011ec:	14002173          	csrr	sp,sscratch
ffffffffc02011f0:	712d                	addi	sp,sp,-288
ffffffffc02011f2:	e002                	sd	zero,0(sp)
ffffffffc02011f4:	e406                	sd	ra,8(sp)
ffffffffc02011f6:	ec0e                	sd	gp,24(sp)
ffffffffc02011f8:	f012                	sd	tp,32(sp)
ffffffffc02011fa:	f416                	sd	t0,40(sp)
ffffffffc02011fc:	f81a                	sd	t1,48(sp)
ffffffffc02011fe:	fc1e                	sd	t2,56(sp)
ffffffffc0201200:	e0a2                	sd	s0,64(sp)
ffffffffc0201202:	e4a6                	sd	s1,72(sp)
ffffffffc0201204:	e8aa                	sd	a0,80(sp)
ffffffffc0201206:	ecae                	sd	a1,88(sp)
ffffffffc0201208:	f0b2                	sd	a2,96(sp)
ffffffffc020120a:	f4b6                	sd	a3,104(sp)
ffffffffc020120c:	f8ba                	sd	a4,112(sp)
ffffffffc020120e:	fcbe                	sd	a5,120(sp)
ffffffffc0201210:	e142                	sd	a6,128(sp)
ffffffffc0201212:	e546                	sd	a7,136(sp)
ffffffffc0201214:	e94a                	sd	s2,144(sp)
ffffffffc0201216:	ed4e                	sd	s3,152(sp)
ffffffffc0201218:	f152                	sd	s4,160(sp)
ffffffffc020121a:	f556                	sd	s5,168(sp)
ffffffffc020121c:	f95a                	sd	s6,176(sp)
ffffffffc020121e:	fd5e                	sd	s7,184(sp)
ffffffffc0201220:	e1e2                	sd	s8,192(sp)
ffffffffc0201222:	e5e6                	sd	s9,200(sp)
ffffffffc0201224:	e9ea                	sd	s10,208(sp)
ffffffffc0201226:	edee                	sd	s11,216(sp)
ffffffffc0201228:	f1f2                	sd	t3,224(sp)
ffffffffc020122a:	f5f6                	sd	t4,232(sp)
ffffffffc020122c:	f9fa                	sd	t5,240(sp)
ffffffffc020122e:	fdfe                	sd	t6,248(sp)
ffffffffc0201230:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201234:	100024f3          	csrr	s1,sstatus
ffffffffc0201238:	14102973          	csrr	s2,sepc
ffffffffc020123c:	143029f3          	csrr	s3,stval
ffffffffc0201240:	14202a73          	csrr	s4,scause
ffffffffc0201244:	e822                	sd	s0,16(sp)
ffffffffc0201246:	e226                	sd	s1,256(sp)
ffffffffc0201248:	e64a                	sd	s2,264(sp)
ffffffffc020124a:	ea4e                	sd	s3,272(sp)
ffffffffc020124c:	ee52                	sd	s4,280(sp)
ffffffffc020124e:	850a                	mv	a0,sp
ffffffffc0201250:	f0bff0ef          	jal	ra,ffffffffc020115a <trap>

ffffffffc0201254 <__trapret>:
ffffffffc0201254:	6492                	ld	s1,256(sp)
ffffffffc0201256:	6932                	ld	s2,264(sp)
ffffffffc0201258:	1004f413          	andi	s0,s1,256
ffffffffc020125c:	e401                	bnez	s0,ffffffffc0201264 <__trapret+0x10>
ffffffffc020125e:	1200                	addi	s0,sp,288
ffffffffc0201260:	14041073          	csrw	sscratch,s0
ffffffffc0201264:	10049073          	csrw	sstatus,s1
ffffffffc0201268:	14191073          	csrw	sepc,s2
ffffffffc020126c:	60a2                	ld	ra,8(sp)
ffffffffc020126e:	61e2                	ld	gp,24(sp)
ffffffffc0201270:	7202                	ld	tp,32(sp)
ffffffffc0201272:	72a2                	ld	t0,40(sp)
ffffffffc0201274:	7342                	ld	t1,48(sp)
ffffffffc0201276:	73e2                	ld	t2,56(sp)
ffffffffc0201278:	6406                	ld	s0,64(sp)
ffffffffc020127a:	64a6                	ld	s1,72(sp)
ffffffffc020127c:	6546                	ld	a0,80(sp)
ffffffffc020127e:	65e6                	ld	a1,88(sp)
ffffffffc0201280:	7606                	ld	a2,96(sp)
ffffffffc0201282:	76a6                	ld	a3,104(sp)
ffffffffc0201284:	7746                	ld	a4,112(sp)
ffffffffc0201286:	77e6                	ld	a5,120(sp)
ffffffffc0201288:	680a                	ld	a6,128(sp)
ffffffffc020128a:	68aa                	ld	a7,136(sp)
ffffffffc020128c:	694a                	ld	s2,144(sp)
ffffffffc020128e:	69ea                	ld	s3,152(sp)
ffffffffc0201290:	7a0a                	ld	s4,160(sp)
ffffffffc0201292:	7aaa                	ld	s5,168(sp)
ffffffffc0201294:	7b4a                	ld	s6,176(sp)
ffffffffc0201296:	7bea                	ld	s7,184(sp)
ffffffffc0201298:	6c0e                	ld	s8,192(sp)
ffffffffc020129a:	6cae                	ld	s9,200(sp)
ffffffffc020129c:	6d4e                	ld	s10,208(sp)
ffffffffc020129e:	6dee                	ld	s11,216(sp)
ffffffffc02012a0:	7e0e                	ld	t3,224(sp)
ffffffffc02012a2:	7eae                	ld	t4,232(sp)
ffffffffc02012a4:	7f4e                	ld	t5,240(sp)
ffffffffc02012a6:	7fee                	ld	t6,248(sp)
ffffffffc02012a8:	6142                	ld	sp,16(sp)
ffffffffc02012aa:	10200073          	sret

ffffffffc02012ae <forkrets>:
ffffffffc02012ae:	812a                	mv	sp,a0
ffffffffc02012b0:	b755                	j	ffffffffc0201254 <__trapret>

ffffffffc02012b2 <pa2page.part.0>:
ffffffffc02012b2:	1141                	addi	sp,sp,-16
ffffffffc02012b4:	0000b617          	auipc	a2,0xb
ffffffffc02012b8:	d2460613          	addi	a2,a2,-732 # ffffffffc020bfd8 <commands+0x910>
ffffffffc02012bc:	06900593          	li	a1,105
ffffffffc02012c0:	0000b517          	auipc	a0,0xb
ffffffffc02012c4:	d3850513          	addi	a0,a0,-712 # ffffffffc020bff8 <commands+0x930>
ffffffffc02012c8:	e406                	sd	ra,8(sp)
ffffffffc02012ca:	f65fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02012ce <pte2page.part.0>:
ffffffffc02012ce:	1141                	addi	sp,sp,-16
ffffffffc02012d0:	0000b617          	auipc	a2,0xb
ffffffffc02012d4:	d3860613          	addi	a2,a2,-712 # ffffffffc020c008 <commands+0x940>
ffffffffc02012d8:	07f00593          	li	a1,127
ffffffffc02012dc:	0000b517          	auipc	a0,0xb
ffffffffc02012e0:	d1c50513          	addi	a0,a0,-740 # ffffffffc020bff8 <commands+0x930>
ffffffffc02012e4:	e406                	sd	ra,8(sp)
ffffffffc02012e6:	f49fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02012ea <alloc_pages>:
ffffffffc02012ea:	100027f3          	csrr	a5,sstatus
ffffffffc02012ee:	8b89                	andi	a5,a5,2
ffffffffc02012f0:	e799                	bnez	a5,ffffffffc02012fe <alloc_pages+0x14>
ffffffffc02012f2:	00095797          	auipc	a5,0x95
ffffffffc02012f6:	5b67b783          	ld	a5,1462(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc02012fa:	6f9c                	ld	a5,24(a5)
ffffffffc02012fc:	8782                	jr	a5
ffffffffc02012fe:	1141                	addi	sp,sp,-16
ffffffffc0201300:	e406                	sd	ra,8(sp)
ffffffffc0201302:	e022                	sd	s0,0(sp)
ffffffffc0201304:	842a                	mv	s0,a0
ffffffffc0201306:	a9bff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020130a:	00095797          	auipc	a5,0x95
ffffffffc020130e:	59e7b783          	ld	a5,1438(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201312:	6f9c                	ld	a5,24(a5)
ffffffffc0201314:	8522                	mv	a0,s0
ffffffffc0201316:	9782                	jalr	a5
ffffffffc0201318:	842a                	mv	s0,a0
ffffffffc020131a:	a81ff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020131e:	60a2                	ld	ra,8(sp)
ffffffffc0201320:	8522                	mv	a0,s0
ffffffffc0201322:	6402                	ld	s0,0(sp)
ffffffffc0201324:	0141                	addi	sp,sp,16
ffffffffc0201326:	8082                	ret

ffffffffc0201328 <free_pages>:
ffffffffc0201328:	100027f3          	csrr	a5,sstatus
ffffffffc020132c:	8b89                	andi	a5,a5,2
ffffffffc020132e:	e799                	bnez	a5,ffffffffc020133c <free_pages+0x14>
ffffffffc0201330:	00095797          	auipc	a5,0x95
ffffffffc0201334:	5787b783          	ld	a5,1400(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201338:	739c                	ld	a5,32(a5)
ffffffffc020133a:	8782                	jr	a5
ffffffffc020133c:	1101                	addi	sp,sp,-32
ffffffffc020133e:	ec06                	sd	ra,24(sp)
ffffffffc0201340:	e822                	sd	s0,16(sp)
ffffffffc0201342:	e426                	sd	s1,8(sp)
ffffffffc0201344:	842a                	mv	s0,a0
ffffffffc0201346:	84ae                	mv	s1,a1
ffffffffc0201348:	a59ff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020134c:	00095797          	auipc	a5,0x95
ffffffffc0201350:	55c7b783          	ld	a5,1372(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201354:	739c                	ld	a5,32(a5)
ffffffffc0201356:	85a6                	mv	a1,s1
ffffffffc0201358:	8522                	mv	a0,s0
ffffffffc020135a:	9782                	jalr	a5
ffffffffc020135c:	6442                	ld	s0,16(sp)
ffffffffc020135e:	60e2                	ld	ra,24(sp)
ffffffffc0201360:	64a2                	ld	s1,8(sp)
ffffffffc0201362:	6105                	addi	sp,sp,32
ffffffffc0201364:	a37ff06f          	j	ffffffffc0200d9a <intr_enable>

ffffffffc0201368 <nr_free_pages>:
ffffffffc0201368:	100027f3          	csrr	a5,sstatus
ffffffffc020136c:	8b89                	andi	a5,a5,2
ffffffffc020136e:	e799                	bnez	a5,ffffffffc020137c <nr_free_pages+0x14>
ffffffffc0201370:	00095797          	auipc	a5,0x95
ffffffffc0201374:	5387b783          	ld	a5,1336(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201378:	779c                	ld	a5,40(a5)
ffffffffc020137a:	8782                	jr	a5
ffffffffc020137c:	1141                	addi	sp,sp,-16
ffffffffc020137e:	e406                	sd	ra,8(sp)
ffffffffc0201380:	e022                	sd	s0,0(sp)
ffffffffc0201382:	a1fff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201386:	00095797          	auipc	a5,0x95
ffffffffc020138a:	5227b783          	ld	a5,1314(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc020138e:	779c                	ld	a5,40(a5)
ffffffffc0201390:	9782                	jalr	a5
ffffffffc0201392:	842a                	mv	s0,a0
ffffffffc0201394:	a07ff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201398:	60a2                	ld	ra,8(sp)
ffffffffc020139a:	8522                	mv	a0,s0
ffffffffc020139c:	6402                	ld	s0,0(sp)
ffffffffc020139e:	0141                	addi	sp,sp,16
ffffffffc02013a0:	8082                	ret

ffffffffc02013a2 <get_pte>:
ffffffffc02013a2:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02013a6:	1ff7f793          	andi	a5,a5,511
ffffffffc02013aa:	7139                	addi	sp,sp,-64
ffffffffc02013ac:	078e                	slli	a5,a5,0x3
ffffffffc02013ae:	f426                	sd	s1,40(sp)
ffffffffc02013b0:	00f504b3          	add	s1,a0,a5
ffffffffc02013b4:	6094                	ld	a3,0(s1)
ffffffffc02013b6:	f04a                	sd	s2,32(sp)
ffffffffc02013b8:	ec4e                	sd	s3,24(sp)
ffffffffc02013ba:	e852                	sd	s4,16(sp)
ffffffffc02013bc:	fc06                	sd	ra,56(sp)
ffffffffc02013be:	f822                	sd	s0,48(sp)
ffffffffc02013c0:	e456                	sd	s5,8(sp)
ffffffffc02013c2:	e05a                	sd	s6,0(sp)
ffffffffc02013c4:	0016f793          	andi	a5,a3,1
ffffffffc02013c8:	892e                	mv	s2,a1
ffffffffc02013ca:	8a32                	mv	s4,a2
ffffffffc02013cc:	00095997          	auipc	s3,0x95
ffffffffc02013d0:	4cc98993          	addi	s3,s3,1228 # ffffffffc0296898 <npage>
ffffffffc02013d4:	efbd                	bnez	a5,ffffffffc0201452 <get_pte+0xb0>
ffffffffc02013d6:	14060c63          	beqz	a2,ffffffffc020152e <get_pte+0x18c>
ffffffffc02013da:	100027f3          	csrr	a5,sstatus
ffffffffc02013de:	8b89                	andi	a5,a5,2
ffffffffc02013e0:	14079963          	bnez	a5,ffffffffc0201532 <get_pte+0x190>
ffffffffc02013e4:	00095797          	auipc	a5,0x95
ffffffffc02013e8:	4c47b783          	ld	a5,1220(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc02013ec:	6f9c                	ld	a5,24(a5)
ffffffffc02013ee:	4505                	li	a0,1
ffffffffc02013f0:	9782                	jalr	a5
ffffffffc02013f2:	842a                	mv	s0,a0
ffffffffc02013f4:	12040d63          	beqz	s0,ffffffffc020152e <get_pte+0x18c>
ffffffffc02013f8:	00095b17          	auipc	s6,0x95
ffffffffc02013fc:	4a8b0b13          	addi	s6,s6,1192 # ffffffffc02968a0 <pages>
ffffffffc0201400:	000b3503          	ld	a0,0(s6)
ffffffffc0201404:	00080ab7          	lui	s5,0x80
ffffffffc0201408:	00095997          	auipc	s3,0x95
ffffffffc020140c:	49098993          	addi	s3,s3,1168 # ffffffffc0296898 <npage>
ffffffffc0201410:	40a40533          	sub	a0,s0,a0
ffffffffc0201414:	8519                	srai	a0,a0,0x6
ffffffffc0201416:	9556                	add	a0,a0,s5
ffffffffc0201418:	0009b703          	ld	a4,0(s3)
ffffffffc020141c:	00c51793          	slli	a5,a0,0xc
ffffffffc0201420:	4685                	li	a3,1
ffffffffc0201422:	c014                	sw	a3,0(s0)
ffffffffc0201424:	83b1                	srli	a5,a5,0xc
ffffffffc0201426:	0532                	slli	a0,a0,0xc
ffffffffc0201428:	16e7f763          	bgeu	a5,a4,ffffffffc0201596 <get_pte+0x1f4>
ffffffffc020142c:	00095797          	auipc	a5,0x95
ffffffffc0201430:	4847b783          	ld	a5,1156(a5) # ffffffffc02968b0 <va_pa_offset>
ffffffffc0201434:	6605                	lui	a2,0x1
ffffffffc0201436:	4581                	li	a1,0
ffffffffc0201438:	953e                	add	a0,a0,a5
ffffffffc020143a:	2e7090ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc020143e:	000b3683          	ld	a3,0(s6)
ffffffffc0201442:	40d406b3          	sub	a3,s0,a3
ffffffffc0201446:	8699                	srai	a3,a3,0x6
ffffffffc0201448:	96d6                	add	a3,a3,s5
ffffffffc020144a:	06aa                	slli	a3,a3,0xa
ffffffffc020144c:	0116e693          	ori	a3,a3,17
ffffffffc0201450:	e094                	sd	a3,0(s1)
ffffffffc0201452:	77fd                	lui	a5,0xfffff
ffffffffc0201454:	068a                	slli	a3,a3,0x2
ffffffffc0201456:	0009b703          	ld	a4,0(s3)
ffffffffc020145a:	8efd                	and	a3,a3,a5
ffffffffc020145c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201460:	10e7ff63          	bgeu	a5,a4,ffffffffc020157e <get_pte+0x1dc>
ffffffffc0201464:	00095a97          	auipc	s5,0x95
ffffffffc0201468:	44ca8a93          	addi	s5,s5,1100 # ffffffffc02968b0 <va_pa_offset>
ffffffffc020146c:	000ab403          	ld	s0,0(s5)
ffffffffc0201470:	01595793          	srli	a5,s2,0x15
ffffffffc0201474:	1ff7f793          	andi	a5,a5,511
ffffffffc0201478:	96a2                	add	a3,a3,s0
ffffffffc020147a:	00379413          	slli	s0,a5,0x3
ffffffffc020147e:	9436                	add	s0,s0,a3
ffffffffc0201480:	6014                	ld	a3,0(s0)
ffffffffc0201482:	0016f793          	andi	a5,a3,1
ffffffffc0201486:	ebad                	bnez	a5,ffffffffc02014f8 <get_pte+0x156>
ffffffffc0201488:	0a0a0363          	beqz	s4,ffffffffc020152e <get_pte+0x18c>
ffffffffc020148c:	100027f3          	csrr	a5,sstatus
ffffffffc0201490:	8b89                	andi	a5,a5,2
ffffffffc0201492:	efcd                	bnez	a5,ffffffffc020154c <get_pte+0x1aa>
ffffffffc0201494:	00095797          	auipc	a5,0x95
ffffffffc0201498:	4147b783          	ld	a5,1044(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc020149c:	6f9c                	ld	a5,24(a5)
ffffffffc020149e:	4505                	li	a0,1
ffffffffc02014a0:	9782                	jalr	a5
ffffffffc02014a2:	84aa                	mv	s1,a0
ffffffffc02014a4:	c4c9                	beqz	s1,ffffffffc020152e <get_pte+0x18c>
ffffffffc02014a6:	00095b17          	auipc	s6,0x95
ffffffffc02014aa:	3fab0b13          	addi	s6,s6,1018 # ffffffffc02968a0 <pages>
ffffffffc02014ae:	000b3503          	ld	a0,0(s6)
ffffffffc02014b2:	00080a37          	lui	s4,0x80
ffffffffc02014b6:	0009b703          	ld	a4,0(s3)
ffffffffc02014ba:	40a48533          	sub	a0,s1,a0
ffffffffc02014be:	8519                	srai	a0,a0,0x6
ffffffffc02014c0:	9552                	add	a0,a0,s4
ffffffffc02014c2:	00c51793          	slli	a5,a0,0xc
ffffffffc02014c6:	4685                	li	a3,1
ffffffffc02014c8:	c094                	sw	a3,0(s1)
ffffffffc02014ca:	83b1                	srli	a5,a5,0xc
ffffffffc02014cc:	0532                	slli	a0,a0,0xc
ffffffffc02014ce:	0ee7f163          	bgeu	a5,a4,ffffffffc02015b0 <get_pte+0x20e>
ffffffffc02014d2:	000ab783          	ld	a5,0(s5)
ffffffffc02014d6:	6605                	lui	a2,0x1
ffffffffc02014d8:	4581                	li	a1,0
ffffffffc02014da:	953e                	add	a0,a0,a5
ffffffffc02014dc:	245090ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc02014e0:	000b3683          	ld	a3,0(s6)
ffffffffc02014e4:	40d486b3          	sub	a3,s1,a3
ffffffffc02014e8:	8699                	srai	a3,a3,0x6
ffffffffc02014ea:	96d2                	add	a3,a3,s4
ffffffffc02014ec:	06aa                	slli	a3,a3,0xa
ffffffffc02014ee:	0116e693          	ori	a3,a3,17
ffffffffc02014f2:	e014                	sd	a3,0(s0)
ffffffffc02014f4:	0009b703          	ld	a4,0(s3)
ffffffffc02014f8:	068a                	slli	a3,a3,0x2
ffffffffc02014fa:	757d                	lui	a0,0xfffff
ffffffffc02014fc:	8ee9                	and	a3,a3,a0
ffffffffc02014fe:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201502:	06e7f263          	bgeu	a5,a4,ffffffffc0201566 <get_pte+0x1c4>
ffffffffc0201506:	000ab503          	ld	a0,0(s5)
ffffffffc020150a:	00c95913          	srli	s2,s2,0xc
ffffffffc020150e:	1ff97913          	andi	s2,s2,511
ffffffffc0201512:	96aa                	add	a3,a3,a0
ffffffffc0201514:	00391513          	slli	a0,s2,0x3
ffffffffc0201518:	9536                	add	a0,a0,a3
ffffffffc020151a:	70e2                	ld	ra,56(sp)
ffffffffc020151c:	7442                	ld	s0,48(sp)
ffffffffc020151e:	74a2                	ld	s1,40(sp)
ffffffffc0201520:	7902                	ld	s2,32(sp)
ffffffffc0201522:	69e2                	ld	s3,24(sp)
ffffffffc0201524:	6a42                	ld	s4,16(sp)
ffffffffc0201526:	6aa2                	ld	s5,8(sp)
ffffffffc0201528:	6b02                	ld	s6,0(sp)
ffffffffc020152a:	6121                	addi	sp,sp,64
ffffffffc020152c:	8082                	ret
ffffffffc020152e:	4501                	li	a0,0
ffffffffc0201530:	b7ed                	j	ffffffffc020151a <get_pte+0x178>
ffffffffc0201532:	86fff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201536:	00095797          	auipc	a5,0x95
ffffffffc020153a:	3727b783          	ld	a5,882(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc020153e:	6f9c                	ld	a5,24(a5)
ffffffffc0201540:	4505                	li	a0,1
ffffffffc0201542:	9782                	jalr	a5
ffffffffc0201544:	842a                	mv	s0,a0
ffffffffc0201546:	855ff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020154a:	b56d                	j	ffffffffc02013f4 <get_pte+0x52>
ffffffffc020154c:	855ff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201550:	00095797          	auipc	a5,0x95
ffffffffc0201554:	3587b783          	ld	a5,856(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201558:	6f9c                	ld	a5,24(a5)
ffffffffc020155a:	4505                	li	a0,1
ffffffffc020155c:	9782                	jalr	a5
ffffffffc020155e:	84aa                	mv	s1,a0
ffffffffc0201560:	83bff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201564:	b781                	j	ffffffffc02014a4 <get_pte+0x102>
ffffffffc0201566:	0000b617          	auipc	a2,0xb
ffffffffc020156a:	aca60613          	addi	a2,a2,-1334 # ffffffffc020c030 <commands+0x968>
ffffffffc020156e:	13200593          	li	a1,306
ffffffffc0201572:	0000b517          	auipc	a0,0xb
ffffffffc0201576:	ae650513          	addi	a0,a0,-1306 # ffffffffc020c058 <commands+0x990>
ffffffffc020157a:	cb5fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020157e:	0000b617          	auipc	a2,0xb
ffffffffc0201582:	ab260613          	addi	a2,a2,-1358 # ffffffffc020c030 <commands+0x968>
ffffffffc0201586:	12500593          	li	a1,293
ffffffffc020158a:	0000b517          	auipc	a0,0xb
ffffffffc020158e:	ace50513          	addi	a0,a0,-1330 # ffffffffc020c058 <commands+0x990>
ffffffffc0201592:	c9dfe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201596:	86aa                	mv	a3,a0
ffffffffc0201598:	0000b617          	auipc	a2,0xb
ffffffffc020159c:	a9860613          	addi	a2,a2,-1384 # ffffffffc020c030 <commands+0x968>
ffffffffc02015a0:	12100593          	li	a1,289
ffffffffc02015a4:	0000b517          	auipc	a0,0xb
ffffffffc02015a8:	ab450513          	addi	a0,a0,-1356 # ffffffffc020c058 <commands+0x990>
ffffffffc02015ac:	c83fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02015b0:	86aa                	mv	a3,a0
ffffffffc02015b2:	0000b617          	auipc	a2,0xb
ffffffffc02015b6:	a7e60613          	addi	a2,a2,-1410 # ffffffffc020c030 <commands+0x968>
ffffffffc02015ba:	12f00593          	li	a1,303
ffffffffc02015be:	0000b517          	auipc	a0,0xb
ffffffffc02015c2:	a9a50513          	addi	a0,a0,-1382 # ffffffffc020c058 <commands+0x990>
ffffffffc02015c6:	c69fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02015ca <boot_map_segment>:
ffffffffc02015ca:	6785                	lui	a5,0x1
ffffffffc02015cc:	7139                	addi	sp,sp,-64
ffffffffc02015ce:	00d5c833          	xor	a6,a1,a3
ffffffffc02015d2:	17fd                	addi	a5,a5,-1
ffffffffc02015d4:	fc06                	sd	ra,56(sp)
ffffffffc02015d6:	f822                	sd	s0,48(sp)
ffffffffc02015d8:	f426                	sd	s1,40(sp)
ffffffffc02015da:	f04a                	sd	s2,32(sp)
ffffffffc02015dc:	ec4e                	sd	s3,24(sp)
ffffffffc02015de:	e852                	sd	s4,16(sp)
ffffffffc02015e0:	e456                	sd	s5,8(sp)
ffffffffc02015e2:	00f87833          	and	a6,a6,a5
ffffffffc02015e6:	08081563          	bnez	a6,ffffffffc0201670 <boot_map_segment+0xa6>
ffffffffc02015ea:	00f5f4b3          	and	s1,a1,a5
ffffffffc02015ee:	963e                	add	a2,a2,a5
ffffffffc02015f0:	94b2                	add	s1,s1,a2
ffffffffc02015f2:	797d                	lui	s2,0xfffff
ffffffffc02015f4:	80b1                	srli	s1,s1,0xc
ffffffffc02015f6:	0125f5b3          	and	a1,a1,s2
ffffffffc02015fa:	0126f6b3          	and	a3,a3,s2
ffffffffc02015fe:	c0a1                	beqz	s1,ffffffffc020163e <boot_map_segment+0x74>
ffffffffc0201600:	00176713          	ori	a4,a4,1
ffffffffc0201604:	04b2                	slli	s1,s1,0xc
ffffffffc0201606:	02071993          	slli	s3,a4,0x20
ffffffffc020160a:	8a2a                	mv	s4,a0
ffffffffc020160c:	842e                	mv	s0,a1
ffffffffc020160e:	94ae                	add	s1,s1,a1
ffffffffc0201610:	40b68933          	sub	s2,a3,a1
ffffffffc0201614:	0209d993          	srli	s3,s3,0x20
ffffffffc0201618:	6a85                	lui	s5,0x1
ffffffffc020161a:	4605                	li	a2,1
ffffffffc020161c:	85a2                	mv	a1,s0
ffffffffc020161e:	8552                	mv	a0,s4
ffffffffc0201620:	d83ff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0201624:	008907b3          	add	a5,s2,s0
ffffffffc0201628:	c505                	beqz	a0,ffffffffc0201650 <boot_map_segment+0x86>
ffffffffc020162a:	83b1                	srli	a5,a5,0xc
ffffffffc020162c:	07aa                	slli	a5,a5,0xa
ffffffffc020162e:	0137e7b3          	or	a5,a5,s3
ffffffffc0201632:	0017e793          	ori	a5,a5,1
ffffffffc0201636:	e11c                	sd	a5,0(a0)
ffffffffc0201638:	9456                	add	s0,s0,s5
ffffffffc020163a:	fe8490e3          	bne	s1,s0,ffffffffc020161a <boot_map_segment+0x50>
ffffffffc020163e:	70e2                	ld	ra,56(sp)
ffffffffc0201640:	7442                	ld	s0,48(sp)
ffffffffc0201642:	74a2                	ld	s1,40(sp)
ffffffffc0201644:	7902                	ld	s2,32(sp)
ffffffffc0201646:	69e2                	ld	s3,24(sp)
ffffffffc0201648:	6a42                	ld	s4,16(sp)
ffffffffc020164a:	6aa2                	ld	s5,8(sp)
ffffffffc020164c:	6121                	addi	sp,sp,64
ffffffffc020164e:	8082                	ret
ffffffffc0201650:	0000b697          	auipc	a3,0xb
ffffffffc0201654:	a3068693          	addi	a3,a3,-1488 # ffffffffc020c080 <commands+0x9b8>
ffffffffc0201658:	0000a617          	auipc	a2,0xa
ffffffffc020165c:	2c060613          	addi	a2,a2,704 # ffffffffc020b918 <commands+0x250>
ffffffffc0201660:	09c00593          	li	a1,156
ffffffffc0201664:	0000b517          	auipc	a0,0xb
ffffffffc0201668:	9f450513          	addi	a0,a0,-1548 # ffffffffc020c058 <commands+0x990>
ffffffffc020166c:	bc3fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201670:	0000b697          	auipc	a3,0xb
ffffffffc0201674:	9f868693          	addi	a3,a3,-1544 # ffffffffc020c068 <commands+0x9a0>
ffffffffc0201678:	0000a617          	auipc	a2,0xa
ffffffffc020167c:	2a060613          	addi	a2,a2,672 # ffffffffc020b918 <commands+0x250>
ffffffffc0201680:	09500593          	li	a1,149
ffffffffc0201684:	0000b517          	auipc	a0,0xb
ffffffffc0201688:	9d450513          	addi	a0,a0,-1580 # ffffffffc020c058 <commands+0x990>
ffffffffc020168c:	ba3fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201690 <get_page>:
ffffffffc0201690:	1141                	addi	sp,sp,-16
ffffffffc0201692:	e022                	sd	s0,0(sp)
ffffffffc0201694:	8432                	mv	s0,a2
ffffffffc0201696:	4601                	li	a2,0
ffffffffc0201698:	e406                	sd	ra,8(sp)
ffffffffc020169a:	d09ff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc020169e:	c011                	beqz	s0,ffffffffc02016a2 <get_page+0x12>
ffffffffc02016a0:	e008                	sd	a0,0(s0)
ffffffffc02016a2:	c511                	beqz	a0,ffffffffc02016ae <get_page+0x1e>
ffffffffc02016a4:	611c                	ld	a5,0(a0)
ffffffffc02016a6:	4501                	li	a0,0
ffffffffc02016a8:	0017f713          	andi	a4,a5,1
ffffffffc02016ac:	e709                	bnez	a4,ffffffffc02016b6 <get_page+0x26>
ffffffffc02016ae:	60a2                	ld	ra,8(sp)
ffffffffc02016b0:	6402                	ld	s0,0(sp)
ffffffffc02016b2:	0141                	addi	sp,sp,16
ffffffffc02016b4:	8082                	ret
ffffffffc02016b6:	078a                	slli	a5,a5,0x2
ffffffffc02016b8:	83b1                	srli	a5,a5,0xc
ffffffffc02016ba:	00095717          	auipc	a4,0x95
ffffffffc02016be:	1de73703          	ld	a4,478(a4) # ffffffffc0296898 <npage>
ffffffffc02016c2:	00e7ff63          	bgeu	a5,a4,ffffffffc02016e0 <get_page+0x50>
ffffffffc02016c6:	60a2                	ld	ra,8(sp)
ffffffffc02016c8:	6402                	ld	s0,0(sp)
ffffffffc02016ca:	fff80537          	lui	a0,0xfff80
ffffffffc02016ce:	97aa                	add	a5,a5,a0
ffffffffc02016d0:	079a                	slli	a5,a5,0x6
ffffffffc02016d2:	00095517          	auipc	a0,0x95
ffffffffc02016d6:	1ce53503          	ld	a0,462(a0) # ffffffffc02968a0 <pages>
ffffffffc02016da:	953e                	add	a0,a0,a5
ffffffffc02016dc:	0141                	addi	sp,sp,16
ffffffffc02016de:	8082                	ret
ffffffffc02016e0:	bd3ff0ef          	jal	ra,ffffffffc02012b2 <pa2page.part.0>

ffffffffc02016e4 <unmap_range>:
ffffffffc02016e4:	7159                	addi	sp,sp,-112
ffffffffc02016e6:	00c5e7b3          	or	a5,a1,a2
ffffffffc02016ea:	f486                	sd	ra,104(sp)
ffffffffc02016ec:	f0a2                	sd	s0,96(sp)
ffffffffc02016ee:	eca6                	sd	s1,88(sp)
ffffffffc02016f0:	e8ca                	sd	s2,80(sp)
ffffffffc02016f2:	e4ce                	sd	s3,72(sp)
ffffffffc02016f4:	e0d2                	sd	s4,64(sp)
ffffffffc02016f6:	fc56                	sd	s5,56(sp)
ffffffffc02016f8:	f85a                	sd	s6,48(sp)
ffffffffc02016fa:	f45e                	sd	s7,40(sp)
ffffffffc02016fc:	f062                	sd	s8,32(sp)
ffffffffc02016fe:	ec66                	sd	s9,24(sp)
ffffffffc0201700:	e86a                	sd	s10,16(sp)
ffffffffc0201702:	17d2                	slli	a5,a5,0x34
ffffffffc0201704:	e3ed                	bnez	a5,ffffffffc02017e6 <unmap_range+0x102>
ffffffffc0201706:	002007b7          	lui	a5,0x200
ffffffffc020170a:	842e                	mv	s0,a1
ffffffffc020170c:	0ef5ed63          	bltu	a1,a5,ffffffffc0201806 <unmap_range+0x122>
ffffffffc0201710:	8932                	mv	s2,a2
ffffffffc0201712:	0ec5fa63          	bgeu	a1,a2,ffffffffc0201806 <unmap_range+0x122>
ffffffffc0201716:	4785                	li	a5,1
ffffffffc0201718:	07fe                	slli	a5,a5,0x1f
ffffffffc020171a:	0ec7e663          	bltu	a5,a2,ffffffffc0201806 <unmap_range+0x122>
ffffffffc020171e:	89aa                	mv	s3,a0
ffffffffc0201720:	6a05                	lui	s4,0x1
ffffffffc0201722:	00095c97          	auipc	s9,0x95
ffffffffc0201726:	176c8c93          	addi	s9,s9,374 # ffffffffc0296898 <npage>
ffffffffc020172a:	00095c17          	auipc	s8,0x95
ffffffffc020172e:	176c0c13          	addi	s8,s8,374 # ffffffffc02968a0 <pages>
ffffffffc0201732:	fff80bb7          	lui	s7,0xfff80
ffffffffc0201736:	00095d17          	auipc	s10,0x95
ffffffffc020173a:	172d0d13          	addi	s10,s10,370 # ffffffffc02968a8 <pmm_manager>
ffffffffc020173e:	00200b37          	lui	s6,0x200
ffffffffc0201742:	ffe00ab7          	lui	s5,0xffe00
ffffffffc0201746:	4601                	li	a2,0
ffffffffc0201748:	85a2                	mv	a1,s0
ffffffffc020174a:	854e                	mv	a0,s3
ffffffffc020174c:	c57ff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0201750:	84aa                	mv	s1,a0
ffffffffc0201752:	cd29                	beqz	a0,ffffffffc02017ac <unmap_range+0xc8>
ffffffffc0201754:	611c                	ld	a5,0(a0)
ffffffffc0201756:	e395                	bnez	a5,ffffffffc020177a <unmap_range+0x96>
ffffffffc0201758:	9452                	add	s0,s0,s4
ffffffffc020175a:	ff2466e3          	bltu	s0,s2,ffffffffc0201746 <unmap_range+0x62>
ffffffffc020175e:	70a6                	ld	ra,104(sp)
ffffffffc0201760:	7406                	ld	s0,96(sp)
ffffffffc0201762:	64e6                	ld	s1,88(sp)
ffffffffc0201764:	6946                	ld	s2,80(sp)
ffffffffc0201766:	69a6                	ld	s3,72(sp)
ffffffffc0201768:	6a06                	ld	s4,64(sp)
ffffffffc020176a:	7ae2                	ld	s5,56(sp)
ffffffffc020176c:	7b42                	ld	s6,48(sp)
ffffffffc020176e:	7ba2                	ld	s7,40(sp)
ffffffffc0201770:	7c02                	ld	s8,32(sp)
ffffffffc0201772:	6ce2                	ld	s9,24(sp)
ffffffffc0201774:	6d42                	ld	s10,16(sp)
ffffffffc0201776:	6165                	addi	sp,sp,112
ffffffffc0201778:	8082                	ret
ffffffffc020177a:	0017f713          	andi	a4,a5,1
ffffffffc020177e:	df69                	beqz	a4,ffffffffc0201758 <unmap_range+0x74>
ffffffffc0201780:	000cb703          	ld	a4,0(s9)
ffffffffc0201784:	078a                	slli	a5,a5,0x2
ffffffffc0201786:	83b1                	srli	a5,a5,0xc
ffffffffc0201788:	08e7ff63          	bgeu	a5,a4,ffffffffc0201826 <unmap_range+0x142>
ffffffffc020178c:	000c3503          	ld	a0,0(s8)
ffffffffc0201790:	97de                	add	a5,a5,s7
ffffffffc0201792:	079a                	slli	a5,a5,0x6
ffffffffc0201794:	953e                	add	a0,a0,a5
ffffffffc0201796:	411c                	lw	a5,0(a0)
ffffffffc0201798:	fff7871b          	addiw	a4,a5,-1
ffffffffc020179c:	c118                	sw	a4,0(a0)
ffffffffc020179e:	cf11                	beqz	a4,ffffffffc02017ba <unmap_range+0xd6>
ffffffffc02017a0:	0004b023          	sd	zero,0(s1)
ffffffffc02017a4:	12040073          	sfence.vma	s0
ffffffffc02017a8:	9452                	add	s0,s0,s4
ffffffffc02017aa:	bf45                	j	ffffffffc020175a <unmap_range+0x76>
ffffffffc02017ac:	945a                	add	s0,s0,s6
ffffffffc02017ae:	01547433          	and	s0,s0,s5
ffffffffc02017b2:	d455                	beqz	s0,ffffffffc020175e <unmap_range+0x7a>
ffffffffc02017b4:	f92469e3          	bltu	s0,s2,ffffffffc0201746 <unmap_range+0x62>
ffffffffc02017b8:	b75d                	j	ffffffffc020175e <unmap_range+0x7a>
ffffffffc02017ba:	100027f3          	csrr	a5,sstatus
ffffffffc02017be:	8b89                	andi	a5,a5,2
ffffffffc02017c0:	e799                	bnez	a5,ffffffffc02017ce <unmap_range+0xea>
ffffffffc02017c2:	000d3783          	ld	a5,0(s10)
ffffffffc02017c6:	4585                	li	a1,1
ffffffffc02017c8:	739c                	ld	a5,32(a5)
ffffffffc02017ca:	9782                	jalr	a5
ffffffffc02017cc:	bfd1                	j	ffffffffc02017a0 <unmap_range+0xbc>
ffffffffc02017ce:	e42a                	sd	a0,8(sp)
ffffffffc02017d0:	dd0ff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02017d4:	000d3783          	ld	a5,0(s10)
ffffffffc02017d8:	6522                	ld	a0,8(sp)
ffffffffc02017da:	4585                	li	a1,1
ffffffffc02017dc:	739c                	ld	a5,32(a5)
ffffffffc02017de:	9782                	jalr	a5
ffffffffc02017e0:	dbaff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02017e4:	bf75                	j	ffffffffc02017a0 <unmap_range+0xbc>
ffffffffc02017e6:	0000b697          	auipc	a3,0xb
ffffffffc02017ea:	8aa68693          	addi	a3,a3,-1878 # ffffffffc020c090 <commands+0x9c8>
ffffffffc02017ee:	0000a617          	auipc	a2,0xa
ffffffffc02017f2:	12a60613          	addi	a2,a2,298 # ffffffffc020b918 <commands+0x250>
ffffffffc02017f6:	15a00593          	li	a1,346
ffffffffc02017fa:	0000b517          	auipc	a0,0xb
ffffffffc02017fe:	85e50513          	addi	a0,a0,-1954 # ffffffffc020c058 <commands+0x990>
ffffffffc0201802:	a2dfe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201806:	0000b697          	auipc	a3,0xb
ffffffffc020180a:	8ba68693          	addi	a3,a3,-1862 # ffffffffc020c0c0 <commands+0x9f8>
ffffffffc020180e:	0000a617          	auipc	a2,0xa
ffffffffc0201812:	10a60613          	addi	a2,a2,266 # ffffffffc020b918 <commands+0x250>
ffffffffc0201816:	15b00593          	li	a1,347
ffffffffc020181a:	0000b517          	auipc	a0,0xb
ffffffffc020181e:	83e50513          	addi	a0,a0,-1986 # ffffffffc020c058 <commands+0x990>
ffffffffc0201822:	a0dfe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201826:	a8dff0ef          	jal	ra,ffffffffc02012b2 <pa2page.part.0>

ffffffffc020182a <exit_range>:
ffffffffc020182a:	7119                	addi	sp,sp,-128
ffffffffc020182c:	00c5e7b3          	or	a5,a1,a2
ffffffffc0201830:	fc86                	sd	ra,120(sp)
ffffffffc0201832:	f8a2                	sd	s0,112(sp)
ffffffffc0201834:	f4a6                	sd	s1,104(sp)
ffffffffc0201836:	f0ca                	sd	s2,96(sp)
ffffffffc0201838:	ecce                	sd	s3,88(sp)
ffffffffc020183a:	e8d2                	sd	s4,80(sp)
ffffffffc020183c:	e4d6                	sd	s5,72(sp)
ffffffffc020183e:	e0da                	sd	s6,64(sp)
ffffffffc0201840:	fc5e                	sd	s7,56(sp)
ffffffffc0201842:	f862                	sd	s8,48(sp)
ffffffffc0201844:	f466                	sd	s9,40(sp)
ffffffffc0201846:	f06a                	sd	s10,32(sp)
ffffffffc0201848:	ec6e                	sd	s11,24(sp)
ffffffffc020184a:	17d2                	slli	a5,a5,0x34
ffffffffc020184c:	20079a63          	bnez	a5,ffffffffc0201a60 <exit_range+0x236>
ffffffffc0201850:	002007b7          	lui	a5,0x200
ffffffffc0201854:	24f5e463          	bltu	a1,a5,ffffffffc0201a9c <exit_range+0x272>
ffffffffc0201858:	8ab2                	mv	s5,a2
ffffffffc020185a:	24c5f163          	bgeu	a1,a2,ffffffffc0201a9c <exit_range+0x272>
ffffffffc020185e:	4785                	li	a5,1
ffffffffc0201860:	07fe                	slli	a5,a5,0x1f
ffffffffc0201862:	22c7ed63          	bltu	a5,a2,ffffffffc0201a9c <exit_range+0x272>
ffffffffc0201866:	c00009b7          	lui	s3,0xc0000
ffffffffc020186a:	0135f9b3          	and	s3,a1,s3
ffffffffc020186e:	ffe00937          	lui	s2,0xffe00
ffffffffc0201872:	400007b7          	lui	a5,0x40000
ffffffffc0201876:	5cfd                	li	s9,-1
ffffffffc0201878:	8c2a                	mv	s8,a0
ffffffffc020187a:	0125f933          	and	s2,a1,s2
ffffffffc020187e:	99be                	add	s3,s3,a5
ffffffffc0201880:	00095d17          	auipc	s10,0x95
ffffffffc0201884:	018d0d13          	addi	s10,s10,24 # ffffffffc0296898 <npage>
ffffffffc0201888:	00ccdc93          	srli	s9,s9,0xc
ffffffffc020188c:	00095717          	auipc	a4,0x95
ffffffffc0201890:	01470713          	addi	a4,a4,20 # ffffffffc02968a0 <pages>
ffffffffc0201894:	00095d97          	auipc	s11,0x95
ffffffffc0201898:	014d8d93          	addi	s11,s11,20 # ffffffffc02968a8 <pmm_manager>
ffffffffc020189c:	c0000437          	lui	s0,0xc0000
ffffffffc02018a0:	944e                	add	s0,s0,s3
ffffffffc02018a2:	8079                	srli	s0,s0,0x1e
ffffffffc02018a4:	1ff47413          	andi	s0,s0,511
ffffffffc02018a8:	040e                	slli	s0,s0,0x3
ffffffffc02018aa:	9462                	add	s0,s0,s8
ffffffffc02018ac:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc02018b0:	001a7793          	andi	a5,s4,1
ffffffffc02018b4:	eb99                	bnez	a5,ffffffffc02018ca <exit_range+0xa0>
ffffffffc02018b6:	12098463          	beqz	s3,ffffffffc02019de <exit_range+0x1b4>
ffffffffc02018ba:	400007b7          	lui	a5,0x40000
ffffffffc02018be:	97ce                	add	a5,a5,s3
ffffffffc02018c0:	894e                	mv	s2,s3
ffffffffc02018c2:	1159fe63          	bgeu	s3,s5,ffffffffc02019de <exit_range+0x1b4>
ffffffffc02018c6:	89be                	mv	s3,a5
ffffffffc02018c8:	bfd1                	j	ffffffffc020189c <exit_range+0x72>
ffffffffc02018ca:	000d3783          	ld	a5,0(s10)
ffffffffc02018ce:	0a0a                	slli	s4,s4,0x2
ffffffffc02018d0:	00ca5a13          	srli	s4,s4,0xc
ffffffffc02018d4:	1cfa7263          	bgeu	s4,a5,ffffffffc0201a98 <exit_range+0x26e>
ffffffffc02018d8:	fff80637          	lui	a2,0xfff80
ffffffffc02018dc:	9652                	add	a2,a2,s4
ffffffffc02018de:	000806b7          	lui	a3,0x80
ffffffffc02018e2:	96b2                	add	a3,a3,a2
ffffffffc02018e4:	0196f5b3          	and	a1,a3,s9
ffffffffc02018e8:	061a                	slli	a2,a2,0x6
ffffffffc02018ea:	06b2                	slli	a3,a3,0xc
ffffffffc02018ec:	18f5fa63          	bgeu	a1,a5,ffffffffc0201a80 <exit_range+0x256>
ffffffffc02018f0:	00095817          	auipc	a6,0x95
ffffffffc02018f4:	fc080813          	addi	a6,a6,-64 # ffffffffc02968b0 <va_pa_offset>
ffffffffc02018f8:	00083b03          	ld	s6,0(a6)
ffffffffc02018fc:	4b85                	li	s7,1
ffffffffc02018fe:	fff80e37          	lui	t3,0xfff80
ffffffffc0201902:	9b36                	add	s6,s6,a3
ffffffffc0201904:	00080337          	lui	t1,0x80
ffffffffc0201908:	6885                	lui	a7,0x1
ffffffffc020190a:	a819                	j	ffffffffc0201920 <exit_range+0xf6>
ffffffffc020190c:	4b81                	li	s7,0
ffffffffc020190e:	002007b7          	lui	a5,0x200
ffffffffc0201912:	993e                	add	s2,s2,a5
ffffffffc0201914:	08090c63          	beqz	s2,ffffffffc02019ac <exit_range+0x182>
ffffffffc0201918:	09397a63          	bgeu	s2,s3,ffffffffc02019ac <exit_range+0x182>
ffffffffc020191c:	0f597063          	bgeu	s2,s5,ffffffffc02019fc <exit_range+0x1d2>
ffffffffc0201920:	01595493          	srli	s1,s2,0x15
ffffffffc0201924:	1ff4f493          	andi	s1,s1,511
ffffffffc0201928:	048e                	slli	s1,s1,0x3
ffffffffc020192a:	94da                	add	s1,s1,s6
ffffffffc020192c:	609c                	ld	a5,0(s1)
ffffffffc020192e:	0017f693          	andi	a3,a5,1
ffffffffc0201932:	dee9                	beqz	a3,ffffffffc020190c <exit_range+0xe2>
ffffffffc0201934:	000d3583          	ld	a1,0(s10)
ffffffffc0201938:	078a                	slli	a5,a5,0x2
ffffffffc020193a:	83b1                	srli	a5,a5,0xc
ffffffffc020193c:	14b7fe63          	bgeu	a5,a1,ffffffffc0201a98 <exit_range+0x26e>
ffffffffc0201940:	97f2                	add	a5,a5,t3
ffffffffc0201942:	006786b3          	add	a3,a5,t1
ffffffffc0201946:	0196feb3          	and	t4,a3,s9
ffffffffc020194a:	00679513          	slli	a0,a5,0x6
ffffffffc020194e:	06b2                	slli	a3,a3,0xc
ffffffffc0201950:	12bef863          	bgeu	t4,a1,ffffffffc0201a80 <exit_range+0x256>
ffffffffc0201954:	00083783          	ld	a5,0(a6)
ffffffffc0201958:	96be                	add	a3,a3,a5
ffffffffc020195a:	011685b3          	add	a1,a3,a7
ffffffffc020195e:	629c                	ld	a5,0(a3)
ffffffffc0201960:	8b85                	andi	a5,a5,1
ffffffffc0201962:	f7d5                	bnez	a5,ffffffffc020190e <exit_range+0xe4>
ffffffffc0201964:	06a1                	addi	a3,a3,8
ffffffffc0201966:	fed59ce3          	bne	a1,a3,ffffffffc020195e <exit_range+0x134>
ffffffffc020196a:	631c                	ld	a5,0(a4)
ffffffffc020196c:	953e                	add	a0,a0,a5
ffffffffc020196e:	100027f3          	csrr	a5,sstatus
ffffffffc0201972:	8b89                	andi	a5,a5,2
ffffffffc0201974:	e7d9                	bnez	a5,ffffffffc0201a02 <exit_range+0x1d8>
ffffffffc0201976:	000db783          	ld	a5,0(s11)
ffffffffc020197a:	4585                	li	a1,1
ffffffffc020197c:	e032                	sd	a2,0(sp)
ffffffffc020197e:	739c                	ld	a5,32(a5)
ffffffffc0201980:	9782                	jalr	a5
ffffffffc0201982:	6602                	ld	a2,0(sp)
ffffffffc0201984:	00095817          	auipc	a6,0x95
ffffffffc0201988:	f2c80813          	addi	a6,a6,-212 # ffffffffc02968b0 <va_pa_offset>
ffffffffc020198c:	fff80e37          	lui	t3,0xfff80
ffffffffc0201990:	00080337          	lui	t1,0x80
ffffffffc0201994:	6885                	lui	a7,0x1
ffffffffc0201996:	00095717          	auipc	a4,0x95
ffffffffc020199a:	f0a70713          	addi	a4,a4,-246 # ffffffffc02968a0 <pages>
ffffffffc020199e:	0004b023          	sd	zero,0(s1)
ffffffffc02019a2:	002007b7          	lui	a5,0x200
ffffffffc02019a6:	993e                	add	s2,s2,a5
ffffffffc02019a8:	f60918e3          	bnez	s2,ffffffffc0201918 <exit_range+0xee>
ffffffffc02019ac:	f00b85e3          	beqz	s7,ffffffffc02018b6 <exit_range+0x8c>
ffffffffc02019b0:	000d3783          	ld	a5,0(s10)
ffffffffc02019b4:	0efa7263          	bgeu	s4,a5,ffffffffc0201a98 <exit_range+0x26e>
ffffffffc02019b8:	6308                	ld	a0,0(a4)
ffffffffc02019ba:	9532                	add	a0,a0,a2
ffffffffc02019bc:	100027f3          	csrr	a5,sstatus
ffffffffc02019c0:	8b89                	andi	a5,a5,2
ffffffffc02019c2:	efad                	bnez	a5,ffffffffc0201a3c <exit_range+0x212>
ffffffffc02019c4:	000db783          	ld	a5,0(s11)
ffffffffc02019c8:	4585                	li	a1,1
ffffffffc02019ca:	739c                	ld	a5,32(a5)
ffffffffc02019cc:	9782                	jalr	a5
ffffffffc02019ce:	00095717          	auipc	a4,0x95
ffffffffc02019d2:	ed270713          	addi	a4,a4,-302 # ffffffffc02968a0 <pages>
ffffffffc02019d6:	00043023          	sd	zero,0(s0)
ffffffffc02019da:	ee0990e3          	bnez	s3,ffffffffc02018ba <exit_range+0x90>
ffffffffc02019de:	70e6                	ld	ra,120(sp)
ffffffffc02019e0:	7446                	ld	s0,112(sp)
ffffffffc02019e2:	74a6                	ld	s1,104(sp)
ffffffffc02019e4:	7906                	ld	s2,96(sp)
ffffffffc02019e6:	69e6                	ld	s3,88(sp)
ffffffffc02019e8:	6a46                	ld	s4,80(sp)
ffffffffc02019ea:	6aa6                	ld	s5,72(sp)
ffffffffc02019ec:	6b06                	ld	s6,64(sp)
ffffffffc02019ee:	7be2                	ld	s7,56(sp)
ffffffffc02019f0:	7c42                	ld	s8,48(sp)
ffffffffc02019f2:	7ca2                	ld	s9,40(sp)
ffffffffc02019f4:	7d02                	ld	s10,32(sp)
ffffffffc02019f6:	6de2                	ld	s11,24(sp)
ffffffffc02019f8:	6109                	addi	sp,sp,128
ffffffffc02019fa:	8082                	ret
ffffffffc02019fc:	ea0b8fe3          	beqz	s7,ffffffffc02018ba <exit_range+0x90>
ffffffffc0201a00:	bf45                	j	ffffffffc02019b0 <exit_range+0x186>
ffffffffc0201a02:	e032                	sd	a2,0(sp)
ffffffffc0201a04:	e42a                	sd	a0,8(sp)
ffffffffc0201a06:	b9aff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201a0a:	000db783          	ld	a5,0(s11)
ffffffffc0201a0e:	6522                	ld	a0,8(sp)
ffffffffc0201a10:	4585                	li	a1,1
ffffffffc0201a12:	739c                	ld	a5,32(a5)
ffffffffc0201a14:	9782                	jalr	a5
ffffffffc0201a16:	b84ff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201a1a:	6602                	ld	a2,0(sp)
ffffffffc0201a1c:	00095717          	auipc	a4,0x95
ffffffffc0201a20:	e8470713          	addi	a4,a4,-380 # ffffffffc02968a0 <pages>
ffffffffc0201a24:	6885                	lui	a7,0x1
ffffffffc0201a26:	00080337          	lui	t1,0x80
ffffffffc0201a2a:	fff80e37          	lui	t3,0xfff80
ffffffffc0201a2e:	00095817          	auipc	a6,0x95
ffffffffc0201a32:	e8280813          	addi	a6,a6,-382 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0201a36:	0004b023          	sd	zero,0(s1)
ffffffffc0201a3a:	b7a5                	j	ffffffffc02019a2 <exit_range+0x178>
ffffffffc0201a3c:	e02a                	sd	a0,0(sp)
ffffffffc0201a3e:	b62ff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201a42:	000db783          	ld	a5,0(s11)
ffffffffc0201a46:	6502                	ld	a0,0(sp)
ffffffffc0201a48:	4585                	li	a1,1
ffffffffc0201a4a:	739c                	ld	a5,32(a5)
ffffffffc0201a4c:	9782                	jalr	a5
ffffffffc0201a4e:	b4cff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201a52:	00095717          	auipc	a4,0x95
ffffffffc0201a56:	e4e70713          	addi	a4,a4,-434 # ffffffffc02968a0 <pages>
ffffffffc0201a5a:	00043023          	sd	zero,0(s0)
ffffffffc0201a5e:	bfb5                	j	ffffffffc02019da <exit_range+0x1b0>
ffffffffc0201a60:	0000a697          	auipc	a3,0xa
ffffffffc0201a64:	63068693          	addi	a3,a3,1584 # ffffffffc020c090 <commands+0x9c8>
ffffffffc0201a68:	0000a617          	auipc	a2,0xa
ffffffffc0201a6c:	eb060613          	addi	a2,a2,-336 # ffffffffc020b918 <commands+0x250>
ffffffffc0201a70:	16f00593          	li	a1,367
ffffffffc0201a74:	0000a517          	auipc	a0,0xa
ffffffffc0201a78:	5e450513          	addi	a0,a0,1508 # ffffffffc020c058 <commands+0x990>
ffffffffc0201a7c:	fb2fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201a80:	0000a617          	auipc	a2,0xa
ffffffffc0201a84:	5b060613          	addi	a2,a2,1456 # ffffffffc020c030 <commands+0x968>
ffffffffc0201a88:	07100593          	li	a1,113
ffffffffc0201a8c:	0000a517          	auipc	a0,0xa
ffffffffc0201a90:	56c50513          	addi	a0,a0,1388 # ffffffffc020bff8 <commands+0x930>
ffffffffc0201a94:	f9afe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201a98:	81bff0ef          	jal	ra,ffffffffc02012b2 <pa2page.part.0>
ffffffffc0201a9c:	0000a697          	auipc	a3,0xa
ffffffffc0201aa0:	62468693          	addi	a3,a3,1572 # ffffffffc020c0c0 <commands+0x9f8>
ffffffffc0201aa4:	0000a617          	auipc	a2,0xa
ffffffffc0201aa8:	e7460613          	addi	a2,a2,-396 # ffffffffc020b918 <commands+0x250>
ffffffffc0201aac:	17000593          	li	a1,368
ffffffffc0201ab0:	0000a517          	auipc	a0,0xa
ffffffffc0201ab4:	5a850513          	addi	a0,a0,1448 # ffffffffc020c058 <commands+0x990>
ffffffffc0201ab8:	f76fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201abc <page_remove>:
ffffffffc0201abc:	7179                	addi	sp,sp,-48
ffffffffc0201abe:	4601                	li	a2,0
ffffffffc0201ac0:	ec26                	sd	s1,24(sp)
ffffffffc0201ac2:	f406                	sd	ra,40(sp)
ffffffffc0201ac4:	f022                	sd	s0,32(sp)
ffffffffc0201ac6:	84ae                	mv	s1,a1
ffffffffc0201ac8:	8dbff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0201acc:	c511                	beqz	a0,ffffffffc0201ad8 <page_remove+0x1c>
ffffffffc0201ace:	611c                	ld	a5,0(a0)
ffffffffc0201ad0:	842a                	mv	s0,a0
ffffffffc0201ad2:	0017f713          	andi	a4,a5,1
ffffffffc0201ad6:	e711                	bnez	a4,ffffffffc0201ae2 <page_remove+0x26>
ffffffffc0201ad8:	70a2                	ld	ra,40(sp)
ffffffffc0201ada:	7402                	ld	s0,32(sp)
ffffffffc0201adc:	64e2                	ld	s1,24(sp)
ffffffffc0201ade:	6145                	addi	sp,sp,48
ffffffffc0201ae0:	8082                	ret
ffffffffc0201ae2:	078a                	slli	a5,a5,0x2
ffffffffc0201ae4:	83b1                	srli	a5,a5,0xc
ffffffffc0201ae6:	00095717          	auipc	a4,0x95
ffffffffc0201aea:	db273703          	ld	a4,-590(a4) # ffffffffc0296898 <npage>
ffffffffc0201aee:	06e7f363          	bgeu	a5,a4,ffffffffc0201b54 <page_remove+0x98>
ffffffffc0201af2:	fff80537          	lui	a0,0xfff80
ffffffffc0201af6:	97aa                	add	a5,a5,a0
ffffffffc0201af8:	079a                	slli	a5,a5,0x6
ffffffffc0201afa:	00095517          	auipc	a0,0x95
ffffffffc0201afe:	da653503          	ld	a0,-602(a0) # ffffffffc02968a0 <pages>
ffffffffc0201b02:	953e                	add	a0,a0,a5
ffffffffc0201b04:	411c                	lw	a5,0(a0)
ffffffffc0201b06:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201b0a:	c118                	sw	a4,0(a0)
ffffffffc0201b0c:	cb11                	beqz	a4,ffffffffc0201b20 <page_remove+0x64>
ffffffffc0201b0e:	00043023          	sd	zero,0(s0)
ffffffffc0201b12:	12048073          	sfence.vma	s1
ffffffffc0201b16:	70a2                	ld	ra,40(sp)
ffffffffc0201b18:	7402                	ld	s0,32(sp)
ffffffffc0201b1a:	64e2                	ld	s1,24(sp)
ffffffffc0201b1c:	6145                	addi	sp,sp,48
ffffffffc0201b1e:	8082                	ret
ffffffffc0201b20:	100027f3          	csrr	a5,sstatus
ffffffffc0201b24:	8b89                	andi	a5,a5,2
ffffffffc0201b26:	eb89                	bnez	a5,ffffffffc0201b38 <page_remove+0x7c>
ffffffffc0201b28:	00095797          	auipc	a5,0x95
ffffffffc0201b2c:	d807b783          	ld	a5,-640(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201b30:	739c                	ld	a5,32(a5)
ffffffffc0201b32:	4585                	li	a1,1
ffffffffc0201b34:	9782                	jalr	a5
ffffffffc0201b36:	bfe1                	j	ffffffffc0201b0e <page_remove+0x52>
ffffffffc0201b38:	e42a                	sd	a0,8(sp)
ffffffffc0201b3a:	a66ff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201b3e:	00095797          	auipc	a5,0x95
ffffffffc0201b42:	d6a7b783          	ld	a5,-662(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201b46:	739c                	ld	a5,32(a5)
ffffffffc0201b48:	6522                	ld	a0,8(sp)
ffffffffc0201b4a:	4585                	li	a1,1
ffffffffc0201b4c:	9782                	jalr	a5
ffffffffc0201b4e:	a4cff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201b52:	bf75                	j	ffffffffc0201b0e <page_remove+0x52>
ffffffffc0201b54:	f5eff0ef          	jal	ra,ffffffffc02012b2 <pa2page.part.0>

ffffffffc0201b58 <page_insert>:
ffffffffc0201b58:	7139                	addi	sp,sp,-64
ffffffffc0201b5a:	e852                	sd	s4,16(sp)
ffffffffc0201b5c:	8a32                	mv	s4,a2
ffffffffc0201b5e:	f822                	sd	s0,48(sp)
ffffffffc0201b60:	4605                	li	a2,1
ffffffffc0201b62:	842e                	mv	s0,a1
ffffffffc0201b64:	85d2                	mv	a1,s4
ffffffffc0201b66:	f426                	sd	s1,40(sp)
ffffffffc0201b68:	fc06                	sd	ra,56(sp)
ffffffffc0201b6a:	f04a                	sd	s2,32(sp)
ffffffffc0201b6c:	ec4e                	sd	s3,24(sp)
ffffffffc0201b6e:	e456                	sd	s5,8(sp)
ffffffffc0201b70:	84b6                	mv	s1,a3
ffffffffc0201b72:	831ff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0201b76:	c961                	beqz	a0,ffffffffc0201c46 <page_insert+0xee>
ffffffffc0201b78:	4014                	lw	a3,0(s0)
ffffffffc0201b7a:	611c                	ld	a5,0(a0)
ffffffffc0201b7c:	89aa                	mv	s3,a0
ffffffffc0201b7e:	0016871b          	addiw	a4,a3,1
ffffffffc0201b82:	c018                	sw	a4,0(s0)
ffffffffc0201b84:	0017f713          	andi	a4,a5,1
ffffffffc0201b88:	ef05                	bnez	a4,ffffffffc0201bc0 <page_insert+0x68>
ffffffffc0201b8a:	00095717          	auipc	a4,0x95
ffffffffc0201b8e:	d1673703          	ld	a4,-746(a4) # ffffffffc02968a0 <pages>
ffffffffc0201b92:	8c19                	sub	s0,s0,a4
ffffffffc0201b94:	000807b7          	lui	a5,0x80
ffffffffc0201b98:	8419                	srai	s0,s0,0x6
ffffffffc0201b9a:	943e                	add	s0,s0,a5
ffffffffc0201b9c:	042a                	slli	s0,s0,0xa
ffffffffc0201b9e:	8cc1                	or	s1,s1,s0
ffffffffc0201ba0:	0014e493          	ori	s1,s1,1
ffffffffc0201ba4:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0201ba8:	120a0073          	sfence.vma	s4
ffffffffc0201bac:	4501                	li	a0,0
ffffffffc0201bae:	70e2                	ld	ra,56(sp)
ffffffffc0201bb0:	7442                	ld	s0,48(sp)
ffffffffc0201bb2:	74a2                	ld	s1,40(sp)
ffffffffc0201bb4:	7902                	ld	s2,32(sp)
ffffffffc0201bb6:	69e2                	ld	s3,24(sp)
ffffffffc0201bb8:	6a42                	ld	s4,16(sp)
ffffffffc0201bba:	6aa2                	ld	s5,8(sp)
ffffffffc0201bbc:	6121                	addi	sp,sp,64
ffffffffc0201bbe:	8082                	ret
ffffffffc0201bc0:	078a                	slli	a5,a5,0x2
ffffffffc0201bc2:	83b1                	srli	a5,a5,0xc
ffffffffc0201bc4:	00095717          	auipc	a4,0x95
ffffffffc0201bc8:	cd473703          	ld	a4,-812(a4) # ffffffffc0296898 <npage>
ffffffffc0201bcc:	06e7ff63          	bgeu	a5,a4,ffffffffc0201c4a <page_insert+0xf2>
ffffffffc0201bd0:	00095a97          	auipc	s5,0x95
ffffffffc0201bd4:	cd0a8a93          	addi	s5,s5,-816 # ffffffffc02968a0 <pages>
ffffffffc0201bd8:	000ab703          	ld	a4,0(s5)
ffffffffc0201bdc:	fff80937          	lui	s2,0xfff80
ffffffffc0201be0:	993e                	add	s2,s2,a5
ffffffffc0201be2:	091a                	slli	s2,s2,0x6
ffffffffc0201be4:	993a                	add	s2,s2,a4
ffffffffc0201be6:	01240c63          	beq	s0,s2,ffffffffc0201bfe <page_insert+0xa6>
ffffffffc0201bea:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0201bee:	fff7869b          	addiw	a3,a5,-1
ffffffffc0201bf2:	00d92023          	sw	a3,0(s2)
ffffffffc0201bf6:	c691                	beqz	a3,ffffffffc0201c02 <page_insert+0xaa>
ffffffffc0201bf8:	120a0073          	sfence.vma	s4
ffffffffc0201bfc:	bf59                	j	ffffffffc0201b92 <page_insert+0x3a>
ffffffffc0201bfe:	c014                	sw	a3,0(s0)
ffffffffc0201c00:	bf49                	j	ffffffffc0201b92 <page_insert+0x3a>
ffffffffc0201c02:	100027f3          	csrr	a5,sstatus
ffffffffc0201c06:	8b89                	andi	a5,a5,2
ffffffffc0201c08:	ef91                	bnez	a5,ffffffffc0201c24 <page_insert+0xcc>
ffffffffc0201c0a:	00095797          	auipc	a5,0x95
ffffffffc0201c0e:	c9e7b783          	ld	a5,-866(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201c12:	739c                	ld	a5,32(a5)
ffffffffc0201c14:	4585                	li	a1,1
ffffffffc0201c16:	854a                	mv	a0,s2
ffffffffc0201c18:	9782                	jalr	a5
ffffffffc0201c1a:	000ab703          	ld	a4,0(s5)
ffffffffc0201c1e:	120a0073          	sfence.vma	s4
ffffffffc0201c22:	bf85                	j	ffffffffc0201b92 <page_insert+0x3a>
ffffffffc0201c24:	97cff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201c28:	00095797          	auipc	a5,0x95
ffffffffc0201c2c:	c807b783          	ld	a5,-896(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201c30:	739c                	ld	a5,32(a5)
ffffffffc0201c32:	4585                	li	a1,1
ffffffffc0201c34:	854a                	mv	a0,s2
ffffffffc0201c36:	9782                	jalr	a5
ffffffffc0201c38:	962ff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201c3c:	000ab703          	ld	a4,0(s5)
ffffffffc0201c40:	120a0073          	sfence.vma	s4
ffffffffc0201c44:	b7b9                	j	ffffffffc0201b92 <page_insert+0x3a>
ffffffffc0201c46:	5571                	li	a0,-4
ffffffffc0201c48:	b79d                	j	ffffffffc0201bae <page_insert+0x56>
ffffffffc0201c4a:	e68ff0ef          	jal	ra,ffffffffc02012b2 <pa2page.part.0>

ffffffffc0201c4e <pmm_init>:
ffffffffc0201c4e:	0000b797          	auipc	a5,0xb
ffffffffc0201c52:	19a78793          	addi	a5,a5,410 # ffffffffc020cde8 <default_pmm_manager>
ffffffffc0201c56:	638c                	ld	a1,0(a5)
ffffffffc0201c58:	7159                	addi	sp,sp,-112
ffffffffc0201c5a:	f85a                	sd	s6,48(sp)
ffffffffc0201c5c:	0000a517          	auipc	a0,0xa
ffffffffc0201c60:	47c50513          	addi	a0,a0,1148 # ffffffffc020c0d8 <commands+0xa10>
ffffffffc0201c64:	00095b17          	auipc	s6,0x95
ffffffffc0201c68:	c44b0b13          	addi	s6,s6,-956 # ffffffffc02968a8 <pmm_manager>
ffffffffc0201c6c:	f486                	sd	ra,104(sp)
ffffffffc0201c6e:	e8ca                	sd	s2,80(sp)
ffffffffc0201c70:	e4ce                	sd	s3,72(sp)
ffffffffc0201c72:	f0a2                	sd	s0,96(sp)
ffffffffc0201c74:	eca6                	sd	s1,88(sp)
ffffffffc0201c76:	e0d2                	sd	s4,64(sp)
ffffffffc0201c78:	fc56                	sd	s5,56(sp)
ffffffffc0201c7a:	f45e                	sd	s7,40(sp)
ffffffffc0201c7c:	f062                	sd	s8,32(sp)
ffffffffc0201c7e:	ec66                	sd	s9,24(sp)
ffffffffc0201c80:	00fb3023          	sd	a5,0(s6)
ffffffffc0201c84:	ca6fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201c88:	000b3783          	ld	a5,0(s6)
ffffffffc0201c8c:	00095997          	auipc	s3,0x95
ffffffffc0201c90:	c2498993          	addi	s3,s3,-988 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0201c94:	679c                	ld	a5,8(a5)
ffffffffc0201c96:	9782                	jalr	a5
ffffffffc0201c98:	57f5                	li	a5,-3
ffffffffc0201c9a:	07fa                	slli	a5,a5,0x1e
ffffffffc0201c9c:	00f9b023          	sd	a5,0(s3)
ffffffffc0201ca0:	c49fe0ef          	jal	ra,ffffffffc02008e8 <get_memory_base>
ffffffffc0201ca4:	892a                	mv	s2,a0
ffffffffc0201ca6:	c4dfe0ef          	jal	ra,ffffffffc02008f2 <get_memory_size>
ffffffffc0201caa:	280502e3          	beqz	a0,ffffffffc020272e <pmm_init+0xae0>
ffffffffc0201cae:	84aa                	mv	s1,a0
ffffffffc0201cb0:	0000a517          	auipc	a0,0xa
ffffffffc0201cb4:	46050513          	addi	a0,a0,1120 # ffffffffc020c110 <commands+0xa48>
ffffffffc0201cb8:	c72fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201cbc:	00990433          	add	s0,s2,s1
ffffffffc0201cc0:	fff40693          	addi	a3,s0,-1
ffffffffc0201cc4:	864a                	mv	a2,s2
ffffffffc0201cc6:	85a6                	mv	a1,s1
ffffffffc0201cc8:	0000a517          	auipc	a0,0xa
ffffffffc0201ccc:	46050513          	addi	a0,a0,1120 # ffffffffc020c128 <commands+0xa60>
ffffffffc0201cd0:	c5afe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201cd4:	c8000737          	lui	a4,0xc8000
ffffffffc0201cd8:	87a2                	mv	a5,s0
ffffffffc0201cda:	5e876e63          	bltu	a4,s0,ffffffffc02022d6 <pmm_init+0x688>
ffffffffc0201cde:	757d                	lui	a0,0xfffff
ffffffffc0201ce0:	00096617          	auipc	a2,0x96
ffffffffc0201ce4:	c2f60613          	addi	a2,a2,-977 # ffffffffc029790f <end+0xfff>
ffffffffc0201ce8:	8e69                	and	a2,a2,a0
ffffffffc0201cea:	00095497          	auipc	s1,0x95
ffffffffc0201cee:	bae48493          	addi	s1,s1,-1106 # ffffffffc0296898 <npage>
ffffffffc0201cf2:	00c7d513          	srli	a0,a5,0xc
ffffffffc0201cf6:	00095b97          	auipc	s7,0x95
ffffffffc0201cfa:	baab8b93          	addi	s7,s7,-1110 # ffffffffc02968a0 <pages>
ffffffffc0201cfe:	e088                	sd	a0,0(s1)
ffffffffc0201d00:	00cbb023          	sd	a2,0(s7)
ffffffffc0201d04:	000807b7          	lui	a5,0x80
ffffffffc0201d08:	86b2                	mv	a3,a2
ffffffffc0201d0a:	02f50863          	beq	a0,a5,ffffffffc0201d3a <pmm_init+0xec>
ffffffffc0201d0e:	4781                	li	a5,0
ffffffffc0201d10:	4585                	li	a1,1
ffffffffc0201d12:	fff806b7          	lui	a3,0xfff80
ffffffffc0201d16:	00679513          	slli	a0,a5,0x6
ffffffffc0201d1a:	9532                	add	a0,a0,a2
ffffffffc0201d1c:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd686f8>
ffffffffc0201d20:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc0201d24:	6088                	ld	a0,0(s1)
ffffffffc0201d26:	0785                	addi	a5,a5,1
ffffffffc0201d28:	000bb603          	ld	a2,0(s7)
ffffffffc0201d2c:	00d50733          	add	a4,a0,a3
ffffffffc0201d30:	fee7e3e3          	bltu	a5,a4,ffffffffc0201d16 <pmm_init+0xc8>
ffffffffc0201d34:	071a                	slli	a4,a4,0x6
ffffffffc0201d36:	00e606b3          	add	a3,a2,a4
ffffffffc0201d3a:	c02007b7          	lui	a5,0xc0200
ffffffffc0201d3e:	3af6eae3          	bltu	a3,a5,ffffffffc02028f2 <pmm_init+0xca4>
ffffffffc0201d42:	0009b583          	ld	a1,0(s3)
ffffffffc0201d46:	77fd                	lui	a5,0xfffff
ffffffffc0201d48:	8c7d                	and	s0,s0,a5
ffffffffc0201d4a:	8e8d                	sub	a3,a3,a1
ffffffffc0201d4c:	5e86e363          	bltu	a3,s0,ffffffffc0202332 <pmm_init+0x6e4>
ffffffffc0201d50:	0000a517          	auipc	a0,0xa
ffffffffc0201d54:	42850513          	addi	a0,a0,1064 # ffffffffc020c178 <commands+0xab0>
ffffffffc0201d58:	bd2fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201d5c:	000b3783          	ld	a5,0(s6)
ffffffffc0201d60:	7b9c                	ld	a5,48(a5)
ffffffffc0201d62:	9782                	jalr	a5
ffffffffc0201d64:	0000a517          	auipc	a0,0xa
ffffffffc0201d68:	42c50513          	addi	a0,a0,1068 # ffffffffc020c190 <commands+0xac8>
ffffffffc0201d6c:	bbefe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201d70:	100027f3          	csrr	a5,sstatus
ffffffffc0201d74:	8b89                	andi	a5,a5,2
ffffffffc0201d76:	5a079363          	bnez	a5,ffffffffc020231c <pmm_init+0x6ce>
ffffffffc0201d7a:	000b3783          	ld	a5,0(s6)
ffffffffc0201d7e:	4505                	li	a0,1
ffffffffc0201d80:	6f9c                	ld	a5,24(a5)
ffffffffc0201d82:	9782                	jalr	a5
ffffffffc0201d84:	842a                	mv	s0,a0
ffffffffc0201d86:	180408e3          	beqz	s0,ffffffffc0202716 <pmm_init+0xac8>
ffffffffc0201d8a:	000bb683          	ld	a3,0(s7)
ffffffffc0201d8e:	5a7d                	li	s4,-1
ffffffffc0201d90:	6098                	ld	a4,0(s1)
ffffffffc0201d92:	40d406b3          	sub	a3,s0,a3
ffffffffc0201d96:	8699                	srai	a3,a3,0x6
ffffffffc0201d98:	00080437          	lui	s0,0x80
ffffffffc0201d9c:	96a2                	add	a3,a3,s0
ffffffffc0201d9e:	00ca5793          	srli	a5,s4,0xc
ffffffffc0201da2:	8ff5                	and	a5,a5,a3
ffffffffc0201da4:	06b2                	slli	a3,a3,0xc
ffffffffc0201da6:	30e7fde3          	bgeu	a5,a4,ffffffffc02028c0 <pmm_init+0xc72>
ffffffffc0201daa:	0009b403          	ld	s0,0(s3)
ffffffffc0201dae:	6605                	lui	a2,0x1
ffffffffc0201db0:	4581                	li	a1,0
ffffffffc0201db2:	9436                	add	s0,s0,a3
ffffffffc0201db4:	8522                	mv	a0,s0
ffffffffc0201db6:	16a090ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0201dba:	0009b683          	ld	a3,0(s3)
ffffffffc0201dbe:	77fd                	lui	a5,0xfffff
ffffffffc0201dc0:	0000a917          	auipc	s2,0xa
ffffffffc0201dc4:	65b90913          	addi	s2,s2,1627 # ffffffffc020c41b <commands+0xd53>
ffffffffc0201dc8:	00f97933          	and	s2,s2,a5
ffffffffc0201dcc:	c0200ab7          	lui	s5,0xc0200
ffffffffc0201dd0:	3fe00637          	lui	a2,0x3fe00
ffffffffc0201dd4:	964a                	add	a2,a2,s2
ffffffffc0201dd6:	4729                	li	a4,10
ffffffffc0201dd8:	40da86b3          	sub	a3,s5,a3
ffffffffc0201ddc:	c02005b7          	lui	a1,0xc0200
ffffffffc0201de0:	8522                	mv	a0,s0
ffffffffc0201de2:	fe8ff0ef          	jal	ra,ffffffffc02015ca <boot_map_segment>
ffffffffc0201de6:	c8000637          	lui	a2,0xc8000
ffffffffc0201dea:	41260633          	sub	a2,a2,s2
ffffffffc0201dee:	3f596ce3          	bltu	s2,s5,ffffffffc02029e6 <pmm_init+0xd98>
ffffffffc0201df2:	0009b683          	ld	a3,0(s3)
ffffffffc0201df6:	85ca                	mv	a1,s2
ffffffffc0201df8:	4719                	li	a4,6
ffffffffc0201dfa:	40d906b3          	sub	a3,s2,a3
ffffffffc0201dfe:	8522                	mv	a0,s0
ffffffffc0201e00:	00095917          	auipc	s2,0x95
ffffffffc0201e04:	a9090913          	addi	s2,s2,-1392 # ffffffffc0296890 <boot_pgdir_va>
ffffffffc0201e08:	fc2ff0ef          	jal	ra,ffffffffc02015ca <boot_map_segment>
ffffffffc0201e0c:	00893023          	sd	s0,0(s2)
ffffffffc0201e10:	2d5464e3          	bltu	s0,s5,ffffffffc02028d8 <pmm_init+0xc8a>
ffffffffc0201e14:	0009b783          	ld	a5,0(s3)
ffffffffc0201e18:	1a7e                	slli	s4,s4,0x3f
ffffffffc0201e1a:	8c1d                	sub	s0,s0,a5
ffffffffc0201e1c:	00c45793          	srli	a5,s0,0xc
ffffffffc0201e20:	00095717          	auipc	a4,0x95
ffffffffc0201e24:	a6873423          	sd	s0,-1432(a4) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc0201e28:	0147ea33          	or	s4,a5,s4
ffffffffc0201e2c:	180a1073          	csrw	satp,s4
ffffffffc0201e30:	12000073          	sfence.vma
ffffffffc0201e34:	0000a517          	auipc	a0,0xa
ffffffffc0201e38:	39c50513          	addi	a0,a0,924 # ffffffffc020c1d0 <commands+0xb08>
ffffffffc0201e3c:	aeefe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201e40:	0000f717          	auipc	a4,0xf
ffffffffc0201e44:	1c070713          	addi	a4,a4,448 # ffffffffc0211000 <bootstack>
ffffffffc0201e48:	0000f797          	auipc	a5,0xf
ffffffffc0201e4c:	1b878793          	addi	a5,a5,440 # ffffffffc0211000 <bootstack>
ffffffffc0201e50:	5cf70d63          	beq	a4,a5,ffffffffc020242a <pmm_init+0x7dc>
ffffffffc0201e54:	100027f3          	csrr	a5,sstatus
ffffffffc0201e58:	8b89                	andi	a5,a5,2
ffffffffc0201e5a:	4a079763          	bnez	a5,ffffffffc0202308 <pmm_init+0x6ba>
ffffffffc0201e5e:	000b3783          	ld	a5,0(s6)
ffffffffc0201e62:	779c                	ld	a5,40(a5)
ffffffffc0201e64:	9782                	jalr	a5
ffffffffc0201e66:	842a                	mv	s0,a0
ffffffffc0201e68:	6098                	ld	a4,0(s1)
ffffffffc0201e6a:	c80007b7          	lui	a5,0xc8000
ffffffffc0201e6e:	83b1                	srli	a5,a5,0xc
ffffffffc0201e70:	08e7e3e3          	bltu	a5,a4,ffffffffc02026f6 <pmm_init+0xaa8>
ffffffffc0201e74:	00093503          	ld	a0,0(s2)
ffffffffc0201e78:	04050fe3          	beqz	a0,ffffffffc02026d6 <pmm_init+0xa88>
ffffffffc0201e7c:	03451793          	slli	a5,a0,0x34
ffffffffc0201e80:	04079be3          	bnez	a5,ffffffffc02026d6 <pmm_init+0xa88>
ffffffffc0201e84:	4601                	li	a2,0
ffffffffc0201e86:	4581                	li	a1,0
ffffffffc0201e88:	809ff0ef          	jal	ra,ffffffffc0201690 <get_page>
ffffffffc0201e8c:	2e0511e3          	bnez	a0,ffffffffc020296e <pmm_init+0xd20>
ffffffffc0201e90:	100027f3          	csrr	a5,sstatus
ffffffffc0201e94:	8b89                	andi	a5,a5,2
ffffffffc0201e96:	44079e63          	bnez	a5,ffffffffc02022f2 <pmm_init+0x6a4>
ffffffffc0201e9a:	000b3783          	ld	a5,0(s6)
ffffffffc0201e9e:	4505                	li	a0,1
ffffffffc0201ea0:	6f9c                	ld	a5,24(a5)
ffffffffc0201ea2:	9782                	jalr	a5
ffffffffc0201ea4:	8a2a                	mv	s4,a0
ffffffffc0201ea6:	00093503          	ld	a0,0(s2)
ffffffffc0201eaa:	4681                	li	a3,0
ffffffffc0201eac:	4601                	li	a2,0
ffffffffc0201eae:	85d2                	mv	a1,s4
ffffffffc0201eb0:	ca9ff0ef          	jal	ra,ffffffffc0201b58 <page_insert>
ffffffffc0201eb4:	26051be3          	bnez	a0,ffffffffc020292a <pmm_init+0xcdc>
ffffffffc0201eb8:	00093503          	ld	a0,0(s2)
ffffffffc0201ebc:	4601                	li	a2,0
ffffffffc0201ebe:	4581                	li	a1,0
ffffffffc0201ec0:	ce2ff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0201ec4:	280505e3          	beqz	a0,ffffffffc020294e <pmm_init+0xd00>
ffffffffc0201ec8:	611c                	ld	a5,0(a0)
ffffffffc0201eca:	0017f713          	andi	a4,a5,1
ffffffffc0201ece:	26070ee3          	beqz	a4,ffffffffc020294a <pmm_init+0xcfc>
ffffffffc0201ed2:	6098                	ld	a4,0(s1)
ffffffffc0201ed4:	078a                	slli	a5,a5,0x2
ffffffffc0201ed6:	83b1                	srli	a5,a5,0xc
ffffffffc0201ed8:	62e7f363          	bgeu	a5,a4,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc0201edc:	000bb683          	ld	a3,0(s7)
ffffffffc0201ee0:	fff80637          	lui	a2,0xfff80
ffffffffc0201ee4:	97b2                	add	a5,a5,a2
ffffffffc0201ee6:	079a                	slli	a5,a5,0x6
ffffffffc0201ee8:	97b6                	add	a5,a5,a3
ffffffffc0201eea:	2afa12e3          	bne	s4,a5,ffffffffc020298e <pmm_init+0xd40>
ffffffffc0201eee:	000a2683          	lw	a3,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0201ef2:	4785                	li	a5,1
ffffffffc0201ef4:	2cf699e3          	bne	a3,a5,ffffffffc02029c6 <pmm_init+0xd78>
ffffffffc0201ef8:	00093503          	ld	a0,0(s2)
ffffffffc0201efc:	77fd                	lui	a5,0xfffff
ffffffffc0201efe:	6114                	ld	a3,0(a0)
ffffffffc0201f00:	068a                	slli	a3,a3,0x2
ffffffffc0201f02:	8efd                	and	a3,a3,a5
ffffffffc0201f04:	00c6d613          	srli	a2,a3,0xc
ffffffffc0201f08:	2ae673e3          	bgeu	a2,a4,ffffffffc02029ae <pmm_init+0xd60>
ffffffffc0201f0c:	0009bc03          	ld	s8,0(s3)
ffffffffc0201f10:	96e2                	add	a3,a3,s8
ffffffffc0201f12:	0006ba83          	ld	s5,0(a3) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0201f16:	0a8a                	slli	s5,s5,0x2
ffffffffc0201f18:	00fafab3          	and	s5,s5,a5
ffffffffc0201f1c:	00cad793          	srli	a5,s5,0xc
ffffffffc0201f20:	06e7f3e3          	bgeu	a5,a4,ffffffffc0202786 <pmm_init+0xb38>
ffffffffc0201f24:	4601                	li	a2,0
ffffffffc0201f26:	6585                	lui	a1,0x1
ffffffffc0201f28:	9ae2                	add	s5,s5,s8
ffffffffc0201f2a:	c78ff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0201f2e:	0aa1                	addi	s5,s5,8
ffffffffc0201f30:	03551be3          	bne	a0,s5,ffffffffc0202766 <pmm_init+0xb18>
ffffffffc0201f34:	100027f3          	csrr	a5,sstatus
ffffffffc0201f38:	8b89                	andi	a5,a5,2
ffffffffc0201f3a:	3a079163          	bnez	a5,ffffffffc02022dc <pmm_init+0x68e>
ffffffffc0201f3e:	000b3783          	ld	a5,0(s6)
ffffffffc0201f42:	4505                	li	a0,1
ffffffffc0201f44:	6f9c                	ld	a5,24(a5)
ffffffffc0201f46:	9782                	jalr	a5
ffffffffc0201f48:	8c2a                	mv	s8,a0
ffffffffc0201f4a:	00093503          	ld	a0,0(s2)
ffffffffc0201f4e:	46d1                	li	a3,20
ffffffffc0201f50:	6605                	lui	a2,0x1
ffffffffc0201f52:	85e2                	mv	a1,s8
ffffffffc0201f54:	c05ff0ef          	jal	ra,ffffffffc0201b58 <page_insert>
ffffffffc0201f58:	1a0519e3          	bnez	a0,ffffffffc020290a <pmm_init+0xcbc>
ffffffffc0201f5c:	00093503          	ld	a0,0(s2)
ffffffffc0201f60:	4601                	li	a2,0
ffffffffc0201f62:	6585                	lui	a1,0x1
ffffffffc0201f64:	c3eff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0201f68:	10050ce3          	beqz	a0,ffffffffc0202880 <pmm_init+0xc32>
ffffffffc0201f6c:	611c                	ld	a5,0(a0)
ffffffffc0201f6e:	0107f713          	andi	a4,a5,16
ffffffffc0201f72:	0e0707e3          	beqz	a4,ffffffffc0202860 <pmm_init+0xc12>
ffffffffc0201f76:	8b91                	andi	a5,a5,4
ffffffffc0201f78:	0c0784e3          	beqz	a5,ffffffffc0202840 <pmm_init+0xbf2>
ffffffffc0201f7c:	00093503          	ld	a0,0(s2)
ffffffffc0201f80:	611c                	ld	a5,0(a0)
ffffffffc0201f82:	8bc1                	andi	a5,a5,16
ffffffffc0201f84:	08078ee3          	beqz	a5,ffffffffc0202820 <pmm_init+0xbd2>
ffffffffc0201f88:	000c2703          	lw	a4,0(s8)
ffffffffc0201f8c:	4785                	li	a5,1
ffffffffc0201f8e:	06f719e3          	bne	a4,a5,ffffffffc0202800 <pmm_init+0xbb2>
ffffffffc0201f92:	4681                	li	a3,0
ffffffffc0201f94:	6605                	lui	a2,0x1
ffffffffc0201f96:	85d2                	mv	a1,s4
ffffffffc0201f98:	bc1ff0ef          	jal	ra,ffffffffc0201b58 <page_insert>
ffffffffc0201f9c:	040512e3          	bnez	a0,ffffffffc02027e0 <pmm_init+0xb92>
ffffffffc0201fa0:	000a2703          	lw	a4,0(s4)
ffffffffc0201fa4:	4789                	li	a5,2
ffffffffc0201fa6:	00f71de3          	bne	a4,a5,ffffffffc02027c0 <pmm_init+0xb72>
ffffffffc0201faa:	000c2783          	lw	a5,0(s8)
ffffffffc0201fae:	7e079963          	bnez	a5,ffffffffc02027a0 <pmm_init+0xb52>
ffffffffc0201fb2:	00093503          	ld	a0,0(s2)
ffffffffc0201fb6:	4601                	li	a2,0
ffffffffc0201fb8:	6585                	lui	a1,0x1
ffffffffc0201fba:	be8ff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0201fbe:	54050263          	beqz	a0,ffffffffc0202502 <pmm_init+0x8b4>
ffffffffc0201fc2:	6118                	ld	a4,0(a0)
ffffffffc0201fc4:	00177793          	andi	a5,a4,1
ffffffffc0201fc8:	180781e3          	beqz	a5,ffffffffc020294a <pmm_init+0xcfc>
ffffffffc0201fcc:	6094                	ld	a3,0(s1)
ffffffffc0201fce:	00271793          	slli	a5,a4,0x2
ffffffffc0201fd2:	83b1                	srli	a5,a5,0xc
ffffffffc0201fd4:	52d7f563          	bgeu	a5,a3,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc0201fd8:	000bb683          	ld	a3,0(s7)
ffffffffc0201fdc:	fff80ab7          	lui	s5,0xfff80
ffffffffc0201fe0:	97d6                	add	a5,a5,s5
ffffffffc0201fe2:	079a                	slli	a5,a5,0x6
ffffffffc0201fe4:	97b6                	add	a5,a5,a3
ffffffffc0201fe6:	58fa1e63          	bne	s4,a5,ffffffffc0202582 <pmm_init+0x934>
ffffffffc0201fea:	8b41                	andi	a4,a4,16
ffffffffc0201fec:	56071b63          	bnez	a4,ffffffffc0202562 <pmm_init+0x914>
ffffffffc0201ff0:	00093503          	ld	a0,0(s2)
ffffffffc0201ff4:	4581                	li	a1,0
ffffffffc0201ff6:	ac7ff0ef          	jal	ra,ffffffffc0201abc <page_remove>
ffffffffc0201ffa:	000a2c83          	lw	s9,0(s4)
ffffffffc0201ffe:	4785                	li	a5,1
ffffffffc0202000:	5cfc9163          	bne	s9,a5,ffffffffc02025c2 <pmm_init+0x974>
ffffffffc0202004:	000c2783          	lw	a5,0(s8)
ffffffffc0202008:	58079d63          	bnez	a5,ffffffffc02025a2 <pmm_init+0x954>
ffffffffc020200c:	00093503          	ld	a0,0(s2)
ffffffffc0202010:	6585                	lui	a1,0x1
ffffffffc0202012:	aabff0ef          	jal	ra,ffffffffc0201abc <page_remove>
ffffffffc0202016:	000a2783          	lw	a5,0(s4)
ffffffffc020201a:	200793e3          	bnez	a5,ffffffffc0202a20 <pmm_init+0xdd2>
ffffffffc020201e:	000c2783          	lw	a5,0(s8)
ffffffffc0202022:	1c079fe3          	bnez	a5,ffffffffc0202a00 <pmm_init+0xdb2>
ffffffffc0202026:	00093a03          	ld	s4,0(s2)
ffffffffc020202a:	608c                	ld	a1,0(s1)
ffffffffc020202c:	000a3683          	ld	a3,0(s4)
ffffffffc0202030:	068a                	slli	a3,a3,0x2
ffffffffc0202032:	82b1                	srli	a3,a3,0xc
ffffffffc0202034:	4cb6f563          	bgeu	a3,a1,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc0202038:	000bb503          	ld	a0,0(s7)
ffffffffc020203c:	96d6                	add	a3,a3,s5
ffffffffc020203e:	069a                	slli	a3,a3,0x6
ffffffffc0202040:	00d507b3          	add	a5,a0,a3
ffffffffc0202044:	439c                	lw	a5,0(a5)
ffffffffc0202046:	4f979e63          	bne	a5,s9,ffffffffc0202542 <pmm_init+0x8f4>
ffffffffc020204a:	8699                	srai	a3,a3,0x6
ffffffffc020204c:	00080637          	lui	a2,0x80
ffffffffc0202050:	96b2                	add	a3,a3,a2
ffffffffc0202052:	00c69713          	slli	a4,a3,0xc
ffffffffc0202056:	8331                	srli	a4,a4,0xc
ffffffffc0202058:	06b2                	slli	a3,a3,0xc
ffffffffc020205a:	06b773e3          	bgeu	a4,a1,ffffffffc02028c0 <pmm_init+0xc72>
ffffffffc020205e:	0009b703          	ld	a4,0(s3)
ffffffffc0202062:	96ba                	add	a3,a3,a4
ffffffffc0202064:	629c                	ld	a5,0(a3)
ffffffffc0202066:	078a                	slli	a5,a5,0x2
ffffffffc0202068:	83b1                	srli	a5,a5,0xc
ffffffffc020206a:	48b7fa63          	bgeu	a5,a1,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc020206e:	8f91                	sub	a5,a5,a2
ffffffffc0202070:	079a                	slli	a5,a5,0x6
ffffffffc0202072:	953e                	add	a0,a0,a5
ffffffffc0202074:	100027f3          	csrr	a5,sstatus
ffffffffc0202078:	8b89                	andi	a5,a5,2
ffffffffc020207a:	32079463          	bnez	a5,ffffffffc02023a2 <pmm_init+0x754>
ffffffffc020207e:	000b3783          	ld	a5,0(s6)
ffffffffc0202082:	4585                	li	a1,1
ffffffffc0202084:	739c                	ld	a5,32(a5)
ffffffffc0202086:	9782                	jalr	a5
ffffffffc0202088:	000a3783          	ld	a5,0(s4)
ffffffffc020208c:	6098                	ld	a4,0(s1)
ffffffffc020208e:	078a                	slli	a5,a5,0x2
ffffffffc0202090:	83b1                	srli	a5,a5,0xc
ffffffffc0202092:	46e7f663          	bgeu	a5,a4,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc0202096:	000bb503          	ld	a0,0(s7)
ffffffffc020209a:	fff80737          	lui	a4,0xfff80
ffffffffc020209e:	97ba                	add	a5,a5,a4
ffffffffc02020a0:	079a                	slli	a5,a5,0x6
ffffffffc02020a2:	953e                	add	a0,a0,a5
ffffffffc02020a4:	100027f3          	csrr	a5,sstatus
ffffffffc02020a8:	8b89                	andi	a5,a5,2
ffffffffc02020aa:	2e079063          	bnez	a5,ffffffffc020238a <pmm_init+0x73c>
ffffffffc02020ae:	000b3783          	ld	a5,0(s6)
ffffffffc02020b2:	4585                	li	a1,1
ffffffffc02020b4:	739c                	ld	a5,32(a5)
ffffffffc02020b6:	9782                	jalr	a5
ffffffffc02020b8:	00093783          	ld	a5,0(s2)
ffffffffc02020bc:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc02020c0:	12000073          	sfence.vma
ffffffffc02020c4:	100027f3          	csrr	a5,sstatus
ffffffffc02020c8:	8b89                	andi	a5,a5,2
ffffffffc02020ca:	2a079663          	bnez	a5,ffffffffc0202376 <pmm_init+0x728>
ffffffffc02020ce:	000b3783          	ld	a5,0(s6)
ffffffffc02020d2:	779c                	ld	a5,40(a5)
ffffffffc02020d4:	9782                	jalr	a5
ffffffffc02020d6:	8a2a                	mv	s4,a0
ffffffffc02020d8:	7d441463          	bne	s0,s4,ffffffffc02028a0 <pmm_init+0xc52>
ffffffffc02020dc:	0000a517          	auipc	a0,0xa
ffffffffc02020e0:	44c50513          	addi	a0,a0,1100 # ffffffffc020c528 <commands+0xe60>
ffffffffc02020e4:	846fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02020e8:	100027f3          	csrr	a5,sstatus
ffffffffc02020ec:	8b89                	andi	a5,a5,2
ffffffffc02020ee:	26079a63          	bnez	a5,ffffffffc0202362 <pmm_init+0x714>
ffffffffc02020f2:	000b3783          	ld	a5,0(s6)
ffffffffc02020f6:	779c                	ld	a5,40(a5)
ffffffffc02020f8:	9782                	jalr	a5
ffffffffc02020fa:	8c2a                	mv	s8,a0
ffffffffc02020fc:	6098                	ld	a4,0(s1)
ffffffffc02020fe:	c0200437          	lui	s0,0xc0200
ffffffffc0202102:	7afd                	lui	s5,0xfffff
ffffffffc0202104:	00c71793          	slli	a5,a4,0xc
ffffffffc0202108:	6a05                	lui	s4,0x1
ffffffffc020210a:	02f47c63          	bgeu	s0,a5,ffffffffc0202142 <pmm_init+0x4f4>
ffffffffc020210e:	00c45793          	srli	a5,s0,0xc
ffffffffc0202112:	00093503          	ld	a0,0(s2)
ffffffffc0202116:	3ae7f763          	bgeu	a5,a4,ffffffffc02024c4 <pmm_init+0x876>
ffffffffc020211a:	0009b583          	ld	a1,0(s3)
ffffffffc020211e:	4601                	li	a2,0
ffffffffc0202120:	95a2                	add	a1,a1,s0
ffffffffc0202122:	a80ff0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0202126:	36050f63          	beqz	a0,ffffffffc02024a4 <pmm_init+0x856>
ffffffffc020212a:	611c                	ld	a5,0(a0)
ffffffffc020212c:	078a                	slli	a5,a5,0x2
ffffffffc020212e:	0157f7b3          	and	a5,a5,s5
ffffffffc0202132:	3a879663          	bne	a5,s0,ffffffffc02024de <pmm_init+0x890>
ffffffffc0202136:	6098                	ld	a4,0(s1)
ffffffffc0202138:	9452                	add	s0,s0,s4
ffffffffc020213a:	00c71793          	slli	a5,a4,0xc
ffffffffc020213e:	fcf468e3          	bltu	s0,a5,ffffffffc020210e <pmm_init+0x4c0>
ffffffffc0202142:	00093783          	ld	a5,0(s2)
ffffffffc0202146:	639c                	ld	a5,0(a5)
ffffffffc0202148:	48079d63          	bnez	a5,ffffffffc02025e2 <pmm_init+0x994>
ffffffffc020214c:	100027f3          	csrr	a5,sstatus
ffffffffc0202150:	8b89                	andi	a5,a5,2
ffffffffc0202152:	26079463          	bnez	a5,ffffffffc02023ba <pmm_init+0x76c>
ffffffffc0202156:	000b3783          	ld	a5,0(s6)
ffffffffc020215a:	4505                	li	a0,1
ffffffffc020215c:	6f9c                	ld	a5,24(a5)
ffffffffc020215e:	9782                	jalr	a5
ffffffffc0202160:	8a2a                	mv	s4,a0
ffffffffc0202162:	00093503          	ld	a0,0(s2)
ffffffffc0202166:	4699                	li	a3,6
ffffffffc0202168:	10000613          	li	a2,256
ffffffffc020216c:	85d2                	mv	a1,s4
ffffffffc020216e:	9ebff0ef          	jal	ra,ffffffffc0201b58 <page_insert>
ffffffffc0202172:	4a051863          	bnez	a0,ffffffffc0202622 <pmm_init+0x9d4>
ffffffffc0202176:	000a2703          	lw	a4,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020217a:	4785                	li	a5,1
ffffffffc020217c:	48f71363          	bne	a4,a5,ffffffffc0202602 <pmm_init+0x9b4>
ffffffffc0202180:	00093503          	ld	a0,0(s2)
ffffffffc0202184:	6405                	lui	s0,0x1
ffffffffc0202186:	4699                	li	a3,6
ffffffffc0202188:	10040613          	addi	a2,s0,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc020218c:	85d2                	mv	a1,s4
ffffffffc020218e:	9cbff0ef          	jal	ra,ffffffffc0201b58 <page_insert>
ffffffffc0202192:	38051863          	bnez	a0,ffffffffc0202522 <pmm_init+0x8d4>
ffffffffc0202196:	000a2703          	lw	a4,0(s4)
ffffffffc020219a:	4789                	li	a5,2
ffffffffc020219c:	4ef71363          	bne	a4,a5,ffffffffc0202682 <pmm_init+0xa34>
ffffffffc02021a0:	0000a597          	auipc	a1,0xa
ffffffffc02021a4:	4d058593          	addi	a1,a1,1232 # ffffffffc020c670 <commands+0xfa8>
ffffffffc02021a8:	10000513          	li	a0,256
ffffffffc02021ac:	509080ef          	jal	ra,ffffffffc020aeb4 <strcpy>
ffffffffc02021b0:	10040593          	addi	a1,s0,256
ffffffffc02021b4:	10000513          	li	a0,256
ffffffffc02021b8:	50f080ef          	jal	ra,ffffffffc020aec6 <strcmp>
ffffffffc02021bc:	4a051363          	bnez	a0,ffffffffc0202662 <pmm_init+0xa14>
ffffffffc02021c0:	000bb683          	ld	a3,0(s7)
ffffffffc02021c4:	00080737          	lui	a4,0x80
ffffffffc02021c8:	547d                	li	s0,-1
ffffffffc02021ca:	40da06b3          	sub	a3,s4,a3
ffffffffc02021ce:	8699                	srai	a3,a3,0x6
ffffffffc02021d0:	609c                	ld	a5,0(s1)
ffffffffc02021d2:	96ba                	add	a3,a3,a4
ffffffffc02021d4:	8031                	srli	s0,s0,0xc
ffffffffc02021d6:	0086f733          	and	a4,a3,s0
ffffffffc02021da:	06b2                	slli	a3,a3,0xc
ffffffffc02021dc:	6ef77263          	bgeu	a4,a5,ffffffffc02028c0 <pmm_init+0xc72>
ffffffffc02021e0:	0009b783          	ld	a5,0(s3)
ffffffffc02021e4:	10000513          	li	a0,256
ffffffffc02021e8:	96be                	add	a3,a3,a5
ffffffffc02021ea:	10068023          	sb	zero,256(a3)
ffffffffc02021ee:	491080ef          	jal	ra,ffffffffc020ae7e <strlen>
ffffffffc02021f2:	44051863          	bnez	a0,ffffffffc0202642 <pmm_init+0x9f4>
ffffffffc02021f6:	00093a83          	ld	s5,0(s2)
ffffffffc02021fa:	609c                	ld	a5,0(s1)
ffffffffc02021fc:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202200:	068a                	slli	a3,a3,0x2
ffffffffc0202202:	82b1                	srli	a3,a3,0xc
ffffffffc0202204:	2ef6fd63          	bgeu	a3,a5,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc0202208:	8c75                	and	s0,s0,a3
ffffffffc020220a:	06b2                	slli	a3,a3,0xc
ffffffffc020220c:	6af47a63          	bgeu	s0,a5,ffffffffc02028c0 <pmm_init+0xc72>
ffffffffc0202210:	0009b403          	ld	s0,0(s3)
ffffffffc0202214:	9436                	add	s0,s0,a3
ffffffffc0202216:	100027f3          	csrr	a5,sstatus
ffffffffc020221a:	8b89                	andi	a5,a5,2
ffffffffc020221c:	1e079c63          	bnez	a5,ffffffffc0202414 <pmm_init+0x7c6>
ffffffffc0202220:	000b3783          	ld	a5,0(s6)
ffffffffc0202224:	4585                	li	a1,1
ffffffffc0202226:	8552                	mv	a0,s4
ffffffffc0202228:	739c                	ld	a5,32(a5)
ffffffffc020222a:	9782                	jalr	a5
ffffffffc020222c:	601c                	ld	a5,0(s0)
ffffffffc020222e:	6098                	ld	a4,0(s1)
ffffffffc0202230:	078a                	slli	a5,a5,0x2
ffffffffc0202232:	83b1                	srli	a5,a5,0xc
ffffffffc0202234:	2ce7f563          	bgeu	a5,a4,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc0202238:	000bb503          	ld	a0,0(s7)
ffffffffc020223c:	fff80737          	lui	a4,0xfff80
ffffffffc0202240:	97ba                	add	a5,a5,a4
ffffffffc0202242:	079a                	slli	a5,a5,0x6
ffffffffc0202244:	953e                	add	a0,a0,a5
ffffffffc0202246:	100027f3          	csrr	a5,sstatus
ffffffffc020224a:	8b89                	andi	a5,a5,2
ffffffffc020224c:	1a079863          	bnez	a5,ffffffffc02023fc <pmm_init+0x7ae>
ffffffffc0202250:	000b3783          	ld	a5,0(s6)
ffffffffc0202254:	4585                	li	a1,1
ffffffffc0202256:	739c                	ld	a5,32(a5)
ffffffffc0202258:	9782                	jalr	a5
ffffffffc020225a:	000ab783          	ld	a5,0(s5)
ffffffffc020225e:	6098                	ld	a4,0(s1)
ffffffffc0202260:	078a                	slli	a5,a5,0x2
ffffffffc0202262:	83b1                	srli	a5,a5,0xc
ffffffffc0202264:	28e7fd63          	bgeu	a5,a4,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc0202268:	000bb503          	ld	a0,0(s7)
ffffffffc020226c:	fff80737          	lui	a4,0xfff80
ffffffffc0202270:	97ba                	add	a5,a5,a4
ffffffffc0202272:	079a                	slli	a5,a5,0x6
ffffffffc0202274:	953e                	add	a0,a0,a5
ffffffffc0202276:	100027f3          	csrr	a5,sstatus
ffffffffc020227a:	8b89                	andi	a5,a5,2
ffffffffc020227c:	16079463          	bnez	a5,ffffffffc02023e4 <pmm_init+0x796>
ffffffffc0202280:	000b3783          	ld	a5,0(s6)
ffffffffc0202284:	4585                	li	a1,1
ffffffffc0202286:	739c                	ld	a5,32(a5)
ffffffffc0202288:	9782                	jalr	a5
ffffffffc020228a:	00093783          	ld	a5,0(s2)
ffffffffc020228e:	0007b023          	sd	zero,0(a5)
ffffffffc0202292:	12000073          	sfence.vma
ffffffffc0202296:	100027f3          	csrr	a5,sstatus
ffffffffc020229a:	8b89                	andi	a5,a5,2
ffffffffc020229c:	12079a63          	bnez	a5,ffffffffc02023d0 <pmm_init+0x782>
ffffffffc02022a0:	000b3783          	ld	a5,0(s6)
ffffffffc02022a4:	779c                	ld	a5,40(a5)
ffffffffc02022a6:	9782                	jalr	a5
ffffffffc02022a8:	842a                	mv	s0,a0
ffffffffc02022aa:	488c1e63          	bne	s8,s0,ffffffffc0202746 <pmm_init+0xaf8>
ffffffffc02022ae:	0000a517          	auipc	a0,0xa
ffffffffc02022b2:	43a50513          	addi	a0,a0,1082 # ffffffffc020c6e8 <commands+0x1020>
ffffffffc02022b6:	e75fd0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02022ba:	7406                	ld	s0,96(sp)
ffffffffc02022bc:	70a6                	ld	ra,104(sp)
ffffffffc02022be:	64e6                	ld	s1,88(sp)
ffffffffc02022c0:	6946                	ld	s2,80(sp)
ffffffffc02022c2:	69a6                	ld	s3,72(sp)
ffffffffc02022c4:	6a06                	ld	s4,64(sp)
ffffffffc02022c6:	7ae2                	ld	s5,56(sp)
ffffffffc02022c8:	7b42                	ld	s6,48(sp)
ffffffffc02022ca:	7ba2                	ld	s7,40(sp)
ffffffffc02022cc:	7c02                	ld	s8,32(sp)
ffffffffc02022ce:	6ce2                	ld	s9,24(sp)
ffffffffc02022d0:	6165                	addi	sp,sp,112
ffffffffc02022d2:	4cc0106f          	j	ffffffffc020379e <kmalloc_init>
ffffffffc02022d6:	c80007b7          	lui	a5,0xc8000
ffffffffc02022da:	b411                	j	ffffffffc0201cde <pmm_init+0x90>
ffffffffc02022dc:	ac5fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02022e0:	000b3783          	ld	a5,0(s6)
ffffffffc02022e4:	4505                	li	a0,1
ffffffffc02022e6:	6f9c                	ld	a5,24(a5)
ffffffffc02022e8:	9782                	jalr	a5
ffffffffc02022ea:	8c2a                	mv	s8,a0
ffffffffc02022ec:	aaffe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02022f0:	b9a9                	j	ffffffffc0201f4a <pmm_init+0x2fc>
ffffffffc02022f2:	aaffe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02022f6:	000b3783          	ld	a5,0(s6)
ffffffffc02022fa:	4505                	li	a0,1
ffffffffc02022fc:	6f9c                	ld	a5,24(a5)
ffffffffc02022fe:	9782                	jalr	a5
ffffffffc0202300:	8a2a                	mv	s4,a0
ffffffffc0202302:	a99fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202306:	b645                	j	ffffffffc0201ea6 <pmm_init+0x258>
ffffffffc0202308:	a99fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020230c:	000b3783          	ld	a5,0(s6)
ffffffffc0202310:	779c                	ld	a5,40(a5)
ffffffffc0202312:	9782                	jalr	a5
ffffffffc0202314:	842a                	mv	s0,a0
ffffffffc0202316:	a85fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020231a:	b6b9                	j	ffffffffc0201e68 <pmm_init+0x21a>
ffffffffc020231c:	a85fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202320:	000b3783          	ld	a5,0(s6)
ffffffffc0202324:	4505                	li	a0,1
ffffffffc0202326:	6f9c                	ld	a5,24(a5)
ffffffffc0202328:	9782                	jalr	a5
ffffffffc020232a:	842a                	mv	s0,a0
ffffffffc020232c:	a6ffe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202330:	bc99                	j	ffffffffc0201d86 <pmm_init+0x138>
ffffffffc0202332:	6705                	lui	a4,0x1
ffffffffc0202334:	177d                	addi	a4,a4,-1
ffffffffc0202336:	96ba                	add	a3,a3,a4
ffffffffc0202338:	8ff5                	and	a5,a5,a3
ffffffffc020233a:	00c7d713          	srli	a4,a5,0xc
ffffffffc020233e:	1ca77063          	bgeu	a4,a0,ffffffffc02024fe <pmm_init+0x8b0>
ffffffffc0202342:	000b3683          	ld	a3,0(s6)
ffffffffc0202346:	fff80537          	lui	a0,0xfff80
ffffffffc020234a:	972a                	add	a4,a4,a0
ffffffffc020234c:	6a94                	ld	a3,16(a3)
ffffffffc020234e:	8c1d                	sub	s0,s0,a5
ffffffffc0202350:	00671513          	slli	a0,a4,0x6
ffffffffc0202354:	00c45593          	srli	a1,s0,0xc
ffffffffc0202358:	9532                	add	a0,a0,a2
ffffffffc020235a:	9682                	jalr	a3
ffffffffc020235c:	0009b583          	ld	a1,0(s3)
ffffffffc0202360:	bac5                	j	ffffffffc0201d50 <pmm_init+0x102>
ffffffffc0202362:	a3ffe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202366:	000b3783          	ld	a5,0(s6)
ffffffffc020236a:	779c                	ld	a5,40(a5)
ffffffffc020236c:	9782                	jalr	a5
ffffffffc020236e:	8c2a                	mv	s8,a0
ffffffffc0202370:	a2bfe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202374:	b361                	j	ffffffffc02020fc <pmm_init+0x4ae>
ffffffffc0202376:	a2bfe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020237a:	000b3783          	ld	a5,0(s6)
ffffffffc020237e:	779c                	ld	a5,40(a5)
ffffffffc0202380:	9782                	jalr	a5
ffffffffc0202382:	8a2a                	mv	s4,a0
ffffffffc0202384:	a17fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202388:	bb81                	j	ffffffffc02020d8 <pmm_init+0x48a>
ffffffffc020238a:	e42a                	sd	a0,8(sp)
ffffffffc020238c:	a15fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202390:	000b3783          	ld	a5,0(s6)
ffffffffc0202394:	6522                	ld	a0,8(sp)
ffffffffc0202396:	4585                	li	a1,1
ffffffffc0202398:	739c                	ld	a5,32(a5)
ffffffffc020239a:	9782                	jalr	a5
ffffffffc020239c:	9fffe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02023a0:	bb21                	j	ffffffffc02020b8 <pmm_init+0x46a>
ffffffffc02023a2:	e42a                	sd	a0,8(sp)
ffffffffc02023a4:	9fdfe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02023a8:	000b3783          	ld	a5,0(s6)
ffffffffc02023ac:	6522                	ld	a0,8(sp)
ffffffffc02023ae:	4585                	li	a1,1
ffffffffc02023b0:	739c                	ld	a5,32(a5)
ffffffffc02023b2:	9782                	jalr	a5
ffffffffc02023b4:	9e7fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02023b8:	b9c1                	j	ffffffffc0202088 <pmm_init+0x43a>
ffffffffc02023ba:	9e7fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02023be:	000b3783          	ld	a5,0(s6)
ffffffffc02023c2:	4505                	li	a0,1
ffffffffc02023c4:	6f9c                	ld	a5,24(a5)
ffffffffc02023c6:	9782                	jalr	a5
ffffffffc02023c8:	8a2a                	mv	s4,a0
ffffffffc02023ca:	9d1fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02023ce:	bb51                	j	ffffffffc0202162 <pmm_init+0x514>
ffffffffc02023d0:	9d1fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02023d4:	000b3783          	ld	a5,0(s6)
ffffffffc02023d8:	779c                	ld	a5,40(a5)
ffffffffc02023da:	9782                	jalr	a5
ffffffffc02023dc:	842a                	mv	s0,a0
ffffffffc02023de:	9bdfe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02023e2:	b5e1                	j	ffffffffc02022aa <pmm_init+0x65c>
ffffffffc02023e4:	e42a                	sd	a0,8(sp)
ffffffffc02023e6:	9bbfe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02023ea:	000b3783          	ld	a5,0(s6)
ffffffffc02023ee:	6522                	ld	a0,8(sp)
ffffffffc02023f0:	4585                	li	a1,1
ffffffffc02023f2:	739c                	ld	a5,32(a5)
ffffffffc02023f4:	9782                	jalr	a5
ffffffffc02023f6:	9a5fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02023fa:	bd41                	j	ffffffffc020228a <pmm_init+0x63c>
ffffffffc02023fc:	e42a                	sd	a0,8(sp)
ffffffffc02023fe:	9a3fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202402:	000b3783          	ld	a5,0(s6)
ffffffffc0202406:	6522                	ld	a0,8(sp)
ffffffffc0202408:	4585                	li	a1,1
ffffffffc020240a:	739c                	ld	a5,32(a5)
ffffffffc020240c:	9782                	jalr	a5
ffffffffc020240e:	98dfe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202412:	b5a1                	j	ffffffffc020225a <pmm_init+0x60c>
ffffffffc0202414:	98dfe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202418:	000b3783          	ld	a5,0(s6)
ffffffffc020241c:	4585                	li	a1,1
ffffffffc020241e:	8552                	mv	a0,s4
ffffffffc0202420:	739c                	ld	a5,32(a5)
ffffffffc0202422:	9782                	jalr	a5
ffffffffc0202424:	977fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202428:	b511                	j	ffffffffc020222c <pmm_init+0x5de>
ffffffffc020242a:	00011417          	auipc	s0,0x11
ffffffffc020242e:	bd640413          	addi	s0,s0,-1066 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0202432:	00011797          	auipc	a5,0x11
ffffffffc0202436:	bce78793          	addi	a5,a5,-1074 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc020243a:	a0f41de3          	bne	s0,a5,ffffffffc0201e54 <pmm_init+0x206>
ffffffffc020243e:	4581                	li	a1,0
ffffffffc0202440:	6605                	lui	a2,0x1
ffffffffc0202442:	8522                	mv	a0,s0
ffffffffc0202444:	2dd080ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0202448:	0000e597          	auipc	a1,0xe
ffffffffc020244c:	bb858593          	addi	a1,a1,-1096 # ffffffffc0210000 <bootstackguard>
ffffffffc0202450:	0000f797          	auipc	a5,0xf
ffffffffc0202454:	ba0787a3          	sb	zero,-1105(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc0202458:	0000e797          	auipc	a5,0xe
ffffffffc020245c:	ba078423          	sb	zero,-1112(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc0202460:	00093503          	ld	a0,0(s2)
ffffffffc0202464:	2555ec63          	bltu	a1,s5,ffffffffc02026bc <pmm_init+0xa6e>
ffffffffc0202468:	0009b683          	ld	a3,0(s3)
ffffffffc020246c:	4701                	li	a4,0
ffffffffc020246e:	6605                	lui	a2,0x1
ffffffffc0202470:	40d586b3          	sub	a3,a1,a3
ffffffffc0202474:	956ff0ef          	jal	ra,ffffffffc02015ca <boot_map_segment>
ffffffffc0202478:	00093503          	ld	a0,0(s2)
ffffffffc020247c:	23546363          	bltu	s0,s5,ffffffffc02026a2 <pmm_init+0xa54>
ffffffffc0202480:	0009b683          	ld	a3,0(s3)
ffffffffc0202484:	4701                	li	a4,0
ffffffffc0202486:	6605                	lui	a2,0x1
ffffffffc0202488:	40d406b3          	sub	a3,s0,a3
ffffffffc020248c:	85a2                	mv	a1,s0
ffffffffc020248e:	93cff0ef          	jal	ra,ffffffffc02015ca <boot_map_segment>
ffffffffc0202492:	12000073          	sfence.vma
ffffffffc0202496:	0000a517          	auipc	a0,0xa
ffffffffc020249a:	d6250513          	addi	a0,a0,-670 # ffffffffc020c1f8 <commands+0xb30>
ffffffffc020249e:	c8dfd0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02024a2:	ba4d                	j	ffffffffc0201e54 <pmm_init+0x206>
ffffffffc02024a4:	0000a697          	auipc	a3,0xa
ffffffffc02024a8:	0a468693          	addi	a3,a3,164 # ffffffffc020c548 <commands+0xe80>
ffffffffc02024ac:	00009617          	auipc	a2,0x9
ffffffffc02024b0:	46c60613          	addi	a2,a2,1132 # ffffffffc020b918 <commands+0x250>
ffffffffc02024b4:	28800593          	li	a1,648
ffffffffc02024b8:	0000a517          	auipc	a0,0xa
ffffffffc02024bc:	ba050513          	addi	a0,a0,-1120 # ffffffffc020c058 <commands+0x990>
ffffffffc02024c0:	d6ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02024c4:	86a2                	mv	a3,s0
ffffffffc02024c6:	0000a617          	auipc	a2,0xa
ffffffffc02024ca:	b6a60613          	addi	a2,a2,-1174 # ffffffffc020c030 <commands+0x968>
ffffffffc02024ce:	28800593          	li	a1,648
ffffffffc02024d2:	0000a517          	auipc	a0,0xa
ffffffffc02024d6:	b8650513          	addi	a0,a0,-1146 # ffffffffc020c058 <commands+0x990>
ffffffffc02024da:	d55fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02024de:	0000a697          	auipc	a3,0xa
ffffffffc02024e2:	0aa68693          	addi	a3,a3,170 # ffffffffc020c588 <commands+0xec0>
ffffffffc02024e6:	00009617          	auipc	a2,0x9
ffffffffc02024ea:	43260613          	addi	a2,a2,1074 # ffffffffc020b918 <commands+0x250>
ffffffffc02024ee:	28900593          	li	a1,649
ffffffffc02024f2:	0000a517          	auipc	a0,0xa
ffffffffc02024f6:	b6650513          	addi	a0,a0,-1178 # ffffffffc020c058 <commands+0x990>
ffffffffc02024fa:	d35fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02024fe:	db5fe0ef          	jal	ra,ffffffffc02012b2 <pa2page.part.0>
ffffffffc0202502:	0000a697          	auipc	a3,0xa
ffffffffc0202506:	eae68693          	addi	a3,a3,-338 # ffffffffc020c3b0 <commands+0xce8>
ffffffffc020250a:	00009617          	auipc	a2,0x9
ffffffffc020250e:	40e60613          	addi	a2,a2,1038 # ffffffffc020b918 <commands+0x250>
ffffffffc0202512:	26500593          	li	a1,613
ffffffffc0202516:	0000a517          	auipc	a0,0xa
ffffffffc020251a:	b4250513          	addi	a0,a0,-1214 # ffffffffc020c058 <commands+0x990>
ffffffffc020251e:	d11fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202522:	0000a697          	auipc	a3,0xa
ffffffffc0202526:	0ee68693          	addi	a3,a3,238 # ffffffffc020c610 <commands+0xf48>
ffffffffc020252a:	00009617          	auipc	a2,0x9
ffffffffc020252e:	3ee60613          	addi	a2,a2,1006 # ffffffffc020b918 <commands+0x250>
ffffffffc0202532:	29200593          	li	a1,658
ffffffffc0202536:	0000a517          	auipc	a0,0xa
ffffffffc020253a:	b2250513          	addi	a0,a0,-1246 # ffffffffc020c058 <commands+0x990>
ffffffffc020253e:	cf1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202542:	0000a697          	auipc	a3,0xa
ffffffffc0202546:	f8e68693          	addi	a3,a3,-114 # ffffffffc020c4d0 <commands+0xe08>
ffffffffc020254a:	00009617          	auipc	a2,0x9
ffffffffc020254e:	3ce60613          	addi	a2,a2,974 # ffffffffc020b918 <commands+0x250>
ffffffffc0202552:	27100593          	li	a1,625
ffffffffc0202556:	0000a517          	auipc	a0,0xa
ffffffffc020255a:	b0250513          	addi	a0,a0,-1278 # ffffffffc020c058 <commands+0x990>
ffffffffc020255e:	cd1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202562:	0000a697          	auipc	a3,0xa
ffffffffc0202566:	f3e68693          	addi	a3,a3,-194 # ffffffffc020c4a0 <commands+0xdd8>
ffffffffc020256a:	00009617          	auipc	a2,0x9
ffffffffc020256e:	3ae60613          	addi	a2,a2,942 # ffffffffc020b918 <commands+0x250>
ffffffffc0202572:	26700593          	li	a1,615
ffffffffc0202576:	0000a517          	auipc	a0,0xa
ffffffffc020257a:	ae250513          	addi	a0,a0,-1310 # ffffffffc020c058 <commands+0x990>
ffffffffc020257e:	cb1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202582:	0000a697          	auipc	a3,0xa
ffffffffc0202586:	d8e68693          	addi	a3,a3,-626 # ffffffffc020c310 <commands+0xc48>
ffffffffc020258a:	00009617          	auipc	a2,0x9
ffffffffc020258e:	38e60613          	addi	a2,a2,910 # ffffffffc020b918 <commands+0x250>
ffffffffc0202592:	26600593          	li	a1,614
ffffffffc0202596:	0000a517          	auipc	a0,0xa
ffffffffc020259a:	ac250513          	addi	a0,a0,-1342 # ffffffffc020c058 <commands+0x990>
ffffffffc020259e:	c91fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025a2:	0000a697          	auipc	a3,0xa
ffffffffc02025a6:	ee668693          	addi	a3,a3,-282 # ffffffffc020c488 <commands+0xdc0>
ffffffffc02025aa:	00009617          	auipc	a2,0x9
ffffffffc02025ae:	36e60613          	addi	a2,a2,878 # ffffffffc020b918 <commands+0x250>
ffffffffc02025b2:	26b00593          	li	a1,619
ffffffffc02025b6:	0000a517          	auipc	a0,0xa
ffffffffc02025ba:	aa250513          	addi	a0,a0,-1374 # ffffffffc020c058 <commands+0x990>
ffffffffc02025be:	c71fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025c2:	0000a697          	auipc	a3,0xa
ffffffffc02025c6:	d6668693          	addi	a3,a3,-666 # ffffffffc020c328 <commands+0xc60>
ffffffffc02025ca:	00009617          	auipc	a2,0x9
ffffffffc02025ce:	34e60613          	addi	a2,a2,846 # ffffffffc020b918 <commands+0x250>
ffffffffc02025d2:	26a00593          	li	a1,618
ffffffffc02025d6:	0000a517          	auipc	a0,0xa
ffffffffc02025da:	a8250513          	addi	a0,a0,-1406 # ffffffffc020c058 <commands+0x990>
ffffffffc02025de:	c51fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025e2:	0000a697          	auipc	a3,0xa
ffffffffc02025e6:	fbe68693          	addi	a3,a3,-66 # ffffffffc020c5a0 <commands+0xed8>
ffffffffc02025ea:	00009617          	auipc	a2,0x9
ffffffffc02025ee:	32e60613          	addi	a2,a2,814 # ffffffffc020b918 <commands+0x250>
ffffffffc02025f2:	28c00593          	li	a1,652
ffffffffc02025f6:	0000a517          	auipc	a0,0xa
ffffffffc02025fa:	a6250513          	addi	a0,a0,-1438 # ffffffffc020c058 <commands+0x990>
ffffffffc02025fe:	c31fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202602:	0000a697          	auipc	a3,0xa
ffffffffc0202606:	ff668693          	addi	a3,a3,-10 # ffffffffc020c5f8 <commands+0xf30>
ffffffffc020260a:	00009617          	auipc	a2,0x9
ffffffffc020260e:	30e60613          	addi	a2,a2,782 # ffffffffc020b918 <commands+0x250>
ffffffffc0202612:	29100593          	li	a1,657
ffffffffc0202616:	0000a517          	auipc	a0,0xa
ffffffffc020261a:	a4250513          	addi	a0,a0,-1470 # ffffffffc020c058 <commands+0x990>
ffffffffc020261e:	c11fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202622:	0000a697          	auipc	a3,0xa
ffffffffc0202626:	f9668693          	addi	a3,a3,-106 # ffffffffc020c5b8 <commands+0xef0>
ffffffffc020262a:	00009617          	auipc	a2,0x9
ffffffffc020262e:	2ee60613          	addi	a2,a2,750 # ffffffffc020b918 <commands+0x250>
ffffffffc0202632:	29000593          	li	a1,656
ffffffffc0202636:	0000a517          	auipc	a0,0xa
ffffffffc020263a:	a2250513          	addi	a0,a0,-1502 # ffffffffc020c058 <commands+0x990>
ffffffffc020263e:	bf1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202642:	0000a697          	auipc	a3,0xa
ffffffffc0202646:	07e68693          	addi	a3,a3,126 # ffffffffc020c6c0 <commands+0xff8>
ffffffffc020264a:	00009617          	auipc	a2,0x9
ffffffffc020264e:	2ce60613          	addi	a2,a2,718 # ffffffffc020b918 <commands+0x250>
ffffffffc0202652:	29a00593          	li	a1,666
ffffffffc0202656:	0000a517          	auipc	a0,0xa
ffffffffc020265a:	a0250513          	addi	a0,a0,-1534 # ffffffffc020c058 <commands+0x990>
ffffffffc020265e:	bd1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202662:	0000a697          	auipc	a3,0xa
ffffffffc0202666:	02668693          	addi	a3,a3,38 # ffffffffc020c688 <commands+0xfc0>
ffffffffc020266a:	00009617          	auipc	a2,0x9
ffffffffc020266e:	2ae60613          	addi	a2,a2,686 # ffffffffc020b918 <commands+0x250>
ffffffffc0202672:	29700593          	li	a1,663
ffffffffc0202676:	0000a517          	auipc	a0,0xa
ffffffffc020267a:	9e250513          	addi	a0,a0,-1566 # ffffffffc020c058 <commands+0x990>
ffffffffc020267e:	bb1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202682:	0000a697          	auipc	a3,0xa
ffffffffc0202686:	fd668693          	addi	a3,a3,-42 # ffffffffc020c658 <commands+0xf90>
ffffffffc020268a:	00009617          	auipc	a2,0x9
ffffffffc020268e:	28e60613          	addi	a2,a2,654 # ffffffffc020b918 <commands+0x250>
ffffffffc0202692:	29300593          	li	a1,659
ffffffffc0202696:	0000a517          	auipc	a0,0xa
ffffffffc020269a:	9c250513          	addi	a0,a0,-1598 # ffffffffc020c058 <commands+0x990>
ffffffffc020269e:	b91fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026a2:	86a2                	mv	a3,s0
ffffffffc02026a4:	0000a617          	auipc	a2,0xa
ffffffffc02026a8:	aac60613          	addi	a2,a2,-1364 # ffffffffc020c150 <commands+0xa88>
ffffffffc02026ac:	0dc00593          	li	a1,220
ffffffffc02026b0:	0000a517          	auipc	a0,0xa
ffffffffc02026b4:	9a850513          	addi	a0,a0,-1624 # ffffffffc020c058 <commands+0x990>
ffffffffc02026b8:	b77fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026bc:	86ae                	mv	a3,a1
ffffffffc02026be:	0000a617          	auipc	a2,0xa
ffffffffc02026c2:	a9260613          	addi	a2,a2,-1390 # ffffffffc020c150 <commands+0xa88>
ffffffffc02026c6:	0db00593          	li	a1,219
ffffffffc02026ca:	0000a517          	auipc	a0,0xa
ffffffffc02026ce:	98e50513          	addi	a0,a0,-1650 # ffffffffc020c058 <commands+0x990>
ffffffffc02026d2:	b5dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026d6:	0000a697          	auipc	a3,0xa
ffffffffc02026da:	b6a68693          	addi	a3,a3,-1174 # ffffffffc020c240 <commands+0xb78>
ffffffffc02026de:	00009617          	auipc	a2,0x9
ffffffffc02026e2:	23a60613          	addi	a2,a2,570 # ffffffffc020b918 <commands+0x250>
ffffffffc02026e6:	24a00593          	li	a1,586
ffffffffc02026ea:	0000a517          	auipc	a0,0xa
ffffffffc02026ee:	96e50513          	addi	a0,a0,-1682 # ffffffffc020c058 <commands+0x990>
ffffffffc02026f2:	b3dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026f6:	0000a697          	auipc	a3,0xa
ffffffffc02026fa:	b2a68693          	addi	a3,a3,-1238 # ffffffffc020c220 <commands+0xb58>
ffffffffc02026fe:	00009617          	auipc	a2,0x9
ffffffffc0202702:	21a60613          	addi	a2,a2,538 # ffffffffc020b918 <commands+0x250>
ffffffffc0202706:	24900593          	li	a1,585
ffffffffc020270a:	0000a517          	auipc	a0,0xa
ffffffffc020270e:	94e50513          	addi	a0,a0,-1714 # ffffffffc020c058 <commands+0x990>
ffffffffc0202712:	b1dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202716:	0000a617          	auipc	a2,0xa
ffffffffc020271a:	a9a60613          	addi	a2,a2,-1382 # ffffffffc020c1b0 <commands+0xae8>
ffffffffc020271e:	0aa00593          	li	a1,170
ffffffffc0202722:	0000a517          	auipc	a0,0xa
ffffffffc0202726:	93650513          	addi	a0,a0,-1738 # ffffffffc020c058 <commands+0x990>
ffffffffc020272a:	b05fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020272e:	0000a617          	auipc	a2,0xa
ffffffffc0202732:	9c260613          	addi	a2,a2,-1598 # ffffffffc020c0f0 <commands+0xa28>
ffffffffc0202736:	06500593          	li	a1,101
ffffffffc020273a:	0000a517          	auipc	a0,0xa
ffffffffc020273e:	91e50513          	addi	a0,a0,-1762 # ffffffffc020c058 <commands+0x990>
ffffffffc0202742:	aedfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202746:	0000a697          	auipc	a3,0xa
ffffffffc020274a:	dba68693          	addi	a3,a3,-582 # ffffffffc020c500 <commands+0xe38>
ffffffffc020274e:	00009617          	auipc	a2,0x9
ffffffffc0202752:	1ca60613          	addi	a2,a2,458 # ffffffffc020b918 <commands+0x250>
ffffffffc0202756:	2a300593          	li	a1,675
ffffffffc020275a:	0000a517          	auipc	a0,0xa
ffffffffc020275e:	8fe50513          	addi	a0,a0,-1794 # ffffffffc020c058 <commands+0x990>
ffffffffc0202762:	acdfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202766:	0000a697          	auipc	a3,0xa
ffffffffc020276a:	bda68693          	addi	a3,a3,-1062 # ffffffffc020c340 <commands+0xc78>
ffffffffc020276e:	00009617          	auipc	a2,0x9
ffffffffc0202772:	1aa60613          	addi	a2,a2,426 # ffffffffc020b918 <commands+0x250>
ffffffffc0202776:	25800593          	li	a1,600
ffffffffc020277a:	0000a517          	auipc	a0,0xa
ffffffffc020277e:	8de50513          	addi	a0,a0,-1826 # ffffffffc020c058 <commands+0x990>
ffffffffc0202782:	aadfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202786:	86d6                	mv	a3,s5
ffffffffc0202788:	0000a617          	auipc	a2,0xa
ffffffffc020278c:	8a860613          	addi	a2,a2,-1880 # ffffffffc020c030 <commands+0x968>
ffffffffc0202790:	25700593          	li	a1,599
ffffffffc0202794:	0000a517          	auipc	a0,0xa
ffffffffc0202798:	8c450513          	addi	a0,a0,-1852 # ffffffffc020c058 <commands+0x990>
ffffffffc020279c:	a93fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02027a0:	0000a697          	auipc	a3,0xa
ffffffffc02027a4:	ce868693          	addi	a3,a3,-792 # ffffffffc020c488 <commands+0xdc0>
ffffffffc02027a8:	00009617          	auipc	a2,0x9
ffffffffc02027ac:	17060613          	addi	a2,a2,368 # ffffffffc020b918 <commands+0x250>
ffffffffc02027b0:	26400593          	li	a1,612
ffffffffc02027b4:	0000a517          	auipc	a0,0xa
ffffffffc02027b8:	8a450513          	addi	a0,a0,-1884 # ffffffffc020c058 <commands+0x990>
ffffffffc02027bc:	a73fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02027c0:	0000a697          	auipc	a3,0xa
ffffffffc02027c4:	cb068693          	addi	a3,a3,-848 # ffffffffc020c470 <commands+0xda8>
ffffffffc02027c8:	00009617          	auipc	a2,0x9
ffffffffc02027cc:	15060613          	addi	a2,a2,336 # ffffffffc020b918 <commands+0x250>
ffffffffc02027d0:	26300593          	li	a1,611
ffffffffc02027d4:	0000a517          	auipc	a0,0xa
ffffffffc02027d8:	88450513          	addi	a0,a0,-1916 # ffffffffc020c058 <commands+0x990>
ffffffffc02027dc:	a53fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02027e0:	0000a697          	auipc	a3,0xa
ffffffffc02027e4:	c6068693          	addi	a3,a3,-928 # ffffffffc020c440 <commands+0xd78>
ffffffffc02027e8:	00009617          	auipc	a2,0x9
ffffffffc02027ec:	13060613          	addi	a2,a2,304 # ffffffffc020b918 <commands+0x250>
ffffffffc02027f0:	26200593          	li	a1,610
ffffffffc02027f4:	0000a517          	auipc	a0,0xa
ffffffffc02027f8:	86450513          	addi	a0,a0,-1948 # ffffffffc020c058 <commands+0x990>
ffffffffc02027fc:	a33fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202800:	0000a697          	auipc	a3,0xa
ffffffffc0202804:	c2868693          	addi	a3,a3,-984 # ffffffffc020c428 <commands+0xd60>
ffffffffc0202808:	00009617          	auipc	a2,0x9
ffffffffc020280c:	11060613          	addi	a2,a2,272 # ffffffffc020b918 <commands+0x250>
ffffffffc0202810:	26000593          	li	a1,608
ffffffffc0202814:	0000a517          	auipc	a0,0xa
ffffffffc0202818:	84450513          	addi	a0,a0,-1980 # ffffffffc020c058 <commands+0x990>
ffffffffc020281c:	a13fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202820:	0000a697          	auipc	a3,0xa
ffffffffc0202824:	be868693          	addi	a3,a3,-1048 # ffffffffc020c408 <commands+0xd40>
ffffffffc0202828:	00009617          	auipc	a2,0x9
ffffffffc020282c:	0f060613          	addi	a2,a2,240 # ffffffffc020b918 <commands+0x250>
ffffffffc0202830:	25f00593          	li	a1,607
ffffffffc0202834:	0000a517          	auipc	a0,0xa
ffffffffc0202838:	82450513          	addi	a0,a0,-2012 # ffffffffc020c058 <commands+0x990>
ffffffffc020283c:	9f3fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202840:	0000a697          	auipc	a3,0xa
ffffffffc0202844:	bb868693          	addi	a3,a3,-1096 # ffffffffc020c3f8 <commands+0xd30>
ffffffffc0202848:	00009617          	auipc	a2,0x9
ffffffffc020284c:	0d060613          	addi	a2,a2,208 # ffffffffc020b918 <commands+0x250>
ffffffffc0202850:	25e00593          	li	a1,606
ffffffffc0202854:	0000a517          	auipc	a0,0xa
ffffffffc0202858:	80450513          	addi	a0,a0,-2044 # ffffffffc020c058 <commands+0x990>
ffffffffc020285c:	9d3fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202860:	0000a697          	auipc	a3,0xa
ffffffffc0202864:	b8868693          	addi	a3,a3,-1144 # ffffffffc020c3e8 <commands+0xd20>
ffffffffc0202868:	00009617          	auipc	a2,0x9
ffffffffc020286c:	0b060613          	addi	a2,a2,176 # ffffffffc020b918 <commands+0x250>
ffffffffc0202870:	25d00593          	li	a1,605
ffffffffc0202874:	00009517          	auipc	a0,0x9
ffffffffc0202878:	7e450513          	addi	a0,a0,2020 # ffffffffc020c058 <commands+0x990>
ffffffffc020287c:	9b3fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202880:	0000a697          	auipc	a3,0xa
ffffffffc0202884:	b3068693          	addi	a3,a3,-1232 # ffffffffc020c3b0 <commands+0xce8>
ffffffffc0202888:	00009617          	auipc	a2,0x9
ffffffffc020288c:	09060613          	addi	a2,a2,144 # ffffffffc020b918 <commands+0x250>
ffffffffc0202890:	25c00593          	li	a1,604
ffffffffc0202894:	00009517          	auipc	a0,0x9
ffffffffc0202898:	7c450513          	addi	a0,a0,1988 # ffffffffc020c058 <commands+0x990>
ffffffffc020289c:	993fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02028a0:	0000a697          	auipc	a3,0xa
ffffffffc02028a4:	c6068693          	addi	a3,a3,-928 # ffffffffc020c500 <commands+0xe38>
ffffffffc02028a8:	00009617          	auipc	a2,0x9
ffffffffc02028ac:	07060613          	addi	a2,a2,112 # ffffffffc020b918 <commands+0x250>
ffffffffc02028b0:	27900593          	li	a1,633
ffffffffc02028b4:	00009517          	auipc	a0,0x9
ffffffffc02028b8:	7a450513          	addi	a0,a0,1956 # ffffffffc020c058 <commands+0x990>
ffffffffc02028bc:	973fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02028c0:	00009617          	auipc	a2,0x9
ffffffffc02028c4:	77060613          	addi	a2,a2,1904 # ffffffffc020c030 <commands+0x968>
ffffffffc02028c8:	07100593          	li	a1,113
ffffffffc02028cc:	00009517          	auipc	a0,0x9
ffffffffc02028d0:	72c50513          	addi	a0,a0,1836 # ffffffffc020bff8 <commands+0x930>
ffffffffc02028d4:	95bfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02028d8:	86a2                	mv	a3,s0
ffffffffc02028da:	0000a617          	auipc	a2,0xa
ffffffffc02028de:	87660613          	addi	a2,a2,-1930 # ffffffffc020c150 <commands+0xa88>
ffffffffc02028e2:	0ca00593          	li	a1,202
ffffffffc02028e6:	00009517          	auipc	a0,0x9
ffffffffc02028ea:	77250513          	addi	a0,a0,1906 # ffffffffc020c058 <commands+0x990>
ffffffffc02028ee:	941fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02028f2:	0000a617          	auipc	a2,0xa
ffffffffc02028f6:	85e60613          	addi	a2,a2,-1954 # ffffffffc020c150 <commands+0xa88>
ffffffffc02028fa:	08100593          	li	a1,129
ffffffffc02028fe:	00009517          	auipc	a0,0x9
ffffffffc0202902:	75a50513          	addi	a0,a0,1882 # ffffffffc020c058 <commands+0x990>
ffffffffc0202906:	929fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020290a:	0000a697          	auipc	a3,0xa
ffffffffc020290e:	a6668693          	addi	a3,a3,-1434 # ffffffffc020c370 <commands+0xca8>
ffffffffc0202912:	00009617          	auipc	a2,0x9
ffffffffc0202916:	00660613          	addi	a2,a2,6 # ffffffffc020b918 <commands+0x250>
ffffffffc020291a:	25b00593          	li	a1,603
ffffffffc020291e:	00009517          	auipc	a0,0x9
ffffffffc0202922:	73a50513          	addi	a0,a0,1850 # ffffffffc020c058 <commands+0x990>
ffffffffc0202926:	909fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020292a:	0000a697          	auipc	a3,0xa
ffffffffc020292e:	98668693          	addi	a3,a3,-1658 # ffffffffc020c2b0 <commands+0xbe8>
ffffffffc0202932:	00009617          	auipc	a2,0x9
ffffffffc0202936:	fe660613          	addi	a2,a2,-26 # ffffffffc020b918 <commands+0x250>
ffffffffc020293a:	24f00593          	li	a1,591
ffffffffc020293e:	00009517          	auipc	a0,0x9
ffffffffc0202942:	71a50513          	addi	a0,a0,1818 # ffffffffc020c058 <commands+0x990>
ffffffffc0202946:	8e9fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020294a:	985fe0ef          	jal	ra,ffffffffc02012ce <pte2page.part.0>
ffffffffc020294e:	0000a697          	auipc	a3,0xa
ffffffffc0202952:	99268693          	addi	a3,a3,-1646 # ffffffffc020c2e0 <commands+0xc18>
ffffffffc0202956:	00009617          	auipc	a2,0x9
ffffffffc020295a:	fc260613          	addi	a2,a2,-62 # ffffffffc020b918 <commands+0x250>
ffffffffc020295e:	25200593          	li	a1,594
ffffffffc0202962:	00009517          	auipc	a0,0x9
ffffffffc0202966:	6f650513          	addi	a0,a0,1782 # ffffffffc020c058 <commands+0x990>
ffffffffc020296a:	8c5fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020296e:	0000a697          	auipc	a3,0xa
ffffffffc0202972:	91268693          	addi	a3,a3,-1774 # ffffffffc020c280 <commands+0xbb8>
ffffffffc0202976:	00009617          	auipc	a2,0x9
ffffffffc020297a:	fa260613          	addi	a2,a2,-94 # ffffffffc020b918 <commands+0x250>
ffffffffc020297e:	24b00593          	li	a1,587
ffffffffc0202982:	00009517          	auipc	a0,0x9
ffffffffc0202986:	6d650513          	addi	a0,a0,1750 # ffffffffc020c058 <commands+0x990>
ffffffffc020298a:	8a5fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020298e:	0000a697          	auipc	a3,0xa
ffffffffc0202992:	98268693          	addi	a3,a3,-1662 # ffffffffc020c310 <commands+0xc48>
ffffffffc0202996:	00009617          	auipc	a2,0x9
ffffffffc020299a:	f8260613          	addi	a2,a2,-126 # ffffffffc020b918 <commands+0x250>
ffffffffc020299e:	25300593          	li	a1,595
ffffffffc02029a2:	00009517          	auipc	a0,0x9
ffffffffc02029a6:	6b650513          	addi	a0,a0,1718 # ffffffffc020c058 <commands+0x990>
ffffffffc02029aa:	885fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02029ae:	00009617          	auipc	a2,0x9
ffffffffc02029b2:	68260613          	addi	a2,a2,1666 # ffffffffc020c030 <commands+0x968>
ffffffffc02029b6:	25600593          	li	a1,598
ffffffffc02029ba:	00009517          	auipc	a0,0x9
ffffffffc02029be:	69e50513          	addi	a0,a0,1694 # ffffffffc020c058 <commands+0x990>
ffffffffc02029c2:	86dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02029c6:	0000a697          	auipc	a3,0xa
ffffffffc02029ca:	96268693          	addi	a3,a3,-1694 # ffffffffc020c328 <commands+0xc60>
ffffffffc02029ce:	00009617          	auipc	a2,0x9
ffffffffc02029d2:	f4a60613          	addi	a2,a2,-182 # ffffffffc020b918 <commands+0x250>
ffffffffc02029d6:	25400593          	li	a1,596
ffffffffc02029da:	00009517          	auipc	a0,0x9
ffffffffc02029de:	67e50513          	addi	a0,a0,1662 # ffffffffc020c058 <commands+0x990>
ffffffffc02029e2:	84dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02029e6:	86ca                	mv	a3,s2
ffffffffc02029e8:	00009617          	auipc	a2,0x9
ffffffffc02029ec:	76860613          	addi	a2,a2,1896 # ffffffffc020c150 <commands+0xa88>
ffffffffc02029f0:	0c600593          	li	a1,198
ffffffffc02029f4:	00009517          	auipc	a0,0x9
ffffffffc02029f8:	66450513          	addi	a0,a0,1636 # ffffffffc020c058 <commands+0x990>
ffffffffc02029fc:	833fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202a00:	0000a697          	auipc	a3,0xa
ffffffffc0202a04:	a8868693          	addi	a3,a3,-1400 # ffffffffc020c488 <commands+0xdc0>
ffffffffc0202a08:	00009617          	auipc	a2,0x9
ffffffffc0202a0c:	f1060613          	addi	a2,a2,-240 # ffffffffc020b918 <commands+0x250>
ffffffffc0202a10:	26f00593          	li	a1,623
ffffffffc0202a14:	00009517          	auipc	a0,0x9
ffffffffc0202a18:	64450513          	addi	a0,a0,1604 # ffffffffc020c058 <commands+0x990>
ffffffffc0202a1c:	813fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202a20:	0000a697          	auipc	a3,0xa
ffffffffc0202a24:	a9868693          	addi	a3,a3,-1384 # ffffffffc020c4b8 <commands+0xdf0>
ffffffffc0202a28:	00009617          	auipc	a2,0x9
ffffffffc0202a2c:	ef060613          	addi	a2,a2,-272 # ffffffffc020b918 <commands+0x250>
ffffffffc0202a30:	26e00593          	li	a1,622
ffffffffc0202a34:	00009517          	auipc	a0,0x9
ffffffffc0202a38:	62450513          	addi	a0,a0,1572 # ffffffffc020c058 <commands+0x990>
ffffffffc0202a3c:	ff2fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202a40 <copy_range>:
ffffffffc0202a40:	7159                	addi	sp,sp,-112
ffffffffc0202a42:	00d667b3          	or	a5,a2,a3
ffffffffc0202a46:	f486                	sd	ra,104(sp)
ffffffffc0202a48:	f0a2                	sd	s0,96(sp)
ffffffffc0202a4a:	eca6                	sd	s1,88(sp)
ffffffffc0202a4c:	e8ca                	sd	s2,80(sp)
ffffffffc0202a4e:	e4ce                	sd	s3,72(sp)
ffffffffc0202a50:	e0d2                	sd	s4,64(sp)
ffffffffc0202a52:	fc56                	sd	s5,56(sp)
ffffffffc0202a54:	f85a                	sd	s6,48(sp)
ffffffffc0202a56:	f45e                	sd	s7,40(sp)
ffffffffc0202a58:	f062                	sd	s8,32(sp)
ffffffffc0202a5a:	ec66                	sd	s9,24(sp)
ffffffffc0202a5c:	e86a                	sd	s10,16(sp)
ffffffffc0202a5e:	e46e                	sd	s11,8(sp)
ffffffffc0202a60:	17d2                	slli	a5,a5,0x34
ffffffffc0202a62:	20079f63          	bnez	a5,ffffffffc0202c80 <copy_range+0x240>
ffffffffc0202a66:	002007b7          	lui	a5,0x200
ffffffffc0202a6a:	8432                	mv	s0,a2
ffffffffc0202a6c:	1af66263          	bltu	a2,a5,ffffffffc0202c10 <copy_range+0x1d0>
ffffffffc0202a70:	8936                	mv	s2,a3
ffffffffc0202a72:	18d67f63          	bgeu	a2,a3,ffffffffc0202c10 <copy_range+0x1d0>
ffffffffc0202a76:	4785                	li	a5,1
ffffffffc0202a78:	07fe                	slli	a5,a5,0x1f
ffffffffc0202a7a:	18d7eb63          	bltu	a5,a3,ffffffffc0202c10 <copy_range+0x1d0>
ffffffffc0202a7e:	5b7d                	li	s6,-1
ffffffffc0202a80:	8aaa                	mv	s5,a0
ffffffffc0202a82:	89ae                	mv	s3,a1
ffffffffc0202a84:	6a05                	lui	s4,0x1
ffffffffc0202a86:	00094c17          	auipc	s8,0x94
ffffffffc0202a8a:	e12c0c13          	addi	s8,s8,-494 # ffffffffc0296898 <npage>
ffffffffc0202a8e:	00094b97          	auipc	s7,0x94
ffffffffc0202a92:	e12b8b93          	addi	s7,s7,-494 # ffffffffc02968a0 <pages>
ffffffffc0202a96:	00cb5b13          	srli	s6,s6,0xc
ffffffffc0202a9a:	00094c97          	auipc	s9,0x94
ffffffffc0202a9e:	e0ec8c93          	addi	s9,s9,-498 # ffffffffc02968a8 <pmm_manager>
ffffffffc0202aa2:	4601                	li	a2,0
ffffffffc0202aa4:	85a2                	mv	a1,s0
ffffffffc0202aa6:	854e                	mv	a0,s3
ffffffffc0202aa8:	8fbfe0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0202aac:	84aa                	mv	s1,a0
ffffffffc0202aae:	0e050c63          	beqz	a0,ffffffffc0202ba6 <copy_range+0x166>
ffffffffc0202ab2:	611c                	ld	a5,0(a0)
ffffffffc0202ab4:	8b85                	andi	a5,a5,1
ffffffffc0202ab6:	e785                	bnez	a5,ffffffffc0202ade <copy_range+0x9e>
ffffffffc0202ab8:	9452                	add	s0,s0,s4
ffffffffc0202aba:	ff2464e3          	bltu	s0,s2,ffffffffc0202aa2 <copy_range+0x62>
ffffffffc0202abe:	4501                	li	a0,0
ffffffffc0202ac0:	70a6                	ld	ra,104(sp)
ffffffffc0202ac2:	7406                	ld	s0,96(sp)
ffffffffc0202ac4:	64e6                	ld	s1,88(sp)
ffffffffc0202ac6:	6946                	ld	s2,80(sp)
ffffffffc0202ac8:	69a6                	ld	s3,72(sp)
ffffffffc0202aca:	6a06                	ld	s4,64(sp)
ffffffffc0202acc:	7ae2                	ld	s5,56(sp)
ffffffffc0202ace:	7b42                	ld	s6,48(sp)
ffffffffc0202ad0:	7ba2                	ld	s7,40(sp)
ffffffffc0202ad2:	7c02                	ld	s8,32(sp)
ffffffffc0202ad4:	6ce2                	ld	s9,24(sp)
ffffffffc0202ad6:	6d42                	ld	s10,16(sp)
ffffffffc0202ad8:	6da2                	ld	s11,8(sp)
ffffffffc0202ada:	6165                	addi	sp,sp,112
ffffffffc0202adc:	8082                	ret
ffffffffc0202ade:	4605                	li	a2,1
ffffffffc0202ae0:	85a2                	mv	a1,s0
ffffffffc0202ae2:	8556                	mv	a0,s5
ffffffffc0202ae4:	8bffe0ef          	jal	ra,ffffffffc02013a2 <get_pte>
ffffffffc0202ae8:	c56d                	beqz	a0,ffffffffc0202bd2 <copy_range+0x192>
ffffffffc0202aea:	609c                	ld	a5,0(s1)
ffffffffc0202aec:	0017f713          	andi	a4,a5,1
ffffffffc0202af0:	01f7f493          	andi	s1,a5,31
ffffffffc0202af4:	16070a63          	beqz	a4,ffffffffc0202c68 <copy_range+0x228>
ffffffffc0202af8:	000c3683          	ld	a3,0(s8)
ffffffffc0202afc:	078a                	slli	a5,a5,0x2
ffffffffc0202afe:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202b02:	14d77763          	bgeu	a4,a3,ffffffffc0202c50 <copy_range+0x210>
ffffffffc0202b06:	000bb783          	ld	a5,0(s7)
ffffffffc0202b0a:	fff806b7          	lui	a3,0xfff80
ffffffffc0202b0e:	9736                	add	a4,a4,a3
ffffffffc0202b10:	071a                	slli	a4,a4,0x6
ffffffffc0202b12:	00e78db3          	add	s11,a5,a4
ffffffffc0202b16:	10002773          	csrr	a4,sstatus
ffffffffc0202b1a:	8b09                	andi	a4,a4,2
ffffffffc0202b1c:	e345                	bnez	a4,ffffffffc0202bbc <copy_range+0x17c>
ffffffffc0202b1e:	000cb703          	ld	a4,0(s9)
ffffffffc0202b22:	4505                	li	a0,1
ffffffffc0202b24:	6f18                	ld	a4,24(a4)
ffffffffc0202b26:	9702                	jalr	a4
ffffffffc0202b28:	8d2a                	mv	s10,a0
ffffffffc0202b2a:	0c0d8363          	beqz	s11,ffffffffc0202bf0 <copy_range+0x1b0>
ffffffffc0202b2e:	100d0163          	beqz	s10,ffffffffc0202c30 <copy_range+0x1f0>
ffffffffc0202b32:	000bb703          	ld	a4,0(s7)
ffffffffc0202b36:	000805b7          	lui	a1,0x80
ffffffffc0202b3a:	000c3603          	ld	a2,0(s8)
ffffffffc0202b3e:	40ed86b3          	sub	a3,s11,a4
ffffffffc0202b42:	8699                	srai	a3,a3,0x6
ffffffffc0202b44:	96ae                	add	a3,a3,a1
ffffffffc0202b46:	0166f7b3          	and	a5,a3,s6
ffffffffc0202b4a:	06b2                	slli	a3,a3,0xc
ffffffffc0202b4c:	08c7f663          	bgeu	a5,a2,ffffffffc0202bd8 <copy_range+0x198>
ffffffffc0202b50:	40ed07b3          	sub	a5,s10,a4
ffffffffc0202b54:	00094717          	auipc	a4,0x94
ffffffffc0202b58:	d5c70713          	addi	a4,a4,-676 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0202b5c:	6308                	ld	a0,0(a4)
ffffffffc0202b5e:	8799                	srai	a5,a5,0x6
ffffffffc0202b60:	97ae                	add	a5,a5,a1
ffffffffc0202b62:	0167f733          	and	a4,a5,s6
ffffffffc0202b66:	00a685b3          	add	a1,a3,a0
ffffffffc0202b6a:	07b2                	slli	a5,a5,0xc
ffffffffc0202b6c:	06c77563          	bgeu	a4,a2,ffffffffc0202bd6 <copy_range+0x196>
ffffffffc0202b70:	6605                	lui	a2,0x1
ffffffffc0202b72:	953e                	add	a0,a0,a5
ffffffffc0202b74:	3fe080ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0202b78:	86a6                	mv	a3,s1
ffffffffc0202b7a:	8622                	mv	a2,s0
ffffffffc0202b7c:	85ea                	mv	a1,s10
ffffffffc0202b7e:	8556                	mv	a0,s5
ffffffffc0202b80:	fd9fe0ef          	jal	ra,ffffffffc0201b58 <page_insert>
ffffffffc0202b84:	d915                	beqz	a0,ffffffffc0202ab8 <copy_range+0x78>
ffffffffc0202b86:	0000a697          	auipc	a3,0xa
ffffffffc0202b8a:	ba268693          	addi	a3,a3,-1118 # ffffffffc020c728 <commands+0x1060>
ffffffffc0202b8e:	00009617          	auipc	a2,0x9
ffffffffc0202b92:	d8a60613          	addi	a2,a2,-630 # ffffffffc020b918 <commands+0x250>
ffffffffc0202b96:	1e700593          	li	a1,487
ffffffffc0202b9a:	00009517          	auipc	a0,0x9
ffffffffc0202b9e:	4be50513          	addi	a0,a0,1214 # ffffffffc020c058 <commands+0x990>
ffffffffc0202ba2:	e8cfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202ba6:	00200637          	lui	a2,0x200
ffffffffc0202baa:	9432                	add	s0,s0,a2
ffffffffc0202bac:	ffe00637          	lui	a2,0xffe00
ffffffffc0202bb0:	8c71                	and	s0,s0,a2
ffffffffc0202bb2:	f00406e3          	beqz	s0,ffffffffc0202abe <copy_range+0x7e>
ffffffffc0202bb6:	ef2466e3          	bltu	s0,s2,ffffffffc0202aa2 <copy_range+0x62>
ffffffffc0202bba:	b711                	j	ffffffffc0202abe <copy_range+0x7e>
ffffffffc0202bbc:	9e4fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202bc0:	000cb703          	ld	a4,0(s9)
ffffffffc0202bc4:	4505                	li	a0,1
ffffffffc0202bc6:	6f18                	ld	a4,24(a4)
ffffffffc0202bc8:	9702                	jalr	a4
ffffffffc0202bca:	8d2a                	mv	s10,a0
ffffffffc0202bcc:	9cefe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202bd0:	bfa9                	j	ffffffffc0202b2a <copy_range+0xea>
ffffffffc0202bd2:	5571                	li	a0,-4
ffffffffc0202bd4:	b5f5                	j	ffffffffc0202ac0 <copy_range+0x80>
ffffffffc0202bd6:	86be                	mv	a3,a5
ffffffffc0202bd8:	00009617          	auipc	a2,0x9
ffffffffc0202bdc:	45860613          	addi	a2,a2,1112 # ffffffffc020c030 <commands+0x968>
ffffffffc0202be0:	07100593          	li	a1,113
ffffffffc0202be4:	00009517          	auipc	a0,0x9
ffffffffc0202be8:	41450513          	addi	a0,a0,1044 # ffffffffc020bff8 <commands+0x930>
ffffffffc0202bec:	e42fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202bf0:	0000a697          	auipc	a3,0xa
ffffffffc0202bf4:	b1868693          	addi	a3,a3,-1256 # ffffffffc020c708 <commands+0x1040>
ffffffffc0202bf8:	00009617          	auipc	a2,0x9
ffffffffc0202bfc:	d2060613          	addi	a2,a2,-736 # ffffffffc020b918 <commands+0x250>
ffffffffc0202c00:	1ce00593          	li	a1,462
ffffffffc0202c04:	00009517          	auipc	a0,0x9
ffffffffc0202c08:	45450513          	addi	a0,a0,1108 # ffffffffc020c058 <commands+0x990>
ffffffffc0202c0c:	e22fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c10:	00009697          	auipc	a3,0x9
ffffffffc0202c14:	4b068693          	addi	a3,a3,1200 # ffffffffc020c0c0 <commands+0x9f8>
ffffffffc0202c18:	00009617          	auipc	a2,0x9
ffffffffc0202c1c:	d0060613          	addi	a2,a2,-768 # ffffffffc020b918 <commands+0x250>
ffffffffc0202c20:	1b600593          	li	a1,438
ffffffffc0202c24:	00009517          	auipc	a0,0x9
ffffffffc0202c28:	43450513          	addi	a0,a0,1076 # ffffffffc020c058 <commands+0x990>
ffffffffc0202c2c:	e02fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c30:	0000a697          	auipc	a3,0xa
ffffffffc0202c34:	ae868693          	addi	a3,a3,-1304 # ffffffffc020c718 <commands+0x1050>
ffffffffc0202c38:	00009617          	auipc	a2,0x9
ffffffffc0202c3c:	ce060613          	addi	a2,a2,-800 # ffffffffc020b918 <commands+0x250>
ffffffffc0202c40:	1cf00593          	li	a1,463
ffffffffc0202c44:	00009517          	auipc	a0,0x9
ffffffffc0202c48:	41450513          	addi	a0,a0,1044 # ffffffffc020c058 <commands+0x990>
ffffffffc0202c4c:	de2fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c50:	00009617          	auipc	a2,0x9
ffffffffc0202c54:	38860613          	addi	a2,a2,904 # ffffffffc020bfd8 <commands+0x910>
ffffffffc0202c58:	06900593          	li	a1,105
ffffffffc0202c5c:	00009517          	auipc	a0,0x9
ffffffffc0202c60:	39c50513          	addi	a0,a0,924 # ffffffffc020bff8 <commands+0x930>
ffffffffc0202c64:	dcafd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c68:	00009617          	auipc	a2,0x9
ffffffffc0202c6c:	3a060613          	addi	a2,a2,928 # ffffffffc020c008 <commands+0x940>
ffffffffc0202c70:	07f00593          	li	a1,127
ffffffffc0202c74:	00009517          	auipc	a0,0x9
ffffffffc0202c78:	38450513          	addi	a0,a0,900 # ffffffffc020bff8 <commands+0x930>
ffffffffc0202c7c:	db2fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c80:	00009697          	auipc	a3,0x9
ffffffffc0202c84:	41068693          	addi	a3,a3,1040 # ffffffffc020c090 <commands+0x9c8>
ffffffffc0202c88:	00009617          	auipc	a2,0x9
ffffffffc0202c8c:	c9060613          	addi	a2,a2,-880 # ffffffffc020b918 <commands+0x250>
ffffffffc0202c90:	1b500593          	li	a1,437
ffffffffc0202c94:	00009517          	auipc	a0,0x9
ffffffffc0202c98:	3c450513          	addi	a0,a0,964 # ffffffffc020c058 <commands+0x990>
ffffffffc0202c9c:	d92fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202ca0 <pgdir_alloc_page>:
ffffffffc0202ca0:	7179                	addi	sp,sp,-48
ffffffffc0202ca2:	ec26                	sd	s1,24(sp)
ffffffffc0202ca4:	e84a                	sd	s2,16(sp)
ffffffffc0202ca6:	e052                	sd	s4,0(sp)
ffffffffc0202ca8:	f406                	sd	ra,40(sp)
ffffffffc0202caa:	f022                	sd	s0,32(sp)
ffffffffc0202cac:	e44e                	sd	s3,8(sp)
ffffffffc0202cae:	8a2a                	mv	s4,a0
ffffffffc0202cb0:	84ae                	mv	s1,a1
ffffffffc0202cb2:	8932                	mv	s2,a2
ffffffffc0202cb4:	100027f3          	csrr	a5,sstatus
ffffffffc0202cb8:	8b89                	andi	a5,a5,2
ffffffffc0202cba:	00094997          	auipc	s3,0x94
ffffffffc0202cbe:	bee98993          	addi	s3,s3,-1042 # ffffffffc02968a8 <pmm_manager>
ffffffffc0202cc2:	ef8d                	bnez	a5,ffffffffc0202cfc <pgdir_alloc_page+0x5c>
ffffffffc0202cc4:	0009b783          	ld	a5,0(s3)
ffffffffc0202cc8:	4505                	li	a0,1
ffffffffc0202cca:	6f9c                	ld	a5,24(a5)
ffffffffc0202ccc:	9782                	jalr	a5
ffffffffc0202cce:	842a                	mv	s0,a0
ffffffffc0202cd0:	cc09                	beqz	s0,ffffffffc0202cea <pgdir_alloc_page+0x4a>
ffffffffc0202cd2:	86ca                	mv	a3,s2
ffffffffc0202cd4:	8626                	mv	a2,s1
ffffffffc0202cd6:	85a2                	mv	a1,s0
ffffffffc0202cd8:	8552                	mv	a0,s4
ffffffffc0202cda:	e7ffe0ef          	jal	ra,ffffffffc0201b58 <page_insert>
ffffffffc0202cde:	e915                	bnez	a0,ffffffffc0202d12 <pgdir_alloc_page+0x72>
ffffffffc0202ce0:	4018                	lw	a4,0(s0)
ffffffffc0202ce2:	fc04                	sd	s1,56(s0)
ffffffffc0202ce4:	4785                	li	a5,1
ffffffffc0202ce6:	04f71e63          	bne	a4,a5,ffffffffc0202d42 <pgdir_alloc_page+0xa2>
ffffffffc0202cea:	70a2                	ld	ra,40(sp)
ffffffffc0202cec:	8522                	mv	a0,s0
ffffffffc0202cee:	7402                	ld	s0,32(sp)
ffffffffc0202cf0:	64e2                	ld	s1,24(sp)
ffffffffc0202cf2:	6942                	ld	s2,16(sp)
ffffffffc0202cf4:	69a2                	ld	s3,8(sp)
ffffffffc0202cf6:	6a02                	ld	s4,0(sp)
ffffffffc0202cf8:	6145                	addi	sp,sp,48
ffffffffc0202cfa:	8082                	ret
ffffffffc0202cfc:	8a4fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202d00:	0009b783          	ld	a5,0(s3)
ffffffffc0202d04:	4505                	li	a0,1
ffffffffc0202d06:	6f9c                	ld	a5,24(a5)
ffffffffc0202d08:	9782                	jalr	a5
ffffffffc0202d0a:	842a                	mv	s0,a0
ffffffffc0202d0c:	88efe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202d10:	b7c1                	j	ffffffffc0202cd0 <pgdir_alloc_page+0x30>
ffffffffc0202d12:	100027f3          	csrr	a5,sstatus
ffffffffc0202d16:	8b89                	andi	a5,a5,2
ffffffffc0202d18:	eb89                	bnez	a5,ffffffffc0202d2a <pgdir_alloc_page+0x8a>
ffffffffc0202d1a:	0009b783          	ld	a5,0(s3)
ffffffffc0202d1e:	8522                	mv	a0,s0
ffffffffc0202d20:	4585                	li	a1,1
ffffffffc0202d22:	739c                	ld	a5,32(a5)
ffffffffc0202d24:	4401                	li	s0,0
ffffffffc0202d26:	9782                	jalr	a5
ffffffffc0202d28:	b7c9                	j	ffffffffc0202cea <pgdir_alloc_page+0x4a>
ffffffffc0202d2a:	876fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202d2e:	0009b783          	ld	a5,0(s3)
ffffffffc0202d32:	8522                	mv	a0,s0
ffffffffc0202d34:	4585                	li	a1,1
ffffffffc0202d36:	739c                	ld	a5,32(a5)
ffffffffc0202d38:	4401                	li	s0,0
ffffffffc0202d3a:	9782                	jalr	a5
ffffffffc0202d3c:	85efe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202d40:	b76d                	j	ffffffffc0202cea <pgdir_alloc_page+0x4a>
ffffffffc0202d42:	0000a697          	auipc	a3,0xa
ffffffffc0202d46:	9f668693          	addi	a3,a3,-1546 # ffffffffc020c738 <commands+0x1070>
ffffffffc0202d4a:	00009617          	auipc	a2,0x9
ffffffffc0202d4e:	bce60613          	addi	a2,a2,-1074 # ffffffffc020b918 <commands+0x250>
ffffffffc0202d52:	23000593          	li	a1,560
ffffffffc0202d56:	00009517          	auipc	a0,0x9
ffffffffc0202d5a:	30250513          	addi	a0,a0,770 # ffffffffc020c058 <commands+0x990>
ffffffffc0202d5e:	cd0fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202d62 <check_vma_overlap.part.0>:
ffffffffc0202d62:	1141                	addi	sp,sp,-16
ffffffffc0202d64:	0000a697          	auipc	a3,0xa
ffffffffc0202d68:	9ec68693          	addi	a3,a3,-1556 # ffffffffc020c750 <commands+0x1088>
ffffffffc0202d6c:	00009617          	auipc	a2,0x9
ffffffffc0202d70:	bac60613          	addi	a2,a2,-1108 # ffffffffc020b918 <commands+0x250>
ffffffffc0202d74:	07400593          	li	a1,116
ffffffffc0202d78:	0000a517          	auipc	a0,0xa
ffffffffc0202d7c:	9f850513          	addi	a0,a0,-1544 # ffffffffc020c770 <commands+0x10a8>
ffffffffc0202d80:	e406                	sd	ra,8(sp)
ffffffffc0202d82:	cacfd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202d86 <mm_create>:
ffffffffc0202d86:	1141                	addi	sp,sp,-16
ffffffffc0202d88:	05800513          	li	a0,88
ffffffffc0202d8c:	e022                	sd	s0,0(sp)
ffffffffc0202d8e:	e406                	sd	ra,8(sp)
ffffffffc0202d90:	233000ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0202d94:	842a                	mv	s0,a0
ffffffffc0202d96:	c115                	beqz	a0,ffffffffc0202dba <mm_create+0x34>
ffffffffc0202d98:	e408                	sd	a0,8(s0)
ffffffffc0202d9a:	e008                	sd	a0,0(s0)
ffffffffc0202d9c:	00053823          	sd	zero,16(a0)
ffffffffc0202da0:	00053c23          	sd	zero,24(a0)
ffffffffc0202da4:	02052023          	sw	zero,32(a0)
ffffffffc0202da8:	02053423          	sd	zero,40(a0)
ffffffffc0202dac:	02052823          	sw	zero,48(a0)
ffffffffc0202db0:	4585                	li	a1,1
ffffffffc0202db2:	03850513          	addi	a0,a0,56
ffffffffc0202db6:	189010ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc0202dba:	60a2                	ld	ra,8(sp)
ffffffffc0202dbc:	8522                	mv	a0,s0
ffffffffc0202dbe:	6402                	ld	s0,0(sp)
ffffffffc0202dc0:	0141                	addi	sp,sp,16
ffffffffc0202dc2:	8082                	ret

ffffffffc0202dc4 <find_vma>:
ffffffffc0202dc4:	86aa                	mv	a3,a0
ffffffffc0202dc6:	c505                	beqz	a0,ffffffffc0202dee <find_vma+0x2a>
ffffffffc0202dc8:	6908                	ld	a0,16(a0)
ffffffffc0202dca:	c501                	beqz	a0,ffffffffc0202dd2 <find_vma+0xe>
ffffffffc0202dcc:	651c                	ld	a5,8(a0)
ffffffffc0202dce:	02f5f263          	bgeu	a1,a5,ffffffffc0202df2 <find_vma+0x2e>
ffffffffc0202dd2:	669c                	ld	a5,8(a3)
ffffffffc0202dd4:	00f68d63          	beq	a3,a5,ffffffffc0202dee <find_vma+0x2a>
ffffffffc0202dd8:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0202ddc:	00e5e663          	bltu	a1,a4,ffffffffc0202de8 <find_vma+0x24>
ffffffffc0202de0:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202de4:	00e5ec63          	bltu	a1,a4,ffffffffc0202dfc <find_vma+0x38>
ffffffffc0202de8:	679c                	ld	a5,8(a5)
ffffffffc0202dea:	fef697e3          	bne	a3,a5,ffffffffc0202dd8 <find_vma+0x14>
ffffffffc0202dee:	4501                	li	a0,0
ffffffffc0202df0:	8082                	ret
ffffffffc0202df2:	691c                	ld	a5,16(a0)
ffffffffc0202df4:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0202dd2 <find_vma+0xe>
ffffffffc0202df8:	ea88                	sd	a0,16(a3)
ffffffffc0202dfa:	8082                	ret
ffffffffc0202dfc:	fe078513          	addi	a0,a5,-32
ffffffffc0202e00:	ea88                	sd	a0,16(a3)
ffffffffc0202e02:	8082                	ret

ffffffffc0202e04 <insert_vma_struct>:
ffffffffc0202e04:	6590                	ld	a2,8(a1)
ffffffffc0202e06:	0105b803          	ld	a6,16(a1) # 80010 <_binary_bin_sfs_img_size+0xad10>
ffffffffc0202e0a:	1141                	addi	sp,sp,-16
ffffffffc0202e0c:	e406                	sd	ra,8(sp)
ffffffffc0202e0e:	87aa                	mv	a5,a0
ffffffffc0202e10:	01066763          	bltu	a2,a6,ffffffffc0202e1e <insert_vma_struct+0x1a>
ffffffffc0202e14:	a085                	j	ffffffffc0202e74 <insert_vma_struct+0x70>
ffffffffc0202e16:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e1a:	04e66863          	bltu	a2,a4,ffffffffc0202e6a <insert_vma_struct+0x66>
ffffffffc0202e1e:	86be                	mv	a3,a5
ffffffffc0202e20:	679c                	ld	a5,8(a5)
ffffffffc0202e22:	fef51ae3          	bne	a0,a5,ffffffffc0202e16 <insert_vma_struct+0x12>
ffffffffc0202e26:	02a68463          	beq	a3,a0,ffffffffc0202e4e <insert_vma_struct+0x4a>
ffffffffc0202e2a:	ff06b703          	ld	a4,-16(a3)
ffffffffc0202e2e:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202e32:	08e8f163          	bgeu	a7,a4,ffffffffc0202eb4 <insert_vma_struct+0xb0>
ffffffffc0202e36:	04e66f63          	bltu	a2,a4,ffffffffc0202e94 <insert_vma_struct+0x90>
ffffffffc0202e3a:	00f50a63          	beq	a0,a5,ffffffffc0202e4e <insert_vma_struct+0x4a>
ffffffffc0202e3e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e42:	05076963          	bltu	a4,a6,ffffffffc0202e94 <insert_vma_struct+0x90>
ffffffffc0202e46:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202e4a:	02c77363          	bgeu	a4,a2,ffffffffc0202e70 <insert_vma_struct+0x6c>
ffffffffc0202e4e:	5118                	lw	a4,32(a0)
ffffffffc0202e50:	e188                	sd	a0,0(a1)
ffffffffc0202e52:	02058613          	addi	a2,a1,32
ffffffffc0202e56:	e390                	sd	a2,0(a5)
ffffffffc0202e58:	e690                	sd	a2,8(a3)
ffffffffc0202e5a:	60a2                	ld	ra,8(sp)
ffffffffc0202e5c:	f59c                	sd	a5,40(a1)
ffffffffc0202e5e:	f194                	sd	a3,32(a1)
ffffffffc0202e60:	0017079b          	addiw	a5,a4,1
ffffffffc0202e64:	d11c                	sw	a5,32(a0)
ffffffffc0202e66:	0141                	addi	sp,sp,16
ffffffffc0202e68:	8082                	ret
ffffffffc0202e6a:	fca690e3          	bne	a3,a0,ffffffffc0202e2a <insert_vma_struct+0x26>
ffffffffc0202e6e:	bfd1                	j	ffffffffc0202e42 <insert_vma_struct+0x3e>
ffffffffc0202e70:	ef3ff0ef          	jal	ra,ffffffffc0202d62 <check_vma_overlap.part.0>
ffffffffc0202e74:	0000a697          	auipc	a3,0xa
ffffffffc0202e78:	90c68693          	addi	a3,a3,-1780 # ffffffffc020c780 <commands+0x10b8>
ffffffffc0202e7c:	00009617          	auipc	a2,0x9
ffffffffc0202e80:	a9c60613          	addi	a2,a2,-1380 # ffffffffc020b918 <commands+0x250>
ffffffffc0202e84:	07a00593          	li	a1,122
ffffffffc0202e88:	0000a517          	auipc	a0,0xa
ffffffffc0202e8c:	8e850513          	addi	a0,a0,-1816 # ffffffffc020c770 <commands+0x10a8>
ffffffffc0202e90:	b9efd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202e94:	0000a697          	auipc	a3,0xa
ffffffffc0202e98:	92c68693          	addi	a3,a3,-1748 # ffffffffc020c7c0 <commands+0x10f8>
ffffffffc0202e9c:	00009617          	auipc	a2,0x9
ffffffffc0202ea0:	a7c60613          	addi	a2,a2,-1412 # ffffffffc020b918 <commands+0x250>
ffffffffc0202ea4:	07300593          	li	a1,115
ffffffffc0202ea8:	0000a517          	auipc	a0,0xa
ffffffffc0202eac:	8c850513          	addi	a0,a0,-1848 # ffffffffc020c770 <commands+0x10a8>
ffffffffc0202eb0:	b7efd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202eb4:	0000a697          	auipc	a3,0xa
ffffffffc0202eb8:	8ec68693          	addi	a3,a3,-1812 # ffffffffc020c7a0 <commands+0x10d8>
ffffffffc0202ebc:	00009617          	auipc	a2,0x9
ffffffffc0202ec0:	a5c60613          	addi	a2,a2,-1444 # ffffffffc020b918 <commands+0x250>
ffffffffc0202ec4:	07200593          	li	a1,114
ffffffffc0202ec8:	0000a517          	auipc	a0,0xa
ffffffffc0202ecc:	8a850513          	addi	a0,a0,-1880 # ffffffffc020c770 <commands+0x10a8>
ffffffffc0202ed0:	b5efd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202ed4 <mm_destroy>:
ffffffffc0202ed4:	591c                	lw	a5,48(a0)
ffffffffc0202ed6:	1141                	addi	sp,sp,-16
ffffffffc0202ed8:	e406                	sd	ra,8(sp)
ffffffffc0202eda:	e022                	sd	s0,0(sp)
ffffffffc0202edc:	e78d                	bnez	a5,ffffffffc0202f06 <mm_destroy+0x32>
ffffffffc0202ede:	842a                	mv	s0,a0
ffffffffc0202ee0:	6508                	ld	a0,8(a0)
ffffffffc0202ee2:	00a40c63          	beq	s0,a0,ffffffffc0202efa <mm_destroy+0x26>
ffffffffc0202ee6:	6118                	ld	a4,0(a0)
ffffffffc0202ee8:	651c                	ld	a5,8(a0)
ffffffffc0202eea:	1501                	addi	a0,a0,-32
ffffffffc0202eec:	e71c                	sd	a5,8(a4)
ffffffffc0202eee:	e398                	sd	a4,0(a5)
ffffffffc0202ef0:	183000ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0202ef4:	6408                	ld	a0,8(s0)
ffffffffc0202ef6:	fea418e3          	bne	s0,a0,ffffffffc0202ee6 <mm_destroy+0x12>
ffffffffc0202efa:	8522                	mv	a0,s0
ffffffffc0202efc:	6402                	ld	s0,0(sp)
ffffffffc0202efe:	60a2                	ld	ra,8(sp)
ffffffffc0202f00:	0141                	addi	sp,sp,16
ffffffffc0202f02:	1710006f          	j	ffffffffc0203872 <kfree>
ffffffffc0202f06:	0000a697          	auipc	a3,0xa
ffffffffc0202f0a:	8da68693          	addi	a3,a3,-1830 # ffffffffc020c7e0 <commands+0x1118>
ffffffffc0202f0e:	00009617          	auipc	a2,0x9
ffffffffc0202f12:	a0a60613          	addi	a2,a2,-1526 # ffffffffc020b918 <commands+0x250>
ffffffffc0202f16:	09e00593          	li	a1,158
ffffffffc0202f1a:	0000a517          	auipc	a0,0xa
ffffffffc0202f1e:	85650513          	addi	a0,a0,-1962 # ffffffffc020c770 <commands+0x10a8>
ffffffffc0202f22:	b0cfd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202f26 <mm_map>:
ffffffffc0202f26:	7139                	addi	sp,sp,-64
ffffffffc0202f28:	f822                	sd	s0,48(sp)
ffffffffc0202f2a:	6405                	lui	s0,0x1
ffffffffc0202f2c:	147d                	addi	s0,s0,-1
ffffffffc0202f2e:	77fd                	lui	a5,0xfffff
ffffffffc0202f30:	9622                	add	a2,a2,s0
ffffffffc0202f32:	962e                	add	a2,a2,a1
ffffffffc0202f34:	f426                	sd	s1,40(sp)
ffffffffc0202f36:	fc06                	sd	ra,56(sp)
ffffffffc0202f38:	00f5f4b3          	and	s1,a1,a5
ffffffffc0202f3c:	f04a                	sd	s2,32(sp)
ffffffffc0202f3e:	ec4e                	sd	s3,24(sp)
ffffffffc0202f40:	e852                	sd	s4,16(sp)
ffffffffc0202f42:	e456                	sd	s5,8(sp)
ffffffffc0202f44:	002005b7          	lui	a1,0x200
ffffffffc0202f48:	00f67433          	and	s0,a2,a5
ffffffffc0202f4c:	06b4e363          	bltu	s1,a1,ffffffffc0202fb2 <mm_map+0x8c>
ffffffffc0202f50:	0684f163          	bgeu	s1,s0,ffffffffc0202fb2 <mm_map+0x8c>
ffffffffc0202f54:	4785                	li	a5,1
ffffffffc0202f56:	07fe                	slli	a5,a5,0x1f
ffffffffc0202f58:	0487ed63          	bltu	a5,s0,ffffffffc0202fb2 <mm_map+0x8c>
ffffffffc0202f5c:	89aa                	mv	s3,a0
ffffffffc0202f5e:	cd21                	beqz	a0,ffffffffc0202fb6 <mm_map+0x90>
ffffffffc0202f60:	85a6                	mv	a1,s1
ffffffffc0202f62:	8ab6                	mv	s5,a3
ffffffffc0202f64:	8a3a                	mv	s4,a4
ffffffffc0202f66:	e5fff0ef          	jal	ra,ffffffffc0202dc4 <find_vma>
ffffffffc0202f6a:	c501                	beqz	a0,ffffffffc0202f72 <mm_map+0x4c>
ffffffffc0202f6c:	651c                	ld	a5,8(a0)
ffffffffc0202f6e:	0487e263          	bltu	a5,s0,ffffffffc0202fb2 <mm_map+0x8c>
ffffffffc0202f72:	03000513          	li	a0,48
ffffffffc0202f76:	04d000ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0202f7a:	892a                	mv	s2,a0
ffffffffc0202f7c:	5571                	li	a0,-4
ffffffffc0202f7e:	02090163          	beqz	s2,ffffffffc0202fa0 <mm_map+0x7a>
ffffffffc0202f82:	854e                	mv	a0,s3
ffffffffc0202f84:	00993423          	sd	s1,8(s2)
ffffffffc0202f88:	00893823          	sd	s0,16(s2)
ffffffffc0202f8c:	01592c23          	sw	s5,24(s2)
ffffffffc0202f90:	85ca                	mv	a1,s2
ffffffffc0202f92:	e73ff0ef          	jal	ra,ffffffffc0202e04 <insert_vma_struct>
ffffffffc0202f96:	4501                	li	a0,0
ffffffffc0202f98:	000a0463          	beqz	s4,ffffffffc0202fa0 <mm_map+0x7a>
ffffffffc0202f9c:	012a3023          	sd	s2,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202fa0:	70e2                	ld	ra,56(sp)
ffffffffc0202fa2:	7442                	ld	s0,48(sp)
ffffffffc0202fa4:	74a2                	ld	s1,40(sp)
ffffffffc0202fa6:	7902                	ld	s2,32(sp)
ffffffffc0202fa8:	69e2                	ld	s3,24(sp)
ffffffffc0202faa:	6a42                	ld	s4,16(sp)
ffffffffc0202fac:	6aa2                	ld	s5,8(sp)
ffffffffc0202fae:	6121                	addi	sp,sp,64
ffffffffc0202fb0:	8082                	ret
ffffffffc0202fb2:	5575                	li	a0,-3
ffffffffc0202fb4:	b7f5                	j	ffffffffc0202fa0 <mm_map+0x7a>
ffffffffc0202fb6:	0000a697          	auipc	a3,0xa
ffffffffc0202fba:	84268693          	addi	a3,a3,-1982 # ffffffffc020c7f8 <commands+0x1130>
ffffffffc0202fbe:	00009617          	auipc	a2,0x9
ffffffffc0202fc2:	95a60613          	addi	a2,a2,-1702 # ffffffffc020b918 <commands+0x250>
ffffffffc0202fc6:	0b300593          	li	a1,179
ffffffffc0202fca:	00009517          	auipc	a0,0x9
ffffffffc0202fce:	7a650513          	addi	a0,a0,1958 # ffffffffc020c770 <commands+0x10a8>
ffffffffc0202fd2:	a5cfd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202fd6 <dup_mmap>:
ffffffffc0202fd6:	7139                	addi	sp,sp,-64
ffffffffc0202fd8:	fc06                	sd	ra,56(sp)
ffffffffc0202fda:	f822                	sd	s0,48(sp)
ffffffffc0202fdc:	f426                	sd	s1,40(sp)
ffffffffc0202fde:	f04a                	sd	s2,32(sp)
ffffffffc0202fe0:	ec4e                	sd	s3,24(sp)
ffffffffc0202fe2:	e852                	sd	s4,16(sp)
ffffffffc0202fe4:	e456                	sd	s5,8(sp)
ffffffffc0202fe6:	c52d                	beqz	a0,ffffffffc0203050 <dup_mmap+0x7a>
ffffffffc0202fe8:	892a                	mv	s2,a0
ffffffffc0202fea:	84ae                	mv	s1,a1
ffffffffc0202fec:	842e                	mv	s0,a1
ffffffffc0202fee:	e595                	bnez	a1,ffffffffc020301a <dup_mmap+0x44>
ffffffffc0202ff0:	a085                	j	ffffffffc0203050 <dup_mmap+0x7a>
ffffffffc0202ff2:	854a                	mv	a0,s2
ffffffffc0202ff4:	0155b423          	sd	s5,8(a1) # 200008 <_binary_bin_sfs_img_size+0x18ad08>
ffffffffc0202ff8:	0145b823          	sd	s4,16(a1)
ffffffffc0202ffc:	0135ac23          	sw	s3,24(a1)
ffffffffc0203000:	e05ff0ef          	jal	ra,ffffffffc0202e04 <insert_vma_struct>
ffffffffc0203004:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_bin_swap_img_size-0x6d10>
ffffffffc0203008:	fe843603          	ld	a2,-24(s0)
ffffffffc020300c:	6c8c                	ld	a1,24(s1)
ffffffffc020300e:	01893503          	ld	a0,24(s2)
ffffffffc0203012:	4701                	li	a4,0
ffffffffc0203014:	a2dff0ef          	jal	ra,ffffffffc0202a40 <copy_range>
ffffffffc0203018:	e105                	bnez	a0,ffffffffc0203038 <dup_mmap+0x62>
ffffffffc020301a:	6000                	ld	s0,0(s0)
ffffffffc020301c:	02848863          	beq	s1,s0,ffffffffc020304c <dup_mmap+0x76>
ffffffffc0203020:	03000513          	li	a0,48
ffffffffc0203024:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203028:	ff043a03          	ld	s4,-16(s0)
ffffffffc020302c:	ff842983          	lw	s3,-8(s0)
ffffffffc0203030:	792000ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0203034:	85aa                	mv	a1,a0
ffffffffc0203036:	fd55                	bnez	a0,ffffffffc0202ff2 <dup_mmap+0x1c>
ffffffffc0203038:	5571                	li	a0,-4
ffffffffc020303a:	70e2                	ld	ra,56(sp)
ffffffffc020303c:	7442                	ld	s0,48(sp)
ffffffffc020303e:	74a2                	ld	s1,40(sp)
ffffffffc0203040:	7902                	ld	s2,32(sp)
ffffffffc0203042:	69e2                	ld	s3,24(sp)
ffffffffc0203044:	6a42                	ld	s4,16(sp)
ffffffffc0203046:	6aa2                	ld	s5,8(sp)
ffffffffc0203048:	6121                	addi	sp,sp,64
ffffffffc020304a:	8082                	ret
ffffffffc020304c:	4501                	li	a0,0
ffffffffc020304e:	b7f5                	j	ffffffffc020303a <dup_mmap+0x64>
ffffffffc0203050:	00009697          	auipc	a3,0x9
ffffffffc0203054:	7b868693          	addi	a3,a3,1976 # ffffffffc020c808 <commands+0x1140>
ffffffffc0203058:	00009617          	auipc	a2,0x9
ffffffffc020305c:	8c060613          	addi	a2,a2,-1856 # ffffffffc020b918 <commands+0x250>
ffffffffc0203060:	0cf00593          	li	a1,207
ffffffffc0203064:	00009517          	auipc	a0,0x9
ffffffffc0203068:	70c50513          	addi	a0,a0,1804 # ffffffffc020c770 <commands+0x10a8>
ffffffffc020306c:	9c2fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0203070 <exit_mmap>:
ffffffffc0203070:	1101                	addi	sp,sp,-32
ffffffffc0203072:	ec06                	sd	ra,24(sp)
ffffffffc0203074:	e822                	sd	s0,16(sp)
ffffffffc0203076:	e426                	sd	s1,8(sp)
ffffffffc0203078:	e04a                	sd	s2,0(sp)
ffffffffc020307a:	c531                	beqz	a0,ffffffffc02030c6 <exit_mmap+0x56>
ffffffffc020307c:	591c                	lw	a5,48(a0)
ffffffffc020307e:	84aa                	mv	s1,a0
ffffffffc0203080:	e3b9                	bnez	a5,ffffffffc02030c6 <exit_mmap+0x56>
ffffffffc0203082:	6500                	ld	s0,8(a0)
ffffffffc0203084:	01853903          	ld	s2,24(a0)
ffffffffc0203088:	02850663          	beq	a0,s0,ffffffffc02030b4 <exit_mmap+0x44>
ffffffffc020308c:	ff043603          	ld	a2,-16(s0)
ffffffffc0203090:	fe843583          	ld	a1,-24(s0)
ffffffffc0203094:	854a                	mv	a0,s2
ffffffffc0203096:	e4efe0ef          	jal	ra,ffffffffc02016e4 <unmap_range>
ffffffffc020309a:	6400                	ld	s0,8(s0)
ffffffffc020309c:	fe8498e3          	bne	s1,s0,ffffffffc020308c <exit_mmap+0x1c>
ffffffffc02030a0:	6400                	ld	s0,8(s0)
ffffffffc02030a2:	00848c63          	beq	s1,s0,ffffffffc02030ba <exit_mmap+0x4a>
ffffffffc02030a6:	ff043603          	ld	a2,-16(s0)
ffffffffc02030aa:	fe843583          	ld	a1,-24(s0)
ffffffffc02030ae:	854a                	mv	a0,s2
ffffffffc02030b0:	f7afe0ef          	jal	ra,ffffffffc020182a <exit_range>
ffffffffc02030b4:	6400                	ld	s0,8(s0)
ffffffffc02030b6:	fe8498e3          	bne	s1,s0,ffffffffc02030a6 <exit_mmap+0x36>
ffffffffc02030ba:	60e2                	ld	ra,24(sp)
ffffffffc02030bc:	6442                	ld	s0,16(sp)
ffffffffc02030be:	64a2                	ld	s1,8(sp)
ffffffffc02030c0:	6902                	ld	s2,0(sp)
ffffffffc02030c2:	6105                	addi	sp,sp,32
ffffffffc02030c4:	8082                	ret
ffffffffc02030c6:	00009697          	auipc	a3,0x9
ffffffffc02030ca:	76268693          	addi	a3,a3,1890 # ffffffffc020c828 <commands+0x1160>
ffffffffc02030ce:	00009617          	auipc	a2,0x9
ffffffffc02030d2:	84a60613          	addi	a2,a2,-1974 # ffffffffc020b918 <commands+0x250>
ffffffffc02030d6:	0e800593          	li	a1,232
ffffffffc02030da:	00009517          	auipc	a0,0x9
ffffffffc02030de:	69650513          	addi	a0,a0,1686 # ffffffffc020c770 <commands+0x10a8>
ffffffffc02030e2:	94cfd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02030e6 <vmm_init>:
ffffffffc02030e6:	7139                	addi	sp,sp,-64
ffffffffc02030e8:	05800513          	li	a0,88
ffffffffc02030ec:	fc06                	sd	ra,56(sp)
ffffffffc02030ee:	f822                	sd	s0,48(sp)
ffffffffc02030f0:	f426                	sd	s1,40(sp)
ffffffffc02030f2:	f04a                	sd	s2,32(sp)
ffffffffc02030f4:	ec4e                	sd	s3,24(sp)
ffffffffc02030f6:	e852                	sd	s4,16(sp)
ffffffffc02030f8:	e456                	sd	s5,8(sp)
ffffffffc02030fa:	6c8000ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02030fe:	2e050963          	beqz	a0,ffffffffc02033f0 <vmm_init+0x30a>
ffffffffc0203102:	e508                	sd	a0,8(a0)
ffffffffc0203104:	e108                	sd	a0,0(a0)
ffffffffc0203106:	00053823          	sd	zero,16(a0)
ffffffffc020310a:	00053c23          	sd	zero,24(a0)
ffffffffc020310e:	02052023          	sw	zero,32(a0)
ffffffffc0203112:	02053423          	sd	zero,40(a0)
ffffffffc0203116:	02052823          	sw	zero,48(a0)
ffffffffc020311a:	84aa                	mv	s1,a0
ffffffffc020311c:	4585                	li	a1,1
ffffffffc020311e:	03850513          	addi	a0,a0,56
ffffffffc0203122:	61c010ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc0203126:	03200413          	li	s0,50
ffffffffc020312a:	a811                	j	ffffffffc020313e <vmm_init+0x58>
ffffffffc020312c:	e500                	sd	s0,8(a0)
ffffffffc020312e:	e91c                	sd	a5,16(a0)
ffffffffc0203130:	00052c23          	sw	zero,24(a0)
ffffffffc0203134:	146d                	addi	s0,s0,-5
ffffffffc0203136:	8526                	mv	a0,s1
ffffffffc0203138:	ccdff0ef          	jal	ra,ffffffffc0202e04 <insert_vma_struct>
ffffffffc020313c:	c80d                	beqz	s0,ffffffffc020316e <vmm_init+0x88>
ffffffffc020313e:	03000513          	li	a0,48
ffffffffc0203142:	680000ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0203146:	85aa                	mv	a1,a0
ffffffffc0203148:	00240793          	addi	a5,s0,2
ffffffffc020314c:	f165                	bnez	a0,ffffffffc020312c <vmm_init+0x46>
ffffffffc020314e:	0000a697          	auipc	a3,0xa
ffffffffc0203152:	87268693          	addi	a3,a3,-1934 # ffffffffc020c9c0 <commands+0x12f8>
ffffffffc0203156:	00008617          	auipc	a2,0x8
ffffffffc020315a:	7c260613          	addi	a2,a2,1986 # ffffffffc020b918 <commands+0x250>
ffffffffc020315e:	12c00593          	li	a1,300
ffffffffc0203162:	00009517          	auipc	a0,0x9
ffffffffc0203166:	60e50513          	addi	a0,a0,1550 # ffffffffc020c770 <commands+0x10a8>
ffffffffc020316a:	8c4fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020316e:	03700413          	li	s0,55
ffffffffc0203172:	1f900913          	li	s2,505
ffffffffc0203176:	a819                	j	ffffffffc020318c <vmm_init+0xa6>
ffffffffc0203178:	e500                	sd	s0,8(a0)
ffffffffc020317a:	e91c                	sd	a5,16(a0)
ffffffffc020317c:	00052c23          	sw	zero,24(a0)
ffffffffc0203180:	0415                	addi	s0,s0,5
ffffffffc0203182:	8526                	mv	a0,s1
ffffffffc0203184:	c81ff0ef          	jal	ra,ffffffffc0202e04 <insert_vma_struct>
ffffffffc0203188:	03240a63          	beq	s0,s2,ffffffffc02031bc <vmm_init+0xd6>
ffffffffc020318c:	03000513          	li	a0,48
ffffffffc0203190:	632000ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0203194:	85aa                	mv	a1,a0
ffffffffc0203196:	00240793          	addi	a5,s0,2
ffffffffc020319a:	fd79                	bnez	a0,ffffffffc0203178 <vmm_init+0x92>
ffffffffc020319c:	0000a697          	auipc	a3,0xa
ffffffffc02031a0:	82468693          	addi	a3,a3,-2012 # ffffffffc020c9c0 <commands+0x12f8>
ffffffffc02031a4:	00008617          	auipc	a2,0x8
ffffffffc02031a8:	77460613          	addi	a2,a2,1908 # ffffffffc020b918 <commands+0x250>
ffffffffc02031ac:	13300593          	li	a1,307
ffffffffc02031b0:	00009517          	auipc	a0,0x9
ffffffffc02031b4:	5c050513          	addi	a0,a0,1472 # ffffffffc020c770 <commands+0x10a8>
ffffffffc02031b8:	876fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02031bc:	649c                	ld	a5,8(s1)
ffffffffc02031be:	471d                	li	a4,7
ffffffffc02031c0:	1fb00593          	li	a1,507
ffffffffc02031c4:	16f48663          	beq	s1,a5,ffffffffc0203330 <vmm_init+0x24a>
ffffffffc02031c8:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd686d8>
ffffffffc02031cc:	ffe70693          	addi	a3,a4,-2
ffffffffc02031d0:	10d61063          	bne	a2,a3,ffffffffc02032d0 <vmm_init+0x1ea>
ffffffffc02031d4:	ff07b683          	ld	a3,-16(a5)
ffffffffc02031d8:	0ed71c63          	bne	a4,a3,ffffffffc02032d0 <vmm_init+0x1ea>
ffffffffc02031dc:	0715                	addi	a4,a4,5
ffffffffc02031de:	679c                	ld	a5,8(a5)
ffffffffc02031e0:	feb712e3          	bne	a4,a1,ffffffffc02031c4 <vmm_init+0xde>
ffffffffc02031e4:	4a1d                	li	s4,7
ffffffffc02031e6:	4415                	li	s0,5
ffffffffc02031e8:	1f900a93          	li	s5,505
ffffffffc02031ec:	85a2                	mv	a1,s0
ffffffffc02031ee:	8526                	mv	a0,s1
ffffffffc02031f0:	bd5ff0ef          	jal	ra,ffffffffc0202dc4 <find_vma>
ffffffffc02031f4:	892a                	mv	s2,a0
ffffffffc02031f6:	16050d63          	beqz	a0,ffffffffc0203370 <vmm_init+0x28a>
ffffffffc02031fa:	00140593          	addi	a1,s0,1
ffffffffc02031fe:	8526                	mv	a0,s1
ffffffffc0203200:	bc5ff0ef          	jal	ra,ffffffffc0202dc4 <find_vma>
ffffffffc0203204:	89aa                	mv	s3,a0
ffffffffc0203206:	14050563          	beqz	a0,ffffffffc0203350 <vmm_init+0x26a>
ffffffffc020320a:	85d2                	mv	a1,s4
ffffffffc020320c:	8526                	mv	a0,s1
ffffffffc020320e:	bb7ff0ef          	jal	ra,ffffffffc0202dc4 <find_vma>
ffffffffc0203212:	16051f63          	bnez	a0,ffffffffc0203390 <vmm_init+0x2aa>
ffffffffc0203216:	00340593          	addi	a1,s0,3
ffffffffc020321a:	8526                	mv	a0,s1
ffffffffc020321c:	ba9ff0ef          	jal	ra,ffffffffc0202dc4 <find_vma>
ffffffffc0203220:	1a051863          	bnez	a0,ffffffffc02033d0 <vmm_init+0x2ea>
ffffffffc0203224:	00440593          	addi	a1,s0,4
ffffffffc0203228:	8526                	mv	a0,s1
ffffffffc020322a:	b9bff0ef          	jal	ra,ffffffffc0202dc4 <find_vma>
ffffffffc020322e:	18051163          	bnez	a0,ffffffffc02033b0 <vmm_init+0x2ca>
ffffffffc0203232:	00893783          	ld	a5,8(s2)
ffffffffc0203236:	0a879d63          	bne	a5,s0,ffffffffc02032f0 <vmm_init+0x20a>
ffffffffc020323a:	01093783          	ld	a5,16(s2)
ffffffffc020323e:	0b479963          	bne	a5,s4,ffffffffc02032f0 <vmm_init+0x20a>
ffffffffc0203242:	0089b783          	ld	a5,8(s3)
ffffffffc0203246:	0c879563          	bne	a5,s0,ffffffffc0203310 <vmm_init+0x22a>
ffffffffc020324a:	0109b783          	ld	a5,16(s3)
ffffffffc020324e:	0d479163          	bne	a5,s4,ffffffffc0203310 <vmm_init+0x22a>
ffffffffc0203252:	0415                	addi	s0,s0,5
ffffffffc0203254:	0a15                	addi	s4,s4,5
ffffffffc0203256:	f9541be3          	bne	s0,s5,ffffffffc02031ec <vmm_init+0x106>
ffffffffc020325a:	4411                	li	s0,4
ffffffffc020325c:	597d                	li	s2,-1
ffffffffc020325e:	85a2                	mv	a1,s0
ffffffffc0203260:	8526                	mv	a0,s1
ffffffffc0203262:	b63ff0ef          	jal	ra,ffffffffc0202dc4 <find_vma>
ffffffffc0203266:	0004059b          	sext.w	a1,s0
ffffffffc020326a:	c90d                	beqz	a0,ffffffffc020329c <vmm_init+0x1b6>
ffffffffc020326c:	6914                	ld	a3,16(a0)
ffffffffc020326e:	6510                	ld	a2,8(a0)
ffffffffc0203270:	00009517          	auipc	a0,0x9
ffffffffc0203274:	6d850513          	addi	a0,a0,1752 # ffffffffc020c948 <commands+0x1280>
ffffffffc0203278:	eb3fc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020327c:	00009697          	auipc	a3,0x9
ffffffffc0203280:	6f468693          	addi	a3,a3,1780 # ffffffffc020c970 <commands+0x12a8>
ffffffffc0203284:	00008617          	auipc	a2,0x8
ffffffffc0203288:	69460613          	addi	a2,a2,1684 # ffffffffc020b918 <commands+0x250>
ffffffffc020328c:	15900593          	li	a1,345
ffffffffc0203290:	00009517          	auipc	a0,0x9
ffffffffc0203294:	4e050513          	addi	a0,a0,1248 # ffffffffc020c770 <commands+0x10a8>
ffffffffc0203298:	f97fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020329c:	147d                	addi	s0,s0,-1
ffffffffc020329e:	fd2410e3          	bne	s0,s2,ffffffffc020325e <vmm_init+0x178>
ffffffffc02032a2:	8526                	mv	a0,s1
ffffffffc02032a4:	c31ff0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc02032a8:	00009517          	auipc	a0,0x9
ffffffffc02032ac:	6e050513          	addi	a0,a0,1760 # ffffffffc020c988 <commands+0x12c0>
ffffffffc02032b0:	e7bfc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02032b4:	7442                	ld	s0,48(sp)
ffffffffc02032b6:	70e2                	ld	ra,56(sp)
ffffffffc02032b8:	74a2                	ld	s1,40(sp)
ffffffffc02032ba:	7902                	ld	s2,32(sp)
ffffffffc02032bc:	69e2                	ld	s3,24(sp)
ffffffffc02032be:	6a42                	ld	s4,16(sp)
ffffffffc02032c0:	6aa2                	ld	s5,8(sp)
ffffffffc02032c2:	00009517          	auipc	a0,0x9
ffffffffc02032c6:	6e650513          	addi	a0,a0,1766 # ffffffffc020c9a8 <commands+0x12e0>
ffffffffc02032ca:	6121                	addi	sp,sp,64
ffffffffc02032cc:	e5ffc06f          	j	ffffffffc020012a <cprintf>
ffffffffc02032d0:	00009697          	auipc	a3,0x9
ffffffffc02032d4:	59068693          	addi	a3,a3,1424 # ffffffffc020c860 <commands+0x1198>
ffffffffc02032d8:	00008617          	auipc	a2,0x8
ffffffffc02032dc:	64060613          	addi	a2,a2,1600 # ffffffffc020b918 <commands+0x250>
ffffffffc02032e0:	13d00593          	li	a1,317
ffffffffc02032e4:	00009517          	auipc	a0,0x9
ffffffffc02032e8:	48c50513          	addi	a0,a0,1164 # ffffffffc020c770 <commands+0x10a8>
ffffffffc02032ec:	f43fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02032f0:	00009697          	auipc	a3,0x9
ffffffffc02032f4:	5f868693          	addi	a3,a3,1528 # ffffffffc020c8e8 <commands+0x1220>
ffffffffc02032f8:	00008617          	auipc	a2,0x8
ffffffffc02032fc:	62060613          	addi	a2,a2,1568 # ffffffffc020b918 <commands+0x250>
ffffffffc0203300:	14e00593          	li	a1,334
ffffffffc0203304:	00009517          	auipc	a0,0x9
ffffffffc0203308:	46c50513          	addi	a0,a0,1132 # ffffffffc020c770 <commands+0x10a8>
ffffffffc020330c:	f23fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203310:	00009697          	auipc	a3,0x9
ffffffffc0203314:	60868693          	addi	a3,a3,1544 # ffffffffc020c918 <commands+0x1250>
ffffffffc0203318:	00008617          	auipc	a2,0x8
ffffffffc020331c:	60060613          	addi	a2,a2,1536 # ffffffffc020b918 <commands+0x250>
ffffffffc0203320:	14f00593          	li	a1,335
ffffffffc0203324:	00009517          	auipc	a0,0x9
ffffffffc0203328:	44c50513          	addi	a0,a0,1100 # ffffffffc020c770 <commands+0x10a8>
ffffffffc020332c:	f03fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203330:	00009697          	auipc	a3,0x9
ffffffffc0203334:	51868693          	addi	a3,a3,1304 # ffffffffc020c848 <commands+0x1180>
ffffffffc0203338:	00008617          	auipc	a2,0x8
ffffffffc020333c:	5e060613          	addi	a2,a2,1504 # ffffffffc020b918 <commands+0x250>
ffffffffc0203340:	13b00593          	li	a1,315
ffffffffc0203344:	00009517          	auipc	a0,0x9
ffffffffc0203348:	42c50513          	addi	a0,a0,1068 # ffffffffc020c770 <commands+0x10a8>
ffffffffc020334c:	ee3fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203350:	00009697          	auipc	a3,0x9
ffffffffc0203354:	55868693          	addi	a3,a3,1368 # ffffffffc020c8a8 <commands+0x11e0>
ffffffffc0203358:	00008617          	auipc	a2,0x8
ffffffffc020335c:	5c060613          	addi	a2,a2,1472 # ffffffffc020b918 <commands+0x250>
ffffffffc0203360:	14600593          	li	a1,326
ffffffffc0203364:	00009517          	auipc	a0,0x9
ffffffffc0203368:	40c50513          	addi	a0,a0,1036 # ffffffffc020c770 <commands+0x10a8>
ffffffffc020336c:	ec3fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203370:	00009697          	auipc	a3,0x9
ffffffffc0203374:	52868693          	addi	a3,a3,1320 # ffffffffc020c898 <commands+0x11d0>
ffffffffc0203378:	00008617          	auipc	a2,0x8
ffffffffc020337c:	5a060613          	addi	a2,a2,1440 # ffffffffc020b918 <commands+0x250>
ffffffffc0203380:	14400593          	li	a1,324
ffffffffc0203384:	00009517          	auipc	a0,0x9
ffffffffc0203388:	3ec50513          	addi	a0,a0,1004 # ffffffffc020c770 <commands+0x10a8>
ffffffffc020338c:	ea3fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203390:	00009697          	auipc	a3,0x9
ffffffffc0203394:	52868693          	addi	a3,a3,1320 # ffffffffc020c8b8 <commands+0x11f0>
ffffffffc0203398:	00008617          	auipc	a2,0x8
ffffffffc020339c:	58060613          	addi	a2,a2,1408 # ffffffffc020b918 <commands+0x250>
ffffffffc02033a0:	14800593          	li	a1,328
ffffffffc02033a4:	00009517          	auipc	a0,0x9
ffffffffc02033a8:	3cc50513          	addi	a0,a0,972 # ffffffffc020c770 <commands+0x10a8>
ffffffffc02033ac:	e83fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02033b0:	00009697          	auipc	a3,0x9
ffffffffc02033b4:	52868693          	addi	a3,a3,1320 # ffffffffc020c8d8 <commands+0x1210>
ffffffffc02033b8:	00008617          	auipc	a2,0x8
ffffffffc02033bc:	56060613          	addi	a2,a2,1376 # ffffffffc020b918 <commands+0x250>
ffffffffc02033c0:	14c00593          	li	a1,332
ffffffffc02033c4:	00009517          	auipc	a0,0x9
ffffffffc02033c8:	3ac50513          	addi	a0,a0,940 # ffffffffc020c770 <commands+0x10a8>
ffffffffc02033cc:	e63fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02033d0:	00009697          	auipc	a3,0x9
ffffffffc02033d4:	4f868693          	addi	a3,a3,1272 # ffffffffc020c8c8 <commands+0x1200>
ffffffffc02033d8:	00008617          	auipc	a2,0x8
ffffffffc02033dc:	54060613          	addi	a2,a2,1344 # ffffffffc020b918 <commands+0x250>
ffffffffc02033e0:	14a00593          	li	a1,330
ffffffffc02033e4:	00009517          	auipc	a0,0x9
ffffffffc02033e8:	38c50513          	addi	a0,a0,908 # ffffffffc020c770 <commands+0x10a8>
ffffffffc02033ec:	e43fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02033f0:	00009697          	auipc	a3,0x9
ffffffffc02033f4:	40868693          	addi	a3,a3,1032 # ffffffffc020c7f8 <commands+0x1130>
ffffffffc02033f8:	00008617          	auipc	a2,0x8
ffffffffc02033fc:	52060613          	addi	a2,a2,1312 # ffffffffc020b918 <commands+0x250>
ffffffffc0203400:	12400593          	li	a1,292
ffffffffc0203404:	00009517          	auipc	a0,0x9
ffffffffc0203408:	36c50513          	addi	a0,a0,876 # ffffffffc020c770 <commands+0x10a8>
ffffffffc020340c:	e23fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0203410 <user_mem_check>:
ffffffffc0203410:	7179                	addi	sp,sp,-48
ffffffffc0203412:	f022                	sd	s0,32(sp)
ffffffffc0203414:	f406                	sd	ra,40(sp)
ffffffffc0203416:	ec26                	sd	s1,24(sp)
ffffffffc0203418:	e84a                	sd	s2,16(sp)
ffffffffc020341a:	e44e                	sd	s3,8(sp)
ffffffffc020341c:	e052                	sd	s4,0(sp)
ffffffffc020341e:	842e                	mv	s0,a1
ffffffffc0203420:	c135                	beqz	a0,ffffffffc0203484 <user_mem_check+0x74>
ffffffffc0203422:	002007b7          	lui	a5,0x200
ffffffffc0203426:	04f5e663          	bltu	a1,a5,ffffffffc0203472 <user_mem_check+0x62>
ffffffffc020342a:	00c584b3          	add	s1,a1,a2
ffffffffc020342e:	0495f263          	bgeu	a1,s1,ffffffffc0203472 <user_mem_check+0x62>
ffffffffc0203432:	4785                	li	a5,1
ffffffffc0203434:	07fe                	slli	a5,a5,0x1f
ffffffffc0203436:	0297ee63          	bltu	a5,s1,ffffffffc0203472 <user_mem_check+0x62>
ffffffffc020343a:	892a                	mv	s2,a0
ffffffffc020343c:	89b6                	mv	s3,a3
ffffffffc020343e:	6a05                	lui	s4,0x1
ffffffffc0203440:	a821                	j	ffffffffc0203458 <user_mem_check+0x48>
ffffffffc0203442:	0027f693          	andi	a3,a5,2
ffffffffc0203446:	9752                	add	a4,a4,s4
ffffffffc0203448:	8ba1                	andi	a5,a5,8
ffffffffc020344a:	c685                	beqz	a3,ffffffffc0203472 <user_mem_check+0x62>
ffffffffc020344c:	c399                	beqz	a5,ffffffffc0203452 <user_mem_check+0x42>
ffffffffc020344e:	02e46263          	bltu	s0,a4,ffffffffc0203472 <user_mem_check+0x62>
ffffffffc0203452:	6900                	ld	s0,16(a0)
ffffffffc0203454:	04947663          	bgeu	s0,s1,ffffffffc02034a0 <user_mem_check+0x90>
ffffffffc0203458:	85a2                	mv	a1,s0
ffffffffc020345a:	854a                	mv	a0,s2
ffffffffc020345c:	969ff0ef          	jal	ra,ffffffffc0202dc4 <find_vma>
ffffffffc0203460:	c909                	beqz	a0,ffffffffc0203472 <user_mem_check+0x62>
ffffffffc0203462:	6518                	ld	a4,8(a0)
ffffffffc0203464:	00e46763          	bltu	s0,a4,ffffffffc0203472 <user_mem_check+0x62>
ffffffffc0203468:	4d1c                	lw	a5,24(a0)
ffffffffc020346a:	fc099ce3          	bnez	s3,ffffffffc0203442 <user_mem_check+0x32>
ffffffffc020346e:	8b85                	andi	a5,a5,1
ffffffffc0203470:	f3ed                	bnez	a5,ffffffffc0203452 <user_mem_check+0x42>
ffffffffc0203472:	4501                	li	a0,0
ffffffffc0203474:	70a2                	ld	ra,40(sp)
ffffffffc0203476:	7402                	ld	s0,32(sp)
ffffffffc0203478:	64e2                	ld	s1,24(sp)
ffffffffc020347a:	6942                	ld	s2,16(sp)
ffffffffc020347c:	69a2                	ld	s3,8(sp)
ffffffffc020347e:	6a02                	ld	s4,0(sp)
ffffffffc0203480:	6145                	addi	sp,sp,48
ffffffffc0203482:	8082                	ret
ffffffffc0203484:	c02007b7          	lui	a5,0xc0200
ffffffffc0203488:	4501                	li	a0,0
ffffffffc020348a:	fef5e5e3          	bltu	a1,a5,ffffffffc0203474 <user_mem_check+0x64>
ffffffffc020348e:	962e                	add	a2,a2,a1
ffffffffc0203490:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203474 <user_mem_check+0x64>
ffffffffc0203494:	c8000537          	lui	a0,0xc8000
ffffffffc0203498:	0505                	addi	a0,a0,1
ffffffffc020349a:	00a63533          	sltu	a0,a2,a0
ffffffffc020349e:	bfd9                	j	ffffffffc0203474 <user_mem_check+0x64>
ffffffffc02034a0:	4505                	li	a0,1
ffffffffc02034a2:	bfc9                	j	ffffffffc0203474 <user_mem_check+0x64>

ffffffffc02034a4 <copy_from_user>:
ffffffffc02034a4:	1101                	addi	sp,sp,-32
ffffffffc02034a6:	e822                	sd	s0,16(sp)
ffffffffc02034a8:	e426                	sd	s1,8(sp)
ffffffffc02034aa:	8432                	mv	s0,a2
ffffffffc02034ac:	84b6                	mv	s1,a3
ffffffffc02034ae:	e04a                	sd	s2,0(sp)
ffffffffc02034b0:	86ba                	mv	a3,a4
ffffffffc02034b2:	892e                	mv	s2,a1
ffffffffc02034b4:	8626                	mv	a2,s1
ffffffffc02034b6:	85a2                	mv	a1,s0
ffffffffc02034b8:	ec06                	sd	ra,24(sp)
ffffffffc02034ba:	f57ff0ef          	jal	ra,ffffffffc0203410 <user_mem_check>
ffffffffc02034be:	c519                	beqz	a0,ffffffffc02034cc <copy_from_user+0x28>
ffffffffc02034c0:	8626                	mv	a2,s1
ffffffffc02034c2:	85a2                	mv	a1,s0
ffffffffc02034c4:	854a                	mv	a0,s2
ffffffffc02034c6:	2ad070ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc02034ca:	4505                	li	a0,1
ffffffffc02034cc:	60e2                	ld	ra,24(sp)
ffffffffc02034ce:	6442                	ld	s0,16(sp)
ffffffffc02034d0:	64a2                	ld	s1,8(sp)
ffffffffc02034d2:	6902                	ld	s2,0(sp)
ffffffffc02034d4:	6105                	addi	sp,sp,32
ffffffffc02034d6:	8082                	ret

ffffffffc02034d8 <copy_to_user>:
ffffffffc02034d8:	1101                	addi	sp,sp,-32
ffffffffc02034da:	e822                	sd	s0,16(sp)
ffffffffc02034dc:	8436                	mv	s0,a3
ffffffffc02034de:	e04a                	sd	s2,0(sp)
ffffffffc02034e0:	4685                	li	a3,1
ffffffffc02034e2:	8932                	mv	s2,a2
ffffffffc02034e4:	8622                	mv	a2,s0
ffffffffc02034e6:	e426                	sd	s1,8(sp)
ffffffffc02034e8:	ec06                	sd	ra,24(sp)
ffffffffc02034ea:	84ae                	mv	s1,a1
ffffffffc02034ec:	f25ff0ef          	jal	ra,ffffffffc0203410 <user_mem_check>
ffffffffc02034f0:	c519                	beqz	a0,ffffffffc02034fe <copy_to_user+0x26>
ffffffffc02034f2:	8622                	mv	a2,s0
ffffffffc02034f4:	85ca                	mv	a1,s2
ffffffffc02034f6:	8526                	mv	a0,s1
ffffffffc02034f8:	27b070ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc02034fc:	4505                	li	a0,1
ffffffffc02034fe:	60e2                	ld	ra,24(sp)
ffffffffc0203500:	6442                	ld	s0,16(sp)
ffffffffc0203502:	64a2                	ld	s1,8(sp)
ffffffffc0203504:	6902                	ld	s2,0(sp)
ffffffffc0203506:	6105                	addi	sp,sp,32
ffffffffc0203508:	8082                	ret

ffffffffc020350a <copy_string>:
ffffffffc020350a:	7139                	addi	sp,sp,-64
ffffffffc020350c:	ec4e                	sd	s3,24(sp)
ffffffffc020350e:	6985                	lui	s3,0x1
ffffffffc0203510:	99b2                	add	s3,s3,a2
ffffffffc0203512:	77fd                	lui	a5,0xfffff
ffffffffc0203514:	00f9f9b3          	and	s3,s3,a5
ffffffffc0203518:	f426                	sd	s1,40(sp)
ffffffffc020351a:	f04a                	sd	s2,32(sp)
ffffffffc020351c:	e852                	sd	s4,16(sp)
ffffffffc020351e:	e456                	sd	s5,8(sp)
ffffffffc0203520:	fc06                	sd	ra,56(sp)
ffffffffc0203522:	f822                	sd	s0,48(sp)
ffffffffc0203524:	84b2                	mv	s1,a2
ffffffffc0203526:	8aaa                	mv	s5,a0
ffffffffc0203528:	8a2e                	mv	s4,a1
ffffffffc020352a:	8936                	mv	s2,a3
ffffffffc020352c:	40c989b3          	sub	s3,s3,a2
ffffffffc0203530:	a015                	j	ffffffffc0203554 <copy_string+0x4a>
ffffffffc0203532:	167070ef          	jal	ra,ffffffffc020ae98 <strnlen>
ffffffffc0203536:	87aa                	mv	a5,a0
ffffffffc0203538:	85a6                	mv	a1,s1
ffffffffc020353a:	8552                	mv	a0,s4
ffffffffc020353c:	8622                	mv	a2,s0
ffffffffc020353e:	0487e363          	bltu	a5,s0,ffffffffc0203584 <copy_string+0x7a>
ffffffffc0203542:	0329f763          	bgeu	s3,s2,ffffffffc0203570 <copy_string+0x66>
ffffffffc0203546:	22d070ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc020354a:	9a22                	add	s4,s4,s0
ffffffffc020354c:	94a2                	add	s1,s1,s0
ffffffffc020354e:	40890933          	sub	s2,s2,s0
ffffffffc0203552:	6985                	lui	s3,0x1
ffffffffc0203554:	4681                	li	a3,0
ffffffffc0203556:	85a6                	mv	a1,s1
ffffffffc0203558:	8556                	mv	a0,s5
ffffffffc020355a:	844a                	mv	s0,s2
ffffffffc020355c:	0129f363          	bgeu	s3,s2,ffffffffc0203562 <copy_string+0x58>
ffffffffc0203560:	844e                	mv	s0,s3
ffffffffc0203562:	8622                	mv	a2,s0
ffffffffc0203564:	eadff0ef          	jal	ra,ffffffffc0203410 <user_mem_check>
ffffffffc0203568:	87aa                	mv	a5,a0
ffffffffc020356a:	85a2                	mv	a1,s0
ffffffffc020356c:	8526                	mv	a0,s1
ffffffffc020356e:	f3f1                	bnez	a5,ffffffffc0203532 <copy_string+0x28>
ffffffffc0203570:	4501                	li	a0,0
ffffffffc0203572:	70e2                	ld	ra,56(sp)
ffffffffc0203574:	7442                	ld	s0,48(sp)
ffffffffc0203576:	74a2                	ld	s1,40(sp)
ffffffffc0203578:	7902                	ld	s2,32(sp)
ffffffffc020357a:	69e2                	ld	s3,24(sp)
ffffffffc020357c:	6a42                	ld	s4,16(sp)
ffffffffc020357e:	6aa2                	ld	s5,8(sp)
ffffffffc0203580:	6121                	addi	sp,sp,64
ffffffffc0203582:	8082                	ret
ffffffffc0203584:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc0203588:	1eb070ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc020358c:	4505                	li	a0,1
ffffffffc020358e:	b7d5                	j	ffffffffc0203572 <copy_string+0x68>

ffffffffc0203590 <slob_free>:
ffffffffc0203590:	c94d                	beqz	a0,ffffffffc0203642 <slob_free+0xb2>
ffffffffc0203592:	1141                	addi	sp,sp,-16
ffffffffc0203594:	e022                	sd	s0,0(sp)
ffffffffc0203596:	e406                	sd	ra,8(sp)
ffffffffc0203598:	842a                	mv	s0,a0
ffffffffc020359a:	e9c1                	bnez	a1,ffffffffc020362a <slob_free+0x9a>
ffffffffc020359c:	100027f3          	csrr	a5,sstatus
ffffffffc02035a0:	8b89                	andi	a5,a5,2
ffffffffc02035a2:	4501                	li	a0,0
ffffffffc02035a4:	ebd9                	bnez	a5,ffffffffc020363a <slob_free+0xaa>
ffffffffc02035a6:	0008e617          	auipc	a2,0x8e
ffffffffc02035aa:	aaa60613          	addi	a2,a2,-1366 # ffffffffc0291050 <slobfree>
ffffffffc02035ae:	621c                	ld	a5,0(a2)
ffffffffc02035b0:	873e                	mv	a4,a5
ffffffffc02035b2:	679c                	ld	a5,8(a5)
ffffffffc02035b4:	02877a63          	bgeu	a4,s0,ffffffffc02035e8 <slob_free+0x58>
ffffffffc02035b8:	00f46463          	bltu	s0,a5,ffffffffc02035c0 <slob_free+0x30>
ffffffffc02035bc:	fef76ae3          	bltu	a4,a5,ffffffffc02035b0 <slob_free+0x20>
ffffffffc02035c0:	400c                	lw	a1,0(s0)
ffffffffc02035c2:	00459693          	slli	a3,a1,0x4
ffffffffc02035c6:	96a2                	add	a3,a3,s0
ffffffffc02035c8:	02d78a63          	beq	a5,a3,ffffffffc02035fc <slob_free+0x6c>
ffffffffc02035cc:	4314                	lw	a3,0(a4)
ffffffffc02035ce:	e41c                	sd	a5,8(s0)
ffffffffc02035d0:	00469793          	slli	a5,a3,0x4
ffffffffc02035d4:	97ba                	add	a5,a5,a4
ffffffffc02035d6:	02f40e63          	beq	s0,a5,ffffffffc0203612 <slob_free+0x82>
ffffffffc02035da:	e700                	sd	s0,8(a4)
ffffffffc02035dc:	e218                	sd	a4,0(a2)
ffffffffc02035de:	e129                	bnez	a0,ffffffffc0203620 <slob_free+0x90>
ffffffffc02035e0:	60a2                	ld	ra,8(sp)
ffffffffc02035e2:	6402                	ld	s0,0(sp)
ffffffffc02035e4:	0141                	addi	sp,sp,16
ffffffffc02035e6:	8082                	ret
ffffffffc02035e8:	fcf764e3          	bltu	a4,a5,ffffffffc02035b0 <slob_free+0x20>
ffffffffc02035ec:	fcf472e3          	bgeu	s0,a5,ffffffffc02035b0 <slob_free+0x20>
ffffffffc02035f0:	400c                	lw	a1,0(s0)
ffffffffc02035f2:	00459693          	slli	a3,a1,0x4
ffffffffc02035f6:	96a2                	add	a3,a3,s0
ffffffffc02035f8:	fcd79ae3          	bne	a5,a3,ffffffffc02035cc <slob_free+0x3c>
ffffffffc02035fc:	4394                	lw	a3,0(a5)
ffffffffc02035fe:	679c                	ld	a5,8(a5)
ffffffffc0203600:	9db5                	addw	a1,a1,a3
ffffffffc0203602:	c00c                	sw	a1,0(s0)
ffffffffc0203604:	4314                	lw	a3,0(a4)
ffffffffc0203606:	e41c                	sd	a5,8(s0)
ffffffffc0203608:	00469793          	slli	a5,a3,0x4
ffffffffc020360c:	97ba                	add	a5,a5,a4
ffffffffc020360e:	fcf416e3          	bne	s0,a5,ffffffffc02035da <slob_free+0x4a>
ffffffffc0203612:	401c                	lw	a5,0(s0)
ffffffffc0203614:	640c                	ld	a1,8(s0)
ffffffffc0203616:	e218                	sd	a4,0(a2)
ffffffffc0203618:	9ebd                	addw	a3,a3,a5
ffffffffc020361a:	c314                	sw	a3,0(a4)
ffffffffc020361c:	e70c                	sd	a1,8(a4)
ffffffffc020361e:	d169                	beqz	a0,ffffffffc02035e0 <slob_free+0x50>
ffffffffc0203620:	6402                	ld	s0,0(sp)
ffffffffc0203622:	60a2                	ld	ra,8(sp)
ffffffffc0203624:	0141                	addi	sp,sp,16
ffffffffc0203626:	f74fd06f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc020362a:	25bd                	addiw	a1,a1,15
ffffffffc020362c:	8191                	srli	a1,a1,0x4
ffffffffc020362e:	c10c                	sw	a1,0(a0)
ffffffffc0203630:	100027f3          	csrr	a5,sstatus
ffffffffc0203634:	8b89                	andi	a5,a5,2
ffffffffc0203636:	4501                	li	a0,0
ffffffffc0203638:	d7bd                	beqz	a5,ffffffffc02035a6 <slob_free+0x16>
ffffffffc020363a:	f66fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020363e:	4505                	li	a0,1
ffffffffc0203640:	b79d                	j	ffffffffc02035a6 <slob_free+0x16>
ffffffffc0203642:	8082                	ret

ffffffffc0203644 <__slob_get_free_pages.constprop.0>:
ffffffffc0203644:	4785                	li	a5,1
ffffffffc0203646:	1141                	addi	sp,sp,-16
ffffffffc0203648:	00a7953b          	sllw	a0,a5,a0
ffffffffc020364c:	e406                	sd	ra,8(sp)
ffffffffc020364e:	c9dfd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203652:	c91d                	beqz	a0,ffffffffc0203688 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0203654:	00093697          	auipc	a3,0x93
ffffffffc0203658:	24c6b683          	ld	a3,588(a3) # ffffffffc02968a0 <pages>
ffffffffc020365c:	8d15                	sub	a0,a0,a3
ffffffffc020365e:	8519                	srai	a0,a0,0x6
ffffffffc0203660:	0000c697          	auipc	a3,0xc
ffffffffc0203664:	f506b683          	ld	a3,-176(a3) # ffffffffc020f5b0 <nbase>
ffffffffc0203668:	9536                	add	a0,a0,a3
ffffffffc020366a:	00c51793          	slli	a5,a0,0xc
ffffffffc020366e:	83b1                	srli	a5,a5,0xc
ffffffffc0203670:	00093717          	auipc	a4,0x93
ffffffffc0203674:	22873703          	ld	a4,552(a4) # ffffffffc0296898 <npage>
ffffffffc0203678:	0532                	slli	a0,a0,0xc
ffffffffc020367a:	00e7fa63          	bgeu	a5,a4,ffffffffc020368e <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc020367e:	00093697          	auipc	a3,0x93
ffffffffc0203682:	2326b683          	ld	a3,562(a3) # ffffffffc02968b0 <va_pa_offset>
ffffffffc0203686:	9536                	add	a0,a0,a3
ffffffffc0203688:	60a2                	ld	ra,8(sp)
ffffffffc020368a:	0141                	addi	sp,sp,16
ffffffffc020368c:	8082                	ret
ffffffffc020368e:	86aa                	mv	a3,a0
ffffffffc0203690:	00009617          	auipc	a2,0x9
ffffffffc0203694:	9a060613          	addi	a2,a2,-1632 # ffffffffc020c030 <commands+0x968>
ffffffffc0203698:	07100593          	li	a1,113
ffffffffc020369c:	00009517          	auipc	a0,0x9
ffffffffc02036a0:	95c50513          	addi	a0,a0,-1700 # ffffffffc020bff8 <commands+0x930>
ffffffffc02036a4:	b8bfc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02036a8 <slob_alloc.constprop.0>:
ffffffffc02036a8:	1101                	addi	sp,sp,-32
ffffffffc02036aa:	ec06                	sd	ra,24(sp)
ffffffffc02036ac:	e822                	sd	s0,16(sp)
ffffffffc02036ae:	e426                	sd	s1,8(sp)
ffffffffc02036b0:	e04a                	sd	s2,0(sp)
ffffffffc02036b2:	01050713          	addi	a4,a0,16
ffffffffc02036b6:	6785                	lui	a5,0x1
ffffffffc02036b8:	0cf77363          	bgeu	a4,a5,ffffffffc020377e <slob_alloc.constprop.0+0xd6>
ffffffffc02036bc:	00f50493          	addi	s1,a0,15
ffffffffc02036c0:	8091                	srli	s1,s1,0x4
ffffffffc02036c2:	2481                	sext.w	s1,s1
ffffffffc02036c4:	10002673          	csrr	a2,sstatus
ffffffffc02036c8:	8a09                	andi	a2,a2,2
ffffffffc02036ca:	e25d                	bnez	a2,ffffffffc0203770 <slob_alloc.constprop.0+0xc8>
ffffffffc02036cc:	0008e917          	auipc	s2,0x8e
ffffffffc02036d0:	98490913          	addi	s2,s2,-1660 # ffffffffc0291050 <slobfree>
ffffffffc02036d4:	00093683          	ld	a3,0(s2)
ffffffffc02036d8:	669c                	ld	a5,8(a3)
ffffffffc02036da:	4398                	lw	a4,0(a5)
ffffffffc02036dc:	08975e63          	bge	a4,s1,ffffffffc0203778 <slob_alloc.constprop.0+0xd0>
ffffffffc02036e0:	00f68b63          	beq	a3,a5,ffffffffc02036f6 <slob_alloc.constprop.0+0x4e>
ffffffffc02036e4:	6780                	ld	s0,8(a5)
ffffffffc02036e6:	4018                	lw	a4,0(s0)
ffffffffc02036e8:	02975a63          	bge	a4,s1,ffffffffc020371c <slob_alloc.constprop.0+0x74>
ffffffffc02036ec:	00093683          	ld	a3,0(s2)
ffffffffc02036f0:	87a2                	mv	a5,s0
ffffffffc02036f2:	fef699e3          	bne	a3,a5,ffffffffc02036e4 <slob_alloc.constprop.0+0x3c>
ffffffffc02036f6:	ee31                	bnez	a2,ffffffffc0203752 <slob_alloc.constprop.0+0xaa>
ffffffffc02036f8:	4501                	li	a0,0
ffffffffc02036fa:	f4bff0ef          	jal	ra,ffffffffc0203644 <__slob_get_free_pages.constprop.0>
ffffffffc02036fe:	842a                	mv	s0,a0
ffffffffc0203700:	cd05                	beqz	a0,ffffffffc0203738 <slob_alloc.constprop.0+0x90>
ffffffffc0203702:	6585                	lui	a1,0x1
ffffffffc0203704:	e8dff0ef          	jal	ra,ffffffffc0203590 <slob_free>
ffffffffc0203708:	10002673          	csrr	a2,sstatus
ffffffffc020370c:	8a09                	andi	a2,a2,2
ffffffffc020370e:	ee05                	bnez	a2,ffffffffc0203746 <slob_alloc.constprop.0+0x9e>
ffffffffc0203710:	00093783          	ld	a5,0(s2)
ffffffffc0203714:	6780                	ld	s0,8(a5)
ffffffffc0203716:	4018                	lw	a4,0(s0)
ffffffffc0203718:	fc974ae3          	blt	a4,s1,ffffffffc02036ec <slob_alloc.constprop.0+0x44>
ffffffffc020371c:	04e48763          	beq	s1,a4,ffffffffc020376a <slob_alloc.constprop.0+0xc2>
ffffffffc0203720:	00449693          	slli	a3,s1,0x4
ffffffffc0203724:	96a2                	add	a3,a3,s0
ffffffffc0203726:	e794                	sd	a3,8(a5)
ffffffffc0203728:	640c                	ld	a1,8(s0)
ffffffffc020372a:	9f05                	subw	a4,a4,s1
ffffffffc020372c:	c298                	sw	a4,0(a3)
ffffffffc020372e:	e68c                	sd	a1,8(a3)
ffffffffc0203730:	c004                	sw	s1,0(s0)
ffffffffc0203732:	00f93023          	sd	a5,0(s2)
ffffffffc0203736:	e20d                	bnez	a2,ffffffffc0203758 <slob_alloc.constprop.0+0xb0>
ffffffffc0203738:	60e2                	ld	ra,24(sp)
ffffffffc020373a:	8522                	mv	a0,s0
ffffffffc020373c:	6442                	ld	s0,16(sp)
ffffffffc020373e:	64a2                	ld	s1,8(sp)
ffffffffc0203740:	6902                	ld	s2,0(sp)
ffffffffc0203742:	6105                	addi	sp,sp,32
ffffffffc0203744:	8082                	ret
ffffffffc0203746:	e5afd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020374a:	00093783          	ld	a5,0(s2)
ffffffffc020374e:	4605                	li	a2,1
ffffffffc0203750:	b7d1                	j	ffffffffc0203714 <slob_alloc.constprop.0+0x6c>
ffffffffc0203752:	e48fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203756:	b74d                	j	ffffffffc02036f8 <slob_alloc.constprop.0+0x50>
ffffffffc0203758:	e42fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020375c:	60e2                	ld	ra,24(sp)
ffffffffc020375e:	8522                	mv	a0,s0
ffffffffc0203760:	6442                	ld	s0,16(sp)
ffffffffc0203762:	64a2                	ld	s1,8(sp)
ffffffffc0203764:	6902                	ld	s2,0(sp)
ffffffffc0203766:	6105                	addi	sp,sp,32
ffffffffc0203768:	8082                	ret
ffffffffc020376a:	6418                	ld	a4,8(s0)
ffffffffc020376c:	e798                	sd	a4,8(a5)
ffffffffc020376e:	b7d1                	j	ffffffffc0203732 <slob_alloc.constprop.0+0x8a>
ffffffffc0203770:	e30fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203774:	4605                	li	a2,1
ffffffffc0203776:	bf99                	j	ffffffffc02036cc <slob_alloc.constprop.0+0x24>
ffffffffc0203778:	843e                	mv	s0,a5
ffffffffc020377a:	87b6                	mv	a5,a3
ffffffffc020377c:	b745                	j	ffffffffc020371c <slob_alloc.constprop.0+0x74>
ffffffffc020377e:	00009697          	auipc	a3,0x9
ffffffffc0203782:	25268693          	addi	a3,a3,594 # ffffffffc020c9d0 <commands+0x1308>
ffffffffc0203786:	00008617          	auipc	a2,0x8
ffffffffc020378a:	19260613          	addi	a2,a2,402 # ffffffffc020b918 <commands+0x250>
ffffffffc020378e:	06300593          	li	a1,99
ffffffffc0203792:	00009517          	auipc	a0,0x9
ffffffffc0203796:	25e50513          	addi	a0,a0,606 # ffffffffc020c9f0 <commands+0x1328>
ffffffffc020379a:	a95fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020379e <kmalloc_init>:
ffffffffc020379e:	1141                	addi	sp,sp,-16
ffffffffc02037a0:	00009517          	auipc	a0,0x9
ffffffffc02037a4:	26850513          	addi	a0,a0,616 # ffffffffc020ca08 <commands+0x1340>
ffffffffc02037a8:	e406                	sd	ra,8(sp)
ffffffffc02037aa:	981fc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02037ae:	60a2                	ld	ra,8(sp)
ffffffffc02037b0:	00009517          	auipc	a0,0x9
ffffffffc02037b4:	27050513          	addi	a0,a0,624 # ffffffffc020ca20 <commands+0x1358>
ffffffffc02037b8:	0141                	addi	sp,sp,16
ffffffffc02037ba:	971fc06f          	j	ffffffffc020012a <cprintf>

ffffffffc02037be <kallocated>:
ffffffffc02037be:	4501                	li	a0,0
ffffffffc02037c0:	8082                	ret

ffffffffc02037c2 <kmalloc>:
ffffffffc02037c2:	1101                	addi	sp,sp,-32
ffffffffc02037c4:	e04a                	sd	s2,0(sp)
ffffffffc02037c6:	6905                	lui	s2,0x1
ffffffffc02037c8:	e822                	sd	s0,16(sp)
ffffffffc02037ca:	ec06                	sd	ra,24(sp)
ffffffffc02037cc:	e426                	sd	s1,8(sp)
ffffffffc02037ce:	fef90793          	addi	a5,s2,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc02037d2:	842a                	mv	s0,a0
ffffffffc02037d4:	04a7f963          	bgeu	a5,a0,ffffffffc0203826 <kmalloc+0x64>
ffffffffc02037d8:	4561                	li	a0,24
ffffffffc02037da:	ecfff0ef          	jal	ra,ffffffffc02036a8 <slob_alloc.constprop.0>
ffffffffc02037de:	84aa                	mv	s1,a0
ffffffffc02037e0:	c929                	beqz	a0,ffffffffc0203832 <kmalloc+0x70>
ffffffffc02037e2:	0004079b          	sext.w	a5,s0
ffffffffc02037e6:	4501                	li	a0,0
ffffffffc02037e8:	00f95763          	bge	s2,a5,ffffffffc02037f6 <kmalloc+0x34>
ffffffffc02037ec:	6705                	lui	a4,0x1
ffffffffc02037ee:	8785                	srai	a5,a5,0x1
ffffffffc02037f0:	2505                	addiw	a0,a0,1
ffffffffc02037f2:	fef74ee3          	blt	a4,a5,ffffffffc02037ee <kmalloc+0x2c>
ffffffffc02037f6:	c088                	sw	a0,0(s1)
ffffffffc02037f8:	e4dff0ef          	jal	ra,ffffffffc0203644 <__slob_get_free_pages.constprop.0>
ffffffffc02037fc:	e488                	sd	a0,8(s1)
ffffffffc02037fe:	842a                	mv	s0,a0
ffffffffc0203800:	c525                	beqz	a0,ffffffffc0203868 <kmalloc+0xa6>
ffffffffc0203802:	100027f3          	csrr	a5,sstatus
ffffffffc0203806:	8b89                	andi	a5,a5,2
ffffffffc0203808:	ef8d                	bnez	a5,ffffffffc0203842 <kmalloc+0x80>
ffffffffc020380a:	00093797          	auipc	a5,0x93
ffffffffc020380e:	0ae78793          	addi	a5,a5,174 # ffffffffc02968b8 <bigblocks>
ffffffffc0203812:	6398                	ld	a4,0(a5)
ffffffffc0203814:	e384                	sd	s1,0(a5)
ffffffffc0203816:	e898                	sd	a4,16(s1)
ffffffffc0203818:	60e2                	ld	ra,24(sp)
ffffffffc020381a:	8522                	mv	a0,s0
ffffffffc020381c:	6442                	ld	s0,16(sp)
ffffffffc020381e:	64a2                	ld	s1,8(sp)
ffffffffc0203820:	6902                	ld	s2,0(sp)
ffffffffc0203822:	6105                	addi	sp,sp,32
ffffffffc0203824:	8082                	ret
ffffffffc0203826:	0541                	addi	a0,a0,16
ffffffffc0203828:	e81ff0ef          	jal	ra,ffffffffc02036a8 <slob_alloc.constprop.0>
ffffffffc020382c:	01050413          	addi	s0,a0,16
ffffffffc0203830:	f565                	bnez	a0,ffffffffc0203818 <kmalloc+0x56>
ffffffffc0203832:	4401                	li	s0,0
ffffffffc0203834:	60e2                	ld	ra,24(sp)
ffffffffc0203836:	8522                	mv	a0,s0
ffffffffc0203838:	6442                	ld	s0,16(sp)
ffffffffc020383a:	64a2                	ld	s1,8(sp)
ffffffffc020383c:	6902                	ld	s2,0(sp)
ffffffffc020383e:	6105                	addi	sp,sp,32
ffffffffc0203840:	8082                	ret
ffffffffc0203842:	d5efd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203846:	00093797          	auipc	a5,0x93
ffffffffc020384a:	07278793          	addi	a5,a5,114 # ffffffffc02968b8 <bigblocks>
ffffffffc020384e:	6398                	ld	a4,0(a5)
ffffffffc0203850:	e384                	sd	s1,0(a5)
ffffffffc0203852:	e898                	sd	a4,16(s1)
ffffffffc0203854:	d46fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203858:	6480                	ld	s0,8(s1)
ffffffffc020385a:	60e2                	ld	ra,24(sp)
ffffffffc020385c:	64a2                	ld	s1,8(sp)
ffffffffc020385e:	8522                	mv	a0,s0
ffffffffc0203860:	6442                	ld	s0,16(sp)
ffffffffc0203862:	6902                	ld	s2,0(sp)
ffffffffc0203864:	6105                	addi	sp,sp,32
ffffffffc0203866:	8082                	ret
ffffffffc0203868:	45e1                	li	a1,24
ffffffffc020386a:	8526                	mv	a0,s1
ffffffffc020386c:	d25ff0ef          	jal	ra,ffffffffc0203590 <slob_free>
ffffffffc0203870:	b765                	j	ffffffffc0203818 <kmalloc+0x56>

ffffffffc0203872 <kfree>:
ffffffffc0203872:	c179                	beqz	a0,ffffffffc0203938 <kfree+0xc6>
ffffffffc0203874:	1101                	addi	sp,sp,-32
ffffffffc0203876:	e822                	sd	s0,16(sp)
ffffffffc0203878:	ec06                	sd	ra,24(sp)
ffffffffc020387a:	e426                	sd	s1,8(sp)
ffffffffc020387c:	03451793          	slli	a5,a0,0x34
ffffffffc0203880:	842a                	mv	s0,a0
ffffffffc0203882:	e7c1                	bnez	a5,ffffffffc020390a <kfree+0x98>
ffffffffc0203884:	100027f3          	csrr	a5,sstatus
ffffffffc0203888:	8b89                	andi	a5,a5,2
ffffffffc020388a:	ebc9                	bnez	a5,ffffffffc020391c <kfree+0xaa>
ffffffffc020388c:	00093797          	auipc	a5,0x93
ffffffffc0203890:	02c7b783          	ld	a5,44(a5) # ffffffffc02968b8 <bigblocks>
ffffffffc0203894:	4601                	li	a2,0
ffffffffc0203896:	cbb5                	beqz	a5,ffffffffc020390a <kfree+0x98>
ffffffffc0203898:	00093697          	auipc	a3,0x93
ffffffffc020389c:	02068693          	addi	a3,a3,32 # ffffffffc02968b8 <bigblocks>
ffffffffc02038a0:	a021                	j	ffffffffc02038a8 <kfree+0x36>
ffffffffc02038a2:	01048693          	addi	a3,s1,16
ffffffffc02038a6:	c3ad                	beqz	a5,ffffffffc0203908 <kfree+0x96>
ffffffffc02038a8:	6798                	ld	a4,8(a5)
ffffffffc02038aa:	84be                	mv	s1,a5
ffffffffc02038ac:	6b9c                	ld	a5,16(a5)
ffffffffc02038ae:	fe871ae3          	bne	a4,s0,ffffffffc02038a2 <kfree+0x30>
ffffffffc02038b2:	e29c                	sd	a5,0(a3)
ffffffffc02038b4:	ee3d                	bnez	a2,ffffffffc0203932 <kfree+0xc0>
ffffffffc02038b6:	c02007b7          	lui	a5,0xc0200
ffffffffc02038ba:	4098                	lw	a4,0(s1)
ffffffffc02038bc:	08f46b63          	bltu	s0,a5,ffffffffc0203952 <kfree+0xe0>
ffffffffc02038c0:	00093697          	auipc	a3,0x93
ffffffffc02038c4:	ff06b683          	ld	a3,-16(a3) # ffffffffc02968b0 <va_pa_offset>
ffffffffc02038c8:	8c15                	sub	s0,s0,a3
ffffffffc02038ca:	8031                	srli	s0,s0,0xc
ffffffffc02038cc:	00093797          	auipc	a5,0x93
ffffffffc02038d0:	fcc7b783          	ld	a5,-52(a5) # ffffffffc0296898 <npage>
ffffffffc02038d4:	06f47363          	bgeu	s0,a5,ffffffffc020393a <kfree+0xc8>
ffffffffc02038d8:	0000c517          	auipc	a0,0xc
ffffffffc02038dc:	cd853503          	ld	a0,-808(a0) # ffffffffc020f5b0 <nbase>
ffffffffc02038e0:	8c09                	sub	s0,s0,a0
ffffffffc02038e2:	041a                	slli	s0,s0,0x6
ffffffffc02038e4:	00093517          	auipc	a0,0x93
ffffffffc02038e8:	fbc53503          	ld	a0,-68(a0) # ffffffffc02968a0 <pages>
ffffffffc02038ec:	4585                	li	a1,1
ffffffffc02038ee:	9522                	add	a0,a0,s0
ffffffffc02038f0:	00e595bb          	sllw	a1,a1,a4
ffffffffc02038f4:	a35fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc02038f8:	6442                	ld	s0,16(sp)
ffffffffc02038fa:	60e2                	ld	ra,24(sp)
ffffffffc02038fc:	8526                	mv	a0,s1
ffffffffc02038fe:	64a2                	ld	s1,8(sp)
ffffffffc0203900:	45e1                	li	a1,24
ffffffffc0203902:	6105                	addi	sp,sp,32
ffffffffc0203904:	c8dff06f          	j	ffffffffc0203590 <slob_free>
ffffffffc0203908:	e215                	bnez	a2,ffffffffc020392c <kfree+0xba>
ffffffffc020390a:	ff040513          	addi	a0,s0,-16
ffffffffc020390e:	6442                	ld	s0,16(sp)
ffffffffc0203910:	60e2                	ld	ra,24(sp)
ffffffffc0203912:	64a2                	ld	s1,8(sp)
ffffffffc0203914:	4581                	li	a1,0
ffffffffc0203916:	6105                	addi	sp,sp,32
ffffffffc0203918:	c79ff06f          	j	ffffffffc0203590 <slob_free>
ffffffffc020391c:	c84fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203920:	00093797          	auipc	a5,0x93
ffffffffc0203924:	f987b783          	ld	a5,-104(a5) # ffffffffc02968b8 <bigblocks>
ffffffffc0203928:	4605                	li	a2,1
ffffffffc020392a:	f7bd                	bnez	a5,ffffffffc0203898 <kfree+0x26>
ffffffffc020392c:	c6efd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203930:	bfe9                	j	ffffffffc020390a <kfree+0x98>
ffffffffc0203932:	c68fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203936:	b741                	j	ffffffffc02038b6 <kfree+0x44>
ffffffffc0203938:	8082                	ret
ffffffffc020393a:	00008617          	auipc	a2,0x8
ffffffffc020393e:	69e60613          	addi	a2,a2,1694 # ffffffffc020bfd8 <commands+0x910>
ffffffffc0203942:	06900593          	li	a1,105
ffffffffc0203946:	00008517          	auipc	a0,0x8
ffffffffc020394a:	6b250513          	addi	a0,a0,1714 # ffffffffc020bff8 <commands+0x930>
ffffffffc020394e:	8e1fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203952:	86a2                	mv	a3,s0
ffffffffc0203954:	00008617          	auipc	a2,0x8
ffffffffc0203958:	7fc60613          	addi	a2,a2,2044 # ffffffffc020c150 <commands+0xa88>
ffffffffc020395c:	07700593          	li	a1,119
ffffffffc0203960:	00008517          	auipc	a0,0x8
ffffffffc0203964:	69850513          	addi	a0,a0,1688 # ffffffffc020bff8 <commands+0x930>
ffffffffc0203968:	8c7fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020396c <default_init>:
ffffffffc020396c:	0008e797          	auipc	a5,0x8e
ffffffffc0203970:	e3c78793          	addi	a5,a5,-452 # ffffffffc02917a8 <free_area>
ffffffffc0203974:	e79c                	sd	a5,8(a5)
ffffffffc0203976:	e39c                	sd	a5,0(a5)
ffffffffc0203978:	0007a823          	sw	zero,16(a5)
ffffffffc020397c:	8082                	ret

ffffffffc020397e <default_nr_free_pages>:
ffffffffc020397e:	0008e517          	auipc	a0,0x8e
ffffffffc0203982:	e3a56503          	lwu	a0,-454(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0203986:	8082                	ret

ffffffffc0203988 <default_check>:
ffffffffc0203988:	715d                	addi	sp,sp,-80
ffffffffc020398a:	e0a2                	sd	s0,64(sp)
ffffffffc020398c:	0008e417          	auipc	s0,0x8e
ffffffffc0203990:	e1c40413          	addi	s0,s0,-484 # ffffffffc02917a8 <free_area>
ffffffffc0203994:	641c                	ld	a5,8(s0)
ffffffffc0203996:	e486                	sd	ra,72(sp)
ffffffffc0203998:	fc26                	sd	s1,56(sp)
ffffffffc020399a:	f84a                	sd	s2,48(sp)
ffffffffc020399c:	f44e                	sd	s3,40(sp)
ffffffffc020399e:	f052                	sd	s4,32(sp)
ffffffffc02039a0:	ec56                	sd	s5,24(sp)
ffffffffc02039a2:	e85a                	sd	s6,16(sp)
ffffffffc02039a4:	e45e                	sd	s7,8(sp)
ffffffffc02039a6:	e062                	sd	s8,0(sp)
ffffffffc02039a8:	2a878d63          	beq	a5,s0,ffffffffc0203c62 <default_check+0x2da>
ffffffffc02039ac:	4481                	li	s1,0
ffffffffc02039ae:	4901                	li	s2,0
ffffffffc02039b0:	ff07b703          	ld	a4,-16(a5)
ffffffffc02039b4:	8b09                	andi	a4,a4,2
ffffffffc02039b6:	2a070a63          	beqz	a4,ffffffffc0203c6a <default_check+0x2e2>
ffffffffc02039ba:	ff87a703          	lw	a4,-8(a5)
ffffffffc02039be:	679c                	ld	a5,8(a5)
ffffffffc02039c0:	2905                	addiw	s2,s2,1
ffffffffc02039c2:	9cb9                	addw	s1,s1,a4
ffffffffc02039c4:	fe8796e3          	bne	a5,s0,ffffffffc02039b0 <default_check+0x28>
ffffffffc02039c8:	89a6                	mv	s3,s1
ffffffffc02039ca:	99ffd0ef          	jal	ra,ffffffffc0201368 <nr_free_pages>
ffffffffc02039ce:	6f351e63          	bne	a0,s3,ffffffffc02040ca <default_check+0x742>
ffffffffc02039d2:	4505                	li	a0,1
ffffffffc02039d4:	917fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc02039d8:	8aaa                	mv	s5,a0
ffffffffc02039da:	42050863          	beqz	a0,ffffffffc0203e0a <default_check+0x482>
ffffffffc02039de:	4505                	li	a0,1
ffffffffc02039e0:	90bfd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc02039e4:	89aa                	mv	s3,a0
ffffffffc02039e6:	70050263          	beqz	a0,ffffffffc02040ea <default_check+0x762>
ffffffffc02039ea:	4505                	li	a0,1
ffffffffc02039ec:	8fffd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc02039f0:	8a2a                	mv	s4,a0
ffffffffc02039f2:	48050c63          	beqz	a0,ffffffffc0203e8a <default_check+0x502>
ffffffffc02039f6:	293a8a63          	beq	s5,s3,ffffffffc0203c8a <default_check+0x302>
ffffffffc02039fa:	28aa8863          	beq	s5,a0,ffffffffc0203c8a <default_check+0x302>
ffffffffc02039fe:	28a98663          	beq	s3,a0,ffffffffc0203c8a <default_check+0x302>
ffffffffc0203a02:	000aa783          	lw	a5,0(s5)
ffffffffc0203a06:	2a079263          	bnez	a5,ffffffffc0203caa <default_check+0x322>
ffffffffc0203a0a:	0009a783          	lw	a5,0(s3) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203a0e:	28079e63          	bnez	a5,ffffffffc0203caa <default_check+0x322>
ffffffffc0203a12:	411c                	lw	a5,0(a0)
ffffffffc0203a14:	28079b63          	bnez	a5,ffffffffc0203caa <default_check+0x322>
ffffffffc0203a18:	00093797          	auipc	a5,0x93
ffffffffc0203a1c:	e887b783          	ld	a5,-376(a5) # ffffffffc02968a0 <pages>
ffffffffc0203a20:	40fa8733          	sub	a4,s5,a5
ffffffffc0203a24:	0000c617          	auipc	a2,0xc
ffffffffc0203a28:	b8c63603          	ld	a2,-1140(a2) # ffffffffc020f5b0 <nbase>
ffffffffc0203a2c:	8719                	srai	a4,a4,0x6
ffffffffc0203a2e:	9732                	add	a4,a4,a2
ffffffffc0203a30:	00093697          	auipc	a3,0x93
ffffffffc0203a34:	e686b683          	ld	a3,-408(a3) # ffffffffc0296898 <npage>
ffffffffc0203a38:	06b2                	slli	a3,a3,0xc
ffffffffc0203a3a:	0732                	slli	a4,a4,0xc
ffffffffc0203a3c:	28d77763          	bgeu	a4,a3,ffffffffc0203cca <default_check+0x342>
ffffffffc0203a40:	40f98733          	sub	a4,s3,a5
ffffffffc0203a44:	8719                	srai	a4,a4,0x6
ffffffffc0203a46:	9732                	add	a4,a4,a2
ffffffffc0203a48:	0732                	slli	a4,a4,0xc
ffffffffc0203a4a:	4cd77063          	bgeu	a4,a3,ffffffffc0203f0a <default_check+0x582>
ffffffffc0203a4e:	40f507b3          	sub	a5,a0,a5
ffffffffc0203a52:	8799                	srai	a5,a5,0x6
ffffffffc0203a54:	97b2                	add	a5,a5,a2
ffffffffc0203a56:	07b2                	slli	a5,a5,0xc
ffffffffc0203a58:	30d7f963          	bgeu	a5,a3,ffffffffc0203d6a <default_check+0x3e2>
ffffffffc0203a5c:	4505                	li	a0,1
ffffffffc0203a5e:	00043c03          	ld	s8,0(s0)
ffffffffc0203a62:	00843b83          	ld	s7,8(s0)
ffffffffc0203a66:	01042b03          	lw	s6,16(s0)
ffffffffc0203a6a:	e400                	sd	s0,8(s0)
ffffffffc0203a6c:	e000                	sd	s0,0(s0)
ffffffffc0203a6e:	0008e797          	auipc	a5,0x8e
ffffffffc0203a72:	d407a523          	sw	zero,-694(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0203a76:	875fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203a7a:	2c051863          	bnez	a0,ffffffffc0203d4a <default_check+0x3c2>
ffffffffc0203a7e:	4585                	li	a1,1
ffffffffc0203a80:	8556                	mv	a0,s5
ffffffffc0203a82:	8a7fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203a86:	4585                	li	a1,1
ffffffffc0203a88:	854e                	mv	a0,s3
ffffffffc0203a8a:	89ffd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203a8e:	4585                	li	a1,1
ffffffffc0203a90:	8552                	mv	a0,s4
ffffffffc0203a92:	897fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203a96:	4818                	lw	a4,16(s0)
ffffffffc0203a98:	478d                	li	a5,3
ffffffffc0203a9a:	28f71863          	bne	a4,a5,ffffffffc0203d2a <default_check+0x3a2>
ffffffffc0203a9e:	4505                	li	a0,1
ffffffffc0203aa0:	84bfd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203aa4:	89aa                	mv	s3,a0
ffffffffc0203aa6:	26050263          	beqz	a0,ffffffffc0203d0a <default_check+0x382>
ffffffffc0203aaa:	4505                	li	a0,1
ffffffffc0203aac:	83ffd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203ab0:	8aaa                	mv	s5,a0
ffffffffc0203ab2:	3a050c63          	beqz	a0,ffffffffc0203e6a <default_check+0x4e2>
ffffffffc0203ab6:	4505                	li	a0,1
ffffffffc0203ab8:	833fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203abc:	8a2a                	mv	s4,a0
ffffffffc0203abe:	38050663          	beqz	a0,ffffffffc0203e4a <default_check+0x4c2>
ffffffffc0203ac2:	4505                	li	a0,1
ffffffffc0203ac4:	827fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203ac8:	36051163          	bnez	a0,ffffffffc0203e2a <default_check+0x4a2>
ffffffffc0203acc:	4585                	li	a1,1
ffffffffc0203ace:	854e                	mv	a0,s3
ffffffffc0203ad0:	859fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203ad4:	641c                	ld	a5,8(s0)
ffffffffc0203ad6:	20878a63          	beq	a5,s0,ffffffffc0203cea <default_check+0x362>
ffffffffc0203ada:	4505                	li	a0,1
ffffffffc0203adc:	80ffd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203ae0:	30a99563          	bne	s3,a0,ffffffffc0203dea <default_check+0x462>
ffffffffc0203ae4:	4505                	li	a0,1
ffffffffc0203ae6:	805fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203aea:	2e051063          	bnez	a0,ffffffffc0203dca <default_check+0x442>
ffffffffc0203aee:	481c                	lw	a5,16(s0)
ffffffffc0203af0:	2a079d63          	bnez	a5,ffffffffc0203daa <default_check+0x422>
ffffffffc0203af4:	854e                	mv	a0,s3
ffffffffc0203af6:	4585                	li	a1,1
ffffffffc0203af8:	01843023          	sd	s8,0(s0)
ffffffffc0203afc:	01743423          	sd	s7,8(s0)
ffffffffc0203b00:	01642823          	sw	s6,16(s0)
ffffffffc0203b04:	825fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203b08:	4585                	li	a1,1
ffffffffc0203b0a:	8556                	mv	a0,s5
ffffffffc0203b0c:	81dfd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203b10:	4585                	li	a1,1
ffffffffc0203b12:	8552                	mv	a0,s4
ffffffffc0203b14:	815fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203b18:	4515                	li	a0,5
ffffffffc0203b1a:	fd0fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203b1e:	89aa                	mv	s3,a0
ffffffffc0203b20:	26050563          	beqz	a0,ffffffffc0203d8a <default_check+0x402>
ffffffffc0203b24:	651c                	ld	a5,8(a0)
ffffffffc0203b26:	8385                	srli	a5,a5,0x1
ffffffffc0203b28:	8b85                	andi	a5,a5,1
ffffffffc0203b2a:	54079063          	bnez	a5,ffffffffc020406a <default_check+0x6e2>
ffffffffc0203b2e:	4505                	li	a0,1
ffffffffc0203b30:	00043b03          	ld	s6,0(s0)
ffffffffc0203b34:	00843a83          	ld	s5,8(s0)
ffffffffc0203b38:	e000                	sd	s0,0(s0)
ffffffffc0203b3a:	e400                	sd	s0,8(s0)
ffffffffc0203b3c:	faefd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203b40:	50051563          	bnez	a0,ffffffffc020404a <default_check+0x6c2>
ffffffffc0203b44:	08098a13          	addi	s4,s3,128
ffffffffc0203b48:	8552                	mv	a0,s4
ffffffffc0203b4a:	458d                	li	a1,3
ffffffffc0203b4c:	01042b83          	lw	s7,16(s0)
ffffffffc0203b50:	0008e797          	auipc	a5,0x8e
ffffffffc0203b54:	c607a423          	sw	zero,-920(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0203b58:	fd0fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203b5c:	4511                	li	a0,4
ffffffffc0203b5e:	f8cfd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203b62:	4c051463          	bnez	a0,ffffffffc020402a <default_check+0x6a2>
ffffffffc0203b66:	0889b783          	ld	a5,136(s3)
ffffffffc0203b6a:	8385                	srli	a5,a5,0x1
ffffffffc0203b6c:	8b85                	andi	a5,a5,1
ffffffffc0203b6e:	48078e63          	beqz	a5,ffffffffc020400a <default_check+0x682>
ffffffffc0203b72:	0909a703          	lw	a4,144(s3)
ffffffffc0203b76:	478d                	li	a5,3
ffffffffc0203b78:	48f71963          	bne	a4,a5,ffffffffc020400a <default_check+0x682>
ffffffffc0203b7c:	450d                	li	a0,3
ffffffffc0203b7e:	f6cfd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203b82:	8c2a                	mv	s8,a0
ffffffffc0203b84:	46050363          	beqz	a0,ffffffffc0203fea <default_check+0x662>
ffffffffc0203b88:	4505                	li	a0,1
ffffffffc0203b8a:	f60fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203b8e:	42051e63          	bnez	a0,ffffffffc0203fca <default_check+0x642>
ffffffffc0203b92:	418a1c63          	bne	s4,s8,ffffffffc0203faa <default_check+0x622>
ffffffffc0203b96:	4585                	li	a1,1
ffffffffc0203b98:	854e                	mv	a0,s3
ffffffffc0203b9a:	f8efd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203b9e:	458d                	li	a1,3
ffffffffc0203ba0:	8552                	mv	a0,s4
ffffffffc0203ba2:	f86fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203ba6:	0089b783          	ld	a5,8(s3)
ffffffffc0203baa:	04098c13          	addi	s8,s3,64
ffffffffc0203bae:	8385                	srli	a5,a5,0x1
ffffffffc0203bb0:	8b85                	andi	a5,a5,1
ffffffffc0203bb2:	3c078c63          	beqz	a5,ffffffffc0203f8a <default_check+0x602>
ffffffffc0203bb6:	0109a703          	lw	a4,16(s3)
ffffffffc0203bba:	4785                	li	a5,1
ffffffffc0203bbc:	3cf71763          	bne	a4,a5,ffffffffc0203f8a <default_check+0x602>
ffffffffc0203bc0:	008a3783          	ld	a5,8(s4) # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc0203bc4:	8385                	srli	a5,a5,0x1
ffffffffc0203bc6:	8b85                	andi	a5,a5,1
ffffffffc0203bc8:	3a078163          	beqz	a5,ffffffffc0203f6a <default_check+0x5e2>
ffffffffc0203bcc:	010a2703          	lw	a4,16(s4)
ffffffffc0203bd0:	478d                	li	a5,3
ffffffffc0203bd2:	38f71c63          	bne	a4,a5,ffffffffc0203f6a <default_check+0x5e2>
ffffffffc0203bd6:	4505                	li	a0,1
ffffffffc0203bd8:	f12fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203bdc:	36a99763          	bne	s3,a0,ffffffffc0203f4a <default_check+0x5c2>
ffffffffc0203be0:	4585                	li	a1,1
ffffffffc0203be2:	f46fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203be6:	4509                	li	a0,2
ffffffffc0203be8:	f02fd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203bec:	32aa1f63          	bne	s4,a0,ffffffffc0203f2a <default_check+0x5a2>
ffffffffc0203bf0:	4589                	li	a1,2
ffffffffc0203bf2:	f36fd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203bf6:	4585                	li	a1,1
ffffffffc0203bf8:	8562                	mv	a0,s8
ffffffffc0203bfa:	f2efd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203bfe:	4515                	li	a0,5
ffffffffc0203c00:	eeafd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203c04:	89aa                	mv	s3,a0
ffffffffc0203c06:	48050263          	beqz	a0,ffffffffc020408a <default_check+0x702>
ffffffffc0203c0a:	4505                	li	a0,1
ffffffffc0203c0c:	edefd0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0203c10:	2c051d63          	bnez	a0,ffffffffc0203eea <default_check+0x562>
ffffffffc0203c14:	481c                	lw	a5,16(s0)
ffffffffc0203c16:	2a079a63          	bnez	a5,ffffffffc0203eca <default_check+0x542>
ffffffffc0203c1a:	4595                	li	a1,5
ffffffffc0203c1c:	854e                	mv	a0,s3
ffffffffc0203c1e:	01742823          	sw	s7,16(s0)
ffffffffc0203c22:	01643023          	sd	s6,0(s0)
ffffffffc0203c26:	01543423          	sd	s5,8(s0)
ffffffffc0203c2a:	efefd0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0203c2e:	641c                	ld	a5,8(s0)
ffffffffc0203c30:	00878963          	beq	a5,s0,ffffffffc0203c42 <default_check+0x2ba>
ffffffffc0203c34:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203c38:	679c                	ld	a5,8(a5)
ffffffffc0203c3a:	397d                	addiw	s2,s2,-1
ffffffffc0203c3c:	9c99                	subw	s1,s1,a4
ffffffffc0203c3e:	fe879be3          	bne	a5,s0,ffffffffc0203c34 <default_check+0x2ac>
ffffffffc0203c42:	26091463          	bnez	s2,ffffffffc0203eaa <default_check+0x522>
ffffffffc0203c46:	46049263          	bnez	s1,ffffffffc02040aa <default_check+0x722>
ffffffffc0203c4a:	60a6                	ld	ra,72(sp)
ffffffffc0203c4c:	6406                	ld	s0,64(sp)
ffffffffc0203c4e:	74e2                	ld	s1,56(sp)
ffffffffc0203c50:	7942                	ld	s2,48(sp)
ffffffffc0203c52:	79a2                	ld	s3,40(sp)
ffffffffc0203c54:	7a02                	ld	s4,32(sp)
ffffffffc0203c56:	6ae2                	ld	s5,24(sp)
ffffffffc0203c58:	6b42                	ld	s6,16(sp)
ffffffffc0203c5a:	6ba2                	ld	s7,8(sp)
ffffffffc0203c5c:	6c02                	ld	s8,0(sp)
ffffffffc0203c5e:	6161                	addi	sp,sp,80
ffffffffc0203c60:	8082                	ret
ffffffffc0203c62:	4981                	li	s3,0
ffffffffc0203c64:	4481                	li	s1,0
ffffffffc0203c66:	4901                	li	s2,0
ffffffffc0203c68:	b38d                	j	ffffffffc02039ca <default_check+0x42>
ffffffffc0203c6a:	00009697          	auipc	a3,0x9
ffffffffc0203c6e:	dd668693          	addi	a3,a3,-554 # ffffffffc020ca40 <commands+0x1378>
ffffffffc0203c72:	00008617          	auipc	a2,0x8
ffffffffc0203c76:	ca660613          	addi	a2,a2,-858 # ffffffffc020b918 <commands+0x250>
ffffffffc0203c7a:	0ef00593          	li	a1,239
ffffffffc0203c7e:	00009517          	auipc	a0,0x9
ffffffffc0203c82:	dd250513          	addi	a0,a0,-558 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203c86:	da8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203c8a:	00009697          	auipc	a3,0x9
ffffffffc0203c8e:	e5e68693          	addi	a3,a3,-418 # ffffffffc020cae8 <commands+0x1420>
ffffffffc0203c92:	00008617          	auipc	a2,0x8
ffffffffc0203c96:	c8660613          	addi	a2,a2,-890 # ffffffffc020b918 <commands+0x250>
ffffffffc0203c9a:	0bc00593          	li	a1,188
ffffffffc0203c9e:	00009517          	auipc	a0,0x9
ffffffffc0203ca2:	db250513          	addi	a0,a0,-590 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203ca6:	d88fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203caa:	00009697          	auipc	a3,0x9
ffffffffc0203cae:	e6668693          	addi	a3,a3,-410 # ffffffffc020cb10 <commands+0x1448>
ffffffffc0203cb2:	00008617          	auipc	a2,0x8
ffffffffc0203cb6:	c6660613          	addi	a2,a2,-922 # ffffffffc020b918 <commands+0x250>
ffffffffc0203cba:	0bd00593          	li	a1,189
ffffffffc0203cbe:	00009517          	auipc	a0,0x9
ffffffffc0203cc2:	d9250513          	addi	a0,a0,-622 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203cc6:	d68fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203cca:	00009697          	auipc	a3,0x9
ffffffffc0203cce:	e8668693          	addi	a3,a3,-378 # ffffffffc020cb50 <commands+0x1488>
ffffffffc0203cd2:	00008617          	auipc	a2,0x8
ffffffffc0203cd6:	c4660613          	addi	a2,a2,-954 # ffffffffc020b918 <commands+0x250>
ffffffffc0203cda:	0bf00593          	li	a1,191
ffffffffc0203cde:	00009517          	auipc	a0,0x9
ffffffffc0203ce2:	d7250513          	addi	a0,a0,-654 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203ce6:	d48fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203cea:	00009697          	auipc	a3,0x9
ffffffffc0203cee:	eee68693          	addi	a3,a3,-274 # ffffffffc020cbd8 <commands+0x1510>
ffffffffc0203cf2:	00008617          	auipc	a2,0x8
ffffffffc0203cf6:	c2660613          	addi	a2,a2,-986 # ffffffffc020b918 <commands+0x250>
ffffffffc0203cfa:	0d800593          	li	a1,216
ffffffffc0203cfe:	00009517          	auipc	a0,0x9
ffffffffc0203d02:	d5250513          	addi	a0,a0,-686 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203d06:	d28fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d0a:	00009697          	auipc	a3,0x9
ffffffffc0203d0e:	d7e68693          	addi	a3,a3,-642 # ffffffffc020ca88 <commands+0x13c0>
ffffffffc0203d12:	00008617          	auipc	a2,0x8
ffffffffc0203d16:	c0660613          	addi	a2,a2,-1018 # ffffffffc020b918 <commands+0x250>
ffffffffc0203d1a:	0d100593          	li	a1,209
ffffffffc0203d1e:	00009517          	auipc	a0,0x9
ffffffffc0203d22:	d3250513          	addi	a0,a0,-718 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203d26:	d08fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d2a:	00009697          	auipc	a3,0x9
ffffffffc0203d2e:	e9e68693          	addi	a3,a3,-354 # ffffffffc020cbc8 <commands+0x1500>
ffffffffc0203d32:	00008617          	auipc	a2,0x8
ffffffffc0203d36:	be660613          	addi	a2,a2,-1050 # ffffffffc020b918 <commands+0x250>
ffffffffc0203d3a:	0cf00593          	li	a1,207
ffffffffc0203d3e:	00009517          	auipc	a0,0x9
ffffffffc0203d42:	d1250513          	addi	a0,a0,-750 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203d46:	ce8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d4a:	00009697          	auipc	a3,0x9
ffffffffc0203d4e:	e6668693          	addi	a3,a3,-410 # ffffffffc020cbb0 <commands+0x14e8>
ffffffffc0203d52:	00008617          	auipc	a2,0x8
ffffffffc0203d56:	bc660613          	addi	a2,a2,-1082 # ffffffffc020b918 <commands+0x250>
ffffffffc0203d5a:	0ca00593          	li	a1,202
ffffffffc0203d5e:	00009517          	auipc	a0,0x9
ffffffffc0203d62:	cf250513          	addi	a0,a0,-782 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203d66:	cc8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d6a:	00009697          	auipc	a3,0x9
ffffffffc0203d6e:	e2668693          	addi	a3,a3,-474 # ffffffffc020cb90 <commands+0x14c8>
ffffffffc0203d72:	00008617          	auipc	a2,0x8
ffffffffc0203d76:	ba660613          	addi	a2,a2,-1114 # ffffffffc020b918 <commands+0x250>
ffffffffc0203d7a:	0c100593          	li	a1,193
ffffffffc0203d7e:	00009517          	auipc	a0,0x9
ffffffffc0203d82:	cd250513          	addi	a0,a0,-814 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203d86:	ca8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d8a:	00009697          	auipc	a3,0x9
ffffffffc0203d8e:	e9668693          	addi	a3,a3,-362 # ffffffffc020cc20 <commands+0x1558>
ffffffffc0203d92:	00008617          	auipc	a2,0x8
ffffffffc0203d96:	b8660613          	addi	a2,a2,-1146 # ffffffffc020b918 <commands+0x250>
ffffffffc0203d9a:	0f700593          	li	a1,247
ffffffffc0203d9e:	00009517          	auipc	a0,0x9
ffffffffc0203da2:	cb250513          	addi	a0,a0,-846 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203da6:	c88fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203daa:	00009697          	auipc	a3,0x9
ffffffffc0203dae:	e6668693          	addi	a3,a3,-410 # ffffffffc020cc10 <commands+0x1548>
ffffffffc0203db2:	00008617          	auipc	a2,0x8
ffffffffc0203db6:	b6660613          	addi	a2,a2,-1178 # ffffffffc020b918 <commands+0x250>
ffffffffc0203dba:	0de00593          	li	a1,222
ffffffffc0203dbe:	00009517          	auipc	a0,0x9
ffffffffc0203dc2:	c9250513          	addi	a0,a0,-878 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203dc6:	c68fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203dca:	00009697          	auipc	a3,0x9
ffffffffc0203dce:	de668693          	addi	a3,a3,-538 # ffffffffc020cbb0 <commands+0x14e8>
ffffffffc0203dd2:	00008617          	auipc	a2,0x8
ffffffffc0203dd6:	b4660613          	addi	a2,a2,-1210 # ffffffffc020b918 <commands+0x250>
ffffffffc0203dda:	0dc00593          	li	a1,220
ffffffffc0203dde:	00009517          	auipc	a0,0x9
ffffffffc0203de2:	c7250513          	addi	a0,a0,-910 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203de6:	c48fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203dea:	00009697          	auipc	a3,0x9
ffffffffc0203dee:	e0668693          	addi	a3,a3,-506 # ffffffffc020cbf0 <commands+0x1528>
ffffffffc0203df2:	00008617          	auipc	a2,0x8
ffffffffc0203df6:	b2660613          	addi	a2,a2,-1242 # ffffffffc020b918 <commands+0x250>
ffffffffc0203dfa:	0db00593          	li	a1,219
ffffffffc0203dfe:	00009517          	auipc	a0,0x9
ffffffffc0203e02:	c5250513          	addi	a0,a0,-942 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203e06:	c28fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e0a:	00009697          	auipc	a3,0x9
ffffffffc0203e0e:	c7e68693          	addi	a3,a3,-898 # ffffffffc020ca88 <commands+0x13c0>
ffffffffc0203e12:	00008617          	auipc	a2,0x8
ffffffffc0203e16:	b0660613          	addi	a2,a2,-1274 # ffffffffc020b918 <commands+0x250>
ffffffffc0203e1a:	0b800593          	li	a1,184
ffffffffc0203e1e:	00009517          	auipc	a0,0x9
ffffffffc0203e22:	c3250513          	addi	a0,a0,-974 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203e26:	c08fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e2a:	00009697          	auipc	a3,0x9
ffffffffc0203e2e:	d8668693          	addi	a3,a3,-634 # ffffffffc020cbb0 <commands+0x14e8>
ffffffffc0203e32:	00008617          	auipc	a2,0x8
ffffffffc0203e36:	ae660613          	addi	a2,a2,-1306 # ffffffffc020b918 <commands+0x250>
ffffffffc0203e3a:	0d500593          	li	a1,213
ffffffffc0203e3e:	00009517          	auipc	a0,0x9
ffffffffc0203e42:	c1250513          	addi	a0,a0,-1006 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203e46:	be8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e4a:	00009697          	auipc	a3,0x9
ffffffffc0203e4e:	c7e68693          	addi	a3,a3,-898 # ffffffffc020cac8 <commands+0x1400>
ffffffffc0203e52:	00008617          	auipc	a2,0x8
ffffffffc0203e56:	ac660613          	addi	a2,a2,-1338 # ffffffffc020b918 <commands+0x250>
ffffffffc0203e5a:	0d300593          	li	a1,211
ffffffffc0203e5e:	00009517          	auipc	a0,0x9
ffffffffc0203e62:	bf250513          	addi	a0,a0,-1038 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203e66:	bc8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e6a:	00009697          	auipc	a3,0x9
ffffffffc0203e6e:	c3e68693          	addi	a3,a3,-962 # ffffffffc020caa8 <commands+0x13e0>
ffffffffc0203e72:	00008617          	auipc	a2,0x8
ffffffffc0203e76:	aa660613          	addi	a2,a2,-1370 # ffffffffc020b918 <commands+0x250>
ffffffffc0203e7a:	0d200593          	li	a1,210
ffffffffc0203e7e:	00009517          	auipc	a0,0x9
ffffffffc0203e82:	bd250513          	addi	a0,a0,-1070 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203e86:	ba8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e8a:	00009697          	auipc	a3,0x9
ffffffffc0203e8e:	c3e68693          	addi	a3,a3,-962 # ffffffffc020cac8 <commands+0x1400>
ffffffffc0203e92:	00008617          	auipc	a2,0x8
ffffffffc0203e96:	a8660613          	addi	a2,a2,-1402 # ffffffffc020b918 <commands+0x250>
ffffffffc0203e9a:	0ba00593          	li	a1,186
ffffffffc0203e9e:	00009517          	auipc	a0,0x9
ffffffffc0203ea2:	bb250513          	addi	a0,a0,-1102 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203ea6:	b88fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203eaa:	00009697          	auipc	a3,0x9
ffffffffc0203eae:	ec668693          	addi	a3,a3,-314 # ffffffffc020cd70 <commands+0x16a8>
ffffffffc0203eb2:	00008617          	auipc	a2,0x8
ffffffffc0203eb6:	a6660613          	addi	a2,a2,-1434 # ffffffffc020b918 <commands+0x250>
ffffffffc0203eba:	12400593          	li	a1,292
ffffffffc0203ebe:	00009517          	auipc	a0,0x9
ffffffffc0203ec2:	b9250513          	addi	a0,a0,-1134 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203ec6:	b68fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203eca:	00009697          	auipc	a3,0x9
ffffffffc0203ece:	d4668693          	addi	a3,a3,-698 # ffffffffc020cc10 <commands+0x1548>
ffffffffc0203ed2:	00008617          	auipc	a2,0x8
ffffffffc0203ed6:	a4660613          	addi	a2,a2,-1466 # ffffffffc020b918 <commands+0x250>
ffffffffc0203eda:	11900593          	li	a1,281
ffffffffc0203ede:	00009517          	auipc	a0,0x9
ffffffffc0203ee2:	b7250513          	addi	a0,a0,-1166 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203ee6:	b48fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203eea:	00009697          	auipc	a3,0x9
ffffffffc0203eee:	cc668693          	addi	a3,a3,-826 # ffffffffc020cbb0 <commands+0x14e8>
ffffffffc0203ef2:	00008617          	auipc	a2,0x8
ffffffffc0203ef6:	a2660613          	addi	a2,a2,-1498 # ffffffffc020b918 <commands+0x250>
ffffffffc0203efa:	11700593          	li	a1,279
ffffffffc0203efe:	00009517          	auipc	a0,0x9
ffffffffc0203f02:	b5250513          	addi	a0,a0,-1198 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203f06:	b28fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f0a:	00009697          	auipc	a3,0x9
ffffffffc0203f0e:	c6668693          	addi	a3,a3,-922 # ffffffffc020cb70 <commands+0x14a8>
ffffffffc0203f12:	00008617          	auipc	a2,0x8
ffffffffc0203f16:	a0660613          	addi	a2,a2,-1530 # ffffffffc020b918 <commands+0x250>
ffffffffc0203f1a:	0c000593          	li	a1,192
ffffffffc0203f1e:	00009517          	auipc	a0,0x9
ffffffffc0203f22:	b3250513          	addi	a0,a0,-1230 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203f26:	b08fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f2a:	00009697          	auipc	a3,0x9
ffffffffc0203f2e:	e0668693          	addi	a3,a3,-506 # ffffffffc020cd30 <commands+0x1668>
ffffffffc0203f32:	00008617          	auipc	a2,0x8
ffffffffc0203f36:	9e660613          	addi	a2,a2,-1562 # ffffffffc020b918 <commands+0x250>
ffffffffc0203f3a:	11100593          	li	a1,273
ffffffffc0203f3e:	00009517          	auipc	a0,0x9
ffffffffc0203f42:	b1250513          	addi	a0,a0,-1262 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203f46:	ae8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f4a:	00009697          	auipc	a3,0x9
ffffffffc0203f4e:	dc668693          	addi	a3,a3,-570 # ffffffffc020cd10 <commands+0x1648>
ffffffffc0203f52:	00008617          	auipc	a2,0x8
ffffffffc0203f56:	9c660613          	addi	a2,a2,-1594 # ffffffffc020b918 <commands+0x250>
ffffffffc0203f5a:	10f00593          	li	a1,271
ffffffffc0203f5e:	00009517          	auipc	a0,0x9
ffffffffc0203f62:	af250513          	addi	a0,a0,-1294 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203f66:	ac8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f6a:	00009697          	auipc	a3,0x9
ffffffffc0203f6e:	d7e68693          	addi	a3,a3,-642 # ffffffffc020cce8 <commands+0x1620>
ffffffffc0203f72:	00008617          	auipc	a2,0x8
ffffffffc0203f76:	9a660613          	addi	a2,a2,-1626 # ffffffffc020b918 <commands+0x250>
ffffffffc0203f7a:	10d00593          	li	a1,269
ffffffffc0203f7e:	00009517          	auipc	a0,0x9
ffffffffc0203f82:	ad250513          	addi	a0,a0,-1326 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203f86:	aa8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f8a:	00009697          	auipc	a3,0x9
ffffffffc0203f8e:	d3668693          	addi	a3,a3,-714 # ffffffffc020ccc0 <commands+0x15f8>
ffffffffc0203f92:	00008617          	auipc	a2,0x8
ffffffffc0203f96:	98660613          	addi	a2,a2,-1658 # ffffffffc020b918 <commands+0x250>
ffffffffc0203f9a:	10c00593          	li	a1,268
ffffffffc0203f9e:	00009517          	auipc	a0,0x9
ffffffffc0203fa2:	ab250513          	addi	a0,a0,-1358 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203fa6:	a88fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203faa:	00009697          	auipc	a3,0x9
ffffffffc0203fae:	d0668693          	addi	a3,a3,-762 # ffffffffc020ccb0 <commands+0x15e8>
ffffffffc0203fb2:	00008617          	auipc	a2,0x8
ffffffffc0203fb6:	96660613          	addi	a2,a2,-1690 # ffffffffc020b918 <commands+0x250>
ffffffffc0203fba:	10700593          	li	a1,263
ffffffffc0203fbe:	00009517          	auipc	a0,0x9
ffffffffc0203fc2:	a9250513          	addi	a0,a0,-1390 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203fc6:	a68fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203fca:	00009697          	auipc	a3,0x9
ffffffffc0203fce:	be668693          	addi	a3,a3,-1050 # ffffffffc020cbb0 <commands+0x14e8>
ffffffffc0203fd2:	00008617          	auipc	a2,0x8
ffffffffc0203fd6:	94660613          	addi	a2,a2,-1722 # ffffffffc020b918 <commands+0x250>
ffffffffc0203fda:	10600593          	li	a1,262
ffffffffc0203fde:	00009517          	auipc	a0,0x9
ffffffffc0203fe2:	a7250513          	addi	a0,a0,-1422 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0203fe6:	a48fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203fea:	00009697          	auipc	a3,0x9
ffffffffc0203fee:	ca668693          	addi	a3,a3,-858 # ffffffffc020cc90 <commands+0x15c8>
ffffffffc0203ff2:	00008617          	auipc	a2,0x8
ffffffffc0203ff6:	92660613          	addi	a2,a2,-1754 # ffffffffc020b918 <commands+0x250>
ffffffffc0203ffa:	10500593          	li	a1,261
ffffffffc0203ffe:	00009517          	auipc	a0,0x9
ffffffffc0204002:	a5250513          	addi	a0,a0,-1454 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204006:	a28fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020400a:	00009697          	auipc	a3,0x9
ffffffffc020400e:	c5668693          	addi	a3,a3,-938 # ffffffffc020cc60 <commands+0x1598>
ffffffffc0204012:	00008617          	auipc	a2,0x8
ffffffffc0204016:	90660613          	addi	a2,a2,-1786 # ffffffffc020b918 <commands+0x250>
ffffffffc020401a:	10400593          	li	a1,260
ffffffffc020401e:	00009517          	auipc	a0,0x9
ffffffffc0204022:	a3250513          	addi	a0,a0,-1486 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204026:	a08fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020402a:	00009697          	auipc	a3,0x9
ffffffffc020402e:	c1e68693          	addi	a3,a3,-994 # ffffffffc020cc48 <commands+0x1580>
ffffffffc0204032:	00008617          	auipc	a2,0x8
ffffffffc0204036:	8e660613          	addi	a2,a2,-1818 # ffffffffc020b918 <commands+0x250>
ffffffffc020403a:	10300593          	li	a1,259
ffffffffc020403e:	00009517          	auipc	a0,0x9
ffffffffc0204042:	a1250513          	addi	a0,a0,-1518 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204046:	9e8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020404a:	00009697          	auipc	a3,0x9
ffffffffc020404e:	b6668693          	addi	a3,a3,-1178 # ffffffffc020cbb0 <commands+0x14e8>
ffffffffc0204052:	00008617          	auipc	a2,0x8
ffffffffc0204056:	8c660613          	addi	a2,a2,-1850 # ffffffffc020b918 <commands+0x250>
ffffffffc020405a:	0fd00593          	li	a1,253
ffffffffc020405e:	00009517          	auipc	a0,0x9
ffffffffc0204062:	9f250513          	addi	a0,a0,-1550 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204066:	9c8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020406a:	00009697          	auipc	a3,0x9
ffffffffc020406e:	bc668693          	addi	a3,a3,-1082 # ffffffffc020cc30 <commands+0x1568>
ffffffffc0204072:	00008617          	auipc	a2,0x8
ffffffffc0204076:	8a660613          	addi	a2,a2,-1882 # ffffffffc020b918 <commands+0x250>
ffffffffc020407a:	0f800593          	li	a1,248
ffffffffc020407e:	00009517          	auipc	a0,0x9
ffffffffc0204082:	9d250513          	addi	a0,a0,-1582 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204086:	9a8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020408a:	00009697          	auipc	a3,0x9
ffffffffc020408e:	cc668693          	addi	a3,a3,-826 # ffffffffc020cd50 <commands+0x1688>
ffffffffc0204092:	00008617          	auipc	a2,0x8
ffffffffc0204096:	88660613          	addi	a2,a2,-1914 # ffffffffc020b918 <commands+0x250>
ffffffffc020409a:	11600593          	li	a1,278
ffffffffc020409e:	00009517          	auipc	a0,0x9
ffffffffc02040a2:	9b250513          	addi	a0,a0,-1614 # ffffffffc020ca50 <commands+0x1388>
ffffffffc02040a6:	988fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040aa:	00009697          	auipc	a3,0x9
ffffffffc02040ae:	cd668693          	addi	a3,a3,-810 # ffffffffc020cd80 <commands+0x16b8>
ffffffffc02040b2:	00008617          	auipc	a2,0x8
ffffffffc02040b6:	86660613          	addi	a2,a2,-1946 # ffffffffc020b918 <commands+0x250>
ffffffffc02040ba:	12500593          	li	a1,293
ffffffffc02040be:	00009517          	auipc	a0,0x9
ffffffffc02040c2:	99250513          	addi	a0,a0,-1646 # ffffffffc020ca50 <commands+0x1388>
ffffffffc02040c6:	968fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040ca:	00009697          	auipc	a3,0x9
ffffffffc02040ce:	99e68693          	addi	a3,a3,-1634 # ffffffffc020ca68 <commands+0x13a0>
ffffffffc02040d2:	00008617          	auipc	a2,0x8
ffffffffc02040d6:	84660613          	addi	a2,a2,-1978 # ffffffffc020b918 <commands+0x250>
ffffffffc02040da:	0f200593          	li	a1,242
ffffffffc02040de:	00009517          	auipc	a0,0x9
ffffffffc02040e2:	97250513          	addi	a0,a0,-1678 # ffffffffc020ca50 <commands+0x1388>
ffffffffc02040e6:	948fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040ea:	00009697          	auipc	a3,0x9
ffffffffc02040ee:	9be68693          	addi	a3,a3,-1602 # ffffffffc020caa8 <commands+0x13e0>
ffffffffc02040f2:	00008617          	auipc	a2,0x8
ffffffffc02040f6:	82660613          	addi	a2,a2,-2010 # ffffffffc020b918 <commands+0x250>
ffffffffc02040fa:	0b900593          	li	a1,185
ffffffffc02040fe:	00009517          	auipc	a0,0x9
ffffffffc0204102:	95250513          	addi	a0,a0,-1710 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204106:	928fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020410a <default_free_pages>:
ffffffffc020410a:	1141                	addi	sp,sp,-16
ffffffffc020410c:	e406                	sd	ra,8(sp)
ffffffffc020410e:	14058463          	beqz	a1,ffffffffc0204256 <default_free_pages+0x14c>
ffffffffc0204112:	00659693          	slli	a3,a1,0x6
ffffffffc0204116:	96aa                	add	a3,a3,a0
ffffffffc0204118:	87aa                	mv	a5,a0
ffffffffc020411a:	02d50263          	beq	a0,a3,ffffffffc020413e <default_free_pages+0x34>
ffffffffc020411e:	6798                	ld	a4,8(a5)
ffffffffc0204120:	8b05                	andi	a4,a4,1
ffffffffc0204122:	10071a63          	bnez	a4,ffffffffc0204236 <default_free_pages+0x12c>
ffffffffc0204126:	6798                	ld	a4,8(a5)
ffffffffc0204128:	8b09                	andi	a4,a4,2
ffffffffc020412a:	10071663          	bnez	a4,ffffffffc0204236 <default_free_pages+0x12c>
ffffffffc020412e:	0007b423          	sd	zero,8(a5)
ffffffffc0204132:	0007a023          	sw	zero,0(a5)
ffffffffc0204136:	04078793          	addi	a5,a5,64
ffffffffc020413a:	fed792e3          	bne	a5,a3,ffffffffc020411e <default_free_pages+0x14>
ffffffffc020413e:	2581                	sext.w	a1,a1
ffffffffc0204140:	c90c                	sw	a1,16(a0)
ffffffffc0204142:	00850893          	addi	a7,a0,8
ffffffffc0204146:	4789                	li	a5,2
ffffffffc0204148:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc020414c:	0008d697          	auipc	a3,0x8d
ffffffffc0204150:	65c68693          	addi	a3,a3,1628 # ffffffffc02917a8 <free_area>
ffffffffc0204154:	4a98                	lw	a4,16(a3)
ffffffffc0204156:	669c                	ld	a5,8(a3)
ffffffffc0204158:	01850613          	addi	a2,a0,24
ffffffffc020415c:	9db9                	addw	a1,a1,a4
ffffffffc020415e:	ca8c                	sw	a1,16(a3)
ffffffffc0204160:	0ad78463          	beq	a5,a3,ffffffffc0204208 <default_free_pages+0xfe>
ffffffffc0204164:	fe878713          	addi	a4,a5,-24
ffffffffc0204168:	0006b803          	ld	a6,0(a3)
ffffffffc020416c:	4581                	li	a1,0
ffffffffc020416e:	00e56a63          	bltu	a0,a4,ffffffffc0204182 <default_free_pages+0x78>
ffffffffc0204172:	6798                	ld	a4,8(a5)
ffffffffc0204174:	04d70c63          	beq	a4,a3,ffffffffc02041cc <default_free_pages+0xc2>
ffffffffc0204178:	87ba                	mv	a5,a4
ffffffffc020417a:	fe878713          	addi	a4,a5,-24
ffffffffc020417e:	fee57ae3          	bgeu	a0,a4,ffffffffc0204172 <default_free_pages+0x68>
ffffffffc0204182:	c199                	beqz	a1,ffffffffc0204188 <default_free_pages+0x7e>
ffffffffc0204184:	0106b023          	sd	a6,0(a3)
ffffffffc0204188:	6398                	ld	a4,0(a5)
ffffffffc020418a:	e390                	sd	a2,0(a5)
ffffffffc020418c:	e710                	sd	a2,8(a4)
ffffffffc020418e:	f11c                	sd	a5,32(a0)
ffffffffc0204190:	ed18                	sd	a4,24(a0)
ffffffffc0204192:	00d70d63          	beq	a4,a3,ffffffffc02041ac <default_free_pages+0xa2>
ffffffffc0204196:	ff872583          	lw	a1,-8(a4) # ff8 <_binary_bin_swap_img_size-0x6d08>
ffffffffc020419a:	fe870613          	addi	a2,a4,-24
ffffffffc020419e:	02059813          	slli	a6,a1,0x20
ffffffffc02041a2:	01a85793          	srli	a5,a6,0x1a
ffffffffc02041a6:	97b2                	add	a5,a5,a2
ffffffffc02041a8:	02f50c63          	beq	a0,a5,ffffffffc02041e0 <default_free_pages+0xd6>
ffffffffc02041ac:	711c                	ld	a5,32(a0)
ffffffffc02041ae:	00d78c63          	beq	a5,a3,ffffffffc02041c6 <default_free_pages+0xbc>
ffffffffc02041b2:	4910                	lw	a2,16(a0)
ffffffffc02041b4:	fe878693          	addi	a3,a5,-24
ffffffffc02041b8:	02061593          	slli	a1,a2,0x20
ffffffffc02041bc:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02041c0:	972a                	add	a4,a4,a0
ffffffffc02041c2:	04e68a63          	beq	a3,a4,ffffffffc0204216 <default_free_pages+0x10c>
ffffffffc02041c6:	60a2                	ld	ra,8(sp)
ffffffffc02041c8:	0141                	addi	sp,sp,16
ffffffffc02041ca:	8082                	ret
ffffffffc02041cc:	e790                	sd	a2,8(a5)
ffffffffc02041ce:	f114                	sd	a3,32(a0)
ffffffffc02041d0:	6798                	ld	a4,8(a5)
ffffffffc02041d2:	ed1c                	sd	a5,24(a0)
ffffffffc02041d4:	02d70763          	beq	a4,a3,ffffffffc0204202 <default_free_pages+0xf8>
ffffffffc02041d8:	8832                	mv	a6,a2
ffffffffc02041da:	4585                	li	a1,1
ffffffffc02041dc:	87ba                	mv	a5,a4
ffffffffc02041de:	bf71                	j	ffffffffc020417a <default_free_pages+0x70>
ffffffffc02041e0:	491c                	lw	a5,16(a0)
ffffffffc02041e2:	9dbd                	addw	a1,a1,a5
ffffffffc02041e4:	feb72c23          	sw	a1,-8(a4)
ffffffffc02041e8:	57f5                	li	a5,-3
ffffffffc02041ea:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc02041ee:	01853803          	ld	a6,24(a0)
ffffffffc02041f2:	710c                	ld	a1,32(a0)
ffffffffc02041f4:	8532                	mv	a0,a2
ffffffffc02041f6:	00b83423          	sd	a1,8(a6)
ffffffffc02041fa:	671c                	ld	a5,8(a4)
ffffffffc02041fc:	0105b023          	sd	a6,0(a1) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204200:	b77d                	j	ffffffffc02041ae <default_free_pages+0xa4>
ffffffffc0204202:	e290                	sd	a2,0(a3)
ffffffffc0204204:	873e                	mv	a4,a5
ffffffffc0204206:	bf41                	j	ffffffffc0204196 <default_free_pages+0x8c>
ffffffffc0204208:	60a2                	ld	ra,8(sp)
ffffffffc020420a:	e390                	sd	a2,0(a5)
ffffffffc020420c:	e790                	sd	a2,8(a5)
ffffffffc020420e:	f11c                	sd	a5,32(a0)
ffffffffc0204210:	ed1c                	sd	a5,24(a0)
ffffffffc0204212:	0141                	addi	sp,sp,16
ffffffffc0204214:	8082                	ret
ffffffffc0204216:	ff87a703          	lw	a4,-8(a5)
ffffffffc020421a:	ff078693          	addi	a3,a5,-16
ffffffffc020421e:	9e39                	addw	a2,a2,a4
ffffffffc0204220:	c910                	sw	a2,16(a0)
ffffffffc0204222:	5775                	li	a4,-3
ffffffffc0204224:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc0204228:	6398                	ld	a4,0(a5)
ffffffffc020422a:	679c                	ld	a5,8(a5)
ffffffffc020422c:	60a2                	ld	ra,8(sp)
ffffffffc020422e:	e71c                	sd	a5,8(a4)
ffffffffc0204230:	e398                	sd	a4,0(a5)
ffffffffc0204232:	0141                	addi	sp,sp,16
ffffffffc0204234:	8082                	ret
ffffffffc0204236:	00009697          	auipc	a3,0x9
ffffffffc020423a:	b6268693          	addi	a3,a3,-1182 # ffffffffc020cd98 <commands+0x16d0>
ffffffffc020423e:	00007617          	auipc	a2,0x7
ffffffffc0204242:	6da60613          	addi	a2,a2,1754 # ffffffffc020b918 <commands+0x250>
ffffffffc0204246:	08200593          	li	a1,130
ffffffffc020424a:	00009517          	auipc	a0,0x9
ffffffffc020424e:	80650513          	addi	a0,a0,-2042 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204252:	fddfb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204256:	00009697          	auipc	a3,0x9
ffffffffc020425a:	b3a68693          	addi	a3,a3,-1222 # ffffffffc020cd90 <commands+0x16c8>
ffffffffc020425e:	00007617          	auipc	a2,0x7
ffffffffc0204262:	6ba60613          	addi	a2,a2,1722 # ffffffffc020b918 <commands+0x250>
ffffffffc0204266:	07f00593          	li	a1,127
ffffffffc020426a:	00008517          	auipc	a0,0x8
ffffffffc020426e:	7e650513          	addi	a0,a0,2022 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204272:	fbdfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204276 <default_alloc_pages>:
ffffffffc0204276:	c941                	beqz	a0,ffffffffc0204306 <default_alloc_pages+0x90>
ffffffffc0204278:	0008d597          	auipc	a1,0x8d
ffffffffc020427c:	53058593          	addi	a1,a1,1328 # ffffffffc02917a8 <free_area>
ffffffffc0204280:	0105a803          	lw	a6,16(a1)
ffffffffc0204284:	872a                	mv	a4,a0
ffffffffc0204286:	02081793          	slli	a5,a6,0x20
ffffffffc020428a:	9381                	srli	a5,a5,0x20
ffffffffc020428c:	00a7ee63          	bltu	a5,a0,ffffffffc02042a8 <default_alloc_pages+0x32>
ffffffffc0204290:	87ae                	mv	a5,a1
ffffffffc0204292:	a801                	j	ffffffffc02042a2 <default_alloc_pages+0x2c>
ffffffffc0204294:	ff87a683          	lw	a3,-8(a5)
ffffffffc0204298:	02069613          	slli	a2,a3,0x20
ffffffffc020429c:	9201                	srli	a2,a2,0x20
ffffffffc020429e:	00e67763          	bgeu	a2,a4,ffffffffc02042ac <default_alloc_pages+0x36>
ffffffffc02042a2:	679c                	ld	a5,8(a5)
ffffffffc02042a4:	feb798e3          	bne	a5,a1,ffffffffc0204294 <default_alloc_pages+0x1e>
ffffffffc02042a8:	4501                	li	a0,0
ffffffffc02042aa:	8082                	ret
ffffffffc02042ac:	0007b883          	ld	a7,0(a5)
ffffffffc02042b0:	0087b303          	ld	t1,8(a5)
ffffffffc02042b4:	fe878513          	addi	a0,a5,-24
ffffffffc02042b8:	00070e1b          	sext.w	t3,a4
ffffffffc02042bc:	0068b423          	sd	t1,8(a7) # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc02042c0:	01133023          	sd	a7,0(t1) # 80000 <_binary_bin_sfs_img_size+0xad00>
ffffffffc02042c4:	02c77863          	bgeu	a4,a2,ffffffffc02042f4 <default_alloc_pages+0x7e>
ffffffffc02042c8:	071a                	slli	a4,a4,0x6
ffffffffc02042ca:	972a                	add	a4,a4,a0
ffffffffc02042cc:	41c686bb          	subw	a3,a3,t3
ffffffffc02042d0:	cb14                	sw	a3,16(a4)
ffffffffc02042d2:	00870613          	addi	a2,a4,8
ffffffffc02042d6:	4689                	li	a3,2
ffffffffc02042d8:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc02042dc:	0088b683          	ld	a3,8(a7)
ffffffffc02042e0:	01870613          	addi	a2,a4,24
ffffffffc02042e4:	0105a803          	lw	a6,16(a1)
ffffffffc02042e8:	e290                	sd	a2,0(a3)
ffffffffc02042ea:	00c8b423          	sd	a2,8(a7)
ffffffffc02042ee:	f314                	sd	a3,32(a4)
ffffffffc02042f0:	01173c23          	sd	a7,24(a4)
ffffffffc02042f4:	41c8083b          	subw	a6,a6,t3
ffffffffc02042f8:	0105a823          	sw	a6,16(a1)
ffffffffc02042fc:	5775                	li	a4,-3
ffffffffc02042fe:	17c1                	addi	a5,a5,-16
ffffffffc0204300:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0204304:	8082                	ret
ffffffffc0204306:	1141                	addi	sp,sp,-16
ffffffffc0204308:	00009697          	auipc	a3,0x9
ffffffffc020430c:	a8868693          	addi	a3,a3,-1400 # ffffffffc020cd90 <commands+0x16c8>
ffffffffc0204310:	00007617          	auipc	a2,0x7
ffffffffc0204314:	60860613          	addi	a2,a2,1544 # ffffffffc020b918 <commands+0x250>
ffffffffc0204318:	06100593          	li	a1,97
ffffffffc020431c:	00008517          	auipc	a0,0x8
ffffffffc0204320:	73450513          	addi	a0,a0,1844 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204324:	e406                	sd	ra,8(sp)
ffffffffc0204326:	f09fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020432a <default_init_memmap>:
ffffffffc020432a:	1141                	addi	sp,sp,-16
ffffffffc020432c:	e406                	sd	ra,8(sp)
ffffffffc020432e:	c5f1                	beqz	a1,ffffffffc02043fa <default_init_memmap+0xd0>
ffffffffc0204330:	00659693          	slli	a3,a1,0x6
ffffffffc0204334:	96aa                	add	a3,a3,a0
ffffffffc0204336:	87aa                	mv	a5,a0
ffffffffc0204338:	00d50f63          	beq	a0,a3,ffffffffc0204356 <default_init_memmap+0x2c>
ffffffffc020433c:	6798                	ld	a4,8(a5)
ffffffffc020433e:	8b05                	andi	a4,a4,1
ffffffffc0204340:	cf49                	beqz	a4,ffffffffc02043da <default_init_memmap+0xb0>
ffffffffc0204342:	0007a823          	sw	zero,16(a5)
ffffffffc0204346:	0007b423          	sd	zero,8(a5)
ffffffffc020434a:	0007a023          	sw	zero,0(a5)
ffffffffc020434e:	04078793          	addi	a5,a5,64
ffffffffc0204352:	fed795e3          	bne	a5,a3,ffffffffc020433c <default_init_memmap+0x12>
ffffffffc0204356:	2581                	sext.w	a1,a1
ffffffffc0204358:	c90c                	sw	a1,16(a0)
ffffffffc020435a:	4789                	li	a5,2
ffffffffc020435c:	00850713          	addi	a4,a0,8
ffffffffc0204360:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0204364:	0008d697          	auipc	a3,0x8d
ffffffffc0204368:	44468693          	addi	a3,a3,1092 # ffffffffc02917a8 <free_area>
ffffffffc020436c:	4a98                	lw	a4,16(a3)
ffffffffc020436e:	669c                	ld	a5,8(a3)
ffffffffc0204370:	01850613          	addi	a2,a0,24
ffffffffc0204374:	9db9                	addw	a1,a1,a4
ffffffffc0204376:	ca8c                	sw	a1,16(a3)
ffffffffc0204378:	04d78a63          	beq	a5,a3,ffffffffc02043cc <default_init_memmap+0xa2>
ffffffffc020437c:	fe878713          	addi	a4,a5,-24
ffffffffc0204380:	0006b803          	ld	a6,0(a3)
ffffffffc0204384:	4581                	li	a1,0
ffffffffc0204386:	00e56a63          	bltu	a0,a4,ffffffffc020439a <default_init_memmap+0x70>
ffffffffc020438a:	6798                	ld	a4,8(a5)
ffffffffc020438c:	02d70263          	beq	a4,a3,ffffffffc02043b0 <default_init_memmap+0x86>
ffffffffc0204390:	87ba                	mv	a5,a4
ffffffffc0204392:	fe878713          	addi	a4,a5,-24
ffffffffc0204396:	fee57ae3          	bgeu	a0,a4,ffffffffc020438a <default_init_memmap+0x60>
ffffffffc020439a:	c199                	beqz	a1,ffffffffc02043a0 <default_init_memmap+0x76>
ffffffffc020439c:	0106b023          	sd	a6,0(a3)
ffffffffc02043a0:	6398                	ld	a4,0(a5)
ffffffffc02043a2:	60a2                	ld	ra,8(sp)
ffffffffc02043a4:	e390                	sd	a2,0(a5)
ffffffffc02043a6:	e710                	sd	a2,8(a4)
ffffffffc02043a8:	f11c                	sd	a5,32(a0)
ffffffffc02043aa:	ed18                	sd	a4,24(a0)
ffffffffc02043ac:	0141                	addi	sp,sp,16
ffffffffc02043ae:	8082                	ret
ffffffffc02043b0:	e790                	sd	a2,8(a5)
ffffffffc02043b2:	f114                	sd	a3,32(a0)
ffffffffc02043b4:	6798                	ld	a4,8(a5)
ffffffffc02043b6:	ed1c                	sd	a5,24(a0)
ffffffffc02043b8:	00d70663          	beq	a4,a3,ffffffffc02043c4 <default_init_memmap+0x9a>
ffffffffc02043bc:	8832                	mv	a6,a2
ffffffffc02043be:	4585                	li	a1,1
ffffffffc02043c0:	87ba                	mv	a5,a4
ffffffffc02043c2:	bfc1                	j	ffffffffc0204392 <default_init_memmap+0x68>
ffffffffc02043c4:	60a2                	ld	ra,8(sp)
ffffffffc02043c6:	e290                	sd	a2,0(a3)
ffffffffc02043c8:	0141                	addi	sp,sp,16
ffffffffc02043ca:	8082                	ret
ffffffffc02043cc:	60a2                	ld	ra,8(sp)
ffffffffc02043ce:	e390                	sd	a2,0(a5)
ffffffffc02043d0:	e790                	sd	a2,8(a5)
ffffffffc02043d2:	f11c                	sd	a5,32(a0)
ffffffffc02043d4:	ed1c                	sd	a5,24(a0)
ffffffffc02043d6:	0141                	addi	sp,sp,16
ffffffffc02043d8:	8082                	ret
ffffffffc02043da:	00009697          	auipc	a3,0x9
ffffffffc02043de:	9e668693          	addi	a3,a3,-1562 # ffffffffc020cdc0 <commands+0x16f8>
ffffffffc02043e2:	00007617          	auipc	a2,0x7
ffffffffc02043e6:	53660613          	addi	a2,a2,1334 # ffffffffc020b918 <commands+0x250>
ffffffffc02043ea:	04800593          	li	a1,72
ffffffffc02043ee:	00008517          	auipc	a0,0x8
ffffffffc02043f2:	66250513          	addi	a0,a0,1634 # ffffffffc020ca50 <commands+0x1388>
ffffffffc02043f6:	e39fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02043fa:	00009697          	auipc	a3,0x9
ffffffffc02043fe:	99668693          	addi	a3,a3,-1642 # ffffffffc020cd90 <commands+0x16c8>
ffffffffc0204402:	00007617          	auipc	a2,0x7
ffffffffc0204406:	51660613          	addi	a2,a2,1302 # ffffffffc020b918 <commands+0x250>
ffffffffc020440a:	04500593          	li	a1,69
ffffffffc020440e:	00008517          	auipc	a0,0x8
ffffffffc0204412:	64250513          	addi	a0,a0,1602 # ffffffffc020ca50 <commands+0x1388>
ffffffffc0204416:	e19fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020441a <wait_queue_init>:
ffffffffc020441a:	e508                	sd	a0,8(a0)
ffffffffc020441c:	e108                	sd	a0,0(a0)
ffffffffc020441e:	8082                	ret

ffffffffc0204420 <wait_queue_del>:
ffffffffc0204420:	7198                	ld	a4,32(a1)
ffffffffc0204422:	01858793          	addi	a5,a1,24
ffffffffc0204426:	00e78b63          	beq	a5,a4,ffffffffc020443c <wait_queue_del+0x1c>
ffffffffc020442a:	6994                	ld	a3,16(a1)
ffffffffc020442c:	00a69863          	bne	a3,a0,ffffffffc020443c <wait_queue_del+0x1c>
ffffffffc0204430:	6d94                	ld	a3,24(a1)
ffffffffc0204432:	e698                	sd	a4,8(a3)
ffffffffc0204434:	e314                	sd	a3,0(a4)
ffffffffc0204436:	f19c                	sd	a5,32(a1)
ffffffffc0204438:	ed9c                	sd	a5,24(a1)
ffffffffc020443a:	8082                	ret
ffffffffc020443c:	1141                	addi	sp,sp,-16
ffffffffc020443e:	00009697          	auipc	a3,0x9
ffffffffc0204442:	a3268693          	addi	a3,a3,-1486 # ffffffffc020ce70 <default_pmm_manager+0x88>
ffffffffc0204446:	00007617          	auipc	a2,0x7
ffffffffc020444a:	4d260613          	addi	a2,a2,1234 # ffffffffc020b918 <commands+0x250>
ffffffffc020444e:	45f1                	li	a1,28
ffffffffc0204450:	00009517          	auipc	a0,0x9
ffffffffc0204454:	a0850513          	addi	a0,a0,-1528 # ffffffffc020ce58 <default_pmm_manager+0x70>
ffffffffc0204458:	e406                	sd	ra,8(sp)
ffffffffc020445a:	dd5fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020445e <wait_queue_first>:
ffffffffc020445e:	651c                	ld	a5,8(a0)
ffffffffc0204460:	00f50563          	beq	a0,a5,ffffffffc020446a <wait_queue_first+0xc>
ffffffffc0204464:	fe878513          	addi	a0,a5,-24
ffffffffc0204468:	8082                	ret
ffffffffc020446a:	4501                	li	a0,0
ffffffffc020446c:	8082                	ret

ffffffffc020446e <wait_queue_empty>:
ffffffffc020446e:	651c                	ld	a5,8(a0)
ffffffffc0204470:	40a78533          	sub	a0,a5,a0
ffffffffc0204474:	00153513          	seqz	a0,a0
ffffffffc0204478:	8082                	ret

ffffffffc020447a <wait_in_queue>:
ffffffffc020447a:	711c                	ld	a5,32(a0)
ffffffffc020447c:	0561                	addi	a0,a0,24
ffffffffc020447e:	40a78533          	sub	a0,a5,a0
ffffffffc0204482:	00a03533          	snez	a0,a0
ffffffffc0204486:	8082                	ret

ffffffffc0204488 <wakeup_wait>:
ffffffffc0204488:	e689                	bnez	a3,ffffffffc0204492 <wakeup_wait+0xa>
ffffffffc020448a:	6188                	ld	a0,0(a1)
ffffffffc020448c:	c590                	sw	a2,8(a1)
ffffffffc020448e:	4090206f          	j	ffffffffc0207096 <wakeup_proc>
ffffffffc0204492:	7198                	ld	a4,32(a1)
ffffffffc0204494:	01858793          	addi	a5,a1,24
ffffffffc0204498:	00e78e63          	beq	a5,a4,ffffffffc02044b4 <wakeup_wait+0x2c>
ffffffffc020449c:	6994                	ld	a3,16(a1)
ffffffffc020449e:	00d51b63          	bne	a0,a3,ffffffffc02044b4 <wakeup_wait+0x2c>
ffffffffc02044a2:	6d94                	ld	a3,24(a1)
ffffffffc02044a4:	6188                	ld	a0,0(a1)
ffffffffc02044a6:	e698                	sd	a4,8(a3)
ffffffffc02044a8:	e314                	sd	a3,0(a4)
ffffffffc02044aa:	f19c                	sd	a5,32(a1)
ffffffffc02044ac:	ed9c                	sd	a5,24(a1)
ffffffffc02044ae:	c590                	sw	a2,8(a1)
ffffffffc02044b0:	3e70206f          	j	ffffffffc0207096 <wakeup_proc>
ffffffffc02044b4:	1141                	addi	sp,sp,-16
ffffffffc02044b6:	00009697          	auipc	a3,0x9
ffffffffc02044ba:	9ba68693          	addi	a3,a3,-1606 # ffffffffc020ce70 <default_pmm_manager+0x88>
ffffffffc02044be:	00007617          	auipc	a2,0x7
ffffffffc02044c2:	45a60613          	addi	a2,a2,1114 # ffffffffc020b918 <commands+0x250>
ffffffffc02044c6:	45f1                	li	a1,28
ffffffffc02044c8:	00009517          	auipc	a0,0x9
ffffffffc02044cc:	99050513          	addi	a0,a0,-1648 # ffffffffc020ce58 <default_pmm_manager+0x70>
ffffffffc02044d0:	e406                	sd	ra,8(sp)
ffffffffc02044d2:	d5dfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02044d6 <wakeup_queue>:
ffffffffc02044d6:	651c                	ld	a5,8(a0)
ffffffffc02044d8:	0ca78563          	beq	a5,a0,ffffffffc02045a2 <wakeup_queue+0xcc>
ffffffffc02044dc:	1101                	addi	sp,sp,-32
ffffffffc02044de:	e822                	sd	s0,16(sp)
ffffffffc02044e0:	e426                	sd	s1,8(sp)
ffffffffc02044e2:	e04a                	sd	s2,0(sp)
ffffffffc02044e4:	ec06                	sd	ra,24(sp)
ffffffffc02044e6:	84aa                	mv	s1,a0
ffffffffc02044e8:	892e                	mv	s2,a1
ffffffffc02044ea:	fe878413          	addi	s0,a5,-24
ffffffffc02044ee:	e23d                	bnez	a2,ffffffffc0204554 <wakeup_queue+0x7e>
ffffffffc02044f0:	6008                	ld	a0,0(s0)
ffffffffc02044f2:	01242423          	sw	s2,8(s0)
ffffffffc02044f6:	3a1020ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc02044fa:	701c                	ld	a5,32(s0)
ffffffffc02044fc:	01840713          	addi	a4,s0,24
ffffffffc0204500:	02e78463          	beq	a5,a4,ffffffffc0204528 <wakeup_queue+0x52>
ffffffffc0204504:	6818                	ld	a4,16(s0)
ffffffffc0204506:	02e49163          	bne	s1,a4,ffffffffc0204528 <wakeup_queue+0x52>
ffffffffc020450a:	02f48f63          	beq	s1,a5,ffffffffc0204548 <wakeup_queue+0x72>
ffffffffc020450e:	fe87b503          	ld	a0,-24(a5)
ffffffffc0204512:	ff27a823          	sw	s2,-16(a5)
ffffffffc0204516:	fe878413          	addi	s0,a5,-24
ffffffffc020451a:	37d020ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc020451e:	701c                	ld	a5,32(s0)
ffffffffc0204520:	01840713          	addi	a4,s0,24
ffffffffc0204524:	fee790e3          	bne	a5,a4,ffffffffc0204504 <wakeup_queue+0x2e>
ffffffffc0204528:	00009697          	auipc	a3,0x9
ffffffffc020452c:	94868693          	addi	a3,a3,-1720 # ffffffffc020ce70 <default_pmm_manager+0x88>
ffffffffc0204530:	00007617          	auipc	a2,0x7
ffffffffc0204534:	3e860613          	addi	a2,a2,1000 # ffffffffc020b918 <commands+0x250>
ffffffffc0204538:	02200593          	li	a1,34
ffffffffc020453c:	00009517          	auipc	a0,0x9
ffffffffc0204540:	91c50513          	addi	a0,a0,-1764 # ffffffffc020ce58 <default_pmm_manager+0x70>
ffffffffc0204544:	cebfb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204548:	60e2                	ld	ra,24(sp)
ffffffffc020454a:	6442                	ld	s0,16(sp)
ffffffffc020454c:	64a2                	ld	s1,8(sp)
ffffffffc020454e:	6902                	ld	s2,0(sp)
ffffffffc0204550:	6105                	addi	sp,sp,32
ffffffffc0204552:	8082                	ret
ffffffffc0204554:	6798                	ld	a4,8(a5)
ffffffffc0204556:	02f70763          	beq	a4,a5,ffffffffc0204584 <wakeup_queue+0xae>
ffffffffc020455a:	6814                	ld	a3,16(s0)
ffffffffc020455c:	02d49463          	bne	s1,a3,ffffffffc0204584 <wakeup_queue+0xae>
ffffffffc0204560:	6c14                	ld	a3,24(s0)
ffffffffc0204562:	6008                	ld	a0,0(s0)
ffffffffc0204564:	e698                	sd	a4,8(a3)
ffffffffc0204566:	e314                	sd	a3,0(a4)
ffffffffc0204568:	f01c                	sd	a5,32(s0)
ffffffffc020456a:	ec1c                	sd	a5,24(s0)
ffffffffc020456c:	01242423          	sw	s2,8(s0)
ffffffffc0204570:	327020ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc0204574:	6480                	ld	s0,8(s1)
ffffffffc0204576:	fc8489e3          	beq	s1,s0,ffffffffc0204548 <wakeup_queue+0x72>
ffffffffc020457a:	6418                	ld	a4,8(s0)
ffffffffc020457c:	87a2                	mv	a5,s0
ffffffffc020457e:	1421                	addi	s0,s0,-24
ffffffffc0204580:	fce79de3          	bne	a5,a4,ffffffffc020455a <wakeup_queue+0x84>
ffffffffc0204584:	00009697          	auipc	a3,0x9
ffffffffc0204588:	8ec68693          	addi	a3,a3,-1812 # ffffffffc020ce70 <default_pmm_manager+0x88>
ffffffffc020458c:	00007617          	auipc	a2,0x7
ffffffffc0204590:	38c60613          	addi	a2,a2,908 # ffffffffc020b918 <commands+0x250>
ffffffffc0204594:	45f1                	li	a1,28
ffffffffc0204596:	00009517          	auipc	a0,0x9
ffffffffc020459a:	8c250513          	addi	a0,a0,-1854 # ffffffffc020ce58 <default_pmm_manager+0x70>
ffffffffc020459e:	c91fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02045a2:	8082                	ret

ffffffffc02045a4 <wait_current_set>:
ffffffffc02045a4:	00092797          	auipc	a5,0x92
ffffffffc02045a8:	31c7b783          	ld	a5,796(a5) # ffffffffc02968c0 <current>
ffffffffc02045ac:	c39d                	beqz	a5,ffffffffc02045d2 <wait_current_set+0x2e>
ffffffffc02045ae:	01858713          	addi	a4,a1,24
ffffffffc02045b2:	800006b7          	lui	a3,0x80000
ffffffffc02045b6:	ed98                	sd	a4,24(a1)
ffffffffc02045b8:	e19c                	sd	a5,0(a1)
ffffffffc02045ba:	c594                	sw	a3,8(a1)
ffffffffc02045bc:	4685                	li	a3,1
ffffffffc02045be:	c394                	sw	a3,0(a5)
ffffffffc02045c0:	0ec7a623          	sw	a2,236(a5)
ffffffffc02045c4:	611c                	ld	a5,0(a0)
ffffffffc02045c6:	e988                	sd	a0,16(a1)
ffffffffc02045c8:	e118                	sd	a4,0(a0)
ffffffffc02045ca:	e798                	sd	a4,8(a5)
ffffffffc02045cc:	f188                	sd	a0,32(a1)
ffffffffc02045ce:	ed9c                	sd	a5,24(a1)
ffffffffc02045d0:	8082                	ret
ffffffffc02045d2:	1141                	addi	sp,sp,-16
ffffffffc02045d4:	00009697          	auipc	a3,0x9
ffffffffc02045d8:	8dc68693          	addi	a3,a3,-1828 # ffffffffc020ceb0 <default_pmm_manager+0xc8>
ffffffffc02045dc:	00007617          	auipc	a2,0x7
ffffffffc02045e0:	33c60613          	addi	a2,a2,828 # ffffffffc020b918 <commands+0x250>
ffffffffc02045e4:	07400593          	li	a1,116
ffffffffc02045e8:	00009517          	auipc	a0,0x9
ffffffffc02045ec:	87050513          	addi	a0,a0,-1936 # ffffffffc020ce58 <default_pmm_manager+0x70>
ffffffffc02045f0:	e406                	sd	ra,8(sp)
ffffffffc02045f2:	c3dfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02045f6 <__down.constprop.0>:
ffffffffc02045f6:	715d                	addi	sp,sp,-80
ffffffffc02045f8:	e0a2                	sd	s0,64(sp)
ffffffffc02045fa:	e486                	sd	ra,72(sp)
ffffffffc02045fc:	fc26                	sd	s1,56(sp)
ffffffffc02045fe:	842a                	mv	s0,a0
ffffffffc0204600:	100027f3          	csrr	a5,sstatus
ffffffffc0204604:	8b89                	andi	a5,a5,2
ffffffffc0204606:	ebb1                	bnez	a5,ffffffffc020465a <__down.constprop.0+0x64>
ffffffffc0204608:	411c                	lw	a5,0(a0)
ffffffffc020460a:	00f05a63          	blez	a5,ffffffffc020461e <__down.constprop.0+0x28>
ffffffffc020460e:	37fd                	addiw	a5,a5,-1
ffffffffc0204610:	c11c                	sw	a5,0(a0)
ffffffffc0204612:	4501                	li	a0,0
ffffffffc0204614:	60a6                	ld	ra,72(sp)
ffffffffc0204616:	6406                	ld	s0,64(sp)
ffffffffc0204618:	74e2                	ld	s1,56(sp)
ffffffffc020461a:	6161                	addi	sp,sp,80
ffffffffc020461c:	8082                	ret
ffffffffc020461e:	00850413          	addi	s0,a0,8
ffffffffc0204622:	0024                	addi	s1,sp,8
ffffffffc0204624:	10000613          	li	a2,256
ffffffffc0204628:	85a6                	mv	a1,s1
ffffffffc020462a:	8522                	mv	a0,s0
ffffffffc020462c:	f79ff0ef          	jal	ra,ffffffffc02045a4 <wait_current_set>
ffffffffc0204630:	319020ef          	jal	ra,ffffffffc0207148 <schedule>
ffffffffc0204634:	100027f3          	csrr	a5,sstatus
ffffffffc0204638:	8b89                	andi	a5,a5,2
ffffffffc020463a:	efb9                	bnez	a5,ffffffffc0204698 <__down.constprop.0+0xa2>
ffffffffc020463c:	8526                	mv	a0,s1
ffffffffc020463e:	e3dff0ef          	jal	ra,ffffffffc020447a <wait_in_queue>
ffffffffc0204642:	e531                	bnez	a0,ffffffffc020468e <__down.constprop.0+0x98>
ffffffffc0204644:	4542                	lw	a0,16(sp)
ffffffffc0204646:	10000793          	li	a5,256
ffffffffc020464a:	fcf515e3          	bne	a0,a5,ffffffffc0204614 <__down.constprop.0+0x1e>
ffffffffc020464e:	60a6                	ld	ra,72(sp)
ffffffffc0204650:	6406                	ld	s0,64(sp)
ffffffffc0204652:	74e2                	ld	s1,56(sp)
ffffffffc0204654:	4501                	li	a0,0
ffffffffc0204656:	6161                	addi	sp,sp,80
ffffffffc0204658:	8082                	ret
ffffffffc020465a:	f46fc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020465e:	401c                	lw	a5,0(s0)
ffffffffc0204660:	00f05c63          	blez	a5,ffffffffc0204678 <__down.constprop.0+0x82>
ffffffffc0204664:	37fd                	addiw	a5,a5,-1
ffffffffc0204666:	c01c                	sw	a5,0(s0)
ffffffffc0204668:	f32fc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020466c:	60a6                	ld	ra,72(sp)
ffffffffc020466e:	6406                	ld	s0,64(sp)
ffffffffc0204670:	74e2                	ld	s1,56(sp)
ffffffffc0204672:	4501                	li	a0,0
ffffffffc0204674:	6161                	addi	sp,sp,80
ffffffffc0204676:	8082                	ret
ffffffffc0204678:	0421                	addi	s0,s0,8
ffffffffc020467a:	0024                	addi	s1,sp,8
ffffffffc020467c:	10000613          	li	a2,256
ffffffffc0204680:	85a6                	mv	a1,s1
ffffffffc0204682:	8522                	mv	a0,s0
ffffffffc0204684:	f21ff0ef          	jal	ra,ffffffffc02045a4 <wait_current_set>
ffffffffc0204688:	f12fc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020468c:	b755                	j	ffffffffc0204630 <__down.constprop.0+0x3a>
ffffffffc020468e:	85a6                	mv	a1,s1
ffffffffc0204690:	8522                	mv	a0,s0
ffffffffc0204692:	d8fff0ef          	jal	ra,ffffffffc0204420 <wait_queue_del>
ffffffffc0204696:	b77d                	j	ffffffffc0204644 <__down.constprop.0+0x4e>
ffffffffc0204698:	f08fc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020469c:	8526                	mv	a0,s1
ffffffffc020469e:	dddff0ef          	jal	ra,ffffffffc020447a <wait_in_queue>
ffffffffc02046a2:	e501                	bnez	a0,ffffffffc02046aa <__down.constprop.0+0xb4>
ffffffffc02046a4:	ef6fc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02046a8:	bf71                	j	ffffffffc0204644 <__down.constprop.0+0x4e>
ffffffffc02046aa:	85a6                	mv	a1,s1
ffffffffc02046ac:	8522                	mv	a0,s0
ffffffffc02046ae:	d73ff0ef          	jal	ra,ffffffffc0204420 <wait_queue_del>
ffffffffc02046b2:	bfcd                	j	ffffffffc02046a4 <__down.constprop.0+0xae>

ffffffffc02046b4 <__up.constprop.0>:
ffffffffc02046b4:	1101                	addi	sp,sp,-32
ffffffffc02046b6:	e822                	sd	s0,16(sp)
ffffffffc02046b8:	ec06                	sd	ra,24(sp)
ffffffffc02046ba:	e426                	sd	s1,8(sp)
ffffffffc02046bc:	e04a                	sd	s2,0(sp)
ffffffffc02046be:	842a                	mv	s0,a0
ffffffffc02046c0:	100027f3          	csrr	a5,sstatus
ffffffffc02046c4:	8b89                	andi	a5,a5,2
ffffffffc02046c6:	4901                	li	s2,0
ffffffffc02046c8:	eba1                	bnez	a5,ffffffffc0204718 <__up.constprop.0+0x64>
ffffffffc02046ca:	00840493          	addi	s1,s0,8
ffffffffc02046ce:	8526                	mv	a0,s1
ffffffffc02046d0:	d8fff0ef          	jal	ra,ffffffffc020445e <wait_queue_first>
ffffffffc02046d4:	85aa                	mv	a1,a0
ffffffffc02046d6:	cd0d                	beqz	a0,ffffffffc0204710 <__up.constprop.0+0x5c>
ffffffffc02046d8:	6118                	ld	a4,0(a0)
ffffffffc02046da:	10000793          	li	a5,256
ffffffffc02046de:	0ec72703          	lw	a4,236(a4)
ffffffffc02046e2:	02f71f63          	bne	a4,a5,ffffffffc0204720 <__up.constprop.0+0x6c>
ffffffffc02046e6:	4685                	li	a3,1
ffffffffc02046e8:	10000613          	li	a2,256
ffffffffc02046ec:	8526                	mv	a0,s1
ffffffffc02046ee:	d9bff0ef          	jal	ra,ffffffffc0204488 <wakeup_wait>
ffffffffc02046f2:	00091863          	bnez	s2,ffffffffc0204702 <__up.constprop.0+0x4e>
ffffffffc02046f6:	60e2                	ld	ra,24(sp)
ffffffffc02046f8:	6442                	ld	s0,16(sp)
ffffffffc02046fa:	64a2                	ld	s1,8(sp)
ffffffffc02046fc:	6902                	ld	s2,0(sp)
ffffffffc02046fe:	6105                	addi	sp,sp,32
ffffffffc0204700:	8082                	ret
ffffffffc0204702:	6442                	ld	s0,16(sp)
ffffffffc0204704:	60e2                	ld	ra,24(sp)
ffffffffc0204706:	64a2                	ld	s1,8(sp)
ffffffffc0204708:	6902                	ld	s2,0(sp)
ffffffffc020470a:	6105                	addi	sp,sp,32
ffffffffc020470c:	e8efc06f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc0204710:	401c                	lw	a5,0(s0)
ffffffffc0204712:	2785                	addiw	a5,a5,1
ffffffffc0204714:	c01c                	sw	a5,0(s0)
ffffffffc0204716:	bff1                	j	ffffffffc02046f2 <__up.constprop.0+0x3e>
ffffffffc0204718:	e88fc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020471c:	4905                	li	s2,1
ffffffffc020471e:	b775                	j	ffffffffc02046ca <__up.constprop.0+0x16>
ffffffffc0204720:	00008697          	auipc	a3,0x8
ffffffffc0204724:	7a068693          	addi	a3,a3,1952 # ffffffffc020cec0 <default_pmm_manager+0xd8>
ffffffffc0204728:	00007617          	auipc	a2,0x7
ffffffffc020472c:	1f060613          	addi	a2,a2,496 # ffffffffc020b918 <commands+0x250>
ffffffffc0204730:	45e5                	li	a1,25
ffffffffc0204732:	00008517          	auipc	a0,0x8
ffffffffc0204736:	7b650513          	addi	a0,a0,1974 # ffffffffc020cee8 <default_pmm_manager+0x100>
ffffffffc020473a:	af5fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020473e <sem_init>:
ffffffffc020473e:	c10c                	sw	a1,0(a0)
ffffffffc0204740:	0521                	addi	a0,a0,8
ffffffffc0204742:	cd9ff06f          	j	ffffffffc020441a <wait_queue_init>

ffffffffc0204746 <up>:
ffffffffc0204746:	f6fff06f          	j	ffffffffc02046b4 <__up.constprop.0>

ffffffffc020474a <down>:
ffffffffc020474a:	1141                	addi	sp,sp,-16
ffffffffc020474c:	e406                	sd	ra,8(sp)
ffffffffc020474e:	ea9ff0ef          	jal	ra,ffffffffc02045f6 <__down.constprop.0>
ffffffffc0204752:	2501                	sext.w	a0,a0
ffffffffc0204754:	e501                	bnez	a0,ffffffffc020475c <down+0x12>
ffffffffc0204756:	60a2                	ld	ra,8(sp)
ffffffffc0204758:	0141                	addi	sp,sp,16
ffffffffc020475a:	8082                	ret
ffffffffc020475c:	00008697          	auipc	a3,0x8
ffffffffc0204760:	79c68693          	addi	a3,a3,1948 # ffffffffc020cef8 <default_pmm_manager+0x110>
ffffffffc0204764:	00007617          	auipc	a2,0x7
ffffffffc0204768:	1b460613          	addi	a2,a2,436 # ffffffffc020b918 <commands+0x250>
ffffffffc020476c:	04000593          	li	a1,64
ffffffffc0204770:	00008517          	auipc	a0,0x8
ffffffffc0204774:	77850513          	addi	a0,a0,1912 # ffffffffc020cee8 <default_pmm_manager+0x100>
ffffffffc0204778:	ab7fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020477c <copy_path>:
ffffffffc020477c:	7139                	addi	sp,sp,-64
ffffffffc020477e:	f04a                	sd	s2,32(sp)
ffffffffc0204780:	00092917          	auipc	s2,0x92
ffffffffc0204784:	14090913          	addi	s2,s2,320 # ffffffffc02968c0 <current>
ffffffffc0204788:	00093703          	ld	a4,0(s2)
ffffffffc020478c:	ec4e                	sd	s3,24(sp)
ffffffffc020478e:	89aa                	mv	s3,a0
ffffffffc0204790:	6505                	lui	a0,0x1
ffffffffc0204792:	f426                	sd	s1,40(sp)
ffffffffc0204794:	e852                	sd	s4,16(sp)
ffffffffc0204796:	fc06                	sd	ra,56(sp)
ffffffffc0204798:	f822                	sd	s0,48(sp)
ffffffffc020479a:	e456                	sd	s5,8(sp)
ffffffffc020479c:	02873a03          	ld	s4,40(a4)
ffffffffc02047a0:	84ae                	mv	s1,a1
ffffffffc02047a2:	820ff0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02047a6:	c141                	beqz	a0,ffffffffc0204826 <copy_path+0xaa>
ffffffffc02047a8:	842a                	mv	s0,a0
ffffffffc02047aa:	040a0563          	beqz	s4,ffffffffc02047f4 <copy_path+0x78>
ffffffffc02047ae:	038a0a93          	addi	s5,s4,56
ffffffffc02047b2:	8556                	mv	a0,s5
ffffffffc02047b4:	f97ff0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc02047b8:	00093783          	ld	a5,0(s2)
ffffffffc02047bc:	cba1                	beqz	a5,ffffffffc020480c <copy_path+0x90>
ffffffffc02047be:	43dc                	lw	a5,4(a5)
ffffffffc02047c0:	6685                	lui	a3,0x1
ffffffffc02047c2:	8626                	mv	a2,s1
ffffffffc02047c4:	04fa2823          	sw	a5,80(s4)
ffffffffc02047c8:	85a2                	mv	a1,s0
ffffffffc02047ca:	8552                	mv	a0,s4
ffffffffc02047cc:	d3ffe0ef          	jal	ra,ffffffffc020350a <copy_string>
ffffffffc02047d0:	c529                	beqz	a0,ffffffffc020481a <copy_path+0x9e>
ffffffffc02047d2:	8556                	mv	a0,s5
ffffffffc02047d4:	f73ff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc02047d8:	040a2823          	sw	zero,80(s4)
ffffffffc02047dc:	0089b023          	sd	s0,0(s3)
ffffffffc02047e0:	4501                	li	a0,0
ffffffffc02047e2:	70e2                	ld	ra,56(sp)
ffffffffc02047e4:	7442                	ld	s0,48(sp)
ffffffffc02047e6:	74a2                	ld	s1,40(sp)
ffffffffc02047e8:	7902                	ld	s2,32(sp)
ffffffffc02047ea:	69e2                	ld	s3,24(sp)
ffffffffc02047ec:	6a42                	ld	s4,16(sp)
ffffffffc02047ee:	6aa2                	ld	s5,8(sp)
ffffffffc02047f0:	6121                	addi	sp,sp,64
ffffffffc02047f2:	8082                	ret
ffffffffc02047f4:	85aa                	mv	a1,a0
ffffffffc02047f6:	6685                	lui	a3,0x1
ffffffffc02047f8:	8626                	mv	a2,s1
ffffffffc02047fa:	4501                	li	a0,0
ffffffffc02047fc:	d0ffe0ef          	jal	ra,ffffffffc020350a <copy_string>
ffffffffc0204800:	fd71                	bnez	a0,ffffffffc02047dc <copy_path+0x60>
ffffffffc0204802:	8522                	mv	a0,s0
ffffffffc0204804:	86eff0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0204808:	5575                	li	a0,-3
ffffffffc020480a:	bfe1                	j	ffffffffc02047e2 <copy_path+0x66>
ffffffffc020480c:	6685                	lui	a3,0x1
ffffffffc020480e:	8626                	mv	a2,s1
ffffffffc0204810:	85a2                	mv	a1,s0
ffffffffc0204812:	8552                	mv	a0,s4
ffffffffc0204814:	cf7fe0ef          	jal	ra,ffffffffc020350a <copy_string>
ffffffffc0204818:	fd4d                	bnez	a0,ffffffffc02047d2 <copy_path+0x56>
ffffffffc020481a:	8556                	mv	a0,s5
ffffffffc020481c:	f2bff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204820:	040a2823          	sw	zero,80(s4)
ffffffffc0204824:	bff9                	j	ffffffffc0204802 <copy_path+0x86>
ffffffffc0204826:	5571                	li	a0,-4
ffffffffc0204828:	bf6d                	j	ffffffffc02047e2 <copy_path+0x66>

ffffffffc020482a <sysfile_open>:
ffffffffc020482a:	7179                	addi	sp,sp,-48
ffffffffc020482c:	872a                	mv	a4,a0
ffffffffc020482e:	ec26                	sd	s1,24(sp)
ffffffffc0204830:	0028                	addi	a0,sp,8
ffffffffc0204832:	84ae                	mv	s1,a1
ffffffffc0204834:	85ba                	mv	a1,a4
ffffffffc0204836:	f022                	sd	s0,32(sp)
ffffffffc0204838:	f406                	sd	ra,40(sp)
ffffffffc020483a:	f43ff0ef          	jal	ra,ffffffffc020477c <copy_path>
ffffffffc020483e:	842a                	mv	s0,a0
ffffffffc0204840:	e909                	bnez	a0,ffffffffc0204852 <sysfile_open+0x28>
ffffffffc0204842:	6522                	ld	a0,8(sp)
ffffffffc0204844:	85a6                	mv	a1,s1
ffffffffc0204846:	7ba000ef          	jal	ra,ffffffffc0205000 <file_open>
ffffffffc020484a:	842a                	mv	s0,a0
ffffffffc020484c:	6522                	ld	a0,8(sp)
ffffffffc020484e:	824ff0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0204852:	70a2                	ld	ra,40(sp)
ffffffffc0204854:	8522                	mv	a0,s0
ffffffffc0204856:	7402                	ld	s0,32(sp)
ffffffffc0204858:	64e2                	ld	s1,24(sp)
ffffffffc020485a:	6145                	addi	sp,sp,48
ffffffffc020485c:	8082                	ret

ffffffffc020485e <sysfile_close>:
ffffffffc020485e:	0a10006f          	j	ffffffffc02050fe <file_close>

ffffffffc0204862 <sysfile_read>:
ffffffffc0204862:	7159                	addi	sp,sp,-112
ffffffffc0204864:	f0a2                	sd	s0,96(sp)
ffffffffc0204866:	f486                	sd	ra,104(sp)
ffffffffc0204868:	eca6                	sd	s1,88(sp)
ffffffffc020486a:	e8ca                	sd	s2,80(sp)
ffffffffc020486c:	e4ce                	sd	s3,72(sp)
ffffffffc020486e:	e0d2                	sd	s4,64(sp)
ffffffffc0204870:	fc56                	sd	s5,56(sp)
ffffffffc0204872:	f85a                	sd	s6,48(sp)
ffffffffc0204874:	f45e                	sd	s7,40(sp)
ffffffffc0204876:	f062                	sd	s8,32(sp)
ffffffffc0204878:	ec66                	sd	s9,24(sp)
ffffffffc020487a:	4401                	li	s0,0
ffffffffc020487c:	ee19                	bnez	a2,ffffffffc020489a <sysfile_read+0x38>
ffffffffc020487e:	70a6                	ld	ra,104(sp)
ffffffffc0204880:	8522                	mv	a0,s0
ffffffffc0204882:	7406                	ld	s0,96(sp)
ffffffffc0204884:	64e6                	ld	s1,88(sp)
ffffffffc0204886:	6946                	ld	s2,80(sp)
ffffffffc0204888:	69a6                	ld	s3,72(sp)
ffffffffc020488a:	6a06                	ld	s4,64(sp)
ffffffffc020488c:	7ae2                	ld	s5,56(sp)
ffffffffc020488e:	7b42                	ld	s6,48(sp)
ffffffffc0204890:	7ba2                	ld	s7,40(sp)
ffffffffc0204892:	7c02                	ld	s8,32(sp)
ffffffffc0204894:	6ce2                	ld	s9,24(sp)
ffffffffc0204896:	6165                	addi	sp,sp,112
ffffffffc0204898:	8082                	ret
ffffffffc020489a:	00092c97          	auipc	s9,0x92
ffffffffc020489e:	026c8c93          	addi	s9,s9,38 # ffffffffc02968c0 <current>
ffffffffc02048a2:	000cb783          	ld	a5,0(s9)
ffffffffc02048a6:	84b2                	mv	s1,a2
ffffffffc02048a8:	8b2e                	mv	s6,a1
ffffffffc02048aa:	4601                	li	a2,0
ffffffffc02048ac:	4585                	li	a1,1
ffffffffc02048ae:	0287b903          	ld	s2,40(a5)
ffffffffc02048b2:	8aaa                	mv	s5,a0
ffffffffc02048b4:	6f8000ef          	jal	ra,ffffffffc0204fac <file_testfd>
ffffffffc02048b8:	c959                	beqz	a0,ffffffffc020494e <sysfile_read+0xec>
ffffffffc02048ba:	6505                	lui	a0,0x1
ffffffffc02048bc:	f07fe0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02048c0:	89aa                	mv	s3,a0
ffffffffc02048c2:	c941                	beqz	a0,ffffffffc0204952 <sysfile_read+0xf0>
ffffffffc02048c4:	4b81                	li	s7,0
ffffffffc02048c6:	6a05                	lui	s4,0x1
ffffffffc02048c8:	03890c13          	addi	s8,s2,56
ffffffffc02048cc:	0744ec63          	bltu	s1,s4,ffffffffc0204944 <sysfile_read+0xe2>
ffffffffc02048d0:	e452                	sd	s4,8(sp)
ffffffffc02048d2:	6605                	lui	a2,0x1
ffffffffc02048d4:	0034                	addi	a3,sp,8
ffffffffc02048d6:	85ce                	mv	a1,s3
ffffffffc02048d8:	8556                	mv	a0,s5
ffffffffc02048da:	07b000ef          	jal	ra,ffffffffc0205154 <file_read>
ffffffffc02048de:	66a2                	ld	a3,8(sp)
ffffffffc02048e0:	842a                	mv	s0,a0
ffffffffc02048e2:	ca9d                	beqz	a3,ffffffffc0204918 <sysfile_read+0xb6>
ffffffffc02048e4:	00090c63          	beqz	s2,ffffffffc02048fc <sysfile_read+0x9a>
ffffffffc02048e8:	8562                	mv	a0,s8
ffffffffc02048ea:	e61ff0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc02048ee:	000cb783          	ld	a5,0(s9)
ffffffffc02048f2:	cfa1                	beqz	a5,ffffffffc020494a <sysfile_read+0xe8>
ffffffffc02048f4:	43dc                	lw	a5,4(a5)
ffffffffc02048f6:	66a2                	ld	a3,8(sp)
ffffffffc02048f8:	04f92823          	sw	a5,80(s2)
ffffffffc02048fc:	864e                	mv	a2,s3
ffffffffc02048fe:	85da                	mv	a1,s6
ffffffffc0204900:	854a                	mv	a0,s2
ffffffffc0204902:	bd7fe0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc0204906:	c50d                	beqz	a0,ffffffffc0204930 <sysfile_read+0xce>
ffffffffc0204908:	67a2                	ld	a5,8(sp)
ffffffffc020490a:	04f4e663          	bltu	s1,a5,ffffffffc0204956 <sysfile_read+0xf4>
ffffffffc020490e:	9b3e                	add	s6,s6,a5
ffffffffc0204910:	8c9d                	sub	s1,s1,a5
ffffffffc0204912:	9bbe                	add	s7,s7,a5
ffffffffc0204914:	02091263          	bnez	s2,ffffffffc0204938 <sysfile_read+0xd6>
ffffffffc0204918:	e401                	bnez	s0,ffffffffc0204920 <sysfile_read+0xbe>
ffffffffc020491a:	67a2                	ld	a5,8(sp)
ffffffffc020491c:	c391                	beqz	a5,ffffffffc0204920 <sysfile_read+0xbe>
ffffffffc020491e:	f4dd                	bnez	s1,ffffffffc02048cc <sysfile_read+0x6a>
ffffffffc0204920:	854e                	mv	a0,s3
ffffffffc0204922:	f51fe0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0204926:	f40b8ce3          	beqz	s7,ffffffffc020487e <sysfile_read+0x1c>
ffffffffc020492a:	000b841b          	sext.w	s0,s7
ffffffffc020492e:	bf81                	j	ffffffffc020487e <sysfile_read+0x1c>
ffffffffc0204930:	e011                	bnez	s0,ffffffffc0204934 <sysfile_read+0xd2>
ffffffffc0204932:	5475                	li	s0,-3
ffffffffc0204934:	fe0906e3          	beqz	s2,ffffffffc0204920 <sysfile_read+0xbe>
ffffffffc0204938:	8562                	mv	a0,s8
ffffffffc020493a:	e0dff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020493e:	04092823          	sw	zero,80(s2)
ffffffffc0204942:	bfd9                	j	ffffffffc0204918 <sysfile_read+0xb6>
ffffffffc0204944:	e426                	sd	s1,8(sp)
ffffffffc0204946:	8626                	mv	a2,s1
ffffffffc0204948:	b771                	j	ffffffffc02048d4 <sysfile_read+0x72>
ffffffffc020494a:	66a2                	ld	a3,8(sp)
ffffffffc020494c:	bf45                	j	ffffffffc02048fc <sysfile_read+0x9a>
ffffffffc020494e:	5475                	li	s0,-3
ffffffffc0204950:	b73d                	j	ffffffffc020487e <sysfile_read+0x1c>
ffffffffc0204952:	5471                	li	s0,-4
ffffffffc0204954:	b72d                	j	ffffffffc020487e <sysfile_read+0x1c>
ffffffffc0204956:	00008697          	auipc	a3,0x8
ffffffffc020495a:	5b268693          	addi	a3,a3,1458 # ffffffffc020cf08 <default_pmm_manager+0x120>
ffffffffc020495e:	00007617          	auipc	a2,0x7
ffffffffc0204962:	fba60613          	addi	a2,a2,-70 # ffffffffc020b918 <commands+0x250>
ffffffffc0204966:	05500593          	li	a1,85
ffffffffc020496a:	00008517          	auipc	a0,0x8
ffffffffc020496e:	5ae50513          	addi	a0,a0,1454 # ffffffffc020cf18 <default_pmm_manager+0x130>
ffffffffc0204972:	8bdfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204976 <sysfile_write>:
ffffffffc0204976:	7159                	addi	sp,sp,-112
ffffffffc0204978:	e8ca                	sd	s2,80(sp)
ffffffffc020497a:	f486                	sd	ra,104(sp)
ffffffffc020497c:	f0a2                	sd	s0,96(sp)
ffffffffc020497e:	eca6                	sd	s1,88(sp)
ffffffffc0204980:	e4ce                	sd	s3,72(sp)
ffffffffc0204982:	e0d2                	sd	s4,64(sp)
ffffffffc0204984:	fc56                	sd	s5,56(sp)
ffffffffc0204986:	f85a                	sd	s6,48(sp)
ffffffffc0204988:	f45e                	sd	s7,40(sp)
ffffffffc020498a:	f062                	sd	s8,32(sp)
ffffffffc020498c:	ec66                	sd	s9,24(sp)
ffffffffc020498e:	4901                	li	s2,0
ffffffffc0204990:	ee19                	bnez	a2,ffffffffc02049ae <sysfile_write+0x38>
ffffffffc0204992:	70a6                	ld	ra,104(sp)
ffffffffc0204994:	7406                	ld	s0,96(sp)
ffffffffc0204996:	64e6                	ld	s1,88(sp)
ffffffffc0204998:	69a6                	ld	s3,72(sp)
ffffffffc020499a:	6a06                	ld	s4,64(sp)
ffffffffc020499c:	7ae2                	ld	s5,56(sp)
ffffffffc020499e:	7b42                	ld	s6,48(sp)
ffffffffc02049a0:	7ba2                	ld	s7,40(sp)
ffffffffc02049a2:	7c02                	ld	s8,32(sp)
ffffffffc02049a4:	6ce2                	ld	s9,24(sp)
ffffffffc02049a6:	854a                	mv	a0,s2
ffffffffc02049a8:	6946                	ld	s2,80(sp)
ffffffffc02049aa:	6165                	addi	sp,sp,112
ffffffffc02049ac:	8082                	ret
ffffffffc02049ae:	00092c17          	auipc	s8,0x92
ffffffffc02049b2:	f12c0c13          	addi	s8,s8,-238 # ffffffffc02968c0 <current>
ffffffffc02049b6:	000c3783          	ld	a5,0(s8)
ffffffffc02049ba:	8432                	mv	s0,a2
ffffffffc02049bc:	89ae                	mv	s3,a1
ffffffffc02049be:	4605                	li	a2,1
ffffffffc02049c0:	4581                	li	a1,0
ffffffffc02049c2:	7784                	ld	s1,40(a5)
ffffffffc02049c4:	8baa                	mv	s7,a0
ffffffffc02049c6:	5e6000ef          	jal	ra,ffffffffc0204fac <file_testfd>
ffffffffc02049ca:	cd59                	beqz	a0,ffffffffc0204a68 <sysfile_write+0xf2>
ffffffffc02049cc:	6505                	lui	a0,0x1
ffffffffc02049ce:	df5fe0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02049d2:	8a2a                	mv	s4,a0
ffffffffc02049d4:	cd41                	beqz	a0,ffffffffc0204a6c <sysfile_write+0xf6>
ffffffffc02049d6:	4c81                	li	s9,0
ffffffffc02049d8:	6a85                	lui	s5,0x1
ffffffffc02049da:	03848b13          	addi	s6,s1,56
ffffffffc02049de:	05546a63          	bltu	s0,s5,ffffffffc0204a32 <sysfile_write+0xbc>
ffffffffc02049e2:	e456                	sd	s5,8(sp)
ffffffffc02049e4:	c8a9                	beqz	s1,ffffffffc0204a36 <sysfile_write+0xc0>
ffffffffc02049e6:	855a                	mv	a0,s6
ffffffffc02049e8:	d63ff0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc02049ec:	000c3783          	ld	a5,0(s8)
ffffffffc02049f0:	c399                	beqz	a5,ffffffffc02049f6 <sysfile_write+0x80>
ffffffffc02049f2:	43dc                	lw	a5,4(a5)
ffffffffc02049f4:	c8bc                	sw	a5,80(s1)
ffffffffc02049f6:	66a2                	ld	a3,8(sp)
ffffffffc02049f8:	4701                	li	a4,0
ffffffffc02049fa:	864e                	mv	a2,s3
ffffffffc02049fc:	85d2                	mv	a1,s4
ffffffffc02049fe:	8526                	mv	a0,s1
ffffffffc0204a00:	aa5fe0ef          	jal	ra,ffffffffc02034a4 <copy_from_user>
ffffffffc0204a04:	c139                	beqz	a0,ffffffffc0204a4a <sysfile_write+0xd4>
ffffffffc0204a06:	855a                	mv	a0,s6
ffffffffc0204a08:	d3fff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204a0c:	0404a823          	sw	zero,80(s1)
ffffffffc0204a10:	6622                	ld	a2,8(sp)
ffffffffc0204a12:	0034                	addi	a3,sp,8
ffffffffc0204a14:	85d2                	mv	a1,s4
ffffffffc0204a16:	855e                	mv	a0,s7
ffffffffc0204a18:	023000ef          	jal	ra,ffffffffc020523a <file_write>
ffffffffc0204a1c:	67a2                	ld	a5,8(sp)
ffffffffc0204a1e:	892a                	mv	s2,a0
ffffffffc0204a20:	ef85                	bnez	a5,ffffffffc0204a58 <sysfile_write+0xe2>
ffffffffc0204a22:	8552                	mv	a0,s4
ffffffffc0204a24:	e4ffe0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0204a28:	f60c85e3          	beqz	s9,ffffffffc0204992 <sysfile_write+0x1c>
ffffffffc0204a2c:	000c891b          	sext.w	s2,s9
ffffffffc0204a30:	b78d                	j	ffffffffc0204992 <sysfile_write+0x1c>
ffffffffc0204a32:	e422                	sd	s0,8(sp)
ffffffffc0204a34:	f8cd                	bnez	s1,ffffffffc02049e6 <sysfile_write+0x70>
ffffffffc0204a36:	66a2                	ld	a3,8(sp)
ffffffffc0204a38:	4701                	li	a4,0
ffffffffc0204a3a:	864e                	mv	a2,s3
ffffffffc0204a3c:	85d2                	mv	a1,s4
ffffffffc0204a3e:	4501                	li	a0,0
ffffffffc0204a40:	a65fe0ef          	jal	ra,ffffffffc02034a4 <copy_from_user>
ffffffffc0204a44:	f571                	bnez	a0,ffffffffc0204a10 <sysfile_write+0x9a>
ffffffffc0204a46:	5975                	li	s2,-3
ffffffffc0204a48:	bfe9                	j	ffffffffc0204a22 <sysfile_write+0xac>
ffffffffc0204a4a:	855a                	mv	a0,s6
ffffffffc0204a4c:	cfbff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204a50:	5975                	li	s2,-3
ffffffffc0204a52:	0404a823          	sw	zero,80(s1)
ffffffffc0204a56:	b7f1                	j	ffffffffc0204a22 <sysfile_write+0xac>
ffffffffc0204a58:	00f46c63          	bltu	s0,a5,ffffffffc0204a70 <sysfile_write+0xfa>
ffffffffc0204a5c:	99be                	add	s3,s3,a5
ffffffffc0204a5e:	8c1d                	sub	s0,s0,a5
ffffffffc0204a60:	9cbe                	add	s9,s9,a5
ffffffffc0204a62:	f161                	bnez	a0,ffffffffc0204a22 <sysfile_write+0xac>
ffffffffc0204a64:	fc2d                	bnez	s0,ffffffffc02049de <sysfile_write+0x68>
ffffffffc0204a66:	bf75                	j	ffffffffc0204a22 <sysfile_write+0xac>
ffffffffc0204a68:	5975                	li	s2,-3
ffffffffc0204a6a:	b725                	j	ffffffffc0204992 <sysfile_write+0x1c>
ffffffffc0204a6c:	5971                	li	s2,-4
ffffffffc0204a6e:	b715                	j	ffffffffc0204992 <sysfile_write+0x1c>
ffffffffc0204a70:	00008697          	auipc	a3,0x8
ffffffffc0204a74:	49868693          	addi	a3,a3,1176 # ffffffffc020cf08 <default_pmm_manager+0x120>
ffffffffc0204a78:	00007617          	auipc	a2,0x7
ffffffffc0204a7c:	ea060613          	addi	a2,a2,-352 # ffffffffc020b918 <commands+0x250>
ffffffffc0204a80:	08a00593          	li	a1,138
ffffffffc0204a84:	00008517          	auipc	a0,0x8
ffffffffc0204a88:	49450513          	addi	a0,a0,1172 # ffffffffc020cf18 <default_pmm_manager+0x130>
ffffffffc0204a8c:	fa2fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204a90 <sysfile_seek>:
ffffffffc0204a90:	0910006f          	j	ffffffffc0205320 <file_seek>

ffffffffc0204a94 <sysfile_fstat>:
ffffffffc0204a94:	715d                	addi	sp,sp,-80
ffffffffc0204a96:	f44e                	sd	s3,40(sp)
ffffffffc0204a98:	00092997          	auipc	s3,0x92
ffffffffc0204a9c:	e2898993          	addi	s3,s3,-472 # ffffffffc02968c0 <current>
ffffffffc0204aa0:	0009b703          	ld	a4,0(s3)
ffffffffc0204aa4:	fc26                	sd	s1,56(sp)
ffffffffc0204aa6:	84ae                	mv	s1,a1
ffffffffc0204aa8:	858a                	mv	a1,sp
ffffffffc0204aaa:	e0a2                	sd	s0,64(sp)
ffffffffc0204aac:	f84a                	sd	s2,48(sp)
ffffffffc0204aae:	e486                	sd	ra,72(sp)
ffffffffc0204ab0:	02873903          	ld	s2,40(a4)
ffffffffc0204ab4:	f052                	sd	s4,32(sp)
ffffffffc0204ab6:	18b000ef          	jal	ra,ffffffffc0205440 <file_fstat>
ffffffffc0204aba:	842a                	mv	s0,a0
ffffffffc0204abc:	e91d                	bnez	a0,ffffffffc0204af2 <sysfile_fstat+0x5e>
ffffffffc0204abe:	04090363          	beqz	s2,ffffffffc0204b04 <sysfile_fstat+0x70>
ffffffffc0204ac2:	03890a13          	addi	s4,s2,56
ffffffffc0204ac6:	8552                	mv	a0,s4
ffffffffc0204ac8:	c83ff0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0204acc:	0009b783          	ld	a5,0(s3)
ffffffffc0204ad0:	c3b9                	beqz	a5,ffffffffc0204b16 <sysfile_fstat+0x82>
ffffffffc0204ad2:	43dc                	lw	a5,4(a5)
ffffffffc0204ad4:	02000693          	li	a3,32
ffffffffc0204ad8:	860a                	mv	a2,sp
ffffffffc0204ada:	04f92823          	sw	a5,80(s2)
ffffffffc0204ade:	85a6                	mv	a1,s1
ffffffffc0204ae0:	854a                	mv	a0,s2
ffffffffc0204ae2:	9f7fe0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc0204ae6:	c121                	beqz	a0,ffffffffc0204b26 <sysfile_fstat+0x92>
ffffffffc0204ae8:	8552                	mv	a0,s4
ffffffffc0204aea:	c5dff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204aee:	04092823          	sw	zero,80(s2)
ffffffffc0204af2:	60a6                	ld	ra,72(sp)
ffffffffc0204af4:	8522                	mv	a0,s0
ffffffffc0204af6:	6406                	ld	s0,64(sp)
ffffffffc0204af8:	74e2                	ld	s1,56(sp)
ffffffffc0204afa:	7942                	ld	s2,48(sp)
ffffffffc0204afc:	79a2                	ld	s3,40(sp)
ffffffffc0204afe:	7a02                	ld	s4,32(sp)
ffffffffc0204b00:	6161                	addi	sp,sp,80
ffffffffc0204b02:	8082                	ret
ffffffffc0204b04:	02000693          	li	a3,32
ffffffffc0204b08:	860a                	mv	a2,sp
ffffffffc0204b0a:	85a6                	mv	a1,s1
ffffffffc0204b0c:	9cdfe0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc0204b10:	f16d                	bnez	a0,ffffffffc0204af2 <sysfile_fstat+0x5e>
ffffffffc0204b12:	5475                	li	s0,-3
ffffffffc0204b14:	bff9                	j	ffffffffc0204af2 <sysfile_fstat+0x5e>
ffffffffc0204b16:	02000693          	li	a3,32
ffffffffc0204b1a:	860a                	mv	a2,sp
ffffffffc0204b1c:	85a6                	mv	a1,s1
ffffffffc0204b1e:	854a                	mv	a0,s2
ffffffffc0204b20:	9b9fe0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc0204b24:	f171                	bnez	a0,ffffffffc0204ae8 <sysfile_fstat+0x54>
ffffffffc0204b26:	8552                	mv	a0,s4
ffffffffc0204b28:	c1fff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204b2c:	5475                	li	s0,-3
ffffffffc0204b2e:	04092823          	sw	zero,80(s2)
ffffffffc0204b32:	b7c1                	j	ffffffffc0204af2 <sysfile_fstat+0x5e>

ffffffffc0204b34 <sysfile_fsync>:
ffffffffc0204b34:	1cd0006f          	j	ffffffffc0205500 <file_fsync>

ffffffffc0204b38 <sysfile_getcwd>:
ffffffffc0204b38:	715d                	addi	sp,sp,-80
ffffffffc0204b3a:	f44e                	sd	s3,40(sp)
ffffffffc0204b3c:	00092997          	auipc	s3,0x92
ffffffffc0204b40:	d8498993          	addi	s3,s3,-636 # ffffffffc02968c0 <current>
ffffffffc0204b44:	0009b783          	ld	a5,0(s3)
ffffffffc0204b48:	f84a                	sd	s2,48(sp)
ffffffffc0204b4a:	e486                	sd	ra,72(sp)
ffffffffc0204b4c:	e0a2                	sd	s0,64(sp)
ffffffffc0204b4e:	fc26                	sd	s1,56(sp)
ffffffffc0204b50:	f052                	sd	s4,32(sp)
ffffffffc0204b52:	0287b903          	ld	s2,40(a5)
ffffffffc0204b56:	cda9                	beqz	a1,ffffffffc0204bb0 <sysfile_getcwd+0x78>
ffffffffc0204b58:	842e                	mv	s0,a1
ffffffffc0204b5a:	84aa                	mv	s1,a0
ffffffffc0204b5c:	04090363          	beqz	s2,ffffffffc0204ba2 <sysfile_getcwd+0x6a>
ffffffffc0204b60:	03890a13          	addi	s4,s2,56
ffffffffc0204b64:	8552                	mv	a0,s4
ffffffffc0204b66:	be5ff0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0204b6a:	0009b783          	ld	a5,0(s3)
ffffffffc0204b6e:	c781                	beqz	a5,ffffffffc0204b76 <sysfile_getcwd+0x3e>
ffffffffc0204b70:	43dc                	lw	a5,4(a5)
ffffffffc0204b72:	04f92823          	sw	a5,80(s2)
ffffffffc0204b76:	4685                	li	a3,1
ffffffffc0204b78:	8622                	mv	a2,s0
ffffffffc0204b7a:	85a6                	mv	a1,s1
ffffffffc0204b7c:	854a                	mv	a0,s2
ffffffffc0204b7e:	893fe0ef          	jal	ra,ffffffffc0203410 <user_mem_check>
ffffffffc0204b82:	e90d                	bnez	a0,ffffffffc0204bb4 <sysfile_getcwd+0x7c>
ffffffffc0204b84:	5475                	li	s0,-3
ffffffffc0204b86:	8552                	mv	a0,s4
ffffffffc0204b88:	bbfff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204b8c:	04092823          	sw	zero,80(s2)
ffffffffc0204b90:	60a6                	ld	ra,72(sp)
ffffffffc0204b92:	8522                	mv	a0,s0
ffffffffc0204b94:	6406                	ld	s0,64(sp)
ffffffffc0204b96:	74e2                	ld	s1,56(sp)
ffffffffc0204b98:	7942                	ld	s2,48(sp)
ffffffffc0204b9a:	79a2                	ld	s3,40(sp)
ffffffffc0204b9c:	7a02                	ld	s4,32(sp)
ffffffffc0204b9e:	6161                	addi	sp,sp,80
ffffffffc0204ba0:	8082                	ret
ffffffffc0204ba2:	862e                	mv	a2,a1
ffffffffc0204ba4:	4685                	li	a3,1
ffffffffc0204ba6:	85aa                	mv	a1,a0
ffffffffc0204ba8:	4501                	li	a0,0
ffffffffc0204baa:	867fe0ef          	jal	ra,ffffffffc0203410 <user_mem_check>
ffffffffc0204bae:	ed09                	bnez	a0,ffffffffc0204bc8 <sysfile_getcwd+0x90>
ffffffffc0204bb0:	5475                	li	s0,-3
ffffffffc0204bb2:	bff9                	j	ffffffffc0204b90 <sysfile_getcwd+0x58>
ffffffffc0204bb4:	8622                	mv	a2,s0
ffffffffc0204bb6:	4681                	li	a3,0
ffffffffc0204bb8:	85a6                	mv	a1,s1
ffffffffc0204bba:	850a                	mv	a0,sp
ffffffffc0204bbc:	371000ef          	jal	ra,ffffffffc020572c <iobuf_init>
ffffffffc0204bc0:	016030ef          	jal	ra,ffffffffc0207bd6 <vfs_getcwd>
ffffffffc0204bc4:	842a                	mv	s0,a0
ffffffffc0204bc6:	b7c1                	j	ffffffffc0204b86 <sysfile_getcwd+0x4e>
ffffffffc0204bc8:	8622                	mv	a2,s0
ffffffffc0204bca:	4681                	li	a3,0
ffffffffc0204bcc:	85a6                	mv	a1,s1
ffffffffc0204bce:	850a                	mv	a0,sp
ffffffffc0204bd0:	35d000ef          	jal	ra,ffffffffc020572c <iobuf_init>
ffffffffc0204bd4:	002030ef          	jal	ra,ffffffffc0207bd6 <vfs_getcwd>
ffffffffc0204bd8:	842a                	mv	s0,a0
ffffffffc0204bda:	bf5d                	j	ffffffffc0204b90 <sysfile_getcwd+0x58>

ffffffffc0204bdc <sysfile_getdirentry>:
ffffffffc0204bdc:	7139                	addi	sp,sp,-64
ffffffffc0204bde:	e852                	sd	s4,16(sp)
ffffffffc0204be0:	00092a17          	auipc	s4,0x92
ffffffffc0204be4:	ce0a0a13          	addi	s4,s4,-800 # ffffffffc02968c0 <current>
ffffffffc0204be8:	000a3703          	ld	a4,0(s4)
ffffffffc0204bec:	ec4e                	sd	s3,24(sp)
ffffffffc0204bee:	89aa                	mv	s3,a0
ffffffffc0204bf0:	10800513          	li	a0,264
ffffffffc0204bf4:	f426                	sd	s1,40(sp)
ffffffffc0204bf6:	f04a                	sd	s2,32(sp)
ffffffffc0204bf8:	fc06                	sd	ra,56(sp)
ffffffffc0204bfa:	f822                	sd	s0,48(sp)
ffffffffc0204bfc:	e456                	sd	s5,8(sp)
ffffffffc0204bfe:	7704                	ld	s1,40(a4)
ffffffffc0204c00:	892e                	mv	s2,a1
ffffffffc0204c02:	bc1fe0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0204c06:	c169                	beqz	a0,ffffffffc0204cc8 <sysfile_getdirentry+0xec>
ffffffffc0204c08:	842a                	mv	s0,a0
ffffffffc0204c0a:	c8c1                	beqz	s1,ffffffffc0204c9a <sysfile_getdirentry+0xbe>
ffffffffc0204c0c:	03848a93          	addi	s5,s1,56
ffffffffc0204c10:	8556                	mv	a0,s5
ffffffffc0204c12:	b39ff0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0204c16:	000a3783          	ld	a5,0(s4)
ffffffffc0204c1a:	c399                	beqz	a5,ffffffffc0204c20 <sysfile_getdirentry+0x44>
ffffffffc0204c1c:	43dc                	lw	a5,4(a5)
ffffffffc0204c1e:	c8bc                	sw	a5,80(s1)
ffffffffc0204c20:	4705                	li	a4,1
ffffffffc0204c22:	46a1                	li	a3,8
ffffffffc0204c24:	864a                	mv	a2,s2
ffffffffc0204c26:	85a2                	mv	a1,s0
ffffffffc0204c28:	8526                	mv	a0,s1
ffffffffc0204c2a:	87bfe0ef          	jal	ra,ffffffffc02034a4 <copy_from_user>
ffffffffc0204c2e:	e505                	bnez	a0,ffffffffc0204c56 <sysfile_getdirentry+0x7a>
ffffffffc0204c30:	8556                	mv	a0,s5
ffffffffc0204c32:	b15ff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204c36:	59f5                	li	s3,-3
ffffffffc0204c38:	0404a823          	sw	zero,80(s1)
ffffffffc0204c3c:	8522                	mv	a0,s0
ffffffffc0204c3e:	c35fe0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0204c42:	70e2                	ld	ra,56(sp)
ffffffffc0204c44:	7442                	ld	s0,48(sp)
ffffffffc0204c46:	74a2                	ld	s1,40(sp)
ffffffffc0204c48:	7902                	ld	s2,32(sp)
ffffffffc0204c4a:	6a42                	ld	s4,16(sp)
ffffffffc0204c4c:	6aa2                	ld	s5,8(sp)
ffffffffc0204c4e:	854e                	mv	a0,s3
ffffffffc0204c50:	69e2                	ld	s3,24(sp)
ffffffffc0204c52:	6121                	addi	sp,sp,64
ffffffffc0204c54:	8082                	ret
ffffffffc0204c56:	8556                	mv	a0,s5
ffffffffc0204c58:	aefff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204c5c:	854e                	mv	a0,s3
ffffffffc0204c5e:	85a2                	mv	a1,s0
ffffffffc0204c60:	0404a823          	sw	zero,80(s1)
ffffffffc0204c64:	14b000ef          	jal	ra,ffffffffc02055ae <file_getdirentry>
ffffffffc0204c68:	89aa                	mv	s3,a0
ffffffffc0204c6a:	f969                	bnez	a0,ffffffffc0204c3c <sysfile_getdirentry+0x60>
ffffffffc0204c6c:	8556                	mv	a0,s5
ffffffffc0204c6e:	addff0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0204c72:	000a3783          	ld	a5,0(s4)
ffffffffc0204c76:	c399                	beqz	a5,ffffffffc0204c7c <sysfile_getdirentry+0xa0>
ffffffffc0204c78:	43dc                	lw	a5,4(a5)
ffffffffc0204c7a:	c8bc                	sw	a5,80(s1)
ffffffffc0204c7c:	10800693          	li	a3,264
ffffffffc0204c80:	8622                	mv	a2,s0
ffffffffc0204c82:	85ca                	mv	a1,s2
ffffffffc0204c84:	8526                	mv	a0,s1
ffffffffc0204c86:	853fe0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc0204c8a:	e111                	bnez	a0,ffffffffc0204c8e <sysfile_getdirentry+0xb2>
ffffffffc0204c8c:	59f5                	li	s3,-3
ffffffffc0204c8e:	8556                	mv	a0,s5
ffffffffc0204c90:	ab7ff0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0204c94:	0404a823          	sw	zero,80(s1)
ffffffffc0204c98:	b755                	j	ffffffffc0204c3c <sysfile_getdirentry+0x60>
ffffffffc0204c9a:	85aa                	mv	a1,a0
ffffffffc0204c9c:	4705                	li	a4,1
ffffffffc0204c9e:	46a1                	li	a3,8
ffffffffc0204ca0:	864a                	mv	a2,s2
ffffffffc0204ca2:	4501                	li	a0,0
ffffffffc0204ca4:	801fe0ef          	jal	ra,ffffffffc02034a4 <copy_from_user>
ffffffffc0204ca8:	cd11                	beqz	a0,ffffffffc0204cc4 <sysfile_getdirentry+0xe8>
ffffffffc0204caa:	854e                	mv	a0,s3
ffffffffc0204cac:	85a2                	mv	a1,s0
ffffffffc0204cae:	101000ef          	jal	ra,ffffffffc02055ae <file_getdirentry>
ffffffffc0204cb2:	89aa                	mv	s3,a0
ffffffffc0204cb4:	f541                	bnez	a0,ffffffffc0204c3c <sysfile_getdirentry+0x60>
ffffffffc0204cb6:	10800693          	li	a3,264
ffffffffc0204cba:	8622                	mv	a2,s0
ffffffffc0204cbc:	85ca                	mv	a1,s2
ffffffffc0204cbe:	81bfe0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc0204cc2:	fd2d                	bnez	a0,ffffffffc0204c3c <sysfile_getdirentry+0x60>
ffffffffc0204cc4:	59f5                	li	s3,-3
ffffffffc0204cc6:	bf9d                	j	ffffffffc0204c3c <sysfile_getdirentry+0x60>
ffffffffc0204cc8:	59f1                	li	s3,-4
ffffffffc0204cca:	bfa5                	j	ffffffffc0204c42 <sysfile_getdirentry+0x66>

ffffffffc0204ccc <sysfile_dup>:
ffffffffc0204ccc:	1c90006f          	j	ffffffffc0205694 <file_dup>

ffffffffc0204cd0 <get_fd_array.part.0>:
ffffffffc0204cd0:	1141                	addi	sp,sp,-16
ffffffffc0204cd2:	00008697          	auipc	a3,0x8
ffffffffc0204cd6:	25e68693          	addi	a3,a3,606 # ffffffffc020cf30 <default_pmm_manager+0x148>
ffffffffc0204cda:	00007617          	auipc	a2,0x7
ffffffffc0204cde:	c3e60613          	addi	a2,a2,-962 # ffffffffc020b918 <commands+0x250>
ffffffffc0204ce2:	45d1                	li	a1,20
ffffffffc0204ce4:	00008517          	auipc	a0,0x8
ffffffffc0204ce8:	27c50513          	addi	a0,a0,636 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204cec:	e406                	sd	ra,8(sp)
ffffffffc0204cee:	d40fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204cf2 <fd_array_alloc>:
ffffffffc0204cf2:	00092797          	auipc	a5,0x92
ffffffffc0204cf6:	bce7b783          	ld	a5,-1074(a5) # ffffffffc02968c0 <current>
ffffffffc0204cfa:	1487b783          	ld	a5,328(a5)
ffffffffc0204cfe:	1141                	addi	sp,sp,-16
ffffffffc0204d00:	e406                	sd	ra,8(sp)
ffffffffc0204d02:	c3a5                	beqz	a5,ffffffffc0204d62 <fd_array_alloc+0x70>
ffffffffc0204d04:	4b98                	lw	a4,16(a5)
ffffffffc0204d06:	04e05e63          	blez	a4,ffffffffc0204d62 <fd_array_alloc+0x70>
ffffffffc0204d0a:	775d                	lui	a4,0xffff7
ffffffffc0204d0c:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204d10:	679c                	ld	a5,8(a5)
ffffffffc0204d12:	02e50863          	beq	a0,a4,ffffffffc0204d42 <fd_array_alloc+0x50>
ffffffffc0204d16:	04700713          	li	a4,71
ffffffffc0204d1a:	04a76263          	bltu	a4,a0,ffffffffc0204d5e <fd_array_alloc+0x6c>
ffffffffc0204d1e:	00351713          	slli	a4,a0,0x3
ffffffffc0204d22:	40a70533          	sub	a0,a4,a0
ffffffffc0204d26:	050e                	slli	a0,a0,0x3
ffffffffc0204d28:	97aa                	add	a5,a5,a0
ffffffffc0204d2a:	4398                	lw	a4,0(a5)
ffffffffc0204d2c:	e71d                	bnez	a4,ffffffffc0204d5a <fd_array_alloc+0x68>
ffffffffc0204d2e:	5b88                	lw	a0,48(a5)
ffffffffc0204d30:	e91d                	bnez	a0,ffffffffc0204d66 <fd_array_alloc+0x74>
ffffffffc0204d32:	4705                	li	a4,1
ffffffffc0204d34:	c398                	sw	a4,0(a5)
ffffffffc0204d36:	0207b423          	sd	zero,40(a5)
ffffffffc0204d3a:	e19c                	sd	a5,0(a1)
ffffffffc0204d3c:	60a2                	ld	ra,8(sp)
ffffffffc0204d3e:	0141                	addi	sp,sp,16
ffffffffc0204d40:	8082                	ret
ffffffffc0204d42:	6685                	lui	a3,0x1
ffffffffc0204d44:	fc068693          	addi	a3,a3,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0204d48:	96be                	add	a3,a3,a5
ffffffffc0204d4a:	4398                	lw	a4,0(a5)
ffffffffc0204d4c:	d36d                	beqz	a4,ffffffffc0204d2e <fd_array_alloc+0x3c>
ffffffffc0204d4e:	03878793          	addi	a5,a5,56
ffffffffc0204d52:	fef69ce3          	bne	a3,a5,ffffffffc0204d4a <fd_array_alloc+0x58>
ffffffffc0204d56:	5529                	li	a0,-22
ffffffffc0204d58:	b7d5                	j	ffffffffc0204d3c <fd_array_alloc+0x4a>
ffffffffc0204d5a:	5545                	li	a0,-15
ffffffffc0204d5c:	b7c5                	j	ffffffffc0204d3c <fd_array_alloc+0x4a>
ffffffffc0204d5e:	5575                	li	a0,-3
ffffffffc0204d60:	bff1                	j	ffffffffc0204d3c <fd_array_alloc+0x4a>
ffffffffc0204d62:	f6fff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>
ffffffffc0204d66:	00008697          	auipc	a3,0x8
ffffffffc0204d6a:	20a68693          	addi	a3,a3,522 # ffffffffc020cf70 <default_pmm_manager+0x188>
ffffffffc0204d6e:	00007617          	auipc	a2,0x7
ffffffffc0204d72:	baa60613          	addi	a2,a2,-1110 # ffffffffc020b918 <commands+0x250>
ffffffffc0204d76:	03b00593          	li	a1,59
ffffffffc0204d7a:	00008517          	auipc	a0,0x8
ffffffffc0204d7e:	1e650513          	addi	a0,a0,486 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204d82:	cacfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204d86 <fd_array_free>:
ffffffffc0204d86:	411c                	lw	a5,0(a0)
ffffffffc0204d88:	1141                	addi	sp,sp,-16
ffffffffc0204d8a:	e022                	sd	s0,0(sp)
ffffffffc0204d8c:	e406                	sd	ra,8(sp)
ffffffffc0204d8e:	4705                	li	a4,1
ffffffffc0204d90:	842a                	mv	s0,a0
ffffffffc0204d92:	04e78063          	beq	a5,a4,ffffffffc0204dd2 <fd_array_free+0x4c>
ffffffffc0204d96:	470d                	li	a4,3
ffffffffc0204d98:	04e79563          	bne	a5,a4,ffffffffc0204de2 <fd_array_free+0x5c>
ffffffffc0204d9c:	591c                	lw	a5,48(a0)
ffffffffc0204d9e:	c38d                	beqz	a5,ffffffffc0204dc0 <fd_array_free+0x3a>
ffffffffc0204da0:	00008697          	auipc	a3,0x8
ffffffffc0204da4:	1d068693          	addi	a3,a3,464 # ffffffffc020cf70 <default_pmm_manager+0x188>
ffffffffc0204da8:	00007617          	auipc	a2,0x7
ffffffffc0204dac:	b7060613          	addi	a2,a2,-1168 # ffffffffc020b918 <commands+0x250>
ffffffffc0204db0:	04500593          	li	a1,69
ffffffffc0204db4:	00008517          	auipc	a0,0x8
ffffffffc0204db8:	1ac50513          	addi	a0,a0,428 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204dbc:	c72fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204dc0:	7408                	ld	a0,40(s0)
ffffffffc0204dc2:	504030ef          	jal	ra,ffffffffc02082c6 <vfs_close>
ffffffffc0204dc6:	60a2                	ld	ra,8(sp)
ffffffffc0204dc8:	00042023          	sw	zero,0(s0)
ffffffffc0204dcc:	6402                	ld	s0,0(sp)
ffffffffc0204dce:	0141                	addi	sp,sp,16
ffffffffc0204dd0:	8082                	ret
ffffffffc0204dd2:	591c                	lw	a5,48(a0)
ffffffffc0204dd4:	f7f1                	bnez	a5,ffffffffc0204da0 <fd_array_free+0x1a>
ffffffffc0204dd6:	60a2                	ld	ra,8(sp)
ffffffffc0204dd8:	00042023          	sw	zero,0(s0)
ffffffffc0204ddc:	6402                	ld	s0,0(sp)
ffffffffc0204dde:	0141                	addi	sp,sp,16
ffffffffc0204de0:	8082                	ret
ffffffffc0204de2:	00008697          	auipc	a3,0x8
ffffffffc0204de6:	1c668693          	addi	a3,a3,454 # ffffffffc020cfa8 <default_pmm_manager+0x1c0>
ffffffffc0204dea:	00007617          	auipc	a2,0x7
ffffffffc0204dee:	b2e60613          	addi	a2,a2,-1234 # ffffffffc020b918 <commands+0x250>
ffffffffc0204df2:	04400593          	li	a1,68
ffffffffc0204df6:	00008517          	auipc	a0,0x8
ffffffffc0204dfa:	16a50513          	addi	a0,a0,362 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204dfe:	c30fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204e02 <fd_array_release>:
ffffffffc0204e02:	4118                	lw	a4,0(a0)
ffffffffc0204e04:	1141                	addi	sp,sp,-16
ffffffffc0204e06:	e406                	sd	ra,8(sp)
ffffffffc0204e08:	4685                	li	a3,1
ffffffffc0204e0a:	3779                	addiw	a4,a4,-2
ffffffffc0204e0c:	04e6e063          	bltu	a3,a4,ffffffffc0204e4c <fd_array_release+0x4a>
ffffffffc0204e10:	5918                	lw	a4,48(a0)
ffffffffc0204e12:	00e05d63          	blez	a4,ffffffffc0204e2c <fd_array_release+0x2a>
ffffffffc0204e16:	fff7069b          	addiw	a3,a4,-1
ffffffffc0204e1a:	d914                	sw	a3,48(a0)
ffffffffc0204e1c:	c681                	beqz	a3,ffffffffc0204e24 <fd_array_release+0x22>
ffffffffc0204e1e:	60a2                	ld	ra,8(sp)
ffffffffc0204e20:	0141                	addi	sp,sp,16
ffffffffc0204e22:	8082                	ret
ffffffffc0204e24:	60a2                	ld	ra,8(sp)
ffffffffc0204e26:	0141                	addi	sp,sp,16
ffffffffc0204e28:	f5fff06f          	j	ffffffffc0204d86 <fd_array_free>
ffffffffc0204e2c:	00008697          	auipc	a3,0x8
ffffffffc0204e30:	1ec68693          	addi	a3,a3,492 # ffffffffc020d018 <default_pmm_manager+0x230>
ffffffffc0204e34:	00007617          	auipc	a2,0x7
ffffffffc0204e38:	ae460613          	addi	a2,a2,-1308 # ffffffffc020b918 <commands+0x250>
ffffffffc0204e3c:	05600593          	li	a1,86
ffffffffc0204e40:	00008517          	auipc	a0,0x8
ffffffffc0204e44:	12050513          	addi	a0,a0,288 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204e48:	be6fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204e4c:	00008697          	auipc	a3,0x8
ffffffffc0204e50:	19468693          	addi	a3,a3,404 # ffffffffc020cfe0 <default_pmm_manager+0x1f8>
ffffffffc0204e54:	00007617          	auipc	a2,0x7
ffffffffc0204e58:	ac460613          	addi	a2,a2,-1340 # ffffffffc020b918 <commands+0x250>
ffffffffc0204e5c:	05500593          	li	a1,85
ffffffffc0204e60:	00008517          	auipc	a0,0x8
ffffffffc0204e64:	10050513          	addi	a0,a0,256 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204e68:	bc6fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204e6c <fd_array_open.part.0>:
ffffffffc0204e6c:	1141                	addi	sp,sp,-16
ffffffffc0204e6e:	00008697          	auipc	a3,0x8
ffffffffc0204e72:	1c268693          	addi	a3,a3,450 # ffffffffc020d030 <default_pmm_manager+0x248>
ffffffffc0204e76:	00007617          	auipc	a2,0x7
ffffffffc0204e7a:	aa260613          	addi	a2,a2,-1374 # ffffffffc020b918 <commands+0x250>
ffffffffc0204e7e:	05f00593          	li	a1,95
ffffffffc0204e82:	00008517          	auipc	a0,0x8
ffffffffc0204e86:	0de50513          	addi	a0,a0,222 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204e8a:	e406                	sd	ra,8(sp)
ffffffffc0204e8c:	ba2fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204e90 <fd_array_init>:
ffffffffc0204e90:	4781                	li	a5,0
ffffffffc0204e92:	04800713          	li	a4,72
ffffffffc0204e96:	cd1c                	sw	a5,24(a0)
ffffffffc0204e98:	02052823          	sw	zero,48(a0)
ffffffffc0204e9c:	00052023          	sw	zero,0(a0)
ffffffffc0204ea0:	2785                	addiw	a5,a5,1
ffffffffc0204ea2:	03850513          	addi	a0,a0,56
ffffffffc0204ea6:	fee798e3          	bne	a5,a4,ffffffffc0204e96 <fd_array_init+0x6>
ffffffffc0204eaa:	8082                	ret

ffffffffc0204eac <fd_array_close>:
ffffffffc0204eac:	4118                	lw	a4,0(a0)
ffffffffc0204eae:	1141                	addi	sp,sp,-16
ffffffffc0204eb0:	e406                	sd	ra,8(sp)
ffffffffc0204eb2:	e022                	sd	s0,0(sp)
ffffffffc0204eb4:	4789                	li	a5,2
ffffffffc0204eb6:	04f71a63          	bne	a4,a5,ffffffffc0204f0a <fd_array_close+0x5e>
ffffffffc0204eba:	591c                	lw	a5,48(a0)
ffffffffc0204ebc:	842a                	mv	s0,a0
ffffffffc0204ebe:	02f05663          	blez	a5,ffffffffc0204eea <fd_array_close+0x3e>
ffffffffc0204ec2:	37fd                	addiw	a5,a5,-1
ffffffffc0204ec4:	470d                	li	a4,3
ffffffffc0204ec6:	c118                	sw	a4,0(a0)
ffffffffc0204ec8:	d91c                	sw	a5,48(a0)
ffffffffc0204eca:	0007871b          	sext.w	a4,a5
ffffffffc0204ece:	c709                	beqz	a4,ffffffffc0204ed8 <fd_array_close+0x2c>
ffffffffc0204ed0:	60a2                	ld	ra,8(sp)
ffffffffc0204ed2:	6402                	ld	s0,0(sp)
ffffffffc0204ed4:	0141                	addi	sp,sp,16
ffffffffc0204ed6:	8082                	ret
ffffffffc0204ed8:	7508                	ld	a0,40(a0)
ffffffffc0204eda:	3ec030ef          	jal	ra,ffffffffc02082c6 <vfs_close>
ffffffffc0204ede:	60a2                	ld	ra,8(sp)
ffffffffc0204ee0:	00042023          	sw	zero,0(s0)
ffffffffc0204ee4:	6402                	ld	s0,0(sp)
ffffffffc0204ee6:	0141                	addi	sp,sp,16
ffffffffc0204ee8:	8082                	ret
ffffffffc0204eea:	00008697          	auipc	a3,0x8
ffffffffc0204eee:	12e68693          	addi	a3,a3,302 # ffffffffc020d018 <default_pmm_manager+0x230>
ffffffffc0204ef2:	00007617          	auipc	a2,0x7
ffffffffc0204ef6:	a2660613          	addi	a2,a2,-1498 # ffffffffc020b918 <commands+0x250>
ffffffffc0204efa:	06800593          	li	a1,104
ffffffffc0204efe:	00008517          	auipc	a0,0x8
ffffffffc0204f02:	06250513          	addi	a0,a0,98 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204f06:	b28fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204f0a:	00008697          	auipc	a3,0x8
ffffffffc0204f0e:	07e68693          	addi	a3,a3,126 # ffffffffc020cf88 <default_pmm_manager+0x1a0>
ffffffffc0204f12:	00007617          	auipc	a2,0x7
ffffffffc0204f16:	a0660613          	addi	a2,a2,-1530 # ffffffffc020b918 <commands+0x250>
ffffffffc0204f1a:	06700593          	li	a1,103
ffffffffc0204f1e:	00008517          	auipc	a0,0x8
ffffffffc0204f22:	04250513          	addi	a0,a0,66 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204f26:	b08fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204f2a <fd_array_dup>:
ffffffffc0204f2a:	7179                	addi	sp,sp,-48
ffffffffc0204f2c:	e84a                	sd	s2,16(sp)
ffffffffc0204f2e:	00052903          	lw	s2,0(a0)
ffffffffc0204f32:	f406                	sd	ra,40(sp)
ffffffffc0204f34:	f022                	sd	s0,32(sp)
ffffffffc0204f36:	ec26                	sd	s1,24(sp)
ffffffffc0204f38:	e44e                	sd	s3,8(sp)
ffffffffc0204f3a:	4785                	li	a5,1
ffffffffc0204f3c:	04f91663          	bne	s2,a5,ffffffffc0204f88 <fd_array_dup+0x5e>
ffffffffc0204f40:	0005a983          	lw	s3,0(a1)
ffffffffc0204f44:	4789                	li	a5,2
ffffffffc0204f46:	04f99163          	bne	s3,a5,ffffffffc0204f88 <fd_array_dup+0x5e>
ffffffffc0204f4a:	7584                	ld	s1,40(a1)
ffffffffc0204f4c:	699c                	ld	a5,16(a1)
ffffffffc0204f4e:	7194                	ld	a3,32(a1)
ffffffffc0204f50:	6598                	ld	a4,8(a1)
ffffffffc0204f52:	842a                	mv	s0,a0
ffffffffc0204f54:	e91c                	sd	a5,16(a0)
ffffffffc0204f56:	f114                	sd	a3,32(a0)
ffffffffc0204f58:	e518                	sd	a4,8(a0)
ffffffffc0204f5a:	8526                	mv	a0,s1
ffffffffc0204f5c:	7ad020ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc0204f60:	8526                	mv	a0,s1
ffffffffc0204f62:	7b3020ef          	jal	ra,ffffffffc0207f14 <inode_open_inc>
ffffffffc0204f66:	401c                	lw	a5,0(s0)
ffffffffc0204f68:	f404                	sd	s1,40(s0)
ffffffffc0204f6a:	03279f63          	bne	a5,s2,ffffffffc0204fa8 <fd_array_dup+0x7e>
ffffffffc0204f6e:	cc8d                	beqz	s1,ffffffffc0204fa8 <fd_array_dup+0x7e>
ffffffffc0204f70:	581c                	lw	a5,48(s0)
ffffffffc0204f72:	01342023          	sw	s3,0(s0)
ffffffffc0204f76:	70a2                	ld	ra,40(sp)
ffffffffc0204f78:	2785                	addiw	a5,a5,1
ffffffffc0204f7a:	d81c                	sw	a5,48(s0)
ffffffffc0204f7c:	7402                	ld	s0,32(sp)
ffffffffc0204f7e:	64e2                	ld	s1,24(sp)
ffffffffc0204f80:	6942                	ld	s2,16(sp)
ffffffffc0204f82:	69a2                	ld	s3,8(sp)
ffffffffc0204f84:	6145                	addi	sp,sp,48
ffffffffc0204f86:	8082                	ret
ffffffffc0204f88:	00008697          	auipc	a3,0x8
ffffffffc0204f8c:	0d868693          	addi	a3,a3,216 # ffffffffc020d060 <default_pmm_manager+0x278>
ffffffffc0204f90:	00007617          	auipc	a2,0x7
ffffffffc0204f94:	98860613          	addi	a2,a2,-1656 # ffffffffc020b918 <commands+0x250>
ffffffffc0204f98:	07300593          	li	a1,115
ffffffffc0204f9c:	00008517          	auipc	a0,0x8
ffffffffc0204fa0:	fc450513          	addi	a0,a0,-60 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0204fa4:	a8afb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204fa8:	ec5ff0ef          	jal	ra,ffffffffc0204e6c <fd_array_open.part.0>

ffffffffc0204fac <file_testfd>:
ffffffffc0204fac:	04700793          	li	a5,71
ffffffffc0204fb0:	04a7e263          	bltu	a5,a0,ffffffffc0204ff4 <file_testfd+0x48>
ffffffffc0204fb4:	00092797          	auipc	a5,0x92
ffffffffc0204fb8:	90c7b783          	ld	a5,-1780(a5) # ffffffffc02968c0 <current>
ffffffffc0204fbc:	1487b783          	ld	a5,328(a5)
ffffffffc0204fc0:	cf85                	beqz	a5,ffffffffc0204ff8 <file_testfd+0x4c>
ffffffffc0204fc2:	4b98                	lw	a4,16(a5)
ffffffffc0204fc4:	02e05a63          	blez	a4,ffffffffc0204ff8 <file_testfd+0x4c>
ffffffffc0204fc8:	6798                	ld	a4,8(a5)
ffffffffc0204fca:	00351793          	slli	a5,a0,0x3
ffffffffc0204fce:	8f89                	sub	a5,a5,a0
ffffffffc0204fd0:	078e                	slli	a5,a5,0x3
ffffffffc0204fd2:	97ba                	add	a5,a5,a4
ffffffffc0204fd4:	4394                	lw	a3,0(a5)
ffffffffc0204fd6:	4709                	li	a4,2
ffffffffc0204fd8:	00e69e63          	bne	a3,a4,ffffffffc0204ff4 <file_testfd+0x48>
ffffffffc0204fdc:	4f98                	lw	a4,24(a5)
ffffffffc0204fde:	00a71b63          	bne	a4,a0,ffffffffc0204ff4 <file_testfd+0x48>
ffffffffc0204fe2:	c199                	beqz	a1,ffffffffc0204fe8 <file_testfd+0x3c>
ffffffffc0204fe4:	6788                	ld	a0,8(a5)
ffffffffc0204fe6:	c901                	beqz	a0,ffffffffc0204ff6 <file_testfd+0x4a>
ffffffffc0204fe8:	4505                	li	a0,1
ffffffffc0204fea:	c611                	beqz	a2,ffffffffc0204ff6 <file_testfd+0x4a>
ffffffffc0204fec:	6b88                	ld	a0,16(a5)
ffffffffc0204fee:	00a03533          	snez	a0,a0
ffffffffc0204ff2:	8082                	ret
ffffffffc0204ff4:	4501                	li	a0,0
ffffffffc0204ff6:	8082                	ret
ffffffffc0204ff8:	1141                	addi	sp,sp,-16
ffffffffc0204ffa:	e406                	sd	ra,8(sp)
ffffffffc0204ffc:	cd5ff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>

ffffffffc0205000 <file_open>:
ffffffffc0205000:	711d                	addi	sp,sp,-96
ffffffffc0205002:	ec86                	sd	ra,88(sp)
ffffffffc0205004:	e8a2                	sd	s0,80(sp)
ffffffffc0205006:	e4a6                	sd	s1,72(sp)
ffffffffc0205008:	e0ca                	sd	s2,64(sp)
ffffffffc020500a:	fc4e                	sd	s3,56(sp)
ffffffffc020500c:	f852                	sd	s4,48(sp)
ffffffffc020500e:	0035f793          	andi	a5,a1,3
ffffffffc0205012:	470d                	li	a4,3
ffffffffc0205014:	0ce78163          	beq	a5,a4,ffffffffc02050d6 <file_open+0xd6>
ffffffffc0205018:	078e                	slli	a5,a5,0x3
ffffffffc020501a:	00008717          	auipc	a4,0x8
ffffffffc020501e:	2b670713          	addi	a4,a4,694 # ffffffffc020d2d0 <CSWTCH.79>
ffffffffc0205022:	892a                	mv	s2,a0
ffffffffc0205024:	00008697          	auipc	a3,0x8
ffffffffc0205028:	29468693          	addi	a3,a3,660 # ffffffffc020d2b8 <CSWTCH.78>
ffffffffc020502c:	755d                	lui	a0,0xffff7
ffffffffc020502e:	96be                	add	a3,a3,a5
ffffffffc0205030:	84ae                	mv	s1,a1
ffffffffc0205032:	97ba                	add	a5,a5,a4
ffffffffc0205034:	858a                	mv	a1,sp
ffffffffc0205036:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020503a:	0006ba03          	ld	s4,0(a3)
ffffffffc020503e:	0007b983          	ld	s3,0(a5)
ffffffffc0205042:	cb1ff0ef          	jal	ra,ffffffffc0204cf2 <fd_array_alloc>
ffffffffc0205046:	842a                	mv	s0,a0
ffffffffc0205048:	c911                	beqz	a0,ffffffffc020505c <file_open+0x5c>
ffffffffc020504a:	60e6                	ld	ra,88(sp)
ffffffffc020504c:	8522                	mv	a0,s0
ffffffffc020504e:	6446                	ld	s0,80(sp)
ffffffffc0205050:	64a6                	ld	s1,72(sp)
ffffffffc0205052:	6906                	ld	s2,64(sp)
ffffffffc0205054:	79e2                	ld	s3,56(sp)
ffffffffc0205056:	7a42                	ld	s4,48(sp)
ffffffffc0205058:	6125                	addi	sp,sp,96
ffffffffc020505a:	8082                	ret
ffffffffc020505c:	0030                	addi	a2,sp,8
ffffffffc020505e:	85a6                	mv	a1,s1
ffffffffc0205060:	854a                	mv	a0,s2
ffffffffc0205062:	0be030ef          	jal	ra,ffffffffc0208120 <vfs_open>
ffffffffc0205066:	842a                	mv	s0,a0
ffffffffc0205068:	e13d                	bnez	a0,ffffffffc02050ce <file_open+0xce>
ffffffffc020506a:	6782                	ld	a5,0(sp)
ffffffffc020506c:	0204f493          	andi	s1,s1,32
ffffffffc0205070:	6422                	ld	s0,8(sp)
ffffffffc0205072:	0207b023          	sd	zero,32(a5)
ffffffffc0205076:	c885                	beqz	s1,ffffffffc02050a6 <file_open+0xa6>
ffffffffc0205078:	c03d                	beqz	s0,ffffffffc02050de <file_open+0xde>
ffffffffc020507a:	783c                	ld	a5,112(s0)
ffffffffc020507c:	c3ad                	beqz	a5,ffffffffc02050de <file_open+0xde>
ffffffffc020507e:	779c                	ld	a5,40(a5)
ffffffffc0205080:	cfb9                	beqz	a5,ffffffffc02050de <file_open+0xde>
ffffffffc0205082:	8522                	mv	a0,s0
ffffffffc0205084:	00008597          	auipc	a1,0x8
ffffffffc0205088:	06458593          	addi	a1,a1,100 # ffffffffc020d0e8 <default_pmm_manager+0x300>
ffffffffc020508c:	695020ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0205090:	783c                	ld	a5,112(s0)
ffffffffc0205092:	6522                	ld	a0,8(sp)
ffffffffc0205094:	080c                	addi	a1,sp,16
ffffffffc0205096:	779c                	ld	a5,40(a5)
ffffffffc0205098:	9782                	jalr	a5
ffffffffc020509a:	842a                	mv	s0,a0
ffffffffc020509c:	e515                	bnez	a0,ffffffffc02050c8 <file_open+0xc8>
ffffffffc020509e:	6782                	ld	a5,0(sp)
ffffffffc02050a0:	7722                	ld	a4,40(sp)
ffffffffc02050a2:	6422                	ld	s0,8(sp)
ffffffffc02050a4:	f398                	sd	a4,32(a5)
ffffffffc02050a6:	4394                	lw	a3,0(a5)
ffffffffc02050a8:	f780                	sd	s0,40(a5)
ffffffffc02050aa:	0147b423          	sd	s4,8(a5)
ffffffffc02050ae:	0137b823          	sd	s3,16(a5)
ffffffffc02050b2:	4705                	li	a4,1
ffffffffc02050b4:	02e69363          	bne	a3,a4,ffffffffc02050da <file_open+0xda>
ffffffffc02050b8:	c00d                	beqz	s0,ffffffffc02050da <file_open+0xda>
ffffffffc02050ba:	5b98                	lw	a4,48(a5)
ffffffffc02050bc:	4689                	li	a3,2
ffffffffc02050be:	4f80                	lw	s0,24(a5)
ffffffffc02050c0:	2705                	addiw	a4,a4,1
ffffffffc02050c2:	c394                	sw	a3,0(a5)
ffffffffc02050c4:	db98                	sw	a4,48(a5)
ffffffffc02050c6:	b751                	j	ffffffffc020504a <file_open+0x4a>
ffffffffc02050c8:	6522                	ld	a0,8(sp)
ffffffffc02050ca:	1fc030ef          	jal	ra,ffffffffc02082c6 <vfs_close>
ffffffffc02050ce:	6502                	ld	a0,0(sp)
ffffffffc02050d0:	cb7ff0ef          	jal	ra,ffffffffc0204d86 <fd_array_free>
ffffffffc02050d4:	bf9d                	j	ffffffffc020504a <file_open+0x4a>
ffffffffc02050d6:	5475                	li	s0,-3
ffffffffc02050d8:	bf8d                	j	ffffffffc020504a <file_open+0x4a>
ffffffffc02050da:	d93ff0ef          	jal	ra,ffffffffc0204e6c <fd_array_open.part.0>
ffffffffc02050de:	00008697          	auipc	a3,0x8
ffffffffc02050e2:	fba68693          	addi	a3,a3,-70 # ffffffffc020d098 <default_pmm_manager+0x2b0>
ffffffffc02050e6:	00007617          	auipc	a2,0x7
ffffffffc02050ea:	83260613          	addi	a2,a2,-1998 # ffffffffc020b918 <commands+0x250>
ffffffffc02050ee:	0b500593          	li	a1,181
ffffffffc02050f2:	00008517          	auipc	a0,0x8
ffffffffc02050f6:	e6e50513          	addi	a0,a0,-402 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc02050fa:	934fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02050fe <file_close>:
ffffffffc02050fe:	04700713          	li	a4,71
ffffffffc0205102:	04a76563          	bltu	a4,a0,ffffffffc020514c <file_close+0x4e>
ffffffffc0205106:	00091717          	auipc	a4,0x91
ffffffffc020510a:	7ba73703          	ld	a4,1978(a4) # ffffffffc02968c0 <current>
ffffffffc020510e:	14873703          	ld	a4,328(a4)
ffffffffc0205112:	1141                	addi	sp,sp,-16
ffffffffc0205114:	e406                	sd	ra,8(sp)
ffffffffc0205116:	cf0d                	beqz	a4,ffffffffc0205150 <file_close+0x52>
ffffffffc0205118:	4b14                	lw	a3,16(a4)
ffffffffc020511a:	02d05b63          	blez	a3,ffffffffc0205150 <file_close+0x52>
ffffffffc020511e:	6718                	ld	a4,8(a4)
ffffffffc0205120:	87aa                	mv	a5,a0
ffffffffc0205122:	050e                	slli	a0,a0,0x3
ffffffffc0205124:	8d1d                	sub	a0,a0,a5
ffffffffc0205126:	050e                	slli	a0,a0,0x3
ffffffffc0205128:	953a                	add	a0,a0,a4
ffffffffc020512a:	4114                	lw	a3,0(a0)
ffffffffc020512c:	4709                	li	a4,2
ffffffffc020512e:	00e69b63          	bne	a3,a4,ffffffffc0205144 <file_close+0x46>
ffffffffc0205132:	4d18                	lw	a4,24(a0)
ffffffffc0205134:	00f71863          	bne	a4,a5,ffffffffc0205144 <file_close+0x46>
ffffffffc0205138:	d75ff0ef          	jal	ra,ffffffffc0204eac <fd_array_close>
ffffffffc020513c:	60a2                	ld	ra,8(sp)
ffffffffc020513e:	4501                	li	a0,0
ffffffffc0205140:	0141                	addi	sp,sp,16
ffffffffc0205142:	8082                	ret
ffffffffc0205144:	60a2                	ld	ra,8(sp)
ffffffffc0205146:	5575                	li	a0,-3
ffffffffc0205148:	0141                	addi	sp,sp,16
ffffffffc020514a:	8082                	ret
ffffffffc020514c:	5575                	li	a0,-3
ffffffffc020514e:	8082                	ret
ffffffffc0205150:	b81ff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>

ffffffffc0205154 <file_read>:
ffffffffc0205154:	715d                	addi	sp,sp,-80
ffffffffc0205156:	e486                	sd	ra,72(sp)
ffffffffc0205158:	e0a2                	sd	s0,64(sp)
ffffffffc020515a:	fc26                	sd	s1,56(sp)
ffffffffc020515c:	f84a                	sd	s2,48(sp)
ffffffffc020515e:	f44e                	sd	s3,40(sp)
ffffffffc0205160:	f052                	sd	s4,32(sp)
ffffffffc0205162:	0006b023          	sd	zero,0(a3)
ffffffffc0205166:	04700793          	li	a5,71
ffffffffc020516a:	0aa7e463          	bltu	a5,a0,ffffffffc0205212 <file_read+0xbe>
ffffffffc020516e:	00091797          	auipc	a5,0x91
ffffffffc0205172:	7527b783          	ld	a5,1874(a5) # ffffffffc02968c0 <current>
ffffffffc0205176:	1487b783          	ld	a5,328(a5)
ffffffffc020517a:	cfd1                	beqz	a5,ffffffffc0205216 <file_read+0xc2>
ffffffffc020517c:	4b98                	lw	a4,16(a5)
ffffffffc020517e:	08e05c63          	blez	a4,ffffffffc0205216 <file_read+0xc2>
ffffffffc0205182:	6780                	ld	s0,8(a5)
ffffffffc0205184:	00351793          	slli	a5,a0,0x3
ffffffffc0205188:	8f89                	sub	a5,a5,a0
ffffffffc020518a:	078e                	slli	a5,a5,0x3
ffffffffc020518c:	943e                	add	s0,s0,a5
ffffffffc020518e:	00042983          	lw	s3,0(s0)
ffffffffc0205192:	4789                	li	a5,2
ffffffffc0205194:	06f99f63          	bne	s3,a5,ffffffffc0205212 <file_read+0xbe>
ffffffffc0205198:	4c1c                	lw	a5,24(s0)
ffffffffc020519a:	06a79c63          	bne	a5,a0,ffffffffc0205212 <file_read+0xbe>
ffffffffc020519e:	641c                	ld	a5,8(s0)
ffffffffc02051a0:	cbad                	beqz	a5,ffffffffc0205212 <file_read+0xbe>
ffffffffc02051a2:	581c                	lw	a5,48(s0)
ffffffffc02051a4:	8a36                	mv	s4,a3
ffffffffc02051a6:	7014                	ld	a3,32(s0)
ffffffffc02051a8:	2785                	addiw	a5,a5,1
ffffffffc02051aa:	850a                	mv	a0,sp
ffffffffc02051ac:	d81c                	sw	a5,48(s0)
ffffffffc02051ae:	57e000ef          	jal	ra,ffffffffc020572c <iobuf_init>
ffffffffc02051b2:	02843903          	ld	s2,40(s0)
ffffffffc02051b6:	84aa                	mv	s1,a0
ffffffffc02051b8:	06090163          	beqz	s2,ffffffffc020521a <file_read+0xc6>
ffffffffc02051bc:	07093783          	ld	a5,112(s2)
ffffffffc02051c0:	cfa9                	beqz	a5,ffffffffc020521a <file_read+0xc6>
ffffffffc02051c2:	6f9c                	ld	a5,24(a5)
ffffffffc02051c4:	cbb9                	beqz	a5,ffffffffc020521a <file_read+0xc6>
ffffffffc02051c6:	00008597          	auipc	a1,0x8
ffffffffc02051ca:	f7a58593          	addi	a1,a1,-134 # ffffffffc020d140 <default_pmm_manager+0x358>
ffffffffc02051ce:	854a                	mv	a0,s2
ffffffffc02051d0:	551020ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02051d4:	07093783          	ld	a5,112(s2)
ffffffffc02051d8:	7408                	ld	a0,40(s0)
ffffffffc02051da:	85a6                	mv	a1,s1
ffffffffc02051dc:	6f9c                	ld	a5,24(a5)
ffffffffc02051de:	9782                	jalr	a5
ffffffffc02051e0:	689c                	ld	a5,16(s1)
ffffffffc02051e2:	6c94                	ld	a3,24(s1)
ffffffffc02051e4:	4018                	lw	a4,0(s0)
ffffffffc02051e6:	84aa                	mv	s1,a0
ffffffffc02051e8:	8f95                	sub	a5,a5,a3
ffffffffc02051ea:	03370063          	beq	a4,s3,ffffffffc020520a <file_read+0xb6>
ffffffffc02051ee:	00fa3023          	sd	a5,0(s4)
ffffffffc02051f2:	8522                	mv	a0,s0
ffffffffc02051f4:	c0fff0ef          	jal	ra,ffffffffc0204e02 <fd_array_release>
ffffffffc02051f8:	60a6                	ld	ra,72(sp)
ffffffffc02051fa:	6406                	ld	s0,64(sp)
ffffffffc02051fc:	7942                	ld	s2,48(sp)
ffffffffc02051fe:	79a2                	ld	s3,40(sp)
ffffffffc0205200:	7a02                	ld	s4,32(sp)
ffffffffc0205202:	8526                	mv	a0,s1
ffffffffc0205204:	74e2                	ld	s1,56(sp)
ffffffffc0205206:	6161                	addi	sp,sp,80
ffffffffc0205208:	8082                	ret
ffffffffc020520a:	7018                	ld	a4,32(s0)
ffffffffc020520c:	973e                	add	a4,a4,a5
ffffffffc020520e:	f018                	sd	a4,32(s0)
ffffffffc0205210:	bff9                	j	ffffffffc02051ee <file_read+0x9a>
ffffffffc0205212:	54f5                	li	s1,-3
ffffffffc0205214:	b7d5                	j	ffffffffc02051f8 <file_read+0xa4>
ffffffffc0205216:	abbff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>
ffffffffc020521a:	00008697          	auipc	a3,0x8
ffffffffc020521e:	ed668693          	addi	a3,a3,-298 # ffffffffc020d0f0 <default_pmm_manager+0x308>
ffffffffc0205222:	00006617          	auipc	a2,0x6
ffffffffc0205226:	6f660613          	addi	a2,a2,1782 # ffffffffc020b918 <commands+0x250>
ffffffffc020522a:	0de00593          	li	a1,222
ffffffffc020522e:	00008517          	auipc	a0,0x8
ffffffffc0205232:	d3250513          	addi	a0,a0,-718 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc0205236:	ff9fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020523a <file_write>:
ffffffffc020523a:	715d                	addi	sp,sp,-80
ffffffffc020523c:	e486                	sd	ra,72(sp)
ffffffffc020523e:	e0a2                	sd	s0,64(sp)
ffffffffc0205240:	fc26                	sd	s1,56(sp)
ffffffffc0205242:	f84a                	sd	s2,48(sp)
ffffffffc0205244:	f44e                	sd	s3,40(sp)
ffffffffc0205246:	f052                	sd	s4,32(sp)
ffffffffc0205248:	0006b023          	sd	zero,0(a3)
ffffffffc020524c:	04700793          	li	a5,71
ffffffffc0205250:	0aa7e463          	bltu	a5,a0,ffffffffc02052f8 <file_write+0xbe>
ffffffffc0205254:	00091797          	auipc	a5,0x91
ffffffffc0205258:	66c7b783          	ld	a5,1644(a5) # ffffffffc02968c0 <current>
ffffffffc020525c:	1487b783          	ld	a5,328(a5)
ffffffffc0205260:	cfd1                	beqz	a5,ffffffffc02052fc <file_write+0xc2>
ffffffffc0205262:	4b98                	lw	a4,16(a5)
ffffffffc0205264:	08e05c63          	blez	a4,ffffffffc02052fc <file_write+0xc2>
ffffffffc0205268:	6780                	ld	s0,8(a5)
ffffffffc020526a:	00351793          	slli	a5,a0,0x3
ffffffffc020526e:	8f89                	sub	a5,a5,a0
ffffffffc0205270:	078e                	slli	a5,a5,0x3
ffffffffc0205272:	943e                	add	s0,s0,a5
ffffffffc0205274:	00042983          	lw	s3,0(s0)
ffffffffc0205278:	4789                	li	a5,2
ffffffffc020527a:	06f99f63          	bne	s3,a5,ffffffffc02052f8 <file_write+0xbe>
ffffffffc020527e:	4c1c                	lw	a5,24(s0)
ffffffffc0205280:	06a79c63          	bne	a5,a0,ffffffffc02052f8 <file_write+0xbe>
ffffffffc0205284:	681c                	ld	a5,16(s0)
ffffffffc0205286:	cbad                	beqz	a5,ffffffffc02052f8 <file_write+0xbe>
ffffffffc0205288:	581c                	lw	a5,48(s0)
ffffffffc020528a:	8a36                	mv	s4,a3
ffffffffc020528c:	7014                	ld	a3,32(s0)
ffffffffc020528e:	2785                	addiw	a5,a5,1
ffffffffc0205290:	850a                	mv	a0,sp
ffffffffc0205292:	d81c                	sw	a5,48(s0)
ffffffffc0205294:	498000ef          	jal	ra,ffffffffc020572c <iobuf_init>
ffffffffc0205298:	02843903          	ld	s2,40(s0)
ffffffffc020529c:	84aa                	mv	s1,a0
ffffffffc020529e:	06090163          	beqz	s2,ffffffffc0205300 <file_write+0xc6>
ffffffffc02052a2:	07093783          	ld	a5,112(s2)
ffffffffc02052a6:	cfa9                	beqz	a5,ffffffffc0205300 <file_write+0xc6>
ffffffffc02052a8:	739c                	ld	a5,32(a5)
ffffffffc02052aa:	cbb9                	beqz	a5,ffffffffc0205300 <file_write+0xc6>
ffffffffc02052ac:	00008597          	auipc	a1,0x8
ffffffffc02052b0:	eec58593          	addi	a1,a1,-276 # ffffffffc020d198 <default_pmm_manager+0x3b0>
ffffffffc02052b4:	854a                	mv	a0,s2
ffffffffc02052b6:	46b020ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02052ba:	07093783          	ld	a5,112(s2)
ffffffffc02052be:	7408                	ld	a0,40(s0)
ffffffffc02052c0:	85a6                	mv	a1,s1
ffffffffc02052c2:	739c                	ld	a5,32(a5)
ffffffffc02052c4:	9782                	jalr	a5
ffffffffc02052c6:	689c                	ld	a5,16(s1)
ffffffffc02052c8:	6c94                	ld	a3,24(s1)
ffffffffc02052ca:	4018                	lw	a4,0(s0)
ffffffffc02052cc:	84aa                	mv	s1,a0
ffffffffc02052ce:	8f95                	sub	a5,a5,a3
ffffffffc02052d0:	03370063          	beq	a4,s3,ffffffffc02052f0 <file_write+0xb6>
ffffffffc02052d4:	00fa3023          	sd	a5,0(s4)
ffffffffc02052d8:	8522                	mv	a0,s0
ffffffffc02052da:	b29ff0ef          	jal	ra,ffffffffc0204e02 <fd_array_release>
ffffffffc02052de:	60a6                	ld	ra,72(sp)
ffffffffc02052e0:	6406                	ld	s0,64(sp)
ffffffffc02052e2:	7942                	ld	s2,48(sp)
ffffffffc02052e4:	79a2                	ld	s3,40(sp)
ffffffffc02052e6:	7a02                	ld	s4,32(sp)
ffffffffc02052e8:	8526                	mv	a0,s1
ffffffffc02052ea:	74e2                	ld	s1,56(sp)
ffffffffc02052ec:	6161                	addi	sp,sp,80
ffffffffc02052ee:	8082                	ret
ffffffffc02052f0:	7018                	ld	a4,32(s0)
ffffffffc02052f2:	973e                	add	a4,a4,a5
ffffffffc02052f4:	f018                	sd	a4,32(s0)
ffffffffc02052f6:	bff9                	j	ffffffffc02052d4 <file_write+0x9a>
ffffffffc02052f8:	54f5                	li	s1,-3
ffffffffc02052fa:	b7d5                	j	ffffffffc02052de <file_write+0xa4>
ffffffffc02052fc:	9d5ff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>
ffffffffc0205300:	00008697          	auipc	a3,0x8
ffffffffc0205304:	e4868693          	addi	a3,a3,-440 # ffffffffc020d148 <default_pmm_manager+0x360>
ffffffffc0205308:	00006617          	auipc	a2,0x6
ffffffffc020530c:	61060613          	addi	a2,a2,1552 # ffffffffc020b918 <commands+0x250>
ffffffffc0205310:	0f800593          	li	a1,248
ffffffffc0205314:	00008517          	auipc	a0,0x8
ffffffffc0205318:	c4c50513          	addi	a0,a0,-948 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc020531c:	f13fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205320 <file_seek>:
ffffffffc0205320:	7139                	addi	sp,sp,-64
ffffffffc0205322:	fc06                	sd	ra,56(sp)
ffffffffc0205324:	f822                	sd	s0,48(sp)
ffffffffc0205326:	f426                	sd	s1,40(sp)
ffffffffc0205328:	f04a                	sd	s2,32(sp)
ffffffffc020532a:	04700793          	li	a5,71
ffffffffc020532e:	08a7e863          	bltu	a5,a0,ffffffffc02053be <file_seek+0x9e>
ffffffffc0205332:	00091797          	auipc	a5,0x91
ffffffffc0205336:	58e7b783          	ld	a5,1422(a5) # ffffffffc02968c0 <current>
ffffffffc020533a:	1487b783          	ld	a5,328(a5)
ffffffffc020533e:	cfdd                	beqz	a5,ffffffffc02053fc <file_seek+0xdc>
ffffffffc0205340:	4b98                	lw	a4,16(a5)
ffffffffc0205342:	0ae05d63          	blez	a4,ffffffffc02053fc <file_seek+0xdc>
ffffffffc0205346:	6780                	ld	s0,8(a5)
ffffffffc0205348:	00351793          	slli	a5,a0,0x3
ffffffffc020534c:	8f89                	sub	a5,a5,a0
ffffffffc020534e:	078e                	slli	a5,a5,0x3
ffffffffc0205350:	943e                	add	s0,s0,a5
ffffffffc0205352:	4018                	lw	a4,0(s0)
ffffffffc0205354:	4789                	li	a5,2
ffffffffc0205356:	06f71463          	bne	a4,a5,ffffffffc02053be <file_seek+0x9e>
ffffffffc020535a:	4c1c                	lw	a5,24(s0)
ffffffffc020535c:	06a79163          	bne	a5,a0,ffffffffc02053be <file_seek+0x9e>
ffffffffc0205360:	581c                	lw	a5,48(s0)
ffffffffc0205362:	4685                	li	a3,1
ffffffffc0205364:	892e                	mv	s2,a1
ffffffffc0205366:	2785                	addiw	a5,a5,1
ffffffffc0205368:	d81c                	sw	a5,48(s0)
ffffffffc020536a:	02d60063          	beq	a2,a3,ffffffffc020538a <file_seek+0x6a>
ffffffffc020536e:	06e60063          	beq	a2,a4,ffffffffc02053ce <file_seek+0xae>
ffffffffc0205372:	54f5                	li	s1,-3
ffffffffc0205374:	ce11                	beqz	a2,ffffffffc0205390 <file_seek+0x70>
ffffffffc0205376:	8522                	mv	a0,s0
ffffffffc0205378:	a8bff0ef          	jal	ra,ffffffffc0204e02 <fd_array_release>
ffffffffc020537c:	70e2                	ld	ra,56(sp)
ffffffffc020537e:	7442                	ld	s0,48(sp)
ffffffffc0205380:	7902                	ld	s2,32(sp)
ffffffffc0205382:	8526                	mv	a0,s1
ffffffffc0205384:	74a2                	ld	s1,40(sp)
ffffffffc0205386:	6121                	addi	sp,sp,64
ffffffffc0205388:	8082                	ret
ffffffffc020538a:	701c                	ld	a5,32(s0)
ffffffffc020538c:	00f58933          	add	s2,a1,a5
ffffffffc0205390:	7404                	ld	s1,40(s0)
ffffffffc0205392:	c4bd                	beqz	s1,ffffffffc0205400 <file_seek+0xe0>
ffffffffc0205394:	78bc                	ld	a5,112(s1)
ffffffffc0205396:	c7ad                	beqz	a5,ffffffffc0205400 <file_seek+0xe0>
ffffffffc0205398:	6fbc                	ld	a5,88(a5)
ffffffffc020539a:	c3bd                	beqz	a5,ffffffffc0205400 <file_seek+0xe0>
ffffffffc020539c:	8526                	mv	a0,s1
ffffffffc020539e:	00008597          	auipc	a1,0x8
ffffffffc02053a2:	e5258593          	addi	a1,a1,-430 # ffffffffc020d1f0 <default_pmm_manager+0x408>
ffffffffc02053a6:	37b020ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02053aa:	78bc                	ld	a5,112(s1)
ffffffffc02053ac:	7408                	ld	a0,40(s0)
ffffffffc02053ae:	85ca                	mv	a1,s2
ffffffffc02053b0:	6fbc                	ld	a5,88(a5)
ffffffffc02053b2:	9782                	jalr	a5
ffffffffc02053b4:	84aa                	mv	s1,a0
ffffffffc02053b6:	f161                	bnez	a0,ffffffffc0205376 <file_seek+0x56>
ffffffffc02053b8:	03243023          	sd	s2,32(s0)
ffffffffc02053bc:	bf6d                	j	ffffffffc0205376 <file_seek+0x56>
ffffffffc02053be:	70e2                	ld	ra,56(sp)
ffffffffc02053c0:	7442                	ld	s0,48(sp)
ffffffffc02053c2:	54f5                	li	s1,-3
ffffffffc02053c4:	7902                	ld	s2,32(sp)
ffffffffc02053c6:	8526                	mv	a0,s1
ffffffffc02053c8:	74a2                	ld	s1,40(sp)
ffffffffc02053ca:	6121                	addi	sp,sp,64
ffffffffc02053cc:	8082                	ret
ffffffffc02053ce:	7404                	ld	s1,40(s0)
ffffffffc02053d0:	c8a1                	beqz	s1,ffffffffc0205420 <file_seek+0x100>
ffffffffc02053d2:	78bc                	ld	a5,112(s1)
ffffffffc02053d4:	c7b1                	beqz	a5,ffffffffc0205420 <file_seek+0x100>
ffffffffc02053d6:	779c                	ld	a5,40(a5)
ffffffffc02053d8:	c7a1                	beqz	a5,ffffffffc0205420 <file_seek+0x100>
ffffffffc02053da:	8526                	mv	a0,s1
ffffffffc02053dc:	00008597          	auipc	a1,0x8
ffffffffc02053e0:	d0c58593          	addi	a1,a1,-756 # ffffffffc020d0e8 <default_pmm_manager+0x300>
ffffffffc02053e4:	33d020ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02053e8:	78bc                	ld	a5,112(s1)
ffffffffc02053ea:	7408                	ld	a0,40(s0)
ffffffffc02053ec:	858a                	mv	a1,sp
ffffffffc02053ee:	779c                	ld	a5,40(a5)
ffffffffc02053f0:	9782                	jalr	a5
ffffffffc02053f2:	84aa                	mv	s1,a0
ffffffffc02053f4:	f149                	bnez	a0,ffffffffc0205376 <file_seek+0x56>
ffffffffc02053f6:	67e2                	ld	a5,24(sp)
ffffffffc02053f8:	993e                	add	s2,s2,a5
ffffffffc02053fa:	bf59                	j	ffffffffc0205390 <file_seek+0x70>
ffffffffc02053fc:	8d5ff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>
ffffffffc0205400:	00008697          	auipc	a3,0x8
ffffffffc0205404:	da068693          	addi	a3,a3,-608 # ffffffffc020d1a0 <default_pmm_manager+0x3b8>
ffffffffc0205408:	00006617          	auipc	a2,0x6
ffffffffc020540c:	51060613          	addi	a2,a2,1296 # ffffffffc020b918 <commands+0x250>
ffffffffc0205410:	11a00593          	li	a1,282
ffffffffc0205414:	00008517          	auipc	a0,0x8
ffffffffc0205418:	b4c50513          	addi	a0,a0,-1204 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc020541c:	e13fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205420:	00008697          	auipc	a3,0x8
ffffffffc0205424:	c7868693          	addi	a3,a3,-904 # ffffffffc020d098 <default_pmm_manager+0x2b0>
ffffffffc0205428:	00006617          	auipc	a2,0x6
ffffffffc020542c:	4f060613          	addi	a2,a2,1264 # ffffffffc020b918 <commands+0x250>
ffffffffc0205430:	11200593          	li	a1,274
ffffffffc0205434:	00008517          	auipc	a0,0x8
ffffffffc0205438:	b2c50513          	addi	a0,a0,-1236 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc020543c:	df3fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205440 <file_fstat>:
ffffffffc0205440:	1101                	addi	sp,sp,-32
ffffffffc0205442:	ec06                	sd	ra,24(sp)
ffffffffc0205444:	e822                	sd	s0,16(sp)
ffffffffc0205446:	e426                	sd	s1,8(sp)
ffffffffc0205448:	e04a                	sd	s2,0(sp)
ffffffffc020544a:	04700793          	li	a5,71
ffffffffc020544e:	06a7ef63          	bltu	a5,a0,ffffffffc02054cc <file_fstat+0x8c>
ffffffffc0205452:	00091797          	auipc	a5,0x91
ffffffffc0205456:	46e7b783          	ld	a5,1134(a5) # ffffffffc02968c0 <current>
ffffffffc020545a:	1487b783          	ld	a5,328(a5)
ffffffffc020545e:	cfd9                	beqz	a5,ffffffffc02054fc <file_fstat+0xbc>
ffffffffc0205460:	4b98                	lw	a4,16(a5)
ffffffffc0205462:	08e05d63          	blez	a4,ffffffffc02054fc <file_fstat+0xbc>
ffffffffc0205466:	6780                	ld	s0,8(a5)
ffffffffc0205468:	00351793          	slli	a5,a0,0x3
ffffffffc020546c:	8f89                	sub	a5,a5,a0
ffffffffc020546e:	078e                	slli	a5,a5,0x3
ffffffffc0205470:	943e                	add	s0,s0,a5
ffffffffc0205472:	4018                	lw	a4,0(s0)
ffffffffc0205474:	4789                	li	a5,2
ffffffffc0205476:	04f71b63          	bne	a4,a5,ffffffffc02054cc <file_fstat+0x8c>
ffffffffc020547a:	4c1c                	lw	a5,24(s0)
ffffffffc020547c:	04a79863          	bne	a5,a0,ffffffffc02054cc <file_fstat+0x8c>
ffffffffc0205480:	581c                	lw	a5,48(s0)
ffffffffc0205482:	02843903          	ld	s2,40(s0)
ffffffffc0205486:	2785                	addiw	a5,a5,1
ffffffffc0205488:	d81c                	sw	a5,48(s0)
ffffffffc020548a:	04090963          	beqz	s2,ffffffffc02054dc <file_fstat+0x9c>
ffffffffc020548e:	07093783          	ld	a5,112(s2)
ffffffffc0205492:	c7a9                	beqz	a5,ffffffffc02054dc <file_fstat+0x9c>
ffffffffc0205494:	779c                	ld	a5,40(a5)
ffffffffc0205496:	c3b9                	beqz	a5,ffffffffc02054dc <file_fstat+0x9c>
ffffffffc0205498:	84ae                	mv	s1,a1
ffffffffc020549a:	854a                	mv	a0,s2
ffffffffc020549c:	00008597          	auipc	a1,0x8
ffffffffc02054a0:	c4c58593          	addi	a1,a1,-948 # ffffffffc020d0e8 <default_pmm_manager+0x300>
ffffffffc02054a4:	27d020ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02054a8:	07093783          	ld	a5,112(s2)
ffffffffc02054ac:	7408                	ld	a0,40(s0)
ffffffffc02054ae:	85a6                	mv	a1,s1
ffffffffc02054b0:	779c                	ld	a5,40(a5)
ffffffffc02054b2:	9782                	jalr	a5
ffffffffc02054b4:	87aa                	mv	a5,a0
ffffffffc02054b6:	8522                	mv	a0,s0
ffffffffc02054b8:	843e                	mv	s0,a5
ffffffffc02054ba:	949ff0ef          	jal	ra,ffffffffc0204e02 <fd_array_release>
ffffffffc02054be:	60e2                	ld	ra,24(sp)
ffffffffc02054c0:	8522                	mv	a0,s0
ffffffffc02054c2:	6442                	ld	s0,16(sp)
ffffffffc02054c4:	64a2                	ld	s1,8(sp)
ffffffffc02054c6:	6902                	ld	s2,0(sp)
ffffffffc02054c8:	6105                	addi	sp,sp,32
ffffffffc02054ca:	8082                	ret
ffffffffc02054cc:	5475                	li	s0,-3
ffffffffc02054ce:	60e2                	ld	ra,24(sp)
ffffffffc02054d0:	8522                	mv	a0,s0
ffffffffc02054d2:	6442                	ld	s0,16(sp)
ffffffffc02054d4:	64a2                	ld	s1,8(sp)
ffffffffc02054d6:	6902                	ld	s2,0(sp)
ffffffffc02054d8:	6105                	addi	sp,sp,32
ffffffffc02054da:	8082                	ret
ffffffffc02054dc:	00008697          	auipc	a3,0x8
ffffffffc02054e0:	bbc68693          	addi	a3,a3,-1092 # ffffffffc020d098 <default_pmm_manager+0x2b0>
ffffffffc02054e4:	00006617          	auipc	a2,0x6
ffffffffc02054e8:	43460613          	addi	a2,a2,1076 # ffffffffc020b918 <commands+0x250>
ffffffffc02054ec:	12c00593          	li	a1,300
ffffffffc02054f0:	00008517          	auipc	a0,0x8
ffffffffc02054f4:	a7050513          	addi	a0,a0,-1424 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc02054f8:	d37fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02054fc:	fd4ff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>

ffffffffc0205500 <file_fsync>:
ffffffffc0205500:	1101                	addi	sp,sp,-32
ffffffffc0205502:	ec06                	sd	ra,24(sp)
ffffffffc0205504:	e822                	sd	s0,16(sp)
ffffffffc0205506:	e426                	sd	s1,8(sp)
ffffffffc0205508:	04700793          	li	a5,71
ffffffffc020550c:	06a7e863          	bltu	a5,a0,ffffffffc020557c <file_fsync+0x7c>
ffffffffc0205510:	00091797          	auipc	a5,0x91
ffffffffc0205514:	3b07b783          	ld	a5,944(a5) # ffffffffc02968c0 <current>
ffffffffc0205518:	1487b783          	ld	a5,328(a5)
ffffffffc020551c:	c7d9                	beqz	a5,ffffffffc02055aa <file_fsync+0xaa>
ffffffffc020551e:	4b98                	lw	a4,16(a5)
ffffffffc0205520:	08e05563          	blez	a4,ffffffffc02055aa <file_fsync+0xaa>
ffffffffc0205524:	6780                	ld	s0,8(a5)
ffffffffc0205526:	00351793          	slli	a5,a0,0x3
ffffffffc020552a:	8f89                	sub	a5,a5,a0
ffffffffc020552c:	078e                	slli	a5,a5,0x3
ffffffffc020552e:	943e                	add	s0,s0,a5
ffffffffc0205530:	4018                	lw	a4,0(s0)
ffffffffc0205532:	4789                	li	a5,2
ffffffffc0205534:	04f71463          	bne	a4,a5,ffffffffc020557c <file_fsync+0x7c>
ffffffffc0205538:	4c1c                	lw	a5,24(s0)
ffffffffc020553a:	04a79163          	bne	a5,a0,ffffffffc020557c <file_fsync+0x7c>
ffffffffc020553e:	581c                	lw	a5,48(s0)
ffffffffc0205540:	7404                	ld	s1,40(s0)
ffffffffc0205542:	2785                	addiw	a5,a5,1
ffffffffc0205544:	d81c                	sw	a5,48(s0)
ffffffffc0205546:	c0b1                	beqz	s1,ffffffffc020558a <file_fsync+0x8a>
ffffffffc0205548:	78bc                	ld	a5,112(s1)
ffffffffc020554a:	c3a1                	beqz	a5,ffffffffc020558a <file_fsync+0x8a>
ffffffffc020554c:	7b9c                	ld	a5,48(a5)
ffffffffc020554e:	cf95                	beqz	a5,ffffffffc020558a <file_fsync+0x8a>
ffffffffc0205550:	00008597          	auipc	a1,0x8
ffffffffc0205554:	cf858593          	addi	a1,a1,-776 # ffffffffc020d248 <default_pmm_manager+0x460>
ffffffffc0205558:	8526                	mv	a0,s1
ffffffffc020555a:	1c7020ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc020555e:	78bc                	ld	a5,112(s1)
ffffffffc0205560:	7408                	ld	a0,40(s0)
ffffffffc0205562:	7b9c                	ld	a5,48(a5)
ffffffffc0205564:	9782                	jalr	a5
ffffffffc0205566:	87aa                	mv	a5,a0
ffffffffc0205568:	8522                	mv	a0,s0
ffffffffc020556a:	843e                	mv	s0,a5
ffffffffc020556c:	897ff0ef          	jal	ra,ffffffffc0204e02 <fd_array_release>
ffffffffc0205570:	60e2                	ld	ra,24(sp)
ffffffffc0205572:	8522                	mv	a0,s0
ffffffffc0205574:	6442                	ld	s0,16(sp)
ffffffffc0205576:	64a2                	ld	s1,8(sp)
ffffffffc0205578:	6105                	addi	sp,sp,32
ffffffffc020557a:	8082                	ret
ffffffffc020557c:	5475                	li	s0,-3
ffffffffc020557e:	60e2                	ld	ra,24(sp)
ffffffffc0205580:	8522                	mv	a0,s0
ffffffffc0205582:	6442                	ld	s0,16(sp)
ffffffffc0205584:	64a2                	ld	s1,8(sp)
ffffffffc0205586:	6105                	addi	sp,sp,32
ffffffffc0205588:	8082                	ret
ffffffffc020558a:	00008697          	auipc	a3,0x8
ffffffffc020558e:	c6e68693          	addi	a3,a3,-914 # ffffffffc020d1f8 <default_pmm_manager+0x410>
ffffffffc0205592:	00006617          	auipc	a2,0x6
ffffffffc0205596:	38660613          	addi	a2,a2,902 # ffffffffc020b918 <commands+0x250>
ffffffffc020559a:	13a00593          	li	a1,314
ffffffffc020559e:	00008517          	auipc	a0,0x8
ffffffffc02055a2:	9c250513          	addi	a0,a0,-1598 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc02055a6:	c89fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02055aa:	f26ff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>

ffffffffc02055ae <file_getdirentry>:
ffffffffc02055ae:	715d                	addi	sp,sp,-80
ffffffffc02055b0:	e486                	sd	ra,72(sp)
ffffffffc02055b2:	e0a2                	sd	s0,64(sp)
ffffffffc02055b4:	fc26                	sd	s1,56(sp)
ffffffffc02055b6:	f84a                	sd	s2,48(sp)
ffffffffc02055b8:	f44e                	sd	s3,40(sp)
ffffffffc02055ba:	04700793          	li	a5,71
ffffffffc02055be:	0aa7e063          	bltu	a5,a0,ffffffffc020565e <file_getdirentry+0xb0>
ffffffffc02055c2:	00091797          	auipc	a5,0x91
ffffffffc02055c6:	2fe7b783          	ld	a5,766(a5) # ffffffffc02968c0 <current>
ffffffffc02055ca:	1487b783          	ld	a5,328(a5)
ffffffffc02055ce:	c3e9                	beqz	a5,ffffffffc0205690 <file_getdirentry+0xe2>
ffffffffc02055d0:	4b98                	lw	a4,16(a5)
ffffffffc02055d2:	0ae05f63          	blez	a4,ffffffffc0205690 <file_getdirentry+0xe2>
ffffffffc02055d6:	6780                	ld	s0,8(a5)
ffffffffc02055d8:	00351793          	slli	a5,a0,0x3
ffffffffc02055dc:	8f89                	sub	a5,a5,a0
ffffffffc02055de:	078e                	slli	a5,a5,0x3
ffffffffc02055e0:	943e                	add	s0,s0,a5
ffffffffc02055e2:	4018                	lw	a4,0(s0)
ffffffffc02055e4:	4789                	li	a5,2
ffffffffc02055e6:	06f71c63          	bne	a4,a5,ffffffffc020565e <file_getdirentry+0xb0>
ffffffffc02055ea:	4c1c                	lw	a5,24(s0)
ffffffffc02055ec:	06a79963          	bne	a5,a0,ffffffffc020565e <file_getdirentry+0xb0>
ffffffffc02055f0:	581c                	lw	a5,48(s0)
ffffffffc02055f2:	6194                	ld	a3,0(a1)
ffffffffc02055f4:	84ae                	mv	s1,a1
ffffffffc02055f6:	2785                	addiw	a5,a5,1
ffffffffc02055f8:	10000613          	li	a2,256
ffffffffc02055fc:	d81c                	sw	a5,48(s0)
ffffffffc02055fe:	05a1                	addi	a1,a1,8
ffffffffc0205600:	850a                	mv	a0,sp
ffffffffc0205602:	12a000ef          	jal	ra,ffffffffc020572c <iobuf_init>
ffffffffc0205606:	02843983          	ld	s3,40(s0)
ffffffffc020560a:	892a                	mv	s2,a0
ffffffffc020560c:	06098263          	beqz	s3,ffffffffc0205670 <file_getdirentry+0xc2>
ffffffffc0205610:	0709b783          	ld	a5,112(s3)
ffffffffc0205614:	cfb1                	beqz	a5,ffffffffc0205670 <file_getdirentry+0xc2>
ffffffffc0205616:	63bc                	ld	a5,64(a5)
ffffffffc0205618:	cfa1                	beqz	a5,ffffffffc0205670 <file_getdirentry+0xc2>
ffffffffc020561a:	854e                	mv	a0,s3
ffffffffc020561c:	00008597          	auipc	a1,0x8
ffffffffc0205620:	c8c58593          	addi	a1,a1,-884 # ffffffffc020d2a8 <default_pmm_manager+0x4c0>
ffffffffc0205624:	0fd020ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0205628:	0709b783          	ld	a5,112(s3)
ffffffffc020562c:	7408                	ld	a0,40(s0)
ffffffffc020562e:	85ca                	mv	a1,s2
ffffffffc0205630:	63bc                	ld	a5,64(a5)
ffffffffc0205632:	9782                	jalr	a5
ffffffffc0205634:	89aa                	mv	s3,a0
ffffffffc0205636:	e909                	bnez	a0,ffffffffc0205648 <file_getdirentry+0x9a>
ffffffffc0205638:	609c                	ld	a5,0(s1)
ffffffffc020563a:	01093683          	ld	a3,16(s2)
ffffffffc020563e:	01893703          	ld	a4,24(s2)
ffffffffc0205642:	97b6                	add	a5,a5,a3
ffffffffc0205644:	8f99                	sub	a5,a5,a4
ffffffffc0205646:	e09c                	sd	a5,0(s1)
ffffffffc0205648:	8522                	mv	a0,s0
ffffffffc020564a:	fb8ff0ef          	jal	ra,ffffffffc0204e02 <fd_array_release>
ffffffffc020564e:	60a6                	ld	ra,72(sp)
ffffffffc0205650:	6406                	ld	s0,64(sp)
ffffffffc0205652:	74e2                	ld	s1,56(sp)
ffffffffc0205654:	7942                	ld	s2,48(sp)
ffffffffc0205656:	854e                	mv	a0,s3
ffffffffc0205658:	79a2                	ld	s3,40(sp)
ffffffffc020565a:	6161                	addi	sp,sp,80
ffffffffc020565c:	8082                	ret
ffffffffc020565e:	60a6                	ld	ra,72(sp)
ffffffffc0205660:	6406                	ld	s0,64(sp)
ffffffffc0205662:	59f5                	li	s3,-3
ffffffffc0205664:	74e2                	ld	s1,56(sp)
ffffffffc0205666:	7942                	ld	s2,48(sp)
ffffffffc0205668:	854e                	mv	a0,s3
ffffffffc020566a:	79a2                	ld	s3,40(sp)
ffffffffc020566c:	6161                	addi	sp,sp,80
ffffffffc020566e:	8082                	ret
ffffffffc0205670:	00008697          	auipc	a3,0x8
ffffffffc0205674:	be068693          	addi	a3,a3,-1056 # ffffffffc020d250 <default_pmm_manager+0x468>
ffffffffc0205678:	00006617          	auipc	a2,0x6
ffffffffc020567c:	2a060613          	addi	a2,a2,672 # ffffffffc020b918 <commands+0x250>
ffffffffc0205680:	14a00593          	li	a1,330
ffffffffc0205684:	00008517          	auipc	a0,0x8
ffffffffc0205688:	8dc50513          	addi	a0,a0,-1828 # ffffffffc020cf60 <default_pmm_manager+0x178>
ffffffffc020568c:	ba3fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205690:	e40ff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>

ffffffffc0205694 <file_dup>:
ffffffffc0205694:	04700713          	li	a4,71
ffffffffc0205698:	06a76463          	bltu	a4,a0,ffffffffc0205700 <file_dup+0x6c>
ffffffffc020569c:	00091717          	auipc	a4,0x91
ffffffffc02056a0:	22473703          	ld	a4,548(a4) # ffffffffc02968c0 <current>
ffffffffc02056a4:	14873703          	ld	a4,328(a4)
ffffffffc02056a8:	1101                	addi	sp,sp,-32
ffffffffc02056aa:	ec06                	sd	ra,24(sp)
ffffffffc02056ac:	e822                	sd	s0,16(sp)
ffffffffc02056ae:	cb39                	beqz	a4,ffffffffc0205704 <file_dup+0x70>
ffffffffc02056b0:	4b14                	lw	a3,16(a4)
ffffffffc02056b2:	04d05963          	blez	a3,ffffffffc0205704 <file_dup+0x70>
ffffffffc02056b6:	6700                	ld	s0,8(a4)
ffffffffc02056b8:	00351713          	slli	a4,a0,0x3
ffffffffc02056bc:	8f09                	sub	a4,a4,a0
ffffffffc02056be:	070e                	slli	a4,a4,0x3
ffffffffc02056c0:	943a                	add	s0,s0,a4
ffffffffc02056c2:	4014                	lw	a3,0(s0)
ffffffffc02056c4:	4709                	li	a4,2
ffffffffc02056c6:	02e69863          	bne	a3,a4,ffffffffc02056f6 <file_dup+0x62>
ffffffffc02056ca:	4c18                	lw	a4,24(s0)
ffffffffc02056cc:	02a71563          	bne	a4,a0,ffffffffc02056f6 <file_dup+0x62>
ffffffffc02056d0:	852e                	mv	a0,a1
ffffffffc02056d2:	002c                	addi	a1,sp,8
ffffffffc02056d4:	e1eff0ef          	jal	ra,ffffffffc0204cf2 <fd_array_alloc>
ffffffffc02056d8:	c509                	beqz	a0,ffffffffc02056e2 <file_dup+0x4e>
ffffffffc02056da:	60e2                	ld	ra,24(sp)
ffffffffc02056dc:	6442                	ld	s0,16(sp)
ffffffffc02056de:	6105                	addi	sp,sp,32
ffffffffc02056e0:	8082                	ret
ffffffffc02056e2:	6522                	ld	a0,8(sp)
ffffffffc02056e4:	85a2                	mv	a1,s0
ffffffffc02056e6:	845ff0ef          	jal	ra,ffffffffc0204f2a <fd_array_dup>
ffffffffc02056ea:	67a2                	ld	a5,8(sp)
ffffffffc02056ec:	60e2                	ld	ra,24(sp)
ffffffffc02056ee:	6442                	ld	s0,16(sp)
ffffffffc02056f0:	4f88                	lw	a0,24(a5)
ffffffffc02056f2:	6105                	addi	sp,sp,32
ffffffffc02056f4:	8082                	ret
ffffffffc02056f6:	60e2                	ld	ra,24(sp)
ffffffffc02056f8:	6442                	ld	s0,16(sp)
ffffffffc02056fa:	5575                	li	a0,-3
ffffffffc02056fc:	6105                	addi	sp,sp,32
ffffffffc02056fe:	8082                	ret
ffffffffc0205700:	5575                	li	a0,-3
ffffffffc0205702:	8082                	ret
ffffffffc0205704:	dccff0ef          	jal	ra,ffffffffc0204cd0 <get_fd_array.part.0>

ffffffffc0205708 <iobuf_skip.part.0>:
ffffffffc0205708:	1141                	addi	sp,sp,-16
ffffffffc020570a:	00008697          	auipc	a3,0x8
ffffffffc020570e:	bde68693          	addi	a3,a3,-1058 # ffffffffc020d2e8 <CSWTCH.79+0x18>
ffffffffc0205712:	00006617          	auipc	a2,0x6
ffffffffc0205716:	20660613          	addi	a2,a2,518 # ffffffffc020b918 <commands+0x250>
ffffffffc020571a:	04a00593          	li	a1,74
ffffffffc020571e:	00008517          	auipc	a0,0x8
ffffffffc0205722:	be250513          	addi	a0,a0,-1054 # ffffffffc020d300 <CSWTCH.79+0x30>
ffffffffc0205726:	e406                	sd	ra,8(sp)
ffffffffc0205728:	b07fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020572c <iobuf_init>:
ffffffffc020572c:	e10c                	sd	a1,0(a0)
ffffffffc020572e:	e514                	sd	a3,8(a0)
ffffffffc0205730:	ed10                	sd	a2,24(a0)
ffffffffc0205732:	e910                	sd	a2,16(a0)
ffffffffc0205734:	8082                	ret

ffffffffc0205736 <iobuf_move>:
ffffffffc0205736:	7179                	addi	sp,sp,-48
ffffffffc0205738:	ec26                	sd	s1,24(sp)
ffffffffc020573a:	6d04                	ld	s1,24(a0)
ffffffffc020573c:	f022                	sd	s0,32(sp)
ffffffffc020573e:	e84a                	sd	s2,16(sp)
ffffffffc0205740:	e44e                	sd	s3,8(sp)
ffffffffc0205742:	f406                	sd	ra,40(sp)
ffffffffc0205744:	842a                	mv	s0,a0
ffffffffc0205746:	8932                	mv	s2,a2
ffffffffc0205748:	852e                	mv	a0,a1
ffffffffc020574a:	89ba                	mv	s3,a4
ffffffffc020574c:	00967363          	bgeu	a2,s1,ffffffffc0205752 <iobuf_move+0x1c>
ffffffffc0205750:	84b2                	mv	s1,a2
ffffffffc0205752:	c495                	beqz	s1,ffffffffc020577e <iobuf_move+0x48>
ffffffffc0205754:	600c                	ld	a1,0(s0)
ffffffffc0205756:	c681                	beqz	a3,ffffffffc020575e <iobuf_move+0x28>
ffffffffc0205758:	87ae                	mv	a5,a1
ffffffffc020575a:	85aa                	mv	a1,a0
ffffffffc020575c:	853e                	mv	a0,a5
ffffffffc020575e:	8626                	mv	a2,s1
ffffffffc0205760:	7d2050ef          	jal	ra,ffffffffc020af32 <memmove>
ffffffffc0205764:	6c1c                	ld	a5,24(s0)
ffffffffc0205766:	0297ea63          	bltu	a5,s1,ffffffffc020579a <iobuf_move+0x64>
ffffffffc020576a:	6014                	ld	a3,0(s0)
ffffffffc020576c:	6418                	ld	a4,8(s0)
ffffffffc020576e:	8f85                	sub	a5,a5,s1
ffffffffc0205770:	96a6                	add	a3,a3,s1
ffffffffc0205772:	9726                	add	a4,a4,s1
ffffffffc0205774:	e014                	sd	a3,0(s0)
ffffffffc0205776:	e418                	sd	a4,8(s0)
ffffffffc0205778:	ec1c                	sd	a5,24(s0)
ffffffffc020577a:	40990933          	sub	s2,s2,s1
ffffffffc020577e:	00098463          	beqz	s3,ffffffffc0205786 <iobuf_move+0x50>
ffffffffc0205782:	0099b023          	sd	s1,0(s3)
ffffffffc0205786:	4501                	li	a0,0
ffffffffc0205788:	00091b63          	bnez	s2,ffffffffc020579e <iobuf_move+0x68>
ffffffffc020578c:	70a2                	ld	ra,40(sp)
ffffffffc020578e:	7402                	ld	s0,32(sp)
ffffffffc0205790:	64e2                	ld	s1,24(sp)
ffffffffc0205792:	6942                	ld	s2,16(sp)
ffffffffc0205794:	69a2                	ld	s3,8(sp)
ffffffffc0205796:	6145                	addi	sp,sp,48
ffffffffc0205798:	8082                	ret
ffffffffc020579a:	f6fff0ef          	jal	ra,ffffffffc0205708 <iobuf_skip.part.0>
ffffffffc020579e:	5571                	li	a0,-4
ffffffffc02057a0:	b7f5                	j	ffffffffc020578c <iobuf_move+0x56>

ffffffffc02057a2 <iobuf_skip>:
ffffffffc02057a2:	6d1c                	ld	a5,24(a0)
ffffffffc02057a4:	00b7eb63          	bltu	a5,a1,ffffffffc02057ba <iobuf_skip+0x18>
ffffffffc02057a8:	6114                	ld	a3,0(a0)
ffffffffc02057aa:	6518                	ld	a4,8(a0)
ffffffffc02057ac:	8f8d                	sub	a5,a5,a1
ffffffffc02057ae:	96ae                	add	a3,a3,a1
ffffffffc02057b0:	95ba                	add	a1,a1,a4
ffffffffc02057b2:	e114                	sd	a3,0(a0)
ffffffffc02057b4:	e50c                	sd	a1,8(a0)
ffffffffc02057b6:	ed1c                	sd	a5,24(a0)
ffffffffc02057b8:	8082                	ret
ffffffffc02057ba:	1141                	addi	sp,sp,-16
ffffffffc02057bc:	e406                	sd	ra,8(sp)
ffffffffc02057be:	f4bff0ef          	jal	ra,ffffffffc0205708 <iobuf_skip.part.0>

ffffffffc02057c2 <fs_init>:
ffffffffc02057c2:	1141                	addi	sp,sp,-16
ffffffffc02057c4:	e406                	sd	ra,8(sp)
ffffffffc02057c6:	33b020ef          	jal	ra,ffffffffc0208300 <vfs_init>
ffffffffc02057ca:	572030ef          	jal	ra,ffffffffc0208d3c <dev_init>
ffffffffc02057ce:	60a2                	ld	ra,8(sp)
ffffffffc02057d0:	0141                	addi	sp,sp,16
ffffffffc02057d2:	5aa0306f          	j	ffffffffc0208d7c <sfs_init>

ffffffffc02057d6 <fs_cleanup>:
ffffffffc02057d6:	0640206f          	j	ffffffffc020783a <vfs_cleanup>

ffffffffc02057da <lock_files>:
ffffffffc02057da:	0561                	addi	a0,a0,24
ffffffffc02057dc:	f6ffe06f          	j	ffffffffc020474a <down>

ffffffffc02057e0 <unlock_files>:
ffffffffc02057e0:	0561                	addi	a0,a0,24
ffffffffc02057e2:	f65fe06f          	j	ffffffffc0204746 <up>

ffffffffc02057e6 <files_create>:
ffffffffc02057e6:	1141                	addi	sp,sp,-16
ffffffffc02057e8:	6505                	lui	a0,0x1
ffffffffc02057ea:	e022                	sd	s0,0(sp)
ffffffffc02057ec:	e406                	sd	ra,8(sp)
ffffffffc02057ee:	fd5fd0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02057f2:	842a                	mv	s0,a0
ffffffffc02057f4:	cd19                	beqz	a0,ffffffffc0205812 <files_create+0x2c>
ffffffffc02057f6:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc02057fa:	00043023          	sd	zero,0(s0)
ffffffffc02057fe:	0561                	addi	a0,a0,24
ffffffffc0205800:	e41c                	sd	a5,8(s0)
ffffffffc0205802:	00042823          	sw	zero,16(s0)
ffffffffc0205806:	4585                	li	a1,1
ffffffffc0205808:	f37fe0ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc020580c:	6408                	ld	a0,8(s0)
ffffffffc020580e:	e82ff0ef          	jal	ra,ffffffffc0204e90 <fd_array_init>
ffffffffc0205812:	60a2                	ld	ra,8(sp)
ffffffffc0205814:	8522                	mv	a0,s0
ffffffffc0205816:	6402                	ld	s0,0(sp)
ffffffffc0205818:	0141                	addi	sp,sp,16
ffffffffc020581a:	8082                	ret

ffffffffc020581c <files_destroy>:
ffffffffc020581c:	7179                	addi	sp,sp,-48
ffffffffc020581e:	f406                	sd	ra,40(sp)
ffffffffc0205820:	f022                	sd	s0,32(sp)
ffffffffc0205822:	ec26                	sd	s1,24(sp)
ffffffffc0205824:	e84a                	sd	s2,16(sp)
ffffffffc0205826:	e44e                	sd	s3,8(sp)
ffffffffc0205828:	c52d                	beqz	a0,ffffffffc0205892 <files_destroy+0x76>
ffffffffc020582a:	491c                	lw	a5,16(a0)
ffffffffc020582c:	89aa                	mv	s3,a0
ffffffffc020582e:	e3b5                	bnez	a5,ffffffffc0205892 <files_destroy+0x76>
ffffffffc0205830:	6108                	ld	a0,0(a0)
ffffffffc0205832:	c119                	beqz	a0,ffffffffc0205838 <files_destroy+0x1c>
ffffffffc0205834:	7a2020ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc0205838:	0089b403          	ld	s0,8(s3)
ffffffffc020583c:	6485                	lui	s1,0x1
ffffffffc020583e:	fc048493          	addi	s1,s1,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205842:	94a2                	add	s1,s1,s0
ffffffffc0205844:	4909                	li	s2,2
ffffffffc0205846:	401c                	lw	a5,0(s0)
ffffffffc0205848:	03278063          	beq	a5,s2,ffffffffc0205868 <files_destroy+0x4c>
ffffffffc020584c:	e39d                	bnez	a5,ffffffffc0205872 <files_destroy+0x56>
ffffffffc020584e:	03840413          	addi	s0,s0,56
ffffffffc0205852:	fe849ae3          	bne	s1,s0,ffffffffc0205846 <files_destroy+0x2a>
ffffffffc0205856:	7402                	ld	s0,32(sp)
ffffffffc0205858:	70a2                	ld	ra,40(sp)
ffffffffc020585a:	64e2                	ld	s1,24(sp)
ffffffffc020585c:	6942                	ld	s2,16(sp)
ffffffffc020585e:	854e                	mv	a0,s3
ffffffffc0205860:	69a2                	ld	s3,8(sp)
ffffffffc0205862:	6145                	addi	sp,sp,48
ffffffffc0205864:	80efe06f          	j	ffffffffc0203872 <kfree>
ffffffffc0205868:	8522                	mv	a0,s0
ffffffffc020586a:	e42ff0ef          	jal	ra,ffffffffc0204eac <fd_array_close>
ffffffffc020586e:	401c                	lw	a5,0(s0)
ffffffffc0205870:	bff1                	j	ffffffffc020584c <files_destroy+0x30>
ffffffffc0205872:	00008697          	auipc	a3,0x8
ffffffffc0205876:	ade68693          	addi	a3,a3,-1314 # ffffffffc020d350 <CSWTCH.79+0x80>
ffffffffc020587a:	00006617          	auipc	a2,0x6
ffffffffc020587e:	09e60613          	addi	a2,a2,158 # ffffffffc020b918 <commands+0x250>
ffffffffc0205882:	03d00593          	li	a1,61
ffffffffc0205886:	00008517          	auipc	a0,0x8
ffffffffc020588a:	aba50513          	addi	a0,a0,-1350 # ffffffffc020d340 <CSWTCH.79+0x70>
ffffffffc020588e:	9a1fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205892:	00008697          	auipc	a3,0x8
ffffffffc0205896:	a7e68693          	addi	a3,a3,-1410 # ffffffffc020d310 <CSWTCH.79+0x40>
ffffffffc020589a:	00006617          	auipc	a2,0x6
ffffffffc020589e:	07e60613          	addi	a2,a2,126 # ffffffffc020b918 <commands+0x250>
ffffffffc02058a2:	03300593          	li	a1,51
ffffffffc02058a6:	00008517          	auipc	a0,0x8
ffffffffc02058aa:	a9a50513          	addi	a0,a0,-1382 # ffffffffc020d340 <CSWTCH.79+0x70>
ffffffffc02058ae:	981fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02058b2 <files_closeall>:
ffffffffc02058b2:	1101                	addi	sp,sp,-32
ffffffffc02058b4:	ec06                	sd	ra,24(sp)
ffffffffc02058b6:	e822                	sd	s0,16(sp)
ffffffffc02058b8:	e426                	sd	s1,8(sp)
ffffffffc02058ba:	e04a                	sd	s2,0(sp)
ffffffffc02058bc:	c129                	beqz	a0,ffffffffc02058fe <files_closeall+0x4c>
ffffffffc02058be:	491c                	lw	a5,16(a0)
ffffffffc02058c0:	02f05f63          	blez	a5,ffffffffc02058fe <files_closeall+0x4c>
ffffffffc02058c4:	6504                	ld	s1,8(a0)
ffffffffc02058c6:	6785                	lui	a5,0x1
ffffffffc02058c8:	fc078793          	addi	a5,a5,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02058cc:	07048413          	addi	s0,s1,112
ffffffffc02058d0:	4909                	li	s2,2
ffffffffc02058d2:	94be                	add	s1,s1,a5
ffffffffc02058d4:	a029                	j	ffffffffc02058de <files_closeall+0x2c>
ffffffffc02058d6:	03840413          	addi	s0,s0,56
ffffffffc02058da:	00848c63          	beq	s1,s0,ffffffffc02058f2 <files_closeall+0x40>
ffffffffc02058de:	401c                	lw	a5,0(s0)
ffffffffc02058e0:	ff279be3          	bne	a5,s2,ffffffffc02058d6 <files_closeall+0x24>
ffffffffc02058e4:	8522                	mv	a0,s0
ffffffffc02058e6:	03840413          	addi	s0,s0,56
ffffffffc02058ea:	dc2ff0ef          	jal	ra,ffffffffc0204eac <fd_array_close>
ffffffffc02058ee:	fe8498e3          	bne	s1,s0,ffffffffc02058de <files_closeall+0x2c>
ffffffffc02058f2:	60e2                	ld	ra,24(sp)
ffffffffc02058f4:	6442                	ld	s0,16(sp)
ffffffffc02058f6:	64a2                	ld	s1,8(sp)
ffffffffc02058f8:	6902                	ld	s2,0(sp)
ffffffffc02058fa:	6105                	addi	sp,sp,32
ffffffffc02058fc:	8082                	ret
ffffffffc02058fe:	00007697          	auipc	a3,0x7
ffffffffc0205902:	63268693          	addi	a3,a3,1586 # ffffffffc020cf30 <default_pmm_manager+0x148>
ffffffffc0205906:	00006617          	auipc	a2,0x6
ffffffffc020590a:	01260613          	addi	a2,a2,18 # ffffffffc020b918 <commands+0x250>
ffffffffc020590e:	04500593          	li	a1,69
ffffffffc0205912:	00008517          	auipc	a0,0x8
ffffffffc0205916:	a2e50513          	addi	a0,a0,-1490 # ffffffffc020d340 <CSWTCH.79+0x70>
ffffffffc020591a:	915fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020591e <dup_files>:
ffffffffc020591e:	7179                	addi	sp,sp,-48
ffffffffc0205920:	f406                	sd	ra,40(sp)
ffffffffc0205922:	f022                	sd	s0,32(sp)
ffffffffc0205924:	ec26                	sd	s1,24(sp)
ffffffffc0205926:	e84a                	sd	s2,16(sp)
ffffffffc0205928:	e44e                	sd	s3,8(sp)
ffffffffc020592a:	e052                	sd	s4,0(sp)
ffffffffc020592c:	c52d                	beqz	a0,ffffffffc0205996 <dup_files+0x78>
ffffffffc020592e:	842e                	mv	s0,a1
ffffffffc0205930:	c1bd                	beqz	a1,ffffffffc0205996 <dup_files+0x78>
ffffffffc0205932:	491c                	lw	a5,16(a0)
ffffffffc0205934:	84aa                	mv	s1,a0
ffffffffc0205936:	e3c1                	bnez	a5,ffffffffc02059b6 <dup_files+0x98>
ffffffffc0205938:	499c                	lw	a5,16(a1)
ffffffffc020593a:	06f05e63          	blez	a5,ffffffffc02059b6 <dup_files+0x98>
ffffffffc020593e:	6188                	ld	a0,0(a1)
ffffffffc0205940:	e088                	sd	a0,0(s1)
ffffffffc0205942:	c119                	beqz	a0,ffffffffc0205948 <dup_files+0x2a>
ffffffffc0205944:	5c4020ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc0205948:	6400                	ld	s0,8(s0)
ffffffffc020594a:	6905                	lui	s2,0x1
ffffffffc020594c:	fc090913          	addi	s2,s2,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205950:	6484                	ld	s1,8(s1)
ffffffffc0205952:	9922                	add	s2,s2,s0
ffffffffc0205954:	4989                	li	s3,2
ffffffffc0205956:	4a05                	li	s4,1
ffffffffc0205958:	a039                	j	ffffffffc0205966 <dup_files+0x48>
ffffffffc020595a:	03840413          	addi	s0,s0,56
ffffffffc020595e:	03848493          	addi	s1,s1,56
ffffffffc0205962:	02890163          	beq	s2,s0,ffffffffc0205984 <dup_files+0x66>
ffffffffc0205966:	401c                	lw	a5,0(s0)
ffffffffc0205968:	ff3799e3          	bne	a5,s3,ffffffffc020595a <dup_files+0x3c>
ffffffffc020596c:	0144a023          	sw	s4,0(s1)
ffffffffc0205970:	85a2                	mv	a1,s0
ffffffffc0205972:	8526                	mv	a0,s1
ffffffffc0205974:	03840413          	addi	s0,s0,56
ffffffffc0205978:	db2ff0ef          	jal	ra,ffffffffc0204f2a <fd_array_dup>
ffffffffc020597c:	03848493          	addi	s1,s1,56
ffffffffc0205980:	fe8913e3          	bne	s2,s0,ffffffffc0205966 <dup_files+0x48>
ffffffffc0205984:	70a2                	ld	ra,40(sp)
ffffffffc0205986:	7402                	ld	s0,32(sp)
ffffffffc0205988:	64e2                	ld	s1,24(sp)
ffffffffc020598a:	6942                	ld	s2,16(sp)
ffffffffc020598c:	69a2                	ld	s3,8(sp)
ffffffffc020598e:	6a02                	ld	s4,0(sp)
ffffffffc0205990:	4501                	li	a0,0
ffffffffc0205992:	6145                	addi	sp,sp,48
ffffffffc0205994:	8082                	ret
ffffffffc0205996:	00007697          	auipc	a3,0x7
ffffffffc020599a:	e7268693          	addi	a3,a3,-398 # ffffffffc020c808 <commands+0x1140>
ffffffffc020599e:	00006617          	auipc	a2,0x6
ffffffffc02059a2:	f7a60613          	addi	a2,a2,-134 # ffffffffc020b918 <commands+0x250>
ffffffffc02059a6:	05300593          	li	a1,83
ffffffffc02059aa:	00008517          	auipc	a0,0x8
ffffffffc02059ae:	99650513          	addi	a0,a0,-1642 # ffffffffc020d340 <CSWTCH.79+0x70>
ffffffffc02059b2:	87dfa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02059b6:	00008697          	auipc	a3,0x8
ffffffffc02059ba:	9b268693          	addi	a3,a3,-1614 # ffffffffc020d368 <CSWTCH.79+0x98>
ffffffffc02059be:	00006617          	auipc	a2,0x6
ffffffffc02059c2:	f5a60613          	addi	a2,a2,-166 # ffffffffc020b918 <commands+0x250>
ffffffffc02059c6:	05400593          	li	a1,84
ffffffffc02059ca:	00008517          	auipc	a0,0x8
ffffffffc02059ce:	97650513          	addi	a0,a0,-1674 # ffffffffc020d340 <CSWTCH.79+0x70>
ffffffffc02059d2:	85dfa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02059d6 <switch_to>:
ffffffffc02059d6:	00153023          	sd	ra,0(a0)
ffffffffc02059da:	00253423          	sd	sp,8(a0)
ffffffffc02059de:	e900                	sd	s0,16(a0)
ffffffffc02059e0:	ed04                	sd	s1,24(a0)
ffffffffc02059e2:	03253023          	sd	s2,32(a0)
ffffffffc02059e6:	03353423          	sd	s3,40(a0)
ffffffffc02059ea:	03453823          	sd	s4,48(a0)
ffffffffc02059ee:	03553c23          	sd	s5,56(a0)
ffffffffc02059f2:	05653023          	sd	s6,64(a0)
ffffffffc02059f6:	05753423          	sd	s7,72(a0)
ffffffffc02059fa:	05853823          	sd	s8,80(a0)
ffffffffc02059fe:	05953c23          	sd	s9,88(a0)
ffffffffc0205a02:	07a53023          	sd	s10,96(a0)
ffffffffc0205a06:	07b53423          	sd	s11,104(a0)
ffffffffc0205a0a:	0005b083          	ld	ra,0(a1)
ffffffffc0205a0e:	0085b103          	ld	sp,8(a1)
ffffffffc0205a12:	6980                	ld	s0,16(a1)
ffffffffc0205a14:	6d84                	ld	s1,24(a1)
ffffffffc0205a16:	0205b903          	ld	s2,32(a1)
ffffffffc0205a1a:	0285b983          	ld	s3,40(a1)
ffffffffc0205a1e:	0305ba03          	ld	s4,48(a1)
ffffffffc0205a22:	0385ba83          	ld	s5,56(a1)
ffffffffc0205a26:	0405bb03          	ld	s6,64(a1)
ffffffffc0205a2a:	0485bb83          	ld	s7,72(a1)
ffffffffc0205a2e:	0505bc03          	ld	s8,80(a1)
ffffffffc0205a32:	0585bc83          	ld	s9,88(a1)
ffffffffc0205a36:	0605bd03          	ld	s10,96(a1)
ffffffffc0205a3a:	0685bd83          	ld	s11,104(a1)
ffffffffc0205a3e:	8082                	ret

ffffffffc0205a40 <kernel_thread_entry>:
ffffffffc0205a40:	8526                	mv	a0,s1
ffffffffc0205a42:	9402                	jalr	s0
ffffffffc0205a44:	676000ef          	jal	ra,ffffffffc02060ba <do_exit>

ffffffffc0205a48 <alloc_proc>:
ffffffffc0205a48:	1141                	addi	sp,sp,-16
ffffffffc0205a4a:	15000513          	li	a0,336
ffffffffc0205a4e:	e022                	sd	s0,0(sp)
ffffffffc0205a50:	e406                	sd	ra,8(sp)
ffffffffc0205a52:	d71fd0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0205a56:	842a                	mv	s0,a0
ffffffffc0205a58:	c141                	beqz	a0,ffffffffc0205ad8 <alloc_proc+0x90>
ffffffffc0205a5a:	57fd                	li	a5,-1
ffffffffc0205a5c:	1782                	slli	a5,a5,0x20
ffffffffc0205a5e:	e11c                	sd	a5,0(a0)
ffffffffc0205a60:	07000613          	li	a2,112
ffffffffc0205a64:	4581                	li	a1,0
ffffffffc0205a66:	00052423          	sw	zero,8(a0)
ffffffffc0205a6a:	00053823          	sd	zero,16(a0)
ffffffffc0205a6e:	00053c23          	sd	zero,24(a0)
ffffffffc0205a72:	02053023          	sd	zero,32(a0)
ffffffffc0205a76:	02053423          	sd	zero,40(a0)
ffffffffc0205a7a:	03050513          	addi	a0,a0,48
ffffffffc0205a7e:	4a2050ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0205a82:	00091797          	auipc	a5,0x91
ffffffffc0205a86:	e067b783          	ld	a5,-506(a5) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc0205a8a:	f45c                	sd	a5,168(s0)
ffffffffc0205a8c:	0a043023          	sd	zero,160(s0)
ffffffffc0205a90:	0a042823          	sw	zero,176(s0)
ffffffffc0205a94:	463d                	li	a2,15
ffffffffc0205a96:	4581                	li	a1,0
ffffffffc0205a98:	0b440513          	addi	a0,s0,180
ffffffffc0205a9c:	484050ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0205aa0:	11040793          	addi	a5,s0,272
ffffffffc0205aa4:	0e042623          	sw	zero,236(s0)
ffffffffc0205aa8:	0e043c23          	sd	zero,248(s0)
ffffffffc0205aac:	10043023          	sd	zero,256(s0)
ffffffffc0205ab0:	0e043823          	sd	zero,240(s0)
ffffffffc0205ab4:	10043423          	sd	zero,264(s0)
ffffffffc0205ab8:	10f43c23          	sd	a5,280(s0)
ffffffffc0205abc:	10f43823          	sd	a5,272(s0)
ffffffffc0205ac0:	12042023          	sw	zero,288(s0)
ffffffffc0205ac4:	12043423          	sd	zero,296(s0)
ffffffffc0205ac8:	12043823          	sd	zero,304(s0)
ffffffffc0205acc:	12043c23          	sd	zero,312(s0)
ffffffffc0205ad0:	14043023          	sd	zero,320(s0)
ffffffffc0205ad4:	14043423          	sd	zero,328(s0)
ffffffffc0205ad8:	60a2                	ld	ra,8(sp)
ffffffffc0205ada:	8522                	mv	a0,s0
ffffffffc0205adc:	6402                	ld	s0,0(sp)
ffffffffc0205ade:	0141                	addi	sp,sp,16
ffffffffc0205ae0:	8082                	ret

ffffffffc0205ae2 <forkret>:
ffffffffc0205ae2:	00091797          	auipc	a5,0x91
ffffffffc0205ae6:	dde7b783          	ld	a5,-546(a5) # ffffffffc02968c0 <current>
ffffffffc0205aea:	73c8                	ld	a0,160(a5)
ffffffffc0205aec:	fc2fb06f          	j	ffffffffc02012ae <forkrets>

ffffffffc0205af0 <copy_files>:
ffffffffc0205af0:	7179                	addi	sp,sp,-48
ffffffffc0205af2:	00091797          	auipc	a5,0x91
ffffffffc0205af6:	dce7b783          	ld	a5,-562(a5) # ffffffffc02968c0 <current>
ffffffffc0205afa:	f022                	sd	s0,32(sp)
ffffffffc0205afc:	1487b403          	ld	s0,328(a5)
ffffffffc0205b00:	f406                	sd	ra,40(sp)
ffffffffc0205b02:	ec26                	sd	s1,24(sp)
ffffffffc0205b04:	e84a                	sd	s2,16(sp)
ffffffffc0205b06:	e44e                	sd	s3,8(sp)
ffffffffc0205b08:	c039                	beqz	s0,ffffffffc0205b4e <copy_files+0x5e>
ffffffffc0205b0a:	812d                	srli	a0,a0,0xb
ffffffffc0205b0c:	8905                	andi	a0,a0,1
ffffffffc0205b0e:	84ae                	mv	s1,a1
ffffffffc0205b10:	cd19                	beqz	a0,ffffffffc0205b2e <copy_files+0x3e>
ffffffffc0205b12:	481c                	lw	a5,16(s0)
ffffffffc0205b14:	4901                	li	s2,0
ffffffffc0205b16:	2785                	addiw	a5,a5,1
ffffffffc0205b18:	c81c                	sw	a5,16(s0)
ffffffffc0205b1a:	1484b423          	sd	s0,328(s1)
ffffffffc0205b1e:	70a2                	ld	ra,40(sp)
ffffffffc0205b20:	7402                	ld	s0,32(sp)
ffffffffc0205b22:	64e2                	ld	s1,24(sp)
ffffffffc0205b24:	69a2                	ld	s3,8(sp)
ffffffffc0205b26:	854a                	mv	a0,s2
ffffffffc0205b28:	6942                	ld	s2,16(sp)
ffffffffc0205b2a:	6145                	addi	sp,sp,48
ffffffffc0205b2c:	8082                	ret
ffffffffc0205b2e:	cb9ff0ef          	jal	ra,ffffffffc02057e6 <files_create>
ffffffffc0205b32:	89aa                	mv	s3,a0
ffffffffc0205b34:	c919                	beqz	a0,ffffffffc0205b4a <copy_files+0x5a>
ffffffffc0205b36:	85a2                	mv	a1,s0
ffffffffc0205b38:	de7ff0ef          	jal	ra,ffffffffc020591e <dup_files>
ffffffffc0205b3c:	892a                	mv	s2,a0
ffffffffc0205b3e:	844e                	mv	s0,s3
ffffffffc0205b40:	d969                	beqz	a0,ffffffffc0205b12 <copy_files+0x22>
ffffffffc0205b42:	854e                	mv	a0,s3
ffffffffc0205b44:	cd9ff0ef          	jal	ra,ffffffffc020581c <files_destroy>
ffffffffc0205b48:	bfd9                	j	ffffffffc0205b1e <copy_files+0x2e>
ffffffffc0205b4a:	5971                	li	s2,-4
ffffffffc0205b4c:	bfc9                	j	ffffffffc0205b1e <copy_files+0x2e>
ffffffffc0205b4e:	00008697          	auipc	a3,0x8
ffffffffc0205b52:	84a68693          	addi	a3,a3,-1974 # ffffffffc020d398 <CSWTCH.79+0xc8>
ffffffffc0205b56:	00006617          	auipc	a2,0x6
ffffffffc0205b5a:	dc260613          	addi	a2,a2,-574 # ffffffffc020b918 <commands+0x250>
ffffffffc0205b5e:	1de00593          	li	a1,478
ffffffffc0205b62:	00008517          	auipc	a0,0x8
ffffffffc0205b66:	84e50513          	addi	a0,a0,-1970 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0205b6a:	ec4fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205b6e <put_pgdir.isra.0>:
ffffffffc0205b6e:	1141                	addi	sp,sp,-16
ffffffffc0205b70:	e406                	sd	ra,8(sp)
ffffffffc0205b72:	c02007b7          	lui	a5,0xc0200
ffffffffc0205b76:	02f56e63          	bltu	a0,a5,ffffffffc0205bb2 <put_pgdir.isra.0+0x44>
ffffffffc0205b7a:	00091697          	auipc	a3,0x91
ffffffffc0205b7e:	d366b683          	ld	a3,-714(a3) # ffffffffc02968b0 <va_pa_offset>
ffffffffc0205b82:	8d15                	sub	a0,a0,a3
ffffffffc0205b84:	8131                	srli	a0,a0,0xc
ffffffffc0205b86:	00091797          	auipc	a5,0x91
ffffffffc0205b8a:	d127b783          	ld	a5,-750(a5) # ffffffffc0296898 <npage>
ffffffffc0205b8e:	02f57f63          	bgeu	a0,a5,ffffffffc0205bcc <put_pgdir.isra.0+0x5e>
ffffffffc0205b92:	0000a697          	auipc	a3,0xa
ffffffffc0205b96:	a1e6b683          	ld	a3,-1506(a3) # ffffffffc020f5b0 <nbase>
ffffffffc0205b9a:	60a2                	ld	ra,8(sp)
ffffffffc0205b9c:	8d15                	sub	a0,a0,a3
ffffffffc0205b9e:	00091797          	auipc	a5,0x91
ffffffffc0205ba2:	d027b783          	ld	a5,-766(a5) # ffffffffc02968a0 <pages>
ffffffffc0205ba6:	051a                	slli	a0,a0,0x6
ffffffffc0205ba8:	4585                	li	a1,1
ffffffffc0205baa:	953e                	add	a0,a0,a5
ffffffffc0205bac:	0141                	addi	sp,sp,16
ffffffffc0205bae:	f7afb06f          	j	ffffffffc0201328 <free_pages>
ffffffffc0205bb2:	86aa                	mv	a3,a0
ffffffffc0205bb4:	00006617          	auipc	a2,0x6
ffffffffc0205bb8:	59c60613          	addi	a2,a2,1436 # ffffffffc020c150 <commands+0xa88>
ffffffffc0205bbc:	07700593          	li	a1,119
ffffffffc0205bc0:	00006517          	auipc	a0,0x6
ffffffffc0205bc4:	43850513          	addi	a0,a0,1080 # ffffffffc020bff8 <commands+0x930>
ffffffffc0205bc8:	e66fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205bcc:	00006617          	auipc	a2,0x6
ffffffffc0205bd0:	40c60613          	addi	a2,a2,1036 # ffffffffc020bfd8 <commands+0x910>
ffffffffc0205bd4:	06900593          	li	a1,105
ffffffffc0205bd8:	00006517          	auipc	a0,0x6
ffffffffc0205bdc:	42050513          	addi	a0,a0,1056 # ffffffffc020bff8 <commands+0x930>
ffffffffc0205be0:	e4efa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205be4 <setup_pgdir>:
ffffffffc0205be4:	1101                	addi	sp,sp,-32
ffffffffc0205be6:	e426                	sd	s1,8(sp)
ffffffffc0205be8:	84aa                	mv	s1,a0
ffffffffc0205bea:	4505                	li	a0,1
ffffffffc0205bec:	ec06                	sd	ra,24(sp)
ffffffffc0205bee:	e822                	sd	s0,16(sp)
ffffffffc0205bf0:	efafb0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0205bf4:	c939                	beqz	a0,ffffffffc0205c4a <setup_pgdir+0x66>
ffffffffc0205bf6:	00091697          	auipc	a3,0x91
ffffffffc0205bfa:	caa6b683          	ld	a3,-854(a3) # ffffffffc02968a0 <pages>
ffffffffc0205bfe:	40d506b3          	sub	a3,a0,a3
ffffffffc0205c02:	8699                	srai	a3,a3,0x6
ffffffffc0205c04:	0000a417          	auipc	s0,0xa
ffffffffc0205c08:	9ac43403          	ld	s0,-1620(s0) # ffffffffc020f5b0 <nbase>
ffffffffc0205c0c:	96a2                	add	a3,a3,s0
ffffffffc0205c0e:	00c69793          	slli	a5,a3,0xc
ffffffffc0205c12:	83b1                	srli	a5,a5,0xc
ffffffffc0205c14:	00091717          	auipc	a4,0x91
ffffffffc0205c18:	c8473703          	ld	a4,-892(a4) # ffffffffc0296898 <npage>
ffffffffc0205c1c:	06b2                	slli	a3,a3,0xc
ffffffffc0205c1e:	02e7f863          	bgeu	a5,a4,ffffffffc0205c4e <setup_pgdir+0x6a>
ffffffffc0205c22:	00091417          	auipc	s0,0x91
ffffffffc0205c26:	c8e43403          	ld	s0,-882(s0) # ffffffffc02968b0 <va_pa_offset>
ffffffffc0205c2a:	9436                	add	s0,s0,a3
ffffffffc0205c2c:	6605                	lui	a2,0x1
ffffffffc0205c2e:	00091597          	auipc	a1,0x91
ffffffffc0205c32:	c625b583          	ld	a1,-926(a1) # ffffffffc0296890 <boot_pgdir_va>
ffffffffc0205c36:	8522                	mv	a0,s0
ffffffffc0205c38:	33a050ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0205c3c:	4501                	li	a0,0
ffffffffc0205c3e:	ec80                	sd	s0,24(s1)
ffffffffc0205c40:	60e2                	ld	ra,24(sp)
ffffffffc0205c42:	6442                	ld	s0,16(sp)
ffffffffc0205c44:	64a2                	ld	s1,8(sp)
ffffffffc0205c46:	6105                	addi	sp,sp,32
ffffffffc0205c48:	8082                	ret
ffffffffc0205c4a:	5571                	li	a0,-4
ffffffffc0205c4c:	bfd5                	j	ffffffffc0205c40 <setup_pgdir+0x5c>
ffffffffc0205c4e:	00006617          	auipc	a2,0x6
ffffffffc0205c52:	3e260613          	addi	a2,a2,994 # ffffffffc020c030 <commands+0x968>
ffffffffc0205c56:	07100593          	li	a1,113
ffffffffc0205c5a:	00006517          	auipc	a0,0x6
ffffffffc0205c5e:	39e50513          	addi	a0,a0,926 # ffffffffc020bff8 <commands+0x930>
ffffffffc0205c62:	dccfa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205c66 <proc_run>:
ffffffffc0205c66:	1101                	addi	sp,sp,-32
ffffffffc0205c68:	e426                	sd	s1,8(sp)
ffffffffc0205c6a:	00091497          	auipc	s1,0x91
ffffffffc0205c6e:	c5648493          	addi	s1,s1,-938 # ffffffffc02968c0 <current>
ffffffffc0205c72:	6098                	ld	a4,0(s1)
ffffffffc0205c74:	ec06                	sd	ra,24(sp)
ffffffffc0205c76:	e822                	sd	s0,16(sp)
ffffffffc0205c78:	e04a                	sd	s2,0(sp)
ffffffffc0205c7a:	04a70363          	beq	a4,a0,ffffffffc0205cc0 <proc_run+0x5a>
ffffffffc0205c7e:	842a                	mv	s0,a0
ffffffffc0205c80:	100027f3          	csrr	a5,sstatus
ffffffffc0205c84:	8b89                	andi	a5,a5,2
ffffffffc0205c86:	4901                	li	s2,0
ffffffffc0205c88:	e7b9                	bnez	a5,ffffffffc0205cd6 <proc_run+0x70>
ffffffffc0205c8a:	741c                	ld	a5,40(s0)
ffffffffc0205c8c:	c3a1                	beqz	a5,ffffffffc0205ccc <proc_run+0x66>
ffffffffc0205c8e:	745c                	ld	a5,168(s0)
ffffffffc0205c90:	56fd                	li	a3,-1
ffffffffc0205c92:	16fe                	slli	a3,a3,0x3f
ffffffffc0205c94:	83b1                	srli	a5,a5,0xc
ffffffffc0205c96:	8fd5                	or	a5,a5,a3
ffffffffc0205c98:	18079073          	csrw	satp,a5
ffffffffc0205c9c:	12000073          	sfence.vma
ffffffffc0205ca0:	03040593          	addi	a1,s0,48
ffffffffc0205ca4:	03070513          	addi	a0,a4,48
ffffffffc0205ca8:	e080                	sd	s0,0(s1)
ffffffffc0205caa:	d2dff0ef          	jal	ra,ffffffffc02059d6 <switch_to>
ffffffffc0205cae:	00090963          	beqz	s2,ffffffffc0205cc0 <proc_run+0x5a>
ffffffffc0205cb2:	6442                	ld	s0,16(sp)
ffffffffc0205cb4:	60e2                	ld	ra,24(sp)
ffffffffc0205cb6:	64a2                	ld	s1,8(sp)
ffffffffc0205cb8:	6902                	ld	s2,0(sp)
ffffffffc0205cba:	6105                	addi	sp,sp,32
ffffffffc0205cbc:	8defb06f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc0205cc0:	60e2                	ld	ra,24(sp)
ffffffffc0205cc2:	6442                	ld	s0,16(sp)
ffffffffc0205cc4:	64a2                	ld	s1,8(sp)
ffffffffc0205cc6:	6902                	ld	s2,0(sp)
ffffffffc0205cc8:	6105                	addi	sp,sp,32
ffffffffc0205cca:	8082                	ret
ffffffffc0205ccc:	00091797          	auipc	a5,0x91
ffffffffc0205cd0:	bbc7b783          	ld	a5,-1092(a5) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc0205cd4:	bf75                	j	ffffffffc0205c90 <proc_run+0x2a>
ffffffffc0205cd6:	8cafb0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0205cda:	6098                	ld	a4,0(s1)
ffffffffc0205cdc:	4905                	li	s2,1
ffffffffc0205cde:	b775                	j	ffffffffc0205c8a <proc_run+0x24>

ffffffffc0205ce0 <do_fork>:
ffffffffc0205ce0:	7119                	addi	sp,sp,-128
ffffffffc0205ce2:	ecce                	sd	s3,88(sp)
ffffffffc0205ce4:	00091997          	auipc	s3,0x91
ffffffffc0205ce8:	bf498993          	addi	s3,s3,-1036 # ffffffffc02968d8 <nr_process>
ffffffffc0205cec:	0009a703          	lw	a4,0(s3)
ffffffffc0205cf0:	fc86                	sd	ra,120(sp)
ffffffffc0205cf2:	f8a2                	sd	s0,112(sp)
ffffffffc0205cf4:	f4a6                	sd	s1,104(sp)
ffffffffc0205cf6:	f0ca                	sd	s2,96(sp)
ffffffffc0205cf8:	e8d2                	sd	s4,80(sp)
ffffffffc0205cfa:	e4d6                	sd	s5,72(sp)
ffffffffc0205cfc:	e0da                	sd	s6,64(sp)
ffffffffc0205cfe:	fc5e                	sd	s7,56(sp)
ffffffffc0205d00:	f862                	sd	s8,48(sp)
ffffffffc0205d02:	f466                	sd	s9,40(sp)
ffffffffc0205d04:	f06a                	sd	s10,32(sp)
ffffffffc0205d06:	ec6e                	sd	s11,24(sp)
ffffffffc0205d08:	6785                	lui	a5,0x1
ffffffffc0205d0a:	2cf75863          	bge	a4,a5,ffffffffc0205fda <do_fork+0x2fa>
ffffffffc0205d0e:	892a                	mv	s2,a0
ffffffffc0205d10:	8aae                	mv	s5,a1
ffffffffc0205d12:	84b2                	mv	s1,a2
ffffffffc0205d14:	d35ff0ef          	jal	ra,ffffffffc0205a48 <alloc_proc>
ffffffffc0205d18:	842a                	mv	s0,a0
ffffffffc0205d1a:	2c050e63          	beqz	a0,ffffffffc0205ff6 <do_fork+0x316>
ffffffffc0205d1e:	00091b97          	auipc	s7,0x91
ffffffffc0205d22:	ba2b8b93          	addi	s7,s7,-1118 # ffffffffc02968c0 <current>
ffffffffc0205d26:	000bb783          	ld	a5,0(s7)
ffffffffc0205d2a:	4509                	li	a0,2
ffffffffc0205d2c:	f01c                	sd	a5,32(s0)
ffffffffc0205d2e:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205d32:	db8fb0ef          	jal	ra,ffffffffc02012ea <alloc_pages>
ffffffffc0205d36:	2a050063          	beqz	a0,ffffffffc0205fd6 <do_fork+0x2f6>
ffffffffc0205d3a:	00091c17          	auipc	s8,0x91
ffffffffc0205d3e:	b66c0c13          	addi	s8,s8,-1178 # ffffffffc02968a0 <pages>
ffffffffc0205d42:	000c3683          	ld	a3,0(s8)
ffffffffc0205d46:	0000aa17          	auipc	s4,0xa
ffffffffc0205d4a:	86aa3a03          	ld	s4,-1942(s4) # ffffffffc020f5b0 <nbase>
ffffffffc0205d4e:	00091c97          	auipc	s9,0x91
ffffffffc0205d52:	b4ac8c93          	addi	s9,s9,-1206 # ffffffffc0296898 <npage>
ffffffffc0205d56:	40d506b3          	sub	a3,a0,a3
ffffffffc0205d5a:	8699                	srai	a3,a3,0x6
ffffffffc0205d5c:	96d2                	add	a3,a3,s4
ffffffffc0205d5e:	000cb703          	ld	a4,0(s9)
ffffffffc0205d62:	00c69793          	slli	a5,a3,0xc
ffffffffc0205d66:	83b1                	srli	a5,a5,0xc
ffffffffc0205d68:	06b2                	slli	a3,a3,0xc
ffffffffc0205d6a:	2ae7f063          	bgeu	a5,a4,ffffffffc020600a <do_fork+0x32a>
ffffffffc0205d6e:	000bb703          	ld	a4,0(s7)
ffffffffc0205d72:	00091d17          	auipc	s10,0x91
ffffffffc0205d76:	b3ed0d13          	addi	s10,s10,-1218 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0205d7a:	000d3783          	ld	a5,0(s10)
ffffffffc0205d7e:	02873b03          	ld	s6,40(a4)
ffffffffc0205d82:	96be                	add	a3,a3,a5
ffffffffc0205d84:	e814                	sd	a3,16(s0)
ffffffffc0205d86:	020b0663          	beqz	s6,ffffffffc0205db2 <do_fork+0xd2>
ffffffffc0205d8a:	10097793          	andi	a5,s2,256
ffffffffc0205d8e:	cbed                	beqz	a5,ffffffffc0205e80 <do_fork+0x1a0>
ffffffffc0205d90:	030b2783          	lw	a5,48(s6)
ffffffffc0205d94:	018b3683          	ld	a3,24(s6)
ffffffffc0205d98:	c0200737          	lui	a4,0xc0200
ffffffffc0205d9c:	2785                	addiw	a5,a5,1
ffffffffc0205d9e:	02fb2823          	sw	a5,48(s6)
ffffffffc0205da2:	03643423          	sd	s6,40(s0)
ffffffffc0205da6:	26e6ee63          	bltu	a3,a4,ffffffffc0206022 <do_fork+0x342>
ffffffffc0205daa:	000d3783          	ld	a5,0(s10)
ffffffffc0205dae:	8e9d                	sub	a3,a3,a5
ffffffffc0205db0:	f454                	sd	a3,168(s0)
ffffffffc0205db2:	85a2                	mv	a1,s0
ffffffffc0205db4:	854a                	mv	a0,s2
ffffffffc0205db6:	d3bff0ef          	jal	ra,ffffffffc0205af0 <copy_files>
ffffffffc0205dba:	10051863          	bnez	a0,ffffffffc0205eca <do_fork+0x1ea>
ffffffffc0205dbe:	6818                	ld	a4,16(s0)
ffffffffc0205dc0:	6789                	lui	a5,0x2
ffffffffc0205dc2:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205dc6:	973e                	add	a4,a4,a5
ffffffffc0205dc8:	f058                	sd	a4,160(s0)
ffffffffc0205dca:	87ba                	mv	a5,a4
ffffffffc0205dcc:	12048813          	addi	a6,s1,288
ffffffffc0205dd0:	6088                	ld	a0,0(s1)
ffffffffc0205dd2:	648c                	ld	a1,8(s1)
ffffffffc0205dd4:	6890                	ld	a2,16(s1)
ffffffffc0205dd6:	6c94                	ld	a3,24(s1)
ffffffffc0205dd8:	e388                	sd	a0,0(a5)
ffffffffc0205dda:	e78c                	sd	a1,8(a5)
ffffffffc0205ddc:	eb90                	sd	a2,16(a5)
ffffffffc0205dde:	ef94                	sd	a3,24(a5)
ffffffffc0205de0:	02048493          	addi	s1,s1,32
ffffffffc0205de4:	02078793          	addi	a5,a5,32
ffffffffc0205de8:	ff0494e3          	bne	s1,a6,ffffffffc0205dd0 <do_fork+0xf0>
ffffffffc0205dec:	04073823          	sd	zero,80(a4) # ffffffffc0200050 <kern_init+0x6>
ffffffffc0205df0:	000a9363          	bnez	s5,ffffffffc0205df6 <do_fork+0x116>
ffffffffc0205df4:	8aba                	mv	s5,a4
ffffffffc0205df6:	0008b817          	auipc	a6,0x8b
ffffffffc0205dfa:	26280813          	addi	a6,a6,610 # ffffffffc0291058 <last_pid.1>
ffffffffc0205dfe:	00082783          	lw	a5,0(a6)
ffffffffc0205e02:	01573823          	sd	s5,16(a4)
ffffffffc0205e06:	00000697          	auipc	a3,0x0
ffffffffc0205e0a:	cdc68693          	addi	a3,a3,-804 # ffffffffc0205ae2 <forkret>
ffffffffc0205e0e:	0017851b          	addiw	a0,a5,1
ffffffffc0205e12:	f814                	sd	a3,48(s0)
ffffffffc0205e14:	fc18                	sd	a4,56(s0)
ffffffffc0205e16:	00a82023          	sw	a0,0(a6)
ffffffffc0205e1a:	6789                	lui	a5,0x2
ffffffffc0205e1c:	18f55b63          	bge	a0,a5,ffffffffc0205fb2 <do_fork+0x2d2>
ffffffffc0205e20:	0008b317          	auipc	t1,0x8b
ffffffffc0205e24:	23c30313          	addi	t1,t1,572 # ffffffffc029105c <next_safe.0>
ffffffffc0205e28:	00032783          	lw	a5,0(t1)
ffffffffc0205e2c:	00090497          	auipc	s1,0x90
ffffffffc0205e30:	99448493          	addi	s1,s1,-1644 # ffffffffc02957c0 <proc_list>
ffffffffc0205e34:	10f54663          	blt	a0,a5,ffffffffc0205f40 <do_fork+0x260>
ffffffffc0205e38:	00090497          	auipc	s1,0x90
ffffffffc0205e3c:	98848493          	addi	s1,s1,-1656 # ffffffffc02957c0 <proc_list>
ffffffffc0205e40:	0084be03          	ld	t3,8(s1)
ffffffffc0205e44:	6789                	lui	a5,0x2
ffffffffc0205e46:	00f32023          	sw	a5,0(t1)
ffffffffc0205e4a:	86aa                	mv	a3,a0
ffffffffc0205e4c:	4581                	li	a1,0
ffffffffc0205e4e:	6e89                	lui	t4,0x2
ffffffffc0205e50:	1a9e0563          	beq	t3,s1,ffffffffc0205ffa <do_fork+0x31a>
ffffffffc0205e54:	88ae                	mv	a7,a1
ffffffffc0205e56:	87f2                	mv	a5,t3
ffffffffc0205e58:	6609                	lui	a2,0x2
ffffffffc0205e5a:	a811                	j	ffffffffc0205e6e <do_fork+0x18e>
ffffffffc0205e5c:	00e6d663          	bge	a3,a4,ffffffffc0205e68 <do_fork+0x188>
ffffffffc0205e60:	00c75463          	bge	a4,a2,ffffffffc0205e68 <do_fork+0x188>
ffffffffc0205e64:	863a                	mv	a2,a4
ffffffffc0205e66:	4885                	li	a7,1
ffffffffc0205e68:	679c                	ld	a5,8(a5)
ffffffffc0205e6a:	0c978363          	beq	a5,s1,ffffffffc0205f30 <do_fork+0x250>
ffffffffc0205e6e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205e72:	fed715e3          	bne	a4,a3,ffffffffc0205e5c <do_fork+0x17c>
ffffffffc0205e76:	2685                	addiw	a3,a3,1
ffffffffc0205e78:	14c6da63          	bge	a3,a2,ffffffffc0205fcc <do_fork+0x2ec>
ffffffffc0205e7c:	4585                	li	a1,1
ffffffffc0205e7e:	b7ed                	j	ffffffffc0205e68 <do_fork+0x188>
ffffffffc0205e80:	f07fc0ef          	jal	ra,ffffffffc0202d86 <mm_create>
ffffffffc0205e84:	8daa                	mv	s11,a0
ffffffffc0205e86:	c939                	beqz	a0,ffffffffc0205edc <do_fork+0x1fc>
ffffffffc0205e88:	d5dff0ef          	jal	ra,ffffffffc0205be4 <setup_pgdir>
ffffffffc0205e8c:	10051e63          	bnez	a0,ffffffffc0205fa8 <do_fork+0x2c8>
ffffffffc0205e90:	038b0793          	addi	a5,s6,56
ffffffffc0205e94:	853e                	mv	a0,a5
ffffffffc0205e96:	e43e                	sd	a5,8(sp)
ffffffffc0205e98:	8b3fe0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0205e9c:	000bb703          	ld	a4,0(s7)
ffffffffc0205ea0:	67a2                	ld	a5,8(sp)
ffffffffc0205ea2:	c701                	beqz	a4,ffffffffc0205eaa <do_fork+0x1ca>
ffffffffc0205ea4:	4358                	lw	a4,4(a4)
ffffffffc0205ea6:	04eb2823          	sw	a4,80(s6)
ffffffffc0205eaa:	85da                	mv	a1,s6
ffffffffc0205eac:	856e                	mv	a0,s11
ffffffffc0205eae:	e43e                	sd	a5,8(sp)
ffffffffc0205eb0:	926fd0ef          	jal	ra,ffffffffc0202fd6 <dup_mmap>
ffffffffc0205eb4:	67a2                	ld	a5,8(sp)
ffffffffc0205eb6:	8baa                	mv	s7,a0
ffffffffc0205eb8:	853e                	mv	a0,a5
ffffffffc0205eba:	88dfe0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0205ebe:	040b2823          	sw	zero,80(s6)
ffffffffc0205ec2:	100b9e63          	bnez	s7,ffffffffc0205fde <do_fork+0x2fe>
ffffffffc0205ec6:	8b6e                	mv	s6,s11
ffffffffc0205ec8:	b5e1                	j	ffffffffc0205d90 <do_fork+0xb0>
ffffffffc0205eca:	14843503          	ld	a0,328(s0)
ffffffffc0205ece:	c519                	beqz	a0,ffffffffc0205edc <do_fork+0x1fc>
ffffffffc0205ed0:	491c                	lw	a5,16(a0)
ffffffffc0205ed2:	fff7871b          	addiw	a4,a5,-1
ffffffffc0205ed6:	c918                	sw	a4,16(a0)
ffffffffc0205ed8:	0e070663          	beqz	a4,ffffffffc0205fc4 <do_fork+0x2e4>
ffffffffc0205edc:	54f1                	li	s1,-4
ffffffffc0205ede:	6814                	ld	a3,16(s0)
ffffffffc0205ee0:	c02007b7          	lui	a5,0xc0200
ffffffffc0205ee4:	16f6e763          	bltu	a3,a5,ffffffffc0206052 <do_fork+0x372>
ffffffffc0205ee8:	000d3703          	ld	a4,0(s10)
ffffffffc0205eec:	000cb783          	ld	a5,0(s9)
ffffffffc0205ef0:	8e99                	sub	a3,a3,a4
ffffffffc0205ef2:	82b1                	srli	a3,a3,0xc
ffffffffc0205ef4:	14f6f363          	bgeu	a3,a5,ffffffffc020603a <do_fork+0x35a>
ffffffffc0205ef8:	000c3503          	ld	a0,0(s8)
ffffffffc0205efc:	414686b3          	sub	a3,a3,s4
ffffffffc0205f00:	069a                	slli	a3,a3,0x6
ffffffffc0205f02:	4589                	li	a1,2
ffffffffc0205f04:	9536                	add	a0,a0,a3
ffffffffc0205f06:	c22fb0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0205f0a:	8522                	mv	a0,s0
ffffffffc0205f0c:	967fd0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0205f10:	70e6                	ld	ra,120(sp)
ffffffffc0205f12:	7446                	ld	s0,112(sp)
ffffffffc0205f14:	7906                	ld	s2,96(sp)
ffffffffc0205f16:	69e6                	ld	s3,88(sp)
ffffffffc0205f18:	6a46                	ld	s4,80(sp)
ffffffffc0205f1a:	6aa6                	ld	s5,72(sp)
ffffffffc0205f1c:	6b06                	ld	s6,64(sp)
ffffffffc0205f1e:	7be2                	ld	s7,56(sp)
ffffffffc0205f20:	7c42                	ld	s8,48(sp)
ffffffffc0205f22:	7ca2                	ld	s9,40(sp)
ffffffffc0205f24:	7d02                	ld	s10,32(sp)
ffffffffc0205f26:	6de2                	ld	s11,24(sp)
ffffffffc0205f28:	8526                	mv	a0,s1
ffffffffc0205f2a:	74a6                	ld	s1,104(sp)
ffffffffc0205f2c:	6109                	addi	sp,sp,128
ffffffffc0205f2e:	8082                	ret
ffffffffc0205f30:	c581                	beqz	a1,ffffffffc0205f38 <do_fork+0x258>
ffffffffc0205f32:	00d82023          	sw	a3,0(a6)
ffffffffc0205f36:	8536                	mv	a0,a3
ffffffffc0205f38:	00088463          	beqz	a7,ffffffffc0205f40 <do_fork+0x260>
ffffffffc0205f3c:	00c32023          	sw	a2,0(t1)
ffffffffc0205f40:	c048                	sw	a0,4(s0)
ffffffffc0205f42:	45a9                	li	a1,10
ffffffffc0205f44:	2501                	sext.w	a0,a0
ffffffffc0205f46:	4c0050ef          	jal	ra,ffffffffc020b406 <hash32>
ffffffffc0205f4a:	02051793          	slli	a5,a0,0x20
ffffffffc0205f4e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205f52:	0008c797          	auipc	a5,0x8c
ffffffffc0205f56:	86e78793          	addi	a5,a5,-1938 # ffffffffc02917c0 <hash_list>
ffffffffc0205f5a:	953e                	add	a0,a0,a5
ffffffffc0205f5c:	650c                	ld	a1,8(a0)
ffffffffc0205f5e:	7014                	ld	a3,32(s0)
ffffffffc0205f60:	0d840793          	addi	a5,s0,216
ffffffffc0205f64:	e19c                	sd	a5,0(a1)
ffffffffc0205f66:	6490                	ld	a2,8(s1)
ffffffffc0205f68:	e51c                	sd	a5,8(a0)
ffffffffc0205f6a:	7af8                	ld	a4,240(a3)
ffffffffc0205f6c:	0c840793          	addi	a5,s0,200
ffffffffc0205f70:	f06c                	sd	a1,224(s0)
ffffffffc0205f72:	ec68                	sd	a0,216(s0)
ffffffffc0205f74:	e21c                	sd	a5,0(a2)
ffffffffc0205f76:	e49c                	sd	a5,8(s1)
ffffffffc0205f78:	e870                	sd	a2,208(s0)
ffffffffc0205f7a:	e464                	sd	s1,200(s0)
ffffffffc0205f7c:	0e043c23          	sd	zero,248(s0)
ffffffffc0205f80:	10e43023          	sd	a4,256(s0)
ffffffffc0205f84:	c311                	beqz	a4,ffffffffc0205f88 <do_fork+0x2a8>
ffffffffc0205f86:	ff60                	sd	s0,248(a4)
ffffffffc0205f88:	0009a783          	lw	a5,0(s3)
ffffffffc0205f8c:	8522                	mv	a0,s0
ffffffffc0205f8e:	fae0                	sd	s0,240(a3)
ffffffffc0205f90:	2785                	addiw	a5,a5,1
ffffffffc0205f92:	00f9a023          	sw	a5,0(s3)
ffffffffc0205f96:	100010ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc0205f9a:	85a2                	mv	a1,s0
ffffffffc0205f9c:	854a                	mv	a0,s2
ffffffffc0205f9e:	4044                	lw	s1,4(s0)
ffffffffc0205fa0:	b51ff0ef          	jal	ra,ffffffffc0205af0 <copy_files>
ffffffffc0205fa4:	d535                	beqz	a0,ffffffffc0205f10 <do_fork+0x230>
ffffffffc0205fa6:	bf25                	j	ffffffffc0205ede <do_fork+0x1fe>
ffffffffc0205fa8:	856e                	mv	a0,s11
ffffffffc0205faa:	f2bfc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc0205fae:	54f1                	li	s1,-4
ffffffffc0205fb0:	b73d                	j	ffffffffc0205ede <do_fork+0x1fe>
ffffffffc0205fb2:	4785                	li	a5,1
ffffffffc0205fb4:	00f82023          	sw	a5,0(a6)
ffffffffc0205fb8:	4505                	li	a0,1
ffffffffc0205fba:	0008b317          	auipc	t1,0x8b
ffffffffc0205fbe:	0a230313          	addi	t1,t1,162 # ffffffffc029105c <next_safe.0>
ffffffffc0205fc2:	bd9d                	j	ffffffffc0205e38 <do_fork+0x158>
ffffffffc0205fc4:	859ff0ef          	jal	ra,ffffffffc020581c <files_destroy>
ffffffffc0205fc8:	54f1                	li	s1,-4
ffffffffc0205fca:	bf11                	j	ffffffffc0205ede <do_fork+0x1fe>
ffffffffc0205fcc:	01d6c363          	blt	a3,t4,ffffffffc0205fd2 <do_fork+0x2f2>
ffffffffc0205fd0:	4685                	li	a3,1
ffffffffc0205fd2:	4585                	li	a1,1
ffffffffc0205fd4:	bdb5                	j	ffffffffc0205e50 <do_fork+0x170>
ffffffffc0205fd6:	54f1                	li	s1,-4
ffffffffc0205fd8:	bf0d                	j	ffffffffc0205f0a <do_fork+0x22a>
ffffffffc0205fda:	54ed                	li	s1,-5
ffffffffc0205fdc:	bf15                	j	ffffffffc0205f10 <do_fork+0x230>
ffffffffc0205fde:	856e                	mv	a0,s11
ffffffffc0205fe0:	890fd0ef          	jal	ra,ffffffffc0203070 <exit_mmap>
ffffffffc0205fe4:	018db503          	ld	a0,24(s11)
ffffffffc0205fe8:	54f1                	li	s1,-4
ffffffffc0205fea:	b85ff0ef          	jal	ra,ffffffffc0205b6e <put_pgdir.isra.0>
ffffffffc0205fee:	856e                	mv	a0,s11
ffffffffc0205ff0:	ee5fc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc0205ff4:	b5ed                	j	ffffffffc0205ede <do_fork+0x1fe>
ffffffffc0205ff6:	54f1                	li	s1,-4
ffffffffc0205ff8:	bf21                	j	ffffffffc0205f10 <do_fork+0x230>
ffffffffc0205ffa:	c589                	beqz	a1,ffffffffc0206004 <do_fork+0x324>
ffffffffc0205ffc:	00d82023          	sw	a3,0(a6)
ffffffffc0206000:	8536                	mv	a0,a3
ffffffffc0206002:	bf3d                	j	ffffffffc0205f40 <do_fork+0x260>
ffffffffc0206004:	00082503          	lw	a0,0(a6)
ffffffffc0206008:	bf25                	j	ffffffffc0205f40 <do_fork+0x260>
ffffffffc020600a:	00006617          	auipc	a2,0x6
ffffffffc020600e:	02660613          	addi	a2,a2,38 # ffffffffc020c030 <commands+0x968>
ffffffffc0206012:	07100593          	li	a1,113
ffffffffc0206016:	00006517          	auipc	a0,0x6
ffffffffc020601a:	fe250513          	addi	a0,a0,-30 # ffffffffc020bff8 <commands+0x930>
ffffffffc020601e:	a10fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206022:	00006617          	auipc	a2,0x6
ffffffffc0206026:	12e60613          	addi	a2,a2,302 # ffffffffc020c150 <commands+0xa88>
ffffffffc020602a:	1be00593          	li	a1,446
ffffffffc020602e:	00007517          	auipc	a0,0x7
ffffffffc0206032:	38250513          	addi	a0,a0,898 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206036:	9f8fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020603a:	00006617          	auipc	a2,0x6
ffffffffc020603e:	f9e60613          	addi	a2,a2,-98 # ffffffffc020bfd8 <commands+0x910>
ffffffffc0206042:	06900593          	li	a1,105
ffffffffc0206046:	00006517          	auipc	a0,0x6
ffffffffc020604a:	fb250513          	addi	a0,a0,-78 # ffffffffc020bff8 <commands+0x930>
ffffffffc020604e:	9e0fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206052:	00006617          	auipc	a2,0x6
ffffffffc0206056:	0fe60613          	addi	a2,a2,254 # ffffffffc020c150 <commands+0xa88>
ffffffffc020605a:	07700593          	li	a1,119
ffffffffc020605e:	00006517          	auipc	a0,0x6
ffffffffc0206062:	f9a50513          	addi	a0,a0,-102 # ffffffffc020bff8 <commands+0x930>
ffffffffc0206066:	9c8fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020606a <kernel_thread>:
ffffffffc020606a:	7129                	addi	sp,sp,-320
ffffffffc020606c:	fa22                	sd	s0,304(sp)
ffffffffc020606e:	f626                	sd	s1,296(sp)
ffffffffc0206070:	f24a                	sd	s2,288(sp)
ffffffffc0206072:	84ae                	mv	s1,a1
ffffffffc0206074:	892a                	mv	s2,a0
ffffffffc0206076:	8432                	mv	s0,a2
ffffffffc0206078:	4581                	li	a1,0
ffffffffc020607a:	12000613          	li	a2,288
ffffffffc020607e:	850a                	mv	a0,sp
ffffffffc0206080:	fe06                	sd	ra,312(sp)
ffffffffc0206082:	69f040ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0206086:	e0ca                	sd	s2,64(sp)
ffffffffc0206088:	e4a6                	sd	s1,72(sp)
ffffffffc020608a:	100027f3          	csrr	a5,sstatus
ffffffffc020608e:	edd7f793          	andi	a5,a5,-291
ffffffffc0206092:	1207e793          	ori	a5,a5,288
ffffffffc0206096:	e23e                	sd	a5,256(sp)
ffffffffc0206098:	860a                	mv	a2,sp
ffffffffc020609a:	10046513          	ori	a0,s0,256
ffffffffc020609e:	00000797          	auipc	a5,0x0
ffffffffc02060a2:	9a278793          	addi	a5,a5,-1630 # ffffffffc0205a40 <kernel_thread_entry>
ffffffffc02060a6:	4581                	li	a1,0
ffffffffc02060a8:	e63e                	sd	a5,264(sp)
ffffffffc02060aa:	c37ff0ef          	jal	ra,ffffffffc0205ce0 <do_fork>
ffffffffc02060ae:	70f2                	ld	ra,312(sp)
ffffffffc02060b0:	7452                	ld	s0,304(sp)
ffffffffc02060b2:	74b2                	ld	s1,296(sp)
ffffffffc02060b4:	7912                	ld	s2,288(sp)
ffffffffc02060b6:	6131                	addi	sp,sp,320
ffffffffc02060b8:	8082                	ret

ffffffffc02060ba <do_exit>:
ffffffffc02060ba:	7179                	addi	sp,sp,-48
ffffffffc02060bc:	f022                	sd	s0,32(sp)
ffffffffc02060be:	00091417          	auipc	s0,0x91
ffffffffc02060c2:	80240413          	addi	s0,s0,-2046 # ffffffffc02968c0 <current>
ffffffffc02060c6:	601c                	ld	a5,0(s0)
ffffffffc02060c8:	f406                	sd	ra,40(sp)
ffffffffc02060ca:	ec26                	sd	s1,24(sp)
ffffffffc02060cc:	e84a                	sd	s2,16(sp)
ffffffffc02060ce:	e44e                	sd	s3,8(sp)
ffffffffc02060d0:	e052                	sd	s4,0(sp)
ffffffffc02060d2:	00090717          	auipc	a4,0x90
ffffffffc02060d6:	7f673703          	ld	a4,2038(a4) # ffffffffc02968c8 <idleproc>
ffffffffc02060da:	0ee78763          	beq	a5,a4,ffffffffc02061c8 <do_exit+0x10e>
ffffffffc02060de:	00090497          	auipc	s1,0x90
ffffffffc02060e2:	7f248493          	addi	s1,s1,2034 # ffffffffc02968d0 <initproc>
ffffffffc02060e6:	6098                	ld	a4,0(s1)
ffffffffc02060e8:	10e78763          	beq	a5,a4,ffffffffc02061f6 <do_exit+0x13c>
ffffffffc02060ec:	0287b983          	ld	s3,40(a5)
ffffffffc02060f0:	892a                	mv	s2,a0
ffffffffc02060f2:	02098e63          	beqz	s3,ffffffffc020612e <do_exit+0x74>
ffffffffc02060f6:	00090797          	auipc	a5,0x90
ffffffffc02060fa:	7927b783          	ld	a5,1938(a5) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc02060fe:	577d                	li	a4,-1
ffffffffc0206100:	177e                	slli	a4,a4,0x3f
ffffffffc0206102:	83b1                	srli	a5,a5,0xc
ffffffffc0206104:	8fd9                	or	a5,a5,a4
ffffffffc0206106:	18079073          	csrw	satp,a5
ffffffffc020610a:	0309a783          	lw	a5,48(s3)
ffffffffc020610e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206112:	02e9a823          	sw	a4,48(s3)
ffffffffc0206116:	c769                	beqz	a4,ffffffffc02061e0 <do_exit+0x126>
ffffffffc0206118:	601c                	ld	a5,0(s0)
ffffffffc020611a:	1487b503          	ld	a0,328(a5)
ffffffffc020611e:	0207b423          	sd	zero,40(a5)
ffffffffc0206122:	c511                	beqz	a0,ffffffffc020612e <do_exit+0x74>
ffffffffc0206124:	491c                	lw	a5,16(a0)
ffffffffc0206126:	fff7871b          	addiw	a4,a5,-1
ffffffffc020612a:	c918                	sw	a4,16(a0)
ffffffffc020612c:	cb59                	beqz	a4,ffffffffc02061c2 <do_exit+0x108>
ffffffffc020612e:	601c                	ld	a5,0(s0)
ffffffffc0206130:	470d                	li	a4,3
ffffffffc0206132:	c398                	sw	a4,0(a5)
ffffffffc0206134:	0f27a423          	sw	s2,232(a5)
ffffffffc0206138:	100027f3          	csrr	a5,sstatus
ffffffffc020613c:	8b89                	andi	a5,a5,2
ffffffffc020613e:	4a01                	li	s4,0
ffffffffc0206140:	e7f9                	bnez	a5,ffffffffc020620e <do_exit+0x154>
ffffffffc0206142:	6018                	ld	a4,0(s0)
ffffffffc0206144:	800007b7          	lui	a5,0x80000
ffffffffc0206148:	0785                	addi	a5,a5,1
ffffffffc020614a:	7308                	ld	a0,32(a4)
ffffffffc020614c:	0ec52703          	lw	a4,236(a0)
ffffffffc0206150:	0cf70363          	beq	a4,a5,ffffffffc0206216 <do_exit+0x15c>
ffffffffc0206154:	6018                	ld	a4,0(s0)
ffffffffc0206156:	7b7c                	ld	a5,240(a4)
ffffffffc0206158:	c3a1                	beqz	a5,ffffffffc0206198 <do_exit+0xde>
ffffffffc020615a:	800009b7          	lui	s3,0x80000
ffffffffc020615e:	490d                	li	s2,3
ffffffffc0206160:	0985                	addi	s3,s3,1
ffffffffc0206162:	a021                	j	ffffffffc020616a <do_exit+0xb0>
ffffffffc0206164:	6018                	ld	a4,0(s0)
ffffffffc0206166:	7b7c                	ld	a5,240(a4)
ffffffffc0206168:	cb85                	beqz	a5,ffffffffc0206198 <do_exit+0xde>
ffffffffc020616a:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc020616e:	6088                	ld	a0,0(s1)
ffffffffc0206170:	fb74                	sd	a3,240(a4)
ffffffffc0206172:	7978                	ld	a4,240(a0)
ffffffffc0206174:	0e07bc23          	sd	zero,248(a5)
ffffffffc0206178:	10e7b023          	sd	a4,256(a5)
ffffffffc020617c:	c311                	beqz	a4,ffffffffc0206180 <do_exit+0xc6>
ffffffffc020617e:	ff7c                	sd	a5,248(a4)
ffffffffc0206180:	4398                	lw	a4,0(a5)
ffffffffc0206182:	f388                	sd	a0,32(a5)
ffffffffc0206184:	f97c                	sd	a5,240(a0)
ffffffffc0206186:	fd271fe3          	bne	a4,s2,ffffffffc0206164 <do_exit+0xaa>
ffffffffc020618a:	0ec52783          	lw	a5,236(a0)
ffffffffc020618e:	fd379be3          	bne	a5,s3,ffffffffc0206164 <do_exit+0xaa>
ffffffffc0206192:	705000ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc0206196:	b7f9                	j	ffffffffc0206164 <do_exit+0xaa>
ffffffffc0206198:	020a1263          	bnez	s4,ffffffffc02061bc <do_exit+0x102>
ffffffffc020619c:	7ad000ef          	jal	ra,ffffffffc0207148 <schedule>
ffffffffc02061a0:	601c                	ld	a5,0(s0)
ffffffffc02061a2:	00007617          	auipc	a2,0x7
ffffffffc02061a6:	24660613          	addi	a2,a2,582 # ffffffffc020d3e8 <CSWTCH.79+0x118>
ffffffffc02061aa:	2aa00593          	li	a1,682
ffffffffc02061ae:	43d4                	lw	a3,4(a5)
ffffffffc02061b0:	00007517          	auipc	a0,0x7
ffffffffc02061b4:	20050513          	addi	a0,a0,512 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc02061b8:	876fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02061bc:	bdffa0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02061c0:	bff1                	j	ffffffffc020619c <do_exit+0xe2>
ffffffffc02061c2:	e5aff0ef          	jal	ra,ffffffffc020581c <files_destroy>
ffffffffc02061c6:	b7a5                	j	ffffffffc020612e <do_exit+0x74>
ffffffffc02061c8:	00007617          	auipc	a2,0x7
ffffffffc02061cc:	20060613          	addi	a2,a2,512 # ffffffffc020d3c8 <CSWTCH.79+0xf8>
ffffffffc02061d0:	27500593          	li	a1,629
ffffffffc02061d4:	00007517          	auipc	a0,0x7
ffffffffc02061d8:	1dc50513          	addi	a0,a0,476 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc02061dc:	852fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02061e0:	854e                	mv	a0,s3
ffffffffc02061e2:	e8ffc0ef          	jal	ra,ffffffffc0203070 <exit_mmap>
ffffffffc02061e6:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc02061ea:	985ff0ef          	jal	ra,ffffffffc0205b6e <put_pgdir.isra.0>
ffffffffc02061ee:	854e                	mv	a0,s3
ffffffffc02061f0:	ce5fc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc02061f4:	b715                	j	ffffffffc0206118 <do_exit+0x5e>
ffffffffc02061f6:	00007617          	auipc	a2,0x7
ffffffffc02061fa:	1e260613          	addi	a2,a2,482 # ffffffffc020d3d8 <CSWTCH.79+0x108>
ffffffffc02061fe:	27900593          	li	a1,633
ffffffffc0206202:	00007517          	auipc	a0,0x7
ffffffffc0206206:	1ae50513          	addi	a0,a0,430 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc020620a:	824fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020620e:	b93fa0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0206212:	4a05                	li	s4,1
ffffffffc0206214:	b73d                	j	ffffffffc0206142 <do_exit+0x88>
ffffffffc0206216:	681000ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc020621a:	bf2d                	j	ffffffffc0206154 <do_exit+0x9a>

ffffffffc020621c <do_wait.part.0>:
ffffffffc020621c:	715d                	addi	sp,sp,-80
ffffffffc020621e:	f84a                	sd	s2,48(sp)
ffffffffc0206220:	f44e                	sd	s3,40(sp)
ffffffffc0206222:	80000937          	lui	s2,0x80000
ffffffffc0206226:	6989                	lui	s3,0x2
ffffffffc0206228:	fc26                	sd	s1,56(sp)
ffffffffc020622a:	f052                	sd	s4,32(sp)
ffffffffc020622c:	ec56                	sd	s5,24(sp)
ffffffffc020622e:	e85a                	sd	s6,16(sp)
ffffffffc0206230:	e45e                	sd	s7,8(sp)
ffffffffc0206232:	e486                	sd	ra,72(sp)
ffffffffc0206234:	e0a2                	sd	s0,64(sp)
ffffffffc0206236:	84aa                	mv	s1,a0
ffffffffc0206238:	8a2e                	mv	s4,a1
ffffffffc020623a:	00090b97          	auipc	s7,0x90
ffffffffc020623e:	686b8b93          	addi	s7,s7,1670 # ffffffffc02968c0 <current>
ffffffffc0206242:	00050b1b          	sext.w	s6,a0
ffffffffc0206246:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020624a:	19f9                	addi	s3,s3,-2
ffffffffc020624c:	0905                	addi	s2,s2,1
ffffffffc020624e:	ccbd                	beqz	s1,ffffffffc02062cc <do_wait.part.0+0xb0>
ffffffffc0206250:	0359e863          	bltu	s3,s5,ffffffffc0206280 <do_wait.part.0+0x64>
ffffffffc0206254:	45a9                	li	a1,10
ffffffffc0206256:	855a                	mv	a0,s6
ffffffffc0206258:	1ae050ef          	jal	ra,ffffffffc020b406 <hash32>
ffffffffc020625c:	02051793          	slli	a5,a0,0x20
ffffffffc0206260:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206264:	0008b797          	auipc	a5,0x8b
ffffffffc0206268:	55c78793          	addi	a5,a5,1372 # ffffffffc02917c0 <hash_list>
ffffffffc020626c:	953e                	add	a0,a0,a5
ffffffffc020626e:	842a                	mv	s0,a0
ffffffffc0206270:	a029                	j	ffffffffc020627a <do_wait.part.0+0x5e>
ffffffffc0206272:	f2c42783          	lw	a5,-212(s0)
ffffffffc0206276:	02978163          	beq	a5,s1,ffffffffc0206298 <do_wait.part.0+0x7c>
ffffffffc020627a:	6400                	ld	s0,8(s0)
ffffffffc020627c:	fe851be3          	bne	a0,s0,ffffffffc0206272 <do_wait.part.0+0x56>
ffffffffc0206280:	5579                	li	a0,-2
ffffffffc0206282:	60a6                	ld	ra,72(sp)
ffffffffc0206284:	6406                	ld	s0,64(sp)
ffffffffc0206286:	74e2                	ld	s1,56(sp)
ffffffffc0206288:	7942                	ld	s2,48(sp)
ffffffffc020628a:	79a2                	ld	s3,40(sp)
ffffffffc020628c:	7a02                	ld	s4,32(sp)
ffffffffc020628e:	6ae2                	ld	s5,24(sp)
ffffffffc0206290:	6b42                	ld	s6,16(sp)
ffffffffc0206292:	6ba2                	ld	s7,8(sp)
ffffffffc0206294:	6161                	addi	sp,sp,80
ffffffffc0206296:	8082                	ret
ffffffffc0206298:	000bb683          	ld	a3,0(s7)
ffffffffc020629c:	f4843783          	ld	a5,-184(s0)
ffffffffc02062a0:	fed790e3          	bne	a5,a3,ffffffffc0206280 <do_wait.part.0+0x64>
ffffffffc02062a4:	f2842703          	lw	a4,-216(s0)
ffffffffc02062a8:	478d                	li	a5,3
ffffffffc02062aa:	0ef70b63          	beq	a4,a5,ffffffffc02063a0 <do_wait.part.0+0x184>
ffffffffc02062ae:	4785                	li	a5,1
ffffffffc02062b0:	c29c                	sw	a5,0(a3)
ffffffffc02062b2:	0f26a623          	sw	s2,236(a3)
ffffffffc02062b6:	693000ef          	jal	ra,ffffffffc0207148 <schedule>
ffffffffc02062ba:	000bb783          	ld	a5,0(s7)
ffffffffc02062be:	0b07a783          	lw	a5,176(a5)
ffffffffc02062c2:	8b85                	andi	a5,a5,1
ffffffffc02062c4:	d7c9                	beqz	a5,ffffffffc020624e <do_wait.part.0+0x32>
ffffffffc02062c6:	555d                	li	a0,-9
ffffffffc02062c8:	df3ff0ef          	jal	ra,ffffffffc02060ba <do_exit>
ffffffffc02062cc:	000bb683          	ld	a3,0(s7)
ffffffffc02062d0:	7ae0                	ld	s0,240(a3)
ffffffffc02062d2:	d45d                	beqz	s0,ffffffffc0206280 <do_wait.part.0+0x64>
ffffffffc02062d4:	470d                	li	a4,3
ffffffffc02062d6:	a021                	j	ffffffffc02062de <do_wait.part.0+0xc2>
ffffffffc02062d8:	10043403          	ld	s0,256(s0)
ffffffffc02062dc:	d869                	beqz	s0,ffffffffc02062ae <do_wait.part.0+0x92>
ffffffffc02062de:	401c                	lw	a5,0(s0)
ffffffffc02062e0:	fee79ce3          	bne	a5,a4,ffffffffc02062d8 <do_wait.part.0+0xbc>
ffffffffc02062e4:	00090797          	auipc	a5,0x90
ffffffffc02062e8:	5e47b783          	ld	a5,1508(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02062ec:	0c878963          	beq	a5,s0,ffffffffc02063be <do_wait.part.0+0x1a2>
ffffffffc02062f0:	00090797          	auipc	a5,0x90
ffffffffc02062f4:	5e07b783          	ld	a5,1504(a5) # ffffffffc02968d0 <initproc>
ffffffffc02062f8:	0cf40363          	beq	s0,a5,ffffffffc02063be <do_wait.part.0+0x1a2>
ffffffffc02062fc:	000a0663          	beqz	s4,ffffffffc0206308 <do_wait.part.0+0xec>
ffffffffc0206300:	0e842783          	lw	a5,232(s0)
ffffffffc0206304:	00fa2023          	sw	a5,0(s4)
ffffffffc0206308:	100027f3          	csrr	a5,sstatus
ffffffffc020630c:	8b89                	andi	a5,a5,2
ffffffffc020630e:	4581                	li	a1,0
ffffffffc0206310:	e7c1                	bnez	a5,ffffffffc0206398 <do_wait.part.0+0x17c>
ffffffffc0206312:	6c70                	ld	a2,216(s0)
ffffffffc0206314:	7074                	ld	a3,224(s0)
ffffffffc0206316:	10043703          	ld	a4,256(s0)
ffffffffc020631a:	7c7c                	ld	a5,248(s0)
ffffffffc020631c:	e614                	sd	a3,8(a2)
ffffffffc020631e:	e290                	sd	a2,0(a3)
ffffffffc0206320:	6470                	ld	a2,200(s0)
ffffffffc0206322:	6874                	ld	a3,208(s0)
ffffffffc0206324:	e614                	sd	a3,8(a2)
ffffffffc0206326:	e290                	sd	a2,0(a3)
ffffffffc0206328:	c319                	beqz	a4,ffffffffc020632e <do_wait.part.0+0x112>
ffffffffc020632a:	ff7c                	sd	a5,248(a4)
ffffffffc020632c:	7c7c                	ld	a5,248(s0)
ffffffffc020632e:	c3b5                	beqz	a5,ffffffffc0206392 <do_wait.part.0+0x176>
ffffffffc0206330:	10e7b023          	sd	a4,256(a5)
ffffffffc0206334:	00090717          	auipc	a4,0x90
ffffffffc0206338:	5a470713          	addi	a4,a4,1444 # ffffffffc02968d8 <nr_process>
ffffffffc020633c:	431c                	lw	a5,0(a4)
ffffffffc020633e:	37fd                	addiw	a5,a5,-1
ffffffffc0206340:	c31c                	sw	a5,0(a4)
ffffffffc0206342:	e5a9                	bnez	a1,ffffffffc020638c <do_wait.part.0+0x170>
ffffffffc0206344:	6814                	ld	a3,16(s0)
ffffffffc0206346:	c02007b7          	lui	a5,0xc0200
ffffffffc020634a:	04f6ee63          	bltu	a3,a5,ffffffffc02063a6 <do_wait.part.0+0x18a>
ffffffffc020634e:	00090797          	auipc	a5,0x90
ffffffffc0206352:	5627b783          	ld	a5,1378(a5) # ffffffffc02968b0 <va_pa_offset>
ffffffffc0206356:	8e9d                	sub	a3,a3,a5
ffffffffc0206358:	82b1                	srli	a3,a3,0xc
ffffffffc020635a:	00090797          	auipc	a5,0x90
ffffffffc020635e:	53e7b783          	ld	a5,1342(a5) # ffffffffc0296898 <npage>
ffffffffc0206362:	06f6fa63          	bgeu	a3,a5,ffffffffc02063d6 <do_wait.part.0+0x1ba>
ffffffffc0206366:	00009517          	auipc	a0,0x9
ffffffffc020636a:	24a53503          	ld	a0,586(a0) # ffffffffc020f5b0 <nbase>
ffffffffc020636e:	8e89                	sub	a3,a3,a0
ffffffffc0206370:	069a                	slli	a3,a3,0x6
ffffffffc0206372:	00090517          	auipc	a0,0x90
ffffffffc0206376:	52e53503          	ld	a0,1326(a0) # ffffffffc02968a0 <pages>
ffffffffc020637a:	9536                	add	a0,a0,a3
ffffffffc020637c:	4589                	li	a1,2
ffffffffc020637e:	fabfa0ef          	jal	ra,ffffffffc0201328 <free_pages>
ffffffffc0206382:	8522                	mv	a0,s0
ffffffffc0206384:	ceefd0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0206388:	4501                	li	a0,0
ffffffffc020638a:	bde5                	j	ffffffffc0206282 <do_wait.part.0+0x66>
ffffffffc020638c:	a0ffa0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0206390:	bf55                	j	ffffffffc0206344 <do_wait.part.0+0x128>
ffffffffc0206392:	701c                	ld	a5,32(s0)
ffffffffc0206394:	fbf8                	sd	a4,240(a5)
ffffffffc0206396:	bf79                	j	ffffffffc0206334 <do_wait.part.0+0x118>
ffffffffc0206398:	a09fa0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020639c:	4585                	li	a1,1
ffffffffc020639e:	bf95                	j	ffffffffc0206312 <do_wait.part.0+0xf6>
ffffffffc02063a0:	f2840413          	addi	s0,s0,-216
ffffffffc02063a4:	b781                	j	ffffffffc02062e4 <do_wait.part.0+0xc8>
ffffffffc02063a6:	00006617          	auipc	a2,0x6
ffffffffc02063aa:	daa60613          	addi	a2,a2,-598 # ffffffffc020c150 <commands+0xa88>
ffffffffc02063ae:	07700593          	li	a1,119
ffffffffc02063b2:	00006517          	auipc	a0,0x6
ffffffffc02063b6:	c4650513          	addi	a0,a0,-954 # ffffffffc020bff8 <commands+0x930>
ffffffffc02063ba:	e75f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02063be:	00007617          	auipc	a2,0x7
ffffffffc02063c2:	04a60613          	addi	a2,a2,74 # ffffffffc020d408 <CSWTCH.79+0x138>
ffffffffc02063c6:	43000593          	li	a1,1072
ffffffffc02063ca:	00007517          	auipc	a0,0x7
ffffffffc02063ce:	fe650513          	addi	a0,a0,-26 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc02063d2:	e5df90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02063d6:	00006617          	auipc	a2,0x6
ffffffffc02063da:	c0260613          	addi	a2,a2,-1022 # ffffffffc020bfd8 <commands+0x910>
ffffffffc02063de:	06900593          	li	a1,105
ffffffffc02063e2:	00006517          	auipc	a0,0x6
ffffffffc02063e6:	c1650513          	addi	a0,a0,-1002 # ffffffffc020bff8 <commands+0x930>
ffffffffc02063ea:	e45f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02063ee <init_main>:
ffffffffc02063ee:	1141                	addi	sp,sp,-16
ffffffffc02063f0:	00007517          	auipc	a0,0x7
ffffffffc02063f4:	03850513          	addi	a0,a0,56 # ffffffffc020d428 <CSWTCH.79+0x158>
ffffffffc02063f8:	e406                	sd	ra,8(sp)
ffffffffc02063fa:	721010ef          	jal	ra,ffffffffc020831a <vfs_set_bootfs>
ffffffffc02063fe:	e179                	bnez	a0,ffffffffc02064c4 <init_main+0xd6>
ffffffffc0206400:	f69fa0ef          	jal	ra,ffffffffc0201368 <nr_free_pages>
ffffffffc0206404:	bbafd0ef          	jal	ra,ffffffffc02037be <kallocated>
ffffffffc0206408:	4601                	li	a2,0
ffffffffc020640a:	4581                	li	a1,0
ffffffffc020640c:	00001517          	auipc	a0,0x1
ffffffffc0206410:	83650513          	addi	a0,a0,-1994 # ffffffffc0206c42 <user_main>
ffffffffc0206414:	c57ff0ef          	jal	ra,ffffffffc020606a <kernel_thread>
ffffffffc0206418:	00a04563          	bgtz	a0,ffffffffc0206422 <init_main+0x34>
ffffffffc020641c:	a841                	j	ffffffffc02064ac <init_main+0xbe>
ffffffffc020641e:	52b000ef          	jal	ra,ffffffffc0207148 <schedule>
ffffffffc0206422:	4581                	li	a1,0
ffffffffc0206424:	4501                	li	a0,0
ffffffffc0206426:	df7ff0ef          	jal	ra,ffffffffc020621c <do_wait.part.0>
ffffffffc020642a:	d975                	beqz	a0,ffffffffc020641e <init_main+0x30>
ffffffffc020642c:	baaff0ef          	jal	ra,ffffffffc02057d6 <fs_cleanup>
ffffffffc0206430:	00007517          	auipc	a0,0x7
ffffffffc0206434:	04050513          	addi	a0,a0,64 # ffffffffc020d470 <CSWTCH.79+0x1a0>
ffffffffc0206438:	cf3f90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020643c:	00090797          	auipc	a5,0x90
ffffffffc0206440:	4947b783          	ld	a5,1172(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206444:	7bf8                	ld	a4,240(a5)
ffffffffc0206446:	e339                	bnez	a4,ffffffffc020648c <init_main+0x9e>
ffffffffc0206448:	7ff8                	ld	a4,248(a5)
ffffffffc020644a:	e329                	bnez	a4,ffffffffc020648c <init_main+0x9e>
ffffffffc020644c:	1007b703          	ld	a4,256(a5)
ffffffffc0206450:	ef15                	bnez	a4,ffffffffc020648c <init_main+0x9e>
ffffffffc0206452:	00090697          	auipc	a3,0x90
ffffffffc0206456:	4866a683          	lw	a3,1158(a3) # ffffffffc02968d8 <nr_process>
ffffffffc020645a:	4709                	li	a4,2
ffffffffc020645c:	0ce69163          	bne	a3,a4,ffffffffc020651e <init_main+0x130>
ffffffffc0206460:	0008f717          	auipc	a4,0x8f
ffffffffc0206464:	36070713          	addi	a4,a4,864 # ffffffffc02957c0 <proc_list>
ffffffffc0206468:	6714                	ld	a3,8(a4)
ffffffffc020646a:	0c878793          	addi	a5,a5,200
ffffffffc020646e:	08d79863          	bne	a5,a3,ffffffffc02064fe <init_main+0x110>
ffffffffc0206472:	6318                	ld	a4,0(a4)
ffffffffc0206474:	06e79563          	bne	a5,a4,ffffffffc02064de <init_main+0xf0>
ffffffffc0206478:	00007517          	auipc	a0,0x7
ffffffffc020647c:	0e050513          	addi	a0,a0,224 # ffffffffc020d558 <CSWTCH.79+0x288>
ffffffffc0206480:	cabf90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0206484:	60a2                	ld	ra,8(sp)
ffffffffc0206486:	4501                	li	a0,0
ffffffffc0206488:	0141                	addi	sp,sp,16
ffffffffc020648a:	8082                	ret
ffffffffc020648c:	00007697          	auipc	a3,0x7
ffffffffc0206490:	00c68693          	addi	a3,a3,12 # ffffffffc020d498 <CSWTCH.79+0x1c8>
ffffffffc0206494:	00005617          	auipc	a2,0x5
ffffffffc0206498:	48460613          	addi	a2,a2,1156 # ffffffffc020b918 <commands+0x250>
ffffffffc020649c:	4a600593          	li	a1,1190
ffffffffc02064a0:	00007517          	auipc	a0,0x7
ffffffffc02064a4:	f1050513          	addi	a0,a0,-240 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc02064a8:	d87f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064ac:	00007617          	auipc	a2,0x7
ffffffffc02064b0:	fa460613          	addi	a2,a2,-92 # ffffffffc020d450 <CSWTCH.79+0x180>
ffffffffc02064b4:	49900593          	li	a1,1177
ffffffffc02064b8:	00007517          	auipc	a0,0x7
ffffffffc02064bc:	ef850513          	addi	a0,a0,-264 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc02064c0:	d6ff90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064c4:	86aa                	mv	a3,a0
ffffffffc02064c6:	00007617          	auipc	a2,0x7
ffffffffc02064ca:	f6a60613          	addi	a2,a2,-150 # ffffffffc020d430 <CSWTCH.79+0x160>
ffffffffc02064ce:	49100593          	li	a1,1169
ffffffffc02064d2:	00007517          	auipc	a0,0x7
ffffffffc02064d6:	ede50513          	addi	a0,a0,-290 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc02064da:	d55f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064de:	00007697          	auipc	a3,0x7
ffffffffc02064e2:	04a68693          	addi	a3,a3,74 # ffffffffc020d528 <CSWTCH.79+0x258>
ffffffffc02064e6:	00005617          	auipc	a2,0x5
ffffffffc02064ea:	43260613          	addi	a2,a2,1074 # ffffffffc020b918 <commands+0x250>
ffffffffc02064ee:	4a900593          	li	a1,1193
ffffffffc02064f2:	00007517          	auipc	a0,0x7
ffffffffc02064f6:	ebe50513          	addi	a0,a0,-322 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc02064fa:	d35f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064fe:	00007697          	auipc	a3,0x7
ffffffffc0206502:	ffa68693          	addi	a3,a3,-6 # ffffffffc020d4f8 <CSWTCH.79+0x228>
ffffffffc0206506:	00005617          	auipc	a2,0x5
ffffffffc020650a:	41260613          	addi	a2,a2,1042 # ffffffffc020b918 <commands+0x250>
ffffffffc020650e:	4a800593          	li	a1,1192
ffffffffc0206512:	00007517          	auipc	a0,0x7
ffffffffc0206516:	e9e50513          	addi	a0,a0,-354 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc020651a:	d15f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020651e:	00007697          	auipc	a3,0x7
ffffffffc0206522:	fca68693          	addi	a3,a3,-54 # ffffffffc020d4e8 <CSWTCH.79+0x218>
ffffffffc0206526:	00005617          	auipc	a2,0x5
ffffffffc020652a:	3f260613          	addi	a2,a2,1010 # ffffffffc020b918 <commands+0x250>
ffffffffc020652e:	4a700593          	li	a1,1191
ffffffffc0206532:	00007517          	auipc	a0,0x7
ffffffffc0206536:	e7e50513          	addi	a0,a0,-386 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc020653a:	cf5f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020653e <do_execve>:
ffffffffc020653e:	ca010113          	addi	sp,sp,-864
ffffffffc0206542:	31713c23          	sd	s7,792(sp)
ffffffffc0206546:	00090b97          	auipc	s7,0x90
ffffffffc020654a:	37ab8b93          	addi	s7,s7,890 # ffffffffc02968c0 <current>
ffffffffc020654e:	000bb683          	ld	a3,0(s7)
ffffffffc0206552:	fff5871b          	addiw	a4,a1,-1
ffffffffc0206556:	33513423          	sd	s5,808(sp)
ffffffffc020655a:	34113c23          	sd	ra,856(sp)
ffffffffc020655e:	34813823          	sd	s0,848(sp)
ffffffffc0206562:	34913423          	sd	s1,840(sp)
ffffffffc0206566:	35213023          	sd	s2,832(sp)
ffffffffc020656a:	33313c23          	sd	s3,824(sp)
ffffffffc020656e:	33413823          	sd	s4,816(sp)
ffffffffc0206572:	33613023          	sd	s6,800(sp)
ffffffffc0206576:	31813823          	sd	s8,784(sp)
ffffffffc020657a:	31913423          	sd	s9,776(sp)
ffffffffc020657e:	31a13023          	sd	s10,768(sp)
ffffffffc0206582:	2fb13c23          	sd	s11,760(sp)
ffffffffc0206586:	c83a                	sw	a4,16(sp)
ffffffffc0206588:	47fd                	li	a5,31
ffffffffc020658a:	0286ba83          	ld	s5,40(a3)
ffffffffc020658e:	58e7e263          	bltu	a5,a4,ffffffffc0206b12 <do_execve+0x5d4>
ffffffffc0206592:	892e                	mv	s2,a1
ffffffffc0206594:	842a                	mv	s0,a0
ffffffffc0206596:	8c32                	mv	s8,a2
ffffffffc0206598:	4581                	li	a1,0
ffffffffc020659a:	4641                	li	a2,16
ffffffffc020659c:	1088                	addi	a0,sp,96
ffffffffc020659e:	183040ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc02065a2:	000a8c63          	beqz	s5,ffffffffc02065ba <do_execve+0x7c>
ffffffffc02065a6:	038a8513          	addi	a0,s5,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc02065aa:	9a0fe0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc02065ae:	000bb783          	ld	a5,0(s7)
ffffffffc02065b2:	c781                	beqz	a5,ffffffffc02065ba <do_execve+0x7c>
ffffffffc02065b4:	43dc                	lw	a5,4(a5)
ffffffffc02065b6:	04faa823          	sw	a5,80(s5)
ffffffffc02065ba:	20040163          	beqz	s0,ffffffffc02067bc <do_execve+0x27e>
ffffffffc02065be:	46c1                	li	a3,16
ffffffffc02065c0:	8622                	mv	a2,s0
ffffffffc02065c2:	108c                	addi	a1,sp,96
ffffffffc02065c4:	8556                	mv	a0,s5
ffffffffc02065c6:	f45fc0ef          	jal	ra,ffffffffc020350a <copy_string>
ffffffffc02065ca:	54050c63          	beqz	a0,ffffffffc0206b22 <do_execve+0x5e4>
ffffffffc02065ce:	00391793          	slli	a5,s2,0x3
ffffffffc02065d2:	4681                	li	a3,0
ffffffffc02065d4:	863e                	mv	a2,a5
ffffffffc02065d6:	85e2                	mv	a1,s8
ffffffffc02065d8:	8556                	mv	a0,s5
ffffffffc02065da:	f03e                	sd	a5,32(sp)
ffffffffc02065dc:	e35fc0ef          	jal	ra,ffffffffc0203410 <user_mem_check>
ffffffffc02065e0:	8a62                	mv	s4,s8
ffffffffc02065e2:	52050c63          	beqz	a0,ffffffffc0206b1a <do_execve+0x5dc>
ffffffffc02065e6:	11a0                	addi	s0,sp,232
ffffffffc02065e8:	8b22                	mv	s6,s0
ffffffffc02065ea:	4481                	li	s1,0
ffffffffc02065ec:	a011                	j	ffffffffc02065f0 <do_execve+0xb2>
ffffffffc02065ee:	84be                	mv	s1,a5
ffffffffc02065f0:	6505                	lui	a0,0x1
ffffffffc02065f2:	9d0fd0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02065f6:	89aa                	mv	s3,a0
ffffffffc02065f8:	c171                	beqz	a0,ffffffffc02066bc <do_execve+0x17e>
ffffffffc02065fa:	000a3603          	ld	a2,0(s4)
ffffffffc02065fe:	85aa                	mv	a1,a0
ffffffffc0206600:	6685                	lui	a3,0x1
ffffffffc0206602:	8556                	mv	a0,s5
ffffffffc0206604:	f07fc0ef          	jal	ra,ffffffffc020350a <copy_string>
ffffffffc0206608:	1a050563          	beqz	a0,ffffffffc02067b2 <do_execve+0x274>
ffffffffc020660c:	013b3023          	sd	s3,0(s6)
ffffffffc0206610:	0014879b          	addiw	a5,s1,1
ffffffffc0206614:	0b21                	addi	s6,s6,8
ffffffffc0206616:	0a21                	addi	s4,s4,8
ffffffffc0206618:	fcf91be3          	bne	s2,a5,ffffffffc02065ee <do_execve+0xb0>
ffffffffc020661c:	000c3983          	ld	s3,0(s8)
ffffffffc0206620:	080a8063          	beqz	s5,ffffffffc02066a0 <do_execve+0x162>
ffffffffc0206624:	038a8513          	addi	a0,s5,56
ffffffffc0206628:	91efe0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020662c:	000bb783          	ld	a5,0(s7)
ffffffffc0206630:	040aa823          	sw	zero,80(s5)
ffffffffc0206634:	1487b503          	ld	a0,328(a5)
ffffffffc0206638:	a7aff0ef          	jal	ra,ffffffffc02058b2 <files_closeall>
ffffffffc020663c:	4581                	li	a1,0
ffffffffc020663e:	854e                	mv	a0,s3
ffffffffc0206640:	9eafe0ef          	jal	ra,ffffffffc020482a <sysfile_open>
ffffffffc0206644:	8a2a                	mv	s4,a0
ffffffffc0206646:	04054463          	bltz	a0,ffffffffc020668e <do_execve+0x150>
ffffffffc020664a:	00090797          	auipc	a5,0x90
ffffffffc020664e:	23e7b783          	ld	a5,574(a5) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc0206652:	577d                	li	a4,-1
ffffffffc0206654:	177e                	slli	a4,a4,0x3f
ffffffffc0206656:	83b1                	srli	a5,a5,0xc
ffffffffc0206658:	8fd9                	or	a5,a5,a4
ffffffffc020665a:	18079073          	csrw	satp,a5
ffffffffc020665e:	030aa783          	lw	a5,48(s5)
ffffffffc0206662:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206666:	02eaa823          	sw	a4,48(s5)
ffffffffc020666a:	26070c63          	beqz	a4,ffffffffc02068e2 <do_execve+0x3a4>
ffffffffc020666e:	000bb783          	ld	a5,0(s7)
ffffffffc0206672:	0207b423          	sd	zero,40(a5)
ffffffffc0206676:	f10fc0ef          	jal	ra,ffffffffc0202d86 <mm_create>
ffffffffc020667a:	8b2a                	mv	s6,a0
ffffffffc020667c:	c901                	beqz	a0,ffffffffc020668c <do_execve+0x14e>
ffffffffc020667e:	d66ff0ef          	jal	ra,ffffffffc0205be4 <setup_pgdir>
ffffffffc0206682:	8c2a                	mv	s8,a0
ffffffffc0206684:	c55d                	beqz	a0,ffffffffc0206732 <do_execve+0x1f4>
ffffffffc0206686:	855a                	mv	a0,s6
ffffffffc0206688:	84dfc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc020668c:	5a71                	li	s4,-4
ffffffffc020668e:	67c2                	ld	a5,16(sp)
ffffffffc0206690:	0f010913          	addi	s2,sp,240
ffffffffc0206694:	02079713          	slli	a4,a5,0x20
ffffffffc0206698:	01d75493          	srli	s1,a4,0x1d
ffffffffc020669c:	94ca                	add	s1,s1,s2
ffffffffc020669e:	a991                	j	ffffffffc0206af2 <do_execve+0x5b4>
ffffffffc02066a0:	000bb783          	ld	a5,0(s7)
ffffffffc02066a4:	1487b503          	ld	a0,328(a5)
ffffffffc02066a8:	a0aff0ef          	jal	ra,ffffffffc02058b2 <files_closeall>
ffffffffc02066ac:	4581                	li	a1,0
ffffffffc02066ae:	854e                	mv	a0,s3
ffffffffc02066b0:	97afe0ef          	jal	ra,ffffffffc020482a <sysfile_open>
ffffffffc02066b4:	8a2a                	mv	s4,a0
ffffffffc02066b6:	fc0550e3          	bgez	a0,ffffffffc0206676 <do_execve+0x138>
ffffffffc02066ba:	bfd1                	j	ffffffffc020668e <do_execve+0x150>
ffffffffc02066bc:	5c71                	li	s8,-4
ffffffffc02066be:	c485                	beqz	s1,ffffffffc02066e6 <do_execve+0x1a8>
ffffffffc02066c0:	34fd                	addiw	s1,s1,-1
ffffffffc02066c2:	02049793          	slli	a5,s1,0x20
ffffffffc02066c6:	01d7d493          	srli	s1,a5,0x1d
ffffffffc02066ca:	0f010913          	addi	s2,sp,240
ffffffffc02066ce:	94ca                	add	s1,s1,s2
ffffffffc02066d0:	a011                	j	ffffffffc02066d4 <do_execve+0x196>
ffffffffc02066d2:	0921                	addi	s2,s2,8
ffffffffc02066d4:	6008                	ld	a0,0(s0)
ffffffffc02066d6:	c509                	beqz	a0,ffffffffc02066e0 <do_execve+0x1a2>
ffffffffc02066d8:	99afd0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc02066dc:	00043023          	sd	zero,0(s0)
ffffffffc02066e0:	844a                	mv	s0,s2
ffffffffc02066e2:	ff2498e3          	bne	s1,s2,ffffffffc02066d2 <do_execve+0x194>
ffffffffc02066e6:	000a8863          	beqz	s5,ffffffffc02066f6 <do_execve+0x1b8>
ffffffffc02066ea:	038a8513          	addi	a0,s5,56
ffffffffc02066ee:	858fe0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc02066f2:	040aa823          	sw	zero,80(s5)
ffffffffc02066f6:	35813083          	ld	ra,856(sp)
ffffffffc02066fa:	35013403          	ld	s0,848(sp)
ffffffffc02066fe:	34813483          	ld	s1,840(sp)
ffffffffc0206702:	34013903          	ld	s2,832(sp)
ffffffffc0206706:	33813983          	ld	s3,824(sp)
ffffffffc020670a:	33013a03          	ld	s4,816(sp)
ffffffffc020670e:	32813a83          	ld	s5,808(sp)
ffffffffc0206712:	32013b03          	ld	s6,800(sp)
ffffffffc0206716:	31813b83          	ld	s7,792(sp)
ffffffffc020671a:	30813c83          	ld	s9,776(sp)
ffffffffc020671e:	30013d03          	ld	s10,768(sp)
ffffffffc0206722:	2f813d83          	ld	s11,760(sp)
ffffffffc0206726:	8562                	mv	a0,s8
ffffffffc0206728:	31013c03          	ld	s8,784(sp)
ffffffffc020672c:	36010113          	addi	sp,sp,864
ffffffffc0206730:	8082                	ret
ffffffffc0206732:	4601                	li	a2,0
ffffffffc0206734:	4581                	li	a1,0
ffffffffc0206736:	8552                	mv	a0,s4
ffffffffc0206738:	b58fe0ef          	jal	ra,ffffffffc0204a90 <sysfile_seek>
ffffffffc020673c:	cd41                	beqz	a0,ffffffffc02067d4 <do_execve+0x296>
ffffffffc020673e:	3c054c63          	bltz	a0,ffffffffc0206b16 <do_execve+0x5d8>
ffffffffc0206742:	572a                	lw	a4,168(sp)
ffffffffc0206744:	464c47b7          	lui	a5,0x464c4
ffffffffc0206748:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc020674c:	38f71963          	bne	a4,a5,ffffffffc0206ade <do_execve+0x5a0>
ffffffffc0206750:	0e015783          	lhu	a5,224(sp)
ffffffffc0206754:	f402                	sd	zero,40(sp)
ffffffffc0206756:	ec02                	sd	zero,24(sp)
ffffffffc0206758:	cbf1                	beqz	a5,ffffffffc020682c <do_execve+0x2ee>
ffffffffc020675a:	57fd                	li	a5,-1
ffffffffc020675c:	83b1                	srli	a5,a5,0xc
ffffffffc020675e:	e43e                	sd	a5,8(sp)
ffffffffc0206760:	f822                	sd	s0,48(sp)
ffffffffc0206762:	e0a6                	sd	s1,64(sp)
ffffffffc0206764:	fc62                	sd	s8,56(sp)
ffffffffc0206766:	e4ca                	sd	s2,72(sp)
ffffffffc0206768:	65ae                	ld	a1,200(sp)
ffffffffc020676a:	67e2                	ld	a5,24(sp)
ffffffffc020676c:	4601                	li	a2,0
ffffffffc020676e:	8552                	mv	a0,s4
ffffffffc0206770:	95be                	add	a1,a1,a5
ffffffffc0206772:	b1efe0ef          	jal	ra,ffffffffc0204a90 <sysfile_seek>
ffffffffc0206776:	89aa                	mv	s3,a0
ffffffffc0206778:	e549                	bnez	a0,ffffffffc0206802 <do_execve+0x2c4>
ffffffffc020677a:	03800613          	li	a2,56
ffffffffc020677e:	188c                	addi	a1,sp,112
ffffffffc0206780:	8552                	mv	a0,s4
ffffffffc0206782:	8e0fe0ef          	jal	ra,ffffffffc0204862 <sysfile_read>
ffffffffc0206786:	03800793          	li	a5,56
ffffffffc020678a:	06f50e63          	beq	a0,a5,ffffffffc0206806 <do_execve+0x2c8>
ffffffffc020678e:	7442                	ld	s0,48(sp)
ffffffffc0206790:	0005099b          	sext.w	s3,a0
ffffffffc0206794:	00054363          	bltz	a0,ffffffffc020679a <do_execve+0x25c>
ffffffffc0206798:	59fd                	li	s3,-1
ffffffffc020679a:	855a                	mv	a0,s6
ffffffffc020679c:	8d5fc0ef          	jal	ra,ffffffffc0203070 <exit_mmap>
ffffffffc02067a0:	018b3503          	ld	a0,24(s6)
ffffffffc02067a4:	8a4e                	mv	s4,s3
ffffffffc02067a6:	bc8ff0ef          	jal	ra,ffffffffc0205b6e <put_pgdir.isra.0>
ffffffffc02067aa:	855a                	mv	a0,s6
ffffffffc02067ac:	f28fc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc02067b0:	bdf9                	j	ffffffffc020668e <do_execve+0x150>
ffffffffc02067b2:	854e                	mv	a0,s3
ffffffffc02067b4:	8befd0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc02067b8:	5c75                	li	s8,-3
ffffffffc02067ba:	b711                	j	ffffffffc02066be <do_execve+0x180>
ffffffffc02067bc:	000bb783          	ld	a5,0(s7)
ffffffffc02067c0:	00007617          	auipc	a2,0x7
ffffffffc02067c4:	db860613          	addi	a2,a2,-584 # ffffffffc020d578 <CSWTCH.79+0x2a8>
ffffffffc02067c8:	45c1                	li	a1,16
ffffffffc02067ca:	43d4                	lw	a3,4(a5)
ffffffffc02067cc:	1088                	addi	a0,sp,96
ffffffffc02067ce:	3eb040ef          	jal	ra,ffffffffc020b3b8 <snprintf>
ffffffffc02067d2:	bbf5                	j	ffffffffc02065ce <do_execve+0x90>
ffffffffc02067d4:	04000613          	li	a2,64
ffffffffc02067d8:	112c                	addi	a1,sp,168
ffffffffc02067da:	8552                	mv	a0,s4
ffffffffc02067dc:	886fe0ef          	jal	ra,ffffffffc0204862 <sysfile_read>
ffffffffc02067e0:	04000793          	li	a5,64
ffffffffc02067e4:	f4f50fe3          	beq	a0,a5,ffffffffc0206742 <do_execve+0x204>
ffffffffc02067e8:	00050a1b          	sext.w	s4,a0
ffffffffc02067ec:	00054363          	bltz	a0,ffffffffc02067f2 <do_execve+0x2b4>
ffffffffc02067f0:	5a7d                	li	s4,-1
ffffffffc02067f2:	018b3503          	ld	a0,24(s6)
ffffffffc02067f6:	b78ff0ef          	jal	ra,ffffffffc0205b6e <put_pgdir.isra.0>
ffffffffc02067fa:	855a                	mv	a0,s6
ffffffffc02067fc:	ed8fc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc0206800:	b579                	j	ffffffffc020668e <do_execve+0x150>
ffffffffc0206802:	3a054a63          	bltz	a0,ffffffffc0206bb6 <do_execve+0x678>
ffffffffc0206806:	5746                	lw	a4,112(sp)
ffffffffc0206808:	4785                	li	a5,1
ffffffffc020680a:	0ef70763          	beq	a4,a5,ffffffffc02068f8 <do_execve+0x3ba>
ffffffffc020680e:	7722                	ld	a4,40(sp)
ffffffffc0206810:	66e2                	ld	a3,24(sp)
ffffffffc0206812:	0e015783          	lhu	a5,224(sp)
ffffffffc0206816:	2705                	addiw	a4,a4,1
ffffffffc0206818:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc020681c:	f43a                	sd	a4,40(sp)
ffffffffc020681e:	ec36                	sd	a3,24(sp)
ffffffffc0206820:	f4f744e3          	blt	a4,a5,ffffffffc0206768 <do_execve+0x22a>
ffffffffc0206824:	7442                	ld	s0,48(sp)
ffffffffc0206826:	6486                	ld	s1,64(sp)
ffffffffc0206828:	7c62                	ld	s8,56(sp)
ffffffffc020682a:	6926                	ld	s2,72(sp)
ffffffffc020682c:	4701                	li	a4,0
ffffffffc020682e:	46ad                	li	a3,11
ffffffffc0206830:	00100637          	lui	a2,0x100
ffffffffc0206834:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0206838:	855a                	mv	a0,s6
ffffffffc020683a:	eecfc0ef          	jal	ra,ffffffffc0202f26 <mm_map>
ffffffffc020683e:	89aa                	mv	s3,a0
ffffffffc0206840:	fd29                	bnez	a0,ffffffffc020679a <do_execve+0x25c>
ffffffffc0206842:	7ffff9b7          	lui	s3,0x7ffff
ffffffffc0206846:	7afd                	lui	s5,0xfffff
ffffffffc0206848:	7fffba37          	lui	s4,0x7fffb
ffffffffc020684c:	018b3503          	ld	a0,24(s6)
ffffffffc0206850:	467d                	li	a2,31
ffffffffc0206852:	85ce                	mv	a1,s3
ffffffffc0206854:	c4cfc0ef          	jal	ra,ffffffffc0202ca0 <pgdir_alloc_page>
ffffffffc0206858:	3c050563          	beqz	a0,ffffffffc0206c22 <do_execve+0x6e4>
ffffffffc020685c:	99d6                	add	s3,s3,s5
ffffffffc020685e:	ff4997e3          	bne	s3,s4,ffffffffc020684c <do_execve+0x30e>
ffffffffc0206862:	030b2783          	lw	a5,48(s6)
ffffffffc0206866:	000bb703          	ld	a4,0(s7)
ffffffffc020686a:	018b3683          	ld	a3,24(s6)
ffffffffc020686e:	2785                	addiw	a5,a5,1
ffffffffc0206870:	02fb2823          	sw	a5,48(s6)
ffffffffc0206874:	03673423          	sd	s6,40(a4)
ffffffffc0206878:	c02007b7          	lui	a5,0xc0200
ffffffffc020687c:	34f6eb63          	bltu	a3,a5,ffffffffc0206bd2 <do_execve+0x694>
ffffffffc0206880:	00090797          	auipc	a5,0x90
ffffffffc0206884:	0307b783          	ld	a5,48(a5) # ffffffffc02968b0 <va_pa_offset>
ffffffffc0206888:	8e9d                	sub	a3,a3,a5
ffffffffc020688a:	f754                	sd	a3,168(a4)
ffffffffc020688c:	577d                	li	a4,-1
ffffffffc020688e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0206892:	177e                	slli	a4,a4,0x3f
ffffffffc0206894:	8fd9                	or	a5,a5,a4
ffffffffc0206896:	18079073          	csrw	satp,a5
ffffffffc020689a:	7782                	ld	a5,32(sp)
ffffffffc020689c:	4985                	li	s3,1
ffffffffc020689e:	8a26                	mv	s4,s1
ffffffffc02068a0:	ff878a93          	addi	s5,a5,-8
ffffffffc02068a4:	11bc                	addi	a5,sp,232
ffffffffc02068a6:	01578cb3          	add	s9,a5,s5
ffffffffc02068aa:	13bc                	addi	a5,sp,488
ffffffffc02068ac:	9abe                	add	s5,s5,a5
ffffffffc02068ae:	09fe                	slli	s3,s3,0x1f
ffffffffc02068b0:	a801                	j	ffffffffc02068c0 <do_execve+0x382>
ffffffffc02068b2:	013ab023          	sd	s3,0(s5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc02068b6:	1ce1                	addi	s9,s9,-8
ffffffffc02068b8:	1ae1                	addi	s5,s5,-8
ffffffffc02068ba:	260a0e63          	beqz	s4,ffffffffc0206b36 <do_execve+0x5f8>
ffffffffc02068be:	3a7d                	addiw	s4,s4,-1
ffffffffc02068c0:	000cbd03          	ld	s10,0(s9)
ffffffffc02068c4:	856a                	mv	a0,s10
ffffffffc02068c6:	5b8040ef          	jal	ra,ffffffffc020ae7e <strlen>
ffffffffc02068ca:	00150693          	addi	a3,a0,1 # 1001 <_binary_bin_swap_img_size-0x6cff>
ffffffffc02068ce:	40d989b3          	sub	s3,s3,a3
ffffffffc02068d2:	866a                	mv	a2,s10
ffffffffc02068d4:	85ce                	mv	a1,s3
ffffffffc02068d6:	855a                	mv	a0,s6
ffffffffc02068d8:	c01fc0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc02068dc:	f979                	bnez	a0,ffffffffc02068b2 <do_execve+0x374>
ffffffffc02068de:	59f5                	li	s3,-3
ffffffffc02068e0:	bd6d                	j	ffffffffc020679a <do_execve+0x25c>
ffffffffc02068e2:	8556                	mv	a0,s5
ffffffffc02068e4:	f8cfc0ef          	jal	ra,ffffffffc0203070 <exit_mmap>
ffffffffc02068e8:	018ab503          	ld	a0,24(s5)
ffffffffc02068ec:	a82ff0ef          	jal	ra,ffffffffc0205b6e <put_pgdir.isra.0>
ffffffffc02068f0:	8556                	mv	a0,s5
ffffffffc02068f2:	de2fc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc02068f6:	bba5                	j	ffffffffc020666e <do_execve+0x130>
ffffffffc02068f8:	57d6                	lw	a5,116(sp)
ffffffffc02068fa:	0017f693          	andi	a3,a5,1
ffffffffc02068fe:	c291                	beqz	a3,ffffffffc0206902 <do_execve+0x3c4>
ffffffffc0206900:	4691                	li	a3,4
ffffffffc0206902:	0027f713          	andi	a4,a5,2
ffffffffc0206906:	8b91                	andi	a5,a5,4
ffffffffc0206908:	c771                	beqz	a4,ffffffffc02069d4 <do_execve+0x496>
ffffffffc020690a:	0026e693          	ori	a3,a3,2
ffffffffc020690e:	e7e9                	bnez	a5,ffffffffc02069d8 <do_execve+0x49a>
ffffffffc0206910:	4add                	li	s5,23
ffffffffc0206912:	0046f793          	andi	a5,a3,4
ffffffffc0206916:	c399                	beqz	a5,ffffffffc020691c <do_execve+0x3de>
ffffffffc0206918:	008aea93          	ori	s5,s5,8
ffffffffc020691c:	666a                	ld	a2,152(sp)
ffffffffc020691e:	658a                	ld	a1,128(sp)
ffffffffc0206920:	4701                	li	a4,0
ffffffffc0206922:	855a                	mv	a0,s6
ffffffffc0206924:	e02fc0ef          	jal	ra,ffffffffc0202f26 <mm_map>
ffffffffc0206928:	89aa                	mv	s3,a0
ffffffffc020692a:	28051663          	bnez	a0,ffffffffc0206bb6 <do_execve+0x678>
ffffffffc020692e:	6d0a                	ld	s10,128(sp)
ffffffffc0206930:	694a                	ld	s2,144(sp)
ffffffffc0206932:	996a                	add	s2,s2,s10
ffffffffc0206934:	0d2d7263          	bgeu	s10,s2,ffffffffc02069f8 <do_execve+0x4ba>
ffffffffc0206938:	6c05                	lui	s8,0x1
ffffffffc020693a:	00090d97          	auipc	s11,0x90
ffffffffc020693e:	f5ed8d93          	addi	s11,s11,-162 # ffffffffc0296898 <npage>
ffffffffc0206942:	e05a                	sd	s6,0(sp)
ffffffffc0206944:	6782                	ld	a5,0(sp)
ffffffffc0206946:	8656                	mv	a2,s5
ffffffffc0206948:	6f88                	ld	a0,24(a5)
ffffffffc020694a:	77fd                	lui	a5,0xfffff
ffffffffc020694c:	00fd74b3          	and	s1,s10,a5
ffffffffc0206950:	85a6                	mv	a1,s1
ffffffffc0206952:	b4efc0ef          	jal	ra,ffffffffc0202ca0 <pgdir_alloc_page>
ffffffffc0206956:	1a050a63          	beqz	a0,ffffffffc0206b0a <do_execve+0x5cc>
ffffffffc020695a:	01848733          	add	a4,s1,s8
ffffffffc020695e:	41a90b33          	sub	s6,s2,s10
ffffffffc0206962:	00e96663          	bltu	s2,a4,ffffffffc020696e <do_execve+0x430>
ffffffffc0206966:	41a487b3          	sub	a5,s1,s10
ffffffffc020696a:	01878b33          	add	s6,a5,s8
ffffffffc020696e:	00090797          	auipc	a5,0x90
ffffffffc0206972:	f3278793          	addi	a5,a5,-206 # ffffffffc02968a0 <pages>
ffffffffc0206976:	6398                	ld	a4,0(a5)
ffffffffc0206978:	00009797          	auipc	a5,0x9
ffffffffc020697c:	c3878793          	addi	a5,a5,-968 # ffffffffc020f5b0 <nbase>
ffffffffc0206980:	638c                	ld	a1,0(a5)
ffffffffc0206982:	8d19                	sub	a0,a0,a4
ffffffffc0206984:	8519                	srai	a0,a0,0x6
ffffffffc0206986:	952e                	add	a0,a0,a1
ffffffffc0206988:	668a                	ld	a3,128(sp)
ffffffffc020698a:	75e6                	ld	a1,120(sp)
ffffffffc020698c:	67a2                	ld	a5,8(sp)
ffffffffc020698e:	000db703          	ld	a4,0(s11)
ffffffffc0206992:	8d95                	sub	a1,a1,a3
ffffffffc0206994:	00f576b3          	and	a3,a0,a5
ffffffffc0206998:	95ea                	add	a1,a1,s10
ffffffffc020699a:	00c51413          	slli	s0,a0,0xc
ffffffffc020699e:	24e6f663          	bgeu	a3,a4,ffffffffc0206bea <do_execve+0x6ac>
ffffffffc02069a2:	00090797          	auipc	a5,0x90
ffffffffc02069a6:	f0e78793          	addi	a5,a5,-242 # ffffffffc02968b0 <va_pa_offset>
ffffffffc02069aa:	4601                	li	a2,0
ffffffffc02069ac:	8552                	mv	a0,s4
ffffffffc02069ae:	0007bc83          	ld	s9,0(a5)
ffffffffc02069b2:	8defe0ef          	jal	ra,ffffffffc0204a90 <sysfile_seek>
ffffffffc02069b6:	89aa                	mv	s3,a0
ffffffffc02069b8:	e51d                	bnez	a0,ffffffffc02069e6 <do_execve+0x4a8>
ffffffffc02069ba:	019405b3          	add	a1,s0,s9
ffffffffc02069be:	409d04b3          	sub	s1,s10,s1
ffffffffc02069c2:	865a                	mv	a2,s6
ffffffffc02069c4:	95a6                	add	a1,a1,s1
ffffffffc02069c6:	8552                	mv	a0,s4
ffffffffc02069c8:	e9bfd0ef          	jal	ra,ffffffffc0204862 <sysfile_read>
ffffffffc02069cc:	00ab0f63          	beq	s6,a0,ffffffffc02069ea <do_execve+0x4ac>
ffffffffc02069d0:	6b02                	ld	s6,0(sp)
ffffffffc02069d2:	bb75                	j	ffffffffc020678e <do_execve+0x250>
ffffffffc02069d4:	4ac5                	li	s5,17
ffffffffc02069d6:	c781                	beqz	a5,ffffffffc02069de <do_execve+0x4a0>
ffffffffc02069d8:	0016e693          	ori	a3,a3,1
ffffffffc02069dc:	4acd                	li	s5,19
ffffffffc02069de:	0026f793          	andi	a5,a3,2
ffffffffc02069e2:	db85                	beqz	a5,ffffffffc0206912 <do_execve+0x3d4>
ffffffffc02069e4:	b735                	j	ffffffffc0206910 <do_execve+0x3d2>
ffffffffc02069e6:	1c054763          	bltz	a0,ffffffffc0206bb4 <do_execve+0x676>
ffffffffc02069ea:	9d5a                	add	s10,s10,s6
ffffffffc02069ec:	f52d6ce3          	bltu	s10,s2,ffffffffc0206944 <do_execve+0x406>
ffffffffc02069f0:	6d0a                	ld	s10,128(sp)
ffffffffc02069f2:	694a                	ld	s2,144(sp)
ffffffffc02069f4:	6b02                	ld	s6,0(sp)
ffffffffc02069f6:	996a                	add	s2,s2,s10
ffffffffc02069f8:	646a                	ld	s0,152(sp)
ffffffffc02069fa:	946a                	add	s0,s0,s10
ffffffffc02069fc:	e08979e3          	bgeu	s2,s0,ffffffffc020680e <do_execve+0x2d0>
ffffffffc0206a00:	7d7d                	lui	s10,0xfffff
ffffffffc0206a02:	6485                	lui	s1,0x1
ffffffffc0206a04:	00090c97          	auipc	s9,0x90
ffffffffc0206a08:	e94c8c93          	addi	s9,s9,-364 # ffffffffc0296898 <npage>
ffffffffc0206a0c:	00090c17          	auipc	s8,0x90
ffffffffc0206a10:	ea4c0c13          	addi	s8,s8,-348 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0206a14:	a8a1                	j	ffffffffc0206a6c <do_execve+0x52e>
ffffffffc0206a16:	009d87b3          	add	a5,s11,s1
ffffffffc0206a1a:	41b90733          	sub	a4,s2,s11
ffffffffc0206a1e:	41240633          	sub	a2,s0,s2
ffffffffc0206a22:	00f46663          	bltu	s0,a5,ffffffffc0206a2e <do_execve+0x4f0>
ffffffffc0206a26:	412d8db3          	sub	s11,s11,s2
ffffffffc0206a2a:	009d8633          	add	a2,s11,s1
ffffffffc0206a2e:	00090797          	auipc	a5,0x90
ffffffffc0206a32:	e7278793          	addi	a5,a5,-398 # ffffffffc02968a0 <pages>
ffffffffc0206a36:	639c                	ld	a5,0(a5)
ffffffffc0206a38:	00009697          	auipc	a3,0x9
ffffffffc0206a3c:	b7868693          	addi	a3,a3,-1160 # ffffffffc020f5b0 <nbase>
ffffffffc0206a40:	628c                	ld	a1,0(a3)
ffffffffc0206a42:	40f507b3          	sub	a5,a0,a5
ffffffffc0206a46:	8799                	srai	a5,a5,0x6
ffffffffc0206a48:	97ae                	add	a5,a5,a1
ffffffffc0206a4a:	65a2                	ld	a1,8(sp)
ffffffffc0206a4c:	000cb683          	ld	a3,0(s9)
ffffffffc0206a50:	8dfd                	and	a1,a1,a5
ffffffffc0206a52:	07b2                	slli	a5,a5,0xc
ffffffffc0206a54:	1ad5fa63          	bgeu	a1,a3,ffffffffc0206c08 <do_execve+0x6ca>
ffffffffc0206a58:	000c3503          	ld	a0,0(s8)
ffffffffc0206a5c:	9932                	add	s2,s2,a2
ffffffffc0206a5e:	4581                	li	a1,0
ffffffffc0206a60:	953e                	add	a0,a0,a5
ffffffffc0206a62:	953a                	add	a0,a0,a4
ffffffffc0206a64:	4bc040ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0206a68:	da8973e3          	bgeu	s2,s0,ffffffffc020680e <do_execve+0x2d0>
ffffffffc0206a6c:	018b3503          	ld	a0,24(s6)
ffffffffc0206a70:	01a97db3          	and	s11,s2,s10
ffffffffc0206a74:	8656                	mv	a2,s5
ffffffffc0206a76:	85ee                	mv	a1,s11
ffffffffc0206a78:	a28fc0ef          	jal	ra,ffffffffc0202ca0 <pgdir_alloc_page>
ffffffffc0206a7c:	fd49                	bnez	a0,ffffffffc0206a16 <do_execve+0x4d8>
ffffffffc0206a7e:	7442                	ld	s0,48(sp)
ffffffffc0206a80:	7c62                	ld	s8,56(sp)
ffffffffc0206a82:	855a                	mv	a0,s6
ffffffffc0206a84:	decfc0ef          	jal	ra,ffffffffc0203070 <exit_mmap>
ffffffffc0206a88:	018b3503          	ld	a0,24(s6)
ffffffffc0206a8c:	8e2ff0ef          	jal	ra,ffffffffc0205b6e <put_pgdir.isra.0>
ffffffffc0206a90:	855a                	mv	a0,s6
ffffffffc0206a92:	c42fc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc0206a96:	16099763          	bnez	s3,ffffffffc0206c04 <do_execve+0x6c6>
ffffffffc0206a9a:	67c2                	ld	a5,16(sp)
ffffffffc0206a9c:	0f010913          	addi	s2,sp,240
ffffffffc0206aa0:	02079713          	slli	a4,a5,0x20
ffffffffc0206aa4:	01d75493          	srli	s1,a4,0x1d
ffffffffc0206aa8:	94ca                	add	s1,s1,s2
ffffffffc0206aaa:	a011                	j	ffffffffc0206aae <do_execve+0x570>
ffffffffc0206aac:	0921                	addi	s2,s2,8
ffffffffc0206aae:	6008                	ld	a0,0(s0)
ffffffffc0206ab0:	c509                	beqz	a0,ffffffffc0206aba <do_execve+0x57c>
ffffffffc0206ab2:	dc1fc0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0206ab6:	00043023          	sd	zero,0(s0)
ffffffffc0206aba:	844a                	mv	s0,s2
ffffffffc0206abc:	fe9918e3          	bne	s2,s1,ffffffffc0206aac <do_execve+0x56e>
ffffffffc0206ac0:	000bb403          	ld	s0,0(s7)
ffffffffc0206ac4:	4641                	li	a2,16
ffffffffc0206ac6:	4581                	li	a1,0
ffffffffc0206ac8:	0b440413          	addi	s0,s0,180
ffffffffc0206acc:	8522                	mv	a0,s0
ffffffffc0206ace:	452040ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0206ad2:	463d                	li	a2,15
ffffffffc0206ad4:	108c                	addi	a1,sp,96
ffffffffc0206ad6:	8522                	mv	a0,s0
ffffffffc0206ad8:	49a040ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0206adc:	b929                	j	ffffffffc02066f6 <do_execve+0x1b8>
ffffffffc0206ade:	018b3503          	ld	a0,24(s6)
ffffffffc0206ae2:	5a61                	li	s4,-8
ffffffffc0206ae4:	88aff0ef          	jal	ra,ffffffffc0205b6e <put_pgdir.isra.0>
ffffffffc0206ae8:	855a                	mv	a0,s6
ffffffffc0206aea:	beafc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc0206aee:	b645                	j	ffffffffc020668e <do_execve+0x150>
ffffffffc0206af0:	0921                	addi	s2,s2,8
ffffffffc0206af2:	6008                	ld	a0,0(s0)
ffffffffc0206af4:	c509                	beqz	a0,ffffffffc0206afe <do_execve+0x5c0>
ffffffffc0206af6:	d7dfc0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0206afa:	00043023          	sd	zero,0(s0)
ffffffffc0206afe:	844a                	mv	s0,s2
ffffffffc0206b00:	ff2498e3          	bne	s1,s2,ffffffffc0206af0 <do_execve+0x5b2>
ffffffffc0206b04:	8552                	mv	a0,s4
ffffffffc0206b06:	db4ff0ef          	jal	ra,ffffffffc02060ba <do_exit>
ffffffffc0206b0a:	6b02                	ld	s6,0(sp)
ffffffffc0206b0c:	7442                	ld	s0,48(sp)
ffffffffc0206b0e:	7c62                	ld	s8,56(sp)
ffffffffc0206b10:	bf8d                	j	ffffffffc0206a82 <do_execve+0x544>
ffffffffc0206b12:	5c75                	li	s8,-3
ffffffffc0206b14:	b6cd                	j	ffffffffc02066f6 <do_execve+0x1b8>
ffffffffc0206b16:	8a2a                	mv	s4,a0
ffffffffc0206b18:	b9e9                	j	ffffffffc02067f2 <do_execve+0x2b4>
ffffffffc0206b1a:	5c75                	li	s8,-3
ffffffffc0206b1c:	bc0a97e3          	bnez	s5,ffffffffc02066ea <do_execve+0x1ac>
ffffffffc0206b20:	bed9                	j	ffffffffc02066f6 <do_execve+0x1b8>
ffffffffc0206b22:	fe0a88e3          	beqz	s5,ffffffffc0206b12 <do_execve+0x5d4>
ffffffffc0206b26:	038a8513          	addi	a0,s5,56
ffffffffc0206b2a:	c1dfd0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0206b2e:	5c75                	li	s8,-3
ffffffffc0206b30:	040aa823          	sw	zero,80(s5)
ffffffffc0206b34:	b6c9                	j	ffffffffc02066f6 <do_execve+0x1b8>
ffffffffc0206b36:	7782                	ld	a5,32(sp)
ffffffffc0206b38:	ff89f993          	andi	s3,s3,-8
ffffffffc0206b3c:	1e810a93          	addi	s5,sp,488
ffffffffc0206b40:	07a1                	addi	a5,a5,8
ffffffffc0206b42:	40f989b3          	sub	s3,s3,a5
ffffffffc0206b46:	41598cb3          	sub	s9,s3,s5
ffffffffc0206b4a:	a011                	j	ffffffffc0206b4e <do_execve+0x610>
ffffffffc0206b4c:	8a3e                	mv	s4,a5
ffffffffc0206b4e:	46a1                	li	a3,8
ffffffffc0206b50:	8656                	mv	a2,s5
ffffffffc0206b52:	015c85b3          	add	a1,s9,s5
ffffffffc0206b56:	855a                	mv	a0,s6
ffffffffc0206b58:	981fc0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc0206b5c:	d80501e3          	beqz	a0,ffffffffc02068de <do_execve+0x3a0>
ffffffffc0206b60:	001a079b          	addiw	a5,s4,1
ffffffffc0206b64:	0aa1                	addi	s5,s5,8
ffffffffc0206b66:	fe9a43e3          	blt	s4,s1,ffffffffc0206b4c <do_execve+0x60e>
ffffffffc0206b6a:	7782                	ld	a5,32(sp)
ffffffffc0206b6c:	46a1                	li	a3,8
ffffffffc0206b6e:	08b0                	addi	a2,sp,88
ffffffffc0206b70:	013785b3          	add	a1,a5,s3
ffffffffc0206b74:	855a                	mv	a0,s6
ffffffffc0206b76:	ec82                	sd	zero,88(sp)
ffffffffc0206b78:	961fc0ef          	jal	ra,ffffffffc02034d8 <copy_to_user>
ffffffffc0206b7c:	cd1d                	beqz	a0,ffffffffc0206bba <do_execve+0x67c>
ffffffffc0206b7e:	000bb783          	ld	a5,0(s7)
ffffffffc0206b82:	12000613          	li	a2,288
ffffffffc0206b86:	4581                	li	a1,0
ffffffffc0206b88:	73c4                	ld	s1,160(a5)
ffffffffc0206b8a:	1004ba03          	ld	s4,256(s1) # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0206b8e:	8526                	mv	a0,s1
ffffffffc0206b90:	390040ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0206b94:	670e                	ld	a4,192(sp)
ffffffffc0206b96:	edfa7793          	andi	a5,s4,-289
ffffffffc0206b9a:	0207e793          	ori	a5,a5,32
ffffffffc0206b9e:	10f4b023          	sd	a5,256(s1)
ffffffffc0206ba2:	0134b823          	sd	s3,16(s1)
ffffffffc0206ba6:	0524b823          	sd	s2,80(s1)
ffffffffc0206baa:	0534bc23          	sd	s3,88(s1)
ffffffffc0206bae:	10e4b423          	sd	a4,264(s1)
ffffffffc0206bb2:	b5e5                	j	ffffffffc0206a9a <do_execve+0x55c>
ffffffffc0206bb4:	6b02                	ld	s6,0(sp)
ffffffffc0206bb6:	7442                	ld	s0,48(sp)
ffffffffc0206bb8:	b6cd                	j	ffffffffc020679a <do_execve+0x25c>
ffffffffc0206bba:	855a                	mv	a0,s6
ffffffffc0206bbc:	cb4fc0ef          	jal	ra,ffffffffc0203070 <exit_mmap>
ffffffffc0206bc0:	018b3503          	ld	a0,24(s6)
ffffffffc0206bc4:	5a75                	li	s4,-3
ffffffffc0206bc6:	fa9fe0ef          	jal	ra,ffffffffc0205b6e <put_pgdir.isra.0>
ffffffffc0206bca:	855a                	mv	a0,s6
ffffffffc0206bcc:	b08fc0ef          	jal	ra,ffffffffc0202ed4 <mm_destroy>
ffffffffc0206bd0:	bc7d                	j	ffffffffc020668e <do_execve+0x150>
ffffffffc0206bd2:	00005617          	auipc	a2,0x5
ffffffffc0206bd6:	57e60613          	addi	a2,a2,1406 # ffffffffc020c150 <commands+0xa88>
ffffffffc0206bda:	34000593          	li	a1,832
ffffffffc0206bde:	00006517          	auipc	a0,0x6
ffffffffc0206be2:	7d250513          	addi	a0,a0,2002 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206be6:	e48f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206bea:	86a2                	mv	a3,s0
ffffffffc0206bec:	00005617          	auipc	a2,0x5
ffffffffc0206bf0:	44460613          	addi	a2,a2,1092 # ffffffffc020c030 <commands+0x968>
ffffffffc0206bf4:	07100593          	li	a1,113
ffffffffc0206bf8:	00005517          	auipc	a0,0x5
ffffffffc0206bfc:	40050513          	addi	a0,a0,1024 # ffffffffc020bff8 <commands+0x930>
ffffffffc0206c00:	e2ef90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206c04:	8a4e                	mv	s4,s3
ffffffffc0206c06:	b461                	j	ffffffffc020668e <do_execve+0x150>
ffffffffc0206c08:	86be                	mv	a3,a5
ffffffffc0206c0a:	00005617          	auipc	a2,0x5
ffffffffc0206c0e:	42660613          	addi	a2,a2,1062 # ffffffffc020c030 <commands+0x968>
ffffffffc0206c12:	07100593          	li	a1,113
ffffffffc0206c16:	00005517          	auipc	a0,0x5
ffffffffc0206c1a:	3e250513          	addi	a0,a0,994 # ffffffffc020bff8 <commands+0x930>
ffffffffc0206c1e:	e10f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206c22:	00007697          	auipc	a3,0x7
ffffffffc0206c26:	96668693          	addi	a3,a3,-1690 # ffffffffc020d588 <CSWTCH.79+0x2b8>
ffffffffc0206c2a:	00005617          	auipc	a2,0x5
ffffffffc0206c2e:	cee60613          	addi	a2,a2,-786 # ffffffffc020b918 <commands+0x250>
ffffffffc0206c32:	33b00593          	li	a1,827
ffffffffc0206c36:	00006517          	auipc	a0,0x6
ffffffffc0206c3a:	77a50513          	addi	a0,a0,1914 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206c3e:	df0f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0206c42 <user_main>:
ffffffffc0206c42:	7179                	addi	sp,sp,-48
ffffffffc0206c44:	e84a                	sd	s2,16(sp)
ffffffffc0206c46:	00090917          	auipc	s2,0x90
ffffffffc0206c4a:	c7a90913          	addi	s2,s2,-902 # ffffffffc02968c0 <current>
ffffffffc0206c4e:	00093783          	ld	a5,0(s2)
ffffffffc0206c52:	00007617          	auipc	a2,0x7
ffffffffc0206c56:	98660613          	addi	a2,a2,-1658 # ffffffffc020d5d8 <CSWTCH.79+0x308>
ffffffffc0206c5a:	00007517          	auipc	a0,0x7
ffffffffc0206c5e:	98650513          	addi	a0,a0,-1658 # ffffffffc020d5e0 <CSWTCH.79+0x310>
ffffffffc0206c62:	43cc                	lw	a1,4(a5)
ffffffffc0206c64:	f406                	sd	ra,40(sp)
ffffffffc0206c66:	f022                	sd	s0,32(sp)
ffffffffc0206c68:	ec26                	sd	s1,24(sp)
ffffffffc0206c6a:	e032                	sd	a2,0(sp)
ffffffffc0206c6c:	e402                	sd	zero,8(sp)
ffffffffc0206c6e:	cbcf90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0206c72:	6782                	ld	a5,0(sp)
ffffffffc0206c74:	cfb9                	beqz	a5,ffffffffc0206cd2 <user_main+0x90>
ffffffffc0206c76:	003c                	addi	a5,sp,8
ffffffffc0206c78:	4401                	li	s0,0
ffffffffc0206c7a:	6398                	ld	a4,0(a5)
ffffffffc0206c7c:	0405                	addi	s0,s0,1
ffffffffc0206c7e:	07a1                	addi	a5,a5,8
ffffffffc0206c80:	ff6d                	bnez	a4,ffffffffc0206c7a <user_main+0x38>
ffffffffc0206c82:	00093783          	ld	a5,0(s2)
ffffffffc0206c86:	12000613          	li	a2,288
ffffffffc0206c8a:	6b84                	ld	s1,16(a5)
ffffffffc0206c8c:	73cc                	ld	a1,160(a5)
ffffffffc0206c8e:	6789                	lui	a5,0x2
ffffffffc0206c90:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206c94:	94be                	add	s1,s1,a5
ffffffffc0206c96:	8526                	mv	a0,s1
ffffffffc0206c98:	2da040ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0206c9c:	00093783          	ld	a5,0(s2)
ffffffffc0206ca0:	860a                	mv	a2,sp
ffffffffc0206ca2:	0004059b          	sext.w	a1,s0
ffffffffc0206ca6:	f3c4                	sd	s1,160(a5)
ffffffffc0206ca8:	00007517          	auipc	a0,0x7
ffffffffc0206cac:	93050513          	addi	a0,a0,-1744 # ffffffffc020d5d8 <CSWTCH.79+0x308>
ffffffffc0206cb0:	88fff0ef          	jal	ra,ffffffffc020653e <do_execve>
ffffffffc0206cb4:	8126                	mv	sp,s1
ffffffffc0206cb6:	d9efa06f          	j	ffffffffc0201254 <__trapret>
ffffffffc0206cba:	00007617          	auipc	a2,0x7
ffffffffc0206cbe:	94e60613          	addi	a2,a2,-1714 # ffffffffc020d608 <CSWTCH.79+0x338>
ffffffffc0206cc2:	48700593          	li	a1,1159
ffffffffc0206cc6:	00006517          	auipc	a0,0x6
ffffffffc0206cca:	6ea50513          	addi	a0,a0,1770 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206cce:	d60f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206cd2:	4401                	li	s0,0
ffffffffc0206cd4:	b77d                	j	ffffffffc0206c82 <user_main+0x40>

ffffffffc0206cd6 <do_yield>:
ffffffffc0206cd6:	00090797          	auipc	a5,0x90
ffffffffc0206cda:	bea7b783          	ld	a5,-1046(a5) # ffffffffc02968c0 <current>
ffffffffc0206cde:	4705                	li	a4,1
ffffffffc0206ce0:	ef98                	sd	a4,24(a5)
ffffffffc0206ce2:	4501                	li	a0,0
ffffffffc0206ce4:	8082                	ret

ffffffffc0206ce6 <do_wait>:
ffffffffc0206ce6:	1101                	addi	sp,sp,-32
ffffffffc0206ce8:	e822                	sd	s0,16(sp)
ffffffffc0206cea:	e426                	sd	s1,8(sp)
ffffffffc0206cec:	ec06                	sd	ra,24(sp)
ffffffffc0206cee:	842e                	mv	s0,a1
ffffffffc0206cf0:	84aa                	mv	s1,a0
ffffffffc0206cf2:	c999                	beqz	a1,ffffffffc0206d08 <do_wait+0x22>
ffffffffc0206cf4:	00090797          	auipc	a5,0x90
ffffffffc0206cf8:	bcc7b783          	ld	a5,-1076(a5) # ffffffffc02968c0 <current>
ffffffffc0206cfc:	7788                	ld	a0,40(a5)
ffffffffc0206cfe:	4685                	li	a3,1
ffffffffc0206d00:	4611                	li	a2,4
ffffffffc0206d02:	f0efc0ef          	jal	ra,ffffffffc0203410 <user_mem_check>
ffffffffc0206d06:	c909                	beqz	a0,ffffffffc0206d18 <do_wait+0x32>
ffffffffc0206d08:	85a2                	mv	a1,s0
ffffffffc0206d0a:	6442                	ld	s0,16(sp)
ffffffffc0206d0c:	60e2                	ld	ra,24(sp)
ffffffffc0206d0e:	8526                	mv	a0,s1
ffffffffc0206d10:	64a2                	ld	s1,8(sp)
ffffffffc0206d12:	6105                	addi	sp,sp,32
ffffffffc0206d14:	d08ff06f          	j	ffffffffc020621c <do_wait.part.0>
ffffffffc0206d18:	60e2                	ld	ra,24(sp)
ffffffffc0206d1a:	6442                	ld	s0,16(sp)
ffffffffc0206d1c:	64a2                	ld	s1,8(sp)
ffffffffc0206d1e:	5575                	li	a0,-3
ffffffffc0206d20:	6105                	addi	sp,sp,32
ffffffffc0206d22:	8082                	ret

ffffffffc0206d24 <do_kill>:
ffffffffc0206d24:	1141                	addi	sp,sp,-16
ffffffffc0206d26:	6789                	lui	a5,0x2
ffffffffc0206d28:	e406                	sd	ra,8(sp)
ffffffffc0206d2a:	e022                	sd	s0,0(sp)
ffffffffc0206d2c:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206d30:	17f9                	addi	a5,a5,-2
ffffffffc0206d32:	02e7e963          	bltu	a5,a4,ffffffffc0206d64 <do_kill+0x40>
ffffffffc0206d36:	842a                	mv	s0,a0
ffffffffc0206d38:	45a9                	li	a1,10
ffffffffc0206d3a:	2501                	sext.w	a0,a0
ffffffffc0206d3c:	6ca040ef          	jal	ra,ffffffffc020b406 <hash32>
ffffffffc0206d40:	02051793          	slli	a5,a0,0x20
ffffffffc0206d44:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206d48:	0008b797          	auipc	a5,0x8b
ffffffffc0206d4c:	a7878793          	addi	a5,a5,-1416 # ffffffffc02917c0 <hash_list>
ffffffffc0206d50:	953e                	add	a0,a0,a5
ffffffffc0206d52:	87aa                	mv	a5,a0
ffffffffc0206d54:	a029                	j	ffffffffc0206d5e <do_kill+0x3a>
ffffffffc0206d56:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206d5a:	00870b63          	beq	a4,s0,ffffffffc0206d70 <do_kill+0x4c>
ffffffffc0206d5e:	679c                	ld	a5,8(a5)
ffffffffc0206d60:	fef51be3          	bne	a0,a5,ffffffffc0206d56 <do_kill+0x32>
ffffffffc0206d64:	5475                	li	s0,-3
ffffffffc0206d66:	60a2                	ld	ra,8(sp)
ffffffffc0206d68:	8522                	mv	a0,s0
ffffffffc0206d6a:	6402                	ld	s0,0(sp)
ffffffffc0206d6c:	0141                	addi	sp,sp,16
ffffffffc0206d6e:	8082                	ret
ffffffffc0206d70:	fd87a703          	lw	a4,-40(a5)
ffffffffc0206d74:	00177693          	andi	a3,a4,1
ffffffffc0206d78:	e295                	bnez	a3,ffffffffc0206d9c <do_kill+0x78>
ffffffffc0206d7a:	4bd4                	lw	a3,20(a5)
ffffffffc0206d7c:	00176713          	ori	a4,a4,1
ffffffffc0206d80:	fce7ac23          	sw	a4,-40(a5)
ffffffffc0206d84:	4401                	li	s0,0
ffffffffc0206d86:	fe06d0e3          	bgez	a3,ffffffffc0206d66 <do_kill+0x42>
ffffffffc0206d8a:	f2878513          	addi	a0,a5,-216
ffffffffc0206d8e:	308000ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc0206d92:	60a2                	ld	ra,8(sp)
ffffffffc0206d94:	8522                	mv	a0,s0
ffffffffc0206d96:	6402                	ld	s0,0(sp)
ffffffffc0206d98:	0141                	addi	sp,sp,16
ffffffffc0206d9a:	8082                	ret
ffffffffc0206d9c:	545d                	li	s0,-9
ffffffffc0206d9e:	b7e1                	j	ffffffffc0206d66 <do_kill+0x42>

ffffffffc0206da0 <proc_init>:
ffffffffc0206da0:	1101                	addi	sp,sp,-32
ffffffffc0206da2:	e426                	sd	s1,8(sp)
ffffffffc0206da4:	0008f797          	auipc	a5,0x8f
ffffffffc0206da8:	a1c78793          	addi	a5,a5,-1508 # ffffffffc02957c0 <proc_list>
ffffffffc0206dac:	ec06                	sd	ra,24(sp)
ffffffffc0206dae:	e822                	sd	s0,16(sp)
ffffffffc0206db0:	e04a                	sd	s2,0(sp)
ffffffffc0206db2:	0008b497          	auipc	s1,0x8b
ffffffffc0206db6:	a0e48493          	addi	s1,s1,-1522 # ffffffffc02917c0 <hash_list>
ffffffffc0206dba:	e79c                	sd	a5,8(a5)
ffffffffc0206dbc:	e39c                	sd	a5,0(a5)
ffffffffc0206dbe:	0008f717          	auipc	a4,0x8f
ffffffffc0206dc2:	a0270713          	addi	a4,a4,-1534 # ffffffffc02957c0 <proc_list>
ffffffffc0206dc6:	87a6                	mv	a5,s1
ffffffffc0206dc8:	e79c                	sd	a5,8(a5)
ffffffffc0206dca:	e39c                	sd	a5,0(a5)
ffffffffc0206dcc:	07c1                	addi	a5,a5,16
ffffffffc0206dce:	fef71de3          	bne	a4,a5,ffffffffc0206dc8 <proc_init+0x28>
ffffffffc0206dd2:	c77fe0ef          	jal	ra,ffffffffc0205a48 <alloc_proc>
ffffffffc0206dd6:	00090917          	auipc	s2,0x90
ffffffffc0206dda:	af290913          	addi	s2,s2,-1294 # ffffffffc02968c8 <idleproc>
ffffffffc0206dde:	00a93023          	sd	a0,0(s2)
ffffffffc0206de2:	842a                	mv	s0,a0
ffffffffc0206de4:	12050863          	beqz	a0,ffffffffc0206f14 <proc_init+0x174>
ffffffffc0206de8:	4789                	li	a5,2
ffffffffc0206dea:	e11c                	sd	a5,0(a0)
ffffffffc0206dec:	0000a797          	auipc	a5,0xa
ffffffffc0206df0:	21478793          	addi	a5,a5,532 # ffffffffc0211000 <bootstack>
ffffffffc0206df4:	e91c                	sd	a5,16(a0)
ffffffffc0206df6:	4785                	li	a5,1
ffffffffc0206df8:	ed1c                	sd	a5,24(a0)
ffffffffc0206dfa:	9edfe0ef          	jal	ra,ffffffffc02057e6 <files_create>
ffffffffc0206dfe:	14a43423          	sd	a0,328(s0)
ffffffffc0206e02:	0e050d63          	beqz	a0,ffffffffc0206efc <proc_init+0x15c>
ffffffffc0206e06:	00093403          	ld	s0,0(s2)
ffffffffc0206e0a:	4641                	li	a2,16
ffffffffc0206e0c:	4581                	li	a1,0
ffffffffc0206e0e:	14843703          	ld	a4,328(s0)
ffffffffc0206e12:	0b440413          	addi	s0,s0,180
ffffffffc0206e16:	8522                	mv	a0,s0
ffffffffc0206e18:	4b1c                	lw	a5,16(a4)
ffffffffc0206e1a:	2785                	addiw	a5,a5,1
ffffffffc0206e1c:	cb1c                	sw	a5,16(a4)
ffffffffc0206e1e:	102040ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0206e22:	463d                	li	a2,15
ffffffffc0206e24:	00007597          	auipc	a1,0x7
ffffffffc0206e28:	84458593          	addi	a1,a1,-1980 # ffffffffc020d668 <CSWTCH.79+0x398>
ffffffffc0206e2c:	8522                	mv	a0,s0
ffffffffc0206e2e:	144040ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0206e32:	00090717          	auipc	a4,0x90
ffffffffc0206e36:	aa670713          	addi	a4,a4,-1370 # ffffffffc02968d8 <nr_process>
ffffffffc0206e3a:	431c                	lw	a5,0(a4)
ffffffffc0206e3c:	00093683          	ld	a3,0(s2)
ffffffffc0206e40:	4601                	li	a2,0
ffffffffc0206e42:	2785                	addiw	a5,a5,1
ffffffffc0206e44:	4581                	li	a1,0
ffffffffc0206e46:	fffff517          	auipc	a0,0xfffff
ffffffffc0206e4a:	5a850513          	addi	a0,a0,1448 # ffffffffc02063ee <init_main>
ffffffffc0206e4e:	c31c                	sw	a5,0(a4)
ffffffffc0206e50:	00090797          	auipc	a5,0x90
ffffffffc0206e54:	a6d7b823          	sd	a3,-1424(a5) # ffffffffc02968c0 <current>
ffffffffc0206e58:	a12ff0ef          	jal	ra,ffffffffc020606a <kernel_thread>
ffffffffc0206e5c:	842a                	mv	s0,a0
ffffffffc0206e5e:	08a05363          	blez	a0,ffffffffc0206ee4 <proc_init+0x144>
ffffffffc0206e62:	6789                	lui	a5,0x2
ffffffffc0206e64:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206e68:	17f9                	addi	a5,a5,-2
ffffffffc0206e6a:	2501                	sext.w	a0,a0
ffffffffc0206e6c:	02e7e363          	bltu	a5,a4,ffffffffc0206e92 <proc_init+0xf2>
ffffffffc0206e70:	45a9                	li	a1,10
ffffffffc0206e72:	594040ef          	jal	ra,ffffffffc020b406 <hash32>
ffffffffc0206e76:	02051793          	slli	a5,a0,0x20
ffffffffc0206e7a:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0206e7e:	96a6                	add	a3,a3,s1
ffffffffc0206e80:	87b6                	mv	a5,a3
ffffffffc0206e82:	a029                	j	ffffffffc0206e8c <proc_init+0xec>
ffffffffc0206e84:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_bin_swap_img_size-0x5dd4>
ffffffffc0206e88:	04870b63          	beq	a4,s0,ffffffffc0206ede <proc_init+0x13e>
ffffffffc0206e8c:	679c                	ld	a5,8(a5)
ffffffffc0206e8e:	fef69be3          	bne	a3,a5,ffffffffc0206e84 <proc_init+0xe4>
ffffffffc0206e92:	4781                	li	a5,0
ffffffffc0206e94:	0b478493          	addi	s1,a5,180
ffffffffc0206e98:	4641                	li	a2,16
ffffffffc0206e9a:	4581                	li	a1,0
ffffffffc0206e9c:	00090417          	auipc	s0,0x90
ffffffffc0206ea0:	a3440413          	addi	s0,s0,-1484 # ffffffffc02968d0 <initproc>
ffffffffc0206ea4:	8526                	mv	a0,s1
ffffffffc0206ea6:	e01c                	sd	a5,0(s0)
ffffffffc0206ea8:	078040ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0206eac:	463d                	li	a2,15
ffffffffc0206eae:	00006597          	auipc	a1,0x6
ffffffffc0206eb2:	7e258593          	addi	a1,a1,2018 # ffffffffc020d690 <CSWTCH.79+0x3c0>
ffffffffc0206eb6:	8526                	mv	a0,s1
ffffffffc0206eb8:	0ba040ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0206ebc:	00093783          	ld	a5,0(s2)
ffffffffc0206ec0:	c7d1                	beqz	a5,ffffffffc0206f4c <proc_init+0x1ac>
ffffffffc0206ec2:	43dc                	lw	a5,4(a5)
ffffffffc0206ec4:	e7c1                	bnez	a5,ffffffffc0206f4c <proc_init+0x1ac>
ffffffffc0206ec6:	601c                	ld	a5,0(s0)
ffffffffc0206ec8:	c3b5                	beqz	a5,ffffffffc0206f2c <proc_init+0x18c>
ffffffffc0206eca:	43d8                	lw	a4,4(a5)
ffffffffc0206ecc:	4785                	li	a5,1
ffffffffc0206ece:	04f71f63          	bne	a4,a5,ffffffffc0206f2c <proc_init+0x18c>
ffffffffc0206ed2:	60e2                	ld	ra,24(sp)
ffffffffc0206ed4:	6442                	ld	s0,16(sp)
ffffffffc0206ed6:	64a2                	ld	s1,8(sp)
ffffffffc0206ed8:	6902                	ld	s2,0(sp)
ffffffffc0206eda:	6105                	addi	sp,sp,32
ffffffffc0206edc:	8082                	ret
ffffffffc0206ede:	f2878793          	addi	a5,a5,-216
ffffffffc0206ee2:	bf4d                	j	ffffffffc0206e94 <proc_init+0xf4>
ffffffffc0206ee4:	00006617          	auipc	a2,0x6
ffffffffc0206ee8:	78c60613          	addi	a2,a2,1932 # ffffffffc020d670 <CSWTCH.79+0x3a0>
ffffffffc0206eec:	4d300593          	li	a1,1235
ffffffffc0206ef0:	00006517          	auipc	a0,0x6
ffffffffc0206ef4:	4c050513          	addi	a0,a0,1216 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206ef8:	b36f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206efc:	00006617          	auipc	a2,0x6
ffffffffc0206f00:	74460613          	addi	a2,a2,1860 # ffffffffc020d640 <CSWTCH.79+0x370>
ffffffffc0206f04:	4c700593          	li	a1,1223
ffffffffc0206f08:	00006517          	auipc	a0,0x6
ffffffffc0206f0c:	4a850513          	addi	a0,a0,1192 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206f10:	b1ef90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206f14:	00006617          	auipc	a2,0x6
ffffffffc0206f18:	71460613          	addi	a2,a2,1812 # ffffffffc020d628 <CSWTCH.79+0x358>
ffffffffc0206f1c:	4bd00593          	li	a1,1213
ffffffffc0206f20:	00006517          	auipc	a0,0x6
ffffffffc0206f24:	49050513          	addi	a0,a0,1168 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206f28:	b06f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206f2c:	00006697          	auipc	a3,0x6
ffffffffc0206f30:	79468693          	addi	a3,a3,1940 # ffffffffc020d6c0 <CSWTCH.79+0x3f0>
ffffffffc0206f34:	00005617          	auipc	a2,0x5
ffffffffc0206f38:	9e460613          	addi	a2,a2,-1564 # ffffffffc020b918 <commands+0x250>
ffffffffc0206f3c:	4da00593          	li	a1,1242
ffffffffc0206f40:	00006517          	auipc	a0,0x6
ffffffffc0206f44:	47050513          	addi	a0,a0,1136 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206f48:	ae6f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206f4c:	00006697          	auipc	a3,0x6
ffffffffc0206f50:	74c68693          	addi	a3,a3,1868 # ffffffffc020d698 <CSWTCH.79+0x3c8>
ffffffffc0206f54:	00005617          	auipc	a2,0x5
ffffffffc0206f58:	9c460613          	addi	a2,a2,-1596 # ffffffffc020b918 <commands+0x250>
ffffffffc0206f5c:	4d900593          	li	a1,1241
ffffffffc0206f60:	00006517          	auipc	a0,0x6
ffffffffc0206f64:	45050513          	addi	a0,a0,1104 # ffffffffc020d3b0 <CSWTCH.79+0xe0>
ffffffffc0206f68:	ac6f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0206f6c <cpu_idle>:
ffffffffc0206f6c:	1141                	addi	sp,sp,-16
ffffffffc0206f6e:	e022                	sd	s0,0(sp)
ffffffffc0206f70:	e406                	sd	ra,8(sp)
ffffffffc0206f72:	00090417          	auipc	s0,0x90
ffffffffc0206f76:	94e40413          	addi	s0,s0,-1714 # ffffffffc02968c0 <current>
ffffffffc0206f7a:	6018                	ld	a4,0(s0)
ffffffffc0206f7c:	6f1c                	ld	a5,24(a4)
ffffffffc0206f7e:	dffd                	beqz	a5,ffffffffc0206f7c <cpu_idle+0x10>
ffffffffc0206f80:	1c8000ef          	jal	ra,ffffffffc0207148 <schedule>
ffffffffc0206f84:	bfdd                	j	ffffffffc0206f7a <cpu_idle+0xe>

ffffffffc0206f86 <lab6_set_priority>:
ffffffffc0206f86:	1141                	addi	sp,sp,-16
ffffffffc0206f88:	e022                	sd	s0,0(sp)
ffffffffc0206f8a:	85aa                	mv	a1,a0
ffffffffc0206f8c:	842a                	mv	s0,a0
ffffffffc0206f8e:	00006517          	auipc	a0,0x6
ffffffffc0206f92:	75a50513          	addi	a0,a0,1882 # ffffffffc020d6e8 <CSWTCH.79+0x418>
ffffffffc0206f96:	e406                	sd	ra,8(sp)
ffffffffc0206f98:	992f90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0206f9c:	00090797          	auipc	a5,0x90
ffffffffc0206fa0:	9247b783          	ld	a5,-1756(a5) # ffffffffc02968c0 <current>
ffffffffc0206fa4:	e801                	bnez	s0,ffffffffc0206fb4 <lab6_set_priority+0x2e>
ffffffffc0206fa6:	60a2                	ld	ra,8(sp)
ffffffffc0206fa8:	6402                	ld	s0,0(sp)
ffffffffc0206faa:	4705                	li	a4,1
ffffffffc0206fac:	14e7a223          	sw	a4,324(a5)
ffffffffc0206fb0:	0141                	addi	sp,sp,16
ffffffffc0206fb2:	8082                	ret
ffffffffc0206fb4:	60a2                	ld	ra,8(sp)
ffffffffc0206fb6:	1487a223          	sw	s0,324(a5)
ffffffffc0206fba:	6402                	ld	s0,0(sp)
ffffffffc0206fbc:	0141                	addi	sp,sp,16
ffffffffc0206fbe:	8082                	ret

ffffffffc0206fc0 <do_sleep>:
ffffffffc0206fc0:	c539                	beqz	a0,ffffffffc020700e <do_sleep+0x4e>
ffffffffc0206fc2:	7179                	addi	sp,sp,-48
ffffffffc0206fc4:	f022                	sd	s0,32(sp)
ffffffffc0206fc6:	f406                	sd	ra,40(sp)
ffffffffc0206fc8:	842a                	mv	s0,a0
ffffffffc0206fca:	100027f3          	csrr	a5,sstatus
ffffffffc0206fce:	8b89                	andi	a5,a5,2
ffffffffc0206fd0:	e3a9                	bnez	a5,ffffffffc0207012 <do_sleep+0x52>
ffffffffc0206fd2:	00090797          	auipc	a5,0x90
ffffffffc0206fd6:	8ee7b783          	ld	a5,-1810(a5) # ffffffffc02968c0 <current>
ffffffffc0206fda:	0818                	addi	a4,sp,16
ffffffffc0206fdc:	c02a                	sw	a0,0(sp)
ffffffffc0206fde:	ec3a                	sd	a4,24(sp)
ffffffffc0206fe0:	e83a                	sd	a4,16(sp)
ffffffffc0206fe2:	e43e                	sd	a5,8(sp)
ffffffffc0206fe4:	4705                	li	a4,1
ffffffffc0206fe6:	c398                	sw	a4,0(a5)
ffffffffc0206fe8:	80000737          	lui	a4,0x80000
ffffffffc0206fec:	840a                	mv	s0,sp
ffffffffc0206fee:	0709                	addi	a4,a4,2
ffffffffc0206ff0:	0ee7a623          	sw	a4,236(a5)
ffffffffc0206ff4:	8522                	mv	a0,s0
ffffffffc0206ff6:	212000ef          	jal	ra,ffffffffc0207208 <add_timer>
ffffffffc0206ffa:	14e000ef          	jal	ra,ffffffffc0207148 <schedule>
ffffffffc0206ffe:	8522                	mv	a0,s0
ffffffffc0207000:	2d0000ef          	jal	ra,ffffffffc02072d0 <del_timer>
ffffffffc0207004:	70a2                	ld	ra,40(sp)
ffffffffc0207006:	7402                	ld	s0,32(sp)
ffffffffc0207008:	4501                	li	a0,0
ffffffffc020700a:	6145                	addi	sp,sp,48
ffffffffc020700c:	8082                	ret
ffffffffc020700e:	4501                	li	a0,0
ffffffffc0207010:	8082                	ret
ffffffffc0207012:	d8ff90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0207016:	00090797          	auipc	a5,0x90
ffffffffc020701a:	8aa7b783          	ld	a5,-1878(a5) # ffffffffc02968c0 <current>
ffffffffc020701e:	0818                	addi	a4,sp,16
ffffffffc0207020:	c022                	sw	s0,0(sp)
ffffffffc0207022:	e43e                	sd	a5,8(sp)
ffffffffc0207024:	ec3a                	sd	a4,24(sp)
ffffffffc0207026:	e83a                	sd	a4,16(sp)
ffffffffc0207028:	4705                	li	a4,1
ffffffffc020702a:	c398                	sw	a4,0(a5)
ffffffffc020702c:	80000737          	lui	a4,0x80000
ffffffffc0207030:	0709                	addi	a4,a4,2
ffffffffc0207032:	840a                	mv	s0,sp
ffffffffc0207034:	8522                	mv	a0,s0
ffffffffc0207036:	0ee7a623          	sw	a4,236(a5)
ffffffffc020703a:	1ce000ef          	jal	ra,ffffffffc0207208 <add_timer>
ffffffffc020703e:	d5df90ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0207042:	bf65                	j	ffffffffc0206ffa <do_sleep+0x3a>

ffffffffc0207044 <sched_init>:
ffffffffc0207044:	1141                	addi	sp,sp,-16
ffffffffc0207046:	0008a717          	auipc	a4,0x8a
ffffffffc020704a:	fda70713          	addi	a4,a4,-38 # ffffffffc0291020 <default_sched_class>
ffffffffc020704e:	e022                	sd	s0,0(sp)
ffffffffc0207050:	e406                	sd	ra,8(sp)
ffffffffc0207052:	0008e797          	auipc	a5,0x8e
ffffffffc0207056:	79e78793          	addi	a5,a5,1950 # ffffffffc02957f0 <timer_list>
ffffffffc020705a:	6714                	ld	a3,8(a4)
ffffffffc020705c:	0008e517          	auipc	a0,0x8e
ffffffffc0207060:	77450513          	addi	a0,a0,1908 # ffffffffc02957d0 <__rq>
ffffffffc0207064:	e79c                	sd	a5,8(a5)
ffffffffc0207066:	e39c                	sd	a5,0(a5)
ffffffffc0207068:	4795                	li	a5,5
ffffffffc020706a:	c95c                	sw	a5,20(a0)
ffffffffc020706c:	00090417          	auipc	s0,0x90
ffffffffc0207070:	87c40413          	addi	s0,s0,-1924 # ffffffffc02968e8 <sched_class>
ffffffffc0207074:	00090797          	auipc	a5,0x90
ffffffffc0207078:	86a7b623          	sd	a0,-1940(a5) # ffffffffc02968e0 <rq>
ffffffffc020707c:	e018                	sd	a4,0(s0)
ffffffffc020707e:	9682                	jalr	a3
ffffffffc0207080:	601c                	ld	a5,0(s0)
ffffffffc0207082:	6402                	ld	s0,0(sp)
ffffffffc0207084:	60a2                	ld	ra,8(sp)
ffffffffc0207086:	638c                	ld	a1,0(a5)
ffffffffc0207088:	00006517          	auipc	a0,0x6
ffffffffc020708c:	67850513          	addi	a0,a0,1656 # ffffffffc020d700 <CSWTCH.79+0x430>
ffffffffc0207090:	0141                	addi	sp,sp,16
ffffffffc0207092:	898f906f          	j	ffffffffc020012a <cprintf>

ffffffffc0207096 <wakeup_proc>:
ffffffffc0207096:	4118                	lw	a4,0(a0)
ffffffffc0207098:	1101                	addi	sp,sp,-32
ffffffffc020709a:	ec06                	sd	ra,24(sp)
ffffffffc020709c:	e822                	sd	s0,16(sp)
ffffffffc020709e:	e426                	sd	s1,8(sp)
ffffffffc02070a0:	478d                	li	a5,3
ffffffffc02070a2:	08f70363          	beq	a4,a5,ffffffffc0207128 <wakeup_proc+0x92>
ffffffffc02070a6:	842a                	mv	s0,a0
ffffffffc02070a8:	100027f3          	csrr	a5,sstatus
ffffffffc02070ac:	8b89                	andi	a5,a5,2
ffffffffc02070ae:	4481                	li	s1,0
ffffffffc02070b0:	e7bd                	bnez	a5,ffffffffc020711e <wakeup_proc+0x88>
ffffffffc02070b2:	4789                	li	a5,2
ffffffffc02070b4:	04f70863          	beq	a4,a5,ffffffffc0207104 <wakeup_proc+0x6e>
ffffffffc02070b8:	c01c                	sw	a5,0(s0)
ffffffffc02070ba:	0e042623          	sw	zero,236(s0)
ffffffffc02070be:	00090797          	auipc	a5,0x90
ffffffffc02070c2:	8027b783          	ld	a5,-2046(a5) # ffffffffc02968c0 <current>
ffffffffc02070c6:	02878363          	beq	a5,s0,ffffffffc02070ec <wakeup_proc+0x56>
ffffffffc02070ca:	0008f797          	auipc	a5,0x8f
ffffffffc02070ce:	7fe7b783          	ld	a5,2046(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02070d2:	00f40d63          	beq	s0,a5,ffffffffc02070ec <wakeup_proc+0x56>
ffffffffc02070d6:	00090797          	auipc	a5,0x90
ffffffffc02070da:	8127b783          	ld	a5,-2030(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02070de:	6b9c                	ld	a5,16(a5)
ffffffffc02070e0:	85a2                	mv	a1,s0
ffffffffc02070e2:	0008f517          	auipc	a0,0x8f
ffffffffc02070e6:	7fe53503          	ld	a0,2046(a0) # ffffffffc02968e0 <rq>
ffffffffc02070ea:	9782                	jalr	a5
ffffffffc02070ec:	e491                	bnez	s1,ffffffffc02070f8 <wakeup_proc+0x62>
ffffffffc02070ee:	60e2                	ld	ra,24(sp)
ffffffffc02070f0:	6442                	ld	s0,16(sp)
ffffffffc02070f2:	64a2                	ld	s1,8(sp)
ffffffffc02070f4:	6105                	addi	sp,sp,32
ffffffffc02070f6:	8082                	ret
ffffffffc02070f8:	6442                	ld	s0,16(sp)
ffffffffc02070fa:	60e2                	ld	ra,24(sp)
ffffffffc02070fc:	64a2                	ld	s1,8(sp)
ffffffffc02070fe:	6105                	addi	sp,sp,32
ffffffffc0207100:	c9bf906f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc0207104:	00006617          	auipc	a2,0x6
ffffffffc0207108:	64c60613          	addi	a2,a2,1612 # ffffffffc020d750 <CSWTCH.79+0x480>
ffffffffc020710c:	05200593          	li	a1,82
ffffffffc0207110:	00006517          	auipc	a0,0x6
ffffffffc0207114:	62850513          	addi	a0,a0,1576 # ffffffffc020d738 <CSWTCH.79+0x468>
ffffffffc0207118:	97ef90ef          	jal	ra,ffffffffc0200296 <__warn>
ffffffffc020711c:	bfc1                	j	ffffffffc02070ec <wakeup_proc+0x56>
ffffffffc020711e:	c83f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0207122:	4018                	lw	a4,0(s0)
ffffffffc0207124:	4485                	li	s1,1
ffffffffc0207126:	b771                	j	ffffffffc02070b2 <wakeup_proc+0x1c>
ffffffffc0207128:	00006697          	auipc	a3,0x6
ffffffffc020712c:	5f068693          	addi	a3,a3,1520 # ffffffffc020d718 <CSWTCH.79+0x448>
ffffffffc0207130:	00004617          	auipc	a2,0x4
ffffffffc0207134:	7e860613          	addi	a2,a2,2024 # ffffffffc020b918 <commands+0x250>
ffffffffc0207138:	04300593          	li	a1,67
ffffffffc020713c:	00006517          	auipc	a0,0x6
ffffffffc0207140:	5fc50513          	addi	a0,a0,1532 # ffffffffc020d738 <CSWTCH.79+0x468>
ffffffffc0207144:	8eaf90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207148 <schedule>:
ffffffffc0207148:	7179                	addi	sp,sp,-48
ffffffffc020714a:	f406                	sd	ra,40(sp)
ffffffffc020714c:	f022                	sd	s0,32(sp)
ffffffffc020714e:	ec26                	sd	s1,24(sp)
ffffffffc0207150:	e84a                	sd	s2,16(sp)
ffffffffc0207152:	e44e                	sd	s3,8(sp)
ffffffffc0207154:	e052                	sd	s4,0(sp)
ffffffffc0207156:	100027f3          	csrr	a5,sstatus
ffffffffc020715a:	8b89                	andi	a5,a5,2
ffffffffc020715c:	4a01                	li	s4,0
ffffffffc020715e:	e3cd                	bnez	a5,ffffffffc0207200 <schedule+0xb8>
ffffffffc0207160:	0008f497          	auipc	s1,0x8f
ffffffffc0207164:	76048493          	addi	s1,s1,1888 # ffffffffc02968c0 <current>
ffffffffc0207168:	608c                	ld	a1,0(s1)
ffffffffc020716a:	0008f997          	auipc	s3,0x8f
ffffffffc020716e:	77e98993          	addi	s3,s3,1918 # ffffffffc02968e8 <sched_class>
ffffffffc0207172:	0008f917          	auipc	s2,0x8f
ffffffffc0207176:	76e90913          	addi	s2,s2,1902 # ffffffffc02968e0 <rq>
ffffffffc020717a:	4194                	lw	a3,0(a1)
ffffffffc020717c:	0005bc23          	sd	zero,24(a1)
ffffffffc0207180:	4709                	li	a4,2
ffffffffc0207182:	0009b783          	ld	a5,0(s3)
ffffffffc0207186:	00093503          	ld	a0,0(s2)
ffffffffc020718a:	04e68e63          	beq	a3,a4,ffffffffc02071e6 <schedule+0x9e>
ffffffffc020718e:	739c                	ld	a5,32(a5)
ffffffffc0207190:	9782                	jalr	a5
ffffffffc0207192:	842a                	mv	s0,a0
ffffffffc0207194:	c521                	beqz	a0,ffffffffc02071dc <schedule+0x94>
ffffffffc0207196:	0009b783          	ld	a5,0(s3)
ffffffffc020719a:	00093503          	ld	a0,0(s2)
ffffffffc020719e:	85a2                	mv	a1,s0
ffffffffc02071a0:	6f9c                	ld	a5,24(a5)
ffffffffc02071a2:	9782                	jalr	a5
ffffffffc02071a4:	441c                	lw	a5,8(s0)
ffffffffc02071a6:	6098                	ld	a4,0(s1)
ffffffffc02071a8:	2785                	addiw	a5,a5,1
ffffffffc02071aa:	c41c                	sw	a5,8(s0)
ffffffffc02071ac:	00870563          	beq	a4,s0,ffffffffc02071b6 <schedule+0x6e>
ffffffffc02071b0:	8522                	mv	a0,s0
ffffffffc02071b2:	ab5fe0ef          	jal	ra,ffffffffc0205c66 <proc_run>
ffffffffc02071b6:	000a1a63          	bnez	s4,ffffffffc02071ca <schedule+0x82>
ffffffffc02071ba:	70a2                	ld	ra,40(sp)
ffffffffc02071bc:	7402                	ld	s0,32(sp)
ffffffffc02071be:	64e2                	ld	s1,24(sp)
ffffffffc02071c0:	6942                	ld	s2,16(sp)
ffffffffc02071c2:	69a2                	ld	s3,8(sp)
ffffffffc02071c4:	6a02                	ld	s4,0(sp)
ffffffffc02071c6:	6145                	addi	sp,sp,48
ffffffffc02071c8:	8082                	ret
ffffffffc02071ca:	7402                	ld	s0,32(sp)
ffffffffc02071cc:	70a2                	ld	ra,40(sp)
ffffffffc02071ce:	64e2                	ld	s1,24(sp)
ffffffffc02071d0:	6942                	ld	s2,16(sp)
ffffffffc02071d2:	69a2                	ld	s3,8(sp)
ffffffffc02071d4:	6a02                	ld	s4,0(sp)
ffffffffc02071d6:	6145                	addi	sp,sp,48
ffffffffc02071d8:	bc3f906f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc02071dc:	0008f417          	auipc	s0,0x8f
ffffffffc02071e0:	6ec43403          	ld	s0,1772(s0) # ffffffffc02968c8 <idleproc>
ffffffffc02071e4:	b7c1                	j	ffffffffc02071a4 <schedule+0x5c>
ffffffffc02071e6:	0008f717          	auipc	a4,0x8f
ffffffffc02071ea:	6e273703          	ld	a4,1762(a4) # ffffffffc02968c8 <idleproc>
ffffffffc02071ee:	fae580e3          	beq	a1,a4,ffffffffc020718e <schedule+0x46>
ffffffffc02071f2:	6b9c                	ld	a5,16(a5)
ffffffffc02071f4:	9782                	jalr	a5
ffffffffc02071f6:	0009b783          	ld	a5,0(s3)
ffffffffc02071fa:	00093503          	ld	a0,0(s2)
ffffffffc02071fe:	bf41                	j	ffffffffc020718e <schedule+0x46>
ffffffffc0207200:	ba1f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0207204:	4a05                	li	s4,1
ffffffffc0207206:	bfa9                	j	ffffffffc0207160 <schedule+0x18>

ffffffffc0207208 <add_timer>:
ffffffffc0207208:	1141                	addi	sp,sp,-16
ffffffffc020720a:	e022                	sd	s0,0(sp)
ffffffffc020720c:	e406                	sd	ra,8(sp)
ffffffffc020720e:	842a                	mv	s0,a0
ffffffffc0207210:	100027f3          	csrr	a5,sstatus
ffffffffc0207214:	8b89                	andi	a5,a5,2
ffffffffc0207216:	4501                	li	a0,0
ffffffffc0207218:	eba5                	bnez	a5,ffffffffc0207288 <add_timer+0x80>
ffffffffc020721a:	401c                	lw	a5,0(s0)
ffffffffc020721c:	cbb5                	beqz	a5,ffffffffc0207290 <add_timer+0x88>
ffffffffc020721e:	6418                	ld	a4,8(s0)
ffffffffc0207220:	cb25                	beqz	a4,ffffffffc0207290 <add_timer+0x88>
ffffffffc0207222:	6c18                	ld	a4,24(s0)
ffffffffc0207224:	01040593          	addi	a1,s0,16
ffffffffc0207228:	08e59463          	bne	a1,a4,ffffffffc02072b0 <add_timer+0xa8>
ffffffffc020722c:	0008e617          	auipc	a2,0x8e
ffffffffc0207230:	5c460613          	addi	a2,a2,1476 # ffffffffc02957f0 <timer_list>
ffffffffc0207234:	6618                	ld	a4,8(a2)
ffffffffc0207236:	00c71863          	bne	a4,a2,ffffffffc0207246 <add_timer+0x3e>
ffffffffc020723a:	a80d                	j	ffffffffc020726c <add_timer+0x64>
ffffffffc020723c:	6718                	ld	a4,8(a4)
ffffffffc020723e:	9f95                	subw	a5,a5,a3
ffffffffc0207240:	c01c                	sw	a5,0(s0)
ffffffffc0207242:	02c70563          	beq	a4,a2,ffffffffc020726c <add_timer+0x64>
ffffffffc0207246:	ff072683          	lw	a3,-16(a4)
ffffffffc020724a:	fed7f9e3          	bgeu	a5,a3,ffffffffc020723c <add_timer+0x34>
ffffffffc020724e:	40f687bb          	subw	a5,a3,a5
ffffffffc0207252:	fef72823          	sw	a5,-16(a4)
ffffffffc0207256:	631c                	ld	a5,0(a4)
ffffffffc0207258:	e30c                	sd	a1,0(a4)
ffffffffc020725a:	e78c                	sd	a1,8(a5)
ffffffffc020725c:	ec18                	sd	a4,24(s0)
ffffffffc020725e:	e81c                	sd	a5,16(s0)
ffffffffc0207260:	c105                	beqz	a0,ffffffffc0207280 <add_timer+0x78>
ffffffffc0207262:	6402                	ld	s0,0(sp)
ffffffffc0207264:	60a2                	ld	ra,8(sp)
ffffffffc0207266:	0141                	addi	sp,sp,16
ffffffffc0207268:	b33f906f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc020726c:	0008e717          	auipc	a4,0x8e
ffffffffc0207270:	58470713          	addi	a4,a4,1412 # ffffffffc02957f0 <timer_list>
ffffffffc0207274:	631c                	ld	a5,0(a4)
ffffffffc0207276:	e30c                	sd	a1,0(a4)
ffffffffc0207278:	e78c                	sd	a1,8(a5)
ffffffffc020727a:	ec18                	sd	a4,24(s0)
ffffffffc020727c:	e81c                	sd	a5,16(s0)
ffffffffc020727e:	f175                	bnez	a0,ffffffffc0207262 <add_timer+0x5a>
ffffffffc0207280:	60a2                	ld	ra,8(sp)
ffffffffc0207282:	6402                	ld	s0,0(sp)
ffffffffc0207284:	0141                	addi	sp,sp,16
ffffffffc0207286:	8082                	ret
ffffffffc0207288:	b19f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020728c:	4505                	li	a0,1
ffffffffc020728e:	b771                	j	ffffffffc020721a <add_timer+0x12>
ffffffffc0207290:	00006697          	auipc	a3,0x6
ffffffffc0207294:	4e068693          	addi	a3,a3,1248 # ffffffffc020d770 <CSWTCH.79+0x4a0>
ffffffffc0207298:	00004617          	auipc	a2,0x4
ffffffffc020729c:	68060613          	addi	a2,a2,1664 # ffffffffc020b918 <commands+0x250>
ffffffffc02072a0:	07a00593          	li	a1,122
ffffffffc02072a4:	00006517          	auipc	a0,0x6
ffffffffc02072a8:	49450513          	addi	a0,a0,1172 # ffffffffc020d738 <CSWTCH.79+0x468>
ffffffffc02072ac:	f83f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02072b0:	00006697          	auipc	a3,0x6
ffffffffc02072b4:	4f068693          	addi	a3,a3,1264 # ffffffffc020d7a0 <CSWTCH.79+0x4d0>
ffffffffc02072b8:	00004617          	auipc	a2,0x4
ffffffffc02072bc:	66060613          	addi	a2,a2,1632 # ffffffffc020b918 <commands+0x250>
ffffffffc02072c0:	07b00593          	li	a1,123
ffffffffc02072c4:	00006517          	auipc	a0,0x6
ffffffffc02072c8:	47450513          	addi	a0,a0,1140 # ffffffffc020d738 <CSWTCH.79+0x468>
ffffffffc02072cc:	f63f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02072d0 <del_timer>:
ffffffffc02072d0:	1101                	addi	sp,sp,-32
ffffffffc02072d2:	e822                	sd	s0,16(sp)
ffffffffc02072d4:	ec06                	sd	ra,24(sp)
ffffffffc02072d6:	e426                	sd	s1,8(sp)
ffffffffc02072d8:	842a                	mv	s0,a0
ffffffffc02072da:	100027f3          	csrr	a5,sstatus
ffffffffc02072de:	8b89                	andi	a5,a5,2
ffffffffc02072e0:	01050493          	addi	s1,a0,16
ffffffffc02072e4:	eb9d                	bnez	a5,ffffffffc020731a <del_timer+0x4a>
ffffffffc02072e6:	6d1c                	ld	a5,24(a0)
ffffffffc02072e8:	02978463          	beq	a5,s1,ffffffffc0207310 <del_timer+0x40>
ffffffffc02072ec:	4114                	lw	a3,0(a0)
ffffffffc02072ee:	6918                	ld	a4,16(a0)
ffffffffc02072f0:	ce81                	beqz	a3,ffffffffc0207308 <del_timer+0x38>
ffffffffc02072f2:	0008e617          	auipc	a2,0x8e
ffffffffc02072f6:	4fe60613          	addi	a2,a2,1278 # ffffffffc02957f0 <timer_list>
ffffffffc02072fa:	00c78763          	beq	a5,a2,ffffffffc0207308 <del_timer+0x38>
ffffffffc02072fe:	ff07a603          	lw	a2,-16(a5)
ffffffffc0207302:	9eb1                	addw	a3,a3,a2
ffffffffc0207304:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207308:	e71c                	sd	a5,8(a4)
ffffffffc020730a:	e398                	sd	a4,0(a5)
ffffffffc020730c:	ec04                	sd	s1,24(s0)
ffffffffc020730e:	e804                	sd	s1,16(s0)
ffffffffc0207310:	60e2                	ld	ra,24(sp)
ffffffffc0207312:	6442                	ld	s0,16(sp)
ffffffffc0207314:	64a2                	ld	s1,8(sp)
ffffffffc0207316:	6105                	addi	sp,sp,32
ffffffffc0207318:	8082                	ret
ffffffffc020731a:	a87f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020731e:	6c1c                	ld	a5,24(s0)
ffffffffc0207320:	02978463          	beq	a5,s1,ffffffffc0207348 <del_timer+0x78>
ffffffffc0207324:	4014                	lw	a3,0(s0)
ffffffffc0207326:	6818                	ld	a4,16(s0)
ffffffffc0207328:	ce81                	beqz	a3,ffffffffc0207340 <del_timer+0x70>
ffffffffc020732a:	0008e617          	auipc	a2,0x8e
ffffffffc020732e:	4c660613          	addi	a2,a2,1222 # ffffffffc02957f0 <timer_list>
ffffffffc0207332:	00c78763          	beq	a5,a2,ffffffffc0207340 <del_timer+0x70>
ffffffffc0207336:	ff07a603          	lw	a2,-16(a5)
ffffffffc020733a:	9eb1                	addw	a3,a3,a2
ffffffffc020733c:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207340:	e71c                	sd	a5,8(a4)
ffffffffc0207342:	e398                	sd	a4,0(a5)
ffffffffc0207344:	ec04                	sd	s1,24(s0)
ffffffffc0207346:	e804                	sd	s1,16(s0)
ffffffffc0207348:	6442                	ld	s0,16(sp)
ffffffffc020734a:	60e2                	ld	ra,24(sp)
ffffffffc020734c:	64a2                	ld	s1,8(sp)
ffffffffc020734e:	6105                	addi	sp,sp,32
ffffffffc0207350:	a4bf906f          	j	ffffffffc0200d9a <intr_enable>

ffffffffc0207354 <run_timer_list>:
ffffffffc0207354:	7139                	addi	sp,sp,-64
ffffffffc0207356:	fc06                	sd	ra,56(sp)
ffffffffc0207358:	f822                	sd	s0,48(sp)
ffffffffc020735a:	f426                	sd	s1,40(sp)
ffffffffc020735c:	f04a                	sd	s2,32(sp)
ffffffffc020735e:	ec4e                	sd	s3,24(sp)
ffffffffc0207360:	e852                	sd	s4,16(sp)
ffffffffc0207362:	e456                	sd	s5,8(sp)
ffffffffc0207364:	e05a                	sd	s6,0(sp)
ffffffffc0207366:	100027f3          	csrr	a5,sstatus
ffffffffc020736a:	8b89                	andi	a5,a5,2
ffffffffc020736c:	4b01                	li	s6,0
ffffffffc020736e:	efe9                	bnez	a5,ffffffffc0207448 <run_timer_list+0xf4>
ffffffffc0207370:	0008e997          	auipc	s3,0x8e
ffffffffc0207374:	48098993          	addi	s3,s3,1152 # ffffffffc02957f0 <timer_list>
ffffffffc0207378:	0089b403          	ld	s0,8(s3)
ffffffffc020737c:	07340a63          	beq	s0,s3,ffffffffc02073f0 <run_timer_list+0x9c>
ffffffffc0207380:	ff042783          	lw	a5,-16(s0)
ffffffffc0207384:	ff040913          	addi	s2,s0,-16
ffffffffc0207388:	0e078763          	beqz	a5,ffffffffc0207476 <run_timer_list+0x122>
ffffffffc020738c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0207390:	fee42823          	sw	a4,-16(s0)
ffffffffc0207394:	ef31                	bnez	a4,ffffffffc02073f0 <run_timer_list+0x9c>
ffffffffc0207396:	00006a97          	auipc	s5,0x6
ffffffffc020739a:	472a8a93          	addi	s5,s5,1138 # ffffffffc020d808 <CSWTCH.79+0x538>
ffffffffc020739e:	00006a17          	auipc	s4,0x6
ffffffffc02073a2:	39aa0a13          	addi	s4,s4,922 # ffffffffc020d738 <CSWTCH.79+0x468>
ffffffffc02073a6:	a005                	j	ffffffffc02073c6 <run_timer_list+0x72>
ffffffffc02073a8:	0a07d763          	bgez	a5,ffffffffc0207456 <run_timer_list+0x102>
ffffffffc02073ac:	8526                	mv	a0,s1
ffffffffc02073ae:	ce9ff0ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc02073b2:	854a                	mv	a0,s2
ffffffffc02073b4:	f1dff0ef          	jal	ra,ffffffffc02072d0 <del_timer>
ffffffffc02073b8:	03340c63          	beq	s0,s3,ffffffffc02073f0 <run_timer_list+0x9c>
ffffffffc02073bc:	ff042783          	lw	a5,-16(s0)
ffffffffc02073c0:	ff040913          	addi	s2,s0,-16
ffffffffc02073c4:	e795                	bnez	a5,ffffffffc02073f0 <run_timer_list+0x9c>
ffffffffc02073c6:	00893483          	ld	s1,8(s2)
ffffffffc02073ca:	6400                	ld	s0,8(s0)
ffffffffc02073cc:	0ec4a783          	lw	a5,236(s1)
ffffffffc02073d0:	ffe1                	bnez	a5,ffffffffc02073a8 <run_timer_list+0x54>
ffffffffc02073d2:	40d4                	lw	a3,4(s1)
ffffffffc02073d4:	8656                	mv	a2,s5
ffffffffc02073d6:	0ba00593          	li	a1,186
ffffffffc02073da:	8552                	mv	a0,s4
ffffffffc02073dc:	ebbf80ef          	jal	ra,ffffffffc0200296 <__warn>
ffffffffc02073e0:	8526                	mv	a0,s1
ffffffffc02073e2:	cb5ff0ef          	jal	ra,ffffffffc0207096 <wakeup_proc>
ffffffffc02073e6:	854a                	mv	a0,s2
ffffffffc02073e8:	ee9ff0ef          	jal	ra,ffffffffc02072d0 <del_timer>
ffffffffc02073ec:	fd3418e3          	bne	s0,s3,ffffffffc02073bc <run_timer_list+0x68>
ffffffffc02073f0:	0008f597          	auipc	a1,0x8f
ffffffffc02073f4:	4d05b583          	ld	a1,1232(a1) # ffffffffc02968c0 <current>
ffffffffc02073f8:	c18d                	beqz	a1,ffffffffc020741a <run_timer_list+0xc6>
ffffffffc02073fa:	0008f797          	auipc	a5,0x8f
ffffffffc02073fe:	4ce7b783          	ld	a5,1230(a5) # ffffffffc02968c8 <idleproc>
ffffffffc0207402:	04f58763          	beq	a1,a5,ffffffffc0207450 <run_timer_list+0xfc>
ffffffffc0207406:	0008f797          	auipc	a5,0x8f
ffffffffc020740a:	4e27b783          	ld	a5,1250(a5) # ffffffffc02968e8 <sched_class>
ffffffffc020740e:	779c                	ld	a5,40(a5)
ffffffffc0207410:	0008f517          	auipc	a0,0x8f
ffffffffc0207414:	4d053503          	ld	a0,1232(a0) # ffffffffc02968e0 <rq>
ffffffffc0207418:	9782                	jalr	a5
ffffffffc020741a:	000b1c63          	bnez	s6,ffffffffc0207432 <run_timer_list+0xde>
ffffffffc020741e:	70e2                	ld	ra,56(sp)
ffffffffc0207420:	7442                	ld	s0,48(sp)
ffffffffc0207422:	74a2                	ld	s1,40(sp)
ffffffffc0207424:	7902                	ld	s2,32(sp)
ffffffffc0207426:	69e2                	ld	s3,24(sp)
ffffffffc0207428:	6a42                	ld	s4,16(sp)
ffffffffc020742a:	6aa2                	ld	s5,8(sp)
ffffffffc020742c:	6b02                	ld	s6,0(sp)
ffffffffc020742e:	6121                	addi	sp,sp,64
ffffffffc0207430:	8082                	ret
ffffffffc0207432:	7442                	ld	s0,48(sp)
ffffffffc0207434:	70e2                	ld	ra,56(sp)
ffffffffc0207436:	74a2                	ld	s1,40(sp)
ffffffffc0207438:	7902                	ld	s2,32(sp)
ffffffffc020743a:	69e2                	ld	s3,24(sp)
ffffffffc020743c:	6a42                	ld	s4,16(sp)
ffffffffc020743e:	6aa2                	ld	s5,8(sp)
ffffffffc0207440:	6b02                	ld	s6,0(sp)
ffffffffc0207442:	6121                	addi	sp,sp,64
ffffffffc0207444:	957f906f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc0207448:	959f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020744c:	4b05                	li	s6,1
ffffffffc020744e:	b70d                	j	ffffffffc0207370 <run_timer_list+0x1c>
ffffffffc0207450:	4785                	li	a5,1
ffffffffc0207452:	ed9c                	sd	a5,24(a1)
ffffffffc0207454:	b7d9                	j	ffffffffc020741a <run_timer_list+0xc6>
ffffffffc0207456:	00006697          	auipc	a3,0x6
ffffffffc020745a:	38a68693          	addi	a3,a3,906 # ffffffffc020d7e0 <CSWTCH.79+0x510>
ffffffffc020745e:	00004617          	auipc	a2,0x4
ffffffffc0207462:	4ba60613          	addi	a2,a2,1210 # ffffffffc020b918 <commands+0x250>
ffffffffc0207466:	0b600593          	li	a1,182
ffffffffc020746a:	00006517          	auipc	a0,0x6
ffffffffc020746e:	2ce50513          	addi	a0,a0,718 # ffffffffc020d738 <CSWTCH.79+0x468>
ffffffffc0207472:	dbdf80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207476:	00006697          	auipc	a3,0x6
ffffffffc020747a:	35268693          	addi	a3,a3,850 # ffffffffc020d7c8 <CSWTCH.79+0x4f8>
ffffffffc020747e:	00004617          	auipc	a2,0x4
ffffffffc0207482:	49a60613          	addi	a2,a2,1178 # ffffffffc020b918 <commands+0x250>
ffffffffc0207486:	0ae00593          	li	a1,174
ffffffffc020748a:	00006517          	auipc	a0,0x6
ffffffffc020748e:	2ae50513          	addi	a0,a0,686 # ffffffffc020d738 <CSWTCH.79+0x468>
ffffffffc0207492:	d9df80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207496 <RR_init>:
ffffffffc0207496:	e508                	sd	a0,8(a0)
ffffffffc0207498:	e108                	sd	a0,0(a0)
ffffffffc020749a:	00052823          	sw	zero,16(a0)
ffffffffc020749e:	8082                	ret

ffffffffc02074a0 <RR_pick_next>:
ffffffffc02074a0:	651c                	ld	a5,8(a0)
ffffffffc02074a2:	00f50563          	beq	a0,a5,ffffffffc02074ac <RR_pick_next+0xc>
ffffffffc02074a6:	ef078513          	addi	a0,a5,-272
ffffffffc02074aa:	8082                	ret
ffffffffc02074ac:	4501                	li	a0,0
ffffffffc02074ae:	8082                	ret

ffffffffc02074b0 <RR_proc_tick>:
ffffffffc02074b0:	1205a783          	lw	a5,288(a1)
ffffffffc02074b4:	00f05563          	blez	a5,ffffffffc02074be <RR_proc_tick+0xe>
ffffffffc02074b8:	37fd                	addiw	a5,a5,-1
ffffffffc02074ba:	12f5a023          	sw	a5,288(a1)
ffffffffc02074be:	e399                	bnez	a5,ffffffffc02074c4 <RR_proc_tick+0x14>
ffffffffc02074c0:	4785                	li	a5,1
ffffffffc02074c2:	ed9c                	sd	a5,24(a1)
ffffffffc02074c4:	8082                	ret

ffffffffc02074c6 <RR_dequeue>:
ffffffffc02074c6:	1185b703          	ld	a4,280(a1)
ffffffffc02074ca:	11058793          	addi	a5,a1,272
ffffffffc02074ce:	02e78363          	beq	a5,a4,ffffffffc02074f4 <RR_dequeue+0x2e>
ffffffffc02074d2:	1085b683          	ld	a3,264(a1)
ffffffffc02074d6:	00a69f63          	bne	a3,a0,ffffffffc02074f4 <RR_dequeue+0x2e>
ffffffffc02074da:	1105b503          	ld	a0,272(a1)
ffffffffc02074de:	4a90                	lw	a2,16(a3)
ffffffffc02074e0:	e518                	sd	a4,8(a0)
ffffffffc02074e2:	e308                	sd	a0,0(a4)
ffffffffc02074e4:	10f5bc23          	sd	a5,280(a1)
ffffffffc02074e8:	10f5b823          	sd	a5,272(a1)
ffffffffc02074ec:	fff6079b          	addiw	a5,a2,-1
ffffffffc02074f0:	ca9c                	sw	a5,16(a3)
ffffffffc02074f2:	8082                	ret
ffffffffc02074f4:	1141                	addi	sp,sp,-16
ffffffffc02074f6:	00006697          	auipc	a3,0x6
ffffffffc02074fa:	33268693          	addi	a3,a3,818 # ffffffffc020d828 <CSWTCH.79+0x558>
ffffffffc02074fe:	00004617          	auipc	a2,0x4
ffffffffc0207502:	41a60613          	addi	a2,a2,1050 # ffffffffc020b918 <commands+0x250>
ffffffffc0207506:	03c00593          	li	a1,60
ffffffffc020750a:	00006517          	auipc	a0,0x6
ffffffffc020750e:	35650513          	addi	a0,a0,854 # ffffffffc020d860 <CSWTCH.79+0x590>
ffffffffc0207512:	e406                	sd	ra,8(sp)
ffffffffc0207514:	d1bf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207518 <RR_enqueue>:
ffffffffc0207518:	1185b703          	ld	a4,280(a1)
ffffffffc020751c:	11058793          	addi	a5,a1,272
ffffffffc0207520:	02e79d63          	bne	a5,a4,ffffffffc020755a <RR_enqueue+0x42>
ffffffffc0207524:	6118                	ld	a4,0(a0)
ffffffffc0207526:	1205a683          	lw	a3,288(a1)
ffffffffc020752a:	e11c                	sd	a5,0(a0)
ffffffffc020752c:	e71c                	sd	a5,8(a4)
ffffffffc020752e:	10a5bc23          	sd	a0,280(a1)
ffffffffc0207532:	10e5b823          	sd	a4,272(a1)
ffffffffc0207536:	495c                	lw	a5,20(a0)
ffffffffc0207538:	ea89                	bnez	a3,ffffffffc020754a <RR_enqueue+0x32>
ffffffffc020753a:	12f5a023          	sw	a5,288(a1)
ffffffffc020753e:	491c                	lw	a5,16(a0)
ffffffffc0207540:	10a5b423          	sd	a0,264(a1)
ffffffffc0207544:	2785                	addiw	a5,a5,1
ffffffffc0207546:	c91c                	sw	a5,16(a0)
ffffffffc0207548:	8082                	ret
ffffffffc020754a:	fed7c8e3          	blt	a5,a3,ffffffffc020753a <RR_enqueue+0x22>
ffffffffc020754e:	491c                	lw	a5,16(a0)
ffffffffc0207550:	10a5b423          	sd	a0,264(a1)
ffffffffc0207554:	2785                	addiw	a5,a5,1
ffffffffc0207556:	c91c                	sw	a5,16(a0)
ffffffffc0207558:	8082                	ret
ffffffffc020755a:	1141                	addi	sp,sp,-16
ffffffffc020755c:	00006697          	auipc	a3,0x6
ffffffffc0207560:	32468693          	addi	a3,a3,804 # ffffffffc020d880 <CSWTCH.79+0x5b0>
ffffffffc0207564:	00004617          	auipc	a2,0x4
ffffffffc0207568:	3b460613          	addi	a2,a2,948 # ffffffffc020b918 <commands+0x250>
ffffffffc020756c:	02800593          	li	a1,40
ffffffffc0207570:	00006517          	auipc	a0,0x6
ffffffffc0207574:	2f050513          	addi	a0,a0,752 # ffffffffc020d860 <CSWTCH.79+0x590>
ffffffffc0207578:	e406                	sd	ra,8(sp)
ffffffffc020757a:	cb5f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020757e <sys_getpid>:
ffffffffc020757e:	0008f797          	auipc	a5,0x8f
ffffffffc0207582:	3427b783          	ld	a5,834(a5) # ffffffffc02968c0 <current>
ffffffffc0207586:	43c8                	lw	a0,4(a5)
ffffffffc0207588:	8082                	ret

ffffffffc020758a <sys_pgdir>:
ffffffffc020758a:	4501                	li	a0,0
ffffffffc020758c:	8082                	ret

ffffffffc020758e <sys_gettime>:
ffffffffc020758e:	0008f797          	auipc	a5,0x8f
ffffffffc0207592:	2f27b783          	ld	a5,754(a5) # ffffffffc0296880 <ticks>
ffffffffc0207596:	0027951b          	slliw	a0,a5,0x2
ffffffffc020759a:	9d3d                	addw	a0,a0,a5
ffffffffc020759c:	0015151b          	slliw	a0,a0,0x1
ffffffffc02075a0:	8082                	ret

ffffffffc02075a2 <sys_lab6_set_priority>:
ffffffffc02075a2:	4108                	lw	a0,0(a0)
ffffffffc02075a4:	1141                	addi	sp,sp,-16
ffffffffc02075a6:	e406                	sd	ra,8(sp)
ffffffffc02075a8:	9dfff0ef          	jal	ra,ffffffffc0206f86 <lab6_set_priority>
ffffffffc02075ac:	60a2                	ld	ra,8(sp)
ffffffffc02075ae:	4501                	li	a0,0
ffffffffc02075b0:	0141                	addi	sp,sp,16
ffffffffc02075b2:	8082                	ret

ffffffffc02075b4 <sys_dup>:
ffffffffc02075b4:	450c                	lw	a1,8(a0)
ffffffffc02075b6:	4108                	lw	a0,0(a0)
ffffffffc02075b8:	f14fd06f          	j	ffffffffc0204ccc <sysfile_dup>

ffffffffc02075bc <sys_getdirentry>:
ffffffffc02075bc:	650c                	ld	a1,8(a0)
ffffffffc02075be:	4108                	lw	a0,0(a0)
ffffffffc02075c0:	e1cfd06f          	j	ffffffffc0204bdc <sysfile_getdirentry>

ffffffffc02075c4 <sys_getcwd>:
ffffffffc02075c4:	650c                	ld	a1,8(a0)
ffffffffc02075c6:	6108                	ld	a0,0(a0)
ffffffffc02075c8:	d70fd06f          	j	ffffffffc0204b38 <sysfile_getcwd>

ffffffffc02075cc <sys_fsync>:
ffffffffc02075cc:	4108                	lw	a0,0(a0)
ffffffffc02075ce:	d66fd06f          	j	ffffffffc0204b34 <sysfile_fsync>

ffffffffc02075d2 <sys_fstat>:
ffffffffc02075d2:	650c                	ld	a1,8(a0)
ffffffffc02075d4:	4108                	lw	a0,0(a0)
ffffffffc02075d6:	cbefd06f          	j	ffffffffc0204a94 <sysfile_fstat>

ffffffffc02075da <sys_seek>:
ffffffffc02075da:	4910                	lw	a2,16(a0)
ffffffffc02075dc:	650c                	ld	a1,8(a0)
ffffffffc02075de:	4108                	lw	a0,0(a0)
ffffffffc02075e0:	cb0fd06f          	j	ffffffffc0204a90 <sysfile_seek>

ffffffffc02075e4 <sys_write>:
ffffffffc02075e4:	6910                	ld	a2,16(a0)
ffffffffc02075e6:	650c                	ld	a1,8(a0)
ffffffffc02075e8:	4108                	lw	a0,0(a0)
ffffffffc02075ea:	b8cfd06f          	j	ffffffffc0204976 <sysfile_write>

ffffffffc02075ee <sys_read>:
ffffffffc02075ee:	6910                	ld	a2,16(a0)
ffffffffc02075f0:	650c                	ld	a1,8(a0)
ffffffffc02075f2:	4108                	lw	a0,0(a0)
ffffffffc02075f4:	a6efd06f          	j	ffffffffc0204862 <sysfile_read>

ffffffffc02075f8 <sys_close>:
ffffffffc02075f8:	4108                	lw	a0,0(a0)
ffffffffc02075fa:	a64fd06f          	j	ffffffffc020485e <sysfile_close>

ffffffffc02075fe <sys_open>:
ffffffffc02075fe:	450c                	lw	a1,8(a0)
ffffffffc0207600:	6108                	ld	a0,0(a0)
ffffffffc0207602:	a28fd06f          	j	ffffffffc020482a <sysfile_open>

ffffffffc0207606 <sys_putc>:
ffffffffc0207606:	4108                	lw	a0,0(a0)
ffffffffc0207608:	1141                	addi	sp,sp,-16
ffffffffc020760a:	e406                	sd	ra,8(sp)
ffffffffc020760c:	b5bf80ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc0207610:	60a2                	ld	ra,8(sp)
ffffffffc0207612:	4501                	li	a0,0
ffffffffc0207614:	0141                	addi	sp,sp,16
ffffffffc0207616:	8082                	ret

ffffffffc0207618 <sys_kill>:
ffffffffc0207618:	4108                	lw	a0,0(a0)
ffffffffc020761a:	f0aff06f          	j	ffffffffc0206d24 <do_kill>

ffffffffc020761e <sys_sleep>:
ffffffffc020761e:	4108                	lw	a0,0(a0)
ffffffffc0207620:	9a1ff06f          	j	ffffffffc0206fc0 <do_sleep>

ffffffffc0207624 <sys_yield>:
ffffffffc0207624:	eb2ff06f          	j	ffffffffc0206cd6 <do_yield>

ffffffffc0207628 <sys_exec>:
ffffffffc0207628:	6910                	ld	a2,16(a0)
ffffffffc020762a:	450c                	lw	a1,8(a0)
ffffffffc020762c:	6108                	ld	a0,0(a0)
ffffffffc020762e:	f11fe06f          	j	ffffffffc020653e <do_execve>

ffffffffc0207632 <sys_wait>:
ffffffffc0207632:	650c                	ld	a1,8(a0)
ffffffffc0207634:	4108                	lw	a0,0(a0)
ffffffffc0207636:	eb0ff06f          	j	ffffffffc0206ce6 <do_wait>

ffffffffc020763a <sys_fork>:
ffffffffc020763a:	0008f797          	auipc	a5,0x8f
ffffffffc020763e:	2867b783          	ld	a5,646(a5) # ffffffffc02968c0 <current>
ffffffffc0207642:	73d0                	ld	a2,160(a5)
ffffffffc0207644:	4501                	li	a0,0
ffffffffc0207646:	6a0c                	ld	a1,16(a2)
ffffffffc0207648:	e98fe06f          	j	ffffffffc0205ce0 <do_fork>

ffffffffc020764c <sys_exit>:
ffffffffc020764c:	4108                	lw	a0,0(a0)
ffffffffc020764e:	a6dfe06f          	j	ffffffffc02060ba <do_exit>

ffffffffc0207652 <syscall>:
ffffffffc0207652:	715d                	addi	sp,sp,-80
ffffffffc0207654:	fc26                	sd	s1,56(sp)
ffffffffc0207656:	0008f497          	auipc	s1,0x8f
ffffffffc020765a:	26a48493          	addi	s1,s1,618 # ffffffffc02968c0 <current>
ffffffffc020765e:	6098                	ld	a4,0(s1)
ffffffffc0207660:	e0a2                	sd	s0,64(sp)
ffffffffc0207662:	f84a                	sd	s2,48(sp)
ffffffffc0207664:	7340                	ld	s0,160(a4)
ffffffffc0207666:	e486                	sd	ra,72(sp)
ffffffffc0207668:	0ff00793          	li	a5,255
ffffffffc020766c:	05042903          	lw	s2,80(s0)
ffffffffc0207670:	0327ee63          	bltu	a5,s2,ffffffffc02076ac <syscall+0x5a>
ffffffffc0207674:	00391713          	slli	a4,s2,0x3
ffffffffc0207678:	00006797          	auipc	a5,0x6
ffffffffc020767c:	28078793          	addi	a5,a5,640 # ffffffffc020d8f8 <syscalls>
ffffffffc0207680:	97ba                	add	a5,a5,a4
ffffffffc0207682:	639c                	ld	a5,0(a5)
ffffffffc0207684:	c785                	beqz	a5,ffffffffc02076ac <syscall+0x5a>
ffffffffc0207686:	6c28                	ld	a0,88(s0)
ffffffffc0207688:	702c                	ld	a1,96(s0)
ffffffffc020768a:	7430                	ld	a2,104(s0)
ffffffffc020768c:	7834                	ld	a3,112(s0)
ffffffffc020768e:	7c38                	ld	a4,120(s0)
ffffffffc0207690:	e42a                	sd	a0,8(sp)
ffffffffc0207692:	e82e                	sd	a1,16(sp)
ffffffffc0207694:	ec32                	sd	a2,24(sp)
ffffffffc0207696:	f036                	sd	a3,32(sp)
ffffffffc0207698:	f43a                	sd	a4,40(sp)
ffffffffc020769a:	0028                	addi	a0,sp,8
ffffffffc020769c:	9782                	jalr	a5
ffffffffc020769e:	60a6                	ld	ra,72(sp)
ffffffffc02076a0:	e828                	sd	a0,80(s0)
ffffffffc02076a2:	6406                	ld	s0,64(sp)
ffffffffc02076a4:	74e2                	ld	s1,56(sp)
ffffffffc02076a6:	7942                	ld	s2,48(sp)
ffffffffc02076a8:	6161                	addi	sp,sp,80
ffffffffc02076aa:	8082                	ret
ffffffffc02076ac:	8522                	mv	a0,s0
ffffffffc02076ae:	8e1f90ef          	jal	ra,ffffffffc0200f8e <print_trapframe>
ffffffffc02076b2:	609c                	ld	a5,0(s1)
ffffffffc02076b4:	86ca                	mv	a3,s2
ffffffffc02076b6:	00006617          	auipc	a2,0x6
ffffffffc02076ba:	1fa60613          	addi	a2,a2,506 # ffffffffc020d8b0 <CSWTCH.79+0x5e0>
ffffffffc02076be:	43d8                	lw	a4,4(a5)
ffffffffc02076c0:	0d800593          	li	a1,216
ffffffffc02076c4:	0b478793          	addi	a5,a5,180
ffffffffc02076c8:	00006517          	auipc	a0,0x6
ffffffffc02076cc:	21850513          	addi	a0,a0,536 # ffffffffc020d8e0 <CSWTCH.79+0x610>
ffffffffc02076d0:	b5ff80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02076d4 <vfs_do_add>:
ffffffffc02076d4:	7139                	addi	sp,sp,-64
ffffffffc02076d6:	fc06                	sd	ra,56(sp)
ffffffffc02076d8:	f822                	sd	s0,48(sp)
ffffffffc02076da:	f426                	sd	s1,40(sp)
ffffffffc02076dc:	f04a                	sd	s2,32(sp)
ffffffffc02076de:	ec4e                	sd	s3,24(sp)
ffffffffc02076e0:	e852                	sd	s4,16(sp)
ffffffffc02076e2:	e456                	sd	s5,8(sp)
ffffffffc02076e4:	e05a                	sd	s6,0(sp)
ffffffffc02076e6:	0e050b63          	beqz	a0,ffffffffc02077dc <vfs_do_add+0x108>
ffffffffc02076ea:	842a                	mv	s0,a0
ffffffffc02076ec:	8a2e                	mv	s4,a1
ffffffffc02076ee:	8b32                	mv	s6,a2
ffffffffc02076f0:	8ab6                	mv	s5,a3
ffffffffc02076f2:	c5cd                	beqz	a1,ffffffffc020779c <vfs_do_add+0xc8>
ffffffffc02076f4:	4db8                	lw	a4,88(a1)
ffffffffc02076f6:	6785                	lui	a5,0x1
ffffffffc02076f8:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02076fc:	0af71163          	bne	a4,a5,ffffffffc020779e <vfs_do_add+0xca>
ffffffffc0207700:	8522                	mv	a0,s0
ffffffffc0207702:	77c030ef          	jal	ra,ffffffffc020ae7e <strlen>
ffffffffc0207706:	47fd                	li	a5,31
ffffffffc0207708:	0ca7e663          	bltu	a5,a0,ffffffffc02077d4 <vfs_do_add+0x100>
ffffffffc020770c:	8522                	mv	a0,s0
ffffffffc020770e:	9a5f80ef          	jal	ra,ffffffffc02000b2 <strdup>
ffffffffc0207712:	84aa                	mv	s1,a0
ffffffffc0207714:	c171                	beqz	a0,ffffffffc02077d8 <vfs_do_add+0x104>
ffffffffc0207716:	03000513          	li	a0,48
ffffffffc020771a:	8a8fc0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc020771e:	89aa                	mv	s3,a0
ffffffffc0207720:	c92d                	beqz	a0,ffffffffc0207792 <vfs_do_add+0xbe>
ffffffffc0207722:	0008e517          	auipc	a0,0x8e
ffffffffc0207726:	0ee50513          	addi	a0,a0,238 # ffffffffc0295810 <vdev_list_sem>
ffffffffc020772a:	0008e917          	auipc	s2,0x8e
ffffffffc020772e:	0d690913          	addi	s2,s2,214 # ffffffffc0295800 <vdev_list>
ffffffffc0207732:	818fd0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0207736:	844a                	mv	s0,s2
ffffffffc0207738:	a039                	j	ffffffffc0207746 <vfs_do_add+0x72>
ffffffffc020773a:	fe043503          	ld	a0,-32(s0)
ffffffffc020773e:	85a6                	mv	a1,s1
ffffffffc0207740:	786030ef          	jal	ra,ffffffffc020aec6 <strcmp>
ffffffffc0207744:	cd2d                	beqz	a0,ffffffffc02077be <vfs_do_add+0xea>
ffffffffc0207746:	6400                	ld	s0,8(s0)
ffffffffc0207748:	ff2419e3          	bne	s0,s2,ffffffffc020773a <vfs_do_add+0x66>
ffffffffc020774c:	6418                	ld	a4,8(s0)
ffffffffc020774e:	02098793          	addi	a5,s3,32
ffffffffc0207752:	0099b023          	sd	s1,0(s3)
ffffffffc0207756:	0149b423          	sd	s4,8(s3)
ffffffffc020775a:	0159bc23          	sd	s5,24(s3)
ffffffffc020775e:	0169b823          	sd	s6,16(s3)
ffffffffc0207762:	e31c                	sd	a5,0(a4)
ffffffffc0207764:	0289b023          	sd	s0,32(s3)
ffffffffc0207768:	02e9b423          	sd	a4,40(s3)
ffffffffc020776c:	0008e517          	auipc	a0,0x8e
ffffffffc0207770:	0a450513          	addi	a0,a0,164 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207774:	e41c                	sd	a5,8(s0)
ffffffffc0207776:	4401                	li	s0,0
ffffffffc0207778:	fcffc0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020777c:	70e2                	ld	ra,56(sp)
ffffffffc020777e:	8522                	mv	a0,s0
ffffffffc0207780:	7442                	ld	s0,48(sp)
ffffffffc0207782:	74a2                	ld	s1,40(sp)
ffffffffc0207784:	7902                	ld	s2,32(sp)
ffffffffc0207786:	69e2                	ld	s3,24(sp)
ffffffffc0207788:	6a42                	ld	s4,16(sp)
ffffffffc020778a:	6aa2                	ld	s5,8(sp)
ffffffffc020778c:	6b02                	ld	s6,0(sp)
ffffffffc020778e:	6121                	addi	sp,sp,64
ffffffffc0207790:	8082                	ret
ffffffffc0207792:	5471                	li	s0,-4
ffffffffc0207794:	8526                	mv	a0,s1
ffffffffc0207796:	8dcfc0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020779a:	b7cd                	j	ffffffffc020777c <vfs_do_add+0xa8>
ffffffffc020779c:	d2b5                	beqz	a3,ffffffffc0207700 <vfs_do_add+0x2c>
ffffffffc020779e:	00007697          	auipc	a3,0x7
ffffffffc02077a2:	98268693          	addi	a3,a3,-1662 # ffffffffc020e120 <syscalls+0x828>
ffffffffc02077a6:	00004617          	auipc	a2,0x4
ffffffffc02077aa:	17260613          	addi	a2,a2,370 # ffffffffc020b918 <commands+0x250>
ffffffffc02077ae:	08f00593          	li	a1,143
ffffffffc02077b2:	00007517          	auipc	a0,0x7
ffffffffc02077b6:	95650513          	addi	a0,a0,-1706 # ffffffffc020e108 <syscalls+0x810>
ffffffffc02077ba:	a75f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02077be:	0008e517          	auipc	a0,0x8e
ffffffffc02077c2:	05250513          	addi	a0,a0,82 # ffffffffc0295810 <vdev_list_sem>
ffffffffc02077c6:	f81fc0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc02077ca:	854e                	mv	a0,s3
ffffffffc02077cc:	8a6fc0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc02077d0:	5425                	li	s0,-23
ffffffffc02077d2:	b7c9                	j	ffffffffc0207794 <vfs_do_add+0xc0>
ffffffffc02077d4:	5451                	li	s0,-12
ffffffffc02077d6:	b75d                	j	ffffffffc020777c <vfs_do_add+0xa8>
ffffffffc02077d8:	5471                	li	s0,-4
ffffffffc02077da:	b74d                	j	ffffffffc020777c <vfs_do_add+0xa8>
ffffffffc02077dc:	00007697          	auipc	a3,0x7
ffffffffc02077e0:	91c68693          	addi	a3,a3,-1764 # ffffffffc020e0f8 <syscalls+0x800>
ffffffffc02077e4:	00004617          	auipc	a2,0x4
ffffffffc02077e8:	13460613          	addi	a2,a2,308 # ffffffffc020b918 <commands+0x250>
ffffffffc02077ec:	08e00593          	li	a1,142
ffffffffc02077f0:	00007517          	auipc	a0,0x7
ffffffffc02077f4:	91850513          	addi	a0,a0,-1768 # ffffffffc020e108 <syscalls+0x810>
ffffffffc02077f8:	a37f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02077fc <find_mount.part.0>:
ffffffffc02077fc:	1141                	addi	sp,sp,-16
ffffffffc02077fe:	00007697          	auipc	a3,0x7
ffffffffc0207802:	8fa68693          	addi	a3,a3,-1798 # ffffffffc020e0f8 <syscalls+0x800>
ffffffffc0207806:	00004617          	auipc	a2,0x4
ffffffffc020780a:	11260613          	addi	a2,a2,274 # ffffffffc020b918 <commands+0x250>
ffffffffc020780e:	0cd00593          	li	a1,205
ffffffffc0207812:	00007517          	auipc	a0,0x7
ffffffffc0207816:	8f650513          	addi	a0,a0,-1802 # ffffffffc020e108 <syscalls+0x810>
ffffffffc020781a:	e406                	sd	ra,8(sp)
ffffffffc020781c:	a13f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207820 <vfs_devlist_init>:
ffffffffc0207820:	0008e797          	auipc	a5,0x8e
ffffffffc0207824:	fe078793          	addi	a5,a5,-32 # ffffffffc0295800 <vdev_list>
ffffffffc0207828:	4585                	li	a1,1
ffffffffc020782a:	0008e517          	auipc	a0,0x8e
ffffffffc020782e:	fe650513          	addi	a0,a0,-26 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207832:	e79c                	sd	a5,8(a5)
ffffffffc0207834:	e39c                	sd	a5,0(a5)
ffffffffc0207836:	f09fc06f          	j	ffffffffc020473e <sem_init>

ffffffffc020783a <vfs_cleanup>:
ffffffffc020783a:	1101                	addi	sp,sp,-32
ffffffffc020783c:	e426                	sd	s1,8(sp)
ffffffffc020783e:	0008e497          	auipc	s1,0x8e
ffffffffc0207842:	fc248493          	addi	s1,s1,-62 # ffffffffc0295800 <vdev_list>
ffffffffc0207846:	649c                	ld	a5,8(s1)
ffffffffc0207848:	ec06                	sd	ra,24(sp)
ffffffffc020784a:	e822                	sd	s0,16(sp)
ffffffffc020784c:	02978e63          	beq	a5,s1,ffffffffc0207888 <vfs_cleanup+0x4e>
ffffffffc0207850:	0008e517          	auipc	a0,0x8e
ffffffffc0207854:	fc050513          	addi	a0,a0,-64 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207858:	ef3fc0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc020785c:	6480                	ld	s0,8(s1)
ffffffffc020785e:	00940b63          	beq	s0,s1,ffffffffc0207874 <vfs_cleanup+0x3a>
ffffffffc0207862:	ff043783          	ld	a5,-16(s0)
ffffffffc0207866:	853e                	mv	a0,a5
ffffffffc0207868:	c399                	beqz	a5,ffffffffc020786e <vfs_cleanup+0x34>
ffffffffc020786a:	6bfc                	ld	a5,208(a5)
ffffffffc020786c:	9782                	jalr	a5
ffffffffc020786e:	6400                	ld	s0,8(s0)
ffffffffc0207870:	fe9419e3          	bne	s0,s1,ffffffffc0207862 <vfs_cleanup+0x28>
ffffffffc0207874:	6442                	ld	s0,16(sp)
ffffffffc0207876:	60e2                	ld	ra,24(sp)
ffffffffc0207878:	64a2                	ld	s1,8(sp)
ffffffffc020787a:	0008e517          	auipc	a0,0x8e
ffffffffc020787e:	f9650513          	addi	a0,a0,-106 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207882:	6105                	addi	sp,sp,32
ffffffffc0207884:	ec3fc06f          	j	ffffffffc0204746 <up>
ffffffffc0207888:	60e2                	ld	ra,24(sp)
ffffffffc020788a:	6442                	ld	s0,16(sp)
ffffffffc020788c:	64a2                	ld	s1,8(sp)
ffffffffc020788e:	6105                	addi	sp,sp,32
ffffffffc0207890:	8082                	ret

ffffffffc0207892 <vfs_get_root>:
ffffffffc0207892:	7179                	addi	sp,sp,-48
ffffffffc0207894:	f406                	sd	ra,40(sp)
ffffffffc0207896:	f022                	sd	s0,32(sp)
ffffffffc0207898:	ec26                	sd	s1,24(sp)
ffffffffc020789a:	e84a                	sd	s2,16(sp)
ffffffffc020789c:	e44e                	sd	s3,8(sp)
ffffffffc020789e:	e052                	sd	s4,0(sp)
ffffffffc02078a0:	c541                	beqz	a0,ffffffffc0207928 <vfs_get_root+0x96>
ffffffffc02078a2:	0008e917          	auipc	s2,0x8e
ffffffffc02078a6:	f5e90913          	addi	s2,s2,-162 # ffffffffc0295800 <vdev_list>
ffffffffc02078aa:	00893783          	ld	a5,8(s2)
ffffffffc02078ae:	07278b63          	beq	a5,s2,ffffffffc0207924 <vfs_get_root+0x92>
ffffffffc02078b2:	89aa                	mv	s3,a0
ffffffffc02078b4:	0008e517          	auipc	a0,0x8e
ffffffffc02078b8:	f5c50513          	addi	a0,a0,-164 # ffffffffc0295810 <vdev_list_sem>
ffffffffc02078bc:	8a2e                	mv	s4,a1
ffffffffc02078be:	844a                	mv	s0,s2
ffffffffc02078c0:	e8bfc0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc02078c4:	a801                	j	ffffffffc02078d4 <vfs_get_root+0x42>
ffffffffc02078c6:	fe043583          	ld	a1,-32(s0)
ffffffffc02078ca:	854e                	mv	a0,s3
ffffffffc02078cc:	5fa030ef          	jal	ra,ffffffffc020aec6 <strcmp>
ffffffffc02078d0:	84aa                	mv	s1,a0
ffffffffc02078d2:	c505                	beqz	a0,ffffffffc02078fa <vfs_get_root+0x68>
ffffffffc02078d4:	6400                	ld	s0,8(s0)
ffffffffc02078d6:	ff2418e3          	bne	s0,s2,ffffffffc02078c6 <vfs_get_root+0x34>
ffffffffc02078da:	54cd                	li	s1,-13
ffffffffc02078dc:	0008e517          	auipc	a0,0x8e
ffffffffc02078e0:	f3450513          	addi	a0,a0,-204 # ffffffffc0295810 <vdev_list_sem>
ffffffffc02078e4:	e63fc0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc02078e8:	70a2                	ld	ra,40(sp)
ffffffffc02078ea:	7402                	ld	s0,32(sp)
ffffffffc02078ec:	6942                	ld	s2,16(sp)
ffffffffc02078ee:	69a2                	ld	s3,8(sp)
ffffffffc02078f0:	6a02                	ld	s4,0(sp)
ffffffffc02078f2:	8526                	mv	a0,s1
ffffffffc02078f4:	64e2                	ld	s1,24(sp)
ffffffffc02078f6:	6145                	addi	sp,sp,48
ffffffffc02078f8:	8082                	ret
ffffffffc02078fa:	ff043503          	ld	a0,-16(s0)
ffffffffc02078fe:	c519                	beqz	a0,ffffffffc020790c <vfs_get_root+0x7a>
ffffffffc0207900:	617c                	ld	a5,192(a0)
ffffffffc0207902:	9782                	jalr	a5
ffffffffc0207904:	c519                	beqz	a0,ffffffffc0207912 <vfs_get_root+0x80>
ffffffffc0207906:	00aa3023          	sd	a0,0(s4)
ffffffffc020790a:	bfc9                	j	ffffffffc02078dc <vfs_get_root+0x4a>
ffffffffc020790c:	ff843783          	ld	a5,-8(s0)
ffffffffc0207910:	c399                	beqz	a5,ffffffffc0207916 <vfs_get_root+0x84>
ffffffffc0207912:	54c9                	li	s1,-14
ffffffffc0207914:	b7e1                	j	ffffffffc02078dc <vfs_get_root+0x4a>
ffffffffc0207916:	fe843503          	ld	a0,-24(s0)
ffffffffc020791a:	5ee000ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc020791e:	fe843503          	ld	a0,-24(s0)
ffffffffc0207922:	b7cd                	j	ffffffffc0207904 <vfs_get_root+0x72>
ffffffffc0207924:	54cd                	li	s1,-13
ffffffffc0207926:	b7c9                	j	ffffffffc02078e8 <vfs_get_root+0x56>
ffffffffc0207928:	00006697          	auipc	a3,0x6
ffffffffc020792c:	7d068693          	addi	a3,a3,2000 # ffffffffc020e0f8 <syscalls+0x800>
ffffffffc0207930:	00004617          	auipc	a2,0x4
ffffffffc0207934:	fe860613          	addi	a2,a2,-24 # ffffffffc020b918 <commands+0x250>
ffffffffc0207938:	04500593          	li	a1,69
ffffffffc020793c:	00006517          	auipc	a0,0x6
ffffffffc0207940:	7cc50513          	addi	a0,a0,1996 # ffffffffc020e108 <syscalls+0x810>
ffffffffc0207944:	8ebf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207948 <vfs_get_devname>:
ffffffffc0207948:	0008e697          	auipc	a3,0x8e
ffffffffc020794c:	eb868693          	addi	a3,a3,-328 # ffffffffc0295800 <vdev_list>
ffffffffc0207950:	87b6                	mv	a5,a3
ffffffffc0207952:	e511                	bnez	a0,ffffffffc020795e <vfs_get_devname+0x16>
ffffffffc0207954:	a829                	j	ffffffffc020796e <vfs_get_devname+0x26>
ffffffffc0207956:	ff07b703          	ld	a4,-16(a5)
ffffffffc020795a:	00a70763          	beq	a4,a0,ffffffffc0207968 <vfs_get_devname+0x20>
ffffffffc020795e:	679c                	ld	a5,8(a5)
ffffffffc0207960:	fed79be3          	bne	a5,a3,ffffffffc0207956 <vfs_get_devname+0xe>
ffffffffc0207964:	4501                	li	a0,0
ffffffffc0207966:	8082                	ret
ffffffffc0207968:	fe07b503          	ld	a0,-32(a5)
ffffffffc020796c:	8082                	ret
ffffffffc020796e:	1141                	addi	sp,sp,-16
ffffffffc0207970:	00007697          	auipc	a3,0x7
ffffffffc0207974:	81068693          	addi	a3,a3,-2032 # ffffffffc020e180 <syscalls+0x888>
ffffffffc0207978:	00004617          	auipc	a2,0x4
ffffffffc020797c:	fa060613          	addi	a2,a2,-96 # ffffffffc020b918 <commands+0x250>
ffffffffc0207980:	06a00593          	li	a1,106
ffffffffc0207984:	00006517          	auipc	a0,0x6
ffffffffc0207988:	78450513          	addi	a0,a0,1924 # ffffffffc020e108 <syscalls+0x810>
ffffffffc020798c:	e406                	sd	ra,8(sp)
ffffffffc020798e:	8a1f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207992 <vfs_add_dev>:
ffffffffc0207992:	86b2                	mv	a3,a2
ffffffffc0207994:	4601                	li	a2,0
ffffffffc0207996:	d3fff06f          	j	ffffffffc02076d4 <vfs_do_add>

ffffffffc020799a <vfs_mount>:
ffffffffc020799a:	7179                	addi	sp,sp,-48
ffffffffc020799c:	e84a                	sd	s2,16(sp)
ffffffffc020799e:	892a                	mv	s2,a0
ffffffffc02079a0:	0008e517          	auipc	a0,0x8e
ffffffffc02079a4:	e7050513          	addi	a0,a0,-400 # ffffffffc0295810 <vdev_list_sem>
ffffffffc02079a8:	e44e                	sd	s3,8(sp)
ffffffffc02079aa:	f406                	sd	ra,40(sp)
ffffffffc02079ac:	f022                	sd	s0,32(sp)
ffffffffc02079ae:	ec26                	sd	s1,24(sp)
ffffffffc02079b0:	89ae                	mv	s3,a1
ffffffffc02079b2:	d99fc0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc02079b6:	08090a63          	beqz	s2,ffffffffc0207a4a <vfs_mount+0xb0>
ffffffffc02079ba:	0008e497          	auipc	s1,0x8e
ffffffffc02079be:	e4648493          	addi	s1,s1,-442 # ffffffffc0295800 <vdev_list>
ffffffffc02079c2:	6480                	ld	s0,8(s1)
ffffffffc02079c4:	00941663          	bne	s0,s1,ffffffffc02079d0 <vfs_mount+0x36>
ffffffffc02079c8:	a8ad                	j	ffffffffc0207a42 <vfs_mount+0xa8>
ffffffffc02079ca:	6400                	ld	s0,8(s0)
ffffffffc02079cc:	06940b63          	beq	s0,s1,ffffffffc0207a42 <vfs_mount+0xa8>
ffffffffc02079d0:	ff843783          	ld	a5,-8(s0)
ffffffffc02079d4:	dbfd                	beqz	a5,ffffffffc02079ca <vfs_mount+0x30>
ffffffffc02079d6:	fe043503          	ld	a0,-32(s0)
ffffffffc02079da:	85ca                	mv	a1,s2
ffffffffc02079dc:	4ea030ef          	jal	ra,ffffffffc020aec6 <strcmp>
ffffffffc02079e0:	f56d                	bnez	a0,ffffffffc02079ca <vfs_mount+0x30>
ffffffffc02079e2:	ff043783          	ld	a5,-16(s0)
ffffffffc02079e6:	e3a5                	bnez	a5,ffffffffc0207a46 <vfs_mount+0xac>
ffffffffc02079e8:	fe043783          	ld	a5,-32(s0)
ffffffffc02079ec:	c3c9                	beqz	a5,ffffffffc0207a6e <vfs_mount+0xd4>
ffffffffc02079ee:	ff843783          	ld	a5,-8(s0)
ffffffffc02079f2:	cfb5                	beqz	a5,ffffffffc0207a6e <vfs_mount+0xd4>
ffffffffc02079f4:	fe843503          	ld	a0,-24(s0)
ffffffffc02079f8:	c939                	beqz	a0,ffffffffc0207a4e <vfs_mount+0xb4>
ffffffffc02079fa:	4d38                	lw	a4,88(a0)
ffffffffc02079fc:	6785                	lui	a5,0x1
ffffffffc02079fe:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207a02:	04f71663          	bne	a4,a5,ffffffffc0207a4e <vfs_mount+0xb4>
ffffffffc0207a06:	ff040593          	addi	a1,s0,-16
ffffffffc0207a0a:	9982                	jalr	s3
ffffffffc0207a0c:	84aa                	mv	s1,a0
ffffffffc0207a0e:	ed01                	bnez	a0,ffffffffc0207a26 <vfs_mount+0x8c>
ffffffffc0207a10:	ff043783          	ld	a5,-16(s0)
ffffffffc0207a14:	cfad                	beqz	a5,ffffffffc0207a8e <vfs_mount+0xf4>
ffffffffc0207a16:	fe043583          	ld	a1,-32(s0)
ffffffffc0207a1a:	00006517          	auipc	a0,0x6
ffffffffc0207a1e:	7f650513          	addi	a0,a0,2038 # ffffffffc020e210 <syscalls+0x918>
ffffffffc0207a22:	f08f80ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0207a26:	0008e517          	auipc	a0,0x8e
ffffffffc0207a2a:	dea50513          	addi	a0,a0,-534 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207a2e:	d19fc0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0207a32:	70a2                	ld	ra,40(sp)
ffffffffc0207a34:	7402                	ld	s0,32(sp)
ffffffffc0207a36:	6942                	ld	s2,16(sp)
ffffffffc0207a38:	69a2                	ld	s3,8(sp)
ffffffffc0207a3a:	8526                	mv	a0,s1
ffffffffc0207a3c:	64e2                	ld	s1,24(sp)
ffffffffc0207a3e:	6145                	addi	sp,sp,48
ffffffffc0207a40:	8082                	ret
ffffffffc0207a42:	54cd                	li	s1,-13
ffffffffc0207a44:	b7cd                	j	ffffffffc0207a26 <vfs_mount+0x8c>
ffffffffc0207a46:	54c5                	li	s1,-15
ffffffffc0207a48:	bff9                	j	ffffffffc0207a26 <vfs_mount+0x8c>
ffffffffc0207a4a:	db3ff0ef          	jal	ra,ffffffffc02077fc <find_mount.part.0>
ffffffffc0207a4e:	00006697          	auipc	a3,0x6
ffffffffc0207a52:	77268693          	addi	a3,a3,1906 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0207a56:	00004617          	auipc	a2,0x4
ffffffffc0207a5a:	ec260613          	addi	a2,a2,-318 # ffffffffc020b918 <commands+0x250>
ffffffffc0207a5e:	0ed00593          	li	a1,237
ffffffffc0207a62:	00006517          	auipc	a0,0x6
ffffffffc0207a66:	6a650513          	addi	a0,a0,1702 # ffffffffc020e108 <syscalls+0x810>
ffffffffc0207a6a:	fc4f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207a6e:	00006697          	auipc	a3,0x6
ffffffffc0207a72:	72268693          	addi	a3,a3,1826 # ffffffffc020e190 <syscalls+0x898>
ffffffffc0207a76:	00004617          	auipc	a2,0x4
ffffffffc0207a7a:	ea260613          	addi	a2,a2,-350 # ffffffffc020b918 <commands+0x250>
ffffffffc0207a7e:	0eb00593          	li	a1,235
ffffffffc0207a82:	00006517          	auipc	a0,0x6
ffffffffc0207a86:	68650513          	addi	a0,a0,1670 # ffffffffc020e108 <syscalls+0x810>
ffffffffc0207a8a:	fa4f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207a8e:	00006697          	auipc	a3,0x6
ffffffffc0207a92:	76a68693          	addi	a3,a3,1898 # ffffffffc020e1f8 <syscalls+0x900>
ffffffffc0207a96:	00004617          	auipc	a2,0x4
ffffffffc0207a9a:	e8260613          	addi	a2,a2,-382 # ffffffffc020b918 <commands+0x250>
ffffffffc0207a9e:	0ef00593          	li	a1,239
ffffffffc0207aa2:	00006517          	auipc	a0,0x6
ffffffffc0207aa6:	66650513          	addi	a0,a0,1638 # ffffffffc020e108 <syscalls+0x810>
ffffffffc0207aaa:	f84f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207aae <vfs_get_curdir>:
ffffffffc0207aae:	0008f797          	auipc	a5,0x8f
ffffffffc0207ab2:	e127b783          	ld	a5,-494(a5) # ffffffffc02968c0 <current>
ffffffffc0207ab6:	1487b783          	ld	a5,328(a5)
ffffffffc0207aba:	1101                	addi	sp,sp,-32
ffffffffc0207abc:	e426                	sd	s1,8(sp)
ffffffffc0207abe:	6384                	ld	s1,0(a5)
ffffffffc0207ac0:	ec06                	sd	ra,24(sp)
ffffffffc0207ac2:	e822                	sd	s0,16(sp)
ffffffffc0207ac4:	cc81                	beqz	s1,ffffffffc0207adc <vfs_get_curdir+0x2e>
ffffffffc0207ac6:	842a                	mv	s0,a0
ffffffffc0207ac8:	8526                	mv	a0,s1
ffffffffc0207aca:	43e000ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc0207ace:	4501                	li	a0,0
ffffffffc0207ad0:	e004                	sd	s1,0(s0)
ffffffffc0207ad2:	60e2                	ld	ra,24(sp)
ffffffffc0207ad4:	6442                	ld	s0,16(sp)
ffffffffc0207ad6:	64a2                	ld	s1,8(sp)
ffffffffc0207ad8:	6105                	addi	sp,sp,32
ffffffffc0207ada:	8082                	ret
ffffffffc0207adc:	5541                	li	a0,-16
ffffffffc0207ade:	bfd5                	j	ffffffffc0207ad2 <vfs_get_curdir+0x24>

ffffffffc0207ae0 <vfs_set_curdir>:
ffffffffc0207ae0:	7139                	addi	sp,sp,-64
ffffffffc0207ae2:	f04a                	sd	s2,32(sp)
ffffffffc0207ae4:	0008f917          	auipc	s2,0x8f
ffffffffc0207ae8:	ddc90913          	addi	s2,s2,-548 # ffffffffc02968c0 <current>
ffffffffc0207aec:	00093783          	ld	a5,0(s2)
ffffffffc0207af0:	f822                	sd	s0,48(sp)
ffffffffc0207af2:	842a                	mv	s0,a0
ffffffffc0207af4:	1487b503          	ld	a0,328(a5)
ffffffffc0207af8:	ec4e                	sd	s3,24(sp)
ffffffffc0207afa:	fc06                	sd	ra,56(sp)
ffffffffc0207afc:	f426                	sd	s1,40(sp)
ffffffffc0207afe:	cddfd0ef          	jal	ra,ffffffffc02057da <lock_files>
ffffffffc0207b02:	00093783          	ld	a5,0(s2)
ffffffffc0207b06:	1487b503          	ld	a0,328(a5)
ffffffffc0207b0a:	00053983          	ld	s3,0(a0)
ffffffffc0207b0e:	07340963          	beq	s0,s3,ffffffffc0207b80 <vfs_set_curdir+0xa0>
ffffffffc0207b12:	cc39                	beqz	s0,ffffffffc0207b70 <vfs_set_curdir+0x90>
ffffffffc0207b14:	783c                	ld	a5,112(s0)
ffffffffc0207b16:	c7bd                	beqz	a5,ffffffffc0207b84 <vfs_set_curdir+0xa4>
ffffffffc0207b18:	6bbc                	ld	a5,80(a5)
ffffffffc0207b1a:	c7ad                	beqz	a5,ffffffffc0207b84 <vfs_set_curdir+0xa4>
ffffffffc0207b1c:	00006597          	auipc	a1,0x6
ffffffffc0207b20:	76c58593          	addi	a1,a1,1900 # ffffffffc020e288 <syscalls+0x990>
ffffffffc0207b24:	8522                	mv	a0,s0
ffffffffc0207b26:	3fa000ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0207b2a:	783c                	ld	a5,112(s0)
ffffffffc0207b2c:	006c                	addi	a1,sp,12
ffffffffc0207b2e:	8522                	mv	a0,s0
ffffffffc0207b30:	6bbc                	ld	a5,80(a5)
ffffffffc0207b32:	9782                	jalr	a5
ffffffffc0207b34:	84aa                	mv	s1,a0
ffffffffc0207b36:	e901                	bnez	a0,ffffffffc0207b46 <vfs_set_curdir+0x66>
ffffffffc0207b38:	47b2                	lw	a5,12(sp)
ffffffffc0207b3a:	669d                	lui	a3,0x7
ffffffffc0207b3c:	6709                	lui	a4,0x2
ffffffffc0207b3e:	8ff5                	and	a5,a5,a3
ffffffffc0207b40:	54b9                	li	s1,-18
ffffffffc0207b42:	02e78063          	beq	a5,a4,ffffffffc0207b62 <vfs_set_curdir+0x82>
ffffffffc0207b46:	00093783          	ld	a5,0(s2)
ffffffffc0207b4a:	1487b503          	ld	a0,328(a5)
ffffffffc0207b4e:	c93fd0ef          	jal	ra,ffffffffc02057e0 <unlock_files>
ffffffffc0207b52:	70e2                	ld	ra,56(sp)
ffffffffc0207b54:	7442                	ld	s0,48(sp)
ffffffffc0207b56:	7902                	ld	s2,32(sp)
ffffffffc0207b58:	69e2                	ld	s3,24(sp)
ffffffffc0207b5a:	8526                	mv	a0,s1
ffffffffc0207b5c:	74a2                	ld	s1,40(sp)
ffffffffc0207b5e:	6121                	addi	sp,sp,64
ffffffffc0207b60:	8082                	ret
ffffffffc0207b62:	8522                	mv	a0,s0
ffffffffc0207b64:	3a4000ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc0207b68:	00093783          	ld	a5,0(s2)
ffffffffc0207b6c:	1487b503          	ld	a0,328(a5)
ffffffffc0207b70:	e100                	sd	s0,0(a0)
ffffffffc0207b72:	4481                	li	s1,0
ffffffffc0207b74:	fc098de3          	beqz	s3,ffffffffc0207b4e <vfs_set_curdir+0x6e>
ffffffffc0207b78:	854e                	mv	a0,s3
ffffffffc0207b7a:	45c000ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc0207b7e:	b7e1                	j	ffffffffc0207b46 <vfs_set_curdir+0x66>
ffffffffc0207b80:	4481                	li	s1,0
ffffffffc0207b82:	b7f1                	j	ffffffffc0207b4e <vfs_set_curdir+0x6e>
ffffffffc0207b84:	00006697          	auipc	a3,0x6
ffffffffc0207b88:	69c68693          	addi	a3,a3,1692 # ffffffffc020e220 <syscalls+0x928>
ffffffffc0207b8c:	00004617          	auipc	a2,0x4
ffffffffc0207b90:	d8c60613          	addi	a2,a2,-628 # ffffffffc020b918 <commands+0x250>
ffffffffc0207b94:	04300593          	li	a1,67
ffffffffc0207b98:	00006517          	auipc	a0,0x6
ffffffffc0207b9c:	6d850513          	addi	a0,a0,1752 # ffffffffc020e270 <syscalls+0x978>
ffffffffc0207ba0:	e8ef80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207ba4 <vfs_chdir>:
ffffffffc0207ba4:	1101                	addi	sp,sp,-32
ffffffffc0207ba6:	002c                	addi	a1,sp,8
ffffffffc0207ba8:	e822                	sd	s0,16(sp)
ffffffffc0207baa:	ec06                	sd	ra,24(sp)
ffffffffc0207bac:	21e000ef          	jal	ra,ffffffffc0207dca <vfs_lookup>
ffffffffc0207bb0:	842a                	mv	s0,a0
ffffffffc0207bb2:	c511                	beqz	a0,ffffffffc0207bbe <vfs_chdir+0x1a>
ffffffffc0207bb4:	60e2                	ld	ra,24(sp)
ffffffffc0207bb6:	8522                	mv	a0,s0
ffffffffc0207bb8:	6442                	ld	s0,16(sp)
ffffffffc0207bba:	6105                	addi	sp,sp,32
ffffffffc0207bbc:	8082                	ret
ffffffffc0207bbe:	6522                	ld	a0,8(sp)
ffffffffc0207bc0:	f21ff0ef          	jal	ra,ffffffffc0207ae0 <vfs_set_curdir>
ffffffffc0207bc4:	842a                	mv	s0,a0
ffffffffc0207bc6:	6522                	ld	a0,8(sp)
ffffffffc0207bc8:	40e000ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc0207bcc:	60e2                	ld	ra,24(sp)
ffffffffc0207bce:	8522                	mv	a0,s0
ffffffffc0207bd0:	6442                	ld	s0,16(sp)
ffffffffc0207bd2:	6105                	addi	sp,sp,32
ffffffffc0207bd4:	8082                	ret

ffffffffc0207bd6 <vfs_getcwd>:
ffffffffc0207bd6:	0008f797          	auipc	a5,0x8f
ffffffffc0207bda:	cea7b783          	ld	a5,-790(a5) # ffffffffc02968c0 <current>
ffffffffc0207bde:	1487b783          	ld	a5,328(a5)
ffffffffc0207be2:	7179                	addi	sp,sp,-48
ffffffffc0207be4:	ec26                	sd	s1,24(sp)
ffffffffc0207be6:	6384                	ld	s1,0(a5)
ffffffffc0207be8:	f406                	sd	ra,40(sp)
ffffffffc0207bea:	f022                	sd	s0,32(sp)
ffffffffc0207bec:	e84a                	sd	s2,16(sp)
ffffffffc0207bee:	ccbd                	beqz	s1,ffffffffc0207c6c <vfs_getcwd+0x96>
ffffffffc0207bf0:	892a                	mv	s2,a0
ffffffffc0207bf2:	8526                	mv	a0,s1
ffffffffc0207bf4:	314000ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc0207bf8:	74a8                	ld	a0,104(s1)
ffffffffc0207bfa:	c93d                	beqz	a0,ffffffffc0207c70 <vfs_getcwd+0x9a>
ffffffffc0207bfc:	d4dff0ef          	jal	ra,ffffffffc0207948 <vfs_get_devname>
ffffffffc0207c00:	842a                	mv	s0,a0
ffffffffc0207c02:	27c030ef          	jal	ra,ffffffffc020ae7e <strlen>
ffffffffc0207c06:	862a                	mv	a2,a0
ffffffffc0207c08:	85a2                	mv	a1,s0
ffffffffc0207c0a:	4701                	li	a4,0
ffffffffc0207c0c:	4685                	li	a3,1
ffffffffc0207c0e:	854a                	mv	a0,s2
ffffffffc0207c10:	b27fd0ef          	jal	ra,ffffffffc0205736 <iobuf_move>
ffffffffc0207c14:	842a                	mv	s0,a0
ffffffffc0207c16:	c919                	beqz	a0,ffffffffc0207c2c <vfs_getcwd+0x56>
ffffffffc0207c18:	8526                	mv	a0,s1
ffffffffc0207c1a:	3bc000ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc0207c1e:	70a2                	ld	ra,40(sp)
ffffffffc0207c20:	8522                	mv	a0,s0
ffffffffc0207c22:	7402                	ld	s0,32(sp)
ffffffffc0207c24:	64e2                	ld	s1,24(sp)
ffffffffc0207c26:	6942                	ld	s2,16(sp)
ffffffffc0207c28:	6145                	addi	sp,sp,48
ffffffffc0207c2a:	8082                	ret
ffffffffc0207c2c:	03a00793          	li	a5,58
ffffffffc0207c30:	4701                	li	a4,0
ffffffffc0207c32:	4685                	li	a3,1
ffffffffc0207c34:	4605                	li	a2,1
ffffffffc0207c36:	00f10593          	addi	a1,sp,15
ffffffffc0207c3a:	854a                	mv	a0,s2
ffffffffc0207c3c:	00f107a3          	sb	a5,15(sp)
ffffffffc0207c40:	af7fd0ef          	jal	ra,ffffffffc0205736 <iobuf_move>
ffffffffc0207c44:	842a                	mv	s0,a0
ffffffffc0207c46:	f969                	bnez	a0,ffffffffc0207c18 <vfs_getcwd+0x42>
ffffffffc0207c48:	78bc                	ld	a5,112(s1)
ffffffffc0207c4a:	c3b9                	beqz	a5,ffffffffc0207c90 <vfs_getcwd+0xba>
ffffffffc0207c4c:	7f9c                	ld	a5,56(a5)
ffffffffc0207c4e:	c3a9                	beqz	a5,ffffffffc0207c90 <vfs_getcwd+0xba>
ffffffffc0207c50:	00006597          	auipc	a1,0x6
ffffffffc0207c54:	6b058593          	addi	a1,a1,1712 # ffffffffc020e300 <syscalls+0xa08>
ffffffffc0207c58:	8526                	mv	a0,s1
ffffffffc0207c5a:	2c6000ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0207c5e:	78bc                	ld	a5,112(s1)
ffffffffc0207c60:	85ca                	mv	a1,s2
ffffffffc0207c62:	8526                	mv	a0,s1
ffffffffc0207c64:	7f9c                	ld	a5,56(a5)
ffffffffc0207c66:	9782                	jalr	a5
ffffffffc0207c68:	842a                	mv	s0,a0
ffffffffc0207c6a:	b77d                	j	ffffffffc0207c18 <vfs_getcwd+0x42>
ffffffffc0207c6c:	5441                	li	s0,-16
ffffffffc0207c6e:	bf45                	j	ffffffffc0207c1e <vfs_getcwd+0x48>
ffffffffc0207c70:	00006697          	auipc	a3,0x6
ffffffffc0207c74:	62068693          	addi	a3,a3,1568 # ffffffffc020e290 <syscalls+0x998>
ffffffffc0207c78:	00004617          	auipc	a2,0x4
ffffffffc0207c7c:	ca060613          	addi	a2,a2,-864 # ffffffffc020b918 <commands+0x250>
ffffffffc0207c80:	06e00593          	li	a1,110
ffffffffc0207c84:	00006517          	auipc	a0,0x6
ffffffffc0207c88:	5ec50513          	addi	a0,a0,1516 # ffffffffc020e270 <syscalls+0x978>
ffffffffc0207c8c:	da2f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207c90:	00006697          	auipc	a3,0x6
ffffffffc0207c94:	61868693          	addi	a3,a3,1560 # ffffffffc020e2a8 <syscalls+0x9b0>
ffffffffc0207c98:	00004617          	auipc	a2,0x4
ffffffffc0207c9c:	c8060613          	addi	a2,a2,-896 # ffffffffc020b918 <commands+0x250>
ffffffffc0207ca0:	07800593          	li	a1,120
ffffffffc0207ca4:	00006517          	auipc	a0,0x6
ffffffffc0207ca8:	5cc50513          	addi	a0,a0,1484 # ffffffffc020e270 <syscalls+0x978>
ffffffffc0207cac:	d82f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207cb0 <get_device>:
ffffffffc0207cb0:	7179                	addi	sp,sp,-48
ffffffffc0207cb2:	ec26                	sd	s1,24(sp)
ffffffffc0207cb4:	e84a                	sd	s2,16(sp)
ffffffffc0207cb6:	f406                	sd	ra,40(sp)
ffffffffc0207cb8:	f022                	sd	s0,32(sp)
ffffffffc0207cba:	00054303          	lbu	t1,0(a0)
ffffffffc0207cbe:	892e                	mv	s2,a1
ffffffffc0207cc0:	84b2                	mv	s1,a2
ffffffffc0207cc2:	02030463          	beqz	t1,ffffffffc0207cea <get_device+0x3a>
ffffffffc0207cc6:	00150413          	addi	s0,a0,1
ffffffffc0207cca:	86a2                	mv	a3,s0
ffffffffc0207ccc:	879a                	mv	a5,t1
ffffffffc0207cce:	4701                	li	a4,0
ffffffffc0207cd0:	03a00813          	li	a6,58
ffffffffc0207cd4:	02f00893          	li	a7,47
ffffffffc0207cd8:	03078363          	beq	a5,a6,ffffffffc0207cfe <get_device+0x4e>
ffffffffc0207cdc:	05178a63          	beq	a5,a7,ffffffffc0207d30 <get_device+0x80>
ffffffffc0207ce0:	0006c783          	lbu	a5,0(a3)
ffffffffc0207ce4:	2705                	addiw	a4,a4,1
ffffffffc0207ce6:	0685                	addi	a3,a3,1
ffffffffc0207ce8:	fbe5                	bnez	a5,ffffffffc0207cd8 <get_device+0x28>
ffffffffc0207cea:	7402                	ld	s0,32(sp)
ffffffffc0207cec:	00a93023          	sd	a0,0(s2)
ffffffffc0207cf0:	70a2                	ld	ra,40(sp)
ffffffffc0207cf2:	6942                	ld	s2,16(sp)
ffffffffc0207cf4:	8526                	mv	a0,s1
ffffffffc0207cf6:	64e2                	ld	s1,24(sp)
ffffffffc0207cf8:	6145                	addi	sp,sp,48
ffffffffc0207cfa:	db5ff06f          	j	ffffffffc0207aae <vfs_get_curdir>
ffffffffc0207cfe:	cb15                	beqz	a4,ffffffffc0207d32 <get_device+0x82>
ffffffffc0207d00:	00e507b3          	add	a5,a0,a4
ffffffffc0207d04:	0705                	addi	a4,a4,1
ffffffffc0207d06:	00078023          	sb	zero,0(a5)
ffffffffc0207d0a:	972a                	add	a4,a4,a0
ffffffffc0207d0c:	02f00613          	li	a2,47
ffffffffc0207d10:	00074783          	lbu	a5,0(a4) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc0207d14:	86ba                	mv	a3,a4
ffffffffc0207d16:	0705                	addi	a4,a4,1
ffffffffc0207d18:	fec78ce3          	beq	a5,a2,ffffffffc0207d10 <get_device+0x60>
ffffffffc0207d1c:	7402                	ld	s0,32(sp)
ffffffffc0207d1e:	70a2                	ld	ra,40(sp)
ffffffffc0207d20:	00d93023          	sd	a3,0(s2)
ffffffffc0207d24:	85a6                	mv	a1,s1
ffffffffc0207d26:	6942                	ld	s2,16(sp)
ffffffffc0207d28:	64e2                	ld	s1,24(sp)
ffffffffc0207d2a:	6145                	addi	sp,sp,48
ffffffffc0207d2c:	b67ff06f          	j	ffffffffc0207892 <vfs_get_root>
ffffffffc0207d30:	ff4d                	bnez	a4,ffffffffc0207cea <get_device+0x3a>
ffffffffc0207d32:	02f00793          	li	a5,47
ffffffffc0207d36:	04f30563          	beq	t1,a5,ffffffffc0207d80 <get_device+0xd0>
ffffffffc0207d3a:	03a00793          	li	a5,58
ffffffffc0207d3e:	06f31663          	bne	t1,a5,ffffffffc0207daa <get_device+0xfa>
ffffffffc0207d42:	0028                	addi	a0,sp,8
ffffffffc0207d44:	d6bff0ef          	jal	ra,ffffffffc0207aae <vfs_get_curdir>
ffffffffc0207d48:	e515                	bnez	a0,ffffffffc0207d74 <get_device+0xc4>
ffffffffc0207d4a:	67a2                	ld	a5,8(sp)
ffffffffc0207d4c:	77a8                	ld	a0,104(a5)
ffffffffc0207d4e:	cd15                	beqz	a0,ffffffffc0207d8a <get_device+0xda>
ffffffffc0207d50:	617c                	ld	a5,192(a0)
ffffffffc0207d52:	9782                	jalr	a5
ffffffffc0207d54:	87aa                	mv	a5,a0
ffffffffc0207d56:	6522                	ld	a0,8(sp)
ffffffffc0207d58:	e09c                	sd	a5,0(s1)
ffffffffc0207d5a:	27c000ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc0207d5e:	02f00713          	li	a4,47
ffffffffc0207d62:	a011                	j	ffffffffc0207d66 <get_device+0xb6>
ffffffffc0207d64:	0405                	addi	s0,s0,1
ffffffffc0207d66:	00044783          	lbu	a5,0(s0)
ffffffffc0207d6a:	fee78de3          	beq	a5,a4,ffffffffc0207d64 <get_device+0xb4>
ffffffffc0207d6e:	00893023          	sd	s0,0(s2)
ffffffffc0207d72:	4501                	li	a0,0
ffffffffc0207d74:	70a2                	ld	ra,40(sp)
ffffffffc0207d76:	7402                	ld	s0,32(sp)
ffffffffc0207d78:	64e2                	ld	s1,24(sp)
ffffffffc0207d7a:	6942                	ld	s2,16(sp)
ffffffffc0207d7c:	6145                	addi	sp,sp,48
ffffffffc0207d7e:	8082                	ret
ffffffffc0207d80:	8526                	mv	a0,s1
ffffffffc0207d82:	616000ef          	jal	ra,ffffffffc0208398 <vfs_get_bootfs>
ffffffffc0207d86:	dd61                	beqz	a0,ffffffffc0207d5e <get_device+0xae>
ffffffffc0207d88:	b7f5                	j	ffffffffc0207d74 <get_device+0xc4>
ffffffffc0207d8a:	00006697          	auipc	a3,0x6
ffffffffc0207d8e:	50668693          	addi	a3,a3,1286 # ffffffffc020e290 <syscalls+0x998>
ffffffffc0207d92:	00004617          	auipc	a2,0x4
ffffffffc0207d96:	b8660613          	addi	a2,a2,-1146 # ffffffffc020b918 <commands+0x250>
ffffffffc0207d9a:	03900593          	li	a1,57
ffffffffc0207d9e:	00006517          	auipc	a0,0x6
ffffffffc0207da2:	58250513          	addi	a0,a0,1410 # ffffffffc020e320 <syscalls+0xa28>
ffffffffc0207da6:	c88f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207daa:	00006697          	auipc	a3,0x6
ffffffffc0207dae:	56668693          	addi	a3,a3,1382 # ffffffffc020e310 <syscalls+0xa18>
ffffffffc0207db2:	00004617          	auipc	a2,0x4
ffffffffc0207db6:	b6660613          	addi	a2,a2,-1178 # ffffffffc020b918 <commands+0x250>
ffffffffc0207dba:	03300593          	li	a1,51
ffffffffc0207dbe:	00006517          	auipc	a0,0x6
ffffffffc0207dc2:	56250513          	addi	a0,a0,1378 # ffffffffc020e320 <syscalls+0xa28>
ffffffffc0207dc6:	c68f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207dca <vfs_lookup>:
ffffffffc0207dca:	7139                	addi	sp,sp,-64
ffffffffc0207dcc:	f426                	sd	s1,40(sp)
ffffffffc0207dce:	0830                	addi	a2,sp,24
ffffffffc0207dd0:	84ae                	mv	s1,a1
ffffffffc0207dd2:	002c                	addi	a1,sp,8
ffffffffc0207dd4:	f822                	sd	s0,48(sp)
ffffffffc0207dd6:	fc06                	sd	ra,56(sp)
ffffffffc0207dd8:	f04a                	sd	s2,32(sp)
ffffffffc0207dda:	e42a                	sd	a0,8(sp)
ffffffffc0207ddc:	ed5ff0ef          	jal	ra,ffffffffc0207cb0 <get_device>
ffffffffc0207de0:	842a                	mv	s0,a0
ffffffffc0207de2:	ed1d                	bnez	a0,ffffffffc0207e20 <vfs_lookup+0x56>
ffffffffc0207de4:	67a2                	ld	a5,8(sp)
ffffffffc0207de6:	6962                	ld	s2,24(sp)
ffffffffc0207de8:	0007c783          	lbu	a5,0(a5)
ffffffffc0207dec:	c3a9                	beqz	a5,ffffffffc0207e2e <vfs_lookup+0x64>
ffffffffc0207dee:	04090963          	beqz	s2,ffffffffc0207e40 <vfs_lookup+0x76>
ffffffffc0207df2:	07093783          	ld	a5,112(s2)
ffffffffc0207df6:	c7a9                	beqz	a5,ffffffffc0207e40 <vfs_lookup+0x76>
ffffffffc0207df8:	7bbc                	ld	a5,112(a5)
ffffffffc0207dfa:	c3b9                	beqz	a5,ffffffffc0207e40 <vfs_lookup+0x76>
ffffffffc0207dfc:	854a                	mv	a0,s2
ffffffffc0207dfe:	00006597          	auipc	a1,0x6
ffffffffc0207e02:	58a58593          	addi	a1,a1,1418 # ffffffffc020e388 <syscalls+0xa90>
ffffffffc0207e06:	11a000ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0207e0a:	07093783          	ld	a5,112(s2)
ffffffffc0207e0e:	65a2                	ld	a1,8(sp)
ffffffffc0207e10:	6562                	ld	a0,24(sp)
ffffffffc0207e12:	7bbc                	ld	a5,112(a5)
ffffffffc0207e14:	8626                	mv	a2,s1
ffffffffc0207e16:	9782                	jalr	a5
ffffffffc0207e18:	842a                	mv	s0,a0
ffffffffc0207e1a:	6562                	ld	a0,24(sp)
ffffffffc0207e1c:	1ba000ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc0207e20:	70e2                	ld	ra,56(sp)
ffffffffc0207e22:	8522                	mv	a0,s0
ffffffffc0207e24:	7442                	ld	s0,48(sp)
ffffffffc0207e26:	74a2                	ld	s1,40(sp)
ffffffffc0207e28:	7902                	ld	s2,32(sp)
ffffffffc0207e2a:	6121                	addi	sp,sp,64
ffffffffc0207e2c:	8082                	ret
ffffffffc0207e2e:	70e2                	ld	ra,56(sp)
ffffffffc0207e30:	8522                	mv	a0,s0
ffffffffc0207e32:	7442                	ld	s0,48(sp)
ffffffffc0207e34:	0124b023          	sd	s2,0(s1)
ffffffffc0207e38:	74a2                	ld	s1,40(sp)
ffffffffc0207e3a:	7902                	ld	s2,32(sp)
ffffffffc0207e3c:	6121                	addi	sp,sp,64
ffffffffc0207e3e:	8082                	ret
ffffffffc0207e40:	00006697          	auipc	a3,0x6
ffffffffc0207e44:	4f868693          	addi	a3,a3,1272 # ffffffffc020e338 <syscalls+0xa40>
ffffffffc0207e48:	00004617          	auipc	a2,0x4
ffffffffc0207e4c:	ad060613          	addi	a2,a2,-1328 # ffffffffc020b918 <commands+0x250>
ffffffffc0207e50:	04f00593          	li	a1,79
ffffffffc0207e54:	00006517          	auipc	a0,0x6
ffffffffc0207e58:	4cc50513          	addi	a0,a0,1228 # ffffffffc020e320 <syscalls+0xa28>
ffffffffc0207e5c:	bd2f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207e60 <vfs_lookup_parent>:
ffffffffc0207e60:	7139                	addi	sp,sp,-64
ffffffffc0207e62:	f822                	sd	s0,48(sp)
ffffffffc0207e64:	f426                	sd	s1,40(sp)
ffffffffc0207e66:	842e                	mv	s0,a1
ffffffffc0207e68:	84b2                	mv	s1,a2
ffffffffc0207e6a:	002c                	addi	a1,sp,8
ffffffffc0207e6c:	0830                	addi	a2,sp,24
ffffffffc0207e6e:	fc06                	sd	ra,56(sp)
ffffffffc0207e70:	e42a                	sd	a0,8(sp)
ffffffffc0207e72:	e3fff0ef          	jal	ra,ffffffffc0207cb0 <get_device>
ffffffffc0207e76:	e509                	bnez	a0,ffffffffc0207e80 <vfs_lookup_parent+0x20>
ffffffffc0207e78:	67a2                	ld	a5,8(sp)
ffffffffc0207e7a:	e09c                	sd	a5,0(s1)
ffffffffc0207e7c:	67e2                	ld	a5,24(sp)
ffffffffc0207e7e:	e01c                	sd	a5,0(s0)
ffffffffc0207e80:	70e2                	ld	ra,56(sp)
ffffffffc0207e82:	7442                	ld	s0,48(sp)
ffffffffc0207e84:	74a2                	ld	s1,40(sp)
ffffffffc0207e86:	6121                	addi	sp,sp,64
ffffffffc0207e88:	8082                	ret

ffffffffc0207e8a <__alloc_inode>:
ffffffffc0207e8a:	1141                	addi	sp,sp,-16
ffffffffc0207e8c:	e022                	sd	s0,0(sp)
ffffffffc0207e8e:	842a                	mv	s0,a0
ffffffffc0207e90:	07800513          	li	a0,120
ffffffffc0207e94:	e406                	sd	ra,8(sp)
ffffffffc0207e96:	92dfb0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0207e9a:	c111                	beqz	a0,ffffffffc0207e9e <__alloc_inode+0x14>
ffffffffc0207e9c:	cd20                	sw	s0,88(a0)
ffffffffc0207e9e:	60a2                	ld	ra,8(sp)
ffffffffc0207ea0:	6402                	ld	s0,0(sp)
ffffffffc0207ea2:	0141                	addi	sp,sp,16
ffffffffc0207ea4:	8082                	ret

ffffffffc0207ea6 <inode_init>:
ffffffffc0207ea6:	4785                	li	a5,1
ffffffffc0207ea8:	06052023          	sw	zero,96(a0)
ffffffffc0207eac:	f92c                	sd	a1,112(a0)
ffffffffc0207eae:	f530                	sd	a2,104(a0)
ffffffffc0207eb0:	cd7c                	sw	a5,92(a0)
ffffffffc0207eb2:	8082                	ret

ffffffffc0207eb4 <inode_kill>:
ffffffffc0207eb4:	4d78                	lw	a4,92(a0)
ffffffffc0207eb6:	1141                	addi	sp,sp,-16
ffffffffc0207eb8:	e406                	sd	ra,8(sp)
ffffffffc0207eba:	e719                	bnez	a4,ffffffffc0207ec8 <inode_kill+0x14>
ffffffffc0207ebc:	513c                	lw	a5,96(a0)
ffffffffc0207ebe:	e78d                	bnez	a5,ffffffffc0207ee8 <inode_kill+0x34>
ffffffffc0207ec0:	60a2                	ld	ra,8(sp)
ffffffffc0207ec2:	0141                	addi	sp,sp,16
ffffffffc0207ec4:	9affb06f          	j	ffffffffc0203872 <kfree>
ffffffffc0207ec8:	00006697          	auipc	a3,0x6
ffffffffc0207ecc:	4c868693          	addi	a3,a3,1224 # ffffffffc020e390 <syscalls+0xa98>
ffffffffc0207ed0:	00004617          	auipc	a2,0x4
ffffffffc0207ed4:	a4860613          	addi	a2,a2,-1464 # ffffffffc020b918 <commands+0x250>
ffffffffc0207ed8:	02900593          	li	a1,41
ffffffffc0207edc:	00006517          	auipc	a0,0x6
ffffffffc0207ee0:	4d450513          	addi	a0,a0,1236 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc0207ee4:	b4af80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207ee8:	00006697          	auipc	a3,0x6
ffffffffc0207eec:	4e068693          	addi	a3,a3,1248 # ffffffffc020e3c8 <syscalls+0xad0>
ffffffffc0207ef0:	00004617          	auipc	a2,0x4
ffffffffc0207ef4:	a2860613          	addi	a2,a2,-1496 # ffffffffc020b918 <commands+0x250>
ffffffffc0207ef8:	02a00593          	li	a1,42
ffffffffc0207efc:	00006517          	auipc	a0,0x6
ffffffffc0207f00:	4b450513          	addi	a0,a0,1204 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc0207f04:	b2af80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207f08 <inode_ref_inc>:
ffffffffc0207f08:	4d7c                	lw	a5,92(a0)
ffffffffc0207f0a:	2785                	addiw	a5,a5,1
ffffffffc0207f0c:	cd7c                	sw	a5,92(a0)
ffffffffc0207f0e:	0007851b          	sext.w	a0,a5
ffffffffc0207f12:	8082                	ret

ffffffffc0207f14 <inode_open_inc>:
ffffffffc0207f14:	513c                	lw	a5,96(a0)
ffffffffc0207f16:	2785                	addiw	a5,a5,1
ffffffffc0207f18:	d13c                	sw	a5,96(a0)
ffffffffc0207f1a:	0007851b          	sext.w	a0,a5
ffffffffc0207f1e:	8082                	ret

ffffffffc0207f20 <inode_check>:
ffffffffc0207f20:	1141                	addi	sp,sp,-16
ffffffffc0207f22:	e406                	sd	ra,8(sp)
ffffffffc0207f24:	c90d                	beqz	a0,ffffffffc0207f56 <inode_check+0x36>
ffffffffc0207f26:	793c                	ld	a5,112(a0)
ffffffffc0207f28:	c79d                	beqz	a5,ffffffffc0207f56 <inode_check+0x36>
ffffffffc0207f2a:	6398                	ld	a4,0(a5)
ffffffffc0207f2c:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207f30:	0786                	slli	a5,a5,0x1
ffffffffc0207f32:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0207f36:	08f71063          	bne	a4,a5,ffffffffc0207fb6 <inode_check+0x96>
ffffffffc0207f3a:	4d78                	lw	a4,92(a0)
ffffffffc0207f3c:	513c                	lw	a5,96(a0)
ffffffffc0207f3e:	04f74c63          	blt	a4,a5,ffffffffc0207f96 <inode_check+0x76>
ffffffffc0207f42:	0407ca63          	bltz	a5,ffffffffc0207f96 <inode_check+0x76>
ffffffffc0207f46:	66c1                	lui	a3,0x10
ffffffffc0207f48:	02d75763          	bge	a4,a3,ffffffffc0207f76 <inode_check+0x56>
ffffffffc0207f4c:	02d7d563          	bge	a5,a3,ffffffffc0207f76 <inode_check+0x56>
ffffffffc0207f50:	60a2                	ld	ra,8(sp)
ffffffffc0207f52:	0141                	addi	sp,sp,16
ffffffffc0207f54:	8082                	ret
ffffffffc0207f56:	00006697          	auipc	a3,0x6
ffffffffc0207f5a:	49268693          	addi	a3,a3,1170 # ffffffffc020e3e8 <syscalls+0xaf0>
ffffffffc0207f5e:	00004617          	auipc	a2,0x4
ffffffffc0207f62:	9ba60613          	addi	a2,a2,-1606 # ffffffffc020b918 <commands+0x250>
ffffffffc0207f66:	06e00593          	li	a1,110
ffffffffc0207f6a:	00006517          	auipc	a0,0x6
ffffffffc0207f6e:	44650513          	addi	a0,a0,1094 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc0207f72:	abcf80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207f76:	00006697          	auipc	a3,0x6
ffffffffc0207f7a:	4f268693          	addi	a3,a3,1266 # ffffffffc020e468 <syscalls+0xb70>
ffffffffc0207f7e:	00004617          	auipc	a2,0x4
ffffffffc0207f82:	99a60613          	addi	a2,a2,-1638 # ffffffffc020b918 <commands+0x250>
ffffffffc0207f86:	07200593          	li	a1,114
ffffffffc0207f8a:	00006517          	auipc	a0,0x6
ffffffffc0207f8e:	42650513          	addi	a0,a0,1062 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc0207f92:	a9cf80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207f96:	00006697          	auipc	a3,0x6
ffffffffc0207f9a:	4a268693          	addi	a3,a3,1186 # ffffffffc020e438 <syscalls+0xb40>
ffffffffc0207f9e:	00004617          	auipc	a2,0x4
ffffffffc0207fa2:	97a60613          	addi	a2,a2,-1670 # ffffffffc020b918 <commands+0x250>
ffffffffc0207fa6:	07100593          	li	a1,113
ffffffffc0207faa:	00006517          	auipc	a0,0x6
ffffffffc0207fae:	40650513          	addi	a0,a0,1030 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc0207fb2:	a7cf80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207fb6:	00006697          	auipc	a3,0x6
ffffffffc0207fba:	45a68693          	addi	a3,a3,1114 # ffffffffc020e410 <syscalls+0xb18>
ffffffffc0207fbe:	00004617          	auipc	a2,0x4
ffffffffc0207fc2:	95a60613          	addi	a2,a2,-1702 # ffffffffc020b918 <commands+0x250>
ffffffffc0207fc6:	06f00593          	li	a1,111
ffffffffc0207fca:	00006517          	auipc	a0,0x6
ffffffffc0207fce:	3e650513          	addi	a0,a0,998 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc0207fd2:	a5cf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207fd6 <inode_ref_dec>:
ffffffffc0207fd6:	4d7c                	lw	a5,92(a0)
ffffffffc0207fd8:	1101                	addi	sp,sp,-32
ffffffffc0207fda:	ec06                	sd	ra,24(sp)
ffffffffc0207fdc:	e822                	sd	s0,16(sp)
ffffffffc0207fde:	e426                	sd	s1,8(sp)
ffffffffc0207fe0:	e04a                	sd	s2,0(sp)
ffffffffc0207fe2:	06f05e63          	blez	a5,ffffffffc020805e <inode_ref_dec+0x88>
ffffffffc0207fe6:	fff7849b          	addiw	s1,a5,-1
ffffffffc0207fea:	cd64                	sw	s1,92(a0)
ffffffffc0207fec:	842a                	mv	s0,a0
ffffffffc0207fee:	e09d                	bnez	s1,ffffffffc0208014 <inode_ref_dec+0x3e>
ffffffffc0207ff0:	793c                	ld	a5,112(a0)
ffffffffc0207ff2:	c7b1                	beqz	a5,ffffffffc020803e <inode_ref_dec+0x68>
ffffffffc0207ff4:	0487b903          	ld	s2,72(a5)
ffffffffc0207ff8:	04090363          	beqz	s2,ffffffffc020803e <inode_ref_dec+0x68>
ffffffffc0207ffc:	00006597          	auipc	a1,0x6
ffffffffc0208000:	51c58593          	addi	a1,a1,1308 # ffffffffc020e518 <syscalls+0xc20>
ffffffffc0208004:	f1dff0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0208008:	8522                	mv	a0,s0
ffffffffc020800a:	9902                	jalr	s2
ffffffffc020800c:	c501                	beqz	a0,ffffffffc0208014 <inode_ref_dec+0x3e>
ffffffffc020800e:	57c5                	li	a5,-15
ffffffffc0208010:	00f51963          	bne	a0,a5,ffffffffc0208022 <inode_ref_dec+0x4c>
ffffffffc0208014:	60e2                	ld	ra,24(sp)
ffffffffc0208016:	6442                	ld	s0,16(sp)
ffffffffc0208018:	6902                	ld	s2,0(sp)
ffffffffc020801a:	8526                	mv	a0,s1
ffffffffc020801c:	64a2                	ld	s1,8(sp)
ffffffffc020801e:	6105                	addi	sp,sp,32
ffffffffc0208020:	8082                	ret
ffffffffc0208022:	85aa                	mv	a1,a0
ffffffffc0208024:	00006517          	auipc	a0,0x6
ffffffffc0208028:	4fc50513          	addi	a0,a0,1276 # ffffffffc020e520 <syscalls+0xc28>
ffffffffc020802c:	8fef80ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0208030:	60e2                	ld	ra,24(sp)
ffffffffc0208032:	6442                	ld	s0,16(sp)
ffffffffc0208034:	6902                	ld	s2,0(sp)
ffffffffc0208036:	8526                	mv	a0,s1
ffffffffc0208038:	64a2                	ld	s1,8(sp)
ffffffffc020803a:	6105                	addi	sp,sp,32
ffffffffc020803c:	8082                	ret
ffffffffc020803e:	00006697          	auipc	a3,0x6
ffffffffc0208042:	48a68693          	addi	a3,a3,1162 # ffffffffc020e4c8 <syscalls+0xbd0>
ffffffffc0208046:	00004617          	auipc	a2,0x4
ffffffffc020804a:	8d260613          	addi	a2,a2,-1838 # ffffffffc020b918 <commands+0x250>
ffffffffc020804e:	04400593          	li	a1,68
ffffffffc0208052:	00006517          	auipc	a0,0x6
ffffffffc0208056:	35e50513          	addi	a0,a0,862 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc020805a:	9d4f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020805e:	00006697          	auipc	a3,0x6
ffffffffc0208062:	44a68693          	addi	a3,a3,1098 # ffffffffc020e4a8 <syscalls+0xbb0>
ffffffffc0208066:	00004617          	auipc	a2,0x4
ffffffffc020806a:	8b260613          	addi	a2,a2,-1870 # ffffffffc020b918 <commands+0x250>
ffffffffc020806e:	03f00593          	li	a1,63
ffffffffc0208072:	00006517          	auipc	a0,0x6
ffffffffc0208076:	33e50513          	addi	a0,a0,830 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc020807a:	9b4f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020807e <inode_open_dec>:
ffffffffc020807e:	513c                	lw	a5,96(a0)
ffffffffc0208080:	1101                	addi	sp,sp,-32
ffffffffc0208082:	ec06                	sd	ra,24(sp)
ffffffffc0208084:	e822                	sd	s0,16(sp)
ffffffffc0208086:	e426                	sd	s1,8(sp)
ffffffffc0208088:	e04a                	sd	s2,0(sp)
ffffffffc020808a:	06f05b63          	blez	a5,ffffffffc0208100 <inode_open_dec+0x82>
ffffffffc020808e:	fff7849b          	addiw	s1,a5,-1
ffffffffc0208092:	d124                	sw	s1,96(a0)
ffffffffc0208094:	842a                	mv	s0,a0
ffffffffc0208096:	e085                	bnez	s1,ffffffffc02080b6 <inode_open_dec+0x38>
ffffffffc0208098:	793c                	ld	a5,112(a0)
ffffffffc020809a:	c3b9                	beqz	a5,ffffffffc02080e0 <inode_open_dec+0x62>
ffffffffc020809c:	0107b903          	ld	s2,16(a5)
ffffffffc02080a0:	04090063          	beqz	s2,ffffffffc02080e0 <inode_open_dec+0x62>
ffffffffc02080a4:	00006597          	auipc	a1,0x6
ffffffffc02080a8:	50c58593          	addi	a1,a1,1292 # ffffffffc020e5b0 <syscalls+0xcb8>
ffffffffc02080ac:	e75ff0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02080b0:	8522                	mv	a0,s0
ffffffffc02080b2:	9902                	jalr	s2
ffffffffc02080b4:	e901                	bnez	a0,ffffffffc02080c4 <inode_open_dec+0x46>
ffffffffc02080b6:	60e2                	ld	ra,24(sp)
ffffffffc02080b8:	6442                	ld	s0,16(sp)
ffffffffc02080ba:	6902                	ld	s2,0(sp)
ffffffffc02080bc:	8526                	mv	a0,s1
ffffffffc02080be:	64a2                	ld	s1,8(sp)
ffffffffc02080c0:	6105                	addi	sp,sp,32
ffffffffc02080c2:	8082                	ret
ffffffffc02080c4:	85aa                	mv	a1,a0
ffffffffc02080c6:	00006517          	auipc	a0,0x6
ffffffffc02080ca:	4f250513          	addi	a0,a0,1266 # ffffffffc020e5b8 <syscalls+0xcc0>
ffffffffc02080ce:	85cf80ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02080d2:	60e2                	ld	ra,24(sp)
ffffffffc02080d4:	6442                	ld	s0,16(sp)
ffffffffc02080d6:	6902                	ld	s2,0(sp)
ffffffffc02080d8:	8526                	mv	a0,s1
ffffffffc02080da:	64a2                	ld	s1,8(sp)
ffffffffc02080dc:	6105                	addi	sp,sp,32
ffffffffc02080de:	8082                	ret
ffffffffc02080e0:	00006697          	auipc	a3,0x6
ffffffffc02080e4:	48068693          	addi	a3,a3,1152 # ffffffffc020e560 <syscalls+0xc68>
ffffffffc02080e8:	00004617          	auipc	a2,0x4
ffffffffc02080ec:	83060613          	addi	a2,a2,-2000 # ffffffffc020b918 <commands+0x250>
ffffffffc02080f0:	06100593          	li	a1,97
ffffffffc02080f4:	00006517          	auipc	a0,0x6
ffffffffc02080f8:	2bc50513          	addi	a0,a0,700 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc02080fc:	932f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208100:	00006697          	auipc	a3,0x6
ffffffffc0208104:	44068693          	addi	a3,a3,1088 # ffffffffc020e540 <syscalls+0xc48>
ffffffffc0208108:	00004617          	auipc	a2,0x4
ffffffffc020810c:	81060613          	addi	a2,a2,-2032 # ffffffffc020b918 <commands+0x250>
ffffffffc0208110:	05c00593          	li	a1,92
ffffffffc0208114:	00006517          	auipc	a0,0x6
ffffffffc0208118:	29c50513          	addi	a0,a0,668 # ffffffffc020e3b0 <syscalls+0xab8>
ffffffffc020811c:	912f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208120 <vfs_open>:
ffffffffc0208120:	711d                	addi	sp,sp,-96
ffffffffc0208122:	e4a6                	sd	s1,72(sp)
ffffffffc0208124:	e0ca                	sd	s2,64(sp)
ffffffffc0208126:	fc4e                	sd	s3,56(sp)
ffffffffc0208128:	ec86                	sd	ra,88(sp)
ffffffffc020812a:	e8a2                	sd	s0,80(sp)
ffffffffc020812c:	f852                	sd	s4,48(sp)
ffffffffc020812e:	f456                	sd	s5,40(sp)
ffffffffc0208130:	0035f793          	andi	a5,a1,3
ffffffffc0208134:	84ae                	mv	s1,a1
ffffffffc0208136:	892a                	mv	s2,a0
ffffffffc0208138:	89b2                	mv	s3,a2
ffffffffc020813a:	0e078663          	beqz	a5,ffffffffc0208226 <vfs_open+0x106>
ffffffffc020813e:	470d                	li	a4,3
ffffffffc0208140:	0105fa93          	andi	s5,a1,16
ffffffffc0208144:	0ce78f63          	beq	a5,a4,ffffffffc0208222 <vfs_open+0x102>
ffffffffc0208148:	002c                	addi	a1,sp,8
ffffffffc020814a:	854a                	mv	a0,s2
ffffffffc020814c:	c7fff0ef          	jal	ra,ffffffffc0207dca <vfs_lookup>
ffffffffc0208150:	842a                	mv	s0,a0
ffffffffc0208152:	0044fa13          	andi	s4,s1,4
ffffffffc0208156:	e159                	bnez	a0,ffffffffc02081dc <vfs_open+0xbc>
ffffffffc0208158:	00c4f793          	andi	a5,s1,12
ffffffffc020815c:	4731                	li	a4,12
ffffffffc020815e:	0ee78263          	beq	a5,a4,ffffffffc0208242 <vfs_open+0x122>
ffffffffc0208162:	6422                	ld	s0,8(sp)
ffffffffc0208164:	12040163          	beqz	s0,ffffffffc0208286 <vfs_open+0x166>
ffffffffc0208168:	783c                	ld	a5,112(s0)
ffffffffc020816a:	cff1                	beqz	a5,ffffffffc0208246 <vfs_open+0x126>
ffffffffc020816c:	679c                	ld	a5,8(a5)
ffffffffc020816e:	cfe1                	beqz	a5,ffffffffc0208246 <vfs_open+0x126>
ffffffffc0208170:	8522                	mv	a0,s0
ffffffffc0208172:	00006597          	auipc	a1,0x6
ffffffffc0208176:	53658593          	addi	a1,a1,1334 # ffffffffc020e6a8 <syscalls+0xdb0>
ffffffffc020817a:	da7ff0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc020817e:	783c                	ld	a5,112(s0)
ffffffffc0208180:	6522                	ld	a0,8(sp)
ffffffffc0208182:	85a6                	mv	a1,s1
ffffffffc0208184:	679c                	ld	a5,8(a5)
ffffffffc0208186:	9782                	jalr	a5
ffffffffc0208188:	842a                	mv	s0,a0
ffffffffc020818a:	6522                	ld	a0,8(sp)
ffffffffc020818c:	e845                	bnez	s0,ffffffffc020823c <vfs_open+0x11c>
ffffffffc020818e:	015a6a33          	or	s4,s4,s5
ffffffffc0208192:	d83ff0ef          	jal	ra,ffffffffc0207f14 <inode_open_inc>
ffffffffc0208196:	020a0663          	beqz	s4,ffffffffc02081c2 <vfs_open+0xa2>
ffffffffc020819a:	64a2                	ld	s1,8(sp)
ffffffffc020819c:	c4e9                	beqz	s1,ffffffffc0208266 <vfs_open+0x146>
ffffffffc020819e:	78bc                	ld	a5,112(s1)
ffffffffc02081a0:	c3f9                	beqz	a5,ffffffffc0208266 <vfs_open+0x146>
ffffffffc02081a2:	73bc                	ld	a5,96(a5)
ffffffffc02081a4:	c3e9                	beqz	a5,ffffffffc0208266 <vfs_open+0x146>
ffffffffc02081a6:	00006597          	auipc	a1,0x6
ffffffffc02081aa:	56258593          	addi	a1,a1,1378 # ffffffffc020e708 <syscalls+0xe10>
ffffffffc02081ae:	8526                	mv	a0,s1
ffffffffc02081b0:	d71ff0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02081b4:	78bc                	ld	a5,112(s1)
ffffffffc02081b6:	6522                	ld	a0,8(sp)
ffffffffc02081b8:	4581                	li	a1,0
ffffffffc02081ba:	73bc                	ld	a5,96(a5)
ffffffffc02081bc:	9782                	jalr	a5
ffffffffc02081be:	87aa                	mv	a5,a0
ffffffffc02081c0:	e92d                	bnez	a0,ffffffffc0208232 <vfs_open+0x112>
ffffffffc02081c2:	67a2                	ld	a5,8(sp)
ffffffffc02081c4:	00f9b023          	sd	a5,0(s3)
ffffffffc02081c8:	60e6                	ld	ra,88(sp)
ffffffffc02081ca:	8522                	mv	a0,s0
ffffffffc02081cc:	6446                	ld	s0,80(sp)
ffffffffc02081ce:	64a6                	ld	s1,72(sp)
ffffffffc02081d0:	6906                	ld	s2,64(sp)
ffffffffc02081d2:	79e2                	ld	s3,56(sp)
ffffffffc02081d4:	7a42                	ld	s4,48(sp)
ffffffffc02081d6:	7aa2                	ld	s5,40(sp)
ffffffffc02081d8:	6125                	addi	sp,sp,96
ffffffffc02081da:	8082                	ret
ffffffffc02081dc:	57c1                	li	a5,-16
ffffffffc02081de:	fef515e3          	bne	a0,a5,ffffffffc02081c8 <vfs_open+0xa8>
ffffffffc02081e2:	fe0a03e3          	beqz	s4,ffffffffc02081c8 <vfs_open+0xa8>
ffffffffc02081e6:	0810                	addi	a2,sp,16
ffffffffc02081e8:	082c                	addi	a1,sp,24
ffffffffc02081ea:	854a                	mv	a0,s2
ffffffffc02081ec:	c75ff0ef          	jal	ra,ffffffffc0207e60 <vfs_lookup_parent>
ffffffffc02081f0:	842a                	mv	s0,a0
ffffffffc02081f2:	f979                	bnez	a0,ffffffffc02081c8 <vfs_open+0xa8>
ffffffffc02081f4:	6462                	ld	s0,24(sp)
ffffffffc02081f6:	c845                	beqz	s0,ffffffffc02082a6 <vfs_open+0x186>
ffffffffc02081f8:	783c                	ld	a5,112(s0)
ffffffffc02081fa:	c7d5                	beqz	a5,ffffffffc02082a6 <vfs_open+0x186>
ffffffffc02081fc:	77bc                	ld	a5,104(a5)
ffffffffc02081fe:	c7c5                	beqz	a5,ffffffffc02082a6 <vfs_open+0x186>
ffffffffc0208200:	8522                	mv	a0,s0
ffffffffc0208202:	00006597          	auipc	a1,0x6
ffffffffc0208206:	43e58593          	addi	a1,a1,1086 # ffffffffc020e640 <syscalls+0xd48>
ffffffffc020820a:	d17ff0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc020820e:	783c                	ld	a5,112(s0)
ffffffffc0208210:	65c2                	ld	a1,16(sp)
ffffffffc0208212:	6562                	ld	a0,24(sp)
ffffffffc0208214:	77bc                	ld	a5,104(a5)
ffffffffc0208216:	4034d613          	srai	a2,s1,0x3
ffffffffc020821a:	0034                	addi	a3,sp,8
ffffffffc020821c:	8a05                	andi	a2,a2,1
ffffffffc020821e:	9782                	jalr	a5
ffffffffc0208220:	b789                	j	ffffffffc0208162 <vfs_open+0x42>
ffffffffc0208222:	5475                	li	s0,-3
ffffffffc0208224:	b755                	j	ffffffffc02081c8 <vfs_open+0xa8>
ffffffffc0208226:	0105fa93          	andi	s5,a1,16
ffffffffc020822a:	5475                	li	s0,-3
ffffffffc020822c:	f80a9ee3          	bnez	s5,ffffffffc02081c8 <vfs_open+0xa8>
ffffffffc0208230:	bf21                	j	ffffffffc0208148 <vfs_open+0x28>
ffffffffc0208232:	6522                	ld	a0,8(sp)
ffffffffc0208234:	843e                	mv	s0,a5
ffffffffc0208236:	e49ff0ef          	jal	ra,ffffffffc020807e <inode_open_dec>
ffffffffc020823a:	6522                	ld	a0,8(sp)
ffffffffc020823c:	d9bff0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc0208240:	b761                	j	ffffffffc02081c8 <vfs_open+0xa8>
ffffffffc0208242:	5425                	li	s0,-23
ffffffffc0208244:	b751                	j	ffffffffc02081c8 <vfs_open+0xa8>
ffffffffc0208246:	00006697          	auipc	a3,0x6
ffffffffc020824a:	41268693          	addi	a3,a3,1042 # ffffffffc020e658 <syscalls+0xd60>
ffffffffc020824e:	00003617          	auipc	a2,0x3
ffffffffc0208252:	6ca60613          	addi	a2,a2,1738 # ffffffffc020b918 <commands+0x250>
ffffffffc0208256:	03300593          	li	a1,51
ffffffffc020825a:	00006517          	auipc	a0,0x6
ffffffffc020825e:	3ce50513          	addi	a0,a0,974 # ffffffffc020e628 <syscalls+0xd30>
ffffffffc0208262:	fcdf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208266:	00006697          	auipc	a3,0x6
ffffffffc020826a:	44a68693          	addi	a3,a3,1098 # ffffffffc020e6b0 <syscalls+0xdb8>
ffffffffc020826e:	00003617          	auipc	a2,0x3
ffffffffc0208272:	6aa60613          	addi	a2,a2,1706 # ffffffffc020b918 <commands+0x250>
ffffffffc0208276:	03a00593          	li	a1,58
ffffffffc020827a:	00006517          	auipc	a0,0x6
ffffffffc020827e:	3ae50513          	addi	a0,a0,942 # ffffffffc020e628 <syscalls+0xd30>
ffffffffc0208282:	fadf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208286:	00006697          	auipc	a3,0x6
ffffffffc020828a:	3c268693          	addi	a3,a3,962 # ffffffffc020e648 <syscalls+0xd50>
ffffffffc020828e:	00003617          	auipc	a2,0x3
ffffffffc0208292:	68a60613          	addi	a2,a2,1674 # ffffffffc020b918 <commands+0x250>
ffffffffc0208296:	03100593          	li	a1,49
ffffffffc020829a:	00006517          	auipc	a0,0x6
ffffffffc020829e:	38e50513          	addi	a0,a0,910 # ffffffffc020e628 <syscalls+0xd30>
ffffffffc02082a2:	f8df70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02082a6:	00006697          	auipc	a3,0x6
ffffffffc02082aa:	33268693          	addi	a3,a3,818 # ffffffffc020e5d8 <syscalls+0xce0>
ffffffffc02082ae:	00003617          	auipc	a2,0x3
ffffffffc02082b2:	66a60613          	addi	a2,a2,1642 # ffffffffc020b918 <commands+0x250>
ffffffffc02082b6:	02c00593          	li	a1,44
ffffffffc02082ba:	00006517          	auipc	a0,0x6
ffffffffc02082be:	36e50513          	addi	a0,a0,878 # ffffffffc020e628 <syscalls+0xd30>
ffffffffc02082c2:	f6df70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02082c6 <vfs_close>:
ffffffffc02082c6:	1141                	addi	sp,sp,-16
ffffffffc02082c8:	e406                	sd	ra,8(sp)
ffffffffc02082ca:	e022                	sd	s0,0(sp)
ffffffffc02082cc:	842a                	mv	s0,a0
ffffffffc02082ce:	db1ff0ef          	jal	ra,ffffffffc020807e <inode_open_dec>
ffffffffc02082d2:	8522                	mv	a0,s0
ffffffffc02082d4:	d03ff0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc02082d8:	60a2                	ld	ra,8(sp)
ffffffffc02082da:	6402                	ld	s0,0(sp)
ffffffffc02082dc:	4501                	li	a0,0
ffffffffc02082de:	0141                	addi	sp,sp,16
ffffffffc02082e0:	8082                	ret

ffffffffc02082e2 <__alloc_fs>:
ffffffffc02082e2:	1141                	addi	sp,sp,-16
ffffffffc02082e4:	e022                	sd	s0,0(sp)
ffffffffc02082e6:	842a                	mv	s0,a0
ffffffffc02082e8:	0d800513          	li	a0,216
ffffffffc02082ec:	e406                	sd	ra,8(sp)
ffffffffc02082ee:	cd4fb0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02082f2:	c119                	beqz	a0,ffffffffc02082f8 <__alloc_fs+0x16>
ffffffffc02082f4:	0a852823          	sw	s0,176(a0)
ffffffffc02082f8:	60a2                	ld	ra,8(sp)
ffffffffc02082fa:	6402                	ld	s0,0(sp)
ffffffffc02082fc:	0141                	addi	sp,sp,16
ffffffffc02082fe:	8082                	ret

ffffffffc0208300 <vfs_init>:
ffffffffc0208300:	1141                	addi	sp,sp,-16
ffffffffc0208302:	4585                	li	a1,1
ffffffffc0208304:	0008d517          	auipc	a0,0x8d
ffffffffc0208308:	52450513          	addi	a0,a0,1316 # ffffffffc0295828 <bootfs_sem>
ffffffffc020830c:	e406                	sd	ra,8(sp)
ffffffffc020830e:	c30fc0ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc0208312:	60a2                	ld	ra,8(sp)
ffffffffc0208314:	0141                	addi	sp,sp,16
ffffffffc0208316:	d0aff06f          	j	ffffffffc0207820 <vfs_devlist_init>

ffffffffc020831a <vfs_set_bootfs>:
ffffffffc020831a:	7179                	addi	sp,sp,-48
ffffffffc020831c:	f022                	sd	s0,32(sp)
ffffffffc020831e:	f406                	sd	ra,40(sp)
ffffffffc0208320:	ec26                	sd	s1,24(sp)
ffffffffc0208322:	e402                	sd	zero,8(sp)
ffffffffc0208324:	842a                	mv	s0,a0
ffffffffc0208326:	c915                	beqz	a0,ffffffffc020835a <vfs_set_bootfs+0x40>
ffffffffc0208328:	03a00593          	li	a1,58
ffffffffc020832c:	3df020ef          	jal	ra,ffffffffc020af0a <strchr>
ffffffffc0208330:	c135                	beqz	a0,ffffffffc0208394 <vfs_set_bootfs+0x7a>
ffffffffc0208332:	00154783          	lbu	a5,1(a0)
ffffffffc0208336:	efb9                	bnez	a5,ffffffffc0208394 <vfs_set_bootfs+0x7a>
ffffffffc0208338:	8522                	mv	a0,s0
ffffffffc020833a:	86bff0ef          	jal	ra,ffffffffc0207ba4 <vfs_chdir>
ffffffffc020833e:	842a                	mv	s0,a0
ffffffffc0208340:	c519                	beqz	a0,ffffffffc020834e <vfs_set_bootfs+0x34>
ffffffffc0208342:	70a2                	ld	ra,40(sp)
ffffffffc0208344:	8522                	mv	a0,s0
ffffffffc0208346:	7402                	ld	s0,32(sp)
ffffffffc0208348:	64e2                	ld	s1,24(sp)
ffffffffc020834a:	6145                	addi	sp,sp,48
ffffffffc020834c:	8082                	ret
ffffffffc020834e:	0028                	addi	a0,sp,8
ffffffffc0208350:	f5eff0ef          	jal	ra,ffffffffc0207aae <vfs_get_curdir>
ffffffffc0208354:	842a                	mv	s0,a0
ffffffffc0208356:	f575                	bnez	a0,ffffffffc0208342 <vfs_set_bootfs+0x28>
ffffffffc0208358:	6422                	ld	s0,8(sp)
ffffffffc020835a:	0008d517          	auipc	a0,0x8d
ffffffffc020835e:	4ce50513          	addi	a0,a0,1230 # ffffffffc0295828 <bootfs_sem>
ffffffffc0208362:	be8fc0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0208366:	0008e797          	auipc	a5,0x8e
ffffffffc020836a:	58a78793          	addi	a5,a5,1418 # ffffffffc02968f0 <bootfs_node>
ffffffffc020836e:	6384                	ld	s1,0(a5)
ffffffffc0208370:	0008d517          	auipc	a0,0x8d
ffffffffc0208374:	4b850513          	addi	a0,a0,1208 # ffffffffc0295828 <bootfs_sem>
ffffffffc0208378:	e380                	sd	s0,0(a5)
ffffffffc020837a:	4401                	li	s0,0
ffffffffc020837c:	bcafc0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0208380:	d0e9                	beqz	s1,ffffffffc0208342 <vfs_set_bootfs+0x28>
ffffffffc0208382:	8526                	mv	a0,s1
ffffffffc0208384:	c53ff0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc0208388:	70a2                	ld	ra,40(sp)
ffffffffc020838a:	8522                	mv	a0,s0
ffffffffc020838c:	7402                	ld	s0,32(sp)
ffffffffc020838e:	64e2                	ld	s1,24(sp)
ffffffffc0208390:	6145                	addi	sp,sp,48
ffffffffc0208392:	8082                	ret
ffffffffc0208394:	5475                	li	s0,-3
ffffffffc0208396:	b775                	j	ffffffffc0208342 <vfs_set_bootfs+0x28>

ffffffffc0208398 <vfs_get_bootfs>:
ffffffffc0208398:	1101                	addi	sp,sp,-32
ffffffffc020839a:	e426                	sd	s1,8(sp)
ffffffffc020839c:	0008e497          	auipc	s1,0x8e
ffffffffc02083a0:	55448493          	addi	s1,s1,1364 # ffffffffc02968f0 <bootfs_node>
ffffffffc02083a4:	609c                	ld	a5,0(s1)
ffffffffc02083a6:	ec06                	sd	ra,24(sp)
ffffffffc02083a8:	e822                	sd	s0,16(sp)
ffffffffc02083aa:	c3a1                	beqz	a5,ffffffffc02083ea <vfs_get_bootfs+0x52>
ffffffffc02083ac:	842a                	mv	s0,a0
ffffffffc02083ae:	0008d517          	auipc	a0,0x8d
ffffffffc02083b2:	47a50513          	addi	a0,a0,1146 # ffffffffc0295828 <bootfs_sem>
ffffffffc02083b6:	b94fc0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc02083ba:	6084                	ld	s1,0(s1)
ffffffffc02083bc:	c08d                	beqz	s1,ffffffffc02083de <vfs_get_bootfs+0x46>
ffffffffc02083be:	8526                	mv	a0,s1
ffffffffc02083c0:	b49ff0ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc02083c4:	0008d517          	auipc	a0,0x8d
ffffffffc02083c8:	46450513          	addi	a0,a0,1124 # ffffffffc0295828 <bootfs_sem>
ffffffffc02083cc:	b7afc0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc02083d0:	4501                	li	a0,0
ffffffffc02083d2:	e004                	sd	s1,0(s0)
ffffffffc02083d4:	60e2                	ld	ra,24(sp)
ffffffffc02083d6:	6442                	ld	s0,16(sp)
ffffffffc02083d8:	64a2                	ld	s1,8(sp)
ffffffffc02083da:	6105                	addi	sp,sp,32
ffffffffc02083dc:	8082                	ret
ffffffffc02083de:	0008d517          	auipc	a0,0x8d
ffffffffc02083e2:	44a50513          	addi	a0,a0,1098 # ffffffffc0295828 <bootfs_sem>
ffffffffc02083e6:	b60fc0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc02083ea:	5541                	li	a0,-16
ffffffffc02083ec:	b7e5                	j	ffffffffc02083d4 <vfs_get_bootfs+0x3c>

ffffffffc02083ee <stdin_open>:
ffffffffc02083ee:	4501                	li	a0,0
ffffffffc02083f0:	e191                	bnez	a1,ffffffffc02083f4 <stdin_open+0x6>
ffffffffc02083f2:	8082                	ret
ffffffffc02083f4:	5575                	li	a0,-3
ffffffffc02083f6:	8082                	ret

ffffffffc02083f8 <stdin_close>:
ffffffffc02083f8:	4501                	li	a0,0
ffffffffc02083fa:	8082                	ret

ffffffffc02083fc <stdin_ioctl>:
ffffffffc02083fc:	5575                	li	a0,-3
ffffffffc02083fe:	8082                	ret

ffffffffc0208400 <stdin_io>:
ffffffffc0208400:	7135                	addi	sp,sp,-160
ffffffffc0208402:	ed06                	sd	ra,152(sp)
ffffffffc0208404:	e922                	sd	s0,144(sp)
ffffffffc0208406:	e526                	sd	s1,136(sp)
ffffffffc0208408:	e14a                	sd	s2,128(sp)
ffffffffc020840a:	fcce                	sd	s3,120(sp)
ffffffffc020840c:	f8d2                	sd	s4,112(sp)
ffffffffc020840e:	f4d6                	sd	s5,104(sp)
ffffffffc0208410:	f0da                	sd	s6,96(sp)
ffffffffc0208412:	ecde                	sd	s7,88(sp)
ffffffffc0208414:	e8e2                	sd	s8,80(sp)
ffffffffc0208416:	e4e6                	sd	s9,72(sp)
ffffffffc0208418:	e0ea                	sd	s10,64(sp)
ffffffffc020841a:	fc6e                	sd	s11,56(sp)
ffffffffc020841c:	14061163          	bnez	a2,ffffffffc020855e <stdin_io+0x15e>
ffffffffc0208420:	0005bd83          	ld	s11,0(a1)
ffffffffc0208424:	0185bd03          	ld	s10,24(a1)
ffffffffc0208428:	8b2e                	mv	s6,a1
ffffffffc020842a:	100027f3          	csrr	a5,sstatus
ffffffffc020842e:	8b89                	andi	a5,a5,2
ffffffffc0208430:	10079e63          	bnez	a5,ffffffffc020854c <stdin_io+0x14c>
ffffffffc0208434:	4401                	li	s0,0
ffffffffc0208436:	100d0963          	beqz	s10,ffffffffc0208548 <stdin_io+0x148>
ffffffffc020843a:	0008e997          	auipc	s3,0x8e
ffffffffc020843e:	4be98993          	addi	s3,s3,1214 # ffffffffc02968f8 <p_rpos>
ffffffffc0208442:	0009b783          	ld	a5,0(s3)
ffffffffc0208446:	800004b7          	lui	s1,0x80000
ffffffffc020844a:	6c85                	lui	s9,0x1
ffffffffc020844c:	4a81                	li	s5,0
ffffffffc020844e:	0008ea17          	auipc	s4,0x8e
ffffffffc0208452:	4b2a0a13          	addi	s4,s4,1202 # ffffffffc0296900 <p_wpos>
ffffffffc0208456:	0491                	addi	s1,s1,4
ffffffffc0208458:	0008d917          	auipc	s2,0x8d
ffffffffc020845c:	3e890913          	addi	s2,s2,1000 # ffffffffc0295840 <__wait_queue>
ffffffffc0208460:	1cfd                	addi	s9,s9,-1
ffffffffc0208462:	000a3703          	ld	a4,0(s4)
ffffffffc0208466:	000a8c1b          	sext.w	s8,s5
ffffffffc020846a:	8be2                	mv	s7,s8
ffffffffc020846c:	02e7d763          	bge	a5,a4,ffffffffc020849a <stdin_io+0x9a>
ffffffffc0208470:	a859                	j	ffffffffc0208506 <stdin_io+0x106>
ffffffffc0208472:	cd7fe0ef          	jal	ra,ffffffffc0207148 <schedule>
ffffffffc0208476:	100027f3          	csrr	a5,sstatus
ffffffffc020847a:	8b89                	andi	a5,a5,2
ffffffffc020847c:	4401                	li	s0,0
ffffffffc020847e:	ef8d                	bnez	a5,ffffffffc02084b8 <stdin_io+0xb8>
ffffffffc0208480:	0028                	addi	a0,sp,8
ffffffffc0208482:	ff9fb0ef          	jal	ra,ffffffffc020447a <wait_in_queue>
ffffffffc0208486:	e121                	bnez	a0,ffffffffc02084c6 <stdin_io+0xc6>
ffffffffc0208488:	47c2                	lw	a5,16(sp)
ffffffffc020848a:	04979563          	bne	a5,s1,ffffffffc02084d4 <stdin_io+0xd4>
ffffffffc020848e:	0009b783          	ld	a5,0(s3)
ffffffffc0208492:	000a3703          	ld	a4,0(s4)
ffffffffc0208496:	06e7c863          	blt	a5,a4,ffffffffc0208506 <stdin_io+0x106>
ffffffffc020849a:	8626                	mv	a2,s1
ffffffffc020849c:	002c                	addi	a1,sp,8
ffffffffc020849e:	854a                	mv	a0,s2
ffffffffc02084a0:	904fc0ef          	jal	ra,ffffffffc02045a4 <wait_current_set>
ffffffffc02084a4:	d479                	beqz	s0,ffffffffc0208472 <stdin_io+0x72>
ffffffffc02084a6:	8f5f80ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02084aa:	c9ffe0ef          	jal	ra,ffffffffc0207148 <schedule>
ffffffffc02084ae:	100027f3          	csrr	a5,sstatus
ffffffffc02084b2:	8b89                	andi	a5,a5,2
ffffffffc02084b4:	4401                	li	s0,0
ffffffffc02084b6:	d7e9                	beqz	a5,ffffffffc0208480 <stdin_io+0x80>
ffffffffc02084b8:	8e9f80ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02084bc:	0028                	addi	a0,sp,8
ffffffffc02084be:	4405                	li	s0,1
ffffffffc02084c0:	fbbfb0ef          	jal	ra,ffffffffc020447a <wait_in_queue>
ffffffffc02084c4:	d171                	beqz	a0,ffffffffc0208488 <stdin_io+0x88>
ffffffffc02084c6:	002c                	addi	a1,sp,8
ffffffffc02084c8:	854a                	mv	a0,s2
ffffffffc02084ca:	f57fb0ef          	jal	ra,ffffffffc0204420 <wait_queue_del>
ffffffffc02084ce:	47c2                	lw	a5,16(sp)
ffffffffc02084d0:	fa978fe3          	beq	a5,s1,ffffffffc020848e <stdin_io+0x8e>
ffffffffc02084d4:	e435                	bnez	s0,ffffffffc0208540 <stdin_io+0x140>
ffffffffc02084d6:	060b8963          	beqz	s7,ffffffffc0208548 <stdin_io+0x148>
ffffffffc02084da:	018b3783          	ld	a5,24(s6)
ffffffffc02084de:	41578ab3          	sub	s5,a5,s5
ffffffffc02084e2:	015b3c23          	sd	s5,24(s6)
ffffffffc02084e6:	60ea                	ld	ra,152(sp)
ffffffffc02084e8:	644a                	ld	s0,144(sp)
ffffffffc02084ea:	64aa                	ld	s1,136(sp)
ffffffffc02084ec:	690a                	ld	s2,128(sp)
ffffffffc02084ee:	79e6                	ld	s3,120(sp)
ffffffffc02084f0:	7a46                	ld	s4,112(sp)
ffffffffc02084f2:	7aa6                	ld	s5,104(sp)
ffffffffc02084f4:	7b06                	ld	s6,96(sp)
ffffffffc02084f6:	6c46                	ld	s8,80(sp)
ffffffffc02084f8:	6ca6                	ld	s9,72(sp)
ffffffffc02084fa:	6d06                	ld	s10,64(sp)
ffffffffc02084fc:	7de2                	ld	s11,56(sp)
ffffffffc02084fe:	855e                	mv	a0,s7
ffffffffc0208500:	6be6                	ld	s7,88(sp)
ffffffffc0208502:	610d                	addi	sp,sp,160
ffffffffc0208504:	8082                	ret
ffffffffc0208506:	43f7d713          	srai	a4,a5,0x3f
ffffffffc020850a:	03475693          	srli	a3,a4,0x34
ffffffffc020850e:	00d78733          	add	a4,a5,a3
ffffffffc0208512:	01977733          	and	a4,a4,s9
ffffffffc0208516:	8f15                	sub	a4,a4,a3
ffffffffc0208518:	0008d697          	auipc	a3,0x8d
ffffffffc020851c:	33868693          	addi	a3,a3,824 # ffffffffc0295850 <stdin_buffer>
ffffffffc0208520:	9736                	add	a4,a4,a3
ffffffffc0208522:	00074683          	lbu	a3,0(a4)
ffffffffc0208526:	0785                	addi	a5,a5,1
ffffffffc0208528:	015d8733          	add	a4,s11,s5
ffffffffc020852c:	00d70023          	sb	a3,0(a4)
ffffffffc0208530:	00f9b023          	sd	a5,0(s3)
ffffffffc0208534:	0a85                	addi	s5,s5,1
ffffffffc0208536:	001c0b9b          	addiw	s7,s8,1
ffffffffc020853a:	f3aae4e3          	bltu	s5,s10,ffffffffc0208462 <stdin_io+0x62>
ffffffffc020853e:	dc51                	beqz	s0,ffffffffc02084da <stdin_io+0xda>
ffffffffc0208540:	85bf80ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0208544:	f80b9be3          	bnez	s7,ffffffffc02084da <stdin_io+0xda>
ffffffffc0208548:	4b81                	li	s7,0
ffffffffc020854a:	bf71                	j	ffffffffc02084e6 <stdin_io+0xe6>
ffffffffc020854c:	855f80ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0208550:	4405                	li	s0,1
ffffffffc0208552:	ee0d14e3          	bnez	s10,ffffffffc020843a <stdin_io+0x3a>
ffffffffc0208556:	845f80ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020855a:	4b81                	li	s7,0
ffffffffc020855c:	b769                	j	ffffffffc02084e6 <stdin_io+0xe6>
ffffffffc020855e:	5bf5                	li	s7,-3
ffffffffc0208560:	b759                	j	ffffffffc02084e6 <stdin_io+0xe6>

ffffffffc0208562 <dev_stdin_write>:
ffffffffc0208562:	e111                	bnez	a0,ffffffffc0208566 <dev_stdin_write+0x4>
ffffffffc0208564:	8082                	ret
ffffffffc0208566:	1101                	addi	sp,sp,-32
ffffffffc0208568:	e822                	sd	s0,16(sp)
ffffffffc020856a:	ec06                	sd	ra,24(sp)
ffffffffc020856c:	e426                	sd	s1,8(sp)
ffffffffc020856e:	842a                	mv	s0,a0
ffffffffc0208570:	100027f3          	csrr	a5,sstatus
ffffffffc0208574:	8b89                	andi	a5,a5,2
ffffffffc0208576:	4481                	li	s1,0
ffffffffc0208578:	e3c1                	bnez	a5,ffffffffc02085f8 <dev_stdin_write+0x96>
ffffffffc020857a:	0008e597          	auipc	a1,0x8e
ffffffffc020857e:	38658593          	addi	a1,a1,902 # ffffffffc0296900 <p_wpos>
ffffffffc0208582:	6198                	ld	a4,0(a1)
ffffffffc0208584:	6605                	lui	a2,0x1
ffffffffc0208586:	fff60513          	addi	a0,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020858a:	43f75693          	srai	a3,a4,0x3f
ffffffffc020858e:	92d1                	srli	a3,a3,0x34
ffffffffc0208590:	00d707b3          	add	a5,a4,a3
ffffffffc0208594:	8fe9                	and	a5,a5,a0
ffffffffc0208596:	8f95                	sub	a5,a5,a3
ffffffffc0208598:	0008d697          	auipc	a3,0x8d
ffffffffc020859c:	2b868693          	addi	a3,a3,696 # ffffffffc0295850 <stdin_buffer>
ffffffffc02085a0:	97b6                	add	a5,a5,a3
ffffffffc02085a2:	00878023          	sb	s0,0(a5)
ffffffffc02085a6:	0008e797          	auipc	a5,0x8e
ffffffffc02085aa:	3527b783          	ld	a5,850(a5) # ffffffffc02968f8 <p_rpos>
ffffffffc02085ae:	40f707b3          	sub	a5,a4,a5
ffffffffc02085b2:	00c7d463          	bge	a5,a2,ffffffffc02085ba <dev_stdin_write+0x58>
ffffffffc02085b6:	0705                	addi	a4,a4,1
ffffffffc02085b8:	e198                	sd	a4,0(a1)
ffffffffc02085ba:	0008d517          	auipc	a0,0x8d
ffffffffc02085be:	28650513          	addi	a0,a0,646 # ffffffffc0295840 <__wait_queue>
ffffffffc02085c2:	eadfb0ef          	jal	ra,ffffffffc020446e <wait_queue_empty>
ffffffffc02085c6:	cd09                	beqz	a0,ffffffffc02085e0 <dev_stdin_write+0x7e>
ffffffffc02085c8:	e491                	bnez	s1,ffffffffc02085d4 <dev_stdin_write+0x72>
ffffffffc02085ca:	60e2                	ld	ra,24(sp)
ffffffffc02085cc:	6442                	ld	s0,16(sp)
ffffffffc02085ce:	64a2                	ld	s1,8(sp)
ffffffffc02085d0:	6105                	addi	sp,sp,32
ffffffffc02085d2:	8082                	ret
ffffffffc02085d4:	6442                	ld	s0,16(sp)
ffffffffc02085d6:	60e2                	ld	ra,24(sp)
ffffffffc02085d8:	64a2                	ld	s1,8(sp)
ffffffffc02085da:	6105                	addi	sp,sp,32
ffffffffc02085dc:	fbef806f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc02085e0:	800005b7          	lui	a1,0x80000
ffffffffc02085e4:	4605                	li	a2,1
ffffffffc02085e6:	0591                	addi	a1,a1,4
ffffffffc02085e8:	0008d517          	auipc	a0,0x8d
ffffffffc02085ec:	25850513          	addi	a0,a0,600 # ffffffffc0295840 <__wait_queue>
ffffffffc02085f0:	ee7fb0ef          	jal	ra,ffffffffc02044d6 <wakeup_queue>
ffffffffc02085f4:	d8f9                	beqz	s1,ffffffffc02085ca <dev_stdin_write+0x68>
ffffffffc02085f6:	bff9                	j	ffffffffc02085d4 <dev_stdin_write+0x72>
ffffffffc02085f8:	fa8f80ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02085fc:	4485                	li	s1,1
ffffffffc02085fe:	bfb5                	j	ffffffffc020857a <dev_stdin_write+0x18>

ffffffffc0208600 <dev_init_stdin>:
ffffffffc0208600:	1141                	addi	sp,sp,-16
ffffffffc0208602:	e406                	sd	ra,8(sp)
ffffffffc0208604:	e022                	sd	s0,0(sp)
ffffffffc0208606:	74a000ef          	jal	ra,ffffffffc0208d50 <dev_create_inode>
ffffffffc020860a:	c93d                	beqz	a0,ffffffffc0208680 <dev_init_stdin+0x80>
ffffffffc020860c:	4d38                	lw	a4,88(a0)
ffffffffc020860e:	6785                	lui	a5,0x1
ffffffffc0208610:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208614:	842a                	mv	s0,a0
ffffffffc0208616:	08f71e63          	bne	a4,a5,ffffffffc02086b2 <dev_init_stdin+0xb2>
ffffffffc020861a:	4785                	li	a5,1
ffffffffc020861c:	e41c                	sd	a5,8(s0)
ffffffffc020861e:	00000797          	auipc	a5,0x0
ffffffffc0208622:	dd078793          	addi	a5,a5,-560 # ffffffffc02083ee <stdin_open>
ffffffffc0208626:	e81c                	sd	a5,16(s0)
ffffffffc0208628:	00000797          	auipc	a5,0x0
ffffffffc020862c:	dd078793          	addi	a5,a5,-560 # ffffffffc02083f8 <stdin_close>
ffffffffc0208630:	ec1c                	sd	a5,24(s0)
ffffffffc0208632:	00000797          	auipc	a5,0x0
ffffffffc0208636:	dce78793          	addi	a5,a5,-562 # ffffffffc0208400 <stdin_io>
ffffffffc020863a:	f01c                	sd	a5,32(s0)
ffffffffc020863c:	00000797          	auipc	a5,0x0
ffffffffc0208640:	dc078793          	addi	a5,a5,-576 # ffffffffc02083fc <stdin_ioctl>
ffffffffc0208644:	f41c                	sd	a5,40(s0)
ffffffffc0208646:	0008d517          	auipc	a0,0x8d
ffffffffc020864a:	1fa50513          	addi	a0,a0,506 # ffffffffc0295840 <__wait_queue>
ffffffffc020864e:	00043023          	sd	zero,0(s0)
ffffffffc0208652:	0008e797          	auipc	a5,0x8e
ffffffffc0208656:	2a07b723          	sd	zero,686(a5) # ffffffffc0296900 <p_wpos>
ffffffffc020865a:	0008e797          	auipc	a5,0x8e
ffffffffc020865e:	2807bf23          	sd	zero,670(a5) # ffffffffc02968f8 <p_rpos>
ffffffffc0208662:	db9fb0ef          	jal	ra,ffffffffc020441a <wait_queue_init>
ffffffffc0208666:	4601                	li	a2,0
ffffffffc0208668:	85a2                	mv	a1,s0
ffffffffc020866a:	00006517          	auipc	a0,0x6
ffffffffc020866e:	0ee50513          	addi	a0,a0,238 # ffffffffc020e758 <syscalls+0xe60>
ffffffffc0208672:	b20ff0ef          	jal	ra,ffffffffc0207992 <vfs_add_dev>
ffffffffc0208676:	e10d                	bnez	a0,ffffffffc0208698 <dev_init_stdin+0x98>
ffffffffc0208678:	60a2                	ld	ra,8(sp)
ffffffffc020867a:	6402                	ld	s0,0(sp)
ffffffffc020867c:	0141                	addi	sp,sp,16
ffffffffc020867e:	8082                	ret
ffffffffc0208680:	00006617          	auipc	a2,0x6
ffffffffc0208684:	09860613          	addi	a2,a2,152 # ffffffffc020e718 <syscalls+0xe20>
ffffffffc0208688:	07500593          	li	a1,117
ffffffffc020868c:	00006517          	auipc	a0,0x6
ffffffffc0208690:	0ac50513          	addi	a0,a0,172 # ffffffffc020e738 <syscalls+0xe40>
ffffffffc0208694:	b9bf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208698:	86aa                	mv	a3,a0
ffffffffc020869a:	00006617          	auipc	a2,0x6
ffffffffc020869e:	0c660613          	addi	a2,a2,198 # ffffffffc020e760 <syscalls+0xe68>
ffffffffc02086a2:	07b00593          	li	a1,123
ffffffffc02086a6:	00006517          	auipc	a0,0x6
ffffffffc02086aa:	09250513          	addi	a0,a0,146 # ffffffffc020e738 <syscalls+0xe40>
ffffffffc02086ae:	b81f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02086b2:	00006697          	auipc	a3,0x6
ffffffffc02086b6:	b0e68693          	addi	a3,a3,-1266 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc02086ba:	00003617          	auipc	a2,0x3
ffffffffc02086be:	25e60613          	addi	a2,a2,606 # ffffffffc020b918 <commands+0x250>
ffffffffc02086c2:	07700593          	li	a1,119
ffffffffc02086c6:	00006517          	auipc	a0,0x6
ffffffffc02086ca:	07250513          	addi	a0,a0,114 # ffffffffc020e738 <syscalls+0xe40>
ffffffffc02086ce:	b61f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02086d2 <disk0_open>:
ffffffffc02086d2:	4501                	li	a0,0
ffffffffc02086d4:	8082                	ret

ffffffffc02086d6 <disk0_close>:
ffffffffc02086d6:	4501                	li	a0,0
ffffffffc02086d8:	8082                	ret

ffffffffc02086da <disk0_ioctl>:
ffffffffc02086da:	5531                	li	a0,-20
ffffffffc02086dc:	8082                	ret

ffffffffc02086de <disk0_io>:
ffffffffc02086de:	659c                	ld	a5,8(a1)
ffffffffc02086e0:	7159                	addi	sp,sp,-112
ffffffffc02086e2:	eca6                	sd	s1,88(sp)
ffffffffc02086e4:	f45e                	sd	s7,40(sp)
ffffffffc02086e6:	6d84                	ld	s1,24(a1)
ffffffffc02086e8:	6b85                	lui	s7,0x1
ffffffffc02086ea:	1bfd                	addi	s7,s7,-1
ffffffffc02086ec:	e4ce                	sd	s3,72(sp)
ffffffffc02086ee:	43f7d993          	srai	s3,a5,0x3f
ffffffffc02086f2:	0179f9b3          	and	s3,s3,s7
ffffffffc02086f6:	99be                	add	s3,s3,a5
ffffffffc02086f8:	8fc5                	or	a5,a5,s1
ffffffffc02086fa:	f486                	sd	ra,104(sp)
ffffffffc02086fc:	f0a2                	sd	s0,96(sp)
ffffffffc02086fe:	e8ca                	sd	s2,80(sp)
ffffffffc0208700:	e0d2                	sd	s4,64(sp)
ffffffffc0208702:	fc56                	sd	s5,56(sp)
ffffffffc0208704:	f85a                	sd	s6,48(sp)
ffffffffc0208706:	f062                	sd	s8,32(sp)
ffffffffc0208708:	ec66                	sd	s9,24(sp)
ffffffffc020870a:	e86a                	sd	s10,16(sp)
ffffffffc020870c:	0177f7b3          	and	a5,a5,s7
ffffffffc0208710:	10079d63          	bnez	a5,ffffffffc020882a <disk0_io+0x14c>
ffffffffc0208714:	40c9d993          	srai	s3,s3,0xc
ffffffffc0208718:	00c4d713          	srli	a4,s1,0xc
ffffffffc020871c:	2981                	sext.w	s3,s3
ffffffffc020871e:	2701                	sext.w	a4,a4
ffffffffc0208720:	00e987bb          	addw	a5,s3,a4
ffffffffc0208724:	6114                	ld	a3,0(a0)
ffffffffc0208726:	1782                	slli	a5,a5,0x20
ffffffffc0208728:	9381                	srli	a5,a5,0x20
ffffffffc020872a:	10f6e063          	bltu	a3,a5,ffffffffc020882a <disk0_io+0x14c>
ffffffffc020872e:	4501                	li	a0,0
ffffffffc0208730:	ef19                	bnez	a4,ffffffffc020874e <disk0_io+0x70>
ffffffffc0208732:	70a6                	ld	ra,104(sp)
ffffffffc0208734:	7406                	ld	s0,96(sp)
ffffffffc0208736:	64e6                	ld	s1,88(sp)
ffffffffc0208738:	6946                	ld	s2,80(sp)
ffffffffc020873a:	69a6                	ld	s3,72(sp)
ffffffffc020873c:	6a06                	ld	s4,64(sp)
ffffffffc020873e:	7ae2                	ld	s5,56(sp)
ffffffffc0208740:	7b42                	ld	s6,48(sp)
ffffffffc0208742:	7ba2                	ld	s7,40(sp)
ffffffffc0208744:	7c02                	ld	s8,32(sp)
ffffffffc0208746:	6ce2                	ld	s9,24(sp)
ffffffffc0208748:	6d42                	ld	s10,16(sp)
ffffffffc020874a:	6165                	addi	sp,sp,112
ffffffffc020874c:	8082                	ret
ffffffffc020874e:	0008e517          	auipc	a0,0x8e
ffffffffc0208752:	10250513          	addi	a0,a0,258 # ffffffffc0296850 <disk0_sem>
ffffffffc0208756:	8b2e                	mv	s6,a1
ffffffffc0208758:	8c32                	mv	s8,a2
ffffffffc020875a:	0008ea97          	auipc	s5,0x8e
ffffffffc020875e:	1aea8a93          	addi	s5,s5,430 # ffffffffc0296908 <disk0_buffer>
ffffffffc0208762:	fe9fb0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0208766:	6c91                	lui	s9,0x4
ffffffffc0208768:	e4b9                	bnez	s1,ffffffffc02087b6 <disk0_io+0xd8>
ffffffffc020876a:	a845                	j	ffffffffc020881a <disk0_io+0x13c>
ffffffffc020876c:	00c4d413          	srli	s0,s1,0xc
ffffffffc0208770:	0034169b          	slliw	a3,s0,0x3
ffffffffc0208774:	00068d1b          	sext.w	s10,a3
ffffffffc0208778:	1682                	slli	a3,a3,0x20
ffffffffc020877a:	2401                	sext.w	s0,s0
ffffffffc020877c:	9281                	srli	a3,a3,0x20
ffffffffc020877e:	8926                	mv	s2,s1
ffffffffc0208780:	00399a1b          	slliw	s4,s3,0x3
ffffffffc0208784:	862e                	mv	a2,a1
ffffffffc0208786:	4509                	li	a0,2
ffffffffc0208788:	85d2                	mv	a1,s4
ffffffffc020878a:	ce4f80ef          	jal	ra,ffffffffc0200c6e <ide_read_secs>
ffffffffc020878e:	e165                	bnez	a0,ffffffffc020886e <disk0_io+0x190>
ffffffffc0208790:	000ab583          	ld	a1,0(s5)
ffffffffc0208794:	0038                	addi	a4,sp,8
ffffffffc0208796:	4685                	li	a3,1
ffffffffc0208798:	864a                	mv	a2,s2
ffffffffc020879a:	855a                	mv	a0,s6
ffffffffc020879c:	f9bfc0ef          	jal	ra,ffffffffc0205736 <iobuf_move>
ffffffffc02087a0:	67a2                	ld	a5,8(sp)
ffffffffc02087a2:	09279663          	bne	a5,s2,ffffffffc020882e <disk0_io+0x150>
ffffffffc02087a6:	017977b3          	and	a5,s2,s7
ffffffffc02087aa:	e3d1                	bnez	a5,ffffffffc020882e <disk0_io+0x150>
ffffffffc02087ac:	412484b3          	sub	s1,s1,s2
ffffffffc02087b0:	013409bb          	addw	s3,s0,s3
ffffffffc02087b4:	c0bd                	beqz	s1,ffffffffc020881a <disk0_io+0x13c>
ffffffffc02087b6:	000ab583          	ld	a1,0(s5)
ffffffffc02087ba:	000c1b63          	bnez	s8,ffffffffc02087d0 <disk0_io+0xf2>
ffffffffc02087be:	fb94e7e3          	bltu	s1,s9,ffffffffc020876c <disk0_io+0x8e>
ffffffffc02087c2:	02000693          	li	a3,32
ffffffffc02087c6:	02000d13          	li	s10,32
ffffffffc02087ca:	4411                	li	s0,4
ffffffffc02087cc:	6911                	lui	s2,0x4
ffffffffc02087ce:	bf4d                	j	ffffffffc0208780 <disk0_io+0xa2>
ffffffffc02087d0:	0038                	addi	a4,sp,8
ffffffffc02087d2:	4681                	li	a3,0
ffffffffc02087d4:	6611                	lui	a2,0x4
ffffffffc02087d6:	855a                	mv	a0,s6
ffffffffc02087d8:	f5ffc0ef          	jal	ra,ffffffffc0205736 <iobuf_move>
ffffffffc02087dc:	6422                	ld	s0,8(sp)
ffffffffc02087de:	c825                	beqz	s0,ffffffffc020884e <disk0_io+0x170>
ffffffffc02087e0:	0684e763          	bltu	s1,s0,ffffffffc020884e <disk0_io+0x170>
ffffffffc02087e4:	017477b3          	and	a5,s0,s7
ffffffffc02087e8:	e3bd                	bnez	a5,ffffffffc020884e <disk0_io+0x170>
ffffffffc02087ea:	8031                	srli	s0,s0,0xc
ffffffffc02087ec:	0034179b          	slliw	a5,s0,0x3
ffffffffc02087f0:	000ab603          	ld	a2,0(s5)
ffffffffc02087f4:	0039991b          	slliw	s2,s3,0x3
ffffffffc02087f8:	02079693          	slli	a3,a5,0x20
ffffffffc02087fc:	9281                	srli	a3,a3,0x20
ffffffffc02087fe:	85ca                	mv	a1,s2
ffffffffc0208800:	4509                	li	a0,2
ffffffffc0208802:	2401                	sext.w	s0,s0
ffffffffc0208804:	00078a1b          	sext.w	s4,a5
ffffffffc0208808:	cfcf80ef          	jal	ra,ffffffffc0200d04 <ide_write_secs>
ffffffffc020880c:	e151                	bnez	a0,ffffffffc0208890 <disk0_io+0x1b2>
ffffffffc020880e:	6922                	ld	s2,8(sp)
ffffffffc0208810:	013409bb          	addw	s3,s0,s3
ffffffffc0208814:	412484b3          	sub	s1,s1,s2
ffffffffc0208818:	fcd9                	bnez	s1,ffffffffc02087b6 <disk0_io+0xd8>
ffffffffc020881a:	0008e517          	auipc	a0,0x8e
ffffffffc020881e:	03650513          	addi	a0,a0,54 # ffffffffc0296850 <disk0_sem>
ffffffffc0208822:	f25fb0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc0208826:	4501                	li	a0,0
ffffffffc0208828:	b729                	j	ffffffffc0208732 <disk0_io+0x54>
ffffffffc020882a:	5575                	li	a0,-3
ffffffffc020882c:	b719                	j	ffffffffc0208732 <disk0_io+0x54>
ffffffffc020882e:	00006697          	auipc	a3,0x6
ffffffffc0208832:	04a68693          	addi	a3,a3,74 # ffffffffc020e878 <syscalls+0xf80>
ffffffffc0208836:	00003617          	auipc	a2,0x3
ffffffffc020883a:	0e260613          	addi	a2,a2,226 # ffffffffc020b918 <commands+0x250>
ffffffffc020883e:	06200593          	li	a1,98
ffffffffc0208842:	00006517          	auipc	a0,0x6
ffffffffc0208846:	f7e50513          	addi	a0,a0,-130 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc020884a:	9e5f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020884e:	00006697          	auipc	a3,0x6
ffffffffc0208852:	f3268693          	addi	a3,a3,-206 # ffffffffc020e780 <syscalls+0xe88>
ffffffffc0208856:	00003617          	auipc	a2,0x3
ffffffffc020885a:	0c260613          	addi	a2,a2,194 # ffffffffc020b918 <commands+0x250>
ffffffffc020885e:	05700593          	li	a1,87
ffffffffc0208862:	00006517          	auipc	a0,0x6
ffffffffc0208866:	f5e50513          	addi	a0,a0,-162 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc020886a:	9c5f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020886e:	88aa                	mv	a7,a0
ffffffffc0208870:	886a                	mv	a6,s10
ffffffffc0208872:	87a2                	mv	a5,s0
ffffffffc0208874:	8752                	mv	a4,s4
ffffffffc0208876:	86ce                	mv	a3,s3
ffffffffc0208878:	00006617          	auipc	a2,0x6
ffffffffc020887c:	fb860613          	addi	a2,a2,-72 # ffffffffc020e830 <syscalls+0xf38>
ffffffffc0208880:	02d00593          	li	a1,45
ffffffffc0208884:	00006517          	auipc	a0,0x6
ffffffffc0208888:	f3c50513          	addi	a0,a0,-196 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc020888c:	9a3f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208890:	88aa                	mv	a7,a0
ffffffffc0208892:	8852                	mv	a6,s4
ffffffffc0208894:	87a2                	mv	a5,s0
ffffffffc0208896:	874a                	mv	a4,s2
ffffffffc0208898:	86ce                	mv	a3,s3
ffffffffc020889a:	00006617          	auipc	a2,0x6
ffffffffc020889e:	f4660613          	addi	a2,a2,-186 # ffffffffc020e7e0 <syscalls+0xee8>
ffffffffc02088a2:	03700593          	li	a1,55
ffffffffc02088a6:	00006517          	auipc	a0,0x6
ffffffffc02088aa:	f1a50513          	addi	a0,a0,-230 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc02088ae:	981f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02088b2 <dev_init_disk0>:
ffffffffc02088b2:	1101                	addi	sp,sp,-32
ffffffffc02088b4:	ec06                	sd	ra,24(sp)
ffffffffc02088b6:	e822                	sd	s0,16(sp)
ffffffffc02088b8:	e426                	sd	s1,8(sp)
ffffffffc02088ba:	496000ef          	jal	ra,ffffffffc0208d50 <dev_create_inode>
ffffffffc02088be:	c541                	beqz	a0,ffffffffc0208946 <dev_init_disk0+0x94>
ffffffffc02088c0:	4d38                	lw	a4,88(a0)
ffffffffc02088c2:	6485                	lui	s1,0x1
ffffffffc02088c4:	23448793          	addi	a5,s1,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02088c8:	842a                	mv	s0,a0
ffffffffc02088ca:	0cf71f63          	bne	a4,a5,ffffffffc02089a8 <dev_init_disk0+0xf6>
ffffffffc02088ce:	4509                	li	a0,2
ffffffffc02088d0:	b52f80ef          	jal	ra,ffffffffc0200c22 <ide_device_valid>
ffffffffc02088d4:	cd55                	beqz	a0,ffffffffc0208990 <dev_init_disk0+0xde>
ffffffffc02088d6:	4509                	li	a0,2
ffffffffc02088d8:	b6ef80ef          	jal	ra,ffffffffc0200c46 <ide_device_size>
ffffffffc02088dc:	00355793          	srli	a5,a0,0x3
ffffffffc02088e0:	e01c                	sd	a5,0(s0)
ffffffffc02088e2:	00000797          	auipc	a5,0x0
ffffffffc02088e6:	df078793          	addi	a5,a5,-528 # ffffffffc02086d2 <disk0_open>
ffffffffc02088ea:	e81c                	sd	a5,16(s0)
ffffffffc02088ec:	00000797          	auipc	a5,0x0
ffffffffc02088f0:	dea78793          	addi	a5,a5,-534 # ffffffffc02086d6 <disk0_close>
ffffffffc02088f4:	ec1c                	sd	a5,24(s0)
ffffffffc02088f6:	00000797          	auipc	a5,0x0
ffffffffc02088fa:	de878793          	addi	a5,a5,-536 # ffffffffc02086de <disk0_io>
ffffffffc02088fe:	f01c                	sd	a5,32(s0)
ffffffffc0208900:	00000797          	auipc	a5,0x0
ffffffffc0208904:	dda78793          	addi	a5,a5,-550 # ffffffffc02086da <disk0_ioctl>
ffffffffc0208908:	f41c                	sd	a5,40(s0)
ffffffffc020890a:	4585                	li	a1,1
ffffffffc020890c:	0008e517          	auipc	a0,0x8e
ffffffffc0208910:	f4450513          	addi	a0,a0,-188 # ffffffffc0296850 <disk0_sem>
ffffffffc0208914:	e404                	sd	s1,8(s0)
ffffffffc0208916:	e29fb0ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc020891a:	6511                	lui	a0,0x4
ffffffffc020891c:	ea7fa0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc0208920:	0008e797          	auipc	a5,0x8e
ffffffffc0208924:	fea7b423          	sd	a0,-24(a5) # ffffffffc0296908 <disk0_buffer>
ffffffffc0208928:	c921                	beqz	a0,ffffffffc0208978 <dev_init_disk0+0xc6>
ffffffffc020892a:	4605                	li	a2,1
ffffffffc020892c:	85a2                	mv	a1,s0
ffffffffc020892e:	00006517          	auipc	a0,0x6
ffffffffc0208932:	fda50513          	addi	a0,a0,-38 # ffffffffc020e908 <syscalls+0x1010>
ffffffffc0208936:	85cff0ef          	jal	ra,ffffffffc0207992 <vfs_add_dev>
ffffffffc020893a:	e115                	bnez	a0,ffffffffc020895e <dev_init_disk0+0xac>
ffffffffc020893c:	60e2                	ld	ra,24(sp)
ffffffffc020893e:	6442                	ld	s0,16(sp)
ffffffffc0208940:	64a2                	ld	s1,8(sp)
ffffffffc0208942:	6105                	addi	sp,sp,32
ffffffffc0208944:	8082                	ret
ffffffffc0208946:	00006617          	auipc	a2,0x6
ffffffffc020894a:	f6260613          	addi	a2,a2,-158 # ffffffffc020e8a8 <syscalls+0xfb0>
ffffffffc020894e:	08700593          	li	a1,135
ffffffffc0208952:	00006517          	auipc	a0,0x6
ffffffffc0208956:	e6e50513          	addi	a0,a0,-402 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc020895a:	8d5f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020895e:	86aa                	mv	a3,a0
ffffffffc0208960:	00006617          	auipc	a2,0x6
ffffffffc0208964:	fb060613          	addi	a2,a2,-80 # ffffffffc020e910 <syscalls+0x1018>
ffffffffc0208968:	08d00593          	li	a1,141
ffffffffc020896c:	00006517          	auipc	a0,0x6
ffffffffc0208970:	e5450513          	addi	a0,a0,-428 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc0208974:	8bbf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208978:	00006617          	auipc	a2,0x6
ffffffffc020897c:	f7060613          	addi	a2,a2,-144 # ffffffffc020e8e8 <syscalls+0xff0>
ffffffffc0208980:	07f00593          	li	a1,127
ffffffffc0208984:	00006517          	auipc	a0,0x6
ffffffffc0208988:	e3c50513          	addi	a0,a0,-452 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc020898c:	8a3f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208990:	00006617          	auipc	a2,0x6
ffffffffc0208994:	f3860613          	addi	a2,a2,-200 # ffffffffc020e8c8 <syscalls+0xfd0>
ffffffffc0208998:	07300593          	li	a1,115
ffffffffc020899c:	00006517          	auipc	a0,0x6
ffffffffc02089a0:	e2450513          	addi	a0,a0,-476 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc02089a4:	88bf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02089a8:	00006697          	auipc	a3,0x6
ffffffffc02089ac:	81868693          	addi	a3,a3,-2024 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc02089b0:	00003617          	auipc	a2,0x3
ffffffffc02089b4:	f6860613          	addi	a2,a2,-152 # ffffffffc020b918 <commands+0x250>
ffffffffc02089b8:	08900593          	li	a1,137
ffffffffc02089bc:	00006517          	auipc	a0,0x6
ffffffffc02089c0:	e0450513          	addi	a0,a0,-508 # ffffffffc020e7c0 <syscalls+0xec8>
ffffffffc02089c4:	86bf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02089c8 <stdout_open>:
ffffffffc02089c8:	4785                	li	a5,1
ffffffffc02089ca:	4501                	li	a0,0
ffffffffc02089cc:	00f59363          	bne	a1,a5,ffffffffc02089d2 <stdout_open+0xa>
ffffffffc02089d0:	8082                	ret
ffffffffc02089d2:	5575                	li	a0,-3
ffffffffc02089d4:	8082                	ret

ffffffffc02089d6 <stdout_close>:
ffffffffc02089d6:	4501                	li	a0,0
ffffffffc02089d8:	8082                	ret

ffffffffc02089da <stdout_ioctl>:
ffffffffc02089da:	5575                	li	a0,-3
ffffffffc02089dc:	8082                	ret

ffffffffc02089de <stdout_io>:
ffffffffc02089de:	ca05                	beqz	a2,ffffffffc0208a0e <stdout_io+0x30>
ffffffffc02089e0:	6d9c                	ld	a5,24(a1)
ffffffffc02089e2:	1101                	addi	sp,sp,-32
ffffffffc02089e4:	e822                	sd	s0,16(sp)
ffffffffc02089e6:	e426                	sd	s1,8(sp)
ffffffffc02089e8:	ec06                	sd	ra,24(sp)
ffffffffc02089ea:	6180                	ld	s0,0(a1)
ffffffffc02089ec:	84ae                	mv	s1,a1
ffffffffc02089ee:	cb91                	beqz	a5,ffffffffc0208a02 <stdout_io+0x24>
ffffffffc02089f0:	00044503          	lbu	a0,0(s0)
ffffffffc02089f4:	0405                	addi	s0,s0,1
ffffffffc02089f6:	f70f70ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc02089fa:	6c9c                	ld	a5,24(s1)
ffffffffc02089fc:	17fd                	addi	a5,a5,-1
ffffffffc02089fe:	ec9c                	sd	a5,24(s1)
ffffffffc0208a00:	fbe5                	bnez	a5,ffffffffc02089f0 <stdout_io+0x12>
ffffffffc0208a02:	60e2                	ld	ra,24(sp)
ffffffffc0208a04:	6442                	ld	s0,16(sp)
ffffffffc0208a06:	64a2                	ld	s1,8(sp)
ffffffffc0208a08:	4501                	li	a0,0
ffffffffc0208a0a:	6105                	addi	sp,sp,32
ffffffffc0208a0c:	8082                	ret
ffffffffc0208a0e:	5575                	li	a0,-3
ffffffffc0208a10:	8082                	ret

ffffffffc0208a12 <dev_init_stdout>:
ffffffffc0208a12:	1141                	addi	sp,sp,-16
ffffffffc0208a14:	e406                	sd	ra,8(sp)
ffffffffc0208a16:	33a000ef          	jal	ra,ffffffffc0208d50 <dev_create_inode>
ffffffffc0208a1a:	c939                	beqz	a0,ffffffffc0208a70 <dev_init_stdout+0x5e>
ffffffffc0208a1c:	4d38                	lw	a4,88(a0)
ffffffffc0208a1e:	6785                	lui	a5,0x1
ffffffffc0208a20:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208a24:	85aa                	mv	a1,a0
ffffffffc0208a26:	06f71e63          	bne	a4,a5,ffffffffc0208aa2 <dev_init_stdout+0x90>
ffffffffc0208a2a:	4785                	li	a5,1
ffffffffc0208a2c:	e51c                	sd	a5,8(a0)
ffffffffc0208a2e:	00000797          	auipc	a5,0x0
ffffffffc0208a32:	f9a78793          	addi	a5,a5,-102 # ffffffffc02089c8 <stdout_open>
ffffffffc0208a36:	e91c                	sd	a5,16(a0)
ffffffffc0208a38:	00000797          	auipc	a5,0x0
ffffffffc0208a3c:	f9e78793          	addi	a5,a5,-98 # ffffffffc02089d6 <stdout_close>
ffffffffc0208a40:	ed1c                	sd	a5,24(a0)
ffffffffc0208a42:	00000797          	auipc	a5,0x0
ffffffffc0208a46:	f9c78793          	addi	a5,a5,-100 # ffffffffc02089de <stdout_io>
ffffffffc0208a4a:	f11c                	sd	a5,32(a0)
ffffffffc0208a4c:	00000797          	auipc	a5,0x0
ffffffffc0208a50:	f8e78793          	addi	a5,a5,-114 # ffffffffc02089da <stdout_ioctl>
ffffffffc0208a54:	00053023          	sd	zero,0(a0)
ffffffffc0208a58:	f51c                	sd	a5,40(a0)
ffffffffc0208a5a:	4601                	li	a2,0
ffffffffc0208a5c:	00006517          	auipc	a0,0x6
ffffffffc0208a60:	f1450513          	addi	a0,a0,-236 # ffffffffc020e970 <syscalls+0x1078>
ffffffffc0208a64:	f2ffe0ef          	jal	ra,ffffffffc0207992 <vfs_add_dev>
ffffffffc0208a68:	e105                	bnez	a0,ffffffffc0208a88 <dev_init_stdout+0x76>
ffffffffc0208a6a:	60a2                	ld	ra,8(sp)
ffffffffc0208a6c:	0141                	addi	sp,sp,16
ffffffffc0208a6e:	8082                	ret
ffffffffc0208a70:	00006617          	auipc	a2,0x6
ffffffffc0208a74:	ec060613          	addi	a2,a2,-320 # ffffffffc020e930 <syscalls+0x1038>
ffffffffc0208a78:	03700593          	li	a1,55
ffffffffc0208a7c:	00006517          	auipc	a0,0x6
ffffffffc0208a80:	ed450513          	addi	a0,a0,-300 # ffffffffc020e950 <syscalls+0x1058>
ffffffffc0208a84:	faaf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208a88:	86aa                	mv	a3,a0
ffffffffc0208a8a:	00006617          	auipc	a2,0x6
ffffffffc0208a8e:	eee60613          	addi	a2,a2,-274 # ffffffffc020e978 <syscalls+0x1080>
ffffffffc0208a92:	03d00593          	li	a1,61
ffffffffc0208a96:	00006517          	auipc	a0,0x6
ffffffffc0208a9a:	eba50513          	addi	a0,a0,-326 # ffffffffc020e950 <syscalls+0x1058>
ffffffffc0208a9e:	f90f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208aa2:	00005697          	auipc	a3,0x5
ffffffffc0208aa6:	71e68693          	addi	a3,a3,1822 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208aaa:	00003617          	auipc	a2,0x3
ffffffffc0208aae:	e6e60613          	addi	a2,a2,-402 # ffffffffc020b918 <commands+0x250>
ffffffffc0208ab2:	03900593          	li	a1,57
ffffffffc0208ab6:	00006517          	auipc	a0,0x6
ffffffffc0208aba:	e9a50513          	addi	a0,a0,-358 # ffffffffc020e950 <syscalls+0x1058>
ffffffffc0208abe:	f70f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208ac2 <dev_lookup>:
ffffffffc0208ac2:	0005c783          	lbu	a5,0(a1) # ffffffff80000000 <_binary_bin_sfs_img_size+0xffffffff7ff8ad00>
ffffffffc0208ac6:	e385                	bnez	a5,ffffffffc0208ae6 <dev_lookup+0x24>
ffffffffc0208ac8:	1101                	addi	sp,sp,-32
ffffffffc0208aca:	e822                	sd	s0,16(sp)
ffffffffc0208acc:	e426                	sd	s1,8(sp)
ffffffffc0208ace:	ec06                	sd	ra,24(sp)
ffffffffc0208ad0:	84aa                	mv	s1,a0
ffffffffc0208ad2:	8432                	mv	s0,a2
ffffffffc0208ad4:	c34ff0ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc0208ad8:	60e2                	ld	ra,24(sp)
ffffffffc0208ada:	e004                	sd	s1,0(s0)
ffffffffc0208adc:	6442                	ld	s0,16(sp)
ffffffffc0208ade:	64a2                	ld	s1,8(sp)
ffffffffc0208ae0:	4501                	li	a0,0
ffffffffc0208ae2:	6105                	addi	sp,sp,32
ffffffffc0208ae4:	8082                	ret
ffffffffc0208ae6:	5541                	li	a0,-16
ffffffffc0208ae8:	8082                	ret

ffffffffc0208aea <dev_fstat>:
ffffffffc0208aea:	1101                	addi	sp,sp,-32
ffffffffc0208aec:	e426                	sd	s1,8(sp)
ffffffffc0208aee:	84ae                	mv	s1,a1
ffffffffc0208af0:	e822                	sd	s0,16(sp)
ffffffffc0208af2:	02000613          	li	a2,32
ffffffffc0208af6:	842a                	mv	s0,a0
ffffffffc0208af8:	4581                	li	a1,0
ffffffffc0208afa:	8526                	mv	a0,s1
ffffffffc0208afc:	ec06                	sd	ra,24(sp)
ffffffffc0208afe:	422020ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0208b02:	c429                	beqz	s0,ffffffffc0208b4c <dev_fstat+0x62>
ffffffffc0208b04:	783c                	ld	a5,112(s0)
ffffffffc0208b06:	c3b9                	beqz	a5,ffffffffc0208b4c <dev_fstat+0x62>
ffffffffc0208b08:	6bbc                	ld	a5,80(a5)
ffffffffc0208b0a:	c3a9                	beqz	a5,ffffffffc0208b4c <dev_fstat+0x62>
ffffffffc0208b0c:	00005597          	auipc	a1,0x5
ffffffffc0208b10:	77c58593          	addi	a1,a1,1916 # ffffffffc020e288 <syscalls+0x990>
ffffffffc0208b14:	8522                	mv	a0,s0
ffffffffc0208b16:	c0aff0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0208b1a:	783c                	ld	a5,112(s0)
ffffffffc0208b1c:	85a6                	mv	a1,s1
ffffffffc0208b1e:	8522                	mv	a0,s0
ffffffffc0208b20:	6bbc                	ld	a5,80(a5)
ffffffffc0208b22:	9782                	jalr	a5
ffffffffc0208b24:	ed19                	bnez	a0,ffffffffc0208b42 <dev_fstat+0x58>
ffffffffc0208b26:	4c38                	lw	a4,88(s0)
ffffffffc0208b28:	6785                	lui	a5,0x1
ffffffffc0208b2a:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208b2e:	02f71f63          	bne	a4,a5,ffffffffc0208b6c <dev_fstat+0x82>
ffffffffc0208b32:	6018                	ld	a4,0(s0)
ffffffffc0208b34:	641c                	ld	a5,8(s0)
ffffffffc0208b36:	4685                	li	a3,1
ffffffffc0208b38:	e494                	sd	a3,8(s1)
ffffffffc0208b3a:	02e787b3          	mul	a5,a5,a4
ffffffffc0208b3e:	e898                	sd	a4,16(s1)
ffffffffc0208b40:	ec9c                	sd	a5,24(s1)
ffffffffc0208b42:	60e2                	ld	ra,24(sp)
ffffffffc0208b44:	6442                	ld	s0,16(sp)
ffffffffc0208b46:	64a2                	ld	s1,8(sp)
ffffffffc0208b48:	6105                	addi	sp,sp,32
ffffffffc0208b4a:	8082                	ret
ffffffffc0208b4c:	00005697          	auipc	a3,0x5
ffffffffc0208b50:	6d468693          	addi	a3,a3,1748 # ffffffffc020e220 <syscalls+0x928>
ffffffffc0208b54:	00003617          	auipc	a2,0x3
ffffffffc0208b58:	dc460613          	addi	a2,a2,-572 # ffffffffc020b918 <commands+0x250>
ffffffffc0208b5c:	04200593          	li	a1,66
ffffffffc0208b60:	00006517          	auipc	a0,0x6
ffffffffc0208b64:	e3850513          	addi	a0,a0,-456 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208b68:	ec6f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208b6c:	00005697          	auipc	a3,0x5
ffffffffc0208b70:	65468693          	addi	a3,a3,1620 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208b74:	00003617          	auipc	a2,0x3
ffffffffc0208b78:	da460613          	addi	a2,a2,-604 # ffffffffc020b918 <commands+0x250>
ffffffffc0208b7c:	04500593          	li	a1,69
ffffffffc0208b80:	00006517          	auipc	a0,0x6
ffffffffc0208b84:	e1850513          	addi	a0,a0,-488 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208b88:	ea6f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208b8c <dev_ioctl>:
ffffffffc0208b8c:	c909                	beqz	a0,ffffffffc0208b9e <dev_ioctl+0x12>
ffffffffc0208b8e:	4d34                	lw	a3,88(a0)
ffffffffc0208b90:	6705                	lui	a4,0x1
ffffffffc0208b92:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208b96:	00e69463          	bne	a3,a4,ffffffffc0208b9e <dev_ioctl+0x12>
ffffffffc0208b9a:	751c                	ld	a5,40(a0)
ffffffffc0208b9c:	8782                	jr	a5
ffffffffc0208b9e:	1141                	addi	sp,sp,-16
ffffffffc0208ba0:	00005697          	auipc	a3,0x5
ffffffffc0208ba4:	62068693          	addi	a3,a3,1568 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208ba8:	00003617          	auipc	a2,0x3
ffffffffc0208bac:	d7060613          	addi	a2,a2,-656 # ffffffffc020b918 <commands+0x250>
ffffffffc0208bb0:	03500593          	li	a1,53
ffffffffc0208bb4:	00006517          	auipc	a0,0x6
ffffffffc0208bb8:	de450513          	addi	a0,a0,-540 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208bbc:	e406                	sd	ra,8(sp)
ffffffffc0208bbe:	e70f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208bc2 <dev_tryseek>:
ffffffffc0208bc2:	c51d                	beqz	a0,ffffffffc0208bf0 <dev_tryseek+0x2e>
ffffffffc0208bc4:	4d38                	lw	a4,88(a0)
ffffffffc0208bc6:	6785                	lui	a5,0x1
ffffffffc0208bc8:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208bcc:	02f71263          	bne	a4,a5,ffffffffc0208bf0 <dev_tryseek+0x2e>
ffffffffc0208bd0:	611c                	ld	a5,0(a0)
ffffffffc0208bd2:	cf89                	beqz	a5,ffffffffc0208bec <dev_tryseek+0x2a>
ffffffffc0208bd4:	6518                	ld	a4,8(a0)
ffffffffc0208bd6:	02e5f6b3          	remu	a3,a1,a4
ffffffffc0208bda:	ea89                	bnez	a3,ffffffffc0208bec <dev_tryseek+0x2a>
ffffffffc0208bdc:	0005c863          	bltz	a1,ffffffffc0208bec <dev_tryseek+0x2a>
ffffffffc0208be0:	02e787b3          	mul	a5,a5,a4
ffffffffc0208be4:	00f5f463          	bgeu	a1,a5,ffffffffc0208bec <dev_tryseek+0x2a>
ffffffffc0208be8:	4501                	li	a0,0
ffffffffc0208bea:	8082                	ret
ffffffffc0208bec:	5575                	li	a0,-3
ffffffffc0208bee:	8082                	ret
ffffffffc0208bf0:	1141                	addi	sp,sp,-16
ffffffffc0208bf2:	00005697          	auipc	a3,0x5
ffffffffc0208bf6:	5ce68693          	addi	a3,a3,1486 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208bfa:	00003617          	auipc	a2,0x3
ffffffffc0208bfe:	d1e60613          	addi	a2,a2,-738 # ffffffffc020b918 <commands+0x250>
ffffffffc0208c02:	05f00593          	li	a1,95
ffffffffc0208c06:	00006517          	auipc	a0,0x6
ffffffffc0208c0a:	d9250513          	addi	a0,a0,-622 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208c0e:	e406                	sd	ra,8(sp)
ffffffffc0208c10:	e1ef70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208c14 <dev_gettype>:
ffffffffc0208c14:	c10d                	beqz	a0,ffffffffc0208c36 <dev_gettype+0x22>
ffffffffc0208c16:	4d38                	lw	a4,88(a0)
ffffffffc0208c18:	6785                	lui	a5,0x1
ffffffffc0208c1a:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208c1e:	00f71c63          	bne	a4,a5,ffffffffc0208c36 <dev_gettype+0x22>
ffffffffc0208c22:	6118                	ld	a4,0(a0)
ffffffffc0208c24:	6795                	lui	a5,0x5
ffffffffc0208c26:	c701                	beqz	a4,ffffffffc0208c2e <dev_gettype+0x1a>
ffffffffc0208c28:	c19c                	sw	a5,0(a1)
ffffffffc0208c2a:	4501                	li	a0,0
ffffffffc0208c2c:	8082                	ret
ffffffffc0208c2e:	6791                	lui	a5,0x4
ffffffffc0208c30:	c19c                	sw	a5,0(a1)
ffffffffc0208c32:	4501                	li	a0,0
ffffffffc0208c34:	8082                	ret
ffffffffc0208c36:	1141                	addi	sp,sp,-16
ffffffffc0208c38:	00005697          	auipc	a3,0x5
ffffffffc0208c3c:	58868693          	addi	a3,a3,1416 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208c40:	00003617          	auipc	a2,0x3
ffffffffc0208c44:	cd860613          	addi	a2,a2,-808 # ffffffffc020b918 <commands+0x250>
ffffffffc0208c48:	05300593          	li	a1,83
ffffffffc0208c4c:	00006517          	auipc	a0,0x6
ffffffffc0208c50:	d4c50513          	addi	a0,a0,-692 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208c54:	e406                	sd	ra,8(sp)
ffffffffc0208c56:	dd8f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208c5a <dev_write>:
ffffffffc0208c5a:	c911                	beqz	a0,ffffffffc0208c6e <dev_write+0x14>
ffffffffc0208c5c:	4d34                	lw	a3,88(a0)
ffffffffc0208c5e:	6705                	lui	a4,0x1
ffffffffc0208c60:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208c64:	00e69563          	bne	a3,a4,ffffffffc0208c6e <dev_write+0x14>
ffffffffc0208c68:	711c                	ld	a5,32(a0)
ffffffffc0208c6a:	4605                	li	a2,1
ffffffffc0208c6c:	8782                	jr	a5
ffffffffc0208c6e:	1141                	addi	sp,sp,-16
ffffffffc0208c70:	00005697          	auipc	a3,0x5
ffffffffc0208c74:	55068693          	addi	a3,a3,1360 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208c78:	00003617          	auipc	a2,0x3
ffffffffc0208c7c:	ca060613          	addi	a2,a2,-864 # ffffffffc020b918 <commands+0x250>
ffffffffc0208c80:	02c00593          	li	a1,44
ffffffffc0208c84:	00006517          	auipc	a0,0x6
ffffffffc0208c88:	d1450513          	addi	a0,a0,-748 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208c8c:	e406                	sd	ra,8(sp)
ffffffffc0208c8e:	da0f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208c92 <dev_read>:
ffffffffc0208c92:	c911                	beqz	a0,ffffffffc0208ca6 <dev_read+0x14>
ffffffffc0208c94:	4d34                	lw	a3,88(a0)
ffffffffc0208c96:	6705                	lui	a4,0x1
ffffffffc0208c98:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208c9c:	00e69563          	bne	a3,a4,ffffffffc0208ca6 <dev_read+0x14>
ffffffffc0208ca0:	711c                	ld	a5,32(a0)
ffffffffc0208ca2:	4601                	li	a2,0
ffffffffc0208ca4:	8782                	jr	a5
ffffffffc0208ca6:	1141                	addi	sp,sp,-16
ffffffffc0208ca8:	00005697          	auipc	a3,0x5
ffffffffc0208cac:	51868693          	addi	a3,a3,1304 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208cb0:	00003617          	auipc	a2,0x3
ffffffffc0208cb4:	c6860613          	addi	a2,a2,-920 # ffffffffc020b918 <commands+0x250>
ffffffffc0208cb8:	02300593          	li	a1,35
ffffffffc0208cbc:	00006517          	auipc	a0,0x6
ffffffffc0208cc0:	cdc50513          	addi	a0,a0,-804 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208cc4:	e406                	sd	ra,8(sp)
ffffffffc0208cc6:	d68f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208cca <dev_close>:
ffffffffc0208cca:	c909                	beqz	a0,ffffffffc0208cdc <dev_close+0x12>
ffffffffc0208ccc:	4d34                	lw	a3,88(a0)
ffffffffc0208cce:	6705                	lui	a4,0x1
ffffffffc0208cd0:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208cd4:	00e69463          	bne	a3,a4,ffffffffc0208cdc <dev_close+0x12>
ffffffffc0208cd8:	6d1c                	ld	a5,24(a0)
ffffffffc0208cda:	8782                	jr	a5
ffffffffc0208cdc:	1141                	addi	sp,sp,-16
ffffffffc0208cde:	00005697          	auipc	a3,0x5
ffffffffc0208ce2:	4e268693          	addi	a3,a3,1250 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208ce6:	00003617          	auipc	a2,0x3
ffffffffc0208cea:	c3260613          	addi	a2,a2,-974 # ffffffffc020b918 <commands+0x250>
ffffffffc0208cee:	45e9                	li	a1,26
ffffffffc0208cf0:	00006517          	auipc	a0,0x6
ffffffffc0208cf4:	ca850513          	addi	a0,a0,-856 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208cf8:	e406                	sd	ra,8(sp)
ffffffffc0208cfa:	d34f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208cfe <dev_open>:
ffffffffc0208cfe:	03c5f713          	andi	a4,a1,60
ffffffffc0208d02:	eb11                	bnez	a4,ffffffffc0208d16 <dev_open+0x18>
ffffffffc0208d04:	c919                	beqz	a0,ffffffffc0208d1a <dev_open+0x1c>
ffffffffc0208d06:	4d34                	lw	a3,88(a0)
ffffffffc0208d08:	6705                	lui	a4,0x1
ffffffffc0208d0a:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d0e:	00e69663          	bne	a3,a4,ffffffffc0208d1a <dev_open+0x1c>
ffffffffc0208d12:	691c                	ld	a5,16(a0)
ffffffffc0208d14:	8782                	jr	a5
ffffffffc0208d16:	5575                	li	a0,-3
ffffffffc0208d18:	8082                	ret
ffffffffc0208d1a:	1141                	addi	sp,sp,-16
ffffffffc0208d1c:	00005697          	auipc	a3,0x5
ffffffffc0208d20:	4a468693          	addi	a3,a3,1188 # ffffffffc020e1c0 <syscalls+0x8c8>
ffffffffc0208d24:	00003617          	auipc	a2,0x3
ffffffffc0208d28:	bf460613          	addi	a2,a2,-1036 # ffffffffc020b918 <commands+0x250>
ffffffffc0208d2c:	45c5                	li	a1,17
ffffffffc0208d2e:	00006517          	auipc	a0,0x6
ffffffffc0208d32:	c6a50513          	addi	a0,a0,-918 # ffffffffc020e998 <syscalls+0x10a0>
ffffffffc0208d36:	e406                	sd	ra,8(sp)
ffffffffc0208d38:	cf6f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208d3c <dev_init>:
ffffffffc0208d3c:	1141                	addi	sp,sp,-16
ffffffffc0208d3e:	e406                	sd	ra,8(sp)
ffffffffc0208d40:	8c1ff0ef          	jal	ra,ffffffffc0208600 <dev_init_stdin>
ffffffffc0208d44:	ccfff0ef          	jal	ra,ffffffffc0208a12 <dev_init_stdout>
ffffffffc0208d48:	60a2                	ld	ra,8(sp)
ffffffffc0208d4a:	0141                	addi	sp,sp,16
ffffffffc0208d4c:	b67ff06f          	j	ffffffffc02088b2 <dev_init_disk0>

ffffffffc0208d50 <dev_create_inode>:
ffffffffc0208d50:	6505                	lui	a0,0x1
ffffffffc0208d52:	1141                	addi	sp,sp,-16
ffffffffc0208d54:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d58:	e022                	sd	s0,0(sp)
ffffffffc0208d5a:	e406                	sd	ra,8(sp)
ffffffffc0208d5c:	92eff0ef          	jal	ra,ffffffffc0207e8a <__alloc_inode>
ffffffffc0208d60:	842a                	mv	s0,a0
ffffffffc0208d62:	c901                	beqz	a0,ffffffffc0208d72 <dev_create_inode+0x22>
ffffffffc0208d64:	4601                	li	a2,0
ffffffffc0208d66:	00006597          	auipc	a1,0x6
ffffffffc0208d6a:	c4a58593          	addi	a1,a1,-950 # ffffffffc020e9b0 <dev_node_ops>
ffffffffc0208d6e:	938ff0ef          	jal	ra,ffffffffc0207ea6 <inode_init>
ffffffffc0208d72:	60a2                	ld	ra,8(sp)
ffffffffc0208d74:	8522                	mv	a0,s0
ffffffffc0208d76:	6402                	ld	s0,0(sp)
ffffffffc0208d78:	0141                	addi	sp,sp,16
ffffffffc0208d7a:	8082                	ret

ffffffffc0208d7c <sfs_init>:
ffffffffc0208d7c:	1141                	addi	sp,sp,-16
ffffffffc0208d7e:	00006517          	auipc	a0,0x6
ffffffffc0208d82:	b8a50513          	addi	a0,a0,-1142 # ffffffffc020e908 <syscalls+0x1010>
ffffffffc0208d86:	e406                	sd	ra,8(sp)
ffffffffc0208d88:	0bd000ef          	jal	ra,ffffffffc0209644 <sfs_mount>
ffffffffc0208d8c:	e501                	bnez	a0,ffffffffc0208d94 <sfs_init+0x18>
ffffffffc0208d8e:	60a2                	ld	ra,8(sp)
ffffffffc0208d90:	0141                	addi	sp,sp,16
ffffffffc0208d92:	8082                	ret
ffffffffc0208d94:	86aa                	mv	a3,a0
ffffffffc0208d96:	00006617          	auipc	a2,0x6
ffffffffc0208d9a:	c9a60613          	addi	a2,a2,-870 # ffffffffc020ea30 <dev_node_ops+0x80>
ffffffffc0208d9e:	45c1                	li	a1,16
ffffffffc0208da0:	00006517          	auipc	a0,0x6
ffffffffc0208da4:	cb050513          	addi	a0,a0,-848 # ffffffffc020ea50 <dev_node_ops+0xa0>
ffffffffc0208da8:	c86f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208dac <sfs_rwblock_nolock>:
ffffffffc0208dac:	7139                	addi	sp,sp,-64
ffffffffc0208dae:	f822                	sd	s0,48(sp)
ffffffffc0208db0:	f426                	sd	s1,40(sp)
ffffffffc0208db2:	fc06                	sd	ra,56(sp)
ffffffffc0208db4:	842a                	mv	s0,a0
ffffffffc0208db6:	84b6                	mv	s1,a3
ffffffffc0208db8:	e211                	bnez	a2,ffffffffc0208dbc <sfs_rwblock_nolock+0x10>
ffffffffc0208dba:	e715                	bnez	a4,ffffffffc0208de6 <sfs_rwblock_nolock+0x3a>
ffffffffc0208dbc:	405c                	lw	a5,4(s0)
ffffffffc0208dbe:	02f67463          	bgeu	a2,a5,ffffffffc0208de6 <sfs_rwblock_nolock+0x3a>
ffffffffc0208dc2:	00c6169b          	slliw	a3,a2,0xc
ffffffffc0208dc6:	1682                	slli	a3,a3,0x20
ffffffffc0208dc8:	6605                	lui	a2,0x1
ffffffffc0208dca:	9281                	srli	a3,a3,0x20
ffffffffc0208dcc:	850a                	mv	a0,sp
ffffffffc0208dce:	95ffc0ef          	jal	ra,ffffffffc020572c <iobuf_init>
ffffffffc0208dd2:	85aa                	mv	a1,a0
ffffffffc0208dd4:	7808                	ld	a0,48(s0)
ffffffffc0208dd6:	8626                	mv	a2,s1
ffffffffc0208dd8:	7118                	ld	a4,32(a0)
ffffffffc0208dda:	9702                	jalr	a4
ffffffffc0208ddc:	70e2                	ld	ra,56(sp)
ffffffffc0208dde:	7442                	ld	s0,48(sp)
ffffffffc0208de0:	74a2                	ld	s1,40(sp)
ffffffffc0208de2:	6121                	addi	sp,sp,64
ffffffffc0208de4:	8082                	ret
ffffffffc0208de6:	00006697          	auipc	a3,0x6
ffffffffc0208dea:	c8268693          	addi	a3,a3,-894 # ffffffffc020ea68 <dev_node_ops+0xb8>
ffffffffc0208dee:	00003617          	auipc	a2,0x3
ffffffffc0208df2:	b2a60613          	addi	a2,a2,-1238 # ffffffffc020b918 <commands+0x250>
ffffffffc0208df6:	45d5                	li	a1,21
ffffffffc0208df8:	00006517          	auipc	a0,0x6
ffffffffc0208dfc:	ca850513          	addi	a0,a0,-856 # ffffffffc020eaa0 <dev_node_ops+0xf0>
ffffffffc0208e00:	c2ef70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208e04 <sfs_rblock>:
ffffffffc0208e04:	7139                	addi	sp,sp,-64
ffffffffc0208e06:	ec4e                	sd	s3,24(sp)
ffffffffc0208e08:	89b6                	mv	s3,a3
ffffffffc0208e0a:	f822                	sd	s0,48(sp)
ffffffffc0208e0c:	f04a                	sd	s2,32(sp)
ffffffffc0208e0e:	e852                	sd	s4,16(sp)
ffffffffc0208e10:	fc06                	sd	ra,56(sp)
ffffffffc0208e12:	f426                	sd	s1,40(sp)
ffffffffc0208e14:	e456                	sd	s5,8(sp)
ffffffffc0208e16:	8a2a                	mv	s4,a0
ffffffffc0208e18:	892e                	mv	s2,a1
ffffffffc0208e1a:	8432                	mv	s0,a2
ffffffffc0208e1c:	2e0000ef          	jal	ra,ffffffffc02090fc <lock_sfs_io>
ffffffffc0208e20:	04098063          	beqz	s3,ffffffffc0208e60 <sfs_rblock+0x5c>
ffffffffc0208e24:	013409bb          	addw	s3,s0,s3
ffffffffc0208e28:	6a85                	lui	s5,0x1
ffffffffc0208e2a:	a021                	j	ffffffffc0208e32 <sfs_rblock+0x2e>
ffffffffc0208e2c:	9956                	add	s2,s2,s5
ffffffffc0208e2e:	02898963          	beq	s3,s0,ffffffffc0208e60 <sfs_rblock+0x5c>
ffffffffc0208e32:	8622                	mv	a2,s0
ffffffffc0208e34:	85ca                	mv	a1,s2
ffffffffc0208e36:	4705                	li	a4,1
ffffffffc0208e38:	4681                	li	a3,0
ffffffffc0208e3a:	8552                	mv	a0,s4
ffffffffc0208e3c:	f71ff0ef          	jal	ra,ffffffffc0208dac <sfs_rwblock_nolock>
ffffffffc0208e40:	84aa                	mv	s1,a0
ffffffffc0208e42:	2405                	addiw	s0,s0,1
ffffffffc0208e44:	d565                	beqz	a0,ffffffffc0208e2c <sfs_rblock+0x28>
ffffffffc0208e46:	8552                	mv	a0,s4
ffffffffc0208e48:	2c4000ef          	jal	ra,ffffffffc020910c <unlock_sfs_io>
ffffffffc0208e4c:	70e2                	ld	ra,56(sp)
ffffffffc0208e4e:	7442                	ld	s0,48(sp)
ffffffffc0208e50:	7902                	ld	s2,32(sp)
ffffffffc0208e52:	69e2                	ld	s3,24(sp)
ffffffffc0208e54:	6a42                	ld	s4,16(sp)
ffffffffc0208e56:	6aa2                	ld	s5,8(sp)
ffffffffc0208e58:	8526                	mv	a0,s1
ffffffffc0208e5a:	74a2                	ld	s1,40(sp)
ffffffffc0208e5c:	6121                	addi	sp,sp,64
ffffffffc0208e5e:	8082                	ret
ffffffffc0208e60:	4481                	li	s1,0
ffffffffc0208e62:	b7d5                	j	ffffffffc0208e46 <sfs_rblock+0x42>

ffffffffc0208e64 <sfs_wblock>:
ffffffffc0208e64:	7139                	addi	sp,sp,-64
ffffffffc0208e66:	ec4e                	sd	s3,24(sp)
ffffffffc0208e68:	89b6                	mv	s3,a3
ffffffffc0208e6a:	f822                	sd	s0,48(sp)
ffffffffc0208e6c:	f04a                	sd	s2,32(sp)
ffffffffc0208e6e:	e852                	sd	s4,16(sp)
ffffffffc0208e70:	fc06                	sd	ra,56(sp)
ffffffffc0208e72:	f426                	sd	s1,40(sp)
ffffffffc0208e74:	e456                	sd	s5,8(sp)
ffffffffc0208e76:	8a2a                	mv	s4,a0
ffffffffc0208e78:	892e                	mv	s2,a1
ffffffffc0208e7a:	8432                	mv	s0,a2
ffffffffc0208e7c:	280000ef          	jal	ra,ffffffffc02090fc <lock_sfs_io>
ffffffffc0208e80:	04098063          	beqz	s3,ffffffffc0208ec0 <sfs_wblock+0x5c>
ffffffffc0208e84:	013409bb          	addw	s3,s0,s3
ffffffffc0208e88:	6a85                	lui	s5,0x1
ffffffffc0208e8a:	a021                	j	ffffffffc0208e92 <sfs_wblock+0x2e>
ffffffffc0208e8c:	9956                	add	s2,s2,s5
ffffffffc0208e8e:	02898963          	beq	s3,s0,ffffffffc0208ec0 <sfs_wblock+0x5c>
ffffffffc0208e92:	8622                	mv	a2,s0
ffffffffc0208e94:	85ca                	mv	a1,s2
ffffffffc0208e96:	4705                	li	a4,1
ffffffffc0208e98:	4685                	li	a3,1
ffffffffc0208e9a:	8552                	mv	a0,s4
ffffffffc0208e9c:	f11ff0ef          	jal	ra,ffffffffc0208dac <sfs_rwblock_nolock>
ffffffffc0208ea0:	84aa                	mv	s1,a0
ffffffffc0208ea2:	2405                	addiw	s0,s0,1
ffffffffc0208ea4:	d565                	beqz	a0,ffffffffc0208e8c <sfs_wblock+0x28>
ffffffffc0208ea6:	8552                	mv	a0,s4
ffffffffc0208ea8:	264000ef          	jal	ra,ffffffffc020910c <unlock_sfs_io>
ffffffffc0208eac:	70e2                	ld	ra,56(sp)
ffffffffc0208eae:	7442                	ld	s0,48(sp)
ffffffffc0208eb0:	7902                	ld	s2,32(sp)
ffffffffc0208eb2:	69e2                	ld	s3,24(sp)
ffffffffc0208eb4:	6a42                	ld	s4,16(sp)
ffffffffc0208eb6:	6aa2                	ld	s5,8(sp)
ffffffffc0208eb8:	8526                	mv	a0,s1
ffffffffc0208eba:	74a2                	ld	s1,40(sp)
ffffffffc0208ebc:	6121                	addi	sp,sp,64
ffffffffc0208ebe:	8082                	ret
ffffffffc0208ec0:	4481                	li	s1,0
ffffffffc0208ec2:	b7d5                	j	ffffffffc0208ea6 <sfs_wblock+0x42>

ffffffffc0208ec4 <sfs_rbuf>:
ffffffffc0208ec4:	7179                	addi	sp,sp,-48
ffffffffc0208ec6:	f406                	sd	ra,40(sp)
ffffffffc0208ec8:	f022                	sd	s0,32(sp)
ffffffffc0208eca:	ec26                	sd	s1,24(sp)
ffffffffc0208ecc:	e84a                	sd	s2,16(sp)
ffffffffc0208ece:	e44e                	sd	s3,8(sp)
ffffffffc0208ed0:	e052                	sd	s4,0(sp)
ffffffffc0208ed2:	6785                	lui	a5,0x1
ffffffffc0208ed4:	04f77863          	bgeu	a4,a5,ffffffffc0208f24 <sfs_rbuf+0x60>
ffffffffc0208ed8:	84ba                	mv	s1,a4
ffffffffc0208eda:	9732                	add	a4,a4,a2
ffffffffc0208edc:	89b2                	mv	s3,a2
ffffffffc0208ede:	04e7e363          	bltu	a5,a4,ffffffffc0208f24 <sfs_rbuf+0x60>
ffffffffc0208ee2:	8936                	mv	s2,a3
ffffffffc0208ee4:	842a                	mv	s0,a0
ffffffffc0208ee6:	8a2e                	mv	s4,a1
ffffffffc0208ee8:	214000ef          	jal	ra,ffffffffc02090fc <lock_sfs_io>
ffffffffc0208eec:	642c                	ld	a1,72(s0)
ffffffffc0208eee:	864a                	mv	a2,s2
ffffffffc0208ef0:	4705                	li	a4,1
ffffffffc0208ef2:	4681                	li	a3,0
ffffffffc0208ef4:	8522                	mv	a0,s0
ffffffffc0208ef6:	eb7ff0ef          	jal	ra,ffffffffc0208dac <sfs_rwblock_nolock>
ffffffffc0208efa:	892a                	mv	s2,a0
ffffffffc0208efc:	cd09                	beqz	a0,ffffffffc0208f16 <sfs_rbuf+0x52>
ffffffffc0208efe:	8522                	mv	a0,s0
ffffffffc0208f00:	20c000ef          	jal	ra,ffffffffc020910c <unlock_sfs_io>
ffffffffc0208f04:	70a2                	ld	ra,40(sp)
ffffffffc0208f06:	7402                	ld	s0,32(sp)
ffffffffc0208f08:	64e2                	ld	s1,24(sp)
ffffffffc0208f0a:	69a2                	ld	s3,8(sp)
ffffffffc0208f0c:	6a02                	ld	s4,0(sp)
ffffffffc0208f0e:	854a                	mv	a0,s2
ffffffffc0208f10:	6942                	ld	s2,16(sp)
ffffffffc0208f12:	6145                	addi	sp,sp,48
ffffffffc0208f14:	8082                	ret
ffffffffc0208f16:	642c                	ld	a1,72(s0)
ffffffffc0208f18:	864e                	mv	a2,s3
ffffffffc0208f1a:	8552                	mv	a0,s4
ffffffffc0208f1c:	95a6                	add	a1,a1,s1
ffffffffc0208f1e:	054020ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0208f22:	bff1                	j	ffffffffc0208efe <sfs_rbuf+0x3a>
ffffffffc0208f24:	00006697          	auipc	a3,0x6
ffffffffc0208f28:	b9468693          	addi	a3,a3,-1132 # ffffffffc020eab8 <dev_node_ops+0x108>
ffffffffc0208f2c:	00003617          	auipc	a2,0x3
ffffffffc0208f30:	9ec60613          	addi	a2,a2,-1556 # ffffffffc020b918 <commands+0x250>
ffffffffc0208f34:	05500593          	li	a1,85
ffffffffc0208f38:	00006517          	auipc	a0,0x6
ffffffffc0208f3c:	b6850513          	addi	a0,a0,-1176 # ffffffffc020eaa0 <dev_node_ops+0xf0>
ffffffffc0208f40:	aeef70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208f44 <sfs_wbuf>:
ffffffffc0208f44:	7139                	addi	sp,sp,-64
ffffffffc0208f46:	fc06                	sd	ra,56(sp)
ffffffffc0208f48:	f822                	sd	s0,48(sp)
ffffffffc0208f4a:	f426                	sd	s1,40(sp)
ffffffffc0208f4c:	f04a                	sd	s2,32(sp)
ffffffffc0208f4e:	ec4e                	sd	s3,24(sp)
ffffffffc0208f50:	e852                	sd	s4,16(sp)
ffffffffc0208f52:	e456                	sd	s5,8(sp)
ffffffffc0208f54:	6785                	lui	a5,0x1
ffffffffc0208f56:	06f77163          	bgeu	a4,a5,ffffffffc0208fb8 <sfs_wbuf+0x74>
ffffffffc0208f5a:	893a                	mv	s2,a4
ffffffffc0208f5c:	9732                	add	a4,a4,a2
ffffffffc0208f5e:	8a32                	mv	s4,a2
ffffffffc0208f60:	04e7ec63          	bltu	a5,a4,ffffffffc0208fb8 <sfs_wbuf+0x74>
ffffffffc0208f64:	842a                	mv	s0,a0
ffffffffc0208f66:	89b6                	mv	s3,a3
ffffffffc0208f68:	8aae                	mv	s5,a1
ffffffffc0208f6a:	192000ef          	jal	ra,ffffffffc02090fc <lock_sfs_io>
ffffffffc0208f6e:	642c                	ld	a1,72(s0)
ffffffffc0208f70:	4705                	li	a4,1
ffffffffc0208f72:	4681                	li	a3,0
ffffffffc0208f74:	864e                	mv	a2,s3
ffffffffc0208f76:	8522                	mv	a0,s0
ffffffffc0208f78:	e35ff0ef          	jal	ra,ffffffffc0208dac <sfs_rwblock_nolock>
ffffffffc0208f7c:	84aa                	mv	s1,a0
ffffffffc0208f7e:	cd11                	beqz	a0,ffffffffc0208f9a <sfs_wbuf+0x56>
ffffffffc0208f80:	8522                	mv	a0,s0
ffffffffc0208f82:	18a000ef          	jal	ra,ffffffffc020910c <unlock_sfs_io>
ffffffffc0208f86:	70e2                	ld	ra,56(sp)
ffffffffc0208f88:	7442                	ld	s0,48(sp)
ffffffffc0208f8a:	7902                	ld	s2,32(sp)
ffffffffc0208f8c:	69e2                	ld	s3,24(sp)
ffffffffc0208f8e:	6a42                	ld	s4,16(sp)
ffffffffc0208f90:	6aa2                	ld	s5,8(sp)
ffffffffc0208f92:	8526                	mv	a0,s1
ffffffffc0208f94:	74a2                	ld	s1,40(sp)
ffffffffc0208f96:	6121                	addi	sp,sp,64
ffffffffc0208f98:	8082                	ret
ffffffffc0208f9a:	6428                	ld	a0,72(s0)
ffffffffc0208f9c:	8652                	mv	a2,s4
ffffffffc0208f9e:	85d6                	mv	a1,s5
ffffffffc0208fa0:	954a                	add	a0,a0,s2
ffffffffc0208fa2:	7d1010ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0208fa6:	642c                	ld	a1,72(s0)
ffffffffc0208fa8:	4705                	li	a4,1
ffffffffc0208faa:	4685                	li	a3,1
ffffffffc0208fac:	864e                	mv	a2,s3
ffffffffc0208fae:	8522                	mv	a0,s0
ffffffffc0208fb0:	dfdff0ef          	jal	ra,ffffffffc0208dac <sfs_rwblock_nolock>
ffffffffc0208fb4:	84aa                	mv	s1,a0
ffffffffc0208fb6:	b7e9                	j	ffffffffc0208f80 <sfs_wbuf+0x3c>
ffffffffc0208fb8:	00006697          	auipc	a3,0x6
ffffffffc0208fbc:	b0068693          	addi	a3,a3,-1280 # ffffffffc020eab8 <dev_node_ops+0x108>
ffffffffc0208fc0:	00003617          	auipc	a2,0x3
ffffffffc0208fc4:	95860613          	addi	a2,a2,-1704 # ffffffffc020b918 <commands+0x250>
ffffffffc0208fc8:	06b00593          	li	a1,107
ffffffffc0208fcc:	00006517          	auipc	a0,0x6
ffffffffc0208fd0:	ad450513          	addi	a0,a0,-1324 # ffffffffc020eaa0 <dev_node_ops+0xf0>
ffffffffc0208fd4:	a5af70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208fd8 <sfs_sync_super>:
ffffffffc0208fd8:	1101                	addi	sp,sp,-32
ffffffffc0208fda:	ec06                	sd	ra,24(sp)
ffffffffc0208fdc:	e822                	sd	s0,16(sp)
ffffffffc0208fde:	e426                	sd	s1,8(sp)
ffffffffc0208fe0:	842a                	mv	s0,a0
ffffffffc0208fe2:	11a000ef          	jal	ra,ffffffffc02090fc <lock_sfs_io>
ffffffffc0208fe6:	6428                	ld	a0,72(s0)
ffffffffc0208fe8:	6605                	lui	a2,0x1
ffffffffc0208fea:	4581                	li	a1,0
ffffffffc0208fec:	735010ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc0208ff0:	6428                	ld	a0,72(s0)
ffffffffc0208ff2:	85a2                	mv	a1,s0
ffffffffc0208ff4:	02c00613          	li	a2,44
ffffffffc0208ff8:	77b010ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc0208ffc:	642c                	ld	a1,72(s0)
ffffffffc0208ffe:	4701                	li	a4,0
ffffffffc0209000:	4685                	li	a3,1
ffffffffc0209002:	4601                	li	a2,0
ffffffffc0209004:	8522                	mv	a0,s0
ffffffffc0209006:	da7ff0ef          	jal	ra,ffffffffc0208dac <sfs_rwblock_nolock>
ffffffffc020900a:	84aa                	mv	s1,a0
ffffffffc020900c:	8522                	mv	a0,s0
ffffffffc020900e:	0fe000ef          	jal	ra,ffffffffc020910c <unlock_sfs_io>
ffffffffc0209012:	60e2                	ld	ra,24(sp)
ffffffffc0209014:	6442                	ld	s0,16(sp)
ffffffffc0209016:	8526                	mv	a0,s1
ffffffffc0209018:	64a2                	ld	s1,8(sp)
ffffffffc020901a:	6105                	addi	sp,sp,32
ffffffffc020901c:	8082                	ret

ffffffffc020901e <sfs_sync_freemap>:
ffffffffc020901e:	7139                	addi	sp,sp,-64
ffffffffc0209020:	ec4e                	sd	s3,24(sp)
ffffffffc0209022:	e852                	sd	s4,16(sp)
ffffffffc0209024:	00456983          	lwu	s3,4(a0)
ffffffffc0209028:	8a2a                	mv	s4,a0
ffffffffc020902a:	7d08                	ld	a0,56(a0)
ffffffffc020902c:	67a1                	lui	a5,0x8
ffffffffc020902e:	17fd                	addi	a5,a5,-1
ffffffffc0209030:	4581                	li	a1,0
ffffffffc0209032:	f822                	sd	s0,48(sp)
ffffffffc0209034:	fc06                	sd	ra,56(sp)
ffffffffc0209036:	f426                	sd	s1,40(sp)
ffffffffc0209038:	f04a                	sd	s2,32(sp)
ffffffffc020903a:	e456                	sd	s5,8(sp)
ffffffffc020903c:	99be                	add	s3,s3,a5
ffffffffc020903e:	633010ef          	jal	ra,ffffffffc020ae70 <bitmap_getdata>
ffffffffc0209042:	00f9d993          	srli	s3,s3,0xf
ffffffffc0209046:	842a                	mv	s0,a0
ffffffffc0209048:	8552                	mv	a0,s4
ffffffffc020904a:	0b2000ef          	jal	ra,ffffffffc02090fc <lock_sfs_io>
ffffffffc020904e:	04098163          	beqz	s3,ffffffffc0209090 <sfs_sync_freemap+0x72>
ffffffffc0209052:	09b2                	slli	s3,s3,0xc
ffffffffc0209054:	99a2                	add	s3,s3,s0
ffffffffc0209056:	4909                	li	s2,2
ffffffffc0209058:	6a85                	lui	s5,0x1
ffffffffc020905a:	a021                	j	ffffffffc0209062 <sfs_sync_freemap+0x44>
ffffffffc020905c:	2905                	addiw	s2,s2,1
ffffffffc020905e:	02898963          	beq	s3,s0,ffffffffc0209090 <sfs_sync_freemap+0x72>
ffffffffc0209062:	85a2                	mv	a1,s0
ffffffffc0209064:	864a                	mv	a2,s2
ffffffffc0209066:	4705                	li	a4,1
ffffffffc0209068:	4685                	li	a3,1
ffffffffc020906a:	8552                	mv	a0,s4
ffffffffc020906c:	d41ff0ef          	jal	ra,ffffffffc0208dac <sfs_rwblock_nolock>
ffffffffc0209070:	84aa                	mv	s1,a0
ffffffffc0209072:	9456                	add	s0,s0,s5
ffffffffc0209074:	d565                	beqz	a0,ffffffffc020905c <sfs_sync_freemap+0x3e>
ffffffffc0209076:	8552                	mv	a0,s4
ffffffffc0209078:	094000ef          	jal	ra,ffffffffc020910c <unlock_sfs_io>
ffffffffc020907c:	70e2                	ld	ra,56(sp)
ffffffffc020907e:	7442                	ld	s0,48(sp)
ffffffffc0209080:	7902                	ld	s2,32(sp)
ffffffffc0209082:	69e2                	ld	s3,24(sp)
ffffffffc0209084:	6a42                	ld	s4,16(sp)
ffffffffc0209086:	6aa2                	ld	s5,8(sp)
ffffffffc0209088:	8526                	mv	a0,s1
ffffffffc020908a:	74a2                	ld	s1,40(sp)
ffffffffc020908c:	6121                	addi	sp,sp,64
ffffffffc020908e:	8082                	ret
ffffffffc0209090:	4481                	li	s1,0
ffffffffc0209092:	b7d5                	j	ffffffffc0209076 <sfs_sync_freemap+0x58>

ffffffffc0209094 <sfs_clear_block>:
ffffffffc0209094:	7179                	addi	sp,sp,-48
ffffffffc0209096:	f022                	sd	s0,32(sp)
ffffffffc0209098:	e84a                	sd	s2,16(sp)
ffffffffc020909a:	e44e                	sd	s3,8(sp)
ffffffffc020909c:	f406                	sd	ra,40(sp)
ffffffffc020909e:	89b2                	mv	s3,a2
ffffffffc02090a0:	ec26                	sd	s1,24(sp)
ffffffffc02090a2:	892a                	mv	s2,a0
ffffffffc02090a4:	842e                	mv	s0,a1
ffffffffc02090a6:	056000ef          	jal	ra,ffffffffc02090fc <lock_sfs_io>
ffffffffc02090aa:	04893503          	ld	a0,72(s2) # 4048 <_binary_bin_swap_img_size-0x3cb8>
ffffffffc02090ae:	6605                	lui	a2,0x1
ffffffffc02090b0:	4581                	li	a1,0
ffffffffc02090b2:	66f010ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc02090b6:	02098d63          	beqz	s3,ffffffffc02090f0 <sfs_clear_block+0x5c>
ffffffffc02090ba:	013409bb          	addw	s3,s0,s3
ffffffffc02090be:	a019                	j	ffffffffc02090c4 <sfs_clear_block+0x30>
ffffffffc02090c0:	02898863          	beq	s3,s0,ffffffffc02090f0 <sfs_clear_block+0x5c>
ffffffffc02090c4:	04893583          	ld	a1,72(s2)
ffffffffc02090c8:	8622                	mv	a2,s0
ffffffffc02090ca:	4705                	li	a4,1
ffffffffc02090cc:	4685                	li	a3,1
ffffffffc02090ce:	854a                	mv	a0,s2
ffffffffc02090d0:	cddff0ef          	jal	ra,ffffffffc0208dac <sfs_rwblock_nolock>
ffffffffc02090d4:	84aa                	mv	s1,a0
ffffffffc02090d6:	2405                	addiw	s0,s0,1
ffffffffc02090d8:	d565                	beqz	a0,ffffffffc02090c0 <sfs_clear_block+0x2c>
ffffffffc02090da:	854a                	mv	a0,s2
ffffffffc02090dc:	030000ef          	jal	ra,ffffffffc020910c <unlock_sfs_io>
ffffffffc02090e0:	70a2                	ld	ra,40(sp)
ffffffffc02090e2:	7402                	ld	s0,32(sp)
ffffffffc02090e4:	6942                	ld	s2,16(sp)
ffffffffc02090e6:	69a2                	ld	s3,8(sp)
ffffffffc02090e8:	8526                	mv	a0,s1
ffffffffc02090ea:	64e2                	ld	s1,24(sp)
ffffffffc02090ec:	6145                	addi	sp,sp,48
ffffffffc02090ee:	8082                	ret
ffffffffc02090f0:	4481                	li	s1,0
ffffffffc02090f2:	b7e5                	j	ffffffffc02090da <sfs_clear_block+0x46>

ffffffffc02090f4 <lock_sfs_fs>:
ffffffffc02090f4:	05050513          	addi	a0,a0,80
ffffffffc02090f8:	e52fb06f          	j	ffffffffc020474a <down>

ffffffffc02090fc <lock_sfs_io>:
ffffffffc02090fc:	06850513          	addi	a0,a0,104
ffffffffc0209100:	e4afb06f          	j	ffffffffc020474a <down>

ffffffffc0209104 <unlock_sfs_fs>:
ffffffffc0209104:	05050513          	addi	a0,a0,80
ffffffffc0209108:	e3efb06f          	j	ffffffffc0204746 <up>

ffffffffc020910c <unlock_sfs_io>:
ffffffffc020910c:	06850513          	addi	a0,a0,104
ffffffffc0209110:	e36fb06f          	j	ffffffffc0204746 <up>

ffffffffc0209114 <sfs_unmount>:
ffffffffc0209114:	1141                	addi	sp,sp,-16
ffffffffc0209116:	e406                	sd	ra,8(sp)
ffffffffc0209118:	e022                	sd	s0,0(sp)
ffffffffc020911a:	cd1d                	beqz	a0,ffffffffc0209158 <sfs_unmount+0x44>
ffffffffc020911c:	0b052783          	lw	a5,176(a0)
ffffffffc0209120:	842a                	mv	s0,a0
ffffffffc0209122:	eb9d                	bnez	a5,ffffffffc0209158 <sfs_unmount+0x44>
ffffffffc0209124:	7158                	ld	a4,160(a0)
ffffffffc0209126:	09850793          	addi	a5,a0,152
ffffffffc020912a:	02f71563          	bne	a4,a5,ffffffffc0209154 <sfs_unmount+0x40>
ffffffffc020912e:	613c                	ld	a5,64(a0)
ffffffffc0209130:	e7a1                	bnez	a5,ffffffffc0209178 <sfs_unmount+0x64>
ffffffffc0209132:	7d08                	ld	a0,56(a0)
ffffffffc0209134:	523010ef          	jal	ra,ffffffffc020ae56 <bitmap_destroy>
ffffffffc0209138:	6428                	ld	a0,72(s0)
ffffffffc020913a:	f38fa0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020913e:	7448                	ld	a0,168(s0)
ffffffffc0209140:	f32fa0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0209144:	8522                	mv	a0,s0
ffffffffc0209146:	f2cfa0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020914a:	4501                	li	a0,0
ffffffffc020914c:	60a2                	ld	ra,8(sp)
ffffffffc020914e:	6402                	ld	s0,0(sp)
ffffffffc0209150:	0141                	addi	sp,sp,16
ffffffffc0209152:	8082                	ret
ffffffffc0209154:	5545                	li	a0,-15
ffffffffc0209156:	bfdd                	j	ffffffffc020914c <sfs_unmount+0x38>
ffffffffc0209158:	00006697          	auipc	a3,0x6
ffffffffc020915c:	9a868693          	addi	a3,a3,-1624 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc0209160:	00002617          	auipc	a2,0x2
ffffffffc0209164:	7b860613          	addi	a2,a2,1976 # ffffffffc020b918 <commands+0x250>
ffffffffc0209168:	04100593          	li	a1,65
ffffffffc020916c:	00006517          	auipc	a0,0x6
ffffffffc0209170:	9c450513          	addi	a0,a0,-1596 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc0209174:	8baf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209178:	00006697          	auipc	a3,0x6
ffffffffc020917c:	9d068693          	addi	a3,a3,-1584 # ffffffffc020eb48 <dev_node_ops+0x198>
ffffffffc0209180:	00002617          	auipc	a2,0x2
ffffffffc0209184:	79860613          	addi	a2,a2,1944 # ffffffffc020b918 <commands+0x250>
ffffffffc0209188:	04500593          	li	a1,69
ffffffffc020918c:	00006517          	auipc	a0,0x6
ffffffffc0209190:	9a450513          	addi	a0,a0,-1628 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc0209194:	89af70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209198 <sfs_cleanup>:
ffffffffc0209198:	1101                	addi	sp,sp,-32
ffffffffc020919a:	ec06                	sd	ra,24(sp)
ffffffffc020919c:	e822                	sd	s0,16(sp)
ffffffffc020919e:	e426                	sd	s1,8(sp)
ffffffffc02091a0:	e04a                	sd	s2,0(sp)
ffffffffc02091a2:	c525                	beqz	a0,ffffffffc020920a <sfs_cleanup+0x72>
ffffffffc02091a4:	0b052783          	lw	a5,176(a0)
ffffffffc02091a8:	84aa                	mv	s1,a0
ffffffffc02091aa:	e3a5                	bnez	a5,ffffffffc020920a <sfs_cleanup+0x72>
ffffffffc02091ac:	4158                	lw	a4,4(a0)
ffffffffc02091ae:	4514                	lw	a3,8(a0)
ffffffffc02091b0:	00c50913          	addi	s2,a0,12
ffffffffc02091b4:	85ca                	mv	a1,s2
ffffffffc02091b6:	40d7063b          	subw	a2,a4,a3
ffffffffc02091ba:	00006517          	auipc	a0,0x6
ffffffffc02091be:	9a650513          	addi	a0,a0,-1626 # ffffffffc020eb60 <dev_node_ops+0x1b0>
ffffffffc02091c2:	f69f60ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02091c6:	02000413          	li	s0,32
ffffffffc02091ca:	a019                	j	ffffffffc02091d0 <sfs_cleanup+0x38>
ffffffffc02091cc:	347d                	addiw	s0,s0,-1
ffffffffc02091ce:	c819                	beqz	s0,ffffffffc02091e4 <sfs_cleanup+0x4c>
ffffffffc02091d0:	7cdc                	ld	a5,184(s1)
ffffffffc02091d2:	8526                	mv	a0,s1
ffffffffc02091d4:	9782                	jalr	a5
ffffffffc02091d6:	f97d                	bnez	a0,ffffffffc02091cc <sfs_cleanup+0x34>
ffffffffc02091d8:	60e2                	ld	ra,24(sp)
ffffffffc02091da:	6442                	ld	s0,16(sp)
ffffffffc02091dc:	64a2                	ld	s1,8(sp)
ffffffffc02091de:	6902                	ld	s2,0(sp)
ffffffffc02091e0:	6105                	addi	sp,sp,32
ffffffffc02091e2:	8082                	ret
ffffffffc02091e4:	6442                	ld	s0,16(sp)
ffffffffc02091e6:	60e2                	ld	ra,24(sp)
ffffffffc02091e8:	64a2                	ld	s1,8(sp)
ffffffffc02091ea:	86ca                	mv	a3,s2
ffffffffc02091ec:	6902                	ld	s2,0(sp)
ffffffffc02091ee:	872a                	mv	a4,a0
ffffffffc02091f0:	00006617          	auipc	a2,0x6
ffffffffc02091f4:	99060613          	addi	a2,a2,-1648 # ffffffffc020eb80 <dev_node_ops+0x1d0>
ffffffffc02091f8:	05f00593          	li	a1,95
ffffffffc02091fc:	00006517          	auipc	a0,0x6
ffffffffc0209200:	93450513          	addi	a0,a0,-1740 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc0209204:	6105                	addi	sp,sp,32
ffffffffc0209206:	890f706f          	j	ffffffffc0200296 <__warn>
ffffffffc020920a:	00006697          	auipc	a3,0x6
ffffffffc020920e:	8f668693          	addi	a3,a3,-1802 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc0209212:	00002617          	auipc	a2,0x2
ffffffffc0209216:	70660613          	addi	a2,a2,1798 # ffffffffc020b918 <commands+0x250>
ffffffffc020921a:	05400593          	li	a1,84
ffffffffc020921e:	00006517          	auipc	a0,0x6
ffffffffc0209222:	91250513          	addi	a0,a0,-1774 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc0209226:	808f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020922a <sfs_sync>:
ffffffffc020922a:	7179                	addi	sp,sp,-48
ffffffffc020922c:	f406                	sd	ra,40(sp)
ffffffffc020922e:	f022                	sd	s0,32(sp)
ffffffffc0209230:	ec26                	sd	s1,24(sp)
ffffffffc0209232:	e84a                	sd	s2,16(sp)
ffffffffc0209234:	e44e                	sd	s3,8(sp)
ffffffffc0209236:	e052                	sd	s4,0(sp)
ffffffffc0209238:	cd4d                	beqz	a0,ffffffffc02092f2 <sfs_sync+0xc8>
ffffffffc020923a:	0b052783          	lw	a5,176(a0)
ffffffffc020923e:	8a2a                	mv	s4,a0
ffffffffc0209240:	ebcd                	bnez	a5,ffffffffc02092f2 <sfs_sync+0xc8>
ffffffffc0209242:	eb3ff0ef          	jal	ra,ffffffffc02090f4 <lock_sfs_fs>
ffffffffc0209246:	0a0a3403          	ld	s0,160(s4)
ffffffffc020924a:	098a0913          	addi	s2,s4,152
ffffffffc020924e:	02890763          	beq	s2,s0,ffffffffc020927c <sfs_sync+0x52>
ffffffffc0209252:	00004997          	auipc	s3,0x4
ffffffffc0209256:	ff698993          	addi	s3,s3,-10 # ffffffffc020d248 <default_pmm_manager+0x460>
ffffffffc020925a:	7c1c                	ld	a5,56(s0)
ffffffffc020925c:	fc840493          	addi	s1,s0,-56
ffffffffc0209260:	cbb5                	beqz	a5,ffffffffc02092d4 <sfs_sync+0xaa>
ffffffffc0209262:	7b9c                	ld	a5,48(a5)
ffffffffc0209264:	cba5                	beqz	a5,ffffffffc02092d4 <sfs_sync+0xaa>
ffffffffc0209266:	85ce                	mv	a1,s3
ffffffffc0209268:	8526                	mv	a0,s1
ffffffffc020926a:	cb7fe0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc020926e:	7c1c                	ld	a5,56(s0)
ffffffffc0209270:	8526                	mv	a0,s1
ffffffffc0209272:	7b9c                	ld	a5,48(a5)
ffffffffc0209274:	9782                	jalr	a5
ffffffffc0209276:	6400                	ld	s0,8(s0)
ffffffffc0209278:	fe8911e3          	bne	s2,s0,ffffffffc020925a <sfs_sync+0x30>
ffffffffc020927c:	8552                	mv	a0,s4
ffffffffc020927e:	e87ff0ef          	jal	ra,ffffffffc0209104 <unlock_sfs_fs>
ffffffffc0209282:	040a3783          	ld	a5,64(s4)
ffffffffc0209286:	4501                	li	a0,0
ffffffffc0209288:	eb89                	bnez	a5,ffffffffc020929a <sfs_sync+0x70>
ffffffffc020928a:	70a2                	ld	ra,40(sp)
ffffffffc020928c:	7402                	ld	s0,32(sp)
ffffffffc020928e:	64e2                	ld	s1,24(sp)
ffffffffc0209290:	6942                	ld	s2,16(sp)
ffffffffc0209292:	69a2                	ld	s3,8(sp)
ffffffffc0209294:	6a02                	ld	s4,0(sp)
ffffffffc0209296:	6145                	addi	sp,sp,48
ffffffffc0209298:	8082                	ret
ffffffffc020929a:	040a3023          	sd	zero,64(s4)
ffffffffc020929e:	8552                	mv	a0,s4
ffffffffc02092a0:	d39ff0ef          	jal	ra,ffffffffc0208fd8 <sfs_sync_super>
ffffffffc02092a4:	cd01                	beqz	a0,ffffffffc02092bc <sfs_sync+0x92>
ffffffffc02092a6:	70a2                	ld	ra,40(sp)
ffffffffc02092a8:	7402                	ld	s0,32(sp)
ffffffffc02092aa:	4785                	li	a5,1
ffffffffc02092ac:	04fa3023          	sd	a5,64(s4)
ffffffffc02092b0:	64e2                	ld	s1,24(sp)
ffffffffc02092b2:	6942                	ld	s2,16(sp)
ffffffffc02092b4:	69a2                	ld	s3,8(sp)
ffffffffc02092b6:	6a02                	ld	s4,0(sp)
ffffffffc02092b8:	6145                	addi	sp,sp,48
ffffffffc02092ba:	8082                	ret
ffffffffc02092bc:	8552                	mv	a0,s4
ffffffffc02092be:	d61ff0ef          	jal	ra,ffffffffc020901e <sfs_sync_freemap>
ffffffffc02092c2:	f175                	bnez	a0,ffffffffc02092a6 <sfs_sync+0x7c>
ffffffffc02092c4:	70a2                	ld	ra,40(sp)
ffffffffc02092c6:	7402                	ld	s0,32(sp)
ffffffffc02092c8:	64e2                	ld	s1,24(sp)
ffffffffc02092ca:	6942                	ld	s2,16(sp)
ffffffffc02092cc:	69a2                	ld	s3,8(sp)
ffffffffc02092ce:	6a02                	ld	s4,0(sp)
ffffffffc02092d0:	6145                	addi	sp,sp,48
ffffffffc02092d2:	8082                	ret
ffffffffc02092d4:	00004697          	auipc	a3,0x4
ffffffffc02092d8:	f2468693          	addi	a3,a3,-220 # ffffffffc020d1f8 <default_pmm_manager+0x410>
ffffffffc02092dc:	00002617          	auipc	a2,0x2
ffffffffc02092e0:	63c60613          	addi	a2,a2,1596 # ffffffffc020b918 <commands+0x250>
ffffffffc02092e4:	45ed                	li	a1,27
ffffffffc02092e6:	00006517          	auipc	a0,0x6
ffffffffc02092ea:	84a50513          	addi	a0,a0,-1974 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc02092ee:	f41f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02092f2:	00006697          	auipc	a3,0x6
ffffffffc02092f6:	80e68693          	addi	a3,a3,-2034 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc02092fa:	00002617          	auipc	a2,0x2
ffffffffc02092fe:	61e60613          	addi	a2,a2,1566 # ffffffffc020b918 <commands+0x250>
ffffffffc0209302:	45d5                	li	a1,21
ffffffffc0209304:	00006517          	auipc	a0,0x6
ffffffffc0209308:	82c50513          	addi	a0,a0,-2004 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc020930c:	f23f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209310 <sfs_get_root>:
ffffffffc0209310:	1101                	addi	sp,sp,-32
ffffffffc0209312:	ec06                	sd	ra,24(sp)
ffffffffc0209314:	cd09                	beqz	a0,ffffffffc020932e <sfs_get_root+0x1e>
ffffffffc0209316:	0b052783          	lw	a5,176(a0)
ffffffffc020931a:	eb91                	bnez	a5,ffffffffc020932e <sfs_get_root+0x1e>
ffffffffc020931c:	4605                	li	a2,1
ffffffffc020931e:	002c                	addi	a1,sp,8
ffffffffc0209320:	376010ef          	jal	ra,ffffffffc020a696 <sfs_load_inode>
ffffffffc0209324:	e50d                	bnez	a0,ffffffffc020934e <sfs_get_root+0x3e>
ffffffffc0209326:	60e2                	ld	ra,24(sp)
ffffffffc0209328:	6522                	ld	a0,8(sp)
ffffffffc020932a:	6105                	addi	sp,sp,32
ffffffffc020932c:	8082                	ret
ffffffffc020932e:	00005697          	auipc	a3,0x5
ffffffffc0209332:	7d268693          	addi	a3,a3,2002 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc0209336:	00002617          	auipc	a2,0x2
ffffffffc020933a:	5e260613          	addi	a2,a2,1506 # ffffffffc020b918 <commands+0x250>
ffffffffc020933e:	03600593          	li	a1,54
ffffffffc0209342:	00005517          	auipc	a0,0x5
ffffffffc0209346:	7ee50513          	addi	a0,a0,2030 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc020934a:	ee5f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020934e:	86aa                	mv	a3,a0
ffffffffc0209350:	00006617          	auipc	a2,0x6
ffffffffc0209354:	85060613          	addi	a2,a2,-1968 # ffffffffc020eba0 <dev_node_ops+0x1f0>
ffffffffc0209358:	03700593          	li	a1,55
ffffffffc020935c:	00005517          	auipc	a0,0x5
ffffffffc0209360:	7d450513          	addi	a0,a0,2004 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc0209364:	ecbf60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209368 <sfs_do_mount>:
ffffffffc0209368:	6518                	ld	a4,8(a0)
ffffffffc020936a:	7171                	addi	sp,sp,-176
ffffffffc020936c:	f506                	sd	ra,168(sp)
ffffffffc020936e:	f122                	sd	s0,160(sp)
ffffffffc0209370:	ed26                	sd	s1,152(sp)
ffffffffc0209372:	e94a                	sd	s2,144(sp)
ffffffffc0209374:	e54e                	sd	s3,136(sp)
ffffffffc0209376:	e152                	sd	s4,128(sp)
ffffffffc0209378:	fcd6                	sd	s5,120(sp)
ffffffffc020937a:	f8da                	sd	s6,112(sp)
ffffffffc020937c:	f4de                	sd	s7,104(sp)
ffffffffc020937e:	f0e2                	sd	s8,96(sp)
ffffffffc0209380:	ece6                	sd	s9,88(sp)
ffffffffc0209382:	e8ea                	sd	s10,80(sp)
ffffffffc0209384:	e4ee                	sd	s11,72(sp)
ffffffffc0209386:	6785                	lui	a5,0x1
ffffffffc0209388:	24f71663          	bne	a4,a5,ffffffffc02095d4 <sfs_do_mount+0x26c>
ffffffffc020938c:	892a                	mv	s2,a0
ffffffffc020938e:	4501                	li	a0,0
ffffffffc0209390:	8aae                	mv	s5,a1
ffffffffc0209392:	f51fe0ef          	jal	ra,ffffffffc02082e2 <__alloc_fs>
ffffffffc0209396:	842a                	mv	s0,a0
ffffffffc0209398:	24050463          	beqz	a0,ffffffffc02095e0 <sfs_do_mount+0x278>
ffffffffc020939c:	0b052b03          	lw	s6,176(a0)
ffffffffc02093a0:	260b1263          	bnez	s6,ffffffffc0209604 <sfs_do_mount+0x29c>
ffffffffc02093a4:	03253823          	sd	s2,48(a0)
ffffffffc02093a8:	6505                	lui	a0,0x1
ffffffffc02093aa:	c18fa0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc02093ae:	e428                	sd	a0,72(s0)
ffffffffc02093b0:	84aa                	mv	s1,a0
ffffffffc02093b2:	16050363          	beqz	a0,ffffffffc0209518 <sfs_do_mount+0x1b0>
ffffffffc02093b6:	85aa                	mv	a1,a0
ffffffffc02093b8:	4681                	li	a3,0
ffffffffc02093ba:	6605                	lui	a2,0x1
ffffffffc02093bc:	1008                	addi	a0,sp,32
ffffffffc02093be:	b6efc0ef          	jal	ra,ffffffffc020572c <iobuf_init>
ffffffffc02093c2:	02093783          	ld	a5,32(s2)
ffffffffc02093c6:	85aa                	mv	a1,a0
ffffffffc02093c8:	4601                	li	a2,0
ffffffffc02093ca:	854a                	mv	a0,s2
ffffffffc02093cc:	9782                	jalr	a5
ffffffffc02093ce:	8a2a                	mv	s4,a0
ffffffffc02093d0:	10051e63          	bnez	a0,ffffffffc02094ec <sfs_do_mount+0x184>
ffffffffc02093d4:	408c                	lw	a1,0(s1)
ffffffffc02093d6:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc02093da:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc02093de:	14c59863          	bne	a1,a2,ffffffffc020952e <sfs_do_mount+0x1c6>
ffffffffc02093e2:	40dc                	lw	a5,4(s1)
ffffffffc02093e4:	00093603          	ld	a2,0(s2)
ffffffffc02093e8:	02079713          	slli	a4,a5,0x20
ffffffffc02093ec:	9301                	srli	a4,a4,0x20
ffffffffc02093ee:	12e66763          	bltu	a2,a4,ffffffffc020951c <sfs_do_mount+0x1b4>
ffffffffc02093f2:	020485a3          	sb	zero,43(s1)
ffffffffc02093f6:	0084af03          	lw	t5,8(s1)
ffffffffc02093fa:	00c4ae83          	lw	t4,12(s1)
ffffffffc02093fe:	0104ae03          	lw	t3,16(s1)
ffffffffc0209402:	0144a303          	lw	t1,20(s1)
ffffffffc0209406:	0184a883          	lw	a7,24(s1)
ffffffffc020940a:	01c4a803          	lw	a6,28(s1)
ffffffffc020940e:	5090                	lw	a2,32(s1)
ffffffffc0209410:	50d4                	lw	a3,36(s1)
ffffffffc0209412:	5498                	lw	a4,40(s1)
ffffffffc0209414:	6511                	lui	a0,0x4
ffffffffc0209416:	c00c                	sw	a1,0(s0)
ffffffffc0209418:	c05c                	sw	a5,4(s0)
ffffffffc020941a:	01e42423          	sw	t5,8(s0)
ffffffffc020941e:	01d42623          	sw	t4,12(s0)
ffffffffc0209422:	01c42823          	sw	t3,16(s0)
ffffffffc0209426:	00642a23          	sw	t1,20(s0)
ffffffffc020942a:	01142c23          	sw	a7,24(s0)
ffffffffc020942e:	01042e23          	sw	a6,28(s0)
ffffffffc0209432:	d010                	sw	a2,32(s0)
ffffffffc0209434:	d054                	sw	a3,36(s0)
ffffffffc0209436:	d418                	sw	a4,40(s0)
ffffffffc0209438:	b8afa0ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc020943c:	f448                	sd	a0,168(s0)
ffffffffc020943e:	8c2a                	mv	s8,a0
ffffffffc0209440:	18050c63          	beqz	a0,ffffffffc02095d8 <sfs_do_mount+0x270>
ffffffffc0209444:	6711                	lui	a4,0x4
ffffffffc0209446:	87aa                	mv	a5,a0
ffffffffc0209448:	972a                	add	a4,a4,a0
ffffffffc020944a:	e79c                	sd	a5,8(a5)
ffffffffc020944c:	e39c                	sd	a5,0(a5)
ffffffffc020944e:	07c1                	addi	a5,a5,16
ffffffffc0209450:	fee79de3          	bne	a5,a4,ffffffffc020944a <sfs_do_mount+0xe2>
ffffffffc0209454:	0044eb83          	lwu	s7,4(s1)
ffffffffc0209458:	67a1                	lui	a5,0x8
ffffffffc020945a:	fff78993          	addi	s3,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc020945e:	9bce                	add	s7,s7,s3
ffffffffc0209460:	77e1                	lui	a5,0xffff8
ffffffffc0209462:	00fbfbb3          	and	s7,s7,a5
ffffffffc0209466:	2b81                	sext.w	s7,s7
ffffffffc0209468:	855e                	mv	a0,s7
ffffffffc020946a:	7f2010ef          	jal	ra,ffffffffc020ac5c <bitmap_create>
ffffffffc020946e:	fc08                	sd	a0,56(s0)
ffffffffc0209470:	8d2a                	mv	s10,a0
ffffffffc0209472:	14050f63          	beqz	a0,ffffffffc02095d0 <sfs_do_mount+0x268>
ffffffffc0209476:	0044e783          	lwu	a5,4(s1)
ffffffffc020947a:	082c                	addi	a1,sp,24
ffffffffc020947c:	97ce                	add	a5,a5,s3
ffffffffc020947e:	00f7d713          	srli	a4,a5,0xf
ffffffffc0209482:	e43a                	sd	a4,8(sp)
ffffffffc0209484:	40f7d993          	srai	s3,a5,0xf
ffffffffc0209488:	1e9010ef          	jal	ra,ffffffffc020ae70 <bitmap_getdata>
ffffffffc020948c:	14050c63          	beqz	a0,ffffffffc02095e4 <sfs_do_mount+0x27c>
ffffffffc0209490:	00c9979b          	slliw	a5,s3,0xc
ffffffffc0209494:	66e2                	ld	a3,24(sp)
ffffffffc0209496:	1782                	slli	a5,a5,0x20
ffffffffc0209498:	9381                	srli	a5,a5,0x20
ffffffffc020949a:	14d79563          	bne	a5,a3,ffffffffc02095e4 <sfs_do_mount+0x27c>
ffffffffc020949e:	6722                	ld	a4,8(sp)
ffffffffc02094a0:	6d89                	lui	s11,0x2
ffffffffc02094a2:	89aa                	mv	s3,a0
ffffffffc02094a4:	00c71c93          	slli	s9,a4,0xc
ffffffffc02094a8:	9caa                	add	s9,s9,a0
ffffffffc02094aa:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02094ae:	e711                	bnez	a4,ffffffffc02094ba <sfs_do_mount+0x152>
ffffffffc02094b0:	a079                	j	ffffffffc020953e <sfs_do_mount+0x1d6>
ffffffffc02094b2:	6785                	lui	a5,0x1
ffffffffc02094b4:	99be                	add	s3,s3,a5
ffffffffc02094b6:	093c8463          	beq	s9,s3,ffffffffc020953e <sfs_do_mount+0x1d6>
ffffffffc02094ba:	013d86bb          	addw	a3,s11,s3
ffffffffc02094be:	1682                	slli	a3,a3,0x20
ffffffffc02094c0:	6605                	lui	a2,0x1
ffffffffc02094c2:	85ce                	mv	a1,s3
ffffffffc02094c4:	9281                	srli	a3,a3,0x20
ffffffffc02094c6:	1008                	addi	a0,sp,32
ffffffffc02094c8:	a64fc0ef          	jal	ra,ffffffffc020572c <iobuf_init>
ffffffffc02094cc:	02093783          	ld	a5,32(s2)
ffffffffc02094d0:	85aa                	mv	a1,a0
ffffffffc02094d2:	4601                	li	a2,0
ffffffffc02094d4:	854a                	mv	a0,s2
ffffffffc02094d6:	9782                	jalr	a5
ffffffffc02094d8:	dd69                	beqz	a0,ffffffffc02094b2 <sfs_do_mount+0x14a>
ffffffffc02094da:	e42a                	sd	a0,8(sp)
ffffffffc02094dc:	856a                	mv	a0,s10
ffffffffc02094de:	179010ef          	jal	ra,ffffffffc020ae56 <bitmap_destroy>
ffffffffc02094e2:	67a2                	ld	a5,8(sp)
ffffffffc02094e4:	8a3e                	mv	s4,a5
ffffffffc02094e6:	8562                	mv	a0,s8
ffffffffc02094e8:	b8afa0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc02094ec:	8526                	mv	a0,s1
ffffffffc02094ee:	b84fa0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc02094f2:	8522                	mv	a0,s0
ffffffffc02094f4:	b7efa0ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc02094f8:	70aa                	ld	ra,168(sp)
ffffffffc02094fa:	740a                	ld	s0,160(sp)
ffffffffc02094fc:	64ea                	ld	s1,152(sp)
ffffffffc02094fe:	694a                	ld	s2,144(sp)
ffffffffc0209500:	69aa                	ld	s3,136(sp)
ffffffffc0209502:	7ae6                	ld	s5,120(sp)
ffffffffc0209504:	7b46                	ld	s6,112(sp)
ffffffffc0209506:	7ba6                	ld	s7,104(sp)
ffffffffc0209508:	7c06                	ld	s8,96(sp)
ffffffffc020950a:	6ce6                	ld	s9,88(sp)
ffffffffc020950c:	6d46                	ld	s10,80(sp)
ffffffffc020950e:	6da6                	ld	s11,72(sp)
ffffffffc0209510:	8552                	mv	a0,s4
ffffffffc0209512:	6a0a                	ld	s4,128(sp)
ffffffffc0209514:	614d                	addi	sp,sp,176
ffffffffc0209516:	8082                	ret
ffffffffc0209518:	5a71                	li	s4,-4
ffffffffc020951a:	bfe1                	j	ffffffffc02094f2 <sfs_do_mount+0x18a>
ffffffffc020951c:	85be                	mv	a1,a5
ffffffffc020951e:	00005517          	auipc	a0,0x5
ffffffffc0209522:	6da50513          	addi	a0,a0,1754 # ffffffffc020ebf8 <dev_node_ops+0x248>
ffffffffc0209526:	c05f60ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020952a:	5a75                	li	s4,-3
ffffffffc020952c:	b7c1                	j	ffffffffc02094ec <sfs_do_mount+0x184>
ffffffffc020952e:	00005517          	auipc	a0,0x5
ffffffffc0209532:	69250513          	addi	a0,a0,1682 # ffffffffc020ebc0 <dev_node_ops+0x210>
ffffffffc0209536:	bf5f60ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020953a:	5a75                	li	s4,-3
ffffffffc020953c:	bf45                	j	ffffffffc02094ec <sfs_do_mount+0x184>
ffffffffc020953e:	00442903          	lw	s2,4(s0)
ffffffffc0209542:	4481                	li	s1,0
ffffffffc0209544:	080b8c63          	beqz	s7,ffffffffc02095dc <sfs_do_mount+0x274>
ffffffffc0209548:	85a6                	mv	a1,s1
ffffffffc020954a:	856a                	mv	a0,s10
ffffffffc020954c:	091010ef          	jal	ra,ffffffffc020addc <bitmap_test>
ffffffffc0209550:	c111                	beqz	a0,ffffffffc0209554 <sfs_do_mount+0x1ec>
ffffffffc0209552:	2b05                	addiw	s6,s6,1
ffffffffc0209554:	2485                	addiw	s1,s1,1
ffffffffc0209556:	fe9b99e3          	bne	s7,s1,ffffffffc0209548 <sfs_do_mount+0x1e0>
ffffffffc020955a:	441c                	lw	a5,8(s0)
ffffffffc020955c:	0d679463          	bne	a5,s6,ffffffffc0209624 <sfs_do_mount+0x2bc>
ffffffffc0209560:	4585                	li	a1,1
ffffffffc0209562:	05040513          	addi	a0,s0,80
ffffffffc0209566:	04043023          	sd	zero,64(s0)
ffffffffc020956a:	9d4fb0ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc020956e:	4585                	li	a1,1
ffffffffc0209570:	06840513          	addi	a0,s0,104
ffffffffc0209574:	9cafb0ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc0209578:	4585                	li	a1,1
ffffffffc020957a:	08040513          	addi	a0,s0,128
ffffffffc020957e:	9c0fb0ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc0209582:	09840793          	addi	a5,s0,152
ffffffffc0209586:	f05c                	sd	a5,160(s0)
ffffffffc0209588:	ec5c                	sd	a5,152(s0)
ffffffffc020958a:	874a                	mv	a4,s2
ffffffffc020958c:	86da                	mv	a3,s6
ffffffffc020958e:	4169063b          	subw	a2,s2,s6
ffffffffc0209592:	00c40593          	addi	a1,s0,12
ffffffffc0209596:	00005517          	auipc	a0,0x5
ffffffffc020959a:	6f250513          	addi	a0,a0,1778 # ffffffffc020ec88 <dev_node_ops+0x2d8>
ffffffffc020959e:	b8df60ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02095a2:	00000797          	auipc	a5,0x0
ffffffffc02095a6:	c8878793          	addi	a5,a5,-888 # ffffffffc020922a <sfs_sync>
ffffffffc02095aa:	fc5c                	sd	a5,184(s0)
ffffffffc02095ac:	00000797          	auipc	a5,0x0
ffffffffc02095b0:	d6478793          	addi	a5,a5,-668 # ffffffffc0209310 <sfs_get_root>
ffffffffc02095b4:	e07c                	sd	a5,192(s0)
ffffffffc02095b6:	00000797          	auipc	a5,0x0
ffffffffc02095ba:	b5e78793          	addi	a5,a5,-1186 # ffffffffc0209114 <sfs_unmount>
ffffffffc02095be:	e47c                	sd	a5,200(s0)
ffffffffc02095c0:	00000797          	auipc	a5,0x0
ffffffffc02095c4:	bd878793          	addi	a5,a5,-1064 # ffffffffc0209198 <sfs_cleanup>
ffffffffc02095c8:	e87c                	sd	a5,208(s0)
ffffffffc02095ca:	008ab023          	sd	s0,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc02095ce:	b72d                	j	ffffffffc02094f8 <sfs_do_mount+0x190>
ffffffffc02095d0:	5a71                	li	s4,-4
ffffffffc02095d2:	bf11                	j	ffffffffc02094e6 <sfs_do_mount+0x17e>
ffffffffc02095d4:	5a49                	li	s4,-14
ffffffffc02095d6:	b70d                	j	ffffffffc02094f8 <sfs_do_mount+0x190>
ffffffffc02095d8:	5a71                	li	s4,-4
ffffffffc02095da:	bf09                	j	ffffffffc02094ec <sfs_do_mount+0x184>
ffffffffc02095dc:	4b01                	li	s6,0
ffffffffc02095de:	bfb5                	j	ffffffffc020955a <sfs_do_mount+0x1f2>
ffffffffc02095e0:	5a71                	li	s4,-4
ffffffffc02095e2:	bf19                	j	ffffffffc02094f8 <sfs_do_mount+0x190>
ffffffffc02095e4:	00005697          	auipc	a3,0x5
ffffffffc02095e8:	64468693          	addi	a3,a3,1604 # ffffffffc020ec28 <dev_node_ops+0x278>
ffffffffc02095ec:	00002617          	auipc	a2,0x2
ffffffffc02095f0:	32c60613          	addi	a2,a2,812 # ffffffffc020b918 <commands+0x250>
ffffffffc02095f4:	08300593          	li	a1,131
ffffffffc02095f8:	00005517          	auipc	a0,0x5
ffffffffc02095fc:	53850513          	addi	a0,a0,1336 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc0209600:	c2ff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209604:	00005697          	auipc	a3,0x5
ffffffffc0209608:	4fc68693          	addi	a3,a3,1276 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc020960c:	00002617          	auipc	a2,0x2
ffffffffc0209610:	30c60613          	addi	a2,a2,780 # ffffffffc020b918 <commands+0x250>
ffffffffc0209614:	0a300593          	li	a1,163
ffffffffc0209618:	00005517          	auipc	a0,0x5
ffffffffc020961c:	51850513          	addi	a0,a0,1304 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc0209620:	c0ff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209624:	00005697          	auipc	a3,0x5
ffffffffc0209628:	63468693          	addi	a3,a3,1588 # ffffffffc020ec58 <dev_node_ops+0x2a8>
ffffffffc020962c:	00002617          	auipc	a2,0x2
ffffffffc0209630:	2ec60613          	addi	a2,a2,748 # ffffffffc020b918 <commands+0x250>
ffffffffc0209634:	0e000593          	li	a1,224
ffffffffc0209638:	00005517          	auipc	a0,0x5
ffffffffc020963c:	4f850513          	addi	a0,a0,1272 # ffffffffc020eb30 <dev_node_ops+0x180>
ffffffffc0209640:	beff60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209644 <sfs_mount>:
ffffffffc0209644:	00000597          	auipc	a1,0x0
ffffffffc0209648:	d2458593          	addi	a1,a1,-732 # ffffffffc0209368 <sfs_do_mount>
ffffffffc020964c:	b4efe06f          	j	ffffffffc020799a <vfs_mount>

ffffffffc0209650 <sfs_opendir>:
ffffffffc0209650:	0235f593          	andi	a1,a1,35
ffffffffc0209654:	4501                	li	a0,0
ffffffffc0209656:	e191                	bnez	a1,ffffffffc020965a <sfs_opendir+0xa>
ffffffffc0209658:	8082                	ret
ffffffffc020965a:	553d                	li	a0,-17
ffffffffc020965c:	8082                	ret

ffffffffc020965e <sfs_openfile>:
ffffffffc020965e:	4501                	li	a0,0
ffffffffc0209660:	8082                	ret

ffffffffc0209662 <sfs_gettype>:
ffffffffc0209662:	1141                	addi	sp,sp,-16
ffffffffc0209664:	e406                	sd	ra,8(sp)
ffffffffc0209666:	c939                	beqz	a0,ffffffffc02096bc <sfs_gettype+0x5a>
ffffffffc0209668:	4d34                	lw	a3,88(a0)
ffffffffc020966a:	6785                	lui	a5,0x1
ffffffffc020966c:	23578713          	addi	a4,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209670:	04e69663          	bne	a3,a4,ffffffffc02096bc <sfs_gettype+0x5a>
ffffffffc0209674:	6114                	ld	a3,0(a0)
ffffffffc0209676:	4709                	li	a4,2
ffffffffc0209678:	0046d683          	lhu	a3,4(a3)
ffffffffc020967c:	02e68a63          	beq	a3,a4,ffffffffc02096b0 <sfs_gettype+0x4e>
ffffffffc0209680:	470d                	li	a4,3
ffffffffc0209682:	02e68163          	beq	a3,a4,ffffffffc02096a4 <sfs_gettype+0x42>
ffffffffc0209686:	4705                	li	a4,1
ffffffffc0209688:	00e68f63          	beq	a3,a4,ffffffffc02096a6 <sfs_gettype+0x44>
ffffffffc020968c:	00005617          	auipc	a2,0x5
ffffffffc0209690:	66c60613          	addi	a2,a2,1644 # ffffffffc020ecf8 <dev_node_ops+0x348>
ffffffffc0209694:	3a700593          	li	a1,935
ffffffffc0209698:	00005517          	auipc	a0,0x5
ffffffffc020969c:	64850513          	addi	a0,a0,1608 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc02096a0:	b8ff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02096a4:	678d                	lui	a5,0x3
ffffffffc02096a6:	60a2                	ld	ra,8(sp)
ffffffffc02096a8:	c19c                	sw	a5,0(a1)
ffffffffc02096aa:	4501                	li	a0,0
ffffffffc02096ac:	0141                	addi	sp,sp,16
ffffffffc02096ae:	8082                	ret
ffffffffc02096b0:	60a2                	ld	ra,8(sp)
ffffffffc02096b2:	6789                	lui	a5,0x2
ffffffffc02096b4:	c19c                	sw	a5,0(a1)
ffffffffc02096b6:	4501                	li	a0,0
ffffffffc02096b8:	0141                	addi	sp,sp,16
ffffffffc02096ba:	8082                	ret
ffffffffc02096bc:	00005697          	auipc	a3,0x5
ffffffffc02096c0:	5ec68693          	addi	a3,a3,1516 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc02096c4:	00002617          	auipc	a2,0x2
ffffffffc02096c8:	25460613          	addi	a2,a2,596 # ffffffffc020b918 <commands+0x250>
ffffffffc02096cc:	39b00593          	li	a1,923
ffffffffc02096d0:	00005517          	auipc	a0,0x5
ffffffffc02096d4:	61050513          	addi	a0,a0,1552 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc02096d8:	b57f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02096dc <sfs_fsync>:
ffffffffc02096dc:	7179                	addi	sp,sp,-48
ffffffffc02096de:	ec26                	sd	s1,24(sp)
ffffffffc02096e0:	7524                	ld	s1,104(a0)
ffffffffc02096e2:	f406                	sd	ra,40(sp)
ffffffffc02096e4:	f022                	sd	s0,32(sp)
ffffffffc02096e6:	e84a                	sd	s2,16(sp)
ffffffffc02096e8:	e44e                	sd	s3,8(sp)
ffffffffc02096ea:	c4bd                	beqz	s1,ffffffffc0209758 <sfs_fsync+0x7c>
ffffffffc02096ec:	0b04a783          	lw	a5,176(s1)
ffffffffc02096f0:	e7a5                	bnez	a5,ffffffffc0209758 <sfs_fsync+0x7c>
ffffffffc02096f2:	4d38                	lw	a4,88(a0)
ffffffffc02096f4:	6785                	lui	a5,0x1
ffffffffc02096f6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02096fa:	842a                	mv	s0,a0
ffffffffc02096fc:	06f71e63          	bne	a4,a5,ffffffffc0209778 <sfs_fsync+0x9c>
ffffffffc0209700:	691c                	ld	a5,16(a0)
ffffffffc0209702:	4901                	li	s2,0
ffffffffc0209704:	eb89                	bnez	a5,ffffffffc0209716 <sfs_fsync+0x3a>
ffffffffc0209706:	70a2                	ld	ra,40(sp)
ffffffffc0209708:	7402                	ld	s0,32(sp)
ffffffffc020970a:	64e2                	ld	s1,24(sp)
ffffffffc020970c:	69a2                	ld	s3,8(sp)
ffffffffc020970e:	854a                	mv	a0,s2
ffffffffc0209710:	6942                	ld	s2,16(sp)
ffffffffc0209712:	6145                	addi	sp,sp,48
ffffffffc0209714:	8082                	ret
ffffffffc0209716:	02050993          	addi	s3,a0,32
ffffffffc020971a:	854e                	mv	a0,s3
ffffffffc020971c:	82efb0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc0209720:	681c                	ld	a5,16(s0)
ffffffffc0209722:	ef81                	bnez	a5,ffffffffc020973a <sfs_fsync+0x5e>
ffffffffc0209724:	854e                	mv	a0,s3
ffffffffc0209726:	820fb0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020972a:	70a2                	ld	ra,40(sp)
ffffffffc020972c:	7402                	ld	s0,32(sp)
ffffffffc020972e:	64e2                	ld	s1,24(sp)
ffffffffc0209730:	69a2                	ld	s3,8(sp)
ffffffffc0209732:	854a                	mv	a0,s2
ffffffffc0209734:	6942                	ld	s2,16(sp)
ffffffffc0209736:	6145                	addi	sp,sp,48
ffffffffc0209738:	8082                	ret
ffffffffc020973a:	4414                	lw	a3,8(s0)
ffffffffc020973c:	600c                	ld	a1,0(s0)
ffffffffc020973e:	00043823          	sd	zero,16(s0)
ffffffffc0209742:	4701                	li	a4,0
ffffffffc0209744:	04000613          	li	a2,64
ffffffffc0209748:	8526                	mv	a0,s1
ffffffffc020974a:	ffaff0ef          	jal	ra,ffffffffc0208f44 <sfs_wbuf>
ffffffffc020974e:	892a                	mv	s2,a0
ffffffffc0209750:	d971                	beqz	a0,ffffffffc0209724 <sfs_fsync+0x48>
ffffffffc0209752:	4785                	li	a5,1
ffffffffc0209754:	e81c                	sd	a5,16(s0)
ffffffffc0209756:	b7f9                	j	ffffffffc0209724 <sfs_fsync+0x48>
ffffffffc0209758:	00005697          	auipc	a3,0x5
ffffffffc020975c:	3a868693          	addi	a3,a3,936 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc0209760:	00002617          	auipc	a2,0x2
ffffffffc0209764:	1b860613          	addi	a2,a2,440 # ffffffffc020b918 <commands+0x250>
ffffffffc0209768:	2df00593          	li	a1,735
ffffffffc020976c:	00005517          	auipc	a0,0x5
ffffffffc0209770:	57450513          	addi	a0,a0,1396 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209774:	abbf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209778:	00005697          	auipc	a3,0x5
ffffffffc020977c:	53068693          	addi	a3,a3,1328 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc0209780:	00002617          	auipc	a2,0x2
ffffffffc0209784:	19860613          	addi	a2,a2,408 # ffffffffc020b918 <commands+0x250>
ffffffffc0209788:	2e000593          	li	a1,736
ffffffffc020978c:	00005517          	auipc	a0,0x5
ffffffffc0209790:	55450513          	addi	a0,a0,1364 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209794:	a9bf60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209798 <sfs_fstat>:
ffffffffc0209798:	1101                	addi	sp,sp,-32
ffffffffc020979a:	e426                	sd	s1,8(sp)
ffffffffc020979c:	84ae                	mv	s1,a1
ffffffffc020979e:	e822                	sd	s0,16(sp)
ffffffffc02097a0:	02000613          	li	a2,32
ffffffffc02097a4:	842a                	mv	s0,a0
ffffffffc02097a6:	4581                	li	a1,0
ffffffffc02097a8:	8526                	mv	a0,s1
ffffffffc02097aa:	ec06                	sd	ra,24(sp)
ffffffffc02097ac:	774010ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc02097b0:	c439                	beqz	s0,ffffffffc02097fe <sfs_fstat+0x66>
ffffffffc02097b2:	783c                	ld	a5,112(s0)
ffffffffc02097b4:	c7a9                	beqz	a5,ffffffffc02097fe <sfs_fstat+0x66>
ffffffffc02097b6:	6bbc                	ld	a5,80(a5)
ffffffffc02097b8:	c3b9                	beqz	a5,ffffffffc02097fe <sfs_fstat+0x66>
ffffffffc02097ba:	00005597          	auipc	a1,0x5
ffffffffc02097be:	ace58593          	addi	a1,a1,-1330 # ffffffffc020e288 <syscalls+0x990>
ffffffffc02097c2:	8522                	mv	a0,s0
ffffffffc02097c4:	f5cfe0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02097c8:	783c                	ld	a5,112(s0)
ffffffffc02097ca:	85a6                	mv	a1,s1
ffffffffc02097cc:	8522                	mv	a0,s0
ffffffffc02097ce:	6bbc                	ld	a5,80(a5)
ffffffffc02097d0:	9782                	jalr	a5
ffffffffc02097d2:	e10d                	bnez	a0,ffffffffc02097f4 <sfs_fstat+0x5c>
ffffffffc02097d4:	4c38                	lw	a4,88(s0)
ffffffffc02097d6:	6785                	lui	a5,0x1
ffffffffc02097d8:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02097dc:	04f71163          	bne	a4,a5,ffffffffc020981e <sfs_fstat+0x86>
ffffffffc02097e0:	601c                	ld	a5,0(s0)
ffffffffc02097e2:	0067d683          	lhu	a3,6(a5)
ffffffffc02097e6:	0087e703          	lwu	a4,8(a5)
ffffffffc02097ea:	0007e783          	lwu	a5,0(a5)
ffffffffc02097ee:	e494                	sd	a3,8(s1)
ffffffffc02097f0:	e898                	sd	a4,16(s1)
ffffffffc02097f2:	ec9c                	sd	a5,24(s1)
ffffffffc02097f4:	60e2                	ld	ra,24(sp)
ffffffffc02097f6:	6442                	ld	s0,16(sp)
ffffffffc02097f8:	64a2                	ld	s1,8(sp)
ffffffffc02097fa:	6105                	addi	sp,sp,32
ffffffffc02097fc:	8082                	ret
ffffffffc02097fe:	00005697          	auipc	a3,0x5
ffffffffc0209802:	a2268693          	addi	a3,a3,-1502 # ffffffffc020e220 <syscalls+0x928>
ffffffffc0209806:	00002617          	auipc	a2,0x2
ffffffffc020980a:	11260613          	addi	a2,a2,274 # ffffffffc020b918 <commands+0x250>
ffffffffc020980e:	2d000593          	li	a1,720
ffffffffc0209812:	00005517          	auipc	a0,0x5
ffffffffc0209816:	4ce50513          	addi	a0,a0,1230 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020981a:	a15f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020981e:	00005697          	auipc	a3,0x5
ffffffffc0209822:	48a68693          	addi	a3,a3,1162 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc0209826:	00002617          	auipc	a2,0x2
ffffffffc020982a:	0f260613          	addi	a2,a2,242 # ffffffffc020b918 <commands+0x250>
ffffffffc020982e:	2d300593          	li	a1,723
ffffffffc0209832:	00005517          	auipc	a0,0x5
ffffffffc0209836:	4ae50513          	addi	a0,a0,1198 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020983a:	9f5f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020983e <sfs_tryseek>:
ffffffffc020983e:	080007b7          	lui	a5,0x8000
ffffffffc0209842:	04f5fd63          	bgeu	a1,a5,ffffffffc020989c <sfs_tryseek+0x5e>
ffffffffc0209846:	1101                	addi	sp,sp,-32
ffffffffc0209848:	e822                	sd	s0,16(sp)
ffffffffc020984a:	ec06                	sd	ra,24(sp)
ffffffffc020984c:	e426                	sd	s1,8(sp)
ffffffffc020984e:	842a                	mv	s0,a0
ffffffffc0209850:	c921                	beqz	a0,ffffffffc02098a0 <sfs_tryseek+0x62>
ffffffffc0209852:	4d38                	lw	a4,88(a0)
ffffffffc0209854:	6785                	lui	a5,0x1
ffffffffc0209856:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020985a:	04f71363          	bne	a4,a5,ffffffffc02098a0 <sfs_tryseek+0x62>
ffffffffc020985e:	611c                	ld	a5,0(a0)
ffffffffc0209860:	84ae                	mv	s1,a1
ffffffffc0209862:	0007e783          	lwu	a5,0(a5)
ffffffffc0209866:	02b7d563          	bge	a5,a1,ffffffffc0209890 <sfs_tryseek+0x52>
ffffffffc020986a:	793c                	ld	a5,112(a0)
ffffffffc020986c:	cbb1                	beqz	a5,ffffffffc02098c0 <sfs_tryseek+0x82>
ffffffffc020986e:	73bc                	ld	a5,96(a5)
ffffffffc0209870:	cba1                	beqz	a5,ffffffffc02098c0 <sfs_tryseek+0x82>
ffffffffc0209872:	00005597          	auipc	a1,0x5
ffffffffc0209876:	e9658593          	addi	a1,a1,-362 # ffffffffc020e708 <syscalls+0xe10>
ffffffffc020987a:	ea6fe0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc020987e:	783c                	ld	a5,112(s0)
ffffffffc0209880:	8522                	mv	a0,s0
ffffffffc0209882:	6442                	ld	s0,16(sp)
ffffffffc0209884:	60e2                	ld	ra,24(sp)
ffffffffc0209886:	73bc                	ld	a5,96(a5)
ffffffffc0209888:	85a6                	mv	a1,s1
ffffffffc020988a:	64a2                	ld	s1,8(sp)
ffffffffc020988c:	6105                	addi	sp,sp,32
ffffffffc020988e:	8782                	jr	a5
ffffffffc0209890:	60e2                	ld	ra,24(sp)
ffffffffc0209892:	6442                	ld	s0,16(sp)
ffffffffc0209894:	64a2                	ld	s1,8(sp)
ffffffffc0209896:	4501                	li	a0,0
ffffffffc0209898:	6105                	addi	sp,sp,32
ffffffffc020989a:	8082                	ret
ffffffffc020989c:	5575                	li	a0,-3
ffffffffc020989e:	8082                	ret
ffffffffc02098a0:	00005697          	auipc	a3,0x5
ffffffffc02098a4:	40868693          	addi	a3,a3,1032 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc02098a8:	00002617          	auipc	a2,0x2
ffffffffc02098ac:	07060613          	addi	a2,a2,112 # ffffffffc020b918 <commands+0x250>
ffffffffc02098b0:	3b200593          	li	a1,946
ffffffffc02098b4:	00005517          	auipc	a0,0x5
ffffffffc02098b8:	42c50513          	addi	a0,a0,1068 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc02098bc:	973f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02098c0:	00005697          	auipc	a3,0x5
ffffffffc02098c4:	df068693          	addi	a3,a3,-528 # ffffffffc020e6b0 <syscalls+0xdb8>
ffffffffc02098c8:	00002617          	auipc	a2,0x2
ffffffffc02098cc:	05060613          	addi	a2,a2,80 # ffffffffc020b918 <commands+0x250>
ffffffffc02098d0:	3b400593          	li	a1,948
ffffffffc02098d4:	00005517          	auipc	a0,0x5
ffffffffc02098d8:	40c50513          	addi	a0,a0,1036 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc02098dc:	953f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02098e0 <sfs_close>:
ffffffffc02098e0:	1141                	addi	sp,sp,-16
ffffffffc02098e2:	e406                	sd	ra,8(sp)
ffffffffc02098e4:	e022                	sd	s0,0(sp)
ffffffffc02098e6:	c11d                	beqz	a0,ffffffffc020990c <sfs_close+0x2c>
ffffffffc02098e8:	793c                	ld	a5,112(a0)
ffffffffc02098ea:	842a                	mv	s0,a0
ffffffffc02098ec:	c385                	beqz	a5,ffffffffc020990c <sfs_close+0x2c>
ffffffffc02098ee:	7b9c                	ld	a5,48(a5)
ffffffffc02098f0:	cf91                	beqz	a5,ffffffffc020990c <sfs_close+0x2c>
ffffffffc02098f2:	00004597          	auipc	a1,0x4
ffffffffc02098f6:	95658593          	addi	a1,a1,-1706 # ffffffffc020d248 <default_pmm_manager+0x460>
ffffffffc02098fa:	e26fe0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc02098fe:	783c                	ld	a5,112(s0)
ffffffffc0209900:	8522                	mv	a0,s0
ffffffffc0209902:	6402                	ld	s0,0(sp)
ffffffffc0209904:	60a2                	ld	ra,8(sp)
ffffffffc0209906:	7b9c                	ld	a5,48(a5)
ffffffffc0209908:	0141                	addi	sp,sp,16
ffffffffc020990a:	8782                	jr	a5
ffffffffc020990c:	00004697          	auipc	a3,0x4
ffffffffc0209910:	8ec68693          	addi	a3,a3,-1812 # ffffffffc020d1f8 <default_pmm_manager+0x410>
ffffffffc0209914:	00002617          	auipc	a2,0x2
ffffffffc0209918:	00460613          	addi	a2,a2,4 # ffffffffc020b918 <commands+0x250>
ffffffffc020991c:	21c00593          	li	a1,540
ffffffffc0209920:	00005517          	auipc	a0,0x5
ffffffffc0209924:	3c050513          	addi	a0,a0,960 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209928:	907f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020992c <sfs_io.part.0>:
ffffffffc020992c:	1141                	addi	sp,sp,-16
ffffffffc020992e:	00005697          	auipc	a3,0x5
ffffffffc0209932:	37a68693          	addi	a3,a3,890 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc0209936:	00002617          	auipc	a2,0x2
ffffffffc020993a:	fe260613          	addi	a2,a2,-30 # ffffffffc020b918 <commands+0x250>
ffffffffc020993e:	2af00593          	li	a1,687
ffffffffc0209942:	00005517          	auipc	a0,0x5
ffffffffc0209946:	39e50513          	addi	a0,a0,926 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020994a:	e406                	sd	ra,8(sp)
ffffffffc020994c:	8e3f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209950 <sfs_block_free>:
ffffffffc0209950:	1101                	addi	sp,sp,-32
ffffffffc0209952:	e426                	sd	s1,8(sp)
ffffffffc0209954:	ec06                	sd	ra,24(sp)
ffffffffc0209956:	e822                	sd	s0,16(sp)
ffffffffc0209958:	4154                	lw	a3,4(a0)
ffffffffc020995a:	84ae                	mv	s1,a1
ffffffffc020995c:	c595                	beqz	a1,ffffffffc0209988 <sfs_block_free+0x38>
ffffffffc020995e:	02d5f563          	bgeu	a1,a3,ffffffffc0209988 <sfs_block_free+0x38>
ffffffffc0209962:	842a                	mv	s0,a0
ffffffffc0209964:	7d08                	ld	a0,56(a0)
ffffffffc0209966:	476010ef          	jal	ra,ffffffffc020addc <bitmap_test>
ffffffffc020996a:	ed05                	bnez	a0,ffffffffc02099a2 <sfs_block_free+0x52>
ffffffffc020996c:	7c08                	ld	a0,56(s0)
ffffffffc020996e:	85a6                	mv	a1,s1
ffffffffc0209970:	494010ef          	jal	ra,ffffffffc020ae04 <bitmap_free>
ffffffffc0209974:	441c                	lw	a5,8(s0)
ffffffffc0209976:	4705                	li	a4,1
ffffffffc0209978:	60e2                	ld	ra,24(sp)
ffffffffc020997a:	2785                	addiw	a5,a5,1
ffffffffc020997c:	e038                	sd	a4,64(s0)
ffffffffc020997e:	c41c                	sw	a5,8(s0)
ffffffffc0209980:	6442                	ld	s0,16(sp)
ffffffffc0209982:	64a2                	ld	s1,8(sp)
ffffffffc0209984:	6105                	addi	sp,sp,32
ffffffffc0209986:	8082                	ret
ffffffffc0209988:	8726                	mv	a4,s1
ffffffffc020998a:	00005617          	auipc	a2,0x5
ffffffffc020998e:	38660613          	addi	a2,a2,902 # ffffffffc020ed10 <dev_node_ops+0x360>
ffffffffc0209992:	05300593          	li	a1,83
ffffffffc0209996:	00005517          	auipc	a0,0x5
ffffffffc020999a:	34a50513          	addi	a0,a0,842 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020999e:	891f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02099a2:	00005697          	auipc	a3,0x5
ffffffffc02099a6:	3a668693          	addi	a3,a3,934 # ffffffffc020ed48 <dev_node_ops+0x398>
ffffffffc02099aa:	00002617          	auipc	a2,0x2
ffffffffc02099ae:	f6e60613          	addi	a2,a2,-146 # ffffffffc020b918 <commands+0x250>
ffffffffc02099b2:	06a00593          	li	a1,106
ffffffffc02099b6:	00005517          	auipc	a0,0x5
ffffffffc02099ba:	32a50513          	addi	a0,a0,810 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc02099be:	871f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02099c2 <sfs_reclaim>:
ffffffffc02099c2:	1101                	addi	sp,sp,-32
ffffffffc02099c4:	e426                	sd	s1,8(sp)
ffffffffc02099c6:	7524                	ld	s1,104(a0)
ffffffffc02099c8:	ec06                	sd	ra,24(sp)
ffffffffc02099ca:	e822                	sd	s0,16(sp)
ffffffffc02099cc:	e04a                	sd	s2,0(sp)
ffffffffc02099ce:	0e048a63          	beqz	s1,ffffffffc0209ac2 <sfs_reclaim+0x100>
ffffffffc02099d2:	0b04a783          	lw	a5,176(s1)
ffffffffc02099d6:	0e079663          	bnez	a5,ffffffffc0209ac2 <sfs_reclaim+0x100>
ffffffffc02099da:	4d38                	lw	a4,88(a0)
ffffffffc02099dc:	6785                	lui	a5,0x1
ffffffffc02099de:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02099e2:	842a                	mv	s0,a0
ffffffffc02099e4:	10f71f63          	bne	a4,a5,ffffffffc0209b02 <sfs_reclaim+0x140>
ffffffffc02099e8:	8526                	mv	a0,s1
ffffffffc02099ea:	f0aff0ef          	jal	ra,ffffffffc02090f4 <lock_sfs_fs>
ffffffffc02099ee:	4c1c                	lw	a5,24(s0)
ffffffffc02099f0:	0ef05963          	blez	a5,ffffffffc0209ae2 <sfs_reclaim+0x120>
ffffffffc02099f4:	fff7871b          	addiw	a4,a5,-1
ffffffffc02099f8:	cc18                	sw	a4,24(s0)
ffffffffc02099fa:	eb59                	bnez	a4,ffffffffc0209a90 <sfs_reclaim+0xce>
ffffffffc02099fc:	05c42903          	lw	s2,92(s0)
ffffffffc0209a00:	08091863          	bnez	s2,ffffffffc0209a90 <sfs_reclaim+0xce>
ffffffffc0209a04:	601c                	ld	a5,0(s0)
ffffffffc0209a06:	0067d783          	lhu	a5,6(a5)
ffffffffc0209a0a:	e785                	bnez	a5,ffffffffc0209a32 <sfs_reclaim+0x70>
ffffffffc0209a0c:	783c                	ld	a5,112(s0)
ffffffffc0209a0e:	10078a63          	beqz	a5,ffffffffc0209b22 <sfs_reclaim+0x160>
ffffffffc0209a12:	73bc                	ld	a5,96(a5)
ffffffffc0209a14:	10078763          	beqz	a5,ffffffffc0209b22 <sfs_reclaim+0x160>
ffffffffc0209a18:	00005597          	auipc	a1,0x5
ffffffffc0209a1c:	cf058593          	addi	a1,a1,-784 # ffffffffc020e708 <syscalls+0xe10>
ffffffffc0209a20:	8522                	mv	a0,s0
ffffffffc0209a22:	cfefe0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0209a26:	783c                	ld	a5,112(s0)
ffffffffc0209a28:	4581                	li	a1,0
ffffffffc0209a2a:	8522                	mv	a0,s0
ffffffffc0209a2c:	73bc                	ld	a5,96(a5)
ffffffffc0209a2e:	9782                	jalr	a5
ffffffffc0209a30:	e559                	bnez	a0,ffffffffc0209abe <sfs_reclaim+0xfc>
ffffffffc0209a32:	681c                	ld	a5,16(s0)
ffffffffc0209a34:	c39d                	beqz	a5,ffffffffc0209a5a <sfs_reclaim+0x98>
ffffffffc0209a36:	783c                	ld	a5,112(s0)
ffffffffc0209a38:	10078563          	beqz	a5,ffffffffc0209b42 <sfs_reclaim+0x180>
ffffffffc0209a3c:	7b9c                	ld	a5,48(a5)
ffffffffc0209a3e:	10078263          	beqz	a5,ffffffffc0209b42 <sfs_reclaim+0x180>
ffffffffc0209a42:	8522                	mv	a0,s0
ffffffffc0209a44:	00004597          	auipc	a1,0x4
ffffffffc0209a48:	80458593          	addi	a1,a1,-2044 # ffffffffc020d248 <default_pmm_manager+0x460>
ffffffffc0209a4c:	cd4fe0ef          	jal	ra,ffffffffc0207f20 <inode_check>
ffffffffc0209a50:	783c                	ld	a5,112(s0)
ffffffffc0209a52:	8522                	mv	a0,s0
ffffffffc0209a54:	7b9c                	ld	a5,48(a5)
ffffffffc0209a56:	9782                	jalr	a5
ffffffffc0209a58:	e13d                	bnez	a0,ffffffffc0209abe <sfs_reclaim+0xfc>
ffffffffc0209a5a:	7c18                	ld	a4,56(s0)
ffffffffc0209a5c:	603c                	ld	a5,64(s0)
ffffffffc0209a5e:	8526                	mv	a0,s1
ffffffffc0209a60:	e71c                	sd	a5,8(a4)
ffffffffc0209a62:	e398                	sd	a4,0(a5)
ffffffffc0209a64:	6438                	ld	a4,72(s0)
ffffffffc0209a66:	683c                	ld	a5,80(s0)
ffffffffc0209a68:	e71c                	sd	a5,8(a4)
ffffffffc0209a6a:	e398                	sd	a4,0(a5)
ffffffffc0209a6c:	e98ff0ef          	jal	ra,ffffffffc0209104 <unlock_sfs_fs>
ffffffffc0209a70:	6008                	ld	a0,0(s0)
ffffffffc0209a72:	00655783          	lhu	a5,6(a0)
ffffffffc0209a76:	cb85                	beqz	a5,ffffffffc0209aa6 <sfs_reclaim+0xe4>
ffffffffc0209a78:	dfbf90ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc0209a7c:	8522                	mv	a0,s0
ffffffffc0209a7e:	c36fe0ef          	jal	ra,ffffffffc0207eb4 <inode_kill>
ffffffffc0209a82:	60e2                	ld	ra,24(sp)
ffffffffc0209a84:	6442                	ld	s0,16(sp)
ffffffffc0209a86:	64a2                	ld	s1,8(sp)
ffffffffc0209a88:	854a                	mv	a0,s2
ffffffffc0209a8a:	6902                	ld	s2,0(sp)
ffffffffc0209a8c:	6105                	addi	sp,sp,32
ffffffffc0209a8e:	8082                	ret
ffffffffc0209a90:	5945                	li	s2,-15
ffffffffc0209a92:	8526                	mv	a0,s1
ffffffffc0209a94:	e70ff0ef          	jal	ra,ffffffffc0209104 <unlock_sfs_fs>
ffffffffc0209a98:	60e2                	ld	ra,24(sp)
ffffffffc0209a9a:	6442                	ld	s0,16(sp)
ffffffffc0209a9c:	64a2                	ld	s1,8(sp)
ffffffffc0209a9e:	854a                	mv	a0,s2
ffffffffc0209aa0:	6902                	ld	s2,0(sp)
ffffffffc0209aa2:	6105                	addi	sp,sp,32
ffffffffc0209aa4:	8082                	ret
ffffffffc0209aa6:	440c                	lw	a1,8(s0)
ffffffffc0209aa8:	8526                	mv	a0,s1
ffffffffc0209aaa:	ea7ff0ef          	jal	ra,ffffffffc0209950 <sfs_block_free>
ffffffffc0209aae:	6008                	ld	a0,0(s0)
ffffffffc0209ab0:	5d4c                	lw	a1,60(a0)
ffffffffc0209ab2:	d1f9                	beqz	a1,ffffffffc0209a78 <sfs_reclaim+0xb6>
ffffffffc0209ab4:	8526                	mv	a0,s1
ffffffffc0209ab6:	e9bff0ef          	jal	ra,ffffffffc0209950 <sfs_block_free>
ffffffffc0209aba:	6008                	ld	a0,0(s0)
ffffffffc0209abc:	bf75                	j	ffffffffc0209a78 <sfs_reclaim+0xb6>
ffffffffc0209abe:	892a                	mv	s2,a0
ffffffffc0209ac0:	bfc9                	j	ffffffffc0209a92 <sfs_reclaim+0xd0>
ffffffffc0209ac2:	00005697          	auipc	a3,0x5
ffffffffc0209ac6:	03e68693          	addi	a3,a3,62 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc0209aca:	00002617          	auipc	a2,0x2
ffffffffc0209ace:	e4e60613          	addi	a2,a2,-434 # ffffffffc020b918 <commands+0x250>
ffffffffc0209ad2:	37000593          	li	a1,880
ffffffffc0209ad6:	00005517          	auipc	a0,0x5
ffffffffc0209ada:	20a50513          	addi	a0,a0,522 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209ade:	f50f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209ae2:	00005697          	auipc	a3,0x5
ffffffffc0209ae6:	28668693          	addi	a3,a3,646 # ffffffffc020ed68 <dev_node_ops+0x3b8>
ffffffffc0209aea:	00002617          	auipc	a2,0x2
ffffffffc0209aee:	e2e60613          	addi	a2,a2,-466 # ffffffffc020b918 <commands+0x250>
ffffffffc0209af2:	37600593          	li	a1,886
ffffffffc0209af6:	00005517          	auipc	a0,0x5
ffffffffc0209afa:	1ea50513          	addi	a0,a0,490 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209afe:	f30f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209b02:	00005697          	auipc	a3,0x5
ffffffffc0209b06:	1a668693          	addi	a3,a3,422 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc0209b0a:	00002617          	auipc	a2,0x2
ffffffffc0209b0e:	e0e60613          	addi	a2,a2,-498 # ffffffffc020b918 <commands+0x250>
ffffffffc0209b12:	37100593          	li	a1,881
ffffffffc0209b16:	00005517          	auipc	a0,0x5
ffffffffc0209b1a:	1ca50513          	addi	a0,a0,458 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209b1e:	f10f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209b22:	00005697          	auipc	a3,0x5
ffffffffc0209b26:	b8e68693          	addi	a3,a3,-1138 # ffffffffc020e6b0 <syscalls+0xdb8>
ffffffffc0209b2a:	00002617          	auipc	a2,0x2
ffffffffc0209b2e:	dee60613          	addi	a2,a2,-530 # ffffffffc020b918 <commands+0x250>
ffffffffc0209b32:	37b00593          	li	a1,891
ffffffffc0209b36:	00005517          	auipc	a0,0x5
ffffffffc0209b3a:	1aa50513          	addi	a0,a0,426 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209b3e:	ef0f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209b42:	00003697          	auipc	a3,0x3
ffffffffc0209b46:	6b668693          	addi	a3,a3,1718 # ffffffffc020d1f8 <default_pmm_manager+0x410>
ffffffffc0209b4a:	00002617          	auipc	a2,0x2
ffffffffc0209b4e:	dce60613          	addi	a2,a2,-562 # ffffffffc020b918 <commands+0x250>
ffffffffc0209b52:	38000593          	li	a1,896
ffffffffc0209b56:	00005517          	auipc	a0,0x5
ffffffffc0209b5a:	18a50513          	addi	a0,a0,394 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209b5e:	ed0f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209b62 <sfs_block_alloc>:
ffffffffc0209b62:	1101                	addi	sp,sp,-32
ffffffffc0209b64:	e822                	sd	s0,16(sp)
ffffffffc0209b66:	842a                	mv	s0,a0
ffffffffc0209b68:	7d08                	ld	a0,56(a0)
ffffffffc0209b6a:	e426                	sd	s1,8(sp)
ffffffffc0209b6c:	ec06                	sd	ra,24(sp)
ffffffffc0209b6e:	84ae                	mv	s1,a1
ffffffffc0209b70:	1fc010ef          	jal	ra,ffffffffc020ad6c <bitmap_alloc>
ffffffffc0209b74:	e90d                	bnez	a0,ffffffffc0209ba6 <sfs_block_alloc+0x44>
ffffffffc0209b76:	441c                	lw	a5,8(s0)
ffffffffc0209b78:	cbad                	beqz	a5,ffffffffc0209bea <sfs_block_alloc+0x88>
ffffffffc0209b7a:	37fd                	addiw	a5,a5,-1
ffffffffc0209b7c:	c41c                	sw	a5,8(s0)
ffffffffc0209b7e:	408c                	lw	a1,0(s1)
ffffffffc0209b80:	4785                	li	a5,1
ffffffffc0209b82:	e03c                	sd	a5,64(s0)
ffffffffc0209b84:	4054                	lw	a3,4(s0)
ffffffffc0209b86:	c58d                	beqz	a1,ffffffffc0209bb0 <sfs_block_alloc+0x4e>
ffffffffc0209b88:	02d5f463          	bgeu	a1,a3,ffffffffc0209bb0 <sfs_block_alloc+0x4e>
ffffffffc0209b8c:	7c08                	ld	a0,56(s0)
ffffffffc0209b8e:	24e010ef          	jal	ra,ffffffffc020addc <bitmap_test>
ffffffffc0209b92:	ed05                	bnez	a0,ffffffffc0209bca <sfs_block_alloc+0x68>
ffffffffc0209b94:	8522                	mv	a0,s0
ffffffffc0209b96:	6442                	ld	s0,16(sp)
ffffffffc0209b98:	408c                	lw	a1,0(s1)
ffffffffc0209b9a:	60e2                	ld	ra,24(sp)
ffffffffc0209b9c:	64a2                	ld	s1,8(sp)
ffffffffc0209b9e:	4605                	li	a2,1
ffffffffc0209ba0:	6105                	addi	sp,sp,32
ffffffffc0209ba2:	cf2ff06f          	j	ffffffffc0209094 <sfs_clear_block>
ffffffffc0209ba6:	60e2                	ld	ra,24(sp)
ffffffffc0209ba8:	6442                	ld	s0,16(sp)
ffffffffc0209baa:	64a2                	ld	s1,8(sp)
ffffffffc0209bac:	6105                	addi	sp,sp,32
ffffffffc0209bae:	8082                	ret
ffffffffc0209bb0:	872e                	mv	a4,a1
ffffffffc0209bb2:	00005617          	auipc	a2,0x5
ffffffffc0209bb6:	15e60613          	addi	a2,a2,350 # ffffffffc020ed10 <dev_node_ops+0x360>
ffffffffc0209bba:	05300593          	li	a1,83
ffffffffc0209bbe:	00005517          	auipc	a0,0x5
ffffffffc0209bc2:	12250513          	addi	a0,a0,290 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209bc6:	e68f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209bca:	00005697          	auipc	a3,0x5
ffffffffc0209bce:	1d668693          	addi	a3,a3,470 # ffffffffc020eda0 <dev_node_ops+0x3f0>
ffffffffc0209bd2:	00002617          	auipc	a2,0x2
ffffffffc0209bd6:	d4660613          	addi	a2,a2,-698 # ffffffffc020b918 <commands+0x250>
ffffffffc0209bda:	06100593          	li	a1,97
ffffffffc0209bde:	00005517          	auipc	a0,0x5
ffffffffc0209be2:	10250513          	addi	a0,a0,258 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209be6:	e48f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209bea:	00005697          	auipc	a3,0x5
ffffffffc0209bee:	19668693          	addi	a3,a3,406 # ffffffffc020ed80 <dev_node_ops+0x3d0>
ffffffffc0209bf2:	00002617          	auipc	a2,0x2
ffffffffc0209bf6:	d2660613          	addi	a2,a2,-730 # ffffffffc020b918 <commands+0x250>
ffffffffc0209bfa:	05f00593          	li	a1,95
ffffffffc0209bfe:	00005517          	auipc	a0,0x5
ffffffffc0209c02:	0e250513          	addi	a0,a0,226 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209c06:	e28f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209c0a <sfs_bmap_load_nolock>:
ffffffffc0209c0a:	7159                	addi	sp,sp,-112
ffffffffc0209c0c:	f85a                	sd	s6,48(sp)
ffffffffc0209c0e:	0005bb03          	ld	s6,0(a1)
ffffffffc0209c12:	f45e                	sd	s7,40(sp)
ffffffffc0209c14:	f486                	sd	ra,104(sp)
ffffffffc0209c16:	008b2b83          	lw	s7,8(s6)
ffffffffc0209c1a:	f0a2                	sd	s0,96(sp)
ffffffffc0209c1c:	eca6                	sd	s1,88(sp)
ffffffffc0209c1e:	e8ca                	sd	s2,80(sp)
ffffffffc0209c20:	e4ce                	sd	s3,72(sp)
ffffffffc0209c22:	e0d2                	sd	s4,64(sp)
ffffffffc0209c24:	fc56                	sd	s5,56(sp)
ffffffffc0209c26:	f062                	sd	s8,32(sp)
ffffffffc0209c28:	ec66                	sd	s9,24(sp)
ffffffffc0209c2a:	18cbe363          	bltu	s7,a2,ffffffffc0209db0 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209c2e:	47ad                	li	a5,11
ffffffffc0209c30:	8aae                	mv	s5,a1
ffffffffc0209c32:	8432                	mv	s0,a2
ffffffffc0209c34:	84aa                	mv	s1,a0
ffffffffc0209c36:	89b6                	mv	s3,a3
ffffffffc0209c38:	04c7f563          	bgeu	a5,a2,ffffffffc0209c82 <sfs_bmap_load_nolock+0x78>
ffffffffc0209c3c:	ff46071b          	addiw	a4,a2,-12
ffffffffc0209c40:	0007069b          	sext.w	a3,a4
ffffffffc0209c44:	3ff00793          	li	a5,1023
ffffffffc0209c48:	1ad7e163          	bltu	a5,a3,ffffffffc0209dea <sfs_bmap_load_nolock+0x1e0>
ffffffffc0209c4c:	03cb2a03          	lw	s4,60(s6)
ffffffffc0209c50:	02071793          	slli	a5,a4,0x20
ffffffffc0209c54:	c602                	sw	zero,12(sp)
ffffffffc0209c56:	c452                	sw	s4,8(sp)
ffffffffc0209c58:	01e7dc13          	srli	s8,a5,0x1e
ffffffffc0209c5c:	0e0a1e63          	bnez	s4,ffffffffc0209d58 <sfs_bmap_load_nolock+0x14e>
ffffffffc0209c60:	0acb8663          	beq	s7,a2,ffffffffc0209d0c <sfs_bmap_load_nolock+0x102>
ffffffffc0209c64:	4a01                	li	s4,0
ffffffffc0209c66:	40d4                	lw	a3,4(s1)
ffffffffc0209c68:	8752                	mv	a4,s4
ffffffffc0209c6a:	00005617          	auipc	a2,0x5
ffffffffc0209c6e:	0a660613          	addi	a2,a2,166 # ffffffffc020ed10 <dev_node_ops+0x360>
ffffffffc0209c72:	05300593          	li	a1,83
ffffffffc0209c76:	00005517          	auipc	a0,0x5
ffffffffc0209c7a:	06a50513          	addi	a0,a0,106 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209c7e:	db0f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209c82:	02061793          	slli	a5,a2,0x20
ffffffffc0209c86:	01e7da13          	srli	s4,a5,0x1e
ffffffffc0209c8a:	9a5a                	add	s4,s4,s6
ffffffffc0209c8c:	00ca2583          	lw	a1,12(s4)
ffffffffc0209c90:	c22e                	sw	a1,4(sp)
ffffffffc0209c92:	ed99                	bnez	a1,ffffffffc0209cb0 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209c94:	fccb98e3          	bne	s7,a2,ffffffffc0209c64 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209c98:	004c                	addi	a1,sp,4
ffffffffc0209c9a:	ec9ff0ef          	jal	ra,ffffffffc0209b62 <sfs_block_alloc>
ffffffffc0209c9e:	892a                	mv	s2,a0
ffffffffc0209ca0:	e921                	bnez	a0,ffffffffc0209cf0 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209ca2:	4592                	lw	a1,4(sp)
ffffffffc0209ca4:	4705                	li	a4,1
ffffffffc0209ca6:	00ba2623          	sw	a1,12(s4)
ffffffffc0209caa:	00eab823          	sd	a4,16(s5)
ffffffffc0209cae:	d9dd                	beqz	a1,ffffffffc0209c64 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209cb0:	40d4                	lw	a3,4(s1)
ffffffffc0209cb2:	10d5ff63          	bgeu	a1,a3,ffffffffc0209dd0 <sfs_bmap_load_nolock+0x1c6>
ffffffffc0209cb6:	7c88                	ld	a0,56(s1)
ffffffffc0209cb8:	124010ef          	jal	ra,ffffffffc020addc <bitmap_test>
ffffffffc0209cbc:	18051363          	bnez	a0,ffffffffc0209e42 <sfs_bmap_load_nolock+0x238>
ffffffffc0209cc0:	4a12                	lw	s4,4(sp)
ffffffffc0209cc2:	fa0a02e3          	beqz	s4,ffffffffc0209c66 <sfs_bmap_load_nolock+0x5c>
ffffffffc0209cc6:	40dc                	lw	a5,4(s1)
ffffffffc0209cc8:	f8fa7fe3          	bgeu	s4,a5,ffffffffc0209c66 <sfs_bmap_load_nolock+0x5c>
ffffffffc0209ccc:	7c88                	ld	a0,56(s1)
ffffffffc0209cce:	85d2                	mv	a1,s4
ffffffffc0209cd0:	10c010ef          	jal	ra,ffffffffc020addc <bitmap_test>
ffffffffc0209cd4:	12051763          	bnez	a0,ffffffffc0209e02 <sfs_bmap_load_nolock+0x1f8>
ffffffffc0209cd8:	008b9763          	bne	s7,s0,ffffffffc0209ce6 <sfs_bmap_load_nolock+0xdc>
ffffffffc0209cdc:	008b2783          	lw	a5,8(s6)
ffffffffc0209ce0:	2785                	addiw	a5,a5,1
ffffffffc0209ce2:	00fb2423          	sw	a5,8(s6)
ffffffffc0209ce6:	4901                	li	s2,0
ffffffffc0209ce8:	00098463          	beqz	s3,ffffffffc0209cf0 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209cec:	0149a023          	sw	s4,0(s3)
ffffffffc0209cf0:	70a6                	ld	ra,104(sp)
ffffffffc0209cf2:	7406                	ld	s0,96(sp)
ffffffffc0209cf4:	64e6                	ld	s1,88(sp)
ffffffffc0209cf6:	69a6                	ld	s3,72(sp)
ffffffffc0209cf8:	6a06                	ld	s4,64(sp)
ffffffffc0209cfa:	7ae2                	ld	s5,56(sp)
ffffffffc0209cfc:	7b42                	ld	s6,48(sp)
ffffffffc0209cfe:	7ba2                	ld	s7,40(sp)
ffffffffc0209d00:	7c02                	ld	s8,32(sp)
ffffffffc0209d02:	6ce2                	ld	s9,24(sp)
ffffffffc0209d04:	854a                	mv	a0,s2
ffffffffc0209d06:	6946                	ld	s2,80(sp)
ffffffffc0209d08:	6165                	addi	sp,sp,112
ffffffffc0209d0a:	8082                	ret
ffffffffc0209d0c:	002c                	addi	a1,sp,8
ffffffffc0209d0e:	e55ff0ef          	jal	ra,ffffffffc0209b62 <sfs_block_alloc>
ffffffffc0209d12:	892a                	mv	s2,a0
ffffffffc0209d14:	00c10c93          	addi	s9,sp,12
ffffffffc0209d18:	fd61                	bnez	a0,ffffffffc0209cf0 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209d1a:	85e6                	mv	a1,s9
ffffffffc0209d1c:	8526                	mv	a0,s1
ffffffffc0209d1e:	e45ff0ef          	jal	ra,ffffffffc0209b62 <sfs_block_alloc>
ffffffffc0209d22:	892a                	mv	s2,a0
ffffffffc0209d24:	e925                	bnez	a0,ffffffffc0209d94 <sfs_bmap_load_nolock+0x18a>
ffffffffc0209d26:	46a2                	lw	a3,8(sp)
ffffffffc0209d28:	85e6                	mv	a1,s9
ffffffffc0209d2a:	8762                	mv	a4,s8
ffffffffc0209d2c:	4611                	li	a2,4
ffffffffc0209d2e:	8526                	mv	a0,s1
ffffffffc0209d30:	a14ff0ef          	jal	ra,ffffffffc0208f44 <sfs_wbuf>
ffffffffc0209d34:	45b2                	lw	a1,12(sp)
ffffffffc0209d36:	892a                	mv	s2,a0
ffffffffc0209d38:	e939                	bnez	a0,ffffffffc0209d8e <sfs_bmap_load_nolock+0x184>
ffffffffc0209d3a:	03cb2683          	lw	a3,60(s6)
ffffffffc0209d3e:	4722                	lw	a4,8(sp)
ffffffffc0209d40:	c22e                	sw	a1,4(sp)
ffffffffc0209d42:	f6d706e3          	beq	a4,a3,ffffffffc0209cae <sfs_bmap_load_nolock+0xa4>
ffffffffc0209d46:	eef1                	bnez	a3,ffffffffc0209e22 <sfs_bmap_load_nolock+0x218>
ffffffffc0209d48:	02eb2e23          	sw	a4,60(s6)
ffffffffc0209d4c:	4705                	li	a4,1
ffffffffc0209d4e:	00eab823          	sd	a4,16(s5)
ffffffffc0209d52:	f00589e3          	beqz	a1,ffffffffc0209c64 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209d56:	bfa9                	j	ffffffffc0209cb0 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209d58:	00c10c93          	addi	s9,sp,12
ffffffffc0209d5c:	8762                	mv	a4,s8
ffffffffc0209d5e:	86d2                	mv	a3,s4
ffffffffc0209d60:	4611                	li	a2,4
ffffffffc0209d62:	85e6                	mv	a1,s9
ffffffffc0209d64:	960ff0ef          	jal	ra,ffffffffc0208ec4 <sfs_rbuf>
ffffffffc0209d68:	892a                	mv	s2,a0
ffffffffc0209d6a:	f159                	bnez	a0,ffffffffc0209cf0 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209d6c:	45b2                	lw	a1,12(sp)
ffffffffc0209d6e:	e995                	bnez	a1,ffffffffc0209da2 <sfs_bmap_load_nolock+0x198>
ffffffffc0209d70:	fa8b85e3          	beq	s7,s0,ffffffffc0209d1a <sfs_bmap_load_nolock+0x110>
ffffffffc0209d74:	03cb2703          	lw	a4,60(s6)
ffffffffc0209d78:	47a2                	lw	a5,8(sp)
ffffffffc0209d7a:	c202                	sw	zero,4(sp)
ffffffffc0209d7c:	eee784e3          	beq	a5,a4,ffffffffc0209c64 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209d80:	e34d                	bnez	a4,ffffffffc0209e22 <sfs_bmap_load_nolock+0x218>
ffffffffc0209d82:	02fb2e23          	sw	a5,60(s6)
ffffffffc0209d86:	4785                	li	a5,1
ffffffffc0209d88:	00fab823          	sd	a5,16(s5)
ffffffffc0209d8c:	bde1                	j	ffffffffc0209c64 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209d8e:	8526                	mv	a0,s1
ffffffffc0209d90:	bc1ff0ef          	jal	ra,ffffffffc0209950 <sfs_block_free>
ffffffffc0209d94:	45a2                	lw	a1,8(sp)
ffffffffc0209d96:	f4ba0de3          	beq	s4,a1,ffffffffc0209cf0 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209d9a:	8526                	mv	a0,s1
ffffffffc0209d9c:	bb5ff0ef          	jal	ra,ffffffffc0209950 <sfs_block_free>
ffffffffc0209da0:	bf81                	j	ffffffffc0209cf0 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209da2:	03cb2683          	lw	a3,60(s6)
ffffffffc0209da6:	4722                	lw	a4,8(sp)
ffffffffc0209da8:	c22e                	sw	a1,4(sp)
ffffffffc0209daa:	f8e69ee3          	bne	a3,a4,ffffffffc0209d46 <sfs_bmap_load_nolock+0x13c>
ffffffffc0209dae:	b709                	j	ffffffffc0209cb0 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209db0:	00005697          	auipc	a3,0x5
ffffffffc0209db4:	01868693          	addi	a3,a3,24 # ffffffffc020edc8 <dev_node_ops+0x418>
ffffffffc0209db8:	00002617          	auipc	a2,0x2
ffffffffc0209dbc:	b6060613          	addi	a2,a2,-1184 # ffffffffc020b918 <commands+0x250>
ffffffffc0209dc0:	16400593          	li	a1,356
ffffffffc0209dc4:	00005517          	auipc	a0,0x5
ffffffffc0209dc8:	f1c50513          	addi	a0,a0,-228 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209dcc:	c62f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209dd0:	872e                	mv	a4,a1
ffffffffc0209dd2:	00005617          	auipc	a2,0x5
ffffffffc0209dd6:	f3e60613          	addi	a2,a2,-194 # ffffffffc020ed10 <dev_node_ops+0x360>
ffffffffc0209dda:	05300593          	li	a1,83
ffffffffc0209dde:	00005517          	auipc	a0,0x5
ffffffffc0209de2:	f0250513          	addi	a0,a0,-254 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209de6:	c48f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209dea:	00005617          	auipc	a2,0x5
ffffffffc0209dee:	00e60613          	addi	a2,a2,14 # ffffffffc020edf8 <dev_node_ops+0x448>
ffffffffc0209df2:	11e00593          	li	a1,286
ffffffffc0209df6:	00005517          	auipc	a0,0x5
ffffffffc0209dfa:	eea50513          	addi	a0,a0,-278 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209dfe:	c30f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209e02:	00005697          	auipc	a3,0x5
ffffffffc0209e06:	f4668693          	addi	a3,a3,-186 # ffffffffc020ed48 <dev_node_ops+0x398>
ffffffffc0209e0a:	00002617          	auipc	a2,0x2
ffffffffc0209e0e:	b0e60613          	addi	a2,a2,-1266 # ffffffffc020b918 <commands+0x250>
ffffffffc0209e12:	16b00593          	li	a1,363
ffffffffc0209e16:	00005517          	auipc	a0,0x5
ffffffffc0209e1a:	eca50513          	addi	a0,a0,-310 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209e1e:	c10f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209e22:	00005697          	auipc	a3,0x5
ffffffffc0209e26:	fbe68693          	addi	a3,a3,-66 # ffffffffc020ede0 <dev_node_ops+0x430>
ffffffffc0209e2a:	00002617          	auipc	a2,0x2
ffffffffc0209e2e:	aee60613          	addi	a2,a2,-1298 # ffffffffc020b918 <commands+0x250>
ffffffffc0209e32:	11800593          	li	a1,280
ffffffffc0209e36:	00005517          	auipc	a0,0x5
ffffffffc0209e3a:	eaa50513          	addi	a0,a0,-342 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209e3e:	bf0f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209e42:	00005697          	auipc	a3,0x5
ffffffffc0209e46:	fe668693          	addi	a3,a3,-26 # ffffffffc020ee28 <dev_node_ops+0x478>
ffffffffc0209e4a:	00002617          	auipc	a2,0x2
ffffffffc0209e4e:	ace60613          	addi	a2,a2,-1330 # ffffffffc020b918 <commands+0x250>
ffffffffc0209e52:	12100593          	li	a1,289
ffffffffc0209e56:	00005517          	auipc	a0,0x5
ffffffffc0209e5a:	e8a50513          	addi	a0,a0,-374 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc0209e5e:	bd0f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209e62 <sfs_io_nolock>:
ffffffffc0209e62:	7175                	addi	sp,sp,-144
ffffffffc0209e64:	f86a                	sd	s10,48(sp)
ffffffffc0209e66:	8d2e                	mv	s10,a1
ffffffffc0209e68:	618c                	ld	a1,0(a1)
ffffffffc0209e6a:	e506                	sd	ra,136(sp)
ffffffffc0209e6c:	e122                	sd	s0,128(sp)
ffffffffc0209e6e:	0045d303          	lhu	t1,4(a1)
ffffffffc0209e72:	fca6                	sd	s1,120(sp)
ffffffffc0209e74:	f8ca                	sd	s2,112(sp)
ffffffffc0209e76:	f4ce                	sd	s3,104(sp)
ffffffffc0209e78:	f0d2                	sd	s4,96(sp)
ffffffffc0209e7a:	ecd6                	sd	s5,88(sp)
ffffffffc0209e7c:	e8da                	sd	s6,80(sp)
ffffffffc0209e7e:	e4de                	sd	s7,72(sp)
ffffffffc0209e80:	e0e2                	sd	s8,64(sp)
ffffffffc0209e82:	fc66                	sd	s9,56(sp)
ffffffffc0209e84:	f46e                	sd	s11,40(sp)
ffffffffc0209e86:	4889                	li	a7,2
ffffffffc0209e88:	19130f63          	beq	t1,a7,ffffffffc020a026 <sfs_io_nolock+0x1c4>
ffffffffc0209e8c:	00073c83          	ld	s9,0(a4) # 4000 <_binary_bin_swap_img_size-0x3d00>
ffffffffc0209e90:	843a                	mv	s0,a4
ffffffffc0209e92:	00043023          	sd	zero,0(s0)
ffffffffc0209e96:	08000737          	lui	a4,0x8000
ffffffffc0209e9a:	8c36                	mv	s8,a3
ffffffffc0209e9c:	9cb6                	add	s9,s9,a3
ffffffffc0209e9e:	14e6fa63          	bgeu	a3,a4,ffffffffc0209ff2 <sfs_io_nolock+0x190>
ffffffffc0209ea2:	14dcc863          	blt	s9,a3,ffffffffc0209ff2 <sfs_io_nolock+0x190>
ffffffffc0209ea6:	8baa                	mv	s7,a0
ffffffffc0209ea8:	4501                	li	a0,0
ffffffffc0209eaa:	0f968663          	beq	a3,s9,ffffffffc0209f96 <sfs_io_nolock+0x134>
ffffffffc0209eae:	89b2                	mv	s3,a2
ffffffffc0209eb0:	11977263          	bgeu	a4,s9,ffffffffc0209fb4 <sfs_io_nolock+0x152>
ffffffffc0209eb4:	10079b63          	bnez	a5,ffffffffc0209fca <sfs_io_nolock+0x168>
ffffffffc0209eb8:	08000cb7          	lui	s9,0x8000
ffffffffc0209ebc:	0005e783          	lwu	a5,0(a1)
ffffffffc0209ec0:	4501                	li	a0,0
ffffffffc0209ec2:	0cfc5a63          	bge	s8,a5,ffffffffc0209f96 <sfs_io_nolock+0x134>
ffffffffc0209ec6:	1397c463          	blt	a5,s9,ffffffffc0209fee <sfs_io_nolock+0x18c>
ffffffffc0209eca:	fffff797          	auipc	a5,0xfffff
ffffffffc0209ece:	ffa78793          	addi	a5,a5,-6 # ffffffffc0208ec4 <sfs_rbuf>
ffffffffc0209ed2:	fffffb17          	auipc	s6,0xfffff
ffffffffc0209ed6:	f32b0b13          	addi	s6,s6,-206 # ffffffffc0208e04 <sfs_rblock>
ffffffffc0209eda:	e03e                	sd	a5,0(sp)
ffffffffc0209edc:	40cc5493          	srai	s1,s8,0xc
ffffffffc0209ee0:	2481                	sext.w	s1,s1
ffffffffc0209ee2:	139c5f63          	bge	s8,s9,ffffffffc020a020 <sfs_io_nolock+0x1be>
ffffffffc0209ee6:	6a05                	lui	s4,0x1
ffffffffc0209ee8:	2485                	addiw	s1,s1,1
ffffffffc0209eea:	8de2                	mv	s11,s8
ffffffffc0209eec:	4901                	li	s2,0
ffffffffc0209eee:	fffa0a93          	addi	s5,s4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209ef2:	015df7b3          	and	a5,s11,s5
ffffffffc0209ef6:	fff4861b          	addiw	a2,s1,-1
ffffffffc0209efa:	ef8d                	bnez	a5,ffffffffc0209f34 <sfs_io_nolock+0xd2>
ffffffffc0209efc:	41bc88b3          	sub	a7,s9,s11
ffffffffc0209f00:	0f48cb63          	blt	a7,s4,ffffffffc0209ff6 <sfs_io_nolock+0x194>
ffffffffc0209f04:	0874                	addi	a3,sp,28
ffffffffc0209f06:	85ea                	mv	a1,s10
ffffffffc0209f08:	855e                	mv	a0,s7
ffffffffc0209f0a:	d01ff0ef          	jal	ra,ffffffffc0209c0a <sfs_bmap_load_nolock>
ffffffffc0209f0e:	e13d                	bnez	a0,ffffffffc0209f74 <sfs_io_nolock+0x112>
ffffffffc0209f10:	4672                	lw	a2,28(sp)
ffffffffc0209f12:	4685                	li	a3,1
ffffffffc0209f14:	012985b3          	add	a1,s3,s2
ffffffffc0209f18:	855e                	mv	a0,s7
ffffffffc0209f1a:	9b02                	jalr	s6
ffffffffc0209f1c:	ed21                	bnez	a0,ffffffffc0209f74 <sfs_io_nolock+0x112>
ffffffffc0209f1e:	9952                	add	s2,s2,s4
ffffffffc0209f20:	9dd2                	add	s11,s11,s4
ffffffffc0209f22:	2485                	addiw	s1,s1,1
ffffffffc0209f24:	fd9dc7e3          	blt	s11,s9,ffffffffc0209ef2 <sfs_io_nolock+0x90>
ffffffffc0209f28:	000d3583          	ld	a1,0(s10) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0209f2c:	012c06b3          	add	a3,s8,s2
ffffffffc0209f30:	4501                	li	a0,0
ffffffffc0209f32:	a0a9                	j	ffffffffc0209f7c <sfs_io_nolock+0x11a>
ffffffffc0209f34:	0874                	addi	a3,sp,28
ffffffffc0209f36:	85ea                	mv	a1,s10
ffffffffc0209f38:	855e                	mv	a0,s7
ffffffffc0209f3a:	cd1ff0ef          	jal	ra,ffffffffc0209c0a <sfs_bmap_load_nolock>
ffffffffc0209f3e:	e91d                	bnez	a0,ffffffffc0209f74 <sfs_io_nolock+0x112>
ffffffffc0209f40:	43fdd713          	srai	a4,s11,0x3f
ffffffffc0209f44:	03475793          	srli	a5,a4,0x34
ffffffffc0209f48:	00fd8733          	add	a4,s11,a5
ffffffffc0209f4c:	01577733          	and	a4,a4,s5
ffffffffc0209f50:	8f1d                	sub	a4,a4,a5
ffffffffc0209f52:	40ea0633          	sub	a2,s4,a4
ffffffffc0209f56:	00cd87b3          	add	a5,s11,a2
ffffffffc0209f5a:	00fcf463          	bgeu	s9,a5,ffffffffc0209f62 <sfs_io_nolock+0x100>
ffffffffc0209f5e:	41bc8633          	sub	a2,s9,s11
ffffffffc0209f62:	46f2                	lw	a3,28(sp)
ffffffffc0209f64:	6782                	ld	a5,0(sp)
ffffffffc0209f66:	012985b3          	add	a1,s3,s2
ffffffffc0209f6a:	855e                	mv	a0,s7
ffffffffc0209f6c:	e432                	sd	a2,8(sp)
ffffffffc0209f6e:	9782                	jalr	a5
ffffffffc0209f70:	6622                	ld	a2,8(sp)
ffffffffc0209f72:	c93d                	beqz	a0,ffffffffc0209fe8 <sfs_io_nolock+0x186>
ffffffffc0209f74:	000d3583          	ld	a1,0(s10)
ffffffffc0209f78:	012c06b3          	add	a3,s8,s2
ffffffffc0209f7c:	0005e783          	lwu	a5,0(a1)
ffffffffc0209f80:	01243023          	sd	s2,0(s0)
ffffffffc0209f84:	00d7f963          	bgeu	a5,a3,ffffffffc0209f96 <sfs_io_nolock+0x134>
ffffffffc0209f88:	012c093b          	addw	s2,s8,s2
ffffffffc0209f8c:	0125a023          	sw	s2,0(a1)
ffffffffc0209f90:	4785                	li	a5,1
ffffffffc0209f92:	00fd3823          	sd	a5,16(s10)
ffffffffc0209f96:	60aa                	ld	ra,136(sp)
ffffffffc0209f98:	640a                	ld	s0,128(sp)
ffffffffc0209f9a:	74e6                	ld	s1,120(sp)
ffffffffc0209f9c:	7946                	ld	s2,112(sp)
ffffffffc0209f9e:	79a6                	ld	s3,104(sp)
ffffffffc0209fa0:	7a06                	ld	s4,96(sp)
ffffffffc0209fa2:	6ae6                	ld	s5,88(sp)
ffffffffc0209fa4:	6b46                	ld	s6,80(sp)
ffffffffc0209fa6:	6ba6                	ld	s7,72(sp)
ffffffffc0209fa8:	6c06                	ld	s8,64(sp)
ffffffffc0209faa:	7ce2                	ld	s9,56(sp)
ffffffffc0209fac:	7d42                	ld	s10,48(sp)
ffffffffc0209fae:	7da2                	ld	s11,40(sp)
ffffffffc0209fb0:	6149                	addi	sp,sp,144
ffffffffc0209fb2:	8082                	ret
ffffffffc0209fb4:	d781                	beqz	a5,ffffffffc0209ebc <sfs_io_nolock+0x5a>
ffffffffc0209fb6:	fffff797          	auipc	a5,0xfffff
ffffffffc0209fba:	f8e78793          	addi	a5,a5,-114 # ffffffffc0208f44 <sfs_wbuf>
ffffffffc0209fbe:	fffffb17          	auipc	s6,0xfffff
ffffffffc0209fc2:	ea6b0b13          	addi	s6,s6,-346 # ffffffffc0208e64 <sfs_wblock>
ffffffffc0209fc6:	e03e                	sd	a5,0(sp)
ffffffffc0209fc8:	bf11                	j	ffffffffc0209edc <sfs_io_nolock+0x7a>
ffffffffc0209fca:	40cc5493          	srai	s1,s8,0xc
ffffffffc0209fce:	fffff797          	auipc	a5,0xfffff
ffffffffc0209fd2:	f7678793          	addi	a5,a5,-138 # ffffffffc0208f44 <sfs_wbuf>
ffffffffc0209fd6:	2481                	sext.w	s1,s1
ffffffffc0209fd8:	08000cb7          	lui	s9,0x8000
ffffffffc0209fdc:	fffffb17          	auipc	s6,0xfffff
ffffffffc0209fe0:	e88b0b13          	addi	s6,s6,-376 # ffffffffc0208e64 <sfs_wblock>
ffffffffc0209fe4:	e03e                	sd	a5,0(sp)
ffffffffc0209fe6:	b701                	j	ffffffffc0209ee6 <sfs_io_nolock+0x84>
ffffffffc0209fe8:	9932                	add	s2,s2,a2
ffffffffc0209fea:	9db2                	add	s11,s11,a2
ffffffffc0209fec:	bf1d                	j	ffffffffc0209f22 <sfs_io_nolock+0xc0>
ffffffffc0209fee:	8cbe                	mv	s9,a5
ffffffffc0209ff0:	bde9                	j	ffffffffc0209eca <sfs_io_nolock+0x68>
ffffffffc0209ff2:	5575                	li	a0,-3
ffffffffc0209ff4:	b74d                	j	ffffffffc0209f96 <sfs_io_nolock+0x134>
ffffffffc0209ff6:	0874                	addi	a3,sp,28
ffffffffc0209ff8:	85ea                	mv	a1,s10
ffffffffc0209ffa:	855e                	mv	a0,s7
ffffffffc0209ffc:	e446                	sd	a7,8(sp)
ffffffffc0209ffe:	c0dff0ef          	jal	ra,ffffffffc0209c0a <sfs_bmap_load_nolock>
ffffffffc020a002:	68a2                	ld	a7,8(sp)
ffffffffc020a004:	f925                	bnez	a0,ffffffffc0209f74 <sfs_io_nolock+0x112>
ffffffffc020a006:	46f2                	lw	a3,28(sp)
ffffffffc020a008:	6782                	ld	a5,0(sp)
ffffffffc020a00a:	8646                	mv	a2,a7
ffffffffc020a00c:	4701                	li	a4,0
ffffffffc020a00e:	012985b3          	add	a1,s3,s2
ffffffffc020a012:	855e                	mv	a0,s7
ffffffffc020a014:	e446                	sd	a7,8(sp)
ffffffffc020a016:	9782                	jalr	a5
ffffffffc020a018:	68a2                	ld	a7,8(sp)
ffffffffc020a01a:	fd29                	bnez	a0,ffffffffc0209f74 <sfs_io_nolock+0x112>
ffffffffc020a01c:	9946                	add	s2,s2,a7
ffffffffc020a01e:	bf99                	j	ffffffffc0209f74 <sfs_io_nolock+0x112>
ffffffffc020a020:	4901                	li	s2,0
ffffffffc020a022:	4501                	li	a0,0
ffffffffc020a024:	bfa1                	j	ffffffffc0209f7c <sfs_io_nolock+0x11a>
ffffffffc020a026:	00005697          	auipc	a3,0x5
ffffffffc020a02a:	e2a68693          	addi	a3,a3,-470 # ffffffffc020ee50 <dev_node_ops+0x4a0>
ffffffffc020a02e:	00002617          	auipc	a2,0x2
ffffffffc020a032:	8ea60613          	addi	a2,a2,-1814 # ffffffffc020b918 <commands+0x250>
ffffffffc020a036:	22b00593          	li	a1,555
ffffffffc020a03a:	00005517          	auipc	a0,0x5
ffffffffc020a03e:	ca650513          	addi	a0,a0,-858 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a042:	9ecf60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a046 <sfs_read>:
ffffffffc020a046:	7139                	addi	sp,sp,-64
ffffffffc020a048:	f04a                	sd	s2,32(sp)
ffffffffc020a04a:	06853903          	ld	s2,104(a0)
ffffffffc020a04e:	fc06                	sd	ra,56(sp)
ffffffffc020a050:	f822                	sd	s0,48(sp)
ffffffffc020a052:	f426                	sd	s1,40(sp)
ffffffffc020a054:	ec4e                	sd	s3,24(sp)
ffffffffc020a056:	04090f63          	beqz	s2,ffffffffc020a0b4 <sfs_read+0x6e>
ffffffffc020a05a:	0b092783          	lw	a5,176(s2)
ffffffffc020a05e:	ebb9                	bnez	a5,ffffffffc020a0b4 <sfs_read+0x6e>
ffffffffc020a060:	4d38                	lw	a4,88(a0)
ffffffffc020a062:	6785                	lui	a5,0x1
ffffffffc020a064:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a068:	842a                	mv	s0,a0
ffffffffc020a06a:	06f71563          	bne	a4,a5,ffffffffc020a0d4 <sfs_read+0x8e>
ffffffffc020a06e:	02050993          	addi	s3,a0,32
ffffffffc020a072:	854e                	mv	a0,s3
ffffffffc020a074:	84ae                	mv	s1,a1
ffffffffc020a076:	ed4fa0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc020a07a:	0184b803          	ld	a6,24(s1)
ffffffffc020a07e:	6494                	ld	a3,8(s1)
ffffffffc020a080:	6090                	ld	a2,0(s1)
ffffffffc020a082:	85a2                	mv	a1,s0
ffffffffc020a084:	4781                	li	a5,0
ffffffffc020a086:	0038                	addi	a4,sp,8
ffffffffc020a088:	854a                	mv	a0,s2
ffffffffc020a08a:	e442                	sd	a6,8(sp)
ffffffffc020a08c:	dd7ff0ef          	jal	ra,ffffffffc0209e62 <sfs_io_nolock>
ffffffffc020a090:	65a2                	ld	a1,8(sp)
ffffffffc020a092:	842a                	mv	s0,a0
ffffffffc020a094:	ed81                	bnez	a1,ffffffffc020a0ac <sfs_read+0x66>
ffffffffc020a096:	854e                	mv	a0,s3
ffffffffc020a098:	eaefa0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020a09c:	70e2                	ld	ra,56(sp)
ffffffffc020a09e:	8522                	mv	a0,s0
ffffffffc020a0a0:	7442                	ld	s0,48(sp)
ffffffffc020a0a2:	74a2                	ld	s1,40(sp)
ffffffffc020a0a4:	7902                	ld	s2,32(sp)
ffffffffc020a0a6:	69e2                	ld	s3,24(sp)
ffffffffc020a0a8:	6121                	addi	sp,sp,64
ffffffffc020a0aa:	8082                	ret
ffffffffc020a0ac:	8526                	mv	a0,s1
ffffffffc020a0ae:	ef4fb0ef          	jal	ra,ffffffffc02057a2 <iobuf_skip>
ffffffffc020a0b2:	b7d5                	j	ffffffffc020a096 <sfs_read+0x50>
ffffffffc020a0b4:	00005697          	auipc	a3,0x5
ffffffffc020a0b8:	a4c68693          	addi	a3,a3,-1460 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc020a0bc:	00002617          	auipc	a2,0x2
ffffffffc020a0c0:	85c60613          	addi	a2,a2,-1956 # ffffffffc020b918 <commands+0x250>
ffffffffc020a0c4:	2ae00593          	li	a1,686
ffffffffc020a0c8:	00005517          	auipc	a0,0x5
ffffffffc020a0cc:	c1850513          	addi	a0,a0,-1000 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a0d0:	95ef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a0d4:	859ff0ef          	jal	ra,ffffffffc020992c <sfs_io.part.0>

ffffffffc020a0d8 <sfs_write>:
ffffffffc020a0d8:	7139                	addi	sp,sp,-64
ffffffffc020a0da:	f04a                	sd	s2,32(sp)
ffffffffc020a0dc:	06853903          	ld	s2,104(a0)
ffffffffc020a0e0:	fc06                	sd	ra,56(sp)
ffffffffc020a0e2:	f822                	sd	s0,48(sp)
ffffffffc020a0e4:	f426                	sd	s1,40(sp)
ffffffffc020a0e6:	ec4e                	sd	s3,24(sp)
ffffffffc020a0e8:	04090f63          	beqz	s2,ffffffffc020a146 <sfs_write+0x6e>
ffffffffc020a0ec:	0b092783          	lw	a5,176(s2)
ffffffffc020a0f0:	ebb9                	bnez	a5,ffffffffc020a146 <sfs_write+0x6e>
ffffffffc020a0f2:	4d38                	lw	a4,88(a0)
ffffffffc020a0f4:	6785                	lui	a5,0x1
ffffffffc020a0f6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a0fa:	842a                	mv	s0,a0
ffffffffc020a0fc:	06f71563          	bne	a4,a5,ffffffffc020a166 <sfs_write+0x8e>
ffffffffc020a100:	02050993          	addi	s3,a0,32
ffffffffc020a104:	854e                	mv	a0,s3
ffffffffc020a106:	84ae                	mv	s1,a1
ffffffffc020a108:	e42fa0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc020a10c:	0184b803          	ld	a6,24(s1)
ffffffffc020a110:	6494                	ld	a3,8(s1)
ffffffffc020a112:	6090                	ld	a2,0(s1)
ffffffffc020a114:	85a2                	mv	a1,s0
ffffffffc020a116:	4785                	li	a5,1
ffffffffc020a118:	0038                	addi	a4,sp,8
ffffffffc020a11a:	854a                	mv	a0,s2
ffffffffc020a11c:	e442                	sd	a6,8(sp)
ffffffffc020a11e:	d45ff0ef          	jal	ra,ffffffffc0209e62 <sfs_io_nolock>
ffffffffc020a122:	65a2                	ld	a1,8(sp)
ffffffffc020a124:	842a                	mv	s0,a0
ffffffffc020a126:	ed81                	bnez	a1,ffffffffc020a13e <sfs_write+0x66>
ffffffffc020a128:	854e                	mv	a0,s3
ffffffffc020a12a:	e1cfa0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020a12e:	70e2                	ld	ra,56(sp)
ffffffffc020a130:	8522                	mv	a0,s0
ffffffffc020a132:	7442                	ld	s0,48(sp)
ffffffffc020a134:	74a2                	ld	s1,40(sp)
ffffffffc020a136:	7902                	ld	s2,32(sp)
ffffffffc020a138:	69e2                	ld	s3,24(sp)
ffffffffc020a13a:	6121                	addi	sp,sp,64
ffffffffc020a13c:	8082                	ret
ffffffffc020a13e:	8526                	mv	a0,s1
ffffffffc020a140:	e62fb0ef          	jal	ra,ffffffffc02057a2 <iobuf_skip>
ffffffffc020a144:	b7d5                	j	ffffffffc020a128 <sfs_write+0x50>
ffffffffc020a146:	00005697          	auipc	a3,0x5
ffffffffc020a14a:	9ba68693          	addi	a3,a3,-1606 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc020a14e:	00001617          	auipc	a2,0x1
ffffffffc020a152:	7ca60613          	addi	a2,a2,1994 # ffffffffc020b918 <commands+0x250>
ffffffffc020a156:	2ae00593          	li	a1,686
ffffffffc020a15a:	00005517          	auipc	a0,0x5
ffffffffc020a15e:	b8650513          	addi	a0,a0,-1146 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a162:	8ccf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a166:	fc6ff0ef          	jal	ra,ffffffffc020992c <sfs_io.part.0>

ffffffffc020a16a <sfs_dirent_read_nolock>:
ffffffffc020a16a:	6198                	ld	a4,0(a1)
ffffffffc020a16c:	7179                	addi	sp,sp,-48
ffffffffc020a16e:	f406                	sd	ra,40(sp)
ffffffffc020a170:	00475883          	lhu	a7,4(a4) # 8000004 <_binary_bin_sfs_img_size+0x7f8ad04>
ffffffffc020a174:	f022                	sd	s0,32(sp)
ffffffffc020a176:	ec26                	sd	s1,24(sp)
ffffffffc020a178:	4809                	li	a6,2
ffffffffc020a17a:	05089b63          	bne	a7,a6,ffffffffc020a1d0 <sfs_dirent_read_nolock+0x66>
ffffffffc020a17e:	4718                	lw	a4,8(a4)
ffffffffc020a180:	87b2                	mv	a5,a2
ffffffffc020a182:	2601                	sext.w	a2,a2
ffffffffc020a184:	04e7f663          	bgeu	a5,a4,ffffffffc020a1d0 <sfs_dirent_read_nolock+0x66>
ffffffffc020a188:	84b6                	mv	s1,a3
ffffffffc020a18a:	0074                	addi	a3,sp,12
ffffffffc020a18c:	842a                	mv	s0,a0
ffffffffc020a18e:	a7dff0ef          	jal	ra,ffffffffc0209c0a <sfs_bmap_load_nolock>
ffffffffc020a192:	c511                	beqz	a0,ffffffffc020a19e <sfs_dirent_read_nolock+0x34>
ffffffffc020a194:	70a2                	ld	ra,40(sp)
ffffffffc020a196:	7402                	ld	s0,32(sp)
ffffffffc020a198:	64e2                	ld	s1,24(sp)
ffffffffc020a19a:	6145                	addi	sp,sp,48
ffffffffc020a19c:	8082                	ret
ffffffffc020a19e:	45b2                	lw	a1,12(sp)
ffffffffc020a1a0:	4054                	lw	a3,4(s0)
ffffffffc020a1a2:	c5b9                	beqz	a1,ffffffffc020a1f0 <sfs_dirent_read_nolock+0x86>
ffffffffc020a1a4:	04d5f663          	bgeu	a1,a3,ffffffffc020a1f0 <sfs_dirent_read_nolock+0x86>
ffffffffc020a1a8:	7c08                	ld	a0,56(s0)
ffffffffc020a1aa:	433000ef          	jal	ra,ffffffffc020addc <bitmap_test>
ffffffffc020a1ae:	ed31                	bnez	a0,ffffffffc020a20a <sfs_dirent_read_nolock+0xa0>
ffffffffc020a1b0:	46b2                	lw	a3,12(sp)
ffffffffc020a1b2:	4701                	li	a4,0
ffffffffc020a1b4:	10400613          	li	a2,260
ffffffffc020a1b8:	85a6                	mv	a1,s1
ffffffffc020a1ba:	8522                	mv	a0,s0
ffffffffc020a1bc:	d09fe0ef          	jal	ra,ffffffffc0208ec4 <sfs_rbuf>
ffffffffc020a1c0:	f971                	bnez	a0,ffffffffc020a194 <sfs_dirent_read_nolock+0x2a>
ffffffffc020a1c2:	100481a3          	sb	zero,259(s1)
ffffffffc020a1c6:	70a2                	ld	ra,40(sp)
ffffffffc020a1c8:	7402                	ld	s0,32(sp)
ffffffffc020a1ca:	64e2                	ld	s1,24(sp)
ffffffffc020a1cc:	6145                	addi	sp,sp,48
ffffffffc020a1ce:	8082                	ret
ffffffffc020a1d0:	00005697          	auipc	a3,0x5
ffffffffc020a1d4:	ca068693          	addi	a3,a3,-864 # ffffffffc020ee70 <dev_node_ops+0x4c0>
ffffffffc020a1d8:	00001617          	auipc	a2,0x1
ffffffffc020a1dc:	74060613          	addi	a2,a2,1856 # ffffffffc020b918 <commands+0x250>
ffffffffc020a1e0:	18e00593          	li	a1,398
ffffffffc020a1e4:	00005517          	auipc	a0,0x5
ffffffffc020a1e8:	afc50513          	addi	a0,a0,-1284 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a1ec:	842f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a1f0:	872e                	mv	a4,a1
ffffffffc020a1f2:	00005617          	auipc	a2,0x5
ffffffffc020a1f6:	b1e60613          	addi	a2,a2,-1250 # ffffffffc020ed10 <dev_node_ops+0x360>
ffffffffc020a1fa:	05300593          	li	a1,83
ffffffffc020a1fe:	00005517          	auipc	a0,0x5
ffffffffc020a202:	ae250513          	addi	a0,a0,-1310 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a206:	828f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a20a:	00005697          	auipc	a3,0x5
ffffffffc020a20e:	b3e68693          	addi	a3,a3,-1218 # ffffffffc020ed48 <dev_node_ops+0x398>
ffffffffc020a212:	00001617          	auipc	a2,0x1
ffffffffc020a216:	70660613          	addi	a2,a2,1798 # ffffffffc020b918 <commands+0x250>
ffffffffc020a21a:	19500593          	li	a1,405
ffffffffc020a21e:	00005517          	auipc	a0,0x5
ffffffffc020a222:	ac250513          	addi	a0,a0,-1342 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a226:	808f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a22a <sfs_getdirentry>:
ffffffffc020a22a:	715d                	addi	sp,sp,-80
ffffffffc020a22c:	ec56                	sd	s5,24(sp)
ffffffffc020a22e:	8aaa                	mv	s5,a0
ffffffffc020a230:	10400513          	li	a0,260
ffffffffc020a234:	e85a                	sd	s6,16(sp)
ffffffffc020a236:	e486                	sd	ra,72(sp)
ffffffffc020a238:	e0a2                	sd	s0,64(sp)
ffffffffc020a23a:	fc26                	sd	s1,56(sp)
ffffffffc020a23c:	f84a                	sd	s2,48(sp)
ffffffffc020a23e:	f44e                	sd	s3,40(sp)
ffffffffc020a240:	f052                	sd	s4,32(sp)
ffffffffc020a242:	e45e                	sd	s7,8(sp)
ffffffffc020a244:	e062                	sd	s8,0(sp)
ffffffffc020a246:	8b2e                	mv	s6,a1
ffffffffc020a248:	d7af90ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc020a24c:	cd61                	beqz	a0,ffffffffc020a324 <sfs_getdirentry+0xfa>
ffffffffc020a24e:	068abb83          	ld	s7,104(s5)
ffffffffc020a252:	0c0b8b63          	beqz	s7,ffffffffc020a328 <sfs_getdirentry+0xfe>
ffffffffc020a256:	0b0ba783          	lw	a5,176(s7) # 10b0 <_binary_bin_swap_img_size-0x6c50>
ffffffffc020a25a:	e7f9                	bnez	a5,ffffffffc020a328 <sfs_getdirentry+0xfe>
ffffffffc020a25c:	058aa703          	lw	a4,88(s5)
ffffffffc020a260:	6785                	lui	a5,0x1
ffffffffc020a262:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a266:	0ef71163          	bne	a4,a5,ffffffffc020a348 <sfs_getdirentry+0x11e>
ffffffffc020a26a:	008b3983          	ld	s3,8(s6)
ffffffffc020a26e:	892a                	mv	s2,a0
ffffffffc020a270:	0a09c163          	bltz	s3,ffffffffc020a312 <sfs_getdirentry+0xe8>
ffffffffc020a274:	0ff9f793          	zext.b	a5,s3
ffffffffc020a278:	efc9                	bnez	a5,ffffffffc020a312 <sfs_getdirentry+0xe8>
ffffffffc020a27a:	000ab783          	ld	a5,0(s5)
ffffffffc020a27e:	0089d993          	srli	s3,s3,0x8
ffffffffc020a282:	2981                	sext.w	s3,s3
ffffffffc020a284:	479c                	lw	a5,8(a5)
ffffffffc020a286:	0937eb63          	bltu	a5,s3,ffffffffc020a31c <sfs_getdirentry+0xf2>
ffffffffc020a28a:	020a8c13          	addi	s8,s5,32
ffffffffc020a28e:	8562                	mv	a0,s8
ffffffffc020a290:	cbafa0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc020a294:	000ab783          	ld	a5,0(s5)
ffffffffc020a298:	0087aa03          	lw	s4,8(a5)
ffffffffc020a29c:	07405663          	blez	s4,ffffffffc020a308 <sfs_getdirentry+0xde>
ffffffffc020a2a0:	4481                	li	s1,0
ffffffffc020a2a2:	a811                	j	ffffffffc020a2b6 <sfs_getdirentry+0x8c>
ffffffffc020a2a4:	00092783          	lw	a5,0(s2)
ffffffffc020a2a8:	c781                	beqz	a5,ffffffffc020a2b0 <sfs_getdirentry+0x86>
ffffffffc020a2aa:	02098263          	beqz	s3,ffffffffc020a2ce <sfs_getdirentry+0xa4>
ffffffffc020a2ae:	39fd                	addiw	s3,s3,-1
ffffffffc020a2b0:	2485                	addiw	s1,s1,1
ffffffffc020a2b2:	049a0b63          	beq	s4,s1,ffffffffc020a308 <sfs_getdirentry+0xde>
ffffffffc020a2b6:	86ca                	mv	a3,s2
ffffffffc020a2b8:	8626                	mv	a2,s1
ffffffffc020a2ba:	85d6                	mv	a1,s5
ffffffffc020a2bc:	855e                	mv	a0,s7
ffffffffc020a2be:	eadff0ef          	jal	ra,ffffffffc020a16a <sfs_dirent_read_nolock>
ffffffffc020a2c2:	842a                	mv	s0,a0
ffffffffc020a2c4:	d165                	beqz	a0,ffffffffc020a2a4 <sfs_getdirentry+0x7a>
ffffffffc020a2c6:	8562                	mv	a0,s8
ffffffffc020a2c8:	c7efa0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020a2cc:	a831                	j	ffffffffc020a2e8 <sfs_getdirentry+0xbe>
ffffffffc020a2ce:	8562                	mv	a0,s8
ffffffffc020a2d0:	c76fa0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020a2d4:	4701                	li	a4,0
ffffffffc020a2d6:	4685                	li	a3,1
ffffffffc020a2d8:	10000613          	li	a2,256
ffffffffc020a2dc:	00490593          	addi	a1,s2,4
ffffffffc020a2e0:	855a                	mv	a0,s6
ffffffffc020a2e2:	c54fb0ef          	jal	ra,ffffffffc0205736 <iobuf_move>
ffffffffc020a2e6:	842a                	mv	s0,a0
ffffffffc020a2e8:	854a                	mv	a0,s2
ffffffffc020a2ea:	d88f90ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020a2ee:	60a6                	ld	ra,72(sp)
ffffffffc020a2f0:	8522                	mv	a0,s0
ffffffffc020a2f2:	6406                	ld	s0,64(sp)
ffffffffc020a2f4:	74e2                	ld	s1,56(sp)
ffffffffc020a2f6:	7942                	ld	s2,48(sp)
ffffffffc020a2f8:	79a2                	ld	s3,40(sp)
ffffffffc020a2fa:	7a02                	ld	s4,32(sp)
ffffffffc020a2fc:	6ae2                	ld	s5,24(sp)
ffffffffc020a2fe:	6b42                	ld	s6,16(sp)
ffffffffc020a300:	6ba2                	ld	s7,8(sp)
ffffffffc020a302:	6c02                	ld	s8,0(sp)
ffffffffc020a304:	6161                	addi	sp,sp,80
ffffffffc020a306:	8082                	ret
ffffffffc020a308:	8562                	mv	a0,s8
ffffffffc020a30a:	5441                	li	s0,-16
ffffffffc020a30c:	c3afa0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020a310:	bfe1                	j	ffffffffc020a2e8 <sfs_getdirentry+0xbe>
ffffffffc020a312:	854a                	mv	a0,s2
ffffffffc020a314:	d5ef90ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020a318:	5475                	li	s0,-3
ffffffffc020a31a:	bfd1                	j	ffffffffc020a2ee <sfs_getdirentry+0xc4>
ffffffffc020a31c:	d56f90ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020a320:	5441                	li	s0,-16
ffffffffc020a322:	b7f1                	j	ffffffffc020a2ee <sfs_getdirentry+0xc4>
ffffffffc020a324:	5471                	li	s0,-4
ffffffffc020a326:	b7e1                	j	ffffffffc020a2ee <sfs_getdirentry+0xc4>
ffffffffc020a328:	00004697          	auipc	a3,0x4
ffffffffc020a32c:	7d868693          	addi	a3,a3,2008 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc020a330:	00001617          	auipc	a2,0x1
ffffffffc020a334:	5e860613          	addi	a2,a2,1512 # ffffffffc020b918 <commands+0x250>
ffffffffc020a338:	35200593          	li	a1,850
ffffffffc020a33c:	00005517          	auipc	a0,0x5
ffffffffc020a340:	9a450513          	addi	a0,a0,-1628 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a344:	eebf50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a348:	00005697          	auipc	a3,0x5
ffffffffc020a34c:	96068693          	addi	a3,a3,-1696 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc020a350:	00001617          	auipc	a2,0x1
ffffffffc020a354:	5c860613          	addi	a2,a2,1480 # ffffffffc020b918 <commands+0x250>
ffffffffc020a358:	35300593          	li	a1,851
ffffffffc020a35c:	00005517          	auipc	a0,0x5
ffffffffc020a360:	98450513          	addi	a0,a0,-1660 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a364:	ecbf50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a368 <sfs_dirent_search_nolock.constprop.0>:
ffffffffc020a368:	715d                	addi	sp,sp,-80
ffffffffc020a36a:	f052                	sd	s4,32(sp)
ffffffffc020a36c:	8a2a                	mv	s4,a0
ffffffffc020a36e:	8532                	mv	a0,a2
ffffffffc020a370:	f44e                	sd	s3,40(sp)
ffffffffc020a372:	e85a                	sd	s6,16(sp)
ffffffffc020a374:	e45e                	sd	s7,8(sp)
ffffffffc020a376:	e486                	sd	ra,72(sp)
ffffffffc020a378:	e0a2                	sd	s0,64(sp)
ffffffffc020a37a:	fc26                	sd	s1,56(sp)
ffffffffc020a37c:	f84a                	sd	s2,48(sp)
ffffffffc020a37e:	ec56                	sd	s5,24(sp)
ffffffffc020a380:	e062                	sd	s8,0(sp)
ffffffffc020a382:	8b32                	mv	s6,a2
ffffffffc020a384:	89ae                	mv	s3,a1
ffffffffc020a386:	8bb6                	mv	s7,a3
ffffffffc020a388:	2f7000ef          	jal	ra,ffffffffc020ae7e <strlen>
ffffffffc020a38c:	0ff00793          	li	a5,255
ffffffffc020a390:	06a7ef63          	bltu	a5,a0,ffffffffc020a40e <sfs_dirent_search_nolock.constprop.0+0xa6>
ffffffffc020a394:	10400513          	li	a0,260
ffffffffc020a398:	c2af90ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc020a39c:	892a                	mv	s2,a0
ffffffffc020a39e:	c535                	beqz	a0,ffffffffc020a40a <sfs_dirent_search_nolock.constprop.0+0xa2>
ffffffffc020a3a0:	0009b783          	ld	a5,0(s3)
ffffffffc020a3a4:	0087aa83          	lw	s5,8(a5)
ffffffffc020a3a8:	05505a63          	blez	s5,ffffffffc020a3fc <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a3ac:	4481                	li	s1,0
ffffffffc020a3ae:	00450c13          	addi	s8,a0,4
ffffffffc020a3b2:	a829                	j	ffffffffc020a3cc <sfs_dirent_search_nolock.constprop.0+0x64>
ffffffffc020a3b4:	00092783          	lw	a5,0(s2)
ffffffffc020a3b8:	c799                	beqz	a5,ffffffffc020a3c6 <sfs_dirent_search_nolock.constprop.0+0x5e>
ffffffffc020a3ba:	85e2                	mv	a1,s8
ffffffffc020a3bc:	855a                	mv	a0,s6
ffffffffc020a3be:	309000ef          	jal	ra,ffffffffc020aec6 <strcmp>
ffffffffc020a3c2:	842a                	mv	s0,a0
ffffffffc020a3c4:	cd15                	beqz	a0,ffffffffc020a400 <sfs_dirent_search_nolock.constprop.0+0x98>
ffffffffc020a3c6:	2485                	addiw	s1,s1,1
ffffffffc020a3c8:	029a8a63          	beq	s5,s1,ffffffffc020a3fc <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a3cc:	86ca                	mv	a3,s2
ffffffffc020a3ce:	8626                	mv	a2,s1
ffffffffc020a3d0:	85ce                	mv	a1,s3
ffffffffc020a3d2:	8552                	mv	a0,s4
ffffffffc020a3d4:	d97ff0ef          	jal	ra,ffffffffc020a16a <sfs_dirent_read_nolock>
ffffffffc020a3d8:	842a                	mv	s0,a0
ffffffffc020a3da:	dd69                	beqz	a0,ffffffffc020a3b4 <sfs_dirent_search_nolock.constprop.0+0x4c>
ffffffffc020a3dc:	854a                	mv	a0,s2
ffffffffc020a3de:	c94f90ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020a3e2:	60a6                	ld	ra,72(sp)
ffffffffc020a3e4:	8522                	mv	a0,s0
ffffffffc020a3e6:	6406                	ld	s0,64(sp)
ffffffffc020a3e8:	74e2                	ld	s1,56(sp)
ffffffffc020a3ea:	7942                	ld	s2,48(sp)
ffffffffc020a3ec:	79a2                	ld	s3,40(sp)
ffffffffc020a3ee:	7a02                	ld	s4,32(sp)
ffffffffc020a3f0:	6ae2                	ld	s5,24(sp)
ffffffffc020a3f2:	6b42                	ld	s6,16(sp)
ffffffffc020a3f4:	6ba2                	ld	s7,8(sp)
ffffffffc020a3f6:	6c02                	ld	s8,0(sp)
ffffffffc020a3f8:	6161                	addi	sp,sp,80
ffffffffc020a3fa:	8082                	ret
ffffffffc020a3fc:	5441                	li	s0,-16
ffffffffc020a3fe:	bff9                	j	ffffffffc020a3dc <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a400:	00092783          	lw	a5,0(s2)
ffffffffc020a404:	00fba023          	sw	a5,0(s7)
ffffffffc020a408:	bfd1                	j	ffffffffc020a3dc <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a40a:	5471                	li	s0,-4
ffffffffc020a40c:	bfd9                	j	ffffffffc020a3e2 <sfs_dirent_search_nolock.constprop.0+0x7a>
ffffffffc020a40e:	00005697          	auipc	a3,0x5
ffffffffc020a412:	ab268693          	addi	a3,a3,-1358 # ffffffffc020eec0 <dev_node_ops+0x510>
ffffffffc020a416:	00001617          	auipc	a2,0x1
ffffffffc020a41a:	50260613          	addi	a2,a2,1282 # ffffffffc020b918 <commands+0x250>
ffffffffc020a41e:	1ba00593          	li	a1,442
ffffffffc020a422:	00005517          	auipc	a0,0x5
ffffffffc020a426:	8be50513          	addi	a0,a0,-1858 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a42a:	e05f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a42e <sfs_truncfile>:
ffffffffc020a42e:	7175                	addi	sp,sp,-144
ffffffffc020a430:	e506                	sd	ra,136(sp)
ffffffffc020a432:	e122                	sd	s0,128(sp)
ffffffffc020a434:	fca6                	sd	s1,120(sp)
ffffffffc020a436:	f8ca                	sd	s2,112(sp)
ffffffffc020a438:	f4ce                	sd	s3,104(sp)
ffffffffc020a43a:	f0d2                	sd	s4,96(sp)
ffffffffc020a43c:	ecd6                	sd	s5,88(sp)
ffffffffc020a43e:	e8da                	sd	s6,80(sp)
ffffffffc020a440:	e4de                	sd	s7,72(sp)
ffffffffc020a442:	e0e2                	sd	s8,64(sp)
ffffffffc020a444:	fc66                	sd	s9,56(sp)
ffffffffc020a446:	f86a                	sd	s10,48(sp)
ffffffffc020a448:	f46e                	sd	s11,40(sp)
ffffffffc020a44a:	080007b7          	lui	a5,0x8000
ffffffffc020a44e:	16b7e463          	bltu	a5,a1,ffffffffc020a5b6 <sfs_truncfile+0x188>
ffffffffc020a452:	06853c83          	ld	s9,104(a0)
ffffffffc020a456:	89aa                	mv	s3,a0
ffffffffc020a458:	160c8163          	beqz	s9,ffffffffc020a5ba <sfs_truncfile+0x18c>
ffffffffc020a45c:	0b0ca783          	lw	a5,176(s9) # 80000b0 <_binary_bin_sfs_img_size+0x7f8adb0>
ffffffffc020a460:	14079d63          	bnez	a5,ffffffffc020a5ba <sfs_truncfile+0x18c>
ffffffffc020a464:	4d38                	lw	a4,88(a0)
ffffffffc020a466:	6405                	lui	s0,0x1
ffffffffc020a468:	23540793          	addi	a5,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a46c:	16f71763          	bne	a4,a5,ffffffffc020a5da <sfs_truncfile+0x1ac>
ffffffffc020a470:	00053a83          	ld	s5,0(a0)
ffffffffc020a474:	147d                	addi	s0,s0,-1
ffffffffc020a476:	942e                	add	s0,s0,a1
ffffffffc020a478:	000ae783          	lwu	a5,0(s5)
ffffffffc020a47c:	8031                	srli	s0,s0,0xc
ffffffffc020a47e:	8a2e                	mv	s4,a1
ffffffffc020a480:	2401                	sext.w	s0,s0
ffffffffc020a482:	02b79763          	bne	a5,a1,ffffffffc020a4b0 <sfs_truncfile+0x82>
ffffffffc020a486:	008aa783          	lw	a5,8(s5)
ffffffffc020a48a:	4901                	li	s2,0
ffffffffc020a48c:	18879763          	bne	a5,s0,ffffffffc020a61a <sfs_truncfile+0x1ec>
ffffffffc020a490:	60aa                	ld	ra,136(sp)
ffffffffc020a492:	640a                	ld	s0,128(sp)
ffffffffc020a494:	74e6                	ld	s1,120(sp)
ffffffffc020a496:	79a6                	ld	s3,104(sp)
ffffffffc020a498:	7a06                	ld	s4,96(sp)
ffffffffc020a49a:	6ae6                	ld	s5,88(sp)
ffffffffc020a49c:	6b46                	ld	s6,80(sp)
ffffffffc020a49e:	6ba6                	ld	s7,72(sp)
ffffffffc020a4a0:	6c06                	ld	s8,64(sp)
ffffffffc020a4a2:	7ce2                	ld	s9,56(sp)
ffffffffc020a4a4:	7d42                	ld	s10,48(sp)
ffffffffc020a4a6:	7da2                	ld	s11,40(sp)
ffffffffc020a4a8:	854a                	mv	a0,s2
ffffffffc020a4aa:	7946                	ld	s2,112(sp)
ffffffffc020a4ac:	6149                	addi	sp,sp,144
ffffffffc020a4ae:	8082                	ret
ffffffffc020a4b0:	02050b13          	addi	s6,a0,32
ffffffffc020a4b4:	855a                	mv	a0,s6
ffffffffc020a4b6:	a94fa0ef          	jal	ra,ffffffffc020474a <down>
ffffffffc020a4ba:	008aa483          	lw	s1,8(s5)
ffffffffc020a4be:	0a84e663          	bltu	s1,s0,ffffffffc020a56a <sfs_truncfile+0x13c>
ffffffffc020a4c2:	0c947163          	bgeu	s0,s1,ffffffffc020a584 <sfs_truncfile+0x156>
ffffffffc020a4c6:	4dad                	li	s11,11
ffffffffc020a4c8:	4b85                	li	s7,1
ffffffffc020a4ca:	a09d                	j	ffffffffc020a530 <sfs_truncfile+0x102>
ffffffffc020a4cc:	ff37091b          	addiw	s2,a4,-13
ffffffffc020a4d0:	0009079b          	sext.w	a5,s2
ffffffffc020a4d4:	3ff00713          	li	a4,1023
ffffffffc020a4d8:	04f76563          	bltu	a4,a5,ffffffffc020a522 <sfs_truncfile+0xf4>
ffffffffc020a4dc:	03cd2c03          	lw	s8,60(s10)
ffffffffc020a4e0:	040c0163          	beqz	s8,ffffffffc020a522 <sfs_truncfile+0xf4>
ffffffffc020a4e4:	004ca783          	lw	a5,4(s9)
ffffffffc020a4e8:	18fc7963          	bgeu	s8,a5,ffffffffc020a67a <sfs_truncfile+0x24c>
ffffffffc020a4ec:	038cb503          	ld	a0,56(s9)
ffffffffc020a4f0:	85e2                	mv	a1,s8
ffffffffc020a4f2:	0eb000ef          	jal	ra,ffffffffc020addc <bitmap_test>
ffffffffc020a4f6:	16051263          	bnez	a0,ffffffffc020a65a <sfs_truncfile+0x22c>
ffffffffc020a4fa:	02091793          	slli	a5,s2,0x20
ffffffffc020a4fe:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a502:	86e2                	mv	a3,s8
ffffffffc020a504:	4611                	li	a2,4
ffffffffc020a506:	082c                	addi	a1,sp,24
ffffffffc020a508:	8566                	mv	a0,s9
ffffffffc020a50a:	e43a                	sd	a4,8(sp)
ffffffffc020a50c:	ce02                	sw	zero,28(sp)
ffffffffc020a50e:	9b7fe0ef          	jal	ra,ffffffffc0208ec4 <sfs_rbuf>
ffffffffc020a512:	892a                	mv	s2,a0
ffffffffc020a514:	e141                	bnez	a0,ffffffffc020a594 <sfs_truncfile+0x166>
ffffffffc020a516:	47e2                	lw	a5,24(sp)
ffffffffc020a518:	6722                	ld	a4,8(sp)
ffffffffc020a51a:	e3c9                	bnez	a5,ffffffffc020a59c <sfs_truncfile+0x16e>
ffffffffc020a51c:	008d2603          	lw	a2,8(s10)
ffffffffc020a520:	367d                	addiw	a2,a2,-1
ffffffffc020a522:	00cd2423          	sw	a2,8(s10)
ffffffffc020a526:	0179b823          	sd	s7,16(s3)
ffffffffc020a52a:	34fd                	addiw	s1,s1,-1
ffffffffc020a52c:	04940a63          	beq	s0,s1,ffffffffc020a580 <sfs_truncfile+0x152>
ffffffffc020a530:	0009bd03          	ld	s10,0(s3)
ffffffffc020a534:	008d2703          	lw	a4,8(s10)
ffffffffc020a538:	c369                	beqz	a4,ffffffffc020a5fa <sfs_truncfile+0x1cc>
ffffffffc020a53a:	fff7079b          	addiw	a5,a4,-1
ffffffffc020a53e:	0007861b          	sext.w	a2,a5
ffffffffc020a542:	f8cde5e3          	bltu	s11,a2,ffffffffc020a4cc <sfs_truncfile+0x9e>
ffffffffc020a546:	02079713          	slli	a4,a5,0x20
ffffffffc020a54a:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a54e:	00fd0933          	add	s2,s10,a5
ffffffffc020a552:	00c92583          	lw	a1,12(s2)
ffffffffc020a556:	d5f1                	beqz	a1,ffffffffc020a522 <sfs_truncfile+0xf4>
ffffffffc020a558:	8566                	mv	a0,s9
ffffffffc020a55a:	bf6ff0ef          	jal	ra,ffffffffc0209950 <sfs_block_free>
ffffffffc020a55e:	00092623          	sw	zero,12(s2)
ffffffffc020a562:	008d2603          	lw	a2,8(s10)
ffffffffc020a566:	367d                	addiw	a2,a2,-1
ffffffffc020a568:	bf6d                	j	ffffffffc020a522 <sfs_truncfile+0xf4>
ffffffffc020a56a:	4681                	li	a3,0
ffffffffc020a56c:	8626                	mv	a2,s1
ffffffffc020a56e:	85ce                	mv	a1,s3
ffffffffc020a570:	8566                	mv	a0,s9
ffffffffc020a572:	e98ff0ef          	jal	ra,ffffffffc0209c0a <sfs_bmap_load_nolock>
ffffffffc020a576:	892a                	mv	s2,a0
ffffffffc020a578:	ed11                	bnez	a0,ffffffffc020a594 <sfs_truncfile+0x166>
ffffffffc020a57a:	2485                	addiw	s1,s1,1
ffffffffc020a57c:	fe9417e3          	bne	s0,s1,ffffffffc020a56a <sfs_truncfile+0x13c>
ffffffffc020a580:	008aa483          	lw	s1,8(s5)
ffffffffc020a584:	0a941b63          	bne	s0,s1,ffffffffc020a63a <sfs_truncfile+0x20c>
ffffffffc020a588:	014aa023          	sw	s4,0(s5)
ffffffffc020a58c:	4785                	li	a5,1
ffffffffc020a58e:	00f9b823          	sd	a5,16(s3)
ffffffffc020a592:	4901                	li	s2,0
ffffffffc020a594:	855a                	mv	a0,s6
ffffffffc020a596:	9b0fa0ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020a59a:	bddd                	j	ffffffffc020a490 <sfs_truncfile+0x62>
ffffffffc020a59c:	86e2                	mv	a3,s8
ffffffffc020a59e:	4611                	li	a2,4
ffffffffc020a5a0:	086c                	addi	a1,sp,28
ffffffffc020a5a2:	8566                	mv	a0,s9
ffffffffc020a5a4:	9a1fe0ef          	jal	ra,ffffffffc0208f44 <sfs_wbuf>
ffffffffc020a5a8:	892a                	mv	s2,a0
ffffffffc020a5aa:	f56d                	bnez	a0,ffffffffc020a594 <sfs_truncfile+0x166>
ffffffffc020a5ac:	45e2                	lw	a1,24(sp)
ffffffffc020a5ae:	8566                	mv	a0,s9
ffffffffc020a5b0:	ba0ff0ef          	jal	ra,ffffffffc0209950 <sfs_block_free>
ffffffffc020a5b4:	b7a5                	j	ffffffffc020a51c <sfs_truncfile+0xee>
ffffffffc020a5b6:	5975                	li	s2,-3
ffffffffc020a5b8:	bde1                	j	ffffffffc020a490 <sfs_truncfile+0x62>
ffffffffc020a5ba:	00004697          	auipc	a3,0x4
ffffffffc020a5be:	54668693          	addi	a3,a3,1350 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc020a5c2:	00001617          	auipc	a2,0x1
ffffffffc020a5c6:	35660613          	addi	a2,a2,854 # ffffffffc020b918 <commands+0x250>
ffffffffc020a5ca:	3c100593          	li	a1,961
ffffffffc020a5ce:	00004517          	auipc	a0,0x4
ffffffffc020a5d2:	71250513          	addi	a0,a0,1810 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a5d6:	c59f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a5da:	00004697          	auipc	a3,0x4
ffffffffc020a5de:	6ce68693          	addi	a3,a3,1742 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc020a5e2:	00001617          	auipc	a2,0x1
ffffffffc020a5e6:	33660613          	addi	a2,a2,822 # ffffffffc020b918 <commands+0x250>
ffffffffc020a5ea:	3c200593          	li	a1,962
ffffffffc020a5ee:	00004517          	auipc	a0,0x4
ffffffffc020a5f2:	6f250513          	addi	a0,a0,1778 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a5f6:	c39f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a5fa:	00005697          	auipc	a3,0x5
ffffffffc020a5fe:	90668693          	addi	a3,a3,-1786 # ffffffffc020ef00 <dev_node_ops+0x550>
ffffffffc020a602:	00001617          	auipc	a2,0x1
ffffffffc020a606:	31660613          	addi	a2,a2,790 # ffffffffc020b918 <commands+0x250>
ffffffffc020a60a:	17b00593          	li	a1,379
ffffffffc020a60e:	00004517          	auipc	a0,0x4
ffffffffc020a612:	6d250513          	addi	a0,a0,1746 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a616:	c19f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a61a:	00005697          	auipc	a3,0x5
ffffffffc020a61e:	8ce68693          	addi	a3,a3,-1842 # ffffffffc020eee8 <dev_node_ops+0x538>
ffffffffc020a622:	00001617          	auipc	a2,0x1
ffffffffc020a626:	2f660613          	addi	a2,a2,758 # ffffffffc020b918 <commands+0x250>
ffffffffc020a62a:	3c900593          	li	a1,969
ffffffffc020a62e:	00004517          	auipc	a0,0x4
ffffffffc020a632:	6b250513          	addi	a0,a0,1714 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a636:	bf9f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a63a:	00005697          	auipc	a3,0x5
ffffffffc020a63e:	91668693          	addi	a3,a3,-1770 # ffffffffc020ef50 <dev_node_ops+0x5a0>
ffffffffc020a642:	00001617          	auipc	a2,0x1
ffffffffc020a646:	2d660613          	addi	a2,a2,726 # ffffffffc020b918 <commands+0x250>
ffffffffc020a64a:	3e200593          	li	a1,994
ffffffffc020a64e:	00004517          	auipc	a0,0x4
ffffffffc020a652:	69250513          	addi	a0,a0,1682 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a656:	bd9f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a65a:	00005697          	auipc	a3,0x5
ffffffffc020a65e:	8be68693          	addi	a3,a3,-1858 # ffffffffc020ef18 <dev_node_ops+0x568>
ffffffffc020a662:	00001617          	auipc	a2,0x1
ffffffffc020a666:	2b660613          	addi	a2,a2,694 # ffffffffc020b918 <commands+0x250>
ffffffffc020a66a:	12b00593          	li	a1,299
ffffffffc020a66e:	00004517          	auipc	a0,0x4
ffffffffc020a672:	67250513          	addi	a0,a0,1650 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a676:	bb9f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a67a:	8762                	mv	a4,s8
ffffffffc020a67c:	86be                	mv	a3,a5
ffffffffc020a67e:	00004617          	auipc	a2,0x4
ffffffffc020a682:	69260613          	addi	a2,a2,1682 # ffffffffc020ed10 <dev_node_ops+0x360>
ffffffffc020a686:	05300593          	li	a1,83
ffffffffc020a68a:	00004517          	auipc	a0,0x4
ffffffffc020a68e:	65650513          	addi	a0,a0,1622 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a692:	b9df50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a696 <sfs_load_inode>:
ffffffffc020a696:	7139                	addi	sp,sp,-64
ffffffffc020a698:	fc06                	sd	ra,56(sp)
ffffffffc020a69a:	f822                	sd	s0,48(sp)
ffffffffc020a69c:	f426                	sd	s1,40(sp)
ffffffffc020a69e:	f04a                	sd	s2,32(sp)
ffffffffc020a6a0:	84b2                	mv	s1,a2
ffffffffc020a6a2:	892a                	mv	s2,a0
ffffffffc020a6a4:	ec4e                	sd	s3,24(sp)
ffffffffc020a6a6:	e852                	sd	s4,16(sp)
ffffffffc020a6a8:	89ae                	mv	s3,a1
ffffffffc020a6aa:	e456                	sd	s5,8(sp)
ffffffffc020a6ac:	a49fe0ef          	jal	ra,ffffffffc02090f4 <lock_sfs_fs>
ffffffffc020a6b0:	45a9                	li	a1,10
ffffffffc020a6b2:	8526                	mv	a0,s1
ffffffffc020a6b4:	0a893403          	ld	s0,168(s2)
ffffffffc020a6b8:	54f000ef          	jal	ra,ffffffffc020b406 <hash32>
ffffffffc020a6bc:	02051793          	slli	a5,a0,0x20
ffffffffc020a6c0:	01c7d713          	srli	a4,a5,0x1c
ffffffffc020a6c4:	9722                	add	a4,a4,s0
ffffffffc020a6c6:	843a                	mv	s0,a4
ffffffffc020a6c8:	a029                	j	ffffffffc020a6d2 <sfs_load_inode+0x3c>
ffffffffc020a6ca:	fc042783          	lw	a5,-64(s0)
ffffffffc020a6ce:	10978863          	beq	a5,s1,ffffffffc020a7de <sfs_load_inode+0x148>
ffffffffc020a6d2:	6400                	ld	s0,8(s0)
ffffffffc020a6d4:	fe871be3          	bne	a4,s0,ffffffffc020a6ca <sfs_load_inode+0x34>
ffffffffc020a6d8:	04000513          	li	a0,64
ffffffffc020a6dc:	8e6f90ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc020a6e0:	8aaa                	mv	s5,a0
ffffffffc020a6e2:	16050563          	beqz	a0,ffffffffc020a84c <sfs_load_inode+0x1b6>
ffffffffc020a6e6:	00492683          	lw	a3,4(s2)
ffffffffc020a6ea:	18048363          	beqz	s1,ffffffffc020a870 <sfs_load_inode+0x1da>
ffffffffc020a6ee:	18d4f163          	bgeu	s1,a3,ffffffffc020a870 <sfs_load_inode+0x1da>
ffffffffc020a6f2:	03893503          	ld	a0,56(s2)
ffffffffc020a6f6:	85a6                	mv	a1,s1
ffffffffc020a6f8:	6e4000ef          	jal	ra,ffffffffc020addc <bitmap_test>
ffffffffc020a6fc:	18051763          	bnez	a0,ffffffffc020a88a <sfs_load_inode+0x1f4>
ffffffffc020a700:	4701                	li	a4,0
ffffffffc020a702:	86a6                	mv	a3,s1
ffffffffc020a704:	04000613          	li	a2,64
ffffffffc020a708:	85d6                	mv	a1,s5
ffffffffc020a70a:	854a                	mv	a0,s2
ffffffffc020a70c:	fb8fe0ef          	jal	ra,ffffffffc0208ec4 <sfs_rbuf>
ffffffffc020a710:	842a                	mv	s0,a0
ffffffffc020a712:	0e051563          	bnez	a0,ffffffffc020a7fc <sfs_load_inode+0x166>
ffffffffc020a716:	006ad783          	lhu	a5,6(s5)
ffffffffc020a71a:	12078b63          	beqz	a5,ffffffffc020a850 <sfs_load_inode+0x1ba>
ffffffffc020a71e:	6405                	lui	s0,0x1
ffffffffc020a720:	23540513          	addi	a0,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a724:	f66fd0ef          	jal	ra,ffffffffc0207e8a <__alloc_inode>
ffffffffc020a728:	8a2a                	mv	s4,a0
ffffffffc020a72a:	c961                	beqz	a0,ffffffffc020a7fa <sfs_load_inode+0x164>
ffffffffc020a72c:	004ad683          	lhu	a3,4(s5)
ffffffffc020a730:	4785                	li	a5,1
ffffffffc020a732:	0cf69c63          	bne	a3,a5,ffffffffc020a80a <sfs_load_inode+0x174>
ffffffffc020a736:	864a                	mv	a2,s2
ffffffffc020a738:	00005597          	auipc	a1,0x5
ffffffffc020a73c:	92858593          	addi	a1,a1,-1752 # ffffffffc020f060 <sfs_node_fileops>
ffffffffc020a740:	f66fd0ef          	jal	ra,ffffffffc0207ea6 <inode_init>
ffffffffc020a744:	058a2783          	lw	a5,88(s4)
ffffffffc020a748:	23540413          	addi	s0,s0,565
ffffffffc020a74c:	0e879063          	bne	a5,s0,ffffffffc020a82c <sfs_load_inode+0x196>
ffffffffc020a750:	4785                	li	a5,1
ffffffffc020a752:	00fa2c23          	sw	a5,24(s4)
ffffffffc020a756:	015a3023          	sd	s5,0(s4)
ffffffffc020a75a:	009a2423          	sw	s1,8(s4)
ffffffffc020a75e:	000a3823          	sd	zero,16(s4)
ffffffffc020a762:	4585                	li	a1,1
ffffffffc020a764:	020a0513          	addi	a0,s4,32
ffffffffc020a768:	fd7f90ef          	jal	ra,ffffffffc020473e <sem_init>
ffffffffc020a76c:	058a2703          	lw	a4,88(s4)
ffffffffc020a770:	6785                	lui	a5,0x1
ffffffffc020a772:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a776:	14f71663          	bne	a4,a5,ffffffffc020a8c2 <sfs_load_inode+0x22c>
ffffffffc020a77a:	0a093703          	ld	a4,160(s2)
ffffffffc020a77e:	038a0793          	addi	a5,s4,56
ffffffffc020a782:	008a2503          	lw	a0,8(s4)
ffffffffc020a786:	e31c                	sd	a5,0(a4)
ffffffffc020a788:	0af93023          	sd	a5,160(s2)
ffffffffc020a78c:	09890793          	addi	a5,s2,152
ffffffffc020a790:	0a893403          	ld	s0,168(s2)
ffffffffc020a794:	45a9                	li	a1,10
ffffffffc020a796:	04ea3023          	sd	a4,64(s4)
ffffffffc020a79a:	02fa3c23          	sd	a5,56(s4)
ffffffffc020a79e:	469000ef          	jal	ra,ffffffffc020b406 <hash32>
ffffffffc020a7a2:	02051713          	slli	a4,a0,0x20
ffffffffc020a7a6:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a7aa:	97a2                	add	a5,a5,s0
ffffffffc020a7ac:	6798                	ld	a4,8(a5)
ffffffffc020a7ae:	048a0693          	addi	a3,s4,72
ffffffffc020a7b2:	e314                	sd	a3,0(a4)
ffffffffc020a7b4:	e794                	sd	a3,8(a5)
ffffffffc020a7b6:	04ea3823          	sd	a4,80(s4)
ffffffffc020a7ba:	04fa3423          	sd	a5,72(s4)
ffffffffc020a7be:	854a                	mv	a0,s2
ffffffffc020a7c0:	945fe0ef          	jal	ra,ffffffffc0209104 <unlock_sfs_fs>
ffffffffc020a7c4:	4401                	li	s0,0
ffffffffc020a7c6:	0149b023          	sd	s4,0(s3)
ffffffffc020a7ca:	70e2                	ld	ra,56(sp)
ffffffffc020a7cc:	8522                	mv	a0,s0
ffffffffc020a7ce:	7442                	ld	s0,48(sp)
ffffffffc020a7d0:	74a2                	ld	s1,40(sp)
ffffffffc020a7d2:	7902                	ld	s2,32(sp)
ffffffffc020a7d4:	69e2                	ld	s3,24(sp)
ffffffffc020a7d6:	6a42                	ld	s4,16(sp)
ffffffffc020a7d8:	6aa2                	ld	s5,8(sp)
ffffffffc020a7da:	6121                	addi	sp,sp,64
ffffffffc020a7dc:	8082                	ret
ffffffffc020a7de:	fb840a13          	addi	s4,s0,-72
ffffffffc020a7e2:	8552                	mv	a0,s4
ffffffffc020a7e4:	f24fd0ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc020a7e8:	4785                	li	a5,1
ffffffffc020a7ea:	fcf51ae3          	bne	a0,a5,ffffffffc020a7be <sfs_load_inode+0x128>
ffffffffc020a7ee:	fd042783          	lw	a5,-48(s0)
ffffffffc020a7f2:	2785                	addiw	a5,a5,1
ffffffffc020a7f4:	fcf42823          	sw	a5,-48(s0)
ffffffffc020a7f8:	b7d9                	j	ffffffffc020a7be <sfs_load_inode+0x128>
ffffffffc020a7fa:	5471                	li	s0,-4
ffffffffc020a7fc:	8556                	mv	a0,s5
ffffffffc020a7fe:	874f90ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020a802:	854a                	mv	a0,s2
ffffffffc020a804:	901fe0ef          	jal	ra,ffffffffc0209104 <unlock_sfs_fs>
ffffffffc020a808:	b7c9                	j	ffffffffc020a7ca <sfs_load_inode+0x134>
ffffffffc020a80a:	4789                	li	a5,2
ffffffffc020a80c:	08f69f63          	bne	a3,a5,ffffffffc020a8aa <sfs_load_inode+0x214>
ffffffffc020a810:	864a                	mv	a2,s2
ffffffffc020a812:	00004597          	auipc	a1,0x4
ffffffffc020a816:	7ce58593          	addi	a1,a1,1998 # ffffffffc020efe0 <sfs_node_dirops>
ffffffffc020a81a:	e8cfd0ef          	jal	ra,ffffffffc0207ea6 <inode_init>
ffffffffc020a81e:	058a2703          	lw	a4,88(s4)
ffffffffc020a822:	6785                	lui	a5,0x1
ffffffffc020a824:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a828:	f2f704e3          	beq	a4,a5,ffffffffc020a750 <sfs_load_inode+0xba>
ffffffffc020a82c:	00004697          	auipc	a3,0x4
ffffffffc020a830:	47c68693          	addi	a3,a3,1148 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc020a834:	00001617          	auipc	a2,0x1
ffffffffc020a838:	0e460613          	addi	a2,a2,228 # ffffffffc020b918 <commands+0x250>
ffffffffc020a83c:	07700593          	li	a1,119
ffffffffc020a840:	00004517          	auipc	a0,0x4
ffffffffc020a844:	4a050513          	addi	a0,a0,1184 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a848:	9e7f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a84c:	5471                	li	s0,-4
ffffffffc020a84e:	bf55                	j	ffffffffc020a802 <sfs_load_inode+0x16c>
ffffffffc020a850:	00004697          	auipc	a3,0x4
ffffffffc020a854:	71868693          	addi	a3,a3,1816 # ffffffffc020ef68 <dev_node_ops+0x5b8>
ffffffffc020a858:	00001617          	auipc	a2,0x1
ffffffffc020a85c:	0c060613          	addi	a2,a2,192 # ffffffffc020b918 <commands+0x250>
ffffffffc020a860:	0ad00593          	li	a1,173
ffffffffc020a864:	00004517          	auipc	a0,0x4
ffffffffc020a868:	47c50513          	addi	a0,a0,1148 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a86c:	9c3f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a870:	8726                	mv	a4,s1
ffffffffc020a872:	00004617          	auipc	a2,0x4
ffffffffc020a876:	49e60613          	addi	a2,a2,1182 # ffffffffc020ed10 <dev_node_ops+0x360>
ffffffffc020a87a:	05300593          	li	a1,83
ffffffffc020a87e:	00004517          	auipc	a0,0x4
ffffffffc020a882:	46250513          	addi	a0,a0,1122 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a886:	9a9f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a88a:	00004697          	auipc	a3,0x4
ffffffffc020a88e:	4be68693          	addi	a3,a3,1214 # ffffffffc020ed48 <dev_node_ops+0x398>
ffffffffc020a892:	00001617          	auipc	a2,0x1
ffffffffc020a896:	08660613          	addi	a2,a2,134 # ffffffffc020b918 <commands+0x250>
ffffffffc020a89a:	0a800593          	li	a1,168
ffffffffc020a89e:	00004517          	auipc	a0,0x4
ffffffffc020a8a2:	44250513          	addi	a0,a0,1090 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a8a6:	989f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a8aa:	00004617          	auipc	a2,0x4
ffffffffc020a8ae:	44e60613          	addi	a2,a2,1102 # ffffffffc020ecf8 <dev_node_ops+0x348>
ffffffffc020a8b2:	02e00593          	li	a1,46
ffffffffc020a8b6:	00004517          	auipc	a0,0x4
ffffffffc020a8ba:	42a50513          	addi	a0,a0,1066 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a8be:	971f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a8c2:	00004697          	auipc	a3,0x4
ffffffffc020a8c6:	3e668693          	addi	a3,a3,998 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc020a8ca:	00001617          	auipc	a2,0x1
ffffffffc020a8ce:	04e60613          	addi	a2,a2,78 # ffffffffc020b918 <commands+0x250>
ffffffffc020a8d2:	0b100593          	li	a1,177
ffffffffc020a8d6:	00004517          	auipc	a0,0x4
ffffffffc020a8da:	40a50513          	addi	a0,a0,1034 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a8de:	951f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a8e2 <sfs_lookup>:
ffffffffc020a8e2:	7139                	addi	sp,sp,-64
ffffffffc020a8e4:	ec4e                	sd	s3,24(sp)
ffffffffc020a8e6:	06853983          	ld	s3,104(a0)
ffffffffc020a8ea:	fc06                	sd	ra,56(sp)
ffffffffc020a8ec:	f822                	sd	s0,48(sp)
ffffffffc020a8ee:	f426                	sd	s1,40(sp)
ffffffffc020a8f0:	f04a                	sd	s2,32(sp)
ffffffffc020a8f2:	e852                	sd	s4,16(sp)
ffffffffc020a8f4:	0a098c63          	beqz	s3,ffffffffc020a9ac <sfs_lookup+0xca>
ffffffffc020a8f8:	0b09a783          	lw	a5,176(s3)
ffffffffc020a8fc:	ebc5                	bnez	a5,ffffffffc020a9ac <sfs_lookup+0xca>
ffffffffc020a8fe:	0005c783          	lbu	a5,0(a1)
ffffffffc020a902:	84ae                	mv	s1,a1
ffffffffc020a904:	c7c1                	beqz	a5,ffffffffc020a98c <sfs_lookup+0xaa>
ffffffffc020a906:	02f00713          	li	a4,47
ffffffffc020a90a:	08e78163          	beq	a5,a4,ffffffffc020a98c <sfs_lookup+0xaa>
ffffffffc020a90e:	842a                	mv	s0,a0
ffffffffc020a910:	8a32                	mv	s4,a2
ffffffffc020a912:	df6fd0ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc020a916:	4c38                	lw	a4,88(s0)
ffffffffc020a918:	6785                	lui	a5,0x1
ffffffffc020a91a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a91e:	0af71763          	bne	a4,a5,ffffffffc020a9cc <sfs_lookup+0xea>
ffffffffc020a922:	6018                	ld	a4,0(s0)
ffffffffc020a924:	4789                	li	a5,2
ffffffffc020a926:	00475703          	lhu	a4,4(a4)
ffffffffc020a92a:	04f71c63          	bne	a4,a5,ffffffffc020a982 <sfs_lookup+0xa0>
ffffffffc020a92e:	02040913          	addi	s2,s0,32
ffffffffc020a932:	854a                	mv	a0,s2
ffffffffc020a934:	e17f90ef          	jal	ra,ffffffffc020474a <down>
ffffffffc020a938:	8626                	mv	a2,s1
ffffffffc020a93a:	0054                	addi	a3,sp,4
ffffffffc020a93c:	85a2                	mv	a1,s0
ffffffffc020a93e:	854e                	mv	a0,s3
ffffffffc020a940:	a29ff0ef          	jal	ra,ffffffffc020a368 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020a944:	84aa                	mv	s1,a0
ffffffffc020a946:	854a                	mv	a0,s2
ffffffffc020a948:	dfff90ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020a94c:	cc89                	beqz	s1,ffffffffc020a966 <sfs_lookup+0x84>
ffffffffc020a94e:	8522                	mv	a0,s0
ffffffffc020a950:	e86fd0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc020a954:	70e2                	ld	ra,56(sp)
ffffffffc020a956:	7442                	ld	s0,48(sp)
ffffffffc020a958:	7902                	ld	s2,32(sp)
ffffffffc020a95a:	69e2                	ld	s3,24(sp)
ffffffffc020a95c:	6a42                	ld	s4,16(sp)
ffffffffc020a95e:	8526                	mv	a0,s1
ffffffffc020a960:	74a2                	ld	s1,40(sp)
ffffffffc020a962:	6121                	addi	sp,sp,64
ffffffffc020a964:	8082                	ret
ffffffffc020a966:	4612                	lw	a2,4(sp)
ffffffffc020a968:	002c                	addi	a1,sp,8
ffffffffc020a96a:	854e                	mv	a0,s3
ffffffffc020a96c:	d2bff0ef          	jal	ra,ffffffffc020a696 <sfs_load_inode>
ffffffffc020a970:	84aa                	mv	s1,a0
ffffffffc020a972:	8522                	mv	a0,s0
ffffffffc020a974:	e62fd0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc020a978:	fcf1                	bnez	s1,ffffffffc020a954 <sfs_lookup+0x72>
ffffffffc020a97a:	67a2                	ld	a5,8(sp)
ffffffffc020a97c:	00fa3023          	sd	a5,0(s4)
ffffffffc020a980:	bfd1                	j	ffffffffc020a954 <sfs_lookup+0x72>
ffffffffc020a982:	8522                	mv	a0,s0
ffffffffc020a984:	e52fd0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc020a988:	54b9                	li	s1,-18
ffffffffc020a98a:	b7e9                	j	ffffffffc020a954 <sfs_lookup+0x72>
ffffffffc020a98c:	00004697          	auipc	a3,0x4
ffffffffc020a990:	5f468693          	addi	a3,a3,1524 # ffffffffc020ef80 <dev_node_ops+0x5d0>
ffffffffc020a994:	00001617          	auipc	a2,0x1
ffffffffc020a998:	f8460613          	addi	a2,a2,-124 # ffffffffc020b918 <commands+0x250>
ffffffffc020a99c:	3f300593          	li	a1,1011
ffffffffc020a9a0:	00004517          	auipc	a0,0x4
ffffffffc020a9a4:	34050513          	addi	a0,a0,832 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a9a8:	887f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a9ac:	00004697          	auipc	a3,0x4
ffffffffc020a9b0:	15468693          	addi	a3,a3,340 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc020a9b4:	00001617          	auipc	a2,0x1
ffffffffc020a9b8:	f6460613          	addi	a2,a2,-156 # ffffffffc020b918 <commands+0x250>
ffffffffc020a9bc:	3f200593          	li	a1,1010
ffffffffc020a9c0:	00004517          	auipc	a0,0x4
ffffffffc020a9c4:	32050513          	addi	a0,a0,800 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a9c8:	867f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a9cc:	00004697          	auipc	a3,0x4
ffffffffc020a9d0:	2dc68693          	addi	a3,a3,732 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc020a9d4:	00001617          	auipc	a2,0x1
ffffffffc020a9d8:	f4460613          	addi	a2,a2,-188 # ffffffffc020b918 <commands+0x250>
ffffffffc020a9dc:	3f500593          	li	a1,1013
ffffffffc020a9e0:	00004517          	auipc	a0,0x4
ffffffffc020a9e4:	30050513          	addi	a0,a0,768 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020a9e8:	847f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a9ec <sfs_namefile>:
ffffffffc020a9ec:	6d98                	ld	a4,24(a1)
ffffffffc020a9ee:	7175                	addi	sp,sp,-144
ffffffffc020a9f0:	e506                	sd	ra,136(sp)
ffffffffc020a9f2:	e122                	sd	s0,128(sp)
ffffffffc020a9f4:	fca6                	sd	s1,120(sp)
ffffffffc020a9f6:	f8ca                	sd	s2,112(sp)
ffffffffc020a9f8:	f4ce                	sd	s3,104(sp)
ffffffffc020a9fa:	f0d2                	sd	s4,96(sp)
ffffffffc020a9fc:	ecd6                	sd	s5,88(sp)
ffffffffc020a9fe:	e8da                	sd	s6,80(sp)
ffffffffc020aa00:	e4de                	sd	s7,72(sp)
ffffffffc020aa02:	e0e2                	sd	s8,64(sp)
ffffffffc020aa04:	fc66                	sd	s9,56(sp)
ffffffffc020aa06:	f86a                	sd	s10,48(sp)
ffffffffc020aa08:	f46e                	sd	s11,40(sp)
ffffffffc020aa0a:	e42e                	sd	a1,8(sp)
ffffffffc020aa0c:	4789                	li	a5,2
ffffffffc020aa0e:	1ae7f363          	bgeu	a5,a4,ffffffffc020abb4 <sfs_namefile+0x1c8>
ffffffffc020aa12:	89aa                	mv	s3,a0
ffffffffc020aa14:	10400513          	li	a0,260
ffffffffc020aa18:	dabf80ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc020aa1c:	842a                	mv	s0,a0
ffffffffc020aa1e:	18050b63          	beqz	a0,ffffffffc020abb4 <sfs_namefile+0x1c8>
ffffffffc020aa22:	0689b483          	ld	s1,104(s3)
ffffffffc020aa26:	1e048963          	beqz	s1,ffffffffc020ac18 <sfs_namefile+0x22c>
ffffffffc020aa2a:	0b04a783          	lw	a5,176(s1)
ffffffffc020aa2e:	1e079563          	bnez	a5,ffffffffc020ac18 <sfs_namefile+0x22c>
ffffffffc020aa32:	0589ac83          	lw	s9,88(s3)
ffffffffc020aa36:	6785                	lui	a5,0x1
ffffffffc020aa38:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020aa3c:	1afc9e63          	bne	s9,a5,ffffffffc020abf8 <sfs_namefile+0x20c>
ffffffffc020aa40:	6722                	ld	a4,8(sp)
ffffffffc020aa42:	854e                	mv	a0,s3
ffffffffc020aa44:	8ace                	mv	s5,s3
ffffffffc020aa46:	6f1c                	ld	a5,24(a4)
ffffffffc020aa48:	00073b03          	ld	s6,0(a4)
ffffffffc020aa4c:	02098a13          	addi	s4,s3,32
ffffffffc020aa50:	ffe78b93          	addi	s7,a5,-2
ffffffffc020aa54:	9b3e                	add	s6,s6,a5
ffffffffc020aa56:	00004d17          	auipc	s10,0x4
ffffffffc020aa5a:	54ad0d13          	addi	s10,s10,1354 # ffffffffc020efa0 <dev_node_ops+0x5f0>
ffffffffc020aa5e:	caafd0ef          	jal	ra,ffffffffc0207f08 <inode_ref_inc>
ffffffffc020aa62:	00440c13          	addi	s8,s0,4
ffffffffc020aa66:	e066                	sd	s9,0(sp)
ffffffffc020aa68:	8552                	mv	a0,s4
ffffffffc020aa6a:	ce1f90ef          	jal	ra,ffffffffc020474a <down>
ffffffffc020aa6e:	0854                	addi	a3,sp,20
ffffffffc020aa70:	866a                	mv	a2,s10
ffffffffc020aa72:	85d6                	mv	a1,s5
ffffffffc020aa74:	8526                	mv	a0,s1
ffffffffc020aa76:	8f3ff0ef          	jal	ra,ffffffffc020a368 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020aa7a:	8daa                	mv	s11,a0
ffffffffc020aa7c:	8552                	mv	a0,s4
ffffffffc020aa7e:	cc9f90ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020aa82:	020d8863          	beqz	s11,ffffffffc020aab2 <sfs_namefile+0xc6>
ffffffffc020aa86:	854e                	mv	a0,s3
ffffffffc020aa88:	d4efd0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc020aa8c:	8522                	mv	a0,s0
ffffffffc020aa8e:	de5f80ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020aa92:	60aa                	ld	ra,136(sp)
ffffffffc020aa94:	640a                	ld	s0,128(sp)
ffffffffc020aa96:	74e6                	ld	s1,120(sp)
ffffffffc020aa98:	7946                	ld	s2,112(sp)
ffffffffc020aa9a:	79a6                	ld	s3,104(sp)
ffffffffc020aa9c:	7a06                	ld	s4,96(sp)
ffffffffc020aa9e:	6ae6                	ld	s5,88(sp)
ffffffffc020aaa0:	6b46                	ld	s6,80(sp)
ffffffffc020aaa2:	6ba6                	ld	s7,72(sp)
ffffffffc020aaa4:	6c06                	ld	s8,64(sp)
ffffffffc020aaa6:	7ce2                	ld	s9,56(sp)
ffffffffc020aaa8:	7d42                	ld	s10,48(sp)
ffffffffc020aaaa:	856e                	mv	a0,s11
ffffffffc020aaac:	7da2                	ld	s11,40(sp)
ffffffffc020aaae:	6149                	addi	sp,sp,144
ffffffffc020aab0:	8082                	ret
ffffffffc020aab2:	4652                	lw	a2,20(sp)
ffffffffc020aab4:	082c                	addi	a1,sp,24
ffffffffc020aab6:	8526                	mv	a0,s1
ffffffffc020aab8:	bdfff0ef          	jal	ra,ffffffffc020a696 <sfs_load_inode>
ffffffffc020aabc:	8daa                	mv	s11,a0
ffffffffc020aabe:	f561                	bnez	a0,ffffffffc020aa86 <sfs_namefile+0x9a>
ffffffffc020aac0:	854e                	mv	a0,s3
ffffffffc020aac2:	008aa903          	lw	s2,8(s5)
ffffffffc020aac6:	d10fd0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc020aaca:	6ce2                	ld	s9,24(sp)
ffffffffc020aacc:	0b3c8463          	beq	s9,s3,ffffffffc020ab74 <sfs_namefile+0x188>
ffffffffc020aad0:	100c8463          	beqz	s9,ffffffffc020abd8 <sfs_namefile+0x1ec>
ffffffffc020aad4:	058ca703          	lw	a4,88(s9)
ffffffffc020aad8:	6782                	ld	a5,0(sp)
ffffffffc020aada:	0ef71f63          	bne	a4,a5,ffffffffc020abd8 <sfs_namefile+0x1ec>
ffffffffc020aade:	008ca703          	lw	a4,8(s9)
ffffffffc020aae2:	8ae6                	mv	s5,s9
ffffffffc020aae4:	0d270a63          	beq	a4,s2,ffffffffc020abb8 <sfs_namefile+0x1cc>
ffffffffc020aae8:	000cb703          	ld	a4,0(s9)
ffffffffc020aaec:	4789                	li	a5,2
ffffffffc020aaee:	00475703          	lhu	a4,4(a4)
ffffffffc020aaf2:	0cf71363          	bne	a4,a5,ffffffffc020abb8 <sfs_namefile+0x1cc>
ffffffffc020aaf6:	020c8a13          	addi	s4,s9,32
ffffffffc020aafa:	8552                	mv	a0,s4
ffffffffc020aafc:	c4ff90ef          	jal	ra,ffffffffc020474a <down>
ffffffffc020ab00:	000cb703          	ld	a4,0(s9)
ffffffffc020ab04:	00872983          	lw	s3,8(a4)
ffffffffc020ab08:	01304963          	bgtz	s3,ffffffffc020ab1a <sfs_namefile+0x12e>
ffffffffc020ab0c:	a899                	j	ffffffffc020ab62 <sfs_namefile+0x176>
ffffffffc020ab0e:	4018                	lw	a4,0(s0)
ffffffffc020ab10:	01270e63          	beq	a4,s2,ffffffffc020ab2c <sfs_namefile+0x140>
ffffffffc020ab14:	2d85                	addiw	s11,s11,1
ffffffffc020ab16:	05b98663          	beq	s3,s11,ffffffffc020ab62 <sfs_namefile+0x176>
ffffffffc020ab1a:	86a2                	mv	a3,s0
ffffffffc020ab1c:	866e                	mv	a2,s11
ffffffffc020ab1e:	85e6                	mv	a1,s9
ffffffffc020ab20:	8526                	mv	a0,s1
ffffffffc020ab22:	e48ff0ef          	jal	ra,ffffffffc020a16a <sfs_dirent_read_nolock>
ffffffffc020ab26:	872a                	mv	a4,a0
ffffffffc020ab28:	d17d                	beqz	a0,ffffffffc020ab0e <sfs_namefile+0x122>
ffffffffc020ab2a:	a82d                	j	ffffffffc020ab64 <sfs_namefile+0x178>
ffffffffc020ab2c:	8552                	mv	a0,s4
ffffffffc020ab2e:	c19f90ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020ab32:	8562                	mv	a0,s8
ffffffffc020ab34:	34a000ef          	jal	ra,ffffffffc020ae7e <strlen>
ffffffffc020ab38:	00150793          	addi	a5,a0,1
ffffffffc020ab3c:	862a                	mv	a2,a0
ffffffffc020ab3e:	06fbe863          	bltu	s7,a5,ffffffffc020abae <sfs_namefile+0x1c2>
ffffffffc020ab42:	fff64913          	not	s2,a2
ffffffffc020ab46:	995a                	add	s2,s2,s6
ffffffffc020ab48:	85e2                	mv	a1,s8
ffffffffc020ab4a:	854a                	mv	a0,s2
ffffffffc020ab4c:	40fb8bb3          	sub	s7,s7,a5
ffffffffc020ab50:	422000ef          	jal	ra,ffffffffc020af72 <memcpy>
ffffffffc020ab54:	02f00793          	li	a5,47
ffffffffc020ab58:	fefb0fa3          	sb	a5,-1(s6)
ffffffffc020ab5c:	89e6                	mv	s3,s9
ffffffffc020ab5e:	8b4a                	mv	s6,s2
ffffffffc020ab60:	b721                	j	ffffffffc020aa68 <sfs_namefile+0x7c>
ffffffffc020ab62:	5741                	li	a4,-16
ffffffffc020ab64:	8552                	mv	a0,s4
ffffffffc020ab66:	e03a                	sd	a4,0(sp)
ffffffffc020ab68:	bdff90ef          	jal	ra,ffffffffc0204746 <up>
ffffffffc020ab6c:	6702                	ld	a4,0(sp)
ffffffffc020ab6e:	89e6                	mv	s3,s9
ffffffffc020ab70:	8dba                	mv	s11,a4
ffffffffc020ab72:	bf11                	j	ffffffffc020aa86 <sfs_namefile+0x9a>
ffffffffc020ab74:	854e                	mv	a0,s3
ffffffffc020ab76:	c60fd0ef          	jal	ra,ffffffffc0207fd6 <inode_ref_dec>
ffffffffc020ab7a:	64a2                	ld	s1,8(sp)
ffffffffc020ab7c:	85da                	mv	a1,s6
ffffffffc020ab7e:	6c98                	ld	a4,24(s1)
ffffffffc020ab80:	6088                	ld	a0,0(s1)
ffffffffc020ab82:	1779                	addi	a4,a4,-2
ffffffffc020ab84:	41770bb3          	sub	s7,a4,s7
ffffffffc020ab88:	865e                	mv	a2,s7
ffffffffc020ab8a:	0505                	addi	a0,a0,1
ffffffffc020ab8c:	3a6000ef          	jal	ra,ffffffffc020af32 <memmove>
ffffffffc020ab90:	02f00713          	li	a4,47
ffffffffc020ab94:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020ab98:	955e                	add	a0,a0,s7
ffffffffc020ab9a:	00050023          	sb	zero,0(a0)
ffffffffc020ab9e:	85de                	mv	a1,s7
ffffffffc020aba0:	8526                	mv	a0,s1
ffffffffc020aba2:	c01fa0ef          	jal	ra,ffffffffc02057a2 <iobuf_skip>
ffffffffc020aba6:	8522                	mv	a0,s0
ffffffffc020aba8:	ccbf80ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020abac:	b5dd                	j	ffffffffc020aa92 <sfs_namefile+0xa6>
ffffffffc020abae:	89e6                	mv	s3,s9
ffffffffc020abb0:	5df1                	li	s11,-4
ffffffffc020abb2:	bdd1                	j	ffffffffc020aa86 <sfs_namefile+0x9a>
ffffffffc020abb4:	5df1                	li	s11,-4
ffffffffc020abb6:	bdf1                	j	ffffffffc020aa92 <sfs_namefile+0xa6>
ffffffffc020abb8:	00004697          	auipc	a3,0x4
ffffffffc020abbc:	3f068693          	addi	a3,a3,1008 # ffffffffc020efa8 <dev_node_ops+0x5f8>
ffffffffc020abc0:	00001617          	auipc	a2,0x1
ffffffffc020abc4:	d5860613          	addi	a2,a2,-680 # ffffffffc020b918 <commands+0x250>
ffffffffc020abc8:	31100593          	li	a1,785
ffffffffc020abcc:	00004517          	auipc	a0,0x4
ffffffffc020abd0:	11450513          	addi	a0,a0,276 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020abd4:	e5af50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020abd8:	00004697          	auipc	a3,0x4
ffffffffc020abdc:	0d068693          	addi	a3,a3,208 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc020abe0:	00001617          	auipc	a2,0x1
ffffffffc020abe4:	d3860613          	addi	a2,a2,-712 # ffffffffc020b918 <commands+0x250>
ffffffffc020abe8:	31000593          	li	a1,784
ffffffffc020abec:	00004517          	auipc	a0,0x4
ffffffffc020abf0:	0f450513          	addi	a0,a0,244 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020abf4:	e3af50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020abf8:	00004697          	auipc	a3,0x4
ffffffffc020abfc:	0b068693          	addi	a3,a3,176 # ffffffffc020eca8 <dev_node_ops+0x2f8>
ffffffffc020ac00:	00001617          	auipc	a2,0x1
ffffffffc020ac04:	d1860613          	addi	a2,a2,-744 # ffffffffc020b918 <commands+0x250>
ffffffffc020ac08:	2fd00593          	li	a1,765
ffffffffc020ac0c:	00004517          	auipc	a0,0x4
ffffffffc020ac10:	0d450513          	addi	a0,a0,212 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020ac14:	e1af50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020ac18:	00004697          	auipc	a3,0x4
ffffffffc020ac1c:	ee868693          	addi	a3,a3,-280 # ffffffffc020eb00 <dev_node_ops+0x150>
ffffffffc020ac20:	00001617          	auipc	a2,0x1
ffffffffc020ac24:	cf860613          	addi	a2,a2,-776 # ffffffffc020b918 <commands+0x250>
ffffffffc020ac28:	2fc00593          	li	a1,764
ffffffffc020ac2c:	00004517          	auipc	a0,0x4
ffffffffc020ac30:	0b450513          	addi	a0,a0,180 # ffffffffc020ece0 <dev_node_ops+0x330>
ffffffffc020ac34:	dfaf50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ac38 <bitmap_translate.part.0>:
ffffffffc020ac38:	1141                	addi	sp,sp,-16
ffffffffc020ac3a:	00004697          	auipc	a3,0x4
ffffffffc020ac3e:	4a668693          	addi	a3,a3,1190 # ffffffffc020f0e0 <sfs_node_fileops+0x80>
ffffffffc020ac42:	00001617          	auipc	a2,0x1
ffffffffc020ac46:	cd660613          	addi	a2,a2,-810 # ffffffffc020b918 <commands+0x250>
ffffffffc020ac4a:	04c00593          	li	a1,76
ffffffffc020ac4e:	00004517          	auipc	a0,0x4
ffffffffc020ac52:	4aa50513          	addi	a0,a0,1194 # ffffffffc020f0f8 <sfs_node_fileops+0x98>
ffffffffc020ac56:	e406                	sd	ra,8(sp)
ffffffffc020ac58:	dd6f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ac5c <bitmap_create>:
ffffffffc020ac5c:	7139                	addi	sp,sp,-64
ffffffffc020ac5e:	fc06                	sd	ra,56(sp)
ffffffffc020ac60:	f822                	sd	s0,48(sp)
ffffffffc020ac62:	f426                	sd	s1,40(sp)
ffffffffc020ac64:	f04a                	sd	s2,32(sp)
ffffffffc020ac66:	ec4e                	sd	s3,24(sp)
ffffffffc020ac68:	e852                	sd	s4,16(sp)
ffffffffc020ac6a:	e456                	sd	s5,8(sp)
ffffffffc020ac6c:	c14d                	beqz	a0,ffffffffc020ad0e <bitmap_create+0xb2>
ffffffffc020ac6e:	842a                	mv	s0,a0
ffffffffc020ac70:	4541                	li	a0,16
ffffffffc020ac72:	b51f80ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc020ac76:	84aa                	mv	s1,a0
ffffffffc020ac78:	cd25                	beqz	a0,ffffffffc020acf0 <bitmap_create+0x94>
ffffffffc020ac7a:	02041a13          	slli	s4,s0,0x20
ffffffffc020ac7e:	020a5a13          	srli	s4,s4,0x20
ffffffffc020ac82:	01fa0793          	addi	a5,s4,31
ffffffffc020ac86:	0057d993          	srli	s3,a5,0x5
ffffffffc020ac8a:	00299a93          	slli	s5,s3,0x2
ffffffffc020ac8e:	8556                	mv	a0,s5
ffffffffc020ac90:	894e                	mv	s2,s3
ffffffffc020ac92:	b31f80ef          	jal	ra,ffffffffc02037c2 <kmalloc>
ffffffffc020ac96:	c53d                	beqz	a0,ffffffffc020ad04 <bitmap_create+0xa8>
ffffffffc020ac98:	0134a223          	sw	s3,4(s1)
ffffffffc020ac9c:	c080                	sw	s0,0(s1)
ffffffffc020ac9e:	8656                	mv	a2,s5
ffffffffc020aca0:	0ff00593          	li	a1,255
ffffffffc020aca4:	27c000ef          	jal	ra,ffffffffc020af20 <memset>
ffffffffc020aca8:	e488                	sd	a0,8(s1)
ffffffffc020acaa:	0996                	slli	s3,s3,0x5
ffffffffc020acac:	053a0263          	beq	s4,s3,ffffffffc020acf0 <bitmap_create+0x94>
ffffffffc020acb0:	fff9079b          	addiw	a5,s2,-1
ffffffffc020acb4:	0057969b          	slliw	a3,a5,0x5
ffffffffc020acb8:	0054561b          	srliw	a2,s0,0x5
ffffffffc020acbc:	40d4073b          	subw	a4,s0,a3
ffffffffc020acc0:	0054541b          	srliw	s0,s0,0x5
ffffffffc020acc4:	08f61463          	bne	a2,a5,ffffffffc020ad4c <bitmap_create+0xf0>
ffffffffc020acc8:	fff7069b          	addiw	a3,a4,-1
ffffffffc020accc:	47f9                	li	a5,30
ffffffffc020acce:	04d7ef63          	bltu	a5,a3,ffffffffc020ad2c <bitmap_create+0xd0>
ffffffffc020acd2:	1402                	slli	s0,s0,0x20
ffffffffc020acd4:	8079                	srli	s0,s0,0x1e
ffffffffc020acd6:	9522                	add	a0,a0,s0
ffffffffc020acd8:	411c                	lw	a5,0(a0)
ffffffffc020acda:	4585                	li	a1,1
ffffffffc020acdc:	02000613          	li	a2,32
ffffffffc020ace0:	00e596bb          	sllw	a3,a1,a4
ffffffffc020ace4:	8fb5                	xor	a5,a5,a3
ffffffffc020ace6:	2705                	addiw	a4,a4,1
ffffffffc020ace8:	2781                	sext.w	a5,a5
ffffffffc020acea:	fec71be3          	bne	a4,a2,ffffffffc020ace0 <bitmap_create+0x84>
ffffffffc020acee:	c11c                	sw	a5,0(a0)
ffffffffc020acf0:	70e2                	ld	ra,56(sp)
ffffffffc020acf2:	7442                	ld	s0,48(sp)
ffffffffc020acf4:	7902                	ld	s2,32(sp)
ffffffffc020acf6:	69e2                	ld	s3,24(sp)
ffffffffc020acf8:	6a42                	ld	s4,16(sp)
ffffffffc020acfa:	6aa2                	ld	s5,8(sp)
ffffffffc020acfc:	8526                	mv	a0,s1
ffffffffc020acfe:	74a2                	ld	s1,40(sp)
ffffffffc020ad00:	6121                	addi	sp,sp,64
ffffffffc020ad02:	8082                	ret
ffffffffc020ad04:	8526                	mv	a0,s1
ffffffffc020ad06:	b6df80ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020ad0a:	4481                	li	s1,0
ffffffffc020ad0c:	b7d5                	j	ffffffffc020acf0 <bitmap_create+0x94>
ffffffffc020ad0e:	00004697          	auipc	a3,0x4
ffffffffc020ad12:	40268693          	addi	a3,a3,1026 # ffffffffc020f110 <sfs_node_fileops+0xb0>
ffffffffc020ad16:	00001617          	auipc	a2,0x1
ffffffffc020ad1a:	c0260613          	addi	a2,a2,-1022 # ffffffffc020b918 <commands+0x250>
ffffffffc020ad1e:	45d5                	li	a1,21
ffffffffc020ad20:	00004517          	auipc	a0,0x4
ffffffffc020ad24:	3d850513          	addi	a0,a0,984 # ffffffffc020f0f8 <sfs_node_fileops+0x98>
ffffffffc020ad28:	d06f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020ad2c:	00004697          	auipc	a3,0x4
ffffffffc020ad30:	42468693          	addi	a3,a3,1060 # ffffffffc020f150 <sfs_node_fileops+0xf0>
ffffffffc020ad34:	00001617          	auipc	a2,0x1
ffffffffc020ad38:	be460613          	addi	a2,a2,-1052 # ffffffffc020b918 <commands+0x250>
ffffffffc020ad3c:	02b00593          	li	a1,43
ffffffffc020ad40:	00004517          	auipc	a0,0x4
ffffffffc020ad44:	3b850513          	addi	a0,a0,952 # ffffffffc020f0f8 <sfs_node_fileops+0x98>
ffffffffc020ad48:	ce6f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020ad4c:	00004697          	auipc	a3,0x4
ffffffffc020ad50:	3ec68693          	addi	a3,a3,1004 # ffffffffc020f138 <sfs_node_fileops+0xd8>
ffffffffc020ad54:	00001617          	auipc	a2,0x1
ffffffffc020ad58:	bc460613          	addi	a2,a2,-1084 # ffffffffc020b918 <commands+0x250>
ffffffffc020ad5c:	02a00593          	li	a1,42
ffffffffc020ad60:	00004517          	auipc	a0,0x4
ffffffffc020ad64:	39850513          	addi	a0,a0,920 # ffffffffc020f0f8 <sfs_node_fileops+0x98>
ffffffffc020ad68:	cc6f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ad6c <bitmap_alloc>:
ffffffffc020ad6c:	4150                	lw	a2,4(a0)
ffffffffc020ad6e:	651c                	ld	a5,8(a0)
ffffffffc020ad70:	c231                	beqz	a2,ffffffffc020adb4 <bitmap_alloc+0x48>
ffffffffc020ad72:	4701                	li	a4,0
ffffffffc020ad74:	a029                	j	ffffffffc020ad7e <bitmap_alloc+0x12>
ffffffffc020ad76:	2705                	addiw	a4,a4,1
ffffffffc020ad78:	0791                	addi	a5,a5,4
ffffffffc020ad7a:	02e60d63          	beq	a2,a4,ffffffffc020adb4 <bitmap_alloc+0x48>
ffffffffc020ad7e:	4394                	lw	a3,0(a5)
ffffffffc020ad80:	dafd                	beqz	a3,ffffffffc020ad76 <bitmap_alloc+0xa>
ffffffffc020ad82:	4501                	li	a0,0
ffffffffc020ad84:	4885                	li	a7,1
ffffffffc020ad86:	8e36                	mv	t3,a3
ffffffffc020ad88:	02000313          	li	t1,32
ffffffffc020ad8c:	a021                	j	ffffffffc020ad94 <bitmap_alloc+0x28>
ffffffffc020ad8e:	2505                	addiw	a0,a0,1
ffffffffc020ad90:	02650463          	beq	a0,t1,ffffffffc020adb8 <bitmap_alloc+0x4c>
ffffffffc020ad94:	00a8983b          	sllw	a6,a7,a0
ffffffffc020ad98:	0106f633          	and	a2,a3,a6
ffffffffc020ad9c:	2601                	sext.w	a2,a2
ffffffffc020ad9e:	da65                	beqz	a2,ffffffffc020ad8e <bitmap_alloc+0x22>
ffffffffc020ada0:	010e4833          	xor	a6,t3,a6
ffffffffc020ada4:	0057171b          	slliw	a4,a4,0x5
ffffffffc020ada8:	9f29                	addw	a4,a4,a0
ffffffffc020adaa:	0107a023          	sw	a6,0(a5)
ffffffffc020adae:	c198                	sw	a4,0(a1)
ffffffffc020adb0:	4501                	li	a0,0
ffffffffc020adb2:	8082                	ret
ffffffffc020adb4:	5571                	li	a0,-4
ffffffffc020adb6:	8082                	ret
ffffffffc020adb8:	1141                	addi	sp,sp,-16
ffffffffc020adba:	00001697          	auipc	a3,0x1
ffffffffc020adbe:	70e68693          	addi	a3,a3,1806 # ffffffffc020c4c8 <commands+0xe00>
ffffffffc020adc2:	00001617          	auipc	a2,0x1
ffffffffc020adc6:	b5660613          	addi	a2,a2,-1194 # ffffffffc020b918 <commands+0x250>
ffffffffc020adca:	04300593          	li	a1,67
ffffffffc020adce:	00004517          	auipc	a0,0x4
ffffffffc020add2:	32a50513          	addi	a0,a0,810 # ffffffffc020f0f8 <sfs_node_fileops+0x98>
ffffffffc020add6:	e406                	sd	ra,8(sp)
ffffffffc020add8:	c56f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020addc <bitmap_test>:
ffffffffc020addc:	411c                	lw	a5,0(a0)
ffffffffc020adde:	00f5ff63          	bgeu	a1,a5,ffffffffc020adfc <bitmap_test+0x20>
ffffffffc020ade2:	651c                	ld	a5,8(a0)
ffffffffc020ade4:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020ade8:	070a                	slli	a4,a4,0x2
ffffffffc020adea:	97ba                	add	a5,a5,a4
ffffffffc020adec:	4388                	lw	a0,0(a5)
ffffffffc020adee:	4785                	li	a5,1
ffffffffc020adf0:	00b795bb          	sllw	a1,a5,a1
ffffffffc020adf4:	8d6d                	and	a0,a0,a1
ffffffffc020adf6:	1502                	slli	a0,a0,0x20
ffffffffc020adf8:	9101                	srli	a0,a0,0x20
ffffffffc020adfa:	8082                	ret
ffffffffc020adfc:	1141                	addi	sp,sp,-16
ffffffffc020adfe:	e406                	sd	ra,8(sp)
ffffffffc020ae00:	e39ff0ef          	jal	ra,ffffffffc020ac38 <bitmap_translate.part.0>

ffffffffc020ae04 <bitmap_free>:
ffffffffc020ae04:	411c                	lw	a5,0(a0)
ffffffffc020ae06:	1141                	addi	sp,sp,-16
ffffffffc020ae08:	e406                	sd	ra,8(sp)
ffffffffc020ae0a:	02f5f463          	bgeu	a1,a5,ffffffffc020ae32 <bitmap_free+0x2e>
ffffffffc020ae0e:	651c                	ld	a5,8(a0)
ffffffffc020ae10:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020ae14:	070a                	slli	a4,a4,0x2
ffffffffc020ae16:	97ba                	add	a5,a5,a4
ffffffffc020ae18:	4398                	lw	a4,0(a5)
ffffffffc020ae1a:	4685                	li	a3,1
ffffffffc020ae1c:	00b695bb          	sllw	a1,a3,a1
ffffffffc020ae20:	00b776b3          	and	a3,a4,a1
ffffffffc020ae24:	2681                	sext.w	a3,a3
ffffffffc020ae26:	ea81                	bnez	a3,ffffffffc020ae36 <bitmap_free+0x32>
ffffffffc020ae28:	60a2                	ld	ra,8(sp)
ffffffffc020ae2a:	8f4d                	or	a4,a4,a1
ffffffffc020ae2c:	c398                	sw	a4,0(a5)
ffffffffc020ae2e:	0141                	addi	sp,sp,16
ffffffffc020ae30:	8082                	ret
ffffffffc020ae32:	e07ff0ef          	jal	ra,ffffffffc020ac38 <bitmap_translate.part.0>
ffffffffc020ae36:	00004697          	auipc	a3,0x4
ffffffffc020ae3a:	34268693          	addi	a3,a3,834 # ffffffffc020f178 <sfs_node_fileops+0x118>
ffffffffc020ae3e:	00001617          	auipc	a2,0x1
ffffffffc020ae42:	ada60613          	addi	a2,a2,-1318 # ffffffffc020b918 <commands+0x250>
ffffffffc020ae46:	05f00593          	li	a1,95
ffffffffc020ae4a:	00004517          	auipc	a0,0x4
ffffffffc020ae4e:	2ae50513          	addi	a0,a0,686 # ffffffffc020f0f8 <sfs_node_fileops+0x98>
ffffffffc020ae52:	bdcf50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ae56 <bitmap_destroy>:
ffffffffc020ae56:	1141                	addi	sp,sp,-16
ffffffffc020ae58:	e022                	sd	s0,0(sp)
ffffffffc020ae5a:	842a                	mv	s0,a0
ffffffffc020ae5c:	6508                	ld	a0,8(a0)
ffffffffc020ae5e:	e406                	sd	ra,8(sp)
ffffffffc020ae60:	a13f80ef          	jal	ra,ffffffffc0203872 <kfree>
ffffffffc020ae64:	8522                	mv	a0,s0
ffffffffc020ae66:	6402                	ld	s0,0(sp)
ffffffffc020ae68:	60a2                	ld	ra,8(sp)
ffffffffc020ae6a:	0141                	addi	sp,sp,16
ffffffffc020ae6c:	a07f806f          	j	ffffffffc0203872 <kfree>

ffffffffc020ae70 <bitmap_getdata>:
ffffffffc020ae70:	c589                	beqz	a1,ffffffffc020ae7a <bitmap_getdata+0xa>
ffffffffc020ae72:	00456783          	lwu	a5,4(a0)
ffffffffc020ae76:	078a                	slli	a5,a5,0x2
ffffffffc020ae78:	e19c                	sd	a5,0(a1)
ffffffffc020ae7a:	6508                	ld	a0,8(a0)
ffffffffc020ae7c:	8082                	ret

ffffffffc020ae7e <strlen>:
ffffffffc020ae7e:	00054783          	lbu	a5,0(a0)
ffffffffc020ae82:	872a                	mv	a4,a0
ffffffffc020ae84:	4501                	li	a0,0
ffffffffc020ae86:	cb81                	beqz	a5,ffffffffc020ae96 <strlen+0x18>
ffffffffc020ae88:	0505                	addi	a0,a0,1
ffffffffc020ae8a:	00a707b3          	add	a5,a4,a0
ffffffffc020ae8e:	0007c783          	lbu	a5,0(a5)
ffffffffc020ae92:	fbfd                	bnez	a5,ffffffffc020ae88 <strlen+0xa>
ffffffffc020ae94:	8082                	ret
ffffffffc020ae96:	8082                	ret

ffffffffc020ae98 <strnlen>:
ffffffffc020ae98:	4781                	li	a5,0
ffffffffc020ae9a:	e589                	bnez	a1,ffffffffc020aea4 <strnlen+0xc>
ffffffffc020ae9c:	a811                	j	ffffffffc020aeb0 <strnlen+0x18>
ffffffffc020ae9e:	0785                	addi	a5,a5,1
ffffffffc020aea0:	00f58863          	beq	a1,a5,ffffffffc020aeb0 <strnlen+0x18>
ffffffffc020aea4:	00f50733          	add	a4,a0,a5
ffffffffc020aea8:	00074703          	lbu	a4,0(a4)
ffffffffc020aeac:	fb6d                	bnez	a4,ffffffffc020ae9e <strnlen+0x6>
ffffffffc020aeae:	85be                	mv	a1,a5
ffffffffc020aeb0:	852e                	mv	a0,a1
ffffffffc020aeb2:	8082                	ret

ffffffffc020aeb4 <strcpy>:
ffffffffc020aeb4:	87aa                	mv	a5,a0
ffffffffc020aeb6:	0005c703          	lbu	a4,0(a1)
ffffffffc020aeba:	0785                	addi	a5,a5,1
ffffffffc020aebc:	0585                	addi	a1,a1,1
ffffffffc020aebe:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020aec2:	fb75                	bnez	a4,ffffffffc020aeb6 <strcpy+0x2>
ffffffffc020aec4:	8082                	ret

ffffffffc020aec6 <strcmp>:
ffffffffc020aec6:	00054783          	lbu	a5,0(a0)
ffffffffc020aeca:	0005c703          	lbu	a4,0(a1)
ffffffffc020aece:	cb89                	beqz	a5,ffffffffc020aee0 <strcmp+0x1a>
ffffffffc020aed0:	0505                	addi	a0,a0,1
ffffffffc020aed2:	0585                	addi	a1,a1,1
ffffffffc020aed4:	fee789e3          	beq	a5,a4,ffffffffc020aec6 <strcmp>
ffffffffc020aed8:	0007851b          	sext.w	a0,a5
ffffffffc020aedc:	9d19                	subw	a0,a0,a4
ffffffffc020aede:	8082                	ret
ffffffffc020aee0:	4501                	li	a0,0
ffffffffc020aee2:	bfed                	j	ffffffffc020aedc <strcmp+0x16>

ffffffffc020aee4 <strncmp>:
ffffffffc020aee4:	c20d                	beqz	a2,ffffffffc020af06 <strncmp+0x22>
ffffffffc020aee6:	962e                	add	a2,a2,a1
ffffffffc020aee8:	a031                	j	ffffffffc020aef4 <strncmp+0x10>
ffffffffc020aeea:	0505                	addi	a0,a0,1
ffffffffc020aeec:	00e79a63          	bne	a5,a4,ffffffffc020af00 <strncmp+0x1c>
ffffffffc020aef0:	00b60b63          	beq	a2,a1,ffffffffc020af06 <strncmp+0x22>
ffffffffc020aef4:	00054783          	lbu	a5,0(a0)
ffffffffc020aef8:	0585                	addi	a1,a1,1
ffffffffc020aefa:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020aefe:	f7f5                	bnez	a5,ffffffffc020aeea <strncmp+0x6>
ffffffffc020af00:	40e7853b          	subw	a0,a5,a4
ffffffffc020af04:	8082                	ret
ffffffffc020af06:	4501                	li	a0,0
ffffffffc020af08:	8082                	ret

ffffffffc020af0a <strchr>:
ffffffffc020af0a:	00054783          	lbu	a5,0(a0)
ffffffffc020af0e:	c799                	beqz	a5,ffffffffc020af1c <strchr+0x12>
ffffffffc020af10:	00f58763          	beq	a1,a5,ffffffffc020af1e <strchr+0x14>
ffffffffc020af14:	00154783          	lbu	a5,1(a0)
ffffffffc020af18:	0505                	addi	a0,a0,1
ffffffffc020af1a:	fbfd                	bnez	a5,ffffffffc020af10 <strchr+0x6>
ffffffffc020af1c:	4501                	li	a0,0
ffffffffc020af1e:	8082                	ret

ffffffffc020af20 <memset>:
ffffffffc020af20:	ca01                	beqz	a2,ffffffffc020af30 <memset+0x10>
ffffffffc020af22:	962a                	add	a2,a2,a0
ffffffffc020af24:	87aa                	mv	a5,a0
ffffffffc020af26:	0785                	addi	a5,a5,1
ffffffffc020af28:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020af2c:	fec79de3          	bne	a5,a2,ffffffffc020af26 <memset+0x6>
ffffffffc020af30:	8082                	ret

ffffffffc020af32 <memmove>:
ffffffffc020af32:	02a5f263          	bgeu	a1,a0,ffffffffc020af56 <memmove+0x24>
ffffffffc020af36:	00c587b3          	add	a5,a1,a2
ffffffffc020af3a:	00f57e63          	bgeu	a0,a5,ffffffffc020af56 <memmove+0x24>
ffffffffc020af3e:	00c50733          	add	a4,a0,a2
ffffffffc020af42:	c615                	beqz	a2,ffffffffc020af6e <memmove+0x3c>
ffffffffc020af44:	fff7c683          	lbu	a3,-1(a5)
ffffffffc020af48:	17fd                	addi	a5,a5,-1
ffffffffc020af4a:	177d                	addi	a4,a4,-1
ffffffffc020af4c:	00d70023          	sb	a3,0(a4)
ffffffffc020af50:	fef59ae3          	bne	a1,a5,ffffffffc020af44 <memmove+0x12>
ffffffffc020af54:	8082                	ret
ffffffffc020af56:	00c586b3          	add	a3,a1,a2
ffffffffc020af5a:	87aa                	mv	a5,a0
ffffffffc020af5c:	ca11                	beqz	a2,ffffffffc020af70 <memmove+0x3e>
ffffffffc020af5e:	0005c703          	lbu	a4,0(a1)
ffffffffc020af62:	0585                	addi	a1,a1,1
ffffffffc020af64:	0785                	addi	a5,a5,1
ffffffffc020af66:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020af6a:	fed59ae3          	bne	a1,a3,ffffffffc020af5e <memmove+0x2c>
ffffffffc020af6e:	8082                	ret
ffffffffc020af70:	8082                	ret

ffffffffc020af72 <memcpy>:
ffffffffc020af72:	ca19                	beqz	a2,ffffffffc020af88 <memcpy+0x16>
ffffffffc020af74:	962e                	add	a2,a2,a1
ffffffffc020af76:	87aa                	mv	a5,a0
ffffffffc020af78:	0005c703          	lbu	a4,0(a1)
ffffffffc020af7c:	0585                	addi	a1,a1,1
ffffffffc020af7e:	0785                	addi	a5,a5,1
ffffffffc020af80:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020af84:	fec59ae3          	bne	a1,a2,ffffffffc020af78 <memcpy+0x6>
ffffffffc020af88:	8082                	ret

ffffffffc020af8a <printnum>:
ffffffffc020af8a:	02071893          	slli	a7,a4,0x20
ffffffffc020af8e:	7139                	addi	sp,sp,-64
ffffffffc020af90:	0208d893          	srli	a7,a7,0x20
ffffffffc020af94:	e456                	sd	s5,8(sp)
ffffffffc020af96:	0316fab3          	remu	s5,a3,a7
ffffffffc020af9a:	f822                	sd	s0,48(sp)
ffffffffc020af9c:	f426                	sd	s1,40(sp)
ffffffffc020af9e:	f04a                	sd	s2,32(sp)
ffffffffc020afa0:	ec4e                	sd	s3,24(sp)
ffffffffc020afa2:	fc06                	sd	ra,56(sp)
ffffffffc020afa4:	e852                	sd	s4,16(sp)
ffffffffc020afa6:	84aa                	mv	s1,a0
ffffffffc020afa8:	89ae                	mv	s3,a1
ffffffffc020afaa:	8932                	mv	s2,a2
ffffffffc020afac:	fff7841b          	addiw	s0,a5,-1
ffffffffc020afb0:	2a81                	sext.w	s5,s5
ffffffffc020afb2:	0516f163          	bgeu	a3,a7,ffffffffc020aff4 <printnum+0x6a>
ffffffffc020afb6:	8a42                	mv	s4,a6
ffffffffc020afb8:	00805863          	blez	s0,ffffffffc020afc8 <printnum+0x3e>
ffffffffc020afbc:	347d                	addiw	s0,s0,-1
ffffffffc020afbe:	864e                	mv	a2,s3
ffffffffc020afc0:	85ca                	mv	a1,s2
ffffffffc020afc2:	8552                	mv	a0,s4
ffffffffc020afc4:	9482                	jalr	s1
ffffffffc020afc6:	f87d                	bnez	s0,ffffffffc020afbc <printnum+0x32>
ffffffffc020afc8:	1a82                	slli	s5,s5,0x20
ffffffffc020afca:	00004797          	auipc	a5,0x4
ffffffffc020afce:	1be78793          	addi	a5,a5,446 # ffffffffc020f188 <sfs_node_fileops+0x128>
ffffffffc020afd2:	020ada93          	srli	s5,s5,0x20
ffffffffc020afd6:	9abe                	add	s5,s5,a5
ffffffffc020afd8:	7442                	ld	s0,48(sp)
ffffffffc020afda:	000ac503          	lbu	a0,0(s5)
ffffffffc020afde:	70e2                	ld	ra,56(sp)
ffffffffc020afe0:	6a42                	ld	s4,16(sp)
ffffffffc020afe2:	6aa2                	ld	s5,8(sp)
ffffffffc020afe4:	864e                	mv	a2,s3
ffffffffc020afe6:	85ca                	mv	a1,s2
ffffffffc020afe8:	69e2                	ld	s3,24(sp)
ffffffffc020afea:	7902                	ld	s2,32(sp)
ffffffffc020afec:	87a6                	mv	a5,s1
ffffffffc020afee:	74a2                	ld	s1,40(sp)
ffffffffc020aff0:	6121                	addi	sp,sp,64
ffffffffc020aff2:	8782                	jr	a5
ffffffffc020aff4:	0316d6b3          	divu	a3,a3,a7
ffffffffc020aff8:	87a2                	mv	a5,s0
ffffffffc020affa:	f91ff0ef          	jal	ra,ffffffffc020af8a <printnum>
ffffffffc020affe:	b7e9                	j	ffffffffc020afc8 <printnum+0x3e>

ffffffffc020b000 <sprintputch>:
ffffffffc020b000:	499c                	lw	a5,16(a1)
ffffffffc020b002:	6198                	ld	a4,0(a1)
ffffffffc020b004:	6594                	ld	a3,8(a1)
ffffffffc020b006:	2785                	addiw	a5,a5,1
ffffffffc020b008:	c99c                	sw	a5,16(a1)
ffffffffc020b00a:	00d77763          	bgeu	a4,a3,ffffffffc020b018 <sprintputch+0x18>
ffffffffc020b00e:	00170793          	addi	a5,a4,1
ffffffffc020b012:	e19c                	sd	a5,0(a1)
ffffffffc020b014:	00a70023          	sb	a0,0(a4)
ffffffffc020b018:	8082                	ret

ffffffffc020b01a <vprintfmt>:
ffffffffc020b01a:	7119                	addi	sp,sp,-128
ffffffffc020b01c:	f4a6                	sd	s1,104(sp)
ffffffffc020b01e:	f0ca                	sd	s2,96(sp)
ffffffffc020b020:	ecce                	sd	s3,88(sp)
ffffffffc020b022:	e8d2                	sd	s4,80(sp)
ffffffffc020b024:	e4d6                	sd	s5,72(sp)
ffffffffc020b026:	e0da                	sd	s6,64(sp)
ffffffffc020b028:	fc5e                	sd	s7,56(sp)
ffffffffc020b02a:	ec6e                	sd	s11,24(sp)
ffffffffc020b02c:	fc86                	sd	ra,120(sp)
ffffffffc020b02e:	f8a2                	sd	s0,112(sp)
ffffffffc020b030:	f862                	sd	s8,48(sp)
ffffffffc020b032:	f466                	sd	s9,40(sp)
ffffffffc020b034:	f06a                	sd	s10,32(sp)
ffffffffc020b036:	89aa                	mv	s3,a0
ffffffffc020b038:	892e                	mv	s2,a1
ffffffffc020b03a:	84b2                	mv	s1,a2
ffffffffc020b03c:	8db6                	mv	s11,a3
ffffffffc020b03e:	8aba                	mv	s5,a4
ffffffffc020b040:	02500a13          	li	s4,37
ffffffffc020b044:	5bfd                	li	s7,-1
ffffffffc020b046:	00004b17          	auipc	s6,0x4
ffffffffc020b04a:	16eb0b13          	addi	s6,s6,366 # ffffffffc020f1b4 <sfs_node_fileops+0x154>
ffffffffc020b04e:	000dc503          	lbu	a0,0(s11) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020b052:	001d8413          	addi	s0,s11,1
ffffffffc020b056:	01450b63          	beq	a0,s4,ffffffffc020b06c <vprintfmt+0x52>
ffffffffc020b05a:	c129                	beqz	a0,ffffffffc020b09c <vprintfmt+0x82>
ffffffffc020b05c:	864a                	mv	a2,s2
ffffffffc020b05e:	85a6                	mv	a1,s1
ffffffffc020b060:	0405                	addi	s0,s0,1
ffffffffc020b062:	9982                	jalr	s3
ffffffffc020b064:	fff44503          	lbu	a0,-1(s0)
ffffffffc020b068:	ff4519e3          	bne	a0,s4,ffffffffc020b05a <vprintfmt+0x40>
ffffffffc020b06c:	00044583          	lbu	a1,0(s0)
ffffffffc020b070:	02000813          	li	a6,32
ffffffffc020b074:	4d01                	li	s10,0
ffffffffc020b076:	4301                	li	t1,0
ffffffffc020b078:	5cfd                	li	s9,-1
ffffffffc020b07a:	5c7d                	li	s8,-1
ffffffffc020b07c:	05500513          	li	a0,85
ffffffffc020b080:	48a5                	li	a7,9
ffffffffc020b082:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b086:	0ff67613          	zext.b	a2,a2
ffffffffc020b08a:	00140d93          	addi	s11,s0,1
ffffffffc020b08e:	04c56263          	bltu	a0,a2,ffffffffc020b0d2 <vprintfmt+0xb8>
ffffffffc020b092:	060a                	slli	a2,a2,0x2
ffffffffc020b094:	965a                	add	a2,a2,s6
ffffffffc020b096:	4214                	lw	a3,0(a2)
ffffffffc020b098:	96da                	add	a3,a3,s6
ffffffffc020b09a:	8682                	jr	a3
ffffffffc020b09c:	70e6                	ld	ra,120(sp)
ffffffffc020b09e:	7446                	ld	s0,112(sp)
ffffffffc020b0a0:	74a6                	ld	s1,104(sp)
ffffffffc020b0a2:	7906                	ld	s2,96(sp)
ffffffffc020b0a4:	69e6                	ld	s3,88(sp)
ffffffffc020b0a6:	6a46                	ld	s4,80(sp)
ffffffffc020b0a8:	6aa6                	ld	s5,72(sp)
ffffffffc020b0aa:	6b06                	ld	s6,64(sp)
ffffffffc020b0ac:	7be2                	ld	s7,56(sp)
ffffffffc020b0ae:	7c42                	ld	s8,48(sp)
ffffffffc020b0b0:	7ca2                	ld	s9,40(sp)
ffffffffc020b0b2:	7d02                	ld	s10,32(sp)
ffffffffc020b0b4:	6de2                	ld	s11,24(sp)
ffffffffc020b0b6:	6109                	addi	sp,sp,128
ffffffffc020b0b8:	8082                	ret
ffffffffc020b0ba:	882e                	mv	a6,a1
ffffffffc020b0bc:	00144583          	lbu	a1,1(s0)
ffffffffc020b0c0:	846e                	mv	s0,s11
ffffffffc020b0c2:	00140d93          	addi	s11,s0,1
ffffffffc020b0c6:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b0ca:	0ff67613          	zext.b	a2,a2
ffffffffc020b0ce:	fcc572e3          	bgeu	a0,a2,ffffffffc020b092 <vprintfmt+0x78>
ffffffffc020b0d2:	864a                	mv	a2,s2
ffffffffc020b0d4:	85a6                	mv	a1,s1
ffffffffc020b0d6:	02500513          	li	a0,37
ffffffffc020b0da:	9982                	jalr	s3
ffffffffc020b0dc:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b0e0:	8da2                	mv	s11,s0
ffffffffc020b0e2:	f74786e3          	beq	a5,s4,ffffffffc020b04e <vprintfmt+0x34>
ffffffffc020b0e6:	ffedc783          	lbu	a5,-2(s11)
ffffffffc020b0ea:	1dfd                	addi	s11,s11,-1
ffffffffc020b0ec:	ff479de3          	bne	a5,s4,ffffffffc020b0e6 <vprintfmt+0xcc>
ffffffffc020b0f0:	bfb9                	j	ffffffffc020b04e <vprintfmt+0x34>
ffffffffc020b0f2:	fd058c9b          	addiw	s9,a1,-48
ffffffffc020b0f6:	00144583          	lbu	a1,1(s0)
ffffffffc020b0fa:	846e                	mv	s0,s11
ffffffffc020b0fc:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b100:	0005861b          	sext.w	a2,a1
ffffffffc020b104:	02d8e463          	bltu	a7,a3,ffffffffc020b12c <vprintfmt+0x112>
ffffffffc020b108:	00144583          	lbu	a1,1(s0)
ffffffffc020b10c:	002c969b          	slliw	a3,s9,0x2
ffffffffc020b110:	0196873b          	addw	a4,a3,s9
ffffffffc020b114:	0017171b          	slliw	a4,a4,0x1
ffffffffc020b118:	9f31                	addw	a4,a4,a2
ffffffffc020b11a:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b11e:	0405                	addi	s0,s0,1
ffffffffc020b120:	fd070c9b          	addiw	s9,a4,-48
ffffffffc020b124:	0005861b          	sext.w	a2,a1
ffffffffc020b128:	fed8f0e3          	bgeu	a7,a3,ffffffffc020b108 <vprintfmt+0xee>
ffffffffc020b12c:	f40c5be3          	bgez	s8,ffffffffc020b082 <vprintfmt+0x68>
ffffffffc020b130:	8c66                	mv	s8,s9
ffffffffc020b132:	5cfd                	li	s9,-1
ffffffffc020b134:	b7b9                	j	ffffffffc020b082 <vprintfmt+0x68>
ffffffffc020b136:	fffc4693          	not	a3,s8
ffffffffc020b13a:	96fd                	srai	a3,a3,0x3f
ffffffffc020b13c:	00dc77b3          	and	a5,s8,a3
ffffffffc020b140:	00144583          	lbu	a1,1(s0)
ffffffffc020b144:	00078c1b          	sext.w	s8,a5
ffffffffc020b148:	846e                	mv	s0,s11
ffffffffc020b14a:	bf25                	j	ffffffffc020b082 <vprintfmt+0x68>
ffffffffc020b14c:	000aac83          	lw	s9,0(s5)
ffffffffc020b150:	00144583          	lbu	a1,1(s0)
ffffffffc020b154:	0aa1                	addi	s5,s5,8
ffffffffc020b156:	846e                	mv	s0,s11
ffffffffc020b158:	bfd1                	j	ffffffffc020b12c <vprintfmt+0x112>
ffffffffc020b15a:	4705                	li	a4,1
ffffffffc020b15c:	008a8613          	addi	a2,s5,8
ffffffffc020b160:	00674463          	blt	a4,t1,ffffffffc020b168 <vprintfmt+0x14e>
ffffffffc020b164:	1c030c63          	beqz	t1,ffffffffc020b33c <vprintfmt+0x322>
ffffffffc020b168:	000ab683          	ld	a3,0(s5)
ffffffffc020b16c:	4741                	li	a4,16
ffffffffc020b16e:	8ab2                	mv	s5,a2
ffffffffc020b170:	2801                	sext.w	a6,a6
ffffffffc020b172:	87e2                	mv	a5,s8
ffffffffc020b174:	8626                	mv	a2,s1
ffffffffc020b176:	85ca                	mv	a1,s2
ffffffffc020b178:	854e                	mv	a0,s3
ffffffffc020b17a:	e11ff0ef          	jal	ra,ffffffffc020af8a <printnum>
ffffffffc020b17e:	bdc1                	j	ffffffffc020b04e <vprintfmt+0x34>
ffffffffc020b180:	000aa503          	lw	a0,0(s5)
ffffffffc020b184:	864a                	mv	a2,s2
ffffffffc020b186:	85a6                	mv	a1,s1
ffffffffc020b188:	0aa1                	addi	s5,s5,8
ffffffffc020b18a:	9982                	jalr	s3
ffffffffc020b18c:	b5c9                	j	ffffffffc020b04e <vprintfmt+0x34>
ffffffffc020b18e:	4705                	li	a4,1
ffffffffc020b190:	008a8613          	addi	a2,s5,8
ffffffffc020b194:	00674463          	blt	a4,t1,ffffffffc020b19c <vprintfmt+0x182>
ffffffffc020b198:	18030d63          	beqz	t1,ffffffffc020b332 <vprintfmt+0x318>
ffffffffc020b19c:	000ab683          	ld	a3,0(s5)
ffffffffc020b1a0:	4729                	li	a4,10
ffffffffc020b1a2:	8ab2                	mv	s5,a2
ffffffffc020b1a4:	b7f1                	j	ffffffffc020b170 <vprintfmt+0x156>
ffffffffc020b1a6:	00144583          	lbu	a1,1(s0)
ffffffffc020b1aa:	4d05                	li	s10,1
ffffffffc020b1ac:	846e                	mv	s0,s11
ffffffffc020b1ae:	bdd1                	j	ffffffffc020b082 <vprintfmt+0x68>
ffffffffc020b1b0:	864a                	mv	a2,s2
ffffffffc020b1b2:	85a6                	mv	a1,s1
ffffffffc020b1b4:	02500513          	li	a0,37
ffffffffc020b1b8:	9982                	jalr	s3
ffffffffc020b1ba:	bd51                	j	ffffffffc020b04e <vprintfmt+0x34>
ffffffffc020b1bc:	00144583          	lbu	a1,1(s0)
ffffffffc020b1c0:	2305                	addiw	t1,t1,1
ffffffffc020b1c2:	846e                	mv	s0,s11
ffffffffc020b1c4:	bd7d                	j	ffffffffc020b082 <vprintfmt+0x68>
ffffffffc020b1c6:	4705                	li	a4,1
ffffffffc020b1c8:	008a8613          	addi	a2,s5,8
ffffffffc020b1cc:	00674463          	blt	a4,t1,ffffffffc020b1d4 <vprintfmt+0x1ba>
ffffffffc020b1d0:	14030c63          	beqz	t1,ffffffffc020b328 <vprintfmt+0x30e>
ffffffffc020b1d4:	000ab683          	ld	a3,0(s5)
ffffffffc020b1d8:	4721                	li	a4,8
ffffffffc020b1da:	8ab2                	mv	s5,a2
ffffffffc020b1dc:	bf51                	j	ffffffffc020b170 <vprintfmt+0x156>
ffffffffc020b1de:	03000513          	li	a0,48
ffffffffc020b1e2:	864a                	mv	a2,s2
ffffffffc020b1e4:	85a6                	mv	a1,s1
ffffffffc020b1e6:	e042                	sd	a6,0(sp)
ffffffffc020b1e8:	9982                	jalr	s3
ffffffffc020b1ea:	864a                	mv	a2,s2
ffffffffc020b1ec:	85a6                	mv	a1,s1
ffffffffc020b1ee:	07800513          	li	a0,120
ffffffffc020b1f2:	9982                	jalr	s3
ffffffffc020b1f4:	0aa1                	addi	s5,s5,8
ffffffffc020b1f6:	6802                	ld	a6,0(sp)
ffffffffc020b1f8:	4741                	li	a4,16
ffffffffc020b1fa:	ff8ab683          	ld	a3,-8(s5)
ffffffffc020b1fe:	bf8d                	j	ffffffffc020b170 <vprintfmt+0x156>
ffffffffc020b200:	000ab403          	ld	s0,0(s5)
ffffffffc020b204:	008a8793          	addi	a5,s5,8
ffffffffc020b208:	e03e                	sd	a5,0(sp)
ffffffffc020b20a:	14040c63          	beqz	s0,ffffffffc020b362 <vprintfmt+0x348>
ffffffffc020b20e:	11805063          	blez	s8,ffffffffc020b30e <vprintfmt+0x2f4>
ffffffffc020b212:	02d00693          	li	a3,45
ffffffffc020b216:	0cd81963          	bne	a6,a3,ffffffffc020b2e8 <vprintfmt+0x2ce>
ffffffffc020b21a:	00044683          	lbu	a3,0(s0)
ffffffffc020b21e:	0006851b          	sext.w	a0,a3
ffffffffc020b222:	ce8d                	beqz	a3,ffffffffc020b25c <vprintfmt+0x242>
ffffffffc020b224:	00140a93          	addi	s5,s0,1
ffffffffc020b228:	05e00413          	li	s0,94
ffffffffc020b22c:	000cc563          	bltz	s9,ffffffffc020b236 <vprintfmt+0x21c>
ffffffffc020b230:	3cfd                	addiw	s9,s9,-1
ffffffffc020b232:	037c8363          	beq	s9,s7,ffffffffc020b258 <vprintfmt+0x23e>
ffffffffc020b236:	864a                	mv	a2,s2
ffffffffc020b238:	85a6                	mv	a1,s1
ffffffffc020b23a:	100d0663          	beqz	s10,ffffffffc020b346 <vprintfmt+0x32c>
ffffffffc020b23e:	3681                	addiw	a3,a3,-32
ffffffffc020b240:	10d47363          	bgeu	s0,a3,ffffffffc020b346 <vprintfmt+0x32c>
ffffffffc020b244:	03f00513          	li	a0,63
ffffffffc020b248:	9982                	jalr	s3
ffffffffc020b24a:	000ac683          	lbu	a3,0(s5)
ffffffffc020b24e:	3c7d                	addiw	s8,s8,-1
ffffffffc020b250:	0a85                	addi	s5,s5,1
ffffffffc020b252:	0006851b          	sext.w	a0,a3
ffffffffc020b256:	faf9                	bnez	a3,ffffffffc020b22c <vprintfmt+0x212>
ffffffffc020b258:	01805a63          	blez	s8,ffffffffc020b26c <vprintfmt+0x252>
ffffffffc020b25c:	3c7d                	addiw	s8,s8,-1
ffffffffc020b25e:	864a                	mv	a2,s2
ffffffffc020b260:	85a6                	mv	a1,s1
ffffffffc020b262:	02000513          	li	a0,32
ffffffffc020b266:	9982                	jalr	s3
ffffffffc020b268:	fe0c1ae3          	bnez	s8,ffffffffc020b25c <vprintfmt+0x242>
ffffffffc020b26c:	6a82                	ld	s5,0(sp)
ffffffffc020b26e:	b3c5                	j	ffffffffc020b04e <vprintfmt+0x34>
ffffffffc020b270:	4705                	li	a4,1
ffffffffc020b272:	008a8d13          	addi	s10,s5,8
ffffffffc020b276:	00674463          	blt	a4,t1,ffffffffc020b27e <vprintfmt+0x264>
ffffffffc020b27a:	0a030463          	beqz	t1,ffffffffc020b322 <vprintfmt+0x308>
ffffffffc020b27e:	000ab403          	ld	s0,0(s5)
ffffffffc020b282:	0c044463          	bltz	s0,ffffffffc020b34a <vprintfmt+0x330>
ffffffffc020b286:	86a2                	mv	a3,s0
ffffffffc020b288:	8aea                	mv	s5,s10
ffffffffc020b28a:	4729                	li	a4,10
ffffffffc020b28c:	b5d5                	j	ffffffffc020b170 <vprintfmt+0x156>
ffffffffc020b28e:	000aa783          	lw	a5,0(s5)
ffffffffc020b292:	46e1                	li	a3,24
ffffffffc020b294:	0aa1                	addi	s5,s5,8
ffffffffc020b296:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b29a:	8fb9                	xor	a5,a5,a4
ffffffffc020b29c:	40e7873b          	subw	a4,a5,a4
ffffffffc020b2a0:	02e6c663          	blt	a3,a4,ffffffffc020b2cc <vprintfmt+0x2b2>
ffffffffc020b2a4:	00371793          	slli	a5,a4,0x3
ffffffffc020b2a8:	00004697          	auipc	a3,0x4
ffffffffc020b2ac:	24068693          	addi	a3,a3,576 # ffffffffc020f4e8 <error_string>
ffffffffc020b2b0:	97b6                	add	a5,a5,a3
ffffffffc020b2b2:	639c                	ld	a5,0(a5)
ffffffffc020b2b4:	cf81                	beqz	a5,ffffffffc020b2cc <vprintfmt+0x2b2>
ffffffffc020b2b6:	873e                	mv	a4,a5
ffffffffc020b2b8:	00000697          	auipc	a3,0x0
ffffffffc020b2bc:	19068693          	addi	a3,a3,400 # ffffffffc020b448 <etext+0x2c>
ffffffffc020b2c0:	8626                	mv	a2,s1
ffffffffc020b2c2:	85ca                	mv	a1,s2
ffffffffc020b2c4:	854e                	mv	a0,s3
ffffffffc020b2c6:	0d4000ef          	jal	ra,ffffffffc020b39a <printfmt>
ffffffffc020b2ca:	b351                	j	ffffffffc020b04e <vprintfmt+0x34>
ffffffffc020b2cc:	00004697          	auipc	a3,0x4
ffffffffc020b2d0:	edc68693          	addi	a3,a3,-292 # ffffffffc020f1a8 <sfs_node_fileops+0x148>
ffffffffc020b2d4:	8626                	mv	a2,s1
ffffffffc020b2d6:	85ca                	mv	a1,s2
ffffffffc020b2d8:	854e                	mv	a0,s3
ffffffffc020b2da:	0c0000ef          	jal	ra,ffffffffc020b39a <printfmt>
ffffffffc020b2de:	bb85                	j	ffffffffc020b04e <vprintfmt+0x34>
ffffffffc020b2e0:	00004417          	auipc	s0,0x4
ffffffffc020b2e4:	ec040413          	addi	s0,s0,-320 # ffffffffc020f1a0 <sfs_node_fileops+0x140>
ffffffffc020b2e8:	85e6                	mv	a1,s9
ffffffffc020b2ea:	8522                	mv	a0,s0
ffffffffc020b2ec:	e442                	sd	a6,8(sp)
ffffffffc020b2ee:	babff0ef          	jal	ra,ffffffffc020ae98 <strnlen>
ffffffffc020b2f2:	40ac0c3b          	subw	s8,s8,a0
ffffffffc020b2f6:	01805c63          	blez	s8,ffffffffc020b30e <vprintfmt+0x2f4>
ffffffffc020b2fa:	6822                	ld	a6,8(sp)
ffffffffc020b2fc:	00080a9b          	sext.w	s5,a6
ffffffffc020b300:	3c7d                	addiw	s8,s8,-1
ffffffffc020b302:	864a                	mv	a2,s2
ffffffffc020b304:	85a6                	mv	a1,s1
ffffffffc020b306:	8556                	mv	a0,s5
ffffffffc020b308:	9982                	jalr	s3
ffffffffc020b30a:	fe0c1be3          	bnez	s8,ffffffffc020b300 <vprintfmt+0x2e6>
ffffffffc020b30e:	00044683          	lbu	a3,0(s0)
ffffffffc020b312:	00140a93          	addi	s5,s0,1
ffffffffc020b316:	0006851b          	sext.w	a0,a3
ffffffffc020b31a:	daa9                	beqz	a3,ffffffffc020b26c <vprintfmt+0x252>
ffffffffc020b31c:	05e00413          	li	s0,94
ffffffffc020b320:	b731                	j	ffffffffc020b22c <vprintfmt+0x212>
ffffffffc020b322:	000aa403          	lw	s0,0(s5)
ffffffffc020b326:	bfb1                	j	ffffffffc020b282 <vprintfmt+0x268>
ffffffffc020b328:	000ae683          	lwu	a3,0(s5)
ffffffffc020b32c:	4721                	li	a4,8
ffffffffc020b32e:	8ab2                	mv	s5,a2
ffffffffc020b330:	b581                	j	ffffffffc020b170 <vprintfmt+0x156>
ffffffffc020b332:	000ae683          	lwu	a3,0(s5)
ffffffffc020b336:	4729                	li	a4,10
ffffffffc020b338:	8ab2                	mv	s5,a2
ffffffffc020b33a:	bd1d                	j	ffffffffc020b170 <vprintfmt+0x156>
ffffffffc020b33c:	000ae683          	lwu	a3,0(s5)
ffffffffc020b340:	4741                	li	a4,16
ffffffffc020b342:	8ab2                	mv	s5,a2
ffffffffc020b344:	b535                	j	ffffffffc020b170 <vprintfmt+0x156>
ffffffffc020b346:	9982                	jalr	s3
ffffffffc020b348:	b709                	j	ffffffffc020b24a <vprintfmt+0x230>
ffffffffc020b34a:	864a                	mv	a2,s2
ffffffffc020b34c:	85a6                	mv	a1,s1
ffffffffc020b34e:	02d00513          	li	a0,45
ffffffffc020b352:	e042                	sd	a6,0(sp)
ffffffffc020b354:	9982                	jalr	s3
ffffffffc020b356:	6802                	ld	a6,0(sp)
ffffffffc020b358:	8aea                	mv	s5,s10
ffffffffc020b35a:	408006b3          	neg	a3,s0
ffffffffc020b35e:	4729                	li	a4,10
ffffffffc020b360:	bd01                	j	ffffffffc020b170 <vprintfmt+0x156>
ffffffffc020b362:	03805163          	blez	s8,ffffffffc020b384 <vprintfmt+0x36a>
ffffffffc020b366:	02d00693          	li	a3,45
ffffffffc020b36a:	f6d81be3          	bne	a6,a3,ffffffffc020b2e0 <vprintfmt+0x2c6>
ffffffffc020b36e:	00004417          	auipc	s0,0x4
ffffffffc020b372:	e3240413          	addi	s0,s0,-462 # ffffffffc020f1a0 <sfs_node_fileops+0x140>
ffffffffc020b376:	02800693          	li	a3,40
ffffffffc020b37a:	02800513          	li	a0,40
ffffffffc020b37e:	00140a93          	addi	s5,s0,1
ffffffffc020b382:	b55d                	j	ffffffffc020b228 <vprintfmt+0x20e>
ffffffffc020b384:	00004a97          	auipc	s5,0x4
ffffffffc020b388:	e1da8a93          	addi	s5,s5,-483 # ffffffffc020f1a1 <sfs_node_fileops+0x141>
ffffffffc020b38c:	02800513          	li	a0,40
ffffffffc020b390:	02800693          	li	a3,40
ffffffffc020b394:	05e00413          	li	s0,94
ffffffffc020b398:	bd51                	j	ffffffffc020b22c <vprintfmt+0x212>

ffffffffc020b39a <printfmt>:
ffffffffc020b39a:	7139                	addi	sp,sp,-64
ffffffffc020b39c:	02010313          	addi	t1,sp,32
ffffffffc020b3a0:	f03a                	sd	a4,32(sp)
ffffffffc020b3a2:	871a                	mv	a4,t1
ffffffffc020b3a4:	ec06                	sd	ra,24(sp)
ffffffffc020b3a6:	f43e                	sd	a5,40(sp)
ffffffffc020b3a8:	f842                	sd	a6,48(sp)
ffffffffc020b3aa:	fc46                	sd	a7,56(sp)
ffffffffc020b3ac:	e41a                	sd	t1,8(sp)
ffffffffc020b3ae:	c6dff0ef          	jal	ra,ffffffffc020b01a <vprintfmt>
ffffffffc020b3b2:	60e2                	ld	ra,24(sp)
ffffffffc020b3b4:	6121                	addi	sp,sp,64
ffffffffc020b3b6:	8082                	ret

ffffffffc020b3b8 <snprintf>:
ffffffffc020b3b8:	711d                	addi	sp,sp,-96
ffffffffc020b3ba:	15fd                	addi	a1,a1,-1
ffffffffc020b3bc:	03810313          	addi	t1,sp,56
ffffffffc020b3c0:	95aa                	add	a1,a1,a0
ffffffffc020b3c2:	f406                	sd	ra,40(sp)
ffffffffc020b3c4:	fc36                	sd	a3,56(sp)
ffffffffc020b3c6:	e0ba                	sd	a4,64(sp)
ffffffffc020b3c8:	e4be                	sd	a5,72(sp)
ffffffffc020b3ca:	e8c2                	sd	a6,80(sp)
ffffffffc020b3cc:	ecc6                	sd	a7,88(sp)
ffffffffc020b3ce:	e01a                	sd	t1,0(sp)
ffffffffc020b3d0:	e42a                	sd	a0,8(sp)
ffffffffc020b3d2:	e82e                	sd	a1,16(sp)
ffffffffc020b3d4:	cc02                	sw	zero,24(sp)
ffffffffc020b3d6:	c515                	beqz	a0,ffffffffc020b402 <snprintf+0x4a>
ffffffffc020b3d8:	02a5e563          	bltu	a1,a0,ffffffffc020b402 <snprintf+0x4a>
ffffffffc020b3dc:	75dd                	lui	a1,0xffff7
ffffffffc020b3de:	86b2                	mv	a3,a2
ffffffffc020b3e0:	00000517          	auipc	a0,0x0
ffffffffc020b3e4:	c2050513          	addi	a0,a0,-992 # ffffffffc020b000 <sprintputch>
ffffffffc020b3e8:	871a                	mv	a4,t1
ffffffffc020b3ea:	0030                	addi	a2,sp,8
ffffffffc020b3ec:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b3f0:	c2bff0ef          	jal	ra,ffffffffc020b01a <vprintfmt>
ffffffffc020b3f4:	67a2                	ld	a5,8(sp)
ffffffffc020b3f6:	00078023          	sb	zero,0(a5)
ffffffffc020b3fa:	4562                	lw	a0,24(sp)
ffffffffc020b3fc:	70a2                	ld	ra,40(sp)
ffffffffc020b3fe:	6125                	addi	sp,sp,96
ffffffffc020b400:	8082                	ret
ffffffffc020b402:	5575                	li	a0,-3
ffffffffc020b404:	bfe5                	j	ffffffffc020b3fc <snprintf+0x44>

ffffffffc020b406 <hash32>:
ffffffffc020b406:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b40a:	2785                	addiw	a5,a5,1
ffffffffc020b40c:	02a7853b          	mulw	a0,a5,a0
ffffffffc020b410:	02000793          	li	a5,32
ffffffffc020b414:	9f8d                	subw	a5,a5,a1
ffffffffc020b416:	00f5553b          	srlw	a0,a0,a5
ffffffffc020b41a:	8082                	ret
