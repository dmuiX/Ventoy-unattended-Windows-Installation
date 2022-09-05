@echo off
:: don't run this twice!
if exist %systemroot%\DONE_SDI.tag exit

:: set USB and location Dir
set USB=%~d0

:: create Temp folder and set log path
md %systemdrive%\Temp > nul
set loganddisplay= ^> %~n0_temp.txt 2^>^&1 ^& type %~n0_temp.txt ^>^> %log% ^& type %~n0_temp.txt ^& del /Q /F %~n0_temp.txt

echo "Copy started\r\n" >> %loganddisplay%

xcopy /herky %USB%\Win10Install\*.* %WINDIR%\Setup\Scripts\ %loganddisplay%

:: push tag to stop
echo stop > %systemroot%\DONE_SDI.tag

echo "Successful executed" >> %loganddisplay%

exit