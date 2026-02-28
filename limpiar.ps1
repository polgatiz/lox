# Detener procesos
Get-Process -Name "powershell" -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*TaskHostWin*"} | Stop-Process -Force
# Borrar carpeta de archivos
Remove-Item -Path "$env:LOCALAPPDATA\WinSystem" -Recurse -Force -ErrorAction SilentlyContinue
# Borrar acceso directo de inicio
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk" -Force -ErrorAction SilentlyContinue
Write-Host "Sistema limpio." -ForegroundColor Cyan
