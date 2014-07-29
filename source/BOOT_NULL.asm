
ORG 0x7C00    ; Origem do código em 7C00

principal:	; Marcador de início
jmp $		; Saltar para o início desta instrução (o loop infinito)
		; Uma outra alternativa seria jmp principal que
		; também funcionará como loop infinito

; Para terminar
times 510-($-$$) db 0	; Preenche o resto do setor com zeros
db 0x55,0xAA		; Põe a assinatura do boot loader no final