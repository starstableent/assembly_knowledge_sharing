.data

bFoo byte 001h
wFoo word 012h
dwFoo dword 0123h
qwFoo qword 01234h

.code

main proc
	; === Assignment ===
	mov rax, 0FFFFFFFFFFFFFFFFh ; Assigns to bits 0-63
	mov ax, 0					; Assigns to bits 0-15
	mov ah, 0FFh				; Assigns to bits 8-15
	mov al, 0FFh				; Assigns to bits 0-7
	mov eax, 10					; Assigns to bits 0-31 and zero extend 32-63
	
	mov r15, 0FFFFFFFFFFFFFFFFh ; Assigns to bits 0-63
	mov r15w, 0					; Assigns to bits 0-15
	mov r15b, 0FFh				; Assigns to bits 0-7
	mov r15d, 20				; Assigns to bits 0-31 and zero extend 32-63

	mov rax, r15				; Register to register assigment. Operands must be the same
	; mov rax, r15d				; ERROR: Doesn't compile because operands are of different sizes
	mov rax, qwFoo				; Memory to register assigment
	mov qwFoo, rax				; Register to memory assigment
	movzx rax, wFoo				; Memory 16 bit to 64 bit register assignment with zero extension

	; === Addition & Subtraction ===
	mov rax, 0FFFFFFFFFFFFFF00h
	add rax, 1					; Adds to bits 0-63
	add eax, 1					; Adds to bits 0-31 and zero extends 32-63

	mov al, 255
	add al, 1					; Carry for MSB and resulting value 0 (CY == 1, ZR == 1, PL == 0)

	mov al, -1					; Since -1 == 255 in two's complement, this results in the same flags getting set
	add al, 1

	mov al, 0
	sub al, 1					; Borrow for MSB and resulting value -1 (CY == 1, ZR == 0, PL == 1)

	mov al, 127					
	add al, 1					; Signed overflow (OV == 1)
	add al, 1					; No signed overflow since value is part signed range (OV == 0)

	mov al, -128
	sub al, 1					; Signed underflow and borrow (OV == 1, CY == 1)

	; === Multiplication ===

	mov rax, 0FFFFFFFFh
	mov r8, 2
	mul r8b						; ax = al * 8-bit register|memory
	mul r8w						; dx:ax = ax * 16-bit register|memory
	mul r8d						; edx:eax = eax * 32-bit register|memory
	mul r8						; rdx:rax = rax * 64-bit register|memory

	mov rax, 0FFFFFFFFFFFFFFFFh
	mul r8

	mov rax, 0FFh				; FF == 255 unsigned
	mov r8, 2
	mul r8b

	mov rax, 0FFh				; FF == -1 signed
	mov r8, 2
	imul r8b
	  
	mov rdx, 0
	mov rax, 07FFFFFFFFFFFFFFFh
	imul r9, rax, 10				; r9 = rax * 10 (product too big to fit in r9)
	
	mov r8, 10
	imul rax, r8					; rax = rax * r8 (product too big to fit in rax)

	mov rax, 07FFFFFFFFFFFFFFFh
	imul r8							; rdx:rax = rax * r8 (product fits in rdx:rax)
	
	; === Division ===
	mov rax, 255
	; mov rax, 512				; ERROR: Integer overflow because 512 / 2 = 256, which requires 9 bits and therefore doesn't fit in al which has 8 bits
	mov r8, 2
	div r8b						; ax / (8-bit register|memory)			=> al = quotient, ah = remainer
	
	mov rdx, 0					; Need to clear rdx or it will be part of the dividened
	div r8w						; dx:ax / (16-bit register|memory)		=> ax = quotient, dx = remainer
	
	mov rdx, 0
	div r8d						; edx:eax / (32-bit register|memory)	=> eax = quotient, edx = remainer
	
	mov rdx, 0
	div r8						; rdx:rax / (16-bit register|memory)	=> rax = quotient, rdx = remainer

	; There's also 'idiv' for signed division which works pretty much the same way as 'div'

	; === Bit operations ===

	mov rax, 1
	mov cl, 2

	shl rax, 2			; rax = rax << 2
	shl rax, cl			; rax = rax << cl (only defined for register 'cl')
	shr rax, 2			; rax = rax >> 2
	shr rax, cl			; rax = rax >> cl (only defined for register 'cl')
	shl al, 8			; Triggers carry because MSB is set and shifted out
	mov rax, 1
	shr al, 1			; Triggers carry because bit LSB is set and shifted out

	mov rax, 1001b
	ror al, 4			; 0000 1001 => 1001 0000 == 144
	rol al, 2			; 1001 0000 => 0100 0010 == 66

	mov r8, 1100b
	mov r9, 1011b
	and r9, r8			; r9 = r9 & r8 = 1100b & 1011b = 1000 = 8
	
	mov r8, 1100b
	mov r9, 1011b
	andn r9, r9, r8		; r9 = r9 & !r8 = 1100 & 0100 = 0100 = 4

	mov r8, 1100b
	mov r9, 1011b 
	or r9, r8			; r9 = r9 | r8 = 1100 | 1011 = 1111 = 15

	mov r8, 1100b
	mov r9, 1011b 
	xor r9, r8			; r9 = r9 ^ r8 = 1100 ^ 1011 = 0111 = 7

	not r9b				; r9b = !r9b = 0000 0111 = 1111 1000 = 248

	; === Memory operations ===
	lea rax, bFoo		; Load address of bFoo into rax
	mov byte ptr [rax], 255		; Write into address held by rax (must specify ptr type)s
	mov dword ptr [rax], 1000	; This will work but overflow since rax points to a one byte variable

	mov r8b, byte ptr [rax]
	
	mov rbp, rsp		; Setup base pointer
	 
	mov rax, 1000FFFFh 
	
	push 123			; Push 8 bytes
	push ax				; Push 2 bytes
	push rax			; Push 8 bytes
	 
	
	mov r8, [rbp - 8]	; Read bytes 0-7 (123)
	mov r8w, [rbp - 10] ; Read bytes 8-9 (FFFF)
	mov r8, [rbp - 18]	; Read bytes 10-17 (1000FFFF)

	pop r9				; Pop 1000FFFFh
	pop r9w				; Pop FFFF
	pop r9				; Pop 123
	
	sub rsp, 100		; Allocate 100 bytes on stack
	mov rdi, rsp		; Set top of stack as destination address
	mov eax, 011h		; Value to copy
	mov ecx, 100		; Number of iterations
	cld					; Set direction to forward
	rep stosb			; Set each of the 100 stack allocated bytes to 123
	
	mov rsp, rbp		; Restore stack pointer (i.e. pop everything allocated at once)

	; === Misc ===
	mov rax, 1
	neg rax		; 1 => -1
	neg rax		; -1 => 1

	ret
main endp

end