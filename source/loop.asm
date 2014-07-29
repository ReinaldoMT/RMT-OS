ORG 0x100

   mov	   cx, 0		; Contador = 0

Marcador:			; marcador para dirigir o salto
   mov	   ah, 9		; Imprimir mensagem
   mov	   dx, msg
   int	   0x21

   inc	   cx		; Contador = Contador + 1 (inc=incrementa)


   cmp	   cx, 5	; Compara contador com 5
   jne	   Marcador	; Se contador diferente de 5, salta para Marcador

   mov	   ax, 0x4C00	; Termina o programa
   int	   0x21

msg   db  'Reinaldo',13,10,'$'	; A string contém nova linha (13,10)