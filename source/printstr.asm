; Este � um programa DOS => ele ser� carregado no endere�o 0x100
; O Nasm precisa do endere�o para poder calcular o valor dos ponteiros.
; Para dar um endere�o base para o Nasm, use o comando ORG (de ORiGem):
ORG 0x100

   mov	 ah, 9		; Imprimir string
   mov	 dx, msg		; (DX=Ponteiro para msg)
   int	 0x21

   mov	 ax, 0x4C00	; Termina programa
   int	 0x21

   msg	 db 'Primeiro programa em assembly$'  ; Insere a mensagem - uma string terminada em "$"