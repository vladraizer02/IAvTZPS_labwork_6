	SECTION .text
	GLOBAL printhex
;---------------------------------------------- ;
;subroutine for print long number in hex format ;

;parameters: ;
; rsi – long number 4096 bit max ;
; rcx - size of long number in bytes ;
;---------------------------------------------- ;
printhex:
	mov ebx, 0 ; номер байта числа
	std ; записываем строку с конца
	mov eax, 10 ; символ \n 
	lea rdi, [hexstr + hexstr.len - 1] ; адрес конца строки
	stosb ; сохраняем \n в строке
.oncemore:
	mov al, [rsi+rbx] ; читаем байт
	and eax, 0x0F ; младшая тетрада
	mov al, [hexdigits+rax] ; выбираем цифру из таблицы
	stosb ; записываем цифру в конец строки
	mov al, [rsi+rbx] ; еще раз читаем тот же байт
	and eax, 0xF0 ; старшая тетрада
	shr eax, 4 ; идет на место младшей 
	mov al, [hexdigits+rax] ; выбираем цифру из таблицы
	stosb ; записываем цифру в конец строки
	inc rbx ; к следующему байту
	cmp rbx, rcx ; число закончилось?
	jne .oncemore ; нет - еще раз
	mov rax, 1 ; да - теперь печатаем
	inc rdi ; 
	mov rsi, rdi ; копируем в rsi адрес строки
	lea rdx, [hexstr + hexstr.len]
	sub rdx, rsi ; длина строки = конец - начало
	mov rdi, 1 ; вывод в stdout
	syscall
	ret
  SECTION .data
hexdigits: db '0123456789abcdef' ; цифры
  SECTiON .bss
hexstr:
	RESB 4096/4+1 ; 4096 bits max
.len: EQU $ - hexstr
