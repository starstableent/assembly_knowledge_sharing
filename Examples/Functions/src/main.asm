.data

; 13 bytes
SomeStruct struct
	a byte 0
	byte 3 dup(0)
	b dword 0
	c dword 0
	d byte 0
	
SomeStruct ends

myStruct SomeStruct { -10, { 0, 0, 0 }, 20, 30, -40 } ; Variable can't have same name as type even if casing differs since MASM isn't case sensitive

.code
extern GetSum : proc
extern ModifySomeStruct : proc

GetSumAsm proc
	; Frame prologue
	push rbp		; Save rbp
	mov rbp, rsp

	mov eax, ecx		; sum = a 
	add eax, edx		; sum += b
	add eax, r8d		; sum += c  
	add eax, r8d		; sum += c
	add al, [rsp + 48]	; sum += e
	add eax, [rsp + 56] ; sum += f

	; Frame epilogue
	mov rsp, rbp ; Restore stack ptr (Pops all local stack variables)
	pop rbp ; Restore rbp
	
	ret
GetSumAsm endp

ModifySomeStructAsm proc
	inc [rcx].SomeStruct.a
	inc [rcx].SomeStruct.b
	inc [rcx].SomeStruct.c
	inc [rcx].SomeStruct.d

	ret
ModifySomeStructAsm endp

Foo:
	mov rax, 10
	pop r8			; Pops return address from stack
	jmp r8			; Jump to return address

FooFunc proc
	mov rax, 10
	ret				; Pops return address from stack and jumps to the address
FooFunc endp

main proc
	mov r12, rsp ; Save stack ptr

	call Foo		; Call pushes rip to the stack to be used later as return address
	call FooFunc

	push 60		; f
	push 0FF32h	; e
	mov r9d, 40	; d
	mov r8d, 30	; c
	mov edx, 20 ; b
	mov ecx, 10 ; a
	
	sub rsp, 32 ; Allocate shadow space

	call GetSum
	
	mov rsp, r12 ; Restore stack ptr

	
	mov r12, rsp ; Save stack ptr

	lea rcx, myStruct
	mov [rcx].SomeStruct.c, 35

	sub rsp, 32 ; Allocate shadow space

	call ModifySomeStruct

	mov rsp, r12 ; Restore stack ptr

	ret
main endp

end
