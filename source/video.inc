;------------------------------------------------------------------------------
;  MODULO VIDEO
;  18-06-2005 Reinaldo Martins Thoma
;------------------------------------------------------------------------------

; Colours   640x480 800x600 1024x768 1280x1024 1600x1200
; --------+--------+-------+--------+---------+---------
;    256  | 0101   | 0103  | 0105   | 0107    | 011C
; 32,768  | 0110   | 0113  | 0116   | 0119    | 011D
; 65,536  | 0111   | 0114  | 0117   | 011A    | 011E
; 16.8M   | 0112   | 0115  | 0118   | 011B    | 011F


; Video Modes AL
  VM_320x200	  = 0x013 ;        256 colors
  VM_640x480x1	  = 0x011 ;            B/W
  VM_640x480x2	  = 0x012 ;         16 colors
  ; SVGA
  VM_640x480x8	  = 0x101 ;        256 colors
  VM_640x480x16   = 0x111 ;     65.536 colors - 16 bits
  VM_640x480x24   = 0x112 ; 16.777.216 colors - 24 bits

  VM_800x600x2	  = 0x102 ; 16
  VM_800x600x8	  = 0x103 ; 256
  VM_800x600x16   = 0x114 ; 65K
  VM_800x600x24   = 0x115 ; 16M

  VM_1024x768x2   = 0x104 ; 16
  VM_1024x768x8   = 0x105 ; 256
  VM_1024x768x16  = 0x117 ; 65K
  VM_1024x768x24  = 0x118 ; 16M

  VM_1280x1024x2  = 0x106 ; 16
  VM_1280x1024x8  = 0x107 ; 256
  VM_1280x1024x16 = 0x11A ; 65K
  VM_1280x1024x24 = 0x11B ; 16M

macro setVideoMode proc, vmode
{
  MOV	  AX, 0x4F02
  MOV	  BX, vmode
  INT	  0x10

  CMP	  AL, 0x01
  JE	  .error
  jmp	  .fim
  .error:
    ; Volta para modo texto
    MOV     AX, 0x4F02
    MOV     BX, 0x0013
    INT     0x10
  .fim:
}

macro setPixel proc,x,y,color
{
  MOV	  AX, 0xA000 ; Segmento de video
  MOV	  ES, AX     ; Coloca ES no segmento de video
  MOV	  BX, y      ; bx = y

  ;320x200
  MOV	  DI, BX     ; DI = y
  SHL	  BX, 8      ;
  SHL	  DI, 6
  ADD	  DI, BX

  ;640x480
  ;MOV     DI, BX     ; DI = y
  ;SHL     BX, 9      ; 512 +
  ;SHL     DI, 7      ; 128 =
  ;ADD     DI, BX     ; 640

  ;800x600
  ;MOV     DI, BX     ; DI = y
  ;MOV     DX, BX
  ;SHL     BX, 9      ; 512 +
  ;SHL     DI, 8      ; 256 +
  ;SHL     DX, 5      ;  32
  ;ADD     DI, BX     ; 800
  ;ADD     DI, CX

  ;1024x768
  ;SHL     BX, 10     ; BX = BX*1024
  ;MOV     DI, BX     ;

  MOV	  DX, x
  ADD	  DI, DX
  MOV	  AL, color
  MOV	  [ES:DI], AL
}