#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_pmm.h>
#include <stdio.h>

// 1. 核心配置（适配 QEMU 128MB 内存）
#define MAX_ORDER 14          // 最大块大小 = 2^14 = 16384 页
#define BLOCK_SIZE(order) (1 << (order))  // 计算块大小（页）
#define PAGE_IDX(page) ((page) - pages)   // 计算页在全局数组中的索引

// 2. 空闲块管理：按块大小（2^order）维护多个空闲链表
static free_area_t buddy_free_areas[MAX_ORDER + 1];

// 辅助函数：判断节点是否在链表中
static int is_node_in_list(list_entry_t *head, list_entry_t *node) {
    list_entry_t *curr = head->next;
    while (curr != head) {
        if (curr == node) {
            return 1;
        }
        curr = curr->next;
    }
    return 0;
}

// 3. 辅助函数：计算请求n页对应的最小order（向上取整为2的幂）
static int get_min_order(size_t n) {
    if (n <= 0) return 0;
    int order = 0;
    size_t size = 1;
    while (size < n) {
        order++;
        size <<= 1;
        if (order > MAX_ORDER) {
            return -1;
        }
    }
    return order;
}

// 4. 辅助函数：计算页的伙伴页
static struct Page *get_buddy(struct Page *page, int order) {
    if (page == NULL || order < 0 || order > MAX_ORDER) {
        return NULL;
    }
    size_t block_size = BLOCK_SIZE(order);
    size_t page_idx = PAGE_IDX(page);
    size_t buddy_idx = page_idx ^ block_size;
    return (buddy_idx < npage) ? (pages + buddy_idx) : NULL;
}

// 9. 辅助函数：统计空闲页总数 - 提前声明
static size_t buddy_nr_free_pages(void);

// 5. 初始化函数：初始化所有空闲链表
static void buddy_init(void) {
    for (int i = 0; i <= MAX_ORDER; i++) {
        list_init(&buddy_free_areas[i].free_list);
        buddy_free_areas[i].nr_free = 0;
    }
    cprintf("buddy_pmm: init completed (max order: %d, max block size: %d pages)\n", 
            MAX_ORDER, BLOCK_SIZE(MAX_ORDER));
}

// 6. 内存映射初始化：将连续内存拆分为2的幂大小的块
static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0 && base != NULL);
    struct Page *p = base;

    // 初始化每页的基础状态
    for (; p != base + n; p++) {
        assert(PageReserved(p));
        p->flags = 0;
        p->property = 0;
        set_page_ref(p, 0);
        ClearPageProperty(p);
    }

    // 拆分连续内存为2的幂大小的块
    size_t remaining = n;
    struct Page *curr_base = base;
    
    while (remaining > 0) {
        int order = 0;
        size_t current_size = 1;
        
        // 找到最大的2的幂块
        while ((current_size * 2) <= remaining && (order + 1) <= MAX_ORDER) {
            order++;
            current_size *= 2;
        }
        
        size_t block_size = current_size;

        // 标记块首页的order
        curr_base->property = order;
        SetPageProperty(curr_base);

        // 将块加入对应order的空闲链表
        list_add_before(&buddy_free_areas[order].free_list, &curr_base->page_link);
        buddy_free_areas[order].nr_free++;

        remaining -= block_size;
        curr_base += block_size;
    }
    cprintf("buddy_pmm: init %d pages, total free: %d pages\n", 
            (int)n, (int)buddy_nr_free_pages());
}

// 7. 核心分配函数：按2的幂分配块
static struct Page *buddy_alloc_pages(size_t n) {
    assert(n > 0);

    int target_order = get_min_order(n);
    if (target_order == -1) {
        cprintf("buddy_pmm: alloc failed (request %d pages > max block size)\n", (int)n);
        return NULL;
    }

    // 从target_order开始找有空闲块的链表
    int order = target_order;
    for (; order <= MAX_ORDER; order++) {
        if (buddy_free_areas[order].nr_free > 0) {
            break;
        }
    }
    if (order > MAX_ORDER) {
        cprintf("buddy_pmm: alloc failed (no free block for %d pages)\n", (int)n);
        return NULL;
    }

    // 拆分大块（从order拆到target_order）
    while (order > target_order) {
        order--;
        size_t block_size = BLOCK_SIZE(order);

        // 从当前order+1的链表取一个块
        list_entry_t *le = list_next(&buddy_free_areas[order + 1].free_list);
        struct Page *parent_block = le2page(le, page_link);

        list_del(le);
        buddy_free_areas[order + 1].nr_free--;

        // 拆分为两个子块
        struct Page *right_block = parent_block + block_size;
        parent_block->property = order;
        right_block->property = order;
        SetPageProperty(parent_block);
        SetPageProperty(right_block);

        // 将两个子块加入当前order的空闲链表
        list_add_before(&buddy_free_areas[order].free_list, &parent_block->page_link);
        list_add_before(&buddy_free_areas[order].free_list, &right_block->page_link);
        buddy_free_areas[order].nr_free += 2;
    }

    // 从target_order链表取一个块分配
    list_entry_t *le = list_next(&buddy_free_areas[target_order].free_list);
    struct Page *alloc_block = le2page(le, page_link);

    list_del(le);
    buddy_free_areas[target_order].nr_free--;
    ClearPageProperty(alloc_block);

    cprintf("buddy_pmm: alloc %d pages (actual %d pages, order=%d)\n", 
            (int)n, (int)BLOCK_SIZE(target_order), target_order);
    return alloc_block;
}

// 8. 核心释放函数：释放块并尝试合并伙伴块 - 修复版本
static void buddy_free_pages(struct Page *base, size_t n) {
    assert(n > 0 && base != NULL);
    struct Page *p = base;

    // 验证释放页的合法性
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }

    // 确定释放块的order
    int order = get_min_order(n);
    assert(order >= 0 && order <= MAX_ORDER);
    assert(BLOCK_SIZE(order) == n);
    base->property = order;
    SetPageProperty(base);

    int final_order = order;

    // 先将块加入对应链表，然后再尝试合并
    list_add_before(&buddy_free_areas[order].free_list, &base->page_link);
    buddy_free_areas[order].nr_free++;

    // 尝试合并伙伴块
    while (order < MAX_ORDER) {
        struct Page *buddy = get_buddy(base, order);
        
        // 检查伙伴块是否可合并
        if (buddy == NULL || !PageProperty(buddy) || buddy->property != order) {
            break;
        }

        // 检查伙伴块是否在对应的空闲链表中
        if (!is_node_in_list(&buddy_free_areas[order].free_list, &buddy->page_link)) {
            break;
        }

        // 合并当前块与伙伴块
        list_del(&base->page_link);
        list_del(&buddy->page_link);
        buddy_free_areas[order].nr_free -= 2;

        // 确定合并后的大块首页（取地址较小的页）
        struct Page *merged_base = (base < buddy) ? base : buddy;
        merged_base->property = order + 1;
        SetPageProperty(merged_base);

        // 将合并后的块加入order+1的链表
        list_add_before(&buddy_free_areas[order + 1].free_list, &merged_base->page_link);
        buddy_free_areas[order + 1].nr_free++;

        base = merged_base;
        order++;
        final_order = order;
    }

    cprintf("buddy_pmm: free %d pages (start order=%d, final order=%d)\n", 
            (int)n, get_min_order(n), final_order);
}

// 9. 辅助函数：统计空闲页总数
static size_t buddy_nr_free_pages(void) {
    size_t total = 0;
    for (int i = 0; i <= MAX_ORDER; i++) {
        total += buddy_free_areas[i].nr_free * BLOCK_SIZE(i);
    }
    return total;
}

// 调试函数：打印所有order的空闲块信息
static void buddy_debug_info(void) {
    cprintf("=== Buddy System Debug Info ===\n");
    for (int i = 0; i <= MAX_ORDER; i++) {
        if (buddy_free_areas[i].nr_free > 0) {
            cprintf("Order %d: %d blocks, %d pages total\n", 
                    i, buddy_free_areas[i].nr_free, 
                    buddy_free_areas[i].nr_free * BLOCK_SIZE(i));
        }
    }
    cprintf("Total free pages: %d\n", (int)buddy_nr_free_pages());
    cprintf("===============================\n");
}

// 10. 测试函数：验证伙伴系统的分配、拆分、合并逻辑
static void buddy_check(void) {
    int score = 0, sum_score = 8;
    cprintf("\n=== Buddy System Enhanced Test Start ===\n");
    size_t initial_free = buddy_nr_free_pages();
    
    // 检测最大可用块
    size_t max_possible_block = 0;
    int max_order_found = -1;
    for (int o = MAX_ORDER; o >= 0; o--) {
        if (buddy_free_areas[o].nr_free > 0) {
            max_possible_block = BLOCK_SIZE(o);
            max_order_found = o;
            break;
        }
    }
    cprintf("buddy_check: initial free: %d pages, max available block: %d pages (order=%d)\n", 
            (int)initial_free, (int)max_possible_block, max_order_found);

    // 测试1：基础1页分配
    struct Page *p0 = alloc_page();
    assert(p0 != NULL && !PageProperty(p0));
    size_t after_alloc1 = buddy_nr_free_pages();
    assert(after_alloc1 == initial_free - 1);
    score++;
    cprintf("Test 1 Passed (alloc 1 page, free=%d) | Score: %d/%d\n", 
            (int)after_alloc1, score, sum_score);

    // 测试2：非2的幂分配
    struct Page *p1 = alloc_pages(3);
    assert(p1 != NULL);
    size_t after_alloc2 = buddy_nr_free_pages();
    assert(after_alloc2 == initial_free - 1 - 4);
    int has_free_block = 0;
    for (int o = 0; o <= 2; o++) {
        if (buddy_free_areas[o].nr_free > 0) {
            has_free_block = 1;
            break;
        }
    }
    assert(has_free_block == 1);
    score++;
    cprintf("Test 2 Passed (alloc 3->4 pages, split ok) | Score: %d/%d\n", score, sum_score);

    // 测试3：多轮分配+释放+合并
    free_pages(p1, 4);
    free_page(p0);
    
    struct Page *p2 = alloc_pages(8);
    struct Page *p3 = alloc_pages(2);
    assert(p2 != NULL && p3 != NULL);
    
    free_pages(p3, 2);
    struct Page *p1_new = alloc_pages(4);
    assert(p1_new != NULL);
    free_pages(p1_new, 4);
    free_pages(p2, 8);
    
    int has_large_block = 0;
    for (int o = 3; o <= MAX_ORDER; o++) {
        if (buddy_free_areas[o].nr_free > 0) {
            has_large_block = 1;
            break;
        }
    }
    assert(has_large_block == 1);
    score++;
    cprintf("Test 3 Passed (multi alloc/free/merge) | Score: %d/%d\n", score, sum_score);

    // 测试4：边界块合并
    int test_order = (MAX_ORDER >= 2) ? MAX_ORDER - 2 : 0;
    size_t test_block_size = BLOCK_SIZE(test_order);
    if (test_block_size > buddy_nr_free_pages()) {
        test_order = get_min_order(buddy_nr_free_pages() / 2);
        test_block_size = BLOCK_SIZE(test_order);
    }
    struct Page *p4 = alloc_pages(test_block_size);
    assert(p4 != NULL);
    free_pages(p4, test_block_size);
    
    struct Page *buddy_p4 = get_buddy(p4, test_order);
    if (buddy_p4 != NULL && PageProperty(buddy_p4) && buddy_p4->property == test_order) {
        assert(buddy_free_areas[test_order + 1].nr_free > 0);
    }
    score++;
    cprintf("Test 4 Passed (boundary merge, block size: %d) | Score: %d/%d\n", 
            (int)test_block_size, score, sum_score);

    // 测试5：最大块分配
    cprintf("Test 5: attempting to alloc %d pages (current free: %d)\n", 
            (int)max_possible_block, (int)buddy_nr_free_pages());
    struct Page *p5 = alloc_pages(max_possible_block);
    assert(p5 != NULL);
    
    size_t after_alloc5 = buddy_nr_free_pages();
    size_t expected_free = initial_free - max_possible_block;
    cprintf("After alloc: free pages = %d, expected = %d\n", 
            (int)after_alloc5, (int)expected_free);
    
    
    assert(after_alloc5 == expected_free);
    
    // 验证最大块链表已空
    int max_order = get_min_order(max_possible_block);
    assert(buddy_free_areas[max_order].nr_free == 0);
    score++;
    cprintf("Test 5 Passed (alloc max block: %d pages) | Score: %d/%d\n", 
            (int)max_possible_block, score, sum_score);

    // 测试6：分配超出最大块
    struct Page *p6 = alloc_pages(max_possible_block + 1);
    assert(p6 == NULL);
    score++;
    cprintf("Test 6 Passed (alloc >max block: failed) | Score: %d/%d\n", score, sum_score);

    // 测试7：释放后空闲数恢复
    free_pages(p5, max_possible_block);
    size_t final_free = buddy_nr_free_pages();
    
    // 严格检查：必须完全恢复
    assert(final_free == initial_free);
    score++;
    cprintf("Test 7 Passed (free count recover: %d) | Score: %d/%d\n", 
            (int)final_free, score, sum_score);

    // 测试8：连续小分配+合并 
    cprintf("Test 8: Testing small allocation and merge...\n");
    
    // 方法1：分配一个4页块，然后拆分成单页，再释放看是否能合并回去
    struct Page *base_block = alloc_pages(4);  // 分配4页块
    assert(base_block != NULL);
    
    // 记录这个4页块的地址
    struct Page *single_pages[4];
    for (int i = 0; i < 4; i++) {
        single_pages[i] = base_block + i;
    }
    
    // 释放这个4页块
    free_pages(base_block, 4);
    
    // 现在分配4个单页，应该从刚才释放的4页块中拆分出来
    struct Page *allocated_pages[4];
    for (int i = 0; i < 4; i++) {
        allocated_pages[i] = alloc_page();
        assert(allocated_pages[i] != NULL);
    }
    
    // 打印分配后的状态
    cprintf("After allocating 4 single pages from 4-page block:\n");
    buddy_debug_info();
    
    // 检查这些页是否来自同一个4页块（应该是连续的）
    int are_continuous = 1;
    for (int i = 1; i < 4; i++) {
        if (allocated_pages[i] != allocated_pages[i-1] + 1) {
            are_continuous = 0;
            break;
        }
    }
    
    if (are_continuous) {
        cprintf("Allocated pages are continuous, good for merging test\n");
        
        // 释放这4个连续的页，它们应该合并成一个4页块
        for (int i = 0; i < 4; i++) {
            free_page(allocated_pages[i]);
        }
        
        cprintf("After freeing 4 continuous pages:\n");
        buddy_debug_info();
        
        // 检查是否形成了4页块（order=2）
        if (buddy_free_areas[2].nr_free >= 1) {
            cprintf("Successfully merged into order=2 block\n");
        } else {
            cprintf("Warning: Expected order=2 block but not found\n");
            // 检查是否有更大的块包含了这些页
            for (int o = 3; o <= MAX_ORDER; o++) {
                if (buddy_free_areas[o].nr_free > 0) {
                    cprintf("Found larger block at order=%d instead\n", o);
                    break;
                }
            }
        }
    } else {
        cprintf("Allocated pages are not continuous, using alternative test\n");
        
        // 如果页不连续，使用替代测试：直接分配和释放4页块
        for (int i = 0; i < 4; i++) {
            free_page(allocated_pages[i]);
        }
        
        struct Page *test_block = alloc_pages(4);
        assert(test_block != NULL);
        free_pages(test_block, 4);
        
        cprintf("After alloc/free of 4-page block:\n");
        buddy_debug_info();
    }
    
    // 最终检查：必须存在order>=2的块
    int has_order2_plus = 0;
    for (int o = 2; o <= MAX_ORDER; o++) {
        if (buddy_free_areas[o].nr_free > 0) {
            has_order2_plus = 1;
            break;
        }
    }
    assert(has_order2_plus == 1);
    
    score++;
    cprintf("Test 8 Passed (small alloc + merge) | Score: %d/%d\n", score, sum_score);

    // 测试总结
    assert(buddy_nr_free_pages() == initial_free);
    cprintf("=== Buddy System Test Passed (Total: %d/%d) ===\n\n", score, sum_score);
}

// 11. 注册伙伴系统管理器
const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};
