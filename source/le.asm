ORG 0x100

   mov	   ah, 9	   ; Imprime "Escreva alguma coisa: "
   mov	   dx, msg1	   ;
   int	   0x21 	   ;

   mov	   ah, 0xA	   ; Coleciona as teclas digitadas
   mov	   dx, buf	   ;    armazenando-as no buffer
   int	   0x21 	   ;

   mov	   ax, 0x4C00	   ; Termina o programa
   int	   0x21 	   ;

msg1	db	'Escreva alguma coisa: $'

; Este é o buffer de entrada
buf:
max	db	20
count	db	0
dados	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0