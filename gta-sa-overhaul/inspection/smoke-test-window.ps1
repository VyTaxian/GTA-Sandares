param(
    [string]$GameDir = 'D:\Games\GTA San Andreas\Game',
    [string]$Screenshot = 'C:\Users\ADMIN\OneDrive\Documents\Default Project\gta-sa-overhaul\inspection\baseline-windowed.png',
    [int]$WaitSeconds = 25,
    [string]$Arguments = ''
)

$ErrorActionPreference = 'Stop'
$exe = Join-Path $GameDir 'gta_sa.exe'

if (Get-Process -Name 'gta_sa' -ErrorAction SilentlyContinue) { throw 'gta_sa.exe is already running.' }

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $exe
$psi.WorkingDirectory = $GameDir
$psi.Arguments = $Arguments
$psi.UseShellExecute = $false
$p = [System.Diagnostics.Process]::Start($psi)

Start-Sleep -Seconds $WaitSeconds
$p.Refresh()
$alive = -not $p.HasExited
Write-Output "PID=$($p.Id)"
Write-Output "ALIVE=$alive"
if ($alive) {
    Write-Output "TITLE=$($p.MainWindowTitle)"
    Write-Output "HWND=$($p.MainWindowHandle)"
    Write-Output "RESPONDING=$($p.Responding)"
} else {
    Write-Output "EXITCODE=$($p.ExitCode)"
}

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bmp = New-Object System.Drawing.Bitmap($bounds.Width, $bounds.Height)
$gfx = [System.Drawing.Graphics]::FromImage($bmp)
$gfx.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
$bmp.Save($Screenshot, [System.Drawing.Imaging.ImageFormat]::Png)
$gfx.Dispose()
$bmp.Dispose()
Write-Output "SCREENSHOT=$Screenshot"

if ($alive) {
    $p.CloseMainWindow() | Out-Null
    Start-Sleep -Seconds 3
    $p.Refresh()
    if (-not $p.HasExited) { Stop-Process -Id $p.Id -Force }
}
