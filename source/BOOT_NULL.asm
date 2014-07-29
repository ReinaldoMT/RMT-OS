
ORG 0x7C00    ; Origem do c�digo em 7C00

principal:	; Marcador de in�cio
jmp $		; Saltar para o in�cio desta instru��o (o loop infinito)
		; Uma outra alternativa seria jmp principal que
		; tamb�m funcionar� como loop infinito

; Para terminar
times 510-($-$$) db 0	; Preenche o resto do setor com zeros
db 0x55,0xAA		; P�e a assinatura do boot loader no final