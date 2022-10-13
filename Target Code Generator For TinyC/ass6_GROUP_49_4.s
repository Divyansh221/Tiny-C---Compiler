	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"\n      ######################################################\n"
.LC1:
	.string	"      ##                                                  ##\n"
.LC2:
	.string	"      ##                Fibonacci Numbers                 ##\n"
.LC3:
	.string	"      ##                                                  ##\n"
.LC4:
	.string	"      ######################################################\n\n"
.LC5:
	.string	"      Enter the value of N (<= 45): "
.LC6:
	.string	"      The entered value is: "
.LC7:
	.string	"      The first N fibonacci numbers are :\n"
.LC8:
	.string	"      "
.LC9:
	.string	"      "
.LC10:
	.string	"      "
.LC11:
	.string	"      "
.LC12:
	.string	"\n"
	.text	
	.globl	main
	.type	main, @function
main: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$248, %rsp

	movq 	$.LC0, -28(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printStr
	movl	%eax, -32(%rbp)
	movq 	$.LC1, -36(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	printStr
	movl	%eax, -40(%rbp)
	movq 	$.LC2, -44(%rbp)
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rdi
	call	printStr
	movl	%eax, -48(%rbp)
	movq 	$.LC3, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	printStr
	movl	%eax, -56(%rbp)
	movq 	$.LC4, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printStr
	movl	%eax, -64(%rbp)
	movq 	$.LC5, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printStr
	movl	%eax, -72(%rbp)
	leaq	-80(%rbp), %rax
	movq 	%rax, -88(%rbp)
	movl 	-88(%rbp), %eax
	movq 	-88(%rbp), %rdi
	call	readInt
	movl	%eax, -92(%rbp)
	movl	-92(%rbp), %eax
	movl 	%eax, -76(%rbp)
	movq 	$.LC6, -100(%rbp)
	movl 	-100(%rbp), %eax
	movq 	-100(%rbp), %rdi
	call	printStr
	movl	%eax, -104(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	printInt
	movl	%eax, -112(%rbp)
	movq 	$.LC7, -116(%rbp)
	movl 	-116(%rbp), %eax
	movq 	-116(%rbp), %rdi
	call	printStr
	movl	%eax, -120(%rbp)
	movl	$0, %eax
	movl 	%eax, -132(%rbp)
	movl	-132(%rbp), %eax
	movl 	%eax, -128(%rbp)
	movl	$1, %eax
	movl 	%eax, -140(%rbp)
	movl	-140(%rbp), %eax
	movl 	%eax, -136(%rbp)
	movq 	$.LC8, -148(%rbp)
	movl 	-148(%rbp), %eax
	movq 	-148(%rbp), %rdi
	call	printStr
	movl	%eax, -152(%rbp)
	movl	$0, %eax
	movl 	%eax, -156(%rbp)
	movl	-76(%rbp), %eax
	cmpl	-156(%rbp), %eax
	jg .L2
	jmp .L3
	jmp .L3
.L2: 
	movl 	-128(%rbp), %eax
	movq 	-128(%rbp), %rdi
	call	printInt
	movl	%eax, -160(%rbp)
	jmp .L3
.L3: 
	movq 	$.LC9, -164(%rbp)
	movl 	-164(%rbp), %eax
	movq 	-164(%rbp), %rdi
	call	printStr
	movl	%eax, -168(%rbp)
	movl	$1, %eax
	movl 	%eax, -172(%rbp)
	movl	-76(%rbp), %eax
	cmpl	-172(%rbp), %eax
	jg .L4
	jmp .L5
	jmp .L5
.L4: 
	movl 	-136(%rbp), %eax
	movq 	-136(%rbp), %rdi
	call	printInt
	movl	%eax, -176(%rbp)
	jmp .L5
.L5: 
	movq 	$.LC10, -180(%rbp)
	movl 	-180(%rbp), %eax
	movq 	-180(%rbp), %rdi
	call	printStr
	movl	%eax, -184(%rbp)
	movl	$2, %eax
	movl 	%eax, -188(%rbp)
	movl	-188(%rbp), %eax
	movl 	%eax, -124(%rbp)
.L6: 
	movl	-124(%rbp), %eax
	cmpl	-76(%rbp), %eax
	jl .L8
	jmp .L9
.L7: 
	movl	-124(%rbp), %eax
	movl 	%eax, -196(%rbp)
	addl 	$1, -124(%rbp)
	jmp .L6
.L8: 
	movl 	-128(%rbp), %eax
	movl 	-136(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -200(%rbp)
	movl	-200(%rbp), %eax
	movl 	%eax, -144(%rbp)
	movl 	-144(%rbp), %eax
	movq 	-144(%rbp), %rdi
	call	printInt
	movl	%eax, -208(%rbp)
	movq 	$.LC11, -212(%rbp)
	movl 	-212(%rbp), %eax
	movq 	-212(%rbp), %rdi
	call	printStr
	movl	%eax, -216(%rbp)
	movl	-136(%rbp), %eax
	movl 	%eax, -128(%rbp)
	movl	-144(%rbp), %eax
	movl 	%eax, -136(%rbp)
	movl	$10, %eax
	movl 	%eax, -232(%rbp)
	movl 	-124(%rbp), %eax
	cltd
	idivl 	-232(%rbp)
	movl 	%eax, -236(%rbp)
	movl	-236(%rbp), %eax
	movl 	%eax, -228(%rbp)
	jmp .L7
.L9: 
	movq 	$.LC12, -240(%rbp)
	movl 	-240(%rbp), %eax
	movq 	-240(%rbp), %rdi
	call	printStr
	movl	%eax, -244(%rbp)
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by GROUP_49"
	.section	.note.GNU-stack,"",@progbits
