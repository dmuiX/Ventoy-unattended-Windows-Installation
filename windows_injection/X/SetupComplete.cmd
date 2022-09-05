:: Environment variables that are already available:
:: %USB% is the USB drive - e.g. D:  NOTE: IT MAY BE DISCONNECTED BY NOW!
:: %BIT% will either be X86 or AMD64
:: %WINVER% will be 7 or 8 or 10
:: %log% will be the log file
:: %errlog% will be a log file to record errors
:: %systemdrive%\DRIVERS folder will hold all files that were in %USB%\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO

:: use loganddisplay to show the console text output of any command and then append to log file (e.g. dir C:\  %loganddisplay%)
set loganddisplay= ^> %~n0_temp.txt 2^>^&1 ^& type %~n0_temp.txt ^>^> %log% ^& type %~n0_temp.txt ^& del /Q /F %~n0_temp.txt
set errlog=%systemdrive%\temp\%~n0_ERRORS.log

set BIT=%PROCESSOR_ARCHITECTURE%
if /i "%BIT%"=="X86" set B=32 bit
if /i "%BIT%"=="AMD64" set B=64 bit

if "%BIT%"=="" echo ERROR: The BIT environment variable is not set - you must run Startup.cmd first. %loganddisplay%

:: Stop automatic updates (uncomment to enable)
:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f

:: Install chocolatey

echo Starting Installation of Chocolatey...
echo %date% %time% DOWNLOAD CHOCOLATEY FROM NETWORK AND INSTALL... >> %loganddisplay%
:: Some packages may not install correctly at this stage due to no user account but may still work OK - if not, use choco in the startup.cmd file instead!
:: Packages may not be listed by choco list command if installed in this phase
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
if errorlevel 1 echo CHOCO POWERSHELL INSTALL reported errorlevel %errorlevel% >> %errlog%
echo Downloading and installings apps - please wait...
echo See https://chocolatey.org/packages for choco packages >> %loganddisplay%

:: configure choco to allow non-checksummed packages and not prompt user for 'Yes' (-y is not needed)
choco feature enable -n allowEmptyChecksums > nul
choco feature enable -n allowGlobalConfirmation > nul

choco install -h | find /i "chocolatey" > nul || start /wait %systemdrive%\DRIVERS\nircmd speak text "WARNING: Chocolatey is not installed - choco installs will not work"

:: ----- ONLINE INSTALLS - INTERNET ACCESS REQUIRED ----

choco install firefox -r %loganddisplay%
choco install brave -r %loganddisplay%
choco install sudo -r %loganddisplay%
choco install clink-maintained -r %loganddisplay%
choco install choco-cleaner -r %loganddisplay%
choco install hashtab -r %loganddisplay%
choco install 7zip -r %loganddisplay%
choco install teracopy -r %loganddisplay%
choco install microsoft-windows-terminal -r %loganddisplay%
choco install mediamonkey -r %loganddisplay%
choco install itunes -r %loganddisplay% 
choco install auto-dark-mode -r %loganddisplay%
@REM choco install rufus -r %loganddisplay%
@REM choco install office365proplus -r %loganddisplay%
@REM choco install microsoft-edge -r %loganddisplay%

set log=%systemdrive%\afterInstallationLog

:: DEACTIVATE CRAP APPS WINDOWS
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /d 1 /t REG_DWORD /f
reg add "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /d 1 /t REG_DWORD /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /d 0 /t REG_DWORD /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /d 0 /t REG_DWORD /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\" /v SystemPaneSuggestionsEnabled /d 0 /t REG_DWORD /f

%systemdrive%\DRIVERS\nircmd.exe speak text "Run Decrapifier script"
SET PowerShellScriptPath=%systemdrive%\DRIVERS\decrapifier.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File """"%PowerShellScriptPath%"""" -ClearStart' -Verb RunAs;}"
timeout 360

echo "Uninstall Onedrive" >> %loganddisplay%
%systemdrive%\DRIVERS\nircmd.exe speak text "Uninstall Onedrive"
taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall

echo "Uninstall Teams" >> %loganddisplay%
%systemdrive%\DRIVERS\nircmd.exe speak text "Uninstall Teams"
wmic product where name="Teams Machine-Wide Installer" call uninstall

echo "Reboot" >> %loganddisplay%
%systemdrive%\DRIVERS\nircmd.exe speak text "Reboot"
shutdown /r /t 15

goto :EOF

REM --------------------- END ---------------------------

REM --------- Convert variable to uppercase --------

:ToUpper
REM Returns variable %1 as UpCase in variable %2
REM Usage: call :ToUpper %myvar% myvar
FOR /F "tokens=2 delims=-" %%A IN ('FIND "" "%~1" 2^>^&1') DO SET UpCase=%%A
set %2=%UpCase:~1,99%
goto :EOF