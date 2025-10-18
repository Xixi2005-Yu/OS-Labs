
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00006297          	auipc	t0,0x6
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0206000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00006297          	auipc	t0,0x6
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0206008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02052b7          	lui	t0,0xc0205
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	0d828293          	addi	t0,t0,216 # ffffffffc02000d8 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00002517          	auipc	a0,0x2
ffffffffc0200050:	98450513          	addi	a0,a0,-1660 # ffffffffc02019d0 <etext+0x2>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07e58593          	addi	a1,a1,126 # ffffffffc02000d8 <kern_init>
ffffffffc0200062:	00002517          	auipc	a0,0x2
ffffffffc0200066:	98e50513          	addi	a0,a0,-1650 # ffffffffc02019f0 <etext+0x22>
ffffffffc020006a:	0e2000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00002597          	auipc	a1,0x2
ffffffffc0200072:	96058593          	addi	a1,a1,-1696 # ffffffffc02019ce <etext>
ffffffffc0200076:	00002517          	auipc	a0,0x2
ffffffffc020007a:	99a50513          	addi	a0,a0,-1638 # ffffffffc0201a10 <etext+0x42>
ffffffffc020007e:	0ce000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00006597          	auipc	a1,0x6
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0206018 <buddy_free_areas>
ffffffffc020008a:	00002517          	auipc	a0,0x2
ffffffffc020008e:	9a650513          	addi	a0,a0,-1626 # ffffffffc0201a30 <etext+0x62>
ffffffffc0200092:	0ba000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00006597          	auipc	a1,0x6
ffffffffc020009a:	13258593          	addi	a1,a1,306 # ffffffffc02061c8 <end>
ffffffffc020009e:	00002517          	auipc	a0,0x2
ffffffffc02000a2:	9b250513          	addi	a0,a0,-1614 # ffffffffc0201a50 <etext+0x82>
ffffffffc02000a6:	0a6000ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00006597          	auipc	a1,0x6
ffffffffc02000ae:	51d58593          	addi	a1,a1,1309 # ffffffffc02065c7 <end+0x3ff>
ffffffffc02000b2:	00000797          	auipc	a5,0x0
ffffffffc02000b6:	02678793          	addi	a5,a5,38 # ffffffffc02000d8 <kern_init>
ffffffffc02000ba:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000be:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c8:	95be                	add	a1,a1,a5
ffffffffc02000ca:	85a9                	srai	a1,a1,0xa
ffffffffc02000cc:	00002517          	auipc	a0,0x2
ffffffffc02000d0:	9a450513          	addi	a0,a0,-1628 # ffffffffc0201a70 <etext+0xa2>
}
ffffffffc02000d4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d6:	a89d                	j	ffffffffc020014c <cprintf>

ffffffffc02000d8 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d8:	00006517          	auipc	a0,0x6
ffffffffc02000dc:	f4050513          	addi	a0,a0,-192 # ffffffffc0206018 <buddy_free_areas>
ffffffffc02000e0:	00006617          	auipc	a2,0x6
ffffffffc02000e4:	0e860613          	addi	a2,a2,232 # ffffffffc02061c8 <end>
int kern_init(void) {
ffffffffc02000e8:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000ea:	8e09                	sub	a2,a2,a0
ffffffffc02000ec:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ee:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000f0:	0cd010ef          	jal	ra,ffffffffc02019bc <memset>
    dtb_init();
ffffffffc02000f4:	12c000ef          	jal	ra,ffffffffc0200220 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f8:	11e000ef          	jal	ra,ffffffffc0200216 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fc:	00002517          	auipc	a0,0x2
ffffffffc0200100:	9a450513          	addi	a0,a0,-1628 # ffffffffc0201aa0 <etext+0xd2>
ffffffffc0200104:	07e000ef          	jal	ra,ffffffffc0200182 <cputs>

    print_kerninfo();
ffffffffc0200108:	f43ff0ef          	jal	ra,ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010c:	256010ef          	jal	ra,ffffffffc0201362 <pmm_init>

    /* do nothing */
    while (1)
ffffffffc0200110:	a001                	j	ffffffffc0200110 <kern_init+0x38>

ffffffffc0200112 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200112:	1141                	addi	sp,sp,-16
ffffffffc0200114:	e022                	sd	s0,0(sp)
ffffffffc0200116:	e406                	sd	ra,8(sp)
ffffffffc0200118:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020011a:	0fe000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    (*cnt) ++;
ffffffffc020011e:	401c                	lw	a5,0(s0)
}
ffffffffc0200120:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200122:	2785                	addiw	a5,a5,1
ffffffffc0200124:	c01c                	sw	a5,0(s0)
}
ffffffffc0200126:	6402                	ld	s0,0(sp)
ffffffffc0200128:	0141                	addi	sp,sp,16
ffffffffc020012a:	8082                	ret

ffffffffc020012c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020012c:	1101                	addi	sp,sp,-32
ffffffffc020012e:	862a                	mv	a2,a0
ffffffffc0200130:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200132:	00000517          	auipc	a0,0x0
ffffffffc0200136:	fe050513          	addi	a0,a0,-32 # ffffffffc0200112 <cputch>
ffffffffc020013a:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc020013c:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013e:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200140:	466010ef          	jal	ra,ffffffffc02015a6 <vprintfmt>
    return cnt;
}
ffffffffc0200144:	60e2                	ld	ra,24(sp)
ffffffffc0200146:	4532                	lw	a0,12(sp)
ffffffffc0200148:	6105                	addi	sp,sp,32
ffffffffc020014a:	8082                	ret

ffffffffc020014c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc020014c:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014e:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200152:	8e2a                	mv	t3,a0
ffffffffc0200154:	f42e                	sd	a1,40(sp)
ffffffffc0200156:	f832                	sd	a2,48(sp)
ffffffffc0200158:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020015a:	00000517          	auipc	a0,0x0
ffffffffc020015e:	fb850513          	addi	a0,a0,-72 # ffffffffc0200112 <cputch>
ffffffffc0200162:	004c                	addi	a1,sp,4
ffffffffc0200164:	869a                	mv	a3,t1
ffffffffc0200166:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc0200168:	ec06                	sd	ra,24(sp)
ffffffffc020016a:	e0ba                	sd	a4,64(sp)
ffffffffc020016c:	e4be                	sd	a5,72(sp)
ffffffffc020016e:	e8c2                	sd	a6,80(sp)
ffffffffc0200170:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200172:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200174:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200176:	430010ef          	jal	ra,ffffffffc02015a6 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020017a:	60e2                	ld	ra,24(sp)
ffffffffc020017c:	4512                	lw	a0,4(sp)
ffffffffc020017e:	6125                	addi	sp,sp,96
ffffffffc0200180:	8082                	ret

ffffffffc0200182 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200182:	1101                	addi	sp,sp,-32
ffffffffc0200184:	e822                	sd	s0,16(sp)
ffffffffc0200186:	ec06                	sd	ra,24(sp)
ffffffffc0200188:	e426                	sd	s1,8(sp)
ffffffffc020018a:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc020018c:	00054503          	lbu	a0,0(a0)
ffffffffc0200190:	c51d                	beqz	a0,ffffffffc02001be <cputs+0x3c>
ffffffffc0200192:	0405                	addi	s0,s0,1
ffffffffc0200194:	4485                	li	s1,1
ffffffffc0200196:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200198:	080000ef          	jal	ra,ffffffffc0200218 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020019c:	00044503          	lbu	a0,0(s0)
ffffffffc02001a0:	008487bb          	addw	a5,s1,s0
ffffffffc02001a4:	0405                	addi	s0,s0,1
ffffffffc02001a6:	f96d                	bnez	a0,ffffffffc0200198 <cputs+0x16>
    (*cnt) ++;
ffffffffc02001a8:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001ac:	4529                	li	a0,10
ffffffffc02001ae:	06a000ef          	jal	ra,ffffffffc0200218 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001b2:	60e2                	ld	ra,24(sp)
ffffffffc02001b4:	8522                	mv	a0,s0
ffffffffc02001b6:	6442                	ld	s0,16(sp)
ffffffffc02001b8:	64a2                	ld	s1,8(sp)
ffffffffc02001ba:	6105                	addi	sp,sp,32
ffffffffc02001bc:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001be:	4405                	li	s0,1
ffffffffc02001c0:	b7f5                	j	ffffffffc02001ac <cputs+0x2a>

ffffffffc02001c2 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c2:	00006317          	auipc	t1,0x6
ffffffffc02001c6:	fbe30313          	addi	t1,t1,-66 # ffffffffc0206180 <is_panic>
ffffffffc02001ca:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001ce:	715d                	addi	sp,sp,-80
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001de:	000e0363          	beqz	t3,ffffffffc02001e4 <__panic+0x22>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x20>
    is_panic = 1;
ffffffffc02001e4:	4785                	li	a5,1
ffffffffc02001e6:	00f32023          	sw	a5,0(t1)
    va_start(ap, fmt);
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001ee:	862e                	mv	a2,a1
ffffffffc02001f0:	85aa                	mv	a1,a0
ffffffffc02001f2:	00002517          	auipc	a0,0x2
ffffffffc02001f6:	8ce50513          	addi	a0,a0,-1842 # ffffffffc0201ac0 <etext+0xf2>
    va_start(ap, fmt);
ffffffffc02001fa:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001fc:	f51ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200200:	65a2                	ld	a1,8(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	f29ff0ef          	jal	ra,ffffffffc020012c <vcprintf>
    cprintf("\n");
ffffffffc0200208:	00002517          	auipc	a0,0x2
ffffffffc020020c:	2f850513          	addi	a0,a0,760 # ffffffffc0202500 <etext+0xb32>
ffffffffc0200210:	f3dff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200214:	b7f9                	j	ffffffffc02001e2 <__panic+0x20>

ffffffffc0200216 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200216:	8082                	ret

ffffffffc0200218 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200218:	0ff57513          	zext.b	a0,a0
ffffffffc020021c:	70c0106f          	j	ffffffffc0201928 <sbi_console_putchar>

ffffffffc0200220 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200220:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200222:	00002517          	auipc	a0,0x2
ffffffffc0200226:	8be50513          	addi	a0,a0,-1858 # ffffffffc0201ae0 <etext+0x112>
void dtb_init(void) {
ffffffffc020022a:	fc86                	sd	ra,120(sp)
ffffffffc020022c:	f8a2                	sd	s0,112(sp)
ffffffffc020022e:	e8d2                	sd	s4,80(sp)
ffffffffc0200230:	f4a6                	sd	s1,104(sp)
ffffffffc0200232:	f0ca                	sd	s2,96(sp)
ffffffffc0200234:	ecce                	sd	s3,88(sp)
ffffffffc0200236:	e4d6                	sd	s5,72(sp)
ffffffffc0200238:	e0da                	sd	s6,64(sp)
ffffffffc020023a:	fc5e                	sd	s7,56(sp)
ffffffffc020023c:	f862                	sd	s8,48(sp)
ffffffffc020023e:	f466                	sd	s9,40(sp)
ffffffffc0200240:	f06a                	sd	s10,32(sp)
ffffffffc0200242:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200244:	f09ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200248:	00006597          	auipc	a1,0x6
ffffffffc020024c:	db85b583          	ld	a1,-584(a1) # ffffffffc0206000 <boot_hartid>
ffffffffc0200250:	00002517          	auipc	a0,0x2
ffffffffc0200254:	8a050513          	addi	a0,a0,-1888 # ffffffffc0201af0 <etext+0x122>
ffffffffc0200258:	ef5ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020025c:	00006417          	auipc	s0,0x6
ffffffffc0200260:	dac40413          	addi	s0,s0,-596 # ffffffffc0206008 <boot_dtb>
ffffffffc0200264:	600c                	ld	a1,0(s0)
ffffffffc0200266:	00002517          	auipc	a0,0x2
ffffffffc020026a:	89a50513          	addi	a0,a0,-1894 # ffffffffc0201b00 <etext+0x132>
ffffffffc020026e:	edfff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200272:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200276:	00002517          	auipc	a0,0x2
ffffffffc020027a:	8a250513          	addi	a0,a0,-1886 # ffffffffc0201b18 <etext+0x14a>
    if (boot_dtb == 0) {
ffffffffc020027e:	120a0463          	beqz	s4,ffffffffc02003a6 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200282:	57f5                	li	a5,-3
ffffffffc0200284:	07fa                	slli	a5,a5,0x1e
ffffffffc0200286:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc020028a:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020028c:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200290:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200292:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200296:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020029a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020029e:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a2:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002a6:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002a8:	8ec9                	or	a3,a3,a0
ffffffffc02002aa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002ae:	1b7d                	addi	s6,s6,-1
ffffffffc02002b0:	0167f7b3          	and	a5,a5,s6
ffffffffc02002b4:	8dd5                	or	a1,a1,a3
ffffffffc02002b6:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02002b8:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002bc:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02002be:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed9d25>
ffffffffc02002c2:	10f59163          	bne	a1,a5,ffffffffc02003c4 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02002c6:	471c                	lw	a5,8(a4)
ffffffffc02002c8:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02002ca:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002cc:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02002d0:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02002d4:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d8:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002dc:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e0:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e4:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e8:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ec:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002f4:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002f6:	01146433          	or	s0,s0,a7
ffffffffc02002fa:	0086969b          	slliw	a3,a3,0x8
ffffffffc02002fe:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200302:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200304:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200308:	8c49                	or	s0,s0,a0
ffffffffc020030a:	0166f6b3          	and	a3,a3,s6
ffffffffc020030e:	00ca6a33          	or	s4,s4,a2
ffffffffc0200312:	0167f7b3          	and	a5,a5,s6
ffffffffc0200316:	8c55                	or	s0,s0,a3
ffffffffc0200318:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020031c:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020031e:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200320:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200322:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200326:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200328:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020032a:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020032e:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200330:	00002917          	auipc	s2,0x2
ffffffffc0200334:	83890913          	addi	s2,s2,-1992 # ffffffffc0201b68 <etext+0x19a>
ffffffffc0200338:	49bd                	li	s3,15
        switch (token) {
ffffffffc020033a:	4d91                	li	s11,4
ffffffffc020033c:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020033e:	00002497          	auipc	s1,0x2
ffffffffc0200342:	82248493          	addi	s1,s1,-2014 # ffffffffc0201b60 <etext+0x192>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200346:	000a2703          	lw	a4,0(s4)
ffffffffc020034a:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020034e:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200352:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200356:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020035a:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020035e:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200362:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200364:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200368:	0087171b          	slliw	a4,a4,0x8
ffffffffc020036c:	8fd5                	or	a5,a5,a3
ffffffffc020036e:	00eb7733          	and	a4,s6,a4
ffffffffc0200372:	8fd9                	or	a5,a5,a4
ffffffffc0200374:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200376:	09778c63          	beq	a5,s7,ffffffffc020040e <dtb_init+0x1ee>
ffffffffc020037a:	00fbea63          	bltu	s7,a5,ffffffffc020038e <dtb_init+0x16e>
ffffffffc020037e:	07a78663          	beq	a5,s10,ffffffffc02003ea <dtb_init+0x1ca>
ffffffffc0200382:	4709                	li	a4,2
ffffffffc0200384:	00e79763          	bne	a5,a4,ffffffffc0200392 <dtb_init+0x172>
ffffffffc0200388:	4c81                	li	s9,0
ffffffffc020038a:	8a56                	mv	s4,s5
ffffffffc020038c:	bf6d                	j	ffffffffc0200346 <dtb_init+0x126>
ffffffffc020038e:	ffb78ee3          	beq	a5,s11,ffffffffc020038a <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200392:	00002517          	auipc	a0,0x2
ffffffffc0200396:	84e50513          	addi	a0,a0,-1970 # ffffffffc0201be0 <etext+0x212>
ffffffffc020039a:	db3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020039e:	00002517          	auipc	a0,0x2
ffffffffc02003a2:	87a50513          	addi	a0,a0,-1926 # ffffffffc0201c18 <etext+0x24a>
}
ffffffffc02003a6:	7446                	ld	s0,112(sp)
ffffffffc02003a8:	70e6                	ld	ra,120(sp)
ffffffffc02003aa:	74a6                	ld	s1,104(sp)
ffffffffc02003ac:	7906                	ld	s2,96(sp)
ffffffffc02003ae:	69e6                	ld	s3,88(sp)
ffffffffc02003b0:	6a46                	ld	s4,80(sp)
ffffffffc02003b2:	6aa6                	ld	s5,72(sp)
ffffffffc02003b4:	6b06                	ld	s6,64(sp)
ffffffffc02003b6:	7be2                	ld	s7,56(sp)
ffffffffc02003b8:	7c42                	ld	s8,48(sp)
ffffffffc02003ba:	7ca2                	ld	s9,40(sp)
ffffffffc02003bc:	7d02                	ld	s10,32(sp)
ffffffffc02003be:	6de2                	ld	s11,24(sp)
ffffffffc02003c0:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02003c2:	b369                	j	ffffffffc020014c <cprintf>
}
ffffffffc02003c4:	7446                	ld	s0,112(sp)
ffffffffc02003c6:	70e6                	ld	ra,120(sp)
ffffffffc02003c8:	74a6                	ld	s1,104(sp)
ffffffffc02003ca:	7906                	ld	s2,96(sp)
ffffffffc02003cc:	69e6                	ld	s3,88(sp)
ffffffffc02003ce:	6a46                	ld	s4,80(sp)
ffffffffc02003d0:	6aa6                	ld	s5,72(sp)
ffffffffc02003d2:	6b06                	ld	s6,64(sp)
ffffffffc02003d4:	7be2                	ld	s7,56(sp)
ffffffffc02003d6:	7c42                	ld	s8,48(sp)
ffffffffc02003d8:	7ca2                	ld	s9,40(sp)
ffffffffc02003da:	7d02                	ld	s10,32(sp)
ffffffffc02003dc:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003de:	00001517          	auipc	a0,0x1
ffffffffc02003e2:	75a50513          	addi	a0,a0,1882 # ffffffffc0201b38 <etext+0x16a>
}
ffffffffc02003e6:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003e8:	b395                	j	ffffffffc020014c <cprintf>
                int name_len = strlen(name);
ffffffffc02003ea:	8556                	mv	a0,s5
ffffffffc02003ec:	556010ef          	jal	ra,ffffffffc0201942 <strlen>
ffffffffc02003f0:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003f2:	4619                	li	a2,6
ffffffffc02003f4:	85a6                	mv	a1,s1
ffffffffc02003f6:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02003f8:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003fa:	59c010ef          	jal	ra,ffffffffc0201996 <strncmp>
ffffffffc02003fe:	e111                	bnez	a0,ffffffffc0200402 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200400:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200402:	0a91                	addi	s5,s5,4
ffffffffc0200404:	9ad2                	add	s5,s5,s4
ffffffffc0200406:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020040a:	8a56                	mv	s4,s5
ffffffffc020040c:	bf2d                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020040e:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200412:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200416:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020041a:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020041e:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200422:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200426:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020042a:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020042e:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200432:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200436:	00eaeab3          	or	s5,s5,a4
ffffffffc020043a:	00fb77b3          	and	a5,s6,a5
ffffffffc020043e:	00faeab3          	or	s5,s5,a5
ffffffffc0200442:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200444:	000c9c63          	bnez	s9,ffffffffc020045c <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200448:	1a82                	slli	s5,s5,0x20
ffffffffc020044a:	00368793          	addi	a5,a3,3
ffffffffc020044e:	020ada93          	srli	s5,s5,0x20
ffffffffc0200452:	9abe                	add	s5,s5,a5
ffffffffc0200454:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200458:	8a56                	mv	s4,s5
ffffffffc020045a:	b5f5                	j	ffffffffc0200346 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020045c:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200460:	85ca                	mv	a1,s2
ffffffffc0200462:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200464:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200468:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020046c:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200470:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200474:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200478:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020047a:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020047e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200482:	8d59                	or	a0,a0,a4
ffffffffc0200484:	00fb77b3          	and	a5,s6,a5
ffffffffc0200488:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc020048a:	1502                	slli	a0,a0,0x20
ffffffffc020048c:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020048e:	9522                	add	a0,a0,s0
ffffffffc0200490:	4e8010ef          	jal	ra,ffffffffc0201978 <strcmp>
ffffffffc0200494:	66a2                	ld	a3,8(sp)
ffffffffc0200496:	f94d                	bnez	a0,ffffffffc0200448 <dtb_init+0x228>
ffffffffc0200498:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200448 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020049c:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02004a0:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02004a4:	00001517          	auipc	a0,0x1
ffffffffc02004a8:	6cc50513          	addi	a0,a0,1740 # ffffffffc0201b70 <etext+0x1a2>
           fdt32_to_cpu(x >> 32);
ffffffffc02004ac:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b0:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02004b4:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b8:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02004bc:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c0:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c4:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c8:	0187d693          	srli	a3,a5,0x18
ffffffffc02004cc:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02004d0:	0087579b          	srliw	a5,a4,0x8
ffffffffc02004d4:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d8:	0106561b          	srliw	a2,a2,0x10
ffffffffc02004dc:	010f6f33          	or	t5,t5,a6
ffffffffc02004e0:	0187529b          	srliw	t0,a4,0x18
ffffffffc02004e4:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e8:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ec:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02004f4:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02004f8:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200500:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200504:	8361                	srli	a4,a4,0x18
ffffffffc0200506:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020050a:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020050e:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200512:	00cb7633          	and	a2,s6,a2
ffffffffc0200516:	0088181b          	slliw	a6,a6,0x8
ffffffffc020051a:	0085959b          	slliw	a1,a1,0x8
ffffffffc020051e:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200522:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200526:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052a:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020052e:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200532:	011b78b3          	and	a7,s6,a7
ffffffffc0200536:	005eeeb3          	or	t4,t4,t0
ffffffffc020053a:	00c6e733          	or	a4,a3,a2
ffffffffc020053e:	006c6c33          	or	s8,s8,t1
ffffffffc0200542:	010b76b3          	and	a3,s6,a6
ffffffffc0200546:	00bb7b33          	and	s6,s6,a1
ffffffffc020054a:	01d7e7b3          	or	a5,a5,t4
ffffffffc020054e:	016c6b33          	or	s6,s8,s6
ffffffffc0200552:	01146433          	or	s0,s0,a7
ffffffffc0200556:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200558:	1702                	slli	a4,a4,0x20
ffffffffc020055a:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020055c:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020055e:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200560:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200562:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200566:	0167eb33          	or	s6,a5,s6
ffffffffc020056a:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020056c:	be1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200570:	85a2                	mv	a1,s0
ffffffffc0200572:	00001517          	auipc	a0,0x1
ffffffffc0200576:	61e50513          	addi	a0,a0,1566 # ffffffffc0201b90 <etext+0x1c2>
ffffffffc020057a:	bd3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020057e:	014b5613          	srli	a2,s6,0x14
ffffffffc0200582:	85da                	mv	a1,s6
ffffffffc0200584:	00001517          	auipc	a0,0x1
ffffffffc0200588:	62450513          	addi	a0,a0,1572 # ffffffffc0201ba8 <etext+0x1da>
ffffffffc020058c:	bc1ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200590:	008b05b3          	add	a1,s6,s0
ffffffffc0200594:	15fd                	addi	a1,a1,-1
ffffffffc0200596:	00001517          	auipc	a0,0x1
ffffffffc020059a:	63250513          	addi	a0,a0,1586 # ffffffffc0201bc8 <etext+0x1fa>
ffffffffc020059e:	bafff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02005a2:	00001517          	auipc	a0,0x1
ffffffffc02005a6:	67650513          	addi	a0,a0,1654 # ffffffffc0201c18 <etext+0x24a>
        memory_base = mem_base;
ffffffffc02005aa:	00006797          	auipc	a5,0x6
ffffffffc02005ae:	bc87bf23          	sd	s0,-1058(a5) # ffffffffc0206188 <memory_base>
        memory_size = mem_size;
ffffffffc02005b2:	00006797          	auipc	a5,0x6
ffffffffc02005b6:	bd67bf23          	sd	s6,-1058(a5) # ffffffffc0206190 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02005ba:	b3f5                	j	ffffffffc02003a6 <dtb_init+0x186>

ffffffffc02005bc <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02005bc:	00006517          	auipc	a0,0x6
ffffffffc02005c0:	bcc53503          	ld	a0,-1076(a0) # ffffffffc0206188 <memory_base>
ffffffffc02005c4:	8082                	ret

ffffffffc02005c6 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc02005c6:	00006517          	auipc	a0,0x6
ffffffffc02005ca:	bca53503          	ld	a0,-1078(a0) # ffffffffc0206190 <memory_size>
ffffffffc02005ce:	8082                	ret

ffffffffc02005d0 <buddy_nr_free_pages>:
}

// 9. 辅助函数：统计空闲页总数
static size_t buddy_nr_free_pages(void) {
    size_t total = 0;
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc02005d0:	00006697          	auipc	a3,0x6
ffffffffc02005d4:	a5868693          	addi	a3,a3,-1448 # ffffffffc0206028 <buddy_free_areas+0x10>
ffffffffc02005d8:	4701                	li	a4,0
    size_t total = 0;
ffffffffc02005da:	4501                	li	a0,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc02005dc:	463d                	li	a2,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc02005de:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc02005e0:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc02005e2:	00e797bb          	sllw	a5,a5,a4
ffffffffc02005e6:	1782                	slli	a5,a5,0x20
ffffffffc02005e8:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc02005ea:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc02005ec:	953e                	add	a0,a0,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc02005ee:	fec718e3          	bne	a4,a2,ffffffffc02005de <buddy_nr_free_pages+0xe>
    }
    return total;
}
ffffffffc02005f2:	8082                	ret

ffffffffc02005f4 <buddy_debug_info>:

// 调试函数：打印所有order的空闲块信息
static void buddy_debug_info(void) {
ffffffffc02005f4:	7179                	addi	sp,sp,-48
ffffffffc02005f6:	ec26                	sd	s1,24(sp)
    cprintf("=== Buddy System Debug Info ===\n");
ffffffffc02005f8:	00001517          	auipc	a0,0x1
ffffffffc02005fc:	63850513          	addi	a0,a0,1592 # ffffffffc0201c30 <etext+0x262>
ffffffffc0200600:	00006497          	auipc	s1,0x6
ffffffffc0200604:	a2848493          	addi	s1,s1,-1496 # ffffffffc0206028 <buddy_free_areas+0x10>
static void buddy_debug_info(void) {
ffffffffc0200608:	f022                	sd	s0,32(sp)
ffffffffc020060a:	e84a                	sd	s2,16(sp)
ffffffffc020060c:	e44e                	sd	s3,8(sp)
ffffffffc020060e:	e052                	sd	s4,0(sp)
ffffffffc0200610:	f406                	sd	ra,40(sp)
    cprintf("=== Buddy System Debug Info ===\n");
ffffffffc0200612:	8926                	mv	s2,s1
ffffffffc0200614:	b39ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200618:	4401                	li	s0,0
        if (buddy_free_areas[i].nr_free > 0) {
            cprintf("Order %d: %d blocks, %d pages total\n", 
ffffffffc020061a:	00001a17          	auipc	s4,0x1
ffffffffc020061e:	63ea0a13          	addi	s4,s4,1598 # ffffffffc0201c58 <etext+0x28a>
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200622:	49bd                	li	s3,15
ffffffffc0200624:	a021                	j	ffffffffc020062c <buddy_debug_info+0x38>
ffffffffc0200626:	2405                	addiw	s0,s0,1
ffffffffc0200628:	01340f63          	beq	s0,s3,ffffffffc0200646 <buddy_debug_info+0x52>
        if (buddy_free_areas[i].nr_free > 0) {
ffffffffc020062c:	00092603          	lw	a2,0(s2)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200630:	0961                	addi	s2,s2,24
        if (buddy_free_areas[i].nr_free > 0) {
ffffffffc0200632:	da75                	beqz	a2,ffffffffc0200626 <buddy_debug_info+0x32>
            cprintf("Order %d: %d blocks, %d pages total\n", 
ffffffffc0200634:	008616bb          	sllw	a3,a2,s0
ffffffffc0200638:	85a2                	mv	a1,s0
ffffffffc020063a:	8552                	mv	a0,s4
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020063c:	2405                	addiw	s0,s0,1
            cprintf("Order %d: %d blocks, %d pages total\n", 
ffffffffc020063e:	b0fff0ef          	jal	ra,ffffffffc020014c <cprintf>
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200642:	ff3415e3          	bne	s0,s3,ffffffffc020062c <buddy_debug_info+0x38>
    size_t total = 0;
ffffffffc0200646:	4581                	li	a1,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200648:	4701                	li	a4,0
ffffffffc020064a:	46bd                	li	a3,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc020064c:	409c                	lw	a5,0(s1)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020064e:	04e1                	addi	s1,s1,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200650:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200654:	1782                	slli	a5,a5,0x20
ffffffffc0200656:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200658:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc020065a:	95be                	add	a1,a1,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020065c:	fed718e3          	bne	a4,a3,ffffffffc020064c <buddy_debug_info+0x58>
                    i, buddy_free_areas[i].nr_free, 
                    buddy_free_areas[i].nr_free * BLOCK_SIZE(i));
        }
    }
    cprintf("Total free pages: %d\n", (int)buddy_nr_free_pages());
ffffffffc0200660:	2581                	sext.w	a1,a1
ffffffffc0200662:	00001517          	auipc	a0,0x1
ffffffffc0200666:	61e50513          	addi	a0,a0,1566 # ffffffffc0201c80 <etext+0x2b2>
ffffffffc020066a:	ae3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    cprintf("===============================\n");
}
ffffffffc020066e:	7402                	ld	s0,32(sp)
ffffffffc0200670:	70a2                	ld	ra,40(sp)
ffffffffc0200672:	64e2                	ld	s1,24(sp)
ffffffffc0200674:	6942                	ld	s2,16(sp)
ffffffffc0200676:	69a2                	ld	s3,8(sp)
ffffffffc0200678:	6a02                	ld	s4,0(sp)
    cprintf("===============================\n");
ffffffffc020067a:	00001517          	auipc	a0,0x1
ffffffffc020067e:	61e50513          	addi	a0,a0,1566 # ffffffffc0201c98 <etext+0x2ca>
}
ffffffffc0200682:	6145                	addi	sp,sp,48
    cprintf("===============================\n");
ffffffffc0200684:	b4e1                	j	ffffffffc020014c <cprintf>

ffffffffc0200686 <buddy_init>:
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200686:	00006797          	auipc	a5,0x6
ffffffffc020068a:	99278793          	addi	a5,a5,-1646 # ffffffffc0206018 <buddy_free_areas>
ffffffffc020068e:	00006717          	auipc	a4,0x6
ffffffffc0200692:	af270713          	addi	a4,a4,-1294 # ffffffffc0206180 <is_panic>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200696:	e79c                	sd	a5,8(a5)
ffffffffc0200698:	e39c                	sd	a5,0(a5)
        buddy_free_areas[i].nr_free = 0;
ffffffffc020069a:	0007a823          	sw	zero,16(a5)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020069e:	07e1                	addi	a5,a5,24
ffffffffc02006a0:	fee79be3          	bne	a5,a4,ffffffffc0200696 <buddy_init+0x10>
    cprintf("buddy_pmm: init completed (max order: %d, max block size: %d pages)\n", 
ffffffffc02006a4:	6611                	lui	a2,0x4
ffffffffc02006a6:	45b9                	li	a1,14
ffffffffc02006a8:	00001517          	auipc	a0,0x1
ffffffffc02006ac:	61850513          	addi	a0,a0,1560 # ffffffffc0201cc0 <etext+0x2f2>
ffffffffc02006b0:	bc71                	j	ffffffffc020014c <cprintf>

ffffffffc02006b2 <buddy_init_memmap>:
static void buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc02006b2:	1141                	addi	sp,sp,-16
ffffffffc02006b4:	e406                	sd	ra,8(sp)
    assert(n > 0 && base != NULL);
ffffffffc02006b6:	12058063          	beqz	a1,ffffffffc02007d6 <buddy_init_memmap+0x124>
ffffffffc02006ba:	10050e63          	beqz	a0,ffffffffc02007d6 <buddy_init_memmap+0x124>
    for (; p != base + n; p++) {
ffffffffc02006be:	00259693          	slli	a3,a1,0x2
ffffffffc02006c2:	96ae                	add	a3,a3,a1
ffffffffc02006c4:	068e                	slli	a3,a3,0x3
ffffffffc02006c6:	96aa                	add	a3,a3,a0
ffffffffc02006c8:	87aa                	mv	a5,a0
ffffffffc02006ca:	00d50f63          	beq	a0,a3,ffffffffc02006e8 <buddy_init_memmap+0x36>
        assert(PageReserved(p));
ffffffffc02006ce:	6798                	ld	a4,8(a5)
ffffffffc02006d0:	8b05                	andi	a4,a4,1
ffffffffc02006d2:	c375                	beqz	a4,ffffffffc02007b6 <buddy_init_memmap+0x104>
        p->flags = 0;
ffffffffc02006d4:	0007b423          	sd	zero,8(a5)
        p->property = 0;
ffffffffc02006d8:	0007a823          	sw	zero,16(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02006dc:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++) {
ffffffffc02006e0:	02878793          	addi	a5,a5,40
ffffffffc02006e4:	fed795e3          	bne	a5,a3,ffffffffc02006ce <buddy_init_memmap+0x1c>
        int order = 0;
ffffffffc02006e8:	862e                	mv	a2,a1
ffffffffc02006ea:	00006e97          	auipc	t4,0x6
ffffffffc02006ee:	92ee8e93          	addi	t4,t4,-1746 # ffffffffc0206018 <buddy_free_areas>
        while ((current_size * 2) <= remaining && (order + 1) <= MAX_ORDER) {
ffffffffc02006f2:	4f05                	li	t5,1
ffffffffc02006f4:	4839                	li	a6,14
        curr_base += block_size;
ffffffffc02006f6:	00006f97          	auipc	t6,0x6
ffffffffc02006fa:	a72f8f93          	addi	t6,t6,-1422 # ffffffffc0206168 <buddy_free_areas+0x150>
        while ((current_size * 2) <= remaining && (order + 1) <= MAX_ORDER) {
ffffffffc02006fe:	4709                	li	a4,2
        int order = 0;
ffffffffc0200700:	4781                	li	a5,0
        while ((current_size * 2) <= remaining && (order + 1) <= MAX_ORDER) {
ffffffffc0200702:	0be60363          	beq	a2,t5,ffffffffc02007a8 <buddy_init_memmap+0xf6>
            order++;
ffffffffc0200706:	86ba                	mv	a3,a4
        while ((current_size * 2) <= remaining && (order + 1) <= MAX_ORDER) {
ffffffffc0200708:	0706                	slli	a4,a4,0x1
            order++;
ffffffffc020070a:	2785                	addiw	a5,a5,1
        while ((current_size * 2) <= remaining && (order + 1) <= MAX_ORDER) {
ffffffffc020070c:	08e66163          	bltu	a2,a4,ffffffffc020078e <buddy_init_memmap+0xdc>
ffffffffc0200710:	ff079be3          	bne	a5,a6,ffffffffc0200706 <buddy_init_memmap+0x54>
        curr_base += block_size;
ffffffffc0200714:	00269893          	slli	a7,a3,0x2
ffffffffc0200718:	98b6                	add	a7,a7,a3
ffffffffc020071a:	088e                	slli	a7,a7,0x3
ffffffffc020071c:	8e7e                	mv	t3,t6
ffffffffc020071e:	43b9                	li	t2,14
ffffffffc0200720:	00179713          	slli	a4,a5,0x1
        SetPageProperty(curr_base);
ffffffffc0200724:	00853303          	ld	t1,8(a0)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200728:	97ba                	add	a5,a5,a4
ffffffffc020072a:	078e                	slli	a5,a5,0x3
ffffffffc020072c:	97f6                	add	a5,a5,t4
ffffffffc020072e:	0007b283          	ld	t0,0(a5)
ffffffffc0200732:	00236713          	ori	a4,t1,2
ffffffffc0200736:	e518                	sd	a4,8(a0)
        curr_base->property = order;
ffffffffc0200738:	00752823          	sw	t2,16(a0)
        buddy_free_areas[order].nr_free++;
ffffffffc020073c:	4b98                	lw	a4,16(a5)
        list_add_before(&buddy_free_areas[order].free_list, &curr_base->page_link);
ffffffffc020073e:	01850313          	addi	t1,a0,24
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0200742:	0067b023          	sd	t1,0(a5)
ffffffffc0200746:	0062b423          	sd	t1,8(t0)
    elm->next = next;
ffffffffc020074a:	03c53023          	sd	t3,32(a0)
    elm->prev = prev;
ffffffffc020074e:	00553c23          	sd	t0,24(a0)
        buddy_free_areas[order].nr_free++;
ffffffffc0200752:	2705                	addiw	a4,a4,1
ffffffffc0200754:	cb98                	sw	a4,16(a5)
        remaining -= block_size;
ffffffffc0200756:	8e15                	sub	a2,a2,a3
        curr_base += block_size;
ffffffffc0200758:	9546                	add	a0,a0,a7
    while (remaining > 0) {
ffffffffc020075a:	f255                	bnez	a2,ffffffffc02006fe <buddy_init_memmap+0x4c>
    cprintf("buddy_pmm: init %d pages, total free: %d pages\n", 
ffffffffc020075c:	2581                	sext.w	a1,a1
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020075e:	00006697          	auipc	a3,0x6
ffffffffc0200762:	8ca68693          	addi	a3,a3,-1846 # ffffffffc0206028 <buddy_free_areas+0x10>
ffffffffc0200766:	4701                	li	a4,0
ffffffffc0200768:	453d                	li	a0,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc020076a:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020076c:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc020076e:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200772:	1782                	slli	a5,a5,0x20
ffffffffc0200774:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200776:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200778:	963e                	add	a2,a2,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020077a:	fea718e3          	bne	a4,a0,ffffffffc020076a <buddy_init_memmap+0xb8>
}
ffffffffc020077e:	60a2                	ld	ra,8(sp)
    cprintf("buddy_pmm: init %d pages, total free: %d pages\n", 
ffffffffc0200780:	2601                	sext.w	a2,a2
ffffffffc0200782:	00001517          	auipc	a0,0x1
ffffffffc0200786:	5de50513          	addi	a0,a0,1502 # ffffffffc0201d60 <etext+0x392>
}
ffffffffc020078a:	0141                	addi	sp,sp,16
    cprintf("buddy_pmm: init %d pages, total free: %d pages\n", 
ffffffffc020078c:	b2c1                	j	ffffffffc020014c <cprintf>
        list_add_before(&buddy_free_areas[order].free_list, &curr_base->page_link);
ffffffffc020078e:	00179713          	slli	a4,a5,0x1
ffffffffc0200792:	00f70e33          	add	t3,a4,a5
        curr_base += block_size;
ffffffffc0200796:	00269893          	slli	a7,a3,0x2
        list_add_before(&buddy_free_areas[order].free_list, &curr_base->page_link);
ffffffffc020079a:	0e0e                	slli	t3,t3,0x3
        curr_base += block_size;
ffffffffc020079c:	98b6                	add	a7,a7,a3
        curr_base->property = order;
ffffffffc020079e:	0007839b          	sext.w	t2,a5
        list_add_before(&buddy_free_areas[order].free_list, &curr_base->page_link);
ffffffffc02007a2:	9e76                	add	t3,t3,t4
        curr_base += block_size;
ffffffffc02007a4:	088e                	slli	a7,a7,0x3
ffffffffc02007a6:	bfbd                	j	ffffffffc0200724 <buddy_init_memmap+0x72>
        size_t current_size = 1;
ffffffffc02007a8:	4685                	li	a3,1
        while ((current_size * 2) <= remaining && (order + 1) <= MAX_ORDER) {
ffffffffc02007aa:	02800893          	li	a7,40
ffffffffc02007ae:	8e76                	mv	t3,t4
ffffffffc02007b0:	4381                	li	t2,0
ffffffffc02007b2:	4701                	li	a4,0
ffffffffc02007b4:	bf85                	j	ffffffffc0200724 <buddy_init_memmap+0x72>
        assert(PageReserved(p));
ffffffffc02007b6:	00001697          	auipc	a3,0x1
ffffffffc02007ba:	59a68693          	addi	a3,a3,1434 # ffffffffc0201d50 <etext+0x382>
ffffffffc02007be:	00001617          	auipc	a2,0x1
ffffffffc02007c2:	56260613          	addi	a2,a2,1378 # ffffffffc0201d20 <etext+0x352>
ffffffffc02007c6:	04900593          	li	a1,73
ffffffffc02007ca:	00001517          	auipc	a0,0x1
ffffffffc02007ce:	56e50513          	addi	a0,a0,1390 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02007d2:	9f1ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(n > 0 && base != NULL);
ffffffffc02007d6:	00001697          	auipc	a3,0x1
ffffffffc02007da:	53268693          	addi	a3,a3,1330 # ffffffffc0201d08 <etext+0x33a>
ffffffffc02007de:	00001617          	auipc	a2,0x1
ffffffffc02007e2:	54260613          	addi	a2,a2,1346 # ffffffffc0201d20 <etext+0x352>
ffffffffc02007e6:	04400593          	li	a1,68
ffffffffc02007ea:	00001517          	auipc	a0,0x1
ffffffffc02007ee:	54e50513          	addi	a0,a0,1358 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02007f2:	9d1ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc02007f6 <buddy_alloc_pages>:
static struct Page *buddy_alloc_pages(size_t n) {
ffffffffc02007f6:	1141                	addi	sp,sp,-16
ffffffffc02007f8:	e406                	sd	ra,8(sp)
ffffffffc02007fa:	e022                	sd	s0,0(sp)
    assert(n > 0);
ffffffffc02007fc:	14050963          	beqz	a0,ffffffffc020094e <buddy_alloc_pages+0x158>
ffffffffc0200800:	4785                	li	a5,1
ffffffffc0200802:	4681                	li	a3,0
ffffffffc0200804:	473d                	li	a4,15
    while (size < n) {
ffffffffc0200806:	02a7f063          	bgeu	a5,a0,ffffffffc0200826 <buddy_alloc_pages+0x30>
        order++;
ffffffffc020080a:	2685                	addiw	a3,a3,1
        size <<= 1;
ffffffffc020080c:	0786                	slli	a5,a5,0x1
        if (order > MAX_ORDER) {
ffffffffc020080e:	fee69ce3          	bne	a3,a4,ffffffffc0200806 <buddy_alloc_pages+0x10>
        cprintf("buddy_pmm: alloc failed (request %d pages > max block size)\n", (int)n);
ffffffffc0200812:	0005059b          	sext.w	a1,a0
ffffffffc0200816:	00001517          	auipc	a0,0x1
ffffffffc020081a:	5f250513          	addi	a0,a0,1522 # ffffffffc0201e08 <etext+0x43a>
ffffffffc020081e:	92fff0ef          	jal	ra,ffffffffc020014c <cprintf>
        return NULL;
ffffffffc0200822:	4401                	li	s0,0
ffffffffc0200824:	a205                	j	ffffffffc0200944 <buddy_alloc_pages+0x14e>
ffffffffc0200826:	00169593          	slli	a1,a3,0x1
ffffffffc020082a:	00d58733          	add	a4,a1,a3
ffffffffc020082e:	00005e17          	auipc	t3,0x5
ffffffffc0200832:	7eae0e13          	addi	t3,t3,2026 # ffffffffc0206018 <buddy_free_areas>
ffffffffc0200836:	070e                	slli	a4,a4,0x3
ffffffffc0200838:	9772                	add	a4,a4,t3
    while (size < n) {
ffffffffc020083a:	87b6                	mv	a5,a3
    for (; order <= MAX_ORDER; order++) {
ffffffffc020083c:	463d                	li	a2,15
        if (buddy_free_areas[order].nr_free > 0) {
ffffffffc020083e:	01072803          	lw	a6,16(a4)
ffffffffc0200842:	02081063          	bnez	a6,ffffffffc0200862 <buddy_alloc_pages+0x6c>
    for (; order <= MAX_ORDER; order++) {
ffffffffc0200846:	2785                	addiw	a5,a5,1
ffffffffc0200848:	0761                	addi	a4,a4,24
ffffffffc020084a:	fec79ae3          	bne	a5,a2,ffffffffc020083e <buddy_alloc_pages+0x48>
        cprintf("buddy_pmm: alloc failed (no free block for %d pages)\n", (int)n);
ffffffffc020084e:	0005059b          	sext.w	a1,a0
ffffffffc0200852:	00001517          	auipc	a0,0x1
ffffffffc0200856:	57e50513          	addi	a0,a0,1406 # ffffffffc0201dd0 <etext+0x402>
ffffffffc020085a:	8f3ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        return NULL;
ffffffffc020085e:	4401                	li	s0,0
ffffffffc0200860:	a0d5                	j	ffffffffc0200944 <buddy_alloc_pages+0x14e>
    while (order > target_order) {
ffffffffc0200862:	08f6de63          	bge	a3,a5,ffffffffc02008fe <buddy_alloc_pages+0x108>
ffffffffc0200866:	00179713          	slli	a4,a5,0x1
ffffffffc020086a:	973e                	add	a4,a4,a5
ffffffffc020086c:	070e                	slli	a4,a4,0x3
ffffffffc020086e:	1721                	addi	a4,a4,-24
ffffffffc0200870:	9772                	add	a4,a4,t3
        size_t block_size = BLOCK_SIZE(order);
ffffffffc0200872:	4f85                	li	t6,1
    return listelm->next;
ffffffffc0200874:	02073883          	ld	a7,32(a4)
        order--;
ffffffffc0200878:	fff7861b          	addiw	a2,a5,-1
        size_t block_size = BLOCK_SIZE(order);
ffffffffc020087c:	00cf9f3b          	sllw	t5,t6,a2
    __list_del(listelm->prev, listelm->next);
ffffffffc0200880:	0088b303          	ld	t1,8(a7)
ffffffffc0200884:	0008be83          	ld	t4,0(a7)
        struct Page *right_block = parent_block + block_size;
ffffffffc0200888:	002f1793          	slli	a5,t5,0x2
ffffffffc020088c:	97fa                	add	a5,a5,t5
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020088e:	006eb423          	sd	t1,8(t4)
    next->prev = prev;
ffffffffc0200892:	01d33023          	sd	t4,0(t1)
        buddy_free_areas[order + 1].nr_free--;
ffffffffc0200896:	387d                	addiw	a6,a6,-1
        SetPageProperty(parent_block);
ffffffffc0200898:	ff08b303          	ld	t1,-16(a7)
        struct Page *right_block = parent_block + block_size;
ffffffffc020089c:	078e                	slli	a5,a5,0x3
        buddy_free_areas[order + 1].nr_free--;
ffffffffc020089e:	03072423          	sw	a6,40(a4)
        struct Page *right_block = parent_block + block_size;
ffffffffc02008a2:	17a1                	addi	a5,a5,-24
        parent_block->property = order;
ffffffffc02008a4:	fec8ac23          	sw	a2,-8(a7)
        struct Page *right_block = parent_block + block_size;
ffffffffc02008a8:	97c6                	add	a5,a5,a7
        right_block->property = order;
ffffffffc02008aa:	cb90                	sw	a2,16(a5)
        SetPageProperty(parent_block);
ffffffffc02008ac:	00236813          	ori	a6,t1,2
ffffffffc02008b0:	ff08b823          	sd	a6,-16(a7)
        SetPageProperty(right_block);
ffffffffc02008b4:	0087b303          	ld	t1,8(a5)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02008b8:	00073e83          	ld	t4,0(a4)
        buddy_free_areas[order].nr_free += 2;
ffffffffc02008bc:	01072803          	lw	a6,16(a4)
        SetPageProperty(right_block);
ffffffffc02008c0:	00236313          	ori	t1,t1,2
ffffffffc02008c4:	0067b423          	sd	t1,8(a5)
    prev->next = next->prev = elm;
ffffffffc02008c8:	01173023          	sd	a7,0(a4)
ffffffffc02008cc:	011eb423          	sd	a7,8(t4)
    elm->next = next;
ffffffffc02008d0:	00e8b423          	sd	a4,8(a7)
    elm->prev = prev;
ffffffffc02008d4:	01d8b023          	sd	t4,0(a7)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02008d8:	00073883          	ld	a7,0(a4)
        list_add_before(&buddy_free_areas[order].free_list, &right_block->page_link);
ffffffffc02008dc:	01878313          	addi	t1,a5,24
    prev->next = next->prev = elm;
ffffffffc02008e0:	00673023          	sd	t1,0(a4)
ffffffffc02008e4:	0068b423          	sd	t1,8(a7)
    elm->next = next;
ffffffffc02008e8:	f398                	sd	a4,32(a5)
    elm->prev = prev;
ffffffffc02008ea:	0117bc23          	sd	a7,24(a5)
        buddy_free_areas[order].nr_free += 2;
ffffffffc02008ee:	2809                	addiw	a6,a6,2
ffffffffc02008f0:	01072823          	sw	a6,16(a4)
        order--;
ffffffffc02008f4:	0006079b          	sext.w	a5,a2
    while (order > target_order) {
ffffffffc02008f8:	1721                	addi	a4,a4,-24
ffffffffc02008fa:	f6d79de3          	bne	a5,a3,ffffffffc0200874 <buddy_alloc_pages+0x7e>
    return listelm->next;
ffffffffc02008fe:	95b6                	add	a1,a1,a3
ffffffffc0200900:	058e                	slli	a1,a1,0x3
ffffffffc0200902:	9e2e                	add	t3,t3,a1
ffffffffc0200904:	008e3783          	ld	a5,8(t3)
    buddy_free_areas[target_order].nr_free--;
ffffffffc0200908:	010e2603          	lw	a2,16(t3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020090c:	678c                	ld	a1,8(a5)
ffffffffc020090e:	0007b803          	ld	a6,0(a5)
    ClearPageProperty(alloc_block);
ffffffffc0200912:	ff07b703          	ld	a4,-16(a5)
    buddy_free_areas[target_order].nr_free--;
ffffffffc0200916:	367d                	addiw	a2,a2,-1
    prev->next = next;
ffffffffc0200918:	00b83423          	sd	a1,8(a6)
    next->prev = prev;
ffffffffc020091c:	0105b023          	sd	a6,0(a1)
ffffffffc0200920:	00ce2823          	sw	a2,16(t3)
    ClearPageProperty(alloc_block);
ffffffffc0200924:	9b75                	andi	a4,a4,-3
    cprintf("buddy_pmm: alloc %d pages (actual %d pages, order=%d)\n", 
ffffffffc0200926:	4605                	li	a2,1
ffffffffc0200928:	0005059b          	sext.w	a1,a0
    ClearPageProperty(alloc_block);
ffffffffc020092c:	fee7b823          	sd	a4,-16(a5)
    cprintf("buddy_pmm: alloc %d pages (actual %d pages, order=%d)\n", 
ffffffffc0200930:	00d6163b          	sllw	a2,a2,a3
ffffffffc0200934:	00001517          	auipc	a0,0x1
ffffffffc0200938:	46450513          	addi	a0,a0,1124 # ffffffffc0201d98 <etext+0x3ca>
    struct Page *alloc_block = le2page(le, page_link);
ffffffffc020093c:	fe878413          	addi	s0,a5,-24
    cprintf("buddy_pmm: alloc %d pages (actual %d pages, order=%d)\n", 
ffffffffc0200940:	80dff0ef          	jal	ra,ffffffffc020014c <cprintf>
}
ffffffffc0200944:	60a2                	ld	ra,8(sp)
ffffffffc0200946:	8522                	mv	a0,s0
ffffffffc0200948:	6402                	ld	s0,0(sp)
ffffffffc020094a:	0141                	addi	sp,sp,16
ffffffffc020094c:	8082                	ret
    assert(n > 0);
ffffffffc020094e:	00001697          	auipc	a3,0x1
ffffffffc0200952:	44268693          	addi	a3,a3,1090 # ffffffffc0201d90 <etext+0x3c2>
ffffffffc0200956:	00001617          	auipc	a2,0x1
ffffffffc020095a:	3ca60613          	addi	a2,a2,970 # ffffffffc0201d20 <etext+0x352>
ffffffffc020095e:	07100593          	li	a1,113
ffffffffc0200962:	00001517          	auipc	a0,0x1
ffffffffc0200966:	3d650513          	addi	a0,a0,982 # ffffffffc0201d38 <etext+0x36a>
ffffffffc020096a:	859ff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc020096e <buddy_free_pages>:
static void buddy_free_pages(struct Page *base, size_t n) {
ffffffffc020096e:	1141                	addi	sp,sp,-16
ffffffffc0200970:	e406                	sd	ra,8(sp)
ffffffffc0200972:	e022                	sd	s0,0(sp)
    assert(n > 0 && base != NULL);
ffffffffc0200974:	1e058363          	beqz	a1,ffffffffc0200b5a <buddy_free_pages+0x1ec>
ffffffffc0200978:	1e050163          	beqz	a0,ffffffffc0200b5a <buddy_free_pages+0x1ec>
    for (; p != base + n; p++) {
ffffffffc020097c:	00259693          	slli	a3,a1,0x2
ffffffffc0200980:	96ae                	add	a3,a3,a1
ffffffffc0200982:	068e                	slli	a3,a3,0x3
ffffffffc0200984:	96aa                	add	a3,a3,a0
ffffffffc0200986:	87aa                	mv	a5,a0
ffffffffc0200988:	00d50e63          	beq	a0,a3,ffffffffc02009a4 <buddy_free_pages+0x36>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020098c:	6798                	ld	a4,8(a5)
ffffffffc020098e:	8b0d                	andi	a4,a4,3
ffffffffc0200990:	18071563          	bnez	a4,ffffffffc0200b1a <buddy_free_pages+0x1ac>
        p->flags = 0;
ffffffffc0200994:	0007b423          	sd	zero,8(a5)
ffffffffc0200998:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++) {
ffffffffc020099c:	02878793          	addi	a5,a5,40
ffffffffc02009a0:	fed796e3          	bne	a5,a3,ffffffffc020098c <buddy_free_pages+0x1e>
    size_t size = 1;
ffffffffc02009a4:	4785                	li	a5,1
    int order = 0;
ffffffffc02009a6:	4601                	li	a2,0
        if (order > MAX_ORDER) {
ffffffffc02009a8:	473d                	li	a4,15
    while (size < n) {
ffffffffc02009aa:	02b7f663          	bgeu	a5,a1,ffffffffc02009d6 <buddy_free_pages+0x68>
        order++;
ffffffffc02009ae:	2605                	addiw	a2,a2,1
        size <<= 1;
ffffffffc02009b0:	0786                	slli	a5,a5,0x1
        if (order > MAX_ORDER) {
ffffffffc02009b2:	fee61ce3          	bne	a2,a4,ffffffffc02009aa <buddy_free_pages+0x3c>
    assert(order >= 0 && order <= MAX_ORDER);
ffffffffc02009b6:	00001697          	auipc	a3,0x1
ffffffffc02009ba:	4ba68693          	addi	a3,a3,1210 # ffffffffc0201e70 <etext+0x4a2>
ffffffffc02009be:	00001617          	auipc	a2,0x1
ffffffffc02009c2:	36260613          	addi	a2,a2,866 # ffffffffc0201d20 <etext+0x352>
ffffffffc02009c6:	0b900593          	li	a1,185
ffffffffc02009ca:	00001517          	auipc	a0,0x1
ffffffffc02009ce:	36e50513          	addi	a0,a0,878 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02009d2:	ff0ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(BLOCK_SIZE(order) == n);
ffffffffc02009d6:	4785                	li	a5,1
ffffffffc02009d8:	00c797bb          	sllw	a5,a5,a2
    assert(order >= 0 && order <= MAX_ORDER);
ffffffffc02009dc:	0006089b          	sext.w	a7,a2
    assert(BLOCK_SIZE(order) == n);
ffffffffc02009e0:	14f59d63          	bne	a1,a5,ffffffffc0200b3a <buddy_free_pages+0x1cc>
    list_add_before(&buddy_free_areas[order].free_list, &base->page_link);
ffffffffc02009e4:	00161793          	slli	a5,a2,0x1
    SetPageProperty(base);
ffffffffc02009e8:	6514                	ld	a3,8(a0)
    list_add_before(&buddy_free_areas[order].free_list, &base->page_link);
ffffffffc02009ea:	97b2                	add	a5,a5,a2
ffffffffc02009ec:	078e                	slli	a5,a5,0x3
ffffffffc02009ee:	00005717          	auipc	a4,0x5
ffffffffc02009f2:	62a70713          	addi	a4,a4,1578 # ffffffffc0206018 <buddy_free_areas>
ffffffffc02009f6:	973e                	add	a4,a4,a5
    __list_add(elm, listelm->prev, listelm);
ffffffffc02009f8:	00073803          	ld	a6,0(a4)
    SetPageProperty(base);
ffffffffc02009fc:	0026e793          	ori	a5,a3,2
ffffffffc0200a00:	e51c                	sd	a5,8(a0)
    base->property = order;
ffffffffc0200a02:	01152823          	sw	a7,16(a0)
    buddy_free_areas[order].nr_free++;
ffffffffc0200a06:	4b1c                	lw	a5,16(a4)
    list_add_before(&buddy_free_areas[order].free_list, &base->page_link);
ffffffffc0200a08:	01850e13          	addi	t3,a0,24
    prev->next = next->prev = elm;
ffffffffc0200a0c:	01c73023          	sd	t3,0(a4)
ffffffffc0200a10:	01c83423          	sd	t3,8(a6)
    buddy_free_areas[order].nr_free++;
ffffffffc0200a14:	2785                	addiw	a5,a5,1
    elm->next = next;
ffffffffc0200a16:	f118                	sd	a4,32(a0)
    elm->prev = prev;
ffffffffc0200a18:	01053c23          	sd	a6,24(a0)
ffffffffc0200a1c:	cb1c                	sw	a5,16(a4)
    while (order < MAX_ORDER) {
ffffffffc0200a1e:	47b9                	li	a5,14
ffffffffc0200a20:	0ef60b63          	beq	a2,a5,ffffffffc0200b16 <buddy_free_pages+0x1a8>
    size_t page_idx = PAGE_IDX(page);
ffffffffc0200a24:	00005e97          	auipc	t4,0x5
ffffffffc0200a28:	77cebe83          	ld	t4,1916(t4) # ffffffffc02061a0 <pages>
    return (buddy_idx < npage) ? (pages + buddy_idx) : NULL;
ffffffffc0200a2c:	00005397          	auipc	t2,0x5
ffffffffc0200a30:	76c3b383          	ld	t2,1900(t2) # ffffffffc0206198 <npage>
ffffffffc0200a34:	86b2                	mv	a3,a2
ffffffffc0200a36:	00002297          	auipc	t0,0x2
ffffffffc0200a3a:	f922b283          	ld	t0,-110(t0) # ffffffffc02029c8 <error_string+0x38>
    size_t block_size = BLOCK_SIZE(order);
ffffffffc0200a3e:	4f85                	li	t6,1
    while (order < MAX_ORDER) {
ffffffffc0200a40:	4f39                	li	t5,14
    size_t page_idx = PAGE_IDX(page);
ffffffffc0200a42:	41d50833          	sub	a6,a0,t4
ffffffffc0200a46:	40385813          	srai	a6,a6,0x3
ffffffffc0200a4a:	02580833          	mul	a6,a6,t0
    size_t block_size = BLOCK_SIZE(order);
ffffffffc0200a4e:	00df97bb          	sllw	a5,t6,a3
    size_t buddy_idx = page_idx ^ block_size;
ffffffffc0200a52:	00f847b3          	xor	a5,a6,a5
    return (buddy_idx < npage) ? (pages + buddy_idx) : NULL;
ffffffffc0200a56:	0277fe63          	bgeu	a5,t2,ffffffffc0200a92 <buddy_free_pages+0x124>
ffffffffc0200a5a:	00279813          	slli	a6,a5,0x2
ffffffffc0200a5e:	983e                	add	a6,a6,a5
ffffffffc0200a60:	080e                	slli	a6,a6,0x3
ffffffffc0200a62:	9876                	add	a6,a6,t4
        if (buddy == NULL || !PageProperty(buddy) || buddy->property != order) {
ffffffffc0200a64:	02080763          	beqz	a6,ffffffffc0200a92 <buddy_free_pages+0x124>
ffffffffc0200a68:	00883783          	ld	a5,8(a6)
ffffffffc0200a6c:	8b89                	andi	a5,a5,2
ffffffffc0200a6e:	c395                	beqz	a5,ffffffffc0200a92 <buddy_free_pages+0x124>
ffffffffc0200a70:	01082883          	lw	a7,16(a6)
ffffffffc0200a74:	0006879b          	sext.w	a5,a3
ffffffffc0200a78:	00f89d63          	bne	a7,a5,ffffffffc0200a92 <buddy_free_pages+0x124>
    list_entry_t *curr = head->next;
ffffffffc0200a7c:	671c                	ld	a5,8(a4)
        if (!is_node_in_list(&buddy_free_areas[order].free_list, &buddy->page_link)) {
ffffffffc0200a7e:	01880893          	addi	a7,a6,24
    while (curr != head) {
ffffffffc0200a82:	833a                	mv	t1,a4
ffffffffc0200a84:	00e78763          	beq	a5,a4,ffffffffc0200a92 <buddy_free_pages+0x124>
        if (curr == node) {
ffffffffc0200a88:	00f88f63          	beq	a7,a5,ffffffffc0200aa6 <buddy_free_pages+0x138>
        curr = curr->next;
ffffffffc0200a8c:	679c                	ld	a5,8(a5)
    while (curr != head) {
ffffffffc0200a8e:	fee79de3          	bne	a5,a4,ffffffffc0200a88 <buddy_free_pages+0x11a>
}
ffffffffc0200a92:	6402                	ld	s0,0(sp)
ffffffffc0200a94:	60a2                	ld	ra,8(sp)
    cprintf("buddy_pmm: free %d pages (start order=%d, final order=%d)\n", 
ffffffffc0200a96:	2581                	sext.w	a1,a1
ffffffffc0200a98:	00001517          	auipc	a0,0x1
ffffffffc0200a9c:	41850513          	addi	a0,a0,1048 # ffffffffc0201eb0 <etext+0x4e2>
}
ffffffffc0200aa0:	0141                	addi	sp,sp,16
    cprintf("buddy_pmm: free %d pages (start order=%d, final order=%d)\n", 
ffffffffc0200aa2:	eaaff06f          	j	ffffffffc020014c <cprintf>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200aa6:	6d00                	ld	s0,24(a0)
ffffffffc0200aa8:	02053883          	ld	a7,32(a0)
        buddy_free_areas[order].nr_free -= 2;
ffffffffc0200aac:	4b1c                	lw	a5,16(a4)
    prev->next = next;
ffffffffc0200aae:	01143423          	sd	a7,8(s0)
    next->prev = prev;
ffffffffc0200ab2:	0088b023          	sd	s0,0(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200ab6:	01883403          	ld	s0,24(a6)
ffffffffc0200aba:	02083883          	ld	a7,32(a6)
ffffffffc0200abe:	37f9                	addiw	a5,a5,-2
    prev->next = next;
ffffffffc0200ac0:	01143423          	sd	a7,8(s0)
    next->prev = prev;
ffffffffc0200ac4:	0088b023          	sd	s0,0(a7)
ffffffffc0200ac8:	cb1c                	sw	a5,16(a4)
        struct Page *merged_base = (base < buddy) ? base : buddy;
ffffffffc0200aca:	00a87563          	bgeu	a6,a0,ffffffffc0200ad4 <buddy_free_pages+0x166>
ffffffffc0200ace:	8542                	mv	a0,a6
ffffffffc0200ad0:	01880e13          	addi	t3,a6,24
        SetPageProperty(merged_base);
ffffffffc0200ad4:	651c                	ld	a5,8(a0)
        merged_base->property = order + 1;
ffffffffc0200ad6:	2685                	addiw	a3,a3,1
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200ad8:	01833803          	ld	a6,24(t1)
        SetPageProperty(merged_base);
ffffffffc0200adc:	0027e793          	ori	a5,a5,2
        merged_base->property = order + 1;
ffffffffc0200ae0:	c914                	sw	a3,16(a0)
        SetPageProperty(merged_base);
ffffffffc0200ae2:	e51c                	sd	a5,8(a0)
        buddy_free_areas[order + 1].nr_free++;
ffffffffc0200ae4:	02832783          	lw	a5,40(t1)
    prev->next = next->prev = elm;
ffffffffc0200ae8:	01c33c23          	sd	t3,24(t1)
ffffffffc0200aec:	01c83423          	sd	t3,8(a6)
ffffffffc0200af0:	0761                	addi	a4,a4,24
    elm->next = next;
ffffffffc0200af2:	f118                	sd	a4,32(a0)
    elm->prev = prev;
ffffffffc0200af4:	01053c23          	sd	a6,24(a0)
ffffffffc0200af8:	2785                	addiw	a5,a5,1
ffffffffc0200afa:	02f32423          	sw	a5,40(t1)
    while (order < MAX_ORDER) {
ffffffffc0200afe:	f5e692e3          	bne	a3,t5,ffffffffc0200a42 <buddy_free_pages+0xd4>
}
ffffffffc0200b02:	6402                	ld	s0,0(sp)
ffffffffc0200b04:	60a2                	ld	ra,8(sp)
    cprintf("buddy_pmm: free %d pages (start order=%d, final order=%d)\n", 
ffffffffc0200b06:	2581                	sext.w	a1,a1
ffffffffc0200b08:	00001517          	auipc	a0,0x1
ffffffffc0200b0c:	3a850513          	addi	a0,a0,936 # ffffffffc0201eb0 <etext+0x4e2>
}
ffffffffc0200b10:	0141                	addi	sp,sp,16
    cprintf("buddy_pmm: free %d pages (start order=%d, final order=%d)\n", 
ffffffffc0200b12:	e3aff06f          	j	ffffffffc020014c <cprintf>
    while (order < MAX_ORDER) {
ffffffffc0200b16:	46b9                	li	a3,14
ffffffffc0200b18:	bfad                	j	ffffffffc0200a92 <buddy_free_pages+0x124>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200b1a:	00001697          	auipc	a3,0x1
ffffffffc0200b1e:	32e68693          	addi	a3,a3,814 # ffffffffc0201e48 <etext+0x47a>
ffffffffc0200b22:	00001617          	auipc	a2,0x1
ffffffffc0200b26:	1fe60613          	addi	a2,a2,510 # ffffffffc0201d20 <etext+0x352>
ffffffffc0200b2a:	0b200593          	li	a1,178
ffffffffc0200b2e:	00001517          	auipc	a0,0x1
ffffffffc0200b32:	20a50513          	addi	a0,a0,522 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0200b36:	e8cff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(BLOCK_SIZE(order) == n);
ffffffffc0200b3a:	00001697          	auipc	a3,0x1
ffffffffc0200b3e:	35e68693          	addi	a3,a3,862 # ffffffffc0201e98 <etext+0x4ca>
ffffffffc0200b42:	00001617          	auipc	a2,0x1
ffffffffc0200b46:	1de60613          	addi	a2,a2,478 # ffffffffc0201d20 <etext+0x352>
ffffffffc0200b4a:	0ba00593          	li	a1,186
ffffffffc0200b4e:	00001517          	auipc	a0,0x1
ffffffffc0200b52:	1ea50513          	addi	a0,a0,490 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0200b56:	e6cff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(n > 0 && base != NULL);
ffffffffc0200b5a:	00001697          	auipc	a3,0x1
ffffffffc0200b5e:	1ae68693          	addi	a3,a3,430 # ffffffffc0201d08 <etext+0x33a>
ffffffffc0200b62:	00001617          	auipc	a2,0x1
ffffffffc0200b66:	1be60613          	addi	a2,a2,446 # ffffffffc0201d20 <etext+0x352>
ffffffffc0200b6a:	0ad00593          	li	a1,173
ffffffffc0200b6e:	00001517          	auipc	a0,0x1
ffffffffc0200b72:	1ca50513          	addi	a0,a0,458 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0200b76:	e4cff0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc0200b7a <buddy_check>:

// 10. 测试函数：验证伙伴系统的分配、拆分、合并逻辑
static void buddy_check(void) {
ffffffffc0200b7a:	7175                	addi	sp,sp,-144
    int score = 0, sum_score = 8;
    cprintf("\n=== Buddy System Enhanced Test Start ===\n");
ffffffffc0200b7c:	00001517          	auipc	a0,0x1
ffffffffc0200b80:	37450513          	addi	a0,a0,884 # ffffffffc0201ef0 <etext+0x522>
static void buddy_check(void) {
ffffffffc0200b84:	e122                	sd	s0,128(sp)
ffffffffc0200b86:	fca6                	sd	s1,120(sp)
ffffffffc0200b88:	e506                	sd	ra,136(sp)
ffffffffc0200b8a:	f8ca                	sd	s2,112(sp)
ffffffffc0200b8c:	f4ce                	sd	s3,104(sp)
ffffffffc0200b8e:	f0d2                	sd	s4,96(sp)
ffffffffc0200b90:	ecd6                	sd	s5,88(sp)
ffffffffc0200b92:	e8da                	sd	s6,80(sp)
ffffffffc0200b94:	e4de                	sd	s7,72(sp)
ffffffffc0200b96:	e0e2                	sd	s8,64(sp)
ffffffffc0200b98:	fc66                	sd	s9,56(sp)
ffffffffc0200b9a:	f86a                	sd	s10,48(sp)
ffffffffc0200b9c:	f46e                	sd	s11,40(sp)
ffffffffc0200b9e:	00005417          	auipc	s0,0x5
ffffffffc0200ba2:	48a40413          	addi	s0,s0,1162 # ffffffffc0206028 <buddy_free_areas+0x10>
    cprintf("\n=== Buddy System Enhanced Test Start ===\n");
ffffffffc0200ba6:	da6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    size_t total = 0;
ffffffffc0200baa:	4481                	li	s1,0
    cprintf("\n=== Buddy System Enhanced Test Start ===\n");
ffffffffc0200bac:	86a2                	mv	a3,s0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200bae:	4701                	li	a4,0
ffffffffc0200bb0:	463d                	li	a2,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200bb2:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200bb4:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200bb6:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200bba:	1782                	slli	a5,a5,0x20
ffffffffc0200bbc:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200bbe:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200bc0:	94be                	add	s1,s1,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200bc2:	fec718e3          	bne	a4,a2,ffffffffc0200bb2 <buddy_check+0x38>
ffffffffc0200bc6:	00005797          	auipc	a5,0x5
ffffffffc0200bca:	5b278793          	addi	a5,a5,1458 # ffffffffc0206178 <buddy_free_areas+0x160>
    size_t initial_free = buddy_nr_free_pages();
    
    // 检测最大可用块
    size_t max_possible_block = 0;
    int max_order_found = -1;
    for (int o = MAX_ORDER; o >= 0; o--) {
ffffffffc0200bce:	46b9                	li	a3,14
ffffffffc0200bd0:	567d                	li	a2,-1
        if (buddy_free_areas[o].nr_free > 0) {
ffffffffc0200bd2:	4398                	lw	a4,0(a5)
ffffffffc0200bd4:	4e071763          	bnez	a4,ffffffffc02010c2 <buddy_check+0x548>
    for (int o = MAX_ORDER; o >= 0; o--) {
ffffffffc0200bd8:	36fd                	addiw	a3,a3,-1
ffffffffc0200bda:	17a1                	addi	a5,a5,-24
ffffffffc0200bdc:	fec69be3          	bne	a3,a2,ffffffffc0200bd2 <buddy_check+0x58>
ffffffffc0200be0:	4a01                	li	s4,0
    size_t max_possible_block = 0;
ffffffffc0200be2:	4981                	li	s3,0
            max_possible_block = BLOCK_SIZE(o);
            max_order_found = o;
            break;
        }
    }
    cprintf("buddy_check: initial free: %d pages, max available block: %d pages (order=%d)\n", 
ffffffffc0200be4:	00048a9b          	sext.w	s5,s1
ffffffffc0200be8:	8652                	mv	a2,s4
ffffffffc0200bea:	85d6                	mv	a1,s5
ffffffffc0200bec:	00001517          	auipc	a0,0x1
ffffffffc0200bf0:	33450513          	addi	a0,a0,820 # ffffffffc0201f20 <etext+0x552>
ffffffffc0200bf4:	d58ff0ef          	jal	ra,ffffffffc020014c <cprintf>
            (int)initial_free, (int)max_possible_block, max_order_found);

    // 测试1：基础1页分配
    struct Page *p0 = alloc_page();
ffffffffc0200bf8:	4505                	li	a0,1
ffffffffc0200bfa:	750000ef          	jal	ra,ffffffffc020134a <alloc_pages>
ffffffffc0200bfe:	8b2a                	mv	s6,a0
    assert(p0 != NULL && !PageProperty(p0));
ffffffffc0200c00:	68050563          	beqz	a0,ffffffffc020128a <buddy_check+0x710>
ffffffffc0200c04:	00853903          	ld	s2,8(a0)
ffffffffc0200c08:	00297913          	andi	s2,s2,2
ffffffffc0200c0c:	66091f63          	bnez	s2,ffffffffc020128a <buddy_check+0x710>
ffffffffc0200c10:	00005697          	auipc	a3,0x5
ffffffffc0200c14:	41868693          	addi	a3,a3,1048 # ffffffffc0206028 <buddy_free_areas+0x10>
    size_t total = 0;
ffffffffc0200c18:	4581                	li	a1,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200c1a:	4701                	li	a4,0
ffffffffc0200c1c:	463d                	li	a2,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200c1e:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200c20:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200c22:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200c26:	1782                	slli	a5,a5,0x20
ffffffffc0200c28:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200c2a:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200c2c:	95be                	add	a1,a1,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200c2e:	fec718e3          	bne	a4,a2,ffffffffc0200c1e <buddy_check+0xa4>
    size_t after_alloc1 = buddy_nr_free_pages();
    assert(after_alloc1 == initial_free - 1);
ffffffffc0200c32:	fff48793          	addi	a5,s1,-1
ffffffffc0200c36:	5eb79a63          	bne	a5,a1,ffffffffc020122a <buddy_check+0x6b0>
    score++;
    cprintf("Test 1 Passed (alloc 1 page, free=%d) | Score: %d/%d\n", 
ffffffffc0200c3a:	46a1                	li	a3,8
ffffffffc0200c3c:	4605                	li	a2,1
ffffffffc0200c3e:	2581                	sext.w	a1,a1
ffffffffc0200c40:	00001517          	auipc	a0,0x1
ffffffffc0200c44:	37850513          	addi	a0,a0,888 # ffffffffc0201fb8 <etext+0x5ea>
ffffffffc0200c48:	d04ff0ef          	jal	ra,ffffffffc020014c <cprintf>
            (int)after_alloc1, score, sum_score);

    // 测试2：非2的幂分配
    struct Page *p1 = alloc_pages(3);
ffffffffc0200c4c:	450d                	li	a0,3
ffffffffc0200c4e:	6fc000ef          	jal	ra,ffffffffc020134a <alloc_pages>
ffffffffc0200c52:	8baa                	mv	s7,a0
    assert(p1 != NULL);
ffffffffc0200c54:	5a050b63          	beqz	a0,ffffffffc020120a <buddy_check+0x690>
ffffffffc0200c58:	00005697          	auipc	a3,0x5
ffffffffc0200c5c:	3d068693          	addi	a3,a3,976 # ffffffffc0206028 <buddy_free_areas+0x10>
    size_t total = 0;
ffffffffc0200c60:	4601                	li	a2,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200c62:	4701                	li	a4,0
ffffffffc0200c64:	45bd                	li	a1,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200c66:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200c68:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200c6a:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200c6e:	1782                	slli	a5,a5,0x20
ffffffffc0200c70:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200c72:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200c74:	963e                	add	a2,a2,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200c76:	feb718e3          	bne	a4,a1,ffffffffc0200c66 <buddy_check+0xec>
    size_t after_alloc2 = buddy_nr_free_pages();
    assert(after_alloc2 == initial_free - 1 - 4);
ffffffffc0200c7a:	ffb48793          	addi	a5,s1,-5
ffffffffc0200c7e:	66c79663          	bne	a5,a2,ffffffffc02012ea <buddy_check+0x770>
    int has_free_block = 0;
    for (int o = 0; o <= 2; o++) {
        if (buddy_free_areas[o].nr_free > 0) {
ffffffffc0200c82:	00005c17          	auipc	s8,0x5
ffffffffc0200c86:	396c0c13          	addi	s8,s8,918 # ffffffffc0206018 <buddy_free_areas>
ffffffffc0200c8a:	010c2783          	lw	a5,16(s8)
ffffffffc0200c8e:	028c2683          	lw	a3,40(s8)
ffffffffc0200c92:	040c2703          	lw	a4,64(s8)
ffffffffc0200c96:	8fd5                	or	a5,a5,a3
ffffffffc0200c98:	8fd9                	or	a5,a5,a4
ffffffffc0200c9a:	2781                	sext.w	a5,a5
ffffffffc0200c9c:	e38d                	bnez	a5,ffffffffc0200cbe <buddy_check+0x144>
            has_free_block = 1;
            break;
        }
    }
    assert(has_free_block == 1);
ffffffffc0200c9e:	00001697          	auipc	a3,0x1
ffffffffc0200ca2:	38a68693          	addi	a3,a3,906 # ffffffffc0202028 <etext+0x65a>
ffffffffc0200ca6:	00001617          	auipc	a2,0x1
ffffffffc0200caa:	07a60613          	addi	a2,a2,122 # ffffffffc0201d20 <etext+0x352>
ffffffffc0200cae:	12800593          	li	a1,296
ffffffffc0200cb2:	00001517          	auipc	a0,0x1
ffffffffc0200cb6:	08650513          	addi	a0,a0,134 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0200cba:	d08ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    score++;
    cprintf("Test 2 Passed (alloc 3->4 pages, split ok) | Score: %d/%d\n", score, sum_score);
ffffffffc0200cbe:	4621                	li	a2,8
ffffffffc0200cc0:	4589                	li	a1,2
ffffffffc0200cc2:	00001517          	auipc	a0,0x1
ffffffffc0200cc6:	37e50513          	addi	a0,a0,894 # ffffffffc0202040 <etext+0x672>
ffffffffc0200cca:	c82ff0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 测试3：多轮分配+释放+合并
    free_pages(p1, 4);
ffffffffc0200cce:	4591                	li	a1,4
ffffffffc0200cd0:	855e                	mv	a0,s7
ffffffffc0200cd2:	684000ef          	jal	ra,ffffffffc0201356 <free_pages>
    free_page(p0);
ffffffffc0200cd6:	855a                	mv	a0,s6
ffffffffc0200cd8:	4585                	li	a1,1
ffffffffc0200cda:	67c000ef          	jal	ra,ffffffffc0201356 <free_pages>
    
    struct Page *p2 = alloc_pages(8);
ffffffffc0200cde:	4521                	li	a0,8
ffffffffc0200ce0:	66a000ef          	jal	ra,ffffffffc020134a <alloc_pages>
ffffffffc0200ce4:	8b2a                	mv	s6,a0
    struct Page *p3 = alloc_pages(2);
ffffffffc0200ce6:	4509                	li	a0,2
ffffffffc0200ce8:	662000ef          	jal	ra,ffffffffc020134a <alloc_pages>
    assert(p2 != NULL && p3 != NULL);
ffffffffc0200cec:	5c0b0f63          	beqz	s6,ffffffffc02012ca <buddy_check+0x750>
ffffffffc0200cf0:	5c050d63          	beqz	a0,ffffffffc02012ca <buddy_check+0x750>
    
    free_pages(p3, 2);
ffffffffc0200cf4:	4589                	li	a1,2
ffffffffc0200cf6:	660000ef          	jal	ra,ffffffffc0201356 <free_pages>
    struct Page *p1_new = alloc_pages(4);
ffffffffc0200cfa:	4511                	li	a0,4
ffffffffc0200cfc:	64e000ef          	jal	ra,ffffffffc020134a <alloc_pages>
    assert(p1_new != NULL);
ffffffffc0200d00:	5a050563          	beqz	a0,ffffffffc02012aa <buddy_check+0x730>
    free_pages(p1_new, 4);
ffffffffc0200d04:	4591                	li	a1,4
ffffffffc0200d06:	650000ef          	jal	ra,ffffffffc0201356 <free_pages>
    free_pages(p2, 8);
ffffffffc0200d0a:	855a                	mv	a0,s6
ffffffffc0200d0c:	45a1                	li	a1,8
ffffffffc0200d0e:	00005b97          	auipc	s7,0x5
ffffffffc0200d12:	362b8b93          	addi	s7,s7,866 # ffffffffc0206070 <buddy_free_areas+0x58>
ffffffffc0200d16:	640000ef          	jal	ra,ffffffffc0201356 <free_pages>
    
    int has_large_block = 0;
    for (int o = 3; o <= MAX_ORDER; o++) {
ffffffffc0200d1a:	00005b17          	auipc	s6,0x5
ffffffffc0200d1e:	476b0b13          	addi	s6,s6,1142 # ffffffffc0206190 <memory_size>
    free_pages(p2, 8);
ffffffffc0200d22:	87de                	mv	a5,s7
        if (buddy_free_areas[o].nr_free > 0) {
ffffffffc0200d24:	4398                	lw	a4,0(a5)
ffffffffc0200d26:	e705                	bnez	a4,ffffffffc0200d4e <buddy_check+0x1d4>
    for (int o = 3; o <= MAX_ORDER; o++) {
ffffffffc0200d28:	07e1                	addi	a5,a5,24
ffffffffc0200d2a:	ff679de3          	bne	a5,s6,ffffffffc0200d24 <buddy_check+0x1aa>
            has_large_block = 1;
            break;
        }
    }
    assert(has_large_block == 1);
ffffffffc0200d2e:	00002697          	auipc	a3,0x2
ffffffffc0200d32:	86a68693          	addi	a3,a3,-1942 # ffffffffc0202598 <etext+0xbca>
ffffffffc0200d36:	00001617          	auipc	a2,0x1
ffffffffc0200d3a:	fea60613          	addi	a2,a2,-22 # ffffffffc0201d20 <etext+0x352>
ffffffffc0200d3e:	14100593          	li	a1,321
ffffffffc0200d42:	00001517          	auipc	a0,0x1
ffffffffc0200d46:	ff650513          	addi	a0,a0,-10 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0200d4a:	c78ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    score++;
    cprintf("Test 3 Passed (multi alloc/free/merge) | Score: %d/%d\n", score, sum_score);
ffffffffc0200d4e:	4621                	li	a2,8
ffffffffc0200d50:	458d                	li	a1,3
ffffffffc0200d52:	00002517          	auipc	a0,0x2
ffffffffc0200d56:	85e50513          	addi	a0,a0,-1954 # ffffffffc02025b0 <etext+0xbe2>
ffffffffc0200d5a:	bf2ff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200d5e:	00005697          	auipc	a3,0x5
ffffffffc0200d62:	2ca68693          	addi	a3,a3,714 # ffffffffc0206028 <buddy_free_areas+0x10>
    size_t total = 0;
ffffffffc0200d66:	4601                	li	a2,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200d68:	4701                	li	a4,0
ffffffffc0200d6a:	45bd                	li	a1,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200d6c:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200d6e:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200d70:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200d74:	1782                	slli	a5,a5,0x20
ffffffffc0200d76:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200d78:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200d7a:	963e                	add	a2,a2,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200d7c:	feb718e3          	bne	a4,a1,ffffffffc0200d6c <buddy_check+0x1f2>

    // 测试4：边界块合并
    int test_order = (MAX_ORDER >= 2) ? MAX_ORDER - 2 : 0;
    size_t test_block_size = BLOCK_SIZE(test_order);
    if (test_block_size > buddy_nr_free_pages()) {
ffffffffc0200d80:	6785                	lui	a5,0x1
ffffffffc0200d82:	24f66e63          	bltu	a2,a5,ffffffffc0200fde <buddy_check+0x464>
        test_order = get_min_order(buddy_nr_free_pages() / 2);
        test_block_size = BLOCK_SIZE(test_order);
    }
    struct Page *p4 = alloc_pages(test_block_size);
ffffffffc0200d86:	6505                	lui	a0,0x1
ffffffffc0200d88:	5c2000ef          	jal	ra,ffffffffc020134a <alloc_pages>
ffffffffc0200d8c:	8caa                	mv	s9,a0
    assert(p4 != NULL);
ffffffffc0200d8e:	3a050e63          	beqz	a0,ffffffffc020114a <buddy_check+0x5d0>
    free_pages(p4, test_block_size);
ffffffffc0200d92:	6585                	lui	a1,0x1
ffffffffc0200d94:	5c2000ef          	jal	ra,ffffffffc0201356 <free_pages>
    size_t test_block_size = BLOCK_SIZE(test_order);
ffffffffc0200d98:	6d85                	lui	s11,0x1
    int test_order = (MAX_ORDER >= 2) ? MAX_ORDER - 2 : 0;
ffffffffc0200d9a:	4d31                	li	s10,12
    size_t page_idx = PAGE_IDX(page);
ffffffffc0200d9c:	00005717          	auipc	a4,0x5
ffffffffc0200da0:	40473703          	ld	a4,1028(a4) # ffffffffc02061a0 <pages>
ffffffffc0200da4:	40ec87b3          	sub	a5,s9,a4
ffffffffc0200da8:	00002697          	auipc	a3,0x2
ffffffffc0200dac:	c206b683          	ld	a3,-992(a3) # ffffffffc02029c8 <error_string+0x38>
ffffffffc0200db0:	878d                	srai	a5,a5,0x3
ffffffffc0200db2:	02d787b3          	mul	a5,a5,a3
    return (buddy_idx < npage) ? (pages + buddy_idx) : NULL;
ffffffffc0200db6:	00005697          	auipc	a3,0x5
ffffffffc0200dba:	3e26b683          	ld	a3,994(a3) # ffffffffc0206198 <npage>
    size_t buddy_idx = page_idx ^ block_size;
ffffffffc0200dbe:	01b7c7b3          	xor	a5,a5,s11
    return (buddy_idx < npage) ? (pages + buddy_idx) : NULL;
ffffffffc0200dc2:	00d7fe63          	bgeu	a5,a3,ffffffffc0200dde <buddy_check+0x264>
ffffffffc0200dc6:	00279693          	slli	a3,a5,0x2
ffffffffc0200dca:	97b6                	add	a5,a5,a3
ffffffffc0200dcc:	078e                	slli	a5,a5,0x3
ffffffffc0200dce:	97ba                	add	a5,a5,a4
    
    struct Page *buddy_p4 = get_buddy(p4, test_order);
    if (buddy_p4 != NULL && PageProperty(buddy_p4) && buddy_p4->property == test_order) {
ffffffffc0200dd0:	c799                	beqz	a5,ffffffffc0200dde <buddy_check+0x264>
ffffffffc0200dd2:	6798                	ld	a4,8(a5)
ffffffffc0200dd4:	8b09                	andi	a4,a4,2
ffffffffc0200dd6:	c701                	beqz	a4,ffffffffc0200dde <buddy_check+0x264>
ffffffffc0200dd8:	4b9c                	lw	a5,16(a5)
ffffffffc0200dda:	31a78963          	beq	a5,s10,ffffffffc02010ec <buddy_check+0x572>
        assert(buddy_free_areas[test_order + 1].nr_free > 0);
    }
    score++;
    cprintf("Test 4 Passed (boundary merge, block size: %d) | Score: %d/%d\n", 
ffffffffc0200dde:	000d859b          	sext.w	a1,s11
ffffffffc0200de2:	46a1                	li	a3,8
ffffffffc0200de4:	4611                	li	a2,4
ffffffffc0200de6:	00001517          	auipc	a0,0x1
ffffffffc0200dea:	30a50513          	addi	a0,a0,778 # ffffffffc02020f0 <etext+0x722>
ffffffffc0200dee:	b5eff0ef          	jal	ra,ffffffffc020014c <cprintf>
ffffffffc0200df2:	00005697          	auipc	a3,0x5
ffffffffc0200df6:	23668693          	addi	a3,a3,566 # ffffffffc0206028 <buddy_free_areas+0x10>
    size_t total = 0;
ffffffffc0200dfa:	4601                	li	a2,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200dfc:	4701                	li	a4,0
ffffffffc0200dfe:	45bd                	li	a1,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200e00:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200e02:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200e04:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200e08:	1782                	slli	a5,a5,0x20
ffffffffc0200e0a:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200e0c:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200e0e:	963e                	add	a2,a2,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200e10:	feb718e3          	bne	a4,a1,ffffffffc0200e00 <buddy_check+0x286>
            (int)test_block_size, score, sum_score);

    // 测试5：最大块分配
    cprintf("Test 5: attempting to alloc %d pages (current free: %d)\n", 
ffffffffc0200e14:	2601                	sext.w	a2,a2
ffffffffc0200e16:	85d2                	mv	a1,s4
ffffffffc0200e18:	00001517          	auipc	a0,0x1
ffffffffc0200e1c:	31850513          	addi	a0,a0,792 # ffffffffc0202130 <etext+0x762>
ffffffffc0200e20:	b2cff0ef          	jal	ra,ffffffffc020014c <cprintf>
            (int)max_possible_block, (int)buddy_nr_free_pages());
    struct Page *p5 = alloc_pages(max_possible_block);
ffffffffc0200e24:	854e                	mv	a0,s3
ffffffffc0200e26:	524000ef          	jal	ra,ffffffffc020134a <alloc_pages>
ffffffffc0200e2a:	8caa                	mv	s9,a0
    assert(p5 != NULL);
ffffffffc0200e2c:	40050f63          	beqz	a0,ffffffffc020124a <buddy_check+0x6d0>
ffffffffc0200e30:	00005697          	auipc	a3,0x5
ffffffffc0200e34:	1f868693          	addi	a3,a3,504 # ffffffffc0206028 <buddy_free_areas+0x10>
    size_t total = 0;
ffffffffc0200e38:	4d01                	li	s10,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200e3a:	4701                	li	a4,0
ffffffffc0200e3c:	463d                	li	a2,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200e3e:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200e40:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200e42:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200e46:	1782                	slli	a5,a5,0x20
ffffffffc0200e48:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200e4a:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200e4c:	9d3e                	add	s10,s10,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200e4e:	fec718e3          	bne	a4,a2,ffffffffc0200e3e <buddy_check+0x2c4>
    
    size_t after_alloc5 = buddy_nr_free_pages();
    size_t expected_free = initial_free - max_possible_block;
ffffffffc0200e52:	41348db3          	sub	s11,s1,s3
    cprintf("After alloc: free pages = %d, expected = %d\n", 
ffffffffc0200e56:	000d861b          	sext.w	a2,s11
ffffffffc0200e5a:	000d059b          	sext.w	a1,s10
ffffffffc0200e5e:	00001517          	auipc	a0,0x1
ffffffffc0200e62:	32250513          	addi	a0,a0,802 # ffffffffc0202180 <etext+0x7b2>
ffffffffc0200e66:	ae6ff0ef          	jal	ra,ffffffffc020014c <cprintf>
            (int)after_alloc5, (int)expected_free);
    
    
    assert(after_alloc5 == expected_free);
ffffffffc0200e6a:	33ad9063          	bne	s11,s10,ffffffffc020118a <buddy_check+0x610>
    if (n <= 0) return 0;
ffffffffc0200e6e:	4781                	li	a5,0
ffffffffc0200e70:	00098b63          	beqz	s3,ffffffffc0200e86 <buddy_check+0x30c>
    size_t size = 1;
ffffffffc0200e74:	4705                	li	a4,1
        if (order > MAX_ORDER) {
ffffffffc0200e76:	46bd                	li	a3,15
    while (size < n) {
ffffffffc0200e78:	01377763          	bgeu	a4,s3,ffffffffc0200e86 <buddy_check+0x30c>
        order++;
ffffffffc0200e7c:	2785                	addiw	a5,a5,1
        size <<= 1;
ffffffffc0200e7e:	0706                	slli	a4,a4,0x1
        if (order > MAX_ORDER) {
ffffffffc0200e80:	fed79ce3          	bne	a5,a3,ffffffffc0200e78 <buddy_check+0x2fe>
            return -1;
ffffffffc0200e84:	57fd                	li	a5,-1
    
    // 验证最大块链表已空
    int max_order = get_min_order(max_possible_block);
    assert(buddy_free_areas[max_order].nr_free == 0);
ffffffffc0200e86:	00179713          	slli	a4,a5,0x1
ffffffffc0200e8a:	97ba                	add	a5,a5,a4
ffffffffc0200e8c:	078e                	slli	a5,a5,0x3
ffffffffc0200e8e:	97e2                	add	a5,a5,s8
ffffffffc0200e90:	4b9c                	lw	a5,16(a5)
ffffffffc0200e92:	30079c63          	bnez	a5,ffffffffc02011aa <buddy_check+0x630>
    score++;
    cprintf("Test 5 Passed (alloc max block: %d pages) | Score: %d/%d\n", 
ffffffffc0200e96:	46a1                	li	a3,8
ffffffffc0200e98:	4615                	li	a2,5
ffffffffc0200e9a:	85d2                	mv	a1,s4
ffffffffc0200e9c:	00001517          	auipc	a0,0x1
ffffffffc0200ea0:	36450513          	addi	a0,a0,868 # ffffffffc0202200 <etext+0x832>
ffffffffc0200ea4:	aa8ff0ef          	jal	ra,ffffffffc020014c <cprintf>
            (int)max_possible_block, score, sum_score);

    // 测试6：分配超出最大块
    struct Page *p6 = alloc_pages(max_possible_block + 1);
ffffffffc0200ea8:	00198513          	addi	a0,s3,1
ffffffffc0200eac:	49e000ef          	jal	ra,ffffffffc020134a <alloc_pages>
    assert(p6 == NULL);
ffffffffc0200eb0:	44051d63          	bnez	a0,ffffffffc020130a <buddy_check+0x790>
    score++;
    cprintf("Test 6 Passed (alloc >max block: failed) | Score: %d/%d\n", score, sum_score);
ffffffffc0200eb4:	4621                	li	a2,8
ffffffffc0200eb6:	4599                	li	a1,6
ffffffffc0200eb8:	00001517          	auipc	a0,0x1
ffffffffc0200ebc:	39850513          	addi	a0,a0,920 # ffffffffc0202250 <etext+0x882>
ffffffffc0200ec0:	a8cff0ef          	jal	ra,ffffffffc020014c <cprintf>

    // 测试7：释放后空闲数恢复
    free_pages(p5, max_possible_block);
ffffffffc0200ec4:	85ce                	mv	a1,s3
ffffffffc0200ec6:	8566                	mv	a0,s9
ffffffffc0200ec8:	48e000ef          	jal	ra,ffffffffc0201356 <free_pages>
ffffffffc0200ecc:	00005697          	auipc	a3,0x5
ffffffffc0200ed0:	15c68693          	addi	a3,a3,348 # ffffffffc0206028 <buddy_free_areas+0x10>
    size_t total = 0;
ffffffffc0200ed4:	4601                	li	a2,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200ed6:	4701                	li	a4,0
ffffffffc0200ed8:	45bd                	li	a1,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200eda:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200edc:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200ede:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200ee2:	1782                	slli	a5,a5,0x20
ffffffffc0200ee4:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200ee6:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200ee8:	963e                	add	a2,a2,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200eea:	feb718e3          	bne	a4,a1,ffffffffc0200eda <buddy_check+0x360>
    size_t final_free = buddy_nr_free_pages();
    
    // 严格检查：必须完全恢复
    assert(final_free == initial_free);
ffffffffc0200eee:	42c49e63          	bne	s1,a2,ffffffffc020132a <buddy_check+0x7b0>
    score++;
    cprintf("Test 7 Passed (free count recover: %d) | Score: %d/%d\n", 
ffffffffc0200ef2:	46a1                	li	a3,8
ffffffffc0200ef4:	461d                	li	a2,7
ffffffffc0200ef6:	85d6                	mv	a1,s5
ffffffffc0200ef8:	00001517          	auipc	a0,0x1
ffffffffc0200efc:	3b850513          	addi	a0,a0,952 # ffffffffc02022b0 <etext+0x8e2>
ffffffffc0200f00:	a4cff0ef          	jal	ra,ffffffffc020014c <cprintf>
            (int)final_free, score, sum_score);

    // 测试8：连续小分配+合并 
    cprintf("Test 8: Testing small allocation and merge...\n");
ffffffffc0200f04:	00001517          	auipc	a0,0x1
ffffffffc0200f08:	3e450513          	addi	a0,a0,996 # ffffffffc02022e8 <etext+0x91a>
ffffffffc0200f0c:	a40ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    
    // 方法1：分配一个4页块，然后拆分成单页，再释放看是否能合并回去
    struct Page *base_block = alloc_pages(4);  // 分配4页块
ffffffffc0200f10:	4511                	li	a0,4
ffffffffc0200f12:	438000ef          	jal	ra,ffffffffc020134a <alloc_pages>
    assert(base_block != NULL);
ffffffffc0200f16:	2a050a63          	beqz	a0,ffffffffc02011ca <buddy_check+0x650>
    for (int i = 0; i < 4; i++) {
        single_pages[i] = base_block + i;
    }
    
    // 释放这个4页块
    free_pages(base_block, 4);
ffffffffc0200f1a:	4591                	li	a1,4
ffffffffc0200f1c:	898a                	mv	s3,sp
ffffffffc0200f1e:	438000ef          	jal	ra,ffffffffc0201356 <free_pages>
    
    // 现在分配4个单页，应该从刚才释放的4页块中拆分出来
    struct Page *allocated_pages[4];
    for (int i = 0; i < 4; i++) {
ffffffffc0200f22:	02010a93          	addi	s5,sp,32
    free_pages(base_block, 4);
ffffffffc0200f26:	8a4e                	mv	s4,s3
        allocated_pages[i] = alloc_page();
ffffffffc0200f28:	4505                	li	a0,1
ffffffffc0200f2a:	420000ef          	jal	ra,ffffffffc020134a <alloc_pages>
ffffffffc0200f2e:	00aa3023          	sd	a0,0(s4)
        assert(allocated_pages[i] != NULL);
ffffffffc0200f32:	22050c63          	beqz	a0,ffffffffc020116a <buddy_check+0x5f0>
    for (int i = 0; i < 4; i++) {
ffffffffc0200f36:	0a21                	addi	s4,s4,8
ffffffffc0200f38:	ff4a98e3          	bne	s5,s4,ffffffffc0200f28 <buddy_check+0x3ae>
    }
    
    // 打印分配后的状态
    cprintf("After allocating 4 single pages from 4-page block:\n");
ffffffffc0200f3c:	00001517          	auipc	a0,0x1
ffffffffc0200f40:	41450513          	addi	a0,a0,1044 # ffffffffc0202350 <etext+0x982>
ffffffffc0200f44:	a08ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    buddy_debug_info();
ffffffffc0200f48:	eacff0ef          	jal	ra,ffffffffc02005f4 <buddy_debug_info>
    
    // 检查这些页是否来自同一个4页块（应该是连续的）
    int are_continuous = 1;
    for (int i = 1; i < 4; i++) {
        if (allocated_pages[i] != allocated_pages[i-1] + 1) {
ffffffffc0200f4c:	6782                	ld	a5,0(sp)
ffffffffc0200f4e:	66a2                	ld	a3,8(sp)
ffffffffc0200f50:	02878713          	addi	a4,a5,40 # 1028 <kern_entry-0xffffffffc01fefd8>
ffffffffc0200f54:	12e69863          	bne	a3,a4,ffffffffc0201084 <buddy_check+0x50a>
ffffffffc0200f58:	66c2                	ld	a3,16(sp)
ffffffffc0200f5a:	05078713          	addi	a4,a5,80
ffffffffc0200f5e:	12e69363          	bne	a3,a4,ffffffffc0201084 <buddy_check+0x50a>
ffffffffc0200f62:	6762                	ld	a4,24(sp)
ffffffffc0200f64:	07878793          	addi	a5,a5,120
ffffffffc0200f68:	10f71e63          	bne	a4,a5,ffffffffc0201084 <buddy_check+0x50a>
            break;
        }
    }
    
    if (are_continuous) {
        cprintf("Allocated pages are continuous, good for merging test\n");
ffffffffc0200f6c:	00001517          	auipc	a0,0x1
ffffffffc0200f70:	41c50513          	addi	a0,a0,1052 # ffffffffc0202388 <etext+0x9ba>
ffffffffc0200f74:	9d8ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        
        // 释放这4个连续的页，它们应该合并成一个4页块
        for (int i = 0; i < 4; i++) {
            free_page(allocated_pages[i]);
ffffffffc0200f78:	0009b503          	ld	a0,0(s3)
ffffffffc0200f7c:	4585                	li	a1,1
        for (int i = 0; i < 4; i++) {
ffffffffc0200f7e:	09a1                	addi	s3,s3,8
            free_page(allocated_pages[i]);
ffffffffc0200f80:	3d6000ef          	jal	ra,ffffffffc0201356 <free_pages>
        for (int i = 0; i < 4; i++) {
ffffffffc0200f84:	ff599ae3          	bne	s3,s5,ffffffffc0200f78 <buddy_check+0x3fe>
        }
        
        cprintf("After freeing 4 continuous pages:\n");
ffffffffc0200f88:	00001517          	auipc	a0,0x1
ffffffffc0200f8c:	43850513          	addi	a0,a0,1080 # ffffffffc02023c0 <etext+0x9f2>
ffffffffc0200f90:	9bcff0ef          	jal	ra,ffffffffc020014c <cprintf>
        buddy_debug_info();
ffffffffc0200f94:	e60ff0ef          	jal	ra,ffffffffc02005f4 <buddy_debug_info>
        
        // 检查是否形成了4页块（order=2）
        if (buddy_free_areas[2].nr_free >= 1) {
ffffffffc0200f98:	040c2783          	lw	a5,64(s8)
ffffffffc0200f9c:	12078863          	beqz	a5,ffffffffc02010cc <buddy_check+0x552>
            cprintf("Successfully merged into order=2 block\n");
ffffffffc0200fa0:	00001517          	auipc	a0,0x1
ffffffffc0200fa4:	44850513          	addi	a0,a0,1096 # ffffffffc02023e8 <etext+0xa1a>
ffffffffc0200fa8:	9a4ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        buddy_debug_info();
    }
    
    // 最终检查：必须存在order>=2的块
    int has_order2_plus = 0;
    for (int o = 2; o <= MAX_ORDER; o++) {
ffffffffc0200fac:	00005797          	auipc	a5,0x5
ffffffffc0200fb0:	0ac78793          	addi	a5,a5,172 # ffffffffc0206058 <buddy_free_areas+0x40>
        if (buddy_free_areas[o].nr_free > 0) {
ffffffffc0200fb4:	4398                	lw	a4,0(a5)
ffffffffc0200fb6:	eb3d                	bnez	a4,ffffffffc020102c <buddy_check+0x4b2>
    for (int o = 2; o <= MAX_ORDER; o++) {
ffffffffc0200fb8:	07e1                	addi	a5,a5,24
ffffffffc0200fba:	ff679de3          	bne	a5,s6,ffffffffc0200fb4 <buddy_check+0x43a>
            has_order2_plus = 1;
            break;
        }
    }
    assert(has_order2_plus == 1);
ffffffffc0200fbe:	00001697          	auipc	a3,0x1
ffffffffc0200fc2:	54a68693          	addi	a3,a3,1354 # ffffffffc0202508 <etext+0xb3a>
ffffffffc0200fc6:	00001617          	auipc	a2,0x1
ffffffffc0200fca:	d5a60613          	addi	a2,a2,-678 # ffffffffc0201d20 <etext+0x352>
ffffffffc0200fce:	1d100593          	li	a1,465
ffffffffc0200fd2:	00001517          	auipc	a0,0x1
ffffffffc0200fd6:	d6650513          	addi	a0,a0,-666 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0200fda:	9e8ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc0200fde:	00005697          	auipc	a3,0x5
ffffffffc0200fe2:	04a68693          	addi	a3,a3,74 # ffffffffc0206028 <buddy_free_areas+0x10>
    size_t total = 0;
ffffffffc0200fe6:	4601                	li	a2,0
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200fe8:	4701                	li	a4,0
ffffffffc0200fea:	45bd                	li	a1,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200fec:	429c                	lw	a5,0(a3)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200fee:	06e1                	addi	a3,a3,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200ff0:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200ff4:	1782                	slli	a5,a5,0x20
ffffffffc0200ff6:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200ff8:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0200ffa:	963e                	add	a2,a2,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0200ffc:	feb718e3          	bne	a4,a1,ffffffffc0200fec <buddy_check+0x472>
    if (n <= 0) return 0;
ffffffffc0201000:	4785                	li	a5,1
ffffffffc0201002:	10c7fe63          	bgeu	a5,a2,ffffffffc020111e <buddy_check+0x5a4>
        test_order = get_min_order(buddy_nr_free_pages() / 2);
ffffffffc0201006:	8205                	srli	a2,a2,0x1
    int order = 0;
ffffffffc0201008:	4d01                	li	s10,0
        if (order > MAX_ORDER) {
ffffffffc020100a:	473d                	li	a4,15
    while (size < n) {
ffffffffc020100c:	12c7f463          	bgeu	a5,a2,ffffffffc0201134 <buddy_check+0x5ba>
        order++;
ffffffffc0201010:	2d05                	addiw	s10,s10,1
        size <<= 1;
ffffffffc0201012:	0786                	slli	a5,a5,0x1
        if (order > MAX_ORDER) {
ffffffffc0201014:	feed1ce3          	bne	s10,a4,ffffffffc020100c <buddy_check+0x492>
    struct Page *p4 = alloc_pages(test_block_size);
ffffffffc0201018:	4501                	li	a0,0
ffffffffc020101a:	330000ef          	jal	ra,ffffffffc020134a <alloc_pages>
    assert(p4 != NULL);
ffffffffc020101e:	12050663          	beqz	a0,ffffffffc020114a <buddy_check+0x5d0>
    free_pages(p4, test_block_size);
ffffffffc0201022:	4581                	li	a1,0
ffffffffc0201024:	332000ef          	jal	ra,ffffffffc0201356 <free_pages>
ffffffffc0201028:	4581                	li	a1,0
ffffffffc020102a:	bb65                	j	ffffffffc0200de2 <buddy_check+0x268>
    
    score++;
    cprintf("Test 8 Passed (small alloc + merge) | Score: %d/%d\n", score, sum_score);
ffffffffc020102c:	4621                	li	a2,8
ffffffffc020102e:	45a1                	li	a1,8
ffffffffc0201030:	00001517          	auipc	a0,0x1
ffffffffc0201034:	4f050513          	addi	a0,a0,1264 # ffffffffc0202520 <etext+0xb52>
ffffffffc0201038:	914ff0ef          	jal	ra,ffffffffc020014c <cprintf>
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020103c:	4701                	li	a4,0
ffffffffc020103e:	46bd                	li	a3,15
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0201040:	401c                	lw	a5,0(s0)
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0201042:	0461                	addi	s0,s0,24
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc0201044:	00e797bb          	sllw	a5,a5,a4
ffffffffc0201048:	1782                	slli	a5,a5,0x20
ffffffffc020104a:	9381                	srli	a5,a5,0x20
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc020104c:	2705                	addiw	a4,a4,1
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
ffffffffc020104e:	993e                	add	s2,s2,a5
    for (int i = 0; i <= MAX_ORDER; i++) {
ffffffffc0201050:	fed718e3          	bne	a4,a3,ffffffffc0201040 <buddy_check+0x4c6>

    // 测试总结
    assert(buddy_nr_free_pages() == initial_free);
ffffffffc0201054:	21249b63          	bne	s1,s2,ffffffffc020126a <buddy_check+0x6f0>
    cprintf("=== Buddy System Test Passed (Total: %d/%d) ===\n\n", score, sum_score);
}
ffffffffc0201058:	640a                	ld	s0,128(sp)
ffffffffc020105a:	60aa                	ld	ra,136(sp)
ffffffffc020105c:	74e6                	ld	s1,120(sp)
ffffffffc020105e:	7946                	ld	s2,112(sp)
ffffffffc0201060:	79a6                	ld	s3,104(sp)
ffffffffc0201062:	7a06                	ld	s4,96(sp)
ffffffffc0201064:	6ae6                	ld	s5,88(sp)
ffffffffc0201066:	6b46                	ld	s6,80(sp)
ffffffffc0201068:	6ba6                	ld	s7,72(sp)
ffffffffc020106a:	6c06                	ld	s8,64(sp)
ffffffffc020106c:	7ce2                	ld	s9,56(sp)
ffffffffc020106e:	7d42                	ld	s10,48(sp)
ffffffffc0201070:	7da2                	ld	s11,40(sp)
    cprintf("=== Buddy System Test Passed (Total: %d/%d) ===\n\n", score, sum_score);
ffffffffc0201072:	4621                	li	a2,8
ffffffffc0201074:	45a1                	li	a1,8
ffffffffc0201076:	00001517          	auipc	a0,0x1
ffffffffc020107a:	45a50513          	addi	a0,a0,1114 # ffffffffc02024d0 <etext+0xb02>
}
ffffffffc020107e:	6149                	addi	sp,sp,144
    cprintf("=== Buddy System Test Passed (Total: %d/%d) ===\n\n", score, sum_score);
ffffffffc0201080:	8ccff06f          	j	ffffffffc020014c <cprintf>
        cprintf("Allocated pages are not continuous, using alternative test\n");
ffffffffc0201084:	00001517          	auipc	a0,0x1
ffffffffc0201088:	4d450513          	addi	a0,a0,1236 # ffffffffc0202558 <etext+0xb8a>
ffffffffc020108c:	8c0ff0ef          	jal	ra,ffffffffc020014c <cprintf>
            free_page(allocated_pages[i]);
ffffffffc0201090:	0009b503          	ld	a0,0(s3)
ffffffffc0201094:	4585                	li	a1,1
        for (int i = 0; i < 4; i++) {
ffffffffc0201096:	09a1                	addi	s3,s3,8
            free_page(allocated_pages[i]);
ffffffffc0201098:	2be000ef          	jal	ra,ffffffffc0201356 <free_pages>
        for (int i = 0; i < 4; i++) {
ffffffffc020109c:	ff3a9ae3          	bne	s5,s3,ffffffffc0201090 <buddy_check+0x516>
        struct Page *test_block = alloc_pages(4);
ffffffffc02010a0:	4511                	li	a0,4
ffffffffc02010a2:	2a8000ef          	jal	ra,ffffffffc020134a <alloc_pages>
        assert(test_block != NULL);
ffffffffc02010a6:	14050263          	beqz	a0,ffffffffc02011ea <buddy_check+0x670>
        free_pages(test_block, 4);
ffffffffc02010aa:	4591                	li	a1,4
ffffffffc02010ac:	2aa000ef          	jal	ra,ffffffffc0201356 <free_pages>
        cprintf("After alloc/free of 4-page block:\n");
ffffffffc02010b0:	00001517          	auipc	a0,0x1
ffffffffc02010b4:	3d050513          	addi	a0,a0,976 # ffffffffc0202480 <etext+0xab2>
ffffffffc02010b8:	894ff0ef          	jal	ra,ffffffffc020014c <cprintf>
        buddy_debug_info();
ffffffffc02010bc:	d38ff0ef          	jal	ra,ffffffffc02005f4 <buddy_debug_info>
ffffffffc02010c0:	b5f5                	j	ffffffffc0200fac <buddy_check+0x432>
            max_possible_block = BLOCK_SIZE(o);
ffffffffc02010c2:	4a05                	li	s4,1
ffffffffc02010c4:	00da1a3b          	sllw	s4,s4,a3
ffffffffc02010c8:	89d2                	mv	s3,s4
            break;
ffffffffc02010ca:	be29                	j	ffffffffc0200be4 <buddy_check+0x6a>
            cprintf("Warning: Expected order=2 block but not found\n");
ffffffffc02010cc:	00001517          	auipc	a0,0x1
ffffffffc02010d0:	34450513          	addi	a0,a0,836 # ffffffffc0202410 <etext+0xa42>
ffffffffc02010d4:	878ff0ef          	jal	ra,ffffffffc020014c <cprintf>
            for (int o = 3; o <= MAX_ORDER; o++) {
ffffffffc02010d8:	458d                	li	a1,3
ffffffffc02010da:	473d                	li	a4,15
                if (buddy_free_areas[o].nr_free > 0) {
ffffffffc02010dc:	000ba783          	lw	a5,0(s7)
ffffffffc02010e0:	efb1                	bnez	a5,ffffffffc020113c <buddy_check+0x5c2>
            for (int o = 3; o <= MAX_ORDER; o++) {
ffffffffc02010e2:	2585                	addiw	a1,a1,1
ffffffffc02010e4:	0be1                	addi	s7,s7,24
ffffffffc02010e6:	fee59be3          	bne	a1,a4,ffffffffc02010dc <buddy_check+0x562>
ffffffffc02010ea:	b5c9                	j	ffffffffc0200fac <buddy_check+0x432>
        assert(buddy_free_areas[test_order + 1].nr_free > 0);
ffffffffc02010ec:	2d05                	addiw	s10,s10,1
ffffffffc02010ee:	001d1793          	slli	a5,s10,0x1
ffffffffc02010f2:	97ea                	add	a5,a5,s10
ffffffffc02010f4:	078e                	slli	a5,a5,0x3
ffffffffc02010f6:	97e2                	add	a5,a5,s8
ffffffffc02010f8:	4b9c                	lw	a5,16(a5)
ffffffffc02010fa:	ce0792e3          	bnez	a5,ffffffffc0200dde <buddy_check+0x264>
ffffffffc02010fe:	00001697          	auipc	a3,0x1
ffffffffc0201102:	fc268693          	addi	a3,a3,-62 # ffffffffc02020c0 <etext+0x6f2>
ffffffffc0201106:	00001617          	auipc	a2,0x1
ffffffffc020110a:	c1a60613          	addi	a2,a2,-998 # ffffffffc0201d20 <etext+0x352>
ffffffffc020110e:	15200593          	li	a1,338
ffffffffc0201112:	00001517          	auipc	a0,0x1
ffffffffc0201116:	c2650513          	addi	a0,a0,-986 # ffffffffc0201d38 <etext+0x36a>
ffffffffc020111a:	8a8ff0ef          	jal	ra,ffffffffc02001c2 <__panic>
ffffffffc020111e:	4d85                	li	s11,1
    if (n <= 0) return 0;
ffffffffc0201120:	4d01                	li	s10,0
    struct Page *p4 = alloc_pages(test_block_size);
ffffffffc0201122:	856e                	mv	a0,s11
ffffffffc0201124:	226000ef          	jal	ra,ffffffffc020134a <alloc_pages>
ffffffffc0201128:	8caa                	mv	s9,a0
    assert(p4 != NULL);
ffffffffc020112a:	c105                	beqz	a0,ffffffffc020114a <buddy_check+0x5d0>
    free_pages(p4, test_block_size);
ffffffffc020112c:	85ee                	mv	a1,s11
ffffffffc020112e:	228000ef          	jal	ra,ffffffffc0201356 <free_pages>
    if (page == NULL || order < 0 || order > MAX_ORDER) {
ffffffffc0201132:	b1ad                	j	ffffffffc0200d9c <buddy_check+0x222>
        test_block_size = BLOCK_SIZE(test_order);
ffffffffc0201134:	4d85                	li	s11,1
ffffffffc0201136:	01ad9dbb          	sllw	s11,s11,s10
ffffffffc020113a:	b7e5                	j	ffffffffc0201122 <buddy_check+0x5a8>
                    cprintf("Found larger block at order=%d instead\n", o);
ffffffffc020113c:	00001517          	auipc	a0,0x1
ffffffffc0201140:	30450513          	addi	a0,a0,772 # ffffffffc0202440 <etext+0xa72>
ffffffffc0201144:	808ff0ef          	jal	ra,ffffffffc020014c <cprintf>
                    break;
ffffffffc0201148:	b595                	j	ffffffffc0200fac <buddy_check+0x432>
    assert(p4 != NULL);
ffffffffc020114a:	00001697          	auipc	a3,0x1
ffffffffc020114e:	f6668693          	addi	a3,a3,-154 # ffffffffc02020b0 <etext+0x6e2>
ffffffffc0201152:	00001617          	auipc	a2,0x1
ffffffffc0201156:	bce60613          	addi	a2,a2,-1074 # ffffffffc0201d20 <etext+0x352>
ffffffffc020115a:	14d00593          	li	a1,333
ffffffffc020115e:	00001517          	auipc	a0,0x1
ffffffffc0201162:	bda50513          	addi	a0,a0,-1062 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201166:	85cff0ef          	jal	ra,ffffffffc02001c2 <__panic>
        assert(allocated_pages[i] != NULL);
ffffffffc020116a:	00001697          	auipc	a3,0x1
ffffffffc020116e:	1c668693          	addi	a3,a3,454 # ffffffffc0202330 <etext+0x962>
ffffffffc0201172:	00001617          	auipc	a2,0x1
ffffffffc0201176:	bae60613          	addi	a2,a2,-1106 # ffffffffc0201d20 <etext+0x352>
ffffffffc020117a:	19100593          	li	a1,401
ffffffffc020117e:	00001517          	auipc	a0,0x1
ffffffffc0201182:	bba50513          	addi	a0,a0,-1094 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201186:	83cff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(after_alloc5 == expected_free);
ffffffffc020118a:	00001697          	auipc	a3,0x1
ffffffffc020118e:	02668693          	addi	a3,a3,38 # ffffffffc02021b0 <etext+0x7e2>
ffffffffc0201192:	00001617          	auipc	a2,0x1
ffffffffc0201196:	b8e60613          	addi	a2,a2,-1138 # ffffffffc0201d20 <etext+0x352>
ffffffffc020119a:	16400593          	li	a1,356
ffffffffc020119e:	00001517          	auipc	a0,0x1
ffffffffc02011a2:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02011a6:	81cff0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_free_areas[max_order].nr_free == 0);
ffffffffc02011aa:	00001697          	auipc	a3,0x1
ffffffffc02011ae:	02668693          	addi	a3,a3,38 # ffffffffc02021d0 <etext+0x802>
ffffffffc02011b2:	00001617          	auipc	a2,0x1
ffffffffc02011b6:	b6e60613          	addi	a2,a2,-1170 # ffffffffc0201d20 <etext+0x352>
ffffffffc02011ba:	16800593          	li	a1,360
ffffffffc02011be:	00001517          	auipc	a0,0x1
ffffffffc02011c2:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02011c6:	ffdfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(base_block != NULL);
ffffffffc02011ca:	00001697          	auipc	a3,0x1
ffffffffc02011ce:	14e68693          	addi	a3,a3,334 # ffffffffc0202318 <etext+0x94a>
ffffffffc02011d2:	00001617          	auipc	a2,0x1
ffffffffc02011d6:	b4e60613          	addi	a2,a2,-1202 # ffffffffc0201d20 <etext+0x352>
ffffffffc02011da:	18200593          	li	a1,386
ffffffffc02011de:	00001517          	auipc	a0,0x1
ffffffffc02011e2:	b5a50513          	addi	a0,a0,-1190 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02011e6:	fddfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
        assert(test_block != NULL);
ffffffffc02011ea:	00001697          	auipc	a3,0x1
ffffffffc02011ee:	27e68693          	addi	a3,a3,638 # ffffffffc0202468 <etext+0xa9a>
ffffffffc02011f2:	00001617          	auipc	a2,0x1
ffffffffc02011f6:	b2e60613          	addi	a2,a2,-1234 # ffffffffc0201d20 <etext+0x352>
ffffffffc02011fa:	1c200593          	li	a1,450
ffffffffc02011fe:	00001517          	auipc	a0,0x1
ffffffffc0201202:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201206:	fbdfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p1 != NULL);
ffffffffc020120a:	00001697          	auipc	a3,0x1
ffffffffc020120e:	de668693          	addi	a3,a3,-538 # ffffffffc0201ff0 <etext+0x622>
ffffffffc0201212:	00001617          	auipc	a2,0x1
ffffffffc0201216:	b0e60613          	addi	a2,a2,-1266 # ffffffffc0201d20 <etext+0x352>
ffffffffc020121a:	11e00593          	li	a1,286
ffffffffc020121e:	00001517          	auipc	a0,0x1
ffffffffc0201222:	b1a50513          	addi	a0,a0,-1254 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201226:	f9dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(after_alloc1 == initial_free - 1);
ffffffffc020122a:	00001697          	auipc	a3,0x1
ffffffffc020122e:	d6668693          	addi	a3,a3,-666 # ffffffffc0201f90 <etext+0x5c2>
ffffffffc0201232:	00001617          	auipc	a2,0x1
ffffffffc0201236:	aee60613          	addi	a2,a2,-1298 # ffffffffc0201d20 <etext+0x352>
ffffffffc020123a:	11700593          	li	a1,279
ffffffffc020123e:	00001517          	auipc	a0,0x1
ffffffffc0201242:	afa50513          	addi	a0,a0,-1286 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201246:	f7dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p5 != NULL);
ffffffffc020124a:	00001697          	auipc	a3,0x1
ffffffffc020124e:	f2668693          	addi	a3,a3,-218 # ffffffffc0202170 <etext+0x7a2>
ffffffffc0201252:	00001617          	auipc	a2,0x1
ffffffffc0201256:	ace60613          	addi	a2,a2,-1330 # ffffffffc0201d20 <etext+0x352>
ffffffffc020125a:	15c00593          	li	a1,348
ffffffffc020125e:	00001517          	auipc	a0,0x1
ffffffffc0201262:	ada50513          	addi	a0,a0,-1318 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201266:	f5dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(buddy_nr_free_pages() == initial_free);
ffffffffc020126a:	00001697          	auipc	a3,0x1
ffffffffc020126e:	23e68693          	addi	a3,a3,574 # ffffffffc02024a8 <etext+0xada>
ffffffffc0201272:	00001617          	auipc	a2,0x1
ffffffffc0201276:	aae60613          	addi	a2,a2,-1362 # ffffffffc0201d20 <etext+0x352>
ffffffffc020127a:	1d700593          	li	a1,471
ffffffffc020127e:	00001517          	auipc	a0,0x1
ffffffffc0201282:	aba50513          	addi	a0,a0,-1350 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201286:	f3dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p0 != NULL && !PageProperty(p0));
ffffffffc020128a:	00001697          	auipc	a3,0x1
ffffffffc020128e:	ce668693          	addi	a3,a3,-794 # ffffffffc0201f70 <etext+0x5a2>
ffffffffc0201292:	00001617          	auipc	a2,0x1
ffffffffc0201296:	a8e60613          	addi	a2,a2,-1394 # ffffffffc0201d20 <etext+0x352>
ffffffffc020129a:	11500593          	li	a1,277
ffffffffc020129e:	00001517          	auipc	a0,0x1
ffffffffc02012a2:	a9a50513          	addi	a0,a0,-1382 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02012a6:	f1dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p1_new != NULL);
ffffffffc02012aa:	00001697          	auipc	a3,0x1
ffffffffc02012ae:	df668693          	addi	a3,a3,-522 # ffffffffc02020a0 <etext+0x6d2>
ffffffffc02012b2:	00001617          	auipc	a2,0x1
ffffffffc02012b6:	a6e60613          	addi	a2,a2,-1426 # ffffffffc0201d20 <etext+0x352>
ffffffffc02012ba:	13600593          	li	a1,310
ffffffffc02012be:	00001517          	auipc	a0,0x1
ffffffffc02012c2:	a7a50513          	addi	a0,a0,-1414 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02012c6:	efdfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p2 != NULL && p3 != NULL);
ffffffffc02012ca:	00001697          	auipc	a3,0x1
ffffffffc02012ce:	db668693          	addi	a3,a3,-586 # ffffffffc0202080 <etext+0x6b2>
ffffffffc02012d2:	00001617          	auipc	a2,0x1
ffffffffc02012d6:	a4e60613          	addi	a2,a2,-1458 # ffffffffc0201d20 <etext+0x352>
ffffffffc02012da:	13200593          	li	a1,306
ffffffffc02012de:	00001517          	auipc	a0,0x1
ffffffffc02012e2:	a5a50513          	addi	a0,a0,-1446 # ffffffffc0201d38 <etext+0x36a>
ffffffffc02012e6:	eddfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(after_alloc2 == initial_free - 1 - 4);
ffffffffc02012ea:	00001697          	auipc	a3,0x1
ffffffffc02012ee:	d1668693          	addi	a3,a3,-746 # ffffffffc0202000 <etext+0x632>
ffffffffc02012f2:	00001617          	auipc	a2,0x1
ffffffffc02012f6:	a2e60613          	addi	a2,a2,-1490 # ffffffffc0201d20 <etext+0x352>
ffffffffc02012fa:	12000593          	li	a1,288
ffffffffc02012fe:	00001517          	auipc	a0,0x1
ffffffffc0201302:	a3a50513          	addi	a0,a0,-1478 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201306:	ebdfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(p6 == NULL);
ffffffffc020130a:	00001697          	auipc	a3,0x1
ffffffffc020130e:	f3668693          	addi	a3,a3,-202 # ffffffffc0202240 <etext+0x872>
ffffffffc0201312:	00001617          	auipc	a2,0x1
ffffffffc0201316:	a0e60613          	addi	a2,a2,-1522 # ffffffffc0201d20 <etext+0x352>
ffffffffc020131a:	16f00593          	li	a1,367
ffffffffc020131e:	00001517          	auipc	a0,0x1
ffffffffc0201322:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201326:	e9dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    assert(final_free == initial_free);
ffffffffc020132a:	00001697          	auipc	a3,0x1
ffffffffc020132e:	f6668693          	addi	a3,a3,-154 # ffffffffc0202290 <etext+0x8c2>
ffffffffc0201332:	00001617          	auipc	a2,0x1
ffffffffc0201336:	9ee60613          	addi	a2,a2,-1554 # ffffffffc0201d20 <etext+0x352>
ffffffffc020133a:	17800593          	li	a1,376
ffffffffc020133e:	00001517          	auipc	a0,0x1
ffffffffc0201342:	9fa50513          	addi	a0,a0,-1542 # ffffffffc0201d38 <etext+0x36a>
ffffffffc0201346:	e7dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc020134a <alloc_pages>:
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc020134a:	00005797          	auipc	a5,0x5
ffffffffc020134e:	e5e7b783          	ld	a5,-418(a5) # ffffffffc02061a8 <pmm_manager>
ffffffffc0201352:	6f9c                	ld	a5,24(a5)
ffffffffc0201354:	8782                	jr	a5

ffffffffc0201356 <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc0201356:	00005797          	auipc	a5,0x5
ffffffffc020135a:	e527b783          	ld	a5,-430(a5) # ffffffffc02061a8 <pmm_manager>
ffffffffc020135e:	739c                	ld	a5,32(a5)
ffffffffc0201360:	8782                	jr	a5

ffffffffc0201362 <pmm_init>:
    pmm_manager = &buddy_pmm_manager;
ffffffffc0201362:	00001797          	auipc	a5,0x1
ffffffffc0201366:	29e78793          	addi	a5,a5,670 # ffffffffc0202600 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020136a:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc020136c:	7179                	addi	sp,sp,-48
ffffffffc020136e:	f022                	sd	s0,32(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201370:	00001517          	auipc	a0,0x1
ffffffffc0201374:	2c850513          	addi	a0,a0,712 # ffffffffc0202638 <buddy_pmm_manager+0x38>
    pmm_manager = &buddy_pmm_manager;
ffffffffc0201378:	00005417          	auipc	s0,0x5
ffffffffc020137c:	e3040413          	addi	s0,s0,-464 # ffffffffc02061a8 <pmm_manager>
void pmm_init(void) {
ffffffffc0201380:	f406                	sd	ra,40(sp)
ffffffffc0201382:	ec26                	sd	s1,24(sp)
ffffffffc0201384:	e44e                	sd	s3,8(sp)
ffffffffc0201386:	e84a                	sd	s2,16(sp)
ffffffffc0201388:	e052                	sd	s4,0(sp)
    pmm_manager = &buddy_pmm_manager;
ffffffffc020138a:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020138c:	dc1fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    pmm_manager->init();
ffffffffc0201390:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201392:	00005497          	auipc	s1,0x5
ffffffffc0201396:	e2e48493          	addi	s1,s1,-466 # ffffffffc02061c0 <va_pa_offset>
    pmm_manager->init();
ffffffffc020139a:	679c                	ld	a5,8(a5)
ffffffffc020139c:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020139e:	57f5                	li	a5,-3
ffffffffc02013a0:	07fa                	slli	a5,a5,0x1e
ffffffffc02013a2:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc02013a4:	a18ff0ef          	jal	ra,ffffffffc02005bc <get_memory_base>
ffffffffc02013a8:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc02013aa:	a1cff0ef          	jal	ra,ffffffffc02005c6 <get_memory_size>
    if (mem_size == 0) {
ffffffffc02013ae:	14050d63          	beqz	a0,ffffffffc0201508 <pmm_init+0x1a6>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02013b2:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc02013b4:	00001517          	auipc	a0,0x1
ffffffffc02013b8:	2cc50513          	addi	a0,a0,716 # ffffffffc0202680 <buddy_pmm_manager+0x80>
ffffffffc02013bc:	d91fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02013c0:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02013c4:	864e                	mv	a2,s3
ffffffffc02013c6:	fffa0693          	addi	a3,s4,-1
ffffffffc02013ca:	85ca                	mv	a1,s2
ffffffffc02013cc:	00001517          	auipc	a0,0x1
ffffffffc02013d0:	2cc50513          	addi	a0,a0,716 # ffffffffc0202698 <buddy_pmm_manager+0x98>
ffffffffc02013d4:	d79fe0ef          	jal	ra,ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02013d8:	c80007b7          	lui	a5,0xc8000
ffffffffc02013dc:	8652                	mv	a2,s4
ffffffffc02013de:	0d47e463          	bltu	a5,s4,ffffffffc02014a6 <pmm_init+0x144>
ffffffffc02013e2:	00006797          	auipc	a5,0x6
ffffffffc02013e6:	de578793          	addi	a5,a5,-539 # ffffffffc02071c7 <end+0xfff>
ffffffffc02013ea:	757d                	lui	a0,0xfffff
ffffffffc02013ec:	8d7d                	and	a0,a0,a5
ffffffffc02013ee:	8231                	srli	a2,a2,0xc
ffffffffc02013f0:	00005797          	auipc	a5,0x5
ffffffffc02013f4:	dac7b423          	sd	a2,-600(a5) # ffffffffc0206198 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02013f8:	00005797          	auipc	a5,0x5
ffffffffc02013fc:	daa7b423          	sd	a0,-600(a5) # ffffffffc02061a0 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201400:	000807b7          	lui	a5,0x80
ffffffffc0201404:	002005b7          	lui	a1,0x200
ffffffffc0201408:	02f60563          	beq	a2,a5,ffffffffc0201432 <pmm_init+0xd0>
ffffffffc020140c:	00261593          	slli	a1,a2,0x2
ffffffffc0201410:	00c586b3          	add	a3,a1,a2
ffffffffc0201414:	fec007b7          	lui	a5,0xfec00
ffffffffc0201418:	97aa                	add	a5,a5,a0
ffffffffc020141a:	068e                	slli	a3,a3,0x3
ffffffffc020141c:	96be                	add	a3,a3,a5
ffffffffc020141e:	87aa                	mv	a5,a0
        SetPageReserved(pages + i);
ffffffffc0201420:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201422:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9f9e60>
        SetPageReserved(pages + i);
ffffffffc0201426:	00176713          	ori	a4,a4,1
ffffffffc020142a:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020142e:	fef699e3          	bne	a3,a5,ffffffffc0201420 <pmm_init+0xbe>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201432:	95b2                	add	a1,a1,a2
ffffffffc0201434:	fec006b7          	lui	a3,0xfec00
ffffffffc0201438:	96aa                	add	a3,a3,a0
ffffffffc020143a:	058e                	slli	a1,a1,0x3
ffffffffc020143c:	96ae                	add	a3,a3,a1
ffffffffc020143e:	c02007b7          	lui	a5,0xc0200
ffffffffc0201442:	0af6e763          	bltu	a3,a5,ffffffffc02014f0 <pmm_init+0x18e>
ffffffffc0201446:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0201448:	77fd                	lui	a5,0xfffff
ffffffffc020144a:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020144e:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0201450:	04b6ee63          	bltu	a3,a1,ffffffffc02014ac <pmm_init+0x14a>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201454:	601c                	ld	a5,0(s0)
ffffffffc0201456:	7b9c                	ld	a5,48(a5)
ffffffffc0201458:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020145a:	00001517          	auipc	a0,0x1
ffffffffc020145e:	2c650513          	addi	a0,a0,710 # ffffffffc0202720 <buddy_pmm_manager+0x120>
ffffffffc0201462:	cebfe0ef          	jal	ra,ffffffffc020014c <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0201466:	00004597          	auipc	a1,0x4
ffffffffc020146a:	b9a58593          	addi	a1,a1,-1126 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc020146e:	00005797          	auipc	a5,0x5
ffffffffc0201472:	d4b7b523          	sd	a1,-694(a5) # ffffffffc02061b8 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201476:	c02007b7          	lui	a5,0xc0200
ffffffffc020147a:	0af5e363          	bltu	a1,a5,ffffffffc0201520 <pmm_init+0x1be>
ffffffffc020147e:	6090                	ld	a2,0(s1)
}
ffffffffc0201480:	7402                	ld	s0,32(sp)
ffffffffc0201482:	70a2                	ld	ra,40(sp)
ffffffffc0201484:	64e2                	ld	s1,24(sp)
ffffffffc0201486:	6942                	ld	s2,16(sp)
ffffffffc0201488:	69a2                	ld	s3,8(sp)
ffffffffc020148a:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc020148c:	40c58633          	sub	a2,a1,a2
ffffffffc0201490:	00005797          	auipc	a5,0x5
ffffffffc0201494:	d2c7b023          	sd	a2,-736(a5) # ffffffffc02061b0 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201498:	00001517          	auipc	a0,0x1
ffffffffc020149c:	2a850513          	addi	a0,a0,680 # ffffffffc0202740 <buddy_pmm_manager+0x140>
}
ffffffffc02014a0:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02014a2:	cabfe06f          	j	ffffffffc020014c <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02014a6:	c8000637          	lui	a2,0xc8000
ffffffffc02014aa:	bf25                	j	ffffffffc02013e2 <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02014ac:	6705                	lui	a4,0x1
ffffffffc02014ae:	177d                	addi	a4,a4,-1
ffffffffc02014b0:	96ba                	add	a3,a3,a4
ffffffffc02014b2:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02014b4:	00c6d793          	srli	a5,a3,0xc
ffffffffc02014b8:	02c7f063          	bgeu	a5,a2,ffffffffc02014d8 <pmm_init+0x176>
    pmm_manager->init_memmap(base, n);
ffffffffc02014bc:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02014be:	fff80737          	lui	a4,0xfff80
ffffffffc02014c2:	973e                	add	a4,a4,a5
ffffffffc02014c4:	00271793          	slli	a5,a4,0x2
ffffffffc02014c8:	97ba                	add	a5,a5,a4
ffffffffc02014ca:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02014cc:	8d95                	sub	a1,a1,a3
ffffffffc02014ce:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02014d0:	81b1                	srli	a1,a1,0xc
ffffffffc02014d2:	953e                	add	a0,a0,a5
ffffffffc02014d4:	9702                	jalr	a4
}
ffffffffc02014d6:	bfbd                	j	ffffffffc0201454 <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc02014d8:	00001617          	auipc	a2,0x1
ffffffffc02014dc:	21860613          	addi	a2,a2,536 # ffffffffc02026f0 <buddy_pmm_manager+0xf0>
ffffffffc02014e0:	06a00593          	li	a1,106
ffffffffc02014e4:	00001517          	auipc	a0,0x1
ffffffffc02014e8:	22c50513          	addi	a0,a0,556 # ffffffffc0202710 <buddy_pmm_manager+0x110>
ffffffffc02014ec:	cd7fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02014f0:	00001617          	auipc	a2,0x1
ffffffffc02014f4:	1d860613          	addi	a2,a2,472 # ffffffffc02026c8 <buddy_pmm_manager+0xc8>
ffffffffc02014f8:	05e00593          	li	a1,94
ffffffffc02014fc:	00001517          	auipc	a0,0x1
ffffffffc0201500:	17450513          	addi	a0,a0,372 # ffffffffc0202670 <buddy_pmm_manager+0x70>
ffffffffc0201504:	cbffe0ef          	jal	ra,ffffffffc02001c2 <__panic>
        panic("DTB memory info not available");
ffffffffc0201508:	00001617          	auipc	a2,0x1
ffffffffc020150c:	14860613          	addi	a2,a2,328 # ffffffffc0202650 <buddy_pmm_manager+0x50>
ffffffffc0201510:	04600593          	li	a1,70
ffffffffc0201514:	00001517          	auipc	a0,0x1
ffffffffc0201518:	15c50513          	addi	a0,a0,348 # ffffffffc0202670 <buddy_pmm_manager+0x70>
ffffffffc020151c:	ca7fe0ef          	jal	ra,ffffffffc02001c2 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201520:	86ae                	mv	a3,a1
ffffffffc0201522:	00001617          	auipc	a2,0x1
ffffffffc0201526:	1a660613          	addi	a2,a2,422 # ffffffffc02026c8 <buddy_pmm_manager+0xc8>
ffffffffc020152a:	07900593          	li	a1,121
ffffffffc020152e:	00001517          	auipc	a0,0x1
ffffffffc0201532:	14250513          	addi	a0,a0,322 # ffffffffc0202670 <buddy_pmm_manager+0x70>
ffffffffc0201536:	c8dfe0ef          	jal	ra,ffffffffc02001c2 <__panic>

ffffffffc020153a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020153a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020153e:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0201540:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201544:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201546:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020154a:	f022                	sd	s0,32(sp)
ffffffffc020154c:	ec26                	sd	s1,24(sp)
ffffffffc020154e:	e84a                	sd	s2,16(sp)
ffffffffc0201550:	f406                	sd	ra,40(sp)
ffffffffc0201552:	e44e                	sd	s3,8(sp)
ffffffffc0201554:	84aa                	mv	s1,a0
ffffffffc0201556:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201558:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020155c:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020155e:	03067e63          	bgeu	a2,a6,ffffffffc020159a <printnum+0x60>
ffffffffc0201562:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201564:	00805763          	blez	s0,ffffffffc0201572 <printnum+0x38>
ffffffffc0201568:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020156a:	85ca                	mv	a1,s2
ffffffffc020156c:	854e                	mv	a0,s3
ffffffffc020156e:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201570:	fc65                	bnez	s0,ffffffffc0201568 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201572:	1a02                	slli	s4,s4,0x20
ffffffffc0201574:	00001797          	auipc	a5,0x1
ffffffffc0201578:	20c78793          	addi	a5,a5,524 # ffffffffc0202780 <buddy_pmm_manager+0x180>
ffffffffc020157c:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201580:	9a3e                	add	s4,s4,a5
}
ffffffffc0201582:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201584:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201588:	70a2                	ld	ra,40(sp)
ffffffffc020158a:	69a2                	ld	s3,8(sp)
ffffffffc020158c:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020158e:	85ca                	mv	a1,s2
ffffffffc0201590:	87a6                	mv	a5,s1
}
ffffffffc0201592:	6942                	ld	s2,16(sp)
ffffffffc0201594:	64e2                	ld	s1,24(sp)
ffffffffc0201596:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201598:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020159a:	03065633          	divu	a2,a2,a6
ffffffffc020159e:	8722                	mv	a4,s0
ffffffffc02015a0:	f9bff0ef          	jal	ra,ffffffffc020153a <printnum>
ffffffffc02015a4:	b7f9                	j	ffffffffc0201572 <printnum+0x38>

ffffffffc02015a6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02015a6:	7119                	addi	sp,sp,-128
ffffffffc02015a8:	f4a6                	sd	s1,104(sp)
ffffffffc02015aa:	f0ca                	sd	s2,96(sp)
ffffffffc02015ac:	ecce                	sd	s3,88(sp)
ffffffffc02015ae:	e8d2                	sd	s4,80(sp)
ffffffffc02015b0:	e4d6                	sd	s5,72(sp)
ffffffffc02015b2:	e0da                	sd	s6,64(sp)
ffffffffc02015b4:	fc5e                	sd	s7,56(sp)
ffffffffc02015b6:	f06a                	sd	s10,32(sp)
ffffffffc02015b8:	fc86                	sd	ra,120(sp)
ffffffffc02015ba:	f8a2                	sd	s0,112(sp)
ffffffffc02015bc:	f862                	sd	s8,48(sp)
ffffffffc02015be:	f466                	sd	s9,40(sp)
ffffffffc02015c0:	ec6e                	sd	s11,24(sp)
ffffffffc02015c2:	892a                	mv	s2,a0
ffffffffc02015c4:	84ae                	mv	s1,a1
ffffffffc02015c6:	8d32                	mv	s10,a2
ffffffffc02015c8:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02015ca:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02015ce:	5b7d                	li	s6,-1
ffffffffc02015d0:	00001a97          	auipc	s5,0x1
ffffffffc02015d4:	1e4a8a93          	addi	s5,s5,484 # ffffffffc02027b4 <buddy_pmm_manager+0x1b4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02015d8:	00001b97          	auipc	s7,0x1
ffffffffc02015dc:	3b8b8b93          	addi	s7,s7,952 # ffffffffc0202990 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02015e0:	000d4503          	lbu	a0,0(s10)
ffffffffc02015e4:	001d0413          	addi	s0,s10,1
ffffffffc02015e8:	01350a63          	beq	a0,s3,ffffffffc02015fc <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02015ec:	c121                	beqz	a0,ffffffffc020162c <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02015ee:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02015f0:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02015f2:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02015f4:	fff44503          	lbu	a0,-1(s0)
ffffffffc02015f8:	ff351ae3          	bne	a0,s3,ffffffffc02015ec <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015fc:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0201600:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0201604:	4c81                	li	s9,0
ffffffffc0201606:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0201608:	5c7d                	li	s8,-1
ffffffffc020160a:	5dfd                	li	s11,-1
ffffffffc020160c:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0201610:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201612:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201616:	0ff5f593          	zext.b	a1,a1
ffffffffc020161a:	00140d13          	addi	s10,s0,1
ffffffffc020161e:	04b56263          	bltu	a0,a1,ffffffffc0201662 <vprintfmt+0xbc>
ffffffffc0201622:	058a                	slli	a1,a1,0x2
ffffffffc0201624:	95d6                	add	a1,a1,s5
ffffffffc0201626:	4194                	lw	a3,0(a1)
ffffffffc0201628:	96d6                	add	a3,a3,s5
ffffffffc020162a:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020162c:	70e6                	ld	ra,120(sp)
ffffffffc020162e:	7446                	ld	s0,112(sp)
ffffffffc0201630:	74a6                	ld	s1,104(sp)
ffffffffc0201632:	7906                	ld	s2,96(sp)
ffffffffc0201634:	69e6                	ld	s3,88(sp)
ffffffffc0201636:	6a46                	ld	s4,80(sp)
ffffffffc0201638:	6aa6                	ld	s5,72(sp)
ffffffffc020163a:	6b06                	ld	s6,64(sp)
ffffffffc020163c:	7be2                	ld	s7,56(sp)
ffffffffc020163e:	7c42                	ld	s8,48(sp)
ffffffffc0201640:	7ca2                	ld	s9,40(sp)
ffffffffc0201642:	7d02                	ld	s10,32(sp)
ffffffffc0201644:	6de2                	ld	s11,24(sp)
ffffffffc0201646:	6109                	addi	sp,sp,128
ffffffffc0201648:	8082                	ret
            padc = '0';
ffffffffc020164a:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020164c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201650:	846a                	mv	s0,s10
ffffffffc0201652:	00140d13          	addi	s10,s0,1
ffffffffc0201656:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020165a:	0ff5f593          	zext.b	a1,a1
ffffffffc020165e:	fcb572e3          	bgeu	a0,a1,ffffffffc0201622 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0201662:	85a6                	mv	a1,s1
ffffffffc0201664:	02500513          	li	a0,37
ffffffffc0201668:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020166a:	fff44783          	lbu	a5,-1(s0)
ffffffffc020166e:	8d22                	mv	s10,s0
ffffffffc0201670:	f73788e3          	beq	a5,s3,ffffffffc02015e0 <vprintfmt+0x3a>
ffffffffc0201674:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201678:	1d7d                	addi	s10,s10,-1
ffffffffc020167a:	ff379de3          	bne	a5,s3,ffffffffc0201674 <vprintfmt+0xce>
ffffffffc020167e:	b78d                	j	ffffffffc02015e0 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201680:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201684:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201688:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020168a:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020168e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201692:	02d86463          	bltu	a6,a3,ffffffffc02016ba <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201696:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc020169a:	002c169b          	slliw	a3,s8,0x2
ffffffffc020169e:	0186873b          	addw	a4,a3,s8
ffffffffc02016a2:	0017171b          	slliw	a4,a4,0x1
ffffffffc02016a6:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02016a8:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02016ac:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02016ae:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02016b2:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02016b6:	fed870e3          	bgeu	a6,a3,ffffffffc0201696 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02016ba:	f40ddce3          	bgez	s11,ffffffffc0201612 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02016be:	8de2                	mv	s11,s8
ffffffffc02016c0:	5c7d                	li	s8,-1
ffffffffc02016c2:	bf81                	j	ffffffffc0201612 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02016c4:	fffdc693          	not	a3,s11
ffffffffc02016c8:	96fd                	srai	a3,a3,0x3f
ffffffffc02016ca:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016ce:	00144603          	lbu	a2,1(s0)
ffffffffc02016d2:	2d81                	sext.w	s11,s11
ffffffffc02016d4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02016d6:	bf35                	j	ffffffffc0201612 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02016d8:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016dc:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02016e0:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016e2:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02016e4:	bfd9                	j	ffffffffc02016ba <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02016e6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02016e8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02016ec:	01174463          	blt	a4,a7,ffffffffc02016f4 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02016f0:	1a088e63          	beqz	a7,ffffffffc02018ac <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02016f4:	000a3603          	ld	a2,0(s4)
ffffffffc02016f8:	46c1                	li	a3,16
ffffffffc02016fa:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02016fc:	2781                	sext.w	a5,a5
ffffffffc02016fe:	876e                	mv	a4,s11
ffffffffc0201700:	85a6                	mv	a1,s1
ffffffffc0201702:	854a                	mv	a0,s2
ffffffffc0201704:	e37ff0ef          	jal	ra,ffffffffc020153a <printnum>
            break;
ffffffffc0201708:	bde1                	j	ffffffffc02015e0 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc020170a:	000a2503          	lw	a0,0(s4)
ffffffffc020170e:	85a6                	mv	a1,s1
ffffffffc0201710:	0a21                	addi	s4,s4,8
ffffffffc0201712:	9902                	jalr	s2
            break;
ffffffffc0201714:	b5f1                	j	ffffffffc02015e0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201716:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201718:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020171c:	01174463          	blt	a4,a7,ffffffffc0201724 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201720:	18088163          	beqz	a7,ffffffffc02018a2 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201724:	000a3603          	ld	a2,0(s4)
ffffffffc0201728:	46a9                	li	a3,10
ffffffffc020172a:	8a2e                	mv	s4,a1
ffffffffc020172c:	bfc1                	j	ffffffffc02016fc <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020172e:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201732:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201734:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201736:	bdf1                	j	ffffffffc0201612 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201738:	85a6                	mv	a1,s1
ffffffffc020173a:	02500513          	li	a0,37
ffffffffc020173e:	9902                	jalr	s2
            break;
ffffffffc0201740:	b545                	j	ffffffffc02015e0 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201742:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201746:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201748:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020174a:	b5e1                	j	ffffffffc0201612 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020174c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020174e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201752:	01174463          	blt	a4,a7,ffffffffc020175a <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201756:	14088163          	beqz	a7,ffffffffc0201898 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020175a:	000a3603          	ld	a2,0(s4)
ffffffffc020175e:	46a1                	li	a3,8
ffffffffc0201760:	8a2e                	mv	s4,a1
ffffffffc0201762:	bf69                	j	ffffffffc02016fc <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201764:	03000513          	li	a0,48
ffffffffc0201768:	85a6                	mv	a1,s1
ffffffffc020176a:	e03e                	sd	a5,0(sp)
ffffffffc020176c:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020176e:	85a6                	mv	a1,s1
ffffffffc0201770:	07800513          	li	a0,120
ffffffffc0201774:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201776:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201778:	6782                	ld	a5,0(sp)
ffffffffc020177a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020177c:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201780:	bfb5                	j	ffffffffc02016fc <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201782:	000a3403          	ld	s0,0(s4)
ffffffffc0201786:	008a0713          	addi	a4,s4,8
ffffffffc020178a:	e03a                	sd	a4,0(sp)
ffffffffc020178c:	14040263          	beqz	s0,ffffffffc02018d0 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201790:	0fb05763          	blez	s11,ffffffffc020187e <vprintfmt+0x2d8>
ffffffffc0201794:	02d00693          	li	a3,45
ffffffffc0201798:	0cd79163          	bne	a5,a3,ffffffffc020185a <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020179c:	00044783          	lbu	a5,0(s0)
ffffffffc02017a0:	0007851b          	sext.w	a0,a5
ffffffffc02017a4:	cf85                	beqz	a5,ffffffffc02017dc <vprintfmt+0x236>
ffffffffc02017a6:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02017aa:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02017ae:	000c4563          	bltz	s8,ffffffffc02017b8 <vprintfmt+0x212>
ffffffffc02017b2:	3c7d                	addiw	s8,s8,-1
ffffffffc02017b4:	036c0263          	beq	s8,s6,ffffffffc02017d8 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02017b8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02017ba:	0e0c8e63          	beqz	s9,ffffffffc02018b6 <vprintfmt+0x310>
ffffffffc02017be:	3781                	addiw	a5,a5,-32
ffffffffc02017c0:	0ef47b63          	bgeu	s0,a5,ffffffffc02018b6 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02017c4:	03f00513          	li	a0,63
ffffffffc02017c8:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02017ca:	000a4783          	lbu	a5,0(s4)
ffffffffc02017ce:	3dfd                	addiw	s11,s11,-1
ffffffffc02017d0:	0a05                	addi	s4,s4,1
ffffffffc02017d2:	0007851b          	sext.w	a0,a5
ffffffffc02017d6:	ffe1                	bnez	a5,ffffffffc02017ae <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02017d8:	01b05963          	blez	s11,ffffffffc02017ea <vprintfmt+0x244>
ffffffffc02017dc:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02017de:	85a6                	mv	a1,s1
ffffffffc02017e0:	02000513          	li	a0,32
ffffffffc02017e4:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02017e6:	fe0d9be3          	bnez	s11,ffffffffc02017dc <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02017ea:	6a02                	ld	s4,0(sp)
ffffffffc02017ec:	bbd5                	j	ffffffffc02015e0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02017ee:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02017f0:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02017f4:	01174463          	blt	a4,a7,ffffffffc02017fc <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02017f8:	08088d63          	beqz	a7,ffffffffc0201892 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02017fc:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201800:	0a044d63          	bltz	s0,ffffffffc02018ba <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201804:	8622                	mv	a2,s0
ffffffffc0201806:	8a66                	mv	s4,s9
ffffffffc0201808:	46a9                	li	a3,10
ffffffffc020180a:	bdcd                	j	ffffffffc02016fc <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc020180c:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201810:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201812:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201814:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201818:	8fb5                	xor	a5,a5,a3
ffffffffc020181a:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020181e:	02d74163          	blt	a4,a3,ffffffffc0201840 <vprintfmt+0x29a>
ffffffffc0201822:	00369793          	slli	a5,a3,0x3
ffffffffc0201826:	97de                	add	a5,a5,s7
ffffffffc0201828:	639c                	ld	a5,0(a5)
ffffffffc020182a:	cb99                	beqz	a5,ffffffffc0201840 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020182c:	86be                	mv	a3,a5
ffffffffc020182e:	00001617          	auipc	a2,0x1
ffffffffc0201832:	f8260613          	addi	a2,a2,-126 # ffffffffc02027b0 <buddy_pmm_manager+0x1b0>
ffffffffc0201836:	85a6                	mv	a1,s1
ffffffffc0201838:	854a                	mv	a0,s2
ffffffffc020183a:	0ce000ef          	jal	ra,ffffffffc0201908 <printfmt>
ffffffffc020183e:	b34d                	j	ffffffffc02015e0 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201840:	00001617          	auipc	a2,0x1
ffffffffc0201844:	f6060613          	addi	a2,a2,-160 # ffffffffc02027a0 <buddy_pmm_manager+0x1a0>
ffffffffc0201848:	85a6                	mv	a1,s1
ffffffffc020184a:	854a                	mv	a0,s2
ffffffffc020184c:	0bc000ef          	jal	ra,ffffffffc0201908 <printfmt>
ffffffffc0201850:	bb41                	j	ffffffffc02015e0 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201852:	00001417          	auipc	s0,0x1
ffffffffc0201856:	f4640413          	addi	s0,s0,-186 # ffffffffc0202798 <buddy_pmm_manager+0x198>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020185a:	85e2                	mv	a1,s8
ffffffffc020185c:	8522                	mv	a0,s0
ffffffffc020185e:	e43e                	sd	a5,8(sp)
ffffffffc0201860:	0fc000ef          	jal	ra,ffffffffc020195c <strnlen>
ffffffffc0201864:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201868:	01b05b63          	blez	s11,ffffffffc020187e <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020186c:	67a2                	ld	a5,8(sp)
ffffffffc020186e:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201872:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201874:	85a6                	mv	a1,s1
ffffffffc0201876:	8552                	mv	a0,s4
ffffffffc0201878:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020187a:	fe0d9ce3          	bnez	s11,ffffffffc0201872 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020187e:	00044783          	lbu	a5,0(s0)
ffffffffc0201882:	00140a13          	addi	s4,s0,1
ffffffffc0201886:	0007851b          	sext.w	a0,a5
ffffffffc020188a:	d3a5                	beqz	a5,ffffffffc02017ea <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020188c:	05e00413          	li	s0,94
ffffffffc0201890:	bf39                	j	ffffffffc02017ae <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0201892:	000a2403          	lw	s0,0(s4)
ffffffffc0201896:	b7ad                	j	ffffffffc0201800 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201898:	000a6603          	lwu	a2,0(s4)
ffffffffc020189c:	46a1                	li	a3,8
ffffffffc020189e:	8a2e                	mv	s4,a1
ffffffffc02018a0:	bdb1                	j	ffffffffc02016fc <vprintfmt+0x156>
ffffffffc02018a2:	000a6603          	lwu	a2,0(s4)
ffffffffc02018a6:	46a9                	li	a3,10
ffffffffc02018a8:	8a2e                	mv	s4,a1
ffffffffc02018aa:	bd89                	j	ffffffffc02016fc <vprintfmt+0x156>
ffffffffc02018ac:	000a6603          	lwu	a2,0(s4)
ffffffffc02018b0:	46c1                	li	a3,16
ffffffffc02018b2:	8a2e                	mv	s4,a1
ffffffffc02018b4:	b5a1                	j	ffffffffc02016fc <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02018b6:	9902                	jalr	s2
ffffffffc02018b8:	bf09                	j	ffffffffc02017ca <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02018ba:	85a6                	mv	a1,s1
ffffffffc02018bc:	02d00513          	li	a0,45
ffffffffc02018c0:	e03e                	sd	a5,0(sp)
ffffffffc02018c2:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02018c4:	6782                	ld	a5,0(sp)
ffffffffc02018c6:	8a66                	mv	s4,s9
ffffffffc02018c8:	40800633          	neg	a2,s0
ffffffffc02018cc:	46a9                	li	a3,10
ffffffffc02018ce:	b53d                	j	ffffffffc02016fc <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02018d0:	03b05163          	blez	s11,ffffffffc02018f2 <vprintfmt+0x34c>
ffffffffc02018d4:	02d00693          	li	a3,45
ffffffffc02018d8:	f6d79de3          	bne	a5,a3,ffffffffc0201852 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02018dc:	00001417          	auipc	s0,0x1
ffffffffc02018e0:	ebc40413          	addi	s0,s0,-324 # ffffffffc0202798 <buddy_pmm_manager+0x198>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02018e4:	02800793          	li	a5,40
ffffffffc02018e8:	02800513          	li	a0,40
ffffffffc02018ec:	00140a13          	addi	s4,s0,1
ffffffffc02018f0:	bd6d                	j	ffffffffc02017aa <vprintfmt+0x204>
ffffffffc02018f2:	00001a17          	auipc	s4,0x1
ffffffffc02018f6:	ea7a0a13          	addi	s4,s4,-345 # ffffffffc0202799 <buddy_pmm_manager+0x199>
ffffffffc02018fa:	02800513          	li	a0,40
ffffffffc02018fe:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201902:	05e00413          	li	s0,94
ffffffffc0201906:	b565                	j	ffffffffc02017ae <vprintfmt+0x208>

ffffffffc0201908 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201908:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020190a:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020190e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201910:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201912:	ec06                	sd	ra,24(sp)
ffffffffc0201914:	f83a                	sd	a4,48(sp)
ffffffffc0201916:	fc3e                	sd	a5,56(sp)
ffffffffc0201918:	e0c2                	sd	a6,64(sp)
ffffffffc020191a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020191c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020191e:	c89ff0ef          	jal	ra,ffffffffc02015a6 <vprintfmt>
}
ffffffffc0201922:	60e2                	ld	ra,24(sp)
ffffffffc0201924:	6161                	addi	sp,sp,80
ffffffffc0201926:	8082                	ret

ffffffffc0201928 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201928:	4781                	li	a5,0
ffffffffc020192a:	00004717          	auipc	a4,0x4
ffffffffc020192e:	6e673703          	ld	a4,1766(a4) # ffffffffc0206010 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201932:	88ba                	mv	a7,a4
ffffffffc0201934:	852a                	mv	a0,a0
ffffffffc0201936:	85be                	mv	a1,a5
ffffffffc0201938:	863e                	mv	a2,a5
ffffffffc020193a:	00000073          	ecall
ffffffffc020193e:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201940:	8082                	ret

ffffffffc0201942 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201942:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201946:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201948:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020194a:	cb81                	beqz	a5,ffffffffc020195a <strlen+0x18>
        cnt ++;
ffffffffc020194c:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020194e:	00a707b3          	add	a5,a4,a0
ffffffffc0201952:	0007c783          	lbu	a5,0(a5)
ffffffffc0201956:	fbfd                	bnez	a5,ffffffffc020194c <strlen+0xa>
ffffffffc0201958:	8082                	ret
    }
    return cnt;
}
ffffffffc020195a:	8082                	ret

ffffffffc020195c <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc020195c:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020195e:	e589                	bnez	a1,ffffffffc0201968 <strnlen+0xc>
ffffffffc0201960:	a811                	j	ffffffffc0201974 <strnlen+0x18>
        cnt ++;
ffffffffc0201962:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201964:	00f58863          	beq	a1,a5,ffffffffc0201974 <strnlen+0x18>
ffffffffc0201968:	00f50733          	add	a4,a0,a5
ffffffffc020196c:	00074703          	lbu	a4,0(a4)
ffffffffc0201970:	fb6d                	bnez	a4,ffffffffc0201962 <strnlen+0x6>
ffffffffc0201972:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201974:	852e                	mv	a0,a1
ffffffffc0201976:	8082                	ret

ffffffffc0201978 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201978:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020197c:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201980:	cb89                	beqz	a5,ffffffffc0201992 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0201982:	0505                	addi	a0,a0,1
ffffffffc0201984:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201986:	fee789e3          	beq	a5,a4,ffffffffc0201978 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020198a:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020198e:	9d19                	subw	a0,a0,a4
ffffffffc0201990:	8082                	ret
ffffffffc0201992:	4501                	li	a0,0
ffffffffc0201994:	bfed                	j	ffffffffc020198e <strcmp+0x16>

ffffffffc0201996 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201996:	c20d                	beqz	a2,ffffffffc02019b8 <strncmp+0x22>
ffffffffc0201998:	962e                	add	a2,a2,a1
ffffffffc020199a:	a031                	j	ffffffffc02019a6 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc020199c:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020199e:	00e79a63          	bne	a5,a4,ffffffffc02019b2 <strncmp+0x1c>
ffffffffc02019a2:	00b60b63          	beq	a2,a1,ffffffffc02019b8 <strncmp+0x22>
ffffffffc02019a6:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02019aa:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02019ac:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02019b0:	f7f5                	bnez	a5,ffffffffc020199c <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02019b2:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02019b6:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02019b8:	4501                	li	a0,0
ffffffffc02019ba:	8082                	ret

ffffffffc02019bc <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02019bc:	ca01                	beqz	a2,ffffffffc02019cc <memset+0x10>
ffffffffc02019be:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02019c0:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02019c2:	0785                	addi	a5,a5,1
ffffffffc02019c4:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02019c8:	fec79de3          	bne	a5,a2,ffffffffc02019c2 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02019cc:	8082                	ret
