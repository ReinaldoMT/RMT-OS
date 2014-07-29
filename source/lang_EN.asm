;------------------------------------------------------------------------------
;  MODULO KERNEL - CONSTANTS IN ENGLISH
;  23-06-2005 Reinaldo Martins Thoma
;------------------------------------------------------------------------------;
StrSystemVer db ' RMT OS - Ver: 0.01 BR',13,10,' RMT Software Brasil - 2005 (http://www.rmtsoftware.com.br)',13,10,0
StrCmdNotFound db 13,10,'   Command not recognised, type <help> for informations.',0

StrHelpMessage db 13,10, ' ------------------------------------------  '
	       db 13,10, ' RMT OS Help'
	       db 13,10, '   cls    -> Clear screen'
	       db 13,10, '   help   -> Show this help screen'
	       db 13,10, '   reboot -> Reboot the system'
	       db 13,10, '   run    -> Run in graphical mode'
	       db 13,10, '   ver    -> Show the system version'
	       db 13,10, ' ------------------------------------------  ',13,10,0