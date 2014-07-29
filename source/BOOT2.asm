ORG 0x7C00		  ; Origem do código em 7C00

principal:		  ; Marcador do início do programa
  ; Configurar a pilha.
  cli			  ; Disabilitar interrupções
  mov ax, 0x9000	       ; Por a pilha em 9000:0000
  mov ss, ax		  ; Transferir o endereço para o registrador do segmento da pilha (SS)
  mov sp, 0		  ; Zerar ponteiro do topo da pilha
  sti			  ; Habilitar interrupções (SeT Interrupts bit)

  call cls		  ; Limpa a tela

  mov ax,0x0000 	  ; Como não é possível carregar diretamente DS
  mov ds,ax		  ; passamos o valor de ax para ds
  mov si,StrSystemVer	  ; Ponteiro para o deslocamento da string
  call write		  ; Chamar a rotina de impressão

trava:
  jmp trava		  ; Loop infinito

; Procedures

;-------------------------------------------------------------
; cls - LIMPA A TELA E COLOCA CURSOR NO INICIO
;-------------------------------------------------------------
cls:
  mov ah,0x07	  ; Indica a rotina de rolagem de tela da BIOS
  mov al,0x00	  ; Rolar TODAS as linhas
  mov bh,0x07	  ; Texto branco em fundo preto
  mov ch,0x00	  ; Linha do canto superior esquerdo
  mov cl,0x00	  ; Coluna do canto superior esquerdo
  mov dh,100	  ; Linha do canto inferior direito (maior que a tela)
  mov dl,100	  ; Coluna do canto inferior direito (maior que a tela)
  int 0x10		  ; Chama a INT 10
		; Posicionar o cursor
  mov ah,0x02	  ; Indica a rotina de posicionamento do cursor
  mov bh,0x00	  ; Número da página de vídeo
  mov dx,0x0000   ; Linha e coluna da nova posição do cursor (0,0) DH = ROW DX = COL
  int 0x10		  ; Chama a INT 10
  call volta

;-------------------------------------------------------------
; volta - Volta
;-------------------------------------------------------------
volta:
  Retn

;-------------------------------------------------------------
; write - Escreve uma string
;-------------------------------------------------------------
write:	    ; Marcador do início da sub-rotina
  mov ah,0x0E	; Indica a rotina de teletipo da BIOS
  mov bh,0x00	; Número da página de vídeo
  mov bl,0x07	; Texto branco em fundo preto

  .proxCar:	 ; Marcador interno para início do loop
    lodsb		; Copia o byte em DS:SI para AL e incrementa SI
    or al,al	; Verifica se al = 0
    jz .volta	; Se al=0, string terminou e salta para .volta
    int 0x10	; Se não, chama INT 10 para por caracter na tela
    jmp .proxCar	; Vai para o início do loop

  .volta:
    ret 	; Retorna à rotina principal

;-------------------------------------------------------------
; VARIAVEIS E COSTANTES
;-------------------------------------------------------------
StrSystemVer db 13,10,' RMT OS - Ver: 0.01 BR',13,10,' RMT Software Brasil - 2005 (http://www.rmtsoftware.com.br)',13,10,0


; Finalizaçao
times 510-($-$$) db 0	; Preenche o resto do setor com zeros
db 0x55,0xAA		; Põe a assinatura do boot loader no final
; Fim