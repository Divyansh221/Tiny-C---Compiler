	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"\n      ######################################################\n"
.LC1:
	.string	"      ##                                                  ##\n"
.LC2:
	.string	"      ##          Print first n natural numbers           ##\n"
.LC3:
	.string	"      ##                   (LOOP)                         ##\n"
.LC4:
	.string	"      ##                                                  ##\n"
.LC5:
	.string	"      ######################################################\n\n"
.LC6:
	.string	"      Enter the value of n (an integer) : "
.LC7:
	.string	"      "
.LC8:
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
	subq	$180, %rsp

	movq 	$.LC0, -44(%rbp)
	movl 	-44(%rbp), %eax
	movq 	-44(%rbp), %rdi
	call	printStr
	movl	%eax, -48(%rbp)
	movq 	$.LC1, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	printStr
	movl	%eax, -56(%rbp)
	movq 	$.LC2, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printStr
	movl	%eax, -64(%rbp)
	movq 	$.LC3, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printStr
	movl	%eax, -72(%rbp)
	movq 	$.LC4, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	printStr
	movl	%eax, -80(%rbp)
	movq 	$.LC5, -84(%rbp)
	movl 	-84(%rbp), %eax
	movq 	-84(%rbp), %rdi
	call	printStr
	movl	%eax, -88(%rbp)
	movl	$1, %eax
	movl 	%eax, -92(%rbp)
	movl	-92(%rbp), %eax
	movl 	%eax, -28(%rbp)
	leaq	-28(%rbp), %rax
	movq 	%rax, -100(%rbp)
	movl	-100(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movq 	$.LC6, -108(%rbp)
	movl 	-108(%rbp), %eax
	movq 	-108(%rbp), %rdi
	call	printStr
	movl	%eax, -112(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
	call	readInt
	movl	%eax, -120(%rbp)
	movl	-120(%rbp), %eax
	movl 	%eax, -36(%rbp)
	movl	$0, %eax
	movl 	%eax, -128(%rbp)
	movl	-128(%rbp), %eax
	movl 	%eax, -24(%rbp)
.L2: 
	movl	-24(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl .L4
	jmp .L5
.L3: 
	movl	-24(%rbp), %eax
	movl 	%eax, -136(%rbp)
	addl 	$1, -24(%rbp)
	jmp .L2
.L4: 
	movq 	$.LC7, -140(%rbp)
	movl 	-140(%rbp), %eax
	movq 	-140(%rbp), %rdi
	call	printStr
	movl	%eax, -144(%rbp)
	movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rdi
	call	printInt
	movl	%eax, -152(%rbp)
	movl	$1, %eax
	movl 	%eax, -156(%rbp)
	movl 	-28(%rbp), %eax
	movl 	-156(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -160(%rbp)
	movl	-160(%rbp), %eax
	movl 	%eax, -28(%rbp)
	jmp .L3
.L5: 
	movq 	$.LC8, -168(%rbp)
	movl 	-168(%rbp), %eax
	movq 	-168(%rbp), %rdi
	call	printStr
	movl	%eax, -172(%rbp)
	movl	$0, %eax
	movl 	%eax, -176(%rbp)
	movl	-176(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident		"Compiled by GROUP_49"
	.section	.note.GNU-stack,"",@progbits
