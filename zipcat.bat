@echo off
cls
echo ================================
echo   ZIP CAT TOOL
echo ================================
echo.

set /p ZIP="Paste zip file path: "

if not exist "%ZIP%" (
    echo Error: file not found: %ZIP%
    pause
    exit /b 1
)

for %%F in ("%ZIP%") do set ZIPNAME=%%~nF

set TMPDIR=%TEMP%\zipcat_%RANDOM%
mkdir "%TMPDIR%"

echo.
echo Reading files...
echo.

powershell -command "Expand-Archive -Path '%ZIP%' -DestinationPath '%TMPDIR%'"

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

set /p SAVEDIR="Where do you want to save the file? Paste folder path: "

if not exist "%SAVEDIR%" (
    echo Error: directory not found: %SAVEDIR%
    rmdir /s /q "%TMPDIR%"
    pause
    exit /b 1
)

copy "%OUTTEMP%" "%SAVEDIR%\%ZIPNAME%_cat.txt"
rmdir /s /q "%TMPDIR%"
del "%OUTTEMP%"

echo.
echo Saved to: %SAVEDIR%\%ZIPNAME%_cat.txt
echo.
pause