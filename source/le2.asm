ORG 0x100

inicio:
   mov	   ah, 9	   ; Servi�o de impress�o da INT 21
   mov	   dx, msg1	   ; Imprime "Escreva alguma coisa: "
   int	   0x21

tecla:
   mov	   ah, 0x1	   ; Servi�o de rastrear uma tecla
   int	   0x21

   cmp	   al,13	   ; se for Enter
   je	   termina	   ; salte para termina e p�e caracteres na tela

   cmp	   al, 27	   ; se foe Esc
   je	   fecha	   ; termina o programa

   mov	   [dados+bx], al  ; p�e caracter da tecla no buffer
   mov	   bl, [count]	   ; p�e n�mero j� teclado em BL
   inc	   bx		   ; incrementa n�mero de caracteres
   mov	   [count], bl	   ; atualiza count

   cmp	   bl, 20	   ; compara n�mero de caracteres com 20
   je	   termina	   ; se forem 20, termina
   jmp	   tecla	   ; sen�o volta a esperar tecla

termina:
   mov	   al, '$'	   ; P�e caracter terminador '$' em AL
   mov	   bl, [count]	   ; P�e n�mero de teclas digitadas em BL
   mov	   bh, 0	   ; Zera o byte alto de BX
   mov	   [dados+bx], al   ; Adiciona '$' no final do buffer

   mov	   ah, 9	   ; Imprime "Voc� escreveu: "
   mov	   dx, msg2	   ;
   int	   0x21 	   ;

   mov	   ah, 9	   ; Imprime o conte�do do buffer
   mov	   dx, dados
   int	   0x21

   xor	   bx, bx	   ; Zera o registrador BX (o mesmo que mov bx,0)
   mov	   bl, 20	   ; M�ximo de caracteres (20)
   xor	   ax, ax	   ; Zera o registrador AX
   mov	   [count], al	   ; Zera o contador
limpa:
   mov	   [dados+bx], al   ; P�e 0 na posi��o in�cio do buffer + BL
   dec	   bl		   ; Decrementa BL
   cmp	   bl, 0	   ; Compara com 0
   ja	   limpa	   ; Se for maior que 0 continua limpando o buffer

   jmp	   inicio	   ; Se n�o, pede "Escreva alguma coisa: "

fecha:
   mov	   ax, 0x4c00	   ; Servi�o para terminar programa
   int	   0x21

; Os caracteres 13 e 10 for�am uma nova linha
msg1	db	13,10,13,10,'Escreva alguma coisa: $'
msg2	db	13,10,'Voce escreveu: $'

; Este � o buffer de entrada com espa�o para 20 bytes para caracteres
; e 1 byte para '$'
buf:
count	db	0
dados	 db	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0