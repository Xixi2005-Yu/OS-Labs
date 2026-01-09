
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000c297          	auipc	t0,0xc
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020c000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000c297          	auipc	t0,0xc
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020c008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020b2b7          	lui	t0,0xc020b
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
ffffffffc020003c:	c020b137          	lui	sp,0xc020b

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000c2517          	auipc	a0,0xc2
ffffffffc020004e:	6e650513          	addi	a0,a0,1766 # ffffffffc02c2730 <buf>
ffffffffc0200052:	000c7617          	auipc	a2,0xc7
ffffffffc0200056:	bbe60613          	addi	a2,a2,-1090 # ffffffffc02c6c10 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	373050ef          	jal	ra,ffffffffc0205bd4 <memset>
    cons_init(); // init the console
ffffffffc0200066:	520000ef          	jal	ra,ffffffffc0200586 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00006597          	auipc	a1,0x6
ffffffffc020006e:	b9658593          	addi	a1,a1,-1130 # ffffffffc0205c00 <etext+0x2>
ffffffffc0200072:	00006517          	auipc	a0,0x6
ffffffffc0200076:	bae50513          	addi	a0,a0,-1106 # ffffffffc0205c20 <etext+0x22>
ffffffffc020007a:	11e000ef          	jal	ra,ffffffffc0200198 <cprintf>

    print_kerninfo();
ffffffffc020007e:	1a2000ef          	jal	ra,ffffffffc0200220 <print_kerninfo>

    // grade_backtrace();

    dtb_init(); // init dtb
ffffffffc0200082:	576000ef          	jal	ra,ffffffffc02005f8 <dtb_init>

    pmm_init(); // init physical memory management
ffffffffc0200086:	5a0020ef          	jal	ra,ffffffffc0202626 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	12b000ef          	jal	ra,ffffffffc02009b4 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	129000ef          	jal	ra,ffffffffc02009b6 <idt_init>

    vmm_init(); // init virtual memory management
ffffffffc0200092:	06d030ef          	jal	ra,ffffffffc02038fe <vmm_init>
    sched_init();
ffffffffc0200096:	3d4050ef          	jal	ra,ffffffffc020546a <sched_init>
    proc_init(); // init process table
ffffffffc020009a:	45f040ef          	jal	ra,ffffffffc0204cf8 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009e:	4a0000ef          	jal	ra,ffffffffc020053e <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc02000a2:	107000ef          	jal	ra,ffffffffc02009a8 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a6:	5eb040ef          	jal	ra,ffffffffc0204e90 <cpu_idle>

ffffffffc02000aa <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000aa:	715d                	addi	sp,sp,-80
ffffffffc02000ac:	e486                	sd	ra,72(sp)
ffffffffc02000ae:	e0a6                	sd	s1,64(sp)
ffffffffc02000b0:	fc4a                	sd	s2,56(sp)
ffffffffc02000b2:	f84e                	sd	s3,48(sp)
ffffffffc02000b4:	f452                	sd	s4,40(sp)
ffffffffc02000b6:	f056                	sd	s5,32(sp)
ffffffffc02000b8:	ec5a                	sd	s6,24(sp)
ffffffffc02000ba:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000bc:	c901                	beqz	a0,ffffffffc02000cc <readline+0x22>
ffffffffc02000be:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000c0:	00006517          	auipc	a0,0x6
ffffffffc02000c4:	b6850513          	addi	a0,a0,-1176 # ffffffffc0205c28 <etext+0x2a>
ffffffffc02000c8:	0d0000ef          	jal	ra,ffffffffc0200198 <cprintf>
readline(const char *prompt) {
ffffffffc02000cc:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ce:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d0:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000d2:	4aa9                	li	s5,10
ffffffffc02000d4:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d6:	000c2b97          	auipc	s7,0xc2
ffffffffc02000da:	65ab8b93          	addi	s7,s7,1626 # ffffffffc02c2730 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000de:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000e2:	12e000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc02000e6:	00054a63          	bltz	a0,ffffffffc02000fa <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ea:	00a95a63          	bge	s2,a0,ffffffffc02000fe <readline+0x54>
ffffffffc02000ee:	029a5263          	bge	s4,s1,ffffffffc0200112 <readline+0x68>
        c = getchar();
ffffffffc02000f2:	11e000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc02000f6:	fe055ae3          	bgez	a0,ffffffffc02000ea <readline+0x40>
            return NULL;
ffffffffc02000fa:	4501                	li	a0,0
ffffffffc02000fc:	a091                	j	ffffffffc0200140 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fe:	03351463          	bne	a0,s3,ffffffffc0200126 <readline+0x7c>
ffffffffc0200102:	e8a9                	bnez	s1,ffffffffc0200154 <readline+0xaa>
        c = getchar();
ffffffffc0200104:	10c000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc0200108:	fe0549e3          	bltz	a0,ffffffffc02000fa <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020010c:	fea959e3          	bge	s2,a0,ffffffffc02000fe <readline+0x54>
ffffffffc0200110:	4481                	li	s1,0
            cputchar(c);
ffffffffc0200112:	e42a                	sd	a0,8(sp)
ffffffffc0200114:	0ba000ef          	jal	ra,ffffffffc02001ce <cputchar>
            buf[i ++] = c;
ffffffffc0200118:	6522                	ld	a0,8(sp)
ffffffffc020011a:	009b87b3          	add	a5,s7,s1
ffffffffc020011e:	2485                	addiw	s1,s1,1
ffffffffc0200120:	00a78023          	sb	a0,0(a5)
ffffffffc0200124:	bf7d                	j	ffffffffc02000e2 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200126:	01550463          	beq	a0,s5,ffffffffc020012e <readline+0x84>
ffffffffc020012a:	fb651ce3          	bne	a0,s6,ffffffffc02000e2 <readline+0x38>
            cputchar(c);
ffffffffc020012e:	0a0000ef          	jal	ra,ffffffffc02001ce <cputchar>
            buf[i] = '\0';
ffffffffc0200132:	000c2517          	auipc	a0,0xc2
ffffffffc0200136:	5fe50513          	addi	a0,a0,1534 # ffffffffc02c2730 <buf>
ffffffffc020013a:	94aa                	add	s1,s1,a0
ffffffffc020013c:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200140:	60a6                	ld	ra,72(sp)
ffffffffc0200142:	6486                	ld	s1,64(sp)
ffffffffc0200144:	7962                	ld	s2,56(sp)
ffffffffc0200146:	79c2                	ld	s3,48(sp)
ffffffffc0200148:	7a22                	ld	s4,40(sp)
ffffffffc020014a:	7a82                	ld	s5,32(sp)
ffffffffc020014c:	6b62                	ld	s6,24(sp)
ffffffffc020014e:	6bc2                	ld	s7,16(sp)
ffffffffc0200150:	6161                	addi	sp,sp,80
ffffffffc0200152:	8082                	ret
            cputchar(c);
ffffffffc0200154:	4521                	li	a0,8
ffffffffc0200156:	078000ef          	jal	ra,ffffffffc02001ce <cputchar>
            i --;
ffffffffc020015a:	34fd                	addiw	s1,s1,-1
ffffffffc020015c:	b759                	j	ffffffffc02000e2 <readline+0x38>

ffffffffc020015e <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015e:	1141                	addi	sp,sp,-16
ffffffffc0200160:	e022                	sd	s0,0(sp)
ffffffffc0200162:	e406                	sd	ra,8(sp)
ffffffffc0200164:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200166:	422000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    (*cnt)++;
ffffffffc020016a:	401c                	lw	a5,0(s0)
}
ffffffffc020016c:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016e:	2785                	addiw	a5,a5,1
ffffffffc0200170:	c01c                	sw	a5,0(s0)
}
ffffffffc0200172:	6402                	ld	s0,0(sp)
ffffffffc0200174:	0141                	addi	sp,sp,16
ffffffffc0200176:	8082                	ret

ffffffffc0200178 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200178:	1101                	addi	sp,sp,-32
ffffffffc020017a:	862a                	mv	a2,a0
ffffffffc020017c:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017e:	00000517          	auipc	a0,0x0
ffffffffc0200182:	fe050513          	addi	a0,a0,-32 # ffffffffc020015e <cputch>
ffffffffc0200186:	006c                	addi	a1,sp,12
{
ffffffffc0200188:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020018a:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020018c:	624050ef          	jal	ra,ffffffffc02057b0 <vprintfmt>
    return cnt;
}
ffffffffc0200190:	60e2                	ld	ra,24(sp)
ffffffffc0200192:	4532                	lw	a0,12(sp)
ffffffffc0200194:	6105                	addi	sp,sp,32
ffffffffc0200196:	8082                	ret

ffffffffc0200198 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200198:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020019a:	02810313          	addi	t1,sp,40 # ffffffffc020b028 <boot_page_table_sv39+0x28>
{
ffffffffc020019e:	8e2a                	mv	t3,a0
ffffffffc02001a0:	f42e                	sd	a1,40(sp)
ffffffffc02001a2:	f832                	sd	a2,48(sp)
ffffffffc02001a4:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a6:	00000517          	auipc	a0,0x0
ffffffffc02001aa:	fb850513          	addi	a0,a0,-72 # ffffffffc020015e <cputch>
ffffffffc02001ae:	004c                	addi	a1,sp,4
ffffffffc02001b0:	869a                	mv	a3,t1
ffffffffc02001b2:	8672                	mv	a2,t3
{
ffffffffc02001b4:	ec06                	sd	ra,24(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	e4be                	sd	a5,72(sp)
ffffffffc02001ba:	e8c2                	sd	a6,80(sp)
ffffffffc02001bc:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001be:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001c0:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001c2:	5ee050ef          	jal	ra,ffffffffc02057b0 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c6:	60e2                	ld	ra,24(sp)
ffffffffc02001c8:	4512                	lw	a0,4(sp)
ffffffffc02001ca:	6125                	addi	sp,sp,96
ffffffffc02001cc:	8082                	ret

ffffffffc02001ce <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ce:	ae6d                	j	ffffffffc0200588 <cons_putc>

ffffffffc02001d0 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001d0:	1101                	addi	sp,sp,-32
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	ec06                	sd	ra,24(sp)
ffffffffc02001d6:	e426                	sd	s1,8(sp)
ffffffffc02001d8:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001da:	00054503          	lbu	a0,0(a0)
ffffffffc02001de:	c51d                	beqz	a0,ffffffffc020020c <cputs+0x3c>
ffffffffc02001e0:	0405                	addi	s0,s0,1
ffffffffc02001e2:	4485                	li	s1,1
ffffffffc02001e4:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e6:	3a2000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001ea:	00044503          	lbu	a0,0(s0)
ffffffffc02001ee:	008487bb          	addw	a5,s1,s0
ffffffffc02001f2:	0405                	addi	s0,s0,1
ffffffffc02001f4:	f96d                	bnez	a0,ffffffffc02001e6 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f6:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001fa:	4529                	li	a0,10
ffffffffc02001fc:	38c000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200200:	60e2                	ld	ra,24(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	6442                	ld	s0,16(sp)
ffffffffc0200206:	64a2                	ld	s1,8(sp)
ffffffffc0200208:	6105                	addi	sp,sp,32
ffffffffc020020a:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc020020c:	4405                	li	s0,1
ffffffffc020020e:	b7f5                	j	ffffffffc02001fa <cputs+0x2a>

ffffffffc0200210 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200210:	1141                	addi	sp,sp,-16
ffffffffc0200212:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200214:	3a8000ef          	jal	ra,ffffffffc02005bc <cons_getc>
ffffffffc0200218:	dd75                	beqz	a0,ffffffffc0200214 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc020021a:	60a2                	ld	ra,8(sp)
ffffffffc020021c:	0141                	addi	sp,sp,16
ffffffffc020021e:	8082                	ret

ffffffffc0200220 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200220:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200222:	00006517          	auipc	a0,0x6
ffffffffc0200226:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0205c30 <etext+0x32>
void print_kerninfo(void) {
ffffffffc020022a:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020022c:	f6dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200230:	00000597          	auipc	a1,0x0
ffffffffc0200234:	e1a58593          	addi	a1,a1,-486 # ffffffffc020004a <kern_init>
ffffffffc0200238:	00006517          	auipc	a0,0x6
ffffffffc020023c:	a1850513          	addi	a0,a0,-1512 # ffffffffc0205c50 <etext+0x52>
ffffffffc0200240:	f59ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200244:	00006597          	auipc	a1,0x6
ffffffffc0200248:	9ba58593          	addi	a1,a1,-1606 # ffffffffc0205bfe <etext>
ffffffffc020024c:	00006517          	auipc	a0,0x6
ffffffffc0200250:	a2450513          	addi	a0,a0,-1500 # ffffffffc0205c70 <etext+0x72>
ffffffffc0200254:	f45ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200258:	000c2597          	auipc	a1,0xc2
ffffffffc020025c:	4d858593          	addi	a1,a1,1240 # ffffffffc02c2730 <buf>
ffffffffc0200260:	00006517          	auipc	a0,0x6
ffffffffc0200264:	a3050513          	addi	a0,a0,-1488 # ffffffffc0205c90 <etext+0x92>
ffffffffc0200268:	f31ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc020026c:	000c7597          	auipc	a1,0xc7
ffffffffc0200270:	9a458593          	addi	a1,a1,-1628 # ffffffffc02c6c10 <end>
ffffffffc0200274:	00006517          	auipc	a0,0x6
ffffffffc0200278:	a3c50513          	addi	a0,a0,-1476 # ffffffffc0205cb0 <etext+0xb2>
ffffffffc020027c:	f1dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200280:	000c7597          	auipc	a1,0xc7
ffffffffc0200284:	d8f58593          	addi	a1,a1,-625 # ffffffffc02c700f <end+0x3ff>
ffffffffc0200288:	00000797          	auipc	a5,0x0
ffffffffc020028c:	dc278793          	addi	a5,a5,-574 # ffffffffc020004a <kern_init>
ffffffffc0200290:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200294:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200298:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029a:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029e:	95be                	add	a1,a1,a5
ffffffffc02002a0:	85a9                	srai	a1,a1,0xa
ffffffffc02002a2:	00006517          	auipc	a0,0x6
ffffffffc02002a6:	a2e50513          	addi	a0,a0,-1490 # ffffffffc0205cd0 <etext+0xd2>
}
ffffffffc02002aa:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002ac:	b5f5                	j	ffffffffc0200198 <cprintf>

ffffffffc02002ae <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02002ae:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b0:	00006617          	auipc	a2,0x6
ffffffffc02002b4:	a5060613          	addi	a2,a2,-1456 # ffffffffc0205d00 <etext+0x102>
ffffffffc02002b8:	04d00593          	li	a1,77
ffffffffc02002bc:	00006517          	auipc	a0,0x6
ffffffffc02002c0:	a5c50513          	addi	a0,a0,-1444 # ffffffffc0205d18 <etext+0x11a>
void print_stackframe(void) {
ffffffffc02002c4:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c6:	1cc000ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02002ca <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002ca:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002cc:	00006617          	auipc	a2,0x6
ffffffffc02002d0:	a6460613          	addi	a2,a2,-1436 # ffffffffc0205d30 <etext+0x132>
ffffffffc02002d4:	00006597          	auipc	a1,0x6
ffffffffc02002d8:	a7c58593          	addi	a1,a1,-1412 # ffffffffc0205d50 <etext+0x152>
ffffffffc02002dc:	00006517          	auipc	a0,0x6
ffffffffc02002e0:	a7c50513          	addi	a0,a0,-1412 # ffffffffc0205d58 <etext+0x15a>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e4:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	eb3ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc02002ea:	00006617          	auipc	a2,0x6
ffffffffc02002ee:	a7e60613          	addi	a2,a2,-1410 # ffffffffc0205d68 <etext+0x16a>
ffffffffc02002f2:	00006597          	auipc	a1,0x6
ffffffffc02002f6:	a9e58593          	addi	a1,a1,-1378 # ffffffffc0205d90 <etext+0x192>
ffffffffc02002fa:	00006517          	auipc	a0,0x6
ffffffffc02002fe:	a5e50513          	addi	a0,a0,-1442 # ffffffffc0205d58 <etext+0x15a>
ffffffffc0200302:	e97ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0200306:	00006617          	auipc	a2,0x6
ffffffffc020030a:	a9a60613          	addi	a2,a2,-1382 # ffffffffc0205da0 <etext+0x1a2>
ffffffffc020030e:	00006597          	auipc	a1,0x6
ffffffffc0200312:	ab258593          	addi	a1,a1,-1358 # ffffffffc0205dc0 <etext+0x1c2>
ffffffffc0200316:	00006517          	auipc	a0,0x6
ffffffffc020031a:	a4250513          	addi	a0,a0,-1470 # ffffffffc0205d58 <etext+0x15a>
ffffffffc020031e:	e7bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    }
    return 0;
}
ffffffffc0200322:	60a2                	ld	ra,8(sp)
ffffffffc0200324:	4501                	li	a0,0
ffffffffc0200326:	0141                	addi	sp,sp,16
ffffffffc0200328:	8082                	ret

ffffffffc020032a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020032a:	1141                	addi	sp,sp,-16
ffffffffc020032c:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032e:	ef3ff0ef          	jal	ra,ffffffffc0200220 <print_kerninfo>
    return 0;
}
ffffffffc0200332:	60a2                	ld	ra,8(sp)
ffffffffc0200334:	4501                	li	a0,0
ffffffffc0200336:	0141                	addi	sp,sp,16
ffffffffc0200338:	8082                	ret

ffffffffc020033a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020033a:	1141                	addi	sp,sp,-16
ffffffffc020033c:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033e:	f71ff0ef          	jal	ra,ffffffffc02002ae <print_stackframe>
    return 0;
}
ffffffffc0200342:	60a2                	ld	ra,8(sp)
ffffffffc0200344:	4501                	li	a0,0
ffffffffc0200346:	0141                	addi	sp,sp,16
ffffffffc0200348:	8082                	ret

ffffffffc020034a <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020034a:	7115                	addi	sp,sp,-224
ffffffffc020034c:	ed5e                	sd	s7,152(sp)
ffffffffc020034e:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200350:	00006517          	auipc	a0,0x6
ffffffffc0200354:	a8050513          	addi	a0,a0,-1408 # ffffffffc0205dd0 <etext+0x1d2>
kmonitor(struct trapframe *tf) {
ffffffffc0200358:	ed86                	sd	ra,216(sp)
ffffffffc020035a:	e9a2                	sd	s0,208(sp)
ffffffffc020035c:	e5a6                	sd	s1,200(sp)
ffffffffc020035e:	e1ca                	sd	s2,192(sp)
ffffffffc0200360:	fd4e                	sd	s3,184(sp)
ffffffffc0200362:	f952                	sd	s4,176(sp)
ffffffffc0200364:	f556                	sd	s5,168(sp)
ffffffffc0200366:	f15a                	sd	s6,160(sp)
ffffffffc0200368:	e962                	sd	s8,144(sp)
ffffffffc020036a:	e566                	sd	s9,136(sp)
ffffffffc020036c:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036e:	e2bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200372:	00006517          	auipc	a0,0x6
ffffffffc0200376:	a8650513          	addi	a0,a0,-1402 # ffffffffc0205df8 <etext+0x1fa>
ffffffffc020037a:	e1fff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    if (tf != NULL) {
ffffffffc020037e:	000b8563          	beqz	s7,ffffffffc0200388 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200382:	855e                	mv	a0,s7
ffffffffc0200384:	01b000ef          	jal	ra,ffffffffc0200b9e <print_trapframe>
ffffffffc0200388:	00006c17          	auipc	s8,0x6
ffffffffc020038c:	ae0c0c13          	addi	s8,s8,-1312 # ffffffffc0205e68 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200390:	00006917          	auipc	s2,0x6
ffffffffc0200394:	a9090913          	addi	s2,s2,-1392 # ffffffffc0205e20 <etext+0x222>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200398:	00006497          	auipc	s1,0x6
ffffffffc020039c:	a9048493          	addi	s1,s1,-1392 # ffffffffc0205e28 <etext+0x22a>
        if (argc == MAXARGS - 1) {
ffffffffc02003a0:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003a2:	00006b17          	auipc	s6,0x6
ffffffffc02003a6:	a8eb0b13          	addi	s6,s6,-1394 # ffffffffc0205e30 <etext+0x232>
        argv[argc ++] = buf;
ffffffffc02003aa:	00006a17          	auipc	s4,0x6
ffffffffc02003ae:	9a6a0a13          	addi	s4,s4,-1626 # ffffffffc0205d50 <etext+0x152>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003b2:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003b4:	854a                	mv	a0,s2
ffffffffc02003b6:	cf5ff0ef          	jal	ra,ffffffffc02000aa <readline>
ffffffffc02003ba:	842a                	mv	s0,a0
ffffffffc02003bc:	dd65                	beqz	a0,ffffffffc02003b4 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003be:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003c2:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003c4:	e1bd                	bnez	a1,ffffffffc020042a <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc02003c6:	fe0c87e3          	beqz	s9,ffffffffc02003b4 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ca:	6582                	ld	a1,0(sp)
ffffffffc02003cc:	00006d17          	auipc	s10,0x6
ffffffffc02003d0:	a9cd0d13          	addi	s10,s10,-1380 # ffffffffc0205e68 <commands>
        argv[argc ++] = buf;
ffffffffc02003d4:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d6:	4401                	li	s0,0
ffffffffc02003d8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003da:	7a0050ef          	jal	ra,ffffffffc0205b7a <strcmp>
ffffffffc02003de:	c919                	beqz	a0,ffffffffc02003f4 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003e0:	2405                	addiw	s0,s0,1
ffffffffc02003e2:	0b540063          	beq	s0,s5,ffffffffc0200482 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003e6:	000d3503          	ld	a0,0(s10)
ffffffffc02003ea:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003ec:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ee:	78c050ef          	jal	ra,ffffffffc0205b7a <strcmp>
ffffffffc02003f2:	f57d                	bnez	a0,ffffffffc02003e0 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f4:	00141793          	slli	a5,s0,0x1
ffffffffc02003f8:	97a2                	add	a5,a5,s0
ffffffffc02003fa:	078e                	slli	a5,a5,0x3
ffffffffc02003fc:	97e2                	add	a5,a5,s8
ffffffffc02003fe:	6b9c                	ld	a5,16(a5)
ffffffffc0200400:	865e                	mv	a2,s7
ffffffffc0200402:	002c                	addi	a1,sp,8
ffffffffc0200404:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200408:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc020040a:	fa0555e3          	bgez	a0,ffffffffc02003b4 <kmonitor+0x6a>
}
ffffffffc020040e:	60ee                	ld	ra,216(sp)
ffffffffc0200410:	644e                	ld	s0,208(sp)
ffffffffc0200412:	64ae                	ld	s1,200(sp)
ffffffffc0200414:	690e                	ld	s2,192(sp)
ffffffffc0200416:	79ea                	ld	s3,184(sp)
ffffffffc0200418:	7a4a                	ld	s4,176(sp)
ffffffffc020041a:	7aaa                	ld	s5,168(sp)
ffffffffc020041c:	7b0a                	ld	s6,160(sp)
ffffffffc020041e:	6bea                	ld	s7,152(sp)
ffffffffc0200420:	6c4a                	ld	s8,144(sp)
ffffffffc0200422:	6caa                	ld	s9,136(sp)
ffffffffc0200424:	6d0a                	ld	s10,128(sp)
ffffffffc0200426:	612d                	addi	sp,sp,224
ffffffffc0200428:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020042a:	8526                	mv	a0,s1
ffffffffc020042c:	792050ef          	jal	ra,ffffffffc0205bbe <strchr>
ffffffffc0200430:	c901                	beqz	a0,ffffffffc0200440 <kmonitor+0xf6>
ffffffffc0200432:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200436:	00040023          	sb	zero,0(s0)
ffffffffc020043a:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020043c:	d5c9                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc020043e:	b7f5                	j	ffffffffc020042a <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc0200440:	00044783          	lbu	a5,0(s0)
ffffffffc0200444:	d3c9                	beqz	a5,ffffffffc02003c6 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200446:	033c8963          	beq	s9,s3,ffffffffc0200478 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc020044a:	003c9793          	slli	a5,s9,0x3
ffffffffc020044e:	0118                	addi	a4,sp,128
ffffffffc0200450:	97ba                	add	a5,a5,a4
ffffffffc0200452:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200456:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020045a:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020045c:	e591                	bnez	a1,ffffffffc0200468 <kmonitor+0x11e>
ffffffffc020045e:	b7b5                	j	ffffffffc02003ca <kmonitor+0x80>
ffffffffc0200460:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200464:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200466:	d1a5                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc0200468:	8526                	mv	a0,s1
ffffffffc020046a:	754050ef          	jal	ra,ffffffffc0205bbe <strchr>
ffffffffc020046e:	d96d                	beqz	a0,ffffffffc0200460 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200470:	00044583          	lbu	a1,0(s0)
ffffffffc0200474:	d9a9                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc0200476:	bf55                	j	ffffffffc020042a <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200478:	45c1                	li	a1,16
ffffffffc020047a:	855a                	mv	a0,s6
ffffffffc020047c:	d1dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0200480:	b7e9                	j	ffffffffc020044a <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200482:	6582                	ld	a1,0(sp)
ffffffffc0200484:	00006517          	auipc	a0,0x6
ffffffffc0200488:	9cc50513          	addi	a0,a0,-1588 # ffffffffc0205e50 <etext+0x252>
ffffffffc020048c:	d0dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return 0;
ffffffffc0200490:	b715                	j	ffffffffc02003b4 <kmonitor+0x6a>

ffffffffc0200492 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200492:	000c6317          	auipc	t1,0xc6
ffffffffc0200496:	6f630313          	addi	t1,t1,1782 # ffffffffc02c6b88 <is_panic>
ffffffffc020049a:	00033e03          	ld	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020049e:	715d                	addi	sp,sp,-80
ffffffffc02004a0:	ec06                	sd	ra,24(sp)
ffffffffc02004a2:	e822                	sd	s0,16(sp)
ffffffffc02004a4:	f436                	sd	a3,40(sp)
ffffffffc02004a6:	f83a                	sd	a4,48(sp)
ffffffffc02004a8:	fc3e                	sd	a5,56(sp)
ffffffffc02004aa:	e0c2                	sd	a6,64(sp)
ffffffffc02004ac:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02004ae:	020e1a63          	bnez	t3,ffffffffc02004e2 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004b2:	4785                	li	a5,1
ffffffffc02004b4:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b8:	8432                	mv	s0,a2
ffffffffc02004ba:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004bc:	862e                	mv	a2,a1
ffffffffc02004be:	85aa                	mv	a1,a0
ffffffffc02004c0:	00006517          	auipc	a0,0x6
ffffffffc02004c4:	9f050513          	addi	a0,a0,-1552 # ffffffffc0205eb0 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c8:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004ca:	ccfff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ce:	65a2                	ld	a1,8(sp)
ffffffffc02004d0:	8522                	mv	a0,s0
ffffffffc02004d2:	ca7ff0ef          	jal	ra,ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc02004d6:	00007517          	auipc	a0,0x7
ffffffffc02004da:	ad250513          	addi	a0,a0,-1326 # ffffffffc0206fa8 <default_pmm_manager+0x578>
ffffffffc02004de:	cbbff0ef          	jal	ra,ffffffffc0200198 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004e2:	4501                	li	a0,0
ffffffffc02004e4:	4581                	li	a1,0
ffffffffc02004e6:	4601                	li	a2,0
ffffffffc02004e8:	48a1                	li	a7,8
ffffffffc02004ea:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ee:	4c0000ef          	jal	ra,ffffffffc02009ae <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004f2:	4501                	li	a0,0
ffffffffc02004f4:	e57ff0ef          	jal	ra,ffffffffc020034a <kmonitor>
    while (1) {
ffffffffc02004f8:	bfed                	j	ffffffffc02004f2 <__panic+0x60>

ffffffffc02004fa <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004fa:	715d                	addi	sp,sp,-80
ffffffffc02004fc:	832e                	mv	t1,a1
ffffffffc02004fe:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200500:	85aa                	mv	a1,a0
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200502:	8432                	mv	s0,a2
ffffffffc0200504:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200508:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020050a:	00006517          	auipc	a0,0x6
ffffffffc020050e:	9c650513          	addi	a0,a0,-1594 # ffffffffc0205ed0 <commands+0x68>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200512:	ec06                	sd	ra,24(sp)
ffffffffc0200514:	f436                	sd	a3,40(sp)
ffffffffc0200516:	f83a                	sd	a4,48(sp)
ffffffffc0200518:	e0c2                	sd	a6,64(sp)
ffffffffc020051a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020051c:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051e:	c7bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200522:	65a2                	ld	a1,8(sp)
ffffffffc0200524:	8522                	mv	a0,s0
ffffffffc0200526:	c53ff0ef          	jal	ra,ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc020052a:	00007517          	auipc	a0,0x7
ffffffffc020052e:	a7e50513          	addi	a0,a0,-1410 # ffffffffc0206fa8 <default_pmm_manager+0x578>
ffffffffc0200532:	c67ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    va_end(ap);
}
ffffffffc0200536:	60e2                	ld	ra,24(sp)
ffffffffc0200538:	6442                	ld	s0,16(sp)
ffffffffc020053a:	6161                	addi	sp,sp,80
ffffffffc020053c:	8082                	ret

ffffffffc020053e <clock_init>:
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
    set_csr(sie, MIP_STIP);
ffffffffc020053e:	02000793          	li	a5,32
ffffffffc0200542:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200546:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054a:	67e1                	lui	a5,0x18
ffffffffc020054c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbf90>
ffffffffc0200550:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200552:	4581                	li	a1,0
ffffffffc0200554:	4601                	li	a2,0
ffffffffc0200556:	4881                	li	a7,0
ffffffffc0200558:	00000073          	ecall
    cprintf("++ setup timer interrupts\n");
ffffffffc020055c:	00006517          	auipc	a0,0x6
ffffffffc0200560:	99450513          	addi	a0,a0,-1644 # ffffffffc0205ef0 <commands+0x88>
    ticks = 0;
ffffffffc0200564:	000c6797          	auipc	a5,0xc6
ffffffffc0200568:	6207b623          	sd	zero,1580(a5) # ffffffffc02c6b90 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020056c:	b135                	j	ffffffffc0200198 <cprintf>

ffffffffc020056e <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020056e:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200572:	67e1                	lui	a5,0x18
ffffffffc0200574:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbf90>
ffffffffc0200578:	953e                	add	a0,a0,a5
ffffffffc020057a:	4581                	li	a1,0
ffffffffc020057c:	4601                	li	a2,0
ffffffffc020057e:	4881                	li	a7,0
ffffffffc0200580:	00000073          	ecall
ffffffffc0200584:	8082                	ret

ffffffffc0200586 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200586:	8082                	ret

ffffffffc0200588 <cons_putc>:
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200588:	100027f3          	csrr	a5,sstatus
ffffffffc020058c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020058e:	0ff57513          	zext.b	a0,a0
ffffffffc0200592:	e799                	bnez	a5,ffffffffc02005a0 <cons_putc+0x18>
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4885                	li	a7,1
ffffffffc020059a:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc020059e:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005a6:	408000ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc02005aa:	6522                	ld	a0,8(sp)
ffffffffc02005ac:	4581                	li	a1,0
ffffffffc02005ae:	4601                	li	a2,0
ffffffffc02005b0:	4885                	li	a7,1
ffffffffc02005b2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005b6:	60e2                	ld	ra,24(sp)
ffffffffc02005b8:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005ba:	a6fd                	j	ffffffffc02009a8 <intr_enable>

ffffffffc02005bc <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005bc:	100027f3          	csrr	a5,sstatus
ffffffffc02005c0:	8b89                	andi	a5,a5,2
ffffffffc02005c2:	eb89                	bnez	a5,ffffffffc02005d4 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005c4:	4501                	li	a0,0
ffffffffc02005c6:	4581                	li	a1,0
ffffffffc02005c8:	4601                	li	a2,0
ffffffffc02005ca:	4889                	li	a7,2
ffffffffc02005cc:	00000073          	ecall
ffffffffc02005d0:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d2:	8082                	ret
int cons_getc(void) {
ffffffffc02005d4:	1101                	addi	sp,sp,-32
ffffffffc02005d6:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005d8:	3d6000ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc02005dc:	4501                	li	a0,0
ffffffffc02005de:	4581                	li	a1,0
ffffffffc02005e0:	4601                	li	a2,0
ffffffffc02005e2:	4889                	li	a7,2
ffffffffc02005e4:	00000073          	ecall
ffffffffc02005e8:	2501                	sext.w	a0,a0
ffffffffc02005ea:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005ec:	3bc000ef          	jal	ra,ffffffffc02009a8 <intr_enable>
}
ffffffffc02005f0:	60e2                	ld	ra,24(sp)
ffffffffc02005f2:	6522                	ld	a0,8(sp)
ffffffffc02005f4:	6105                	addi	sp,sp,32
ffffffffc02005f6:	8082                	ret

ffffffffc02005f8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005f8:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc02005fa:	00006517          	auipc	a0,0x6
ffffffffc02005fe:	91650513          	addi	a0,a0,-1770 # ffffffffc0205f10 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200602:	fc86                	sd	ra,120(sp)
ffffffffc0200604:	f8a2                	sd	s0,112(sp)
ffffffffc0200606:	e8d2                	sd	s4,80(sp)
ffffffffc0200608:	f4a6                	sd	s1,104(sp)
ffffffffc020060a:	f0ca                	sd	s2,96(sp)
ffffffffc020060c:	ecce                	sd	s3,88(sp)
ffffffffc020060e:	e4d6                	sd	s5,72(sp)
ffffffffc0200610:	e0da                	sd	s6,64(sp)
ffffffffc0200612:	fc5e                	sd	s7,56(sp)
ffffffffc0200614:	f862                	sd	s8,48(sp)
ffffffffc0200616:	f466                	sd	s9,40(sp)
ffffffffc0200618:	f06a                	sd	s10,32(sp)
ffffffffc020061a:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc020061c:	b7dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200620:	0000c597          	auipc	a1,0xc
ffffffffc0200624:	9e05b583          	ld	a1,-1568(a1) # ffffffffc020c000 <boot_hartid>
ffffffffc0200628:	00006517          	auipc	a0,0x6
ffffffffc020062c:	8f850513          	addi	a0,a0,-1800 # ffffffffc0205f20 <commands+0xb8>
ffffffffc0200630:	b69ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200634:	0000c417          	auipc	s0,0xc
ffffffffc0200638:	9d440413          	addi	s0,s0,-1580 # ffffffffc020c008 <boot_dtb>
ffffffffc020063c:	600c                	ld	a1,0(s0)
ffffffffc020063e:	00006517          	auipc	a0,0x6
ffffffffc0200642:	8f250513          	addi	a0,a0,-1806 # ffffffffc0205f30 <commands+0xc8>
ffffffffc0200646:	b53ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc020064a:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc020064e:	00006517          	auipc	a0,0x6
ffffffffc0200652:	8fa50513          	addi	a0,a0,-1798 # ffffffffc0205f48 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc0200656:	120a0463          	beqz	s4,ffffffffc020077e <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020065a:	57f5                	li	a5,-3
ffffffffc020065c:	07fa                	slli	a5,a5,0x1e
ffffffffc020065e:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200662:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200664:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200668:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020066e:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200672:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200676:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067a:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067e:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	8ec9                	or	a3,a3,a0
ffffffffc0200682:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200686:	1b7d                	addi	s6,s6,-1
ffffffffc0200688:	0167f7b3          	and	a5,a5,s6
ffffffffc020068c:	8dd5                	or	a1,a1,a3
ffffffffc020068e:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200690:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200694:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe192dd>
ffffffffc020069a:	10f59163          	bne	a1,a5,ffffffffc020079c <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020069e:	471c                	lw	a5,8(a4)
ffffffffc02006a0:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a2:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a4:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006a8:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006ac:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b8:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006bc:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c0:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c4:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c8:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006cc:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	01146433          	or	s0,s0,a7
ffffffffc02006d2:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006d6:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006da:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006dc:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e0:	8c49                	or	s0,s0,a0
ffffffffc02006e2:	0166f6b3          	and	a3,a3,s6
ffffffffc02006e6:	00ca6a33          	or	s4,s4,a2
ffffffffc02006ea:	0167f7b3          	and	a5,a5,s6
ffffffffc02006ee:	8c55                	or	s0,s0,a3
ffffffffc02006f0:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f4:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006f6:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f8:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fa:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200702:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc0200706:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200708:	00006917          	auipc	s2,0x6
ffffffffc020070c:	89090913          	addi	s2,s2,-1904 # ffffffffc0205f98 <commands+0x130>
ffffffffc0200710:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200712:	4d91                	li	s11,4
ffffffffc0200714:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200716:	00006497          	auipc	s1,0x6
ffffffffc020071a:	87a48493          	addi	s1,s1,-1926 # ffffffffc0205f90 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020071e:	000a2703          	lw	a4,0(s4)
ffffffffc0200722:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200726:	0087569b          	srliw	a3,a4,0x8
ffffffffc020072a:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020072e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200732:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200736:	0107571b          	srliw	a4,a4,0x10
ffffffffc020073a:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020073c:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200740:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200744:	8fd5                	or	a5,a5,a3
ffffffffc0200746:	00eb7733          	and	a4,s6,a4
ffffffffc020074a:	8fd9                	or	a5,a5,a4
ffffffffc020074c:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc020074e:	09778c63          	beq	a5,s7,ffffffffc02007e6 <dtb_init+0x1ee>
ffffffffc0200752:	00fbea63          	bltu	s7,a5,ffffffffc0200766 <dtb_init+0x16e>
ffffffffc0200756:	07a78663          	beq	a5,s10,ffffffffc02007c2 <dtb_init+0x1ca>
ffffffffc020075a:	4709                	li	a4,2
ffffffffc020075c:	00e79763          	bne	a5,a4,ffffffffc020076a <dtb_init+0x172>
ffffffffc0200760:	4c81                	li	s9,0
ffffffffc0200762:	8a56                	mv	s4,s5
ffffffffc0200764:	bf6d                	j	ffffffffc020071e <dtb_init+0x126>
ffffffffc0200766:	ffb78ee3          	beq	a5,s11,ffffffffc0200762 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc020076a:	00006517          	auipc	a0,0x6
ffffffffc020076e:	8a650513          	addi	a0,a0,-1882 # ffffffffc0206010 <commands+0x1a8>
ffffffffc0200772:	a27ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200776:	00006517          	auipc	a0,0x6
ffffffffc020077a:	8d250513          	addi	a0,a0,-1838 # ffffffffc0206048 <commands+0x1e0>
}
ffffffffc020077e:	7446                	ld	s0,112(sp)
ffffffffc0200780:	70e6                	ld	ra,120(sp)
ffffffffc0200782:	74a6                	ld	s1,104(sp)
ffffffffc0200784:	7906                	ld	s2,96(sp)
ffffffffc0200786:	69e6                	ld	s3,88(sp)
ffffffffc0200788:	6a46                	ld	s4,80(sp)
ffffffffc020078a:	6aa6                	ld	s5,72(sp)
ffffffffc020078c:	6b06                	ld	s6,64(sp)
ffffffffc020078e:	7be2                	ld	s7,56(sp)
ffffffffc0200790:	7c42                	ld	s8,48(sp)
ffffffffc0200792:	7ca2                	ld	s9,40(sp)
ffffffffc0200794:	7d02                	ld	s10,32(sp)
ffffffffc0200796:	6de2                	ld	s11,24(sp)
ffffffffc0200798:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc020079a:	bafd                	j	ffffffffc0200198 <cprintf>
}
ffffffffc020079c:	7446                	ld	s0,112(sp)
ffffffffc020079e:	70e6                	ld	ra,120(sp)
ffffffffc02007a0:	74a6                	ld	s1,104(sp)
ffffffffc02007a2:	7906                	ld	s2,96(sp)
ffffffffc02007a4:	69e6                	ld	s3,88(sp)
ffffffffc02007a6:	6a46                	ld	s4,80(sp)
ffffffffc02007a8:	6aa6                	ld	s5,72(sp)
ffffffffc02007aa:	6b06                	ld	s6,64(sp)
ffffffffc02007ac:	7be2                	ld	s7,56(sp)
ffffffffc02007ae:	7c42                	ld	s8,48(sp)
ffffffffc02007b0:	7ca2                	ld	s9,40(sp)
ffffffffc02007b2:	7d02                	ld	s10,32(sp)
ffffffffc02007b4:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007b6:	00005517          	auipc	a0,0x5
ffffffffc02007ba:	7b250513          	addi	a0,a0,1970 # ffffffffc0205f68 <commands+0x100>
}
ffffffffc02007be:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c0:	bae1                	j	ffffffffc0200198 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c2:	8556                	mv	a0,s5
ffffffffc02007c4:	36e050ef          	jal	ra,ffffffffc0205b32 <strlen>
ffffffffc02007c8:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007ca:	4619                	li	a2,6
ffffffffc02007cc:	85a6                	mv	a1,s1
ffffffffc02007ce:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d0:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d2:	3c6050ef          	jal	ra,ffffffffc0205b98 <strncmp>
ffffffffc02007d6:	e111                	bnez	a0,ffffffffc02007da <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007d8:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007da:	0a91                	addi	s5,s5,4
ffffffffc02007dc:	9ad2                	add	s5,s5,s4
ffffffffc02007de:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e2:	8a56                	mv	s4,s5
ffffffffc02007e4:	bf2d                	j	ffffffffc020071e <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007e6:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ea:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ee:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f2:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f6:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007fa:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fe:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200802:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200806:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020080a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020080e:	00eaeab3          	or	s5,s5,a4
ffffffffc0200812:	00fb77b3          	and	a5,s6,a5
ffffffffc0200816:	00faeab3          	or	s5,s5,a5
ffffffffc020081a:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020081c:	000c9c63          	bnez	s9,ffffffffc0200834 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200820:	1a82                	slli	s5,s5,0x20
ffffffffc0200822:	00368793          	addi	a5,a3,3
ffffffffc0200826:	020ada93          	srli	s5,s5,0x20
ffffffffc020082a:	9abe                	add	s5,s5,a5
ffffffffc020082c:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200830:	8a56                	mv	s4,s5
ffffffffc0200832:	b5f5                	j	ffffffffc020071e <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200834:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200838:	85ca                	mv	a1,s2
ffffffffc020083a:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020083c:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200840:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200844:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200848:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200850:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200852:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200856:	0087979b          	slliw	a5,a5,0x8
ffffffffc020085a:	8d59                	or	a0,a0,a4
ffffffffc020085c:	00fb77b3          	and	a5,s6,a5
ffffffffc0200860:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200862:	1502                	slli	a0,a0,0x20
ffffffffc0200864:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200866:	9522                	add	a0,a0,s0
ffffffffc0200868:	312050ef          	jal	ra,ffffffffc0205b7a <strcmp>
ffffffffc020086c:	66a2                	ld	a3,8(sp)
ffffffffc020086e:	f94d                	bnez	a0,ffffffffc0200820 <dtb_init+0x228>
ffffffffc0200870:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200820 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200874:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200878:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020087c:	00005517          	auipc	a0,0x5
ffffffffc0200880:	72450513          	addi	a0,a0,1828 # ffffffffc0205fa0 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc0200884:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200888:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020088c:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200890:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200894:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200898:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020089c:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a0:	0187d693          	srli	a3,a5,0x18
ffffffffc02008a4:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008a8:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008ac:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b0:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008b4:	010f6f33          	or	t5,t5,a6
ffffffffc02008b8:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008bc:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c0:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008c4:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c8:	0186f6b3          	and	a3,a3,s8
ffffffffc02008cc:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d0:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008d4:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008d8:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008dc:	8361                	srli	a4,a4,0x18
ffffffffc02008de:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e2:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008e6:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008ea:	00cb7633          	and	a2,s6,a2
ffffffffc02008ee:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f2:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008f6:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008fa:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008fe:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200902:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200906:	0088989b          	slliw	a7,a7,0x8
ffffffffc020090a:	011b78b3          	and	a7,s6,a7
ffffffffc020090e:	005eeeb3          	or	t4,t4,t0
ffffffffc0200912:	00c6e733          	or	a4,a3,a2
ffffffffc0200916:	006c6c33          	or	s8,s8,t1
ffffffffc020091a:	010b76b3          	and	a3,s6,a6
ffffffffc020091e:	00bb7b33          	and	s6,s6,a1
ffffffffc0200922:	01d7e7b3          	or	a5,a5,t4
ffffffffc0200926:	016c6b33          	or	s6,s8,s6
ffffffffc020092a:	01146433          	or	s0,s0,a7
ffffffffc020092e:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200930:	1702                	slli	a4,a4,0x20
ffffffffc0200932:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200934:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200938:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093a:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	0167eb33          	or	s6,a5,s6
ffffffffc0200942:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200944:	855ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200948:	85a2                	mv	a1,s0
ffffffffc020094a:	00005517          	auipc	a0,0x5
ffffffffc020094e:	67650513          	addi	a0,a0,1654 # ffffffffc0205fc0 <commands+0x158>
ffffffffc0200952:	847ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200956:	014b5613          	srli	a2,s6,0x14
ffffffffc020095a:	85da                	mv	a1,s6
ffffffffc020095c:	00005517          	auipc	a0,0x5
ffffffffc0200960:	67c50513          	addi	a0,a0,1660 # ffffffffc0205fd8 <commands+0x170>
ffffffffc0200964:	835ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200968:	008b05b3          	add	a1,s6,s0
ffffffffc020096c:	15fd                	addi	a1,a1,-1
ffffffffc020096e:	00005517          	auipc	a0,0x5
ffffffffc0200972:	68a50513          	addi	a0,a0,1674 # ffffffffc0205ff8 <commands+0x190>
ffffffffc0200976:	823ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc020097a:	00005517          	auipc	a0,0x5
ffffffffc020097e:	6ce50513          	addi	a0,a0,1742 # ffffffffc0206048 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200982:	000c6797          	auipc	a5,0xc6
ffffffffc0200986:	2087bb23          	sd	s0,534(a5) # ffffffffc02c6b98 <memory_base>
        memory_size = mem_size;
ffffffffc020098a:	000c6797          	auipc	a5,0xc6
ffffffffc020098e:	2167bb23          	sd	s6,534(a5) # ffffffffc02c6ba0 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200992:	b3f5                	j	ffffffffc020077e <dtb_init+0x186>

ffffffffc0200994 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200994:	000c6517          	auipc	a0,0xc6
ffffffffc0200998:	20453503          	ld	a0,516(a0) # ffffffffc02c6b98 <memory_base>
ffffffffc020099c:	8082                	ret

ffffffffc020099e <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc020099e:	000c6517          	auipc	a0,0xc6
ffffffffc02009a2:	20253503          	ld	a0,514(a0) # ffffffffc02c6ba0 <memory_size>
ffffffffc02009a6:	8082                	ret

ffffffffc02009a8 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009a8:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009b4:	8082                	ret

ffffffffc02009b6 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009b6:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009ba:	00000797          	auipc	a5,0x0
ffffffffc02009be:	44278793          	addi	a5,a5,1090 # ffffffffc0200dfc <__alltraps>
ffffffffc02009c2:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009c6:	000407b7          	lui	a5,0x40
ffffffffc02009ca:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009ce:	8082                	ret

ffffffffc02009d0 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d0:	610c                	ld	a1,0(a0)
{
ffffffffc02009d2:	1141                	addi	sp,sp,-16
ffffffffc02009d4:	e022                	sd	s0,0(sp)
ffffffffc02009d6:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	68850513          	addi	a0,a0,1672 # ffffffffc0206060 <commands+0x1f8>
{
ffffffffc02009e0:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e2:	fb6ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009e6:	640c                	ld	a1,8(s0)
ffffffffc02009e8:	00005517          	auipc	a0,0x5
ffffffffc02009ec:	69050513          	addi	a0,a0,1680 # ffffffffc0206078 <commands+0x210>
ffffffffc02009f0:	fa8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009f4:	680c                	ld	a1,16(s0)
ffffffffc02009f6:	00005517          	auipc	a0,0x5
ffffffffc02009fa:	69a50513          	addi	a0,a0,1690 # ffffffffc0206090 <commands+0x228>
ffffffffc02009fe:	f9aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a02:	6c0c                	ld	a1,24(s0)
ffffffffc0200a04:	00005517          	auipc	a0,0x5
ffffffffc0200a08:	6a450513          	addi	a0,a0,1700 # ffffffffc02060a8 <commands+0x240>
ffffffffc0200a0c:	f8cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a10:	700c                	ld	a1,32(s0)
ffffffffc0200a12:	00005517          	auipc	a0,0x5
ffffffffc0200a16:	6ae50513          	addi	a0,a0,1710 # ffffffffc02060c0 <commands+0x258>
ffffffffc0200a1a:	f7eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a1e:	740c                	ld	a1,40(s0)
ffffffffc0200a20:	00005517          	auipc	a0,0x5
ffffffffc0200a24:	6b850513          	addi	a0,a0,1720 # ffffffffc02060d8 <commands+0x270>
ffffffffc0200a28:	f70ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a2c:	780c                	ld	a1,48(s0)
ffffffffc0200a2e:	00005517          	auipc	a0,0x5
ffffffffc0200a32:	6c250513          	addi	a0,a0,1730 # ffffffffc02060f0 <commands+0x288>
ffffffffc0200a36:	f62ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a3a:	7c0c                	ld	a1,56(s0)
ffffffffc0200a3c:	00005517          	auipc	a0,0x5
ffffffffc0200a40:	6cc50513          	addi	a0,a0,1740 # ffffffffc0206108 <commands+0x2a0>
ffffffffc0200a44:	f54ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a48:	602c                	ld	a1,64(s0)
ffffffffc0200a4a:	00005517          	auipc	a0,0x5
ffffffffc0200a4e:	6d650513          	addi	a0,a0,1750 # ffffffffc0206120 <commands+0x2b8>
ffffffffc0200a52:	f46ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a56:	642c                	ld	a1,72(s0)
ffffffffc0200a58:	00005517          	auipc	a0,0x5
ffffffffc0200a5c:	6e050513          	addi	a0,a0,1760 # ffffffffc0206138 <commands+0x2d0>
ffffffffc0200a60:	f38ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a64:	682c                	ld	a1,80(s0)
ffffffffc0200a66:	00005517          	auipc	a0,0x5
ffffffffc0200a6a:	6ea50513          	addi	a0,a0,1770 # ffffffffc0206150 <commands+0x2e8>
ffffffffc0200a6e:	f2aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a72:	6c2c                	ld	a1,88(s0)
ffffffffc0200a74:	00005517          	auipc	a0,0x5
ffffffffc0200a78:	6f450513          	addi	a0,a0,1780 # ffffffffc0206168 <commands+0x300>
ffffffffc0200a7c:	f1cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a80:	702c                	ld	a1,96(s0)
ffffffffc0200a82:	00005517          	auipc	a0,0x5
ffffffffc0200a86:	6fe50513          	addi	a0,a0,1790 # ffffffffc0206180 <commands+0x318>
ffffffffc0200a8a:	f0eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a8e:	742c                	ld	a1,104(s0)
ffffffffc0200a90:	00005517          	auipc	a0,0x5
ffffffffc0200a94:	70850513          	addi	a0,a0,1800 # ffffffffc0206198 <commands+0x330>
ffffffffc0200a98:	f00ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a9c:	782c                	ld	a1,112(s0)
ffffffffc0200a9e:	00005517          	auipc	a0,0x5
ffffffffc0200aa2:	71250513          	addi	a0,a0,1810 # ffffffffc02061b0 <commands+0x348>
ffffffffc0200aa6:	ef2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200aaa:	7c2c                	ld	a1,120(s0)
ffffffffc0200aac:	00005517          	auipc	a0,0x5
ffffffffc0200ab0:	71c50513          	addi	a0,a0,1820 # ffffffffc02061c8 <commands+0x360>
ffffffffc0200ab4:	ee4ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200ab8:	604c                	ld	a1,128(s0)
ffffffffc0200aba:	00005517          	auipc	a0,0x5
ffffffffc0200abe:	72650513          	addi	a0,a0,1830 # ffffffffc02061e0 <commands+0x378>
ffffffffc0200ac2:	ed6ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200ac6:	644c                	ld	a1,136(s0)
ffffffffc0200ac8:	00005517          	auipc	a0,0x5
ffffffffc0200acc:	73050513          	addi	a0,a0,1840 # ffffffffc02061f8 <commands+0x390>
ffffffffc0200ad0:	ec8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ad4:	684c                	ld	a1,144(s0)
ffffffffc0200ad6:	00005517          	auipc	a0,0x5
ffffffffc0200ada:	73a50513          	addi	a0,a0,1850 # ffffffffc0206210 <commands+0x3a8>
ffffffffc0200ade:	ebaff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae2:	6c4c                	ld	a1,152(s0)
ffffffffc0200ae4:	00005517          	auipc	a0,0x5
ffffffffc0200ae8:	74450513          	addi	a0,a0,1860 # ffffffffc0206228 <commands+0x3c0>
ffffffffc0200aec:	eacff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af0:	704c                	ld	a1,160(s0)
ffffffffc0200af2:	00005517          	auipc	a0,0x5
ffffffffc0200af6:	74e50513          	addi	a0,a0,1870 # ffffffffc0206240 <commands+0x3d8>
ffffffffc0200afa:	e9eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200afe:	744c                	ld	a1,168(s0)
ffffffffc0200b00:	00005517          	auipc	a0,0x5
ffffffffc0200b04:	75850513          	addi	a0,a0,1880 # ffffffffc0206258 <commands+0x3f0>
ffffffffc0200b08:	e90ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b0c:	784c                	ld	a1,176(s0)
ffffffffc0200b0e:	00005517          	auipc	a0,0x5
ffffffffc0200b12:	76250513          	addi	a0,a0,1890 # ffffffffc0206270 <commands+0x408>
ffffffffc0200b16:	e82ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b1a:	7c4c                	ld	a1,184(s0)
ffffffffc0200b1c:	00005517          	auipc	a0,0x5
ffffffffc0200b20:	76c50513          	addi	a0,a0,1900 # ffffffffc0206288 <commands+0x420>
ffffffffc0200b24:	e74ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b28:	606c                	ld	a1,192(s0)
ffffffffc0200b2a:	00005517          	auipc	a0,0x5
ffffffffc0200b2e:	77650513          	addi	a0,a0,1910 # ffffffffc02062a0 <commands+0x438>
ffffffffc0200b32:	e66ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b36:	646c                	ld	a1,200(s0)
ffffffffc0200b38:	00005517          	auipc	a0,0x5
ffffffffc0200b3c:	78050513          	addi	a0,a0,1920 # ffffffffc02062b8 <commands+0x450>
ffffffffc0200b40:	e58ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b44:	686c                	ld	a1,208(s0)
ffffffffc0200b46:	00005517          	auipc	a0,0x5
ffffffffc0200b4a:	78a50513          	addi	a0,a0,1930 # ffffffffc02062d0 <commands+0x468>
ffffffffc0200b4e:	e4aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b52:	6c6c                	ld	a1,216(s0)
ffffffffc0200b54:	00005517          	auipc	a0,0x5
ffffffffc0200b58:	79450513          	addi	a0,a0,1940 # ffffffffc02062e8 <commands+0x480>
ffffffffc0200b5c:	e3cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b60:	706c                	ld	a1,224(s0)
ffffffffc0200b62:	00005517          	auipc	a0,0x5
ffffffffc0200b66:	79e50513          	addi	a0,a0,1950 # ffffffffc0206300 <commands+0x498>
ffffffffc0200b6a:	e2eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b6e:	746c                	ld	a1,232(s0)
ffffffffc0200b70:	00005517          	auipc	a0,0x5
ffffffffc0200b74:	7a850513          	addi	a0,a0,1960 # ffffffffc0206318 <commands+0x4b0>
ffffffffc0200b78:	e20ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b7c:	786c                	ld	a1,240(s0)
ffffffffc0200b7e:	00005517          	auipc	a0,0x5
ffffffffc0200b82:	7b250513          	addi	a0,a0,1970 # ffffffffc0206330 <commands+0x4c8>
ffffffffc0200b86:	e12ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b8a:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b8c:	6402                	ld	s0,0(sp)
ffffffffc0200b8e:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	00005517          	auipc	a0,0x5
ffffffffc0200b94:	7b850513          	addi	a0,a0,1976 # ffffffffc0206348 <commands+0x4e0>
}
ffffffffc0200b98:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b9a:	dfeff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200b9e <print_trapframe>:
{
ffffffffc0200b9e:	1141                	addi	sp,sp,-16
ffffffffc0200ba0:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba2:	85aa                	mv	a1,a0
{
ffffffffc0200ba4:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba6:	00005517          	auipc	a0,0x5
ffffffffc0200baa:	7ba50513          	addi	a0,a0,1978 # ffffffffc0206360 <commands+0x4f8>
{
ffffffffc0200bae:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb0:	de8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bb4:	8522                	mv	a0,s0
ffffffffc0200bb6:	e1bff0ef          	jal	ra,ffffffffc02009d0 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bba:	10043583          	ld	a1,256(s0)
ffffffffc0200bbe:	00005517          	auipc	a0,0x5
ffffffffc0200bc2:	7ba50513          	addi	a0,a0,1978 # ffffffffc0206378 <commands+0x510>
ffffffffc0200bc6:	dd2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bca:	10843583          	ld	a1,264(s0)
ffffffffc0200bce:	00005517          	auipc	a0,0x5
ffffffffc0200bd2:	7c250513          	addi	a0,a0,1986 # ffffffffc0206390 <commands+0x528>
ffffffffc0200bd6:	dc2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200bda:	11043583          	ld	a1,272(s0)
ffffffffc0200bde:	00005517          	auipc	a0,0x5
ffffffffc0200be2:	7ca50513          	addi	a0,a0,1994 # ffffffffc02063a8 <commands+0x540>
ffffffffc0200be6:	db2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bea:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bee:	6402                	ld	s0,0(sp)
ffffffffc0200bf0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf2:	00005517          	auipc	a0,0x5
ffffffffc0200bf6:	7c650513          	addi	a0,a0,1990 # ffffffffc02063b8 <commands+0x550>
}
ffffffffc0200bfa:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bfc:	d9cff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200c00 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c00:	11853783          	ld	a5,280(a0)
ffffffffc0200c04:	472d                	li	a4,11
ffffffffc0200c06:	0786                	slli	a5,a5,0x1
ffffffffc0200c08:	8385                	srli	a5,a5,0x1
ffffffffc0200c0a:	06f76d63          	bltu	a4,a5,ffffffffc0200c84 <interrupt_handler+0x84>
ffffffffc0200c0e:	00006717          	auipc	a4,0x6
ffffffffc0200c12:	86270713          	addi	a4,a4,-1950 # ffffffffc0206470 <commands+0x608>
ffffffffc0200c16:	078a                	slli	a5,a5,0x2
ffffffffc0200c18:	97ba                	add	a5,a5,a4
ffffffffc0200c1a:	439c                	lw	a5,0(a5)
ffffffffc0200c1c:	97ba                	add	a5,a5,a4
ffffffffc0200c1e:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c20:	00006517          	auipc	a0,0x6
ffffffffc0200c24:	81050513          	addi	a0,a0,-2032 # ffffffffc0206430 <commands+0x5c8>
ffffffffc0200c28:	d70ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c2c:	00005517          	auipc	a0,0x5
ffffffffc0200c30:	7e450513          	addi	a0,a0,2020 # ffffffffc0206410 <commands+0x5a8>
ffffffffc0200c34:	d64ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c38:	00005517          	auipc	a0,0x5
ffffffffc0200c3c:	79850513          	addi	a0,a0,1944 # ffffffffc02063d0 <commands+0x568>
ffffffffc0200c40:	d58ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c44:	00005517          	auipc	a0,0x5
ffffffffc0200c48:	7ac50513          	addi	a0,a0,1964 # ffffffffc02063f0 <commands+0x588>
ffffffffc0200c4c:	d4cff06f          	j	ffffffffc0200198 <cprintf>
{
ffffffffc0200c50:	1141                	addi	sp,sp,-16
ffffffffc0200c52:	e406                	sd	ra,8(sp)
        /*(1)设置下次时钟中断- clock_set_next_event()
         *(2)计数器（ticks）加一
         *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
        clock_set_next_event();
ffffffffc0200c54:	91bff0ef          	jal	ra,ffffffffc020056e <clock_set_next_event>
        ticks++;
ffffffffc0200c58:	000c6717          	auipc	a4,0xc6
ffffffffc0200c5c:	f3870713          	addi	a4,a4,-200 # ffffffffc02c6b90 <ticks>
ffffffffc0200c60:	631c                	ld	a5,0(a4)

        // lab6: 2312642  (update LAB3 steps)
        //  在时钟中断时调用调度器的 sched_class_proc_tick 函数
        if (current != NULL)
ffffffffc0200c62:	000c6517          	auipc	a0,0xc6
ffffffffc0200c66:	f7e53503          	ld	a0,-130(a0) # ffffffffc02c6be0 <current>
        ticks++;
ffffffffc0200c6a:	0785                	addi	a5,a5,1
ffffffffc0200c6c:	e31c                	sd	a5,0(a4)
        if (current != NULL)
ffffffffc0200c6e:	cd01                	beqz	a0,ffffffffc0200c86 <interrupt_handler+0x86>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c70:	60a2                	ld	ra,8(sp)
ffffffffc0200c72:	0141                	addi	sp,sp,16
            sched_class_proc_tick(current);
ffffffffc0200c74:	7ce0406f          	j	ffffffffc0205442 <sched_class_proc_tick>
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c78:	00005517          	auipc	a0,0x5
ffffffffc0200c7c:	7d850513          	addi	a0,a0,2008 # ffffffffc0206450 <commands+0x5e8>
ffffffffc0200c80:	d18ff06f          	j	ffffffffc0200198 <cprintf>
        print_trapframe(tf);
ffffffffc0200c84:	bf29                	j	ffffffffc0200b9e <print_trapframe>
}
ffffffffc0200c86:	60a2                	ld	ra,8(sp)
ffffffffc0200c88:	0141                	addi	sp,sp,16
ffffffffc0200c8a:	8082                	ret

ffffffffc0200c8c <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c8c:	11853783          	ld	a5,280(a0)
{
ffffffffc0200c90:	1141                	addi	sp,sp,-16
ffffffffc0200c92:	e022                	sd	s0,0(sp)
ffffffffc0200c94:	e406                	sd	ra,8(sp)
ffffffffc0200c96:	473d                	li	a4,15
ffffffffc0200c98:	842a                	mv	s0,a0
ffffffffc0200c9a:	0af76b63          	bltu	a4,a5,ffffffffc0200d50 <exception_handler+0xc4>
ffffffffc0200c9e:	00006717          	auipc	a4,0x6
ffffffffc0200ca2:	99270713          	addi	a4,a4,-1646 # ffffffffc0206630 <commands+0x7c8>
ffffffffc0200ca6:	078a                	slli	a5,a5,0x2
ffffffffc0200ca8:	97ba                	add	a5,a5,a4
ffffffffc0200caa:	439c                	lw	a5,0(a5)
ffffffffc0200cac:	97ba                	add	a5,a5,a4
ffffffffc0200cae:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cb0:	00006517          	auipc	a0,0x6
ffffffffc0200cb4:	8d850513          	addi	a0,a0,-1832 # ffffffffc0206588 <commands+0x720>
ffffffffc0200cb8:	ce0ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        tf->epc += 4;
ffffffffc0200cbc:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cc0:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200cc2:	0791                	addi	a5,a5,4
ffffffffc0200cc4:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cc8:	6402                	ld	s0,0(sp)
ffffffffc0200cca:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200ccc:	1e10406f          	j	ffffffffc02056ac <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200cd0:	00006517          	auipc	a0,0x6
ffffffffc0200cd4:	8d850513          	addi	a0,a0,-1832 # ffffffffc02065a8 <commands+0x740>
}
ffffffffc0200cd8:	6402                	ld	s0,0(sp)
ffffffffc0200cda:	60a2                	ld	ra,8(sp)
ffffffffc0200cdc:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200cde:	cbaff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200ce2:	00006517          	auipc	a0,0x6
ffffffffc0200ce6:	8e650513          	addi	a0,a0,-1818 # ffffffffc02065c8 <commands+0x760>
ffffffffc0200cea:	b7fd                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200cec:	00006517          	auipc	a0,0x6
ffffffffc0200cf0:	8fc50513          	addi	a0,a0,-1796 # ffffffffc02065e8 <commands+0x780>
ffffffffc0200cf4:	b7d5                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200cf6:	00006517          	auipc	a0,0x6
ffffffffc0200cfa:	90a50513          	addi	a0,a0,-1782 # ffffffffc0206600 <commands+0x798>
ffffffffc0200cfe:	bfe9                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d00:	00006517          	auipc	a0,0x6
ffffffffc0200d04:	91850513          	addi	a0,a0,-1768 # ffffffffc0206618 <commands+0x7b0>
ffffffffc0200d08:	bfc1                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d0a:	00005517          	auipc	a0,0x5
ffffffffc0200d0e:	79650513          	addi	a0,a0,1942 # ffffffffc02064a0 <commands+0x638>
ffffffffc0200d12:	b7d9                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d14:	00005517          	auipc	a0,0x5
ffffffffc0200d18:	7ac50513          	addi	a0,a0,1964 # ffffffffc02064c0 <commands+0x658>
ffffffffc0200d1c:	bf75                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d1e:	00005517          	auipc	a0,0x5
ffffffffc0200d22:	7c250513          	addi	a0,a0,1986 # ffffffffc02064e0 <commands+0x678>
ffffffffc0200d26:	bf4d                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d28:	00005517          	auipc	a0,0x5
ffffffffc0200d2c:	7d050513          	addi	a0,a0,2000 # ffffffffc02064f8 <commands+0x690>
ffffffffc0200d30:	b765                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Load address misaligned\n");
ffffffffc0200d32:	00005517          	auipc	a0,0x5
ffffffffc0200d36:	7d650513          	addi	a0,a0,2006 # ffffffffc0206508 <commands+0x6a0>
ffffffffc0200d3a:	bf79                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d3c:	00005517          	auipc	a0,0x5
ffffffffc0200d40:	7ec50513          	addi	a0,a0,2028 # ffffffffc0206528 <commands+0x6c0>
ffffffffc0200d44:	bf51                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d46:	00006517          	auipc	a0,0x6
ffffffffc0200d4a:	82a50513          	addi	a0,a0,-2006 # ffffffffc0206570 <commands+0x708>
ffffffffc0200d4e:	b769                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d50:	8522                	mv	a0,s0
}
ffffffffc0200d52:	6402                	ld	s0,0(sp)
ffffffffc0200d54:	60a2                	ld	ra,8(sp)
ffffffffc0200d56:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200d58:	b599                	j	ffffffffc0200b9e <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d5a:	00005617          	auipc	a2,0x5
ffffffffc0200d5e:	7e660613          	addi	a2,a2,2022 # ffffffffc0206540 <commands+0x6d8>
ffffffffc0200d62:	0c000593          	li	a1,192
ffffffffc0200d66:	00005517          	auipc	a0,0x5
ffffffffc0200d6a:	7f250513          	addi	a0,a0,2034 # ffffffffc0206558 <commands+0x6f0>
ffffffffc0200d6e:	f24ff0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0200d72 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200d72:	1101                	addi	sp,sp,-32
ffffffffc0200d74:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200d76:	000c6417          	auipc	s0,0xc6
ffffffffc0200d7a:	e6a40413          	addi	s0,s0,-406 # ffffffffc02c6be0 <current>
ffffffffc0200d7e:	6018                	ld	a4,0(s0)
{
ffffffffc0200d80:	ec06                	sd	ra,24(sp)
ffffffffc0200d82:	e426                	sd	s1,8(sp)
ffffffffc0200d84:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d86:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200d8a:	cf1d                	beqz	a4,ffffffffc0200dc8 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200d8c:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200d90:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200d94:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200d96:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d9a:	0206c463          	bltz	a3,ffffffffc0200dc2 <trap+0x50>
        exception_handler(tf);
ffffffffc0200d9e:	eefff0ef          	jal	ra,ffffffffc0200c8c <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200da2:	601c                	ld	a5,0(s0)
ffffffffc0200da4:	0b27b023          	sd	s2,160(a5) # 400a0 <_binary_obj___user_matrix_out_size+0x33990>
        if (!in_kernel)
ffffffffc0200da8:	e499                	bnez	s1,ffffffffc0200db6 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200daa:	0b07a703          	lw	a4,176(a5)
ffffffffc0200dae:	8b05                	andi	a4,a4,1
ffffffffc0200db0:	e329                	bnez	a4,ffffffffc0200df2 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200db2:	6f9c                	ld	a5,24(a5)
ffffffffc0200db4:	eb85                	bnez	a5,ffffffffc0200de4 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200db6:	60e2                	ld	ra,24(sp)
ffffffffc0200db8:	6442                	ld	s0,16(sp)
ffffffffc0200dba:	64a2                	ld	s1,8(sp)
ffffffffc0200dbc:	6902                	ld	s2,0(sp)
ffffffffc0200dbe:	6105                	addi	sp,sp,32
ffffffffc0200dc0:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200dc2:	e3fff0ef          	jal	ra,ffffffffc0200c00 <interrupt_handler>
ffffffffc0200dc6:	bff1                	j	ffffffffc0200da2 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dc8:	0006c863          	bltz	a3,ffffffffc0200dd8 <trap+0x66>
}
ffffffffc0200dcc:	6442                	ld	s0,16(sp)
ffffffffc0200dce:	60e2                	ld	ra,24(sp)
ffffffffc0200dd0:	64a2                	ld	s1,8(sp)
ffffffffc0200dd2:	6902                	ld	s2,0(sp)
ffffffffc0200dd4:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200dd6:	bd5d                	j	ffffffffc0200c8c <exception_handler>
}
ffffffffc0200dd8:	6442                	ld	s0,16(sp)
ffffffffc0200dda:	60e2                	ld	ra,24(sp)
ffffffffc0200ddc:	64a2                	ld	s1,8(sp)
ffffffffc0200dde:	6902                	ld	s2,0(sp)
ffffffffc0200de0:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200de2:	bd39                	j	ffffffffc0200c00 <interrupt_handler>
}
ffffffffc0200de4:	6442                	ld	s0,16(sp)
ffffffffc0200de6:	60e2                	ld	ra,24(sp)
ffffffffc0200de8:	64a2                	ld	s1,8(sp)
ffffffffc0200dea:	6902                	ld	s2,0(sp)
ffffffffc0200dec:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200dee:	7800406f          	j	ffffffffc020556e <schedule>
                do_exit(-E_KILLED);
ffffffffc0200df2:	555d                	li	a0,-9
ffffffffc0200df4:	450030ef          	jal	ra,ffffffffc0204244 <do_exit>
            if (current->need_resched)
ffffffffc0200df8:	601c                	ld	a5,0(s0)
ffffffffc0200dfa:	bf65                	j	ffffffffc0200db2 <trap+0x40>

ffffffffc0200dfc <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200dfc:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e00:	00011463          	bnez	sp,ffffffffc0200e08 <__alltraps+0xc>
ffffffffc0200e04:	14002173          	csrr	sp,sscratch
ffffffffc0200e08:	712d                	addi	sp,sp,-288
ffffffffc0200e0a:	e002                	sd	zero,0(sp)
ffffffffc0200e0c:	e406                	sd	ra,8(sp)
ffffffffc0200e0e:	ec0e                	sd	gp,24(sp)
ffffffffc0200e10:	f012                	sd	tp,32(sp)
ffffffffc0200e12:	f416                	sd	t0,40(sp)
ffffffffc0200e14:	f81a                	sd	t1,48(sp)
ffffffffc0200e16:	fc1e                	sd	t2,56(sp)
ffffffffc0200e18:	e0a2                	sd	s0,64(sp)
ffffffffc0200e1a:	e4a6                	sd	s1,72(sp)
ffffffffc0200e1c:	e8aa                	sd	a0,80(sp)
ffffffffc0200e1e:	ecae                	sd	a1,88(sp)
ffffffffc0200e20:	f0b2                	sd	a2,96(sp)
ffffffffc0200e22:	f4b6                	sd	a3,104(sp)
ffffffffc0200e24:	f8ba                	sd	a4,112(sp)
ffffffffc0200e26:	fcbe                	sd	a5,120(sp)
ffffffffc0200e28:	e142                	sd	a6,128(sp)
ffffffffc0200e2a:	e546                	sd	a7,136(sp)
ffffffffc0200e2c:	e94a                	sd	s2,144(sp)
ffffffffc0200e2e:	ed4e                	sd	s3,152(sp)
ffffffffc0200e30:	f152                	sd	s4,160(sp)
ffffffffc0200e32:	f556                	sd	s5,168(sp)
ffffffffc0200e34:	f95a                	sd	s6,176(sp)
ffffffffc0200e36:	fd5e                	sd	s7,184(sp)
ffffffffc0200e38:	e1e2                	sd	s8,192(sp)
ffffffffc0200e3a:	e5e6                	sd	s9,200(sp)
ffffffffc0200e3c:	e9ea                	sd	s10,208(sp)
ffffffffc0200e3e:	edee                	sd	s11,216(sp)
ffffffffc0200e40:	f1f2                	sd	t3,224(sp)
ffffffffc0200e42:	f5f6                	sd	t4,232(sp)
ffffffffc0200e44:	f9fa                	sd	t5,240(sp)
ffffffffc0200e46:	fdfe                	sd	t6,248(sp)
ffffffffc0200e48:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200e4c:	100024f3          	csrr	s1,sstatus
ffffffffc0200e50:	14102973          	csrr	s2,sepc
ffffffffc0200e54:	143029f3          	csrr	s3,stval
ffffffffc0200e58:	14202a73          	csrr	s4,scause
ffffffffc0200e5c:	e822                	sd	s0,16(sp)
ffffffffc0200e5e:	e226                	sd	s1,256(sp)
ffffffffc0200e60:	e64a                	sd	s2,264(sp)
ffffffffc0200e62:	ea4e                	sd	s3,272(sp)
ffffffffc0200e64:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200e66:	850a                	mv	a0,sp
    jal trap
ffffffffc0200e68:	f0bff0ef          	jal	ra,ffffffffc0200d72 <trap>

ffffffffc0200e6c <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200e6c:	6492                	ld	s1,256(sp)
ffffffffc0200e6e:	6932                	ld	s2,264(sp)
ffffffffc0200e70:	1004f413          	andi	s0,s1,256
ffffffffc0200e74:	e401                	bnez	s0,ffffffffc0200e7c <__trapret+0x10>
ffffffffc0200e76:	1200                	addi	s0,sp,288
ffffffffc0200e78:	14041073          	csrw	sscratch,s0
ffffffffc0200e7c:	10049073          	csrw	sstatus,s1
ffffffffc0200e80:	14191073          	csrw	sepc,s2
ffffffffc0200e84:	60a2                	ld	ra,8(sp)
ffffffffc0200e86:	61e2                	ld	gp,24(sp)
ffffffffc0200e88:	7202                	ld	tp,32(sp)
ffffffffc0200e8a:	72a2                	ld	t0,40(sp)
ffffffffc0200e8c:	7342                	ld	t1,48(sp)
ffffffffc0200e8e:	73e2                	ld	t2,56(sp)
ffffffffc0200e90:	6406                	ld	s0,64(sp)
ffffffffc0200e92:	64a6                	ld	s1,72(sp)
ffffffffc0200e94:	6546                	ld	a0,80(sp)
ffffffffc0200e96:	65e6                	ld	a1,88(sp)
ffffffffc0200e98:	7606                	ld	a2,96(sp)
ffffffffc0200e9a:	76a6                	ld	a3,104(sp)
ffffffffc0200e9c:	7746                	ld	a4,112(sp)
ffffffffc0200e9e:	77e6                	ld	a5,120(sp)
ffffffffc0200ea0:	680a                	ld	a6,128(sp)
ffffffffc0200ea2:	68aa                	ld	a7,136(sp)
ffffffffc0200ea4:	694a                	ld	s2,144(sp)
ffffffffc0200ea6:	69ea                	ld	s3,152(sp)
ffffffffc0200ea8:	7a0a                	ld	s4,160(sp)
ffffffffc0200eaa:	7aaa                	ld	s5,168(sp)
ffffffffc0200eac:	7b4a                	ld	s6,176(sp)
ffffffffc0200eae:	7bea                	ld	s7,184(sp)
ffffffffc0200eb0:	6c0e                	ld	s8,192(sp)
ffffffffc0200eb2:	6cae                	ld	s9,200(sp)
ffffffffc0200eb4:	6d4e                	ld	s10,208(sp)
ffffffffc0200eb6:	6dee                	ld	s11,216(sp)
ffffffffc0200eb8:	7e0e                	ld	t3,224(sp)
ffffffffc0200eba:	7eae                	ld	t4,232(sp)
ffffffffc0200ebc:	7f4e                	ld	t5,240(sp)
ffffffffc0200ebe:	7fee                	ld	t6,248(sp)
ffffffffc0200ec0:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200ec2:	10200073          	sret

ffffffffc0200ec6 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200ec6:	812a                	mv	sp,a0
ffffffffc0200ec8:	b755                	j	ffffffffc0200e6c <__trapret>

ffffffffc0200eca <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200eca:	000c2797          	auipc	a5,0xc2
ffffffffc0200ece:	c6678793          	addi	a5,a5,-922 # ffffffffc02c2b30 <free_area>
ffffffffc0200ed2:	e79c                	sd	a5,8(a5)
ffffffffc0200ed4:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200ed6:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200eda:	8082                	ret

ffffffffc0200edc <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200edc:	000c2517          	auipc	a0,0xc2
ffffffffc0200ee0:	c6456503          	lwu	a0,-924(a0) # ffffffffc02c2b40 <free_area+0x10>
ffffffffc0200ee4:	8082                	ret

ffffffffc0200ee6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200ee6:	715d                	addi	sp,sp,-80
ffffffffc0200ee8:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200eea:	000c2417          	auipc	s0,0xc2
ffffffffc0200eee:	c4640413          	addi	s0,s0,-954 # ffffffffc02c2b30 <free_area>
ffffffffc0200ef2:	641c                	ld	a5,8(s0)
ffffffffc0200ef4:	e486                	sd	ra,72(sp)
ffffffffc0200ef6:	fc26                	sd	s1,56(sp)
ffffffffc0200ef8:	f84a                	sd	s2,48(sp)
ffffffffc0200efa:	f44e                	sd	s3,40(sp)
ffffffffc0200efc:	f052                	sd	s4,32(sp)
ffffffffc0200efe:	ec56                	sd	s5,24(sp)
ffffffffc0200f00:	e85a                	sd	s6,16(sp)
ffffffffc0200f02:	e45e                	sd	s7,8(sp)
ffffffffc0200f04:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0200f06:	2a878d63          	beq	a5,s0,ffffffffc02011c0 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200f0a:	4481                	li	s1,0
ffffffffc0200f0c:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200f0e:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200f12:	8b09                	andi	a4,a4,2
ffffffffc0200f14:	2a070a63          	beqz	a4,ffffffffc02011c8 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0200f18:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f1c:	679c                	ld	a5,8(a5)
ffffffffc0200f1e:	2905                	addiw	s2,s2,1
ffffffffc0200f20:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0200f22:	fe8796e3          	bne	a5,s0,ffffffffc0200f0e <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200f26:	89a6                	mv	s3,s1
ffffffffc0200f28:	6df000ef          	jal	ra,ffffffffc0201e06 <nr_free_pages>
ffffffffc0200f2c:	6f351e63          	bne	a0,s3,ffffffffc0201628 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f30:	4505                	li	a0,1
ffffffffc0200f32:	657000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc0200f36:	8aaa                	mv	s5,a0
ffffffffc0200f38:	42050863          	beqz	a0,ffffffffc0201368 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f3c:	4505                	li	a0,1
ffffffffc0200f3e:	64b000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc0200f42:	89aa                	mv	s3,a0
ffffffffc0200f44:	70050263          	beqz	a0,ffffffffc0201648 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f48:	4505                	li	a0,1
ffffffffc0200f4a:	63f000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc0200f4e:	8a2a                	mv	s4,a0
ffffffffc0200f50:	48050c63          	beqz	a0,ffffffffc02013e8 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200f54:	293a8a63          	beq	s5,s3,ffffffffc02011e8 <default_check+0x302>
ffffffffc0200f58:	28aa8863          	beq	s5,a0,ffffffffc02011e8 <default_check+0x302>
ffffffffc0200f5c:	28a98663          	beq	s3,a0,ffffffffc02011e8 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200f60:	000aa783          	lw	a5,0(s5)
ffffffffc0200f64:	2a079263          	bnez	a5,ffffffffc0201208 <default_check+0x322>
ffffffffc0200f68:	0009a783          	lw	a5,0(s3)
ffffffffc0200f6c:	28079e63          	bnez	a5,ffffffffc0201208 <default_check+0x322>
ffffffffc0200f70:	411c                	lw	a5,0(a0)
ffffffffc0200f72:	28079b63          	bnez	a5,ffffffffc0201208 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200f76:	000c6797          	auipc	a5,0xc6
ffffffffc0200f7a:	c527b783          	ld	a5,-942(a5) # ffffffffc02c6bc8 <pages>
ffffffffc0200f7e:	40fa8733          	sub	a4,s5,a5
ffffffffc0200f82:	00007617          	auipc	a2,0x7
ffffffffc0200f86:	4ee63603          	ld	a2,1262(a2) # ffffffffc0208470 <nbase>
ffffffffc0200f8a:	8719                	srai	a4,a4,0x6
ffffffffc0200f8c:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200f8e:	000c6697          	auipc	a3,0xc6
ffffffffc0200f92:	c326b683          	ld	a3,-974(a3) # ffffffffc02c6bc0 <npage>
ffffffffc0200f96:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f98:	0732                	slli	a4,a4,0xc
ffffffffc0200f9a:	28d77763          	bgeu	a4,a3,ffffffffc0201228 <default_check+0x342>
    return page - pages + nbase;
ffffffffc0200f9e:	40f98733          	sub	a4,s3,a5
ffffffffc0200fa2:	8719                	srai	a4,a4,0x6
ffffffffc0200fa4:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200fa6:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200fa8:	4cd77063          	bgeu	a4,a3,ffffffffc0201468 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0200fac:	40f507b3          	sub	a5,a0,a5
ffffffffc0200fb0:	8799                	srai	a5,a5,0x6
ffffffffc0200fb2:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200fb4:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200fb6:	30d7f963          	bgeu	a5,a3,ffffffffc02012c8 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0200fba:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200fbc:	00043c03          	ld	s8,0(s0)
ffffffffc0200fc0:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200fc4:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200fc8:	e400                	sd	s0,8(s0)
ffffffffc0200fca:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200fcc:	000c2797          	auipc	a5,0xc2
ffffffffc0200fd0:	b607aa23          	sw	zero,-1164(a5) # ffffffffc02c2b40 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200fd4:	5b5000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc0200fd8:	2c051863          	bnez	a0,ffffffffc02012a8 <default_check+0x3c2>
    free_page(p0);
ffffffffc0200fdc:	4585                	li	a1,1
ffffffffc0200fde:	8556                	mv	a0,s5
ffffffffc0200fe0:	5e7000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    free_page(p1);
ffffffffc0200fe4:	4585                	li	a1,1
ffffffffc0200fe6:	854e                	mv	a0,s3
ffffffffc0200fe8:	5df000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    free_page(p2);
ffffffffc0200fec:	4585                	li	a1,1
ffffffffc0200fee:	8552                	mv	a0,s4
ffffffffc0200ff0:	5d7000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    assert(nr_free == 3);
ffffffffc0200ff4:	4818                	lw	a4,16(s0)
ffffffffc0200ff6:	478d                	li	a5,3
ffffffffc0200ff8:	28f71863          	bne	a4,a5,ffffffffc0201288 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ffc:	4505                	li	a0,1
ffffffffc0200ffe:	58b000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc0201002:	89aa                	mv	s3,a0
ffffffffc0201004:	26050263          	beqz	a0,ffffffffc0201268 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201008:	4505                	li	a0,1
ffffffffc020100a:	57f000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020100e:	8aaa                	mv	s5,a0
ffffffffc0201010:	3a050c63          	beqz	a0,ffffffffc02013c8 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201014:	4505                	li	a0,1
ffffffffc0201016:	573000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020101a:	8a2a                	mv	s4,a0
ffffffffc020101c:	38050663          	beqz	a0,ffffffffc02013a8 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201020:	4505                	li	a0,1
ffffffffc0201022:	567000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc0201026:	36051163          	bnez	a0,ffffffffc0201388 <default_check+0x4a2>
    free_page(p0);
ffffffffc020102a:	4585                	li	a1,1
ffffffffc020102c:	854e                	mv	a0,s3
ffffffffc020102e:	599000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201032:	641c                	ld	a5,8(s0)
ffffffffc0201034:	20878a63          	beq	a5,s0,ffffffffc0201248 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201038:	4505                	li	a0,1
ffffffffc020103a:	54f000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020103e:	30a99563          	bne	s3,a0,ffffffffc0201348 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201042:	4505                	li	a0,1
ffffffffc0201044:	545000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc0201048:	2e051063          	bnez	a0,ffffffffc0201328 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc020104c:	481c                	lw	a5,16(s0)
ffffffffc020104e:	2a079d63          	bnez	a5,ffffffffc0201308 <default_check+0x422>
    free_page(p);
ffffffffc0201052:	854e                	mv	a0,s3
ffffffffc0201054:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201056:	01843023          	sd	s8,0(s0)
ffffffffc020105a:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020105e:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201062:	565000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    free_page(p1);
ffffffffc0201066:	4585                	li	a1,1
ffffffffc0201068:	8556                	mv	a0,s5
ffffffffc020106a:	55d000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    free_page(p2);
ffffffffc020106e:	4585                	li	a1,1
ffffffffc0201070:	8552                	mv	a0,s4
ffffffffc0201072:	555000ef          	jal	ra,ffffffffc0201dc6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201076:	4515                	li	a0,5
ffffffffc0201078:	511000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020107c:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020107e:	26050563          	beqz	a0,ffffffffc02012e8 <default_check+0x402>
ffffffffc0201082:	651c                	ld	a5,8(a0)
ffffffffc0201084:	8385                	srli	a5,a5,0x1
ffffffffc0201086:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201088:	54079063          	bnez	a5,ffffffffc02015c8 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020108c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020108e:	00043b03          	ld	s6,0(s0)
ffffffffc0201092:	00843a83          	ld	s5,8(s0)
ffffffffc0201096:	e000                	sd	s0,0(s0)
ffffffffc0201098:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc020109a:	4ef000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020109e:	50051563          	bnez	a0,ffffffffc02015a8 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02010a2:	08098a13          	addi	s4,s3,128
ffffffffc02010a6:	8552                	mv	a0,s4
ffffffffc02010a8:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02010aa:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02010ae:	000c2797          	auipc	a5,0xc2
ffffffffc02010b2:	a807a923          	sw	zero,-1390(a5) # ffffffffc02c2b40 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02010b6:	511000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02010ba:	4511                	li	a0,4
ffffffffc02010bc:	4cd000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc02010c0:	4c051463          	bnez	a0,ffffffffc0201588 <default_check+0x6a2>
ffffffffc02010c4:	0889b783          	ld	a5,136(s3)
ffffffffc02010c8:	8385                	srli	a5,a5,0x1
ffffffffc02010ca:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02010cc:	48078e63          	beqz	a5,ffffffffc0201568 <default_check+0x682>
ffffffffc02010d0:	0909a703          	lw	a4,144(s3)
ffffffffc02010d4:	478d                	li	a5,3
ffffffffc02010d6:	48f71963          	bne	a4,a5,ffffffffc0201568 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02010da:	450d                	li	a0,3
ffffffffc02010dc:	4ad000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc02010e0:	8c2a                	mv	s8,a0
ffffffffc02010e2:	46050363          	beqz	a0,ffffffffc0201548 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02010e6:	4505                	li	a0,1
ffffffffc02010e8:	4a1000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc02010ec:	42051e63          	bnez	a0,ffffffffc0201528 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc02010f0:	418a1c63          	bne	s4,s8,ffffffffc0201508 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02010f4:	4585                	li	a1,1
ffffffffc02010f6:	854e                	mv	a0,s3
ffffffffc02010f8:	4cf000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    free_pages(p1, 3);
ffffffffc02010fc:	458d                	li	a1,3
ffffffffc02010fe:	8552                	mv	a0,s4
ffffffffc0201100:	4c7000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
ffffffffc0201104:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201108:	04098c13          	addi	s8,s3,64
ffffffffc020110c:	8385                	srli	a5,a5,0x1
ffffffffc020110e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201110:	3c078c63          	beqz	a5,ffffffffc02014e8 <default_check+0x602>
ffffffffc0201114:	0109a703          	lw	a4,16(s3)
ffffffffc0201118:	4785                	li	a5,1
ffffffffc020111a:	3cf71763          	bne	a4,a5,ffffffffc02014e8 <default_check+0x602>
ffffffffc020111e:	008a3783          	ld	a5,8(s4)
ffffffffc0201122:	8385                	srli	a5,a5,0x1
ffffffffc0201124:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201126:	3a078163          	beqz	a5,ffffffffc02014c8 <default_check+0x5e2>
ffffffffc020112a:	010a2703          	lw	a4,16(s4)
ffffffffc020112e:	478d                	li	a5,3
ffffffffc0201130:	38f71c63          	bne	a4,a5,ffffffffc02014c8 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201134:	4505                	li	a0,1
ffffffffc0201136:	453000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020113a:	36a99763          	bne	s3,a0,ffffffffc02014a8 <default_check+0x5c2>
    free_page(p0);
ffffffffc020113e:	4585                	li	a1,1
ffffffffc0201140:	487000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201144:	4509                	li	a0,2
ffffffffc0201146:	443000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020114a:	32aa1f63          	bne	s4,a0,ffffffffc0201488 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020114e:	4589                	li	a1,2
ffffffffc0201150:	477000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    free_page(p2);
ffffffffc0201154:	4585                	li	a1,1
ffffffffc0201156:	8562                	mv	a0,s8
ffffffffc0201158:	46f000ef          	jal	ra,ffffffffc0201dc6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020115c:	4515                	li	a0,5
ffffffffc020115e:	42b000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc0201162:	89aa                	mv	s3,a0
ffffffffc0201164:	48050263          	beqz	a0,ffffffffc02015e8 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201168:	4505                	li	a0,1
ffffffffc020116a:	41f000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020116e:	2c051d63          	bnez	a0,ffffffffc0201448 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201172:	481c                	lw	a5,16(s0)
ffffffffc0201174:	2a079a63          	bnez	a5,ffffffffc0201428 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201178:	4595                	li	a1,5
ffffffffc020117a:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc020117c:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201180:	01643023          	sd	s6,0(s0)
ffffffffc0201184:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201188:	43f000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    return listelm->next;
ffffffffc020118c:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020118e:	00878963          	beq	a5,s0,ffffffffc02011a0 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201192:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201196:	679c                	ld	a5,8(a5)
ffffffffc0201198:	397d                	addiw	s2,s2,-1
ffffffffc020119a:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020119c:	fe879be3          	bne	a5,s0,ffffffffc0201192 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02011a0:	26091463          	bnez	s2,ffffffffc0201408 <default_check+0x522>
    assert(total == 0);
ffffffffc02011a4:	46049263          	bnez	s1,ffffffffc0201608 <default_check+0x722>
}
ffffffffc02011a8:	60a6                	ld	ra,72(sp)
ffffffffc02011aa:	6406                	ld	s0,64(sp)
ffffffffc02011ac:	74e2                	ld	s1,56(sp)
ffffffffc02011ae:	7942                	ld	s2,48(sp)
ffffffffc02011b0:	79a2                	ld	s3,40(sp)
ffffffffc02011b2:	7a02                	ld	s4,32(sp)
ffffffffc02011b4:	6ae2                	ld	s5,24(sp)
ffffffffc02011b6:	6b42                	ld	s6,16(sp)
ffffffffc02011b8:	6ba2                	ld	s7,8(sp)
ffffffffc02011ba:	6c02                	ld	s8,0(sp)
ffffffffc02011bc:	6161                	addi	sp,sp,80
ffffffffc02011be:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02011c0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02011c2:	4481                	li	s1,0
ffffffffc02011c4:	4901                	li	s2,0
ffffffffc02011c6:	b38d                	j	ffffffffc0200f28 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02011c8:	00005697          	auipc	a3,0x5
ffffffffc02011cc:	4a868693          	addi	a3,a3,1192 # ffffffffc0206670 <commands+0x808>
ffffffffc02011d0:	00005617          	auipc	a2,0x5
ffffffffc02011d4:	4b060613          	addi	a2,a2,1200 # ffffffffc0206680 <commands+0x818>
ffffffffc02011d8:	11000593          	li	a1,272
ffffffffc02011dc:	00005517          	auipc	a0,0x5
ffffffffc02011e0:	4bc50513          	addi	a0,a0,1212 # ffffffffc0206698 <commands+0x830>
ffffffffc02011e4:	aaeff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02011e8:	00005697          	auipc	a3,0x5
ffffffffc02011ec:	54868693          	addi	a3,a3,1352 # ffffffffc0206730 <commands+0x8c8>
ffffffffc02011f0:	00005617          	auipc	a2,0x5
ffffffffc02011f4:	49060613          	addi	a2,a2,1168 # ffffffffc0206680 <commands+0x818>
ffffffffc02011f8:	0db00593          	li	a1,219
ffffffffc02011fc:	00005517          	auipc	a0,0x5
ffffffffc0201200:	49c50513          	addi	a0,a0,1180 # ffffffffc0206698 <commands+0x830>
ffffffffc0201204:	a8eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201208:	00005697          	auipc	a3,0x5
ffffffffc020120c:	55068693          	addi	a3,a3,1360 # ffffffffc0206758 <commands+0x8f0>
ffffffffc0201210:	00005617          	auipc	a2,0x5
ffffffffc0201214:	47060613          	addi	a2,a2,1136 # ffffffffc0206680 <commands+0x818>
ffffffffc0201218:	0dc00593          	li	a1,220
ffffffffc020121c:	00005517          	auipc	a0,0x5
ffffffffc0201220:	47c50513          	addi	a0,a0,1148 # ffffffffc0206698 <commands+0x830>
ffffffffc0201224:	a6eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201228:	00005697          	auipc	a3,0x5
ffffffffc020122c:	57068693          	addi	a3,a3,1392 # ffffffffc0206798 <commands+0x930>
ffffffffc0201230:	00005617          	auipc	a2,0x5
ffffffffc0201234:	45060613          	addi	a2,a2,1104 # ffffffffc0206680 <commands+0x818>
ffffffffc0201238:	0de00593          	li	a1,222
ffffffffc020123c:	00005517          	auipc	a0,0x5
ffffffffc0201240:	45c50513          	addi	a0,a0,1116 # ffffffffc0206698 <commands+0x830>
ffffffffc0201244:	a4eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201248:	00005697          	auipc	a3,0x5
ffffffffc020124c:	5d868693          	addi	a3,a3,1496 # ffffffffc0206820 <commands+0x9b8>
ffffffffc0201250:	00005617          	auipc	a2,0x5
ffffffffc0201254:	43060613          	addi	a2,a2,1072 # ffffffffc0206680 <commands+0x818>
ffffffffc0201258:	0f700593          	li	a1,247
ffffffffc020125c:	00005517          	auipc	a0,0x5
ffffffffc0201260:	43c50513          	addi	a0,a0,1084 # ffffffffc0206698 <commands+0x830>
ffffffffc0201264:	a2eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201268:	00005697          	auipc	a3,0x5
ffffffffc020126c:	46868693          	addi	a3,a3,1128 # ffffffffc02066d0 <commands+0x868>
ffffffffc0201270:	00005617          	auipc	a2,0x5
ffffffffc0201274:	41060613          	addi	a2,a2,1040 # ffffffffc0206680 <commands+0x818>
ffffffffc0201278:	0f000593          	li	a1,240
ffffffffc020127c:	00005517          	auipc	a0,0x5
ffffffffc0201280:	41c50513          	addi	a0,a0,1052 # ffffffffc0206698 <commands+0x830>
ffffffffc0201284:	a0eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 3);
ffffffffc0201288:	00005697          	auipc	a3,0x5
ffffffffc020128c:	58868693          	addi	a3,a3,1416 # ffffffffc0206810 <commands+0x9a8>
ffffffffc0201290:	00005617          	auipc	a2,0x5
ffffffffc0201294:	3f060613          	addi	a2,a2,1008 # ffffffffc0206680 <commands+0x818>
ffffffffc0201298:	0ee00593          	li	a1,238
ffffffffc020129c:	00005517          	auipc	a0,0x5
ffffffffc02012a0:	3fc50513          	addi	a0,a0,1020 # ffffffffc0206698 <commands+0x830>
ffffffffc02012a4:	9eeff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012a8:	00005697          	auipc	a3,0x5
ffffffffc02012ac:	55068693          	addi	a3,a3,1360 # ffffffffc02067f8 <commands+0x990>
ffffffffc02012b0:	00005617          	auipc	a2,0x5
ffffffffc02012b4:	3d060613          	addi	a2,a2,976 # ffffffffc0206680 <commands+0x818>
ffffffffc02012b8:	0e900593          	li	a1,233
ffffffffc02012bc:	00005517          	auipc	a0,0x5
ffffffffc02012c0:	3dc50513          	addi	a0,a0,988 # ffffffffc0206698 <commands+0x830>
ffffffffc02012c4:	9ceff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02012c8:	00005697          	auipc	a3,0x5
ffffffffc02012cc:	51068693          	addi	a3,a3,1296 # ffffffffc02067d8 <commands+0x970>
ffffffffc02012d0:	00005617          	auipc	a2,0x5
ffffffffc02012d4:	3b060613          	addi	a2,a2,944 # ffffffffc0206680 <commands+0x818>
ffffffffc02012d8:	0e000593          	li	a1,224
ffffffffc02012dc:	00005517          	auipc	a0,0x5
ffffffffc02012e0:	3bc50513          	addi	a0,a0,956 # ffffffffc0206698 <commands+0x830>
ffffffffc02012e4:	9aeff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 != NULL);
ffffffffc02012e8:	00005697          	auipc	a3,0x5
ffffffffc02012ec:	58068693          	addi	a3,a3,1408 # ffffffffc0206868 <commands+0xa00>
ffffffffc02012f0:	00005617          	auipc	a2,0x5
ffffffffc02012f4:	39060613          	addi	a2,a2,912 # ffffffffc0206680 <commands+0x818>
ffffffffc02012f8:	11800593          	li	a1,280
ffffffffc02012fc:	00005517          	auipc	a0,0x5
ffffffffc0201300:	39c50513          	addi	a0,a0,924 # ffffffffc0206698 <commands+0x830>
ffffffffc0201304:	98eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 0);
ffffffffc0201308:	00005697          	auipc	a3,0x5
ffffffffc020130c:	55068693          	addi	a3,a3,1360 # ffffffffc0206858 <commands+0x9f0>
ffffffffc0201310:	00005617          	auipc	a2,0x5
ffffffffc0201314:	37060613          	addi	a2,a2,880 # ffffffffc0206680 <commands+0x818>
ffffffffc0201318:	0fd00593          	li	a1,253
ffffffffc020131c:	00005517          	auipc	a0,0x5
ffffffffc0201320:	37c50513          	addi	a0,a0,892 # ffffffffc0206698 <commands+0x830>
ffffffffc0201324:	96eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201328:	00005697          	auipc	a3,0x5
ffffffffc020132c:	4d068693          	addi	a3,a3,1232 # ffffffffc02067f8 <commands+0x990>
ffffffffc0201330:	00005617          	auipc	a2,0x5
ffffffffc0201334:	35060613          	addi	a2,a2,848 # ffffffffc0206680 <commands+0x818>
ffffffffc0201338:	0fb00593          	li	a1,251
ffffffffc020133c:	00005517          	auipc	a0,0x5
ffffffffc0201340:	35c50513          	addi	a0,a0,860 # ffffffffc0206698 <commands+0x830>
ffffffffc0201344:	94eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201348:	00005697          	auipc	a3,0x5
ffffffffc020134c:	4f068693          	addi	a3,a3,1264 # ffffffffc0206838 <commands+0x9d0>
ffffffffc0201350:	00005617          	auipc	a2,0x5
ffffffffc0201354:	33060613          	addi	a2,a2,816 # ffffffffc0206680 <commands+0x818>
ffffffffc0201358:	0fa00593          	li	a1,250
ffffffffc020135c:	00005517          	auipc	a0,0x5
ffffffffc0201360:	33c50513          	addi	a0,a0,828 # ffffffffc0206698 <commands+0x830>
ffffffffc0201364:	92eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201368:	00005697          	auipc	a3,0x5
ffffffffc020136c:	36868693          	addi	a3,a3,872 # ffffffffc02066d0 <commands+0x868>
ffffffffc0201370:	00005617          	auipc	a2,0x5
ffffffffc0201374:	31060613          	addi	a2,a2,784 # ffffffffc0206680 <commands+0x818>
ffffffffc0201378:	0d700593          	li	a1,215
ffffffffc020137c:	00005517          	auipc	a0,0x5
ffffffffc0201380:	31c50513          	addi	a0,a0,796 # ffffffffc0206698 <commands+0x830>
ffffffffc0201384:	90eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201388:	00005697          	auipc	a3,0x5
ffffffffc020138c:	47068693          	addi	a3,a3,1136 # ffffffffc02067f8 <commands+0x990>
ffffffffc0201390:	00005617          	auipc	a2,0x5
ffffffffc0201394:	2f060613          	addi	a2,a2,752 # ffffffffc0206680 <commands+0x818>
ffffffffc0201398:	0f400593          	li	a1,244
ffffffffc020139c:	00005517          	auipc	a0,0x5
ffffffffc02013a0:	2fc50513          	addi	a0,a0,764 # ffffffffc0206698 <commands+0x830>
ffffffffc02013a4:	8eeff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013a8:	00005697          	auipc	a3,0x5
ffffffffc02013ac:	36868693          	addi	a3,a3,872 # ffffffffc0206710 <commands+0x8a8>
ffffffffc02013b0:	00005617          	auipc	a2,0x5
ffffffffc02013b4:	2d060613          	addi	a2,a2,720 # ffffffffc0206680 <commands+0x818>
ffffffffc02013b8:	0f200593          	li	a1,242
ffffffffc02013bc:	00005517          	auipc	a0,0x5
ffffffffc02013c0:	2dc50513          	addi	a0,a0,732 # ffffffffc0206698 <commands+0x830>
ffffffffc02013c4:	8ceff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02013c8:	00005697          	auipc	a3,0x5
ffffffffc02013cc:	32868693          	addi	a3,a3,808 # ffffffffc02066f0 <commands+0x888>
ffffffffc02013d0:	00005617          	auipc	a2,0x5
ffffffffc02013d4:	2b060613          	addi	a2,a2,688 # ffffffffc0206680 <commands+0x818>
ffffffffc02013d8:	0f100593          	li	a1,241
ffffffffc02013dc:	00005517          	auipc	a0,0x5
ffffffffc02013e0:	2bc50513          	addi	a0,a0,700 # ffffffffc0206698 <commands+0x830>
ffffffffc02013e4:	8aeff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013e8:	00005697          	auipc	a3,0x5
ffffffffc02013ec:	32868693          	addi	a3,a3,808 # ffffffffc0206710 <commands+0x8a8>
ffffffffc02013f0:	00005617          	auipc	a2,0x5
ffffffffc02013f4:	29060613          	addi	a2,a2,656 # ffffffffc0206680 <commands+0x818>
ffffffffc02013f8:	0d900593          	li	a1,217
ffffffffc02013fc:	00005517          	auipc	a0,0x5
ffffffffc0201400:	29c50513          	addi	a0,a0,668 # ffffffffc0206698 <commands+0x830>
ffffffffc0201404:	88eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(count == 0);
ffffffffc0201408:	00005697          	auipc	a3,0x5
ffffffffc020140c:	5b068693          	addi	a3,a3,1456 # ffffffffc02069b8 <commands+0xb50>
ffffffffc0201410:	00005617          	auipc	a2,0x5
ffffffffc0201414:	27060613          	addi	a2,a2,624 # ffffffffc0206680 <commands+0x818>
ffffffffc0201418:	14600593          	li	a1,326
ffffffffc020141c:	00005517          	auipc	a0,0x5
ffffffffc0201420:	27c50513          	addi	a0,a0,636 # ffffffffc0206698 <commands+0x830>
ffffffffc0201424:	86eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 0);
ffffffffc0201428:	00005697          	auipc	a3,0x5
ffffffffc020142c:	43068693          	addi	a3,a3,1072 # ffffffffc0206858 <commands+0x9f0>
ffffffffc0201430:	00005617          	auipc	a2,0x5
ffffffffc0201434:	25060613          	addi	a2,a2,592 # ffffffffc0206680 <commands+0x818>
ffffffffc0201438:	13a00593          	li	a1,314
ffffffffc020143c:	00005517          	auipc	a0,0x5
ffffffffc0201440:	25c50513          	addi	a0,a0,604 # ffffffffc0206698 <commands+0x830>
ffffffffc0201444:	84eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201448:	00005697          	auipc	a3,0x5
ffffffffc020144c:	3b068693          	addi	a3,a3,944 # ffffffffc02067f8 <commands+0x990>
ffffffffc0201450:	00005617          	auipc	a2,0x5
ffffffffc0201454:	23060613          	addi	a2,a2,560 # ffffffffc0206680 <commands+0x818>
ffffffffc0201458:	13800593          	li	a1,312
ffffffffc020145c:	00005517          	auipc	a0,0x5
ffffffffc0201460:	23c50513          	addi	a0,a0,572 # ffffffffc0206698 <commands+0x830>
ffffffffc0201464:	82eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201468:	00005697          	auipc	a3,0x5
ffffffffc020146c:	35068693          	addi	a3,a3,848 # ffffffffc02067b8 <commands+0x950>
ffffffffc0201470:	00005617          	auipc	a2,0x5
ffffffffc0201474:	21060613          	addi	a2,a2,528 # ffffffffc0206680 <commands+0x818>
ffffffffc0201478:	0df00593          	li	a1,223
ffffffffc020147c:	00005517          	auipc	a0,0x5
ffffffffc0201480:	21c50513          	addi	a0,a0,540 # ffffffffc0206698 <commands+0x830>
ffffffffc0201484:	80eff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201488:	00005697          	auipc	a3,0x5
ffffffffc020148c:	4f068693          	addi	a3,a3,1264 # ffffffffc0206978 <commands+0xb10>
ffffffffc0201490:	00005617          	auipc	a2,0x5
ffffffffc0201494:	1f060613          	addi	a2,a2,496 # ffffffffc0206680 <commands+0x818>
ffffffffc0201498:	13200593          	li	a1,306
ffffffffc020149c:	00005517          	auipc	a0,0x5
ffffffffc02014a0:	1fc50513          	addi	a0,a0,508 # ffffffffc0206698 <commands+0x830>
ffffffffc02014a4:	feffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02014a8:	00005697          	auipc	a3,0x5
ffffffffc02014ac:	4b068693          	addi	a3,a3,1200 # ffffffffc0206958 <commands+0xaf0>
ffffffffc02014b0:	00005617          	auipc	a2,0x5
ffffffffc02014b4:	1d060613          	addi	a2,a2,464 # ffffffffc0206680 <commands+0x818>
ffffffffc02014b8:	13000593          	li	a1,304
ffffffffc02014bc:	00005517          	auipc	a0,0x5
ffffffffc02014c0:	1dc50513          	addi	a0,a0,476 # ffffffffc0206698 <commands+0x830>
ffffffffc02014c4:	fcffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02014c8:	00005697          	auipc	a3,0x5
ffffffffc02014cc:	46868693          	addi	a3,a3,1128 # ffffffffc0206930 <commands+0xac8>
ffffffffc02014d0:	00005617          	auipc	a2,0x5
ffffffffc02014d4:	1b060613          	addi	a2,a2,432 # ffffffffc0206680 <commands+0x818>
ffffffffc02014d8:	12e00593          	li	a1,302
ffffffffc02014dc:	00005517          	auipc	a0,0x5
ffffffffc02014e0:	1bc50513          	addi	a0,a0,444 # ffffffffc0206698 <commands+0x830>
ffffffffc02014e4:	faffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02014e8:	00005697          	auipc	a3,0x5
ffffffffc02014ec:	42068693          	addi	a3,a3,1056 # ffffffffc0206908 <commands+0xaa0>
ffffffffc02014f0:	00005617          	auipc	a2,0x5
ffffffffc02014f4:	19060613          	addi	a2,a2,400 # ffffffffc0206680 <commands+0x818>
ffffffffc02014f8:	12d00593          	li	a1,301
ffffffffc02014fc:	00005517          	auipc	a0,0x5
ffffffffc0201500:	19c50513          	addi	a0,a0,412 # ffffffffc0206698 <commands+0x830>
ffffffffc0201504:	f8ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201508:	00005697          	auipc	a3,0x5
ffffffffc020150c:	3f068693          	addi	a3,a3,1008 # ffffffffc02068f8 <commands+0xa90>
ffffffffc0201510:	00005617          	auipc	a2,0x5
ffffffffc0201514:	17060613          	addi	a2,a2,368 # ffffffffc0206680 <commands+0x818>
ffffffffc0201518:	12800593          	li	a1,296
ffffffffc020151c:	00005517          	auipc	a0,0x5
ffffffffc0201520:	17c50513          	addi	a0,a0,380 # ffffffffc0206698 <commands+0x830>
ffffffffc0201524:	f6ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201528:	00005697          	auipc	a3,0x5
ffffffffc020152c:	2d068693          	addi	a3,a3,720 # ffffffffc02067f8 <commands+0x990>
ffffffffc0201530:	00005617          	auipc	a2,0x5
ffffffffc0201534:	15060613          	addi	a2,a2,336 # ffffffffc0206680 <commands+0x818>
ffffffffc0201538:	12700593          	li	a1,295
ffffffffc020153c:	00005517          	auipc	a0,0x5
ffffffffc0201540:	15c50513          	addi	a0,a0,348 # ffffffffc0206698 <commands+0x830>
ffffffffc0201544:	f4ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201548:	00005697          	auipc	a3,0x5
ffffffffc020154c:	39068693          	addi	a3,a3,912 # ffffffffc02068d8 <commands+0xa70>
ffffffffc0201550:	00005617          	auipc	a2,0x5
ffffffffc0201554:	13060613          	addi	a2,a2,304 # ffffffffc0206680 <commands+0x818>
ffffffffc0201558:	12600593          	li	a1,294
ffffffffc020155c:	00005517          	auipc	a0,0x5
ffffffffc0201560:	13c50513          	addi	a0,a0,316 # ffffffffc0206698 <commands+0x830>
ffffffffc0201564:	f2ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201568:	00005697          	auipc	a3,0x5
ffffffffc020156c:	34068693          	addi	a3,a3,832 # ffffffffc02068a8 <commands+0xa40>
ffffffffc0201570:	00005617          	auipc	a2,0x5
ffffffffc0201574:	11060613          	addi	a2,a2,272 # ffffffffc0206680 <commands+0x818>
ffffffffc0201578:	12500593          	li	a1,293
ffffffffc020157c:	00005517          	auipc	a0,0x5
ffffffffc0201580:	11c50513          	addi	a0,a0,284 # ffffffffc0206698 <commands+0x830>
ffffffffc0201584:	f0ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201588:	00005697          	auipc	a3,0x5
ffffffffc020158c:	30868693          	addi	a3,a3,776 # ffffffffc0206890 <commands+0xa28>
ffffffffc0201590:	00005617          	auipc	a2,0x5
ffffffffc0201594:	0f060613          	addi	a2,a2,240 # ffffffffc0206680 <commands+0x818>
ffffffffc0201598:	12400593          	li	a1,292
ffffffffc020159c:	00005517          	auipc	a0,0x5
ffffffffc02015a0:	0fc50513          	addi	a0,a0,252 # ffffffffc0206698 <commands+0x830>
ffffffffc02015a4:	eeffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015a8:	00005697          	auipc	a3,0x5
ffffffffc02015ac:	25068693          	addi	a3,a3,592 # ffffffffc02067f8 <commands+0x990>
ffffffffc02015b0:	00005617          	auipc	a2,0x5
ffffffffc02015b4:	0d060613          	addi	a2,a2,208 # ffffffffc0206680 <commands+0x818>
ffffffffc02015b8:	11e00593          	li	a1,286
ffffffffc02015bc:	00005517          	auipc	a0,0x5
ffffffffc02015c0:	0dc50513          	addi	a0,a0,220 # ffffffffc0206698 <commands+0x830>
ffffffffc02015c4:	ecffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(!PageProperty(p0));
ffffffffc02015c8:	00005697          	auipc	a3,0x5
ffffffffc02015cc:	2b068693          	addi	a3,a3,688 # ffffffffc0206878 <commands+0xa10>
ffffffffc02015d0:	00005617          	auipc	a2,0x5
ffffffffc02015d4:	0b060613          	addi	a2,a2,176 # ffffffffc0206680 <commands+0x818>
ffffffffc02015d8:	11900593          	li	a1,281
ffffffffc02015dc:	00005517          	auipc	a0,0x5
ffffffffc02015e0:	0bc50513          	addi	a0,a0,188 # ffffffffc0206698 <commands+0x830>
ffffffffc02015e4:	eaffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02015e8:	00005697          	auipc	a3,0x5
ffffffffc02015ec:	3b068693          	addi	a3,a3,944 # ffffffffc0206998 <commands+0xb30>
ffffffffc02015f0:	00005617          	auipc	a2,0x5
ffffffffc02015f4:	09060613          	addi	a2,a2,144 # ffffffffc0206680 <commands+0x818>
ffffffffc02015f8:	13700593          	li	a1,311
ffffffffc02015fc:	00005517          	auipc	a0,0x5
ffffffffc0201600:	09c50513          	addi	a0,a0,156 # ffffffffc0206698 <commands+0x830>
ffffffffc0201604:	e8ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(total == 0);
ffffffffc0201608:	00005697          	auipc	a3,0x5
ffffffffc020160c:	3c068693          	addi	a3,a3,960 # ffffffffc02069c8 <commands+0xb60>
ffffffffc0201610:	00005617          	auipc	a2,0x5
ffffffffc0201614:	07060613          	addi	a2,a2,112 # ffffffffc0206680 <commands+0x818>
ffffffffc0201618:	14700593          	li	a1,327
ffffffffc020161c:	00005517          	auipc	a0,0x5
ffffffffc0201620:	07c50513          	addi	a0,a0,124 # ffffffffc0206698 <commands+0x830>
ffffffffc0201624:	e6ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201628:	00005697          	auipc	a3,0x5
ffffffffc020162c:	08868693          	addi	a3,a3,136 # ffffffffc02066b0 <commands+0x848>
ffffffffc0201630:	00005617          	auipc	a2,0x5
ffffffffc0201634:	05060613          	addi	a2,a2,80 # ffffffffc0206680 <commands+0x818>
ffffffffc0201638:	11300593          	li	a1,275
ffffffffc020163c:	00005517          	auipc	a0,0x5
ffffffffc0201640:	05c50513          	addi	a0,a0,92 # ffffffffc0206698 <commands+0x830>
ffffffffc0201644:	e4ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201648:	00005697          	auipc	a3,0x5
ffffffffc020164c:	0a868693          	addi	a3,a3,168 # ffffffffc02066f0 <commands+0x888>
ffffffffc0201650:	00005617          	auipc	a2,0x5
ffffffffc0201654:	03060613          	addi	a2,a2,48 # ffffffffc0206680 <commands+0x818>
ffffffffc0201658:	0d800593          	li	a1,216
ffffffffc020165c:	00005517          	auipc	a0,0x5
ffffffffc0201660:	03c50513          	addi	a0,a0,60 # ffffffffc0206698 <commands+0x830>
ffffffffc0201664:	e2ffe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201668 <default_free_pages>:
{
ffffffffc0201668:	1141                	addi	sp,sp,-16
ffffffffc020166a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020166c:	14058463          	beqz	a1,ffffffffc02017b4 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201670:	00659693          	slli	a3,a1,0x6
ffffffffc0201674:	96aa                	add	a3,a3,a0
ffffffffc0201676:	87aa                	mv	a5,a0
ffffffffc0201678:	02d50263          	beq	a0,a3,ffffffffc020169c <default_free_pages+0x34>
ffffffffc020167c:	6798                	ld	a4,8(a5)
ffffffffc020167e:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201680:	10071a63          	bnez	a4,ffffffffc0201794 <default_free_pages+0x12c>
ffffffffc0201684:	6798                	ld	a4,8(a5)
ffffffffc0201686:	8b09                	andi	a4,a4,2
ffffffffc0201688:	10071663          	bnez	a4,ffffffffc0201794 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc020168c:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201690:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201694:	04078793          	addi	a5,a5,64
ffffffffc0201698:	fed792e3          	bne	a5,a3,ffffffffc020167c <default_free_pages+0x14>
    base->property = n;
ffffffffc020169c:	2581                	sext.w	a1,a1
ffffffffc020169e:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02016a0:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02016a4:	4789                	li	a5,2
ffffffffc02016a6:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02016aa:	000c1697          	auipc	a3,0xc1
ffffffffc02016ae:	48668693          	addi	a3,a3,1158 # ffffffffc02c2b30 <free_area>
ffffffffc02016b2:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02016b4:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02016b6:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02016ba:	9db9                	addw	a1,a1,a4
ffffffffc02016bc:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02016be:	0ad78463          	beq	a5,a3,ffffffffc0201766 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02016c2:	fe878713          	addi	a4,a5,-24
ffffffffc02016c6:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02016ca:	4581                	li	a1,0
            if (base < page)
ffffffffc02016cc:	00e56a63          	bltu	a0,a4,ffffffffc02016e0 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02016d0:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02016d2:	04d70c63          	beq	a4,a3,ffffffffc020172a <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02016d6:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02016d8:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02016dc:	fee57ae3          	bgeu	a0,a4,ffffffffc02016d0 <default_free_pages+0x68>
ffffffffc02016e0:	c199                	beqz	a1,ffffffffc02016e6 <default_free_pages+0x7e>
ffffffffc02016e2:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02016e6:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02016e8:	e390                	sd	a2,0(a5)
ffffffffc02016ea:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02016ec:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02016ee:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc02016f0:	00d70d63          	beq	a4,a3,ffffffffc020170a <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02016f4:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02016f8:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02016fc:	02059813          	slli	a6,a1,0x20
ffffffffc0201700:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201704:	97b2                	add	a5,a5,a2
ffffffffc0201706:	02f50c63          	beq	a0,a5,ffffffffc020173e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020170a:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc020170c:	00d78c63          	beq	a5,a3,ffffffffc0201724 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201710:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201712:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201716:	02061593          	slli	a1,a2,0x20
ffffffffc020171a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020171e:	972a                	add	a4,a4,a0
ffffffffc0201720:	04e68a63          	beq	a3,a4,ffffffffc0201774 <default_free_pages+0x10c>
}
ffffffffc0201724:	60a2                	ld	ra,8(sp)
ffffffffc0201726:	0141                	addi	sp,sp,16
ffffffffc0201728:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020172a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020172c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020172e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201730:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201732:	02d70763          	beq	a4,a3,ffffffffc0201760 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201736:	8832                	mv	a6,a2
ffffffffc0201738:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020173a:	87ba                	mv	a5,a4
ffffffffc020173c:	bf71                	j	ffffffffc02016d8 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020173e:	491c                	lw	a5,16(a0)
ffffffffc0201740:	9dbd                	addw	a1,a1,a5
ffffffffc0201742:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201746:	57f5                	li	a5,-3
ffffffffc0201748:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020174c:	01853803          	ld	a6,24(a0)
ffffffffc0201750:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201752:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201754:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201758:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020175a:	0105b023          	sd	a6,0(a1)
ffffffffc020175e:	b77d                	j	ffffffffc020170c <default_free_pages+0xa4>
ffffffffc0201760:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201762:	873e                	mv	a4,a5
ffffffffc0201764:	bf41                	j	ffffffffc02016f4 <default_free_pages+0x8c>
}
ffffffffc0201766:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201768:	e390                	sd	a2,0(a5)
ffffffffc020176a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020176c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020176e:	ed1c                	sd	a5,24(a0)
ffffffffc0201770:	0141                	addi	sp,sp,16
ffffffffc0201772:	8082                	ret
            base->property += p->property;
ffffffffc0201774:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201778:	ff078693          	addi	a3,a5,-16
ffffffffc020177c:	9e39                	addw	a2,a2,a4
ffffffffc020177e:	c910                	sw	a2,16(a0)
ffffffffc0201780:	5775                	li	a4,-3
ffffffffc0201782:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201786:	6398                	ld	a4,0(a5)
ffffffffc0201788:	679c                	ld	a5,8(a5)
}
ffffffffc020178a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020178c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020178e:	e398                	sd	a4,0(a5)
ffffffffc0201790:	0141                	addi	sp,sp,16
ffffffffc0201792:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201794:	00005697          	auipc	a3,0x5
ffffffffc0201798:	24c68693          	addi	a3,a3,588 # ffffffffc02069e0 <commands+0xb78>
ffffffffc020179c:	00005617          	auipc	a2,0x5
ffffffffc02017a0:	ee460613          	addi	a2,a2,-284 # ffffffffc0206680 <commands+0x818>
ffffffffc02017a4:	09400593          	li	a1,148
ffffffffc02017a8:	00005517          	auipc	a0,0x5
ffffffffc02017ac:	ef050513          	addi	a0,a0,-272 # ffffffffc0206698 <commands+0x830>
ffffffffc02017b0:	ce3fe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(n > 0);
ffffffffc02017b4:	00005697          	auipc	a3,0x5
ffffffffc02017b8:	22468693          	addi	a3,a3,548 # ffffffffc02069d8 <commands+0xb70>
ffffffffc02017bc:	00005617          	auipc	a2,0x5
ffffffffc02017c0:	ec460613          	addi	a2,a2,-316 # ffffffffc0206680 <commands+0x818>
ffffffffc02017c4:	09000593          	li	a1,144
ffffffffc02017c8:	00005517          	auipc	a0,0x5
ffffffffc02017cc:	ed050513          	addi	a0,a0,-304 # ffffffffc0206698 <commands+0x830>
ffffffffc02017d0:	cc3fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02017d4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02017d4:	c941                	beqz	a0,ffffffffc0201864 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02017d6:	000c1597          	auipc	a1,0xc1
ffffffffc02017da:	35a58593          	addi	a1,a1,858 # ffffffffc02c2b30 <free_area>
ffffffffc02017de:	0105a803          	lw	a6,16(a1)
ffffffffc02017e2:	872a                	mv	a4,a0
ffffffffc02017e4:	02081793          	slli	a5,a6,0x20
ffffffffc02017e8:	9381                	srli	a5,a5,0x20
ffffffffc02017ea:	00a7ee63          	bltu	a5,a0,ffffffffc0201806 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02017ee:	87ae                	mv	a5,a1
ffffffffc02017f0:	a801                	j	ffffffffc0201800 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc02017f2:	ff87a683          	lw	a3,-8(a5)
ffffffffc02017f6:	02069613          	slli	a2,a3,0x20
ffffffffc02017fa:	9201                	srli	a2,a2,0x20
ffffffffc02017fc:	00e67763          	bgeu	a2,a4,ffffffffc020180a <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201800:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201802:	feb798e3          	bne	a5,a1,ffffffffc02017f2 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201806:	4501                	li	a0,0
}
ffffffffc0201808:	8082                	ret
    return listelm->prev;
ffffffffc020180a:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020180e:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201812:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201816:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020181a:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020181e:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201822:	02c77863          	bgeu	a4,a2,ffffffffc0201852 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201826:	071a                	slli	a4,a4,0x6
ffffffffc0201828:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020182a:	41c686bb          	subw	a3,a3,t3
ffffffffc020182e:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201830:	00870613          	addi	a2,a4,8
ffffffffc0201834:	4689                	li	a3,2
ffffffffc0201836:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020183a:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020183e:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201842:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201846:	e290                	sd	a2,0(a3)
ffffffffc0201848:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc020184c:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020184e:	01173c23          	sd	a7,24(a4)
ffffffffc0201852:	41c8083b          	subw	a6,a6,t3
ffffffffc0201856:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020185a:	5775                	li	a4,-3
ffffffffc020185c:	17c1                	addi	a5,a5,-16
ffffffffc020185e:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201862:	8082                	ret
{
ffffffffc0201864:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201866:	00005697          	auipc	a3,0x5
ffffffffc020186a:	17268693          	addi	a3,a3,370 # ffffffffc02069d8 <commands+0xb70>
ffffffffc020186e:	00005617          	auipc	a2,0x5
ffffffffc0201872:	e1260613          	addi	a2,a2,-494 # ffffffffc0206680 <commands+0x818>
ffffffffc0201876:	06c00593          	li	a1,108
ffffffffc020187a:	00005517          	auipc	a0,0x5
ffffffffc020187e:	e1e50513          	addi	a0,a0,-482 # ffffffffc0206698 <commands+0x830>
{
ffffffffc0201882:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201884:	c0ffe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201888 <default_init_memmap>:
{
ffffffffc0201888:	1141                	addi	sp,sp,-16
ffffffffc020188a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020188c:	c5f1                	beqz	a1,ffffffffc0201958 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc020188e:	00659693          	slli	a3,a1,0x6
ffffffffc0201892:	96aa                	add	a3,a3,a0
ffffffffc0201894:	87aa                	mv	a5,a0
ffffffffc0201896:	00d50f63          	beq	a0,a3,ffffffffc02018b4 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020189a:	6798                	ld	a4,8(a5)
ffffffffc020189c:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc020189e:	cf49                	beqz	a4,ffffffffc0201938 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02018a0:	0007a823          	sw	zero,16(a5)
ffffffffc02018a4:	0007b423          	sd	zero,8(a5)
ffffffffc02018a8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02018ac:	04078793          	addi	a5,a5,64
ffffffffc02018b0:	fed795e3          	bne	a5,a3,ffffffffc020189a <default_init_memmap+0x12>
    base->property = n;
ffffffffc02018b4:	2581                	sext.w	a1,a1
ffffffffc02018b6:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02018b8:	4789                	li	a5,2
ffffffffc02018ba:	00850713          	addi	a4,a0,8
ffffffffc02018be:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02018c2:	000c1697          	auipc	a3,0xc1
ffffffffc02018c6:	26e68693          	addi	a3,a3,622 # ffffffffc02c2b30 <free_area>
ffffffffc02018ca:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02018cc:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02018ce:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02018d2:	9db9                	addw	a1,a1,a4
ffffffffc02018d4:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02018d6:	04d78a63          	beq	a5,a3,ffffffffc020192a <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02018da:	fe878713          	addi	a4,a5,-24
ffffffffc02018de:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02018e2:	4581                	li	a1,0
            if (base < page)
ffffffffc02018e4:	00e56a63          	bltu	a0,a4,ffffffffc02018f8 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02018e8:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02018ea:	02d70263          	beq	a4,a3,ffffffffc020190e <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc02018ee:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02018f0:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02018f4:	fee57ae3          	bgeu	a0,a4,ffffffffc02018e8 <default_init_memmap+0x60>
ffffffffc02018f8:	c199                	beqz	a1,ffffffffc02018fe <default_init_memmap+0x76>
ffffffffc02018fa:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02018fe:	6398                	ld	a4,0(a5)
}
ffffffffc0201900:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201902:	e390                	sd	a2,0(a5)
ffffffffc0201904:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201906:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201908:	ed18                	sd	a4,24(a0)
ffffffffc020190a:	0141                	addi	sp,sp,16
ffffffffc020190c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020190e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201910:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201912:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201914:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201916:	00d70663          	beq	a4,a3,ffffffffc0201922 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc020191a:	8832                	mv	a6,a2
ffffffffc020191c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020191e:	87ba                	mv	a5,a4
ffffffffc0201920:	bfc1                	j	ffffffffc02018f0 <default_init_memmap+0x68>
}
ffffffffc0201922:	60a2                	ld	ra,8(sp)
ffffffffc0201924:	e290                	sd	a2,0(a3)
ffffffffc0201926:	0141                	addi	sp,sp,16
ffffffffc0201928:	8082                	ret
ffffffffc020192a:	60a2                	ld	ra,8(sp)
ffffffffc020192c:	e390                	sd	a2,0(a5)
ffffffffc020192e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201930:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201932:	ed1c                	sd	a5,24(a0)
ffffffffc0201934:	0141                	addi	sp,sp,16
ffffffffc0201936:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201938:	00005697          	auipc	a3,0x5
ffffffffc020193c:	0d068693          	addi	a3,a3,208 # ffffffffc0206a08 <commands+0xba0>
ffffffffc0201940:	00005617          	auipc	a2,0x5
ffffffffc0201944:	d4060613          	addi	a2,a2,-704 # ffffffffc0206680 <commands+0x818>
ffffffffc0201948:	04b00593          	li	a1,75
ffffffffc020194c:	00005517          	auipc	a0,0x5
ffffffffc0201950:	d4c50513          	addi	a0,a0,-692 # ffffffffc0206698 <commands+0x830>
ffffffffc0201954:	b3ffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(n > 0);
ffffffffc0201958:	00005697          	auipc	a3,0x5
ffffffffc020195c:	08068693          	addi	a3,a3,128 # ffffffffc02069d8 <commands+0xb70>
ffffffffc0201960:	00005617          	auipc	a2,0x5
ffffffffc0201964:	d2060613          	addi	a2,a2,-736 # ffffffffc0206680 <commands+0x818>
ffffffffc0201968:	04700593          	li	a1,71
ffffffffc020196c:	00005517          	auipc	a0,0x5
ffffffffc0201970:	d2c50513          	addi	a0,a0,-724 # ffffffffc0206698 <commands+0x830>
ffffffffc0201974:	b1ffe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201978 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201978:	c94d                	beqz	a0,ffffffffc0201a2a <slob_free+0xb2>
{
ffffffffc020197a:	1141                	addi	sp,sp,-16
ffffffffc020197c:	e022                	sd	s0,0(sp)
ffffffffc020197e:	e406                	sd	ra,8(sp)
ffffffffc0201980:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201982:	e9c1                	bnez	a1,ffffffffc0201a12 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201984:	100027f3          	csrr	a5,sstatus
ffffffffc0201988:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020198a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020198c:	ebd9                	bnez	a5,ffffffffc0201a22 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020198e:	000c1617          	auipc	a2,0xc1
ffffffffc0201992:	d9260613          	addi	a2,a2,-622 # ffffffffc02c2720 <slobfree>
ffffffffc0201996:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201998:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020199a:	679c                	ld	a5,8(a5)
ffffffffc020199c:	02877a63          	bgeu	a4,s0,ffffffffc02019d0 <slob_free+0x58>
ffffffffc02019a0:	00f46463          	bltu	s0,a5,ffffffffc02019a8 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019a4:	fef76ae3          	bltu	a4,a5,ffffffffc0201998 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc02019a8:	400c                	lw	a1,0(s0)
ffffffffc02019aa:	00459693          	slli	a3,a1,0x4
ffffffffc02019ae:	96a2                	add	a3,a3,s0
ffffffffc02019b0:	02d78a63          	beq	a5,a3,ffffffffc02019e4 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc02019b4:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc02019b6:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02019b8:	00469793          	slli	a5,a3,0x4
ffffffffc02019bc:	97ba                	add	a5,a5,a4
ffffffffc02019be:	02f40e63          	beq	s0,a5,ffffffffc02019fa <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc02019c2:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc02019c4:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc02019c6:	e129                	bnez	a0,ffffffffc0201a08 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02019c8:	60a2                	ld	ra,8(sp)
ffffffffc02019ca:	6402                	ld	s0,0(sp)
ffffffffc02019cc:	0141                	addi	sp,sp,16
ffffffffc02019ce:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019d0:	fcf764e3          	bltu	a4,a5,ffffffffc0201998 <slob_free+0x20>
ffffffffc02019d4:	fcf472e3          	bgeu	s0,a5,ffffffffc0201998 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc02019d8:	400c                	lw	a1,0(s0)
ffffffffc02019da:	00459693          	slli	a3,a1,0x4
ffffffffc02019de:	96a2                	add	a3,a3,s0
ffffffffc02019e0:	fcd79ae3          	bne	a5,a3,ffffffffc02019b4 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc02019e4:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02019e6:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02019e8:	9db5                	addw	a1,a1,a3
ffffffffc02019ea:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc02019ec:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc02019ee:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02019f0:	00469793          	slli	a5,a3,0x4
ffffffffc02019f4:	97ba                	add	a5,a5,a4
ffffffffc02019f6:	fcf416e3          	bne	s0,a5,ffffffffc02019c2 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc02019fa:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc02019fc:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc02019fe:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201a00:	9ebd                	addw	a3,a3,a5
ffffffffc0201a02:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201a04:	e70c                	sd	a1,8(a4)
ffffffffc0201a06:	d169                	beqz	a0,ffffffffc02019c8 <slob_free+0x50>
}
ffffffffc0201a08:	6402                	ld	s0,0(sp)
ffffffffc0201a0a:	60a2                	ld	ra,8(sp)
ffffffffc0201a0c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201a0e:	f9bfe06f          	j	ffffffffc02009a8 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201a12:	25bd                	addiw	a1,a1,15
ffffffffc0201a14:	8191                	srli	a1,a1,0x4
ffffffffc0201a16:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a18:	100027f3          	csrr	a5,sstatus
ffffffffc0201a1c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a1e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a20:	d7bd                	beqz	a5,ffffffffc020198e <slob_free+0x16>
        intr_disable();
ffffffffc0201a22:	f8dfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0201a26:	4505                	li	a0,1
ffffffffc0201a28:	b79d                	j	ffffffffc020198e <slob_free+0x16>
ffffffffc0201a2a:	8082                	ret

ffffffffc0201a2c <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a2c:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a2e:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a30:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a34:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a36:	352000ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
	if (!page)
ffffffffc0201a3a:	c91d                	beqz	a0,ffffffffc0201a70 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201a3c:	000c5697          	auipc	a3,0xc5
ffffffffc0201a40:	18c6b683          	ld	a3,396(a3) # ffffffffc02c6bc8 <pages>
ffffffffc0201a44:	8d15                	sub	a0,a0,a3
ffffffffc0201a46:	8519                	srai	a0,a0,0x6
ffffffffc0201a48:	00007697          	auipc	a3,0x7
ffffffffc0201a4c:	a286b683          	ld	a3,-1496(a3) # ffffffffc0208470 <nbase>
ffffffffc0201a50:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201a52:	00c51793          	slli	a5,a0,0xc
ffffffffc0201a56:	83b1                	srli	a5,a5,0xc
ffffffffc0201a58:	000c5717          	auipc	a4,0xc5
ffffffffc0201a5c:	16873703          	ld	a4,360(a4) # ffffffffc02c6bc0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201a60:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201a62:	00e7fa63          	bgeu	a5,a4,ffffffffc0201a76 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201a66:	000c5697          	auipc	a3,0xc5
ffffffffc0201a6a:	1726b683          	ld	a3,370(a3) # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0201a6e:	9536                	add	a0,a0,a3
}
ffffffffc0201a70:	60a2                	ld	ra,8(sp)
ffffffffc0201a72:	0141                	addi	sp,sp,16
ffffffffc0201a74:	8082                	ret
ffffffffc0201a76:	86aa                	mv	a3,a0
ffffffffc0201a78:	00005617          	auipc	a2,0x5
ffffffffc0201a7c:	ff060613          	addi	a2,a2,-16 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0201a80:	07100593          	li	a1,113
ffffffffc0201a84:	00005517          	auipc	a0,0x5
ffffffffc0201a88:	00c50513          	addi	a0,a0,12 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc0201a8c:	a07fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201a90 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201a90:	1101                	addi	sp,sp,-32
ffffffffc0201a92:	ec06                	sd	ra,24(sp)
ffffffffc0201a94:	e822                	sd	s0,16(sp)
ffffffffc0201a96:	e426                	sd	s1,8(sp)
ffffffffc0201a98:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201a9a:	01050713          	addi	a4,a0,16
ffffffffc0201a9e:	6785                	lui	a5,0x1
ffffffffc0201aa0:	0cf77363          	bgeu	a4,a5,ffffffffc0201b66 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201aa4:	00f50493          	addi	s1,a0,15
ffffffffc0201aa8:	8091                	srli	s1,s1,0x4
ffffffffc0201aaa:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aac:	10002673          	csrr	a2,sstatus
ffffffffc0201ab0:	8a09                	andi	a2,a2,2
ffffffffc0201ab2:	e25d                	bnez	a2,ffffffffc0201b58 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201ab4:	000c1917          	auipc	s2,0xc1
ffffffffc0201ab8:	c6c90913          	addi	s2,s2,-916 # ffffffffc02c2720 <slobfree>
ffffffffc0201abc:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201ac0:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201ac2:	4398                	lw	a4,0(a5)
ffffffffc0201ac4:	08975e63          	bge	a4,s1,ffffffffc0201b60 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201ac8:	00f68b63          	beq	a3,a5,ffffffffc0201ade <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201acc:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201ace:	4018                	lw	a4,0(s0)
ffffffffc0201ad0:	02975a63          	bge	a4,s1,ffffffffc0201b04 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201ad4:	00093683          	ld	a3,0(s2)
ffffffffc0201ad8:	87a2                	mv	a5,s0
ffffffffc0201ada:	fef699e3          	bne	a3,a5,ffffffffc0201acc <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201ade:	ee31                	bnez	a2,ffffffffc0201b3a <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201ae0:	4501                	li	a0,0
ffffffffc0201ae2:	f4bff0ef          	jal	ra,ffffffffc0201a2c <__slob_get_free_pages.constprop.0>
ffffffffc0201ae6:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201ae8:	cd05                	beqz	a0,ffffffffc0201b20 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201aea:	6585                	lui	a1,0x1
ffffffffc0201aec:	e8dff0ef          	jal	ra,ffffffffc0201978 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201af0:	10002673          	csrr	a2,sstatus
ffffffffc0201af4:	8a09                	andi	a2,a2,2
ffffffffc0201af6:	ee05                	bnez	a2,ffffffffc0201b2e <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201af8:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201afc:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201afe:	4018                	lw	a4,0(s0)
ffffffffc0201b00:	fc974ae3          	blt	a4,s1,ffffffffc0201ad4 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201b04:	04e48763          	beq	s1,a4,ffffffffc0201b52 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201b08:	00449693          	slli	a3,s1,0x4
ffffffffc0201b0c:	96a2                	add	a3,a3,s0
ffffffffc0201b0e:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201b10:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201b12:	9f05                	subw	a4,a4,s1
ffffffffc0201b14:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201b16:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201b18:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201b1a:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201b1e:	e20d                	bnez	a2,ffffffffc0201b40 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201b20:	60e2                	ld	ra,24(sp)
ffffffffc0201b22:	8522                	mv	a0,s0
ffffffffc0201b24:	6442                	ld	s0,16(sp)
ffffffffc0201b26:	64a2                	ld	s1,8(sp)
ffffffffc0201b28:	6902                	ld	s2,0(sp)
ffffffffc0201b2a:	6105                	addi	sp,sp,32
ffffffffc0201b2c:	8082                	ret
        intr_disable();
ffffffffc0201b2e:	e81fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
			cur = slobfree;
ffffffffc0201b32:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201b36:	4605                	li	a2,1
ffffffffc0201b38:	b7d1                	j	ffffffffc0201afc <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201b3a:	e6ffe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201b3e:	b74d                	j	ffffffffc0201ae0 <slob_alloc.constprop.0+0x50>
ffffffffc0201b40:	e69fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
}
ffffffffc0201b44:	60e2                	ld	ra,24(sp)
ffffffffc0201b46:	8522                	mv	a0,s0
ffffffffc0201b48:	6442                	ld	s0,16(sp)
ffffffffc0201b4a:	64a2                	ld	s1,8(sp)
ffffffffc0201b4c:	6902                	ld	s2,0(sp)
ffffffffc0201b4e:	6105                	addi	sp,sp,32
ffffffffc0201b50:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201b52:	6418                	ld	a4,8(s0)
ffffffffc0201b54:	e798                	sd	a4,8(a5)
ffffffffc0201b56:	b7d1                	j	ffffffffc0201b1a <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201b58:	e57fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0201b5c:	4605                	li	a2,1
ffffffffc0201b5e:	bf99                	j	ffffffffc0201ab4 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201b60:	843e                	mv	s0,a5
ffffffffc0201b62:	87b6                	mv	a5,a3
ffffffffc0201b64:	b745                	j	ffffffffc0201b04 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201b66:	00005697          	auipc	a3,0x5
ffffffffc0201b6a:	f3a68693          	addi	a3,a3,-198 # ffffffffc0206aa0 <default_pmm_manager+0x70>
ffffffffc0201b6e:	00005617          	auipc	a2,0x5
ffffffffc0201b72:	b1260613          	addi	a2,a2,-1262 # ffffffffc0206680 <commands+0x818>
ffffffffc0201b76:	06300593          	li	a1,99
ffffffffc0201b7a:	00005517          	auipc	a0,0x5
ffffffffc0201b7e:	f4650513          	addi	a0,a0,-186 # ffffffffc0206ac0 <default_pmm_manager+0x90>
ffffffffc0201b82:	911fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201b86 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201b86:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201b88:	00005517          	auipc	a0,0x5
ffffffffc0201b8c:	f5050513          	addi	a0,a0,-176 # ffffffffc0206ad8 <default_pmm_manager+0xa8>
{
ffffffffc0201b90:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201b92:	e06fe0ef          	jal	ra,ffffffffc0200198 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201b96:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201b98:	00005517          	auipc	a0,0x5
ffffffffc0201b9c:	f5850513          	addi	a0,a0,-168 # ffffffffc0206af0 <default_pmm_manager+0xc0>
}
ffffffffc0201ba0:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201ba2:	df6fe06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0201ba6 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201ba6:	4501                	li	a0,0
ffffffffc0201ba8:	8082                	ret

ffffffffc0201baa <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201baa:	1101                	addi	sp,sp,-32
ffffffffc0201bac:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201bae:	6905                	lui	s2,0x1
{
ffffffffc0201bb0:	e822                	sd	s0,16(sp)
ffffffffc0201bb2:	ec06                	sd	ra,24(sp)
ffffffffc0201bb4:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201bb6:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8f51>
{
ffffffffc0201bba:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201bbc:	04a7f963          	bgeu	a5,a0,ffffffffc0201c0e <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201bc0:	4561                	li	a0,24
ffffffffc0201bc2:	ecfff0ef          	jal	ra,ffffffffc0201a90 <slob_alloc.constprop.0>
ffffffffc0201bc6:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201bc8:	c929                	beqz	a0,ffffffffc0201c1a <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201bca:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201bce:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201bd0:	00f95763          	bge	s2,a5,ffffffffc0201bde <kmalloc+0x34>
ffffffffc0201bd4:	6705                	lui	a4,0x1
ffffffffc0201bd6:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201bd8:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201bda:	fef74ee3          	blt	a4,a5,ffffffffc0201bd6 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201bde:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201be0:	e4dff0ef          	jal	ra,ffffffffc0201a2c <__slob_get_free_pages.constprop.0>
ffffffffc0201be4:	e488                	sd	a0,8(s1)
ffffffffc0201be6:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201be8:	c525                	beqz	a0,ffffffffc0201c50 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bea:	100027f3          	csrr	a5,sstatus
ffffffffc0201bee:	8b89                	andi	a5,a5,2
ffffffffc0201bf0:	ef8d                	bnez	a5,ffffffffc0201c2a <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201bf2:	000c5797          	auipc	a5,0xc5
ffffffffc0201bf6:	fb678793          	addi	a5,a5,-74 # ffffffffc02c6ba8 <bigblocks>
ffffffffc0201bfa:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201bfc:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201bfe:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201c00:	60e2                	ld	ra,24(sp)
ffffffffc0201c02:	8522                	mv	a0,s0
ffffffffc0201c04:	6442                	ld	s0,16(sp)
ffffffffc0201c06:	64a2                	ld	s1,8(sp)
ffffffffc0201c08:	6902                	ld	s2,0(sp)
ffffffffc0201c0a:	6105                	addi	sp,sp,32
ffffffffc0201c0c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201c0e:	0541                	addi	a0,a0,16
ffffffffc0201c10:	e81ff0ef          	jal	ra,ffffffffc0201a90 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201c14:	01050413          	addi	s0,a0,16
ffffffffc0201c18:	f565                	bnez	a0,ffffffffc0201c00 <kmalloc+0x56>
ffffffffc0201c1a:	4401                	li	s0,0
}
ffffffffc0201c1c:	60e2                	ld	ra,24(sp)
ffffffffc0201c1e:	8522                	mv	a0,s0
ffffffffc0201c20:	6442                	ld	s0,16(sp)
ffffffffc0201c22:	64a2                	ld	s1,8(sp)
ffffffffc0201c24:	6902                	ld	s2,0(sp)
ffffffffc0201c26:	6105                	addi	sp,sp,32
ffffffffc0201c28:	8082                	ret
        intr_disable();
ffffffffc0201c2a:	d85fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
		bb->next = bigblocks;
ffffffffc0201c2e:	000c5797          	auipc	a5,0xc5
ffffffffc0201c32:	f7a78793          	addi	a5,a5,-134 # ffffffffc02c6ba8 <bigblocks>
ffffffffc0201c36:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201c38:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201c3a:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201c3c:	d6dfe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
		return bb->pages;
ffffffffc0201c40:	6480                	ld	s0,8(s1)
}
ffffffffc0201c42:	60e2                	ld	ra,24(sp)
ffffffffc0201c44:	64a2                	ld	s1,8(sp)
ffffffffc0201c46:	8522                	mv	a0,s0
ffffffffc0201c48:	6442                	ld	s0,16(sp)
ffffffffc0201c4a:	6902                	ld	s2,0(sp)
ffffffffc0201c4c:	6105                	addi	sp,sp,32
ffffffffc0201c4e:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c50:	45e1                	li	a1,24
ffffffffc0201c52:	8526                	mv	a0,s1
ffffffffc0201c54:	d25ff0ef          	jal	ra,ffffffffc0201978 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201c58:	b765                	j	ffffffffc0201c00 <kmalloc+0x56>

ffffffffc0201c5a <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201c5a:	c169                	beqz	a0,ffffffffc0201d1c <kfree+0xc2>
{
ffffffffc0201c5c:	1101                	addi	sp,sp,-32
ffffffffc0201c5e:	e822                	sd	s0,16(sp)
ffffffffc0201c60:	ec06                	sd	ra,24(sp)
ffffffffc0201c62:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201c64:	03451793          	slli	a5,a0,0x34
ffffffffc0201c68:	842a                	mv	s0,a0
ffffffffc0201c6a:	e3d9                	bnez	a5,ffffffffc0201cf0 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c6c:	100027f3          	csrr	a5,sstatus
ffffffffc0201c70:	8b89                	andi	a5,a5,2
ffffffffc0201c72:	e7d9                	bnez	a5,ffffffffc0201d00 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c74:	000c5797          	auipc	a5,0xc5
ffffffffc0201c78:	f347b783          	ld	a5,-204(a5) # ffffffffc02c6ba8 <bigblocks>
    return 0;
ffffffffc0201c7c:	4601                	li	a2,0
ffffffffc0201c7e:	cbad                	beqz	a5,ffffffffc0201cf0 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201c80:	000c5697          	auipc	a3,0xc5
ffffffffc0201c84:	f2868693          	addi	a3,a3,-216 # ffffffffc02c6ba8 <bigblocks>
ffffffffc0201c88:	a021                	j	ffffffffc0201c90 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c8a:	01048693          	addi	a3,s1,16
ffffffffc0201c8e:	c3a5                	beqz	a5,ffffffffc0201cee <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201c90:	6798                	ld	a4,8(a5)
ffffffffc0201c92:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201c94:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201c96:	fe871ae3          	bne	a4,s0,ffffffffc0201c8a <kfree+0x30>
				*last = bb->next;
ffffffffc0201c9a:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201c9c:	ee2d                	bnez	a2,ffffffffc0201d16 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201c9e:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201ca2:	4098                	lw	a4,0(s1)
ffffffffc0201ca4:	08f46963          	bltu	s0,a5,ffffffffc0201d36 <kfree+0xdc>
ffffffffc0201ca8:	000c5697          	auipc	a3,0xc5
ffffffffc0201cac:	f306b683          	ld	a3,-208(a3) # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0201cb0:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201cb2:	8031                	srli	s0,s0,0xc
ffffffffc0201cb4:	000c5797          	auipc	a5,0xc5
ffffffffc0201cb8:	f0c7b783          	ld	a5,-244(a5) # ffffffffc02c6bc0 <npage>
ffffffffc0201cbc:	06f47163          	bgeu	s0,a5,ffffffffc0201d1e <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201cc0:	00006517          	auipc	a0,0x6
ffffffffc0201cc4:	7b053503          	ld	a0,1968(a0) # ffffffffc0208470 <nbase>
ffffffffc0201cc8:	8c09                	sub	s0,s0,a0
ffffffffc0201cca:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201ccc:	000c5517          	auipc	a0,0xc5
ffffffffc0201cd0:	efc53503          	ld	a0,-260(a0) # ffffffffc02c6bc8 <pages>
ffffffffc0201cd4:	4585                	li	a1,1
ffffffffc0201cd6:	9522                	add	a0,a0,s0
ffffffffc0201cd8:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201cdc:	0ea000ef          	jal	ra,ffffffffc0201dc6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201ce0:	6442                	ld	s0,16(sp)
ffffffffc0201ce2:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201ce4:	8526                	mv	a0,s1
}
ffffffffc0201ce6:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201ce8:	45e1                	li	a1,24
}
ffffffffc0201cea:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201cec:	b171                	j	ffffffffc0201978 <slob_free>
ffffffffc0201cee:	e20d                	bnez	a2,ffffffffc0201d10 <kfree+0xb6>
ffffffffc0201cf0:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201cf4:	6442                	ld	s0,16(sp)
ffffffffc0201cf6:	60e2                	ld	ra,24(sp)
ffffffffc0201cf8:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201cfa:	4581                	li	a1,0
}
ffffffffc0201cfc:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201cfe:	b9ad                	j	ffffffffc0201978 <slob_free>
        intr_disable();
ffffffffc0201d00:	caffe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d04:	000c5797          	auipc	a5,0xc5
ffffffffc0201d08:	ea47b783          	ld	a5,-348(a5) # ffffffffc02c6ba8 <bigblocks>
        return 1;
ffffffffc0201d0c:	4605                	li	a2,1
ffffffffc0201d0e:	fbad                	bnez	a5,ffffffffc0201c80 <kfree+0x26>
        intr_enable();
ffffffffc0201d10:	c99fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201d14:	bff1                	j	ffffffffc0201cf0 <kfree+0x96>
ffffffffc0201d16:	c93fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201d1a:	b751                	j	ffffffffc0201c9e <kfree+0x44>
ffffffffc0201d1c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201d1e:	00005617          	auipc	a2,0x5
ffffffffc0201d22:	e1a60613          	addi	a2,a2,-486 # ffffffffc0206b38 <default_pmm_manager+0x108>
ffffffffc0201d26:	06900593          	li	a1,105
ffffffffc0201d2a:	00005517          	auipc	a0,0x5
ffffffffc0201d2e:	d6650513          	addi	a0,a0,-666 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc0201d32:	f60fe0ef          	jal	ra,ffffffffc0200492 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201d36:	86a2                	mv	a3,s0
ffffffffc0201d38:	00005617          	auipc	a2,0x5
ffffffffc0201d3c:	dd860613          	addi	a2,a2,-552 # ffffffffc0206b10 <default_pmm_manager+0xe0>
ffffffffc0201d40:	07700593          	li	a1,119
ffffffffc0201d44:	00005517          	auipc	a0,0x5
ffffffffc0201d48:	d4c50513          	addi	a0,a0,-692 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc0201d4c:	f46fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201d50 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201d50:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201d52:	00005617          	auipc	a2,0x5
ffffffffc0201d56:	de660613          	addi	a2,a2,-538 # ffffffffc0206b38 <default_pmm_manager+0x108>
ffffffffc0201d5a:	06900593          	li	a1,105
ffffffffc0201d5e:	00005517          	auipc	a0,0x5
ffffffffc0201d62:	d3250513          	addi	a0,a0,-718 # ffffffffc0206a90 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201d66:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201d68:	f2afe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201d6c <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201d6c:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201d6e:	00005617          	auipc	a2,0x5
ffffffffc0201d72:	dea60613          	addi	a2,a2,-534 # ffffffffc0206b58 <default_pmm_manager+0x128>
ffffffffc0201d76:	07f00593          	li	a1,127
ffffffffc0201d7a:	00005517          	auipc	a0,0x5
ffffffffc0201d7e:	d1650513          	addi	a0,a0,-746 # ffffffffc0206a90 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201d82:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201d84:	f0efe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201d88 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d88:	100027f3          	csrr	a5,sstatus
ffffffffc0201d8c:	8b89                	andi	a5,a5,2
ffffffffc0201d8e:	e799                	bnez	a5,ffffffffc0201d9c <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201d90:	000c5797          	auipc	a5,0xc5
ffffffffc0201d94:	e407b783          	ld	a5,-448(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201d98:	6f9c                	ld	a5,24(a5)
ffffffffc0201d9a:	8782                	jr	a5
{
ffffffffc0201d9c:	1141                	addi	sp,sp,-16
ffffffffc0201d9e:	e406                	sd	ra,8(sp)
ffffffffc0201da0:	e022                	sd	s0,0(sp)
ffffffffc0201da2:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201da4:	c0bfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201da8:	000c5797          	auipc	a5,0xc5
ffffffffc0201dac:	e287b783          	ld	a5,-472(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201db0:	6f9c                	ld	a5,24(a5)
ffffffffc0201db2:	8522                	mv	a0,s0
ffffffffc0201db4:	9782                	jalr	a5
ffffffffc0201db6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201db8:	bf1fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201dbc:	60a2                	ld	ra,8(sp)
ffffffffc0201dbe:	8522                	mv	a0,s0
ffffffffc0201dc0:	6402                	ld	s0,0(sp)
ffffffffc0201dc2:	0141                	addi	sp,sp,16
ffffffffc0201dc4:	8082                	ret

ffffffffc0201dc6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dc6:	100027f3          	csrr	a5,sstatus
ffffffffc0201dca:	8b89                	andi	a5,a5,2
ffffffffc0201dcc:	e799                	bnez	a5,ffffffffc0201dda <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201dce:	000c5797          	auipc	a5,0xc5
ffffffffc0201dd2:	e027b783          	ld	a5,-510(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201dd6:	739c                	ld	a5,32(a5)
ffffffffc0201dd8:	8782                	jr	a5
{
ffffffffc0201dda:	1101                	addi	sp,sp,-32
ffffffffc0201ddc:	ec06                	sd	ra,24(sp)
ffffffffc0201dde:	e822                	sd	s0,16(sp)
ffffffffc0201de0:	e426                	sd	s1,8(sp)
ffffffffc0201de2:	842a                	mv	s0,a0
ffffffffc0201de4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201de6:	bc9fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201dea:	000c5797          	auipc	a5,0xc5
ffffffffc0201dee:	de67b783          	ld	a5,-538(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201df2:	739c                	ld	a5,32(a5)
ffffffffc0201df4:	85a6                	mv	a1,s1
ffffffffc0201df6:	8522                	mv	a0,s0
ffffffffc0201df8:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201dfa:	6442                	ld	s0,16(sp)
ffffffffc0201dfc:	60e2                	ld	ra,24(sp)
ffffffffc0201dfe:	64a2                	ld	s1,8(sp)
ffffffffc0201e00:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201e02:	ba7fe06f          	j	ffffffffc02009a8 <intr_enable>

ffffffffc0201e06 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e06:	100027f3          	csrr	a5,sstatus
ffffffffc0201e0a:	8b89                	andi	a5,a5,2
ffffffffc0201e0c:	e799                	bnez	a5,ffffffffc0201e1a <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e0e:	000c5797          	auipc	a5,0xc5
ffffffffc0201e12:	dc27b783          	ld	a5,-574(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201e16:	779c                	ld	a5,40(a5)
ffffffffc0201e18:	8782                	jr	a5
{
ffffffffc0201e1a:	1141                	addi	sp,sp,-16
ffffffffc0201e1c:	e406                	sd	ra,8(sp)
ffffffffc0201e1e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201e20:	b8ffe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e24:	000c5797          	auipc	a5,0xc5
ffffffffc0201e28:	dac7b783          	ld	a5,-596(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201e2c:	779c                	ld	a5,40(a5)
ffffffffc0201e2e:	9782                	jalr	a5
ffffffffc0201e30:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201e32:	b77fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201e36:	60a2                	ld	ra,8(sp)
ffffffffc0201e38:	8522                	mv	a0,s0
ffffffffc0201e3a:	6402                	ld	s0,0(sp)
ffffffffc0201e3c:	0141                	addi	sp,sp,16
ffffffffc0201e3e:	8082                	ret

ffffffffc0201e40 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e40:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201e44:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201e48:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e4a:	078e                	slli	a5,a5,0x3
{
ffffffffc0201e4c:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e4e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201e52:	6094                	ld	a3,0(s1)
{
ffffffffc0201e54:	f04a                	sd	s2,32(sp)
ffffffffc0201e56:	ec4e                	sd	s3,24(sp)
ffffffffc0201e58:	e852                	sd	s4,16(sp)
ffffffffc0201e5a:	fc06                	sd	ra,56(sp)
ffffffffc0201e5c:	f822                	sd	s0,48(sp)
ffffffffc0201e5e:	e456                	sd	s5,8(sp)
ffffffffc0201e60:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201e62:	0016f793          	andi	a5,a3,1
{
ffffffffc0201e66:	892e                	mv	s2,a1
ffffffffc0201e68:	8a32                	mv	s4,a2
ffffffffc0201e6a:	000c5997          	auipc	s3,0xc5
ffffffffc0201e6e:	d5698993          	addi	s3,s3,-682 # ffffffffc02c6bc0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201e72:	efbd                	bnez	a5,ffffffffc0201ef0 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e74:	14060c63          	beqz	a2,ffffffffc0201fcc <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e78:	100027f3          	csrr	a5,sstatus
ffffffffc0201e7c:	8b89                	andi	a5,a5,2
ffffffffc0201e7e:	14079963          	bnez	a5,ffffffffc0201fd0 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e82:	000c5797          	auipc	a5,0xc5
ffffffffc0201e86:	d4e7b783          	ld	a5,-690(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201e8a:	6f9c                	ld	a5,24(a5)
ffffffffc0201e8c:	4505                	li	a0,1
ffffffffc0201e8e:	9782                	jalr	a5
ffffffffc0201e90:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e92:	12040d63          	beqz	s0,ffffffffc0201fcc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201e96:	000c5b17          	auipc	s6,0xc5
ffffffffc0201e9a:	d32b0b13          	addi	s6,s6,-718 # ffffffffc02c6bc8 <pages>
ffffffffc0201e9e:	000b3503          	ld	a0,0(s6)
ffffffffc0201ea2:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201ea6:	000c5997          	auipc	s3,0xc5
ffffffffc0201eaa:	d1a98993          	addi	s3,s3,-742 # ffffffffc02c6bc0 <npage>
ffffffffc0201eae:	40a40533          	sub	a0,s0,a0
ffffffffc0201eb2:	8519                	srai	a0,a0,0x6
ffffffffc0201eb4:	9556                	add	a0,a0,s5
ffffffffc0201eb6:	0009b703          	ld	a4,0(s3)
ffffffffc0201eba:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201ebe:	4685                	li	a3,1
ffffffffc0201ec0:	c014                	sw	a3,0(s0)
ffffffffc0201ec2:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ec4:	0532                	slli	a0,a0,0xc
ffffffffc0201ec6:	16e7f763          	bgeu	a5,a4,ffffffffc0202034 <get_pte+0x1f4>
ffffffffc0201eca:	000c5797          	auipc	a5,0xc5
ffffffffc0201ece:	d0e7b783          	ld	a5,-754(a5) # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0201ed2:	6605                	lui	a2,0x1
ffffffffc0201ed4:	4581                	li	a1,0
ffffffffc0201ed6:	953e                	add	a0,a0,a5
ffffffffc0201ed8:	4fd030ef          	jal	ra,ffffffffc0205bd4 <memset>
    return page - pages + nbase;
ffffffffc0201edc:	000b3683          	ld	a3,0(s6)
ffffffffc0201ee0:	40d406b3          	sub	a3,s0,a3
ffffffffc0201ee4:	8699                	srai	a3,a3,0x6
ffffffffc0201ee6:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201ee8:	06aa                	slli	a3,a3,0xa
ffffffffc0201eea:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201eee:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201ef0:	77fd                	lui	a5,0xfffff
ffffffffc0201ef2:	068a                	slli	a3,a3,0x2
ffffffffc0201ef4:	0009b703          	ld	a4,0(s3)
ffffffffc0201ef8:	8efd                	and	a3,a3,a5
ffffffffc0201efa:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201efe:	10e7ff63          	bgeu	a5,a4,ffffffffc020201c <get_pte+0x1dc>
ffffffffc0201f02:	000c5a97          	auipc	s5,0xc5
ffffffffc0201f06:	cd6a8a93          	addi	s5,s5,-810 # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0201f0a:	000ab403          	ld	s0,0(s5)
ffffffffc0201f0e:	01595793          	srli	a5,s2,0x15
ffffffffc0201f12:	1ff7f793          	andi	a5,a5,511
ffffffffc0201f16:	96a2                	add	a3,a3,s0
ffffffffc0201f18:	00379413          	slli	s0,a5,0x3
ffffffffc0201f1c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201f1e:	6014                	ld	a3,0(s0)
ffffffffc0201f20:	0016f793          	andi	a5,a3,1
ffffffffc0201f24:	ebad                	bnez	a5,ffffffffc0201f96 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f26:	0a0a0363          	beqz	s4,ffffffffc0201fcc <get_pte+0x18c>
ffffffffc0201f2a:	100027f3          	csrr	a5,sstatus
ffffffffc0201f2e:	8b89                	andi	a5,a5,2
ffffffffc0201f30:	efcd                	bnez	a5,ffffffffc0201fea <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f32:	000c5797          	auipc	a5,0xc5
ffffffffc0201f36:	c9e7b783          	ld	a5,-866(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201f3a:	6f9c                	ld	a5,24(a5)
ffffffffc0201f3c:	4505                	li	a0,1
ffffffffc0201f3e:	9782                	jalr	a5
ffffffffc0201f40:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f42:	c4c9                	beqz	s1,ffffffffc0201fcc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201f44:	000c5b17          	auipc	s6,0xc5
ffffffffc0201f48:	c84b0b13          	addi	s6,s6,-892 # ffffffffc02c6bc8 <pages>
ffffffffc0201f4c:	000b3503          	ld	a0,0(s6)
ffffffffc0201f50:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f54:	0009b703          	ld	a4,0(s3)
ffffffffc0201f58:	40a48533          	sub	a0,s1,a0
ffffffffc0201f5c:	8519                	srai	a0,a0,0x6
ffffffffc0201f5e:	9552                	add	a0,a0,s4
ffffffffc0201f60:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201f64:	4685                	li	a3,1
ffffffffc0201f66:	c094                	sw	a3,0(s1)
ffffffffc0201f68:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201f6a:	0532                	slli	a0,a0,0xc
ffffffffc0201f6c:	0ee7f163          	bgeu	a5,a4,ffffffffc020204e <get_pte+0x20e>
ffffffffc0201f70:	000ab783          	ld	a5,0(s5)
ffffffffc0201f74:	6605                	lui	a2,0x1
ffffffffc0201f76:	4581                	li	a1,0
ffffffffc0201f78:	953e                	add	a0,a0,a5
ffffffffc0201f7a:	45b030ef          	jal	ra,ffffffffc0205bd4 <memset>
    return page - pages + nbase;
ffffffffc0201f7e:	000b3683          	ld	a3,0(s6)
ffffffffc0201f82:	40d486b3          	sub	a3,s1,a3
ffffffffc0201f86:	8699                	srai	a3,a3,0x6
ffffffffc0201f88:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f8a:	06aa                	slli	a3,a3,0xa
ffffffffc0201f8c:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f90:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f92:	0009b703          	ld	a4,0(s3)
ffffffffc0201f96:	068a                	slli	a3,a3,0x2
ffffffffc0201f98:	757d                	lui	a0,0xfffff
ffffffffc0201f9a:	8ee9                	and	a3,a3,a0
ffffffffc0201f9c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201fa0:	06e7f263          	bgeu	a5,a4,ffffffffc0202004 <get_pte+0x1c4>
ffffffffc0201fa4:	000ab503          	ld	a0,0(s5)
ffffffffc0201fa8:	00c95913          	srli	s2,s2,0xc
ffffffffc0201fac:	1ff97913          	andi	s2,s2,511
ffffffffc0201fb0:	96aa                	add	a3,a3,a0
ffffffffc0201fb2:	00391513          	slli	a0,s2,0x3
ffffffffc0201fb6:	9536                	add	a0,a0,a3
}
ffffffffc0201fb8:	70e2                	ld	ra,56(sp)
ffffffffc0201fba:	7442                	ld	s0,48(sp)
ffffffffc0201fbc:	74a2                	ld	s1,40(sp)
ffffffffc0201fbe:	7902                	ld	s2,32(sp)
ffffffffc0201fc0:	69e2                	ld	s3,24(sp)
ffffffffc0201fc2:	6a42                	ld	s4,16(sp)
ffffffffc0201fc4:	6aa2                	ld	s5,8(sp)
ffffffffc0201fc6:	6b02                	ld	s6,0(sp)
ffffffffc0201fc8:	6121                	addi	sp,sp,64
ffffffffc0201fca:	8082                	ret
            return NULL;
ffffffffc0201fcc:	4501                	li	a0,0
ffffffffc0201fce:	b7ed                	j	ffffffffc0201fb8 <get_pte+0x178>
        intr_disable();
ffffffffc0201fd0:	9dffe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fd4:	000c5797          	auipc	a5,0xc5
ffffffffc0201fd8:	bfc7b783          	ld	a5,-1028(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201fdc:	6f9c                	ld	a5,24(a5)
ffffffffc0201fde:	4505                	li	a0,1
ffffffffc0201fe0:	9782                	jalr	a5
ffffffffc0201fe2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201fe4:	9c5fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201fe8:	b56d                	j	ffffffffc0201e92 <get_pte+0x52>
        intr_disable();
ffffffffc0201fea:	9c5fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0201fee:	000c5797          	auipc	a5,0xc5
ffffffffc0201ff2:	be27b783          	ld	a5,-1054(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0201ff6:	6f9c                	ld	a5,24(a5)
ffffffffc0201ff8:	4505                	li	a0,1
ffffffffc0201ffa:	9782                	jalr	a5
ffffffffc0201ffc:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0201ffe:	9abfe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202002:	b781                	j	ffffffffc0201f42 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202004:	00005617          	auipc	a2,0x5
ffffffffc0202008:	a6460613          	addi	a2,a2,-1436 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc020200c:	0fa00593          	li	a1,250
ffffffffc0202010:	00005517          	auipc	a0,0x5
ffffffffc0202014:	b7050513          	addi	a0,a0,-1168 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202018:	c7afe0ef          	jal	ra,ffffffffc0200492 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020201c:	00005617          	auipc	a2,0x5
ffffffffc0202020:	a4c60613          	addi	a2,a2,-1460 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0202024:	0ed00593          	li	a1,237
ffffffffc0202028:	00005517          	auipc	a0,0x5
ffffffffc020202c:	b5850513          	addi	a0,a0,-1192 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202030:	c62fe0ef          	jal	ra,ffffffffc0200492 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202034:	86aa                	mv	a3,a0
ffffffffc0202036:	00005617          	auipc	a2,0x5
ffffffffc020203a:	a3260613          	addi	a2,a2,-1486 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc020203e:	0e900593          	li	a1,233
ffffffffc0202042:	00005517          	auipc	a0,0x5
ffffffffc0202046:	b3e50513          	addi	a0,a0,-1218 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc020204a:	c48fe0ef          	jal	ra,ffffffffc0200492 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020204e:	86aa                	mv	a3,a0
ffffffffc0202050:	00005617          	auipc	a2,0x5
ffffffffc0202054:	a1860613          	addi	a2,a2,-1512 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0202058:	0f700593          	li	a1,247
ffffffffc020205c:	00005517          	auipc	a0,0x5
ffffffffc0202060:	b2450513          	addi	a0,a0,-1244 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202064:	c2efe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0202068 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202068:	1141                	addi	sp,sp,-16
ffffffffc020206a:	e022                	sd	s0,0(sp)
ffffffffc020206c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020206e:	4601                	li	a2,0
{
ffffffffc0202070:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202072:	dcfff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
    if (ptep_store != NULL)
ffffffffc0202076:	c011                	beqz	s0,ffffffffc020207a <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202078:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020207a:	c511                	beqz	a0,ffffffffc0202086 <get_page+0x1e>
ffffffffc020207c:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020207e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202080:	0017f713          	andi	a4,a5,1
ffffffffc0202084:	e709                	bnez	a4,ffffffffc020208e <get_page+0x26>
}
ffffffffc0202086:	60a2                	ld	ra,8(sp)
ffffffffc0202088:	6402                	ld	s0,0(sp)
ffffffffc020208a:	0141                	addi	sp,sp,16
ffffffffc020208c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020208e:	078a                	slli	a5,a5,0x2
ffffffffc0202090:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202092:	000c5717          	auipc	a4,0xc5
ffffffffc0202096:	b2e73703          	ld	a4,-1234(a4) # ffffffffc02c6bc0 <npage>
ffffffffc020209a:	00e7ff63          	bgeu	a5,a4,ffffffffc02020b8 <get_page+0x50>
ffffffffc020209e:	60a2                	ld	ra,8(sp)
ffffffffc02020a0:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02020a2:	fff80537          	lui	a0,0xfff80
ffffffffc02020a6:	97aa                	add	a5,a5,a0
ffffffffc02020a8:	079a                	slli	a5,a5,0x6
ffffffffc02020aa:	000c5517          	auipc	a0,0xc5
ffffffffc02020ae:	b1e53503          	ld	a0,-1250(a0) # ffffffffc02c6bc8 <pages>
ffffffffc02020b2:	953e                	add	a0,a0,a5
ffffffffc02020b4:	0141                	addi	sp,sp,16
ffffffffc02020b6:	8082                	ret
ffffffffc02020b8:	c99ff0ef          	jal	ra,ffffffffc0201d50 <pa2page.part.0>

ffffffffc02020bc <unmap_range>:
        tlb_invalidate(pgdir, la); //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02020bc:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020be:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02020c2:	f486                	sd	ra,104(sp)
ffffffffc02020c4:	f0a2                	sd	s0,96(sp)
ffffffffc02020c6:	eca6                	sd	s1,88(sp)
ffffffffc02020c8:	e8ca                	sd	s2,80(sp)
ffffffffc02020ca:	e4ce                	sd	s3,72(sp)
ffffffffc02020cc:	e0d2                	sd	s4,64(sp)
ffffffffc02020ce:	fc56                	sd	s5,56(sp)
ffffffffc02020d0:	f85a                	sd	s6,48(sp)
ffffffffc02020d2:	f45e                	sd	s7,40(sp)
ffffffffc02020d4:	f062                	sd	s8,32(sp)
ffffffffc02020d6:	ec66                	sd	s9,24(sp)
ffffffffc02020d8:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020da:	17d2                	slli	a5,a5,0x34
ffffffffc02020dc:	e3ed                	bnez	a5,ffffffffc02021be <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02020de:	002007b7          	lui	a5,0x200
ffffffffc02020e2:	842e                	mv	s0,a1
ffffffffc02020e4:	0ef5ed63          	bltu	a1,a5,ffffffffc02021de <unmap_range+0x122>
ffffffffc02020e8:	8932                	mv	s2,a2
ffffffffc02020ea:	0ec5fa63          	bgeu	a1,a2,ffffffffc02021de <unmap_range+0x122>
ffffffffc02020ee:	4785                	li	a5,1
ffffffffc02020f0:	07fe                	slli	a5,a5,0x1f
ffffffffc02020f2:	0ec7e663          	bltu	a5,a2,ffffffffc02021de <unmap_range+0x122>
ffffffffc02020f6:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02020f8:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02020fa:	000c5c97          	auipc	s9,0xc5
ffffffffc02020fe:	ac6c8c93          	addi	s9,s9,-1338 # ffffffffc02c6bc0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202102:	000c5c17          	auipc	s8,0xc5
ffffffffc0202106:	ac6c0c13          	addi	s8,s8,-1338 # ffffffffc02c6bc8 <pages>
ffffffffc020210a:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020210e:	000c5d17          	auipc	s10,0xc5
ffffffffc0202112:	ac2d0d13          	addi	s10,s10,-1342 # ffffffffc02c6bd0 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202116:	00200b37          	lui	s6,0x200
ffffffffc020211a:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020211e:	4601                	li	a2,0
ffffffffc0202120:	85a2                	mv	a1,s0
ffffffffc0202122:	854e                	mv	a0,s3
ffffffffc0202124:	d1dff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
ffffffffc0202128:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020212a:	cd29                	beqz	a0,ffffffffc0202184 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc020212c:	611c                	ld	a5,0(a0)
ffffffffc020212e:	e395                	bnez	a5,ffffffffc0202152 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202130:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202132:	ff2466e3          	bltu	s0,s2,ffffffffc020211e <unmap_range+0x62>
}
ffffffffc0202136:	70a6                	ld	ra,104(sp)
ffffffffc0202138:	7406                	ld	s0,96(sp)
ffffffffc020213a:	64e6                	ld	s1,88(sp)
ffffffffc020213c:	6946                	ld	s2,80(sp)
ffffffffc020213e:	69a6                	ld	s3,72(sp)
ffffffffc0202140:	6a06                	ld	s4,64(sp)
ffffffffc0202142:	7ae2                	ld	s5,56(sp)
ffffffffc0202144:	7b42                	ld	s6,48(sp)
ffffffffc0202146:	7ba2                	ld	s7,40(sp)
ffffffffc0202148:	7c02                	ld	s8,32(sp)
ffffffffc020214a:	6ce2                	ld	s9,24(sp)
ffffffffc020214c:	6d42                	ld	s10,16(sp)
ffffffffc020214e:	6165                	addi	sp,sp,112
ffffffffc0202150:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202152:	0017f713          	andi	a4,a5,1
ffffffffc0202156:	df69                	beqz	a4,ffffffffc0202130 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202158:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc020215c:	078a                	slli	a5,a5,0x2
ffffffffc020215e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202160:	08e7ff63          	bgeu	a5,a4,ffffffffc02021fe <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202164:	000c3503          	ld	a0,0(s8)
ffffffffc0202168:	97de                	add	a5,a5,s7
ffffffffc020216a:	079a                	slli	a5,a5,0x6
ffffffffc020216c:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020216e:	411c                	lw	a5,0(a0)
ffffffffc0202170:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202174:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202176:	cf11                	beqz	a4,ffffffffc0202192 <unmap_range+0xd6>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0202178:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020217c:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202180:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202182:	bf45                	j	ffffffffc0202132 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202184:	945a                	add	s0,s0,s6
ffffffffc0202186:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020218a:	d455                	beqz	s0,ffffffffc0202136 <unmap_range+0x7a>
ffffffffc020218c:	f92469e3          	bltu	s0,s2,ffffffffc020211e <unmap_range+0x62>
ffffffffc0202190:	b75d                	j	ffffffffc0202136 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202192:	100027f3          	csrr	a5,sstatus
ffffffffc0202196:	8b89                	andi	a5,a5,2
ffffffffc0202198:	e799                	bnez	a5,ffffffffc02021a6 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc020219a:	000d3783          	ld	a5,0(s10)
ffffffffc020219e:	4585                	li	a1,1
ffffffffc02021a0:	739c                	ld	a5,32(a5)
ffffffffc02021a2:	9782                	jalr	a5
    if (flag)
ffffffffc02021a4:	bfd1                	j	ffffffffc0202178 <unmap_range+0xbc>
ffffffffc02021a6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02021a8:	807fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc02021ac:	000d3783          	ld	a5,0(s10)
ffffffffc02021b0:	6522                	ld	a0,8(sp)
ffffffffc02021b2:	4585                	li	a1,1
ffffffffc02021b4:	739c                	ld	a5,32(a5)
ffffffffc02021b6:	9782                	jalr	a5
        intr_enable();
ffffffffc02021b8:	ff0fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc02021bc:	bf75                	j	ffffffffc0202178 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021be:	00005697          	auipc	a3,0x5
ffffffffc02021c2:	9d268693          	addi	a3,a3,-1582 # ffffffffc0206b90 <default_pmm_manager+0x160>
ffffffffc02021c6:	00004617          	auipc	a2,0x4
ffffffffc02021ca:	4ba60613          	addi	a2,a2,1210 # ffffffffc0206680 <commands+0x818>
ffffffffc02021ce:	12200593          	li	a1,290
ffffffffc02021d2:	00005517          	auipc	a0,0x5
ffffffffc02021d6:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02021da:	ab8fe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02021de:	00005697          	auipc	a3,0x5
ffffffffc02021e2:	9e268693          	addi	a3,a3,-1566 # ffffffffc0206bc0 <default_pmm_manager+0x190>
ffffffffc02021e6:	00004617          	auipc	a2,0x4
ffffffffc02021ea:	49a60613          	addi	a2,a2,1178 # ffffffffc0206680 <commands+0x818>
ffffffffc02021ee:	12300593          	li	a1,291
ffffffffc02021f2:	00005517          	auipc	a0,0x5
ffffffffc02021f6:	98e50513          	addi	a0,a0,-1650 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02021fa:	a98fe0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc02021fe:	b53ff0ef          	jal	ra,ffffffffc0201d50 <pa2page.part.0>

ffffffffc0202202 <exit_range>:
{
ffffffffc0202202:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202204:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202208:	fc86                	sd	ra,120(sp)
ffffffffc020220a:	f8a2                	sd	s0,112(sp)
ffffffffc020220c:	f4a6                	sd	s1,104(sp)
ffffffffc020220e:	f0ca                	sd	s2,96(sp)
ffffffffc0202210:	ecce                	sd	s3,88(sp)
ffffffffc0202212:	e8d2                	sd	s4,80(sp)
ffffffffc0202214:	e4d6                	sd	s5,72(sp)
ffffffffc0202216:	e0da                	sd	s6,64(sp)
ffffffffc0202218:	fc5e                	sd	s7,56(sp)
ffffffffc020221a:	f862                	sd	s8,48(sp)
ffffffffc020221c:	f466                	sd	s9,40(sp)
ffffffffc020221e:	f06a                	sd	s10,32(sp)
ffffffffc0202220:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202222:	17d2                	slli	a5,a5,0x34
ffffffffc0202224:	20079a63          	bnez	a5,ffffffffc0202438 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202228:	002007b7          	lui	a5,0x200
ffffffffc020222c:	24f5e463          	bltu	a1,a5,ffffffffc0202474 <exit_range+0x272>
ffffffffc0202230:	8ab2                	mv	s5,a2
ffffffffc0202232:	24c5f163          	bgeu	a1,a2,ffffffffc0202474 <exit_range+0x272>
ffffffffc0202236:	4785                	li	a5,1
ffffffffc0202238:	07fe                	slli	a5,a5,0x1f
ffffffffc020223a:	22c7ed63          	bltu	a5,a2,ffffffffc0202474 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020223e:	c00009b7          	lui	s3,0xc0000
ffffffffc0202242:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202246:	ffe00937          	lui	s2,0xffe00
ffffffffc020224a:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020224e:	5cfd                	li	s9,-1
ffffffffc0202250:	8c2a                	mv	s8,a0
ffffffffc0202252:	0125f933          	and	s2,a1,s2
ffffffffc0202256:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202258:	000c5d17          	auipc	s10,0xc5
ffffffffc020225c:	968d0d13          	addi	s10,s10,-1688 # ffffffffc02c6bc0 <npage>
    return KADDR(page2pa(page));
ffffffffc0202260:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202264:	000c5717          	auipc	a4,0xc5
ffffffffc0202268:	96470713          	addi	a4,a4,-1692 # ffffffffc02c6bc8 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc020226c:	000c5d97          	auipc	s11,0xc5
ffffffffc0202270:	964d8d93          	addi	s11,s11,-1692 # ffffffffc02c6bd0 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202274:	c0000437          	lui	s0,0xc0000
ffffffffc0202278:	944e                	add	s0,s0,s3
ffffffffc020227a:	8079                	srli	s0,s0,0x1e
ffffffffc020227c:	1ff47413          	andi	s0,s0,511
ffffffffc0202280:	040e                	slli	s0,s0,0x3
ffffffffc0202282:	9462                	add	s0,s0,s8
ffffffffc0202284:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff38f0>
        if (pde1 & PTE_V)
ffffffffc0202288:	001a7793          	andi	a5,s4,1
ffffffffc020228c:	eb99                	bnez	a5,ffffffffc02022a2 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc020228e:	12098463          	beqz	s3,ffffffffc02023b6 <exit_range+0x1b4>
ffffffffc0202292:	400007b7          	lui	a5,0x40000
ffffffffc0202296:	97ce                	add	a5,a5,s3
ffffffffc0202298:	894e                	mv	s2,s3
ffffffffc020229a:	1159fe63          	bgeu	s3,s5,ffffffffc02023b6 <exit_range+0x1b4>
ffffffffc020229e:	89be                	mv	s3,a5
ffffffffc02022a0:	bfd1                	j	ffffffffc0202274 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02022a2:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02022a6:	0a0a                	slli	s4,s4,0x2
ffffffffc02022a8:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc02022ac:	1cfa7263          	bgeu	s4,a5,ffffffffc0202470 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02022b0:	fff80637          	lui	a2,0xfff80
ffffffffc02022b4:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc02022b6:	000806b7          	lui	a3,0x80
ffffffffc02022ba:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02022bc:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02022c0:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02022c2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02022c4:	18f5fa63          	bgeu	a1,a5,ffffffffc0202458 <exit_range+0x256>
ffffffffc02022c8:	000c5817          	auipc	a6,0xc5
ffffffffc02022cc:	91080813          	addi	a6,a6,-1776 # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc02022d0:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02022d4:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02022d6:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02022da:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02022dc:	00080337          	lui	t1,0x80
ffffffffc02022e0:	6885                	lui	a7,0x1
ffffffffc02022e2:	a819                	j	ffffffffc02022f8 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc02022e4:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc02022e6:	002007b7          	lui	a5,0x200
ffffffffc02022ea:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02022ec:	08090c63          	beqz	s2,ffffffffc0202384 <exit_range+0x182>
ffffffffc02022f0:	09397a63          	bgeu	s2,s3,ffffffffc0202384 <exit_range+0x182>
ffffffffc02022f4:	0f597063          	bgeu	s2,s5,ffffffffc02023d4 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02022f8:	01595493          	srli	s1,s2,0x15
ffffffffc02022fc:	1ff4f493          	andi	s1,s1,511
ffffffffc0202300:	048e                	slli	s1,s1,0x3
ffffffffc0202302:	94da                	add	s1,s1,s6
ffffffffc0202304:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202306:	0017f693          	andi	a3,a5,1
ffffffffc020230a:	dee9                	beqz	a3,ffffffffc02022e4 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc020230c:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202310:	078a                	slli	a5,a5,0x2
ffffffffc0202312:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202314:	14b7fe63          	bgeu	a5,a1,ffffffffc0202470 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202318:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020231a:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020231e:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202322:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202326:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202328:	12bef863          	bgeu	t4,a1,ffffffffc0202458 <exit_range+0x256>
ffffffffc020232c:	00083783          	ld	a5,0(a6)
ffffffffc0202330:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202332:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202336:	629c                	ld	a5,0(a3)
ffffffffc0202338:	8b85                	andi	a5,a5,1
ffffffffc020233a:	f7d5                	bnez	a5,ffffffffc02022e6 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020233c:	06a1                	addi	a3,a3,8
ffffffffc020233e:	fed59ce3          	bne	a1,a3,ffffffffc0202336 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202342:	631c                	ld	a5,0(a4)
ffffffffc0202344:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202346:	100027f3          	csrr	a5,sstatus
ffffffffc020234a:	8b89                	andi	a5,a5,2
ffffffffc020234c:	e7d9                	bnez	a5,ffffffffc02023da <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020234e:	000db783          	ld	a5,0(s11)
ffffffffc0202352:	4585                	li	a1,1
ffffffffc0202354:	e032                	sd	a2,0(sp)
ffffffffc0202356:	739c                	ld	a5,32(a5)
ffffffffc0202358:	9782                	jalr	a5
    if (flag)
ffffffffc020235a:	6602                	ld	a2,0(sp)
ffffffffc020235c:	000c5817          	auipc	a6,0xc5
ffffffffc0202360:	87c80813          	addi	a6,a6,-1924 # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0202364:	fff80e37          	lui	t3,0xfff80
ffffffffc0202368:	00080337          	lui	t1,0x80
ffffffffc020236c:	6885                	lui	a7,0x1
ffffffffc020236e:	000c5717          	auipc	a4,0xc5
ffffffffc0202372:	85a70713          	addi	a4,a4,-1958 # ffffffffc02c6bc8 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202376:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020237a:	002007b7          	lui	a5,0x200
ffffffffc020237e:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202380:	f60918e3          	bnez	s2,ffffffffc02022f0 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202384:	f00b85e3          	beqz	s7,ffffffffc020228e <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202388:	000d3783          	ld	a5,0(s10)
ffffffffc020238c:	0efa7263          	bgeu	s4,a5,ffffffffc0202470 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202390:	6308                	ld	a0,0(a4)
ffffffffc0202392:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202394:	100027f3          	csrr	a5,sstatus
ffffffffc0202398:	8b89                	andi	a5,a5,2
ffffffffc020239a:	efad                	bnez	a5,ffffffffc0202414 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc020239c:	000db783          	ld	a5,0(s11)
ffffffffc02023a0:	4585                	li	a1,1
ffffffffc02023a2:	739c                	ld	a5,32(a5)
ffffffffc02023a4:	9782                	jalr	a5
ffffffffc02023a6:	000c5717          	auipc	a4,0xc5
ffffffffc02023aa:	82270713          	addi	a4,a4,-2014 # ffffffffc02c6bc8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02023ae:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02023b2:	ee0990e3          	bnez	s3,ffffffffc0202292 <exit_range+0x90>
}
ffffffffc02023b6:	70e6                	ld	ra,120(sp)
ffffffffc02023b8:	7446                	ld	s0,112(sp)
ffffffffc02023ba:	74a6                	ld	s1,104(sp)
ffffffffc02023bc:	7906                	ld	s2,96(sp)
ffffffffc02023be:	69e6                	ld	s3,88(sp)
ffffffffc02023c0:	6a46                	ld	s4,80(sp)
ffffffffc02023c2:	6aa6                	ld	s5,72(sp)
ffffffffc02023c4:	6b06                	ld	s6,64(sp)
ffffffffc02023c6:	7be2                	ld	s7,56(sp)
ffffffffc02023c8:	7c42                	ld	s8,48(sp)
ffffffffc02023ca:	7ca2                	ld	s9,40(sp)
ffffffffc02023cc:	7d02                	ld	s10,32(sp)
ffffffffc02023ce:	6de2                	ld	s11,24(sp)
ffffffffc02023d0:	6109                	addi	sp,sp,128
ffffffffc02023d2:	8082                	ret
            if (free_pd0)
ffffffffc02023d4:	ea0b8fe3          	beqz	s7,ffffffffc0202292 <exit_range+0x90>
ffffffffc02023d8:	bf45                	j	ffffffffc0202388 <exit_range+0x186>
ffffffffc02023da:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02023dc:	e42a                	sd	a0,8(sp)
ffffffffc02023de:	dd0fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02023e2:	000db783          	ld	a5,0(s11)
ffffffffc02023e6:	6522                	ld	a0,8(sp)
ffffffffc02023e8:	4585                	li	a1,1
ffffffffc02023ea:	739c                	ld	a5,32(a5)
ffffffffc02023ec:	9782                	jalr	a5
        intr_enable();
ffffffffc02023ee:	dbafe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc02023f2:	6602                	ld	a2,0(sp)
ffffffffc02023f4:	000c4717          	auipc	a4,0xc4
ffffffffc02023f8:	7d470713          	addi	a4,a4,2004 # ffffffffc02c6bc8 <pages>
ffffffffc02023fc:	6885                	lui	a7,0x1
ffffffffc02023fe:	00080337          	lui	t1,0x80
ffffffffc0202402:	fff80e37          	lui	t3,0xfff80
ffffffffc0202406:	000c4817          	auipc	a6,0xc4
ffffffffc020240a:	7d280813          	addi	a6,a6,2002 # ffffffffc02c6bd8 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020240e:	0004b023          	sd	zero,0(s1)
ffffffffc0202412:	b7a5                	j	ffffffffc020237a <exit_range+0x178>
ffffffffc0202414:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202416:	d98fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020241a:	000db783          	ld	a5,0(s11)
ffffffffc020241e:	6502                	ld	a0,0(sp)
ffffffffc0202420:	4585                	li	a1,1
ffffffffc0202422:	739c                	ld	a5,32(a5)
ffffffffc0202424:	9782                	jalr	a5
        intr_enable();
ffffffffc0202426:	d82fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020242a:	000c4717          	auipc	a4,0xc4
ffffffffc020242e:	79e70713          	addi	a4,a4,1950 # ffffffffc02c6bc8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202432:	00043023          	sd	zero,0(s0)
ffffffffc0202436:	bfb5                	j	ffffffffc02023b2 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202438:	00004697          	auipc	a3,0x4
ffffffffc020243c:	75868693          	addi	a3,a3,1880 # ffffffffc0206b90 <default_pmm_manager+0x160>
ffffffffc0202440:	00004617          	auipc	a2,0x4
ffffffffc0202444:	24060613          	addi	a2,a2,576 # ffffffffc0206680 <commands+0x818>
ffffffffc0202448:	13700593          	li	a1,311
ffffffffc020244c:	00004517          	auipc	a0,0x4
ffffffffc0202450:	73450513          	addi	a0,a0,1844 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202454:	83efe0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202458:	00004617          	auipc	a2,0x4
ffffffffc020245c:	61060613          	addi	a2,a2,1552 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0202460:	07100593          	li	a1,113
ffffffffc0202464:	00004517          	auipc	a0,0x4
ffffffffc0202468:	62c50513          	addi	a0,a0,1580 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc020246c:	826fe0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0202470:	8e1ff0ef          	jal	ra,ffffffffc0201d50 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202474:	00004697          	auipc	a3,0x4
ffffffffc0202478:	74c68693          	addi	a3,a3,1868 # ffffffffc0206bc0 <default_pmm_manager+0x190>
ffffffffc020247c:	00004617          	auipc	a2,0x4
ffffffffc0202480:	20460613          	addi	a2,a2,516 # ffffffffc0206680 <commands+0x818>
ffffffffc0202484:	13800593          	li	a1,312
ffffffffc0202488:	00004517          	auipc	a0,0x4
ffffffffc020248c:	6f850513          	addi	a0,a0,1784 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202490:	802fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0202494 <page_remove>:
{
ffffffffc0202494:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202496:	4601                	li	a2,0
{
ffffffffc0202498:	ec26                	sd	s1,24(sp)
ffffffffc020249a:	f406                	sd	ra,40(sp)
ffffffffc020249c:	f022                	sd	s0,32(sp)
ffffffffc020249e:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02024a0:	9a1ff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
    if (ptep != NULL)
ffffffffc02024a4:	c511                	beqz	a0,ffffffffc02024b0 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc02024a6:	611c                	ld	a5,0(a0)
ffffffffc02024a8:	842a                	mv	s0,a0
ffffffffc02024aa:	0017f713          	andi	a4,a5,1
ffffffffc02024ae:	e711                	bnez	a4,ffffffffc02024ba <page_remove+0x26>
}
ffffffffc02024b0:	70a2                	ld	ra,40(sp)
ffffffffc02024b2:	7402                	ld	s0,32(sp)
ffffffffc02024b4:	64e2                	ld	s1,24(sp)
ffffffffc02024b6:	6145                	addi	sp,sp,48
ffffffffc02024b8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02024ba:	078a                	slli	a5,a5,0x2
ffffffffc02024bc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024be:	000c4717          	auipc	a4,0xc4
ffffffffc02024c2:	70273703          	ld	a4,1794(a4) # ffffffffc02c6bc0 <npage>
ffffffffc02024c6:	06e7f363          	bgeu	a5,a4,ffffffffc020252c <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02024ca:	fff80537          	lui	a0,0xfff80
ffffffffc02024ce:	97aa                	add	a5,a5,a0
ffffffffc02024d0:	079a                	slli	a5,a5,0x6
ffffffffc02024d2:	000c4517          	auipc	a0,0xc4
ffffffffc02024d6:	6f653503          	ld	a0,1782(a0) # ffffffffc02c6bc8 <pages>
ffffffffc02024da:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02024dc:	411c                	lw	a5,0(a0)
ffffffffc02024de:	fff7871b          	addiw	a4,a5,-1
ffffffffc02024e2:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02024e4:	cb11                	beqz	a4,ffffffffc02024f8 <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc02024e6:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02024ea:	12048073          	sfence.vma	s1
}
ffffffffc02024ee:	70a2                	ld	ra,40(sp)
ffffffffc02024f0:	7402                	ld	s0,32(sp)
ffffffffc02024f2:	64e2                	ld	s1,24(sp)
ffffffffc02024f4:	6145                	addi	sp,sp,48
ffffffffc02024f6:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024f8:	100027f3          	csrr	a5,sstatus
ffffffffc02024fc:	8b89                	andi	a5,a5,2
ffffffffc02024fe:	eb89                	bnez	a5,ffffffffc0202510 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202500:	000c4797          	auipc	a5,0xc4
ffffffffc0202504:	6d07b783          	ld	a5,1744(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0202508:	739c                	ld	a5,32(a5)
ffffffffc020250a:	4585                	li	a1,1
ffffffffc020250c:	9782                	jalr	a5
    if (flag)
ffffffffc020250e:	bfe1                	j	ffffffffc02024e6 <page_remove+0x52>
        intr_disable();
ffffffffc0202510:	e42a                	sd	a0,8(sp)
ffffffffc0202512:	c9cfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202516:	000c4797          	auipc	a5,0xc4
ffffffffc020251a:	6ba7b783          	ld	a5,1722(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc020251e:	739c                	ld	a5,32(a5)
ffffffffc0202520:	6522                	ld	a0,8(sp)
ffffffffc0202522:	4585                	li	a1,1
ffffffffc0202524:	9782                	jalr	a5
        intr_enable();
ffffffffc0202526:	c82fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020252a:	bf75                	j	ffffffffc02024e6 <page_remove+0x52>
ffffffffc020252c:	825ff0ef          	jal	ra,ffffffffc0201d50 <pa2page.part.0>

ffffffffc0202530 <page_insert>:
{
ffffffffc0202530:	7139                	addi	sp,sp,-64
ffffffffc0202532:	e852                	sd	s4,16(sp)
ffffffffc0202534:	8a32                	mv	s4,a2
ffffffffc0202536:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202538:	4605                	li	a2,1
{
ffffffffc020253a:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020253c:	85d2                	mv	a1,s4
{
ffffffffc020253e:	f426                	sd	s1,40(sp)
ffffffffc0202540:	fc06                	sd	ra,56(sp)
ffffffffc0202542:	f04a                	sd	s2,32(sp)
ffffffffc0202544:	ec4e                	sd	s3,24(sp)
ffffffffc0202546:	e456                	sd	s5,8(sp)
ffffffffc0202548:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020254a:	8f7ff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
    if (ptep == NULL)
ffffffffc020254e:	c961                	beqz	a0,ffffffffc020261e <page_insert+0xee>
    page->ref += 1;
ffffffffc0202550:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202552:	611c                	ld	a5,0(a0)
ffffffffc0202554:	89aa                	mv	s3,a0
ffffffffc0202556:	0016871b          	addiw	a4,a3,1
ffffffffc020255a:	c018                	sw	a4,0(s0)
ffffffffc020255c:	0017f713          	andi	a4,a5,1
ffffffffc0202560:	ef05                	bnez	a4,ffffffffc0202598 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202562:	000c4717          	auipc	a4,0xc4
ffffffffc0202566:	66673703          	ld	a4,1638(a4) # ffffffffc02c6bc8 <pages>
ffffffffc020256a:	8c19                	sub	s0,s0,a4
ffffffffc020256c:	000807b7          	lui	a5,0x80
ffffffffc0202570:	8419                	srai	s0,s0,0x6
ffffffffc0202572:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202574:	042a                	slli	s0,s0,0xa
ffffffffc0202576:	8cc1                	or	s1,s1,s0
ffffffffc0202578:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc020257c:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff38f0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202580:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202584:	4501                	li	a0,0
}
ffffffffc0202586:	70e2                	ld	ra,56(sp)
ffffffffc0202588:	7442                	ld	s0,48(sp)
ffffffffc020258a:	74a2                	ld	s1,40(sp)
ffffffffc020258c:	7902                	ld	s2,32(sp)
ffffffffc020258e:	69e2                	ld	s3,24(sp)
ffffffffc0202590:	6a42                	ld	s4,16(sp)
ffffffffc0202592:	6aa2                	ld	s5,8(sp)
ffffffffc0202594:	6121                	addi	sp,sp,64
ffffffffc0202596:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202598:	078a                	slli	a5,a5,0x2
ffffffffc020259a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020259c:	000c4717          	auipc	a4,0xc4
ffffffffc02025a0:	62473703          	ld	a4,1572(a4) # ffffffffc02c6bc0 <npage>
ffffffffc02025a4:	06e7ff63          	bgeu	a5,a4,ffffffffc0202622 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02025a8:	000c4a97          	auipc	s5,0xc4
ffffffffc02025ac:	620a8a93          	addi	s5,s5,1568 # ffffffffc02c6bc8 <pages>
ffffffffc02025b0:	000ab703          	ld	a4,0(s5)
ffffffffc02025b4:	fff80937          	lui	s2,0xfff80
ffffffffc02025b8:	993e                	add	s2,s2,a5
ffffffffc02025ba:	091a                	slli	s2,s2,0x6
ffffffffc02025bc:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02025be:	01240c63          	beq	s0,s2,ffffffffc02025d6 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02025c2:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcb93f0>
ffffffffc02025c6:	fff7869b          	addiw	a3,a5,-1
ffffffffc02025ca:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc02025ce:	c691                	beqz	a3,ffffffffc02025da <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025d0:	120a0073          	sfence.vma	s4
}
ffffffffc02025d4:	bf59                	j	ffffffffc020256a <page_insert+0x3a>
ffffffffc02025d6:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02025d8:	bf49                	j	ffffffffc020256a <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02025da:	100027f3          	csrr	a5,sstatus
ffffffffc02025de:	8b89                	andi	a5,a5,2
ffffffffc02025e0:	ef91                	bnez	a5,ffffffffc02025fc <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc02025e2:	000c4797          	auipc	a5,0xc4
ffffffffc02025e6:	5ee7b783          	ld	a5,1518(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc02025ea:	739c                	ld	a5,32(a5)
ffffffffc02025ec:	4585                	li	a1,1
ffffffffc02025ee:	854a                	mv	a0,s2
ffffffffc02025f0:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02025f2:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025f6:	120a0073          	sfence.vma	s4
ffffffffc02025fa:	bf85                	j	ffffffffc020256a <page_insert+0x3a>
        intr_disable();
ffffffffc02025fc:	bb2fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202600:	000c4797          	auipc	a5,0xc4
ffffffffc0202604:	5d07b783          	ld	a5,1488(a5) # ffffffffc02c6bd0 <pmm_manager>
ffffffffc0202608:	739c                	ld	a5,32(a5)
ffffffffc020260a:	4585                	li	a1,1
ffffffffc020260c:	854a                	mv	a0,s2
ffffffffc020260e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202610:	b98fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202614:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202618:	120a0073          	sfence.vma	s4
ffffffffc020261c:	b7b9                	j	ffffffffc020256a <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020261e:	5571                	li	a0,-4
ffffffffc0202620:	b79d                	j	ffffffffc0202586 <page_insert+0x56>
ffffffffc0202622:	f2eff0ef          	jal	ra,ffffffffc0201d50 <pa2page.part.0>

ffffffffc0202626 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202626:	00004797          	auipc	a5,0x4
ffffffffc020262a:	40a78793          	addi	a5,a5,1034 # ffffffffc0206a30 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020262e:	638c                	ld	a1,0(a5)
{
ffffffffc0202630:	7159                	addi	sp,sp,-112
ffffffffc0202632:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202634:	00004517          	auipc	a0,0x4
ffffffffc0202638:	5a450513          	addi	a0,a0,1444 # ffffffffc0206bd8 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc020263c:	000c4b17          	auipc	s6,0xc4
ffffffffc0202640:	594b0b13          	addi	s6,s6,1428 # ffffffffc02c6bd0 <pmm_manager>
{
ffffffffc0202644:	f486                	sd	ra,104(sp)
ffffffffc0202646:	e8ca                	sd	s2,80(sp)
ffffffffc0202648:	e4ce                	sd	s3,72(sp)
ffffffffc020264a:	f0a2                	sd	s0,96(sp)
ffffffffc020264c:	eca6                	sd	s1,88(sp)
ffffffffc020264e:	e0d2                	sd	s4,64(sp)
ffffffffc0202650:	fc56                	sd	s5,56(sp)
ffffffffc0202652:	f45e                	sd	s7,40(sp)
ffffffffc0202654:	f062                	sd	s8,32(sp)
ffffffffc0202656:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202658:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020265c:	b3dfd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    pmm_manager->init();
ffffffffc0202660:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202664:	000c4997          	auipc	s3,0xc4
ffffffffc0202668:	57498993          	addi	s3,s3,1396 # ffffffffc02c6bd8 <va_pa_offset>
    pmm_manager->init();
ffffffffc020266c:	679c                	ld	a5,8(a5)
ffffffffc020266e:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202670:	57f5                	li	a5,-3
ffffffffc0202672:	07fa                	slli	a5,a5,0x1e
ffffffffc0202674:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202678:	b1cfe0ef          	jal	ra,ffffffffc0200994 <get_memory_base>
ffffffffc020267c:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020267e:	b20fe0ef          	jal	ra,ffffffffc020099e <get_memory_size>
    if (mem_size == 0)
ffffffffc0202682:	200505e3          	beqz	a0,ffffffffc020308c <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202686:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202688:	00004517          	auipc	a0,0x4
ffffffffc020268c:	58850513          	addi	a0,a0,1416 # ffffffffc0206c10 <default_pmm_manager+0x1e0>
ffffffffc0202690:	b09fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202694:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202698:	fff40693          	addi	a3,s0,-1
ffffffffc020269c:	864a                	mv	a2,s2
ffffffffc020269e:	85a6                	mv	a1,s1
ffffffffc02026a0:	00004517          	auipc	a0,0x4
ffffffffc02026a4:	58850513          	addi	a0,a0,1416 # ffffffffc0206c28 <default_pmm_manager+0x1f8>
ffffffffc02026a8:	af1fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02026ac:	c8000737          	lui	a4,0xc8000
ffffffffc02026b0:	87a2                	mv	a5,s0
ffffffffc02026b2:	54876163          	bltu	a4,s0,ffffffffc0202bf4 <pmm_init+0x5ce>
ffffffffc02026b6:	757d                	lui	a0,0xfffff
ffffffffc02026b8:	000c5617          	auipc	a2,0xc5
ffffffffc02026bc:	55760613          	addi	a2,a2,1367 # ffffffffc02c7c0f <end+0xfff>
ffffffffc02026c0:	8e69                	and	a2,a2,a0
ffffffffc02026c2:	000c4497          	auipc	s1,0xc4
ffffffffc02026c6:	4fe48493          	addi	s1,s1,1278 # ffffffffc02c6bc0 <npage>
ffffffffc02026ca:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02026ce:	000c4b97          	auipc	s7,0xc4
ffffffffc02026d2:	4fab8b93          	addi	s7,s7,1274 # ffffffffc02c6bc8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02026d6:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02026d8:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026dc:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02026e0:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026e2:	02f50863          	beq	a0,a5,ffffffffc0202712 <pmm_init+0xec>
ffffffffc02026e6:	4781                	li	a5,0
ffffffffc02026e8:	4585                	li	a1,1
ffffffffc02026ea:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02026ee:	00679513          	slli	a0,a5,0x6
ffffffffc02026f2:	9532                	add	a0,a0,a2
ffffffffc02026f4:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd383f8>
ffffffffc02026f8:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026fc:	6088                	ld	a0,0(s1)
ffffffffc02026fe:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202700:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202704:	00d50733          	add	a4,a0,a3
ffffffffc0202708:	fee7e3e3          	bltu	a5,a4,ffffffffc02026ee <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020270c:	071a                	slli	a4,a4,0x6
ffffffffc020270e:	00e606b3          	add	a3,a2,a4
ffffffffc0202712:	c02007b7          	lui	a5,0xc0200
ffffffffc0202716:	2ef6ece3          	bltu	a3,a5,ffffffffc020320e <pmm_init+0xbe8>
ffffffffc020271a:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020271e:	77fd                	lui	a5,0xfffff
ffffffffc0202720:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202722:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202724:	5086eb63          	bltu	a3,s0,ffffffffc0202c3a <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202728:	00004517          	auipc	a0,0x4
ffffffffc020272c:	52850513          	addi	a0,a0,1320 # ffffffffc0206c50 <default_pmm_manager+0x220>
ffffffffc0202730:	a69fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202734:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202738:	000c4917          	auipc	s2,0xc4
ffffffffc020273c:	48090913          	addi	s2,s2,1152 # ffffffffc02c6bb8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202740:	7b9c                	ld	a5,48(a5)
ffffffffc0202742:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202744:	00004517          	auipc	a0,0x4
ffffffffc0202748:	52450513          	addi	a0,a0,1316 # ffffffffc0206c68 <default_pmm_manager+0x238>
ffffffffc020274c:	a4dfd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202750:	00009697          	auipc	a3,0x9
ffffffffc0202754:	8b068693          	addi	a3,a3,-1872 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc0202758:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020275c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202760:	28f6ebe3          	bltu	a3,a5,ffffffffc02031f6 <pmm_init+0xbd0>
ffffffffc0202764:	0009b783          	ld	a5,0(s3)
ffffffffc0202768:	8e9d                	sub	a3,a3,a5
ffffffffc020276a:	000c4797          	auipc	a5,0xc4
ffffffffc020276e:	44d7b323          	sd	a3,1094(a5) # ffffffffc02c6bb0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202772:	100027f3          	csrr	a5,sstatus
ffffffffc0202776:	8b89                	andi	a5,a5,2
ffffffffc0202778:	4a079763          	bnez	a5,ffffffffc0202c26 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc020277c:	000b3783          	ld	a5,0(s6)
ffffffffc0202780:	779c                	ld	a5,40(a5)
ffffffffc0202782:	9782                	jalr	a5
ffffffffc0202784:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202786:	6098                	ld	a4,0(s1)
ffffffffc0202788:	c80007b7          	lui	a5,0xc8000
ffffffffc020278c:	83b1                	srli	a5,a5,0xc
ffffffffc020278e:	66e7e363          	bltu	a5,a4,ffffffffc0202df4 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202792:	00093503          	ld	a0,0(s2)
ffffffffc0202796:	62050f63          	beqz	a0,ffffffffc0202dd4 <pmm_init+0x7ae>
ffffffffc020279a:	03451793          	slli	a5,a0,0x34
ffffffffc020279e:	62079b63          	bnez	a5,ffffffffc0202dd4 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02027a2:	4601                	li	a2,0
ffffffffc02027a4:	4581                	li	a1,0
ffffffffc02027a6:	8c3ff0ef          	jal	ra,ffffffffc0202068 <get_page>
ffffffffc02027aa:	60051563          	bnez	a0,ffffffffc0202db4 <pmm_init+0x78e>
ffffffffc02027ae:	100027f3          	csrr	a5,sstatus
ffffffffc02027b2:	8b89                	andi	a5,a5,2
ffffffffc02027b4:	44079e63          	bnez	a5,ffffffffc0202c10 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02027b8:	000b3783          	ld	a5,0(s6)
ffffffffc02027bc:	4505                	li	a0,1
ffffffffc02027be:	6f9c                	ld	a5,24(a5)
ffffffffc02027c0:	9782                	jalr	a5
ffffffffc02027c2:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02027c4:	00093503          	ld	a0,0(s2)
ffffffffc02027c8:	4681                	li	a3,0
ffffffffc02027ca:	4601                	li	a2,0
ffffffffc02027cc:	85d2                	mv	a1,s4
ffffffffc02027ce:	d63ff0ef          	jal	ra,ffffffffc0202530 <page_insert>
ffffffffc02027d2:	26051ae3          	bnez	a0,ffffffffc0203246 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02027d6:	00093503          	ld	a0,0(s2)
ffffffffc02027da:	4601                	li	a2,0
ffffffffc02027dc:	4581                	li	a1,0
ffffffffc02027de:	e62ff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
ffffffffc02027e2:	240502e3          	beqz	a0,ffffffffc0203226 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc02027e6:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc02027e8:	0017f713          	andi	a4,a5,1
ffffffffc02027ec:	5a070263          	beqz	a4,ffffffffc0202d90 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc02027f0:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02027f2:	078a                	slli	a5,a5,0x2
ffffffffc02027f4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02027f6:	58e7fb63          	bgeu	a5,a4,ffffffffc0202d8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02027fa:	000bb683          	ld	a3,0(s7)
ffffffffc02027fe:	fff80637          	lui	a2,0xfff80
ffffffffc0202802:	97b2                	add	a5,a5,a2
ffffffffc0202804:	079a                	slli	a5,a5,0x6
ffffffffc0202806:	97b6                	add	a5,a5,a3
ffffffffc0202808:	14fa17e3          	bne	s4,a5,ffffffffc0203156 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc020280c:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f40>
ffffffffc0202810:	4785                	li	a5,1
ffffffffc0202812:	12f692e3          	bne	a3,a5,ffffffffc0203136 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202816:	00093503          	ld	a0,0(s2)
ffffffffc020281a:	77fd                	lui	a5,0xfffff
ffffffffc020281c:	6114                	ld	a3,0(a0)
ffffffffc020281e:	068a                	slli	a3,a3,0x2
ffffffffc0202820:	8efd                	and	a3,a3,a5
ffffffffc0202822:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202826:	0ee67ce3          	bgeu	a2,a4,ffffffffc020311e <pmm_init+0xaf8>
ffffffffc020282a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020282e:	96e2                	add	a3,a3,s8
ffffffffc0202830:	0006ba83          	ld	s5,0(a3)
ffffffffc0202834:	0a8a                	slli	s5,s5,0x2
ffffffffc0202836:	00fafab3          	and	s5,s5,a5
ffffffffc020283a:	00cad793          	srli	a5,s5,0xc
ffffffffc020283e:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203104 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202842:	4601                	li	a2,0
ffffffffc0202844:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202846:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202848:	df8ff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020284c:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020284e:	55551363          	bne	a0,s5,ffffffffc0202d94 <pmm_init+0x76e>
ffffffffc0202852:	100027f3          	csrr	a5,sstatus
ffffffffc0202856:	8b89                	andi	a5,a5,2
ffffffffc0202858:	3a079163          	bnez	a5,ffffffffc0202bfa <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc020285c:	000b3783          	ld	a5,0(s6)
ffffffffc0202860:	4505                	li	a0,1
ffffffffc0202862:	6f9c                	ld	a5,24(a5)
ffffffffc0202864:	9782                	jalr	a5
ffffffffc0202866:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202868:	00093503          	ld	a0,0(s2)
ffffffffc020286c:	46d1                	li	a3,20
ffffffffc020286e:	6605                	lui	a2,0x1
ffffffffc0202870:	85e2                	mv	a1,s8
ffffffffc0202872:	cbfff0ef          	jal	ra,ffffffffc0202530 <page_insert>
ffffffffc0202876:	060517e3          	bnez	a0,ffffffffc02030e4 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020287a:	00093503          	ld	a0,0(s2)
ffffffffc020287e:	4601                	li	a2,0
ffffffffc0202880:	6585                	lui	a1,0x1
ffffffffc0202882:	dbeff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
ffffffffc0202886:	02050fe3          	beqz	a0,ffffffffc02030c4 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc020288a:	611c                	ld	a5,0(a0)
ffffffffc020288c:	0107f713          	andi	a4,a5,16
ffffffffc0202890:	7c070e63          	beqz	a4,ffffffffc020306c <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0202894:	8b91                	andi	a5,a5,4
ffffffffc0202896:	7a078b63          	beqz	a5,ffffffffc020304c <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020289a:	00093503          	ld	a0,0(s2)
ffffffffc020289e:	611c                	ld	a5,0(a0)
ffffffffc02028a0:	8bc1                	andi	a5,a5,16
ffffffffc02028a2:	78078563          	beqz	a5,ffffffffc020302c <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02028a6:	000c2703          	lw	a4,0(s8)
ffffffffc02028aa:	4785                	li	a5,1
ffffffffc02028ac:	76f71063          	bne	a4,a5,ffffffffc020300c <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02028b0:	4681                	li	a3,0
ffffffffc02028b2:	6605                	lui	a2,0x1
ffffffffc02028b4:	85d2                	mv	a1,s4
ffffffffc02028b6:	c7bff0ef          	jal	ra,ffffffffc0202530 <page_insert>
ffffffffc02028ba:	72051963          	bnez	a0,ffffffffc0202fec <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02028be:	000a2703          	lw	a4,0(s4)
ffffffffc02028c2:	4789                	li	a5,2
ffffffffc02028c4:	70f71463          	bne	a4,a5,ffffffffc0202fcc <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02028c8:	000c2783          	lw	a5,0(s8)
ffffffffc02028cc:	6e079063          	bnez	a5,ffffffffc0202fac <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02028d0:	00093503          	ld	a0,0(s2)
ffffffffc02028d4:	4601                	li	a2,0
ffffffffc02028d6:	6585                	lui	a1,0x1
ffffffffc02028d8:	d68ff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
ffffffffc02028dc:	6a050863          	beqz	a0,ffffffffc0202f8c <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc02028e0:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc02028e2:	00177793          	andi	a5,a4,1
ffffffffc02028e6:	4a078563          	beqz	a5,ffffffffc0202d90 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc02028ea:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02028ec:	00271793          	slli	a5,a4,0x2
ffffffffc02028f0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02028f2:	48d7fd63          	bgeu	a5,a3,ffffffffc0202d8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02028f6:	000bb683          	ld	a3,0(s7)
ffffffffc02028fa:	fff80ab7          	lui	s5,0xfff80
ffffffffc02028fe:	97d6                	add	a5,a5,s5
ffffffffc0202900:	079a                	slli	a5,a5,0x6
ffffffffc0202902:	97b6                	add	a5,a5,a3
ffffffffc0202904:	66fa1463          	bne	s4,a5,ffffffffc0202f6c <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202908:	8b41                	andi	a4,a4,16
ffffffffc020290a:	64071163          	bnez	a4,ffffffffc0202f4c <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc020290e:	00093503          	ld	a0,0(s2)
ffffffffc0202912:	4581                	li	a1,0
ffffffffc0202914:	b81ff0ef          	jal	ra,ffffffffc0202494 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202918:	000a2c83          	lw	s9,0(s4)
ffffffffc020291c:	4785                	li	a5,1
ffffffffc020291e:	60fc9763          	bne	s9,a5,ffffffffc0202f2c <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202922:	000c2783          	lw	a5,0(s8)
ffffffffc0202926:	5e079363          	bnez	a5,ffffffffc0202f0c <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020292a:	00093503          	ld	a0,0(s2)
ffffffffc020292e:	6585                	lui	a1,0x1
ffffffffc0202930:	b65ff0ef          	jal	ra,ffffffffc0202494 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202934:	000a2783          	lw	a5,0(s4)
ffffffffc0202938:	52079a63          	bnez	a5,ffffffffc0202e6c <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc020293c:	000c2783          	lw	a5,0(s8)
ffffffffc0202940:	50079663          	bnez	a5,ffffffffc0202e4c <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202944:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202948:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020294a:	000a3683          	ld	a3,0(s4)
ffffffffc020294e:	068a                	slli	a3,a3,0x2
ffffffffc0202950:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202952:	42b6fd63          	bgeu	a3,a1,ffffffffc0202d8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202956:	000bb503          	ld	a0,0(s7)
ffffffffc020295a:	96d6                	add	a3,a3,s5
ffffffffc020295c:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc020295e:	00d507b3          	add	a5,a0,a3
ffffffffc0202962:	439c                	lw	a5,0(a5)
ffffffffc0202964:	4d979463          	bne	a5,s9,ffffffffc0202e2c <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202968:	8699                	srai	a3,a3,0x6
ffffffffc020296a:	00080637          	lui	a2,0x80
ffffffffc020296e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202970:	00c69713          	slli	a4,a3,0xc
ffffffffc0202974:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202976:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202978:	48b77e63          	bgeu	a4,a1,ffffffffc0202e14 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc020297c:	0009b703          	ld	a4,0(s3)
ffffffffc0202980:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202982:	629c                	ld	a5,0(a3)
ffffffffc0202984:	078a                	slli	a5,a5,0x2
ffffffffc0202986:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202988:	40b7f263          	bgeu	a5,a1,ffffffffc0202d8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020298c:	8f91                	sub	a5,a5,a2
ffffffffc020298e:	079a                	slli	a5,a5,0x6
ffffffffc0202990:	953e                	add	a0,a0,a5
ffffffffc0202992:	100027f3          	csrr	a5,sstatus
ffffffffc0202996:	8b89                	andi	a5,a5,2
ffffffffc0202998:	30079963          	bnez	a5,ffffffffc0202caa <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc020299c:	000b3783          	ld	a5,0(s6)
ffffffffc02029a0:	4585                	li	a1,1
ffffffffc02029a2:	739c                	ld	a5,32(a5)
ffffffffc02029a4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02029a6:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02029aa:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02029ac:	078a                	slli	a5,a5,0x2
ffffffffc02029ae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029b0:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202d8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02029b4:	000bb503          	ld	a0,0(s7)
ffffffffc02029b8:	fff80737          	lui	a4,0xfff80
ffffffffc02029bc:	97ba                	add	a5,a5,a4
ffffffffc02029be:	079a                	slli	a5,a5,0x6
ffffffffc02029c0:	953e                	add	a0,a0,a5
ffffffffc02029c2:	100027f3          	csrr	a5,sstatus
ffffffffc02029c6:	8b89                	andi	a5,a5,2
ffffffffc02029c8:	2c079563          	bnez	a5,ffffffffc0202c92 <pmm_init+0x66c>
ffffffffc02029cc:	000b3783          	ld	a5,0(s6)
ffffffffc02029d0:	4585                	li	a1,1
ffffffffc02029d2:	739c                	ld	a5,32(a5)
ffffffffc02029d4:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02029d6:	00093783          	ld	a5,0(s2)
ffffffffc02029da:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd383f0>
    asm volatile("sfence.vma");
ffffffffc02029de:	12000073          	sfence.vma
ffffffffc02029e2:	100027f3          	csrr	a5,sstatus
ffffffffc02029e6:	8b89                	andi	a5,a5,2
ffffffffc02029e8:	28079b63          	bnez	a5,ffffffffc0202c7e <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc02029ec:	000b3783          	ld	a5,0(s6)
ffffffffc02029f0:	779c                	ld	a5,40(a5)
ffffffffc02029f2:	9782                	jalr	a5
ffffffffc02029f4:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02029f6:	4b441b63          	bne	s0,s4,ffffffffc0202eac <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02029fa:	00004517          	auipc	a0,0x4
ffffffffc02029fe:	59650513          	addi	a0,a0,1430 # ffffffffc0206f90 <default_pmm_manager+0x560>
ffffffffc0202a02:	f96fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0202a06:	100027f3          	csrr	a5,sstatus
ffffffffc0202a0a:	8b89                	andi	a5,a5,2
ffffffffc0202a0c:	24079f63          	bnez	a5,ffffffffc0202c6a <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a10:	000b3783          	ld	a5,0(s6)
ffffffffc0202a14:	779c                	ld	a5,40(a5)
ffffffffc0202a16:	9782                	jalr	a5
ffffffffc0202a18:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a1a:	6098                	ld	a4,0(s1)
ffffffffc0202a1c:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202a20:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a22:	00c71793          	slli	a5,a4,0xc
ffffffffc0202a26:	6a05                	lui	s4,0x1
ffffffffc0202a28:	02f47c63          	bgeu	s0,a5,ffffffffc0202a60 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202a2c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202a30:	00093503          	ld	a0,0(s2)
ffffffffc0202a34:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202d32 <pmm_init+0x70c>
ffffffffc0202a38:	0009b583          	ld	a1,0(s3)
ffffffffc0202a3c:	4601                	li	a2,0
ffffffffc0202a3e:	95a2                	add	a1,a1,s0
ffffffffc0202a40:	c00ff0ef          	jal	ra,ffffffffc0201e40 <get_pte>
ffffffffc0202a44:	32050463          	beqz	a0,ffffffffc0202d6c <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202a48:	611c                	ld	a5,0(a0)
ffffffffc0202a4a:	078a                	slli	a5,a5,0x2
ffffffffc0202a4c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202a50:	2e879e63          	bne	a5,s0,ffffffffc0202d4c <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a54:	6098                	ld	a4,0(s1)
ffffffffc0202a56:	9452                	add	s0,s0,s4
ffffffffc0202a58:	00c71793          	slli	a5,a4,0xc
ffffffffc0202a5c:	fcf468e3          	bltu	s0,a5,ffffffffc0202a2c <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202a60:	00093783          	ld	a5,0(s2)
ffffffffc0202a64:	639c                	ld	a5,0(a5)
ffffffffc0202a66:	42079363          	bnez	a5,ffffffffc0202e8c <pmm_init+0x866>
ffffffffc0202a6a:	100027f3          	csrr	a5,sstatus
ffffffffc0202a6e:	8b89                	andi	a5,a5,2
ffffffffc0202a70:	24079963          	bnez	a5,ffffffffc0202cc2 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a74:	000b3783          	ld	a5,0(s6)
ffffffffc0202a78:	4505                	li	a0,1
ffffffffc0202a7a:	6f9c                	ld	a5,24(a5)
ffffffffc0202a7c:	9782                	jalr	a5
ffffffffc0202a7e:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202a80:	00093503          	ld	a0,0(s2)
ffffffffc0202a84:	4699                	li	a3,6
ffffffffc0202a86:	10000613          	li	a2,256
ffffffffc0202a8a:	85d2                	mv	a1,s4
ffffffffc0202a8c:	aa5ff0ef          	jal	ra,ffffffffc0202530 <page_insert>
ffffffffc0202a90:	44051e63          	bnez	a0,ffffffffc0202eec <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202a94:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f40>
ffffffffc0202a98:	4785                	li	a5,1
ffffffffc0202a9a:	42f71963          	bne	a4,a5,ffffffffc0202ecc <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202a9e:	00093503          	ld	a0,0(s2)
ffffffffc0202aa2:	6405                	lui	s0,0x1
ffffffffc0202aa4:	4699                	li	a3,6
ffffffffc0202aa6:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8e40>
ffffffffc0202aaa:	85d2                	mv	a1,s4
ffffffffc0202aac:	a85ff0ef          	jal	ra,ffffffffc0202530 <page_insert>
ffffffffc0202ab0:	72051363          	bnez	a0,ffffffffc02031d6 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202ab4:	000a2703          	lw	a4,0(s4)
ffffffffc0202ab8:	4789                	li	a5,2
ffffffffc0202aba:	6ef71e63          	bne	a4,a5,ffffffffc02031b6 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202abe:	00004597          	auipc	a1,0x4
ffffffffc0202ac2:	61a58593          	addi	a1,a1,1562 # ffffffffc02070d8 <default_pmm_manager+0x6a8>
ffffffffc0202ac6:	10000513          	li	a0,256
ffffffffc0202aca:	09e030ef          	jal	ra,ffffffffc0205b68 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202ace:	10040593          	addi	a1,s0,256
ffffffffc0202ad2:	10000513          	li	a0,256
ffffffffc0202ad6:	0a4030ef          	jal	ra,ffffffffc0205b7a <strcmp>
ffffffffc0202ada:	6a051e63          	bnez	a0,ffffffffc0203196 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202ade:	000bb683          	ld	a3,0(s7)
ffffffffc0202ae2:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202ae6:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202ae8:	40da06b3          	sub	a3,s4,a3
ffffffffc0202aec:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202aee:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202af0:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202af2:	8031                	srli	s0,s0,0xc
ffffffffc0202af4:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202af8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202afa:	30f77d63          	bgeu	a4,a5,ffffffffc0202e14 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202afe:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202b02:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202b06:	96be                	add	a3,a3,a5
ffffffffc0202b08:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202b0c:	026030ef          	jal	ra,ffffffffc0205b32 <strlen>
ffffffffc0202b10:	66051363          	bnez	a0,ffffffffc0203176 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202b14:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202b18:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b1a:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd383f0>
ffffffffc0202b1e:	068a                	slli	a3,a3,0x2
ffffffffc0202b20:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b22:	26f6f563          	bgeu	a3,a5,ffffffffc0202d8c <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202b26:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b28:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b2a:	2ef47563          	bgeu	s0,a5,ffffffffc0202e14 <pmm_init+0x7ee>
ffffffffc0202b2e:	0009b403          	ld	s0,0(s3)
ffffffffc0202b32:	9436                	add	s0,s0,a3
ffffffffc0202b34:	100027f3          	csrr	a5,sstatus
ffffffffc0202b38:	8b89                	andi	a5,a5,2
ffffffffc0202b3a:	1e079163          	bnez	a5,ffffffffc0202d1c <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202b3e:	000b3783          	ld	a5,0(s6)
ffffffffc0202b42:	4585                	li	a1,1
ffffffffc0202b44:	8552                	mv	a0,s4
ffffffffc0202b46:	739c                	ld	a5,32(a5)
ffffffffc0202b48:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b4a:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202b4c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b4e:	078a                	slli	a5,a5,0x2
ffffffffc0202b50:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b52:	22e7fd63          	bgeu	a5,a4,ffffffffc0202d8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b56:	000bb503          	ld	a0,0(s7)
ffffffffc0202b5a:	fff80737          	lui	a4,0xfff80
ffffffffc0202b5e:	97ba                	add	a5,a5,a4
ffffffffc0202b60:	079a                	slli	a5,a5,0x6
ffffffffc0202b62:	953e                	add	a0,a0,a5
ffffffffc0202b64:	100027f3          	csrr	a5,sstatus
ffffffffc0202b68:	8b89                	andi	a5,a5,2
ffffffffc0202b6a:	18079d63          	bnez	a5,ffffffffc0202d04 <pmm_init+0x6de>
ffffffffc0202b6e:	000b3783          	ld	a5,0(s6)
ffffffffc0202b72:	4585                	li	a1,1
ffffffffc0202b74:	739c                	ld	a5,32(a5)
ffffffffc0202b76:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b78:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202b7c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b7e:	078a                	slli	a5,a5,0x2
ffffffffc0202b80:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b82:	20e7f563          	bgeu	a5,a4,ffffffffc0202d8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b86:	000bb503          	ld	a0,0(s7)
ffffffffc0202b8a:	fff80737          	lui	a4,0xfff80
ffffffffc0202b8e:	97ba                	add	a5,a5,a4
ffffffffc0202b90:	079a                	slli	a5,a5,0x6
ffffffffc0202b92:	953e                	add	a0,a0,a5
ffffffffc0202b94:	100027f3          	csrr	a5,sstatus
ffffffffc0202b98:	8b89                	andi	a5,a5,2
ffffffffc0202b9a:	14079963          	bnez	a5,ffffffffc0202cec <pmm_init+0x6c6>
ffffffffc0202b9e:	000b3783          	ld	a5,0(s6)
ffffffffc0202ba2:	4585                	li	a1,1
ffffffffc0202ba4:	739c                	ld	a5,32(a5)
ffffffffc0202ba6:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202ba8:	00093783          	ld	a5,0(s2)
ffffffffc0202bac:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202bb0:	12000073          	sfence.vma
ffffffffc0202bb4:	100027f3          	csrr	a5,sstatus
ffffffffc0202bb8:	8b89                	andi	a5,a5,2
ffffffffc0202bba:	10079f63          	bnez	a5,ffffffffc0202cd8 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202bbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202bc2:	779c                	ld	a5,40(a5)
ffffffffc0202bc4:	9782                	jalr	a5
ffffffffc0202bc6:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202bc8:	4c8c1e63          	bne	s8,s0,ffffffffc02030a4 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202bcc:	00004517          	auipc	a0,0x4
ffffffffc0202bd0:	58450513          	addi	a0,a0,1412 # ffffffffc0207150 <default_pmm_manager+0x720>
ffffffffc0202bd4:	dc4fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
}
ffffffffc0202bd8:	7406                	ld	s0,96(sp)
ffffffffc0202bda:	70a6                	ld	ra,104(sp)
ffffffffc0202bdc:	64e6                	ld	s1,88(sp)
ffffffffc0202bde:	6946                	ld	s2,80(sp)
ffffffffc0202be0:	69a6                	ld	s3,72(sp)
ffffffffc0202be2:	6a06                	ld	s4,64(sp)
ffffffffc0202be4:	7ae2                	ld	s5,56(sp)
ffffffffc0202be6:	7b42                	ld	s6,48(sp)
ffffffffc0202be8:	7ba2                	ld	s7,40(sp)
ffffffffc0202bea:	7c02                	ld	s8,32(sp)
ffffffffc0202bec:	6ce2                	ld	s9,24(sp)
ffffffffc0202bee:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202bf0:	f97fe06f          	j	ffffffffc0201b86 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202bf4:	c80007b7          	lui	a5,0xc8000
ffffffffc0202bf8:	bc7d                	j	ffffffffc02026b6 <pmm_init+0x90>
        intr_disable();
ffffffffc0202bfa:	db5fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202bfe:	000b3783          	ld	a5,0(s6)
ffffffffc0202c02:	4505                	li	a0,1
ffffffffc0202c04:	6f9c                	ld	a5,24(a5)
ffffffffc0202c06:	9782                	jalr	a5
ffffffffc0202c08:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202c0a:	d9ffd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c0e:	b9a9                	j	ffffffffc0202868 <pmm_init+0x242>
        intr_disable();
ffffffffc0202c10:	d9ffd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202c14:	000b3783          	ld	a5,0(s6)
ffffffffc0202c18:	4505                	li	a0,1
ffffffffc0202c1a:	6f9c                	ld	a5,24(a5)
ffffffffc0202c1c:	9782                	jalr	a5
ffffffffc0202c1e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202c20:	d89fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c24:	b645                	j	ffffffffc02027c4 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202c26:	d89fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c2e:	779c                	ld	a5,40(a5)
ffffffffc0202c30:	9782                	jalr	a5
ffffffffc0202c32:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202c34:	d75fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c38:	b6b9                	j	ffffffffc0202786 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202c3a:	6705                	lui	a4,0x1
ffffffffc0202c3c:	177d                	addi	a4,a4,-1
ffffffffc0202c3e:	96ba                	add	a3,a3,a4
ffffffffc0202c40:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202c42:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202c46:	14a77363          	bgeu	a4,a0,ffffffffc0202d8c <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202c4a:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202c4e:	fff80537          	lui	a0,0xfff80
ffffffffc0202c52:	972a                	add	a4,a4,a0
ffffffffc0202c54:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202c56:	8c1d                	sub	s0,s0,a5
ffffffffc0202c58:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202c5c:	00c45593          	srli	a1,s0,0xc
ffffffffc0202c60:	9532                	add	a0,a0,a2
ffffffffc0202c62:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202c64:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202c68:	b4c1                	j	ffffffffc0202728 <pmm_init+0x102>
        intr_disable();
ffffffffc0202c6a:	d45fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c6e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c72:	779c                	ld	a5,40(a5)
ffffffffc0202c74:	9782                	jalr	a5
ffffffffc0202c76:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202c78:	d31fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c7c:	bb79                	j	ffffffffc0202a1a <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202c7e:	d31fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202c82:	000b3783          	ld	a5,0(s6)
ffffffffc0202c86:	779c                	ld	a5,40(a5)
ffffffffc0202c88:	9782                	jalr	a5
ffffffffc0202c8a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202c8c:	d1dfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c90:	b39d                	j	ffffffffc02029f6 <pmm_init+0x3d0>
ffffffffc0202c92:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202c94:	d1bfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202c98:	000b3783          	ld	a5,0(s6)
ffffffffc0202c9c:	6522                	ld	a0,8(sp)
ffffffffc0202c9e:	4585                	li	a1,1
ffffffffc0202ca0:	739c                	ld	a5,32(a5)
ffffffffc0202ca2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ca4:	d05fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202ca8:	b33d                	j	ffffffffc02029d6 <pmm_init+0x3b0>
ffffffffc0202caa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202cac:	d03fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202cb0:	000b3783          	ld	a5,0(s6)
ffffffffc0202cb4:	6522                	ld	a0,8(sp)
ffffffffc0202cb6:	4585                	li	a1,1
ffffffffc0202cb8:	739c                	ld	a5,32(a5)
ffffffffc0202cba:	9782                	jalr	a5
        intr_enable();
ffffffffc0202cbc:	cedfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202cc0:	b1dd                	j	ffffffffc02029a6 <pmm_init+0x380>
        intr_disable();
ffffffffc0202cc2:	cedfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202cc6:	000b3783          	ld	a5,0(s6)
ffffffffc0202cca:	4505                	li	a0,1
ffffffffc0202ccc:	6f9c                	ld	a5,24(a5)
ffffffffc0202cce:	9782                	jalr	a5
ffffffffc0202cd0:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202cd2:	cd7fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202cd6:	b36d                	j	ffffffffc0202a80 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202cd8:	cd7fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cdc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce0:	779c                	ld	a5,40(a5)
ffffffffc0202ce2:	9782                	jalr	a5
ffffffffc0202ce4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202ce6:	cc3fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202cea:	bdf9                	j	ffffffffc0202bc8 <pmm_init+0x5a2>
ffffffffc0202cec:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202cee:	cc1fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202cf2:	000b3783          	ld	a5,0(s6)
ffffffffc0202cf6:	6522                	ld	a0,8(sp)
ffffffffc0202cf8:	4585                	li	a1,1
ffffffffc0202cfa:	739c                	ld	a5,32(a5)
ffffffffc0202cfc:	9782                	jalr	a5
        intr_enable();
ffffffffc0202cfe:	cabfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d02:	b55d                	j	ffffffffc0202ba8 <pmm_init+0x582>
ffffffffc0202d04:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d06:	ca9fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202d0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d0e:	6522                	ld	a0,8(sp)
ffffffffc0202d10:	4585                	li	a1,1
ffffffffc0202d12:	739c                	ld	a5,32(a5)
ffffffffc0202d14:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d16:	c93fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d1a:	bdb9                	j	ffffffffc0202b78 <pmm_init+0x552>
        intr_disable();
ffffffffc0202d1c:	c93fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202d20:	000b3783          	ld	a5,0(s6)
ffffffffc0202d24:	4585                	li	a1,1
ffffffffc0202d26:	8552                	mv	a0,s4
ffffffffc0202d28:	739c                	ld	a5,32(a5)
ffffffffc0202d2a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d2c:	c7dfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d30:	bd29                	j	ffffffffc0202b4a <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d32:	86a2                	mv	a3,s0
ffffffffc0202d34:	00004617          	auipc	a2,0x4
ffffffffc0202d38:	d3460613          	addi	a2,a2,-716 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0202d3c:	25100593          	li	a1,593
ffffffffc0202d40:	00004517          	auipc	a0,0x4
ffffffffc0202d44:	e4050513          	addi	a0,a0,-448 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202d48:	f4afd0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d4c:	00004697          	auipc	a3,0x4
ffffffffc0202d50:	2a468693          	addi	a3,a3,676 # ffffffffc0206ff0 <default_pmm_manager+0x5c0>
ffffffffc0202d54:	00004617          	auipc	a2,0x4
ffffffffc0202d58:	92c60613          	addi	a2,a2,-1748 # ffffffffc0206680 <commands+0x818>
ffffffffc0202d5c:	25200593          	li	a1,594
ffffffffc0202d60:	00004517          	auipc	a0,0x4
ffffffffc0202d64:	e2050513          	addi	a0,a0,-480 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202d68:	f2afd0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d6c:	00004697          	auipc	a3,0x4
ffffffffc0202d70:	24468693          	addi	a3,a3,580 # ffffffffc0206fb0 <default_pmm_manager+0x580>
ffffffffc0202d74:	00004617          	auipc	a2,0x4
ffffffffc0202d78:	90c60613          	addi	a2,a2,-1780 # ffffffffc0206680 <commands+0x818>
ffffffffc0202d7c:	25100593          	li	a1,593
ffffffffc0202d80:	00004517          	auipc	a0,0x4
ffffffffc0202d84:	e0050513          	addi	a0,a0,-512 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202d88:	f0afd0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0202d8c:	fc5fe0ef          	jal	ra,ffffffffc0201d50 <pa2page.part.0>
ffffffffc0202d90:	fddfe0ef          	jal	ra,ffffffffc0201d6c <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202d94:	00004697          	auipc	a3,0x4
ffffffffc0202d98:	01468693          	addi	a3,a3,20 # ffffffffc0206da8 <default_pmm_manager+0x378>
ffffffffc0202d9c:	00004617          	auipc	a2,0x4
ffffffffc0202da0:	8e460613          	addi	a2,a2,-1820 # ffffffffc0206680 <commands+0x818>
ffffffffc0202da4:	22100593          	li	a1,545
ffffffffc0202da8:	00004517          	auipc	a0,0x4
ffffffffc0202dac:	dd850513          	addi	a0,a0,-552 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202db0:	ee2fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202db4:	00004697          	auipc	a3,0x4
ffffffffc0202db8:	f3468693          	addi	a3,a3,-204 # ffffffffc0206ce8 <default_pmm_manager+0x2b8>
ffffffffc0202dbc:	00004617          	auipc	a2,0x4
ffffffffc0202dc0:	8c460613          	addi	a2,a2,-1852 # ffffffffc0206680 <commands+0x818>
ffffffffc0202dc4:	21400593          	li	a1,532
ffffffffc0202dc8:	00004517          	auipc	a0,0x4
ffffffffc0202dcc:	db850513          	addi	a0,a0,-584 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202dd0:	ec2fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202dd4:	00004697          	auipc	a3,0x4
ffffffffc0202dd8:	ed468693          	addi	a3,a3,-300 # ffffffffc0206ca8 <default_pmm_manager+0x278>
ffffffffc0202ddc:	00004617          	auipc	a2,0x4
ffffffffc0202de0:	8a460613          	addi	a2,a2,-1884 # ffffffffc0206680 <commands+0x818>
ffffffffc0202de4:	21300593          	li	a1,531
ffffffffc0202de8:	00004517          	auipc	a0,0x4
ffffffffc0202dec:	d9850513          	addi	a0,a0,-616 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202df0:	ea2fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202df4:	00004697          	auipc	a3,0x4
ffffffffc0202df8:	e9468693          	addi	a3,a3,-364 # ffffffffc0206c88 <default_pmm_manager+0x258>
ffffffffc0202dfc:	00004617          	auipc	a2,0x4
ffffffffc0202e00:	88460613          	addi	a2,a2,-1916 # ffffffffc0206680 <commands+0x818>
ffffffffc0202e04:	21200593          	li	a1,530
ffffffffc0202e08:	00004517          	auipc	a0,0x4
ffffffffc0202e0c:	d7850513          	addi	a0,a0,-648 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202e10:	e82fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202e14:	00004617          	auipc	a2,0x4
ffffffffc0202e18:	c5460613          	addi	a2,a2,-940 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0202e1c:	07100593          	li	a1,113
ffffffffc0202e20:	00004517          	auipc	a0,0x4
ffffffffc0202e24:	c7050513          	addi	a0,a0,-912 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc0202e28:	e6afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202e2c:	00004697          	auipc	a3,0x4
ffffffffc0202e30:	10c68693          	addi	a3,a3,268 # ffffffffc0206f38 <default_pmm_manager+0x508>
ffffffffc0202e34:	00004617          	auipc	a2,0x4
ffffffffc0202e38:	84c60613          	addi	a2,a2,-1972 # ffffffffc0206680 <commands+0x818>
ffffffffc0202e3c:	23a00593          	li	a1,570
ffffffffc0202e40:	00004517          	auipc	a0,0x4
ffffffffc0202e44:	d4050513          	addi	a0,a0,-704 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202e48:	e4afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202e4c:	00004697          	auipc	a3,0x4
ffffffffc0202e50:	0a468693          	addi	a3,a3,164 # ffffffffc0206ef0 <default_pmm_manager+0x4c0>
ffffffffc0202e54:	00004617          	auipc	a2,0x4
ffffffffc0202e58:	82c60613          	addi	a2,a2,-2004 # ffffffffc0206680 <commands+0x818>
ffffffffc0202e5c:	23800593          	li	a1,568
ffffffffc0202e60:	00004517          	auipc	a0,0x4
ffffffffc0202e64:	d2050513          	addi	a0,a0,-736 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202e68:	e2afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202e6c:	00004697          	auipc	a3,0x4
ffffffffc0202e70:	0b468693          	addi	a3,a3,180 # ffffffffc0206f20 <default_pmm_manager+0x4f0>
ffffffffc0202e74:	00004617          	auipc	a2,0x4
ffffffffc0202e78:	80c60613          	addi	a2,a2,-2036 # ffffffffc0206680 <commands+0x818>
ffffffffc0202e7c:	23700593          	li	a1,567
ffffffffc0202e80:	00004517          	auipc	a0,0x4
ffffffffc0202e84:	d0050513          	addi	a0,a0,-768 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202e88:	e0afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202e8c:	00004697          	auipc	a3,0x4
ffffffffc0202e90:	17c68693          	addi	a3,a3,380 # ffffffffc0207008 <default_pmm_manager+0x5d8>
ffffffffc0202e94:	00003617          	auipc	a2,0x3
ffffffffc0202e98:	7ec60613          	addi	a2,a2,2028 # ffffffffc0206680 <commands+0x818>
ffffffffc0202e9c:	25500593          	li	a1,597
ffffffffc0202ea0:	00004517          	auipc	a0,0x4
ffffffffc0202ea4:	ce050513          	addi	a0,a0,-800 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202ea8:	deafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202eac:	00004697          	auipc	a3,0x4
ffffffffc0202eb0:	0bc68693          	addi	a3,a3,188 # ffffffffc0206f68 <default_pmm_manager+0x538>
ffffffffc0202eb4:	00003617          	auipc	a2,0x3
ffffffffc0202eb8:	7cc60613          	addi	a2,a2,1996 # ffffffffc0206680 <commands+0x818>
ffffffffc0202ebc:	24200593          	li	a1,578
ffffffffc0202ec0:	00004517          	auipc	a0,0x4
ffffffffc0202ec4:	cc050513          	addi	a0,a0,-832 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202ec8:	dcafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202ecc:	00004697          	auipc	a3,0x4
ffffffffc0202ed0:	19468693          	addi	a3,a3,404 # ffffffffc0207060 <default_pmm_manager+0x630>
ffffffffc0202ed4:	00003617          	auipc	a2,0x3
ffffffffc0202ed8:	7ac60613          	addi	a2,a2,1964 # ffffffffc0206680 <commands+0x818>
ffffffffc0202edc:	25a00593          	li	a1,602
ffffffffc0202ee0:	00004517          	auipc	a0,0x4
ffffffffc0202ee4:	ca050513          	addi	a0,a0,-864 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202ee8:	daafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202eec:	00004697          	auipc	a3,0x4
ffffffffc0202ef0:	13468693          	addi	a3,a3,308 # ffffffffc0207020 <default_pmm_manager+0x5f0>
ffffffffc0202ef4:	00003617          	auipc	a2,0x3
ffffffffc0202ef8:	78c60613          	addi	a2,a2,1932 # ffffffffc0206680 <commands+0x818>
ffffffffc0202efc:	25900593          	li	a1,601
ffffffffc0202f00:	00004517          	auipc	a0,0x4
ffffffffc0202f04:	c8050513          	addi	a0,a0,-896 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202f08:	d8afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f0c:	00004697          	auipc	a3,0x4
ffffffffc0202f10:	fe468693          	addi	a3,a3,-28 # ffffffffc0206ef0 <default_pmm_manager+0x4c0>
ffffffffc0202f14:	00003617          	auipc	a2,0x3
ffffffffc0202f18:	76c60613          	addi	a2,a2,1900 # ffffffffc0206680 <commands+0x818>
ffffffffc0202f1c:	23400593          	li	a1,564
ffffffffc0202f20:	00004517          	auipc	a0,0x4
ffffffffc0202f24:	c6050513          	addi	a0,a0,-928 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202f28:	d6afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202f2c:	00004697          	auipc	a3,0x4
ffffffffc0202f30:	e6468693          	addi	a3,a3,-412 # ffffffffc0206d90 <default_pmm_manager+0x360>
ffffffffc0202f34:	00003617          	auipc	a2,0x3
ffffffffc0202f38:	74c60613          	addi	a2,a2,1868 # ffffffffc0206680 <commands+0x818>
ffffffffc0202f3c:	23300593          	li	a1,563
ffffffffc0202f40:	00004517          	auipc	a0,0x4
ffffffffc0202f44:	c4050513          	addi	a0,a0,-960 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202f48:	d4afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202f4c:	00004697          	auipc	a3,0x4
ffffffffc0202f50:	fbc68693          	addi	a3,a3,-68 # ffffffffc0206f08 <default_pmm_manager+0x4d8>
ffffffffc0202f54:	00003617          	auipc	a2,0x3
ffffffffc0202f58:	72c60613          	addi	a2,a2,1836 # ffffffffc0206680 <commands+0x818>
ffffffffc0202f5c:	23000593          	li	a1,560
ffffffffc0202f60:	00004517          	auipc	a0,0x4
ffffffffc0202f64:	c2050513          	addi	a0,a0,-992 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202f68:	d2afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202f6c:	00004697          	auipc	a3,0x4
ffffffffc0202f70:	e0c68693          	addi	a3,a3,-500 # ffffffffc0206d78 <default_pmm_manager+0x348>
ffffffffc0202f74:	00003617          	auipc	a2,0x3
ffffffffc0202f78:	70c60613          	addi	a2,a2,1804 # ffffffffc0206680 <commands+0x818>
ffffffffc0202f7c:	22f00593          	li	a1,559
ffffffffc0202f80:	00004517          	auipc	a0,0x4
ffffffffc0202f84:	c0050513          	addi	a0,a0,-1024 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202f88:	d0afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202f8c:	00004697          	auipc	a3,0x4
ffffffffc0202f90:	e8c68693          	addi	a3,a3,-372 # ffffffffc0206e18 <default_pmm_manager+0x3e8>
ffffffffc0202f94:	00003617          	auipc	a2,0x3
ffffffffc0202f98:	6ec60613          	addi	a2,a2,1772 # ffffffffc0206680 <commands+0x818>
ffffffffc0202f9c:	22e00593          	li	a1,558
ffffffffc0202fa0:	00004517          	auipc	a0,0x4
ffffffffc0202fa4:	be050513          	addi	a0,a0,-1056 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202fa8:	ceafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202fac:	00004697          	auipc	a3,0x4
ffffffffc0202fb0:	f4468693          	addi	a3,a3,-188 # ffffffffc0206ef0 <default_pmm_manager+0x4c0>
ffffffffc0202fb4:	00003617          	auipc	a2,0x3
ffffffffc0202fb8:	6cc60613          	addi	a2,a2,1740 # ffffffffc0206680 <commands+0x818>
ffffffffc0202fbc:	22d00593          	li	a1,557
ffffffffc0202fc0:	00004517          	auipc	a0,0x4
ffffffffc0202fc4:	bc050513          	addi	a0,a0,-1088 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202fc8:	ccafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202fcc:	00004697          	auipc	a3,0x4
ffffffffc0202fd0:	f0c68693          	addi	a3,a3,-244 # ffffffffc0206ed8 <default_pmm_manager+0x4a8>
ffffffffc0202fd4:	00003617          	auipc	a2,0x3
ffffffffc0202fd8:	6ac60613          	addi	a2,a2,1708 # ffffffffc0206680 <commands+0x818>
ffffffffc0202fdc:	22c00593          	li	a1,556
ffffffffc0202fe0:	00004517          	auipc	a0,0x4
ffffffffc0202fe4:	ba050513          	addi	a0,a0,-1120 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0202fe8:	caafd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202fec:	00004697          	auipc	a3,0x4
ffffffffc0202ff0:	ebc68693          	addi	a3,a3,-324 # ffffffffc0206ea8 <default_pmm_manager+0x478>
ffffffffc0202ff4:	00003617          	auipc	a2,0x3
ffffffffc0202ff8:	68c60613          	addi	a2,a2,1676 # ffffffffc0206680 <commands+0x818>
ffffffffc0202ffc:	22b00593          	li	a1,555
ffffffffc0203000:	00004517          	auipc	a0,0x4
ffffffffc0203004:	b8050513          	addi	a0,a0,-1152 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203008:	c8afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020300c:	00004697          	auipc	a3,0x4
ffffffffc0203010:	e8468693          	addi	a3,a3,-380 # ffffffffc0206e90 <default_pmm_manager+0x460>
ffffffffc0203014:	00003617          	auipc	a2,0x3
ffffffffc0203018:	66c60613          	addi	a2,a2,1644 # ffffffffc0206680 <commands+0x818>
ffffffffc020301c:	22900593          	li	a1,553
ffffffffc0203020:	00004517          	auipc	a0,0x4
ffffffffc0203024:	b6050513          	addi	a0,a0,-1184 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203028:	c6afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020302c:	00004697          	auipc	a3,0x4
ffffffffc0203030:	e4468693          	addi	a3,a3,-444 # ffffffffc0206e70 <default_pmm_manager+0x440>
ffffffffc0203034:	00003617          	auipc	a2,0x3
ffffffffc0203038:	64c60613          	addi	a2,a2,1612 # ffffffffc0206680 <commands+0x818>
ffffffffc020303c:	22800593          	li	a1,552
ffffffffc0203040:	00004517          	auipc	a0,0x4
ffffffffc0203044:	b4050513          	addi	a0,a0,-1216 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203048:	c4afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(*ptep & PTE_W);
ffffffffc020304c:	00004697          	auipc	a3,0x4
ffffffffc0203050:	e1468693          	addi	a3,a3,-492 # ffffffffc0206e60 <default_pmm_manager+0x430>
ffffffffc0203054:	00003617          	auipc	a2,0x3
ffffffffc0203058:	62c60613          	addi	a2,a2,1580 # ffffffffc0206680 <commands+0x818>
ffffffffc020305c:	22700593          	li	a1,551
ffffffffc0203060:	00004517          	auipc	a0,0x4
ffffffffc0203064:	b2050513          	addi	a0,a0,-1248 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203068:	c2afd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(*ptep & PTE_U);
ffffffffc020306c:	00004697          	auipc	a3,0x4
ffffffffc0203070:	de468693          	addi	a3,a3,-540 # ffffffffc0206e50 <default_pmm_manager+0x420>
ffffffffc0203074:	00003617          	auipc	a2,0x3
ffffffffc0203078:	60c60613          	addi	a2,a2,1548 # ffffffffc0206680 <commands+0x818>
ffffffffc020307c:	22600593          	li	a1,550
ffffffffc0203080:	00004517          	auipc	a0,0x4
ffffffffc0203084:	b0050513          	addi	a0,a0,-1280 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203088:	c0afd0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("DTB memory info not available");
ffffffffc020308c:	00004617          	auipc	a2,0x4
ffffffffc0203090:	b6460613          	addi	a2,a2,-1180 # ffffffffc0206bf0 <default_pmm_manager+0x1c0>
ffffffffc0203094:	06500593          	li	a1,101
ffffffffc0203098:	00004517          	auipc	a0,0x4
ffffffffc020309c:	ae850513          	addi	a0,a0,-1304 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02030a0:	bf2fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02030a4:	00004697          	auipc	a3,0x4
ffffffffc02030a8:	ec468693          	addi	a3,a3,-316 # ffffffffc0206f68 <default_pmm_manager+0x538>
ffffffffc02030ac:	00003617          	auipc	a2,0x3
ffffffffc02030b0:	5d460613          	addi	a2,a2,1492 # ffffffffc0206680 <commands+0x818>
ffffffffc02030b4:	26c00593          	li	a1,620
ffffffffc02030b8:	00004517          	auipc	a0,0x4
ffffffffc02030bc:	ac850513          	addi	a0,a0,-1336 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02030c0:	bd2fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030c4:	00004697          	auipc	a3,0x4
ffffffffc02030c8:	d5468693          	addi	a3,a3,-684 # ffffffffc0206e18 <default_pmm_manager+0x3e8>
ffffffffc02030cc:	00003617          	auipc	a2,0x3
ffffffffc02030d0:	5b460613          	addi	a2,a2,1460 # ffffffffc0206680 <commands+0x818>
ffffffffc02030d4:	22500593          	li	a1,549
ffffffffc02030d8:	00004517          	auipc	a0,0x4
ffffffffc02030dc:	aa850513          	addi	a0,a0,-1368 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02030e0:	bb2fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02030e4:	00004697          	auipc	a3,0x4
ffffffffc02030e8:	cf468693          	addi	a3,a3,-780 # ffffffffc0206dd8 <default_pmm_manager+0x3a8>
ffffffffc02030ec:	00003617          	auipc	a2,0x3
ffffffffc02030f0:	59460613          	addi	a2,a2,1428 # ffffffffc0206680 <commands+0x818>
ffffffffc02030f4:	22400593          	li	a1,548
ffffffffc02030f8:	00004517          	auipc	a0,0x4
ffffffffc02030fc:	a8850513          	addi	a0,a0,-1400 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203100:	b92fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203104:	86d6                	mv	a3,s5
ffffffffc0203106:	00004617          	auipc	a2,0x4
ffffffffc020310a:	96260613          	addi	a2,a2,-1694 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc020310e:	22000593          	li	a1,544
ffffffffc0203112:	00004517          	auipc	a0,0x4
ffffffffc0203116:	a6e50513          	addi	a0,a0,-1426 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc020311a:	b78fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020311e:	00004617          	auipc	a2,0x4
ffffffffc0203122:	94a60613          	addi	a2,a2,-1718 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0203126:	21f00593          	li	a1,543
ffffffffc020312a:	00004517          	auipc	a0,0x4
ffffffffc020312e:	a5650513          	addi	a0,a0,-1450 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203132:	b60fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203136:	00004697          	auipc	a3,0x4
ffffffffc020313a:	c5a68693          	addi	a3,a3,-934 # ffffffffc0206d90 <default_pmm_manager+0x360>
ffffffffc020313e:	00003617          	auipc	a2,0x3
ffffffffc0203142:	54260613          	addi	a2,a2,1346 # ffffffffc0206680 <commands+0x818>
ffffffffc0203146:	21d00593          	li	a1,541
ffffffffc020314a:	00004517          	auipc	a0,0x4
ffffffffc020314e:	a3650513          	addi	a0,a0,-1482 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203152:	b40fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203156:	00004697          	auipc	a3,0x4
ffffffffc020315a:	c2268693          	addi	a3,a3,-990 # ffffffffc0206d78 <default_pmm_manager+0x348>
ffffffffc020315e:	00003617          	auipc	a2,0x3
ffffffffc0203162:	52260613          	addi	a2,a2,1314 # ffffffffc0206680 <commands+0x818>
ffffffffc0203166:	21c00593          	li	a1,540
ffffffffc020316a:	00004517          	auipc	a0,0x4
ffffffffc020316e:	a1650513          	addi	a0,a0,-1514 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203172:	b20fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203176:	00004697          	auipc	a3,0x4
ffffffffc020317a:	fb268693          	addi	a3,a3,-78 # ffffffffc0207128 <default_pmm_manager+0x6f8>
ffffffffc020317e:	00003617          	auipc	a2,0x3
ffffffffc0203182:	50260613          	addi	a2,a2,1282 # ffffffffc0206680 <commands+0x818>
ffffffffc0203186:	26300593          	li	a1,611
ffffffffc020318a:	00004517          	auipc	a0,0x4
ffffffffc020318e:	9f650513          	addi	a0,a0,-1546 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203192:	b00fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203196:	00004697          	auipc	a3,0x4
ffffffffc020319a:	f5a68693          	addi	a3,a3,-166 # ffffffffc02070f0 <default_pmm_manager+0x6c0>
ffffffffc020319e:	00003617          	auipc	a2,0x3
ffffffffc02031a2:	4e260613          	addi	a2,a2,1250 # ffffffffc0206680 <commands+0x818>
ffffffffc02031a6:	26000593          	li	a1,608
ffffffffc02031aa:	00004517          	auipc	a0,0x4
ffffffffc02031ae:	9d650513          	addi	a0,a0,-1578 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02031b2:	ae0fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p) == 2);
ffffffffc02031b6:	00004697          	auipc	a3,0x4
ffffffffc02031ba:	f0a68693          	addi	a3,a3,-246 # ffffffffc02070c0 <default_pmm_manager+0x690>
ffffffffc02031be:	00003617          	auipc	a2,0x3
ffffffffc02031c2:	4c260613          	addi	a2,a2,1218 # ffffffffc0206680 <commands+0x818>
ffffffffc02031c6:	25c00593          	li	a1,604
ffffffffc02031ca:	00004517          	auipc	a0,0x4
ffffffffc02031ce:	9b650513          	addi	a0,a0,-1610 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02031d2:	ac0fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02031d6:	00004697          	auipc	a3,0x4
ffffffffc02031da:	ea268693          	addi	a3,a3,-350 # ffffffffc0207078 <default_pmm_manager+0x648>
ffffffffc02031de:	00003617          	auipc	a2,0x3
ffffffffc02031e2:	4a260613          	addi	a2,a2,1186 # ffffffffc0206680 <commands+0x818>
ffffffffc02031e6:	25b00593          	li	a1,603
ffffffffc02031ea:	00004517          	auipc	a0,0x4
ffffffffc02031ee:	99650513          	addi	a0,a0,-1642 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02031f2:	aa0fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02031f6:	00004617          	auipc	a2,0x4
ffffffffc02031fa:	91a60613          	addi	a2,a2,-1766 # ffffffffc0206b10 <default_pmm_manager+0xe0>
ffffffffc02031fe:	0c900593          	li	a1,201
ffffffffc0203202:	00004517          	auipc	a0,0x4
ffffffffc0203206:	97e50513          	addi	a0,a0,-1666 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc020320a:	a88fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020320e:	00004617          	auipc	a2,0x4
ffffffffc0203212:	90260613          	addi	a2,a2,-1790 # ffffffffc0206b10 <default_pmm_manager+0xe0>
ffffffffc0203216:	08100593          	li	a1,129
ffffffffc020321a:	00004517          	auipc	a0,0x4
ffffffffc020321e:	96650513          	addi	a0,a0,-1690 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203222:	a70fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203226:	00004697          	auipc	a3,0x4
ffffffffc020322a:	b2268693          	addi	a3,a3,-1246 # ffffffffc0206d48 <default_pmm_manager+0x318>
ffffffffc020322e:	00003617          	auipc	a2,0x3
ffffffffc0203232:	45260613          	addi	a2,a2,1106 # ffffffffc0206680 <commands+0x818>
ffffffffc0203236:	21b00593          	li	a1,539
ffffffffc020323a:	00004517          	auipc	a0,0x4
ffffffffc020323e:	94650513          	addi	a0,a0,-1722 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203242:	a50fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203246:	00004697          	auipc	a3,0x4
ffffffffc020324a:	ad268693          	addi	a3,a3,-1326 # ffffffffc0206d18 <default_pmm_manager+0x2e8>
ffffffffc020324e:	00003617          	auipc	a2,0x3
ffffffffc0203252:	43260613          	addi	a2,a2,1074 # ffffffffc0206680 <commands+0x818>
ffffffffc0203256:	21800593          	li	a1,536
ffffffffc020325a:	00004517          	auipc	a0,0x4
ffffffffc020325e:	92650513          	addi	a0,a0,-1754 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203262:	a30fd0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203266 <copy_range>:
{
ffffffffc0203266:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203268:	00d667b3          	or	a5,a2,a3
{
ffffffffc020326c:	f486                	sd	ra,104(sp)
ffffffffc020326e:	f0a2                	sd	s0,96(sp)
ffffffffc0203270:	eca6                	sd	s1,88(sp)
ffffffffc0203272:	e8ca                	sd	s2,80(sp)
ffffffffc0203274:	e4ce                	sd	s3,72(sp)
ffffffffc0203276:	e0d2                	sd	s4,64(sp)
ffffffffc0203278:	fc56                	sd	s5,56(sp)
ffffffffc020327a:	f85a                	sd	s6,48(sp)
ffffffffc020327c:	f45e                	sd	s7,40(sp)
ffffffffc020327e:	f062                	sd	s8,32(sp)
ffffffffc0203280:	ec66                	sd	s9,24(sp)
ffffffffc0203282:	e86a                	sd	s10,16(sp)
ffffffffc0203284:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203286:	17d2                	slli	a5,a5,0x34
ffffffffc0203288:	20079f63          	bnez	a5,ffffffffc02034a6 <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc020328c:	002007b7          	lui	a5,0x200
ffffffffc0203290:	8432                	mv	s0,a2
ffffffffc0203292:	1af66263          	bltu	a2,a5,ffffffffc0203436 <copy_range+0x1d0>
ffffffffc0203296:	8936                	mv	s2,a3
ffffffffc0203298:	18d67f63          	bgeu	a2,a3,ffffffffc0203436 <copy_range+0x1d0>
ffffffffc020329c:	4785                	li	a5,1
ffffffffc020329e:	07fe                	slli	a5,a5,0x1f
ffffffffc02032a0:	18d7eb63          	bltu	a5,a3,ffffffffc0203436 <copy_range+0x1d0>
ffffffffc02032a4:	5b7d                	li	s6,-1
ffffffffc02032a6:	8aaa                	mv	s5,a0
ffffffffc02032a8:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc02032aa:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02032ac:	000c4c17          	auipc	s8,0xc4
ffffffffc02032b0:	914c0c13          	addi	s8,s8,-1772 # ffffffffc02c6bc0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02032b4:	000c4b97          	auipc	s7,0xc4
ffffffffc02032b8:	914b8b93          	addi	s7,s7,-1772 # ffffffffc02c6bc8 <pages>
    return KADDR(page2pa(page));
ffffffffc02032bc:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc02032c0:	000c4c97          	auipc	s9,0xc4
ffffffffc02032c4:	910c8c93          	addi	s9,s9,-1776 # ffffffffc02c6bd0 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02032c8:	4601                	li	a2,0
ffffffffc02032ca:	85a2                	mv	a1,s0
ffffffffc02032cc:	854e                	mv	a0,s3
ffffffffc02032ce:	b73fe0ef          	jal	ra,ffffffffc0201e40 <get_pte>
ffffffffc02032d2:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02032d4:	0e050c63          	beqz	a0,ffffffffc02033cc <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc02032d8:	611c                	ld	a5,0(a0)
ffffffffc02032da:	8b85                	andi	a5,a5,1
ffffffffc02032dc:	e785                	bnez	a5,ffffffffc0203304 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc02032de:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02032e0:	ff2464e3          	bltu	s0,s2,ffffffffc02032c8 <copy_range+0x62>
    return 0;
ffffffffc02032e4:	4501                	li	a0,0
}
ffffffffc02032e6:	70a6                	ld	ra,104(sp)
ffffffffc02032e8:	7406                	ld	s0,96(sp)
ffffffffc02032ea:	64e6                	ld	s1,88(sp)
ffffffffc02032ec:	6946                	ld	s2,80(sp)
ffffffffc02032ee:	69a6                	ld	s3,72(sp)
ffffffffc02032f0:	6a06                	ld	s4,64(sp)
ffffffffc02032f2:	7ae2                	ld	s5,56(sp)
ffffffffc02032f4:	7b42                	ld	s6,48(sp)
ffffffffc02032f6:	7ba2                	ld	s7,40(sp)
ffffffffc02032f8:	7c02                	ld	s8,32(sp)
ffffffffc02032fa:	6ce2                	ld	s9,24(sp)
ffffffffc02032fc:	6d42                	ld	s10,16(sp)
ffffffffc02032fe:	6da2                	ld	s11,8(sp)
ffffffffc0203300:	6165                	addi	sp,sp,112
ffffffffc0203302:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203304:	4605                	li	a2,1
ffffffffc0203306:	85a2                	mv	a1,s0
ffffffffc0203308:	8556                	mv	a0,s5
ffffffffc020330a:	b37fe0ef          	jal	ra,ffffffffc0201e40 <get_pte>
ffffffffc020330e:	c56d                	beqz	a0,ffffffffc02033f8 <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203310:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc0203312:	0017f713          	andi	a4,a5,1
ffffffffc0203316:	01f7f493          	andi	s1,a5,31
ffffffffc020331a:	16070a63          	beqz	a4,ffffffffc020348e <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc020331e:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203322:	078a                	slli	a5,a5,0x2
ffffffffc0203324:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203328:	14d77763          	bgeu	a4,a3,ffffffffc0203476 <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc020332c:	000bb783          	ld	a5,0(s7)
ffffffffc0203330:	fff806b7          	lui	a3,0xfff80
ffffffffc0203334:	9736                	add	a4,a4,a3
ffffffffc0203336:	071a                	slli	a4,a4,0x6
ffffffffc0203338:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020333c:	10002773          	csrr	a4,sstatus
ffffffffc0203340:	8b09                	andi	a4,a4,2
ffffffffc0203342:	e345                	bnez	a4,ffffffffc02033e2 <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203344:	000cb703          	ld	a4,0(s9)
ffffffffc0203348:	4505                	li	a0,1
ffffffffc020334a:	6f18                	ld	a4,24(a4)
ffffffffc020334c:	9702                	jalr	a4
ffffffffc020334e:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0203350:	0c0d8363          	beqz	s11,ffffffffc0203416 <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203354:	100d0163          	beqz	s10,ffffffffc0203456 <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc0203358:	000bb703          	ld	a4,0(s7)
ffffffffc020335c:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc0203360:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203364:	40ed86b3          	sub	a3,s11,a4
ffffffffc0203368:	8699                	srai	a3,a3,0x6
ffffffffc020336a:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc020336c:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203370:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203372:	08c7f663          	bgeu	a5,a2,ffffffffc02033fe <copy_range+0x198>
    return page - pages + nbase;
ffffffffc0203376:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc020337a:	000c4717          	auipc	a4,0xc4
ffffffffc020337e:	85e70713          	addi	a4,a4,-1954 # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0203382:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0203384:	8799                	srai	a5,a5,0x6
ffffffffc0203386:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc0203388:	0167f733          	and	a4,a5,s6
ffffffffc020338c:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203390:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203392:	06c77563          	bgeu	a4,a2,ffffffffc02033fc <copy_range+0x196>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203396:	6605                	lui	a2,0x1
ffffffffc0203398:	953e                	add	a0,a0,a5
ffffffffc020339a:	04d020ef          	jal	ra,ffffffffc0205be6 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc020339e:	86a6                	mv	a3,s1
ffffffffc02033a0:	8622                	mv	a2,s0
ffffffffc02033a2:	85ea                	mv	a1,s10
ffffffffc02033a4:	8556                	mv	a0,s5
ffffffffc02033a6:	98aff0ef          	jal	ra,ffffffffc0202530 <page_insert>
            assert(ret == 0);
ffffffffc02033aa:	d915                	beqz	a0,ffffffffc02032de <copy_range+0x78>
ffffffffc02033ac:	00004697          	auipc	a3,0x4
ffffffffc02033b0:	de468693          	addi	a3,a3,-540 # ffffffffc0207190 <default_pmm_manager+0x760>
ffffffffc02033b4:	00003617          	auipc	a2,0x3
ffffffffc02033b8:	2cc60613          	addi	a2,a2,716 # ffffffffc0206680 <commands+0x818>
ffffffffc02033bc:	1b000593          	li	a1,432
ffffffffc02033c0:	00003517          	auipc	a0,0x3
ffffffffc02033c4:	7c050513          	addi	a0,a0,1984 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02033c8:	8cafd0ef          	jal	ra,ffffffffc0200492 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02033cc:	00200637          	lui	a2,0x200
ffffffffc02033d0:	9432                	add	s0,s0,a2
ffffffffc02033d2:	ffe00637          	lui	a2,0xffe00
ffffffffc02033d6:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc02033d8:	f00406e3          	beqz	s0,ffffffffc02032e4 <copy_range+0x7e>
ffffffffc02033dc:	ef2466e3          	bltu	s0,s2,ffffffffc02032c8 <copy_range+0x62>
ffffffffc02033e0:	b711                	j	ffffffffc02032e4 <copy_range+0x7e>
        intr_disable();
ffffffffc02033e2:	dccfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02033e6:	000cb703          	ld	a4,0(s9)
ffffffffc02033ea:	4505                	li	a0,1
ffffffffc02033ec:	6f18                	ld	a4,24(a4)
ffffffffc02033ee:	9702                	jalr	a4
ffffffffc02033f0:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc02033f2:	db6fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc02033f6:	bfa9                	j	ffffffffc0203350 <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc02033f8:	5571                	li	a0,-4
ffffffffc02033fa:	b5f5                	j	ffffffffc02032e6 <copy_range+0x80>
ffffffffc02033fc:	86be                	mv	a3,a5
ffffffffc02033fe:	00003617          	auipc	a2,0x3
ffffffffc0203402:	66a60613          	addi	a2,a2,1642 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0203406:	07100593          	li	a1,113
ffffffffc020340a:	00003517          	auipc	a0,0x3
ffffffffc020340e:	68650513          	addi	a0,a0,1670 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc0203412:	880fd0ef          	jal	ra,ffffffffc0200492 <__panic>
            assert(page != NULL);
ffffffffc0203416:	00004697          	auipc	a3,0x4
ffffffffc020341a:	d5a68693          	addi	a3,a3,-678 # ffffffffc0207170 <default_pmm_manager+0x740>
ffffffffc020341e:	00003617          	auipc	a2,0x3
ffffffffc0203422:	26260613          	addi	a2,a2,610 # ffffffffc0206680 <commands+0x818>
ffffffffc0203426:	19600593          	li	a1,406
ffffffffc020342a:	00003517          	auipc	a0,0x3
ffffffffc020342e:	75650513          	addi	a0,a0,1878 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203432:	860fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203436:	00003697          	auipc	a3,0x3
ffffffffc020343a:	78a68693          	addi	a3,a3,1930 # ffffffffc0206bc0 <default_pmm_manager+0x190>
ffffffffc020343e:	00003617          	auipc	a2,0x3
ffffffffc0203442:	24260613          	addi	a2,a2,578 # ffffffffc0206680 <commands+0x818>
ffffffffc0203446:	17e00593          	li	a1,382
ffffffffc020344a:	00003517          	auipc	a0,0x3
ffffffffc020344e:	73650513          	addi	a0,a0,1846 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203452:	840fd0ef          	jal	ra,ffffffffc0200492 <__panic>
            assert(npage != NULL);
ffffffffc0203456:	00004697          	auipc	a3,0x4
ffffffffc020345a:	d2a68693          	addi	a3,a3,-726 # ffffffffc0207180 <default_pmm_manager+0x750>
ffffffffc020345e:	00003617          	auipc	a2,0x3
ffffffffc0203462:	22260613          	addi	a2,a2,546 # ffffffffc0206680 <commands+0x818>
ffffffffc0203466:	19700593          	li	a1,407
ffffffffc020346a:	00003517          	auipc	a0,0x3
ffffffffc020346e:	71650513          	addi	a0,a0,1814 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203472:	820fd0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203476:	00003617          	auipc	a2,0x3
ffffffffc020347a:	6c260613          	addi	a2,a2,1730 # ffffffffc0206b38 <default_pmm_manager+0x108>
ffffffffc020347e:	06900593          	li	a1,105
ffffffffc0203482:	00003517          	auipc	a0,0x3
ffffffffc0203486:	60e50513          	addi	a0,a0,1550 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc020348a:	808fd0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc020348e:	00003617          	auipc	a2,0x3
ffffffffc0203492:	6ca60613          	addi	a2,a2,1738 # ffffffffc0206b58 <default_pmm_manager+0x128>
ffffffffc0203496:	07f00593          	li	a1,127
ffffffffc020349a:	00003517          	auipc	a0,0x3
ffffffffc020349e:	5f650513          	addi	a0,a0,1526 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc02034a2:	ff1fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02034a6:	00003697          	auipc	a3,0x3
ffffffffc02034aa:	6ea68693          	addi	a3,a3,1770 # ffffffffc0206b90 <default_pmm_manager+0x160>
ffffffffc02034ae:	00003617          	auipc	a2,0x3
ffffffffc02034b2:	1d260613          	addi	a2,a2,466 # ffffffffc0206680 <commands+0x818>
ffffffffc02034b6:	17d00593          	li	a1,381
ffffffffc02034ba:	00003517          	auipc	a0,0x3
ffffffffc02034be:	6c650513          	addi	a0,a0,1734 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc02034c2:	fd1fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02034c6 <pgdir_alloc_page>:
{
ffffffffc02034c6:	7179                	addi	sp,sp,-48
ffffffffc02034c8:	ec26                	sd	s1,24(sp)
ffffffffc02034ca:	e84a                	sd	s2,16(sp)
ffffffffc02034cc:	e052                	sd	s4,0(sp)
ffffffffc02034ce:	f406                	sd	ra,40(sp)
ffffffffc02034d0:	f022                	sd	s0,32(sp)
ffffffffc02034d2:	e44e                	sd	s3,8(sp)
ffffffffc02034d4:	8a2a                	mv	s4,a0
ffffffffc02034d6:	84ae                	mv	s1,a1
ffffffffc02034d8:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02034da:	100027f3          	csrr	a5,sstatus
ffffffffc02034de:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc02034e0:	000c3997          	auipc	s3,0xc3
ffffffffc02034e4:	6f098993          	addi	s3,s3,1776 # ffffffffc02c6bd0 <pmm_manager>
ffffffffc02034e8:	ef8d                	bnez	a5,ffffffffc0203522 <pgdir_alloc_page+0x5c>
ffffffffc02034ea:	0009b783          	ld	a5,0(s3)
ffffffffc02034ee:	4505                	li	a0,1
ffffffffc02034f0:	6f9c                	ld	a5,24(a5)
ffffffffc02034f2:	9782                	jalr	a5
ffffffffc02034f4:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc02034f6:	cc09                	beqz	s0,ffffffffc0203510 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02034f8:	86ca                	mv	a3,s2
ffffffffc02034fa:	8626                	mv	a2,s1
ffffffffc02034fc:	85a2                	mv	a1,s0
ffffffffc02034fe:	8552                	mv	a0,s4
ffffffffc0203500:	830ff0ef          	jal	ra,ffffffffc0202530 <page_insert>
ffffffffc0203504:	e915                	bnez	a0,ffffffffc0203538 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203506:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203508:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc020350a:	4785                	li	a5,1
ffffffffc020350c:	04f71e63          	bne	a4,a5,ffffffffc0203568 <pgdir_alloc_page+0xa2>
}
ffffffffc0203510:	70a2                	ld	ra,40(sp)
ffffffffc0203512:	8522                	mv	a0,s0
ffffffffc0203514:	7402                	ld	s0,32(sp)
ffffffffc0203516:	64e2                	ld	s1,24(sp)
ffffffffc0203518:	6942                	ld	s2,16(sp)
ffffffffc020351a:	69a2                	ld	s3,8(sp)
ffffffffc020351c:	6a02                	ld	s4,0(sp)
ffffffffc020351e:	6145                	addi	sp,sp,48
ffffffffc0203520:	8082                	ret
        intr_disable();
ffffffffc0203522:	c8cfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203526:	0009b783          	ld	a5,0(s3)
ffffffffc020352a:	4505                	li	a0,1
ffffffffc020352c:	6f9c                	ld	a5,24(a5)
ffffffffc020352e:	9782                	jalr	a5
ffffffffc0203530:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203532:	c76fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0203536:	b7c1                	j	ffffffffc02034f6 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203538:	100027f3          	csrr	a5,sstatus
ffffffffc020353c:	8b89                	andi	a5,a5,2
ffffffffc020353e:	eb89                	bnez	a5,ffffffffc0203550 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203540:	0009b783          	ld	a5,0(s3)
ffffffffc0203544:	8522                	mv	a0,s0
ffffffffc0203546:	4585                	li	a1,1
ffffffffc0203548:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020354a:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020354c:	9782                	jalr	a5
    if (flag)
ffffffffc020354e:	b7c9                	j	ffffffffc0203510 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203550:	c5efd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0203554:	0009b783          	ld	a5,0(s3)
ffffffffc0203558:	8522                	mv	a0,s0
ffffffffc020355a:	4585                	li	a1,1
ffffffffc020355c:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020355e:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203560:	9782                	jalr	a5
        intr_enable();
ffffffffc0203562:	c46fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0203566:	b76d                	j	ffffffffc0203510 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203568:	00004697          	auipc	a3,0x4
ffffffffc020356c:	c3868693          	addi	a3,a3,-968 # ffffffffc02071a0 <default_pmm_manager+0x770>
ffffffffc0203570:	00003617          	auipc	a2,0x3
ffffffffc0203574:	11060613          	addi	a2,a2,272 # ffffffffc0206680 <commands+0x818>
ffffffffc0203578:	1f900593          	li	a1,505
ffffffffc020357c:	00003517          	auipc	a0,0x3
ffffffffc0203580:	60450513          	addi	a0,a0,1540 # ffffffffc0206b80 <default_pmm_manager+0x150>
ffffffffc0203584:	f0ffc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203588 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203588:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc020358a:	00004697          	auipc	a3,0x4
ffffffffc020358e:	c2e68693          	addi	a3,a3,-978 # ffffffffc02071b8 <default_pmm_manager+0x788>
ffffffffc0203592:	00003617          	auipc	a2,0x3
ffffffffc0203596:	0ee60613          	addi	a2,a2,238 # ffffffffc0206680 <commands+0x818>
ffffffffc020359a:	07400593          	li	a1,116
ffffffffc020359e:	00004517          	auipc	a0,0x4
ffffffffc02035a2:	c3a50513          	addi	a0,a0,-966 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02035a6:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02035a8:	eebfc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02035ac <mm_create>:
{
ffffffffc02035ac:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02035ae:	04000513          	li	a0,64
{
ffffffffc02035b2:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02035b4:	df6fe0ef          	jal	ra,ffffffffc0201baa <kmalloc>
    if (mm != NULL)
ffffffffc02035b8:	cd19                	beqz	a0,ffffffffc02035d6 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02035ba:	e508                	sd	a0,8(a0)
ffffffffc02035bc:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02035be:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02035c2:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02035c6:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02035ca:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02035ce:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02035d2:	02053c23          	sd	zero,56(a0)
}
ffffffffc02035d6:	60a2                	ld	ra,8(sp)
ffffffffc02035d8:	0141                	addi	sp,sp,16
ffffffffc02035da:	8082                	ret

ffffffffc02035dc <find_vma>:
{
ffffffffc02035dc:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02035de:	c505                	beqz	a0,ffffffffc0203606 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc02035e0:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02035e2:	c501                	beqz	a0,ffffffffc02035ea <find_vma+0xe>
ffffffffc02035e4:	651c                	ld	a5,8(a0)
ffffffffc02035e6:	02f5f263          	bgeu	a1,a5,ffffffffc020360a <find_vma+0x2e>
    return listelm->next;
ffffffffc02035ea:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc02035ec:	00f68d63          	beq	a3,a5,ffffffffc0203606 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02035f0:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_matrix_out_size+0x1f38d8>
ffffffffc02035f4:	00e5e663          	bltu	a1,a4,ffffffffc0203600 <find_vma+0x24>
ffffffffc02035f8:	ff07b703          	ld	a4,-16(a5)
ffffffffc02035fc:	00e5ec63          	bltu	a1,a4,ffffffffc0203614 <find_vma+0x38>
ffffffffc0203600:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203602:	fef697e3          	bne	a3,a5,ffffffffc02035f0 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203606:	4501                	li	a0,0
}
ffffffffc0203608:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020360a:	691c                	ld	a5,16(a0)
ffffffffc020360c:	fcf5ffe3          	bgeu	a1,a5,ffffffffc02035ea <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203610:	ea88                	sd	a0,16(a3)
ffffffffc0203612:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203614:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203618:	ea88                	sd	a0,16(a3)
ffffffffc020361a:	8082                	ret

ffffffffc020361c <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc020361c:	6590                	ld	a2,8(a1)
ffffffffc020361e:	0105b803          	ld	a6,16(a1) # 80010 <_binary_obj___user_matrix_out_size+0x73900>
{
ffffffffc0203622:	1141                	addi	sp,sp,-16
ffffffffc0203624:	e406                	sd	ra,8(sp)
ffffffffc0203626:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203628:	01066763          	bltu	a2,a6,ffffffffc0203636 <insert_vma_struct+0x1a>
ffffffffc020362c:	a085                	j	ffffffffc020368c <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020362e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203632:	04e66863          	bltu	a2,a4,ffffffffc0203682 <insert_vma_struct+0x66>
ffffffffc0203636:	86be                	mv	a3,a5
ffffffffc0203638:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020363a:	fef51ae3          	bne	a0,a5,ffffffffc020362e <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc020363e:	02a68463          	beq	a3,a0,ffffffffc0203666 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203642:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203646:	fe86b883          	ld	a7,-24(a3)
ffffffffc020364a:	08e8f163          	bgeu	a7,a4,ffffffffc02036cc <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020364e:	04e66f63          	bltu	a2,a4,ffffffffc02036ac <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203652:	00f50a63          	beq	a0,a5,ffffffffc0203666 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203656:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020365a:	05076963          	bltu	a4,a6,ffffffffc02036ac <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc020365e:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203662:	02c77363          	bgeu	a4,a2,ffffffffc0203688 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203666:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203668:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020366a:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020366e:	e390                	sd	a2,0(a5)
ffffffffc0203670:	e690                	sd	a2,8(a3)
}
ffffffffc0203672:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203674:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203676:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203678:	0017079b          	addiw	a5,a4,1
ffffffffc020367c:	d11c                	sw	a5,32(a0)
}
ffffffffc020367e:	0141                	addi	sp,sp,16
ffffffffc0203680:	8082                	ret
    if (le_prev != list)
ffffffffc0203682:	fca690e3          	bne	a3,a0,ffffffffc0203642 <insert_vma_struct+0x26>
ffffffffc0203686:	bfd1                	j	ffffffffc020365a <insert_vma_struct+0x3e>
ffffffffc0203688:	f01ff0ef          	jal	ra,ffffffffc0203588 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc020368c:	00004697          	auipc	a3,0x4
ffffffffc0203690:	b5c68693          	addi	a3,a3,-1188 # ffffffffc02071e8 <default_pmm_manager+0x7b8>
ffffffffc0203694:	00003617          	auipc	a2,0x3
ffffffffc0203698:	fec60613          	addi	a2,a2,-20 # ffffffffc0206680 <commands+0x818>
ffffffffc020369c:	07a00593          	li	a1,122
ffffffffc02036a0:	00004517          	auipc	a0,0x4
ffffffffc02036a4:	b3850513          	addi	a0,a0,-1224 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc02036a8:	debfc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02036ac:	00004697          	auipc	a3,0x4
ffffffffc02036b0:	b7c68693          	addi	a3,a3,-1156 # ffffffffc0207228 <default_pmm_manager+0x7f8>
ffffffffc02036b4:	00003617          	auipc	a2,0x3
ffffffffc02036b8:	fcc60613          	addi	a2,a2,-52 # ffffffffc0206680 <commands+0x818>
ffffffffc02036bc:	07300593          	li	a1,115
ffffffffc02036c0:	00004517          	auipc	a0,0x4
ffffffffc02036c4:	b1850513          	addi	a0,a0,-1256 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc02036c8:	dcbfc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02036cc:	00004697          	auipc	a3,0x4
ffffffffc02036d0:	b3c68693          	addi	a3,a3,-1220 # ffffffffc0207208 <default_pmm_manager+0x7d8>
ffffffffc02036d4:	00003617          	auipc	a2,0x3
ffffffffc02036d8:	fac60613          	addi	a2,a2,-84 # ffffffffc0206680 <commands+0x818>
ffffffffc02036dc:	07200593          	li	a1,114
ffffffffc02036e0:	00004517          	auipc	a0,0x4
ffffffffc02036e4:	af850513          	addi	a0,a0,-1288 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc02036e8:	dabfc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02036ec <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02036ec:	591c                	lw	a5,48(a0)
{
ffffffffc02036ee:	1141                	addi	sp,sp,-16
ffffffffc02036f0:	e406                	sd	ra,8(sp)
ffffffffc02036f2:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02036f4:	e78d                	bnez	a5,ffffffffc020371e <mm_destroy+0x32>
ffffffffc02036f6:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02036f8:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02036fa:	00a40c63          	beq	s0,a0,ffffffffc0203712 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02036fe:	6118                	ld	a4,0(a0)
ffffffffc0203700:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203702:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203704:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203706:	e398                	sd	a4,0(a5)
ffffffffc0203708:	d52fe0ef          	jal	ra,ffffffffc0201c5a <kfree>
    return listelm->next;
ffffffffc020370c:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc020370e:	fea418e3          	bne	s0,a0,ffffffffc02036fe <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203712:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203714:	6402                	ld	s0,0(sp)
ffffffffc0203716:	60a2                	ld	ra,8(sp)
ffffffffc0203718:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020371a:	d40fe06f          	j	ffffffffc0201c5a <kfree>
    assert(mm_count(mm) == 0);
ffffffffc020371e:	00004697          	auipc	a3,0x4
ffffffffc0203722:	b2a68693          	addi	a3,a3,-1238 # ffffffffc0207248 <default_pmm_manager+0x818>
ffffffffc0203726:	00003617          	auipc	a2,0x3
ffffffffc020372a:	f5a60613          	addi	a2,a2,-166 # ffffffffc0206680 <commands+0x818>
ffffffffc020372e:	09e00593          	li	a1,158
ffffffffc0203732:	00004517          	auipc	a0,0x4
ffffffffc0203736:	aa650513          	addi	a0,a0,-1370 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc020373a:	d59fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020373e <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc020373e:	7139                	addi	sp,sp,-64
ffffffffc0203740:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203742:	6405                	lui	s0,0x1
ffffffffc0203744:	147d                	addi	s0,s0,-1
ffffffffc0203746:	77fd                	lui	a5,0xfffff
ffffffffc0203748:	9622                	add	a2,a2,s0
ffffffffc020374a:	962e                	add	a2,a2,a1
{
ffffffffc020374c:	f426                	sd	s1,40(sp)
ffffffffc020374e:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203750:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203754:	f04a                	sd	s2,32(sp)
ffffffffc0203756:	ec4e                	sd	s3,24(sp)
ffffffffc0203758:	e852                	sd	s4,16(sp)
ffffffffc020375a:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc020375c:	002005b7          	lui	a1,0x200
ffffffffc0203760:	00f67433          	and	s0,a2,a5
ffffffffc0203764:	06b4e363          	bltu	s1,a1,ffffffffc02037ca <mm_map+0x8c>
ffffffffc0203768:	0684f163          	bgeu	s1,s0,ffffffffc02037ca <mm_map+0x8c>
ffffffffc020376c:	4785                	li	a5,1
ffffffffc020376e:	07fe                	slli	a5,a5,0x1f
ffffffffc0203770:	0487ed63          	bltu	a5,s0,ffffffffc02037ca <mm_map+0x8c>
ffffffffc0203774:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203776:	cd21                	beqz	a0,ffffffffc02037ce <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203778:	85a6                	mv	a1,s1
ffffffffc020377a:	8ab6                	mv	s5,a3
ffffffffc020377c:	8a3a                	mv	s4,a4
ffffffffc020377e:	e5fff0ef          	jal	ra,ffffffffc02035dc <find_vma>
ffffffffc0203782:	c501                	beqz	a0,ffffffffc020378a <mm_map+0x4c>
ffffffffc0203784:	651c                	ld	a5,8(a0)
ffffffffc0203786:	0487e263          	bltu	a5,s0,ffffffffc02037ca <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020378a:	03000513          	li	a0,48
ffffffffc020378e:	c1cfe0ef          	jal	ra,ffffffffc0201baa <kmalloc>
ffffffffc0203792:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203794:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203796:	02090163          	beqz	s2,ffffffffc02037b8 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc020379a:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc020379c:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02037a0:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02037a4:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02037a8:	85ca                	mv	a1,s2
ffffffffc02037aa:	e73ff0ef          	jal	ra,ffffffffc020361c <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02037ae:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02037b0:	000a0463          	beqz	s4,ffffffffc02037b8 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02037b4:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f40>

out:
    return ret;
}
ffffffffc02037b8:	70e2                	ld	ra,56(sp)
ffffffffc02037ba:	7442                	ld	s0,48(sp)
ffffffffc02037bc:	74a2                	ld	s1,40(sp)
ffffffffc02037be:	7902                	ld	s2,32(sp)
ffffffffc02037c0:	69e2                	ld	s3,24(sp)
ffffffffc02037c2:	6a42                	ld	s4,16(sp)
ffffffffc02037c4:	6aa2                	ld	s5,8(sp)
ffffffffc02037c6:	6121                	addi	sp,sp,64
ffffffffc02037c8:	8082                	ret
        return -E_INVAL;
ffffffffc02037ca:	5575                	li	a0,-3
ffffffffc02037cc:	b7f5                	j	ffffffffc02037b8 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc02037ce:	00004697          	auipc	a3,0x4
ffffffffc02037d2:	a9268693          	addi	a3,a3,-1390 # ffffffffc0207260 <default_pmm_manager+0x830>
ffffffffc02037d6:	00003617          	auipc	a2,0x3
ffffffffc02037da:	eaa60613          	addi	a2,a2,-342 # ffffffffc0206680 <commands+0x818>
ffffffffc02037de:	0b300593          	li	a1,179
ffffffffc02037e2:	00004517          	auipc	a0,0x4
ffffffffc02037e6:	9f650513          	addi	a0,a0,-1546 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc02037ea:	ca9fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02037ee <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc02037ee:	7139                	addi	sp,sp,-64
ffffffffc02037f0:	fc06                	sd	ra,56(sp)
ffffffffc02037f2:	f822                	sd	s0,48(sp)
ffffffffc02037f4:	f426                	sd	s1,40(sp)
ffffffffc02037f6:	f04a                	sd	s2,32(sp)
ffffffffc02037f8:	ec4e                	sd	s3,24(sp)
ffffffffc02037fa:	e852                	sd	s4,16(sp)
ffffffffc02037fc:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc02037fe:	c52d                	beqz	a0,ffffffffc0203868 <dup_mmap+0x7a>
ffffffffc0203800:	892a                	mv	s2,a0
ffffffffc0203802:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203804:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203806:	e595                	bnez	a1,ffffffffc0203832 <dup_mmap+0x44>
ffffffffc0203808:	a085                	j	ffffffffc0203868 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc020380a:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc020380c:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_matrix_out_size+0x1f38f8>
        vma->vm_end = vm_end;
ffffffffc0203810:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203814:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203818:	e05ff0ef          	jal	ra,ffffffffc020361c <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc020381c:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8f50>
ffffffffc0203820:	fe843603          	ld	a2,-24(s0)
ffffffffc0203824:	6c8c                	ld	a1,24(s1)
ffffffffc0203826:	01893503          	ld	a0,24(s2)
ffffffffc020382a:	4701                	li	a4,0
ffffffffc020382c:	a3bff0ef          	jal	ra,ffffffffc0203266 <copy_range>
ffffffffc0203830:	e105                	bnez	a0,ffffffffc0203850 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203832:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203834:	02848863          	beq	s1,s0,ffffffffc0203864 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203838:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc020383c:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203840:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203844:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203848:	b62fe0ef          	jal	ra,ffffffffc0201baa <kmalloc>
ffffffffc020384c:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc020384e:	fd55                	bnez	a0,ffffffffc020380a <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203850:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203852:	70e2                	ld	ra,56(sp)
ffffffffc0203854:	7442                	ld	s0,48(sp)
ffffffffc0203856:	74a2                	ld	s1,40(sp)
ffffffffc0203858:	7902                	ld	s2,32(sp)
ffffffffc020385a:	69e2                	ld	s3,24(sp)
ffffffffc020385c:	6a42                	ld	s4,16(sp)
ffffffffc020385e:	6aa2                	ld	s5,8(sp)
ffffffffc0203860:	6121                	addi	sp,sp,64
ffffffffc0203862:	8082                	ret
    return 0;
ffffffffc0203864:	4501                	li	a0,0
ffffffffc0203866:	b7f5                	j	ffffffffc0203852 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203868:	00004697          	auipc	a3,0x4
ffffffffc020386c:	a0868693          	addi	a3,a3,-1528 # ffffffffc0207270 <default_pmm_manager+0x840>
ffffffffc0203870:	00003617          	auipc	a2,0x3
ffffffffc0203874:	e1060613          	addi	a2,a2,-496 # ffffffffc0206680 <commands+0x818>
ffffffffc0203878:	0cf00593          	li	a1,207
ffffffffc020387c:	00004517          	auipc	a0,0x4
ffffffffc0203880:	95c50513          	addi	a0,a0,-1700 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203884:	c0ffc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203888 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203888:	1101                	addi	sp,sp,-32
ffffffffc020388a:	ec06                	sd	ra,24(sp)
ffffffffc020388c:	e822                	sd	s0,16(sp)
ffffffffc020388e:	e426                	sd	s1,8(sp)
ffffffffc0203890:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203892:	c531                	beqz	a0,ffffffffc02038de <exit_mmap+0x56>
ffffffffc0203894:	591c                	lw	a5,48(a0)
ffffffffc0203896:	84aa                	mv	s1,a0
ffffffffc0203898:	e3b9                	bnez	a5,ffffffffc02038de <exit_mmap+0x56>
    return listelm->next;
ffffffffc020389a:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc020389c:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02038a0:	02850663          	beq	a0,s0,ffffffffc02038cc <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02038a4:	ff043603          	ld	a2,-16(s0)
ffffffffc02038a8:	fe843583          	ld	a1,-24(s0)
ffffffffc02038ac:	854a                	mv	a0,s2
ffffffffc02038ae:	80ffe0ef          	jal	ra,ffffffffc02020bc <unmap_range>
ffffffffc02038b2:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02038b4:	fe8498e3          	bne	s1,s0,ffffffffc02038a4 <exit_mmap+0x1c>
ffffffffc02038b8:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02038ba:	00848c63          	beq	s1,s0,ffffffffc02038d2 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02038be:	ff043603          	ld	a2,-16(s0)
ffffffffc02038c2:	fe843583          	ld	a1,-24(s0)
ffffffffc02038c6:	854a                	mv	a0,s2
ffffffffc02038c8:	93bfe0ef          	jal	ra,ffffffffc0202202 <exit_range>
ffffffffc02038cc:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02038ce:	fe8498e3          	bne	s1,s0,ffffffffc02038be <exit_mmap+0x36>
    }
}
ffffffffc02038d2:	60e2                	ld	ra,24(sp)
ffffffffc02038d4:	6442                	ld	s0,16(sp)
ffffffffc02038d6:	64a2                	ld	s1,8(sp)
ffffffffc02038d8:	6902                	ld	s2,0(sp)
ffffffffc02038da:	6105                	addi	sp,sp,32
ffffffffc02038dc:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02038de:	00004697          	auipc	a3,0x4
ffffffffc02038e2:	9b268693          	addi	a3,a3,-1614 # ffffffffc0207290 <default_pmm_manager+0x860>
ffffffffc02038e6:	00003617          	auipc	a2,0x3
ffffffffc02038ea:	d9a60613          	addi	a2,a2,-614 # ffffffffc0206680 <commands+0x818>
ffffffffc02038ee:	0e800593          	li	a1,232
ffffffffc02038f2:	00004517          	auipc	a0,0x4
ffffffffc02038f6:	8e650513          	addi	a0,a0,-1818 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc02038fa:	b99fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02038fe <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc02038fe:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203900:	04000513          	li	a0,64
{
ffffffffc0203904:	fc06                	sd	ra,56(sp)
ffffffffc0203906:	f822                	sd	s0,48(sp)
ffffffffc0203908:	f426                	sd	s1,40(sp)
ffffffffc020390a:	f04a                	sd	s2,32(sp)
ffffffffc020390c:	ec4e                	sd	s3,24(sp)
ffffffffc020390e:	e852                	sd	s4,16(sp)
ffffffffc0203910:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203912:	a98fe0ef          	jal	ra,ffffffffc0201baa <kmalloc>
    if (mm != NULL)
ffffffffc0203916:	2e050663          	beqz	a0,ffffffffc0203c02 <vmm_init+0x304>
ffffffffc020391a:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc020391c:	e508                	sd	a0,8(a0)
ffffffffc020391e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203920:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203924:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203928:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc020392c:	02053423          	sd	zero,40(a0)
ffffffffc0203930:	02052823          	sw	zero,48(a0)
ffffffffc0203934:	02053c23          	sd	zero,56(a0)
ffffffffc0203938:	03200413          	li	s0,50
ffffffffc020393c:	a811                	j	ffffffffc0203950 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc020393e:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203940:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203942:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203946:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203948:	8526                	mv	a0,s1
ffffffffc020394a:	cd3ff0ef          	jal	ra,ffffffffc020361c <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc020394e:	c80d                	beqz	s0,ffffffffc0203980 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203950:	03000513          	li	a0,48
ffffffffc0203954:	a56fe0ef          	jal	ra,ffffffffc0201baa <kmalloc>
ffffffffc0203958:	85aa                	mv	a1,a0
ffffffffc020395a:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc020395e:	f165                	bnez	a0,ffffffffc020393e <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203960:	00004697          	auipc	a3,0x4
ffffffffc0203964:	ac868693          	addi	a3,a3,-1336 # ffffffffc0207428 <default_pmm_manager+0x9f8>
ffffffffc0203968:	00003617          	auipc	a2,0x3
ffffffffc020396c:	d1860613          	addi	a2,a2,-744 # ffffffffc0206680 <commands+0x818>
ffffffffc0203970:	12c00593          	li	a1,300
ffffffffc0203974:	00004517          	auipc	a0,0x4
ffffffffc0203978:	86450513          	addi	a0,a0,-1948 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc020397c:	b17fc0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0203980:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203984:	1f900913          	li	s2,505
ffffffffc0203988:	a819                	j	ffffffffc020399e <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc020398a:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc020398c:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc020398e:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203992:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203994:	8526                	mv	a0,s1
ffffffffc0203996:	c87ff0ef          	jal	ra,ffffffffc020361c <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc020399a:	03240a63          	beq	s0,s2,ffffffffc02039ce <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020399e:	03000513          	li	a0,48
ffffffffc02039a2:	a08fe0ef          	jal	ra,ffffffffc0201baa <kmalloc>
ffffffffc02039a6:	85aa                	mv	a1,a0
ffffffffc02039a8:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc02039ac:	fd79                	bnez	a0,ffffffffc020398a <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc02039ae:	00004697          	auipc	a3,0x4
ffffffffc02039b2:	a7a68693          	addi	a3,a3,-1414 # ffffffffc0207428 <default_pmm_manager+0x9f8>
ffffffffc02039b6:	00003617          	auipc	a2,0x3
ffffffffc02039ba:	cca60613          	addi	a2,a2,-822 # ffffffffc0206680 <commands+0x818>
ffffffffc02039be:	13300593          	li	a1,307
ffffffffc02039c2:	00004517          	auipc	a0,0x4
ffffffffc02039c6:	81650513          	addi	a0,a0,-2026 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc02039ca:	ac9fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return listelm->next;
ffffffffc02039ce:	649c                	ld	a5,8(s1)
ffffffffc02039d0:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc02039d2:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc02039d6:	16f48663          	beq	s1,a5,ffffffffc0203b42 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02039da:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd383d8>
ffffffffc02039de:	ffe70693          	addi	a3,a4,-2
ffffffffc02039e2:	10d61063          	bne	a2,a3,ffffffffc0203ae2 <vmm_init+0x1e4>
ffffffffc02039e6:	ff07b683          	ld	a3,-16(a5)
ffffffffc02039ea:	0ed71c63          	bne	a4,a3,ffffffffc0203ae2 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc02039ee:	0715                	addi	a4,a4,5
ffffffffc02039f0:	679c                	ld	a5,8(a5)
ffffffffc02039f2:	feb712e3          	bne	a4,a1,ffffffffc02039d6 <vmm_init+0xd8>
ffffffffc02039f6:	4a1d                	li	s4,7
ffffffffc02039f8:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc02039fa:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc02039fe:	85a2                	mv	a1,s0
ffffffffc0203a00:	8526                	mv	a0,s1
ffffffffc0203a02:	bdbff0ef          	jal	ra,ffffffffc02035dc <find_vma>
ffffffffc0203a06:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203a08:	16050d63          	beqz	a0,ffffffffc0203b82 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203a0c:	00140593          	addi	a1,s0,1
ffffffffc0203a10:	8526                	mv	a0,s1
ffffffffc0203a12:	bcbff0ef          	jal	ra,ffffffffc02035dc <find_vma>
ffffffffc0203a16:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203a18:	14050563          	beqz	a0,ffffffffc0203b62 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203a1c:	85d2                	mv	a1,s4
ffffffffc0203a1e:	8526                	mv	a0,s1
ffffffffc0203a20:	bbdff0ef          	jal	ra,ffffffffc02035dc <find_vma>
        assert(vma3 == NULL);
ffffffffc0203a24:	16051f63          	bnez	a0,ffffffffc0203ba2 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203a28:	00340593          	addi	a1,s0,3
ffffffffc0203a2c:	8526                	mv	a0,s1
ffffffffc0203a2e:	bafff0ef          	jal	ra,ffffffffc02035dc <find_vma>
        assert(vma4 == NULL);
ffffffffc0203a32:	1a051863          	bnez	a0,ffffffffc0203be2 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203a36:	00440593          	addi	a1,s0,4
ffffffffc0203a3a:	8526                	mv	a0,s1
ffffffffc0203a3c:	ba1ff0ef          	jal	ra,ffffffffc02035dc <find_vma>
        assert(vma5 == NULL);
ffffffffc0203a40:	18051163          	bnez	a0,ffffffffc0203bc2 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203a44:	00893783          	ld	a5,8(s2)
ffffffffc0203a48:	0a879d63          	bne	a5,s0,ffffffffc0203b02 <vmm_init+0x204>
ffffffffc0203a4c:	01093783          	ld	a5,16(s2)
ffffffffc0203a50:	0b479963          	bne	a5,s4,ffffffffc0203b02 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203a54:	0089b783          	ld	a5,8(s3)
ffffffffc0203a58:	0c879563          	bne	a5,s0,ffffffffc0203b22 <vmm_init+0x224>
ffffffffc0203a5c:	0109b783          	ld	a5,16(s3)
ffffffffc0203a60:	0d479163          	bne	a5,s4,ffffffffc0203b22 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203a64:	0415                	addi	s0,s0,5
ffffffffc0203a66:	0a15                	addi	s4,s4,5
ffffffffc0203a68:	f9541be3          	bne	s0,s5,ffffffffc02039fe <vmm_init+0x100>
ffffffffc0203a6c:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203a6e:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203a70:	85a2                	mv	a1,s0
ffffffffc0203a72:	8526                	mv	a0,s1
ffffffffc0203a74:	b69ff0ef          	jal	ra,ffffffffc02035dc <find_vma>
ffffffffc0203a78:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203a7c:	c90d                	beqz	a0,ffffffffc0203aae <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203a7e:	6914                	ld	a3,16(a0)
ffffffffc0203a80:	6510                	ld	a2,8(a0)
ffffffffc0203a82:	00004517          	auipc	a0,0x4
ffffffffc0203a86:	92e50513          	addi	a0,a0,-1746 # ffffffffc02073b0 <default_pmm_manager+0x980>
ffffffffc0203a8a:	f0efc0ef          	jal	ra,ffffffffc0200198 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203a8e:	00004697          	auipc	a3,0x4
ffffffffc0203a92:	94a68693          	addi	a3,a3,-1718 # ffffffffc02073d8 <default_pmm_manager+0x9a8>
ffffffffc0203a96:	00003617          	auipc	a2,0x3
ffffffffc0203a9a:	bea60613          	addi	a2,a2,-1046 # ffffffffc0206680 <commands+0x818>
ffffffffc0203a9e:	15900593          	li	a1,345
ffffffffc0203aa2:	00003517          	auipc	a0,0x3
ffffffffc0203aa6:	73650513          	addi	a0,a0,1846 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203aaa:	9e9fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203aae:	147d                	addi	s0,s0,-1
ffffffffc0203ab0:	fd2410e3          	bne	s0,s2,ffffffffc0203a70 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203ab4:	8526                	mv	a0,s1
ffffffffc0203ab6:	c37ff0ef          	jal	ra,ffffffffc02036ec <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203aba:	00004517          	auipc	a0,0x4
ffffffffc0203abe:	93650513          	addi	a0,a0,-1738 # ffffffffc02073f0 <default_pmm_manager+0x9c0>
ffffffffc0203ac2:	ed6fc0ef          	jal	ra,ffffffffc0200198 <cprintf>
}
ffffffffc0203ac6:	7442                	ld	s0,48(sp)
ffffffffc0203ac8:	70e2                	ld	ra,56(sp)
ffffffffc0203aca:	74a2                	ld	s1,40(sp)
ffffffffc0203acc:	7902                	ld	s2,32(sp)
ffffffffc0203ace:	69e2                	ld	s3,24(sp)
ffffffffc0203ad0:	6a42                	ld	s4,16(sp)
ffffffffc0203ad2:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203ad4:	00004517          	auipc	a0,0x4
ffffffffc0203ad8:	93c50513          	addi	a0,a0,-1732 # ffffffffc0207410 <default_pmm_manager+0x9e0>
}
ffffffffc0203adc:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203ade:	ebafc06f          	j	ffffffffc0200198 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203ae2:	00003697          	auipc	a3,0x3
ffffffffc0203ae6:	7e668693          	addi	a3,a3,2022 # ffffffffc02072c8 <default_pmm_manager+0x898>
ffffffffc0203aea:	00003617          	auipc	a2,0x3
ffffffffc0203aee:	b9660613          	addi	a2,a2,-1130 # ffffffffc0206680 <commands+0x818>
ffffffffc0203af2:	13d00593          	li	a1,317
ffffffffc0203af6:	00003517          	auipc	a0,0x3
ffffffffc0203afa:	6e250513          	addi	a0,a0,1762 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203afe:	995fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b02:	00004697          	auipc	a3,0x4
ffffffffc0203b06:	84e68693          	addi	a3,a3,-1970 # ffffffffc0207350 <default_pmm_manager+0x920>
ffffffffc0203b0a:	00003617          	auipc	a2,0x3
ffffffffc0203b0e:	b7660613          	addi	a2,a2,-1162 # ffffffffc0206680 <commands+0x818>
ffffffffc0203b12:	14e00593          	li	a1,334
ffffffffc0203b16:	00003517          	auipc	a0,0x3
ffffffffc0203b1a:	6c250513          	addi	a0,a0,1730 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203b1e:	975fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b22:	00004697          	auipc	a3,0x4
ffffffffc0203b26:	85e68693          	addi	a3,a3,-1954 # ffffffffc0207380 <default_pmm_manager+0x950>
ffffffffc0203b2a:	00003617          	auipc	a2,0x3
ffffffffc0203b2e:	b5660613          	addi	a2,a2,-1194 # ffffffffc0206680 <commands+0x818>
ffffffffc0203b32:	14f00593          	li	a1,335
ffffffffc0203b36:	00003517          	auipc	a0,0x3
ffffffffc0203b3a:	6a250513          	addi	a0,a0,1698 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203b3e:	955fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203b42:	00003697          	auipc	a3,0x3
ffffffffc0203b46:	76e68693          	addi	a3,a3,1902 # ffffffffc02072b0 <default_pmm_manager+0x880>
ffffffffc0203b4a:	00003617          	auipc	a2,0x3
ffffffffc0203b4e:	b3660613          	addi	a2,a2,-1226 # ffffffffc0206680 <commands+0x818>
ffffffffc0203b52:	13b00593          	li	a1,315
ffffffffc0203b56:	00003517          	auipc	a0,0x3
ffffffffc0203b5a:	68250513          	addi	a0,a0,1666 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203b5e:	935fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma2 != NULL);
ffffffffc0203b62:	00003697          	auipc	a3,0x3
ffffffffc0203b66:	7ae68693          	addi	a3,a3,1966 # ffffffffc0207310 <default_pmm_manager+0x8e0>
ffffffffc0203b6a:	00003617          	auipc	a2,0x3
ffffffffc0203b6e:	b1660613          	addi	a2,a2,-1258 # ffffffffc0206680 <commands+0x818>
ffffffffc0203b72:	14600593          	li	a1,326
ffffffffc0203b76:	00003517          	auipc	a0,0x3
ffffffffc0203b7a:	66250513          	addi	a0,a0,1634 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203b7e:	915fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma1 != NULL);
ffffffffc0203b82:	00003697          	auipc	a3,0x3
ffffffffc0203b86:	77e68693          	addi	a3,a3,1918 # ffffffffc0207300 <default_pmm_manager+0x8d0>
ffffffffc0203b8a:	00003617          	auipc	a2,0x3
ffffffffc0203b8e:	af660613          	addi	a2,a2,-1290 # ffffffffc0206680 <commands+0x818>
ffffffffc0203b92:	14400593          	li	a1,324
ffffffffc0203b96:	00003517          	auipc	a0,0x3
ffffffffc0203b9a:	64250513          	addi	a0,a0,1602 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203b9e:	8f5fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma3 == NULL);
ffffffffc0203ba2:	00003697          	auipc	a3,0x3
ffffffffc0203ba6:	77e68693          	addi	a3,a3,1918 # ffffffffc0207320 <default_pmm_manager+0x8f0>
ffffffffc0203baa:	00003617          	auipc	a2,0x3
ffffffffc0203bae:	ad660613          	addi	a2,a2,-1322 # ffffffffc0206680 <commands+0x818>
ffffffffc0203bb2:	14800593          	li	a1,328
ffffffffc0203bb6:	00003517          	auipc	a0,0x3
ffffffffc0203bba:	62250513          	addi	a0,a0,1570 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203bbe:	8d5fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma5 == NULL);
ffffffffc0203bc2:	00003697          	auipc	a3,0x3
ffffffffc0203bc6:	77e68693          	addi	a3,a3,1918 # ffffffffc0207340 <default_pmm_manager+0x910>
ffffffffc0203bca:	00003617          	auipc	a2,0x3
ffffffffc0203bce:	ab660613          	addi	a2,a2,-1354 # ffffffffc0206680 <commands+0x818>
ffffffffc0203bd2:	14c00593          	li	a1,332
ffffffffc0203bd6:	00003517          	auipc	a0,0x3
ffffffffc0203bda:	60250513          	addi	a0,a0,1538 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203bde:	8b5fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma4 == NULL);
ffffffffc0203be2:	00003697          	auipc	a3,0x3
ffffffffc0203be6:	74e68693          	addi	a3,a3,1870 # ffffffffc0207330 <default_pmm_manager+0x900>
ffffffffc0203bea:	00003617          	auipc	a2,0x3
ffffffffc0203bee:	a9660613          	addi	a2,a2,-1386 # ffffffffc0206680 <commands+0x818>
ffffffffc0203bf2:	14a00593          	li	a1,330
ffffffffc0203bf6:	00003517          	auipc	a0,0x3
ffffffffc0203bfa:	5e250513          	addi	a0,a0,1506 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203bfe:	895fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(mm != NULL);
ffffffffc0203c02:	00003697          	auipc	a3,0x3
ffffffffc0203c06:	65e68693          	addi	a3,a3,1630 # ffffffffc0207260 <default_pmm_manager+0x830>
ffffffffc0203c0a:	00003617          	auipc	a2,0x3
ffffffffc0203c0e:	a7660613          	addi	a2,a2,-1418 # ffffffffc0206680 <commands+0x818>
ffffffffc0203c12:	12400593          	li	a1,292
ffffffffc0203c16:	00003517          	auipc	a0,0x3
ffffffffc0203c1a:	5c250513          	addi	a0,a0,1474 # ffffffffc02071d8 <default_pmm_manager+0x7a8>
ffffffffc0203c1e:	875fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203c22 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203c22:	7179                	addi	sp,sp,-48
ffffffffc0203c24:	f022                	sd	s0,32(sp)
ffffffffc0203c26:	f406                	sd	ra,40(sp)
ffffffffc0203c28:	ec26                	sd	s1,24(sp)
ffffffffc0203c2a:	e84a                	sd	s2,16(sp)
ffffffffc0203c2c:	e44e                	sd	s3,8(sp)
ffffffffc0203c2e:	e052                	sd	s4,0(sp)
ffffffffc0203c30:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203c32:	c135                	beqz	a0,ffffffffc0203c96 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203c34:	002007b7          	lui	a5,0x200
ffffffffc0203c38:	04f5e663          	bltu	a1,a5,ffffffffc0203c84 <user_mem_check+0x62>
ffffffffc0203c3c:	00c584b3          	add	s1,a1,a2
ffffffffc0203c40:	0495f263          	bgeu	a1,s1,ffffffffc0203c84 <user_mem_check+0x62>
ffffffffc0203c44:	4785                	li	a5,1
ffffffffc0203c46:	07fe                	slli	a5,a5,0x1f
ffffffffc0203c48:	0297ee63          	bltu	a5,s1,ffffffffc0203c84 <user_mem_check+0x62>
ffffffffc0203c4c:	892a                	mv	s2,a0
ffffffffc0203c4e:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203c50:	6a05                	lui	s4,0x1
ffffffffc0203c52:	a821                	j	ffffffffc0203c6a <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c54:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203c58:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203c5a:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c5c:	c685                	beqz	a3,ffffffffc0203c84 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203c5e:	c399                	beqz	a5,ffffffffc0203c64 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203c60:	02e46263          	bltu	s0,a4,ffffffffc0203c84 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203c64:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203c66:	04947663          	bgeu	s0,s1,ffffffffc0203cb2 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203c6a:	85a2                	mv	a1,s0
ffffffffc0203c6c:	854a                	mv	a0,s2
ffffffffc0203c6e:	96fff0ef          	jal	ra,ffffffffc02035dc <find_vma>
ffffffffc0203c72:	c909                	beqz	a0,ffffffffc0203c84 <user_mem_check+0x62>
ffffffffc0203c74:	6518                	ld	a4,8(a0)
ffffffffc0203c76:	00e46763          	bltu	s0,a4,ffffffffc0203c84 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c7a:	4d1c                	lw	a5,24(a0)
ffffffffc0203c7c:	fc099ce3          	bnez	s3,ffffffffc0203c54 <user_mem_check+0x32>
ffffffffc0203c80:	8b85                	andi	a5,a5,1
ffffffffc0203c82:	f3ed                	bnez	a5,ffffffffc0203c64 <user_mem_check+0x42>
            return 0;
ffffffffc0203c84:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203c86:	70a2                	ld	ra,40(sp)
ffffffffc0203c88:	7402                	ld	s0,32(sp)
ffffffffc0203c8a:	64e2                	ld	s1,24(sp)
ffffffffc0203c8c:	6942                	ld	s2,16(sp)
ffffffffc0203c8e:	69a2                	ld	s3,8(sp)
ffffffffc0203c90:	6a02                	ld	s4,0(sp)
ffffffffc0203c92:	6145                	addi	sp,sp,48
ffffffffc0203c94:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203c96:	c02007b7          	lui	a5,0xc0200
ffffffffc0203c9a:	4501                	li	a0,0
ffffffffc0203c9c:	fef5e5e3          	bltu	a1,a5,ffffffffc0203c86 <user_mem_check+0x64>
ffffffffc0203ca0:	962e                	add	a2,a2,a1
ffffffffc0203ca2:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203c86 <user_mem_check+0x64>
ffffffffc0203ca6:	c8000537          	lui	a0,0xc8000
ffffffffc0203caa:	0505                	addi	a0,a0,1
ffffffffc0203cac:	00a63533          	sltu	a0,a2,a0
ffffffffc0203cb0:	bfd9                	j	ffffffffc0203c86 <user_mem_check+0x64>
        return 1;
ffffffffc0203cb2:	4505                	li	a0,1
ffffffffc0203cb4:	bfc9                	j	ffffffffc0203c86 <user_mem_check+0x64>

ffffffffc0203cb6 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203cb6:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203cb8:	9402                	jalr	s0

	jal do_exit
ffffffffc0203cba:	58a000ef          	jal	ra,ffffffffc0204244 <do_exit>

ffffffffc0203cbe <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203cbe:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203cc0:	15000513          	li	a0,336
{
ffffffffc0203cc4:	e022                	sd	s0,0(sp)
ffffffffc0203cc6:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203cc8:	ee3fd0ef          	jal	ra,ffffffffc0201baa <kmalloc>
ffffffffc0203ccc:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203cce:	cd35                	beqz	a0,ffffffffc0203d4a <alloc_proc+0x8c>
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */

        // Initialize basic fields
        proc->state = PROC_UNINIT;
ffffffffc0203cd0:	57fd                	li	a5,-1
ffffffffc0203cd2:	1782                	slli	a5,a5,0x20
ffffffffc0203cd4:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203cd6:	07000613          	li	a2,112
ffffffffc0203cda:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203cdc:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d393f8>
        proc->kstack = 0;
ffffffffc0203ce0:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203ce4:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203ce8:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203cec:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203cf0:	03050513          	addi	a0,a0,48
ffffffffc0203cf4:	6e1010ef          	jal	ra,ffffffffc0205bd4 <memset>
        proc->tf = NULL;
        proc->pgdir = 0;
        proc->flags = 0;
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203cf8:	4641                	li	a2,16
        proc->tf = NULL;
ffffffffc0203cfa:	0a043023          	sd	zero,160(s0)
        proc->pgdir = 0;
ffffffffc0203cfe:	0a043423          	sd	zero,168(s0)
        proc->flags = 0;
ffffffffc0203d02:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203d06:	4581                	li	a1,0
ffffffffc0203d08:	0b440513          	addi	a0,s0,180
ffffffffc0203d0c:	6c9010ef          	jal	ra,ffffffffc0205bd4 <memset>
         *       uint32_t lab6_stride;                       // stride value (lab6 stride)
         *       uint32_t lab6_priority;                     // priority value (lab6 stride)
         */
        // Initialize LAB6 additions
        proc->rq = NULL;
        list_init(&(proc->run_link));
ffffffffc0203d10:	11040793          	addi	a5,s0,272
    elm->prev = elm->next = elm;
ffffffffc0203d14:	10f43c23          	sd	a5,280(s0)
ffffffffc0203d18:	10f43823          	sd	a5,272(s0)
        proc->time_slice = 0;
        skew_heap_init(&(proc->lab6_run_pool));
        proc->lab6_stride = 0;
        proc->lab6_priority = 1;
ffffffffc0203d1c:	4785                	li	a5,1
        proc->wait_state = 0;
ffffffffc0203d1e:	0e042623          	sw	zero,236(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc0203d22:	10043023          	sd	zero,256(s0)
ffffffffc0203d26:	0e043c23          	sd	zero,248(s0)
ffffffffc0203d2a:	0e043823          	sd	zero,240(s0)
        proc->rq = NULL;
ffffffffc0203d2e:	10043423          	sd	zero,264(s0)
        proc->time_slice = 0;
ffffffffc0203d32:	12042023          	sw	zero,288(s0)
     compare_f comp) __attribute__((always_inline));

static inline void
skew_heap_init(skew_heap_entry_t *a)
{
     a->left = a->right = a->parent = NULL;
ffffffffc0203d36:	12043423          	sd	zero,296(s0)
ffffffffc0203d3a:	12043c23          	sd	zero,312(s0)
ffffffffc0203d3e:	12043823          	sd	zero,304(s0)
        proc->lab6_stride = 0;
ffffffffc0203d42:	14043023          	sd	zero,320(s0)
        proc->lab6_priority = 1;
ffffffffc0203d46:	14f42423          	sw	a5,328(s0)
    }
    return proc;
}
ffffffffc0203d4a:	60a2                	ld	ra,8(sp)
ffffffffc0203d4c:	8522                	mv	a0,s0
ffffffffc0203d4e:	6402                	ld	s0,0(sp)
ffffffffc0203d50:	0141                	addi	sp,sp,16
ffffffffc0203d52:	8082                	ret

ffffffffc0203d54 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203d54:	000c3797          	auipc	a5,0xc3
ffffffffc0203d58:	e8c7b783          	ld	a5,-372(a5) # ffffffffc02c6be0 <current>
ffffffffc0203d5c:	73c8                	ld	a0,160(a5)
ffffffffc0203d5e:	968fd06f          	j	ffffffffc0200ec6 <forkrets>

ffffffffc0203d62 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203d62:	6d14                	ld	a3,24(a0)
}

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm)
{
ffffffffc0203d64:	1141                	addi	sp,sp,-16
ffffffffc0203d66:	e406                	sd	ra,8(sp)
ffffffffc0203d68:	c02007b7          	lui	a5,0xc0200
ffffffffc0203d6c:	02f6ee63          	bltu	a3,a5,ffffffffc0203da8 <put_pgdir+0x46>
ffffffffc0203d70:	000c3517          	auipc	a0,0xc3
ffffffffc0203d74:	e6853503          	ld	a0,-408(a0) # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0203d78:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203d7a:	82b1                	srli	a3,a3,0xc
ffffffffc0203d7c:	000c3797          	auipc	a5,0xc3
ffffffffc0203d80:	e447b783          	ld	a5,-444(a5) # ffffffffc02c6bc0 <npage>
ffffffffc0203d84:	02f6fe63          	bgeu	a3,a5,ffffffffc0203dc0 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203d88:	00004517          	auipc	a0,0x4
ffffffffc0203d8c:	6e853503          	ld	a0,1768(a0) # ffffffffc0208470 <nbase>
    free_page(kva2page(mm->pgdir));
}
ffffffffc0203d90:	60a2                	ld	ra,8(sp)
ffffffffc0203d92:	8e89                	sub	a3,a3,a0
ffffffffc0203d94:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203d96:	000c3517          	auipc	a0,0xc3
ffffffffc0203d9a:	e3253503          	ld	a0,-462(a0) # ffffffffc02c6bc8 <pages>
ffffffffc0203d9e:	4585                	li	a1,1
ffffffffc0203da0:	9536                	add	a0,a0,a3
}
ffffffffc0203da2:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203da4:	822fe06f          	j	ffffffffc0201dc6 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203da8:	00003617          	auipc	a2,0x3
ffffffffc0203dac:	d6860613          	addi	a2,a2,-664 # ffffffffc0206b10 <default_pmm_manager+0xe0>
ffffffffc0203db0:	07700593          	li	a1,119
ffffffffc0203db4:	00003517          	auipc	a0,0x3
ffffffffc0203db8:	cdc50513          	addi	a0,a0,-804 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc0203dbc:	ed6fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203dc0:	00003617          	auipc	a2,0x3
ffffffffc0203dc4:	d7860613          	addi	a2,a2,-648 # ffffffffc0206b38 <default_pmm_manager+0x108>
ffffffffc0203dc8:	06900593          	li	a1,105
ffffffffc0203dcc:	00003517          	auipc	a0,0x3
ffffffffc0203dd0:	cc450513          	addi	a0,a0,-828 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc0203dd4:	ebefc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203dd8 <proc_run>:
{
ffffffffc0203dd8:	1101                	addi	sp,sp,-32
ffffffffc0203dda:	e426                	sd	s1,8(sp)
    if (proc != current)
ffffffffc0203ddc:	000c3497          	auipc	s1,0xc3
ffffffffc0203de0:	e0448493          	addi	s1,s1,-508 # ffffffffc02c6be0 <current>
ffffffffc0203de4:	6098                	ld	a4,0(s1)
{
ffffffffc0203de6:	ec06                	sd	ra,24(sp)
ffffffffc0203de8:	e822                	sd	s0,16(sp)
ffffffffc0203dea:	e04a                	sd	s2,0(sp)
    if (proc != current)
ffffffffc0203dec:	04a70163          	beq	a4,a0,ffffffffc0203e2e <proc_run+0x56>
ffffffffc0203df0:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203df2:	100027f3          	csrr	a5,sstatus
ffffffffc0203df6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203df8:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203dfa:	e7a9                	bnez	a5,ffffffffc0203e44 <proc_run+0x6c>
            if (proc->mm != NULL)
ffffffffc0203dfc:	741c                	ld	a5,40(s0)
ffffffffc0203dfe:	cf95                	beqz	a5,ffffffffc0203e3a <proc_run+0x62>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203e00:	745c                	ld	a5,168(s0)
ffffffffc0203e02:	56fd                	li	a3,-1
ffffffffc0203e04:	16fe                	slli	a3,a3,0x3f
ffffffffc0203e06:	83b1                	srli	a5,a5,0xc
ffffffffc0203e08:	8fd5                	or	a5,a5,a3
ffffffffc0203e0a:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203e0e:	03040593          	addi	a1,s0,48
ffffffffc0203e12:	03070513          	addi	a0,a4,48
            current = proc;
ffffffffc0203e16:	e080                	sd	s0,0(s1)
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203e18:	0cc010ef          	jal	ra,ffffffffc0204ee4 <switch_to>
    if (flag)
ffffffffc0203e1c:	00090963          	beqz	s2,ffffffffc0203e2e <proc_run+0x56>
}
ffffffffc0203e20:	6442                	ld	s0,16(sp)
ffffffffc0203e22:	60e2                	ld	ra,24(sp)
ffffffffc0203e24:	64a2                	ld	s1,8(sp)
ffffffffc0203e26:	6902                	ld	s2,0(sp)
ffffffffc0203e28:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203e2a:	b7ffc06f          	j	ffffffffc02009a8 <intr_enable>
ffffffffc0203e2e:	60e2                	ld	ra,24(sp)
ffffffffc0203e30:	6442                	ld	s0,16(sp)
ffffffffc0203e32:	64a2                	ld	s1,8(sp)
ffffffffc0203e34:	6902                	ld	s2,0(sp)
ffffffffc0203e36:	6105                	addi	sp,sp,32
ffffffffc0203e38:	8082                	ret
ffffffffc0203e3a:	000c3797          	auipc	a5,0xc3
ffffffffc0203e3e:	d767b783          	ld	a5,-650(a5) # ffffffffc02c6bb0 <boot_pgdir_pa>
ffffffffc0203e42:	b7c1                	j	ffffffffc0203e02 <proc_run+0x2a>
        intr_disable();
ffffffffc0203e44:	b6bfc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
            struct proc_struct *prev = current;
ffffffffc0203e48:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0203e4a:	4905                	li	s2,1
ffffffffc0203e4c:	bf45                	j	ffffffffc0203dfc <proc_run+0x24>

ffffffffc0203e4e <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
ffffffffc0203e4e:	7119                	addi	sp,sp,-128
ffffffffc0203e50:	f0ca                	sd	s2,96(sp)
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
ffffffffc0203e52:	000c3917          	auipc	s2,0xc3
ffffffffc0203e56:	da690913          	addi	s2,s2,-602 # ffffffffc02c6bf8 <nr_process>
ffffffffc0203e5a:	00092703          	lw	a4,0(s2)
{
ffffffffc0203e5e:	fc86                	sd	ra,120(sp)
ffffffffc0203e60:	f8a2                	sd	s0,112(sp)
ffffffffc0203e62:	f4a6                	sd	s1,104(sp)
ffffffffc0203e64:	ecce                	sd	s3,88(sp)
ffffffffc0203e66:	e8d2                	sd	s4,80(sp)
ffffffffc0203e68:	e4d6                	sd	s5,72(sp)
ffffffffc0203e6a:	e0da                	sd	s6,64(sp)
ffffffffc0203e6c:	fc5e                	sd	s7,56(sp)
ffffffffc0203e6e:	f862                	sd	s8,48(sp)
ffffffffc0203e70:	f466                	sd	s9,40(sp)
ffffffffc0203e72:	f06a                	sd	s10,32(sp)
ffffffffc0203e74:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203e76:	6785                	lui	a5,0x1
ffffffffc0203e78:	2ef75c63          	bge	a4,a5,ffffffffc0204170 <do_fork+0x322>
ffffffffc0203e7c:	8a2a                	mv	s4,a0
ffffffffc0203e7e:	89ae                	mv	s3,a1
ffffffffc0203e80:	8432                	mv	s0,a2
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    if ((proc = alloc_proc()) == NULL)
ffffffffc0203e82:	e3dff0ef          	jal	ra,ffffffffc0203cbe <alloc_proc>
ffffffffc0203e86:	84aa                	mv	s1,a0
ffffffffc0203e88:	2c050863          	beqz	a0,ffffffffc0204158 <do_fork+0x30a>
    {
        goto fork_out;
    }
    // LAB5 update step 1: set parent and clear wait_state
    proc->parent = current;
ffffffffc0203e8c:	000c3c17          	auipc	s8,0xc3
ffffffffc0203e90:	d54c0c13          	addi	s8,s8,-684 # ffffffffc02c6be0 <current>
ffffffffc0203e94:	000c3783          	ld	a5,0(s8)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203e98:	4509                	li	a0,2
    proc->parent = current;
ffffffffc0203e9a:	f09c                	sd	a5,32(s1)
    current->wait_state = 0;
ffffffffc0203e9c:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8e54>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203ea0:	ee9fd0ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
    if (page != NULL)
ffffffffc0203ea4:	2a050763          	beqz	a0,ffffffffc0204152 <do_fork+0x304>
    return page - pages + nbase;
ffffffffc0203ea8:	000c3a97          	auipc	s5,0xc3
ffffffffc0203eac:	d20a8a93          	addi	s5,s5,-736 # ffffffffc02c6bc8 <pages>
ffffffffc0203eb0:	000ab683          	ld	a3,0(s5)
ffffffffc0203eb4:	00004b17          	auipc	s6,0x4
ffffffffc0203eb8:	5bcb0b13          	addi	s6,s6,1468 # ffffffffc0208470 <nbase>
ffffffffc0203ebc:	000b3783          	ld	a5,0(s6)
ffffffffc0203ec0:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0203ec4:	000c3b97          	auipc	s7,0xc3
ffffffffc0203ec8:	cfcb8b93          	addi	s7,s7,-772 # ffffffffc02c6bc0 <npage>
    return page - pages + nbase;
ffffffffc0203ecc:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203ece:	5dfd                	li	s11,-1
ffffffffc0203ed0:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0203ed4:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203ed6:	00cddd93          	srli	s11,s11,0xc
ffffffffc0203eda:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0203ede:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203ee0:	2ce67563          	bgeu	a2,a4,ffffffffc02041aa <do_fork+0x35c>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0203ee4:	000c3603          	ld	a2,0(s8)
ffffffffc0203ee8:	000c3c17          	auipc	s8,0xc3
ffffffffc0203eec:	cf0c0c13          	addi	s8,s8,-784 # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0203ef0:	000c3703          	ld	a4,0(s8)
ffffffffc0203ef4:	02863d03          	ld	s10,40(a2)
ffffffffc0203ef8:	e43e                	sd	a5,8(sp)
ffffffffc0203efa:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0203efc:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0203efe:	020d0863          	beqz	s10,ffffffffc0203f2e <do_fork+0xe0>
    if (clone_flags & CLONE_VM)
ffffffffc0203f02:	100a7a13          	andi	s4,s4,256
ffffffffc0203f06:	180a0863          	beqz	s4,ffffffffc0204096 <do_fork+0x248>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0203f0a:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203f0e:	018d3783          	ld	a5,24(s10)
ffffffffc0203f12:	c02006b7          	lui	a3,0xc0200
ffffffffc0203f16:	2705                	addiw	a4,a4,1
ffffffffc0203f18:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc0203f1c:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203f20:	2ad7e163          	bltu	a5,a3,ffffffffc02041c2 <do_fork+0x374>
ffffffffc0203f24:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203f28:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203f2a:	8f99                	sub	a5,a5,a4
ffffffffc0203f2c:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203f2e:	6789                	lui	a5,0x2
ffffffffc0203f30:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x8060>
ffffffffc0203f34:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0203f36:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203f38:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc0203f3a:	87b6                	mv	a5,a3
ffffffffc0203f3c:	12040893          	addi	a7,s0,288
ffffffffc0203f40:	00063803          	ld	a6,0(a2)
ffffffffc0203f44:	6608                	ld	a0,8(a2)
ffffffffc0203f46:	6a0c                	ld	a1,16(a2)
ffffffffc0203f48:	6e18                	ld	a4,24(a2)
ffffffffc0203f4a:	0107b023          	sd	a6,0(a5)
ffffffffc0203f4e:	e788                	sd	a0,8(a5)
ffffffffc0203f50:	eb8c                	sd	a1,16(a5)
ffffffffc0203f52:	ef98                	sd	a4,24(a5)
ffffffffc0203f54:	02060613          	addi	a2,a2,32
ffffffffc0203f58:	02078793          	addi	a5,a5,32
ffffffffc0203f5c:	ff1612e3          	bne	a2,a7,ffffffffc0203f40 <do_fork+0xf2>
    proc->tf->gpr.a0 = 0;
ffffffffc0203f60:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203f64:	12098763          	beqz	s3,ffffffffc0204092 <do_fork+0x244>
    if (++last_pid >= MAX_PID)
ffffffffc0203f68:	000be817          	auipc	a6,0xbe
ffffffffc0203f6c:	7c080813          	addi	a6,a6,1984 # ffffffffc02c2728 <last_pid.1>
ffffffffc0203f70:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203f74:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203f78:	00000717          	auipc	a4,0x0
ffffffffc0203f7c:	ddc70713          	addi	a4,a4,-548 # ffffffffc0203d54 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0203f80:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203f84:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0203f86:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc0203f88:	00a82023          	sw	a0,0(a6)
ffffffffc0203f8c:	6789                	lui	a5,0x2
ffffffffc0203f8e:	08f55b63          	bge	a0,a5,ffffffffc0204024 <do_fork+0x1d6>
    if (last_pid >= next_safe)
ffffffffc0203f92:	000be317          	auipc	t1,0xbe
ffffffffc0203f96:	79a30313          	addi	t1,t1,1946 # ffffffffc02c272c <next_safe.0>
ffffffffc0203f9a:	00032783          	lw	a5,0(t1)
ffffffffc0203f9e:	000c3417          	auipc	s0,0xc3
ffffffffc0203fa2:	baa40413          	addi	s0,s0,-1110 # ffffffffc02c6b48 <proc_list>
ffffffffc0203fa6:	08f55763          	bge	a0,a5,ffffffffc0204034 <do_fork+0x1e6>
        goto bad_fork_cleanup_kstack;
    }
    //    4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);
    //    5. insert proc_struct into hash_list && proc_list
    proc->pid = get_pid();
ffffffffc0203faa:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203fac:	45a9                	li	a1,10
ffffffffc0203fae:	2501                	sext.w	a0,a0
ffffffffc0203fb0:	77e010ef          	jal	ra,ffffffffc020572e <hash32>
ffffffffc0203fb4:	02051793          	slli	a5,a0,0x20
ffffffffc0203fb8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0203fbc:	000bf797          	auipc	a5,0xbf
ffffffffc0203fc0:	b8c78793          	addi	a5,a5,-1140 # ffffffffc02c2b48 <hash_list>
ffffffffc0203fc4:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0203fc6:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0203fc8:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203fca:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc0203fce:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0203fd0:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc0203fd2:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0203fd4:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0203fd6:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc0203fda:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc0203fdc:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc0203fde:	e21c                	sd	a5,0(a2)
ffffffffc0203fe0:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0203fe2:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0203fe4:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0203fe6:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0203fea:	10e4b023          	sd	a4,256(s1)
ffffffffc0203fee:	c311                	beqz	a4,ffffffffc0203ff2 <do_fork+0x1a4>
        proc->optr->yptr = proc;
ffffffffc0203ff0:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0203ff2:	00092783          	lw	a5,0(s2)
    hash_proc(proc);
    set_links(proc);
    //    6. call wakeup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
ffffffffc0203ff6:	8526                	mv	a0,s1
    proc->parent->cptr = proc;
ffffffffc0203ff8:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0203ffa:	2785                	addiw	a5,a5,1
ffffffffc0203ffc:	00f92023          	sw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc0204000:	4bc010ef          	jal	ra,ffffffffc02054bc <wakeup_proc>
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
ffffffffc0204004:	40c8                	lw	a0,4(s1)
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
ffffffffc0204006:	70e6                	ld	ra,120(sp)
ffffffffc0204008:	7446                	ld	s0,112(sp)
ffffffffc020400a:	74a6                	ld	s1,104(sp)
ffffffffc020400c:	7906                	ld	s2,96(sp)
ffffffffc020400e:	69e6                	ld	s3,88(sp)
ffffffffc0204010:	6a46                	ld	s4,80(sp)
ffffffffc0204012:	6aa6                	ld	s5,72(sp)
ffffffffc0204014:	6b06                	ld	s6,64(sp)
ffffffffc0204016:	7be2                	ld	s7,56(sp)
ffffffffc0204018:	7c42                	ld	s8,48(sp)
ffffffffc020401a:	7ca2                	ld	s9,40(sp)
ffffffffc020401c:	7d02                	ld	s10,32(sp)
ffffffffc020401e:	6de2                	ld	s11,24(sp)
ffffffffc0204020:	6109                	addi	sp,sp,128
ffffffffc0204022:	8082                	ret
        last_pid = 1;
ffffffffc0204024:	4785                	li	a5,1
ffffffffc0204026:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc020402a:	4505                	li	a0,1
ffffffffc020402c:	000be317          	auipc	t1,0xbe
ffffffffc0204030:	70030313          	addi	t1,t1,1792 # ffffffffc02c272c <next_safe.0>
    return listelm->next;
ffffffffc0204034:	000c3417          	auipc	s0,0xc3
ffffffffc0204038:	b1440413          	addi	s0,s0,-1260 # ffffffffc02c6b48 <proc_list>
ffffffffc020403c:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc0204040:	6789                	lui	a5,0x2
ffffffffc0204042:	00f32023          	sw	a5,0(t1)
ffffffffc0204046:	86aa                	mv	a3,a0
ffffffffc0204048:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc020404a:	6e89                	lui	t4,0x2
ffffffffc020404c:	108e0d63          	beq	t3,s0,ffffffffc0204166 <do_fork+0x318>
ffffffffc0204050:	88ae                	mv	a7,a1
ffffffffc0204052:	87f2                	mv	a5,t3
ffffffffc0204054:	6609                	lui	a2,0x2
ffffffffc0204056:	a811                	j	ffffffffc020406a <do_fork+0x21c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204058:	00e6d663          	bge	a3,a4,ffffffffc0204064 <do_fork+0x216>
ffffffffc020405c:	00c75463          	bge	a4,a2,ffffffffc0204064 <do_fork+0x216>
ffffffffc0204060:	863a                	mv	a2,a4
ffffffffc0204062:	4885                	li	a7,1
ffffffffc0204064:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204066:	00878d63          	beq	a5,s0,ffffffffc0204080 <do_fork+0x232>
            if (proc->pid == last_pid)
ffffffffc020406a:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x8004>
ffffffffc020406e:	fed715e3          	bne	a4,a3,ffffffffc0204058 <do_fork+0x20a>
                if (++last_pid >= next_safe)
ffffffffc0204072:	2685                	addiw	a3,a3,1
ffffffffc0204074:	0ec6d463          	bge	a3,a2,ffffffffc020415c <do_fork+0x30e>
ffffffffc0204078:	679c                	ld	a5,8(a5)
ffffffffc020407a:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020407c:	fe8797e3          	bne	a5,s0,ffffffffc020406a <do_fork+0x21c>
ffffffffc0204080:	c581                	beqz	a1,ffffffffc0204088 <do_fork+0x23a>
ffffffffc0204082:	00d82023          	sw	a3,0(a6)
ffffffffc0204086:	8536                	mv	a0,a3
ffffffffc0204088:	f20881e3          	beqz	a7,ffffffffc0203faa <do_fork+0x15c>
ffffffffc020408c:	00c32023          	sw	a2,0(t1)
ffffffffc0204090:	bf29                	j	ffffffffc0203faa <do_fork+0x15c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204092:	89b6                	mv	s3,a3
ffffffffc0204094:	bdd1                	j	ffffffffc0203f68 <do_fork+0x11a>
    if ((mm = mm_create()) == NULL)
ffffffffc0204096:	d16ff0ef          	jal	ra,ffffffffc02035ac <mm_create>
ffffffffc020409a:	8caa                	mv	s9,a0
ffffffffc020409c:	c159                	beqz	a0,ffffffffc0204122 <do_fork+0x2d4>
    if ((page = alloc_page()) == NULL)
ffffffffc020409e:	4505                	li	a0,1
ffffffffc02040a0:	ce9fd0ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc02040a4:	cd25                	beqz	a0,ffffffffc020411c <do_fork+0x2ce>
    return page - pages + nbase;
ffffffffc02040a6:	000ab683          	ld	a3,0(s5)
ffffffffc02040aa:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc02040ac:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc02040b0:	40d506b3          	sub	a3,a0,a3
ffffffffc02040b4:	8699                	srai	a3,a3,0x6
ffffffffc02040b6:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02040b8:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc02040bc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02040be:	0eedf663          	bgeu	s11,a4,ffffffffc02041aa <do_fork+0x35c>
ffffffffc02040c2:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02040c6:	6605                	lui	a2,0x1
ffffffffc02040c8:	000c3597          	auipc	a1,0xc3
ffffffffc02040cc:	af05b583          	ld	a1,-1296(a1) # ffffffffc02c6bb8 <boot_pgdir_va>
ffffffffc02040d0:	9a36                	add	s4,s4,a3
ffffffffc02040d2:	8552                	mv	a0,s4
ffffffffc02040d4:	313010ef          	jal	ra,ffffffffc0205be6 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc02040d8:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc02040dc:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02040e0:	4785                	li	a5,1
ffffffffc02040e2:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc02040e6:	8b85                	andi	a5,a5,1
ffffffffc02040e8:	4a05                	li	s4,1
ffffffffc02040ea:	c799                	beqz	a5,ffffffffc02040f8 <do_fork+0x2aa>
    {
        schedule();
ffffffffc02040ec:	482010ef          	jal	ra,ffffffffc020556e <schedule>
ffffffffc02040f0:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc02040f4:	8b85                	andi	a5,a5,1
ffffffffc02040f6:	fbfd                	bnez	a5,ffffffffc02040ec <do_fork+0x29e>
        ret = dup_mmap(mm, oldmm);
ffffffffc02040f8:	85ea                	mv	a1,s10
ffffffffc02040fa:	8566                	mv	a0,s9
ffffffffc02040fc:	ef2ff0ef          	jal	ra,ffffffffc02037ee <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204100:	57f9                	li	a5,-2
ffffffffc0204102:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc0204106:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc0204108:	cbad                	beqz	a5,ffffffffc020417a <do_fork+0x32c>
good_mm:
ffffffffc020410a:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc020410c:	de050fe3          	beqz	a0,ffffffffc0203f0a <do_fork+0xbc>
    exit_mmap(mm);
ffffffffc0204110:	8566                	mv	a0,s9
ffffffffc0204112:	f76ff0ef          	jal	ra,ffffffffc0203888 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204116:	8566                	mv	a0,s9
ffffffffc0204118:	c4bff0ef          	jal	ra,ffffffffc0203d62 <put_pgdir>
    mm_destroy(mm);
ffffffffc020411c:	8566                	mv	a0,s9
ffffffffc020411e:	dceff0ef          	jal	ra,ffffffffc02036ec <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204122:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc0204124:	c02007b7          	lui	a5,0xc0200
ffffffffc0204128:	0af6ea63          	bltu	a3,a5,ffffffffc02041dc <do_fork+0x38e>
ffffffffc020412c:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc0204130:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0204134:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204138:	83b1                	srli	a5,a5,0xc
ffffffffc020413a:	04e7fc63          	bgeu	a5,a4,ffffffffc0204192 <do_fork+0x344>
    return &pages[PPN(pa) - nbase];
ffffffffc020413e:	000b3703          	ld	a4,0(s6)
ffffffffc0204142:	000ab503          	ld	a0,0(s5)
ffffffffc0204146:	4589                	li	a1,2
ffffffffc0204148:	8f99                	sub	a5,a5,a4
ffffffffc020414a:	079a                	slli	a5,a5,0x6
ffffffffc020414c:	953e                	add	a0,a0,a5
ffffffffc020414e:	c79fd0ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    kfree(proc);
ffffffffc0204152:	8526                	mv	a0,s1
ffffffffc0204154:	b07fd0ef          	jal	ra,ffffffffc0201c5a <kfree>
    ret = -E_NO_MEM;
ffffffffc0204158:	5571                	li	a0,-4
    return ret;
ffffffffc020415a:	b575                	j	ffffffffc0204006 <do_fork+0x1b8>
                    if (last_pid >= MAX_PID)
ffffffffc020415c:	01d6c363          	blt	a3,t4,ffffffffc0204162 <do_fork+0x314>
                        last_pid = 1;
ffffffffc0204160:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204162:	4585                	li	a1,1
ffffffffc0204164:	b5e5                	j	ffffffffc020404c <do_fork+0x1fe>
ffffffffc0204166:	c599                	beqz	a1,ffffffffc0204174 <do_fork+0x326>
ffffffffc0204168:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020416c:	8536                	mv	a0,a3
ffffffffc020416e:	bd35                	j	ffffffffc0203faa <do_fork+0x15c>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204170:	556d                	li	a0,-5
ffffffffc0204172:	bd51                	j	ffffffffc0204006 <do_fork+0x1b8>
    return last_pid;
ffffffffc0204174:	00082503          	lw	a0,0(a6)
ffffffffc0204178:	bd0d                	j	ffffffffc0203faa <do_fork+0x15c>
    {
        panic("Unlock failed.\n");
ffffffffc020417a:	00003617          	auipc	a2,0x3
ffffffffc020417e:	2be60613          	addi	a2,a2,702 # ffffffffc0207438 <default_pmm_manager+0xa08>
ffffffffc0204182:	04000593          	li	a1,64
ffffffffc0204186:	00003517          	auipc	a0,0x3
ffffffffc020418a:	2c250513          	addi	a0,a0,706 # ffffffffc0207448 <default_pmm_manager+0xa18>
ffffffffc020418e:	b04fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204192:	00003617          	auipc	a2,0x3
ffffffffc0204196:	9a660613          	addi	a2,a2,-1626 # ffffffffc0206b38 <default_pmm_manager+0x108>
ffffffffc020419a:	06900593          	li	a1,105
ffffffffc020419e:	00003517          	auipc	a0,0x3
ffffffffc02041a2:	8f250513          	addi	a0,a0,-1806 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc02041a6:	aecfc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc02041aa:	00003617          	auipc	a2,0x3
ffffffffc02041ae:	8be60613          	addi	a2,a2,-1858 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc02041b2:	07100593          	li	a1,113
ffffffffc02041b6:	00003517          	auipc	a0,0x3
ffffffffc02041ba:	8da50513          	addi	a0,a0,-1830 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc02041be:	ad4fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02041c2:	86be                	mv	a3,a5
ffffffffc02041c4:	00003617          	auipc	a2,0x3
ffffffffc02041c8:	94c60613          	addi	a2,a2,-1716 # ffffffffc0206b10 <default_pmm_manager+0xe0>
ffffffffc02041cc:	1a700593          	li	a1,423
ffffffffc02041d0:	00003517          	auipc	a0,0x3
ffffffffc02041d4:	29050513          	addi	a0,a0,656 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc02041d8:	abafc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02041dc:	00003617          	auipc	a2,0x3
ffffffffc02041e0:	93460613          	addi	a2,a2,-1740 # ffffffffc0206b10 <default_pmm_manager+0xe0>
ffffffffc02041e4:	07700593          	li	a1,119
ffffffffc02041e8:	00003517          	auipc	a0,0x3
ffffffffc02041ec:	8a850513          	addi	a0,a0,-1880 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc02041f0:	aa2fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02041f4 <kernel_thread>:
{
ffffffffc02041f4:	7129                	addi	sp,sp,-320
ffffffffc02041f6:	fa22                	sd	s0,304(sp)
ffffffffc02041f8:	f626                	sd	s1,296(sp)
ffffffffc02041fa:	f24a                	sd	s2,288(sp)
ffffffffc02041fc:	84ae                	mv	s1,a1
ffffffffc02041fe:	892a                	mv	s2,a0
ffffffffc0204200:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204202:	4581                	li	a1,0
ffffffffc0204204:	12000613          	li	a2,288
ffffffffc0204208:	850a                	mv	a0,sp
{
ffffffffc020420a:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020420c:	1c9010ef          	jal	ra,ffffffffc0205bd4 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0204210:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204212:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204214:	100027f3          	csrr	a5,sstatus
ffffffffc0204218:	edd7f793          	andi	a5,a5,-291
ffffffffc020421c:	1207e793          	ori	a5,a5,288
ffffffffc0204220:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204222:	860a                	mv	a2,sp
ffffffffc0204224:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204228:	00000797          	auipc	a5,0x0
ffffffffc020422c:	a8e78793          	addi	a5,a5,-1394 # ffffffffc0203cb6 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204230:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204232:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204234:	c1bff0ef          	jal	ra,ffffffffc0203e4e <do_fork>
}
ffffffffc0204238:	70f2                	ld	ra,312(sp)
ffffffffc020423a:	7452                	ld	s0,304(sp)
ffffffffc020423c:	74b2                	ld	s1,296(sp)
ffffffffc020423e:	7912                	ld	s2,288(sp)
ffffffffc0204240:	6131                	addi	sp,sp,320
ffffffffc0204242:	8082                	ret

ffffffffc0204244 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int do_exit(int error_code)
{
ffffffffc0204244:	7179                	addi	sp,sp,-48
ffffffffc0204246:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204248:	000c3417          	auipc	s0,0xc3
ffffffffc020424c:	99840413          	addi	s0,s0,-1640 # ffffffffc02c6be0 <current>
ffffffffc0204250:	601c                	ld	a5,0(s0)
{
ffffffffc0204252:	f406                	sd	ra,40(sp)
ffffffffc0204254:	ec26                	sd	s1,24(sp)
ffffffffc0204256:	e84a                	sd	s2,16(sp)
ffffffffc0204258:	e44e                	sd	s3,8(sp)
ffffffffc020425a:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc020425c:	000c3717          	auipc	a4,0xc3
ffffffffc0204260:	98c73703          	ld	a4,-1652(a4) # ffffffffc02c6be8 <idleproc>
ffffffffc0204264:	0ce78c63          	beq	a5,a4,ffffffffc020433c <do_exit+0xf8>
    {
        panic("idleproc exit.\n");
    }
    if (current == initproc)
ffffffffc0204268:	000c3497          	auipc	s1,0xc3
ffffffffc020426c:	98848493          	addi	s1,s1,-1656 # ffffffffc02c6bf0 <initproc>
ffffffffc0204270:	6098                	ld	a4,0(s1)
ffffffffc0204272:	0ee78b63          	beq	a5,a4,ffffffffc0204368 <do_exit+0x124>
    {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
ffffffffc0204276:	0287b983          	ld	s3,40(a5)
ffffffffc020427a:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc020427c:	02098663          	beqz	s3,ffffffffc02042a8 <do_exit+0x64>
ffffffffc0204280:	000c3797          	auipc	a5,0xc3
ffffffffc0204284:	9307b783          	ld	a5,-1744(a5) # ffffffffc02c6bb0 <boot_pgdir_pa>
ffffffffc0204288:	577d                	li	a4,-1
ffffffffc020428a:	177e                	slli	a4,a4,0x3f
ffffffffc020428c:	83b1                	srli	a5,a5,0xc
ffffffffc020428e:	8fd9                	or	a5,a5,a4
ffffffffc0204290:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204294:	0309a783          	lw	a5,48(s3)
ffffffffc0204298:	fff7871b          	addiw	a4,a5,-1
ffffffffc020429c:	02e9a823          	sw	a4,48(s3)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
ffffffffc02042a0:	cb55                	beqz	a4,ffffffffc0204354 <do_exit+0x110>
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
ffffffffc02042a2:	601c                	ld	a5,0(s0)
ffffffffc02042a4:	0207b423          	sd	zero,40(a5)
    }
    current->state = PROC_ZOMBIE;
ffffffffc02042a8:	601c                	ld	a5,0(s0)
ffffffffc02042aa:	470d                	li	a4,3
ffffffffc02042ac:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc02042ae:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02042b2:	100027f3          	csrr	a5,sstatus
ffffffffc02042b6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02042b8:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02042ba:	e3f9                	bnez	a5,ffffffffc0204380 <do_exit+0x13c>
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
ffffffffc02042bc:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02042be:	800007b7          	lui	a5,0x80000
ffffffffc02042c2:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc02042c4:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc02042c6:	0ec52703          	lw	a4,236(a0)
ffffffffc02042ca:	0af70f63          	beq	a4,a5,ffffffffc0204388 <do_exit+0x144>
        {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL)
ffffffffc02042ce:	6018                	ld	a4,0(s0)
ffffffffc02042d0:	7b7c                	ld	a5,240(a4)
ffffffffc02042d2:	c3a1                	beqz	a5,ffffffffc0204312 <do_exit+0xce>
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE)
            {
                if (initproc->wait_state == WT_CHILD)
ffffffffc02042d4:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02042d8:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02042da:	0985                	addi	s3,s3,1
ffffffffc02042dc:	a021                	j	ffffffffc02042e4 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02042de:	6018                	ld	a4,0(s0)
ffffffffc02042e0:	7b7c                	ld	a5,240(a4)
ffffffffc02042e2:	cb85                	beqz	a5,ffffffffc0204312 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02042e4:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_matrix_out_size+0xffffffff7fff39f0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02042e8:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02042ea:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02042ec:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02042ee:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02042f2:	10e7b023          	sd	a4,256(a5)
ffffffffc02042f6:	c311                	beqz	a4,ffffffffc02042fa <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02042f8:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02042fa:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02042fc:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02042fe:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204300:	fd271fe3          	bne	a4,s2,ffffffffc02042de <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204304:	0ec52783          	lw	a5,236(a0)
ffffffffc0204308:	fd379be3          	bne	a5,s3,ffffffffc02042de <do_exit+0x9a>
                {
                    wakeup_proc(initproc);
ffffffffc020430c:	1b0010ef          	jal	ra,ffffffffc02054bc <wakeup_proc>
ffffffffc0204310:	b7f9                	j	ffffffffc02042de <do_exit+0x9a>
    if (flag)
ffffffffc0204312:	020a1263          	bnez	s4,ffffffffc0204336 <do_exit+0xf2>
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
ffffffffc0204316:	258010ef          	jal	ra,ffffffffc020556e <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc020431a:	601c                	ld	a5,0(s0)
ffffffffc020431c:	00003617          	auipc	a2,0x3
ffffffffc0204320:	17c60613          	addi	a2,a2,380 # ffffffffc0207498 <default_pmm_manager+0xa68>
ffffffffc0204324:	24e00593          	li	a1,590
ffffffffc0204328:	43d4                	lw	a3,4(a5)
ffffffffc020432a:	00003517          	auipc	a0,0x3
ffffffffc020432e:	13650513          	addi	a0,a0,310 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204332:	960fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        intr_enable();
ffffffffc0204336:	e72fc0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020433a:	bff1                	j	ffffffffc0204316 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc020433c:	00003617          	auipc	a2,0x3
ffffffffc0204340:	13c60613          	addi	a2,a2,316 # ffffffffc0207478 <default_pmm_manager+0xa48>
ffffffffc0204344:	21a00593          	li	a1,538
ffffffffc0204348:	00003517          	auipc	a0,0x3
ffffffffc020434c:	11850513          	addi	a0,a0,280 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204350:	942fc0ef          	jal	ra,ffffffffc0200492 <__panic>
            exit_mmap(mm);
ffffffffc0204354:	854e                	mv	a0,s3
ffffffffc0204356:	d32ff0ef          	jal	ra,ffffffffc0203888 <exit_mmap>
            put_pgdir(mm);
ffffffffc020435a:	854e                	mv	a0,s3
ffffffffc020435c:	a07ff0ef          	jal	ra,ffffffffc0203d62 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204360:	854e                	mv	a0,s3
ffffffffc0204362:	b8aff0ef          	jal	ra,ffffffffc02036ec <mm_destroy>
ffffffffc0204366:	bf35                	j	ffffffffc02042a2 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204368:	00003617          	auipc	a2,0x3
ffffffffc020436c:	12060613          	addi	a2,a2,288 # ffffffffc0207488 <default_pmm_manager+0xa58>
ffffffffc0204370:	21e00593          	li	a1,542
ffffffffc0204374:	00003517          	auipc	a0,0x3
ffffffffc0204378:	0ec50513          	addi	a0,a0,236 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc020437c:	916fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        intr_disable();
ffffffffc0204380:	e2efc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0204384:	4a05                	li	s4,1
ffffffffc0204386:	bf1d                	j	ffffffffc02042bc <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204388:	134010ef          	jal	ra,ffffffffc02054bc <wakeup_proc>
ffffffffc020438c:	b789                	j	ffffffffc02042ce <do_exit+0x8a>

ffffffffc020438e <do_wait.part.0>:
}

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int do_wait(int pid, int *code_store)
ffffffffc020438e:	715d                	addi	sp,sp,-80
ffffffffc0204390:	f84a                	sd	s2,48(sp)
ffffffffc0204392:	f44e                	sd	s3,40(sp)
        }
    }
    if (haskid)
    {
        current->state = PROC_SLEEPING;
        current->wait_state = WT_CHILD;
ffffffffc0204394:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204398:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc020439a:	fc26                	sd	s1,56(sp)
ffffffffc020439c:	f052                	sd	s4,32(sp)
ffffffffc020439e:	ec56                	sd	s5,24(sp)
ffffffffc02043a0:	e85a                	sd	s6,16(sp)
ffffffffc02043a2:	e45e                	sd	s7,8(sp)
ffffffffc02043a4:	e486                	sd	ra,72(sp)
ffffffffc02043a6:	e0a2                	sd	s0,64(sp)
ffffffffc02043a8:	84aa                	mv	s1,a0
ffffffffc02043aa:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc02043ac:	000c3b97          	auipc	s7,0xc3
ffffffffc02043b0:	834b8b93          	addi	s7,s7,-1996 # ffffffffc02c6be0 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc02043b4:	00050b1b          	sext.w	s6,a0
ffffffffc02043b8:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02043bc:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc02043be:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc02043c0:	ccbd                	beqz	s1,ffffffffc020443e <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc02043c2:	0359e863          	bltu	s3,s5,ffffffffc02043f2 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02043c6:	45a9                	li	a1,10
ffffffffc02043c8:	855a                	mv	a0,s6
ffffffffc02043ca:	364010ef          	jal	ra,ffffffffc020572e <hash32>
ffffffffc02043ce:	02051793          	slli	a5,a0,0x20
ffffffffc02043d2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02043d6:	000be797          	auipc	a5,0xbe
ffffffffc02043da:	77278793          	addi	a5,a5,1906 # ffffffffc02c2b48 <hash_list>
ffffffffc02043de:	953e                	add	a0,a0,a5
ffffffffc02043e0:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02043e2:	a029                	j	ffffffffc02043ec <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02043e4:	f2c42783          	lw	a5,-212(s0)
ffffffffc02043e8:	02978163          	beq	a5,s1,ffffffffc020440a <do_wait.part.0+0x7c>
ffffffffc02043ec:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02043ee:	fe851be3          	bne	a0,s0,ffffffffc02043e4 <do_wait.part.0+0x56>
        {
            do_exit(-E_KILLED);
        }
        goto repeat;
    }
    return -E_BAD_PROC;
ffffffffc02043f2:	5579                	li	a0,-2
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
    return 0;
}
ffffffffc02043f4:	60a6                	ld	ra,72(sp)
ffffffffc02043f6:	6406                	ld	s0,64(sp)
ffffffffc02043f8:	74e2                	ld	s1,56(sp)
ffffffffc02043fa:	7942                	ld	s2,48(sp)
ffffffffc02043fc:	79a2                	ld	s3,40(sp)
ffffffffc02043fe:	7a02                	ld	s4,32(sp)
ffffffffc0204400:	6ae2                	ld	s5,24(sp)
ffffffffc0204402:	6b42                	ld	s6,16(sp)
ffffffffc0204404:	6ba2                	ld	s7,8(sp)
ffffffffc0204406:	6161                	addi	sp,sp,80
ffffffffc0204408:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc020440a:	000bb683          	ld	a3,0(s7)
ffffffffc020440e:	f4843783          	ld	a5,-184(s0)
ffffffffc0204412:	fed790e3          	bne	a5,a3,ffffffffc02043f2 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204416:	f2842703          	lw	a4,-216(s0)
ffffffffc020441a:	478d                	li	a5,3
ffffffffc020441c:	0ef70b63          	beq	a4,a5,ffffffffc0204512 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc0204420:	4785                	li	a5,1
ffffffffc0204422:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0204424:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc0204428:	146010ef          	jal	ra,ffffffffc020556e <schedule>
        if (current->flags & PF_EXITING)
ffffffffc020442c:	000bb783          	ld	a5,0(s7)
ffffffffc0204430:	0b07a783          	lw	a5,176(a5)
ffffffffc0204434:	8b85                	andi	a5,a5,1
ffffffffc0204436:	d7c9                	beqz	a5,ffffffffc02043c0 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204438:	555d                	li	a0,-9
ffffffffc020443a:	e0bff0ef          	jal	ra,ffffffffc0204244 <do_exit>
        proc = current->cptr;
ffffffffc020443e:	000bb683          	ld	a3,0(s7)
ffffffffc0204442:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204444:	d45d                	beqz	s0,ffffffffc02043f2 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204446:	470d                	li	a4,3
ffffffffc0204448:	a021                	j	ffffffffc0204450 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc020444a:	10043403          	ld	s0,256(s0)
ffffffffc020444e:	d869                	beqz	s0,ffffffffc0204420 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204450:	401c                	lw	a5,0(s0)
ffffffffc0204452:	fee79ce3          	bne	a5,a4,ffffffffc020444a <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204456:	000c2797          	auipc	a5,0xc2
ffffffffc020445a:	7927b783          	ld	a5,1938(a5) # ffffffffc02c6be8 <idleproc>
ffffffffc020445e:	0c878963          	beq	a5,s0,ffffffffc0204530 <do_wait.part.0+0x1a2>
ffffffffc0204462:	000c2797          	auipc	a5,0xc2
ffffffffc0204466:	78e7b783          	ld	a5,1934(a5) # ffffffffc02c6bf0 <initproc>
ffffffffc020446a:	0cf40363          	beq	s0,a5,ffffffffc0204530 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc020446e:	000a0663          	beqz	s4,ffffffffc020447a <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204472:	0e842783          	lw	a5,232(s0)
ffffffffc0204476:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f40>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020447a:	100027f3          	csrr	a5,sstatus
ffffffffc020447e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204480:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204482:	e7c1                	bnez	a5,ffffffffc020450a <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204484:	6c70                	ld	a2,216(s0)
ffffffffc0204486:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204488:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc020448c:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc020448e:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204490:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204492:	6470                	ld	a2,200(s0)
ffffffffc0204494:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204496:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204498:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc020449a:	c319                	beqz	a4,ffffffffc02044a0 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc020449c:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc020449e:	7c7c                	ld	a5,248(s0)
ffffffffc02044a0:	c3b5                	beqz	a5,ffffffffc0204504 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc02044a2:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc02044a6:	000c2717          	auipc	a4,0xc2
ffffffffc02044aa:	75270713          	addi	a4,a4,1874 # ffffffffc02c6bf8 <nr_process>
ffffffffc02044ae:	431c                	lw	a5,0(a4)
ffffffffc02044b0:	37fd                	addiw	a5,a5,-1
ffffffffc02044b2:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc02044b4:	e5a9                	bnez	a1,ffffffffc02044fe <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02044b6:	6814                	ld	a3,16(s0)
ffffffffc02044b8:	c02007b7          	lui	a5,0xc0200
ffffffffc02044bc:	04f6ee63          	bltu	a3,a5,ffffffffc0204518 <do_wait.part.0+0x18a>
ffffffffc02044c0:	000c2797          	auipc	a5,0xc2
ffffffffc02044c4:	7187b783          	ld	a5,1816(a5) # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc02044c8:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02044ca:	82b1                	srli	a3,a3,0xc
ffffffffc02044cc:	000c2797          	auipc	a5,0xc2
ffffffffc02044d0:	6f47b783          	ld	a5,1780(a5) # ffffffffc02c6bc0 <npage>
ffffffffc02044d4:	06f6fa63          	bgeu	a3,a5,ffffffffc0204548 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02044d8:	00004517          	auipc	a0,0x4
ffffffffc02044dc:	f9853503          	ld	a0,-104(a0) # ffffffffc0208470 <nbase>
ffffffffc02044e0:	8e89                	sub	a3,a3,a0
ffffffffc02044e2:	069a                	slli	a3,a3,0x6
ffffffffc02044e4:	000c2517          	auipc	a0,0xc2
ffffffffc02044e8:	6e453503          	ld	a0,1764(a0) # ffffffffc02c6bc8 <pages>
ffffffffc02044ec:	9536                	add	a0,a0,a3
ffffffffc02044ee:	4589                	li	a1,2
ffffffffc02044f0:	8d7fd0ef          	jal	ra,ffffffffc0201dc6 <free_pages>
    kfree(proc);
ffffffffc02044f4:	8522                	mv	a0,s0
ffffffffc02044f6:	f64fd0ef          	jal	ra,ffffffffc0201c5a <kfree>
    return 0;
ffffffffc02044fa:	4501                	li	a0,0
ffffffffc02044fc:	bde5                	j	ffffffffc02043f4 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02044fe:	caafc0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0204502:	bf55                	j	ffffffffc02044b6 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc0204504:	701c                	ld	a5,32(s0)
ffffffffc0204506:	fbf8                	sd	a4,240(a5)
ffffffffc0204508:	bf79                	j	ffffffffc02044a6 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc020450a:	ca4fc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc020450e:	4585                	li	a1,1
ffffffffc0204510:	bf95                	j	ffffffffc0204484 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204512:	f2840413          	addi	s0,s0,-216
ffffffffc0204516:	b781                	j	ffffffffc0204456 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc0204518:	00002617          	auipc	a2,0x2
ffffffffc020451c:	5f860613          	addi	a2,a2,1528 # ffffffffc0206b10 <default_pmm_manager+0xe0>
ffffffffc0204520:	07700593          	li	a1,119
ffffffffc0204524:	00002517          	auipc	a0,0x2
ffffffffc0204528:	56c50513          	addi	a0,a0,1388 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc020452c:	f67fb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0204530:	00003617          	auipc	a2,0x3
ffffffffc0204534:	f8860613          	addi	a2,a2,-120 # ffffffffc02074b8 <default_pmm_manager+0xa88>
ffffffffc0204538:	37300593          	li	a1,883
ffffffffc020453c:	00003517          	auipc	a0,0x3
ffffffffc0204540:	f2450513          	addi	a0,a0,-220 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204544:	f4ffb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204548:	00002617          	auipc	a2,0x2
ffffffffc020454c:	5f060613          	addi	a2,a2,1520 # ffffffffc0206b38 <default_pmm_manager+0x108>
ffffffffc0204550:	06900593          	li	a1,105
ffffffffc0204554:	00002517          	auipc	a0,0x2
ffffffffc0204558:	53c50513          	addi	a0,a0,1340 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc020455c:	f37fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204560 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204560:	1141                	addi	sp,sp,-16
ffffffffc0204562:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204564:	8a3fd0ef          	jal	ra,ffffffffc0201e06 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204568:	e3efd0ef          	jal	ra,ffffffffc0201ba6 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc020456c:	4601                	li	a2,0
ffffffffc020456e:	4581                	li	a1,0
ffffffffc0204570:	00000517          	auipc	a0,0x0
ffffffffc0204574:	62850513          	addi	a0,a0,1576 # ffffffffc0204b98 <user_main>
ffffffffc0204578:	c7dff0ef          	jal	ra,ffffffffc02041f4 <kernel_thread>
    if (pid <= 0)
ffffffffc020457c:	00a04563          	bgtz	a0,ffffffffc0204586 <init_main+0x26>
ffffffffc0204580:	a071                	j	ffffffffc020460c <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204582:	7ed000ef          	jal	ra,ffffffffc020556e <schedule>
    if (code_store != NULL)
ffffffffc0204586:	4581                	li	a1,0
ffffffffc0204588:	4501                	li	a0,0
ffffffffc020458a:	e05ff0ef          	jal	ra,ffffffffc020438e <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc020458e:	d975                	beqz	a0,ffffffffc0204582 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204590:	00003517          	auipc	a0,0x3
ffffffffc0204594:	f6850513          	addi	a0,a0,-152 # ffffffffc02074f8 <default_pmm_manager+0xac8>
ffffffffc0204598:	c01fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020459c:	000c2797          	auipc	a5,0xc2
ffffffffc02045a0:	6547b783          	ld	a5,1620(a5) # ffffffffc02c6bf0 <initproc>
ffffffffc02045a4:	7bf8                	ld	a4,240(a5)
ffffffffc02045a6:	e339                	bnez	a4,ffffffffc02045ec <init_main+0x8c>
ffffffffc02045a8:	7ff8                	ld	a4,248(a5)
ffffffffc02045aa:	e329                	bnez	a4,ffffffffc02045ec <init_main+0x8c>
ffffffffc02045ac:	1007b703          	ld	a4,256(a5)
ffffffffc02045b0:	ef15                	bnez	a4,ffffffffc02045ec <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc02045b2:	000c2697          	auipc	a3,0xc2
ffffffffc02045b6:	6466a683          	lw	a3,1606(a3) # ffffffffc02c6bf8 <nr_process>
ffffffffc02045ba:	4709                	li	a4,2
ffffffffc02045bc:	0ae69463          	bne	a3,a4,ffffffffc0204664 <init_main+0x104>
    return listelm->next;
ffffffffc02045c0:	000c2697          	auipc	a3,0xc2
ffffffffc02045c4:	58868693          	addi	a3,a3,1416 # ffffffffc02c6b48 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02045c8:	6698                	ld	a4,8(a3)
ffffffffc02045ca:	0c878793          	addi	a5,a5,200
ffffffffc02045ce:	06f71b63          	bne	a4,a5,ffffffffc0204644 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02045d2:	629c                	ld	a5,0(a3)
ffffffffc02045d4:	04f71863          	bne	a4,a5,ffffffffc0204624 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02045d8:	00003517          	auipc	a0,0x3
ffffffffc02045dc:	00850513          	addi	a0,a0,8 # ffffffffc02075e0 <default_pmm_manager+0xbb0>
ffffffffc02045e0:	bb9fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return 0;
}
ffffffffc02045e4:	60a2                	ld	ra,8(sp)
ffffffffc02045e6:	4501                	li	a0,0
ffffffffc02045e8:	0141                	addi	sp,sp,16
ffffffffc02045ea:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02045ec:	00003697          	auipc	a3,0x3
ffffffffc02045f0:	f3468693          	addi	a3,a3,-204 # ffffffffc0207520 <default_pmm_manager+0xaf0>
ffffffffc02045f4:	00002617          	auipc	a2,0x2
ffffffffc02045f8:	08c60613          	addi	a2,a2,140 # ffffffffc0206680 <commands+0x818>
ffffffffc02045fc:	3df00593          	li	a1,991
ffffffffc0204600:	00003517          	auipc	a0,0x3
ffffffffc0204604:	e6050513          	addi	a0,a0,-416 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204608:	e8bfb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("create user_main failed.\n");
ffffffffc020460c:	00003617          	auipc	a2,0x3
ffffffffc0204610:	ecc60613          	addi	a2,a2,-308 # ffffffffc02074d8 <default_pmm_manager+0xaa8>
ffffffffc0204614:	3d600593          	li	a1,982
ffffffffc0204618:	00003517          	auipc	a0,0x3
ffffffffc020461c:	e4850513          	addi	a0,a0,-440 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204620:	e73fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204624:	00003697          	auipc	a3,0x3
ffffffffc0204628:	f8c68693          	addi	a3,a3,-116 # ffffffffc02075b0 <default_pmm_manager+0xb80>
ffffffffc020462c:	00002617          	auipc	a2,0x2
ffffffffc0204630:	05460613          	addi	a2,a2,84 # ffffffffc0206680 <commands+0x818>
ffffffffc0204634:	3e200593          	li	a1,994
ffffffffc0204638:	00003517          	auipc	a0,0x3
ffffffffc020463c:	e2850513          	addi	a0,a0,-472 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204640:	e53fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204644:	00003697          	auipc	a3,0x3
ffffffffc0204648:	f3c68693          	addi	a3,a3,-196 # ffffffffc0207580 <default_pmm_manager+0xb50>
ffffffffc020464c:	00002617          	auipc	a2,0x2
ffffffffc0204650:	03460613          	addi	a2,a2,52 # ffffffffc0206680 <commands+0x818>
ffffffffc0204654:	3e100593          	li	a1,993
ffffffffc0204658:	00003517          	auipc	a0,0x3
ffffffffc020465c:	e0850513          	addi	a0,a0,-504 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204660:	e33fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_process == 2);
ffffffffc0204664:	00003697          	auipc	a3,0x3
ffffffffc0204668:	f0c68693          	addi	a3,a3,-244 # ffffffffc0207570 <default_pmm_manager+0xb40>
ffffffffc020466c:	00002617          	auipc	a2,0x2
ffffffffc0204670:	01460613          	addi	a2,a2,20 # ffffffffc0206680 <commands+0x818>
ffffffffc0204674:	3e000593          	li	a1,992
ffffffffc0204678:	00003517          	auipc	a0,0x3
ffffffffc020467c:	de850513          	addi	a0,a0,-536 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204680:	e13fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204684 <do_execve>:
{
ffffffffc0204684:	7171                	addi	sp,sp,-176
ffffffffc0204686:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204688:	000c2d97          	auipc	s11,0xc2
ffffffffc020468c:	558d8d93          	addi	s11,s11,1368 # ffffffffc02c6be0 <current>
ffffffffc0204690:	000db783          	ld	a5,0(s11)
{
ffffffffc0204694:	e54e                	sd	s3,136(sp)
ffffffffc0204696:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204698:	0287b983          	ld	s3,40(a5)
{
ffffffffc020469c:	e94a                	sd	s2,144(sp)
ffffffffc020469e:	f4de                	sd	s7,104(sp)
ffffffffc02046a0:	892a                	mv	s2,a0
ffffffffc02046a2:	8bb2                	mv	s7,a2
ffffffffc02046a4:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02046a6:	862e                	mv	a2,a1
ffffffffc02046a8:	4681                	li	a3,0
ffffffffc02046aa:	85aa                	mv	a1,a0
ffffffffc02046ac:	854e                	mv	a0,s3
{
ffffffffc02046ae:	f506                	sd	ra,168(sp)
ffffffffc02046b0:	f122                	sd	s0,160(sp)
ffffffffc02046b2:	e152                	sd	s4,128(sp)
ffffffffc02046b4:	fcd6                	sd	s5,120(sp)
ffffffffc02046b6:	f8da                	sd	s6,112(sp)
ffffffffc02046b8:	f0e2                	sd	s8,96(sp)
ffffffffc02046ba:	ece6                	sd	s9,88(sp)
ffffffffc02046bc:	e8ea                	sd	s10,80(sp)
ffffffffc02046be:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02046c0:	d62ff0ef          	jal	ra,ffffffffc0203c22 <user_mem_check>
ffffffffc02046c4:	40050a63          	beqz	a0,ffffffffc0204ad8 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02046c8:	4641                	li	a2,16
ffffffffc02046ca:	4581                	li	a1,0
ffffffffc02046cc:	1808                	addi	a0,sp,48
ffffffffc02046ce:	506010ef          	jal	ra,ffffffffc0205bd4 <memset>
    memcpy(local_name, name, len);
ffffffffc02046d2:	47bd                	li	a5,15
ffffffffc02046d4:	8626                	mv	a2,s1
ffffffffc02046d6:	1e97e263          	bltu	a5,s1,ffffffffc02048ba <do_execve+0x236>
ffffffffc02046da:	85ca                	mv	a1,s2
ffffffffc02046dc:	1808                	addi	a0,sp,48
ffffffffc02046de:	508010ef          	jal	ra,ffffffffc0205be6 <memcpy>
    if (mm != NULL)
ffffffffc02046e2:	1e098363          	beqz	s3,ffffffffc02048c8 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc02046e6:	00003517          	auipc	a0,0x3
ffffffffc02046ea:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0207260 <default_pmm_manager+0x830>
ffffffffc02046ee:	ae3fb0ef          	jal	ra,ffffffffc02001d0 <cputs>
ffffffffc02046f2:	000c2797          	auipc	a5,0xc2
ffffffffc02046f6:	4be7b783          	ld	a5,1214(a5) # ffffffffc02c6bb0 <boot_pgdir_pa>
ffffffffc02046fa:	577d                	li	a4,-1
ffffffffc02046fc:	177e                	slli	a4,a4,0x3f
ffffffffc02046fe:	83b1                	srli	a5,a5,0xc
ffffffffc0204700:	8fd9                	or	a5,a5,a4
ffffffffc0204702:	18079073          	csrw	satp,a5
ffffffffc0204706:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7f10>
ffffffffc020470a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020470e:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204712:	2c070463          	beqz	a4,ffffffffc02049da <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204716:	000db783          	ld	a5,0(s11)
ffffffffc020471a:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc020471e:	e8ffe0ef          	jal	ra,ffffffffc02035ac <mm_create>
ffffffffc0204722:	84aa                	mv	s1,a0
ffffffffc0204724:	1c050d63          	beqz	a0,ffffffffc02048fe <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204728:	4505                	li	a0,1
ffffffffc020472a:	e5efd0ef          	jal	ra,ffffffffc0201d88 <alloc_pages>
ffffffffc020472e:	3a050963          	beqz	a0,ffffffffc0204ae0 <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc0204732:	000c2c97          	auipc	s9,0xc2
ffffffffc0204736:	496c8c93          	addi	s9,s9,1174 # ffffffffc02c6bc8 <pages>
ffffffffc020473a:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc020473e:	000c2c17          	auipc	s8,0xc2
ffffffffc0204742:	482c0c13          	addi	s8,s8,1154 # ffffffffc02c6bc0 <npage>
    return page - pages + nbase;
ffffffffc0204746:	00004717          	auipc	a4,0x4
ffffffffc020474a:	d2a73703          	ld	a4,-726(a4) # ffffffffc0208470 <nbase>
ffffffffc020474e:	40d506b3          	sub	a3,a0,a3
ffffffffc0204752:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204754:	5afd                	li	s5,-1
ffffffffc0204756:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc020475a:	96ba                	add	a3,a3,a4
ffffffffc020475c:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc020475e:	00cad713          	srli	a4,s5,0xc
ffffffffc0204762:	ec3a                	sd	a4,24(sp)
ffffffffc0204764:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204766:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204768:	38f77063          	bgeu	a4,a5,ffffffffc0204ae8 <do_execve+0x464>
ffffffffc020476c:	000c2b17          	auipc	s6,0xc2
ffffffffc0204770:	46cb0b13          	addi	s6,s6,1132 # ffffffffc02c6bd8 <va_pa_offset>
ffffffffc0204774:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204778:	6605                	lui	a2,0x1
ffffffffc020477a:	000c2597          	auipc	a1,0xc2
ffffffffc020477e:	43e5b583          	ld	a1,1086(a1) # ffffffffc02c6bb8 <boot_pgdir_va>
ffffffffc0204782:	9936                	add	s2,s2,a3
ffffffffc0204784:	854a                	mv	a0,s2
ffffffffc0204786:	460010ef          	jal	ra,ffffffffc0205be6 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc020478a:	7782                	ld	a5,32(sp)
ffffffffc020478c:	4398                	lw	a4,0(a5)
ffffffffc020478e:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204792:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204796:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_matrix_out_size+0x464b7e6f>
ffffffffc020479a:	14f71863          	bne	a4,a5,ffffffffc02048ea <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020479e:	7682                	ld	a3,32(sp)
ffffffffc02047a0:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02047a4:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02047a8:	00371793          	slli	a5,a4,0x3
ffffffffc02047ac:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02047ae:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02047b0:	078e                	slli	a5,a5,0x3
ffffffffc02047b2:	97ce                	add	a5,a5,s3
ffffffffc02047b4:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc02047b6:	00f9fc63          	bgeu	s3,a5,ffffffffc02047ce <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc02047ba:	0009a783          	lw	a5,0(s3)
ffffffffc02047be:	4705                	li	a4,1
ffffffffc02047c0:	14e78163          	beq	a5,a4,ffffffffc0204902 <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc02047c4:	77a2                	ld	a5,40(sp)
ffffffffc02047c6:	03898993          	addi	s3,s3,56
ffffffffc02047ca:	fef9e8e3          	bltu	s3,a5,ffffffffc02047ba <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc02047ce:	4701                	li	a4,0
ffffffffc02047d0:	46ad                	li	a3,11
ffffffffc02047d2:	00100637          	lui	a2,0x100
ffffffffc02047d6:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02047da:	8526                	mv	a0,s1
ffffffffc02047dc:	f63fe0ef          	jal	ra,ffffffffc020373e <mm_map>
ffffffffc02047e0:	8a2a                	mv	s4,a0
ffffffffc02047e2:	1e051263          	bnez	a0,ffffffffc02049c6 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02047e6:	6c88                	ld	a0,24(s1)
ffffffffc02047e8:	467d                	li	a2,31
ffffffffc02047ea:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02047ee:	cd9fe0ef          	jal	ra,ffffffffc02034c6 <pgdir_alloc_page>
ffffffffc02047f2:	38050363          	beqz	a0,ffffffffc0204b78 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02047f6:	6c88                	ld	a0,24(s1)
ffffffffc02047f8:	467d                	li	a2,31
ffffffffc02047fa:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02047fe:	cc9fe0ef          	jal	ra,ffffffffc02034c6 <pgdir_alloc_page>
ffffffffc0204802:	34050b63          	beqz	a0,ffffffffc0204b58 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204806:	6c88                	ld	a0,24(s1)
ffffffffc0204808:	467d                	li	a2,31
ffffffffc020480a:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc020480e:	cb9fe0ef          	jal	ra,ffffffffc02034c6 <pgdir_alloc_page>
ffffffffc0204812:	32050363          	beqz	a0,ffffffffc0204b38 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204816:	6c88                	ld	a0,24(s1)
ffffffffc0204818:	467d                	li	a2,31
ffffffffc020481a:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc020481e:	ca9fe0ef          	jal	ra,ffffffffc02034c6 <pgdir_alloc_page>
ffffffffc0204822:	2e050b63          	beqz	a0,ffffffffc0204b18 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204826:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204828:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc020482c:	6c94                	ld	a3,24(s1)
ffffffffc020482e:	2785                	addiw	a5,a5,1
ffffffffc0204830:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204832:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204834:	c02007b7          	lui	a5,0xc0200
ffffffffc0204838:	2cf6e463          	bltu	a3,a5,ffffffffc0204b00 <do_execve+0x47c>
ffffffffc020483c:	000b3783          	ld	a5,0(s6)
ffffffffc0204840:	577d                	li	a4,-1
ffffffffc0204842:	177e                	slli	a4,a4,0x3f
ffffffffc0204844:	8e9d                	sub	a3,a3,a5
ffffffffc0204846:	00c6d793          	srli	a5,a3,0xc
ffffffffc020484a:	f654                	sd	a3,168(a2)
ffffffffc020484c:	8fd9                	or	a5,a5,a4
ffffffffc020484e:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204852:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204854:	4581                	li	a1,0
ffffffffc0204856:	12000613          	li	a2,288
ffffffffc020485a:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc020485c:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204860:	374010ef          	jal	ra,ffffffffc0205bd4 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204864:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204866:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc020486a:	edf4f493          	andi	s1,s1,-289
    tf->epc = elf->e_entry;
ffffffffc020486e:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204870:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204872:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_matrix_out_size+0xffffffff7fff39a4>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204876:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204878:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020487c:	4641                	li	a2,16
ffffffffc020487e:	4581                	li	a1,0
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204880:	10943023          	sd	s1,256(s0)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204884:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204886:	10e43423          	sd	a4,264(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020488a:	854a                	mv	a0,s2
ffffffffc020488c:	348010ef          	jal	ra,ffffffffc0205bd4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204890:	463d                	li	a2,15
ffffffffc0204892:	180c                	addi	a1,sp,48
ffffffffc0204894:	854a                	mv	a0,s2
ffffffffc0204896:	350010ef          	jal	ra,ffffffffc0205be6 <memcpy>
}
ffffffffc020489a:	70aa                	ld	ra,168(sp)
ffffffffc020489c:	740a                	ld	s0,160(sp)
ffffffffc020489e:	64ea                	ld	s1,152(sp)
ffffffffc02048a0:	694a                	ld	s2,144(sp)
ffffffffc02048a2:	69aa                	ld	s3,136(sp)
ffffffffc02048a4:	7ae6                	ld	s5,120(sp)
ffffffffc02048a6:	7b46                	ld	s6,112(sp)
ffffffffc02048a8:	7ba6                	ld	s7,104(sp)
ffffffffc02048aa:	7c06                	ld	s8,96(sp)
ffffffffc02048ac:	6ce6                	ld	s9,88(sp)
ffffffffc02048ae:	6d46                	ld	s10,80(sp)
ffffffffc02048b0:	6da6                	ld	s11,72(sp)
ffffffffc02048b2:	8552                	mv	a0,s4
ffffffffc02048b4:	6a0a                	ld	s4,128(sp)
ffffffffc02048b6:	614d                	addi	sp,sp,176
ffffffffc02048b8:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc02048ba:	463d                	li	a2,15
ffffffffc02048bc:	85ca                	mv	a1,s2
ffffffffc02048be:	1808                	addi	a0,sp,48
ffffffffc02048c0:	326010ef          	jal	ra,ffffffffc0205be6 <memcpy>
    if (mm != NULL)
ffffffffc02048c4:	e20991e3          	bnez	s3,ffffffffc02046e6 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc02048c8:	000db783          	ld	a5,0(s11)
ffffffffc02048cc:	779c                	ld	a5,40(a5)
ffffffffc02048ce:	e40788e3          	beqz	a5,ffffffffc020471e <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc02048d2:	00003617          	auipc	a2,0x3
ffffffffc02048d6:	d2e60613          	addi	a2,a2,-722 # ffffffffc0207600 <default_pmm_manager+0xbd0>
ffffffffc02048da:	25a00593          	li	a1,602
ffffffffc02048de:	00003517          	auipc	a0,0x3
ffffffffc02048e2:	b8250513          	addi	a0,a0,-1150 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc02048e6:	badfb0ef          	jal	ra,ffffffffc0200492 <__panic>
    put_pgdir(mm);
ffffffffc02048ea:	8526                	mv	a0,s1
ffffffffc02048ec:	c76ff0ef          	jal	ra,ffffffffc0203d62 <put_pgdir>
    mm_destroy(mm);
ffffffffc02048f0:	8526                	mv	a0,s1
ffffffffc02048f2:	dfbfe0ef          	jal	ra,ffffffffc02036ec <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc02048f6:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc02048f8:	8552                	mv	a0,s4
ffffffffc02048fa:	94bff0ef          	jal	ra,ffffffffc0204244 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc02048fe:	5a71                	li	s4,-4
ffffffffc0204900:	bfe5                	j	ffffffffc02048f8 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204902:	0289b603          	ld	a2,40(s3)
ffffffffc0204906:	0209b783          	ld	a5,32(s3)
ffffffffc020490a:	1cf66d63          	bltu	a2,a5,ffffffffc0204ae4 <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc020490e:	0049a783          	lw	a5,4(s3)
ffffffffc0204912:	0017f693          	andi	a3,a5,1
ffffffffc0204916:	c291                	beqz	a3,ffffffffc020491a <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204918:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc020491a:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc020491e:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204920:	e779                	bnez	a4,ffffffffc02049ee <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204922:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204924:	c781                	beqz	a5,ffffffffc020492c <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204926:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc020492a:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc020492c:	0026f793          	andi	a5,a3,2
ffffffffc0204930:	e3f1                	bnez	a5,ffffffffc02049f4 <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204932:	0046f793          	andi	a5,a3,4
ffffffffc0204936:	c399                	beqz	a5,ffffffffc020493c <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204938:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc020493c:	0109b583          	ld	a1,16(s3)
ffffffffc0204940:	4701                	li	a4,0
ffffffffc0204942:	8526                	mv	a0,s1
ffffffffc0204944:	dfbfe0ef          	jal	ra,ffffffffc020373e <mm_map>
ffffffffc0204948:	8a2a                	mv	s4,a0
ffffffffc020494a:	ed35                	bnez	a0,ffffffffc02049c6 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc020494c:	0109bb83          	ld	s7,16(s3)
ffffffffc0204950:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204952:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204956:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc020495a:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc020495e:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204960:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204962:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204964:	054be963          	bltu	s7,s4,ffffffffc02049b6 <do_execve+0x332>
ffffffffc0204968:	aa95                	j	ffffffffc0204adc <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc020496a:	6785                	lui	a5,0x1
ffffffffc020496c:	415b8533          	sub	a0,s7,s5
ffffffffc0204970:	9abe                	add	s5,s5,a5
ffffffffc0204972:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204976:	015a7463          	bgeu	s4,s5,ffffffffc020497e <do_execve+0x2fa>
                size -= la - end;
ffffffffc020497a:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc020497e:	000cb683          	ld	a3,0(s9)
ffffffffc0204982:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204984:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204988:	40d406b3          	sub	a3,s0,a3
ffffffffc020498c:	8699                	srai	a3,a3,0x6
ffffffffc020498e:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204990:	67e2                	ld	a5,24(sp)
ffffffffc0204992:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204996:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204998:	14b87863          	bgeu	a6,a1,ffffffffc0204ae8 <do_execve+0x464>
ffffffffc020499c:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc02049a0:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc02049a2:	9bb2                	add	s7,s7,a2
ffffffffc02049a4:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc02049a6:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc02049a8:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc02049aa:	23c010ef          	jal	ra,ffffffffc0205be6 <memcpy>
            start += size, from += size;
ffffffffc02049ae:	6622                	ld	a2,8(sp)
ffffffffc02049b0:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc02049b2:	054bf363          	bgeu	s7,s4,ffffffffc02049f8 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc02049b6:	6c88                	ld	a0,24(s1)
ffffffffc02049b8:	866a                	mv	a2,s10
ffffffffc02049ba:	85d6                	mv	a1,s5
ffffffffc02049bc:	b0bfe0ef          	jal	ra,ffffffffc02034c6 <pgdir_alloc_page>
ffffffffc02049c0:	842a                	mv	s0,a0
ffffffffc02049c2:	f545                	bnez	a0,ffffffffc020496a <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc02049c4:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc02049c6:	8526                	mv	a0,s1
ffffffffc02049c8:	ec1fe0ef          	jal	ra,ffffffffc0203888 <exit_mmap>
    put_pgdir(mm);
ffffffffc02049cc:	8526                	mv	a0,s1
ffffffffc02049ce:	b94ff0ef          	jal	ra,ffffffffc0203d62 <put_pgdir>
    mm_destroy(mm);
ffffffffc02049d2:	8526                	mv	a0,s1
ffffffffc02049d4:	d19fe0ef          	jal	ra,ffffffffc02036ec <mm_destroy>
    return ret;
ffffffffc02049d8:	b705                	j	ffffffffc02048f8 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc02049da:	854e                	mv	a0,s3
ffffffffc02049dc:	eadfe0ef          	jal	ra,ffffffffc0203888 <exit_mmap>
            put_pgdir(mm);
ffffffffc02049e0:	854e                	mv	a0,s3
ffffffffc02049e2:	b80ff0ef          	jal	ra,ffffffffc0203d62 <put_pgdir>
            mm_destroy(mm);
ffffffffc02049e6:	854e                	mv	a0,s3
ffffffffc02049e8:	d05fe0ef          	jal	ra,ffffffffc02036ec <mm_destroy>
ffffffffc02049ec:	b32d                	j	ffffffffc0204716 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc02049ee:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc02049f2:	fb95                	bnez	a5,ffffffffc0204926 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc02049f4:	4d5d                	li	s10,23
ffffffffc02049f6:	bf35                	j	ffffffffc0204932 <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc02049f8:	0109b683          	ld	a3,16(s3)
ffffffffc02049fc:	0289b903          	ld	s2,40(s3)
ffffffffc0204a00:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204a02:	075bfd63          	bgeu	s7,s5,ffffffffc0204a7c <do_execve+0x3f8>
            if (start == end)
ffffffffc0204a06:	db790fe3          	beq	s2,s7,ffffffffc02047c4 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204a0a:	6785                	lui	a5,0x1
ffffffffc0204a0c:	00fb8533          	add	a0,s7,a5
ffffffffc0204a10:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204a14:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204a18:	0b597d63          	bgeu	s2,s5,ffffffffc0204ad2 <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204a1c:	000cb683          	ld	a3,0(s9)
ffffffffc0204a20:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204a22:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204a26:	40d406b3          	sub	a3,s0,a3
ffffffffc0204a2a:	8699                	srai	a3,a3,0x6
ffffffffc0204a2c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204a2e:	67e2                	ld	a5,24(sp)
ffffffffc0204a30:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204a34:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204a36:	0ac5f963          	bgeu	a1,a2,ffffffffc0204ae8 <do_execve+0x464>
ffffffffc0204a3a:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204a3e:	8652                	mv	a2,s4
ffffffffc0204a40:	4581                	li	a1,0
ffffffffc0204a42:	96c2                	add	a3,a3,a6
ffffffffc0204a44:	9536                	add	a0,a0,a3
ffffffffc0204a46:	18e010ef          	jal	ra,ffffffffc0205bd4 <memset>
            start += size;
ffffffffc0204a4a:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204a4e:	03597463          	bgeu	s2,s5,ffffffffc0204a76 <do_execve+0x3f2>
ffffffffc0204a52:	d6e909e3          	beq	s2,a4,ffffffffc02047c4 <do_execve+0x140>
ffffffffc0204a56:	00003697          	auipc	a3,0x3
ffffffffc0204a5a:	bd268693          	addi	a3,a3,-1070 # ffffffffc0207628 <default_pmm_manager+0xbf8>
ffffffffc0204a5e:	00002617          	auipc	a2,0x2
ffffffffc0204a62:	c2260613          	addi	a2,a2,-990 # ffffffffc0206680 <commands+0x818>
ffffffffc0204a66:	2c300593          	li	a1,707
ffffffffc0204a6a:	00003517          	auipc	a0,0x3
ffffffffc0204a6e:	9f650513          	addi	a0,a0,-1546 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204a72:	a21fb0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0204a76:	ff5710e3          	bne	a4,s5,ffffffffc0204a56 <do_execve+0x3d2>
ffffffffc0204a7a:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204a7c:	d52bf4e3          	bgeu	s7,s2,ffffffffc02047c4 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204a80:	6c88                	ld	a0,24(s1)
ffffffffc0204a82:	866a                	mv	a2,s10
ffffffffc0204a84:	85d6                	mv	a1,s5
ffffffffc0204a86:	a41fe0ef          	jal	ra,ffffffffc02034c6 <pgdir_alloc_page>
ffffffffc0204a8a:	842a                	mv	s0,a0
ffffffffc0204a8c:	dd05                	beqz	a0,ffffffffc02049c4 <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204a8e:	6785                	lui	a5,0x1
ffffffffc0204a90:	415b8533          	sub	a0,s7,s5
ffffffffc0204a94:	9abe                	add	s5,s5,a5
ffffffffc0204a96:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204a9a:	01597463          	bgeu	s2,s5,ffffffffc0204aa2 <do_execve+0x41e>
                size -= la - end;
ffffffffc0204a9e:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204aa2:	000cb683          	ld	a3,0(s9)
ffffffffc0204aa6:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204aa8:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204aac:	40d406b3          	sub	a3,s0,a3
ffffffffc0204ab0:	8699                	srai	a3,a3,0x6
ffffffffc0204ab2:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204ab4:	67e2                	ld	a5,24(sp)
ffffffffc0204ab6:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204aba:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204abc:	02b87663          	bgeu	a6,a1,ffffffffc0204ae8 <do_execve+0x464>
ffffffffc0204ac0:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204ac4:	4581                	li	a1,0
            start += size;
ffffffffc0204ac6:	9bb2                	add	s7,s7,a2
ffffffffc0204ac8:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204aca:	9536                	add	a0,a0,a3
ffffffffc0204acc:	108010ef          	jal	ra,ffffffffc0205bd4 <memset>
ffffffffc0204ad0:	b775                	j	ffffffffc0204a7c <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204ad2:	417a8a33          	sub	s4,s5,s7
ffffffffc0204ad6:	b799                	j	ffffffffc0204a1c <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204ad8:	5a75                	li	s4,-3
ffffffffc0204ada:	b3c1                	j	ffffffffc020489a <do_execve+0x216>
        while (start < end)
ffffffffc0204adc:	86de                	mv	a3,s7
ffffffffc0204ade:	bf39                	j	ffffffffc02049fc <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204ae0:	5a71                	li	s4,-4
ffffffffc0204ae2:	bdc5                	j	ffffffffc02049d2 <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204ae4:	5a61                	li	s4,-8
ffffffffc0204ae6:	b5c5                	j	ffffffffc02049c6 <do_execve+0x342>
ffffffffc0204ae8:	00002617          	auipc	a2,0x2
ffffffffc0204aec:	f8060613          	addi	a2,a2,-128 # ffffffffc0206a68 <default_pmm_manager+0x38>
ffffffffc0204af0:	07100593          	li	a1,113
ffffffffc0204af4:	00002517          	auipc	a0,0x2
ffffffffc0204af8:	f9c50513          	addi	a0,a0,-100 # ffffffffc0206a90 <default_pmm_manager+0x60>
ffffffffc0204afc:	997fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b00:	00002617          	auipc	a2,0x2
ffffffffc0204b04:	01060613          	addi	a2,a2,16 # ffffffffc0206b10 <default_pmm_manager+0xe0>
ffffffffc0204b08:	2e200593          	li	a1,738
ffffffffc0204b0c:	00003517          	auipc	a0,0x3
ffffffffc0204b10:	95450513          	addi	a0,a0,-1708 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204b14:	97ffb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b18:	00003697          	auipc	a3,0x3
ffffffffc0204b1c:	c2868693          	addi	a3,a3,-984 # ffffffffc0207740 <default_pmm_manager+0xd10>
ffffffffc0204b20:	00002617          	auipc	a2,0x2
ffffffffc0204b24:	b6060613          	addi	a2,a2,-1184 # ffffffffc0206680 <commands+0x818>
ffffffffc0204b28:	2dd00593          	li	a1,733
ffffffffc0204b2c:	00003517          	auipc	a0,0x3
ffffffffc0204b30:	93450513          	addi	a0,a0,-1740 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204b34:	95ffb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b38:	00003697          	auipc	a3,0x3
ffffffffc0204b3c:	bc068693          	addi	a3,a3,-1088 # ffffffffc02076f8 <default_pmm_manager+0xcc8>
ffffffffc0204b40:	00002617          	auipc	a2,0x2
ffffffffc0204b44:	b4060613          	addi	a2,a2,-1216 # ffffffffc0206680 <commands+0x818>
ffffffffc0204b48:	2dc00593          	li	a1,732
ffffffffc0204b4c:	00003517          	auipc	a0,0x3
ffffffffc0204b50:	91450513          	addi	a0,a0,-1772 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204b54:	93ffb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b58:	00003697          	auipc	a3,0x3
ffffffffc0204b5c:	b5868693          	addi	a3,a3,-1192 # ffffffffc02076b0 <default_pmm_manager+0xc80>
ffffffffc0204b60:	00002617          	auipc	a2,0x2
ffffffffc0204b64:	b2060613          	addi	a2,a2,-1248 # ffffffffc0206680 <commands+0x818>
ffffffffc0204b68:	2db00593          	li	a1,731
ffffffffc0204b6c:	00003517          	auipc	a0,0x3
ffffffffc0204b70:	8f450513          	addi	a0,a0,-1804 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204b74:	91ffb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204b78:	00003697          	auipc	a3,0x3
ffffffffc0204b7c:	af068693          	addi	a3,a3,-1296 # ffffffffc0207668 <default_pmm_manager+0xc38>
ffffffffc0204b80:	00002617          	auipc	a2,0x2
ffffffffc0204b84:	b0060613          	addi	a2,a2,-1280 # ffffffffc0206680 <commands+0x818>
ffffffffc0204b88:	2da00593          	li	a1,730
ffffffffc0204b8c:	00003517          	auipc	a0,0x3
ffffffffc0204b90:	8d450513          	addi	a0,a0,-1836 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204b94:	8fffb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204b98 <user_main>:
{
ffffffffc0204b98:	1101                	addi	sp,sp,-32
ffffffffc0204b9a:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE(priority);
ffffffffc0204b9c:	000c2917          	auipc	s2,0xc2
ffffffffc0204ba0:	04490913          	addi	s2,s2,68 # ffffffffc02c6be0 <current>
ffffffffc0204ba4:	00093783          	ld	a5,0(s2)
ffffffffc0204ba8:	00003617          	auipc	a2,0x3
ffffffffc0204bac:	be060613          	addi	a2,a2,-1056 # ffffffffc0207788 <default_pmm_manager+0xd58>
ffffffffc0204bb0:	00003517          	auipc	a0,0x3
ffffffffc0204bb4:	be850513          	addi	a0,a0,-1048 # ffffffffc0207798 <default_pmm_manager+0xd68>
ffffffffc0204bb8:	43cc                	lw	a1,4(a5)
{
ffffffffc0204bba:	ec06                	sd	ra,24(sp)
ffffffffc0204bbc:	e822                	sd	s0,16(sp)
ffffffffc0204bbe:	e426                	sd	s1,8(sp)
    KERNEL_EXECVE(priority);
ffffffffc0204bc0:	dd8fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    size_t len = strlen(name);
ffffffffc0204bc4:	00003517          	auipc	a0,0x3
ffffffffc0204bc8:	bc450513          	addi	a0,a0,-1084 # ffffffffc0207788 <default_pmm_manager+0xd58>
ffffffffc0204bcc:	767000ef          	jal	ra,ffffffffc0205b32 <strlen>
    struct trapframe *old_tf = current->tf;
ffffffffc0204bd0:	00093783          	ld	a5,0(s2)
    size_t len = strlen(name);
ffffffffc0204bd4:	84aa                	mv	s1,a0
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204bd6:	12000613          	li	a2,288
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204bda:	6b80                	ld	s0,16(a5)
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204bdc:	73cc                	ld	a1,160(a5)
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204bde:	6789                	lui	a5,0x2
ffffffffc0204be0:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x8060>
ffffffffc0204be4:	943e                	add	s0,s0,a5
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204be6:	8522                	mv	a0,s0
ffffffffc0204be8:	7ff000ef          	jal	ra,ffffffffc0205be6 <memcpy>
    current->tf = new_tf;
ffffffffc0204bec:	00093783          	ld	a5,0(s2)
    ret = do_execve(name, len, binary, size);
ffffffffc0204bf0:	3fe07697          	auipc	a3,0x3fe07
ffffffffc0204bf4:	b5068693          	addi	a3,a3,-1200 # b740 <_binary_obj___user_priority_out_size>
ffffffffc0204bf8:	0007d617          	auipc	a2,0x7d
ffffffffc0204bfc:	12860613          	addi	a2,a2,296 # ffffffffc0281d20 <_binary_obj___user_priority_out_start>
    current->tf = new_tf;
ffffffffc0204c00:	f3c0                	sd	s0,160(a5)
    ret = do_execve(name, len, binary, size);
ffffffffc0204c02:	85a6                	mv	a1,s1
ffffffffc0204c04:	00003517          	auipc	a0,0x3
ffffffffc0204c08:	b8450513          	addi	a0,a0,-1148 # ffffffffc0207788 <default_pmm_manager+0xd58>
ffffffffc0204c0c:	a79ff0ef          	jal	ra,ffffffffc0204684 <do_execve>
    asm volatile(
ffffffffc0204c10:	8122                	mv	sp,s0
ffffffffc0204c12:	a5afc06f          	j	ffffffffc0200e6c <__trapret>
    panic("user_main execve failed.\n");
ffffffffc0204c16:	00003617          	auipc	a2,0x3
ffffffffc0204c1a:	baa60613          	addi	a2,a2,-1110 # ffffffffc02077c0 <default_pmm_manager+0xd90>
ffffffffc0204c1e:	3c900593          	li	a1,969
ffffffffc0204c22:	00003517          	auipc	a0,0x3
ffffffffc0204c26:	83e50513          	addi	a0,a0,-1986 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204c2a:	869fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204c2e <do_yield>:
    current->need_resched = 1;
ffffffffc0204c2e:	000c2797          	auipc	a5,0xc2
ffffffffc0204c32:	fb27b783          	ld	a5,-78(a5) # ffffffffc02c6be0 <current>
ffffffffc0204c36:	4705                	li	a4,1
ffffffffc0204c38:	ef98                	sd	a4,24(a5)
}
ffffffffc0204c3a:	4501                	li	a0,0
ffffffffc0204c3c:	8082                	ret

ffffffffc0204c3e <do_wait>:
{
ffffffffc0204c3e:	1101                	addi	sp,sp,-32
ffffffffc0204c40:	e822                	sd	s0,16(sp)
ffffffffc0204c42:	e426                	sd	s1,8(sp)
ffffffffc0204c44:	ec06                	sd	ra,24(sp)
ffffffffc0204c46:	842e                	mv	s0,a1
ffffffffc0204c48:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204c4a:	c999                	beqz	a1,ffffffffc0204c60 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204c4c:	000c2797          	auipc	a5,0xc2
ffffffffc0204c50:	f947b783          	ld	a5,-108(a5) # ffffffffc02c6be0 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204c54:	7788                	ld	a0,40(a5)
ffffffffc0204c56:	4685                	li	a3,1
ffffffffc0204c58:	4611                	li	a2,4
ffffffffc0204c5a:	fc9fe0ef          	jal	ra,ffffffffc0203c22 <user_mem_check>
ffffffffc0204c5e:	c909                	beqz	a0,ffffffffc0204c70 <do_wait+0x32>
ffffffffc0204c60:	85a2                	mv	a1,s0
}
ffffffffc0204c62:	6442                	ld	s0,16(sp)
ffffffffc0204c64:	60e2                	ld	ra,24(sp)
ffffffffc0204c66:	8526                	mv	a0,s1
ffffffffc0204c68:	64a2                	ld	s1,8(sp)
ffffffffc0204c6a:	6105                	addi	sp,sp,32
ffffffffc0204c6c:	f22ff06f          	j	ffffffffc020438e <do_wait.part.0>
ffffffffc0204c70:	60e2                	ld	ra,24(sp)
ffffffffc0204c72:	6442                	ld	s0,16(sp)
ffffffffc0204c74:	64a2                	ld	s1,8(sp)
ffffffffc0204c76:	5575                	li	a0,-3
ffffffffc0204c78:	6105                	addi	sp,sp,32
ffffffffc0204c7a:	8082                	ret

ffffffffc0204c7c <do_kill>:
{
ffffffffc0204c7c:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204c7e:	6789                	lui	a5,0x2
{
ffffffffc0204c80:	e406                	sd	ra,8(sp)
ffffffffc0204c82:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204c84:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204c88:	17f9                	addi	a5,a5,-2
ffffffffc0204c8a:	02e7e963          	bltu	a5,a4,ffffffffc0204cbc <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204c8e:	842a                	mv	s0,a0
ffffffffc0204c90:	45a9                	li	a1,10
ffffffffc0204c92:	2501                	sext.w	a0,a0
ffffffffc0204c94:	29b000ef          	jal	ra,ffffffffc020572e <hash32>
ffffffffc0204c98:	02051793          	slli	a5,a0,0x20
ffffffffc0204c9c:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204ca0:	000be797          	auipc	a5,0xbe
ffffffffc0204ca4:	ea878793          	addi	a5,a5,-344 # ffffffffc02c2b48 <hash_list>
ffffffffc0204ca8:	953e                	add	a0,a0,a5
ffffffffc0204caa:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204cac:	a029                	j	ffffffffc0204cb6 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204cae:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204cb2:	00870b63          	beq	a4,s0,ffffffffc0204cc8 <do_kill+0x4c>
ffffffffc0204cb6:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204cb8:	fef51be3          	bne	a0,a5,ffffffffc0204cae <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204cbc:	5475                	li	s0,-3
}
ffffffffc0204cbe:	60a2                	ld	ra,8(sp)
ffffffffc0204cc0:	8522                	mv	a0,s0
ffffffffc0204cc2:	6402                	ld	s0,0(sp)
ffffffffc0204cc4:	0141                	addi	sp,sp,16
ffffffffc0204cc6:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204cc8:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204ccc:	00177693          	andi	a3,a4,1
ffffffffc0204cd0:	e295                	bnez	a3,ffffffffc0204cf4 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204cd2:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204cd4:	00176713          	ori	a4,a4,1
ffffffffc0204cd8:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204cdc:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204cde:	fe06d0e3          	bgez	a3,ffffffffc0204cbe <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204ce2:	f2878513          	addi	a0,a5,-216
ffffffffc0204ce6:	7d6000ef          	jal	ra,ffffffffc02054bc <wakeup_proc>
}
ffffffffc0204cea:	60a2                	ld	ra,8(sp)
ffffffffc0204cec:	8522                	mv	a0,s0
ffffffffc0204cee:	6402                	ld	s0,0(sp)
ffffffffc0204cf0:	0141                	addi	sp,sp,16
ffffffffc0204cf2:	8082                	ret
        return -E_KILLED;
ffffffffc0204cf4:	545d                	li	s0,-9
ffffffffc0204cf6:	b7e1                	j	ffffffffc0204cbe <do_kill+0x42>

ffffffffc0204cf8 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204cf8:	1101                	addi	sp,sp,-32
ffffffffc0204cfa:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204cfc:	000c2797          	auipc	a5,0xc2
ffffffffc0204d00:	e4c78793          	addi	a5,a5,-436 # ffffffffc02c6b48 <proc_list>
ffffffffc0204d04:	ec06                	sd	ra,24(sp)
ffffffffc0204d06:	e822                	sd	s0,16(sp)
ffffffffc0204d08:	e04a                	sd	s2,0(sp)
ffffffffc0204d0a:	000be497          	auipc	s1,0xbe
ffffffffc0204d0e:	e3e48493          	addi	s1,s1,-450 # ffffffffc02c2b48 <hash_list>
ffffffffc0204d12:	e79c                	sd	a5,8(a5)
ffffffffc0204d14:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204d16:	000c2717          	auipc	a4,0xc2
ffffffffc0204d1a:	e3270713          	addi	a4,a4,-462 # ffffffffc02c6b48 <proc_list>
ffffffffc0204d1e:	87a6                	mv	a5,s1
ffffffffc0204d20:	e79c                	sd	a5,8(a5)
ffffffffc0204d22:	e39c                	sd	a5,0(a5)
ffffffffc0204d24:	07c1                	addi	a5,a5,16
ffffffffc0204d26:	fef71de3          	bne	a4,a5,ffffffffc0204d20 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204d2a:	f95fe0ef          	jal	ra,ffffffffc0203cbe <alloc_proc>
ffffffffc0204d2e:	000c2917          	auipc	s2,0xc2
ffffffffc0204d32:	eba90913          	addi	s2,s2,-326 # ffffffffc02c6be8 <idleproc>
ffffffffc0204d36:	00a93023          	sd	a0,0(s2)
ffffffffc0204d3a:	0e050f63          	beqz	a0,ffffffffc0204e38 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204d3e:	4789                	li	a5,2
ffffffffc0204d40:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204d42:	00004797          	auipc	a5,0x4
ffffffffc0204d46:	2be78793          	addi	a5,a5,702 # ffffffffc0209000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d4a:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204d4e:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204d50:	4785                	li	a5,1
ffffffffc0204d52:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d54:	4641                	li	a2,16
ffffffffc0204d56:	4581                	li	a1,0
ffffffffc0204d58:	8522                	mv	a0,s0
ffffffffc0204d5a:	67b000ef          	jal	ra,ffffffffc0205bd4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204d5e:	463d                	li	a2,15
ffffffffc0204d60:	00003597          	auipc	a1,0x3
ffffffffc0204d64:	a9858593          	addi	a1,a1,-1384 # ffffffffc02077f8 <default_pmm_manager+0xdc8>
ffffffffc0204d68:	8522                	mv	a0,s0
ffffffffc0204d6a:	67d000ef          	jal	ra,ffffffffc0205be6 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204d6e:	000c2717          	auipc	a4,0xc2
ffffffffc0204d72:	e8a70713          	addi	a4,a4,-374 # ffffffffc02c6bf8 <nr_process>
ffffffffc0204d76:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204d78:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204d7c:	4601                	li	a2,0
    nr_process++;
ffffffffc0204d7e:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204d80:	4581                	li	a1,0
ffffffffc0204d82:	fffff517          	auipc	a0,0xfffff
ffffffffc0204d86:	7de50513          	addi	a0,a0,2014 # ffffffffc0204560 <init_main>
    nr_process++;
ffffffffc0204d8a:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204d8c:	000c2797          	auipc	a5,0xc2
ffffffffc0204d90:	e4d7ba23          	sd	a3,-428(a5) # ffffffffc02c6be0 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204d94:	c60ff0ef          	jal	ra,ffffffffc02041f4 <kernel_thread>
ffffffffc0204d98:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204d9a:	08a05363          	blez	a0,ffffffffc0204e20 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204d9e:	6789                	lui	a5,0x2
ffffffffc0204da0:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204da4:	17f9                	addi	a5,a5,-2
ffffffffc0204da6:	2501                	sext.w	a0,a0
ffffffffc0204da8:	02e7e363          	bltu	a5,a4,ffffffffc0204dce <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204dac:	45a9                	li	a1,10
ffffffffc0204dae:	181000ef          	jal	ra,ffffffffc020572e <hash32>
ffffffffc0204db2:	02051793          	slli	a5,a0,0x20
ffffffffc0204db6:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204dba:	96a6                	add	a3,a3,s1
ffffffffc0204dbc:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204dbe:	a029                	j	ffffffffc0204dc8 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204dc0:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x8014>
ffffffffc0204dc4:	04870b63          	beq	a4,s0,ffffffffc0204e1a <proc_init+0x122>
    return listelm->next;
ffffffffc0204dc8:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204dca:	fef69be3          	bne	a3,a5,ffffffffc0204dc0 <proc_init+0xc8>
    return NULL;
ffffffffc0204dce:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204dd0:	0b478493          	addi	s1,a5,180
ffffffffc0204dd4:	4641                	li	a2,16
ffffffffc0204dd6:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204dd8:	000c2417          	auipc	s0,0xc2
ffffffffc0204ddc:	e1840413          	addi	s0,s0,-488 # ffffffffc02c6bf0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204de0:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204de2:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204de4:	5f1000ef          	jal	ra,ffffffffc0205bd4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204de8:	463d                	li	a2,15
ffffffffc0204dea:	00003597          	auipc	a1,0x3
ffffffffc0204dee:	a3658593          	addi	a1,a1,-1482 # ffffffffc0207820 <default_pmm_manager+0xdf0>
ffffffffc0204df2:	8526                	mv	a0,s1
ffffffffc0204df4:	5f3000ef          	jal	ra,ffffffffc0205be6 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204df8:	00093783          	ld	a5,0(s2)
ffffffffc0204dfc:	cbb5                	beqz	a5,ffffffffc0204e70 <proc_init+0x178>
ffffffffc0204dfe:	43dc                	lw	a5,4(a5)
ffffffffc0204e00:	eba5                	bnez	a5,ffffffffc0204e70 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204e02:	601c                	ld	a5,0(s0)
ffffffffc0204e04:	c7b1                	beqz	a5,ffffffffc0204e50 <proc_init+0x158>
ffffffffc0204e06:	43d8                	lw	a4,4(a5)
ffffffffc0204e08:	4785                	li	a5,1
ffffffffc0204e0a:	04f71363          	bne	a4,a5,ffffffffc0204e50 <proc_init+0x158>
}
ffffffffc0204e0e:	60e2                	ld	ra,24(sp)
ffffffffc0204e10:	6442                	ld	s0,16(sp)
ffffffffc0204e12:	64a2                	ld	s1,8(sp)
ffffffffc0204e14:	6902                	ld	s2,0(sp)
ffffffffc0204e16:	6105                	addi	sp,sp,32
ffffffffc0204e18:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204e1a:	f2878793          	addi	a5,a5,-216
ffffffffc0204e1e:	bf4d                	j	ffffffffc0204dd0 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204e20:	00003617          	auipc	a2,0x3
ffffffffc0204e24:	9e060613          	addi	a2,a2,-1568 # ffffffffc0207800 <default_pmm_manager+0xdd0>
ffffffffc0204e28:	40500593          	li	a1,1029
ffffffffc0204e2c:	00002517          	auipc	a0,0x2
ffffffffc0204e30:	63450513          	addi	a0,a0,1588 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204e34:	e5efb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204e38:	00003617          	auipc	a2,0x3
ffffffffc0204e3c:	9a860613          	addi	a2,a2,-1624 # ffffffffc02077e0 <default_pmm_manager+0xdb0>
ffffffffc0204e40:	3f600593          	li	a1,1014
ffffffffc0204e44:	00002517          	auipc	a0,0x2
ffffffffc0204e48:	61c50513          	addi	a0,a0,1564 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204e4c:	e46fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204e50:	00003697          	auipc	a3,0x3
ffffffffc0204e54:	a0068693          	addi	a3,a3,-1536 # ffffffffc0207850 <default_pmm_manager+0xe20>
ffffffffc0204e58:	00002617          	auipc	a2,0x2
ffffffffc0204e5c:	82860613          	addi	a2,a2,-2008 # ffffffffc0206680 <commands+0x818>
ffffffffc0204e60:	40c00593          	li	a1,1036
ffffffffc0204e64:	00002517          	auipc	a0,0x2
ffffffffc0204e68:	5fc50513          	addi	a0,a0,1532 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204e6c:	e26fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204e70:	00003697          	auipc	a3,0x3
ffffffffc0204e74:	9b868693          	addi	a3,a3,-1608 # ffffffffc0207828 <default_pmm_manager+0xdf8>
ffffffffc0204e78:	00002617          	auipc	a2,0x2
ffffffffc0204e7c:	80860613          	addi	a2,a2,-2040 # ffffffffc0206680 <commands+0x818>
ffffffffc0204e80:	40b00593          	li	a1,1035
ffffffffc0204e84:	00002517          	auipc	a0,0x2
ffffffffc0204e88:	5dc50513          	addi	a0,a0,1500 # ffffffffc0207460 <default_pmm_manager+0xa30>
ffffffffc0204e8c:	e06fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204e90 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204e90:	1141                	addi	sp,sp,-16
ffffffffc0204e92:	e022                	sd	s0,0(sp)
ffffffffc0204e94:	e406                	sd	ra,8(sp)
ffffffffc0204e96:	000c2417          	auipc	s0,0xc2
ffffffffc0204e9a:	d4a40413          	addi	s0,s0,-694 # ffffffffc02c6be0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204e9e:	6018                	ld	a4,0(s0)
ffffffffc0204ea0:	6f1c                	ld	a5,24(a4)
ffffffffc0204ea2:	dffd                	beqz	a5,ffffffffc0204ea0 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204ea4:	6ca000ef          	jal	ra,ffffffffc020556e <schedule>
ffffffffc0204ea8:	bfdd                	j	ffffffffc0204e9e <cpu_idle+0xe>

ffffffffc0204eaa <lab6_set_priority>:
        }
    }
}
// FOR LAB6, set the process's priority (bigger value will get more CPU time)
void lab6_set_priority(uint32_t priority)
{
ffffffffc0204eaa:	1141                	addi	sp,sp,-16
ffffffffc0204eac:	e022                	sd	s0,0(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc0204eae:	85aa                	mv	a1,a0
{
ffffffffc0204eb0:	842a                	mv	s0,a0
    cprintf("set priority to %d\n", priority);
ffffffffc0204eb2:	00003517          	auipc	a0,0x3
ffffffffc0204eb6:	9c650513          	addi	a0,a0,-1594 # ffffffffc0207878 <default_pmm_manager+0xe48>
{
ffffffffc0204eba:	e406                	sd	ra,8(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc0204ebc:	adcfb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    if (priority == 0)
        current->lab6_priority = 1;
ffffffffc0204ec0:	000c2797          	auipc	a5,0xc2
ffffffffc0204ec4:	d207b783          	ld	a5,-736(a5) # ffffffffc02c6be0 <current>
    if (priority == 0)
ffffffffc0204ec8:	e801                	bnez	s0,ffffffffc0204ed8 <lab6_set_priority+0x2e>
    else
        current->lab6_priority = priority;
}
ffffffffc0204eca:	60a2                	ld	ra,8(sp)
ffffffffc0204ecc:	6402                	ld	s0,0(sp)
        current->lab6_priority = 1;
ffffffffc0204ece:	4705                	li	a4,1
ffffffffc0204ed0:	14e7a423          	sw	a4,328(a5)
}
ffffffffc0204ed4:	0141                	addi	sp,sp,16
ffffffffc0204ed6:	8082                	ret
ffffffffc0204ed8:	60a2                	ld	ra,8(sp)
        current->lab6_priority = priority;
ffffffffc0204eda:	1487a423          	sw	s0,328(a5)
}
ffffffffc0204ede:	6402                	ld	s0,0(sp)
ffffffffc0204ee0:	0141                	addi	sp,sp,16
ffffffffc0204ee2:	8082                	ret

ffffffffc0204ee4 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204ee4:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204ee8:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204eec:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204eee:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204ef0:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204ef4:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204ef8:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204efc:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204f00:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204f04:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0204f08:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0204f0c:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0204f10:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0204f14:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0204f18:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0204f1c:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0204f20:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0204f22:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0204f24:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0204f28:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0204f2c:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0204f30:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0204f34:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0204f38:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0204f3c:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0204f40:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0204f44:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0204f48:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0204f4c:	8082                	ret

ffffffffc0204f4e <stride_init>:
    elm->prev = elm->next = elm;
ffffffffc0204f4e:	e508                	sd	a0,8(a0)
ffffffffc0204f50:	e108                	sd	a0,0(a0)
static void
stride_init(struct run_queue *rq)
{
     /* LAB6 CHALLENGE 1: 2312642 */
     list_init(&(rq->run_list));
     rq->lab6_run_pool = NULL;
ffffffffc0204f52:	00053c23          	sd	zero,24(a0)
     rq->proc_num = 0;
ffffffffc0204f56:	00052823          	sw	zero,16(a0)
}
ffffffffc0204f5a:	8082                	ret

ffffffffc0204f5c <stride_pick_next>:
static struct proc_struct *
stride_pick_next(struct run_queue *rq)
{
     /* LAB6 CHALLENGE 1: 2312642 */
#if USE_SKEW_HEAP
     if (rq->lab6_run_pool == NULL)
ffffffffc0204f5c:	6d18                	ld	a4,24(a0)
ffffffffc0204f5e:	c305                	beqz	a4,ffffffffc0204f7e <stride_pick_next+0x22>
          {
               p = q;
          }
     }
#endif
     p->lab6_stride += BIG_STRIDE / p->lab6_priority;
ffffffffc0204f60:	5314                	lw	a3,32(a4)
ffffffffc0204f62:	800007b7          	lui	a5,0x80000
ffffffffc0204f66:	fff7c793          	not	a5,a5
ffffffffc0204f6a:	02d7d7bb          	divuw	a5,a5,a3
ffffffffc0204f6e:	6f14                	ld	a3,24(a4)
     struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
ffffffffc0204f70:	ed870513          	addi	a0,a4,-296
     p->lab6_stride += BIG_STRIDE / p->lab6_priority;
ffffffffc0204f74:	1782                	slli	a5,a5,0x20
ffffffffc0204f76:	9381                	srli	a5,a5,0x20
ffffffffc0204f78:	97b6                	add	a5,a5,a3
ffffffffc0204f7a:	ef1c                	sd	a5,24(a4)
     return p;
ffffffffc0204f7c:	8082                	ret
          return NULL;
ffffffffc0204f7e:	4501                	li	a0,0
}
ffffffffc0204f80:	8082                	ret

ffffffffc0204f82 <stride_proc_tick>:
 */
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
     /* LAB6 CHALLENGE 1: 2312642 */
     if (proc->time_slice > 0)
ffffffffc0204f82:	1205a783          	lw	a5,288(a1)
ffffffffc0204f86:	00f05563          	blez	a5,ffffffffc0204f90 <stride_proc_tick+0xe>
     {
          proc->time_slice--;
ffffffffc0204f8a:	37fd                	addiw	a5,a5,-1
ffffffffc0204f8c:	12f5a023          	sw	a5,288(a1)
     }
     if (proc->time_slice == 0)
ffffffffc0204f90:	e399                	bnez	a5,ffffffffc0204f96 <stride_proc_tick+0x14>
     {
          proc->need_resched = 1;
ffffffffc0204f92:	4785                	li	a5,1
ffffffffc0204f94:	ed9c                	sd	a5,24(a1)
     }
}
ffffffffc0204f96:	8082                	ret

ffffffffc0204f98 <skew_heap_merge.constprop.0>:
}

static inline skew_heap_entry_t *
skew_heap_merge(skew_heap_entry_t *a, skew_heap_entry_t *b,
ffffffffc0204f98:	7139                	addi	sp,sp,-64
ffffffffc0204f9a:	f822                	sd	s0,48(sp)
ffffffffc0204f9c:	fc06                	sd	ra,56(sp)
ffffffffc0204f9e:	f426                	sd	s1,40(sp)
ffffffffc0204fa0:	f04a                	sd	s2,32(sp)
ffffffffc0204fa2:	ec4e                	sd	s3,24(sp)
ffffffffc0204fa4:	e852                	sd	s4,16(sp)
ffffffffc0204fa6:	e456                	sd	s5,8(sp)
ffffffffc0204fa8:	e05a                	sd	s6,0(sp)
ffffffffc0204faa:	842e                	mv	s0,a1
                compare_f comp)
{
     if (a == NULL) return b;
ffffffffc0204fac:	c925                	beqz	a0,ffffffffc020501c <skew_heap_merge.constprop.0+0x84>
ffffffffc0204fae:	84aa                	mv	s1,a0
     else if (b == NULL) return a;
ffffffffc0204fb0:	c1ed                	beqz	a1,ffffffffc0205092 <skew_heap_merge.constprop.0+0xfa>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0204fb2:	4d1c                	lw	a5,24(a0)
ffffffffc0204fb4:	4d98                	lw	a4,24(a1)
     else if (delta < 0)
ffffffffc0204fb6:	40e786bb          	subw	a3,a5,a4
ffffffffc0204fba:	0606cc63          	bltz	a3,ffffffffc0205032 <skew_heap_merge.constprop.0+0x9a>
          return a;
     }
     else
     {
          r = b->left;
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0204fbe:	0105b903          	ld	s2,16(a1)
          r = b->left;
ffffffffc0204fc2:	0085ba03          	ld	s4,8(a1)
     else if (b == NULL) return a;
ffffffffc0204fc6:	04090763          	beqz	s2,ffffffffc0205014 <skew_heap_merge.constprop.0+0x7c>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0204fca:	01892703          	lw	a4,24(s2)
     else if (delta < 0)
ffffffffc0204fce:	40e786bb          	subw	a3,a5,a4
ffffffffc0204fd2:	0c06c263          	bltz	a3,ffffffffc0205096 <skew_heap_merge.constprop.0+0xfe>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0204fd6:	01093983          	ld	s3,16(s2)
          r = b->left;
ffffffffc0204fda:	00893a83          	ld	s5,8(s2)
     else if (b == NULL) return a;
ffffffffc0204fde:	10098c63          	beqz	s3,ffffffffc02050f6 <skew_heap_merge.constprop.0+0x15e>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0204fe2:	0189b703          	ld	a4,24(s3)
     else if (delta < 0)
ffffffffc0204fe6:	9f99                	subw	a5,a5,a4
ffffffffc0204fe8:	1407c863          	bltz	a5,ffffffffc0205138 <skew_heap_merge.constprop.0+0x1a0>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0204fec:	0109b583          	ld	a1,16(s3)
          r = b->left;
ffffffffc0204ff0:	0089b483          	ld	s1,8(s3)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0204ff4:	fa5ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          
          b->left = l;
ffffffffc0204ff8:	00a9b423          	sd	a0,8(s3)
          b->right = r;
ffffffffc0204ffc:	0099b823          	sd	s1,16(s3)
          if (l) l->parent = b;
ffffffffc0205000:	c119                	beqz	a0,ffffffffc0205006 <skew_heap_merge.constprop.0+0x6e>
ffffffffc0205002:	01353023          	sd	s3,0(a0)
          b->left = l;
ffffffffc0205006:	01393423          	sd	s3,8(s2)
          b->right = r;
ffffffffc020500a:	01593823          	sd	s5,16(s2)
          if (l) l->parent = b;
ffffffffc020500e:	0129b023          	sd	s2,0(s3)
ffffffffc0205012:	84ca                	mv	s1,s2
          b->left = l;
ffffffffc0205014:	e404                	sd	s1,8(s0)
          b->right = r;
ffffffffc0205016:	01443823          	sd	s4,16(s0)
          if (l) l->parent = b;
ffffffffc020501a:	e080                	sd	s0,0(s1)
ffffffffc020501c:	8522                	mv	a0,s0

          return b;
     }
}
ffffffffc020501e:	70e2                	ld	ra,56(sp)
ffffffffc0205020:	7442                	ld	s0,48(sp)
ffffffffc0205022:	74a2                	ld	s1,40(sp)
ffffffffc0205024:	7902                	ld	s2,32(sp)
ffffffffc0205026:	69e2                	ld	s3,24(sp)
ffffffffc0205028:	6a42                	ld	s4,16(sp)
ffffffffc020502a:	6aa2                	ld	s5,8(sp)
ffffffffc020502c:	6b02                	ld	s6,0(sp)
ffffffffc020502e:	6121                	addi	sp,sp,64
ffffffffc0205030:	8082                	ret
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205032:	01053903          	ld	s2,16(a0)
          r = a->left;
ffffffffc0205036:	00853a03          	ld	s4,8(a0)
     if (a == NULL) return b;
ffffffffc020503a:	04090863          	beqz	s2,ffffffffc020508a <skew_heap_merge.constprop.0+0xf2>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc020503e:	01892783          	lw	a5,24(s2)
     else if (delta < 0)
ffffffffc0205042:	40e7873b          	subw	a4,a5,a4
ffffffffc0205046:	08074963          	bltz	a4,ffffffffc02050d8 <skew_heap_merge.constprop.0+0x140>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020504a:	0105b983          	ld	s3,16(a1)
          r = b->left;
ffffffffc020504e:	0085ba83          	ld	s5,8(a1)
     else if (b == NULL) return a;
ffffffffc0205052:	02098663          	beqz	s3,ffffffffc020507e <skew_heap_merge.constprop.0+0xe6>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0205056:	0189b703          	ld	a4,24(s3)
     else if (delta < 0)
ffffffffc020505a:	9f99                	subw	a5,a5,a4
ffffffffc020505c:	0807cf63          	bltz	a5,ffffffffc02050fa <skew_heap_merge.constprop.0+0x162>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205060:	0109b583          	ld	a1,16(s3)
          r = b->left;
ffffffffc0205064:	0089bb03          	ld	s6,8(s3)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205068:	854a                	mv	a0,s2
ffffffffc020506a:	f2fff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          b->left = l;
ffffffffc020506e:	00a9b423          	sd	a0,8(s3)
          b->right = r;
ffffffffc0205072:	0169b823          	sd	s6,16(s3)
          if (l) l->parent = b;
ffffffffc0205076:	894e                	mv	s2,s3
ffffffffc0205078:	c119                	beqz	a0,ffffffffc020507e <skew_heap_merge.constprop.0+0xe6>
ffffffffc020507a:	01253023          	sd	s2,0(a0)
          b->left = l;
ffffffffc020507e:	01243423          	sd	s2,8(s0)
          b->right = r;
ffffffffc0205082:	01543823          	sd	s5,16(s0)
          if (l) l->parent = b;
ffffffffc0205086:	00893023          	sd	s0,0(s2)
          a->left = l;
ffffffffc020508a:	e480                	sd	s0,8(s1)
          a->right = r;
ffffffffc020508c:	0144b823          	sd	s4,16(s1)
          if (l) l->parent = a;
ffffffffc0205090:	e004                	sd	s1,0(s0)
ffffffffc0205092:	8526                	mv	a0,s1
ffffffffc0205094:	b769                	j	ffffffffc020501e <skew_heap_merge.constprop.0+0x86>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205096:	01053983          	ld	s3,16(a0)
          r = a->left;
ffffffffc020509a:	00853a83          	ld	s5,8(a0)
     if (a == NULL) return b;
ffffffffc020509e:	02098663          	beqz	s3,ffffffffc02050ca <skew_heap_merge.constprop.0+0x132>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc02050a2:	0189b783          	ld	a5,24(s3)
     else if (delta < 0)
ffffffffc02050a6:	40e7873b          	subw	a4,a5,a4
ffffffffc02050aa:	06074763          	bltz	a4,ffffffffc0205118 <skew_heap_merge.constprop.0+0x180>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02050ae:	01093583          	ld	a1,16(s2)
          r = b->left;
ffffffffc02050b2:	00893b03          	ld	s6,8(s2)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02050b6:	854e                	mv	a0,s3
ffffffffc02050b8:	ee1ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          b->left = l;
ffffffffc02050bc:	00a93423          	sd	a0,8(s2)
          b->right = r;
ffffffffc02050c0:	01693823          	sd	s6,16(s2)
          if (l) l->parent = b;
ffffffffc02050c4:	c119                	beqz	a0,ffffffffc02050ca <skew_heap_merge.constprop.0+0x132>
ffffffffc02050c6:	01253023          	sd	s2,0(a0)
          a->left = l;
ffffffffc02050ca:	0124b423          	sd	s2,8(s1)
          a->right = r;
ffffffffc02050ce:	0154b823          	sd	s5,16(s1)
          if (l) l->parent = a;
ffffffffc02050d2:	00993023          	sd	s1,0(s2)
ffffffffc02050d6:	bf3d                	j	ffffffffc0205014 <skew_heap_merge.constprop.0+0x7c>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02050d8:	01093503          	ld	a0,16(s2)
          r = a->left;
ffffffffc02050dc:	00893983          	ld	s3,8(s2)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02050e0:	844a                	mv	s0,s2
ffffffffc02050e2:	eb7ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc02050e6:	00a93423          	sd	a0,8(s2)
          a->right = r;
ffffffffc02050ea:	01393823          	sd	s3,16(s2)
          if (l) l->parent = a;
ffffffffc02050ee:	dd51                	beqz	a0,ffffffffc020508a <skew_heap_merge.constprop.0+0xf2>
ffffffffc02050f0:	01253023          	sd	s2,0(a0)
ffffffffc02050f4:	bf59                	j	ffffffffc020508a <skew_heap_merge.constprop.0+0xf2>
          if (l) l->parent = b;
ffffffffc02050f6:	89a6                	mv	s3,s1
ffffffffc02050f8:	b739                	j	ffffffffc0205006 <skew_heap_merge.constprop.0+0x6e>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02050fa:	01093503          	ld	a0,16(s2)
          r = a->left;
ffffffffc02050fe:	00893b03          	ld	s6,8(s2)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205102:	85ce                	mv	a1,s3
ffffffffc0205104:	e95ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc0205108:	00a93423          	sd	a0,8(s2)
          a->right = r;
ffffffffc020510c:	01693823          	sd	s6,16(s2)
          if (l) l->parent = a;
ffffffffc0205110:	d53d                	beqz	a0,ffffffffc020507e <skew_heap_merge.constprop.0+0xe6>
          if (l) l->parent = b;
ffffffffc0205112:	01253023          	sd	s2,0(a0)
ffffffffc0205116:	b7a5                	j	ffffffffc020507e <skew_heap_merge.constprop.0+0xe6>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205118:	0109b503          	ld	a0,16(s3)
          r = a->left;
ffffffffc020511c:	0089bb03          	ld	s6,8(s3)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205120:	85ca                	mv	a1,s2
ffffffffc0205122:	e77ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc0205126:	00a9b423          	sd	a0,8(s3)
          a->right = r;
ffffffffc020512a:	0169b823          	sd	s6,16(s3)
          if (l) l->parent = a;
ffffffffc020512e:	894e                	mv	s2,s3
ffffffffc0205130:	dd49                	beqz	a0,ffffffffc02050ca <skew_heap_merge.constprop.0+0x132>
          if (l) l->parent = b;
ffffffffc0205132:	01253023          	sd	s2,0(a0)
ffffffffc0205136:	bf51                	j	ffffffffc02050ca <skew_heap_merge.constprop.0+0x132>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205138:	6908                	ld	a0,16(a0)
          r = a->left;
ffffffffc020513a:	0084bb03          	ld	s6,8(s1)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020513e:	85ce                	mv	a1,s3
ffffffffc0205140:	e59ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc0205144:	e488                	sd	a0,8(s1)
          a->right = r;
ffffffffc0205146:	0164b823          	sd	s6,16(s1)
          if (l) l->parent = a;
ffffffffc020514a:	d555                	beqz	a0,ffffffffc02050f6 <skew_heap_merge.constprop.0+0x15e>
ffffffffc020514c:	e104                	sd	s1,0(a0)
ffffffffc020514e:	89a6                	mv	s3,s1
ffffffffc0205150:	bd5d                	j	ffffffffc0205006 <skew_heap_merge.constprop.0+0x6e>

ffffffffc0205152 <stride_enqueue>:
     if (proc->lab6_priority == 0)
ffffffffc0205152:	1485a783          	lw	a5,328(a1)
{
ffffffffc0205156:	7139                	addi	sp,sp,-64
ffffffffc0205158:	f822                	sd	s0,48(sp)
ffffffffc020515a:	f426                	sd	s1,40(sp)
ffffffffc020515c:	fc06                	sd	ra,56(sp)
ffffffffc020515e:	f04a                	sd	s2,32(sp)
ffffffffc0205160:	ec4e                	sd	s3,24(sp)
ffffffffc0205162:	e852                	sd	s4,16(sp)
ffffffffc0205164:	e456                	sd	s5,8(sp)
ffffffffc0205166:	842e                	mv	s0,a1
ffffffffc0205168:	84aa                	mv	s1,a0
     if (proc->lab6_priority == 0)
ffffffffc020516a:	e781                	bnez	a5,ffffffffc0205172 <stride_enqueue+0x20>
          proc->lab6_priority = 1;
ffffffffc020516c:	4785                	li	a5,1
ffffffffc020516e:	14f5a423          	sw	a5,328(a1)
     proc->time_slice = rq->max_time_slice;
ffffffffc0205172:	48dc                	lw	a5,20(s1)
     rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
ffffffffc0205174:	0184b903          	ld	s2,24(s1)
     a->left = a->right = a->parent = NULL;
ffffffffc0205178:	12043423          	sd	zero,296(s0)
     proc->time_slice = rq->max_time_slice;
ffffffffc020517c:	12f42023          	sw	a5,288(s0)
ffffffffc0205180:	12043c23          	sd	zero,312(s0)
ffffffffc0205184:	12043823          	sd	zero,304(s0)
     skew_heap_init(&(proc->lab6_run_pool));
ffffffffc0205188:	12840593          	addi	a1,s0,296
     if (a == NULL) return b;
ffffffffc020518c:	00090d63          	beqz	s2,ffffffffc02051a6 <stride_enqueue+0x54>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0205190:	14042703          	lw	a4,320(s0)
ffffffffc0205194:	01893783          	ld	a5,24(s2)
     else if (delta < 0)
ffffffffc0205198:	9f99                	subw	a5,a5,a4
ffffffffc020519a:	0207c563          	bltz	a5,ffffffffc02051c4 <stride_enqueue+0x72>
          b->left = l;
ffffffffc020519e:	13243823          	sd	s2,304(s0)
          if (l) l->parent = b;
ffffffffc02051a2:	00b93023          	sd	a1,0(s2)
     rq->proc_num++;
ffffffffc02051a6:	489c                	lw	a5,16(s1)
     rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
ffffffffc02051a8:	ec8c                	sd	a1,24(s1)
     proc->rq = rq;
ffffffffc02051aa:	10943423          	sd	s1,264(s0)
}
ffffffffc02051ae:	70e2                	ld	ra,56(sp)
ffffffffc02051b0:	7442                	ld	s0,48(sp)
     rq->proc_num++;
ffffffffc02051b2:	2785                	addiw	a5,a5,1
ffffffffc02051b4:	c89c                	sw	a5,16(s1)
}
ffffffffc02051b6:	7902                	ld	s2,32(sp)
ffffffffc02051b8:	74a2                	ld	s1,40(sp)
ffffffffc02051ba:	69e2                	ld	s3,24(sp)
ffffffffc02051bc:	6a42                	ld	s4,16(sp)
ffffffffc02051be:	6aa2                	ld	s5,8(sp)
ffffffffc02051c0:	6121                	addi	sp,sp,64
ffffffffc02051c2:	8082                	ret
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02051c4:	01093983          	ld	s3,16(s2)
          r = a->left;
ffffffffc02051c8:	00893a03          	ld	s4,8(s2)
     if (a == NULL) return b;
ffffffffc02051cc:	00098c63          	beqz	s3,ffffffffc02051e4 <stride_enqueue+0x92>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc02051d0:	0189b783          	ld	a5,24(s3)
     else if (delta < 0)
ffffffffc02051d4:	40e7873b          	subw	a4,a5,a4
ffffffffc02051d8:	00074e63          	bltz	a4,ffffffffc02051f4 <stride_enqueue+0xa2>
          b->left = l;
ffffffffc02051dc:	13343823          	sd	s3,304(s0)
          if (l) l->parent = b;
ffffffffc02051e0:	00b9b023          	sd	a1,0(s3)
          a->left = l;
ffffffffc02051e4:	00b93423          	sd	a1,8(s2)
          a->right = r;
ffffffffc02051e8:	01493823          	sd	s4,16(s2)
          if (l) l->parent = a;
ffffffffc02051ec:	0125b023          	sd	s2,0(a1)
ffffffffc02051f0:	85ca                	mv	a1,s2
ffffffffc02051f2:	bf55                	j	ffffffffc02051a6 <stride_enqueue+0x54>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02051f4:	0109b503          	ld	a0,16(s3)
          r = a->left;
ffffffffc02051f8:	0089ba83          	ld	s5,8(s3)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02051fc:	d9dff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc0205200:	00a9b423          	sd	a0,8(s3)
          a->right = r;
ffffffffc0205204:	0159b823          	sd	s5,16(s3)
          if (l) l->parent = a;
ffffffffc0205208:	85ce                	mv	a1,s3
ffffffffc020520a:	dd69                	beqz	a0,ffffffffc02051e4 <stride_enqueue+0x92>
ffffffffc020520c:	01353023          	sd	s3,0(a0)
ffffffffc0205210:	bfd1                	j	ffffffffc02051e4 <stride_enqueue+0x92>

ffffffffc0205212 <stride_dequeue>:
{
ffffffffc0205212:	711d                	addi	sp,sp,-96
ffffffffc0205214:	e0ca                	sd	s2,64(sp)
static inline skew_heap_entry_t *
skew_heap_remove(skew_heap_entry_t *a, skew_heap_entry_t *b,
                 compare_f comp)
{
     skew_heap_entry_t *p   = b->parent;
     skew_heap_entry_t *rep = skew_heap_merge(b->left, b->right, comp);
ffffffffc0205216:	1305b903          	ld	s2,304(a1)
ffffffffc020521a:	e8a2                	sd	s0,80(sp)
ffffffffc020521c:	e4a6                	sd	s1,72(sp)
ffffffffc020521e:	fc4e                	sd	s3,56(sp)
ffffffffc0205220:	f456                	sd	s5,40(sp)
ffffffffc0205222:	f05a                	sd	s6,32(sp)
ffffffffc0205224:	ec86                	sd	ra,88(sp)
ffffffffc0205226:	f852                	sd	s4,48(sp)
ffffffffc0205228:	ec5e                	sd	s7,24(sp)
ffffffffc020522a:	e862                	sd	s8,16(sp)
ffffffffc020522c:	e466                	sd	s9,8(sp)
ffffffffc020522e:	e06a                	sd	s10,0(sp)
     rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
ffffffffc0205230:	01853b03          	ld	s6,24(a0)
     skew_heap_entry_t *p   = b->parent;
ffffffffc0205234:	1285b983          	ld	s3,296(a1)
     skew_heap_entry_t *rep = skew_heap_merge(b->left, b->right, comp);
ffffffffc0205238:	1385b483          	ld	s1,312(a1)
{
ffffffffc020523c:	842e                	mv	s0,a1
ffffffffc020523e:	8aaa                	mv	s5,a0
     if (a == NULL) return b;
ffffffffc0205240:	12090863          	beqz	s2,ffffffffc0205370 <stride_dequeue+0x15e>
     else if (b == NULL) return a;
ffffffffc0205244:	12048d63          	beqz	s1,ffffffffc020537e <stride_dequeue+0x16c>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0205248:	01892783          	lw	a5,24(s2)
ffffffffc020524c:	4c98                	lw	a4,24(s1)
     else if (delta < 0)
ffffffffc020524e:	40e786bb          	subw	a3,a5,a4
ffffffffc0205252:	0a06c763          	bltz	a3,ffffffffc0205300 <stride_dequeue+0xee>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205256:	0104ba03          	ld	s4,16(s1)
          r = b->left;
ffffffffc020525a:	0084bc03          	ld	s8,8(s1)
     else if (b == NULL) return a;
ffffffffc020525e:	040a0963          	beqz	s4,ffffffffc02052b0 <stride_dequeue+0x9e>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0205262:	018a2703          	lw	a4,24(s4)
     else if (delta < 0)
ffffffffc0205266:	40e786bb          	subw	a3,a5,a4
ffffffffc020526a:	1006ce63          	bltz	a3,ffffffffc0205386 <stride_dequeue+0x174>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020526e:	010a3b83          	ld	s7,16(s4)
          r = b->left;
ffffffffc0205272:	008a3c83          	ld	s9,8(s4)
     else if (b == NULL) return a;
ffffffffc0205276:	020b8663          	beqz	s7,ffffffffc02052a2 <stride_dequeue+0x90>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc020527a:	018bb703          	ld	a4,24(s7)
     else if (delta < 0)
ffffffffc020527e:	9f99                	subw	a5,a5,a4
ffffffffc0205280:	1a07c363          	bltz	a5,ffffffffc0205426 <stride_dequeue+0x214>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205284:	010bb583          	ld	a1,16(s7)
          r = b->left;
ffffffffc0205288:	008bbd03          	ld	s10,8(s7)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020528c:	854a                	mv	a0,s2
ffffffffc020528e:	d0bff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          b->left = l;
ffffffffc0205292:	00abb423          	sd	a0,8(s7)
          b->right = r;
ffffffffc0205296:	01abb823          	sd	s10,16(s7)
          if (l) l->parent = b;
ffffffffc020529a:	895e                	mv	s2,s7
ffffffffc020529c:	c119                	beqz	a0,ffffffffc02052a2 <stride_dequeue+0x90>
ffffffffc020529e:	01253023          	sd	s2,0(a0)
          b->left = l;
ffffffffc02052a2:	012a3423          	sd	s2,8(s4)
          b->right = r;
ffffffffc02052a6:	019a3823          	sd	s9,16(s4)
          if (l) l->parent = b;
ffffffffc02052aa:	01493023          	sd	s4,0(s2)
ffffffffc02052ae:	8952                	mv	s2,s4
          b->left = l;
ffffffffc02052b0:	0124b423          	sd	s2,8(s1)
          b->right = r;
ffffffffc02052b4:	0184b823          	sd	s8,16(s1)
          if (l) l->parent = b;
ffffffffc02052b8:	00993023          	sd	s1,0(s2)
     if (rep) rep->parent = p;
ffffffffc02052bc:	0134b023          	sd	s3,0(s1)
     
     if (p)
ffffffffc02052c0:	0a098663          	beqz	s3,ffffffffc020536c <stride_dequeue+0x15a>
     {
          if (p->left == b)
ffffffffc02052c4:	0089b783          	ld	a5,8(s3)
     rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
ffffffffc02052c8:	12840413          	addi	s0,s0,296
ffffffffc02052cc:	0a878663          	beq	a5,s0,ffffffffc0205378 <stride_dequeue+0x166>
               p->left = rep;
          else p->right = rep;
ffffffffc02052d0:	0099b823          	sd	s1,16(s3)
     if (rq->proc_num > 0)
ffffffffc02052d4:	010aa783          	lw	a5,16(s5)
     rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
ffffffffc02052d8:	016abc23          	sd	s6,24(s5)
     if (rq->proc_num > 0)
ffffffffc02052dc:	c781                	beqz	a5,ffffffffc02052e4 <stride_dequeue+0xd2>
          rq->proc_num--;
ffffffffc02052de:	37fd                	addiw	a5,a5,-1
ffffffffc02052e0:	00faa823          	sw	a5,16(s5)
}
ffffffffc02052e4:	60e6                	ld	ra,88(sp)
ffffffffc02052e6:	6446                	ld	s0,80(sp)
ffffffffc02052e8:	64a6                	ld	s1,72(sp)
ffffffffc02052ea:	6906                	ld	s2,64(sp)
ffffffffc02052ec:	79e2                	ld	s3,56(sp)
ffffffffc02052ee:	7a42                	ld	s4,48(sp)
ffffffffc02052f0:	7aa2                	ld	s5,40(sp)
ffffffffc02052f2:	7b02                	ld	s6,32(sp)
ffffffffc02052f4:	6be2                	ld	s7,24(sp)
ffffffffc02052f6:	6c42                	ld	s8,16(sp)
ffffffffc02052f8:	6ca2                	ld	s9,8(sp)
ffffffffc02052fa:	6d02                	ld	s10,0(sp)
ffffffffc02052fc:	6125                	addi	sp,sp,96
ffffffffc02052fe:	8082                	ret
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205300:	01093a03          	ld	s4,16(s2)
          r = a->left;
ffffffffc0205304:	00893c03          	ld	s8,8(s2)
     if (a == NULL) return b;
ffffffffc0205308:	040a0863          	beqz	s4,ffffffffc0205358 <stride_dequeue+0x146>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc020530c:	018a2783          	lw	a5,24(s4)
     else if (delta < 0)
ffffffffc0205310:	40e7873b          	subw	a4,a5,a4
ffffffffc0205314:	0a074a63          	bltz	a4,ffffffffc02053c8 <stride_dequeue+0x1b6>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205318:	0104bb83          	ld	s7,16(s1)
          r = b->left;
ffffffffc020531c:	0084bc83          	ld	s9,8(s1)
     else if (b == NULL) return a;
ffffffffc0205320:	020b8663          	beqz	s7,ffffffffc020534c <stride_dequeue+0x13a>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0205324:	018bb703          	ld	a4,24(s7)
     else if (delta < 0)
ffffffffc0205328:	9f99                	subw	a5,a5,a4
ffffffffc020532a:	0a07cf63          	bltz	a5,ffffffffc02053e8 <stride_dequeue+0x1d6>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020532e:	010bb583          	ld	a1,16(s7)
          r = b->left;
ffffffffc0205332:	008bbd03          	ld	s10,8(s7)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc0205336:	8552                	mv	a0,s4
ffffffffc0205338:	c61ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          b->left = l;
ffffffffc020533c:	00abb423          	sd	a0,8(s7)
          b->right = r;
ffffffffc0205340:	01abb823          	sd	s10,16(s7)
          if (l) l->parent = b;
ffffffffc0205344:	8a5e                	mv	s4,s7
ffffffffc0205346:	c119                	beqz	a0,ffffffffc020534c <stride_dequeue+0x13a>
ffffffffc0205348:	01453023          	sd	s4,0(a0)
          b->left = l;
ffffffffc020534c:	0144b423          	sd	s4,8(s1)
          b->right = r;
ffffffffc0205350:	0194b823          	sd	s9,16(s1)
          if (l) l->parent = b;
ffffffffc0205354:	009a3023          	sd	s1,0(s4)
          a->left = l;
ffffffffc0205358:	00993423          	sd	s1,8(s2)
          a->right = r;
ffffffffc020535c:	01893823          	sd	s8,16(s2)
          if (l) l->parent = a;
ffffffffc0205360:	0124b023          	sd	s2,0(s1)
ffffffffc0205364:	84ca                	mv	s1,s2
     if (rep) rep->parent = p;
ffffffffc0205366:	0134b023          	sd	s3,0(s1)
ffffffffc020536a:	bf99                	j	ffffffffc02052c0 <stride_dequeue+0xae>
ffffffffc020536c:	8b26                	mv	s6,s1
ffffffffc020536e:	b79d                	j	ffffffffc02052d4 <stride_dequeue+0xc2>
ffffffffc0205370:	d8a1                	beqz	s1,ffffffffc02052c0 <stride_dequeue+0xae>
ffffffffc0205372:	0134b023          	sd	s3,0(s1)
ffffffffc0205376:	b7a9                	j	ffffffffc02052c0 <stride_dequeue+0xae>
               p->left = rep;
ffffffffc0205378:	0099b423          	sd	s1,8(s3)
ffffffffc020537c:	bfa1                	j	ffffffffc02052d4 <stride_dequeue+0xc2>
ffffffffc020537e:	84ca                	mv	s1,s2
     if (rep) rep->parent = p;
ffffffffc0205380:	0134b023          	sd	s3,0(s1)
ffffffffc0205384:	bf35                	j	ffffffffc02052c0 <stride_dequeue+0xae>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205386:	01093b83          	ld	s7,16(s2)
          r = a->left;
ffffffffc020538a:	00893c83          	ld	s9,8(s2)
     if (a == NULL) return b;
ffffffffc020538e:	020b8663          	beqz	s7,ffffffffc02053ba <stride_dequeue+0x1a8>
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
ffffffffc0205392:	018bb783          	ld	a5,24(s7)
     else if (delta < 0)
ffffffffc0205396:	40e7873b          	subw	a4,a5,a4
ffffffffc020539a:	06074663          	bltz	a4,ffffffffc0205406 <stride_dequeue+0x1f4>
          l = skew_heap_merge(a, b->right, comp);
ffffffffc020539e:	010a3583          	ld	a1,16(s4)
          r = b->left;
ffffffffc02053a2:	008a3d03          	ld	s10,8(s4)
          l = skew_heap_merge(a, b->right, comp);
ffffffffc02053a6:	855e                	mv	a0,s7
ffffffffc02053a8:	bf1ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          b->left = l;
ffffffffc02053ac:	00aa3423          	sd	a0,8(s4)
          b->right = r;
ffffffffc02053b0:	01aa3823          	sd	s10,16(s4)
          if (l) l->parent = b;
ffffffffc02053b4:	c119                	beqz	a0,ffffffffc02053ba <stride_dequeue+0x1a8>
ffffffffc02053b6:	01453023          	sd	s4,0(a0)
          a->left = l;
ffffffffc02053ba:	01493423          	sd	s4,8(s2)
          a->right = r;
ffffffffc02053be:	01993823          	sd	s9,16(s2)
          if (l) l->parent = a;
ffffffffc02053c2:	012a3023          	sd	s2,0(s4)
ffffffffc02053c6:	b5ed                	j	ffffffffc02052b0 <stride_dequeue+0x9e>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02053c8:	010a3503          	ld	a0,16(s4)
          r = a->left;
ffffffffc02053cc:	008a3b83          	ld	s7,8(s4)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02053d0:	85a6                	mv	a1,s1
ffffffffc02053d2:	bc7ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc02053d6:	00aa3423          	sd	a0,8(s4)
          a->right = r;
ffffffffc02053da:	017a3823          	sd	s7,16(s4)
          if (l) l->parent = a;
ffffffffc02053de:	84d2                	mv	s1,s4
ffffffffc02053e0:	dd25                	beqz	a0,ffffffffc0205358 <stride_dequeue+0x146>
ffffffffc02053e2:	01453023          	sd	s4,0(a0)
ffffffffc02053e6:	bf8d                	j	ffffffffc0205358 <stride_dequeue+0x146>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02053e8:	010a3503          	ld	a0,16(s4)
          r = a->left;
ffffffffc02053ec:	008a3d03          	ld	s10,8(s4)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc02053f0:	85de                	mv	a1,s7
ffffffffc02053f2:	ba7ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc02053f6:	00aa3423          	sd	a0,8(s4)
          a->right = r;
ffffffffc02053fa:	01aa3823          	sd	s10,16(s4)
          if (l) l->parent = a;
ffffffffc02053fe:	d539                	beqz	a0,ffffffffc020534c <stride_dequeue+0x13a>
          if (l) l->parent = b;
ffffffffc0205400:	01453023          	sd	s4,0(a0)
ffffffffc0205404:	b7a1                	j	ffffffffc020534c <stride_dequeue+0x13a>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205406:	010bb503          	ld	a0,16(s7)
          r = a->left;
ffffffffc020540a:	008bbd03          	ld	s10,8(s7)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020540e:	85d2                	mv	a1,s4
ffffffffc0205410:	b89ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc0205414:	00abb423          	sd	a0,8(s7)
          a->right = r;
ffffffffc0205418:	01abb823          	sd	s10,16(s7)
          if (l) l->parent = a;
ffffffffc020541c:	8a5e                	mv	s4,s7
ffffffffc020541e:	dd51                	beqz	a0,ffffffffc02053ba <stride_dequeue+0x1a8>
          if (l) l->parent = b;
ffffffffc0205420:	01453023          	sd	s4,0(a0)
ffffffffc0205424:	bf59                	j	ffffffffc02053ba <stride_dequeue+0x1a8>
          l = skew_heap_merge(a->right, b, comp);
ffffffffc0205426:	01093503          	ld	a0,16(s2)
          r = a->left;
ffffffffc020542a:	00893d03          	ld	s10,8(s2)
          l = skew_heap_merge(a->right, b, comp);
ffffffffc020542e:	85de                	mv	a1,s7
ffffffffc0205430:	b69ff0ef          	jal	ra,ffffffffc0204f98 <skew_heap_merge.constprop.0>
          a->left = l;
ffffffffc0205434:	00a93423          	sd	a0,8(s2)
          a->right = r;
ffffffffc0205438:	01a93823          	sd	s10,16(s2)
          if (l) l->parent = a;
ffffffffc020543c:	e60511e3          	bnez	a0,ffffffffc020529e <stride_dequeue+0x8c>
ffffffffc0205440:	b58d                	j	ffffffffc02052a2 <stride_dequeue+0x90>

ffffffffc0205442 <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void sched_class_proc_tick(struct proc_struct *proc)
{
    if (proc != idleproc)
ffffffffc0205442:	000c1797          	auipc	a5,0xc1
ffffffffc0205446:	7a67b783          	ld	a5,1958(a5) # ffffffffc02c6be8 <idleproc>
{
ffffffffc020544a:	85aa                	mv	a1,a0
    if (proc != idleproc)
ffffffffc020544c:	00a78c63          	beq	a5,a0,ffffffffc0205464 <sched_class_proc_tick+0x22>
    {
        sched_class->proc_tick(rq, proc);
ffffffffc0205450:	000c1797          	auipc	a5,0xc1
ffffffffc0205454:	7b87b783          	ld	a5,1976(a5) # ffffffffc02c6c08 <sched_class>
ffffffffc0205458:	779c                	ld	a5,40(a5)
ffffffffc020545a:	000c1517          	auipc	a0,0xc1
ffffffffc020545e:	7a653503          	ld	a0,1958(a0) # ffffffffc02c6c00 <rq>
ffffffffc0205462:	8782                	jr	a5
    }
    else
    {
        proc->need_resched = 1;
ffffffffc0205464:	4705                	li	a4,1
ffffffffc0205466:	ef98                	sd	a4,24(a5)
    }
}
ffffffffc0205468:	8082                	ret

ffffffffc020546a <sched_init>:

static struct run_queue __rq;

void sched_init(void)
{
ffffffffc020546a:	1141                	addi	sp,sp,-16
    list_init(&timer_list);

    // LAB6 Stride: switch to stride scheduler
    sched_class = &stride_sched_class;
ffffffffc020546c:	000bd717          	auipc	a4,0xbd
ffffffffc0205470:	28470713          	addi	a4,a4,644 # ffffffffc02c26f0 <stride_sched_class>
{
ffffffffc0205474:	e022                	sd	s0,0(sp)
ffffffffc0205476:	e406                	sd	ra,8(sp)
ffffffffc0205478:	000c1797          	auipc	a5,0xc1
ffffffffc020547c:	70078793          	addi	a5,a5,1792 # ffffffffc02c6b78 <timer_list>

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
ffffffffc0205480:	6714                	ld	a3,8(a4)
    rq = &__rq;
ffffffffc0205482:	000c1517          	auipc	a0,0xc1
ffffffffc0205486:	6d650513          	addi	a0,a0,1750 # ffffffffc02c6b58 <__rq>
ffffffffc020548a:	e79c                	sd	a5,8(a5)
ffffffffc020548c:	e39c                	sd	a5,0(a5)
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc020548e:	4789                	li	a5,2
ffffffffc0205490:	c95c                	sw	a5,20(a0)
    sched_class = &stride_sched_class;
ffffffffc0205492:	000c1417          	auipc	s0,0xc1
ffffffffc0205496:	77640413          	addi	s0,s0,1910 # ffffffffc02c6c08 <sched_class>
    rq = &__rq;
ffffffffc020549a:	000c1797          	auipc	a5,0xc1
ffffffffc020549e:	76a7b323          	sd	a0,1894(a5) # ffffffffc02c6c00 <rq>
    sched_class = &stride_sched_class;
ffffffffc02054a2:	e018                	sd	a4,0(s0)
    sched_class->init(rq);
ffffffffc02054a4:	9682                	jalr	a3

    cprintf("sched class: %s\n", sched_class->name);
ffffffffc02054a6:	601c                	ld	a5,0(s0)
}
ffffffffc02054a8:	6402                	ld	s0,0(sp)
ffffffffc02054aa:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc02054ac:	638c                	ld	a1,0(a5)
ffffffffc02054ae:	00002517          	auipc	a0,0x2
ffffffffc02054b2:	3fa50513          	addi	a0,a0,1018 # ffffffffc02078a8 <default_pmm_manager+0xe78>
}
ffffffffc02054b6:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc02054b8:	ce1fa06f          	j	ffffffffc0200198 <cprintf>

ffffffffc02054bc <wakeup_proc>:

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02054bc:	4118                	lw	a4,0(a0)
{
ffffffffc02054be:	1101                	addi	sp,sp,-32
ffffffffc02054c0:	ec06                	sd	ra,24(sp)
ffffffffc02054c2:	e822                	sd	s0,16(sp)
ffffffffc02054c4:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02054c6:	478d                	li	a5,3
ffffffffc02054c8:	08f70363          	beq	a4,a5,ffffffffc020554e <wakeup_proc+0x92>
ffffffffc02054cc:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02054ce:	100027f3          	csrr	a5,sstatus
ffffffffc02054d2:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02054d4:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02054d6:	e7bd                	bnez	a5,ffffffffc0205544 <wakeup_proc+0x88>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc02054d8:	4789                	li	a5,2
ffffffffc02054da:	04f70863          	beq	a4,a5,ffffffffc020552a <wakeup_proc+0x6e>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc02054de:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc02054e0:	0e042623          	sw	zero,236(s0)
            if (proc != current)
ffffffffc02054e4:	000c1797          	auipc	a5,0xc1
ffffffffc02054e8:	6fc7b783          	ld	a5,1788(a5) # ffffffffc02c6be0 <current>
ffffffffc02054ec:	02878363          	beq	a5,s0,ffffffffc0205512 <wakeup_proc+0x56>
    if (proc != idleproc)
ffffffffc02054f0:	000c1797          	auipc	a5,0xc1
ffffffffc02054f4:	6f87b783          	ld	a5,1784(a5) # ffffffffc02c6be8 <idleproc>
ffffffffc02054f8:	00f40d63          	beq	s0,a5,ffffffffc0205512 <wakeup_proc+0x56>
        sched_class->enqueue(rq, proc);
ffffffffc02054fc:	000c1797          	auipc	a5,0xc1
ffffffffc0205500:	70c7b783          	ld	a5,1804(a5) # ffffffffc02c6c08 <sched_class>
ffffffffc0205504:	6b9c                	ld	a5,16(a5)
ffffffffc0205506:	85a2                	mv	a1,s0
ffffffffc0205508:	000c1517          	auipc	a0,0xc1
ffffffffc020550c:	6f853503          	ld	a0,1784(a0) # ffffffffc02c6c00 <rq>
ffffffffc0205510:	9782                	jalr	a5
    if (flag)
ffffffffc0205512:	e491                	bnez	s1,ffffffffc020551e <wakeup_proc+0x62>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205514:	60e2                	ld	ra,24(sp)
ffffffffc0205516:	6442                	ld	s0,16(sp)
ffffffffc0205518:	64a2                	ld	s1,8(sp)
ffffffffc020551a:	6105                	addi	sp,sp,32
ffffffffc020551c:	8082                	ret
ffffffffc020551e:	6442                	ld	s0,16(sp)
ffffffffc0205520:	60e2                	ld	ra,24(sp)
ffffffffc0205522:	64a2                	ld	s1,8(sp)
ffffffffc0205524:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205526:	c82fb06f          	j	ffffffffc02009a8 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc020552a:	00002617          	auipc	a2,0x2
ffffffffc020552e:	3ce60613          	addi	a2,a2,974 # ffffffffc02078f8 <default_pmm_manager+0xec8>
ffffffffc0205532:	05200593          	li	a1,82
ffffffffc0205536:	00002517          	auipc	a0,0x2
ffffffffc020553a:	3aa50513          	addi	a0,a0,938 # ffffffffc02078e0 <default_pmm_manager+0xeb0>
ffffffffc020553e:	fbdfa0ef          	jal	ra,ffffffffc02004fa <__warn>
ffffffffc0205542:	bfc1                	j	ffffffffc0205512 <wakeup_proc+0x56>
        intr_disable();
ffffffffc0205544:	c6afb0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205548:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc020554a:	4485                	li	s1,1
ffffffffc020554c:	b771                	j	ffffffffc02054d8 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020554e:	00002697          	auipc	a3,0x2
ffffffffc0205552:	37268693          	addi	a3,a3,882 # ffffffffc02078c0 <default_pmm_manager+0xe90>
ffffffffc0205556:	00001617          	auipc	a2,0x1
ffffffffc020555a:	12a60613          	addi	a2,a2,298 # ffffffffc0206680 <commands+0x818>
ffffffffc020555e:	04300593          	li	a1,67
ffffffffc0205562:	00002517          	auipc	a0,0x2
ffffffffc0205566:	37e50513          	addi	a0,a0,894 # ffffffffc02078e0 <default_pmm_manager+0xeb0>
ffffffffc020556a:	f29fa0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020556e <schedule>:

void schedule(void)
{
ffffffffc020556e:	7179                	addi	sp,sp,-48
ffffffffc0205570:	f406                	sd	ra,40(sp)
ffffffffc0205572:	f022                	sd	s0,32(sp)
ffffffffc0205574:	ec26                	sd	s1,24(sp)
ffffffffc0205576:	e84a                	sd	s2,16(sp)
ffffffffc0205578:	e44e                	sd	s3,8(sp)
ffffffffc020557a:	e052                	sd	s4,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020557c:	100027f3          	csrr	a5,sstatus
ffffffffc0205580:	8b89                	andi	a5,a5,2
ffffffffc0205582:	4a01                	li	s4,0
ffffffffc0205584:	e3cd                	bnez	a5,ffffffffc0205626 <schedule+0xb8>
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205586:	000c1497          	auipc	s1,0xc1
ffffffffc020558a:	65a48493          	addi	s1,s1,1626 # ffffffffc02c6be0 <current>
ffffffffc020558e:	608c                	ld	a1,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc0205590:	000c1997          	auipc	s3,0xc1
ffffffffc0205594:	67898993          	addi	s3,s3,1656 # ffffffffc02c6c08 <sched_class>
ffffffffc0205598:	000c1917          	auipc	s2,0xc1
ffffffffc020559c:	66890913          	addi	s2,s2,1640 # ffffffffc02c6c00 <rq>
        if (current->state == PROC_RUNNABLE)
ffffffffc02055a0:	4194                	lw	a3,0(a1)
        current->need_resched = 0;
ffffffffc02055a2:	0005bc23          	sd	zero,24(a1)
        if (current->state == PROC_RUNNABLE)
ffffffffc02055a6:	4709                	li	a4,2
        sched_class->enqueue(rq, proc);
ffffffffc02055a8:	0009b783          	ld	a5,0(s3)
ffffffffc02055ac:	00093503          	ld	a0,0(s2)
        if (current->state == PROC_RUNNABLE)
ffffffffc02055b0:	04e68e63          	beq	a3,a4,ffffffffc020560c <schedule+0x9e>
    return sched_class->pick_next(rq);
ffffffffc02055b4:	739c                	ld	a5,32(a5)
ffffffffc02055b6:	9782                	jalr	a5
ffffffffc02055b8:	842a                	mv	s0,a0
        {
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL)
ffffffffc02055ba:	c521                	beqz	a0,ffffffffc0205602 <schedule+0x94>
    sched_class->dequeue(rq, proc);
ffffffffc02055bc:	0009b783          	ld	a5,0(s3)
ffffffffc02055c0:	00093503          	ld	a0,0(s2)
ffffffffc02055c4:	85a2                	mv	a1,s0
ffffffffc02055c6:	6f9c                	ld	a5,24(a5)
ffffffffc02055c8:	9782                	jalr	a5
        }
        if (next == NULL)
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02055ca:	441c                	lw	a5,8(s0)
        if (next != current)
ffffffffc02055cc:	6098                	ld	a4,0(s1)
        next->runs++;
ffffffffc02055ce:	2785                	addiw	a5,a5,1
ffffffffc02055d0:	c41c                	sw	a5,8(s0)
        if (next != current)
ffffffffc02055d2:	00870563          	beq	a4,s0,ffffffffc02055dc <schedule+0x6e>
        {
            proc_run(next);
ffffffffc02055d6:	8522                	mv	a0,s0
ffffffffc02055d8:	801fe0ef          	jal	ra,ffffffffc0203dd8 <proc_run>
    if (flag)
ffffffffc02055dc:	000a1a63          	bnez	s4,ffffffffc02055f0 <schedule+0x82>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02055e0:	70a2                	ld	ra,40(sp)
ffffffffc02055e2:	7402                	ld	s0,32(sp)
ffffffffc02055e4:	64e2                	ld	s1,24(sp)
ffffffffc02055e6:	6942                	ld	s2,16(sp)
ffffffffc02055e8:	69a2                	ld	s3,8(sp)
ffffffffc02055ea:	6a02                	ld	s4,0(sp)
ffffffffc02055ec:	6145                	addi	sp,sp,48
ffffffffc02055ee:	8082                	ret
ffffffffc02055f0:	7402                	ld	s0,32(sp)
ffffffffc02055f2:	70a2                	ld	ra,40(sp)
ffffffffc02055f4:	64e2                	ld	s1,24(sp)
ffffffffc02055f6:	6942                	ld	s2,16(sp)
ffffffffc02055f8:	69a2                	ld	s3,8(sp)
ffffffffc02055fa:	6a02                	ld	s4,0(sp)
ffffffffc02055fc:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02055fe:	baafb06f          	j	ffffffffc02009a8 <intr_enable>
            next = idleproc;
ffffffffc0205602:	000c1417          	auipc	s0,0xc1
ffffffffc0205606:	5e643403          	ld	s0,1510(s0) # ffffffffc02c6be8 <idleproc>
ffffffffc020560a:	b7c1                	j	ffffffffc02055ca <schedule+0x5c>
    if (proc != idleproc)
ffffffffc020560c:	000c1717          	auipc	a4,0xc1
ffffffffc0205610:	5dc73703          	ld	a4,1500(a4) # ffffffffc02c6be8 <idleproc>
ffffffffc0205614:	fae580e3          	beq	a1,a4,ffffffffc02055b4 <schedule+0x46>
        sched_class->enqueue(rq, proc);
ffffffffc0205618:	6b9c                	ld	a5,16(a5)
ffffffffc020561a:	9782                	jalr	a5
    return sched_class->pick_next(rq);
ffffffffc020561c:	0009b783          	ld	a5,0(s3)
ffffffffc0205620:	00093503          	ld	a0,0(s2)
ffffffffc0205624:	bf41                	j	ffffffffc02055b4 <schedule+0x46>
        intr_disable();
ffffffffc0205626:	b88fb0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc020562a:	4a05                	li	s4,1
ffffffffc020562c:	bfa9                	j	ffffffffc0205586 <schedule+0x18>

ffffffffc020562e <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020562e:	000c1797          	auipc	a5,0xc1
ffffffffc0205632:	5b27b783          	ld	a5,1458(a5) # ffffffffc02c6be0 <current>
}
ffffffffc0205636:	43c8                	lw	a0,4(a5)
ffffffffc0205638:	8082                	ret

ffffffffc020563a <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc020563a:	4501                	li	a0,0
ffffffffc020563c:	8082                	ret

ffffffffc020563e <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc020563e:	000c1797          	auipc	a5,0xc1
ffffffffc0205642:	5527b783          	ld	a5,1362(a5) # ffffffffc02c6b90 <ticks>
ffffffffc0205646:	0027951b          	slliw	a0,a5,0x2
ffffffffc020564a:	9d3d                	addw	a0,a0,a5
}
ffffffffc020564c:	0015151b          	slliw	a0,a0,0x1
ffffffffc0205650:	8082                	ret

ffffffffc0205652 <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc0205652:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc0205654:	1141                	addi	sp,sp,-16
ffffffffc0205656:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc0205658:	853ff0ef          	jal	ra,ffffffffc0204eaa <lab6_set_priority>
    return 0;
}
ffffffffc020565c:	60a2                	ld	ra,8(sp)
ffffffffc020565e:	4501                	li	a0,0
ffffffffc0205660:	0141                	addi	sp,sp,16
ffffffffc0205662:	8082                	ret

ffffffffc0205664 <sys_putc>:
    cputchar(c);
ffffffffc0205664:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205666:	1141                	addi	sp,sp,-16
ffffffffc0205668:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc020566a:	b65fa0ef          	jal	ra,ffffffffc02001ce <cputchar>
}
ffffffffc020566e:	60a2                	ld	ra,8(sp)
ffffffffc0205670:	4501                	li	a0,0
ffffffffc0205672:	0141                	addi	sp,sp,16
ffffffffc0205674:	8082                	ret

ffffffffc0205676 <sys_kill>:
    return do_kill(pid);
ffffffffc0205676:	4108                	lw	a0,0(a0)
ffffffffc0205678:	e04ff06f          	j	ffffffffc0204c7c <do_kill>

ffffffffc020567c <sys_yield>:
    return do_yield();
ffffffffc020567c:	db2ff06f          	j	ffffffffc0204c2e <do_yield>

ffffffffc0205680 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205680:	6d14                	ld	a3,24(a0)
ffffffffc0205682:	6910                	ld	a2,16(a0)
ffffffffc0205684:	650c                	ld	a1,8(a0)
ffffffffc0205686:	6108                	ld	a0,0(a0)
ffffffffc0205688:	ffdfe06f          	j	ffffffffc0204684 <do_execve>

ffffffffc020568c <sys_wait>:
    return do_wait(pid, store);
ffffffffc020568c:	650c                	ld	a1,8(a0)
ffffffffc020568e:	4108                	lw	a0,0(a0)
ffffffffc0205690:	daeff06f          	j	ffffffffc0204c3e <do_wait>

ffffffffc0205694 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205694:	000c1797          	auipc	a5,0xc1
ffffffffc0205698:	54c7b783          	ld	a5,1356(a5) # ffffffffc02c6be0 <current>
ffffffffc020569c:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020569e:	4501                	li	a0,0
ffffffffc02056a0:	6a0c                	ld	a1,16(a2)
ffffffffc02056a2:	facfe06f          	j	ffffffffc0203e4e <do_fork>

ffffffffc02056a6 <sys_exit>:
    return do_exit(error_code);
ffffffffc02056a6:	4108                	lw	a0,0(a0)
ffffffffc02056a8:	b9dfe06f          	j	ffffffffc0204244 <do_exit>

ffffffffc02056ac <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02056ac:	715d                	addi	sp,sp,-80
ffffffffc02056ae:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02056b0:	000c1497          	auipc	s1,0xc1
ffffffffc02056b4:	53048493          	addi	s1,s1,1328 # ffffffffc02c6be0 <current>
ffffffffc02056b8:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02056ba:	e0a2                	sd	s0,64(sp)
ffffffffc02056bc:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02056be:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02056c0:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02056c2:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc02056c6:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02056ca:	0327ee63          	bltu	a5,s2,ffffffffc0205706 <syscall+0x5a>
        if (syscalls[num] != NULL) {
ffffffffc02056ce:	00391713          	slli	a4,s2,0x3
ffffffffc02056d2:	00002797          	auipc	a5,0x2
ffffffffc02056d6:	28e78793          	addi	a5,a5,654 # ffffffffc0207960 <syscalls>
ffffffffc02056da:	97ba                	add	a5,a5,a4
ffffffffc02056dc:	639c                	ld	a5,0(a5)
ffffffffc02056de:	c785                	beqz	a5,ffffffffc0205706 <syscall+0x5a>
            arg[0] = tf->gpr.a1;
ffffffffc02056e0:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02056e2:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02056e4:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02056e6:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02056e8:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02056ea:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02056ec:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02056ee:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02056f0:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02056f2:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02056f4:	0028                	addi	a0,sp,8
ffffffffc02056f6:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02056f8:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02056fa:	e828                	sd	a0,80(s0)
}
ffffffffc02056fc:	6406                	ld	s0,64(sp)
ffffffffc02056fe:	74e2                	ld	s1,56(sp)
ffffffffc0205700:	7942                	ld	s2,48(sp)
ffffffffc0205702:	6161                	addi	sp,sp,80
ffffffffc0205704:	8082                	ret
    print_trapframe(tf);
ffffffffc0205706:	8522                	mv	a0,s0
ffffffffc0205708:	c96fb0ef          	jal	ra,ffffffffc0200b9e <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc020570c:	609c                	ld	a5,0(s1)
ffffffffc020570e:	86ca                	mv	a3,s2
ffffffffc0205710:	00002617          	auipc	a2,0x2
ffffffffc0205714:	20860613          	addi	a2,a2,520 # ffffffffc0207918 <default_pmm_manager+0xee8>
ffffffffc0205718:	43d8                	lw	a4,4(a5)
ffffffffc020571a:	06c00593          	li	a1,108
ffffffffc020571e:	0b478793          	addi	a5,a5,180
ffffffffc0205722:	00002517          	auipc	a0,0x2
ffffffffc0205726:	22650513          	addi	a0,a0,550 # ffffffffc0207948 <default_pmm_manager+0xf18>
ffffffffc020572a:	d69fa0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020572e <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020572e:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205732:	2785                	addiw	a5,a5,1
ffffffffc0205734:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205738:	02000793          	li	a5,32
ffffffffc020573c:	9f8d                	subw	a5,a5,a1
}
ffffffffc020573e:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205742:	8082                	ret

ffffffffc0205744 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205744:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205748:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020574a:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020574e:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205750:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205754:	f022                	sd	s0,32(sp)
ffffffffc0205756:	ec26                	sd	s1,24(sp)
ffffffffc0205758:	e84a                	sd	s2,16(sp)
ffffffffc020575a:	f406                	sd	ra,40(sp)
ffffffffc020575c:	e44e                	sd	s3,8(sp)
ffffffffc020575e:	84aa                	mv	s1,a0
ffffffffc0205760:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205762:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205766:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205768:	03067e63          	bgeu	a2,a6,ffffffffc02057a4 <printnum+0x60>
ffffffffc020576c:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020576e:	00805763          	blez	s0,ffffffffc020577c <printnum+0x38>
ffffffffc0205772:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205774:	85ca                	mv	a1,s2
ffffffffc0205776:	854e                	mv	a0,s3
ffffffffc0205778:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020577a:	fc65                	bnez	s0,ffffffffc0205772 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020577c:	1a02                	slli	s4,s4,0x20
ffffffffc020577e:	00003797          	auipc	a5,0x3
ffffffffc0205782:	9e278793          	addi	a5,a5,-1566 # ffffffffc0208160 <syscalls+0x800>
ffffffffc0205786:	020a5a13          	srli	s4,s4,0x20
ffffffffc020578a:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020578c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020578e:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205792:	70a2                	ld	ra,40(sp)
ffffffffc0205794:	69a2                	ld	s3,8(sp)
ffffffffc0205796:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205798:	85ca                	mv	a1,s2
ffffffffc020579a:	87a6                	mv	a5,s1
}
ffffffffc020579c:	6942                	ld	s2,16(sp)
ffffffffc020579e:	64e2                	ld	s1,24(sp)
ffffffffc02057a0:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02057a2:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02057a4:	03065633          	divu	a2,a2,a6
ffffffffc02057a8:	8722                	mv	a4,s0
ffffffffc02057aa:	f9bff0ef          	jal	ra,ffffffffc0205744 <printnum>
ffffffffc02057ae:	b7f9                	j	ffffffffc020577c <printnum+0x38>

ffffffffc02057b0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02057b0:	7119                	addi	sp,sp,-128
ffffffffc02057b2:	f4a6                	sd	s1,104(sp)
ffffffffc02057b4:	f0ca                	sd	s2,96(sp)
ffffffffc02057b6:	ecce                	sd	s3,88(sp)
ffffffffc02057b8:	e8d2                	sd	s4,80(sp)
ffffffffc02057ba:	e4d6                	sd	s5,72(sp)
ffffffffc02057bc:	e0da                	sd	s6,64(sp)
ffffffffc02057be:	fc5e                	sd	s7,56(sp)
ffffffffc02057c0:	f06a                	sd	s10,32(sp)
ffffffffc02057c2:	fc86                	sd	ra,120(sp)
ffffffffc02057c4:	f8a2                	sd	s0,112(sp)
ffffffffc02057c6:	f862                	sd	s8,48(sp)
ffffffffc02057c8:	f466                	sd	s9,40(sp)
ffffffffc02057ca:	ec6e                	sd	s11,24(sp)
ffffffffc02057cc:	892a                	mv	s2,a0
ffffffffc02057ce:	84ae                	mv	s1,a1
ffffffffc02057d0:	8d32                	mv	s10,a2
ffffffffc02057d2:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02057d4:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02057d8:	5b7d                	li	s6,-1
ffffffffc02057da:	00003a97          	auipc	s5,0x3
ffffffffc02057de:	9b2a8a93          	addi	s5,s5,-1614 # ffffffffc020818c <syscalls+0x82c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02057e2:	00003b97          	auipc	s7,0x3
ffffffffc02057e6:	bc6b8b93          	addi	s7,s7,-1082 # ffffffffc02083a8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02057ea:	000d4503          	lbu	a0,0(s10)
ffffffffc02057ee:	001d0413          	addi	s0,s10,1
ffffffffc02057f2:	01350a63          	beq	a0,s3,ffffffffc0205806 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02057f6:	c121                	beqz	a0,ffffffffc0205836 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02057f8:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02057fa:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02057fc:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02057fe:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205802:	ff351ae3          	bne	a0,s3,ffffffffc02057f6 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205806:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020580a:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020580e:	4c81                	li	s9,0
ffffffffc0205810:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205812:	5c7d                	li	s8,-1
ffffffffc0205814:	5dfd                	li	s11,-1
ffffffffc0205816:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc020581a:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020581c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205820:	0ff5f593          	zext.b	a1,a1
ffffffffc0205824:	00140d13          	addi	s10,s0,1
ffffffffc0205828:	04b56263          	bltu	a0,a1,ffffffffc020586c <vprintfmt+0xbc>
ffffffffc020582c:	058a                	slli	a1,a1,0x2
ffffffffc020582e:	95d6                	add	a1,a1,s5
ffffffffc0205830:	4194                	lw	a3,0(a1)
ffffffffc0205832:	96d6                	add	a3,a3,s5
ffffffffc0205834:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205836:	70e6                	ld	ra,120(sp)
ffffffffc0205838:	7446                	ld	s0,112(sp)
ffffffffc020583a:	74a6                	ld	s1,104(sp)
ffffffffc020583c:	7906                	ld	s2,96(sp)
ffffffffc020583e:	69e6                	ld	s3,88(sp)
ffffffffc0205840:	6a46                	ld	s4,80(sp)
ffffffffc0205842:	6aa6                	ld	s5,72(sp)
ffffffffc0205844:	6b06                	ld	s6,64(sp)
ffffffffc0205846:	7be2                	ld	s7,56(sp)
ffffffffc0205848:	7c42                	ld	s8,48(sp)
ffffffffc020584a:	7ca2                	ld	s9,40(sp)
ffffffffc020584c:	7d02                	ld	s10,32(sp)
ffffffffc020584e:	6de2                	ld	s11,24(sp)
ffffffffc0205850:	6109                	addi	sp,sp,128
ffffffffc0205852:	8082                	ret
            padc = '0';
ffffffffc0205854:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205856:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020585a:	846a                	mv	s0,s10
ffffffffc020585c:	00140d13          	addi	s10,s0,1
ffffffffc0205860:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205864:	0ff5f593          	zext.b	a1,a1
ffffffffc0205868:	fcb572e3          	bgeu	a0,a1,ffffffffc020582c <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc020586c:	85a6                	mv	a1,s1
ffffffffc020586e:	02500513          	li	a0,37
ffffffffc0205872:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205874:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205878:	8d22                	mv	s10,s0
ffffffffc020587a:	f73788e3          	beq	a5,s3,ffffffffc02057ea <vprintfmt+0x3a>
ffffffffc020587e:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205882:	1d7d                	addi	s10,s10,-1
ffffffffc0205884:	ff379de3          	bne	a5,s3,ffffffffc020587e <vprintfmt+0xce>
ffffffffc0205888:	b78d                	j	ffffffffc02057ea <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc020588a:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020588e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205892:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205894:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205898:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020589c:	02d86463          	bltu	a6,a3,ffffffffc02058c4 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02058a0:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02058a4:	002c169b          	slliw	a3,s8,0x2
ffffffffc02058a8:	0186873b          	addw	a4,a3,s8
ffffffffc02058ac:	0017171b          	slliw	a4,a4,0x1
ffffffffc02058b0:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02058b2:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02058b6:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02058b8:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02058bc:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02058c0:	fed870e3          	bgeu	a6,a3,ffffffffc02058a0 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02058c4:	f40ddce3          	bgez	s11,ffffffffc020581c <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02058c8:	8de2                	mv	s11,s8
ffffffffc02058ca:	5c7d                	li	s8,-1
ffffffffc02058cc:	bf81                	j	ffffffffc020581c <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02058ce:	fffdc693          	not	a3,s11
ffffffffc02058d2:	96fd                	srai	a3,a3,0x3f
ffffffffc02058d4:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02058d8:	00144603          	lbu	a2,1(s0)
ffffffffc02058dc:	2d81                	sext.w	s11,s11
ffffffffc02058de:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02058e0:	bf35                	j	ffffffffc020581c <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02058e2:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02058e6:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02058ea:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02058ec:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02058ee:	bfd9                	j	ffffffffc02058c4 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02058f0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02058f2:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02058f6:	01174463          	blt	a4,a7,ffffffffc02058fe <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02058fa:	1a088e63          	beqz	a7,ffffffffc0205ab6 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02058fe:	000a3603          	ld	a2,0(s4)
ffffffffc0205902:	46c1                	li	a3,16
ffffffffc0205904:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205906:	2781                	sext.w	a5,a5
ffffffffc0205908:	876e                	mv	a4,s11
ffffffffc020590a:	85a6                	mv	a1,s1
ffffffffc020590c:	854a                	mv	a0,s2
ffffffffc020590e:	e37ff0ef          	jal	ra,ffffffffc0205744 <printnum>
            break;
ffffffffc0205912:	bde1                	j	ffffffffc02057ea <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205914:	000a2503          	lw	a0,0(s4)
ffffffffc0205918:	85a6                	mv	a1,s1
ffffffffc020591a:	0a21                	addi	s4,s4,8
ffffffffc020591c:	9902                	jalr	s2
            break;
ffffffffc020591e:	b5f1                	j	ffffffffc02057ea <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205920:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205922:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205926:	01174463          	blt	a4,a7,ffffffffc020592e <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc020592a:	18088163          	beqz	a7,ffffffffc0205aac <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020592e:	000a3603          	ld	a2,0(s4)
ffffffffc0205932:	46a9                	li	a3,10
ffffffffc0205934:	8a2e                	mv	s4,a1
ffffffffc0205936:	bfc1                	j	ffffffffc0205906 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205938:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020593c:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020593e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205940:	bdf1                	j	ffffffffc020581c <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205942:	85a6                	mv	a1,s1
ffffffffc0205944:	02500513          	li	a0,37
ffffffffc0205948:	9902                	jalr	s2
            break;
ffffffffc020594a:	b545                	j	ffffffffc02057ea <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020594c:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0205950:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205952:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205954:	b5e1                	j	ffffffffc020581c <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205956:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205958:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020595c:	01174463          	blt	a4,a7,ffffffffc0205964 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0205960:	14088163          	beqz	a7,ffffffffc0205aa2 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205964:	000a3603          	ld	a2,0(s4)
ffffffffc0205968:	46a1                	li	a3,8
ffffffffc020596a:	8a2e                	mv	s4,a1
ffffffffc020596c:	bf69                	j	ffffffffc0205906 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020596e:	03000513          	li	a0,48
ffffffffc0205972:	85a6                	mv	a1,s1
ffffffffc0205974:	e03e                	sd	a5,0(sp)
ffffffffc0205976:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205978:	85a6                	mv	a1,s1
ffffffffc020597a:	07800513          	li	a0,120
ffffffffc020597e:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205980:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205982:	6782                	ld	a5,0(sp)
ffffffffc0205984:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205986:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc020598a:	bfb5                	j	ffffffffc0205906 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020598c:	000a3403          	ld	s0,0(s4)
ffffffffc0205990:	008a0713          	addi	a4,s4,8
ffffffffc0205994:	e03a                	sd	a4,0(sp)
ffffffffc0205996:	14040263          	beqz	s0,ffffffffc0205ada <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc020599a:	0fb05763          	blez	s11,ffffffffc0205a88 <vprintfmt+0x2d8>
ffffffffc020599e:	02d00693          	li	a3,45
ffffffffc02059a2:	0cd79163          	bne	a5,a3,ffffffffc0205a64 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02059a6:	00044783          	lbu	a5,0(s0)
ffffffffc02059aa:	0007851b          	sext.w	a0,a5
ffffffffc02059ae:	cf85                	beqz	a5,ffffffffc02059e6 <vprintfmt+0x236>
ffffffffc02059b0:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02059b4:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02059b8:	000c4563          	bltz	s8,ffffffffc02059c2 <vprintfmt+0x212>
ffffffffc02059bc:	3c7d                	addiw	s8,s8,-1
ffffffffc02059be:	036c0263          	beq	s8,s6,ffffffffc02059e2 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02059c2:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02059c4:	0e0c8e63          	beqz	s9,ffffffffc0205ac0 <vprintfmt+0x310>
ffffffffc02059c8:	3781                	addiw	a5,a5,-32
ffffffffc02059ca:	0ef47b63          	bgeu	s0,a5,ffffffffc0205ac0 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02059ce:	03f00513          	li	a0,63
ffffffffc02059d2:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02059d4:	000a4783          	lbu	a5,0(s4)
ffffffffc02059d8:	3dfd                	addiw	s11,s11,-1
ffffffffc02059da:	0a05                	addi	s4,s4,1
ffffffffc02059dc:	0007851b          	sext.w	a0,a5
ffffffffc02059e0:	ffe1                	bnez	a5,ffffffffc02059b8 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02059e2:	01b05963          	blez	s11,ffffffffc02059f4 <vprintfmt+0x244>
ffffffffc02059e6:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02059e8:	85a6                	mv	a1,s1
ffffffffc02059ea:	02000513          	li	a0,32
ffffffffc02059ee:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02059f0:	fe0d9be3          	bnez	s11,ffffffffc02059e6 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02059f4:	6a02                	ld	s4,0(sp)
ffffffffc02059f6:	bbd5                	j	ffffffffc02057ea <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02059f8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02059fa:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02059fe:	01174463          	blt	a4,a7,ffffffffc0205a06 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0205a02:	08088d63          	beqz	a7,ffffffffc0205a9c <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0205a06:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205a0a:	0a044d63          	bltz	s0,ffffffffc0205ac4 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0205a0e:	8622                	mv	a2,s0
ffffffffc0205a10:	8a66                	mv	s4,s9
ffffffffc0205a12:	46a9                	li	a3,10
ffffffffc0205a14:	bdcd                	j	ffffffffc0205906 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205a16:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205a1a:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205a1c:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205a1e:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0205a22:	8fb5                	xor	a5,a5,a3
ffffffffc0205a24:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205a28:	02d74163          	blt	a4,a3,ffffffffc0205a4a <vprintfmt+0x29a>
ffffffffc0205a2c:	00369793          	slli	a5,a3,0x3
ffffffffc0205a30:	97de                	add	a5,a5,s7
ffffffffc0205a32:	639c                	ld	a5,0(a5)
ffffffffc0205a34:	cb99                	beqz	a5,ffffffffc0205a4a <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205a36:	86be                	mv	a3,a5
ffffffffc0205a38:	00000617          	auipc	a2,0x0
ffffffffc0205a3c:	1f060613          	addi	a2,a2,496 # ffffffffc0205c28 <etext+0x2a>
ffffffffc0205a40:	85a6                	mv	a1,s1
ffffffffc0205a42:	854a                	mv	a0,s2
ffffffffc0205a44:	0ce000ef          	jal	ra,ffffffffc0205b12 <printfmt>
ffffffffc0205a48:	b34d                	j	ffffffffc02057ea <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205a4a:	00002617          	auipc	a2,0x2
ffffffffc0205a4e:	73660613          	addi	a2,a2,1846 # ffffffffc0208180 <syscalls+0x820>
ffffffffc0205a52:	85a6                	mv	a1,s1
ffffffffc0205a54:	854a                	mv	a0,s2
ffffffffc0205a56:	0bc000ef          	jal	ra,ffffffffc0205b12 <printfmt>
ffffffffc0205a5a:	bb41                	j	ffffffffc02057ea <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205a5c:	00002417          	auipc	s0,0x2
ffffffffc0205a60:	71c40413          	addi	s0,s0,1820 # ffffffffc0208178 <syscalls+0x818>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205a64:	85e2                	mv	a1,s8
ffffffffc0205a66:	8522                	mv	a0,s0
ffffffffc0205a68:	e43e                	sd	a5,8(sp)
ffffffffc0205a6a:	0e2000ef          	jal	ra,ffffffffc0205b4c <strnlen>
ffffffffc0205a6e:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205a72:	01b05b63          	blez	s11,ffffffffc0205a88 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205a76:	67a2                	ld	a5,8(sp)
ffffffffc0205a78:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205a7c:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0205a7e:	85a6                	mv	a1,s1
ffffffffc0205a80:	8552                	mv	a0,s4
ffffffffc0205a82:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205a84:	fe0d9ce3          	bnez	s11,ffffffffc0205a7c <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205a88:	00044783          	lbu	a5,0(s0)
ffffffffc0205a8c:	00140a13          	addi	s4,s0,1
ffffffffc0205a90:	0007851b          	sext.w	a0,a5
ffffffffc0205a94:	d3a5                	beqz	a5,ffffffffc02059f4 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205a96:	05e00413          	li	s0,94
ffffffffc0205a9a:	bf39                	j	ffffffffc02059b8 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0205a9c:	000a2403          	lw	s0,0(s4)
ffffffffc0205aa0:	b7ad                	j	ffffffffc0205a0a <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0205aa2:	000a6603          	lwu	a2,0(s4)
ffffffffc0205aa6:	46a1                	li	a3,8
ffffffffc0205aa8:	8a2e                	mv	s4,a1
ffffffffc0205aaa:	bdb1                	j	ffffffffc0205906 <vprintfmt+0x156>
ffffffffc0205aac:	000a6603          	lwu	a2,0(s4)
ffffffffc0205ab0:	46a9                	li	a3,10
ffffffffc0205ab2:	8a2e                	mv	s4,a1
ffffffffc0205ab4:	bd89                	j	ffffffffc0205906 <vprintfmt+0x156>
ffffffffc0205ab6:	000a6603          	lwu	a2,0(s4)
ffffffffc0205aba:	46c1                	li	a3,16
ffffffffc0205abc:	8a2e                	mv	s4,a1
ffffffffc0205abe:	b5a1                	j	ffffffffc0205906 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0205ac0:	9902                	jalr	s2
ffffffffc0205ac2:	bf09                	j	ffffffffc02059d4 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0205ac4:	85a6                	mv	a1,s1
ffffffffc0205ac6:	02d00513          	li	a0,45
ffffffffc0205aca:	e03e                	sd	a5,0(sp)
ffffffffc0205acc:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0205ace:	6782                	ld	a5,0(sp)
ffffffffc0205ad0:	8a66                	mv	s4,s9
ffffffffc0205ad2:	40800633          	neg	a2,s0
ffffffffc0205ad6:	46a9                	li	a3,10
ffffffffc0205ad8:	b53d                	j	ffffffffc0205906 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0205ada:	03b05163          	blez	s11,ffffffffc0205afc <vprintfmt+0x34c>
ffffffffc0205ade:	02d00693          	li	a3,45
ffffffffc0205ae2:	f6d79de3          	bne	a5,a3,ffffffffc0205a5c <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0205ae6:	00002417          	auipc	s0,0x2
ffffffffc0205aea:	69240413          	addi	s0,s0,1682 # ffffffffc0208178 <syscalls+0x818>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205aee:	02800793          	li	a5,40
ffffffffc0205af2:	02800513          	li	a0,40
ffffffffc0205af6:	00140a13          	addi	s4,s0,1
ffffffffc0205afa:	bd6d                	j	ffffffffc02059b4 <vprintfmt+0x204>
ffffffffc0205afc:	00002a17          	auipc	s4,0x2
ffffffffc0205b00:	67da0a13          	addi	s4,s4,1661 # ffffffffc0208179 <syscalls+0x819>
ffffffffc0205b04:	02800513          	li	a0,40
ffffffffc0205b08:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205b0c:	05e00413          	li	s0,94
ffffffffc0205b10:	b565                	j	ffffffffc02059b8 <vprintfmt+0x208>

ffffffffc0205b12 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205b12:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205b14:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205b18:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205b1a:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205b1c:	ec06                	sd	ra,24(sp)
ffffffffc0205b1e:	f83a                	sd	a4,48(sp)
ffffffffc0205b20:	fc3e                	sd	a5,56(sp)
ffffffffc0205b22:	e0c2                	sd	a6,64(sp)
ffffffffc0205b24:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205b26:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205b28:	c89ff0ef          	jal	ra,ffffffffc02057b0 <vprintfmt>
}
ffffffffc0205b2c:	60e2                	ld	ra,24(sp)
ffffffffc0205b2e:	6161                	addi	sp,sp,80
ffffffffc0205b30:	8082                	ret

ffffffffc0205b32 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205b32:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205b36:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0205b38:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205b3a:	cb81                	beqz	a5,ffffffffc0205b4a <strlen+0x18>
        cnt ++;
ffffffffc0205b3c:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205b3e:	00a707b3          	add	a5,a4,a0
ffffffffc0205b42:	0007c783          	lbu	a5,0(a5)
ffffffffc0205b46:	fbfd                	bnez	a5,ffffffffc0205b3c <strlen+0xa>
ffffffffc0205b48:	8082                	ret
    }
    return cnt;
}
ffffffffc0205b4a:	8082                	ret

ffffffffc0205b4c <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205b4c:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205b4e:	e589                	bnez	a1,ffffffffc0205b58 <strnlen+0xc>
ffffffffc0205b50:	a811                	j	ffffffffc0205b64 <strnlen+0x18>
        cnt ++;
ffffffffc0205b52:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205b54:	00f58863          	beq	a1,a5,ffffffffc0205b64 <strnlen+0x18>
ffffffffc0205b58:	00f50733          	add	a4,a0,a5
ffffffffc0205b5c:	00074703          	lbu	a4,0(a4)
ffffffffc0205b60:	fb6d                	bnez	a4,ffffffffc0205b52 <strnlen+0x6>
ffffffffc0205b62:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205b64:	852e                	mv	a0,a1
ffffffffc0205b66:	8082                	ret

ffffffffc0205b68 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205b68:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205b6a:	0005c703          	lbu	a4,0(a1)
ffffffffc0205b6e:	0785                	addi	a5,a5,1
ffffffffc0205b70:	0585                	addi	a1,a1,1
ffffffffc0205b72:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205b76:	fb75                	bnez	a4,ffffffffc0205b6a <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205b78:	8082                	ret

ffffffffc0205b7a <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205b7a:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205b7e:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205b82:	cb89                	beqz	a5,ffffffffc0205b94 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205b84:	0505                	addi	a0,a0,1
ffffffffc0205b86:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205b88:	fee789e3          	beq	a5,a4,ffffffffc0205b7a <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205b8c:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205b90:	9d19                	subw	a0,a0,a4
ffffffffc0205b92:	8082                	ret
ffffffffc0205b94:	4501                	li	a0,0
ffffffffc0205b96:	bfed                	j	ffffffffc0205b90 <strcmp+0x16>

ffffffffc0205b98 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205b98:	c20d                	beqz	a2,ffffffffc0205bba <strncmp+0x22>
ffffffffc0205b9a:	962e                	add	a2,a2,a1
ffffffffc0205b9c:	a031                	j	ffffffffc0205ba8 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0205b9e:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205ba0:	00e79a63          	bne	a5,a4,ffffffffc0205bb4 <strncmp+0x1c>
ffffffffc0205ba4:	00b60b63          	beq	a2,a1,ffffffffc0205bba <strncmp+0x22>
ffffffffc0205ba8:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205bac:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205bae:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0205bb2:	f7f5                	bnez	a5,ffffffffc0205b9e <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205bb4:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0205bb8:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205bba:	4501                	li	a0,0
ffffffffc0205bbc:	8082                	ret

ffffffffc0205bbe <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205bbe:	00054783          	lbu	a5,0(a0)
ffffffffc0205bc2:	c799                	beqz	a5,ffffffffc0205bd0 <strchr+0x12>
        if (*s == c) {
ffffffffc0205bc4:	00f58763          	beq	a1,a5,ffffffffc0205bd2 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0205bc8:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0205bcc:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205bce:	fbfd                	bnez	a5,ffffffffc0205bc4 <strchr+0x6>
    }
    return NULL;
ffffffffc0205bd0:	4501                	li	a0,0
}
ffffffffc0205bd2:	8082                	ret

ffffffffc0205bd4 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205bd4:	ca01                	beqz	a2,ffffffffc0205be4 <memset+0x10>
ffffffffc0205bd6:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205bd8:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205bda:	0785                	addi	a5,a5,1
ffffffffc0205bdc:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205be0:	fec79de3          	bne	a5,a2,ffffffffc0205bda <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205be4:	8082                	ret

ffffffffc0205be6 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205be6:	ca19                	beqz	a2,ffffffffc0205bfc <memcpy+0x16>
ffffffffc0205be8:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205bea:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205bec:	0005c703          	lbu	a4,0(a1)
ffffffffc0205bf0:	0585                	addi	a1,a1,1
ffffffffc0205bf2:	0785                	addi	a5,a5,1
ffffffffc0205bf4:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205bf8:	fec59ae3          	bne	a1,a2,ffffffffc0205bec <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205bfc:	8082                	ret
