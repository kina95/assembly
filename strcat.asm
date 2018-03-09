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
	lea rdi, [str1]
	lea rsi, [str3]
	mov rbx, rdi
	mov rdx, rsi
	call _strlen

	mov rdi, rdx
	call _strlen
	add rbx, rcx
	mov rdi, rbx
	call _strcat
	pop rsi
	pop rdi
	xor rax, rax
	mov rax, 60
	syscall

_strlen:
	xor rax, rax
	mov rcx, 0xffffffffffffffff
	repne scasb ; repeat until no equal, compare al and di, if equal zf=1
	not rcx
	mov rax, rcx
	ret

_strcat:
	xor rax, rax
	cld
	rep movsb
	mov byte[rdi], 0
	mov rax, rdi
	ret

