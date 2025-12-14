#include <defs.h>
#include <mmu.h>
#include <memlayout.h>
#include <pmm.h>
#include <clock.h>
#include <trap.h>
#include <riscv.h>
#include <stdio.h>
#include <assert.h>
#include <console.h>
#include <vmm.h>
#include <kdebug.h>
#include <unistd.h>
#include <syscall.h>
#include <error.h>
#include <sched.h>
#include <sync.h>
#include <sbi.h>

#define TICK_NUM 100
static int num = 0;  // 跟踪打印次数
static void print_ticks()
{
    cprintf("%d ticks\n", TICK_NUM);
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
    return (tf->status & SSTATUS_SPP) != 0;
}

void print_trapframe(struct trapframe *tf)
{
    cprintf("trapframe at %p\n", tf);
    // cprintf("trapframe at 0x%x\n", tf);
    print_regs(&tf->gpr);
    cprintf("  status   0x%08x\n", tf->status);
    cprintf("  epc      0x%08x\n", tf->epc);
    cprintf("  tval 0x%08x\n", tf->tval);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
    cprintf("  ra       0x%08x\n", gpr->ra);
    cprintf("  sp       0x%08x\n", gpr->sp);
    cprintf("  gp       0x%08x\n", gpr->gp);
    cprintf("  tp       0x%08x\n", gpr->tp);
    cprintf("  t0       0x%08x\n", gpr->t0);
    cprintf("  t1       0x%08x\n", gpr->t1);
    cprintf("  t2       0x%08x\n", gpr->t2);
    cprintf("  s0       0x%08x\n", gpr->s0);
    cprintf("  s1       0x%08x\n", gpr->s1);
    cprintf("  a0       0x%08x\n", gpr->a0);
    cprintf("  a1       0x%08x\n", gpr->a1);
    cprintf("  a2       0x%08x\n", gpr->a2);
    cprintf("  a3       0x%08x\n", gpr->a3);
    cprintf("  a4       0x%08x\n", gpr->a4);
    cprintf("  a5       0x%08x\n", gpr->a5);
    cprintf("  a6       0x%08x\n", gpr->a6);
    cprintf("  a7       0x%08x\n", gpr->a7);
    cprintf("  s2       0x%08x\n", gpr->s2);
    cprintf("  s3       0x%08x\n", gpr->s3);
    cprintf("  s4       0x%08x\n", gpr->s4);
    cprintf("  s5       0x%08x\n", gpr->s5);
    cprintf("  s6       0x%08x\n", gpr->s6);
    cprintf("  s7       0x%08x\n", gpr->s7);
    cprintf("  s8       0x%08x\n", gpr->s8);
    cprintf("  s9       0x%08x\n", gpr->s9);
    cprintf("  s10      0x%08x\n", gpr->s10);
    cprintf("  s11      0x%08x\n", gpr->s11);
    cprintf("  t3       0x%08x\n", gpr->t3);
    cprintf("  t4       0x%08x\n", gpr->t4);
    cprintf("  t5       0x%08x\n", gpr->t5);
    cprintf("  t6       0x%08x\n", gpr->t6);
}

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
    {
    case IRQ_U_SOFT:
        cprintf("User software interrupt\n");
        break;
    case IRQ_S_SOFT:
        cprintf("Supervisor software interrupt\n");
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
        break;
    case IRQ_U_TIMER:
        cprintf("User software interrupt\n");
        break;
    case IRQ_S_TIMER:
        // "All bits besides SSIP and USIP in the sip register are
        // read-only." -- privileged spec1.9.1, 4.1.4, p59
        // In fact, Call sbi_set_timer will clear STIP, or you can clear it
        // directly.
        // cprintf("Supervisor timer interrupt\n");
        /* LAB5 GRADE   YOUR CODE :  */
        /* 时间片轮转： 
         *(1) 设置下一次时钟中断（clock_set_next_event）
         *(2) ticks 计数器自增
         *(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，
         *    如果有则标记该进程需要被重新调度（current->need_resched）
         */
        /* (1) 设置下次时钟中断 */
        clock_set_next_event();

        /* (2) ticks 计数器自增 */
        ticks++;

        /* (3) 每 TICK_NUM 次中断检查当前进程并标记需要重调度 */
        if (ticks >= TICK_NUM) {
            ticks = 0;
            if (current != NULL && current != idleproc) {
                current->need_resched = 1;
            }
        }
        break;
    case IRQ_H_TIMER:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_TIMER:
        cprintf("Machine software interrupt\n");
        break;
    case IRQ_U_EXT:
        cprintf("User software interrupt\n");
        break;
    case IRQ_S_EXT:
        cprintf("Supervisor external interrupt\n");
        break;
    case IRQ_H_EXT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_EXT:
        cprintf("Machine software interrupt\n");
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
    {
    case CAUSE_MISALIGNED_FETCH:
        cprintf("Instruction address misaligned\n");
        break;
    case CAUSE_FETCH_ACCESS:
        cprintf("Instruction access fault\n");
        break;
    case CAUSE_ILLEGAL_INSTRUCTION:
        cprintf("Illegal instruction\n");
        break;
    case CAUSE_BREAKPOINT:
        cprintf("Breakpoint\n");
        if (tf->gpr.a7 == 10)
        {
            tf->epc += 4;
            syscall();
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
        }
        break;
    case CAUSE_MISALIGNED_LOAD:
        cprintf("Load address misaligned\n");
        break;
    case CAUSE_LOAD_ACCESS:
        cprintf("Load access fault\n");
        break;
    case CAUSE_MISALIGNED_STORE:
        panic("AMO address misaligned\n");
        break;
    case CAUSE_STORE_ACCESS:
        cprintf("Store/AMO access fault\n");
        break;
    case CAUSE_USER_ECALL:
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_HYPERVISOR_ECALL:
        cprintf("Environment call from H-mode\n");
        break;
    case CAUSE_MACHINE_ECALL:
        cprintf("Environment call from M-mode\n");
        break;
    case CAUSE_FETCH_PAGE_FAULT:
        cprintf("Instruction page fault\n");
        break;
    case CAUSE_LOAD_PAGE_FAULT:
        cprintf("Load page fault\n");
        break;
    case CAUSE_STORE_PAGE_FAULT:
    {
        uintptr_t badv = tf->tval;
        cprintf("Store/AMO page fault at %p\n", (void *)badv);
        struct mm_struct *mm = current->mm;
        if (mm == NULL)
        {
            // no user mm, cannot handle
            panic("store page fault in kernel or kernel-thread\n");
        }
        uintptr_t la = ROUNDDOWN(badv, PGSIZE);
        /* Acquire mm lock to avoid races during COW handling. Re-check pte
         * after taking the lock because it may have changed. */
        lock_mm(mm);
        pte_t *ptep = get_pte(mm->pgdir, la, 0);
        if (ptep == NULL || !(*ptep & PTE_V))
        {
            /* not present: treat as fatal for now */
            cprintf("segfault: no mapping for %p\n", (void *)badv);
            unlock_mm(mm);
            do_exit(-E_INVAL);
            break;
        }
        struct Page *page = pte2page(*ptep);
        cprintf("COW fault: va=%p ppn=%x ref=%d pte=0x%08x\n", (void *)la, page2ppn(page), page_ref(page), (uint32_t)(*ptep));
        if ((*ptep & PTE_W) || page_ref(page) == 1)
        {
            /* if writable already or sole owner, promote to writable */
            uint32_t user_bits = (*ptep & (PTE_R | PTE_X | PTE_U));
            *ptep = pte_create(page2ppn(page), user_bits | PTE_W);
            tlb_invalidate(mm->pgdir, la);
            cprintf("COW promote: va=%p ppn=%x ref=%d\n", (void *)la, page2ppn(page), page_ref(page));
            unlock_mm(mm);
            break;
        }
        /* page is shared and not writable -> perform copy-on-write */
        cprintf("COW alloc+copy: va=%p old_ppn=%x old_ref=%d\n", (void *)la, page2ppn(page), page_ref(page));
        struct Page *npage = alloc_page();
        if (npage == NULL)
        {
            cprintf("COW: alloc_page failed\n");
            unlock_mm(mm);
            do_exit(-E_NO_MEM);
            break;
        }
        memcpy(page2kva(npage), page2kva(page), PGSIZE);
        /* replace mapping in current pgdir: remove old pte and insert new page */
        page_remove(mm->pgdir, la);
        if (page_insert(mm->pgdir, npage, la, PTE_USER) != 0)
        {
            cprintf("COW: page_insert failed\n");
            unlock_mm(mm);
            do_exit(-E_NO_MEM);
        }
        cprintf("COW done: va=%p new_ppn=%x new_ref=%d old_ref=%d\n", (void *)la, page2ppn(npage), page_ref(npage), page_ref(page));
        unlock_mm(mm);
        break;
    }
    default:
        print_trapframe(tf);
        break;
    }
}

static inline void trap_dispatch(struct trapframe *tf)
{
    if ((intptr_t)tf->cause < 0)
    {
        // interrupts
        interrupt_handler(tf);
    }
    else
    {
        // exceptions
        exception_handler(tf);
    }
}

/* *
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
        current->tf = tf;

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
        if (!in_kernel)
        {
            if (current->flags & PF_EXITING)
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
            {
                schedule();
            }
        }
    }
}
