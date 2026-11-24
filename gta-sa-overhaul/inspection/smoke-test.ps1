param(
    [string]$GameDir = 'D:\Games\GTA San Andreas\Game',
    [string]$Screenshot = 'C:\Users\ADMIN\OneDrive\Documents\Default Project\gta-sa-overhaul\inspection\baseline-smoke.png',
    [int]$WaitSeconds = 55
)

$ErrorActionPreference = 'Stop'
$exe = Join-Path $GameDir 'gta_sa.exe'

if (-not (Test-Path $exe)) { throw "Missing executable: $exe" }
if (Get-Process -Name 'gta_sa' -ErrorAction SilentlyContinue) { throw 'gta_sa.exe is already running.' }

$hash = Get-FileHash -Path $exe -Algorithm SHA256
Write-Output "EXE_SHA256=$($hash.Hash)"

$p = Start-Process -FilePath $exe -ArgumentList '-windowed' -WorkingDirectory $GameDir -PassThru
Write-Output "PID=$($p.Id)"

Start-Sleep -Seconds $WaitSeconds

$p.Refresh()
$alive = -not $p.HasExited
Write-Output "ALIVE=$alive"
if ($alive) {
    Write-Output "WINDOW_TITLE=$($p.MainWindowTitle)"
    Write-Output "RESPONDING=$($p.Responding)"
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
