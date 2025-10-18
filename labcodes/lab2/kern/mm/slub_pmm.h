#ifndef _SLUB_PMM_H_
#define _SLUB_PMM_H_

#include "../../libs/defs.h"   // 提供 uintptr_t, size_t, uint8_t 等

struct Page; // 前置声明

/* slab 结构 */
struct slab {
    struct slab *next;     // slab 链表
    void *start;           // slab 对象起始地址
    size_t obj_num;        // 对象总数
    size_t free_count;     // 空闲数量
    void **free_list;      // 空闲对象链表
};

/* kmem_cache 结构 */
struct kmem_cache {
    size_t obj_size;
    struct slab *partial;  // 有空闲对象的 slab 链表
};

/* 外部接口 */
struct kmem_cache *kmem_cache_create(size_t obj_size);
void *kmem_cache_alloc(struct kmem_cache *cache);
void kmem_cache_free(struct kmem_cache *cache, void *obj);
void slub_check(void);

#endif

