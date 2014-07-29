; ---------------------------------------------------------
; Programa principal
; ---------------------------------------------------------
ORG 0x7C00		  ; Origem do código em 7C00

   ; Cebecalho para compatibilidade com MS-DOS FAT12
   jmp	   inicio
   nop
   db	   'RMT OS  '	   ; 8-bytes para o nome
   dw	   512		   ; tamanho do setor em bytes
   db	   1		   ; setores por cluster
   dw	   1		   ; clusters reservados
   db	   2		   ; numero de FATs
   dw	   224		   ; entrada do diretorio principal
   dw	   2880 	   ; total de setores
   db	   0F0h 	   ; formato
   dw	   9		   ; setores por FAT
   dw	   18		   ; setores por trilha
   dw	   2		   ; lados
   dd	   0		   ; setores ocultos
   dd	   0		   ; mais setores
   db	   0		   ; Id do driver
   db	   0		   ; reservado
   db	   4		   ; assinatura de boot
   dd	   0FFFFFFFFh	   ; numero do volume serial
   db	   'NO NAME    '   ; nome do label (11 bytes)
   db	   'FAT12   '	   ; sistema de arquivo (8 bytes)

inicio:
   ; Configurar a pilha.
   cli			; Disabilitar interrupções
   mov ax, 0x9000		; Por a pilha em 9000:0000
   mov ss, ax		; Transferir o endereço para o registrador do segmento da pilha (SS)
   mov sp, 0		; Zerar ponteiro do topo da pilha
   sti			; Habilitar interrupções (SeT Interrupts bit)

   mov [bootdrv], dl	; DL indica o drive de boot
   call carregar		; Chamar a função que reseta a controladora
			; e faz a leitura de setores do disco
   jmp far 1000h:0		; Salta para o buffer com o código

; ---------------------------------------------------------
; Funções e variáveis do bootstrap
; ---------------------------------------------------------

bootdrv db 0		; A identificação do drive de boot

carregar:
   push ds		; Preserva o valor do segmento de dados na pilha

.reset:
   mov ax, 0		; Serviço que reseta o sistema de disco
   mov dl, [bootdrv]	; Drive que deve ser resetado
   int 13h		; INT 13 faz o reset
   jc .reset		; Falhou -> Tentar novamente (jc=jump on carry)

   pop ds			; Retoma o valor do segmento de dados da pilha

.leitura:
   mov ax,0x1000		; O buffer deve ficar em 1000:0000
   mov es,ax		; Transfere 1000 para ES (Extra Segment)
   mov bx, 0		; e transfere 0 de deslocamento para BX
			; O resultado é ES:BX com 1000:0000

   mov ah, 2		; Serviço 2 da INT 13 => Ler setores de disco
   mov al, 5		; Ler 5 setores (é mais do que suficiente)
   mov cx, 2		; Cilindro=0, Setor=2
   mov dh, 0		; Cabeça=0
   mov dl, [bootdrv]	; Drive=drive de boot
   int 13h		; Leia! ES:BX = dados do disco
   jc .leitura		; falhou -> Tente novamente

   retn 		; Terminada a leitura, retornar

times 512-($-$$)-2 db 0 ; Preenche com 0 até setor ter 512 bytes
   dw 0AA55h		; Põe a assinatura do setor de boot