	MOV	AX, 1000h

; set forward direction:
	CLD

; load source into DS:SI,
; load target into ES:DI:
	MOV	AX, CS
	MOV	DS, AX
	MOV	ES, AX
	LEA	si, [str1]
	LEA	di, [str2]

; set counter to string length:
	MOV	CX, 11

; compare until equal:
	REPE	CMPSB
	JNZ	not_equal

; "Yes" - equal!
	MOV	AL, 'Y'
	MOV	AH, 0Eh
	INT	10h

	JMP	exit_here

not_equal:

; "No" - not equal!
	MOV	AL, 'N'
	MOV	AH, 0Eh
	INT	10h

exit_here:
	jmp exit_here
	;RET

; data:
str1 db 'Test string'
str2 db 'Test string'

times 512-($-$$) db 0 ; Preenche com 0 até setor ter 512 bytes
