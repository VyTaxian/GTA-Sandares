$ErrorActionPreference = 'Stop'
Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class WM {
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
$psi.FileName=$exe; $psi.WorkingDirectory=$game; $psi.Arguments=''; $psi.UseShellExecute=$false
$p=[System.Diagnostics.Process]::Start($psi)
$seen=@()
for($i=0;$i -lt 15;$i++){
  Start-Sleep -Seconds 2
  $p.Refresh()
  $list=New-Object System.Collections.ArrayList
  $cb=[WM+EnumWindowsProc]{ param([IntPtr]$h,[IntPtr]$l)
    [uint32]$procId=0; [WM]::GetWindowThreadProcessId($h,[ref]$procId)|Out-Null
    if($procId -eq $p.Id -and [WM]::IsWindowVisible($h)){
      $sb=New-Object System.Text.StringBuilder 512; [WM]::GetWindowText($h,$sb,$sb.Capacity)|Out-Null
      $list.Add([pscustomobject]@{HWND=$h.ToInt64();Title=$sb.ToString()})|Out-Null
    }
    return $true
  }
  [WM]::EnumWindows($cb,[IntPtr]::Zero)|Out-Null
  $titles=($list | ForEach-Object {$_.Title}) -join '|'
  Write-Output ("T={0}s MAIN=[{1}] WINDOWS=[{2}]" -f (($i+1)*2),$p.MainWindowTitle,$titles)
  foreach($w in $list | Where-Object {$_.Title -eq 'ASI Loader'}){
    $out="C:\Users\ADMIN\OneDrive\Documents\Default Project\gta-sa-overhaul\inspection\asi-dialog-$($w.HWND).png"
    & 'C:\Users\ADMIN\OneDrive\Documents\Default Project\gta-sa-overhaul\inspection\capture-window.ps1' -HWND $w.HWND -Output $out
    $seen += $out
  }
}
Write-Output "CAPTURES=$($seen.Count)"
if(-not $p.HasExited){ Stop-Process -Id $p.Id -Force }
