; Designed for Emu8086
; Assembler and Visual Microprocessor Emulator for Windows:
;
;   http://www.emu8086.com



; This is a very basic example
; of a tiny operating system.
;
; This is Kernel module!
;
; It is assumed that this machine
; code is loaded by 'micro-os_loader.asm'
; from floppy drive from:
;   cylinder: 0
;   sector: 2
;   head: 0

; Directive to create BIN file:
#make_BIN#

; where to load (for emulator)?
#LOAD_SEGMENT=0800#
#LOAD_OFFSET=0000#

; set these values to registers on load,
; actually only DS, ES, CS, IP, SS, SP are
; important. In real world these values
; are left by "micro-os_loader":
#AL=0B#
#AH=00#
#BH=00#
#BL=00#
#CH=00#
#CL=02#
#DH=00#
#DL=00#
#DS=0800#
#ES=0800#
#SI=7C02#
#DI=0000#
#BP=0000#
#CS=0800#
#IP=0000#
#SS=07C0#
#SP=03FE#



include 'emu8086.inc'

; Kernel is loaded at 0800:0000
ORG 0000h

; skip the data section:
JMP start

;==== data section =====================

; welcome message:
msg  DB 'Welcome to micro-os!', 13, 10,
     DB 'type help if you need it', 0

cmd_size	EQU 10	  ; size of command_buffer
command_buffer	DB cmd_size DUP('x')
clean_str	DB cmd_size DUP(' '), 0
prompt		DB '>', 0

; commands:
cHELP	 DB 'help', 0
cCLS	 DB 'cls', 0
cQUIT	 DB 'quit', 0
cEXIT	 DB 'exit', 0
cREBOOT  DB 'reboot', 0

help_msg DB 'Thank you for using micro-os!', 13, 10
	 DB 'List of supported commands:', 13, 10
	 DB 'help   - print out this list.', 13, 10
	 DB 'cls    - clear the screen.', 13, 10
	 DB 'reboot - reboot the machine.', 13, 10
	 DB 'quit   - same as reboot.', 13, 10
	 DB 'exit   - same as reboot.', 13, 10
	 DB 'more to come!', 13, 10, 0

unknown  DB 'Unknown command: ' , 0

;======================================

start:

; set data segment:
PUSH	CS
POP	DS

; set default video mode 80x25:
MOV	AH, 00h
MOV	AL, 03h
INT	10h

; clear screen:
CALL	clear_screen

; print out the message:
LEA	SI, msg
CALL	print_string


eternal_loop:

CALL	GET_COMMAND

CALL	PROCESS_CMD

; make eternal loop:
JMP eternal_loop


;===========================================
GET_COMMAND PROC NEAR

; set cursor position to bottom
; of the screen:
MOV	AX, 40h
MOV	ES, AX
MOV	AL, ES:[84h]

GOTOXY	0, AL

; clear command line:
LEA	SI, clean_str
CALL	print_string

GOTOXY	0, AL

; show prompt:
LEA	SI, prompt
CALL	print_string


; wait for a command:
MOV	DX, cmd_size	; buffer size.
LEA	DI, command_buffer
CALL	get_string


RET
GET_COMMAND ENDP
;===========================================

PROCESS_CMD PROC    NEAR

;//// check commands here ///
; set ES to DS
PUSH	DS
POP	ES

CLD	; forward compare.

; compare command buffer with 'help'
LEA	SI, command_buffer
MOV	CX, 5	; size of ['help',0] string.
LEA	DI, cHELP
REPE	CMPSB
JE	help_command

; compare command buffer with 'cls'
LEA	SI, command_buffer
MOV	CX, 4	; size of ['cls',0] string.
LEA	DI, cCLS
REPE	CMPSB
JNE	not_cls
JMP	cls_command
not_cls:

; compare command buffer with 'quit'
LEA	SI, command_buffer
MOV	CX, 5	; size of ['quit',0] string.
LEA	DI, cQUIT
REPE	CMPSB
JE	reboot_command

; compare command buffer with 'exit'
LEA	SI, command_buffer
MOV	CX, 5	; size of ['exit',0] string.
LEA	DI, cEXIT
REPE	CMPSB
JE	reboot_command

; compare command buffer with 'reboot'
LEA	SI, command_buffer
MOV	CX, 7	; size of ['reboot',0] string.
LEA	DI, cREBOOT
REPE	CMPSB
JE	reboot_command

;////////////////////////////

; if gets here, then command is
; unknown...

MOV	AL, 1
CALL	SCROLL_T_AREA

; set cursor position just
; above prompt line:
MOV	AX, 40h
MOV	ES, AX
MOV	AL, ES:[84h]
DEC	AL
GOTOXY	0, AL

LEA	SI, unknown
CALL	print_string

LEA	SI, command_buffer
CALL	print_string

MOV	AL, 1
CALL	SCROLL_T_AREA

JMP	processed

; +++++ 'help' COMMAND ++++++
help_command:

; scroll text area 9 lines up:
MOV	AL, 9
CALL	SCROLL_T_AREA

; set cursor position 9 lines
; above prompt line:
MOV	AX, 40h
MOV	ES, AX
MOV	AL, ES:[84h]
SUB	AL, 9
GOTOXY	0, AL

LEA	SI, help_msg
CALL	print_string

MOV	AL, 1
CALL	SCROLL_T_AREA

JMP	processed


; +++++ 'cls' COMMAND ++++++
cls_command:

; clear screen:
CALL	clear_screen

JMP	processed


; +++ 'quit', 'exit', 'reboot' +++
reboot_command:

; store magic value at 0040h:0072h:
;   0000h - cold boot.
;   1234h - warm boot.
MOV	AX, 0040h
MOV	DS, AX
MOV	w.[0072h], 0000h ; cold boot.

JMP	0FFFFh:0000h	 ; reboot!

; ++++++++++++++++++++++++++

processed:
RET
PROCESS_CMD ENDP

;===========================================

; scroll all screen except last row
; up by value specified in AL

SCROLL_T_AREA	PROC	NEAR

MOV DX, 40h
MOV ES, DX  ; for getting screen parameters.
MOV AH, 06h ; scroll up function id.
MOV BH, 07  ; attribute for new lines.
MOV CH, 0   ; upper row.
MOV CL, 0   ; upper col.
MOV DI, 84h ; rows on screen -1,
MOV DH, ES:[DI] ; lower row (byte).
DEC DH	; don't scroll bottom line.
MOV DI, 4Ah ; columns on screen,
MOV DL, ES:[DI]
DEC DL	; lower col.
INT 10h

RET
SCROLL_T_AREA	ENDP

;===========================================

DEFINE_PRINT_STRING
DEFINE_GET_STRING
DEFINE_CLEAR_SCREEN

END
