#include <asm.h>

ENTRY(write)
	pushl %ebp
	movl %esp, %ebp

	//Move write parameters to the registers (no se si es movl o pushl)
	movl 0x08(%ebp), %ebx
	movl 0x0c(%ebp), %ecx
	movl 0x10(%ebp), %edx


	//pushl  %ebx
        //pushl  %ecx
        //pushl  %edx



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

