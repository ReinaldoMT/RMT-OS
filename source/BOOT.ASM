;PROGRAMA EXEMPLO PARA O GRAVADOR GBootR POR: Ricardo Andrade Rossa

ORG 7C00h	      ; Lugar de ORG para a BIOS
   Jmp	 Inicio       ; Salta para o inicio do programa
   Nop

; DADOS DO DISCO

DB '        '	      ; Label do disco
DW 512		      ; Bytes por setor
DB 1		      ; Setor por Bloco
DW 1		      ; Tamanho do boot nos setores
DB 2		      ; Numero de copias da FAT
DW 224		      ; Entradas do diretorio
DW 2880 	      ; Numero de setores (16-Bit)
DB 0F0h 	      ; Descritor de midia
DW 9		      ; Setores por FAT
DW 18		      ; Setores por Cilindro
DW 2		      ; Cabecas
DD 0		      ; Setores invisiveis
DD 0		      ; Numero de setores (32-Bit)
DB 0		      ; Disco 0
DB 0		      ; Reservado
DB 029h 	      ; Assinatura de boot
DD 0		      ; Volume
DB 'EXEMPLO'	      ; Nome do volume
DB '        '	      ; Tipo do sistema de arquivo(FAT)

Inicio: 	      ; Procedimento do inicio do Boot
   Mov	 AX,0	      ; Zera o AX
   Mov	 SS,AX	      ; Zera o SS - SS := AX(0)
   Mov	 SP,7C00h     ; Local do Boot (ORG)
   Push  SS	      ; Grava o SS
   Pop	 DS	      ; Pega o DS
   Mov	 SI,mensagem  ; SI := Mensagem
   Call  Escreva      ; Escreve a mensagem
   Jmp	 $	      ; Trava

Escreva:
   LodSB	      ; Copia o byte em DS:SI para AL e incrementa SI
   Cmp	 AL,0	      ; E fim do texto? byte = 0
   Je	 Volta	      ; Se Sim, volta
   Mov	 AH,0Eh       ; Funcao 0E - Escreve texto
   Int	 10h	      ; BIOS - Tela
   Jmp	 Escreva      ; Proximo caracter

Volta:
   Retn 	      ; Volta

Cor DB 1
PosX DW 5
PosY DW 5

mensagem  DB 13,10,'================================= RMT-Software =================================',0
	  RB 510 + 7C00h -$   ; Preenche com zeros
	  DB 55h,0AAh	      ; Assinatura do Boot
