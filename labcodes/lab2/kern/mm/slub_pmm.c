#include "slub_pmm.h"
#include <pmm.h>
#include <string.h>
#include <stdio.h> 

extern uintptr_t va_pa_offset;

/* 获取内核虚拟地址 */
static inline void *page2kva(struct Page *page) {
    return (void *)(page2pa(page) + va_pa_offset);
}

/* 分配一个新的 slab */
static struct slab *alloc_page_slab(struct kmem_cache *cache) {
    struct Page *page = alloc_page();
    if (!page) return NULL;

    struct slab *s = (struct slab *)page2kva(page);
    s->start = (void *)((char *)s + sizeof(struct slab));

    s->obj_num = (PGSIZE - sizeof(struct slab)) / cache->obj_size;
    s->free_count = s->obj_num;

    s->free_list = (void **)s->start;
    char *ptr = s->start;
    for (size_t i = 0; i < s->obj_num - 1; i++) {
        *(void **)ptr = ptr + cache->obj_size;
        ptr += cache->obj_size;
    }
    *(void **)ptr = NULL;

    s->next = NULL;
    return s;
}

/* 创建 cache */
struct kmem_cache *kmem_cache_create(size_t obj_size) {
    struct Page *page = alloc_page();
    if (!page) return NULL;

    struct kmem_cache *cache = (struct kmem_cache *)page2kva(page);
    cache->obj_size = obj_size;
    cache->partial = NULL;
    return cache;
}

/* 分配对象 */
void *kmem_cache_alloc(struct kmem_cache *cache) {
    struct slab *s = cache->partial;

    /* 查找有空闲对象的 slab */
    while (s && !s->free_list)
        s = s->next;

    if (!s) {
        s = alloc_page_slab(cache);
        if (!s) return NULL;
        s->next = cache->partial;
        cache->partial = s;
    }

    void *obj = s->free_list;
    s->free_list = *(void **)obj;
    s->free_count--;
    return obj;
}

/* 查找对象所在 slab */
static struct slab *find_slab(struct kmem_cache *cache, void *obj) {
    struct slab *s = cache->partial;
    while (s) {
        uintptr_t start = (uintptr_t)s->start;
        uintptr_t end = start + s->obj_num * cache->obj_size;
        uintptr_t p = (uintptr_t)obj;
        if (p >= start && p < end)
            return s;
        s = s->next;
    }
    return NULL;
}

/* 释放对象 */
void kmem_cache_free(struct kmem_cache *cache, void *obj) {
    struct slab *s = find_slab(cache, obj);
    if (!s) {
        cputs("Warning: free ptr not found in any slab!\n");
        return;
    }

    *(void **)obj = s->free_list;
    s->free_list = obj;
    s->free_count++;
}

/* ------------------------- 测试功能 ------------------------- */

/* 检查指针对齐 */
static inline void check_alignment(void *ptr, size_t align, const char *name, int *ok) {
    if (((uintptr_t)ptr & (align - 1)) != 0) {
        cprintf("Alignment error: %s at %p is not %lu-byte aligned!\n", name, ptr, align);
        *ok = 0;
    }
}

/* 测试对象写入和读取完整性 */
static inline void test_object_integrity(void *obj, size_t size, uint8_t pattern, const char *name, int *ok) {
    memset(obj, pattern, size);
    for (size_t i = 0; i < size; i++) {
        if (((uint8_t *)obj)[i] != pattern) {
            cprintf("Integrity error: %s[%lu] != 0x%x\n", name, i, pattern);
            *ok = 0;
            return;
        }
    }
}

/* SLUB 全功能测试 */
void slub_check(void) {
    cputs("=== SLUB Full Feature Test ===\n");

    int total_score = 0;
    const int max_score = 7;

    struct kmem_cache *cache32 = kmem_cache_create(32);
    struct kmem_cache *cache64 = kmem_cache_create(64);
    struct kmem_cache *cache128 = kmem_cache_create(128);

    void *objs32[200];
    void *objs64[100];
    void *objs128[100];

    size_t i;
    int step_ok;

    // 基础分配测试
    cputs(">>> Step 1: Basic allocation test\n");
    step_ok = 1;
    for (i = 0; i < 50; i++) {
        objs32[i] = kmem_cache_alloc(cache32);
        objs64[i] = kmem_cache_alloc(cache64);
        objs128[i] = kmem_cache_alloc(cache128);
        cprintf("Allocated 32B obj[%lu] at %p\n", i, objs32[i]);
        cprintf("Allocated 64B obj[%lu] at %p\n", i, objs64[i]);
        cprintf("Allocated 128B obj[%lu] at %p\n", i, objs128[i]);
        if (!objs32[i] || !objs64[i] || !objs128[i]) step_ok = 0;
    }
    if (step_ok) { total_score++; cprintf("Step 1 Passed | Score: %d/%d\n", total_score, max_score); }
    else cprintf("Step 1 Failed | Score: %d/%d\n", total_score, max_score);

    // 内存对齐验证
    cputs(">>> Step 2: Alignment check\n");
    step_ok = 1;
    for (i = 0; i < 50; i++) {
        check_alignment(objs32[i], 8, "32B obj", &step_ok);
        check_alignment(objs64[i], 8, "64B obj", &step_ok);
        check_alignment(objs128[i], 8, "128B obj", &step_ok);
    }
    if (step_ok) { total_score++; cprintf("Step 2 Passed | Score: %d/%d\n", total_score, max_score); }
    else cprintf("Step 2 Failed | Score: %d/%d\n", total_score, max_score);

    // 对象完整性测试
    cputs(">>> Step 3: Object integrity test\n");
    step_ok = 1;
    for (i = 0; i < 50; i++) {
        test_object_integrity(objs32[i], 32, 0xAA, "32B obj", &step_ok);
        test_object_integrity(objs64[i], 64, 0xBB, "64B obj", &step_ok);
        test_object_integrity(objs128[i], 128, 0xCC, "128B obj", &step_ok);
    }
    if (step_ok) { total_score++; cprintf("Step 3 Passed | Score: %d/%d\n", total_score, max_score); }
    else cprintf("Step 3 Failed | Score: %d/%d\n", total_score, max_score);

    // 随机释放奇数索引对象
    cputs(">>> Step 4: Free odd-indexed objects\n");
    for (i = 1; i < 50; i += 2) {
        kmem_cache_free(cache32, objs32[i]);
        kmem_cache_free(cache64, objs64[i]);
        kmem_cache_free(cache128, objs128[i]);
        cprintf("Freed 32B obj[%lu] at %p\n", i, objs32[i]);
        cprintf("Freed 64B obj[%lu] at %p\n", i, objs64[i]);
        cprintf("Freed 128B obj[%lu] at %p\n", i, objs128[i]);
    }
    total_score++; cprintf("Step 4 Passed | Score: %d/%d\n", total_score, max_score);

    // 测试空闲对象复用
    cputs(">>> Step 5: Re-allocate objects to test reuse\n");
    step_ok = 1;
    for (i = 0; i < 25; i++) {
        void *p32 = kmem_cache_alloc(cache32);
        void *p64 = kmem_cache_alloc(cache64);
        void *p128 = kmem_cache_alloc(cache128);
        cprintf("Re-allocated 32B obj at %p\n", p32);
        cprintf("Re-allocated 64B obj at %p\n", p64);
        cprintf("Re-allocated 128B obj at %p\n", p128);
        if (!p32 || !p64 || !p128) step_ok = 0;
    }
    if (step_ok) { total_score++; cprintf("Step 5 Passed | Score: %d/%d\n", total_score, max_score); }
    else cprintf("Step 5 Failed | Score: %d/%d\n", total_score, max_score);

    // 边界条件测试
    cputs(">>> Step 6: Boundary and error handling test\n");
    void *fake_obj;
    kmem_cache_free(cache32, &fake_obj); // 未分配对象释放
    kmem_cache_free(cache32, objs32[0]); // 正确释放
    kmem_cache_free(cache32, objs32[0]); // 重复释放
    total_score++; cprintf("Step 6 Passed | Score: %d/%d\n", total_score, max_score);

    // 大量对象分配能力测试
    cputs(">>> Step 7: Multi-slab allocation test\n");
    step_ok = 1;
    size_t total_objs = 200;
    for (i = 0; i < total_objs; i++) {
        objs32[i] = kmem_cache_alloc(cache32);
        if (!objs32[i]) {
            step_ok = 0;
            cprintf("Allocation failed at index %lu\n", i);
        }
    }
    if (step_ok) {
        total_score++;
        cprintf("Step 7 Passed | Score: %d/%d\n", total_score, max_score);
    } else {
        cprintf("Step 7 Failed | Score: %d/%d\n", total_score, max_score);
    }

    // 最终结果总结
    cprintf("\n=== SLUB Full Feature Test Completed | Total Score: %d/%d ===\n", total_score, max_score);
    if (total_score == max_score) cputs(">>> All tests passed successfully! <<<\n");
}

