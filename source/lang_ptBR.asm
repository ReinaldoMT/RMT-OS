;------------------------------------------------------------------------------
;  MODULO KERNEL - CONSTANTES EM PORTUGUES DO BRASIL
;  23-06-2005 Reinaldo Martins Thoma
;------------------------------------------------------------------------------;
StrSystemVer db ' RMT OS - Ver: 0.01 BR',13,10,' RMT Software Brasil - 2005 (http://www.rmtsoftware.com.br)',13,10,0
StrCmdNotFound db 13,10,'   Comando n',132,'o reconhecido pelo sistema, digite <help> para obter ajuda.',0

StrHelpMessage db 13,10, ' ------------------------------------------  '
	       db 13,10, ' Ajuda do RMT OS'
	       db 13,10, '   cls    -> Limpa a tela'
	       db 13,10, '   help   -> Exibe esta tela de ajuda'
	       db 13,10, '   reboot -> Reinicia o computador'
	       db 13,10, '   run    -> Executa o modo gr',160,'fico'
	       db 13,10, '   ver    -> Exibe a vers',132,'o do sistema'
	       db 13,10, ' ------------------------------------------  ',13,10,0