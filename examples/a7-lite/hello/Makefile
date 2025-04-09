APP  := hello_rtthread

SRCS := main.c board.c

KERNEL_SRC_PATH := ../../../rt-thread

# rtthread kernel source
SRCS += $(KERNEL_SRC_PATH)/src/clock.c
SRCS += $(KERNEL_SRC_PATH)/src/components.c
SRCS += $(KERNEL_SRC_PATH)/src/cpu.c
SRCS += $(KERNEL_SRC_PATH)/src/device.c
SRCS += $(KERNEL_SRC_PATH)/src/idle.c
SRCS += $(KERNEL_SRC_PATH)/src/ipc.c
SRCS += $(KERNEL_SRC_PATH)/src/irq.c
SRCS += $(KERNEL_SRC_PATH)/src/kservice.c
SRCS += $(KERNEL_SRC_PATH)/src/mem.c
SRCS += $(KERNEL_SRC_PATH)/src/memheap.c
SRCS += $(KERNEL_SRC_PATH)/src/mempool.c
SRCS += $(KERNEL_SRC_PATH)/src/object.c
SRCS += $(KERNEL_SRC_PATH)/src/scheduler.c
SRCS += $(KERNEL_SRC_PATH)/src/signal.c
SRCS += $(KERNEL_SRC_PATH)/src/slab.c
SRCS += $(KERNEL_SRC_PATH)/src/thread.c
SRCS += $(KERNEL_SRC_PATH)/src/timer.c

# libcpu source
SRCS += $(KERNEL_SRC_PATH)/libcpu/risc-v/hazard3/interrupt.c
SRCS += $(KERNEL_SRC_PATH)/libcpu/risc-v/hazard3/tick.c
SRCS += $(KERNEL_SRC_PATH)/libcpu/risc-v/hazard3/interrupt_gcc.S
SRCS += $(KERNEL_SRC_PATH)/libcpu/risc-v/hazard3/context_gcc.S

# common source
SRCS += $(KERNEL_SRC_PATH)/libcpu/risc-v/common/cpuport.c

INCDIR = .
INCDIR += $(KERNEL_SRC_PATH)/include
INCDIR += $(KERNEL_SRC_PATH)/libcpu/risc-v/hazard3
INCDIR += $(KERNEL_SRC_PATH)/libcpu/risc-v/common

CCFLAGS = -march=rv32imac_zicsr_zifencei -g

CCFLAGS += -DRUNNING_RTOS -DRTOS_RTTHREAD

SDK_PATH := ../../../..

include $(SDK_PATH)/common/common.mk
