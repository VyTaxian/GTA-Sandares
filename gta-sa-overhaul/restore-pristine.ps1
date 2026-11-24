param(
    [string]$GameDir = 'D:\Games\GTA San Andreas\Game',
    [string]$BackupDir = 'D:\GTA_SA_Backups\Game_v1.01_EU_DEViANCE_pristine_2026-11-24'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $GameDir -PathType Container)) { throw "Game directory not found: $GameDir" }
if (-not (Test-Path -LiteralPath $BackupDir -PathType Container)) { throw "Backup directory not found: $BackupDir" }

$running = Get-Process -Name 'gta_sa' -ErrorAction SilentlyContinue
if ($running) {
    Write-Output 'Stopping running gta_sa.exe processes...'
    $running | ForEach-Object { Stop-Process -Id $_.Id -Force }
}

Write-Output 'Restoring pristine game folder...'
$robocopyArgs = @($BackupDir, $GameDir, '/MIR', '/NFL', '/NDL', '/NJH', '/NJS', '/NP', '/R:2', '/W:1')
& robocopy.exe @robocopyArgs | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy failed with exit code $LASTEXITCODE" }

$exeHash = (Get-FileHash -LiteralPath (Join-Path $GameDir 'gta_sa.exe') -Algorithm SHA256).Hash
$vorbisHash = (Get-FileHash -LiteralPath (Join-Path $GameDir 'vorbisFile.dll') -Algorithm SHA256).Hash

Write-Output "EXE_SHA256=$exeHash"
Write-Output "VORBISFILE_SHA256=$vorbisHash"

if ($exeHash -ne 'CD885D84BCBDACDDC27BDBD6676E376557F118F090E71E0DB7C746E72C949064') {
    throw 'gta_sa.exe hash did not match the expected pristine hash.'
}
if ($vorbisHash -ne 'A08923479000CEC366967FB8259E0920B7AA18859722C7DDA1415726BED4774F') {
    throw 'vorbisFile.dll hash did not match the expected pristine hash.'
}

Write-Output 'Restore verified.'
