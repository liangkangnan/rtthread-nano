#include <stdint.h>

#include "rtthread.h"
#include "rtdef.h"

static struct rt_thread thread1;
static struct rt_thread thread2;
static rt_uint8_t thread1_stack[2048];
static rt_uint8_t thread2_stack[2048];

static void rt_thread1_entry(void *parameter)
{
    rt_kprintf("thread 1 started\n");

    while (1) {
        rt_thread_mdelay(100);
        rt_kprintf("thread 1.\n");
    }
}

static void rt_thread2_entry(void *parameter)
{
    rt_kprintf("thread 2 started\n");

    while (1) {
        rt_thread_mdelay(100);
        rt_kprintf("thread 2.\n");
    }
}


int main()
{
    rt_kprintf("Hello, RT-Thread!\n");

    /* initialize thread 1 */
    rt_thread_init(&thread1,
                   "1",
                   rt_thread1_entry,
                   RT_NULL,
                   &thread1_stack[0],
                   sizeof(thread1_stack),
                   RT_THREAD_PRIORITY_MAX / 5,
                   10);
    /* startup */
    rt_thread_startup(&thread1);

    /* initialize thread 2 */
    rt_thread_init(&thread2,
                   "2",
                   rt_thread2_entry,
                   RT_NULL,
                   &thread2_stack[0],
                   sizeof(thread2_stack),
                   RT_THREAD_PRIORITY_MAX / 4,
                   20);
    /* startup */
    rt_thread_startup(&thread2);

    while (1)
    {
        rt_thread_mdelay(500);
    }
}
