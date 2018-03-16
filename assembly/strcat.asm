; nasm -f elf64 -o strcat.o strcat.asm
; ld -o strcat strcat.o

section .data
	str1 db "aaaaaa", 0x00
	times 100 db 0x00
	str2 db "bbbb", 0x00
	times 100 db 0x00
	str3 db "cccc", 0x00 

section .text
	global _start

_start:
	xor rax, rax
	push rdi
	push rsi
	lea rdi, [str1] ; move string index pointer to destination pointer
	lea rsi, [str3] ; move string index pointer to source pointer
	mov rbx, rdi ; store string index pointer to register 
	mov rdx, rsi 
	call _strlen ; length string in destination pointer

	mov rdi, rdx 
	call _strlen ; length string in source pointer
	add rbx, rcx
	mov rdi, rbx ; destination pointer + rcx
	call _strcat
	pop rsi
	pop rdi
	xor rax, rax
	mov rax, 60 ; exit
	syscall

_strlen:
	xor rax, rax
	mov rcx, 0xffffffffffffffff
	repne scasb ; (repne) if zf=0 and ecx > 0, compare until ecx 0 / (scasb) compare al(byte) and edi
	not rcx
	mov rax, rcx
	ret

_strcat:
	xor rax, rax
	cld ; DF, increase destination pointer
	rep movsb ; byte unit, move source pointer to destination pointer
	mov byte[rdi], 0 ; add a tailing zero
	mov rax, rdi
	ret

