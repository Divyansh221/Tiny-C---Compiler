	.file	"test.c"
	.globl	x
	.data
	.align 4
	.type	x, @object
	.size	x, 4
x:
	.long	0
	.globl	t00
	.data
	.align 4
	.type	t00, @object
	.size	t00, 4
t00:
	.long	0
	.section	.rodata
.LC0:
	.string	"\n      ######################################################\n"
.LC1:
	.string	"      ##                                                  ##\n"
.LC2:
	.string	"      ##             Testing loops and arrays             ##\n"
.LC3:
	.string	"      ##                                                  ##\n"
.LC4:
	.string	"      ######################################################\n\n"
.LC5:
	.string	"      Sum of all array elements is : "
.LC6:
	.string	"      Testing result - OK\n"
.LC7:
	.string	"\n      ######################################################\n"
.LC8:
	.string	"      ##                                                  ##\n"
.LC9:
	.string	"      ##             Testing function calls               ##\n"
.LC10:
	.string	"      ##                                                  ##\n"
.LC11:
	.string	"      ######################################################\n\n"
.LC12:
	.string	"      Enter 1st integer : "
.LC13:
	.string	"      Enter 2nd integer : "
.LC14:
	.string	"      Minimum of the two numbers is : "
.LC15:
	.string	"      Testing result - OK\n"
.LC16:
	.string	"\n"
	.text	
	movl	$0, %eax
	movl 	%eax, 0(%rbp)
	movl	0(%rbp), %eax
	movl 	%eax, 0(%rbp)
	.globl	minimum
	.type	minimum, @function
minimum: 
.LFB0:
	.cfi_startproc
	pushq 	%rbp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movq 	%rsp, %rbp
	.cfi_def_cfa_register 5
	subq	$44, %rsp
	movq	%rdi, -20(%rbp)
	movq	%rsi, -16(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jg .L2
	jmp .L3
	jmp .L5
.L2: 
	jmp .L4
.L3: 
	movl	-20(%rbp), %eax
	movl 	%eax, -28(%rbp)
	jmp .L5
.L4: 
	movl	-16(%rbp), %eax
	movl 	%eax, -28(%rbp)
	jmp .L5
.L5: 
	movl	-28(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	minimum, .-minimum
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
	subq	$508, %rsp

	movl	$0, %eax
	movl 	%eax, -60(%rbp)
	movl	-60(%rbp), %eax
	movl 	%eax, -56(%rbp)
	movl	$5, %eax
	movl 	%eax, -84(%rbp)
	movl	$5, %eax
	movl 	%eax, -188(%rbp)
	movl	$5, %eax
	movl 	%eax, -192(%rbp)
	movl	$5, %eax
	movl 	%eax, -196(%rbp)
	movl	-196(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movl	$0, %eax
	movl 	%eax, -204(%rbp)
	movl	-204(%rbp), %eax
	movl 	%eax, -24(%rbp)
	movl	$100, %eax
	movl 	%eax, -212(%rbp)
	movl	-212(%rbp), %eax
	movl 	%eax, -28(%rbp)
	movq 	$.LC0, -224(%rbp)
	movl 	-224(%rbp), %eax
	movq 	-224(%rbp), %rdi
	call	printStr
	movl	%eax, -228(%rbp)
	movq 	$.LC1, -232(%rbp)
	movl 	-232(%rbp), %eax
	movq 	-232(%rbp), %rdi
	call	printStr
	movl	%eax, -236(%rbp)
	movq 	$.LC2, -240(%rbp)
	movl 	-240(%rbp), %eax
	movq 	-240(%rbp), %rdi
	call	printStr
	movl	%eax, -244(%rbp)
	movq 	$.LC3, -248(%rbp)
	movl 	-248(%rbp), %eax
	movq 	-248(%rbp), %rdi
	call	printStr
	movl	%eax, -252(%rbp)
	movq 	$.LC4, -256(%rbp)
	movl 	-256(%rbp), %eax
	movq 	-256(%rbp), %rdi
	call	printStr
	movl	%eax, -260(%rbp)
.L8: 
	movl	$5, %eax
	movl 	%eax, -264(%rbp)
	movl	-24(%rbp), %eax
	cmpl	-264(%rbp), %eax
	jl .L9
	jmp .L10
.L9: 
	movl	-24(%rbp), %eax
	movl 	%eax, -268(%rbp)
	addl 	$1, -24(%rbp)
	addl 	$1, -28(%rbp)
	movl 	-24(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -272(%rbp)
	movl 	-24(%rbp), %eax
	imull 	-28(%rbp), %eax
	movl 	%eax, -276(%rbp)
	movq	-276(%rbp), %rdx
	movq	%rdx, -64(%rbp)
	jmp .L8
.L10: 
	movl 	-24(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -284(%rbp)
	movq	-64(%rbp), %rax
	movq 	%rax, -288(%rbp)
	movl 	-56(%rbp), %eax
	movl 	-288(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -292(%rbp)
	movl	-292(%rbp), %eax
	movl 	%eax, -56(%rbp)
	movl	-24(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl .L10
	jmp .L11
.L11: 
	movl	$0, %eax
	movl 	%eax, -300(%rbp)
	movl	-300(%rbp), %eax
	movl 	%eax, -24(%rbp)
.L12: 
	movl	-24(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl .L14
	jmp .L18
.L13: 
	movl	-24(%rbp), %eax
	movl 	%eax, -308(%rbp)
	addl 	$1, -24(%rbp)
	jmp .L12
.L14: 
	movl	$0, %eax
	movl 	%eax, -312(%rbp)
	movl	-312(%rbp), %eax
	movl 	%eax, -28(%rbp)
.L15: 
	movl	-28(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl .L17
	jmp .L13
.L16: 
	movl	-28(%rbp), %eax
	movl 	%eax, -320(%rbp)
	addl 	$1, -28(%rbp)
	jmp .L15
.L17: 
	movl 	-24(%rbp), %eax
	imull 	$20, %eax
	movl 	%eax, -324(%rbp)
	movl 	-28(%rbp), %eax
	imull 	$4, %eax
	movl 	%eax, -332(%rbp)
	movl 	-324(%rbp), %eax
	movl 	-332(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -328(%rbp)
	movl 	-24(%rbp), %eax
	imull 	-28(%rbp), %eax
	movl 	%eax, -336(%rbp)
	movl 	-56(%rbp), %eax
	movl 	-336(%rbp), %edx
	addl 	%edx, %eax
	movl 	%eax, -340(%rbp)
	movq	-340(%rbp), %rdx
	movq	%rdx, -324(%rbp)
	jmp .L16
	jmp .L13
.L18: 
	movq 	$.LC5, -348(%rbp)
	movl 	-348(%rbp), %eax
	movq 	-348(%rbp), %rdi
	call	printStr
	movl	%eax, -352(%rbp)
	movl 	-56(%rbp), %eax
	movq 	-56(%rbp), %rdi
	call	printInt
	movl	%eax, -360(%rbp)
	movq 	$.LC6, -364(%rbp)
	movl 	-364(%rbp), %eax
	movq 	-364(%rbp), %rdi
	call	printStr
	movl	%eax, -368(%rbp)
	movq 	$.LC7, -372(%rbp)
	movl 	-372(%rbp), %eax
	movq 	-372(%rbp), %rdi
	call	printStr
	movl	%eax, -376(%rbp)
	movq 	$.LC8, -380(%rbp)
	movl 	-380(%rbp), %eax
	movq 	-380(%rbp), %rdi
	call	printStr
	movl	%eax, -384(%rbp)
	movq 	$.LC9, -388(%rbp)
	movl 	-388(%rbp), %eax
	movq 	-388(%rbp), %rdi
	call	printStr
	movl	%eax, -392(%rbp)
	movq 	$.LC10, -396(%rbp)
	movl 	-396(%rbp), %eax
	movq 	-396(%rbp), %rdi
	call	printStr
	movl	%eax, -400(%rbp)
	movq 	$.LC11, -404(%rbp)
	movl 	-404(%rbp), %eax
	movq 	-404(%rbp), %rdi
	call	printStr
	movl	%eax, -408(%rbp)
	movl	$3, %eax
	movl 	%eax, -412(%rbp)
	movl	-412(%rbp), %eax
	movl 	%eax, -48(%rbp)
	leaq	-48(%rbp), %rax
	movq 	%rax, -420(%rbp)
	movl	-420(%rbp), %eax
	movl 	%eax, -52(%rbp)
	movq 	$.LC12, -428(%rbp)
	movl 	-428(%rbp), %eax
	movq 	-428(%rbp), %rdi
	call	printStr
	movl	%eax, -432(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	readInt
	movl	%eax, -440(%rbp)
	movl	-440(%rbp), %eax
	movl 	%eax, -32(%rbp)
	movq 	$.LC13, -448(%rbp)
	movl 	-448(%rbp), %eax
	movq 	-448(%rbp), %rdi
	call	printStr
	movl	%eax, -452(%rbp)
	movl 	-52(%rbp), %eax
	movq 	-52(%rbp), %rdi
	call	readInt
	movl	%eax, -456(%rbp)
	movl	-456(%rbp), %eax
	movl 	%eax, -36(%rbp)
	movl 	-32(%rbp), %eax
	movq 	-32(%rbp), %rdi
movl 	-36(%rbp), %eax
	movq 	-36(%rbp), %rsi
	call	minimum
	movl	%eax, -468(%rbp)
	movl	-468(%rbp), %eax
	movl 	%eax, -40(%rbp)
	movq 	$.LC14, -476(%rbp)
	movl 	-476(%rbp), %eax
	movq 	-476(%rbp), %rdi
	call	printStr
	movl	%eax, -480(%rbp)
	movl 	-40(%rbp), %eax
	movq 	-40(%rbp), %rdi
	call	printInt
	movl	%eax, -484(%rbp)
	movq 	$.LC15, -488(%rbp)
	movl 	-488(%rbp), %eax
	movq 	-488(%rbp), %rdi
	call	printStr
	movl	%eax, -492(%rbp)
	movq 	$.LC16, -496(%rbp)
	movl 	-496(%rbp), %eax
	movq 	-496(%rbp), %rdi
	call	printStr
	movl	%eax, -500(%rbp)
	movl	$0, %eax
	movl 	%eax, -504(%rbp)
	movl	-504(%rbp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident		"Compiled by GROUP_49"
	.section	.note.GNU-stack,"",@progbits
