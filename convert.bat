   @echo off
   for %%f in (*.aac) do (
       ffmpeg -i "%%f" "%%~nf.wav"
   )
   echo Done!
   pause