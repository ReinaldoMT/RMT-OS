  mov	ah,2	       ; servi�o 2 da interrup��o 21
  mov	dl,'X'	       ; caracter que deve ser impresso
  int	0x21	       ; chama a interrup��o e imprime na tela

  mov	ax, 0x4C00    ; AH = 0x4C,  AL=0
  int	0x21	      ; a interrup��o de software 0x21 � chamada