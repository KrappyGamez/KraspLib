' Krasplib beta 0.16
' Archivo BAS - Envoltorio / Wrapper
' (C) KrappyGamez 2025 bajo licencia MIT



' desde 0xa7bc hasta bfff ocupado por bufferes y código

asm
  _CALL_ADDR_ADJUST equ 996 - 10
  _BUFFER_ADDR_ADJUST equ 984 + _CALL_ADDR_ADJUST  - 8
end asm

const PK_BUFFER_ADDR_ADJUST as uinteger = 984 + 996  - 10 - 8 ' en realidad privada

' Definiciones BASIC


const KC_SEL_KEY_RIGHT as ubyte = 0
const KC_SEL_KEY_LEFT as ubyte = 1
const KC_SEL_KEY_DOWN as ubyte = 2
const KC_SEL_KEY_UP as ubyte = 3
const KC_SEL_KEY_ACTION_1 as ubyte = 4
const KC_SEL_KEY_ACTION_2 as ubyte = 5
const KC_SEL_KEY_ACTION_3 as ubyte = 6
const KC_SEL_KEY_ACTION_4 as ubyte = 7


const KC_SFX_HIT as ubyte = 0
const KC_SFX_PICK as ubyte = 1
const KC_SFX_SELECT as ubyte = 2
const KC_SFX_LOOSE as ubyte = 3
const KC_SFX_LONG_LOW_TICK as ubyte = 4
const KC_SFX_LONG_HIGH_TICK as ubyte = 5
const KC_SFX_SHORT_HIGH_TICK as ubyte = 6
const KC_SFX_SHORT_LOW_TICK as ubyte = 7



const KC_COL_BLOCK_CENTER as ubyte = 0
const KC_COL_BLOCK_UP as ubyte = 1
const KC_COL_BLOCK_DOWN as ubyte = 2
const KC_COL_BLOCK_LEFT as ubyte = 3
const KC_COL_BLOCK_RIGHT as ubyte = 4


const KC_MASK_INPUT_RIGHT as ubyte = 1
const KC_MASK_INPUT_LEFT as ubyte = 2
const KC_MASK_INPUT_DOWN as ubyte = 4
const KC_MASK_INPUT_UP as ubyte = 8
const KC_MASK_INPUT_ACTION_1 as ubyte = 16
const KC_MASK_INPUT_ACTION_2 as ubyte = 32
const KC_MASK_INPUT_ACTION_3 as ubyte = 64
const KC_MASK_INPUT_ACTION_4 as ubyte = 128




const KC_MEMORY_VIDEO_RASTER as uinteger = 0x4000
const KC_MEMORY_VIDEO_ATTRIBS as uinteger = 0x5800


const KC_DIR_MAP_DECODE_BUFFER as uinteger = 0xa7d0 + 32 + 32  + PK_BUFFER_ADDR_ADJUST
const KC_DIR_ATTRIB_BUFFER as uinteger = 0xa7d0 + 32 + 32 + 704 + PK_BUFFER_ADDR_ADJUST



const PK_GLOBAL_VARS as uinteger =  0xbfb0 '0xad00     ' privada

' pendientes de documentar


const KC_ELEMENT_ENABLED as ubyte = 0x80
const KC_ELEMENT_USEATTRIB as ubyte = 0x40

const KC_AFFINITY_MASK as ubyte = 0x18
const KC_AFFINITY_0 as ubyte = 0x00
const KC_AFFINITY_1 as ubyte = 0x08
const KC_AFFINITY_2 as ubyte = 0x10
const KC_AFFINITY_3 as ubyte = 0x18



const KV_DECODE_PASS_RASTER as ubyte = 0
const KV_DECODE_PASS_ATTRIBS as ubyte = 1
const KV_DECODE_PASS_DATA as ubyte = 2






dim kv_databuffer(704) as ubyte at KC_DIR_MAP_DECODE_BUFFER
dim kv_keydefs(8) as ubyte at 0xbef8 - 10 ' ojo, asjutar si cambiamos el ajuste de direcciones







dim kv_spraddr as uinteger at PK_GLOBAL_VARS + 29
dim kv_mapaddr as uinteger at PK_GLOBAL_VARS + 31
dim kv_tilesetaddr as uinteger at PK_GLOBAL_VARS + 33
dim kv_tilesetattraddr as uinteger at PK_GLOBAL_VARS + 35


dim pk_maproomselector as ubyte at PK_GLOBAL_VARS


dim pk_maploadpass as ubyte at PK_GLOBAL_VARS + 43
dim pk_printtileinputx as ubyte at PK_GLOBAL_VARS + 43
dim pk_printtileinputy as ubyte at PK_GLOBAL_VARS + 44
dim pk_printtileinputn as ubyte at PK_GLOBAL_VARS + 45


dim pk_collisionresult as ubyte at PK_GLOBAL_VARS  + 37
dim pk_collisioninput as ubyte at PK_GLOBAL_VARS   + 38
dim pk_collisionsprx as ubyte at PK_GLOBAL_VARS    + 39
dim pk_collisionspry as ubyte at PK_GLOBAL_VARS    + 40


dim kv_usejoystick as ubyte at PK_GLOBAL_VARS + 73
dim kv_userinput as ubyte at PK_GLOBAL_VARS + 78
dim kv_userinputpulse as ubyte at PK_GLOBAL_VARS + 79






dim kv_spritedefs(32) as ubyte at 0xa7d0  + PK_BUFFER_ADDR_ADJUST
dim kv_dotdefs(32) as ubyte at 0xa7d0 + 32  + PK_BUFFER_ADDR_ADJUST





' Llamadas basic de funciones y sub externas



sub fastcall ks_decodeScreen(room as ubyte)

asm
  push ix
call 0xbade + _CALL_ADDR_ADJUST + 10; _decodificarpantalla
  pop ix
end asm

end sub




sub fastcall ks_kraspInit()
  asm
  call 0xb000 + _CALL_ADDR_ADJUST
  end asm
end sub


sub fastcall ks_drawFrame()


asm

  push ix
  exx
  push hl

  call 0xb7bc + _CALL_ADDR_ADJUST + 9 ; _procesarSprites
  call 0xb8fb + _CALL_ADDR_ADJUST + 9; _procesarDots
  call 0xb95e + _CALL_ADDR_ADJUST + 10 ; _procesarFrame

  pop hl
  exx
  pop ix

end asm



end sub



sub fastcall ks_playSFX(id as ubyte)
  asm
    call 0xb04a + _CALL_ADDR_ADJUST ; _stdsound
  end asm
end sub



sub fastcall ks_clearKeys()
  asm
    call 0xb259 + _CALL_ADDR_ADJUST ; cclearkeys
  end asm
end sub



sub fastcall ks_redefineKey(selkey as ubyte)
  asm
    call 0xb262 + _CALL_ADDR_ADJUST ; rredefinekey
  end asm
end sub




sub fastcall ks_syncWait(skip as ubyte)  ' también procesa el teclado...

  asm
    call 0xb4f6 + _CALL_ADDR_ADJUST ; syncwait

  end asm

end sub




sub ks_printTile(posx as ubyte, posy as ubyte, tilenum as ubyte, xormode as ubyte)

      pk_printtileinputx = posx
      pk_printtileinputy = posy
      pk_printtileinputn = tilenum
      pk_collisionresult = xormode

  asm

    call 0xb50c + _CALL_ADDR_ADJUST ;  _printtile
  end asm
end sub







function kf_collisionWithBlock (sprnum as ubyte, side as ubyte) as ubyte

pk_collisioninput = side
pk_collisionsprx = kv_spritedefs(sprnum+1)
pk_collisionspry = kv_spritedefs(sprnum+2)
pk_collisionresult = 0


asm

  call 0xb647 + _CALL_ADDR_ADJUST + 9;  _collisionwithblock

end asm

  return pk_collisionresult

end function







' Funciones mixtas




function kf_collisionWithDot(affinity as ubyte, sprnum as ubyte) as ubyte

  pk_collisioninput = affinity
  pk_collisionresult = 0xff
  pk_collisionsprx = kv_spritedefs(sprnum+1)
  pk_collisionspry = kv_spritedefs(sprnum+2)

  asm
    call 0xb595 + _CALL_ADDR_ADJUST + 4 ;  _collisionwithdot

  end asm

  if (pk_collisionresult < 255) then
    pk_collisionresult = ((8 - pk_collisionresult) <<2)
  end if

  return pk_collisionresult
end function





function kf_collisionWithSprite(affinity as ubyte, sprnum as ubyte) as ubyte

  pk_collisionsprx = kv_spritedefs(sprnum+1)
  pk_collisionspry = kv_spritedefs(sprnum+2)
  pk_collisionresult = sprnum >> 2
  pk_collisioninput = affinity

  asm
  
  call 0xb54a + _CALL_ADDR_ADJUST ; _collisionwithsprite

  end asm
  
  if (pk_collisionresult < 255) then
    pk_collisionresult = ((8 - pk_collisionresult) <<2)
  end if

  return pk_collisionresult
end function








' Funciones que habrá que revisar por si "asmificamos"


sub ks_setCrunchedAttr(posx as ubyte, posy as ubyte, value as ubyte)

  posx = posx >> 2
  posy = posy >> 2

  dim uefectiva as uinteger =  KC_DIR_ATTRIB_BUFFER + ((cast(uinteger, posy )<< 4)       +  cast(uinteger, (posx >> 1))  )
  dim befectivo as ubyte = peek(uefectiva)

  if (posx band 0x01) then

    poke (uefectiva, (befectivo band 0xf8) bor (value) )
    '_collisionresult = (_collisionresult band 0x7)
  else
    '_collisionresult = (_collisionresult >> 3)
    poke (uefectiva, (befectivo band 0xc7) bor (value<<3) )
  end if


end sub


function kf_getCrunchedAttr(posx as ubyte, posy as ubyte) as ubyte

  posx = posx >> 2
  posy = posy >> 2

  pk_collisionresult =  peek   ( KC_DIR_ATTRIB_BUFFER + ((cast(uinteger, posy )<< 4)       +  cast(uinteger, (posx >> 1))  ))

  if (posx band 0x01) then
    pk_collisionresult = (pk_collisionresult band 0x7)
  else
    pk_collisionresult = (pk_collisionresult >> 3)
  end if

  return pk_collisionresult
end function




sub ks_dumpCrunchedAttr(posx as ubyte, posy as ubyte)

  dim befectivo as ubyte =  kf_getCrunchedAttr(posx,posy)

  posx = posx >> 2
  posy = posy >> 2

  dim uefectiva as uinteger = KC_MEMORY_VIDEO_ATTRIBS + (cast(uinteger, posy )<< 5)  +  cast(uinteger, posx)
  poke(uefectiva, (peek(uefectiva) band 0xf8) +  befectivo )
end sub








sub fastcall ks_clearItems()
  asm
    call 0xb000 + _CALL_ADDR_ADJUST + 19
  end asm
end sub


sub fastcall ks_flush()
  asm
    push ix
    call 0xb000 + _CALL_ADDR_ADJUST + 19
    call 0xb95e + _CALL_ADDR_ADJUST + 10 ; _procesarFrame
    pop ix
  end asm
end sub

function kf_coordsToBufferIndex(posx as ubyte, posy as ubyte) as uinteger
  return (cast(uinteger,(posy band 0xfc))<<3) + (cast(uinteger, posx)>>2)
end function

sub fastcall ks_curtain(color as ubyte)
  asm
    ld b, 88
    ld hl, _MEMORY_VIDEO_ATTRIBS
    call 0xb149 + _CALL_ADDR_ADJUST ; setmem
  end asm
end sub











' añadido 1 enero...





sub ks_decodeScreenStepByStep(room as ubyte, pass as ubyte)

  pk_maproomselector = room
  pk_maploadpass = pass

  asm
  push ix

    call 0xb27d + _CALL_ADDR_ADJUST ; _ddecodificarpantalla
    ;call  _ddecodificarpantalla


  pop ix
  end asm

end sub


sub fastcall ks_crunchAttribs()
  asm
    push ix

      call  0xb6f4 + _CALL_ADDR_ADJUST + 9; _crunchAttribs
      ;call   _crunchAttribs

    pop ix
  end asm
end sub



sub fastcall ks_dumpRaster()
  asm
    push ix
    
      call 0xbab5 + _CALL_ADDR_ADJUST + 10 ; _volcarrastermapa
      ;call  _volcarrastermapa

    pop ix
  end asm
end sub


sub fastcall ks_dumpAttribs()
  asm

    ld hl, _DIR_MAP_DECODE_BUFFER
    ld de, _MEMORY_VIDEO_ATTRIBS
    ld bc, 704
    ldir

  end asm
end sub


asm
; Definiciones para ASM

  KC_DOTDEFS_DIR equ _DOT_LIST
  KC_SPRITEDEFS_DIR equ _SPR_LIST

end asm



sub ks_genericSound(pitch as ubyte, time as ubyte)

  pk_printtileinputx = pitch
  pk_printtileinputy = time

  asm
; b -> tono ... sin especificar, la verdad
; c -> duracion ... sin especificar

  ld a,[_INPUT_PRINT_TILE_X]
  ld b,a
  ld a,[_INPUT_PRINT_TILE_Y]
  ld c,a

    call 0xb000 + _CALL_ADDR_ADJUST + 28

  end asm

end sub










'-------------











asm


 ; Definiciones ASM




 _DIR_BUFFERS equ 0xa000 + _BUFFER_ADDR_ADJUST ; de momento...     Tamano total 3112  (restan 984)


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



  _DIR_MAP_DECODE_BUFFER equ _DOT_LIST + 32 ; 704  ; desde 0xb808
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
  DECODIFICAR_PASADA equ _GLOBAL_VARS + 48
  DECODE_ATTRIB_CUSTOMFLAG equ _GLOBAL_VARS + 49
  DECODE_TILE equ _GLOBAL_VARS + 50
  DECODE_ATTRIB equ _GLOBAL_VARS + 51
  DECODE_DATA equ _GLOBAL_VARS + 52


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











end asm



