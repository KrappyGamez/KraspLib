; Krasplib 0.16 CORE
; (C) KrappyGamez 2025 bajo licencia MIT

_CALL_ADDR_ADJUST equ 996 - 10
_BUFFER_ADDR_ADJUST equ  984 + _CALL_ADDR_ADJUST - 8



org 0xb000 + _CALL_ADDR_ADJUST





 ; Definiciones ASM




 _DIR_BUFFERS equ 0xa000 + _BUFFER_ADDR_ADJUST; de momento...  tamaño 3112, restan 984


  _RASTER_POINTERS_1 equ _DIR_BUFFERS ; + 176
  _ATTRIB_POINTERS_1 equ _RASTER_POINTERS_1 + 176
  _RASTER_POINTERS_2 equ _ATTRIB_POINTERS_1 + 48; 4 ultimos no se usan
  _ATTRIB_POINTERS_2 equ _RASTER_POINTERS_2 + 176

  _RASTER_BUFFER_1 equ _ATTRIB_POINTERS_2 + 48; 4 ultimos no se usan
  _RASTER_BUFFER_2 equ _RASTER_BUFFER_1 + 648
  _ATTRIB_BUFFER_1 equ _RASTER_BUFFER_2 + 648
  _ATTRIB_BUFFER_2 equ _ATTRIB_BUFFER_1 + 128

  _SPR_LIST equ _ATTRIB_BUFFER_2 + 128 ; 4 * 8 bytes
  _DOT_LIST equ _SPR_LIST + 32 ; 3 * 8 bytes



  _DIR_MAP_DECODE_BUFFER equ _DOT_LIST + 32 ; + 24 ; 704  ; desde 0xb808
  _DIR_ADDITIONAL_BUFFER equ _DIR_MAP_DECODE_BUFFER + 704 ; 352
  

  _MEMORY_VIDEO_RASTER equ 0x4000
  _MEMORY_VIDEO_RASTER_HI equ 0x40
  _MEMORY_VIDEO_ATTRIBS equ 0x5800



  _DIR_LINE_TABLE equ 0xbf00
  _DIR_LINE_TABLE_HI equ 0xbf

  




  _GLOBAL_VARS equ 0xbfb0;0xad00




  ; Vars.. algunas se solapan
  
  _INPUT_DECODEPASS equ _GLOBAL_VARS + 43
  _INPUT_PRINT_TILE_X equ _GLOBAL_VARS + 43
  _INPUT_PRINT_TILE_Y equ _GLOBAL_VARS + 44
  _INPUT_TILENUM equ _GLOBAL_VARS + 45



  DECODE_CLOSING_INDEX equ _GLOBAL_VARS + 43; es una word
  DECODE_BWRYC equ _GLOBAL_VARS + 45
  DECODE_BWRXC equ _GLOBAL_VARS + 46
  DECODIFICAR_PASADA equ _GLOBAL_VARS + 47
  DECODE_ATTRIB_CUSTOMFLAG equ _GLOBAL_VARS + 48
  DECODE_TILE equ _GLOBAL_VARS + 49
  DECODE_ATTRIB equ _GLOBAL_VARS + 50
  DECODE_DATA equ _GLOBAL_VARS + 51


  DECODE_X1 equ _GLOBAL_VARS + 52
  DECODE_Y1 equ _GLOBAL_VARS + 53
  DECODE_X2 equ _GLOBAL_VARS + 54
  DECODE_Y2 equ _GLOBAL_VARS + 55

  DECODE_WRAPX equ _GLOBAL_VARS + 56
  DECODE_WRAPY equ _GLOBAL_VARS + 57
  DECODE_BTILE equ _GLOBAL_VARS + 58
  DECODE_BATTRIB equ _GLOBAL_VARS + 59

  DECODE_STAIRMODE equ _GLOBAL_VARS + 60
  DECODE_STAIR_PIVOTX_1 equ _GLOBAL_VARS + 61
  DECODE_STAIR_PIVOTX_2 equ _GLOBAL_VARS + 62
  DECODE_STAIR_PIVOT_ADD equ _GLOBAL_VARS + 63

  DECODE_STAIR_SMALLADJUST equ _GLOBAL_VARS + 64


  _GV_MAP_CURRENT_PAGE equ _GLOBAL_VARS
  _GV_CURRENT_RASTER_BUFFER_FLAG equ _GLOBAL_VARS + 1

  _GV_CURRENT_RASTER_BUFFER equ _GLOBAL_VARS + 2 ; word
  _GV_CURRENT_RASTER_POINTERS equ _GLOBAL_VARS + 4 ; word
  _GV_BACK_RASTER_POINTERS equ _GLOBAL_VARS + 6 ; word

  _GV_CURRENT_ATTR_BUFFER equ _GLOBAL_VARS + 8 ; word
  _GV_CURRENT_ATTR_POINTERS equ _GLOBAL_VARS + 10 ; word
  _GV_BACK_ATTR_POINTERS equ _GLOBAL_VARS + 12 ; word



  _PF_RASTER_BUFFER_TOP equ _GLOBAL_VARS +14; word         ; ojo.. igual interesa pasarlos fuera de solapes..
  _PF_ATTRIB_BUFFER_TOP equ _GLOBAL_VARS +16 ; word
  _PF_STR_BK_ATTR_POINTERS equ _GLOBAL_VARS +18 ; word
  _PF_STR_ATTR_LINE equ _GLOBAL_VARS +20 ; word
  _PF_STR_CR_ATTR_POINTERS equ _GLOBAL_VARS +22 ; word
  _PF_STR_ATTRBUFF equ _GLOBAL_VARS +24  ; word
  _PF_STR_ATTRBUFF_FLAGODD equ _GLOBAL_VARS +26 ; byte
  _PF_STR_PANNING equ _GLOBAL_VARS +27 ; word

  _GV_SPR_ADDR_POINTER equ _GLOBAL_VARS + 29 ; word
  _GV_MAP_ADDR_POINTER equ _GLOBAL_VARS + 31 ; word
  _GV_TILESET_ADDR_POINTER equ _GLOBAL_VARS + 33 ; word
  _GV_TILESET_ATTR_ADDR_POINTER equ _GLOBAL_VARS + 35 ; word




  _GV_COLLISION_RESULT equ _GLOBAL_VARS + 37; byte
  _GV_COLLISION_INPUT equ _GLOBAL_VARS + 38 ; byte
  _GV_COLLISION_SPRX equ _GLOBAL_VARS + 39 ; byte
  _GV_COLLISION_SPRY equ _GLOBAL_VARS + 40 ; byte



  _PF_STR_ATTRBUFF_2 equ _GLOBAL_VARS + 41 ; word

  


  _SYNC_WAIT equ _GLOBAL_VARS + 65; byte




_TEST_KEY_AUXB equ _GLOBAL_VARS + 66
_ESTADO_TECLAS equ _GLOBAL_VARS + 67
_ESTADO_JOYSTICK equ _GLOBAL_VARS + 68
_ESTADO_TECLAS_PRE equ _GLOBAL_VARS + 69
_ESTADO_JOYSTICK_PRE equ _GLOBAL_VARS + 70
_ESTADO_TECLAS_PRE_2 equ _GLOBAL_VARS + 71
_ESTADO_JOYSTICK_PRE_2 equ _GLOBAL_VARS + 72


_FLAG_USO_TECLAS equ _GLOBAL_VARS + 73

_ESTADO_TECLAS_STICKY equ _GLOBAL_VARS + 74
_ESTADO_JOYSTICK_STICKY equ _GLOBAL_VARS + 75

_ESTADO_TECLAS_STICKY_K equ _GLOBAL_VARS + 76
_ESTADO_JOYSTICK_STICKY_K equ _GLOBAL_VARS + 77

_ESTADO_CONTROL equ _GLOBAL_VARS + 78
_ESTADO_CONTROL_STICKY equ _GLOBAL_VARS + 79





  ; INICIO





  ld b,10
  ld hl, _GLOBAL_VARS
  call _clearMem8


  ld a,0xff
  ;xor a
  ld [_GV_CURRENT_RASTER_BUFFER_FLAG],a
  call _flipBuffers
  call _flipBuffers

  ld b, 8
  ld hl, _SPR_LIST ; bueno.. supongo que se podrá optimizar la limpieza
  call _clearMem8
  
  ret









; b -> tono ... sin especificar, la verdad
; c -> duracion ... sin especificar
;-------------------------------------------------------------------------------

_soundfx:

  push de
  push af

  ld e,b

  ld d,0

  bson1:


  ld b,e

  bson2:

  djnz bson2

  ld a,d

  out (254),a
  xor 16

  ld d,a

  dec c
  ld a,c
  cp 0
  jr nz, bson1

  pop af
  pop de

ret





_soundfx_6:

  ld c,4 + 2
  ld b,50
  call _soundfx


  ld c,2 + 2
  ld b,250
  call _soundfx
ret



_soundfx_7:

  ld c,4
  ld b,65
  call _soundfx

ret




_stdsound: ; 0xb049

  cp 0
  jr z, _soundfx_1
  cp 1
  jr z, _soundfx_2
  cp 2
  jr z, _soundfx_3
  cp 3
  jr z, _soundfx_4
  cp 4
  jr z, _soundfx_5
  cp 5
  jr z, _soundfx_6
  cp 6
  jr z, _soundfx_7
  ;cp 7
  ;jr z, _soundfx_8

  ; soundfx_8
    ld c,3
  ld b,110
  call _soundfx

  ret



_soundfx_1:

  ld bc, 0x14e0
  _soundfx_1_loop:
  push bc
  ld a,c
  ld d,a

  ld a,c
  neg

  ld b,a
  ld c,2
  call _soundfx

  ld a,d

  add a,0x10

  ld b,a
  ld c,1
  call _soundfx

  pop bc

  ld a,c
  ld c,6
  sub c
  ld c,a

  djnz _soundfx_1_loop

ret



_soundfx_2:
  ld c,70 + 70
  ld b,25
  call _soundfx
  ld c,70 + 70
  ld b,50
  call _soundfx
ret



_soundfx_3:
  ld b,192
  ld c,48
  call _soundfx

  ld b,128
  ld c,96
  call _soundfx
ret



_soundfx_4:

  ld bc, 0x18e0
  _soundfx_4_loop:
  push bc
  ld a,c
  ld d,a
  ;ld [KRASP_SOUND_AUXB],a

  ld a,c
  neg

  ld b,a
  ld c,10
  call _soundfx

  ;ld a,[KRASP_SOUND_AUXB]
  ld a,d
  add a,0x10

  ld b,a
  ld c,4
  call _soundfx

  pop bc

  ld a,c
  ld c,8
  sub c
  ld c,a

  djnz _soundfx_4_loop

ret



_soundfx_5:
  ld bc, 0x08e0
  _soundfx_5_loop:
  push bc

  ld b,c
  ld c,3
  call _soundfx

  pop bc

  ld a,c
  ld c,0x18 + 3
  sub c
  add a,b
  ld c,a

  djnz _soundfx_5_loop
ret



















  _flipBuffers: ; 0xb0e2

    ld a,[_GV_CURRENT_RASTER_BUFFER_FLAG]
    xor 0xff
    ld [_GV_CURRENT_RASTER_BUFFER_FLAG],a

    jr z, _flipBuffersA


    ld hl,_RASTER_POINTERS_1
    ld [_GV_BACK_RASTER_POINTERS],hl
    ld hl,_ATTRIB_POINTERS_1
    ld [_GV_BACK_ATTR_POINTERS],hl

    ld hl,_RASTER_BUFFER_2
    ld [_GV_CURRENT_RASTER_BUFFER],hl
    ld [_PF_RASTER_BUFFER_TOP],hl
    ld hl, _ATTRIB_BUFFER_2
    ld [_PF_ATTRIB_BUFFER_TOP], hl
    ld [_GV_CURRENT_ATTR_BUFFER],hl

    ld hl,_ATTRIB_POINTERS_2
    ld [_GV_CURRENT_ATTR_POINTERS],hl

    ld hl,_RASTER_POINTERS_2
    ld [_GV_CURRENT_RASTER_POINTERS],hl




    jr _flipBuffersF
    _flipBuffersA:


    ld hl,_RASTER_POINTERS_2
    ld [_GV_BACK_RASTER_POINTERS],hl
    ld hl,_ATTRIB_POINTERS_2
    ld [_GV_BACK_ATTR_POINTERS],hl

    ld hl,_RASTER_BUFFER_1
    ld [_GV_CURRENT_RASTER_BUFFER],hl
    ld [_PF_RASTER_BUFFER_TOP],hl
    ld hl, _ATTRIB_BUFFER_1
    ld [_PF_ATTRIB_BUFFER_TOP], hl
    ld [_GV_CURRENT_ATTR_BUFFER],hl

    ld hl,_ATTRIB_POINTERS_1
    ld [_GV_CURRENT_ATTR_POINTERS],hl

    ld hl,_RASTER_POINTERS_1
    ld [_GV_CURRENT_RASTER_POINTERS],hl


    _flipBuffersF:

    ld b,28
    call _clearMem8_B

  ret





  _clearMem8:  ; 0xb148
    xor a
  _setMem8:    ; 0xb149
    _cmem8_loop:
    ld [hl],a
    inc hl
    ld [hl],a
    inc hl
    ld [hl],a
    inc hl
    ld [hl],a
    inc hl
    ld [hl],a
    inc hl
    ld [hl],a
    inc hl
    ld [hl],a
    inc hl
    ld [hl],a
    inc hl
    djnz _cmem8_loop
  ret





  _clearMem8_B:  ; 0xb15c
    xor a
    ;ld a,0xff
    _cmem8B_loop:
    ;inc hl
    ld [hl],a
    inc hl
    inc hl
    ld [hl],a
    inc hl
    inc hl
    ld [hl],a
    inc hl
    inc hl
    ld [hl],a
    inc hl
    inc hl
    djnz _cmem8B_loop
  ret
















; ----------
; devolvera a = 0 si no está definica, otro valor en caso distinto

_checkdefined:  ; 0xb16c



  ld e,0
  ld c,a


  ld b,8
  
  ld hl, _KEY_CONTROL_RIGHT
  ;ld hl,_KEY_CONTROL_ACTION_1

  _checkdefined_loop:

  ld a,[hl]
  cp c
  jr z, _checkdefined_definida

  inc hl

  djnz _checkdefined_loop

  ld a,e

  _checkdefined_definida:

ret






; --- esto devolverá la tecla pulsada
; 3 primeros bits: indice de puerto
; resto: a uno el bit correspondiente a la tecla (prodría ser más de una)

_get_first_key:  ; 0xb17d


; codigos de teclas !!!
; ojo, que lo importante es el numero de puerto y el bit que cambia
; puerto, según el bit que se pone a cero
; Q -> 65 (puerto 2, bit 0)
; A -> 33 (puerto 1, bit 0)
; O -> 162 (puerto 5, bit 1)
; P -> 161 (puerto 5, bit 0)
; spc -> 225 (puerto 7, bit 0)
; M -> 228 (puerto 7, bit 2)
; N -> 232 (puerto 7, bit 3)
; ent -> 193 (puerto 6, bit 0)
; 1 -> 97
; 2 -> 98
; 3 -> 100
; 4 -> 104
; 5 -> 112
; 0 -> 129

  ld h,0
  ld l,h

  ld d,1

  ld b,8

  _get_first_key_loop:

  push bc

  ld c,0xfe
  ld a,d
  cpl
  ld b,a

  in a,(c)
  or 0xe0
  cpl

  cp 0
  jr z,_get_first_key_nohit

  ld b,a

  ld a,l
  or a
  rla
  rla
  rla
  rla
  rla
  or b

  ld h,a

  _get_first_key_nohit:


  or a
  rl d
  inc l

  pop bc

  djnz   _get_first_key_loop

  ld a,h

ret






; devolverá en a si la tecla está pulsada.. 0 si no, otro valor si sí
; entrada: a (3 primeros bits puerto, resto id tecla)


_test_key:  ; 0xb1a6



  ld [_TEST_KEY_AUXB],a

  and 0xe0
  cp 0x00 ; puerto 0
  jr nz, _test_key_p1   ; jp es más rápido... si la cosa se pone chunga cambiar a jr
    ld b,0xfe
   _test_key_p1:
  cp 0x20 ; puerto 1
  jr nz, _test_key_p2
    ld b,0xfd
   _test_key_p2:
  cp 0x40 ; puerto 2
  jr nz, _test_key_p3
    ld b,0xfb
   _test_key_p3:
  cp 0x60 ; puerto 3
  jr nz, _test_key_p4
    ld b,0xf7
   _test_key_p4:
  cp 0x80 ; puerto 4
  jr nz, _test_key_p5
    ld b,0xef
   _test_key_p5:
  cp 0xa0 ; puerto 5
  jr nz, _test_key_p6
    ld b,0xdf
   _test_key_p6:
  cp 0xc0 ; puerto 6
  jr nz, _test_key_p7
    ld b,0xbf
   _test_key_p7:
  cp 0xe0 ; puerto 7
  jr nz, _test_key_p8
    ld b,0x7f
   _test_key_p8:

  ld c,0xfe
  in a,(c)
  cpl
  ld b,a
  ld a,[_TEST_KEY_AUXB]
  and 0x1f
  and b


ret














_refreshInput: ; 0xb1e8




; obtencion de teclas




  ld h,0
  
  ld de, _KEY_CONTROL_RIGHT
  ; ld de,_KEY_CONTROL_ACTION_1

  _datos_teclas:

  ld b,8

  _datos_teclas_estandar_loop:
  push bc
  ld a,[de]
  call _test_key
  cp 0
  jp z, _datos_teclas_estandar_loop_nohit
  set 7,h
  _datos_teclas_estandar_loop_nohit:

  inc de
  rr h ; ceo que no hace falta poner el carry a cero
  pop bc
  djnz _datos_teclas_estandar_loop

  rl h ; recuperamos carry


  ld a,h


  ld [_ESTADO_TECLAS],a
  
  
  and 0xe0
  ld l,a



  ; _datos_kempston_loop:   ?????

  ld d,0
  ld c,0x1f
  in a,(c)
  ld h,a

  ;djnz _datos_kempston_loop  ; ?????


  or l
  ld [_ESTADO_JOYSTICK],a

  
  

ld a,[_ESTADO_JOYSTICK]
ld [_ESTADO_CONTROL],a
ld a,[_ESTADO_JOYSTICK_STICKY]
ld [_ESTADO_CONTROL_STICKY],a

ld a,[_FLAG_USO_TECLAS]
cp 0
jr nz,_pfj_nousateclas

ld a,[_ESTADO_TECLAS]
ld [_ESTADO_CONTROL],a
ld a,[_ESTADO_TECLAS_STICKY]
ld [_ESTADO_CONTROL_STICKY],a

_pfj_nousateclas:


  ld a,[_ESTADO_TECLAS]
  ld c,a
  cpl
  ld b,a
  ld a,[_ESTADO_TECLAS_STICKY_K]
  or b
  cpl
  ld [_ESTADO_TECLAS_STICKY],a
  ld a,c
  ld [_ESTADO_TECLAS_STICKY_K],a
  


  ld a,[_ESTADO_JOYSTICK]
  ld c,a
  cpl
  ld b,a
  ld a,[_ESTADO_JOYSTICK_STICKY_K]
  or b
  cpl
  ld [_ESTADO_JOYSTICK_STICKY],a
  ld a,c
  ld [_ESTADO_JOYSTICK_STICKY_K],a


ret





cclearkeys: ; 0xb259


    ld hl,_KEY_CONTROL_RIGHT
    ld b,1
    call  _clearMem8

ret




rredefinekey: ; 0xb262


    ld hl, _KEY_CONTROL_RIGHT
    ld d,0
    ld e,a
    add hl,de

    push hl

    _redef_loop:


    call  _get_first_key
    cp 0
    jr z, _redef_loop
    
    push af
    
    call  _checkdefined

    pop bc

    cp 0


    jr nz, _redef_loop


    
    pop hl
    
    ld [hl],b




ret

























    _ddecodificarpantalla: ; 0xb27d






    ld a,[_INPUT_DECODEPASS]

    ld [DECODIFICAR_PASADA],a
    
    ld b,88
    ld hl,_DIR_MAP_DECODE_BUFFER

    cp 1
    ld a,0x07 ; blanco sobre negro, por defecto
    jr z, _dp_limpiaatribs
    xor a

    _dp_limpiaatribs:


    ;call 0xb149 ; _setMem8
    call _setMem8


    xor a


    ld [DECODE_ATTRIB_CUSTOMFLAG],a






;----------------------------------
; decodificacion paginas
;----------------------------------


;-------------------------------------------------------
; decodificar página
; dirección del mapa en DE
; en b el número de página  ... ya no...
;-------------------------------------------------------


;decodificar_pagina:


  ;ld de,_DIR_MAP
  ;ld de,49152
  ld de,[_GV_MAP_ADDR_POINTER]


;  _GV_SPR_ADDR_POINTER equ _GLOBAL_VARS + 14 + 15 ; word
;  _GV_MAP_ADDR_POINTER equ _GLOBAL_VARS + 14 + 17 ; word
;  _GV_TILESET_ADDR_POINTER equ _GLOBAL_VARS + 14 + 19 ; word






  ld a,[_GV_MAP_CURRENT_PAGE]
  
  ld b,a






  cp 0
  jr z, _decodificar_pagina_bucle_localizar_pagina_fin

  _decodificar_pagina_bucle_localizar_pagina:

  inc de
  inc de

  djnz  _decodificar_pagina_bucle_localizar_pagina

  _decodificar_pagina_bucle_localizar_pagina_fin:



  ld a,[de]
  ld ixl,a
  inc de

  ld a,[de]
  ld ixh,a

  inc de


  ld a,[de]
  ld l,a
  inc de

  ld a,[de]
  ld h,a


  ld [DECODE_CLOSING_INDEX],hl


  ; en DECODE_CLOSING_INDEX esta la dirección tope


  _decodificar_pagina_bucle:


; recordemos...
; 0 -> numero tile
; 1 -> bit 5: custom attr, bit 6: use charset ||| 5 bits x1
; 2 -> bit 5: punto, bit 6: dato ||| 5 bits y1
; (opcional) -> custom attr
; (opcional) -> bits 5 y 6: wrapx ||| 5 bits x2
; (opcional) -> bits 5 y 6: wrapy ||| 5 bits y2
; (opcional) -> dato

  ; bueno, de momento lo básico

  ld a,[ix + 0] ; numero tile
  ld [DECODE_TILE],a
  inc ix

  ; saquemos el attrib.. posible "override" posterior

   ;ld hl, _DIR_TILESET_ATTRIBS  ; _TILESET_ATTRIBS
  ld hl,[_GV_TILESET_ATTR_ADDR_POINTER]



  ;_GV_SPR_ADDR_POINTER equ _GLOBAL_VARS + 14 + 15 ; word
  ;_GV_MAP_ADDR_POINTER equ _GLOBAL_VARS + 14 + 17 ; word
  ;_GV_TILESET_ADDR_POINTER equ _GLOBAL_VARS + 14 + 19 ; word






  add a,l
  ld l,a
  ld a,h
  adc a,0
  ld h,a
  ld a,[hl]

  ld [DECODE_ATTRIB],a

  xor a
  ld [DECODE_DATA],a



  ld a,[ix+0] ; x1 y más

  ld b,a
  and 31

  ld [DECODE_X1],a
  inc ix


  ld a,[ix+0] ; y1 y más
  ld c,a
  and 31

  ld [DECODE_Y1],a
  inc ix

  ; vale, en b y c tenemos los datos brutos, sacar de ahí los bits
  ; bit 5b : custom attr .. de momento nada aparte de incrementar ix
  ; bit 6b : charset .. de momento nada
  ; bit 5c : punto
  ; bit 6c : dato .. de momento nada aparte de incrementar ix

  bit 5,b
  jr z, _decodificar_pagina_nocustomattr

  ; de momento nada, solo incrementar ix
  ; bueno, la verdad que casi lo puedo ir haciendo..

  ld a,[ix+0]
  ld [DECODE_ATTRIB],a
  ld a,1
  ld [DECODE_ATTRIB_CUSTOMFLAG],a



  inc ix
  _decodificar_pagina_nocustomattr:


  bit 6,b
  jr z, _decodificar_pagina_nocharset

  ; al final no tendra nada que ver con charset.. será bit7



  ld a,[DECODE_DATA]
;  ld a,255
  or 128
  ld [DECODE_DATA],a

  _decodificar_pagina_nocharset:


  bit 7,b
  jr z, _decodificar_pagina_nobit6



  ld a,[DECODE_DATA]
;  ld a,255
  or 64
  ld [DECODE_DATA],a

  _decodificar_pagina_nobit6:


  bit 7,c
  jr z, _decodificar_pagina_nobit5



  ld a,[DECODE_DATA]
;  ld a,255
  or 32
  ld [DECODE_DATA],a

  _decodificar_pagina_nobit5:


  ld a,255
  ld [DECODE_X2],a
  ld [DECODE_Y2],a


  bit 5,c
  jr nz, _decodificar_pagina_nopunto

  push bc

  ld a,[ix+0]
  ld b,a
  and 31
  ld [DECODE_X2],a
  inc ix

  ld a,[ix+0]
  ld c,a
  and 31
  ld [DECODE_Y2],a
  inc ix


  ld a,b
  ;REPT 5
  or a
  rra
  ;ENDM
  or a
  rra
  or a
  rra
  or a
  rra
  or a
  rra



  cp 1
  jr nz, _decodificar_pagina_noajuste_wrapx

  ld a,255


  _decodificar_pagina_noajuste_wrapx:



  ld [DECODE_WRAPX],a

  ld a,c
;  REPT 5
  or a
  rra
;  ENDM
  or a
  rra
  or a
  rra
  or a
  rra
  or a
  rra



  cp 1
  jr nz, _decodificar_pagina_noajuste_wrapy

  ld a,255


  _decodificar_pagina_noajuste_wrapy:

  ld [DECODE_WRAPY],a


  pop bc
  _decodificar_pagina_nopunto:


  bit 6,c
  jr z, _decodificar_pagina_nodato

  ld a,[ix+0]
  ld [DECODE_DATA],a

  ; de momento nada, solo incrementar ix
  inc ix
  _decodificar_pagina_nodato:


  call decodificar_bloque



  ;pop bc
  ;dec b


  ld hl,[DECODE_CLOSING_INDEX]
  ld a,ixl
  cp l

  jp nz, _decodificar_pagina_bucle

  ld a,ixh
  cp h

  jp nz, _decodificar_pagina_bucle

  
  
  


ret



;-------------------------------------------------------
; decodificar bloque.. pues eso
;-------------------------------------------------------


decodificar_bloque:


  ;  no podemos usar ix
  



  ld a,[DECODE_X2]
  cp 255
  jr z, _decod_b_nostair








  ; ajuste del modo stair...
  xor a
  ;ld [DECODE_STAIR_SMALLADJUST],a
  ld [DECODE_STAIRMODE],a
  ld [DECODE_STAIR_PIVOT_ADD],a
  





  ld a,[DECODE_X1]
  ld [DECODE_STAIR_PIVOTX_1],a
  ld b,a
  ld a,[DECODE_X2]

  ld [DECODE_STAIR_PIVOTX_2],a
  cp b
  jr nc, _decod_b_nostair


  ld [DECODE_X1],a
  ld [DECODE_STAIR_PIVOTX_1],a
  ld a,b
  ld [DECODE_X2],a
  ld [DECODE_STAIR_PIVOTX_2],a 

  
  ld a,[DECODE_WRAPY]
    cp 0
  jr nz, _stair_ajustewerapy
  inc a
  ld [DECODE_WRAPY],a
  _stair_ajustewerapy:




  ld a,[DECODE_WRAPX]
  
  
  
  cp 0
  jr nz, _stair_ajustewerapx
  inc a
  _stair_ajustewerapx:



  ld b,a
  dec b

  ld [DECODE_STAIR_PIVOT_ADD],a
  ld a,[DECODE_X1]
  add a,b
  ld [DECODE_STAIR_PIVOTX_2],a







  ld a,2
  ld [DECODE_STAIRMODE],a


  ld a,[DECODE_Y1]
  ld b,a
  ld a,[DECODE_Y2]
  cp b
  


  jr nc, _decod_b_nostair

  ld [DECODE_Y1],a
  ld a,b
  ld [DECODE_Y2],a


  


  ld a,[DECODE_X2]
  ld [DECODE_STAIR_PIVOTX_2],a

  ld a,[DECODE_STAIR_PIVOT_ADD]
  neg
  ld b,a
  ld [DECODE_STAIR_PIVOT_ADD],a
  ld a,[DECODE_X2]
  add a,b
  inc a
  ld [DECODE_STAIR_PIVOTX_1],a








  
  ld a,1
  ld [DECODE_STAIRMODE],a



  
  _decod_b_nostair:





  ld a,[DECODE_TILE]
  ld [DECODE_BTILE],a
  ld a,[DECODE_ATTRIB]
  ld [DECODE_BATTRIB],a


  ld a,[DECODE_X2]
  cp 255
  jp z, _decodificar_bloque_solouno

;  jp _decodificar_bloque_solouno


  ; es bloque


  ld a,[DECODE_Y1]
  ld c,a

  xor a
  ld [DECODE_BWRYC],a


  _decodificar_bloque_bucle_y:


  ld a,[DECODE_X1]
  ld b,a


  xor a
  ld [DECODE_BWRXC],a


  _decodificar_bloque_bucle_x:



  ld a,[DECODE_WRAPX]
  ld d,a
  ld a,[DECODE_BWRXC]

  cp d
  jr c, _decodificar_bloque_noajustewrapx
  
  



  xor a
  ld [DECODE_BWRXC],a


  _decodificar_bloque_noajustewrapx:

  ld h,a

  ld a,[DECODE_WRAPY]
  ld d,a
  ld a,[DECODE_BWRYC]

  cp d
  jr c, _decodificar_bloque_noajustewrapy

  ; ajuste escalera
  


  ld a,[DECODE_STAIR_PIVOT_ADD]
  ld l,a

  ld a,[DECODE_STAIR_PIVOTX_1]
  add a,l
  ld [DECODE_STAIR_PIVOTX_1],a

  ld a,[DECODE_STAIR_PIVOTX_2]
  add a,l
  ld [DECODE_STAIR_PIVOTX_2],a
  





  xor a
  ld [DECODE_BWRYC],a

  _decodificar_bloque_noajustewrapy:

  ld l,a


  ld a,[DECODE_TILE]
  add a,h

  or a
  rl l
  rl l
  rl l
  rl l
  add a,l


  ld [DECODE_BTILE],a



  ; falta ajustar el attrib!
  ; bueno, parece q ya esta..


  push af
  ld a,[DECODE_ATTRIB_CUSTOMFLAG]
  ld l,a
  pop af
  bit 0,l
  jr nz, _decodificar_bloque_noajusteattrib

  ;ld hl, _DIR_TILESET_ATTRIBS
  ld hl,[_GV_TILESET_ATTR_ADDR_POINTER]




  add a,l
  ld l,a
  ld a,h
  adc a,0
  ld h,a
  ld a,[hl]

  ld [DECODE_BATTRIB],a

  _decodificar_bloque_noajusteattrib:



  push bc
  


  ld l,b
  inc l

  ld a,[DECODE_STAIR_PIVOTX_1]
  cp l
  jr nc, _stairs_nopunto

  ld a,[DECODE_STAIR_PIVOTX_2]
  cp b
  jr nc, _stairs_sipunto

  jr  _stairs_nopunto


  _stairs_sipunto:



  call decodificar_punto
  
  _stairs_nopunto:




  pop bc


  ld a,[DECODE_BWRXC]
  inc a
  ld [DECODE_BWRXC],a


  inc b
  ld a,[DECODE_X2]
  inc a
  cp b
  jr nz, _decodificar_bloque_bucle_x

  ld a,[DECODE_BWRYC]
  inc a
  ld [DECODE_BWRYC],a

  inc c
  ld a,[DECODE_Y2]
  inc a
  cp c
  jp nz, _decodificar_bloque_bucle_y



  jr _decodificar_bloque_fin
  _decodificar_bloque_solouno:
  ; es punto

  ld a,[DECODE_X1]
  ld b,a
  ld a,[DECODE_Y1]
  ld c,a



  call decodificar_punto


  _decodificar_bloque_fin:



  xor a

  ld [DECODE_ATTRIB_CUSTOMFLAG],a

ret



;----------------------------------------
; decodifica: en BC las coordenadas xy
;----------------------------------------


decodificar_punto:
  or a



  ld h,0

  ld a,b

  ld l,a


  ld a,c

  rla
  rla
  rla
  rla
  rl h
  rla
  rl h
  add a,l
  ld l,a
  ld a,h
  adc a,0
  ld h,a


  ld de,_DIR_MAP_DECODE_BUFFER
  add hl,de


  ld a,[DECODIFICAR_PASADA]
  cp 0

  jr nz, _decodificar_punto_pasada_1


  ld a,[DECODE_BTILE]


  jr _decodificar_punto_finpasada

  _decodificar_punto_pasada_1:
  cp 1
  jr nz, _decodificar_punto_pasada_2


  ld a,[DECODE_BATTRIB]


  jr _decodificar_punto_finpasada

  _decodificar_punto_pasada_2:



  ;ld de,_DIR_MAP_DECODE_BUFFER
  ;add hl,de


  ld a,[DECODE_DATA]
  
  




;------------

;  cp 0
;  jr nz, _noarreglitodecodificarpunto

;  ld a,[DECODE_BTILE]
;  cp 0
;  jr z, _noarreglitodecodificarpunto

;  ld a,9

;  xor a ; ????
;;  ld [hl],a

;------------------












;  _noarreglitodecodificarpunto:

;  ld [hl],a



  _decodificar_punto_finpasada:

  ld [hl],a


ret




_syncwait: ; 0xb4f6



    ld [_SYNC_WAIT],a
    ld e,a

    _syncwaitb:


    ld a,[0x5c78]

    cp e
    jp c, _syncwaitb


    _syncwaitf:

    xor a
    ld [_SYNC_WAIT],a
    ld [0x5c78],a
    

    ;call 0xb1e8 ; _refreshInput
    call _refreshInput

ret







_printtile:  ; 0xb50c




    ;push ix
    

    ld a,[_GV_COLLISION_RESULT]

    ld c,a ; indicador modo xor

    ld a,[_INPUT_TILENUM]

    ld hl,[_GV_TILESET_ADDR_POINTER]




    ld d,0
    or a
    rla
    rl d
    rla
    rl d
    rla
    rl d
    ld e,a

    add hl,de ; en hl la posición del char..

    ld d, _MEMORY_VIDEO_RASTER_HI
    ld a,[_INPUT_PRINT_TILE_Y]
    and 0x18
    add a,d
    ld d,a
    


    ld a,[_INPUT_PRINT_TILE_Y]

    rrca
    rrca
    rrca

    and 0xe0
    ld e,a

    ld a,[_INPUT_PRINT_TILE_X]
    add a,e
    ld e,a ; vale.. en de se supone que la posicion en destino..

    ;ld a,8
    ld b,8

    _buc_pt1:

    ;ldi
    
    ld a,[de]
    
    xor [hl]
    bit 0,c
    jr nz,_ptile_modoxor

    ld a,[hl]

    _ptile_modoxor:

    ld [de],a
    ;inc de

    inc hl
    

    ;dec de
    inc d

    ;dec a
    ;jr nz,_buc_pt1
    djnz _buc_pt1
    
    ;pop ix
ret





_collisionwithsprite: ; 0xb54a


    ld a,  [_GV_COLLISION_RESULT]
    ld d,a
    ld a,8
    sub d
    ld d,a


    ld a,0xff
    ld [_GV_COLLISION_RESULT],a
  
  
  
  

    ld a,[_GV_COLLISION_INPUT]
    ld c,a
    ld hl,_SPR_LIST
    ld b,8

    _cwsprloop:
    
    ld a,b
    cp d
    jr z, _cwspr_nonn
    
    ld a,[hl]
    inc hl

    bit 7,a
    jr z, _cwspr_nol


    and 0x18
    cp c
    jr nz, _cwspr_nol
    
    ld a,[hl]
    add a,8
    ld e,a

    ld a,[_GV_COLLISION_SPRX]
    ;sub 8

    sub e ;[hl]
    jr nc, _cwspr_nol
    cp 241
    jr c, _cwspr_nol

    inc hl
    
    ld a,[hl]
    add a,8
    ld e,a

    ld a,[_GV_COLLISION_SPRY]
    ; sub 8

    sub e ;[hl]
    jr nc, _cwspr_nolb
    cp 241
    jr c, _cwspr_nolb

    ld a,b
    ld [_GV_COLLISION_RESULT],a
    jr _cwspr_lff
    _cwspr_nonn:
    inc hl
    _cwspr_nol:
    inc hl
    _cwspr_nolb:
    inc hl
    inc hl
    _cwspr_lf:

    djnz _cwsprloop
    
    _cwspr_lff:


ret







_collisionwithdot:  ; 0xb595 + 4




    ld a,[_GV_COLLISION_INPUT]
    ld c,a
    ld hl,_DOT_LIST
    ld b,8

    _cwdotloop:
    
    ld a,[hl]
    
    inc hl
    
    bit 7,a
    jr z, _cwdot_nol


    ld d,[hl]
    and 0x18
    cp c
    jr nz, _cwdot_nol
    
    ld a,[_GV_COLLISION_SPRX]
    inc d
    sub d
    jr nc, _cwdot_nol
    cp 248
    jr c, _cwdot_nol

    inc hl
    ld d,[hl]

    ld a,[_GV_COLLISION_SPRY]
    inc d
    sub d
    jr nc, _cwdot_nolb

    cp 248
    jr c, _cwdot_nolb


    ld a,b
    ld [_GV_COLLISION_RESULT],a
    jr _cwdot_lff
    _cwdot_nol:
    inc hl
    _cwdot_nolb:
    inc hl
    ;_cwdot_lf:
    inc hl

    djnz _cwdotloop
    
    _cwdot_lff:

ret

















  _colblock_lin1:
  ld a,[ix+2]
  cp h
  jr c, _colblock_lin1b
  ld h,a
  _colblock_lin1b:
  ld a,[ix+1]
  cp h
  jr c, _colblock_lin1c
  ld h,a
  _colblock_lin1c:
  ld a,[ix+0]
  cp h
  ret c
  ld h,a
  ret


  _colblock_lin2:
  ld a,[ix+2+ 32]
  cp h
  jr c, _colblock_lin2b
  ld h,a
  _colblock_lin2b:
  ld a,[ix+1+ 32]
  cp h
  jr c, _colblock_lin2c
  ld h,a
  _colblock_lin2c:
  ld a,[ix+0+ 32]
  cp h
  ret c
  ld h,a
  ret


  _colblock_lin3:
  ld a,[ix+2+ 64]
  cp h
  jr c, _colblock_lin3b
  ld h,a
  _colblock_lin3b:
  ld a,[ix+1+ 64]
  cp h
  jr c, _colblock_lin3c
  ld h,a
  _colblock_lin3c:
  ld a,[ix+0+ 64]
  cp h
  ret c
  ld h,a
  ret




  _colblock_row1:
  ld a,[ix+64]
  cp h
  jr c, _colblock_row1b
  ld h,a
  _colblock_row1b:
  ld a,[ix+32]
  cp h
  jr c, _colblock_row1c
  ld h,a
  _colblock_row1c:
  ld a,[ix+0]
  cp h
  ret c
  ld h,a
  ret


  _colblock_row2:
  ld a,[ix+1+ 64]
  cp h
  jr c, _colblock_row2b
  ld h,a
  _colblock_row2b:
  ld a,[ix+1+ 32]
  cp h
  jr c, _colblock_row2c
  ld h,a
  _colblock_row2c:
  ld a,[ix+1+ 0]
  cp h
  ret c
  ld h,a
  ret


  _colblock_row3:
  ld a,[ix+2+ 64]
  cp h
  jr c, _colblock_row3b
  ld h,a
  _colblock_row3b:
  ld a,[ix+2+ 32]
  cp h
  jr c, _colblock_row3c
  ld h,a
  _colblock_row3c:
  ld a,[ix+2+ 0]
  cp h
  ret c
  ld h,a
  ret









_collisionwithblock:  ; 0xb647  + 9





  push ix


  ld a,[_GV_COLLISION_SPRX]
  and 0x03
  ld b,a
  ld a,[_GV_COLLISION_SPRY]
  and 0x03
  ld c,a


  ld ix,_DIR_MAP_DECODE_BUFFER
  


  ld a,[_GV_COLLISION_SPRX]
  rra
  rra
  and 0x1f
  ld e,a

  ld d,0
  ld h,d

  ld a,[_GV_COLLISION_SPRY]
  and 0x7c
  rla
  rla
  rl d
  rla
  rl d


  or e
  ld e,a

  add ix,de


  ; bien, en bc indicación de si son 2 o 3 bloques (0-> 2 bloques, no 0-> 3 bloques), en ix la coordenada efectiva inicial
  ; en h el valor mayor encontrado, por defecto 0
  ; en l




  ld a,[_GV_COLLISION_INPUT]
  
  cp 0
  jr nz, _cwblock_nocenter

  cp b
  call nz, _colblock_lin1
  call z, _colblock_lin1b
  xor a
  cp b
  call nz, _colblock_lin2
  call z, _colblock_lin2b


  xor a
  cp c
  jr z, _colblock_fin

  cp b
  call nz,_colblock_lin3
  call z, _colblock_lin3b


  jr _colblock_fin
  _cwblock_nocenter:

  cp 1
  jr nz, _cwblock_noup
  
  ld a,b
  cp 0
  call nz, _colblock_lin1
  call z, _colblock_lin1b

  jr _colblock_fin
  _cwblock_noup:
  cp 2
  jr nz, _cwblock_nodown
  
  ld a,c
  cp 0
  ld a,b
  jr z, _cwblock_down_a

  cp 0
  call nz, _colblock_lin3
  call z, _colblock_lin3b
  jr _colblock_fin

  _cwblock_down_a:
  
  cp 0
  call nz, _colblock_lin2
  call z, _colblock_lin2b


  jr _colblock_fin
  _cwblock_nodown:
  cp 3
  jr nz, _cwblock_noleft

  ld a,c
  cp 0
  call nz, _colblock_row1
  call z, _colblock_row1b



  jr _colblock_fin
  _cwblock_noleft:
  ;cp 4
  ;jr nz, _colblock_fin
  



  ld a,b
  cp 0
  ld a,c
  jr z, _cwblock_right_a

  cp 0
  call nz, _colblock_row3
  call z, _colblock_row3b
  jr _colblock_fin

  _cwblock_right_a:

  cp 0
  call nz, _colblock_row2
  call z, _colblock_row2b








  jr _colblock_fin

  _colblock_fin:
  

  ld a,h
  ld [_GV_COLLISION_RESULT],a




  pop ix




ret






  _crunchAttribs:  ;  0xb6f4   + 9



  ld hl,_DIR_MAP_DECODE_BUFFER
  ld de,_DIR_ADDITIONAL_BUFFER

  call _crunchAttribsB
  call _crunchAttribsB
  

  ret

  _crunchAttribsB:

  ld b, 176

  _chunchA_loop:

  ld a,[hl]
  rla
  rla
  rla
  


  and 0x38
  ld c,a
  inc hl

  ld a,[hl]
  and 0x07


  or c


  ld [de],a
  inc hl
  inc de

  djnz _chunchA_loop

  ret




; ------------- parte chunga.. sprites y frames...

















  _preimprimirSprite: ; bc -> pos yx / ix -> dir del sprite



  ld a,b
  rlca   ; se supone que y < 128
  
  ld hl,[_GV_CURRENT_RASTER_POINTERS]
  ld de,[_PF_RASTER_BUFFER_TOP]
  add a,l
  ld l,a
  ld a,h
  adc a,0
  ld h,a

  ; vale, se supone que en hl está el primer putero.. puntero

  ld b,8

  _preimprimirSprite_buc:
  push bc  ; en c seguimos teniendo la coordenada x.. fresquita a cada vuelta
  push hl

  ;ld a,c
  ;ld [_PF_STR_KEEPX],a    ; mmm puede que no haga falta guardarlo



  ld b,[hl]
  ld [hl],d
  inc hl
  ld a,[hl]
  ld [hl],e
  
  push ix
  pop hl

  ld ixh,b
  ld ixl,a ; bien, en ix está el valor que habrá que añadir al final del bloque.. el siguiente puntero
         ; en de seguimos teniendo la dieccion del bloque





  ld a,c
  rra
  rra
  and 0x3f

  ld [de],a  ; pos x
  xor a
  inc de
  
  ld [_PF_STR_PANNING],de
  
  ldi
  ldi
  ld [de],a
  inc de
  ldi
  ldi
  ld [de],a
  inc de
  
  ld a,ixh
  ld [de],a
  ld a,ixl
  inc de
  ld [de],a

  inc de
  ld [_PF_RASTER_BUFFER_TOP],de



  bit 1,c
  jr z, _preimprimirSprite_nobigpanning

  push hl
  
  ld hl,[_PF_STR_PANNING]


  xor a
  rrd
  inc hl
  rrd
  inc hl
  rrd
  inc hl

  xor a
  rrd
  inc hl
  rrd
  inc hl
  rrd
  
  pop hl


  _preimprimirSprite_nobigpanning:
  
  
  bit 0,c
  jr z, _preimprimirSprite_nosmallpanning
  
  exx


  ld hl,[_PF_STR_PANNING]

  ld a,[hl]
  inc hl
  ld b,[hl]
  inc hl
  ld c,[hl]
  inc hl

  push hl

  ld hl,[_PF_STR_PANNING]
  
  or a

  rra
  rr b
  rr c
  rra
  rr b
  rr c
  
  ld [hl],a
  inc hl
  ld [hl],b
  inc hl
  ld [hl],c


  
  pop hl

  push hl
  
  ld a,[hl]
  inc hl
  ld b,[hl]
  inc hl
  ld c,[hl]
  inc hl
  

  pop hl

  or a
  
  rra
  rr b
  rr c
  rra
  rr b
  rr c
  
  ld [hl],a
  inc hl
  ld [hl],b
  inc hl
  ld [hl],c





  exx



  
  _preimprimirSprite_nosmallpanning:
  






  push hl
  pop ix


  pop hl
  inc hl
  inc hl ; siguiente puntero..
  



  pop bc
  
  dec b

  jp nz, _preimprimirSprite_buc



  ret




  _procesarSprites: ; 0xb7bc + 9


  ; ret  ; deshabilitado pa probarrrll..


  ld hl, _SPR_LIST
  ld b,8

  _prsptloop:

  push bc

  ld a,[hl]
  inc hl
  bit 7,a

  jp z, _prspt_nosp

  ; de momento solo me quedo con la pos yx
  
  
  bit 6,a
  jr z, _prspt_noattr
  push hl
  push ix



  ; procesamiento de los attr..

  ld b,3
  and 0x07
  ex af, af' ; en a' el atributo
  ld d,[hl] ; pos x
  inc hl
  ld c,[hl] ; pos y.. procesamos
  ld a,c
  rra
  and 0x3e


  ld e,a
  ld a,c
  and b
  jr nz, _prspt_noajusteatry
  dec b
  _prspt_noajusteatry:



  ld a,d
  ld c,2
  and 0x3
  jr nz, _prspt_noajusteatrx
  dec c
  _prspt_noajusteatrx:
  
  ld a,d
  rra
  rra
  and 0x1f
  ld d,a
  


  ; compactamos..
  ld a,c
  rrca
  rrca
  and 0xc0
  or d
  ld c,a
  ex af, af'
  ld d,a

  ; en b el tamaño y, en c la combinación tamaño x y posicion x
  ; en e la posicion y (doblada para pillar puntero)
  ; en d el atrib..
  

  ld ix,[_GV_CURRENT_ATTR_POINTERS]
  ld a,e
  add a,ixl
  ld ixl,a
  ld a,ixh
  adc a,0
  ld ixh,a

  ld hl,[_PF_ATTRIB_BUFFER_TOP]


  _prspt_bucatr1:
  
  ld a,[ix+0]
  ld e,[ix+1]

  ld [ix+0],h
  ld [ix+1],l

  ld [hl],c
  inc hl
  ld [hl], d
  inc hl
  ld [hl],a
  inc hl
  ld [hl],e
  inc hl



  inc ix
  inc ix




  djnz _prspt_bucatr1
  
  
  ld [_PF_ATTRIB_BUFFER_TOP],hl
  


  ;ld [ix+0],0
  ;ld [ix+1],0


  pop ix
  pop hl

  _prspt_noattr:




  ld c,[hl]


  inc hl

  ld b,[hl]

  inc hl


  ld d,0
  ld a,[hl]

  rla
  rl d
  rla
  rl d
  rla
  rl d
  rla
  rl d
  rla
  rl d
  and 0xe0
  ld e,a

  push hl



  ld ix, [_GV_SPR_ADDR_POINTER]

  add ix,de

  call _preimprimirSprite

  pop hl


  jr _prspt_spcont
  _prspt_nosp:
  inc hl
  inc hl
  _prspt_spcont:
  inc hl


  pop bc
  dec b
  jp nz, _prsptloop
  
  ret











  _preimprimirDot: ; bc -> pos yx /

  ld a,b
  rlca   ; se supone que y < 128

  ld hl,[_GV_CURRENT_RASTER_POINTERS]
  ld de,[_PF_RASTER_BUFFER_TOP]
  add a,l
  ld l,a
  ld a,h
  adc a,0
  ld h,a

  ; vale, se supone que en hl está el primer putero.. puntero


  push hl



  ld b,[hl]
  ld [hl],d
  inc hl
  ld a,[hl]
  ld [hl],e




  ld ixh,b
  ld ixl,a ; bien, en ix está el valor que habrá que añadir al final del bloque.. el siguiente puntero
         ; en de seguimos teniendo la dieccion del bloque





  ld a,c
  rra
  rra
  and 0x3f

  ld [de],a  ; pos x
  inc de

  ld [_PF_STR_PANNING],de

  ld a,0xc0
  ld [de],a
  xor a
  inc de
  ld [de],a
  inc de
  ld [de],a
  inc de
  
  ld a,0xc0
  ld [de],a
  xor a
  inc de
  ld [de],a
  inc de
  ld [de],a
  inc de
  

  
  ld a,ixh
  ld [de],a
  ld a,ixl
  inc de
  ld [de],a
  
  inc de
  ld [_PF_RASTER_BUFFER_TOP],de
  


  bit 1,c
  jr z, _preimprimirDot_nobigpanning
  
  push hl

  ld hl,[_PF_STR_PANNING]


  xor a
  rrd
  inc hl
  rrd
  inc hl
  rrd
  inc hl

  xor a
  rrd
  inc hl
  rrd
  inc hl
  rrd
  
  pop hl


  _preimprimirDot_nobigpanning:
  
  
  bit 0,c
  jr z, _preimprimirDot_nosmallpanning
  
  exx


  ld hl,[_PF_STR_PANNING]

  ld a,[hl]
  inc hl
  ld b,[hl]
  inc hl
  ld c,[hl]
  inc hl

  push hl
  
  ld hl,[_PF_STR_PANNING]
  
  or a
  
  rra
  rr b
  rr c
  rra
  rr b
  rr c
  
  ld [hl],a
  inc hl
  ld [hl],b
  inc hl
  ld [hl],c



  pop hl
  
  push hl

  ld a,[hl]
  inc hl
  ld b,[hl]
  inc hl
  ld c,[hl]
  inc hl
  

  pop hl
  
  or a
  
  rra
  rr b
  rr c
  rra
  rr b
  rr c
  
  ld [hl],a
  inc hl
  ld [hl],b
  inc hl
  ld [hl],c



  exx

  _preimprimirDot_nosmallpanning:




  push hl
  pop ix


  pop hl
  inc hl
  inc hl ; siguiente puntero..



  ret





  _procesarDots: ; 0xb8fb + 9




  ld hl, _DOT_LIST
  ld b,8

  _prdloop:

  push bc

  ld a,[hl]
  inc hl
  bit 7,a

  jp z, _prd_nosp
  
  ; de momento solo me quedo con la pos yx
  

  bit 6,a
  jr z, _prd_noattr

  push hl
  push ix
  


  ; procesamiento de los attr..



  and 0x07

  ld d,a

  ld a,[hl] ; pos x
  rra
  rra
  and 0x1f
  ld c,a

  inc hl
  ld a,[hl] ; pos y.. procesamos
  rra
  and 0x3e
  ld e,a



  ; en c la pos x
  ; en e la posicion y (doblada para pillar puntero)
  ; en d el atrib..

  
  ld ix,[_GV_CURRENT_ATTR_POINTERS]
  ld a,e
  add a,ixl
  ld ixl,a
  ld a,ixh
  adc a,0
  ld ixh,a

  ld hl,[_PF_ATTRIB_BUFFER_TOP]



  ld a,[ix+0]
  ld e,[ix+1]
  
  ld [ix+0],h
  ld [ix+1],l

  ld [hl],c
  inc hl
  ld [hl], d
  inc hl
  ld [hl],a
  inc hl
  ld [hl],e
  inc hl



  inc ix
  inc ix



  
  ld [_PF_ATTRIB_BUFFER_TOP],hl
  



  pop ix
  pop hl

  _prd_noattr:
  
  





  ld c,[hl] ; posx ?


  inc hl

  ld b,[hl] ; pos y?



  push hl


  call _preimprimirDot

  pop hl


  jr _prd_spcont
  _prd_nosp:

  inc hl
  _prd_spcont:
  inc hl
  inc hl


  pop bc
  
  djnz _prdloop

  
  ret












  _procesarFrame: ; 0xb95e + 10
  
 

  ;xor a
  ;ld [_PF_STR_ATTRBUFF_FLAGODD],a

  
  ld hl, _DIR_ADDITIONAL_BUFFER
  ld [_PF_STR_ATTRBUFF_2],hl




  ld hl,_MEMORY_VIDEO_ATTRIBS
  ld [_PF_STR_ATTR_LINE], hl

  ld ixh, _DIR_LINE_TABLE_HI

  ld hl,_GV_CURRENT_ATTR_POINTERS
  ld c,[hl]
  inc hl
  ld b,[hl]
  ld [_PF_STR_CR_ATTR_POINTERS],bc


  ld hl,_GV_BACK_ATTR_POINTERS
  ld a,[hl]
  ld [_PF_STR_BK_ATTR_POINTERS],a
  inc hl
  ld a,[hl]
  ld [_PF_STR_BK_ATTR_POINTERS+1],a



  ld hl,_GV_BACK_RASTER_POINTERS
  ld e,[hl]
  inc hl
  ld d,[hl]
  


  exx



  ld hl,_GV_CURRENT_RASTER_POINTERS
  ld e,[hl]
  inc hl
  ld d,[hl]

  ld bc, 0x5800

  _pf_mainloop:

  push bc

  ; obtener dirección efectiva de línea


  ld ixl,c

  
  ld a,c


  and 0x06


  call z, _pf_lineaatrib


  ld h,[ix+0]
  ld l,[ix+1]


  push hl


  ; en de el puntero actual
  ; en hl la linea de impresión actual
  
  call _pf_linearaster

  exx
  pop hl


  call _pf_linearaster

  
  exx
  



  pop bc
  inc c
  inc c
  dec b
  jp nz, _pf_mainloop



  ;call 0xb0e2 ;_flipBuffers

  call _flipBuffers




  ret




  _pf_linearaster:



  push de

  _pf_linearaster_buc1:

  ld a,[de]
  cp 0
  jr z, _pf_linearaster_bucf ; puntero "cero"
  ld c,a
  inc de
  ld a,[de]


  ld e,a
  ld d,c
  push hl

  ld a,[de] ; posicion x
  push af
  add a,l ; en principio no hay que ocuparse del carry ni nada..
  ld l,a
  
  inc de
  
  ; bien, en hl la posición x

  ld a,[de]
  xor [hl]

  ld [hl],a
  inc de
  inc hl

  ld a,[de]
  xor [hl]
  ld [hl],a
  inc de
  inc hl

  ld a,[de]
  xor [hl]
  ld [hl],a
  inc de

  pop af

  pop hl
  push hl
  inc h
  
  add a,l ; en principio no hay que ocuparse del carry ni nada..
  ld l,a

  ld a,[de]
  xor [hl]
  ld [hl],a
  inc de
  inc hl

  ld a,[de]
  xor [hl]
  ld [hl],a
  inc de
  inc hl

  ld a,[de]
  xor [hl]
  ld [hl],a
  inc de
  
  pop hl
  

  jr _pf_linearaster_buc1


  _pf_linearaster_bucf:


  pop de
  inc de ; siguiente puntero raster
  inc de





  ret






  _pf_lineaatrib: ; hl usable, bc usable)
  ;  en _PF_STR_CR_ATTR_POINTERS los punteros actuales y en _PF_STR_BK_ATTR_POINTERS los anteriores..
   ; _PF_STR_ATTR_LINE contiene la linea actual de attribs



  push ix




  ; borrados...

  ld hl,[_PF_STR_BK_ATTR_POINTERS]

  ld b,h
  ld c,l
  inc bc
  inc bc
  ld [_PF_STR_BK_ATTR_POINTERS],bc
  
  ; ok, en [hl] el primer puntero. Son borrados, no tomaremos en cuenta el valor..
  

  
  


  _pf_atr_borr_pbloc:



  ld a,[hl]
  cp 0
  jr z, _pf_atr_borr_pblocf
  inc hl
  ld l,[hl]
  ld h,a


  ld ix,[_PF_STR_ATTRBUFF_2]
  ;ld ix, _DIR_ADDITIONAL_BUFFER + 272 ;+ 16
  ;ld [_PF_STR_ATTRBUFF],ix






  ld a,[hl]
  and 0x1f
  ld c,a
  ld b,0

  push bc
  xor a
  rr c
  rla
  ld [_PF_STR_ATTRBUFF_FLAGODD],a

  add ix,bc
  ld [_PF_STR_ATTRBUFF],ix
  
  pop bc
  ld ix,[_PF_STR_ATTR_LINE]

  add ix,bc
  ld a,[hl]
  rlca
  rlca
  and 0x03
  ld b,a
  inc b

  inc hl

  _pf_atr_bucesc1b:

  
  push hl
  ld hl,[_PF_STR_ATTRBUFF]





  ld a,[_PF_STR_ATTRBUFF_FLAGODD]
  bit 0,a
  jr z, _pf_borrbitcero
  xor a
  ld [_PF_STR_ATTRBUFF_FLAGODD],a

  ld a,[hl]

  inc hl
  ld [_PF_STR_ATTRBUFF],hl


  jr _pf_borrbitfin
  _pf_borrbitcero:
  inc a
  ld [_PF_STR_ATTRBUFF_FLAGODD],a
  


  ld a,[hl]
  rra
  rra
  rra

  _pf_borrbitfin:
  
  pop hl
  



  and 0x07
  ld c,a

  ld a,[ix+0]
  and 0xf8
  or c


  ld [ix+0],a
  inc ix


  djnz _pf_atr_bucesc1b
  
  inc hl


  jr _pf_atr_borr_pbloc


  _pf_atr_borr_pblocf:


  










  ;pop ix
  ;push ix

  ; escrituras...


  ld hl,[_PF_STR_CR_ATTR_POINTERS]
  ld b,h
  ld c,l
  inc bc
  inc bc
  ld [_PF_STR_CR_ATTR_POINTERS],bc





 ; ok, en [hl] el primer puntero

 


  _pf_atr_escr_pbloc:


  ld a,[hl]
  cp 0
  jr z, _pf_atr_escr_pblocf
  inc hl
  ld l,[hl]
  ld h,a



  ld ix,[_PF_STR_ATTR_LINE]


  ld a,[hl]
  and 0x1f
  ld c,a
  ld b,0
  add ix,bc
  ld a,[hl]
  rlca
  rlca
  and 0x03
  ld b,a
  inc b

  inc hl

  _pf_atr_bucesc1:



  ld a,[ix+0]
  and 0xf8
  or [hl]
  ld [ix+0],a
  inc ix


  djnz _pf_atr_bucesc1

  inc hl


  jr _pf_atr_escr_pbloc


  _pf_atr_escr_pblocf:


  

  

  


  
  pop ix


  ld hl,[_PF_STR_ATTRBUFF_2]
  ld a,0x10
  add a,l
  ld l,a
  ld a,h
  adc a,0
  ld h,a
  ld [_PF_STR_ATTRBUFF_2],hl


  ;di
  ;jp $

  ld hl,[_PF_STR_ATTR_LINE]
  ld a,0x20
  add a,l
  ld l,a
  ld a,h
  adc a,0
  ld h,a
  ld [_PF_STR_ATTR_LINE],hl





  ret








 _volcarrastermapa: ; 0xbab5 + 10



 ld hl, _DIR_MAP_DECODE_BUFFER
 ld c, 22
 
 _vrm_loopy:
 
 ld b,32
 _vrm_loopx:
 
 push bc
 push hl
 
 xor a
 ld [_GV_COLLISION_RESULT],a

 ld a,[hl]
 ld [_INPUT_TILENUM],a
 
 ld a,22
 sub c
 ld [_INPUT_PRINT_TILE_Y],a
 
 ld a,32
 sub b
 ld [_INPUT_PRINT_TILE_X],a

 ; call 0xb50c ; _printtile
 call _printtile

 pop hl
 inc hl
 pop bc

 djnz _vrm_loopx
 
 
 dec c
 jr nz, _vrm_loopy
 
 ret


_decodificarpantalla: ;  0xbade + 10



    push af
    ld [_GV_MAP_CURRENT_PAGE],a
    xor a
    ld [_INPUT_DECODEPASS],a
    ;call 0xb27d ; _ddecodificarpantalla
    call  _ddecodificarpantalla


    ;call 0xbab5 ; _volcarrastermapa
    call  _volcarrastermapa

    pop af
    push af
    ld [_GV_MAP_CURRENT_PAGE],a
    ld a,1
    ld [_INPUT_DECODEPASS],a
    ;call 0xb27d ; _ddecodificarpantalla
    call _ddecodificarpantalla


    ld hl, _DIR_MAP_DECODE_BUFFER
    ld de, _MEMORY_VIDEO_ATTRIBS
    ld bc, 704
    ldir

    ;call  0xb6f4 ; _crunchAttribs
    call   _crunchAttribs


    pop af
    ld [_GV_MAP_CURRENT_PAGE],a
    ld a,2
    ld [_INPUT_DECODEPASS],a
    ;call 0xb27d ; _ddecodificarpantalla
    call  _ddecodificarpantalla



ret























_KEY_CONTROL_RIGHT: db 161
_KEY_CONTROL_LEFT: db 162
_KEY_CONTROL_DOWN: db 33
_KEY_CONTROL_UP: db 65
_KEY_CONTROL_ACTION_1: db 225

_KEY_CONTROL_ACTION_2: db 228
_KEY_CONTROL_ACTION_3: db 232
_KEY_CONTROL_ACTION_4: db 193

















org 0xbf00

  ; Lista conversion líneas

  dw 0x0040, 0x0042, 0x0044, 0x0046
  dw 0x2040, 0x2042, 0x2044, 0x2046
  dw 0x4040, 0x4042, 0x4044, 0x4046
  dw 0x6040, 0x6042, 0x6044, 0x6046
  dw 0x8040, 0x8042, 0x8044, 0x8046
  dw 0xa040, 0xa042, 0xa044, 0xa046
  dw 0xc040, 0xc042, 0xc044, 0xc046
  dw 0xe040, 0xe042, 0xe044, 0xe046

  dw 0x0048, 0x004a, 0x004c, 0x004e
  dw 0x2048, 0x204a, 0x204c, 0x204e
  dw 0x4048, 0x404a, 0x404c, 0x404e
  dw 0x6048, 0x604a, 0x604c, 0x604e
  dw 0x8048, 0x804a, 0x804c, 0x804e
  dw 0xa048, 0xa04a, 0xa04c, 0xa04e
  dw 0xc048, 0xc04a, 0xc04c, 0xc04e
  dw 0xe048, 0xe04a, 0xe04c, 0xe04e

  dw 0x0050, 0x0052, 0x0054, 0x0056
  dw 0x2050, 0x2052, 0x2054, 0x2056
  dw 0x4050, 0x4052, 0x4054, 0x4056
  dw 0x6050, 0x6052, 0x6054, 0x6056
  dw 0x8050, 0x8052, 0x8054, 0x8056
  dw 0xa050, 0xa052, 0xa054, 0xa056
