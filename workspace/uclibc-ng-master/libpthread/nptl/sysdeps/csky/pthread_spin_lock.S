#include <sysdep.h>

	.text
	.align	4

ENTRY (pthread_spin_lock)
	mov	a2, a0
1:
	movi	a0, 0
	movi	a1, 1
	trap	2		// trap 2 use to cmpxchg
	cmpnei	a0, 0
	bt	1b
	movi	a0, 0
	jmp	r15

    /* TODO */
END (pthread_spin_lock)
