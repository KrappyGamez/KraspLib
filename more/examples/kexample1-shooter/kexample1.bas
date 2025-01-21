' (C) KrappyGamez 2025 bajo licencia MIT
#include "krasplib.bas"

' Global vars

dim ticker as ubyte
dim enemsdir(7) as ubyte
dim playerdir, playeraffinity, playerlives, round as ubyte


' Subs and functions


sub init()
  ink 7
  ks_kraspInit()
  'Entry point: 24320
  kv_spraddr = 60160     ' Make sure these values match the loader. Also pay attention to the enty point for compiling
  kv_mapaddr = 49152
  kv_tilesetaddr = 63232
  kv_tilesetattraddr = 65280
end sub



sub showMenu()
  cls
  print at 3,3;"KRASPLIB EXAMPLE #1:SHOOTER";
  print at 6,2;"1 - KEYBOARD";
  print at 7,2;"2 - KEMPSTON";
  print at 8,2;"3 - REDEFINE KEYS";
  print at 9,2;"4 - EXIT TO DOS BASIC"; ' Ok, this is just a stupid joke..
  plot 112,112
  draw 23,6
  plot 135,112
  draw -23,6
  print at 11,6;"INSTRUCTIONS:";
  print at 13,1;"SHOOT THE ENEMIES WITH BULLETS";
  print at 14,1;"OF THE SAME COLOR";
  print at 15,1;"TOUCH THE ORBS TO SWITCH THE";
  print at 16,1;"COLOR";
  print at 19,3;"KRAPPYGAMEZ 2025";
end sub


sub redefineKeys()
  cls
  ks_clearKeys()
  print at 6,2;"LEFT";
  ks_redefineKey(KC_SEL_KEY_LEFT)
  ks_playSFX(KC_SFX_SELECT)
  print at 6,2;"RIGHT";
  ks_redefineKey(KC_SEL_KEY_RIGHT)
  ks_playSFX(KC_SFX_SELECT)
  print at 6,2;"UP   ";
  ks_redefineKey(KC_SEL_KEY_UP)
  ks_playSFX(KC_SFX_SELECT)
  print at 6,2;"DOWN";
  ks_redefineKey(KC_SEL_KEY_DOWN)
  ks_playSFX(KC_SFX_SELECT)
  print at 6,2;"FIRE";
  ks_redefineKey(KC_SEL_KEY_ACTION_1)
  ks_playSFX(KC_SFX_SELECT)
end sub


sub addBullet(posx as ubyte, posy as ubyte, affinity as ubyte)
  dim scan as ubyte = 0
  do
    if (kv_dotdefs(scan)=0) then
      if (affinity = KC_AFFINITY_0) then
        kv_dotdefs(scan) = (KC_ELEMENT_ENABLED bor KC_ELEMENT_USEATTRIB bor KC_AFFINITY_0) bor 4 ' Bitwise or the value
      else
        kv_dotdefs(scan) = (KC_ELEMENT_ENABLED bor KC_ELEMENT_USEATTRIB + KC_AFFINITY_1) + 6  ' Addition works as well
      end if
      kv_dotdefs(scan + 1) = posx
      kv_dotdefs(scan + 2) = posy
      kv_dotdefs(scan + 3) = playerdir ' This position is user defined, not used by krasplib
      ks_playSFX(KC_SFX_SHORT_LOW_TICK)
      scan = 32
    else
      scan = scan + 4
    end if
  loop until scan > 31
end sub


function checkEnemiesKilled() as ubyte
  dim scan as ubyte
  for scan = 4 to 28 step 4
    if (kv_spritedefs(scan)) then
      return 0
    end if
  next
  return 1
end function


sub moveBullets()
  dim scan as ubyte
  dim bullx, bully as ubyte
  for scan = 0 to 28 step 4
    if (kv_dotdefs(scan)) then
      bullx = kv_dotdefs(scan + 1)
      bully = kv_dotdefs(scan + 2)
      on kv_dotdefs(scan + 3) goto mvb_0, mvb_1, mvb_2, mvb_3, mvb_4, mvb_5, mvb_6, mvb_7
        kv_dotdefs(scan) = 0
        ks_printTile(bullx>>2,bully>>2,35,1)
      goto mvb_f
      mvb_0:
        bully = bully - 4
      goto mvb_f
      mvb_1:
        bullx = bullx + 4
        bully = bully - 4
      goto mvb_f
      mvb_2:
        bullx = bullx + 4
      goto mvb_f
      mvb_3:
        bullx = bullx + 4
        bully = bully + 4
      goto mvb_f
      mvb_4:
        bully = bully + 4
      goto mvb_f
      mvb_5:
        bullx = bullx - 4
        bully = bully + 4
      goto mvb_f
      mvb_6:
        bullx = bullx - 4
      goto mvb_f
      mvb_7:
        bullx = bullx - 4
        bully = bully - 4
      mvb_f:
      ' No specific block collision detection for bullets, but it's easy to do directly reading the data buffer
      if (kv_databuffer( ((cast(uinteger,bully) band 0x7c)<<3) +  (cast(uinteger,bullx) >> 2)  ) > 63) then
      ' if (kv_databuffer(kf_coordsToBufferIndex(bullx, bully)) ) ' Alternate bus slower code
        kv_dotdefs(scan + 3) = 8
        kv_dotdefs(scan) = kv_dotdefs(scan) bor KC_AFFINITY_3
        ks_playSFX(KC_SFX_SHORT_HIGH_TICK)
        ks_printTile(kv_dotdefs(scan + 1)>>2,kv_dotdefs(scan + 2)>>2,35,1)
      else
          kv_dotdefs(scan + 1) = bullx
          kv_dotdefs(scan + 2) = bully
      end if
    end if
  next
end sub


function checkEnemyHit(enemindex as ubyte) as ubyte
  ' Detects hits only if the enemy's affiniti matches the bullet's affinity. The mask is used to isolate the enemy's affinity
  return kf_collisionWithDot( kv_spritedefs(enemindex) band KC_AFFINITY_MASK , enemindex)
end function


function checkPlayerHit() as ubyte
 ' Detects collision with any enemy, regardless of the affinity. Notice the "source" sprite (the player in this context) is ignored to prevent "self-collisions"
 return ( (kf_collisionWithSprite(KC_AFFINITY_0, 0) bxor 255) bor (kf_collisionWithSprite(KC_AFFINITY_1, 0) bxor 255))
end function


sub moveEnemies() ' I guess there is room for optimization here...
  dim scan as ubyte
  dim enemd as ubyte
  dim enemnum as ubyte
  dim enemhit as ubyte
  for scan = 4 to 28 step 4  ' Krasplib uses the index on the array, and each block is 4 bytes long
    if (kv_spritedefs(scan)) then
      enemnum = (scan>>2) - 1 ' Ordinal number of the enemy (beginning at 0)
      enemd = enemsdir(enemnum)
      if (enemd<8) then
        if (enemd band 4) then
          if (enemd band 1) then
            kv_spritedefs(scan + 1) = kv_spritedefs(scan + 1) - 1
            if (kv_spritedefs(scan + 1) < 1) then
              kv_spritedefs(scan + 1) = kv_spritedefs(scan + 1) + 1
              enemd = enemd bxor 1
            end if
          else
            kv_spritedefs(scan + 1) = kv_spritedefs(scan + 1) + 1
            if (kv_spritedefs(scan + 1) > 118) then
              kv_spritedefs(scan + 1) = kv_spritedefs(scan + 1) - 1
              enemd = enemd bxor 1
            end if
          end if
          if (enemd band 2) then
            kv_spritedefs(scan + 2) = kv_spritedefs(scan + 2) - 1
            if (kv_spritedefs(scan + 2) < 1) then
              kv_spritedefs(scan + 2) = kv_spritedefs(scan + 2) + 1
              enemd = enemd bxor 2
            end if
          else
            kv_spritedefs(scan + 2) = kv_spritedefs(scan + 2) + 1
            if (kv_spritedefs(scan + 2) > 78) then
              kv_spritedefs(scan + 2) = kv_spritedefs(scan + 2) - 1
              enemd = enemd bxor 2
            end if
          end if
        else
          if (enemd band 1) then
            kv_spritedefs(scan + 1) = kv_spritedefs(scan + 1) - 1
            if ((kf_collisionWithBlock(scan, KC_COL_BLOCK_LEFT)>63)) then
              kv_spritedefs(scan + 1) = kv_spritedefs(scan + 1) + 1
              enemd = enemd bxor 1
            end if
          else
            kv_spritedefs(scan + 1) = kv_spritedefs(scan + 1) + 1
            if ((kf_collisionWithBlock(scan, KC_COL_BLOCK_RIGHT)>63)) then
              kv_spritedefs(scan + 1) = kv_spritedefs(scan + 1) - 1
              enemd = enemd bxor 1
            end if
          end if
          if (enemd band 2) then
            kv_spritedefs(scan + 2) = kv_spritedefs(scan + 2) - 1
            if ((kf_collisionWithBlock(scan, KC_COL_BLOCK_UP)>63)) then
              kv_spritedefs(scan + 2) = kv_spritedefs(scan + 2) + 1
              enemd = enemd bxor 2
            end if
          else
            kv_spritedefs(scan + 2) = kv_spritedefs(scan + 2) + 1
            if ((kf_collisionWithBlock(scan, KC_COL_BLOCK_DOWN)>63)) then
              kv_spritedefs(scan + 2) = kv_spritedefs(scan + 2) - 1
              enemd = enemd bxor 2
            end if
          end if
        end if
        kv_spritedefs(scan + 3) = (kv_spritedefs(scan + 3) band 0xfe) bor ((ticker >> 2) band 1)
        enemsdir(enemnum) = enemd
        enemhit = checkEnemyHit(scan)
        if (enemhit < 255) then
          kv_dotdefs(enemhit) = 0
          enemsdir(enemnum) = 8
        end if
      else
        enemsdir(enemnum) = enemd +1
        if (enemd = 8) then
        ks_playSFX(KC_SFX_HIT)
        kv_spritedefs(scan) = (kv_spritedefs(scan) band (KC_ELEMENT_ENABLED bor KC_ELEMENT_USEATTRIB) ) bor KC_AFFINITY_2 bor 3
        kv_spritedefs(scan + 3) = 12
        else
          if (enemd = 9) then
          kv_spritedefs(scan + 3) = 13
          else
            enemsdir(enemnum) = 0
            kv_spritedefs(scan) = 0
          end if
        end if
      end if
    end if
  next
end sub


sub movePlayer()
  dim tempdirv as ubyte = 0
  dim tempdirh as ubyte = 0
  if ((ticker band 1) or (kf_collisionWithBlock(0, KC_COL_BLOCK_CENTER)<>32)) then
    if (kv_userinput band KC_MASK_INPUT_UP) then
      tempdirv = 1
      kv_spritedefs(2) = kv_spritedefs(2) - 1
      if ((kf_collisionWithBlock(0, KC_COL_BLOCK_UP)>63)) then  ' We could use KC_COL_BLOCK_CENTER but this is slightly faster
        kv_spritedefs(2) = kv_spritedefs(2) + 1
      end if
    else
      if (kv_userinput band KC_MASK_INPUT_DOWN) then
        tempdirv = 2
        kv_spritedefs(2) = kv_spritedefs(2) + 1
        if ((kf_collisionWithBlock(0, KC_COL_BLOCK_DOWN)>63)) then
          kv_spritedefs(2) = kv_spritedefs(2) - 1
        end if
      end if
    end if
    if (kv_userinput band KC_MASK_INPUT_LEFT) then
      tempdirh = 1
      kv_spritedefs(1) = kv_spritedefs(1) - 1
      if ((kf_collisionWithBlock(0, KC_COL_BLOCK_LEFT)>63)) then
        kv_spritedefs(1) = kv_spritedefs(1) + 1
      end if
    else
      if (kv_userinput band KC_MASK_INPUT_RIGHT) then
        tempdirh = 2
        kv_spritedefs(1) = kv_spritedefs(1) + 1
        if ((kf_collisionWithBlock(0, KC_COL_BLOCK_RIGHT)>63)) then
          kv_spritedefs(1) = kv_spritedefs(1) - 1
        end if
      end if
    end if
  end if
  if (tempdirv bor tempdirh) then
    if (tempdirv = 0) then
      if (tempdirh = 1) then
        playerdir = 6
      else
        playerdir = 2
      end if
    else
      if (tempdirv = 1) then
        if (tempdirh = 0) then
          playerdir = 0
        else
          if (tempdirh = 1) then
            playerdir = 7
          else
            playerdir = 1
          end if
        end if
      else
        if (tempdirh = 0) then
          playerdir = 4
        else
          if (tempdirh = 1) then
            playerdir = 5
          else
            playerdir = 3
          end if
        end if
      end if
    end if
    kv_spritedefs(3) = playerdir
  end if
  if (kv_userinputpulse band KC_MASK_INPUT_ACTION_1) then
    addBullet(kv_spritedefs(1) + 3 + (ticker band 1),kv_spritedefs(2) + 3 + ((ticker >> 1) band 1), playeraffinity)
  end if
end sub


function gameLoop() as ubyte
  dim result as ubyte = 0
  dim affchange as ubyte
  while not result
    if (playerdir <8) then
      movePlayer()
      if (checkPlayerHit()) then
        playerdir = 10
        ks_playSFX(KC_SFX_LOOSE)
      end if
    else
      playerdir = playerdir + 1
      kv_spritedefs(3) = 12 bor (playerdir band 1)
      if (playerdir > 22) then
        result = 2
        playerlives = playerlives - 1
      end if
    end if
    moveBullets()
    moveEnemies()

    affchange = kf_collisionWithBlock(0,KC_COL_BLOCK_CENTER)
    if (affchange=31) then ' green, aff 0
      if (playeraffinity <> KC_AFFINITY_1) then
        playeraffinity = KC_AFFINITY_1
        ks_playSFX(KC_SFX_PICK)
      end if
    else
      if (affchange=30) then ' yellow, aff 1
        if (playeraffinity <> KC_AFFINITY_0) then
          playeraffinity = KC_AFFINITY_0
          ks_playSFX(KC_SFX_PICK)
        end if
      end if
    end if
    ks_drawFrame()
    ks_syncWait(3)
    ticker = ticker + 1
    
    if (checkEnemiesKilled()) then
      result = 1
      round = round + 1
      ks_playSFX(KC_SFX_SELECT)
    end if
  wend
end function


sub addEnemy(posx as ubyte, posy as ubyte, posm as ubyte, affinity as ubyte, attr as ubyte)
  dim scan as ubyte = 4
  while (scan < 32)
    if (kv_spritedefs(scan)=0) then
      kv_spritedefs(scan) = (KC_ELEMENT_ENABLED bor KC_ELEMENT_USEATTRIB) bor (affinity bor attr)
      kv_spritedefs(scan + 1) = posx
      kv_spritedefs(scan + 2) = posy
      if (posm band 4) then
        kv_spritedefs(scan + 3) = 8
      else
        kv_spritedefs(scan + 3) = 10
      end if
      enemsdir((scan >>2) -1) = posm
      scan = 32
    end if
    scan = scan + 4
  wend
end sub


sub printHud()
  print at 23,0; "LIVES:"; playerlives; "   ROUND:"; round;
end sub


sub startRound(round as ubyte)
  ks_flush() ' The screen is cleared from the previos data, if any
  printHud()
  dim scan as uinteger
  dim sbyte as ubyte
  dim sposx, sposy as ubyte
  dim sposm, saffinity as ubyte
  dim sattr as ubyte
  ks_curtain(0) ' Black screen before decoding the raster graphics
  ks_decodeScreen(round)
  for scan = 0 to 703  ' Now we decode the specific data (player an enemy positions)
    sbyte = kv_databuffer(scan)
    sposx = ((cast(ubyte,(scan))<<2) band 0x7c)
    sposy = ((cast(ubyte,(scan>>3))) band 0x7c)
    if (sbyte = 29) then
      kv_spritedefs(1) = sposx
      kv_spritedefs(2) = sposy
    end if
    if (sbyte >0 and sbyte < 17) then
      sbyte = sbyte - 1
      sposm = sbyte band 0x7

      if (sbyte band 8) then
        saffinity = KC_AFFINITY_0
        sattr = 4
      else
        saffinity = KC_AFFINITY_1
        sattr = 6
      end if
      addEnemy(sposx, sposy, sposm, saffinity, sattr)
    end if
  next
  kv_spritedefs(0) = KC_ELEMENT_ENABLED
  playerdir = 0
  playeraffinity = KC_AFFINITY_0
end sub


sub startGame()
  playerlives = 3
  round = 0
  startRound(0)
  while gameLoop()
    if (round < 4) then  ' This is just an example, unly four rounds
      if (playerlives > 0) then
        startRound(round)
      else
        print at 10,10;"GAME OVER";
        ks_syncWait(0)   ' Tick to make a small pause (about 2.5 seconds)
        ks_syncWait(128)
        return
      end if
    else
      print at 10,10;"GAME COMLETED";
      ks_syncWait(0)
      ks_syncWait(128)
      return
    end if
  wend
end sub


function menuLoop() as byte
  dim ik as ubyte
  dim result as ubyte = 1
  while result = 1
    ik = val(inkey$)
    if (ik > 0) then
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
    if ik = 4 then
      result = 0
    end if
  wend
  return result
end function


' Begining of program

init()
do
showMenu()
loop until  menuLoop()= 0







