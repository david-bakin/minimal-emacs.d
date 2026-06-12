@echo off

rem derived from https://www.emacswiki.org/emacs/RobertAdesamEmacsClientBat
rem and https://stackoverflow.com/a/40406636/751579
rem and https://emacs.stackexchange.com/a/12896/8382

setlocal enableextensions enabledelayedexpansion

rem set following variables appropriately (and they assume you're
rem using the normal init-directory at .~/.emacs.d) (and they also
rem assume there are no spaces in binpath or in %userprofile% or 
rem %servername%
set servername=minimal
set binpath=c:\b\emacs-30.2-my-build\bin
set initeldurationsec=1
set serverfile=%userprofile%\.emacs.d\var\server\%servername%
if "%~1"=="" (
  set filename=%homedrive%%homepath%\Downloads
) else (
  set filename=%~1
)

rem GOAL: only try emacsclient -e if there's an emacs.exe running
rem  (if there isn't even an emacs.exe running just delete the server
rem  file and start a daemon)
rem IOW:
rem if there's an emacs.exe running AND you can connect to it with
rem emacsclient then DONE, otherwise delete the server file and start
rem the daemon.

set emacsserverrunning=N
rem (It's stupid that Microsoft's `tasklist` does not set an
rem errorlevel if the filter fails to pass anything)
tasklist /nh /fi "imagename eq emacs.exe" | findstr /i "emacs.exe" >nul 2>&1
if not errorlevel 1 set emacsserverrunning=Y

if %emacsserverrunning%==Y (
  set emacsserverrunning=N
  if exist %serverfile% (
    emacsclient --timeout=1 --server-file=%serverfile% -e "(+ 1 0)" >nul 2>&1
    if not errorlevel 1 set emacsserverrunning=Y
  )
)

if %emacsserverrunning%==N (
  echo starting emacs daemon
  del %serverfile% 2>nul
  %binpath%\runemacs.exe --daemon=%servername%
  rem give it a chance to run through the init.el and get to the
  rem point where `server-start` is executed
  sleep %initeldurationsec%
)

rem customize the following line as you see fit (e.g.,
rem `--create-frame` instead of `-reuse-frame`)
%binpath%\emacsclient.exe --no-wait --timeout=1 --server-file=%serverfile% ^
                          --reuse-frame "%filename%"

endlocal


