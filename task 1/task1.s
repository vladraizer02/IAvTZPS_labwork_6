SECTION .text
GLOBAL main
EXTERN printhex
EXTERN printf

%macro first_step 0
	%assign i 0
	%rep 7
		mov rax, [A+8*(i+1)]
		mul rbx
		add [R+8*i], rax
		adc rdx, 0
		mov [R+8*(i+1)], rdx
	%assign i i+1
	%endrep
%endmacro

%macro second_step 0
	%assign i 1
	%rep 7
		mov rbx, [B+8*i]

		mov rax, [A+8*0]
		mul rbx
		add [R+8*0], rax
		adc rdx, 0
		mov rcx, rdx
		mov r8, [R+8*0]
		mov [C+8*i], r8

		%assign j 1
		%rep 3
			mov rax, [A+8*j]
			mul rbx
			mov [R+8*0], rdx
			add [R+8*j], rax
			mov r8, 0
			adc [R+8*0], r8
			add [R+8*j], rcx
			adc [R+8*0], r8

			mov rax, [A+8*(j+1)]
			mul rbx
			mov rcx, rdx
			add [R+8*(j+1)], rax
			adc rcx, 0
			mov r8, [R+8*0]
			add [R+8*(j+1)], r8
			adc rcx, 0
		%assign j j+2
		%endrep

		mov rax, [A+8*7]
		mul rbx
		mov [R+8*0], rdx
		add [R+8*7], rax
		mov r8, 0
		adc [R+8*0], r8
		add [R+8*7], rcx
		adc [R+8*0], r8

		mov r9, [R+8*0]

		%assign j 0
		%rep 7
			mov r8, [R+8*(j+1)]
			mov [R+8*j], r8
		%assign j j+1
		%endrep

		mov [R+8*7], r9

	%assign i i+1
	%endrep
%endmacro

%macro third_step 0
	%assign i 0
	%rep 8
		mov r8, [R+i*8]
		mov [C+64+i*8], r8
	%assign i i+1
	%endrep
%endmacro

main:
;;;;;;;;;;;;;;;;;;;;; шаг 1
	mov rbx, [B+8*0]

	mov rax, [A+8*0]
	mul rbx
	mov [C+8*0], rax
	mov [R+8*0], rdx

	first_step
	
	mov r8, 0
	adc [R+8*7], r8

;;;;;;;;;;;;;;;;;;;;; шаг 2

	second_step

;;;;;;;;;;;;;;;;;;;;; шаг 3

	third_step

;;;;;;;;;;;;;;;;;;;;; Вывод чисел

	mov rdi, msg1 ;arg_1
	xor rax, rax ;arg_2
	call printf wrt ..plt 

	mov rsi, A
	mov rcx, 64
	call printhex

	mov rdi, msg2 ;arg_1
	xor rax, rax ;arg_2
	call printf wrt ..plt 

	mov rsi, B
	mov rcx, 64
	call printhex

	mov rdi, msg3 ;arg_1
	xor rax, rax ;arg_2
	call printf wrt ..plt 

	mov rsi, C
	mov rcx, 128
	call printhex

	mov rax, 60 
	mov rdi, 0 
	syscall 

SECTION .data
A DQ 	0xed85d4c1f1f9b755, 0x34c9006ae24d224e, 0x9090d91b7096c87d, 0x67cca311b00e2b04, 0x73a84f9e8b8e5dc6, 0xfdf90a0d7a7cc7ce, 0x31201acbf3f0e1ac, 0xc9363a5be9cb5aaa
B DQ 	0xb1745ec6b8707900, 0x3227bb01df375499, 0x2d454bde85012415, 0x73885168590c979e, 0x8739aadb86c17863, 0x5cefe361c298c21a, 0x66f7b2cbf0c57c03, 0x7a1b1881358b5369
C DQ 	0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000
R DQ 	0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000

SECTION .rodata
msg1: db "A:", 0x0a, 0 
msg2: db "B:", 0x0a, 0 
msg3: db "C:", 0x0a, 0 
