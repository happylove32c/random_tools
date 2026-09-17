@echo off
cls

:START
echo ================================
echo   FOLDER CAT TOOL
echo ================================
echo.

set /p INPUT="Paste folder or zip path: "

if not exist "%INPUT%" (
    echo Error: path not found: %INPUT%
    pause
    goto END
)

set TMPDIR=%TEMP%\zipcat_%RANDOM%
mkdir "%TMPDIR%"

echo %INPUT% | findstr /i "\.zip$" >nul
if errorlevel 1 (
    rem It's a folder
    for %%F in ("%INPUT%") do set INPUTNAME=%%~nxF
    echo.
    echo Copying folder (excluding junk)...
    echo.
    powershell -command ^
        "Get-ChildItem -Path '%INPUT%' -Recurse | Where-Object { $_.FullName -notmatch 'node_modules|\.git|\.next|dist|build' } | ForEach-Object { $rel = $_.FullName.Substring('%INPUT%'.Length + 1); if (-not $_.PSIsContainer) { $dest = Join-Path '%TMPDIR%' $rel; $dir = Split-Path $dest; if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }; Copy-Item $_.FullName $dest } }"
    set ISZIP=0
) else (
    rem It's a zip
    for %%F in ("%INPUT%") do set INPUTNAME=%%~nF
    echo.
    echo Extracting zip (excluding junk)...
    echo.
    powershell -command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%INPUT%', '%TMPDIR%')"
    set ISZIP=1
)

for /f %%T in ('powershell -command "[int][double]::Parse((Get-Date -UFormat %%s))"') do set EPOCH=%%T
for /f "tokens=1-3 delims=/ " %%A in ("%date%") do set DATESTR=%%C%%B%%A
for /f "tokens=1-3 delims=:." %%A in ("%time%") do (
    set HH=%%A
    set MIN=%%B
    set SEC=%%C
)
set HH=%HH: =0%
set TIMESTAMP=%DATESTR%_%HH%%MIN%%SEC%_%EPOCH%s

echo.
echo Catting files...
echo.

set OUTTEMP=%TEMP%\zipcat_out_%RANDOM%.txt
type nul > "%OUTTEMP%"

for /r "%TMPDIR%" %%F in (*) do (
    echo %%F | findstr /i "node_modules .git .next dist build" >nul
    if errorlevel 1 (
        echo ===== %%~nxF ===== >> "%OUTTEMP%"
        type "%%F" >> "%OUTTEMP%"
        echo. >> "%OUTTEMP%"
    )
)

echo Done.
echo.

set /p SAVEDIR="Where do you want to save the output? Paste folder path: "

if not exist "%SAVEDIR%" (
    echo Error: directory not found: %SAVEDIR%
    rmdir /s /q "%TMPDIR%"
    pause
    goto END
)

copy "%OUTTEMP%" "%SAVEDIR%\%INPUTNAME%_cat_%TIMESTAMP%.txt"
del "%OUTTEMP%"
rmdir /s /q "%TMPDIR%"

echo.
if "%ISZIP%"=="0" (
    set /p KEEPZIP="Want to save a zip of this folder? [y/N]: "
    if /i "%KEEPZIP%"=="y" (
        set TMPZIP=%TEMP%\zipcat_%RANDOM%.zip
        powershell -command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::CreateFromDirectory('%TMPDIR%', '%TMPZIP%')"
        copy "%TMPZIP%" "%SAVEDIR%\%INPUTNAME%_%TIMESTAMP%.zip"
        del "%TMPZIP%" 2>nul
        echo Zip saved to: %SAVEDIR%\%INPUTNAME%_%TIMESTAMP%.zip
    )
) else (
    set /p KEEPZIP="Keep the original zip copy? [y/N]: "
    if /i "%KEEPZIP%"=="y" (
        copy "%INPUT%" "%SAVEDIR%\%INPUTNAME%_%TIMESTAMP%.zip"
        echo Zip saved to: %SAVEDIR%\%INPUTNAME%_%TIMESTAMP%.zip
    )
)

echo.
echo Saved to: %SAVEDIR%\%INPUTNAME%_cat_%TIMESTAMP%.txt
echo.

set /p AGAIN="Process another? [y/N]: "
if /i "%AGAIN%"=="y" (
    echo.
    goto START
)

:END
echo.
echo Bye.
pause