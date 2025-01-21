' (C) KrappyGamez 2025 bajo licencia MIT
#include "krasplib.bas"

' Global vars

dim ticker as ubyte = 0
dim playerlives, maproom as ubyte
dim playerhinertia,  playerfacing , playervinertia, playerimmune as ubyte
dim passkey as ubyte
dim chkposx, chkposy, chkroom as ubyte  ' For "checkpoint"
dim enemdata(7) as ubyte

' Subs and functions

sub init()
  ink 7
  ks_kraspInit()
  kv_spraddr = 60160   ' Make sure these values match the loader. Also pay attention to the enty point for compiling
  kv_mapaddr = 49152
  kv_tilesetaddr = 63232
  kv_tilesetattraddr = 65280
end sub


' Moving platforms notices:
' Affinity is set in order not to be detected as enemy
' Not recommentd to let them reach solid blocks: use limiters (value 60) if needed
' Also, DO NOT LET PLATFORMS REACH THE EDGES!!

sub setVPlatform(posx as ubyte, posy as ubyte) ' Moving platform, sprite number 8
  kv_spritedefs(28) = KC_ELEMENT_ENABLED + KC_AFFINITY_1
  kv_spritedefs(29) = posx
  kv_spritedefs(30) = posy
  enemdata(7) = ticker band 1
  ticker = ticker + 1
end sub

sub setHPlatform(posx as ubyte, posy as ubyte) ' Moving platform, sprite number 7
  kv_spritedefs(24) = KC_ELEMENT_ENABLED + KC_AFFINITY_1
  kv_spritedefs(25) = posx
  kv_spritedefs(26) = posy
  enemdata(6) = ticker band 1
  ticker = ticker + 1
end sub

function playerOnHPlatform() as ubyte ' Returns a "solid block" hit if on a horizontal platform
  dim result, playerposx, playerposy  as ubyte
  result = 0
  playerposx = kv_spritedefs(1) + 8
  playerposy = kv_spritedefs(2) + 8
  if (kv_spritedefs(24)) then
    if (playerposy = kv_spritedefs(26)) then
      if ((playerposx>kv_spritedefs(25)) and (playerposx<(kv_spritedefs(25)+16))) then
        result = 0xc0
      end if
    end if
  end if
  return result
end function

function playerOnVPlatform() as ubyte ' Returns a "solid block" hit if on a vertical platform
  dim result, playerposx, playerposy  as ubyte
  result = 0
  playerposx = kv_spritedefs(1) + 8
  playerposy = kv_spritedefs(2) + 10 ' Adjustments needed due to "gravity"
  if (kv_spritedefs(28)) then
    if ((playerposy>kv_spritedefs(30)) and (playerposy<(kv_spritedefs(30)+4))) then
      if ((playerposx>kv_spritedefs(29)) and (playerposx<(kv_spritedefs(29)+16))) then
        result = 0xc0
      end if
    end if
  end if
  return result
end function

sub eraseGeneric(svalue as ubyte, noprint as ubyte) ' To remove elements from the screen / databuffer due to game progress
  dim sloop as uinteger
  dim scx, scy as ubyte
  sloop = 0
  for scy = 0 to 21
    for scx = 0 to 31
      if (kv_databuffer(sloop)=svalue) then
        kv_databuffer(sloop) = 0
        if (not noprint) then
           print at scy,scx;"\{p0}\{i7}\{b0} ";
           ks_setCrunchedAttr(scx <<2, scy<<2, 7)
        end if
      end if
      sloop = sloop + 1
    next
  next
end sub

sub eraseDoor()
  eraseGeneric(193,0)
end sub

sub eraseWater()
  eraseGeneric(65,0)
end sub

sub eraseKey()
  eraseGeneric(63,0)
end sub

sub eraseScada()
  eraseGeneric(62,1)
end sub

sub loadRoom() ' Loads the room on global var "maproom"
  ks_flush() ' The screen is cleared from the previos data, if any
  printHud()
  dim sposx, sposy, sval as ubyte
  dim scan as uinteger
  ks_curtain(0) ' Black screen before decoding the raster graphics
  ks_decodeScreen(maproom) ' Alternatively, the decoding can be performed step-by-step (if so, remember to dump the data too!)
  if (passkey > 0) then ' Not very efficient but who cares..
    eraseKey()
    eraseDoor()
  end if
  if (passkey > 1) then
    eraseScada()
    eraseWater()
  end if
  scan = 0 ' Add the enemies and moving platforms
  for sposy = 0 to 84 step 4
    for sposx = 0 to 124 step 4
      sval = kv_databuffer(scan)
        if (sval = 58) then
          print at (sposy>>2),(sposx>>2);"\{f1}\{i2}\{p6}SCADA";
          kv_databuffer(scan) = 0
        end if
        if (sval = 59) then
          print at (sposy>>2),(sposx>>2);"\{f1}\{i1}\{p5}EXIT";
          kv_databuffer(scan) = 0
        end if
        if (sval>0 and sval < 17) then
          kv_databuffer(scan) = 0
          if (sval band 0x08) then ' Atandard enemies and moving platforms
            if (sval band 0x04) then
              if (sval = 0x0f) then ' Vertical
                setVPlatform(sposx,sposy)
              else
                addEnemy(sposx,sposy,(sval band 0x3) + 3)
              end if
            else
              if (sval = 0x0b) then ' Horizontal
                setHPlatform(sposx,sposy)
              else
                addEnemy(sposx,sposy,(sval band 0x3))
              end if
            end if
          else ' Big enemies
            if (sval = 1) then
              addTallEnemy(sposx,sposy)
            end if
            if (sval = 2) then
              addFatEnemy(sposx,sposy)
            end if
          end if
        end if
      scan = scan + 1
    next
  next
end sub


function checkPlayerHit() as ubyte ' To detect a miss but also other events
' Remember: check spikes near non-solid floor as they may be undetected
  dim hitres as byte
  if (playerimmune) then
    playerimmune = playerimmune - 1
    if (playerimmune) then
      return 0
    end if
  end if
  
  hitres = kf_collisionWithBlock(0,KC_COL_BLOCK_CENTER)

  if (hitres = 63) then  ' Key  (clear values of 193)
    passkey = 1
    eraseKey() ' This will work as long as no sprites are over the key. Otherwise, the regular print should be replaced by ks_printTile
    return 2
  end if
    if (hitres = 62) then  ' Scada (clear values of 65)
    passkey = 2
    eraseScada()
    return 3
  end if
  if (hitres = 61) then ' Exit (win the game)
    return 4
  end if

  if ((hitres  band 0xc0)= 0x40) then
    return 1 ' Spikes, loose life
  end if

  if (kf_collisionWithSprite(0, 0) <> 255) then
    return 1 ' Enemy hit, loose life
  end if

  return 0
end function

sub movePlatforms() ' Moves and checks moving platforms if present. Applies movement to the player if needed
' Notice that regular collision detection with the player is not appropriate so it has to be calculated manually (see playerOnVPlatform and playerOnHplatform)
' Also, platforms bounce on any cell with value >0. DON'T LET PLATFORMS REACH THE EDGES, USE "LIMITERS" (value 60) IF NEEDED!!
' V platform
  if (kv_spritedefs(28)) then
    if (enemdata(7)) then
      kv_spritedefs(30) = kv_spritedefs(30) + 1
      if (kf_collisionWithBlock (28, KC_COL_BLOCK_DOWN)) then
        kv_spritedefs(30) = kv_spritedefs(30) - 1
        enemdata(7) = 0
      else
        if (playerOnVPlatform()) then
          kv_spritedefs(2) = kv_spritedefs(30) - 8
        end if
      end if
    else
      kv_spritedefs(30) = kv_spritedefs(30) - 1
      if (kf_collisionWithBlock (28, KC_COL_BLOCK_UP)) then
        kv_spritedefs(30) = kv_spritedefs(30) + 1
        enemdata(7) = 1
      else
        if (playerOnVPlatform()) then
          kv_spritedefs(2) = kv_spritedefs(30) - 8
        end if
      end if
    end if
    kv_spritedefs(31) = 24 + ((ticker>>1) band 1)
  end if

' H platform
  if (kv_spritedefs(24)) then
    if (enemdata(6)) then
      kv_spritedefs(25) = kv_spritedefs(25) + 1
      if (kf_collisionWithBlock (24, KC_COL_BLOCK_RIGHT)) then
        kv_spritedefs(25) = kv_spritedefs(25) - 1
        enemdata(6) = 0
      else
        if (playerOnHPlatform()) then
          kv_spritedefs(1) = kv_spritedefs(1) + 1
        end if
      end if
    else
      kv_spritedefs(25) = kv_spritedefs(25) - 1
      if (kf_collisionWithBlock (24, KC_COL_BLOCK_LEFT)) then
        kv_spritedefs(25) = kv_spritedefs(25) + 1
        enemdata(6) = 1
      else
        if (playerOnHPlatform()) then
          kv_spritedefs(1) = kv_spritedefs(1) - 1
        end if
      end if
    end if
    kv_spritedefs(27) = 24 + ((ticker>>1) band 1)
  end if
end sub

sub moveEnemies() ' As well as platforms, enemies bounce on any cell with value >0. DON'T LET PLATFORMS REACH THE EDGES, USE "LIMITERS" (value 60) IF NEEDED!!
  dim enemindex as ubyte
  dim etyp as ubyte
  dim edat as ubyte
  dim eidx2 as ubyte
  for enemindex = 4 to 20 step 4
    eidx2 = enemindex >> 2
    if (kv_spritedefs(enemindex) and (enemdata(eidx2)<>255)) then
      etyp = enemdata(eidx2) band 0x07
      edat = enemdata(eidx2) band 0xf8
      on etyp goto enem_type_0, enem_type_1, enem_type_2, enem_type_3, enem_type_4, enem_type_5, enem_type_6
      ' Type 7 - fat enemy. This enemy bounces on the edges of the screen and ignore terrain
      kv_spritedefs(enemindex + 3) = 64 + (ticker band 0x4)
      kv_spritedefs(enemindex + 3 + 4) = 65 + (ticker band 0x4)
      kv_spritedefs(enemindex + 3 + 8) = 66 + (ticker band 0x4)
      kv_spritedefs(enemindex + 3 + 12) = 67 + (ticker band 0x4)
      if (edat band 0x08) then
        if (kv_spritedefs(enemindex + 1) > 4) then
          kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) - 1
          kv_spritedefs(enemindex + 1 + 4) = kv_spritedefs(enemindex + 1 + 4) - 1
          kv_spritedefs(enemindex + 1 + 8) = kv_spritedefs(enemindex + 1 + 8) - 1
          kv_spritedefs(enemindex + 1 + 12) = kv_spritedefs(enemindex + 1 + 12) - 1
        else
          edat = edat band 0xf7
        end if
      else
        if (kv_spritedefs(enemindex + 1) < 107) then
          kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) + 1
          kv_spritedefs(enemindex + 1 + 4) = kv_spritedefs(enemindex + 1 + 4) + 1
          kv_spritedefs(enemindex + 1 + 8) = kv_spritedefs(enemindex + 1 + 8) + 1
          kv_spritedefs(enemindex + 1 + 12) = kv_spritedefs(enemindex + 1 + 12) + 1
        else
          edat = edat bor 0x08
        end if
      end if
      if (edat band 0x10) then
        if (kv_spritedefs(enemindex + 2) > 4) then
          kv_spritedefs(enemindex + 2) = kv_spritedefs(enemindex + 2) - 1
          kv_spritedefs(enemindex + 2 + 4) = kv_spritedefs(enemindex + 2 + 4) - 1
          kv_spritedefs(enemindex + 2 + 8) = kv_spritedefs(enemindex + 2 + 8) - 1
          kv_spritedefs(enemindex + 2 + 12) = kv_spritedefs(enemindex + 2 + 12) - 1
        else
          edat = edat band 0xef
        end if
      else
        if (kv_spritedefs(enemindex + 2) < 67) then
          kv_spritedefs(enemindex + 2) = kv_spritedefs(enemindex + 2) + 1
          kv_spritedefs(enemindex + 2 + 4) = kv_spritedefs(enemindex + 2 + 4) + 1
          kv_spritedefs(enemindex + 2 + 8) = kv_spritedefs(enemindex + 2 + 8) + 1
          kv_spritedefs(enemindex + 2 + 12) = kv_spritedefs(enemindex + 2 + 12) + 1
        else
          edat = edat bor 0x10
        end if
      end if
      goto enem_type_f
      enem_type_0: ' Vertical enemies
        kv_spritedefs(enemindex + 3) = 12
      goto enem_type_vertcont
      enem_type_1:
        kv_spritedefs(enemindex + 3) = 14
      goto enem_type_vertcont
      enem_type_2:
        kv_spritedefs(enemindex + 3) = 16
      enem_type_vertcont:
        kv_spritedefs(enemindex + 3) = kv_spritedefs(enemindex + 3) + ((ticker band 0x4)>>2)
        if (edat) then
          kv_spritedefs(enemindex + 2) = kv_spritedefs(enemindex + 2) + 1
          if (kf_collisionWithBlock(enemindex,KC_COL_BLOCK_DOWN)) then
            kv_spritedefs(enemindex + 2) = kv_spritedefs(enemindex + 2) - 1
            edat = 0
          end if
        else
          kv_spritedefs(enemindex + 2) = kv_spritedefs(enemindex + 2) - 1
          if (kf_collisionWithBlock(enemindex,KC_COL_BLOCK_UP)) then
            kv_spritedefs(enemindex + 2) = kv_spritedefs(enemindex + 2) + 1
            edat = 0x08
          end if
        end if
      goto enem_type_f
      enem_type_3: ' Horizontal enemies (except the tall one)
        kv_spritedefs(enemindex + 3) = 32
      goto enem_type_horcont
      enem_type_4:
        kv_spritedefs(enemindex + 3) = 36
      goto enem_type_horcont
      enem_type_5:
        kv_spritedefs(enemindex + 3) = 44
      enem_type_horcont:
        if (edat) then
          kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) + 1
          if (kf_collisionWithBlock(enemindex,KC_COL_BLOCK_RIGHT)) then
            kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) - 1
            edat = 0
          end if
        else
          kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) - 1
          kv_spritedefs(enemindex + 3) = kv_spritedefs(enemindex + 3) + 2
          if (kf_collisionWithBlock(enemindex,KC_COL_BLOCK_LEFT)) then
            kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) + 1
            edat = 0x08
          end if
        end if
        kv_spritedefs(enemindex + 3) = kv_spritedefs(enemindex + 3) + ((ticker band 0x4)>>2)
      goto enem_type_f
      enem_type_6: ' Tall enemy
        kv_spritedefs(enemindex + 3) = 56 + ((ticker band 0x4)>>1)
        kv_spritedefs(enemindex + 7) = 57 + ((ticker band 0x4)>>1)
        if (edat) then
          kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) + 1
          kv_spritedefs(enemindex + 5) = kv_spritedefs(enemindex + 5) + 1
          if (kf_collisionWithBlock(enemindex+4,KC_COL_BLOCK_RIGHT)) then
            kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) - 1
            kv_spritedefs(enemindex + 5) = kv_spritedefs(enemindex + 5) - 1
            edat = 0
          end if
        else
          kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) - 1
          kv_spritedefs(enemindex + 5) = kv_spritedefs(enemindex + 5) - 1
          if (kf_collisionWithBlock(enemindex+4,KC_COL_BLOCK_LEFT)) then
            kv_spritedefs(enemindex + 1) = kv_spritedefs(enemindex + 1) + 1
            kv_spritedefs(enemindex + 5) = kv_spritedefs(enemindex + 5) + 1
            edat = 0x08
          end if
        end if
      enem_type_f:
      enemdata(eidx2) = (enemdata(eidx2) band 0x07) bor edat
    end if
  next
end sub

function playerOnFloor() as ubyte ' Returns block collision data
  dim result as ubyte
  kv_spritedefs(2) = kv_spritedefs(2) + 1
  result = kf_collisionWithBlock (0, KC_COL_BLOCK_DOWN) band 0xc0 ' Lower part removed for enemies / platforms limiters, the key, etc.
  kv_spritedefs(2) = kv_spritedefs(2) - 1
  if (not result) then
    result = playerOnHPlatform()
    if (not result) then
      result = playerOnVPlatform()
    end if
  'else
  '  if ((result band 0x80) and (not playerimmune))then
  '    chkroom = maproom
  '    chkposx = kv_spritedefs(1)
  '    chkposy = kv_spritedefs(2)
  '  end if
  end if
  return result
end function

sub movePlayer() ' This sub is a bit messy with the inertias and so.. sorry for not making it cleaner..
  dim psprite as ubyte
  dim colresult as ubyte
  dim premaproom as ubyte
  dim storeposx, storeposy as ubyte
  if (playervinertia < 2) then
    colresult = playerOnFloor() band 0x80
    if (colresult) then
      if (kv_userinputpulse band KC_MASK_INPUT_UP) then
        ks_playSFX(KC_SFX_SHORT_HIGH_TICK)
        playervinertia = 20
      else
        if (kv_userinputpulse band KC_MASK_INPUT_DOWN) then
          ks_playSFX(KC_SFX_SHORT_HIGH_TICK)
          playervinertia = 12
        else
          playervinertia = 0
        end if
      end if
    else
      if (not playervinertia) then
        playerhinertia = 0
        playervinertia = 1
      end if
    end if
  end if
  if (playerfacing) then
    psprite = 0
  else
    psprite = 4
  end if
  
  if (playervinertia) then
    if (playervinertia > 4) then
      psprite = psprite + 2
      kv_spritedefs(2) = kv_spritedefs(2) - 1
      colresult = kf_collisionWithBlock (0, KC_COL_BLOCK_UP) band 0xc0
      if (colresult = 0xc0) then
        kv_spritedefs(2) = kv_spritedefs(2) + 1
      end if
    end if
    if (playervinertia = 1)
      psprite = psprite + 3
      kv_spritedefs(2) = kv_spritedefs(2) + 1
    end if
    if (playervinertia > 1) then
      playervinertia = playervinertia - 1
    end if
  else
    playerhinertia = 0
    if (kv_userinput band KC_MASK_INPUT_LEFT) then
      playerhinertia = 1
      playerfacing = 0
    end if
    if (kv_userinput band KC_MASK_INPUT_RIGHT) then
      playerhinertia = 1
      playerfacing = 1
    end if
    if (playerhinertia) then
      if (ticker band 0x4) then
        psprite = psprite + 1
      end if
    end if
  end if
  if (playerhinertia) then
    if (playerfacing) then
      kv_spritedefs(1) = kv_spritedefs(1) + 1
      colresult = kf_collisionWithBlock (0, KC_COL_BLOCK_RIGHT) band 0xc0
      if (colresult = 0xc0) then
        kv_spritedefs(1) = kv_spritedefs(1) - 1
        if (playervinertia = 1) then 
          playerhinertia = 0
        end if
      end if
    else
      kv_spritedefs(1) = kv_spritedefs(1) - 1
      colresult = kf_collisionWithBlock (0, KC_COL_BLOCK_LEFT) band 0xc0
      if (colresult = 0xc0) then
        kv_spritedefs(1) = kv_spritedefs(1) + 1
        if (playervinertia = 1) then
          playerhinertia = 0
        end if
      end if
    end if
    if (not playervinertia) then
      colresult = playerOnFloor() band 0xc0
      if (not colresult) then
        playerhinertia = 0
      end if
    end if
  end if

  kv_spritedefs(3) = psprite
  if (playerimmune band 0x02) then
    kv_spritedefs(0) = KC_ELEMENT_ENABLED + KC_ELEMENT_USEATTRIB + 2
  else
    kv_spritedefs(0) = KC_ELEMENT_ENABLED
  end if
  ' Check screen change
  premaproom = maproom
  storeposx = kv_spritedefs(1)
  storeposy = kv_spritedefs(2)
  if (kv_spritedefs(1)<3) then
    premaproom = premaproom - 1
    storeposx = storeposx + 112
  else
    if (kv_spritedefs(1)>116)
      premaproom = premaproom + 1
      storeposx = storeposx - 112
    end if
  end if
  if (kv_spritedefs(2)<3) then
    premaproom = premaproom - 16
    storeposy = storeposy + 72
  else
    if (kv_spritedefs(2)>76)
      premaproom = premaproom + 16
      storeposy = storeposy - 72
    end if
  end if
  if (premaproom <> maproom) then
    maproom = premaproom
    loadRoom()
    kv_spritedefs(1) = storeposx
    kv_spritedefs(2) = storeposy
  end if
end sub

sub showMenu()
  cls
  ks_curtain(0)
  ks_decodeScreen(0)
  ink 7:bright 1: paper 2
  print at 2,1;"KRASPLIB EXAMPLE #2:PLATFORMER";
  print at 6,7;"1 - KEYBOARD";
  print at 8,7;"2 - KEMPSTON";
  print at 10,7;"3 - REDEFINE KEYS";
  print at 19,7;"KRAPPYGAMEZ 2025";
  paper 0
end sub

sub redefineKeys()
  ks_clearKeys()
  print at 13,7;"LEFT";
  ks_redefineKey(KC_SEL_KEY_LEFT)
  ks_playSFX(KC_SFX_SELECT)
  print at 13,7;"RIGHT";
  ks_redefineKey(KC_SEL_KEY_RIGHT)
  ks_playSFX(KC_SFX_SELECT)
  print at 13,7;"HIGH JUMP";
  ks_redefineKey(KC_SEL_KEY_UP)
  ks_playSFX(KC_SFX_SELECT)
  print at 13,7;"LOW JUMP ";
  ks_redefineKey(KC_SEL_KEY_DOWN)
  ks_playSFX(KC_SFX_SELECT)
end sub

sub respawnPlayer()
  ks_syncWait(1)' Clears any pending keystroke
  kv_spritedefs(1) = chkposx
  kv_spritedefs(2) = chkposy
  playerhinertia = 0
  playervinertia = 0
  playerfacing = 1
  playerimmune = 48
end sub

function gameLoop() as ubyte ' Main loop. When terminated returns a value
  dim result as ubyte = 0
  playerloop_init:
  while not result
    movePlayer()
    on checkPlayerHit goto player_hit_f, player_hit_kill, player_hit_pickup, player_hit_pickup , player_hit_exit
    player_hit_kill:
      ks_playSFX(KC_SFX_LOOSE)
      playerlives = playerlives - 1
      if (playerlives) then
        maproom = chkroom
        loadRoom()
        respawnPlayer()
        goto playerloop_init
      else
        result = 1 ' Game over
        goto playerloop_init
      end if
    player_hit_pickup:
      ks_playSFX(KC_SFX_PICK)
      printHud()
      goto player_hit_f
    player_hit_exit:
      result = 2 ' Game won
      goto playerloop_init
    player_hit_f:
    movePlatforms()
    moveEnemies()
    ks_drawFrame()
    ticker = ticker + 1
    kv_spritedefs(2) = kv_spritedefs(2) + 1 ' Checkpoint
    if ((kf_collisionWithBlock (0, KC_COL_BLOCK_DOWN)band 0x80) and (not playerimmune))then
      chkroom = maproom
      chkposx = kv_spritedefs(1)
      chkposy = kv_spritedefs(2) - 1
    end if
    kv_spritedefs(2) = kv_spritedefs(2) - 1
    ks_syncWait(2) ' Max 25 fps.. tipically between 20 and 25
  wend
end function

sub addTallEnemy(posx as ubyte, posy as ubyte) ' Reserved sprites 4 and 5
  kv_spritedefs(16) = KC_ELEMENT_ENABLED + KC_ELEMENT_USEATTRIB + 4 ' Paint this one green
  kv_spritedefs(20) = KC_ELEMENT_ENABLED + KC_ELEMENT_USEATTRIB + 4
  kv_spritedefs(17) = posx
  kv_spritedefs(21) = posx
  kv_spritedefs(18) = posy
  kv_spritedefs(22) = posy + 8
  enemdata(4) = 6 bor ((ticker band 0x01)<<3)
  enemdata(5) = 255
  ticker = ticker + 1
end sub

sub addFatEnemy(posx as ubyte, posy as ubyte) ' Reserved sprites 2 to 5
  kv_spritedefs(8) = KC_ELEMENT_ENABLED
  kv_spritedefs(12) = KC_ELEMENT_ENABLED
  kv_spritedefs(16) = KC_ELEMENT_ENABLED
  kv_spritedefs(20) = KC_ELEMENT_ENABLED
  kv_spritedefs(9) = posx
  kv_spritedefs(13) = posx
  kv_spritedefs(17) = posx + 8
  kv_spritedefs(21) = posx + 8
  kv_spritedefs(10) = posy
  kv_spritedefs(14) = posy + 8
  kv_spritedefs(18) = posy
  kv_spritedefs(22) = posy + 8
  enemdata(2) = 7 bor ((ticker band 0x03)<<3)
  enemdata(3) = 255
  enemdata(4) = 255
  enemdata(5) = 255
  ticker = ticker + 1
end sub

sub addEnemy(posx as ubyte, posy as ubyte, type as ubyte) ' Up to 5 enemies unless a large one is present
  dim scan as ubyte = 4
  type = type bor ((ticker band 0x01)<<3)
  while (scan < 24)
    if (kv_spritedefs(scan)=0) then
      kv_spritedefs(scan) = KC_ELEMENT_ENABLED
      kv_spritedefs(scan + 1) = posx
      kv_spritedefs(scan + 2) = posy
      enemdata(scan >> 2) = type
      scan = 24
    end if
    scan = scan + 4
  wend
  ticker = ticker + 1
end sub

sub printHud()
  print at 23,0; "LIVES:"; playerlives;" ";
  if passkey > 0 then
    print at 22,0;"SCADA ROOM OPEN";
  end if
  if passkey > 1 then
    print at 22,18;"WATER PUMP OFF";
  end if

end sub

sub startGame()
  passkey = 0
  maproom = chkroom
  loadRoom()
  respawnPlayer()
  if (gameLoop()=1) then
    print at 10,11;"\{b1}\{f1}\{p2}\{i6}GAME  OVER";
  else
    print at 10,12;"\{b1}\{f1}\{p1}\{i5}YOU WON!";
  end if
  while not (kv_userinputpulse)
    ks_syncWait(1)
  wend
end sub

function menuLoop() as byte
  dim ik as ubyte
  dim result as ubyte = 1
  while result = 1
    ik = val(inkey$)
    if (ik > 0 and ik<4) then
      ks_playSFX(KC_SFX_SELECT)
    end if
    if ik = 1 then
      kv_usejoystick = 0
      startGame()
      result = 2
    end if
    if ik = 2 then
      kv_usejoystick = 1
      startGame()
      result = 2
    end if
    if ik = 3 then
      redefineKeys()
      result = 2
    end if
  wend
  return result
end function

'---------------------
' Beginning of program
'---------------------

init()
do
 showMenu()
 chkposx = kv_databuffer(66) ' Get initial data from the main map
 chkposy = kv_databuffer(67)
 chkroom = kv_databuffer(65)
 playerlives = kv_databuffer(68)
loop until  menuLoop()= 0 ' Actually, forever











