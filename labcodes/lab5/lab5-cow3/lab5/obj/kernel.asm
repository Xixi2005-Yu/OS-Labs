
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
ffffffffc020004a:	000bc517          	auipc	a0,0xbc
ffffffffc020004e:	c6e50513          	addi	a0,a0,-914 # ffffffffc02bbcb8 <buf>
ffffffffc0200052:	000c0617          	auipc	a2,0xc0
ffffffffc0200056:	10a60613          	addi	a2,a2,266 # ffffffffc02c015c <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	047050ef          	jal	ra,ffffffffc02058a8 <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	86a58593          	addi	a1,a1,-1942 # ffffffffc02058d8 <etext+0x6>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	88250513          	addi	a0,a0,-1918 # ffffffffc02058f8 <etext+0x26>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	15d020ef          	jal	ra,ffffffffc02029e2 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	3b3030ef          	jal	ra,ffffffffc0203c44 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	765040ef          	jal	ra,ffffffffc0204ffa <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	0f0050ef          	jal	ra,ffffffffc0205192 <cpu_idle>

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
ffffffffc02000bc:	00006517          	auipc	a0,0x6
ffffffffc02000c0:	84450513          	addi	a0,a0,-1980 # ffffffffc0205900 <etext+0x2e>
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
ffffffffc02000d2:	000bcb97          	auipc	s7,0xbc
ffffffffc02000d6:	be6b8b93          	addi	s7,s7,-1050 # ffffffffc02bbcb8 <buf>
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
ffffffffc020012e:	000bc517          	auipc	a0,0xbc
ffffffffc0200132:	b8a50513          	addi	a0,a0,-1142 # ffffffffc02bbcb8 <buf>
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
ffffffffc0200188:	2fc050ef          	jal	ra,ffffffffc0205484 <vprintfmt>
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
ffffffffc02001be:	2c6050ef          	jal	ra,ffffffffc0205484 <vprintfmt>
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
ffffffffc0200222:	6ea50513          	addi	a0,a0,1770 # ffffffffc0205908 <etext+0x36>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	6f450513          	addi	a0,a0,1780 # ffffffffc0205928 <etext+0x56>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	69258593          	addi	a1,a1,1682 # ffffffffc02058d2 <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	70050513          	addi	a0,a0,1792 # ffffffffc0205948 <etext+0x76>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000bc597          	auipc	a1,0xbc
ffffffffc0200258:	a6458593          	addi	a1,a1,-1436 # ffffffffc02bbcb8 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	70c50513          	addi	a0,a0,1804 # ffffffffc0205968 <etext+0x96>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000c0597          	auipc	a1,0xc0
ffffffffc020026c:	ef458593          	addi	a1,a1,-268 # ffffffffc02c015c <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	71850513          	addi	a0,a0,1816 # ffffffffc0205988 <etext+0xb6>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000c0597          	auipc	a1,0xc0
ffffffffc0200280:	2df58593          	addi	a1,a1,735 # ffffffffc02c055b <end+0x3ff>
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
ffffffffc02002a2:	70a50513          	addi	a0,a0,1802 # ffffffffc02059a8 <etext+0xd6>
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
ffffffffc02002b0:	72c60613          	addi	a2,a2,1836 # ffffffffc02059d8 <etext+0x106>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	73850513          	addi	a0,a0,1848 # ffffffffc02059f0 <etext+0x11e>
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
ffffffffc02002cc:	74060613          	addi	a2,a2,1856 # ffffffffc0205a08 <etext+0x136>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	75858593          	addi	a1,a1,1880 # ffffffffc0205a28 <etext+0x156>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	75850513          	addi	a0,a0,1880 # ffffffffc0205a30 <etext+0x15e>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	75a60613          	addi	a2,a2,1882 # ffffffffc0205a40 <etext+0x16e>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	77a58593          	addi	a1,a1,1914 # ffffffffc0205a68 <etext+0x196>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	73a50513          	addi	a0,a0,1850 # ffffffffc0205a30 <etext+0x15e>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	77660613          	addi	a2,a2,1910 # ffffffffc0205a78 <etext+0x1a6>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	78e58593          	addi	a1,a1,1934 # ffffffffc0205a98 <etext+0x1c6>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	71e50513          	addi	a0,a0,1822 # ffffffffc0205a30 <etext+0x15e>
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
ffffffffc0200350:	75c50513          	addi	a0,a0,1884 # ffffffffc0205aa8 <etext+0x1d6>
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
ffffffffc0200372:	76250513          	addi	a0,a0,1890 # ffffffffc0205ad0 <etext+0x1fe>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00005c17          	auipc	s8,0x5
ffffffffc0200388:	7bcc0c13          	addi	s8,s8,1980 # ffffffffc0205b40 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	76c90913          	addi	s2,s2,1900 # ffffffffc0205af8 <etext+0x226>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	76c48493          	addi	s1,s1,1900 # ffffffffc0205b00 <etext+0x22e>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	76ab0b13          	addi	s6,s6,1898 # ffffffffc0205b08 <etext+0x236>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	682a0a13          	addi	s4,s4,1666 # ffffffffc0205a28 <etext+0x156>
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
ffffffffc02003cc:	778d0d13          	addi	s10,s10,1912 # ffffffffc0205b40 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	478050ef          	jal	ra,ffffffffc020584e <strcmp>
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
ffffffffc02003ea:	464050ef          	jal	ra,ffffffffc020584e <strcmp>
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
ffffffffc0200428:	46a050ef          	jal	ra,ffffffffc0205892 <strchr>
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
ffffffffc0200466:	42c050ef          	jal	ra,ffffffffc0205892 <strchr>
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
ffffffffc0200484:	6a850513          	addi	a0,a0,1704 # ffffffffc0205b28 <etext+0x256>
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
ffffffffc020048e:	000c0317          	auipc	t1,0xc0
ffffffffc0200492:	c5230313          	addi	t1,t1,-942 # ffffffffc02c00e0 <is_panic>
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
ffffffffc02004c0:	6cc50513          	addi	a0,a0,1740 # ffffffffc0205b88 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00007517          	auipc	a0,0x7
ffffffffc02004d6:	92650513          	addi	a0,a0,-1754 # ffffffffc0206df8 <default_pmm_manager+0x520>
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
ffffffffc020050a:	6a250513          	addi	a0,a0,1698 # ffffffffc0205ba8 <commands+0x68>
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
ffffffffc0200526:	00007517          	auipc	a0,0x7
ffffffffc020052a:	8d250513          	addi	a0,a0,-1838 # ffffffffc0206df8 <default_pmm_manager+0x520>
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
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_dirtycow_test_out_size+0xd480>
ffffffffc0200540:	000c0717          	auipc	a4,0xc0
ffffffffc0200544:	baf73823          	sd	a5,-1104(a4) # ffffffffc02c00f0 <timebase>
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
ffffffffc0200564:	66850513          	addi	a0,a0,1640 # ffffffffc0205bc8 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000c0797          	auipc	a5,0xc0
ffffffffc020056c:	b807b023          	sd	zero,-1152(a5) # ffffffffc02c00e8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000c0797          	auipc	a5,0xc0
ffffffffc020057a:	b7a7b783          	ld	a5,-1158(a5) # ffffffffc02c00f0 <timebase>
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
ffffffffc0200604:	5e850513          	addi	a0,a0,1512 # ffffffffc0205be8 <commands+0xa8>
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
ffffffffc0200632:	5ca50513          	addi	a0,a0,1482 # ffffffffc0205bf8 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	5c450513          	addi	a0,a0,1476 # ffffffffc0205c08 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	5cc50513          	addi	a0,a0,1484 # ffffffffc0205c20 <commands+0xe0>
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
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe1fd91>
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
ffffffffc0200712:	56290913          	addi	s2,s2,1378 # ffffffffc0205c70 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	54c48493          	addi	s1,s1,1356 # ffffffffc0205c68 <commands+0x128>
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
ffffffffc0200774:	57850513          	addi	a0,a0,1400 # ffffffffc0205ce8 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	5a450513          	addi	a0,a0,1444 # ffffffffc0205d20 <commands+0x1e0>
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
ffffffffc02007c0:	48450513          	addi	a0,a0,1156 # ffffffffc0205c40 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	03c050ef          	jal	ra,ffffffffc0205806 <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	094050ef          	jal	ra,ffffffffc020586c <strncmp>
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
ffffffffc020086e:	7e1040ef          	jal	ra,ffffffffc020584e <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	3f650513          	addi	a0,a0,1014 # ffffffffc0205c78 <commands+0x138>
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
ffffffffc0200954:	34850513          	addi	a0,a0,840 # ffffffffc0205c98 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	34e50513          	addi	a0,a0,846 # ffffffffc0205cb0 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	35c50513          	addi	a0,a0,860 # ffffffffc0205cd0 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	3a050513          	addi	a0,a0,928 # ffffffffc0205d20 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000bf797          	auipc	a5,0xbf
ffffffffc020098c:	7687b823          	sd	s0,1904(a5) # ffffffffc02c00f8 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000bf797          	auipc	a5,0xbf
ffffffffc0200994:	7767b823          	sd	s6,1904(a5) # ffffffffc02c0100 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000bf517          	auipc	a0,0xbf
ffffffffc020099e:	75e53503          	ld	a0,1886(a0) # ffffffffc02c00f8 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000bf517          	auipc	a0,0xbf
ffffffffc02009a8:	75c53503          	ld	a0,1884(a0) # ffffffffc02c0100 <memory_size>
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
ffffffffc02009c4:	75078793          	addi	a5,a5,1872 # ffffffffc0201110 <__alltraps>
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
ffffffffc02009e2:	35a50513          	addi	a0,a0,858 # ffffffffc0205d38 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	36250513          	addi	a0,a0,866 # ffffffffc0205d50 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	36c50513          	addi	a0,a0,876 # ffffffffc0205d68 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	37650513          	addi	a0,a0,886 # ffffffffc0205d80 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	38050513          	addi	a0,a0,896 # ffffffffc0205d98 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	38a50513          	addi	a0,a0,906 # ffffffffc0205db0 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	39450513          	addi	a0,a0,916 # ffffffffc0205dc8 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	39e50513          	addi	a0,a0,926 # ffffffffc0205de0 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	3a850513          	addi	a0,a0,936 # ffffffffc0205df8 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	3b250513          	addi	a0,a0,946 # ffffffffc0205e10 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	3bc50513          	addi	a0,a0,956 # ffffffffc0205e28 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	3c650513          	addi	a0,a0,966 # ffffffffc0205e40 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	3d050513          	addi	a0,a0,976 # ffffffffc0205e58 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	3da50513          	addi	a0,a0,986 # ffffffffc0205e70 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	3e450513          	addi	a0,a0,996 # ffffffffc0205e88 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	3ee50513          	addi	a0,a0,1006 # ffffffffc0205ea0 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	3f850513          	addi	a0,a0,1016 # ffffffffc0205eb8 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	40250513          	addi	a0,a0,1026 # ffffffffc0205ed0 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	40c50513          	addi	a0,a0,1036 # ffffffffc0205ee8 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	41650513          	addi	a0,a0,1046 # ffffffffc0205f00 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	42050513          	addi	a0,a0,1056 # ffffffffc0205f18 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	42a50513          	addi	a0,a0,1066 # ffffffffc0205f30 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	43450513          	addi	a0,a0,1076 # ffffffffc0205f48 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	43e50513          	addi	a0,a0,1086 # ffffffffc0205f60 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	44850513          	addi	a0,a0,1096 # ffffffffc0205f78 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	45250513          	addi	a0,a0,1106 # ffffffffc0205f90 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	45c50513          	addi	a0,a0,1116 # ffffffffc0205fa8 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	46650513          	addi	a0,a0,1126 # ffffffffc0205fc0 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	47050513          	addi	a0,a0,1136 # ffffffffc0205fd8 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	47a50513          	addi	a0,a0,1146 # ffffffffc0205ff0 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	48450513          	addi	a0,a0,1156 # ffffffffc0206008 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	48a50513          	addi	a0,a0,1162 # ffffffffc0206020 <commands+0x4e0>
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
ffffffffc0200bb0:	48c50513          	addi	a0,a0,1164 # ffffffffc0206038 <commands+0x4f8>
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
ffffffffc0200bc8:	48c50513          	addi	a0,a0,1164 # ffffffffc0206050 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	49450513          	addi	a0,a0,1172 # ffffffffc0206068 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	49c50513          	addi	a0,a0,1180 # ffffffffc0206080 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	49850513          	addi	a0,a0,1176 # ffffffffc0206090 <commands+0x550>
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
ffffffffc0200c18:	53470713          	addi	a4,a4,1332 # ffffffffc0206148 <commands+0x608>
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
ffffffffc0200c2a:	4e250513          	addi	a0,a0,1250 # ffffffffc0206108 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	4b650513          	addi	a0,a0,1206 # ffffffffc02060e8 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	46a50513          	addi	a0,a0,1130 # ffffffffc02060a8 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	47e50513          	addi	a0,a0,1150 # ffffffffc02060c8 <commands+0x588>
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
ffffffffc0200c5e:	000bf797          	auipc	a5,0xbf
ffffffffc0200c62:	48a78793          	addi	a5,a5,1162 # ffffffffc02c00e8 <ticks>
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
ffffffffc0200c76:	000bf797          	auipc	a5,0xbf
ffffffffc0200c7a:	4607b923          	sd	zero,1138(a5) # ffffffffc02c00e8 <ticks>
            if (current != NULL && current != idleproc) {
ffffffffc0200c7e:	000bf797          	auipc	a5,0xbf
ffffffffc0200c82:	4c27b783          	ld	a5,1218(a5) # ffffffffc02c0140 <current>
ffffffffc0200c86:	cb89                	beqz	a5,ffffffffc0200c98 <interrupt_handler+0x92>
ffffffffc0200c88:	000bf717          	auipc	a4,0xbf
ffffffffc0200c8c:	4c073703          	ld	a4,1216(a4) # ffffffffc02c0148 <idleproc>
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
ffffffffc0200ca2:	48a50513          	addi	a0,a0,1162 # ffffffffc0206128 <commands+0x5e8>
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
ffffffffc0200cb0:	7139                	addi	sp,sp,-64
ffffffffc0200cb2:	f822                	sd	s0,48(sp)
ffffffffc0200cb4:	fc06                	sd	ra,56(sp)
ffffffffc0200cb6:	f426                	sd	s1,40(sp)
ffffffffc0200cb8:	f04a                	sd	s2,32(sp)
ffffffffc0200cba:	ec4e                	sd	s3,24(sp)
ffffffffc0200cbc:	e852                	sd	s4,16(sp)
ffffffffc0200cbe:	e456                	sd	s5,8(sp)
ffffffffc0200cc0:	e05a                	sd	s6,0(sp)
ffffffffc0200cc2:	473d                	li	a4,15
ffffffffc0200cc4:	842a                	mv	s0,a0
ffffffffc0200cc6:	16f76a63          	bltu	a4,a5,ffffffffc0200e3a <exception_handler+0x18e>
ffffffffc0200cca:	00006717          	auipc	a4,0x6
ffffffffc0200cce:	80a70713          	addi	a4,a4,-2038 # ffffffffc02064d4 <commands+0x994>
ffffffffc0200cd2:	078a                	slli	a5,a5,0x2
ffffffffc0200cd4:	97ba                	add	a5,a5,a4
ffffffffc0200cd6:	439c                	lw	a5,0(a5)
ffffffffc0200cd8:	97ba                	add	a5,a5,a4
ffffffffc0200cda:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cdc:	00005517          	auipc	a0,0x5
ffffffffc0200ce0:	58450513          	addi	a0,a0,1412 # ffffffffc0206260 <commands+0x720>
ffffffffc0200ce4:	cb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200ce8:	10843783          	ld	a5,264(s0)
    }
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cec:	70e2                	ld	ra,56(sp)
ffffffffc0200cee:	74a2                	ld	s1,40(sp)
        tf->epc += 4;
ffffffffc0200cf0:	0791                	addi	a5,a5,4
ffffffffc0200cf2:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cf6:	7442                	ld	s0,48(sp)
ffffffffc0200cf8:	7902                	ld	s2,32(sp)
ffffffffc0200cfa:	69e2                	ld	s3,24(sp)
ffffffffc0200cfc:	6a42                	ld	s4,16(sp)
ffffffffc0200cfe:	6aa2                	ld	s5,8(sp)
ffffffffc0200d00:	6b02                	ld	s6,0(sp)
ffffffffc0200d02:	6121                	addi	sp,sp,64
        syscall();
ffffffffc0200d04:	67e0406f          	j	ffffffffc0205382 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d08:	00005517          	auipc	a0,0x5
ffffffffc0200d0c:	57850513          	addi	a0,a0,1400 # ffffffffc0206280 <commands+0x740>
}
ffffffffc0200d10:	7442                	ld	s0,48(sp)
ffffffffc0200d12:	70e2                	ld	ra,56(sp)
ffffffffc0200d14:	74a2                	ld	s1,40(sp)
ffffffffc0200d16:	7902                	ld	s2,32(sp)
ffffffffc0200d18:	69e2                	ld	s3,24(sp)
ffffffffc0200d1a:	6a42                	ld	s4,16(sp)
ffffffffc0200d1c:	6aa2                	ld	s5,8(sp)
ffffffffc0200d1e:	6b02                	ld	s6,0(sp)
ffffffffc0200d20:	6121                	addi	sp,sp,64
        cprintf("Instruction access fault\n");
ffffffffc0200d22:	c72ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d26:	00005517          	auipc	a0,0x5
ffffffffc0200d2a:	57a50513          	addi	a0,a0,1402 # ffffffffc02062a0 <commands+0x760>
ffffffffc0200d2e:	b7cd                	j	ffffffffc0200d10 <exception_handler+0x64>
        cprintf("Instruction page fault\n");
ffffffffc0200d30:	00005517          	auipc	a0,0x5
ffffffffc0200d34:	59050513          	addi	a0,a0,1424 # ffffffffc02062c0 <commands+0x780>
ffffffffc0200d38:	bfe1                	j	ffffffffc0200d10 <exception_handler+0x64>
        cprintf("Load page fault\n");
ffffffffc0200d3a:	00005517          	auipc	a0,0x5
ffffffffc0200d3e:	59e50513          	addi	a0,a0,1438 # ffffffffc02062d8 <commands+0x798>
ffffffffc0200d42:	b7f9                	j	ffffffffc0200d10 <exception_handler+0x64>
        uintptr_t badv = tf->tval;
ffffffffc0200d44:	11053a03          	ld	s4,272(a0)
        cprintf("Store/AMO page fault at %p\n", (void *)badv);
ffffffffc0200d48:	00005517          	auipc	a0,0x5
ffffffffc0200d4c:	5a850513          	addi	a0,a0,1448 # ffffffffc02062f0 <commands+0x7b0>
ffffffffc0200d50:	85d2                	mv	a1,s4
ffffffffc0200d52:	c42ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        struct mm_struct *mm = current->mm;
ffffffffc0200d56:	000bf797          	auipc	a5,0xbf
ffffffffc0200d5a:	3ea7b783          	ld	a5,1002(a5) # ffffffffc02c0140 <current>
ffffffffc0200d5e:	0287b903          	ld	s2,40(a5)
        if (mm == NULL)
ffffffffc0200d62:	30090563          	beqz	s2,ffffffffc020106c <exception_handler+0x3c0>
        uintptr_t la = ROUNDDOWN(badv, PGSIZE);
ffffffffc0200d66:	79fd                	lui	s3,0xfffff
ffffffffc0200d68:	013a79b3          	and	s3,s4,s3
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0200d6c:	03890413          	addi	s0,s2,56
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200d70:	4785                	li	a5,1
ffffffffc0200d72:	40f437af          	amoor.d	a5,a5,(s0)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0200d76:	8b85                	andi	a5,a5,1
ffffffffc0200d78:	4485                	li	s1,1
ffffffffc0200d7a:	c799                	beqz	a5,ffffffffc0200d88 <exception_handler+0xdc>
    {
        schedule();
ffffffffc0200d7c:	51a040ef          	jal	ra,ffffffffc0205296 <schedule>
ffffffffc0200d80:	409437af          	amoor.d	a5,s1,(s0)
    while (!try_lock(lock))
ffffffffc0200d84:	8b85                	andi	a5,a5,1
ffffffffc0200d86:	fbfd                	bnez	a5,ffffffffc0200d7c <exception_handler+0xd0>
        pte_t *ptep = get_pte(mm->pgdir, la, 0);
ffffffffc0200d88:	01893503          	ld	a0,24(s2)
ffffffffc0200d8c:	4601                	li	a2,0
ffffffffc0200d8e:	85ce                	mv	a1,s3
ffffffffc0200d90:	46c010ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc0200d94:	842a                	mv	s0,a0
        if (ptep == NULL || !(*ptep & PTE_V))
ffffffffc0200d96:	c509                	beqz	a0,ffffffffc0200da0 <exception_handler+0xf4>
ffffffffc0200d98:	6118                	ld	a4,0(a0)
ffffffffc0200d9a:	00177793          	andi	a5,a4,1
ffffffffc0200d9e:	e7e9                	bnez	a5,ffffffffc0200e68 <exception_handler+0x1bc>
            cprintf("segfault: no mapping for %p\n", (void *)badv);
ffffffffc0200da0:	85d2                	mv	a1,s4
ffffffffc0200da2:	00005517          	auipc	a0,0x5
ffffffffc0200da6:	59e50513          	addi	a0,a0,1438 # ffffffffc0206340 <commands+0x800>
ffffffffc0200daa:	beaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200dae:	57f9                	li	a5,-2
ffffffffc0200db0:	03890713          	addi	a4,s2,56
ffffffffc0200db4:	60f737af          	amoand.d	a5,a5,(a4)
ffffffffc0200db8:	8b85                	andi	a5,a5,1
            do_exit(-E_INVAL);
ffffffffc0200dba:	5575                	li	a0,-3
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc0200dbc:	1a078d63          	beqz	a5,ffffffffc0200f76 <exception_handler+0x2ca>
}
ffffffffc0200dc0:	7442                	ld	s0,48(sp)
ffffffffc0200dc2:	70e2                	ld	ra,56(sp)
ffffffffc0200dc4:	74a2                	ld	s1,40(sp)
ffffffffc0200dc6:	7902                	ld	s2,32(sp)
ffffffffc0200dc8:	69e2                	ld	s3,24(sp)
ffffffffc0200dca:	6a42                	ld	s4,16(sp)
ffffffffc0200dcc:	6aa2                	ld	s5,8(sp)
ffffffffc0200dce:	6b02                	ld	s6,0(sp)
ffffffffc0200dd0:	6121                	addi	sp,sp,64
            do_exit(-E_NO_MEM);
ffffffffc0200dd2:	00b0306f          	j	ffffffffc02045dc <do_exit>
        cprintf("Instruction address misaligned\n");
ffffffffc0200dd6:	00005517          	auipc	a0,0x5
ffffffffc0200dda:	3a250513          	addi	a0,a0,930 # ffffffffc0206178 <commands+0x638>
ffffffffc0200dde:	bf0d                	j	ffffffffc0200d10 <exception_handler+0x64>
        cprintf("Instruction access fault\n");
ffffffffc0200de0:	00005517          	auipc	a0,0x5
ffffffffc0200de4:	3b850513          	addi	a0,a0,952 # ffffffffc0206198 <commands+0x658>
ffffffffc0200de8:	b725                	j	ffffffffc0200d10 <exception_handler+0x64>
        cprintf("Illegal instruction\n");
ffffffffc0200dea:	00005517          	auipc	a0,0x5
ffffffffc0200dee:	3ce50513          	addi	a0,a0,974 # ffffffffc02061b8 <commands+0x678>
ffffffffc0200df2:	bf39                	j	ffffffffc0200d10 <exception_handler+0x64>
        cprintf("Breakpoint\n");
ffffffffc0200df4:	00005517          	auipc	a0,0x5
ffffffffc0200df8:	3dc50513          	addi	a0,a0,988 # ffffffffc02061d0 <commands+0x690>
ffffffffc0200dfc:	b98ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200e00:	6458                	ld	a4,136(s0)
ffffffffc0200e02:	47a9                	li	a5,10
ffffffffc0200e04:	18f70563          	beq	a4,a5,ffffffffc0200f8e <exception_handler+0x2e2>
}
ffffffffc0200e08:	70e2                	ld	ra,56(sp)
ffffffffc0200e0a:	7442                	ld	s0,48(sp)
ffffffffc0200e0c:	74a2                	ld	s1,40(sp)
ffffffffc0200e0e:	7902                	ld	s2,32(sp)
ffffffffc0200e10:	69e2                	ld	s3,24(sp)
ffffffffc0200e12:	6a42                	ld	s4,16(sp)
ffffffffc0200e14:	6aa2                	ld	s5,8(sp)
ffffffffc0200e16:	6b02                	ld	s6,0(sp)
ffffffffc0200e18:	6121                	addi	sp,sp,64
ffffffffc0200e1a:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200e1c:	00005517          	auipc	a0,0x5
ffffffffc0200e20:	3c450513          	addi	a0,a0,964 # ffffffffc02061e0 <commands+0x6a0>
ffffffffc0200e24:	b5f5                	j	ffffffffc0200d10 <exception_handler+0x64>
        cprintf("Load access fault\n");
ffffffffc0200e26:	00005517          	auipc	a0,0x5
ffffffffc0200e2a:	3da50513          	addi	a0,a0,986 # ffffffffc0206200 <commands+0x6c0>
ffffffffc0200e2e:	b5cd                	j	ffffffffc0200d10 <exception_handler+0x64>
        cprintf("Store/AMO access fault\n");
ffffffffc0200e30:	00005517          	auipc	a0,0x5
ffffffffc0200e34:	41850513          	addi	a0,a0,1048 # ffffffffc0206248 <commands+0x708>
ffffffffc0200e38:	bde1                	j	ffffffffc0200d10 <exception_handler+0x64>
        print_trapframe(tf);
ffffffffc0200e3a:	8522                	mv	a0,s0
}
ffffffffc0200e3c:	7442                	ld	s0,48(sp)
ffffffffc0200e3e:	70e2                	ld	ra,56(sp)
ffffffffc0200e40:	74a2                	ld	s1,40(sp)
ffffffffc0200e42:	7902                	ld	s2,32(sp)
ffffffffc0200e44:	69e2                	ld	s3,24(sp)
ffffffffc0200e46:	6a42                	ld	s4,16(sp)
ffffffffc0200e48:	6aa2                	ld	s5,8(sp)
ffffffffc0200e4a:	6b02                	ld	s6,0(sp)
ffffffffc0200e4c:	6121                	addi	sp,sp,64
        print_trapframe(tf);
ffffffffc0200e4e:	bb99                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200e50:	00005617          	auipc	a2,0x5
ffffffffc0200e54:	3c860613          	addi	a2,a2,968 # ffffffffc0206218 <commands+0x6d8>
ffffffffc0200e58:	0c800593          	li	a1,200
ffffffffc0200e5c:	00005517          	auipc	a0,0x5
ffffffffc0200e60:	3d450513          	addi	a0,a0,980 # ffffffffc0206230 <commands+0x6f0>
ffffffffc0200e64:	e2aff0ef          	jal	ra,ffffffffc020048e <__panic>
}

static inline struct Page *
pa2page(uintptr_t pa)
{
    if (PPN(pa) >= npage)
ffffffffc0200e68:	000bfb17          	auipc	s6,0xbf
ffffffffc0200e6c:	2b8b0b13          	addi	s6,s6,696 # ffffffffc02c0120 <npage>
ffffffffc0200e70:	000b3783          	ld	a5,0(s6)
{
    if (!(pte & PTE_V))
    {
        panic("pte2page called with invalid pte");
    }
    return pa2page(PTE_ADDR(pte));
ffffffffc0200e74:	00271613          	slli	a2,a4,0x2
ffffffffc0200e78:	8231                	srli	a2,a2,0xc
    if (PPN(pa) >= npage)
ffffffffc0200e7a:	1cf67d63          	bgeu	a2,a5,ffffffffc0201054 <exception_handler+0x3a8>
    return &pages[PPN(pa) - nbase];
ffffffffc0200e7e:	000bfa97          	auipc	s5,0xbf
ffffffffc0200e82:	2aaa8a93          	addi	s5,s5,682 # ffffffffc02c0128 <pages>
ffffffffc0200e86:	00007a17          	auipc	s4,0x7
ffffffffc0200e8a:	d02a3a03          	ld	s4,-766(s4) # ffffffffc0207b88 <nbase>
ffffffffc0200e8e:	000ab483          	ld	s1,0(s5)
ffffffffc0200e92:	41460633          	sub	a2,a2,s4
ffffffffc0200e96:	061a                	slli	a2,a2,0x6
ffffffffc0200e98:	94b2                	add	s1,s1,a2
        cprintf("COW fault: va=%p ppn=%x ref=%d pte=0x%08x\n", (void *)la, page2ppn(page), page_ref(page), (uint32_t)(*ptep));
ffffffffc0200e9a:	4094                	lw	a3,0(s1)
    return page - pages + nbase;
ffffffffc0200e9c:	8619                	srai	a2,a2,0x6
ffffffffc0200e9e:	2701                	sext.w	a4,a4
ffffffffc0200ea0:	9652                	add	a2,a2,s4
ffffffffc0200ea2:	85ce                	mv	a1,s3
ffffffffc0200ea4:	00005517          	auipc	a0,0x5
ffffffffc0200ea8:	51450513          	addi	a0,a0,1300 # ffffffffc02063b8 <commands+0x878>
ffffffffc0200eac:	ae8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if ((*ptep & PTE_W) || page_ref(page) == 1)
ffffffffc0200eb0:	601c                	ld	a5,0(s0)
ffffffffc0200eb2:	000ab603          	ld	a2,0(s5)
ffffffffc0200eb6:	0047f713          	andi	a4,a5,4
ffffffffc0200eba:	10071363          	bnez	a4,ffffffffc0200fc0 <exception_handler+0x314>
}

static inline int
page_ref(struct Page *page)
{
    return page->ref;
ffffffffc0200ebe:	4094                	lw	a3,0(s1)
    return page - pages + nbase;
ffffffffc0200ec0:	40c48633          	sub	a2,s1,a2
ffffffffc0200ec4:	8619                	srai	a2,a2,0x6
ffffffffc0200ec6:	4705                	li	a4,1
ffffffffc0200ec8:	9652                	add	a2,a2,s4
ffffffffc0200eca:	0ee68f63          	beq	a3,a4,ffffffffc0200fc8 <exception_handler+0x31c>
        cprintf("COW alloc+copy: va=%p old_ppn=%x old_ref=%d\n", (void *)la, page2ppn(page), page_ref(page));
ffffffffc0200ece:	85ce                	mv	a1,s3
ffffffffc0200ed0:	00005517          	auipc	a0,0x5
ffffffffc0200ed4:	54050513          	addi	a0,a0,1344 # ffffffffc0206410 <commands+0x8d0>
ffffffffc0200ed8:	abcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        struct Page *npage = alloc_page();
ffffffffc0200edc:	4505                	li	a0,1
ffffffffc0200ede:	266010ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc0200ee2:	842a                	mv	s0,a0
        if (npage == NULL)
ffffffffc0200ee4:	10050c63          	beqz	a0,ffffffffc0200ffc <exception_handler+0x350>
ffffffffc0200ee8:	000ab783          	ld	a5,0(s5)
    return KADDR(page2pa(page));
ffffffffc0200eec:	567d                	li	a2,-1
ffffffffc0200eee:	000b3803          	ld	a6,0(s6)
    return page - pages + nbase;
ffffffffc0200ef2:	40f50733          	sub	a4,a0,a5
ffffffffc0200ef6:	8719                	srai	a4,a4,0x6
ffffffffc0200ef8:	9752                	add	a4,a4,s4
    return KADDR(page2pa(page));
ffffffffc0200efa:	8231                	srli	a2,a2,0xc
ffffffffc0200efc:	00c775b3          	and	a1,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f00:	00c71693          	slli	a3,a4,0xc
    return KADDR(page2pa(page));
ffffffffc0200f04:	1305fc63          	bgeu	a1,a6,ffffffffc020103c <exception_handler+0x390>
    return page - pages + nbase;
ffffffffc0200f08:	40f487b3          	sub	a5,s1,a5
ffffffffc0200f0c:	8799                	srai	a5,a5,0x6
ffffffffc0200f0e:	97d2                	add	a5,a5,s4
    return KADDR(page2pa(page));
ffffffffc0200f10:	000bf597          	auipc	a1,0xbf
ffffffffc0200f14:	2285b583          	ld	a1,552(a1) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0200f18:	8e7d                	and	a2,a2,a5
ffffffffc0200f1a:	00b68533          	add	a0,a3,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f1e:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0200f22:	11067d63          	bgeu	a2,a6,ffffffffc020103c <exception_handler+0x390>
        memcpy(page2kva(npage), page2kva(page), PGSIZE);
ffffffffc0200f26:	95b6                	add	a1,a1,a3
ffffffffc0200f28:	6605                	lui	a2,0x1
ffffffffc0200f2a:	191040ef          	jal	ra,ffffffffc02058ba <memcpy>
        page_remove(mm->pgdir, la);
ffffffffc0200f2e:	01893503          	ld	a0,24(s2)
ffffffffc0200f32:	85ce                	mv	a1,s3
ffffffffc0200f34:	11d010ef          	jal	ra,ffffffffc0202850 <page_remove>
        if (page_insert(mm->pgdir, npage, la, PTE_USER) != 0)
ffffffffc0200f38:	01893503          	ld	a0,24(s2)
ffffffffc0200f3c:	46fd                	li	a3,31
ffffffffc0200f3e:	864e                	mv	a2,s3
ffffffffc0200f40:	85a2                	mv	a1,s0
ffffffffc0200f42:	1ab010ef          	jal	ra,ffffffffc02028ec <page_insert>
ffffffffc0200f46:	e971                	bnez	a0,ffffffffc020101a <exception_handler+0x36e>
    return page - pages + nbase;
ffffffffc0200f48:	000ab603          	ld	a2,0(s5)
        cprintf("COW done: va=%p new_ppn=%x new_ref=%d old_ref=%d\n", (void *)la, page2ppn(npage), page_ref(npage), page_ref(page));
ffffffffc0200f4c:	4098                	lw	a4,0(s1)
ffffffffc0200f4e:	4014                	lw	a3,0(s0)
ffffffffc0200f50:	40c40633          	sub	a2,s0,a2
ffffffffc0200f54:	8619                	srai	a2,a2,0x6
ffffffffc0200f56:	9652                	add	a2,a2,s4
ffffffffc0200f58:	85ce                	mv	a1,s3
ffffffffc0200f5a:	00005517          	auipc	a0,0x5
ffffffffc0200f5e:	54650513          	addi	a0,a0,1350 # ffffffffc02064a0 <commands+0x960>
ffffffffc0200f62:	a32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200f66:	57f9                	li	a5,-2
ffffffffc0200f68:	03890713          	addi	a4,s2,56
ffffffffc0200f6c:	60f737af          	amoand.d	a5,a5,(a4)
ffffffffc0200f70:	8b85                	andi	a5,a5,1
ffffffffc0200f72:	e8079be3          	bnez	a5,ffffffffc0200e08 <exception_handler+0x15c>
    {
        panic("Unlock failed.\n");
ffffffffc0200f76:	00005617          	auipc	a2,0x5
ffffffffc0200f7a:	3ea60613          	addi	a2,a2,1002 # ffffffffc0206360 <commands+0x820>
ffffffffc0200f7e:	03f00593          	li	a1,63
ffffffffc0200f82:	00005517          	auipc	a0,0x5
ffffffffc0200f86:	3ee50513          	addi	a0,a0,1006 # ffffffffc0206370 <commands+0x830>
ffffffffc0200f8a:	d04ff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200f8e:	10843783          	ld	a5,264(s0)
ffffffffc0200f92:	0791                	addi	a5,a5,4
ffffffffc0200f94:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200f98:	3ea040ef          	jal	ra,ffffffffc0205382 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f9c:	000bf797          	auipc	a5,0xbf
ffffffffc0200fa0:	1a47b783          	ld	a5,420(a5) # ffffffffc02c0140 <current>
ffffffffc0200fa4:	6b9c                	ld	a5,16(a5)
ffffffffc0200fa6:	8522                	mv	a0,s0
}
ffffffffc0200fa8:	7442                	ld	s0,48(sp)
ffffffffc0200faa:	70e2                	ld	ra,56(sp)
ffffffffc0200fac:	74a2                	ld	s1,40(sp)
ffffffffc0200fae:	7902                	ld	s2,32(sp)
ffffffffc0200fb0:	69e2                	ld	s3,24(sp)
ffffffffc0200fb2:	6a42                	ld	s4,16(sp)
ffffffffc0200fb4:	6aa2                	ld	s5,8(sp)
ffffffffc0200fb6:	6b02                	ld	s6,0(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200fb8:	6589                	lui	a1,0x2
ffffffffc0200fba:	95be                	add	a1,a1,a5
}
ffffffffc0200fbc:	6121                	addi	sp,sp,64
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200fbe:	a405                	j	ffffffffc02011de <kernel_execve_ret>
ffffffffc0200fc0:	40c48633          	sub	a2,s1,a2
ffffffffc0200fc4:	8619                	srai	a2,a2,0x6
ffffffffc0200fc6:	9652                	add	a2,a2,s4
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0200fc8:	062a                	slli	a2,a2,0xa
            uint32_t user_bits = (*ptep & (PTE_R | PTE_X | PTE_U));
ffffffffc0200fca:	8be9                	andi	a5,a5,26
            tlb_invalidate(mm->pgdir, la);
ffffffffc0200fcc:	01893503          	ld	a0,24(s2)
ffffffffc0200fd0:	8fd1                	or	a5,a5,a2
ffffffffc0200fd2:	0057e793          	ori	a5,a5,5
ffffffffc0200fd6:	85ce                	mv	a1,s3
            *ptep = pte_create(page2ppn(page), user_bits | PTE_W);
ffffffffc0200fd8:	e01c                	sd	a5,0(s0)
            tlb_invalidate(mm->pgdir, la);
ffffffffc0200fda:	02d020ef          	jal	ra,ffffffffc0203806 <tlb_invalidate>
    return page - pages + nbase;
ffffffffc0200fde:	000ab603          	ld	a2,0(s5)
            cprintf("COW promote: va=%p ppn=%x ref=%d\n", (void *)la, page2ppn(page), page_ref(page));
ffffffffc0200fe2:	4094                	lw	a3,0(s1)
ffffffffc0200fe4:	85ce                	mv	a1,s3
ffffffffc0200fe6:	40c48633          	sub	a2,s1,a2
ffffffffc0200fea:	8619                	srai	a2,a2,0x6
ffffffffc0200fec:	9652                	add	a2,a2,s4
ffffffffc0200fee:	00005517          	auipc	a0,0x5
ffffffffc0200ff2:	3fa50513          	addi	a0,a0,1018 # ffffffffc02063e8 <commands+0x8a8>
ffffffffc0200ff6:	99eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200ffa:	b7b5                	j	ffffffffc0200f66 <exception_handler+0x2ba>
            cprintf("COW: alloc_page failed\n");
ffffffffc0200ffc:	00005517          	auipc	a0,0x5
ffffffffc0201000:	44450513          	addi	a0,a0,1092 # ffffffffc0206440 <commands+0x900>
ffffffffc0201004:	990ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0201008:	57f9                	li	a5,-2
ffffffffc020100a:	03890713          	addi	a4,s2,56
ffffffffc020100e:	60f737af          	amoand.d	a5,a5,(a4)
ffffffffc0201012:	8b85                	andi	a5,a5,1
    if (!test_and_clear_bit(0, lock))
ffffffffc0201014:	d3ad                	beqz	a5,ffffffffc0200f76 <exception_handler+0x2ca>
            do_exit(-E_NO_MEM);
ffffffffc0201016:	5571                	li	a0,-4
ffffffffc0201018:	b365                	j	ffffffffc0200dc0 <exception_handler+0x114>
            cprintf("COW: page_insert failed\n");
ffffffffc020101a:	00005517          	auipc	a0,0x5
ffffffffc020101e:	46650513          	addi	a0,a0,1126 # ffffffffc0206480 <commands+0x940>
ffffffffc0201022:	972ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0201026:	57f9                	li	a5,-2
ffffffffc0201028:	03890713          	addi	a4,s2,56
ffffffffc020102c:	60f737af          	amoand.d	a5,a5,(a4)
ffffffffc0201030:	8b85                	andi	a5,a5,1
ffffffffc0201032:	d3b1                	beqz	a5,ffffffffc0200f76 <exception_handler+0x2ca>
            do_exit(-E_NO_MEM);
ffffffffc0201034:	5571                	li	a0,-4
ffffffffc0201036:	5a6030ef          	jal	ra,ffffffffc02045dc <do_exit>
ffffffffc020103a:	b739                	j	ffffffffc0200f48 <exception_handler+0x29c>
    return KADDR(page2pa(page));
ffffffffc020103c:	00005617          	auipc	a2,0x5
ffffffffc0201040:	41c60613          	addi	a2,a2,1052 # ffffffffc0206458 <commands+0x918>
ffffffffc0201044:	07100593          	li	a1,113
ffffffffc0201048:	00005517          	auipc	a0,0x5
ffffffffc020104c:	36050513          	addi	a0,a0,864 # ffffffffc02063a8 <commands+0x868>
ffffffffc0201050:	c3eff0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0201054:	00005617          	auipc	a2,0x5
ffffffffc0201058:	33460613          	addi	a2,a2,820 # ffffffffc0206388 <commands+0x848>
ffffffffc020105c:	06900593          	li	a1,105
ffffffffc0201060:	00005517          	auipc	a0,0x5
ffffffffc0201064:	34850513          	addi	a0,a0,840 # ffffffffc02063a8 <commands+0x868>
ffffffffc0201068:	c26ff0ef          	jal	ra,ffffffffc020048e <__panic>
            panic("store page fault in kernel or kernel-thread\n");
ffffffffc020106c:	00005617          	auipc	a2,0x5
ffffffffc0201070:	2a460613          	addi	a2,a2,676 # ffffffffc0206310 <commands+0x7d0>
ffffffffc0201074:	0eb00593          	li	a1,235
ffffffffc0201078:	00005517          	auipc	a0,0x5
ffffffffc020107c:	1b850513          	addi	a0,a0,440 # ffffffffc0206230 <commands+0x6f0>
ffffffffc0201080:	c0eff0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201084 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0201084:	1101                	addi	sp,sp,-32
ffffffffc0201086:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0201088:	000bf417          	auipc	s0,0xbf
ffffffffc020108c:	0b840413          	addi	s0,s0,184 # ffffffffc02c0140 <current>
ffffffffc0201090:	6018                	ld	a4,0(s0)
{
ffffffffc0201092:	ec06                	sd	ra,24(sp)
ffffffffc0201094:	e426                	sd	s1,8(sp)
ffffffffc0201096:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0201098:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc020109c:	cf1d                	beqz	a4,ffffffffc02010da <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc020109e:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc02010a2:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc02010a6:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02010a8:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc02010ac:	0206c463          	bltz	a3,ffffffffc02010d4 <trap+0x50>
        exception_handler(tf);
ffffffffc02010b0:	bfdff0ef          	jal	ra,ffffffffc0200cac <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc02010b4:	601c                	ld	a5,0(s0)
ffffffffc02010b6:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc02010ba:	e499                	bnez	s1,ffffffffc02010c8 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc02010bc:	0b07a703          	lw	a4,176(a5)
ffffffffc02010c0:	8b05                	andi	a4,a4,1
ffffffffc02010c2:	e329                	bnez	a4,ffffffffc0201104 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc02010c4:	6f9c                	ld	a5,24(a5)
ffffffffc02010c6:	eb85                	bnez	a5,ffffffffc02010f6 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc02010c8:	60e2                	ld	ra,24(sp)
ffffffffc02010ca:	6442                	ld	s0,16(sp)
ffffffffc02010cc:	64a2                	ld	s1,8(sp)
ffffffffc02010ce:	6902                	ld	s2,0(sp)
ffffffffc02010d0:	6105                	addi	sp,sp,32
ffffffffc02010d2:	8082                	ret
        interrupt_handler(tf);
ffffffffc02010d4:	b33ff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc02010d8:	bff1                	j	ffffffffc02010b4 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc02010da:	0006c863          	bltz	a3,ffffffffc02010ea <trap+0x66>
}
ffffffffc02010de:	6442                	ld	s0,16(sp)
ffffffffc02010e0:	60e2                	ld	ra,24(sp)
ffffffffc02010e2:	64a2                	ld	s1,8(sp)
ffffffffc02010e4:	6902                	ld	s2,0(sp)
ffffffffc02010e6:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc02010e8:	b6d1                	j	ffffffffc0200cac <exception_handler>
}
ffffffffc02010ea:	6442                	ld	s0,16(sp)
ffffffffc02010ec:	60e2                	ld	ra,24(sp)
ffffffffc02010ee:	64a2                	ld	s1,8(sp)
ffffffffc02010f0:	6902                	ld	s2,0(sp)
ffffffffc02010f2:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc02010f4:	be09                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc02010f6:	6442                	ld	s0,16(sp)
ffffffffc02010f8:	60e2                	ld	ra,24(sp)
ffffffffc02010fa:	64a2                	ld	s1,8(sp)
ffffffffc02010fc:	6902                	ld	s2,0(sp)
ffffffffc02010fe:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0201100:	1960406f          	j	ffffffffc0205296 <schedule>
                do_exit(-E_KILLED);
ffffffffc0201104:	555d                	li	a0,-9
ffffffffc0201106:	4d6030ef          	jal	ra,ffffffffc02045dc <do_exit>
            if (current->need_resched)
ffffffffc020110a:	601c                	ld	a5,0(s0)
ffffffffc020110c:	bf65                	j	ffffffffc02010c4 <trap+0x40>
	...

ffffffffc0201110 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0201110:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0201114:	00011463          	bnez	sp,ffffffffc020111c <__alltraps+0xc>
ffffffffc0201118:	14002173          	csrr	sp,sscratch
ffffffffc020111c:	712d                	addi	sp,sp,-288
ffffffffc020111e:	e002                	sd	zero,0(sp)
ffffffffc0201120:	e406                	sd	ra,8(sp)
ffffffffc0201122:	ec0e                	sd	gp,24(sp)
ffffffffc0201124:	f012                	sd	tp,32(sp)
ffffffffc0201126:	f416                	sd	t0,40(sp)
ffffffffc0201128:	f81a                	sd	t1,48(sp)
ffffffffc020112a:	fc1e                	sd	t2,56(sp)
ffffffffc020112c:	e0a2                	sd	s0,64(sp)
ffffffffc020112e:	e4a6                	sd	s1,72(sp)
ffffffffc0201130:	e8aa                	sd	a0,80(sp)
ffffffffc0201132:	ecae                	sd	a1,88(sp)
ffffffffc0201134:	f0b2                	sd	a2,96(sp)
ffffffffc0201136:	f4b6                	sd	a3,104(sp)
ffffffffc0201138:	f8ba                	sd	a4,112(sp)
ffffffffc020113a:	fcbe                	sd	a5,120(sp)
ffffffffc020113c:	e142                	sd	a6,128(sp)
ffffffffc020113e:	e546                	sd	a7,136(sp)
ffffffffc0201140:	e94a                	sd	s2,144(sp)
ffffffffc0201142:	ed4e                	sd	s3,152(sp)
ffffffffc0201144:	f152                	sd	s4,160(sp)
ffffffffc0201146:	f556                	sd	s5,168(sp)
ffffffffc0201148:	f95a                	sd	s6,176(sp)
ffffffffc020114a:	fd5e                	sd	s7,184(sp)
ffffffffc020114c:	e1e2                	sd	s8,192(sp)
ffffffffc020114e:	e5e6                	sd	s9,200(sp)
ffffffffc0201150:	e9ea                	sd	s10,208(sp)
ffffffffc0201152:	edee                	sd	s11,216(sp)
ffffffffc0201154:	f1f2                	sd	t3,224(sp)
ffffffffc0201156:	f5f6                	sd	t4,232(sp)
ffffffffc0201158:	f9fa                	sd	t5,240(sp)
ffffffffc020115a:	fdfe                	sd	t6,248(sp)
ffffffffc020115c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201160:	100024f3          	csrr	s1,sstatus
ffffffffc0201164:	14102973          	csrr	s2,sepc
ffffffffc0201168:	143029f3          	csrr	s3,stval
ffffffffc020116c:	14202a73          	csrr	s4,scause
ffffffffc0201170:	e822                	sd	s0,16(sp)
ffffffffc0201172:	e226                	sd	s1,256(sp)
ffffffffc0201174:	e64a                	sd	s2,264(sp)
ffffffffc0201176:	ea4e                	sd	s3,272(sp)
ffffffffc0201178:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc020117a:	850a                	mv	a0,sp
    jal trap
ffffffffc020117c:	f09ff0ef          	jal	ra,ffffffffc0201084 <trap>

ffffffffc0201180 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0201180:	6492                	ld	s1,256(sp)
ffffffffc0201182:	6932                	ld	s2,264(sp)
ffffffffc0201184:	1004f413          	andi	s0,s1,256
ffffffffc0201188:	e401                	bnez	s0,ffffffffc0201190 <__trapret+0x10>
ffffffffc020118a:	1200                	addi	s0,sp,288
ffffffffc020118c:	14041073          	csrw	sscratch,s0
ffffffffc0201190:	10049073          	csrw	sstatus,s1
ffffffffc0201194:	14191073          	csrw	sepc,s2
ffffffffc0201198:	60a2                	ld	ra,8(sp)
ffffffffc020119a:	61e2                	ld	gp,24(sp)
ffffffffc020119c:	7202                	ld	tp,32(sp)
ffffffffc020119e:	72a2                	ld	t0,40(sp)
ffffffffc02011a0:	7342                	ld	t1,48(sp)
ffffffffc02011a2:	73e2                	ld	t2,56(sp)
ffffffffc02011a4:	6406                	ld	s0,64(sp)
ffffffffc02011a6:	64a6                	ld	s1,72(sp)
ffffffffc02011a8:	6546                	ld	a0,80(sp)
ffffffffc02011aa:	65e6                	ld	a1,88(sp)
ffffffffc02011ac:	7606                	ld	a2,96(sp)
ffffffffc02011ae:	76a6                	ld	a3,104(sp)
ffffffffc02011b0:	7746                	ld	a4,112(sp)
ffffffffc02011b2:	77e6                	ld	a5,120(sp)
ffffffffc02011b4:	680a                	ld	a6,128(sp)
ffffffffc02011b6:	68aa                	ld	a7,136(sp)
ffffffffc02011b8:	694a                	ld	s2,144(sp)
ffffffffc02011ba:	69ea                	ld	s3,152(sp)
ffffffffc02011bc:	7a0a                	ld	s4,160(sp)
ffffffffc02011be:	7aaa                	ld	s5,168(sp)
ffffffffc02011c0:	7b4a                	ld	s6,176(sp)
ffffffffc02011c2:	7bea                	ld	s7,184(sp)
ffffffffc02011c4:	6c0e                	ld	s8,192(sp)
ffffffffc02011c6:	6cae                	ld	s9,200(sp)
ffffffffc02011c8:	6d4e                	ld	s10,208(sp)
ffffffffc02011ca:	6dee                	ld	s11,216(sp)
ffffffffc02011cc:	7e0e                	ld	t3,224(sp)
ffffffffc02011ce:	7eae                	ld	t4,232(sp)
ffffffffc02011d0:	7f4e                	ld	t5,240(sp)
ffffffffc02011d2:	7fee                	ld	t6,248(sp)
ffffffffc02011d4:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc02011d6:	10200073          	sret

ffffffffc02011da <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc02011da:	812a                	mv	sp,a0
    j __trapret
ffffffffc02011dc:	b755                	j	ffffffffc0201180 <__trapret>

ffffffffc02011de <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc02011de:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc02011e2:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc02011e6:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc02011ea:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc02011ee:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc02011f2:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc02011f6:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc02011fa:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc02011fe:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0201202:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0201204:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0201206:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0201208:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc020120a:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc020120c:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc020120e:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0201210:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0201212:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0201214:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0201216:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0201218:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc020121a:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc020121c:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc020121e:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0201220:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0201222:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0201224:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0201226:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0201228:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc020122a:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc020122c:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc020122e:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0201230:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0201232:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0201234:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0201236:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0201238:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc020123a:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc020123c:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc020123e:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0201240:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0201242:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0201244:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0201246:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0201248:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc020124a:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc020124c:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc020124e:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0201250:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0201252:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0201254:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0201256:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0201258:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc020125a:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc020125c:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc020125e:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201260:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0201262:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0201264:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0201266:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0201268:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc020126a:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc020126c:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc020126e:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0201270:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0201272:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0201274:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0201276:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0201278:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc020127a:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc020127c:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc020127e:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0201280:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0201282:	812e                	mv	sp,a1
ffffffffc0201284:	bdf5                	j	ffffffffc0201180 <__trapret>

ffffffffc0201286 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201286:	000bb797          	auipc	a5,0xbb
ffffffffc020128a:	e3278793          	addi	a5,a5,-462 # ffffffffc02bc0b8 <free_area>
ffffffffc020128e:	e79c                	sd	a5,8(a5)
ffffffffc0201290:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201292:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201296:	8082                	ret

ffffffffc0201298 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0201298:	000bb517          	auipc	a0,0xbb
ffffffffc020129c:	e3056503          	lwu	a0,-464(a0) # ffffffffc02bc0c8 <free_area+0x10>
ffffffffc02012a0:	8082                	ret

ffffffffc02012a2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc02012a2:	715d                	addi	sp,sp,-80
ffffffffc02012a4:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02012a6:	000bb417          	auipc	s0,0xbb
ffffffffc02012aa:	e1240413          	addi	s0,s0,-494 # ffffffffc02bc0b8 <free_area>
ffffffffc02012ae:	641c                	ld	a5,8(s0)
ffffffffc02012b0:	e486                	sd	ra,72(sp)
ffffffffc02012b2:	fc26                	sd	s1,56(sp)
ffffffffc02012b4:	f84a                	sd	s2,48(sp)
ffffffffc02012b6:	f44e                	sd	s3,40(sp)
ffffffffc02012b8:	f052                	sd	s4,32(sp)
ffffffffc02012ba:	ec56                	sd	s5,24(sp)
ffffffffc02012bc:	e85a                	sd	s6,16(sp)
ffffffffc02012be:	e45e                	sd	s7,8(sp)
ffffffffc02012c0:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02012c2:	2a878d63          	beq	a5,s0,ffffffffc020157c <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc02012c6:	4481                	li	s1,0
ffffffffc02012c8:	4901                	li	s2,0
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02012ca:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02012ce:	8b09                	andi	a4,a4,2
ffffffffc02012d0:	2a070a63          	beqz	a4,ffffffffc0201584 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc02012d4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012d8:	679c                	ld	a5,8(a5)
ffffffffc02012da:	2905                	addiw	s2,s2,1
ffffffffc02012dc:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02012de:	fe8796e3          	bne	a5,s0,ffffffffc02012ca <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02012e2:	89a6                	mv	s3,s1
ffffffffc02012e4:	6df000ef          	jal	ra,ffffffffc02021c2 <nr_free_pages>
ffffffffc02012e8:	6f351e63          	bne	a0,s3,ffffffffc02019e4 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012ec:	4505                	li	a0,1
ffffffffc02012ee:	657000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02012f2:	8aaa                	mv	s5,a0
ffffffffc02012f4:	42050863          	beqz	a0,ffffffffc0201724 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012f8:	4505                	li	a0,1
ffffffffc02012fa:	64b000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02012fe:	89aa                	mv	s3,a0
ffffffffc0201300:	70050263          	beqz	a0,ffffffffc0201a04 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201304:	4505                	li	a0,1
ffffffffc0201306:	63f000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc020130a:	8a2a                	mv	s4,a0
ffffffffc020130c:	48050c63          	beqz	a0,ffffffffc02017a4 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201310:	293a8a63          	beq	s5,s3,ffffffffc02015a4 <default_check+0x302>
ffffffffc0201314:	28aa8863          	beq	s5,a0,ffffffffc02015a4 <default_check+0x302>
ffffffffc0201318:	28a98663          	beq	s3,a0,ffffffffc02015a4 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020131c:	000aa783          	lw	a5,0(s5)
ffffffffc0201320:	2a079263          	bnez	a5,ffffffffc02015c4 <default_check+0x322>
ffffffffc0201324:	0009a783          	lw	a5,0(s3) # fffffffffffff000 <end+0x3fd3eea4>
ffffffffc0201328:	28079e63          	bnez	a5,ffffffffc02015c4 <default_check+0x322>
ffffffffc020132c:	411c                	lw	a5,0(a0)
ffffffffc020132e:	28079b63          	bnez	a5,ffffffffc02015c4 <default_check+0x322>
    return page - pages + nbase;
ffffffffc0201332:	000bf797          	auipc	a5,0xbf
ffffffffc0201336:	df67b783          	ld	a5,-522(a5) # ffffffffc02c0128 <pages>
ffffffffc020133a:	40fa8733          	sub	a4,s5,a5
ffffffffc020133e:	00007617          	auipc	a2,0x7
ffffffffc0201342:	84a63603          	ld	a2,-1974(a2) # ffffffffc0207b88 <nbase>
ffffffffc0201346:	8719                	srai	a4,a4,0x6
ffffffffc0201348:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020134a:	000bf697          	auipc	a3,0xbf
ffffffffc020134e:	dd66b683          	ld	a3,-554(a3) # ffffffffc02c0120 <npage>
ffffffffc0201352:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201354:	0732                	slli	a4,a4,0xc
ffffffffc0201356:	28d77763          	bgeu	a4,a3,ffffffffc02015e4 <default_check+0x342>
    return page - pages + nbase;
ffffffffc020135a:	40f98733          	sub	a4,s3,a5
ffffffffc020135e:	8719                	srai	a4,a4,0x6
ffffffffc0201360:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201362:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201364:	4cd77063          	bgeu	a4,a3,ffffffffc0201824 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201368:	40f507b3          	sub	a5,a0,a5
ffffffffc020136c:	8799                	srai	a5,a5,0x6
ffffffffc020136e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201370:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201372:	30d7f963          	bgeu	a5,a3,ffffffffc0201684 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0201376:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201378:	00043c03          	ld	s8,0(s0)
ffffffffc020137c:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201380:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201384:	e400                	sd	s0,8(s0)
ffffffffc0201386:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201388:	000bb797          	auipc	a5,0xbb
ffffffffc020138c:	d407a023          	sw	zero,-704(a5) # ffffffffc02bc0c8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201390:	5b5000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc0201394:	2c051863          	bnez	a0,ffffffffc0201664 <default_check+0x3c2>
    free_page(p0);
ffffffffc0201398:	4585                	li	a1,1
ffffffffc020139a:	8556                	mv	a0,s5
ffffffffc020139c:	5e7000ef          	jal	ra,ffffffffc0202182 <free_pages>
    free_page(p1);
ffffffffc02013a0:	4585                	li	a1,1
ffffffffc02013a2:	854e                	mv	a0,s3
ffffffffc02013a4:	5df000ef          	jal	ra,ffffffffc0202182 <free_pages>
    free_page(p2);
ffffffffc02013a8:	4585                	li	a1,1
ffffffffc02013aa:	8552                	mv	a0,s4
ffffffffc02013ac:	5d7000ef          	jal	ra,ffffffffc0202182 <free_pages>
    assert(nr_free == 3);
ffffffffc02013b0:	4818                	lw	a4,16(s0)
ffffffffc02013b2:	478d                	li	a5,3
ffffffffc02013b4:	28f71863          	bne	a4,a5,ffffffffc0201644 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02013b8:	4505                	li	a0,1
ffffffffc02013ba:	58b000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02013be:	89aa                	mv	s3,a0
ffffffffc02013c0:	26050263          	beqz	a0,ffffffffc0201624 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02013c4:	4505                	li	a0,1
ffffffffc02013c6:	57f000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02013ca:	8aaa                	mv	s5,a0
ffffffffc02013cc:	3a050c63          	beqz	a0,ffffffffc0201784 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013d0:	4505                	li	a0,1
ffffffffc02013d2:	573000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02013d6:	8a2a                	mv	s4,a0
ffffffffc02013d8:	38050663          	beqz	a0,ffffffffc0201764 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc02013dc:	4505                	li	a0,1
ffffffffc02013de:	567000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02013e2:	36051163          	bnez	a0,ffffffffc0201744 <default_check+0x4a2>
    free_page(p0);
ffffffffc02013e6:	4585                	li	a1,1
ffffffffc02013e8:	854e                	mv	a0,s3
ffffffffc02013ea:	599000ef          	jal	ra,ffffffffc0202182 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02013ee:	641c                	ld	a5,8(s0)
ffffffffc02013f0:	20878a63          	beq	a5,s0,ffffffffc0201604 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc02013f4:	4505                	li	a0,1
ffffffffc02013f6:	54f000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02013fa:	30a99563          	bne	s3,a0,ffffffffc0201704 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc02013fe:	4505                	li	a0,1
ffffffffc0201400:	545000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc0201404:	2e051063          	bnez	a0,ffffffffc02016e4 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201408:	481c                	lw	a5,16(s0)
ffffffffc020140a:	2a079d63          	bnez	a5,ffffffffc02016c4 <default_check+0x422>
    free_page(p);
ffffffffc020140e:	854e                	mv	a0,s3
ffffffffc0201410:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201412:	01843023          	sd	s8,0(s0)
ffffffffc0201416:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020141a:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc020141e:	565000ef          	jal	ra,ffffffffc0202182 <free_pages>
    free_page(p1);
ffffffffc0201422:	4585                	li	a1,1
ffffffffc0201424:	8556                	mv	a0,s5
ffffffffc0201426:	55d000ef          	jal	ra,ffffffffc0202182 <free_pages>
    free_page(p2);
ffffffffc020142a:	4585                	li	a1,1
ffffffffc020142c:	8552                	mv	a0,s4
ffffffffc020142e:	555000ef          	jal	ra,ffffffffc0202182 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201432:	4515                	li	a0,5
ffffffffc0201434:	511000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc0201438:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020143a:	26050563          	beqz	a0,ffffffffc02016a4 <default_check+0x402>
ffffffffc020143e:	651c                	ld	a5,8(a0)
ffffffffc0201440:	8385                	srli	a5,a5,0x1
ffffffffc0201442:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201444:	54079063          	bnez	a5,ffffffffc0201984 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201448:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020144a:	00043b03          	ld	s6,0(s0)
ffffffffc020144e:	00843a83          	ld	s5,8(s0)
ffffffffc0201452:	e000                	sd	s0,0(s0)
ffffffffc0201454:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201456:	4ef000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc020145a:	50051563          	bnez	a0,ffffffffc0201964 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc020145e:	08098a13          	addi	s4,s3,128
ffffffffc0201462:	8552                	mv	a0,s4
ffffffffc0201464:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201466:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc020146a:	000bb797          	auipc	a5,0xbb
ffffffffc020146e:	c407af23          	sw	zero,-930(a5) # ffffffffc02bc0c8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201472:	511000ef          	jal	ra,ffffffffc0202182 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201476:	4511                	li	a0,4
ffffffffc0201478:	4cd000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc020147c:	4c051463          	bnez	a0,ffffffffc0201944 <default_check+0x6a2>
ffffffffc0201480:	0889b783          	ld	a5,136(s3)
ffffffffc0201484:	8385                	srli	a5,a5,0x1
ffffffffc0201486:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201488:	48078e63          	beqz	a5,ffffffffc0201924 <default_check+0x682>
ffffffffc020148c:	0909a703          	lw	a4,144(s3)
ffffffffc0201490:	478d                	li	a5,3
ffffffffc0201492:	48f71963          	bne	a4,a5,ffffffffc0201924 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201496:	450d                	li	a0,3
ffffffffc0201498:	4ad000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc020149c:	8c2a                	mv	s8,a0
ffffffffc020149e:	46050363          	beqz	a0,ffffffffc0201904 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02014a2:	4505                	li	a0,1
ffffffffc02014a4:	4a1000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02014a8:	42051e63          	bnez	a0,ffffffffc02018e4 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc02014ac:	418a1c63          	bne	s4,s8,ffffffffc02018c4 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02014b0:	4585                	li	a1,1
ffffffffc02014b2:	854e                	mv	a0,s3
ffffffffc02014b4:	4cf000ef          	jal	ra,ffffffffc0202182 <free_pages>
    free_pages(p1, 3);
ffffffffc02014b8:	458d                	li	a1,3
ffffffffc02014ba:	8552                	mv	a0,s4
ffffffffc02014bc:	4c7000ef          	jal	ra,ffffffffc0202182 <free_pages>
ffffffffc02014c0:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02014c4:	04098c13          	addi	s8,s3,64
ffffffffc02014c8:	8385                	srli	a5,a5,0x1
ffffffffc02014ca:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02014cc:	3c078c63          	beqz	a5,ffffffffc02018a4 <default_check+0x602>
ffffffffc02014d0:	0109a703          	lw	a4,16(s3)
ffffffffc02014d4:	4785                	li	a5,1
ffffffffc02014d6:	3cf71763          	bne	a4,a5,ffffffffc02018a4 <default_check+0x602>
ffffffffc02014da:	008a3783          	ld	a5,8(s4)
ffffffffc02014de:	8385                	srli	a5,a5,0x1
ffffffffc02014e0:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02014e2:	3a078163          	beqz	a5,ffffffffc0201884 <default_check+0x5e2>
ffffffffc02014e6:	010a2703          	lw	a4,16(s4)
ffffffffc02014ea:	478d                	li	a5,3
ffffffffc02014ec:	38f71c63          	bne	a4,a5,ffffffffc0201884 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02014f0:	4505                	li	a0,1
ffffffffc02014f2:	453000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc02014f6:	36a99763          	bne	s3,a0,ffffffffc0201864 <default_check+0x5c2>
    free_page(p0);
ffffffffc02014fa:	4585                	li	a1,1
ffffffffc02014fc:	487000ef          	jal	ra,ffffffffc0202182 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201500:	4509                	li	a0,2
ffffffffc0201502:	443000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc0201506:	32aa1f63          	bne	s4,a0,ffffffffc0201844 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020150a:	4589                	li	a1,2
ffffffffc020150c:	477000ef          	jal	ra,ffffffffc0202182 <free_pages>
    free_page(p2);
ffffffffc0201510:	4585                	li	a1,1
ffffffffc0201512:	8562                	mv	a0,s8
ffffffffc0201514:	46f000ef          	jal	ra,ffffffffc0202182 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201518:	4515                	li	a0,5
ffffffffc020151a:	42b000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc020151e:	89aa                	mv	s3,a0
ffffffffc0201520:	48050263          	beqz	a0,ffffffffc02019a4 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201524:	4505                	li	a0,1
ffffffffc0201526:	41f000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc020152a:	2c051d63          	bnez	a0,ffffffffc0201804 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc020152e:	481c                	lw	a5,16(s0)
ffffffffc0201530:	2a079a63          	bnez	a5,ffffffffc02017e4 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201534:	4595                	li	a1,5
ffffffffc0201536:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201538:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc020153c:	01643023          	sd	s6,0(s0)
ffffffffc0201540:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201544:	43f000ef          	jal	ra,ffffffffc0202182 <free_pages>
    return listelm->next;
ffffffffc0201548:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020154a:	00878963          	beq	a5,s0,ffffffffc020155c <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc020154e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201552:	679c                	ld	a5,8(a5)
ffffffffc0201554:	397d                	addiw	s2,s2,-1
ffffffffc0201556:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201558:	fe879be3          	bne	a5,s0,ffffffffc020154e <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc020155c:	26091463          	bnez	s2,ffffffffc02017c4 <default_check+0x522>
    assert(total == 0);
ffffffffc0201560:	46049263          	bnez	s1,ffffffffc02019c4 <default_check+0x722>
}
ffffffffc0201564:	60a6                	ld	ra,72(sp)
ffffffffc0201566:	6406                	ld	s0,64(sp)
ffffffffc0201568:	74e2                	ld	s1,56(sp)
ffffffffc020156a:	7942                	ld	s2,48(sp)
ffffffffc020156c:	79a2                	ld	s3,40(sp)
ffffffffc020156e:	7a02                	ld	s4,32(sp)
ffffffffc0201570:	6ae2                	ld	s5,24(sp)
ffffffffc0201572:	6b42                	ld	s6,16(sp)
ffffffffc0201574:	6ba2                	ld	s7,8(sp)
ffffffffc0201576:	6c02                	ld	s8,0(sp)
ffffffffc0201578:	6161                	addi	sp,sp,80
ffffffffc020157a:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc020157c:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020157e:	4481                	li	s1,0
ffffffffc0201580:	4901                	li	s2,0
ffffffffc0201582:	b38d                	j	ffffffffc02012e4 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201584:	00005697          	auipc	a3,0x5
ffffffffc0201588:	f9468693          	addi	a3,a3,-108 # ffffffffc0206518 <commands+0x9d8>
ffffffffc020158c:	00005617          	auipc	a2,0x5
ffffffffc0201590:	f9c60613          	addi	a2,a2,-100 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201594:	11000593          	li	a1,272
ffffffffc0201598:	00005517          	auipc	a0,0x5
ffffffffc020159c:	fa850513          	addi	a0,a0,-88 # ffffffffc0206540 <commands+0xa00>
ffffffffc02015a0:	eeffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02015a4:	00005697          	auipc	a3,0x5
ffffffffc02015a8:	03468693          	addi	a3,a3,52 # ffffffffc02065d8 <commands+0xa98>
ffffffffc02015ac:	00005617          	auipc	a2,0x5
ffffffffc02015b0:	f7c60613          	addi	a2,a2,-132 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02015b4:	0db00593          	li	a1,219
ffffffffc02015b8:	00005517          	auipc	a0,0x5
ffffffffc02015bc:	f8850513          	addi	a0,a0,-120 # ffffffffc0206540 <commands+0xa00>
ffffffffc02015c0:	ecffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02015c4:	00005697          	auipc	a3,0x5
ffffffffc02015c8:	03c68693          	addi	a3,a3,60 # ffffffffc0206600 <commands+0xac0>
ffffffffc02015cc:	00005617          	auipc	a2,0x5
ffffffffc02015d0:	f5c60613          	addi	a2,a2,-164 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02015d4:	0dc00593          	li	a1,220
ffffffffc02015d8:	00005517          	auipc	a0,0x5
ffffffffc02015dc:	f6850513          	addi	a0,a0,-152 # ffffffffc0206540 <commands+0xa00>
ffffffffc02015e0:	eaffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02015e4:	00005697          	auipc	a3,0x5
ffffffffc02015e8:	05c68693          	addi	a3,a3,92 # ffffffffc0206640 <commands+0xb00>
ffffffffc02015ec:	00005617          	auipc	a2,0x5
ffffffffc02015f0:	f3c60613          	addi	a2,a2,-196 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02015f4:	0de00593          	li	a1,222
ffffffffc02015f8:	00005517          	auipc	a0,0x5
ffffffffc02015fc:	f4850513          	addi	a0,a0,-184 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201600:	e8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201604:	00005697          	auipc	a3,0x5
ffffffffc0201608:	0c468693          	addi	a3,a3,196 # ffffffffc02066c8 <commands+0xb88>
ffffffffc020160c:	00005617          	auipc	a2,0x5
ffffffffc0201610:	f1c60613          	addi	a2,a2,-228 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201614:	0f700593          	li	a1,247
ffffffffc0201618:	00005517          	auipc	a0,0x5
ffffffffc020161c:	f2850513          	addi	a0,a0,-216 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201620:	e6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201624:	00005697          	auipc	a3,0x5
ffffffffc0201628:	f5468693          	addi	a3,a3,-172 # ffffffffc0206578 <commands+0xa38>
ffffffffc020162c:	00005617          	auipc	a2,0x5
ffffffffc0201630:	efc60613          	addi	a2,a2,-260 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201634:	0f000593          	li	a1,240
ffffffffc0201638:	00005517          	auipc	a0,0x5
ffffffffc020163c:	f0850513          	addi	a0,a0,-248 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201640:	e4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc0201644:	00005697          	auipc	a3,0x5
ffffffffc0201648:	07468693          	addi	a3,a3,116 # ffffffffc02066b8 <commands+0xb78>
ffffffffc020164c:	00005617          	auipc	a2,0x5
ffffffffc0201650:	edc60613          	addi	a2,a2,-292 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201654:	0ee00593          	li	a1,238
ffffffffc0201658:	00005517          	auipc	a0,0x5
ffffffffc020165c:	ee850513          	addi	a0,a0,-280 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201660:	e2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201664:	00005697          	auipc	a3,0x5
ffffffffc0201668:	03c68693          	addi	a3,a3,60 # ffffffffc02066a0 <commands+0xb60>
ffffffffc020166c:	00005617          	auipc	a2,0x5
ffffffffc0201670:	ebc60613          	addi	a2,a2,-324 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201674:	0e900593          	li	a1,233
ffffffffc0201678:	00005517          	auipc	a0,0x5
ffffffffc020167c:	ec850513          	addi	a0,a0,-312 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201680:	e0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201684:	00005697          	auipc	a3,0x5
ffffffffc0201688:	ffc68693          	addi	a3,a3,-4 # ffffffffc0206680 <commands+0xb40>
ffffffffc020168c:	00005617          	auipc	a2,0x5
ffffffffc0201690:	e9c60613          	addi	a2,a2,-356 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201694:	0e000593          	li	a1,224
ffffffffc0201698:	00005517          	auipc	a0,0x5
ffffffffc020169c:	ea850513          	addi	a0,a0,-344 # ffffffffc0206540 <commands+0xa00>
ffffffffc02016a0:	deffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc02016a4:	00005697          	auipc	a3,0x5
ffffffffc02016a8:	06c68693          	addi	a3,a3,108 # ffffffffc0206710 <commands+0xbd0>
ffffffffc02016ac:	00005617          	auipc	a2,0x5
ffffffffc02016b0:	e7c60613          	addi	a2,a2,-388 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02016b4:	11800593          	li	a1,280
ffffffffc02016b8:	00005517          	auipc	a0,0x5
ffffffffc02016bc:	e8850513          	addi	a0,a0,-376 # ffffffffc0206540 <commands+0xa00>
ffffffffc02016c0:	dcffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02016c4:	00005697          	auipc	a3,0x5
ffffffffc02016c8:	03c68693          	addi	a3,a3,60 # ffffffffc0206700 <commands+0xbc0>
ffffffffc02016cc:	00005617          	auipc	a2,0x5
ffffffffc02016d0:	e5c60613          	addi	a2,a2,-420 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02016d4:	0fd00593          	li	a1,253
ffffffffc02016d8:	00005517          	auipc	a0,0x5
ffffffffc02016dc:	e6850513          	addi	a0,a0,-408 # ffffffffc0206540 <commands+0xa00>
ffffffffc02016e0:	daffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016e4:	00005697          	auipc	a3,0x5
ffffffffc02016e8:	fbc68693          	addi	a3,a3,-68 # ffffffffc02066a0 <commands+0xb60>
ffffffffc02016ec:	00005617          	auipc	a2,0x5
ffffffffc02016f0:	e3c60613          	addi	a2,a2,-452 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02016f4:	0fb00593          	li	a1,251
ffffffffc02016f8:	00005517          	auipc	a0,0x5
ffffffffc02016fc:	e4850513          	addi	a0,a0,-440 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201700:	d8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201704:	00005697          	auipc	a3,0x5
ffffffffc0201708:	fdc68693          	addi	a3,a3,-36 # ffffffffc02066e0 <commands+0xba0>
ffffffffc020170c:	00005617          	auipc	a2,0x5
ffffffffc0201710:	e1c60613          	addi	a2,a2,-484 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201714:	0fa00593          	li	a1,250
ffffffffc0201718:	00005517          	auipc	a0,0x5
ffffffffc020171c:	e2850513          	addi	a0,a0,-472 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201720:	d6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201724:	00005697          	auipc	a3,0x5
ffffffffc0201728:	e5468693          	addi	a3,a3,-428 # ffffffffc0206578 <commands+0xa38>
ffffffffc020172c:	00005617          	auipc	a2,0x5
ffffffffc0201730:	dfc60613          	addi	a2,a2,-516 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201734:	0d700593          	li	a1,215
ffffffffc0201738:	00005517          	auipc	a0,0x5
ffffffffc020173c:	e0850513          	addi	a0,a0,-504 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201740:	d4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201744:	00005697          	auipc	a3,0x5
ffffffffc0201748:	f5c68693          	addi	a3,a3,-164 # ffffffffc02066a0 <commands+0xb60>
ffffffffc020174c:	00005617          	auipc	a2,0x5
ffffffffc0201750:	ddc60613          	addi	a2,a2,-548 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201754:	0f400593          	li	a1,244
ffffffffc0201758:	00005517          	auipc	a0,0x5
ffffffffc020175c:	de850513          	addi	a0,a0,-536 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201760:	d2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201764:	00005697          	auipc	a3,0x5
ffffffffc0201768:	e5468693          	addi	a3,a3,-428 # ffffffffc02065b8 <commands+0xa78>
ffffffffc020176c:	00005617          	auipc	a2,0x5
ffffffffc0201770:	dbc60613          	addi	a2,a2,-580 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201774:	0f200593          	li	a1,242
ffffffffc0201778:	00005517          	auipc	a0,0x5
ffffffffc020177c:	dc850513          	addi	a0,a0,-568 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201780:	d0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201784:	00005697          	auipc	a3,0x5
ffffffffc0201788:	e1468693          	addi	a3,a3,-492 # ffffffffc0206598 <commands+0xa58>
ffffffffc020178c:	00005617          	auipc	a2,0x5
ffffffffc0201790:	d9c60613          	addi	a2,a2,-612 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201794:	0f100593          	li	a1,241
ffffffffc0201798:	00005517          	auipc	a0,0x5
ffffffffc020179c:	da850513          	addi	a0,a0,-600 # ffffffffc0206540 <commands+0xa00>
ffffffffc02017a0:	ceffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02017a4:	00005697          	auipc	a3,0x5
ffffffffc02017a8:	e1468693          	addi	a3,a3,-492 # ffffffffc02065b8 <commands+0xa78>
ffffffffc02017ac:	00005617          	auipc	a2,0x5
ffffffffc02017b0:	d7c60613          	addi	a2,a2,-644 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02017b4:	0d900593          	li	a1,217
ffffffffc02017b8:	00005517          	auipc	a0,0x5
ffffffffc02017bc:	d8850513          	addi	a0,a0,-632 # ffffffffc0206540 <commands+0xa00>
ffffffffc02017c0:	ccffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc02017c4:	00005697          	auipc	a3,0x5
ffffffffc02017c8:	09c68693          	addi	a3,a3,156 # ffffffffc0206860 <commands+0xd20>
ffffffffc02017cc:	00005617          	auipc	a2,0x5
ffffffffc02017d0:	d5c60613          	addi	a2,a2,-676 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02017d4:	14600593          	li	a1,326
ffffffffc02017d8:	00005517          	auipc	a0,0x5
ffffffffc02017dc:	d6850513          	addi	a0,a0,-664 # ffffffffc0206540 <commands+0xa00>
ffffffffc02017e0:	caffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02017e4:	00005697          	auipc	a3,0x5
ffffffffc02017e8:	f1c68693          	addi	a3,a3,-228 # ffffffffc0206700 <commands+0xbc0>
ffffffffc02017ec:	00005617          	auipc	a2,0x5
ffffffffc02017f0:	d3c60613          	addi	a2,a2,-708 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02017f4:	13a00593          	li	a1,314
ffffffffc02017f8:	00005517          	auipc	a0,0x5
ffffffffc02017fc:	d4850513          	addi	a0,a0,-696 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201800:	c8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201804:	00005697          	auipc	a3,0x5
ffffffffc0201808:	e9c68693          	addi	a3,a3,-356 # ffffffffc02066a0 <commands+0xb60>
ffffffffc020180c:	00005617          	auipc	a2,0x5
ffffffffc0201810:	d1c60613          	addi	a2,a2,-740 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201814:	13800593          	li	a1,312
ffffffffc0201818:	00005517          	auipc	a0,0x5
ffffffffc020181c:	d2850513          	addi	a0,a0,-728 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201820:	c6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201824:	00005697          	auipc	a3,0x5
ffffffffc0201828:	e3c68693          	addi	a3,a3,-452 # ffffffffc0206660 <commands+0xb20>
ffffffffc020182c:	00005617          	auipc	a2,0x5
ffffffffc0201830:	cfc60613          	addi	a2,a2,-772 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201834:	0df00593          	li	a1,223
ffffffffc0201838:	00005517          	auipc	a0,0x5
ffffffffc020183c:	d0850513          	addi	a0,a0,-760 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201840:	c4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201844:	00005697          	auipc	a3,0x5
ffffffffc0201848:	fdc68693          	addi	a3,a3,-36 # ffffffffc0206820 <commands+0xce0>
ffffffffc020184c:	00005617          	auipc	a2,0x5
ffffffffc0201850:	cdc60613          	addi	a2,a2,-804 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201854:	13200593          	li	a1,306
ffffffffc0201858:	00005517          	auipc	a0,0x5
ffffffffc020185c:	ce850513          	addi	a0,a0,-792 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201860:	c2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201864:	00005697          	auipc	a3,0x5
ffffffffc0201868:	f9c68693          	addi	a3,a3,-100 # ffffffffc0206800 <commands+0xcc0>
ffffffffc020186c:	00005617          	auipc	a2,0x5
ffffffffc0201870:	cbc60613          	addi	a2,a2,-836 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201874:	13000593          	li	a1,304
ffffffffc0201878:	00005517          	auipc	a0,0x5
ffffffffc020187c:	cc850513          	addi	a0,a0,-824 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201880:	c0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201884:	00005697          	auipc	a3,0x5
ffffffffc0201888:	f5468693          	addi	a3,a3,-172 # ffffffffc02067d8 <commands+0xc98>
ffffffffc020188c:	00005617          	auipc	a2,0x5
ffffffffc0201890:	c9c60613          	addi	a2,a2,-868 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201894:	12e00593          	li	a1,302
ffffffffc0201898:	00005517          	auipc	a0,0x5
ffffffffc020189c:	ca850513          	addi	a0,a0,-856 # ffffffffc0206540 <commands+0xa00>
ffffffffc02018a0:	beffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02018a4:	00005697          	auipc	a3,0x5
ffffffffc02018a8:	f0c68693          	addi	a3,a3,-244 # ffffffffc02067b0 <commands+0xc70>
ffffffffc02018ac:	00005617          	auipc	a2,0x5
ffffffffc02018b0:	c7c60613          	addi	a2,a2,-900 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02018b4:	12d00593          	li	a1,301
ffffffffc02018b8:	00005517          	auipc	a0,0x5
ffffffffc02018bc:	c8850513          	addi	a0,a0,-888 # ffffffffc0206540 <commands+0xa00>
ffffffffc02018c0:	bcffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc02018c4:	00005697          	auipc	a3,0x5
ffffffffc02018c8:	edc68693          	addi	a3,a3,-292 # ffffffffc02067a0 <commands+0xc60>
ffffffffc02018cc:	00005617          	auipc	a2,0x5
ffffffffc02018d0:	c5c60613          	addi	a2,a2,-932 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02018d4:	12800593          	li	a1,296
ffffffffc02018d8:	00005517          	auipc	a0,0x5
ffffffffc02018dc:	c6850513          	addi	a0,a0,-920 # ffffffffc0206540 <commands+0xa00>
ffffffffc02018e0:	baffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02018e4:	00005697          	auipc	a3,0x5
ffffffffc02018e8:	dbc68693          	addi	a3,a3,-580 # ffffffffc02066a0 <commands+0xb60>
ffffffffc02018ec:	00005617          	auipc	a2,0x5
ffffffffc02018f0:	c3c60613          	addi	a2,a2,-964 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02018f4:	12700593          	li	a1,295
ffffffffc02018f8:	00005517          	auipc	a0,0x5
ffffffffc02018fc:	c4850513          	addi	a0,a0,-952 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201900:	b8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201904:	00005697          	auipc	a3,0x5
ffffffffc0201908:	e7c68693          	addi	a3,a3,-388 # ffffffffc0206780 <commands+0xc40>
ffffffffc020190c:	00005617          	auipc	a2,0x5
ffffffffc0201910:	c1c60613          	addi	a2,a2,-996 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201914:	12600593          	li	a1,294
ffffffffc0201918:	00005517          	auipc	a0,0x5
ffffffffc020191c:	c2850513          	addi	a0,a0,-984 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201920:	b6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201924:	00005697          	auipc	a3,0x5
ffffffffc0201928:	e2c68693          	addi	a3,a3,-468 # ffffffffc0206750 <commands+0xc10>
ffffffffc020192c:	00005617          	auipc	a2,0x5
ffffffffc0201930:	bfc60613          	addi	a2,a2,-1028 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201934:	12500593          	li	a1,293
ffffffffc0201938:	00005517          	auipc	a0,0x5
ffffffffc020193c:	c0850513          	addi	a0,a0,-1016 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201940:	b4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201944:	00005697          	auipc	a3,0x5
ffffffffc0201948:	df468693          	addi	a3,a3,-524 # ffffffffc0206738 <commands+0xbf8>
ffffffffc020194c:	00005617          	auipc	a2,0x5
ffffffffc0201950:	bdc60613          	addi	a2,a2,-1060 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201954:	12400593          	li	a1,292
ffffffffc0201958:	00005517          	auipc	a0,0x5
ffffffffc020195c:	be850513          	addi	a0,a0,-1048 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201960:	b2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201964:	00005697          	auipc	a3,0x5
ffffffffc0201968:	d3c68693          	addi	a3,a3,-708 # ffffffffc02066a0 <commands+0xb60>
ffffffffc020196c:	00005617          	auipc	a2,0x5
ffffffffc0201970:	bbc60613          	addi	a2,a2,-1092 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201974:	11e00593          	li	a1,286
ffffffffc0201978:	00005517          	auipc	a0,0x5
ffffffffc020197c:	bc850513          	addi	a0,a0,-1080 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201980:	b0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc0201984:	00005697          	auipc	a3,0x5
ffffffffc0201988:	d9c68693          	addi	a3,a3,-612 # ffffffffc0206720 <commands+0xbe0>
ffffffffc020198c:	00005617          	auipc	a2,0x5
ffffffffc0201990:	b9c60613          	addi	a2,a2,-1124 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201994:	11900593          	li	a1,281
ffffffffc0201998:	00005517          	auipc	a0,0x5
ffffffffc020199c:	ba850513          	addi	a0,a0,-1112 # ffffffffc0206540 <commands+0xa00>
ffffffffc02019a0:	aeffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02019a4:	00005697          	auipc	a3,0x5
ffffffffc02019a8:	e9c68693          	addi	a3,a3,-356 # ffffffffc0206840 <commands+0xd00>
ffffffffc02019ac:	00005617          	auipc	a2,0x5
ffffffffc02019b0:	b7c60613          	addi	a2,a2,-1156 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02019b4:	13700593          	li	a1,311
ffffffffc02019b8:	00005517          	auipc	a0,0x5
ffffffffc02019bc:	b8850513          	addi	a0,a0,-1144 # ffffffffc0206540 <commands+0xa00>
ffffffffc02019c0:	acffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc02019c4:	00005697          	auipc	a3,0x5
ffffffffc02019c8:	eac68693          	addi	a3,a3,-340 # ffffffffc0206870 <commands+0xd30>
ffffffffc02019cc:	00005617          	auipc	a2,0x5
ffffffffc02019d0:	b5c60613          	addi	a2,a2,-1188 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02019d4:	14700593          	li	a1,327
ffffffffc02019d8:	00005517          	auipc	a0,0x5
ffffffffc02019dc:	b6850513          	addi	a0,a0,-1176 # ffffffffc0206540 <commands+0xa00>
ffffffffc02019e0:	aaffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc02019e4:	00005697          	auipc	a3,0x5
ffffffffc02019e8:	b7468693          	addi	a3,a3,-1164 # ffffffffc0206558 <commands+0xa18>
ffffffffc02019ec:	00005617          	auipc	a2,0x5
ffffffffc02019f0:	b3c60613          	addi	a2,a2,-1220 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02019f4:	11300593          	li	a1,275
ffffffffc02019f8:	00005517          	auipc	a0,0x5
ffffffffc02019fc:	b4850513          	addi	a0,a0,-1208 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201a00:	a8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201a04:	00005697          	auipc	a3,0x5
ffffffffc0201a08:	b9468693          	addi	a3,a3,-1132 # ffffffffc0206598 <commands+0xa58>
ffffffffc0201a0c:	00005617          	auipc	a2,0x5
ffffffffc0201a10:	b1c60613          	addi	a2,a2,-1252 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201a14:	0d800593          	li	a1,216
ffffffffc0201a18:	00005517          	auipc	a0,0x5
ffffffffc0201a1c:	b2850513          	addi	a0,a0,-1240 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201a20:	a6ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201a24 <default_free_pages>:
{
ffffffffc0201a24:	1141                	addi	sp,sp,-16
ffffffffc0201a26:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a28:	14058463          	beqz	a1,ffffffffc0201b70 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201a2c:	00659693          	slli	a3,a1,0x6
ffffffffc0201a30:	96aa                	add	a3,a3,a0
ffffffffc0201a32:	87aa                	mv	a5,a0
ffffffffc0201a34:	02d50263          	beq	a0,a3,ffffffffc0201a58 <default_free_pages+0x34>
ffffffffc0201a38:	6798                	ld	a4,8(a5)
ffffffffc0201a3a:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201a3c:	10071a63          	bnez	a4,ffffffffc0201b50 <default_free_pages+0x12c>
ffffffffc0201a40:	6798                	ld	a4,8(a5)
ffffffffc0201a42:	8b09                	andi	a4,a4,2
ffffffffc0201a44:	10071663          	bnez	a4,ffffffffc0201b50 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0201a48:	0007b423          	sd	zero,8(a5)
    page->ref = val;
ffffffffc0201a4c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201a50:	04078793          	addi	a5,a5,64
ffffffffc0201a54:	fed792e3          	bne	a5,a3,ffffffffc0201a38 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201a58:	2581                	sext.w	a1,a1
ffffffffc0201a5a:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201a5c:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201a60:	4789                	li	a5,2
ffffffffc0201a62:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201a66:	000ba697          	auipc	a3,0xba
ffffffffc0201a6a:	65268693          	addi	a3,a3,1618 # ffffffffc02bc0b8 <free_area>
ffffffffc0201a6e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201a70:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201a72:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201a76:	9db9                	addw	a1,a1,a4
ffffffffc0201a78:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201a7a:	0ad78463          	beq	a5,a3,ffffffffc0201b22 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc0201a7e:	fe878713          	addi	a4,a5,-24
ffffffffc0201a82:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201a86:	4581                	li	a1,0
            if (base < page)
ffffffffc0201a88:	00e56a63          	bltu	a0,a4,ffffffffc0201a9c <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201a8c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a8e:	04d70c63          	beq	a4,a3,ffffffffc0201ae6 <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc0201a92:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a94:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a98:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a8c <default_free_pages+0x68>
ffffffffc0201a9c:	c199                	beqz	a1,ffffffffc0201aa2 <default_free_pages+0x7e>
ffffffffc0201a9e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201aa2:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201aa4:	e390                	sd	a2,0(a5)
ffffffffc0201aa6:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201aa8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201aaa:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0201aac:	00d70d63          	beq	a4,a3,ffffffffc0201ac6 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201ab0:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201ab4:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201ab8:	02059813          	slli	a6,a1,0x20
ffffffffc0201abc:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201ac0:	97b2                	add	a5,a5,a2
ffffffffc0201ac2:	02f50c63          	beq	a0,a5,ffffffffc0201afa <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201ac6:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201ac8:	00d78c63          	beq	a5,a3,ffffffffc0201ae0 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201acc:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201ace:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201ad2:	02061593          	slli	a1,a2,0x20
ffffffffc0201ad6:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201ada:	972a                	add	a4,a4,a0
ffffffffc0201adc:	04e68a63          	beq	a3,a4,ffffffffc0201b30 <default_free_pages+0x10c>
}
ffffffffc0201ae0:	60a2                	ld	ra,8(sp)
ffffffffc0201ae2:	0141                	addi	sp,sp,16
ffffffffc0201ae4:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201ae6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201ae8:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201aea:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201aec:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201aee:	02d70763          	beq	a4,a3,ffffffffc0201b1c <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201af2:	8832                	mv	a6,a2
ffffffffc0201af4:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201af6:	87ba                	mv	a5,a4
ffffffffc0201af8:	bf71                	j	ffffffffc0201a94 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201afa:	491c                	lw	a5,16(a0)
ffffffffc0201afc:	9dbd                	addw	a1,a1,a5
ffffffffc0201afe:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201b02:	57f5                	li	a5,-3
ffffffffc0201b04:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201b08:	01853803          	ld	a6,24(a0)
ffffffffc0201b0c:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201b0e:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201b10:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201b14:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201b16:	0105b023          	sd	a6,0(a1)
ffffffffc0201b1a:	b77d                	j	ffffffffc0201ac8 <default_free_pages+0xa4>
ffffffffc0201b1c:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201b1e:	873e                	mv	a4,a5
ffffffffc0201b20:	bf41                	j	ffffffffc0201ab0 <default_free_pages+0x8c>
}
ffffffffc0201b22:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201b24:	e390                	sd	a2,0(a5)
ffffffffc0201b26:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201b28:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201b2a:	ed1c                	sd	a5,24(a0)
ffffffffc0201b2c:	0141                	addi	sp,sp,16
ffffffffc0201b2e:	8082                	ret
            base->property += p->property;
ffffffffc0201b30:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b34:	ff078693          	addi	a3,a5,-16
ffffffffc0201b38:	9e39                	addw	a2,a2,a4
ffffffffc0201b3a:	c910                	sw	a2,16(a0)
ffffffffc0201b3c:	5775                	li	a4,-3
ffffffffc0201b3e:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201b42:	6398                	ld	a4,0(a5)
ffffffffc0201b44:	679c                	ld	a5,8(a5)
}
ffffffffc0201b46:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201b48:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201b4a:	e398                	sd	a4,0(a5)
ffffffffc0201b4c:	0141                	addi	sp,sp,16
ffffffffc0201b4e:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201b50:	00005697          	auipc	a3,0x5
ffffffffc0201b54:	d3868693          	addi	a3,a3,-712 # ffffffffc0206888 <commands+0xd48>
ffffffffc0201b58:	00005617          	auipc	a2,0x5
ffffffffc0201b5c:	9d060613          	addi	a2,a2,-1584 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201b60:	09400593          	li	a1,148
ffffffffc0201b64:	00005517          	auipc	a0,0x5
ffffffffc0201b68:	9dc50513          	addi	a0,a0,-1572 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201b6c:	923fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201b70:	00005697          	auipc	a3,0x5
ffffffffc0201b74:	d1068693          	addi	a3,a3,-752 # ffffffffc0206880 <commands+0xd40>
ffffffffc0201b78:	00005617          	auipc	a2,0x5
ffffffffc0201b7c:	9b060613          	addi	a2,a2,-1616 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201b80:	09000593          	li	a1,144
ffffffffc0201b84:	00005517          	auipc	a0,0x5
ffffffffc0201b88:	9bc50513          	addi	a0,a0,-1604 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201b8c:	903fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201b90 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201b90:	c941                	beqz	a0,ffffffffc0201c20 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0201b92:	000ba597          	auipc	a1,0xba
ffffffffc0201b96:	52658593          	addi	a1,a1,1318 # ffffffffc02bc0b8 <free_area>
ffffffffc0201b9a:	0105a803          	lw	a6,16(a1)
ffffffffc0201b9e:	872a                	mv	a4,a0
ffffffffc0201ba0:	02081793          	slli	a5,a6,0x20
ffffffffc0201ba4:	9381                	srli	a5,a5,0x20
ffffffffc0201ba6:	00a7ee63          	bltu	a5,a0,ffffffffc0201bc2 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201baa:	87ae                	mv	a5,a1
ffffffffc0201bac:	a801                	j	ffffffffc0201bbc <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201bae:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201bb2:	02069613          	slli	a2,a3,0x20
ffffffffc0201bb6:	9201                	srli	a2,a2,0x20
ffffffffc0201bb8:	00e67763          	bgeu	a2,a4,ffffffffc0201bc6 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201bbc:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201bbe:	feb798e3          	bne	a5,a1,ffffffffc0201bae <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201bc2:	4501                	li	a0,0
}
ffffffffc0201bc4:	8082                	ret
    return listelm->prev;
ffffffffc0201bc6:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201bca:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201bce:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201bd2:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201bd6:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201bda:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201bde:	02c77863          	bgeu	a4,a2,ffffffffc0201c0e <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201be2:	071a                	slli	a4,a4,0x6
ffffffffc0201be4:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201be6:	41c686bb          	subw	a3,a3,t3
ffffffffc0201bea:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201bec:	00870613          	addi	a2,a4,8
ffffffffc0201bf0:	4689                	li	a3,2
ffffffffc0201bf2:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201bf6:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201bfa:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201bfe:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201c02:	e290                	sd	a2,0(a3)
ffffffffc0201c04:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201c08:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201c0a:	01173c23          	sd	a7,24(a4)
ffffffffc0201c0e:	41c8083b          	subw	a6,a6,t3
ffffffffc0201c12:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201c16:	5775                	li	a4,-3
ffffffffc0201c18:	17c1                	addi	a5,a5,-16
ffffffffc0201c1a:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201c1e:	8082                	ret
{
ffffffffc0201c20:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201c22:	00005697          	auipc	a3,0x5
ffffffffc0201c26:	c5e68693          	addi	a3,a3,-930 # ffffffffc0206880 <commands+0xd40>
ffffffffc0201c2a:	00005617          	auipc	a2,0x5
ffffffffc0201c2e:	8fe60613          	addi	a2,a2,-1794 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201c32:	06c00593          	li	a1,108
ffffffffc0201c36:	00005517          	auipc	a0,0x5
ffffffffc0201c3a:	90a50513          	addi	a0,a0,-1782 # ffffffffc0206540 <commands+0xa00>
{
ffffffffc0201c3e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201c40:	84ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201c44 <default_init_memmap>:
{
ffffffffc0201c44:	1141                	addi	sp,sp,-16
ffffffffc0201c46:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201c48:	c5f1                	beqz	a1,ffffffffc0201d14 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201c4a:	00659693          	slli	a3,a1,0x6
ffffffffc0201c4e:	96aa                	add	a3,a3,a0
ffffffffc0201c50:	87aa                	mv	a5,a0
ffffffffc0201c52:	00d50f63          	beq	a0,a3,ffffffffc0201c70 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201c56:	6798                	ld	a4,8(a5)
ffffffffc0201c58:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0201c5a:	cf49                	beqz	a4,ffffffffc0201cf4 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201c5c:	0007a823          	sw	zero,16(a5)
ffffffffc0201c60:	0007b423          	sd	zero,8(a5)
ffffffffc0201c64:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201c68:	04078793          	addi	a5,a5,64
ffffffffc0201c6c:	fed795e3          	bne	a5,a3,ffffffffc0201c56 <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201c70:	2581                	sext.w	a1,a1
ffffffffc0201c72:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201c74:	4789                	li	a5,2
ffffffffc0201c76:	00850713          	addi	a4,a0,8
ffffffffc0201c7a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201c7e:	000ba697          	auipc	a3,0xba
ffffffffc0201c82:	43a68693          	addi	a3,a3,1082 # ffffffffc02bc0b8 <free_area>
ffffffffc0201c86:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201c88:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201c8a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201c8e:	9db9                	addw	a1,a1,a4
ffffffffc0201c90:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201c92:	04d78a63          	beq	a5,a3,ffffffffc0201ce6 <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0201c96:	fe878713          	addi	a4,a5,-24
ffffffffc0201c9a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201c9e:	4581                	li	a1,0
            if (base < page)
ffffffffc0201ca0:	00e56a63          	bltu	a0,a4,ffffffffc0201cb4 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201ca4:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201ca6:	02d70263          	beq	a4,a3,ffffffffc0201cca <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201caa:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201cac:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201cb0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ca4 <default_init_memmap+0x60>
ffffffffc0201cb4:	c199                	beqz	a1,ffffffffc0201cba <default_init_memmap+0x76>
ffffffffc0201cb6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201cba:	6398                	ld	a4,0(a5)
}
ffffffffc0201cbc:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201cbe:	e390                	sd	a2,0(a5)
ffffffffc0201cc0:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201cc2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201cc4:	ed18                	sd	a4,24(a0)
ffffffffc0201cc6:	0141                	addi	sp,sp,16
ffffffffc0201cc8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201cca:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201ccc:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201cce:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201cd0:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201cd2:	00d70663          	beq	a4,a3,ffffffffc0201cde <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201cd6:	8832                	mv	a6,a2
ffffffffc0201cd8:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201cda:	87ba                	mv	a5,a4
ffffffffc0201cdc:	bfc1                	j	ffffffffc0201cac <default_init_memmap+0x68>
}
ffffffffc0201cde:	60a2                	ld	ra,8(sp)
ffffffffc0201ce0:	e290                	sd	a2,0(a3)
ffffffffc0201ce2:	0141                	addi	sp,sp,16
ffffffffc0201ce4:	8082                	ret
ffffffffc0201ce6:	60a2                	ld	ra,8(sp)
ffffffffc0201ce8:	e390                	sd	a2,0(a5)
ffffffffc0201cea:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201cec:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201cee:	ed1c                	sd	a5,24(a0)
ffffffffc0201cf0:	0141                	addi	sp,sp,16
ffffffffc0201cf2:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201cf4:	00005697          	auipc	a3,0x5
ffffffffc0201cf8:	bbc68693          	addi	a3,a3,-1092 # ffffffffc02068b0 <commands+0xd70>
ffffffffc0201cfc:	00005617          	auipc	a2,0x5
ffffffffc0201d00:	82c60613          	addi	a2,a2,-2004 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201d04:	04b00593          	li	a1,75
ffffffffc0201d08:	00005517          	auipc	a0,0x5
ffffffffc0201d0c:	83850513          	addi	a0,a0,-1992 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201d10:	f7efe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201d14:	00005697          	auipc	a3,0x5
ffffffffc0201d18:	b6c68693          	addi	a3,a3,-1172 # ffffffffc0206880 <commands+0xd40>
ffffffffc0201d1c:	00005617          	auipc	a2,0x5
ffffffffc0201d20:	80c60613          	addi	a2,a2,-2036 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201d24:	04700593          	li	a1,71
ffffffffc0201d28:	00005517          	auipc	a0,0x5
ffffffffc0201d2c:	81850513          	addi	a0,a0,-2024 # ffffffffc0206540 <commands+0xa00>
ffffffffc0201d30:	f5efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201d34 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201d34:	c94d                	beqz	a0,ffffffffc0201de6 <slob_free+0xb2>
{
ffffffffc0201d36:	1141                	addi	sp,sp,-16
ffffffffc0201d38:	e022                	sd	s0,0(sp)
ffffffffc0201d3a:	e406                	sd	ra,8(sp)
ffffffffc0201d3c:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201d3e:	e9c1                	bnez	a1,ffffffffc0201dce <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d40:	100027f3          	csrr	a5,sstatus
ffffffffc0201d44:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201d46:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d48:	ebd9                	bnez	a5,ffffffffc0201dde <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201d4a:	000ba617          	auipc	a2,0xba
ffffffffc0201d4e:	f5e60613          	addi	a2,a2,-162 # ffffffffc02bbca8 <slobfree>
ffffffffc0201d52:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201d54:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201d56:	679c                	ld	a5,8(a5)
ffffffffc0201d58:	02877a63          	bgeu	a4,s0,ffffffffc0201d8c <slob_free+0x58>
ffffffffc0201d5c:	00f46463          	bltu	s0,a5,ffffffffc0201d64 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201d60:	fef76ae3          	bltu	a4,a5,ffffffffc0201d54 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201d64:	400c                	lw	a1,0(s0)
ffffffffc0201d66:	00459693          	slli	a3,a1,0x4
ffffffffc0201d6a:	96a2                	add	a3,a3,s0
ffffffffc0201d6c:	02d78a63          	beq	a5,a3,ffffffffc0201da0 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201d70:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201d72:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201d74:	00469793          	slli	a5,a3,0x4
ffffffffc0201d78:	97ba                	add	a5,a5,a4
ffffffffc0201d7a:	02f40e63          	beq	s0,a5,ffffffffc0201db6 <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201d7e:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201d80:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201d82:	e129                	bnez	a0,ffffffffc0201dc4 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201d84:	60a2                	ld	ra,8(sp)
ffffffffc0201d86:	6402                	ld	s0,0(sp)
ffffffffc0201d88:	0141                	addi	sp,sp,16
ffffffffc0201d8a:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201d8c:	fcf764e3          	bltu	a4,a5,ffffffffc0201d54 <slob_free+0x20>
ffffffffc0201d90:	fcf472e3          	bgeu	s0,a5,ffffffffc0201d54 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201d94:	400c                	lw	a1,0(s0)
ffffffffc0201d96:	00459693          	slli	a3,a1,0x4
ffffffffc0201d9a:	96a2                	add	a3,a3,s0
ffffffffc0201d9c:	fcd79ae3          	bne	a5,a3,ffffffffc0201d70 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201da0:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201da2:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201da4:	9db5                	addw	a1,a1,a3
ffffffffc0201da6:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201da8:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201daa:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201dac:	00469793          	slli	a5,a3,0x4
ffffffffc0201db0:	97ba                	add	a5,a5,a4
ffffffffc0201db2:	fcf416e3          	bne	s0,a5,ffffffffc0201d7e <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201db6:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201db8:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201dba:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201dbc:	9ebd                	addw	a3,a3,a5
ffffffffc0201dbe:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201dc0:	e70c                	sd	a1,8(a4)
ffffffffc0201dc2:	d169                	beqz	a0,ffffffffc0201d84 <slob_free+0x50>
}
ffffffffc0201dc4:	6402                	ld	s0,0(sp)
ffffffffc0201dc6:	60a2                	ld	ra,8(sp)
ffffffffc0201dc8:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201dca:	be5fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201dce:	25bd                	addiw	a1,a1,15
ffffffffc0201dd0:	8191                	srli	a1,a1,0x4
ffffffffc0201dd2:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dd4:	100027f3          	csrr	a5,sstatus
ffffffffc0201dd8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201dda:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ddc:	d7bd                	beqz	a5,ffffffffc0201d4a <slob_free+0x16>
        intr_disable();
ffffffffc0201dde:	bd7fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201de2:	4505                	li	a0,1
ffffffffc0201de4:	b79d                	j	ffffffffc0201d4a <slob_free+0x16>
ffffffffc0201de6:	8082                	ret

ffffffffc0201de8 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201de8:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201dea:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201dec:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201df0:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201df2:	352000ef          	jal	ra,ffffffffc0202144 <alloc_pages>
	if (!page)
ffffffffc0201df6:	c91d                	beqz	a0,ffffffffc0201e2c <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201df8:	000be697          	auipc	a3,0xbe
ffffffffc0201dfc:	3306b683          	ld	a3,816(a3) # ffffffffc02c0128 <pages>
ffffffffc0201e00:	8d15                	sub	a0,a0,a3
ffffffffc0201e02:	8519                	srai	a0,a0,0x6
ffffffffc0201e04:	00006697          	auipc	a3,0x6
ffffffffc0201e08:	d846b683          	ld	a3,-636(a3) # ffffffffc0207b88 <nbase>
ffffffffc0201e0c:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201e0e:	00c51793          	slli	a5,a0,0xc
ffffffffc0201e12:	83b1                	srli	a5,a5,0xc
ffffffffc0201e14:	000be717          	auipc	a4,0xbe
ffffffffc0201e18:	30c73703          	ld	a4,780(a4) # ffffffffc02c0120 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e1c:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201e1e:	00e7fa63          	bgeu	a5,a4,ffffffffc0201e32 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201e22:	000be697          	auipc	a3,0xbe
ffffffffc0201e26:	3166b683          	ld	a3,790(a3) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0201e2a:	9536                	add	a0,a0,a3
}
ffffffffc0201e2c:	60a2                	ld	ra,8(sp)
ffffffffc0201e2e:	0141                	addi	sp,sp,16
ffffffffc0201e30:	8082                	ret
ffffffffc0201e32:	86aa                	mv	a3,a0
ffffffffc0201e34:	00004617          	auipc	a2,0x4
ffffffffc0201e38:	62460613          	addi	a2,a2,1572 # ffffffffc0206458 <commands+0x918>
ffffffffc0201e3c:	07100593          	li	a1,113
ffffffffc0201e40:	00004517          	auipc	a0,0x4
ffffffffc0201e44:	56850513          	addi	a0,a0,1384 # ffffffffc02063a8 <commands+0x868>
ffffffffc0201e48:	e46fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e4c <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201e4c:	1101                	addi	sp,sp,-32
ffffffffc0201e4e:	ec06                	sd	ra,24(sp)
ffffffffc0201e50:	e822                	sd	s0,16(sp)
ffffffffc0201e52:	e426                	sd	s1,8(sp)
ffffffffc0201e54:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201e56:	01050713          	addi	a4,a0,16
ffffffffc0201e5a:	6785                	lui	a5,0x1
ffffffffc0201e5c:	0cf77363          	bgeu	a4,a5,ffffffffc0201f22 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201e60:	00f50493          	addi	s1,a0,15
ffffffffc0201e64:	8091                	srli	s1,s1,0x4
ffffffffc0201e66:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e68:	10002673          	csrr	a2,sstatus
ffffffffc0201e6c:	8a09                	andi	a2,a2,2
ffffffffc0201e6e:	e25d                	bnez	a2,ffffffffc0201f14 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201e70:	000ba917          	auipc	s2,0xba
ffffffffc0201e74:	e3890913          	addi	s2,s2,-456 # ffffffffc02bbca8 <slobfree>
ffffffffc0201e78:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201e7c:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201e7e:	4398                	lw	a4,0(a5)
ffffffffc0201e80:	08975e63          	bge	a4,s1,ffffffffc0201f1c <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201e84:	00f68b63          	beq	a3,a5,ffffffffc0201e9a <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201e88:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201e8a:	4018                	lw	a4,0(s0)
ffffffffc0201e8c:	02975a63          	bge	a4,s1,ffffffffc0201ec0 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201e90:	00093683          	ld	a3,0(s2)
ffffffffc0201e94:	87a2                	mv	a5,s0
ffffffffc0201e96:	fef699e3          	bne	a3,a5,ffffffffc0201e88 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201e9a:	ee31                	bnez	a2,ffffffffc0201ef6 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201e9c:	4501                	li	a0,0
ffffffffc0201e9e:	f4bff0ef          	jal	ra,ffffffffc0201de8 <__slob_get_free_pages.constprop.0>
ffffffffc0201ea2:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201ea4:	cd05                	beqz	a0,ffffffffc0201edc <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201ea6:	6585                	lui	a1,0x1
ffffffffc0201ea8:	e8dff0ef          	jal	ra,ffffffffc0201d34 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201eac:	10002673          	csrr	a2,sstatus
ffffffffc0201eb0:	8a09                	andi	a2,a2,2
ffffffffc0201eb2:	ee05                	bnez	a2,ffffffffc0201eea <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201eb4:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201eb8:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201eba:	4018                	lw	a4,0(s0)
ffffffffc0201ebc:	fc974ae3          	blt	a4,s1,ffffffffc0201e90 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201ec0:	04e48763          	beq	s1,a4,ffffffffc0201f0e <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201ec4:	00449693          	slli	a3,s1,0x4
ffffffffc0201ec8:	96a2                	add	a3,a3,s0
ffffffffc0201eca:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201ecc:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201ece:	9f05                	subw	a4,a4,s1
ffffffffc0201ed0:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201ed2:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201ed4:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201ed6:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201eda:	e20d                	bnez	a2,ffffffffc0201efc <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201edc:	60e2                	ld	ra,24(sp)
ffffffffc0201ede:	8522                	mv	a0,s0
ffffffffc0201ee0:	6442                	ld	s0,16(sp)
ffffffffc0201ee2:	64a2                	ld	s1,8(sp)
ffffffffc0201ee4:	6902                	ld	s2,0(sp)
ffffffffc0201ee6:	6105                	addi	sp,sp,32
ffffffffc0201ee8:	8082                	ret
        intr_disable();
ffffffffc0201eea:	acbfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201eee:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201ef2:	4605                	li	a2,1
ffffffffc0201ef4:	b7d1                	j	ffffffffc0201eb8 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201ef6:	ab9fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201efa:	b74d                	j	ffffffffc0201e9c <slob_alloc.constprop.0+0x50>
ffffffffc0201efc:	ab3fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201f00:	60e2                	ld	ra,24(sp)
ffffffffc0201f02:	8522                	mv	a0,s0
ffffffffc0201f04:	6442                	ld	s0,16(sp)
ffffffffc0201f06:	64a2                	ld	s1,8(sp)
ffffffffc0201f08:	6902                	ld	s2,0(sp)
ffffffffc0201f0a:	6105                	addi	sp,sp,32
ffffffffc0201f0c:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201f0e:	6418                	ld	a4,8(s0)
ffffffffc0201f10:	e798                	sd	a4,8(a5)
ffffffffc0201f12:	b7d1                	j	ffffffffc0201ed6 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201f14:	aa1fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201f18:	4605                	li	a2,1
ffffffffc0201f1a:	bf99                	j	ffffffffc0201e70 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201f1c:	843e                	mv	s0,a5
ffffffffc0201f1e:	87b6                	mv	a5,a3
ffffffffc0201f20:	b745                	j	ffffffffc0201ec0 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201f22:	00005697          	auipc	a3,0x5
ffffffffc0201f26:	9ee68693          	addi	a3,a3,-1554 # ffffffffc0206910 <default_pmm_manager+0x38>
ffffffffc0201f2a:	00004617          	auipc	a2,0x4
ffffffffc0201f2e:	5fe60613          	addi	a2,a2,1534 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0201f32:	06300593          	li	a1,99
ffffffffc0201f36:	00005517          	auipc	a0,0x5
ffffffffc0201f3a:	9fa50513          	addi	a0,a0,-1542 # ffffffffc0206930 <default_pmm_manager+0x58>
ffffffffc0201f3e:	d50fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201f42 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201f42:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201f44:	00005517          	auipc	a0,0x5
ffffffffc0201f48:	a0450513          	addi	a0,a0,-1532 # ffffffffc0206948 <default_pmm_manager+0x70>
{
ffffffffc0201f4c:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201f4e:	a46fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201f52:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201f54:	00005517          	auipc	a0,0x5
ffffffffc0201f58:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0206960 <default_pmm_manager+0x88>
}
ffffffffc0201f5c:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201f5e:	a36fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201f62 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201f62:	4501                	li	a0,0
ffffffffc0201f64:	8082                	ret

ffffffffc0201f66 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201f66:	1101                	addi	sp,sp,-32
ffffffffc0201f68:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201f6a:	6905                	lui	s2,0x1
{
ffffffffc0201f6c:	e822                	sd	s0,16(sp)
ffffffffc0201f6e:	ec06                	sd	ra,24(sp)
ffffffffc0201f70:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201f72:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bc1>
{
ffffffffc0201f76:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201f78:	04a7f963          	bgeu	a5,a0,ffffffffc0201fca <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201f7c:	4561                	li	a0,24
ffffffffc0201f7e:	ecfff0ef          	jal	ra,ffffffffc0201e4c <slob_alloc.constprop.0>
ffffffffc0201f82:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201f84:	c929                	beqz	a0,ffffffffc0201fd6 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201f86:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201f8a:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201f8c:	00f95763          	bge	s2,a5,ffffffffc0201f9a <kmalloc+0x34>
ffffffffc0201f90:	6705                	lui	a4,0x1
ffffffffc0201f92:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201f94:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201f96:	fef74ee3          	blt	a4,a5,ffffffffc0201f92 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201f9a:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201f9c:	e4dff0ef          	jal	ra,ffffffffc0201de8 <__slob_get_free_pages.constprop.0>
ffffffffc0201fa0:	e488                	sd	a0,8(s1)
ffffffffc0201fa2:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201fa4:	c525                	beqz	a0,ffffffffc020200c <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fa6:	100027f3          	csrr	a5,sstatus
ffffffffc0201faa:	8b89                	andi	a5,a5,2
ffffffffc0201fac:	ef8d                	bnez	a5,ffffffffc0201fe6 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201fae:	000be797          	auipc	a5,0xbe
ffffffffc0201fb2:	15a78793          	addi	a5,a5,346 # ffffffffc02c0108 <bigblocks>
ffffffffc0201fb6:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201fb8:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201fba:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201fbc:	60e2                	ld	ra,24(sp)
ffffffffc0201fbe:	8522                	mv	a0,s0
ffffffffc0201fc0:	6442                	ld	s0,16(sp)
ffffffffc0201fc2:	64a2                	ld	s1,8(sp)
ffffffffc0201fc4:	6902                	ld	s2,0(sp)
ffffffffc0201fc6:	6105                	addi	sp,sp,32
ffffffffc0201fc8:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201fca:	0541                	addi	a0,a0,16
ffffffffc0201fcc:	e81ff0ef          	jal	ra,ffffffffc0201e4c <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201fd0:	01050413          	addi	s0,a0,16
ffffffffc0201fd4:	f565                	bnez	a0,ffffffffc0201fbc <kmalloc+0x56>
ffffffffc0201fd6:	4401                	li	s0,0
}
ffffffffc0201fd8:	60e2                	ld	ra,24(sp)
ffffffffc0201fda:	8522                	mv	a0,s0
ffffffffc0201fdc:	6442                	ld	s0,16(sp)
ffffffffc0201fde:	64a2                	ld	s1,8(sp)
ffffffffc0201fe0:	6902                	ld	s2,0(sp)
ffffffffc0201fe2:	6105                	addi	sp,sp,32
ffffffffc0201fe4:	8082                	ret
        intr_disable();
ffffffffc0201fe6:	9cffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201fea:	000be797          	auipc	a5,0xbe
ffffffffc0201fee:	11e78793          	addi	a5,a5,286 # ffffffffc02c0108 <bigblocks>
ffffffffc0201ff2:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201ff4:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201ff6:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201ff8:	9b7fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201ffc:	6480                	ld	s0,8(s1)
}
ffffffffc0201ffe:	60e2                	ld	ra,24(sp)
ffffffffc0202000:	64a2                	ld	s1,8(sp)
ffffffffc0202002:	8522                	mv	a0,s0
ffffffffc0202004:	6442                	ld	s0,16(sp)
ffffffffc0202006:	6902                	ld	s2,0(sp)
ffffffffc0202008:	6105                	addi	sp,sp,32
ffffffffc020200a:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc020200c:	45e1                	li	a1,24
ffffffffc020200e:	8526                	mv	a0,s1
ffffffffc0202010:	d25ff0ef          	jal	ra,ffffffffc0201d34 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0202014:	b765                	j	ffffffffc0201fbc <kmalloc+0x56>

ffffffffc0202016 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0202016:	c169                	beqz	a0,ffffffffc02020d8 <kfree+0xc2>
{
ffffffffc0202018:	1101                	addi	sp,sp,-32
ffffffffc020201a:	e822                	sd	s0,16(sp)
ffffffffc020201c:	ec06                	sd	ra,24(sp)
ffffffffc020201e:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0202020:	03451793          	slli	a5,a0,0x34
ffffffffc0202024:	842a                	mv	s0,a0
ffffffffc0202026:	e3d9                	bnez	a5,ffffffffc02020ac <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202028:	100027f3          	csrr	a5,sstatus
ffffffffc020202c:	8b89                	andi	a5,a5,2
ffffffffc020202e:	e7d9                	bnez	a5,ffffffffc02020bc <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0202030:	000be797          	auipc	a5,0xbe
ffffffffc0202034:	0d87b783          	ld	a5,216(a5) # ffffffffc02c0108 <bigblocks>
    return 0;
ffffffffc0202038:	4601                	li	a2,0
ffffffffc020203a:	cbad                	beqz	a5,ffffffffc02020ac <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc020203c:	000be697          	auipc	a3,0xbe
ffffffffc0202040:	0cc68693          	addi	a3,a3,204 # ffffffffc02c0108 <bigblocks>
ffffffffc0202044:	a021                	j	ffffffffc020204c <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0202046:	01048693          	addi	a3,s1,16
ffffffffc020204a:	c3a5                	beqz	a5,ffffffffc02020aa <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc020204c:	6798                	ld	a4,8(a5)
ffffffffc020204e:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0202050:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0202052:	fe871ae3          	bne	a4,s0,ffffffffc0202046 <kfree+0x30>
				*last = bb->next;
ffffffffc0202056:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0202058:	ee2d                	bnez	a2,ffffffffc02020d2 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc020205a:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc020205e:	4098                	lw	a4,0(s1)
ffffffffc0202060:	08f46963          	bltu	s0,a5,ffffffffc02020f2 <kfree+0xdc>
ffffffffc0202064:	000be697          	auipc	a3,0xbe
ffffffffc0202068:	0d46b683          	ld	a3,212(a3) # ffffffffc02c0138 <va_pa_offset>
ffffffffc020206c:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc020206e:	8031                	srli	s0,s0,0xc
ffffffffc0202070:	000be797          	auipc	a5,0xbe
ffffffffc0202074:	0b07b783          	ld	a5,176(a5) # ffffffffc02c0120 <npage>
ffffffffc0202078:	06f47163          	bgeu	s0,a5,ffffffffc02020da <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc020207c:	00006517          	auipc	a0,0x6
ffffffffc0202080:	b0c53503          	ld	a0,-1268(a0) # ffffffffc0207b88 <nbase>
ffffffffc0202084:	8c09                	sub	s0,s0,a0
ffffffffc0202086:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0202088:	000be517          	auipc	a0,0xbe
ffffffffc020208c:	0a053503          	ld	a0,160(a0) # ffffffffc02c0128 <pages>
ffffffffc0202090:	4585                	li	a1,1
ffffffffc0202092:	9522                	add	a0,a0,s0
ffffffffc0202094:	00e595bb          	sllw	a1,a1,a4
ffffffffc0202098:	0ea000ef          	jal	ra,ffffffffc0202182 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc020209c:	6442                	ld	s0,16(sp)
ffffffffc020209e:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02020a0:	8526                	mv	a0,s1
}
ffffffffc02020a2:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02020a4:	45e1                	li	a1,24
}
ffffffffc02020a6:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02020a8:	b171                	j	ffffffffc0201d34 <slob_free>
ffffffffc02020aa:	e20d                	bnez	a2,ffffffffc02020cc <kfree+0xb6>
ffffffffc02020ac:	ff040513          	addi	a0,s0,-16
}
ffffffffc02020b0:	6442                	ld	s0,16(sp)
ffffffffc02020b2:	60e2                	ld	ra,24(sp)
ffffffffc02020b4:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc02020b6:	4581                	li	a1,0
}
ffffffffc02020b8:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02020ba:	b9ad                	j	ffffffffc0201d34 <slob_free>
        intr_disable();
ffffffffc02020bc:	8f9fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc02020c0:	000be797          	auipc	a5,0xbe
ffffffffc02020c4:	0487b783          	ld	a5,72(a5) # ffffffffc02c0108 <bigblocks>
        return 1;
ffffffffc02020c8:	4605                	li	a2,1
ffffffffc02020ca:	fbad                	bnez	a5,ffffffffc020203c <kfree+0x26>
        intr_enable();
ffffffffc02020cc:	8e3fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02020d0:	bff1                	j	ffffffffc02020ac <kfree+0x96>
ffffffffc02020d2:	8ddfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02020d6:	b751                	j	ffffffffc020205a <kfree+0x44>
ffffffffc02020d8:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc02020da:	00004617          	auipc	a2,0x4
ffffffffc02020de:	2ae60613          	addi	a2,a2,686 # ffffffffc0206388 <commands+0x848>
ffffffffc02020e2:	06900593          	li	a1,105
ffffffffc02020e6:	00004517          	auipc	a0,0x4
ffffffffc02020ea:	2c250513          	addi	a0,a0,706 # ffffffffc02063a8 <commands+0x868>
ffffffffc02020ee:	ba0fe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc02020f2:	86a2                	mv	a3,s0
ffffffffc02020f4:	00005617          	auipc	a2,0x5
ffffffffc02020f8:	88c60613          	addi	a2,a2,-1908 # ffffffffc0206980 <default_pmm_manager+0xa8>
ffffffffc02020fc:	07700593          	li	a1,119
ffffffffc0202100:	00004517          	auipc	a0,0x4
ffffffffc0202104:	2a850513          	addi	a0,a0,680 # ffffffffc02063a8 <commands+0x868>
ffffffffc0202108:	b86fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020210c <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc020210c:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc020210e:	00004617          	auipc	a2,0x4
ffffffffc0202112:	27a60613          	addi	a2,a2,634 # ffffffffc0206388 <commands+0x848>
ffffffffc0202116:	06900593          	li	a1,105
ffffffffc020211a:	00004517          	auipc	a0,0x4
ffffffffc020211e:	28e50513          	addi	a0,a0,654 # ffffffffc02063a8 <commands+0x868>
pa2page(uintptr_t pa)
ffffffffc0202122:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0202124:	b6afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202128 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0202128:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc020212a:	00005617          	auipc	a2,0x5
ffffffffc020212e:	87e60613          	addi	a2,a2,-1922 # ffffffffc02069a8 <default_pmm_manager+0xd0>
ffffffffc0202132:	07f00593          	li	a1,127
ffffffffc0202136:	00004517          	auipc	a0,0x4
ffffffffc020213a:	27250513          	addi	a0,a0,626 # ffffffffc02063a8 <commands+0x868>
pte2page(pte_t pte)
ffffffffc020213e:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202140:	b4efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202144 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202144:	100027f3          	csrr	a5,sstatus
ffffffffc0202148:	8b89                	andi	a5,a5,2
ffffffffc020214a:	e799                	bnez	a5,ffffffffc0202158 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc020214c:	000be797          	auipc	a5,0xbe
ffffffffc0202150:	fe47b783          	ld	a5,-28(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc0202154:	6f9c                	ld	a5,24(a5)
ffffffffc0202156:	8782                	jr	a5
{
ffffffffc0202158:	1141                	addi	sp,sp,-16
ffffffffc020215a:	e406                	sd	ra,8(sp)
ffffffffc020215c:	e022                	sd	s0,0(sp)
ffffffffc020215e:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0202160:	855fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202164:	000be797          	auipc	a5,0xbe
ffffffffc0202168:	fcc7b783          	ld	a5,-52(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc020216c:	6f9c                	ld	a5,24(a5)
ffffffffc020216e:	8522                	mv	a0,s0
ffffffffc0202170:	9782                	jalr	a5
ffffffffc0202172:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202174:	83bfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0202178:	60a2                	ld	ra,8(sp)
ffffffffc020217a:	8522                	mv	a0,s0
ffffffffc020217c:	6402                	ld	s0,0(sp)
ffffffffc020217e:	0141                	addi	sp,sp,16
ffffffffc0202180:	8082                	ret

ffffffffc0202182 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202182:	100027f3          	csrr	a5,sstatus
ffffffffc0202186:	8b89                	andi	a5,a5,2
ffffffffc0202188:	e799                	bnez	a5,ffffffffc0202196 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc020218a:	000be797          	auipc	a5,0xbe
ffffffffc020218e:	fa67b783          	ld	a5,-90(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc0202192:	739c                	ld	a5,32(a5)
ffffffffc0202194:	8782                	jr	a5
{
ffffffffc0202196:	1101                	addi	sp,sp,-32
ffffffffc0202198:	ec06                	sd	ra,24(sp)
ffffffffc020219a:	e822                	sd	s0,16(sp)
ffffffffc020219c:	e426                	sd	s1,8(sp)
ffffffffc020219e:	842a                	mv	s0,a0
ffffffffc02021a0:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02021a2:	813fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02021a6:	000be797          	auipc	a5,0xbe
ffffffffc02021aa:	f8a7b783          	ld	a5,-118(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02021ae:	739c                	ld	a5,32(a5)
ffffffffc02021b0:	85a6                	mv	a1,s1
ffffffffc02021b2:	8522                	mv	a0,s0
ffffffffc02021b4:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02021b6:	6442                	ld	s0,16(sp)
ffffffffc02021b8:	60e2                	ld	ra,24(sp)
ffffffffc02021ba:	64a2                	ld	s1,8(sp)
ffffffffc02021bc:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02021be:	ff0fe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc02021c2 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02021c2:	100027f3          	csrr	a5,sstatus
ffffffffc02021c6:	8b89                	andi	a5,a5,2
ffffffffc02021c8:	e799                	bnez	a5,ffffffffc02021d6 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc02021ca:	000be797          	auipc	a5,0xbe
ffffffffc02021ce:	f667b783          	ld	a5,-154(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02021d2:	779c                	ld	a5,40(a5)
ffffffffc02021d4:	8782                	jr	a5
{
ffffffffc02021d6:	1141                	addi	sp,sp,-16
ffffffffc02021d8:	e406                	sd	ra,8(sp)
ffffffffc02021da:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02021dc:	fd8fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02021e0:	000be797          	auipc	a5,0xbe
ffffffffc02021e4:	f507b783          	ld	a5,-176(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02021e8:	779c                	ld	a5,40(a5)
ffffffffc02021ea:	9782                	jalr	a5
ffffffffc02021ec:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02021ee:	fc0fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc02021f2:	60a2                	ld	ra,8(sp)
ffffffffc02021f4:	8522                	mv	a0,s0
ffffffffc02021f6:	6402                	ld	s0,0(sp)
ffffffffc02021f8:	0141                	addi	sp,sp,16
ffffffffc02021fa:	8082                	ret

ffffffffc02021fc <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02021fc:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202200:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0202204:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202206:	078e                	slli	a5,a5,0x3
{
ffffffffc0202208:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020220a:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc020220e:	6094                	ld	a3,0(s1)
{
ffffffffc0202210:	f04a                	sd	s2,32(sp)
ffffffffc0202212:	ec4e                	sd	s3,24(sp)
ffffffffc0202214:	e852                	sd	s4,16(sp)
ffffffffc0202216:	fc06                	sd	ra,56(sp)
ffffffffc0202218:	f822                	sd	s0,48(sp)
ffffffffc020221a:	e456                	sd	s5,8(sp)
ffffffffc020221c:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc020221e:	0016f793          	andi	a5,a3,1
{
ffffffffc0202222:	892e                	mv	s2,a1
ffffffffc0202224:	8a32                	mv	s4,a2
ffffffffc0202226:	000be997          	auipc	s3,0xbe
ffffffffc020222a:	efa98993          	addi	s3,s3,-262 # ffffffffc02c0120 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc020222e:	efbd                	bnez	a5,ffffffffc02022ac <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202230:	14060c63          	beqz	a2,ffffffffc0202388 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202234:	100027f3          	csrr	a5,sstatus
ffffffffc0202238:	8b89                	andi	a5,a5,2
ffffffffc020223a:	14079963          	bnez	a5,ffffffffc020238c <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc020223e:	000be797          	auipc	a5,0xbe
ffffffffc0202242:	ef27b783          	ld	a5,-270(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc0202246:	6f9c                	ld	a5,24(a5)
ffffffffc0202248:	4505                	li	a0,1
ffffffffc020224a:	9782                	jalr	a5
ffffffffc020224c:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020224e:	12040d63          	beqz	s0,ffffffffc0202388 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202252:	000beb17          	auipc	s6,0xbe
ffffffffc0202256:	ed6b0b13          	addi	s6,s6,-298 # ffffffffc02c0128 <pages>
ffffffffc020225a:	000b3503          	ld	a0,0(s6)
ffffffffc020225e:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202262:	000be997          	auipc	s3,0xbe
ffffffffc0202266:	ebe98993          	addi	s3,s3,-322 # ffffffffc02c0120 <npage>
ffffffffc020226a:	40a40533          	sub	a0,s0,a0
ffffffffc020226e:	8519                	srai	a0,a0,0x6
ffffffffc0202270:	9556                	add	a0,a0,s5
ffffffffc0202272:	0009b703          	ld	a4,0(s3)
ffffffffc0202276:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc020227a:	4685                	li	a3,1
ffffffffc020227c:	c014                	sw	a3,0(s0)
ffffffffc020227e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202280:	0532                	slli	a0,a0,0xc
ffffffffc0202282:	16e7f763          	bgeu	a5,a4,ffffffffc02023f0 <get_pte+0x1f4>
ffffffffc0202286:	000be797          	auipc	a5,0xbe
ffffffffc020228a:	eb27b783          	ld	a5,-334(a5) # ffffffffc02c0138 <va_pa_offset>
ffffffffc020228e:	6605                	lui	a2,0x1
ffffffffc0202290:	4581                	li	a1,0
ffffffffc0202292:	953e                	add	a0,a0,a5
ffffffffc0202294:	614030ef          	jal	ra,ffffffffc02058a8 <memset>
    return page - pages + nbase;
ffffffffc0202298:	000b3683          	ld	a3,0(s6)
ffffffffc020229c:	40d406b3          	sub	a3,s0,a3
ffffffffc02022a0:	8699                	srai	a3,a3,0x6
ffffffffc02022a2:	96d6                	add	a3,a3,s5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02022a4:	06aa                	slli	a3,a3,0xa
ffffffffc02022a6:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02022aa:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02022ac:	77fd                	lui	a5,0xfffff
ffffffffc02022ae:	068a                	slli	a3,a3,0x2
ffffffffc02022b0:	0009b703          	ld	a4,0(s3)
ffffffffc02022b4:	8efd                	and	a3,a3,a5
ffffffffc02022b6:	00c6d793          	srli	a5,a3,0xc
ffffffffc02022ba:	10e7ff63          	bgeu	a5,a4,ffffffffc02023d8 <get_pte+0x1dc>
ffffffffc02022be:	000bea97          	auipc	s5,0xbe
ffffffffc02022c2:	e7aa8a93          	addi	s5,s5,-390 # ffffffffc02c0138 <va_pa_offset>
ffffffffc02022c6:	000ab403          	ld	s0,0(s5)
ffffffffc02022ca:	01595793          	srli	a5,s2,0x15
ffffffffc02022ce:	1ff7f793          	andi	a5,a5,511
ffffffffc02022d2:	96a2                	add	a3,a3,s0
ffffffffc02022d4:	00379413          	slli	s0,a5,0x3
ffffffffc02022d8:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc02022da:	6014                	ld	a3,0(s0)
ffffffffc02022dc:	0016f793          	andi	a5,a3,1
ffffffffc02022e0:	ebad                	bnez	a5,ffffffffc0202352 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02022e2:	0a0a0363          	beqz	s4,ffffffffc0202388 <get_pte+0x18c>
ffffffffc02022e6:	100027f3          	csrr	a5,sstatus
ffffffffc02022ea:	8b89                	andi	a5,a5,2
ffffffffc02022ec:	efcd                	bnez	a5,ffffffffc02023a6 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc02022ee:	000be797          	auipc	a5,0xbe
ffffffffc02022f2:	e427b783          	ld	a5,-446(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02022f6:	6f9c                	ld	a5,24(a5)
ffffffffc02022f8:	4505                	li	a0,1
ffffffffc02022fa:	9782                	jalr	a5
ffffffffc02022fc:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02022fe:	c4c9                	beqz	s1,ffffffffc0202388 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202300:	000beb17          	auipc	s6,0xbe
ffffffffc0202304:	e28b0b13          	addi	s6,s6,-472 # ffffffffc02c0128 <pages>
ffffffffc0202308:	000b3503          	ld	a0,0(s6)
ffffffffc020230c:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202310:	0009b703          	ld	a4,0(s3)
ffffffffc0202314:	40a48533          	sub	a0,s1,a0
ffffffffc0202318:	8519                	srai	a0,a0,0x6
ffffffffc020231a:	9552                	add	a0,a0,s4
ffffffffc020231c:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202320:	4685                	li	a3,1
ffffffffc0202322:	c094                	sw	a3,0(s1)
ffffffffc0202324:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202326:	0532                	slli	a0,a0,0xc
ffffffffc0202328:	0ee7f163          	bgeu	a5,a4,ffffffffc020240a <get_pte+0x20e>
ffffffffc020232c:	000ab783          	ld	a5,0(s5)
ffffffffc0202330:	6605                	lui	a2,0x1
ffffffffc0202332:	4581                	li	a1,0
ffffffffc0202334:	953e                	add	a0,a0,a5
ffffffffc0202336:	572030ef          	jal	ra,ffffffffc02058a8 <memset>
    return page - pages + nbase;
ffffffffc020233a:	000b3683          	ld	a3,0(s6)
ffffffffc020233e:	40d486b3          	sub	a3,s1,a3
ffffffffc0202342:	8699                	srai	a3,a3,0x6
ffffffffc0202344:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202346:	06aa                	slli	a3,a3,0xa
ffffffffc0202348:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020234c:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020234e:	0009b703          	ld	a4,0(s3)
ffffffffc0202352:	068a                	slli	a3,a3,0x2
ffffffffc0202354:	757d                	lui	a0,0xfffff
ffffffffc0202356:	8ee9                	and	a3,a3,a0
ffffffffc0202358:	00c6d793          	srli	a5,a3,0xc
ffffffffc020235c:	06e7f263          	bgeu	a5,a4,ffffffffc02023c0 <get_pte+0x1c4>
ffffffffc0202360:	000ab503          	ld	a0,0(s5)
ffffffffc0202364:	00c95913          	srli	s2,s2,0xc
ffffffffc0202368:	1ff97913          	andi	s2,s2,511
ffffffffc020236c:	96aa                	add	a3,a3,a0
ffffffffc020236e:	00391513          	slli	a0,s2,0x3
ffffffffc0202372:	9536                	add	a0,a0,a3
}
ffffffffc0202374:	70e2                	ld	ra,56(sp)
ffffffffc0202376:	7442                	ld	s0,48(sp)
ffffffffc0202378:	74a2                	ld	s1,40(sp)
ffffffffc020237a:	7902                	ld	s2,32(sp)
ffffffffc020237c:	69e2                	ld	s3,24(sp)
ffffffffc020237e:	6a42                	ld	s4,16(sp)
ffffffffc0202380:	6aa2                	ld	s5,8(sp)
ffffffffc0202382:	6b02                	ld	s6,0(sp)
ffffffffc0202384:	6121                	addi	sp,sp,64
ffffffffc0202386:	8082                	ret
            return NULL;
ffffffffc0202388:	4501                	li	a0,0
ffffffffc020238a:	b7ed                	j	ffffffffc0202374 <get_pte+0x178>
        intr_disable();
ffffffffc020238c:	e28fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202390:	000be797          	auipc	a5,0xbe
ffffffffc0202394:	da07b783          	ld	a5,-608(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc0202398:	6f9c                	ld	a5,24(a5)
ffffffffc020239a:	4505                	li	a0,1
ffffffffc020239c:	9782                	jalr	a5
ffffffffc020239e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02023a0:	e0efe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02023a4:	b56d                	j	ffffffffc020224e <get_pte+0x52>
        intr_disable();
ffffffffc02023a6:	e0efe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02023aa:	000be797          	auipc	a5,0xbe
ffffffffc02023ae:	d867b783          	ld	a5,-634(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02023b2:	6f9c                	ld	a5,24(a5)
ffffffffc02023b4:	4505                	li	a0,1
ffffffffc02023b6:	9782                	jalr	a5
ffffffffc02023b8:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02023ba:	df4fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02023be:	b781                	j	ffffffffc02022fe <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02023c0:	00004617          	auipc	a2,0x4
ffffffffc02023c4:	09860613          	addi	a2,a2,152 # ffffffffc0206458 <commands+0x918>
ffffffffc02023c8:	0fa00593          	li	a1,250
ffffffffc02023cc:	00004517          	auipc	a0,0x4
ffffffffc02023d0:	60450513          	addi	a0,a0,1540 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02023d4:	8bafe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02023d8:	00004617          	auipc	a2,0x4
ffffffffc02023dc:	08060613          	addi	a2,a2,128 # ffffffffc0206458 <commands+0x918>
ffffffffc02023e0:	0ed00593          	li	a1,237
ffffffffc02023e4:	00004517          	auipc	a0,0x4
ffffffffc02023e8:	5ec50513          	addi	a0,a0,1516 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02023ec:	8a2fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02023f0:	86aa                	mv	a3,a0
ffffffffc02023f2:	00004617          	auipc	a2,0x4
ffffffffc02023f6:	06660613          	addi	a2,a2,102 # ffffffffc0206458 <commands+0x918>
ffffffffc02023fa:	0e900593          	li	a1,233
ffffffffc02023fe:	00004517          	auipc	a0,0x4
ffffffffc0202402:	5d250513          	addi	a0,a0,1490 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0202406:	888fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020240a:	86aa                	mv	a3,a0
ffffffffc020240c:	00004617          	auipc	a2,0x4
ffffffffc0202410:	04c60613          	addi	a2,a2,76 # ffffffffc0206458 <commands+0x918>
ffffffffc0202414:	0f700593          	li	a1,247
ffffffffc0202418:	00004517          	auipc	a0,0x4
ffffffffc020241c:	5b850513          	addi	a0,a0,1464 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0202420:	86efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202424 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202424:	1141                	addi	sp,sp,-16
ffffffffc0202426:	e022                	sd	s0,0(sp)
ffffffffc0202428:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020242a:	4601                	li	a2,0
{
ffffffffc020242c:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020242e:	dcfff0ef          	jal	ra,ffffffffc02021fc <get_pte>
    if (ptep_store != NULL)
ffffffffc0202432:	c011                	beqz	s0,ffffffffc0202436 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202434:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202436:	c511                	beqz	a0,ffffffffc0202442 <get_page+0x1e>
ffffffffc0202438:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020243a:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020243c:	0017f713          	andi	a4,a5,1
ffffffffc0202440:	e709                	bnez	a4,ffffffffc020244a <get_page+0x26>
}
ffffffffc0202442:	60a2                	ld	ra,8(sp)
ffffffffc0202444:	6402                	ld	s0,0(sp)
ffffffffc0202446:	0141                	addi	sp,sp,16
ffffffffc0202448:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020244a:	078a                	slli	a5,a5,0x2
ffffffffc020244c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020244e:	000be717          	auipc	a4,0xbe
ffffffffc0202452:	cd273703          	ld	a4,-814(a4) # ffffffffc02c0120 <npage>
ffffffffc0202456:	00e7ff63          	bgeu	a5,a4,ffffffffc0202474 <get_page+0x50>
ffffffffc020245a:	60a2                	ld	ra,8(sp)
ffffffffc020245c:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc020245e:	fff80537          	lui	a0,0xfff80
ffffffffc0202462:	97aa                	add	a5,a5,a0
ffffffffc0202464:	079a                	slli	a5,a5,0x6
ffffffffc0202466:	000be517          	auipc	a0,0xbe
ffffffffc020246a:	cc253503          	ld	a0,-830(a0) # ffffffffc02c0128 <pages>
ffffffffc020246e:	953e                	add	a0,a0,a5
ffffffffc0202470:	0141                	addi	sp,sp,16
ffffffffc0202472:	8082                	ret
ffffffffc0202474:	c99ff0ef          	jal	ra,ffffffffc020210c <pa2page.part.0>

ffffffffc0202478 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202478:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020247a:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020247e:	f486                	sd	ra,104(sp)
ffffffffc0202480:	f0a2                	sd	s0,96(sp)
ffffffffc0202482:	eca6                	sd	s1,88(sp)
ffffffffc0202484:	e8ca                	sd	s2,80(sp)
ffffffffc0202486:	e4ce                	sd	s3,72(sp)
ffffffffc0202488:	e0d2                	sd	s4,64(sp)
ffffffffc020248a:	fc56                	sd	s5,56(sp)
ffffffffc020248c:	f85a                	sd	s6,48(sp)
ffffffffc020248e:	f45e                	sd	s7,40(sp)
ffffffffc0202490:	f062                	sd	s8,32(sp)
ffffffffc0202492:	ec66                	sd	s9,24(sp)
ffffffffc0202494:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202496:	17d2                	slli	a5,a5,0x34
ffffffffc0202498:	e3ed                	bnez	a5,ffffffffc020257a <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc020249a:	002007b7          	lui	a5,0x200
ffffffffc020249e:	842e                	mv	s0,a1
ffffffffc02024a0:	0ef5ed63          	bltu	a1,a5,ffffffffc020259a <unmap_range+0x122>
ffffffffc02024a4:	8932                	mv	s2,a2
ffffffffc02024a6:	0ec5fa63          	bgeu	a1,a2,ffffffffc020259a <unmap_range+0x122>
ffffffffc02024aa:	4785                	li	a5,1
ffffffffc02024ac:	07fe                	slli	a5,a5,0x1f
ffffffffc02024ae:	0ec7e663          	bltu	a5,a2,ffffffffc020259a <unmap_range+0x122>
ffffffffc02024b2:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02024b4:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02024b6:	000bec97          	auipc	s9,0xbe
ffffffffc02024ba:	c6ac8c93          	addi	s9,s9,-918 # ffffffffc02c0120 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02024be:	000bec17          	auipc	s8,0xbe
ffffffffc02024c2:	c6ac0c13          	addi	s8,s8,-918 # ffffffffc02c0128 <pages>
ffffffffc02024c6:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc02024ca:	000bed17          	auipc	s10,0xbe
ffffffffc02024ce:	c66d0d13          	addi	s10,s10,-922 # ffffffffc02c0130 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02024d2:	00200b37          	lui	s6,0x200
ffffffffc02024d6:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02024da:	4601                	li	a2,0
ffffffffc02024dc:	85a2                	mv	a1,s0
ffffffffc02024de:	854e                	mv	a0,s3
ffffffffc02024e0:	d1dff0ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc02024e4:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02024e6:	cd29                	beqz	a0,ffffffffc0202540 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc02024e8:	611c                	ld	a5,0(a0)
ffffffffc02024ea:	e395                	bnez	a5,ffffffffc020250e <unmap_range+0x96>
        start += PGSIZE;
ffffffffc02024ec:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02024ee:	ff2466e3          	bltu	s0,s2,ffffffffc02024da <unmap_range+0x62>
}
ffffffffc02024f2:	70a6                	ld	ra,104(sp)
ffffffffc02024f4:	7406                	ld	s0,96(sp)
ffffffffc02024f6:	64e6                	ld	s1,88(sp)
ffffffffc02024f8:	6946                	ld	s2,80(sp)
ffffffffc02024fa:	69a6                	ld	s3,72(sp)
ffffffffc02024fc:	6a06                	ld	s4,64(sp)
ffffffffc02024fe:	7ae2                	ld	s5,56(sp)
ffffffffc0202500:	7b42                	ld	s6,48(sp)
ffffffffc0202502:	7ba2                	ld	s7,40(sp)
ffffffffc0202504:	7c02                	ld	s8,32(sp)
ffffffffc0202506:	6ce2                	ld	s9,24(sp)
ffffffffc0202508:	6d42                	ld	s10,16(sp)
ffffffffc020250a:	6165                	addi	sp,sp,112
ffffffffc020250c:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc020250e:	0017f713          	andi	a4,a5,1
ffffffffc0202512:	df69                	beqz	a4,ffffffffc02024ec <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202514:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202518:	078a                	slli	a5,a5,0x2
ffffffffc020251a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020251c:	08e7ff63          	bgeu	a5,a4,ffffffffc02025ba <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202520:	000c3503          	ld	a0,0(s8)
ffffffffc0202524:	97de                	add	a5,a5,s7
ffffffffc0202526:	079a                	slli	a5,a5,0x6
ffffffffc0202528:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020252a:	411c                	lw	a5,0(a0)
ffffffffc020252c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202530:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202532:	cf11                	beqz	a4,ffffffffc020254e <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202534:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202538:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc020253c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020253e:	bf45                	j	ffffffffc02024ee <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202540:	945a                	add	s0,s0,s6
ffffffffc0202542:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc0202546:	d455                	beqz	s0,ffffffffc02024f2 <unmap_range+0x7a>
ffffffffc0202548:	f92469e3          	bltu	s0,s2,ffffffffc02024da <unmap_range+0x62>
ffffffffc020254c:	b75d                	j	ffffffffc02024f2 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020254e:	100027f3          	csrr	a5,sstatus
ffffffffc0202552:	8b89                	andi	a5,a5,2
ffffffffc0202554:	e799                	bnez	a5,ffffffffc0202562 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc0202556:	000d3783          	ld	a5,0(s10)
ffffffffc020255a:	4585                	li	a1,1
ffffffffc020255c:	739c                	ld	a5,32(a5)
ffffffffc020255e:	9782                	jalr	a5
    if (flag)
ffffffffc0202560:	bfd1                	j	ffffffffc0202534 <unmap_range+0xbc>
ffffffffc0202562:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202564:	c50fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202568:	000d3783          	ld	a5,0(s10)
ffffffffc020256c:	6522                	ld	a0,8(sp)
ffffffffc020256e:	4585                	li	a1,1
ffffffffc0202570:	739c                	ld	a5,32(a5)
ffffffffc0202572:	9782                	jalr	a5
        intr_enable();
ffffffffc0202574:	c3afe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202578:	bf75                	j	ffffffffc0202534 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020257a:	00004697          	auipc	a3,0x4
ffffffffc020257e:	46668693          	addi	a3,a3,1126 # ffffffffc02069e0 <default_pmm_manager+0x108>
ffffffffc0202582:	00004617          	auipc	a2,0x4
ffffffffc0202586:	fa660613          	addi	a2,a2,-90 # ffffffffc0206528 <commands+0x9e8>
ffffffffc020258a:	12000593          	li	a1,288
ffffffffc020258e:	00004517          	auipc	a0,0x4
ffffffffc0202592:	44250513          	addi	a0,a0,1090 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0202596:	ef9fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020259a:	00004697          	auipc	a3,0x4
ffffffffc020259e:	47668693          	addi	a3,a3,1142 # ffffffffc0206a10 <default_pmm_manager+0x138>
ffffffffc02025a2:	00004617          	auipc	a2,0x4
ffffffffc02025a6:	f8660613          	addi	a2,a2,-122 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02025aa:	12100593          	li	a1,289
ffffffffc02025ae:	00004517          	auipc	a0,0x4
ffffffffc02025b2:	42250513          	addi	a0,a0,1058 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02025b6:	ed9fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02025ba:	b53ff0ef          	jal	ra,ffffffffc020210c <pa2page.part.0>

ffffffffc02025be <exit_range>:
{
ffffffffc02025be:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02025c0:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02025c4:	fc86                	sd	ra,120(sp)
ffffffffc02025c6:	f8a2                	sd	s0,112(sp)
ffffffffc02025c8:	f4a6                	sd	s1,104(sp)
ffffffffc02025ca:	f0ca                	sd	s2,96(sp)
ffffffffc02025cc:	ecce                	sd	s3,88(sp)
ffffffffc02025ce:	e8d2                	sd	s4,80(sp)
ffffffffc02025d0:	e4d6                	sd	s5,72(sp)
ffffffffc02025d2:	e0da                	sd	s6,64(sp)
ffffffffc02025d4:	fc5e                	sd	s7,56(sp)
ffffffffc02025d6:	f862                	sd	s8,48(sp)
ffffffffc02025d8:	f466                	sd	s9,40(sp)
ffffffffc02025da:	f06a                	sd	s10,32(sp)
ffffffffc02025dc:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02025de:	17d2                	slli	a5,a5,0x34
ffffffffc02025e0:	20079a63          	bnez	a5,ffffffffc02027f4 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc02025e4:	002007b7          	lui	a5,0x200
ffffffffc02025e8:	24f5e463          	bltu	a1,a5,ffffffffc0202830 <exit_range+0x272>
ffffffffc02025ec:	8ab2                	mv	s5,a2
ffffffffc02025ee:	24c5f163          	bgeu	a1,a2,ffffffffc0202830 <exit_range+0x272>
ffffffffc02025f2:	4785                	li	a5,1
ffffffffc02025f4:	07fe                	slli	a5,a5,0x1f
ffffffffc02025f6:	22c7ed63          	bltu	a5,a2,ffffffffc0202830 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02025fa:	c00009b7          	lui	s3,0xc0000
ffffffffc02025fe:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202602:	ffe00937          	lui	s2,0xffe00
ffffffffc0202606:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020260a:	5cfd                	li	s9,-1
ffffffffc020260c:	8c2a                	mv	s8,a0
ffffffffc020260e:	0125f933          	and	s2,a1,s2
ffffffffc0202612:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202614:	000bed17          	auipc	s10,0xbe
ffffffffc0202618:	b0cd0d13          	addi	s10,s10,-1268 # ffffffffc02c0120 <npage>
    return KADDR(page2pa(page));
ffffffffc020261c:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202620:	000be717          	auipc	a4,0xbe
ffffffffc0202624:	b0870713          	addi	a4,a4,-1272 # ffffffffc02c0128 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202628:	000bed97          	auipc	s11,0xbe
ffffffffc020262c:	b08d8d93          	addi	s11,s11,-1272 # ffffffffc02c0130 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202630:	c0000437          	lui	s0,0xc0000
ffffffffc0202634:	944e                	add	s0,s0,s3
ffffffffc0202636:	8079                	srli	s0,s0,0x1e
ffffffffc0202638:	1ff47413          	andi	s0,s0,511
ffffffffc020263c:	040e                	slli	s0,s0,0x3
ffffffffc020263e:	9462                	add	s0,s0,s8
ffffffffc0202640:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_dirtycow_test_out_size+0xffffffffbfff4de0>
        if (pde1 & PTE_V)
ffffffffc0202644:	001a7793          	andi	a5,s4,1
ffffffffc0202648:	eb99                	bnez	a5,ffffffffc020265e <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc020264a:	12098463          	beqz	s3,ffffffffc0202772 <exit_range+0x1b4>
ffffffffc020264e:	400007b7          	lui	a5,0x40000
ffffffffc0202652:	97ce                	add	a5,a5,s3
ffffffffc0202654:	894e                	mv	s2,s3
ffffffffc0202656:	1159fe63          	bgeu	s3,s5,ffffffffc0202772 <exit_range+0x1b4>
ffffffffc020265a:	89be                	mv	s3,a5
ffffffffc020265c:	bfd1                	j	ffffffffc0202630 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc020265e:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202662:	0a0a                	slli	s4,s4,0x2
ffffffffc0202664:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202668:	1cfa7263          	bgeu	s4,a5,ffffffffc020282c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020266c:	fff80637          	lui	a2,0xfff80
ffffffffc0202670:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202672:	000806b7          	lui	a3,0x80
ffffffffc0202676:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202678:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020267c:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020267e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202680:	18f5fa63          	bgeu	a1,a5,ffffffffc0202814 <exit_range+0x256>
ffffffffc0202684:	000be817          	auipc	a6,0xbe
ffffffffc0202688:	ab480813          	addi	a6,a6,-1356 # ffffffffc02c0138 <va_pa_offset>
ffffffffc020268c:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202690:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202692:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0202696:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202698:	00080337          	lui	t1,0x80
ffffffffc020269c:	6885                	lui	a7,0x1
ffffffffc020269e:	a819                	j	ffffffffc02026b4 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc02026a0:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc02026a2:	002007b7          	lui	a5,0x200
ffffffffc02026a6:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02026a8:	08090c63          	beqz	s2,ffffffffc0202740 <exit_range+0x182>
ffffffffc02026ac:	09397a63          	bgeu	s2,s3,ffffffffc0202740 <exit_range+0x182>
ffffffffc02026b0:	0f597063          	bgeu	s2,s5,ffffffffc0202790 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02026b4:	01595493          	srli	s1,s2,0x15
ffffffffc02026b8:	1ff4f493          	andi	s1,s1,511
ffffffffc02026bc:	048e                	slli	s1,s1,0x3
ffffffffc02026be:	94da                	add	s1,s1,s6
ffffffffc02026c0:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc02026c2:	0017f693          	andi	a3,a5,1
ffffffffc02026c6:	dee9                	beqz	a3,ffffffffc02026a0 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc02026c8:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02026cc:	078a                	slli	a5,a5,0x2
ffffffffc02026ce:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026d0:	14b7fe63          	bgeu	a5,a1,ffffffffc020282c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02026d4:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc02026d6:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc02026da:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02026de:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02026e2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02026e4:	12bef863          	bgeu	t4,a1,ffffffffc0202814 <exit_range+0x256>
ffffffffc02026e8:	00083783          	ld	a5,0(a6)
ffffffffc02026ec:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02026ee:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc02026f2:	629c                	ld	a5,0(a3)
ffffffffc02026f4:	8b85                	andi	a5,a5,1
ffffffffc02026f6:	f7d5                	bnez	a5,ffffffffc02026a2 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02026f8:	06a1                	addi	a3,a3,8
ffffffffc02026fa:	fed59ce3          	bne	a1,a3,ffffffffc02026f2 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc02026fe:	631c                	ld	a5,0(a4)
ffffffffc0202700:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202702:	100027f3          	csrr	a5,sstatus
ffffffffc0202706:	8b89                	andi	a5,a5,2
ffffffffc0202708:	e7d9                	bnez	a5,ffffffffc0202796 <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020270a:	000db783          	ld	a5,0(s11)
ffffffffc020270e:	4585                	li	a1,1
ffffffffc0202710:	e032                	sd	a2,0(sp)
ffffffffc0202712:	739c                	ld	a5,32(a5)
ffffffffc0202714:	9782                	jalr	a5
    if (flag)
ffffffffc0202716:	6602                	ld	a2,0(sp)
ffffffffc0202718:	000be817          	auipc	a6,0xbe
ffffffffc020271c:	a2080813          	addi	a6,a6,-1504 # ffffffffc02c0138 <va_pa_offset>
ffffffffc0202720:	fff80e37          	lui	t3,0xfff80
ffffffffc0202724:	00080337          	lui	t1,0x80
ffffffffc0202728:	6885                	lui	a7,0x1
ffffffffc020272a:	000be717          	auipc	a4,0xbe
ffffffffc020272e:	9fe70713          	addi	a4,a4,-1538 # ffffffffc02c0128 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202732:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc0202736:	002007b7          	lui	a5,0x200
ffffffffc020273a:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020273c:	f60918e3          	bnez	s2,ffffffffc02026ac <exit_range+0xee>
            if (free_pd0)
ffffffffc0202740:	f00b85e3          	beqz	s7,ffffffffc020264a <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202744:	000d3783          	ld	a5,0(s10)
ffffffffc0202748:	0efa7263          	bgeu	s4,a5,ffffffffc020282c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020274c:	6308                	ld	a0,0(a4)
ffffffffc020274e:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202750:	100027f3          	csrr	a5,sstatus
ffffffffc0202754:	8b89                	andi	a5,a5,2
ffffffffc0202756:	efad                	bnez	a5,ffffffffc02027d0 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0202758:	000db783          	ld	a5,0(s11)
ffffffffc020275c:	4585                	li	a1,1
ffffffffc020275e:	739c                	ld	a5,32(a5)
ffffffffc0202760:	9782                	jalr	a5
ffffffffc0202762:	000be717          	auipc	a4,0xbe
ffffffffc0202766:	9c670713          	addi	a4,a4,-1594 # ffffffffc02c0128 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020276a:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc020276e:	ee0990e3          	bnez	s3,ffffffffc020264e <exit_range+0x90>
}
ffffffffc0202772:	70e6                	ld	ra,120(sp)
ffffffffc0202774:	7446                	ld	s0,112(sp)
ffffffffc0202776:	74a6                	ld	s1,104(sp)
ffffffffc0202778:	7906                	ld	s2,96(sp)
ffffffffc020277a:	69e6                	ld	s3,88(sp)
ffffffffc020277c:	6a46                	ld	s4,80(sp)
ffffffffc020277e:	6aa6                	ld	s5,72(sp)
ffffffffc0202780:	6b06                	ld	s6,64(sp)
ffffffffc0202782:	7be2                	ld	s7,56(sp)
ffffffffc0202784:	7c42                	ld	s8,48(sp)
ffffffffc0202786:	7ca2                	ld	s9,40(sp)
ffffffffc0202788:	7d02                	ld	s10,32(sp)
ffffffffc020278a:	6de2                	ld	s11,24(sp)
ffffffffc020278c:	6109                	addi	sp,sp,128
ffffffffc020278e:	8082                	ret
            if (free_pd0)
ffffffffc0202790:	ea0b8fe3          	beqz	s7,ffffffffc020264e <exit_range+0x90>
ffffffffc0202794:	bf45                	j	ffffffffc0202744 <exit_range+0x186>
ffffffffc0202796:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202798:	e42a                	sd	a0,8(sp)
ffffffffc020279a:	a1afe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020279e:	000db783          	ld	a5,0(s11)
ffffffffc02027a2:	6522                	ld	a0,8(sp)
ffffffffc02027a4:	4585                	li	a1,1
ffffffffc02027a6:	739c                	ld	a5,32(a5)
ffffffffc02027a8:	9782                	jalr	a5
        intr_enable();
ffffffffc02027aa:	a04fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02027ae:	6602                	ld	a2,0(sp)
ffffffffc02027b0:	000be717          	auipc	a4,0xbe
ffffffffc02027b4:	97870713          	addi	a4,a4,-1672 # ffffffffc02c0128 <pages>
ffffffffc02027b8:	6885                	lui	a7,0x1
ffffffffc02027ba:	00080337          	lui	t1,0x80
ffffffffc02027be:	fff80e37          	lui	t3,0xfff80
ffffffffc02027c2:	000be817          	auipc	a6,0xbe
ffffffffc02027c6:	97680813          	addi	a6,a6,-1674 # ffffffffc02c0138 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02027ca:	0004b023          	sd	zero,0(s1)
ffffffffc02027ce:	b7a5                	j	ffffffffc0202736 <exit_range+0x178>
ffffffffc02027d0:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc02027d2:	9e2fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02027d6:	000db783          	ld	a5,0(s11)
ffffffffc02027da:	6502                	ld	a0,0(sp)
ffffffffc02027dc:	4585                	li	a1,1
ffffffffc02027de:	739c                	ld	a5,32(a5)
ffffffffc02027e0:	9782                	jalr	a5
        intr_enable();
ffffffffc02027e2:	9ccfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02027e6:	000be717          	auipc	a4,0xbe
ffffffffc02027ea:	94270713          	addi	a4,a4,-1726 # ffffffffc02c0128 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02027ee:	00043023          	sd	zero,0(s0)
ffffffffc02027f2:	bfb5                	j	ffffffffc020276e <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02027f4:	00004697          	auipc	a3,0x4
ffffffffc02027f8:	1ec68693          	addi	a3,a3,492 # ffffffffc02069e0 <default_pmm_manager+0x108>
ffffffffc02027fc:	00004617          	auipc	a2,0x4
ffffffffc0202800:	d2c60613          	addi	a2,a2,-724 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0202804:	13500593          	li	a1,309
ffffffffc0202808:	00004517          	auipc	a0,0x4
ffffffffc020280c:	1c850513          	addi	a0,a0,456 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0202810:	c7ffd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202814:	00004617          	auipc	a2,0x4
ffffffffc0202818:	c4460613          	addi	a2,a2,-956 # ffffffffc0206458 <commands+0x918>
ffffffffc020281c:	07100593          	li	a1,113
ffffffffc0202820:	00004517          	auipc	a0,0x4
ffffffffc0202824:	b8850513          	addi	a0,a0,-1144 # ffffffffc02063a8 <commands+0x868>
ffffffffc0202828:	c67fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020282c:	8e1ff0ef          	jal	ra,ffffffffc020210c <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202830:	00004697          	auipc	a3,0x4
ffffffffc0202834:	1e068693          	addi	a3,a3,480 # ffffffffc0206a10 <default_pmm_manager+0x138>
ffffffffc0202838:	00004617          	auipc	a2,0x4
ffffffffc020283c:	cf060613          	addi	a2,a2,-784 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0202840:	13600593          	li	a1,310
ffffffffc0202844:	00004517          	auipc	a0,0x4
ffffffffc0202848:	18c50513          	addi	a0,a0,396 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020284c:	c43fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202850 <page_remove>:
{
ffffffffc0202850:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202852:	4601                	li	a2,0
{
ffffffffc0202854:	ec26                	sd	s1,24(sp)
ffffffffc0202856:	f406                	sd	ra,40(sp)
ffffffffc0202858:	f022                	sd	s0,32(sp)
ffffffffc020285a:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020285c:	9a1ff0ef          	jal	ra,ffffffffc02021fc <get_pte>
    if (ptep != NULL)
ffffffffc0202860:	c511                	beqz	a0,ffffffffc020286c <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202862:	611c                	ld	a5,0(a0)
ffffffffc0202864:	842a                	mv	s0,a0
ffffffffc0202866:	0017f713          	andi	a4,a5,1
ffffffffc020286a:	e711                	bnez	a4,ffffffffc0202876 <page_remove+0x26>
}
ffffffffc020286c:	70a2                	ld	ra,40(sp)
ffffffffc020286e:	7402                	ld	s0,32(sp)
ffffffffc0202870:	64e2                	ld	s1,24(sp)
ffffffffc0202872:	6145                	addi	sp,sp,48
ffffffffc0202874:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202876:	078a                	slli	a5,a5,0x2
ffffffffc0202878:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020287a:	000be717          	auipc	a4,0xbe
ffffffffc020287e:	8a673703          	ld	a4,-1882(a4) # ffffffffc02c0120 <npage>
ffffffffc0202882:	06e7f363          	bgeu	a5,a4,ffffffffc02028e8 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202886:	fff80537          	lui	a0,0xfff80
ffffffffc020288a:	97aa                	add	a5,a5,a0
ffffffffc020288c:	079a                	slli	a5,a5,0x6
ffffffffc020288e:	000be517          	auipc	a0,0xbe
ffffffffc0202892:	89a53503          	ld	a0,-1894(a0) # ffffffffc02c0128 <pages>
ffffffffc0202896:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202898:	411c                	lw	a5,0(a0)
ffffffffc020289a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020289e:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02028a0:	cb11                	beqz	a4,ffffffffc02028b4 <page_remove+0x64>
        *ptep = 0;
ffffffffc02028a2:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02028a6:	12048073          	sfence.vma	s1
}
ffffffffc02028aa:	70a2                	ld	ra,40(sp)
ffffffffc02028ac:	7402                	ld	s0,32(sp)
ffffffffc02028ae:	64e2                	ld	s1,24(sp)
ffffffffc02028b0:	6145                	addi	sp,sp,48
ffffffffc02028b2:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02028b4:	100027f3          	csrr	a5,sstatus
ffffffffc02028b8:	8b89                	andi	a5,a5,2
ffffffffc02028ba:	eb89                	bnez	a5,ffffffffc02028cc <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc02028bc:	000be797          	auipc	a5,0xbe
ffffffffc02028c0:	8747b783          	ld	a5,-1932(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02028c4:	739c                	ld	a5,32(a5)
ffffffffc02028c6:	4585                	li	a1,1
ffffffffc02028c8:	9782                	jalr	a5
    if (flag)
ffffffffc02028ca:	bfe1                	j	ffffffffc02028a2 <page_remove+0x52>
        intr_disable();
ffffffffc02028cc:	e42a                	sd	a0,8(sp)
ffffffffc02028ce:	8e6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02028d2:	000be797          	auipc	a5,0xbe
ffffffffc02028d6:	85e7b783          	ld	a5,-1954(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02028da:	739c                	ld	a5,32(a5)
ffffffffc02028dc:	6522                	ld	a0,8(sp)
ffffffffc02028de:	4585                	li	a1,1
ffffffffc02028e0:	9782                	jalr	a5
        intr_enable();
ffffffffc02028e2:	8ccfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02028e6:	bf75                	j	ffffffffc02028a2 <page_remove+0x52>
ffffffffc02028e8:	825ff0ef          	jal	ra,ffffffffc020210c <pa2page.part.0>

ffffffffc02028ec <page_insert>:
{
ffffffffc02028ec:	7139                	addi	sp,sp,-64
ffffffffc02028ee:	e852                	sd	s4,16(sp)
ffffffffc02028f0:	8a32                	mv	s4,a2
ffffffffc02028f2:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02028f4:	4605                	li	a2,1
{
ffffffffc02028f6:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02028f8:	85d2                	mv	a1,s4
{
ffffffffc02028fa:	f426                	sd	s1,40(sp)
ffffffffc02028fc:	fc06                	sd	ra,56(sp)
ffffffffc02028fe:	f04a                	sd	s2,32(sp)
ffffffffc0202900:	ec4e                	sd	s3,24(sp)
ffffffffc0202902:	e456                	sd	s5,8(sp)
ffffffffc0202904:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202906:	8f7ff0ef          	jal	ra,ffffffffc02021fc <get_pte>
    if (ptep == NULL)
ffffffffc020290a:	c961                	beqz	a0,ffffffffc02029da <page_insert+0xee>
    page->ref += 1;
ffffffffc020290c:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc020290e:	611c                	ld	a5,0(a0)
ffffffffc0202910:	89aa                	mv	s3,a0
ffffffffc0202912:	0016871b          	addiw	a4,a3,1
ffffffffc0202916:	c018                	sw	a4,0(s0)
ffffffffc0202918:	0017f713          	andi	a4,a5,1
ffffffffc020291c:	ef05                	bnez	a4,ffffffffc0202954 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc020291e:	000be717          	auipc	a4,0xbe
ffffffffc0202922:	80a73703          	ld	a4,-2038(a4) # ffffffffc02c0128 <pages>
ffffffffc0202926:	8c19                	sub	s0,s0,a4
ffffffffc0202928:	000807b7          	lui	a5,0x80
ffffffffc020292c:	8419                	srai	s0,s0,0x6
ffffffffc020292e:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202930:	042a                	slli	s0,s0,0xa
ffffffffc0202932:	8cc1                	or	s1,s1,s0
ffffffffc0202934:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202938:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_dirtycow_test_out_size+0xffffffffbfff4de0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020293c:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202940:	4501                	li	a0,0
}
ffffffffc0202942:	70e2                	ld	ra,56(sp)
ffffffffc0202944:	7442                	ld	s0,48(sp)
ffffffffc0202946:	74a2                	ld	s1,40(sp)
ffffffffc0202948:	7902                	ld	s2,32(sp)
ffffffffc020294a:	69e2                	ld	s3,24(sp)
ffffffffc020294c:	6a42                	ld	s4,16(sp)
ffffffffc020294e:	6aa2                	ld	s5,8(sp)
ffffffffc0202950:	6121                	addi	sp,sp,64
ffffffffc0202952:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202954:	078a                	slli	a5,a5,0x2
ffffffffc0202956:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202958:	000bd717          	auipc	a4,0xbd
ffffffffc020295c:	7c873703          	ld	a4,1992(a4) # ffffffffc02c0120 <npage>
ffffffffc0202960:	06e7ff63          	bgeu	a5,a4,ffffffffc02029de <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202964:	000bda97          	auipc	s5,0xbd
ffffffffc0202968:	7c4a8a93          	addi	s5,s5,1988 # ffffffffc02c0128 <pages>
ffffffffc020296c:	000ab703          	ld	a4,0(s5)
ffffffffc0202970:	fff80937          	lui	s2,0xfff80
ffffffffc0202974:	993e                	add	s2,s2,a5
ffffffffc0202976:	091a                	slli	s2,s2,0x6
ffffffffc0202978:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc020297a:	01240c63          	beq	s0,s2,ffffffffc0202992 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc020297e:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcbfea4>
ffffffffc0202982:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202986:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc020298a:	c691                	beqz	a3,ffffffffc0202996 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020298c:	120a0073          	sfence.vma	s4
}
ffffffffc0202990:	bf59                	j	ffffffffc0202926 <page_insert+0x3a>
ffffffffc0202992:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202994:	bf49                	j	ffffffffc0202926 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202996:	100027f3          	csrr	a5,sstatus
ffffffffc020299a:	8b89                	andi	a5,a5,2
ffffffffc020299c:	ef91                	bnez	a5,ffffffffc02029b8 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc020299e:	000bd797          	auipc	a5,0xbd
ffffffffc02029a2:	7927b783          	ld	a5,1938(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02029a6:	739c                	ld	a5,32(a5)
ffffffffc02029a8:	4585                	li	a1,1
ffffffffc02029aa:	854a                	mv	a0,s2
ffffffffc02029ac:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02029ae:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02029b2:	120a0073          	sfence.vma	s4
ffffffffc02029b6:	bf85                	j	ffffffffc0202926 <page_insert+0x3a>
        intr_disable();
ffffffffc02029b8:	ffdfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02029bc:	000bd797          	auipc	a5,0xbd
ffffffffc02029c0:	7747b783          	ld	a5,1908(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02029c4:	739c                	ld	a5,32(a5)
ffffffffc02029c6:	4585                	li	a1,1
ffffffffc02029c8:	854a                	mv	a0,s2
ffffffffc02029ca:	9782                	jalr	a5
        intr_enable();
ffffffffc02029cc:	fe3fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02029d0:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02029d4:	120a0073          	sfence.vma	s4
ffffffffc02029d8:	b7b9                	j	ffffffffc0202926 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc02029da:	5571                	li	a0,-4
ffffffffc02029dc:	b79d                	j	ffffffffc0202942 <page_insert+0x56>
ffffffffc02029de:	f2eff0ef          	jal	ra,ffffffffc020210c <pa2page.part.0>

ffffffffc02029e2 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02029e2:	00004797          	auipc	a5,0x4
ffffffffc02029e6:	ef678793          	addi	a5,a5,-266 # ffffffffc02068d8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02029ea:	638c                	ld	a1,0(a5)
{
ffffffffc02029ec:	7159                	addi	sp,sp,-112
ffffffffc02029ee:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02029f0:	00004517          	auipc	a0,0x4
ffffffffc02029f4:	03850513          	addi	a0,a0,56 # ffffffffc0206a28 <default_pmm_manager+0x150>
    pmm_manager = &default_pmm_manager;
ffffffffc02029f8:	000bdb17          	auipc	s6,0xbd
ffffffffc02029fc:	738b0b13          	addi	s6,s6,1848 # ffffffffc02c0130 <pmm_manager>
{
ffffffffc0202a00:	f486                	sd	ra,104(sp)
ffffffffc0202a02:	e8ca                	sd	s2,80(sp)
ffffffffc0202a04:	e4ce                	sd	s3,72(sp)
ffffffffc0202a06:	f0a2                	sd	s0,96(sp)
ffffffffc0202a08:	eca6                	sd	s1,88(sp)
ffffffffc0202a0a:	e0d2                	sd	s4,64(sp)
ffffffffc0202a0c:	fc56                	sd	s5,56(sp)
ffffffffc0202a0e:	f45e                	sd	s7,40(sp)
ffffffffc0202a10:	f062                	sd	s8,32(sp)
ffffffffc0202a12:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202a14:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202a18:	f7cfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202a1c:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202a20:	000bd997          	auipc	s3,0xbd
ffffffffc0202a24:	71898993          	addi	s3,s3,1816 # ffffffffc02c0138 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202a28:	679c                	ld	a5,8(a5)
ffffffffc0202a2a:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202a2c:	57f5                	li	a5,-3
ffffffffc0202a2e:	07fa                	slli	a5,a5,0x1e
ffffffffc0202a30:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202a34:	f67fd0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc0202a38:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc0202a3a:	f6bfd0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202a3e:	200505e3          	beqz	a0,ffffffffc0203448 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202a42:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202a44:	00004517          	auipc	a0,0x4
ffffffffc0202a48:	01c50513          	addi	a0,a0,28 # ffffffffc0206a60 <default_pmm_manager+0x188>
ffffffffc0202a4c:	f48fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202a50:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202a54:	fff40693          	addi	a3,s0,-1
ffffffffc0202a58:	864a                	mv	a2,s2
ffffffffc0202a5a:	85a6                	mv	a1,s1
ffffffffc0202a5c:	00004517          	auipc	a0,0x4
ffffffffc0202a60:	01c50513          	addi	a0,a0,28 # ffffffffc0206a78 <default_pmm_manager+0x1a0>
ffffffffc0202a64:	f30fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202a68:	c8000737          	lui	a4,0xc8000
ffffffffc0202a6c:	87a2                	mv	a5,s0
ffffffffc0202a6e:	54876163          	bltu	a4,s0,ffffffffc0202fb0 <pmm_init+0x5ce>
ffffffffc0202a72:	757d                	lui	a0,0xfffff
ffffffffc0202a74:	000be617          	auipc	a2,0xbe
ffffffffc0202a78:	6e760613          	addi	a2,a2,1767 # ffffffffc02c115b <end+0xfff>
ffffffffc0202a7c:	8e69                	and	a2,a2,a0
ffffffffc0202a7e:	000bd497          	auipc	s1,0xbd
ffffffffc0202a82:	6a248493          	addi	s1,s1,1698 # ffffffffc02c0120 <npage>
ffffffffc0202a86:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a8a:	000bdb97          	auipc	s7,0xbd
ffffffffc0202a8e:	69eb8b93          	addi	s7,s7,1694 # ffffffffc02c0128 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202a92:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a94:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a98:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a9c:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a9e:	02f50863          	beq	a0,a5,ffffffffc0202ace <pmm_init+0xec>
ffffffffc0202aa2:	4781                	li	a5,0
ffffffffc0202aa4:	4585                	li	a1,1
ffffffffc0202aa6:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202aaa:	00679513          	slli	a0,a5,0x6
ffffffffc0202aae:	9532                	add	a0,a0,a2
ffffffffc0202ab0:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd3eeac>
ffffffffc0202ab4:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202ab8:	6088                	ld	a0,0(s1)
ffffffffc0202aba:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202abc:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202ac0:	00d50733          	add	a4,a0,a3
ffffffffc0202ac4:	fee7e3e3          	bltu	a5,a4,ffffffffc0202aaa <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202ac8:	071a                	slli	a4,a4,0x6
ffffffffc0202aca:	00e606b3          	add	a3,a2,a4
ffffffffc0202ace:	c02007b7          	lui	a5,0xc0200
ffffffffc0202ad2:	2ef6ece3          	bltu	a3,a5,ffffffffc02035ca <pmm_init+0xbe8>
ffffffffc0202ad6:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202ada:	77fd                	lui	a5,0xfffff
ffffffffc0202adc:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202ade:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202ae0:	5086eb63          	bltu	a3,s0,ffffffffc0202ff6 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202ae4:	00004517          	auipc	a0,0x4
ffffffffc0202ae8:	fbc50513          	addi	a0,a0,-68 # ffffffffc0206aa0 <default_pmm_manager+0x1c8>
ffffffffc0202aec:	ea8fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202af0:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202af4:	000bd917          	auipc	s2,0xbd
ffffffffc0202af8:	62490913          	addi	s2,s2,1572 # ffffffffc02c0118 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202afc:	7b9c                	ld	a5,48(a5)
ffffffffc0202afe:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202b00:	00004517          	auipc	a0,0x4
ffffffffc0202b04:	fb850513          	addi	a0,a0,-72 # ffffffffc0206ab8 <default_pmm_manager+0x1e0>
ffffffffc0202b08:	e8cfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202b0c:	00007697          	auipc	a3,0x7
ffffffffc0202b10:	4f468693          	addi	a3,a3,1268 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202b14:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202b18:	c02007b7          	lui	a5,0xc0200
ffffffffc0202b1c:	28f6ebe3          	bltu	a3,a5,ffffffffc02035b2 <pmm_init+0xbd0>
ffffffffc0202b20:	0009b783          	ld	a5,0(s3)
ffffffffc0202b24:	8e9d                	sub	a3,a3,a5
ffffffffc0202b26:	000bd797          	auipc	a5,0xbd
ffffffffc0202b2a:	5ed7b523          	sd	a3,1514(a5) # ffffffffc02c0110 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202b2e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b32:	8b89                	andi	a5,a5,2
ffffffffc0202b34:	4a079763          	bnez	a5,ffffffffc0202fe2 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b38:	000b3783          	ld	a5,0(s6)
ffffffffc0202b3c:	779c                	ld	a5,40(a5)
ffffffffc0202b3e:	9782                	jalr	a5
ffffffffc0202b40:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202b42:	6098                	ld	a4,0(s1)
ffffffffc0202b44:	c80007b7          	lui	a5,0xc8000
ffffffffc0202b48:	83b1                	srli	a5,a5,0xc
ffffffffc0202b4a:	66e7e363          	bltu	a5,a4,ffffffffc02031b0 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202b4e:	00093503          	ld	a0,0(s2)
ffffffffc0202b52:	62050f63          	beqz	a0,ffffffffc0203190 <pmm_init+0x7ae>
ffffffffc0202b56:	03451793          	slli	a5,a0,0x34
ffffffffc0202b5a:	62079b63          	bnez	a5,ffffffffc0203190 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202b5e:	4601                	li	a2,0
ffffffffc0202b60:	4581                	li	a1,0
ffffffffc0202b62:	8c3ff0ef          	jal	ra,ffffffffc0202424 <get_page>
ffffffffc0202b66:	60051563          	bnez	a0,ffffffffc0203170 <pmm_init+0x78e>
ffffffffc0202b6a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b6e:	8b89                	andi	a5,a5,2
ffffffffc0202b70:	44079e63          	bnez	a5,ffffffffc0202fcc <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b74:	000b3783          	ld	a5,0(s6)
ffffffffc0202b78:	4505                	li	a0,1
ffffffffc0202b7a:	6f9c                	ld	a5,24(a5)
ffffffffc0202b7c:	9782                	jalr	a5
ffffffffc0202b7e:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202b80:	00093503          	ld	a0,0(s2)
ffffffffc0202b84:	4681                	li	a3,0
ffffffffc0202b86:	4601                	li	a2,0
ffffffffc0202b88:	85d2                	mv	a1,s4
ffffffffc0202b8a:	d63ff0ef          	jal	ra,ffffffffc02028ec <page_insert>
ffffffffc0202b8e:	26051ae3          	bnez	a0,ffffffffc0203602 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202b92:	00093503          	ld	a0,0(s2)
ffffffffc0202b96:	4601                	li	a2,0
ffffffffc0202b98:	4581                	li	a1,0
ffffffffc0202b9a:	e62ff0ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc0202b9e:	240502e3          	beqz	a0,ffffffffc02035e2 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202ba2:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202ba4:	0017f713          	andi	a4,a5,1
ffffffffc0202ba8:	5a070263          	beqz	a4,ffffffffc020314c <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202bac:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202bae:	078a                	slli	a5,a5,0x2
ffffffffc0202bb0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bb2:	58e7fb63          	bgeu	a5,a4,ffffffffc0203148 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bb6:	000bb683          	ld	a3,0(s7)
ffffffffc0202bba:	fff80637          	lui	a2,0xfff80
ffffffffc0202bbe:	97b2                	add	a5,a5,a2
ffffffffc0202bc0:	079a                	slli	a5,a5,0x6
ffffffffc0202bc2:	97b6                	add	a5,a5,a3
ffffffffc0202bc4:	14fa17e3          	bne	s4,a5,ffffffffc0203512 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202bc8:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0202bcc:	4785                	li	a5,1
ffffffffc0202bce:	12f692e3          	bne	a3,a5,ffffffffc02034f2 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202bd2:	00093503          	ld	a0,0(s2)
ffffffffc0202bd6:	77fd                	lui	a5,0xfffff
ffffffffc0202bd8:	6114                	ld	a3,0(a0)
ffffffffc0202bda:	068a                	slli	a3,a3,0x2
ffffffffc0202bdc:	8efd                	and	a3,a3,a5
ffffffffc0202bde:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202be2:	0ee67ce3          	bgeu	a2,a4,ffffffffc02034da <pmm_init+0xaf8>
ffffffffc0202be6:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202bea:	96e2                	add	a3,a3,s8
ffffffffc0202bec:	0006ba83          	ld	s5,0(a3)
ffffffffc0202bf0:	0a8a                	slli	s5,s5,0x2
ffffffffc0202bf2:	00fafab3          	and	s5,s5,a5
ffffffffc0202bf6:	00cad793          	srli	a5,s5,0xc
ffffffffc0202bfa:	0ce7f3e3          	bgeu	a5,a4,ffffffffc02034c0 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202bfe:	4601                	li	a2,0
ffffffffc0202c00:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202c02:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202c04:	df8ff0ef          	jal	ra,ffffffffc02021fc <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202c08:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202c0a:	55551363          	bne	a0,s5,ffffffffc0203150 <pmm_init+0x76e>
ffffffffc0202c0e:	100027f3          	csrr	a5,sstatus
ffffffffc0202c12:	8b89                	andi	a5,a5,2
ffffffffc0202c14:	3a079163          	bnez	a5,ffffffffc0202fb6 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c18:	000b3783          	ld	a5,0(s6)
ffffffffc0202c1c:	4505                	li	a0,1
ffffffffc0202c1e:	6f9c                	ld	a5,24(a5)
ffffffffc0202c20:	9782                	jalr	a5
ffffffffc0202c22:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202c24:	00093503          	ld	a0,0(s2)
ffffffffc0202c28:	46d1                	li	a3,20
ffffffffc0202c2a:	6605                	lui	a2,0x1
ffffffffc0202c2c:	85e2                	mv	a1,s8
ffffffffc0202c2e:	cbfff0ef          	jal	ra,ffffffffc02028ec <page_insert>
ffffffffc0202c32:	060517e3          	bnez	a0,ffffffffc02034a0 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202c36:	00093503          	ld	a0,0(s2)
ffffffffc0202c3a:	4601                	li	a2,0
ffffffffc0202c3c:	6585                	lui	a1,0x1
ffffffffc0202c3e:	dbeff0ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc0202c42:	02050fe3          	beqz	a0,ffffffffc0203480 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc0202c46:	611c                	ld	a5,0(a0)
ffffffffc0202c48:	0107f713          	andi	a4,a5,16
ffffffffc0202c4c:	7c070e63          	beqz	a4,ffffffffc0203428 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0202c50:	8b91                	andi	a5,a5,4
ffffffffc0202c52:	7a078b63          	beqz	a5,ffffffffc0203408 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202c56:	00093503          	ld	a0,0(s2)
ffffffffc0202c5a:	611c                	ld	a5,0(a0)
ffffffffc0202c5c:	8bc1                	andi	a5,a5,16
ffffffffc0202c5e:	78078563          	beqz	a5,ffffffffc02033e8 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0202c62:	000c2703          	lw	a4,0(s8)
ffffffffc0202c66:	4785                	li	a5,1
ffffffffc0202c68:	76f71063          	bne	a4,a5,ffffffffc02033c8 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202c6c:	4681                	li	a3,0
ffffffffc0202c6e:	6605                	lui	a2,0x1
ffffffffc0202c70:	85d2                	mv	a1,s4
ffffffffc0202c72:	c7bff0ef          	jal	ra,ffffffffc02028ec <page_insert>
ffffffffc0202c76:	72051963          	bnez	a0,ffffffffc02033a8 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0202c7a:	000a2703          	lw	a4,0(s4)
ffffffffc0202c7e:	4789                	li	a5,2
ffffffffc0202c80:	70f71463          	bne	a4,a5,ffffffffc0203388 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202c84:	000c2783          	lw	a5,0(s8)
ffffffffc0202c88:	6e079063          	bnez	a5,ffffffffc0203368 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202c8c:	00093503          	ld	a0,0(s2)
ffffffffc0202c90:	4601                	li	a2,0
ffffffffc0202c92:	6585                	lui	a1,0x1
ffffffffc0202c94:	d68ff0ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc0202c98:	6a050863          	beqz	a0,ffffffffc0203348 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202c9c:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202c9e:	00177793          	andi	a5,a4,1
ffffffffc0202ca2:	4a078563          	beqz	a5,ffffffffc020314c <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202ca6:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202ca8:	00271793          	slli	a5,a4,0x2
ffffffffc0202cac:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cae:	48d7fd63          	bgeu	a5,a3,ffffffffc0203148 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cb2:	000bb683          	ld	a3,0(s7)
ffffffffc0202cb6:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202cba:	97d6                	add	a5,a5,s5
ffffffffc0202cbc:	079a                	slli	a5,a5,0x6
ffffffffc0202cbe:	97b6                	add	a5,a5,a3
ffffffffc0202cc0:	66fa1463          	bne	s4,a5,ffffffffc0203328 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202cc4:	8b41                	andi	a4,a4,16
ffffffffc0202cc6:	64071163          	bnez	a4,ffffffffc0203308 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202cca:	00093503          	ld	a0,0(s2)
ffffffffc0202cce:	4581                	li	a1,0
ffffffffc0202cd0:	b81ff0ef          	jal	ra,ffffffffc0202850 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202cd4:	000a2c83          	lw	s9,0(s4)
ffffffffc0202cd8:	4785                	li	a5,1
ffffffffc0202cda:	60fc9763          	bne	s9,a5,ffffffffc02032e8 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202cde:	000c2783          	lw	a5,0(s8)
ffffffffc0202ce2:	5e079363          	bnez	a5,ffffffffc02032c8 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202ce6:	00093503          	ld	a0,0(s2)
ffffffffc0202cea:	6585                	lui	a1,0x1
ffffffffc0202cec:	b65ff0ef          	jal	ra,ffffffffc0202850 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202cf0:	000a2783          	lw	a5,0(s4)
ffffffffc0202cf4:	52079a63          	bnez	a5,ffffffffc0203228 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202cf8:	000c2783          	lw	a5,0(s8)
ffffffffc0202cfc:	50079663          	bnez	a5,ffffffffc0203208 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202d00:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202d04:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d06:	000a3683          	ld	a3,0(s4)
ffffffffc0202d0a:	068a                	slli	a3,a3,0x2
ffffffffc0202d0c:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d0e:	42b6fd63          	bgeu	a3,a1,ffffffffc0203148 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d12:	000bb503          	ld	a0,0(s7)
ffffffffc0202d16:	96d6                	add	a3,a3,s5
ffffffffc0202d18:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202d1a:	00d507b3          	add	a5,a0,a3
ffffffffc0202d1e:	439c                	lw	a5,0(a5)
ffffffffc0202d20:	4d979463          	bne	a5,s9,ffffffffc02031e8 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202d24:	8699                	srai	a3,a3,0x6
ffffffffc0202d26:	00080637          	lui	a2,0x80
ffffffffc0202d2a:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202d2c:	00c69713          	slli	a4,a3,0xc
ffffffffc0202d30:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202d32:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202d34:	48b77e63          	bgeu	a4,a1,ffffffffc02031d0 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202d38:	0009b703          	ld	a4,0(s3)
ffffffffc0202d3c:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d3e:	629c                	ld	a5,0(a3)
ffffffffc0202d40:	078a                	slli	a5,a5,0x2
ffffffffc0202d42:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d44:	40b7f263          	bgeu	a5,a1,ffffffffc0203148 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d48:	8f91                	sub	a5,a5,a2
ffffffffc0202d4a:	079a                	slli	a5,a5,0x6
ffffffffc0202d4c:	953e                	add	a0,a0,a5
ffffffffc0202d4e:	100027f3          	csrr	a5,sstatus
ffffffffc0202d52:	8b89                	andi	a5,a5,2
ffffffffc0202d54:	30079963          	bnez	a5,ffffffffc0203066 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202d58:	000b3783          	ld	a5,0(s6)
ffffffffc0202d5c:	4585                	li	a1,1
ffffffffc0202d5e:	739c                	ld	a5,32(a5)
ffffffffc0202d60:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d62:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202d66:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d68:	078a                	slli	a5,a5,0x2
ffffffffc0202d6a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d6c:	3ce7fe63          	bgeu	a5,a4,ffffffffc0203148 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d70:	000bb503          	ld	a0,0(s7)
ffffffffc0202d74:	fff80737          	lui	a4,0xfff80
ffffffffc0202d78:	97ba                	add	a5,a5,a4
ffffffffc0202d7a:	079a                	slli	a5,a5,0x6
ffffffffc0202d7c:	953e                	add	a0,a0,a5
ffffffffc0202d7e:	100027f3          	csrr	a5,sstatus
ffffffffc0202d82:	8b89                	andi	a5,a5,2
ffffffffc0202d84:	2c079563          	bnez	a5,ffffffffc020304e <pmm_init+0x66c>
ffffffffc0202d88:	000b3783          	ld	a5,0(s6)
ffffffffc0202d8c:	4585                	li	a1,1
ffffffffc0202d8e:	739c                	ld	a5,32(a5)
ffffffffc0202d90:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d92:	00093783          	ld	a5,0(s2)
ffffffffc0202d96:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd3eea4>
    asm volatile("sfence.vma");
ffffffffc0202d9a:	12000073          	sfence.vma
ffffffffc0202d9e:	100027f3          	csrr	a5,sstatus
ffffffffc0202da2:	8b89                	andi	a5,a5,2
ffffffffc0202da4:	28079b63          	bnez	a5,ffffffffc020303a <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202da8:	000b3783          	ld	a5,0(s6)
ffffffffc0202dac:	779c                	ld	a5,40(a5)
ffffffffc0202dae:	9782                	jalr	a5
ffffffffc0202db0:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202db2:	4b441b63          	bne	s0,s4,ffffffffc0203268 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202db6:	00004517          	auipc	a0,0x4
ffffffffc0202dba:	02a50513          	addi	a0,a0,42 # ffffffffc0206de0 <default_pmm_manager+0x508>
ffffffffc0202dbe:	bd6fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202dc2:	100027f3          	csrr	a5,sstatus
ffffffffc0202dc6:	8b89                	andi	a5,a5,2
ffffffffc0202dc8:	24079f63          	bnez	a5,ffffffffc0203026 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202dcc:	000b3783          	ld	a5,0(s6)
ffffffffc0202dd0:	779c                	ld	a5,40(a5)
ffffffffc0202dd2:	9782                	jalr	a5
ffffffffc0202dd4:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202dd6:	6098                	ld	a4,0(s1)
ffffffffc0202dd8:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ddc:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202dde:	00c71793          	slli	a5,a4,0xc
ffffffffc0202de2:	6a05                	lui	s4,0x1
ffffffffc0202de4:	02f47c63          	bgeu	s0,a5,ffffffffc0202e1c <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202de8:	00c45793          	srli	a5,s0,0xc
ffffffffc0202dec:	00093503          	ld	a0,0(s2)
ffffffffc0202df0:	2ee7ff63          	bgeu	a5,a4,ffffffffc02030ee <pmm_init+0x70c>
ffffffffc0202df4:	0009b583          	ld	a1,0(s3)
ffffffffc0202df8:	4601                	li	a2,0
ffffffffc0202dfa:	95a2                	add	a1,a1,s0
ffffffffc0202dfc:	c00ff0ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc0202e00:	32050463          	beqz	a0,ffffffffc0203128 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202e04:	611c                	ld	a5,0(a0)
ffffffffc0202e06:	078a                	slli	a5,a5,0x2
ffffffffc0202e08:	0157f7b3          	and	a5,a5,s5
ffffffffc0202e0c:	2e879e63          	bne	a5,s0,ffffffffc0203108 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202e10:	6098                	ld	a4,0(s1)
ffffffffc0202e12:	9452                	add	s0,s0,s4
ffffffffc0202e14:	00c71793          	slli	a5,a4,0xc
ffffffffc0202e18:	fcf468e3          	bltu	s0,a5,ffffffffc0202de8 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202e1c:	00093783          	ld	a5,0(s2)
ffffffffc0202e20:	639c                	ld	a5,0(a5)
ffffffffc0202e22:	42079363          	bnez	a5,ffffffffc0203248 <pmm_init+0x866>
ffffffffc0202e26:	100027f3          	csrr	a5,sstatus
ffffffffc0202e2a:	8b89                	andi	a5,a5,2
ffffffffc0202e2c:	24079963          	bnez	a5,ffffffffc020307e <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e30:	000b3783          	ld	a5,0(s6)
ffffffffc0202e34:	4505                	li	a0,1
ffffffffc0202e36:	6f9c                	ld	a5,24(a5)
ffffffffc0202e38:	9782                	jalr	a5
ffffffffc0202e3a:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202e3c:	00093503          	ld	a0,0(s2)
ffffffffc0202e40:	4699                	li	a3,6
ffffffffc0202e42:	10000613          	li	a2,256
ffffffffc0202e46:	85d2                	mv	a1,s4
ffffffffc0202e48:	aa5ff0ef          	jal	ra,ffffffffc02028ec <page_insert>
ffffffffc0202e4c:	44051e63          	bnez	a0,ffffffffc02032a8 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202e50:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0202e54:	4785                	li	a5,1
ffffffffc0202e56:	42f71963          	bne	a4,a5,ffffffffc0203288 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202e5a:	00093503          	ld	a0,0(s2)
ffffffffc0202e5e:	6405                	lui	s0,0x1
ffffffffc0202e60:	4699                	li	a3,6
ffffffffc0202e62:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ab0>
ffffffffc0202e66:	85d2                	mv	a1,s4
ffffffffc0202e68:	a85ff0ef          	jal	ra,ffffffffc02028ec <page_insert>
ffffffffc0202e6c:	72051363          	bnez	a0,ffffffffc0203592 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202e70:	000a2703          	lw	a4,0(s4)
ffffffffc0202e74:	4789                	li	a5,2
ffffffffc0202e76:	6ef71e63          	bne	a4,a5,ffffffffc0203572 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202e7a:	00004597          	auipc	a1,0x4
ffffffffc0202e7e:	0ae58593          	addi	a1,a1,174 # ffffffffc0206f28 <default_pmm_manager+0x650>
ffffffffc0202e82:	10000513          	li	a0,256
ffffffffc0202e86:	1b7020ef          	jal	ra,ffffffffc020583c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202e8a:	10040593          	addi	a1,s0,256
ffffffffc0202e8e:	10000513          	li	a0,256
ffffffffc0202e92:	1bd020ef          	jal	ra,ffffffffc020584e <strcmp>
ffffffffc0202e96:	6a051e63          	bnez	a0,ffffffffc0203552 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202e9a:	000bb683          	ld	a3,0(s7)
ffffffffc0202e9e:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202ea2:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202ea4:	40da06b3          	sub	a3,s4,a3
ffffffffc0202ea8:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202eaa:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202eac:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202eae:	8031                	srli	s0,s0,0xc
ffffffffc0202eb0:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202eb4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202eb6:	30f77d63          	bgeu	a4,a5,ffffffffc02031d0 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202eba:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202ebe:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202ec2:	96be                	add	a3,a3,a5
ffffffffc0202ec4:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202ec8:	13f020ef          	jal	ra,ffffffffc0205806 <strlen>
ffffffffc0202ecc:	66051363          	bnez	a0,ffffffffc0203532 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202ed0:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202ed4:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ed6:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd3eea4>
ffffffffc0202eda:	068a                	slli	a3,a3,0x2
ffffffffc0202edc:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ede:	26f6f563          	bgeu	a3,a5,ffffffffc0203148 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202ee2:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ee4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202ee6:	2ef47563          	bgeu	s0,a5,ffffffffc02031d0 <pmm_init+0x7ee>
ffffffffc0202eea:	0009b403          	ld	s0,0(s3)
ffffffffc0202eee:	9436                	add	s0,s0,a3
ffffffffc0202ef0:	100027f3          	csrr	a5,sstatus
ffffffffc0202ef4:	8b89                	andi	a5,a5,2
ffffffffc0202ef6:	1e079163          	bnez	a5,ffffffffc02030d8 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202efa:	000b3783          	ld	a5,0(s6)
ffffffffc0202efe:	4585                	li	a1,1
ffffffffc0202f00:	8552                	mv	a0,s4
ffffffffc0202f02:	739c                	ld	a5,32(a5)
ffffffffc0202f04:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202f06:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202f08:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202f0a:	078a                	slli	a5,a5,0x2
ffffffffc0202f0c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202f0e:	22e7fd63          	bgeu	a5,a4,ffffffffc0203148 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202f12:	000bb503          	ld	a0,0(s7)
ffffffffc0202f16:	fff80737          	lui	a4,0xfff80
ffffffffc0202f1a:	97ba                	add	a5,a5,a4
ffffffffc0202f1c:	079a                	slli	a5,a5,0x6
ffffffffc0202f1e:	953e                	add	a0,a0,a5
ffffffffc0202f20:	100027f3          	csrr	a5,sstatus
ffffffffc0202f24:	8b89                	andi	a5,a5,2
ffffffffc0202f26:	18079d63          	bnez	a5,ffffffffc02030c0 <pmm_init+0x6de>
ffffffffc0202f2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f2e:	4585                	li	a1,1
ffffffffc0202f30:	739c                	ld	a5,32(a5)
ffffffffc0202f32:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202f34:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202f38:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202f3a:	078a                	slli	a5,a5,0x2
ffffffffc0202f3c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202f3e:	20e7f563          	bgeu	a5,a4,ffffffffc0203148 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202f42:	000bb503          	ld	a0,0(s7)
ffffffffc0202f46:	fff80737          	lui	a4,0xfff80
ffffffffc0202f4a:	97ba                	add	a5,a5,a4
ffffffffc0202f4c:	079a                	slli	a5,a5,0x6
ffffffffc0202f4e:	953e                	add	a0,a0,a5
ffffffffc0202f50:	100027f3          	csrr	a5,sstatus
ffffffffc0202f54:	8b89                	andi	a5,a5,2
ffffffffc0202f56:	14079963          	bnez	a5,ffffffffc02030a8 <pmm_init+0x6c6>
ffffffffc0202f5a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f5e:	4585                	li	a1,1
ffffffffc0202f60:	739c                	ld	a5,32(a5)
ffffffffc0202f62:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202f64:	00093783          	ld	a5,0(s2)
ffffffffc0202f68:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202f6c:	12000073          	sfence.vma
ffffffffc0202f70:	100027f3          	csrr	a5,sstatus
ffffffffc0202f74:	8b89                	andi	a5,a5,2
ffffffffc0202f76:	10079f63          	bnez	a5,ffffffffc0203094 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f7a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f7e:	779c                	ld	a5,40(a5)
ffffffffc0202f80:	9782                	jalr	a5
ffffffffc0202f82:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202f84:	4c8c1e63          	bne	s8,s0,ffffffffc0203460 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202f88:	00004517          	auipc	a0,0x4
ffffffffc0202f8c:	01850513          	addi	a0,a0,24 # ffffffffc0206fa0 <default_pmm_manager+0x6c8>
ffffffffc0202f90:	a04fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202f94:	7406                	ld	s0,96(sp)
ffffffffc0202f96:	70a6                	ld	ra,104(sp)
ffffffffc0202f98:	64e6                	ld	s1,88(sp)
ffffffffc0202f9a:	6946                	ld	s2,80(sp)
ffffffffc0202f9c:	69a6                	ld	s3,72(sp)
ffffffffc0202f9e:	6a06                	ld	s4,64(sp)
ffffffffc0202fa0:	7ae2                	ld	s5,56(sp)
ffffffffc0202fa2:	7b42                	ld	s6,48(sp)
ffffffffc0202fa4:	7ba2                	ld	s7,40(sp)
ffffffffc0202fa6:	7c02                	ld	s8,32(sp)
ffffffffc0202fa8:	6ce2                	ld	s9,24(sp)
ffffffffc0202faa:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202fac:	f97fe06f          	j	ffffffffc0201f42 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202fb0:	c80007b7          	lui	a5,0xc8000
ffffffffc0202fb4:	bc7d                	j	ffffffffc0202a72 <pmm_init+0x90>
        intr_disable();
ffffffffc0202fb6:	9fffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202fba:	000b3783          	ld	a5,0(s6)
ffffffffc0202fbe:	4505                	li	a0,1
ffffffffc0202fc0:	6f9c                	ld	a5,24(a5)
ffffffffc0202fc2:	9782                	jalr	a5
ffffffffc0202fc4:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202fc6:	9e9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fca:	b9a9                	j	ffffffffc0202c24 <pmm_init+0x242>
        intr_disable();
ffffffffc0202fcc:	9e9fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202fd0:	000b3783          	ld	a5,0(s6)
ffffffffc0202fd4:	4505                	li	a0,1
ffffffffc0202fd6:	6f9c                	ld	a5,24(a5)
ffffffffc0202fd8:	9782                	jalr	a5
ffffffffc0202fda:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202fdc:	9d3fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202fe0:	b645                	j	ffffffffc0202b80 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202fe2:	9d3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202fe6:	000b3783          	ld	a5,0(s6)
ffffffffc0202fea:	779c                	ld	a5,40(a5)
ffffffffc0202fec:	9782                	jalr	a5
ffffffffc0202fee:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202ff0:	9bffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202ff4:	b6b9                	j	ffffffffc0202b42 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202ff6:	6705                	lui	a4,0x1
ffffffffc0202ff8:	177d                	addi	a4,a4,-1
ffffffffc0202ffa:	96ba                	add	a3,a3,a4
ffffffffc0202ffc:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202ffe:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203002:	14a77363          	bgeu	a4,a0,ffffffffc0203148 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0203006:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc020300a:	fff80537          	lui	a0,0xfff80
ffffffffc020300e:	972a                	add	a4,a4,a0
ffffffffc0203010:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0203012:	8c1d                	sub	s0,s0,a5
ffffffffc0203014:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0203018:	00c45593          	srli	a1,s0,0xc
ffffffffc020301c:	9532                	add	a0,a0,a2
ffffffffc020301e:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0203020:	0009b583          	ld	a1,0(s3)
}
ffffffffc0203024:	b4c1                	j	ffffffffc0202ae4 <pmm_init+0x102>
        intr_disable();
ffffffffc0203026:	98ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020302a:	000b3783          	ld	a5,0(s6)
ffffffffc020302e:	779c                	ld	a5,40(a5)
ffffffffc0203030:	9782                	jalr	a5
ffffffffc0203032:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0203034:	97bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203038:	bb79                	j	ffffffffc0202dd6 <pmm_init+0x3f4>
        intr_disable();
ffffffffc020303a:	97bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020303e:	000b3783          	ld	a5,0(s6)
ffffffffc0203042:	779c                	ld	a5,40(a5)
ffffffffc0203044:	9782                	jalr	a5
ffffffffc0203046:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203048:	967fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020304c:	b39d                	j	ffffffffc0202db2 <pmm_init+0x3d0>
ffffffffc020304e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203050:	965fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203054:	000b3783          	ld	a5,0(s6)
ffffffffc0203058:	6522                	ld	a0,8(sp)
ffffffffc020305a:	4585                	li	a1,1
ffffffffc020305c:	739c                	ld	a5,32(a5)
ffffffffc020305e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203060:	94ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203064:	b33d                	j	ffffffffc0202d92 <pmm_init+0x3b0>
ffffffffc0203066:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203068:	94dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020306c:	000b3783          	ld	a5,0(s6)
ffffffffc0203070:	6522                	ld	a0,8(sp)
ffffffffc0203072:	4585                	li	a1,1
ffffffffc0203074:	739c                	ld	a5,32(a5)
ffffffffc0203076:	9782                	jalr	a5
        intr_enable();
ffffffffc0203078:	937fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020307c:	b1dd                	j	ffffffffc0202d62 <pmm_init+0x380>
        intr_disable();
ffffffffc020307e:	937fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203082:	000b3783          	ld	a5,0(s6)
ffffffffc0203086:	4505                	li	a0,1
ffffffffc0203088:	6f9c                	ld	a5,24(a5)
ffffffffc020308a:	9782                	jalr	a5
ffffffffc020308c:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc020308e:	921fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203092:	b36d                	j	ffffffffc0202e3c <pmm_init+0x45a>
        intr_disable();
ffffffffc0203094:	921fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203098:	000b3783          	ld	a5,0(s6)
ffffffffc020309c:	779c                	ld	a5,40(a5)
ffffffffc020309e:	9782                	jalr	a5
ffffffffc02030a0:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02030a2:	90dfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02030a6:	bdf9                	j	ffffffffc0202f84 <pmm_init+0x5a2>
ffffffffc02030a8:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02030aa:	90bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02030ae:	000b3783          	ld	a5,0(s6)
ffffffffc02030b2:	6522                	ld	a0,8(sp)
ffffffffc02030b4:	4585                	li	a1,1
ffffffffc02030b6:	739c                	ld	a5,32(a5)
ffffffffc02030b8:	9782                	jalr	a5
        intr_enable();
ffffffffc02030ba:	8f5fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02030be:	b55d                	j	ffffffffc0202f64 <pmm_init+0x582>
ffffffffc02030c0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02030c2:	8f3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02030c6:	000b3783          	ld	a5,0(s6)
ffffffffc02030ca:	6522                	ld	a0,8(sp)
ffffffffc02030cc:	4585                	li	a1,1
ffffffffc02030ce:	739c                	ld	a5,32(a5)
ffffffffc02030d0:	9782                	jalr	a5
        intr_enable();
ffffffffc02030d2:	8ddfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02030d6:	bdb9                	j	ffffffffc0202f34 <pmm_init+0x552>
        intr_disable();
ffffffffc02030d8:	8ddfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02030dc:	000b3783          	ld	a5,0(s6)
ffffffffc02030e0:	4585                	li	a1,1
ffffffffc02030e2:	8552                	mv	a0,s4
ffffffffc02030e4:	739c                	ld	a5,32(a5)
ffffffffc02030e6:	9782                	jalr	a5
        intr_enable();
ffffffffc02030e8:	8c7fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02030ec:	bd29                	j	ffffffffc0202f06 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02030ee:	86a2                	mv	a3,s0
ffffffffc02030f0:	00003617          	auipc	a2,0x3
ffffffffc02030f4:	36860613          	addi	a2,a2,872 # ffffffffc0206458 <commands+0x918>
ffffffffc02030f8:	24700593          	li	a1,583
ffffffffc02030fc:	00004517          	auipc	a0,0x4
ffffffffc0203100:	8d450513          	addi	a0,a0,-1836 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203104:	b8afd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203108:	00004697          	auipc	a3,0x4
ffffffffc020310c:	d3868693          	addi	a3,a3,-712 # ffffffffc0206e40 <default_pmm_manager+0x568>
ffffffffc0203110:	00003617          	auipc	a2,0x3
ffffffffc0203114:	41860613          	addi	a2,a2,1048 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203118:	24800593          	li	a1,584
ffffffffc020311c:	00004517          	auipc	a0,0x4
ffffffffc0203120:	8b450513          	addi	a0,a0,-1868 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203124:	b6afd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203128:	00004697          	auipc	a3,0x4
ffffffffc020312c:	cd868693          	addi	a3,a3,-808 # ffffffffc0206e00 <default_pmm_manager+0x528>
ffffffffc0203130:	00003617          	auipc	a2,0x3
ffffffffc0203134:	3f860613          	addi	a2,a2,1016 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203138:	24700593          	li	a1,583
ffffffffc020313c:	00004517          	auipc	a0,0x4
ffffffffc0203140:	89450513          	addi	a0,a0,-1900 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203144:	b4afd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203148:	fc5fe0ef          	jal	ra,ffffffffc020210c <pa2page.part.0>
ffffffffc020314c:	fddfe0ef          	jal	ra,ffffffffc0202128 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203150:	00004697          	auipc	a3,0x4
ffffffffc0203154:	aa868693          	addi	a3,a3,-1368 # ffffffffc0206bf8 <default_pmm_manager+0x320>
ffffffffc0203158:	00003617          	auipc	a2,0x3
ffffffffc020315c:	3d060613          	addi	a2,a2,976 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203160:	21700593          	li	a1,535
ffffffffc0203164:	00004517          	auipc	a0,0x4
ffffffffc0203168:	86c50513          	addi	a0,a0,-1940 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020316c:	b22fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0203170:	00004697          	auipc	a3,0x4
ffffffffc0203174:	9c868693          	addi	a3,a3,-1592 # ffffffffc0206b38 <default_pmm_manager+0x260>
ffffffffc0203178:	00003617          	auipc	a2,0x3
ffffffffc020317c:	3b060613          	addi	a2,a2,944 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203180:	20a00593          	li	a1,522
ffffffffc0203184:	00004517          	auipc	a0,0x4
ffffffffc0203188:	84c50513          	addi	a0,a0,-1972 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020318c:	b02fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0203190:	00004697          	auipc	a3,0x4
ffffffffc0203194:	96868693          	addi	a3,a3,-1688 # ffffffffc0206af8 <default_pmm_manager+0x220>
ffffffffc0203198:	00003617          	auipc	a2,0x3
ffffffffc020319c:	39060613          	addi	a2,a2,912 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02031a0:	20900593          	li	a1,521
ffffffffc02031a4:	00004517          	auipc	a0,0x4
ffffffffc02031a8:	82c50513          	addi	a0,a0,-2004 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02031ac:	ae2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02031b0:	00004697          	auipc	a3,0x4
ffffffffc02031b4:	92868693          	addi	a3,a3,-1752 # ffffffffc0206ad8 <default_pmm_manager+0x200>
ffffffffc02031b8:	00003617          	auipc	a2,0x3
ffffffffc02031bc:	37060613          	addi	a2,a2,880 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02031c0:	20800593          	li	a1,520
ffffffffc02031c4:	00004517          	auipc	a0,0x4
ffffffffc02031c8:	80c50513          	addi	a0,a0,-2036 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02031cc:	ac2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02031d0:	00003617          	auipc	a2,0x3
ffffffffc02031d4:	28860613          	addi	a2,a2,648 # ffffffffc0206458 <commands+0x918>
ffffffffc02031d8:	07100593          	li	a1,113
ffffffffc02031dc:	00003517          	auipc	a0,0x3
ffffffffc02031e0:	1cc50513          	addi	a0,a0,460 # ffffffffc02063a8 <commands+0x868>
ffffffffc02031e4:	aaafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02031e8:	00004697          	auipc	a3,0x4
ffffffffc02031ec:	ba068693          	addi	a3,a3,-1120 # ffffffffc0206d88 <default_pmm_manager+0x4b0>
ffffffffc02031f0:	00003617          	auipc	a2,0x3
ffffffffc02031f4:	33860613          	addi	a2,a2,824 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02031f8:	23000593          	li	a1,560
ffffffffc02031fc:	00003517          	auipc	a0,0x3
ffffffffc0203200:	7d450513          	addi	a0,a0,2004 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203204:	a8afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203208:	00004697          	auipc	a3,0x4
ffffffffc020320c:	b3868693          	addi	a3,a3,-1224 # ffffffffc0206d40 <default_pmm_manager+0x468>
ffffffffc0203210:	00003617          	auipc	a2,0x3
ffffffffc0203214:	31860613          	addi	a2,a2,792 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203218:	22e00593          	li	a1,558
ffffffffc020321c:	00003517          	auipc	a0,0x3
ffffffffc0203220:	7b450513          	addi	a0,a0,1972 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203224:	a6afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203228:	00004697          	auipc	a3,0x4
ffffffffc020322c:	b4868693          	addi	a3,a3,-1208 # ffffffffc0206d70 <default_pmm_manager+0x498>
ffffffffc0203230:	00003617          	auipc	a2,0x3
ffffffffc0203234:	2f860613          	addi	a2,a2,760 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203238:	22d00593          	li	a1,557
ffffffffc020323c:	00003517          	auipc	a0,0x3
ffffffffc0203240:	79450513          	addi	a0,a0,1940 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203244:	a4afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203248:	00004697          	auipc	a3,0x4
ffffffffc020324c:	c1068693          	addi	a3,a3,-1008 # ffffffffc0206e58 <default_pmm_manager+0x580>
ffffffffc0203250:	00003617          	auipc	a2,0x3
ffffffffc0203254:	2d860613          	addi	a2,a2,728 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203258:	24b00593          	li	a1,587
ffffffffc020325c:	00003517          	auipc	a0,0x3
ffffffffc0203260:	77450513          	addi	a0,a0,1908 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203264:	a2afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203268:	00004697          	auipc	a3,0x4
ffffffffc020326c:	b5068693          	addi	a3,a3,-1200 # ffffffffc0206db8 <default_pmm_manager+0x4e0>
ffffffffc0203270:	00003617          	auipc	a2,0x3
ffffffffc0203274:	2b860613          	addi	a2,a2,696 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203278:	23800593          	li	a1,568
ffffffffc020327c:	00003517          	auipc	a0,0x3
ffffffffc0203280:	75450513          	addi	a0,a0,1876 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203284:	a0afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203288:	00004697          	auipc	a3,0x4
ffffffffc020328c:	c2868693          	addi	a3,a3,-984 # ffffffffc0206eb0 <default_pmm_manager+0x5d8>
ffffffffc0203290:	00003617          	auipc	a2,0x3
ffffffffc0203294:	29860613          	addi	a2,a2,664 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203298:	25000593          	li	a1,592
ffffffffc020329c:	00003517          	auipc	a0,0x3
ffffffffc02032a0:	73450513          	addi	a0,a0,1844 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02032a4:	9eafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02032a8:	00004697          	auipc	a3,0x4
ffffffffc02032ac:	bc868693          	addi	a3,a3,-1080 # ffffffffc0206e70 <default_pmm_manager+0x598>
ffffffffc02032b0:	00003617          	auipc	a2,0x3
ffffffffc02032b4:	27860613          	addi	a2,a2,632 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02032b8:	24f00593          	li	a1,591
ffffffffc02032bc:	00003517          	auipc	a0,0x3
ffffffffc02032c0:	71450513          	addi	a0,a0,1812 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02032c4:	9cafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02032c8:	00004697          	auipc	a3,0x4
ffffffffc02032cc:	a7868693          	addi	a3,a3,-1416 # ffffffffc0206d40 <default_pmm_manager+0x468>
ffffffffc02032d0:	00003617          	auipc	a2,0x3
ffffffffc02032d4:	25860613          	addi	a2,a2,600 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02032d8:	22a00593          	li	a1,554
ffffffffc02032dc:	00003517          	auipc	a0,0x3
ffffffffc02032e0:	6f450513          	addi	a0,a0,1780 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02032e4:	9aafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02032e8:	00004697          	auipc	a3,0x4
ffffffffc02032ec:	8f868693          	addi	a3,a3,-1800 # ffffffffc0206be0 <default_pmm_manager+0x308>
ffffffffc02032f0:	00003617          	auipc	a2,0x3
ffffffffc02032f4:	23860613          	addi	a2,a2,568 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02032f8:	22900593          	li	a1,553
ffffffffc02032fc:	00003517          	auipc	a0,0x3
ffffffffc0203300:	6d450513          	addi	a0,a0,1748 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203304:	98afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203308:	00004697          	auipc	a3,0x4
ffffffffc020330c:	a5068693          	addi	a3,a3,-1456 # ffffffffc0206d58 <default_pmm_manager+0x480>
ffffffffc0203310:	00003617          	auipc	a2,0x3
ffffffffc0203314:	21860613          	addi	a2,a2,536 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203318:	22600593          	li	a1,550
ffffffffc020331c:	00003517          	auipc	a0,0x3
ffffffffc0203320:	6b450513          	addi	a0,a0,1716 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203324:	96afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203328:	00004697          	auipc	a3,0x4
ffffffffc020332c:	8a068693          	addi	a3,a3,-1888 # ffffffffc0206bc8 <default_pmm_manager+0x2f0>
ffffffffc0203330:	00003617          	auipc	a2,0x3
ffffffffc0203334:	1f860613          	addi	a2,a2,504 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203338:	22500593          	li	a1,549
ffffffffc020333c:	00003517          	auipc	a0,0x3
ffffffffc0203340:	69450513          	addi	a0,a0,1684 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203344:	94afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203348:	00004697          	auipc	a3,0x4
ffffffffc020334c:	92068693          	addi	a3,a3,-1760 # ffffffffc0206c68 <default_pmm_manager+0x390>
ffffffffc0203350:	00003617          	auipc	a2,0x3
ffffffffc0203354:	1d860613          	addi	a2,a2,472 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203358:	22400593          	li	a1,548
ffffffffc020335c:	00003517          	auipc	a0,0x3
ffffffffc0203360:	67450513          	addi	a0,a0,1652 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203364:	92afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203368:	00004697          	auipc	a3,0x4
ffffffffc020336c:	9d868693          	addi	a3,a3,-1576 # ffffffffc0206d40 <default_pmm_manager+0x468>
ffffffffc0203370:	00003617          	auipc	a2,0x3
ffffffffc0203374:	1b860613          	addi	a2,a2,440 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203378:	22300593          	li	a1,547
ffffffffc020337c:	00003517          	auipc	a0,0x3
ffffffffc0203380:	65450513          	addi	a0,a0,1620 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203384:	90afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203388:	00004697          	auipc	a3,0x4
ffffffffc020338c:	9a068693          	addi	a3,a3,-1632 # ffffffffc0206d28 <default_pmm_manager+0x450>
ffffffffc0203390:	00003617          	auipc	a2,0x3
ffffffffc0203394:	19860613          	addi	a2,a2,408 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203398:	22200593          	li	a1,546
ffffffffc020339c:	00003517          	auipc	a0,0x3
ffffffffc02033a0:	63450513          	addi	a0,a0,1588 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02033a4:	8eafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02033a8:	00004697          	auipc	a3,0x4
ffffffffc02033ac:	95068693          	addi	a3,a3,-1712 # ffffffffc0206cf8 <default_pmm_manager+0x420>
ffffffffc02033b0:	00003617          	auipc	a2,0x3
ffffffffc02033b4:	17860613          	addi	a2,a2,376 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02033b8:	22100593          	li	a1,545
ffffffffc02033bc:	00003517          	auipc	a0,0x3
ffffffffc02033c0:	61450513          	addi	a0,a0,1556 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02033c4:	8cafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02033c8:	00004697          	auipc	a3,0x4
ffffffffc02033cc:	91868693          	addi	a3,a3,-1768 # ffffffffc0206ce0 <default_pmm_manager+0x408>
ffffffffc02033d0:	00003617          	auipc	a2,0x3
ffffffffc02033d4:	15860613          	addi	a2,a2,344 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02033d8:	21f00593          	li	a1,543
ffffffffc02033dc:	00003517          	auipc	a0,0x3
ffffffffc02033e0:	5f450513          	addi	a0,a0,1524 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02033e4:	8aafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02033e8:	00004697          	auipc	a3,0x4
ffffffffc02033ec:	8d868693          	addi	a3,a3,-1832 # ffffffffc0206cc0 <default_pmm_manager+0x3e8>
ffffffffc02033f0:	00003617          	auipc	a2,0x3
ffffffffc02033f4:	13860613          	addi	a2,a2,312 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02033f8:	21e00593          	li	a1,542
ffffffffc02033fc:	00003517          	auipc	a0,0x3
ffffffffc0203400:	5d450513          	addi	a0,a0,1492 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203404:	88afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203408:	00004697          	auipc	a3,0x4
ffffffffc020340c:	8a868693          	addi	a3,a3,-1880 # ffffffffc0206cb0 <default_pmm_manager+0x3d8>
ffffffffc0203410:	00003617          	auipc	a2,0x3
ffffffffc0203414:	11860613          	addi	a2,a2,280 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203418:	21d00593          	li	a1,541
ffffffffc020341c:	00003517          	auipc	a0,0x3
ffffffffc0203420:	5b450513          	addi	a0,a0,1460 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203424:	86afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203428:	00004697          	auipc	a3,0x4
ffffffffc020342c:	87868693          	addi	a3,a3,-1928 # ffffffffc0206ca0 <default_pmm_manager+0x3c8>
ffffffffc0203430:	00003617          	auipc	a2,0x3
ffffffffc0203434:	0f860613          	addi	a2,a2,248 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203438:	21c00593          	li	a1,540
ffffffffc020343c:	00003517          	auipc	a0,0x3
ffffffffc0203440:	59450513          	addi	a0,a0,1428 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203444:	84afd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc0203448:	00003617          	auipc	a2,0x3
ffffffffc020344c:	5f860613          	addi	a2,a2,1528 # ffffffffc0206a40 <default_pmm_manager+0x168>
ffffffffc0203450:	06500593          	li	a1,101
ffffffffc0203454:	00003517          	auipc	a0,0x3
ffffffffc0203458:	57c50513          	addi	a0,a0,1404 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020345c:	832fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203460:	00004697          	auipc	a3,0x4
ffffffffc0203464:	95868693          	addi	a3,a3,-1704 # ffffffffc0206db8 <default_pmm_manager+0x4e0>
ffffffffc0203468:	00003617          	auipc	a2,0x3
ffffffffc020346c:	0c060613          	addi	a2,a2,192 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203470:	26200593          	li	a1,610
ffffffffc0203474:	00003517          	auipc	a0,0x3
ffffffffc0203478:	55c50513          	addi	a0,a0,1372 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020347c:	812fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203480:	00003697          	auipc	a3,0x3
ffffffffc0203484:	7e868693          	addi	a3,a3,2024 # ffffffffc0206c68 <default_pmm_manager+0x390>
ffffffffc0203488:	00003617          	auipc	a2,0x3
ffffffffc020348c:	0a060613          	addi	a2,a2,160 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203490:	21b00593          	li	a1,539
ffffffffc0203494:	00003517          	auipc	a0,0x3
ffffffffc0203498:	53c50513          	addi	a0,a0,1340 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020349c:	ff3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02034a0:	00003697          	auipc	a3,0x3
ffffffffc02034a4:	78868693          	addi	a3,a3,1928 # ffffffffc0206c28 <default_pmm_manager+0x350>
ffffffffc02034a8:	00003617          	auipc	a2,0x3
ffffffffc02034ac:	08060613          	addi	a2,a2,128 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02034b0:	21a00593          	li	a1,538
ffffffffc02034b4:	00003517          	auipc	a0,0x3
ffffffffc02034b8:	51c50513          	addi	a0,a0,1308 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02034bc:	fd3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02034c0:	86d6                	mv	a3,s5
ffffffffc02034c2:	00003617          	auipc	a2,0x3
ffffffffc02034c6:	f9660613          	addi	a2,a2,-106 # ffffffffc0206458 <commands+0x918>
ffffffffc02034ca:	21600593          	li	a1,534
ffffffffc02034ce:	00003517          	auipc	a0,0x3
ffffffffc02034d2:	50250513          	addi	a0,a0,1282 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02034d6:	fb9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02034da:	00003617          	auipc	a2,0x3
ffffffffc02034de:	f7e60613          	addi	a2,a2,-130 # ffffffffc0206458 <commands+0x918>
ffffffffc02034e2:	21500593          	li	a1,533
ffffffffc02034e6:	00003517          	auipc	a0,0x3
ffffffffc02034ea:	4ea50513          	addi	a0,a0,1258 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02034ee:	fa1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02034f2:	00003697          	auipc	a3,0x3
ffffffffc02034f6:	6ee68693          	addi	a3,a3,1774 # ffffffffc0206be0 <default_pmm_manager+0x308>
ffffffffc02034fa:	00003617          	auipc	a2,0x3
ffffffffc02034fe:	02e60613          	addi	a2,a2,46 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203502:	21300593          	li	a1,531
ffffffffc0203506:	00003517          	auipc	a0,0x3
ffffffffc020350a:	4ca50513          	addi	a0,a0,1226 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020350e:	f81fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203512:	00003697          	auipc	a3,0x3
ffffffffc0203516:	6b668693          	addi	a3,a3,1718 # ffffffffc0206bc8 <default_pmm_manager+0x2f0>
ffffffffc020351a:	00003617          	auipc	a2,0x3
ffffffffc020351e:	00e60613          	addi	a2,a2,14 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203522:	21200593          	li	a1,530
ffffffffc0203526:	00003517          	auipc	a0,0x3
ffffffffc020352a:	4aa50513          	addi	a0,a0,1194 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020352e:	f61fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203532:	00004697          	auipc	a3,0x4
ffffffffc0203536:	a4668693          	addi	a3,a3,-1466 # ffffffffc0206f78 <default_pmm_manager+0x6a0>
ffffffffc020353a:	00003617          	auipc	a2,0x3
ffffffffc020353e:	fee60613          	addi	a2,a2,-18 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203542:	25900593          	li	a1,601
ffffffffc0203546:	00003517          	auipc	a0,0x3
ffffffffc020354a:	48a50513          	addi	a0,a0,1162 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020354e:	f41fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203552:	00004697          	auipc	a3,0x4
ffffffffc0203556:	9ee68693          	addi	a3,a3,-1554 # ffffffffc0206f40 <default_pmm_manager+0x668>
ffffffffc020355a:	00003617          	auipc	a2,0x3
ffffffffc020355e:	fce60613          	addi	a2,a2,-50 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203562:	25600593          	li	a1,598
ffffffffc0203566:	00003517          	auipc	a0,0x3
ffffffffc020356a:	46a50513          	addi	a0,a0,1130 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020356e:	f21fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203572:	00004697          	auipc	a3,0x4
ffffffffc0203576:	99e68693          	addi	a3,a3,-1634 # ffffffffc0206f10 <default_pmm_manager+0x638>
ffffffffc020357a:	00003617          	auipc	a2,0x3
ffffffffc020357e:	fae60613          	addi	a2,a2,-82 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203582:	25200593          	li	a1,594
ffffffffc0203586:	00003517          	auipc	a0,0x3
ffffffffc020358a:	44a50513          	addi	a0,a0,1098 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020358e:	f01fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203592:	00004697          	auipc	a3,0x4
ffffffffc0203596:	93668693          	addi	a3,a3,-1738 # ffffffffc0206ec8 <default_pmm_manager+0x5f0>
ffffffffc020359a:	00003617          	auipc	a2,0x3
ffffffffc020359e:	f8e60613          	addi	a2,a2,-114 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02035a2:	25100593          	li	a1,593
ffffffffc02035a6:	00003517          	auipc	a0,0x3
ffffffffc02035aa:	42a50513          	addi	a0,a0,1066 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02035ae:	ee1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02035b2:	00003617          	auipc	a2,0x3
ffffffffc02035b6:	3ce60613          	addi	a2,a2,974 # ffffffffc0206980 <default_pmm_manager+0xa8>
ffffffffc02035ba:	0c900593          	li	a1,201
ffffffffc02035be:	00003517          	auipc	a0,0x3
ffffffffc02035c2:	41250513          	addi	a0,a0,1042 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02035c6:	ec9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02035ca:	00003617          	auipc	a2,0x3
ffffffffc02035ce:	3b660613          	addi	a2,a2,950 # ffffffffc0206980 <default_pmm_manager+0xa8>
ffffffffc02035d2:	08100593          	li	a1,129
ffffffffc02035d6:	00003517          	auipc	a0,0x3
ffffffffc02035da:	3fa50513          	addi	a0,a0,1018 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02035de:	eb1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02035e2:	00003697          	auipc	a3,0x3
ffffffffc02035e6:	5b668693          	addi	a3,a3,1462 # ffffffffc0206b98 <default_pmm_manager+0x2c0>
ffffffffc02035ea:	00003617          	auipc	a2,0x3
ffffffffc02035ee:	f3e60613          	addi	a2,a2,-194 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02035f2:	21100593          	li	a1,529
ffffffffc02035f6:	00003517          	auipc	a0,0x3
ffffffffc02035fa:	3da50513          	addi	a0,a0,986 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02035fe:	e91fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203602:	00003697          	auipc	a3,0x3
ffffffffc0203606:	56668693          	addi	a3,a3,1382 # ffffffffc0206b68 <default_pmm_manager+0x290>
ffffffffc020360a:	00003617          	auipc	a2,0x3
ffffffffc020360e:	f1e60613          	addi	a2,a2,-226 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203612:	20e00593          	li	a1,526
ffffffffc0203616:	00003517          	auipc	a0,0x3
ffffffffc020361a:	3ba50513          	addi	a0,a0,954 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc020361e:	e71fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203622 <copy_range>:
{
ffffffffc0203622:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203624:	00d66733          	or	a4,a2,a3
{
ffffffffc0203628:	f486                	sd	ra,104(sp)
ffffffffc020362a:	f0a2                	sd	s0,96(sp)
ffffffffc020362c:	eca6                	sd	s1,88(sp)
ffffffffc020362e:	e8ca                	sd	s2,80(sp)
ffffffffc0203630:	e4ce                	sd	s3,72(sp)
ffffffffc0203632:	e0d2                	sd	s4,64(sp)
ffffffffc0203634:	fc56                	sd	s5,56(sp)
ffffffffc0203636:	f85a                	sd	s6,48(sp)
ffffffffc0203638:	f45e                	sd	s7,40(sp)
ffffffffc020363a:	f062                	sd	s8,32(sp)
ffffffffc020363c:	ec66                	sd	s9,24(sp)
ffffffffc020363e:	e86a                	sd	s10,16(sp)
ffffffffc0203640:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203642:	1752                	slli	a4,a4,0x34
ffffffffc0203644:	1a071163          	bnez	a4,ffffffffc02037e6 <copy_range+0x1c4>
    assert(USER_ACCESS(start, end));
ffffffffc0203648:	00200737          	lui	a4,0x200
ffffffffc020364c:	8db2                	mv	s11,a2
ffffffffc020364e:	12e66463          	bltu	a2,a4,ffffffffc0203776 <copy_range+0x154>
ffffffffc0203652:	84b6                	mv	s1,a3
ffffffffc0203654:	12d67163          	bgeu	a2,a3,ffffffffc0203776 <copy_range+0x154>
ffffffffc0203658:	4705                	li	a4,1
ffffffffc020365a:	077e                	slli	a4,a4,0x1f
ffffffffc020365c:	10d76d63          	bltu	a4,a3,ffffffffc0203776 <copy_range+0x154>
ffffffffc0203660:	89aa                	mv	s3,a0
ffffffffc0203662:	892e                	mv	s2,a1
        start += PGSIZE;
ffffffffc0203664:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0203666:	000bdc97          	auipc	s9,0xbd
ffffffffc020366a:	abac8c93          	addi	s9,s9,-1350 # ffffffffc02c0120 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020366e:	000bdb17          	auipc	s6,0xbd
ffffffffc0203672:	abab0b13          	addi	s6,s6,-1350 # ffffffffc02c0128 <pages>
    return page - pages + nbase;
ffffffffc0203676:	00080ab7          	lui	s5,0x80
            cprintf("COW share: va=%p ppn=%x ref=%d\n", (void *)start, page2ppn(page), page_ref(page));
ffffffffc020367a:	00004b97          	auipc	s7,0x4
ffffffffc020367e:	956b8b93          	addi	s7,s7,-1706 # ffffffffc0206fd0 <default_pmm_manager+0x6f8>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203682:	4601                	li	a2,0
ffffffffc0203684:	85ee                	mv	a1,s11
ffffffffc0203686:	854a                	mv	a0,s2
ffffffffc0203688:	b75fe0ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc020368c:	8d2a                	mv	s10,a0
        if (ptep == NULL)
ffffffffc020368e:	c571                	beqz	a0,ffffffffc020375a <copy_range+0x138>
        if (*ptep & PTE_V)
ffffffffc0203690:	6114                	ld	a3,0(a0)
ffffffffc0203692:	8a85                	andi	a3,a3,1
ffffffffc0203694:	e685                	bnez	a3,ffffffffc02036bc <copy_range+0x9a>
        start += PGSIZE;
ffffffffc0203696:	9dd2                	add	s11,s11,s4
    } while (start != 0 && start < end);
ffffffffc0203698:	fe9de5e3          	bltu	s11,s1,ffffffffc0203682 <copy_range+0x60>
    return 0;
ffffffffc020369c:	4501                	li	a0,0
}
ffffffffc020369e:	70a6                	ld	ra,104(sp)
ffffffffc02036a0:	7406                	ld	s0,96(sp)
ffffffffc02036a2:	64e6                	ld	s1,88(sp)
ffffffffc02036a4:	6946                	ld	s2,80(sp)
ffffffffc02036a6:	69a6                	ld	s3,72(sp)
ffffffffc02036a8:	6a06                	ld	s4,64(sp)
ffffffffc02036aa:	7ae2                	ld	s5,56(sp)
ffffffffc02036ac:	7b42                	ld	s6,48(sp)
ffffffffc02036ae:	7ba2                	ld	s7,40(sp)
ffffffffc02036b0:	7c02                	ld	s8,32(sp)
ffffffffc02036b2:	6ce2                	ld	s9,24(sp)
ffffffffc02036b4:	6d42                	ld	s10,16(sp)
ffffffffc02036b6:	6da2                	ld	s11,8(sp)
ffffffffc02036b8:	6165                	addi	sp,sp,112
ffffffffc02036ba:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02036bc:	4605                	li	a2,1
ffffffffc02036be:	85ee                	mv	a1,s11
ffffffffc02036c0:	854e                	mv	a0,s3
ffffffffc02036c2:	b3bfe0ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc02036c6:	c555                	beqz	a0,ffffffffc0203772 <copy_range+0x150>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc02036c8:	000d3683          	ld	a3,0(s10)
    if (!(pte & PTE_V))
ffffffffc02036cc:	0016f613          	andi	a2,a3,1
ffffffffc02036d0:	0006841b          	sext.w	s0,a3
ffffffffc02036d4:	0e060d63          	beqz	a2,ffffffffc02037ce <copy_range+0x1ac>
    if (PPN(pa) >= npage)
ffffffffc02036d8:	000cb583          	ld	a1,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02036dc:	00269613          	slli	a2,a3,0x2
ffffffffc02036e0:	8231                	srli	a2,a2,0xc
    if (PPN(pa) >= npage)
ffffffffc02036e2:	0cb67a63          	bgeu	a2,a1,ffffffffc02037b6 <copy_range+0x194>
    return &pages[PPN(pa) - nbase];
ffffffffc02036e6:	000b3803          	ld	a6,0(s6)
ffffffffc02036ea:	fff807b7          	lui	a5,0xfff80
ffffffffc02036ee:	963e                	add	a2,a2,a5
ffffffffc02036f0:	061a                	slli	a2,a2,0x6
ffffffffc02036f2:	00c80c33          	add	s8,a6,a2
            assert(page != NULL);
ffffffffc02036f6:	0a0c0063          	beqz	s8,ffffffffc0203796 <copy_range+0x174>
            cprintf("COW share: va=%p ppn=%x ref=%d\n", (void *)start, page2ppn(page), page_ref(page));
ffffffffc02036fa:	000c2683          	lw	a3,0(s8)
    return page - pages + nbase;
ffffffffc02036fe:	8619                	srai	a2,a2,0x6
ffffffffc0203700:	9656                	add	a2,a2,s5
ffffffffc0203702:	85ee                	mv	a1,s11
ffffffffc0203704:	855e                	mv	a0,s7
ffffffffc0203706:	a8ffc0ef          	jal	ra,ffffffffc0200194 <cprintf>
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc020370a:	4605                	li	a2,1
ffffffffc020370c:	85ee                	mv	a1,s11
ffffffffc020370e:	854e                	mv	a0,s3
            uint32_t ro_perm = perm & (~PTE_W);
ffffffffc0203710:	886d                	andi	s0,s0,27
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203712:	aebfe0ef          	jal	ra,ffffffffc02021fc <get_pte>
ffffffffc0203716:	cd31                	beqz	a0,ffffffffc0203772 <copy_range+0x150>
            if (page_insert(to, page, start, ro_perm) != 0)
ffffffffc0203718:	86a2                	mv	a3,s0
ffffffffc020371a:	866e                	mv	a2,s11
ffffffffc020371c:	85e2                	mv	a1,s8
ffffffffc020371e:	854e                	mv	a0,s3
ffffffffc0203720:	9ccff0ef          	jal	ra,ffffffffc02028ec <page_insert>
ffffffffc0203724:	e539                	bnez	a0,ffffffffc0203772 <copy_range+0x150>
ffffffffc0203726:	000b3603          	ld	a2,0(s6)
ffffffffc020372a:	40cc0633          	sub	a2,s8,a2
ffffffffc020372e:	8619                	srai	a2,a2,0x6
ffffffffc0203730:	9656                	add	a2,a2,s5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0203732:	00a61693          	slli	a3,a2,0xa
ffffffffc0203736:	8c55                	or	s0,s0,a3
ffffffffc0203738:	00146413          	ori	s0,s0,1
            *ptep = pte_create(page2ppn(page), ro_perm);
ffffffffc020373c:	008d3023          	sd	s0,0(s10)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0203740:	120d8073          	sfence.vma	s11
            cprintf("COW mapped: va=%p ppn=%x new_ref=%d\n", (void *)start, page2ppn(page), page_ref(page));
ffffffffc0203744:	000c2683          	lw	a3,0(s8)
ffffffffc0203748:	85ee                	mv	a1,s11
ffffffffc020374a:	00004517          	auipc	a0,0x4
ffffffffc020374e:	8a650513          	addi	a0,a0,-1882 # ffffffffc0206ff0 <default_pmm_manager+0x718>
ffffffffc0203752:	a43fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        start += PGSIZE;
ffffffffc0203756:	9dd2                	add	s11,s11,s4
    } while (start != 0 && start < end);
ffffffffc0203758:	b781                	j	ffffffffc0203698 <copy_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020375a:	002007b7          	lui	a5,0x200
ffffffffc020375e:	97ee                	add	a5,a5,s11
ffffffffc0203760:	ffe00737          	lui	a4,0xffe00
ffffffffc0203764:	00e7fdb3          	and	s11,a5,a4
    } while (start != 0 && start < end);
ffffffffc0203768:	f20d8ae3          	beqz	s11,ffffffffc020369c <copy_range+0x7a>
ffffffffc020376c:	f09debe3          	bltu	s11,s1,ffffffffc0203682 <copy_range+0x60>
ffffffffc0203770:	b735                	j	ffffffffc020369c <copy_range+0x7a>
                return -E_NO_MEM;
ffffffffc0203772:	5571                	li	a0,-4
ffffffffc0203774:	b72d                	j	ffffffffc020369e <copy_range+0x7c>
    assert(USER_ACCESS(start, end));
ffffffffc0203776:	00003697          	auipc	a3,0x3
ffffffffc020377a:	29a68693          	addi	a3,a3,666 # ffffffffc0206a10 <default_pmm_manager+0x138>
ffffffffc020377e:	00003617          	auipc	a2,0x3
ffffffffc0203782:	daa60613          	addi	a2,a2,-598 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203786:	17c00593          	li	a1,380
ffffffffc020378a:	00003517          	auipc	a0,0x3
ffffffffc020378e:	24650513          	addi	a0,a0,582 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203792:	cfdfc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc0203796:	00004697          	auipc	a3,0x4
ffffffffc020379a:	82a68693          	addi	a3,a3,-2006 # ffffffffc0206fc0 <default_pmm_manager+0x6e8>
ffffffffc020379e:	00003617          	auipc	a2,0x3
ffffffffc02037a2:	d8a60613          	addi	a2,a2,-630 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02037a6:	19600593          	li	a1,406
ffffffffc02037aa:	00003517          	auipc	a0,0x3
ffffffffc02037ae:	22650513          	addi	a0,a0,550 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02037b2:	cddfc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02037b6:	00003617          	auipc	a2,0x3
ffffffffc02037ba:	bd260613          	addi	a2,a2,-1070 # ffffffffc0206388 <commands+0x848>
ffffffffc02037be:	06900593          	li	a1,105
ffffffffc02037c2:	00003517          	auipc	a0,0x3
ffffffffc02037c6:	be650513          	addi	a0,a0,-1050 # ffffffffc02063a8 <commands+0x868>
ffffffffc02037ca:	cc5fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02037ce:	00003617          	auipc	a2,0x3
ffffffffc02037d2:	1da60613          	addi	a2,a2,474 # ffffffffc02069a8 <default_pmm_manager+0xd0>
ffffffffc02037d6:	07f00593          	li	a1,127
ffffffffc02037da:	00003517          	auipc	a0,0x3
ffffffffc02037de:	bce50513          	addi	a0,a0,-1074 # ffffffffc02063a8 <commands+0x868>
ffffffffc02037e2:	cadfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02037e6:	00003697          	auipc	a3,0x3
ffffffffc02037ea:	1fa68693          	addi	a3,a3,506 # ffffffffc02069e0 <default_pmm_manager+0x108>
ffffffffc02037ee:	00003617          	auipc	a2,0x3
ffffffffc02037f2:	d3a60613          	addi	a2,a2,-710 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02037f6:	17b00593          	li	a1,379
ffffffffc02037fa:	00003517          	auipc	a0,0x3
ffffffffc02037fe:	1d650513          	addi	a0,a0,470 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc0203802:	c8dfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203806 <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0203806:	12058073          	sfence.vma	a1
}
ffffffffc020380a:	8082                	ret

ffffffffc020380c <pgdir_alloc_page>:
{
ffffffffc020380c:	7179                	addi	sp,sp,-48
ffffffffc020380e:	ec26                	sd	s1,24(sp)
ffffffffc0203810:	e84a                	sd	s2,16(sp)
ffffffffc0203812:	e052                	sd	s4,0(sp)
ffffffffc0203814:	f406                	sd	ra,40(sp)
ffffffffc0203816:	f022                	sd	s0,32(sp)
ffffffffc0203818:	e44e                	sd	s3,8(sp)
ffffffffc020381a:	8a2a                	mv	s4,a0
ffffffffc020381c:	84ae                	mv	s1,a1
ffffffffc020381e:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203820:	100027f3          	csrr	a5,sstatus
ffffffffc0203824:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203826:	000bd997          	auipc	s3,0xbd
ffffffffc020382a:	90a98993          	addi	s3,s3,-1782 # ffffffffc02c0130 <pmm_manager>
ffffffffc020382e:	ef8d                	bnez	a5,ffffffffc0203868 <pgdir_alloc_page+0x5c>
ffffffffc0203830:	0009b783          	ld	a5,0(s3)
ffffffffc0203834:	4505                	li	a0,1
ffffffffc0203836:	6f9c                	ld	a5,24(a5)
ffffffffc0203838:	9782                	jalr	a5
ffffffffc020383a:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc020383c:	cc09                	beqz	s0,ffffffffc0203856 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc020383e:	86ca                	mv	a3,s2
ffffffffc0203840:	8626                	mv	a2,s1
ffffffffc0203842:	85a2                	mv	a1,s0
ffffffffc0203844:	8552                	mv	a0,s4
ffffffffc0203846:	8a6ff0ef          	jal	ra,ffffffffc02028ec <page_insert>
ffffffffc020384a:	e915                	bnez	a0,ffffffffc020387e <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc020384c:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc020384e:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203850:	4785                	li	a5,1
ffffffffc0203852:	04f71e63          	bne	a4,a5,ffffffffc02038ae <pgdir_alloc_page+0xa2>
}
ffffffffc0203856:	70a2                	ld	ra,40(sp)
ffffffffc0203858:	8522                	mv	a0,s0
ffffffffc020385a:	7402                	ld	s0,32(sp)
ffffffffc020385c:	64e2                	ld	s1,24(sp)
ffffffffc020385e:	6942                	ld	s2,16(sp)
ffffffffc0203860:	69a2                	ld	s3,8(sp)
ffffffffc0203862:	6a02                	ld	s4,0(sp)
ffffffffc0203864:	6145                	addi	sp,sp,48
ffffffffc0203866:	8082                	ret
        intr_disable();
ffffffffc0203868:	94cfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020386c:	0009b783          	ld	a5,0(s3)
ffffffffc0203870:	4505                	li	a0,1
ffffffffc0203872:	6f9c                	ld	a5,24(a5)
ffffffffc0203874:	9782                	jalr	a5
ffffffffc0203876:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203878:	936fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020387c:	b7c1                	j	ffffffffc020383c <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020387e:	100027f3          	csrr	a5,sstatus
ffffffffc0203882:	8b89                	andi	a5,a5,2
ffffffffc0203884:	eb89                	bnez	a5,ffffffffc0203896 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203886:	0009b783          	ld	a5,0(s3)
ffffffffc020388a:	8522                	mv	a0,s0
ffffffffc020388c:	4585                	li	a1,1
ffffffffc020388e:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203890:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203892:	9782                	jalr	a5
    if (flag)
ffffffffc0203894:	b7c9                	j	ffffffffc0203856 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203896:	91efd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020389a:	0009b783          	ld	a5,0(s3)
ffffffffc020389e:	8522                	mv	a0,s0
ffffffffc02038a0:	4585                	li	a1,1
ffffffffc02038a2:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc02038a4:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02038a6:	9782                	jalr	a5
        intr_enable();
ffffffffc02038a8:	906fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02038ac:	b76d                	j	ffffffffc0203856 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc02038ae:	00003697          	auipc	a3,0x3
ffffffffc02038b2:	76a68693          	addi	a3,a3,1898 # ffffffffc0207018 <default_pmm_manager+0x740>
ffffffffc02038b6:	00003617          	auipc	a2,0x3
ffffffffc02038ba:	c7260613          	addi	a2,a2,-910 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02038be:	1ef00593          	li	a1,495
ffffffffc02038c2:	00003517          	auipc	a0,0x3
ffffffffc02038c6:	10e50513          	addi	a0,a0,270 # ffffffffc02069d0 <default_pmm_manager+0xf8>
ffffffffc02038ca:	bc5fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02038ce <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02038ce:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02038d0:	00003697          	auipc	a3,0x3
ffffffffc02038d4:	76068693          	addi	a3,a3,1888 # ffffffffc0207030 <default_pmm_manager+0x758>
ffffffffc02038d8:	00003617          	auipc	a2,0x3
ffffffffc02038dc:	c5060613          	addi	a2,a2,-944 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02038e0:	07400593          	li	a1,116
ffffffffc02038e4:	00003517          	auipc	a0,0x3
ffffffffc02038e8:	76c50513          	addi	a0,a0,1900 # ffffffffc0207050 <default_pmm_manager+0x778>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02038ec:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02038ee:	ba1fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02038f2 <mm_create>:
{
ffffffffc02038f2:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038f4:	04000513          	li	a0,64
{
ffffffffc02038f8:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038fa:	e6cfe0ef          	jal	ra,ffffffffc0201f66 <kmalloc>
    if (mm != NULL)
ffffffffc02038fe:	cd19                	beqz	a0,ffffffffc020391c <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc0203900:	e508                	sd	a0,8(a0)
ffffffffc0203902:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203904:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203908:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc020390c:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203910:	02053423          	sd	zero,40(a0)
    mm->mm_count = val;
ffffffffc0203914:	02052823          	sw	zero,48(a0)
    *lock = 0;
ffffffffc0203918:	02053c23          	sd	zero,56(a0)
}
ffffffffc020391c:	60a2                	ld	ra,8(sp)
ffffffffc020391e:	0141                	addi	sp,sp,16
ffffffffc0203920:	8082                	ret

ffffffffc0203922 <find_vma>:
{
ffffffffc0203922:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0203924:	c505                	beqz	a0,ffffffffc020394c <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203926:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203928:	c501                	beqz	a0,ffffffffc0203930 <find_vma+0xe>
ffffffffc020392a:	651c                	ld	a5,8(a0)
ffffffffc020392c:	02f5f263          	bgeu	a1,a5,ffffffffc0203950 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203930:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203932:	00f68d63          	beq	a3,a5,ffffffffc020394c <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203936:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_dirtycow_test_out_size+0x1f4dc8>
ffffffffc020393a:	00e5e663          	bltu	a1,a4,ffffffffc0203946 <find_vma+0x24>
ffffffffc020393e:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203942:	00e5ec63          	bltu	a1,a4,ffffffffc020395a <find_vma+0x38>
ffffffffc0203946:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203948:	fef697e3          	bne	a3,a5,ffffffffc0203936 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc020394c:	4501                	li	a0,0
}
ffffffffc020394e:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203950:	691c                	ld	a5,16(a0)
ffffffffc0203952:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203930 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203956:	ea88                	sd	a0,16(a3)
ffffffffc0203958:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020395a:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc020395e:	ea88                	sd	a0,16(a3)
ffffffffc0203960:	8082                	ret

ffffffffc0203962 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203962:	6590                	ld	a2,8(a1)
ffffffffc0203964:	0105b803          	ld	a6,16(a1)
{
ffffffffc0203968:	1141                	addi	sp,sp,-16
ffffffffc020396a:	e406                	sd	ra,8(sp)
ffffffffc020396c:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020396e:	01066763          	bltu	a2,a6,ffffffffc020397c <insert_vma_struct+0x1a>
ffffffffc0203972:	a085                	j	ffffffffc02039d2 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203974:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203978:	04e66863          	bltu	a2,a4,ffffffffc02039c8 <insert_vma_struct+0x66>
ffffffffc020397c:	86be                	mv	a3,a5
ffffffffc020397e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203980:	fef51ae3          	bne	a0,a5,ffffffffc0203974 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203984:	02a68463          	beq	a3,a0,ffffffffc02039ac <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203988:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020398c:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203990:	08e8f163          	bgeu	a7,a4,ffffffffc0203a12 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203994:	04e66f63          	bltu	a2,a4,ffffffffc02039f2 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203998:	00f50a63          	beq	a0,a5,ffffffffc02039ac <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020399c:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02039a0:	05076963          	bltu	a4,a6,ffffffffc02039f2 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc02039a4:	ff07b603          	ld	a2,-16(a5)
ffffffffc02039a8:	02c77363          	bgeu	a4,a2,ffffffffc02039ce <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02039ac:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02039ae:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02039b0:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02039b4:	e390                	sd	a2,0(a5)
ffffffffc02039b6:	e690                	sd	a2,8(a3)
}
ffffffffc02039b8:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02039ba:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02039bc:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02039be:	0017079b          	addiw	a5,a4,1
ffffffffc02039c2:	d11c                	sw	a5,32(a0)
}
ffffffffc02039c4:	0141                	addi	sp,sp,16
ffffffffc02039c6:	8082                	ret
    if (le_prev != list)
ffffffffc02039c8:	fca690e3          	bne	a3,a0,ffffffffc0203988 <insert_vma_struct+0x26>
ffffffffc02039cc:	bfd1                	j	ffffffffc02039a0 <insert_vma_struct+0x3e>
ffffffffc02039ce:	f01ff0ef          	jal	ra,ffffffffc02038ce <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02039d2:	00003697          	auipc	a3,0x3
ffffffffc02039d6:	68e68693          	addi	a3,a3,1678 # ffffffffc0207060 <default_pmm_manager+0x788>
ffffffffc02039da:	00003617          	auipc	a2,0x3
ffffffffc02039de:	b4e60613          	addi	a2,a2,-1202 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02039e2:	07a00593          	li	a1,122
ffffffffc02039e6:	00003517          	auipc	a0,0x3
ffffffffc02039ea:	66a50513          	addi	a0,a0,1642 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc02039ee:	aa1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02039f2:	00003697          	auipc	a3,0x3
ffffffffc02039f6:	6ae68693          	addi	a3,a3,1710 # ffffffffc02070a0 <default_pmm_manager+0x7c8>
ffffffffc02039fa:	00003617          	auipc	a2,0x3
ffffffffc02039fe:	b2e60613          	addi	a2,a2,-1234 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203a02:	07300593          	li	a1,115
ffffffffc0203a06:	00003517          	auipc	a0,0x3
ffffffffc0203a0a:	64a50513          	addi	a0,a0,1610 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203a0e:	a81fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203a12:	00003697          	auipc	a3,0x3
ffffffffc0203a16:	66e68693          	addi	a3,a3,1646 # ffffffffc0207080 <default_pmm_manager+0x7a8>
ffffffffc0203a1a:	00003617          	auipc	a2,0x3
ffffffffc0203a1e:	b0e60613          	addi	a2,a2,-1266 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203a22:	07200593          	li	a1,114
ffffffffc0203a26:	00003517          	auipc	a0,0x3
ffffffffc0203a2a:	62a50513          	addi	a0,a0,1578 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203a2e:	a61fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a32 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203a32:	591c                	lw	a5,48(a0)
{
ffffffffc0203a34:	1141                	addi	sp,sp,-16
ffffffffc0203a36:	e406                	sd	ra,8(sp)
ffffffffc0203a38:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203a3a:	e78d                	bnez	a5,ffffffffc0203a64 <mm_destroy+0x32>
ffffffffc0203a3c:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203a3e:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203a40:	00a40c63          	beq	s0,a0,ffffffffc0203a58 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203a44:	6118                	ld	a4,0(a0)
ffffffffc0203a46:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203a48:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203a4a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203a4c:	e398                	sd	a4,0(a5)
ffffffffc0203a4e:	dc8fe0ef          	jal	ra,ffffffffc0202016 <kfree>
    return listelm->next;
ffffffffc0203a52:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203a54:	fea418e3          	bne	s0,a0,ffffffffc0203a44 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203a58:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203a5a:	6402                	ld	s0,0(sp)
ffffffffc0203a5c:	60a2                	ld	ra,8(sp)
ffffffffc0203a5e:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203a60:	db6fe06f          	j	ffffffffc0202016 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203a64:	00003697          	auipc	a3,0x3
ffffffffc0203a68:	65c68693          	addi	a3,a3,1628 # ffffffffc02070c0 <default_pmm_manager+0x7e8>
ffffffffc0203a6c:	00003617          	auipc	a2,0x3
ffffffffc0203a70:	abc60613          	addi	a2,a2,-1348 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203a74:	09e00593          	li	a1,158
ffffffffc0203a78:	00003517          	auipc	a0,0x3
ffffffffc0203a7c:	5d850513          	addi	a0,a0,1496 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203a80:	a0ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a84 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203a84:	7139                	addi	sp,sp,-64
ffffffffc0203a86:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203a88:	6405                	lui	s0,0x1
ffffffffc0203a8a:	147d                	addi	s0,s0,-1
ffffffffc0203a8c:	77fd                	lui	a5,0xfffff
ffffffffc0203a8e:	9622                	add	a2,a2,s0
ffffffffc0203a90:	962e                	add	a2,a2,a1
{
ffffffffc0203a92:	f426                	sd	s1,40(sp)
ffffffffc0203a94:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203a96:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203a9a:	f04a                	sd	s2,32(sp)
ffffffffc0203a9c:	ec4e                	sd	s3,24(sp)
ffffffffc0203a9e:	e852                	sd	s4,16(sp)
ffffffffc0203aa0:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203aa2:	002005b7          	lui	a1,0x200
ffffffffc0203aa6:	00f67433          	and	s0,a2,a5
ffffffffc0203aaa:	06b4e363          	bltu	s1,a1,ffffffffc0203b10 <mm_map+0x8c>
ffffffffc0203aae:	0684f163          	bgeu	s1,s0,ffffffffc0203b10 <mm_map+0x8c>
ffffffffc0203ab2:	4785                	li	a5,1
ffffffffc0203ab4:	07fe                	slli	a5,a5,0x1f
ffffffffc0203ab6:	0487ed63          	bltu	a5,s0,ffffffffc0203b10 <mm_map+0x8c>
ffffffffc0203aba:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203abc:	cd21                	beqz	a0,ffffffffc0203b14 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203abe:	85a6                	mv	a1,s1
ffffffffc0203ac0:	8ab6                	mv	s5,a3
ffffffffc0203ac2:	8a3a                	mv	s4,a4
ffffffffc0203ac4:	e5fff0ef          	jal	ra,ffffffffc0203922 <find_vma>
ffffffffc0203ac8:	c501                	beqz	a0,ffffffffc0203ad0 <mm_map+0x4c>
ffffffffc0203aca:	651c                	ld	a5,8(a0)
ffffffffc0203acc:	0487e263          	bltu	a5,s0,ffffffffc0203b10 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ad0:	03000513          	li	a0,48
ffffffffc0203ad4:	c92fe0ef          	jal	ra,ffffffffc0201f66 <kmalloc>
ffffffffc0203ad8:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203ada:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203adc:	02090163          	beqz	s2,ffffffffc0203afe <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203ae0:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0203ae2:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0203ae6:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0203aea:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0203aee:	85ca                	mv	a1,s2
ffffffffc0203af0:	e73ff0ef          	jal	ra,ffffffffc0203962 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0203af4:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0203af6:	000a0463          	beqz	s4,ffffffffc0203afe <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0203afa:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>

out:
    return ret;
}
ffffffffc0203afe:	70e2                	ld	ra,56(sp)
ffffffffc0203b00:	7442                	ld	s0,48(sp)
ffffffffc0203b02:	74a2                	ld	s1,40(sp)
ffffffffc0203b04:	7902                	ld	s2,32(sp)
ffffffffc0203b06:	69e2                	ld	s3,24(sp)
ffffffffc0203b08:	6a42                	ld	s4,16(sp)
ffffffffc0203b0a:	6aa2                	ld	s5,8(sp)
ffffffffc0203b0c:	6121                	addi	sp,sp,64
ffffffffc0203b0e:	8082                	ret
        return -E_INVAL;
ffffffffc0203b10:	5575                	li	a0,-3
ffffffffc0203b12:	b7f5                	j	ffffffffc0203afe <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0203b14:	00003697          	auipc	a3,0x3
ffffffffc0203b18:	5c468693          	addi	a3,a3,1476 # ffffffffc02070d8 <default_pmm_manager+0x800>
ffffffffc0203b1c:	00003617          	auipc	a2,0x3
ffffffffc0203b20:	a0c60613          	addi	a2,a2,-1524 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203b24:	0b300593          	li	a1,179
ffffffffc0203b28:	00003517          	auipc	a0,0x3
ffffffffc0203b2c:	52850513          	addi	a0,a0,1320 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203b30:	95ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203b34 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203b34:	7139                	addi	sp,sp,-64
ffffffffc0203b36:	fc06                	sd	ra,56(sp)
ffffffffc0203b38:	f822                	sd	s0,48(sp)
ffffffffc0203b3a:	f426                	sd	s1,40(sp)
ffffffffc0203b3c:	f04a                	sd	s2,32(sp)
ffffffffc0203b3e:	ec4e                	sd	s3,24(sp)
ffffffffc0203b40:	e852                	sd	s4,16(sp)
ffffffffc0203b42:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203b44:	c52d                	beqz	a0,ffffffffc0203bae <dup_mmap+0x7a>
ffffffffc0203b46:	892a                	mv	s2,a0
ffffffffc0203b48:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203b4a:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203b4c:	e595                	bnez	a1,ffffffffc0203b78 <dup_mmap+0x44>
ffffffffc0203b4e:	a085                	j	ffffffffc0203bae <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203b50:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203b52:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_dirtycow_test_out_size+0x1f4de8>
        vma->vm_end = vm_end;
ffffffffc0203b56:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203b5a:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203b5e:	e05ff0ef          	jal	ra,ffffffffc0203962 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203b62:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bc0>
ffffffffc0203b66:	fe843603          	ld	a2,-24(s0)
ffffffffc0203b6a:	6c8c                	ld	a1,24(s1)
ffffffffc0203b6c:	01893503          	ld	a0,24(s2)
ffffffffc0203b70:	4701                	li	a4,0
ffffffffc0203b72:	ab1ff0ef          	jal	ra,ffffffffc0203622 <copy_range>
ffffffffc0203b76:	e105                	bnez	a0,ffffffffc0203b96 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203b78:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203b7a:	02848863          	beq	s1,s0,ffffffffc0203baa <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b7e:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203b82:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203b86:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203b8a:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b8e:	bd8fe0ef          	jal	ra,ffffffffc0201f66 <kmalloc>
ffffffffc0203b92:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203b94:	fd55                	bnez	a0,ffffffffc0203b50 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203b96:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203b98:	70e2                	ld	ra,56(sp)
ffffffffc0203b9a:	7442                	ld	s0,48(sp)
ffffffffc0203b9c:	74a2                	ld	s1,40(sp)
ffffffffc0203b9e:	7902                	ld	s2,32(sp)
ffffffffc0203ba0:	69e2                	ld	s3,24(sp)
ffffffffc0203ba2:	6a42                	ld	s4,16(sp)
ffffffffc0203ba4:	6aa2                	ld	s5,8(sp)
ffffffffc0203ba6:	6121                	addi	sp,sp,64
ffffffffc0203ba8:	8082                	ret
    return 0;
ffffffffc0203baa:	4501                	li	a0,0
ffffffffc0203bac:	b7f5                	j	ffffffffc0203b98 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203bae:	00003697          	auipc	a3,0x3
ffffffffc0203bb2:	53a68693          	addi	a3,a3,1338 # ffffffffc02070e8 <default_pmm_manager+0x810>
ffffffffc0203bb6:	00003617          	auipc	a2,0x3
ffffffffc0203bba:	97260613          	addi	a2,a2,-1678 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203bbe:	0cf00593          	li	a1,207
ffffffffc0203bc2:	00003517          	auipc	a0,0x3
ffffffffc0203bc6:	48e50513          	addi	a0,a0,1166 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203bca:	8c5fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203bce <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203bce:	1101                	addi	sp,sp,-32
ffffffffc0203bd0:	ec06                	sd	ra,24(sp)
ffffffffc0203bd2:	e822                	sd	s0,16(sp)
ffffffffc0203bd4:	e426                	sd	s1,8(sp)
ffffffffc0203bd6:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203bd8:	c531                	beqz	a0,ffffffffc0203c24 <exit_mmap+0x56>
ffffffffc0203bda:	591c                	lw	a5,48(a0)
ffffffffc0203bdc:	84aa                	mv	s1,a0
ffffffffc0203bde:	e3b9                	bnez	a5,ffffffffc0203c24 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203be0:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203be2:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203be6:	02850663          	beq	a0,s0,ffffffffc0203c12 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203bea:	ff043603          	ld	a2,-16(s0)
ffffffffc0203bee:	fe843583          	ld	a1,-24(s0)
ffffffffc0203bf2:	854a                	mv	a0,s2
ffffffffc0203bf4:	885fe0ef          	jal	ra,ffffffffc0202478 <unmap_range>
ffffffffc0203bf8:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203bfa:	fe8498e3          	bne	s1,s0,ffffffffc0203bea <exit_mmap+0x1c>
ffffffffc0203bfe:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203c00:	00848c63          	beq	s1,s0,ffffffffc0203c18 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203c04:	ff043603          	ld	a2,-16(s0)
ffffffffc0203c08:	fe843583          	ld	a1,-24(s0)
ffffffffc0203c0c:	854a                	mv	a0,s2
ffffffffc0203c0e:	9b1fe0ef          	jal	ra,ffffffffc02025be <exit_range>
ffffffffc0203c12:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203c14:	fe8498e3          	bne	s1,s0,ffffffffc0203c04 <exit_mmap+0x36>
    }
}
ffffffffc0203c18:	60e2                	ld	ra,24(sp)
ffffffffc0203c1a:	6442                	ld	s0,16(sp)
ffffffffc0203c1c:	64a2                	ld	s1,8(sp)
ffffffffc0203c1e:	6902                	ld	s2,0(sp)
ffffffffc0203c20:	6105                	addi	sp,sp,32
ffffffffc0203c22:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203c24:	00003697          	auipc	a3,0x3
ffffffffc0203c28:	4e468693          	addi	a3,a3,1252 # ffffffffc0207108 <default_pmm_manager+0x830>
ffffffffc0203c2c:	00003617          	auipc	a2,0x3
ffffffffc0203c30:	8fc60613          	addi	a2,a2,-1796 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203c34:	0e800593          	li	a1,232
ffffffffc0203c38:	00003517          	auipc	a0,0x3
ffffffffc0203c3c:	41850513          	addi	a0,a0,1048 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203c40:	84ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203c44 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203c44:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c46:	04000513          	li	a0,64
{
ffffffffc0203c4a:	fc06                	sd	ra,56(sp)
ffffffffc0203c4c:	f822                	sd	s0,48(sp)
ffffffffc0203c4e:	f426                	sd	s1,40(sp)
ffffffffc0203c50:	f04a                	sd	s2,32(sp)
ffffffffc0203c52:	ec4e                	sd	s3,24(sp)
ffffffffc0203c54:	e852                	sd	s4,16(sp)
ffffffffc0203c56:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c58:	b0efe0ef          	jal	ra,ffffffffc0201f66 <kmalloc>
    if (mm != NULL)
ffffffffc0203c5c:	2e050663          	beqz	a0,ffffffffc0203f48 <vmm_init+0x304>
ffffffffc0203c60:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203c62:	e508                	sd	a0,8(a0)
ffffffffc0203c64:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203c66:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203c6a:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203c6e:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203c72:	02053423          	sd	zero,40(a0)
ffffffffc0203c76:	02052823          	sw	zero,48(a0)
ffffffffc0203c7a:	02053c23          	sd	zero,56(a0)
ffffffffc0203c7e:	03200413          	li	s0,50
ffffffffc0203c82:	a811                	j	ffffffffc0203c96 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203c84:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203c86:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203c88:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203c8c:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203c8e:	8526                	mv	a0,s1
ffffffffc0203c90:	cd3ff0ef          	jal	ra,ffffffffc0203962 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203c94:	c80d                	beqz	s0,ffffffffc0203cc6 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203c96:	03000513          	li	a0,48
ffffffffc0203c9a:	accfe0ef          	jal	ra,ffffffffc0201f66 <kmalloc>
ffffffffc0203c9e:	85aa                	mv	a1,a0
ffffffffc0203ca0:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203ca4:	f165                	bnez	a0,ffffffffc0203c84 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203ca6:	00003697          	auipc	a3,0x3
ffffffffc0203caa:	5fa68693          	addi	a3,a3,1530 # ffffffffc02072a0 <default_pmm_manager+0x9c8>
ffffffffc0203cae:	00003617          	auipc	a2,0x3
ffffffffc0203cb2:	87a60613          	addi	a2,a2,-1926 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203cb6:	12c00593          	li	a1,300
ffffffffc0203cba:	00003517          	auipc	a0,0x3
ffffffffc0203cbe:	39650513          	addi	a0,a0,918 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203cc2:	fccfc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203cc6:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203cca:	1f900913          	li	s2,505
ffffffffc0203cce:	a819                	j	ffffffffc0203ce4 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203cd0:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203cd2:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203cd4:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203cd8:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203cda:	8526                	mv	a0,s1
ffffffffc0203cdc:	c87ff0ef          	jal	ra,ffffffffc0203962 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ce0:	03240a63          	beq	s0,s2,ffffffffc0203d14 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ce4:	03000513          	li	a0,48
ffffffffc0203ce8:	a7efe0ef          	jal	ra,ffffffffc0201f66 <kmalloc>
ffffffffc0203cec:	85aa                	mv	a1,a0
ffffffffc0203cee:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203cf2:	fd79                	bnez	a0,ffffffffc0203cd0 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203cf4:	00003697          	auipc	a3,0x3
ffffffffc0203cf8:	5ac68693          	addi	a3,a3,1452 # ffffffffc02072a0 <default_pmm_manager+0x9c8>
ffffffffc0203cfc:	00003617          	auipc	a2,0x3
ffffffffc0203d00:	82c60613          	addi	a2,a2,-2004 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203d04:	13300593          	li	a1,307
ffffffffc0203d08:	00003517          	auipc	a0,0x3
ffffffffc0203d0c:	34850513          	addi	a0,a0,840 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203d10:	f7efc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203d14:	649c                	ld	a5,8(s1)
ffffffffc0203d16:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203d18:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203d1c:	16f48663          	beq	s1,a5,ffffffffc0203e88 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203d20:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd3ee8c>
ffffffffc0203d24:	ffe70693          	addi	a3,a4,-2 # ffffffffffdffffe <end+0x3fb3fea2>
ffffffffc0203d28:	10d61063          	bne	a2,a3,ffffffffc0203e28 <vmm_init+0x1e4>
ffffffffc0203d2c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203d30:	0ed71c63          	bne	a4,a3,ffffffffc0203e28 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203d34:	0715                	addi	a4,a4,5
ffffffffc0203d36:	679c                	ld	a5,8(a5)
ffffffffc0203d38:	feb712e3          	bne	a4,a1,ffffffffc0203d1c <vmm_init+0xd8>
ffffffffc0203d3c:	4a1d                	li	s4,7
ffffffffc0203d3e:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203d40:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203d44:	85a2                	mv	a1,s0
ffffffffc0203d46:	8526                	mv	a0,s1
ffffffffc0203d48:	bdbff0ef          	jal	ra,ffffffffc0203922 <find_vma>
ffffffffc0203d4c:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203d4e:	16050d63          	beqz	a0,ffffffffc0203ec8 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203d52:	00140593          	addi	a1,s0,1
ffffffffc0203d56:	8526                	mv	a0,s1
ffffffffc0203d58:	bcbff0ef          	jal	ra,ffffffffc0203922 <find_vma>
ffffffffc0203d5c:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203d5e:	14050563          	beqz	a0,ffffffffc0203ea8 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203d62:	85d2                	mv	a1,s4
ffffffffc0203d64:	8526                	mv	a0,s1
ffffffffc0203d66:	bbdff0ef          	jal	ra,ffffffffc0203922 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203d6a:	16051f63          	bnez	a0,ffffffffc0203ee8 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203d6e:	00340593          	addi	a1,s0,3
ffffffffc0203d72:	8526                	mv	a0,s1
ffffffffc0203d74:	bafff0ef          	jal	ra,ffffffffc0203922 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203d78:	1a051863          	bnez	a0,ffffffffc0203f28 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203d7c:	00440593          	addi	a1,s0,4
ffffffffc0203d80:	8526                	mv	a0,s1
ffffffffc0203d82:	ba1ff0ef          	jal	ra,ffffffffc0203922 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203d86:	18051163          	bnez	a0,ffffffffc0203f08 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203d8a:	00893783          	ld	a5,8(s2)
ffffffffc0203d8e:	0a879d63          	bne	a5,s0,ffffffffc0203e48 <vmm_init+0x204>
ffffffffc0203d92:	01093783          	ld	a5,16(s2)
ffffffffc0203d96:	0b479963          	bne	a5,s4,ffffffffc0203e48 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203d9a:	0089b783          	ld	a5,8(s3)
ffffffffc0203d9e:	0c879563          	bne	a5,s0,ffffffffc0203e68 <vmm_init+0x224>
ffffffffc0203da2:	0109b783          	ld	a5,16(s3)
ffffffffc0203da6:	0d479163          	bne	a5,s4,ffffffffc0203e68 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203daa:	0415                	addi	s0,s0,5
ffffffffc0203dac:	0a15                	addi	s4,s4,5
ffffffffc0203dae:	f9541be3          	bne	s0,s5,ffffffffc0203d44 <vmm_init+0x100>
ffffffffc0203db2:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203db4:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203db6:	85a2                	mv	a1,s0
ffffffffc0203db8:	8526                	mv	a0,s1
ffffffffc0203dba:	b69ff0ef          	jal	ra,ffffffffc0203922 <find_vma>
ffffffffc0203dbe:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203dc2:	c90d                	beqz	a0,ffffffffc0203df4 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203dc4:	6914                	ld	a3,16(a0)
ffffffffc0203dc6:	6510                	ld	a2,8(a0)
ffffffffc0203dc8:	00003517          	auipc	a0,0x3
ffffffffc0203dcc:	46050513          	addi	a0,a0,1120 # ffffffffc0207228 <default_pmm_manager+0x950>
ffffffffc0203dd0:	bc4fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203dd4:	00003697          	auipc	a3,0x3
ffffffffc0203dd8:	47c68693          	addi	a3,a3,1148 # ffffffffc0207250 <default_pmm_manager+0x978>
ffffffffc0203ddc:	00002617          	auipc	a2,0x2
ffffffffc0203de0:	74c60613          	addi	a2,a2,1868 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203de4:	15900593          	li	a1,345
ffffffffc0203de8:	00003517          	auipc	a0,0x3
ffffffffc0203dec:	26850513          	addi	a0,a0,616 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203df0:	e9efc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203df4:	147d                	addi	s0,s0,-1
ffffffffc0203df6:	fd2410e3          	bne	s0,s2,ffffffffc0203db6 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203dfa:	8526                	mv	a0,s1
ffffffffc0203dfc:	c37ff0ef          	jal	ra,ffffffffc0203a32 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203e00:	00003517          	auipc	a0,0x3
ffffffffc0203e04:	46850513          	addi	a0,a0,1128 # ffffffffc0207268 <default_pmm_manager+0x990>
ffffffffc0203e08:	b8cfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203e0c:	7442                	ld	s0,48(sp)
ffffffffc0203e0e:	70e2                	ld	ra,56(sp)
ffffffffc0203e10:	74a2                	ld	s1,40(sp)
ffffffffc0203e12:	7902                	ld	s2,32(sp)
ffffffffc0203e14:	69e2                	ld	s3,24(sp)
ffffffffc0203e16:	6a42                	ld	s4,16(sp)
ffffffffc0203e18:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e1a:	00003517          	auipc	a0,0x3
ffffffffc0203e1e:	46e50513          	addi	a0,a0,1134 # ffffffffc0207288 <default_pmm_manager+0x9b0>
}
ffffffffc0203e22:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e24:	b70fc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203e28:	00003697          	auipc	a3,0x3
ffffffffc0203e2c:	31868693          	addi	a3,a3,792 # ffffffffc0207140 <default_pmm_manager+0x868>
ffffffffc0203e30:	00002617          	auipc	a2,0x2
ffffffffc0203e34:	6f860613          	addi	a2,a2,1784 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203e38:	13d00593          	li	a1,317
ffffffffc0203e3c:	00003517          	auipc	a0,0x3
ffffffffc0203e40:	21450513          	addi	a0,a0,532 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203e44:	e4afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203e48:	00003697          	auipc	a3,0x3
ffffffffc0203e4c:	38068693          	addi	a3,a3,896 # ffffffffc02071c8 <default_pmm_manager+0x8f0>
ffffffffc0203e50:	00002617          	auipc	a2,0x2
ffffffffc0203e54:	6d860613          	addi	a2,a2,1752 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203e58:	14e00593          	li	a1,334
ffffffffc0203e5c:	00003517          	auipc	a0,0x3
ffffffffc0203e60:	1f450513          	addi	a0,a0,500 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203e64:	e2afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203e68:	00003697          	auipc	a3,0x3
ffffffffc0203e6c:	39068693          	addi	a3,a3,912 # ffffffffc02071f8 <default_pmm_manager+0x920>
ffffffffc0203e70:	00002617          	auipc	a2,0x2
ffffffffc0203e74:	6b860613          	addi	a2,a2,1720 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203e78:	14f00593          	li	a1,335
ffffffffc0203e7c:	00003517          	auipc	a0,0x3
ffffffffc0203e80:	1d450513          	addi	a0,a0,468 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203e84:	e0afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203e88:	00003697          	auipc	a3,0x3
ffffffffc0203e8c:	2a068693          	addi	a3,a3,672 # ffffffffc0207128 <default_pmm_manager+0x850>
ffffffffc0203e90:	00002617          	auipc	a2,0x2
ffffffffc0203e94:	69860613          	addi	a2,a2,1688 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203e98:	13b00593          	li	a1,315
ffffffffc0203e9c:	00003517          	auipc	a0,0x3
ffffffffc0203ea0:	1b450513          	addi	a0,a0,436 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203ea4:	deafc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203ea8:	00003697          	auipc	a3,0x3
ffffffffc0203eac:	2e068693          	addi	a3,a3,736 # ffffffffc0207188 <default_pmm_manager+0x8b0>
ffffffffc0203eb0:	00002617          	auipc	a2,0x2
ffffffffc0203eb4:	67860613          	addi	a2,a2,1656 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203eb8:	14600593          	li	a1,326
ffffffffc0203ebc:	00003517          	auipc	a0,0x3
ffffffffc0203ec0:	19450513          	addi	a0,a0,404 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203ec4:	dcafc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203ec8:	00003697          	auipc	a3,0x3
ffffffffc0203ecc:	2b068693          	addi	a3,a3,688 # ffffffffc0207178 <default_pmm_manager+0x8a0>
ffffffffc0203ed0:	00002617          	auipc	a2,0x2
ffffffffc0203ed4:	65860613          	addi	a2,a2,1624 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203ed8:	14400593          	li	a1,324
ffffffffc0203edc:	00003517          	auipc	a0,0x3
ffffffffc0203ee0:	17450513          	addi	a0,a0,372 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203ee4:	daafc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203ee8:	00003697          	auipc	a3,0x3
ffffffffc0203eec:	2b068693          	addi	a3,a3,688 # ffffffffc0207198 <default_pmm_manager+0x8c0>
ffffffffc0203ef0:	00002617          	auipc	a2,0x2
ffffffffc0203ef4:	63860613          	addi	a2,a2,1592 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203ef8:	14800593          	li	a1,328
ffffffffc0203efc:	00003517          	auipc	a0,0x3
ffffffffc0203f00:	15450513          	addi	a0,a0,340 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203f04:	d8afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203f08:	00003697          	auipc	a3,0x3
ffffffffc0203f0c:	2b068693          	addi	a3,a3,688 # ffffffffc02071b8 <default_pmm_manager+0x8e0>
ffffffffc0203f10:	00002617          	auipc	a2,0x2
ffffffffc0203f14:	61860613          	addi	a2,a2,1560 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203f18:	14c00593          	li	a1,332
ffffffffc0203f1c:	00003517          	auipc	a0,0x3
ffffffffc0203f20:	13450513          	addi	a0,a0,308 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203f24:	d6afc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203f28:	00003697          	auipc	a3,0x3
ffffffffc0203f2c:	28068693          	addi	a3,a3,640 # ffffffffc02071a8 <default_pmm_manager+0x8d0>
ffffffffc0203f30:	00002617          	auipc	a2,0x2
ffffffffc0203f34:	5f860613          	addi	a2,a2,1528 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203f38:	14a00593          	li	a1,330
ffffffffc0203f3c:	00003517          	auipc	a0,0x3
ffffffffc0203f40:	11450513          	addi	a0,a0,276 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203f44:	d4afc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203f48:	00003697          	auipc	a3,0x3
ffffffffc0203f4c:	19068693          	addi	a3,a3,400 # ffffffffc02070d8 <default_pmm_manager+0x800>
ffffffffc0203f50:	00002617          	auipc	a2,0x2
ffffffffc0203f54:	5d860613          	addi	a2,a2,1496 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0203f58:	12400593          	li	a1,292
ffffffffc0203f5c:	00003517          	auipc	a0,0x3
ffffffffc0203f60:	0f450513          	addi	a0,a0,244 # ffffffffc0207050 <default_pmm_manager+0x778>
ffffffffc0203f64:	d2afc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f68 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203f68:	7179                	addi	sp,sp,-48
ffffffffc0203f6a:	f022                	sd	s0,32(sp)
ffffffffc0203f6c:	f406                	sd	ra,40(sp)
ffffffffc0203f6e:	ec26                	sd	s1,24(sp)
ffffffffc0203f70:	e84a                	sd	s2,16(sp)
ffffffffc0203f72:	e44e                	sd	s3,8(sp)
ffffffffc0203f74:	e052                	sd	s4,0(sp)
ffffffffc0203f76:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203f78:	c135                	beqz	a0,ffffffffc0203fdc <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203f7a:	002007b7          	lui	a5,0x200
ffffffffc0203f7e:	04f5e663          	bltu	a1,a5,ffffffffc0203fca <user_mem_check+0x62>
ffffffffc0203f82:	00c584b3          	add	s1,a1,a2
ffffffffc0203f86:	0495f263          	bgeu	a1,s1,ffffffffc0203fca <user_mem_check+0x62>
ffffffffc0203f8a:	4785                	li	a5,1
ffffffffc0203f8c:	07fe                	slli	a5,a5,0x1f
ffffffffc0203f8e:	0297ee63          	bltu	a5,s1,ffffffffc0203fca <user_mem_check+0x62>
ffffffffc0203f92:	892a                	mv	s2,a0
ffffffffc0203f94:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f96:	6a05                	lui	s4,0x1
ffffffffc0203f98:	a821                	j	ffffffffc0203fb0 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203f9a:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203f9e:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203fa0:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203fa2:	c685                	beqz	a3,ffffffffc0203fca <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203fa4:	c399                	beqz	a5,ffffffffc0203faa <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203fa6:	02e46263          	bltu	s0,a4,ffffffffc0203fca <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203faa:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203fac:	04947663          	bgeu	s0,s1,ffffffffc0203ff8 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203fb0:	85a2                	mv	a1,s0
ffffffffc0203fb2:	854a                	mv	a0,s2
ffffffffc0203fb4:	96fff0ef          	jal	ra,ffffffffc0203922 <find_vma>
ffffffffc0203fb8:	c909                	beqz	a0,ffffffffc0203fca <user_mem_check+0x62>
ffffffffc0203fba:	6518                	ld	a4,8(a0)
ffffffffc0203fbc:	00e46763          	bltu	s0,a4,ffffffffc0203fca <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203fc0:	4d1c                	lw	a5,24(a0)
ffffffffc0203fc2:	fc099ce3          	bnez	s3,ffffffffc0203f9a <user_mem_check+0x32>
ffffffffc0203fc6:	8b85                	andi	a5,a5,1
ffffffffc0203fc8:	f3ed                	bnez	a5,ffffffffc0203faa <user_mem_check+0x42>
            return 0;
ffffffffc0203fca:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203fcc:	70a2                	ld	ra,40(sp)
ffffffffc0203fce:	7402                	ld	s0,32(sp)
ffffffffc0203fd0:	64e2                	ld	s1,24(sp)
ffffffffc0203fd2:	6942                	ld	s2,16(sp)
ffffffffc0203fd4:	69a2                	ld	s3,8(sp)
ffffffffc0203fd6:	6a02                	ld	s4,0(sp)
ffffffffc0203fd8:	6145                	addi	sp,sp,48
ffffffffc0203fda:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203fdc:	c02007b7          	lui	a5,0xc0200
ffffffffc0203fe0:	4501                	li	a0,0
ffffffffc0203fe2:	fef5e5e3          	bltu	a1,a5,ffffffffc0203fcc <user_mem_check+0x64>
ffffffffc0203fe6:	962e                	add	a2,a2,a1
ffffffffc0203fe8:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203fcc <user_mem_check+0x64>
ffffffffc0203fec:	c8000537          	lui	a0,0xc8000
ffffffffc0203ff0:	0505                	addi	a0,a0,1
ffffffffc0203ff2:	00a63533          	sltu	a0,a2,a0
ffffffffc0203ff6:	bfd9                	j	ffffffffc0203fcc <user_mem_check+0x64>
        return 1;
ffffffffc0203ff8:	4505                	li	a0,1
ffffffffc0203ffa:	bfc9                	j	ffffffffc0203fcc <user_mem_check+0x64>

ffffffffc0203ffc <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203ffc:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203ffe:	9402                	jalr	s0

	jal do_exit
ffffffffc0204000:	5dc000ef          	jal	ra,ffffffffc02045dc <do_exit>

ffffffffc0204004 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0204004:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204006:	10800513          	li	a0,264
{
ffffffffc020400a:	e022                	sd	s0,0(sp)
ffffffffc020400c:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020400e:	f59fd0ef          	jal	ra,ffffffffc0201f66 <kmalloc>
ffffffffc0204012:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0204014:	cd21                	beqz	a0,ffffffffc020406c <alloc_proc+0x68>
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        // 你的Lab4代码将放在这里
        proc->state = PROC_UNINIT;          // 初始状态为未初始化
ffffffffc0204016:	57fd                	li	a5,-1
ffffffffc0204018:	1782                	slli	a5,a5,0x20
ffffffffc020401a:	e11c                	sd	a5,0(a0)
        proc->runs = 0;                     // 运行次数初始为0
        proc->kstack = 0;                   // 内核栈地址暂设为0（后续setup_kstack分配）
        proc->need_resched = 0;             // 初始不需要调度（ucore用0表示false，修复编译报错）
        proc->parent = NULL;                // 父进程初始为NULL
        proc->mm = NULL;                    // 内核线程无独立内存管理结构，设为NULL
        memset(&proc->context, 0, sizeof(struct context));  // 上下文清零
ffffffffc020401c:	07000613          	li	a2,112
ffffffffc0204020:	4581                	li	a1,0
        proc->runs = 0;                     // 运行次数初始为0
ffffffffc0204022:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d3feac>
        proc->kstack = 0;                   // 内核栈地址暂设为0（后续setup_kstack分配）
ffffffffc0204026:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;             // 初始不需要调度（ucore用0表示false，修复编译报错）
ffffffffc020402a:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;                // 父进程初始为NULL
ffffffffc020402e:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;                    // 内核线程无独立内存管理结构，设为NULL
ffffffffc0204032:	02053423          	sd	zero,40(a0)
        memset(&proc->context, 0, sizeof(struct context));  // 上下文清零
ffffffffc0204036:	03050513          	addi	a0,a0,48
ffffffffc020403a:	06f010ef          	jal	ra,ffffffffc02058a8 <memset>
        proc->tf = NULL;                    // 中断帧暂设为NULL（后续copy_thread构造）
        proc->pgdir = boot_pgdir_pa;        // 共享内核页表的物理地址（修复变量名错误，编译报错）
ffffffffc020403e:	000bc797          	auipc	a5,0xbc
ffffffffc0204042:	0d27b783          	ld	a5,210(a5) # ffffffffc02c0110 <boot_pgdir_pa>
        proc->tf = NULL;                    // 中断帧暂设为NULL（后续copy_thread构造）
ffffffffc0204046:	0a043023          	sd	zero,160(s0)
        proc->pgdir = boot_pgdir_pa;        // 共享内核页表的物理地址（修复变量名错误，编译报错）
ffffffffc020404a:	f45c                	sd	a5,168(s0)
        proc->flags = 0;                    // 标志位初始为0
ffffffffc020404c:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);  // 进程名清零
ffffffffc0204050:	4641                	li	a2,16
ffffffffc0204052:	4581                	li	a1,0
ffffffffc0204054:	0b440513          	addi	a0,s0,180
ffffffffc0204058:	051010ef          	jal	ra,ffffffffc02058a8 <memset>
        
        // LAB5: 初始化新增字段
        proc->wait_state = 0;               // 等待状态初始化为0
ffffffffc020405c:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;                  // 子进程指针
ffffffffc0204060:	0e043823          	sd	zero,240(s0)
        proc->yptr = NULL;                  // 弟弟进程指针
ffffffffc0204064:	0e043c23          	sd	zero,248(s0)
        proc->optr = NULL;                  // 哥哥进程指针
ffffffffc0204068:	10043023          	sd	zero,256(s0)
        
        // Lab5部分保持原样，我不修改
    }
    return proc;
}
ffffffffc020406c:	60a2                	ld	ra,8(sp)
ffffffffc020406e:	8522                	mv	a0,s0
ffffffffc0204070:	6402                	ld	s0,0(sp)
ffffffffc0204072:	0141                	addi	sp,sp,16
ffffffffc0204074:	8082                	ret

ffffffffc0204076 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0204076:	000bc797          	auipc	a5,0xbc
ffffffffc020407a:	0ca7b783          	ld	a5,202(a5) # ffffffffc02c0140 <current>
ffffffffc020407e:	73c8                	ld	a0,160(a5)
ffffffffc0204080:	95afd06f          	j	ffffffffc02011da <forkrets>

ffffffffc0204084 <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204084:	000bc797          	auipc	a5,0xbc
ffffffffc0204088:	0bc7b783          	ld	a5,188(a5) # ffffffffc02c0140 <current>
ffffffffc020408c:	43cc                	lw	a1,4(a5)
{
ffffffffc020408e:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204090:	00003617          	auipc	a2,0x3
ffffffffc0204094:	22060613          	addi	a2,a2,544 # ffffffffc02072b0 <default_pmm_manager+0x9d8>
ffffffffc0204098:	00003517          	auipc	a0,0x3
ffffffffc020409c:	22850513          	addi	a0,a0,552 # ffffffffc02072c0 <default_pmm_manager+0x9e8>
{
ffffffffc02040a0:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc02040a2:	8f2fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02040a6:	3fe07797          	auipc	a5,0x3fe07
ffffffffc02040aa:	17a78793          	addi	a5,a5,378 # b220 <_binary_obj___user_dirtycow_test_out_size>
ffffffffc02040ae:	e43e                	sd	a5,8(sp)
ffffffffc02040b0:	00003517          	auipc	a0,0x3
ffffffffc02040b4:	20050513          	addi	a0,a0,512 # ffffffffc02072b0 <default_pmm_manager+0x9d8>
ffffffffc02040b8:	00026797          	auipc	a5,0x26
ffffffffc02040bc:	65078793          	addi	a5,a5,1616 # ffffffffc022a708 <_binary_obj___user_dirtycow_test_out_start>
ffffffffc02040c0:	f03e                	sd	a5,32(sp)
ffffffffc02040c2:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc02040c4:	e802                	sd	zero,16(sp)
ffffffffc02040c6:	740010ef          	jal	ra,ffffffffc0205806 <strlen>
ffffffffc02040ca:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc02040cc:	4511                	li	a0,4
ffffffffc02040ce:	55a2                	lw	a1,40(sp)
ffffffffc02040d0:	4662                	lw	a2,24(sp)
ffffffffc02040d2:	5682                	lw	a3,32(sp)
ffffffffc02040d4:	4722                	lw	a4,8(sp)
ffffffffc02040d6:	48a9                	li	a7,10
ffffffffc02040d8:	9002                	ebreak
ffffffffc02040da:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc02040dc:	65c2                	ld	a1,16(sp)
ffffffffc02040de:	00003517          	auipc	a0,0x3
ffffffffc02040e2:	20a50513          	addi	a0,a0,522 # ffffffffc02072e8 <default_pmm_manager+0xa10>
ffffffffc02040e6:	8aefc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc02040ea:	00003617          	auipc	a2,0x3
ffffffffc02040ee:	20e60613          	addi	a2,a2,526 # ffffffffc02072f8 <default_pmm_manager+0xa20>
ffffffffc02040f2:	3cd00593          	li	a1,973
ffffffffc02040f6:	00003517          	auipc	a0,0x3
ffffffffc02040fa:	22250513          	addi	a0,a0,546 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc02040fe:	b90fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204102 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0204102:	6d14                	ld	a3,24(a0)
{
ffffffffc0204104:	1141                	addi	sp,sp,-16
ffffffffc0204106:	e406                	sd	ra,8(sp)
ffffffffc0204108:	c02007b7          	lui	a5,0xc0200
ffffffffc020410c:	02f6ee63          	bltu	a3,a5,ffffffffc0204148 <put_pgdir+0x46>
ffffffffc0204110:	000bc517          	auipc	a0,0xbc
ffffffffc0204114:	02853503          	ld	a0,40(a0) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0204118:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc020411a:	82b1                	srli	a3,a3,0xc
ffffffffc020411c:	000bc797          	auipc	a5,0xbc
ffffffffc0204120:	0047b783          	ld	a5,4(a5) # ffffffffc02c0120 <npage>
ffffffffc0204124:	02f6fe63          	bgeu	a3,a5,ffffffffc0204160 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0204128:	00004517          	auipc	a0,0x4
ffffffffc020412c:	a6053503          	ld	a0,-1440(a0) # ffffffffc0207b88 <nbase>
}
ffffffffc0204130:	60a2                	ld	ra,8(sp)
ffffffffc0204132:	8e89                	sub	a3,a3,a0
ffffffffc0204134:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0204136:	000bc517          	auipc	a0,0xbc
ffffffffc020413a:	ff253503          	ld	a0,-14(a0) # ffffffffc02c0128 <pages>
ffffffffc020413e:	4585                	li	a1,1
ffffffffc0204140:	9536                	add	a0,a0,a3
}
ffffffffc0204142:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0204144:	83efe06f          	j	ffffffffc0202182 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204148:	00003617          	auipc	a2,0x3
ffffffffc020414c:	83860613          	addi	a2,a2,-1992 # ffffffffc0206980 <default_pmm_manager+0xa8>
ffffffffc0204150:	07700593          	li	a1,119
ffffffffc0204154:	00002517          	auipc	a0,0x2
ffffffffc0204158:	25450513          	addi	a0,a0,596 # ffffffffc02063a8 <commands+0x868>
ffffffffc020415c:	b32fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204160:	00002617          	auipc	a2,0x2
ffffffffc0204164:	22860613          	addi	a2,a2,552 # ffffffffc0206388 <commands+0x848>
ffffffffc0204168:	06900593          	li	a1,105
ffffffffc020416c:	00002517          	auipc	a0,0x2
ffffffffc0204170:	23c50513          	addi	a0,a0,572 # ffffffffc02063a8 <commands+0x868>
ffffffffc0204174:	b1afc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204178 <proc_run>:
{
ffffffffc0204178:	7179                	addi	sp,sp,-48
ffffffffc020417a:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc020417c:	000bc917          	auipc	s2,0xbc
ffffffffc0204180:	fc490913          	addi	s2,s2,-60 # ffffffffc02c0140 <current>
{
ffffffffc0204184:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0204186:	00093483          	ld	s1,0(s2)
{
ffffffffc020418a:	f406                	sd	ra,40(sp)
ffffffffc020418c:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc020418e:	02a48863          	beq	s1,a0,ffffffffc02041be <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204192:	100027f3          	csrr	a5,sstatus
ffffffffc0204196:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204198:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020419a:	ef9d                	bnez	a5,ffffffffc02041d8 <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc020419c:	755c                	ld	a5,168(a0)
ffffffffc020419e:	577d                	li	a4,-1
ffffffffc02041a0:	177e                	slli	a4,a4,0x3f
ffffffffc02041a2:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc02041a4:	00a93023          	sd	a0,0(s2)
ffffffffc02041a8:	8fd9                	or	a5,a5,a4
ffffffffc02041aa:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc02041ae:	03050593          	addi	a1,a0,48
ffffffffc02041b2:	03048513          	addi	a0,s1,48
ffffffffc02041b6:	7f7000ef          	jal	ra,ffffffffc02051ac <switch_to>
    if (flag)
ffffffffc02041ba:	00099863          	bnez	s3,ffffffffc02041ca <proc_run+0x52>
}
ffffffffc02041be:	70a2                	ld	ra,40(sp)
ffffffffc02041c0:	7482                	ld	s1,32(sp)
ffffffffc02041c2:	6962                	ld	s2,24(sp)
ffffffffc02041c4:	69c2                	ld	s3,16(sp)
ffffffffc02041c6:	6145                	addi	sp,sp,48
ffffffffc02041c8:	8082                	ret
ffffffffc02041ca:	70a2                	ld	ra,40(sp)
ffffffffc02041cc:	7482                	ld	s1,32(sp)
ffffffffc02041ce:	6962                	ld	s2,24(sp)
ffffffffc02041d0:	69c2                	ld	s3,16(sp)
ffffffffc02041d2:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02041d4:	fdafc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc02041d8:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02041da:	fdafc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02041de:	6522                	ld	a0,8(sp)
ffffffffc02041e0:	4985                	li	s3,1
ffffffffc02041e2:	bf6d                	j	ffffffffc020419c <proc_run+0x24>

ffffffffc02041e4 <do_fork>:
{
ffffffffc02041e4:	7119                	addi	sp,sp,-128
ffffffffc02041e6:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02041e8:	000bc917          	auipc	s2,0xbc
ffffffffc02041ec:	f7090913          	addi	s2,s2,-144 # ffffffffc02c0158 <nr_process>
ffffffffc02041f0:	00092703          	lw	a4,0(s2)
{
ffffffffc02041f4:	fc86                	sd	ra,120(sp)
ffffffffc02041f6:	f8a2                	sd	s0,112(sp)
ffffffffc02041f8:	f4a6                	sd	s1,104(sp)
ffffffffc02041fa:	ecce                	sd	s3,88(sp)
ffffffffc02041fc:	e8d2                	sd	s4,80(sp)
ffffffffc02041fe:	e4d6                	sd	s5,72(sp)
ffffffffc0204200:	e0da                	sd	s6,64(sp)
ffffffffc0204202:	fc5e                	sd	s7,56(sp)
ffffffffc0204204:	f862                	sd	s8,48(sp)
ffffffffc0204206:	f466                	sd	s9,40(sp)
ffffffffc0204208:	f06a                	sd	s10,32(sp)
ffffffffc020420a:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc020420c:	6785                	lui	a5,0x1
ffffffffc020420e:	2ef75b63          	bge	a4,a5,ffffffffc0204504 <do_fork+0x320>
ffffffffc0204212:	8a2a                	mv	s4,a0
ffffffffc0204214:	89ae                	mv	s3,a1
ffffffffc0204216:	8432                	mv	s0,a2
    proc = alloc_proc();
ffffffffc0204218:	dedff0ef          	jal	ra,ffffffffc0204004 <alloc_proc>
ffffffffc020421c:	84aa                	mv	s1,a0
    if (!proc) {
ffffffffc020421e:	2e050863          	beqz	a0,ffffffffc020450e <do_fork+0x32a>
    proc->parent = current;
ffffffffc0204222:	000bcc17          	auipc	s8,0xbc
ffffffffc0204226:	f1ec0c13          	addi	s8,s8,-226 # ffffffffc02c0140 <current>
ffffffffc020422a:	000c3783          	ld	a5,0(s8)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020422e:	4509                	li	a0,2
    proc->parent = current;
ffffffffc0204230:	f09c                	sd	a5,32(s1)
    current->wait_state = 0;
ffffffffc0204232:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8ac4>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204236:	f0ffd0ef          	jal	ra,ffffffffc0202144 <alloc_pages>
    if (page != NULL)
ffffffffc020423a:	2a050563          	beqz	a0,ffffffffc02044e4 <do_fork+0x300>
    return page - pages + nbase;
ffffffffc020423e:	000bca97          	auipc	s5,0xbc
ffffffffc0204242:	eeaa8a93          	addi	s5,s5,-278 # ffffffffc02c0128 <pages>
ffffffffc0204246:	000ab683          	ld	a3,0(s5)
ffffffffc020424a:	00004b17          	auipc	s6,0x4
ffffffffc020424e:	93eb0b13          	addi	s6,s6,-1730 # ffffffffc0207b88 <nbase>
ffffffffc0204252:	000b3783          	ld	a5,0(s6)
ffffffffc0204256:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc020425a:	000bcb97          	auipc	s7,0xbc
ffffffffc020425e:	ec6b8b93          	addi	s7,s7,-314 # ffffffffc02c0120 <npage>
    return page - pages + nbase;
ffffffffc0204262:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204264:	5dfd                	li	s11,-1
ffffffffc0204266:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc020426a:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020426c:	00cddd93          	srli	s11,s11,0xc
ffffffffc0204270:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204274:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204276:	2ee67363          	bgeu	a2,a4,ffffffffc020455c <do_fork+0x378>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc020427a:	000c3603          	ld	a2,0(s8)
ffffffffc020427e:	000bcc17          	auipc	s8,0xbc
ffffffffc0204282:	ebac0c13          	addi	s8,s8,-326 # ffffffffc02c0138 <va_pa_offset>
ffffffffc0204286:	000c3703          	ld	a4,0(s8)
ffffffffc020428a:	02863d03          	ld	s10,40(a2)
ffffffffc020428e:	e43e                	sd	a5,8(sp)
ffffffffc0204290:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204292:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0204294:	020d0863          	beqz	s10,ffffffffc02042c4 <do_fork+0xe0>
    if (clone_flags & CLONE_VM)
ffffffffc0204298:	100a7a13          	andi	s4,s4,256
ffffffffc020429c:	180a0663          	beqz	s4,ffffffffc0204428 <do_fork+0x244>
    mm->mm_count += 1;
ffffffffc02042a0:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042a4:	018d3783          	ld	a5,24(s10)
ffffffffc02042a8:	c02006b7          	lui	a3,0xc0200
ffffffffc02042ac:	2705                	addiw	a4,a4,1
ffffffffc02042ae:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc02042b2:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042b6:	26d7ea63          	bltu	a5,a3,ffffffffc020452a <do_fork+0x346>
ffffffffc02042ba:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042be:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042c0:	8f99                	sub	a5,a5,a4
ffffffffc02042c2:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042c4:	6789                	lui	a5,0x2
ffffffffc02042c6:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>
ffffffffc02042ca:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02042cc:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02042ce:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02042d0:	87b6                	mv	a5,a3
ffffffffc02042d2:	12040893          	addi	a7,s0,288
ffffffffc02042d6:	00063803          	ld	a6,0(a2)
ffffffffc02042da:	6608                	ld	a0,8(a2)
ffffffffc02042dc:	6a0c                	ld	a1,16(a2)
ffffffffc02042de:	6e18                	ld	a4,24(a2)
ffffffffc02042e0:	0107b023          	sd	a6,0(a5)
ffffffffc02042e4:	e788                	sd	a0,8(a5)
ffffffffc02042e6:	eb8c                	sd	a1,16(a5)
ffffffffc02042e8:	ef98                	sd	a4,24(a5)
ffffffffc02042ea:	02060613          	addi	a2,a2,32
ffffffffc02042ee:	02078793          	addi	a5,a5,32
ffffffffc02042f2:	ff1612e3          	bne	a2,a7,ffffffffc02042d6 <do_fork+0xf2>
    proc->tf->gpr.a0 = 0;
ffffffffc02042f6:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02042fa:	12098563          	beqz	s3,ffffffffc0204424 <do_fork+0x240>
    if (++last_pid >= MAX_PID)
ffffffffc02042fe:	000b8317          	auipc	t1,0xb8
ffffffffc0204302:	9b230313          	addi	t1,t1,-1614 # ffffffffc02bbcb0 <last_pid.1>
ffffffffc0204306:	00032783          	lw	a5,0(t1)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020430a:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020430e:	00000717          	auipc	a4,0x0
ffffffffc0204312:	d6870713          	addi	a4,a4,-664 # ffffffffc0204076 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0204316:	0017851b          	addiw	a0,a5,1
ffffffffc020431a:	000bc617          	auipc	a2,0xbc
ffffffffc020431e:	db660613          	addi	a2,a2,-586 # ffffffffc02c00d0 <proc_list>
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204322:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204324:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc0204326:	00a32023          	sw	a0,0(t1)
ffffffffc020432a:	6789                	lui	a5,0x2
ffffffffc020432c:	00863883          	ld	a7,8(a2)
ffffffffc0204330:	08f55863          	bge	a0,a5,ffffffffc02043c0 <do_fork+0x1dc>
    if (last_pid >= next_safe)
ffffffffc0204334:	000b8e97          	auipc	t4,0xb8
ffffffffc0204338:	980e8e93          	addi	t4,t4,-1664 # ffffffffc02bbcb4 <next_safe.0>
ffffffffc020433c:	000ea783          	lw	a5,0(t4)
ffffffffc0204340:	08f55863          	bge	a0,a5,ffffffffc02043d0 <do_fork+0x1ec>
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204344:	7094                	ld	a3,32(s1)
    proc->pid = get_pid();// 调用get_pid()分配唯一的pid
ffffffffc0204346:	c0c8                	sw	a0,4(s1)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204348:	0c848793          	addi	a5,s1,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020434c:	7af8                	ld	a4,240(a3)
    prev->next = next->prev = elm;
ffffffffc020434e:	00f8b023          	sd	a5,0(a7) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0204352:	e61c                	sd	a5,8(a2)
    elm->next = next;
ffffffffc0204354:	0d14b823          	sd	a7,208(s1)
    elm->prev = prev;
ffffffffc0204358:	e4f0                	sd	a2,200(s1)
    proc->yptr = NULL;
ffffffffc020435a:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020435e:	10e4b023          	sd	a4,256(s1)
ffffffffc0204362:	c311                	beqz	a4,ffffffffc0204366 <do_fork+0x182>
        proc->optr->yptr = proc;
ffffffffc0204364:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0204366:	00092783          	lw	a5,0(s2)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020436a:	45a9                	li	a1,10
    proc->parent->cptr = proc;
ffffffffc020436c:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc020436e:	2785                	addiw	a5,a5,1
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204370:	2501                	sext.w	a0,a0
    nr_process++;
ffffffffc0204372:	00f92023          	sw	a5,0(s2)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204376:	08c010ef          	jal	ra,ffffffffc0205402 <hash32>
ffffffffc020437a:	02051713          	slli	a4,a0,0x20
ffffffffc020437e:	01c75793          	srli	a5,a4,0x1c
ffffffffc0204382:	000b8517          	auipc	a0,0xb8
ffffffffc0204386:	d4e50513          	addi	a0,a0,-690 # ffffffffc02bc0d0 <hash_list>
ffffffffc020438a:	97aa                	add	a5,a5,a0
    __list_add(elm, listelm, listelm->next);
ffffffffc020438c:	6798                	ld	a4,8(a5)
ffffffffc020438e:	0d848693          	addi	a3,s1,216
    wakeup_proc(proc);
ffffffffc0204392:	8526                	mv	a0,s1
    prev->next = next->prev = elm;
ffffffffc0204394:	e314                	sd	a3,0(a4)
ffffffffc0204396:	e794                	sd	a3,8(a5)
    elm->next = next;
ffffffffc0204398:	f0f8                	sd	a4,224(s1)
    elm->prev = prev;
ffffffffc020439a:	ecfc                	sd	a5,216(s1)
ffffffffc020439c:	67b000ef          	jal	ra,ffffffffc0205216 <wakeup_proc>
    ret = proc->pid;
ffffffffc02043a0:	40c8                	lw	a0,4(s1)
}
ffffffffc02043a2:	70e6                	ld	ra,120(sp)
ffffffffc02043a4:	7446                	ld	s0,112(sp)
ffffffffc02043a6:	74a6                	ld	s1,104(sp)
ffffffffc02043a8:	7906                	ld	s2,96(sp)
ffffffffc02043aa:	69e6                	ld	s3,88(sp)
ffffffffc02043ac:	6a46                	ld	s4,80(sp)
ffffffffc02043ae:	6aa6                	ld	s5,72(sp)
ffffffffc02043b0:	6b06                	ld	s6,64(sp)
ffffffffc02043b2:	7be2                	ld	s7,56(sp)
ffffffffc02043b4:	7c42                	ld	s8,48(sp)
ffffffffc02043b6:	7ca2                	ld	s9,40(sp)
ffffffffc02043b8:	7d02                	ld	s10,32(sp)
ffffffffc02043ba:	6de2                	ld	s11,24(sp)
ffffffffc02043bc:	6109                	addi	sp,sp,128
ffffffffc02043be:	8082                	ret
        last_pid = 1;
ffffffffc02043c0:	4785                	li	a5,1
ffffffffc02043c2:	00f32023          	sw	a5,0(t1)
        goto inside;
ffffffffc02043c6:	4505                	li	a0,1
ffffffffc02043c8:	000b8e97          	auipc	t4,0xb8
ffffffffc02043cc:	8ece8e93          	addi	t4,t4,-1812 # ffffffffc02bbcb4 <next_safe.0>
        next_safe = MAX_PID;
ffffffffc02043d0:	6789                	lui	a5,0x2
ffffffffc02043d2:	00fea023          	sw	a5,0(t4)
ffffffffc02043d6:	86aa                	mv	a3,a0
ffffffffc02043d8:	4801                	li	a6,0
        while ((le = list_next(le)) != list)
ffffffffc02043da:	6f09                	lui	t5,0x2
ffffffffc02043dc:	10c88e63          	beq	a7,a2,ffffffffc02044f8 <do_fork+0x314>
ffffffffc02043e0:	8e42                	mv	t3,a6
ffffffffc02043e2:	87c6                	mv	a5,a7
ffffffffc02043e4:	6589                	lui	a1,0x2
ffffffffc02043e6:	a811                	j	ffffffffc02043fa <do_fork+0x216>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02043e8:	00e6d663          	bge	a3,a4,ffffffffc02043f4 <do_fork+0x210>
ffffffffc02043ec:	00b75463          	bge	a4,a1,ffffffffc02043f4 <do_fork+0x210>
ffffffffc02043f0:	85ba                	mv	a1,a4
ffffffffc02043f2:	4e05                	li	t3,1
    return listelm->next;
ffffffffc02043f4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02043f6:	00c78d63          	beq	a5,a2,ffffffffc0204410 <do_fork+0x22c>
            if (proc->pid == last_pid)
ffffffffc02043fa:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c74>
ffffffffc02043fe:	fed715e3          	bne	a4,a3,ffffffffc02043e8 <do_fork+0x204>
                if (++last_pid >= next_safe)
ffffffffc0204402:	2685                	addiw	a3,a3,1
ffffffffc0204404:	0eb6d563          	bge	a3,a1,ffffffffc02044ee <do_fork+0x30a>
ffffffffc0204408:	679c                	ld	a5,8(a5)
ffffffffc020440a:	4805                	li	a6,1
        while ((le = list_next(le)) != list)
ffffffffc020440c:	fec797e3          	bne	a5,a2,ffffffffc02043fa <do_fork+0x216>
ffffffffc0204410:	00080563          	beqz	a6,ffffffffc020441a <do_fork+0x236>
ffffffffc0204414:	00d32023          	sw	a3,0(t1)
ffffffffc0204418:	8536                	mv	a0,a3
ffffffffc020441a:	f20e05e3          	beqz	t3,ffffffffc0204344 <do_fork+0x160>
ffffffffc020441e:	00bea023          	sw	a1,0(t4)
ffffffffc0204422:	b70d                	j	ffffffffc0204344 <do_fork+0x160>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204424:	89b6                	mv	s3,a3
ffffffffc0204426:	bde1                	j	ffffffffc02042fe <do_fork+0x11a>
    if ((mm = mm_create()) == NULL)
ffffffffc0204428:	ccaff0ef          	jal	ra,ffffffffc02038f2 <mm_create>
ffffffffc020442c:	8caa                	mv	s9,a0
ffffffffc020442e:	c159                	beqz	a0,ffffffffc02044b4 <do_fork+0x2d0>
    if ((page = alloc_page()) == NULL)
ffffffffc0204430:	4505                	li	a0,1
ffffffffc0204432:	d13fd0ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc0204436:	cd25                	beqz	a0,ffffffffc02044ae <do_fork+0x2ca>
    return page - pages + nbase;
ffffffffc0204438:	000ab683          	ld	a3,0(s5)
ffffffffc020443c:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc020443e:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204442:	40d506b3          	sub	a3,a0,a3
ffffffffc0204446:	8699                	srai	a3,a3,0x6
ffffffffc0204448:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020444a:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020444e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204450:	10edf663          	bgeu	s11,a4,ffffffffc020455c <do_fork+0x378>
ffffffffc0204454:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204458:	6605                	lui	a2,0x1
ffffffffc020445a:	000bc597          	auipc	a1,0xbc
ffffffffc020445e:	cbe5b583          	ld	a1,-834(a1) # ffffffffc02c0118 <boot_pgdir_va>
ffffffffc0204462:	9a36                	add	s4,s4,a3
ffffffffc0204464:	8552                	mv	a0,s4
ffffffffc0204466:	454010ef          	jal	ra,ffffffffc02058ba <memcpy>
        lock(&(mm->mm_lock));
ffffffffc020446a:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc020446e:	014cbc23          	sd	s4,24(s9)
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204472:	4785                	li	a5,1
ffffffffc0204474:	40fdb7af          	amoor.d	a5,a5,(s11)
    while (!try_lock(lock))
ffffffffc0204478:	8b85                	andi	a5,a5,1
ffffffffc020447a:	4a05                	li	s4,1
ffffffffc020447c:	c799                	beqz	a5,ffffffffc020448a <do_fork+0x2a6>
        schedule();
ffffffffc020447e:	619000ef          	jal	ra,ffffffffc0205296 <schedule>
ffffffffc0204482:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc0204486:	8b85                	andi	a5,a5,1
ffffffffc0204488:	fbfd                	bnez	a5,ffffffffc020447e <do_fork+0x29a>
        ret = dup_mmap(mm, oldmm);
ffffffffc020448a:	85ea                	mv	a1,s10
ffffffffc020448c:	8566                	mv	a0,s9
ffffffffc020448e:	ea6ff0ef          	jal	ra,ffffffffc0203b34 <dup_mmap>
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204492:	57f9                	li	a5,-2
ffffffffc0204494:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc0204498:	8b85                	andi	a5,a5,1
    if (!test_and_clear_bit(0, lock))
ffffffffc020449a:	cfa5                	beqz	a5,ffffffffc0204512 <do_fork+0x32e>
good_mm:
ffffffffc020449c:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc020449e:	e00501e3          	beqz	a0,ffffffffc02042a0 <do_fork+0xbc>
    exit_mmap(mm);
ffffffffc02044a2:	8566                	mv	a0,s9
ffffffffc02044a4:	f2aff0ef          	jal	ra,ffffffffc0203bce <exit_mmap>
    put_pgdir(mm);
ffffffffc02044a8:	8566                	mv	a0,s9
ffffffffc02044aa:	c59ff0ef          	jal	ra,ffffffffc0204102 <put_pgdir>
    mm_destroy(mm);
ffffffffc02044ae:	8566                	mv	a0,s9
ffffffffc02044b0:	d82ff0ef          	jal	ra,ffffffffc0203a32 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02044b4:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02044b6:	c02007b7          	lui	a5,0xc0200
ffffffffc02044ba:	0af6ed63          	bltu	a3,a5,ffffffffc0204574 <do_fork+0x390>
ffffffffc02044be:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02044c2:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02044c6:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02044ca:	83b1                	srli	a5,a5,0xc
ffffffffc02044cc:	06e7fc63          	bgeu	a5,a4,ffffffffc0204544 <do_fork+0x360>
    return &pages[PPN(pa) - nbase];
ffffffffc02044d0:	000b3703          	ld	a4,0(s6)
ffffffffc02044d4:	000ab503          	ld	a0,0(s5)
ffffffffc02044d8:	4589                	li	a1,2
ffffffffc02044da:	8f99                	sub	a5,a5,a4
ffffffffc02044dc:	079a                	slli	a5,a5,0x6
ffffffffc02044de:	953e                	add	a0,a0,a5
ffffffffc02044e0:	ca3fd0ef          	jal	ra,ffffffffc0202182 <free_pages>
    kfree(proc);
ffffffffc02044e4:	8526                	mv	a0,s1
ffffffffc02044e6:	b31fd0ef          	jal	ra,ffffffffc0202016 <kfree>
    ret = -E_NO_MEM;
ffffffffc02044ea:	5571                	li	a0,-4
    goto fork_out;
ffffffffc02044ec:	bd5d                	j	ffffffffc02043a2 <do_fork+0x1be>
                    if (last_pid >= MAX_PID)
ffffffffc02044ee:	01e6c363          	blt	a3,t5,ffffffffc02044f4 <do_fork+0x310>
                        last_pid = 1;
ffffffffc02044f2:	4685                	li	a3,1
                    goto repeat;
ffffffffc02044f4:	4805                	li	a6,1
ffffffffc02044f6:	b5dd                	j	ffffffffc02043dc <do_fork+0x1f8>
ffffffffc02044f8:	00080863          	beqz	a6,ffffffffc0204508 <do_fork+0x324>
ffffffffc02044fc:	00d32023          	sw	a3,0(t1)
    return last_pid;
ffffffffc0204500:	8536                	mv	a0,a3
ffffffffc0204502:	b589                	j	ffffffffc0204344 <do_fork+0x160>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204504:	556d                	li	a0,-5
ffffffffc0204506:	bd71                	j	ffffffffc02043a2 <do_fork+0x1be>
    return last_pid;
ffffffffc0204508:	00032503          	lw	a0,0(t1)
ffffffffc020450c:	bd25                	j	ffffffffc0204344 <do_fork+0x160>
    ret = -E_NO_MEM;
ffffffffc020450e:	5571                	li	a0,-4
ffffffffc0204510:	bd49                	j	ffffffffc02043a2 <do_fork+0x1be>
        panic("Unlock failed.\n");
ffffffffc0204512:	00002617          	auipc	a2,0x2
ffffffffc0204516:	e4e60613          	addi	a2,a2,-434 # ffffffffc0206360 <commands+0x820>
ffffffffc020451a:	03f00593          	li	a1,63
ffffffffc020451e:	00002517          	auipc	a0,0x2
ffffffffc0204522:	e5250513          	addi	a0,a0,-430 # ffffffffc0206370 <commands+0x830>
ffffffffc0204526:	f69fb0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020452a:	86be                	mv	a3,a5
ffffffffc020452c:	00002617          	auipc	a2,0x2
ffffffffc0204530:	45460613          	addi	a2,a2,1108 # ffffffffc0206980 <default_pmm_manager+0xa8>
ffffffffc0204534:	19600593          	li	a1,406
ffffffffc0204538:	00003517          	auipc	a0,0x3
ffffffffc020453c:	de050513          	addi	a0,a0,-544 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204540:	f4ffb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204544:	00002617          	auipc	a2,0x2
ffffffffc0204548:	e4460613          	addi	a2,a2,-444 # ffffffffc0206388 <commands+0x848>
ffffffffc020454c:	06900593          	li	a1,105
ffffffffc0204550:	00002517          	auipc	a0,0x2
ffffffffc0204554:	e5850513          	addi	a0,a0,-424 # ffffffffc02063a8 <commands+0x868>
ffffffffc0204558:	f37fb0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc020455c:	00002617          	auipc	a2,0x2
ffffffffc0204560:	efc60613          	addi	a2,a2,-260 # ffffffffc0206458 <commands+0x918>
ffffffffc0204564:	07100593          	li	a1,113
ffffffffc0204568:	00002517          	auipc	a0,0x2
ffffffffc020456c:	e4050513          	addi	a0,a0,-448 # ffffffffc02063a8 <commands+0x868>
ffffffffc0204570:	f1ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204574:	00002617          	auipc	a2,0x2
ffffffffc0204578:	40c60613          	addi	a2,a2,1036 # ffffffffc0206980 <default_pmm_manager+0xa8>
ffffffffc020457c:	07700593          	li	a1,119
ffffffffc0204580:	00002517          	auipc	a0,0x2
ffffffffc0204584:	e2850513          	addi	a0,a0,-472 # ffffffffc02063a8 <commands+0x868>
ffffffffc0204588:	f07fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020458c <kernel_thread>:
{
ffffffffc020458c:	7129                	addi	sp,sp,-320
ffffffffc020458e:	fa22                	sd	s0,304(sp)
ffffffffc0204590:	f626                	sd	s1,296(sp)
ffffffffc0204592:	f24a                	sd	s2,288(sp)
ffffffffc0204594:	84ae                	mv	s1,a1
ffffffffc0204596:	892a                	mv	s2,a0
ffffffffc0204598:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020459a:	4581                	li	a1,0
ffffffffc020459c:	12000613          	li	a2,288
ffffffffc02045a0:	850a                	mv	a0,sp
{
ffffffffc02045a2:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02045a4:	304010ef          	jal	ra,ffffffffc02058a8 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02045a8:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02045aa:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02045ac:	100027f3          	csrr	a5,sstatus
ffffffffc02045b0:	edd7f793          	andi	a5,a5,-291
ffffffffc02045b4:	1207e793          	ori	a5,a5,288
ffffffffc02045b8:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045ba:	860a                	mv	a2,sp
ffffffffc02045bc:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02045c0:	00000797          	auipc	a5,0x0
ffffffffc02045c4:	a3c78793          	addi	a5,a5,-1476 # ffffffffc0203ffc <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045c8:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02045ca:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045cc:	c19ff0ef          	jal	ra,ffffffffc02041e4 <do_fork>
}
ffffffffc02045d0:	70f2                	ld	ra,312(sp)
ffffffffc02045d2:	7452                	ld	s0,304(sp)
ffffffffc02045d4:	74b2                	ld	s1,296(sp)
ffffffffc02045d6:	7912                	ld	s2,288(sp)
ffffffffc02045d8:	6131                	addi	sp,sp,320
ffffffffc02045da:	8082                	ret

ffffffffc02045dc <do_exit>:
{
ffffffffc02045dc:	7179                	addi	sp,sp,-48
ffffffffc02045de:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc02045e0:	000bc417          	auipc	s0,0xbc
ffffffffc02045e4:	b6040413          	addi	s0,s0,-1184 # ffffffffc02c0140 <current>
ffffffffc02045e8:	601c                	ld	a5,0(s0)
{
ffffffffc02045ea:	f406                	sd	ra,40(sp)
ffffffffc02045ec:	ec26                	sd	s1,24(sp)
ffffffffc02045ee:	e84a                	sd	s2,16(sp)
ffffffffc02045f0:	e44e                	sd	s3,8(sp)
ffffffffc02045f2:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc02045f4:	000bc717          	auipc	a4,0xbc
ffffffffc02045f8:	b5473703          	ld	a4,-1196(a4) # ffffffffc02c0148 <idleproc>
ffffffffc02045fc:	0ce78c63          	beq	a5,a4,ffffffffc02046d4 <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204600:	000bc497          	auipc	s1,0xbc
ffffffffc0204604:	b5048493          	addi	s1,s1,-1200 # ffffffffc02c0150 <initproc>
ffffffffc0204608:	6098                	ld	a4,0(s1)
ffffffffc020460a:	0ee78b63          	beq	a5,a4,ffffffffc0204700 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc020460e:	0287b983          	ld	s3,40(a5)
ffffffffc0204612:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204614:	02098663          	beqz	s3,ffffffffc0204640 <do_exit+0x64>
ffffffffc0204618:	000bc797          	auipc	a5,0xbc
ffffffffc020461c:	af87b783          	ld	a5,-1288(a5) # ffffffffc02c0110 <boot_pgdir_pa>
ffffffffc0204620:	577d                	li	a4,-1
ffffffffc0204622:	177e                	slli	a4,a4,0x3f
ffffffffc0204624:	83b1                	srli	a5,a5,0xc
ffffffffc0204626:	8fd9                	or	a5,a5,a4
ffffffffc0204628:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020462c:	0309a783          	lw	a5,48(s3)
ffffffffc0204630:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204634:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204638:	cb55                	beqz	a4,ffffffffc02046ec <do_exit+0x110>
        current->mm = NULL;
ffffffffc020463a:	601c                	ld	a5,0(s0)
ffffffffc020463c:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204640:	601c                	ld	a5,0(s0)
ffffffffc0204642:	470d                	li	a4,3
ffffffffc0204644:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204646:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020464a:	100027f3          	csrr	a5,sstatus
ffffffffc020464e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204650:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204652:	e3f9                	bnez	a5,ffffffffc0204718 <do_exit+0x13c>
        proc = current->parent;
ffffffffc0204654:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204656:	800007b7          	lui	a5,0x80000
ffffffffc020465a:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc020465c:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc020465e:	0ec52703          	lw	a4,236(a0)
ffffffffc0204662:	0af70f63          	beq	a4,a5,ffffffffc0204720 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc0204666:	6018                	ld	a4,0(s0)
ffffffffc0204668:	7b7c                	ld	a5,240(a4)
ffffffffc020466a:	c3a1                	beqz	a5,ffffffffc02046aa <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020466c:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204670:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204672:	0985                	addi	s3,s3,1
ffffffffc0204674:	a021                	j	ffffffffc020467c <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc0204676:	6018                	ld	a4,0(s0)
ffffffffc0204678:	7b7c                	ld	a5,240(a4)
ffffffffc020467a:	cb85                	beqz	a5,ffffffffc02046aa <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc020467c:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_dirtycow_test_out_size+0xffffffff7fff4ee0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204680:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204682:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204684:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc0204686:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020468a:	10e7b023          	sd	a4,256(a5)
ffffffffc020468e:	c311                	beqz	a4,ffffffffc0204692 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc0204690:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204692:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0204694:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0204696:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204698:	fd271fe3          	bne	a4,s2,ffffffffc0204676 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020469c:	0ec52783          	lw	a5,236(a0)
ffffffffc02046a0:	fd379be3          	bne	a5,s3,ffffffffc0204676 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02046a4:	373000ef          	jal	ra,ffffffffc0205216 <wakeup_proc>
ffffffffc02046a8:	b7f9                	j	ffffffffc0204676 <do_exit+0x9a>
    if (flag)
ffffffffc02046aa:	020a1263          	bnez	s4,ffffffffc02046ce <do_exit+0xf2>
    schedule();
ffffffffc02046ae:	3e9000ef          	jal	ra,ffffffffc0205296 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02046b2:	601c                	ld	a5,0(s0)
ffffffffc02046b4:	00003617          	auipc	a2,0x3
ffffffffc02046b8:	c9c60613          	addi	a2,a2,-868 # ffffffffc0207350 <default_pmm_manager+0xa78>
ffffffffc02046bc:	24e00593          	li	a1,590
ffffffffc02046c0:	43d4                	lw	a3,4(a5)
ffffffffc02046c2:	00003517          	auipc	a0,0x3
ffffffffc02046c6:	c5650513          	addi	a0,a0,-938 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc02046ca:	dc5fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc02046ce:	ae0fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02046d2:	bff1                	j	ffffffffc02046ae <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc02046d4:	00003617          	auipc	a2,0x3
ffffffffc02046d8:	c5c60613          	addi	a2,a2,-932 # ffffffffc0207330 <default_pmm_manager+0xa58>
ffffffffc02046dc:	21a00593          	li	a1,538
ffffffffc02046e0:	00003517          	auipc	a0,0x3
ffffffffc02046e4:	c3850513          	addi	a0,a0,-968 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc02046e8:	da7fb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc02046ec:	854e                	mv	a0,s3
ffffffffc02046ee:	ce0ff0ef          	jal	ra,ffffffffc0203bce <exit_mmap>
            put_pgdir(mm);
ffffffffc02046f2:	854e                	mv	a0,s3
ffffffffc02046f4:	a0fff0ef          	jal	ra,ffffffffc0204102 <put_pgdir>
            mm_destroy(mm);
ffffffffc02046f8:	854e                	mv	a0,s3
ffffffffc02046fa:	b38ff0ef          	jal	ra,ffffffffc0203a32 <mm_destroy>
ffffffffc02046fe:	bf35                	j	ffffffffc020463a <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204700:	00003617          	auipc	a2,0x3
ffffffffc0204704:	c4060613          	addi	a2,a2,-960 # ffffffffc0207340 <default_pmm_manager+0xa68>
ffffffffc0204708:	21e00593          	li	a1,542
ffffffffc020470c:	00003517          	auipc	a0,0x3
ffffffffc0204710:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204714:	d7bfb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc0204718:	a9cfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020471c:	4a05                	li	s4,1
ffffffffc020471e:	bf1d                	j	ffffffffc0204654 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204720:	2f7000ef          	jal	ra,ffffffffc0205216 <wakeup_proc>
ffffffffc0204724:	b789                	j	ffffffffc0204666 <do_exit+0x8a>

ffffffffc0204726 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204726:	715d                	addi	sp,sp,-80
ffffffffc0204728:	f84a                	sd	s2,48(sp)
ffffffffc020472a:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc020472c:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204730:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204732:	fc26                	sd	s1,56(sp)
ffffffffc0204734:	f052                	sd	s4,32(sp)
ffffffffc0204736:	ec56                	sd	s5,24(sp)
ffffffffc0204738:	e85a                	sd	s6,16(sp)
ffffffffc020473a:	e45e                	sd	s7,8(sp)
ffffffffc020473c:	e486                	sd	ra,72(sp)
ffffffffc020473e:	e0a2                	sd	s0,64(sp)
ffffffffc0204740:	84aa                	mv	s1,a0
ffffffffc0204742:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc0204744:	000bcb97          	auipc	s7,0xbc
ffffffffc0204748:	9fcb8b93          	addi	s7,s7,-1540 # ffffffffc02c0140 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc020474c:	00050b1b          	sext.w	s6,a0
ffffffffc0204750:	fff50a9b          	addiw	s5,a0,-1
ffffffffc0204754:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc0204756:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204758:	ccbd                	beqz	s1,ffffffffc02047d6 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc020475a:	0359e863          	bltu	s3,s5,ffffffffc020478a <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020475e:	45a9                	li	a1,10
ffffffffc0204760:	855a                	mv	a0,s6
ffffffffc0204762:	4a1000ef          	jal	ra,ffffffffc0205402 <hash32>
ffffffffc0204766:	02051793          	slli	a5,a0,0x20
ffffffffc020476a:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020476e:	000b8797          	auipc	a5,0xb8
ffffffffc0204772:	96278793          	addi	a5,a5,-1694 # ffffffffc02bc0d0 <hash_list>
ffffffffc0204776:	953e                	add	a0,a0,a5
ffffffffc0204778:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc020477a:	a029                	j	ffffffffc0204784 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc020477c:	f2c42783          	lw	a5,-212(s0)
ffffffffc0204780:	02978163          	beq	a5,s1,ffffffffc02047a2 <do_wait.part.0+0x7c>
ffffffffc0204784:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc0204786:	fe851be3          	bne	a0,s0,ffffffffc020477c <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc020478a:	5579                	li	a0,-2
}
ffffffffc020478c:	60a6                	ld	ra,72(sp)
ffffffffc020478e:	6406                	ld	s0,64(sp)
ffffffffc0204790:	74e2                	ld	s1,56(sp)
ffffffffc0204792:	7942                	ld	s2,48(sp)
ffffffffc0204794:	79a2                	ld	s3,40(sp)
ffffffffc0204796:	7a02                	ld	s4,32(sp)
ffffffffc0204798:	6ae2                	ld	s5,24(sp)
ffffffffc020479a:	6b42                	ld	s6,16(sp)
ffffffffc020479c:	6ba2                	ld	s7,8(sp)
ffffffffc020479e:	6161                	addi	sp,sp,80
ffffffffc02047a0:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02047a2:	000bb683          	ld	a3,0(s7)
ffffffffc02047a6:	f4843783          	ld	a5,-184(s0)
ffffffffc02047aa:	fed790e3          	bne	a5,a3,ffffffffc020478a <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047ae:	f2842703          	lw	a4,-216(s0)
ffffffffc02047b2:	478d                	li	a5,3
ffffffffc02047b4:	0ef70b63          	beq	a4,a5,ffffffffc02048aa <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02047b8:	4785                	li	a5,1
ffffffffc02047ba:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02047bc:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc02047c0:	2d7000ef          	jal	ra,ffffffffc0205296 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02047c4:	000bb783          	ld	a5,0(s7)
ffffffffc02047c8:	0b07a783          	lw	a5,176(a5)
ffffffffc02047cc:	8b85                	andi	a5,a5,1
ffffffffc02047ce:	d7c9                	beqz	a5,ffffffffc0204758 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc02047d0:	555d                	li	a0,-9
ffffffffc02047d2:	e0bff0ef          	jal	ra,ffffffffc02045dc <do_exit>
        proc = current->cptr;
ffffffffc02047d6:	000bb683          	ld	a3,0(s7)
ffffffffc02047da:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc02047dc:	d45d                	beqz	s0,ffffffffc020478a <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047de:	470d                	li	a4,3
ffffffffc02047e0:	a021                	j	ffffffffc02047e8 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc02047e2:	10043403          	ld	s0,256(s0)
ffffffffc02047e6:	d869                	beqz	s0,ffffffffc02047b8 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047e8:	401c                	lw	a5,0(s0)
ffffffffc02047ea:	fee79ce3          	bne	a5,a4,ffffffffc02047e2 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc02047ee:	000bc797          	auipc	a5,0xbc
ffffffffc02047f2:	95a7b783          	ld	a5,-1702(a5) # ffffffffc02c0148 <idleproc>
ffffffffc02047f6:	0c878963          	beq	a5,s0,ffffffffc02048c8 <do_wait.part.0+0x1a2>
ffffffffc02047fa:	000bc797          	auipc	a5,0xbc
ffffffffc02047fe:	9567b783          	ld	a5,-1706(a5) # ffffffffc02c0150 <initproc>
ffffffffc0204802:	0cf40363          	beq	s0,a5,ffffffffc02048c8 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204806:	000a0663          	beqz	s4,ffffffffc0204812 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc020480a:	0e842783          	lw	a5,232(s0)
ffffffffc020480e:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204812:	100027f3          	csrr	a5,sstatus
ffffffffc0204816:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204818:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020481a:	e7c1                	bnez	a5,ffffffffc02048a2 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020481c:	6c70                	ld	a2,216(s0)
ffffffffc020481e:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204820:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204824:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204826:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204828:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020482a:	6470                	ld	a2,200(s0)
ffffffffc020482c:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc020482e:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204830:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204832:	c319                	beqz	a4,ffffffffc0204838 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0204834:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204836:	7c7c                	ld	a5,248(s0)
ffffffffc0204838:	c3b5                	beqz	a5,ffffffffc020489c <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc020483a:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc020483e:	000bc717          	auipc	a4,0xbc
ffffffffc0204842:	91a70713          	addi	a4,a4,-1766 # ffffffffc02c0158 <nr_process>
ffffffffc0204846:	431c                	lw	a5,0(a4)
ffffffffc0204848:	37fd                	addiw	a5,a5,-1
ffffffffc020484a:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc020484c:	e5a9                	bnez	a1,ffffffffc0204896 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020484e:	6814                	ld	a3,16(s0)
ffffffffc0204850:	c02007b7          	lui	a5,0xc0200
ffffffffc0204854:	04f6ee63          	bltu	a3,a5,ffffffffc02048b0 <do_wait.part.0+0x18a>
ffffffffc0204858:	000bc797          	auipc	a5,0xbc
ffffffffc020485c:	8e07b783          	ld	a5,-1824(a5) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0204860:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204862:	82b1                	srli	a3,a3,0xc
ffffffffc0204864:	000bc797          	auipc	a5,0xbc
ffffffffc0204868:	8bc7b783          	ld	a5,-1860(a5) # ffffffffc02c0120 <npage>
ffffffffc020486c:	06f6fa63          	bgeu	a3,a5,ffffffffc02048e0 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0204870:	00003517          	auipc	a0,0x3
ffffffffc0204874:	31853503          	ld	a0,792(a0) # ffffffffc0207b88 <nbase>
ffffffffc0204878:	8e89                	sub	a3,a3,a0
ffffffffc020487a:	069a                	slli	a3,a3,0x6
ffffffffc020487c:	000bc517          	auipc	a0,0xbc
ffffffffc0204880:	8ac53503          	ld	a0,-1876(a0) # ffffffffc02c0128 <pages>
ffffffffc0204884:	9536                	add	a0,a0,a3
ffffffffc0204886:	4589                	li	a1,2
ffffffffc0204888:	8fbfd0ef          	jal	ra,ffffffffc0202182 <free_pages>
    kfree(proc);
ffffffffc020488c:	8522                	mv	a0,s0
ffffffffc020488e:	f88fd0ef          	jal	ra,ffffffffc0202016 <kfree>
    return 0;
ffffffffc0204892:	4501                	li	a0,0
ffffffffc0204894:	bde5                	j	ffffffffc020478c <do_wait.part.0+0x66>
        intr_enable();
ffffffffc0204896:	918fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020489a:	bf55                	j	ffffffffc020484e <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc020489c:	701c                	ld	a5,32(s0)
ffffffffc020489e:	fbf8                	sd	a4,240(a5)
ffffffffc02048a0:	bf79                	j	ffffffffc020483e <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02048a2:	912fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02048a6:	4585                	li	a1,1
ffffffffc02048a8:	bf95                	j	ffffffffc020481c <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02048aa:	f2840413          	addi	s0,s0,-216
ffffffffc02048ae:	b781                	j	ffffffffc02047ee <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02048b0:	00002617          	auipc	a2,0x2
ffffffffc02048b4:	0d060613          	addi	a2,a2,208 # ffffffffc0206980 <default_pmm_manager+0xa8>
ffffffffc02048b8:	07700593          	li	a1,119
ffffffffc02048bc:	00002517          	auipc	a0,0x2
ffffffffc02048c0:	aec50513          	addi	a0,a0,-1300 # ffffffffc02063a8 <commands+0x868>
ffffffffc02048c4:	bcbfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02048c8:	00003617          	auipc	a2,0x3
ffffffffc02048cc:	aa860613          	addi	a2,a2,-1368 # ffffffffc0207370 <default_pmm_manager+0xa98>
ffffffffc02048d0:	37500593          	li	a1,885
ffffffffc02048d4:	00003517          	auipc	a0,0x3
ffffffffc02048d8:	a4450513          	addi	a0,a0,-1468 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc02048dc:	bb3fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02048e0:	00002617          	auipc	a2,0x2
ffffffffc02048e4:	aa860613          	addi	a2,a2,-1368 # ffffffffc0206388 <commands+0x848>
ffffffffc02048e8:	06900593          	li	a1,105
ffffffffc02048ec:	00002517          	auipc	a0,0x2
ffffffffc02048f0:	abc50513          	addi	a0,a0,-1348 # ffffffffc02063a8 <commands+0x868>
ffffffffc02048f4:	b9bfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02048f8 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02048f8:	1141                	addi	sp,sp,-16
ffffffffc02048fa:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02048fc:	8c7fd0ef          	jal	ra,ffffffffc02021c2 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204900:	e62fd0ef          	jal	ra,ffffffffc0201f62 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204904:	4601                	li	a2,0
ffffffffc0204906:	4581                	li	a1,0
ffffffffc0204908:	fffff517          	auipc	a0,0xfffff
ffffffffc020490c:	77c50513          	addi	a0,a0,1916 # ffffffffc0204084 <user_main>
ffffffffc0204910:	c7dff0ef          	jal	ra,ffffffffc020458c <kernel_thread>
    if (pid <= 0)
ffffffffc0204914:	00a04563          	bgtz	a0,ffffffffc020491e <init_main+0x26>
ffffffffc0204918:	a071                	j	ffffffffc02049a4 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc020491a:	17d000ef          	jal	ra,ffffffffc0205296 <schedule>
    if (code_store != NULL)
ffffffffc020491e:	4581                	li	a1,0
ffffffffc0204920:	4501                	li	a0,0
ffffffffc0204922:	e05ff0ef          	jal	ra,ffffffffc0204726 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204926:	d975                	beqz	a0,ffffffffc020491a <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204928:	00003517          	auipc	a0,0x3
ffffffffc020492c:	a8850513          	addi	a0,a0,-1400 # ffffffffc02073b0 <default_pmm_manager+0xad8>
ffffffffc0204930:	865fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204934:	000bc797          	auipc	a5,0xbc
ffffffffc0204938:	81c7b783          	ld	a5,-2020(a5) # ffffffffc02c0150 <initproc>
ffffffffc020493c:	7bf8                	ld	a4,240(a5)
ffffffffc020493e:	e339                	bnez	a4,ffffffffc0204984 <init_main+0x8c>
ffffffffc0204940:	7ff8                	ld	a4,248(a5)
ffffffffc0204942:	e329                	bnez	a4,ffffffffc0204984 <init_main+0x8c>
ffffffffc0204944:	1007b703          	ld	a4,256(a5)
ffffffffc0204948:	ef15                	bnez	a4,ffffffffc0204984 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc020494a:	000bc697          	auipc	a3,0xbc
ffffffffc020494e:	80e6a683          	lw	a3,-2034(a3) # ffffffffc02c0158 <nr_process>
ffffffffc0204952:	4709                	li	a4,2
ffffffffc0204954:	0ae69463          	bne	a3,a4,ffffffffc02049fc <init_main+0x104>
    return listelm->next;
ffffffffc0204958:	000bb697          	auipc	a3,0xbb
ffffffffc020495c:	77868693          	addi	a3,a3,1912 # ffffffffc02c00d0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204960:	6698                	ld	a4,8(a3)
ffffffffc0204962:	0c878793          	addi	a5,a5,200
ffffffffc0204966:	06f71b63          	bne	a4,a5,ffffffffc02049dc <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc020496a:	629c                	ld	a5,0(a3)
ffffffffc020496c:	04f71863          	bne	a4,a5,ffffffffc02049bc <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204970:	00003517          	auipc	a0,0x3
ffffffffc0204974:	b2850513          	addi	a0,a0,-1240 # ffffffffc0207498 <default_pmm_manager+0xbc0>
ffffffffc0204978:	81dfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc020497c:	60a2                	ld	ra,8(sp)
ffffffffc020497e:	4501                	li	a0,0
ffffffffc0204980:	0141                	addi	sp,sp,16
ffffffffc0204982:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204984:	00003697          	auipc	a3,0x3
ffffffffc0204988:	a5468693          	addi	a3,a3,-1452 # ffffffffc02073d8 <default_pmm_manager+0xb00>
ffffffffc020498c:	00002617          	auipc	a2,0x2
ffffffffc0204990:	b9c60613          	addi	a2,a2,-1124 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0204994:	3e300593          	li	a1,995
ffffffffc0204998:	00003517          	auipc	a0,0x3
ffffffffc020499c:	98050513          	addi	a0,a0,-1664 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc02049a0:	aeffb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc02049a4:	00003617          	auipc	a2,0x3
ffffffffc02049a8:	9ec60613          	addi	a2,a2,-1556 # ffffffffc0207390 <default_pmm_manager+0xab8>
ffffffffc02049ac:	3da00593          	li	a1,986
ffffffffc02049b0:	00003517          	auipc	a0,0x3
ffffffffc02049b4:	96850513          	addi	a0,a0,-1688 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc02049b8:	ad7fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02049bc:	00003697          	auipc	a3,0x3
ffffffffc02049c0:	aac68693          	addi	a3,a3,-1364 # ffffffffc0207468 <default_pmm_manager+0xb90>
ffffffffc02049c4:	00002617          	auipc	a2,0x2
ffffffffc02049c8:	b6460613          	addi	a2,a2,-1180 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02049cc:	3e600593          	li	a1,998
ffffffffc02049d0:	00003517          	auipc	a0,0x3
ffffffffc02049d4:	94850513          	addi	a0,a0,-1720 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc02049d8:	ab7fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02049dc:	00003697          	auipc	a3,0x3
ffffffffc02049e0:	a5c68693          	addi	a3,a3,-1444 # ffffffffc0207438 <default_pmm_manager+0xb60>
ffffffffc02049e4:	00002617          	auipc	a2,0x2
ffffffffc02049e8:	b4460613          	addi	a2,a2,-1212 # ffffffffc0206528 <commands+0x9e8>
ffffffffc02049ec:	3e500593          	li	a1,997
ffffffffc02049f0:	00003517          	auipc	a0,0x3
ffffffffc02049f4:	92850513          	addi	a0,a0,-1752 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc02049f8:	a97fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc02049fc:	00003697          	auipc	a3,0x3
ffffffffc0204a00:	a2c68693          	addi	a3,a3,-1492 # ffffffffc0207428 <default_pmm_manager+0xb50>
ffffffffc0204a04:	00002617          	auipc	a2,0x2
ffffffffc0204a08:	b2460613          	addi	a2,a2,-1244 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0204a0c:	3e400593          	li	a1,996
ffffffffc0204a10:	00003517          	auipc	a0,0x3
ffffffffc0204a14:	90850513          	addi	a0,a0,-1784 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204a18:	a77fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204a1c <do_execve>:
{
ffffffffc0204a1c:	7171                	addi	sp,sp,-176
ffffffffc0204a1e:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204a20:	000bbd97          	auipc	s11,0xbb
ffffffffc0204a24:	720d8d93          	addi	s11,s11,1824 # ffffffffc02c0140 <current>
ffffffffc0204a28:	000db783          	ld	a5,0(s11)
{
ffffffffc0204a2c:	e54e                	sd	s3,136(sp)
ffffffffc0204a2e:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204a30:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204a34:	e94a                	sd	s2,144(sp)
ffffffffc0204a36:	f4de                	sd	s7,104(sp)
ffffffffc0204a38:	892a                	mv	s2,a0
ffffffffc0204a3a:	8bb2                	mv	s7,a2
ffffffffc0204a3c:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204a3e:	862e                	mv	a2,a1
ffffffffc0204a40:	4681                	li	a3,0
ffffffffc0204a42:	85aa                	mv	a1,a0
ffffffffc0204a44:	854e                	mv	a0,s3
{
ffffffffc0204a46:	f506                	sd	ra,168(sp)
ffffffffc0204a48:	f122                	sd	s0,160(sp)
ffffffffc0204a4a:	e152                	sd	s4,128(sp)
ffffffffc0204a4c:	fcd6                	sd	s5,120(sp)
ffffffffc0204a4e:	f8da                	sd	s6,112(sp)
ffffffffc0204a50:	f0e2                	sd	s8,96(sp)
ffffffffc0204a52:	ece6                	sd	s9,88(sp)
ffffffffc0204a54:	e8ea                	sd	s10,80(sp)
ffffffffc0204a56:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204a58:	d10ff0ef          	jal	ra,ffffffffc0203f68 <user_mem_check>
ffffffffc0204a5c:	40050a63          	beqz	a0,ffffffffc0204e70 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204a60:	4641                	li	a2,16
ffffffffc0204a62:	4581                	li	a1,0
ffffffffc0204a64:	1808                	addi	a0,sp,48
ffffffffc0204a66:	643000ef          	jal	ra,ffffffffc02058a8 <memset>
    memcpy(local_name, name, len);
ffffffffc0204a6a:	47bd                	li	a5,15
ffffffffc0204a6c:	8626                	mv	a2,s1
ffffffffc0204a6e:	1e97e263          	bltu	a5,s1,ffffffffc0204c52 <do_execve+0x236>
ffffffffc0204a72:	85ca                	mv	a1,s2
ffffffffc0204a74:	1808                	addi	a0,sp,48
ffffffffc0204a76:	645000ef          	jal	ra,ffffffffc02058ba <memcpy>
    if (mm != NULL)
ffffffffc0204a7a:	1e098363          	beqz	s3,ffffffffc0204c60 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204a7e:	00002517          	auipc	a0,0x2
ffffffffc0204a82:	65a50513          	addi	a0,a0,1626 # ffffffffc02070d8 <default_pmm_manager+0x800>
ffffffffc0204a86:	f46fb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204a8a:	000bb797          	auipc	a5,0xbb
ffffffffc0204a8e:	6867b783          	ld	a5,1670(a5) # ffffffffc02c0110 <boot_pgdir_pa>
ffffffffc0204a92:	577d                	li	a4,-1
ffffffffc0204a94:	177e                	slli	a4,a4,0x3f
ffffffffc0204a96:	83b1                	srli	a5,a5,0xc
ffffffffc0204a98:	8fd9                	or	a5,a5,a4
ffffffffc0204a9a:	18079073          	csrw	satp,a5
ffffffffc0204a9e:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b80>
ffffffffc0204aa2:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204aa6:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204aaa:	2c070463          	beqz	a4,ffffffffc0204d72 <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204aae:	000db783          	ld	a5,0(s11)
ffffffffc0204ab2:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204ab6:	e3dfe0ef          	jal	ra,ffffffffc02038f2 <mm_create>
ffffffffc0204aba:	84aa                	mv	s1,a0
ffffffffc0204abc:	1c050d63          	beqz	a0,ffffffffc0204c96 <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204ac0:	4505                	li	a0,1
ffffffffc0204ac2:	e82fd0ef          	jal	ra,ffffffffc0202144 <alloc_pages>
ffffffffc0204ac6:	3a050963          	beqz	a0,ffffffffc0204e78 <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc0204aca:	000bbc97          	auipc	s9,0xbb
ffffffffc0204ace:	65ec8c93          	addi	s9,s9,1630 # ffffffffc02c0128 <pages>
ffffffffc0204ad2:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204ad6:	000bbc17          	auipc	s8,0xbb
ffffffffc0204ada:	64ac0c13          	addi	s8,s8,1610 # ffffffffc02c0120 <npage>
    return page - pages + nbase;
ffffffffc0204ade:	00003717          	auipc	a4,0x3
ffffffffc0204ae2:	0aa73703          	ld	a4,170(a4) # ffffffffc0207b88 <nbase>
ffffffffc0204ae6:	40d506b3          	sub	a3,a0,a3
ffffffffc0204aea:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204aec:	5afd                	li	s5,-1
ffffffffc0204aee:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204af2:	96ba                	add	a3,a3,a4
ffffffffc0204af4:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204af6:	00cad713          	srli	a4,s5,0xc
ffffffffc0204afa:	ec3a                	sd	a4,24(sp)
ffffffffc0204afc:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204afe:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b00:	38f77063          	bgeu	a4,a5,ffffffffc0204e80 <do_execve+0x464>
ffffffffc0204b04:	000bbb17          	auipc	s6,0xbb
ffffffffc0204b08:	634b0b13          	addi	s6,s6,1588 # ffffffffc02c0138 <va_pa_offset>
ffffffffc0204b0c:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204b10:	6605                	lui	a2,0x1
ffffffffc0204b12:	000bb597          	auipc	a1,0xbb
ffffffffc0204b16:	6065b583          	ld	a1,1542(a1) # ffffffffc02c0118 <boot_pgdir_va>
ffffffffc0204b1a:	9936                	add	s2,s2,a3
ffffffffc0204b1c:	854a                	mv	a0,s2
ffffffffc0204b1e:	59d000ef          	jal	ra,ffffffffc02058ba <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204b22:	7782                	ld	a5,32(sp)
ffffffffc0204b24:	4398                	lw	a4,0(a5)
ffffffffc0204b26:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204b2a:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204b2e:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_dirtycow_test_out_size+0x464b935f>
ffffffffc0204b32:	14f71863          	bne	a4,a5,ffffffffc0204c82 <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b36:	7682                	ld	a3,32(sp)
ffffffffc0204b38:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204b3c:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b40:	00371793          	slli	a5,a4,0x3
ffffffffc0204b44:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204b46:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b48:	078e                	slli	a5,a5,0x3
ffffffffc0204b4a:	97ce                	add	a5,a5,s3
ffffffffc0204b4c:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204b4e:	00f9fc63          	bgeu	s3,a5,ffffffffc0204b66 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204b52:	0009a783          	lw	a5,0(s3)
ffffffffc0204b56:	4705                	li	a4,1
ffffffffc0204b58:	14e78163          	beq	a5,a4,ffffffffc0204c9a <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc0204b5c:	77a2                	ld	a5,40(sp)
ffffffffc0204b5e:	03898993          	addi	s3,s3,56
ffffffffc0204b62:	fef9e8e3          	bltu	s3,a5,ffffffffc0204b52 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204b66:	4701                	li	a4,0
ffffffffc0204b68:	46ad                	li	a3,11
ffffffffc0204b6a:	00100637          	lui	a2,0x100
ffffffffc0204b6e:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204b72:	8526                	mv	a0,s1
ffffffffc0204b74:	f11fe0ef          	jal	ra,ffffffffc0203a84 <mm_map>
ffffffffc0204b78:	8a2a                	mv	s4,a0
ffffffffc0204b7a:	1e051263          	bnez	a0,ffffffffc0204d5e <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204b7e:	6c88                	ld	a0,24(s1)
ffffffffc0204b80:	467d                	li	a2,31
ffffffffc0204b82:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204b86:	c87fe0ef          	jal	ra,ffffffffc020380c <pgdir_alloc_page>
ffffffffc0204b8a:	38050363          	beqz	a0,ffffffffc0204f10 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b8e:	6c88                	ld	a0,24(s1)
ffffffffc0204b90:	467d                	li	a2,31
ffffffffc0204b92:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204b96:	c77fe0ef          	jal	ra,ffffffffc020380c <pgdir_alloc_page>
ffffffffc0204b9a:	34050b63          	beqz	a0,ffffffffc0204ef0 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b9e:	6c88                	ld	a0,24(s1)
ffffffffc0204ba0:	467d                	li	a2,31
ffffffffc0204ba2:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204ba6:	c67fe0ef          	jal	ra,ffffffffc020380c <pgdir_alloc_page>
ffffffffc0204baa:	32050363          	beqz	a0,ffffffffc0204ed0 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204bae:	6c88                	ld	a0,24(s1)
ffffffffc0204bb0:	467d                	li	a2,31
ffffffffc0204bb2:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204bb6:	c57fe0ef          	jal	ra,ffffffffc020380c <pgdir_alloc_page>
ffffffffc0204bba:	2e050b63          	beqz	a0,ffffffffc0204eb0 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204bbe:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204bc0:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204bc4:	6c94                	ld	a3,24(s1)
ffffffffc0204bc6:	2785                	addiw	a5,a5,1
ffffffffc0204bc8:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204bca:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204bcc:	c02007b7          	lui	a5,0xc0200
ffffffffc0204bd0:	2cf6e463          	bltu	a3,a5,ffffffffc0204e98 <do_execve+0x47c>
ffffffffc0204bd4:	000b3783          	ld	a5,0(s6)
ffffffffc0204bd8:	577d                	li	a4,-1
ffffffffc0204bda:	177e                	slli	a4,a4,0x3f
ffffffffc0204bdc:	8e9d                	sub	a3,a3,a5
ffffffffc0204bde:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204be2:	f654                	sd	a3,168(a2)
ffffffffc0204be4:	8fd9                	or	a5,a5,a4
ffffffffc0204be6:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204bea:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204bec:	4581                	li	a1,0
ffffffffc0204bee:	12000613          	li	a2,288
ffffffffc0204bf2:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204bf4:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204bf8:	4b1000ef          	jal	ra,ffffffffc02058a8 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204bfc:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204bfe:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204c02:	edf4f493          	andi	s1,s1,-289
    tf->epc = elf->e_entry;
ffffffffc0204c06:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c08:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c0a:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_dirtycow_test_out_size+0xffffffff7fff4e94>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c0e:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204c10:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c14:	4641                	li	a2,16
ffffffffc0204c16:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204c18:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204c1a:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204c1e:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204c22:	854a                	mv	a0,s2
ffffffffc0204c24:	485000ef          	jal	ra,ffffffffc02058a8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204c28:	463d                	li	a2,15
ffffffffc0204c2a:	180c                	addi	a1,sp,48
ffffffffc0204c2c:	854a                	mv	a0,s2
ffffffffc0204c2e:	48d000ef          	jal	ra,ffffffffc02058ba <memcpy>
}
ffffffffc0204c32:	70aa                	ld	ra,168(sp)
ffffffffc0204c34:	740a                	ld	s0,160(sp)
ffffffffc0204c36:	64ea                	ld	s1,152(sp)
ffffffffc0204c38:	694a                	ld	s2,144(sp)
ffffffffc0204c3a:	69aa                	ld	s3,136(sp)
ffffffffc0204c3c:	7ae6                	ld	s5,120(sp)
ffffffffc0204c3e:	7b46                	ld	s6,112(sp)
ffffffffc0204c40:	7ba6                	ld	s7,104(sp)
ffffffffc0204c42:	7c06                	ld	s8,96(sp)
ffffffffc0204c44:	6ce6                	ld	s9,88(sp)
ffffffffc0204c46:	6d46                	ld	s10,80(sp)
ffffffffc0204c48:	6da6                	ld	s11,72(sp)
ffffffffc0204c4a:	8552                	mv	a0,s4
ffffffffc0204c4c:	6a0a                	ld	s4,128(sp)
ffffffffc0204c4e:	614d                	addi	sp,sp,176
ffffffffc0204c50:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204c52:	463d                	li	a2,15
ffffffffc0204c54:	85ca                	mv	a1,s2
ffffffffc0204c56:	1808                	addi	a0,sp,48
ffffffffc0204c58:	463000ef          	jal	ra,ffffffffc02058ba <memcpy>
    if (mm != NULL)
ffffffffc0204c5c:	e20991e3          	bnez	s3,ffffffffc0204a7e <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204c60:	000db783          	ld	a5,0(s11)
ffffffffc0204c64:	779c                	ld	a5,40(a5)
ffffffffc0204c66:	e40788e3          	beqz	a5,ffffffffc0204ab6 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204c6a:	00003617          	auipc	a2,0x3
ffffffffc0204c6e:	84e60613          	addi	a2,a2,-1970 # ffffffffc02074b8 <default_pmm_manager+0xbe0>
ffffffffc0204c72:	25a00593          	li	a1,602
ffffffffc0204c76:	00002517          	auipc	a0,0x2
ffffffffc0204c7a:	6a250513          	addi	a0,a0,1698 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204c7e:	811fb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204c82:	8526                	mv	a0,s1
ffffffffc0204c84:	c7eff0ef          	jal	ra,ffffffffc0204102 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204c88:	8526                	mv	a0,s1
ffffffffc0204c8a:	da9fe0ef          	jal	ra,ffffffffc0203a32 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204c8e:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204c90:	8552                	mv	a0,s4
ffffffffc0204c92:	94bff0ef          	jal	ra,ffffffffc02045dc <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204c96:	5a71                	li	s4,-4
ffffffffc0204c98:	bfe5                	j	ffffffffc0204c90 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204c9a:	0289b603          	ld	a2,40(s3)
ffffffffc0204c9e:	0209b783          	ld	a5,32(s3)
ffffffffc0204ca2:	1cf66d63          	bltu	a2,a5,ffffffffc0204e7c <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204ca6:	0049a783          	lw	a5,4(s3)
ffffffffc0204caa:	0017f693          	andi	a3,a5,1
ffffffffc0204cae:	c291                	beqz	a3,ffffffffc0204cb2 <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204cb0:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204cb2:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204cb6:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204cb8:	e779                	bnez	a4,ffffffffc0204d86 <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204cba:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204cbc:	c781                	beqz	a5,ffffffffc0204cc4 <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204cbe:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204cc2:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204cc4:	0026f793          	andi	a5,a3,2
ffffffffc0204cc8:	e3f1                	bnez	a5,ffffffffc0204d8c <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204cca:	0046f793          	andi	a5,a3,4
ffffffffc0204cce:	c399                	beqz	a5,ffffffffc0204cd4 <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204cd0:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204cd4:	0109b583          	ld	a1,16(s3)
ffffffffc0204cd8:	4701                	li	a4,0
ffffffffc0204cda:	8526                	mv	a0,s1
ffffffffc0204cdc:	da9fe0ef          	jal	ra,ffffffffc0203a84 <mm_map>
ffffffffc0204ce0:	8a2a                	mv	s4,a0
ffffffffc0204ce2:	ed35                	bnez	a0,ffffffffc0204d5e <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204ce4:	0109bb83          	ld	s7,16(s3)
ffffffffc0204ce8:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204cea:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204cee:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204cf2:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204cf6:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204cf8:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204cfa:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204cfc:	054be963          	bltu	s7,s4,ffffffffc0204d4e <do_execve+0x332>
ffffffffc0204d00:	aa95                	j	ffffffffc0204e74 <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d02:	6785                	lui	a5,0x1
ffffffffc0204d04:	415b8533          	sub	a0,s7,s5
ffffffffc0204d08:	9abe                	add	s5,s5,a5
ffffffffc0204d0a:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204d0e:	015a7463          	bgeu	s4,s5,ffffffffc0204d16 <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204d12:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204d16:	000cb683          	ld	a3,0(s9)
ffffffffc0204d1a:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204d1c:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204d20:	40d406b3          	sub	a3,s0,a3
ffffffffc0204d24:	8699                	srai	a3,a3,0x6
ffffffffc0204d26:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204d28:	67e2                	ld	a5,24(sp)
ffffffffc0204d2a:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204d2e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204d30:	14b87863          	bgeu	a6,a1,ffffffffc0204e80 <do_execve+0x464>
ffffffffc0204d34:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d38:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204d3a:	9bb2                	add	s7,s7,a2
ffffffffc0204d3c:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d3e:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204d40:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204d42:	379000ef          	jal	ra,ffffffffc02058ba <memcpy>
            start += size, from += size;
ffffffffc0204d46:	6622                	ld	a2,8(sp)
ffffffffc0204d48:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204d4a:	054bf363          	bgeu	s7,s4,ffffffffc0204d90 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204d4e:	6c88                	ld	a0,24(s1)
ffffffffc0204d50:	866a                	mv	a2,s10
ffffffffc0204d52:	85d6                	mv	a1,s5
ffffffffc0204d54:	ab9fe0ef          	jal	ra,ffffffffc020380c <pgdir_alloc_page>
ffffffffc0204d58:	842a                	mv	s0,a0
ffffffffc0204d5a:	f545                	bnez	a0,ffffffffc0204d02 <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204d5c:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204d5e:	8526                	mv	a0,s1
ffffffffc0204d60:	e6ffe0ef          	jal	ra,ffffffffc0203bce <exit_mmap>
    put_pgdir(mm);
ffffffffc0204d64:	8526                	mv	a0,s1
ffffffffc0204d66:	b9cff0ef          	jal	ra,ffffffffc0204102 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204d6a:	8526                	mv	a0,s1
ffffffffc0204d6c:	cc7fe0ef          	jal	ra,ffffffffc0203a32 <mm_destroy>
    return ret;
ffffffffc0204d70:	b705                	j	ffffffffc0204c90 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204d72:	854e                	mv	a0,s3
ffffffffc0204d74:	e5bfe0ef          	jal	ra,ffffffffc0203bce <exit_mmap>
            put_pgdir(mm);
ffffffffc0204d78:	854e                	mv	a0,s3
ffffffffc0204d7a:	b88ff0ef          	jal	ra,ffffffffc0204102 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204d7e:	854e                	mv	a0,s3
ffffffffc0204d80:	cb3fe0ef          	jal	ra,ffffffffc0203a32 <mm_destroy>
ffffffffc0204d84:	b32d                	j	ffffffffc0204aae <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204d86:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204d8a:	fb95                	bnez	a5,ffffffffc0204cbe <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204d8c:	4d5d                	li	s10,23
ffffffffc0204d8e:	bf35                	j	ffffffffc0204cca <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204d90:	0109b683          	ld	a3,16(s3)
ffffffffc0204d94:	0289b903          	ld	s2,40(s3)
ffffffffc0204d98:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204d9a:	075bfd63          	bgeu	s7,s5,ffffffffc0204e14 <do_execve+0x3f8>
            if (start == end)
ffffffffc0204d9e:	db790fe3          	beq	s2,s7,ffffffffc0204b5c <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204da2:	6785                	lui	a5,0x1
ffffffffc0204da4:	00fb8533          	add	a0,s7,a5
ffffffffc0204da8:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204dac:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204db0:	0b597d63          	bgeu	s2,s5,ffffffffc0204e6a <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204db4:	000cb683          	ld	a3,0(s9)
ffffffffc0204db8:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204dba:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204dbe:	40d406b3          	sub	a3,s0,a3
ffffffffc0204dc2:	8699                	srai	a3,a3,0x6
ffffffffc0204dc4:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204dc6:	67e2                	ld	a5,24(sp)
ffffffffc0204dc8:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204dcc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204dce:	0ac5f963          	bgeu	a1,a2,ffffffffc0204e80 <do_execve+0x464>
ffffffffc0204dd2:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204dd6:	8652                	mv	a2,s4
ffffffffc0204dd8:	4581                	li	a1,0
ffffffffc0204dda:	96c2                	add	a3,a3,a6
ffffffffc0204ddc:	9536                	add	a0,a0,a3
ffffffffc0204dde:	2cb000ef          	jal	ra,ffffffffc02058a8 <memset>
            start += size;
ffffffffc0204de2:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204de6:	03597463          	bgeu	s2,s5,ffffffffc0204e0e <do_execve+0x3f2>
ffffffffc0204dea:	d6e909e3          	beq	s2,a4,ffffffffc0204b5c <do_execve+0x140>
ffffffffc0204dee:	00002697          	auipc	a3,0x2
ffffffffc0204df2:	6f268693          	addi	a3,a3,1778 # ffffffffc02074e0 <default_pmm_manager+0xc08>
ffffffffc0204df6:	00001617          	auipc	a2,0x1
ffffffffc0204dfa:	73260613          	addi	a2,a2,1842 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0204dfe:	2c300593          	li	a1,707
ffffffffc0204e02:	00002517          	auipc	a0,0x2
ffffffffc0204e06:	51650513          	addi	a0,a0,1302 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204e0a:	e84fb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204e0e:	ff5710e3          	bne	a4,s5,ffffffffc0204dee <do_execve+0x3d2>
ffffffffc0204e12:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204e14:	d52bf4e3          	bgeu	s7,s2,ffffffffc0204b5c <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e18:	6c88                	ld	a0,24(s1)
ffffffffc0204e1a:	866a                	mv	a2,s10
ffffffffc0204e1c:	85d6                	mv	a1,s5
ffffffffc0204e1e:	9effe0ef          	jal	ra,ffffffffc020380c <pgdir_alloc_page>
ffffffffc0204e22:	842a                	mv	s0,a0
ffffffffc0204e24:	dd05                	beqz	a0,ffffffffc0204d5c <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e26:	6785                	lui	a5,0x1
ffffffffc0204e28:	415b8533          	sub	a0,s7,s5
ffffffffc0204e2c:	9abe                	add	s5,s5,a5
ffffffffc0204e2e:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204e32:	01597463          	bgeu	s2,s5,ffffffffc0204e3a <do_execve+0x41e>
                size -= la - end;
ffffffffc0204e36:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204e3a:	000cb683          	ld	a3,0(s9)
ffffffffc0204e3e:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e40:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204e44:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e48:	8699                	srai	a3,a3,0x6
ffffffffc0204e4a:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204e4c:	67e2                	ld	a5,24(sp)
ffffffffc0204e4e:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e52:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e54:	02b87663          	bgeu	a6,a1,ffffffffc0204e80 <do_execve+0x464>
ffffffffc0204e58:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204e5c:	4581                	li	a1,0
            start += size;
ffffffffc0204e5e:	9bb2                	add	s7,s7,a2
ffffffffc0204e60:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204e62:	9536                	add	a0,a0,a3
ffffffffc0204e64:	245000ef          	jal	ra,ffffffffc02058a8 <memset>
ffffffffc0204e68:	b775                	j	ffffffffc0204e14 <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204e6a:	417a8a33          	sub	s4,s5,s7
ffffffffc0204e6e:	b799                	j	ffffffffc0204db4 <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204e70:	5a75                	li	s4,-3
ffffffffc0204e72:	b3c1                	j	ffffffffc0204c32 <do_execve+0x216>
        while (start < end)
ffffffffc0204e74:	86de                	mv	a3,s7
ffffffffc0204e76:	bf39                	j	ffffffffc0204d94 <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204e78:	5a71                	li	s4,-4
ffffffffc0204e7a:	bdc5                	j	ffffffffc0204d6a <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204e7c:	5a61                	li	s4,-8
ffffffffc0204e7e:	b5c5                	j	ffffffffc0204d5e <do_execve+0x342>
ffffffffc0204e80:	00001617          	auipc	a2,0x1
ffffffffc0204e84:	5d860613          	addi	a2,a2,1496 # ffffffffc0206458 <commands+0x918>
ffffffffc0204e88:	07100593          	li	a1,113
ffffffffc0204e8c:	00001517          	auipc	a0,0x1
ffffffffc0204e90:	51c50513          	addi	a0,a0,1308 # ffffffffc02063a8 <commands+0x868>
ffffffffc0204e94:	dfafb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204e98:	00002617          	auipc	a2,0x2
ffffffffc0204e9c:	ae860613          	addi	a2,a2,-1304 # ffffffffc0206980 <default_pmm_manager+0xa8>
ffffffffc0204ea0:	2e200593          	li	a1,738
ffffffffc0204ea4:	00002517          	auipc	a0,0x2
ffffffffc0204ea8:	47450513          	addi	a0,a0,1140 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204eac:	de2fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204eb0:	00002697          	auipc	a3,0x2
ffffffffc0204eb4:	74868693          	addi	a3,a3,1864 # ffffffffc02075f8 <default_pmm_manager+0xd20>
ffffffffc0204eb8:	00001617          	auipc	a2,0x1
ffffffffc0204ebc:	67060613          	addi	a2,a2,1648 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0204ec0:	2dd00593          	li	a1,733
ffffffffc0204ec4:	00002517          	auipc	a0,0x2
ffffffffc0204ec8:	45450513          	addi	a0,a0,1108 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204ecc:	dc2fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ed0:	00002697          	auipc	a3,0x2
ffffffffc0204ed4:	6e068693          	addi	a3,a3,1760 # ffffffffc02075b0 <default_pmm_manager+0xcd8>
ffffffffc0204ed8:	00001617          	auipc	a2,0x1
ffffffffc0204edc:	65060613          	addi	a2,a2,1616 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0204ee0:	2dc00593          	li	a1,732
ffffffffc0204ee4:	00002517          	auipc	a0,0x2
ffffffffc0204ee8:	43450513          	addi	a0,a0,1076 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204eec:	da2fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ef0:	00002697          	auipc	a3,0x2
ffffffffc0204ef4:	67868693          	addi	a3,a3,1656 # ffffffffc0207568 <default_pmm_manager+0xc90>
ffffffffc0204ef8:	00001617          	auipc	a2,0x1
ffffffffc0204efc:	63060613          	addi	a2,a2,1584 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0204f00:	2db00593          	li	a1,731
ffffffffc0204f04:	00002517          	auipc	a0,0x2
ffffffffc0204f08:	41450513          	addi	a0,a0,1044 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204f0c:	d82fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204f10:	00002697          	auipc	a3,0x2
ffffffffc0204f14:	61068693          	addi	a3,a3,1552 # ffffffffc0207520 <default_pmm_manager+0xc48>
ffffffffc0204f18:	00001617          	auipc	a2,0x1
ffffffffc0204f1c:	61060613          	addi	a2,a2,1552 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0204f20:	2da00593          	li	a1,730
ffffffffc0204f24:	00002517          	auipc	a0,0x2
ffffffffc0204f28:	3f450513          	addi	a0,a0,1012 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0204f2c:	d62fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204f30 <do_yield>:
    current->need_resched = 1;
ffffffffc0204f30:	000bb797          	auipc	a5,0xbb
ffffffffc0204f34:	2107b783          	ld	a5,528(a5) # ffffffffc02c0140 <current>
ffffffffc0204f38:	4705                	li	a4,1
ffffffffc0204f3a:	ef98                	sd	a4,24(a5)
}
ffffffffc0204f3c:	4501                	li	a0,0
ffffffffc0204f3e:	8082                	ret

ffffffffc0204f40 <do_wait>:
{
ffffffffc0204f40:	1101                	addi	sp,sp,-32
ffffffffc0204f42:	e822                	sd	s0,16(sp)
ffffffffc0204f44:	e426                	sd	s1,8(sp)
ffffffffc0204f46:	ec06                	sd	ra,24(sp)
ffffffffc0204f48:	842e                	mv	s0,a1
ffffffffc0204f4a:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204f4c:	c999                	beqz	a1,ffffffffc0204f62 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204f4e:	000bb797          	auipc	a5,0xbb
ffffffffc0204f52:	1f27b783          	ld	a5,498(a5) # ffffffffc02c0140 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204f56:	7788                	ld	a0,40(a5)
ffffffffc0204f58:	4685                	li	a3,1
ffffffffc0204f5a:	4611                	li	a2,4
ffffffffc0204f5c:	80cff0ef          	jal	ra,ffffffffc0203f68 <user_mem_check>
ffffffffc0204f60:	c909                	beqz	a0,ffffffffc0204f72 <do_wait+0x32>
ffffffffc0204f62:	85a2                	mv	a1,s0
}
ffffffffc0204f64:	6442                	ld	s0,16(sp)
ffffffffc0204f66:	60e2                	ld	ra,24(sp)
ffffffffc0204f68:	8526                	mv	a0,s1
ffffffffc0204f6a:	64a2                	ld	s1,8(sp)
ffffffffc0204f6c:	6105                	addi	sp,sp,32
ffffffffc0204f6e:	fb8ff06f          	j	ffffffffc0204726 <do_wait.part.0>
ffffffffc0204f72:	60e2                	ld	ra,24(sp)
ffffffffc0204f74:	6442                	ld	s0,16(sp)
ffffffffc0204f76:	64a2                	ld	s1,8(sp)
ffffffffc0204f78:	5575                	li	a0,-3
ffffffffc0204f7a:	6105                	addi	sp,sp,32
ffffffffc0204f7c:	8082                	ret

ffffffffc0204f7e <do_kill>:
{
ffffffffc0204f7e:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204f80:	6789                	lui	a5,0x2
{
ffffffffc0204f82:	e406                	sd	ra,8(sp)
ffffffffc0204f84:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204f86:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204f8a:	17f9                	addi	a5,a5,-2
ffffffffc0204f8c:	02e7e963          	bltu	a5,a4,ffffffffc0204fbe <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f90:	842a                	mv	s0,a0
ffffffffc0204f92:	45a9                	li	a1,10
ffffffffc0204f94:	2501                	sext.w	a0,a0
ffffffffc0204f96:	46c000ef          	jal	ra,ffffffffc0205402 <hash32>
ffffffffc0204f9a:	02051793          	slli	a5,a0,0x20
ffffffffc0204f9e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204fa2:	000b7797          	auipc	a5,0xb7
ffffffffc0204fa6:	12e78793          	addi	a5,a5,302 # ffffffffc02bc0d0 <hash_list>
ffffffffc0204faa:	953e                	add	a0,a0,a5
ffffffffc0204fac:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204fae:	a029                	j	ffffffffc0204fb8 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204fb0:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204fb4:	00870b63          	beq	a4,s0,ffffffffc0204fca <do_kill+0x4c>
ffffffffc0204fb8:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204fba:	fef51be3          	bne	a0,a5,ffffffffc0204fb0 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204fbe:	5475                	li	s0,-3
}
ffffffffc0204fc0:	60a2                	ld	ra,8(sp)
ffffffffc0204fc2:	8522                	mv	a0,s0
ffffffffc0204fc4:	6402                	ld	s0,0(sp)
ffffffffc0204fc6:	0141                	addi	sp,sp,16
ffffffffc0204fc8:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204fca:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204fce:	00177693          	andi	a3,a4,1
ffffffffc0204fd2:	e295                	bnez	a3,ffffffffc0204ff6 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204fd4:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204fd6:	00176713          	ori	a4,a4,1
ffffffffc0204fda:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204fde:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204fe0:	fe06d0e3          	bgez	a3,ffffffffc0204fc0 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204fe4:	f2878513          	addi	a0,a5,-216
ffffffffc0204fe8:	22e000ef          	jal	ra,ffffffffc0205216 <wakeup_proc>
}
ffffffffc0204fec:	60a2                	ld	ra,8(sp)
ffffffffc0204fee:	8522                	mv	a0,s0
ffffffffc0204ff0:	6402                	ld	s0,0(sp)
ffffffffc0204ff2:	0141                	addi	sp,sp,16
ffffffffc0204ff4:	8082                	ret
        return -E_KILLED;
ffffffffc0204ff6:	545d                	li	s0,-9
ffffffffc0204ff8:	b7e1                	j	ffffffffc0204fc0 <do_kill+0x42>

ffffffffc0204ffa <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204ffa:	1101                	addi	sp,sp,-32
ffffffffc0204ffc:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204ffe:	000bb797          	auipc	a5,0xbb
ffffffffc0205002:	0d278793          	addi	a5,a5,210 # ffffffffc02c00d0 <proc_list>
ffffffffc0205006:	ec06                	sd	ra,24(sp)
ffffffffc0205008:	e822                	sd	s0,16(sp)
ffffffffc020500a:	e04a                	sd	s2,0(sp)
ffffffffc020500c:	000b7497          	auipc	s1,0xb7
ffffffffc0205010:	0c448493          	addi	s1,s1,196 # ffffffffc02bc0d0 <hash_list>
ffffffffc0205014:	e79c                	sd	a5,8(a5)
ffffffffc0205016:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0205018:	000bb717          	auipc	a4,0xbb
ffffffffc020501c:	0b870713          	addi	a4,a4,184 # ffffffffc02c00d0 <proc_list>
ffffffffc0205020:	87a6                	mv	a5,s1
ffffffffc0205022:	e79c                	sd	a5,8(a5)
ffffffffc0205024:	e39c                	sd	a5,0(a5)
ffffffffc0205026:	07c1                	addi	a5,a5,16
ffffffffc0205028:	fef71de3          	bne	a4,a5,ffffffffc0205022 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc020502c:	fd9fe0ef          	jal	ra,ffffffffc0204004 <alloc_proc>
ffffffffc0205030:	000bb917          	auipc	s2,0xbb
ffffffffc0205034:	11890913          	addi	s2,s2,280 # ffffffffc02c0148 <idleproc>
ffffffffc0205038:	00a93023          	sd	a0,0(s2)
ffffffffc020503c:	0e050f63          	beqz	a0,ffffffffc020513a <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205040:	4789                	li	a5,2
ffffffffc0205042:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205044:	00003797          	auipc	a5,0x3
ffffffffc0205048:	fbc78793          	addi	a5,a5,-68 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020504c:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205050:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0205052:	4785                	li	a5,1
ffffffffc0205054:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205056:	4641                	li	a2,16
ffffffffc0205058:	4581                	li	a1,0
ffffffffc020505a:	8522                	mv	a0,s0
ffffffffc020505c:	04d000ef          	jal	ra,ffffffffc02058a8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205060:	463d                	li	a2,15
ffffffffc0205062:	00002597          	auipc	a1,0x2
ffffffffc0205066:	5f658593          	addi	a1,a1,1526 # ffffffffc0207658 <default_pmm_manager+0xd80>
ffffffffc020506a:	8522                	mv	a0,s0
ffffffffc020506c:	04f000ef          	jal	ra,ffffffffc02058ba <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0205070:	000bb717          	auipc	a4,0xbb
ffffffffc0205074:	0e870713          	addi	a4,a4,232 # ffffffffc02c0158 <nr_process>
ffffffffc0205078:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc020507a:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020507e:	4601                	li	a2,0
    nr_process++;
ffffffffc0205080:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205082:	4581                	li	a1,0
ffffffffc0205084:	00000517          	auipc	a0,0x0
ffffffffc0205088:	87450513          	addi	a0,a0,-1932 # ffffffffc02048f8 <init_main>
    nr_process++;
ffffffffc020508c:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc020508e:	000bb797          	auipc	a5,0xbb
ffffffffc0205092:	0ad7b923          	sd	a3,178(a5) # ffffffffc02c0140 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205096:	cf6ff0ef          	jal	ra,ffffffffc020458c <kernel_thread>
ffffffffc020509a:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc020509c:	08a05363          	blez	a0,ffffffffc0205122 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc02050a0:	6789                	lui	a5,0x2
ffffffffc02050a2:	fff5071b          	addiw	a4,a0,-1
ffffffffc02050a6:	17f9                	addi	a5,a5,-2
ffffffffc02050a8:	2501                	sext.w	a0,a0
ffffffffc02050aa:	02e7e363          	bltu	a5,a4,ffffffffc02050d0 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050ae:	45a9                	li	a1,10
ffffffffc02050b0:	352000ef          	jal	ra,ffffffffc0205402 <hash32>
ffffffffc02050b4:	02051793          	slli	a5,a0,0x20
ffffffffc02050b8:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02050bc:	96a6                	add	a3,a3,s1
ffffffffc02050be:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02050c0:	a029                	j	ffffffffc02050ca <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc02050c2:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c84>
ffffffffc02050c6:	04870b63          	beq	a4,s0,ffffffffc020511c <proc_init+0x122>
    return listelm->next;
ffffffffc02050ca:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02050cc:	fef69be3          	bne	a3,a5,ffffffffc02050c2 <proc_init+0xc8>
    return NULL;
ffffffffc02050d0:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050d2:	0b478493          	addi	s1,a5,180
ffffffffc02050d6:	4641                	li	a2,16
ffffffffc02050d8:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02050da:	000bb417          	auipc	s0,0xbb
ffffffffc02050de:	07640413          	addi	s0,s0,118 # ffffffffc02c0150 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050e2:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc02050e4:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050e6:	7c2000ef          	jal	ra,ffffffffc02058a8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02050ea:	463d                	li	a2,15
ffffffffc02050ec:	00002597          	auipc	a1,0x2
ffffffffc02050f0:	59458593          	addi	a1,a1,1428 # ffffffffc0207680 <default_pmm_manager+0xda8>
ffffffffc02050f4:	8526                	mv	a0,s1
ffffffffc02050f6:	7c4000ef          	jal	ra,ffffffffc02058ba <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02050fa:	00093783          	ld	a5,0(s2)
ffffffffc02050fe:	cbb5                	beqz	a5,ffffffffc0205172 <proc_init+0x178>
ffffffffc0205100:	43dc                	lw	a5,4(a5)
ffffffffc0205102:	eba5                	bnez	a5,ffffffffc0205172 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205104:	601c                	ld	a5,0(s0)
ffffffffc0205106:	c7b1                	beqz	a5,ffffffffc0205152 <proc_init+0x158>
ffffffffc0205108:	43d8                	lw	a4,4(a5)
ffffffffc020510a:	4785                	li	a5,1
ffffffffc020510c:	04f71363          	bne	a4,a5,ffffffffc0205152 <proc_init+0x158>
}
ffffffffc0205110:	60e2                	ld	ra,24(sp)
ffffffffc0205112:	6442                	ld	s0,16(sp)
ffffffffc0205114:	64a2                	ld	s1,8(sp)
ffffffffc0205116:	6902                	ld	s2,0(sp)
ffffffffc0205118:	6105                	addi	sp,sp,32
ffffffffc020511a:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020511c:	f2878793          	addi	a5,a5,-216
ffffffffc0205120:	bf4d                	j	ffffffffc02050d2 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0205122:	00002617          	auipc	a2,0x2
ffffffffc0205126:	53e60613          	addi	a2,a2,1342 # ffffffffc0207660 <default_pmm_manager+0xd88>
ffffffffc020512a:	40900593          	li	a1,1033
ffffffffc020512e:	00002517          	auipc	a0,0x2
ffffffffc0205132:	1ea50513          	addi	a0,a0,490 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc0205136:	b58fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc020513a:	00002617          	auipc	a2,0x2
ffffffffc020513e:	50660613          	addi	a2,a2,1286 # ffffffffc0207640 <default_pmm_manager+0xd68>
ffffffffc0205142:	3fa00593          	li	a1,1018
ffffffffc0205146:	00002517          	auipc	a0,0x2
ffffffffc020514a:	1d250513          	addi	a0,a0,466 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc020514e:	b40fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205152:	00002697          	auipc	a3,0x2
ffffffffc0205156:	55e68693          	addi	a3,a3,1374 # ffffffffc02076b0 <default_pmm_manager+0xdd8>
ffffffffc020515a:	00001617          	auipc	a2,0x1
ffffffffc020515e:	3ce60613          	addi	a2,a2,974 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0205162:	41000593          	li	a1,1040
ffffffffc0205166:	00002517          	auipc	a0,0x2
ffffffffc020516a:	1b250513          	addi	a0,a0,434 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc020516e:	b20fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205172:	00002697          	auipc	a3,0x2
ffffffffc0205176:	51668693          	addi	a3,a3,1302 # ffffffffc0207688 <default_pmm_manager+0xdb0>
ffffffffc020517a:	00001617          	auipc	a2,0x1
ffffffffc020517e:	3ae60613          	addi	a2,a2,942 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0205182:	40f00593          	li	a1,1039
ffffffffc0205186:	00002517          	auipc	a0,0x2
ffffffffc020518a:	19250513          	addi	a0,a0,402 # ffffffffc0207318 <default_pmm_manager+0xa40>
ffffffffc020518e:	b00fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205192 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0205192:	1141                	addi	sp,sp,-16
ffffffffc0205194:	e022                	sd	s0,0(sp)
ffffffffc0205196:	e406                	sd	ra,8(sp)
ffffffffc0205198:	000bb417          	auipc	s0,0xbb
ffffffffc020519c:	fa840413          	addi	s0,s0,-88 # ffffffffc02c0140 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02051a0:	6018                	ld	a4,0(s0)
ffffffffc02051a2:	6f1c                	ld	a5,24(a4)
ffffffffc02051a4:	dffd                	beqz	a5,ffffffffc02051a2 <cpu_idle+0x10>
        {
            schedule();
ffffffffc02051a6:	0f0000ef          	jal	ra,ffffffffc0205296 <schedule>
ffffffffc02051aa:	bfdd                	j	ffffffffc02051a0 <cpu_idle+0xe>

ffffffffc02051ac <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02051ac:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02051b0:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02051b4:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02051b6:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02051b8:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02051bc:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02051c0:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02051c4:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02051c8:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02051cc:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02051d0:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02051d4:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc02051d8:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02051dc:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02051e0:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02051e4:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02051e8:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02051ea:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02051ec:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02051f0:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02051f4:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc02051f8:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02051fc:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205200:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205204:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205208:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc020520c:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205210:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205214:	8082                	ret

ffffffffc0205216 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205216:	4118                	lw	a4,0(a0)
{
ffffffffc0205218:	1101                	addi	sp,sp,-32
ffffffffc020521a:	ec06                	sd	ra,24(sp)
ffffffffc020521c:	e822                	sd	s0,16(sp)
ffffffffc020521e:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205220:	478d                	li	a5,3
ffffffffc0205222:	04f70b63          	beq	a4,a5,ffffffffc0205278 <wakeup_proc+0x62>
ffffffffc0205226:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205228:	100027f3          	csrr	a5,sstatus
ffffffffc020522c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020522e:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205230:	ef9d                	bnez	a5,ffffffffc020526e <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205232:	4789                	li	a5,2
ffffffffc0205234:	02f70163          	beq	a4,a5,ffffffffc0205256 <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0205238:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc020523a:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc020523e:	e491                	bnez	s1,ffffffffc020524a <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205240:	60e2                	ld	ra,24(sp)
ffffffffc0205242:	6442                	ld	s0,16(sp)
ffffffffc0205244:	64a2                	ld	s1,8(sp)
ffffffffc0205246:	6105                	addi	sp,sp,32
ffffffffc0205248:	8082                	ret
ffffffffc020524a:	6442                	ld	s0,16(sp)
ffffffffc020524c:	60e2                	ld	ra,24(sp)
ffffffffc020524e:	64a2                	ld	s1,8(sp)
ffffffffc0205250:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205252:	f5cfb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205256:	00002617          	auipc	a2,0x2
ffffffffc020525a:	4ba60613          	addi	a2,a2,1210 # ffffffffc0207710 <default_pmm_manager+0xe38>
ffffffffc020525e:	45d1                	li	a1,20
ffffffffc0205260:	00002517          	auipc	a0,0x2
ffffffffc0205264:	49850513          	addi	a0,a0,1176 # ffffffffc02076f8 <default_pmm_manager+0xe20>
ffffffffc0205268:	a8efb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc020526c:	bfc9                	j	ffffffffc020523e <wakeup_proc+0x28>
        intr_disable();
ffffffffc020526e:	f46fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205272:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205274:	4485                	li	s1,1
ffffffffc0205276:	bf75                	j	ffffffffc0205232 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205278:	00002697          	auipc	a3,0x2
ffffffffc020527c:	46068693          	addi	a3,a3,1120 # ffffffffc02076d8 <default_pmm_manager+0xe00>
ffffffffc0205280:	00001617          	auipc	a2,0x1
ffffffffc0205284:	2a860613          	addi	a2,a2,680 # ffffffffc0206528 <commands+0x9e8>
ffffffffc0205288:	45a5                	li	a1,9
ffffffffc020528a:	00002517          	auipc	a0,0x2
ffffffffc020528e:	46e50513          	addi	a0,a0,1134 # ffffffffc02076f8 <default_pmm_manager+0xe20>
ffffffffc0205292:	9fcfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205296 <schedule>:

void schedule(void)
{
ffffffffc0205296:	1141                	addi	sp,sp,-16
ffffffffc0205298:	e406                	sd	ra,8(sp)
ffffffffc020529a:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020529c:	100027f3          	csrr	a5,sstatus
ffffffffc02052a0:	8b89                	andi	a5,a5,2
ffffffffc02052a2:	4401                	li	s0,0
ffffffffc02052a4:	efbd                	bnez	a5,ffffffffc0205322 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02052a6:	000bb897          	auipc	a7,0xbb
ffffffffc02052aa:	e9a8b883          	ld	a7,-358(a7) # ffffffffc02c0140 <current>
ffffffffc02052ae:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02052b2:	000bb517          	auipc	a0,0xbb
ffffffffc02052b6:	e9653503          	ld	a0,-362(a0) # ffffffffc02c0148 <idleproc>
ffffffffc02052ba:	04a88e63          	beq	a7,a0,ffffffffc0205316 <schedule+0x80>
ffffffffc02052be:	0c888693          	addi	a3,a7,200
ffffffffc02052c2:	000bb617          	auipc	a2,0xbb
ffffffffc02052c6:	e0e60613          	addi	a2,a2,-498 # ffffffffc02c00d0 <proc_list>
        le = last;
ffffffffc02052ca:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02052cc:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02052ce:	4809                	li	a6,2
ffffffffc02052d0:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02052d2:	00c78863          	beq	a5,a2,ffffffffc02052e2 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc02052d6:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02052da:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc02052de:	03070163          	beq	a4,a6,ffffffffc0205300 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc02052e2:	fef697e3          	bne	a3,a5,ffffffffc02052d0 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02052e6:	ed89                	bnez	a1,ffffffffc0205300 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02052e8:	451c                	lw	a5,8(a0)
ffffffffc02052ea:	2785                	addiw	a5,a5,1
ffffffffc02052ec:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02052ee:	00a88463          	beq	a7,a0,ffffffffc02052f6 <schedule+0x60>
        {
            proc_run(next);
ffffffffc02052f2:	e87fe0ef          	jal	ra,ffffffffc0204178 <proc_run>
    if (flag)
ffffffffc02052f6:	e819                	bnez	s0,ffffffffc020530c <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02052f8:	60a2                	ld	ra,8(sp)
ffffffffc02052fa:	6402                	ld	s0,0(sp)
ffffffffc02052fc:	0141                	addi	sp,sp,16
ffffffffc02052fe:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205300:	4198                	lw	a4,0(a1)
ffffffffc0205302:	4789                	li	a5,2
ffffffffc0205304:	fef712e3          	bne	a4,a5,ffffffffc02052e8 <schedule+0x52>
ffffffffc0205308:	852e                	mv	a0,a1
ffffffffc020530a:	bff9                	j	ffffffffc02052e8 <schedule+0x52>
}
ffffffffc020530c:	6402                	ld	s0,0(sp)
ffffffffc020530e:	60a2                	ld	ra,8(sp)
ffffffffc0205310:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205312:	e9cfb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205316:	000bb617          	auipc	a2,0xbb
ffffffffc020531a:	dba60613          	addi	a2,a2,-582 # ffffffffc02c00d0 <proc_list>
ffffffffc020531e:	86b2                	mv	a3,a2
ffffffffc0205320:	b76d                	j	ffffffffc02052ca <schedule+0x34>
        intr_disable();
ffffffffc0205322:	e92fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205326:	4405                	li	s0,1
ffffffffc0205328:	bfbd                	j	ffffffffc02052a6 <schedule+0x10>

ffffffffc020532a <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020532a:	000bb797          	auipc	a5,0xbb
ffffffffc020532e:	e167b783          	ld	a5,-490(a5) # ffffffffc02c0140 <current>
}
ffffffffc0205332:	43c8                	lw	a0,4(a5)
ffffffffc0205334:	8082                	ret

ffffffffc0205336 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205336:	4501                	li	a0,0
ffffffffc0205338:	8082                	ret

ffffffffc020533a <sys_putc>:
    cputchar(c);
ffffffffc020533a:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc020533c:	1141                	addi	sp,sp,-16
ffffffffc020533e:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205340:	e8bfa0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc0205344:	60a2                	ld	ra,8(sp)
ffffffffc0205346:	4501                	li	a0,0
ffffffffc0205348:	0141                	addi	sp,sp,16
ffffffffc020534a:	8082                	ret

ffffffffc020534c <sys_kill>:
    return do_kill(pid);
ffffffffc020534c:	4108                	lw	a0,0(a0)
ffffffffc020534e:	c31ff06f          	j	ffffffffc0204f7e <do_kill>

ffffffffc0205352 <sys_yield>:
    return do_yield();
ffffffffc0205352:	bdfff06f          	j	ffffffffc0204f30 <do_yield>

ffffffffc0205356 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205356:	6d14                	ld	a3,24(a0)
ffffffffc0205358:	6910                	ld	a2,16(a0)
ffffffffc020535a:	650c                	ld	a1,8(a0)
ffffffffc020535c:	6108                	ld	a0,0(a0)
ffffffffc020535e:	ebeff06f          	j	ffffffffc0204a1c <do_execve>

ffffffffc0205362 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205362:	650c                	ld	a1,8(a0)
ffffffffc0205364:	4108                	lw	a0,0(a0)
ffffffffc0205366:	bdbff06f          	j	ffffffffc0204f40 <do_wait>

ffffffffc020536a <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020536a:	000bb797          	auipc	a5,0xbb
ffffffffc020536e:	dd67b783          	ld	a5,-554(a5) # ffffffffc02c0140 <current>
ffffffffc0205372:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205374:	4501                	li	a0,0
ffffffffc0205376:	6a0c                	ld	a1,16(a2)
ffffffffc0205378:	e6dfe06f          	j	ffffffffc02041e4 <do_fork>

ffffffffc020537c <sys_exit>:
    return do_exit(error_code);
ffffffffc020537c:	4108                	lw	a0,0(a0)
ffffffffc020537e:	a5eff06f          	j	ffffffffc02045dc <do_exit>

ffffffffc0205382 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0205382:	715d                	addi	sp,sp,-80
ffffffffc0205384:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205386:	000bb497          	auipc	s1,0xbb
ffffffffc020538a:	dba48493          	addi	s1,s1,-582 # ffffffffc02c0140 <current>
ffffffffc020538e:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205390:	e0a2                	sd	s0,64(sp)
ffffffffc0205392:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205394:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc0205396:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205398:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc020539a:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020539e:	0327ee63          	bltu	a5,s2,ffffffffc02053da <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02053a2:	00391713          	slli	a4,s2,0x3
ffffffffc02053a6:	00002797          	auipc	a5,0x2
ffffffffc02053aa:	3d278793          	addi	a5,a5,978 # ffffffffc0207778 <syscalls>
ffffffffc02053ae:	97ba                	add	a5,a5,a4
ffffffffc02053b0:	639c                	ld	a5,0(a5)
ffffffffc02053b2:	c785                	beqz	a5,ffffffffc02053da <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02053b4:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02053b6:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02053b8:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02053ba:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02053bc:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02053be:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02053c0:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02053c2:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02053c4:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02053c6:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053c8:	0028                	addi	a0,sp,8
ffffffffc02053ca:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02053cc:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053ce:	e828                	sd	a0,80(s0)
}
ffffffffc02053d0:	6406                	ld	s0,64(sp)
ffffffffc02053d2:	74e2                	ld	s1,56(sp)
ffffffffc02053d4:	7942                	ld	s2,48(sp)
ffffffffc02053d6:	6161                	addi	sp,sp,80
ffffffffc02053d8:	8082                	ret
    print_trapframe(tf);
ffffffffc02053da:	8522                	mv	a0,s0
ffffffffc02053dc:	fc8fb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02053e0:	609c                	ld	a5,0(s1)
ffffffffc02053e2:	86ca                	mv	a3,s2
ffffffffc02053e4:	00002617          	auipc	a2,0x2
ffffffffc02053e8:	34c60613          	addi	a2,a2,844 # ffffffffc0207730 <default_pmm_manager+0xe58>
ffffffffc02053ec:	43d8                	lw	a4,4(a5)
ffffffffc02053ee:	06200593          	li	a1,98
ffffffffc02053f2:	0b478793          	addi	a5,a5,180
ffffffffc02053f6:	00002517          	auipc	a0,0x2
ffffffffc02053fa:	36a50513          	addi	a0,a0,874 # ffffffffc0207760 <default_pmm_manager+0xe88>
ffffffffc02053fe:	890fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205402 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205402:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205406:	2785                	addiw	a5,a5,1
ffffffffc0205408:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc020540c:	02000793          	li	a5,32
ffffffffc0205410:	9f8d                	subw	a5,a5,a1
}
ffffffffc0205412:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205416:	8082                	ret

ffffffffc0205418 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205418:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020541c:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020541e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205422:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205424:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205428:	f022                	sd	s0,32(sp)
ffffffffc020542a:	ec26                	sd	s1,24(sp)
ffffffffc020542c:	e84a                	sd	s2,16(sp)
ffffffffc020542e:	f406                	sd	ra,40(sp)
ffffffffc0205430:	e44e                	sd	s3,8(sp)
ffffffffc0205432:	84aa                	mv	s1,a0
ffffffffc0205434:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205436:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020543a:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020543c:	03067e63          	bgeu	a2,a6,ffffffffc0205478 <printnum+0x60>
ffffffffc0205440:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205442:	00805763          	blez	s0,ffffffffc0205450 <printnum+0x38>
ffffffffc0205446:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205448:	85ca                	mv	a1,s2
ffffffffc020544a:	854e                	mv	a0,s3
ffffffffc020544c:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020544e:	fc65                	bnez	s0,ffffffffc0205446 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205450:	1a02                	slli	s4,s4,0x20
ffffffffc0205452:	00002797          	auipc	a5,0x2
ffffffffc0205456:	42678793          	addi	a5,a5,1062 # ffffffffc0207878 <syscalls+0x100>
ffffffffc020545a:	020a5a13          	srli	s4,s4,0x20
ffffffffc020545e:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205460:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205462:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205466:	70a2                	ld	ra,40(sp)
ffffffffc0205468:	69a2                	ld	s3,8(sp)
ffffffffc020546a:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020546c:	85ca                	mv	a1,s2
ffffffffc020546e:	87a6                	mv	a5,s1
}
ffffffffc0205470:	6942                	ld	s2,16(sp)
ffffffffc0205472:	64e2                	ld	s1,24(sp)
ffffffffc0205474:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205476:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205478:	03065633          	divu	a2,a2,a6
ffffffffc020547c:	8722                	mv	a4,s0
ffffffffc020547e:	f9bff0ef          	jal	ra,ffffffffc0205418 <printnum>
ffffffffc0205482:	b7f9                	j	ffffffffc0205450 <printnum+0x38>

ffffffffc0205484 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0205484:	7119                	addi	sp,sp,-128
ffffffffc0205486:	f4a6                	sd	s1,104(sp)
ffffffffc0205488:	f0ca                	sd	s2,96(sp)
ffffffffc020548a:	ecce                	sd	s3,88(sp)
ffffffffc020548c:	e8d2                	sd	s4,80(sp)
ffffffffc020548e:	e4d6                	sd	s5,72(sp)
ffffffffc0205490:	e0da                	sd	s6,64(sp)
ffffffffc0205492:	fc5e                	sd	s7,56(sp)
ffffffffc0205494:	f06a                	sd	s10,32(sp)
ffffffffc0205496:	fc86                	sd	ra,120(sp)
ffffffffc0205498:	f8a2                	sd	s0,112(sp)
ffffffffc020549a:	f862                	sd	s8,48(sp)
ffffffffc020549c:	f466                	sd	s9,40(sp)
ffffffffc020549e:	ec6e                	sd	s11,24(sp)
ffffffffc02054a0:	892a                	mv	s2,a0
ffffffffc02054a2:	84ae                	mv	s1,a1
ffffffffc02054a4:	8d32                	mv	s10,a2
ffffffffc02054a6:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054a8:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02054ac:	5b7d                	li	s6,-1
ffffffffc02054ae:	00002a97          	auipc	s5,0x2
ffffffffc02054b2:	3f6a8a93          	addi	s5,s5,1014 # ffffffffc02078a4 <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02054b6:	00002b97          	auipc	s7,0x2
ffffffffc02054ba:	60ab8b93          	addi	s7,s7,1546 # ffffffffc0207ac0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054be:	000d4503          	lbu	a0,0(s10)
ffffffffc02054c2:	001d0413          	addi	s0,s10,1
ffffffffc02054c6:	01350a63          	beq	a0,s3,ffffffffc02054da <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02054ca:	c121                	beqz	a0,ffffffffc020550a <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02054cc:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054ce:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02054d0:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054d2:	fff44503          	lbu	a0,-1(s0)
ffffffffc02054d6:	ff351ae3          	bne	a0,s3,ffffffffc02054ca <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054da:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02054de:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02054e2:	4c81                	li	s9,0
ffffffffc02054e4:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02054e6:	5c7d                	li	s8,-1
ffffffffc02054e8:	5dfd                	li	s11,-1
ffffffffc02054ea:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02054ee:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054f0:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02054f4:	0ff5f593          	zext.b	a1,a1
ffffffffc02054f8:	00140d13          	addi	s10,s0,1
ffffffffc02054fc:	04b56263          	bltu	a0,a1,ffffffffc0205540 <vprintfmt+0xbc>
ffffffffc0205500:	058a                	slli	a1,a1,0x2
ffffffffc0205502:	95d6                	add	a1,a1,s5
ffffffffc0205504:	4194                	lw	a3,0(a1)
ffffffffc0205506:	96d6                	add	a3,a3,s5
ffffffffc0205508:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020550a:	70e6                	ld	ra,120(sp)
ffffffffc020550c:	7446                	ld	s0,112(sp)
ffffffffc020550e:	74a6                	ld	s1,104(sp)
ffffffffc0205510:	7906                	ld	s2,96(sp)
ffffffffc0205512:	69e6                	ld	s3,88(sp)
ffffffffc0205514:	6a46                	ld	s4,80(sp)
ffffffffc0205516:	6aa6                	ld	s5,72(sp)
ffffffffc0205518:	6b06                	ld	s6,64(sp)
ffffffffc020551a:	7be2                	ld	s7,56(sp)
ffffffffc020551c:	7c42                	ld	s8,48(sp)
ffffffffc020551e:	7ca2                	ld	s9,40(sp)
ffffffffc0205520:	7d02                	ld	s10,32(sp)
ffffffffc0205522:	6de2                	ld	s11,24(sp)
ffffffffc0205524:	6109                	addi	sp,sp,128
ffffffffc0205526:	8082                	ret
            padc = '0';
ffffffffc0205528:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020552a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020552e:	846a                	mv	s0,s10
ffffffffc0205530:	00140d13          	addi	s10,s0,1
ffffffffc0205534:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205538:	0ff5f593          	zext.b	a1,a1
ffffffffc020553c:	fcb572e3          	bgeu	a0,a1,ffffffffc0205500 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205540:	85a6                	mv	a1,s1
ffffffffc0205542:	02500513          	li	a0,37
ffffffffc0205546:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205548:	fff44783          	lbu	a5,-1(s0)
ffffffffc020554c:	8d22                	mv	s10,s0
ffffffffc020554e:	f73788e3          	beq	a5,s3,ffffffffc02054be <vprintfmt+0x3a>
ffffffffc0205552:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205556:	1d7d                	addi	s10,s10,-1
ffffffffc0205558:	ff379de3          	bne	a5,s3,ffffffffc0205552 <vprintfmt+0xce>
ffffffffc020555c:	b78d                	j	ffffffffc02054be <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc020555e:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0205562:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205566:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205568:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020556c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205570:	02d86463          	bltu	a6,a3,ffffffffc0205598 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0205574:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205578:	002c169b          	slliw	a3,s8,0x2
ffffffffc020557c:	0186873b          	addw	a4,a3,s8
ffffffffc0205580:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205584:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0205586:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020558a:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020558c:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0205590:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205594:	fed870e3          	bgeu	a6,a3,ffffffffc0205574 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0205598:	f40ddce3          	bgez	s11,ffffffffc02054f0 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020559c:	8de2                	mv	s11,s8
ffffffffc020559e:	5c7d                	li	s8,-1
ffffffffc02055a0:	bf81                	j	ffffffffc02054f0 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02055a2:	fffdc693          	not	a3,s11
ffffffffc02055a6:	96fd                	srai	a3,a3,0x3f
ffffffffc02055a8:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055ac:	00144603          	lbu	a2,1(s0)
ffffffffc02055b0:	2d81                	sext.w	s11,s11
ffffffffc02055b2:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02055b4:	bf35                	j	ffffffffc02054f0 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02055b6:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055ba:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02055be:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055c0:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02055c2:	bfd9                	j	ffffffffc0205598 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02055c4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055c6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055ca:	01174463          	blt	a4,a7,ffffffffc02055d2 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02055ce:	1a088e63          	beqz	a7,ffffffffc020578a <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02055d2:	000a3603          	ld	a2,0(s4)
ffffffffc02055d6:	46c1                	li	a3,16
ffffffffc02055d8:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02055da:	2781                	sext.w	a5,a5
ffffffffc02055dc:	876e                	mv	a4,s11
ffffffffc02055de:	85a6                	mv	a1,s1
ffffffffc02055e0:	854a                	mv	a0,s2
ffffffffc02055e2:	e37ff0ef          	jal	ra,ffffffffc0205418 <printnum>
            break;
ffffffffc02055e6:	bde1                	j	ffffffffc02054be <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02055e8:	000a2503          	lw	a0,0(s4)
ffffffffc02055ec:	85a6                	mv	a1,s1
ffffffffc02055ee:	0a21                	addi	s4,s4,8
ffffffffc02055f0:	9902                	jalr	s2
            break;
ffffffffc02055f2:	b5f1                	j	ffffffffc02054be <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02055f4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055f6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055fa:	01174463          	blt	a4,a7,ffffffffc0205602 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02055fe:	18088163          	beqz	a7,ffffffffc0205780 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0205602:	000a3603          	ld	a2,0(s4)
ffffffffc0205606:	46a9                	li	a3,10
ffffffffc0205608:	8a2e                	mv	s4,a1
ffffffffc020560a:	bfc1                	j	ffffffffc02055da <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020560c:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205610:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205612:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205614:	bdf1                	j	ffffffffc02054f0 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205616:	85a6                	mv	a1,s1
ffffffffc0205618:	02500513          	li	a0,37
ffffffffc020561c:	9902                	jalr	s2
            break;
ffffffffc020561e:	b545                	j	ffffffffc02054be <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205620:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0205624:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205626:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205628:	b5e1                	j	ffffffffc02054f0 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020562a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020562c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205630:	01174463          	blt	a4,a7,ffffffffc0205638 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0205634:	14088163          	beqz	a7,ffffffffc0205776 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205638:	000a3603          	ld	a2,0(s4)
ffffffffc020563c:	46a1                	li	a3,8
ffffffffc020563e:	8a2e                	mv	s4,a1
ffffffffc0205640:	bf69                	j	ffffffffc02055da <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0205642:	03000513          	li	a0,48
ffffffffc0205646:	85a6                	mv	a1,s1
ffffffffc0205648:	e03e                	sd	a5,0(sp)
ffffffffc020564a:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020564c:	85a6                	mv	a1,s1
ffffffffc020564e:	07800513          	li	a0,120
ffffffffc0205652:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205654:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205656:	6782                	ld	a5,0(sp)
ffffffffc0205658:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020565a:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc020565e:	bfb5                	j	ffffffffc02055da <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205660:	000a3403          	ld	s0,0(s4)
ffffffffc0205664:	008a0713          	addi	a4,s4,8
ffffffffc0205668:	e03a                	sd	a4,0(sp)
ffffffffc020566a:	14040263          	beqz	s0,ffffffffc02057ae <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc020566e:	0fb05763          	blez	s11,ffffffffc020575c <vprintfmt+0x2d8>
ffffffffc0205672:	02d00693          	li	a3,45
ffffffffc0205676:	0cd79163          	bne	a5,a3,ffffffffc0205738 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020567a:	00044783          	lbu	a5,0(s0)
ffffffffc020567e:	0007851b          	sext.w	a0,a5
ffffffffc0205682:	cf85                	beqz	a5,ffffffffc02056ba <vprintfmt+0x236>
ffffffffc0205684:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205688:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020568c:	000c4563          	bltz	s8,ffffffffc0205696 <vprintfmt+0x212>
ffffffffc0205690:	3c7d                	addiw	s8,s8,-1
ffffffffc0205692:	036c0263          	beq	s8,s6,ffffffffc02056b6 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0205696:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205698:	0e0c8e63          	beqz	s9,ffffffffc0205794 <vprintfmt+0x310>
ffffffffc020569c:	3781                	addiw	a5,a5,-32
ffffffffc020569e:	0ef47b63          	bgeu	s0,a5,ffffffffc0205794 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02056a2:	03f00513          	li	a0,63
ffffffffc02056a6:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056a8:	000a4783          	lbu	a5,0(s4)
ffffffffc02056ac:	3dfd                	addiw	s11,s11,-1
ffffffffc02056ae:	0a05                	addi	s4,s4,1
ffffffffc02056b0:	0007851b          	sext.w	a0,a5
ffffffffc02056b4:	ffe1                	bnez	a5,ffffffffc020568c <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02056b6:	01b05963          	blez	s11,ffffffffc02056c8 <vprintfmt+0x244>
ffffffffc02056ba:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02056bc:	85a6                	mv	a1,s1
ffffffffc02056be:	02000513          	li	a0,32
ffffffffc02056c2:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02056c4:	fe0d9be3          	bnez	s11,ffffffffc02056ba <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02056c8:	6a02                	ld	s4,0(sp)
ffffffffc02056ca:	bbd5                	j	ffffffffc02054be <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02056cc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056ce:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02056d2:	01174463          	blt	a4,a7,ffffffffc02056da <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02056d6:	08088d63          	beqz	a7,ffffffffc0205770 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02056da:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02056de:	0a044d63          	bltz	s0,ffffffffc0205798 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02056e2:	8622                	mv	a2,s0
ffffffffc02056e4:	8a66                	mv	s4,s9
ffffffffc02056e6:	46a9                	li	a3,10
ffffffffc02056e8:	bdcd                	j	ffffffffc02055da <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02056ea:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02056ee:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc02056f0:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02056f2:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02056f6:	8fb5                	xor	a5,a5,a3
ffffffffc02056f8:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02056fc:	02d74163          	blt	a4,a3,ffffffffc020571e <vprintfmt+0x29a>
ffffffffc0205700:	00369793          	slli	a5,a3,0x3
ffffffffc0205704:	97de                	add	a5,a5,s7
ffffffffc0205706:	639c                	ld	a5,0(a5)
ffffffffc0205708:	cb99                	beqz	a5,ffffffffc020571e <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020570a:	86be                	mv	a3,a5
ffffffffc020570c:	00000617          	auipc	a2,0x0
ffffffffc0205710:	1f460613          	addi	a2,a2,500 # ffffffffc0205900 <etext+0x2e>
ffffffffc0205714:	85a6                	mv	a1,s1
ffffffffc0205716:	854a                	mv	a0,s2
ffffffffc0205718:	0ce000ef          	jal	ra,ffffffffc02057e6 <printfmt>
ffffffffc020571c:	b34d                	j	ffffffffc02054be <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020571e:	00002617          	auipc	a2,0x2
ffffffffc0205722:	17a60613          	addi	a2,a2,378 # ffffffffc0207898 <syscalls+0x120>
ffffffffc0205726:	85a6                	mv	a1,s1
ffffffffc0205728:	854a                	mv	a0,s2
ffffffffc020572a:	0bc000ef          	jal	ra,ffffffffc02057e6 <printfmt>
ffffffffc020572e:	bb41                	j	ffffffffc02054be <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205730:	00002417          	auipc	s0,0x2
ffffffffc0205734:	16040413          	addi	s0,s0,352 # ffffffffc0207890 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205738:	85e2                	mv	a1,s8
ffffffffc020573a:	8522                	mv	a0,s0
ffffffffc020573c:	e43e                	sd	a5,8(sp)
ffffffffc020573e:	0e2000ef          	jal	ra,ffffffffc0205820 <strnlen>
ffffffffc0205742:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205746:	01b05b63          	blez	s11,ffffffffc020575c <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020574a:	67a2                	ld	a5,8(sp)
ffffffffc020574c:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205750:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0205752:	85a6                	mv	a1,s1
ffffffffc0205754:	8552                	mv	a0,s4
ffffffffc0205756:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205758:	fe0d9ce3          	bnez	s11,ffffffffc0205750 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020575c:	00044783          	lbu	a5,0(s0)
ffffffffc0205760:	00140a13          	addi	s4,s0,1
ffffffffc0205764:	0007851b          	sext.w	a0,a5
ffffffffc0205768:	d3a5                	beqz	a5,ffffffffc02056c8 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020576a:	05e00413          	li	s0,94
ffffffffc020576e:	bf39                	j	ffffffffc020568c <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0205770:	000a2403          	lw	s0,0(s4)
ffffffffc0205774:	b7ad                	j	ffffffffc02056de <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0205776:	000a6603          	lwu	a2,0(s4)
ffffffffc020577a:	46a1                	li	a3,8
ffffffffc020577c:	8a2e                	mv	s4,a1
ffffffffc020577e:	bdb1                	j	ffffffffc02055da <vprintfmt+0x156>
ffffffffc0205780:	000a6603          	lwu	a2,0(s4)
ffffffffc0205784:	46a9                	li	a3,10
ffffffffc0205786:	8a2e                	mv	s4,a1
ffffffffc0205788:	bd89                	j	ffffffffc02055da <vprintfmt+0x156>
ffffffffc020578a:	000a6603          	lwu	a2,0(s4)
ffffffffc020578e:	46c1                	li	a3,16
ffffffffc0205790:	8a2e                	mv	s4,a1
ffffffffc0205792:	b5a1                	j	ffffffffc02055da <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0205794:	9902                	jalr	s2
ffffffffc0205796:	bf09                	j	ffffffffc02056a8 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0205798:	85a6                	mv	a1,s1
ffffffffc020579a:	02d00513          	li	a0,45
ffffffffc020579e:	e03e                	sd	a5,0(sp)
ffffffffc02057a0:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02057a2:	6782                	ld	a5,0(sp)
ffffffffc02057a4:	8a66                	mv	s4,s9
ffffffffc02057a6:	40800633          	neg	a2,s0
ffffffffc02057aa:	46a9                	li	a3,10
ffffffffc02057ac:	b53d                	j	ffffffffc02055da <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02057ae:	03b05163          	blez	s11,ffffffffc02057d0 <vprintfmt+0x34c>
ffffffffc02057b2:	02d00693          	li	a3,45
ffffffffc02057b6:	f6d79de3          	bne	a5,a3,ffffffffc0205730 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02057ba:	00002417          	auipc	s0,0x2
ffffffffc02057be:	0d640413          	addi	s0,s0,214 # ffffffffc0207890 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057c2:	02800793          	li	a5,40
ffffffffc02057c6:	02800513          	li	a0,40
ffffffffc02057ca:	00140a13          	addi	s4,s0,1
ffffffffc02057ce:	bd6d                	j	ffffffffc0205688 <vprintfmt+0x204>
ffffffffc02057d0:	00002a17          	auipc	s4,0x2
ffffffffc02057d4:	0c1a0a13          	addi	s4,s4,193 # ffffffffc0207891 <syscalls+0x119>
ffffffffc02057d8:	02800513          	li	a0,40
ffffffffc02057dc:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057e0:	05e00413          	li	s0,94
ffffffffc02057e4:	b565                	j	ffffffffc020568c <vprintfmt+0x208>

ffffffffc02057e6 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057e6:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02057e8:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057ec:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02057ee:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057f0:	ec06                	sd	ra,24(sp)
ffffffffc02057f2:	f83a                	sd	a4,48(sp)
ffffffffc02057f4:	fc3e                	sd	a5,56(sp)
ffffffffc02057f6:	e0c2                	sd	a6,64(sp)
ffffffffc02057f8:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02057fa:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02057fc:	c89ff0ef          	jal	ra,ffffffffc0205484 <vprintfmt>
}
ffffffffc0205800:	60e2                	ld	ra,24(sp)
ffffffffc0205802:	6161                	addi	sp,sp,80
ffffffffc0205804:	8082                	ret

ffffffffc0205806 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205806:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc020580a:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020580c:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020580e:	cb81                	beqz	a5,ffffffffc020581e <strlen+0x18>
        cnt ++;
ffffffffc0205810:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205812:	00a707b3          	add	a5,a4,a0
ffffffffc0205816:	0007c783          	lbu	a5,0(a5)
ffffffffc020581a:	fbfd                	bnez	a5,ffffffffc0205810 <strlen+0xa>
ffffffffc020581c:	8082                	ret
    }
    return cnt;
}
ffffffffc020581e:	8082                	ret

ffffffffc0205820 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205820:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205822:	e589                	bnez	a1,ffffffffc020582c <strnlen+0xc>
ffffffffc0205824:	a811                	j	ffffffffc0205838 <strnlen+0x18>
        cnt ++;
ffffffffc0205826:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205828:	00f58863          	beq	a1,a5,ffffffffc0205838 <strnlen+0x18>
ffffffffc020582c:	00f50733          	add	a4,a0,a5
ffffffffc0205830:	00074703          	lbu	a4,0(a4)
ffffffffc0205834:	fb6d                	bnez	a4,ffffffffc0205826 <strnlen+0x6>
ffffffffc0205836:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205838:	852e                	mv	a0,a1
ffffffffc020583a:	8082                	ret

ffffffffc020583c <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020583c:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020583e:	0005c703          	lbu	a4,0(a1)
ffffffffc0205842:	0785                	addi	a5,a5,1
ffffffffc0205844:	0585                	addi	a1,a1,1
ffffffffc0205846:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020584a:	fb75                	bnez	a4,ffffffffc020583e <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020584c:	8082                	ret

ffffffffc020584e <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020584e:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205852:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205856:	cb89                	beqz	a5,ffffffffc0205868 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205858:	0505                	addi	a0,a0,1
ffffffffc020585a:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020585c:	fee789e3          	beq	a5,a4,ffffffffc020584e <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205860:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205864:	9d19                	subw	a0,a0,a4
ffffffffc0205866:	8082                	ret
ffffffffc0205868:	4501                	li	a0,0
ffffffffc020586a:	bfed                	j	ffffffffc0205864 <strcmp+0x16>

ffffffffc020586c <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020586c:	c20d                	beqz	a2,ffffffffc020588e <strncmp+0x22>
ffffffffc020586e:	962e                	add	a2,a2,a1
ffffffffc0205870:	a031                	j	ffffffffc020587c <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0205872:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205874:	00e79a63          	bne	a5,a4,ffffffffc0205888 <strncmp+0x1c>
ffffffffc0205878:	00b60b63          	beq	a2,a1,ffffffffc020588e <strncmp+0x22>
ffffffffc020587c:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205880:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205882:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0205886:	f7f5                	bnez	a5,ffffffffc0205872 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205888:	40e7853b          	subw	a0,a5,a4
}
ffffffffc020588c:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020588e:	4501                	li	a0,0
ffffffffc0205890:	8082                	ret

ffffffffc0205892 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205892:	00054783          	lbu	a5,0(a0)
ffffffffc0205896:	c799                	beqz	a5,ffffffffc02058a4 <strchr+0x12>
        if (*s == c) {
ffffffffc0205898:	00f58763          	beq	a1,a5,ffffffffc02058a6 <strchr+0x14>
    while (*s != '\0') {
ffffffffc020589c:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02058a0:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02058a2:	fbfd                	bnez	a5,ffffffffc0205898 <strchr+0x6>
    }
    return NULL;
ffffffffc02058a4:	4501                	li	a0,0
}
ffffffffc02058a6:	8082                	ret

ffffffffc02058a8 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02058a8:	ca01                	beqz	a2,ffffffffc02058b8 <memset+0x10>
ffffffffc02058aa:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02058ac:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02058ae:	0785                	addi	a5,a5,1
ffffffffc02058b0:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02058b4:	fec79de3          	bne	a5,a2,ffffffffc02058ae <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02058b8:	8082                	ret

ffffffffc02058ba <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02058ba:	ca19                	beqz	a2,ffffffffc02058d0 <memcpy+0x16>
ffffffffc02058bc:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02058be:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02058c0:	0005c703          	lbu	a4,0(a1)
ffffffffc02058c4:	0585                	addi	a1,a1,1
ffffffffc02058c6:	0785                	addi	a5,a5,1
ffffffffc02058c8:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02058cc:	fec59ae3          	bne	a1,a2,ffffffffc02058c0 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02058d0:	8082                	ret
