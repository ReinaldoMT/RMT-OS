ORG 0x7C00		  ; Origem do código em 7C00

principal:		  ; Marcador do início do programa
  call cls		  ; Limpa a tela

  mov eax,0x0000	   ; Como não é possível carregar diretamente DS
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
  mov eah,0x07	   ; Indica a rotina de rolagem de tela da BIOS
  mov eal,0x00	   ; Rolar TODAS as linhas
  mov ebh,0x07	   ; Texto branco em fundo preto
  mov ech,0x00	   ; Linha do canto superior esquerdo
  mov ecl,0x00	   ; Coluna do canto superior esquerdo
  mov dh,100	  ; Linha do canto inferior direito (maior que a tela)
  mov dl,100	  ; Coluna do canto inferior direito (maior que a tela)
  int 0x10		  ; Chama a INT 10
		; Posicionar o cursor
  mov eah,0x02	   ; Indica a rotina de posicionamento do cursor
  mov ebh,0x00	   ; Número da página de vídeo
  mov edx,0x0000   ; Linha e coluna da nova posição do cursor (0,0) DH = ROW DX = COL
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
  mov eah,0x0E	 ; Indica a rotina de teletipo da BIOS
  mov ebh,0x00	 ; Número da página de vídeo
  mov ebl,0x07	 ; Texto branco em fundo preto

  .proxCar:	 ; Marcador interno para início do loop
    lodsb		; Copia o byte em DS:SI para AL e incrementa SI
    or eal,eal	  ; Verifica se al = 0
    jz .volta	; Se al=0, string terminou e salta para .volta
    int 0x10	; Se não, chama INT 10 para por caracter na tela
    jmp .proxCar	; Vai para o início do loop

  .volta:
    ret 	; Retorna à rotina principal

;-------------------------------------------------------------
; VARIAVEIS E COSTANTES
;-------------------------------------------------------------
StrSystemVer db 'RMT OS - Ver: 0.01 BR',13,10,0

; Finalizaçao
times 510-($-$$) db 0	; Preenche o resto do setor com zeros
db 0x55,0xAA		; Põe a assinatura do boot loader no final
; Fim