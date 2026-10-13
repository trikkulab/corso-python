@echo off
rem Doppio clic su questo file per installare l'ambiente del corso.
rem Avvia setup-windows.ps1 senza dover cambiare le impostazioni di sicurezza di PowerShell.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-windows.ps1"
echo.
pause
