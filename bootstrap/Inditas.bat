@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -WindowStyle Hidden -Command "$listener = Get-NetTCPConnection -LocalPort 8765 -State Listen -ErrorAction SilentlyContinue; if (-not $listener) { $python = (Get-Command python -ErrorAction Stop).Source; Start-Process -FilePath $python -ArgumentList '-m http.server 8765 --directory ..' -WorkingDirectory '%~dp0' -WindowStyle Hidden }"
timeout /t 2 /nobreak >nul
start "" "http://localhost:8765/index.html"
