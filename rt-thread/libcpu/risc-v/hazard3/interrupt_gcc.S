#include "riscv_csr.h"
#include "cpuport.h"

.global rt_risc_v_external_interrupt_handler


.section .time_critical.rt_risc_v_external_interrupt_handler
.align 2
rt_risc_v_external_interrupt_handler:

    /* save thread context to thread stack */
    addi sp, sp, -32 * REGBYTES

    STORE x1,   1 * REGBYTES(sp)

    csrr  x1, mstatus
    STORE x1,   2 * REGBYTES(sp)

    csrr  x1, mepc
    STORE x1,   0 * REGBYTES(sp)

    STORE x4,   4 * REGBYTES(sp)
    STORE x5,   5 * REGBYTES(sp)
    STORE x6,   6 * REGBYTES(sp)
    STORE x7,   7 * REGBYTES(sp)
    STORE x8,   8 * REGBYTES(sp)
    STORE x9,   9 * REGBYTES(sp)
    STORE x10, 10 * REGBYTES(sp)
    STORE x11, 11 * REGBYTES(sp)
    STORE x12, 12 * REGBYTES(sp)
    STORE x13, 13 * REGBYTES(sp)
    STORE x14, 14 * REGBYTES(sp)
    STORE x15, 15 * REGBYTES(sp)
    STORE x16, 16 * REGBYTES(sp)
    STORE x17, 17 * REGBYTES(sp)
    STORE x18, 18 * REGBYTES(sp)
    STORE x19, 19 * REGBYTES(sp)
    STORE x20, 20 * REGBYTES(sp)
    STORE x21, 21 * REGBYTES(sp)
    STORE x22, 22 * REGBYTES(sp)
    STORE x23, 23 * REGBYTES(sp)
    STORE x24, 24 * REGBYTES(sp)
    STORE x25, 25 * REGBYTES(sp)
    STORE x26, 26 * REGBYTES(sp)
    STORE x27, 27 * REGBYTES(sp)
    STORE x28, 28 * REGBYTES(sp)
    STORE x29, 29 * REGBYTES(sp)
    STORE x30, 30 * REGBYTES(sp)
    STORE x31, 31 * REGBYTES(sp)

    /* save current thread sp */
    mv  s0, sp

    /* switch to interrupt stack */
    la sp, _stack_top

    // note we replace/recreate the SDK's IRQ mechansim here, since we want to control the exception stacking
save_meicontext:
    // Make sure to set meicontext.clearts to clear+save mie.msie/mtie along
    // with ext IRQ context. We don't let these preempt ext IRQs because they
    // clear meicontext.mreteirq, which breaks __get_current_exception().
    csrrsi s2, RVCSR_MEICONTEXT_OFFSET, RVCSR_MEICONTEXT_CLEARTS_BITS

get_first_irq:
    // Sample the current highest-priority active IRQ (left-shifted by 2) from
    // meinext, and write 1 to meinext.update to update meicontext with the
    // preemption priority and IRQ number of this IRQ
    csrrsi a0, RVCSR_MEINEXT_OFFSET, RVCSR_MEINEXT_UPDATE_BITS
    // MSB will be set if there is no active IRQ at the current priority level
    bltz a0, no_more_irqs
dispatch_irq:
#if RT_ALLOW_NESTED_IRQs
    // Preemption priority was configured by meinext update, so enable preemption:
    csrsi mstatus, 0x8
#endif
    // <- from this point we can be preempted by a higher-priority interrupt.
    // meinext is pre-shifted by 2, so only an add is required to index table
    lui a1, %hi(__external_irq_vector_table)
    add a1, a1, a0
    lw a1, %lo(__external_irq_vector_table)(a1)
    jalr ra, a1
    // note: beware: freertos_risc_v_mtimer_interrupt_handler trashes s0 and s1, but
    // we require s2, s10, s11 saved.

#if RT_ALLOW_NESTED_IRQs
    // Disable IRQs on returning so we can sample the next IRQ
    csrci mstatus, 0x8
#endif
get_next_irq:
    // Get the next-highest-priority IRQ that is active at this level. If
    // there is such an IRQ, update meicontext with new preemption priority.
    csrrsi a0, RVCSR_MEINEXT_OFFSET, RVCSR_MEINEXT_UPDATE_BITS
    // MSB will be set if there is no active IRQ at the current priority level
    bgez a0, dispatch_irq

no_more_irqs:
    /* switch to from_thread stack */
    move  sp, s0

    /* need to switch new thread */
    la    s0, rt_thread_switch_interrupt_flag
    lw    s2, 0(s0)
    beqz  s2, spurious_interrupt
    sw    zero, 0(s0)

    la    s0, rt_interrupt_from_thread
    LOAD  s1, 0(s0)
    STORE sp, 0(s1)

    la    s0, rt_interrupt_to_thread
    LOAD  s1, 0(s0)
    LOAD  sp, 0(s1)

spurious_interrupt:
    j rt_hw_context_switch_exit
