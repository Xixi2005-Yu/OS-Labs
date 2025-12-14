
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
ffffffffc0200062:	15f050ef          	jal	ra,ffffffffc02059c0 <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	98258593          	addi	a1,a1,-1662 # ffffffffc02059f0 <etext+0x6>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	99a50513          	addi	a0,a0,-1638 # ffffffffc0205a10 <etext+0x26>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	275020ef          	jal	ra,ffffffffc0202afa <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	157000ef          	jal	ra,ffffffffc02009e4 <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	4cb030ef          	jal	ra,ffffffffc0203d5c <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	07c050ef          	jal	ra,ffffffffc0205112 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	208050ef          	jal	ra,ffffffffc02052aa <cpu_idle>

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
ffffffffc02000c0:	95c50513          	addi	a0,a0,-1700 # ffffffffc0205a18 <etext+0x2e>
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
ffffffffc0200188:	414050ef          	jal	ra,ffffffffc020559c <vprintfmt>
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
ffffffffc02001be:	3de050ef          	jal	ra,ffffffffc020559c <vprintfmt>
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
ffffffffc020021e:	00006517          	auipc	a0,0x6
ffffffffc0200222:	80250513          	addi	a0,a0,-2046 # ffffffffc0205a20 <etext+0x36>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00006517          	auipc	a0,0x6
ffffffffc0200238:	80c50513          	addi	a0,a0,-2036 # ffffffffc0205a40 <etext+0x56>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	7aa58593          	addi	a1,a1,1962 # ffffffffc02059ea <etext>
ffffffffc0200248:	00006517          	auipc	a0,0x6
ffffffffc020024c:	81850513          	addi	a0,a0,-2024 # ffffffffc0205a60 <etext+0x76>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000bc597          	auipc	a1,0xbc
ffffffffc0200258:	a6458593          	addi	a1,a1,-1436 # ffffffffc02bbcb8 <buf>
ffffffffc020025c:	00006517          	auipc	a0,0x6
ffffffffc0200260:	82450513          	addi	a0,a0,-2012 # ffffffffc0205a80 <etext+0x96>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000c0597          	auipc	a1,0xc0
ffffffffc020026c:	ef458593          	addi	a1,a1,-268 # ffffffffc02c015c <end>
ffffffffc0200270:	00006517          	auipc	a0,0x6
ffffffffc0200274:	83050513          	addi	a0,a0,-2000 # ffffffffc0205aa0 <etext+0xb6>
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
ffffffffc020029e:	00006517          	auipc	a0,0x6
ffffffffc02002a2:	82250513          	addi	a0,a0,-2014 # ffffffffc0205ac0 <etext+0xd6>
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
ffffffffc02002ac:	00006617          	auipc	a2,0x6
ffffffffc02002b0:	84460613          	addi	a2,a2,-1980 # ffffffffc0205af0 <etext+0x106>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00006517          	auipc	a0,0x6
ffffffffc02002bc:	85050513          	addi	a0,a0,-1968 # ffffffffc0205b08 <etext+0x11e>
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
ffffffffc02002c8:	00006617          	auipc	a2,0x6
ffffffffc02002cc:	85860613          	addi	a2,a2,-1960 # ffffffffc0205b20 <etext+0x136>
ffffffffc02002d0:	00006597          	auipc	a1,0x6
ffffffffc02002d4:	87058593          	addi	a1,a1,-1936 # ffffffffc0205b40 <etext+0x156>
ffffffffc02002d8:	00006517          	auipc	a0,0x6
ffffffffc02002dc:	87050513          	addi	a0,a0,-1936 # ffffffffc0205b48 <etext+0x15e>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00006617          	auipc	a2,0x6
ffffffffc02002ea:	87260613          	addi	a2,a2,-1934 # ffffffffc0205b58 <etext+0x16e>
ffffffffc02002ee:	00006597          	auipc	a1,0x6
ffffffffc02002f2:	89258593          	addi	a1,a1,-1902 # ffffffffc0205b80 <etext+0x196>
ffffffffc02002f6:	00006517          	auipc	a0,0x6
ffffffffc02002fa:	85250513          	addi	a0,a0,-1966 # ffffffffc0205b48 <etext+0x15e>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00006617          	auipc	a2,0x6
ffffffffc0200306:	88e60613          	addi	a2,a2,-1906 # ffffffffc0205b90 <etext+0x1a6>
ffffffffc020030a:	00006597          	auipc	a1,0x6
ffffffffc020030e:	8a658593          	addi	a1,a1,-1882 # ffffffffc0205bb0 <etext+0x1c6>
ffffffffc0200312:	00006517          	auipc	a0,0x6
ffffffffc0200316:	83650513          	addi	a0,a0,-1994 # ffffffffc0205b48 <etext+0x15e>
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
ffffffffc020034c:	00006517          	auipc	a0,0x6
ffffffffc0200350:	87450513          	addi	a0,a0,-1932 # ffffffffc0205bc0 <etext+0x1d6>
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
ffffffffc020036e:	00006517          	auipc	a0,0x6
ffffffffc0200372:	87a50513          	addi	a0,a0,-1926 # ffffffffc0205be8 <etext+0x1fe>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	04d000ef          	jal	ra,ffffffffc0200bcc <print_trapframe>
ffffffffc0200384:	00006c17          	auipc	s8,0x6
ffffffffc0200388:	8d4c0c13          	addi	s8,s8,-1836 # ffffffffc0205c58 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00006917          	auipc	s2,0x6
ffffffffc0200390:	88490913          	addi	s2,s2,-1916 # ffffffffc0205c10 <etext+0x226>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00006497          	auipc	s1,0x6
ffffffffc0200398:	88448493          	addi	s1,s1,-1916 # ffffffffc0205c18 <etext+0x22e>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00006b17          	auipc	s6,0x6
ffffffffc02003a2:	882b0b13          	addi	s6,s6,-1918 # ffffffffc0205c20 <etext+0x236>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	79aa0a13          	addi	s4,s4,1946 # ffffffffc0205b40 <etext+0x156>
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
ffffffffc02003c8:	00006d17          	auipc	s10,0x6
ffffffffc02003cc:	890d0d13          	addi	s10,s10,-1904 # ffffffffc0205c58 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	590050ef          	jal	ra,ffffffffc0205966 <strcmp>
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
ffffffffc02003ea:	57c050ef          	jal	ra,ffffffffc0205966 <strcmp>
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
ffffffffc0200428:	582050ef          	jal	ra,ffffffffc02059aa <strchr>
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
ffffffffc0200466:	544050ef          	jal	ra,ffffffffc02059aa <strchr>
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
ffffffffc0200484:	7c050513          	addi	a0,a0,1984 # ffffffffc0205c40 <etext+0x256>
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
ffffffffc02004c0:	7e450513          	addi	a0,a0,2020 # ffffffffc0205ca0 <commands+0x48>
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
ffffffffc02004d6:	b6e50513          	addi	a0,a0,-1170 # ffffffffc0207040 <default_pmm_manager+0x520>
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
ffffffffc020050a:	7ba50513          	addi	a0,a0,1978 # ffffffffc0205cc0 <commands+0x68>
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
ffffffffc020052a:	b1a50513          	addi	a0,a0,-1254 # ffffffffc0207040 <default_pmm_manager+0x520>
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
ffffffffc0200564:	78050513          	addi	a0,a0,1920 # ffffffffc0205ce0 <commands+0x88>
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
ffffffffc0200604:	70050513          	addi	a0,a0,1792 # ffffffffc0205d00 <commands+0xa8>
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
ffffffffc0200632:	6e250513          	addi	a0,a0,1762 # ffffffffc0205d10 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	6dc50513          	addi	a0,a0,1756 # ffffffffc0205d20 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	6e450513          	addi	a0,a0,1764 # ffffffffc0205d38 <commands+0xe0>
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
ffffffffc0200712:	67a90913          	addi	s2,s2,1658 # ffffffffc0205d88 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	66448493          	addi	s1,s1,1636 # ffffffffc0205d80 <commands+0x128>
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
ffffffffc0200774:	69050513          	addi	a0,a0,1680 # ffffffffc0205e00 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	6bc50513          	addi	a0,a0,1724 # ffffffffc0205e38 <commands+0x1e0>
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
ffffffffc02007c0:	59c50513          	addi	a0,a0,1436 # ffffffffc0205d58 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	154050ef          	jal	ra,ffffffffc020591e <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	1ac050ef          	jal	ra,ffffffffc0205984 <strncmp>
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
ffffffffc020086e:	0f8050ef          	jal	ra,ffffffffc0205966 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	50e50513          	addi	a0,a0,1294 # ffffffffc0205d90 <commands+0x138>
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
ffffffffc0200954:	46050513          	addi	a0,a0,1120 # ffffffffc0205db0 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	46650513          	addi	a0,a0,1126 # ffffffffc0205dc8 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	47450513          	addi	a0,a0,1140 # ffffffffc0205de8 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	4b850513          	addi	a0,a0,1208 # ffffffffc0205e38 <commands+0x1e0>
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

ffffffffc02009bc <unlock>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02009bc:	57f9                	li	a5,-2
ffffffffc02009be:	60f537af          	amoand.d	a5,a5,(a0)
ffffffffc02009c2:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02009c4:	c391                	beqz	a5,ffffffffc02009c8 <unlock+0xc>
ffffffffc02009c6:	8082                	ret
{
ffffffffc02009c8:	1141                	addi	sp,sp,-16
    {
        panic("Unlock failed.\n");
ffffffffc02009ca:	00005617          	auipc	a2,0x5
ffffffffc02009ce:	48660613          	addi	a2,a2,1158 # ffffffffc0205e50 <commands+0x1f8>
ffffffffc02009d2:	03f00593          	li	a1,63
ffffffffc02009d6:	00005517          	auipc	a0,0x5
ffffffffc02009da:	48a50513          	addi	a0,a0,1162 # ffffffffc0205e60 <commands+0x208>
{
ffffffffc02009de:	e406                	sd	ra,8(sp)
        panic("Unlock failed.\n");
ffffffffc02009e0:	aafff0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02009e4 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009e4:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009e8:	00001797          	auipc	a5,0x1
ffffffffc02009ec:	84078793          	addi	a5,a5,-1984 # ffffffffc0201228 <__alltraps>
ffffffffc02009f0:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009f4:	000407b7          	lui	a5,0x40
ffffffffc02009f8:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009fc:	8082                	ret

ffffffffc02009fe <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009fe:	610c                	ld	a1,0(a0)
{
ffffffffc0200a00:	1141                	addi	sp,sp,-16
ffffffffc0200a02:	e022                	sd	s0,0(sp)
ffffffffc0200a04:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200a06:	00005517          	auipc	a0,0x5
ffffffffc0200a0a:	47250513          	addi	a0,a0,1138 # ffffffffc0205e78 <commands+0x220>
{
ffffffffc0200a0e:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200a10:	f84ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200a14:	640c                	ld	a1,8(s0)
ffffffffc0200a16:	00005517          	auipc	a0,0x5
ffffffffc0200a1a:	47a50513          	addi	a0,a0,1146 # ffffffffc0205e90 <commands+0x238>
ffffffffc0200a1e:	f76ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200a22:	680c                	ld	a1,16(s0)
ffffffffc0200a24:	00005517          	auipc	a0,0x5
ffffffffc0200a28:	48450513          	addi	a0,a0,1156 # ffffffffc0205ea8 <commands+0x250>
ffffffffc0200a2c:	f68ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a30:	6c0c                	ld	a1,24(s0)
ffffffffc0200a32:	00005517          	auipc	a0,0x5
ffffffffc0200a36:	48e50513          	addi	a0,a0,1166 # ffffffffc0205ec0 <commands+0x268>
ffffffffc0200a3a:	f5aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a3e:	700c                	ld	a1,32(s0)
ffffffffc0200a40:	00005517          	auipc	a0,0x5
ffffffffc0200a44:	49850513          	addi	a0,a0,1176 # ffffffffc0205ed8 <commands+0x280>
ffffffffc0200a48:	f4cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a4c:	740c                	ld	a1,40(s0)
ffffffffc0200a4e:	00005517          	auipc	a0,0x5
ffffffffc0200a52:	4a250513          	addi	a0,a0,1186 # ffffffffc0205ef0 <commands+0x298>
ffffffffc0200a56:	f3eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a5a:	780c                	ld	a1,48(s0)
ffffffffc0200a5c:	00005517          	auipc	a0,0x5
ffffffffc0200a60:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205f08 <commands+0x2b0>
ffffffffc0200a64:	f30ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a68:	7c0c                	ld	a1,56(s0)
ffffffffc0200a6a:	00005517          	auipc	a0,0x5
ffffffffc0200a6e:	4b650513          	addi	a0,a0,1206 # ffffffffc0205f20 <commands+0x2c8>
ffffffffc0200a72:	f22ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a76:	602c                	ld	a1,64(s0)
ffffffffc0200a78:	00005517          	auipc	a0,0x5
ffffffffc0200a7c:	4c050513          	addi	a0,a0,1216 # ffffffffc0205f38 <commands+0x2e0>
ffffffffc0200a80:	f14ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a84:	642c                	ld	a1,72(s0)
ffffffffc0200a86:	00005517          	auipc	a0,0x5
ffffffffc0200a8a:	4ca50513          	addi	a0,a0,1226 # ffffffffc0205f50 <commands+0x2f8>
ffffffffc0200a8e:	f06ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a92:	682c                	ld	a1,80(s0)
ffffffffc0200a94:	00005517          	auipc	a0,0x5
ffffffffc0200a98:	4d450513          	addi	a0,a0,1236 # ffffffffc0205f68 <commands+0x310>
ffffffffc0200a9c:	ef8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200aa0:	6c2c                	ld	a1,88(s0)
ffffffffc0200aa2:	00005517          	auipc	a0,0x5
ffffffffc0200aa6:	4de50513          	addi	a0,a0,1246 # ffffffffc0205f80 <commands+0x328>
ffffffffc0200aaa:	eeaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200aae:	702c                	ld	a1,96(s0)
ffffffffc0200ab0:	00005517          	auipc	a0,0x5
ffffffffc0200ab4:	4e850513          	addi	a0,a0,1256 # ffffffffc0205f98 <commands+0x340>
ffffffffc0200ab8:	edcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200abc:	742c                	ld	a1,104(s0)
ffffffffc0200abe:	00005517          	auipc	a0,0x5
ffffffffc0200ac2:	4f250513          	addi	a0,a0,1266 # ffffffffc0205fb0 <commands+0x358>
ffffffffc0200ac6:	eceff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aca:	782c                	ld	a1,112(s0)
ffffffffc0200acc:	00005517          	auipc	a0,0x5
ffffffffc0200ad0:	4fc50513          	addi	a0,a0,1276 # ffffffffc0205fc8 <commands+0x370>
ffffffffc0200ad4:	ec0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ad8:	7c2c                	ld	a1,120(s0)
ffffffffc0200ada:	00005517          	auipc	a0,0x5
ffffffffc0200ade:	50650513          	addi	a0,a0,1286 # ffffffffc0205fe0 <commands+0x388>
ffffffffc0200ae2:	eb2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200ae6:	604c                	ld	a1,128(s0)
ffffffffc0200ae8:	00005517          	auipc	a0,0x5
ffffffffc0200aec:	51050513          	addi	a0,a0,1296 # ffffffffc0205ff8 <commands+0x3a0>
ffffffffc0200af0:	ea4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200af4:	644c                	ld	a1,136(s0)
ffffffffc0200af6:	00005517          	auipc	a0,0x5
ffffffffc0200afa:	51a50513          	addi	a0,a0,1306 # ffffffffc0206010 <commands+0x3b8>
ffffffffc0200afe:	e96ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200b02:	684c                	ld	a1,144(s0)
ffffffffc0200b04:	00005517          	auipc	a0,0x5
ffffffffc0200b08:	52450513          	addi	a0,a0,1316 # ffffffffc0206028 <commands+0x3d0>
ffffffffc0200b0c:	e88ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200b10:	6c4c                	ld	a1,152(s0)
ffffffffc0200b12:	00005517          	auipc	a0,0x5
ffffffffc0200b16:	52e50513          	addi	a0,a0,1326 # ffffffffc0206040 <commands+0x3e8>
ffffffffc0200b1a:	e7aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200b1e:	704c                	ld	a1,160(s0)
ffffffffc0200b20:	00005517          	auipc	a0,0x5
ffffffffc0200b24:	53850513          	addi	a0,a0,1336 # ffffffffc0206058 <commands+0x400>
ffffffffc0200b28:	e6cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b2c:	744c                	ld	a1,168(s0)
ffffffffc0200b2e:	00005517          	auipc	a0,0x5
ffffffffc0200b32:	54250513          	addi	a0,a0,1346 # ffffffffc0206070 <commands+0x418>
ffffffffc0200b36:	e5eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b3a:	784c                	ld	a1,176(s0)
ffffffffc0200b3c:	00005517          	auipc	a0,0x5
ffffffffc0200b40:	54c50513          	addi	a0,a0,1356 # ffffffffc0206088 <commands+0x430>
ffffffffc0200b44:	e50ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b48:	7c4c                	ld	a1,184(s0)
ffffffffc0200b4a:	00005517          	auipc	a0,0x5
ffffffffc0200b4e:	55650513          	addi	a0,a0,1366 # ffffffffc02060a0 <commands+0x448>
ffffffffc0200b52:	e42ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b56:	606c                	ld	a1,192(s0)
ffffffffc0200b58:	00005517          	auipc	a0,0x5
ffffffffc0200b5c:	56050513          	addi	a0,a0,1376 # ffffffffc02060b8 <commands+0x460>
ffffffffc0200b60:	e34ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b64:	646c                	ld	a1,200(s0)
ffffffffc0200b66:	00005517          	auipc	a0,0x5
ffffffffc0200b6a:	56a50513          	addi	a0,a0,1386 # ffffffffc02060d0 <commands+0x478>
ffffffffc0200b6e:	e26ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b72:	686c                	ld	a1,208(s0)
ffffffffc0200b74:	00005517          	auipc	a0,0x5
ffffffffc0200b78:	57450513          	addi	a0,a0,1396 # ffffffffc02060e8 <commands+0x490>
ffffffffc0200b7c:	e18ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b80:	6c6c                	ld	a1,216(s0)
ffffffffc0200b82:	00005517          	auipc	a0,0x5
ffffffffc0200b86:	57e50513          	addi	a0,a0,1406 # ffffffffc0206100 <commands+0x4a8>
ffffffffc0200b8a:	e0aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b8e:	706c                	ld	a1,224(s0)
ffffffffc0200b90:	00005517          	auipc	a0,0x5
ffffffffc0200b94:	58850513          	addi	a0,a0,1416 # ffffffffc0206118 <commands+0x4c0>
ffffffffc0200b98:	dfcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b9c:	746c                	ld	a1,232(s0)
ffffffffc0200b9e:	00005517          	auipc	a0,0x5
ffffffffc0200ba2:	59250513          	addi	a0,a0,1426 # ffffffffc0206130 <commands+0x4d8>
ffffffffc0200ba6:	deeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200baa:	786c                	ld	a1,240(s0)
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	59c50513          	addi	a0,a0,1436 # ffffffffc0206148 <commands+0x4f0>
ffffffffc0200bb4:	de0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200bb8:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200bba:	6402                	ld	s0,0(sp)
ffffffffc0200bbc:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200bbe:	00005517          	auipc	a0,0x5
ffffffffc0200bc2:	5a250513          	addi	a0,a0,1442 # ffffffffc0206160 <commands+0x508>
}
ffffffffc0200bc6:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200bc8:	dccff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200bcc <print_trapframe>:
{
ffffffffc0200bcc:	1141                	addi	sp,sp,-16
ffffffffc0200bce:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bd0:	85aa                	mv	a1,a0
{
ffffffffc0200bd2:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	5a450513          	addi	a0,a0,1444 # ffffffffc0206178 <commands+0x520>
{
ffffffffc0200bdc:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bde:	db6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200be2:	8522                	mv	a0,s0
ffffffffc0200be4:	e1bff0ef          	jal	ra,ffffffffc02009fe <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200be8:	10043583          	ld	a1,256(s0)
ffffffffc0200bec:	00005517          	auipc	a0,0x5
ffffffffc0200bf0:	5a450513          	addi	a0,a0,1444 # ffffffffc0206190 <commands+0x538>
ffffffffc0200bf4:	da0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bf8:	10843583          	ld	a1,264(s0)
ffffffffc0200bfc:	00005517          	auipc	a0,0x5
ffffffffc0200c00:	5ac50513          	addi	a0,a0,1452 # ffffffffc02061a8 <commands+0x550>
ffffffffc0200c04:	d90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200c08:	11043583          	ld	a1,272(s0)
ffffffffc0200c0c:	00005517          	auipc	a0,0x5
ffffffffc0200c10:	5b450513          	addi	a0,a0,1460 # ffffffffc02061c0 <commands+0x568>
ffffffffc0200c14:	d80ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c18:	11843583          	ld	a1,280(s0)
}
ffffffffc0200c1c:	6402                	ld	s0,0(sp)
ffffffffc0200c1e:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c20:	00005517          	auipc	a0,0x5
ffffffffc0200c24:	5b050513          	addi	a0,a0,1456 # ffffffffc02061d0 <commands+0x578>
}
ffffffffc0200c28:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c2a:	d6aff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200c2e <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c2e:	11853783          	ld	a5,280(a0)
ffffffffc0200c32:	472d                	li	a4,11
ffffffffc0200c34:	0786                	slli	a5,a5,0x1
ffffffffc0200c36:	8385                	srli	a5,a5,0x1
ffffffffc0200c38:	08f76d63          	bltu	a4,a5,ffffffffc0200cd2 <interrupt_handler+0xa4>
ffffffffc0200c3c:	00005717          	auipc	a4,0x5
ffffffffc0200c40:	64c70713          	addi	a4,a4,1612 # ffffffffc0206288 <commands+0x630>
ffffffffc0200c44:	078a                	slli	a5,a5,0x2
ffffffffc0200c46:	97ba                	add	a5,a5,a4
ffffffffc0200c48:	439c                	lw	a5,0(a5)
ffffffffc0200c4a:	97ba                	add	a5,a5,a4
ffffffffc0200c4c:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c4e:	00005517          	auipc	a0,0x5
ffffffffc0200c52:	5fa50513          	addi	a0,a0,1530 # ffffffffc0206248 <commands+0x5f0>
ffffffffc0200c56:	d3eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c5a:	00005517          	auipc	a0,0x5
ffffffffc0200c5e:	5ce50513          	addi	a0,a0,1486 # ffffffffc0206228 <commands+0x5d0>
ffffffffc0200c62:	d32ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c66:	00005517          	auipc	a0,0x5
ffffffffc0200c6a:	58250513          	addi	a0,a0,1410 # ffffffffc02061e8 <commands+0x590>
ffffffffc0200c6e:	d26ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c72:	00005517          	auipc	a0,0x5
ffffffffc0200c76:	59650513          	addi	a0,a0,1430 # ffffffffc0206208 <commands+0x5b0>
ffffffffc0200c7a:	d1aff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c7e:	1141                	addi	sp,sp,-16
ffffffffc0200c80:	e406                	sd	ra,8(sp)
         *(2) ticks 计数器自增
         *(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，
         *    如果有则标记该进程需要被重新调度（current->need_resched）
         */
        /* (1) 设置下次时钟中断 */
        clock_set_next_event();
ffffffffc0200c82:	8f1ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>

        /* (2) ticks 计数器自增 */
        ticks++;
ffffffffc0200c86:	000bf797          	auipc	a5,0xbf
ffffffffc0200c8a:	46278793          	addi	a5,a5,1122 # ffffffffc02c00e8 <ticks>
ffffffffc0200c8e:	6398                	ld	a4,0(a5)

        /* (3) 每 TICK_NUM 次中断检查当前进程并标记需要重调度 */
        if (ticks >= TICK_NUM) {
ffffffffc0200c90:	06300693          	li	a3,99
        ticks++;
ffffffffc0200c94:	0705                	addi	a4,a4,1
ffffffffc0200c96:	e398                	sd	a4,0(a5)
        if (ticks >= TICK_NUM) {
ffffffffc0200c98:	639c                	ld	a5,0(a5)
ffffffffc0200c9a:	02f6f363          	bgeu	a3,a5,ffffffffc0200cc0 <interrupt_handler+0x92>
            ticks = 0;
ffffffffc0200c9e:	000bf797          	auipc	a5,0xbf
ffffffffc0200ca2:	4407b523          	sd	zero,1098(a5) # ffffffffc02c00e8 <ticks>
            if (current != NULL && current != idleproc) {
ffffffffc0200ca6:	000bf797          	auipc	a5,0xbf
ffffffffc0200caa:	49a7b783          	ld	a5,1178(a5) # ffffffffc02c0140 <current>
ffffffffc0200cae:	cb89                	beqz	a5,ffffffffc0200cc0 <interrupt_handler+0x92>
ffffffffc0200cb0:	000bf717          	auipc	a4,0xbf
ffffffffc0200cb4:	49873703          	ld	a4,1176(a4) # ffffffffc02c0148 <idleproc>
ffffffffc0200cb8:	00e78463          	beq	a5,a4,ffffffffc0200cc0 <interrupt_handler+0x92>
                current->need_resched = 1;
ffffffffc0200cbc:	4705                	li	a4,1
ffffffffc0200cbe:	ef98                	sd	a4,24(a5)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cc0:	60a2                	ld	ra,8(sp)
ffffffffc0200cc2:	0141                	addi	sp,sp,16
ffffffffc0200cc4:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200cc6:	00005517          	auipc	a0,0x5
ffffffffc0200cca:	5a250513          	addi	a0,a0,1442 # ffffffffc0206268 <commands+0x610>
ffffffffc0200cce:	cc6ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200cd2:	bded                	j	ffffffffc0200bcc <print_trapframe>

ffffffffc0200cd4 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cd4:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cd8:	711d                	addi	sp,sp,-96
ffffffffc0200cda:	e8a2                	sd	s0,80(sp)
ffffffffc0200cdc:	ec86                	sd	ra,88(sp)
ffffffffc0200cde:	e4a6                	sd	s1,72(sp)
ffffffffc0200ce0:	e0ca                	sd	s2,64(sp)
ffffffffc0200ce2:	fc4e                	sd	s3,56(sp)
ffffffffc0200ce4:	f852                	sd	s4,48(sp)
ffffffffc0200ce6:	f456                	sd	s5,40(sp)
ffffffffc0200ce8:	f05a                	sd	s6,32(sp)
ffffffffc0200cea:	ec5e                	sd	s7,24(sp)
ffffffffc0200cec:	e862                	sd	s8,16(sp)
ffffffffc0200cee:	e466                	sd	s9,8(sp)
ffffffffc0200cf0:	473d                	li	a4,15
ffffffffc0200cf2:	842a                	mv	s0,a0
ffffffffc0200cf4:	18f76663          	bltu	a4,a5,ffffffffc0200e80 <exception_handler+0x1ac>
ffffffffc0200cf8:	00006717          	auipc	a4,0x6
ffffffffc0200cfc:	a2470713          	addi	a4,a4,-1500 # ffffffffc020671c <commands+0xac4>
ffffffffc0200d00:	078a                	slli	a5,a5,0x2
ffffffffc0200d02:	97ba                	add	a5,a5,a4
ffffffffc0200d04:	439c                	lw	a5,0(a5)
ffffffffc0200d06:	97ba                	add	a5,a5,a4
ffffffffc0200d08:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200d0a:	00005517          	auipc	a0,0x5
ffffffffc0200d0e:	69650513          	addi	a0,a0,1686 # ffffffffc02063a0 <commands+0x748>
ffffffffc0200d12:	c82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200d16:	10843783          	ld	a5,264(s0)
    }
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d1a:	60e6                	ld	ra,88(sp)
ffffffffc0200d1c:	64a6                	ld	s1,72(sp)
        tf->epc += 4;
ffffffffc0200d1e:	0791                	addi	a5,a5,4
ffffffffc0200d20:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d24:	6446                	ld	s0,80(sp)
ffffffffc0200d26:	6906                	ld	s2,64(sp)
ffffffffc0200d28:	79e2                	ld	s3,56(sp)
ffffffffc0200d2a:	7a42                	ld	s4,48(sp)
ffffffffc0200d2c:	7aa2                	ld	s5,40(sp)
ffffffffc0200d2e:	7b02                	ld	s6,32(sp)
ffffffffc0200d30:	6be2                	ld	s7,24(sp)
ffffffffc0200d32:	6c42                	ld	s8,16(sp)
ffffffffc0200d34:	6ca2                	ld	s9,8(sp)
ffffffffc0200d36:	6125                	addi	sp,sp,96
        syscall();
ffffffffc0200d38:	7620406f          	j	ffffffffc020549a <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d3c:	00005517          	auipc	a0,0x5
ffffffffc0200d40:	68450513          	addi	a0,a0,1668 # ffffffffc02063c0 <commands+0x768>
}
ffffffffc0200d44:	6446                	ld	s0,80(sp)
ffffffffc0200d46:	60e6                	ld	ra,88(sp)
ffffffffc0200d48:	64a6                	ld	s1,72(sp)
ffffffffc0200d4a:	6906                	ld	s2,64(sp)
ffffffffc0200d4c:	79e2                	ld	s3,56(sp)
ffffffffc0200d4e:	7a42                	ld	s4,48(sp)
ffffffffc0200d50:	7aa2                	ld	s5,40(sp)
ffffffffc0200d52:	7b02                	ld	s6,32(sp)
ffffffffc0200d54:	6be2                	ld	s7,24(sp)
ffffffffc0200d56:	6c42                	ld	s8,16(sp)
ffffffffc0200d58:	6ca2                	ld	s9,8(sp)
ffffffffc0200d5a:	6125                	addi	sp,sp,96
        cprintf("Instruction access fault\n");
ffffffffc0200d5c:	c38ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d60:	00005517          	auipc	a0,0x5
ffffffffc0200d64:	68050513          	addi	a0,a0,1664 # ffffffffc02063e0 <commands+0x788>
ffffffffc0200d68:	bff1                	j	ffffffffc0200d44 <exception_handler+0x70>
        cprintf("Instruction page fault\n");
ffffffffc0200d6a:	00005517          	auipc	a0,0x5
ffffffffc0200d6e:	69650513          	addi	a0,a0,1686 # ffffffffc0206400 <commands+0x7a8>
ffffffffc0200d72:	bfc9                	j	ffffffffc0200d44 <exception_handler+0x70>
        cprintf("Load page fault\n");
ffffffffc0200d74:	00005517          	auipc	a0,0x5
ffffffffc0200d78:	6a450513          	addi	a0,a0,1700 # ffffffffc0206418 <commands+0x7c0>
ffffffffc0200d7c:	b7e1                	j	ffffffffc0200d44 <exception_handler+0x70>
        uintptr_t badv = tf->tval;
ffffffffc0200d7e:	11053a03          	ld	s4,272(a0)
        cprintf("Store/AMO page fault at %p\n", (void *)badv);
ffffffffc0200d82:	00005517          	auipc	a0,0x5
ffffffffc0200d86:	6ae50513          	addi	a0,a0,1710 # ffffffffc0206430 <commands+0x7d8>
ffffffffc0200d8a:	85d2                	mv	a1,s4
ffffffffc0200d8c:	c08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        struct mm_struct *mm = current->mm;
ffffffffc0200d90:	000bf797          	auipc	a5,0xbf
ffffffffc0200d94:	3b07b783          	ld	a5,944(a5) # ffffffffc02c0140 <current>
ffffffffc0200d98:	0287b903          	ld	s2,40(a5)
        if (mm == NULL)
ffffffffc0200d9c:	3c090763          	beqz	s2,ffffffffc020116a <exception_handler+0x496>
        uintptr_t la = ROUNDDOWN(badv, PGSIZE);
ffffffffc0200da0:	79fd                	lui	s3,0xfffff
ffffffffc0200da2:	013a79b3          	and	s3,s4,s3
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0200da6:	03890413          	addi	s0,s2,56
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200daa:	4785                	li	a5,1
ffffffffc0200dac:	40f437af          	amoor.d	a5,a5,(s0)
    while (!try_lock(lock))
ffffffffc0200db0:	8b85                	andi	a5,a5,1
ffffffffc0200db2:	cb81                	beqz	a5,ffffffffc0200dc2 <exception_handler+0xee>
ffffffffc0200db4:	4485                	li	s1,1
        schedule();
ffffffffc0200db6:	5f8040ef          	jal	ra,ffffffffc02053ae <schedule>
ffffffffc0200dba:	409437af          	amoor.d	a5,s1,(s0)
    while (!try_lock(lock))
ffffffffc0200dbe:	8b85                	andi	a5,a5,1
ffffffffc0200dc0:	fbfd                	bnez	a5,ffffffffc0200db6 <exception_handler+0xe2>
        pte_t *ptep = get_pte(mm->pgdir, la, 0);
ffffffffc0200dc2:	01893503          	ld	a0,24(s2)
ffffffffc0200dc6:	4601                	li	a2,0
ffffffffc0200dc8:	85ce                	mv	a1,s3
ffffffffc0200dca:	54a010ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc0200dce:	84aa                	mv	s1,a0
        if (ptep == NULL || !(*ptep & PTE_V))
ffffffffc0200dd0:	c509                	beqz	a0,ffffffffc0200dda <exception_handler+0x106>
ffffffffc0200dd2:	6118                	ld	a4,0(a0)
ffffffffc0200dd4:	00177793          	andi	a5,a4,1
ffffffffc0200dd8:	eff1                	bnez	a5,ffffffffc0200eb4 <exception_handler+0x1e0>
            cprintf("segfault: no mapping for %p\n", (void *)badv);
ffffffffc0200dda:	85d2                	mv	a1,s4
ffffffffc0200ddc:	00005517          	auipc	a0,0x5
ffffffffc0200de0:	6a450513          	addi	a0,a0,1700 # ffffffffc0206480 <commands+0x828>
ffffffffc0200de4:	bb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200de8:	57f9                	li	a5,-2
ffffffffc0200dea:	03890713          	addi	a4,s2,56
ffffffffc0200dee:	60f737af          	amoand.d	a5,a5,(a4)
ffffffffc0200df2:	8b85                	andi	a5,a5,1
            do_exit(-E_INVAL);
ffffffffc0200df4:	5575                	li	a0,-3
    if (!test_and_clear_bit(0, lock))
ffffffffc0200df6:	12078563          	beqz	a5,ffffffffc0200f20 <exception_handler+0x24c>
}
ffffffffc0200dfa:	6446                	ld	s0,80(sp)
ffffffffc0200dfc:	60e6                	ld	ra,88(sp)
ffffffffc0200dfe:	64a6                	ld	s1,72(sp)
ffffffffc0200e00:	6906                	ld	s2,64(sp)
ffffffffc0200e02:	79e2                	ld	s3,56(sp)
ffffffffc0200e04:	7a42                	ld	s4,48(sp)
ffffffffc0200e06:	7aa2                	ld	s5,40(sp)
ffffffffc0200e08:	7b02                	ld	s6,32(sp)
ffffffffc0200e0a:	6be2                	ld	s7,24(sp)
ffffffffc0200e0c:	6c42                	ld	s8,16(sp)
ffffffffc0200e0e:	6ca2                	ld	s9,8(sp)
ffffffffc0200e10:	6125                	addi	sp,sp,96
            do_exit(-E_NO_MEM);
ffffffffc0200e12:	0e30306f          	j	ffffffffc02046f4 <do_exit>
        cprintf("Instruction address misaligned\n");
ffffffffc0200e16:	00005517          	auipc	a0,0x5
ffffffffc0200e1a:	4a250513          	addi	a0,a0,1186 # ffffffffc02062b8 <commands+0x660>
ffffffffc0200e1e:	b71d                	j	ffffffffc0200d44 <exception_handler+0x70>
        cprintf("Instruction access fault\n");
ffffffffc0200e20:	00005517          	auipc	a0,0x5
ffffffffc0200e24:	4b850513          	addi	a0,a0,1208 # ffffffffc02062d8 <commands+0x680>
ffffffffc0200e28:	bf31                	j	ffffffffc0200d44 <exception_handler+0x70>
        cprintf("Illegal instruction\n");
ffffffffc0200e2a:	00005517          	auipc	a0,0x5
ffffffffc0200e2e:	4ce50513          	addi	a0,a0,1230 # ffffffffc02062f8 <commands+0x6a0>
ffffffffc0200e32:	bf09                	j	ffffffffc0200d44 <exception_handler+0x70>
        cprintf("Breakpoint\n");
ffffffffc0200e34:	00005517          	auipc	a0,0x5
ffffffffc0200e38:	4dc50513          	addi	a0,a0,1244 # ffffffffc0206310 <commands+0x6b8>
ffffffffc0200e3c:	b58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200e40:	6458                	ld	a4,136(s0)
ffffffffc0200e42:	47a9                	li	a5,10
ffffffffc0200e44:	0ef70a63          	beq	a4,a5,ffffffffc0200f38 <exception_handler+0x264>
}
ffffffffc0200e48:	60e6                	ld	ra,88(sp)
ffffffffc0200e4a:	6446                	ld	s0,80(sp)
ffffffffc0200e4c:	64a6                	ld	s1,72(sp)
ffffffffc0200e4e:	6906                	ld	s2,64(sp)
ffffffffc0200e50:	79e2                	ld	s3,56(sp)
ffffffffc0200e52:	7a42                	ld	s4,48(sp)
ffffffffc0200e54:	7aa2                	ld	s5,40(sp)
ffffffffc0200e56:	7b02                	ld	s6,32(sp)
ffffffffc0200e58:	6be2                	ld	s7,24(sp)
ffffffffc0200e5a:	6c42                	ld	s8,16(sp)
ffffffffc0200e5c:	6ca2                	ld	s9,8(sp)
ffffffffc0200e5e:	6125                	addi	sp,sp,96
ffffffffc0200e60:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200e62:	00005517          	auipc	a0,0x5
ffffffffc0200e66:	4be50513          	addi	a0,a0,1214 # ffffffffc0206320 <commands+0x6c8>
ffffffffc0200e6a:	bde9                	j	ffffffffc0200d44 <exception_handler+0x70>
        cprintf("Load access fault\n");
ffffffffc0200e6c:	00005517          	auipc	a0,0x5
ffffffffc0200e70:	4d450513          	addi	a0,a0,1236 # ffffffffc0206340 <commands+0x6e8>
ffffffffc0200e74:	bdc1                	j	ffffffffc0200d44 <exception_handler+0x70>
        cprintf("Store/AMO access fault\n");
ffffffffc0200e76:	00005517          	auipc	a0,0x5
ffffffffc0200e7a:	51250513          	addi	a0,a0,1298 # ffffffffc0206388 <commands+0x730>
ffffffffc0200e7e:	b5d9                	j	ffffffffc0200d44 <exception_handler+0x70>
        print_trapframe(tf);
ffffffffc0200e80:	8522                	mv	a0,s0
}
ffffffffc0200e82:	6446                	ld	s0,80(sp)
ffffffffc0200e84:	60e6                	ld	ra,88(sp)
ffffffffc0200e86:	64a6                	ld	s1,72(sp)
ffffffffc0200e88:	6906                	ld	s2,64(sp)
ffffffffc0200e8a:	79e2                	ld	s3,56(sp)
ffffffffc0200e8c:	7a42                	ld	s4,48(sp)
ffffffffc0200e8e:	7aa2                	ld	s5,40(sp)
ffffffffc0200e90:	7b02                	ld	s6,32(sp)
ffffffffc0200e92:	6be2                	ld	s7,24(sp)
ffffffffc0200e94:	6c42                	ld	s8,16(sp)
ffffffffc0200e96:	6ca2                	ld	s9,8(sp)
ffffffffc0200e98:	6125                	addi	sp,sp,96
        print_trapframe(tf);
ffffffffc0200e9a:	bb0d                	j	ffffffffc0200bcc <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200e9c:	00005617          	auipc	a2,0x5
ffffffffc0200ea0:	4bc60613          	addi	a2,a2,1212 # ffffffffc0206358 <commands+0x700>
ffffffffc0200ea4:	0c800593          	li	a1,200
ffffffffc0200ea8:	00005517          	auipc	a0,0x5
ffffffffc0200eac:	4c850513          	addi	a0,a0,1224 # ffffffffc0206370 <commands+0x718>
ffffffffc0200eb0:	ddeff0ef          	jal	ra,ffffffffc020048e <__panic>
}

static inline struct Page *
pa2page(uintptr_t pa)
{
    if (PPN(pa) >= npage)
ffffffffc0200eb4:	000bfa97          	auipc	s5,0xbf
ffffffffc0200eb8:	26ca8a93          	addi	s5,s5,620 # ffffffffc02c0120 <npage>
ffffffffc0200ebc:	000ab783          	ld	a5,0(s5)
{
    if (!(pte & PTE_V))
    {
        panic("pte2page called with invalid pte");
    }
    return pa2page(PTE_ADDR(pte));
ffffffffc0200ec0:	00271613          	slli	a2,a4,0x2
ffffffffc0200ec4:	8231                	srli	a2,a2,0xc
    if (PPN(pa) >= npage)
ffffffffc0200ec6:	2af67e63          	bgeu	a2,a5,ffffffffc0201182 <exception_handler+0x4ae>
    return &pages[PPN(pa) - nbase];
ffffffffc0200eca:	000bfb17          	auipc	s6,0xbf
ffffffffc0200ece:	25eb0b13          	addi	s6,s6,606 # ffffffffc02c0128 <pages>
ffffffffc0200ed2:	00007a17          	auipc	s4,0x7
ffffffffc0200ed6:	efea3a03          	ld	s4,-258(s4) # ffffffffc0207dd0 <nbase>
ffffffffc0200eda:	000b3b83          	ld	s7,0(s6)
ffffffffc0200ede:	41460633          	sub	a2,a2,s4
ffffffffc0200ee2:	061a                	slli	a2,a2,0x6
ffffffffc0200ee4:	9bb2                	add	s7,s7,a2
        cprintf("COW fault: va=%p ppn=%x ref=%d pte=0x%08x\n", (void *)la, page2ppn(page), page_ref(page), (uint32_t)(*ptep));
ffffffffc0200ee6:	000ba683          	lw	a3,0(s7)
    return page - pages + nbase;
ffffffffc0200eea:	8619                	srai	a2,a2,0x6
ffffffffc0200eec:	85ce                	mv	a1,s3
ffffffffc0200eee:	2701                	sext.w	a4,a4
ffffffffc0200ef0:	9652                	add	a2,a2,s4
ffffffffc0200ef2:	00005517          	auipc	a0,0x5
ffffffffc0200ef6:	5de50513          	addi	a0,a0,1502 # ffffffffc02064d0 <commands+0x878>
ffffffffc0200efa:	a9aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (*ptep & PTE_W)
ffffffffc0200efe:	609c                	ld	a5,0(s1)
            cprintf("COW spurious: already writable va=%p\n", (void *)la);
ffffffffc0200f00:	85ce                	mv	a1,s3
        if (*ptep & PTE_W)
ffffffffc0200f02:	8b91                	andi	a5,a5,4
ffffffffc0200f04:	c7b5                	beqz	a5,ffffffffc0200f70 <exception_handler+0x29c>
            cprintf("COW spurious: already writable va=%p\n", (void *)la);
ffffffffc0200f06:	00005517          	auipc	a0,0x5
ffffffffc0200f0a:	5fa50513          	addi	a0,a0,1530 # ffffffffc0206500 <commands+0x8a8>
ffffffffc0200f0e:	a86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200f12:	57f9                	li	a5,-2
ffffffffc0200f14:	03890713          	addi	a4,s2,56
ffffffffc0200f18:	60f737af          	amoand.d	a5,a5,(a4)
ffffffffc0200f1c:	8b85                	andi	a5,a5,1
ffffffffc0200f1e:	f78d                	bnez	a5,ffffffffc0200e48 <exception_handler+0x174>
        panic("Unlock failed.\n");
ffffffffc0200f20:	00005617          	auipc	a2,0x5
ffffffffc0200f24:	f3060613          	addi	a2,a2,-208 # ffffffffc0205e50 <commands+0x1f8>
ffffffffc0200f28:	03f00593          	li	a1,63
ffffffffc0200f2c:	00005517          	auipc	a0,0x5
ffffffffc0200f30:	f3450513          	addi	a0,a0,-204 # ffffffffc0205e60 <commands+0x208>
ffffffffc0200f34:	d5aff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200f38:	10843783          	ld	a5,264(s0)
ffffffffc0200f3c:	0791                	addi	a5,a5,4
ffffffffc0200f3e:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200f42:	558040ef          	jal	ra,ffffffffc020549a <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f46:	000bf797          	auipc	a5,0xbf
ffffffffc0200f4a:	1fa7b783          	ld	a5,506(a5) # ffffffffc02c0140 <current>
ffffffffc0200f4e:	6b9c                	ld	a5,16(a5)
ffffffffc0200f50:	8522                	mv	a0,s0
}
ffffffffc0200f52:	6446                	ld	s0,80(sp)
ffffffffc0200f54:	60e6                	ld	ra,88(sp)
ffffffffc0200f56:	64a6                	ld	s1,72(sp)
ffffffffc0200f58:	6906                	ld	s2,64(sp)
ffffffffc0200f5a:	79e2                	ld	s3,56(sp)
ffffffffc0200f5c:	7a42                	ld	s4,48(sp)
ffffffffc0200f5e:	7aa2                	ld	s5,40(sp)
ffffffffc0200f60:	7b02                	ld	s6,32(sp)
ffffffffc0200f62:	6be2                	ld	s7,24(sp)
ffffffffc0200f64:	6c42                	ld	s8,16(sp)
ffffffffc0200f66:	6ca2                	ld	s9,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f68:	6589                	lui	a1,0x2
ffffffffc0200f6a:	95be                	add	a1,a1,a5
}
ffffffffc0200f6c:	6125                	addi	sp,sp,96
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200f6e:	a661                	j	ffffffffc02012f6 <kernel_execve_ret>
        struct vma_struct *vma = find_vma(mm, la);
ffffffffc0200f70:	854a                	mv	a0,s2
ffffffffc0200f72:	2c9020ef          	jal	ra,ffffffffc0203a3a <find_vma>
        if (vma == NULL || !(vma->vm_flags & VM_WRITE))
ffffffffc0200f76:	cd25                	beqz	a0,ffffffffc0200fee <exception_handler+0x31a>
ffffffffc0200f78:	4d1c                	lw	a5,24(a0)
ffffffffc0200f7a:	8b89                	andi	a5,a5,2
ffffffffc0200f7c:	cbad                	beqz	a5,ffffffffc0200fee <exception_handler+0x31a>
}

static inline int
page_ref(struct Page *page)
{
    return page->ref;
ffffffffc0200f7e:	000ba603          	lw	a2,0(s7)
        if (page_ref(page) > 1)
ffffffffc0200f82:	4785                	li	a5,1
ffffffffc0200f84:	06c7cb63          	blt	a5,a2,ffffffffc0200ffa <exception_handler+0x326>
            if (page_ref(page) == 1 && 
ffffffffc0200f88:	00f61763          	bne	a2,a5,ffffffffc0200f96 <exception_handler+0x2c2>
            pte_t pte_before = *ptep;
ffffffffc0200f8c:	609c                	ld	a5,0(s1)
                (pte_before & PTE_V) && 
ffffffffc0200f8e:	0017f713          	andi	a4,a5,1
            if (page_ref(page) == 1 && 
ffffffffc0200f92:	12071d63          	bnez	a4,ffffffffc02010cc <exception_handler+0x3f8>
            cprintf("COW race/ref-change detected: va=%p ref=%d, doing full copy\n",
ffffffffc0200f96:	85ce                	mv	a1,s3
ffffffffc0200f98:	00005517          	auipc	a0,0x5
ffffffffc0200f9c:	62050513          	addi	a0,a0,1568 # ffffffffc02065b8 <commands+0x960>
ffffffffc0200fa0:	9f4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page - pages + nbase;
ffffffffc0200fa4:	000b3603          	ld	a2,0(s6)
        cprintf("COW alloc+copy: va=%p old_ppn=%x old_ref=%d\n", (void *)la, page2ppn(page), page_ref(page));
ffffffffc0200fa8:	000ba683          	lw	a3,0(s7)
ffffffffc0200fac:	85ce                	mv	a1,s3
ffffffffc0200fae:	40cb8633          	sub	a2,s7,a2
ffffffffc0200fb2:	8619                	srai	a2,a2,0x6
ffffffffc0200fb4:	9652                	add	a2,a2,s4
ffffffffc0200fb6:	00005517          	auipc	a0,0x5
ffffffffc0200fba:	64250513          	addi	a0,a0,1602 # ffffffffc02065f8 <commands+0x9a0>
ffffffffc0200fbe:	9d6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        struct Page *npage = alloc_page();
ffffffffc0200fc2:	4505                	li	a0,1
ffffffffc0200fc4:	298010ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0200fc8:	8c2a                	mv	s8,a0
        if (npage == NULL)
ffffffffc0200fca:	0e050663          	beqz	a0,ffffffffc02010b6 <exception_handler+0x3e2>
        pte_t pte_before_copy = *ptep;
ffffffffc0200fce:	0004bc83          	ld	s9,0(s1)
        if (pte_before_copy & PTE_W)
ffffffffc0200fd2:	004cf793          	andi	a5,s9,4
ffffffffc0200fd6:	cb95                	beqz	a5,ffffffffc020100a <exception_handler+0x336>
            cprintf("COW: race - page became writable, aborting copy\n");
ffffffffc0200fd8:	00005517          	auipc	a0,0x5
ffffffffc0200fdc:	66850513          	addi	a0,a0,1640 # ffffffffc0206640 <commands+0x9e8>
ffffffffc0200fe0:	9b4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
            free_page(npage);
ffffffffc0200fe4:	4585                	li	a1,1
ffffffffc0200fe6:	8562                	mv	a0,s8
ffffffffc0200fe8:	2b2010ef          	jal	ra,ffffffffc020229a <free_pages>
ffffffffc0200fec:	b71d                	j	ffffffffc0200f12 <exception_handler+0x23e>
            cprintf("COW denied: va=%p has no write permission in VMA\n", (void *)la);
ffffffffc0200fee:	85ce                	mv	a1,s3
ffffffffc0200ff0:	00005517          	auipc	a0,0x5
ffffffffc0200ff4:	53850513          	addi	a0,a0,1336 # ffffffffc0206528 <commands+0x8d0>
ffffffffc0200ff8:	b3f5                	j	ffffffffc0200de4 <exception_handler+0x110>
            cprintf("COW shared page: va=%p ref=%d, doing copy\n", 
ffffffffc0200ffa:	85ce                	mv	a1,s3
ffffffffc0200ffc:	00005517          	auipc	a0,0x5
ffffffffc0201000:	56450513          	addi	a0,a0,1380 # ffffffffc0206560 <commands+0x908>
ffffffffc0201004:	990ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0201008:	bf71                	j	ffffffffc0200fa4 <exception_handler+0x2d0>
ffffffffc020100a:	000b3783          	ld	a5,0(s6)
    return KADDR(page2pa(page));
ffffffffc020100e:	577d                	li	a4,-1
ffffffffc0201010:	000ab603          	ld	a2,0(s5)
    return page - pages + nbase;
ffffffffc0201014:	40f506b3          	sub	a3,a0,a5
ffffffffc0201018:	8699                	srai	a3,a3,0x6
ffffffffc020101a:	96d2                	add	a3,a3,s4
    return KADDR(page2pa(page));
ffffffffc020101c:	8331                	srli	a4,a4,0xc
ffffffffc020101e:	00e6f5b3          	and	a1,a3,a4
    return page2ppn(page) << PGSHIFT;
ffffffffc0201022:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201024:	12c5f763          	bgeu	a1,a2,ffffffffc0201152 <exception_handler+0x47e>
    return page - pages + nbase;
ffffffffc0201028:	40fb87b3          	sub	a5,s7,a5
ffffffffc020102c:	8799                	srai	a5,a5,0x6
ffffffffc020102e:	97d2                	add	a5,a5,s4
    return KADDR(page2pa(page));
ffffffffc0201030:	000bf597          	auipc	a1,0xbf
ffffffffc0201034:	1085b583          	ld	a1,264(a1) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0201038:	8f7d                	and	a4,a4,a5
ffffffffc020103a:	00b68533          	add	a0,a3,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc020103e:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0201042:	10c77863          	bgeu	a4,a2,ffffffffc0201152 <exception_handler+0x47e>
        memcpy(page2kva(npage), page2kva(page), PGSIZE);
ffffffffc0201046:	6605                	lui	a2,0x1
ffffffffc0201048:	95b6                	add	a1,a1,a3
ffffffffc020104a:	189040ef          	jal	ra,ffffffffc02059d2 <memcpy>
        if (*ptep != pte_before_copy)
ffffffffc020104e:	609c                	ld	a5,0(s1)
            cprintf("COW: race - PTE changed during copy\n");
ffffffffc0201050:	00005517          	auipc	a0,0x5
ffffffffc0201054:	65050513          	addi	a0,a0,1616 # ffffffffc02066a0 <commands+0xa48>
        if (*ptep != pte_before_copy)
ffffffffc0201058:	f99794e3          	bne	a5,s9,ffffffffc0200fe0 <exception_handler+0x30c>
        page_remove(mm->pgdir, la);
ffffffffc020105c:	01893503          	ld	a0,24(s2)
ffffffffc0201060:	85ce                	mv	a1,s3
ffffffffc0201062:	107010ef          	jal	ra,ffffffffc0202968 <page_remove>
        if (page_insert(mm->pgdir, npage, la, PTE_USER) != 0)
ffffffffc0201066:	01893503          	ld	a0,24(s2)
ffffffffc020106a:	46fd                	li	a3,31
ffffffffc020106c:	864e                	mv	a2,s3
ffffffffc020106e:	85e2                	mv	a1,s8
ffffffffc0201070:	195010ef          	jal	ra,ffffffffc0202a04 <page_insert>
ffffffffc0201074:	ed55                	bnez	a0,ffffffffc0201130 <exception_handler+0x45c>
    return page - pages + nbase;
ffffffffc0201076:	000b3603          	ld	a2,0(s6)
        cprintf("COW done: va=%p new_ppn=%x new_ref=%d old_ref=%d\n", (void *)la, page2ppn(npage), page_ref(npage), page_ref(page));
ffffffffc020107a:	000ba703          	lw	a4,0(s7)
ffffffffc020107e:	000c2683          	lw	a3,0(s8) # ff0000 <_binary_obj___user_dirtycow_test_out_size+0xfe4de0>
ffffffffc0201082:	40cc0633          	sub	a2,s8,a2
ffffffffc0201086:	8619                	srai	a2,a2,0x6
ffffffffc0201088:	9652                	add	a2,a2,s4
ffffffffc020108a:	85ce                	mv	a1,s3
ffffffffc020108c:	00005517          	auipc	a0,0x5
ffffffffc0201090:	65c50513          	addi	a0,a0,1628 # ffffffffc02066e8 <commands+0xa90>
ffffffffc0201094:	900ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
static inline void
unlock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        unlock(&(mm->mm_lock));
ffffffffc0201098:	8522                	mv	a0,s0
}
ffffffffc020109a:	6446                	ld	s0,80(sp)
ffffffffc020109c:	60e6                	ld	ra,88(sp)
ffffffffc020109e:	64a6                	ld	s1,72(sp)
ffffffffc02010a0:	6906                	ld	s2,64(sp)
ffffffffc02010a2:	79e2                	ld	s3,56(sp)
ffffffffc02010a4:	7a42                	ld	s4,48(sp)
ffffffffc02010a6:	7aa2                	ld	s5,40(sp)
ffffffffc02010a8:	7b02                	ld	s6,32(sp)
ffffffffc02010aa:	6be2                	ld	s7,24(sp)
ffffffffc02010ac:	6c42                	ld	s8,16(sp)
ffffffffc02010ae:	6ca2                	ld	s9,8(sp)
ffffffffc02010b0:	6125                	addi	sp,sp,96
ffffffffc02010b2:	90bff06f          	j	ffffffffc02009bc <unlock>
            cprintf("COW: alloc_page failed\n");
ffffffffc02010b6:	00005517          	auipc	a0,0x5
ffffffffc02010ba:	57250513          	addi	a0,a0,1394 # ffffffffc0206628 <commands+0x9d0>
ffffffffc02010be:	8d6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02010c2:	8522                	mv	a0,s0
ffffffffc02010c4:	8f9ff0ef          	jal	ra,ffffffffc02009bc <unlock>
            do_exit(-E_NO_MEM);
ffffffffc02010c8:	5571                	li	a0,-4
ffffffffc02010ca:	bb05                	j	ffffffffc0200dfa <exception_handler+0x126>
    if (PPN(pa) >= npage)
ffffffffc02010cc:	000ab703          	ld	a4,0(s5)
    return pa2page(PTE_ADDR(pte));
ffffffffc02010d0:	00279693          	slli	a3,a5,0x2
ffffffffc02010d4:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc02010d6:	0ae6f663          	bgeu	a3,a4,ffffffffc0201182 <exception_handler+0x4ae>
    return &pages[PPN(pa) - nbase];
ffffffffc02010da:	000b3703          	ld	a4,0(s6)
ffffffffc02010de:	414686b3          	sub	a3,a3,s4
ffffffffc02010e2:	069a                	slli	a3,a3,0x6
ffffffffc02010e4:	96ba                	add	a3,a3,a4
                (pte_before & PTE_V) && 
ffffffffc02010e6:	eadb98e3          	bne	s7,a3,ffffffffc0200f96 <exception_handler+0x2c2>
                !(pte_before & PTE_W))
ffffffffc02010ea:	0047f693          	andi	a3,a5,4
                pte2page(pte_before) == page &&
ffffffffc02010ee:	ea0694e3          	bnez	a3,ffffffffc0200f96 <exception_handler+0x2c2>
    return page - pages + nbase;
ffffffffc02010f2:	40eb8733          	sub	a4,s7,a4
ffffffffc02010f6:	8719                	srai	a4,a4,0x6
ffffffffc02010f8:	9752                	add	a4,a4,s4
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02010fa:	072a                	slli	a4,a4,0xa
                    uint32_t user_bits = (pte_before & (PTE_R | PTE_X | PTE_U));
ffffffffc02010fc:	8be9                	andi	a5,a5,26
                    tlb_invalidate(mm->pgdir, la);
ffffffffc02010fe:	01893503          	ld	a0,24(s2)
ffffffffc0201102:	8fd9                	or	a5,a5,a4
ffffffffc0201104:	0057e793          	ori	a5,a5,5
ffffffffc0201108:	85ce                	mv	a1,s3
                    *ptep = pte_create(page2ppn(page), user_bits | PTE_W);
ffffffffc020110a:	e09c                	sd	a5,0(s1)
                    tlb_invalidate(mm->pgdir, la);
ffffffffc020110c:	013020ef          	jal	ra,ffffffffc020391e <tlb_invalidate>
    return page - pages + nbase;
ffffffffc0201110:	000b3603          	ld	a2,0(s6)
                    cprintf("COW promote: va=%p ppn=%x ref=%d\n", 
ffffffffc0201114:	000ba683          	lw	a3,0(s7)
ffffffffc0201118:	85ce                	mv	a1,s3
ffffffffc020111a:	40cb8633          	sub	a2,s7,a2
ffffffffc020111e:	8619                	srai	a2,a2,0x6
ffffffffc0201120:	9652                	add	a2,a2,s4
ffffffffc0201122:	00005517          	auipc	a0,0x5
ffffffffc0201126:	46e50513          	addi	a0,a0,1134 # ffffffffc0206590 <commands+0x938>
ffffffffc020112a:	86aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020112e:	b7ad                	j	ffffffffc0201098 <exception_handler+0x3c4>
            cprintf("COW: page_insert failed\n");
ffffffffc0201130:	00005517          	auipc	a0,0x5
ffffffffc0201134:	59850513          	addi	a0,a0,1432 # ffffffffc02066c8 <commands+0xa70>
ffffffffc0201138:	85cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
            free_page(npage);
ffffffffc020113c:	4585                	li	a1,1
ffffffffc020113e:	8562                	mv	a0,s8
ffffffffc0201140:	15a010ef          	jal	ra,ffffffffc020229a <free_pages>
ffffffffc0201144:	8522                	mv	a0,s0
ffffffffc0201146:	877ff0ef          	jal	ra,ffffffffc02009bc <unlock>
            do_exit(-E_NO_MEM);
ffffffffc020114a:	5571                	li	a0,-4
ffffffffc020114c:	5a8030ef          	jal	ra,ffffffffc02046f4 <do_exit>
ffffffffc0201150:	b71d                	j	ffffffffc0201076 <exception_handler+0x3a2>
    return KADDR(page2pa(page));
ffffffffc0201152:	00005617          	auipc	a2,0x5
ffffffffc0201156:	52660613          	addi	a2,a2,1318 # ffffffffc0206678 <commands+0xa20>
ffffffffc020115a:	07100593          	li	a1,113
ffffffffc020115e:	00005517          	auipc	a0,0x5
ffffffffc0201162:	36250513          	addi	a0,a0,866 # ffffffffc02064c0 <commands+0x868>
ffffffffc0201166:	b28ff0ef          	jal	ra,ffffffffc020048e <__panic>
            panic("store page fault in kernel or kernel-thread\n");
ffffffffc020116a:	00005617          	auipc	a2,0x5
ffffffffc020116e:	2e660613          	addi	a2,a2,742 # ffffffffc0206450 <commands+0x7f8>
ffffffffc0201172:	0eb00593          	li	a1,235
ffffffffc0201176:	00005517          	auipc	a0,0x5
ffffffffc020117a:	1fa50513          	addi	a0,a0,506 # ffffffffc0206370 <commands+0x718>
ffffffffc020117e:	b10ff0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0201182:	00005617          	auipc	a2,0x5
ffffffffc0201186:	31e60613          	addi	a2,a2,798 # ffffffffc02064a0 <commands+0x848>
ffffffffc020118a:	06900593          	li	a1,105
ffffffffc020118e:	00005517          	auipc	a0,0x5
ffffffffc0201192:	33250513          	addi	a0,a0,818 # ffffffffc02064c0 <commands+0x868>
ffffffffc0201196:	af8ff0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020119a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc020119a:	1101                	addi	sp,sp,-32
ffffffffc020119c:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc020119e:	000bf417          	auipc	s0,0xbf
ffffffffc02011a2:	fa240413          	addi	s0,s0,-94 # ffffffffc02c0140 <current>
ffffffffc02011a6:	6018                	ld	a4,0(s0)
{
ffffffffc02011a8:	ec06                	sd	ra,24(sp)
ffffffffc02011aa:	e426                	sd	s1,8(sp)
ffffffffc02011ac:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc02011ae:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc02011b2:	cf1d                	beqz	a4,ffffffffc02011f0 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02011b4:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc02011b8:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc02011bc:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02011be:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc02011c2:	0206c463          	bltz	a3,ffffffffc02011ea <trap+0x50>
        exception_handler(tf);
ffffffffc02011c6:	b0fff0ef          	jal	ra,ffffffffc0200cd4 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc02011ca:	601c                	ld	a5,0(s0)
ffffffffc02011cc:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc02011d0:	e499                	bnez	s1,ffffffffc02011de <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc02011d2:	0b07a703          	lw	a4,176(a5)
ffffffffc02011d6:	8b05                	andi	a4,a4,1
ffffffffc02011d8:	e331                	bnez	a4,ffffffffc020121c <trap+0x82>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc02011da:	6f9c                	ld	a5,24(a5)
ffffffffc02011dc:	eb8d                	bnez	a5,ffffffffc020120e <trap+0x74>
            {
                schedule();
            }
        }
    }
}
ffffffffc02011de:	60e2                	ld	ra,24(sp)
ffffffffc02011e0:	6442                	ld	s0,16(sp)
ffffffffc02011e2:	64a2                	ld	s1,8(sp)
ffffffffc02011e4:	6902                	ld	s2,0(sp)
ffffffffc02011e6:	6105                	addi	sp,sp,32
ffffffffc02011e8:	8082                	ret
        interrupt_handler(tf);
ffffffffc02011ea:	a45ff0ef          	jal	ra,ffffffffc0200c2e <interrupt_handler>
ffffffffc02011ee:	bff1                	j	ffffffffc02011ca <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc02011f0:	0006c863          	bltz	a3,ffffffffc0201200 <trap+0x66>
}
ffffffffc02011f4:	6442                	ld	s0,16(sp)
ffffffffc02011f6:	60e2                	ld	ra,24(sp)
ffffffffc02011f8:	64a2                	ld	s1,8(sp)
ffffffffc02011fa:	6902                	ld	s2,0(sp)
ffffffffc02011fc:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc02011fe:	bcd9                	j	ffffffffc0200cd4 <exception_handler>
}
ffffffffc0201200:	6442                	ld	s0,16(sp)
ffffffffc0201202:	60e2                	ld	ra,24(sp)
ffffffffc0201204:	64a2                	ld	s1,8(sp)
ffffffffc0201206:	6902                	ld	s2,0(sp)
ffffffffc0201208:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc020120a:	a25ff06f          	j	ffffffffc0200c2e <interrupt_handler>
}
ffffffffc020120e:	6442                	ld	s0,16(sp)
ffffffffc0201210:	60e2                	ld	ra,24(sp)
ffffffffc0201212:	64a2                	ld	s1,8(sp)
ffffffffc0201214:	6902                	ld	s2,0(sp)
ffffffffc0201216:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0201218:	1960406f          	j	ffffffffc02053ae <schedule>
                do_exit(-E_KILLED);
ffffffffc020121c:	555d                	li	a0,-9
ffffffffc020121e:	4d6030ef          	jal	ra,ffffffffc02046f4 <do_exit>
            if (current->need_resched)
ffffffffc0201222:	601c                	ld	a5,0(s0)
ffffffffc0201224:	bf5d                	j	ffffffffc02011da <trap+0x40>
	...

ffffffffc0201228 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0201228:	14011173          	csrrw	sp,sscratch,sp
ffffffffc020122c:	00011463          	bnez	sp,ffffffffc0201234 <__alltraps+0xc>
ffffffffc0201230:	14002173          	csrr	sp,sscratch
ffffffffc0201234:	712d                	addi	sp,sp,-288
ffffffffc0201236:	e002                	sd	zero,0(sp)
ffffffffc0201238:	e406                	sd	ra,8(sp)
ffffffffc020123a:	ec0e                	sd	gp,24(sp)
ffffffffc020123c:	f012                	sd	tp,32(sp)
ffffffffc020123e:	f416                	sd	t0,40(sp)
ffffffffc0201240:	f81a                	sd	t1,48(sp)
ffffffffc0201242:	fc1e                	sd	t2,56(sp)
ffffffffc0201244:	e0a2                	sd	s0,64(sp)
ffffffffc0201246:	e4a6                	sd	s1,72(sp)
ffffffffc0201248:	e8aa                	sd	a0,80(sp)
ffffffffc020124a:	ecae                	sd	a1,88(sp)
ffffffffc020124c:	f0b2                	sd	a2,96(sp)
ffffffffc020124e:	f4b6                	sd	a3,104(sp)
ffffffffc0201250:	f8ba                	sd	a4,112(sp)
ffffffffc0201252:	fcbe                	sd	a5,120(sp)
ffffffffc0201254:	e142                	sd	a6,128(sp)
ffffffffc0201256:	e546                	sd	a7,136(sp)
ffffffffc0201258:	e94a                	sd	s2,144(sp)
ffffffffc020125a:	ed4e                	sd	s3,152(sp)
ffffffffc020125c:	f152                	sd	s4,160(sp)
ffffffffc020125e:	f556                	sd	s5,168(sp)
ffffffffc0201260:	f95a                	sd	s6,176(sp)
ffffffffc0201262:	fd5e                	sd	s7,184(sp)
ffffffffc0201264:	e1e2                	sd	s8,192(sp)
ffffffffc0201266:	e5e6                	sd	s9,200(sp)
ffffffffc0201268:	e9ea                	sd	s10,208(sp)
ffffffffc020126a:	edee                	sd	s11,216(sp)
ffffffffc020126c:	f1f2                	sd	t3,224(sp)
ffffffffc020126e:	f5f6                	sd	t4,232(sp)
ffffffffc0201270:	f9fa                	sd	t5,240(sp)
ffffffffc0201272:	fdfe                	sd	t6,248(sp)
ffffffffc0201274:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201278:	100024f3          	csrr	s1,sstatus
ffffffffc020127c:	14102973          	csrr	s2,sepc
ffffffffc0201280:	143029f3          	csrr	s3,stval
ffffffffc0201284:	14202a73          	csrr	s4,scause
ffffffffc0201288:	e822                	sd	s0,16(sp)
ffffffffc020128a:	e226                	sd	s1,256(sp)
ffffffffc020128c:	e64a                	sd	s2,264(sp)
ffffffffc020128e:	ea4e                	sd	s3,272(sp)
ffffffffc0201290:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0201292:	850a                	mv	a0,sp
    jal trap
ffffffffc0201294:	f07ff0ef          	jal	ra,ffffffffc020119a <trap>

ffffffffc0201298 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0201298:	6492                	ld	s1,256(sp)
ffffffffc020129a:	6932                	ld	s2,264(sp)
ffffffffc020129c:	1004f413          	andi	s0,s1,256
ffffffffc02012a0:	e401                	bnez	s0,ffffffffc02012a8 <__trapret+0x10>
ffffffffc02012a2:	1200                	addi	s0,sp,288
ffffffffc02012a4:	14041073          	csrw	sscratch,s0
ffffffffc02012a8:	10049073          	csrw	sstatus,s1
ffffffffc02012ac:	14191073          	csrw	sepc,s2
ffffffffc02012b0:	60a2                	ld	ra,8(sp)
ffffffffc02012b2:	61e2                	ld	gp,24(sp)
ffffffffc02012b4:	7202                	ld	tp,32(sp)
ffffffffc02012b6:	72a2                	ld	t0,40(sp)
ffffffffc02012b8:	7342                	ld	t1,48(sp)
ffffffffc02012ba:	73e2                	ld	t2,56(sp)
ffffffffc02012bc:	6406                	ld	s0,64(sp)
ffffffffc02012be:	64a6                	ld	s1,72(sp)
ffffffffc02012c0:	6546                	ld	a0,80(sp)
ffffffffc02012c2:	65e6                	ld	a1,88(sp)
ffffffffc02012c4:	7606                	ld	a2,96(sp)
ffffffffc02012c6:	76a6                	ld	a3,104(sp)
ffffffffc02012c8:	7746                	ld	a4,112(sp)
ffffffffc02012ca:	77e6                	ld	a5,120(sp)
ffffffffc02012cc:	680a                	ld	a6,128(sp)
ffffffffc02012ce:	68aa                	ld	a7,136(sp)
ffffffffc02012d0:	694a                	ld	s2,144(sp)
ffffffffc02012d2:	69ea                	ld	s3,152(sp)
ffffffffc02012d4:	7a0a                	ld	s4,160(sp)
ffffffffc02012d6:	7aaa                	ld	s5,168(sp)
ffffffffc02012d8:	7b4a                	ld	s6,176(sp)
ffffffffc02012da:	7bea                	ld	s7,184(sp)
ffffffffc02012dc:	6c0e                	ld	s8,192(sp)
ffffffffc02012de:	6cae                	ld	s9,200(sp)
ffffffffc02012e0:	6d4e                	ld	s10,208(sp)
ffffffffc02012e2:	6dee                	ld	s11,216(sp)
ffffffffc02012e4:	7e0e                	ld	t3,224(sp)
ffffffffc02012e6:	7eae                	ld	t4,232(sp)
ffffffffc02012e8:	7f4e                	ld	t5,240(sp)
ffffffffc02012ea:	7fee                	ld	t6,248(sp)
ffffffffc02012ec:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc02012ee:	10200073          	sret

ffffffffc02012f2 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc02012f2:	812a                	mv	sp,a0
    j __trapret
ffffffffc02012f4:	b755                	j	ffffffffc0201298 <__trapret>

ffffffffc02012f6 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc02012f6:	ee058593          	addi	a1,a1,-288

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc02012fa:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc02012fe:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0201302:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0201306:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc020130a:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc020130e:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0201312:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0201316:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc020131a:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc020131c:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc020131e:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0201320:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0201322:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0201324:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0201326:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0201328:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc020132a:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc020132c:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc020132e:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0201330:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0201332:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0201334:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0201336:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0201338:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc020133a:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc020133c:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc020133e:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0201340:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0201342:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0201344:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0201346:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0201348:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc020134a:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc020134c:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc020134e:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0201350:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0201352:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0201354:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0201356:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0201358:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc020135a:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc020135c:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc020135e:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0201360:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0201362:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0201364:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0201366:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0201368:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc020136a:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc020136c:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc020136e:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0201370:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0201372:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0201374:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0201376:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201378:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc020137a:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc020137c:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc020137e:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0201380:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0201382:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0201384:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0201386:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0201388:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc020138a:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc020138c:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc020138e:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0201390:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0201392:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0201394:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0201396:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0201398:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc020139a:	812e                	mv	sp,a1
ffffffffc020139c:	bdf5                	j	ffffffffc0201298 <__trapret>

ffffffffc020139e <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc020139e:	000bb797          	auipc	a5,0xbb
ffffffffc02013a2:	d1a78793          	addi	a5,a5,-742 # ffffffffc02bc0b8 <free_area>
ffffffffc02013a6:	e79c                	sd	a5,8(a5)
ffffffffc02013a8:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc02013aa:	0007a823          	sw	zero,16(a5)
}
ffffffffc02013ae:	8082                	ret

ffffffffc02013b0 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc02013b0:	000bb517          	auipc	a0,0xbb
ffffffffc02013b4:	d1856503          	lwu	a0,-744(a0) # ffffffffc02bc0c8 <free_area+0x10>
ffffffffc02013b8:	8082                	ret

ffffffffc02013ba <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc02013ba:	715d                	addi	sp,sp,-80
ffffffffc02013bc:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02013be:	000bb417          	auipc	s0,0xbb
ffffffffc02013c2:	cfa40413          	addi	s0,s0,-774 # ffffffffc02bc0b8 <free_area>
ffffffffc02013c6:	641c                	ld	a5,8(s0)
ffffffffc02013c8:	e486                	sd	ra,72(sp)
ffffffffc02013ca:	fc26                	sd	s1,56(sp)
ffffffffc02013cc:	f84a                	sd	s2,48(sp)
ffffffffc02013ce:	f44e                	sd	s3,40(sp)
ffffffffc02013d0:	f052                	sd	s4,32(sp)
ffffffffc02013d2:	ec56                	sd	s5,24(sp)
ffffffffc02013d4:	e85a                	sd	s6,16(sp)
ffffffffc02013d6:	e45e                	sd	s7,8(sp)
ffffffffc02013d8:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02013da:	2a878d63          	beq	a5,s0,ffffffffc0201694 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc02013de:	4481                	li	s1,0
ffffffffc02013e0:	4901                	li	s2,0
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02013e2:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02013e6:	8b09                	andi	a4,a4,2
ffffffffc02013e8:	2a070a63          	beqz	a4,ffffffffc020169c <default_check+0x2e2>
        count++, total += p->property;
ffffffffc02013ec:	ff87a703          	lw	a4,-8(a5)
ffffffffc02013f0:	679c                	ld	a5,8(a5)
ffffffffc02013f2:	2905                	addiw	s2,s2,1
ffffffffc02013f4:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02013f6:	fe8796e3          	bne	a5,s0,ffffffffc02013e2 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02013fa:	89a6                	mv	s3,s1
ffffffffc02013fc:	6df000ef          	jal	ra,ffffffffc02022da <nr_free_pages>
ffffffffc0201400:	6f351e63          	bne	a0,s3,ffffffffc0201afc <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201404:	4505                	li	a0,1
ffffffffc0201406:	657000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc020140a:	8aaa                	mv	s5,a0
ffffffffc020140c:	42050863          	beqz	a0,ffffffffc020183c <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201410:	4505                	li	a0,1
ffffffffc0201412:	64b000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0201416:	89aa                	mv	s3,a0
ffffffffc0201418:	70050263          	beqz	a0,ffffffffc0201b1c <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020141c:	4505                	li	a0,1
ffffffffc020141e:	63f000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0201422:	8a2a                	mv	s4,a0
ffffffffc0201424:	48050c63          	beqz	a0,ffffffffc02018bc <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201428:	293a8a63          	beq	s5,s3,ffffffffc02016bc <default_check+0x302>
ffffffffc020142c:	28aa8863          	beq	s5,a0,ffffffffc02016bc <default_check+0x302>
ffffffffc0201430:	28a98663          	beq	s3,a0,ffffffffc02016bc <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201434:	000aa783          	lw	a5,0(s5)
ffffffffc0201438:	2a079263          	bnez	a5,ffffffffc02016dc <default_check+0x322>
ffffffffc020143c:	0009a783          	lw	a5,0(s3) # fffffffffffff000 <end+0x3fd3eea4>
ffffffffc0201440:	28079e63          	bnez	a5,ffffffffc02016dc <default_check+0x322>
ffffffffc0201444:	411c                	lw	a5,0(a0)
ffffffffc0201446:	28079b63          	bnez	a5,ffffffffc02016dc <default_check+0x322>
    return page - pages + nbase;
ffffffffc020144a:	000bf797          	auipc	a5,0xbf
ffffffffc020144e:	cde7b783          	ld	a5,-802(a5) # ffffffffc02c0128 <pages>
ffffffffc0201452:	40fa8733          	sub	a4,s5,a5
ffffffffc0201456:	00007617          	auipc	a2,0x7
ffffffffc020145a:	97a63603          	ld	a2,-1670(a2) # ffffffffc0207dd0 <nbase>
ffffffffc020145e:	8719                	srai	a4,a4,0x6
ffffffffc0201460:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201462:	000bf697          	auipc	a3,0xbf
ffffffffc0201466:	cbe6b683          	ld	a3,-834(a3) # ffffffffc02c0120 <npage>
ffffffffc020146a:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020146c:	0732                	slli	a4,a4,0xc
ffffffffc020146e:	28d77763          	bgeu	a4,a3,ffffffffc02016fc <default_check+0x342>
    return page - pages + nbase;
ffffffffc0201472:	40f98733          	sub	a4,s3,a5
ffffffffc0201476:	8719                	srai	a4,a4,0x6
ffffffffc0201478:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020147a:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020147c:	4cd77063          	bgeu	a4,a3,ffffffffc020193c <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201480:	40f507b3          	sub	a5,a0,a5
ffffffffc0201484:	8799                	srai	a5,a5,0x6
ffffffffc0201486:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201488:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020148a:	30d7f963          	bgeu	a5,a3,ffffffffc020179c <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc020148e:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201490:	00043c03          	ld	s8,0(s0)
ffffffffc0201494:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201498:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc020149c:	e400                	sd	s0,8(s0)
ffffffffc020149e:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02014a0:	000bb797          	auipc	a5,0xbb
ffffffffc02014a4:	c207a423          	sw	zero,-984(a5) # ffffffffc02bc0c8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02014a8:	5b5000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc02014ac:	2c051863          	bnez	a0,ffffffffc020177c <default_check+0x3c2>
    free_page(p0);
ffffffffc02014b0:	4585                	li	a1,1
ffffffffc02014b2:	8556                	mv	a0,s5
ffffffffc02014b4:	5e7000ef          	jal	ra,ffffffffc020229a <free_pages>
    free_page(p1);
ffffffffc02014b8:	4585                	li	a1,1
ffffffffc02014ba:	854e                	mv	a0,s3
ffffffffc02014bc:	5df000ef          	jal	ra,ffffffffc020229a <free_pages>
    free_page(p2);
ffffffffc02014c0:	4585                	li	a1,1
ffffffffc02014c2:	8552                	mv	a0,s4
ffffffffc02014c4:	5d7000ef          	jal	ra,ffffffffc020229a <free_pages>
    assert(nr_free == 3);
ffffffffc02014c8:	4818                	lw	a4,16(s0)
ffffffffc02014ca:	478d                	li	a5,3
ffffffffc02014cc:	28f71863          	bne	a4,a5,ffffffffc020175c <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02014d0:	4505                	li	a0,1
ffffffffc02014d2:	58b000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc02014d6:	89aa                	mv	s3,a0
ffffffffc02014d8:	26050263          	beqz	a0,ffffffffc020173c <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014dc:	4505                	li	a0,1
ffffffffc02014de:	57f000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc02014e2:	8aaa                	mv	s5,a0
ffffffffc02014e4:	3a050c63          	beqz	a0,ffffffffc020189c <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014e8:	4505                	li	a0,1
ffffffffc02014ea:	573000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc02014ee:	8a2a                	mv	s4,a0
ffffffffc02014f0:	38050663          	beqz	a0,ffffffffc020187c <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc02014f4:	4505                	li	a0,1
ffffffffc02014f6:	567000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc02014fa:	36051163          	bnez	a0,ffffffffc020185c <default_check+0x4a2>
    free_page(p0);
ffffffffc02014fe:	4585                	li	a1,1
ffffffffc0201500:	854e                	mv	a0,s3
ffffffffc0201502:	599000ef          	jal	ra,ffffffffc020229a <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201506:	641c                	ld	a5,8(s0)
ffffffffc0201508:	20878a63          	beq	a5,s0,ffffffffc020171c <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc020150c:	4505                	li	a0,1
ffffffffc020150e:	54f000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0201512:	30a99563          	bne	s3,a0,ffffffffc020181c <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201516:	4505                	li	a0,1
ffffffffc0201518:	545000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc020151c:	2e051063          	bnez	a0,ffffffffc02017fc <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201520:	481c                	lw	a5,16(s0)
ffffffffc0201522:	2a079d63          	bnez	a5,ffffffffc02017dc <default_check+0x422>
    free_page(p);
ffffffffc0201526:	854e                	mv	a0,s3
ffffffffc0201528:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020152a:	01843023          	sd	s8,0(s0)
ffffffffc020152e:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201532:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201536:	565000ef          	jal	ra,ffffffffc020229a <free_pages>
    free_page(p1);
ffffffffc020153a:	4585                	li	a1,1
ffffffffc020153c:	8556                	mv	a0,s5
ffffffffc020153e:	55d000ef          	jal	ra,ffffffffc020229a <free_pages>
    free_page(p2);
ffffffffc0201542:	4585                	li	a1,1
ffffffffc0201544:	8552                	mv	a0,s4
ffffffffc0201546:	555000ef          	jal	ra,ffffffffc020229a <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc020154a:	4515                	li	a0,5
ffffffffc020154c:	511000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0201550:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201552:	26050563          	beqz	a0,ffffffffc02017bc <default_check+0x402>
ffffffffc0201556:	651c                	ld	a5,8(a0)
ffffffffc0201558:	8385                	srli	a5,a5,0x1
ffffffffc020155a:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc020155c:	54079063          	bnez	a5,ffffffffc0201a9c <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201560:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201562:	00043b03          	ld	s6,0(s0)
ffffffffc0201566:	00843a83          	ld	s5,8(s0)
ffffffffc020156a:	e000                	sd	s0,0(s0)
ffffffffc020156c:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc020156e:	4ef000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0201572:	50051563          	bnez	a0,ffffffffc0201a7c <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201576:	08098a13          	addi	s4,s3,128
ffffffffc020157a:	8552                	mv	a0,s4
ffffffffc020157c:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020157e:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201582:	000bb797          	auipc	a5,0xbb
ffffffffc0201586:	b407a323          	sw	zero,-1210(a5) # ffffffffc02bc0c8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020158a:	511000ef          	jal	ra,ffffffffc020229a <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc020158e:	4511                	li	a0,4
ffffffffc0201590:	4cd000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0201594:	4c051463          	bnez	a0,ffffffffc0201a5c <default_check+0x6a2>
ffffffffc0201598:	0889b783          	ld	a5,136(s3)
ffffffffc020159c:	8385                	srli	a5,a5,0x1
ffffffffc020159e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02015a0:	48078e63          	beqz	a5,ffffffffc0201a3c <default_check+0x682>
ffffffffc02015a4:	0909a703          	lw	a4,144(s3)
ffffffffc02015a8:	478d                	li	a5,3
ffffffffc02015aa:	48f71963          	bne	a4,a5,ffffffffc0201a3c <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02015ae:	450d                	li	a0,3
ffffffffc02015b0:	4ad000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc02015b4:	8c2a                	mv	s8,a0
ffffffffc02015b6:	46050363          	beqz	a0,ffffffffc0201a1c <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02015ba:	4505                	li	a0,1
ffffffffc02015bc:	4a1000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc02015c0:	42051e63          	bnez	a0,ffffffffc02019fc <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc02015c4:	418a1c63          	bne	s4,s8,ffffffffc02019dc <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02015c8:	4585                	li	a1,1
ffffffffc02015ca:	854e                	mv	a0,s3
ffffffffc02015cc:	4cf000ef          	jal	ra,ffffffffc020229a <free_pages>
    free_pages(p1, 3);
ffffffffc02015d0:	458d                	li	a1,3
ffffffffc02015d2:	8552                	mv	a0,s4
ffffffffc02015d4:	4c7000ef          	jal	ra,ffffffffc020229a <free_pages>
ffffffffc02015d8:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02015dc:	04098c13          	addi	s8,s3,64
ffffffffc02015e0:	8385                	srli	a5,a5,0x1
ffffffffc02015e2:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02015e4:	3c078c63          	beqz	a5,ffffffffc02019bc <default_check+0x602>
ffffffffc02015e8:	0109a703          	lw	a4,16(s3)
ffffffffc02015ec:	4785                	li	a5,1
ffffffffc02015ee:	3cf71763          	bne	a4,a5,ffffffffc02019bc <default_check+0x602>
ffffffffc02015f2:	008a3783          	ld	a5,8(s4)
ffffffffc02015f6:	8385                	srli	a5,a5,0x1
ffffffffc02015f8:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015fa:	3a078163          	beqz	a5,ffffffffc020199c <default_check+0x5e2>
ffffffffc02015fe:	010a2703          	lw	a4,16(s4)
ffffffffc0201602:	478d                	li	a5,3
ffffffffc0201604:	38f71c63          	bne	a4,a5,ffffffffc020199c <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201608:	4505                	li	a0,1
ffffffffc020160a:	453000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc020160e:	36a99763          	bne	s3,a0,ffffffffc020197c <default_check+0x5c2>
    free_page(p0);
ffffffffc0201612:	4585                	li	a1,1
ffffffffc0201614:	487000ef          	jal	ra,ffffffffc020229a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201618:	4509                	li	a0,2
ffffffffc020161a:	443000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc020161e:	32aa1f63          	bne	s4,a0,ffffffffc020195c <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201622:	4589                	li	a1,2
ffffffffc0201624:	477000ef          	jal	ra,ffffffffc020229a <free_pages>
    free_page(p2);
ffffffffc0201628:	4585                	li	a1,1
ffffffffc020162a:	8562                	mv	a0,s8
ffffffffc020162c:	46f000ef          	jal	ra,ffffffffc020229a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201630:	4515                	li	a0,5
ffffffffc0201632:	42b000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0201636:	89aa                	mv	s3,a0
ffffffffc0201638:	48050263          	beqz	a0,ffffffffc0201abc <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc020163c:	4505                	li	a0,1
ffffffffc020163e:	41f000ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0201642:	2c051d63          	bnez	a0,ffffffffc020191c <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201646:	481c                	lw	a5,16(s0)
ffffffffc0201648:	2a079a63          	bnez	a5,ffffffffc02018fc <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc020164c:	4595                	li	a1,5
ffffffffc020164e:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201650:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201654:	01643023          	sd	s6,0(s0)
ffffffffc0201658:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc020165c:	43f000ef          	jal	ra,ffffffffc020229a <free_pages>
    return listelm->next;
ffffffffc0201660:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201662:	00878963          	beq	a5,s0,ffffffffc0201674 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201666:	ff87a703          	lw	a4,-8(a5)
ffffffffc020166a:	679c                	ld	a5,8(a5)
ffffffffc020166c:	397d                	addiw	s2,s2,-1
ffffffffc020166e:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201670:	fe879be3          	bne	a5,s0,ffffffffc0201666 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0201674:	26091463          	bnez	s2,ffffffffc02018dc <default_check+0x522>
    assert(total == 0);
ffffffffc0201678:	46049263          	bnez	s1,ffffffffc0201adc <default_check+0x722>
}
ffffffffc020167c:	60a6                	ld	ra,72(sp)
ffffffffc020167e:	6406                	ld	s0,64(sp)
ffffffffc0201680:	74e2                	ld	s1,56(sp)
ffffffffc0201682:	7942                	ld	s2,48(sp)
ffffffffc0201684:	79a2                	ld	s3,40(sp)
ffffffffc0201686:	7a02                	ld	s4,32(sp)
ffffffffc0201688:	6ae2                	ld	s5,24(sp)
ffffffffc020168a:	6b42                	ld	s6,16(sp)
ffffffffc020168c:	6ba2                	ld	s7,8(sp)
ffffffffc020168e:	6c02                	ld	s8,0(sp)
ffffffffc0201690:	6161                	addi	sp,sp,80
ffffffffc0201692:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc0201694:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201696:	4481                	li	s1,0
ffffffffc0201698:	4901                	li	s2,0
ffffffffc020169a:	b38d                	j	ffffffffc02013fc <default_check+0x42>
        assert(PageProperty(p));
ffffffffc020169c:	00005697          	auipc	a3,0x5
ffffffffc02016a0:	0c468693          	addi	a3,a3,196 # ffffffffc0206760 <commands+0xb08>
ffffffffc02016a4:	00005617          	auipc	a2,0x5
ffffffffc02016a8:	0cc60613          	addi	a2,a2,204 # ffffffffc0206770 <commands+0xb18>
ffffffffc02016ac:	11000593          	li	a1,272
ffffffffc02016b0:	00005517          	auipc	a0,0x5
ffffffffc02016b4:	0d850513          	addi	a0,a0,216 # ffffffffc0206788 <commands+0xb30>
ffffffffc02016b8:	dd7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02016bc:	00005697          	auipc	a3,0x5
ffffffffc02016c0:	16468693          	addi	a3,a3,356 # ffffffffc0206820 <commands+0xbc8>
ffffffffc02016c4:	00005617          	auipc	a2,0x5
ffffffffc02016c8:	0ac60613          	addi	a2,a2,172 # ffffffffc0206770 <commands+0xb18>
ffffffffc02016cc:	0db00593          	li	a1,219
ffffffffc02016d0:	00005517          	auipc	a0,0x5
ffffffffc02016d4:	0b850513          	addi	a0,a0,184 # ffffffffc0206788 <commands+0xb30>
ffffffffc02016d8:	db7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02016dc:	00005697          	auipc	a3,0x5
ffffffffc02016e0:	16c68693          	addi	a3,a3,364 # ffffffffc0206848 <commands+0xbf0>
ffffffffc02016e4:	00005617          	auipc	a2,0x5
ffffffffc02016e8:	08c60613          	addi	a2,a2,140 # ffffffffc0206770 <commands+0xb18>
ffffffffc02016ec:	0dc00593          	li	a1,220
ffffffffc02016f0:	00005517          	auipc	a0,0x5
ffffffffc02016f4:	09850513          	addi	a0,a0,152 # ffffffffc0206788 <commands+0xb30>
ffffffffc02016f8:	d97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02016fc:	00005697          	auipc	a3,0x5
ffffffffc0201700:	18c68693          	addi	a3,a3,396 # ffffffffc0206888 <commands+0xc30>
ffffffffc0201704:	00005617          	auipc	a2,0x5
ffffffffc0201708:	06c60613          	addi	a2,a2,108 # ffffffffc0206770 <commands+0xb18>
ffffffffc020170c:	0de00593          	li	a1,222
ffffffffc0201710:	00005517          	auipc	a0,0x5
ffffffffc0201714:	07850513          	addi	a0,a0,120 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201718:	d77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc020171c:	00005697          	auipc	a3,0x5
ffffffffc0201720:	1f468693          	addi	a3,a3,500 # ffffffffc0206910 <commands+0xcb8>
ffffffffc0201724:	00005617          	auipc	a2,0x5
ffffffffc0201728:	04c60613          	addi	a2,a2,76 # ffffffffc0206770 <commands+0xb18>
ffffffffc020172c:	0f700593          	li	a1,247
ffffffffc0201730:	00005517          	auipc	a0,0x5
ffffffffc0201734:	05850513          	addi	a0,a0,88 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201738:	d57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020173c:	00005697          	auipc	a3,0x5
ffffffffc0201740:	08468693          	addi	a3,a3,132 # ffffffffc02067c0 <commands+0xb68>
ffffffffc0201744:	00005617          	auipc	a2,0x5
ffffffffc0201748:	02c60613          	addi	a2,a2,44 # ffffffffc0206770 <commands+0xb18>
ffffffffc020174c:	0f000593          	li	a1,240
ffffffffc0201750:	00005517          	auipc	a0,0x5
ffffffffc0201754:	03850513          	addi	a0,a0,56 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201758:	d37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc020175c:	00005697          	auipc	a3,0x5
ffffffffc0201760:	1a468693          	addi	a3,a3,420 # ffffffffc0206900 <commands+0xca8>
ffffffffc0201764:	00005617          	auipc	a2,0x5
ffffffffc0201768:	00c60613          	addi	a2,a2,12 # ffffffffc0206770 <commands+0xb18>
ffffffffc020176c:	0ee00593          	li	a1,238
ffffffffc0201770:	00005517          	auipc	a0,0x5
ffffffffc0201774:	01850513          	addi	a0,a0,24 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201778:	d17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020177c:	00005697          	auipc	a3,0x5
ffffffffc0201780:	16c68693          	addi	a3,a3,364 # ffffffffc02068e8 <commands+0xc90>
ffffffffc0201784:	00005617          	auipc	a2,0x5
ffffffffc0201788:	fec60613          	addi	a2,a2,-20 # ffffffffc0206770 <commands+0xb18>
ffffffffc020178c:	0e900593          	li	a1,233
ffffffffc0201790:	00005517          	auipc	a0,0x5
ffffffffc0201794:	ff850513          	addi	a0,a0,-8 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201798:	cf7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020179c:	00005697          	auipc	a3,0x5
ffffffffc02017a0:	12c68693          	addi	a3,a3,300 # ffffffffc02068c8 <commands+0xc70>
ffffffffc02017a4:	00005617          	auipc	a2,0x5
ffffffffc02017a8:	fcc60613          	addi	a2,a2,-52 # ffffffffc0206770 <commands+0xb18>
ffffffffc02017ac:	0e000593          	li	a1,224
ffffffffc02017b0:	00005517          	auipc	a0,0x5
ffffffffc02017b4:	fd850513          	addi	a0,a0,-40 # ffffffffc0206788 <commands+0xb30>
ffffffffc02017b8:	cd7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc02017bc:	00005697          	auipc	a3,0x5
ffffffffc02017c0:	19c68693          	addi	a3,a3,412 # ffffffffc0206958 <commands+0xd00>
ffffffffc02017c4:	00005617          	auipc	a2,0x5
ffffffffc02017c8:	fac60613          	addi	a2,a2,-84 # ffffffffc0206770 <commands+0xb18>
ffffffffc02017cc:	11800593          	li	a1,280
ffffffffc02017d0:	00005517          	auipc	a0,0x5
ffffffffc02017d4:	fb850513          	addi	a0,a0,-72 # ffffffffc0206788 <commands+0xb30>
ffffffffc02017d8:	cb7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02017dc:	00005697          	auipc	a3,0x5
ffffffffc02017e0:	16c68693          	addi	a3,a3,364 # ffffffffc0206948 <commands+0xcf0>
ffffffffc02017e4:	00005617          	auipc	a2,0x5
ffffffffc02017e8:	f8c60613          	addi	a2,a2,-116 # ffffffffc0206770 <commands+0xb18>
ffffffffc02017ec:	0fd00593          	li	a1,253
ffffffffc02017f0:	00005517          	auipc	a0,0x5
ffffffffc02017f4:	f9850513          	addi	a0,a0,-104 # ffffffffc0206788 <commands+0xb30>
ffffffffc02017f8:	c97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02017fc:	00005697          	auipc	a3,0x5
ffffffffc0201800:	0ec68693          	addi	a3,a3,236 # ffffffffc02068e8 <commands+0xc90>
ffffffffc0201804:	00005617          	auipc	a2,0x5
ffffffffc0201808:	f6c60613          	addi	a2,a2,-148 # ffffffffc0206770 <commands+0xb18>
ffffffffc020180c:	0fb00593          	li	a1,251
ffffffffc0201810:	00005517          	auipc	a0,0x5
ffffffffc0201814:	f7850513          	addi	a0,a0,-136 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201818:	c77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020181c:	00005697          	auipc	a3,0x5
ffffffffc0201820:	10c68693          	addi	a3,a3,268 # ffffffffc0206928 <commands+0xcd0>
ffffffffc0201824:	00005617          	auipc	a2,0x5
ffffffffc0201828:	f4c60613          	addi	a2,a2,-180 # ffffffffc0206770 <commands+0xb18>
ffffffffc020182c:	0fa00593          	li	a1,250
ffffffffc0201830:	00005517          	auipc	a0,0x5
ffffffffc0201834:	f5850513          	addi	a0,a0,-168 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201838:	c57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020183c:	00005697          	auipc	a3,0x5
ffffffffc0201840:	f8468693          	addi	a3,a3,-124 # ffffffffc02067c0 <commands+0xb68>
ffffffffc0201844:	00005617          	auipc	a2,0x5
ffffffffc0201848:	f2c60613          	addi	a2,a2,-212 # ffffffffc0206770 <commands+0xb18>
ffffffffc020184c:	0d700593          	li	a1,215
ffffffffc0201850:	00005517          	auipc	a0,0x5
ffffffffc0201854:	f3850513          	addi	a0,a0,-200 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201858:	c37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020185c:	00005697          	auipc	a3,0x5
ffffffffc0201860:	08c68693          	addi	a3,a3,140 # ffffffffc02068e8 <commands+0xc90>
ffffffffc0201864:	00005617          	auipc	a2,0x5
ffffffffc0201868:	f0c60613          	addi	a2,a2,-244 # ffffffffc0206770 <commands+0xb18>
ffffffffc020186c:	0f400593          	li	a1,244
ffffffffc0201870:	00005517          	auipc	a0,0x5
ffffffffc0201874:	f1850513          	addi	a0,a0,-232 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201878:	c17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020187c:	00005697          	auipc	a3,0x5
ffffffffc0201880:	f8468693          	addi	a3,a3,-124 # ffffffffc0206800 <commands+0xba8>
ffffffffc0201884:	00005617          	auipc	a2,0x5
ffffffffc0201888:	eec60613          	addi	a2,a2,-276 # ffffffffc0206770 <commands+0xb18>
ffffffffc020188c:	0f200593          	li	a1,242
ffffffffc0201890:	00005517          	auipc	a0,0x5
ffffffffc0201894:	ef850513          	addi	a0,a0,-264 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201898:	bf7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020189c:	00005697          	auipc	a3,0x5
ffffffffc02018a0:	f4468693          	addi	a3,a3,-188 # ffffffffc02067e0 <commands+0xb88>
ffffffffc02018a4:	00005617          	auipc	a2,0x5
ffffffffc02018a8:	ecc60613          	addi	a2,a2,-308 # ffffffffc0206770 <commands+0xb18>
ffffffffc02018ac:	0f100593          	li	a1,241
ffffffffc02018b0:	00005517          	auipc	a0,0x5
ffffffffc02018b4:	ed850513          	addi	a0,a0,-296 # ffffffffc0206788 <commands+0xb30>
ffffffffc02018b8:	bd7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02018bc:	00005697          	auipc	a3,0x5
ffffffffc02018c0:	f4468693          	addi	a3,a3,-188 # ffffffffc0206800 <commands+0xba8>
ffffffffc02018c4:	00005617          	auipc	a2,0x5
ffffffffc02018c8:	eac60613          	addi	a2,a2,-340 # ffffffffc0206770 <commands+0xb18>
ffffffffc02018cc:	0d900593          	li	a1,217
ffffffffc02018d0:	00005517          	auipc	a0,0x5
ffffffffc02018d4:	eb850513          	addi	a0,a0,-328 # ffffffffc0206788 <commands+0xb30>
ffffffffc02018d8:	bb7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc02018dc:	00005697          	auipc	a3,0x5
ffffffffc02018e0:	1cc68693          	addi	a3,a3,460 # ffffffffc0206aa8 <commands+0xe50>
ffffffffc02018e4:	00005617          	auipc	a2,0x5
ffffffffc02018e8:	e8c60613          	addi	a2,a2,-372 # ffffffffc0206770 <commands+0xb18>
ffffffffc02018ec:	14600593          	li	a1,326
ffffffffc02018f0:	00005517          	auipc	a0,0x5
ffffffffc02018f4:	e9850513          	addi	a0,a0,-360 # ffffffffc0206788 <commands+0xb30>
ffffffffc02018f8:	b97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02018fc:	00005697          	auipc	a3,0x5
ffffffffc0201900:	04c68693          	addi	a3,a3,76 # ffffffffc0206948 <commands+0xcf0>
ffffffffc0201904:	00005617          	auipc	a2,0x5
ffffffffc0201908:	e6c60613          	addi	a2,a2,-404 # ffffffffc0206770 <commands+0xb18>
ffffffffc020190c:	13a00593          	li	a1,314
ffffffffc0201910:	00005517          	auipc	a0,0x5
ffffffffc0201914:	e7850513          	addi	a0,a0,-392 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201918:	b77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020191c:	00005697          	auipc	a3,0x5
ffffffffc0201920:	fcc68693          	addi	a3,a3,-52 # ffffffffc02068e8 <commands+0xc90>
ffffffffc0201924:	00005617          	auipc	a2,0x5
ffffffffc0201928:	e4c60613          	addi	a2,a2,-436 # ffffffffc0206770 <commands+0xb18>
ffffffffc020192c:	13800593          	li	a1,312
ffffffffc0201930:	00005517          	auipc	a0,0x5
ffffffffc0201934:	e5850513          	addi	a0,a0,-424 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201938:	b57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020193c:	00005697          	auipc	a3,0x5
ffffffffc0201940:	f6c68693          	addi	a3,a3,-148 # ffffffffc02068a8 <commands+0xc50>
ffffffffc0201944:	00005617          	auipc	a2,0x5
ffffffffc0201948:	e2c60613          	addi	a2,a2,-468 # ffffffffc0206770 <commands+0xb18>
ffffffffc020194c:	0df00593          	li	a1,223
ffffffffc0201950:	00005517          	auipc	a0,0x5
ffffffffc0201954:	e3850513          	addi	a0,a0,-456 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201958:	b37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020195c:	00005697          	auipc	a3,0x5
ffffffffc0201960:	10c68693          	addi	a3,a3,268 # ffffffffc0206a68 <commands+0xe10>
ffffffffc0201964:	00005617          	auipc	a2,0x5
ffffffffc0201968:	e0c60613          	addi	a2,a2,-500 # ffffffffc0206770 <commands+0xb18>
ffffffffc020196c:	13200593          	li	a1,306
ffffffffc0201970:	00005517          	auipc	a0,0x5
ffffffffc0201974:	e1850513          	addi	a0,a0,-488 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201978:	b17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020197c:	00005697          	auipc	a3,0x5
ffffffffc0201980:	0cc68693          	addi	a3,a3,204 # ffffffffc0206a48 <commands+0xdf0>
ffffffffc0201984:	00005617          	auipc	a2,0x5
ffffffffc0201988:	dec60613          	addi	a2,a2,-532 # ffffffffc0206770 <commands+0xb18>
ffffffffc020198c:	13000593          	li	a1,304
ffffffffc0201990:	00005517          	auipc	a0,0x5
ffffffffc0201994:	df850513          	addi	a0,a0,-520 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201998:	af7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020199c:	00005697          	auipc	a3,0x5
ffffffffc02019a0:	08468693          	addi	a3,a3,132 # ffffffffc0206a20 <commands+0xdc8>
ffffffffc02019a4:	00005617          	auipc	a2,0x5
ffffffffc02019a8:	dcc60613          	addi	a2,a2,-564 # ffffffffc0206770 <commands+0xb18>
ffffffffc02019ac:	12e00593          	li	a1,302
ffffffffc02019b0:	00005517          	auipc	a0,0x5
ffffffffc02019b4:	dd850513          	addi	a0,a0,-552 # ffffffffc0206788 <commands+0xb30>
ffffffffc02019b8:	ad7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02019bc:	00005697          	auipc	a3,0x5
ffffffffc02019c0:	03c68693          	addi	a3,a3,60 # ffffffffc02069f8 <commands+0xda0>
ffffffffc02019c4:	00005617          	auipc	a2,0x5
ffffffffc02019c8:	dac60613          	addi	a2,a2,-596 # ffffffffc0206770 <commands+0xb18>
ffffffffc02019cc:	12d00593          	li	a1,301
ffffffffc02019d0:	00005517          	auipc	a0,0x5
ffffffffc02019d4:	db850513          	addi	a0,a0,-584 # ffffffffc0206788 <commands+0xb30>
ffffffffc02019d8:	ab7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc02019dc:	00005697          	auipc	a3,0x5
ffffffffc02019e0:	00c68693          	addi	a3,a3,12 # ffffffffc02069e8 <commands+0xd90>
ffffffffc02019e4:	00005617          	auipc	a2,0x5
ffffffffc02019e8:	d8c60613          	addi	a2,a2,-628 # ffffffffc0206770 <commands+0xb18>
ffffffffc02019ec:	12800593          	li	a1,296
ffffffffc02019f0:	00005517          	auipc	a0,0x5
ffffffffc02019f4:	d9850513          	addi	a0,a0,-616 # ffffffffc0206788 <commands+0xb30>
ffffffffc02019f8:	a97fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02019fc:	00005697          	auipc	a3,0x5
ffffffffc0201a00:	eec68693          	addi	a3,a3,-276 # ffffffffc02068e8 <commands+0xc90>
ffffffffc0201a04:	00005617          	auipc	a2,0x5
ffffffffc0201a08:	d6c60613          	addi	a2,a2,-660 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201a0c:	12700593          	li	a1,295
ffffffffc0201a10:	00005517          	auipc	a0,0x5
ffffffffc0201a14:	d7850513          	addi	a0,a0,-648 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201a18:	a77fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201a1c:	00005697          	auipc	a3,0x5
ffffffffc0201a20:	fac68693          	addi	a3,a3,-84 # ffffffffc02069c8 <commands+0xd70>
ffffffffc0201a24:	00005617          	auipc	a2,0x5
ffffffffc0201a28:	d4c60613          	addi	a2,a2,-692 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201a2c:	12600593          	li	a1,294
ffffffffc0201a30:	00005517          	auipc	a0,0x5
ffffffffc0201a34:	d5850513          	addi	a0,a0,-680 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201a38:	a57fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201a3c:	00005697          	auipc	a3,0x5
ffffffffc0201a40:	f5c68693          	addi	a3,a3,-164 # ffffffffc0206998 <commands+0xd40>
ffffffffc0201a44:	00005617          	auipc	a2,0x5
ffffffffc0201a48:	d2c60613          	addi	a2,a2,-724 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201a4c:	12500593          	li	a1,293
ffffffffc0201a50:	00005517          	auipc	a0,0x5
ffffffffc0201a54:	d3850513          	addi	a0,a0,-712 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201a58:	a37fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201a5c:	00005697          	auipc	a3,0x5
ffffffffc0201a60:	f2468693          	addi	a3,a3,-220 # ffffffffc0206980 <commands+0xd28>
ffffffffc0201a64:	00005617          	auipc	a2,0x5
ffffffffc0201a68:	d0c60613          	addi	a2,a2,-756 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201a6c:	12400593          	li	a1,292
ffffffffc0201a70:	00005517          	auipc	a0,0x5
ffffffffc0201a74:	d1850513          	addi	a0,a0,-744 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201a78:	a17fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201a7c:	00005697          	auipc	a3,0x5
ffffffffc0201a80:	e6c68693          	addi	a3,a3,-404 # ffffffffc02068e8 <commands+0xc90>
ffffffffc0201a84:	00005617          	auipc	a2,0x5
ffffffffc0201a88:	cec60613          	addi	a2,a2,-788 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201a8c:	11e00593          	li	a1,286
ffffffffc0201a90:	00005517          	auipc	a0,0x5
ffffffffc0201a94:	cf850513          	addi	a0,a0,-776 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201a98:	9f7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc0201a9c:	00005697          	auipc	a3,0x5
ffffffffc0201aa0:	ecc68693          	addi	a3,a3,-308 # ffffffffc0206968 <commands+0xd10>
ffffffffc0201aa4:	00005617          	auipc	a2,0x5
ffffffffc0201aa8:	ccc60613          	addi	a2,a2,-820 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201aac:	11900593          	li	a1,281
ffffffffc0201ab0:	00005517          	auipc	a0,0x5
ffffffffc0201ab4:	cd850513          	addi	a0,a0,-808 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201ab8:	9d7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201abc:	00005697          	auipc	a3,0x5
ffffffffc0201ac0:	fcc68693          	addi	a3,a3,-52 # ffffffffc0206a88 <commands+0xe30>
ffffffffc0201ac4:	00005617          	auipc	a2,0x5
ffffffffc0201ac8:	cac60613          	addi	a2,a2,-852 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201acc:	13700593          	li	a1,311
ffffffffc0201ad0:	00005517          	auipc	a0,0x5
ffffffffc0201ad4:	cb850513          	addi	a0,a0,-840 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201ad8:	9b7fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc0201adc:	00005697          	auipc	a3,0x5
ffffffffc0201ae0:	fdc68693          	addi	a3,a3,-36 # ffffffffc0206ab8 <commands+0xe60>
ffffffffc0201ae4:	00005617          	auipc	a2,0x5
ffffffffc0201ae8:	c8c60613          	addi	a2,a2,-884 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201aec:	14700593          	li	a1,327
ffffffffc0201af0:	00005517          	auipc	a0,0x5
ffffffffc0201af4:	c9850513          	addi	a0,a0,-872 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201af8:	997fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc0201afc:	00005697          	auipc	a3,0x5
ffffffffc0201b00:	ca468693          	addi	a3,a3,-860 # ffffffffc02067a0 <commands+0xb48>
ffffffffc0201b04:	00005617          	auipc	a2,0x5
ffffffffc0201b08:	c6c60613          	addi	a2,a2,-916 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201b0c:	11300593          	li	a1,275
ffffffffc0201b10:	00005517          	auipc	a0,0x5
ffffffffc0201b14:	c7850513          	addi	a0,a0,-904 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201b18:	977fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201b1c:	00005697          	auipc	a3,0x5
ffffffffc0201b20:	cc468693          	addi	a3,a3,-828 # ffffffffc02067e0 <commands+0xb88>
ffffffffc0201b24:	00005617          	auipc	a2,0x5
ffffffffc0201b28:	c4c60613          	addi	a2,a2,-948 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201b2c:	0d800593          	li	a1,216
ffffffffc0201b30:	00005517          	auipc	a0,0x5
ffffffffc0201b34:	c5850513          	addi	a0,a0,-936 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201b38:	957fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201b3c <default_free_pages>:
{
ffffffffc0201b3c:	1141                	addi	sp,sp,-16
ffffffffc0201b3e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201b40:	14058463          	beqz	a1,ffffffffc0201c88 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201b44:	00659693          	slli	a3,a1,0x6
ffffffffc0201b48:	96aa                	add	a3,a3,a0
ffffffffc0201b4a:	87aa                	mv	a5,a0
ffffffffc0201b4c:	02d50263          	beq	a0,a3,ffffffffc0201b70 <default_free_pages+0x34>
ffffffffc0201b50:	6798                	ld	a4,8(a5)
ffffffffc0201b52:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201b54:	10071a63          	bnez	a4,ffffffffc0201c68 <default_free_pages+0x12c>
ffffffffc0201b58:	6798                	ld	a4,8(a5)
ffffffffc0201b5a:	8b09                	andi	a4,a4,2
ffffffffc0201b5c:	10071663          	bnez	a4,ffffffffc0201c68 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0201b60:	0007b423          	sd	zero,8(a5)
    page->ref = val;
ffffffffc0201b64:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201b68:	04078793          	addi	a5,a5,64
ffffffffc0201b6c:	fed792e3          	bne	a5,a3,ffffffffc0201b50 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201b70:	2581                	sext.w	a1,a1
ffffffffc0201b72:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201b74:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201b78:	4789                	li	a5,2
ffffffffc0201b7a:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201b7e:	000ba697          	auipc	a3,0xba
ffffffffc0201b82:	53a68693          	addi	a3,a3,1338 # ffffffffc02bc0b8 <free_area>
ffffffffc0201b86:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201b88:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201b8a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201b8e:	9db9                	addw	a1,a1,a4
ffffffffc0201b90:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201b92:	0ad78463          	beq	a5,a3,ffffffffc0201c3a <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc0201b96:	fe878713          	addi	a4,a5,-24
ffffffffc0201b9a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201b9e:	4581                	li	a1,0
            if (base < page)
ffffffffc0201ba0:	00e56a63          	bltu	a0,a4,ffffffffc0201bb4 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201ba4:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201ba6:	04d70c63          	beq	a4,a3,ffffffffc0201bfe <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc0201baa:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201bac:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201bb0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ba4 <default_free_pages+0x68>
ffffffffc0201bb4:	c199                	beqz	a1,ffffffffc0201bba <default_free_pages+0x7e>
ffffffffc0201bb6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201bba:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201bbc:	e390                	sd	a2,0(a5)
ffffffffc0201bbe:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201bc0:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201bc2:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0201bc4:	00d70d63          	beq	a4,a3,ffffffffc0201bde <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201bc8:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201bcc:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201bd0:	02059813          	slli	a6,a1,0x20
ffffffffc0201bd4:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201bd8:	97b2                	add	a5,a5,a2
ffffffffc0201bda:	02f50c63          	beq	a0,a5,ffffffffc0201c12 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201bde:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201be0:	00d78c63          	beq	a5,a3,ffffffffc0201bf8 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201be4:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201be6:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201bea:	02061593          	slli	a1,a2,0x20
ffffffffc0201bee:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201bf2:	972a                	add	a4,a4,a0
ffffffffc0201bf4:	04e68a63          	beq	a3,a4,ffffffffc0201c48 <default_free_pages+0x10c>
}
ffffffffc0201bf8:	60a2                	ld	ra,8(sp)
ffffffffc0201bfa:	0141                	addi	sp,sp,16
ffffffffc0201bfc:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201bfe:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201c00:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201c02:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201c04:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201c06:	02d70763          	beq	a4,a3,ffffffffc0201c34 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201c0a:	8832                	mv	a6,a2
ffffffffc0201c0c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201c0e:	87ba                	mv	a5,a4
ffffffffc0201c10:	bf71                	j	ffffffffc0201bac <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201c12:	491c                	lw	a5,16(a0)
ffffffffc0201c14:	9dbd                	addw	a1,a1,a5
ffffffffc0201c16:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201c1a:	57f5                	li	a5,-3
ffffffffc0201c1c:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201c20:	01853803          	ld	a6,24(a0)
ffffffffc0201c24:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201c26:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201c28:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201c2c:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201c2e:	0105b023          	sd	a6,0(a1)
ffffffffc0201c32:	b77d                	j	ffffffffc0201be0 <default_free_pages+0xa4>
ffffffffc0201c34:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201c36:	873e                	mv	a4,a5
ffffffffc0201c38:	bf41                	j	ffffffffc0201bc8 <default_free_pages+0x8c>
}
ffffffffc0201c3a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201c3c:	e390                	sd	a2,0(a5)
ffffffffc0201c3e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201c40:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201c42:	ed1c                	sd	a5,24(a0)
ffffffffc0201c44:	0141                	addi	sp,sp,16
ffffffffc0201c46:	8082                	ret
            base->property += p->property;
ffffffffc0201c48:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201c4c:	ff078693          	addi	a3,a5,-16
ffffffffc0201c50:	9e39                	addw	a2,a2,a4
ffffffffc0201c52:	c910                	sw	a2,16(a0)
ffffffffc0201c54:	5775                	li	a4,-3
ffffffffc0201c56:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201c5a:	6398                	ld	a4,0(a5)
ffffffffc0201c5c:	679c                	ld	a5,8(a5)
}
ffffffffc0201c5e:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201c60:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201c62:	e398                	sd	a4,0(a5)
ffffffffc0201c64:	0141                	addi	sp,sp,16
ffffffffc0201c66:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201c68:	00005697          	auipc	a3,0x5
ffffffffc0201c6c:	e6868693          	addi	a3,a3,-408 # ffffffffc0206ad0 <commands+0xe78>
ffffffffc0201c70:	00005617          	auipc	a2,0x5
ffffffffc0201c74:	b0060613          	addi	a2,a2,-1280 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201c78:	09400593          	li	a1,148
ffffffffc0201c7c:	00005517          	auipc	a0,0x5
ffffffffc0201c80:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201c84:	80bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201c88:	00005697          	auipc	a3,0x5
ffffffffc0201c8c:	e4068693          	addi	a3,a3,-448 # ffffffffc0206ac8 <commands+0xe70>
ffffffffc0201c90:	00005617          	auipc	a2,0x5
ffffffffc0201c94:	ae060613          	addi	a2,a2,-1312 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201c98:	09000593          	li	a1,144
ffffffffc0201c9c:	00005517          	auipc	a0,0x5
ffffffffc0201ca0:	aec50513          	addi	a0,a0,-1300 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201ca4:	feafe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ca8 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201ca8:	c941                	beqz	a0,ffffffffc0201d38 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0201caa:	000ba597          	auipc	a1,0xba
ffffffffc0201cae:	40e58593          	addi	a1,a1,1038 # ffffffffc02bc0b8 <free_area>
ffffffffc0201cb2:	0105a803          	lw	a6,16(a1)
ffffffffc0201cb6:	872a                	mv	a4,a0
ffffffffc0201cb8:	02081793          	slli	a5,a6,0x20
ffffffffc0201cbc:	9381                	srli	a5,a5,0x20
ffffffffc0201cbe:	00a7ee63          	bltu	a5,a0,ffffffffc0201cda <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201cc2:	87ae                	mv	a5,a1
ffffffffc0201cc4:	a801                	j	ffffffffc0201cd4 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201cc6:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201cca:	02069613          	slli	a2,a3,0x20
ffffffffc0201cce:	9201                	srli	a2,a2,0x20
ffffffffc0201cd0:	00e67763          	bgeu	a2,a4,ffffffffc0201cde <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201cd4:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201cd6:	feb798e3          	bne	a5,a1,ffffffffc0201cc6 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201cda:	4501                	li	a0,0
}
ffffffffc0201cdc:	8082                	ret
    return listelm->prev;
ffffffffc0201cde:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201ce2:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201ce6:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201cea:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201cee:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201cf2:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201cf6:	02c77863          	bgeu	a4,a2,ffffffffc0201d26 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201cfa:	071a                	slli	a4,a4,0x6
ffffffffc0201cfc:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201cfe:	41c686bb          	subw	a3,a3,t3
ffffffffc0201d02:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201d04:	00870613          	addi	a2,a4,8
ffffffffc0201d08:	4689                	li	a3,2
ffffffffc0201d0a:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201d0e:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201d12:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201d16:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201d1a:	e290                	sd	a2,0(a3)
ffffffffc0201d1c:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201d20:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201d22:	01173c23          	sd	a7,24(a4)
ffffffffc0201d26:	41c8083b          	subw	a6,a6,t3
ffffffffc0201d2a:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201d2e:	5775                	li	a4,-3
ffffffffc0201d30:	17c1                	addi	a5,a5,-16
ffffffffc0201d32:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201d36:	8082                	ret
{
ffffffffc0201d38:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201d3a:	00005697          	auipc	a3,0x5
ffffffffc0201d3e:	d8e68693          	addi	a3,a3,-626 # ffffffffc0206ac8 <commands+0xe70>
ffffffffc0201d42:	00005617          	auipc	a2,0x5
ffffffffc0201d46:	a2e60613          	addi	a2,a2,-1490 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201d4a:	06c00593          	li	a1,108
ffffffffc0201d4e:	00005517          	auipc	a0,0x5
ffffffffc0201d52:	a3a50513          	addi	a0,a0,-1478 # ffffffffc0206788 <commands+0xb30>
{
ffffffffc0201d56:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201d58:	f36fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201d5c <default_init_memmap>:
{
ffffffffc0201d5c:	1141                	addi	sp,sp,-16
ffffffffc0201d5e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201d60:	c5f1                	beqz	a1,ffffffffc0201e2c <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201d62:	00659693          	slli	a3,a1,0x6
ffffffffc0201d66:	96aa                	add	a3,a3,a0
ffffffffc0201d68:	87aa                	mv	a5,a0
ffffffffc0201d6a:	00d50f63          	beq	a0,a3,ffffffffc0201d88 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201d6e:	6798                	ld	a4,8(a5)
ffffffffc0201d70:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0201d72:	cf49                	beqz	a4,ffffffffc0201e0c <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201d74:	0007a823          	sw	zero,16(a5)
ffffffffc0201d78:	0007b423          	sd	zero,8(a5)
ffffffffc0201d7c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201d80:	04078793          	addi	a5,a5,64
ffffffffc0201d84:	fed795e3          	bne	a5,a3,ffffffffc0201d6e <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201d88:	2581                	sext.w	a1,a1
ffffffffc0201d8a:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201d8c:	4789                	li	a5,2
ffffffffc0201d8e:	00850713          	addi	a4,a0,8
ffffffffc0201d92:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201d96:	000ba697          	auipc	a3,0xba
ffffffffc0201d9a:	32268693          	addi	a3,a3,802 # ffffffffc02bc0b8 <free_area>
ffffffffc0201d9e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201da0:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201da2:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201da6:	9db9                	addw	a1,a1,a4
ffffffffc0201da8:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201daa:	04d78a63          	beq	a5,a3,ffffffffc0201dfe <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0201dae:	fe878713          	addi	a4,a5,-24
ffffffffc0201db2:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201db6:	4581                	li	a1,0
            if (base < page)
ffffffffc0201db8:	00e56a63          	bltu	a0,a4,ffffffffc0201dcc <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201dbc:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201dbe:	02d70263          	beq	a4,a3,ffffffffc0201de2 <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201dc2:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201dc4:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201dc8:	fee57ae3          	bgeu	a0,a4,ffffffffc0201dbc <default_init_memmap+0x60>
ffffffffc0201dcc:	c199                	beqz	a1,ffffffffc0201dd2 <default_init_memmap+0x76>
ffffffffc0201dce:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201dd2:	6398                	ld	a4,0(a5)
}
ffffffffc0201dd4:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201dd6:	e390                	sd	a2,0(a5)
ffffffffc0201dd8:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201dda:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201ddc:	ed18                	sd	a4,24(a0)
ffffffffc0201dde:	0141                	addi	sp,sp,16
ffffffffc0201de0:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201de2:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201de4:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201de6:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201de8:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201dea:	00d70663          	beq	a4,a3,ffffffffc0201df6 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201dee:	8832                	mv	a6,a2
ffffffffc0201df0:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201df2:	87ba                	mv	a5,a4
ffffffffc0201df4:	bfc1                	j	ffffffffc0201dc4 <default_init_memmap+0x68>
}
ffffffffc0201df6:	60a2                	ld	ra,8(sp)
ffffffffc0201df8:	e290                	sd	a2,0(a3)
ffffffffc0201dfa:	0141                	addi	sp,sp,16
ffffffffc0201dfc:	8082                	ret
ffffffffc0201dfe:	60a2                	ld	ra,8(sp)
ffffffffc0201e00:	e390                	sd	a2,0(a5)
ffffffffc0201e02:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201e04:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201e06:	ed1c                	sd	a5,24(a0)
ffffffffc0201e08:	0141                	addi	sp,sp,16
ffffffffc0201e0a:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201e0c:	00005697          	auipc	a3,0x5
ffffffffc0201e10:	cec68693          	addi	a3,a3,-788 # ffffffffc0206af8 <commands+0xea0>
ffffffffc0201e14:	00005617          	auipc	a2,0x5
ffffffffc0201e18:	95c60613          	addi	a2,a2,-1700 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201e1c:	04b00593          	li	a1,75
ffffffffc0201e20:	00005517          	auipc	a0,0x5
ffffffffc0201e24:	96850513          	addi	a0,a0,-1688 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201e28:	e66fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201e2c:	00005697          	auipc	a3,0x5
ffffffffc0201e30:	c9c68693          	addi	a3,a3,-868 # ffffffffc0206ac8 <commands+0xe70>
ffffffffc0201e34:	00005617          	auipc	a2,0x5
ffffffffc0201e38:	93c60613          	addi	a2,a2,-1732 # ffffffffc0206770 <commands+0xb18>
ffffffffc0201e3c:	04700593          	li	a1,71
ffffffffc0201e40:	00005517          	auipc	a0,0x5
ffffffffc0201e44:	94850513          	addi	a0,a0,-1720 # ffffffffc0206788 <commands+0xb30>
ffffffffc0201e48:	e46fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e4c <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201e4c:	c94d                	beqz	a0,ffffffffc0201efe <slob_free+0xb2>
{
ffffffffc0201e4e:	1141                	addi	sp,sp,-16
ffffffffc0201e50:	e022                	sd	s0,0(sp)
ffffffffc0201e52:	e406                	sd	ra,8(sp)
ffffffffc0201e54:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201e56:	e9c1                	bnez	a1,ffffffffc0201ee6 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e58:	100027f3          	csrr	a5,sstatus
ffffffffc0201e5c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201e5e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e60:	ebd9                	bnez	a5,ffffffffc0201ef6 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201e62:	000ba617          	auipc	a2,0xba
ffffffffc0201e66:	e4660613          	addi	a2,a2,-442 # ffffffffc02bbca8 <slobfree>
ffffffffc0201e6a:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201e6c:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201e6e:	679c                	ld	a5,8(a5)
ffffffffc0201e70:	02877a63          	bgeu	a4,s0,ffffffffc0201ea4 <slob_free+0x58>
ffffffffc0201e74:	00f46463          	bltu	s0,a5,ffffffffc0201e7c <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201e78:	fef76ae3          	bltu	a4,a5,ffffffffc0201e6c <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201e7c:	400c                	lw	a1,0(s0)
ffffffffc0201e7e:	00459693          	slli	a3,a1,0x4
ffffffffc0201e82:	96a2                	add	a3,a3,s0
ffffffffc0201e84:	02d78a63          	beq	a5,a3,ffffffffc0201eb8 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201e88:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201e8a:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201e8c:	00469793          	slli	a5,a3,0x4
ffffffffc0201e90:	97ba                	add	a5,a5,a4
ffffffffc0201e92:	02f40e63          	beq	s0,a5,ffffffffc0201ece <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201e96:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201e98:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201e9a:	e129                	bnez	a0,ffffffffc0201edc <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201e9c:	60a2                	ld	ra,8(sp)
ffffffffc0201e9e:	6402                	ld	s0,0(sp)
ffffffffc0201ea0:	0141                	addi	sp,sp,16
ffffffffc0201ea2:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ea4:	fcf764e3          	bltu	a4,a5,ffffffffc0201e6c <slob_free+0x20>
ffffffffc0201ea8:	fcf472e3          	bgeu	s0,a5,ffffffffc0201e6c <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201eac:	400c                	lw	a1,0(s0)
ffffffffc0201eae:	00459693          	slli	a3,a1,0x4
ffffffffc0201eb2:	96a2                	add	a3,a3,s0
ffffffffc0201eb4:	fcd79ae3          	bne	a5,a3,ffffffffc0201e88 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201eb8:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201eba:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201ebc:	9db5                	addw	a1,a1,a3
ffffffffc0201ebe:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201ec0:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201ec2:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201ec4:	00469793          	slli	a5,a3,0x4
ffffffffc0201ec8:	97ba                	add	a5,a5,a4
ffffffffc0201eca:	fcf416e3          	bne	s0,a5,ffffffffc0201e96 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201ece:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201ed0:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201ed2:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201ed4:	9ebd                	addw	a3,a3,a5
ffffffffc0201ed6:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201ed8:	e70c                	sd	a1,8(a4)
ffffffffc0201eda:	d169                	beqz	a0,ffffffffc0201e9c <slob_free+0x50>
}
ffffffffc0201edc:	6402                	ld	s0,0(sp)
ffffffffc0201ede:	60a2                	ld	ra,8(sp)
ffffffffc0201ee0:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201ee2:	acdfe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201ee6:	25bd                	addiw	a1,a1,15
ffffffffc0201ee8:	8191                	srli	a1,a1,0x4
ffffffffc0201eea:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201eec:	100027f3          	csrr	a5,sstatus
ffffffffc0201ef0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201ef2:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ef4:	d7bd                	beqz	a5,ffffffffc0201e62 <slob_free+0x16>
        intr_disable();
ffffffffc0201ef6:	abffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201efa:	4505                	li	a0,1
ffffffffc0201efc:	b79d                	j	ffffffffc0201e62 <slob_free+0x16>
ffffffffc0201efe:	8082                	ret

ffffffffc0201f00 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201f00:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201f02:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201f04:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201f08:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201f0a:	352000ef          	jal	ra,ffffffffc020225c <alloc_pages>
	if (!page)
ffffffffc0201f0e:	c91d                	beqz	a0,ffffffffc0201f44 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201f10:	000be697          	auipc	a3,0xbe
ffffffffc0201f14:	2186b683          	ld	a3,536(a3) # ffffffffc02c0128 <pages>
ffffffffc0201f18:	8d15                	sub	a0,a0,a3
ffffffffc0201f1a:	8519                	srai	a0,a0,0x6
ffffffffc0201f1c:	00006697          	auipc	a3,0x6
ffffffffc0201f20:	eb46b683          	ld	a3,-332(a3) # ffffffffc0207dd0 <nbase>
ffffffffc0201f24:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201f26:	00c51793          	slli	a5,a0,0xc
ffffffffc0201f2a:	83b1                	srli	a5,a5,0xc
ffffffffc0201f2c:	000be717          	auipc	a4,0xbe
ffffffffc0201f30:	1f473703          	ld	a4,500(a4) # ffffffffc02c0120 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201f34:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201f36:	00e7fa63          	bgeu	a5,a4,ffffffffc0201f4a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201f3a:	000be697          	auipc	a3,0xbe
ffffffffc0201f3e:	1fe6b683          	ld	a3,510(a3) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0201f42:	9536                	add	a0,a0,a3
}
ffffffffc0201f44:	60a2                	ld	ra,8(sp)
ffffffffc0201f46:	0141                	addi	sp,sp,16
ffffffffc0201f48:	8082                	ret
ffffffffc0201f4a:	86aa                	mv	a3,a0
ffffffffc0201f4c:	00004617          	auipc	a2,0x4
ffffffffc0201f50:	72c60613          	addi	a2,a2,1836 # ffffffffc0206678 <commands+0xa20>
ffffffffc0201f54:	07100593          	li	a1,113
ffffffffc0201f58:	00004517          	auipc	a0,0x4
ffffffffc0201f5c:	56850513          	addi	a0,a0,1384 # ffffffffc02064c0 <commands+0x868>
ffffffffc0201f60:	d2efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201f64 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201f64:	1101                	addi	sp,sp,-32
ffffffffc0201f66:	ec06                	sd	ra,24(sp)
ffffffffc0201f68:	e822                	sd	s0,16(sp)
ffffffffc0201f6a:	e426                	sd	s1,8(sp)
ffffffffc0201f6c:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201f6e:	01050713          	addi	a4,a0,16
ffffffffc0201f72:	6785                	lui	a5,0x1
ffffffffc0201f74:	0cf77363          	bgeu	a4,a5,ffffffffc020203a <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201f78:	00f50493          	addi	s1,a0,15
ffffffffc0201f7c:	8091                	srli	s1,s1,0x4
ffffffffc0201f7e:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f80:	10002673          	csrr	a2,sstatus
ffffffffc0201f84:	8a09                	andi	a2,a2,2
ffffffffc0201f86:	e25d                	bnez	a2,ffffffffc020202c <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201f88:	000ba917          	auipc	s2,0xba
ffffffffc0201f8c:	d2090913          	addi	s2,s2,-736 # ffffffffc02bbca8 <slobfree>
ffffffffc0201f90:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201f94:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201f96:	4398                	lw	a4,0(a5)
ffffffffc0201f98:	08975e63          	bge	a4,s1,ffffffffc0202034 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201f9c:	00f68b63          	beq	a3,a5,ffffffffc0201fb2 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201fa0:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201fa2:	4018                	lw	a4,0(s0)
ffffffffc0201fa4:	02975a63          	bge	a4,s1,ffffffffc0201fd8 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201fa8:	00093683          	ld	a3,0(s2)
ffffffffc0201fac:	87a2                	mv	a5,s0
ffffffffc0201fae:	fef699e3          	bne	a3,a5,ffffffffc0201fa0 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201fb2:	ee31                	bnez	a2,ffffffffc020200e <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201fb4:	4501                	li	a0,0
ffffffffc0201fb6:	f4bff0ef          	jal	ra,ffffffffc0201f00 <__slob_get_free_pages.constprop.0>
ffffffffc0201fba:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201fbc:	cd05                	beqz	a0,ffffffffc0201ff4 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201fbe:	6585                	lui	a1,0x1
ffffffffc0201fc0:	e8dff0ef          	jal	ra,ffffffffc0201e4c <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fc4:	10002673          	csrr	a2,sstatus
ffffffffc0201fc8:	8a09                	andi	a2,a2,2
ffffffffc0201fca:	ee05                	bnez	a2,ffffffffc0202002 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201fcc:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201fd0:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201fd2:	4018                	lw	a4,0(s0)
ffffffffc0201fd4:	fc974ae3          	blt	a4,s1,ffffffffc0201fa8 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201fd8:	04e48763          	beq	s1,a4,ffffffffc0202026 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201fdc:	00449693          	slli	a3,s1,0x4
ffffffffc0201fe0:	96a2                	add	a3,a3,s0
ffffffffc0201fe2:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201fe4:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201fe6:	9f05                	subw	a4,a4,s1
ffffffffc0201fe8:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201fea:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201fec:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201fee:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201ff2:	e20d                	bnez	a2,ffffffffc0202014 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201ff4:	60e2                	ld	ra,24(sp)
ffffffffc0201ff6:	8522                	mv	a0,s0
ffffffffc0201ff8:	6442                	ld	s0,16(sp)
ffffffffc0201ffa:	64a2                	ld	s1,8(sp)
ffffffffc0201ffc:	6902                	ld	s2,0(sp)
ffffffffc0201ffe:	6105                	addi	sp,sp,32
ffffffffc0202000:	8082                	ret
        intr_disable();
ffffffffc0202002:	9b3fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0202006:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc020200a:	4605                	li	a2,1
ffffffffc020200c:	b7d1                	j	ffffffffc0201fd0 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc020200e:	9a1fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202012:	b74d                	j	ffffffffc0201fb4 <slob_alloc.constprop.0+0x50>
ffffffffc0202014:	99bfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0202018:	60e2                	ld	ra,24(sp)
ffffffffc020201a:	8522                	mv	a0,s0
ffffffffc020201c:	6442                	ld	s0,16(sp)
ffffffffc020201e:	64a2                	ld	s1,8(sp)
ffffffffc0202020:	6902                	ld	s2,0(sp)
ffffffffc0202022:	6105                	addi	sp,sp,32
ffffffffc0202024:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0202026:	6418                	ld	a4,8(s0)
ffffffffc0202028:	e798                	sd	a4,8(a5)
ffffffffc020202a:	b7d1                	j	ffffffffc0201fee <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc020202c:	989fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0202030:	4605                	li	a2,1
ffffffffc0202032:	bf99                	j	ffffffffc0201f88 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0202034:	843e                	mv	s0,a5
ffffffffc0202036:	87b6                	mv	a5,a3
ffffffffc0202038:	b745                	j	ffffffffc0201fd8 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc020203a:	00005697          	auipc	a3,0x5
ffffffffc020203e:	b1e68693          	addi	a3,a3,-1250 # ffffffffc0206b58 <default_pmm_manager+0x38>
ffffffffc0202042:	00004617          	auipc	a2,0x4
ffffffffc0202046:	72e60613          	addi	a2,a2,1838 # ffffffffc0206770 <commands+0xb18>
ffffffffc020204a:	06300593          	li	a1,99
ffffffffc020204e:	00005517          	auipc	a0,0x5
ffffffffc0202052:	b2a50513          	addi	a0,a0,-1238 # ffffffffc0206b78 <default_pmm_manager+0x58>
ffffffffc0202056:	c38fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020205a <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc020205a:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc020205c:	00005517          	auipc	a0,0x5
ffffffffc0202060:	b3450513          	addi	a0,a0,-1228 # ffffffffc0206b90 <default_pmm_manager+0x70>
{
ffffffffc0202064:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0202066:	92efe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc020206a:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc020206c:	00005517          	auipc	a0,0x5
ffffffffc0202070:	b3c50513          	addi	a0,a0,-1220 # ffffffffc0206ba8 <default_pmm_manager+0x88>
}
ffffffffc0202074:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0202076:	91efe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc020207a <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc020207a:	4501                	li	a0,0
ffffffffc020207c:	8082                	ret

ffffffffc020207e <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc020207e:	1101                	addi	sp,sp,-32
ffffffffc0202080:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0202082:	6905                	lui	s2,0x1
{
ffffffffc0202084:	e822                	sd	s0,16(sp)
ffffffffc0202086:	ec06                	sd	ra,24(sp)
ffffffffc0202088:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc020208a:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bc1>
{
ffffffffc020208e:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0202090:	04a7f963          	bgeu	a5,a0,ffffffffc02020e2 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0202094:	4561                	li	a0,24
ffffffffc0202096:	ecfff0ef          	jal	ra,ffffffffc0201f64 <slob_alloc.constprop.0>
ffffffffc020209a:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc020209c:	c929                	beqz	a0,ffffffffc02020ee <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc020209e:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc02020a2:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc02020a4:	00f95763          	bge	s2,a5,ffffffffc02020b2 <kmalloc+0x34>
ffffffffc02020a8:	6705                	lui	a4,0x1
ffffffffc02020aa:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc02020ac:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc02020ae:	fef74ee3          	blt	a4,a5,ffffffffc02020aa <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc02020b2:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc02020b4:	e4dff0ef          	jal	ra,ffffffffc0201f00 <__slob_get_free_pages.constprop.0>
ffffffffc02020b8:	e488                	sd	a0,8(s1)
ffffffffc02020ba:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc02020bc:	c525                	beqz	a0,ffffffffc0202124 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02020be:	100027f3          	csrr	a5,sstatus
ffffffffc02020c2:	8b89                	andi	a5,a5,2
ffffffffc02020c4:	ef8d                	bnez	a5,ffffffffc02020fe <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc02020c6:	000be797          	auipc	a5,0xbe
ffffffffc02020ca:	04278793          	addi	a5,a5,66 # ffffffffc02c0108 <bigblocks>
ffffffffc02020ce:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02020d0:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02020d2:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc02020d4:	60e2                	ld	ra,24(sp)
ffffffffc02020d6:	8522                	mv	a0,s0
ffffffffc02020d8:	6442                	ld	s0,16(sp)
ffffffffc02020da:	64a2                	ld	s1,8(sp)
ffffffffc02020dc:	6902                	ld	s2,0(sp)
ffffffffc02020de:	6105                	addi	sp,sp,32
ffffffffc02020e0:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc02020e2:	0541                	addi	a0,a0,16
ffffffffc02020e4:	e81ff0ef          	jal	ra,ffffffffc0201f64 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc02020e8:	01050413          	addi	s0,a0,16
ffffffffc02020ec:	f565                	bnez	a0,ffffffffc02020d4 <kmalloc+0x56>
ffffffffc02020ee:	4401                	li	s0,0
}
ffffffffc02020f0:	60e2                	ld	ra,24(sp)
ffffffffc02020f2:	8522                	mv	a0,s0
ffffffffc02020f4:	6442                	ld	s0,16(sp)
ffffffffc02020f6:	64a2                	ld	s1,8(sp)
ffffffffc02020f8:	6902                	ld	s2,0(sp)
ffffffffc02020fa:	6105                	addi	sp,sp,32
ffffffffc02020fc:	8082                	ret
        intr_disable();
ffffffffc02020fe:	8b7fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0202102:	000be797          	auipc	a5,0xbe
ffffffffc0202106:	00678793          	addi	a5,a5,6 # ffffffffc02c0108 <bigblocks>
ffffffffc020210a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc020210c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc020210e:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0202110:	89ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0202114:	6480                	ld	s0,8(s1)
}
ffffffffc0202116:	60e2                	ld	ra,24(sp)
ffffffffc0202118:	64a2                	ld	s1,8(sp)
ffffffffc020211a:	8522                	mv	a0,s0
ffffffffc020211c:	6442                	ld	s0,16(sp)
ffffffffc020211e:	6902                	ld	s2,0(sp)
ffffffffc0202120:	6105                	addi	sp,sp,32
ffffffffc0202122:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0202124:	45e1                	li	a1,24
ffffffffc0202126:	8526                	mv	a0,s1
ffffffffc0202128:	d25ff0ef          	jal	ra,ffffffffc0201e4c <slob_free>
	return __kmalloc(size, 0);
ffffffffc020212c:	b765                	j	ffffffffc02020d4 <kmalloc+0x56>

ffffffffc020212e <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc020212e:	c169                	beqz	a0,ffffffffc02021f0 <kfree+0xc2>
{
ffffffffc0202130:	1101                	addi	sp,sp,-32
ffffffffc0202132:	e822                	sd	s0,16(sp)
ffffffffc0202134:	ec06                	sd	ra,24(sp)
ffffffffc0202136:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0202138:	03451793          	slli	a5,a0,0x34
ffffffffc020213c:	842a                	mv	s0,a0
ffffffffc020213e:	e3d9                	bnez	a5,ffffffffc02021c4 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202140:	100027f3          	csrr	a5,sstatus
ffffffffc0202144:	8b89                	andi	a5,a5,2
ffffffffc0202146:	e7d9                	bnez	a5,ffffffffc02021d4 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0202148:	000be797          	auipc	a5,0xbe
ffffffffc020214c:	fc07b783          	ld	a5,-64(a5) # ffffffffc02c0108 <bigblocks>
    return 0;
ffffffffc0202150:	4601                	li	a2,0
ffffffffc0202152:	cbad                	beqz	a5,ffffffffc02021c4 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0202154:	000be697          	auipc	a3,0xbe
ffffffffc0202158:	fb468693          	addi	a3,a3,-76 # ffffffffc02c0108 <bigblocks>
ffffffffc020215c:	a021                	j	ffffffffc0202164 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc020215e:	01048693          	addi	a3,s1,16
ffffffffc0202162:	c3a5                	beqz	a5,ffffffffc02021c2 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0202164:	6798                	ld	a4,8(a5)
ffffffffc0202166:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0202168:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc020216a:	fe871ae3          	bne	a4,s0,ffffffffc020215e <kfree+0x30>
				*last = bb->next;
ffffffffc020216e:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0202170:	ee2d                	bnez	a2,ffffffffc02021ea <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0202172:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0202176:	4098                	lw	a4,0(s1)
ffffffffc0202178:	08f46963          	bltu	s0,a5,ffffffffc020220a <kfree+0xdc>
ffffffffc020217c:	000be697          	auipc	a3,0xbe
ffffffffc0202180:	fbc6b683          	ld	a3,-68(a3) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0202184:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0202186:	8031                	srli	s0,s0,0xc
ffffffffc0202188:	000be797          	auipc	a5,0xbe
ffffffffc020218c:	f987b783          	ld	a5,-104(a5) # ffffffffc02c0120 <npage>
ffffffffc0202190:	06f47163          	bgeu	s0,a5,ffffffffc02021f2 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0202194:	00006517          	auipc	a0,0x6
ffffffffc0202198:	c3c53503          	ld	a0,-964(a0) # ffffffffc0207dd0 <nbase>
ffffffffc020219c:	8c09                	sub	s0,s0,a0
ffffffffc020219e:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc02021a0:	000be517          	auipc	a0,0xbe
ffffffffc02021a4:	f8853503          	ld	a0,-120(a0) # ffffffffc02c0128 <pages>
ffffffffc02021a8:	4585                	li	a1,1
ffffffffc02021aa:	9522                	add	a0,a0,s0
ffffffffc02021ac:	00e595bb          	sllw	a1,a1,a4
ffffffffc02021b0:	0ea000ef          	jal	ra,ffffffffc020229a <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc02021b4:	6442                	ld	s0,16(sp)
ffffffffc02021b6:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02021b8:	8526                	mv	a0,s1
}
ffffffffc02021ba:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02021bc:	45e1                	li	a1,24
}
ffffffffc02021be:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02021c0:	b171                	j	ffffffffc0201e4c <slob_free>
ffffffffc02021c2:	e20d                	bnez	a2,ffffffffc02021e4 <kfree+0xb6>
ffffffffc02021c4:	ff040513          	addi	a0,s0,-16
}
ffffffffc02021c8:	6442                	ld	s0,16(sp)
ffffffffc02021ca:	60e2                	ld	ra,24(sp)
ffffffffc02021cc:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc02021ce:	4581                	li	a1,0
}
ffffffffc02021d0:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02021d2:	b9ad                	j	ffffffffc0201e4c <slob_free>
        intr_disable();
ffffffffc02021d4:	fe0fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc02021d8:	000be797          	auipc	a5,0xbe
ffffffffc02021dc:	f307b783          	ld	a5,-208(a5) # ffffffffc02c0108 <bigblocks>
        return 1;
ffffffffc02021e0:	4605                	li	a2,1
ffffffffc02021e2:	fbad                	bnez	a5,ffffffffc0202154 <kfree+0x26>
        intr_enable();
ffffffffc02021e4:	fcafe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02021e8:	bff1                	j	ffffffffc02021c4 <kfree+0x96>
ffffffffc02021ea:	fc4fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02021ee:	b751                	j	ffffffffc0202172 <kfree+0x44>
ffffffffc02021f0:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc02021f2:	00004617          	auipc	a2,0x4
ffffffffc02021f6:	2ae60613          	addi	a2,a2,686 # ffffffffc02064a0 <commands+0x848>
ffffffffc02021fa:	06900593          	li	a1,105
ffffffffc02021fe:	00004517          	auipc	a0,0x4
ffffffffc0202202:	2c250513          	addi	a0,a0,706 # ffffffffc02064c0 <commands+0x868>
ffffffffc0202206:	a88fe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc020220a:	86a2                	mv	a3,s0
ffffffffc020220c:	00005617          	auipc	a2,0x5
ffffffffc0202210:	9bc60613          	addi	a2,a2,-1604 # ffffffffc0206bc8 <default_pmm_manager+0xa8>
ffffffffc0202214:	07700593          	li	a1,119
ffffffffc0202218:	00004517          	auipc	a0,0x4
ffffffffc020221c:	2a850513          	addi	a0,a0,680 # ffffffffc02064c0 <commands+0x868>
ffffffffc0202220:	a6efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202224 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0202224:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0202226:	00004617          	auipc	a2,0x4
ffffffffc020222a:	27a60613          	addi	a2,a2,634 # ffffffffc02064a0 <commands+0x848>
ffffffffc020222e:	06900593          	li	a1,105
ffffffffc0202232:	00004517          	auipc	a0,0x4
ffffffffc0202236:	28e50513          	addi	a0,a0,654 # ffffffffc02064c0 <commands+0x868>
pa2page(uintptr_t pa)
ffffffffc020223a:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc020223c:	a52fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202240 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0202240:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0202242:	00005617          	auipc	a2,0x5
ffffffffc0202246:	9ae60613          	addi	a2,a2,-1618 # ffffffffc0206bf0 <default_pmm_manager+0xd0>
ffffffffc020224a:	07f00593          	li	a1,127
ffffffffc020224e:	00004517          	auipc	a0,0x4
ffffffffc0202252:	27250513          	addi	a0,a0,626 # ffffffffc02064c0 <commands+0x868>
pte2page(pte_t pte)
ffffffffc0202256:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202258:	a36fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020225c <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020225c:	100027f3          	csrr	a5,sstatus
ffffffffc0202260:	8b89                	andi	a5,a5,2
ffffffffc0202262:	e799                	bnez	a5,ffffffffc0202270 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0202264:	000be797          	auipc	a5,0xbe
ffffffffc0202268:	ecc7b783          	ld	a5,-308(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc020226c:	6f9c                	ld	a5,24(a5)
ffffffffc020226e:	8782                	jr	a5
{
ffffffffc0202270:	1141                	addi	sp,sp,-16
ffffffffc0202272:	e406                	sd	ra,8(sp)
ffffffffc0202274:	e022                	sd	s0,0(sp)
ffffffffc0202276:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0202278:	f3cfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020227c:	000be797          	auipc	a5,0xbe
ffffffffc0202280:	eb47b783          	ld	a5,-332(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc0202284:	6f9c                	ld	a5,24(a5)
ffffffffc0202286:	8522                	mv	a0,s0
ffffffffc0202288:	9782                	jalr	a5
ffffffffc020228a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020228c:	f22fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0202290:	60a2                	ld	ra,8(sp)
ffffffffc0202292:	8522                	mv	a0,s0
ffffffffc0202294:	6402                	ld	s0,0(sp)
ffffffffc0202296:	0141                	addi	sp,sp,16
ffffffffc0202298:	8082                	ret

ffffffffc020229a <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020229a:	100027f3          	csrr	a5,sstatus
ffffffffc020229e:	8b89                	andi	a5,a5,2
ffffffffc02022a0:	e799                	bnez	a5,ffffffffc02022ae <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02022a2:	000be797          	auipc	a5,0xbe
ffffffffc02022a6:	e8e7b783          	ld	a5,-370(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02022aa:	739c                	ld	a5,32(a5)
ffffffffc02022ac:	8782                	jr	a5
{
ffffffffc02022ae:	1101                	addi	sp,sp,-32
ffffffffc02022b0:	ec06                	sd	ra,24(sp)
ffffffffc02022b2:	e822                	sd	s0,16(sp)
ffffffffc02022b4:	e426                	sd	s1,8(sp)
ffffffffc02022b6:	842a                	mv	s0,a0
ffffffffc02022b8:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02022ba:	efafe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02022be:	000be797          	auipc	a5,0xbe
ffffffffc02022c2:	e727b783          	ld	a5,-398(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02022c6:	739c                	ld	a5,32(a5)
ffffffffc02022c8:	85a6                	mv	a1,s1
ffffffffc02022ca:	8522                	mv	a0,s0
ffffffffc02022cc:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02022ce:	6442                	ld	s0,16(sp)
ffffffffc02022d0:	60e2                	ld	ra,24(sp)
ffffffffc02022d2:	64a2                	ld	s1,8(sp)
ffffffffc02022d4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02022d6:	ed8fe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc02022da <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022da:	100027f3          	csrr	a5,sstatus
ffffffffc02022de:	8b89                	andi	a5,a5,2
ffffffffc02022e0:	e799                	bnez	a5,ffffffffc02022ee <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc02022e2:	000be797          	auipc	a5,0xbe
ffffffffc02022e6:	e4e7b783          	ld	a5,-434(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02022ea:	779c                	ld	a5,40(a5)
ffffffffc02022ec:	8782                	jr	a5
{
ffffffffc02022ee:	1141                	addi	sp,sp,-16
ffffffffc02022f0:	e406                	sd	ra,8(sp)
ffffffffc02022f2:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02022f4:	ec0fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02022f8:	000be797          	auipc	a5,0xbe
ffffffffc02022fc:	e387b783          	ld	a5,-456(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc0202300:	779c                	ld	a5,40(a5)
ffffffffc0202302:	9782                	jalr	a5
ffffffffc0202304:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202306:	ea8fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc020230a:	60a2                	ld	ra,8(sp)
ffffffffc020230c:	8522                	mv	a0,s0
ffffffffc020230e:	6402                	ld	s0,0(sp)
ffffffffc0202310:	0141                	addi	sp,sp,16
ffffffffc0202312:	8082                	ret

ffffffffc0202314 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202314:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202318:	1ff7f793          	andi	a5,a5,511
{
ffffffffc020231c:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020231e:	078e                	slli	a5,a5,0x3
{
ffffffffc0202320:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202322:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0202326:	6094                	ld	a3,0(s1)
{
ffffffffc0202328:	f04a                	sd	s2,32(sp)
ffffffffc020232a:	ec4e                	sd	s3,24(sp)
ffffffffc020232c:	e852                	sd	s4,16(sp)
ffffffffc020232e:	fc06                	sd	ra,56(sp)
ffffffffc0202330:	f822                	sd	s0,48(sp)
ffffffffc0202332:	e456                	sd	s5,8(sp)
ffffffffc0202334:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0202336:	0016f793          	andi	a5,a3,1
{
ffffffffc020233a:	892e                	mv	s2,a1
ffffffffc020233c:	8a32                	mv	s4,a2
ffffffffc020233e:	000be997          	auipc	s3,0xbe
ffffffffc0202342:	de298993          	addi	s3,s3,-542 # ffffffffc02c0120 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0202346:	efbd                	bnez	a5,ffffffffc02023c4 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202348:	14060c63          	beqz	a2,ffffffffc02024a0 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020234c:	100027f3          	csrr	a5,sstatus
ffffffffc0202350:	8b89                	andi	a5,a5,2
ffffffffc0202352:	14079963          	bnez	a5,ffffffffc02024a4 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202356:	000be797          	auipc	a5,0xbe
ffffffffc020235a:	dda7b783          	ld	a5,-550(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc020235e:	6f9c                	ld	a5,24(a5)
ffffffffc0202360:	4505                	li	a0,1
ffffffffc0202362:	9782                	jalr	a5
ffffffffc0202364:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202366:	12040d63          	beqz	s0,ffffffffc02024a0 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc020236a:	000beb17          	auipc	s6,0xbe
ffffffffc020236e:	dbeb0b13          	addi	s6,s6,-578 # ffffffffc02c0128 <pages>
ffffffffc0202372:	000b3503          	ld	a0,0(s6)
ffffffffc0202376:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020237a:	000be997          	auipc	s3,0xbe
ffffffffc020237e:	da698993          	addi	s3,s3,-602 # ffffffffc02c0120 <npage>
ffffffffc0202382:	40a40533          	sub	a0,s0,a0
ffffffffc0202386:	8519                	srai	a0,a0,0x6
ffffffffc0202388:	9556                	add	a0,a0,s5
ffffffffc020238a:	0009b703          	ld	a4,0(s3)
ffffffffc020238e:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202392:	4685                	li	a3,1
ffffffffc0202394:	c014                	sw	a3,0(s0)
ffffffffc0202396:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202398:	0532                	slli	a0,a0,0xc
ffffffffc020239a:	16e7f763          	bgeu	a5,a4,ffffffffc0202508 <get_pte+0x1f4>
ffffffffc020239e:	000be797          	auipc	a5,0xbe
ffffffffc02023a2:	d9a7b783          	ld	a5,-614(a5) # ffffffffc02c0138 <va_pa_offset>
ffffffffc02023a6:	6605                	lui	a2,0x1
ffffffffc02023a8:	4581                	li	a1,0
ffffffffc02023aa:	953e                	add	a0,a0,a5
ffffffffc02023ac:	614030ef          	jal	ra,ffffffffc02059c0 <memset>
    return page - pages + nbase;
ffffffffc02023b0:	000b3683          	ld	a3,0(s6)
ffffffffc02023b4:	40d406b3          	sub	a3,s0,a3
ffffffffc02023b8:	8699                	srai	a3,a3,0x6
ffffffffc02023ba:	96d6                	add	a3,a3,s5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02023bc:	06aa                	slli	a3,a3,0xa
ffffffffc02023be:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02023c2:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02023c4:	77fd                	lui	a5,0xfffff
ffffffffc02023c6:	068a                	slli	a3,a3,0x2
ffffffffc02023c8:	0009b703          	ld	a4,0(s3)
ffffffffc02023cc:	8efd                	and	a3,a3,a5
ffffffffc02023ce:	00c6d793          	srli	a5,a3,0xc
ffffffffc02023d2:	10e7ff63          	bgeu	a5,a4,ffffffffc02024f0 <get_pte+0x1dc>
ffffffffc02023d6:	000bea97          	auipc	s5,0xbe
ffffffffc02023da:	d62a8a93          	addi	s5,s5,-670 # ffffffffc02c0138 <va_pa_offset>
ffffffffc02023de:	000ab403          	ld	s0,0(s5)
ffffffffc02023e2:	01595793          	srli	a5,s2,0x15
ffffffffc02023e6:	1ff7f793          	andi	a5,a5,511
ffffffffc02023ea:	96a2                	add	a3,a3,s0
ffffffffc02023ec:	00379413          	slli	s0,a5,0x3
ffffffffc02023f0:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc02023f2:	6014                	ld	a3,0(s0)
ffffffffc02023f4:	0016f793          	andi	a5,a3,1
ffffffffc02023f8:	ebad                	bnez	a5,ffffffffc020246a <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02023fa:	0a0a0363          	beqz	s4,ffffffffc02024a0 <get_pte+0x18c>
ffffffffc02023fe:	100027f3          	csrr	a5,sstatus
ffffffffc0202402:	8b89                	andi	a5,a5,2
ffffffffc0202404:	efcd                	bnez	a5,ffffffffc02024be <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202406:	000be797          	auipc	a5,0xbe
ffffffffc020240a:	d2a7b783          	ld	a5,-726(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc020240e:	6f9c                	ld	a5,24(a5)
ffffffffc0202410:	4505                	li	a0,1
ffffffffc0202412:	9782                	jalr	a5
ffffffffc0202414:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202416:	c4c9                	beqz	s1,ffffffffc02024a0 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202418:	000beb17          	auipc	s6,0xbe
ffffffffc020241c:	d10b0b13          	addi	s6,s6,-752 # ffffffffc02c0128 <pages>
ffffffffc0202420:	000b3503          	ld	a0,0(s6)
ffffffffc0202424:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202428:	0009b703          	ld	a4,0(s3)
ffffffffc020242c:	40a48533          	sub	a0,s1,a0
ffffffffc0202430:	8519                	srai	a0,a0,0x6
ffffffffc0202432:	9552                	add	a0,a0,s4
ffffffffc0202434:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202438:	4685                	li	a3,1
ffffffffc020243a:	c094                	sw	a3,0(s1)
ffffffffc020243c:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020243e:	0532                	slli	a0,a0,0xc
ffffffffc0202440:	0ee7f163          	bgeu	a5,a4,ffffffffc0202522 <get_pte+0x20e>
ffffffffc0202444:	000ab783          	ld	a5,0(s5)
ffffffffc0202448:	6605                	lui	a2,0x1
ffffffffc020244a:	4581                	li	a1,0
ffffffffc020244c:	953e                	add	a0,a0,a5
ffffffffc020244e:	572030ef          	jal	ra,ffffffffc02059c0 <memset>
    return page - pages + nbase;
ffffffffc0202452:	000b3683          	ld	a3,0(s6)
ffffffffc0202456:	40d486b3          	sub	a3,s1,a3
ffffffffc020245a:	8699                	srai	a3,a3,0x6
ffffffffc020245c:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020245e:	06aa                	slli	a3,a3,0xa
ffffffffc0202460:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202464:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202466:	0009b703          	ld	a4,0(s3)
ffffffffc020246a:	068a                	slli	a3,a3,0x2
ffffffffc020246c:	757d                	lui	a0,0xfffff
ffffffffc020246e:	8ee9                	and	a3,a3,a0
ffffffffc0202470:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202474:	06e7f263          	bgeu	a5,a4,ffffffffc02024d8 <get_pte+0x1c4>
ffffffffc0202478:	000ab503          	ld	a0,0(s5)
ffffffffc020247c:	00c95913          	srli	s2,s2,0xc
ffffffffc0202480:	1ff97913          	andi	s2,s2,511
ffffffffc0202484:	96aa                	add	a3,a3,a0
ffffffffc0202486:	00391513          	slli	a0,s2,0x3
ffffffffc020248a:	9536                	add	a0,a0,a3
}
ffffffffc020248c:	70e2                	ld	ra,56(sp)
ffffffffc020248e:	7442                	ld	s0,48(sp)
ffffffffc0202490:	74a2                	ld	s1,40(sp)
ffffffffc0202492:	7902                	ld	s2,32(sp)
ffffffffc0202494:	69e2                	ld	s3,24(sp)
ffffffffc0202496:	6a42                	ld	s4,16(sp)
ffffffffc0202498:	6aa2                	ld	s5,8(sp)
ffffffffc020249a:	6b02                	ld	s6,0(sp)
ffffffffc020249c:	6121                	addi	sp,sp,64
ffffffffc020249e:	8082                	ret
            return NULL;
ffffffffc02024a0:	4501                	li	a0,0
ffffffffc02024a2:	b7ed                	j	ffffffffc020248c <get_pte+0x178>
        intr_disable();
ffffffffc02024a4:	d10fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02024a8:	000be797          	auipc	a5,0xbe
ffffffffc02024ac:	c887b783          	ld	a5,-888(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02024b0:	6f9c                	ld	a5,24(a5)
ffffffffc02024b2:	4505                	li	a0,1
ffffffffc02024b4:	9782                	jalr	a5
ffffffffc02024b6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02024b8:	cf6fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02024bc:	b56d                	j	ffffffffc0202366 <get_pte+0x52>
        intr_disable();
ffffffffc02024be:	cf6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02024c2:	000be797          	auipc	a5,0xbe
ffffffffc02024c6:	c6e7b783          	ld	a5,-914(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02024ca:	6f9c                	ld	a5,24(a5)
ffffffffc02024cc:	4505                	li	a0,1
ffffffffc02024ce:	9782                	jalr	a5
ffffffffc02024d0:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02024d2:	cdcfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02024d6:	b781                	j	ffffffffc0202416 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02024d8:	00004617          	auipc	a2,0x4
ffffffffc02024dc:	1a060613          	addi	a2,a2,416 # ffffffffc0206678 <commands+0xa20>
ffffffffc02024e0:	0fa00593          	li	a1,250
ffffffffc02024e4:	00004517          	auipc	a0,0x4
ffffffffc02024e8:	73450513          	addi	a0,a0,1844 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02024ec:	fa3fd0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02024f0:	00004617          	auipc	a2,0x4
ffffffffc02024f4:	18860613          	addi	a2,a2,392 # ffffffffc0206678 <commands+0xa20>
ffffffffc02024f8:	0ed00593          	li	a1,237
ffffffffc02024fc:	00004517          	auipc	a0,0x4
ffffffffc0202500:	71c50513          	addi	a0,a0,1820 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0202504:	f8bfd0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202508:	86aa                	mv	a3,a0
ffffffffc020250a:	00004617          	auipc	a2,0x4
ffffffffc020250e:	16e60613          	addi	a2,a2,366 # ffffffffc0206678 <commands+0xa20>
ffffffffc0202512:	0e900593          	li	a1,233
ffffffffc0202516:	00004517          	auipc	a0,0x4
ffffffffc020251a:	70250513          	addi	a0,a0,1794 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020251e:	f71fd0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202522:	86aa                	mv	a3,a0
ffffffffc0202524:	00004617          	auipc	a2,0x4
ffffffffc0202528:	15460613          	addi	a2,a2,340 # ffffffffc0206678 <commands+0xa20>
ffffffffc020252c:	0f700593          	li	a1,247
ffffffffc0202530:	00004517          	auipc	a0,0x4
ffffffffc0202534:	6e850513          	addi	a0,a0,1768 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0202538:	f57fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020253c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc020253c:	1141                	addi	sp,sp,-16
ffffffffc020253e:	e022                	sd	s0,0(sp)
ffffffffc0202540:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202542:	4601                	li	a2,0
{
ffffffffc0202544:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202546:	dcfff0ef          	jal	ra,ffffffffc0202314 <get_pte>
    if (ptep_store != NULL)
ffffffffc020254a:	c011                	beqz	s0,ffffffffc020254e <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc020254c:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020254e:	c511                	beqz	a0,ffffffffc020255a <get_page+0x1e>
ffffffffc0202550:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202552:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202554:	0017f713          	andi	a4,a5,1
ffffffffc0202558:	e709                	bnez	a4,ffffffffc0202562 <get_page+0x26>
}
ffffffffc020255a:	60a2                	ld	ra,8(sp)
ffffffffc020255c:	6402                	ld	s0,0(sp)
ffffffffc020255e:	0141                	addi	sp,sp,16
ffffffffc0202560:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202562:	078a                	slli	a5,a5,0x2
ffffffffc0202564:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202566:	000be717          	auipc	a4,0xbe
ffffffffc020256a:	bba73703          	ld	a4,-1094(a4) # ffffffffc02c0120 <npage>
ffffffffc020256e:	00e7ff63          	bgeu	a5,a4,ffffffffc020258c <get_page+0x50>
ffffffffc0202572:	60a2                	ld	ra,8(sp)
ffffffffc0202574:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0202576:	fff80537          	lui	a0,0xfff80
ffffffffc020257a:	97aa                	add	a5,a5,a0
ffffffffc020257c:	079a                	slli	a5,a5,0x6
ffffffffc020257e:	000be517          	auipc	a0,0xbe
ffffffffc0202582:	baa53503          	ld	a0,-1110(a0) # ffffffffc02c0128 <pages>
ffffffffc0202586:	953e                	add	a0,a0,a5
ffffffffc0202588:	0141                	addi	sp,sp,16
ffffffffc020258a:	8082                	ret
ffffffffc020258c:	c99ff0ef          	jal	ra,ffffffffc0202224 <pa2page.part.0>

ffffffffc0202590 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202590:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202592:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202596:	f486                	sd	ra,104(sp)
ffffffffc0202598:	f0a2                	sd	s0,96(sp)
ffffffffc020259a:	eca6                	sd	s1,88(sp)
ffffffffc020259c:	e8ca                	sd	s2,80(sp)
ffffffffc020259e:	e4ce                	sd	s3,72(sp)
ffffffffc02025a0:	e0d2                	sd	s4,64(sp)
ffffffffc02025a2:	fc56                	sd	s5,56(sp)
ffffffffc02025a4:	f85a                	sd	s6,48(sp)
ffffffffc02025a6:	f45e                	sd	s7,40(sp)
ffffffffc02025a8:	f062                	sd	s8,32(sp)
ffffffffc02025aa:	ec66                	sd	s9,24(sp)
ffffffffc02025ac:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02025ae:	17d2                	slli	a5,a5,0x34
ffffffffc02025b0:	e3ed                	bnez	a5,ffffffffc0202692 <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02025b2:	002007b7          	lui	a5,0x200
ffffffffc02025b6:	842e                	mv	s0,a1
ffffffffc02025b8:	0ef5ed63          	bltu	a1,a5,ffffffffc02026b2 <unmap_range+0x122>
ffffffffc02025bc:	8932                	mv	s2,a2
ffffffffc02025be:	0ec5fa63          	bgeu	a1,a2,ffffffffc02026b2 <unmap_range+0x122>
ffffffffc02025c2:	4785                	li	a5,1
ffffffffc02025c4:	07fe                	slli	a5,a5,0x1f
ffffffffc02025c6:	0ec7e663          	bltu	a5,a2,ffffffffc02026b2 <unmap_range+0x122>
ffffffffc02025ca:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02025cc:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02025ce:	000bec97          	auipc	s9,0xbe
ffffffffc02025d2:	b52c8c93          	addi	s9,s9,-1198 # ffffffffc02c0120 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02025d6:	000bec17          	auipc	s8,0xbe
ffffffffc02025da:	b52c0c13          	addi	s8,s8,-1198 # ffffffffc02c0128 <pages>
ffffffffc02025de:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc02025e2:	000bed17          	auipc	s10,0xbe
ffffffffc02025e6:	b4ed0d13          	addi	s10,s10,-1202 # ffffffffc02c0130 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02025ea:	00200b37          	lui	s6,0x200
ffffffffc02025ee:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02025f2:	4601                	li	a2,0
ffffffffc02025f4:	85a2                	mv	a1,s0
ffffffffc02025f6:	854e                	mv	a0,s3
ffffffffc02025f8:	d1dff0ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc02025fc:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02025fe:	cd29                	beqz	a0,ffffffffc0202658 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc0202600:	611c                	ld	a5,0(a0)
ffffffffc0202602:	e395                	bnez	a5,ffffffffc0202626 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202604:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202606:	ff2466e3          	bltu	s0,s2,ffffffffc02025f2 <unmap_range+0x62>
}
ffffffffc020260a:	70a6                	ld	ra,104(sp)
ffffffffc020260c:	7406                	ld	s0,96(sp)
ffffffffc020260e:	64e6                	ld	s1,88(sp)
ffffffffc0202610:	6946                	ld	s2,80(sp)
ffffffffc0202612:	69a6                	ld	s3,72(sp)
ffffffffc0202614:	6a06                	ld	s4,64(sp)
ffffffffc0202616:	7ae2                	ld	s5,56(sp)
ffffffffc0202618:	7b42                	ld	s6,48(sp)
ffffffffc020261a:	7ba2                	ld	s7,40(sp)
ffffffffc020261c:	7c02                	ld	s8,32(sp)
ffffffffc020261e:	6ce2                	ld	s9,24(sp)
ffffffffc0202620:	6d42                	ld	s10,16(sp)
ffffffffc0202622:	6165                	addi	sp,sp,112
ffffffffc0202624:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202626:	0017f713          	andi	a4,a5,1
ffffffffc020262a:	df69                	beqz	a4,ffffffffc0202604 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc020262c:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202630:	078a                	slli	a5,a5,0x2
ffffffffc0202632:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202634:	08e7ff63          	bgeu	a5,a4,ffffffffc02026d2 <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202638:	000c3503          	ld	a0,0(s8)
ffffffffc020263c:	97de                	add	a5,a5,s7
ffffffffc020263e:	079a                	slli	a5,a5,0x6
ffffffffc0202640:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202642:	411c                	lw	a5,0(a0)
ffffffffc0202644:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202648:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc020264a:	cf11                	beqz	a4,ffffffffc0202666 <unmap_range+0xd6>
        *ptep = 0;
ffffffffc020264c:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202650:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202654:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202656:	bf45                	j	ffffffffc0202606 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202658:	945a                	add	s0,s0,s6
ffffffffc020265a:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020265e:	d455                	beqz	s0,ffffffffc020260a <unmap_range+0x7a>
ffffffffc0202660:	f92469e3          	bltu	s0,s2,ffffffffc02025f2 <unmap_range+0x62>
ffffffffc0202664:	b75d                	j	ffffffffc020260a <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202666:	100027f3          	csrr	a5,sstatus
ffffffffc020266a:	8b89                	andi	a5,a5,2
ffffffffc020266c:	e799                	bnez	a5,ffffffffc020267a <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc020266e:	000d3783          	ld	a5,0(s10)
ffffffffc0202672:	4585                	li	a1,1
ffffffffc0202674:	739c                	ld	a5,32(a5)
ffffffffc0202676:	9782                	jalr	a5
    if (flag)
ffffffffc0202678:	bfd1                	j	ffffffffc020264c <unmap_range+0xbc>
ffffffffc020267a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020267c:	b38fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202680:	000d3783          	ld	a5,0(s10)
ffffffffc0202684:	6522                	ld	a0,8(sp)
ffffffffc0202686:	4585                	li	a1,1
ffffffffc0202688:	739c                	ld	a5,32(a5)
ffffffffc020268a:	9782                	jalr	a5
        intr_enable();
ffffffffc020268c:	b22fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202690:	bf75                	j	ffffffffc020264c <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202692:	00004697          	auipc	a3,0x4
ffffffffc0202696:	59668693          	addi	a3,a3,1430 # ffffffffc0206c28 <default_pmm_manager+0x108>
ffffffffc020269a:	00004617          	auipc	a2,0x4
ffffffffc020269e:	0d660613          	addi	a2,a2,214 # ffffffffc0206770 <commands+0xb18>
ffffffffc02026a2:	12000593          	li	a1,288
ffffffffc02026a6:	00004517          	auipc	a0,0x4
ffffffffc02026aa:	57250513          	addi	a0,a0,1394 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02026ae:	de1fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02026b2:	00004697          	auipc	a3,0x4
ffffffffc02026b6:	5a668693          	addi	a3,a3,1446 # ffffffffc0206c58 <default_pmm_manager+0x138>
ffffffffc02026ba:	00004617          	auipc	a2,0x4
ffffffffc02026be:	0b660613          	addi	a2,a2,182 # ffffffffc0206770 <commands+0xb18>
ffffffffc02026c2:	12100593          	li	a1,289
ffffffffc02026c6:	00004517          	auipc	a0,0x4
ffffffffc02026ca:	55250513          	addi	a0,a0,1362 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02026ce:	dc1fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02026d2:	b53ff0ef          	jal	ra,ffffffffc0202224 <pa2page.part.0>

ffffffffc02026d6 <exit_range>:
{
ffffffffc02026d6:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02026d8:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02026dc:	fc86                	sd	ra,120(sp)
ffffffffc02026de:	f8a2                	sd	s0,112(sp)
ffffffffc02026e0:	f4a6                	sd	s1,104(sp)
ffffffffc02026e2:	f0ca                	sd	s2,96(sp)
ffffffffc02026e4:	ecce                	sd	s3,88(sp)
ffffffffc02026e6:	e8d2                	sd	s4,80(sp)
ffffffffc02026e8:	e4d6                	sd	s5,72(sp)
ffffffffc02026ea:	e0da                	sd	s6,64(sp)
ffffffffc02026ec:	fc5e                	sd	s7,56(sp)
ffffffffc02026ee:	f862                	sd	s8,48(sp)
ffffffffc02026f0:	f466                	sd	s9,40(sp)
ffffffffc02026f2:	f06a                	sd	s10,32(sp)
ffffffffc02026f4:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02026f6:	17d2                	slli	a5,a5,0x34
ffffffffc02026f8:	20079a63          	bnez	a5,ffffffffc020290c <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc02026fc:	002007b7          	lui	a5,0x200
ffffffffc0202700:	24f5e463          	bltu	a1,a5,ffffffffc0202948 <exit_range+0x272>
ffffffffc0202704:	8ab2                	mv	s5,a2
ffffffffc0202706:	24c5f163          	bgeu	a1,a2,ffffffffc0202948 <exit_range+0x272>
ffffffffc020270a:	4785                	li	a5,1
ffffffffc020270c:	07fe                	slli	a5,a5,0x1f
ffffffffc020270e:	22c7ed63          	bltu	a5,a2,ffffffffc0202948 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202712:	c00009b7          	lui	s3,0xc0000
ffffffffc0202716:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020271a:	ffe00937          	lui	s2,0xffe00
ffffffffc020271e:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc0202722:	5cfd                	li	s9,-1
ffffffffc0202724:	8c2a                	mv	s8,a0
ffffffffc0202726:	0125f933          	and	s2,a1,s2
ffffffffc020272a:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc020272c:	000bed17          	auipc	s10,0xbe
ffffffffc0202730:	9f4d0d13          	addi	s10,s10,-1548 # ffffffffc02c0120 <npage>
    return KADDR(page2pa(page));
ffffffffc0202734:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202738:	000be717          	auipc	a4,0xbe
ffffffffc020273c:	9f070713          	addi	a4,a4,-1552 # ffffffffc02c0128 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202740:	000bed97          	auipc	s11,0xbe
ffffffffc0202744:	9f0d8d93          	addi	s11,s11,-1552 # ffffffffc02c0130 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202748:	c0000437          	lui	s0,0xc0000
ffffffffc020274c:	944e                	add	s0,s0,s3
ffffffffc020274e:	8079                	srli	s0,s0,0x1e
ffffffffc0202750:	1ff47413          	andi	s0,s0,511
ffffffffc0202754:	040e                	slli	s0,s0,0x3
ffffffffc0202756:	9462                	add	s0,s0,s8
ffffffffc0202758:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_dirtycow_test_out_size+0xffffffffbfff4de0>
        if (pde1 & PTE_V)
ffffffffc020275c:	001a7793          	andi	a5,s4,1
ffffffffc0202760:	eb99                	bnez	a5,ffffffffc0202776 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc0202762:	12098463          	beqz	s3,ffffffffc020288a <exit_range+0x1b4>
ffffffffc0202766:	400007b7          	lui	a5,0x40000
ffffffffc020276a:	97ce                	add	a5,a5,s3
ffffffffc020276c:	894e                	mv	s2,s3
ffffffffc020276e:	1159fe63          	bgeu	s3,s5,ffffffffc020288a <exit_range+0x1b4>
ffffffffc0202772:	89be                	mv	s3,a5
ffffffffc0202774:	bfd1                	j	ffffffffc0202748 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc0202776:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc020277a:	0a0a                	slli	s4,s4,0x2
ffffffffc020277c:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202780:	1cfa7263          	bgeu	s4,a5,ffffffffc0202944 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202784:	fff80637          	lui	a2,0xfff80
ffffffffc0202788:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc020278a:	000806b7          	lui	a3,0x80
ffffffffc020278e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202790:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202794:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202796:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202798:	18f5fa63          	bgeu	a1,a5,ffffffffc020292c <exit_range+0x256>
ffffffffc020279c:	000be817          	auipc	a6,0xbe
ffffffffc02027a0:	99c80813          	addi	a6,a6,-1636 # ffffffffc02c0138 <va_pa_offset>
ffffffffc02027a4:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02027a8:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02027aa:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02027ae:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02027b0:	00080337          	lui	t1,0x80
ffffffffc02027b4:	6885                	lui	a7,0x1
ffffffffc02027b6:	a819                	j	ffffffffc02027cc <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc02027b8:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc02027ba:	002007b7          	lui	a5,0x200
ffffffffc02027be:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02027c0:	08090c63          	beqz	s2,ffffffffc0202858 <exit_range+0x182>
ffffffffc02027c4:	09397a63          	bgeu	s2,s3,ffffffffc0202858 <exit_range+0x182>
ffffffffc02027c8:	0f597063          	bgeu	s2,s5,ffffffffc02028a8 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02027cc:	01595493          	srli	s1,s2,0x15
ffffffffc02027d0:	1ff4f493          	andi	s1,s1,511
ffffffffc02027d4:	048e                	slli	s1,s1,0x3
ffffffffc02027d6:	94da                	add	s1,s1,s6
ffffffffc02027d8:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc02027da:	0017f693          	andi	a3,a5,1
ffffffffc02027de:	dee9                	beqz	a3,ffffffffc02027b8 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc02027e0:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02027e4:	078a                	slli	a5,a5,0x2
ffffffffc02027e6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02027e8:	14b7fe63          	bgeu	a5,a1,ffffffffc0202944 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02027ec:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc02027ee:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc02027f2:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02027f6:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02027fa:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02027fc:	12bef863          	bgeu	t4,a1,ffffffffc020292c <exit_range+0x256>
ffffffffc0202800:	00083783          	ld	a5,0(a6)
ffffffffc0202804:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202806:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc020280a:	629c                	ld	a5,0(a3)
ffffffffc020280c:	8b85                	andi	a5,a5,1
ffffffffc020280e:	f7d5                	bnez	a5,ffffffffc02027ba <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202810:	06a1                	addi	a3,a3,8
ffffffffc0202812:	fed59ce3          	bne	a1,a3,ffffffffc020280a <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202816:	631c                	ld	a5,0(a4)
ffffffffc0202818:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020281a:	100027f3          	csrr	a5,sstatus
ffffffffc020281e:	8b89                	andi	a5,a5,2
ffffffffc0202820:	e7d9                	bnez	a5,ffffffffc02028ae <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc0202822:	000db783          	ld	a5,0(s11)
ffffffffc0202826:	4585                	li	a1,1
ffffffffc0202828:	e032                	sd	a2,0(sp)
ffffffffc020282a:	739c                	ld	a5,32(a5)
ffffffffc020282c:	9782                	jalr	a5
    if (flag)
ffffffffc020282e:	6602                	ld	a2,0(sp)
ffffffffc0202830:	000be817          	auipc	a6,0xbe
ffffffffc0202834:	90880813          	addi	a6,a6,-1784 # ffffffffc02c0138 <va_pa_offset>
ffffffffc0202838:	fff80e37          	lui	t3,0xfff80
ffffffffc020283c:	00080337          	lui	t1,0x80
ffffffffc0202840:	6885                	lui	a7,0x1
ffffffffc0202842:	000be717          	auipc	a4,0xbe
ffffffffc0202846:	8e670713          	addi	a4,a4,-1818 # ffffffffc02c0128 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020284a:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020284e:	002007b7          	lui	a5,0x200
ffffffffc0202852:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202854:	f60918e3          	bnez	s2,ffffffffc02027c4 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202858:	f00b85e3          	beqz	s7,ffffffffc0202762 <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc020285c:	000d3783          	ld	a5,0(s10)
ffffffffc0202860:	0efa7263          	bgeu	s4,a5,ffffffffc0202944 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202864:	6308                	ld	a0,0(a4)
ffffffffc0202866:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202868:	100027f3          	csrr	a5,sstatus
ffffffffc020286c:	8b89                	andi	a5,a5,2
ffffffffc020286e:	efad                	bnez	a5,ffffffffc02028e8 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0202870:	000db783          	ld	a5,0(s11)
ffffffffc0202874:	4585                	li	a1,1
ffffffffc0202876:	739c                	ld	a5,32(a5)
ffffffffc0202878:	9782                	jalr	a5
ffffffffc020287a:	000be717          	auipc	a4,0xbe
ffffffffc020287e:	8ae70713          	addi	a4,a4,-1874 # ffffffffc02c0128 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202882:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc0202886:	ee0990e3          	bnez	s3,ffffffffc0202766 <exit_range+0x90>
}
ffffffffc020288a:	70e6                	ld	ra,120(sp)
ffffffffc020288c:	7446                	ld	s0,112(sp)
ffffffffc020288e:	74a6                	ld	s1,104(sp)
ffffffffc0202890:	7906                	ld	s2,96(sp)
ffffffffc0202892:	69e6                	ld	s3,88(sp)
ffffffffc0202894:	6a46                	ld	s4,80(sp)
ffffffffc0202896:	6aa6                	ld	s5,72(sp)
ffffffffc0202898:	6b06                	ld	s6,64(sp)
ffffffffc020289a:	7be2                	ld	s7,56(sp)
ffffffffc020289c:	7c42                	ld	s8,48(sp)
ffffffffc020289e:	7ca2                	ld	s9,40(sp)
ffffffffc02028a0:	7d02                	ld	s10,32(sp)
ffffffffc02028a2:	6de2                	ld	s11,24(sp)
ffffffffc02028a4:	6109                	addi	sp,sp,128
ffffffffc02028a6:	8082                	ret
            if (free_pd0)
ffffffffc02028a8:	ea0b8fe3          	beqz	s7,ffffffffc0202766 <exit_range+0x90>
ffffffffc02028ac:	bf45                	j	ffffffffc020285c <exit_range+0x186>
ffffffffc02028ae:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02028b0:	e42a                	sd	a0,8(sp)
ffffffffc02028b2:	902fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02028b6:	000db783          	ld	a5,0(s11)
ffffffffc02028ba:	6522                	ld	a0,8(sp)
ffffffffc02028bc:	4585                	li	a1,1
ffffffffc02028be:	739c                	ld	a5,32(a5)
ffffffffc02028c0:	9782                	jalr	a5
        intr_enable();
ffffffffc02028c2:	8ecfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02028c6:	6602                	ld	a2,0(sp)
ffffffffc02028c8:	000be717          	auipc	a4,0xbe
ffffffffc02028cc:	86070713          	addi	a4,a4,-1952 # ffffffffc02c0128 <pages>
ffffffffc02028d0:	6885                	lui	a7,0x1
ffffffffc02028d2:	00080337          	lui	t1,0x80
ffffffffc02028d6:	fff80e37          	lui	t3,0xfff80
ffffffffc02028da:	000be817          	auipc	a6,0xbe
ffffffffc02028de:	85e80813          	addi	a6,a6,-1954 # ffffffffc02c0138 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02028e2:	0004b023          	sd	zero,0(s1)
ffffffffc02028e6:	b7a5                	j	ffffffffc020284e <exit_range+0x178>
ffffffffc02028e8:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc02028ea:	8cafe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02028ee:	000db783          	ld	a5,0(s11)
ffffffffc02028f2:	6502                	ld	a0,0(sp)
ffffffffc02028f4:	4585                	li	a1,1
ffffffffc02028f6:	739c                	ld	a5,32(a5)
ffffffffc02028f8:	9782                	jalr	a5
        intr_enable();
ffffffffc02028fa:	8b4fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02028fe:	000be717          	auipc	a4,0xbe
ffffffffc0202902:	82a70713          	addi	a4,a4,-2006 # ffffffffc02c0128 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202906:	00043023          	sd	zero,0(s0)
ffffffffc020290a:	bfb5                	j	ffffffffc0202886 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020290c:	00004697          	auipc	a3,0x4
ffffffffc0202910:	31c68693          	addi	a3,a3,796 # ffffffffc0206c28 <default_pmm_manager+0x108>
ffffffffc0202914:	00004617          	auipc	a2,0x4
ffffffffc0202918:	e5c60613          	addi	a2,a2,-420 # ffffffffc0206770 <commands+0xb18>
ffffffffc020291c:	13500593          	li	a1,309
ffffffffc0202920:	00004517          	auipc	a0,0x4
ffffffffc0202924:	2f850513          	addi	a0,a0,760 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0202928:	b67fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc020292c:	00004617          	auipc	a2,0x4
ffffffffc0202930:	d4c60613          	addi	a2,a2,-692 # ffffffffc0206678 <commands+0xa20>
ffffffffc0202934:	07100593          	li	a1,113
ffffffffc0202938:	00004517          	auipc	a0,0x4
ffffffffc020293c:	b8850513          	addi	a0,a0,-1144 # ffffffffc02064c0 <commands+0x868>
ffffffffc0202940:	b4ffd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202944:	8e1ff0ef          	jal	ra,ffffffffc0202224 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202948:	00004697          	auipc	a3,0x4
ffffffffc020294c:	31068693          	addi	a3,a3,784 # ffffffffc0206c58 <default_pmm_manager+0x138>
ffffffffc0202950:	00004617          	auipc	a2,0x4
ffffffffc0202954:	e2060613          	addi	a2,a2,-480 # ffffffffc0206770 <commands+0xb18>
ffffffffc0202958:	13600593          	li	a1,310
ffffffffc020295c:	00004517          	auipc	a0,0x4
ffffffffc0202960:	2bc50513          	addi	a0,a0,700 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0202964:	b2bfd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202968 <page_remove>:
{
ffffffffc0202968:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020296a:	4601                	li	a2,0
{
ffffffffc020296c:	ec26                	sd	s1,24(sp)
ffffffffc020296e:	f406                	sd	ra,40(sp)
ffffffffc0202970:	f022                	sd	s0,32(sp)
ffffffffc0202972:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202974:	9a1ff0ef          	jal	ra,ffffffffc0202314 <get_pte>
    if (ptep != NULL)
ffffffffc0202978:	c511                	beqz	a0,ffffffffc0202984 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc020297a:	611c                	ld	a5,0(a0)
ffffffffc020297c:	842a                	mv	s0,a0
ffffffffc020297e:	0017f713          	andi	a4,a5,1
ffffffffc0202982:	e711                	bnez	a4,ffffffffc020298e <page_remove+0x26>
}
ffffffffc0202984:	70a2                	ld	ra,40(sp)
ffffffffc0202986:	7402                	ld	s0,32(sp)
ffffffffc0202988:	64e2                	ld	s1,24(sp)
ffffffffc020298a:	6145                	addi	sp,sp,48
ffffffffc020298c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020298e:	078a                	slli	a5,a5,0x2
ffffffffc0202990:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202992:	000bd717          	auipc	a4,0xbd
ffffffffc0202996:	78e73703          	ld	a4,1934(a4) # ffffffffc02c0120 <npage>
ffffffffc020299a:	06e7f363          	bgeu	a5,a4,ffffffffc0202a00 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc020299e:	fff80537          	lui	a0,0xfff80
ffffffffc02029a2:	97aa                	add	a5,a5,a0
ffffffffc02029a4:	079a                	slli	a5,a5,0x6
ffffffffc02029a6:	000bd517          	auipc	a0,0xbd
ffffffffc02029aa:	78253503          	ld	a0,1922(a0) # ffffffffc02c0128 <pages>
ffffffffc02029ae:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02029b0:	411c                	lw	a5,0(a0)
ffffffffc02029b2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02029b6:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02029b8:	cb11                	beqz	a4,ffffffffc02029cc <page_remove+0x64>
        *ptep = 0;
ffffffffc02029ba:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02029be:	12048073          	sfence.vma	s1
}
ffffffffc02029c2:	70a2                	ld	ra,40(sp)
ffffffffc02029c4:	7402                	ld	s0,32(sp)
ffffffffc02029c6:	64e2                	ld	s1,24(sp)
ffffffffc02029c8:	6145                	addi	sp,sp,48
ffffffffc02029ca:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02029cc:	100027f3          	csrr	a5,sstatus
ffffffffc02029d0:	8b89                	andi	a5,a5,2
ffffffffc02029d2:	eb89                	bnez	a5,ffffffffc02029e4 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc02029d4:	000bd797          	auipc	a5,0xbd
ffffffffc02029d8:	75c7b783          	ld	a5,1884(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02029dc:	739c                	ld	a5,32(a5)
ffffffffc02029de:	4585                	li	a1,1
ffffffffc02029e0:	9782                	jalr	a5
    if (flag)
ffffffffc02029e2:	bfe1                	j	ffffffffc02029ba <page_remove+0x52>
        intr_disable();
ffffffffc02029e4:	e42a                	sd	a0,8(sp)
ffffffffc02029e6:	fcffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02029ea:	000bd797          	auipc	a5,0xbd
ffffffffc02029ee:	7467b783          	ld	a5,1862(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc02029f2:	739c                	ld	a5,32(a5)
ffffffffc02029f4:	6522                	ld	a0,8(sp)
ffffffffc02029f6:	4585                	li	a1,1
ffffffffc02029f8:	9782                	jalr	a5
        intr_enable();
ffffffffc02029fa:	fb5fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02029fe:	bf75                	j	ffffffffc02029ba <page_remove+0x52>
ffffffffc0202a00:	825ff0ef          	jal	ra,ffffffffc0202224 <pa2page.part.0>

ffffffffc0202a04 <page_insert>:
{
ffffffffc0202a04:	7139                	addi	sp,sp,-64
ffffffffc0202a06:	e852                	sd	s4,16(sp)
ffffffffc0202a08:	8a32                	mv	s4,a2
ffffffffc0202a0a:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202a0c:	4605                	li	a2,1
{
ffffffffc0202a0e:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202a10:	85d2                	mv	a1,s4
{
ffffffffc0202a12:	f426                	sd	s1,40(sp)
ffffffffc0202a14:	fc06                	sd	ra,56(sp)
ffffffffc0202a16:	f04a                	sd	s2,32(sp)
ffffffffc0202a18:	ec4e                	sd	s3,24(sp)
ffffffffc0202a1a:	e456                	sd	s5,8(sp)
ffffffffc0202a1c:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202a1e:	8f7ff0ef          	jal	ra,ffffffffc0202314 <get_pte>
    if (ptep == NULL)
ffffffffc0202a22:	c961                	beqz	a0,ffffffffc0202af2 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202a24:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202a26:	611c                	ld	a5,0(a0)
ffffffffc0202a28:	89aa                	mv	s3,a0
ffffffffc0202a2a:	0016871b          	addiw	a4,a3,1
ffffffffc0202a2e:	c018                	sw	a4,0(s0)
ffffffffc0202a30:	0017f713          	andi	a4,a5,1
ffffffffc0202a34:	ef05                	bnez	a4,ffffffffc0202a6c <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202a36:	000bd717          	auipc	a4,0xbd
ffffffffc0202a3a:	6f273703          	ld	a4,1778(a4) # ffffffffc02c0128 <pages>
ffffffffc0202a3e:	8c19                	sub	s0,s0,a4
ffffffffc0202a40:	000807b7          	lui	a5,0x80
ffffffffc0202a44:	8419                	srai	s0,s0,0x6
ffffffffc0202a46:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202a48:	042a                	slli	s0,s0,0xa
ffffffffc0202a4a:	8cc1                	or	s1,s1,s0
ffffffffc0202a4c:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202a50:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_dirtycow_test_out_size+0xffffffffbfff4de0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202a54:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202a58:	4501                	li	a0,0
}
ffffffffc0202a5a:	70e2                	ld	ra,56(sp)
ffffffffc0202a5c:	7442                	ld	s0,48(sp)
ffffffffc0202a5e:	74a2                	ld	s1,40(sp)
ffffffffc0202a60:	7902                	ld	s2,32(sp)
ffffffffc0202a62:	69e2                	ld	s3,24(sp)
ffffffffc0202a64:	6a42                	ld	s4,16(sp)
ffffffffc0202a66:	6aa2                	ld	s5,8(sp)
ffffffffc0202a68:	6121                	addi	sp,sp,64
ffffffffc0202a6a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a6c:	078a                	slli	a5,a5,0x2
ffffffffc0202a6e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a70:	000bd717          	auipc	a4,0xbd
ffffffffc0202a74:	6b073703          	ld	a4,1712(a4) # ffffffffc02c0120 <npage>
ffffffffc0202a78:	06e7ff63          	bgeu	a5,a4,ffffffffc0202af6 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a7c:	000bda97          	auipc	s5,0xbd
ffffffffc0202a80:	6aca8a93          	addi	s5,s5,1708 # ffffffffc02c0128 <pages>
ffffffffc0202a84:	000ab703          	ld	a4,0(s5)
ffffffffc0202a88:	fff80937          	lui	s2,0xfff80
ffffffffc0202a8c:	993e                	add	s2,s2,a5
ffffffffc0202a8e:	091a                	slli	s2,s2,0x6
ffffffffc0202a90:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc0202a92:	01240c63          	beq	s0,s2,ffffffffc0202aaa <page_insert+0xa6>
    page->ref -= 1;
ffffffffc0202a96:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcbfea4>
ffffffffc0202a9a:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202a9e:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc0202aa2:	c691                	beqz	a3,ffffffffc0202aae <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202aa4:	120a0073          	sfence.vma	s4
}
ffffffffc0202aa8:	bf59                	j	ffffffffc0202a3e <page_insert+0x3a>
ffffffffc0202aaa:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202aac:	bf49                	j	ffffffffc0202a3e <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202aae:	100027f3          	csrr	a5,sstatus
ffffffffc0202ab2:	8b89                	andi	a5,a5,2
ffffffffc0202ab4:	ef91                	bnez	a5,ffffffffc0202ad0 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202ab6:	000bd797          	auipc	a5,0xbd
ffffffffc0202aba:	67a7b783          	ld	a5,1658(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc0202abe:	739c                	ld	a5,32(a5)
ffffffffc0202ac0:	4585                	li	a1,1
ffffffffc0202ac2:	854a                	mv	a0,s2
ffffffffc0202ac4:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202ac6:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202aca:	120a0073          	sfence.vma	s4
ffffffffc0202ace:	bf85                	j	ffffffffc0202a3e <page_insert+0x3a>
        intr_disable();
ffffffffc0202ad0:	ee5fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202ad4:	000bd797          	auipc	a5,0xbd
ffffffffc0202ad8:	65c7b783          	ld	a5,1628(a5) # ffffffffc02c0130 <pmm_manager>
ffffffffc0202adc:	739c                	ld	a5,32(a5)
ffffffffc0202ade:	4585                	li	a1,1
ffffffffc0202ae0:	854a                	mv	a0,s2
ffffffffc0202ae2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ae4:	ecbfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202ae8:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202aec:	120a0073          	sfence.vma	s4
ffffffffc0202af0:	b7b9                	j	ffffffffc0202a3e <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202af2:	5571                	li	a0,-4
ffffffffc0202af4:	b79d                	j	ffffffffc0202a5a <page_insert+0x56>
ffffffffc0202af6:	f2eff0ef          	jal	ra,ffffffffc0202224 <pa2page.part.0>

ffffffffc0202afa <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202afa:	00004797          	auipc	a5,0x4
ffffffffc0202afe:	02678793          	addi	a5,a5,38 # ffffffffc0206b20 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202b02:	638c                	ld	a1,0(a5)
{
ffffffffc0202b04:	7159                	addi	sp,sp,-112
ffffffffc0202b06:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202b08:	00004517          	auipc	a0,0x4
ffffffffc0202b0c:	16850513          	addi	a0,a0,360 # ffffffffc0206c70 <default_pmm_manager+0x150>
    pmm_manager = &default_pmm_manager;
ffffffffc0202b10:	000bdb17          	auipc	s6,0xbd
ffffffffc0202b14:	620b0b13          	addi	s6,s6,1568 # ffffffffc02c0130 <pmm_manager>
{
ffffffffc0202b18:	f486                	sd	ra,104(sp)
ffffffffc0202b1a:	e8ca                	sd	s2,80(sp)
ffffffffc0202b1c:	e4ce                	sd	s3,72(sp)
ffffffffc0202b1e:	f0a2                	sd	s0,96(sp)
ffffffffc0202b20:	eca6                	sd	s1,88(sp)
ffffffffc0202b22:	e0d2                	sd	s4,64(sp)
ffffffffc0202b24:	fc56                	sd	s5,56(sp)
ffffffffc0202b26:	f45e                	sd	s7,40(sp)
ffffffffc0202b28:	f062                	sd	s8,32(sp)
ffffffffc0202b2a:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202b2c:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202b30:	e64fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202b34:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202b38:	000bd997          	auipc	s3,0xbd
ffffffffc0202b3c:	60098993          	addi	s3,s3,1536 # ffffffffc02c0138 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202b40:	679c                	ld	a5,8(a5)
ffffffffc0202b42:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202b44:	57f5                	li	a5,-3
ffffffffc0202b46:	07fa                	slli	a5,a5,0x1e
ffffffffc0202b48:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202b4c:	e4ffd0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc0202b50:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc0202b52:	e53fd0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202b56:	200505e3          	beqz	a0,ffffffffc0203560 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202b5a:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202b5c:	00004517          	auipc	a0,0x4
ffffffffc0202b60:	14c50513          	addi	a0,a0,332 # ffffffffc0206ca8 <default_pmm_manager+0x188>
ffffffffc0202b64:	e30fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202b68:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202b6c:	fff40693          	addi	a3,s0,-1
ffffffffc0202b70:	864a                	mv	a2,s2
ffffffffc0202b72:	85a6                	mv	a1,s1
ffffffffc0202b74:	00004517          	auipc	a0,0x4
ffffffffc0202b78:	14c50513          	addi	a0,a0,332 # ffffffffc0206cc0 <default_pmm_manager+0x1a0>
ffffffffc0202b7c:	e18fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202b80:	c8000737          	lui	a4,0xc8000
ffffffffc0202b84:	87a2                	mv	a5,s0
ffffffffc0202b86:	54876163          	bltu	a4,s0,ffffffffc02030c8 <pmm_init+0x5ce>
ffffffffc0202b8a:	757d                	lui	a0,0xfffff
ffffffffc0202b8c:	000be617          	auipc	a2,0xbe
ffffffffc0202b90:	5cf60613          	addi	a2,a2,1487 # ffffffffc02c115b <end+0xfff>
ffffffffc0202b94:	8e69                	and	a2,a2,a0
ffffffffc0202b96:	000bd497          	auipc	s1,0xbd
ffffffffc0202b9a:	58a48493          	addi	s1,s1,1418 # ffffffffc02c0120 <npage>
ffffffffc0202b9e:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202ba2:	000bdb97          	auipc	s7,0xbd
ffffffffc0202ba6:	586b8b93          	addi	s7,s7,1414 # ffffffffc02c0128 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202baa:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202bac:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202bb0:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202bb4:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202bb6:	02f50863          	beq	a0,a5,ffffffffc0202be6 <pmm_init+0xec>
ffffffffc0202bba:	4781                	li	a5,0
ffffffffc0202bbc:	4585                	li	a1,1
ffffffffc0202bbe:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202bc2:	00679513          	slli	a0,a5,0x6
ffffffffc0202bc6:	9532                	add	a0,a0,a2
ffffffffc0202bc8:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd3eeac>
ffffffffc0202bcc:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202bd0:	6088                	ld	a0,0(s1)
ffffffffc0202bd2:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202bd4:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202bd8:	00d50733          	add	a4,a0,a3
ffffffffc0202bdc:	fee7e3e3          	bltu	a5,a4,ffffffffc0202bc2 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202be0:	071a                	slli	a4,a4,0x6
ffffffffc0202be2:	00e606b3          	add	a3,a2,a4
ffffffffc0202be6:	c02007b7          	lui	a5,0xc0200
ffffffffc0202bea:	2ef6ece3          	bltu	a3,a5,ffffffffc02036e2 <pmm_init+0xbe8>
ffffffffc0202bee:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202bf2:	77fd                	lui	a5,0xfffff
ffffffffc0202bf4:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202bf6:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202bf8:	5086eb63          	bltu	a3,s0,ffffffffc020310e <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202bfc:	00004517          	auipc	a0,0x4
ffffffffc0202c00:	0ec50513          	addi	a0,a0,236 # ffffffffc0206ce8 <default_pmm_manager+0x1c8>
ffffffffc0202c04:	d90fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202c08:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202c0c:	000bd917          	auipc	s2,0xbd
ffffffffc0202c10:	50c90913          	addi	s2,s2,1292 # ffffffffc02c0118 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202c14:	7b9c                	ld	a5,48(a5)
ffffffffc0202c16:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202c18:	00004517          	auipc	a0,0x4
ffffffffc0202c1c:	0e850513          	addi	a0,a0,232 # ffffffffc0206d00 <default_pmm_manager+0x1e0>
ffffffffc0202c20:	d74fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202c24:	00007697          	auipc	a3,0x7
ffffffffc0202c28:	3dc68693          	addi	a3,a3,988 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202c2c:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202c30:	c02007b7          	lui	a5,0xc0200
ffffffffc0202c34:	28f6ebe3          	bltu	a3,a5,ffffffffc02036ca <pmm_init+0xbd0>
ffffffffc0202c38:	0009b783          	ld	a5,0(s3)
ffffffffc0202c3c:	8e9d                	sub	a3,a3,a5
ffffffffc0202c3e:	000bd797          	auipc	a5,0xbd
ffffffffc0202c42:	4cd7b923          	sd	a3,1234(a5) # ffffffffc02c0110 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202c46:	100027f3          	csrr	a5,sstatus
ffffffffc0202c4a:	8b89                	andi	a5,a5,2
ffffffffc0202c4c:	4a079763          	bnez	a5,ffffffffc02030fa <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c50:	000b3783          	ld	a5,0(s6)
ffffffffc0202c54:	779c                	ld	a5,40(a5)
ffffffffc0202c56:	9782                	jalr	a5
ffffffffc0202c58:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202c5a:	6098                	ld	a4,0(s1)
ffffffffc0202c5c:	c80007b7          	lui	a5,0xc8000
ffffffffc0202c60:	83b1                	srli	a5,a5,0xc
ffffffffc0202c62:	66e7e363          	bltu	a5,a4,ffffffffc02032c8 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202c66:	00093503          	ld	a0,0(s2)
ffffffffc0202c6a:	62050f63          	beqz	a0,ffffffffc02032a8 <pmm_init+0x7ae>
ffffffffc0202c6e:	03451793          	slli	a5,a0,0x34
ffffffffc0202c72:	62079b63          	bnez	a5,ffffffffc02032a8 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202c76:	4601                	li	a2,0
ffffffffc0202c78:	4581                	li	a1,0
ffffffffc0202c7a:	8c3ff0ef          	jal	ra,ffffffffc020253c <get_page>
ffffffffc0202c7e:	60051563          	bnez	a0,ffffffffc0203288 <pmm_init+0x78e>
ffffffffc0202c82:	100027f3          	csrr	a5,sstatus
ffffffffc0202c86:	8b89                	andi	a5,a5,2
ffffffffc0202c88:	44079e63          	bnez	a5,ffffffffc02030e4 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c8c:	000b3783          	ld	a5,0(s6)
ffffffffc0202c90:	4505                	li	a0,1
ffffffffc0202c92:	6f9c                	ld	a5,24(a5)
ffffffffc0202c94:	9782                	jalr	a5
ffffffffc0202c96:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202c98:	00093503          	ld	a0,0(s2)
ffffffffc0202c9c:	4681                	li	a3,0
ffffffffc0202c9e:	4601                	li	a2,0
ffffffffc0202ca0:	85d2                	mv	a1,s4
ffffffffc0202ca2:	d63ff0ef          	jal	ra,ffffffffc0202a04 <page_insert>
ffffffffc0202ca6:	26051ae3          	bnez	a0,ffffffffc020371a <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202caa:	00093503          	ld	a0,0(s2)
ffffffffc0202cae:	4601                	li	a2,0
ffffffffc0202cb0:	4581                	li	a1,0
ffffffffc0202cb2:	e62ff0ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc0202cb6:	240502e3          	beqz	a0,ffffffffc02036fa <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202cba:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202cbc:	0017f713          	andi	a4,a5,1
ffffffffc0202cc0:	5a070263          	beqz	a4,ffffffffc0203264 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202cc4:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202cc6:	078a                	slli	a5,a5,0x2
ffffffffc0202cc8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cca:	58e7fb63          	bgeu	a5,a4,ffffffffc0203260 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cce:	000bb683          	ld	a3,0(s7)
ffffffffc0202cd2:	fff80637          	lui	a2,0xfff80
ffffffffc0202cd6:	97b2                	add	a5,a5,a2
ffffffffc0202cd8:	079a                	slli	a5,a5,0x6
ffffffffc0202cda:	97b6                	add	a5,a5,a3
ffffffffc0202cdc:	14fa17e3          	bne	s4,a5,ffffffffc020362a <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202ce0:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0202ce4:	4785                	li	a5,1
ffffffffc0202ce6:	12f692e3          	bne	a3,a5,ffffffffc020360a <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202cea:	00093503          	ld	a0,0(s2)
ffffffffc0202cee:	77fd                	lui	a5,0xfffff
ffffffffc0202cf0:	6114                	ld	a3,0(a0)
ffffffffc0202cf2:	068a                	slli	a3,a3,0x2
ffffffffc0202cf4:	8efd                	and	a3,a3,a5
ffffffffc0202cf6:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202cfa:	0ee67ce3          	bgeu	a2,a4,ffffffffc02035f2 <pmm_init+0xaf8>
ffffffffc0202cfe:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202d02:	96e2                	add	a3,a3,s8
ffffffffc0202d04:	0006ba83          	ld	s5,0(a3)
ffffffffc0202d08:	0a8a                	slli	s5,s5,0x2
ffffffffc0202d0a:	00fafab3          	and	s5,s5,a5
ffffffffc0202d0e:	00cad793          	srli	a5,s5,0xc
ffffffffc0202d12:	0ce7f3e3          	bgeu	a5,a4,ffffffffc02035d8 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202d16:	4601                	li	a2,0
ffffffffc0202d18:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202d1a:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202d1c:	df8ff0ef          	jal	ra,ffffffffc0202314 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202d20:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202d22:	55551363          	bne	a0,s5,ffffffffc0203268 <pmm_init+0x76e>
ffffffffc0202d26:	100027f3          	csrr	a5,sstatus
ffffffffc0202d2a:	8b89                	andi	a5,a5,2
ffffffffc0202d2c:	3a079163          	bnez	a5,ffffffffc02030ce <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d30:	000b3783          	ld	a5,0(s6)
ffffffffc0202d34:	4505                	li	a0,1
ffffffffc0202d36:	6f9c                	ld	a5,24(a5)
ffffffffc0202d38:	9782                	jalr	a5
ffffffffc0202d3a:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202d3c:	00093503          	ld	a0,0(s2)
ffffffffc0202d40:	46d1                	li	a3,20
ffffffffc0202d42:	6605                	lui	a2,0x1
ffffffffc0202d44:	85e2                	mv	a1,s8
ffffffffc0202d46:	cbfff0ef          	jal	ra,ffffffffc0202a04 <page_insert>
ffffffffc0202d4a:	060517e3          	bnez	a0,ffffffffc02035b8 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202d4e:	00093503          	ld	a0,0(s2)
ffffffffc0202d52:	4601                	li	a2,0
ffffffffc0202d54:	6585                	lui	a1,0x1
ffffffffc0202d56:	dbeff0ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc0202d5a:	02050fe3          	beqz	a0,ffffffffc0203598 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc0202d5e:	611c                	ld	a5,0(a0)
ffffffffc0202d60:	0107f713          	andi	a4,a5,16
ffffffffc0202d64:	7c070e63          	beqz	a4,ffffffffc0203540 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0202d68:	8b91                	andi	a5,a5,4
ffffffffc0202d6a:	7a078b63          	beqz	a5,ffffffffc0203520 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202d6e:	00093503          	ld	a0,0(s2)
ffffffffc0202d72:	611c                	ld	a5,0(a0)
ffffffffc0202d74:	8bc1                	andi	a5,a5,16
ffffffffc0202d76:	78078563          	beqz	a5,ffffffffc0203500 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0202d7a:	000c2703          	lw	a4,0(s8)
ffffffffc0202d7e:	4785                	li	a5,1
ffffffffc0202d80:	76f71063          	bne	a4,a5,ffffffffc02034e0 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202d84:	4681                	li	a3,0
ffffffffc0202d86:	6605                	lui	a2,0x1
ffffffffc0202d88:	85d2                	mv	a1,s4
ffffffffc0202d8a:	c7bff0ef          	jal	ra,ffffffffc0202a04 <page_insert>
ffffffffc0202d8e:	72051963          	bnez	a0,ffffffffc02034c0 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0202d92:	000a2703          	lw	a4,0(s4)
ffffffffc0202d96:	4789                	li	a5,2
ffffffffc0202d98:	70f71463          	bne	a4,a5,ffffffffc02034a0 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202d9c:	000c2783          	lw	a5,0(s8)
ffffffffc0202da0:	6e079063          	bnez	a5,ffffffffc0203480 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202da4:	00093503          	ld	a0,0(s2)
ffffffffc0202da8:	4601                	li	a2,0
ffffffffc0202daa:	6585                	lui	a1,0x1
ffffffffc0202dac:	d68ff0ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc0202db0:	6a050863          	beqz	a0,ffffffffc0203460 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202db4:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202db6:	00177793          	andi	a5,a4,1
ffffffffc0202dba:	4a078563          	beqz	a5,ffffffffc0203264 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202dbe:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202dc0:	00271793          	slli	a5,a4,0x2
ffffffffc0202dc4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202dc6:	48d7fd63          	bgeu	a5,a3,ffffffffc0203260 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202dca:	000bb683          	ld	a3,0(s7)
ffffffffc0202dce:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202dd2:	97d6                	add	a5,a5,s5
ffffffffc0202dd4:	079a                	slli	a5,a5,0x6
ffffffffc0202dd6:	97b6                	add	a5,a5,a3
ffffffffc0202dd8:	66fa1463          	bne	s4,a5,ffffffffc0203440 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202ddc:	8b41                	andi	a4,a4,16
ffffffffc0202dde:	64071163          	bnez	a4,ffffffffc0203420 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202de2:	00093503          	ld	a0,0(s2)
ffffffffc0202de6:	4581                	li	a1,0
ffffffffc0202de8:	b81ff0ef          	jal	ra,ffffffffc0202968 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202dec:	000a2c83          	lw	s9,0(s4)
ffffffffc0202df0:	4785                	li	a5,1
ffffffffc0202df2:	60fc9763          	bne	s9,a5,ffffffffc0203400 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202df6:	000c2783          	lw	a5,0(s8)
ffffffffc0202dfa:	5e079363          	bnez	a5,ffffffffc02033e0 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202dfe:	00093503          	ld	a0,0(s2)
ffffffffc0202e02:	6585                	lui	a1,0x1
ffffffffc0202e04:	b65ff0ef          	jal	ra,ffffffffc0202968 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202e08:	000a2783          	lw	a5,0(s4)
ffffffffc0202e0c:	52079a63          	bnez	a5,ffffffffc0203340 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202e10:	000c2783          	lw	a5,0(s8)
ffffffffc0202e14:	50079663          	bnez	a5,ffffffffc0203320 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202e18:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202e1c:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e1e:	000a3683          	ld	a3,0(s4)
ffffffffc0202e22:	068a                	slli	a3,a3,0x2
ffffffffc0202e24:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e26:	42b6fd63          	bgeu	a3,a1,ffffffffc0203260 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e2a:	000bb503          	ld	a0,0(s7)
ffffffffc0202e2e:	96d6                	add	a3,a3,s5
ffffffffc0202e30:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202e32:	00d507b3          	add	a5,a0,a3
ffffffffc0202e36:	439c                	lw	a5,0(a5)
ffffffffc0202e38:	4d979463          	bne	a5,s9,ffffffffc0203300 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202e3c:	8699                	srai	a3,a3,0x6
ffffffffc0202e3e:	00080637          	lui	a2,0x80
ffffffffc0202e42:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202e44:	00c69713          	slli	a4,a3,0xc
ffffffffc0202e48:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202e4a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202e4c:	48b77e63          	bgeu	a4,a1,ffffffffc02032e8 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202e50:	0009b703          	ld	a4,0(s3)
ffffffffc0202e54:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e56:	629c                	ld	a5,0(a3)
ffffffffc0202e58:	078a                	slli	a5,a5,0x2
ffffffffc0202e5a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e5c:	40b7f263          	bgeu	a5,a1,ffffffffc0203260 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e60:	8f91                	sub	a5,a5,a2
ffffffffc0202e62:	079a                	slli	a5,a5,0x6
ffffffffc0202e64:	953e                	add	a0,a0,a5
ffffffffc0202e66:	100027f3          	csrr	a5,sstatus
ffffffffc0202e6a:	8b89                	andi	a5,a5,2
ffffffffc0202e6c:	30079963          	bnez	a5,ffffffffc020317e <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202e70:	000b3783          	ld	a5,0(s6)
ffffffffc0202e74:	4585                	li	a1,1
ffffffffc0202e76:	739c                	ld	a5,32(a5)
ffffffffc0202e78:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e7a:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202e7e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e80:	078a                	slli	a5,a5,0x2
ffffffffc0202e82:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e84:	3ce7fe63          	bgeu	a5,a4,ffffffffc0203260 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e88:	000bb503          	ld	a0,0(s7)
ffffffffc0202e8c:	fff80737          	lui	a4,0xfff80
ffffffffc0202e90:	97ba                	add	a5,a5,a4
ffffffffc0202e92:	079a                	slli	a5,a5,0x6
ffffffffc0202e94:	953e                	add	a0,a0,a5
ffffffffc0202e96:	100027f3          	csrr	a5,sstatus
ffffffffc0202e9a:	8b89                	andi	a5,a5,2
ffffffffc0202e9c:	2c079563          	bnez	a5,ffffffffc0203166 <pmm_init+0x66c>
ffffffffc0202ea0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ea4:	4585                	li	a1,1
ffffffffc0202ea6:	739c                	ld	a5,32(a5)
ffffffffc0202ea8:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202eaa:	00093783          	ld	a5,0(s2)
ffffffffc0202eae:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd3eea4>
    asm volatile("sfence.vma");
ffffffffc0202eb2:	12000073          	sfence.vma
ffffffffc0202eb6:	100027f3          	csrr	a5,sstatus
ffffffffc0202eba:	8b89                	andi	a5,a5,2
ffffffffc0202ebc:	28079b63          	bnez	a5,ffffffffc0203152 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ec0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ec4:	779c                	ld	a5,40(a5)
ffffffffc0202ec6:	9782                	jalr	a5
ffffffffc0202ec8:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202eca:	4b441b63          	bne	s0,s4,ffffffffc0203380 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202ece:	00004517          	auipc	a0,0x4
ffffffffc0202ed2:	15a50513          	addi	a0,a0,346 # ffffffffc0207028 <default_pmm_manager+0x508>
ffffffffc0202ed6:	abefd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202eda:	100027f3          	csrr	a5,sstatus
ffffffffc0202ede:	8b89                	andi	a5,a5,2
ffffffffc0202ee0:	24079f63          	bnez	a5,ffffffffc020313e <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ee4:	000b3783          	ld	a5,0(s6)
ffffffffc0202ee8:	779c                	ld	a5,40(a5)
ffffffffc0202eea:	9782                	jalr	a5
ffffffffc0202eec:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202eee:	6098                	ld	a4,0(s1)
ffffffffc0202ef0:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ef4:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202ef6:	00c71793          	slli	a5,a4,0xc
ffffffffc0202efa:	6a05                	lui	s4,0x1
ffffffffc0202efc:	02f47c63          	bgeu	s0,a5,ffffffffc0202f34 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f00:	00c45793          	srli	a5,s0,0xc
ffffffffc0202f04:	00093503          	ld	a0,0(s2)
ffffffffc0202f08:	2ee7ff63          	bgeu	a5,a4,ffffffffc0203206 <pmm_init+0x70c>
ffffffffc0202f0c:	0009b583          	ld	a1,0(s3)
ffffffffc0202f10:	4601                	li	a2,0
ffffffffc0202f12:	95a2                	add	a1,a1,s0
ffffffffc0202f14:	c00ff0ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc0202f18:	32050463          	beqz	a0,ffffffffc0203240 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202f1c:	611c                	ld	a5,0(a0)
ffffffffc0202f1e:	078a                	slli	a5,a5,0x2
ffffffffc0202f20:	0157f7b3          	and	a5,a5,s5
ffffffffc0202f24:	2e879e63          	bne	a5,s0,ffffffffc0203220 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202f28:	6098                	ld	a4,0(s1)
ffffffffc0202f2a:	9452                	add	s0,s0,s4
ffffffffc0202f2c:	00c71793          	slli	a5,a4,0xc
ffffffffc0202f30:	fcf468e3          	bltu	s0,a5,ffffffffc0202f00 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202f34:	00093783          	ld	a5,0(s2)
ffffffffc0202f38:	639c                	ld	a5,0(a5)
ffffffffc0202f3a:	42079363          	bnez	a5,ffffffffc0203360 <pmm_init+0x866>
ffffffffc0202f3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202f42:	8b89                	andi	a5,a5,2
ffffffffc0202f44:	24079963          	bnez	a5,ffffffffc0203196 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202f48:	000b3783          	ld	a5,0(s6)
ffffffffc0202f4c:	4505                	li	a0,1
ffffffffc0202f4e:	6f9c                	ld	a5,24(a5)
ffffffffc0202f50:	9782                	jalr	a5
ffffffffc0202f52:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202f54:	00093503          	ld	a0,0(s2)
ffffffffc0202f58:	4699                	li	a3,6
ffffffffc0202f5a:	10000613          	li	a2,256
ffffffffc0202f5e:	85d2                	mv	a1,s4
ffffffffc0202f60:	aa5ff0ef          	jal	ra,ffffffffc0202a04 <page_insert>
ffffffffc0202f64:	44051e63          	bnez	a0,ffffffffc02033c0 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202f68:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0202f6c:	4785                	li	a5,1
ffffffffc0202f6e:	42f71963          	bne	a4,a5,ffffffffc02033a0 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202f72:	00093503          	ld	a0,0(s2)
ffffffffc0202f76:	6405                	lui	s0,0x1
ffffffffc0202f78:	4699                	li	a3,6
ffffffffc0202f7a:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ab0>
ffffffffc0202f7e:	85d2                	mv	a1,s4
ffffffffc0202f80:	a85ff0ef          	jal	ra,ffffffffc0202a04 <page_insert>
ffffffffc0202f84:	72051363          	bnez	a0,ffffffffc02036aa <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202f88:	000a2703          	lw	a4,0(s4)
ffffffffc0202f8c:	4789                	li	a5,2
ffffffffc0202f8e:	6ef71e63          	bne	a4,a5,ffffffffc020368a <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202f92:	00004597          	auipc	a1,0x4
ffffffffc0202f96:	1de58593          	addi	a1,a1,478 # ffffffffc0207170 <default_pmm_manager+0x650>
ffffffffc0202f9a:	10000513          	li	a0,256
ffffffffc0202f9e:	1b7020ef          	jal	ra,ffffffffc0205954 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202fa2:	10040593          	addi	a1,s0,256
ffffffffc0202fa6:	10000513          	li	a0,256
ffffffffc0202faa:	1bd020ef          	jal	ra,ffffffffc0205966 <strcmp>
ffffffffc0202fae:	6a051e63          	bnez	a0,ffffffffc020366a <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202fb2:	000bb683          	ld	a3,0(s7)
ffffffffc0202fb6:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202fba:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202fbc:	40da06b3          	sub	a3,s4,a3
ffffffffc0202fc0:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202fc2:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202fc4:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202fc6:	8031                	srli	s0,s0,0xc
ffffffffc0202fc8:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202fcc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202fce:	30f77d63          	bgeu	a4,a5,ffffffffc02032e8 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202fd2:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202fd6:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202fda:	96be                	add	a3,a3,a5
ffffffffc0202fdc:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202fe0:	13f020ef          	jal	ra,ffffffffc020591e <strlen>
ffffffffc0202fe4:	66051363          	bnez	a0,ffffffffc020364a <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202fe8:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202fec:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202fee:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd3eea4>
ffffffffc0202ff2:	068a                	slli	a3,a3,0x2
ffffffffc0202ff4:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ff6:	26f6f563          	bgeu	a3,a5,ffffffffc0203260 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202ffa:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ffc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202ffe:	2ef47563          	bgeu	s0,a5,ffffffffc02032e8 <pmm_init+0x7ee>
ffffffffc0203002:	0009b403          	ld	s0,0(s3)
ffffffffc0203006:	9436                	add	s0,s0,a3
ffffffffc0203008:	100027f3          	csrr	a5,sstatus
ffffffffc020300c:	8b89                	andi	a5,a5,2
ffffffffc020300e:	1e079163          	bnez	a5,ffffffffc02031f0 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0203012:	000b3783          	ld	a5,0(s6)
ffffffffc0203016:	4585                	li	a1,1
ffffffffc0203018:	8552                	mv	a0,s4
ffffffffc020301a:	739c                	ld	a5,32(a5)
ffffffffc020301c:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020301e:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0203020:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203022:	078a                	slli	a5,a5,0x2
ffffffffc0203024:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203026:	22e7fd63          	bgeu	a5,a4,ffffffffc0203260 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020302a:	000bb503          	ld	a0,0(s7)
ffffffffc020302e:	fff80737          	lui	a4,0xfff80
ffffffffc0203032:	97ba                	add	a5,a5,a4
ffffffffc0203034:	079a                	slli	a5,a5,0x6
ffffffffc0203036:	953e                	add	a0,a0,a5
ffffffffc0203038:	100027f3          	csrr	a5,sstatus
ffffffffc020303c:	8b89                	andi	a5,a5,2
ffffffffc020303e:	18079d63          	bnez	a5,ffffffffc02031d8 <pmm_init+0x6de>
ffffffffc0203042:	000b3783          	ld	a5,0(s6)
ffffffffc0203046:	4585                	li	a1,1
ffffffffc0203048:	739c                	ld	a5,32(a5)
ffffffffc020304a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020304c:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0203050:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203052:	078a                	slli	a5,a5,0x2
ffffffffc0203054:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203056:	20e7f563          	bgeu	a5,a4,ffffffffc0203260 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020305a:	000bb503          	ld	a0,0(s7)
ffffffffc020305e:	fff80737          	lui	a4,0xfff80
ffffffffc0203062:	97ba                	add	a5,a5,a4
ffffffffc0203064:	079a                	slli	a5,a5,0x6
ffffffffc0203066:	953e                	add	a0,a0,a5
ffffffffc0203068:	100027f3          	csrr	a5,sstatus
ffffffffc020306c:	8b89                	andi	a5,a5,2
ffffffffc020306e:	14079963          	bnez	a5,ffffffffc02031c0 <pmm_init+0x6c6>
ffffffffc0203072:	000b3783          	ld	a5,0(s6)
ffffffffc0203076:	4585                	li	a1,1
ffffffffc0203078:	739c                	ld	a5,32(a5)
ffffffffc020307a:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc020307c:	00093783          	ld	a5,0(s2)
ffffffffc0203080:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0203084:	12000073          	sfence.vma
ffffffffc0203088:	100027f3          	csrr	a5,sstatus
ffffffffc020308c:	8b89                	andi	a5,a5,2
ffffffffc020308e:	10079f63          	bnez	a5,ffffffffc02031ac <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203092:	000b3783          	ld	a5,0(s6)
ffffffffc0203096:	779c                	ld	a5,40(a5)
ffffffffc0203098:	9782                	jalr	a5
ffffffffc020309a:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc020309c:	4c8c1e63          	bne	s8,s0,ffffffffc0203578 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02030a0:	00004517          	auipc	a0,0x4
ffffffffc02030a4:	14850513          	addi	a0,a0,328 # ffffffffc02071e8 <default_pmm_manager+0x6c8>
ffffffffc02030a8:	8ecfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc02030ac:	7406                	ld	s0,96(sp)
ffffffffc02030ae:	70a6                	ld	ra,104(sp)
ffffffffc02030b0:	64e6                	ld	s1,88(sp)
ffffffffc02030b2:	6946                	ld	s2,80(sp)
ffffffffc02030b4:	69a6                	ld	s3,72(sp)
ffffffffc02030b6:	6a06                	ld	s4,64(sp)
ffffffffc02030b8:	7ae2                	ld	s5,56(sp)
ffffffffc02030ba:	7b42                	ld	s6,48(sp)
ffffffffc02030bc:	7ba2                	ld	s7,40(sp)
ffffffffc02030be:	7c02                	ld	s8,32(sp)
ffffffffc02030c0:	6ce2                	ld	s9,24(sp)
ffffffffc02030c2:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc02030c4:	f97fe06f          	j	ffffffffc020205a <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc02030c8:	c80007b7          	lui	a5,0xc8000
ffffffffc02030cc:	bc7d                	j	ffffffffc0202b8a <pmm_init+0x90>
        intr_disable();
ffffffffc02030ce:	8e7fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02030d2:	000b3783          	ld	a5,0(s6)
ffffffffc02030d6:	4505                	li	a0,1
ffffffffc02030d8:	6f9c                	ld	a5,24(a5)
ffffffffc02030da:	9782                	jalr	a5
ffffffffc02030dc:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02030de:	8d1fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02030e2:	b9a9                	j	ffffffffc0202d3c <pmm_init+0x242>
        intr_disable();
ffffffffc02030e4:	8d1fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02030e8:	000b3783          	ld	a5,0(s6)
ffffffffc02030ec:	4505                	li	a0,1
ffffffffc02030ee:	6f9c                	ld	a5,24(a5)
ffffffffc02030f0:	9782                	jalr	a5
ffffffffc02030f2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02030f4:	8bbfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02030f8:	b645                	j	ffffffffc0202c98 <pmm_init+0x19e>
        intr_disable();
ffffffffc02030fa:	8bbfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02030fe:	000b3783          	ld	a5,0(s6)
ffffffffc0203102:	779c                	ld	a5,40(a5)
ffffffffc0203104:	9782                	jalr	a5
ffffffffc0203106:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203108:	8a7fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020310c:	b6b9                	j	ffffffffc0202c5a <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020310e:	6705                	lui	a4,0x1
ffffffffc0203110:	177d                	addi	a4,a4,-1
ffffffffc0203112:	96ba                	add	a3,a3,a4
ffffffffc0203114:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0203116:	00c7d713          	srli	a4,a5,0xc
ffffffffc020311a:	14a77363          	bgeu	a4,a0,ffffffffc0203260 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc020311e:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0203122:	fff80537          	lui	a0,0xfff80
ffffffffc0203126:	972a                	add	a4,a4,a0
ffffffffc0203128:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020312a:	8c1d                	sub	s0,s0,a5
ffffffffc020312c:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0203130:	00c45593          	srli	a1,s0,0xc
ffffffffc0203134:	9532                	add	a0,a0,a2
ffffffffc0203136:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0203138:	0009b583          	ld	a1,0(s3)
}
ffffffffc020313c:	b4c1                	j	ffffffffc0202bfc <pmm_init+0x102>
        intr_disable();
ffffffffc020313e:	877fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203142:	000b3783          	ld	a5,0(s6)
ffffffffc0203146:	779c                	ld	a5,40(a5)
ffffffffc0203148:	9782                	jalr	a5
ffffffffc020314a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020314c:	863fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203150:	bb79                	j	ffffffffc0202eee <pmm_init+0x3f4>
        intr_disable();
ffffffffc0203152:	863fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203156:	000b3783          	ld	a5,0(s6)
ffffffffc020315a:	779c                	ld	a5,40(a5)
ffffffffc020315c:	9782                	jalr	a5
ffffffffc020315e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203160:	84ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203164:	b39d                	j	ffffffffc0202eca <pmm_init+0x3d0>
ffffffffc0203166:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203168:	84dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020316c:	000b3783          	ld	a5,0(s6)
ffffffffc0203170:	6522                	ld	a0,8(sp)
ffffffffc0203172:	4585                	li	a1,1
ffffffffc0203174:	739c                	ld	a5,32(a5)
ffffffffc0203176:	9782                	jalr	a5
        intr_enable();
ffffffffc0203178:	837fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020317c:	b33d                	j	ffffffffc0202eaa <pmm_init+0x3b0>
ffffffffc020317e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203180:	835fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203184:	000b3783          	ld	a5,0(s6)
ffffffffc0203188:	6522                	ld	a0,8(sp)
ffffffffc020318a:	4585                	li	a1,1
ffffffffc020318c:	739c                	ld	a5,32(a5)
ffffffffc020318e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203190:	81ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203194:	b1dd                	j	ffffffffc0202e7a <pmm_init+0x380>
        intr_disable();
ffffffffc0203196:	81ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020319a:	000b3783          	ld	a5,0(s6)
ffffffffc020319e:	4505                	li	a0,1
ffffffffc02031a0:	6f9c                	ld	a5,24(a5)
ffffffffc02031a2:	9782                	jalr	a5
ffffffffc02031a4:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02031a6:	809fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02031aa:	b36d                	j	ffffffffc0202f54 <pmm_init+0x45a>
        intr_disable();
ffffffffc02031ac:	809fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02031b0:	000b3783          	ld	a5,0(s6)
ffffffffc02031b4:	779c                	ld	a5,40(a5)
ffffffffc02031b6:	9782                	jalr	a5
ffffffffc02031b8:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02031ba:	ff4fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02031be:	bdf9                	j	ffffffffc020309c <pmm_init+0x5a2>
ffffffffc02031c0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02031c2:	ff2fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02031c6:	000b3783          	ld	a5,0(s6)
ffffffffc02031ca:	6522                	ld	a0,8(sp)
ffffffffc02031cc:	4585                	li	a1,1
ffffffffc02031ce:	739c                	ld	a5,32(a5)
ffffffffc02031d0:	9782                	jalr	a5
        intr_enable();
ffffffffc02031d2:	fdcfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02031d6:	b55d                	j	ffffffffc020307c <pmm_init+0x582>
ffffffffc02031d8:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02031da:	fdafd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02031de:	000b3783          	ld	a5,0(s6)
ffffffffc02031e2:	6522                	ld	a0,8(sp)
ffffffffc02031e4:	4585                	li	a1,1
ffffffffc02031e6:	739c                	ld	a5,32(a5)
ffffffffc02031e8:	9782                	jalr	a5
        intr_enable();
ffffffffc02031ea:	fc4fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02031ee:	bdb9                	j	ffffffffc020304c <pmm_init+0x552>
        intr_disable();
ffffffffc02031f0:	fc4fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02031f4:	000b3783          	ld	a5,0(s6)
ffffffffc02031f8:	4585                	li	a1,1
ffffffffc02031fa:	8552                	mv	a0,s4
ffffffffc02031fc:	739c                	ld	a5,32(a5)
ffffffffc02031fe:	9782                	jalr	a5
        intr_enable();
ffffffffc0203200:	faefd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203204:	bd29                	j	ffffffffc020301e <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203206:	86a2                	mv	a3,s0
ffffffffc0203208:	00003617          	auipc	a2,0x3
ffffffffc020320c:	47060613          	addi	a2,a2,1136 # ffffffffc0206678 <commands+0xa20>
ffffffffc0203210:	24700593          	li	a1,583
ffffffffc0203214:	00004517          	auipc	a0,0x4
ffffffffc0203218:	a0450513          	addi	a0,a0,-1532 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020321c:	a72fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203220:	00004697          	auipc	a3,0x4
ffffffffc0203224:	e6868693          	addi	a3,a3,-408 # ffffffffc0207088 <default_pmm_manager+0x568>
ffffffffc0203228:	00003617          	auipc	a2,0x3
ffffffffc020322c:	54860613          	addi	a2,a2,1352 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203230:	24800593          	li	a1,584
ffffffffc0203234:	00004517          	auipc	a0,0x4
ffffffffc0203238:	9e450513          	addi	a0,a0,-1564 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020323c:	a52fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203240:	00004697          	auipc	a3,0x4
ffffffffc0203244:	e0868693          	addi	a3,a3,-504 # ffffffffc0207048 <default_pmm_manager+0x528>
ffffffffc0203248:	00003617          	auipc	a2,0x3
ffffffffc020324c:	52860613          	addi	a2,a2,1320 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203250:	24700593          	li	a1,583
ffffffffc0203254:	00004517          	auipc	a0,0x4
ffffffffc0203258:	9c450513          	addi	a0,a0,-1596 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020325c:	a32fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203260:	fc5fe0ef          	jal	ra,ffffffffc0202224 <pa2page.part.0>
ffffffffc0203264:	fddfe0ef          	jal	ra,ffffffffc0202240 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203268:	00004697          	auipc	a3,0x4
ffffffffc020326c:	bd868693          	addi	a3,a3,-1064 # ffffffffc0206e40 <default_pmm_manager+0x320>
ffffffffc0203270:	00003617          	auipc	a2,0x3
ffffffffc0203274:	50060613          	addi	a2,a2,1280 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203278:	21700593          	li	a1,535
ffffffffc020327c:	00004517          	auipc	a0,0x4
ffffffffc0203280:	99c50513          	addi	a0,a0,-1636 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203284:	a0afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0203288:	00004697          	auipc	a3,0x4
ffffffffc020328c:	af868693          	addi	a3,a3,-1288 # ffffffffc0206d80 <default_pmm_manager+0x260>
ffffffffc0203290:	00003617          	auipc	a2,0x3
ffffffffc0203294:	4e060613          	addi	a2,a2,1248 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203298:	20a00593          	li	a1,522
ffffffffc020329c:	00004517          	auipc	a0,0x4
ffffffffc02032a0:	97c50513          	addi	a0,a0,-1668 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02032a4:	9eafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02032a8:	00004697          	auipc	a3,0x4
ffffffffc02032ac:	a9868693          	addi	a3,a3,-1384 # ffffffffc0206d40 <default_pmm_manager+0x220>
ffffffffc02032b0:	00003617          	auipc	a2,0x3
ffffffffc02032b4:	4c060613          	addi	a2,a2,1216 # ffffffffc0206770 <commands+0xb18>
ffffffffc02032b8:	20900593          	li	a1,521
ffffffffc02032bc:	00004517          	auipc	a0,0x4
ffffffffc02032c0:	95c50513          	addi	a0,a0,-1700 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02032c4:	9cafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02032c8:	00004697          	auipc	a3,0x4
ffffffffc02032cc:	a5868693          	addi	a3,a3,-1448 # ffffffffc0206d20 <default_pmm_manager+0x200>
ffffffffc02032d0:	00003617          	auipc	a2,0x3
ffffffffc02032d4:	4a060613          	addi	a2,a2,1184 # ffffffffc0206770 <commands+0xb18>
ffffffffc02032d8:	20800593          	li	a1,520
ffffffffc02032dc:	00004517          	auipc	a0,0x4
ffffffffc02032e0:	93c50513          	addi	a0,a0,-1732 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02032e4:	9aafd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02032e8:	00003617          	auipc	a2,0x3
ffffffffc02032ec:	39060613          	addi	a2,a2,912 # ffffffffc0206678 <commands+0xa20>
ffffffffc02032f0:	07100593          	li	a1,113
ffffffffc02032f4:	00003517          	auipc	a0,0x3
ffffffffc02032f8:	1cc50513          	addi	a0,a0,460 # ffffffffc02064c0 <commands+0x868>
ffffffffc02032fc:	992fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0203300:	00004697          	auipc	a3,0x4
ffffffffc0203304:	cd068693          	addi	a3,a3,-816 # ffffffffc0206fd0 <default_pmm_manager+0x4b0>
ffffffffc0203308:	00003617          	auipc	a2,0x3
ffffffffc020330c:	46860613          	addi	a2,a2,1128 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203310:	23000593          	li	a1,560
ffffffffc0203314:	00004517          	auipc	a0,0x4
ffffffffc0203318:	90450513          	addi	a0,a0,-1788 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020331c:	972fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203320:	00004697          	auipc	a3,0x4
ffffffffc0203324:	c6868693          	addi	a3,a3,-920 # ffffffffc0206f88 <default_pmm_manager+0x468>
ffffffffc0203328:	00003617          	auipc	a2,0x3
ffffffffc020332c:	44860613          	addi	a2,a2,1096 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203330:	22e00593          	li	a1,558
ffffffffc0203334:	00004517          	auipc	a0,0x4
ffffffffc0203338:	8e450513          	addi	a0,a0,-1820 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020333c:	952fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203340:	00004697          	auipc	a3,0x4
ffffffffc0203344:	c7868693          	addi	a3,a3,-904 # ffffffffc0206fb8 <default_pmm_manager+0x498>
ffffffffc0203348:	00003617          	auipc	a2,0x3
ffffffffc020334c:	42860613          	addi	a2,a2,1064 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203350:	22d00593          	li	a1,557
ffffffffc0203354:	00004517          	auipc	a0,0x4
ffffffffc0203358:	8c450513          	addi	a0,a0,-1852 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020335c:	932fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203360:	00004697          	auipc	a3,0x4
ffffffffc0203364:	d4068693          	addi	a3,a3,-704 # ffffffffc02070a0 <default_pmm_manager+0x580>
ffffffffc0203368:	00003617          	auipc	a2,0x3
ffffffffc020336c:	40860613          	addi	a2,a2,1032 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203370:	24b00593          	li	a1,587
ffffffffc0203374:	00004517          	auipc	a0,0x4
ffffffffc0203378:	8a450513          	addi	a0,a0,-1884 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020337c:	912fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203380:	00004697          	auipc	a3,0x4
ffffffffc0203384:	c8068693          	addi	a3,a3,-896 # ffffffffc0207000 <default_pmm_manager+0x4e0>
ffffffffc0203388:	00003617          	auipc	a2,0x3
ffffffffc020338c:	3e860613          	addi	a2,a2,1000 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203390:	23800593          	li	a1,568
ffffffffc0203394:	00004517          	auipc	a0,0x4
ffffffffc0203398:	88450513          	addi	a0,a0,-1916 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020339c:	8f2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc02033a0:	00004697          	auipc	a3,0x4
ffffffffc02033a4:	d5868693          	addi	a3,a3,-680 # ffffffffc02070f8 <default_pmm_manager+0x5d8>
ffffffffc02033a8:	00003617          	auipc	a2,0x3
ffffffffc02033ac:	3c860613          	addi	a2,a2,968 # ffffffffc0206770 <commands+0xb18>
ffffffffc02033b0:	25000593          	li	a1,592
ffffffffc02033b4:	00004517          	auipc	a0,0x4
ffffffffc02033b8:	86450513          	addi	a0,a0,-1948 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02033bc:	8d2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02033c0:	00004697          	auipc	a3,0x4
ffffffffc02033c4:	cf868693          	addi	a3,a3,-776 # ffffffffc02070b8 <default_pmm_manager+0x598>
ffffffffc02033c8:	00003617          	auipc	a2,0x3
ffffffffc02033cc:	3a860613          	addi	a2,a2,936 # ffffffffc0206770 <commands+0xb18>
ffffffffc02033d0:	24f00593          	li	a1,591
ffffffffc02033d4:	00004517          	auipc	a0,0x4
ffffffffc02033d8:	84450513          	addi	a0,a0,-1980 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02033dc:	8b2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02033e0:	00004697          	auipc	a3,0x4
ffffffffc02033e4:	ba868693          	addi	a3,a3,-1112 # ffffffffc0206f88 <default_pmm_manager+0x468>
ffffffffc02033e8:	00003617          	auipc	a2,0x3
ffffffffc02033ec:	38860613          	addi	a2,a2,904 # ffffffffc0206770 <commands+0xb18>
ffffffffc02033f0:	22a00593          	li	a1,554
ffffffffc02033f4:	00004517          	auipc	a0,0x4
ffffffffc02033f8:	82450513          	addi	a0,a0,-2012 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02033fc:	892fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203400:	00004697          	auipc	a3,0x4
ffffffffc0203404:	a2868693          	addi	a3,a3,-1496 # ffffffffc0206e28 <default_pmm_manager+0x308>
ffffffffc0203408:	00003617          	auipc	a2,0x3
ffffffffc020340c:	36860613          	addi	a2,a2,872 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203410:	22900593          	li	a1,553
ffffffffc0203414:	00004517          	auipc	a0,0x4
ffffffffc0203418:	80450513          	addi	a0,a0,-2044 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020341c:	872fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203420:	00004697          	auipc	a3,0x4
ffffffffc0203424:	b8068693          	addi	a3,a3,-1152 # ffffffffc0206fa0 <default_pmm_manager+0x480>
ffffffffc0203428:	00003617          	auipc	a2,0x3
ffffffffc020342c:	34860613          	addi	a2,a2,840 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203430:	22600593          	li	a1,550
ffffffffc0203434:	00003517          	auipc	a0,0x3
ffffffffc0203438:	7e450513          	addi	a0,a0,2020 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020343c:	852fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203440:	00004697          	auipc	a3,0x4
ffffffffc0203444:	9d068693          	addi	a3,a3,-1584 # ffffffffc0206e10 <default_pmm_manager+0x2f0>
ffffffffc0203448:	00003617          	auipc	a2,0x3
ffffffffc020344c:	32860613          	addi	a2,a2,808 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203450:	22500593          	li	a1,549
ffffffffc0203454:	00003517          	auipc	a0,0x3
ffffffffc0203458:	7c450513          	addi	a0,a0,1988 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020345c:	832fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203460:	00004697          	auipc	a3,0x4
ffffffffc0203464:	a5068693          	addi	a3,a3,-1456 # ffffffffc0206eb0 <default_pmm_manager+0x390>
ffffffffc0203468:	00003617          	auipc	a2,0x3
ffffffffc020346c:	30860613          	addi	a2,a2,776 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203470:	22400593          	li	a1,548
ffffffffc0203474:	00003517          	auipc	a0,0x3
ffffffffc0203478:	7a450513          	addi	a0,a0,1956 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020347c:	812fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203480:	00004697          	auipc	a3,0x4
ffffffffc0203484:	b0868693          	addi	a3,a3,-1272 # ffffffffc0206f88 <default_pmm_manager+0x468>
ffffffffc0203488:	00003617          	auipc	a2,0x3
ffffffffc020348c:	2e860613          	addi	a2,a2,744 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203490:	22300593          	li	a1,547
ffffffffc0203494:	00003517          	auipc	a0,0x3
ffffffffc0203498:	78450513          	addi	a0,a0,1924 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020349c:	ff3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02034a0:	00004697          	auipc	a3,0x4
ffffffffc02034a4:	ad068693          	addi	a3,a3,-1328 # ffffffffc0206f70 <default_pmm_manager+0x450>
ffffffffc02034a8:	00003617          	auipc	a2,0x3
ffffffffc02034ac:	2c860613          	addi	a2,a2,712 # ffffffffc0206770 <commands+0xb18>
ffffffffc02034b0:	22200593          	li	a1,546
ffffffffc02034b4:	00003517          	auipc	a0,0x3
ffffffffc02034b8:	76450513          	addi	a0,a0,1892 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02034bc:	fd3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02034c0:	00004697          	auipc	a3,0x4
ffffffffc02034c4:	a8068693          	addi	a3,a3,-1408 # ffffffffc0206f40 <default_pmm_manager+0x420>
ffffffffc02034c8:	00003617          	auipc	a2,0x3
ffffffffc02034cc:	2a860613          	addi	a2,a2,680 # ffffffffc0206770 <commands+0xb18>
ffffffffc02034d0:	22100593          	li	a1,545
ffffffffc02034d4:	00003517          	auipc	a0,0x3
ffffffffc02034d8:	74450513          	addi	a0,a0,1860 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02034dc:	fb3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02034e0:	00004697          	auipc	a3,0x4
ffffffffc02034e4:	a4868693          	addi	a3,a3,-1464 # ffffffffc0206f28 <default_pmm_manager+0x408>
ffffffffc02034e8:	00003617          	auipc	a2,0x3
ffffffffc02034ec:	28860613          	addi	a2,a2,648 # ffffffffc0206770 <commands+0xb18>
ffffffffc02034f0:	21f00593          	li	a1,543
ffffffffc02034f4:	00003517          	auipc	a0,0x3
ffffffffc02034f8:	72450513          	addi	a0,a0,1828 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02034fc:	f93fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203500:	00004697          	auipc	a3,0x4
ffffffffc0203504:	a0868693          	addi	a3,a3,-1528 # ffffffffc0206f08 <default_pmm_manager+0x3e8>
ffffffffc0203508:	00003617          	auipc	a2,0x3
ffffffffc020350c:	26860613          	addi	a2,a2,616 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203510:	21e00593          	li	a1,542
ffffffffc0203514:	00003517          	auipc	a0,0x3
ffffffffc0203518:	70450513          	addi	a0,a0,1796 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020351c:	f73fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203520:	00004697          	auipc	a3,0x4
ffffffffc0203524:	9d868693          	addi	a3,a3,-1576 # ffffffffc0206ef8 <default_pmm_manager+0x3d8>
ffffffffc0203528:	00003617          	auipc	a2,0x3
ffffffffc020352c:	24860613          	addi	a2,a2,584 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203530:	21d00593          	li	a1,541
ffffffffc0203534:	00003517          	auipc	a0,0x3
ffffffffc0203538:	6e450513          	addi	a0,a0,1764 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020353c:	f53fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203540:	00004697          	auipc	a3,0x4
ffffffffc0203544:	9a868693          	addi	a3,a3,-1624 # ffffffffc0206ee8 <default_pmm_manager+0x3c8>
ffffffffc0203548:	00003617          	auipc	a2,0x3
ffffffffc020354c:	22860613          	addi	a2,a2,552 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203550:	21c00593          	li	a1,540
ffffffffc0203554:	00003517          	auipc	a0,0x3
ffffffffc0203558:	6c450513          	addi	a0,a0,1732 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020355c:	f33fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc0203560:	00003617          	auipc	a2,0x3
ffffffffc0203564:	72860613          	addi	a2,a2,1832 # ffffffffc0206c88 <default_pmm_manager+0x168>
ffffffffc0203568:	06500593          	li	a1,101
ffffffffc020356c:	00003517          	auipc	a0,0x3
ffffffffc0203570:	6ac50513          	addi	a0,a0,1708 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203574:	f1bfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203578:	00004697          	auipc	a3,0x4
ffffffffc020357c:	a8868693          	addi	a3,a3,-1400 # ffffffffc0207000 <default_pmm_manager+0x4e0>
ffffffffc0203580:	00003617          	auipc	a2,0x3
ffffffffc0203584:	1f060613          	addi	a2,a2,496 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203588:	26200593          	li	a1,610
ffffffffc020358c:	00003517          	auipc	a0,0x3
ffffffffc0203590:	68c50513          	addi	a0,a0,1676 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203594:	efbfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203598:	00004697          	auipc	a3,0x4
ffffffffc020359c:	91868693          	addi	a3,a3,-1768 # ffffffffc0206eb0 <default_pmm_manager+0x390>
ffffffffc02035a0:	00003617          	auipc	a2,0x3
ffffffffc02035a4:	1d060613          	addi	a2,a2,464 # ffffffffc0206770 <commands+0xb18>
ffffffffc02035a8:	21b00593          	li	a1,539
ffffffffc02035ac:	00003517          	auipc	a0,0x3
ffffffffc02035b0:	66c50513          	addi	a0,a0,1644 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02035b4:	edbfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02035b8:	00004697          	auipc	a3,0x4
ffffffffc02035bc:	8b868693          	addi	a3,a3,-1864 # ffffffffc0206e70 <default_pmm_manager+0x350>
ffffffffc02035c0:	00003617          	auipc	a2,0x3
ffffffffc02035c4:	1b060613          	addi	a2,a2,432 # ffffffffc0206770 <commands+0xb18>
ffffffffc02035c8:	21a00593          	li	a1,538
ffffffffc02035cc:	00003517          	auipc	a0,0x3
ffffffffc02035d0:	64c50513          	addi	a0,a0,1612 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02035d4:	ebbfc0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02035d8:	86d6                	mv	a3,s5
ffffffffc02035da:	00003617          	auipc	a2,0x3
ffffffffc02035de:	09e60613          	addi	a2,a2,158 # ffffffffc0206678 <commands+0xa20>
ffffffffc02035e2:	21600593          	li	a1,534
ffffffffc02035e6:	00003517          	auipc	a0,0x3
ffffffffc02035ea:	63250513          	addi	a0,a0,1586 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02035ee:	ea1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02035f2:	00003617          	auipc	a2,0x3
ffffffffc02035f6:	08660613          	addi	a2,a2,134 # ffffffffc0206678 <commands+0xa20>
ffffffffc02035fa:	21500593          	li	a1,533
ffffffffc02035fe:	00003517          	auipc	a0,0x3
ffffffffc0203602:	61a50513          	addi	a0,a0,1562 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203606:	e89fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020360a:	00004697          	auipc	a3,0x4
ffffffffc020360e:	81e68693          	addi	a3,a3,-2018 # ffffffffc0206e28 <default_pmm_manager+0x308>
ffffffffc0203612:	00003617          	auipc	a2,0x3
ffffffffc0203616:	15e60613          	addi	a2,a2,350 # ffffffffc0206770 <commands+0xb18>
ffffffffc020361a:	21300593          	li	a1,531
ffffffffc020361e:	00003517          	auipc	a0,0x3
ffffffffc0203622:	5fa50513          	addi	a0,a0,1530 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203626:	e69fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020362a:	00003697          	auipc	a3,0x3
ffffffffc020362e:	7e668693          	addi	a3,a3,2022 # ffffffffc0206e10 <default_pmm_manager+0x2f0>
ffffffffc0203632:	00003617          	auipc	a2,0x3
ffffffffc0203636:	13e60613          	addi	a2,a2,318 # ffffffffc0206770 <commands+0xb18>
ffffffffc020363a:	21200593          	li	a1,530
ffffffffc020363e:	00003517          	auipc	a0,0x3
ffffffffc0203642:	5da50513          	addi	a0,a0,1498 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203646:	e49fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020364a:	00004697          	auipc	a3,0x4
ffffffffc020364e:	b7668693          	addi	a3,a3,-1162 # ffffffffc02071c0 <default_pmm_manager+0x6a0>
ffffffffc0203652:	00003617          	auipc	a2,0x3
ffffffffc0203656:	11e60613          	addi	a2,a2,286 # ffffffffc0206770 <commands+0xb18>
ffffffffc020365a:	25900593          	li	a1,601
ffffffffc020365e:	00003517          	auipc	a0,0x3
ffffffffc0203662:	5ba50513          	addi	a0,a0,1466 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203666:	e29fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020366a:	00004697          	auipc	a3,0x4
ffffffffc020366e:	b1e68693          	addi	a3,a3,-1250 # ffffffffc0207188 <default_pmm_manager+0x668>
ffffffffc0203672:	00003617          	auipc	a2,0x3
ffffffffc0203676:	0fe60613          	addi	a2,a2,254 # ffffffffc0206770 <commands+0xb18>
ffffffffc020367a:	25600593          	li	a1,598
ffffffffc020367e:	00003517          	auipc	a0,0x3
ffffffffc0203682:	59a50513          	addi	a0,a0,1434 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203686:	e09fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc020368a:	00004697          	auipc	a3,0x4
ffffffffc020368e:	ace68693          	addi	a3,a3,-1330 # ffffffffc0207158 <default_pmm_manager+0x638>
ffffffffc0203692:	00003617          	auipc	a2,0x3
ffffffffc0203696:	0de60613          	addi	a2,a2,222 # ffffffffc0206770 <commands+0xb18>
ffffffffc020369a:	25200593          	li	a1,594
ffffffffc020369e:	00003517          	auipc	a0,0x3
ffffffffc02036a2:	57a50513          	addi	a0,a0,1402 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02036a6:	de9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02036aa:	00004697          	auipc	a3,0x4
ffffffffc02036ae:	a6668693          	addi	a3,a3,-1434 # ffffffffc0207110 <default_pmm_manager+0x5f0>
ffffffffc02036b2:	00003617          	auipc	a2,0x3
ffffffffc02036b6:	0be60613          	addi	a2,a2,190 # ffffffffc0206770 <commands+0xb18>
ffffffffc02036ba:	25100593          	li	a1,593
ffffffffc02036be:	00003517          	auipc	a0,0x3
ffffffffc02036c2:	55a50513          	addi	a0,a0,1370 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02036c6:	dc9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02036ca:	00003617          	auipc	a2,0x3
ffffffffc02036ce:	4fe60613          	addi	a2,a2,1278 # ffffffffc0206bc8 <default_pmm_manager+0xa8>
ffffffffc02036d2:	0c900593          	li	a1,201
ffffffffc02036d6:	00003517          	auipc	a0,0x3
ffffffffc02036da:	54250513          	addi	a0,a0,1346 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02036de:	db1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02036e2:	00003617          	auipc	a2,0x3
ffffffffc02036e6:	4e660613          	addi	a2,a2,1254 # ffffffffc0206bc8 <default_pmm_manager+0xa8>
ffffffffc02036ea:	08100593          	li	a1,129
ffffffffc02036ee:	00003517          	auipc	a0,0x3
ffffffffc02036f2:	52a50513          	addi	a0,a0,1322 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02036f6:	d99fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02036fa:	00003697          	auipc	a3,0x3
ffffffffc02036fe:	6e668693          	addi	a3,a3,1766 # ffffffffc0206de0 <default_pmm_manager+0x2c0>
ffffffffc0203702:	00003617          	auipc	a2,0x3
ffffffffc0203706:	06e60613          	addi	a2,a2,110 # ffffffffc0206770 <commands+0xb18>
ffffffffc020370a:	21100593          	li	a1,529
ffffffffc020370e:	00003517          	auipc	a0,0x3
ffffffffc0203712:	50a50513          	addi	a0,a0,1290 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203716:	d79fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc020371a:	00003697          	auipc	a3,0x3
ffffffffc020371e:	69668693          	addi	a3,a3,1686 # ffffffffc0206db0 <default_pmm_manager+0x290>
ffffffffc0203722:	00003617          	auipc	a2,0x3
ffffffffc0203726:	04e60613          	addi	a2,a2,78 # ffffffffc0206770 <commands+0xb18>
ffffffffc020372a:	20e00593          	li	a1,526
ffffffffc020372e:	00003517          	auipc	a0,0x3
ffffffffc0203732:	4ea50513          	addi	a0,a0,1258 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc0203736:	d59fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020373a <copy_range>:
{
ffffffffc020373a:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020373c:	00d66733          	or	a4,a2,a3
{
ffffffffc0203740:	f486                	sd	ra,104(sp)
ffffffffc0203742:	f0a2                	sd	s0,96(sp)
ffffffffc0203744:	eca6                	sd	s1,88(sp)
ffffffffc0203746:	e8ca                	sd	s2,80(sp)
ffffffffc0203748:	e4ce                	sd	s3,72(sp)
ffffffffc020374a:	e0d2                	sd	s4,64(sp)
ffffffffc020374c:	fc56                	sd	s5,56(sp)
ffffffffc020374e:	f85a                	sd	s6,48(sp)
ffffffffc0203750:	f45e                	sd	s7,40(sp)
ffffffffc0203752:	f062                	sd	s8,32(sp)
ffffffffc0203754:	ec66                	sd	s9,24(sp)
ffffffffc0203756:	e86a                	sd	s10,16(sp)
ffffffffc0203758:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020375a:	1752                	slli	a4,a4,0x34
ffffffffc020375c:	1a071163          	bnez	a4,ffffffffc02038fe <copy_range+0x1c4>
    assert(USER_ACCESS(start, end));
ffffffffc0203760:	00200737          	lui	a4,0x200
ffffffffc0203764:	8db2                	mv	s11,a2
ffffffffc0203766:	12e66463          	bltu	a2,a4,ffffffffc020388e <copy_range+0x154>
ffffffffc020376a:	84b6                	mv	s1,a3
ffffffffc020376c:	12d67163          	bgeu	a2,a3,ffffffffc020388e <copy_range+0x154>
ffffffffc0203770:	4705                	li	a4,1
ffffffffc0203772:	077e                	slli	a4,a4,0x1f
ffffffffc0203774:	10d76d63          	bltu	a4,a3,ffffffffc020388e <copy_range+0x154>
ffffffffc0203778:	89aa                	mv	s3,a0
ffffffffc020377a:	892e                	mv	s2,a1
        start += PGSIZE;
ffffffffc020377c:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc020377e:	000bdc97          	auipc	s9,0xbd
ffffffffc0203782:	9a2c8c93          	addi	s9,s9,-1630 # ffffffffc02c0120 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203786:	000bdb17          	auipc	s6,0xbd
ffffffffc020378a:	9a2b0b13          	addi	s6,s6,-1630 # ffffffffc02c0128 <pages>
    return page - pages + nbase;
ffffffffc020378e:	00080ab7          	lui	s5,0x80
            cprintf("COW share: va=%p ppn=%x ref=%d\n", (void *)start, page2ppn(page), page_ref(page));
ffffffffc0203792:	00004b97          	auipc	s7,0x4
ffffffffc0203796:	a86b8b93          	addi	s7,s7,-1402 # ffffffffc0207218 <default_pmm_manager+0x6f8>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc020379a:	4601                	li	a2,0
ffffffffc020379c:	85ee                	mv	a1,s11
ffffffffc020379e:	854a                	mv	a0,s2
ffffffffc02037a0:	b75fe0ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc02037a4:	8d2a                	mv	s10,a0
        if (ptep == NULL)
ffffffffc02037a6:	c571                	beqz	a0,ffffffffc0203872 <copy_range+0x138>
        if (*ptep & PTE_V)
ffffffffc02037a8:	6114                	ld	a3,0(a0)
ffffffffc02037aa:	8a85                	andi	a3,a3,1
ffffffffc02037ac:	e685                	bnez	a3,ffffffffc02037d4 <copy_range+0x9a>
        start += PGSIZE;
ffffffffc02037ae:	9dd2                	add	s11,s11,s4
    } while (start != 0 && start < end);
ffffffffc02037b0:	fe9de5e3          	bltu	s11,s1,ffffffffc020379a <copy_range+0x60>
    return 0;
ffffffffc02037b4:	4501                	li	a0,0
}
ffffffffc02037b6:	70a6                	ld	ra,104(sp)
ffffffffc02037b8:	7406                	ld	s0,96(sp)
ffffffffc02037ba:	64e6                	ld	s1,88(sp)
ffffffffc02037bc:	6946                	ld	s2,80(sp)
ffffffffc02037be:	69a6                	ld	s3,72(sp)
ffffffffc02037c0:	6a06                	ld	s4,64(sp)
ffffffffc02037c2:	7ae2                	ld	s5,56(sp)
ffffffffc02037c4:	7b42                	ld	s6,48(sp)
ffffffffc02037c6:	7ba2                	ld	s7,40(sp)
ffffffffc02037c8:	7c02                	ld	s8,32(sp)
ffffffffc02037ca:	6ce2                	ld	s9,24(sp)
ffffffffc02037cc:	6d42                	ld	s10,16(sp)
ffffffffc02037ce:	6da2                	ld	s11,8(sp)
ffffffffc02037d0:	6165                	addi	sp,sp,112
ffffffffc02037d2:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02037d4:	4605                	li	a2,1
ffffffffc02037d6:	85ee                	mv	a1,s11
ffffffffc02037d8:	854e                	mv	a0,s3
ffffffffc02037da:	b3bfe0ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc02037de:	c555                	beqz	a0,ffffffffc020388a <copy_range+0x150>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc02037e0:	000d3683          	ld	a3,0(s10)
    if (!(pte & PTE_V))
ffffffffc02037e4:	0016f613          	andi	a2,a3,1
ffffffffc02037e8:	0006841b          	sext.w	s0,a3
ffffffffc02037ec:	0e060d63          	beqz	a2,ffffffffc02038e6 <copy_range+0x1ac>
    if (PPN(pa) >= npage)
ffffffffc02037f0:	000cb583          	ld	a1,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02037f4:	00269613          	slli	a2,a3,0x2
ffffffffc02037f8:	8231                	srli	a2,a2,0xc
    if (PPN(pa) >= npage)
ffffffffc02037fa:	0cb67a63          	bgeu	a2,a1,ffffffffc02038ce <copy_range+0x194>
    return &pages[PPN(pa) - nbase];
ffffffffc02037fe:	000b3803          	ld	a6,0(s6)
ffffffffc0203802:	fff807b7          	lui	a5,0xfff80
ffffffffc0203806:	963e                	add	a2,a2,a5
ffffffffc0203808:	061a                	slli	a2,a2,0x6
ffffffffc020380a:	00c80c33          	add	s8,a6,a2
            assert(page != NULL);
ffffffffc020380e:	0a0c0063          	beqz	s8,ffffffffc02038ae <copy_range+0x174>
            cprintf("COW share: va=%p ppn=%x ref=%d\n", (void *)start, page2ppn(page), page_ref(page));
ffffffffc0203812:	000c2683          	lw	a3,0(s8)
    return page - pages + nbase;
ffffffffc0203816:	8619                	srai	a2,a2,0x6
ffffffffc0203818:	9656                	add	a2,a2,s5
ffffffffc020381a:	85ee                	mv	a1,s11
ffffffffc020381c:	855e                	mv	a0,s7
ffffffffc020381e:	977fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203822:	4605                	li	a2,1
ffffffffc0203824:	85ee                	mv	a1,s11
ffffffffc0203826:	854e                	mv	a0,s3
            uint32_t ro_perm = perm & (~PTE_W);
ffffffffc0203828:	886d                	andi	s0,s0,27
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc020382a:	aebfe0ef          	jal	ra,ffffffffc0202314 <get_pte>
ffffffffc020382e:	cd31                	beqz	a0,ffffffffc020388a <copy_range+0x150>
            if (page_insert(to, page, start, ro_perm) != 0)
ffffffffc0203830:	86a2                	mv	a3,s0
ffffffffc0203832:	866e                	mv	a2,s11
ffffffffc0203834:	85e2                	mv	a1,s8
ffffffffc0203836:	854e                	mv	a0,s3
ffffffffc0203838:	9ccff0ef          	jal	ra,ffffffffc0202a04 <page_insert>
ffffffffc020383c:	e539                	bnez	a0,ffffffffc020388a <copy_range+0x150>
ffffffffc020383e:	000b3603          	ld	a2,0(s6)
ffffffffc0203842:	40cc0633          	sub	a2,s8,a2
ffffffffc0203846:	8619                	srai	a2,a2,0x6
ffffffffc0203848:	9656                	add	a2,a2,s5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020384a:	00a61693          	slli	a3,a2,0xa
ffffffffc020384e:	8c55                	or	s0,s0,a3
ffffffffc0203850:	00146413          	ori	s0,s0,1
            *ptep = pte_create(page2ppn(page), ro_perm);
ffffffffc0203854:	008d3023          	sd	s0,0(s10)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0203858:	120d8073          	sfence.vma	s11
            cprintf("COW mapped: va=%p ppn=%x new_ref=%d\n", (void *)start, page2ppn(page), page_ref(page));
ffffffffc020385c:	000c2683          	lw	a3,0(s8)
ffffffffc0203860:	85ee                	mv	a1,s11
ffffffffc0203862:	00004517          	auipc	a0,0x4
ffffffffc0203866:	9d650513          	addi	a0,a0,-1578 # ffffffffc0207238 <default_pmm_manager+0x718>
ffffffffc020386a:	92bfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        start += PGSIZE;
ffffffffc020386e:	9dd2                	add	s11,s11,s4
    } while (start != 0 && start < end);
ffffffffc0203870:	b781                	j	ffffffffc02037b0 <copy_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203872:	002007b7          	lui	a5,0x200
ffffffffc0203876:	97ee                	add	a5,a5,s11
ffffffffc0203878:	ffe00737          	lui	a4,0xffe00
ffffffffc020387c:	00e7fdb3          	and	s11,a5,a4
    } while (start != 0 && start < end);
ffffffffc0203880:	f20d8ae3          	beqz	s11,ffffffffc02037b4 <copy_range+0x7a>
ffffffffc0203884:	f09debe3          	bltu	s11,s1,ffffffffc020379a <copy_range+0x60>
ffffffffc0203888:	b735                	j	ffffffffc02037b4 <copy_range+0x7a>
                return -E_NO_MEM;
ffffffffc020388a:	5571                	li	a0,-4
ffffffffc020388c:	b72d                	j	ffffffffc02037b6 <copy_range+0x7c>
    assert(USER_ACCESS(start, end));
ffffffffc020388e:	00003697          	auipc	a3,0x3
ffffffffc0203892:	3ca68693          	addi	a3,a3,970 # ffffffffc0206c58 <default_pmm_manager+0x138>
ffffffffc0203896:	00003617          	auipc	a2,0x3
ffffffffc020389a:	eda60613          	addi	a2,a2,-294 # ffffffffc0206770 <commands+0xb18>
ffffffffc020389e:	17c00593          	li	a1,380
ffffffffc02038a2:	00003517          	auipc	a0,0x3
ffffffffc02038a6:	37650513          	addi	a0,a0,886 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02038aa:	be5fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc02038ae:	00004697          	auipc	a3,0x4
ffffffffc02038b2:	95a68693          	addi	a3,a3,-1702 # ffffffffc0207208 <default_pmm_manager+0x6e8>
ffffffffc02038b6:	00003617          	auipc	a2,0x3
ffffffffc02038ba:	eba60613          	addi	a2,a2,-326 # ffffffffc0206770 <commands+0xb18>
ffffffffc02038be:	19600593          	li	a1,406
ffffffffc02038c2:	00003517          	auipc	a0,0x3
ffffffffc02038c6:	35650513          	addi	a0,a0,854 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02038ca:	bc5fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02038ce:	00003617          	auipc	a2,0x3
ffffffffc02038d2:	bd260613          	addi	a2,a2,-1070 # ffffffffc02064a0 <commands+0x848>
ffffffffc02038d6:	06900593          	li	a1,105
ffffffffc02038da:	00003517          	auipc	a0,0x3
ffffffffc02038de:	be650513          	addi	a0,a0,-1050 # ffffffffc02064c0 <commands+0x868>
ffffffffc02038e2:	badfc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02038e6:	00003617          	auipc	a2,0x3
ffffffffc02038ea:	30a60613          	addi	a2,a2,778 # ffffffffc0206bf0 <default_pmm_manager+0xd0>
ffffffffc02038ee:	07f00593          	li	a1,127
ffffffffc02038f2:	00003517          	auipc	a0,0x3
ffffffffc02038f6:	bce50513          	addi	a0,a0,-1074 # ffffffffc02064c0 <commands+0x868>
ffffffffc02038fa:	b95fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02038fe:	00003697          	auipc	a3,0x3
ffffffffc0203902:	32a68693          	addi	a3,a3,810 # ffffffffc0206c28 <default_pmm_manager+0x108>
ffffffffc0203906:	00003617          	auipc	a2,0x3
ffffffffc020390a:	e6a60613          	addi	a2,a2,-406 # ffffffffc0206770 <commands+0xb18>
ffffffffc020390e:	17b00593          	li	a1,379
ffffffffc0203912:	00003517          	auipc	a0,0x3
ffffffffc0203916:	30650513          	addi	a0,a0,774 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc020391a:	b75fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020391e <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020391e:	12058073          	sfence.vma	a1
}
ffffffffc0203922:	8082                	ret

ffffffffc0203924 <pgdir_alloc_page>:
{
ffffffffc0203924:	7179                	addi	sp,sp,-48
ffffffffc0203926:	ec26                	sd	s1,24(sp)
ffffffffc0203928:	e84a                	sd	s2,16(sp)
ffffffffc020392a:	e052                	sd	s4,0(sp)
ffffffffc020392c:	f406                	sd	ra,40(sp)
ffffffffc020392e:	f022                	sd	s0,32(sp)
ffffffffc0203930:	e44e                	sd	s3,8(sp)
ffffffffc0203932:	8a2a                	mv	s4,a0
ffffffffc0203934:	84ae                	mv	s1,a1
ffffffffc0203936:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203938:	100027f3          	csrr	a5,sstatus
ffffffffc020393c:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc020393e:	000bc997          	auipc	s3,0xbc
ffffffffc0203942:	7f298993          	addi	s3,s3,2034 # ffffffffc02c0130 <pmm_manager>
ffffffffc0203946:	ef8d                	bnez	a5,ffffffffc0203980 <pgdir_alloc_page+0x5c>
ffffffffc0203948:	0009b783          	ld	a5,0(s3)
ffffffffc020394c:	4505                	li	a0,1
ffffffffc020394e:	6f9c                	ld	a5,24(a5)
ffffffffc0203950:	9782                	jalr	a5
ffffffffc0203952:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203954:	cc09                	beqz	s0,ffffffffc020396e <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203956:	86ca                	mv	a3,s2
ffffffffc0203958:	8626                	mv	a2,s1
ffffffffc020395a:	85a2                	mv	a1,s0
ffffffffc020395c:	8552                	mv	a0,s4
ffffffffc020395e:	8a6ff0ef          	jal	ra,ffffffffc0202a04 <page_insert>
ffffffffc0203962:	e915                	bnez	a0,ffffffffc0203996 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203964:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203966:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203968:	4785                	li	a5,1
ffffffffc020396a:	04f71e63          	bne	a4,a5,ffffffffc02039c6 <pgdir_alloc_page+0xa2>
}
ffffffffc020396e:	70a2                	ld	ra,40(sp)
ffffffffc0203970:	8522                	mv	a0,s0
ffffffffc0203972:	7402                	ld	s0,32(sp)
ffffffffc0203974:	64e2                	ld	s1,24(sp)
ffffffffc0203976:	6942                	ld	s2,16(sp)
ffffffffc0203978:	69a2                	ld	s3,8(sp)
ffffffffc020397a:	6a02                	ld	s4,0(sp)
ffffffffc020397c:	6145                	addi	sp,sp,48
ffffffffc020397e:	8082                	ret
        intr_disable();
ffffffffc0203980:	834fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203984:	0009b783          	ld	a5,0(s3)
ffffffffc0203988:	4505                	li	a0,1
ffffffffc020398a:	6f9c                	ld	a5,24(a5)
ffffffffc020398c:	9782                	jalr	a5
ffffffffc020398e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203990:	81efd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203994:	b7c1                	j	ffffffffc0203954 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203996:	100027f3          	csrr	a5,sstatus
ffffffffc020399a:	8b89                	andi	a5,a5,2
ffffffffc020399c:	eb89                	bnez	a5,ffffffffc02039ae <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc020399e:	0009b783          	ld	a5,0(s3)
ffffffffc02039a2:	8522                	mv	a0,s0
ffffffffc02039a4:	4585                	li	a1,1
ffffffffc02039a6:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc02039a8:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02039aa:	9782                	jalr	a5
    if (flag)
ffffffffc02039ac:	b7c9                	j	ffffffffc020396e <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc02039ae:	806fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02039b2:	0009b783          	ld	a5,0(s3)
ffffffffc02039b6:	8522                	mv	a0,s0
ffffffffc02039b8:	4585                	li	a1,1
ffffffffc02039ba:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc02039bc:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02039be:	9782                	jalr	a5
        intr_enable();
ffffffffc02039c0:	feffc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02039c4:	b76d                	j	ffffffffc020396e <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc02039c6:	00004697          	auipc	a3,0x4
ffffffffc02039ca:	89a68693          	addi	a3,a3,-1894 # ffffffffc0207260 <default_pmm_manager+0x740>
ffffffffc02039ce:	00003617          	auipc	a2,0x3
ffffffffc02039d2:	da260613          	addi	a2,a2,-606 # ffffffffc0206770 <commands+0xb18>
ffffffffc02039d6:	1ef00593          	li	a1,495
ffffffffc02039da:	00003517          	auipc	a0,0x3
ffffffffc02039de:	23e50513          	addi	a0,a0,574 # ffffffffc0206c18 <default_pmm_manager+0xf8>
ffffffffc02039e2:	aadfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02039e6 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02039e6:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02039e8:	00004697          	auipc	a3,0x4
ffffffffc02039ec:	89068693          	addi	a3,a3,-1904 # ffffffffc0207278 <default_pmm_manager+0x758>
ffffffffc02039f0:	00003617          	auipc	a2,0x3
ffffffffc02039f4:	d8060613          	addi	a2,a2,-640 # ffffffffc0206770 <commands+0xb18>
ffffffffc02039f8:	07400593          	li	a1,116
ffffffffc02039fc:	00004517          	auipc	a0,0x4
ffffffffc0203a00:	89c50513          	addi	a0,a0,-1892 # ffffffffc0207298 <default_pmm_manager+0x778>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203a04:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0203a06:	a89fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a0a <mm_create>:
{
ffffffffc0203a0a:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a0c:	04000513          	li	a0,64
{
ffffffffc0203a10:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a12:	e6cfe0ef          	jal	ra,ffffffffc020207e <kmalloc>
    if (mm != NULL)
ffffffffc0203a16:	cd19                	beqz	a0,ffffffffc0203a34 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc0203a18:	e508                	sd	a0,8(a0)
ffffffffc0203a1a:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203a1c:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203a20:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203a24:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203a28:	02053423          	sd	zero,40(a0)
    mm->mm_count = val;
ffffffffc0203a2c:	02052823          	sw	zero,48(a0)
    *lock = 0;
ffffffffc0203a30:	02053c23          	sd	zero,56(a0)
}
ffffffffc0203a34:	60a2                	ld	ra,8(sp)
ffffffffc0203a36:	0141                	addi	sp,sp,16
ffffffffc0203a38:	8082                	ret

ffffffffc0203a3a <find_vma>:
{
ffffffffc0203a3a:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0203a3c:	c505                	beqz	a0,ffffffffc0203a64 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203a3e:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203a40:	c501                	beqz	a0,ffffffffc0203a48 <find_vma+0xe>
ffffffffc0203a42:	651c                	ld	a5,8(a0)
ffffffffc0203a44:	02f5f263          	bgeu	a1,a5,ffffffffc0203a68 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203a48:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203a4a:	00f68d63          	beq	a3,a5,ffffffffc0203a64 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203a4e:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_dirtycow_test_out_size+0x1f4dc8>
ffffffffc0203a52:	00e5e663          	bltu	a1,a4,ffffffffc0203a5e <find_vma+0x24>
ffffffffc0203a56:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203a5a:	00e5ec63          	bltu	a1,a4,ffffffffc0203a72 <find_vma+0x38>
ffffffffc0203a5e:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203a60:	fef697e3          	bne	a3,a5,ffffffffc0203a4e <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203a64:	4501                	li	a0,0
}
ffffffffc0203a66:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203a68:	691c                	ld	a5,16(a0)
ffffffffc0203a6a:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203a48 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203a6e:	ea88                	sd	a0,16(a3)
ffffffffc0203a70:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203a72:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203a76:	ea88                	sd	a0,16(a3)
ffffffffc0203a78:	8082                	ret

ffffffffc0203a7a <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203a7a:	6590                	ld	a2,8(a1)
ffffffffc0203a7c:	0105b803          	ld	a6,16(a1)
{
ffffffffc0203a80:	1141                	addi	sp,sp,-16
ffffffffc0203a82:	e406                	sd	ra,8(sp)
ffffffffc0203a84:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203a86:	01066763          	bltu	a2,a6,ffffffffc0203a94 <insert_vma_struct+0x1a>
ffffffffc0203a8a:	a085                	j	ffffffffc0203aea <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203a8c:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203a90:	04e66863          	bltu	a2,a4,ffffffffc0203ae0 <insert_vma_struct+0x66>
ffffffffc0203a94:	86be                	mv	a3,a5
ffffffffc0203a96:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203a98:	fef51ae3          	bne	a0,a5,ffffffffc0203a8c <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203a9c:	02a68463          	beq	a3,a0,ffffffffc0203ac4 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203aa0:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203aa4:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203aa8:	08e8f163          	bgeu	a7,a4,ffffffffc0203b2a <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203aac:	04e66f63          	bltu	a2,a4,ffffffffc0203b0a <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203ab0:	00f50a63          	beq	a0,a5,ffffffffc0203ac4 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203ab4:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203ab8:	05076963          	bltu	a4,a6,ffffffffc0203b0a <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203abc:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203ac0:	02c77363          	bgeu	a4,a2,ffffffffc0203ae6 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203ac4:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203ac6:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203ac8:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203acc:	e390                	sd	a2,0(a5)
ffffffffc0203ace:	e690                	sd	a2,8(a3)
}
ffffffffc0203ad0:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203ad2:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203ad4:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203ad6:	0017079b          	addiw	a5,a4,1
ffffffffc0203ada:	d11c                	sw	a5,32(a0)
}
ffffffffc0203adc:	0141                	addi	sp,sp,16
ffffffffc0203ade:	8082                	ret
    if (le_prev != list)
ffffffffc0203ae0:	fca690e3          	bne	a3,a0,ffffffffc0203aa0 <insert_vma_struct+0x26>
ffffffffc0203ae4:	bfd1                	j	ffffffffc0203ab8 <insert_vma_struct+0x3e>
ffffffffc0203ae6:	f01ff0ef          	jal	ra,ffffffffc02039e6 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203aea:	00003697          	auipc	a3,0x3
ffffffffc0203aee:	7be68693          	addi	a3,a3,1982 # ffffffffc02072a8 <default_pmm_manager+0x788>
ffffffffc0203af2:	00003617          	auipc	a2,0x3
ffffffffc0203af6:	c7e60613          	addi	a2,a2,-898 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203afa:	07a00593          	li	a1,122
ffffffffc0203afe:	00003517          	auipc	a0,0x3
ffffffffc0203b02:	79a50513          	addi	a0,a0,1946 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203b06:	989fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203b0a:	00003697          	auipc	a3,0x3
ffffffffc0203b0e:	7de68693          	addi	a3,a3,2014 # ffffffffc02072e8 <default_pmm_manager+0x7c8>
ffffffffc0203b12:	00003617          	auipc	a2,0x3
ffffffffc0203b16:	c5e60613          	addi	a2,a2,-930 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203b1a:	07300593          	li	a1,115
ffffffffc0203b1e:	00003517          	auipc	a0,0x3
ffffffffc0203b22:	77a50513          	addi	a0,a0,1914 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203b26:	969fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203b2a:	00003697          	auipc	a3,0x3
ffffffffc0203b2e:	79e68693          	addi	a3,a3,1950 # ffffffffc02072c8 <default_pmm_manager+0x7a8>
ffffffffc0203b32:	00003617          	auipc	a2,0x3
ffffffffc0203b36:	c3e60613          	addi	a2,a2,-962 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203b3a:	07200593          	li	a1,114
ffffffffc0203b3e:	00003517          	auipc	a0,0x3
ffffffffc0203b42:	75a50513          	addi	a0,a0,1882 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203b46:	949fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203b4a <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203b4a:	591c                	lw	a5,48(a0)
{
ffffffffc0203b4c:	1141                	addi	sp,sp,-16
ffffffffc0203b4e:	e406                	sd	ra,8(sp)
ffffffffc0203b50:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203b52:	e78d                	bnez	a5,ffffffffc0203b7c <mm_destroy+0x32>
ffffffffc0203b54:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203b56:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203b58:	00a40c63          	beq	s0,a0,ffffffffc0203b70 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203b5c:	6118                	ld	a4,0(a0)
ffffffffc0203b5e:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203b60:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203b62:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203b64:	e398                	sd	a4,0(a5)
ffffffffc0203b66:	dc8fe0ef          	jal	ra,ffffffffc020212e <kfree>
    return listelm->next;
ffffffffc0203b6a:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203b6c:	fea418e3          	bne	s0,a0,ffffffffc0203b5c <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203b70:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203b72:	6402                	ld	s0,0(sp)
ffffffffc0203b74:	60a2                	ld	ra,8(sp)
ffffffffc0203b76:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203b78:	db6fe06f          	j	ffffffffc020212e <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203b7c:	00003697          	auipc	a3,0x3
ffffffffc0203b80:	78c68693          	addi	a3,a3,1932 # ffffffffc0207308 <default_pmm_manager+0x7e8>
ffffffffc0203b84:	00003617          	auipc	a2,0x3
ffffffffc0203b88:	bec60613          	addi	a2,a2,-1044 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203b8c:	09e00593          	li	a1,158
ffffffffc0203b90:	00003517          	auipc	a0,0x3
ffffffffc0203b94:	70850513          	addi	a0,a0,1800 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203b98:	8f7fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203b9c <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203b9c:	7139                	addi	sp,sp,-64
ffffffffc0203b9e:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203ba0:	6405                	lui	s0,0x1
ffffffffc0203ba2:	147d                	addi	s0,s0,-1
ffffffffc0203ba4:	77fd                	lui	a5,0xfffff
ffffffffc0203ba6:	9622                	add	a2,a2,s0
ffffffffc0203ba8:	962e                	add	a2,a2,a1
{
ffffffffc0203baa:	f426                	sd	s1,40(sp)
ffffffffc0203bac:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203bae:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203bb2:	f04a                	sd	s2,32(sp)
ffffffffc0203bb4:	ec4e                	sd	s3,24(sp)
ffffffffc0203bb6:	e852                	sd	s4,16(sp)
ffffffffc0203bb8:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203bba:	002005b7          	lui	a1,0x200
ffffffffc0203bbe:	00f67433          	and	s0,a2,a5
ffffffffc0203bc2:	06b4e363          	bltu	s1,a1,ffffffffc0203c28 <mm_map+0x8c>
ffffffffc0203bc6:	0684f163          	bgeu	s1,s0,ffffffffc0203c28 <mm_map+0x8c>
ffffffffc0203bca:	4785                	li	a5,1
ffffffffc0203bcc:	07fe                	slli	a5,a5,0x1f
ffffffffc0203bce:	0487ed63          	bltu	a5,s0,ffffffffc0203c28 <mm_map+0x8c>
ffffffffc0203bd2:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203bd4:	cd21                	beqz	a0,ffffffffc0203c2c <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203bd6:	85a6                	mv	a1,s1
ffffffffc0203bd8:	8ab6                	mv	s5,a3
ffffffffc0203bda:	8a3a                	mv	s4,a4
ffffffffc0203bdc:	e5fff0ef          	jal	ra,ffffffffc0203a3a <find_vma>
ffffffffc0203be0:	c501                	beqz	a0,ffffffffc0203be8 <mm_map+0x4c>
ffffffffc0203be2:	651c                	ld	a5,8(a0)
ffffffffc0203be4:	0487e263          	bltu	a5,s0,ffffffffc0203c28 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203be8:	03000513          	li	a0,48
ffffffffc0203bec:	c92fe0ef          	jal	ra,ffffffffc020207e <kmalloc>
ffffffffc0203bf0:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203bf2:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203bf4:	02090163          	beqz	s2,ffffffffc0203c16 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203bf8:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0203bfa:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0203bfe:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0203c02:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0203c06:	85ca                	mv	a1,s2
ffffffffc0203c08:	e73ff0ef          	jal	ra,ffffffffc0203a7a <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0203c0c:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0203c0e:	000a0463          	beqz	s4,ffffffffc0203c16 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0203c12:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>

out:
    return ret;
}
ffffffffc0203c16:	70e2                	ld	ra,56(sp)
ffffffffc0203c18:	7442                	ld	s0,48(sp)
ffffffffc0203c1a:	74a2                	ld	s1,40(sp)
ffffffffc0203c1c:	7902                	ld	s2,32(sp)
ffffffffc0203c1e:	69e2                	ld	s3,24(sp)
ffffffffc0203c20:	6a42                	ld	s4,16(sp)
ffffffffc0203c22:	6aa2                	ld	s5,8(sp)
ffffffffc0203c24:	6121                	addi	sp,sp,64
ffffffffc0203c26:	8082                	ret
        return -E_INVAL;
ffffffffc0203c28:	5575                	li	a0,-3
ffffffffc0203c2a:	b7f5                	j	ffffffffc0203c16 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0203c2c:	00003697          	auipc	a3,0x3
ffffffffc0203c30:	6f468693          	addi	a3,a3,1780 # ffffffffc0207320 <default_pmm_manager+0x800>
ffffffffc0203c34:	00003617          	auipc	a2,0x3
ffffffffc0203c38:	b3c60613          	addi	a2,a2,-1220 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203c3c:	0b300593          	li	a1,179
ffffffffc0203c40:	00003517          	auipc	a0,0x3
ffffffffc0203c44:	65850513          	addi	a0,a0,1624 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203c48:	847fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203c4c <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203c4c:	7139                	addi	sp,sp,-64
ffffffffc0203c4e:	fc06                	sd	ra,56(sp)
ffffffffc0203c50:	f822                	sd	s0,48(sp)
ffffffffc0203c52:	f426                	sd	s1,40(sp)
ffffffffc0203c54:	f04a                	sd	s2,32(sp)
ffffffffc0203c56:	ec4e                	sd	s3,24(sp)
ffffffffc0203c58:	e852                	sd	s4,16(sp)
ffffffffc0203c5a:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203c5c:	c52d                	beqz	a0,ffffffffc0203cc6 <dup_mmap+0x7a>
ffffffffc0203c5e:	892a                	mv	s2,a0
ffffffffc0203c60:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203c62:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203c64:	e595                	bnez	a1,ffffffffc0203c90 <dup_mmap+0x44>
ffffffffc0203c66:	a085                	j	ffffffffc0203cc6 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203c68:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203c6a:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_dirtycow_test_out_size+0x1f4de8>
        vma->vm_end = vm_end;
ffffffffc0203c6e:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203c72:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203c76:	e05ff0ef          	jal	ra,ffffffffc0203a7a <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203c7a:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bc0>
ffffffffc0203c7e:	fe843603          	ld	a2,-24(s0)
ffffffffc0203c82:	6c8c                	ld	a1,24(s1)
ffffffffc0203c84:	01893503          	ld	a0,24(s2)
ffffffffc0203c88:	4701                	li	a4,0
ffffffffc0203c8a:	ab1ff0ef          	jal	ra,ffffffffc020373a <copy_range>
ffffffffc0203c8e:	e105                	bnez	a0,ffffffffc0203cae <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203c90:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203c92:	02848863          	beq	s1,s0,ffffffffc0203cc2 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203c96:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203c9a:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203c9e:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203ca2:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ca6:	bd8fe0ef          	jal	ra,ffffffffc020207e <kmalloc>
ffffffffc0203caa:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203cac:	fd55                	bnez	a0,ffffffffc0203c68 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203cae:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203cb0:	70e2                	ld	ra,56(sp)
ffffffffc0203cb2:	7442                	ld	s0,48(sp)
ffffffffc0203cb4:	74a2                	ld	s1,40(sp)
ffffffffc0203cb6:	7902                	ld	s2,32(sp)
ffffffffc0203cb8:	69e2                	ld	s3,24(sp)
ffffffffc0203cba:	6a42                	ld	s4,16(sp)
ffffffffc0203cbc:	6aa2                	ld	s5,8(sp)
ffffffffc0203cbe:	6121                	addi	sp,sp,64
ffffffffc0203cc0:	8082                	ret
    return 0;
ffffffffc0203cc2:	4501                	li	a0,0
ffffffffc0203cc4:	b7f5                	j	ffffffffc0203cb0 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203cc6:	00003697          	auipc	a3,0x3
ffffffffc0203cca:	66a68693          	addi	a3,a3,1642 # ffffffffc0207330 <default_pmm_manager+0x810>
ffffffffc0203cce:	00003617          	auipc	a2,0x3
ffffffffc0203cd2:	aa260613          	addi	a2,a2,-1374 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203cd6:	0cf00593          	li	a1,207
ffffffffc0203cda:	00003517          	auipc	a0,0x3
ffffffffc0203cde:	5be50513          	addi	a0,a0,1470 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203ce2:	facfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203ce6 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203ce6:	1101                	addi	sp,sp,-32
ffffffffc0203ce8:	ec06                	sd	ra,24(sp)
ffffffffc0203cea:	e822                	sd	s0,16(sp)
ffffffffc0203cec:	e426                	sd	s1,8(sp)
ffffffffc0203cee:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203cf0:	c531                	beqz	a0,ffffffffc0203d3c <exit_mmap+0x56>
ffffffffc0203cf2:	591c                	lw	a5,48(a0)
ffffffffc0203cf4:	84aa                	mv	s1,a0
ffffffffc0203cf6:	e3b9                	bnez	a5,ffffffffc0203d3c <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203cf8:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203cfa:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203cfe:	02850663          	beq	a0,s0,ffffffffc0203d2a <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203d02:	ff043603          	ld	a2,-16(s0)
ffffffffc0203d06:	fe843583          	ld	a1,-24(s0)
ffffffffc0203d0a:	854a                	mv	a0,s2
ffffffffc0203d0c:	885fe0ef          	jal	ra,ffffffffc0202590 <unmap_range>
ffffffffc0203d10:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203d12:	fe8498e3          	bne	s1,s0,ffffffffc0203d02 <exit_mmap+0x1c>
ffffffffc0203d16:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203d18:	00848c63          	beq	s1,s0,ffffffffc0203d30 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203d1c:	ff043603          	ld	a2,-16(s0)
ffffffffc0203d20:	fe843583          	ld	a1,-24(s0)
ffffffffc0203d24:	854a                	mv	a0,s2
ffffffffc0203d26:	9b1fe0ef          	jal	ra,ffffffffc02026d6 <exit_range>
ffffffffc0203d2a:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203d2c:	fe8498e3          	bne	s1,s0,ffffffffc0203d1c <exit_mmap+0x36>
    }
}
ffffffffc0203d30:	60e2                	ld	ra,24(sp)
ffffffffc0203d32:	6442                	ld	s0,16(sp)
ffffffffc0203d34:	64a2                	ld	s1,8(sp)
ffffffffc0203d36:	6902                	ld	s2,0(sp)
ffffffffc0203d38:	6105                	addi	sp,sp,32
ffffffffc0203d3a:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203d3c:	00003697          	auipc	a3,0x3
ffffffffc0203d40:	61468693          	addi	a3,a3,1556 # ffffffffc0207350 <default_pmm_manager+0x830>
ffffffffc0203d44:	00003617          	auipc	a2,0x3
ffffffffc0203d48:	a2c60613          	addi	a2,a2,-1492 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203d4c:	0e800593          	li	a1,232
ffffffffc0203d50:	00003517          	auipc	a0,0x3
ffffffffc0203d54:	54850513          	addi	a0,a0,1352 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203d58:	f36fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203d5c <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203d5c:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203d5e:	04000513          	li	a0,64
{
ffffffffc0203d62:	fc06                	sd	ra,56(sp)
ffffffffc0203d64:	f822                	sd	s0,48(sp)
ffffffffc0203d66:	f426                	sd	s1,40(sp)
ffffffffc0203d68:	f04a                	sd	s2,32(sp)
ffffffffc0203d6a:	ec4e                	sd	s3,24(sp)
ffffffffc0203d6c:	e852                	sd	s4,16(sp)
ffffffffc0203d6e:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203d70:	b0efe0ef          	jal	ra,ffffffffc020207e <kmalloc>
    if (mm != NULL)
ffffffffc0203d74:	2e050663          	beqz	a0,ffffffffc0204060 <vmm_init+0x304>
ffffffffc0203d78:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203d7a:	e508                	sd	a0,8(a0)
ffffffffc0203d7c:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203d7e:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203d82:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203d86:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203d8a:	02053423          	sd	zero,40(a0)
ffffffffc0203d8e:	02052823          	sw	zero,48(a0)
ffffffffc0203d92:	02053c23          	sd	zero,56(a0)
ffffffffc0203d96:	03200413          	li	s0,50
ffffffffc0203d9a:	a811                	j	ffffffffc0203dae <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203d9c:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203d9e:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203da0:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203da4:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203da6:	8526                	mv	a0,s1
ffffffffc0203da8:	cd3ff0ef          	jal	ra,ffffffffc0203a7a <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203dac:	c80d                	beqz	s0,ffffffffc0203dde <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203dae:	03000513          	li	a0,48
ffffffffc0203db2:	accfe0ef          	jal	ra,ffffffffc020207e <kmalloc>
ffffffffc0203db6:	85aa                	mv	a1,a0
ffffffffc0203db8:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203dbc:	f165                	bnez	a0,ffffffffc0203d9c <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203dbe:	00003697          	auipc	a3,0x3
ffffffffc0203dc2:	72a68693          	addi	a3,a3,1834 # ffffffffc02074e8 <default_pmm_manager+0x9c8>
ffffffffc0203dc6:	00003617          	auipc	a2,0x3
ffffffffc0203dca:	9aa60613          	addi	a2,a2,-1622 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203dce:	12c00593          	li	a1,300
ffffffffc0203dd2:	00003517          	auipc	a0,0x3
ffffffffc0203dd6:	4c650513          	addi	a0,a0,1222 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203dda:	eb4fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203dde:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203de2:	1f900913          	li	s2,505
ffffffffc0203de6:	a819                	j	ffffffffc0203dfc <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203de8:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203dea:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203dec:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203df0:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203df2:	8526                	mv	a0,s1
ffffffffc0203df4:	c87ff0ef          	jal	ra,ffffffffc0203a7a <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203df8:	03240a63          	beq	s0,s2,ffffffffc0203e2c <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203dfc:	03000513          	li	a0,48
ffffffffc0203e00:	a7efe0ef          	jal	ra,ffffffffc020207e <kmalloc>
ffffffffc0203e04:	85aa                	mv	a1,a0
ffffffffc0203e06:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203e0a:	fd79                	bnez	a0,ffffffffc0203de8 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203e0c:	00003697          	auipc	a3,0x3
ffffffffc0203e10:	6dc68693          	addi	a3,a3,1756 # ffffffffc02074e8 <default_pmm_manager+0x9c8>
ffffffffc0203e14:	00003617          	auipc	a2,0x3
ffffffffc0203e18:	95c60613          	addi	a2,a2,-1700 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203e1c:	13300593          	li	a1,307
ffffffffc0203e20:	00003517          	auipc	a0,0x3
ffffffffc0203e24:	47850513          	addi	a0,a0,1144 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203e28:	e66fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203e2c:	649c                	ld	a5,8(s1)
ffffffffc0203e2e:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203e30:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203e34:	16f48663          	beq	s1,a5,ffffffffc0203fa0 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203e38:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd3ee8c>
ffffffffc0203e3c:	ffe70693          	addi	a3,a4,-2 # ffffffffffdffffe <end+0x3fb3fea2>
ffffffffc0203e40:	10d61063          	bne	a2,a3,ffffffffc0203f40 <vmm_init+0x1e4>
ffffffffc0203e44:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203e48:	0ed71c63          	bne	a4,a3,ffffffffc0203f40 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203e4c:	0715                	addi	a4,a4,5
ffffffffc0203e4e:	679c                	ld	a5,8(a5)
ffffffffc0203e50:	feb712e3          	bne	a4,a1,ffffffffc0203e34 <vmm_init+0xd8>
ffffffffc0203e54:	4a1d                	li	s4,7
ffffffffc0203e56:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203e58:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203e5c:	85a2                	mv	a1,s0
ffffffffc0203e5e:	8526                	mv	a0,s1
ffffffffc0203e60:	bdbff0ef          	jal	ra,ffffffffc0203a3a <find_vma>
ffffffffc0203e64:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203e66:	16050d63          	beqz	a0,ffffffffc0203fe0 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203e6a:	00140593          	addi	a1,s0,1
ffffffffc0203e6e:	8526                	mv	a0,s1
ffffffffc0203e70:	bcbff0ef          	jal	ra,ffffffffc0203a3a <find_vma>
ffffffffc0203e74:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203e76:	14050563          	beqz	a0,ffffffffc0203fc0 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203e7a:	85d2                	mv	a1,s4
ffffffffc0203e7c:	8526                	mv	a0,s1
ffffffffc0203e7e:	bbdff0ef          	jal	ra,ffffffffc0203a3a <find_vma>
        assert(vma3 == NULL);
ffffffffc0203e82:	16051f63          	bnez	a0,ffffffffc0204000 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203e86:	00340593          	addi	a1,s0,3
ffffffffc0203e8a:	8526                	mv	a0,s1
ffffffffc0203e8c:	bafff0ef          	jal	ra,ffffffffc0203a3a <find_vma>
        assert(vma4 == NULL);
ffffffffc0203e90:	1a051863          	bnez	a0,ffffffffc0204040 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203e94:	00440593          	addi	a1,s0,4
ffffffffc0203e98:	8526                	mv	a0,s1
ffffffffc0203e9a:	ba1ff0ef          	jal	ra,ffffffffc0203a3a <find_vma>
        assert(vma5 == NULL);
ffffffffc0203e9e:	18051163          	bnez	a0,ffffffffc0204020 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203ea2:	00893783          	ld	a5,8(s2)
ffffffffc0203ea6:	0a879d63          	bne	a5,s0,ffffffffc0203f60 <vmm_init+0x204>
ffffffffc0203eaa:	01093783          	ld	a5,16(s2)
ffffffffc0203eae:	0b479963          	bne	a5,s4,ffffffffc0203f60 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203eb2:	0089b783          	ld	a5,8(s3)
ffffffffc0203eb6:	0c879563          	bne	a5,s0,ffffffffc0203f80 <vmm_init+0x224>
ffffffffc0203eba:	0109b783          	ld	a5,16(s3)
ffffffffc0203ebe:	0d479163          	bne	a5,s4,ffffffffc0203f80 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203ec2:	0415                	addi	s0,s0,5
ffffffffc0203ec4:	0a15                	addi	s4,s4,5
ffffffffc0203ec6:	f9541be3          	bne	s0,s5,ffffffffc0203e5c <vmm_init+0x100>
ffffffffc0203eca:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203ecc:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203ece:	85a2                	mv	a1,s0
ffffffffc0203ed0:	8526                	mv	a0,s1
ffffffffc0203ed2:	b69ff0ef          	jal	ra,ffffffffc0203a3a <find_vma>
ffffffffc0203ed6:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203eda:	c90d                	beqz	a0,ffffffffc0203f0c <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203edc:	6914                	ld	a3,16(a0)
ffffffffc0203ede:	6510                	ld	a2,8(a0)
ffffffffc0203ee0:	00003517          	auipc	a0,0x3
ffffffffc0203ee4:	59050513          	addi	a0,a0,1424 # ffffffffc0207470 <default_pmm_manager+0x950>
ffffffffc0203ee8:	aacfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203eec:	00003697          	auipc	a3,0x3
ffffffffc0203ef0:	5ac68693          	addi	a3,a3,1452 # ffffffffc0207498 <default_pmm_manager+0x978>
ffffffffc0203ef4:	00003617          	auipc	a2,0x3
ffffffffc0203ef8:	87c60613          	addi	a2,a2,-1924 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203efc:	15900593          	li	a1,345
ffffffffc0203f00:	00003517          	auipc	a0,0x3
ffffffffc0203f04:	39850513          	addi	a0,a0,920 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203f08:	d86fc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203f0c:	147d                	addi	s0,s0,-1
ffffffffc0203f0e:	fd2410e3          	bne	s0,s2,ffffffffc0203ece <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203f12:	8526                	mv	a0,s1
ffffffffc0203f14:	c37ff0ef          	jal	ra,ffffffffc0203b4a <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203f18:	00003517          	auipc	a0,0x3
ffffffffc0203f1c:	59850513          	addi	a0,a0,1432 # ffffffffc02074b0 <default_pmm_manager+0x990>
ffffffffc0203f20:	a74fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203f24:	7442                	ld	s0,48(sp)
ffffffffc0203f26:	70e2                	ld	ra,56(sp)
ffffffffc0203f28:	74a2                	ld	s1,40(sp)
ffffffffc0203f2a:	7902                	ld	s2,32(sp)
ffffffffc0203f2c:	69e2                	ld	s3,24(sp)
ffffffffc0203f2e:	6a42                	ld	s4,16(sp)
ffffffffc0203f30:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203f32:	00003517          	auipc	a0,0x3
ffffffffc0203f36:	59e50513          	addi	a0,a0,1438 # ffffffffc02074d0 <default_pmm_manager+0x9b0>
}
ffffffffc0203f3a:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203f3c:	a58fc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203f40:	00003697          	auipc	a3,0x3
ffffffffc0203f44:	44868693          	addi	a3,a3,1096 # ffffffffc0207388 <default_pmm_manager+0x868>
ffffffffc0203f48:	00003617          	auipc	a2,0x3
ffffffffc0203f4c:	82860613          	addi	a2,a2,-2008 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203f50:	13d00593          	li	a1,317
ffffffffc0203f54:	00003517          	auipc	a0,0x3
ffffffffc0203f58:	34450513          	addi	a0,a0,836 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203f5c:	d32fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203f60:	00003697          	auipc	a3,0x3
ffffffffc0203f64:	4b068693          	addi	a3,a3,1200 # ffffffffc0207410 <default_pmm_manager+0x8f0>
ffffffffc0203f68:	00003617          	auipc	a2,0x3
ffffffffc0203f6c:	80860613          	addi	a2,a2,-2040 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203f70:	14e00593          	li	a1,334
ffffffffc0203f74:	00003517          	auipc	a0,0x3
ffffffffc0203f78:	32450513          	addi	a0,a0,804 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203f7c:	d12fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203f80:	00003697          	auipc	a3,0x3
ffffffffc0203f84:	4c068693          	addi	a3,a3,1216 # ffffffffc0207440 <default_pmm_manager+0x920>
ffffffffc0203f88:	00002617          	auipc	a2,0x2
ffffffffc0203f8c:	7e860613          	addi	a2,a2,2024 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203f90:	14f00593          	li	a1,335
ffffffffc0203f94:	00003517          	auipc	a0,0x3
ffffffffc0203f98:	30450513          	addi	a0,a0,772 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203f9c:	cf2fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203fa0:	00003697          	auipc	a3,0x3
ffffffffc0203fa4:	3d068693          	addi	a3,a3,976 # ffffffffc0207370 <default_pmm_manager+0x850>
ffffffffc0203fa8:	00002617          	auipc	a2,0x2
ffffffffc0203fac:	7c860613          	addi	a2,a2,1992 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203fb0:	13b00593          	li	a1,315
ffffffffc0203fb4:	00003517          	auipc	a0,0x3
ffffffffc0203fb8:	2e450513          	addi	a0,a0,740 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203fbc:	cd2fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203fc0:	00003697          	auipc	a3,0x3
ffffffffc0203fc4:	41068693          	addi	a3,a3,1040 # ffffffffc02073d0 <default_pmm_manager+0x8b0>
ffffffffc0203fc8:	00002617          	auipc	a2,0x2
ffffffffc0203fcc:	7a860613          	addi	a2,a2,1960 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203fd0:	14600593          	li	a1,326
ffffffffc0203fd4:	00003517          	auipc	a0,0x3
ffffffffc0203fd8:	2c450513          	addi	a0,a0,708 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203fdc:	cb2fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203fe0:	00003697          	auipc	a3,0x3
ffffffffc0203fe4:	3e068693          	addi	a3,a3,992 # ffffffffc02073c0 <default_pmm_manager+0x8a0>
ffffffffc0203fe8:	00002617          	auipc	a2,0x2
ffffffffc0203fec:	78860613          	addi	a2,a2,1928 # ffffffffc0206770 <commands+0xb18>
ffffffffc0203ff0:	14400593          	li	a1,324
ffffffffc0203ff4:	00003517          	auipc	a0,0x3
ffffffffc0203ff8:	2a450513          	addi	a0,a0,676 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc0203ffc:	c92fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0204000:	00003697          	auipc	a3,0x3
ffffffffc0204004:	3e068693          	addi	a3,a3,992 # ffffffffc02073e0 <default_pmm_manager+0x8c0>
ffffffffc0204008:	00002617          	auipc	a2,0x2
ffffffffc020400c:	76860613          	addi	a2,a2,1896 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204010:	14800593          	li	a1,328
ffffffffc0204014:	00003517          	auipc	a0,0x3
ffffffffc0204018:	28450513          	addi	a0,a0,644 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc020401c:	c72fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0204020:	00003697          	auipc	a3,0x3
ffffffffc0204024:	3e068693          	addi	a3,a3,992 # ffffffffc0207400 <default_pmm_manager+0x8e0>
ffffffffc0204028:	00002617          	auipc	a2,0x2
ffffffffc020402c:	74860613          	addi	a2,a2,1864 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204030:	14c00593          	li	a1,332
ffffffffc0204034:	00003517          	auipc	a0,0x3
ffffffffc0204038:	26450513          	addi	a0,a0,612 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc020403c:	c52fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0204040:	00003697          	auipc	a3,0x3
ffffffffc0204044:	3b068693          	addi	a3,a3,944 # ffffffffc02073f0 <default_pmm_manager+0x8d0>
ffffffffc0204048:	00002617          	auipc	a2,0x2
ffffffffc020404c:	72860613          	addi	a2,a2,1832 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204050:	14a00593          	li	a1,330
ffffffffc0204054:	00003517          	auipc	a0,0x3
ffffffffc0204058:	24450513          	addi	a0,a0,580 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc020405c:	c32fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0204060:	00003697          	auipc	a3,0x3
ffffffffc0204064:	2c068693          	addi	a3,a3,704 # ffffffffc0207320 <default_pmm_manager+0x800>
ffffffffc0204068:	00002617          	auipc	a2,0x2
ffffffffc020406c:	70860613          	addi	a2,a2,1800 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204070:	12400593          	li	a1,292
ffffffffc0204074:	00003517          	auipc	a0,0x3
ffffffffc0204078:	22450513          	addi	a0,a0,548 # ffffffffc0207298 <default_pmm_manager+0x778>
ffffffffc020407c:	c12fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204080 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0204080:	7179                	addi	sp,sp,-48
ffffffffc0204082:	f022                	sd	s0,32(sp)
ffffffffc0204084:	f406                	sd	ra,40(sp)
ffffffffc0204086:	ec26                	sd	s1,24(sp)
ffffffffc0204088:	e84a                	sd	s2,16(sp)
ffffffffc020408a:	e44e                	sd	s3,8(sp)
ffffffffc020408c:	e052                	sd	s4,0(sp)
ffffffffc020408e:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0204090:	c135                	beqz	a0,ffffffffc02040f4 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0204092:	002007b7          	lui	a5,0x200
ffffffffc0204096:	04f5e663          	bltu	a1,a5,ffffffffc02040e2 <user_mem_check+0x62>
ffffffffc020409a:	00c584b3          	add	s1,a1,a2
ffffffffc020409e:	0495f263          	bgeu	a1,s1,ffffffffc02040e2 <user_mem_check+0x62>
ffffffffc02040a2:	4785                	li	a5,1
ffffffffc02040a4:	07fe                	slli	a5,a5,0x1f
ffffffffc02040a6:	0297ee63          	bltu	a5,s1,ffffffffc02040e2 <user_mem_check+0x62>
ffffffffc02040aa:	892a                	mv	s2,a0
ffffffffc02040ac:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc02040ae:	6a05                	lui	s4,0x1
ffffffffc02040b0:	a821                	j	ffffffffc02040c8 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02040b2:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc02040b6:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc02040b8:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02040ba:	c685                	beqz	a3,ffffffffc02040e2 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc02040bc:	c399                	beqz	a5,ffffffffc02040c2 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc02040be:	02e46263          	bltu	s0,a4,ffffffffc02040e2 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc02040c2:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc02040c4:	04947663          	bgeu	s0,s1,ffffffffc0204110 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc02040c8:	85a2                	mv	a1,s0
ffffffffc02040ca:	854a                	mv	a0,s2
ffffffffc02040cc:	96fff0ef          	jal	ra,ffffffffc0203a3a <find_vma>
ffffffffc02040d0:	c909                	beqz	a0,ffffffffc02040e2 <user_mem_check+0x62>
ffffffffc02040d2:	6518                	ld	a4,8(a0)
ffffffffc02040d4:	00e46763          	bltu	s0,a4,ffffffffc02040e2 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02040d8:	4d1c                	lw	a5,24(a0)
ffffffffc02040da:	fc099ce3          	bnez	s3,ffffffffc02040b2 <user_mem_check+0x32>
ffffffffc02040de:	8b85                	andi	a5,a5,1
ffffffffc02040e0:	f3ed                	bnez	a5,ffffffffc02040c2 <user_mem_check+0x42>
            return 0;
ffffffffc02040e2:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc02040e4:	70a2                	ld	ra,40(sp)
ffffffffc02040e6:	7402                	ld	s0,32(sp)
ffffffffc02040e8:	64e2                	ld	s1,24(sp)
ffffffffc02040ea:	6942                	ld	s2,16(sp)
ffffffffc02040ec:	69a2                	ld	s3,8(sp)
ffffffffc02040ee:	6a02                	ld	s4,0(sp)
ffffffffc02040f0:	6145                	addi	sp,sp,48
ffffffffc02040f2:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc02040f4:	c02007b7          	lui	a5,0xc0200
ffffffffc02040f8:	4501                	li	a0,0
ffffffffc02040fa:	fef5e5e3          	bltu	a1,a5,ffffffffc02040e4 <user_mem_check+0x64>
ffffffffc02040fe:	962e                	add	a2,a2,a1
ffffffffc0204100:	fec5f2e3          	bgeu	a1,a2,ffffffffc02040e4 <user_mem_check+0x64>
ffffffffc0204104:	c8000537          	lui	a0,0xc8000
ffffffffc0204108:	0505                	addi	a0,a0,1
ffffffffc020410a:	00a63533          	sltu	a0,a2,a0
ffffffffc020410e:	bfd9                	j	ffffffffc02040e4 <user_mem_check+0x64>
        return 1;
ffffffffc0204110:	4505                	li	a0,1
ffffffffc0204112:	bfc9                	j	ffffffffc02040e4 <user_mem_check+0x64>

ffffffffc0204114 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0204114:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204116:	9402                	jalr	s0

	jal do_exit
ffffffffc0204118:	5dc000ef          	jal	ra,ffffffffc02046f4 <do_exit>

ffffffffc020411c <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc020411c:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020411e:	10800513          	li	a0,264
{
ffffffffc0204122:	e022                	sd	s0,0(sp)
ffffffffc0204124:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204126:	f59fd0ef          	jal	ra,ffffffffc020207e <kmalloc>
ffffffffc020412a:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc020412c:	cd21                	beqz	a0,ffffffffc0204184 <alloc_proc+0x68>
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        // 你的Lab4代码将放在这里
        proc->state = PROC_UNINIT;          // 初始状态为未初始化
ffffffffc020412e:	57fd                	li	a5,-1
ffffffffc0204130:	1782                	slli	a5,a5,0x20
ffffffffc0204132:	e11c                	sd	a5,0(a0)
        proc->runs = 0;                     // 运行次数初始为0
        proc->kstack = 0;                   // 内核栈地址暂设为0（后续setup_kstack分配）
        proc->need_resched = 0;             // 初始不需要调度（ucore用0表示false，修复编译报错）
        proc->parent = NULL;                // 父进程初始为NULL
        proc->mm = NULL;                    // 内核线程无独立内存管理结构，设为NULL
        memset(&proc->context, 0, sizeof(struct context));  // 上下文清零
ffffffffc0204134:	07000613          	li	a2,112
ffffffffc0204138:	4581                	li	a1,0
        proc->runs = 0;                     // 运行次数初始为0
ffffffffc020413a:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d3feac>
        proc->kstack = 0;                   // 内核栈地址暂设为0（后续setup_kstack分配）
ffffffffc020413e:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;             // 初始不需要调度（ucore用0表示false，修复编译报错）
ffffffffc0204142:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;                // 父进程初始为NULL
ffffffffc0204146:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;                    // 内核线程无独立内存管理结构，设为NULL
ffffffffc020414a:	02053423          	sd	zero,40(a0)
        memset(&proc->context, 0, sizeof(struct context));  // 上下文清零
ffffffffc020414e:	03050513          	addi	a0,a0,48
ffffffffc0204152:	06f010ef          	jal	ra,ffffffffc02059c0 <memset>
        proc->tf = NULL;                    // 中断帧暂设为NULL（后续copy_thread构造）
        proc->pgdir = boot_pgdir_pa;        // 共享内核页表的物理地址（修复变量名错误，编译报错）
ffffffffc0204156:	000bc797          	auipc	a5,0xbc
ffffffffc020415a:	fba7b783          	ld	a5,-70(a5) # ffffffffc02c0110 <boot_pgdir_pa>
        proc->tf = NULL;                    // 中断帧暂设为NULL（后续copy_thread构造）
ffffffffc020415e:	0a043023          	sd	zero,160(s0)
        proc->pgdir = boot_pgdir_pa;        // 共享内核页表的物理地址（修复变量名错误，编译报错）
ffffffffc0204162:	f45c                	sd	a5,168(s0)
        proc->flags = 0;                    // 标志位初始为0
ffffffffc0204164:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);  // 进程名清零
ffffffffc0204168:	4641                	li	a2,16
ffffffffc020416a:	4581                	li	a1,0
ffffffffc020416c:	0b440513          	addi	a0,s0,180
ffffffffc0204170:	051010ef          	jal	ra,ffffffffc02059c0 <memset>
        
        // LAB5: 初始化新增字段
        proc->wait_state = 0;               // 等待状态初始化为0
ffffffffc0204174:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;                  // 子进程指针
ffffffffc0204178:	0e043823          	sd	zero,240(s0)
        proc->yptr = NULL;                  // 弟弟进程指针
ffffffffc020417c:	0e043c23          	sd	zero,248(s0)
        proc->optr = NULL;                  // 哥哥进程指针
ffffffffc0204180:	10043023          	sd	zero,256(s0)
        
        // Lab5部分保持原样，我不修改
    }
    return proc;
}
ffffffffc0204184:	60a2                	ld	ra,8(sp)
ffffffffc0204186:	8522                	mv	a0,s0
ffffffffc0204188:	6402                	ld	s0,0(sp)
ffffffffc020418a:	0141                	addi	sp,sp,16
ffffffffc020418c:	8082                	ret

ffffffffc020418e <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc020418e:	000bc797          	auipc	a5,0xbc
ffffffffc0204192:	fb27b783          	ld	a5,-78(a5) # ffffffffc02c0140 <current>
ffffffffc0204196:	73c8                	ld	a0,160(a5)
ffffffffc0204198:	95afd06f          	j	ffffffffc02012f2 <forkrets>

ffffffffc020419c <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020419c:	000bc797          	auipc	a5,0xbc
ffffffffc02041a0:	fa47b783          	ld	a5,-92(a5) # ffffffffc02c0140 <current>
ffffffffc02041a4:	43cc                	lw	a1,4(a5)
{
ffffffffc02041a6:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc02041a8:	00003617          	auipc	a2,0x3
ffffffffc02041ac:	35060613          	addi	a2,a2,848 # ffffffffc02074f8 <default_pmm_manager+0x9d8>
ffffffffc02041b0:	00003517          	auipc	a0,0x3
ffffffffc02041b4:	35850513          	addi	a0,a0,856 # ffffffffc0207508 <default_pmm_manager+0x9e8>
{
ffffffffc02041b8:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc02041ba:	fdbfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02041be:	3fe07797          	auipc	a5,0x3fe07
ffffffffc02041c2:	06278793          	addi	a5,a5,98 # b220 <_binary_obj___user_dirtycow_test_out_size>
ffffffffc02041c6:	e43e                	sd	a5,8(sp)
ffffffffc02041c8:	00003517          	auipc	a0,0x3
ffffffffc02041cc:	33050513          	addi	a0,a0,816 # ffffffffc02074f8 <default_pmm_manager+0x9d8>
ffffffffc02041d0:	00026797          	auipc	a5,0x26
ffffffffc02041d4:	53878793          	addi	a5,a5,1336 # ffffffffc022a708 <_binary_obj___user_dirtycow_test_out_start>
ffffffffc02041d8:	f03e                	sd	a5,32(sp)
ffffffffc02041da:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc02041dc:	e802                	sd	zero,16(sp)
ffffffffc02041de:	740010ef          	jal	ra,ffffffffc020591e <strlen>
ffffffffc02041e2:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc02041e4:	4511                	li	a0,4
ffffffffc02041e6:	55a2                	lw	a1,40(sp)
ffffffffc02041e8:	4662                	lw	a2,24(sp)
ffffffffc02041ea:	5682                	lw	a3,32(sp)
ffffffffc02041ec:	4722                	lw	a4,8(sp)
ffffffffc02041ee:	48a9                	li	a7,10
ffffffffc02041f0:	9002                	ebreak
ffffffffc02041f2:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc02041f4:	65c2                	ld	a1,16(sp)
ffffffffc02041f6:	00003517          	auipc	a0,0x3
ffffffffc02041fa:	33a50513          	addi	a0,a0,826 # ffffffffc0207530 <default_pmm_manager+0xa10>
ffffffffc02041fe:	f97fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0204202:	00003617          	auipc	a2,0x3
ffffffffc0204206:	33e60613          	addi	a2,a2,830 # ffffffffc0207540 <default_pmm_manager+0xa20>
ffffffffc020420a:	3cd00593          	li	a1,973
ffffffffc020420e:	00003517          	auipc	a0,0x3
ffffffffc0204212:	35250513          	addi	a0,a0,850 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204216:	a78fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020421a <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc020421a:	6d14                	ld	a3,24(a0)
{
ffffffffc020421c:	1141                	addi	sp,sp,-16
ffffffffc020421e:	e406                	sd	ra,8(sp)
ffffffffc0204220:	c02007b7          	lui	a5,0xc0200
ffffffffc0204224:	02f6ee63          	bltu	a3,a5,ffffffffc0204260 <put_pgdir+0x46>
ffffffffc0204228:	000bc517          	auipc	a0,0xbc
ffffffffc020422c:	f1053503          	ld	a0,-240(a0) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0204230:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0204232:	82b1                	srli	a3,a3,0xc
ffffffffc0204234:	000bc797          	auipc	a5,0xbc
ffffffffc0204238:	eec7b783          	ld	a5,-276(a5) # ffffffffc02c0120 <npage>
ffffffffc020423c:	02f6fe63          	bgeu	a3,a5,ffffffffc0204278 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0204240:	00004517          	auipc	a0,0x4
ffffffffc0204244:	b9053503          	ld	a0,-1136(a0) # ffffffffc0207dd0 <nbase>
}
ffffffffc0204248:	60a2                	ld	ra,8(sp)
ffffffffc020424a:	8e89                	sub	a3,a3,a0
ffffffffc020424c:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc020424e:	000bc517          	auipc	a0,0xbc
ffffffffc0204252:	eda53503          	ld	a0,-294(a0) # ffffffffc02c0128 <pages>
ffffffffc0204256:	4585                	li	a1,1
ffffffffc0204258:	9536                	add	a0,a0,a3
}
ffffffffc020425a:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc020425c:	83efe06f          	j	ffffffffc020229a <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204260:	00003617          	auipc	a2,0x3
ffffffffc0204264:	96860613          	addi	a2,a2,-1688 # ffffffffc0206bc8 <default_pmm_manager+0xa8>
ffffffffc0204268:	07700593          	li	a1,119
ffffffffc020426c:	00002517          	auipc	a0,0x2
ffffffffc0204270:	25450513          	addi	a0,a0,596 # ffffffffc02064c0 <commands+0x868>
ffffffffc0204274:	a1afc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204278:	00002617          	auipc	a2,0x2
ffffffffc020427c:	22860613          	addi	a2,a2,552 # ffffffffc02064a0 <commands+0x848>
ffffffffc0204280:	06900593          	li	a1,105
ffffffffc0204284:	00002517          	auipc	a0,0x2
ffffffffc0204288:	23c50513          	addi	a0,a0,572 # ffffffffc02064c0 <commands+0x868>
ffffffffc020428c:	a02fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204290 <proc_run>:
{
ffffffffc0204290:	7179                	addi	sp,sp,-48
ffffffffc0204292:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0204294:	000bc917          	auipc	s2,0xbc
ffffffffc0204298:	eac90913          	addi	s2,s2,-340 # ffffffffc02c0140 <current>
{
ffffffffc020429c:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc020429e:	00093483          	ld	s1,0(s2)
{
ffffffffc02042a2:	f406                	sd	ra,40(sp)
ffffffffc02042a4:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc02042a6:	02a48863          	beq	s1,a0,ffffffffc02042d6 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02042aa:	100027f3          	csrr	a5,sstatus
ffffffffc02042ae:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02042b0:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02042b2:	ef9d                	bnez	a5,ffffffffc02042f0 <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc02042b4:	755c                	ld	a5,168(a0)
ffffffffc02042b6:	577d                	li	a4,-1
ffffffffc02042b8:	177e                	slli	a4,a4,0x3f
ffffffffc02042ba:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc02042bc:	00a93023          	sd	a0,0(s2)
ffffffffc02042c0:	8fd9                	or	a5,a5,a4
ffffffffc02042c2:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc02042c6:	03050593          	addi	a1,a0,48
ffffffffc02042ca:	03048513          	addi	a0,s1,48
ffffffffc02042ce:	7f7000ef          	jal	ra,ffffffffc02052c4 <switch_to>
    if (flag)
ffffffffc02042d2:	00099863          	bnez	s3,ffffffffc02042e2 <proc_run+0x52>
}
ffffffffc02042d6:	70a2                	ld	ra,40(sp)
ffffffffc02042d8:	7482                	ld	s1,32(sp)
ffffffffc02042da:	6962                	ld	s2,24(sp)
ffffffffc02042dc:	69c2                	ld	s3,16(sp)
ffffffffc02042de:	6145                	addi	sp,sp,48
ffffffffc02042e0:	8082                	ret
ffffffffc02042e2:	70a2                	ld	ra,40(sp)
ffffffffc02042e4:	7482                	ld	s1,32(sp)
ffffffffc02042e6:	6962                	ld	s2,24(sp)
ffffffffc02042e8:	69c2                	ld	s3,16(sp)
ffffffffc02042ea:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02042ec:	ec2fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc02042f0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02042f2:	ec2fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02042f6:	6522                	ld	a0,8(sp)
ffffffffc02042f8:	4985                	li	s3,1
ffffffffc02042fa:	bf6d                	j	ffffffffc02042b4 <proc_run+0x24>

ffffffffc02042fc <do_fork>:
{
ffffffffc02042fc:	7119                	addi	sp,sp,-128
ffffffffc02042fe:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204300:	000bc917          	auipc	s2,0xbc
ffffffffc0204304:	e5890913          	addi	s2,s2,-424 # ffffffffc02c0158 <nr_process>
ffffffffc0204308:	00092703          	lw	a4,0(s2)
{
ffffffffc020430c:	fc86                	sd	ra,120(sp)
ffffffffc020430e:	f8a2                	sd	s0,112(sp)
ffffffffc0204310:	f4a6                	sd	s1,104(sp)
ffffffffc0204312:	ecce                	sd	s3,88(sp)
ffffffffc0204314:	e8d2                	sd	s4,80(sp)
ffffffffc0204316:	e4d6                	sd	s5,72(sp)
ffffffffc0204318:	e0da                	sd	s6,64(sp)
ffffffffc020431a:	fc5e                	sd	s7,56(sp)
ffffffffc020431c:	f862                	sd	s8,48(sp)
ffffffffc020431e:	f466                	sd	s9,40(sp)
ffffffffc0204320:	f06a                	sd	s10,32(sp)
ffffffffc0204322:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204324:	6785                	lui	a5,0x1
ffffffffc0204326:	2ef75b63          	bge	a4,a5,ffffffffc020461c <do_fork+0x320>
ffffffffc020432a:	8a2a                	mv	s4,a0
ffffffffc020432c:	89ae                	mv	s3,a1
ffffffffc020432e:	8432                	mv	s0,a2
    proc = alloc_proc();
ffffffffc0204330:	dedff0ef          	jal	ra,ffffffffc020411c <alloc_proc>
ffffffffc0204334:	84aa                	mv	s1,a0
    if (!proc) {
ffffffffc0204336:	2e050863          	beqz	a0,ffffffffc0204626 <do_fork+0x32a>
    proc->parent = current;
ffffffffc020433a:	000bcc17          	auipc	s8,0xbc
ffffffffc020433e:	e06c0c13          	addi	s8,s8,-506 # ffffffffc02c0140 <current>
ffffffffc0204342:	000c3783          	ld	a5,0(s8)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204346:	4509                	li	a0,2
    proc->parent = current;
ffffffffc0204348:	f09c                	sd	a5,32(s1)
    current->wait_state = 0;
ffffffffc020434a:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8ac4>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020434e:	f0ffd0ef          	jal	ra,ffffffffc020225c <alloc_pages>
    if (page != NULL)
ffffffffc0204352:	2a050563          	beqz	a0,ffffffffc02045fc <do_fork+0x300>
    return page - pages + nbase;
ffffffffc0204356:	000bca97          	auipc	s5,0xbc
ffffffffc020435a:	dd2a8a93          	addi	s5,s5,-558 # ffffffffc02c0128 <pages>
ffffffffc020435e:	000ab683          	ld	a3,0(s5)
ffffffffc0204362:	00004b17          	auipc	s6,0x4
ffffffffc0204366:	a6eb0b13          	addi	s6,s6,-1426 # ffffffffc0207dd0 <nbase>
ffffffffc020436a:	000b3783          	ld	a5,0(s6)
ffffffffc020436e:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204372:	000bcb97          	auipc	s7,0xbc
ffffffffc0204376:	daeb8b93          	addi	s7,s7,-594 # ffffffffc02c0120 <npage>
    return page - pages + nbase;
ffffffffc020437a:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020437c:	5dfd                	li	s11,-1
ffffffffc020437e:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204382:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204384:	00cddd93          	srli	s11,s11,0xc
ffffffffc0204388:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020438c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020438e:	2ee67363          	bgeu	a2,a4,ffffffffc0204674 <do_fork+0x378>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204392:	000c3603          	ld	a2,0(s8)
ffffffffc0204396:	000bcc17          	auipc	s8,0xbc
ffffffffc020439a:	da2c0c13          	addi	s8,s8,-606 # ffffffffc02c0138 <va_pa_offset>
ffffffffc020439e:	000c3703          	ld	a4,0(s8)
ffffffffc02043a2:	02863d03          	ld	s10,40(a2)
ffffffffc02043a6:	e43e                	sd	a5,8(sp)
ffffffffc02043a8:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02043aa:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc02043ac:	020d0863          	beqz	s10,ffffffffc02043dc <do_fork+0xe0>
    if (clone_flags & CLONE_VM)
ffffffffc02043b0:	100a7a13          	andi	s4,s4,256
ffffffffc02043b4:	180a0663          	beqz	s4,ffffffffc0204540 <do_fork+0x244>
    mm->mm_count += 1;
ffffffffc02043b8:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02043bc:	018d3783          	ld	a5,24(s10)
ffffffffc02043c0:	c02006b7          	lui	a3,0xc0200
ffffffffc02043c4:	2705                	addiw	a4,a4,1
ffffffffc02043c6:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc02043ca:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02043ce:	26d7ea63          	bltu	a5,a3,ffffffffc0204642 <do_fork+0x346>
ffffffffc02043d2:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02043d6:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02043d8:	8f99                	sub	a5,a5,a4
ffffffffc02043da:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02043dc:	6789                	lui	a5,0x2
ffffffffc02043de:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>
ffffffffc02043e2:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02043e4:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02043e6:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02043e8:	87b6                	mv	a5,a3
ffffffffc02043ea:	12040893          	addi	a7,s0,288
ffffffffc02043ee:	00063803          	ld	a6,0(a2)
ffffffffc02043f2:	6608                	ld	a0,8(a2)
ffffffffc02043f4:	6a0c                	ld	a1,16(a2)
ffffffffc02043f6:	6e18                	ld	a4,24(a2)
ffffffffc02043f8:	0107b023          	sd	a6,0(a5)
ffffffffc02043fc:	e788                	sd	a0,8(a5)
ffffffffc02043fe:	eb8c                	sd	a1,16(a5)
ffffffffc0204400:	ef98                	sd	a4,24(a5)
ffffffffc0204402:	02060613          	addi	a2,a2,32
ffffffffc0204406:	02078793          	addi	a5,a5,32
ffffffffc020440a:	ff1612e3          	bne	a2,a7,ffffffffc02043ee <do_fork+0xf2>
    proc->tf->gpr.a0 = 0;
ffffffffc020440e:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204412:	12098563          	beqz	s3,ffffffffc020453c <do_fork+0x240>
    if (++last_pid >= MAX_PID)
ffffffffc0204416:	000b8317          	auipc	t1,0xb8
ffffffffc020441a:	89a30313          	addi	t1,t1,-1894 # ffffffffc02bbcb0 <last_pid.1>
ffffffffc020441e:	00032783          	lw	a5,0(t1)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204422:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204426:	00000717          	auipc	a4,0x0
ffffffffc020442a:	d6870713          	addi	a4,a4,-664 # ffffffffc020418e <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc020442e:	0017851b          	addiw	a0,a5,1
ffffffffc0204432:	000bc617          	auipc	a2,0xbc
ffffffffc0204436:	c9e60613          	addi	a2,a2,-866 # ffffffffc02c00d0 <proc_list>
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020443a:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020443c:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc020443e:	00a32023          	sw	a0,0(t1)
ffffffffc0204442:	6789                	lui	a5,0x2
ffffffffc0204444:	00863883          	ld	a7,8(a2)
ffffffffc0204448:	08f55863          	bge	a0,a5,ffffffffc02044d8 <do_fork+0x1dc>
    if (last_pid >= next_safe)
ffffffffc020444c:	000b8e97          	auipc	t4,0xb8
ffffffffc0204450:	868e8e93          	addi	t4,t4,-1944 # ffffffffc02bbcb4 <next_safe.0>
ffffffffc0204454:	000ea783          	lw	a5,0(t4)
ffffffffc0204458:	08f55863          	bge	a0,a5,ffffffffc02044e8 <do_fork+0x1ec>
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020445c:	7094                	ld	a3,32(s1)
    proc->pid = get_pid();// 调用get_pid()分配唯一的pid
ffffffffc020445e:	c0c8                	sw	a0,4(s1)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204460:	0c848793          	addi	a5,s1,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204464:	7af8                	ld	a4,240(a3)
    prev->next = next->prev = elm;
ffffffffc0204466:	00f8b023          	sd	a5,0(a7) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc020446a:	e61c                	sd	a5,8(a2)
    elm->next = next;
ffffffffc020446c:	0d14b823          	sd	a7,208(s1)
    elm->prev = prev;
ffffffffc0204470:	e4f0                	sd	a2,200(s1)
    proc->yptr = NULL;
ffffffffc0204472:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204476:	10e4b023          	sd	a4,256(s1)
ffffffffc020447a:	c311                	beqz	a4,ffffffffc020447e <do_fork+0x182>
        proc->optr->yptr = proc;
ffffffffc020447c:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc020447e:	00092783          	lw	a5,0(s2)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204482:	45a9                	li	a1,10
    proc->parent->cptr = proc;
ffffffffc0204484:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204486:	2785                	addiw	a5,a5,1
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204488:	2501                	sext.w	a0,a0
    nr_process++;
ffffffffc020448a:	00f92023          	sw	a5,0(s2)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020448e:	08c010ef          	jal	ra,ffffffffc020551a <hash32>
ffffffffc0204492:	02051713          	slli	a4,a0,0x20
ffffffffc0204496:	01c75793          	srli	a5,a4,0x1c
ffffffffc020449a:	000b8517          	auipc	a0,0xb8
ffffffffc020449e:	c3650513          	addi	a0,a0,-970 # ffffffffc02bc0d0 <hash_list>
ffffffffc02044a2:	97aa                	add	a5,a5,a0
    __list_add(elm, listelm, listelm->next);
ffffffffc02044a4:	6798                	ld	a4,8(a5)
ffffffffc02044a6:	0d848693          	addi	a3,s1,216
    wakeup_proc(proc);
ffffffffc02044aa:	8526                	mv	a0,s1
    prev->next = next->prev = elm;
ffffffffc02044ac:	e314                	sd	a3,0(a4)
ffffffffc02044ae:	e794                	sd	a3,8(a5)
    elm->next = next;
ffffffffc02044b0:	f0f8                	sd	a4,224(s1)
    elm->prev = prev;
ffffffffc02044b2:	ecfc                	sd	a5,216(s1)
ffffffffc02044b4:	67b000ef          	jal	ra,ffffffffc020532e <wakeup_proc>
    ret = proc->pid;
ffffffffc02044b8:	40c8                	lw	a0,4(s1)
}
ffffffffc02044ba:	70e6                	ld	ra,120(sp)
ffffffffc02044bc:	7446                	ld	s0,112(sp)
ffffffffc02044be:	74a6                	ld	s1,104(sp)
ffffffffc02044c0:	7906                	ld	s2,96(sp)
ffffffffc02044c2:	69e6                	ld	s3,88(sp)
ffffffffc02044c4:	6a46                	ld	s4,80(sp)
ffffffffc02044c6:	6aa6                	ld	s5,72(sp)
ffffffffc02044c8:	6b06                	ld	s6,64(sp)
ffffffffc02044ca:	7be2                	ld	s7,56(sp)
ffffffffc02044cc:	7c42                	ld	s8,48(sp)
ffffffffc02044ce:	7ca2                	ld	s9,40(sp)
ffffffffc02044d0:	7d02                	ld	s10,32(sp)
ffffffffc02044d2:	6de2                	ld	s11,24(sp)
ffffffffc02044d4:	6109                	addi	sp,sp,128
ffffffffc02044d6:	8082                	ret
        last_pid = 1;
ffffffffc02044d8:	4785                	li	a5,1
ffffffffc02044da:	00f32023          	sw	a5,0(t1)
        goto inside;
ffffffffc02044de:	4505                	li	a0,1
ffffffffc02044e0:	000b7e97          	auipc	t4,0xb7
ffffffffc02044e4:	7d4e8e93          	addi	t4,t4,2004 # ffffffffc02bbcb4 <next_safe.0>
        next_safe = MAX_PID;
ffffffffc02044e8:	6789                	lui	a5,0x2
ffffffffc02044ea:	00fea023          	sw	a5,0(t4)
ffffffffc02044ee:	86aa                	mv	a3,a0
ffffffffc02044f0:	4801                	li	a6,0
        while ((le = list_next(le)) != list)
ffffffffc02044f2:	6f09                	lui	t5,0x2
ffffffffc02044f4:	10c88e63          	beq	a7,a2,ffffffffc0204610 <do_fork+0x314>
ffffffffc02044f8:	8e42                	mv	t3,a6
ffffffffc02044fa:	87c6                	mv	a5,a7
ffffffffc02044fc:	6589                	lui	a1,0x2
ffffffffc02044fe:	a811                	j	ffffffffc0204512 <do_fork+0x216>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204500:	00e6d663          	bge	a3,a4,ffffffffc020450c <do_fork+0x210>
ffffffffc0204504:	00b75463          	bge	a4,a1,ffffffffc020450c <do_fork+0x210>
ffffffffc0204508:	85ba                	mv	a1,a4
ffffffffc020450a:	4e05                	li	t3,1
    return listelm->next;
ffffffffc020450c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020450e:	00c78d63          	beq	a5,a2,ffffffffc0204528 <do_fork+0x22c>
            if (proc->pid == last_pid)
ffffffffc0204512:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c74>
ffffffffc0204516:	fed715e3          	bne	a4,a3,ffffffffc0204500 <do_fork+0x204>
                if (++last_pid >= next_safe)
ffffffffc020451a:	2685                	addiw	a3,a3,1
ffffffffc020451c:	0eb6d563          	bge	a3,a1,ffffffffc0204606 <do_fork+0x30a>
ffffffffc0204520:	679c                	ld	a5,8(a5)
ffffffffc0204522:	4805                	li	a6,1
        while ((le = list_next(le)) != list)
ffffffffc0204524:	fec797e3          	bne	a5,a2,ffffffffc0204512 <do_fork+0x216>
ffffffffc0204528:	00080563          	beqz	a6,ffffffffc0204532 <do_fork+0x236>
ffffffffc020452c:	00d32023          	sw	a3,0(t1)
ffffffffc0204530:	8536                	mv	a0,a3
ffffffffc0204532:	f20e05e3          	beqz	t3,ffffffffc020445c <do_fork+0x160>
ffffffffc0204536:	00bea023          	sw	a1,0(t4)
ffffffffc020453a:	b70d                	j	ffffffffc020445c <do_fork+0x160>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020453c:	89b6                	mv	s3,a3
ffffffffc020453e:	bde1                	j	ffffffffc0204416 <do_fork+0x11a>
    if ((mm = mm_create()) == NULL)
ffffffffc0204540:	ccaff0ef          	jal	ra,ffffffffc0203a0a <mm_create>
ffffffffc0204544:	8caa                	mv	s9,a0
ffffffffc0204546:	c159                	beqz	a0,ffffffffc02045cc <do_fork+0x2d0>
    if ((page = alloc_page()) == NULL)
ffffffffc0204548:	4505                	li	a0,1
ffffffffc020454a:	d13fd0ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc020454e:	cd25                	beqz	a0,ffffffffc02045c6 <do_fork+0x2ca>
    return page - pages + nbase;
ffffffffc0204550:	000ab683          	ld	a3,0(s5)
ffffffffc0204554:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc0204556:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc020455a:	40d506b3          	sub	a3,a0,a3
ffffffffc020455e:	8699                	srai	a3,a3,0x6
ffffffffc0204560:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204562:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204566:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204568:	10edf663          	bgeu	s11,a4,ffffffffc0204674 <do_fork+0x378>
ffffffffc020456c:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204570:	6605                	lui	a2,0x1
ffffffffc0204572:	000bc597          	auipc	a1,0xbc
ffffffffc0204576:	ba65b583          	ld	a1,-1114(a1) # ffffffffc02c0118 <boot_pgdir_va>
ffffffffc020457a:	9a36                	add	s4,s4,a3
ffffffffc020457c:	8552                	mv	a0,s4
ffffffffc020457e:	454010ef          	jal	ra,ffffffffc02059d2 <memcpy>
        lock(&(mm->mm_lock));
ffffffffc0204582:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc0204586:	014cbc23          	sd	s4,24(s9)
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020458a:	4785                	li	a5,1
ffffffffc020458c:	40fdb7af          	amoor.d	a5,a5,(s11)
    while (!try_lock(lock))
ffffffffc0204590:	8b85                	andi	a5,a5,1
ffffffffc0204592:	4a05                	li	s4,1
ffffffffc0204594:	c799                	beqz	a5,ffffffffc02045a2 <do_fork+0x2a6>
        schedule();
ffffffffc0204596:	619000ef          	jal	ra,ffffffffc02053ae <schedule>
ffffffffc020459a:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc020459e:	8b85                	andi	a5,a5,1
ffffffffc02045a0:	fbfd                	bnez	a5,ffffffffc0204596 <do_fork+0x29a>
        ret = dup_mmap(mm, oldmm);
ffffffffc02045a2:	85ea                	mv	a1,s10
ffffffffc02045a4:	8566                	mv	a0,s9
ffffffffc02045a6:	ea6ff0ef          	jal	ra,ffffffffc0203c4c <dup_mmap>
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02045aa:	57f9                	li	a5,-2
ffffffffc02045ac:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02045b0:	8b85                	andi	a5,a5,1
    if (!test_and_clear_bit(0, lock))
ffffffffc02045b2:	cfa5                	beqz	a5,ffffffffc020462a <do_fork+0x32e>
good_mm:
ffffffffc02045b4:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc02045b6:	e00501e3          	beqz	a0,ffffffffc02043b8 <do_fork+0xbc>
    exit_mmap(mm);
ffffffffc02045ba:	8566                	mv	a0,s9
ffffffffc02045bc:	f2aff0ef          	jal	ra,ffffffffc0203ce6 <exit_mmap>
    put_pgdir(mm);
ffffffffc02045c0:	8566                	mv	a0,s9
ffffffffc02045c2:	c59ff0ef          	jal	ra,ffffffffc020421a <put_pgdir>
    mm_destroy(mm);
ffffffffc02045c6:	8566                	mv	a0,s9
ffffffffc02045c8:	d82ff0ef          	jal	ra,ffffffffc0203b4a <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02045cc:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02045ce:	c02007b7          	lui	a5,0xc0200
ffffffffc02045d2:	0af6ed63          	bltu	a3,a5,ffffffffc020468c <do_fork+0x390>
ffffffffc02045d6:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02045da:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02045de:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02045e2:	83b1                	srli	a5,a5,0xc
ffffffffc02045e4:	06e7fc63          	bgeu	a5,a4,ffffffffc020465c <do_fork+0x360>
    return &pages[PPN(pa) - nbase];
ffffffffc02045e8:	000b3703          	ld	a4,0(s6)
ffffffffc02045ec:	000ab503          	ld	a0,0(s5)
ffffffffc02045f0:	4589                	li	a1,2
ffffffffc02045f2:	8f99                	sub	a5,a5,a4
ffffffffc02045f4:	079a                	slli	a5,a5,0x6
ffffffffc02045f6:	953e                	add	a0,a0,a5
ffffffffc02045f8:	ca3fd0ef          	jal	ra,ffffffffc020229a <free_pages>
    kfree(proc);
ffffffffc02045fc:	8526                	mv	a0,s1
ffffffffc02045fe:	b31fd0ef          	jal	ra,ffffffffc020212e <kfree>
    ret = -E_NO_MEM;
ffffffffc0204602:	5571                	li	a0,-4
    goto fork_out;
ffffffffc0204604:	bd5d                	j	ffffffffc02044ba <do_fork+0x1be>
                    if (last_pid >= MAX_PID)
ffffffffc0204606:	01e6c363          	blt	a3,t5,ffffffffc020460c <do_fork+0x310>
                        last_pid = 1;
ffffffffc020460a:	4685                	li	a3,1
                    goto repeat;
ffffffffc020460c:	4805                	li	a6,1
ffffffffc020460e:	b5dd                	j	ffffffffc02044f4 <do_fork+0x1f8>
ffffffffc0204610:	00080863          	beqz	a6,ffffffffc0204620 <do_fork+0x324>
ffffffffc0204614:	00d32023          	sw	a3,0(t1)
    return last_pid;
ffffffffc0204618:	8536                	mv	a0,a3
ffffffffc020461a:	b589                	j	ffffffffc020445c <do_fork+0x160>
    int ret = -E_NO_FREE_PROC;
ffffffffc020461c:	556d                	li	a0,-5
ffffffffc020461e:	bd71                	j	ffffffffc02044ba <do_fork+0x1be>
    return last_pid;
ffffffffc0204620:	00032503          	lw	a0,0(t1)
ffffffffc0204624:	bd25                	j	ffffffffc020445c <do_fork+0x160>
    ret = -E_NO_MEM;
ffffffffc0204626:	5571                	li	a0,-4
ffffffffc0204628:	bd49                	j	ffffffffc02044ba <do_fork+0x1be>
        panic("Unlock failed.\n");
ffffffffc020462a:	00002617          	auipc	a2,0x2
ffffffffc020462e:	82660613          	addi	a2,a2,-2010 # ffffffffc0205e50 <commands+0x1f8>
ffffffffc0204632:	03f00593          	li	a1,63
ffffffffc0204636:	00002517          	auipc	a0,0x2
ffffffffc020463a:	82a50513          	addi	a0,a0,-2006 # ffffffffc0205e60 <commands+0x208>
ffffffffc020463e:	e51fb0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204642:	86be                	mv	a3,a5
ffffffffc0204644:	00002617          	auipc	a2,0x2
ffffffffc0204648:	58460613          	addi	a2,a2,1412 # ffffffffc0206bc8 <default_pmm_manager+0xa8>
ffffffffc020464c:	19600593          	li	a1,406
ffffffffc0204650:	00003517          	auipc	a0,0x3
ffffffffc0204654:	f1050513          	addi	a0,a0,-240 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204658:	e37fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020465c:	00002617          	auipc	a2,0x2
ffffffffc0204660:	e4460613          	addi	a2,a2,-444 # ffffffffc02064a0 <commands+0x848>
ffffffffc0204664:	06900593          	li	a1,105
ffffffffc0204668:	00002517          	auipc	a0,0x2
ffffffffc020466c:	e5850513          	addi	a0,a0,-424 # ffffffffc02064c0 <commands+0x868>
ffffffffc0204670:	e1ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0204674:	00002617          	auipc	a2,0x2
ffffffffc0204678:	00460613          	addi	a2,a2,4 # ffffffffc0206678 <commands+0xa20>
ffffffffc020467c:	07100593          	li	a1,113
ffffffffc0204680:	00002517          	auipc	a0,0x2
ffffffffc0204684:	e4050513          	addi	a0,a0,-448 # ffffffffc02064c0 <commands+0x868>
ffffffffc0204688:	e07fb0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc020468c:	00002617          	auipc	a2,0x2
ffffffffc0204690:	53c60613          	addi	a2,a2,1340 # ffffffffc0206bc8 <default_pmm_manager+0xa8>
ffffffffc0204694:	07700593          	li	a1,119
ffffffffc0204698:	00002517          	auipc	a0,0x2
ffffffffc020469c:	e2850513          	addi	a0,a0,-472 # ffffffffc02064c0 <commands+0x868>
ffffffffc02046a0:	deffb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02046a4 <kernel_thread>:
{
ffffffffc02046a4:	7129                	addi	sp,sp,-320
ffffffffc02046a6:	fa22                	sd	s0,304(sp)
ffffffffc02046a8:	f626                	sd	s1,296(sp)
ffffffffc02046aa:	f24a                	sd	s2,288(sp)
ffffffffc02046ac:	84ae                	mv	s1,a1
ffffffffc02046ae:	892a                	mv	s2,a0
ffffffffc02046b0:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046b2:	4581                	li	a1,0
ffffffffc02046b4:	12000613          	li	a2,288
ffffffffc02046b8:	850a                	mv	a0,sp
{
ffffffffc02046ba:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046bc:	304010ef          	jal	ra,ffffffffc02059c0 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02046c0:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02046c2:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02046c4:	100027f3          	csrr	a5,sstatus
ffffffffc02046c8:	edd7f793          	andi	a5,a5,-291
ffffffffc02046cc:	1207e793          	ori	a5,a5,288
ffffffffc02046d0:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046d2:	860a                	mv	a2,sp
ffffffffc02046d4:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046d8:	00000797          	auipc	a5,0x0
ffffffffc02046dc:	a3c78793          	addi	a5,a5,-1476 # ffffffffc0204114 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046e0:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046e2:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046e4:	c19ff0ef          	jal	ra,ffffffffc02042fc <do_fork>
}
ffffffffc02046e8:	70f2                	ld	ra,312(sp)
ffffffffc02046ea:	7452                	ld	s0,304(sp)
ffffffffc02046ec:	74b2                	ld	s1,296(sp)
ffffffffc02046ee:	7912                	ld	s2,288(sp)
ffffffffc02046f0:	6131                	addi	sp,sp,320
ffffffffc02046f2:	8082                	ret

ffffffffc02046f4 <do_exit>:
{
ffffffffc02046f4:	7179                	addi	sp,sp,-48
ffffffffc02046f6:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc02046f8:	000bc417          	auipc	s0,0xbc
ffffffffc02046fc:	a4840413          	addi	s0,s0,-1464 # ffffffffc02c0140 <current>
ffffffffc0204700:	601c                	ld	a5,0(s0)
{
ffffffffc0204702:	f406                	sd	ra,40(sp)
ffffffffc0204704:	ec26                	sd	s1,24(sp)
ffffffffc0204706:	e84a                	sd	s2,16(sp)
ffffffffc0204708:	e44e                	sd	s3,8(sp)
ffffffffc020470a:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc020470c:	000bc717          	auipc	a4,0xbc
ffffffffc0204710:	a3c73703          	ld	a4,-1476(a4) # ffffffffc02c0148 <idleproc>
ffffffffc0204714:	0ce78c63          	beq	a5,a4,ffffffffc02047ec <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204718:	000bc497          	auipc	s1,0xbc
ffffffffc020471c:	a3848493          	addi	s1,s1,-1480 # ffffffffc02c0150 <initproc>
ffffffffc0204720:	6098                	ld	a4,0(s1)
ffffffffc0204722:	0ee78b63          	beq	a5,a4,ffffffffc0204818 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204726:	0287b983          	ld	s3,40(a5)
ffffffffc020472a:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc020472c:	02098663          	beqz	s3,ffffffffc0204758 <do_exit+0x64>
ffffffffc0204730:	000bc797          	auipc	a5,0xbc
ffffffffc0204734:	9e07b783          	ld	a5,-1568(a5) # ffffffffc02c0110 <boot_pgdir_pa>
ffffffffc0204738:	577d                	li	a4,-1
ffffffffc020473a:	177e                	slli	a4,a4,0x3f
ffffffffc020473c:	83b1                	srli	a5,a5,0xc
ffffffffc020473e:	8fd9                	or	a5,a5,a4
ffffffffc0204740:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204744:	0309a783          	lw	a5,48(s3)
ffffffffc0204748:	fff7871b          	addiw	a4,a5,-1
ffffffffc020474c:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204750:	cb55                	beqz	a4,ffffffffc0204804 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0204752:	601c                	ld	a5,0(s0)
ffffffffc0204754:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204758:	601c                	ld	a5,0(s0)
ffffffffc020475a:	470d                	li	a4,3
ffffffffc020475c:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc020475e:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204762:	100027f3          	csrr	a5,sstatus
ffffffffc0204766:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204768:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020476a:	e3f9                	bnez	a5,ffffffffc0204830 <do_exit+0x13c>
        proc = current->parent;
ffffffffc020476c:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc020476e:	800007b7          	lui	a5,0x80000
ffffffffc0204772:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204774:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204776:	0ec52703          	lw	a4,236(a0)
ffffffffc020477a:	0af70f63          	beq	a4,a5,ffffffffc0204838 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc020477e:	6018                	ld	a4,0(s0)
ffffffffc0204780:	7b7c                	ld	a5,240(a4)
ffffffffc0204782:	c3a1                	beqz	a5,ffffffffc02047c2 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204784:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204788:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc020478a:	0985                	addi	s3,s3,1
ffffffffc020478c:	a021                	j	ffffffffc0204794 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc020478e:	6018                	ld	a4,0(s0)
ffffffffc0204790:	7b7c                	ld	a5,240(a4)
ffffffffc0204792:	cb85                	beqz	a5,ffffffffc02047c2 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0204794:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_dirtycow_test_out_size+0xffffffff7fff4ee0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204798:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc020479a:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020479c:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc020479e:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02047a2:	10e7b023          	sd	a4,256(a5)
ffffffffc02047a6:	c311                	beqz	a4,ffffffffc02047aa <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02047a8:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047aa:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02047ac:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02047ae:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047b0:	fd271fe3          	bne	a4,s2,ffffffffc020478e <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02047b4:	0ec52783          	lw	a5,236(a0)
ffffffffc02047b8:	fd379be3          	bne	a5,s3,ffffffffc020478e <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02047bc:	373000ef          	jal	ra,ffffffffc020532e <wakeup_proc>
ffffffffc02047c0:	b7f9                	j	ffffffffc020478e <do_exit+0x9a>
    if (flag)
ffffffffc02047c2:	020a1263          	bnez	s4,ffffffffc02047e6 <do_exit+0xf2>
    schedule();
ffffffffc02047c6:	3e9000ef          	jal	ra,ffffffffc02053ae <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02047ca:	601c                	ld	a5,0(s0)
ffffffffc02047cc:	00003617          	auipc	a2,0x3
ffffffffc02047d0:	dcc60613          	addi	a2,a2,-564 # ffffffffc0207598 <default_pmm_manager+0xa78>
ffffffffc02047d4:	24e00593          	li	a1,590
ffffffffc02047d8:	43d4                	lw	a3,4(a5)
ffffffffc02047da:	00003517          	auipc	a0,0x3
ffffffffc02047de:	d8650513          	addi	a0,a0,-634 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc02047e2:	cadfb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc02047e6:	9c8fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02047ea:	bff1                	j	ffffffffc02047c6 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc02047ec:	00003617          	auipc	a2,0x3
ffffffffc02047f0:	d8c60613          	addi	a2,a2,-628 # ffffffffc0207578 <default_pmm_manager+0xa58>
ffffffffc02047f4:	21a00593          	li	a1,538
ffffffffc02047f8:	00003517          	auipc	a0,0x3
ffffffffc02047fc:	d6850513          	addi	a0,a0,-664 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204800:	c8ffb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc0204804:	854e                	mv	a0,s3
ffffffffc0204806:	ce0ff0ef          	jal	ra,ffffffffc0203ce6 <exit_mmap>
            put_pgdir(mm);
ffffffffc020480a:	854e                	mv	a0,s3
ffffffffc020480c:	a0fff0ef          	jal	ra,ffffffffc020421a <put_pgdir>
            mm_destroy(mm);
ffffffffc0204810:	854e                	mv	a0,s3
ffffffffc0204812:	b38ff0ef          	jal	ra,ffffffffc0203b4a <mm_destroy>
ffffffffc0204816:	bf35                	j	ffffffffc0204752 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204818:	00003617          	auipc	a2,0x3
ffffffffc020481c:	d7060613          	addi	a2,a2,-656 # ffffffffc0207588 <default_pmm_manager+0xa68>
ffffffffc0204820:	21e00593          	li	a1,542
ffffffffc0204824:	00003517          	auipc	a0,0x3
ffffffffc0204828:	d3c50513          	addi	a0,a0,-708 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc020482c:	c63fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc0204830:	984fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204834:	4a05                	li	s4,1
ffffffffc0204836:	bf1d                	j	ffffffffc020476c <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204838:	2f7000ef          	jal	ra,ffffffffc020532e <wakeup_proc>
ffffffffc020483c:	b789                	j	ffffffffc020477e <do_exit+0x8a>

ffffffffc020483e <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc020483e:	715d                	addi	sp,sp,-80
ffffffffc0204840:	f84a                	sd	s2,48(sp)
ffffffffc0204842:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0204844:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204848:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc020484a:	fc26                	sd	s1,56(sp)
ffffffffc020484c:	f052                	sd	s4,32(sp)
ffffffffc020484e:	ec56                	sd	s5,24(sp)
ffffffffc0204850:	e85a                	sd	s6,16(sp)
ffffffffc0204852:	e45e                	sd	s7,8(sp)
ffffffffc0204854:	e486                	sd	ra,72(sp)
ffffffffc0204856:	e0a2                	sd	s0,64(sp)
ffffffffc0204858:	84aa                	mv	s1,a0
ffffffffc020485a:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc020485c:	000bcb97          	auipc	s7,0xbc
ffffffffc0204860:	8e4b8b93          	addi	s7,s7,-1820 # ffffffffc02c0140 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204864:	00050b1b          	sext.w	s6,a0
ffffffffc0204868:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020486c:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc020486e:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204870:	ccbd                	beqz	s1,ffffffffc02048ee <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204872:	0359e863          	bltu	s3,s5,ffffffffc02048a2 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204876:	45a9                	li	a1,10
ffffffffc0204878:	855a                	mv	a0,s6
ffffffffc020487a:	4a1000ef          	jal	ra,ffffffffc020551a <hash32>
ffffffffc020487e:	02051793          	slli	a5,a0,0x20
ffffffffc0204882:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204886:	000b8797          	auipc	a5,0xb8
ffffffffc020488a:	84a78793          	addi	a5,a5,-1974 # ffffffffc02bc0d0 <hash_list>
ffffffffc020488e:	953e                	add	a0,a0,a5
ffffffffc0204890:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc0204892:	a029                	j	ffffffffc020489c <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc0204894:	f2c42783          	lw	a5,-212(s0)
ffffffffc0204898:	02978163          	beq	a5,s1,ffffffffc02048ba <do_wait.part.0+0x7c>
ffffffffc020489c:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc020489e:	fe851be3          	bne	a0,s0,ffffffffc0204894 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02048a2:	5579                	li	a0,-2
}
ffffffffc02048a4:	60a6                	ld	ra,72(sp)
ffffffffc02048a6:	6406                	ld	s0,64(sp)
ffffffffc02048a8:	74e2                	ld	s1,56(sp)
ffffffffc02048aa:	7942                	ld	s2,48(sp)
ffffffffc02048ac:	79a2                	ld	s3,40(sp)
ffffffffc02048ae:	7a02                	ld	s4,32(sp)
ffffffffc02048b0:	6ae2                	ld	s5,24(sp)
ffffffffc02048b2:	6b42                	ld	s6,16(sp)
ffffffffc02048b4:	6ba2                	ld	s7,8(sp)
ffffffffc02048b6:	6161                	addi	sp,sp,80
ffffffffc02048b8:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02048ba:	000bb683          	ld	a3,0(s7)
ffffffffc02048be:	f4843783          	ld	a5,-184(s0)
ffffffffc02048c2:	fed790e3          	bne	a5,a3,ffffffffc02048a2 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02048c6:	f2842703          	lw	a4,-216(s0)
ffffffffc02048ca:	478d                	li	a5,3
ffffffffc02048cc:	0ef70b63          	beq	a4,a5,ffffffffc02049c2 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02048d0:	4785                	li	a5,1
ffffffffc02048d2:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02048d4:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc02048d8:	2d7000ef          	jal	ra,ffffffffc02053ae <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02048dc:	000bb783          	ld	a5,0(s7)
ffffffffc02048e0:	0b07a783          	lw	a5,176(a5)
ffffffffc02048e4:	8b85                	andi	a5,a5,1
ffffffffc02048e6:	d7c9                	beqz	a5,ffffffffc0204870 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc02048e8:	555d                	li	a0,-9
ffffffffc02048ea:	e0bff0ef          	jal	ra,ffffffffc02046f4 <do_exit>
        proc = current->cptr;
ffffffffc02048ee:	000bb683          	ld	a3,0(s7)
ffffffffc02048f2:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc02048f4:	d45d                	beqz	s0,ffffffffc02048a2 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02048f6:	470d                	li	a4,3
ffffffffc02048f8:	a021                	j	ffffffffc0204900 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc02048fa:	10043403          	ld	s0,256(s0)
ffffffffc02048fe:	d869                	beqz	s0,ffffffffc02048d0 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204900:	401c                	lw	a5,0(s0)
ffffffffc0204902:	fee79ce3          	bne	a5,a4,ffffffffc02048fa <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204906:	000bc797          	auipc	a5,0xbc
ffffffffc020490a:	8427b783          	ld	a5,-1982(a5) # ffffffffc02c0148 <idleproc>
ffffffffc020490e:	0c878963          	beq	a5,s0,ffffffffc02049e0 <do_wait.part.0+0x1a2>
ffffffffc0204912:	000bc797          	auipc	a5,0xbc
ffffffffc0204916:	83e7b783          	ld	a5,-1986(a5) # ffffffffc02c0150 <initproc>
ffffffffc020491a:	0cf40363          	beq	s0,a5,ffffffffc02049e0 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc020491e:	000a0663          	beqz	s4,ffffffffc020492a <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204922:	0e842783          	lw	a5,232(s0)
ffffffffc0204926:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020492a:	100027f3          	csrr	a5,sstatus
ffffffffc020492e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204930:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204932:	e7c1                	bnez	a5,ffffffffc02049ba <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204934:	6c70                	ld	a2,216(s0)
ffffffffc0204936:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204938:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc020493c:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc020493e:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204940:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204942:	6470                	ld	a2,200(s0)
ffffffffc0204944:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204946:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204948:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc020494a:	c319                	beqz	a4,ffffffffc0204950 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc020494c:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc020494e:	7c7c                	ld	a5,248(s0)
ffffffffc0204950:	c3b5                	beqz	a5,ffffffffc02049b4 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204952:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204956:	000bc717          	auipc	a4,0xbc
ffffffffc020495a:	80270713          	addi	a4,a4,-2046 # ffffffffc02c0158 <nr_process>
ffffffffc020495e:	431c                	lw	a5,0(a4)
ffffffffc0204960:	37fd                	addiw	a5,a5,-1
ffffffffc0204962:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc0204964:	e5a9                	bnez	a1,ffffffffc02049ae <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204966:	6814                	ld	a3,16(s0)
ffffffffc0204968:	c02007b7          	lui	a5,0xc0200
ffffffffc020496c:	04f6ee63          	bltu	a3,a5,ffffffffc02049c8 <do_wait.part.0+0x18a>
ffffffffc0204970:	000bb797          	auipc	a5,0xbb
ffffffffc0204974:	7c87b783          	ld	a5,1992(a5) # ffffffffc02c0138 <va_pa_offset>
ffffffffc0204978:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020497a:	82b1                	srli	a3,a3,0xc
ffffffffc020497c:	000bb797          	auipc	a5,0xbb
ffffffffc0204980:	7a47b783          	ld	a5,1956(a5) # ffffffffc02c0120 <npage>
ffffffffc0204984:	06f6fa63          	bgeu	a3,a5,ffffffffc02049f8 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0204988:	00003517          	auipc	a0,0x3
ffffffffc020498c:	44853503          	ld	a0,1096(a0) # ffffffffc0207dd0 <nbase>
ffffffffc0204990:	8e89                	sub	a3,a3,a0
ffffffffc0204992:	069a                	slli	a3,a3,0x6
ffffffffc0204994:	000bb517          	auipc	a0,0xbb
ffffffffc0204998:	79453503          	ld	a0,1940(a0) # ffffffffc02c0128 <pages>
ffffffffc020499c:	9536                	add	a0,a0,a3
ffffffffc020499e:	4589                	li	a1,2
ffffffffc02049a0:	8fbfd0ef          	jal	ra,ffffffffc020229a <free_pages>
    kfree(proc);
ffffffffc02049a4:	8522                	mv	a0,s0
ffffffffc02049a6:	f88fd0ef          	jal	ra,ffffffffc020212e <kfree>
    return 0;
ffffffffc02049aa:	4501                	li	a0,0
ffffffffc02049ac:	bde5                	j	ffffffffc02048a4 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02049ae:	800fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02049b2:	bf55                	j	ffffffffc0204966 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02049b4:	701c                	ld	a5,32(s0)
ffffffffc02049b6:	fbf8                	sd	a4,240(a5)
ffffffffc02049b8:	bf79                	j	ffffffffc0204956 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02049ba:	ffbfb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02049be:	4585                	li	a1,1
ffffffffc02049c0:	bf95                	j	ffffffffc0204934 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02049c2:	f2840413          	addi	s0,s0,-216
ffffffffc02049c6:	b781                	j	ffffffffc0204906 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02049c8:	00002617          	auipc	a2,0x2
ffffffffc02049cc:	20060613          	addi	a2,a2,512 # ffffffffc0206bc8 <default_pmm_manager+0xa8>
ffffffffc02049d0:	07700593          	li	a1,119
ffffffffc02049d4:	00002517          	auipc	a0,0x2
ffffffffc02049d8:	aec50513          	addi	a0,a0,-1300 # ffffffffc02064c0 <commands+0x868>
ffffffffc02049dc:	ab3fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02049e0:	00003617          	auipc	a2,0x3
ffffffffc02049e4:	bd860613          	addi	a2,a2,-1064 # ffffffffc02075b8 <default_pmm_manager+0xa98>
ffffffffc02049e8:	37500593          	li	a1,885
ffffffffc02049ec:	00003517          	auipc	a0,0x3
ffffffffc02049f0:	b7450513          	addi	a0,a0,-1164 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc02049f4:	a9bfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02049f8:	00002617          	auipc	a2,0x2
ffffffffc02049fc:	aa860613          	addi	a2,a2,-1368 # ffffffffc02064a0 <commands+0x848>
ffffffffc0204a00:	06900593          	li	a1,105
ffffffffc0204a04:	00002517          	auipc	a0,0x2
ffffffffc0204a08:	abc50513          	addi	a0,a0,-1348 # ffffffffc02064c0 <commands+0x868>
ffffffffc0204a0c:	a83fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204a10 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204a10:	1141                	addi	sp,sp,-16
ffffffffc0204a12:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204a14:	8c7fd0ef          	jal	ra,ffffffffc02022da <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204a18:	e62fd0ef          	jal	ra,ffffffffc020207a <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204a1c:	4601                	li	a2,0
ffffffffc0204a1e:	4581                	li	a1,0
ffffffffc0204a20:	fffff517          	auipc	a0,0xfffff
ffffffffc0204a24:	77c50513          	addi	a0,a0,1916 # ffffffffc020419c <user_main>
ffffffffc0204a28:	c7dff0ef          	jal	ra,ffffffffc02046a4 <kernel_thread>
    if (pid <= 0)
ffffffffc0204a2c:	00a04563          	bgtz	a0,ffffffffc0204a36 <init_main+0x26>
ffffffffc0204a30:	a071                	j	ffffffffc0204abc <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204a32:	17d000ef          	jal	ra,ffffffffc02053ae <schedule>
    if (code_store != NULL)
ffffffffc0204a36:	4581                	li	a1,0
ffffffffc0204a38:	4501                	li	a0,0
ffffffffc0204a3a:	e05ff0ef          	jal	ra,ffffffffc020483e <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204a3e:	d975                	beqz	a0,ffffffffc0204a32 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204a40:	00003517          	auipc	a0,0x3
ffffffffc0204a44:	bb850513          	addi	a0,a0,-1096 # ffffffffc02075f8 <default_pmm_manager+0xad8>
ffffffffc0204a48:	f4cfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204a4c:	000bb797          	auipc	a5,0xbb
ffffffffc0204a50:	7047b783          	ld	a5,1796(a5) # ffffffffc02c0150 <initproc>
ffffffffc0204a54:	7bf8                	ld	a4,240(a5)
ffffffffc0204a56:	e339                	bnez	a4,ffffffffc0204a9c <init_main+0x8c>
ffffffffc0204a58:	7ff8                	ld	a4,248(a5)
ffffffffc0204a5a:	e329                	bnez	a4,ffffffffc0204a9c <init_main+0x8c>
ffffffffc0204a5c:	1007b703          	ld	a4,256(a5)
ffffffffc0204a60:	ef15                	bnez	a4,ffffffffc0204a9c <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204a62:	000bb697          	auipc	a3,0xbb
ffffffffc0204a66:	6f66a683          	lw	a3,1782(a3) # ffffffffc02c0158 <nr_process>
ffffffffc0204a6a:	4709                	li	a4,2
ffffffffc0204a6c:	0ae69463          	bne	a3,a4,ffffffffc0204b14 <init_main+0x104>
    return listelm->next;
ffffffffc0204a70:	000bb697          	auipc	a3,0xbb
ffffffffc0204a74:	66068693          	addi	a3,a3,1632 # ffffffffc02c00d0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a78:	6698                	ld	a4,8(a3)
ffffffffc0204a7a:	0c878793          	addi	a5,a5,200
ffffffffc0204a7e:	06f71b63          	bne	a4,a5,ffffffffc0204af4 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a82:	629c                	ld	a5,0(a3)
ffffffffc0204a84:	04f71863          	bne	a4,a5,ffffffffc0204ad4 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204a88:	00003517          	auipc	a0,0x3
ffffffffc0204a8c:	c5850513          	addi	a0,a0,-936 # ffffffffc02076e0 <default_pmm_manager+0xbc0>
ffffffffc0204a90:	f04fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204a94:	60a2                	ld	ra,8(sp)
ffffffffc0204a96:	4501                	li	a0,0
ffffffffc0204a98:	0141                	addi	sp,sp,16
ffffffffc0204a9a:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204a9c:	00003697          	auipc	a3,0x3
ffffffffc0204aa0:	b8468693          	addi	a3,a3,-1148 # ffffffffc0207620 <default_pmm_manager+0xb00>
ffffffffc0204aa4:	00002617          	auipc	a2,0x2
ffffffffc0204aa8:	ccc60613          	addi	a2,a2,-820 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204aac:	3e300593          	li	a1,995
ffffffffc0204ab0:	00003517          	auipc	a0,0x3
ffffffffc0204ab4:	ab050513          	addi	a0,a0,-1360 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204ab8:	9d7fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc0204abc:	00003617          	auipc	a2,0x3
ffffffffc0204ac0:	b1c60613          	addi	a2,a2,-1252 # ffffffffc02075d8 <default_pmm_manager+0xab8>
ffffffffc0204ac4:	3da00593          	li	a1,986
ffffffffc0204ac8:	00003517          	auipc	a0,0x3
ffffffffc0204acc:	a9850513          	addi	a0,a0,-1384 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204ad0:	9bffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204ad4:	00003697          	auipc	a3,0x3
ffffffffc0204ad8:	bdc68693          	addi	a3,a3,-1060 # ffffffffc02076b0 <default_pmm_manager+0xb90>
ffffffffc0204adc:	00002617          	auipc	a2,0x2
ffffffffc0204ae0:	c9460613          	addi	a2,a2,-876 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204ae4:	3e600593          	li	a1,998
ffffffffc0204ae8:	00003517          	auipc	a0,0x3
ffffffffc0204aec:	a7850513          	addi	a0,a0,-1416 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204af0:	99ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204af4:	00003697          	auipc	a3,0x3
ffffffffc0204af8:	b8c68693          	addi	a3,a3,-1140 # ffffffffc0207680 <default_pmm_manager+0xb60>
ffffffffc0204afc:	00002617          	auipc	a2,0x2
ffffffffc0204b00:	c7460613          	addi	a2,a2,-908 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204b04:	3e500593          	li	a1,997
ffffffffc0204b08:	00003517          	auipc	a0,0x3
ffffffffc0204b0c:	a5850513          	addi	a0,a0,-1448 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204b10:	97ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc0204b14:	00003697          	auipc	a3,0x3
ffffffffc0204b18:	b5c68693          	addi	a3,a3,-1188 # ffffffffc0207670 <default_pmm_manager+0xb50>
ffffffffc0204b1c:	00002617          	auipc	a2,0x2
ffffffffc0204b20:	c5460613          	addi	a2,a2,-940 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204b24:	3e400593          	li	a1,996
ffffffffc0204b28:	00003517          	auipc	a0,0x3
ffffffffc0204b2c:	a3850513          	addi	a0,a0,-1480 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204b30:	95ffb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204b34 <do_execve>:
{
ffffffffc0204b34:	7171                	addi	sp,sp,-176
ffffffffc0204b36:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204b38:	000bbd97          	auipc	s11,0xbb
ffffffffc0204b3c:	608d8d93          	addi	s11,s11,1544 # ffffffffc02c0140 <current>
ffffffffc0204b40:	000db783          	ld	a5,0(s11)
{
ffffffffc0204b44:	e54e                	sd	s3,136(sp)
ffffffffc0204b46:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204b48:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204b4c:	e94a                	sd	s2,144(sp)
ffffffffc0204b4e:	f4de                	sd	s7,104(sp)
ffffffffc0204b50:	892a                	mv	s2,a0
ffffffffc0204b52:	8bb2                	mv	s7,a2
ffffffffc0204b54:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b56:	862e                	mv	a2,a1
ffffffffc0204b58:	4681                	li	a3,0
ffffffffc0204b5a:	85aa                	mv	a1,a0
ffffffffc0204b5c:	854e                	mv	a0,s3
{
ffffffffc0204b5e:	f506                	sd	ra,168(sp)
ffffffffc0204b60:	f122                	sd	s0,160(sp)
ffffffffc0204b62:	e152                	sd	s4,128(sp)
ffffffffc0204b64:	fcd6                	sd	s5,120(sp)
ffffffffc0204b66:	f8da                	sd	s6,112(sp)
ffffffffc0204b68:	f0e2                	sd	s8,96(sp)
ffffffffc0204b6a:	ece6                	sd	s9,88(sp)
ffffffffc0204b6c:	e8ea                	sd	s10,80(sp)
ffffffffc0204b6e:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b70:	d10ff0ef          	jal	ra,ffffffffc0204080 <user_mem_check>
ffffffffc0204b74:	40050a63          	beqz	a0,ffffffffc0204f88 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204b78:	4641                	li	a2,16
ffffffffc0204b7a:	4581                	li	a1,0
ffffffffc0204b7c:	1808                	addi	a0,sp,48
ffffffffc0204b7e:	643000ef          	jal	ra,ffffffffc02059c0 <memset>
    memcpy(local_name, name, len);
ffffffffc0204b82:	47bd                	li	a5,15
ffffffffc0204b84:	8626                	mv	a2,s1
ffffffffc0204b86:	1e97e263          	bltu	a5,s1,ffffffffc0204d6a <do_execve+0x236>
ffffffffc0204b8a:	85ca                	mv	a1,s2
ffffffffc0204b8c:	1808                	addi	a0,sp,48
ffffffffc0204b8e:	645000ef          	jal	ra,ffffffffc02059d2 <memcpy>
    if (mm != NULL)
ffffffffc0204b92:	1e098363          	beqz	s3,ffffffffc0204d78 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204b96:	00002517          	auipc	a0,0x2
ffffffffc0204b9a:	78a50513          	addi	a0,a0,1930 # ffffffffc0207320 <default_pmm_manager+0x800>
ffffffffc0204b9e:	e2efb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204ba2:	000bb797          	auipc	a5,0xbb
ffffffffc0204ba6:	56e7b783          	ld	a5,1390(a5) # ffffffffc02c0110 <boot_pgdir_pa>
ffffffffc0204baa:	577d                	li	a4,-1
ffffffffc0204bac:	177e                	slli	a4,a4,0x3f
ffffffffc0204bae:	83b1                	srli	a5,a5,0xc
ffffffffc0204bb0:	8fd9                	or	a5,a5,a4
ffffffffc0204bb2:	18079073          	csrw	satp,a5
ffffffffc0204bb6:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b80>
ffffffffc0204bba:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204bbe:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204bc2:	2c070463          	beqz	a4,ffffffffc0204e8a <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204bc6:	000db783          	ld	a5,0(s11)
ffffffffc0204bca:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204bce:	e3dfe0ef          	jal	ra,ffffffffc0203a0a <mm_create>
ffffffffc0204bd2:	84aa                	mv	s1,a0
ffffffffc0204bd4:	1c050d63          	beqz	a0,ffffffffc0204dae <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204bd8:	4505                	li	a0,1
ffffffffc0204bda:	e82fd0ef          	jal	ra,ffffffffc020225c <alloc_pages>
ffffffffc0204bde:	3a050963          	beqz	a0,ffffffffc0204f90 <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc0204be2:	000bbc97          	auipc	s9,0xbb
ffffffffc0204be6:	546c8c93          	addi	s9,s9,1350 # ffffffffc02c0128 <pages>
ffffffffc0204bea:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204bee:	000bbc17          	auipc	s8,0xbb
ffffffffc0204bf2:	532c0c13          	addi	s8,s8,1330 # ffffffffc02c0120 <npage>
    return page - pages + nbase;
ffffffffc0204bf6:	00003717          	auipc	a4,0x3
ffffffffc0204bfa:	1da73703          	ld	a4,474(a4) # ffffffffc0207dd0 <nbase>
ffffffffc0204bfe:	40d506b3          	sub	a3,a0,a3
ffffffffc0204c02:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204c04:	5afd                	li	s5,-1
ffffffffc0204c06:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204c0a:	96ba                	add	a3,a3,a4
ffffffffc0204c0c:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c0e:	00cad713          	srli	a4,s5,0xc
ffffffffc0204c12:	ec3a                	sd	a4,24(sp)
ffffffffc0204c14:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c16:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c18:	38f77063          	bgeu	a4,a5,ffffffffc0204f98 <do_execve+0x464>
ffffffffc0204c1c:	000bbb17          	auipc	s6,0xbb
ffffffffc0204c20:	51cb0b13          	addi	s6,s6,1308 # ffffffffc02c0138 <va_pa_offset>
ffffffffc0204c24:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204c28:	6605                	lui	a2,0x1
ffffffffc0204c2a:	000bb597          	auipc	a1,0xbb
ffffffffc0204c2e:	4ee5b583          	ld	a1,1262(a1) # ffffffffc02c0118 <boot_pgdir_va>
ffffffffc0204c32:	9936                	add	s2,s2,a3
ffffffffc0204c34:	854a                	mv	a0,s2
ffffffffc0204c36:	59d000ef          	jal	ra,ffffffffc02059d2 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c3a:	7782                	ld	a5,32(sp)
ffffffffc0204c3c:	4398                	lw	a4,0(a5)
ffffffffc0204c3e:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204c42:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c46:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_dirtycow_test_out_size+0x464b935f>
ffffffffc0204c4a:	14f71863          	bne	a4,a5,ffffffffc0204d9a <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c4e:	7682                	ld	a3,32(sp)
ffffffffc0204c50:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204c54:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c58:	00371793          	slli	a5,a4,0x3
ffffffffc0204c5c:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204c5e:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c60:	078e                	slli	a5,a5,0x3
ffffffffc0204c62:	97ce                	add	a5,a5,s3
ffffffffc0204c64:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204c66:	00f9fc63          	bgeu	s3,a5,ffffffffc0204c7e <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204c6a:	0009a783          	lw	a5,0(s3)
ffffffffc0204c6e:	4705                	li	a4,1
ffffffffc0204c70:	14e78163          	beq	a5,a4,ffffffffc0204db2 <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc0204c74:	77a2                	ld	a5,40(sp)
ffffffffc0204c76:	03898993          	addi	s3,s3,56
ffffffffc0204c7a:	fef9e8e3          	bltu	s3,a5,ffffffffc0204c6a <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204c7e:	4701                	li	a4,0
ffffffffc0204c80:	46ad                	li	a3,11
ffffffffc0204c82:	00100637          	lui	a2,0x100
ffffffffc0204c86:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204c8a:	8526                	mv	a0,s1
ffffffffc0204c8c:	f11fe0ef          	jal	ra,ffffffffc0203b9c <mm_map>
ffffffffc0204c90:	8a2a                	mv	s4,a0
ffffffffc0204c92:	1e051263          	bnez	a0,ffffffffc0204e76 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204c96:	6c88                	ld	a0,24(s1)
ffffffffc0204c98:	467d                	li	a2,31
ffffffffc0204c9a:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204c9e:	c87fe0ef          	jal	ra,ffffffffc0203924 <pgdir_alloc_page>
ffffffffc0204ca2:	38050363          	beqz	a0,ffffffffc0205028 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ca6:	6c88                	ld	a0,24(s1)
ffffffffc0204ca8:	467d                	li	a2,31
ffffffffc0204caa:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204cae:	c77fe0ef          	jal	ra,ffffffffc0203924 <pgdir_alloc_page>
ffffffffc0204cb2:	34050b63          	beqz	a0,ffffffffc0205008 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cb6:	6c88                	ld	a0,24(s1)
ffffffffc0204cb8:	467d                	li	a2,31
ffffffffc0204cba:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204cbe:	c67fe0ef          	jal	ra,ffffffffc0203924 <pgdir_alloc_page>
ffffffffc0204cc2:	32050363          	beqz	a0,ffffffffc0204fe8 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cc6:	6c88                	ld	a0,24(s1)
ffffffffc0204cc8:	467d                	li	a2,31
ffffffffc0204cca:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204cce:	c57fe0ef          	jal	ra,ffffffffc0203924 <pgdir_alloc_page>
ffffffffc0204cd2:	2e050b63          	beqz	a0,ffffffffc0204fc8 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204cd6:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204cd8:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cdc:	6c94                	ld	a3,24(s1)
ffffffffc0204cde:	2785                	addiw	a5,a5,1
ffffffffc0204ce0:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204ce2:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204ce4:	c02007b7          	lui	a5,0xc0200
ffffffffc0204ce8:	2cf6e463          	bltu	a3,a5,ffffffffc0204fb0 <do_execve+0x47c>
ffffffffc0204cec:	000b3783          	ld	a5,0(s6)
ffffffffc0204cf0:	577d                	li	a4,-1
ffffffffc0204cf2:	177e                	slli	a4,a4,0x3f
ffffffffc0204cf4:	8e9d                	sub	a3,a3,a5
ffffffffc0204cf6:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204cfa:	f654                	sd	a3,168(a2)
ffffffffc0204cfc:	8fd9                	or	a5,a5,a4
ffffffffc0204cfe:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204d02:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d04:	4581                	li	a1,0
ffffffffc0204d06:	12000613          	li	a2,288
ffffffffc0204d0a:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204d0c:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d10:	4b1000ef          	jal	ra,ffffffffc02059c0 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204d14:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d16:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d1a:	edf4f493          	andi	s1,s1,-289
    tf->epc = elf->e_entry;
ffffffffc0204d1e:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d20:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d22:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_dirtycow_test_out_size+0xffffffff7fff4e94>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d26:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d28:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d2c:	4641                	li	a2,16
ffffffffc0204d2e:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d30:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204d32:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d36:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d3a:	854a                	mv	a0,s2
ffffffffc0204d3c:	485000ef          	jal	ra,ffffffffc02059c0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204d40:	463d                	li	a2,15
ffffffffc0204d42:	180c                	addi	a1,sp,48
ffffffffc0204d44:	854a                	mv	a0,s2
ffffffffc0204d46:	48d000ef          	jal	ra,ffffffffc02059d2 <memcpy>
}
ffffffffc0204d4a:	70aa                	ld	ra,168(sp)
ffffffffc0204d4c:	740a                	ld	s0,160(sp)
ffffffffc0204d4e:	64ea                	ld	s1,152(sp)
ffffffffc0204d50:	694a                	ld	s2,144(sp)
ffffffffc0204d52:	69aa                	ld	s3,136(sp)
ffffffffc0204d54:	7ae6                	ld	s5,120(sp)
ffffffffc0204d56:	7b46                	ld	s6,112(sp)
ffffffffc0204d58:	7ba6                	ld	s7,104(sp)
ffffffffc0204d5a:	7c06                	ld	s8,96(sp)
ffffffffc0204d5c:	6ce6                	ld	s9,88(sp)
ffffffffc0204d5e:	6d46                	ld	s10,80(sp)
ffffffffc0204d60:	6da6                	ld	s11,72(sp)
ffffffffc0204d62:	8552                	mv	a0,s4
ffffffffc0204d64:	6a0a                	ld	s4,128(sp)
ffffffffc0204d66:	614d                	addi	sp,sp,176
ffffffffc0204d68:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204d6a:	463d                	li	a2,15
ffffffffc0204d6c:	85ca                	mv	a1,s2
ffffffffc0204d6e:	1808                	addi	a0,sp,48
ffffffffc0204d70:	463000ef          	jal	ra,ffffffffc02059d2 <memcpy>
    if (mm != NULL)
ffffffffc0204d74:	e20991e3          	bnez	s3,ffffffffc0204b96 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204d78:	000db783          	ld	a5,0(s11)
ffffffffc0204d7c:	779c                	ld	a5,40(a5)
ffffffffc0204d7e:	e40788e3          	beqz	a5,ffffffffc0204bce <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204d82:	00003617          	auipc	a2,0x3
ffffffffc0204d86:	97e60613          	addi	a2,a2,-1666 # ffffffffc0207700 <default_pmm_manager+0xbe0>
ffffffffc0204d8a:	25a00593          	li	a1,602
ffffffffc0204d8e:	00002517          	auipc	a0,0x2
ffffffffc0204d92:	7d250513          	addi	a0,a0,2002 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204d96:	ef8fb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204d9a:	8526                	mv	a0,s1
ffffffffc0204d9c:	c7eff0ef          	jal	ra,ffffffffc020421a <put_pgdir>
    mm_destroy(mm);
ffffffffc0204da0:	8526                	mv	a0,s1
ffffffffc0204da2:	da9fe0ef          	jal	ra,ffffffffc0203b4a <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204da6:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204da8:	8552                	mv	a0,s4
ffffffffc0204daa:	94bff0ef          	jal	ra,ffffffffc02046f4 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204dae:	5a71                	li	s4,-4
ffffffffc0204db0:	bfe5                	j	ffffffffc0204da8 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204db2:	0289b603          	ld	a2,40(s3)
ffffffffc0204db6:	0209b783          	ld	a5,32(s3)
ffffffffc0204dba:	1cf66d63          	bltu	a2,a5,ffffffffc0204f94 <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204dbe:	0049a783          	lw	a5,4(s3)
ffffffffc0204dc2:	0017f693          	andi	a3,a5,1
ffffffffc0204dc6:	c291                	beqz	a3,ffffffffc0204dca <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204dc8:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204dca:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204dce:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204dd0:	e779                	bnez	a4,ffffffffc0204e9e <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204dd2:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204dd4:	c781                	beqz	a5,ffffffffc0204ddc <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204dd6:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204dda:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204ddc:	0026f793          	andi	a5,a3,2
ffffffffc0204de0:	e3f1                	bnez	a5,ffffffffc0204ea4 <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204de2:	0046f793          	andi	a5,a3,4
ffffffffc0204de6:	c399                	beqz	a5,ffffffffc0204dec <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204de8:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204dec:	0109b583          	ld	a1,16(s3)
ffffffffc0204df0:	4701                	li	a4,0
ffffffffc0204df2:	8526                	mv	a0,s1
ffffffffc0204df4:	da9fe0ef          	jal	ra,ffffffffc0203b9c <mm_map>
ffffffffc0204df8:	8a2a                	mv	s4,a0
ffffffffc0204dfa:	ed35                	bnez	a0,ffffffffc0204e76 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204dfc:	0109bb83          	ld	s7,16(s3)
ffffffffc0204e00:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204e02:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e06:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e0a:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e0e:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204e10:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e12:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204e14:	054be963          	bltu	s7,s4,ffffffffc0204e66 <do_execve+0x332>
ffffffffc0204e18:	aa95                	j	ffffffffc0204f8c <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e1a:	6785                	lui	a5,0x1
ffffffffc0204e1c:	415b8533          	sub	a0,s7,s5
ffffffffc0204e20:	9abe                	add	s5,s5,a5
ffffffffc0204e22:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204e26:	015a7463          	bgeu	s4,s5,ffffffffc0204e2e <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204e2a:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204e2e:	000cb683          	ld	a3,0(s9)
ffffffffc0204e32:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e34:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204e38:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e3c:	8699                	srai	a3,a3,0x6
ffffffffc0204e3e:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204e40:	67e2                	ld	a5,24(sp)
ffffffffc0204e42:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e46:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e48:	14b87863          	bgeu	a6,a1,ffffffffc0204f98 <do_execve+0x464>
ffffffffc0204e4c:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e50:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204e52:	9bb2                	add	s7,s7,a2
ffffffffc0204e54:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e56:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204e58:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e5a:	379000ef          	jal	ra,ffffffffc02059d2 <memcpy>
            start += size, from += size;
ffffffffc0204e5e:	6622                	ld	a2,8(sp)
ffffffffc0204e60:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204e62:	054bf363          	bgeu	s7,s4,ffffffffc0204ea8 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e66:	6c88                	ld	a0,24(s1)
ffffffffc0204e68:	866a                	mv	a2,s10
ffffffffc0204e6a:	85d6                	mv	a1,s5
ffffffffc0204e6c:	ab9fe0ef          	jal	ra,ffffffffc0203924 <pgdir_alloc_page>
ffffffffc0204e70:	842a                	mv	s0,a0
ffffffffc0204e72:	f545                	bnez	a0,ffffffffc0204e1a <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204e74:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204e76:	8526                	mv	a0,s1
ffffffffc0204e78:	e6ffe0ef          	jal	ra,ffffffffc0203ce6 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204e7c:	8526                	mv	a0,s1
ffffffffc0204e7e:	b9cff0ef          	jal	ra,ffffffffc020421a <put_pgdir>
    mm_destroy(mm);
ffffffffc0204e82:	8526                	mv	a0,s1
ffffffffc0204e84:	cc7fe0ef          	jal	ra,ffffffffc0203b4a <mm_destroy>
    return ret;
ffffffffc0204e88:	b705                	j	ffffffffc0204da8 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204e8a:	854e                	mv	a0,s3
ffffffffc0204e8c:	e5bfe0ef          	jal	ra,ffffffffc0203ce6 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204e90:	854e                	mv	a0,s3
ffffffffc0204e92:	b88ff0ef          	jal	ra,ffffffffc020421a <put_pgdir>
            mm_destroy(mm);
ffffffffc0204e96:	854e                	mv	a0,s3
ffffffffc0204e98:	cb3fe0ef          	jal	ra,ffffffffc0203b4a <mm_destroy>
ffffffffc0204e9c:	b32d                	j	ffffffffc0204bc6 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204e9e:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ea2:	fb95                	bnez	a5,ffffffffc0204dd6 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204ea4:	4d5d                	li	s10,23
ffffffffc0204ea6:	bf35                	j	ffffffffc0204de2 <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204ea8:	0109b683          	ld	a3,16(s3)
ffffffffc0204eac:	0289b903          	ld	s2,40(s3)
ffffffffc0204eb0:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204eb2:	075bfd63          	bgeu	s7,s5,ffffffffc0204f2c <do_execve+0x3f8>
            if (start == end)
ffffffffc0204eb6:	db790fe3          	beq	s2,s7,ffffffffc0204c74 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204eba:	6785                	lui	a5,0x1
ffffffffc0204ebc:	00fb8533          	add	a0,s7,a5
ffffffffc0204ec0:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204ec4:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204ec8:	0b597d63          	bgeu	s2,s5,ffffffffc0204f82 <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204ecc:	000cb683          	ld	a3,0(s9)
ffffffffc0204ed0:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204ed2:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204ed6:	40d406b3          	sub	a3,s0,a3
ffffffffc0204eda:	8699                	srai	a3,a3,0x6
ffffffffc0204edc:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204ede:	67e2                	ld	a5,24(sp)
ffffffffc0204ee0:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ee4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204ee6:	0ac5f963          	bgeu	a1,a2,ffffffffc0204f98 <do_execve+0x464>
ffffffffc0204eea:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204eee:	8652                	mv	a2,s4
ffffffffc0204ef0:	4581                	li	a1,0
ffffffffc0204ef2:	96c2                	add	a3,a3,a6
ffffffffc0204ef4:	9536                	add	a0,a0,a3
ffffffffc0204ef6:	2cb000ef          	jal	ra,ffffffffc02059c0 <memset>
            start += size;
ffffffffc0204efa:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204efe:	03597463          	bgeu	s2,s5,ffffffffc0204f26 <do_execve+0x3f2>
ffffffffc0204f02:	d6e909e3          	beq	s2,a4,ffffffffc0204c74 <do_execve+0x140>
ffffffffc0204f06:	00003697          	auipc	a3,0x3
ffffffffc0204f0a:	82268693          	addi	a3,a3,-2014 # ffffffffc0207728 <default_pmm_manager+0xc08>
ffffffffc0204f0e:	00002617          	auipc	a2,0x2
ffffffffc0204f12:	86260613          	addi	a2,a2,-1950 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204f16:	2c300593          	li	a1,707
ffffffffc0204f1a:	00002517          	auipc	a0,0x2
ffffffffc0204f1e:	64650513          	addi	a0,a0,1606 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204f22:	d6cfb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204f26:	ff5710e3          	bne	a4,s5,ffffffffc0204f06 <do_execve+0x3d2>
ffffffffc0204f2a:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204f2c:	d52bf4e3          	bgeu	s7,s2,ffffffffc0204c74 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204f30:	6c88                	ld	a0,24(s1)
ffffffffc0204f32:	866a                	mv	a2,s10
ffffffffc0204f34:	85d6                	mv	a1,s5
ffffffffc0204f36:	9effe0ef          	jal	ra,ffffffffc0203924 <pgdir_alloc_page>
ffffffffc0204f3a:	842a                	mv	s0,a0
ffffffffc0204f3c:	dd05                	beqz	a0,ffffffffc0204e74 <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204f3e:	6785                	lui	a5,0x1
ffffffffc0204f40:	415b8533          	sub	a0,s7,s5
ffffffffc0204f44:	9abe                	add	s5,s5,a5
ffffffffc0204f46:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204f4a:	01597463          	bgeu	s2,s5,ffffffffc0204f52 <do_execve+0x41e>
                size -= la - end;
ffffffffc0204f4e:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204f52:	000cb683          	ld	a3,0(s9)
ffffffffc0204f56:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204f58:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204f5c:	40d406b3          	sub	a3,s0,a3
ffffffffc0204f60:	8699                	srai	a3,a3,0x6
ffffffffc0204f62:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204f64:	67e2                	ld	a5,24(sp)
ffffffffc0204f66:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204f6a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204f6c:	02b87663          	bgeu	a6,a1,ffffffffc0204f98 <do_execve+0x464>
ffffffffc0204f70:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f74:	4581                	li	a1,0
            start += size;
ffffffffc0204f76:	9bb2                	add	s7,s7,a2
ffffffffc0204f78:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f7a:	9536                	add	a0,a0,a3
ffffffffc0204f7c:	245000ef          	jal	ra,ffffffffc02059c0 <memset>
ffffffffc0204f80:	b775                	j	ffffffffc0204f2c <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204f82:	417a8a33          	sub	s4,s5,s7
ffffffffc0204f86:	b799                	j	ffffffffc0204ecc <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204f88:	5a75                	li	s4,-3
ffffffffc0204f8a:	b3c1                	j	ffffffffc0204d4a <do_execve+0x216>
        while (start < end)
ffffffffc0204f8c:	86de                	mv	a3,s7
ffffffffc0204f8e:	bf39                	j	ffffffffc0204eac <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204f90:	5a71                	li	s4,-4
ffffffffc0204f92:	bdc5                	j	ffffffffc0204e82 <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204f94:	5a61                	li	s4,-8
ffffffffc0204f96:	b5c5                	j	ffffffffc0204e76 <do_execve+0x342>
ffffffffc0204f98:	00001617          	auipc	a2,0x1
ffffffffc0204f9c:	6e060613          	addi	a2,a2,1760 # ffffffffc0206678 <commands+0xa20>
ffffffffc0204fa0:	07100593          	li	a1,113
ffffffffc0204fa4:	00001517          	auipc	a0,0x1
ffffffffc0204fa8:	51c50513          	addi	a0,a0,1308 # ffffffffc02064c0 <commands+0x868>
ffffffffc0204fac:	ce2fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204fb0:	00002617          	auipc	a2,0x2
ffffffffc0204fb4:	c1860613          	addi	a2,a2,-1000 # ffffffffc0206bc8 <default_pmm_manager+0xa8>
ffffffffc0204fb8:	2e200593          	li	a1,738
ffffffffc0204fbc:	00002517          	auipc	a0,0x2
ffffffffc0204fc0:	5a450513          	addi	a0,a0,1444 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204fc4:	ccafb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204fc8:	00003697          	auipc	a3,0x3
ffffffffc0204fcc:	87868693          	addi	a3,a3,-1928 # ffffffffc0207840 <default_pmm_manager+0xd20>
ffffffffc0204fd0:	00001617          	auipc	a2,0x1
ffffffffc0204fd4:	7a060613          	addi	a2,a2,1952 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204fd8:	2dd00593          	li	a1,733
ffffffffc0204fdc:	00002517          	auipc	a0,0x2
ffffffffc0204fe0:	58450513          	addi	a0,a0,1412 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0204fe4:	caafb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204fe8:	00003697          	auipc	a3,0x3
ffffffffc0204fec:	81068693          	addi	a3,a3,-2032 # ffffffffc02077f8 <default_pmm_manager+0xcd8>
ffffffffc0204ff0:	00001617          	auipc	a2,0x1
ffffffffc0204ff4:	78060613          	addi	a2,a2,1920 # ffffffffc0206770 <commands+0xb18>
ffffffffc0204ff8:	2dc00593          	li	a1,732
ffffffffc0204ffc:	00002517          	auipc	a0,0x2
ffffffffc0205000:	56450513          	addi	a0,a0,1380 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0205004:	c8afb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205008:	00002697          	auipc	a3,0x2
ffffffffc020500c:	7a868693          	addi	a3,a3,1960 # ffffffffc02077b0 <default_pmm_manager+0xc90>
ffffffffc0205010:	00001617          	auipc	a2,0x1
ffffffffc0205014:	76060613          	addi	a2,a2,1888 # ffffffffc0206770 <commands+0xb18>
ffffffffc0205018:	2db00593          	li	a1,731
ffffffffc020501c:	00002517          	auipc	a0,0x2
ffffffffc0205020:	54450513          	addi	a0,a0,1348 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0205024:	c6afb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0205028:	00002697          	auipc	a3,0x2
ffffffffc020502c:	74068693          	addi	a3,a3,1856 # ffffffffc0207768 <default_pmm_manager+0xc48>
ffffffffc0205030:	00001617          	auipc	a2,0x1
ffffffffc0205034:	74060613          	addi	a2,a2,1856 # ffffffffc0206770 <commands+0xb18>
ffffffffc0205038:	2da00593          	li	a1,730
ffffffffc020503c:	00002517          	auipc	a0,0x2
ffffffffc0205040:	52450513          	addi	a0,a0,1316 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0205044:	c4afb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205048 <do_yield>:
    current->need_resched = 1;
ffffffffc0205048:	000bb797          	auipc	a5,0xbb
ffffffffc020504c:	0f87b783          	ld	a5,248(a5) # ffffffffc02c0140 <current>
ffffffffc0205050:	4705                	li	a4,1
ffffffffc0205052:	ef98                	sd	a4,24(a5)
}
ffffffffc0205054:	4501                	li	a0,0
ffffffffc0205056:	8082                	ret

ffffffffc0205058 <do_wait>:
{
ffffffffc0205058:	1101                	addi	sp,sp,-32
ffffffffc020505a:	e822                	sd	s0,16(sp)
ffffffffc020505c:	e426                	sd	s1,8(sp)
ffffffffc020505e:	ec06                	sd	ra,24(sp)
ffffffffc0205060:	842e                	mv	s0,a1
ffffffffc0205062:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0205064:	c999                	beqz	a1,ffffffffc020507a <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0205066:	000bb797          	auipc	a5,0xbb
ffffffffc020506a:	0da7b783          	ld	a5,218(a5) # ffffffffc02c0140 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc020506e:	7788                	ld	a0,40(a5)
ffffffffc0205070:	4685                	li	a3,1
ffffffffc0205072:	4611                	li	a2,4
ffffffffc0205074:	80cff0ef          	jal	ra,ffffffffc0204080 <user_mem_check>
ffffffffc0205078:	c909                	beqz	a0,ffffffffc020508a <do_wait+0x32>
ffffffffc020507a:	85a2                	mv	a1,s0
}
ffffffffc020507c:	6442                	ld	s0,16(sp)
ffffffffc020507e:	60e2                	ld	ra,24(sp)
ffffffffc0205080:	8526                	mv	a0,s1
ffffffffc0205082:	64a2                	ld	s1,8(sp)
ffffffffc0205084:	6105                	addi	sp,sp,32
ffffffffc0205086:	fb8ff06f          	j	ffffffffc020483e <do_wait.part.0>
ffffffffc020508a:	60e2                	ld	ra,24(sp)
ffffffffc020508c:	6442                	ld	s0,16(sp)
ffffffffc020508e:	64a2                	ld	s1,8(sp)
ffffffffc0205090:	5575                	li	a0,-3
ffffffffc0205092:	6105                	addi	sp,sp,32
ffffffffc0205094:	8082                	ret

ffffffffc0205096 <do_kill>:
{
ffffffffc0205096:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0205098:	6789                	lui	a5,0x2
{
ffffffffc020509a:	e406                	sd	ra,8(sp)
ffffffffc020509c:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc020509e:	fff5071b          	addiw	a4,a0,-1
ffffffffc02050a2:	17f9                	addi	a5,a5,-2
ffffffffc02050a4:	02e7e963          	bltu	a5,a4,ffffffffc02050d6 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050a8:	842a                	mv	s0,a0
ffffffffc02050aa:	45a9                	li	a1,10
ffffffffc02050ac:	2501                	sext.w	a0,a0
ffffffffc02050ae:	46c000ef          	jal	ra,ffffffffc020551a <hash32>
ffffffffc02050b2:	02051793          	slli	a5,a0,0x20
ffffffffc02050b6:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02050ba:	000b7797          	auipc	a5,0xb7
ffffffffc02050be:	01678793          	addi	a5,a5,22 # ffffffffc02bc0d0 <hash_list>
ffffffffc02050c2:	953e                	add	a0,a0,a5
ffffffffc02050c4:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc02050c6:	a029                	j	ffffffffc02050d0 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc02050c8:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02050cc:	00870b63          	beq	a4,s0,ffffffffc02050e2 <do_kill+0x4c>
ffffffffc02050d0:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02050d2:	fef51be3          	bne	a0,a5,ffffffffc02050c8 <do_kill+0x32>
    return -E_INVAL;
ffffffffc02050d6:	5475                	li	s0,-3
}
ffffffffc02050d8:	60a2                	ld	ra,8(sp)
ffffffffc02050da:	8522                	mv	a0,s0
ffffffffc02050dc:	6402                	ld	s0,0(sp)
ffffffffc02050de:	0141                	addi	sp,sp,16
ffffffffc02050e0:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc02050e2:	fd87a703          	lw	a4,-40(a5)
ffffffffc02050e6:	00177693          	andi	a3,a4,1
ffffffffc02050ea:	e295                	bnez	a3,ffffffffc020510e <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc02050ec:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc02050ee:	00176713          	ori	a4,a4,1
ffffffffc02050f2:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc02050f6:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc02050f8:	fe06d0e3          	bgez	a3,ffffffffc02050d8 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc02050fc:	f2878513          	addi	a0,a5,-216
ffffffffc0205100:	22e000ef          	jal	ra,ffffffffc020532e <wakeup_proc>
}
ffffffffc0205104:	60a2                	ld	ra,8(sp)
ffffffffc0205106:	8522                	mv	a0,s0
ffffffffc0205108:	6402                	ld	s0,0(sp)
ffffffffc020510a:	0141                	addi	sp,sp,16
ffffffffc020510c:	8082                	ret
        return -E_KILLED;
ffffffffc020510e:	545d                	li	s0,-9
ffffffffc0205110:	b7e1                	j	ffffffffc02050d8 <do_kill+0x42>

ffffffffc0205112 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0205112:	1101                	addi	sp,sp,-32
ffffffffc0205114:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205116:	000bb797          	auipc	a5,0xbb
ffffffffc020511a:	fba78793          	addi	a5,a5,-70 # ffffffffc02c00d0 <proc_list>
ffffffffc020511e:	ec06                	sd	ra,24(sp)
ffffffffc0205120:	e822                	sd	s0,16(sp)
ffffffffc0205122:	e04a                	sd	s2,0(sp)
ffffffffc0205124:	000b7497          	auipc	s1,0xb7
ffffffffc0205128:	fac48493          	addi	s1,s1,-84 # ffffffffc02bc0d0 <hash_list>
ffffffffc020512c:	e79c                	sd	a5,8(a5)
ffffffffc020512e:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0205130:	000bb717          	auipc	a4,0xbb
ffffffffc0205134:	fa070713          	addi	a4,a4,-96 # ffffffffc02c00d0 <proc_list>
ffffffffc0205138:	87a6                	mv	a5,s1
ffffffffc020513a:	e79c                	sd	a5,8(a5)
ffffffffc020513c:	e39c                	sd	a5,0(a5)
ffffffffc020513e:	07c1                	addi	a5,a5,16
ffffffffc0205140:	fef71de3          	bne	a4,a5,ffffffffc020513a <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205144:	fd9fe0ef          	jal	ra,ffffffffc020411c <alloc_proc>
ffffffffc0205148:	000bb917          	auipc	s2,0xbb
ffffffffc020514c:	00090913          	mv	s2,s2
ffffffffc0205150:	00a93023          	sd	a0,0(s2) # ffffffffc02c0148 <idleproc>
ffffffffc0205154:	0e050f63          	beqz	a0,ffffffffc0205252 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205158:	4789                	li	a5,2
ffffffffc020515a:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020515c:	00003797          	auipc	a5,0x3
ffffffffc0205160:	ea478793          	addi	a5,a5,-348 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205164:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205168:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc020516a:	4785                	li	a5,1
ffffffffc020516c:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020516e:	4641                	li	a2,16
ffffffffc0205170:	4581                	li	a1,0
ffffffffc0205172:	8522                	mv	a0,s0
ffffffffc0205174:	04d000ef          	jal	ra,ffffffffc02059c0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205178:	463d                	li	a2,15
ffffffffc020517a:	00002597          	auipc	a1,0x2
ffffffffc020517e:	72658593          	addi	a1,a1,1830 # ffffffffc02078a0 <default_pmm_manager+0xd80>
ffffffffc0205182:	8522                	mv	a0,s0
ffffffffc0205184:	04f000ef          	jal	ra,ffffffffc02059d2 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0205188:	000bb717          	auipc	a4,0xbb
ffffffffc020518c:	fd070713          	addi	a4,a4,-48 # ffffffffc02c0158 <nr_process>
ffffffffc0205190:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0205192:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205196:	4601                	li	a2,0
    nr_process++;
ffffffffc0205198:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020519a:	4581                	li	a1,0
ffffffffc020519c:	00000517          	auipc	a0,0x0
ffffffffc02051a0:	87450513          	addi	a0,a0,-1932 # ffffffffc0204a10 <init_main>
    nr_process++;
ffffffffc02051a4:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02051a6:	000bb797          	auipc	a5,0xbb
ffffffffc02051aa:	f8d7bd23          	sd	a3,-102(a5) # ffffffffc02c0140 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02051ae:	cf6ff0ef          	jal	ra,ffffffffc02046a4 <kernel_thread>
ffffffffc02051b2:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02051b4:	08a05363          	blez	a0,ffffffffc020523a <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc02051b8:	6789                	lui	a5,0x2
ffffffffc02051ba:	fff5071b          	addiw	a4,a0,-1
ffffffffc02051be:	17f9                	addi	a5,a5,-2
ffffffffc02051c0:	2501                	sext.w	a0,a0
ffffffffc02051c2:	02e7e363          	bltu	a5,a4,ffffffffc02051e8 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02051c6:	45a9                	li	a1,10
ffffffffc02051c8:	352000ef          	jal	ra,ffffffffc020551a <hash32>
ffffffffc02051cc:	02051793          	slli	a5,a0,0x20
ffffffffc02051d0:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02051d4:	96a6                	add	a3,a3,s1
ffffffffc02051d6:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02051d8:	a029                	j	ffffffffc02051e2 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc02051da:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c84>
ffffffffc02051de:	04870b63          	beq	a4,s0,ffffffffc0205234 <proc_init+0x122>
    return listelm->next;
ffffffffc02051e2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02051e4:	fef69be3          	bne	a3,a5,ffffffffc02051da <proc_init+0xc8>
    return NULL;
ffffffffc02051e8:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051ea:	0b478493          	addi	s1,a5,180
ffffffffc02051ee:	4641                	li	a2,16
ffffffffc02051f0:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02051f2:	000bb417          	auipc	s0,0xbb
ffffffffc02051f6:	f5e40413          	addi	s0,s0,-162 # ffffffffc02c0150 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051fa:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc02051fc:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051fe:	7c2000ef          	jal	ra,ffffffffc02059c0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205202:	463d                	li	a2,15
ffffffffc0205204:	00002597          	auipc	a1,0x2
ffffffffc0205208:	6c458593          	addi	a1,a1,1732 # ffffffffc02078c8 <default_pmm_manager+0xda8>
ffffffffc020520c:	8526                	mv	a0,s1
ffffffffc020520e:	7c4000ef          	jal	ra,ffffffffc02059d2 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205212:	00093783          	ld	a5,0(s2)
ffffffffc0205216:	cbb5                	beqz	a5,ffffffffc020528a <proc_init+0x178>
ffffffffc0205218:	43dc                	lw	a5,4(a5)
ffffffffc020521a:	eba5                	bnez	a5,ffffffffc020528a <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020521c:	601c                	ld	a5,0(s0)
ffffffffc020521e:	c7b1                	beqz	a5,ffffffffc020526a <proc_init+0x158>
ffffffffc0205220:	43d8                	lw	a4,4(a5)
ffffffffc0205222:	4785                	li	a5,1
ffffffffc0205224:	04f71363          	bne	a4,a5,ffffffffc020526a <proc_init+0x158>
}
ffffffffc0205228:	60e2                	ld	ra,24(sp)
ffffffffc020522a:	6442                	ld	s0,16(sp)
ffffffffc020522c:	64a2                	ld	s1,8(sp)
ffffffffc020522e:	6902                	ld	s2,0(sp)
ffffffffc0205230:	6105                	addi	sp,sp,32
ffffffffc0205232:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205234:	f2878793          	addi	a5,a5,-216
ffffffffc0205238:	bf4d                	j	ffffffffc02051ea <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc020523a:	00002617          	auipc	a2,0x2
ffffffffc020523e:	66e60613          	addi	a2,a2,1646 # ffffffffc02078a8 <default_pmm_manager+0xd88>
ffffffffc0205242:	40900593          	li	a1,1033
ffffffffc0205246:	00002517          	auipc	a0,0x2
ffffffffc020524a:	31a50513          	addi	a0,a0,794 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc020524e:	a40fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205252:	00002617          	auipc	a2,0x2
ffffffffc0205256:	63660613          	addi	a2,a2,1590 # ffffffffc0207888 <default_pmm_manager+0xd68>
ffffffffc020525a:	3fa00593          	li	a1,1018
ffffffffc020525e:	00002517          	auipc	a0,0x2
ffffffffc0205262:	30250513          	addi	a0,a0,770 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0205266:	a28fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020526a:	00002697          	auipc	a3,0x2
ffffffffc020526e:	68e68693          	addi	a3,a3,1678 # ffffffffc02078f8 <default_pmm_manager+0xdd8>
ffffffffc0205272:	00001617          	auipc	a2,0x1
ffffffffc0205276:	4fe60613          	addi	a2,a2,1278 # ffffffffc0206770 <commands+0xb18>
ffffffffc020527a:	41000593          	li	a1,1040
ffffffffc020527e:	00002517          	auipc	a0,0x2
ffffffffc0205282:	2e250513          	addi	a0,a0,738 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc0205286:	a08fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020528a:	00002697          	auipc	a3,0x2
ffffffffc020528e:	64668693          	addi	a3,a3,1606 # ffffffffc02078d0 <default_pmm_manager+0xdb0>
ffffffffc0205292:	00001617          	auipc	a2,0x1
ffffffffc0205296:	4de60613          	addi	a2,a2,1246 # ffffffffc0206770 <commands+0xb18>
ffffffffc020529a:	40f00593          	li	a1,1039
ffffffffc020529e:	00002517          	auipc	a0,0x2
ffffffffc02052a2:	2c250513          	addi	a0,a0,706 # ffffffffc0207560 <default_pmm_manager+0xa40>
ffffffffc02052a6:	9e8fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02052aa <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02052aa:	1141                	addi	sp,sp,-16
ffffffffc02052ac:	e022                	sd	s0,0(sp)
ffffffffc02052ae:	e406                	sd	ra,8(sp)
ffffffffc02052b0:	000bb417          	auipc	s0,0xbb
ffffffffc02052b4:	e9040413          	addi	s0,s0,-368 # ffffffffc02c0140 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02052b8:	6018                	ld	a4,0(s0)
ffffffffc02052ba:	6f1c                	ld	a5,24(a4)
ffffffffc02052bc:	dffd                	beqz	a5,ffffffffc02052ba <cpu_idle+0x10>
        {
            schedule();
ffffffffc02052be:	0f0000ef          	jal	ra,ffffffffc02053ae <schedule>
ffffffffc02052c2:	bfdd                	j	ffffffffc02052b8 <cpu_idle+0xe>

ffffffffc02052c4 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02052c4:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02052c8:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02052cc:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02052ce:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02052d0:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02052d4:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02052d8:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02052dc:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02052e0:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02052e4:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02052e8:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02052ec:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc02052f0:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02052f4:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02052f8:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02052fc:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205300:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205302:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205304:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205308:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020530c:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205310:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205314:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205318:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020531c:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205320:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205324:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205328:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020532c:	8082                	ret

ffffffffc020532e <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020532e:	4118                	lw	a4,0(a0)
{
ffffffffc0205330:	1101                	addi	sp,sp,-32
ffffffffc0205332:	ec06                	sd	ra,24(sp)
ffffffffc0205334:	e822                	sd	s0,16(sp)
ffffffffc0205336:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205338:	478d                	li	a5,3
ffffffffc020533a:	04f70b63          	beq	a4,a5,ffffffffc0205390 <wakeup_proc+0x62>
ffffffffc020533e:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205340:	100027f3          	csrr	a5,sstatus
ffffffffc0205344:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205346:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205348:	ef9d                	bnez	a5,ffffffffc0205386 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc020534a:	4789                	li	a5,2
ffffffffc020534c:	02f70163          	beq	a4,a5,ffffffffc020536e <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0205350:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205352:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0205356:	e491                	bnez	s1,ffffffffc0205362 <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205358:	60e2                	ld	ra,24(sp)
ffffffffc020535a:	6442                	ld	s0,16(sp)
ffffffffc020535c:	64a2                	ld	s1,8(sp)
ffffffffc020535e:	6105                	addi	sp,sp,32
ffffffffc0205360:	8082                	ret
ffffffffc0205362:	6442                	ld	s0,16(sp)
ffffffffc0205364:	60e2                	ld	ra,24(sp)
ffffffffc0205366:	64a2                	ld	s1,8(sp)
ffffffffc0205368:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020536a:	e44fb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc020536e:	00002617          	auipc	a2,0x2
ffffffffc0205372:	5ea60613          	addi	a2,a2,1514 # ffffffffc0207958 <default_pmm_manager+0xe38>
ffffffffc0205376:	45d1                	li	a1,20
ffffffffc0205378:	00002517          	auipc	a0,0x2
ffffffffc020537c:	5c850513          	addi	a0,a0,1480 # ffffffffc0207940 <default_pmm_manager+0xe20>
ffffffffc0205380:	976fb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc0205384:	bfc9                	j	ffffffffc0205356 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205386:	e2efb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020538a:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc020538c:	4485                	li	s1,1
ffffffffc020538e:	bf75                	j	ffffffffc020534a <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205390:	00002697          	auipc	a3,0x2
ffffffffc0205394:	59068693          	addi	a3,a3,1424 # ffffffffc0207920 <default_pmm_manager+0xe00>
ffffffffc0205398:	00001617          	auipc	a2,0x1
ffffffffc020539c:	3d860613          	addi	a2,a2,984 # ffffffffc0206770 <commands+0xb18>
ffffffffc02053a0:	45a5                	li	a1,9
ffffffffc02053a2:	00002517          	auipc	a0,0x2
ffffffffc02053a6:	59e50513          	addi	a0,a0,1438 # ffffffffc0207940 <default_pmm_manager+0xe20>
ffffffffc02053aa:	8e4fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02053ae <schedule>:

void schedule(void)
{
ffffffffc02053ae:	1141                	addi	sp,sp,-16
ffffffffc02053b0:	e406                	sd	ra,8(sp)
ffffffffc02053b2:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02053b4:	100027f3          	csrr	a5,sstatus
ffffffffc02053b8:	8b89                	andi	a5,a5,2
ffffffffc02053ba:	4401                	li	s0,0
ffffffffc02053bc:	efbd                	bnez	a5,ffffffffc020543a <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02053be:	000bb897          	auipc	a7,0xbb
ffffffffc02053c2:	d828b883          	ld	a7,-638(a7) # ffffffffc02c0140 <current>
ffffffffc02053c6:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02053ca:	000bb517          	auipc	a0,0xbb
ffffffffc02053ce:	d7e53503          	ld	a0,-642(a0) # ffffffffc02c0148 <idleproc>
ffffffffc02053d2:	04a88e63          	beq	a7,a0,ffffffffc020542e <schedule+0x80>
ffffffffc02053d6:	0c888693          	addi	a3,a7,200
ffffffffc02053da:	000bb617          	auipc	a2,0xbb
ffffffffc02053de:	cf660613          	addi	a2,a2,-778 # ffffffffc02c00d0 <proc_list>
        le = last;
ffffffffc02053e2:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02053e4:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02053e6:	4809                	li	a6,2
ffffffffc02053e8:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02053ea:	00c78863          	beq	a5,a2,ffffffffc02053fa <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc02053ee:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02053f2:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc02053f6:	03070163          	beq	a4,a6,ffffffffc0205418 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc02053fa:	fef697e3          	bne	a3,a5,ffffffffc02053e8 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02053fe:	ed89                	bnez	a1,ffffffffc0205418 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205400:	451c                	lw	a5,8(a0)
ffffffffc0205402:	2785                	addiw	a5,a5,1
ffffffffc0205404:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205406:	00a88463          	beq	a7,a0,ffffffffc020540e <schedule+0x60>
        {
            proc_run(next);
ffffffffc020540a:	e87fe0ef          	jal	ra,ffffffffc0204290 <proc_run>
    if (flag)
ffffffffc020540e:	e819                	bnez	s0,ffffffffc0205424 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205410:	60a2                	ld	ra,8(sp)
ffffffffc0205412:	6402                	ld	s0,0(sp)
ffffffffc0205414:	0141                	addi	sp,sp,16
ffffffffc0205416:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205418:	4198                	lw	a4,0(a1)
ffffffffc020541a:	4789                	li	a5,2
ffffffffc020541c:	fef712e3          	bne	a4,a5,ffffffffc0205400 <schedule+0x52>
ffffffffc0205420:	852e                	mv	a0,a1
ffffffffc0205422:	bff9                	j	ffffffffc0205400 <schedule+0x52>
}
ffffffffc0205424:	6402                	ld	s0,0(sp)
ffffffffc0205426:	60a2                	ld	ra,8(sp)
ffffffffc0205428:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020542a:	d84fb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020542e:	000bb617          	auipc	a2,0xbb
ffffffffc0205432:	ca260613          	addi	a2,a2,-862 # ffffffffc02c00d0 <proc_list>
ffffffffc0205436:	86b2                	mv	a3,a2
ffffffffc0205438:	b76d                	j	ffffffffc02053e2 <schedule+0x34>
        intr_disable();
ffffffffc020543a:	d7afb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020543e:	4405                	li	s0,1
ffffffffc0205440:	bfbd                	j	ffffffffc02053be <schedule+0x10>

ffffffffc0205442 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205442:	000bb797          	auipc	a5,0xbb
ffffffffc0205446:	cfe7b783          	ld	a5,-770(a5) # ffffffffc02c0140 <current>
}
ffffffffc020544a:	43c8                	lw	a0,4(a5)
ffffffffc020544c:	8082                	ret

ffffffffc020544e <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc020544e:	4501                	li	a0,0
ffffffffc0205450:	8082                	ret

ffffffffc0205452 <sys_putc>:
    cputchar(c);
ffffffffc0205452:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205454:	1141                	addi	sp,sp,-16
ffffffffc0205456:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205458:	d73fa0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc020545c:	60a2                	ld	ra,8(sp)
ffffffffc020545e:	4501                	li	a0,0
ffffffffc0205460:	0141                	addi	sp,sp,16
ffffffffc0205462:	8082                	ret

ffffffffc0205464 <sys_kill>:
    return do_kill(pid);
ffffffffc0205464:	4108                	lw	a0,0(a0)
ffffffffc0205466:	c31ff06f          	j	ffffffffc0205096 <do_kill>

ffffffffc020546a <sys_yield>:
    return do_yield();
ffffffffc020546a:	bdfff06f          	j	ffffffffc0205048 <do_yield>

ffffffffc020546e <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020546e:	6d14                	ld	a3,24(a0)
ffffffffc0205470:	6910                	ld	a2,16(a0)
ffffffffc0205472:	650c                	ld	a1,8(a0)
ffffffffc0205474:	6108                	ld	a0,0(a0)
ffffffffc0205476:	ebeff06f          	j	ffffffffc0204b34 <do_execve>

ffffffffc020547a <sys_wait>:
    return do_wait(pid, store);
ffffffffc020547a:	650c                	ld	a1,8(a0)
ffffffffc020547c:	4108                	lw	a0,0(a0)
ffffffffc020547e:	bdbff06f          	j	ffffffffc0205058 <do_wait>

ffffffffc0205482 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205482:	000bb797          	auipc	a5,0xbb
ffffffffc0205486:	cbe7b783          	ld	a5,-834(a5) # ffffffffc02c0140 <current>
ffffffffc020548a:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020548c:	4501                	li	a0,0
ffffffffc020548e:	6a0c                	ld	a1,16(a2)
ffffffffc0205490:	e6dfe06f          	j	ffffffffc02042fc <do_fork>

ffffffffc0205494 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205494:	4108                	lw	a0,0(a0)
ffffffffc0205496:	a5eff06f          	j	ffffffffc02046f4 <do_exit>

ffffffffc020549a <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc020549a:	715d                	addi	sp,sp,-80
ffffffffc020549c:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020549e:	000bb497          	auipc	s1,0xbb
ffffffffc02054a2:	ca248493          	addi	s1,s1,-862 # ffffffffc02c0140 <current>
ffffffffc02054a6:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02054a8:	e0a2                	sd	s0,64(sp)
ffffffffc02054aa:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02054ac:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02054ae:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02054b0:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02054b2:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02054b6:	0327ee63          	bltu	a5,s2,ffffffffc02054f2 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02054ba:	00391713          	slli	a4,s2,0x3
ffffffffc02054be:	00002797          	auipc	a5,0x2
ffffffffc02054c2:	50278793          	addi	a5,a5,1282 # ffffffffc02079c0 <syscalls>
ffffffffc02054c6:	97ba                	add	a5,a5,a4
ffffffffc02054c8:	639c                	ld	a5,0(a5)
ffffffffc02054ca:	c785                	beqz	a5,ffffffffc02054f2 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02054cc:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02054ce:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02054d0:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02054d2:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02054d4:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02054d6:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02054d8:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02054da:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02054dc:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02054de:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02054e0:	0028                	addi	a0,sp,8
ffffffffc02054e2:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02054e4:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02054e6:	e828                	sd	a0,80(s0)
}
ffffffffc02054e8:	6406                	ld	s0,64(sp)
ffffffffc02054ea:	74e2                	ld	s1,56(sp)
ffffffffc02054ec:	7942                	ld	s2,48(sp)
ffffffffc02054ee:	6161                	addi	sp,sp,80
ffffffffc02054f0:	8082                	ret
    print_trapframe(tf);
ffffffffc02054f2:	8522                	mv	a0,s0
ffffffffc02054f4:	ed8fb0ef          	jal	ra,ffffffffc0200bcc <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02054f8:	609c                	ld	a5,0(s1)
ffffffffc02054fa:	86ca                	mv	a3,s2
ffffffffc02054fc:	00002617          	auipc	a2,0x2
ffffffffc0205500:	47c60613          	addi	a2,a2,1148 # ffffffffc0207978 <default_pmm_manager+0xe58>
ffffffffc0205504:	43d8                	lw	a4,4(a5)
ffffffffc0205506:	06200593          	li	a1,98
ffffffffc020550a:	0b478793          	addi	a5,a5,180
ffffffffc020550e:	00002517          	auipc	a0,0x2
ffffffffc0205512:	49a50513          	addi	a0,a0,1178 # ffffffffc02079a8 <default_pmm_manager+0xe88>
ffffffffc0205516:	f79fa0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020551a <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020551a:	9e3707b7          	lui	a5,0x9e370
ffffffffc020551e:	2785                	addiw	a5,a5,1
ffffffffc0205520:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205524:	02000793          	li	a5,32
ffffffffc0205528:	9f8d                	subw	a5,a5,a1
}
ffffffffc020552a:	00f5553b          	srlw	a0,a0,a5
ffffffffc020552e:	8082                	ret

ffffffffc0205530 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205530:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205534:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205536:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020553a:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020553c:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205540:	f022                	sd	s0,32(sp)
ffffffffc0205542:	ec26                	sd	s1,24(sp)
ffffffffc0205544:	e84a                	sd	s2,16(sp)
ffffffffc0205546:	f406                	sd	ra,40(sp)
ffffffffc0205548:	e44e                	sd	s3,8(sp)
ffffffffc020554a:	84aa                	mv	s1,a0
ffffffffc020554c:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020554e:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205552:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205554:	03067e63          	bgeu	a2,a6,ffffffffc0205590 <printnum+0x60>
ffffffffc0205558:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020555a:	00805763          	blez	s0,ffffffffc0205568 <printnum+0x38>
ffffffffc020555e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205560:	85ca                	mv	a1,s2
ffffffffc0205562:	854e                	mv	a0,s3
ffffffffc0205564:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205566:	fc65                	bnez	s0,ffffffffc020555e <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205568:	1a02                	slli	s4,s4,0x20
ffffffffc020556a:	00002797          	auipc	a5,0x2
ffffffffc020556e:	55678793          	addi	a5,a5,1366 # ffffffffc0207ac0 <syscalls+0x100>
ffffffffc0205572:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205576:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205578:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020557a:	000a4503          	lbu	a0,0(s4)
}
ffffffffc020557e:	70a2                	ld	ra,40(sp)
ffffffffc0205580:	69a2                	ld	s3,8(sp)
ffffffffc0205582:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205584:	85ca                	mv	a1,s2
ffffffffc0205586:	87a6                	mv	a5,s1
}
ffffffffc0205588:	6942                	ld	s2,16(sp)
ffffffffc020558a:	64e2                	ld	s1,24(sp)
ffffffffc020558c:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020558e:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205590:	03065633          	divu	a2,a2,a6
ffffffffc0205594:	8722                	mv	a4,s0
ffffffffc0205596:	f9bff0ef          	jal	ra,ffffffffc0205530 <printnum>
ffffffffc020559a:	b7f9                	j	ffffffffc0205568 <printnum+0x38>

ffffffffc020559c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020559c:	7119                	addi	sp,sp,-128
ffffffffc020559e:	f4a6                	sd	s1,104(sp)
ffffffffc02055a0:	f0ca                	sd	s2,96(sp)
ffffffffc02055a2:	ecce                	sd	s3,88(sp)
ffffffffc02055a4:	e8d2                	sd	s4,80(sp)
ffffffffc02055a6:	e4d6                	sd	s5,72(sp)
ffffffffc02055a8:	e0da                	sd	s6,64(sp)
ffffffffc02055aa:	fc5e                	sd	s7,56(sp)
ffffffffc02055ac:	f06a                	sd	s10,32(sp)
ffffffffc02055ae:	fc86                	sd	ra,120(sp)
ffffffffc02055b0:	f8a2                	sd	s0,112(sp)
ffffffffc02055b2:	f862                	sd	s8,48(sp)
ffffffffc02055b4:	f466                	sd	s9,40(sp)
ffffffffc02055b6:	ec6e                	sd	s11,24(sp)
ffffffffc02055b8:	892a                	mv	s2,a0
ffffffffc02055ba:	84ae                	mv	s1,a1
ffffffffc02055bc:	8d32                	mv	s10,a2
ffffffffc02055be:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055c0:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02055c4:	5b7d                	li	s6,-1
ffffffffc02055c6:	00002a97          	auipc	s5,0x2
ffffffffc02055ca:	526a8a93          	addi	s5,s5,1318 # ffffffffc0207aec <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02055ce:	00002b97          	auipc	s7,0x2
ffffffffc02055d2:	73ab8b93          	addi	s7,s7,1850 # ffffffffc0207d08 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055d6:	000d4503          	lbu	a0,0(s10)
ffffffffc02055da:	001d0413          	addi	s0,s10,1
ffffffffc02055de:	01350a63          	beq	a0,s3,ffffffffc02055f2 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02055e2:	c121                	beqz	a0,ffffffffc0205622 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02055e4:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055e6:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02055e8:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055ea:	fff44503          	lbu	a0,-1(s0)
ffffffffc02055ee:	ff351ae3          	bne	a0,s3,ffffffffc02055e2 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055f2:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02055f6:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02055fa:	4c81                	li	s9,0
ffffffffc02055fc:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02055fe:	5c7d                	li	s8,-1
ffffffffc0205600:	5dfd                	li	s11,-1
ffffffffc0205602:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205606:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205608:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020560c:	0ff5f593          	zext.b	a1,a1
ffffffffc0205610:	00140d13          	addi	s10,s0,1
ffffffffc0205614:	04b56263          	bltu	a0,a1,ffffffffc0205658 <vprintfmt+0xbc>
ffffffffc0205618:	058a                	slli	a1,a1,0x2
ffffffffc020561a:	95d6                	add	a1,a1,s5
ffffffffc020561c:	4194                	lw	a3,0(a1)
ffffffffc020561e:	96d6                	add	a3,a3,s5
ffffffffc0205620:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205622:	70e6                	ld	ra,120(sp)
ffffffffc0205624:	7446                	ld	s0,112(sp)
ffffffffc0205626:	74a6                	ld	s1,104(sp)
ffffffffc0205628:	7906                	ld	s2,96(sp)
ffffffffc020562a:	69e6                	ld	s3,88(sp)
ffffffffc020562c:	6a46                	ld	s4,80(sp)
ffffffffc020562e:	6aa6                	ld	s5,72(sp)
ffffffffc0205630:	6b06                	ld	s6,64(sp)
ffffffffc0205632:	7be2                	ld	s7,56(sp)
ffffffffc0205634:	7c42                	ld	s8,48(sp)
ffffffffc0205636:	7ca2                	ld	s9,40(sp)
ffffffffc0205638:	7d02                	ld	s10,32(sp)
ffffffffc020563a:	6de2                	ld	s11,24(sp)
ffffffffc020563c:	6109                	addi	sp,sp,128
ffffffffc020563e:	8082                	ret
            padc = '0';
ffffffffc0205640:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205642:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205646:	846a                	mv	s0,s10
ffffffffc0205648:	00140d13          	addi	s10,s0,1
ffffffffc020564c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205650:	0ff5f593          	zext.b	a1,a1
ffffffffc0205654:	fcb572e3          	bgeu	a0,a1,ffffffffc0205618 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205658:	85a6                	mv	a1,s1
ffffffffc020565a:	02500513          	li	a0,37
ffffffffc020565e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205660:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205664:	8d22                	mv	s10,s0
ffffffffc0205666:	f73788e3          	beq	a5,s3,ffffffffc02055d6 <vprintfmt+0x3a>
ffffffffc020566a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020566e:	1d7d                	addi	s10,s10,-1
ffffffffc0205670:	ff379de3          	bne	a5,s3,ffffffffc020566a <vprintfmt+0xce>
ffffffffc0205674:	b78d                	j	ffffffffc02055d6 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205676:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020567a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020567e:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205680:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205684:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205688:	02d86463          	bltu	a6,a3,ffffffffc02056b0 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020568c:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205690:	002c169b          	slliw	a3,s8,0x2
ffffffffc0205694:	0186873b          	addw	a4,a3,s8
ffffffffc0205698:	0017171b          	slliw	a4,a4,0x1
ffffffffc020569c:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc020569e:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02056a2:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02056a4:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02056a8:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02056ac:	fed870e3          	bgeu	a6,a3,ffffffffc020568c <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02056b0:	f40ddce3          	bgez	s11,ffffffffc0205608 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02056b4:	8de2                	mv	s11,s8
ffffffffc02056b6:	5c7d                	li	s8,-1
ffffffffc02056b8:	bf81                	j	ffffffffc0205608 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02056ba:	fffdc693          	not	a3,s11
ffffffffc02056be:	96fd                	srai	a3,a3,0x3f
ffffffffc02056c0:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056c4:	00144603          	lbu	a2,1(s0)
ffffffffc02056c8:	2d81                	sext.w	s11,s11
ffffffffc02056ca:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02056cc:	bf35                	j	ffffffffc0205608 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02056ce:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056d2:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02056d6:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056d8:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02056da:	bfd9                	j	ffffffffc02056b0 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02056dc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056de:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02056e2:	01174463          	blt	a4,a7,ffffffffc02056ea <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02056e6:	1a088e63          	beqz	a7,ffffffffc02058a2 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02056ea:	000a3603          	ld	a2,0(s4)
ffffffffc02056ee:	46c1                	li	a3,16
ffffffffc02056f0:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02056f2:	2781                	sext.w	a5,a5
ffffffffc02056f4:	876e                	mv	a4,s11
ffffffffc02056f6:	85a6                	mv	a1,s1
ffffffffc02056f8:	854a                	mv	a0,s2
ffffffffc02056fa:	e37ff0ef          	jal	ra,ffffffffc0205530 <printnum>
            break;
ffffffffc02056fe:	bde1                	j	ffffffffc02055d6 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205700:	000a2503          	lw	a0,0(s4)
ffffffffc0205704:	85a6                	mv	a1,s1
ffffffffc0205706:	0a21                	addi	s4,s4,8
ffffffffc0205708:	9902                	jalr	s2
            break;
ffffffffc020570a:	b5f1                	j	ffffffffc02055d6 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020570c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020570e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205712:	01174463          	blt	a4,a7,ffffffffc020571a <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205716:	18088163          	beqz	a7,ffffffffc0205898 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020571a:	000a3603          	ld	a2,0(s4)
ffffffffc020571e:	46a9                	li	a3,10
ffffffffc0205720:	8a2e                	mv	s4,a1
ffffffffc0205722:	bfc1                	j	ffffffffc02056f2 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205724:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205728:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020572a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020572c:	bdf1                	j	ffffffffc0205608 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020572e:	85a6                	mv	a1,s1
ffffffffc0205730:	02500513          	li	a0,37
ffffffffc0205734:	9902                	jalr	s2
            break;
ffffffffc0205736:	b545                	j	ffffffffc02055d6 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205738:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020573c:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020573e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205740:	b5e1                	j	ffffffffc0205608 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205742:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205744:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205748:	01174463          	blt	a4,a7,ffffffffc0205750 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020574c:	14088163          	beqz	a7,ffffffffc020588e <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205750:	000a3603          	ld	a2,0(s4)
ffffffffc0205754:	46a1                	li	a3,8
ffffffffc0205756:	8a2e                	mv	s4,a1
ffffffffc0205758:	bf69                	j	ffffffffc02056f2 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020575a:	03000513          	li	a0,48
ffffffffc020575e:	85a6                	mv	a1,s1
ffffffffc0205760:	e03e                	sd	a5,0(sp)
ffffffffc0205762:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205764:	85a6                	mv	a1,s1
ffffffffc0205766:	07800513          	li	a0,120
ffffffffc020576a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020576c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020576e:	6782                	ld	a5,0(sp)
ffffffffc0205770:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205772:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205776:	bfb5                	j	ffffffffc02056f2 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205778:	000a3403          	ld	s0,0(s4)
ffffffffc020577c:	008a0713          	addi	a4,s4,8
ffffffffc0205780:	e03a                	sd	a4,0(sp)
ffffffffc0205782:	14040263          	beqz	s0,ffffffffc02058c6 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205786:	0fb05763          	blez	s11,ffffffffc0205874 <vprintfmt+0x2d8>
ffffffffc020578a:	02d00693          	li	a3,45
ffffffffc020578e:	0cd79163          	bne	a5,a3,ffffffffc0205850 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205792:	00044783          	lbu	a5,0(s0)
ffffffffc0205796:	0007851b          	sext.w	a0,a5
ffffffffc020579a:	cf85                	beqz	a5,ffffffffc02057d2 <vprintfmt+0x236>
ffffffffc020579c:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057a0:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057a4:	000c4563          	bltz	s8,ffffffffc02057ae <vprintfmt+0x212>
ffffffffc02057a8:	3c7d                	addiw	s8,s8,-1
ffffffffc02057aa:	036c0263          	beq	s8,s6,ffffffffc02057ce <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02057ae:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057b0:	0e0c8e63          	beqz	s9,ffffffffc02058ac <vprintfmt+0x310>
ffffffffc02057b4:	3781                	addiw	a5,a5,-32
ffffffffc02057b6:	0ef47b63          	bgeu	s0,a5,ffffffffc02058ac <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02057ba:	03f00513          	li	a0,63
ffffffffc02057be:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057c0:	000a4783          	lbu	a5,0(s4)
ffffffffc02057c4:	3dfd                	addiw	s11,s11,-1
ffffffffc02057c6:	0a05                	addi	s4,s4,1
ffffffffc02057c8:	0007851b          	sext.w	a0,a5
ffffffffc02057cc:	ffe1                	bnez	a5,ffffffffc02057a4 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02057ce:	01b05963          	blez	s11,ffffffffc02057e0 <vprintfmt+0x244>
ffffffffc02057d2:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02057d4:	85a6                	mv	a1,s1
ffffffffc02057d6:	02000513          	li	a0,32
ffffffffc02057da:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02057dc:	fe0d9be3          	bnez	s11,ffffffffc02057d2 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02057e0:	6a02                	ld	s4,0(sp)
ffffffffc02057e2:	bbd5                	j	ffffffffc02055d6 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02057e4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02057e6:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02057ea:	01174463          	blt	a4,a7,ffffffffc02057f2 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02057ee:	08088d63          	beqz	a7,ffffffffc0205888 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02057f2:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02057f6:	0a044d63          	bltz	s0,ffffffffc02058b0 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02057fa:	8622                	mv	a2,s0
ffffffffc02057fc:	8a66                	mv	s4,s9
ffffffffc02057fe:	46a9                	li	a3,10
ffffffffc0205800:	bdcd                	j	ffffffffc02056f2 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205802:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205806:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205808:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020580a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020580e:	8fb5                	xor	a5,a5,a3
ffffffffc0205810:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205814:	02d74163          	blt	a4,a3,ffffffffc0205836 <vprintfmt+0x29a>
ffffffffc0205818:	00369793          	slli	a5,a3,0x3
ffffffffc020581c:	97de                	add	a5,a5,s7
ffffffffc020581e:	639c                	ld	a5,0(a5)
ffffffffc0205820:	cb99                	beqz	a5,ffffffffc0205836 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205822:	86be                	mv	a3,a5
ffffffffc0205824:	00000617          	auipc	a2,0x0
ffffffffc0205828:	1f460613          	addi	a2,a2,500 # ffffffffc0205a18 <etext+0x2e>
ffffffffc020582c:	85a6                	mv	a1,s1
ffffffffc020582e:	854a                	mv	a0,s2
ffffffffc0205830:	0ce000ef          	jal	ra,ffffffffc02058fe <printfmt>
ffffffffc0205834:	b34d                	j	ffffffffc02055d6 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205836:	00002617          	auipc	a2,0x2
ffffffffc020583a:	2aa60613          	addi	a2,a2,682 # ffffffffc0207ae0 <syscalls+0x120>
ffffffffc020583e:	85a6                	mv	a1,s1
ffffffffc0205840:	854a                	mv	a0,s2
ffffffffc0205842:	0bc000ef          	jal	ra,ffffffffc02058fe <printfmt>
ffffffffc0205846:	bb41                	j	ffffffffc02055d6 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205848:	00002417          	auipc	s0,0x2
ffffffffc020584c:	29040413          	addi	s0,s0,656 # ffffffffc0207ad8 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205850:	85e2                	mv	a1,s8
ffffffffc0205852:	8522                	mv	a0,s0
ffffffffc0205854:	e43e                	sd	a5,8(sp)
ffffffffc0205856:	0e2000ef          	jal	ra,ffffffffc0205938 <strnlen>
ffffffffc020585a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020585e:	01b05b63          	blez	s11,ffffffffc0205874 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205862:	67a2                	ld	a5,8(sp)
ffffffffc0205864:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205868:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020586a:	85a6                	mv	a1,s1
ffffffffc020586c:	8552                	mv	a0,s4
ffffffffc020586e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205870:	fe0d9ce3          	bnez	s11,ffffffffc0205868 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205874:	00044783          	lbu	a5,0(s0)
ffffffffc0205878:	00140a13          	addi	s4,s0,1
ffffffffc020587c:	0007851b          	sext.w	a0,a5
ffffffffc0205880:	d3a5                	beqz	a5,ffffffffc02057e0 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205882:	05e00413          	li	s0,94
ffffffffc0205886:	bf39                	j	ffffffffc02057a4 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0205888:	000a2403          	lw	s0,0(s4)
ffffffffc020588c:	b7ad                	j	ffffffffc02057f6 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc020588e:	000a6603          	lwu	a2,0(s4)
ffffffffc0205892:	46a1                	li	a3,8
ffffffffc0205894:	8a2e                	mv	s4,a1
ffffffffc0205896:	bdb1                	j	ffffffffc02056f2 <vprintfmt+0x156>
ffffffffc0205898:	000a6603          	lwu	a2,0(s4)
ffffffffc020589c:	46a9                	li	a3,10
ffffffffc020589e:	8a2e                	mv	s4,a1
ffffffffc02058a0:	bd89                	j	ffffffffc02056f2 <vprintfmt+0x156>
ffffffffc02058a2:	000a6603          	lwu	a2,0(s4)
ffffffffc02058a6:	46c1                	li	a3,16
ffffffffc02058a8:	8a2e                	mv	s4,a1
ffffffffc02058aa:	b5a1                	j	ffffffffc02056f2 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02058ac:	9902                	jalr	s2
ffffffffc02058ae:	bf09                	j	ffffffffc02057c0 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02058b0:	85a6                	mv	a1,s1
ffffffffc02058b2:	02d00513          	li	a0,45
ffffffffc02058b6:	e03e                	sd	a5,0(sp)
ffffffffc02058b8:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02058ba:	6782                	ld	a5,0(sp)
ffffffffc02058bc:	8a66                	mv	s4,s9
ffffffffc02058be:	40800633          	neg	a2,s0
ffffffffc02058c2:	46a9                	li	a3,10
ffffffffc02058c4:	b53d                	j	ffffffffc02056f2 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02058c6:	03b05163          	blez	s11,ffffffffc02058e8 <vprintfmt+0x34c>
ffffffffc02058ca:	02d00693          	li	a3,45
ffffffffc02058ce:	f6d79de3          	bne	a5,a3,ffffffffc0205848 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02058d2:	00002417          	auipc	s0,0x2
ffffffffc02058d6:	20640413          	addi	s0,s0,518 # ffffffffc0207ad8 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02058da:	02800793          	li	a5,40
ffffffffc02058de:	02800513          	li	a0,40
ffffffffc02058e2:	00140a13          	addi	s4,s0,1
ffffffffc02058e6:	bd6d                	j	ffffffffc02057a0 <vprintfmt+0x204>
ffffffffc02058e8:	00002a17          	auipc	s4,0x2
ffffffffc02058ec:	1f1a0a13          	addi	s4,s4,497 # ffffffffc0207ad9 <syscalls+0x119>
ffffffffc02058f0:	02800513          	li	a0,40
ffffffffc02058f4:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02058f8:	05e00413          	li	s0,94
ffffffffc02058fc:	b565                	j	ffffffffc02057a4 <vprintfmt+0x208>

ffffffffc02058fe <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02058fe:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205900:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205904:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205906:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205908:	ec06                	sd	ra,24(sp)
ffffffffc020590a:	f83a                	sd	a4,48(sp)
ffffffffc020590c:	fc3e                	sd	a5,56(sp)
ffffffffc020590e:	e0c2                	sd	a6,64(sp)
ffffffffc0205910:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205912:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205914:	c89ff0ef          	jal	ra,ffffffffc020559c <vprintfmt>
}
ffffffffc0205918:	60e2                	ld	ra,24(sp)
ffffffffc020591a:	6161                	addi	sp,sp,80
ffffffffc020591c:	8082                	ret

ffffffffc020591e <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020591e:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205922:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0205924:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205926:	cb81                	beqz	a5,ffffffffc0205936 <strlen+0x18>
        cnt ++;
ffffffffc0205928:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020592a:	00a707b3          	add	a5,a4,a0
ffffffffc020592e:	0007c783          	lbu	a5,0(a5)
ffffffffc0205932:	fbfd                	bnez	a5,ffffffffc0205928 <strlen+0xa>
ffffffffc0205934:	8082                	ret
    }
    return cnt;
}
ffffffffc0205936:	8082                	ret

ffffffffc0205938 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205938:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020593a:	e589                	bnez	a1,ffffffffc0205944 <strnlen+0xc>
ffffffffc020593c:	a811                	j	ffffffffc0205950 <strnlen+0x18>
        cnt ++;
ffffffffc020593e:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205940:	00f58863          	beq	a1,a5,ffffffffc0205950 <strnlen+0x18>
ffffffffc0205944:	00f50733          	add	a4,a0,a5
ffffffffc0205948:	00074703          	lbu	a4,0(a4)
ffffffffc020594c:	fb6d                	bnez	a4,ffffffffc020593e <strnlen+0x6>
ffffffffc020594e:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205950:	852e                	mv	a0,a1
ffffffffc0205952:	8082                	ret

ffffffffc0205954 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205954:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205956:	0005c703          	lbu	a4,0(a1)
ffffffffc020595a:	0785                	addi	a5,a5,1
ffffffffc020595c:	0585                	addi	a1,a1,1
ffffffffc020595e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205962:	fb75                	bnez	a4,ffffffffc0205956 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205964:	8082                	ret

ffffffffc0205966 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205966:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020596a:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020596e:	cb89                	beqz	a5,ffffffffc0205980 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205970:	0505                	addi	a0,a0,1
ffffffffc0205972:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205974:	fee789e3          	beq	a5,a4,ffffffffc0205966 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205978:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020597c:	9d19                	subw	a0,a0,a4
ffffffffc020597e:	8082                	ret
ffffffffc0205980:	4501                	li	a0,0
ffffffffc0205982:	bfed                	j	ffffffffc020597c <strcmp+0x16>

ffffffffc0205984 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205984:	c20d                	beqz	a2,ffffffffc02059a6 <strncmp+0x22>
ffffffffc0205986:	962e                	add	a2,a2,a1
ffffffffc0205988:	a031                	j	ffffffffc0205994 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc020598a:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020598c:	00e79a63          	bne	a5,a4,ffffffffc02059a0 <strncmp+0x1c>
ffffffffc0205990:	00b60b63          	beq	a2,a1,ffffffffc02059a6 <strncmp+0x22>
ffffffffc0205994:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205998:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020599a:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020599e:	f7f5                	bnez	a5,ffffffffc020598a <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059a0:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02059a4:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059a6:	4501                	li	a0,0
ffffffffc02059a8:	8082                	ret

ffffffffc02059aa <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02059aa:	00054783          	lbu	a5,0(a0)
ffffffffc02059ae:	c799                	beqz	a5,ffffffffc02059bc <strchr+0x12>
        if (*s == c) {
ffffffffc02059b0:	00f58763          	beq	a1,a5,ffffffffc02059be <strchr+0x14>
    while (*s != '\0') {
ffffffffc02059b4:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02059b8:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02059ba:	fbfd                	bnez	a5,ffffffffc02059b0 <strchr+0x6>
    }
    return NULL;
ffffffffc02059bc:	4501                	li	a0,0
}
ffffffffc02059be:	8082                	ret

ffffffffc02059c0 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02059c0:	ca01                	beqz	a2,ffffffffc02059d0 <memset+0x10>
ffffffffc02059c2:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02059c4:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02059c6:	0785                	addi	a5,a5,1
ffffffffc02059c8:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02059cc:	fec79de3          	bne	a5,a2,ffffffffc02059c6 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02059d0:	8082                	ret

ffffffffc02059d2 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02059d2:	ca19                	beqz	a2,ffffffffc02059e8 <memcpy+0x16>
ffffffffc02059d4:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02059d6:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02059d8:	0005c703          	lbu	a4,0(a1)
ffffffffc02059dc:	0585                	addi	a1,a1,1
ffffffffc02059de:	0785                	addi	a5,a5,1
ffffffffc02059e0:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02059e4:	fec59ae3          	bne	a1,a2,ffffffffc02059d8 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02059e8:	8082                	ret
