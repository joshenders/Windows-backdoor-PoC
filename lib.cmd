@echo off
 if "%1"=="profile" goto PROFILE
 goto :EOF

:PROFILE
 ver 
 cd %windir%\system32 
 set path=%path%;%2;
 for /f "usebackq tokens=1 delims==" %%i in (`set ^| findstr "^_"`) do set %%i=
 goto :EOF