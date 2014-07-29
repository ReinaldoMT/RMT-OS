; Este é um programa DOS => ele será carregado no endereço 0x100
; O Nasm precisa do endereço para poder calcular o valor dos ponteiros.
; Para dar um endereço base para o Nasm, use o comando ORG (de ORiGem):
ORG 0x100

   mov	 ah, 9		; Imprimir string
   mov	 dx, msg		; (DX=Ponteiro para msg)
   int	 0x21

   mov	 ax, 0x4C00	; Termina programa
   int	 0x21

   msg	 db 'Primeiro programa em assembly$'  ; Insere a mensagem - uma string terminada em "$"