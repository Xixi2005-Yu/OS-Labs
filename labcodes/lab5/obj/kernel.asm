
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

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
ffffffffc020004a:	000a6517          	auipc	a0,0xa6
ffffffffc020004e:	26e50513          	addi	a0,a0,622 # ffffffffc02a62b8 <buf>
ffffffffc0200052:	000aa617          	auipc	a2,0xaa
ffffffffc0200056:	70a60613          	addi	a2,a2,1802 # ffffffffc02aa75c <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	600050ef          	jal	ra,ffffffffc0205662 <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	62258593          	addi	a1,a1,1570 # ffffffffc0205690 <etext+0x4>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	63a50513          	addi	a0,a0,1594 # ffffffffc02056b0 <etext+0x24>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	6a0020ef          	jal	ra,ffffffffc0202726 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	16d030ef          	jal	ra,ffffffffc02039fe <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	51f040ef          	jal	ra,ffffffffc0204db4 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	6ab040ef          	jal	ra,ffffffffc0204f4c <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a6                	sd	s1,64(sp)
ffffffffc02000ac:	fc4a                	sd	s2,56(sp)
ffffffffc02000ae:	f84e                	sd	s3,48(sp)
ffffffffc02000b0:	f452                	sd	s4,40(sp)
ffffffffc02000b2:	f056                	sd	s5,32(sp)
ffffffffc02000b4:	ec5a                	sd	s6,24(sp)
ffffffffc02000b6:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00005517          	auipc	a0,0x5
ffffffffc02000c0:	5fc50513          	addi	a0,a0,1532 # ffffffffc02056b8 <etext+0x2c>
ffffffffc02000c4:	0d0000ef          	jal	ra,ffffffffc0200194 <cprintf>
readline(const char *prompt) {
ffffffffc02000c8:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4aa9                	li	s5,10
ffffffffc02000d0:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d2:	000a6b97          	auipc	s7,0xa6
ffffffffc02000d6:	1e6b8b93          	addi	s7,s7,486 # ffffffffc02a62b8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	12e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	11e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	10c000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc0200104:	fe0549e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200108:	fea959e3          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc020010c:	4481                	li	s1,0
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0ba000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	009b87b3          	add	a5,s7,s1
ffffffffc020011a:	2485                	addiw	s1,s1,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01550463          	beq	a0,s5,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb651ce3          	bne	a0,s6,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	0a0000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	000a6517          	auipc	a0,0xa6
ffffffffc0200132:	18a50513          	addi	a0,a0,394 # ffffffffc02a62b8 <buf>
ffffffffc0200136:	94aa                	add	s1,s1,a0
ffffffffc0200138:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6486                	ld	s1,64(sp)
ffffffffc0200140:	7962                	ld	s2,56(sp)
ffffffffc0200142:	79c2                	ld	s3,48(sp)
ffffffffc0200144:	7a22                	ld	s4,40(sp)
ffffffffc0200146:	7a82                	ld	s5,32(sp)
ffffffffc0200148:	6b62                	ld	s6,24(sp)
ffffffffc020014a:	6bc2                	ld	s7,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	078000ef          	jal	ra,ffffffffc02001ca <cputchar>
            i --;
ffffffffc0200156:	34fd                	addiw	s1,s1,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200162:	42c000ef          	jal	ra,ffffffffc020058e <cons_putc>
    (*cnt)++;
ffffffffc0200166:	401c                	lw	a5,0(s0)
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
}
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	0b6050ef          	jal	ra,ffffffffc020523e <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc020019a:	8e2a                	mv	t3,a0
ffffffffc020019c:	f42e                	sd	a1,40(sp)
ffffffffc020019e:	f832                	sd	a2,48(sp)
ffffffffc02001a0:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a2:	00000517          	auipc	a0,0x0
ffffffffc02001a6:	fb850513          	addi	a0,a0,-72 # ffffffffc020015a <cputch>
ffffffffc02001aa:	004c                	addi	a1,sp,4
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	8672                	mv	a2,t3
{
ffffffffc02001b0:	ec06                	sd	ra,24(sp)
ffffffffc02001b2:	e0ba                	sd	a4,64(sp)
ffffffffc02001b4:	e4be                	sd	a5,72(sp)
ffffffffc02001b6:	e8c2                	sd	a6,80(sp)
ffffffffc02001b8:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001bc:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001be:	080050ef          	jal	ra,ffffffffc020523e <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	4512                	lw	a0,4(sp)
ffffffffc02001c6:	6125                	addi	sp,sp,96
ffffffffc02001c8:	8082                	ret

ffffffffc02001ca <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ca:	a6d1                	j	ffffffffc020058e <cons_putc>

ffffffffc02001cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001cc:	1101                	addi	sp,sp,-32
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e426                	sd	s1,8(sp)
ffffffffc02001d4:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d6:	00054503          	lbu	a0,0(a0)
ffffffffc02001da:	c51d                	beqz	a0,ffffffffc0200208 <cputs+0x3c>
ffffffffc02001dc:	0405                	addi	s0,s0,1
ffffffffc02001de:	4485                	li	s1,1
ffffffffc02001e0:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e2:	3ac000ef          	jal	ra,ffffffffc020058e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e6:	00044503          	lbu	a0,0(s0)
ffffffffc02001ea:	008487bb          	addw	a5,s1,s0
ffffffffc02001ee:	0405                	addi	s0,s0,1
ffffffffc02001f0:	f96d                	bnez	a0,ffffffffc02001e2 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f2:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001f6:	4529                	li	a0,10
ffffffffc02001f8:	396000ef          	jal	ra,ffffffffc020058e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	64a2                	ld	s1,8(sp)
ffffffffc0200204:	6105                	addi	sp,sp,32
ffffffffc0200206:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200208:	4405                	li	s0,1
ffffffffc020020a:	b7f5                	j	ffffffffc02001f6 <cputs+0x2a>

ffffffffc020020c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020020c:	1141                	addi	sp,sp,-16
ffffffffc020020e:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200210:	3b2000ef          	jal	ra,ffffffffc02005c2 <cons_getc>
ffffffffc0200214:	dd75                	beqz	a0,ffffffffc0200210 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200216:	60a2                	ld	ra,8(sp)
ffffffffc0200218:	0141                	addi	sp,sp,16
ffffffffc020021a:	8082                	ret

ffffffffc020021c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020021c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020021e:	00005517          	auipc	a0,0x5
ffffffffc0200222:	4a250513          	addi	a0,a0,1186 # ffffffffc02056c0 <etext+0x34>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	4ac50513          	addi	a0,a0,1196 # ffffffffc02056e0 <etext+0x54>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	44c58593          	addi	a1,a1,1100 # ffffffffc020568c <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	4b850513          	addi	a0,a0,1208 # ffffffffc0205700 <etext+0x74>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000a6597          	auipc	a1,0xa6
ffffffffc0200258:	06458593          	addi	a1,a1,100 # ffffffffc02a62b8 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	4c450513          	addi	a0,a0,1220 # ffffffffc0205720 <etext+0x94>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000aa597          	auipc	a1,0xaa
ffffffffc020026c:	4f458593          	addi	a1,a1,1268 # ffffffffc02aa75c <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	4d050513          	addi	a0,a0,1232 # ffffffffc0205740 <etext+0xb4>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000ab597          	auipc	a1,0xab
ffffffffc0200280:	8df58593          	addi	a1,a1,-1825 # ffffffffc02aab5b <end+0x3ff>
ffffffffc0200284:	00000797          	auipc	a5,0x0
ffffffffc0200288:	dc678793          	addi	a5,a5,-570 # ffffffffc020004a <kern_init>
ffffffffc020028c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200290:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200294:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200296:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029a:	95be                	add	a1,a1,a5
ffffffffc020029c:	85a9                	srai	a1,a1,0xa
ffffffffc020029e:	00005517          	auipc	a0,0x5
ffffffffc02002a2:	4c250513          	addi	a0,a0,1218 # ffffffffc0205760 <etext+0xd4>
}
ffffffffc02002a6:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a8:	b5f5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002aa <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002aa:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ac:	00005617          	auipc	a2,0x5
ffffffffc02002b0:	4e460613          	addi	a2,a2,1252 # ffffffffc0205790 <etext+0x104>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	4f050513          	addi	a0,a0,1264 # ffffffffc02057a8 <etext+0x11c>
{
ffffffffc02002c0:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c2:	1cc000ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02002c6 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002c6:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002c8:	00005617          	auipc	a2,0x5
ffffffffc02002cc:	4f860613          	addi	a2,a2,1272 # ffffffffc02057c0 <etext+0x134>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	51058593          	addi	a1,a1,1296 # ffffffffc02057e0 <etext+0x154>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	51050513          	addi	a0,a0,1296 # ffffffffc02057e8 <etext+0x15c>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	51260613          	addi	a2,a2,1298 # ffffffffc02057f8 <etext+0x16c>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	53258593          	addi	a1,a1,1330 # ffffffffc0205820 <etext+0x194>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	4f250513          	addi	a0,a0,1266 # ffffffffc02057e8 <etext+0x15c>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	52e60613          	addi	a2,a2,1326 # ffffffffc0205830 <etext+0x1a4>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	54658593          	addi	a1,a1,1350 # ffffffffc0205850 <etext+0x1c4>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	4d650513          	addi	a0,a0,1238 # ffffffffc02057e8 <etext+0x15c>
ffffffffc020031a:	e7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc020031e:	60a2                	ld	ra,8(sp)
ffffffffc0200320:	4501                	li	a0,0
ffffffffc0200322:	0141                	addi	sp,sp,16
ffffffffc0200324:	8082                	ret

ffffffffc0200326 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200326:	1141                	addi	sp,sp,-16
ffffffffc0200328:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032a:	ef3ff0ef          	jal	ra,ffffffffc020021c <print_kerninfo>
    return 0;
}
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033a:	f71ff0ef          	jal	ra,ffffffffc02002aa <print_stackframe>
    return 0;
}
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <kmonitor>:
{
ffffffffc0200346:	7115                	addi	sp,sp,-224
ffffffffc0200348:	ed5e                	sd	s7,152(sp)
ffffffffc020034a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	51450513          	addi	a0,a0,1300 # ffffffffc0205860 <etext+0x1d4>
{
ffffffffc0200354:	ed86                	sd	ra,216(sp)
ffffffffc0200356:	e9a2                	sd	s0,208(sp)
ffffffffc0200358:	e5a6                	sd	s1,200(sp)
ffffffffc020035a:	e1ca                	sd	s2,192(sp)
ffffffffc020035c:	fd4e                	sd	s3,184(sp)
ffffffffc020035e:	f952                	sd	s4,176(sp)
ffffffffc0200360:	f556                	sd	s5,168(sp)
ffffffffc0200362:	f15a                	sd	s6,160(sp)
ffffffffc0200364:	e962                	sd	s8,144(sp)
ffffffffc0200366:	e566                	sd	s9,136(sp)
ffffffffc0200368:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	e2bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020036e:	00005517          	auipc	a0,0x5
ffffffffc0200372:	51a50513          	addi	a0,a0,1306 # ffffffffc0205888 <etext+0x1fc>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00005c17          	auipc	s8,0x5
ffffffffc0200388:	574c0c13          	addi	s8,s8,1396 # ffffffffc02058f8 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	52490913          	addi	s2,s2,1316 # ffffffffc02058b0 <etext+0x224>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	52448493          	addi	s1,s1,1316 # ffffffffc02058b8 <etext+0x22c>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	522b0b13          	addi	s6,s6,1314 # ffffffffc02058c0 <etext+0x234>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	43aa0a13          	addi	s4,s4,1082 # ffffffffc02057e0 <etext+0x154>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003ae:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003b0:	854a                	mv	a0,s2
ffffffffc02003b2:	cf5ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc02003b6:	842a                	mv	s0,a0
ffffffffc02003b8:	dd65                	beqz	a0,ffffffffc02003b0 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ba:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003be:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c0:	e1bd                	bnez	a1,ffffffffc0200426 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc02003c2:	fe0c87e3          	beqz	s9,ffffffffc02003b0 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003c6:	6582                	ld	a1,0(sp)
ffffffffc02003c8:	00005d17          	auipc	s10,0x5
ffffffffc02003cc:	530d0d13          	addi	s10,s10,1328 # ffffffffc02058f8 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	232050ef          	jal	ra,ffffffffc0205608 <strcmp>
ffffffffc02003da:	c919                	beqz	a0,ffffffffc02003f0 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003dc:	2405                	addiw	s0,s0,1
ffffffffc02003de:	0b540063          	beq	s0,s5,ffffffffc020047e <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003e2:	000d3503          	ld	a0,0(s10)
ffffffffc02003e6:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003ea:	21e050ef          	jal	ra,ffffffffc0205608 <strcmp>
ffffffffc02003ee:	f57d                	bnez	a0,ffffffffc02003dc <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f0:	00141793          	slli	a5,s0,0x1
ffffffffc02003f4:	97a2                	add	a5,a5,s0
ffffffffc02003f6:	078e                	slli	a5,a5,0x3
ffffffffc02003f8:	97e2                	add	a5,a5,s8
ffffffffc02003fa:	6b9c                	ld	a5,16(a5)
ffffffffc02003fc:	865e                	mv	a2,s7
ffffffffc02003fe:	002c                	addi	a1,sp,8
ffffffffc0200400:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200404:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200406:	fa0555e3          	bgez	a0,ffffffffc02003b0 <kmonitor+0x6a>
}
ffffffffc020040a:	60ee                	ld	ra,216(sp)
ffffffffc020040c:	644e                	ld	s0,208(sp)
ffffffffc020040e:	64ae                	ld	s1,200(sp)
ffffffffc0200410:	690e                	ld	s2,192(sp)
ffffffffc0200412:	79ea                	ld	s3,184(sp)
ffffffffc0200414:	7a4a                	ld	s4,176(sp)
ffffffffc0200416:	7aaa                	ld	s5,168(sp)
ffffffffc0200418:	7b0a                	ld	s6,160(sp)
ffffffffc020041a:	6bea                	ld	s7,152(sp)
ffffffffc020041c:	6c4a                	ld	s8,144(sp)
ffffffffc020041e:	6caa                	ld	s9,136(sp)
ffffffffc0200420:	6d0a                	ld	s10,128(sp)
ffffffffc0200422:	612d                	addi	sp,sp,224
ffffffffc0200424:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200426:	8526                	mv	a0,s1
ffffffffc0200428:	224050ef          	jal	ra,ffffffffc020564c <strchr>
ffffffffc020042c:	c901                	beqz	a0,ffffffffc020043c <kmonitor+0xf6>
ffffffffc020042e:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200432:	00040023          	sb	zero,0(s0)
ffffffffc0200436:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200438:	d5c9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc020043a:	b7f5                	j	ffffffffc0200426 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc020043c:	00044783          	lbu	a5,0(s0)
ffffffffc0200440:	d3c9                	beqz	a5,ffffffffc02003c2 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200442:	033c8963          	beq	s9,s3,ffffffffc0200474 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc0200446:	003c9793          	slli	a5,s9,0x3
ffffffffc020044a:	0118                	addi	a4,sp,128
ffffffffc020044c:	97ba                	add	a5,a5,a4
ffffffffc020044e:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200452:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200456:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200458:	e591                	bnez	a1,ffffffffc0200464 <kmonitor+0x11e>
ffffffffc020045a:	b7b5                	j	ffffffffc02003c6 <kmonitor+0x80>
ffffffffc020045c:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200462:	d1a5                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200464:	8526                	mv	a0,s1
ffffffffc0200466:	1e6050ef          	jal	ra,ffffffffc020564c <strchr>
ffffffffc020046a:	d96d                	beqz	a0,ffffffffc020045c <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046c:	00044583          	lbu	a1,0(s0)
ffffffffc0200470:	d9a9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200472:	bf55                	j	ffffffffc0200426 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200474:	45c1                	li	a1,16
ffffffffc0200476:	855a                	mv	a0,s6
ffffffffc0200478:	d1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020047c:	b7e9                	j	ffffffffc0200446 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020047e:	6582                	ld	a1,0(sp)
ffffffffc0200480:	00005517          	auipc	a0,0x5
ffffffffc0200484:	46050513          	addi	a0,a0,1120 # ffffffffc02058e0 <etext+0x254>
ffffffffc0200488:	d0dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc020048c:	b715                	j	ffffffffc02003b0 <kmonitor+0x6a>

ffffffffc020048e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020048e:	000aa317          	auipc	t1,0xaa
ffffffffc0200492:	25230313          	addi	t1,t1,594 # ffffffffc02aa6e0 <is_panic>
ffffffffc0200496:	00033e03          	ld	t3,0(t1)
{
ffffffffc020049a:	715d                	addi	sp,sp,-80
ffffffffc020049c:	ec06                	sd	ra,24(sp)
ffffffffc020049e:	e822                	sd	s0,16(sp)
ffffffffc02004a0:	f436                	sd	a3,40(sp)
ffffffffc02004a2:	f83a                	sd	a4,48(sp)
ffffffffc02004a4:	fc3e                	sd	a5,56(sp)
ffffffffc02004a6:	e0c2                	sd	a6,64(sp)
ffffffffc02004a8:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004aa:	020e1a63          	bnez	t3,ffffffffc02004de <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004ae:	4785                	li	a5,1
ffffffffc02004b0:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	8432                	mv	s0,a2
ffffffffc02004b6:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b8:	862e                	mv	a2,a1
ffffffffc02004ba:	85aa                	mv	a1,a0
ffffffffc02004bc:	00005517          	auipc	a0,0x5
ffffffffc02004c0:	48450513          	addi	a0,a0,1156 # ffffffffc0205940 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00006517          	auipc	a0,0x6
ffffffffc02004d6:	56650513          	addi	a0,a0,1382 # ffffffffc0206a38 <default_pmm_manager+0x578>
ffffffffc02004da:	cbbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004de:	4501                	li	a0,0
ffffffffc02004e0:	4581                	li	a1,0
ffffffffc02004e2:	4601                	li	a2,0
ffffffffc02004e4:	48a1                	li	a7,8
ffffffffc02004e6:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ea:	4ca000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	e57ff0ef          	jal	ra,ffffffffc0200346 <kmonitor>
    while (1)
ffffffffc02004f4:	bfed                	j	ffffffffc02004ee <__panic+0x60>

ffffffffc02004f6 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f6:	715d                	addi	sp,sp,-80
ffffffffc02004f8:	832e                	mv	t1,a1
ffffffffc02004fa:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	85aa                	mv	a1,a0
{
ffffffffc02004fe:	8432                	mv	s0,a2
ffffffffc0200500:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200502:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200504:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	00005517          	auipc	a0,0x5
ffffffffc020050a:	45a50513          	addi	a0,a0,1114 # ffffffffc0205960 <commands+0x68>
{
ffffffffc020050e:	ec06                	sd	ra,24(sp)
ffffffffc0200510:	f436                	sd	a3,40(sp)
ffffffffc0200512:	f83a                	sd	a4,48(sp)
ffffffffc0200514:	e0c2                	sd	a6,64(sp)
ffffffffc0200516:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200518:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051a:	c7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020051e:	65a2                	ld	a1,8(sp)
ffffffffc0200520:	8522                	mv	a0,s0
ffffffffc0200522:	c53ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200526:	00006517          	auipc	a0,0x6
ffffffffc020052a:	51250513          	addi	a0,a0,1298 # ffffffffc0206a38 <default_pmm_manager+0x578>
ffffffffc020052e:	c67ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc0200532:	60e2                	ld	ra,24(sp)
ffffffffc0200534:	6442                	ld	s0,16(sp)
ffffffffc0200536:	6161                	addi	sp,sp,80
ffffffffc0200538:	8082                	ret

ffffffffc020053a <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020053a:	67e1                	lui	a5,0x18
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd580>
ffffffffc0200540:	000aa717          	auipc	a4,0xaa
ffffffffc0200544:	1af73823          	sd	a5,432(a4) # ffffffffc02aa6f0 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200548:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020054c:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054e:	953e                	add	a0,a0,a5
ffffffffc0200550:	4601                	li	a2,0
ffffffffc0200552:	4881                	li	a7,0
ffffffffc0200554:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200558:	02000793          	li	a5,32
ffffffffc020055c:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200560:	00005517          	auipc	a0,0x5
ffffffffc0200564:	42050513          	addi	a0,a0,1056 # ffffffffc0205980 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000aa797          	auipc	a5,0xaa
ffffffffc020056c:	1807b023          	sd	zero,384(a5) # ffffffffc02aa6e8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000aa797          	auipc	a5,0xaa
ffffffffc020057a:	17a7b783          	ld	a5,378(a5) # ffffffffc02aa6f0 <timebase>
ffffffffc020057e:	953e                	add	a0,a0,a5
ffffffffc0200580:	4581                	li	a1,0
ffffffffc0200582:	4601                	li	a2,0
ffffffffc0200584:	4881                	li	a7,0
ffffffffc0200586:	00000073          	ecall
ffffffffc020058a:	8082                	ret

ffffffffc020058c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020058c:	8082                	ret

ffffffffc020058e <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020058e:	100027f3          	csrr	a5,sstatus
ffffffffc0200592:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200594:	0ff57513          	zext.b	a0,a0
ffffffffc0200598:	e799                	bnez	a5,ffffffffc02005a6 <cons_putc+0x18>
ffffffffc020059a:	4581                	li	a1,0
ffffffffc020059c:	4601                	li	a2,0
ffffffffc020059e:	4885                	li	a7,1
ffffffffc02005a0:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc02005a4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a6:	1101                	addi	sp,sp,-32
ffffffffc02005a8:	ec06                	sd	ra,24(sp)
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005ac:	408000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005b0:	6522                	ld	a0,8(sp)
ffffffffc02005b2:	4581                	li	a1,0
ffffffffc02005b4:	4601                	li	a2,0
ffffffffc02005b6:	4885                	li	a7,1
ffffffffc02005b8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005bc:	60e2                	ld	ra,24(sp)
ffffffffc02005be:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005c0:	a6fd                	j	ffffffffc02009ae <intr_enable>

ffffffffc02005c2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005c2:	100027f3          	csrr	a5,sstatus
ffffffffc02005c6:	8b89                	andi	a5,a5,2
ffffffffc02005c8:	eb89                	bnez	a5,ffffffffc02005da <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005ca:	4501                	li	a0,0
ffffffffc02005cc:	4581                	li	a1,0
ffffffffc02005ce:	4601                	li	a2,0
ffffffffc02005d0:	4889                	li	a7,2
ffffffffc02005d2:	00000073          	ecall
ffffffffc02005d6:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d8:	8082                	ret
int cons_getc(void) {
ffffffffc02005da:	1101                	addi	sp,sp,-32
ffffffffc02005dc:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005de:	3d6000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005e2:	4501                	li	a0,0
ffffffffc02005e4:	4581                	li	a1,0
ffffffffc02005e6:	4601                	li	a2,0
ffffffffc02005e8:	4889                	li	a7,2
ffffffffc02005ea:	00000073          	ecall
ffffffffc02005ee:	2501                	sext.w	a0,a0
ffffffffc02005f0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005f2:	3bc000ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02005f6:	60e2                	ld	ra,24(sp)
ffffffffc02005f8:	6522                	ld	a0,8(sp)
ffffffffc02005fa:	6105                	addi	sp,sp,32
ffffffffc02005fc:	8082                	ret

ffffffffc02005fe <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005fe:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200600:	00005517          	auipc	a0,0x5
ffffffffc0200604:	3a050513          	addi	a0,a0,928 # ffffffffc02059a0 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200608:	fc86                	sd	ra,120(sp)
ffffffffc020060a:	f8a2                	sd	s0,112(sp)
ffffffffc020060c:	e8d2                	sd	s4,80(sp)
ffffffffc020060e:	f4a6                	sd	s1,104(sp)
ffffffffc0200610:	f0ca                	sd	s2,96(sp)
ffffffffc0200612:	ecce                	sd	s3,88(sp)
ffffffffc0200614:	e4d6                	sd	s5,72(sp)
ffffffffc0200616:	e0da                	sd	s6,64(sp)
ffffffffc0200618:	fc5e                	sd	s7,56(sp)
ffffffffc020061a:	f862                	sd	s8,48(sp)
ffffffffc020061c:	f466                	sd	s9,40(sp)
ffffffffc020061e:	f06a                	sd	s10,32(sp)
ffffffffc0200620:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200622:	b73ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200626:	0000b597          	auipc	a1,0xb
ffffffffc020062a:	9da5b583          	ld	a1,-1574(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020062e:	00005517          	auipc	a0,0x5
ffffffffc0200632:	38250513          	addi	a0,a0,898 # ffffffffc02059b0 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	37c50513          	addi	a0,a0,892 # ffffffffc02059c0 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	38450513          	addi	a0,a0,900 # ffffffffc02059d8 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc020065c:	120a0463          	beqz	s4,ffffffffc0200784 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200660:	57f5                	li	a5,-3
ffffffffc0200662:	07fa                	slli	a5,a5,0x1e
ffffffffc0200664:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200668:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066e:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200674:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200678:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200686:	8ec9                	or	a3,a3,a0
ffffffffc0200688:	0087979b          	slliw	a5,a5,0x8
ffffffffc020068c:	1b7d                	addi	s6,s6,-1
ffffffffc020068e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200692:	8dd5                	or	a1,a1,a3
ffffffffc0200694:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe35791>
ffffffffc02006a0:	10f59163          	bne	a1,a5,ffffffffc02007a2 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02006a4:	471c                	lw	a5,8(a4)
ffffffffc02006a6:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a8:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006aa:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006ae:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006b2:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ca:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d2:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	01146433          	or	s0,s0,a7
ffffffffc02006d8:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006dc:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e0:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e6:	8c49                	or	s0,s0,a0
ffffffffc02006e8:	0166f6b3          	and	a3,a3,s6
ffffffffc02006ec:	00ca6a33          	or	s4,s4,a2
ffffffffc02006f0:	0167f7b3          	and	a5,a5,s6
ffffffffc02006f4:	8c55                	or	s0,s0,a3
ffffffffc02006f6:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fa:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fc:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200704:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200706:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200708:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020070c:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020070e:	00005917          	auipc	s2,0x5
ffffffffc0200712:	31a90913          	addi	s2,s2,794 # ffffffffc0205a28 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	30448493          	addi	s1,s1,772 # ffffffffc0205a20 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200724:	000a2703          	lw	a4,0(s4)
ffffffffc0200728:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200730:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200734:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200738:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200740:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	0087171b          	slliw	a4,a4,0x8
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	00eb7733          	and	a4,s6,a4
ffffffffc0200750:	8fd9                	or	a5,a5,a4
ffffffffc0200752:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200754:	09778c63          	beq	a5,s7,ffffffffc02007ec <dtb_init+0x1ee>
ffffffffc0200758:	00fbea63          	bltu	s7,a5,ffffffffc020076c <dtb_init+0x16e>
ffffffffc020075c:	07a78663          	beq	a5,s10,ffffffffc02007c8 <dtb_init+0x1ca>
ffffffffc0200760:	4709                	li	a4,2
ffffffffc0200762:	00e79763          	bne	a5,a4,ffffffffc0200770 <dtb_init+0x172>
ffffffffc0200766:	4c81                	li	s9,0
ffffffffc0200768:	8a56                	mv	s4,s5
ffffffffc020076a:	bf6d                	j	ffffffffc0200724 <dtb_init+0x126>
ffffffffc020076c:	ffb78ee3          	beq	a5,s11,ffffffffc0200768 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	33050513          	addi	a0,a0,816 # ffffffffc0205aa0 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	35c50513          	addi	a0,a0,860 # ffffffffc0205ad8 <commands+0x1e0>
}
ffffffffc0200784:	7446                	ld	s0,112(sp)
ffffffffc0200786:	70e6                	ld	ra,120(sp)
ffffffffc0200788:	74a6                	ld	s1,104(sp)
ffffffffc020078a:	7906                	ld	s2,96(sp)
ffffffffc020078c:	69e6                	ld	s3,88(sp)
ffffffffc020078e:	6a46                	ld	s4,80(sp)
ffffffffc0200790:	6aa6                	ld	s5,72(sp)
ffffffffc0200792:	6b06                	ld	s6,64(sp)
ffffffffc0200794:	7be2                	ld	s7,56(sp)
ffffffffc0200796:	7c42                	ld	s8,48(sp)
ffffffffc0200798:	7ca2                	ld	s9,40(sp)
ffffffffc020079a:	7d02                	ld	s10,32(sp)
ffffffffc020079c:	6de2                	ld	s11,24(sp)
ffffffffc020079e:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02007a0:	bad5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc02007a2:	7446                	ld	s0,112(sp)
ffffffffc02007a4:	70e6                	ld	ra,120(sp)
ffffffffc02007a6:	74a6                	ld	s1,104(sp)
ffffffffc02007a8:	7906                	ld	s2,96(sp)
ffffffffc02007aa:	69e6                	ld	s3,88(sp)
ffffffffc02007ac:	6a46                	ld	s4,80(sp)
ffffffffc02007ae:	6aa6                	ld	s5,72(sp)
ffffffffc02007b0:	6b06                	ld	s6,64(sp)
ffffffffc02007b2:	7be2                	ld	s7,56(sp)
ffffffffc02007b4:	7c42                	ld	s8,48(sp)
ffffffffc02007b6:	7ca2                	ld	s9,40(sp)
ffffffffc02007b8:	7d02                	ld	s10,32(sp)
ffffffffc02007ba:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	23c50513          	addi	a0,a0,572 # ffffffffc02059f8 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	5f7040ef          	jal	ra,ffffffffc02055c0 <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	64f040ef          	jal	ra,ffffffffc0205626 <strncmp>
ffffffffc02007dc:	e111                	bnez	a0,ffffffffc02007e0 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007de:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007e0:	0a91                	addi	s5,s5,4
ffffffffc02007e2:	9ad2                	add	s5,s5,s4
ffffffffc02007e4:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e8:	8a56                	mv	s4,s5
ffffffffc02007ea:	bf2d                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ec:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f0:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007f4:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f8:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fc:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200800:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200804:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200808:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200810:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200814:	00eaeab3          	or	s5,s5,a4
ffffffffc0200818:	00fb77b3          	and	a5,s6,a5
ffffffffc020081c:	00faeab3          	or	s5,s5,a5
ffffffffc0200820:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200822:	000c9c63          	bnez	s9,ffffffffc020083a <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200826:	1a82                	slli	s5,s5,0x20
ffffffffc0200828:	00368793          	addi	a5,a3,3
ffffffffc020082c:	020ada93          	srli	s5,s5,0x20
ffffffffc0200830:	9abe                	add	s5,s5,a5
ffffffffc0200832:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200836:	8a56                	mv	s4,s5
ffffffffc0200838:	b5f5                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020083a:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083e:	85ca                	mv	a1,s2
ffffffffc0200840:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0187971b          	slliw	a4,a5,0x18
ffffffffc020084e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200852:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200856:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200858:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200860:	8d59                	or	a0,a0,a4
ffffffffc0200862:	00fb77b3          	and	a5,s6,a5
ffffffffc0200866:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200868:	1502                	slli	a0,a0,0x20
ffffffffc020086a:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020086c:	9522                	add	a0,a0,s0
ffffffffc020086e:	59b040ef          	jal	ra,ffffffffc0205608 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	1ae50513          	addi	a0,a0,430 # ffffffffc0205a30 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc020088a:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020088e:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200892:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200896:	0187de1b          	srliw	t3,a5,0x18
ffffffffc020089a:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a2:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a6:	0187d693          	srli	a3,a5,0x18
ffffffffc02008aa:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008ae:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008b2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b6:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008ba:	010f6f33          	or	t5,t5,a6
ffffffffc02008be:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008c2:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c6:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ca:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ce:	0186f6b3          	and	a3,a3,s8
ffffffffc02008d2:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d6:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008da:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008de:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e2:	8361                	srli	a4,a4,0x18
ffffffffc02008e4:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e8:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008ec:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008f0:	00cb7633          	and	a2,s6,a2
ffffffffc02008f4:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f8:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008fc:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200900:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200904:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200908:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020090c:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200910:	011b78b3          	and	a7,s6,a7
ffffffffc0200914:	005eeeb3          	or	t4,t4,t0
ffffffffc0200918:	00c6e733          	or	a4,a3,a2
ffffffffc020091c:	006c6c33          	or	s8,s8,t1
ffffffffc0200920:	010b76b3          	and	a3,s6,a6
ffffffffc0200924:	00bb7b33          	and	s6,s6,a1
ffffffffc0200928:	01d7e7b3          	or	a5,a5,t4
ffffffffc020092c:	016c6b33          	or	s6,s8,s6
ffffffffc0200930:	01146433          	or	s0,s0,a7
ffffffffc0200934:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	1702                	slli	a4,a4,0x20
ffffffffc0200938:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200940:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200944:	0167eb33          	or	s6,a5,s6
ffffffffc0200948:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020094a:	84bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020094e:	85a2                	mv	a1,s0
ffffffffc0200950:	00005517          	auipc	a0,0x5
ffffffffc0200954:	10050513          	addi	a0,a0,256 # ffffffffc0205a50 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	10650513          	addi	a0,a0,262 # ffffffffc0205a68 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	11450513          	addi	a0,a0,276 # ffffffffc0205a88 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	15850513          	addi	a0,a0,344 # ffffffffc0205ad8 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000aa797          	auipc	a5,0xaa
ffffffffc020098c:	d687b823          	sd	s0,-656(a5) # ffffffffc02aa6f8 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000aa797          	auipc	a5,0xaa
ffffffffc0200994:	d767b823          	sd	s6,-656(a5) # ffffffffc02aa700 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000aa517          	auipc	a0,0xaa
ffffffffc020099e:	d5e53503          	ld	a0,-674(a0) # ffffffffc02aa6f8 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000aa517          	auipc	a0,0xaa
ffffffffc02009a8:	d5c53503          	ld	a0,-676(a0) # ffffffffc02aa700 <memory_size>
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009bc:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c0:	00000797          	auipc	a5,0x0
ffffffffc02009c4:	49478793          	addi	a5,a5,1172 # ffffffffc0200e54 <__alltraps>
ffffffffc02009c8:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009cc:	000407b7          	lui	a5,0x40
ffffffffc02009d0:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d4:	8082                	ret

ffffffffc02009d6 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d6:	610c                	ld	a1,0(a0)
{
ffffffffc02009d8:	1141                	addi	sp,sp,-16
ffffffffc02009da:	e022                	sd	s0,0(sp)
ffffffffc02009dc:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	11250513          	addi	a0,a0,274 # ffffffffc0205af0 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	11a50513          	addi	a0,a0,282 # ffffffffc0205b08 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	12450513          	addi	a0,a0,292 # ffffffffc0205b20 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	12e50513          	addi	a0,a0,302 # ffffffffc0205b38 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	13850513          	addi	a0,a0,312 # ffffffffc0205b50 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	14250513          	addi	a0,a0,322 # ffffffffc0205b68 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	14c50513          	addi	a0,a0,332 # ffffffffc0205b80 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	15650513          	addi	a0,a0,342 # ffffffffc0205b98 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	16050513          	addi	a0,a0,352 # ffffffffc0205bb0 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	16a50513          	addi	a0,a0,362 # ffffffffc0205bc8 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	17450513          	addi	a0,a0,372 # ffffffffc0205be0 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	17e50513          	addi	a0,a0,382 # ffffffffc0205bf8 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	18850513          	addi	a0,a0,392 # ffffffffc0205c10 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	19250513          	addi	a0,a0,402 # ffffffffc0205c28 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	19c50513          	addi	a0,a0,412 # ffffffffc0205c40 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	1a650513          	addi	a0,a0,422 # ffffffffc0205c58 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	1b050513          	addi	a0,a0,432 # ffffffffc0205c70 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	1ba50513          	addi	a0,a0,442 # ffffffffc0205c88 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	1c450513          	addi	a0,a0,452 # ffffffffc0205ca0 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	1ce50513          	addi	a0,a0,462 # ffffffffc0205cb8 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	1d850513          	addi	a0,a0,472 # ffffffffc0205cd0 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	1e250513          	addi	a0,a0,482 # ffffffffc0205ce8 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	1ec50513          	addi	a0,a0,492 # ffffffffc0205d00 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	1f650513          	addi	a0,a0,502 # ffffffffc0205d18 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	20050513          	addi	a0,a0,512 # ffffffffc0205d30 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	20a50513          	addi	a0,a0,522 # ffffffffc0205d48 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	21450513          	addi	a0,a0,532 # ffffffffc0205d60 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	21e50513          	addi	a0,a0,542 # ffffffffc0205d78 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	22850513          	addi	a0,a0,552 # ffffffffc0205d90 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	23250513          	addi	a0,a0,562 # ffffffffc0205da8 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	23c50513          	addi	a0,a0,572 # ffffffffc0205dc0 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	24250513          	addi	a0,a0,578 # ffffffffc0205dd8 <commands+0x4e0>
}
ffffffffc0200b9e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba0:	df4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ba4 <print_trapframe>:
{
ffffffffc0200ba4:	1141                	addi	sp,sp,-16
ffffffffc0200ba6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba8:	85aa                	mv	a1,a0
{
ffffffffc0200baa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	24450513          	addi	a0,a0,580 # ffffffffc0205df0 <commands+0x4f8>
{
ffffffffc0200bb4:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb6:	ddeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bba:	8522                	mv	a0,s0
ffffffffc0200bbc:	e1bff0ef          	jal	ra,ffffffffc02009d6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc0:	10043583          	ld	a1,256(s0)
ffffffffc0200bc4:	00005517          	auipc	a0,0x5
ffffffffc0200bc8:	24450513          	addi	a0,a0,580 # ffffffffc0205e08 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	24c50513          	addi	a0,a0,588 # ffffffffc0205e20 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	25450513          	addi	a0,a0,596 # ffffffffc0205e38 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	25050513          	addi	a0,a0,592 # ffffffffc0205e48 <commands+0x550>
}
ffffffffc0200c00:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200c06 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c06:	11853783          	ld	a5,280(a0)
ffffffffc0200c0a:	472d                	li	a4,11
ffffffffc0200c0c:	0786                	slli	a5,a5,0x1
ffffffffc0200c0e:	8385                	srli	a5,a5,0x1
ffffffffc0200c10:	08f76d63          	bltu	a4,a5,ffffffffc0200caa <interrupt_handler+0xa4>
ffffffffc0200c14:	00005717          	auipc	a4,0x5
ffffffffc0200c18:	2ec70713          	addi	a4,a4,748 # ffffffffc0205f00 <commands+0x608>
ffffffffc0200c1c:	078a                	slli	a5,a5,0x2
ffffffffc0200c1e:	97ba                	add	a5,a5,a4
ffffffffc0200c20:	439c                	lw	a5,0(a5)
ffffffffc0200c22:	97ba                	add	a5,a5,a4
ffffffffc0200c24:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c26:	00005517          	auipc	a0,0x5
ffffffffc0200c2a:	29a50513          	addi	a0,a0,666 # ffffffffc0205ec0 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	26e50513          	addi	a0,a0,622 # ffffffffc0205ea0 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	22250513          	addi	a0,a0,546 # ffffffffc0205e60 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	23650513          	addi	a0,a0,566 # ffffffffc0205e80 <commands+0x588>
ffffffffc0200c52:	d42ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c56:	1141                	addi	sp,sp,-16
ffffffffc0200c58:	e406                	sd	ra,8(sp)
         *(2) ticks 计数器自增
         *(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，
         *    如果有则标记该进程需要被重新调度（current->need_resched）
         */
        /* (1) 设置下次时钟中断 */
        clock_set_next_event();
ffffffffc0200c5a:	919ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>

        /* (2) ticks 计数器自增 */
        ticks++;
ffffffffc0200c5e:	000aa797          	auipc	a5,0xaa
ffffffffc0200c62:	a8a78793          	addi	a5,a5,-1398 # ffffffffc02aa6e8 <ticks>
ffffffffc0200c66:	6398                	ld	a4,0(a5)

        /* (3) 每 TICK_NUM 次中断检查当前进程并标记需要重调度 */
        if (ticks >= TICK_NUM) {
ffffffffc0200c68:	06300693          	li	a3,99
        ticks++;
ffffffffc0200c6c:	0705                	addi	a4,a4,1
ffffffffc0200c6e:	e398                	sd	a4,0(a5)
        if (ticks >= TICK_NUM) {
ffffffffc0200c70:	639c                	ld	a5,0(a5)
ffffffffc0200c72:	02f6f363          	bgeu	a3,a5,ffffffffc0200c98 <interrupt_handler+0x92>
            ticks = 0;
ffffffffc0200c76:	000aa797          	auipc	a5,0xaa
ffffffffc0200c7a:	a607b923          	sd	zero,-1422(a5) # ffffffffc02aa6e8 <ticks>
            if (current != NULL && current != idleproc) {
ffffffffc0200c7e:	000aa797          	auipc	a5,0xaa
ffffffffc0200c82:	ac27b783          	ld	a5,-1342(a5) # ffffffffc02aa740 <current>
ffffffffc0200c86:	cb89                	beqz	a5,ffffffffc0200c98 <interrupt_handler+0x92>
ffffffffc0200c88:	000aa717          	auipc	a4,0xaa
ffffffffc0200c8c:	ac073703          	ld	a4,-1344(a4) # ffffffffc02aa748 <idleproc>
ffffffffc0200c90:	00e78463          	beq	a5,a4,ffffffffc0200c98 <interrupt_handler+0x92>
                current->need_resched = 1;
ffffffffc0200c94:	4705                	li	a4,1
ffffffffc0200c96:	ef98                	sd	a4,24(a5)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c98:	60a2                	ld	ra,8(sp)
ffffffffc0200c9a:	0141                	addi	sp,sp,16
ffffffffc0200c9c:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c9e:	00005517          	auipc	a0,0x5
ffffffffc0200ca2:	24250513          	addi	a0,a0,578 # ffffffffc0205ee0 <commands+0x5e8>
ffffffffc0200ca6:	ceeff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200caa:	bded                	j	ffffffffc0200ba4 <print_trapframe>

ffffffffc0200cac <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cac:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cb0:	1141                	addi	sp,sp,-16
ffffffffc0200cb2:	e022                	sd	s0,0(sp)
ffffffffc0200cb4:	e406                	sd	ra,8(sp)
ffffffffc0200cb6:	473d                	li	a4,15
ffffffffc0200cb8:	842a                	mv	s0,a0
ffffffffc0200cba:	0cf76463          	bltu	a4,a5,ffffffffc0200d82 <exception_handler+0xd6>
ffffffffc0200cbe:	00005717          	auipc	a4,0x5
ffffffffc0200cc2:	40270713          	addi	a4,a4,1026 # ffffffffc02060c0 <commands+0x7c8>
ffffffffc0200cc6:	078a                	slli	a5,a5,0x2
ffffffffc0200cc8:	97ba                	add	a5,a5,a4
ffffffffc0200cca:	439c                	lw	a5,0(a5)
ffffffffc0200ccc:	97ba                	add	a5,a5,a4
ffffffffc0200cce:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cd0:	00005517          	auipc	a0,0x5
ffffffffc0200cd4:	34850513          	addi	a0,a0,840 # ffffffffc0206018 <commands+0x720>
ffffffffc0200cd8:	cbcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cdc:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200ce0:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200ce2:	0791                	addi	a5,a5,4
ffffffffc0200ce4:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200ce8:	6402                	ld	s0,0(sp)
ffffffffc0200cea:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200cec:	4500406f          	j	ffffffffc020513c <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200cf0:	00005517          	auipc	a0,0x5
ffffffffc0200cf4:	34850513          	addi	a0,a0,840 # ffffffffc0206038 <commands+0x740>
}
ffffffffc0200cf8:	6402                	ld	s0,0(sp)
ffffffffc0200cfa:	60a2                	ld	ra,8(sp)
ffffffffc0200cfc:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200cfe:	c96ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d02:	00005517          	auipc	a0,0x5
ffffffffc0200d06:	35650513          	addi	a0,a0,854 # ffffffffc0206058 <commands+0x760>
ffffffffc0200d0a:	b7fd                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200d0c:	00005517          	auipc	a0,0x5
ffffffffc0200d10:	36c50513          	addi	a0,a0,876 # ffffffffc0206078 <commands+0x780>
ffffffffc0200d14:	b7d5                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d16:	00005517          	auipc	a0,0x5
ffffffffc0200d1a:	37a50513          	addi	a0,a0,890 # ffffffffc0206090 <commands+0x798>
ffffffffc0200d1e:	bfe9                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d20:	00005517          	auipc	a0,0x5
ffffffffc0200d24:	38850513          	addi	a0,a0,904 # ffffffffc02060a8 <commands+0x7b0>
ffffffffc0200d28:	bfc1                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d2a:	00005517          	auipc	a0,0x5
ffffffffc0200d2e:	20650513          	addi	a0,a0,518 # ffffffffc0205f30 <commands+0x638>
ffffffffc0200d32:	b7d9                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d34:	00005517          	auipc	a0,0x5
ffffffffc0200d38:	21c50513          	addi	a0,a0,540 # ffffffffc0205f50 <commands+0x658>
ffffffffc0200d3c:	bf75                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d3e:	00005517          	auipc	a0,0x5
ffffffffc0200d42:	23250513          	addi	a0,a0,562 # ffffffffc0205f70 <commands+0x678>
ffffffffc0200d46:	bf4d                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d48:	00005517          	auipc	a0,0x5
ffffffffc0200d4c:	24050513          	addi	a0,a0,576 # ffffffffc0205f88 <commands+0x690>
ffffffffc0200d50:	c44ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d54:	6458                	ld	a4,136(s0)
ffffffffc0200d56:	47a9                	li	a5,10
ffffffffc0200d58:	04f70663          	beq	a4,a5,ffffffffc0200da4 <exception_handler+0xf8>
}
ffffffffc0200d5c:	60a2                	ld	ra,8(sp)
ffffffffc0200d5e:	6402                	ld	s0,0(sp)
ffffffffc0200d60:	0141                	addi	sp,sp,16
ffffffffc0200d62:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200d64:	00005517          	auipc	a0,0x5
ffffffffc0200d68:	23450513          	addi	a0,a0,564 # ffffffffc0205f98 <commands+0x6a0>
ffffffffc0200d6c:	b771                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d6e:	00005517          	auipc	a0,0x5
ffffffffc0200d72:	24a50513          	addi	a0,a0,586 # ffffffffc0205fb8 <commands+0x6c0>
ffffffffc0200d76:	b749                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d78:	00005517          	auipc	a0,0x5
ffffffffc0200d7c:	28850513          	addi	a0,a0,648 # ffffffffc0206000 <commands+0x708>
ffffffffc0200d80:	bfa5                	j	ffffffffc0200cf8 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d82:	8522                	mv	a0,s0
}
ffffffffc0200d84:	6402                	ld	s0,0(sp)
ffffffffc0200d86:	60a2                	ld	ra,8(sp)
ffffffffc0200d88:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200d8a:	bd29                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d8c:	00005617          	auipc	a2,0x5
ffffffffc0200d90:	24460613          	addi	a2,a2,580 # ffffffffc0205fd0 <commands+0x6d8>
ffffffffc0200d94:	0c700593          	li	a1,199
ffffffffc0200d98:	00005517          	auipc	a0,0x5
ffffffffc0200d9c:	25050513          	addi	a0,a0,592 # ffffffffc0205fe8 <commands+0x6f0>
ffffffffc0200da0:	eeeff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200da4:	10843783          	ld	a5,264(s0)
ffffffffc0200da8:	0791                	addi	a5,a5,4
ffffffffc0200daa:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200dae:	38e040ef          	jal	ra,ffffffffc020513c <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200db2:	000aa797          	auipc	a5,0xaa
ffffffffc0200db6:	98e7b783          	ld	a5,-1650(a5) # ffffffffc02aa740 <current>
ffffffffc0200dba:	6b9c                	ld	a5,16(a5)
ffffffffc0200dbc:	8522                	mv	a0,s0
}
ffffffffc0200dbe:	6402                	ld	s0,0(sp)
ffffffffc0200dc0:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dc2:	6589                	lui	a1,0x2
ffffffffc0200dc4:	95be                	add	a1,a1,a5
}
ffffffffc0200dc6:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dc8:	aaa9                	j	ffffffffc0200f22 <kernel_execve_ret>

ffffffffc0200dca <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200dca:	1101                	addi	sp,sp,-32
ffffffffc0200dcc:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200dce:	000aa417          	auipc	s0,0xaa
ffffffffc0200dd2:	97240413          	addi	s0,s0,-1678 # ffffffffc02aa740 <current>
ffffffffc0200dd6:	6018                	ld	a4,0(s0)
{
ffffffffc0200dd8:	ec06                	sd	ra,24(sp)
ffffffffc0200dda:	e426                	sd	s1,8(sp)
ffffffffc0200ddc:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dde:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200de2:	cf1d                	beqz	a4,ffffffffc0200e20 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200de4:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200de8:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200dec:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dee:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200df2:	0206c463          	bltz	a3,ffffffffc0200e1a <trap+0x50>
        exception_handler(tf);
ffffffffc0200df6:	eb7ff0ef          	jal	ra,ffffffffc0200cac <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200dfa:	601c                	ld	a5,0(s0)
ffffffffc0200dfc:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200e00:	e499                	bnez	s1,ffffffffc0200e0e <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e02:	0b07a703          	lw	a4,176(a5)
ffffffffc0200e06:	8b05                	andi	a4,a4,1
ffffffffc0200e08:	e329                	bnez	a4,ffffffffc0200e4a <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e0a:	6f9c                	ld	a5,24(a5)
ffffffffc0200e0c:	eb85                	bnez	a5,ffffffffc0200e3c <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e0e:	60e2                	ld	ra,24(sp)
ffffffffc0200e10:	6442                	ld	s0,16(sp)
ffffffffc0200e12:	64a2                	ld	s1,8(sp)
ffffffffc0200e14:	6902                	ld	s2,0(sp)
ffffffffc0200e16:	6105                	addi	sp,sp,32
ffffffffc0200e18:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e1a:	dedff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200e1e:	bff1                	j	ffffffffc0200dfa <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e20:	0006c863          	bltz	a3,ffffffffc0200e30 <trap+0x66>
}
ffffffffc0200e24:	6442                	ld	s0,16(sp)
ffffffffc0200e26:	60e2                	ld	ra,24(sp)
ffffffffc0200e28:	64a2                	ld	s1,8(sp)
ffffffffc0200e2a:	6902                	ld	s2,0(sp)
ffffffffc0200e2c:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e2e:	bdbd                	j	ffffffffc0200cac <exception_handler>
}
ffffffffc0200e30:	6442                	ld	s0,16(sp)
ffffffffc0200e32:	60e2                	ld	ra,24(sp)
ffffffffc0200e34:	64a2                	ld	s1,8(sp)
ffffffffc0200e36:	6902                	ld	s2,0(sp)
ffffffffc0200e38:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e3a:	b3f1                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0200e3c:	6442                	ld	s0,16(sp)
ffffffffc0200e3e:	60e2                	ld	ra,24(sp)
ffffffffc0200e40:	64a2                	ld	s1,8(sp)
ffffffffc0200e42:	6902                	ld	s2,0(sp)
ffffffffc0200e44:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e46:	20a0406f          	j	ffffffffc0205050 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e4a:	555d                	li	a0,-9
ffffffffc0200e4c:	54a030ef          	jal	ra,ffffffffc0204396 <do_exit>
            if (current->need_resched)
ffffffffc0200e50:	601c                	ld	a5,0(s0)
ffffffffc0200e52:	bf65                	j	ffffffffc0200e0a <trap+0x40>

ffffffffc0200e54 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e54:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e58:	00011463          	bnez	sp,ffffffffc0200e60 <__alltraps+0xc>
ffffffffc0200e5c:	14002173          	csrr	sp,sscratch
ffffffffc0200e60:	712d                	addi	sp,sp,-288
ffffffffc0200e62:	e002                	sd	zero,0(sp)
ffffffffc0200e64:	e406                	sd	ra,8(sp)
ffffffffc0200e66:	ec0e                	sd	gp,24(sp)
ffffffffc0200e68:	f012                	sd	tp,32(sp)
ffffffffc0200e6a:	f416                	sd	t0,40(sp)
ffffffffc0200e6c:	f81a                	sd	t1,48(sp)
ffffffffc0200e6e:	fc1e                	sd	t2,56(sp)
ffffffffc0200e70:	e0a2                	sd	s0,64(sp)
ffffffffc0200e72:	e4a6                	sd	s1,72(sp)
ffffffffc0200e74:	e8aa                	sd	a0,80(sp)
ffffffffc0200e76:	ecae                	sd	a1,88(sp)
ffffffffc0200e78:	f0b2                	sd	a2,96(sp)
ffffffffc0200e7a:	f4b6                	sd	a3,104(sp)
ffffffffc0200e7c:	f8ba                	sd	a4,112(sp)
ffffffffc0200e7e:	fcbe                	sd	a5,120(sp)
ffffffffc0200e80:	e142                	sd	a6,128(sp)
ffffffffc0200e82:	e546                	sd	a7,136(sp)
ffffffffc0200e84:	e94a                	sd	s2,144(sp)
ffffffffc0200e86:	ed4e                	sd	s3,152(sp)
ffffffffc0200e88:	f152                	sd	s4,160(sp)
ffffffffc0200e8a:	f556                	sd	s5,168(sp)
ffffffffc0200e8c:	f95a                	sd	s6,176(sp)
ffffffffc0200e8e:	fd5e                	sd	s7,184(sp)
ffffffffc0200e90:	e1e2                	sd	s8,192(sp)
ffffffffc0200e92:	e5e6                	sd	s9,200(sp)
ffffffffc0200e94:	e9ea                	sd	s10,208(sp)
ffffffffc0200e96:	edee                	sd	s11,216(sp)
ffffffffc0200e98:	f1f2                	sd	t3,224(sp)
ffffffffc0200e9a:	f5f6                	sd	t4,232(sp)
ffffffffc0200e9c:	f9fa                	sd	t5,240(sp)
ffffffffc0200e9e:	fdfe                	sd	t6,248(sp)
ffffffffc0200ea0:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200ea4:	100024f3          	csrr	s1,sstatus
ffffffffc0200ea8:	14102973          	csrr	s2,sepc
ffffffffc0200eac:	143029f3          	csrr	s3,stval
ffffffffc0200eb0:	14202a73          	csrr	s4,scause
ffffffffc0200eb4:	e822                	sd	s0,16(sp)
ffffffffc0200eb6:	e226                	sd	s1,256(sp)
ffffffffc0200eb8:	e64a                	sd	s2,264(sp)
ffffffffc0200eba:	ea4e                	sd	s3,272(sp)
ffffffffc0200ebc:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200ebe:	850a                	mv	a0,sp
    jal trap
ffffffffc0200ec0:	f0bff0ef          	jal	ra,ffffffffc0200dca <trap>

ffffffffc0200ec4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ec4:	6492                	ld	s1,256(sp)
ffffffffc0200ec6:	6932                	ld	s2,264(sp)
ffffffffc0200ec8:	1004f413          	andi	s0,s1,256
ffffffffc0200ecc:	e401                	bnez	s0,ffffffffc0200ed4 <__trapret+0x10>
ffffffffc0200ece:	1200                	addi	s0,sp,288
ffffffffc0200ed0:	14041073          	csrw	sscratch,s0
ffffffffc0200ed4:	10049073          	csrw	sstatus,s1
ffffffffc0200ed8:	14191073          	csrw	sepc,s2
ffffffffc0200edc:	60a2                	ld	ra,8(sp)
ffffffffc0200ede:	61e2                	ld	gp,24(sp)
ffffffffc0200ee0:	7202                	ld	tp,32(sp)
ffffffffc0200ee2:	72a2                	ld	t0,40(sp)
ffffffffc0200ee4:	7342                	ld	t1,48(sp)
ffffffffc0200ee6:	73e2                	ld	t2,56(sp)
ffffffffc0200ee8:	6406                	ld	s0,64(sp)
ffffffffc0200eea:	64a6                	ld	s1,72(sp)
ffffffffc0200eec:	6546                	ld	a0,80(sp)
ffffffffc0200eee:	65e6                	ld	a1,88(sp)
ffffffffc0200ef0:	7606                	ld	a2,96(sp)
ffffffffc0200ef2:	76a6                	ld	a3,104(sp)
ffffffffc0200ef4:	7746                	ld	a4,112(sp)
ffffffffc0200ef6:	77e6                	ld	a5,120(sp)
ffffffffc0200ef8:	680a                	ld	a6,128(sp)
ffffffffc0200efa:	68aa                	ld	a7,136(sp)
ffffffffc0200efc:	694a                	ld	s2,144(sp)
ffffffffc0200efe:	69ea                	ld	s3,152(sp)
ffffffffc0200f00:	7a0a                	ld	s4,160(sp)
ffffffffc0200f02:	7aaa                	ld	s5,168(sp)
ffffffffc0200f04:	7b4a                	ld	s6,176(sp)
ffffffffc0200f06:	7bea                	ld	s7,184(sp)
ffffffffc0200f08:	6c0e                	ld	s8,192(sp)
ffffffffc0200f0a:	6cae                	ld	s9,200(sp)
ffffffffc0200f0c:	6d4e                	ld	s10,208(sp)
ffffffffc0200f0e:	6dee                	ld	s11,216(sp)
ffffffffc0200f10:	7e0e                	ld	t3,224(sp)
ffffffffc0200f12:	7eae                	ld	t4,232(sp)
ffffffffc0200f14:	7f4e                	ld	t5,240(sp)
ffffffffc0200f16:	7fee                	ld	t6,248(sp)
ffffffffc0200f18:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f1a:	10200073          	sret

ffffffffc0200f1e <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f1e:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f20:	b755                	j	ffffffffc0200ec4 <__trapret>

ffffffffc0200f22 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f22:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cc8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f26:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f2a:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f2e:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f32:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f36:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f3a:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f3e:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f42:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f46:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f48:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f4a:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f4c:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f4e:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f50:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f52:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f54:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f56:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f58:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f5a:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f5c:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f5e:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f60:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f62:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f64:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f66:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f68:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f6a:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f6c:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f6e:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f70:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f72:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f74:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f76:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f78:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f7a:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f7c:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f7e:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f80:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f82:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200f84:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200f86:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200f88:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200f8a:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200f8c:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200f8e:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200f90:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200f92:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200f94:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200f96:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200f98:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200f9a:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200f9c:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200f9e:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200fa0:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200fa2:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200fa4:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200fa6:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200fa8:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200faa:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200fac:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200fae:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200fb0:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200fb2:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200fb4:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200fb6:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200fb8:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200fba:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200fbc:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200fbe:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200fc0:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200fc2:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200fc4:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200fc6:	812e                	mv	sp,a1
ffffffffc0200fc8:	bdf5                	j	ffffffffc0200ec4 <__trapret>

ffffffffc0200fca <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fca:	000a5797          	auipc	a5,0xa5
ffffffffc0200fce:	6ee78793          	addi	a5,a5,1774 # ffffffffc02a66b8 <free_area>
ffffffffc0200fd2:	e79c                	sd	a5,8(a5)
ffffffffc0200fd4:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200fd6:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200fda:	8082                	ret

ffffffffc0200fdc <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200fdc:	000a5517          	auipc	a0,0xa5
ffffffffc0200fe0:	6ec56503          	lwu	a0,1772(a0) # ffffffffc02a66c8 <free_area+0x10>
ffffffffc0200fe4:	8082                	ret

ffffffffc0200fe6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200fe6:	715d                	addi	sp,sp,-80
ffffffffc0200fe8:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200fea:	000a5417          	auipc	s0,0xa5
ffffffffc0200fee:	6ce40413          	addi	s0,s0,1742 # ffffffffc02a66b8 <free_area>
ffffffffc0200ff2:	641c                	ld	a5,8(s0)
ffffffffc0200ff4:	e486                	sd	ra,72(sp)
ffffffffc0200ff6:	fc26                	sd	s1,56(sp)
ffffffffc0200ff8:	f84a                	sd	s2,48(sp)
ffffffffc0200ffa:	f44e                	sd	s3,40(sp)
ffffffffc0200ffc:	f052                	sd	s4,32(sp)
ffffffffc0200ffe:	ec56                	sd	s5,24(sp)
ffffffffc0201000:	e85a                	sd	s6,16(sp)
ffffffffc0201002:	e45e                	sd	s7,8(sp)
ffffffffc0201004:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201006:	2a878d63          	beq	a5,s0,ffffffffc02012c0 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc020100a:	4481                	li	s1,0
ffffffffc020100c:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020100e:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201012:	8b09                	andi	a4,a4,2
ffffffffc0201014:	2a070a63          	beqz	a4,ffffffffc02012c8 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201018:	ff87a703          	lw	a4,-8(a5)
ffffffffc020101c:	679c                	ld	a5,8(a5)
ffffffffc020101e:	2905                	addiw	s2,s2,1
ffffffffc0201020:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201022:	fe8796e3          	bne	a5,s0,ffffffffc020100e <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201026:	89a6                	mv	s3,s1
ffffffffc0201028:	6df000ef          	jal	ra,ffffffffc0201f06 <nr_free_pages>
ffffffffc020102c:	6f351e63          	bne	a0,s3,ffffffffc0201728 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201030:	4505                	li	a0,1
ffffffffc0201032:	657000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc0201036:	8aaa                	mv	s5,a0
ffffffffc0201038:	42050863          	beqz	a0,ffffffffc0201468 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020103c:	4505                	li	a0,1
ffffffffc020103e:	64b000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc0201042:	89aa                	mv	s3,a0
ffffffffc0201044:	70050263          	beqz	a0,ffffffffc0201748 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201048:	4505                	li	a0,1
ffffffffc020104a:	63f000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020104e:	8a2a                	mv	s4,a0
ffffffffc0201050:	48050c63          	beqz	a0,ffffffffc02014e8 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201054:	293a8a63          	beq	s5,s3,ffffffffc02012e8 <default_check+0x302>
ffffffffc0201058:	28aa8863          	beq	s5,a0,ffffffffc02012e8 <default_check+0x302>
ffffffffc020105c:	28a98663          	beq	s3,a0,ffffffffc02012e8 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201060:	000aa783          	lw	a5,0(s5)
ffffffffc0201064:	2a079263          	bnez	a5,ffffffffc0201308 <default_check+0x322>
ffffffffc0201068:	0009a783          	lw	a5,0(s3)
ffffffffc020106c:	28079e63          	bnez	a5,ffffffffc0201308 <default_check+0x322>
ffffffffc0201070:	411c                	lw	a5,0(a0)
ffffffffc0201072:	28079b63          	bnez	a5,ffffffffc0201308 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201076:	000a9797          	auipc	a5,0xa9
ffffffffc020107a:	6b27b783          	ld	a5,1714(a5) # ffffffffc02aa728 <pages>
ffffffffc020107e:	40fa8733          	sub	a4,s5,a5
ffffffffc0201082:	00006617          	auipc	a2,0x6
ffffffffc0201086:	74663603          	ld	a2,1862(a2) # ffffffffc02077c8 <nbase>
ffffffffc020108a:	8719                	srai	a4,a4,0x6
ffffffffc020108c:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020108e:	000a9697          	auipc	a3,0xa9
ffffffffc0201092:	6926b683          	ld	a3,1682(a3) # ffffffffc02aa720 <npage>
ffffffffc0201096:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0201098:	0732                	slli	a4,a4,0xc
ffffffffc020109a:	28d77763          	bgeu	a4,a3,ffffffffc0201328 <default_check+0x342>
    return page - pages + nbase;
ffffffffc020109e:	40f98733          	sub	a4,s3,a5
ffffffffc02010a2:	8719                	srai	a4,a4,0x6
ffffffffc02010a4:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010a6:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010a8:	4cd77063          	bgeu	a4,a3,ffffffffc0201568 <default_check+0x582>
    return page - pages + nbase;
ffffffffc02010ac:	40f507b3          	sub	a5,a0,a5
ffffffffc02010b0:	8799                	srai	a5,a5,0x6
ffffffffc02010b2:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010b4:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02010b6:	30d7f963          	bgeu	a5,a3,ffffffffc02013c8 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc02010ba:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010bc:	00043c03          	ld	s8,0(s0)
ffffffffc02010c0:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc02010c4:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02010c8:	e400                	sd	s0,8(s0)
ffffffffc02010ca:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02010cc:	000a5797          	auipc	a5,0xa5
ffffffffc02010d0:	5e07ae23          	sw	zero,1532(a5) # ffffffffc02a66c8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010d4:	5b5000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc02010d8:	2c051863          	bnez	a0,ffffffffc02013a8 <default_check+0x3c2>
    free_page(p0);
ffffffffc02010dc:	4585                	li	a1,1
ffffffffc02010de:	8556                	mv	a0,s5
ffffffffc02010e0:	5e7000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    free_page(p1);
ffffffffc02010e4:	4585                	li	a1,1
ffffffffc02010e6:	854e                	mv	a0,s3
ffffffffc02010e8:	5df000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    free_page(p2);
ffffffffc02010ec:	4585                	li	a1,1
ffffffffc02010ee:	8552                	mv	a0,s4
ffffffffc02010f0:	5d7000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    assert(nr_free == 3);
ffffffffc02010f4:	4818                	lw	a4,16(s0)
ffffffffc02010f6:	478d                	li	a5,3
ffffffffc02010f8:	28f71863          	bne	a4,a5,ffffffffc0201388 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010fc:	4505                	li	a0,1
ffffffffc02010fe:	58b000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc0201102:	89aa                	mv	s3,a0
ffffffffc0201104:	26050263          	beqz	a0,ffffffffc0201368 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201108:	4505                	li	a0,1
ffffffffc020110a:	57f000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020110e:	8aaa                	mv	s5,a0
ffffffffc0201110:	3a050c63          	beqz	a0,ffffffffc02014c8 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201114:	4505                	li	a0,1
ffffffffc0201116:	573000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020111a:	8a2a                	mv	s4,a0
ffffffffc020111c:	38050663          	beqz	a0,ffffffffc02014a8 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201120:	4505                	li	a0,1
ffffffffc0201122:	567000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc0201126:	36051163          	bnez	a0,ffffffffc0201488 <default_check+0x4a2>
    free_page(p0);
ffffffffc020112a:	4585                	li	a1,1
ffffffffc020112c:	854e                	mv	a0,s3
ffffffffc020112e:	599000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201132:	641c                	ld	a5,8(s0)
ffffffffc0201134:	20878a63          	beq	a5,s0,ffffffffc0201348 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201138:	4505                	li	a0,1
ffffffffc020113a:	54f000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020113e:	30a99563          	bne	s3,a0,ffffffffc0201448 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201142:	4505                	li	a0,1
ffffffffc0201144:	545000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc0201148:	2e051063          	bnez	a0,ffffffffc0201428 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc020114c:	481c                	lw	a5,16(s0)
ffffffffc020114e:	2a079d63          	bnez	a5,ffffffffc0201408 <default_check+0x422>
    free_page(p);
ffffffffc0201152:	854e                	mv	a0,s3
ffffffffc0201154:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201156:	01843023          	sd	s8,0(s0)
ffffffffc020115a:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020115e:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201162:	565000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    free_page(p1);
ffffffffc0201166:	4585                	li	a1,1
ffffffffc0201168:	8556                	mv	a0,s5
ffffffffc020116a:	55d000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    free_page(p2);
ffffffffc020116e:	4585                	li	a1,1
ffffffffc0201170:	8552                	mv	a0,s4
ffffffffc0201172:	555000ef          	jal	ra,ffffffffc0201ec6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201176:	4515                	li	a0,5
ffffffffc0201178:	511000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020117c:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020117e:	26050563          	beqz	a0,ffffffffc02013e8 <default_check+0x402>
ffffffffc0201182:	651c                	ld	a5,8(a0)
ffffffffc0201184:	8385                	srli	a5,a5,0x1
ffffffffc0201186:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201188:	54079063          	bnez	a5,ffffffffc02016c8 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020118c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020118e:	00043b03          	ld	s6,0(s0)
ffffffffc0201192:	00843a83          	ld	s5,8(s0)
ffffffffc0201196:	e000                	sd	s0,0(s0)
ffffffffc0201198:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc020119a:	4ef000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020119e:	50051563          	bnez	a0,ffffffffc02016a8 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011a2:	08098a13          	addi	s4,s3,128
ffffffffc02011a6:	8552                	mv	a0,s4
ffffffffc02011a8:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02011aa:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02011ae:	000a5797          	auipc	a5,0xa5
ffffffffc02011b2:	5007ad23          	sw	zero,1306(a5) # ffffffffc02a66c8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02011b6:	511000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011ba:	4511                	li	a0,4
ffffffffc02011bc:	4cd000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc02011c0:	4c051463          	bnez	a0,ffffffffc0201688 <default_check+0x6a2>
ffffffffc02011c4:	0889b783          	ld	a5,136(s3)
ffffffffc02011c8:	8385                	srli	a5,a5,0x1
ffffffffc02011ca:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011cc:	48078e63          	beqz	a5,ffffffffc0201668 <default_check+0x682>
ffffffffc02011d0:	0909a703          	lw	a4,144(s3)
ffffffffc02011d4:	478d                	li	a5,3
ffffffffc02011d6:	48f71963          	bne	a4,a5,ffffffffc0201668 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011da:	450d                	li	a0,3
ffffffffc02011dc:	4ad000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc02011e0:	8c2a                	mv	s8,a0
ffffffffc02011e2:	46050363          	beqz	a0,ffffffffc0201648 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02011e6:	4505                	li	a0,1
ffffffffc02011e8:	4a1000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc02011ec:	42051e63          	bnez	a0,ffffffffc0201628 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc02011f0:	418a1c63          	bne	s4,s8,ffffffffc0201608 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02011f4:	4585                	li	a1,1
ffffffffc02011f6:	854e                	mv	a0,s3
ffffffffc02011f8:	4cf000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    free_pages(p1, 3);
ffffffffc02011fc:	458d                	li	a1,3
ffffffffc02011fe:	8552                	mv	a0,s4
ffffffffc0201200:	4c7000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
ffffffffc0201204:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201208:	04098c13          	addi	s8,s3,64
ffffffffc020120c:	8385                	srli	a5,a5,0x1
ffffffffc020120e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201210:	3c078c63          	beqz	a5,ffffffffc02015e8 <default_check+0x602>
ffffffffc0201214:	0109a703          	lw	a4,16(s3)
ffffffffc0201218:	4785                	li	a5,1
ffffffffc020121a:	3cf71763          	bne	a4,a5,ffffffffc02015e8 <default_check+0x602>
ffffffffc020121e:	008a3783          	ld	a5,8(s4)
ffffffffc0201222:	8385                	srli	a5,a5,0x1
ffffffffc0201224:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201226:	3a078163          	beqz	a5,ffffffffc02015c8 <default_check+0x5e2>
ffffffffc020122a:	010a2703          	lw	a4,16(s4)
ffffffffc020122e:	478d                	li	a5,3
ffffffffc0201230:	38f71c63          	bne	a4,a5,ffffffffc02015c8 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201234:	4505                	li	a0,1
ffffffffc0201236:	453000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020123a:	36a99763          	bne	s3,a0,ffffffffc02015a8 <default_check+0x5c2>
    free_page(p0);
ffffffffc020123e:	4585                	li	a1,1
ffffffffc0201240:	487000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201244:	4509                	li	a0,2
ffffffffc0201246:	443000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020124a:	32aa1f63          	bne	s4,a0,ffffffffc0201588 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020124e:	4589                	li	a1,2
ffffffffc0201250:	477000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    free_page(p2);
ffffffffc0201254:	4585                	li	a1,1
ffffffffc0201256:	8562                	mv	a0,s8
ffffffffc0201258:	46f000ef          	jal	ra,ffffffffc0201ec6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020125c:	4515                	li	a0,5
ffffffffc020125e:	42b000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc0201262:	89aa                	mv	s3,a0
ffffffffc0201264:	48050263          	beqz	a0,ffffffffc02016e8 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201268:	4505                	li	a0,1
ffffffffc020126a:	41f000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc020126e:	2c051d63          	bnez	a0,ffffffffc0201548 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201272:	481c                	lw	a5,16(s0)
ffffffffc0201274:	2a079a63          	bnez	a5,ffffffffc0201528 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201278:	4595                	li	a1,5
ffffffffc020127a:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc020127c:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201280:	01643023          	sd	s6,0(s0)
ffffffffc0201284:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201288:	43f000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    return listelm->next;
ffffffffc020128c:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020128e:	00878963          	beq	a5,s0,ffffffffc02012a0 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201292:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201296:	679c                	ld	a5,8(a5)
ffffffffc0201298:	397d                	addiw	s2,s2,-1
ffffffffc020129a:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020129c:	fe879be3          	bne	a5,s0,ffffffffc0201292 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02012a0:	26091463          	bnez	s2,ffffffffc0201508 <default_check+0x522>
    assert(total == 0);
ffffffffc02012a4:	46049263          	bnez	s1,ffffffffc0201708 <default_check+0x722>
}
ffffffffc02012a8:	60a6                	ld	ra,72(sp)
ffffffffc02012aa:	6406                	ld	s0,64(sp)
ffffffffc02012ac:	74e2                	ld	s1,56(sp)
ffffffffc02012ae:	7942                	ld	s2,48(sp)
ffffffffc02012b0:	79a2                	ld	s3,40(sp)
ffffffffc02012b2:	7a02                	ld	s4,32(sp)
ffffffffc02012b4:	6ae2                	ld	s5,24(sp)
ffffffffc02012b6:	6b42                	ld	s6,16(sp)
ffffffffc02012b8:	6ba2                	ld	s7,8(sp)
ffffffffc02012ba:	6c02                	ld	s8,0(sp)
ffffffffc02012bc:	6161                	addi	sp,sp,80
ffffffffc02012be:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012c0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012c2:	4481                	li	s1,0
ffffffffc02012c4:	4901                	li	s2,0
ffffffffc02012c6:	b38d                	j	ffffffffc0201028 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02012c8:	00005697          	auipc	a3,0x5
ffffffffc02012cc:	e3868693          	addi	a3,a3,-456 # ffffffffc0206100 <commands+0x808>
ffffffffc02012d0:	00005617          	auipc	a2,0x5
ffffffffc02012d4:	e4060613          	addi	a2,a2,-448 # ffffffffc0206110 <commands+0x818>
ffffffffc02012d8:	11000593          	li	a1,272
ffffffffc02012dc:	00005517          	auipc	a0,0x5
ffffffffc02012e0:	e4c50513          	addi	a0,a0,-436 # ffffffffc0206128 <commands+0x830>
ffffffffc02012e4:	9aaff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02012e8:	00005697          	auipc	a3,0x5
ffffffffc02012ec:	ed868693          	addi	a3,a3,-296 # ffffffffc02061c0 <commands+0x8c8>
ffffffffc02012f0:	00005617          	auipc	a2,0x5
ffffffffc02012f4:	e2060613          	addi	a2,a2,-480 # ffffffffc0206110 <commands+0x818>
ffffffffc02012f8:	0db00593          	li	a1,219
ffffffffc02012fc:	00005517          	auipc	a0,0x5
ffffffffc0201300:	e2c50513          	addi	a0,a0,-468 # ffffffffc0206128 <commands+0x830>
ffffffffc0201304:	98aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201308:	00005697          	auipc	a3,0x5
ffffffffc020130c:	ee068693          	addi	a3,a3,-288 # ffffffffc02061e8 <commands+0x8f0>
ffffffffc0201310:	00005617          	auipc	a2,0x5
ffffffffc0201314:	e0060613          	addi	a2,a2,-512 # ffffffffc0206110 <commands+0x818>
ffffffffc0201318:	0dc00593          	li	a1,220
ffffffffc020131c:	00005517          	auipc	a0,0x5
ffffffffc0201320:	e0c50513          	addi	a0,a0,-500 # ffffffffc0206128 <commands+0x830>
ffffffffc0201324:	96aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201328:	00005697          	auipc	a3,0x5
ffffffffc020132c:	f0068693          	addi	a3,a3,-256 # ffffffffc0206228 <commands+0x930>
ffffffffc0201330:	00005617          	auipc	a2,0x5
ffffffffc0201334:	de060613          	addi	a2,a2,-544 # ffffffffc0206110 <commands+0x818>
ffffffffc0201338:	0de00593          	li	a1,222
ffffffffc020133c:	00005517          	auipc	a0,0x5
ffffffffc0201340:	dec50513          	addi	a0,a0,-532 # ffffffffc0206128 <commands+0x830>
ffffffffc0201344:	94aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201348:	00005697          	auipc	a3,0x5
ffffffffc020134c:	f6868693          	addi	a3,a3,-152 # ffffffffc02062b0 <commands+0x9b8>
ffffffffc0201350:	00005617          	auipc	a2,0x5
ffffffffc0201354:	dc060613          	addi	a2,a2,-576 # ffffffffc0206110 <commands+0x818>
ffffffffc0201358:	0f700593          	li	a1,247
ffffffffc020135c:	00005517          	auipc	a0,0x5
ffffffffc0201360:	dcc50513          	addi	a0,a0,-564 # ffffffffc0206128 <commands+0x830>
ffffffffc0201364:	92aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201368:	00005697          	auipc	a3,0x5
ffffffffc020136c:	df868693          	addi	a3,a3,-520 # ffffffffc0206160 <commands+0x868>
ffffffffc0201370:	00005617          	auipc	a2,0x5
ffffffffc0201374:	da060613          	addi	a2,a2,-608 # ffffffffc0206110 <commands+0x818>
ffffffffc0201378:	0f000593          	li	a1,240
ffffffffc020137c:	00005517          	auipc	a0,0x5
ffffffffc0201380:	dac50513          	addi	a0,a0,-596 # ffffffffc0206128 <commands+0x830>
ffffffffc0201384:	90aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc0201388:	00005697          	auipc	a3,0x5
ffffffffc020138c:	f1868693          	addi	a3,a3,-232 # ffffffffc02062a0 <commands+0x9a8>
ffffffffc0201390:	00005617          	auipc	a2,0x5
ffffffffc0201394:	d8060613          	addi	a2,a2,-640 # ffffffffc0206110 <commands+0x818>
ffffffffc0201398:	0ee00593          	li	a1,238
ffffffffc020139c:	00005517          	auipc	a0,0x5
ffffffffc02013a0:	d8c50513          	addi	a0,a0,-628 # ffffffffc0206128 <commands+0x830>
ffffffffc02013a4:	8eaff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013a8:	00005697          	auipc	a3,0x5
ffffffffc02013ac:	ee068693          	addi	a3,a3,-288 # ffffffffc0206288 <commands+0x990>
ffffffffc02013b0:	00005617          	auipc	a2,0x5
ffffffffc02013b4:	d6060613          	addi	a2,a2,-672 # ffffffffc0206110 <commands+0x818>
ffffffffc02013b8:	0e900593          	li	a1,233
ffffffffc02013bc:	00005517          	auipc	a0,0x5
ffffffffc02013c0:	d6c50513          	addi	a0,a0,-660 # ffffffffc0206128 <commands+0x830>
ffffffffc02013c4:	8caff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02013c8:	00005697          	auipc	a3,0x5
ffffffffc02013cc:	ea068693          	addi	a3,a3,-352 # ffffffffc0206268 <commands+0x970>
ffffffffc02013d0:	00005617          	auipc	a2,0x5
ffffffffc02013d4:	d4060613          	addi	a2,a2,-704 # ffffffffc0206110 <commands+0x818>
ffffffffc02013d8:	0e000593          	li	a1,224
ffffffffc02013dc:	00005517          	auipc	a0,0x5
ffffffffc02013e0:	d4c50513          	addi	a0,a0,-692 # ffffffffc0206128 <commands+0x830>
ffffffffc02013e4:	8aaff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc02013e8:	00005697          	auipc	a3,0x5
ffffffffc02013ec:	f1068693          	addi	a3,a3,-240 # ffffffffc02062f8 <commands+0xa00>
ffffffffc02013f0:	00005617          	auipc	a2,0x5
ffffffffc02013f4:	d2060613          	addi	a2,a2,-736 # ffffffffc0206110 <commands+0x818>
ffffffffc02013f8:	11800593          	li	a1,280
ffffffffc02013fc:	00005517          	auipc	a0,0x5
ffffffffc0201400:	d2c50513          	addi	a0,a0,-724 # ffffffffc0206128 <commands+0x830>
ffffffffc0201404:	88aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201408:	00005697          	auipc	a3,0x5
ffffffffc020140c:	ee068693          	addi	a3,a3,-288 # ffffffffc02062e8 <commands+0x9f0>
ffffffffc0201410:	00005617          	auipc	a2,0x5
ffffffffc0201414:	d0060613          	addi	a2,a2,-768 # ffffffffc0206110 <commands+0x818>
ffffffffc0201418:	0fd00593          	li	a1,253
ffffffffc020141c:	00005517          	auipc	a0,0x5
ffffffffc0201420:	d0c50513          	addi	a0,a0,-756 # ffffffffc0206128 <commands+0x830>
ffffffffc0201424:	86aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201428:	00005697          	auipc	a3,0x5
ffffffffc020142c:	e6068693          	addi	a3,a3,-416 # ffffffffc0206288 <commands+0x990>
ffffffffc0201430:	00005617          	auipc	a2,0x5
ffffffffc0201434:	ce060613          	addi	a2,a2,-800 # ffffffffc0206110 <commands+0x818>
ffffffffc0201438:	0fb00593          	li	a1,251
ffffffffc020143c:	00005517          	auipc	a0,0x5
ffffffffc0201440:	cec50513          	addi	a0,a0,-788 # ffffffffc0206128 <commands+0x830>
ffffffffc0201444:	84aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201448:	00005697          	auipc	a3,0x5
ffffffffc020144c:	e8068693          	addi	a3,a3,-384 # ffffffffc02062c8 <commands+0x9d0>
ffffffffc0201450:	00005617          	auipc	a2,0x5
ffffffffc0201454:	cc060613          	addi	a2,a2,-832 # ffffffffc0206110 <commands+0x818>
ffffffffc0201458:	0fa00593          	li	a1,250
ffffffffc020145c:	00005517          	auipc	a0,0x5
ffffffffc0201460:	ccc50513          	addi	a0,a0,-820 # ffffffffc0206128 <commands+0x830>
ffffffffc0201464:	82aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201468:	00005697          	auipc	a3,0x5
ffffffffc020146c:	cf868693          	addi	a3,a3,-776 # ffffffffc0206160 <commands+0x868>
ffffffffc0201470:	00005617          	auipc	a2,0x5
ffffffffc0201474:	ca060613          	addi	a2,a2,-864 # ffffffffc0206110 <commands+0x818>
ffffffffc0201478:	0d700593          	li	a1,215
ffffffffc020147c:	00005517          	auipc	a0,0x5
ffffffffc0201480:	cac50513          	addi	a0,a0,-852 # ffffffffc0206128 <commands+0x830>
ffffffffc0201484:	80aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201488:	00005697          	auipc	a3,0x5
ffffffffc020148c:	e0068693          	addi	a3,a3,-512 # ffffffffc0206288 <commands+0x990>
ffffffffc0201490:	00005617          	auipc	a2,0x5
ffffffffc0201494:	c8060613          	addi	a2,a2,-896 # ffffffffc0206110 <commands+0x818>
ffffffffc0201498:	0f400593          	li	a1,244
ffffffffc020149c:	00005517          	auipc	a0,0x5
ffffffffc02014a0:	c8c50513          	addi	a0,a0,-884 # ffffffffc0206128 <commands+0x830>
ffffffffc02014a4:	febfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014a8:	00005697          	auipc	a3,0x5
ffffffffc02014ac:	cf868693          	addi	a3,a3,-776 # ffffffffc02061a0 <commands+0x8a8>
ffffffffc02014b0:	00005617          	auipc	a2,0x5
ffffffffc02014b4:	c6060613          	addi	a2,a2,-928 # ffffffffc0206110 <commands+0x818>
ffffffffc02014b8:	0f200593          	li	a1,242
ffffffffc02014bc:	00005517          	auipc	a0,0x5
ffffffffc02014c0:	c6c50513          	addi	a0,a0,-916 # ffffffffc0206128 <commands+0x830>
ffffffffc02014c4:	fcbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014c8:	00005697          	auipc	a3,0x5
ffffffffc02014cc:	cb868693          	addi	a3,a3,-840 # ffffffffc0206180 <commands+0x888>
ffffffffc02014d0:	00005617          	auipc	a2,0x5
ffffffffc02014d4:	c4060613          	addi	a2,a2,-960 # ffffffffc0206110 <commands+0x818>
ffffffffc02014d8:	0f100593          	li	a1,241
ffffffffc02014dc:	00005517          	auipc	a0,0x5
ffffffffc02014e0:	c4c50513          	addi	a0,a0,-948 # ffffffffc0206128 <commands+0x830>
ffffffffc02014e4:	fabfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014e8:	00005697          	auipc	a3,0x5
ffffffffc02014ec:	cb868693          	addi	a3,a3,-840 # ffffffffc02061a0 <commands+0x8a8>
ffffffffc02014f0:	00005617          	auipc	a2,0x5
ffffffffc02014f4:	c2060613          	addi	a2,a2,-992 # ffffffffc0206110 <commands+0x818>
ffffffffc02014f8:	0d900593          	li	a1,217
ffffffffc02014fc:	00005517          	auipc	a0,0x5
ffffffffc0201500:	c2c50513          	addi	a0,a0,-980 # ffffffffc0206128 <commands+0x830>
ffffffffc0201504:	f8bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc0201508:	00005697          	auipc	a3,0x5
ffffffffc020150c:	f4068693          	addi	a3,a3,-192 # ffffffffc0206448 <commands+0xb50>
ffffffffc0201510:	00005617          	auipc	a2,0x5
ffffffffc0201514:	c0060613          	addi	a2,a2,-1024 # ffffffffc0206110 <commands+0x818>
ffffffffc0201518:	14600593          	li	a1,326
ffffffffc020151c:	00005517          	auipc	a0,0x5
ffffffffc0201520:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0206128 <commands+0x830>
ffffffffc0201524:	f6bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201528:	00005697          	auipc	a3,0x5
ffffffffc020152c:	dc068693          	addi	a3,a3,-576 # ffffffffc02062e8 <commands+0x9f0>
ffffffffc0201530:	00005617          	auipc	a2,0x5
ffffffffc0201534:	be060613          	addi	a2,a2,-1056 # ffffffffc0206110 <commands+0x818>
ffffffffc0201538:	13a00593          	li	a1,314
ffffffffc020153c:	00005517          	auipc	a0,0x5
ffffffffc0201540:	bec50513          	addi	a0,a0,-1044 # ffffffffc0206128 <commands+0x830>
ffffffffc0201544:	f4bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201548:	00005697          	auipc	a3,0x5
ffffffffc020154c:	d4068693          	addi	a3,a3,-704 # ffffffffc0206288 <commands+0x990>
ffffffffc0201550:	00005617          	auipc	a2,0x5
ffffffffc0201554:	bc060613          	addi	a2,a2,-1088 # ffffffffc0206110 <commands+0x818>
ffffffffc0201558:	13800593          	li	a1,312
ffffffffc020155c:	00005517          	auipc	a0,0x5
ffffffffc0201560:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0206128 <commands+0x830>
ffffffffc0201564:	f2bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201568:	00005697          	auipc	a3,0x5
ffffffffc020156c:	ce068693          	addi	a3,a3,-800 # ffffffffc0206248 <commands+0x950>
ffffffffc0201570:	00005617          	auipc	a2,0x5
ffffffffc0201574:	ba060613          	addi	a2,a2,-1120 # ffffffffc0206110 <commands+0x818>
ffffffffc0201578:	0df00593          	li	a1,223
ffffffffc020157c:	00005517          	auipc	a0,0x5
ffffffffc0201580:	bac50513          	addi	a0,a0,-1108 # ffffffffc0206128 <commands+0x830>
ffffffffc0201584:	f0bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201588:	00005697          	auipc	a3,0x5
ffffffffc020158c:	e8068693          	addi	a3,a3,-384 # ffffffffc0206408 <commands+0xb10>
ffffffffc0201590:	00005617          	auipc	a2,0x5
ffffffffc0201594:	b8060613          	addi	a2,a2,-1152 # ffffffffc0206110 <commands+0x818>
ffffffffc0201598:	13200593          	li	a1,306
ffffffffc020159c:	00005517          	auipc	a0,0x5
ffffffffc02015a0:	b8c50513          	addi	a0,a0,-1140 # ffffffffc0206128 <commands+0x830>
ffffffffc02015a4:	eebfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02015a8:	00005697          	auipc	a3,0x5
ffffffffc02015ac:	e4068693          	addi	a3,a3,-448 # ffffffffc02063e8 <commands+0xaf0>
ffffffffc02015b0:	00005617          	auipc	a2,0x5
ffffffffc02015b4:	b6060613          	addi	a2,a2,-1184 # ffffffffc0206110 <commands+0x818>
ffffffffc02015b8:	13000593          	li	a1,304
ffffffffc02015bc:	00005517          	auipc	a0,0x5
ffffffffc02015c0:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0206128 <commands+0x830>
ffffffffc02015c4:	ecbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015c8:	00005697          	auipc	a3,0x5
ffffffffc02015cc:	df868693          	addi	a3,a3,-520 # ffffffffc02063c0 <commands+0xac8>
ffffffffc02015d0:	00005617          	auipc	a2,0x5
ffffffffc02015d4:	b4060613          	addi	a2,a2,-1216 # ffffffffc0206110 <commands+0x818>
ffffffffc02015d8:	12e00593          	li	a1,302
ffffffffc02015dc:	00005517          	auipc	a0,0x5
ffffffffc02015e0:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0206128 <commands+0x830>
ffffffffc02015e4:	eabfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02015e8:	00005697          	auipc	a3,0x5
ffffffffc02015ec:	db068693          	addi	a3,a3,-592 # ffffffffc0206398 <commands+0xaa0>
ffffffffc02015f0:	00005617          	auipc	a2,0x5
ffffffffc02015f4:	b2060613          	addi	a2,a2,-1248 # ffffffffc0206110 <commands+0x818>
ffffffffc02015f8:	12d00593          	li	a1,301
ffffffffc02015fc:	00005517          	auipc	a0,0x5
ffffffffc0201600:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0206128 <commands+0x830>
ffffffffc0201604:	e8bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201608:	00005697          	auipc	a3,0x5
ffffffffc020160c:	d8068693          	addi	a3,a3,-640 # ffffffffc0206388 <commands+0xa90>
ffffffffc0201610:	00005617          	auipc	a2,0x5
ffffffffc0201614:	b0060613          	addi	a2,a2,-1280 # ffffffffc0206110 <commands+0x818>
ffffffffc0201618:	12800593          	li	a1,296
ffffffffc020161c:	00005517          	auipc	a0,0x5
ffffffffc0201620:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0206128 <commands+0x830>
ffffffffc0201624:	e6bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201628:	00005697          	auipc	a3,0x5
ffffffffc020162c:	c6068693          	addi	a3,a3,-928 # ffffffffc0206288 <commands+0x990>
ffffffffc0201630:	00005617          	auipc	a2,0x5
ffffffffc0201634:	ae060613          	addi	a2,a2,-1312 # ffffffffc0206110 <commands+0x818>
ffffffffc0201638:	12700593          	li	a1,295
ffffffffc020163c:	00005517          	auipc	a0,0x5
ffffffffc0201640:	aec50513          	addi	a0,a0,-1300 # ffffffffc0206128 <commands+0x830>
ffffffffc0201644:	e4bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201648:	00005697          	auipc	a3,0x5
ffffffffc020164c:	d2068693          	addi	a3,a3,-736 # ffffffffc0206368 <commands+0xa70>
ffffffffc0201650:	00005617          	auipc	a2,0x5
ffffffffc0201654:	ac060613          	addi	a2,a2,-1344 # ffffffffc0206110 <commands+0x818>
ffffffffc0201658:	12600593          	li	a1,294
ffffffffc020165c:	00005517          	auipc	a0,0x5
ffffffffc0201660:	acc50513          	addi	a0,a0,-1332 # ffffffffc0206128 <commands+0x830>
ffffffffc0201664:	e2bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201668:	00005697          	auipc	a3,0x5
ffffffffc020166c:	cd068693          	addi	a3,a3,-816 # ffffffffc0206338 <commands+0xa40>
ffffffffc0201670:	00005617          	auipc	a2,0x5
ffffffffc0201674:	aa060613          	addi	a2,a2,-1376 # ffffffffc0206110 <commands+0x818>
ffffffffc0201678:	12500593          	li	a1,293
ffffffffc020167c:	00005517          	auipc	a0,0x5
ffffffffc0201680:	aac50513          	addi	a0,a0,-1364 # ffffffffc0206128 <commands+0x830>
ffffffffc0201684:	e0bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201688:	00005697          	auipc	a3,0x5
ffffffffc020168c:	c9868693          	addi	a3,a3,-872 # ffffffffc0206320 <commands+0xa28>
ffffffffc0201690:	00005617          	auipc	a2,0x5
ffffffffc0201694:	a8060613          	addi	a2,a2,-1408 # ffffffffc0206110 <commands+0x818>
ffffffffc0201698:	12400593          	li	a1,292
ffffffffc020169c:	00005517          	auipc	a0,0x5
ffffffffc02016a0:	a8c50513          	addi	a0,a0,-1396 # ffffffffc0206128 <commands+0x830>
ffffffffc02016a4:	debfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016a8:	00005697          	auipc	a3,0x5
ffffffffc02016ac:	be068693          	addi	a3,a3,-1056 # ffffffffc0206288 <commands+0x990>
ffffffffc02016b0:	00005617          	auipc	a2,0x5
ffffffffc02016b4:	a6060613          	addi	a2,a2,-1440 # ffffffffc0206110 <commands+0x818>
ffffffffc02016b8:	11e00593          	li	a1,286
ffffffffc02016bc:	00005517          	auipc	a0,0x5
ffffffffc02016c0:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0206128 <commands+0x830>
ffffffffc02016c4:	dcbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc02016c8:	00005697          	auipc	a3,0x5
ffffffffc02016cc:	c4068693          	addi	a3,a3,-960 # ffffffffc0206308 <commands+0xa10>
ffffffffc02016d0:	00005617          	auipc	a2,0x5
ffffffffc02016d4:	a4060613          	addi	a2,a2,-1472 # ffffffffc0206110 <commands+0x818>
ffffffffc02016d8:	11900593          	li	a1,281
ffffffffc02016dc:	00005517          	auipc	a0,0x5
ffffffffc02016e0:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0206128 <commands+0x830>
ffffffffc02016e4:	dabfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02016e8:	00005697          	auipc	a3,0x5
ffffffffc02016ec:	d4068693          	addi	a3,a3,-704 # ffffffffc0206428 <commands+0xb30>
ffffffffc02016f0:	00005617          	auipc	a2,0x5
ffffffffc02016f4:	a2060613          	addi	a2,a2,-1504 # ffffffffc0206110 <commands+0x818>
ffffffffc02016f8:	13700593          	li	a1,311
ffffffffc02016fc:	00005517          	auipc	a0,0x5
ffffffffc0201700:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0206128 <commands+0x830>
ffffffffc0201704:	d8bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc0201708:	00005697          	auipc	a3,0x5
ffffffffc020170c:	d5068693          	addi	a3,a3,-688 # ffffffffc0206458 <commands+0xb60>
ffffffffc0201710:	00005617          	auipc	a2,0x5
ffffffffc0201714:	a0060613          	addi	a2,a2,-1536 # ffffffffc0206110 <commands+0x818>
ffffffffc0201718:	14700593          	li	a1,327
ffffffffc020171c:	00005517          	auipc	a0,0x5
ffffffffc0201720:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0206128 <commands+0x830>
ffffffffc0201724:	d6bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc0201728:	00005697          	auipc	a3,0x5
ffffffffc020172c:	a1868693          	addi	a3,a3,-1512 # ffffffffc0206140 <commands+0x848>
ffffffffc0201730:	00005617          	auipc	a2,0x5
ffffffffc0201734:	9e060613          	addi	a2,a2,-1568 # ffffffffc0206110 <commands+0x818>
ffffffffc0201738:	11300593          	li	a1,275
ffffffffc020173c:	00005517          	auipc	a0,0x5
ffffffffc0201740:	9ec50513          	addi	a0,a0,-1556 # ffffffffc0206128 <commands+0x830>
ffffffffc0201744:	d4bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201748:	00005697          	auipc	a3,0x5
ffffffffc020174c:	a3868693          	addi	a3,a3,-1480 # ffffffffc0206180 <commands+0x888>
ffffffffc0201750:	00005617          	auipc	a2,0x5
ffffffffc0201754:	9c060613          	addi	a2,a2,-1600 # ffffffffc0206110 <commands+0x818>
ffffffffc0201758:	0d800593          	li	a1,216
ffffffffc020175c:	00005517          	auipc	a0,0x5
ffffffffc0201760:	9cc50513          	addi	a0,a0,-1588 # ffffffffc0206128 <commands+0x830>
ffffffffc0201764:	d2bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201768 <default_free_pages>:
{
ffffffffc0201768:	1141                	addi	sp,sp,-16
ffffffffc020176a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020176c:	14058463          	beqz	a1,ffffffffc02018b4 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201770:	00659693          	slli	a3,a1,0x6
ffffffffc0201774:	96aa                	add	a3,a3,a0
ffffffffc0201776:	87aa                	mv	a5,a0
ffffffffc0201778:	02d50263          	beq	a0,a3,ffffffffc020179c <default_free_pages+0x34>
ffffffffc020177c:	6798                	ld	a4,8(a5)
ffffffffc020177e:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201780:	10071a63          	bnez	a4,ffffffffc0201894 <default_free_pages+0x12c>
ffffffffc0201784:	6798                	ld	a4,8(a5)
ffffffffc0201786:	8b09                	andi	a4,a4,2
ffffffffc0201788:	10071663          	bnez	a4,ffffffffc0201894 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc020178c:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201790:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201794:	04078793          	addi	a5,a5,64
ffffffffc0201798:	fed792e3          	bne	a5,a3,ffffffffc020177c <default_free_pages+0x14>
    base->property = n;
ffffffffc020179c:	2581                	sext.w	a1,a1
ffffffffc020179e:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017a0:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017a4:	4789                	li	a5,2
ffffffffc02017a6:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02017aa:	000a5697          	auipc	a3,0xa5
ffffffffc02017ae:	f0e68693          	addi	a3,a3,-242 # ffffffffc02a66b8 <free_area>
ffffffffc02017b2:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02017b4:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02017b6:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02017ba:	9db9                	addw	a1,a1,a4
ffffffffc02017bc:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02017be:	0ad78463          	beq	a5,a3,ffffffffc0201866 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02017c2:	fe878713          	addi	a4,a5,-24
ffffffffc02017c6:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02017ca:	4581                	li	a1,0
            if (base < page)
ffffffffc02017cc:	00e56a63          	bltu	a0,a4,ffffffffc02017e0 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02017d0:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02017d2:	04d70c63          	beq	a4,a3,ffffffffc020182a <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02017d6:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017d8:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017dc:	fee57ae3          	bgeu	a0,a4,ffffffffc02017d0 <default_free_pages+0x68>
ffffffffc02017e0:	c199                	beqz	a1,ffffffffc02017e6 <default_free_pages+0x7e>
ffffffffc02017e2:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02017e6:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02017e8:	e390                	sd	a2,0(a5)
ffffffffc02017ea:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02017ec:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02017ee:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc02017f0:	00d70d63          	beq	a4,a3,ffffffffc020180a <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02017f4:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02017f8:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02017fc:	02059813          	slli	a6,a1,0x20
ffffffffc0201800:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201804:	97b2                	add	a5,a5,a2
ffffffffc0201806:	02f50c63          	beq	a0,a5,ffffffffc020183e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020180a:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc020180c:	00d78c63          	beq	a5,a3,ffffffffc0201824 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201810:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201812:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201816:	02061593          	slli	a1,a2,0x20
ffffffffc020181a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020181e:	972a                	add	a4,a4,a0
ffffffffc0201820:	04e68a63          	beq	a3,a4,ffffffffc0201874 <default_free_pages+0x10c>
}
ffffffffc0201824:	60a2                	ld	ra,8(sp)
ffffffffc0201826:	0141                	addi	sp,sp,16
ffffffffc0201828:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020182a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020182c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020182e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201830:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201832:	02d70763          	beq	a4,a3,ffffffffc0201860 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201836:	8832                	mv	a6,a2
ffffffffc0201838:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020183a:	87ba                	mv	a5,a4
ffffffffc020183c:	bf71                	j	ffffffffc02017d8 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020183e:	491c                	lw	a5,16(a0)
ffffffffc0201840:	9dbd                	addw	a1,a1,a5
ffffffffc0201842:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201846:	57f5                	li	a5,-3
ffffffffc0201848:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020184c:	01853803          	ld	a6,24(a0)
ffffffffc0201850:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201852:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201854:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201858:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020185a:	0105b023          	sd	a6,0(a1)
ffffffffc020185e:	b77d                	j	ffffffffc020180c <default_free_pages+0xa4>
ffffffffc0201860:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201862:	873e                	mv	a4,a5
ffffffffc0201864:	bf41                	j	ffffffffc02017f4 <default_free_pages+0x8c>
}
ffffffffc0201866:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201868:	e390                	sd	a2,0(a5)
ffffffffc020186a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020186c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020186e:	ed1c                	sd	a5,24(a0)
ffffffffc0201870:	0141                	addi	sp,sp,16
ffffffffc0201872:	8082                	ret
            base->property += p->property;
ffffffffc0201874:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201878:	ff078693          	addi	a3,a5,-16
ffffffffc020187c:	9e39                	addw	a2,a2,a4
ffffffffc020187e:	c910                	sw	a2,16(a0)
ffffffffc0201880:	5775                	li	a4,-3
ffffffffc0201882:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201886:	6398                	ld	a4,0(a5)
ffffffffc0201888:	679c                	ld	a5,8(a5)
}
ffffffffc020188a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020188c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020188e:	e398                	sd	a4,0(a5)
ffffffffc0201890:	0141                	addi	sp,sp,16
ffffffffc0201892:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201894:	00005697          	auipc	a3,0x5
ffffffffc0201898:	bdc68693          	addi	a3,a3,-1060 # ffffffffc0206470 <commands+0xb78>
ffffffffc020189c:	00005617          	auipc	a2,0x5
ffffffffc02018a0:	87460613          	addi	a2,a2,-1932 # ffffffffc0206110 <commands+0x818>
ffffffffc02018a4:	09400593          	li	a1,148
ffffffffc02018a8:	00005517          	auipc	a0,0x5
ffffffffc02018ac:	88050513          	addi	a0,a0,-1920 # ffffffffc0206128 <commands+0x830>
ffffffffc02018b0:	bdffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc02018b4:	00005697          	auipc	a3,0x5
ffffffffc02018b8:	bb468693          	addi	a3,a3,-1100 # ffffffffc0206468 <commands+0xb70>
ffffffffc02018bc:	00005617          	auipc	a2,0x5
ffffffffc02018c0:	85460613          	addi	a2,a2,-1964 # ffffffffc0206110 <commands+0x818>
ffffffffc02018c4:	09000593          	li	a1,144
ffffffffc02018c8:	00005517          	auipc	a0,0x5
ffffffffc02018cc:	86050513          	addi	a0,a0,-1952 # ffffffffc0206128 <commands+0x830>
ffffffffc02018d0:	bbffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02018d4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018d4:	c941                	beqz	a0,ffffffffc0201964 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02018d6:	000a5597          	auipc	a1,0xa5
ffffffffc02018da:	de258593          	addi	a1,a1,-542 # ffffffffc02a66b8 <free_area>
ffffffffc02018de:	0105a803          	lw	a6,16(a1)
ffffffffc02018e2:	872a                	mv	a4,a0
ffffffffc02018e4:	02081793          	slli	a5,a6,0x20
ffffffffc02018e8:	9381                	srli	a5,a5,0x20
ffffffffc02018ea:	00a7ee63          	bltu	a5,a0,ffffffffc0201906 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02018ee:	87ae                	mv	a5,a1
ffffffffc02018f0:	a801                	j	ffffffffc0201900 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc02018f2:	ff87a683          	lw	a3,-8(a5)
ffffffffc02018f6:	02069613          	slli	a2,a3,0x20
ffffffffc02018fa:	9201                	srli	a2,a2,0x20
ffffffffc02018fc:	00e67763          	bgeu	a2,a4,ffffffffc020190a <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201900:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201902:	feb798e3          	bne	a5,a1,ffffffffc02018f2 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201906:	4501                	li	a0,0
}
ffffffffc0201908:	8082                	ret
    return listelm->prev;
ffffffffc020190a:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020190e:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201912:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201916:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020191a:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020191e:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201922:	02c77863          	bgeu	a4,a2,ffffffffc0201952 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201926:	071a                	slli	a4,a4,0x6
ffffffffc0201928:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020192a:	41c686bb          	subw	a3,a3,t3
ffffffffc020192e:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201930:	00870613          	addi	a2,a4,8
ffffffffc0201934:	4689                	li	a3,2
ffffffffc0201936:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020193a:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020193e:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201942:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201946:	e290                	sd	a2,0(a3)
ffffffffc0201948:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc020194c:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020194e:	01173c23          	sd	a7,24(a4)
ffffffffc0201952:	41c8083b          	subw	a6,a6,t3
ffffffffc0201956:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020195a:	5775                	li	a4,-3
ffffffffc020195c:	17c1                	addi	a5,a5,-16
ffffffffc020195e:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201962:	8082                	ret
{
ffffffffc0201964:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201966:	00005697          	auipc	a3,0x5
ffffffffc020196a:	b0268693          	addi	a3,a3,-1278 # ffffffffc0206468 <commands+0xb70>
ffffffffc020196e:	00004617          	auipc	a2,0x4
ffffffffc0201972:	7a260613          	addi	a2,a2,1954 # ffffffffc0206110 <commands+0x818>
ffffffffc0201976:	06c00593          	li	a1,108
ffffffffc020197a:	00004517          	auipc	a0,0x4
ffffffffc020197e:	7ae50513          	addi	a0,a0,1966 # ffffffffc0206128 <commands+0x830>
{
ffffffffc0201982:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201984:	b0bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201988 <default_init_memmap>:
{
ffffffffc0201988:	1141                	addi	sp,sp,-16
ffffffffc020198a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020198c:	c5f1                	beqz	a1,ffffffffc0201a58 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc020198e:	00659693          	slli	a3,a1,0x6
ffffffffc0201992:	96aa                	add	a3,a3,a0
ffffffffc0201994:	87aa                	mv	a5,a0
ffffffffc0201996:	00d50f63          	beq	a0,a3,ffffffffc02019b4 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020199a:	6798                	ld	a4,8(a5)
ffffffffc020199c:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc020199e:	cf49                	beqz	a4,ffffffffc0201a38 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02019a0:	0007a823          	sw	zero,16(a5)
ffffffffc02019a4:	0007b423          	sd	zero,8(a5)
ffffffffc02019a8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02019ac:	04078793          	addi	a5,a5,64
ffffffffc02019b0:	fed795e3          	bne	a5,a3,ffffffffc020199a <default_init_memmap+0x12>
    base->property = n;
ffffffffc02019b4:	2581                	sext.w	a1,a1
ffffffffc02019b6:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019b8:	4789                	li	a5,2
ffffffffc02019ba:	00850713          	addi	a4,a0,8
ffffffffc02019be:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02019c2:	000a5697          	auipc	a3,0xa5
ffffffffc02019c6:	cf668693          	addi	a3,a3,-778 # ffffffffc02a66b8 <free_area>
ffffffffc02019ca:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02019cc:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02019ce:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02019d2:	9db9                	addw	a1,a1,a4
ffffffffc02019d4:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02019d6:	04d78a63          	beq	a5,a3,ffffffffc0201a2a <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02019da:	fe878713          	addi	a4,a5,-24
ffffffffc02019de:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02019e2:	4581                	li	a1,0
            if (base < page)
ffffffffc02019e4:	00e56a63          	bltu	a0,a4,ffffffffc02019f8 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02019e8:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02019ea:	02d70263          	beq	a4,a3,ffffffffc0201a0e <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc02019ee:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02019f0:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02019f4:	fee57ae3          	bgeu	a0,a4,ffffffffc02019e8 <default_init_memmap+0x60>
ffffffffc02019f8:	c199                	beqz	a1,ffffffffc02019fe <default_init_memmap+0x76>
ffffffffc02019fa:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02019fe:	6398                	ld	a4,0(a5)
}
ffffffffc0201a00:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a02:	e390                	sd	a2,0(a5)
ffffffffc0201a04:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201a06:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a08:	ed18                	sd	a4,24(a0)
ffffffffc0201a0a:	0141                	addi	sp,sp,16
ffffffffc0201a0c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a0e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a10:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a12:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a14:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a16:	00d70663          	beq	a4,a3,ffffffffc0201a22 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201a1a:	8832                	mv	a6,a2
ffffffffc0201a1c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a1e:	87ba                	mv	a5,a4
ffffffffc0201a20:	bfc1                	j	ffffffffc02019f0 <default_init_memmap+0x68>
}
ffffffffc0201a22:	60a2                	ld	ra,8(sp)
ffffffffc0201a24:	e290                	sd	a2,0(a3)
ffffffffc0201a26:	0141                	addi	sp,sp,16
ffffffffc0201a28:	8082                	ret
ffffffffc0201a2a:	60a2                	ld	ra,8(sp)
ffffffffc0201a2c:	e390                	sd	a2,0(a5)
ffffffffc0201a2e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a30:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a32:	ed1c                	sd	a5,24(a0)
ffffffffc0201a34:	0141                	addi	sp,sp,16
ffffffffc0201a36:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a38:	00005697          	auipc	a3,0x5
ffffffffc0201a3c:	a6068693          	addi	a3,a3,-1440 # ffffffffc0206498 <commands+0xba0>
ffffffffc0201a40:	00004617          	auipc	a2,0x4
ffffffffc0201a44:	6d060613          	addi	a2,a2,1744 # ffffffffc0206110 <commands+0x818>
ffffffffc0201a48:	04b00593          	li	a1,75
ffffffffc0201a4c:	00004517          	auipc	a0,0x4
ffffffffc0201a50:	6dc50513          	addi	a0,a0,1756 # ffffffffc0206128 <commands+0x830>
ffffffffc0201a54:	a3bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201a58:	00005697          	auipc	a3,0x5
ffffffffc0201a5c:	a1068693          	addi	a3,a3,-1520 # ffffffffc0206468 <commands+0xb70>
ffffffffc0201a60:	00004617          	auipc	a2,0x4
ffffffffc0201a64:	6b060613          	addi	a2,a2,1712 # ffffffffc0206110 <commands+0x818>
ffffffffc0201a68:	04700593          	li	a1,71
ffffffffc0201a6c:	00004517          	auipc	a0,0x4
ffffffffc0201a70:	6bc50513          	addi	a0,a0,1724 # ffffffffc0206128 <commands+0x830>
ffffffffc0201a74:	a1bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201a78 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a78:	c94d                	beqz	a0,ffffffffc0201b2a <slob_free+0xb2>
{
ffffffffc0201a7a:	1141                	addi	sp,sp,-16
ffffffffc0201a7c:	e022                	sd	s0,0(sp)
ffffffffc0201a7e:	e406                	sd	ra,8(sp)
ffffffffc0201a80:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201a82:	e9c1                	bnez	a1,ffffffffc0201b12 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a84:	100027f3          	csrr	a5,sstatus
ffffffffc0201a88:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a8a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a8c:	ebd9                	bnez	a5,ffffffffc0201b22 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a8e:	000a5617          	auipc	a2,0xa5
ffffffffc0201a92:	81a60613          	addi	a2,a2,-2022 # ffffffffc02a62a8 <slobfree>
ffffffffc0201a96:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a98:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a9a:	679c                	ld	a5,8(a5)
ffffffffc0201a9c:	02877a63          	bgeu	a4,s0,ffffffffc0201ad0 <slob_free+0x58>
ffffffffc0201aa0:	00f46463          	bltu	s0,a5,ffffffffc0201aa8 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201aa4:	fef76ae3          	bltu	a4,a5,ffffffffc0201a98 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201aa8:	400c                	lw	a1,0(s0)
ffffffffc0201aaa:	00459693          	slli	a3,a1,0x4
ffffffffc0201aae:	96a2                	add	a3,a3,s0
ffffffffc0201ab0:	02d78a63          	beq	a5,a3,ffffffffc0201ae4 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201ab4:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201ab6:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201ab8:	00469793          	slli	a5,a3,0x4
ffffffffc0201abc:	97ba                	add	a5,a5,a4
ffffffffc0201abe:	02f40e63          	beq	s0,a5,ffffffffc0201afa <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201ac2:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201ac4:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201ac6:	e129                	bnez	a0,ffffffffc0201b08 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201ac8:	60a2                	ld	ra,8(sp)
ffffffffc0201aca:	6402                	ld	s0,0(sp)
ffffffffc0201acc:	0141                	addi	sp,sp,16
ffffffffc0201ace:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ad0:	fcf764e3          	bltu	a4,a5,ffffffffc0201a98 <slob_free+0x20>
ffffffffc0201ad4:	fcf472e3          	bgeu	s0,a5,ffffffffc0201a98 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201ad8:	400c                	lw	a1,0(s0)
ffffffffc0201ada:	00459693          	slli	a3,a1,0x4
ffffffffc0201ade:	96a2                	add	a3,a3,s0
ffffffffc0201ae0:	fcd79ae3          	bne	a5,a3,ffffffffc0201ab4 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201ae4:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201ae6:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201ae8:	9db5                	addw	a1,a1,a3
ffffffffc0201aea:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201aec:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201aee:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201af0:	00469793          	slli	a5,a3,0x4
ffffffffc0201af4:	97ba                	add	a5,a5,a4
ffffffffc0201af6:	fcf416e3          	bne	s0,a5,ffffffffc0201ac2 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201afa:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201afc:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201afe:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201b00:	9ebd                	addw	a3,a3,a5
ffffffffc0201b02:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201b04:	e70c                	sd	a1,8(a4)
ffffffffc0201b06:	d169                	beqz	a0,ffffffffc0201ac8 <slob_free+0x50>
}
ffffffffc0201b08:	6402                	ld	s0,0(sp)
ffffffffc0201b0a:	60a2                	ld	ra,8(sp)
ffffffffc0201b0c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201b0e:	ea1fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201b12:	25bd                	addiw	a1,a1,15
ffffffffc0201b14:	8191                	srli	a1,a1,0x4
ffffffffc0201b16:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b18:	100027f3          	csrr	a5,sstatus
ffffffffc0201b1c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b1e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b20:	d7bd                	beqz	a5,ffffffffc0201a8e <slob_free+0x16>
        intr_disable();
ffffffffc0201b22:	e93fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201b26:	4505                	li	a0,1
ffffffffc0201b28:	b79d                	j	ffffffffc0201a8e <slob_free+0x16>
ffffffffc0201b2a:	8082                	ret

ffffffffc0201b2c <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b2c:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b2e:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b30:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b34:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b36:	352000ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
	if (!page)
ffffffffc0201b3a:	c91d                	beqz	a0,ffffffffc0201b70 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201b3c:	000a9697          	auipc	a3,0xa9
ffffffffc0201b40:	bec6b683          	ld	a3,-1044(a3) # ffffffffc02aa728 <pages>
ffffffffc0201b44:	8d15                	sub	a0,a0,a3
ffffffffc0201b46:	8519                	srai	a0,a0,0x6
ffffffffc0201b48:	00006697          	auipc	a3,0x6
ffffffffc0201b4c:	c806b683          	ld	a3,-896(a3) # ffffffffc02077c8 <nbase>
ffffffffc0201b50:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201b52:	00c51793          	slli	a5,a0,0xc
ffffffffc0201b56:	83b1                	srli	a5,a5,0xc
ffffffffc0201b58:	000a9717          	auipc	a4,0xa9
ffffffffc0201b5c:	bc873703          	ld	a4,-1080(a4) # ffffffffc02aa720 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b60:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201b62:	00e7fa63          	bgeu	a5,a4,ffffffffc0201b76 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201b66:	000a9697          	auipc	a3,0xa9
ffffffffc0201b6a:	bd26b683          	ld	a3,-1070(a3) # ffffffffc02aa738 <va_pa_offset>
ffffffffc0201b6e:	9536                	add	a0,a0,a3
}
ffffffffc0201b70:	60a2                	ld	ra,8(sp)
ffffffffc0201b72:	0141                	addi	sp,sp,16
ffffffffc0201b74:	8082                	ret
ffffffffc0201b76:	86aa                	mv	a3,a0
ffffffffc0201b78:	00005617          	auipc	a2,0x5
ffffffffc0201b7c:	98060613          	addi	a2,a2,-1664 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0201b80:	07100593          	li	a1,113
ffffffffc0201b84:	00005517          	auipc	a0,0x5
ffffffffc0201b88:	99c50513          	addi	a0,a0,-1636 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0201b8c:	903fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201b90 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201b90:	1101                	addi	sp,sp,-32
ffffffffc0201b92:	ec06                	sd	ra,24(sp)
ffffffffc0201b94:	e822                	sd	s0,16(sp)
ffffffffc0201b96:	e426                	sd	s1,8(sp)
ffffffffc0201b98:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201b9a:	01050713          	addi	a4,a0,16
ffffffffc0201b9e:	6785                	lui	a5,0x1
ffffffffc0201ba0:	0cf77363          	bgeu	a4,a5,ffffffffc0201c66 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201ba4:	00f50493          	addi	s1,a0,15
ffffffffc0201ba8:	8091                	srli	s1,s1,0x4
ffffffffc0201baa:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bac:	10002673          	csrr	a2,sstatus
ffffffffc0201bb0:	8a09                	andi	a2,a2,2
ffffffffc0201bb2:	e25d                	bnez	a2,ffffffffc0201c58 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201bb4:	000a4917          	auipc	s2,0xa4
ffffffffc0201bb8:	6f490913          	addi	s2,s2,1780 # ffffffffc02a62a8 <slobfree>
ffffffffc0201bbc:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bc0:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201bc2:	4398                	lw	a4,0(a5)
ffffffffc0201bc4:	08975e63          	bge	a4,s1,ffffffffc0201c60 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201bc8:	00f68b63          	beq	a3,a5,ffffffffc0201bde <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bcc:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201bce:	4018                	lw	a4,0(s0)
ffffffffc0201bd0:	02975a63          	bge	a4,s1,ffffffffc0201c04 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201bd4:	00093683          	ld	a3,0(s2)
ffffffffc0201bd8:	87a2                	mv	a5,s0
ffffffffc0201bda:	fef699e3          	bne	a3,a5,ffffffffc0201bcc <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201bde:	ee31                	bnez	a2,ffffffffc0201c3a <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201be0:	4501                	li	a0,0
ffffffffc0201be2:	f4bff0ef          	jal	ra,ffffffffc0201b2c <__slob_get_free_pages.constprop.0>
ffffffffc0201be6:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201be8:	cd05                	beqz	a0,ffffffffc0201c20 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201bea:	6585                	lui	a1,0x1
ffffffffc0201bec:	e8dff0ef          	jal	ra,ffffffffc0201a78 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bf0:	10002673          	csrr	a2,sstatus
ffffffffc0201bf4:	8a09                	andi	a2,a2,2
ffffffffc0201bf6:	ee05                	bnez	a2,ffffffffc0201c2e <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201bf8:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bfc:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201bfe:	4018                	lw	a4,0(s0)
ffffffffc0201c00:	fc974ae3          	blt	a4,s1,ffffffffc0201bd4 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c04:	04e48763          	beq	s1,a4,ffffffffc0201c52 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201c08:	00449693          	slli	a3,s1,0x4
ffffffffc0201c0c:	96a2                	add	a3,a3,s0
ffffffffc0201c0e:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201c10:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201c12:	9f05                	subw	a4,a4,s1
ffffffffc0201c14:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201c16:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201c18:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201c1a:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201c1e:	e20d                	bnez	a2,ffffffffc0201c40 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201c20:	60e2                	ld	ra,24(sp)
ffffffffc0201c22:	8522                	mv	a0,s0
ffffffffc0201c24:	6442                	ld	s0,16(sp)
ffffffffc0201c26:	64a2                	ld	s1,8(sp)
ffffffffc0201c28:	6902                	ld	s2,0(sp)
ffffffffc0201c2a:	6105                	addi	sp,sp,32
ffffffffc0201c2c:	8082                	ret
        intr_disable();
ffffffffc0201c2e:	d87fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201c32:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201c36:	4605                	li	a2,1
ffffffffc0201c38:	b7d1                	j	ffffffffc0201bfc <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201c3a:	d75fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201c3e:	b74d                	j	ffffffffc0201be0 <slob_alloc.constprop.0+0x50>
ffffffffc0201c40:	d6ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201c44:	60e2                	ld	ra,24(sp)
ffffffffc0201c46:	8522                	mv	a0,s0
ffffffffc0201c48:	6442                	ld	s0,16(sp)
ffffffffc0201c4a:	64a2                	ld	s1,8(sp)
ffffffffc0201c4c:	6902                	ld	s2,0(sp)
ffffffffc0201c4e:	6105                	addi	sp,sp,32
ffffffffc0201c50:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201c52:	6418                	ld	a4,8(s0)
ffffffffc0201c54:	e798                	sd	a4,8(a5)
ffffffffc0201c56:	b7d1                	j	ffffffffc0201c1a <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201c58:	d5dfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201c5c:	4605                	li	a2,1
ffffffffc0201c5e:	bf99                	j	ffffffffc0201bb4 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201c60:	843e                	mv	s0,a5
ffffffffc0201c62:	87b6                	mv	a5,a3
ffffffffc0201c64:	b745                	j	ffffffffc0201c04 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c66:	00005697          	auipc	a3,0x5
ffffffffc0201c6a:	8ca68693          	addi	a3,a3,-1846 # ffffffffc0206530 <default_pmm_manager+0x70>
ffffffffc0201c6e:	00004617          	auipc	a2,0x4
ffffffffc0201c72:	4a260613          	addi	a2,a2,1186 # ffffffffc0206110 <commands+0x818>
ffffffffc0201c76:	06300593          	li	a1,99
ffffffffc0201c7a:	00005517          	auipc	a0,0x5
ffffffffc0201c7e:	8d650513          	addi	a0,a0,-1834 # ffffffffc0206550 <default_pmm_manager+0x90>
ffffffffc0201c82:	80dfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201c86 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201c86:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201c88:	00005517          	auipc	a0,0x5
ffffffffc0201c8c:	8e050513          	addi	a0,a0,-1824 # ffffffffc0206568 <default_pmm_manager+0xa8>
{
ffffffffc0201c90:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201c92:	d02fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201c96:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201c98:	00005517          	auipc	a0,0x5
ffffffffc0201c9c:	8e850513          	addi	a0,a0,-1816 # ffffffffc0206580 <default_pmm_manager+0xc0>
}
ffffffffc0201ca0:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201ca2:	cf2fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201ca6 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201ca6:	4501                	li	a0,0
ffffffffc0201ca8:	8082                	ret

ffffffffc0201caa <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201caa:	1101                	addi	sp,sp,-32
ffffffffc0201cac:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cae:	6905                	lui	s2,0x1
{
ffffffffc0201cb0:	e822                	sd	s0,16(sp)
ffffffffc0201cb2:	ec06                	sd	ra,24(sp)
ffffffffc0201cb4:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cb6:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bb9>
{
ffffffffc0201cba:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cbc:	04a7f963          	bgeu	a5,a0,ffffffffc0201d0e <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201cc0:	4561                	li	a0,24
ffffffffc0201cc2:	ecfff0ef          	jal	ra,ffffffffc0201b90 <slob_alloc.constprop.0>
ffffffffc0201cc6:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201cc8:	c929                	beqz	a0,ffffffffc0201d1a <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201cca:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201cce:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201cd0:	00f95763          	bge	s2,a5,ffffffffc0201cde <kmalloc+0x34>
ffffffffc0201cd4:	6705                	lui	a4,0x1
ffffffffc0201cd6:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201cd8:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201cda:	fef74ee3          	blt	a4,a5,ffffffffc0201cd6 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201cde:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201ce0:	e4dff0ef          	jal	ra,ffffffffc0201b2c <__slob_get_free_pages.constprop.0>
ffffffffc0201ce4:	e488                	sd	a0,8(s1)
ffffffffc0201ce6:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201ce8:	c525                	beqz	a0,ffffffffc0201d50 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201cea:	100027f3          	csrr	a5,sstatus
ffffffffc0201cee:	8b89                	andi	a5,a5,2
ffffffffc0201cf0:	ef8d                	bnez	a5,ffffffffc0201d2a <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201cf2:	000a9797          	auipc	a5,0xa9
ffffffffc0201cf6:	a1678793          	addi	a5,a5,-1514 # ffffffffc02aa708 <bigblocks>
ffffffffc0201cfa:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201cfc:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201cfe:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201d00:	60e2                	ld	ra,24(sp)
ffffffffc0201d02:	8522                	mv	a0,s0
ffffffffc0201d04:	6442                	ld	s0,16(sp)
ffffffffc0201d06:	64a2                	ld	s1,8(sp)
ffffffffc0201d08:	6902                	ld	s2,0(sp)
ffffffffc0201d0a:	6105                	addi	sp,sp,32
ffffffffc0201d0c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d0e:	0541                	addi	a0,a0,16
ffffffffc0201d10:	e81ff0ef          	jal	ra,ffffffffc0201b90 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d14:	01050413          	addi	s0,a0,16
ffffffffc0201d18:	f565                	bnez	a0,ffffffffc0201d00 <kmalloc+0x56>
ffffffffc0201d1a:	4401                	li	s0,0
}
ffffffffc0201d1c:	60e2                	ld	ra,24(sp)
ffffffffc0201d1e:	8522                	mv	a0,s0
ffffffffc0201d20:	6442                	ld	s0,16(sp)
ffffffffc0201d22:	64a2                	ld	s1,8(sp)
ffffffffc0201d24:	6902                	ld	s2,0(sp)
ffffffffc0201d26:	6105                	addi	sp,sp,32
ffffffffc0201d28:	8082                	ret
        intr_disable();
ffffffffc0201d2a:	c8bfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d2e:	000a9797          	auipc	a5,0xa9
ffffffffc0201d32:	9da78793          	addi	a5,a5,-1574 # ffffffffc02aa708 <bigblocks>
ffffffffc0201d36:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d38:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d3a:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201d3c:	c73fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201d40:	6480                	ld	s0,8(s1)
}
ffffffffc0201d42:	60e2                	ld	ra,24(sp)
ffffffffc0201d44:	64a2                	ld	s1,8(sp)
ffffffffc0201d46:	8522                	mv	a0,s0
ffffffffc0201d48:	6442                	ld	s0,16(sp)
ffffffffc0201d4a:	6902                	ld	s2,0(sp)
ffffffffc0201d4c:	6105                	addi	sp,sp,32
ffffffffc0201d4e:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d50:	45e1                	li	a1,24
ffffffffc0201d52:	8526                	mv	a0,s1
ffffffffc0201d54:	d25ff0ef          	jal	ra,ffffffffc0201a78 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201d58:	b765                	j	ffffffffc0201d00 <kmalloc+0x56>

ffffffffc0201d5a <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201d5a:	c169                	beqz	a0,ffffffffc0201e1c <kfree+0xc2>
{
ffffffffc0201d5c:	1101                	addi	sp,sp,-32
ffffffffc0201d5e:	e822                	sd	s0,16(sp)
ffffffffc0201d60:	ec06                	sd	ra,24(sp)
ffffffffc0201d62:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201d64:	03451793          	slli	a5,a0,0x34
ffffffffc0201d68:	842a                	mv	s0,a0
ffffffffc0201d6a:	e3d9                	bnez	a5,ffffffffc0201df0 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d6c:	100027f3          	csrr	a5,sstatus
ffffffffc0201d70:	8b89                	andi	a5,a5,2
ffffffffc0201d72:	e7d9                	bnez	a5,ffffffffc0201e00 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d74:	000a9797          	auipc	a5,0xa9
ffffffffc0201d78:	9947b783          	ld	a5,-1644(a5) # ffffffffc02aa708 <bigblocks>
    return 0;
ffffffffc0201d7c:	4601                	li	a2,0
ffffffffc0201d7e:	cbad                	beqz	a5,ffffffffc0201df0 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201d80:	000a9697          	auipc	a3,0xa9
ffffffffc0201d84:	98868693          	addi	a3,a3,-1656 # ffffffffc02aa708 <bigblocks>
ffffffffc0201d88:	a021                	j	ffffffffc0201d90 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d8a:	01048693          	addi	a3,s1,16
ffffffffc0201d8e:	c3a5                	beqz	a5,ffffffffc0201dee <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201d90:	6798                	ld	a4,8(a5)
ffffffffc0201d92:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201d94:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201d96:	fe871ae3          	bne	a4,s0,ffffffffc0201d8a <kfree+0x30>
				*last = bb->next;
ffffffffc0201d9a:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201d9c:	ee2d                	bnez	a2,ffffffffc0201e16 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201d9e:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201da2:	4098                	lw	a4,0(s1)
ffffffffc0201da4:	08f46963          	bltu	s0,a5,ffffffffc0201e36 <kfree+0xdc>
ffffffffc0201da8:	000a9697          	auipc	a3,0xa9
ffffffffc0201dac:	9906b683          	ld	a3,-1648(a3) # ffffffffc02aa738 <va_pa_offset>
ffffffffc0201db0:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201db2:	8031                	srli	s0,s0,0xc
ffffffffc0201db4:	000a9797          	auipc	a5,0xa9
ffffffffc0201db8:	96c7b783          	ld	a5,-1684(a5) # ffffffffc02aa720 <npage>
ffffffffc0201dbc:	06f47163          	bgeu	s0,a5,ffffffffc0201e1e <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201dc0:	00006517          	auipc	a0,0x6
ffffffffc0201dc4:	a0853503          	ld	a0,-1528(a0) # ffffffffc02077c8 <nbase>
ffffffffc0201dc8:	8c09                	sub	s0,s0,a0
ffffffffc0201dca:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201dcc:	000a9517          	auipc	a0,0xa9
ffffffffc0201dd0:	95c53503          	ld	a0,-1700(a0) # ffffffffc02aa728 <pages>
ffffffffc0201dd4:	4585                	li	a1,1
ffffffffc0201dd6:	9522                	add	a0,a0,s0
ffffffffc0201dd8:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201ddc:	0ea000ef          	jal	ra,ffffffffc0201ec6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201de0:	6442                	ld	s0,16(sp)
ffffffffc0201de2:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201de4:	8526                	mv	a0,s1
}
ffffffffc0201de6:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201de8:	45e1                	li	a1,24
}
ffffffffc0201dea:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201dec:	b171                	j	ffffffffc0201a78 <slob_free>
ffffffffc0201dee:	e20d                	bnez	a2,ffffffffc0201e10 <kfree+0xb6>
ffffffffc0201df0:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201df4:	6442                	ld	s0,16(sp)
ffffffffc0201df6:	60e2                	ld	ra,24(sp)
ffffffffc0201df8:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201dfa:	4581                	li	a1,0
}
ffffffffc0201dfc:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201dfe:	b9ad                	j	ffffffffc0201a78 <slob_free>
        intr_disable();
ffffffffc0201e00:	bb5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e04:	000a9797          	auipc	a5,0xa9
ffffffffc0201e08:	9047b783          	ld	a5,-1788(a5) # ffffffffc02aa708 <bigblocks>
        return 1;
ffffffffc0201e0c:	4605                	li	a2,1
ffffffffc0201e0e:	fbad                	bnez	a5,ffffffffc0201d80 <kfree+0x26>
        intr_enable();
ffffffffc0201e10:	b9ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e14:	bff1                	j	ffffffffc0201df0 <kfree+0x96>
ffffffffc0201e16:	b99fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e1a:	b751                	j	ffffffffc0201d9e <kfree+0x44>
ffffffffc0201e1c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e1e:	00004617          	auipc	a2,0x4
ffffffffc0201e22:	7aa60613          	addi	a2,a2,1962 # ffffffffc02065c8 <default_pmm_manager+0x108>
ffffffffc0201e26:	06900593          	li	a1,105
ffffffffc0201e2a:	00004517          	auipc	a0,0x4
ffffffffc0201e2e:	6f650513          	addi	a0,a0,1782 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0201e32:	e5cfe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e36:	86a2                	mv	a3,s0
ffffffffc0201e38:	00004617          	auipc	a2,0x4
ffffffffc0201e3c:	76860613          	addi	a2,a2,1896 # ffffffffc02065a0 <default_pmm_manager+0xe0>
ffffffffc0201e40:	07700593          	li	a1,119
ffffffffc0201e44:	00004517          	auipc	a0,0x4
ffffffffc0201e48:	6dc50513          	addi	a0,a0,1756 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0201e4c:	e42fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e50 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201e50:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201e52:	00004617          	auipc	a2,0x4
ffffffffc0201e56:	77660613          	addi	a2,a2,1910 # ffffffffc02065c8 <default_pmm_manager+0x108>
ffffffffc0201e5a:	06900593          	li	a1,105
ffffffffc0201e5e:	00004517          	auipc	a0,0x4
ffffffffc0201e62:	6c250513          	addi	a0,a0,1730 # ffffffffc0206520 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201e66:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201e68:	e26fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e6c <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201e6c:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201e6e:	00004617          	auipc	a2,0x4
ffffffffc0201e72:	77a60613          	addi	a2,a2,1914 # ffffffffc02065e8 <default_pmm_manager+0x128>
ffffffffc0201e76:	07f00593          	li	a1,127
ffffffffc0201e7a:	00004517          	auipc	a0,0x4
ffffffffc0201e7e:	6a650513          	addi	a0,a0,1702 # ffffffffc0206520 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201e82:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201e84:	e0afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e88 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e88:	100027f3          	csrr	a5,sstatus
ffffffffc0201e8c:	8b89                	andi	a5,a5,2
ffffffffc0201e8e:	e799                	bnez	a5,ffffffffc0201e9c <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e90:	000a9797          	auipc	a5,0xa9
ffffffffc0201e94:	8a07b783          	ld	a5,-1888(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0201e98:	6f9c                	ld	a5,24(a5)
ffffffffc0201e9a:	8782                	jr	a5
{
ffffffffc0201e9c:	1141                	addi	sp,sp,-16
ffffffffc0201e9e:	e406                	sd	ra,8(sp)
ffffffffc0201ea0:	e022                	sd	s0,0(sp)
ffffffffc0201ea2:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201ea4:	b11fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ea8:	000a9797          	auipc	a5,0xa9
ffffffffc0201eac:	8887b783          	ld	a5,-1912(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0201eb0:	6f9c                	ld	a5,24(a5)
ffffffffc0201eb2:	8522                	mv	a0,s0
ffffffffc0201eb4:	9782                	jalr	a5
ffffffffc0201eb6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201eb8:	af7fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201ebc:	60a2                	ld	ra,8(sp)
ffffffffc0201ebe:	8522                	mv	a0,s0
ffffffffc0201ec0:	6402                	ld	s0,0(sp)
ffffffffc0201ec2:	0141                	addi	sp,sp,16
ffffffffc0201ec4:	8082                	ret

ffffffffc0201ec6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ec6:	100027f3          	csrr	a5,sstatus
ffffffffc0201eca:	8b89                	andi	a5,a5,2
ffffffffc0201ecc:	e799                	bnez	a5,ffffffffc0201eda <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201ece:	000a9797          	auipc	a5,0xa9
ffffffffc0201ed2:	8627b783          	ld	a5,-1950(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0201ed6:	739c                	ld	a5,32(a5)
ffffffffc0201ed8:	8782                	jr	a5
{
ffffffffc0201eda:	1101                	addi	sp,sp,-32
ffffffffc0201edc:	ec06                	sd	ra,24(sp)
ffffffffc0201ede:	e822                	sd	s0,16(sp)
ffffffffc0201ee0:	e426                	sd	s1,8(sp)
ffffffffc0201ee2:	842a                	mv	s0,a0
ffffffffc0201ee4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201ee6:	acffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201eea:	000a9797          	auipc	a5,0xa9
ffffffffc0201eee:	8467b783          	ld	a5,-1978(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0201ef2:	739c                	ld	a5,32(a5)
ffffffffc0201ef4:	85a6                	mv	a1,s1
ffffffffc0201ef6:	8522                	mv	a0,s0
ffffffffc0201ef8:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201efa:	6442                	ld	s0,16(sp)
ffffffffc0201efc:	60e2                	ld	ra,24(sp)
ffffffffc0201efe:	64a2                	ld	s1,8(sp)
ffffffffc0201f00:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f02:	aadfe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0201f06 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f06:	100027f3          	csrr	a5,sstatus
ffffffffc0201f0a:	8b89                	andi	a5,a5,2
ffffffffc0201f0c:	e799                	bnez	a5,ffffffffc0201f1a <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f0e:	000a9797          	auipc	a5,0xa9
ffffffffc0201f12:	8227b783          	ld	a5,-2014(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0201f16:	779c                	ld	a5,40(a5)
ffffffffc0201f18:	8782                	jr	a5
{
ffffffffc0201f1a:	1141                	addi	sp,sp,-16
ffffffffc0201f1c:	e406                	sd	ra,8(sp)
ffffffffc0201f1e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201f20:	a95fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f24:	000a9797          	auipc	a5,0xa9
ffffffffc0201f28:	80c7b783          	ld	a5,-2036(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0201f2c:	779c                	ld	a5,40(a5)
ffffffffc0201f2e:	9782                	jalr	a5
ffffffffc0201f30:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f32:	a7dfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201f36:	60a2                	ld	ra,8(sp)
ffffffffc0201f38:	8522                	mv	a0,s0
ffffffffc0201f3a:	6402                	ld	s0,0(sp)
ffffffffc0201f3c:	0141                	addi	sp,sp,16
ffffffffc0201f3e:	8082                	ret

ffffffffc0201f40 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f40:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201f44:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201f48:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f4a:	078e                	slli	a5,a5,0x3
{
ffffffffc0201f4c:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f4e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201f52:	6094                	ld	a3,0(s1)
{
ffffffffc0201f54:	f04a                	sd	s2,32(sp)
ffffffffc0201f56:	ec4e                	sd	s3,24(sp)
ffffffffc0201f58:	e852                	sd	s4,16(sp)
ffffffffc0201f5a:	fc06                	sd	ra,56(sp)
ffffffffc0201f5c:	f822                	sd	s0,48(sp)
ffffffffc0201f5e:	e456                	sd	s5,8(sp)
ffffffffc0201f60:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201f62:	0016f793          	andi	a5,a3,1
{
ffffffffc0201f66:	892e                	mv	s2,a1
ffffffffc0201f68:	8a32                	mv	s4,a2
ffffffffc0201f6a:	000a8997          	auipc	s3,0xa8
ffffffffc0201f6e:	7b698993          	addi	s3,s3,1974 # ffffffffc02aa720 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201f72:	efbd                	bnez	a5,ffffffffc0201ff0 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f74:	14060c63          	beqz	a2,ffffffffc02020cc <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f78:	100027f3          	csrr	a5,sstatus
ffffffffc0201f7c:	8b89                	andi	a5,a5,2
ffffffffc0201f7e:	14079963          	bnez	a5,ffffffffc02020d0 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f82:	000a8797          	auipc	a5,0xa8
ffffffffc0201f86:	7ae7b783          	ld	a5,1966(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0201f8a:	6f9c                	ld	a5,24(a5)
ffffffffc0201f8c:	4505                	li	a0,1
ffffffffc0201f8e:	9782                	jalr	a5
ffffffffc0201f90:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f92:	12040d63          	beqz	s0,ffffffffc02020cc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201f96:	000a8b17          	auipc	s6,0xa8
ffffffffc0201f9a:	792b0b13          	addi	s6,s6,1938 # ffffffffc02aa728 <pages>
ffffffffc0201f9e:	000b3503          	ld	a0,0(s6)
ffffffffc0201fa2:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fa6:	000a8997          	auipc	s3,0xa8
ffffffffc0201faa:	77a98993          	addi	s3,s3,1914 # ffffffffc02aa720 <npage>
ffffffffc0201fae:	40a40533          	sub	a0,s0,a0
ffffffffc0201fb2:	8519                	srai	a0,a0,0x6
ffffffffc0201fb4:	9556                	add	a0,a0,s5
ffffffffc0201fb6:	0009b703          	ld	a4,0(s3)
ffffffffc0201fba:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201fbe:	4685                	li	a3,1
ffffffffc0201fc0:	c014                	sw	a3,0(s0)
ffffffffc0201fc2:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201fc4:	0532                	slli	a0,a0,0xc
ffffffffc0201fc6:	16e7f763          	bgeu	a5,a4,ffffffffc0202134 <get_pte+0x1f4>
ffffffffc0201fca:	000a8797          	auipc	a5,0xa8
ffffffffc0201fce:	76e7b783          	ld	a5,1902(a5) # ffffffffc02aa738 <va_pa_offset>
ffffffffc0201fd2:	6605                	lui	a2,0x1
ffffffffc0201fd4:	4581                	li	a1,0
ffffffffc0201fd6:	953e                	add	a0,a0,a5
ffffffffc0201fd8:	68a030ef          	jal	ra,ffffffffc0205662 <memset>
    return page - pages + nbase;
ffffffffc0201fdc:	000b3683          	ld	a3,0(s6)
ffffffffc0201fe0:	40d406b3          	sub	a3,s0,a3
ffffffffc0201fe4:	8699                	srai	a3,a3,0x6
ffffffffc0201fe6:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201fe8:	06aa                	slli	a3,a3,0xa
ffffffffc0201fea:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201fee:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201ff0:	77fd                	lui	a5,0xfffff
ffffffffc0201ff2:	068a                	slli	a3,a3,0x2
ffffffffc0201ff4:	0009b703          	ld	a4,0(s3)
ffffffffc0201ff8:	8efd                	and	a3,a3,a5
ffffffffc0201ffa:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ffe:	10e7ff63          	bgeu	a5,a4,ffffffffc020211c <get_pte+0x1dc>
ffffffffc0202002:	000a8a97          	auipc	s5,0xa8
ffffffffc0202006:	736a8a93          	addi	s5,s5,1846 # ffffffffc02aa738 <va_pa_offset>
ffffffffc020200a:	000ab403          	ld	s0,0(s5)
ffffffffc020200e:	01595793          	srli	a5,s2,0x15
ffffffffc0202012:	1ff7f793          	andi	a5,a5,511
ffffffffc0202016:	96a2                	add	a3,a3,s0
ffffffffc0202018:	00379413          	slli	s0,a5,0x3
ffffffffc020201c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc020201e:	6014                	ld	a3,0(s0)
ffffffffc0202020:	0016f793          	andi	a5,a3,1
ffffffffc0202024:	ebad                	bnez	a5,ffffffffc0202096 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202026:	0a0a0363          	beqz	s4,ffffffffc02020cc <get_pte+0x18c>
ffffffffc020202a:	100027f3          	csrr	a5,sstatus
ffffffffc020202e:	8b89                	andi	a5,a5,2
ffffffffc0202030:	efcd                	bnez	a5,ffffffffc02020ea <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202032:	000a8797          	auipc	a5,0xa8
ffffffffc0202036:	6fe7b783          	ld	a5,1790(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc020203a:	6f9c                	ld	a5,24(a5)
ffffffffc020203c:	4505                	li	a0,1
ffffffffc020203e:	9782                	jalr	a5
ffffffffc0202040:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202042:	c4c9                	beqz	s1,ffffffffc02020cc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202044:	000a8b17          	auipc	s6,0xa8
ffffffffc0202048:	6e4b0b13          	addi	s6,s6,1764 # ffffffffc02aa728 <pages>
ffffffffc020204c:	000b3503          	ld	a0,0(s6)
ffffffffc0202050:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202054:	0009b703          	ld	a4,0(s3)
ffffffffc0202058:	40a48533          	sub	a0,s1,a0
ffffffffc020205c:	8519                	srai	a0,a0,0x6
ffffffffc020205e:	9552                	add	a0,a0,s4
ffffffffc0202060:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202064:	4685                	li	a3,1
ffffffffc0202066:	c094                	sw	a3,0(s1)
ffffffffc0202068:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020206a:	0532                	slli	a0,a0,0xc
ffffffffc020206c:	0ee7f163          	bgeu	a5,a4,ffffffffc020214e <get_pte+0x20e>
ffffffffc0202070:	000ab783          	ld	a5,0(s5)
ffffffffc0202074:	6605                	lui	a2,0x1
ffffffffc0202076:	4581                	li	a1,0
ffffffffc0202078:	953e                	add	a0,a0,a5
ffffffffc020207a:	5e8030ef          	jal	ra,ffffffffc0205662 <memset>
    return page - pages + nbase;
ffffffffc020207e:	000b3683          	ld	a3,0(s6)
ffffffffc0202082:	40d486b3          	sub	a3,s1,a3
ffffffffc0202086:	8699                	srai	a3,a3,0x6
ffffffffc0202088:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020208a:	06aa                	slli	a3,a3,0xa
ffffffffc020208c:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202090:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202092:	0009b703          	ld	a4,0(s3)
ffffffffc0202096:	068a                	slli	a3,a3,0x2
ffffffffc0202098:	757d                	lui	a0,0xfffff
ffffffffc020209a:	8ee9                	and	a3,a3,a0
ffffffffc020209c:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020a0:	06e7f263          	bgeu	a5,a4,ffffffffc0202104 <get_pte+0x1c4>
ffffffffc02020a4:	000ab503          	ld	a0,0(s5)
ffffffffc02020a8:	00c95913          	srli	s2,s2,0xc
ffffffffc02020ac:	1ff97913          	andi	s2,s2,511
ffffffffc02020b0:	96aa                	add	a3,a3,a0
ffffffffc02020b2:	00391513          	slli	a0,s2,0x3
ffffffffc02020b6:	9536                	add	a0,a0,a3
}
ffffffffc02020b8:	70e2                	ld	ra,56(sp)
ffffffffc02020ba:	7442                	ld	s0,48(sp)
ffffffffc02020bc:	74a2                	ld	s1,40(sp)
ffffffffc02020be:	7902                	ld	s2,32(sp)
ffffffffc02020c0:	69e2                	ld	s3,24(sp)
ffffffffc02020c2:	6a42                	ld	s4,16(sp)
ffffffffc02020c4:	6aa2                	ld	s5,8(sp)
ffffffffc02020c6:	6b02                	ld	s6,0(sp)
ffffffffc02020c8:	6121                	addi	sp,sp,64
ffffffffc02020ca:	8082                	ret
            return NULL;
ffffffffc02020cc:	4501                	li	a0,0
ffffffffc02020ce:	b7ed                	j	ffffffffc02020b8 <get_pte+0x178>
        intr_disable();
ffffffffc02020d0:	8e5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020d4:	000a8797          	auipc	a5,0xa8
ffffffffc02020d8:	65c7b783          	ld	a5,1628(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc02020dc:	6f9c                	ld	a5,24(a5)
ffffffffc02020de:	4505                	li	a0,1
ffffffffc02020e0:	9782                	jalr	a5
ffffffffc02020e2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02020e4:	8cbfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02020e8:	b56d                	j	ffffffffc0201f92 <get_pte+0x52>
        intr_disable();
ffffffffc02020ea:	8cbfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02020ee:	000a8797          	auipc	a5,0xa8
ffffffffc02020f2:	6427b783          	ld	a5,1602(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc02020f6:	6f9c                	ld	a5,24(a5)
ffffffffc02020f8:	4505                	li	a0,1
ffffffffc02020fa:	9782                	jalr	a5
ffffffffc02020fc:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02020fe:	8b1fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202102:	b781                	j	ffffffffc0202042 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202104:	00004617          	auipc	a2,0x4
ffffffffc0202108:	3f460613          	addi	a2,a2,1012 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc020210c:	0fa00593          	li	a1,250
ffffffffc0202110:	00004517          	auipc	a0,0x4
ffffffffc0202114:	50050513          	addi	a0,a0,1280 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202118:	b76fe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020211c:	00004617          	auipc	a2,0x4
ffffffffc0202120:	3dc60613          	addi	a2,a2,988 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0202124:	0ed00593          	li	a1,237
ffffffffc0202128:	00004517          	auipc	a0,0x4
ffffffffc020212c:	4e850513          	addi	a0,a0,1256 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202130:	b5efe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202134:	86aa                	mv	a3,a0
ffffffffc0202136:	00004617          	auipc	a2,0x4
ffffffffc020213a:	3c260613          	addi	a2,a2,962 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc020213e:	0e900593          	li	a1,233
ffffffffc0202142:	00004517          	auipc	a0,0x4
ffffffffc0202146:	4ce50513          	addi	a0,a0,1230 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc020214a:	b44fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020214e:	86aa                	mv	a3,a0
ffffffffc0202150:	00004617          	auipc	a2,0x4
ffffffffc0202154:	3a860613          	addi	a2,a2,936 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0202158:	0f700593          	li	a1,247
ffffffffc020215c:	00004517          	auipc	a0,0x4
ffffffffc0202160:	4b450513          	addi	a0,a0,1204 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202164:	b2afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202168 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202168:	1141                	addi	sp,sp,-16
ffffffffc020216a:	e022                	sd	s0,0(sp)
ffffffffc020216c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020216e:	4601                	li	a2,0
{
ffffffffc0202170:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202172:	dcfff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
    if (ptep_store != NULL)
ffffffffc0202176:	c011                	beqz	s0,ffffffffc020217a <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202178:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020217a:	c511                	beqz	a0,ffffffffc0202186 <get_page+0x1e>
ffffffffc020217c:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020217e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202180:	0017f713          	andi	a4,a5,1
ffffffffc0202184:	e709                	bnez	a4,ffffffffc020218e <get_page+0x26>
}
ffffffffc0202186:	60a2                	ld	ra,8(sp)
ffffffffc0202188:	6402                	ld	s0,0(sp)
ffffffffc020218a:	0141                	addi	sp,sp,16
ffffffffc020218c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020218e:	078a                	slli	a5,a5,0x2
ffffffffc0202190:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202192:	000a8717          	auipc	a4,0xa8
ffffffffc0202196:	58e73703          	ld	a4,1422(a4) # ffffffffc02aa720 <npage>
ffffffffc020219a:	00e7ff63          	bgeu	a5,a4,ffffffffc02021b8 <get_page+0x50>
ffffffffc020219e:	60a2                	ld	ra,8(sp)
ffffffffc02021a0:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02021a2:	fff80537          	lui	a0,0xfff80
ffffffffc02021a6:	97aa                	add	a5,a5,a0
ffffffffc02021a8:	079a                	slli	a5,a5,0x6
ffffffffc02021aa:	000a8517          	auipc	a0,0xa8
ffffffffc02021ae:	57e53503          	ld	a0,1406(a0) # ffffffffc02aa728 <pages>
ffffffffc02021b2:	953e                	add	a0,a0,a5
ffffffffc02021b4:	0141                	addi	sp,sp,16
ffffffffc02021b6:	8082                	ret
ffffffffc02021b8:	c99ff0ef          	jal	ra,ffffffffc0201e50 <pa2page.part.0>

ffffffffc02021bc <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02021bc:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021be:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02021c2:	f486                	sd	ra,104(sp)
ffffffffc02021c4:	f0a2                	sd	s0,96(sp)
ffffffffc02021c6:	eca6                	sd	s1,88(sp)
ffffffffc02021c8:	e8ca                	sd	s2,80(sp)
ffffffffc02021ca:	e4ce                	sd	s3,72(sp)
ffffffffc02021cc:	e0d2                	sd	s4,64(sp)
ffffffffc02021ce:	fc56                	sd	s5,56(sp)
ffffffffc02021d0:	f85a                	sd	s6,48(sp)
ffffffffc02021d2:	f45e                	sd	s7,40(sp)
ffffffffc02021d4:	f062                	sd	s8,32(sp)
ffffffffc02021d6:	ec66                	sd	s9,24(sp)
ffffffffc02021d8:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021da:	17d2                	slli	a5,a5,0x34
ffffffffc02021dc:	e3ed                	bnez	a5,ffffffffc02022be <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02021de:	002007b7          	lui	a5,0x200
ffffffffc02021e2:	842e                	mv	s0,a1
ffffffffc02021e4:	0ef5ed63          	bltu	a1,a5,ffffffffc02022de <unmap_range+0x122>
ffffffffc02021e8:	8932                	mv	s2,a2
ffffffffc02021ea:	0ec5fa63          	bgeu	a1,a2,ffffffffc02022de <unmap_range+0x122>
ffffffffc02021ee:	4785                	li	a5,1
ffffffffc02021f0:	07fe                	slli	a5,a5,0x1f
ffffffffc02021f2:	0ec7e663          	bltu	a5,a2,ffffffffc02022de <unmap_range+0x122>
ffffffffc02021f6:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02021f8:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02021fa:	000a8c97          	auipc	s9,0xa8
ffffffffc02021fe:	526c8c93          	addi	s9,s9,1318 # ffffffffc02aa720 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202202:	000a8c17          	auipc	s8,0xa8
ffffffffc0202206:	526c0c13          	addi	s8,s8,1318 # ffffffffc02aa728 <pages>
ffffffffc020220a:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020220e:	000a8d17          	auipc	s10,0xa8
ffffffffc0202212:	522d0d13          	addi	s10,s10,1314 # ffffffffc02aa730 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202216:	00200b37          	lui	s6,0x200
ffffffffc020221a:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020221e:	4601                	li	a2,0
ffffffffc0202220:	85a2                	mv	a1,s0
ffffffffc0202222:	854e                	mv	a0,s3
ffffffffc0202224:	d1dff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
ffffffffc0202228:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020222a:	cd29                	beqz	a0,ffffffffc0202284 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc020222c:	611c                	ld	a5,0(a0)
ffffffffc020222e:	e395                	bnez	a5,ffffffffc0202252 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202230:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202232:	ff2466e3          	bltu	s0,s2,ffffffffc020221e <unmap_range+0x62>
}
ffffffffc0202236:	70a6                	ld	ra,104(sp)
ffffffffc0202238:	7406                	ld	s0,96(sp)
ffffffffc020223a:	64e6                	ld	s1,88(sp)
ffffffffc020223c:	6946                	ld	s2,80(sp)
ffffffffc020223e:	69a6                	ld	s3,72(sp)
ffffffffc0202240:	6a06                	ld	s4,64(sp)
ffffffffc0202242:	7ae2                	ld	s5,56(sp)
ffffffffc0202244:	7b42                	ld	s6,48(sp)
ffffffffc0202246:	7ba2                	ld	s7,40(sp)
ffffffffc0202248:	7c02                	ld	s8,32(sp)
ffffffffc020224a:	6ce2                	ld	s9,24(sp)
ffffffffc020224c:	6d42                	ld	s10,16(sp)
ffffffffc020224e:	6165                	addi	sp,sp,112
ffffffffc0202250:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202252:	0017f713          	andi	a4,a5,1
ffffffffc0202256:	df69                	beqz	a4,ffffffffc0202230 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202258:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc020225c:	078a                	slli	a5,a5,0x2
ffffffffc020225e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202260:	08e7ff63          	bgeu	a5,a4,ffffffffc02022fe <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202264:	000c3503          	ld	a0,0(s8)
ffffffffc0202268:	97de                	add	a5,a5,s7
ffffffffc020226a:	079a                	slli	a5,a5,0x6
ffffffffc020226c:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020226e:	411c                	lw	a5,0(a0)
ffffffffc0202270:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202274:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202276:	cf11                	beqz	a4,ffffffffc0202292 <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202278:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020227c:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202280:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202282:	bf45                	j	ffffffffc0202232 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202284:	945a                	add	s0,s0,s6
ffffffffc0202286:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020228a:	d455                	beqz	s0,ffffffffc0202236 <unmap_range+0x7a>
ffffffffc020228c:	f92469e3          	bltu	s0,s2,ffffffffc020221e <unmap_range+0x62>
ffffffffc0202290:	b75d                	j	ffffffffc0202236 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202292:	100027f3          	csrr	a5,sstatus
ffffffffc0202296:	8b89                	andi	a5,a5,2
ffffffffc0202298:	e799                	bnez	a5,ffffffffc02022a6 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc020229a:	000d3783          	ld	a5,0(s10)
ffffffffc020229e:	4585                	li	a1,1
ffffffffc02022a0:	739c                	ld	a5,32(a5)
ffffffffc02022a2:	9782                	jalr	a5
    if (flag)
ffffffffc02022a4:	bfd1                	j	ffffffffc0202278 <unmap_range+0xbc>
ffffffffc02022a6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02022a8:	f0cfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02022ac:	000d3783          	ld	a5,0(s10)
ffffffffc02022b0:	6522                	ld	a0,8(sp)
ffffffffc02022b2:	4585                	li	a1,1
ffffffffc02022b4:	739c                	ld	a5,32(a5)
ffffffffc02022b6:	9782                	jalr	a5
        intr_enable();
ffffffffc02022b8:	ef6fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022bc:	bf75                	j	ffffffffc0202278 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022be:	00004697          	auipc	a3,0x4
ffffffffc02022c2:	36268693          	addi	a3,a3,866 # ffffffffc0206620 <default_pmm_manager+0x160>
ffffffffc02022c6:	00004617          	auipc	a2,0x4
ffffffffc02022ca:	e4a60613          	addi	a2,a2,-438 # ffffffffc0206110 <commands+0x818>
ffffffffc02022ce:	12000593          	li	a1,288
ffffffffc02022d2:	00004517          	auipc	a0,0x4
ffffffffc02022d6:	33e50513          	addi	a0,a0,830 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02022da:	9b4fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02022de:	00004697          	auipc	a3,0x4
ffffffffc02022e2:	37268693          	addi	a3,a3,882 # ffffffffc0206650 <default_pmm_manager+0x190>
ffffffffc02022e6:	00004617          	auipc	a2,0x4
ffffffffc02022ea:	e2a60613          	addi	a2,a2,-470 # ffffffffc0206110 <commands+0x818>
ffffffffc02022ee:	12100593          	li	a1,289
ffffffffc02022f2:	00004517          	auipc	a0,0x4
ffffffffc02022f6:	31e50513          	addi	a0,a0,798 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02022fa:	994fe0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02022fe:	b53ff0ef          	jal	ra,ffffffffc0201e50 <pa2page.part.0>

ffffffffc0202302 <exit_range>:
{
ffffffffc0202302:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202304:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202308:	fc86                	sd	ra,120(sp)
ffffffffc020230a:	f8a2                	sd	s0,112(sp)
ffffffffc020230c:	f4a6                	sd	s1,104(sp)
ffffffffc020230e:	f0ca                	sd	s2,96(sp)
ffffffffc0202310:	ecce                	sd	s3,88(sp)
ffffffffc0202312:	e8d2                	sd	s4,80(sp)
ffffffffc0202314:	e4d6                	sd	s5,72(sp)
ffffffffc0202316:	e0da                	sd	s6,64(sp)
ffffffffc0202318:	fc5e                	sd	s7,56(sp)
ffffffffc020231a:	f862                	sd	s8,48(sp)
ffffffffc020231c:	f466                	sd	s9,40(sp)
ffffffffc020231e:	f06a                	sd	s10,32(sp)
ffffffffc0202320:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202322:	17d2                	slli	a5,a5,0x34
ffffffffc0202324:	20079a63          	bnez	a5,ffffffffc0202538 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202328:	002007b7          	lui	a5,0x200
ffffffffc020232c:	24f5e463          	bltu	a1,a5,ffffffffc0202574 <exit_range+0x272>
ffffffffc0202330:	8ab2                	mv	s5,a2
ffffffffc0202332:	24c5f163          	bgeu	a1,a2,ffffffffc0202574 <exit_range+0x272>
ffffffffc0202336:	4785                	li	a5,1
ffffffffc0202338:	07fe                	slli	a5,a5,0x1f
ffffffffc020233a:	22c7ed63          	bltu	a5,a2,ffffffffc0202574 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020233e:	c00009b7          	lui	s3,0xc0000
ffffffffc0202342:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202346:	ffe00937          	lui	s2,0xffe00
ffffffffc020234a:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020234e:	5cfd                	li	s9,-1
ffffffffc0202350:	8c2a                	mv	s8,a0
ffffffffc0202352:	0125f933          	and	s2,a1,s2
ffffffffc0202356:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202358:	000a8d17          	auipc	s10,0xa8
ffffffffc020235c:	3c8d0d13          	addi	s10,s10,968 # ffffffffc02aa720 <npage>
    return KADDR(page2pa(page));
ffffffffc0202360:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202364:	000a8717          	auipc	a4,0xa8
ffffffffc0202368:	3c470713          	addi	a4,a4,964 # ffffffffc02aa728 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc020236c:	000a8d97          	auipc	s11,0xa8
ffffffffc0202370:	3c4d8d93          	addi	s11,s11,964 # ffffffffc02aa730 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202374:	c0000437          	lui	s0,0xc0000
ffffffffc0202378:	944e                	add	s0,s0,s3
ffffffffc020237a:	8079                	srli	s0,s0,0x1e
ffffffffc020237c:	1ff47413          	andi	s0,s0,511
ffffffffc0202380:	040e                	slli	s0,s0,0x3
ffffffffc0202382:	9462                	add	s0,s0,s8
ffffffffc0202384:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ee0>
        if (pde1 & PTE_V)
ffffffffc0202388:	001a7793          	andi	a5,s4,1
ffffffffc020238c:	eb99                	bnez	a5,ffffffffc02023a2 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc020238e:	12098463          	beqz	s3,ffffffffc02024b6 <exit_range+0x1b4>
ffffffffc0202392:	400007b7          	lui	a5,0x40000
ffffffffc0202396:	97ce                	add	a5,a5,s3
ffffffffc0202398:	894e                	mv	s2,s3
ffffffffc020239a:	1159fe63          	bgeu	s3,s5,ffffffffc02024b6 <exit_range+0x1b4>
ffffffffc020239e:	89be                	mv	s3,a5
ffffffffc02023a0:	bfd1                	j	ffffffffc0202374 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02023a2:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02023a6:	0a0a                	slli	s4,s4,0x2
ffffffffc02023a8:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc02023ac:	1cfa7263          	bgeu	s4,a5,ffffffffc0202570 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02023b0:	fff80637          	lui	a2,0xfff80
ffffffffc02023b4:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc02023b6:	000806b7          	lui	a3,0x80
ffffffffc02023ba:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02023bc:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02023c0:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02023c2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02023c4:	18f5fa63          	bgeu	a1,a5,ffffffffc0202558 <exit_range+0x256>
ffffffffc02023c8:	000a8817          	auipc	a6,0xa8
ffffffffc02023cc:	37080813          	addi	a6,a6,880 # ffffffffc02aa738 <va_pa_offset>
ffffffffc02023d0:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02023d4:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02023d6:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02023da:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02023dc:	00080337          	lui	t1,0x80
ffffffffc02023e0:	6885                	lui	a7,0x1
ffffffffc02023e2:	a819                	j	ffffffffc02023f8 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc02023e4:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc02023e6:	002007b7          	lui	a5,0x200
ffffffffc02023ea:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02023ec:	08090c63          	beqz	s2,ffffffffc0202484 <exit_range+0x182>
ffffffffc02023f0:	09397a63          	bgeu	s2,s3,ffffffffc0202484 <exit_range+0x182>
ffffffffc02023f4:	0f597063          	bgeu	s2,s5,ffffffffc02024d4 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02023f8:	01595493          	srli	s1,s2,0x15
ffffffffc02023fc:	1ff4f493          	andi	s1,s1,511
ffffffffc0202400:	048e                	slli	s1,s1,0x3
ffffffffc0202402:	94da                	add	s1,s1,s6
ffffffffc0202404:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202406:	0017f693          	andi	a3,a5,1
ffffffffc020240a:	dee9                	beqz	a3,ffffffffc02023e4 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc020240c:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202410:	078a                	slli	a5,a5,0x2
ffffffffc0202412:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202414:	14b7fe63          	bgeu	a5,a1,ffffffffc0202570 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202418:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020241a:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020241e:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202422:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202426:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202428:	12bef863          	bgeu	t4,a1,ffffffffc0202558 <exit_range+0x256>
ffffffffc020242c:	00083783          	ld	a5,0(a6)
ffffffffc0202430:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202432:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202436:	629c                	ld	a5,0(a3)
ffffffffc0202438:	8b85                	andi	a5,a5,1
ffffffffc020243a:	f7d5                	bnez	a5,ffffffffc02023e6 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020243c:	06a1                	addi	a3,a3,8
ffffffffc020243e:	fed59ce3          	bne	a1,a3,ffffffffc0202436 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202442:	631c                	ld	a5,0(a4)
ffffffffc0202444:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202446:	100027f3          	csrr	a5,sstatus
ffffffffc020244a:	8b89                	andi	a5,a5,2
ffffffffc020244c:	e7d9                	bnez	a5,ffffffffc02024da <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020244e:	000db783          	ld	a5,0(s11)
ffffffffc0202452:	4585                	li	a1,1
ffffffffc0202454:	e032                	sd	a2,0(sp)
ffffffffc0202456:	739c                	ld	a5,32(a5)
ffffffffc0202458:	9782                	jalr	a5
    if (flag)
ffffffffc020245a:	6602                	ld	a2,0(sp)
ffffffffc020245c:	000a8817          	auipc	a6,0xa8
ffffffffc0202460:	2dc80813          	addi	a6,a6,732 # ffffffffc02aa738 <va_pa_offset>
ffffffffc0202464:	fff80e37          	lui	t3,0xfff80
ffffffffc0202468:	00080337          	lui	t1,0x80
ffffffffc020246c:	6885                	lui	a7,0x1
ffffffffc020246e:	000a8717          	auipc	a4,0xa8
ffffffffc0202472:	2ba70713          	addi	a4,a4,698 # ffffffffc02aa728 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202476:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020247a:	002007b7          	lui	a5,0x200
ffffffffc020247e:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202480:	f60918e3          	bnez	s2,ffffffffc02023f0 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202484:	f00b85e3          	beqz	s7,ffffffffc020238e <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202488:	000d3783          	ld	a5,0(s10)
ffffffffc020248c:	0efa7263          	bgeu	s4,a5,ffffffffc0202570 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202490:	6308                	ld	a0,0(a4)
ffffffffc0202492:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202494:	100027f3          	csrr	a5,sstatus
ffffffffc0202498:	8b89                	andi	a5,a5,2
ffffffffc020249a:	efad                	bnez	a5,ffffffffc0202514 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc020249c:	000db783          	ld	a5,0(s11)
ffffffffc02024a0:	4585                	li	a1,1
ffffffffc02024a2:	739c                	ld	a5,32(a5)
ffffffffc02024a4:	9782                	jalr	a5
ffffffffc02024a6:	000a8717          	auipc	a4,0xa8
ffffffffc02024aa:	28270713          	addi	a4,a4,642 # ffffffffc02aa728 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02024ae:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02024b2:	ee0990e3          	bnez	s3,ffffffffc0202392 <exit_range+0x90>
}
ffffffffc02024b6:	70e6                	ld	ra,120(sp)
ffffffffc02024b8:	7446                	ld	s0,112(sp)
ffffffffc02024ba:	74a6                	ld	s1,104(sp)
ffffffffc02024bc:	7906                	ld	s2,96(sp)
ffffffffc02024be:	69e6                	ld	s3,88(sp)
ffffffffc02024c0:	6a46                	ld	s4,80(sp)
ffffffffc02024c2:	6aa6                	ld	s5,72(sp)
ffffffffc02024c4:	6b06                	ld	s6,64(sp)
ffffffffc02024c6:	7be2                	ld	s7,56(sp)
ffffffffc02024c8:	7c42                	ld	s8,48(sp)
ffffffffc02024ca:	7ca2                	ld	s9,40(sp)
ffffffffc02024cc:	7d02                	ld	s10,32(sp)
ffffffffc02024ce:	6de2                	ld	s11,24(sp)
ffffffffc02024d0:	6109                	addi	sp,sp,128
ffffffffc02024d2:	8082                	ret
            if (free_pd0)
ffffffffc02024d4:	ea0b8fe3          	beqz	s7,ffffffffc0202392 <exit_range+0x90>
ffffffffc02024d8:	bf45                	j	ffffffffc0202488 <exit_range+0x186>
ffffffffc02024da:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02024dc:	e42a                	sd	a0,8(sp)
ffffffffc02024de:	cd6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02024e2:	000db783          	ld	a5,0(s11)
ffffffffc02024e6:	6522                	ld	a0,8(sp)
ffffffffc02024e8:	4585                	li	a1,1
ffffffffc02024ea:	739c                	ld	a5,32(a5)
ffffffffc02024ec:	9782                	jalr	a5
        intr_enable();
ffffffffc02024ee:	cc0fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02024f2:	6602                	ld	a2,0(sp)
ffffffffc02024f4:	000a8717          	auipc	a4,0xa8
ffffffffc02024f8:	23470713          	addi	a4,a4,564 # ffffffffc02aa728 <pages>
ffffffffc02024fc:	6885                	lui	a7,0x1
ffffffffc02024fe:	00080337          	lui	t1,0x80
ffffffffc0202502:	fff80e37          	lui	t3,0xfff80
ffffffffc0202506:	000a8817          	auipc	a6,0xa8
ffffffffc020250a:	23280813          	addi	a6,a6,562 # ffffffffc02aa738 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020250e:	0004b023          	sd	zero,0(s1)
ffffffffc0202512:	b7a5                	j	ffffffffc020247a <exit_range+0x178>
ffffffffc0202514:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202516:	c9efe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020251a:	000db783          	ld	a5,0(s11)
ffffffffc020251e:	6502                	ld	a0,0(sp)
ffffffffc0202520:	4585                	li	a1,1
ffffffffc0202522:	739c                	ld	a5,32(a5)
ffffffffc0202524:	9782                	jalr	a5
        intr_enable();
ffffffffc0202526:	c88fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020252a:	000a8717          	auipc	a4,0xa8
ffffffffc020252e:	1fe70713          	addi	a4,a4,510 # ffffffffc02aa728 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202532:	00043023          	sd	zero,0(s0)
ffffffffc0202536:	bfb5                	j	ffffffffc02024b2 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202538:	00004697          	auipc	a3,0x4
ffffffffc020253c:	0e868693          	addi	a3,a3,232 # ffffffffc0206620 <default_pmm_manager+0x160>
ffffffffc0202540:	00004617          	auipc	a2,0x4
ffffffffc0202544:	bd060613          	addi	a2,a2,-1072 # ffffffffc0206110 <commands+0x818>
ffffffffc0202548:	13500593          	li	a1,309
ffffffffc020254c:	00004517          	auipc	a0,0x4
ffffffffc0202550:	0c450513          	addi	a0,a0,196 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202554:	f3bfd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202558:	00004617          	auipc	a2,0x4
ffffffffc020255c:	fa060613          	addi	a2,a2,-96 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0202560:	07100593          	li	a1,113
ffffffffc0202564:	00004517          	auipc	a0,0x4
ffffffffc0202568:	fbc50513          	addi	a0,a0,-68 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc020256c:	f23fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202570:	8e1ff0ef          	jal	ra,ffffffffc0201e50 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202574:	00004697          	auipc	a3,0x4
ffffffffc0202578:	0dc68693          	addi	a3,a3,220 # ffffffffc0206650 <default_pmm_manager+0x190>
ffffffffc020257c:	00004617          	auipc	a2,0x4
ffffffffc0202580:	b9460613          	addi	a2,a2,-1132 # ffffffffc0206110 <commands+0x818>
ffffffffc0202584:	13600593          	li	a1,310
ffffffffc0202588:	00004517          	auipc	a0,0x4
ffffffffc020258c:	08850513          	addi	a0,a0,136 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202590:	efffd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202594 <page_remove>:
{
ffffffffc0202594:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202596:	4601                	li	a2,0
{
ffffffffc0202598:	ec26                	sd	s1,24(sp)
ffffffffc020259a:	f406                	sd	ra,40(sp)
ffffffffc020259c:	f022                	sd	s0,32(sp)
ffffffffc020259e:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025a0:	9a1ff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
    if (ptep != NULL)
ffffffffc02025a4:	c511                	beqz	a0,ffffffffc02025b0 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc02025a6:	611c                	ld	a5,0(a0)
ffffffffc02025a8:	842a                	mv	s0,a0
ffffffffc02025aa:	0017f713          	andi	a4,a5,1
ffffffffc02025ae:	e711                	bnez	a4,ffffffffc02025ba <page_remove+0x26>
}
ffffffffc02025b0:	70a2                	ld	ra,40(sp)
ffffffffc02025b2:	7402                	ld	s0,32(sp)
ffffffffc02025b4:	64e2                	ld	s1,24(sp)
ffffffffc02025b6:	6145                	addi	sp,sp,48
ffffffffc02025b8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02025ba:	078a                	slli	a5,a5,0x2
ffffffffc02025bc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025be:	000a8717          	auipc	a4,0xa8
ffffffffc02025c2:	16273703          	ld	a4,354(a4) # ffffffffc02aa720 <npage>
ffffffffc02025c6:	06e7f363          	bgeu	a5,a4,ffffffffc020262c <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02025ca:	fff80537          	lui	a0,0xfff80
ffffffffc02025ce:	97aa                	add	a5,a5,a0
ffffffffc02025d0:	079a                	slli	a5,a5,0x6
ffffffffc02025d2:	000a8517          	auipc	a0,0xa8
ffffffffc02025d6:	15653503          	ld	a0,342(a0) # ffffffffc02aa728 <pages>
ffffffffc02025da:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02025dc:	411c                	lw	a5,0(a0)
ffffffffc02025de:	fff7871b          	addiw	a4,a5,-1
ffffffffc02025e2:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02025e4:	cb11                	beqz	a4,ffffffffc02025f8 <page_remove+0x64>
        *ptep = 0;
ffffffffc02025e6:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025ea:	12048073          	sfence.vma	s1
}
ffffffffc02025ee:	70a2                	ld	ra,40(sp)
ffffffffc02025f0:	7402                	ld	s0,32(sp)
ffffffffc02025f2:	64e2                	ld	s1,24(sp)
ffffffffc02025f4:	6145                	addi	sp,sp,48
ffffffffc02025f6:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02025f8:	100027f3          	csrr	a5,sstatus
ffffffffc02025fc:	8b89                	andi	a5,a5,2
ffffffffc02025fe:	eb89                	bnez	a5,ffffffffc0202610 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202600:	000a8797          	auipc	a5,0xa8
ffffffffc0202604:	1307b783          	ld	a5,304(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0202608:	739c                	ld	a5,32(a5)
ffffffffc020260a:	4585                	li	a1,1
ffffffffc020260c:	9782                	jalr	a5
    if (flag)
ffffffffc020260e:	bfe1                	j	ffffffffc02025e6 <page_remove+0x52>
        intr_disable();
ffffffffc0202610:	e42a                	sd	a0,8(sp)
ffffffffc0202612:	ba2fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202616:	000a8797          	auipc	a5,0xa8
ffffffffc020261a:	11a7b783          	ld	a5,282(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc020261e:	739c                	ld	a5,32(a5)
ffffffffc0202620:	6522                	ld	a0,8(sp)
ffffffffc0202622:	4585                	li	a1,1
ffffffffc0202624:	9782                	jalr	a5
        intr_enable();
ffffffffc0202626:	b88fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020262a:	bf75                	j	ffffffffc02025e6 <page_remove+0x52>
ffffffffc020262c:	825ff0ef          	jal	ra,ffffffffc0201e50 <pa2page.part.0>

ffffffffc0202630 <page_insert>:
{
ffffffffc0202630:	7139                	addi	sp,sp,-64
ffffffffc0202632:	e852                	sd	s4,16(sp)
ffffffffc0202634:	8a32                	mv	s4,a2
ffffffffc0202636:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202638:	4605                	li	a2,1
{
ffffffffc020263a:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020263c:	85d2                	mv	a1,s4
{
ffffffffc020263e:	f426                	sd	s1,40(sp)
ffffffffc0202640:	fc06                	sd	ra,56(sp)
ffffffffc0202642:	f04a                	sd	s2,32(sp)
ffffffffc0202644:	ec4e                	sd	s3,24(sp)
ffffffffc0202646:	e456                	sd	s5,8(sp)
ffffffffc0202648:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020264a:	8f7ff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
    if (ptep == NULL)
ffffffffc020264e:	c961                	beqz	a0,ffffffffc020271e <page_insert+0xee>
    page->ref += 1;
ffffffffc0202650:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202652:	611c                	ld	a5,0(a0)
ffffffffc0202654:	89aa                	mv	s3,a0
ffffffffc0202656:	0016871b          	addiw	a4,a3,1
ffffffffc020265a:	c018                	sw	a4,0(s0)
ffffffffc020265c:	0017f713          	andi	a4,a5,1
ffffffffc0202660:	ef05                	bnez	a4,ffffffffc0202698 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202662:	000a8717          	auipc	a4,0xa8
ffffffffc0202666:	0c673703          	ld	a4,198(a4) # ffffffffc02aa728 <pages>
ffffffffc020266a:	8c19                	sub	s0,s0,a4
ffffffffc020266c:	000807b7          	lui	a5,0x80
ffffffffc0202670:	8419                	srai	s0,s0,0x6
ffffffffc0202672:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202674:	042a                	slli	s0,s0,0xa
ffffffffc0202676:	8cc1                	or	s1,s1,s0
ffffffffc0202678:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc020267c:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ee0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202680:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202684:	4501                	li	a0,0
}
ffffffffc0202686:	70e2                	ld	ra,56(sp)
ffffffffc0202688:	7442                	ld	s0,48(sp)
ffffffffc020268a:	74a2                	ld	s1,40(sp)
ffffffffc020268c:	7902                	ld	s2,32(sp)
ffffffffc020268e:	69e2                	ld	s3,24(sp)
ffffffffc0202690:	6a42                	ld	s4,16(sp)
ffffffffc0202692:	6aa2                	ld	s5,8(sp)
ffffffffc0202694:	6121                	addi	sp,sp,64
ffffffffc0202696:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202698:	078a                	slli	a5,a5,0x2
ffffffffc020269a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020269c:	000a8717          	auipc	a4,0xa8
ffffffffc02026a0:	08473703          	ld	a4,132(a4) # ffffffffc02aa720 <npage>
ffffffffc02026a4:	06e7ff63          	bgeu	a5,a4,ffffffffc0202722 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02026a8:	000a8a97          	auipc	s5,0xa8
ffffffffc02026ac:	080a8a93          	addi	s5,s5,128 # ffffffffc02aa728 <pages>
ffffffffc02026b0:	000ab703          	ld	a4,0(s5)
ffffffffc02026b4:	fff80937          	lui	s2,0xfff80
ffffffffc02026b8:	993e                	add	s2,s2,a5
ffffffffc02026ba:	091a                	slli	s2,s2,0x6
ffffffffc02026bc:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02026be:	01240c63          	beq	s0,s2,ffffffffc02026d6 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02026c2:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcd58a4>
ffffffffc02026c6:	fff7869b          	addiw	a3,a5,-1
ffffffffc02026ca:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc02026ce:	c691                	beqz	a3,ffffffffc02026da <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026d0:	120a0073          	sfence.vma	s4
}
ffffffffc02026d4:	bf59                	j	ffffffffc020266a <page_insert+0x3a>
ffffffffc02026d6:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02026d8:	bf49                	j	ffffffffc020266a <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026da:	100027f3          	csrr	a5,sstatus
ffffffffc02026de:	8b89                	andi	a5,a5,2
ffffffffc02026e0:	ef91                	bnez	a5,ffffffffc02026fc <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc02026e2:	000a8797          	auipc	a5,0xa8
ffffffffc02026e6:	04e7b783          	ld	a5,78(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc02026ea:	739c                	ld	a5,32(a5)
ffffffffc02026ec:	4585                	li	a1,1
ffffffffc02026ee:	854a                	mv	a0,s2
ffffffffc02026f0:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02026f2:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026f6:	120a0073          	sfence.vma	s4
ffffffffc02026fa:	bf85                	j	ffffffffc020266a <page_insert+0x3a>
        intr_disable();
ffffffffc02026fc:	ab8fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202700:	000a8797          	auipc	a5,0xa8
ffffffffc0202704:	0307b783          	ld	a5,48(a5) # ffffffffc02aa730 <pmm_manager>
ffffffffc0202708:	739c                	ld	a5,32(a5)
ffffffffc020270a:	4585                	li	a1,1
ffffffffc020270c:	854a                	mv	a0,s2
ffffffffc020270e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202710:	a9efe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202714:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202718:	120a0073          	sfence.vma	s4
ffffffffc020271c:	b7b9                	j	ffffffffc020266a <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020271e:	5571                	li	a0,-4
ffffffffc0202720:	b79d                	j	ffffffffc0202686 <page_insert+0x56>
ffffffffc0202722:	f2eff0ef          	jal	ra,ffffffffc0201e50 <pa2page.part.0>

ffffffffc0202726 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202726:	00004797          	auipc	a5,0x4
ffffffffc020272a:	d9a78793          	addi	a5,a5,-614 # ffffffffc02064c0 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020272e:	638c                	ld	a1,0(a5)
{
ffffffffc0202730:	7159                	addi	sp,sp,-112
ffffffffc0202732:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202734:	00004517          	auipc	a0,0x4
ffffffffc0202738:	f3450513          	addi	a0,a0,-204 # ffffffffc0206668 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc020273c:	000a8b17          	auipc	s6,0xa8
ffffffffc0202740:	ff4b0b13          	addi	s6,s6,-12 # ffffffffc02aa730 <pmm_manager>
{
ffffffffc0202744:	f486                	sd	ra,104(sp)
ffffffffc0202746:	e8ca                	sd	s2,80(sp)
ffffffffc0202748:	e4ce                	sd	s3,72(sp)
ffffffffc020274a:	f0a2                	sd	s0,96(sp)
ffffffffc020274c:	eca6                	sd	s1,88(sp)
ffffffffc020274e:	e0d2                	sd	s4,64(sp)
ffffffffc0202750:	fc56                	sd	s5,56(sp)
ffffffffc0202752:	f45e                	sd	s7,40(sp)
ffffffffc0202754:	f062                	sd	s8,32(sp)
ffffffffc0202756:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202758:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020275c:	a39fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202760:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202764:	000a8997          	auipc	s3,0xa8
ffffffffc0202768:	fd498993          	addi	s3,s3,-44 # ffffffffc02aa738 <va_pa_offset>
    pmm_manager->init();
ffffffffc020276c:	679c                	ld	a5,8(a5)
ffffffffc020276e:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202770:	57f5                	li	a5,-3
ffffffffc0202772:	07fa                	slli	a5,a5,0x1e
ffffffffc0202774:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202778:	a22fe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc020277c:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020277e:	a26fe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202782:	200505e3          	beqz	a0,ffffffffc020318c <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202786:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202788:	00004517          	auipc	a0,0x4
ffffffffc020278c:	f1850513          	addi	a0,a0,-232 # ffffffffc02066a0 <default_pmm_manager+0x1e0>
ffffffffc0202790:	a05fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202794:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202798:	fff40693          	addi	a3,s0,-1
ffffffffc020279c:	864a                	mv	a2,s2
ffffffffc020279e:	85a6                	mv	a1,s1
ffffffffc02027a0:	00004517          	auipc	a0,0x4
ffffffffc02027a4:	f1850513          	addi	a0,a0,-232 # ffffffffc02066b8 <default_pmm_manager+0x1f8>
ffffffffc02027a8:	9edfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02027ac:	c8000737          	lui	a4,0xc8000
ffffffffc02027b0:	87a2                	mv	a5,s0
ffffffffc02027b2:	54876163          	bltu	a4,s0,ffffffffc0202cf4 <pmm_init+0x5ce>
ffffffffc02027b6:	757d                	lui	a0,0xfffff
ffffffffc02027b8:	000a9617          	auipc	a2,0xa9
ffffffffc02027bc:	fa360613          	addi	a2,a2,-93 # ffffffffc02ab75b <end+0xfff>
ffffffffc02027c0:	8e69                	and	a2,a2,a0
ffffffffc02027c2:	000a8497          	auipc	s1,0xa8
ffffffffc02027c6:	f5e48493          	addi	s1,s1,-162 # ffffffffc02aa720 <npage>
ffffffffc02027ca:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027ce:	000a8b97          	auipc	s7,0xa8
ffffffffc02027d2:	f5ab8b93          	addi	s7,s7,-166 # ffffffffc02aa728 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02027d6:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027d8:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027dc:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027e0:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027e2:	02f50863          	beq	a0,a5,ffffffffc0202812 <pmm_init+0xec>
ffffffffc02027e6:	4781                	li	a5,0
ffffffffc02027e8:	4585                	li	a1,1
ffffffffc02027ea:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02027ee:	00679513          	slli	a0,a5,0x6
ffffffffc02027f2:	9532                	add	a0,a0,a2
ffffffffc02027f4:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd548ac>
ffffffffc02027f8:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027fc:	6088                	ld	a0,0(s1)
ffffffffc02027fe:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202800:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202804:	00d50733          	add	a4,a0,a3
ffffffffc0202808:	fee7e3e3          	bltu	a5,a4,ffffffffc02027ee <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020280c:	071a                	slli	a4,a4,0x6
ffffffffc020280e:	00e606b3          	add	a3,a2,a4
ffffffffc0202812:	c02007b7          	lui	a5,0xc0200
ffffffffc0202816:	2ef6ece3          	bltu	a3,a5,ffffffffc020330e <pmm_init+0xbe8>
ffffffffc020281a:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020281e:	77fd                	lui	a5,0xfffff
ffffffffc0202820:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202822:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202824:	5086eb63          	bltu	a3,s0,ffffffffc0202d3a <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202828:	00004517          	auipc	a0,0x4
ffffffffc020282c:	eb850513          	addi	a0,a0,-328 # ffffffffc02066e0 <default_pmm_manager+0x220>
ffffffffc0202830:	965fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202834:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202838:	000a8917          	auipc	s2,0xa8
ffffffffc020283c:	ee090913          	addi	s2,s2,-288 # ffffffffc02aa718 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202840:	7b9c                	ld	a5,48(a5)
ffffffffc0202842:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202844:	00004517          	auipc	a0,0x4
ffffffffc0202848:	eb450513          	addi	a0,a0,-332 # ffffffffc02066f8 <default_pmm_manager+0x238>
ffffffffc020284c:	949fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202850:	00007697          	auipc	a3,0x7
ffffffffc0202854:	7b068693          	addi	a3,a3,1968 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202858:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020285c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202860:	28f6ebe3          	bltu	a3,a5,ffffffffc02032f6 <pmm_init+0xbd0>
ffffffffc0202864:	0009b783          	ld	a5,0(s3)
ffffffffc0202868:	8e9d                	sub	a3,a3,a5
ffffffffc020286a:	000a8797          	auipc	a5,0xa8
ffffffffc020286e:	ead7b323          	sd	a3,-346(a5) # ffffffffc02aa710 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202872:	100027f3          	csrr	a5,sstatus
ffffffffc0202876:	8b89                	andi	a5,a5,2
ffffffffc0202878:	4a079763          	bnez	a5,ffffffffc0202d26 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc020287c:	000b3783          	ld	a5,0(s6)
ffffffffc0202880:	779c                	ld	a5,40(a5)
ffffffffc0202882:	9782                	jalr	a5
ffffffffc0202884:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202886:	6098                	ld	a4,0(s1)
ffffffffc0202888:	c80007b7          	lui	a5,0xc8000
ffffffffc020288c:	83b1                	srli	a5,a5,0xc
ffffffffc020288e:	66e7e363          	bltu	a5,a4,ffffffffc0202ef4 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202892:	00093503          	ld	a0,0(s2)
ffffffffc0202896:	62050f63          	beqz	a0,ffffffffc0202ed4 <pmm_init+0x7ae>
ffffffffc020289a:	03451793          	slli	a5,a0,0x34
ffffffffc020289e:	62079b63          	bnez	a5,ffffffffc0202ed4 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02028a2:	4601                	li	a2,0
ffffffffc02028a4:	4581                	li	a1,0
ffffffffc02028a6:	8c3ff0ef          	jal	ra,ffffffffc0202168 <get_page>
ffffffffc02028aa:	60051563          	bnez	a0,ffffffffc0202eb4 <pmm_init+0x78e>
ffffffffc02028ae:	100027f3          	csrr	a5,sstatus
ffffffffc02028b2:	8b89                	andi	a5,a5,2
ffffffffc02028b4:	44079e63          	bnez	a5,ffffffffc0202d10 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02028b8:	000b3783          	ld	a5,0(s6)
ffffffffc02028bc:	4505                	li	a0,1
ffffffffc02028be:	6f9c                	ld	a5,24(a5)
ffffffffc02028c0:	9782                	jalr	a5
ffffffffc02028c2:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02028c4:	00093503          	ld	a0,0(s2)
ffffffffc02028c8:	4681                	li	a3,0
ffffffffc02028ca:	4601                	li	a2,0
ffffffffc02028cc:	85d2                	mv	a1,s4
ffffffffc02028ce:	d63ff0ef          	jal	ra,ffffffffc0202630 <page_insert>
ffffffffc02028d2:	26051ae3          	bnez	a0,ffffffffc0203346 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02028d6:	00093503          	ld	a0,0(s2)
ffffffffc02028da:	4601                	li	a2,0
ffffffffc02028dc:	4581                	li	a1,0
ffffffffc02028de:	e62ff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
ffffffffc02028e2:	240502e3          	beqz	a0,ffffffffc0203326 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc02028e6:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc02028e8:	0017f713          	andi	a4,a5,1
ffffffffc02028ec:	5a070263          	beqz	a4,ffffffffc0202e90 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc02028f0:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02028f2:	078a                	slli	a5,a5,0x2
ffffffffc02028f4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02028f6:	58e7fb63          	bgeu	a5,a4,ffffffffc0202e8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02028fa:	000bb683          	ld	a3,0(s7)
ffffffffc02028fe:	fff80637          	lui	a2,0xfff80
ffffffffc0202902:	97b2                	add	a5,a5,a2
ffffffffc0202904:	079a                	slli	a5,a5,0x6
ffffffffc0202906:	97b6                	add	a5,a5,a3
ffffffffc0202908:	14fa17e3          	bne	s4,a5,ffffffffc0203256 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc020290c:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>
ffffffffc0202910:	4785                	li	a5,1
ffffffffc0202912:	12f692e3          	bne	a3,a5,ffffffffc0203236 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202916:	00093503          	ld	a0,0(s2)
ffffffffc020291a:	77fd                	lui	a5,0xfffff
ffffffffc020291c:	6114                	ld	a3,0(a0)
ffffffffc020291e:	068a                	slli	a3,a3,0x2
ffffffffc0202920:	8efd                	and	a3,a3,a5
ffffffffc0202922:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202926:	0ee67ce3          	bgeu	a2,a4,ffffffffc020321e <pmm_init+0xaf8>
ffffffffc020292a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020292e:	96e2                	add	a3,a3,s8
ffffffffc0202930:	0006ba83          	ld	s5,0(a3)
ffffffffc0202934:	0a8a                	slli	s5,s5,0x2
ffffffffc0202936:	00fafab3          	and	s5,s5,a5
ffffffffc020293a:	00cad793          	srli	a5,s5,0xc
ffffffffc020293e:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203204 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202942:	4601                	li	a2,0
ffffffffc0202944:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202946:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202948:	df8ff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020294c:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020294e:	55551363          	bne	a0,s5,ffffffffc0202e94 <pmm_init+0x76e>
ffffffffc0202952:	100027f3          	csrr	a5,sstatus
ffffffffc0202956:	8b89                	andi	a5,a5,2
ffffffffc0202958:	3a079163          	bnez	a5,ffffffffc0202cfa <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc020295c:	000b3783          	ld	a5,0(s6)
ffffffffc0202960:	4505                	li	a0,1
ffffffffc0202962:	6f9c                	ld	a5,24(a5)
ffffffffc0202964:	9782                	jalr	a5
ffffffffc0202966:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202968:	00093503          	ld	a0,0(s2)
ffffffffc020296c:	46d1                	li	a3,20
ffffffffc020296e:	6605                	lui	a2,0x1
ffffffffc0202970:	85e2                	mv	a1,s8
ffffffffc0202972:	cbfff0ef          	jal	ra,ffffffffc0202630 <page_insert>
ffffffffc0202976:	060517e3          	bnez	a0,ffffffffc02031e4 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020297a:	00093503          	ld	a0,0(s2)
ffffffffc020297e:	4601                	li	a2,0
ffffffffc0202980:	6585                	lui	a1,0x1
ffffffffc0202982:	dbeff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
ffffffffc0202986:	02050fe3          	beqz	a0,ffffffffc02031c4 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc020298a:	611c                	ld	a5,0(a0)
ffffffffc020298c:	0107f713          	andi	a4,a5,16
ffffffffc0202990:	7c070e63          	beqz	a4,ffffffffc020316c <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0202994:	8b91                	andi	a5,a5,4
ffffffffc0202996:	7a078b63          	beqz	a5,ffffffffc020314c <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020299a:	00093503          	ld	a0,0(s2)
ffffffffc020299e:	611c                	ld	a5,0(a0)
ffffffffc02029a0:	8bc1                	andi	a5,a5,16
ffffffffc02029a2:	78078563          	beqz	a5,ffffffffc020312c <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02029a6:	000c2703          	lw	a4,0(s8)
ffffffffc02029aa:	4785                	li	a5,1
ffffffffc02029ac:	76f71063          	bne	a4,a5,ffffffffc020310c <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02029b0:	4681                	li	a3,0
ffffffffc02029b2:	6605                	lui	a2,0x1
ffffffffc02029b4:	85d2                	mv	a1,s4
ffffffffc02029b6:	c7bff0ef          	jal	ra,ffffffffc0202630 <page_insert>
ffffffffc02029ba:	72051963          	bnez	a0,ffffffffc02030ec <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02029be:	000a2703          	lw	a4,0(s4)
ffffffffc02029c2:	4789                	li	a5,2
ffffffffc02029c4:	70f71463          	bne	a4,a5,ffffffffc02030cc <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02029c8:	000c2783          	lw	a5,0(s8)
ffffffffc02029cc:	6e079063          	bnez	a5,ffffffffc02030ac <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02029d0:	00093503          	ld	a0,0(s2)
ffffffffc02029d4:	4601                	li	a2,0
ffffffffc02029d6:	6585                	lui	a1,0x1
ffffffffc02029d8:	d68ff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
ffffffffc02029dc:	6a050863          	beqz	a0,ffffffffc020308c <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc02029e0:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc02029e2:	00177793          	andi	a5,a4,1
ffffffffc02029e6:	4a078563          	beqz	a5,ffffffffc0202e90 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc02029ea:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02029ec:	00271793          	slli	a5,a4,0x2
ffffffffc02029f0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029f2:	48d7fd63          	bgeu	a5,a3,ffffffffc0202e8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02029f6:	000bb683          	ld	a3,0(s7)
ffffffffc02029fa:	fff80ab7          	lui	s5,0xfff80
ffffffffc02029fe:	97d6                	add	a5,a5,s5
ffffffffc0202a00:	079a                	slli	a5,a5,0x6
ffffffffc0202a02:	97b6                	add	a5,a5,a3
ffffffffc0202a04:	66fa1463          	bne	s4,a5,ffffffffc020306c <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a08:	8b41                	andi	a4,a4,16
ffffffffc0202a0a:	64071163          	bnez	a4,ffffffffc020304c <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202a0e:	00093503          	ld	a0,0(s2)
ffffffffc0202a12:	4581                	li	a1,0
ffffffffc0202a14:	b81ff0ef          	jal	ra,ffffffffc0202594 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202a18:	000a2c83          	lw	s9,0(s4)
ffffffffc0202a1c:	4785                	li	a5,1
ffffffffc0202a1e:	60fc9763          	bne	s9,a5,ffffffffc020302c <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202a22:	000c2783          	lw	a5,0(s8)
ffffffffc0202a26:	5e079363          	bnez	a5,ffffffffc020300c <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202a2a:	00093503          	ld	a0,0(s2)
ffffffffc0202a2e:	6585                	lui	a1,0x1
ffffffffc0202a30:	b65ff0ef          	jal	ra,ffffffffc0202594 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202a34:	000a2783          	lw	a5,0(s4)
ffffffffc0202a38:	52079a63          	bnez	a5,ffffffffc0202f6c <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202a3c:	000c2783          	lw	a5,0(s8)
ffffffffc0202a40:	50079663          	bnez	a5,ffffffffc0202f4c <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202a44:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202a48:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a4a:	000a3683          	ld	a3,0(s4)
ffffffffc0202a4e:	068a                	slli	a3,a3,0x2
ffffffffc0202a50:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a52:	42b6fd63          	bgeu	a3,a1,ffffffffc0202e8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a56:	000bb503          	ld	a0,0(s7)
ffffffffc0202a5a:	96d6                	add	a3,a3,s5
ffffffffc0202a5c:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202a5e:	00d507b3          	add	a5,a0,a3
ffffffffc0202a62:	439c                	lw	a5,0(a5)
ffffffffc0202a64:	4d979463          	bne	a5,s9,ffffffffc0202f2c <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202a68:	8699                	srai	a3,a3,0x6
ffffffffc0202a6a:	00080637          	lui	a2,0x80
ffffffffc0202a6e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202a70:	00c69713          	slli	a4,a3,0xc
ffffffffc0202a74:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202a76:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202a78:	48b77e63          	bgeu	a4,a1,ffffffffc0202f14 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202a7c:	0009b703          	ld	a4,0(s3)
ffffffffc0202a80:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a82:	629c                	ld	a5,0(a3)
ffffffffc0202a84:	078a                	slli	a5,a5,0x2
ffffffffc0202a86:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a88:	40b7f263          	bgeu	a5,a1,ffffffffc0202e8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a8c:	8f91                	sub	a5,a5,a2
ffffffffc0202a8e:	079a                	slli	a5,a5,0x6
ffffffffc0202a90:	953e                	add	a0,a0,a5
ffffffffc0202a92:	100027f3          	csrr	a5,sstatus
ffffffffc0202a96:	8b89                	andi	a5,a5,2
ffffffffc0202a98:	30079963          	bnez	a5,ffffffffc0202daa <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202a9c:	000b3783          	ld	a5,0(s6)
ffffffffc0202aa0:	4585                	li	a1,1
ffffffffc0202aa2:	739c                	ld	a5,32(a5)
ffffffffc0202aa4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202aa6:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202aaa:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202aac:	078a                	slli	a5,a5,0x2
ffffffffc0202aae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ab0:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202e8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ab4:	000bb503          	ld	a0,0(s7)
ffffffffc0202ab8:	fff80737          	lui	a4,0xfff80
ffffffffc0202abc:	97ba                	add	a5,a5,a4
ffffffffc0202abe:	079a                	slli	a5,a5,0x6
ffffffffc0202ac0:	953e                	add	a0,a0,a5
ffffffffc0202ac2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ac6:	8b89                	andi	a5,a5,2
ffffffffc0202ac8:	2c079563          	bnez	a5,ffffffffc0202d92 <pmm_init+0x66c>
ffffffffc0202acc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ad0:	4585                	li	a1,1
ffffffffc0202ad2:	739c                	ld	a5,32(a5)
ffffffffc0202ad4:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202ad6:	00093783          	ld	a5,0(s2)
ffffffffc0202ada:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd548a4>
    asm volatile("sfence.vma");
ffffffffc0202ade:	12000073          	sfence.vma
ffffffffc0202ae2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ae6:	8b89                	andi	a5,a5,2
ffffffffc0202ae8:	28079b63          	bnez	a5,ffffffffc0202d7e <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202aec:	000b3783          	ld	a5,0(s6)
ffffffffc0202af0:	779c                	ld	a5,40(a5)
ffffffffc0202af2:	9782                	jalr	a5
ffffffffc0202af4:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202af6:	4b441b63          	bne	s0,s4,ffffffffc0202fac <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202afa:	00004517          	auipc	a0,0x4
ffffffffc0202afe:	f2650513          	addi	a0,a0,-218 # ffffffffc0206a20 <default_pmm_manager+0x560>
ffffffffc0202b02:	e92fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202b06:	100027f3          	csrr	a5,sstatus
ffffffffc0202b0a:	8b89                	andi	a5,a5,2
ffffffffc0202b0c:	24079f63          	bnez	a5,ffffffffc0202d6a <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b10:	000b3783          	ld	a5,0(s6)
ffffffffc0202b14:	779c                	ld	a5,40(a5)
ffffffffc0202b16:	9782                	jalr	a5
ffffffffc0202b18:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b1a:	6098                	ld	a4,0(s1)
ffffffffc0202b1c:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b20:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b22:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b26:	6a05                	lui	s4,0x1
ffffffffc0202b28:	02f47c63          	bgeu	s0,a5,ffffffffc0202b60 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202b2c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202b30:	00093503          	ld	a0,0(s2)
ffffffffc0202b34:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202e32 <pmm_init+0x70c>
ffffffffc0202b38:	0009b583          	ld	a1,0(s3)
ffffffffc0202b3c:	4601                	li	a2,0
ffffffffc0202b3e:	95a2                	add	a1,a1,s0
ffffffffc0202b40:	c00ff0ef          	jal	ra,ffffffffc0201f40 <get_pte>
ffffffffc0202b44:	32050463          	beqz	a0,ffffffffc0202e6c <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b48:	611c                	ld	a5,0(a0)
ffffffffc0202b4a:	078a                	slli	a5,a5,0x2
ffffffffc0202b4c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202b50:	2e879e63          	bne	a5,s0,ffffffffc0202e4c <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b54:	6098                	ld	a4,0(s1)
ffffffffc0202b56:	9452                	add	s0,s0,s4
ffffffffc0202b58:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b5c:	fcf468e3          	bltu	s0,a5,ffffffffc0202b2c <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202b60:	00093783          	ld	a5,0(s2)
ffffffffc0202b64:	639c                	ld	a5,0(a5)
ffffffffc0202b66:	42079363          	bnez	a5,ffffffffc0202f8c <pmm_init+0x866>
ffffffffc0202b6a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b6e:	8b89                	andi	a5,a5,2
ffffffffc0202b70:	24079963          	bnez	a5,ffffffffc0202dc2 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b74:	000b3783          	ld	a5,0(s6)
ffffffffc0202b78:	4505                	li	a0,1
ffffffffc0202b7a:	6f9c                	ld	a5,24(a5)
ffffffffc0202b7c:	9782                	jalr	a5
ffffffffc0202b7e:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202b80:	00093503          	ld	a0,0(s2)
ffffffffc0202b84:	4699                	li	a3,6
ffffffffc0202b86:	10000613          	li	a2,256
ffffffffc0202b8a:	85d2                	mv	a1,s4
ffffffffc0202b8c:	aa5ff0ef          	jal	ra,ffffffffc0202630 <page_insert>
ffffffffc0202b90:	44051e63          	bnez	a0,ffffffffc0202fec <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202b94:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>
ffffffffc0202b98:	4785                	li	a5,1
ffffffffc0202b9a:	42f71963          	bne	a4,a5,ffffffffc0202fcc <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202b9e:	00093503          	ld	a0,0(s2)
ffffffffc0202ba2:	6405                	lui	s0,0x1
ffffffffc0202ba4:	4699                	li	a3,6
ffffffffc0202ba6:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8aa8>
ffffffffc0202baa:	85d2                	mv	a1,s4
ffffffffc0202bac:	a85ff0ef          	jal	ra,ffffffffc0202630 <page_insert>
ffffffffc0202bb0:	72051363          	bnez	a0,ffffffffc02032d6 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202bb4:	000a2703          	lw	a4,0(s4)
ffffffffc0202bb8:	4789                	li	a5,2
ffffffffc0202bba:	6ef71e63          	bne	a4,a5,ffffffffc02032b6 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202bbe:	00004597          	auipc	a1,0x4
ffffffffc0202bc2:	faa58593          	addi	a1,a1,-86 # ffffffffc0206b68 <default_pmm_manager+0x6a8>
ffffffffc0202bc6:	10000513          	li	a0,256
ffffffffc0202bca:	22d020ef          	jal	ra,ffffffffc02055f6 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202bce:	10040593          	addi	a1,s0,256
ffffffffc0202bd2:	10000513          	li	a0,256
ffffffffc0202bd6:	233020ef          	jal	ra,ffffffffc0205608 <strcmp>
ffffffffc0202bda:	6a051e63          	bnez	a0,ffffffffc0203296 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202bde:	000bb683          	ld	a3,0(s7)
ffffffffc0202be2:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202be6:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202be8:	40da06b3          	sub	a3,s4,a3
ffffffffc0202bec:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202bee:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202bf0:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202bf2:	8031                	srli	s0,s0,0xc
ffffffffc0202bf4:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202bf8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202bfa:	30f77d63          	bgeu	a4,a5,ffffffffc0202f14 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202bfe:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c02:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c06:	96be                	add	a3,a3,a5
ffffffffc0202c08:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c0c:	1b5020ef          	jal	ra,ffffffffc02055c0 <strlen>
ffffffffc0202c10:	66051363          	bnez	a0,ffffffffc0203276 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202c14:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c18:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c1a:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd548a4>
ffffffffc0202c1e:	068a                	slli	a3,a3,0x2
ffffffffc0202c20:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c22:	26f6f563          	bgeu	a3,a5,ffffffffc0202e8c <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202c26:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c28:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c2a:	2ef47563          	bgeu	s0,a5,ffffffffc0202f14 <pmm_init+0x7ee>
ffffffffc0202c2e:	0009b403          	ld	s0,0(s3)
ffffffffc0202c32:	9436                	add	s0,s0,a3
ffffffffc0202c34:	100027f3          	csrr	a5,sstatus
ffffffffc0202c38:	8b89                	andi	a5,a5,2
ffffffffc0202c3a:	1e079163          	bnez	a5,ffffffffc0202e1c <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202c3e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c42:	4585                	li	a1,1
ffffffffc0202c44:	8552                	mv	a0,s4
ffffffffc0202c46:	739c                	ld	a5,32(a5)
ffffffffc0202c48:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c4a:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202c4c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c4e:	078a                	slli	a5,a5,0x2
ffffffffc0202c50:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c52:	22e7fd63          	bgeu	a5,a4,ffffffffc0202e8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c56:	000bb503          	ld	a0,0(s7)
ffffffffc0202c5a:	fff80737          	lui	a4,0xfff80
ffffffffc0202c5e:	97ba                	add	a5,a5,a4
ffffffffc0202c60:	079a                	slli	a5,a5,0x6
ffffffffc0202c62:	953e                	add	a0,a0,a5
ffffffffc0202c64:	100027f3          	csrr	a5,sstatus
ffffffffc0202c68:	8b89                	andi	a5,a5,2
ffffffffc0202c6a:	18079d63          	bnez	a5,ffffffffc0202e04 <pmm_init+0x6de>
ffffffffc0202c6e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c72:	4585                	li	a1,1
ffffffffc0202c74:	739c                	ld	a5,32(a5)
ffffffffc0202c76:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c78:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202c7c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c7e:	078a                	slli	a5,a5,0x2
ffffffffc0202c80:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c82:	20e7f563          	bgeu	a5,a4,ffffffffc0202e8c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c86:	000bb503          	ld	a0,0(s7)
ffffffffc0202c8a:	fff80737          	lui	a4,0xfff80
ffffffffc0202c8e:	97ba                	add	a5,a5,a4
ffffffffc0202c90:	079a                	slli	a5,a5,0x6
ffffffffc0202c92:	953e                	add	a0,a0,a5
ffffffffc0202c94:	100027f3          	csrr	a5,sstatus
ffffffffc0202c98:	8b89                	andi	a5,a5,2
ffffffffc0202c9a:	14079963          	bnez	a5,ffffffffc0202dec <pmm_init+0x6c6>
ffffffffc0202c9e:	000b3783          	ld	a5,0(s6)
ffffffffc0202ca2:	4585                	li	a1,1
ffffffffc0202ca4:	739c                	ld	a5,32(a5)
ffffffffc0202ca6:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202ca8:	00093783          	ld	a5,0(s2)
ffffffffc0202cac:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202cb0:	12000073          	sfence.vma
ffffffffc0202cb4:	100027f3          	csrr	a5,sstatus
ffffffffc0202cb8:	8b89                	andi	a5,a5,2
ffffffffc0202cba:	10079f63          	bnez	a5,ffffffffc0202dd8 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202cc2:	779c                	ld	a5,40(a5)
ffffffffc0202cc4:	9782                	jalr	a5
ffffffffc0202cc6:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202cc8:	4c8c1e63          	bne	s8,s0,ffffffffc02031a4 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202ccc:	00004517          	auipc	a0,0x4
ffffffffc0202cd0:	f1450513          	addi	a0,a0,-236 # ffffffffc0206be0 <default_pmm_manager+0x720>
ffffffffc0202cd4:	cc0fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202cd8:	7406                	ld	s0,96(sp)
ffffffffc0202cda:	70a6                	ld	ra,104(sp)
ffffffffc0202cdc:	64e6                	ld	s1,88(sp)
ffffffffc0202cde:	6946                	ld	s2,80(sp)
ffffffffc0202ce0:	69a6                	ld	s3,72(sp)
ffffffffc0202ce2:	6a06                	ld	s4,64(sp)
ffffffffc0202ce4:	7ae2                	ld	s5,56(sp)
ffffffffc0202ce6:	7b42                	ld	s6,48(sp)
ffffffffc0202ce8:	7ba2                	ld	s7,40(sp)
ffffffffc0202cea:	7c02                	ld	s8,32(sp)
ffffffffc0202cec:	6ce2                	ld	s9,24(sp)
ffffffffc0202cee:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202cf0:	f97fe06f          	j	ffffffffc0201c86 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202cf4:	c80007b7          	lui	a5,0xc8000
ffffffffc0202cf8:	bc7d                	j	ffffffffc02027b6 <pmm_init+0x90>
        intr_disable();
ffffffffc0202cfa:	cbbfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202cfe:	000b3783          	ld	a5,0(s6)
ffffffffc0202d02:	4505                	li	a0,1
ffffffffc0202d04:	6f9c                	ld	a5,24(a5)
ffffffffc0202d06:	9782                	jalr	a5
ffffffffc0202d08:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d0a:	ca5fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d0e:	b9a9                	j	ffffffffc0202968 <pmm_init+0x242>
        intr_disable();
ffffffffc0202d10:	ca5fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d14:	000b3783          	ld	a5,0(s6)
ffffffffc0202d18:	4505                	li	a0,1
ffffffffc0202d1a:	6f9c                	ld	a5,24(a5)
ffffffffc0202d1c:	9782                	jalr	a5
ffffffffc0202d1e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d20:	c8ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d24:	b645                	j	ffffffffc02028c4 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202d26:	c8ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d2e:	779c                	ld	a5,40(a5)
ffffffffc0202d30:	9782                	jalr	a5
ffffffffc0202d32:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d34:	c7bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d38:	b6b9                	j	ffffffffc0202886 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202d3a:	6705                	lui	a4,0x1
ffffffffc0202d3c:	177d                	addi	a4,a4,-1
ffffffffc0202d3e:	96ba                	add	a3,a3,a4
ffffffffc0202d40:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202d42:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202d46:	14a77363          	bgeu	a4,a0,ffffffffc0202e8c <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202d4a:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202d4e:	fff80537          	lui	a0,0xfff80
ffffffffc0202d52:	972a                	add	a4,a4,a0
ffffffffc0202d54:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202d56:	8c1d                	sub	s0,s0,a5
ffffffffc0202d58:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202d5c:	00c45593          	srli	a1,s0,0xc
ffffffffc0202d60:	9532                	add	a0,a0,a2
ffffffffc0202d62:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202d64:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202d68:	b4c1                	j	ffffffffc0202828 <pmm_init+0x102>
        intr_disable();
ffffffffc0202d6a:	c4bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d6e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d72:	779c                	ld	a5,40(a5)
ffffffffc0202d74:	9782                	jalr	a5
ffffffffc0202d76:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d78:	c37fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d7c:	bb79                	j	ffffffffc0202b1a <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202d7e:	c37fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d82:	000b3783          	ld	a5,0(s6)
ffffffffc0202d86:	779c                	ld	a5,40(a5)
ffffffffc0202d88:	9782                	jalr	a5
ffffffffc0202d8a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d8c:	c23fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d90:	b39d                	j	ffffffffc0202af6 <pmm_init+0x3d0>
ffffffffc0202d92:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d94:	c21fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202d98:	000b3783          	ld	a5,0(s6)
ffffffffc0202d9c:	6522                	ld	a0,8(sp)
ffffffffc0202d9e:	4585                	li	a1,1
ffffffffc0202da0:	739c                	ld	a5,32(a5)
ffffffffc0202da2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202da4:	c0bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202da8:	b33d                	j	ffffffffc0202ad6 <pmm_init+0x3b0>
ffffffffc0202daa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202dac:	c09fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202db0:	000b3783          	ld	a5,0(s6)
ffffffffc0202db4:	6522                	ld	a0,8(sp)
ffffffffc0202db6:	4585                	li	a1,1
ffffffffc0202db8:	739c                	ld	a5,32(a5)
ffffffffc0202dba:	9782                	jalr	a5
        intr_enable();
ffffffffc0202dbc:	bf3fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dc0:	b1dd                	j	ffffffffc0202aa6 <pmm_init+0x380>
        intr_disable();
ffffffffc0202dc2:	bf3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202dc6:	000b3783          	ld	a5,0(s6)
ffffffffc0202dca:	4505                	li	a0,1
ffffffffc0202dcc:	6f9c                	ld	a5,24(a5)
ffffffffc0202dce:	9782                	jalr	a5
ffffffffc0202dd0:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202dd2:	bddfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dd6:	b36d                	j	ffffffffc0202b80 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202dd8:	bddfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ddc:	000b3783          	ld	a5,0(s6)
ffffffffc0202de0:	779c                	ld	a5,40(a5)
ffffffffc0202de2:	9782                	jalr	a5
ffffffffc0202de4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202de6:	bc9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dea:	bdf9                	j	ffffffffc0202cc8 <pmm_init+0x5a2>
ffffffffc0202dec:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202dee:	bc7fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202df2:	000b3783          	ld	a5,0(s6)
ffffffffc0202df6:	6522                	ld	a0,8(sp)
ffffffffc0202df8:	4585                	li	a1,1
ffffffffc0202dfa:	739c                	ld	a5,32(a5)
ffffffffc0202dfc:	9782                	jalr	a5
        intr_enable();
ffffffffc0202dfe:	bb1fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e02:	b55d                	j	ffffffffc0202ca8 <pmm_init+0x582>
ffffffffc0202e04:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e06:	baffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e0e:	6522                	ld	a0,8(sp)
ffffffffc0202e10:	4585                	li	a1,1
ffffffffc0202e12:	739c                	ld	a5,32(a5)
ffffffffc0202e14:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e16:	b99fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e1a:	bdb9                	j	ffffffffc0202c78 <pmm_init+0x552>
        intr_disable();
ffffffffc0202e1c:	b99fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e20:	000b3783          	ld	a5,0(s6)
ffffffffc0202e24:	4585                	li	a1,1
ffffffffc0202e26:	8552                	mv	a0,s4
ffffffffc0202e28:	739c                	ld	a5,32(a5)
ffffffffc0202e2a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e2c:	b83fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e30:	bd29                	j	ffffffffc0202c4a <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e32:	86a2                	mv	a3,s0
ffffffffc0202e34:	00003617          	auipc	a2,0x3
ffffffffc0202e38:	6c460613          	addi	a2,a2,1732 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0202e3c:	25400593          	li	a1,596
ffffffffc0202e40:	00003517          	auipc	a0,0x3
ffffffffc0202e44:	7d050513          	addi	a0,a0,2000 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202e48:	e46fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202e4c:	00004697          	auipc	a3,0x4
ffffffffc0202e50:	c3468693          	addi	a3,a3,-972 # ffffffffc0206a80 <default_pmm_manager+0x5c0>
ffffffffc0202e54:	00003617          	auipc	a2,0x3
ffffffffc0202e58:	2bc60613          	addi	a2,a2,700 # ffffffffc0206110 <commands+0x818>
ffffffffc0202e5c:	25500593          	li	a1,597
ffffffffc0202e60:	00003517          	auipc	a0,0x3
ffffffffc0202e64:	7b050513          	addi	a0,a0,1968 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202e68:	e26fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e6c:	00004697          	auipc	a3,0x4
ffffffffc0202e70:	bd468693          	addi	a3,a3,-1068 # ffffffffc0206a40 <default_pmm_manager+0x580>
ffffffffc0202e74:	00003617          	auipc	a2,0x3
ffffffffc0202e78:	29c60613          	addi	a2,a2,668 # ffffffffc0206110 <commands+0x818>
ffffffffc0202e7c:	25400593          	li	a1,596
ffffffffc0202e80:	00003517          	auipc	a0,0x3
ffffffffc0202e84:	79050513          	addi	a0,a0,1936 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202e88:	e06fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202e8c:	fc5fe0ef          	jal	ra,ffffffffc0201e50 <pa2page.part.0>
ffffffffc0202e90:	fddfe0ef          	jal	ra,ffffffffc0201e6c <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202e94:	00004697          	auipc	a3,0x4
ffffffffc0202e98:	9a468693          	addi	a3,a3,-1628 # ffffffffc0206838 <default_pmm_manager+0x378>
ffffffffc0202e9c:	00003617          	auipc	a2,0x3
ffffffffc0202ea0:	27460613          	addi	a2,a2,628 # ffffffffc0206110 <commands+0x818>
ffffffffc0202ea4:	22400593          	li	a1,548
ffffffffc0202ea8:	00003517          	auipc	a0,0x3
ffffffffc0202eac:	76850513          	addi	a0,a0,1896 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202eb0:	ddefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202eb4:	00004697          	auipc	a3,0x4
ffffffffc0202eb8:	8c468693          	addi	a3,a3,-1852 # ffffffffc0206778 <default_pmm_manager+0x2b8>
ffffffffc0202ebc:	00003617          	auipc	a2,0x3
ffffffffc0202ec0:	25460613          	addi	a2,a2,596 # ffffffffc0206110 <commands+0x818>
ffffffffc0202ec4:	21700593          	li	a1,535
ffffffffc0202ec8:	00003517          	auipc	a0,0x3
ffffffffc0202ecc:	74850513          	addi	a0,a0,1864 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202ed0:	dbefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202ed4:	00004697          	auipc	a3,0x4
ffffffffc0202ed8:	86468693          	addi	a3,a3,-1948 # ffffffffc0206738 <default_pmm_manager+0x278>
ffffffffc0202edc:	00003617          	auipc	a2,0x3
ffffffffc0202ee0:	23460613          	addi	a2,a2,564 # ffffffffc0206110 <commands+0x818>
ffffffffc0202ee4:	21600593          	li	a1,534
ffffffffc0202ee8:	00003517          	auipc	a0,0x3
ffffffffc0202eec:	72850513          	addi	a0,a0,1832 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202ef0:	d9efd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202ef4:	00004697          	auipc	a3,0x4
ffffffffc0202ef8:	82468693          	addi	a3,a3,-2012 # ffffffffc0206718 <default_pmm_manager+0x258>
ffffffffc0202efc:	00003617          	auipc	a2,0x3
ffffffffc0202f00:	21460613          	addi	a2,a2,532 # ffffffffc0206110 <commands+0x818>
ffffffffc0202f04:	21500593          	li	a1,533
ffffffffc0202f08:	00003517          	auipc	a0,0x3
ffffffffc0202f0c:	70850513          	addi	a0,a0,1800 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202f10:	d7efd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f14:	00003617          	auipc	a2,0x3
ffffffffc0202f18:	5e460613          	addi	a2,a2,1508 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0202f1c:	07100593          	li	a1,113
ffffffffc0202f20:	00003517          	auipc	a0,0x3
ffffffffc0202f24:	60050513          	addi	a0,a0,1536 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0202f28:	d66fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202f2c:	00004697          	auipc	a3,0x4
ffffffffc0202f30:	a9c68693          	addi	a3,a3,-1380 # ffffffffc02069c8 <default_pmm_manager+0x508>
ffffffffc0202f34:	00003617          	auipc	a2,0x3
ffffffffc0202f38:	1dc60613          	addi	a2,a2,476 # ffffffffc0206110 <commands+0x818>
ffffffffc0202f3c:	23d00593          	li	a1,573
ffffffffc0202f40:	00003517          	auipc	a0,0x3
ffffffffc0202f44:	6d050513          	addi	a0,a0,1744 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202f48:	d46fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f4c:	00004697          	auipc	a3,0x4
ffffffffc0202f50:	a3468693          	addi	a3,a3,-1484 # ffffffffc0206980 <default_pmm_manager+0x4c0>
ffffffffc0202f54:	00003617          	auipc	a2,0x3
ffffffffc0202f58:	1bc60613          	addi	a2,a2,444 # ffffffffc0206110 <commands+0x818>
ffffffffc0202f5c:	23b00593          	li	a1,571
ffffffffc0202f60:	00003517          	auipc	a0,0x3
ffffffffc0202f64:	6b050513          	addi	a0,a0,1712 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202f68:	d26fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202f6c:	00004697          	auipc	a3,0x4
ffffffffc0202f70:	a4468693          	addi	a3,a3,-1468 # ffffffffc02069b0 <default_pmm_manager+0x4f0>
ffffffffc0202f74:	00003617          	auipc	a2,0x3
ffffffffc0202f78:	19c60613          	addi	a2,a2,412 # ffffffffc0206110 <commands+0x818>
ffffffffc0202f7c:	23a00593          	li	a1,570
ffffffffc0202f80:	00003517          	auipc	a0,0x3
ffffffffc0202f84:	69050513          	addi	a0,a0,1680 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202f88:	d06fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202f8c:	00004697          	auipc	a3,0x4
ffffffffc0202f90:	b0c68693          	addi	a3,a3,-1268 # ffffffffc0206a98 <default_pmm_manager+0x5d8>
ffffffffc0202f94:	00003617          	auipc	a2,0x3
ffffffffc0202f98:	17c60613          	addi	a2,a2,380 # ffffffffc0206110 <commands+0x818>
ffffffffc0202f9c:	25800593          	li	a1,600
ffffffffc0202fa0:	00003517          	auipc	a0,0x3
ffffffffc0202fa4:	67050513          	addi	a0,a0,1648 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202fa8:	ce6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202fac:	00004697          	auipc	a3,0x4
ffffffffc0202fb0:	a4c68693          	addi	a3,a3,-1460 # ffffffffc02069f8 <default_pmm_manager+0x538>
ffffffffc0202fb4:	00003617          	auipc	a2,0x3
ffffffffc0202fb8:	15c60613          	addi	a2,a2,348 # ffffffffc0206110 <commands+0x818>
ffffffffc0202fbc:	24500593          	li	a1,581
ffffffffc0202fc0:	00003517          	auipc	a0,0x3
ffffffffc0202fc4:	65050513          	addi	a0,a0,1616 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202fc8:	cc6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202fcc:	00004697          	auipc	a3,0x4
ffffffffc0202fd0:	b2468693          	addi	a3,a3,-1244 # ffffffffc0206af0 <default_pmm_manager+0x630>
ffffffffc0202fd4:	00003617          	auipc	a2,0x3
ffffffffc0202fd8:	13c60613          	addi	a2,a2,316 # ffffffffc0206110 <commands+0x818>
ffffffffc0202fdc:	25d00593          	li	a1,605
ffffffffc0202fe0:	00003517          	auipc	a0,0x3
ffffffffc0202fe4:	63050513          	addi	a0,a0,1584 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0202fe8:	ca6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202fec:	00004697          	auipc	a3,0x4
ffffffffc0202ff0:	ac468693          	addi	a3,a3,-1340 # ffffffffc0206ab0 <default_pmm_manager+0x5f0>
ffffffffc0202ff4:	00003617          	auipc	a2,0x3
ffffffffc0202ff8:	11c60613          	addi	a2,a2,284 # ffffffffc0206110 <commands+0x818>
ffffffffc0202ffc:	25c00593          	li	a1,604
ffffffffc0203000:	00003517          	auipc	a0,0x3
ffffffffc0203004:	61050513          	addi	a0,a0,1552 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203008:	c86fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020300c:	00004697          	auipc	a3,0x4
ffffffffc0203010:	97468693          	addi	a3,a3,-1676 # ffffffffc0206980 <default_pmm_manager+0x4c0>
ffffffffc0203014:	00003617          	auipc	a2,0x3
ffffffffc0203018:	0fc60613          	addi	a2,a2,252 # ffffffffc0206110 <commands+0x818>
ffffffffc020301c:	23700593          	li	a1,567
ffffffffc0203020:	00003517          	auipc	a0,0x3
ffffffffc0203024:	5f050513          	addi	a0,a0,1520 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203028:	c66fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020302c:	00003697          	auipc	a3,0x3
ffffffffc0203030:	7f468693          	addi	a3,a3,2036 # ffffffffc0206820 <default_pmm_manager+0x360>
ffffffffc0203034:	00003617          	auipc	a2,0x3
ffffffffc0203038:	0dc60613          	addi	a2,a2,220 # ffffffffc0206110 <commands+0x818>
ffffffffc020303c:	23600593          	li	a1,566
ffffffffc0203040:	00003517          	auipc	a0,0x3
ffffffffc0203044:	5d050513          	addi	a0,a0,1488 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203048:	c46fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc020304c:	00004697          	auipc	a3,0x4
ffffffffc0203050:	94c68693          	addi	a3,a3,-1716 # ffffffffc0206998 <default_pmm_manager+0x4d8>
ffffffffc0203054:	00003617          	auipc	a2,0x3
ffffffffc0203058:	0bc60613          	addi	a2,a2,188 # ffffffffc0206110 <commands+0x818>
ffffffffc020305c:	23300593          	li	a1,563
ffffffffc0203060:	00003517          	auipc	a0,0x3
ffffffffc0203064:	5b050513          	addi	a0,a0,1456 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203068:	c26fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020306c:	00003697          	auipc	a3,0x3
ffffffffc0203070:	79c68693          	addi	a3,a3,1948 # ffffffffc0206808 <default_pmm_manager+0x348>
ffffffffc0203074:	00003617          	auipc	a2,0x3
ffffffffc0203078:	09c60613          	addi	a2,a2,156 # ffffffffc0206110 <commands+0x818>
ffffffffc020307c:	23200593          	li	a1,562
ffffffffc0203080:	00003517          	auipc	a0,0x3
ffffffffc0203084:	59050513          	addi	a0,a0,1424 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203088:	c06fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020308c:	00004697          	auipc	a3,0x4
ffffffffc0203090:	81c68693          	addi	a3,a3,-2020 # ffffffffc02068a8 <default_pmm_manager+0x3e8>
ffffffffc0203094:	00003617          	auipc	a2,0x3
ffffffffc0203098:	07c60613          	addi	a2,a2,124 # ffffffffc0206110 <commands+0x818>
ffffffffc020309c:	23100593          	li	a1,561
ffffffffc02030a0:	00003517          	auipc	a0,0x3
ffffffffc02030a4:	57050513          	addi	a0,a0,1392 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02030a8:	be6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030ac:	00004697          	auipc	a3,0x4
ffffffffc02030b0:	8d468693          	addi	a3,a3,-1836 # ffffffffc0206980 <default_pmm_manager+0x4c0>
ffffffffc02030b4:	00003617          	auipc	a2,0x3
ffffffffc02030b8:	05c60613          	addi	a2,a2,92 # ffffffffc0206110 <commands+0x818>
ffffffffc02030bc:	23000593          	li	a1,560
ffffffffc02030c0:	00003517          	auipc	a0,0x3
ffffffffc02030c4:	55050513          	addi	a0,a0,1360 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02030c8:	bc6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02030cc:	00004697          	auipc	a3,0x4
ffffffffc02030d0:	89c68693          	addi	a3,a3,-1892 # ffffffffc0206968 <default_pmm_manager+0x4a8>
ffffffffc02030d4:	00003617          	auipc	a2,0x3
ffffffffc02030d8:	03c60613          	addi	a2,a2,60 # ffffffffc0206110 <commands+0x818>
ffffffffc02030dc:	22f00593          	li	a1,559
ffffffffc02030e0:	00003517          	auipc	a0,0x3
ffffffffc02030e4:	53050513          	addi	a0,a0,1328 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02030e8:	ba6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02030ec:	00004697          	auipc	a3,0x4
ffffffffc02030f0:	84c68693          	addi	a3,a3,-1972 # ffffffffc0206938 <default_pmm_manager+0x478>
ffffffffc02030f4:	00003617          	auipc	a2,0x3
ffffffffc02030f8:	01c60613          	addi	a2,a2,28 # ffffffffc0206110 <commands+0x818>
ffffffffc02030fc:	22e00593          	li	a1,558
ffffffffc0203100:	00003517          	auipc	a0,0x3
ffffffffc0203104:	51050513          	addi	a0,a0,1296 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203108:	b86fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020310c:	00004697          	auipc	a3,0x4
ffffffffc0203110:	81468693          	addi	a3,a3,-2028 # ffffffffc0206920 <default_pmm_manager+0x460>
ffffffffc0203114:	00003617          	auipc	a2,0x3
ffffffffc0203118:	ffc60613          	addi	a2,a2,-4 # ffffffffc0206110 <commands+0x818>
ffffffffc020311c:	22c00593          	li	a1,556
ffffffffc0203120:	00003517          	auipc	a0,0x3
ffffffffc0203124:	4f050513          	addi	a0,a0,1264 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203128:	b66fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020312c:	00003697          	auipc	a3,0x3
ffffffffc0203130:	7d468693          	addi	a3,a3,2004 # ffffffffc0206900 <default_pmm_manager+0x440>
ffffffffc0203134:	00003617          	auipc	a2,0x3
ffffffffc0203138:	fdc60613          	addi	a2,a2,-36 # ffffffffc0206110 <commands+0x818>
ffffffffc020313c:	22b00593          	li	a1,555
ffffffffc0203140:	00003517          	auipc	a0,0x3
ffffffffc0203144:	4d050513          	addi	a0,a0,1232 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203148:	b46fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc020314c:	00003697          	auipc	a3,0x3
ffffffffc0203150:	7a468693          	addi	a3,a3,1956 # ffffffffc02068f0 <default_pmm_manager+0x430>
ffffffffc0203154:	00003617          	auipc	a2,0x3
ffffffffc0203158:	fbc60613          	addi	a2,a2,-68 # ffffffffc0206110 <commands+0x818>
ffffffffc020315c:	22a00593          	li	a1,554
ffffffffc0203160:	00003517          	auipc	a0,0x3
ffffffffc0203164:	4b050513          	addi	a0,a0,1200 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203168:	b26fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc020316c:	00003697          	auipc	a3,0x3
ffffffffc0203170:	77468693          	addi	a3,a3,1908 # ffffffffc02068e0 <default_pmm_manager+0x420>
ffffffffc0203174:	00003617          	auipc	a2,0x3
ffffffffc0203178:	f9c60613          	addi	a2,a2,-100 # ffffffffc0206110 <commands+0x818>
ffffffffc020317c:	22900593          	li	a1,553
ffffffffc0203180:	00003517          	auipc	a0,0x3
ffffffffc0203184:	49050513          	addi	a0,a0,1168 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203188:	b06fd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc020318c:	00003617          	auipc	a2,0x3
ffffffffc0203190:	4f460613          	addi	a2,a2,1268 # ffffffffc0206680 <default_pmm_manager+0x1c0>
ffffffffc0203194:	06500593          	li	a1,101
ffffffffc0203198:	00003517          	auipc	a0,0x3
ffffffffc020319c:	47850513          	addi	a0,a0,1144 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02031a0:	aeefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02031a4:	00004697          	auipc	a3,0x4
ffffffffc02031a8:	85468693          	addi	a3,a3,-1964 # ffffffffc02069f8 <default_pmm_manager+0x538>
ffffffffc02031ac:	00003617          	auipc	a2,0x3
ffffffffc02031b0:	f6460613          	addi	a2,a2,-156 # ffffffffc0206110 <commands+0x818>
ffffffffc02031b4:	26f00593          	li	a1,623
ffffffffc02031b8:	00003517          	auipc	a0,0x3
ffffffffc02031bc:	45850513          	addi	a0,a0,1112 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02031c0:	acefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02031c4:	00003697          	auipc	a3,0x3
ffffffffc02031c8:	6e468693          	addi	a3,a3,1764 # ffffffffc02068a8 <default_pmm_manager+0x3e8>
ffffffffc02031cc:	00003617          	auipc	a2,0x3
ffffffffc02031d0:	f4460613          	addi	a2,a2,-188 # ffffffffc0206110 <commands+0x818>
ffffffffc02031d4:	22800593          	li	a1,552
ffffffffc02031d8:	00003517          	auipc	a0,0x3
ffffffffc02031dc:	43850513          	addi	a0,a0,1080 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02031e0:	aaefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02031e4:	00003697          	auipc	a3,0x3
ffffffffc02031e8:	68468693          	addi	a3,a3,1668 # ffffffffc0206868 <default_pmm_manager+0x3a8>
ffffffffc02031ec:	00003617          	auipc	a2,0x3
ffffffffc02031f0:	f2460613          	addi	a2,a2,-220 # ffffffffc0206110 <commands+0x818>
ffffffffc02031f4:	22700593          	li	a1,551
ffffffffc02031f8:	00003517          	auipc	a0,0x3
ffffffffc02031fc:	41850513          	addi	a0,a0,1048 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203200:	a8efd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203204:	86d6                	mv	a3,s5
ffffffffc0203206:	00003617          	auipc	a2,0x3
ffffffffc020320a:	2f260613          	addi	a2,a2,754 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc020320e:	22300593          	li	a1,547
ffffffffc0203212:	00003517          	auipc	a0,0x3
ffffffffc0203216:	3fe50513          	addi	a0,a0,1022 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc020321a:	a74fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020321e:	00003617          	auipc	a2,0x3
ffffffffc0203222:	2da60613          	addi	a2,a2,730 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0203226:	22200593          	li	a1,546
ffffffffc020322a:	00003517          	auipc	a0,0x3
ffffffffc020322e:	3e650513          	addi	a0,a0,998 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203232:	a5cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203236:	00003697          	auipc	a3,0x3
ffffffffc020323a:	5ea68693          	addi	a3,a3,1514 # ffffffffc0206820 <default_pmm_manager+0x360>
ffffffffc020323e:	00003617          	auipc	a2,0x3
ffffffffc0203242:	ed260613          	addi	a2,a2,-302 # ffffffffc0206110 <commands+0x818>
ffffffffc0203246:	22000593          	li	a1,544
ffffffffc020324a:	00003517          	auipc	a0,0x3
ffffffffc020324e:	3c650513          	addi	a0,a0,966 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203252:	a3cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203256:	00003697          	auipc	a3,0x3
ffffffffc020325a:	5b268693          	addi	a3,a3,1458 # ffffffffc0206808 <default_pmm_manager+0x348>
ffffffffc020325e:	00003617          	auipc	a2,0x3
ffffffffc0203262:	eb260613          	addi	a2,a2,-334 # ffffffffc0206110 <commands+0x818>
ffffffffc0203266:	21f00593          	li	a1,543
ffffffffc020326a:	00003517          	auipc	a0,0x3
ffffffffc020326e:	3a650513          	addi	a0,a0,934 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203272:	a1cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203276:	00004697          	auipc	a3,0x4
ffffffffc020327a:	94268693          	addi	a3,a3,-1726 # ffffffffc0206bb8 <default_pmm_manager+0x6f8>
ffffffffc020327e:	00003617          	auipc	a2,0x3
ffffffffc0203282:	e9260613          	addi	a2,a2,-366 # ffffffffc0206110 <commands+0x818>
ffffffffc0203286:	26600593          	li	a1,614
ffffffffc020328a:	00003517          	auipc	a0,0x3
ffffffffc020328e:	38650513          	addi	a0,a0,902 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203292:	9fcfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203296:	00004697          	auipc	a3,0x4
ffffffffc020329a:	8ea68693          	addi	a3,a3,-1814 # ffffffffc0206b80 <default_pmm_manager+0x6c0>
ffffffffc020329e:	00003617          	auipc	a2,0x3
ffffffffc02032a2:	e7260613          	addi	a2,a2,-398 # ffffffffc0206110 <commands+0x818>
ffffffffc02032a6:	26300593          	li	a1,611
ffffffffc02032aa:	00003517          	auipc	a0,0x3
ffffffffc02032ae:	36650513          	addi	a0,a0,870 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02032b2:	9dcfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc02032b6:	00004697          	auipc	a3,0x4
ffffffffc02032ba:	89a68693          	addi	a3,a3,-1894 # ffffffffc0206b50 <default_pmm_manager+0x690>
ffffffffc02032be:	00003617          	auipc	a2,0x3
ffffffffc02032c2:	e5260613          	addi	a2,a2,-430 # ffffffffc0206110 <commands+0x818>
ffffffffc02032c6:	25f00593          	li	a1,607
ffffffffc02032ca:	00003517          	auipc	a0,0x3
ffffffffc02032ce:	34650513          	addi	a0,a0,838 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02032d2:	9bcfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02032d6:	00004697          	auipc	a3,0x4
ffffffffc02032da:	83268693          	addi	a3,a3,-1998 # ffffffffc0206b08 <default_pmm_manager+0x648>
ffffffffc02032de:	00003617          	auipc	a2,0x3
ffffffffc02032e2:	e3260613          	addi	a2,a2,-462 # ffffffffc0206110 <commands+0x818>
ffffffffc02032e6:	25e00593          	li	a1,606
ffffffffc02032ea:	00003517          	auipc	a0,0x3
ffffffffc02032ee:	32650513          	addi	a0,a0,806 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02032f2:	99cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02032f6:	00003617          	auipc	a2,0x3
ffffffffc02032fa:	2aa60613          	addi	a2,a2,682 # ffffffffc02065a0 <default_pmm_manager+0xe0>
ffffffffc02032fe:	0c900593          	li	a1,201
ffffffffc0203302:	00003517          	auipc	a0,0x3
ffffffffc0203306:	30e50513          	addi	a0,a0,782 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc020330a:	984fd0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020330e:	00003617          	auipc	a2,0x3
ffffffffc0203312:	29260613          	addi	a2,a2,658 # ffffffffc02065a0 <default_pmm_manager+0xe0>
ffffffffc0203316:	08100593          	li	a1,129
ffffffffc020331a:	00003517          	auipc	a0,0x3
ffffffffc020331e:	2f650513          	addi	a0,a0,758 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203322:	96cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203326:	00003697          	auipc	a3,0x3
ffffffffc020332a:	4b268693          	addi	a3,a3,1202 # ffffffffc02067d8 <default_pmm_manager+0x318>
ffffffffc020332e:	00003617          	auipc	a2,0x3
ffffffffc0203332:	de260613          	addi	a2,a2,-542 # ffffffffc0206110 <commands+0x818>
ffffffffc0203336:	21e00593          	li	a1,542
ffffffffc020333a:	00003517          	auipc	a0,0x3
ffffffffc020333e:	2d650513          	addi	a0,a0,726 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203342:	94cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203346:	00003697          	auipc	a3,0x3
ffffffffc020334a:	46268693          	addi	a3,a3,1122 # ffffffffc02067a8 <default_pmm_manager+0x2e8>
ffffffffc020334e:	00003617          	auipc	a2,0x3
ffffffffc0203352:	dc260613          	addi	a2,a2,-574 # ffffffffc0206110 <commands+0x818>
ffffffffc0203356:	21b00593          	li	a1,539
ffffffffc020335a:	00003517          	auipc	a0,0x3
ffffffffc020335e:	2b650513          	addi	a0,a0,694 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203362:	92cfd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203366 <copy_range>:
{
ffffffffc0203366:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203368:	00d667b3          	or	a5,a2,a3
{
ffffffffc020336c:	f486                	sd	ra,104(sp)
ffffffffc020336e:	f0a2                	sd	s0,96(sp)
ffffffffc0203370:	eca6                	sd	s1,88(sp)
ffffffffc0203372:	e8ca                	sd	s2,80(sp)
ffffffffc0203374:	e4ce                	sd	s3,72(sp)
ffffffffc0203376:	e0d2                	sd	s4,64(sp)
ffffffffc0203378:	fc56                	sd	s5,56(sp)
ffffffffc020337a:	f85a                	sd	s6,48(sp)
ffffffffc020337c:	f45e                	sd	s7,40(sp)
ffffffffc020337e:	f062                	sd	s8,32(sp)
ffffffffc0203380:	ec66                	sd	s9,24(sp)
ffffffffc0203382:	e86a                	sd	s10,16(sp)
ffffffffc0203384:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203386:	17d2                	slli	a5,a5,0x34
ffffffffc0203388:	20079f63          	bnez	a5,ffffffffc02035a6 <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc020338c:	002007b7          	lui	a5,0x200
ffffffffc0203390:	8432                	mv	s0,a2
ffffffffc0203392:	1af66263          	bltu	a2,a5,ffffffffc0203536 <copy_range+0x1d0>
ffffffffc0203396:	8936                	mv	s2,a3
ffffffffc0203398:	18d67f63          	bgeu	a2,a3,ffffffffc0203536 <copy_range+0x1d0>
ffffffffc020339c:	4785                	li	a5,1
ffffffffc020339e:	07fe                	slli	a5,a5,0x1f
ffffffffc02033a0:	18d7eb63          	bltu	a5,a3,ffffffffc0203536 <copy_range+0x1d0>
ffffffffc02033a4:	5b7d                	li	s6,-1
ffffffffc02033a6:	8aaa                	mv	s5,a0
ffffffffc02033a8:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc02033aa:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02033ac:	000a7c17          	auipc	s8,0xa7
ffffffffc02033b0:	374c0c13          	addi	s8,s8,884 # ffffffffc02aa720 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02033b4:	000a7b97          	auipc	s7,0xa7
ffffffffc02033b8:	374b8b93          	addi	s7,s7,884 # ffffffffc02aa728 <pages>
    return KADDR(page2pa(page));
ffffffffc02033bc:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc02033c0:	000a7c97          	auipc	s9,0xa7
ffffffffc02033c4:	370c8c93          	addi	s9,s9,880 # ffffffffc02aa730 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02033c8:	4601                	li	a2,0
ffffffffc02033ca:	85a2                	mv	a1,s0
ffffffffc02033cc:	854e                	mv	a0,s3
ffffffffc02033ce:	b73fe0ef          	jal	ra,ffffffffc0201f40 <get_pte>
ffffffffc02033d2:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02033d4:	0e050c63          	beqz	a0,ffffffffc02034cc <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc02033d8:	611c                	ld	a5,0(a0)
ffffffffc02033da:	8b85                	andi	a5,a5,1
ffffffffc02033dc:	e785                	bnez	a5,ffffffffc0203404 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc02033de:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02033e0:	ff2464e3          	bltu	s0,s2,ffffffffc02033c8 <copy_range+0x62>
    return 0;
ffffffffc02033e4:	4501                	li	a0,0
}
ffffffffc02033e6:	70a6                	ld	ra,104(sp)
ffffffffc02033e8:	7406                	ld	s0,96(sp)
ffffffffc02033ea:	64e6                	ld	s1,88(sp)
ffffffffc02033ec:	6946                	ld	s2,80(sp)
ffffffffc02033ee:	69a6                	ld	s3,72(sp)
ffffffffc02033f0:	6a06                	ld	s4,64(sp)
ffffffffc02033f2:	7ae2                	ld	s5,56(sp)
ffffffffc02033f4:	7b42                	ld	s6,48(sp)
ffffffffc02033f6:	7ba2                	ld	s7,40(sp)
ffffffffc02033f8:	7c02                	ld	s8,32(sp)
ffffffffc02033fa:	6ce2                	ld	s9,24(sp)
ffffffffc02033fc:	6d42                	ld	s10,16(sp)
ffffffffc02033fe:	6da2                	ld	s11,8(sp)
ffffffffc0203400:	6165                	addi	sp,sp,112
ffffffffc0203402:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203404:	4605                	li	a2,1
ffffffffc0203406:	85a2                	mv	a1,s0
ffffffffc0203408:	8556                	mv	a0,s5
ffffffffc020340a:	b37fe0ef          	jal	ra,ffffffffc0201f40 <get_pte>
ffffffffc020340e:	c56d                	beqz	a0,ffffffffc02034f8 <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203410:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc0203412:	0017f713          	andi	a4,a5,1
ffffffffc0203416:	01f7f493          	andi	s1,a5,31
ffffffffc020341a:	16070a63          	beqz	a4,ffffffffc020358e <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc020341e:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203422:	078a                	slli	a5,a5,0x2
ffffffffc0203424:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203428:	14d77763          	bgeu	a4,a3,ffffffffc0203576 <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc020342c:	000bb783          	ld	a5,0(s7)
ffffffffc0203430:	fff806b7          	lui	a3,0xfff80
ffffffffc0203434:	9736                	add	a4,a4,a3
ffffffffc0203436:	071a                	slli	a4,a4,0x6
ffffffffc0203438:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020343c:	10002773          	csrr	a4,sstatus
ffffffffc0203440:	8b09                	andi	a4,a4,2
ffffffffc0203442:	e345                	bnez	a4,ffffffffc02034e2 <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203444:	000cb703          	ld	a4,0(s9)
ffffffffc0203448:	4505                	li	a0,1
ffffffffc020344a:	6f18                	ld	a4,24(a4)
ffffffffc020344c:	9702                	jalr	a4
ffffffffc020344e:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0203450:	0c0d8363          	beqz	s11,ffffffffc0203516 <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203454:	100d0163          	beqz	s10,ffffffffc0203556 <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc0203458:	000bb703          	ld	a4,0(s7)
ffffffffc020345c:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc0203460:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203464:	40ed86b3          	sub	a3,s11,a4
ffffffffc0203468:	8699                	srai	a3,a3,0x6
ffffffffc020346a:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc020346c:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203470:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203472:	08c7f663          	bgeu	a5,a2,ffffffffc02034fe <copy_range+0x198>
    return page - pages + nbase;
ffffffffc0203476:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc020347a:	000a7717          	auipc	a4,0xa7
ffffffffc020347e:	2be70713          	addi	a4,a4,702 # ffffffffc02aa738 <va_pa_offset>
ffffffffc0203482:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0203484:	8799                	srai	a5,a5,0x6
ffffffffc0203486:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc0203488:	0167f733          	and	a4,a5,s6
ffffffffc020348c:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203490:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203492:	06c77563          	bgeu	a4,a2,ffffffffc02034fc <copy_range+0x196>
            memcpy((void *)dst_kvaddr, (void *)src_kvaddr, PGSIZE);
ffffffffc0203496:	6605                	lui	a2,0x1
ffffffffc0203498:	953e                	add	a0,a0,a5
ffffffffc020349a:	1da020ef          	jal	ra,ffffffffc0205674 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc020349e:	86a6                	mv	a3,s1
ffffffffc02034a0:	8622                	mv	a2,s0
ffffffffc02034a2:	85ea                	mv	a1,s10
ffffffffc02034a4:	8556                	mv	a0,s5
ffffffffc02034a6:	98aff0ef          	jal	ra,ffffffffc0202630 <page_insert>
            assert(ret == 0);
ffffffffc02034aa:	d915                	beqz	a0,ffffffffc02033de <copy_range+0x78>
ffffffffc02034ac:	00003697          	auipc	a3,0x3
ffffffffc02034b0:	77468693          	addi	a3,a3,1908 # ffffffffc0206c20 <default_pmm_manager+0x760>
ffffffffc02034b4:	00003617          	auipc	a2,0x3
ffffffffc02034b8:	c5c60613          	addi	a2,a2,-932 # ffffffffc0206110 <commands+0x818>
ffffffffc02034bc:	1b300593          	li	a1,435
ffffffffc02034c0:	00003517          	auipc	a0,0x3
ffffffffc02034c4:	15050513          	addi	a0,a0,336 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02034c8:	fc7fc0ef          	jal	ra,ffffffffc020048e <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02034cc:	00200637          	lui	a2,0x200
ffffffffc02034d0:	9432                	add	s0,s0,a2
ffffffffc02034d2:	ffe00637          	lui	a2,0xffe00
ffffffffc02034d6:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc02034d8:	f00406e3          	beqz	s0,ffffffffc02033e4 <copy_range+0x7e>
ffffffffc02034dc:	ef2466e3          	bltu	s0,s2,ffffffffc02033c8 <copy_range+0x62>
ffffffffc02034e0:	b711                	j	ffffffffc02033e4 <copy_range+0x7e>
        intr_disable();
ffffffffc02034e2:	cd2fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02034e6:	000cb703          	ld	a4,0(s9)
ffffffffc02034ea:	4505                	li	a0,1
ffffffffc02034ec:	6f18                	ld	a4,24(a4)
ffffffffc02034ee:	9702                	jalr	a4
ffffffffc02034f0:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc02034f2:	cbcfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02034f6:	bfa9                	j	ffffffffc0203450 <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc02034f8:	5571                	li	a0,-4
ffffffffc02034fa:	b5f5                	j	ffffffffc02033e6 <copy_range+0x80>
ffffffffc02034fc:	86be                	mv	a3,a5
ffffffffc02034fe:	00003617          	auipc	a2,0x3
ffffffffc0203502:	ffa60613          	addi	a2,a2,-6 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0203506:	07100593          	li	a1,113
ffffffffc020350a:	00003517          	auipc	a0,0x3
ffffffffc020350e:	01650513          	addi	a0,a0,22 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0203512:	f7dfc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc0203516:	00003697          	auipc	a3,0x3
ffffffffc020351a:	6ea68693          	addi	a3,a3,1770 # ffffffffc0206c00 <default_pmm_manager+0x740>
ffffffffc020351e:	00003617          	auipc	a2,0x3
ffffffffc0203522:	bf260613          	addi	a2,a2,-1038 # ffffffffc0206110 <commands+0x818>
ffffffffc0203526:	19400593          	li	a1,404
ffffffffc020352a:	00003517          	auipc	a0,0x3
ffffffffc020352e:	0e650513          	addi	a0,a0,230 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203532:	f5dfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203536:	00003697          	auipc	a3,0x3
ffffffffc020353a:	11a68693          	addi	a3,a3,282 # ffffffffc0206650 <default_pmm_manager+0x190>
ffffffffc020353e:	00003617          	auipc	a2,0x3
ffffffffc0203542:	bd260613          	addi	a2,a2,-1070 # ffffffffc0206110 <commands+0x818>
ffffffffc0203546:	17c00593          	li	a1,380
ffffffffc020354a:	00003517          	auipc	a0,0x3
ffffffffc020354e:	0c650513          	addi	a0,a0,198 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203552:	f3dfc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(npage != NULL);
ffffffffc0203556:	00003697          	auipc	a3,0x3
ffffffffc020355a:	6ba68693          	addi	a3,a3,1722 # ffffffffc0206c10 <default_pmm_manager+0x750>
ffffffffc020355e:	00003617          	auipc	a2,0x3
ffffffffc0203562:	bb260613          	addi	a2,a2,-1102 # ffffffffc0206110 <commands+0x818>
ffffffffc0203566:	19500593          	li	a1,405
ffffffffc020356a:	00003517          	auipc	a0,0x3
ffffffffc020356e:	0a650513          	addi	a0,a0,166 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203572:	f1dfc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203576:	00003617          	auipc	a2,0x3
ffffffffc020357a:	05260613          	addi	a2,a2,82 # ffffffffc02065c8 <default_pmm_manager+0x108>
ffffffffc020357e:	06900593          	li	a1,105
ffffffffc0203582:	00003517          	auipc	a0,0x3
ffffffffc0203586:	f9e50513          	addi	a0,a0,-98 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc020358a:	f05fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc020358e:	00003617          	auipc	a2,0x3
ffffffffc0203592:	05a60613          	addi	a2,a2,90 # ffffffffc02065e8 <default_pmm_manager+0x128>
ffffffffc0203596:	07f00593          	li	a1,127
ffffffffc020359a:	00003517          	auipc	a0,0x3
ffffffffc020359e:	f8650513          	addi	a0,a0,-122 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc02035a2:	eedfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02035a6:	00003697          	auipc	a3,0x3
ffffffffc02035aa:	07a68693          	addi	a3,a3,122 # ffffffffc0206620 <default_pmm_manager+0x160>
ffffffffc02035ae:	00003617          	auipc	a2,0x3
ffffffffc02035b2:	b6260613          	addi	a2,a2,-1182 # ffffffffc0206110 <commands+0x818>
ffffffffc02035b6:	17b00593          	li	a1,379
ffffffffc02035ba:	00003517          	auipc	a0,0x3
ffffffffc02035be:	05650513          	addi	a0,a0,86 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc02035c2:	ecdfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02035c6 <pgdir_alloc_page>:
{
ffffffffc02035c6:	7179                	addi	sp,sp,-48
ffffffffc02035c8:	ec26                	sd	s1,24(sp)
ffffffffc02035ca:	e84a                	sd	s2,16(sp)
ffffffffc02035cc:	e052                	sd	s4,0(sp)
ffffffffc02035ce:	f406                	sd	ra,40(sp)
ffffffffc02035d0:	f022                	sd	s0,32(sp)
ffffffffc02035d2:	e44e                	sd	s3,8(sp)
ffffffffc02035d4:	8a2a                	mv	s4,a0
ffffffffc02035d6:	84ae                	mv	s1,a1
ffffffffc02035d8:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02035da:	100027f3          	csrr	a5,sstatus
ffffffffc02035de:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc02035e0:	000a7997          	auipc	s3,0xa7
ffffffffc02035e4:	15098993          	addi	s3,s3,336 # ffffffffc02aa730 <pmm_manager>
ffffffffc02035e8:	ef8d                	bnez	a5,ffffffffc0203622 <pgdir_alloc_page+0x5c>
ffffffffc02035ea:	0009b783          	ld	a5,0(s3)
ffffffffc02035ee:	4505                	li	a0,1
ffffffffc02035f0:	6f9c                	ld	a5,24(a5)
ffffffffc02035f2:	9782                	jalr	a5
ffffffffc02035f4:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc02035f6:	cc09                	beqz	s0,ffffffffc0203610 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02035f8:	86ca                	mv	a3,s2
ffffffffc02035fa:	8626                	mv	a2,s1
ffffffffc02035fc:	85a2                	mv	a1,s0
ffffffffc02035fe:	8552                	mv	a0,s4
ffffffffc0203600:	830ff0ef          	jal	ra,ffffffffc0202630 <page_insert>
ffffffffc0203604:	e915                	bnez	a0,ffffffffc0203638 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203606:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203608:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc020360a:	4785                	li	a5,1
ffffffffc020360c:	04f71e63          	bne	a4,a5,ffffffffc0203668 <pgdir_alloc_page+0xa2>
}
ffffffffc0203610:	70a2                	ld	ra,40(sp)
ffffffffc0203612:	8522                	mv	a0,s0
ffffffffc0203614:	7402                	ld	s0,32(sp)
ffffffffc0203616:	64e2                	ld	s1,24(sp)
ffffffffc0203618:	6942                	ld	s2,16(sp)
ffffffffc020361a:	69a2                	ld	s3,8(sp)
ffffffffc020361c:	6a02                	ld	s4,0(sp)
ffffffffc020361e:	6145                	addi	sp,sp,48
ffffffffc0203620:	8082                	ret
        intr_disable();
ffffffffc0203622:	b92fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203626:	0009b783          	ld	a5,0(s3)
ffffffffc020362a:	4505                	li	a0,1
ffffffffc020362c:	6f9c                	ld	a5,24(a5)
ffffffffc020362e:	9782                	jalr	a5
ffffffffc0203630:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203632:	b7cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203636:	b7c1                	j	ffffffffc02035f6 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203638:	100027f3          	csrr	a5,sstatus
ffffffffc020363c:	8b89                	andi	a5,a5,2
ffffffffc020363e:	eb89                	bnez	a5,ffffffffc0203650 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203640:	0009b783          	ld	a5,0(s3)
ffffffffc0203644:	8522                	mv	a0,s0
ffffffffc0203646:	4585                	li	a1,1
ffffffffc0203648:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020364a:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020364c:	9782                	jalr	a5
    if (flag)
ffffffffc020364e:	b7c9                	j	ffffffffc0203610 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203650:	b64fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203654:	0009b783          	ld	a5,0(s3)
ffffffffc0203658:	8522                	mv	a0,s0
ffffffffc020365a:	4585                	li	a1,1
ffffffffc020365c:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020365e:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203660:	9782                	jalr	a5
        intr_enable();
ffffffffc0203662:	b4cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203666:	b76d                	j	ffffffffc0203610 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203668:	00003697          	auipc	a3,0x3
ffffffffc020366c:	5c868693          	addi	a3,a3,1480 # ffffffffc0206c30 <default_pmm_manager+0x770>
ffffffffc0203670:	00003617          	auipc	a2,0x3
ffffffffc0203674:	aa060613          	addi	a2,a2,-1376 # ffffffffc0206110 <commands+0x818>
ffffffffc0203678:	1fc00593          	li	a1,508
ffffffffc020367c:	00003517          	auipc	a0,0x3
ffffffffc0203680:	f9450513          	addi	a0,a0,-108 # ffffffffc0206610 <default_pmm_manager+0x150>
ffffffffc0203684:	e0bfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203688 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203688:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc020368a:	00003697          	auipc	a3,0x3
ffffffffc020368e:	5be68693          	addi	a3,a3,1470 # ffffffffc0206c48 <default_pmm_manager+0x788>
ffffffffc0203692:	00003617          	auipc	a2,0x3
ffffffffc0203696:	a7e60613          	addi	a2,a2,-1410 # ffffffffc0206110 <commands+0x818>
ffffffffc020369a:	07400593          	li	a1,116
ffffffffc020369e:	00003517          	auipc	a0,0x3
ffffffffc02036a2:	5ca50513          	addi	a0,a0,1482 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036a6:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02036a8:	de7fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036ac <mm_create>:
{
ffffffffc02036ac:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036ae:	04000513          	li	a0,64
{
ffffffffc02036b2:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036b4:	df6fe0ef          	jal	ra,ffffffffc0201caa <kmalloc>
    if (mm != NULL)
ffffffffc02036b8:	cd19                	beqz	a0,ffffffffc02036d6 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02036ba:	e508                	sd	a0,8(a0)
ffffffffc02036bc:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036be:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02036c2:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02036c6:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02036ca:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02036ce:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02036d2:	02053c23          	sd	zero,56(a0)
}
ffffffffc02036d6:	60a2                	ld	ra,8(sp)
ffffffffc02036d8:	0141                	addi	sp,sp,16
ffffffffc02036da:	8082                	ret

ffffffffc02036dc <find_vma>:
{
ffffffffc02036dc:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02036de:	c505                	beqz	a0,ffffffffc0203706 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc02036e0:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02036e2:	c501                	beqz	a0,ffffffffc02036ea <find_vma+0xe>
ffffffffc02036e4:	651c                	ld	a5,8(a0)
ffffffffc02036e6:	02f5f263          	bgeu	a1,a5,ffffffffc020370a <find_vma+0x2e>
    return listelm->next;
ffffffffc02036ea:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc02036ec:	00f68d63          	beq	a3,a5,ffffffffc0203706 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02036f0:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f4ec8>
ffffffffc02036f4:	00e5e663          	bltu	a1,a4,ffffffffc0203700 <find_vma+0x24>
ffffffffc02036f8:	ff07b703          	ld	a4,-16(a5)
ffffffffc02036fc:	00e5ec63          	bltu	a1,a4,ffffffffc0203714 <find_vma+0x38>
ffffffffc0203700:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203702:	fef697e3          	bne	a3,a5,ffffffffc02036f0 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203706:	4501                	li	a0,0
}
ffffffffc0203708:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020370a:	691c                	ld	a5,16(a0)
ffffffffc020370c:	fcf5ffe3          	bgeu	a1,a5,ffffffffc02036ea <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203710:	ea88                	sd	a0,16(a3)
ffffffffc0203712:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203714:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203718:	ea88                	sd	a0,16(a3)
ffffffffc020371a:	8082                	ret

ffffffffc020371c <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc020371c:	6590                	ld	a2,8(a1)
ffffffffc020371e:	0105b803          	ld	a6,16(a1) # 80010 <_binary_obj___user_exit_out_size+0x74ef0>
{
ffffffffc0203722:	1141                	addi	sp,sp,-16
ffffffffc0203724:	e406                	sd	ra,8(sp)
ffffffffc0203726:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203728:	01066763          	bltu	a2,a6,ffffffffc0203736 <insert_vma_struct+0x1a>
ffffffffc020372c:	a085                	j	ffffffffc020378c <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020372e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203732:	04e66863          	bltu	a2,a4,ffffffffc0203782 <insert_vma_struct+0x66>
ffffffffc0203736:	86be                	mv	a3,a5
ffffffffc0203738:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020373a:	fef51ae3          	bne	a0,a5,ffffffffc020372e <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc020373e:	02a68463          	beq	a3,a0,ffffffffc0203766 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203742:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203746:	fe86b883          	ld	a7,-24(a3)
ffffffffc020374a:	08e8f163          	bgeu	a7,a4,ffffffffc02037cc <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020374e:	04e66f63          	bltu	a2,a4,ffffffffc02037ac <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203752:	00f50a63          	beq	a0,a5,ffffffffc0203766 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203756:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020375a:	05076963          	bltu	a4,a6,ffffffffc02037ac <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc020375e:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203762:	02c77363          	bgeu	a4,a2,ffffffffc0203788 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203766:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203768:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020376a:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020376e:	e390                	sd	a2,0(a5)
ffffffffc0203770:	e690                	sd	a2,8(a3)
}
ffffffffc0203772:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203774:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203776:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203778:	0017079b          	addiw	a5,a4,1
ffffffffc020377c:	d11c                	sw	a5,32(a0)
}
ffffffffc020377e:	0141                	addi	sp,sp,16
ffffffffc0203780:	8082                	ret
    if (le_prev != list)
ffffffffc0203782:	fca690e3          	bne	a3,a0,ffffffffc0203742 <insert_vma_struct+0x26>
ffffffffc0203786:	bfd1                	j	ffffffffc020375a <insert_vma_struct+0x3e>
ffffffffc0203788:	f01ff0ef          	jal	ra,ffffffffc0203688 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc020378c:	00003697          	auipc	a3,0x3
ffffffffc0203790:	4ec68693          	addi	a3,a3,1260 # ffffffffc0206c78 <default_pmm_manager+0x7b8>
ffffffffc0203794:	00003617          	auipc	a2,0x3
ffffffffc0203798:	97c60613          	addi	a2,a2,-1668 # ffffffffc0206110 <commands+0x818>
ffffffffc020379c:	07a00593          	li	a1,122
ffffffffc02037a0:	00003517          	auipc	a0,0x3
ffffffffc02037a4:	4c850513          	addi	a0,a0,1224 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc02037a8:	ce7fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02037ac:	00003697          	auipc	a3,0x3
ffffffffc02037b0:	50c68693          	addi	a3,a3,1292 # ffffffffc0206cb8 <default_pmm_manager+0x7f8>
ffffffffc02037b4:	00003617          	auipc	a2,0x3
ffffffffc02037b8:	95c60613          	addi	a2,a2,-1700 # ffffffffc0206110 <commands+0x818>
ffffffffc02037bc:	07300593          	li	a1,115
ffffffffc02037c0:	00003517          	auipc	a0,0x3
ffffffffc02037c4:	4a850513          	addi	a0,a0,1192 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc02037c8:	cc7fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02037cc:	00003697          	auipc	a3,0x3
ffffffffc02037d0:	4cc68693          	addi	a3,a3,1228 # ffffffffc0206c98 <default_pmm_manager+0x7d8>
ffffffffc02037d4:	00003617          	auipc	a2,0x3
ffffffffc02037d8:	93c60613          	addi	a2,a2,-1732 # ffffffffc0206110 <commands+0x818>
ffffffffc02037dc:	07200593          	li	a1,114
ffffffffc02037e0:	00003517          	auipc	a0,0x3
ffffffffc02037e4:	48850513          	addi	a0,a0,1160 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc02037e8:	ca7fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02037ec <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02037ec:	591c                	lw	a5,48(a0)
{
ffffffffc02037ee:	1141                	addi	sp,sp,-16
ffffffffc02037f0:	e406                	sd	ra,8(sp)
ffffffffc02037f2:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02037f4:	e78d                	bnez	a5,ffffffffc020381e <mm_destroy+0x32>
ffffffffc02037f6:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02037f8:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02037fa:	00a40c63          	beq	s0,a0,ffffffffc0203812 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02037fe:	6118                	ld	a4,0(a0)
ffffffffc0203800:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203802:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203804:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203806:	e398                	sd	a4,0(a5)
ffffffffc0203808:	d52fe0ef          	jal	ra,ffffffffc0201d5a <kfree>
    return listelm->next;
ffffffffc020380c:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc020380e:	fea418e3          	bne	s0,a0,ffffffffc02037fe <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203812:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203814:	6402                	ld	s0,0(sp)
ffffffffc0203816:	60a2                	ld	ra,8(sp)
ffffffffc0203818:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020381a:	d40fe06f          	j	ffffffffc0201d5a <kfree>
    assert(mm_count(mm) == 0);
ffffffffc020381e:	00003697          	auipc	a3,0x3
ffffffffc0203822:	4ba68693          	addi	a3,a3,1210 # ffffffffc0206cd8 <default_pmm_manager+0x818>
ffffffffc0203826:	00003617          	auipc	a2,0x3
ffffffffc020382a:	8ea60613          	addi	a2,a2,-1814 # ffffffffc0206110 <commands+0x818>
ffffffffc020382e:	09e00593          	li	a1,158
ffffffffc0203832:	00003517          	auipc	a0,0x3
ffffffffc0203836:	43650513          	addi	a0,a0,1078 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc020383a:	c55fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020383e <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc020383e:	7139                	addi	sp,sp,-64
ffffffffc0203840:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203842:	6405                	lui	s0,0x1
ffffffffc0203844:	147d                	addi	s0,s0,-1
ffffffffc0203846:	77fd                	lui	a5,0xfffff
ffffffffc0203848:	9622                	add	a2,a2,s0
ffffffffc020384a:	962e                	add	a2,a2,a1
{
ffffffffc020384c:	f426                	sd	s1,40(sp)
ffffffffc020384e:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203850:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203854:	f04a                	sd	s2,32(sp)
ffffffffc0203856:	ec4e                	sd	s3,24(sp)
ffffffffc0203858:	e852                	sd	s4,16(sp)
ffffffffc020385a:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc020385c:	002005b7          	lui	a1,0x200
ffffffffc0203860:	00f67433          	and	s0,a2,a5
ffffffffc0203864:	06b4e363          	bltu	s1,a1,ffffffffc02038ca <mm_map+0x8c>
ffffffffc0203868:	0684f163          	bgeu	s1,s0,ffffffffc02038ca <mm_map+0x8c>
ffffffffc020386c:	4785                	li	a5,1
ffffffffc020386e:	07fe                	slli	a5,a5,0x1f
ffffffffc0203870:	0487ed63          	bltu	a5,s0,ffffffffc02038ca <mm_map+0x8c>
ffffffffc0203874:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203876:	cd21                	beqz	a0,ffffffffc02038ce <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203878:	85a6                	mv	a1,s1
ffffffffc020387a:	8ab6                	mv	s5,a3
ffffffffc020387c:	8a3a                	mv	s4,a4
ffffffffc020387e:	e5fff0ef          	jal	ra,ffffffffc02036dc <find_vma>
ffffffffc0203882:	c501                	beqz	a0,ffffffffc020388a <mm_map+0x4c>
ffffffffc0203884:	651c                	ld	a5,8(a0)
ffffffffc0203886:	0487e263          	bltu	a5,s0,ffffffffc02038ca <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020388a:	03000513          	li	a0,48
ffffffffc020388e:	c1cfe0ef          	jal	ra,ffffffffc0201caa <kmalloc>
ffffffffc0203892:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203894:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203896:	02090163          	beqz	s2,ffffffffc02038b8 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc020389a:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc020389c:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02038a0:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02038a4:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02038a8:	85ca                	mv	a1,s2
ffffffffc02038aa:	e73ff0ef          	jal	ra,ffffffffc020371c <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02038ae:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02038b0:	000a0463          	beqz	s4,ffffffffc02038b8 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02038b4:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>

out:
    return ret;
}
ffffffffc02038b8:	70e2                	ld	ra,56(sp)
ffffffffc02038ba:	7442                	ld	s0,48(sp)
ffffffffc02038bc:	74a2                	ld	s1,40(sp)
ffffffffc02038be:	7902                	ld	s2,32(sp)
ffffffffc02038c0:	69e2                	ld	s3,24(sp)
ffffffffc02038c2:	6a42                	ld	s4,16(sp)
ffffffffc02038c4:	6aa2                	ld	s5,8(sp)
ffffffffc02038c6:	6121                	addi	sp,sp,64
ffffffffc02038c8:	8082                	ret
        return -E_INVAL;
ffffffffc02038ca:	5575                	li	a0,-3
ffffffffc02038cc:	b7f5                	j	ffffffffc02038b8 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc02038ce:	00003697          	auipc	a3,0x3
ffffffffc02038d2:	42268693          	addi	a3,a3,1058 # ffffffffc0206cf0 <default_pmm_manager+0x830>
ffffffffc02038d6:	00003617          	auipc	a2,0x3
ffffffffc02038da:	83a60613          	addi	a2,a2,-1990 # ffffffffc0206110 <commands+0x818>
ffffffffc02038de:	0b300593          	li	a1,179
ffffffffc02038e2:	00003517          	auipc	a0,0x3
ffffffffc02038e6:	38650513          	addi	a0,a0,902 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc02038ea:	ba5fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02038ee <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc02038ee:	7139                	addi	sp,sp,-64
ffffffffc02038f0:	fc06                	sd	ra,56(sp)
ffffffffc02038f2:	f822                	sd	s0,48(sp)
ffffffffc02038f4:	f426                	sd	s1,40(sp)
ffffffffc02038f6:	f04a                	sd	s2,32(sp)
ffffffffc02038f8:	ec4e                	sd	s3,24(sp)
ffffffffc02038fa:	e852                	sd	s4,16(sp)
ffffffffc02038fc:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc02038fe:	c52d                	beqz	a0,ffffffffc0203968 <dup_mmap+0x7a>
ffffffffc0203900:	892a                	mv	s2,a0
ffffffffc0203902:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203904:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203906:	e595                	bnez	a1,ffffffffc0203932 <dup_mmap+0x44>
ffffffffc0203908:	a085                	j	ffffffffc0203968 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc020390a:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc020390c:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ee8>
        vma->vm_end = vm_end;
ffffffffc0203910:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203914:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203918:	e05ff0ef          	jal	ra,ffffffffc020371c <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc020391c:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc0203920:	fe843603          	ld	a2,-24(s0)
ffffffffc0203924:	6c8c                	ld	a1,24(s1)
ffffffffc0203926:	01893503          	ld	a0,24(s2)
ffffffffc020392a:	4701                	li	a4,0
ffffffffc020392c:	a3bff0ef          	jal	ra,ffffffffc0203366 <copy_range>
ffffffffc0203930:	e105                	bnez	a0,ffffffffc0203950 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203932:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203934:	02848863          	beq	s1,s0,ffffffffc0203964 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203938:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc020393c:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203940:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203944:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203948:	b62fe0ef          	jal	ra,ffffffffc0201caa <kmalloc>
ffffffffc020394c:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc020394e:	fd55                	bnez	a0,ffffffffc020390a <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203950:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203952:	70e2                	ld	ra,56(sp)
ffffffffc0203954:	7442                	ld	s0,48(sp)
ffffffffc0203956:	74a2                	ld	s1,40(sp)
ffffffffc0203958:	7902                	ld	s2,32(sp)
ffffffffc020395a:	69e2                	ld	s3,24(sp)
ffffffffc020395c:	6a42                	ld	s4,16(sp)
ffffffffc020395e:	6aa2                	ld	s5,8(sp)
ffffffffc0203960:	6121                	addi	sp,sp,64
ffffffffc0203962:	8082                	ret
    return 0;
ffffffffc0203964:	4501                	li	a0,0
ffffffffc0203966:	b7f5                	j	ffffffffc0203952 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203968:	00003697          	auipc	a3,0x3
ffffffffc020396c:	39868693          	addi	a3,a3,920 # ffffffffc0206d00 <default_pmm_manager+0x840>
ffffffffc0203970:	00002617          	auipc	a2,0x2
ffffffffc0203974:	7a060613          	addi	a2,a2,1952 # ffffffffc0206110 <commands+0x818>
ffffffffc0203978:	0cf00593          	li	a1,207
ffffffffc020397c:	00003517          	auipc	a0,0x3
ffffffffc0203980:	2ec50513          	addi	a0,a0,748 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203984:	b0bfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203988 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203988:	1101                	addi	sp,sp,-32
ffffffffc020398a:	ec06                	sd	ra,24(sp)
ffffffffc020398c:	e822                	sd	s0,16(sp)
ffffffffc020398e:	e426                	sd	s1,8(sp)
ffffffffc0203990:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203992:	c531                	beqz	a0,ffffffffc02039de <exit_mmap+0x56>
ffffffffc0203994:	591c                	lw	a5,48(a0)
ffffffffc0203996:	84aa                	mv	s1,a0
ffffffffc0203998:	e3b9                	bnez	a5,ffffffffc02039de <exit_mmap+0x56>
    return listelm->next;
ffffffffc020399a:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc020399c:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02039a0:	02850663          	beq	a0,s0,ffffffffc02039cc <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039a4:	ff043603          	ld	a2,-16(s0)
ffffffffc02039a8:	fe843583          	ld	a1,-24(s0)
ffffffffc02039ac:	854a                	mv	a0,s2
ffffffffc02039ae:	80ffe0ef          	jal	ra,ffffffffc02021bc <unmap_range>
ffffffffc02039b2:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039b4:	fe8498e3          	bne	s1,s0,ffffffffc02039a4 <exit_mmap+0x1c>
ffffffffc02039b8:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02039ba:	00848c63          	beq	s1,s0,ffffffffc02039d2 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039be:	ff043603          	ld	a2,-16(s0)
ffffffffc02039c2:	fe843583          	ld	a1,-24(s0)
ffffffffc02039c6:	854a                	mv	a0,s2
ffffffffc02039c8:	93bfe0ef          	jal	ra,ffffffffc0202302 <exit_range>
ffffffffc02039cc:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039ce:	fe8498e3          	bne	s1,s0,ffffffffc02039be <exit_mmap+0x36>
    }
}
ffffffffc02039d2:	60e2                	ld	ra,24(sp)
ffffffffc02039d4:	6442                	ld	s0,16(sp)
ffffffffc02039d6:	64a2                	ld	s1,8(sp)
ffffffffc02039d8:	6902                	ld	s2,0(sp)
ffffffffc02039da:	6105                	addi	sp,sp,32
ffffffffc02039dc:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039de:	00003697          	auipc	a3,0x3
ffffffffc02039e2:	34268693          	addi	a3,a3,834 # ffffffffc0206d20 <default_pmm_manager+0x860>
ffffffffc02039e6:	00002617          	auipc	a2,0x2
ffffffffc02039ea:	72a60613          	addi	a2,a2,1834 # ffffffffc0206110 <commands+0x818>
ffffffffc02039ee:	0e800593          	li	a1,232
ffffffffc02039f2:	00003517          	auipc	a0,0x3
ffffffffc02039f6:	27650513          	addi	a0,a0,630 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc02039fa:	a95fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02039fe <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc02039fe:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a00:	04000513          	li	a0,64
{
ffffffffc0203a04:	fc06                	sd	ra,56(sp)
ffffffffc0203a06:	f822                	sd	s0,48(sp)
ffffffffc0203a08:	f426                	sd	s1,40(sp)
ffffffffc0203a0a:	f04a                	sd	s2,32(sp)
ffffffffc0203a0c:	ec4e                	sd	s3,24(sp)
ffffffffc0203a0e:	e852                	sd	s4,16(sp)
ffffffffc0203a10:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a12:	a98fe0ef          	jal	ra,ffffffffc0201caa <kmalloc>
    if (mm != NULL)
ffffffffc0203a16:	2e050663          	beqz	a0,ffffffffc0203d02 <vmm_init+0x304>
ffffffffc0203a1a:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203a1c:	e508                	sd	a0,8(a0)
ffffffffc0203a1e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203a20:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203a24:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203a28:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203a2c:	02053423          	sd	zero,40(a0)
ffffffffc0203a30:	02052823          	sw	zero,48(a0)
ffffffffc0203a34:	02053c23          	sd	zero,56(a0)
ffffffffc0203a38:	03200413          	li	s0,50
ffffffffc0203a3c:	a811                	j	ffffffffc0203a50 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203a3e:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a40:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a42:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203a46:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a48:	8526                	mv	a0,s1
ffffffffc0203a4a:	cd3ff0ef          	jal	ra,ffffffffc020371c <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203a4e:	c80d                	beqz	s0,ffffffffc0203a80 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a50:	03000513          	li	a0,48
ffffffffc0203a54:	a56fe0ef          	jal	ra,ffffffffc0201caa <kmalloc>
ffffffffc0203a58:	85aa                	mv	a1,a0
ffffffffc0203a5a:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203a5e:	f165                	bnez	a0,ffffffffc0203a3e <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203a60:	00003697          	auipc	a3,0x3
ffffffffc0203a64:	45868693          	addi	a3,a3,1112 # ffffffffc0206eb8 <default_pmm_manager+0x9f8>
ffffffffc0203a68:	00002617          	auipc	a2,0x2
ffffffffc0203a6c:	6a860613          	addi	a2,a2,1704 # ffffffffc0206110 <commands+0x818>
ffffffffc0203a70:	12c00593          	li	a1,300
ffffffffc0203a74:	00003517          	auipc	a0,0x3
ffffffffc0203a78:	1f450513          	addi	a0,a0,500 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203a7c:	a13fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203a80:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a84:	1f900913          	li	s2,505
ffffffffc0203a88:	a819                	j	ffffffffc0203a9e <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203a8a:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a8c:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a8e:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a92:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a94:	8526                	mv	a0,s1
ffffffffc0203a96:	c87ff0ef          	jal	ra,ffffffffc020371c <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a9a:	03240a63          	beq	s0,s2,ffffffffc0203ace <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a9e:	03000513          	li	a0,48
ffffffffc0203aa2:	a08fe0ef          	jal	ra,ffffffffc0201caa <kmalloc>
ffffffffc0203aa6:	85aa                	mv	a1,a0
ffffffffc0203aa8:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203aac:	fd79                	bnez	a0,ffffffffc0203a8a <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203aae:	00003697          	auipc	a3,0x3
ffffffffc0203ab2:	40a68693          	addi	a3,a3,1034 # ffffffffc0206eb8 <default_pmm_manager+0x9f8>
ffffffffc0203ab6:	00002617          	auipc	a2,0x2
ffffffffc0203aba:	65a60613          	addi	a2,a2,1626 # ffffffffc0206110 <commands+0x818>
ffffffffc0203abe:	13300593          	li	a1,307
ffffffffc0203ac2:	00003517          	auipc	a0,0x3
ffffffffc0203ac6:	1a650513          	addi	a0,a0,422 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203aca:	9c5fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203ace:	649c                	ld	a5,8(s1)
ffffffffc0203ad0:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203ad2:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203ad6:	16f48663          	beq	s1,a5,ffffffffc0203c42 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203ada:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd5488c>
ffffffffc0203ade:	ffe70693          	addi	a3,a4,-2
ffffffffc0203ae2:	10d61063          	bne	a2,a3,ffffffffc0203be2 <vmm_init+0x1e4>
ffffffffc0203ae6:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203aea:	0ed71c63          	bne	a4,a3,ffffffffc0203be2 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203aee:	0715                	addi	a4,a4,5
ffffffffc0203af0:	679c                	ld	a5,8(a5)
ffffffffc0203af2:	feb712e3          	bne	a4,a1,ffffffffc0203ad6 <vmm_init+0xd8>
ffffffffc0203af6:	4a1d                	li	s4,7
ffffffffc0203af8:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203afa:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203afe:	85a2                	mv	a1,s0
ffffffffc0203b00:	8526                	mv	a0,s1
ffffffffc0203b02:	bdbff0ef          	jal	ra,ffffffffc02036dc <find_vma>
ffffffffc0203b06:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203b08:	16050d63          	beqz	a0,ffffffffc0203c82 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203b0c:	00140593          	addi	a1,s0,1
ffffffffc0203b10:	8526                	mv	a0,s1
ffffffffc0203b12:	bcbff0ef          	jal	ra,ffffffffc02036dc <find_vma>
ffffffffc0203b16:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203b18:	14050563          	beqz	a0,ffffffffc0203c62 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203b1c:	85d2                	mv	a1,s4
ffffffffc0203b1e:	8526                	mv	a0,s1
ffffffffc0203b20:	bbdff0ef          	jal	ra,ffffffffc02036dc <find_vma>
        assert(vma3 == NULL);
ffffffffc0203b24:	16051f63          	bnez	a0,ffffffffc0203ca2 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203b28:	00340593          	addi	a1,s0,3
ffffffffc0203b2c:	8526                	mv	a0,s1
ffffffffc0203b2e:	bafff0ef          	jal	ra,ffffffffc02036dc <find_vma>
        assert(vma4 == NULL);
ffffffffc0203b32:	1a051863          	bnez	a0,ffffffffc0203ce2 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203b36:	00440593          	addi	a1,s0,4
ffffffffc0203b3a:	8526                	mv	a0,s1
ffffffffc0203b3c:	ba1ff0ef          	jal	ra,ffffffffc02036dc <find_vma>
        assert(vma5 == NULL);
ffffffffc0203b40:	18051163          	bnez	a0,ffffffffc0203cc2 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b44:	00893783          	ld	a5,8(s2)
ffffffffc0203b48:	0a879d63          	bne	a5,s0,ffffffffc0203c02 <vmm_init+0x204>
ffffffffc0203b4c:	01093783          	ld	a5,16(s2)
ffffffffc0203b50:	0b479963          	bne	a5,s4,ffffffffc0203c02 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b54:	0089b783          	ld	a5,8(s3)
ffffffffc0203b58:	0c879563          	bne	a5,s0,ffffffffc0203c22 <vmm_init+0x224>
ffffffffc0203b5c:	0109b783          	ld	a5,16(s3)
ffffffffc0203b60:	0d479163          	bne	a5,s4,ffffffffc0203c22 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b64:	0415                	addi	s0,s0,5
ffffffffc0203b66:	0a15                	addi	s4,s4,5
ffffffffc0203b68:	f9541be3          	bne	s0,s5,ffffffffc0203afe <vmm_init+0x100>
ffffffffc0203b6c:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203b6e:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203b70:	85a2                	mv	a1,s0
ffffffffc0203b72:	8526                	mv	a0,s1
ffffffffc0203b74:	b69ff0ef          	jal	ra,ffffffffc02036dc <find_vma>
ffffffffc0203b78:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203b7c:	c90d                	beqz	a0,ffffffffc0203bae <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203b7e:	6914                	ld	a3,16(a0)
ffffffffc0203b80:	6510                	ld	a2,8(a0)
ffffffffc0203b82:	00003517          	auipc	a0,0x3
ffffffffc0203b86:	2be50513          	addi	a0,a0,702 # ffffffffc0206e40 <default_pmm_manager+0x980>
ffffffffc0203b8a:	e0afc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203b8e:	00003697          	auipc	a3,0x3
ffffffffc0203b92:	2da68693          	addi	a3,a3,730 # ffffffffc0206e68 <default_pmm_manager+0x9a8>
ffffffffc0203b96:	00002617          	auipc	a2,0x2
ffffffffc0203b9a:	57a60613          	addi	a2,a2,1402 # ffffffffc0206110 <commands+0x818>
ffffffffc0203b9e:	15900593          	li	a1,345
ffffffffc0203ba2:	00003517          	auipc	a0,0x3
ffffffffc0203ba6:	0c650513          	addi	a0,a0,198 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203baa:	8e5fc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203bae:	147d                	addi	s0,s0,-1
ffffffffc0203bb0:	fd2410e3          	bne	s0,s2,ffffffffc0203b70 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203bb4:	8526                	mv	a0,s1
ffffffffc0203bb6:	c37ff0ef          	jal	ra,ffffffffc02037ec <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203bba:	00003517          	auipc	a0,0x3
ffffffffc0203bbe:	2c650513          	addi	a0,a0,710 # ffffffffc0206e80 <default_pmm_manager+0x9c0>
ffffffffc0203bc2:	dd2fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203bc6:	7442                	ld	s0,48(sp)
ffffffffc0203bc8:	70e2                	ld	ra,56(sp)
ffffffffc0203bca:	74a2                	ld	s1,40(sp)
ffffffffc0203bcc:	7902                	ld	s2,32(sp)
ffffffffc0203bce:	69e2                	ld	s3,24(sp)
ffffffffc0203bd0:	6a42                	ld	s4,16(sp)
ffffffffc0203bd2:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203bd4:	00003517          	auipc	a0,0x3
ffffffffc0203bd8:	2cc50513          	addi	a0,a0,716 # ffffffffc0206ea0 <default_pmm_manager+0x9e0>
}
ffffffffc0203bdc:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203bde:	db6fc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203be2:	00003697          	auipc	a3,0x3
ffffffffc0203be6:	17668693          	addi	a3,a3,374 # ffffffffc0206d58 <default_pmm_manager+0x898>
ffffffffc0203bea:	00002617          	auipc	a2,0x2
ffffffffc0203bee:	52660613          	addi	a2,a2,1318 # ffffffffc0206110 <commands+0x818>
ffffffffc0203bf2:	13d00593          	li	a1,317
ffffffffc0203bf6:	00003517          	auipc	a0,0x3
ffffffffc0203bfa:	07250513          	addi	a0,a0,114 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203bfe:	891fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203c02:	00003697          	auipc	a3,0x3
ffffffffc0203c06:	1de68693          	addi	a3,a3,478 # ffffffffc0206de0 <default_pmm_manager+0x920>
ffffffffc0203c0a:	00002617          	auipc	a2,0x2
ffffffffc0203c0e:	50660613          	addi	a2,a2,1286 # ffffffffc0206110 <commands+0x818>
ffffffffc0203c12:	14e00593          	li	a1,334
ffffffffc0203c16:	00003517          	auipc	a0,0x3
ffffffffc0203c1a:	05250513          	addi	a0,a0,82 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203c1e:	871fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203c22:	00003697          	auipc	a3,0x3
ffffffffc0203c26:	1ee68693          	addi	a3,a3,494 # ffffffffc0206e10 <default_pmm_manager+0x950>
ffffffffc0203c2a:	00002617          	auipc	a2,0x2
ffffffffc0203c2e:	4e660613          	addi	a2,a2,1254 # ffffffffc0206110 <commands+0x818>
ffffffffc0203c32:	14f00593          	li	a1,335
ffffffffc0203c36:	00003517          	auipc	a0,0x3
ffffffffc0203c3a:	03250513          	addi	a0,a0,50 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203c3e:	851fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203c42:	00003697          	auipc	a3,0x3
ffffffffc0203c46:	0fe68693          	addi	a3,a3,254 # ffffffffc0206d40 <default_pmm_manager+0x880>
ffffffffc0203c4a:	00002617          	auipc	a2,0x2
ffffffffc0203c4e:	4c660613          	addi	a2,a2,1222 # ffffffffc0206110 <commands+0x818>
ffffffffc0203c52:	13b00593          	li	a1,315
ffffffffc0203c56:	00003517          	auipc	a0,0x3
ffffffffc0203c5a:	01250513          	addi	a0,a0,18 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203c5e:	831fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203c62:	00003697          	auipc	a3,0x3
ffffffffc0203c66:	13e68693          	addi	a3,a3,318 # ffffffffc0206da0 <default_pmm_manager+0x8e0>
ffffffffc0203c6a:	00002617          	auipc	a2,0x2
ffffffffc0203c6e:	4a660613          	addi	a2,a2,1190 # ffffffffc0206110 <commands+0x818>
ffffffffc0203c72:	14600593          	li	a1,326
ffffffffc0203c76:	00003517          	auipc	a0,0x3
ffffffffc0203c7a:	ff250513          	addi	a0,a0,-14 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203c7e:	811fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203c82:	00003697          	auipc	a3,0x3
ffffffffc0203c86:	10e68693          	addi	a3,a3,270 # ffffffffc0206d90 <default_pmm_manager+0x8d0>
ffffffffc0203c8a:	00002617          	auipc	a2,0x2
ffffffffc0203c8e:	48660613          	addi	a2,a2,1158 # ffffffffc0206110 <commands+0x818>
ffffffffc0203c92:	14400593          	li	a1,324
ffffffffc0203c96:	00003517          	auipc	a0,0x3
ffffffffc0203c9a:	fd250513          	addi	a0,a0,-46 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203c9e:	ff0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203ca2:	00003697          	auipc	a3,0x3
ffffffffc0203ca6:	10e68693          	addi	a3,a3,270 # ffffffffc0206db0 <default_pmm_manager+0x8f0>
ffffffffc0203caa:	00002617          	auipc	a2,0x2
ffffffffc0203cae:	46660613          	addi	a2,a2,1126 # ffffffffc0206110 <commands+0x818>
ffffffffc0203cb2:	14800593          	li	a1,328
ffffffffc0203cb6:	00003517          	auipc	a0,0x3
ffffffffc0203cba:	fb250513          	addi	a0,a0,-78 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203cbe:	fd0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203cc2:	00003697          	auipc	a3,0x3
ffffffffc0203cc6:	10e68693          	addi	a3,a3,270 # ffffffffc0206dd0 <default_pmm_manager+0x910>
ffffffffc0203cca:	00002617          	auipc	a2,0x2
ffffffffc0203cce:	44660613          	addi	a2,a2,1094 # ffffffffc0206110 <commands+0x818>
ffffffffc0203cd2:	14c00593          	li	a1,332
ffffffffc0203cd6:	00003517          	auipc	a0,0x3
ffffffffc0203cda:	f9250513          	addi	a0,a0,-110 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203cde:	fb0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203ce2:	00003697          	auipc	a3,0x3
ffffffffc0203ce6:	0de68693          	addi	a3,a3,222 # ffffffffc0206dc0 <default_pmm_manager+0x900>
ffffffffc0203cea:	00002617          	auipc	a2,0x2
ffffffffc0203cee:	42660613          	addi	a2,a2,1062 # ffffffffc0206110 <commands+0x818>
ffffffffc0203cf2:	14a00593          	li	a1,330
ffffffffc0203cf6:	00003517          	auipc	a0,0x3
ffffffffc0203cfa:	f7250513          	addi	a0,a0,-142 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203cfe:	f90fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203d02:	00003697          	auipc	a3,0x3
ffffffffc0203d06:	fee68693          	addi	a3,a3,-18 # ffffffffc0206cf0 <default_pmm_manager+0x830>
ffffffffc0203d0a:	00002617          	auipc	a2,0x2
ffffffffc0203d0e:	40660613          	addi	a2,a2,1030 # ffffffffc0206110 <commands+0x818>
ffffffffc0203d12:	12400593          	li	a1,292
ffffffffc0203d16:	00003517          	auipc	a0,0x3
ffffffffc0203d1a:	f5250513          	addi	a0,a0,-174 # ffffffffc0206c68 <default_pmm_manager+0x7a8>
ffffffffc0203d1e:	f70fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203d22 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203d22:	7179                	addi	sp,sp,-48
ffffffffc0203d24:	f022                	sd	s0,32(sp)
ffffffffc0203d26:	f406                	sd	ra,40(sp)
ffffffffc0203d28:	ec26                	sd	s1,24(sp)
ffffffffc0203d2a:	e84a                	sd	s2,16(sp)
ffffffffc0203d2c:	e44e                	sd	s3,8(sp)
ffffffffc0203d2e:	e052                	sd	s4,0(sp)
ffffffffc0203d30:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203d32:	c135                	beqz	a0,ffffffffc0203d96 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203d34:	002007b7          	lui	a5,0x200
ffffffffc0203d38:	04f5e663          	bltu	a1,a5,ffffffffc0203d84 <user_mem_check+0x62>
ffffffffc0203d3c:	00c584b3          	add	s1,a1,a2
ffffffffc0203d40:	0495f263          	bgeu	a1,s1,ffffffffc0203d84 <user_mem_check+0x62>
ffffffffc0203d44:	4785                	li	a5,1
ffffffffc0203d46:	07fe                	slli	a5,a5,0x1f
ffffffffc0203d48:	0297ee63          	bltu	a5,s1,ffffffffc0203d84 <user_mem_check+0x62>
ffffffffc0203d4c:	892a                	mv	s2,a0
ffffffffc0203d4e:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d50:	6a05                	lui	s4,0x1
ffffffffc0203d52:	a821                	j	ffffffffc0203d6a <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d54:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d58:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d5a:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d5c:	c685                	beqz	a3,ffffffffc0203d84 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d5e:	c399                	beqz	a5,ffffffffc0203d64 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d60:	02e46263          	bltu	s0,a4,ffffffffc0203d84 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203d64:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203d66:	04947663          	bgeu	s0,s1,ffffffffc0203db2 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203d6a:	85a2                	mv	a1,s0
ffffffffc0203d6c:	854a                	mv	a0,s2
ffffffffc0203d6e:	96fff0ef          	jal	ra,ffffffffc02036dc <find_vma>
ffffffffc0203d72:	c909                	beqz	a0,ffffffffc0203d84 <user_mem_check+0x62>
ffffffffc0203d74:	6518                	ld	a4,8(a0)
ffffffffc0203d76:	00e46763          	bltu	s0,a4,ffffffffc0203d84 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d7a:	4d1c                	lw	a5,24(a0)
ffffffffc0203d7c:	fc099ce3          	bnez	s3,ffffffffc0203d54 <user_mem_check+0x32>
ffffffffc0203d80:	8b85                	andi	a5,a5,1
ffffffffc0203d82:	f3ed                	bnez	a5,ffffffffc0203d64 <user_mem_check+0x42>
            return 0;
ffffffffc0203d84:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203d86:	70a2                	ld	ra,40(sp)
ffffffffc0203d88:	7402                	ld	s0,32(sp)
ffffffffc0203d8a:	64e2                	ld	s1,24(sp)
ffffffffc0203d8c:	6942                	ld	s2,16(sp)
ffffffffc0203d8e:	69a2                	ld	s3,8(sp)
ffffffffc0203d90:	6a02                	ld	s4,0(sp)
ffffffffc0203d92:	6145                	addi	sp,sp,48
ffffffffc0203d94:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203d96:	c02007b7          	lui	a5,0xc0200
ffffffffc0203d9a:	4501                	li	a0,0
ffffffffc0203d9c:	fef5e5e3          	bltu	a1,a5,ffffffffc0203d86 <user_mem_check+0x64>
ffffffffc0203da0:	962e                	add	a2,a2,a1
ffffffffc0203da2:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203d86 <user_mem_check+0x64>
ffffffffc0203da6:	c8000537          	lui	a0,0xc8000
ffffffffc0203daa:	0505                	addi	a0,a0,1
ffffffffc0203dac:	00a63533          	sltu	a0,a2,a0
ffffffffc0203db0:	bfd9                	j	ffffffffc0203d86 <user_mem_check+0x64>
        return 1;
ffffffffc0203db2:	4505                	li	a0,1
ffffffffc0203db4:	bfc9                	j	ffffffffc0203d86 <user_mem_check+0x64>

ffffffffc0203db6 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203db6:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203db8:	9402                	jalr	s0

	jal do_exit
ffffffffc0203dba:	5dc000ef          	jal	ra,ffffffffc0204396 <do_exit>

ffffffffc0203dbe <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203dbe:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203dc0:	10800513          	li	a0,264
{
ffffffffc0203dc4:	e022                	sd	s0,0(sp)
ffffffffc0203dc6:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203dc8:	ee3fd0ef          	jal	ra,ffffffffc0201caa <kmalloc>
ffffffffc0203dcc:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203dce:	cd21                	beqz	a0,ffffffffc0203e26 <alloc_proc+0x68>
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        // 你的Lab4代码将放在这里
        proc->state = PROC_UNINIT;          // 初始状态为未初始化
ffffffffc0203dd0:	57fd                	li	a5,-1
ffffffffc0203dd2:	1782                	slli	a5,a5,0x20
ffffffffc0203dd4:	e11c                	sd	a5,0(a0)
        proc->runs = 0;                     // 运行次数初始为0
        proc->kstack = 0;                   // 内核栈地址暂设为0（后续setup_kstack分配）
        proc->need_resched = 0;             // 初始不需要调度（ucore用0表示false，修复编译报错）
        proc->parent = NULL;                // 父进程初始为NULL
        proc->mm = NULL;                    // 内核线程无独立内存管理结构，设为NULL
        memset(&proc->context, 0, sizeof(struct context));  // 上下文清零
ffffffffc0203dd6:	07000613          	li	a2,112
ffffffffc0203dda:	4581                	li	a1,0
        proc->runs = 0;                     // 运行次数初始为0
ffffffffc0203ddc:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d558ac>
        proc->kstack = 0;                   // 内核栈地址暂设为0（后续setup_kstack分配）
ffffffffc0203de0:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;             // 初始不需要调度（ucore用0表示false，修复编译报错）
ffffffffc0203de4:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;                // 父进程初始为NULL
ffffffffc0203de8:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;                    // 内核线程无独立内存管理结构，设为NULL
ffffffffc0203dec:	02053423          	sd	zero,40(a0)
        memset(&proc->context, 0, sizeof(struct context));  // 上下文清零
ffffffffc0203df0:	03050513          	addi	a0,a0,48
ffffffffc0203df4:	06f010ef          	jal	ra,ffffffffc0205662 <memset>
        proc->tf = NULL;                    // 中断帧暂设为NULL（后续copy_thread构造）
        proc->pgdir = boot_pgdir_pa;        // 共享内核页表的物理地址（修复变量名错误，编译报错）
ffffffffc0203df8:	000a7797          	auipc	a5,0xa7
ffffffffc0203dfc:	9187b783          	ld	a5,-1768(a5) # ffffffffc02aa710 <boot_pgdir_pa>
        proc->tf = NULL;                    // 中断帧暂设为NULL（后续copy_thread构造）
ffffffffc0203e00:	0a043023          	sd	zero,160(s0)
        proc->pgdir = boot_pgdir_pa;        // 共享内核页表的物理地址（修复变量名错误，编译报错）
ffffffffc0203e04:	f45c                	sd	a5,168(s0)
        proc->flags = 0;                    // 标志位初始为0
ffffffffc0203e06:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);  // 进程名清零
ffffffffc0203e0a:	4641                	li	a2,16
ffffffffc0203e0c:	4581                	li	a1,0
ffffffffc0203e0e:	0b440513          	addi	a0,s0,180
ffffffffc0203e12:	051010ef          	jal	ra,ffffffffc0205662 <memset>
        
        // LAB5: 初始化新增字段
        proc->wait_state = 0;               // 等待状态初始化为0
ffffffffc0203e16:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;                  // 子进程指针
ffffffffc0203e1a:	0e043823          	sd	zero,240(s0)
        proc->yptr = NULL;                  // 弟弟进程指针
ffffffffc0203e1e:	0e043c23          	sd	zero,248(s0)
        proc->optr = NULL;                  // 哥哥进程指针
ffffffffc0203e22:	10043023          	sd	zero,256(s0)
        
        // Lab5部分保持原样，我不修改
    }
    return proc;
}
ffffffffc0203e26:	60a2                	ld	ra,8(sp)
ffffffffc0203e28:	8522                	mv	a0,s0
ffffffffc0203e2a:	6402                	ld	s0,0(sp)
ffffffffc0203e2c:	0141                	addi	sp,sp,16
ffffffffc0203e2e:	8082                	ret

ffffffffc0203e30 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203e30:	000a7797          	auipc	a5,0xa7
ffffffffc0203e34:	9107b783          	ld	a5,-1776(a5) # ffffffffc02aa740 <current>
ffffffffc0203e38:	73c8                	ld	a0,160(a5)
ffffffffc0203e3a:	8e4fd06f          	j	ffffffffc0200f1e <forkrets>

ffffffffc0203e3e <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e3e:	000a7797          	auipc	a5,0xa7
ffffffffc0203e42:	9027b783          	ld	a5,-1790(a5) # ffffffffc02aa740 <current>
ffffffffc0203e46:	43cc                	lw	a1,4(a5)
{
ffffffffc0203e48:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e4a:	00003617          	auipc	a2,0x3
ffffffffc0203e4e:	07e60613          	addi	a2,a2,126 # ffffffffc0206ec8 <default_pmm_manager+0xa08>
ffffffffc0203e52:	00003517          	auipc	a0,0x3
ffffffffc0203e56:	08650513          	addi	a0,a0,134 # ffffffffc0206ed8 <default_pmm_manager+0xa18>
{
ffffffffc0203e5a:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e5c:	b38fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0203e60:	3fe07797          	auipc	a5,0x3fe07
ffffffffc0203e64:	b0878793          	addi	a5,a5,-1272 # a968 <_binary_obj___user_forktest_out_size>
ffffffffc0203e68:	e43e                	sd	a5,8(sp)
ffffffffc0203e6a:	00003517          	auipc	a0,0x3
ffffffffc0203e6e:	05e50513          	addi	a0,a0,94 # ffffffffc0206ec8 <default_pmm_manager+0xa08>
ffffffffc0203e72:	00046797          	auipc	a5,0x46
ffffffffc0203e76:	88e78793          	addi	a5,a5,-1906 # ffffffffc0249700 <_binary_obj___user_forktest_out_start>
ffffffffc0203e7a:	f03e                	sd	a5,32(sp)
ffffffffc0203e7c:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203e7e:	e802                	sd	zero,16(sp)
ffffffffc0203e80:	740010ef          	jal	ra,ffffffffc02055c0 <strlen>
ffffffffc0203e84:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203e86:	4511                	li	a0,4
ffffffffc0203e88:	55a2                	lw	a1,40(sp)
ffffffffc0203e8a:	4662                	lw	a2,24(sp)
ffffffffc0203e8c:	5682                	lw	a3,32(sp)
ffffffffc0203e8e:	4722                	lw	a4,8(sp)
ffffffffc0203e90:	48a9                	li	a7,10
ffffffffc0203e92:	9002                	ebreak
ffffffffc0203e94:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203e96:	65c2                	ld	a1,16(sp)
ffffffffc0203e98:	00003517          	auipc	a0,0x3
ffffffffc0203e9c:	06850513          	addi	a0,a0,104 # ffffffffc0206f00 <default_pmm_manager+0xa40>
ffffffffc0203ea0:	af4fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0203ea4:	00003617          	auipc	a2,0x3
ffffffffc0203ea8:	06c60613          	addi	a2,a2,108 # ffffffffc0206f10 <default_pmm_manager+0xa50>
ffffffffc0203eac:	3cd00593          	li	a1,973
ffffffffc0203eb0:	00003517          	auipc	a0,0x3
ffffffffc0203eb4:	08050513          	addi	a0,a0,128 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0203eb8:	dd6fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203ebc <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203ebc:	6d14                	ld	a3,24(a0)
{
ffffffffc0203ebe:	1141                	addi	sp,sp,-16
ffffffffc0203ec0:	e406                	sd	ra,8(sp)
ffffffffc0203ec2:	c02007b7          	lui	a5,0xc0200
ffffffffc0203ec6:	02f6ee63          	bltu	a3,a5,ffffffffc0203f02 <put_pgdir+0x46>
ffffffffc0203eca:	000a7517          	auipc	a0,0xa7
ffffffffc0203ece:	86e53503          	ld	a0,-1938(a0) # ffffffffc02aa738 <va_pa_offset>
ffffffffc0203ed2:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203ed4:	82b1                	srli	a3,a3,0xc
ffffffffc0203ed6:	000a7797          	auipc	a5,0xa7
ffffffffc0203eda:	84a7b783          	ld	a5,-1974(a5) # ffffffffc02aa720 <npage>
ffffffffc0203ede:	02f6fe63          	bgeu	a3,a5,ffffffffc0203f1a <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203ee2:	00004517          	auipc	a0,0x4
ffffffffc0203ee6:	8e653503          	ld	a0,-1818(a0) # ffffffffc02077c8 <nbase>
}
ffffffffc0203eea:	60a2                	ld	ra,8(sp)
ffffffffc0203eec:	8e89                	sub	a3,a3,a0
ffffffffc0203eee:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203ef0:	000a7517          	auipc	a0,0xa7
ffffffffc0203ef4:	83853503          	ld	a0,-1992(a0) # ffffffffc02aa728 <pages>
ffffffffc0203ef8:	4585                	li	a1,1
ffffffffc0203efa:	9536                	add	a0,a0,a3
}
ffffffffc0203efc:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203efe:	fc9fd06f          	j	ffffffffc0201ec6 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203f02:	00002617          	auipc	a2,0x2
ffffffffc0203f06:	69e60613          	addi	a2,a2,1694 # ffffffffc02065a0 <default_pmm_manager+0xe0>
ffffffffc0203f0a:	07700593          	li	a1,119
ffffffffc0203f0e:	00002517          	auipc	a0,0x2
ffffffffc0203f12:	61250513          	addi	a0,a0,1554 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0203f16:	d78fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203f1a:	00002617          	auipc	a2,0x2
ffffffffc0203f1e:	6ae60613          	addi	a2,a2,1710 # ffffffffc02065c8 <default_pmm_manager+0x108>
ffffffffc0203f22:	06900593          	li	a1,105
ffffffffc0203f26:	00002517          	auipc	a0,0x2
ffffffffc0203f2a:	5fa50513          	addi	a0,a0,1530 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0203f2e:	d60fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f32 <proc_run>:
{
ffffffffc0203f32:	7179                	addi	sp,sp,-48
ffffffffc0203f34:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203f36:	000a7917          	auipc	s2,0xa7
ffffffffc0203f3a:	80a90913          	addi	s2,s2,-2038 # ffffffffc02aa740 <current>
{
ffffffffc0203f3e:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203f40:	00093483          	ld	s1,0(s2)
{
ffffffffc0203f44:	f406                	sd	ra,40(sp)
ffffffffc0203f46:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203f48:	02a48863          	beq	s1,a0,ffffffffc0203f78 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f4c:	100027f3          	csrr	a5,sstatus
ffffffffc0203f50:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203f52:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f54:	ef9d                	bnez	a5,ffffffffc0203f92 <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203f56:	755c                	ld	a5,168(a0)
ffffffffc0203f58:	577d                	li	a4,-1
ffffffffc0203f5a:	177e                	slli	a4,a4,0x3f
ffffffffc0203f5c:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc0203f5e:	00a93023          	sd	a0,0(s2)
ffffffffc0203f62:	8fd9                	or	a5,a5,a4
ffffffffc0203f64:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203f68:	03050593          	addi	a1,a0,48
ffffffffc0203f6c:	03048513          	addi	a0,s1,48
ffffffffc0203f70:	7f7000ef          	jal	ra,ffffffffc0204f66 <switch_to>
    if (flag)
ffffffffc0203f74:	00099863          	bnez	s3,ffffffffc0203f84 <proc_run+0x52>
}
ffffffffc0203f78:	70a2                	ld	ra,40(sp)
ffffffffc0203f7a:	7482                	ld	s1,32(sp)
ffffffffc0203f7c:	6962                	ld	s2,24(sp)
ffffffffc0203f7e:	69c2                	ld	s3,16(sp)
ffffffffc0203f80:	6145                	addi	sp,sp,48
ffffffffc0203f82:	8082                	ret
ffffffffc0203f84:	70a2                	ld	ra,40(sp)
ffffffffc0203f86:	7482                	ld	s1,32(sp)
ffffffffc0203f88:	6962                	ld	s2,24(sp)
ffffffffc0203f8a:	69c2                	ld	s3,16(sp)
ffffffffc0203f8c:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203f8e:	a21fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc0203f92:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203f94:	a21fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0203f98:	6522                	ld	a0,8(sp)
ffffffffc0203f9a:	4985                	li	s3,1
ffffffffc0203f9c:	bf6d                	j	ffffffffc0203f56 <proc_run+0x24>

ffffffffc0203f9e <do_fork>:
{
ffffffffc0203f9e:	7119                	addi	sp,sp,-128
ffffffffc0203fa0:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203fa2:	000a6917          	auipc	s2,0xa6
ffffffffc0203fa6:	7b690913          	addi	s2,s2,1974 # ffffffffc02aa758 <nr_process>
ffffffffc0203faa:	00092703          	lw	a4,0(s2)
{
ffffffffc0203fae:	fc86                	sd	ra,120(sp)
ffffffffc0203fb0:	f8a2                	sd	s0,112(sp)
ffffffffc0203fb2:	f4a6                	sd	s1,104(sp)
ffffffffc0203fb4:	ecce                	sd	s3,88(sp)
ffffffffc0203fb6:	e8d2                	sd	s4,80(sp)
ffffffffc0203fb8:	e4d6                	sd	s5,72(sp)
ffffffffc0203fba:	e0da                	sd	s6,64(sp)
ffffffffc0203fbc:	fc5e                	sd	s7,56(sp)
ffffffffc0203fbe:	f862                	sd	s8,48(sp)
ffffffffc0203fc0:	f466                	sd	s9,40(sp)
ffffffffc0203fc2:	f06a                	sd	s10,32(sp)
ffffffffc0203fc4:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203fc6:	6785                	lui	a5,0x1
ffffffffc0203fc8:	2ef75b63          	bge	a4,a5,ffffffffc02042be <do_fork+0x320>
ffffffffc0203fcc:	8a2a                	mv	s4,a0
ffffffffc0203fce:	89ae                	mv	s3,a1
ffffffffc0203fd0:	8432                	mv	s0,a2
    proc = alloc_proc();
ffffffffc0203fd2:	dedff0ef          	jal	ra,ffffffffc0203dbe <alloc_proc>
ffffffffc0203fd6:	84aa                	mv	s1,a0
    if (!proc) {
ffffffffc0203fd8:	2e050863          	beqz	a0,ffffffffc02042c8 <do_fork+0x32a>
    proc->parent = current;
ffffffffc0203fdc:	000a6c17          	auipc	s8,0xa6
ffffffffc0203fe0:	764c0c13          	addi	s8,s8,1892 # ffffffffc02aa740 <current>
ffffffffc0203fe4:	000c3783          	ld	a5,0(s8)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203fe8:	4509                	li	a0,2
    proc->parent = current;
ffffffffc0203fea:	f09c                	sd	a5,32(s1)
    current->wait_state = 0;
ffffffffc0203fec:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8abc>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203ff0:	e99fd0ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
    if (page != NULL)
ffffffffc0203ff4:	2a050563          	beqz	a0,ffffffffc020429e <do_fork+0x300>
    return page - pages + nbase;
ffffffffc0203ff8:	000a6a97          	auipc	s5,0xa6
ffffffffc0203ffc:	730a8a93          	addi	s5,s5,1840 # ffffffffc02aa728 <pages>
ffffffffc0204000:	000ab683          	ld	a3,0(s5)
ffffffffc0204004:	00003b17          	auipc	s6,0x3
ffffffffc0204008:	7c4b0b13          	addi	s6,s6,1988 # ffffffffc02077c8 <nbase>
ffffffffc020400c:	000b3783          	ld	a5,0(s6)
ffffffffc0204010:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204014:	000a6b97          	auipc	s7,0xa6
ffffffffc0204018:	70cb8b93          	addi	s7,s7,1804 # ffffffffc02aa720 <npage>
    return page - pages + nbase;
ffffffffc020401c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020401e:	5dfd                	li	s11,-1
ffffffffc0204020:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204024:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204026:	00cddd93          	srli	s11,s11,0xc
ffffffffc020402a:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020402e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204030:	2ee67363          	bgeu	a2,a4,ffffffffc0204316 <do_fork+0x378>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204034:	000c3603          	ld	a2,0(s8)
ffffffffc0204038:	000a6c17          	auipc	s8,0xa6
ffffffffc020403c:	700c0c13          	addi	s8,s8,1792 # ffffffffc02aa738 <va_pa_offset>
ffffffffc0204040:	000c3703          	ld	a4,0(s8)
ffffffffc0204044:	02863d03          	ld	s10,40(a2)
ffffffffc0204048:	e43e                	sd	a5,8(sp)
ffffffffc020404a:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020404c:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc020404e:	020d0863          	beqz	s10,ffffffffc020407e <do_fork+0xe0>
    if (clone_flags & CLONE_VM)
ffffffffc0204052:	100a7a13          	andi	s4,s4,256
ffffffffc0204056:	180a0663          	beqz	s4,ffffffffc02041e2 <do_fork+0x244>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc020405a:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020405e:	018d3783          	ld	a5,24(s10)
ffffffffc0204062:	c02006b7          	lui	a3,0xc0200
ffffffffc0204066:	2705                	addiw	a4,a4,1
ffffffffc0204068:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc020406c:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204070:	26d7ea63          	bltu	a5,a3,ffffffffc02042e4 <do_fork+0x346>
ffffffffc0204074:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204078:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020407a:	8f99                	sub	a5,a5,a4
ffffffffc020407c:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020407e:	6789                	lui	a5,0x2
ffffffffc0204080:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cc8>
ffffffffc0204084:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0204086:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204088:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc020408a:	87b6                	mv	a5,a3
ffffffffc020408c:	12040893          	addi	a7,s0,288
ffffffffc0204090:	00063803          	ld	a6,0(a2)
ffffffffc0204094:	6608                	ld	a0,8(a2)
ffffffffc0204096:	6a0c                	ld	a1,16(a2)
ffffffffc0204098:	6e18                	ld	a4,24(a2)
ffffffffc020409a:	0107b023          	sd	a6,0(a5)
ffffffffc020409e:	e788                	sd	a0,8(a5)
ffffffffc02040a0:	eb8c                	sd	a1,16(a5)
ffffffffc02040a2:	ef98                	sd	a4,24(a5)
ffffffffc02040a4:	02060613          	addi	a2,a2,32
ffffffffc02040a8:	02078793          	addi	a5,a5,32
ffffffffc02040ac:	ff1612e3          	bne	a2,a7,ffffffffc0204090 <do_fork+0xf2>
    proc->tf->gpr.a0 = 0;
ffffffffc02040b0:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02040b4:	12098563          	beqz	s3,ffffffffc02041de <do_fork+0x240>
    if (++last_pid >= MAX_PID)
ffffffffc02040b8:	000a2317          	auipc	t1,0xa2
ffffffffc02040bc:	1f830313          	addi	t1,t1,504 # ffffffffc02a62b0 <last_pid.1>
ffffffffc02040c0:	00032783          	lw	a5,0(t1)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02040c4:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02040c8:	00000717          	auipc	a4,0x0
ffffffffc02040cc:	d6870713          	addi	a4,a4,-664 # ffffffffc0203e30 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc02040d0:	0017851b          	addiw	a0,a5,1
ffffffffc02040d4:	000a6617          	auipc	a2,0xa6
ffffffffc02040d8:	5fc60613          	addi	a2,a2,1532 # ffffffffc02aa6d0 <proc_list>
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02040dc:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02040de:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc02040e0:	00a32023          	sw	a0,0(t1)
ffffffffc02040e4:	6789                	lui	a5,0x2
ffffffffc02040e6:	00863883          	ld	a7,8(a2)
ffffffffc02040ea:	08f55863          	bge	a0,a5,ffffffffc020417a <do_fork+0x1dc>
    if (last_pid >= next_safe)
ffffffffc02040ee:	000a2e97          	auipc	t4,0xa2
ffffffffc02040f2:	1c6e8e93          	addi	t4,t4,454 # ffffffffc02a62b4 <next_safe.0>
ffffffffc02040f6:	000ea783          	lw	a5,0(t4)
ffffffffc02040fa:	08f55863          	bge	a0,a5,ffffffffc020418a <do_fork+0x1ec>
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02040fe:	7094                	ld	a3,32(s1)
    proc->pid = get_pid();// 调用get_pid()分配唯一的pid
ffffffffc0204100:	c0c8                	sw	a0,4(s1)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204102:	0c848793          	addi	a5,s1,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204106:	7af8                	ld	a4,240(a3)
    prev->next = next->prev = elm;
ffffffffc0204108:	00f8b023          	sd	a5,0(a7) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>
ffffffffc020410c:	e61c                	sd	a5,8(a2)
    elm->next = next;
ffffffffc020410e:	0d14b823          	sd	a7,208(s1)
    elm->prev = prev;
ffffffffc0204112:	e4f0                	sd	a2,200(s1)
    proc->yptr = NULL;
ffffffffc0204114:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204118:	10e4b023          	sd	a4,256(s1)
ffffffffc020411c:	c311                	beqz	a4,ffffffffc0204120 <do_fork+0x182>
        proc->optr->yptr = proc;
ffffffffc020411e:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0204120:	00092783          	lw	a5,0(s2)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204124:	45a9                	li	a1,10
    proc->parent->cptr = proc;
ffffffffc0204126:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204128:	2785                	addiw	a5,a5,1
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020412a:	2501                	sext.w	a0,a0
    nr_process++;
ffffffffc020412c:	00f92023          	sw	a5,0(s2)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204130:	08c010ef          	jal	ra,ffffffffc02051bc <hash32>
ffffffffc0204134:	02051713          	slli	a4,a0,0x20
ffffffffc0204138:	01c75793          	srli	a5,a4,0x1c
ffffffffc020413c:	000a2517          	auipc	a0,0xa2
ffffffffc0204140:	59450513          	addi	a0,a0,1428 # ffffffffc02a66d0 <hash_list>
ffffffffc0204144:	97aa                	add	a5,a5,a0
    __list_add(elm, listelm, listelm->next);
ffffffffc0204146:	6798                	ld	a4,8(a5)
ffffffffc0204148:	0d848693          	addi	a3,s1,216
    wakeup_proc(proc);
ffffffffc020414c:	8526                	mv	a0,s1
    prev->next = next->prev = elm;
ffffffffc020414e:	e314                	sd	a3,0(a4)
ffffffffc0204150:	e794                	sd	a3,8(a5)
    elm->next = next;
ffffffffc0204152:	f0f8                	sd	a4,224(s1)
    elm->prev = prev;
ffffffffc0204154:	ecfc                	sd	a5,216(s1)
ffffffffc0204156:	67b000ef          	jal	ra,ffffffffc0204fd0 <wakeup_proc>
    ret = proc->pid;
ffffffffc020415a:	40c8                	lw	a0,4(s1)
}
ffffffffc020415c:	70e6                	ld	ra,120(sp)
ffffffffc020415e:	7446                	ld	s0,112(sp)
ffffffffc0204160:	74a6                	ld	s1,104(sp)
ffffffffc0204162:	7906                	ld	s2,96(sp)
ffffffffc0204164:	69e6                	ld	s3,88(sp)
ffffffffc0204166:	6a46                	ld	s4,80(sp)
ffffffffc0204168:	6aa6                	ld	s5,72(sp)
ffffffffc020416a:	6b06                	ld	s6,64(sp)
ffffffffc020416c:	7be2                	ld	s7,56(sp)
ffffffffc020416e:	7c42                	ld	s8,48(sp)
ffffffffc0204170:	7ca2                	ld	s9,40(sp)
ffffffffc0204172:	7d02                	ld	s10,32(sp)
ffffffffc0204174:	6de2                	ld	s11,24(sp)
ffffffffc0204176:	6109                	addi	sp,sp,128
ffffffffc0204178:	8082                	ret
        last_pid = 1;
ffffffffc020417a:	4785                	li	a5,1
ffffffffc020417c:	00f32023          	sw	a5,0(t1)
        goto inside;
ffffffffc0204180:	4505                	li	a0,1
ffffffffc0204182:	000a2e97          	auipc	t4,0xa2
ffffffffc0204186:	132e8e93          	addi	t4,t4,306 # ffffffffc02a62b4 <next_safe.0>
        next_safe = MAX_PID;
ffffffffc020418a:	6789                	lui	a5,0x2
ffffffffc020418c:	00fea023          	sw	a5,0(t4)
ffffffffc0204190:	86aa                	mv	a3,a0
ffffffffc0204192:	4801                	li	a6,0
        while ((le = list_next(le)) != list)
ffffffffc0204194:	6f09                	lui	t5,0x2
ffffffffc0204196:	10c88e63          	beq	a7,a2,ffffffffc02042b2 <do_fork+0x314>
ffffffffc020419a:	8e42                	mv	t3,a6
ffffffffc020419c:	87c6                	mv	a5,a7
ffffffffc020419e:	6589                	lui	a1,0x2
ffffffffc02041a0:	a811                	j	ffffffffc02041b4 <do_fork+0x216>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02041a2:	00e6d663          	bge	a3,a4,ffffffffc02041ae <do_fork+0x210>
ffffffffc02041a6:	00b75463          	bge	a4,a1,ffffffffc02041ae <do_fork+0x210>
ffffffffc02041aa:	85ba                	mv	a1,a4
ffffffffc02041ac:	4e05                	li	t3,1
    return listelm->next;
ffffffffc02041ae:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02041b0:	00c78d63          	beq	a5,a2,ffffffffc02041ca <do_fork+0x22c>
            if (proc->pid == last_pid)
ffffffffc02041b4:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c6c>
ffffffffc02041b8:	fed715e3          	bne	a4,a3,ffffffffc02041a2 <do_fork+0x204>
                if (++last_pid >= next_safe)
ffffffffc02041bc:	2685                	addiw	a3,a3,1
ffffffffc02041be:	0eb6d563          	bge	a3,a1,ffffffffc02042a8 <do_fork+0x30a>
ffffffffc02041c2:	679c                	ld	a5,8(a5)
ffffffffc02041c4:	4805                	li	a6,1
        while ((le = list_next(le)) != list)
ffffffffc02041c6:	fec797e3          	bne	a5,a2,ffffffffc02041b4 <do_fork+0x216>
ffffffffc02041ca:	00080563          	beqz	a6,ffffffffc02041d4 <do_fork+0x236>
ffffffffc02041ce:	00d32023          	sw	a3,0(t1)
ffffffffc02041d2:	8536                	mv	a0,a3
ffffffffc02041d4:	f20e05e3          	beqz	t3,ffffffffc02040fe <do_fork+0x160>
ffffffffc02041d8:	00bea023          	sw	a1,0(t4)
ffffffffc02041dc:	b70d                	j	ffffffffc02040fe <do_fork+0x160>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02041de:	89b6                	mv	s3,a3
ffffffffc02041e0:	bde1                	j	ffffffffc02040b8 <do_fork+0x11a>
    if ((mm = mm_create()) == NULL)
ffffffffc02041e2:	ccaff0ef          	jal	ra,ffffffffc02036ac <mm_create>
ffffffffc02041e6:	8caa                	mv	s9,a0
ffffffffc02041e8:	c159                	beqz	a0,ffffffffc020426e <do_fork+0x2d0>
    if ((page = alloc_page()) == NULL)
ffffffffc02041ea:	4505                	li	a0,1
ffffffffc02041ec:	c9dfd0ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc02041f0:	cd25                	beqz	a0,ffffffffc0204268 <do_fork+0x2ca>
    return page - pages + nbase;
ffffffffc02041f2:	000ab683          	ld	a3,0(s5)
ffffffffc02041f6:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc02041f8:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc02041fc:	40d506b3          	sub	a3,a0,a3
ffffffffc0204200:	8699                	srai	a3,a3,0x6
ffffffffc0204202:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204204:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204208:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020420a:	10edf663          	bgeu	s11,a4,ffffffffc0204316 <do_fork+0x378>
ffffffffc020420e:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204212:	6605                	lui	a2,0x1
ffffffffc0204214:	000a6597          	auipc	a1,0xa6
ffffffffc0204218:	5045b583          	ld	a1,1284(a1) # ffffffffc02aa718 <boot_pgdir_va>
ffffffffc020421c:	9a36                	add	s4,s4,a3
ffffffffc020421e:	8552                	mv	a0,s4
ffffffffc0204220:	454010ef          	jal	ra,ffffffffc0205674 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204224:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc0204228:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020422c:	4785                	li	a5,1
ffffffffc020422e:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204232:	8b85                	andi	a5,a5,1
ffffffffc0204234:	4a05                	li	s4,1
ffffffffc0204236:	c799                	beqz	a5,ffffffffc0204244 <do_fork+0x2a6>
    {
        schedule();
ffffffffc0204238:	619000ef          	jal	ra,ffffffffc0205050 <schedule>
ffffffffc020423c:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc0204240:	8b85                	andi	a5,a5,1
ffffffffc0204242:	fbfd                	bnez	a5,ffffffffc0204238 <do_fork+0x29a>
        ret = dup_mmap(mm, oldmm);
ffffffffc0204244:	85ea                	mv	a1,s10
ffffffffc0204246:	8566                	mv	a0,s9
ffffffffc0204248:	ea6ff0ef          	jal	ra,ffffffffc02038ee <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020424c:	57f9                	li	a5,-2
ffffffffc020424e:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc0204252:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc0204254:	cfa5                	beqz	a5,ffffffffc02042cc <do_fork+0x32e>
good_mm:
ffffffffc0204256:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc0204258:	e00501e3          	beqz	a0,ffffffffc020405a <do_fork+0xbc>
    exit_mmap(mm);
ffffffffc020425c:	8566                	mv	a0,s9
ffffffffc020425e:	f2aff0ef          	jal	ra,ffffffffc0203988 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204262:	8566                	mv	a0,s9
ffffffffc0204264:	c59ff0ef          	jal	ra,ffffffffc0203ebc <put_pgdir>
    mm_destroy(mm);
ffffffffc0204268:	8566                	mv	a0,s9
ffffffffc020426a:	d82ff0ef          	jal	ra,ffffffffc02037ec <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020426e:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc0204270:	c02007b7          	lui	a5,0xc0200
ffffffffc0204274:	0af6ed63          	bltu	a3,a5,ffffffffc020432e <do_fork+0x390>
ffffffffc0204278:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc020427c:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0204280:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204284:	83b1                	srli	a5,a5,0xc
ffffffffc0204286:	06e7fc63          	bgeu	a5,a4,ffffffffc02042fe <do_fork+0x360>
    return &pages[PPN(pa) - nbase];
ffffffffc020428a:	000b3703          	ld	a4,0(s6)
ffffffffc020428e:	000ab503          	ld	a0,0(s5)
ffffffffc0204292:	4589                	li	a1,2
ffffffffc0204294:	8f99                	sub	a5,a5,a4
ffffffffc0204296:	079a                	slli	a5,a5,0x6
ffffffffc0204298:	953e                	add	a0,a0,a5
ffffffffc020429a:	c2dfd0ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    kfree(proc);
ffffffffc020429e:	8526                	mv	a0,s1
ffffffffc02042a0:	abbfd0ef          	jal	ra,ffffffffc0201d5a <kfree>
    ret = -E_NO_MEM;
ffffffffc02042a4:	5571                	li	a0,-4
    goto fork_out;
ffffffffc02042a6:	bd5d                	j	ffffffffc020415c <do_fork+0x1be>
                    if (last_pid >= MAX_PID)
ffffffffc02042a8:	01e6c363          	blt	a3,t5,ffffffffc02042ae <do_fork+0x310>
                        last_pid = 1;
ffffffffc02042ac:	4685                	li	a3,1
                    goto repeat;
ffffffffc02042ae:	4805                	li	a6,1
ffffffffc02042b0:	b5dd                	j	ffffffffc0204196 <do_fork+0x1f8>
ffffffffc02042b2:	00080863          	beqz	a6,ffffffffc02042c2 <do_fork+0x324>
ffffffffc02042b6:	00d32023          	sw	a3,0(t1)
    return last_pid;
ffffffffc02042ba:	8536                	mv	a0,a3
ffffffffc02042bc:	b589                	j	ffffffffc02040fe <do_fork+0x160>
    int ret = -E_NO_FREE_PROC;
ffffffffc02042be:	556d                	li	a0,-5
ffffffffc02042c0:	bd71                	j	ffffffffc020415c <do_fork+0x1be>
    return last_pid;
ffffffffc02042c2:	00032503          	lw	a0,0(t1)
ffffffffc02042c6:	bd25                	j	ffffffffc02040fe <do_fork+0x160>
    ret = -E_NO_MEM;
ffffffffc02042c8:	5571                	li	a0,-4
ffffffffc02042ca:	bd49                	j	ffffffffc020415c <do_fork+0x1be>
    {
        panic("Unlock failed.\n");
ffffffffc02042cc:	00003617          	auipc	a2,0x3
ffffffffc02042d0:	c7c60613          	addi	a2,a2,-900 # ffffffffc0206f48 <default_pmm_manager+0xa88>
ffffffffc02042d4:	03f00593          	li	a1,63
ffffffffc02042d8:	00003517          	auipc	a0,0x3
ffffffffc02042dc:	c8050513          	addi	a0,a0,-896 # ffffffffc0206f58 <default_pmm_manager+0xa98>
ffffffffc02042e0:	9aefc0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042e4:	86be                	mv	a3,a5
ffffffffc02042e6:	00002617          	auipc	a2,0x2
ffffffffc02042ea:	2ba60613          	addi	a2,a2,698 # ffffffffc02065a0 <default_pmm_manager+0xe0>
ffffffffc02042ee:	19600593          	li	a1,406
ffffffffc02042f2:	00003517          	auipc	a0,0x3
ffffffffc02042f6:	c3e50513          	addi	a0,a0,-962 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc02042fa:	994fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02042fe:	00002617          	auipc	a2,0x2
ffffffffc0204302:	2ca60613          	addi	a2,a2,714 # ffffffffc02065c8 <default_pmm_manager+0x108>
ffffffffc0204306:	06900593          	li	a1,105
ffffffffc020430a:	00002517          	auipc	a0,0x2
ffffffffc020430e:	21650513          	addi	a0,a0,534 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0204312:	97cfc0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0204316:	00002617          	auipc	a2,0x2
ffffffffc020431a:	1e260613          	addi	a2,a2,482 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc020431e:	07100593          	li	a1,113
ffffffffc0204322:	00002517          	auipc	a0,0x2
ffffffffc0204326:	1fe50513          	addi	a0,a0,510 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc020432a:	964fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc020432e:	00002617          	auipc	a2,0x2
ffffffffc0204332:	27260613          	addi	a2,a2,626 # ffffffffc02065a0 <default_pmm_manager+0xe0>
ffffffffc0204336:	07700593          	li	a1,119
ffffffffc020433a:	00002517          	auipc	a0,0x2
ffffffffc020433e:	1e650513          	addi	a0,a0,486 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0204342:	94cfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204346 <kernel_thread>:
{
ffffffffc0204346:	7129                	addi	sp,sp,-320
ffffffffc0204348:	fa22                	sd	s0,304(sp)
ffffffffc020434a:	f626                	sd	s1,296(sp)
ffffffffc020434c:	f24a                	sd	s2,288(sp)
ffffffffc020434e:	84ae                	mv	s1,a1
ffffffffc0204350:	892a                	mv	s2,a0
ffffffffc0204352:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204354:	4581                	li	a1,0
ffffffffc0204356:	12000613          	li	a2,288
ffffffffc020435a:	850a                	mv	a0,sp
{
ffffffffc020435c:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020435e:	304010ef          	jal	ra,ffffffffc0205662 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0204362:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204364:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204366:	100027f3          	csrr	a5,sstatus
ffffffffc020436a:	edd7f793          	andi	a5,a5,-291
ffffffffc020436e:	1207e793          	ori	a5,a5,288
ffffffffc0204372:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204374:	860a                	mv	a2,sp
ffffffffc0204376:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020437a:	00000797          	auipc	a5,0x0
ffffffffc020437e:	a3c78793          	addi	a5,a5,-1476 # ffffffffc0203db6 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204382:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204384:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204386:	c19ff0ef          	jal	ra,ffffffffc0203f9e <do_fork>
}
ffffffffc020438a:	70f2                	ld	ra,312(sp)
ffffffffc020438c:	7452                	ld	s0,304(sp)
ffffffffc020438e:	74b2                	ld	s1,296(sp)
ffffffffc0204390:	7912                	ld	s2,288(sp)
ffffffffc0204392:	6131                	addi	sp,sp,320
ffffffffc0204394:	8082                	ret

ffffffffc0204396 <do_exit>:
{
ffffffffc0204396:	7179                	addi	sp,sp,-48
ffffffffc0204398:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc020439a:	000a6417          	auipc	s0,0xa6
ffffffffc020439e:	3a640413          	addi	s0,s0,934 # ffffffffc02aa740 <current>
ffffffffc02043a2:	601c                	ld	a5,0(s0)
{
ffffffffc02043a4:	f406                	sd	ra,40(sp)
ffffffffc02043a6:	ec26                	sd	s1,24(sp)
ffffffffc02043a8:	e84a                	sd	s2,16(sp)
ffffffffc02043aa:	e44e                	sd	s3,8(sp)
ffffffffc02043ac:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc02043ae:	000a6717          	auipc	a4,0xa6
ffffffffc02043b2:	39a73703          	ld	a4,922(a4) # ffffffffc02aa748 <idleproc>
ffffffffc02043b6:	0ce78c63          	beq	a5,a4,ffffffffc020448e <do_exit+0xf8>
    if (current == initproc)
ffffffffc02043ba:	000a6497          	auipc	s1,0xa6
ffffffffc02043be:	39648493          	addi	s1,s1,918 # ffffffffc02aa750 <initproc>
ffffffffc02043c2:	6098                	ld	a4,0(s1)
ffffffffc02043c4:	0ee78b63          	beq	a5,a4,ffffffffc02044ba <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc02043c8:	0287b983          	ld	s3,40(a5)
ffffffffc02043cc:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc02043ce:	02098663          	beqz	s3,ffffffffc02043fa <do_exit+0x64>
ffffffffc02043d2:	000a6797          	auipc	a5,0xa6
ffffffffc02043d6:	33e7b783          	ld	a5,830(a5) # ffffffffc02aa710 <boot_pgdir_pa>
ffffffffc02043da:	577d                	li	a4,-1
ffffffffc02043dc:	177e                	slli	a4,a4,0x3f
ffffffffc02043de:	83b1                	srli	a5,a5,0xc
ffffffffc02043e0:	8fd9                	or	a5,a5,a4
ffffffffc02043e2:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc02043e6:	0309a783          	lw	a5,48(s3)
ffffffffc02043ea:	fff7871b          	addiw	a4,a5,-1
ffffffffc02043ee:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc02043f2:	cb55                	beqz	a4,ffffffffc02044a6 <do_exit+0x110>
        current->mm = NULL;
ffffffffc02043f4:	601c                	ld	a5,0(s0)
ffffffffc02043f6:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc02043fa:	601c                	ld	a5,0(s0)
ffffffffc02043fc:	470d                	li	a4,3
ffffffffc02043fe:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204400:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204404:	100027f3          	csrr	a5,sstatus
ffffffffc0204408:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020440a:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020440c:	e3f9                	bnez	a5,ffffffffc02044d2 <do_exit+0x13c>
        proc = current->parent;
ffffffffc020440e:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204410:	800007b7          	lui	a5,0x80000
ffffffffc0204414:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204416:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204418:	0ec52703          	lw	a4,236(a0)
ffffffffc020441c:	0af70f63          	beq	a4,a5,ffffffffc02044da <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc0204420:	6018                	ld	a4,0(s0)
ffffffffc0204422:	7b7c                	ld	a5,240(a4)
ffffffffc0204424:	c3a1                	beqz	a5,ffffffffc0204464 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204426:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc020442a:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc020442c:	0985                	addi	s3,s3,1
ffffffffc020442e:	a021                	j	ffffffffc0204436 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc0204430:	6018                	ld	a4,0(s0)
ffffffffc0204432:	7b7c                	ld	a5,240(a4)
ffffffffc0204434:	cb85                	beqz	a5,ffffffffc0204464 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0204436:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fe0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020443a:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc020443c:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020443e:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc0204440:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204444:	10e7b023          	sd	a4,256(a5)
ffffffffc0204448:	c311                	beqz	a4,ffffffffc020444c <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc020444a:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020444c:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc020444e:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0204450:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204452:	fd271fe3          	bne	a4,s2,ffffffffc0204430 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204456:	0ec52783          	lw	a5,236(a0)
ffffffffc020445a:	fd379be3          	bne	a5,s3,ffffffffc0204430 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc020445e:	373000ef          	jal	ra,ffffffffc0204fd0 <wakeup_proc>
ffffffffc0204462:	b7f9                	j	ffffffffc0204430 <do_exit+0x9a>
    if (flag)
ffffffffc0204464:	020a1263          	bnez	s4,ffffffffc0204488 <do_exit+0xf2>
    schedule();
ffffffffc0204468:	3e9000ef          	jal	ra,ffffffffc0205050 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc020446c:	601c                	ld	a5,0(s0)
ffffffffc020446e:	00003617          	auipc	a2,0x3
ffffffffc0204472:	b2260613          	addi	a2,a2,-1246 # ffffffffc0206f90 <default_pmm_manager+0xad0>
ffffffffc0204476:	24e00593          	li	a1,590
ffffffffc020447a:	43d4                	lw	a3,4(a5)
ffffffffc020447c:	00003517          	auipc	a0,0x3
ffffffffc0204480:	ab450513          	addi	a0,a0,-1356 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204484:	80afc0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc0204488:	d26fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020448c:	bff1                	j	ffffffffc0204468 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc020448e:	00003617          	auipc	a2,0x3
ffffffffc0204492:	ae260613          	addi	a2,a2,-1310 # ffffffffc0206f70 <default_pmm_manager+0xab0>
ffffffffc0204496:	21a00593          	li	a1,538
ffffffffc020449a:	00003517          	auipc	a0,0x3
ffffffffc020449e:	a9650513          	addi	a0,a0,-1386 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc02044a2:	fedfb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc02044a6:	854e                	mv	a0,s3
ffffffffc02044a8:	ce0ff0ef          	jal	ra,ffffffffc0203988 <exit_mmap>
            put_pgdir(mm);
ffffffffc02044ac:	854e                	mv	a0,s3
ffffffffc02044ae:	a0fff0ef          	jal	ra,ffffffffc0203ebc <put_pgdir>
            mm_destroy(mm);
ffffffffc02044b2:	854e                	mv	a0,s3
ffffffffc02044b4:	b38ff0ef          	jal	ra,ffffffffc02037ec <mm_destroy>
ffffffffc02044b8:	bf35                	j	ffffffffc02043f4 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc02044ba:	00003617          	auipc	a2,0x3
ffffffffc02044be:	ac660613          	addi	a2,a2,-1338 # ffffffffc0206f80 <default_pmm_manager+0xac0>
ffffffffc02044c2:	21e00593          	li	a1,542
ffffffffc02044c6:	00003517          	auipc	a0,0x3
ffffffffc02044ca:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc02044ce:	fc1fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc02044d2:	ce2fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02044d6:	4a05                	li	s4,1
ffffffffc02044d8:	bf1d                	j	ffffffffc020440e <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc02044da:	2f7000ef          	jal	ra,ffffffffc0204fd0 <wakeup_proc>
ffffffffc02044de:	b789                	j	ffffffffc0204420 <do_exit+0x8a>

ffffffffc02044e0 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc02044e0:	715d                	addi	sp,sp,-80
ffffffffc02044e2:	f84a                	sd	s2,48(sp)
ffffffffc02044e4:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc02044e6:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc02044ea:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc02044ec:	fc26                	sd	s1,56(sp)
ffffffffc02044ee:	f052                	sd	s4,32(sp)
ffffffffc02044f0:	ec56                	sd	s5,24(sp)
ffffffffc02044f2:	e85a                	sd	s6,16(sp)
ffffffffc02044f4:	e45e                	sd	s7,8(sp)
ffffffffc02044f6:	e486                	sd	ra,72(sp)
ffffffffc02044f8:	e0a2                	sd	s0,64(sp)
ffffffffc02044fa:	84aa                	mv	s1,a0
ffffffffc02044fc:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc02044fe:	000a6b97          	auipc	s7,0xa6
ffffffffc0204502:	242b8b93          	addi	s7,s7,578 # ffffffffc02aa740 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204506:	00050b1b          	sext.w	s6,a0
ffffffffc020450a:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020450e:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc0204510:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204512:	ccbd                	beqz	s1,ffffffffc0204590 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204514:	0359e863          	bltu	s3,s5,ffffffffc0204544 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204518:	45a9                	li	a1,10
ffffffffc020451a:	855a                	mv	a0,s6
ffffffffc020451c:	4a1000ef          	jal	ra,ffffffffc02051bc <hash32>
ffffffffc0204520:	02051793          	slli	a5,a0,0x20
ffffffffc0204524:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204528:	000a2797          	auipc	a5,0xa2
ffffffffc020452c:	1a878793          	addi	a5,a5,424 # ffffffffc02a66d0 <hash_list>
ffffffffc0204530:	953e                	add	a0,a0,a5
ffffffffc0204532:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc0204534:	a029                	j	ffffffffc020453e <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc0204536:	f2c42783          	lw	a5,-212(s0)
ffffffffc020453a:	02978163          	beq	a5,s1,ffffffffc020455c <do_wait.part.0+0x7c>
ffffffffc020453e:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc0204540:	fe851be3          	bne	a0,s0,ffffffffc0204536 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc0204544:	5579                	li	a0,-2
}
ffffffffc0204546:	60a6                	ld	ra,72(sp)
ffffffffc0204548:	6406                	ld	s0,64(sp)
ffffffffc020454a:	74e2                	ld	s1,56(sp)
ffffffffc020454c:	7942                	ld	s2,48(sp)
ffffffffc020454e:	79a2                	ld	s3,40(sp)
ffffffffc0204550:	7a02                	ld	s4,32(sp)
ffffffffc0204552:	6ae2                	ld	s5,24(sp)
ffffffffc0204554:	6b42                	ld	s6,16(sp)
ffffffffc0204556:	6ba2                	ld	s7,8(sp)
ffffffffc0204558:	6161                	addi	sp,sp,80
ffffffffc020455a:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc020455c:	000bb683          	ld	a3,0(s7)
ffffffffc0204560:	f4843783          	ld	a5,-184(s0)
ffffffffc0204564:	fed790e3          	bne	a5,a3,ffffffffc0204544 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204568:	f2842703          	lw	a4,-216(s0)
ffffffffc020456c:	478d                	li	a5,3
ffffffffc020456e:	0ef70b63          	beq	a4,a5,ffffffffc0204664 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc0204572:	4785                	li	a5,1
ffffffffc0204574:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0204576:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc020457a:	2d7000ef          	jal	ra,ffffffffc0205050 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc020457e:	000bb783          	ld	a5,0(s7)
ffffffffc0204582:	0b07a783          	lw	a5,176(a5)
ffffffffc0204586:	8b85                	andi	a5,a5,1
ffffffffc0204588:	d7c9                	beqz	a5,ffffffffc0204512 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc020458a:	555d                	li	a0,-9
ffffffffc020458c:	e0bff0ef          	jal	ra,ffffffffc0204396 <do_exit>
        proc = current->cptr;
ffffffffc0204590:	000bb683          	ld	a3,0(s7)
ffffffffc0204594:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204596:	d45d                	beqz	s0,ffffffffc0204544 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204598:	470d                	li	a4,3
ffffffffc020459a:	a021                	j	ffffffffc02045a2 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc020459c:	10043403          	ld	s0,256(s0)
ffffffffc02045a0:	d869                	beqz	s0,ffffffffc0204572 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045a2:	401c                	lw	a5,0(s0)
ffffffffc02045a4:	fee79ce3          	bne	a5,a4,ffffffffc020459c <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc02045a8:	000a6797          	auipc	a5,0xa6
ffffffffc02045ac:	1a07b783          	ld	a5,416(a5) # ffffffffc02aa748 <idleproc>
ffffffffc02045b0:	0c878963          	beq	a5,s0,ffffffffc0204682 <do_wait.part.0+0x1a2>
ffffffffc02045b4:	000a6797          	auipc	a5,0xa6
ffffffffc02045b8:	19c7b783          	ld	a5,412(a5) # ffffffffc02aa750 <initproc>
ffffffffc02045bc:	0cf40363          	beq	s0,a5,ffffffffc0204682 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc02045c0:	000a0663          	beqz	s4,ffffffffc02045cc <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc02045c4:	0e842783          	lw	a5,232(s0)
ffffffffc02045c8:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02045cc:	100027f3          	csrr	a5,sstatus
ffffffffc02045d0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02045d2:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02045d4:	e7c1                	bnez	a5,ffffffffc020465c <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc02045d6:	6c70                	ld	a2,216(s0)
ffffffffc02045d8:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc02045da:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc02045de:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc02045e0:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02045e2:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02045e4:	6470                	ld	a2,200(s0)
ffffffffc02045e6:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc02045e8:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02045ea:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc02045ec:	c319                	beqz	a4,ffffffffc02045f2 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc02045ee:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc02045f0:	7c7c                	ld	a5,248(s0)
ffffffffc02045f2:	c3b5                	beqz	a5,ffffffffc0204656 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc02045f4:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc02045f8:	000a6717          	auipc	a4,0xa6
ffffffffc02045fc:	16070713          	addi	a4,a4,352 # ffffffffc02aa758 <nr_process>
ffffffffc0204600:	431c                	lw	a5,0(a4)
ffffffffc0204602:	37fd                	addiw	a5,a5,-1
ffffffffc0204604:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc0204606:	e5a9                	bnez	a1,ffffffffc0204650 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204608:	6814                	ld	a3,16(s0)
ffffffffc020460a:	c02007b7          	lui	a5,0xc0200
ffffffffc020460e:	04f6ee63          	bltu	a3,a5,ffffffffc020466a <do_wait.part.0+0x18a>
ffffffffc0204612:	000a6797          	auipc	a5,0xa6
ffffffffc0204616:	1267b783          	ld	a5,294(a5) # ffffffffc02aa738 <va_pa_offset>
ffffffffc020461a:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020461c:	82b1                	srli	a3,a3,0xc
ffffffffc020461e:	000a6797          	auipc	a5,0xa6
ffffffffc0204622:	1027b783          	ld	a5,258(a5) # ffffffffc02aa720 <npage>
ffffffffc0204626:	06f6fa63          	bgeu	a3,a5,ffffffffc020469a <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc020462a:	00003517          	auipc	a0,0x3
ffffffffc020462e:	19e53503          	ld	a0,414(a0) # ffffffffc02077c8 <nbase>
ffffffffc0204632:	8e89                	sub	a3,a3,a0
ffffffffc0204634:	069a                	slli	a3,a3,0x6
ffffffffc0204636:	000a6517          	auipc	a0,0xa6
ffffffffc020463a:	0f253503          	ld	a0,242(a0) # ffffffffc02aa728 <pages>
ffffffffc020463e:	9536                	add	a0,a0,a3
ffffffffc0204640:	4589                	li	a1,2
ffffffffc0204642:	885fd0ef          	jal	ra,ffffffffc0201ec6 <free_pages>
    kfree(proc);
ffffffffc0204646:	8522                	mv	a0,s0
ffffffffc0204648:	f12fd0ef          	jal	ra,ffffffffc0201d5a <kfree>
    return 0;
ffffffffc020464c:	4501                	li	a0,0
ffffffffc020464e:	bde5                	j	ffffffffc0204546 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc0204650:	b5efc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204654:	bf55                	j	ffffffffc0204608 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc0204656:	701c                	ld	a5,32(s0)
ffffffffc0204658:	fbf8                	sd	a4,240(a5)
ffffffffc020465a:	bf79                	j	ffffffffc02045f8 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc020465c:	b58fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204660:	4585                	li	a1,1
ffffffffc0204662:	bf95                	j	ffffffffc02045d6 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204664:	f2840413          	addi	s0,s0,-216
ffffffffc0204668:	b781                	j	ffffffffc02045a8 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc020466a:	00002617          	auipc	a2,0x2
ffffffffc020466e:	f3660613          	addi	a2,a2,-202 # ffffffffc02065a0 <default_pmm_manager+0xe0>
ffffffffc0204672:	07700593          	li	a1,119
ffffffffc0204676:	00002517          	auipc	a0,0x2
ffffffffc020467a:	eaa50513          	addi	a0,a0,-342 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc020467e:	e11fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0204682:	00003617          	auipc	a2,0x3
ffffffffc0204686:	92e60613          	addi	a2,a2,-1746 # ffffffffc0206fb0 <default_pmm_manager+0xaf0>
ffffffffc020468a:	37500593          	li	a1,885
ffffffffc020468e:	00003517          	auipc	a0,0x3
ffffffffc0204692:	8a250513          	addi	a0,a0,-1886 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204696:	df9fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020469a:	00002617          	auipc	a2,0x2
ffffffffc020469e:	f2e60613          	addi	a2,a2,-210 # ffffffffc02065c8 <default_pmm_manager+0x108>
ffffffffc02046a2:	06900593          	li	a1,105
ffffffffc02046a6:	00002517          	auipc	a0,0x2
ffffffffc02046aa:	e7a50513          	addi	a0,a0,-390 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc02046ae:	de1fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02046b2 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02046b2:	1141                	addi	sp,sp,-16
ffffffffc02046b4:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02046b6:	851fd0ef          	jal	ra,ffffffffc0201f06 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc02046ba:	decfd0ef          	jal	ra,ffffffffc0201ca6 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc02046be:	4601                	li	a2,0
ffffffffc02046c0:	4581                	li	a1,0
ffffffffc02046c2:	fffff517          	auipc	a0,0xfffff
ffffffffc02046c6:	77c50513          	addi	a0,a0,1916 # ffffffffc0203e3e <user_main>
ffffffffc02046ca:	c7dff0ef          	jal	ra,ffffffffc0204346 <kernel_thread>
    if (pid <= 0)
ffffffffc02046ce:	00a04563          	bgtz	a0,ffffffffc02046d8 <init_main+0x26>
ffffffffc02046d2:	a071                	j	ffffffffc020475e <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc02046d4:	17d000ef          	jal	ra,ffffffffc0205050 <schedule>
    if (code_store != NULL)
ffffffffc02046d8:	4581                	li	a1,0
ffffffffc02046da:	4501                	li	a0,0
ffffffffc02046dc:	e05ff0ef          	jal	ra,ffffffffc02044e0 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc02046e0:	d975                	beqz	a0,ffffffffc02046d4 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc02046e2:	00003517          	auipc	a0,0x3
ffffffffc02046e6:	90e50513          	addi	a0,a0,-1778 # ffffffffc0206ff0 <default_pmm_manager+0xb30>
ffffffffc02046ea:	aabfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02046ee:	000a6797          	auipc	a5,0xa6
ffffffffc02046f2:	0627b783          	ld	a5,98(a5) # ffffffffc02aa750 <initproc>
ffffffffc02046f6:	7bf8                	ld	a4,240(a5)
ffffffffc02046f8:	e339                	bnez	a4,ffffffffc020473e <init_main+0x8c>
ffffffffc02046fa:	7ff8                	ld	a4,248(a5)
ffffffffc02046fc:	e329                	bnez	a4,ffffffffc020473e <init_main+0x8c>
ffffffffc02046fe:	1007b703          	ld	a4,256(a5)
ffffffffc0204702:	ef15                	bnez	a4,ffffffffc020473e <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204704:	000a6697          	auipc	a3,0xa6
ffffffffc0204708:	0546a683          	lw	a3,84(a3) # ffffffffc02aa758 <nr_process>
ffffffffc020470c:	4709                	li	a4,2
ffffffffc020470e:	0ae69463          	bne	a3,a4,ffffffffc02047b6 <init_main+0x104>
    return listelm->next;
ffffffffc0204712:	000a6697          	auipc	a3,0xa6
ffffffffc0204716:	fbe68693          	addi	a3,a3,-66 # ffffffffc02aa6d0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc020471a:	6698                	ld	a4,8(a3)
ffffffffc020471c:	0c878793          	addi	a5,a5,200
ffffffffc0204720:	06f71b63          	bne	a4,a5,ffffffffc0204796 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204724:	629c                	ld	a5,0(a3)
ffffffffc0204726:	04f71863          	bne	a4,a5,ffffffffc0204776 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc020472a:	00003517          	auipc	a0,0x3
ffffffffc020472e:	9ae50513          	addi	a0,a0,-1618 # ffffffffc02070d8 <default_pmm_manager+0xc18>
ffffffffc0204732:	a63fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204736:	60a2                	ld	ra,8(sp)
ffffffffc0204738:	4501                	li	a0,0
ffffffffc020473a:	0141                	addi	sp,sp,16
ffffffffc020473c:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020473e:	00003697          	auipc	a3,0x3
ffffffffc0204742:	8da68693          	addi	a3,a3,-1830 # ffffffffc0207018 <default_pmm_manager+0xb58>
ffffffffc0204746:	00002617          	auipc	a2,0x2
ffffffffc020474a:	9ca60613          	addi	a2,a2,-1590 # ffffffffc0206110 <commands+0x818>
ffffffffc020474e:	3e300593          	li	a1,995
ffffffffc0204752:	00002517          	auipc	a0,0x2
ffffffffc0204756:	7de50513          	addi	a0,a0,2014 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc020475a:	d35fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc020475e:	00003617          	auipc	a2,0x3
ffffffffc0204762:	87260613          	addi	a2,a2,-1934 # ffffffffc0206fd0 <default_pmm_manager+0xb10>
ffffffffc0204766:	3da00593          	li	a1,986
ffffffffc020476a:	00002517          	auipc	a0,0x2
ffffffffc020476e:	7c650513          	addi	a0,a0,1990 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204772:	d1dfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204776:	00003697          	auipc	a3,0x3
ffffffffc020477a:	93268693          	addi	a3,a3,-1742 # ffffffffc02070a8 <default_pmm_manager+0xbe8>
ffffffffc020477e:	00002617          	auipc	a2,0x2
ffffffffc0204782:	99260613          	addi	a2,a2,-1646 # ffffffffc0206110 <commands+0x818>
ffffffffc0204786:	3e600593          	li	a1,998
ffffffffc020478a:	00002517          	auipc	a0,0x2
ffffffffc020478e:	7a650513          	addi	a0,a0,1958 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204792:	cfdfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204796:	00003697          	auipc	a3,0x3
ffffffffc020479a:	8e268693          	addi	a3,a3,-1822 # ffffffffc0207078 <default_pmm_manager+0xbb8>
ffffffffc020479e:	00002617          	auipc	a2,0x2
ffffffffc02047a2:	97260613          	addi	a2,a2,-1678 # ffffffffc0206110 <commands+0x818>
ffffffffc02047a6:	3e500593          	li	a1,997
ffffffffc02047aa:	00002517          	auipc	a0,0x2
ffffffffc02047ae:	78650513          	addi	a0,a0,1926 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc02047b2:	cddfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc02047b6:	00003697          	auipc	a3,0x3
ffffffffc02047ba:	8b268693          	addi	a3,a3,-1870 # ffffffffc0207068 <default_pmm_manager+0xba8>
ffffffffc02047be:	00002617          	auipc	a2,0x2
ffffffffc02047c2:	95260613          	addi	a2,a2,-1710 # ffffffffc0206110 <commands+0x818>
ffffffffc02047c6:	3e400593          	li	a1,996
ffffffffc02047ca:	00002517          	auipc	a0,0x2
ffffffffc02047ce:	76650513          	addi	a0,a0,1894 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc02047d2:	cbdfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02047d6 <do_execve>:
{
ffffffffc02047d6:	7171                	addi	sp,sp,-176
ffffffffc02047d8:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02047da:	000a6d97          	auipc	s11,0xa6
ffffffffc02047de:	f66d8d93          	addi	s11,s11,-154 # ffffffffc02aa740 <current>
ffffffffc02047e2:	000db783          	ld	a5,0(s11)
{
ffffffffc02047e6:	e54e                	sd	s3,136(sp)
ffffffffc02047e8:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02047ea:	0287b983          	ld	s3,40(a5)
{
ffffffffc02047ee:	e94a                	sd	s2,144(sp)
ffffffffc02047f0:	f4de                	sd	s7,104(sp)
ffffffffc02047f2:	892a                	mv	s2,a0
ffffffffc02047f4:	8bb2                	mv	s7,a2
ffffffffc02047f6:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02047f8:	862e                	mv	a2,a1
ffffffffc02047fa:	4681                	li	a3,0
ffffffffc02047fc:	85aa                	mv	a1,a0
ffffffffc02047fe:	854e                	mv	a0,s3
{
ffffffffc0204800:	f506                	sd	ra,168(sp)
ffffffffc0204802:	f122                	sd	s0,160(sp)
ffffffffc0204804:	e152                	sd	s4,128(sp)
ffffffffc0204806:	fcd6                	sd	s5,120(sp)
ffffffffc0204808:	f8da                	sd	s6,112(sp)
ffffffffc020480a:	f0e2                	sd	s8,96(sp)
ffffffffc020480c:	ece6                	sd	s9,88(sp)
ffffffffc020480e:	e8ea                	sd	s10,80(sp)
ffffffffc0204810:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204812:	d10ff0ef          	jal	ra,ffffffffc0203d22 <user_mem_check>
ffffffffc0204816:	40050a63          	beqz	a0,ffffffffc0204c2a <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc020481a:	4641                	li	a2,16
ffffffffc020481c:	4581                	li	a1,0
ffffffffc020481e:	1808                	addi	a0,sp,48
ffffffffc0204820:	643000ef          	jal	ra,ffffffffc0205662 <memset>
    memcpy(local_name, name, len);
ffffffffc0204824:	47bd                	li	a5,15
ffffffffc0204826:	8626                	mv	a2,s1
ffffffffc0204828:	1e97e263          	bltu	a5,s1,ffffffffc0204a0c <do_execve+0x236>
ffffffffc020482c:	85ca                	mv	a1,s2
ffffffffc020482e:	1808                	addi	a0,sp,48
ffffffffc0204830:	645000ef          	jal	ra,ffffffffc0205674 <memcpy>
    if (mm != NULL)
ffffffffc0204834:	1e098363          	beqz	s3,ffffffffc0204a1a <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204838:	00002517          	auipc	a0,0x2
ffffffffc020483c:	4b850513          	addi	a0,a0,1208 # ffffffffc0206cf0 <default_pmm_manager+0x830>
ffffffffc0204840:	98dfb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204844:	000a6797          	auipc	a5,0xa6
ffffffffc0204848:	ecc7b783          	ld	a5,-308(a5) # ffffffffc02aa710 <boot_pgdir_pa>
ffffffffc020484c:	577d                	li	a4,-1
ffffffffc020484e:	177e                	slli	a4,a4,0x3f
ffffffffc0204850:	83b1                	srli	a5,a5,0xc
ffffffffc0204852:	8fd9                	or	a5,a5,a4
ffffffffc0204854:	18079073          	csrw	satp,a5
ffffffffc0204858:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b78>
ffffffffc020485c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204860:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204864:	2c070463          	beqz	a4,ffffffffc0204b2c <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204868:	000db783          	ld	a5,0(s11)
ffffffffc020486c:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204870:	e3dfe0ef          	jal	ra,ffffffffc02036ac <mm_create>
ffffffffc0204874:	84aa                	mv	s1,a0
ffffffffc0204876:	1c050d63          	beqz	a0,ffffffffc0204a50 <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc020487a:	4505                	li	a0,1
ffffffffc020487c:	e0cfd0ef          	jal	ra,ffffffffc0201e88 <alloc_pages>
ffffffffc0204880:	3a050963          	beqz	a0,ffffffffc0204c32 <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc0204884:	000a6c97          	auipc	s9,0xa6
ffffffffc0204888:	ea4c8c93          	addi	s9,s9,-348 # ffffffffc02aa728 <pages>
ffffffffc020488c:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204890:	000a6c17          	auipc	s8,0xa6
ffffffffc0204894:	e90c0c13          	addi	s8,s8,-368 # ffffffffc02aa720 <npage>
    return page - pages + nbase;
ffffffffc0204898:	00003717          	auipc	a4,0x3
ffffffffc020489c:	f3073703          	ld	a4,-208(a4) # ffffffffc02077c8 <nbase>
ffffffffc02048a0:	40d506b3          	sub	a3,a0,a3
ffffffffc02048a4:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02048a6:	5afd                	li	s5,-1
ffffffffc02048a8:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc02048ac:	96ba                	add	a3,a3,a4
ffffffffc02048ae:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc02048b0:	00cad713          	srli	a4,s5,0xc
ffffffffc02048b4:	ec3a                	sd	a4,24(sp)
ffffffffc02048b6:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc02048b8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02048ba:	38f77063          	bgeu	a4,a5,ffffffffc0204c3a <do_execve+0x464>
ffffffffc02048be:	000a6b17          	auipc	s6,0xa6
ffffffffc02048c2:	e7ab0b13          	addi	s6,s6,-390 # ffffffffc02aa738 <va_pa_offset>
ffffffffc02048c6:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02048ca:	6605                	lui	a2,0x1
ffffffffc02048cc:	000a6597          	auipc	a1,0xa6
ffffffffc02048d0:	e4c5b583          	ld	a1,-436(a1) # ffffffffc02aa718 <boot_pgdir_va>
ffffffffc02048d4:	9936                	add	s2,s2,a3
ffffffffc02048d6:	854a                	mv	a0,s2
ffffffffc02048d8:	59d000ef          	jal	ra,ffffffffc0205674 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc02048dc:	7782                	ld	a5,32(sp)
ffffffffc02048de:	4398                	lw	a4,0(a5)
ffffffffc02048e0:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc02048e4:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc02048e8:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b945f>
ffffffffc02048ec:	14f71863          	bne	a4,a5,ffffffffc0204a3c <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02048f0:	7682                	ld	a3,32(sp)
ffffffffc02048f2:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02048f6:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02048fa:	00371793          	slli	a5,a4,0x3
ffffffffc02048fe:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204900:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204902:	078e                	slli	a5,a5,0x3
ffffffffc0204904:	97ce                	add	a5,a5,s3
ffffffffc0204906:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204908:	00f9fc63          	bgeu	s3,a5,ffffffffc0204920 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc020490c:	0009a783          	lw	a5,0(s3)
ffffffffc0204910:	4705                	li	a4,1
ffffffffc0204912:	14e78163          	beq	a5,a4,ffffffffc0204a54 <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc0204916:	77a2                	ld	a5,40(sp)
ffffffffc0204918:	03898993          	addi	s3,s3,56
ffffffffc020491c:	fef9e8e3          	bltu	s3,a5,ffffffffc020490c <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204920:	4701                	li	a4,0
ffffffffc0204922:	46ad                	li	a3,11
ffffffffc0204924:	00100637          	lui	a2,0x100
ffffffffc0204928:	7ff005b7          	lui	a1,0x7ff00
ffffffffc020492c:	8526                	mv	a0,s1
ffffffffc020492e:	f11fe0ef          	jal	ra,ffffffffc020383e <mm_map>
ffffffffc0204932:	8a2a                	mv	s4,a0
ffffffffc0204934:	1e051263          	bnez	a0,ffffffffc0204b18 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204938:	6c88                	ld	a0,24(s1)
ffffffffc020493a:	467d                	li	a2,31
ffffffffc020493c:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204940:	c87fe0ef          	jal	ra,ffffffffc02035c6 <pgdir_alloc_page>
ffffffffc0204944:	38050363          	beqz	a0,ffffffffc0204cca <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204948:	6c88                	ld	a0,24(s1)
ffffffffc020494a:	467d                	li	a2,31
ffffffffc020494c:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204950:	c77fe0ef          	jal	ra,ffffffffc02035c6 <pgdir_alloc_page>
ffffffffc0204954:	34050b63          	beqz	a0,ffffffffc0204caa <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204958:	6c88                	ld	a0,24(s1)
ffffffffc020495a:	467d                	li	a2,31
ffffffffc020495c:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204960:	c67fe0ef          	jal	ra,ffffffffc02035c6 <pgdir_alloc_page>
ffffffffc0204964:	32050363          	beqz	a0,ffffffffc0204c8a <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204968:	6c88                	ld	a0,24(s1)
ffffffffc020496a:	467d                	li	a2,31
ffffffffc020496c:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204970:	c57fe0ef          	jal	ra,ffffffffc02035c6 <pgdir_alloc_page>
ffffffffc0204974:	2e050b63          	beqz	a0,ffffffffc0204c6a <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204978:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc020497a:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc020497e:	6c94                	ld	a3,24(s1)
ffffffffc0204980:	2785                	addiw	a5,a5,1
ffffffffc0204982:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204984:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204986:	c02007b7          	lui	a5,0xc0200
ffffffffc020498a:	2cf6e463          	bltu	a3,a5,ffffffffc0204c52 <do_execve+0x47c>
ffffffffc020498e:	000b3783          	ld	a5,0(s6)
ffffffffc0204992:	577d                	li	a4,-1
ffffffffc0204994:	177e                	slli	a4,a4,0x3f
ffffffffc0204996:	8e9d                	sub	a3,a3,a5
ffffffffc0204998:	00c6d793          	srli	a5,a3,0xc
ffffffffc020499c:	f654                	sd	a3,168(a2)
ffffffffc020499e:	8fd9                	or	a5,a5,a4
ffffffffc02049a0:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc02049a4:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc02049a6:	4581                	li	a1,0
ffffffffc02049a8:	12000613          	li	a2,288
ffffffffc02049ac:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc02049ae:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc02049b2:	4b1000ef          	jal	ra,ffffffffc0205662 <memset>
    tf->epc = elf->e_entry;
ffffffffc02049b6:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02049b8:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc02049bc:	edf4f493          	andi	s1,s1,-289
    tf->epc = elf->e_entry;
ffffffffc02049c0:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc02049c2:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02049c4:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_exit_out_size+0xffffffff7fff4f94>
    tf->gpr.sp = USTACKTOP;
ffffffffc02049c8:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc02049ca:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02049ce:	4641                	li	a2,16
ffffffffc02049d0:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc02049d2:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc02049d4:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc02049d8:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02049dc:	854a                	mv	a0,s2
ffffffffc02049de:	485000ef          	jal	ra,ffffffffc0205662 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02049e2:	463d                	li	a2,15
ffffffffc02049e4:	180c                	addi	a1,sp,48
ffffffffc02049e6:	854a                	mv	a0,s2
ffffffffc02049e8:	48d000ef          	jal	ra,ffffffffc0205674 <memcpy>
}
ffffffffc02049ec:	70aa                	ld	ra,168(sp)
ffffffffc02049ee:	740a                	ld	s0,160(sp)
ffffffffc02049f0:	64ea                	ld	s1,152(sp)
ffffffffc02049f2:	694a                	ld	s2,144(sp)
ffffffffc02049f4:	69aa                	ld	s3,136(sp)
ffffffffc02049f6:	7ae6                	ld	s5,120(sp)
ffffffffc02049f8:	7b46                	ld	s6,112(sp)
ffffffffc02049fa:	7ba6                	ld	s7,104(sp)
ffffffffc02049fc:	7c06                	ld	s8,96(sp)
ffffffffc02049fe:	6ce6                	ld	s9,88(sp)
ffffffffc0204a00:	6d46                	ld	s10,80(sp)
ffffffffc0204a02:	6da6                	ld	s11,72(sp)
ffffffffc0204a04:	8552                	mv	a0,s4
ffffffffc0204a06:	6a0a                	ld	s4,128(sp)
ffffffffc0204a08:	614d                	addi	sp,sp,176
ffffffffc0204a0a:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204a0c:	463d                	li	a2,15
ffffffffc0204a0e:	85ca                	mv	a1,s2
ffffffffc0204a10:	1808                	addi	a0,sp,48
ffffffffc0204a12:	463000ef          	jal	ra,ffffffffc0205674 <memcpy>
    if (mm != NULL)
ffffffffc0204a16:	e20991e3          	bnez	s3,ffffffffc0204838 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204a1a:	000db783          	ld	a5,0(s11)
ffffffffc0204a1e:	779c                	ld	a5,40(a5)
ffffffffc0204a20:	e40788e3          	beqz	a5,ffffffffc0204870 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204a24:	00002617          	auipc	a2,0x2
ffffffffc0204a28:	6d460613          	addi	a2,a2,1748 # ffffffffc02070f8 <default_pmm_manager+0xc38>
ffffffffc0204a2c:	25a00593          	li	a1,602
ffffffffc0204a30:	00002517          	auipc	a0,0x2
ffffffffc0204a34:	50050513          	addi	a0,a0,1280 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204a38:	a57fb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204a3c:	8526                	mv	a0,s1
ffffffffc0204a3e:	c7eff0ef          	jal	ra,ffffffffc0203ebc <put_pgdir>
    mm_destroy(mm);
ffffffffc0204a42:	8526                	mv	a0,s1
ffffffffc0204a44:	da9fe0ef          	jal	ra,ffffffffc02037ec <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204a48:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204a4a:	8552                	mv	a0,s4
ffffffffc0204a4c:	94bff0ef          	jal	ra,ffffffffc0204396 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204a50:	5a71                	li	s4,-4
ffffffffc0204a52:	bfe5                	j	ffffffffc0204a4a <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204a54:	0289b603          	ld	a2,40(s3)
ffffffffc0204a58:	0209b783          	ld	a5,32(s3)
ffffffffc0204a5c:	1cf66d63          	bltu	a2,a5,ffffffffc0204c36 <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204a60:	0049a783          	lw	a5,4(s3)
ffffffffc0204a64:	0017f693          	andi	a3,a5,1
ffffffffc0204a68:	c291                	beqz	a3,ffffffffc0204a6c <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204a6a:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204a6c:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a70:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204a72:	e779                	bnez	a4,ffffffffc0204b40 <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204a74:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a76:	c781                	beqz	a5,ffffffffc0204a7e <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204a78:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204a7c:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204a7e:	0026f793          	andi	a5,a3,2
ffffffffc0204a82:	e3f1                	bnez	a5,ffffffffc0204b46 <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204a84:	0046f793          	andi	a5,a3,4
ffffffffc0204a88:	c399                	beqz	a5,ffffffffc0204a8e <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204a8a:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204a8e:	0109b583          	ld	a1,16(s3)
ffffffffc0204a92:	4701                	li	a4,0
ffffffffc0204a94:	8526                	mv	a0,s1
ffffffffc0204a96:	da9fe0ef          	jal	ra,ffffffffc020383e <mm_map>
ffffffffc0204a9a:	8a2a                	mv	s4,a0
ffffffffc0204a9c:	ed35                	bnez	a0,ffffffffc0204b18 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204a9e:	0109bb83          	ld	s7,16(s3)
ffffffffc0204aa2:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204aa4:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204aa8:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204aac:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204ab0:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204ab2:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204ab4:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204ab6:	054be963          	bltu	s7,s4,ffffffffc0204b08 <do_execve+0x332>
ffffffffc0204aba:	aa95                	j	ffffffffc0204c2e <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204abc:	6785                	lui	a5,0x1
ffffffffc0204abe:	415b8533          	sub	a0,s7,s5
ffffffffc0204ac2:	9abe                	add	s5,s5,a5
ffffffffc0204ac4:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204ac8:	015a7463          	bgeu	s4,s5,ffffffffc0204ad0 <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204acc:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204ad0:	000cb683          	ld	a3,0(s9)
ffffffffc0204ad4:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204ad6:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204ada:	40d406b3          	sub	a3,s0,a3
ffffffffc0204ade:	8699                	srai	a3,a3,0x6
ffffffffc0204ae0:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204ae2:	67e2                	ld	a5,24(sp)
ffffffffc0204ae4:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ae8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204aea:	14b87863          	bgeu	a6,a1,ffffffffc0204c3a <do_execve+0x464>
ffffffffc0204aee:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204af2:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204af4:	9bb2                	add	s7,s7,a2
ffffffffc0204af6:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204af8:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204afa:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204afc:	379000ef          	jal	ra,ffffffffc0205674 <memcpy>
            start += size, from += size;
ffffffffc0204b00:	6622                	ld	a2,8(sp)
ffffffffc0204b02:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204b04:	054bf363          	bgeu	s7,s4,ffffffffc0204b4a <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b08:	6c88                	ld	a0,24(s1)
ffffffffc0204b0a:	866a                	mv	a2,s10
ffffffffc0204b0c:	85d6                	mv	a1,s5
ffffffffc0204b0e:	ab9fe0ef          	jal	ra,ffffffffc02035c6 <pgdir_alloc_page>
ffffffffc0204b12:	842a                	mv	s0,a0
ffffffffc0204b14:	f545                	bnez	a0,ffffffffc0204abc <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204b16:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204b18:	8526                	mv	a0,s1
ffffffffc0204b1a:	e6ffe0ef          	jal	ra,ffffffffc0203988 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204b1e:	8526                	mv	a0,s1
ffffffffc0204b20:	b9cff0ef          	jal	ra,ffffffffc0203ebc <put_pgdir>
    mm_destroy(mm);
ffffffffc0204b24:	8526                	mv	a0,s1
ffffffffc0204b26:	cc7fe0ef          	jal	ra,ffffffffc02037ec <mm_destroy>
    return ret;
ffffffffc0204b2a:	b705                	j	ffffffffc0204a4a <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204b2c:	854e                	mv	a0,s3
ffffffffc0204b2e:	e5bfe0ef          	jal	ra,ffffffffc0203988 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204b32:	854e                	mv	a0,s3
ffffffffc0204b34:	b88ff0ef          	jal	ra,ffffffffc0203ebc <put_pgdir>
            mm_destroy(mm);
ffffffffc0204b38:	854e                	mv	a0,s3
ffffffffc0204b3a:	cb3fe0ef          	jal	ra,ffffffffc02037ec <mm_destroy>
ffffffffc0204b3e:	b32d                	j	ffffffffc0204868 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204b40:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204b44:	fb95                	bnez	a5,ffffffffc0204a78 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204b46:	4d5d                	li	s10,23
ffffffffc0204b48:	bf35                	j	ffffffffc0204a84 <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204b4a:	0109b683          	ld	a3,16(s3)
ffffffffc0204b4e:	0289b903          	ld	s2,40(s3)
ffffffffc0204b52:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204b54:	075bfd63          	bgeu	s7,s5,ffffffffc0204bce <do_execve+0x3f8>
            if (start == end)
ffffffffc0204b58:	db790fe3          	beq	s2,s7,ffffffffc0204916 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204b5c:	6785                	lui	a5,0x1
ffffffffc0204b5e:	00fb8533          	add	a0,s7,a5
ffffffffc0204b62:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204b66:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204b6a:	0b597d63          	bgeu	s2,s5,ffffffffc0204c24 <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204b6e:	000cb683          	ld	a3,0(s9)
ffffffffc0204b72:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b74:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204b78:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b7c:	8699                	srai	a3,a3,0x6
ffffffffc0204b7e:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204b80:	67e2                	ld	a5,24(sp)
ffffffffc0204b82:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b86:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b88:	0ac5f963          	bgeu	a1,a2,ffffffffc0204c3a <do_execve+0x464>
ffffffffc0204b8c:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204b90:	8652                	mv	a2,s4
ffffffffc0204b92:	4581                	li	a1,0
ffffffffc0204b94:	96c2                	add	a3,a3,a6
ffffffffc0204b96:	9536                	add	a0,a0,a3
ffffffffc0204b98:	2cb000ef          	jal	ra,ffffffffc0205662 <memset>
            start += size;
ffffffffc0204b9c:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204ba0:	03597463          	bgeu	s2,s5,ffffffffc0204bc8 <do_execve+0x3f2>
ffffffffc0204ba4:	d6e909e3          	beq	s2,a4,ffffffffc0204916 <do_execve+0x140>
ffffffffc0204ba8:	00002697          	auipc	a3,0x2
ffffffffc0204bac:	57868693          	addi	a3,a3,1400 # ffffffffc0207120 <default_pmm_manager+0xc60>
ffffffffc0204bb0:	00001617          	auipc	a2,0x1
ffffffffc0204bb4:	56060613          	addi	a2,a2,1376 # ffffffffc0206110 <commands+0x818>
ffffffffc0204bb8:	2c300593          	li	a1,707
ffffffffc0204bbc:	00002517          	auipc	a0,0x2
ffffffffc0204bc0:	37450513          	addi	a0,a0,884 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204bc4:	8cbfb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204bc8:	ff5710e3          	bne	a4,s5,ffffffffc0204ba8 <do_execve+0x3d2>
ffffffffc0204bcc:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204bce:	d52bf4e3          	bgeu	s7,s2,ffffffffc0204916 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204bd2:	6c88                	ld	a0,24(s1)
ffffffffc0204bd4:	866a                	mv	a2,s10
ffffffffc0204bd6:	85d6                	mv	a1,s5
ffffffffc0204bd8:	9effe0ef          	jal	ra,ffffffffc02035c6 <pgdir_alloc_page>
ffffffffc0204bdc:	842a                	mv	s0,a0
ffffffffc0204bde:	dd05                	beqz	a0,ffffffffc0204b16 <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204be0:	6785                	lui	a5,0x1
ffffffffc0204be2:	415b8533          	sub	a0,s7,s5
ffffffffc0204be6:	9abe                	add	s5,s5,a5
ffffffffc0204be8:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204bec:	01597463          	bgeu	s2,s5,ffffffffc0204bf4 <do_execve+0x41e>
                size -= la - end;
ffffffffc0204bf0:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204bf4:	000cb683          	ld	a3,0(s9)
ffffffffc0204bf8:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204bfa:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204bfe:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c02:	8699                	srai	a3,a3,0x6
ffffffffc0204c04:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c06:	67e2                	ld	a5,24(sp)
ffffffffc0204c08:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c0c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c0e:	02b87663          	bgeu	a6,a1,ffffffffc0204c3a <do_execve+0x464>
ffffffffc0204c12:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c16:	4581                	li	a1,0
            start += size;
ffffffffc0204c18:	9bb2                	add	s7,s7,a2
ffffffffc0204c1a:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c1c:	9536                	add	a0,a0,a3
ffffffffc0204c1e:	245000ef          	jal	ra,ffffffffc0205662 <memset>
ffffffffc0204c22:	b775                	j	ffffffffc0204bce <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204c24:	417a8a33          	sub	s4,s5,s7
ffffffffc0204c28:	b799                	j	ffffffffc0204b6e <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204c2a:	5a75                	li	s4,-3
ffffffffc0204c2c:	b3c1                	j	ffffffffc02049ec <do_execve+0x216>
        while (start < end)
ffffffffc0204c2e:	86de                	mv	a3,s7
ffffffffc0204c30:	bf39                	j	ffffffffc0204b4e <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204c32:	5a71                	li	s4,-4
ffffffffc0204c34:	bdc5                	j	ffffffffc0204b24 <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204c36:	5a61                	li	s4,-8
ffffffffc0204c38:	b5c5                	j	ffffffffc0204b18 <do_execve+0x342>
ffffffffc0204c3a:	00002617          	auipc	a2,0x2
ffffffffc0204c3e:	8be60613          	addi	a2,a2,-1858 # ffffffffc02064f8 <default_pmm_manager+0x38>
ffffffffc0204c42:	07100593          	li	a1,113
ffffffffc0204c46:	00002517          	auipc	a0,0x2
ffffffffc0204c4a:	8da50513          	addi	a0,a0,-1830 # ffffffffc0206520 <default_pmm_manager+0x60>
ffffffffc0204c4e:	841fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204c52:	00002617          	auipc	a2,0x2
ffffffffc0204c56:	94e60613          	addi	a2,a2,-1714 # ffffffffc02065a0 <default_pmm_manager+0xe0>
ffffffffc0204c5a:	2e200593          	li	a1,738
ffffffffc0204c5e:	00002517          	auipc	a0,0x2
ffffffffc0204c62:	2d250513          	addi	a0,a0,722 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204c66:	829fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c6a:	00002697          	auipc	a3,0x2
ffffffffc0204c6e:	5ce68693          	addi	a3,a3,1486 # ffffffffc0207238 <default_pmm_manager+0xd78>
ffffffffc0204c72:	00001617          	auipc	a2,0x1
ffffffffc0204c76:	49e60613          	addi	a2,a2,1182 # ffffffffc0206110 <commands+0x818>
ffffffffc0204c7a:	2dd00593          	li	a1,733
ffffffffc0204c7e:	00002517          	auipc	a0,0x2
ffffffffc0204c82:	2b250513          	addi	a0,a0,690 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204c86:	809fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c8a:	00002697          	auipc	a3,0x2
ffffffffc0204c8e:	56668693          	addi	a3,a3,1382 # ffffffffc02071f0 <default_pmm_manager+0xd30>
ffffffffc0204c92:	00001617          	auipc	a2,0x1
ffffffffc0204c96:	47e60613          	addi	a2,a2,1150 # ffffffffc0206110 <commands+0x818>
ffffffffc0204c9a:	2dc00593          	li	a1,732
ffffffffc0204c9e:	00002517          	auipc	a0,0x2
ffffffffc0204ca2:	29250513          	addi	a0,a0,658 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204ca6:	fe8fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204caa:	00002697          	auipc	a3,0x2
ffffffffc0204cae:	4fe68693          	addi	a3,a3,1278 # ffffffffc02071a8 <default_pmm_manager+0xce8>
ffffffffc0204cb2:	00001617          	auipc	a2,0x1
ffffffffc0204cb6:	45e60613          	addi	a2,a2,1118 # ffffffffc0206110 <commands+0x818>
ffffffffc0204cba:	2db00593          	li	a1,731
ffffffffc0204cbe:	00002517          	auipc	a0,0x2
ffffffffc0204cc2:	27250513          	addi	a0,a0,626 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204cc6:	fc8fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204cca:	00002697          	auipc	a3,0x2
ffffffffc0204cce:	49668693          	addi	a3,a3,1174 # ffffffffc0207160 <default_pmm_manager+0xca0>
ffffffffc0204cd2:	00001617          	auipc	a2,0x1
ffffffffc0204cd6:	43e60613          	addi	a2,a2,1086 # ffffffffc0206110 <commands+0x818>
ffffffffc0204cda:	2da00593          	li	a1,730
ffffffffc0204cde:	00002517          	auipc	a0,0x2
ffffffffc0204ce2:	25250513          	addi	a0,a0,594 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204ce6:	fa8fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204cea <do_yield>:
    current->need_resched = 1;
ffffffffc0204cea:	000a6797          	auipc	a5,0xa6
ffffffffc0204cee:	a567b783          	ld	a5,-1450(a5) # ffffffffc02aa740 <current>
ffffffffc0204cf2:	4705                	li	a4,1
ffffffffc0204cf4:	ef98                	sd	a4,24(a5)
}
ffffffffc0204cf6:	4501                	li	a0,0
ffffffffc0204cf8:	8082                	ret

ffffffffc0204cfa <do_wait>:
{
ffffffffc0204cfa:	1101                	addi	sp,sp,-32
ffffffffc0204cfc:	e822                	sd	s0,16(sp)
ffffffffc0204cfe:	e426                	sd	s1,8(sp)
ffffffffc0204d00:	ec06                	sd	ra,24(sp)
ffffffffc0204d02:	842e                	mv	s0,a1
ffffffffc0204d04:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204d06:	c999                	beqz	a1,ffffffffc0204d1c <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204d08:	000a6797          	auipc	a5,0xa6
ffffffffc0204d0c:	a387b783          	ld	a5,-1480(a5) # ffffffffc02aa740 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204d10:	7788                	ld	a0,40(a5)
ffffffffc0204d12:	4685                	li	a3,1
ffffffffc0204d14:	4611                	li	a2,4
ffffffffc0204d16:	80cff0ef          	jal	ra,ffffffffc0203d22 <user_mem_check>
ffffffffc0204d1a:	c909                	beqz	a0,ffffffffc0204d2c <do_wait+0x32>
ffffffffc0204d1c:	85a2                	mv	a1,s0
}
ffffffffc0204d1e:	6442                	ld	s0,16(sp)
ffffffffc0204d20:	60e2                	ld	ra,24(sp)
ffffffffc0204d22:	8526                	mv	a0,s1
ffffffffc0204d24:	64a2                	ld	s1,8(sp)
ffffffffc0204d26:	6105                	addi	sp,sp,32
ffffffffc0204d28:	fb8ff06f          	j	ffffffffc02044e0 <do_wait.part.0>
ffffffffc0204d2c:	60e2                	ld	ra,24(sp)
ffffffffc0204d2e:	6442                	ld	s0,16(sp)
ffffffffc0204d30:	64a2                	ld	s1,8(sp)
ffffffffc0204d32:	5575                	li	a0,-3
ffffffffc0204d34:	6105                	addi	sp,sp,32
ffffffffc0204d36:	8082                	ret

ffffffffc0204d38 <do_kill>:
{
ffffffffc0204d38:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204d3a:	6789                	lui	a5,0x2
{
ffffffffc0204d3c:	e406                	sd	ra,8(sp)
ffffffffc0204d3e:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204d40:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204d44:	17f9                	addi	a5,a5,-2
ffffffffc0204d46:	02e7e963          	bltu	a5,a4,ffffffffc0204d78 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204d4a:	842a                	mv	s0,a0
ffffffffc0204d4c:	45a9                	li	a1,10
ffffffffc0204d4e:	2501                	sext.w	a0,a0
ffffffffc0204d50:	46c000ef          	jal	ra,ffffffffc02051bc <hash32>
ffffffffc0204d54:	02051793          	slli	a5,a0,0x20
ffffffffc0204d58:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204d5c:	000a2797          	auipc	a5,0xa2
ffffffffc0204d60:	97478793          	addi	a5,a5,-1676 # ffffffffc02a66d0 <hash_list>
ffffffffc0204d64:	953e                	add	a0,a0,a5
ffffffffc0204d66:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204d68:	a029                	j	ffffffffc0204d72 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204d6a:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204d6e:	00870b63          	beq	a4,s0,ffffffffc0204d84 <do_kill+0x4c>
ffffffffc0204d72:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204d74:	fef51be3          	bne	a0,a5,ffffffffc0204d6a <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204d78:	5475                	li	s0,-3
}
ffffffffc0204d7a:	60a2                	ld	ra,8(sp)
ffffffffc0204d7c:	8522                	mv	a0,s0
ffffffffc0204d7e:	6402                	ld	s0,0(sp)
ffffffffc0204d80:	0141                	addi	sp,sp,16
ffffffffc0204d82:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204d84:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204d88:	00177693          	andi	a3,a4,1
ffffffffc0204d8c:	e295                	bnez	a3,ffffffffc0204db0 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204d8e:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204d90:	00176713          	ori	a4,a4,1
ffffffffc0204d94:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204d98:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204d9a:	fe06d0e3          	bgez	a3,ffffffffc0204d7a <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204d9e:	f2878513          	addi	a0,a5,-216
ffffffffc0204da2:	22e000ef          	jal	ra,ffffffffc0204fd0 <wakeup_proc>
}
ffffffffc0204da6:	60a2                	ld	ra,8(sp)
ffffffffc0204da8:	8522                	mv	a0,s0
ffffffffc0204daa:	6402                	ld	s0,0(sp)
ffffffffc0204dac:	0141                	addi	sp,sp,16
ffffffffc0204dae:	8082                	ret
        return -E_KILLED;
ffffffffc0204db0:	545d                	li	s0,-9
ffffffffc0204db2:	b7e1                	j	ffffffffc0204d7a <do_kill+0x42>

ffffffffc0204db4 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204db4:	1101                	addi	sp,sp,-32
ffffffffc0204db6:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204db8:	000a6797          	auipc	a5,0xa6
ffffffffc0204dbc:	91878793          	addi	a5,a5,-1768 # ffffffffc02aa6d0 <proc_list>
ffffffffc0204dc0:	ec06                	sd	ra,24(sp)
ffffffffc0204dc2:	e822                	sd	s0,16(sp)
ffffffffc0204dc4:	e04a                	sd	s2,0(sp)
ffffffffc0204dc6:	000a2497          	auipc	s1,0xa2
ffffffffc0204dca:	90a48493          	addi	s1,s1,-1782 # ffffffffc02a66d0 <hash_list>
ffffffffc0204dce:	e79c                	sd	a5,8(a5)
ffffffffc0204dd0:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204dd2:	000a6717          	auipc	a4,0xa6
ffffffffc0204dd6:	8fe70713          	addi	a4,a4,-1794 # ffffffffc02aa6d0 <proc_list>
ffffffffc0204dda:	87a6                	mv	a5,s1
ffffffffc0204ddc:	e79c                	sd	a5,8(a5)
ffffffffc0204dde:	e39c                	sd	a5,0(a5)
ffffffffc0204de0:	07c1                	addi	a5,a5,16
ffffffffc0204de2:	fef71de3          	bne	a4,a5,ffffffffc0204ddc <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204de6:	fd9fe0ef          	jal	ra,ffffffffc0203dbe <alloc_proc>
ffffffffc0204dea:	000a6917          	auipc	s2,0xa6
ffffffffc0204dee:	95e90913          	addi	s2,s2,-1698 # ffffffffc02aa748 <idleproc>
ffffffffc0204df2:	00a93023          	sd	a0,0(s2)
ffffffffc0204df6:	0e050f63          	beqz	a0,ffffffffc0204ef4 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204dfa:	4789                	li	a5,2
ffffffffc0204dfc:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204dfe:	00003797          	auipc	a5,0x3
ffffffffc0204e02:	20278793          	addi	a5,a5,514 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e06:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e0a:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204e0c:	4785                	li	a5,1
ffffffffc0204e0e:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e10:	4641                	li	a2,16
ffffffffc0204e12:	4581                	li	a1,0
ffffffffc0204e14:	8522                	mv	a0,s0
ffffffffc0204e16:	04d000ef          	jal	ra,ffffffffc0205662 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e1a:	463d                	li	a2,15
ffffffffc0204e1c:	00002597          	auipc	a1,0x2
ffffffffc0204e20:	47c58593          	addi	a1,a1,1148 # ffffffffc0207298 <default_pmm_manager+0xdd8>
ffffffffc0204e24:	8522                	mv	a0,s0
ffffffffc0204e26:	04f000ef          	jal	ra,ffffffffc0205674 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204e2a:	000a6717          	auipc	a4,0xa6
ffffffffc0204e2e:	92e70713          	addi	a4,a4,-1746 # ffffffffc02aa758 <nr_process>
ffffffffc0204e32:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204e34:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e38:	4601                	li	a2,0
    nr_process++;
ffffffffc0204e3a:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e3c:	4581                	li	a1,0
ffffffffc0204e3e:	00000517          	auipc	a0,0x0
ffffffffc0204e42:	87450513          	addi	a0,a0,-1932 # ffffffffc02046b2 <init_main>
    nr_process++;
ffffffffc0204e46:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204e48:	000a6797          	auipc	a5,0xa6
ffffffffc0204e4c:	8ed7bc23          	sd	a3,-1800(a5) # ffffffffc02aa740 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e50:	cf6ff0ef          	jal	ra,ffffffffc0204346 <kernel_thread>
ffffffffc0204e54:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204e56:	08a05363          	blez	a0,ffffffffc0204edc <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204e5a:	6789                	lui	a5,0x2
ffffffffc0204e5c:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204e60:	17f9                	addi	a5,a5,-2
ffffffffc0204e62:	2501                	sext.w	a0,a0
ffffffffc0204e64:	02e7e363          	bltu	a5,a4,ffffffffc0204e8a <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204e68:	45a9                	li	a1,10
ffffffffc0204e6a:	352000ef          	jal	ra,ffffffffc02051bc <hash32>
ffffffffc0204e6e:	02051793          	slli	a5,a0,0x20
ffffffffc0204e72:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204e76:	96a6                	add	a3,a3,s1
ffffffffc0204e78:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204e7a:	a029                	j	ffffffffc0204e84 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204e7c:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c7c>
ffffffffc0204e80:	04870b63          	beq	a4,s0,ffffffffc0204ed6 <proc_init+0x122>
    return listelm->next;
ffffffffc0204e84:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204e86:	fef69be3          	bne	a3,a5,ffffffffc0204e7c <proc_init+0xc8>
    return NULL;
ffffffffc0204e8a:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e8c:	0b478493          	addi	s1,a5,180
ffffffffc0204e90:	4641                	li	a2,16
ffffffffc0204e92:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204e94:	000a6417          	auipc	s0,0xa6
ffffffffc0204e98:	8bc40413          	addi	s0,s0,-1860 # ffffffffc02aa750 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e9c:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204e9e:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204ea0:	7c2000ef          	jal	ra,ffffffffc0205662 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204ea4:	463d                	li	a2,15
ffffffffc0204ea6:	00002597          	auipc	a1,0x2
ffffffffc0204eaa:	41a58593          	addi	a1,a1,1050 # ffffffffc02072c0 <default_pmm_manager+0xe00>
ffffffffc0204eae:	8526                	mv	a0,s1
ffffffffc0204eb0:	7c4000ef          	jal	ra,ffffffffc0205674 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204eb4:	00093783          	ld	a5,0(s2)
ffffffffc0204eb8:	cbb5                	beqz	a5,ffffffffc0204f2c <proc_init+0x178>
ffffffffc0204eba:	43dc                	lw	a5,4(a5)
ffffffffc0204ebc:	eba5                	bnez	a5,ffffffffc0204f2c <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204ebe:	601c                	ld	a5,0(s0)
ffffffffc0204ec0:	c7b1                	beqz	a5,ffffffffc0204f0c <proc_init+0x158>
ffffffffc0204ec2:	43d8                	lw	a4,4(a5)
ffffffffc0204ec4:	4785                	li	a5,1
ffffffffc0204ec6:	04f71363          	bne	a4,a5,ffffffffc0204f0c <proc_init+0x158>
}
ffffffffc0204eca:	60e2                	ld	ra,24(sp)
ffffffffc0204ecc:	6442                	ld	s0,16(sp)
ffffffffc0204ece:	64a2                	ld	s1,8(sp)
ffffffffc0204ed0:	6902                	ld	s2,0(sp)
ffffffffc0204ed2:	6105                	addi	sp,sp,32
ffffffffc0204ed4:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204ed6:	f2878793          	addi	a5,a5,-216
ffffffffc0204eda:	bf4d                	j	ffffffffc0204e8c <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204edc:	00002617          	auipc	a2,0x2
ffffffffc0204ee0:	3c460613          	addi	a2,a2,964 # ffffffffc02072a0 <default_pmm_manager+0xde0>
ffffffffc0204ee4:	40900593          	li	a1,1033
ffffffffc0204ee8:	00002517          	auipc	a0,0x2
ffffffffc0204eec:	04850513          	addi	a0,a0,72 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204ef0:	d9efb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204ef4:	00002617          	auipc	a2,0x2
ffffffffc0204ef8:	38c60613          	addi	a2,a2,908 # ffffffffc0207280 <default_pmm_manager+0xdc0>
ffffffffc0204efc:	3fa00593          	li	a1,1018
ffffffffc0204f00:	00002517          	auipc	a0,0x2
ffffffffc0204f04:	03050513          	addi	a0,a0,48 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204f08:	d86fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f0c:	00002697          	auipc	a3,0x2
ffffffffc0204f10:	3e468693          	addi	a3,a3,996 # ffffffffc02072f0 <default_pmm_manager+0xe30>
ffffffffc0204f14:	00001617          	auipc	a2,0x1
ffffffffc0204f18:	1fc60613          	addi	a2,a2,508 # ffffffffc0206110 <commands+0x818>
ffffffffc0204f1c:	41000593          	li	a1,1040
ffffffffc0204f20:	00002517          	auipc	a0,0x2
ffffffffc0204f24:	01050513          	addi	a0,a0,16 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204f28:	d66fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f2c:	00002697          	auipc	a3,0x2
ffffffffc0204f30:	39c68693          	addi	a3,a3,924 # ffffffffc02072c8 <default_pmm_manager+0xe08>
ffffffffc0204f34:	00001617          	auipc	a2,0x1
ffffffffc0204f38:	1dc60613          	addi	a2,a2,476 # ffffffffc0206110 <commands+0x818>
ffffffffc0204f3c:	40f00593          	li	a1,1039
ffffffffc0204f40:	00002517          	auipc	a0,0x2
ffffffffc0204f44:	ff050513          	addi	a0,a0,-16 # ffffffffc0206f30 <default_pmm_manager+0xa70>
ffffffffc0204f48:	d46fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204f4c <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204f4c:	1141                	addi	sp,sp,-16
ffffffffc0204f4e:	e022                	sd	s0,0(sp)
ffffffffc0204f50:	e406                	sd	ra,8(sp)
ffffffffc0204f52:	000a5417          	auipc	s0,0xa5
ffffffffc0204f56:	7ee40413          	addi	s0,s0,2030 # ffffffffc02aa740 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204f5a:	6018                	ld	a4,0(s0)
ffffffffc0204f5c:	6f1c                	ld	a5,24(a4)
ffffffffc0204f5e:	dffd                	beqz	a5,ffffffffc0204f5c <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204f60:	0f0000ef          	jal	ra,ffffffffc0205050 <schedule>
ffffffffc0204f64:	bfdd                	j	ffffffffc0204f5a <cpu_idle+0xe>

ffffffffc0204f66 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204f66:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204f6a:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204f6e:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204f70:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204f72:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204f76:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204f7a:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204f7e:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204f82:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204f86:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0204f8a:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0204f8e:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0204f92:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0204f96:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0204f9a:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0204f9e:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0204fa2:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0204fa4:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0204fa6:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0204faa:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0204fae:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0204fb2:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0204fb6:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0204fba:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0204fbe:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0204fc2:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0204fc6:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0204fca:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0204fce:	8082                	ret

ffffffffc0204fd0 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204fd0:	4118                	lw	a4,0(a0)
{
ffffffffc0204fd2:	1101                	addi	sp,sp,-32
ffffffffc0204fd4:	ec06                	sd	ra,24(sp)
ffffffffc0204fd6:	e822                	sd	s0,16(sp)
ffffffffc0204fd8:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204fda:	478d                	li	a5,3
ffffffffc0204fdc:	04f70b63          	beq	a4,a5,ffffffffc0205032 <wakeup_proc+0x62>
ffffffffc0204fe0:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204fe2:	100027f3          	csrr	a5,sstatus
ffffffffc0204fe6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204fe8:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204fea:	ef9d                	bnez	a5,ffffffffc0205028 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0204fec:	4789                	li	a5,2
ffffffffc0204fee:	02f70163          	beq	a4,a5,ffffffffc0205010 <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0204ff2:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0204ff4:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0204ff8:	e491                	bnez	s1,ffffffffc0205004 <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0204ffa:	60e2                	ld	ra,24(sp)
ffffffffc0204ffc:	6442                	ld	s0,16(sp)
ffffffffc0204ffe:	64a2                	ld	s1,8(sp)
ffffffffc0205000:	6105                	addi	sp,sp,32
ffffffffc0205002:	8082                	ret
ffffffffc0205004:	6442                	ld	s0,16(sp)
ffffffffc0205006:	60e2                	ld	ra,24(sp)
ffffffffc0205008:	64a2                	ld	s1,8(sp)
ffffffffc020500a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020500c:	9a3fb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205010:	00002617          	auipc	a2,0x2
ffffffffc0205014:	34060613          	addi	a2,a2,832 # ffffffffc0207350 <default_pmm_manager+0xe90>
ffffffffc0205018:	45d1                	li	a1,20
ffffffffc020501a:	00002517          	auipc	a0,0x2
ffffffffc020501e:	31e50513          	addi	a0,a0,798 # ffffffffc0207338 <default_pmm_manager+0xe78>
ffffffffc0205022:	cd4fb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc0205026:	bfc9                	j	ffffffffc0204ff8 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205028:	98dfb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020502c:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc020502e:	4485                	li	s1,1
ffffffffc0205030:	bf75                	j	ffffffffc0204fec <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205032:	00002697          	auipc	a3,0x2
ffffffffc0205036:	2e668693          	addi	a3,a3,742 # ffffffffc0207318 <default_pmm_manager+0xe58>
ffffffffc020503a:	00001617          	auipc	a2,0x1
ffffffffc020503e:	0d660613          	addi	a2,a2,214 # ffffffffc0206110 <commands+0x818>
ffffffffc0205042:	45a5                	li	a1,9
ffffffffc0205044:	00002517          	auipc	a0,0x2
ffffffffc0205048:	2f450513          	addi	a0,a0,756 # ffffffffc0207338 <default_pmm_manager+0xe78>
ffffffffc020504c:	c42fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205050 <schedule>:

void schedule(void)
{
ffffffffc0205050:	1141                	addi	sp,sp,-16
ffffffffc0205052:	e406                	sd	ra,8(sp)
ffffffffc0205054:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205056:	100027f3          	csrr	a5,sstatus
ffffffffc020505a:	8b89                	andi	a5,a5,2
ffffffffc020505c:	4401                	li	s0,0
ffffffffc020505e:	efbd                	bnez	a5,ffffffffc02050dc <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205060:	000a5897          	auipc	a7,0xa5
ffffffffc0205064:	6e08b883          	ld	a7,1760(a7) # ffffffffc02aa740 <current>
ffffffffc0205068:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020506c:	000a5517          	auipc	a0,0xa5
ffffffffc0205070:	6dc53503          	ld	a0,1756(a0) # ffffffffc02aa748 <idleproc>
ffffffffc0205074:	04a88e63          	beq	a7,a0,ffffffffc02050d0 <schedule+0x80>
ffffffffc0205078:	0c888693          	addi	a3,a7,200
ffffffffc020507c:	000a5617          	auipc	a2,0xa5
ffffffffc0205080:	65460613          	addi	a2,a2,1620 # ffffffffc02aa6d0 <proc_list>
        le = last;
ffffffffc0205084:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205086:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205088:	4809                	li	a6,2
ffffffffc020508a:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc020508c:	00c78863          	beq	a5,a2,ffffffffc020509c <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc0205090:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0205094:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205098:	03070163          	beq	a4,a6,ffffffffc02050ba <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc020509c:	fef697e3          	bne	a3,a5,ffffffffc020508a <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02050a0:	ed89                	bnez	a1,ffffffffc02050ba <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02050a2:	451c                	lw	a5,8(a0)
ffffffffc02050a4:	2785                	addiw	a5,a5,1
ffffffffc02050a6:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02050a8:	00a88463          	beq	a7,a0,ffffffffc02050b0 <schedule+0x60>
        {
            proc_run(next);
ffffffffc02050ac:	e87fe0ef          	jal	ra,ffffffffc0203f32 <proc_run>
    if (flag)
ffffffffc02050b0:	e819                	bnez	s0,ffffffffc02050c6 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02050b2:	60a2                	ld	ra,8(sp)
ffffffffc02050b4:	6402                	ld	s0,0(sp)
ffffffffc02050b6:	0141                	addi	sp,sp,16
ffffffffc02050b8:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02050ba:	4198                	lw	a4,0(a1)
ffffffffc02050bc:	4789                	li	a5,2
ffffffffc02050be:	fef712e3          	bne	a4,a5,ffffffffc02050a2 <schedule+0x52>
ffffffffc02050c2:	852e                	mv	a0,a1
ffffffffc02050c4:	bff9                	j	ffffffffc02050a2 <schedule+0x52>
}
ffffffffc02050c6:	6402                	ld	s0,0(sp)
ffffffffc02050c8:	60a2                	ld	ra,8(sp)
ffffffffc02050ca:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02050cc:	8e3fb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02050d0:	000a5617          	auipc	a2,0xa5
ffffffffc02050d4:	60060613          	addi	a2,a2,1536 # ffffffffc02aa6d0 <proc_list>
ffffffffc02050d8:	86b2                	mv	a3,a2
ffffffffc02050da:	b76d                	j	ffffffffc0205084 <schedule+0x34>
        intr_disable();
ffffffffc02050dc:	8d9fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02050e0:	4405                	li	s0,1
ffffffffc02050e2:	bfbd                	j	ffffffffc0205060 <schedule+0x10>

ffffffffc02050e4 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02050e4:	000a5797          	auipc	a5,0xa5
ffffffffc02050e8:	65c7b783          	ld	a5,1628(a5) # ffffffffc02aa740 <current>
}
ffffffffc02050ec:	43c8                	lw	a0,4(a5)
ffffffffc02050ee:	8082                	ret

ffffffffc02050f0 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02050f0:	4501                	li	a0,0
ffffffffc02050f2:	8082                	ret

ffffffffc02050f4 <sys_putc>:
    cputchar(c);
ffffffffc02050f4:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc02050f6:	1141                	addi	sp,sp,-16
ffffffffc02050f8:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc02050fa:	8d0fb0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc02050fe:	60a2                	ld	ra,8(sp)
ffffffffc0205100:	4501                	li	a0,0
ffffffffc0205102:	0141                	addi	sp,sp,16
ffffffffc0205104:	8082                	ret

ffffffffc0205106 <sys_kill>:
    return do_kill(pid);
ffffffffc0205106:	4108                	lw	a0,0(a0)
ffffffffc0205108:	c31ff06f          	j	ffffffffc0204d38 <do_kill>

ffffffffc020510c <sys_yield>:
    return do_yield();
ffffffffc020510c:	bdfff06f          	j	ffffffffc0204cea <do_yield>

ffffffffc0205110 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205110:	6d14                	ld	a3,24(a0)
ffffffffc0205112:	6910                	ld	a2,16(a0)
ffffffffc0205114:	650c                	ld	a1,8(a0)
ffffffffc0205116:	6108                	ld	a0,0(a0)
ffffffffc0205118:	ebeff06f          	j	ffffffffc02047d6 <do_execve>

ffffffffc020511c <sys_wait>:
    return do_wait(pid, store);
ffffffffc020511c:	650c                	ld	a1,8(a0)
ffffffffc020511e:	4108                	lw	a0,0(a0)
ffffffffc0205120:	bdbff06f          	j	ffffffffc0204cfa <do_wait>

ffffffffc0205124 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205124:	000a5797          	auipc	a5,0xa5
ffffffffc0205128:	61c7b783          	ld	a5,1564(a5) # ffffffffc02aa740 <current>
ffffffffc020512c:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020512e:	4501                	li	a0,0
ffffffffc0205130:	6a0c                	ld	a1,16(a2)
ffffffffc0205132:	e6dfe06f          	j	ffffffffc0203f9e <do_fork>

ffffffffc0205136 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205136:	4108                	lw	a0,0(a0)
ffffffffc0205138:	a5eff06f          	j	ffffffffc0204396 <do_exit>

ffffffffc020513c <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc020513c:	715d                	addi	sp,sp,-80
ffffffffc020513e:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205140:	000a5497          	auipc	s1,0xa5
ffffffffc0205144:	60048493          	addi	s1,s1,1536 # ffffffffc02aa740 <current>
ffffffffc0205148:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc020514a:	e0a2                	sd	s0,64(sp)
ffffffffc020514c:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc020514e:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc0205150:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205152:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc0205154:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205158:	0327ee63          	bltu	a5,s2,ffffffffc0205194 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc020515c:	00391713          	slli	a4,s2,0x3
ffffffffc0205160:	00002797          	auipc	a5,0x2
ffffffffc0205164:	25878793          	addi	a5,a5,600 # ffffffffc02073b8 <syscalls>
ffffffffc0205168:	97ba                	add	a5,a5,a4
ffffffffc020516a:	639c                	ld	a5,0(a5)
ffffffffc020516c:	c785                	beqz	a5,ffffffffc0205194 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc020516e:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc0205170:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc0205172:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc0205174:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc0205176:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc0205178:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc020517a:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc020517c:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc020517e:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc0205180:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205182:	0028                	addi	a0,sp,8
ffffffffc0205184:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205186:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205188:	e828                	sd	a0,80(s0)
}
ffffffffc020518a:	6406                	ld	s0,64(sp)
ffffffffc020518c:	74e2                	ld	s1,56(sp)
ffffffffc020518e:	7942                	ld	s2,48(sp)
ffffffffc0205190:	6161                	addi	sp,sp,80
ffffffffc0205192:	8082                	ret
    print_trapframe(tf);
ffffffffc0205194:	8522                	mv	a0,s0
ffffffffc0205196:	a0ffb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc020519a:	609c                	ld	a5,0(s1)
ffffffffc020519c:	86ca                	mv	a3,s2
ffffffffc020519e:	00002617          	auipc	a2,0x2
ffffffffc02051a2:	1d260613          	addi	a2,a2,466 # ffffffffc0207370 <default_pmm_manager+0xeb0>
ffffffffc02051a6:	43d8                	lw	a4,4(a5)
ffffffffc02051a8:	06200593          	li	a1,98
ffffffffc02051ac:	0b478793          	addi	a5,a5,180
ffffffffc02051b0:	00002517          	auipc	a0,0x2
ffffffffc02051b4:	1f050513          	addi	a0,a0,496 # ffffffffc02073a0 <default_pmm_manager+0xee0>
ffffffffc02051b8:	ad6fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02051bc <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02051bc:	9e3707b7          	lui	a5,0x9e370
ffffffffc02051c0:	2785                	addiw	a5,a5,1
ffffffffc02051c2:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc02051c6:	02000793          	li	a5,32
ffffffffc02051ca:	9f8d                	subw	a5,a5,a1
}
ffffffffc02051cc:	00f5553b          	srlw	a0,a0,a5
ffffffffc02051d0:	8082                	ret

ffffffffc02051d2 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02051d2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02051d6:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02051d8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02051dc:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02051de:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02051e2:	f022                	sd	s0,32(sp)
ffffffffc02051e4:	ec26                	sd	s1,24(sp)
ffffffffc02051e6:	e84a                	sd	s2,16(sp)
ffffffffc02051e8:	f406                	sd	ra,40(sp)
ffffffffc02051ea:	e44e                	sd	s3,8(sp)
ffffffffc02051ec:	84aa                	mv	s1,a0
ffffffffc02051ee:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02051f0:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02051f4:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02051f6:	03067e63          	bgeu	a2,a6,ffffffffc0205232 <printnum+0x60>
ffffffffc02051fa:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02051fc:	00805763          	blez	s0,ffffffffc020520a <printnum+0x38>
ffffffffc0205200:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205202:	85ca                	mv	a1,s2
ffffffffc0205204:	854e                	mv	a0,s3
ffffffffc0205206:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205208:	fc65                	bnez	s0,ffffffffc0205200 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020520a:	1a02                	slli	s4,s4,0x20
ffffffffc020520c:	00002797          	auipc	a5,0x2
ffffffffc0205210:	2ac78793          	addi	a5,a5,684 # ffffffffc02074b8 <syscalls+0x100>
ffffffffc0205214:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205218:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020521a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020521c:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205220:	70a2                	ld	ra,40(sp)
ffffffffc0205222:	69a2                	ld	s3,8(sp)
ffffffffc0205224:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205226:	85ca                	mv	a1,s2
ffffffffc0205228:	87a6                	mv	a5,s1
}
ffffffffc020522a:	6942                	ld	s2,16(sp)
ffffffffc020522c:	64e2                	ld	s1,24(sp)
ffffffffc020522e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205230:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205232:	03065633          	divu	a2,a2,a6
ffffffffc0205236:	8722                	mv	a4,s0
ffffffffc0205238:	f9bff0ef          	jal	ra,ffffffffc02051d2 <printnum>
ffffffffc020523c:	b7f9                	j	ffffffffc020520a <printnum+0x38>

ffffffffc020523e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020523e:	7119                	addi	sp,sp,-128
ffffffffc0205240:	f4a6                	sd	s1,104(sp)
ffffffffc0205242:	f0ca                	sd	s2,96(sp)
ffffffffc0205244:	ecce                	sd	s3,88(sp)
ffffffffc0205246:	e8d2                	sd	s4,80(sp)
ffffffffc0205248:	e4d6                	sd	s5,72(sp)
ffffffffc020524a:	e0da                	sd	s6,64(sp)
ffffffffc020524c:	fc5e                	sd	s7,56(sp)
ffffffffc020524e:	f06a                	sd	s10,32(sp)
ffffffffc0205250:	fc86                	sd	ra,120(sp)
ffffffffc0205252:	f8a2                	sd	s0,112(sp)
ffffffffc0205254:	f862                	sd	s8,48(sp)
ffffffffc0205256:	f466                	sd	s9,40(sp)
ffffffffc0205258:	ec6e                	sd	s11,24(sp)
ffffffffc020525a:	892a                	mv	s2,a0
ffffffffc020525c:	84ae                	mv	s1,a1
ffffffffc020525e:	8d32                	mv	s10,a2
ffffffffc0205260:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205262:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0205266:	5b7d                	li	s6,-1
ffffffffc0205268:	00002a97          	auipc	s5,0x2
ffffffffc020526c:	27ca8a93          	addi	s5,s5,636 # ffffffffc02074e4 <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205270:	00002b97          	auipc	s7,0x2
ffffffffc0205274:	490b8b93          	addi	s7,s7,1168 # ffffffffc0207700 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205278:	000d4503          	lbu	a0,0(s10)
ffffffffc020527c:	001d0413          	addi	s0,s10,1
ffffffffc0205280:	01350a63          	beq	a0,s3,ffffffffc0205294 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0205284:	c121                	beqz	a0,ffffffffc02052c4 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0205286:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205288:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020528a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020528c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205290:	ff351ae3          	bne	a0,s3,ffffffffc0205284 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205294:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205298:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020529c:	4c81                	li	s9,0
ffffffffc020529e:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02052a0:	5c7d                	li	s8,-1
ffffffffc02052a2:	5dfd                	li	s11,-1
ffffffffc02052a4:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02052a8:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02052aa:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02052ae:	0ff5f593          	zext.b	a1,a1
ffffffffc02052b2:	00140d13          	addi	s10,s0,1
ffffffffc02052b6:	04b56263          	bltu	a0,a1,ffffffffc02052fa <vprintfmt+0xbc>
ffffffffc02052ba:	058a                	slli	a1,a1,0x2
ffffffffc02052bc:	95d6                	add	a1,a1,s5
ffffffffc02052be:	4194                	lw	a3,0(a1)
ffffffffc02052c0:	96d6                	add	a3,a3,s5
ffffffffc02052c2:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02052c4:	70e6                	ld	ra,120(sp)
ffffffffc02052c6:	7446                	ld	s0,112(sp)
ffffffffc02052c8:	74a6                	ld	s1,104(sp)
ffffffffc02052ca:	7906                	ld	s2,96(sp)
ffffffffc02052cc:	69e6                	ld	s3,88(sp)
ffffffffc02052ce:	6a46                	ld	s4,80(sp)
ffffffffc02052d0:	6aa6                	ld	s5,72(sp)
ffffffffc02052d2:	6b06                	ld	s6,64(sp)
ffffffffc02052d4:	7be2                	ld	s7,56(sp)
ffffffffc02052d6:	7c42                	ld	s8,48(sp)
ffffffffc02052d8:	7ca2                	ld	s9,40(sp)
ffffffffc02052da:	7d02                	ld	s10,32(sp)
ffffffffc02052dc:	6de2                	ld	s11,24(sp)
ffffffffc02052de:	6109                	addi	sp,sp,128
ffffffffc02052e0:	8082                	ret
            padc = '0';
ffffffffc02052e2:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02052e4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02052e8:	846a                	mv	s0,s10
ffffffffc02052ea:	00140d13          	addi	s10,s0,1
ffffffffc02052ee:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02052f2:	0ff5f593          	zext.b	a1,a1
ffffffffc02052f6:	fcb572e3          	bgeu	a0,a1,ffffffffc02052ba <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02052fa:	85a6                	mv	a1,s1
ffffffffc02052fc:	02500513          	li	a0,37
ffffffffc0205300:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205302:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205306:	8d22                	mv	s10,s0
ffffffffc0205308:	f73788e3          	beq	a5,s3,ffffffffc0205278 <vprintfmt+0x3a>
ffffffffc020530c:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205310:	1d7d                	addi	s10,s10,-1
ffffffffc0205312:	ff379de3          	bne	a5,s3,ffffffffc020530c <vprintfmt+0xce>
ffffffffc0205316:	b78d                	j	ffffffffc0205278 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205318:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020531c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205320:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205322:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205326:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020532a:	02d86463          	bltu	a6,a3,ffffffffc0205352 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020532e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205332:	002c169b          	slliw	a3,s8,0x2
ffffffffc0205336:	0186873b          	addw	a4,a3,s8
ffffffffc020533a:	0017171b          	slliw	a4,a4,0x1
ffffffffc020533e:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0205340:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205344:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205346:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020534a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020534e:	fed870e3          	bgeu	a6,a3,ffffffffc020532e <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0205352:	f40ddce3          	bgez	s11,ffffffffc02052aa <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0205356:	8de2                	mv	s11,s8
ffffffffc0205358:	5c7d                	li	s8,-1
ffffffffc020535a:	bf81                	j	ffffffffc02052aa <vprintfmt+0x6c>
            if (width < 0)
ffffffffc020535c:	fffdc693          	not	a3,s11
ffffffffc0205360:	96fd                	srai	a3,a3,0x3f
ffffffffc0205362:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205366:	00144603          	lbu	a2,1(s0)
ffffffffc020536a:	2d81                	sext.w	s11,s11
ffffffffc020536c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020536e:	bf35                	j	ffffffffc02052aa <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0205370:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205374:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0205378:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020537a:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020537c:	bfd9                	j	ffffffffc0205352 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020537e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205380:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205384:	01174463          	blt	a4,a7,ffffffffc020538c <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0205388:	1a088e63          	beqz	a7,ffffffffc0205544 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020538c:	000a3603          	ld	a2,0(s4)
ffffffffc0205390:	46c1                	li	a3,16
ffffffffc0205392:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205394:	2781                	sext.w	a5,a5
ffffffffc0205396:	876e                	mv	a4,s11
ffffffffc0205398:	85a6                	mv	a1,s1
ffffffffc020539a:	854a                	mv	a0,s2
ffffffffc020539c:	e37ff0ef          	jal	ra,ffffffffc02051d2 <printnum>
            break;
ffffffffc02053a0:	bde1                	j	ffffffffc0205278 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02053a2:	000a2503          	lw	a0,0(s4)
ffffffffc02053a6:	85a6                	mv	a1,s1
ffffffffc02053a8:	0a21                	addi	s4,s4,8
ffffffffc02053aa:	9902                	jalr	s2
            break;
ffffffffc02053ac:	b5f1                	j	ffffffffc0205278 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02053ae:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02053b0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02053b4:	01174463          	blt	a4,a7,ffffffffc02053bc <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02053b8:	18088163          	beqz	a7,ffffffffc020553a <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02053bc:	000a3603          	ld	a2,0(s4)
ffffffffc02053c0:	46a9                	li	a3,10
ffffffffc02053c2:	8a2e                	mv	s4,a1
ffffffffc02053c4:	bfc1                	j	ffffffffc0205394 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053c6:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02053ca:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053cc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02053ce:	bdf1                	j	ffffffffc02052aa <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02053d0:	85a6                	mv	a1,s1
ffffffffc02053d2:	02500513          	li	a0,37
ffffffffc02053d6:	9902                	jalr	s2
            break;
ffffffffc02053d8:	b545                	j	ffffffffc0205278 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053da:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02053de:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053e0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02053e2:	b5e1                	j	ffffffffc02052aa <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02053e4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02053e6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02053ea:	01174463          	blt	a4,a7,ffffffffc02053f2 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02053ee:	14088163          	beqz	a7,ffffffffc0205530 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02053f2:	000a3603          	ld	a2,0(s4)
ffffffffc02053f6:	46a1                	li	a3,8
ffffffffc02053f8:	8a2e                	mv	s4,a1
ffffffffc02053fa:	bf69                	j	ffffffffc0205394 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02053fc:	03000513          	li	a0,48
ffffffffc0205400:	85a6                	mv	a1,s1
ffffffffc0205402:	e03e                	sd	a5,0(sp)
ffffffffc0205404:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205406:	85a6                	mv	a1,s1
ffffffffc0205408:	07800513          	li	a0,120
ffffffffc020540c:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020540e:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205410:	6782                	ld	a5,0(sp)
ffffffffc0205412:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205414:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205418:	bfb5                	j	ffffffffc0205394 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020541a:	000a3403          	ld	s0,0(s4)
ffffffffc020541e:	008a0713          	addi	a4,s4,8
ffffffffc0205422:	e03a                	sd	a4,0(sp)
ffffffffc0205424:	14040263          	beqz	s0,ffffffffc0205568 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205428:	0fb05763          	blez	s11,ffffffffc0205516 <vprintfmt+0x2d8>
ffffffffc020542c:	02d00693          	li	a3,45
ffffffffc0205430:	0cd79163          	bne	a5,a3,ffffffffc02054f2 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205434:	00044783          	lbu	a5,0(s0)
ffffffffc0205438:	0007851b          	sext.w	a0,a5
ffffffffc020543c:	cf85                	beqz	a5,ffffffffc0205474 <vprintfmt+0x236>
ffffffffc020543e:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205442:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205446:	000c4563          	bltz	s8,ffffffffc0205450 <vprintfmt+0x212>
ffffffffc020544a:	3c7d                	addiw	s8,s8,-1
ffffffffc020544c:	036c0263          	beq	s8,s6,ffffffffc0205470 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0205450:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205452:	0e0c8e63          	beqz	s9,ffffffffc020554e <vprintfmt+0x310>
ffffffffc0205456:	3781                	addiw	a5,a5,-32
ffffffffc0205458:	0ef47b63          	bgeu	s0,a5,ffffffffc020554e <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc020545c:	03f00513          	li	a0,63
ffffffffc0205460:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205462:	000a4783          	lbu	a5,0(s4)
ffffffffc0205466:	3dfd                	addiw	s11,s11,-1
ffffffffc0205468:	0a05                	addi	s4,s4,1
ffffffffc020546a:	0007851b          	sext.w	a0,a5
ffffffffc020546e:	ffe1                	bnez	a5,ffffffffc0205446 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0205470:	01b05963          	blez	s11,ffffffffc0205482 <vprintfmt+0x244>
ffffffffc0205474:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0205476:	85a6                	mv	a1,s1
ffffffffc0205478:	02000513          	li	a0,32
ffffffffc020547c:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020547e:	fe0d9be3          	bnez	s11,ffffffffc0205474 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205482:	6a02                	ld	s4,0(sp)
ffffffffc0205484:	bbd5                	j	ffffffffc0205278 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205486:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205488:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020548c:	01174463          	blt	a4,a7,ffffffffc0205494 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0205490:	08088d63          	beqz	a7,ffffffffc020552a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0205494:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205498:	0a044d63          	bltz	s0,ffffffffc0205552 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020549c:	8622                	mv	a2,s0
ffffffffc020549e:	8a66                	mv	s4,s9
ffffffffc02054a0:	46a9                	li	a3,10
ffffffffc02054a2:	bdcd                	j	ffffffffc0205394 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02054a4:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02054a8:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc02054aa:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02054ac:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02054b0:	8fb5                	xor	a5,a5,a3
ffffffffc02054b2:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02054b6:	02d74163          	blt	a4,a3,ffffffffc02054d8 <vprintfmt+0x29a>
ffffffffc02054ba:	00369793          	slli	a5,a3,0x3
ffffffffc02054be:	97de                	add	a5,a5,s7
ffffffffc02054c0:	639c                	ld	a5,0(a5)
ffffffffc02054c2:	cb99                	beqz	a5,ffffffffc02054d8 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02054c4:	86be                	mv	a3,a5
ffffffffc02054c6:	00000617          	auipc	a2,0x0
ffffffffc02054ca:	1f260613          	addi	a2,a2,498 # ffffffffc02056b8 <etext+0x2c>
ffffffffc02054ce:	85a6                	mv	a1,s1
ffffffffc02054d0:	854a                	mv	a0,s2
ffffffffc02054d2:	0ce000ef          	jal	ra,ffffffffc02055a0 <printfmt>
ffffffffc02054d6:	b34d                	j	ffffffffc0205278 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02054d8:	00002617          	auipc	a2,0x2
ffffffffc02054dc:	00060613          	mv	a2,a2
ffffffffc02054e0:	85a6                	mv	a1,s1
ffffffffc02054e2:	854a                	mv	a0,s2
ffffffffc02054e4:	0bc000ef          	jal	ra,ffffffffc02055a0 <printfmt>
ffffffffc02054e8:	bb41                	j	ffffffffc0205278 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02054ea:	00002417          	auipc	s0,0x2
ffffffffc02054ee:	fe640413          	addi	s0,s0,-26 # ffffffffc02074d0 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02054f2:	85e2                	mv	a1,s8
ffffffffc02054f4:	8522                	mv	a0,s0
ffffffffc02054f6:	e43e                	sd	a5,8(sp)
ffffffffc02054f8:	0e2000ef          	jal	ra,ffffffffc02055da <strnlen>
ffffffffc02054fc:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205500:	01b05b63          	blez	s11,ffffffffc0205516 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205504:	67a2                	ld	a5,8(sp)
ffffffffc0205506:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020550a:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020550c:	85a6                	mv	a1,s1
ffffffffc020550e:	8552                	mv	a0,s4
ffffffffc0205510:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205512:	fe0d9ce3          	bnez	s11,ffffffffc020550a <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205516:	00044783          	lbu	a5,0(s0)
ffffffffc020551a:	00140a13          	addi	s4,s0,1
ffffffffc020551e:	0007851b          	sext.w	a0,a5
ffffffffc0205522:	d3a5                	beqz	a5,ffffffffc0205482 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205524:	05e00413          	li	s0,94
ffffffffc0205528:	bf39                	j	ffffffffc0205446 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020552a:	000a2403          	lw	s0,0(s4)
ffffffffc020552e:	b7ad                	j	ffffffffc0205498 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0205530:	000a6603          	lwu	a2,0(s4)
ffffffffc0205534:	46a1                	li	a3,8
ffffffffc0205536:	8a2e                	mv	s4,a1
ffffffffc0205538:	bdb1                	j	ffffffffc0205394 <vprintfmt+0x156>
ffffffffc020553a:	000a6603          	lwu	a2,0(s4)
ffffffffc020553e:	46a9                	li	a3,10
ffffffffc0205540:	8a2e                	mv	s4,a1
ffffffffc0205542:	bd89                	j	ffffffffc0205394 <vprintfmt+0x156>
ffffffffc0205544:	000a6603          	lwu	a2,0(s4)
ffffffffc0205548:	46c1                	li	a3,16
ffffffffc020554a:	8a2e                	mv	s4,a1
ffffffffc020554c:	b5a1                	j	ffffffffc0205394 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc020554e:	9902                	jalr	s2
ffffffffc0205550:	bf09                	j	ffffffffc0205462 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0205552:	85a6                	mv	a1,s1
ffffffffc0205554:	02d00513          	li	a0,45
ffffffffc0205558:	e03e                	sd	a5,0(sp)
ffffffffc020555a:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020555c:	6782                	ld	a5,0(sp)
ffffffffc020555e:	8a66                	mv	s4,s9
ffffffffc0205560:	40800633          	neg	a2,s0
ffffffffc0205564:	46a9                	li	a3,10
ffffffffc0205566:	b53d                	j	ffffffffc0205394 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0205568:	03b05163          	blez	s11,ffffffffc020558a <vprintfmt+0x34c>
ffffffffc020556c:	02d00693          	li	a3,45
ffffffffc0205570:	f6d79de3          	bne	a5,a3,ffffffffc02054ea <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0205574:	00002417          	auipc	s0,0x2
ffffffffc0205578:	f5c40413          	addi	s0,s0,-164 # ffffffffc02074d0 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020557c:	02800793          	li	a5,40
ffffffffc0205580:	02800513          	li	a0,40
ffffffffc0205584:	00140a13          	addi	s4,s0,1
ffffffffc0205588:	bd6d                	j	ffffffffc0205442 <vprintfmt+0x204>
ffffffffc020558a:	00002a17          	auipc	s4,0x2
ffffffffc020558e:	f47a0a13          	addi	s4,s4,-185 # ffffffffc02074d1 <syscalls+0x119>
ffffffffc0205592:	02800513          	li	a0,40
ffffffffc0205596:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020559a:	05e00413          	li	s0,94
ffffffffc020559e:	b565                	j	ffffffffc0205446 <vprintfmt+0x208>

ffffffffc02055a0 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055a0:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02055a2:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055a6:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02055a8:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055aa:	ec06                	sd	ra,24(sp)
ffffffffc02055ac:	f83a                	sd	a4,48(sp)
ffffffffc02055ae:	fc3e                	sd	a5,56(sp)
ffffffffc02055b0:	e0c2                	sd	a6,64(sp)
ffffffffc02055b2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02055b4:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02055b6:	c89ff0ef          	jal	ra,ffffffffc020523e <vprintfmt>
}
ffffffffc02055ba:	60e2                	ld	ra,24(sp)
ffffffffc02055bc:	6161                	addi	sp,sp,80
ffffffffc02055be:	8082                	ret

ffffffffc02055c0 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02055c0:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02055c4:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02055c6:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02055c8:	cb81                	beqz	a5,ffffffffc02055d8 <strlen+0x18>
        cnt ++;
ffffffffc02055ca:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02055cc:	00a707b3          	add	a5,a4,a0
ffffffffc02055d0:	0007c783          	lbu	a5,0(a5)
ffffffffc02055d4:	fbfd                	bnez	a5,ffffffffc02055ca <strlen+0xa>
ffffffffc02055d6:	8082                	ret
    }
    return cnt;
}
ffffffffc02055d8:	8082                	ret

ffffffffc02055da <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02055da:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02055dc:	e589                	bnez	a1,ffffffffc02055e6 <strnlen+0xc>
ffffffffc02055de:	a811                	j	ffffffffc02055f2 <strnlen+0x18>
        cnt ++;
ffffffffc02055e0:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02055e2:	00f58863          	beq	a1,a5,ffffffffc02055f2 <strnlen+0x18>
ffffffffc02055e6:	00f50733          	add	a4,a0,a5
ffffffffc02055ea:	00074703          	lbu	a4,0(a4)
ffffffffc02055ee:	fb6d                	bnez	a4,ffffffffc02055e0 <strnlen+0x6>
ffffffffc02055f0:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02055f2:	852e                	mv	a0,a1
ffffffffc02055f4:	8082                	ret

ffffffffc02055f6 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02055f6:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02055f8:	0005c703          	lbu	a4,0(a1)
ffffffffc02055fc:	0785                	addi	a5,a5,1
ffffffffc02055fe:	0585                	addi	a1,a1,1
ffffffffc0205600:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205604:	fb75                	bnez	a4,ffffffffc02055f8 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205606:	8082                	ret

ffffffffc0205608 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205608:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020560c:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205610:	cb89                	beqz	a5,ffffffffc0205622 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205612:	0505                	addi	a0,a0,1
ffffffffc0205614:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205616:	fee789e3          	beq	a5,a4,ffffffffc0205608 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020561a:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020561e:	9d19                	subw	a0,a0,a4
ffffffffc0205620:	8082                	ret
ffffffffc0205622:	4501                	li	a0,0
ffffffffc0205624:	bfed                	j	ffffffffc020561e <strcmp+0x16>

ffffffffc0205626 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205626:	c20d                	beqz	a2,ffffffffc0205648 <strncmp+0x22>
ffffffffc0205628:	962e                	add	a2,a2,a1
ffffffffc020562a:	a031                	j	ffffffffc0205636 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc020562c:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020562e:	00e79a63          	bne	a5,a4,ffffffffc0205642 <strncmp+0x1c>
ffffffffc0205632:	00b60b63          	beq	a2,a1,ffffffffc0205648 <strncmp+0x22>
ffffffffc0205636:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc020563a:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020563c:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0205640:	f7f5                	bnez	a5,ffffffffc020562c <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205642:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0205646:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205648:	4501                	li	a0,0
ffffffffc020564a:	8082                	ret

ffffffffc020564c <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc020564c:	00054783          	lbu	a5,0(a0)
ffffffffc0205650:	c799                	beqz	a5,ffffffffc020565e <strchr+0x12>
        if (*s == c) {
ffffffffc0205652:	00f58763          	beq	a1,a5,ffffffffc0205660 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0205656:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc020565a:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc020565c:	fbfd                	bnez	a5,ffffffffc0205652 <strchr+0x6>
    }
    return NULL;
ffffffffc020565e:	4501                	li	a0,0
}
ffffffffc0205660:	8082                	ret

ffffffffc0205662 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205662:	ca01                	beqz	a2,ffffffffc0205672 <memset+0x10>
ffffffffc0205664:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205666:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205668:	0785                	addi	a5,a5,1
ffffffffc020566a:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc020566e:	fec79de3          	bne	a5,a2,ffffffffc0205668 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205672:	8082                	ret

ffffffffc0205674 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205674:	ca19                	beqz	a2,ffffffffc020568a <memcpy+0x16>
ffffffffc0205676:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205678:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc020567a:	0005c703          	lbu	a4,0(a1)
ffffffffc020567e:	0585                	addi	a1,a1,1
ffffffffc0205680:	0785                	addi	a5,a5,1
ffffffffc0205682:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205686:	fec59ae3          	bne	a1,a2,ffffffffc020567a <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc020568a:	8082                	ret
