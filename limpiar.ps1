# Detener procesos y cancelar apagados
Get-Process powershell -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*TaskHostWin*"} | Stop-Process -Force
shutdown.exe /a

# Limpiar archivos de usuario y de sistema antiguo
Remove-Item -Path "$env:LOCALAPPDATA\WinSystem" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\TaskHostWin.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Launcher.vbs" -Force -ErrorAction SilentlyContinue

# Borrar acceso directo
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemHost.lnk" -Force -ErrorAction SilentlyContinue

Write-Host "Sistema restaurado y limpio." -ForegroundColor Cyan
