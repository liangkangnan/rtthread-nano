/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2018/10/28     Bernard      The unify RISC-V porting code.
 */

#include <rthw.h>
#include <rtthread.h>

#include "timer_drv.h"
#include "hazard3_irq.h"
#include "printf.h"

#define TIMER0_IRQ_PRIORITY 10

void tick_isr(void)
{
    timer_clear_int_pending(TIMER0);

    //printf("isr\n");

    rt_interrupt_enter();
    rt_tick_increase();
    rt_interrupt_leave();
}

/* Sets and enable the timer interrupt */
int rt_hw_tick_init(void)
{
    external_irq_enable(true);

    h3irq_enable(TIMER0_IRQ_NUM, true);
    h3irq_set_priority(TIMER0_IRQ_NUM, TIMER0_IRQ_PRIORITY);
    h3irq_set_external_irq_handler(TIMER0_IRQ_NUM, tick_isr);

    timer_int_enable(TIMER0, true);
    timer_set_mode(TIMER0, TIMER_MODE_RELOAD);
    timer_set_div(TIMER0, 12);
    timer_set_expire_count(TIMER0, 1000000 / RT_TICK_PER_SECOND);
    timer_enable(TIMER0, true);

    return 0;
}
