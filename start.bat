@echo off
rem ---------------------------------------------------------------------------
rem SILENCE - local launcher.
rem
rem This file is intentionally pure ASCII. Changing the console code page in
rem the middle of a batch file desynchronises the cmd.exe parser and the rest
rem of the script starts running as garbage - so no Cyrillic here, ever.
rem
rem The form on contacts.html uses fetch(), and the page is built to run under
rem a real HTTP origin (not file://) - this script starts a local server and
rem opens the site in your browser.
rem ---------------------------------------------------------------------------

setlocal enabledelayedexpansion
cd /d "%~dp0"

set PY=
where py >nul 2>nul && set PY=py
if "!PY!"=="" where python >nul 2>nul && set PY=python

if "!PY!"=="" (
  echo.
  echo   Python was not found.
  echo   Install it from https://www.python.org/downloads/ and run this file again.
  echo.
  pause
  exit /b 1
)

rem Find a free port in 8080..8090
set PORT=
for /l %%p in (8080,1,8090) do (
  if "!PORT!"=="" (
    netstat -ano | findstr /c:":%%p " >nul 2>nul || set PORT=%%p
  )
)
if "!PORT!"=="" set PORT=8080

echo.
echo   SILENCE
echo   http://localhost:!PORT!/index.html
echo.
echo   Keep this window open while you use the site.
echo   Press Ctrl+C to stop the server.
echo.

start "" /b cmd /c "timeout /t 2 >nul & start http://localhost:!PORT!/index.html"
!PY! -m http.server !PORT! --bind 127.0.0.1

endlocal
