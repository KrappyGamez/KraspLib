



zxbc.exe -ta -S %1 -H 128 -I C:\boriel\zxbasic\krasplib --explicit --strict -O2 --append-binary C:\boriel\zxbasic\krasplib\krasplib.bin --append-binary map.bin --append-binary tileset.bin --append-binary tsattr.bin --append-binary sprites.bin -o main.tap %2.bas

copy /Y /B loader.tap + /B main.tap %2.tap /B

del main.tap


