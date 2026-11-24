param(
    [string]$GameDir = 'D:\Games\GTA San Andreas\Game',
    [int]$WaitSeconds = 20
)

$ErrorActionPreference = 'Stop'
Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class WinEnum {
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
    [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
}
'@

if (Get-Process -Name 'gta_sa' -ErrorAction SilentlyContinue) { throw 'gta_sa.exe is already running.' }
$exe = Join-Path $GameDir 'gta_sa.exe'
$p = Start-Process -FilePath $exe -WorkingDirectory $GameDir -PassThru
Start-Sleep -Seconds $WaitSeconds
$p.Refresh()
Write-Output "PID=$($p.Id) ALIVE=$(-not $p.HasExited) MAIN_TITLE=$($p.MainWindowTitle)"

$results = New-Object System.Collections.ArrayList
$callback = [WinEnum+EnumWindowsProc]{
    param([IntPtr]$hWnd, [IntPtr]$lParam)
    [uint32]$processId = 0
    [WinEnum]::GetWindowThreadProcessId($hWnd, [ref]$processId) | Out-Null
    if ($processId -eq $p.Id) {
        $sb = New-Object System.Text.StringBuilder 512
        [WinEnum]::GetWindowText($hWnd, $sb, $sb.Capacity) | Out-Null
        $results.Add([pscustomobject]@{HWND=$hWnd.ToInt64();Visible=[WinEnum]::IsWindowVisible($hWnd);Title=$sb.ToString()}) | Out-Null
    }
    return $true
}
[WinEnum]::EnumWindows($callback, [IntPtr]::Zero) | Out-Null
$results | Format-Table -AutoSize | Out-String -Width 400

if (-not $p.HasExited) {
    $p.CloseMainWindow() | Out-Null
    Start-Sleep -Seconds 3
    $p.Refresh()
    if (-not $p.HasExited) { Stop-Process -Id $p.Id -Force }
}
