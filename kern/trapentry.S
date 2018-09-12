/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(vector0, 0)
TRAPHANDLER_NOEC(vector1, 1)
TRAPHANDLER_NOEC(vector2, 2)
TRAPHANDLER_NOEC(vector3, 3)
TRAPHANDLER_NOEC(vector4, 4)
TRAPHANDLER_NOEC(vector5, 5)
TRAPHANDLER_NOEC(vector6, 6)
TRAPHANDLER_NOEC(vector7, 7)
TRAPHANDLER(vector8, 8)
TRAPHANDLER_NOEC(vector9, 9)
TRAPHANDLER(vector10, 10)
TRAPHANDLER(vector11, 11)
TRAPHANDLER(vector12, 12)
TRAPHANDLER(vector13, 13)
TRAPHANDLER(vector14, 14)
TRAPHANDLER_NOEC(vector15, 15)
TRAPHANDLER_NOEC(vector16, 16)
TRAPHANDLER(vector17, 17)
TRAPHANDLER_NOEC(vector18, 18)
TRAPHANDLER_NOEC(vector19, 19)
TRAPHANDLER_NOEC(vector48, 48)

TRAPHANDLER_NOEC(vector32, 32)
TRAPHANDLER_NOEC(vector33, 33)
TRAPHANDLER_NOEC(vector34, 34)
TRAPHANDLER_NOEC(vector35, 35)
TRAPHANDLER_NOEC(vector36, 36)
TRAPHANDLER_NOEC(vector37, 37)
TRAPHANDLER_NOEC(vector38, 38)
TRAPHANDLER_NOEC(vector39, 39)
TRAPHANDLER_NOEC(vector40, 40)
TRAPHANDLER_NOEC(vector41, 41)
TRAPHANDLER_NOEC(vector42, 42)
TRAPHANDLER_NOEC(vector43, 43)
TRAPHANDLER_NOEC(vector44, 44)
TRAPHANDLER_NOEC(vector45, 45)
TRAPHANDLER_NOEC(vector46, 46)
TRAPHANDLER_NOEC(vector47, 47)


.data
.globl vectors
vectors:
	.long vector0
	.long vector1
	.long vector2
	.long vector3
	.long vector4
	.long vector5
	.long vector6
	.long vector7
	.long vector8
	.long vector9
	.long vector10
	.long vector11
	.long vector12
	.long vector13
	.long vector14
	.long vector15
	.long vector16
	.long vector17
	.long vector18
	.long vector19
    .long vector48
    .long vector32
    .long vector33
    .long vector34
    .long vector35
    .long vector36
    .long vector37
    .long vector38
    .long vector39
    .long vector40
    .long vector41
    .long vector42
    .long vector43
    .long vector44
    .long vector45
    .long vector46


.text

/*
 * Lab 3: Your code here for _alltraps
 */
.globl _alltraps
_alltraps:
    pushl %ds
    pushl %es
    pushal
    movw $(GD_KD), %ax
    movw %ax, %ds
    movw %ax, %es
    pushl %esp
    call trap
    addl $4, %esp

.globl trapret
trapret:
    popal
    popl %es
    popl %ds
    addl $0x8, %esp
    iret
