$ErrorActionPreference = 'Stop'
Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class WI {
  public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumWindowsProc cb, IntPtr l);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
  [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr hWnd, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
}
'@
$game='D:\Games\GTA San Andreas\Game'
$exe=Join-Path $game 'gta_sa.exe'
$running=Get-Process -Name gta_sa -ErrorAction SilentlyContinue
if($running){$running | ForEach-Object { Stop-Process -Id $_.Id -Force }}
$psi=New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName=$exe
$psi.WorkingDirectory=$game
$psi.Arguments=''
$psi.UseShellExecute=$false
$p=[System.Diagnostics.Process]::Start($psi)
Start-Sleep -Seconds 20
$p.Refresh()
Write-Output "PID=$($p.Id) TITLE=$($p.MainWindowTitle) ALIVE=$(-not $p.HasExited)"
$list=New-Object System.Collections.ArrayList
$cb=[WI+EnumWindowsProc]{ param([IntPtr]$h,[IntPtr]$l)
  [uint32]$procId=0; [WI]::GetWindowThreadProcessId($h,[ref]$procId)|Out-Null
  if($procId -eq $p.Id -and [WI]::IsWindowVisible($h)){
    $sb=New-Object System.Text.StringBuilder 512; [WI]::GetWindowText($h,$sb,$sb.Capacity)|Out-Null
    $list.Add([pscustomobject]@{HWND=$h.ToInt64();Title=$sb.ToString()})|Out-Null
  }
  return $true
}
[WI]::EnumWindows($cb,[IntPtr]::Zero)|Out-Null
$list | Format-Table -AutoSize | Out-String -Width 300
foreach($w in $list){
  $out="C:\Users\ADMIN\OneDrive\Documents\Default Project\gta-sa-overhaul\inspection\investigate-$($w.HWND).png"
  & 'C:\Users\ADMIN\OneDrive\Documents\Default Project\gta-sa-overhaul\inspection\capture-window.ps1' -HWND $w.HWND -Output $out
}
Write-Output 'LEAVING_PROCESS_RUNNING'
