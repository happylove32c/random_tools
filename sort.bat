@echo off
setlocal EnableDelayedExpansion

REM ==========================================================
REM RANDOM TOOLS — SORT
REM ==========================================================

title Random Tools - Sort
chcp 65001 >nul
color 07

for /F "delims=" %%A in ('echo prompt $E^| cmd') do set "ESC=%%A"

cls

echo.
echo %ESC%[96m╔══════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m║              RANDOM TOOLS — SORT                ║%ESC%[0m
echo %ESC%[96m╚══════════════════════════════════════════════════╝%ESC%[0m
echo.
echo %ESC%[90m  Scanning this directory...%ESC%[0m
echo.

REM ==========================================================
REM PROJECT FOLDERS
REM ==========================================================

for /d %%D in (*) do (

    set "PROJECT=%%~nxD"
    set "SOURCE=%%~fD"
    set "TYPE="

    REM ------------------------------------------------------
    REM Never touch the sorter or its destination folders
    REM ------------------------------------------------------

    if /I "!PROJECT!"=="sort.bat" set "TYPE=SKIP"

    if /I "!PROJECT!"=="React" set "TYPE=SKIP"
    if /I "!PROJECT!"=="Next" set "TYPE=SKIP"
    if /I "!PROJECT!"=="Flutter" set "TYPE=SKIP"
    if /I "!PROJECT!"=="Vanilla HTML" set "TYPE=SKIP"

    if /I "!PROJECT!"=="TXT" set "TYPE=SKIP"
    if /I "!PROJECT!"=="DOCX" set "TYPE=SKIP"
    if /I "!PROJECT!"=="JSON" set "TYPE=SKIP"
    if /I "!PROJECT!"=="XLSX" set "TYPE=SKIP"
    if /I "!PROJECT!"=="CSV" set "TYPE=SKIP"
    if /I "!PROJECT!"=="IMG" set "TYPE=SKIP"
    if /I "!PROJECT!"=="ZIP" set "TYPE=SKIP"
    if /I "!PROJECT!"=="Others" set "TYPE=SKIP"

    if not "!TYPE!"=="SKIP" (

        set "TYPE=Others"

        REM --------------------------------------------------
        REM Flutter
        REM --------------------------------------------------

        if exist "!SOURCE!\pubspec.yaml" (
            set "TYPE=Flutter"
        )

        REM --------------------------------------------------
        REM Next.js / React
        REM --------------------------------------------------

        if "!TYPE!"=="Others" if exist "!SOURCE!\package.json" (

            findstr /I /C:"\"next\"" "!SOURCE!\package.json" >nul 2>&1

            if not errorlevel 1 (
                set "TYPE=Next"
            ) else (

                findstr /I /C:"\"react\"" "!SOURCE!\package.json" >nul 2>&1

                if not errorlevel 1 (
                    set "TYPE=React"
                )
            )
        )

        REM --------------------------------------------------
        REM Vanilla HTML
        REM --------------------------------------------------

        if "!TYPE!"=="Others" (
            dir /B "!SOURCE!\*.html" >nul 2>&1

            if not errorlevel 1 (
                set "TYPE=Vanilla HTML"
            )
        )

        REM --------------------------------------------------
        REM Create destination only when required
        REM --------------------------------------------------

        if not exist "!TYPE!" mkdir "!TYPE!"

        echo %ESC%[90m  [PROJECT]%ESC%[0m !PROJECT! %ESC%[90m→%ESC%[0m !TYPE!

        if exist "!TYPE!\!PROJECT!" (
            echo %ESC%[91m  ✗ Already exists — skipped.%ESC%[0m
        ) else (
            move "!SOURCE!" "!TYPE!\" >nul 2>&1

            if errorlevel 1 (
                echo %ESC%[91m  ✗ Error moving project.%ESC%[0m
            ) else (
                echo %ESC%[92m  ✓ Moved successfully.%ESC%[0m
            )
        )

        echo.
    )
)

REM ==========================================================
REM FILES
REM ==========================================================

for %%F in (*) do (

    set "FILE=%%~nxF"
    set "EXT=%%~xF"
    set "TYPE="

    REM ------------------------------------------------------
    REM sort.bat is the only script that stays
    REM ------------------------------------------------------

    if /I "!FILE!"=="sort.bat" set "TYPE=SKIP"

    if not "!TYPE!"=="SKIP" (

        REM --------------------------------------------------
        REM Documents / Data
        REM --------------------------------------------------

        if /I "!EXT!"==".txt"  set "TYPE=TXT"
        if /I "!EXT!"==".docx" set "TYPE=DOCX"
        if /I "!EXT!"==".json" set "TYPE=JSON"
        if /I "!EXT!"==".xlsx" set "TYPE=XLSX"
        if /I "!EXT!"==".csv"  set "TYPE=CSV"

        REM --------------------------------------------------
        REM Media / Archives
        REM --------------------------------------------------

        if /I "!EXT!"==".img" set "TYPE=IMG"
        if /I "!EXT!"==".zip" set "TYPE=ZIP"

        REM --------------------------------------------------
        REM Scripts → Others
        REM --------------------------------------------------

        if /I "!EXT!"==".bat" set "TYPE=Others"
        if /I "!EXT!"==".cmd" set "TYPE=Others"
        if /I "!EXT!"==".vbs" set "TYPE=Others"
        if /I "!EXT!"==".ps1" set "TYPE=Others"
        if /I "!EXT!"==".psm1" set "TYPE=Others"
        if /I "!EXT!"==".sh" set "TYPE=Others"
        if /I "!EXT!"==".bash" set "TYPE=Others"
        if /I "!EXT!"==".zsh" set "TYPE=Others"

        REM --------------------------------------------------
        REM Anything not recognized → Others
        REM --------------------------------------------------

        if not defined TYPE set "TYPE=Others"

        REM --------------------------------------------------
        REM Create destination only when required
        REM --------------------------------------------------

        if not exist "!TYPE!" mkdir "!TYPE!"

        echo %ESC%[90m  [FILE]%ESC%[0m !FILE! %ESC%[90m→%ESC%[0m !TYPE!

        if exist "!TYPE!\!FILE!" (
            echo %ESC%[91m  ✗ Already exists — skipped.%ESC%[0m
        ) else (
            move "!FILE!" "!TYPE!\" >nul 2>&1

            if errorlevel 1 (
                echo %ESC%[91m  ✗ Error moving file.%ESC%[0m
            ) else (
                echo %ESC%[92m  ✓ Moved successfully.%ESC%[0m
            )
        )

        echo.
    )
)

REM ==========================================================
REM COMPLETE
REM ==========================================================

echo.
echo %ESC%[96m╔══════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m║                 ✓ SORT COMPLETE                 ║%ESC%[0m
echo %ESC%[96m╚══════════════════════════════════════════════════╝%ESC%[0m
echo.
echo %ESC%[92m  ✓ Your directory has been sorted.%ESC%[0m
echo.
echo %ESC%[94m  💡 TIP%ESC%[0m
echo %ESC%[94m  Check out more tools here:%ESC%[0m
echo.
echo %ESC%[96m  https://github.com/happylove32c/random_tools%ESC%[0m
echo.

REM ==========================================================
REM SELF DELETE
REM ==========================================================

echo %ESC%[93m  Remove sort.bat from this directory? [Y/N]%ESC%[0m
choice /C YN /N /M "  > "

if errorlevel 2 goto :KEEP

if errorlevel 1 (
    echo.
    echo %ESC%[94m  sort.bat will remove itself after this window closes.%ESC%[0m
    echo.

    start "" /min cmd /c "timeout /t 2 /nobreak >nul & del /f /q ""%~f0"""
    exit
)

:KEEP

echo.
echo %ESC%[90m  sort.bat was kept.%ESC%[0m
echo.
echo %ESC%[90m  Random Tools — small scripts, less boring work.%ESC%[0m
echo.

pause