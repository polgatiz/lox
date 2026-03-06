# Detener procesos y cancelar apagados
Get-Process powershell -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*TaskHostWin*"} | Stop-Process -Force
shutdown.exe /a

# Limpiar carpetas de AppData y Windows (versiones viejas)
Remove-Item -Path "$env:LOCALAPPDATA\WinSystem" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\TaskHostWin.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Launcher.vbs" -Force -ErrorAction SilentlyContinue

# Borrar accesos directos de Inicio
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemHost.lnk" -Force -ErrorAction SilentlyContinue

Write-Host "Limpieza total completada." -ForegroundColor Cyan
