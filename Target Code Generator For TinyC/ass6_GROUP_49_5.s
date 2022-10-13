	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"\n      ######################################################\n"
.LC1:
	.string	"      ##                                                  ##\n"
.LC2:
	.string	"      ##             Testing Recursive functios           ##\n"
.LC3:
	.string	"      ##                                                  ##\n"
.LC4:
	.string	"      ######################################################\n\n"
.LC5:
	.string	"      Enter the base     : "
.LC6:
	.string	"      Enter the exponent : "
.LC7:
	.string	"      The value of result is : "
.LC8:
	.string	"      Testing result - OK\n"
.LC9:
	.string	"\n"
	.text	
	.globl	pow
	.type	pow, @function
pow: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$80, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$0, %eax
	movl 	%eax, -28(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-28(%rbp), %eax
	je .L2
	jmp .L3
	jmp .L6
.L2: 
	movl	$1, %eax
	movl 	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl 	%eax, -24(%rbp)
	jmp .L6
.L3: 
	movl	$1, %eax
	movl 	%eax, -40(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-40(%rbp), %eax
	je .L4
	jmp .L5
	jmp .L6
.L4: 
	movl	-20(%rbp), %eax
	movl 	%eax, -24(%rbp)
	jmp .L6
.L5: 
	movl	$1, %eax
	movl 	%eax, -52(%rbp)
	movl 	-16(%rbp), %eax
	movl 	-52(%rbp), %edx
	subl 	%edx, %eax
	movl 	%eax, -56(%rbp)
	movl 	-20(%rbp), %eax
	movq 	-20(%rbp), %rdi
movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rsi
	call	pow
	movl	%eax, -60(%rbp)
	movl 	-20(%rbp), %eax
	imull 	-60(%rbp), %eax
	movl 	%eax, -64(%rbp)
	movl	-64(%rbp), %eax
	movl 	%eax, -24(%rbp)
.L6: 
	movl	-24(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	pow, .-pow
	.globl	main
	.type	main, @function
main: 
.LFB1:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$176, %rsp

	movl	$5, %eax
	movl 	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movl 	%eax, -28(%rbp)
	leaq	-36(%rbp), %rax
	movq 	%rax, -44(%rbp)
	movl	-44(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movq 	$.LC0, -52(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	printStr
	movl	%eax, -56(%rbp)
	movq 	$.LC1, -60(%rbp)
	movl 	-60(%rbp), %eax
	movq 	-60(%rbp), %rdi
	call	printStr
	movl	%eax, -64(%rbp)
	movq 	$.LC2, -68(%rbp)
	movl 	-68(%rbp), %eax
	movq 	-68(%rbp), %rdi
	call	printStr
	movl	%eax, -72(%rbp)
	movq 	$.LC3, -76(%rbp)
	movl 	-76(%rbp), %eax
	movq 	-76(%rbp), %rdi
	call	printStr
	movl	%eax, -80(%rbp)
	movq 	$.LC4, -84(%rbp)
	movl 	-84(%rbp), %eax
	movq 	-84(%rbp), %rdi
	call	printStr
	movl	%eax, -88(%rbp)
	movq 	$.LC5, -92(%rbp)
	movl 	-92(%rbp), %eax
	movq 	-92(%rbp), %rdi
	call	printStr
	movl	%eax, -96(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	readInt
	movl	%eax, -104(%rbp)
	movl	-104(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movq 	$.LC6, -112(%rbp)
	movl 	-112(%rbp), %eax
	movq 	-112(%rbp), %rdi
	call	printStr
	movl	%eax, -116(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	readInt
	movl	%eax, -120(%rbp)
	movl	-120(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movl 	-24(%rbp), %eax
	movq 	-24(%rbp), %rdi
movl 	-28(%rbp), %eax
	movq 	-28(%rbp), %rsi
	call	pow
	movl	%eax, -132(%rbp)
	movl	-132(%rbp), %eax
	movl 	%eax, -36(%rbp)
	movq 	$.LC7, -140(%rbp)
	movl 	-140(%rbp), %eax
	movq 	-140(%rbp), %rdi
	call	printStr
	movl	%eax, -144(%rbp)
	movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rdi
	call	printInt
	movl	%eax, -152(%rbp)
	movq 	$.LC8, -156(%rbp)
	movl 	-156(%rbp), %eax
	movq 	-156(%rbp), %rdi
	call	printStr
	movl	%eax, -160(%rbp)
	movq 	$.LC9, -164(%rbp)
	movl 	-164(%rbp), %eax
	movq 	-164(%rbp), %rdi
	call	printStr
	movl	%eax, -168(%rbp)
	movl	$0, %eax
	movl 	%eax, -172(%rbp)
	movl	-172(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident		"Compiled by GROUP_49"
	.section	.note.GNU-stack,"",@progbits
