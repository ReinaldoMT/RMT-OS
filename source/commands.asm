;------------------------------------------------------------------------------
;  MODULO KERNEL - FUNCOES BASICAS DO SISTEMA
;  COMANDOS /-> File COMMANDS.ASM
;  14-06-2005 Reinaldo Martins Thoma
;  Main file = Kernel.asm
;------------------------------------------------------------------------------;
; BX deve conter o numero de caracteres digitados
   PUSH  CX
   ;TODO Comparar cx com length do Comando a ser comparado se for menor CmdNotFound
   CLD			 ; Sentido de leitura da direita para a esquerda
   MOV	 AX, CS 	 ; Coloca AX no segmento de dados atual
   MOV	 DS, AX 	 ; ds = ax
   MOV	 ES, AX 	 ; es = ax

   MOV	 AL, 0
   STOSB
   INC	 BX		 ; Grava #0 no final do comando


   ; Aponta DI para o inicio da String
   MOV	 AX, DI 	 ; ax = di
   SUB	 AX, BX 	 ; ax = ax - cx // Subtrai o numero de caracteres digitados
   MOV	 DI, AX 	 ; carrega DI c/ AX
;------------------------------------------------------------------------------
;   cls
;------------------------------------------------------------------------------
   LEA	 SI,[cmdCLS]	 ; carrega SI c/ cmdCLS
   PUSH  DI
   MOV	 CX, BX 	 ; Seta o contador  CX c/ o numero de caracteres digitados
   REPE  CMPSB		 ; Compara SI c/ DI ate que CX seja 0
   POP	 DI
   JZ	 .cmd_cls	 ; salta para .cmd_cls
;------------------------------------------------------------------------------
;   help
;------------------------------------------------------------------------------
   LEA	 SI,[cmdHELP]	 ; carrega SI
   PUSH  DI
   MOV	 CX, BX 	 ; Seta o contador  CX c/ o numero de caracteres digitados
   REPE  CMPSB		 ; Compara SI c/ DI ate que CX seja 0
   POP	 DI
   JZ	 .cmd_help
;------------------------------------------------------------------------------
;   reboot
;------------------------------------------------------------------------------
   LEA	 SI,[cmdREBOOT]  ; carrega SI
   PUSH  DI
   MOV	 CX, BX 	 ; Seta o contador  CX c/ o numero de caracteres digitados
   REPE  CMPSB		 ; Compara SI c/ DI ate que CX seja 0
   POP	 DI
   JZ	 .cmd_reboot
;------------------------------------------------------------------------------
;   run -> Esperimental
;------------------------------------------------------------------------------
   LEA	 SI,[cmdRUN]	 ; carrega SI
   PUSH  DI
   MOV	 CX, BX 	 ; Seta o contador  CX c/ o numero de caracteres digitados
   REPE  CMPSB		 ; Compara SI c/ DI ate que CX seja 0
   POP	 DI
   JZ	 .cmd_run
;------------------------------------------------------------------------------
;   ver
;------------------------------------------------------------------------------
   LEA	 SI,[cmdVER]	 ; carrega SI
   PUSH  DI
   MOV	 CX, BX 	 ; Seta o contador  CX c/ o numero de caracteres digitados
   REPE  CMPSB		 ; Compara SI c/ DI ate que CX seja 0
   POP	 DI
   JZ	 .cmd_ver


.cmd_not_found:
   MOV	 SI, StrCmdNotFound
   CALL  write
   JMP	 .continua

; cls
.cmd_cls:
   CALL  cls
   JMP	 .continua

; help
.cmd_help:
   MOV	 SI, StrHelpMessage
   CALL  write
   JMP	 .continua

; reboot
.cmd_reboot:
;   0000h - cold boot.
;   1234h - warm boot.
   MOV	   AX, 0040h
   MOV	   DS, AX
   MOV	   word[0072h], 0000h ; cold boot.
   JMP	   0FFFFh:0000h     ; reboot!
   JMP	   fim

; run
.cmd_run:
   push di
   push si
   push ax
   push bx
   push cx
   push dx

   include 'video.inc'

   setVideoMode, 13h;VM_640x480x2

   MOV	   AX, 0xA000 ; Segmento de video
   MOV	   ES, AX     ; Coloca ES no segmento de video

   MOV	   CX,0
   .st:
   MOV	   DI, CX
   MOV	   [ES:DI], byte 0x3
   INC	   CX
   CMP	   CX,0xFFFF
   JNE	   .st


;    ; QUADRADO
;    mov   cx,50
;    mov   dx,50
;   .st1:
;     cmp  dx,120
;     jle  .incdx     ;<=
;     ;jmp  .print
;
;     inc  cx
;     mov  dx,50
;     cmp  cx,200
;     je   .fimteste

;     .incdx:
;     inc dx
;
;     .print:

;     push cx
;     push dx
;     setPixel, cx,dx,0x7
;     pop  dx
;     pop  cx
;     jmp  .st1
;     .fimteste:


   ; Espera apertar uma tecla
   mov	 ah, 00h	     ; Serviço 0 da INT 16 (Ler caracter) Resultado fica em AL
   int	 16h

   ; Retorna os valores originais em si, di, cx
   pop	 dx
   pop	 cx
   pop	 bx
   pop	 ax
   pop	 si
   pop	 di

   call  textMode
   call  cls
   JMP	 .continua

;ver
.cmd_ver:
   MOV	 SI, salto
   CALL  write
   MOV	 SI, StrSystemVer
   CALL  write
   JMP	 .continua

.continua:
   POP	 CX
   MOV	 BX, 00h	     ; zera o contador de caracteres
   CALL  nextline	     ; Coloca o cursor na proxima linha

;-------------------END----------------------------------------