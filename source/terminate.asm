  mov	ah,2	       ; serviço 2 da interrupção 21
  mov	dl,'X'	       ; caracter que deve ser impresso
  int	0x21	       ; chama a interrupção e imprime na tela

  mov	ax, 0x4C00    ; AH = 0x4C,  AL=0
  int	0x21	      ; a interrupção de software 0x21 é chamada