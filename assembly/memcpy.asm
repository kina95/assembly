;nasm -f elf64 -o memcpy.o memcpy.asm
;ld -o memcpy memcpy.o

section .data
	str1: db "aaaaa00a", 0x00
	times 100 db 0x00
	str2: db "bbbbbbb", 0x00
	times 100 db 0x00
	count: db 4	

section .text
	global _start

_start:
	xor rax, rax
	push rdi
	push rsi
	push rdx
	lea rbx, [str1] ; indirect reference, move string index pointer to destination pointer 
	lea rax, [str2] ; indirect reference, move string index pointer to source pointer
	mov rdx, [count] ; store string length
	mov rdi, rbx
	mov rsi, rax
	
	call _memcpy
	pop rdx
	pop rsi
	pop rdi
	xor rax, rax
	mov ax, 60 ; exit
	syscall
	 
_memcpy:
	xor rax, rax
	push rcx
	mov rcx, rdx
	cld ; DF, increase destination pointer
	repne movsb ; byte unit, move source pointer to destination pointer 
	mov byte[rdi], 0 ; add a tailing zero
	mov rax, rdi
	pop rcx
	ret
