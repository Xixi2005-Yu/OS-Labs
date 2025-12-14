
obj/__user_dirtycow_test.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
.text
.globl _start
_start:
    # call user-program function
    call umain
  800020:	0cc000ef          	jal	ra,8000ec <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800026:	1141                	addi	sp,sp,-16
  800028:	e022                	sd	s0,0(sp)
  80002a:	e406                	sd	ra,8(sp)
  80002c:	842e                	mv	s0,a1
    sys_putc(c);
  80002e:	098000ef          	jal	ra,8000c6 <sys_putc>
    (*cnt) ++;
  800032:	401c                	lw	a5,0(s0)
}
  800034:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800036:	2785                	addiw	a5,a5,1
  800038:	c01c                	sw	a5,0(s0)
}
  80003a:	6402                	ld	s0,0(sp)
  80003c:	0141                	addi	sp,sp,16
  80003e:	8082                	ret

0000000000800040 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800040:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800042:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  800046:	8e2a                	mv	t3,a0
  800048:	f42e                	sd	a1,40(sp)
  80004a:	f832                	sd	a2,48(sp)
  80004c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004e:	00000517          	auipc	a0,0x0
  800052:	fd850513          	addi	a0,a0,-40 # 800026 <cputch>
  800056:	004c                	addi	a1,sp,4
  800058:	869a                	mv	a3,t1
  80005a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  80005c:	ec06                	sd	ra,24(sp)
  80005e:	e0ba                	sd	a4,64(sp)
  800060:	e4be                	sd	a5,72(sp)
  800062:	e8c2                	sd	a6,80(sp)
  800064:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  800066:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  800068:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80006a:	0fa000ef          	jal	ra,800164 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006e:	60e2                	ld	ra,24(sp)
  800070:	4512                	lw	a0,4(sp)
  800072:	6125                	addi	sp,sp,96
  800074:	8082                	ret

0000000000800076 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800076:	7175                	addi	sp,sp,-144
  800078:	f8ba                	sd	a4,112(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  80007a:	e0ba                	sd	a4,64(sp)
  80007c:	0118                	addi	a4,sp,128
syscall(int64_t num, ...) {
  80007e:	e42a                	sd	a0,8(sp)
  800080:	ecae                	sd	a1,88(sp)
  800082:	f0b2                	sd	a2,96(sp)
  800084:	f4b6                	sd	a3,104(sp)
  800086:	fcbe                	sd	a5,120(sp)
  800088:	e142                	sd	a6,128(sp)
  80008a:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  80008c:	f42e                	sd	a1,40(sp)
  80008e:	f832                	sd	a2,48(sp)
  800090:	fc36                	sd	a3,56(sp)
  800092:	f03a                	sd	a4,32(sp)
  800094:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);

    asm volatile (
  800096:	6522                	ld	a0,8(sp)
  800098:	75a2                	ld	a1,40(sp)
  80009a:	7642                	ld	a2,48(sp)
  80009c:	76e2                	ld	a3,56(sp)
  80009e:	6706                	ld	a4,64(sp)
  8000a0:	67a6                	ld	a5,72(sp)
  8000a2:	00000073          	ecall
  8000a6:	00a13e23          	sd	a0,28(sp)
        "sd a0, %0"
        : "=m" (ret)
        : "m"(num), "m"(a[0]), "m"(a[1]), "m"(a[2]), "m"(a[3]), "m"(a[4])
        :"memory");
    return ret;
}
  8000aa:	4572                	lw	a0,28(sp)
  8000ac:	6149                	addi	sp,sp,144
  8000ae:	8082                	ret

00000000008000b0 <sys_exit>:

int
sys_exit(int64_t error_code) {
  8000b0:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  8000b2:	4505                	li	a0,1
  8000b4:	b7c9                	j	800076 <syscall>

00000000008000b6 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  8000b6:	4509                	li	a0,2
  8000b8:	bf7d                	j	800076 <syscall>

00000000008000ba <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  8000ba:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  8000bc:	85aa                	mv	a1,a0
  8000be:	450d                	li	a0,3
  8000c0:	bf5d                	j	800076 <syscall>

00000000008000c2 <sys_yield>:
}

int
sys_yield(void) {
    return syscall(SYS_yield);
  8000c2:	4529                	li	a0,10
  8000c4:	bf4d                	j	800076 <syscall>

00000000008000c6 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  8000c6:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000c8:	4579                	li	a0,30
  8000ca:	b775                	j	800076 <syscall>

00000000008000cc <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000cc:	1141                	addi	sp,sp,-16
  8000ce:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000d0:	fe1ff0ef          	jal	ra,8000b0 <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000d4:	00000517          	auipc	a0,0x0
  8000d8:	71c50513          	addi	a0,a0,1820 # 8007f0 <main+0x124>
  8000dc:	f65ff0ef          	jal	ra,800040 <cprintf>
    while (1);
  8000e0:	a001                	j	8000e0 <exit+0x14>

00000000008000e2 <fork>:
}

int
fork(void) {
    return sys_fork();
  8000e2:	bfd1                	j	8000b6 <sys_fork>

00000000008000e4 <wait>:
}

int
wait(void) {
    return sys_wait(0, NULL);
  8000e4:	4581                	li	a1,0
  8000e6:	4501                	li	a0,0
  8000e8:	bfc9                	j	8000ba <sys_wait>

00000000008000ea <yield>:
    return sys_wait(pid, store);
}

void
yield(void) {
    sys_yield();
  8000ea:	bfe1                	j	8000c2 <sys_yield>

00000000008000ec <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000ec:	1141                	addi	sp,sp,-16
  8000ee:	e406                	sd	ra,8(sp)
    int ret = main();
  8000f0:	5dc000ef          	jal	ra,8006cc <main>
    exit(ret);
  8000f4:	fd9ff0ef          	jal	ra,8000cc <exit>

00000000008000f8 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000f8:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000fc:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  8000fe:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800102:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  800104:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800108:	f022                	sd	s0,32(sp)
  80010a:	ec26                	sd	s1,24(sp)
  80010c:	e84a                	sd	s2,16(sp)
  80010e:	f406                	sd	ra,40(sp)
  800110:	e44e                	sd	s3,8(sp)
  800112:	84aa                	mv	s1,a0
  800114:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800116:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  80011a:	2a01                	sext.w	s4,s4
    if (num >= base) {
  80011c:	03067e63          	bgeu	a2,a6,800158 <printnum+0x60>
  800120:	89be                	mv	s3,a5
        while (-- width > 0)
  800122:	00805763          	blez	s0,800130 <printnum+0x38>
  800126:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800128:	85ca                	mv	a1,s2
  80012a:	854e                	mv	a0,s3
  80012c:	9482                	jalr	s1
        while (-- width > 0)
  80012e:	fc65                	bnez	s0,800126 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800130:	1a02                	slli	s4,s4,0x20
  800132:	00000797          	auipc	a5,0x0
  800136:	6d678793          	addi	a5,a5,1750 # 800808 <main+0x13c>
  80013a:	020a5a13          	srli	s4,s4,0x20
  80013e:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  800140:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  800142:	000a4503          	lbu	a0,0(s4)
}
  800146:	70a2                	ld	ra,40(sp)
  800148:	69a2                	ld	s3,8(sp)
  80014a:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  80014c:	85ca                	mv	a1,s2
  80014e:	87a6                	mv	a5,s1
}
  800150:	6942                	ld	s2,16(sp)
  800152:	64e2                	ld	s1,24(sp)
  800154:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  800156:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  800158:	03065633          	divu	a2,a2,a6
  80015c:	8722                	mv	a4,s0
  80015e:	f9bff0ef          	jal	ra,8000f8 <printnum>
  800162:	b7f9                	j	800130 <printnum+0x38>

0000000000800164 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800164:	7119                	addi	sp,sp,-128
  800166:	f4a6                	sd	s1,104(sp)
  800168:	f0ca                	sd	s2,96(sp)
  80016a:	ecce                	sd	s3,88(sp)
  80016c:	e8d2                	sd	s4,80(sp)
  80016e:	e4d6                	sd	s5,72(sp)
  800170:	e0da                	sd	s6,64(sp)
  800172:	fc5e                	sd	s7,56(sp)
  800174:	f06a                	sd	s10,32(sp)
  800176:	fc86                	sd	ra,120(sp)
  800178:	f8a2                	sd	s0,112(sp)
  80017a:	f862                	sd	s8,48(sp)
  80017c:	f466                	sd	s9,40(sp)
  80017e:	ec6e                	sd	s11,24(sp)
  800180:	892a                	mv	s2,a0
  800182:	84ae                	mv	s1,a1
  800184:	8d32                	mv	s10,a2
  800186:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800188:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  80018c:	5b7d                	li	s6,-1
  80018e:	00000a97          	auipc	s5,0x0
  800192:	6aea8a93          	addi	s5,s5,1710 # 80083c <main+0x170>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800196:	00001b97          	auipc	s7,0x1
  80019a:	8c2b8b93          	addi	s7,s7,-1854 # 800a58 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80019e:	000d4503          	lbu	a0,0(s10)
  8001a2:	001d0413          	addi	s0,s10,1
  8001a6:	01350a63          	beq	a0,s3,8001ba <vprintfmt+0x56>
            if (ch == '\0') {
  8001aa:	c121                	beqz	a0,8001ea <vprintfmt+0x86>
            putch(ch, putdat);
  8001ac:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001ae:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  8001b0:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001b2:	fff44503          	lbu	a0,-1(s0)
  8001b6:	ff351ae3          	bne	a0,s3,8001aa <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  8001ba:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  8001be:	02000793          	li	a5,32
        lflag = altflag = 0;
  8001c2:	4c81                	li	s9,0
  8001c4:	4881                	li	a7,0
        width = precision = -1;
  8001c6:	5c7d                	li	s8,-1
  8001c8:	5dfd                	li	s11,-1
  8001ca:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  8001ce:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  8001d0:	fdd6059b          	addiw	a1,a2,-35
  8001d4:	0ff5f593          	zext.b	a1,a1
  8001d8:	00140d13          	addi	s10,s0,1
  8001dc:	04b56263          	bltu	a0,a1,800220 <vprintfmt+0xbc>
  8001e0:	058a                	slli	a1,a1,0x2
  8001e2:	95d6                	add	a1,a1,s5
  8001e4:	4194                	lw	a3,0(a1)
  8001e6:	96d6                	add	a3,a3,s5
  8001e8:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8001ea:	70e6                	ld	ra,120(sp)
  8001ec:	7446                	ld	s0,112(sp)
  8001ee:	74a6                	ld	s1,104(sp)
  8001f0:	7906                	ld	s2,96(sp)
  8001f2:	69e6                	ld	s3,88(sp)
  8001f4:	6a46                	ld	s4,80(sp)
  8001f6:	6aa6                	ld	s5,72(sp)
  8001f8:	6b06                	ld	s6,64(sp)
  8001fa:	7be2                	ld	s7,56(sp)
  8001fc:	7c42                	ld	s8,48(sp)
  8001fe:	7ca2                	ld	s9,40(sp)
  800200:	7d02                	ld	s10,32(sp)
  800202:	6de2                	ld	s11,24(sp)
  800204:	6109                	addi	sp,sp,128
  800206:	8082                	ret
            padc = '0';
  800208:	87b2                	mv	a5,a2
            goto reswitch;
  80020a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80020e:	846a                	mv	s0,s10
  800210:	00140d13          	addi	s10,s0,1
  800214:	fdd6059b          	addiw	a1,a2,-35
  800218:	0ff5f593          	zext.b	a1,a1
  80021c:	fcb572e3          	bgeu	a0,a1,8001e0 <vprintfmt+0x7c>
            putch('%', putdat);
  800220:	85a6                	mv	a1,s1
  800222:	02500513          	li	a0,37
  800226:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800228:	fff44783          	lbu	a5,-1(s0)
  80022c:	8d22                	mv	s10,s0
  80022e:	f73788e3          	beq	a5,s3,80019e <vprintfmt+0x3a>
  800232:	ffed4783          	lbu	a5,-2(s10)
  800236:	1d7d                	addi	s10,s10,-1
  800238:	ff379de3          	bne	a5,s3,800232 <vprintfmt+0xce>
  80023c:	b78d                	j	80019e <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  80023e:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  800242:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800246:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  800248:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  80024c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  800250:	02d86463          	bltu	a6,a3,800278 <vprintfmt+0x114>
                ch = *fmt;
  800254:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  800258:	002c169b          	slliw	a3,s8,0x2
  80025c:	0186873b          	addw	a4,a3,s8
  800260:	0017171b          	slliw	a4,a4,0x1
  800264:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  800266:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  80026a:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  80026c:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800270:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  800274:	fed870e3          	bgeu	a6,a3,800254 <vprintfmt+0xf0>
            if (width < 0)
  800278:	f40ddce3          	bgez	s11,8001d0 <vprintfmt+0x6c>
                width = precision, precision = -1;
  80027c:	8de2                	mv	s11,s8
  80027e:	5c7d                	li	s8,-1
  800280:	bf81                	j	8001d0 <vprintfmt+0x6c>
            if (width < 0)
  800282:	fffdc693          	not	a3,s11
  800286:	96fd                	srai	a3,a3,0x3f
  800288:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  80028c:	00144603          	lbu	a2,1(s0)
  800290:	2d81                	sext.w	s11,s11
  800292:	846a                	mv	s0,s10
            goto reswitch;
  800294:	bf35                	j	8001d0 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800296:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  80029a:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  80029e:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  8002a0:	846a                	mv	s0,s10
            goto process_precision;
  8002a2:	bfd9                	j	800278 <vprintfmt+0x114>
    if (lflag >= 2) {
  8002a4:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002a6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002aa:	01174463          	blt	a4,a7,8002b2 <vprintfmt+0x14e>
    else if (lflag) {
  8002ae:	1a088e63          	beqz	a7,80046a <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  8002b2:	000a3603          	ld	a2,0(s4)
  8002b6:	46c1                	li	a3,16
  8002b8:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  8002ba:	2781                	sext.w	a5,a5
  8002bc:	876e                	mv	a4,s11
  8002be:	85a6                	mv	a1,s1
  8002c0:	854a                	mv	a0,s2
  8002c2:	e37ff0ef          	jal	ra,8000f8 <printnum>
            break;
  8002c6:	bde1                	j	80019e <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8002c8:	000a2503          	lw	a0,0(s4)
  8002cc:	85a6                	mv	a1,s1
  8002ce:	0a21                	addi	s4,s4,8
  8002d0:	9902                	jalr	s2
            break;
  8002d2:	b5f1                	j	80019e <vprintfmt+0x3a>
    if (lflag >= 2) {
  8002d4:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002d6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002da:	01174463          	blt	a4,a7,8002e2 <vprintfmt+0x17e>
    else if (lflag) {
  8002de:	18088163          	beqz	a7,800460 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  8002e2:	000a3603          	ld	a2,0(s4)
  8002e6:	46a9                	li	a3,10
  8002e8:	8a2e                	mv	s4,a1
  8002ea:	bfc1                	j	8002ba <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  8002ec:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  8002f0:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  8002f2:	846a                	mv	s0,s10
            goto reswitch;
  8002f4:	bdf1                	j	8001d0 <vprintfmt+0x6c>
            putch(ch, putdat);
  8002f6:	85a6                	mv	a1,s1
  8002f8:	02500513          	li	a0,37
  8002fc:	9902                	jalr	s2
            break;
  8002fe:	b545                	j	80019e <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800300:	00144603          	lbu	a2,1(s0)
            lflag ++;
  800304:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  800306:	846a                	mv	s0,s10
            goto reswitch;
  800308:	b5e1                	j	8001d0 <vprintfmt+0x6c>
    if (lflag >= 2) {
  80030a:	4705                	li	a4,1
            precision = va_arg(ap, int);
  80030c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800310:	01174463          	blt	a4,a7,800318 <vprintfmt+0x1b4>
    else if (lflag) {
  800314:	14088163          	beqz	a7,800456 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  800318:	000a3603          	ld	a2,0(s4)
  80031c:	46a1                	li	a3,8
  80031e:	8a2e                	mv	s4,a1
  800320:	bf69                	j	8002ba <vprintfmt+0x156>
            putch('0', putdat);
  800322:	03000513          	li	a0,48
  800326:	85a6                	mv	a1,s1
  800328:	e03e                	sd	a5,0(sp)
  80032a:	9902                	jalr	s2
            putch('x', putdat);
  80032c:	85a6                	mv	a1,s1
  80032e:	07800513          	li	a0,120
  800332:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800334:	0a21                	addi	s4,s4,8
            goto number;
  800336:	6782                	ld	a5,0(sp)
  800338:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80033a:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  80033e:	bfb5                	j	8002ba <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  800340:	000a3403          	ld	s0,0(s4)
  800344:	008a0713          	addi	a4,s4,8
  800348:	e03a                	sd	a4,0(sp)
  80034a:	14040263          	beqz	s0,80048e <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  80034e:	0fb05763          	blez	s11,80043c <vprintfmt+0x2d8>
  800352:	02d00693          	li	a3,45
  800356:	0cd79163          	bne	a5,a3,800418 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80035a:	00044783          	lbu	a5,0(s0)
  80035e:	0007851b          	sext.w	a0,a5
  800362:	cf85                	beqz	a5,80039a <vprintfmt+0x236>
  800364:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  800368:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80036c:	000c4563          	bltz	s8,800376 <vprintfmt+0x212>
  800370:	3c7d                	addiw	s8,s8,-1
  800372:	036c0263          	beq	s8,s6,800396 <vprintfmt+0x232>
                    putch('?', putdat);
  800376:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800378:	0e0c8e63          	beqz	s9,800474 <vprintfmt+0x310>
  80037c:	3781                	addiw	a5,a5,-32
  80037e:	0ef47b63          	bgeu	s0,a5,800474 <vprintfmt+0x310>
                    putch('?', putdat);
  800382:	03f00513          	li	a0,63
  800386:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800388:	000a4783          	lbu	a5,0(s4)
  80038c:	3dfd                	addiw	s11,s11,-1
  80038e:	0a05                	addi	s4,s4,1
  800390:	0007851b          	sext.w	a0,a5
  800394:	ffe1                	bnez	a5,80036c <vprintfmt+0x208>
            for (; width > 0; width --) {
  800396:	01b05963          	blez	s11,8003a8 <vprintfmt+0x244>
  80039a:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  80039c:	85a6                	mv	a1,s1
  80039e:	02000513          	li	a0,32
  8003a2:	9902                	jalr	s2
            for (; width > 0; width --) {
  8003a4:	fe0d9be3          	bnez	s11,80039a <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003a8:	6a02                	ld	s4,0(sp)
  8003aa:	bbd5                	j	80019e <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003ac:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8003ae:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  8003b2:	01174463          	blt	a4,a7,8003ba <vprintfmt+0x256>
    else if (lflag) {
  8003b6:	08088d63          	beqz	a7,800450 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  8003ba:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8003be:	0a044d63          	bltz	s0,800478 <vprintfmt+0x314>
            num = getint(&ap, lflag);
  8003c2:	8622                	mv	a2,s0
  8003c4:	8a66                	mv	s4,s9
  8003c6:	46a9                	li	a3,10
  8003c8:	bdcd                	j	8002ba <vprintfmt+0x156>
            err = va_arg(ap, int);
  8003ca:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003ce:	4761                	li	a4,24
            err = va_arg(ap, int);
  8003d0:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8003d2:	41f7d69b          	sraiw	a3,a5,0x1f
  8003d6:	8fb5                	xor	a5,a5,a3
  8003d8:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003dc:	02d74163          	blt	a4,a3,8003fe <vprintfmt+0x29a>
  8003e0:	00369793          	slli	a5,a3,0x3
  8003e4:	97de                	add	a5,a5,s7
  8003e6:	639c                	ld	a5,0(a5)
  8003e8:	cb99                	beqz	a5,8003fe <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  8003ea:	86be                	mv	a3,a5
  8003ec:	00000617          	auipc	a2,0x0
  8003f0:	44c60613          	addi	a2,a2,1100 # 800838 <main+0x16c>
  8003f4:	85a6                	mv	a1,s1
  8003f6:	854a                	mv	a0,s2
  8003f8:	0ce000ef          	jal	ra,8004c6 <printfmt>
  8003fc:	b34d                	j	80019e <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  8003fe:	00000617          	auipc	a2,0x0
  800402:	42a60613          	addi	a2,a2,1066 # 800828 <main+0x15c>
  800406:	85a6                	mv	a1,s1
  800408:	854a                	mv	a0,s2
  80040a:	0bc000ef          	jal	ra,8004c6 <printfmt>
  80040e:	bb41                	j	80019e <vprintfmt+0x3a>
                p = "(null)";
  800410:	00000417          	auipc	s0,0x0
  800414:	41040413          	addi	s0,s0,1040 # 800820 <main+0x154>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800418:	85e2                	mv	a1,s8
  80041a:	8522                	mv	a0,s0
  80041c:	e43e                	sd	a5,8(sp)
  80041e:	0e2000ef          	jal	ra,800500 <strnlen>
  800422:	40ad8dbb          	subw	s11,s11,a0
  800426:	01b05b63          	blez	s11,80043c <vprintfmt+0x2d8>
                    putch(padc, putdat);
  80042a:	67a2                	ld	a5,8(sp)
  80042c:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  800430:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  800432:	85a6                	mv	a1,s1
  800434:	8552                	mv	a0,s4
  800436:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800438:	fe0d9ce3          	bnez	s11,800430 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80043c:	00044783          	lbu	a5,0(s0)
  800440:	00140a13          	addi	s4,s0,1
  800444:	0007851b          	sext.w	a0,a5
  800448:	d3a5                	beqz	a5,8003a8 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  80044a:	05e00413          	li	s0,94
  80044e:	bf39                	j	80036c <vprintfmt+0x208>
        return va_arg(*ap, int);
  800450:	000a2403          	lw	s0,0(s4)
  800454:	b7ad                	j	8003be <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  800456:	000a6603          	lwu	a2,0(s4)
  80045a:	46a1                	li	a3,8
  80045c:	8a2e                	mv	s4,a1
  80045e:	bdb1                	j	8002ba <vprintfmt+0x156>
  800460:	000a6603          	lwu	a2,0(s4)
  800464:	46a9                	li	a3,10
  800466:	8a2e                	mv	s4,a1
  800468:	bd89                	j	8002ba <vprintfmt+0x156>
  80046a:	000a6603          	lwu	a2,0(s4)
  80046e:	46c1                	li	a3,16
  800470:	8a2e                	mv	s4,a1
  800472:	b5a1                	j	8002ba <vprintfmt+0x156>
                    putch(ch, putdat);
  800474:	9902                	jalr	s2
  800476:	bf09                	j	800388 <vprintfmt+0x224>
                putch('-', putdat);
  800478:	85a6                	mv	a1,s1
  80047a:	02d00513          	li	a0,45
  80047e:	e03e                	sd	a5,0(sp)
  800480:	9902                	jalr	s2
                num = -(long long)num;
  800482:	6782                	ld	a5,0(sp)
  800484:	8a66                	mv	s4,s9
  800486:	40800633          	neg	a2,s0
  80048a:	46a9                	li	a3,10
  80048c:	b53d                	j	8002ba <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  80048e:	03b05163          	blez	s11,8004b0 <vprintfmt+0x34c>
  800492:	02d00693          	li	a3,45
  800496:	f6d79de3          	bne	a5,a3,800410 <vprintfmt+0x2ac>
                p = "(null)";
  80049a:	00000417          	auipc	s0,0x0
  80049e:	38640413          	addi	s0,s0,902 # 800820 <main+0x154>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004a2:	02800793          	li	a5,40
  8004a6:	02800513          	li	a0,40
  8004aa:	00140a13          	addi	s4,s0,1
  8004ae:	bd6d                	j	800368 <vprintfmt+0x204>
  8004b0:	00000a17          	auipc	s4,0x0
  8004b4:	371a0a13          	addi	s4,s4,881 # 800821 <main+0x155>
  8004b8:	02800513          	li	a0,40
  8004bc:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c0:	05e00413          	li	s0,94
  8004c4:	b565                	j	80036c <vprintfmt+0x208>

00000000008004c6 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004c6:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8004c8:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004cc:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004ce:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004d0:	ec06                	sd	ra,24(sp)
  8004d2:	f83a                	sd	a4,48(sp)
  8004d4:	fc3e                	sd	a5,56(sp)
  8004d6:	e0c2                	sd	a6,64(sp)
  8004d8:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004da:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004dc:	c89ff0ef          	jal	ra,800164 <vprintfmt>
}
  8004e0:	60e2                	ld	ra,24(sp)
  8004e2:	6161                	addi	sp,sp,80
  8004e4:	8082                	ret

00000000008004e6 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  8004e6:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
  8004ea:	872a                	mv	a4,a0
    size_t cnt = 0;
  8004ec:	4501                	li	a0,0
    while (*s ++ != '\0') {
  8004ee:	cb81                	beqz	a5,8004fe <strlen+0x18>
        cnt ++;
  8004f0:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
  8004f2:	00a707b3          	add	a5,a4,a0
  8004f6:	0007c783          	lbu	a5,0(a5)
  8004fa:	fbfd                	bnez	a5,8004f0 <strlen+0xa>
  8004fc:	8082                	ret
    }
    return cnt;
}
  8004fe:	8082                	ret

0000000000800500 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800500:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  800502:	e589                	bnez	a1,80050c <strnlen+0xc>
  800504:	a811                	j	800518 <strnlen+0x18>
        cnt ++;
  800506:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800508:	00f58863          	beq	a1,a5,800518 <strnlen+0x18>
  80050c:	00f50733          	add	a4,a0,a5
  800510:	00074703          	lbu	a4,0(a4)
  800514:	fb6d                	bnez	a4,800506 <strnlen+0x6>
  800516:	85be                	mv	a1,a5
    }
    return cnt;
}
  800518:	852e                	mv	a0,a1
  80051a:	8082                	ret

000000000080051c <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
  80051c:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
  800520:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
  800524:	cb89                	beqz	a5,800536 <strcmp+0x1a>
        s1 ++, s2 ++;
  800526:	0505                	addi	a0,a0,1
  800528:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
  80052a:	fee789e3          	beq	a5,a4,80051c <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
  80052e:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
  800532:	9d19                	subw	a0,a0,a4
  800534:	8082                	ret
  800536:	4501                	li	a0,0
  800538:	bfed                	j	800532 <strcmp+0x16>

000000000080053a <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  80053a:	c20d                	beqz	a2,80055c <strncmp+0x22>
  80053c:	962e                	add	a2,a2,a1
  80053e:	a031                	j	80054a <strncmp+0x10>
        n --, s1 ++, s2 ++;
  800540:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800542:	00e79a63          	bne	a5,a4,800556 <strncmp+0x1c>
  800546:	00b60b63          	beq	a2,a1,80055c <strncmp+0x22>
  80054a:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
  80054e:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800550:	fff5c703          	lbu	a4,-1(a1)
  800554:	f7f5                	bnez	a5,800540 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800556:	40e7853b          	subw	a0,a5,a4
}
  80055a:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  80055c:	4501                	li	a0,0
  80055e:	8082                	ret

0000000000800560 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
  800560:	ca19                	beqz	a2,800576 <memcpy+0x16>
  800562:	962e                	add	a2,a2,a1
    char *d = dst;
  800564:	87aa                	mv	a5,a0
        *d ++ = *s ++;
  800566:	0005c703          	lbu	a4,0(a1)
  80056a:	0585                	addi	a1,a1,1
  80056c:	0785                	addi	a5,a5,1
  80056e:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
  800572:	fec59ae3          	bne	a1,a2,800566 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  800576:	8082                	ret

0000000000800578 <dirty_write>:
const char cow_target[] = "PROTECTED: Should not be modified!";

// Function to try writing to the "read-only" string
void dirty_write(int proc_id) {
    char *ptr = (char *)cow_target;
    const char exploit_str[] = "EXPLOITED";
  800578:	00000797          	auipc	a5,0x0
  80057c:	68878793          	addi	a5,a5,1672 # 800c00 <error_string+0x1a8>
  800580:	6398                	ld	a4,0(a5)
  800582:	0087d783          	lhu	a5,8(a5)
void dirty_write(int proc_id) {
  800586:	711d                	addi	sp,sp,-96
  800588:	fc4e                	sd	s3,56(sp)
  80058a:	f456                	sd	s5,40(sp)
            }
            yield();
        }
        
        // Limit attempts to reasonable time
        if (attempts > 100000) {
  80058c:	69e1                	lui	s3,0x18
  80058e:	6a89                	lui	s5,0x2
void dirty_write(int proc_id) {
  800590:	e4a6                	sd	s1,72(sp)
  800592:	e0ca                	sd	s2,64(sp)
  800594:	f852                	sd	s4,48(sp)
  800596:	f05a                	sd	s6,32(sp)
  800598:	ec5e                	sd	s7,24(sp)
  80059a:	ec86                	sd	ra,88(sp)
  80059c:	e8a2                	sd	s0,80(sp)
  80059e:	8baa                	mv	s7,a0
    const char exploit_str[] = "EXPLOITED";
  8005a0:	e03a                	sd	a4,0(sp)
  8005a2:	00f11423          	sh	a5,8(sp)
    int attempts = 0;
  8005a6:	4481                	li	s1,0
        memcpy(ptr, exploit_str, strlen(exploit_str));
  8005a8:	00001917          	auipc	s2,0x1
  8005ac:	89890913          	addi	s2,s2,-1896 # 800e40 <cow_target>
            exit(0);
  8005b0:	06400a13          	li	s4,100
  8005b4:	710a8a9b          	addiw	s5,s5,1808
                cprintf("."); // Progress indicator
  8005b8:	00000b17          	auipc	s6,0x0
  8005bc:	610b0b13          	addi	s6,s6,1552 # 800bc8 <error_string+0x170>
        if (attempts > 100000) {
  8005c0:	6a198993          	addi	s3,s3,1697 # 186a1 <_start-0x7e797f>
        memcpy(ptr, exploit_str, strlen(exploit_str));
  8005c4:	850a                	mv	a0,sp
  8005c6:	f21ff0ef          	jal	ra,8004e6 <strlen>
  8005ca:	862a                	mv	a2,a0
  8005cc:	858a                	mv	a1,sp
  8005ce:	854a                	mv	a0,s2
  8005d0:	f91ff0ef          	jal	ra,800560 <memcpy>
        if (strncmp(cow_target, exploit_str, strlen(exploit_str)) == 0) {
  8005d4:	850a                	mv	a0,sp
  8005d6:	f11ff0ef          	jal	ra,8004e6 <strlen>
  8005da:	862a                	mv	a2,a0
  8005dc:	858a                	mv	a1,sp
  8005de:	854a                	mv	a0,s2
        attempts++;
  8005e0:	2485                	addiw	s1,s1,1
        if (strncmp(cow_target, exploit_str, strlen(exploit_str)) == 0) {
  8005e2:	f59ff0ef          	jal	ra,80053a <strncmp>
  8005e6:	c131                	beqz	a0,80062a <dirty_write+0xb2>
        if (attempts % 100 == 0) {
  8005e8:	0344e7bb          	remw	a5,s1,s4
  8005ec:	e791                	bnez	a5,8005f8 <dirty_write+0x80>
            if (attempts % 10000 == 0) {
  8005ee:	0354e43b          	remw	s0,s1,s5
  8005f2:	c805                	beqz	s0,800622 <dirty_write+0xaa>
            yield();
  8005f4:	af7ff0ef          	jal	ra,8000ea <yield>
        if (attempts > 100000) {
  8005f8:	fd3496e3          	bne	s1,s3,8005c4 <dirty_write+0x4c>
            break;
        }
    }
    
    cprintf("\n[*] Process %d failed after %d attempts\n", proc_id, attempts);
  8005fc:	8626                	mv	a2,s1
  8005fe:	85de                	mv	a1,s7
  800600:	00000517          	auipc	a0,0x0
  800604:	5d050513          	addi	a0,a0,1488 # 800bd0 <error_string+0x178>
  800608:	a39ff0ef          	jal	ra,800040 <cprintf>
}
  80060c:	60e6                	ld	ra,88(sp)
  80060e:	6446                	ld	s0,80(sp)
  800610:	64a6                	ld	s1,72(sp)
  800612:	6906                	ld	s2,64(sp)
  800614:	79e2                	ld	s3,56(sp)
  800616:	7a42                	ld	s4,48(sp)
  800618:	7aa2                	ld	s5,40(sp)
  80061a:	7b02                	ld	s6,32(sp)
  80061c:	6be2                	ld	s7,24(sp)
  80061e:	6125                	addi	sp,sp,96
  800620:	8082                	ret
                cprintf("."); // Progress indicator
  800622:	855a                	mv	a0,s6
  800624:	a1dff0ef          	jal	ra,800040 <cprintf>
  800628:	b7f1                	j	8005f4 <dirty_write+0x7c>
            cprintf("\n[*] SUCCESS! Process %d modified read-only memory!\n", proc_id);
  80062a:	85de                	mv	a1,s7
  80062c:	00000517          	auipc	a0,0x0
  800630:	4f450513          	addi	a0,a0,1268 # 800b20 <error_string+0xc8>
  800634:	a0dff0ef          	jal	ra,800040 <cprintf>
            cprintf("[*] Attempts: %d\n", attempts);
  800638:	85a6                	mv	a1,s1
  80063a:	00000517          	auipc	a0,0x0
  80063e:	51e50513          	addi	a0,a0,1310 # 800b58 <error_string+0x100>
  800642:	9ffff0ef          	jal	ra,800040 <cprintf>
            cprintf("[*] Original: %s\n", "PROTECTED: Should not be modified!");
  800646:	00000597          	auipc	a1,0x0
  80064a:	52a58593          	addi	a1,a1,1322 # 800b70 <error_string+0x118>
  80064e:	00000517          	auipc	a0,0x0
  800652:	54a50513          	addi	a0,a0,1354 # 800b98 <error_string+0x140>
  800656:	9ebff0ef          	jal	ra,800040 <cprintf>
            cprintf("[*] Current:  %s\n", cow_target);
  80065a:	00000597          	auipc	a1,0x0
  80065e:	7e658593          	addi	a1,a1,2022 # 800e40 <cow_target>
  800662:	00000517          	auipc	a0,0x0
  800666:	54e50513          	addi	a0,a0,1358 # 800bb0 <error_string+0x158>
  80066a:	9d7ff0ef          	jal	ra,800040 <cprintf>
            exit(0);
  80066e:	4501                	li	a0,0
  800670:	a5dff0ef          	jal	ra,8000cc <exit>

0000000000800674 <check_state>:

// Function to check the current state of the target string
// 在check_state函数中添加超时
void check_state(int proc_id) {
  800674:	1101                	addi	sp,sp,-32
  800676:	e822                	sd	s0,16(sp)
  800678:	6461                	lui	s0,0x18
  80067a:	e426                	sd	s1,8(sp)
  80067c:	e04a                	sd	s2,0(sp)
  80067e:	ec06                	sd	ra,24(sp)
  800680:	6a040413          	addi	s0,s0,1696 # 186a0 <_start-0x7e7980>
    int timeout = 100000;
    while (timeout-- > 0) {
        if (strcmp(cow_target, "PROTECTED: Should not be modified!") != 0) {
  800684:	00000917          	auipc	s2,0x0
  800688:	4ec90913          	addi	s2,s2,1260 # 800b70 <error_string+0x118>
  80068c:	00000497          	auipc	s1,0x0
  800690:	7b448493          	addi	s1,s1,1972 # 800e40 <cow_target>
  800694:	a029                	j	80069e <check_state+0x2a>
    while (timeout-- > 0) {
  800696:	347d                	addiw	s0,s0,-1
            cprintf("\n[!] DETECTED modification!\n");
            exit(0);
        }
        yield();
  800698:	a53ff0ef          	jal	ra,8000ea <yield>
    while (timeout-- > 0) {
  80069c:	cc19                	beqz	s0,8006ba <check_state+0x46>
        if (strcmp(cow_target, "PROTECTED: Should not be modified!") != 0) {
  80069e:	85ca                	mv	a1,s2
  8006a0:	8526                	mv	a0,s1
  8006a2:	e7bff0ef          	jal	ra,80051c <strcmp>
  8006a6:	d965                	beqz	a0,800696 <check_state+0x22>
            cprintf("\n[!] DETECTED modification!\n");
  8006a8:	00000517          	auipc	a0,0x0
  8006ac:	56850513          	addi	a0,a0,1384 # 800c10 <error_string+0x1b8>
  8006b0:	991ff0ef          	jal	ra,800040 <cprintf>
            exit(0);
  8006b4:	4501                	li	a0,0
  8006b6:	a17ff0ef          	jal	ra,8000cc <exit>
    }
    cprintf("[!] Monitor exit after timeout\n");
  8006ba:	00000517          	auipc	a0,0x0
  8006be:	57650513          	addi	a0,a0,1398 # 800c30 <error_string+0x1d8>
  8006c2:	97fff0ef          	jal	ra,800040 <cprintf>
    exit(0);  // 超时也要exit
  8006c6:	4501                	li	a0,0
  8006c8:	a05ff0ef          	jal	ra,8000cc <exit>

00000000008006cc <main>:
}

int main(void) {
  8006cc:	1101                	addi	sp,sp,-32
    cprintf("\n==========================================\n");
  8006ce:	00000517          	auipc	a0,0x0
  8006d2:	58250513          	addi	a0,a0,1410 # 800c50 <error_string+0x1f8>
int main(void) {
  8006d6:	ec06                	sd	ra,24(sp)
  8006d8:	e822                	sd	s0,16(sp)
  8006da:	e426                	sd	s1,8(sp)
    cprintf("\n==========================================\n");
  8006dc:	965ff0ef          	jal	ra,800040 <cprintf>
    cprintf("      Dirty COW Vulnerability Test        \n");
  8006e0:	00000517          	auipc	a0,0x0
  8006e4:	5a050513          	addi	a0,a0,1440 # 800c80 <error_string+0x228>
  8006e8:	959ff0ef          	jal	ra,800040 <cprintf>
    cprintf("==========================================\n");
  8006ec:	00000517          	auipc	a0,0x0
  8006f0:	5c450513          	addi	a0,a0,1476 # 800cb0 <error_string+0x258>
  8006f4:	94dff0ef          	jal	ra,800040 <cprintf>
    cprintf("Target read-only string: %s\n", cow_target);
  8006f8:	00000597          	auipc	a1,0x0
  8006fc:	74858593          	addi	a1,a1,1864 # 800e40 <cow_target>
  800700:	00000517          	auipc	a0,0x0
  800704:	5e050513          	addi	a0,a0,1504 # 800ce0 <error_string+0x288>
  800708:	939ff0ef          	jal	ra,800040 <cprintf>
    cprintf("\n[*] Creating race condition with multiple processes...\n");
  80070c:	00000517          	auipc	a0,0x0
  800710:	5f450513          	addi	a0,a0,1524 # 800d00 <error_string+0x2a8>
  800714:	92dff0ef          	jal	ra,800040 <cprintf>
    cprintf("[*] This will generate many page faults - normal behavior.\n");
  800718:	00000517          	auipc	a0,0x0
  80071c:	62850513          	addi	a0,a0,1576 # 800d40 <error_string+0x2e8>
  800720:	921ff0ef          	jal	ra,800040 <cprintf>
    cprintf("[*] Look for 'SUCCESS' message below.\n");
  800724:	00000517          	auipc	a0,0x0
  800728:	65c50513          	addi	a0,a0,1628 # 800d80 <error_string+0x328>
  80072c:	915ff0ef          	jal	ra,800040 <cprintf>
    cprintf("==========================================\n");
  800730:	00000517          	auipc	a0,0x0
  800734:	58050513          	addi	a0,a0,1408 # 800cb0 <error_string+0x258>
  800738:	909ff0ef          	jal	ra,800040 <cprintf>
    
    int i, pid;
    
    // Create multiple writer processes to increase race condition chance
    for (i = 0; i < 4; i++) {
  80073c:	4401                	li	s0,0
  80073e:	4491                	li	s1,4
        pid = fork();
  800740:	9a3ff0ef          	jal	ra,8000e2 <fork>
        if (pid < 0) {
  800744:	08054663          	bltz	a0,8007d0 <main+0x104>
            cprintf("\nfork failed\n");
            return -1;
        }
        if (pid == 0) {
            // Child writer process
            dirty_write(i + 1);
  800748:	2405                	addiw	s0,s0,1
        if (pid == 0) {
  80074a:	c959                	beqz	a0,8007e0 <main+0x114>
    for (i = 0; i < 4; i++) {
  80074c:	fe941ae3          	bne	s0,s1,800740 <main+0x74>
            exit(0);
        }
    }
    
    // Create a monitor process to check for modifications
    pid = fork();
  800750:	993ff0ef          	jal	ra,8000e2 <fork>
    if (pid == 0) {
  800754:	cd41                	beqz	a0,8007ec <main+0x120>
        check_state(0);
        exit(0);
    }
    
    // Parent process also participates in writing
    dirty_write(5);
  800756:	4515                	li	a0,5
  800758:	e21ff0ef          	jal	ra,800578 <dirty_write>
    
    // Wait for all children (though they should exit on success/failure)
    for (i = 0; i < 5; i++) {
        wait();
  80075c:	989ff0ef          	jal	ra,8000e4 <wait>
  800760:	985ff0ef          	jal	ra,8000e4 <wait>
  800764:	981ff0ef          	jal	ra,8000e4 <wait>
  800768:	97dff0ef          	jal	ra,8000e4 <wait>
  80076c:	979ff0ef          	jal	ra,8000e4 <wait>
    }
    
    cprintf("\n==========================================\n");
  800770:	00000517          	auipc	a0,0x0
  800774:	4e050513          	addi	a0,a0,1248 # 800c50 <error_string+0x1f8>
  800778:	8c9ff0ef          	jal	ra,800040 <cprintf>
    cprintf("[*] Test completed. Final state: %s\n", cow_target);
  80077c:	00000597          	auipc	a1,0x0
  800780:	6c458593          	addi	a1,a1,1732 # 800e40 <cow_target>
  800784:	00000517          	auipc	a0,0x0
  800788:	63450513          	addi	a0,a0,1588 # 800db8 <error_string+0x360>
  80078c:	8b5ff0ef          	jal	ra,800040 <cprintf>
    
    if (strcmp(cow_target, "PROTECTED: Should not be modified!") != 0) {
  800790:	00000597          	auipc	a1,0x0
  800794:	3e058593          	addi	a1,a1,992 # 800b70 <error_string+0x118>
  800798:	00000517          	auipc	a0,0x0
  80079c:	6a850513          	addi	a0,a0,1704 # 800e40 <cow_target>
  8007a0:	d7dff0ef          	jal	ra,80051c <strcmp>
  8007a4:	842a                	mv	s0,a0
  8007a6:	ed09                	bnez	a0,8007c0 <main+0xf4>
        cprintf("[!] Dirty COW vulnerability CONFIRMED!\n");
        return 1;
    } else {
        cprintf("[-] No modification detected. Try running again.\n");
  8007a8:	00000517          	auipc	a0,0x0
  8007ac:	66050513          	addi	a0,a0,1632 # 800e08 <error_string+0x3b0>
  8007b0:	891ff0ef          	jal	ra,800040 <cprintf>
        return 0;
    }
}
  8007b4:	60e2                	ld	ra,24(sp)
  8007b6:	8522                	mv	a0,s0
  8007b8:	6442                	ld	s0,16(sp)
  8007ba:	64a2                	ld	s1,8(sp)
  8007bc:	6105                	addi	sp,sp,32
  8007be:	8082                	ret
        cprintf("[!] Dirty COW vulnerability CONFIRMED!\n");
  8007c0:	00000517          	auipc	a0,0x0
  8007c4:	62050513          	addi	a0,a0,1568 # 800de0 <error_string+0x388>
  8007c8:	879ff0ef          	jal	ra,800040 <cprintf>
        return 1;
  8007cc:	4405                	li	s0,1
  8007ce:	b7dd                	j	8007b4 <main+0xe8>
            cprintf("\nfork failed\n");
  8007d0:	00000517          	auipc	a0,0x0
  8007d4:	5d850513          	addi	a0,a0,1496 # 800da8 <error_string+0x350>
  8007d8:	869ff0ef          	jal	ra,800040 <cprintf>
            return -1;
  8007dc:	547d                	li	s0,-1
  8007de:	bfd9                	j	8007b4 <main+0xe8>
            dirty_write(i + 1);
  8007e0:	8522                	mv	a0,s0
  8007e2:	d97ff0ef          	jal	ra,800578 <dirty_write>
            exit(0);
  8007e6:	4501                	li	a0,0
  8007e8:	8e5ff0ef          	jal	ra,8000cc <exit>
        check_state(0);
  8007ec:	e89ff0ef          	jal	ra,800674 <check_state>
