@echo off

set SevenZCMD=7za64.exe
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto Main
set SevenZCMD=7za32.exe


:Main

if exist windows_injection.7z del /s /Q windows_injection.7z >nul

echo packing injection ...
cd X
..\internal\%SevenZCMD% a ..\windows_injection.7z . >nul
cd ..

echo.
echo.
if exist windows_injection.7z (
    echo ===============================
    echo ========== SUCCESS ============
    echo ===============================
) else (
    echo ===============================
    echo =========== FAILED ============
    echo ===============================
)
echo.
echo.

pause
