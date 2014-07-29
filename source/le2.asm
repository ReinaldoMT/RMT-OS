ORG 0x100

inicio:
   mov	   ah, 9	   ; Serviço de impressão da INT 21
   mov	   dx, msg1	   ; Imprime "Escreva alguma coisa: "
   int	   0x21

tecla:
   mov	   ah, 0x1	   ; Serviço de rastrear uma tecla
   int	   0x21

   cmp	   al,13	   ; se for Enter
   je	   termina	   ; salte para termina e põe caracteres na tela

   cmp	   al, 27	   ; se foe Esc
   je	   fecha	   ; termina o programa

   mov	   [dados+bx], al  ; põe caracter da tecla no buffer
   mov	   bl, [count]	   ; põe número já teclado em BL
   inc	   bx		   ; incrementa número de caracteres
   mov	   [count], bl	   ; atualiza count

   cmp	   bl, 20	   ; compara número de caracteres com 20
   je	   termina	   ; se forem 20, termina
   jmp	   tecla	   ; senão volta a esperar tecla

termina:
   mov	   al, '$'	   ; Põe caracter terminador '$' em AL
   mov	   bl, [count]	   ; Põe número de teclas digitadas em BL
   mov	   bh, 0	   ; Zera o byte alto de BX
   mov	   [dados+bx], al   ; Adiciona '$' no final do buffer

   mov	   ah, 9	   ; Imprime "Você escreveu: "
   mov	   dx, msg2	   ;
   int	   0x21 	   ;

   mov	   ah, 9	   ; Imprime o conteúdo do buffer
   mov	   dx, dados
   int	   0x21

   xor	   bx, bx	   ; Zera o registrador BX (o mesmo que mov bx,0)
   mov	   bl, 20	   ; Máximo de caracteres (20)
   xor	   ax, ax	   ; Zera o registrador AX
   mov	   [count], al	   ; Zera o contador
limpa:
   mov	   [dados+bx], al   ; Põe 0 na posição início do buffer + BL
   dec	   bl		   ; Decrementa BL
   cmp	   bl, 0	   ; Compara com 0
   ja	   limpa	   ; Se for maior que 0 continua limpando o buffer

   jmp	   inicio	   ; Se não, pede "Escreva alguma coisa: "

fecha:
   mov	   ax, 0x4c00	   ; Serviço para terminar programa
   int	   0x21

; Os caracteres 13 e 10 forçam uma nova linha
msg1	db	13,10,13,10,'Escreva alguma coisa: $'
msg2	db	13,10,'Voce escreveu: $'

; Este é o buffer de entrada com espaço para 20 bytes para caracteres
; e 1 byte para '$'
buf:
count	db	0
dados	 db	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0