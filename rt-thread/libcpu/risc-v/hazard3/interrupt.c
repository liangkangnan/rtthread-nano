#include <stdint.h>

#include "timer_drv.h"
#include "hazard3_irq.h"

//extern void rt_risc_v_exception_handler(void);
extern void rt_risc_v_external_interrupt_handler(void);

/**
 * This function will initialize hardware interrupt
 */
void rt_hw_interrupt_init(void)
{
    //irq_set_riscv_vector_handler(RISCV_VEC_MACHINE_EXCEPTION, rt_risc_v_exception_handler);
    irq_set_riscv_vector_handler(RISCV_VEC_MACHINE_EXTERNAL_IRQ, rt_risc_v_external_interrupt_handler);
}
