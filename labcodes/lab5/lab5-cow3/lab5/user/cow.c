#include <ulib.h>
#include <stdio.h>

int global_var = 42;

int main(void)
{
    int pid = fork();
    if (pid < 0) {
        cprintf("fork failed\n");
        return -1;
    }
    if (pid == 0) {
        /* child */
        cprintf("child: initial global = %d\n", global_var);
        global_var = 100;
        cprintf("child: wrote global = %d\n", global_var);
        exit(0);
    } else {
        /* parent */
        wait();
        cprintf("parent: after child global = %d\n", global_var);
        global_var = 200;
        cprintf("parent: wrote global = %d\n", global_var);
        return 0;
    }
}
