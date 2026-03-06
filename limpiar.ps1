# Detener procesos de PowerShell que estén corriendo el script
Get-Process powershell -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*TaskHostWin*"} | Stop-Process -Force

# Cancelar cualquier apagado programado por si acaso
shutdown.exe /a

# Borrar archivos y carpeta
Remove-Item -Path "$env:LOCALAPPDATA\WinSystem" -Recurse -Force -ErrorAction SilentlyContinue

# Borrar acceso directo de inicio
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk" -Force -ErrorAction SilentlyContinue

Write-Host "Limpieza completada con éxito." -ForegroundColor Cyan
