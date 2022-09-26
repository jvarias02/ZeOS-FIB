#include <asm.h>

/* (no_fast)
ENTRY(write)
	pushl %ebp
	movl %esp, %ebp

	//Move write parameters to the registers (no se si es movl o pushl)
	movl 0x08(%ebp), %ebx
	movl 0x0c(%ebp), %ecx
	movl 0x10(%ebp), %edx

	//System call identifier
	movl $4, %eax

	int $0x80

	//Process result
	cmpl $0, %eax
	jge no_error
	negl %eax
	movl %eax, errno //?
	movl $-1, %eax

no_error:
	popl %ebp
	ret

*/

ENTRY(write)
	pushl %ebp
	movl %esp, %ebp

	movl 0x08(%ebp), %ebx
	movl 0x0c(%ebp), %ecx
	movl 0x10(%ebp), %edx

	//System call identifier
	movl $4, %eax

	//Push to user stack
	pushl %ecx
	pushl %edx
	//Store return address
	pushl $return

	pushl %ebp
	movl %esp, %ebp

	sysenter


return:
	popl %ebp
	popl %edx //pop return address
	popl %edx
	popl %ecx

	cmpl $0, %eax
	jge no_error

	//Process result
	cmpl $0, %eax
	jge no_error
	negl %eax
	movl %eax, errno //?
	movl $-1, %eax

no_error:
	popl %ebp
	ret


ENTRY(gettime)
	pushl %ebp
	movl %esp, %ebp

	//System call identifier
	movl $10, %eax

	//Push to user stack
	pushl %ecx
	pushl %edx
	//Store return address
	pushl $gt_return

	pushl %ebp
	movl %esp, %ebp

	sysenter


gt_return:
	popl %ebp
	popl %edx //pop return address
	popl %edx
	popl %ecx

	cmpl $0, %eax
	jge no_error

	//Process result
	cmpl $0, %eax
	jge gt_no_error
	negl %eax
	movl %eax, errno //?
	movl $-1, %eax

gt_no_error:
	popl %ebp
	ret

/*
ENTRY(gettime)
        pushl %ebp
        movl %esp, %ebp

        //System call identifier
        movl $10, %eax

        int $0x80

        //Process result
        cmpl $0, %eax
        jge gt_no_error
        negl %eax
        movl %eax, errno //?
        movl $-1, %eax

gt_no_error:
        popl %ebp
        ret
*/
