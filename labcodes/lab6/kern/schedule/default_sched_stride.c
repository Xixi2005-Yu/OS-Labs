#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <default_sched.h>
#include <stdio.h>

#define USE_SKEW_HEAP 1

/* You should define the BigStride constant here*/
/* LAB6 CHALLENGE 1: 2312642 */
#define BIG_STRIDE 0x7FFFFFFFULL

/* The compare function for two skew_heap_node_t's and the
 * corresponding procs*/
static int
proc_stride_comp_f(void *a, void *b)
{
     struct proc_struct *p = le2proc(a, lab6_run_pool); // 从斜堆节点反推到进程结构
     struct proc_struct *q = le2proc(b, lab6_run_pool);
     // 使用有符号差值避免无符号溢出导致的比较错误，保证 |delta| < BIG_STRIDE
     int32_t delta = (int32_t)(p->lab6_stride - q->lab6_stride);
     if (delta > 0)
          return 1;  // p 的 stride 更大，优先级更低
     else if (delta < 0)
          return -1; // p 的 stride 更小，优先级更高
     else
          return 0;  // stride 相等视为同优先级

}

/*
 * stride_init initializes the run-queue rq with correct assignment for
 * member variables, including:
 *
 *   - run_list: should be a empty list after initialization.
 *   - lab6_run_pool: NULL
 *   - proc_num: 0
 *   - max_time_slice: no need here, the variable would be assigned by the caller.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
stride_init(struct run_queue *rq)
{
     /* LAB6 CHALLENGE 1: 2312642 */
     list_init(&(rq->run_list));
     rq->lab6_run_pool = NULL;
     rq->proc_num = 0;
}

/*
 * stride_enqueue inserts the process ``proc'' into the run-queue
 * ``rq''. The procedure should verify/initialize the relevant members
 * of ``proc'', and then put the ``lab6_run_pool'' node into the
 * queue(since we use priority queue here). The procedure should also
 * update the meta date in ``rq'' structure.
 *
 * proc->time_slice denotes the time slices allocation for the
 * process, which should set to rq->max_time_slice.
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
     /* LAB6 CHALLENGE 1: 2312642 */
#if USE_SKEW_HEAP
     // Ensure valid priority
     if (proc->lab6_priority == 0)
     {
          proc->lab6_priority = 1;
     }
     // Fresh time slice
     proc->time_slice = rq->max_time_slice;
     // (Re)init heap node before insertion
     skew_heap_init(&(proc->lab6_run_pool));
     rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
#else
     list_add_before(&(rq->run_list), &(proc->run_link));
     proc->time_slice = rq->max_time_slice;
#endif
     proc->rq = rq;
     rq->proc_num++;
}

/*
 * stride_dequeue removes the process ``proc'' from the run-queue
 * ``rq'', the operation would be finished by the skew_heap_remove
 * operations. Remember to update the ``rq'' structure.
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc)
{
     /* LAB6 CHALLENGE 1: 2312642 */
#if USE_SKEW_HEAP
     rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
#else
     list_del_init(&(proc->run_link));
#endif
     if (rq->proc_num > 0)
     {
          rq->proc_num--;
     }
}
/*
 * stride_pick_next pick the element from the ``run-queue'', with the
 * minimum value of stride, and returns the corresponding process
 * pointer. The process pointer would be calculated by macro le2proc,
 * see kern/process/proc.h for definition. Return NULL if
 * there is no process in the queue.
 *
 * When one proc structure is selected, remember to update the stride
 * property of the proc. (stride += BIG_STRIDE / priority)
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static struct proc_struct *
stride_pick_next(struct run_queue *rq)
{
     /* LAB6 CHALLENGE 1: 2312642 */
#if USE_SKEW_HEAP
     if (rq->lab6_run_pool == NULL)
     {
          return NULL;
     }
     struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
#else
     if (list_empty(&(rq->run_list)))
     {
          return NULL;
     }
     list_entry_t *le = list_next(&(rq->run_list));
     struct proc_struct *p = le2proc(le, run_link);
     list_entry_t *cur = le;
     while ((cur = list_next(cur)) != &(rq->run_list))
     {
          struct proc_struct *q = le2proc(cur, run_link);
          if ((int32_t)(q->lab6_stride - p->lab6_stride) < 0)
          {
               p = q;
          }
     }
#endif
     p->lab6_stride += BIG_STRIDE / p->lab6_priority;
     return p;
}

/*
 * stride_proc_tick works with the tick event of current process. You
 * should check whether the time slices for current process is
 * exhausted and update the proc struct ``proc''. proc->time_slice
 * denotes the time slices left for current
 * process. proc->need_resched is the flag variable for process
 * switching.
 */
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
     /* LAB6 CHALLENGE 1: 2312642 */
     if (proc->time_slice > 0)
     {
          proc->time_slice--;
     }
     if (proc->time_slice == 0)
     {
          proc->need_resched = 1;
     }
}

struct sched_class stride_sched_class = {
    .name = "stride_scheduler",
    .init = stride_init,
    .enqueue = stride_enqueue,
    .dequeue = stride_dequeue,
    .pick_next = stride_pick_next,
    .proc_tick = stride_proc_tick,
};
