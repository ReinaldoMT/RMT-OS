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


   MOV	 CX, BX
   ; Aponta DI para o inicio da String
   MOV	 AX, DI 	 ; ax = di
   SUB	 AX, BX 	 ; ax = ax - cx // Subtrai o numero de caracteres digitados
   MOV	 DI, AX 	 ; carrega DI c/ AX
;------------------------------------------------------------------------------
;   cls
;------------------------------------------------------------------------------
   LEA	 SI,[cmdCLS]	 ; carrega SI c/ cmdCLS
   PUSH  DI
   REPE  CMPSB		 ; Compara SI c/ DI ate que CX seja 0
   POP	 DI
   JZ	 .cmd_cls	 ; salta para .cmd_cls
;------------------------------------------------------------------------------
;   help
;------------------------------------------------------------------------------
   LEA	 SI,[cmdHELP]	 ; carrega SI
   PUSH  DI
   REPE  CMPSB		 ; Compara SI c/ DI ate que CX seja 0
   POP	 DI
   JZ	 .cmd_help
;------------------------------------------------------------------------------
;   reboot
;------------------------------------------------------------------------------
   LEA	 SI,[cmdREBOOT]  ; carrega SI
   PUSH  DI
   REPE  CMPSB		 ; Compara SI c/ DI ate que CX seja 0
   POP	 DI
   JZ	 .cmd_reboot


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

.continua:
   POP	 CX
   MOV	 BX, 00h	     ; zera o contador de caracteres
   CALL  nextline	     ; Coloca o cursor na proxima linha
;-------------------END----------------------------------------