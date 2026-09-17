@echo off
cls
echo ================================
echo   FOLDER CAT TOOL
echo ================================
echo.

set /p FOLDER="Paste folder path: "

if not exist "%FOLDER%" (
    echo Error: folder not found: %FOLDER%
    pause
    exit /b 1
)

for %%F in ("%FOLDER%") do set FOLDERNAME=%%~nxF

for /f %%T in ('powershell -command "[int][double]::Parse((Get-Date -UFormat %%s))"') do set EPOCH=%%T
for /f "tokens=1-3 delims=/ " %%A in ("%date%") do set DATESTR=%%C%%B%%A
for /f "tokens=1-3 delims=:." %%A in ("%time%") do (
    set HH=%%A
    set MIN=%%B
    set SEC=%%C
)
set HH=%HH: =0%
set TIMESTAMP=%DATESTR%_%HH%%MIN%%SEC%_%EPOCH%s

set TMPZIP=%TEMP%\zipcat_%RANDOM%.zip
set TMPDIR=%TEMP%\zipcat_%RANDOM%
mkdir "%TMPDIR%"

echo.
echo Zipping folder (excluding junk)...
echo.

powershell -command ^
    "Get-ChildItem -Path '%FOLDER%' -Recurse | Where-Object { $_.FullName -notmatch 'node_modules|\.git|\.next|dist|build' } | ForEach-Object { $rel = $_.FullName.Substring('%FOLDER%'.Length + 1); if (-not $_.PSIsContainer) { $dest = Join-Path '%TMPDIR%' $rel; $dir = Split-Path $dest; if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }; Copy-Item $_.FullName $dest } }"

powershell -command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::CreateFromDirectory('%TMPDIR%', '%TMPZIP%')"

echo.
echo Catting files...
echo.

set OUTTEMP=%TEMP%\zipcat_out_%RANDOM%.txt
type nul > "%OUTTEMP%"

for /r "%TMPDIR%" %%F in (*) do (
    echo ===== %%~nxF ===== >> "%OUTTEMP%"
    type "%%F" >> "%OUTTEMP%"
    echo. >> "%OUTTEMP%"
)

echo Done.
echo.

set /p SAVEDIR="Where do you want to save the output? Paste folder path: "

if not exist "%SAVEDIR%" (
    echo Error: directory not found: %SAVEDIR%
    rmdir /s /q "%TMPDIR%"
    del "%TMPZIP%"
    pause
    exit /b 1
)

copy "%OUTTEMP%" "%SAVEDIR%\%FOLDERNAME%_cat_%TIMESTAMP%.txt"
del "%OUTTEMP%"
rmdir /s /q "%TMPDIR%"

echo.
set /p KEEPZIP="Keep the zip? [y/N]: "
if /i "%KEEPZIP%"=="y" (
    copy "%TMPZIP%" "%SAVEDIR%\%FOLDERNAME%_%TIMESTAMP%.zip"
    echo Zip saved to: %SAVEDIR%\%FOLDERNAME%_%TIMESTAMP%.zip
) else (
    echo Zip discarded.
)

del "%TMPZIP%" 2>nul

echo.
echo Saved to: %SAVEDIR%\%FOLDERNAME%_cat_%TIMESTAMP%.txt
echo.
pause