;------------------------------------------------------------------------------
;  MODULO KERNEL - FUNCOES BASICAS DO SISTEMA
;  14-05-2005 Reinaldo Martins Thoma
;------------------------------------------------------------------------------
   mov	 ax, 1000h	     ; Põe endereço em AX
   mov	 ds, ax 	     ; Atualiza o segmento de dados
   mov	 es, ax 	     ; Atualiza o segmento extra

   ;Escreve a versao versao do sistema e o prompt
   mov	 si, StrSystemVer    ; Aponta SI para a string da mensagem
   call  write		     ; Chama a função para imprimir a mensage
   call  nextline	     ; Pula para a proxima linha e adiciona o prompt #>
   xor	 bx, bx 	     ; Zera BX

;------------------------------------------------------------------------------
;  Loop do Sistema
;------------------------------------------------------------------------------
SystemLoop:			; Apenas pendura
   mov	 ah, 00h	     ; Serviço 0 da INT 16 (Ler caracter) Resultado fica em AL
   int	 16h

   cmp	 al, 13d	     ; Verifica se o caracter em ah = 13 (Enter)
   je	 .exec		     ; se for executa
   jne	 .verify_char	     ; else adiciona caracter no buffer cmd
   jmp	 .end1		     ; manda para o final

.exec:
   ; Compara o buffer com os comandos do sistema
   include 'commands.asm'

   jmp	 .end1		     ; salta para end1
;-------------------------------------------------
.verify_char:
   ; Verifica Backspace
   cmp	 al, 08d	    ; Verifica se o caracter em al = 8 (Backspace)
   jne	 .armazena	    ; if(al!=08) goto armazena
   ; if(al==08)
   cmp	 bx, 00h	    ; Verifica se o contador e zero
   je	 .end1		    ; Se for salta para o final
   call  backspace	    ; Apaga o caracter da tela e retorna o carro
   dec	 di		    ; Remove da String
   dec	 bx		    ; Diminui o contador
   jmp	 .end1		    ; Salta para end1
;-------------------------------------------------
.armazena:
   ; Imprime o caracter digitado
   push  bx
   mov	 ah, 0Eh	     ; Serviço 0E da INT 10 da BIOS (Imprimir caracter)
   mov	 bx, 0007h	     ; Imprime branco em fundo preto
   int	 10h		       ; Imprime caracter
   pop	 bx
   inc	 bx		     ; Incrementa o contador de caracteres
   cld
   cmp	 bx, 0Fh
   jg	 .end1		     ; if(bx>16)end1
   stosb		     ; grava em di caracter que esta em AL
;-------------------------------------------------
.end1:
   jmp	SystemLoop

;------------------------------------------------------------------------------
; -> Procedures ***************************************************************
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; backspace - Retorna o cursor e apaga ultimo caracter
;------------------------------------------------------------------------------
backspace:
   push  ax
   mov	 ax, 0E08h	    ; Serviço 0E da INT 10 da BIOS (Imprimir caracter) + Caracter 08
   int	 10h		    ; Imprime caracter <- Backspace
   mov	 ax, 0A00h	    ; Serviço 0A da INT 10 da BIOS (Imprimir caracter sem alterar posicao do cursor) + Caracter 00
   int	 10h		    ; Imprime caracter nulo (apaga caracter)
   pop	 ax
   ret
;------------------------------------------------------------------------------
; nextline - MOVE O CURSOR PARA A PROXIMA LINHA e adiciona o prompt
;------------------------------------------------------------------------------
nextline:
   push  ax
   push  bx
   mov	 ah, 0Eh	   ; Serviço 0E da INT 10 da BIOS (Imprimir caracter)
   mov	 bx, 0007h	   ; Imprime branco em fundo preto
   ; CR
   mov	 al, 13d	   ; Coloca o Caracter 13 <Return>
   int	 10h		   ; Imprime caracter
   ; LF
   mov	 al, 10d	   ; Coloca o Caracter 10
   int	 10h		   ; Imprime caracter
   ; ' '
   mov	 al, 255d	   ; Coloca o Caracter 255 = ' '
   int	 10h		   ; Imprime caracter
   ; #
   mov	 al, 35d	   ; Coloca o Caracter 35 = #
   int	 10h		   ; Imprime caracter
   ; >
   mov	 al, 62d	   ; Coloca o Caracter 62 = >
   int	 10h		   ; Imprime caracter
   pop	 bx
   pop	 ax

   ret

;------------------------------------------------------------------------------
; cls - LIMPA A TELA E COLOCA CURSOR NO INICIO
;------------------------------------------------------------------------------
cls:
   push  ax
   push  bx
   ;push   cx
   push  dx
   mov	 ah, 07h	     ; Indica a rotina de rolagem de tela da BIOS
   mov	 al, 00h	     ; Rolar TODAS as linhas
   mov	 bh, 07h	     ; Texto branco em fundo preto
   mov	 ch, 00h	     ; Linha do canto superior esquerdo
   mov	 cl, 00h	     ; Coluna do canto superior esquerdo
   mov	 dh, 100d	     ; Linha do canto inferior direito (maior que a tela)
   mov	 dl, 100d	     ; Coluna do canto inferior direito (maior que a tela)
   int	 10h			  ; Chama a INT 10
			     ; Posicionar o cursor
   mov	 ah, 02h	     ; Indica a rotina de posicionamento do cursor
   mov	 bh, 00h	     ; Número da página de vídeo
   mov	 dx, 0000h	     ; Linha e coluna da nova posição do cursor (0,0) DH = ROW DX = COL
   int	 10h		     ; Chama a INT 10
   pop	 dx
   ;pop   cx
   pop	 bx
   pop	 ax

   ret

;------------------------------------------------------------------------------
; textMode - Muda para o modo texto
;------------------------------------------------------------------------------
textMode:
   ; Coloca o segmento de dados em 1000h
   MOV	 AX, 1000h	     ; Põe endereço em AX
   MOV	 DS, AX 	     ; Atualiza o segmento de dados
   MOV	 ES, AX 	     ; Atualiza o segmento extra
   XOR	 BX, BX 	     ; BX = 0
   ; Volta para modo texto
   MOV	 AX, 0x0003
   INT	 0x10
   ret
;------------------------------------------------------------------------------
; write - Escreve uma string terminada em 0
; (SI=ponteiro para a string)
;------------------------------------------------------------------------------
write:
   push  si
.start:
   lodsb		     ; Copia o byte em DS:SI para AL e incrementa SI
   or	 al,al		     ; Verifica se o byte lido é zero
   jz	 .exit		     ; Se sim, salta para exit

   mov	 ah, 00Eh	     ; Serviço 0E da INT 10 da BIOS (Imprimir caracter)
   mov	 bx, 0007h	     ; Imprime branco em fundo preto
   int	 10h		     ; Imprime caracter

   jmp	 .start 	     ; Pegar próximo caracter
.exit:
   pop	 si
   ret

;------------------------------------------------------------------------------
; volta - Volta
;------------------------------------------------------------------------------
volta:
   ret			     ; Terminada a tarefa, voltar ao ponto de chamada

fim:

;------------------------------------------------------------------------------
; -> VARIAVEIS E COSTANTES ****************************************************
;------------------------------------------------------------------------------
include   'lang.asm'

salto	  db 13d,10d,0
cmd	  db '';
; Comandos
cmdCLS	  db 'cls',0
cmdHELP   db 'help',0
cmdREBOOT db 'reboot',0
cmdRUN	  db 'run',0
cmdVER	  db 'ver',0

lowercase=0100000b

;times 2048-($-$$) db 0 ; Preenche com 0 até setor ter 2048 bytes

; fill rest of binary image to 1.44MB, to make disk image.

times 512 - ($ - $$) db 0