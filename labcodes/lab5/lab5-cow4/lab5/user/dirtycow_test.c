#include <ulib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Dirty COW Vulnerability Test Program
// This program demonstrates the race condition in Copy-On-Write implementation

// A constant string that should be read-only
const char cow_target[] = "PROTECTED: Should not be modified!";

// Function to try writing to the "read-only" string
void dirty_write(int proc_id) {
    char *ptr = (char *)cow_target;
    const char exploit_str[] = "EXPLOITED";
    int attempts = 0;
    
    while (1) {
        attempts++;
        
        // Attempt to write to the read-only memory
        // This should trigger page faults that the kernel will handle with COW
        memcpy(ptr, exploit_str, strlen(exploit_str));
        
        // Check if the write succeeded
        if (strncmp(cow_target, exploit_str, strlen(exploit_str)) == 0) {
            cprintf("\n[*] SUCCESS! Process %d modified read-only memory!\n", proc_id);
            cprintf("[*] Attempts: %d\n", attempts);
            cprintf("[*] Original: %s\n", "PROTECTED: Should not be modified!");
            cprintf("[*] Current:  %s\n", cow_target);
            exit(0);
        }
        
        // More frequently yield to increase race condition chance
        if (attempts % 100 == 0) {
            if (attempts % 10000 == 0) {
                cprintf("."); // Progress indicator
            }
            yield();
        }
        
        // Limit attempts to reasonable time
        if (attempts > 100000) {
            break;
        }
    }
    
    cprintf("\n[*] Process %d failed after %d attempts\n", proc_id, attempts);
}

// Function to check the current state of the target string
// 在check_state函数中添加超时
void check_state(int proc_id) {
    int timeout = 100000;
    while (timeout-- > 0) {
        if (strcmp(cow_target, "PROTECTED: Should not be modified!") != 0) {
            cprintf("\n[!] DETECTED modification!\n");
            exit(0);
        }
        yield();
    }
    cprintf("[!] Monitor exit after timeout\n");
    exit(0);  // 超时也要exit
}

int main(void) {
    cprintf("\n==========================================\n");
    cprintf("      Dirty COW Vulnerability Test        \n");
    cprintf("==========================================\n");
    cprintf("Target read-only string: %s\n", cow_target);
    cprintf("\n[*] Creating race condition with multiple processes...\n");
    cprintf("[*] This will generate many page faults - normal behavior.\n");
    cprintf("[*] Look for 'SUCCESS' message below.\n");
    cprintf("==========================================\n");
    
    int i, pid;
    
    // Create multiple writer processes to increase race condition chance
    for (i = 0; i < 4; i++) {
        pid = fork();
        if (pid < 0) {
            cprintf("\nfork failed\n");
            return -1;
        }
        if (pid == 0) {
            // Child writer process
            dirty_write(i + 1);
            exit(0);
        }
    }
    
    // Create a monitor process to check for modifications
    pid = fork();
    if (pid == 0) {
        check_state(0);
        exit(0);
    }
    
    // Parent process also participates in writing
    dirty_write(5);
    
    // Wait for all children (though they should exit on success/failure)
    for (i = 0; i < 5; i++) {
        wait();
    }
    
    cprintf("\n==========================================\n");
    cprintf("[*] Test completed. Final state: %s\n", cow_target);
    
    if (strcmp(cow_target, "PROTECTED: Should not be modified!") != 0) {
        cprintf("[!] Dirty COW vulnerability CONFIRMED!\n");
        return 1;
    } else {
        cprintf("[-] No modification detected. Try running again.\n");
        return 0;
    }
}
