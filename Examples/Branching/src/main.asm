.data

DIRECTION_UP equ 0
DIRECTION_RIGHT equ 1
DIRECTION_DOWN equ 2
DIRECTION_LEFT equ 3
DIRECTION_COUNT equ 4

qw_jumpTable_DIRECTION qword offset case_DIRECTION_UP, 
							 case_DIRECTION_RIGHT,
							 case_DIRECTION_DOWN,
							 case_DIRECTION_LEFT,
							 case_DIRECTION_DEFAULT,

jumpTable_DIRECTION_COUNT equ 5

.code

main proc
	; === Conditionless jump ===
	jmp Foo2

	Foo:
	jmp Foo3

	Foo2:
	jmp Foo

	Foo3:
	nop

	; === Jump with condition ===

	mov r8, 3
	cmp r8, r8 ; cmp performs a 'sub' without storing the result
	je example_je_with_sub_instead_of_cmp ; Jump if ZR == 1
	nop

	example_je_with_sub_instead_of_cmp:
	sub r8, r8 ; This has the same effect as 'cmp r8, r8' 
	je example_je_when_condition_not_met ; Jump if ZR == 1
	nop

	example_je_when_condition_not_met:
	cmp r8, 2
	je condition_met
	nop

	condition_met:
	nop

	; jump instruction |       Description         |   Signed/Unsigned comparison |		    Flags		 |
	;------------------|---------------------------|------------------------------|----------------------|
	;	    jmp		   |  always jump              |			  -               |           -			 |
	;	    jl		   |  jump if less             |			signed            |	      PL != OV		 |
	;	    jle		   |  jump if less or equal    |			signed            | PL != OV or ZR == 1  |
	;	    jg         |  jump if greater          |			signed            |	PL == OV and ZR == 0 |
	;	    jge	       |  jump if greater or equal |			signed            |	     PL == OV        |
	;	    jb		   |  jump if below            |		   unsigned           |      CY == 1         |
	;	    jbe		   |  jump if below or equal   |		   unsigned           | CY == 1 or ZR == 1   |
	;	    ja		   |  jump if above            |		   unsigned           | CY == 0 and ZR == 0  |
	;	    jae		   |  jump if above or equal   |		   unsigned           |      CY == 0         |

	; === if-statement ===
	mov eax, 2
	if_equals_1:				; If (eax == 1)
		cmp eax, 1
		jne else_if_equals_2
		nop						; Put code here
		jmp end_of_if_statement
	else_if_equals_2:			; else if (eax == 2)
		cmp eax, 2
		jne _else
		nop						; Put code here
		jmp end_of_if_statement
	_else:						; else
		nop						; Put code here
	end_of_if_statement:
	
	; === switch-statement ===
	mov rcx, DIRECTION_RIGHT			; Enum argument
	mov r11, jumpTable_DIRECTION_COUNT - 1
	cmp rcx, r11
	cmovae rcx, r11						; Set case to 'default' if jump address goes out of bounds
	lea rax, qw_jumpTable_DIRECTION		; Load jump table base address
	mov r10, [rax + rcx * 8]			; Offset in jumptable into case based on enum argument
	jmp r10								; Jump to case

	case_DIRECTION_UP::			; case(DIRECTION_UP)
		nop
		nop
		jmp end_of_switch_case	; break
	case_DIRECTION_RIGHT::		; case(DIRECTION_RIGHT)
		nop
		jmp end_of_switch_case	; break
	case_DIRECTION_DOWN::		; case(DIRECTION_DOWN)
		; fallthrough
	case_DIRECTION_LEFT::		; 
		nop
		jmp end_of_switch_case	; break
	case_DIRECTION_DEFAULT::
		nop
	end_of_switch_case:

	; === while-loop ===

	mov eax, 3
	cmp eax, 0					; Initial comparison
	while_greater_than_0:		; while (eax != 0)
		jz end_of_while_loop	; jz == je (jump if zero)
		nop						; Put code here
		dec eax					; eax--
		jmp while_greater_than_0
	end_of_while_loop:

	; === for-loop ===
	mov eax, 0
	for_0_to_3:					; for (eax = 0; eax < 3; eax++)
		cmp eax, 3
		jge end_of_for_loop;
		nop						; Put code here
		inc eax
		jmp for_0_to_3
	end_of_for_loop:

	ret
main endp

end