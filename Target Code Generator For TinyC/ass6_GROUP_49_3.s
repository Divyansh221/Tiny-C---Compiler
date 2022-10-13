	.file	"test.c"
	.comm	a,4,4
	.globl	b
	.data
	.align 4
	.type	b, @object
	.size	b, 4
b:
	.long	1
	.globl	t00
	.data
	.align 4
	.type	t00, @object
	.size	t00, 4
t00:
	.long	1
	.comm	c,1,1
	.globl	d
	.type	d, @object
	.size	d, 1
d:
	.byte	0
	.globl	t01
	.type	t01, @object
	.size	t01, 1
t01:
	.byte	0
	.section	.rodata
.LC0:
	.string	"\n      ######################################################\n"
.LC1:
	.string	"      ##                                                  ##\n"
.LC2:
	.string	"      ##          Testing conditional statements          ##\n"
.LC3:
	.string	"      ##                                                  ##\n"
.LC4:
	.string	"      ######################################################\n\n"
.LC5:
	.string	"      Enter your age : "
.LC6:
	.string	"      Greater than or equal to 18\n"
.LC7:
	.string	"      Smaller than 18\n"
.LC8:
	.string	"      Testing result - OK\n"
.LC9:
	.string	"\n      ######################################################\n"
.LC10:
	.string	"      ##                                                  ##\n"
.LC11:
	.string	"      ##          Testing Arithmetic operations           ##\n"
.LC12:
	.string	"      ##                                                  ##\n"
.LC13:
	.string	"      ######################################################\n\n"
.LC14:
	.string	"      Addition (var1 and var2) : "
.LC15:
	.string	"      Subtraction (var1 and var2) : "
.LC16:
	.string	"      Multiplication (var1 and var2) : "
.LC17:
	.string	"      Division (var1 and var2) : "
.LC18:
	.string	"      Testing result - OK\n"
.LC19:
	.string	"\n"
	.text	
	movl	$1, %eax
	movl 	%eax, 0(%rbp)
	movl	0(%rbp), %eax
	movl 	%eax, 0(%rbp)
	movb	$0, 0(%rbp)
	movl	0(%rbp), %eax
	movl 	%eax, 0(%rbp)
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
	subq	$320, %rsp

	movl	$8, %eax
	movl 	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movl	$120, %eax
	movl 	%eax, -44(%rbp)
	movl	-44(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movl	$15, %eax
	movl 	%eax, -52(%rbp)
	movl	-52(%rbp), %eax
	movl 	%eax, -48(%rbp)
	movb	$0, -73(%rbp)
	movl	-73(%rbp), %eax
	movl 	%eax, -72(%rbp)
	movb	$0, -75(%rbp)
	movl	-75(%rbp), %eax
	movl 	%eax, -74(%rbp)
	movq 	$.LC0, -80(%rbp)
	movl 	-80(%rbp), %eax
	movq 	-80(%rbp), %rdi
	call	printStr
	movl	%eax, -84(%rbp)
	movq 	$.LC1, -88(%rbp)
	movl 	-88(%rbp), %eax
	movq 	-88(%rbp), %rdi
	call	printStr
	movl	%eax, -92(%rbp)
	movq 	$.LC2, -96(%rbp)
	movl 	-96(%rbp), %eax
	movq 	-96(%rbp), %rdi
	call	printStr
	movl	%eax, -100(%rbp)
	movq 	$.LC3, -104(%rbp)
	movl 	-104(%rbp), %eax
	movq 	-104(%rbp), %rdi
	call	printStr
	movl	%eax, -108(%rbp)
	movq 	$.LC4, -112(%rbp)
	movl 	-112(%rbp), %eax
	movq 	-112(%rbp), %rdi
	call	printStr
	movl	%eax, -116(%rbp)
	movq 	$.LC5, -120(%rbp)
	movl 	-120(%rbp), %eax
	movq 	-120(%rbp), %rdi
	call	printStr
	movl	%eax, -124(%rbp)
	leaq	-24(%rbp), %rax
	movq 	%rax, -128(%rbp)
	movl	-128(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	readInt
	movl	%eax, -140(%rbp)
	movl	-140(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$18, %eax
	movl 	%eax, -148(%rbp)
	movl	-24(%rbp), %eax
	cmpl	-148(%rbp), %eax
	jge .L2
	jmp .L3
	jmp .L4
.L2: 
	movq 	$.LC6, -152(%rbp)
	movl 	-152(%rbp), %eax
	movq 	-152(%rbp), %rdi
	call	printStr
	movl	%eax, -156(%rbp)
	jmp .L4
.L3: 
	movq 	$.LC7, -160(%rbp)
	movl 	-160(%rbp), %eax
	movq 	-160(%rbp), %rdi
	call	printStr
	movl	%eax, -164(%rbp)
.L4: 
	movq 	$.LC8, -168(%rbp)
	movl 	-168(%rbp), %eax
	movq 	-168(%rbp), %rdi
	call	printStr
	movl	%eax, -172(%rbp)
	movq 	$.LC9, -176(%rbp)
	movl 	-176(%rbp), %eax
	movq 	-176(%rbp), %rdi
	call	printStr
	movl	%eax, -180(%rbp)
	movq 	$.LC10, -184(%rbp)
	movl 	-184(%rbp), %eax
	movq 	-184(%rbp), %rdi
	call	printStr
	movl	%eax, -188(%rbp)
	movq 	$.LC11, -192(%rbp)
	movl 	-192(%rbp), %eax
	movq 	-192(%rbp), %rdi
	call	printStr
	movl	%eax, -196(%rbp)
	movq 	$.LC12, -200(%rbp)
	movl 	-200(%rbp), %eax
	movq 	-200(%rbp), %rdi
	call	printStr
	movl	%eax, -204(%rbp)
	movq 	$.LC13, -208(%rbp)
	movl 	-208(%rbp), %eax
	movq 	-208(%rbp), %rdi
	call	printStr
	movl	%eax, -212(%rbp)
	movl 	-40(%rbp), %eax
	movl 	-48(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -216(%rbp)
	movl	-216(%rbp), %eax
	movl 	%eax, -56(%rbp)
	movl 	-40(%rbp), %eax
	movl 	-48(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -224(%rbp)
	movl	-224(%rbp), %eax
	movl 	%eax, -60(%rbp)
	movl 	-40(%rbp), %eax
	imull 	-48(%rbp), %eax
	movl 	%eax, -232(%rbp)
	movl	-232(%rbp), %eax
	movl 	%eax, -64(%rbp)
	movl 	-40(%rbp), %eax
	cltd
	idivl 	-48(%rbp)
	movl 	%eax, -240(%rbp)
	movl	-240(%rbp), %eax
	movl 	%eax, -68(%rbp)
	movq 	$.LC14, -248(%rbp)
	movl 	-248(%rbp), %eax
	movq 	-248(%rbp), %rdi
	call	printStr
	movl	%eax, -252(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printInt
	movl	%eax, -260(%rbp)
	movq 	$.LC15, -264(%rbp)
	movl 	-264(%rbp), %eax
	movq 	-264(%rbp), %rdi
	call	printStr
	movl	%eax, -268(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printInt
	movl	%eax, -272(%rbp)
	movq 	$.LC16, -276(%rbp)
	movl 	-276(%rbp), %eax
	movq 	-276(%rbp), %rdi
	call	printStr
	movl	%eax, -280(%rbp)
	movl 	-64(%rbp), %eax
	movq 	-64(%rbp), %rdi
	call	printInt
	movl	%eax, -284(%rbp)
	movq 	$.LC17, -288(%rbp)
	movl 	-288(%rbp), %eax
	movq 	-288(%rbp), %rdi
	call	printStr
	movl	%eax, -292(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printInt
	movl	%eax, -296(%rbp)
	movq 	$.LC18, -300(%rbp)
	movl 	-300(%rbp), %eax
	movq 	-300(%rbp), %rdi
	call	printStr
	movl	%eax, -304(%rbp)
	movq 	$.LC19, -308(%rbp)
	movl 	-308(%rbp), %eax
	movq 	-308(%rbp), %rdi
	call	printStr
	movl	%eax, -312(%rbp)
	movl	$0, %eax
	movl 	%eax, -316(%rbp)
	movl	-316(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by GROUP_49"
	.section	.note.GNU-stack,"",@progbits
