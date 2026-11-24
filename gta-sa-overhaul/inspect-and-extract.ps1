$ErrorActionPreference = 'Stop'

$iso = 'D:\GTA_SA_Source\Grand Theft Auto - San Andreas.iso'
$game = 'D:\Games\GTA San Andreas'
$sevenZip = 'C:\Program Files\7-Zip\7z.exe'

if (-not (Test-Path $iso)) { throw "ISO not found: $iso" }
if (-not (Test-Path $sevenZip)) { throw "7-Zip not found: $sevenZip" }

Write-Output '=== ISO CONTENTS (top level) ==='
& $sevenZip l $iso | Select-Object -First 60

Write-Output "`n=== EXTRACTING TO $game ==="
New-Item -ItemType Directory -Force -Path $game | Out-Null
& $sevenZip x $iso "-o$game" -y | Select-Object -Last 20

Write-Output "`n=== EXTRACTED TOP LEVEL ==="
Get-ChildItem -Path $game -Force | Select-Object Name, Mode, Length | Format-Table -AutoSize | Out-String -Width 200

Write-Output "`n=== EXECUTABLE IDENTIFICATION ==="
$exes = Get-ChildItem -Path $game -Filter '*.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 30
foreach ($e in $exes) {
  $vi = $e.VersionInfo
  Write-Output "$($e.FullName)"
  Write-Output "  Size=$($e.Length) FileVersion=$($vi.FileVersion) ProductVersion=$($vi.ProductVersion) ProductName=$($vi.ProductName)"
  Write-Output "  SHA1=$((Get-FileHash $e.FullName -Algorithm SHA1).Hash.ToLower())"
}

Write-Output "`n=== KEY DIRECTORIES ==="
foreach ($d in @('data','models','audio','text','anim','txd','scripts')) {
  $p = Join-Path $game $d
  if (Test-Path $p) {
    $files = Get-ChildItem -Path $p -File -Recurse -ErrorAction SilentlyContinue
    $size = ($files | Measure-Object -Property Length -Sum).Sum
    Write-Output "$d : $($files.Count) files, $([math]::Round($size/1MB,1)) MiB"
  } else { Write-Output "$d : MISSING" }
}

Write-Output "`n=== PRE-EXISTING MOD INDICATORS ==="
$patterns = @('*.asi','d3d9.dll','dinput8.dll','dsound.dll','modloader*','cleo*','SilentPatch*','*.ini','gta_sa.set','gta3.img')
foreach ($pat in $patterns) {
  $hits = Get-ChildItem -Path $game -Filter $pat -Recurse -Force -ErrorAction SilentlyContinue | Select-Object -First 20
  if ($hits) {
    Write-Output "-- $pat --"
    $hits | ForEach-Object { Write-Output "   $($_.FullName.Substring($game.Length+1))" }
  }
}

Write-Output "`n=== VERSION-SPECIFIC FILE CHECKS ==="
$checks = @('gta_sa.exe','data\gta.dat','data\handling.cfg','data\vehicles.ide','models\gta3.img','text\american.gxt','audio\CONFIG')
foreach ($c in $checks) {
  $p = Join-Path $game $c
  if (Test-Path $p) {
    $f = Get-Item $p
    Write-Output "$c : $($f.Length) bytes | SHA1=$((Get-FileHash $p -Algorithm SHA1).Hash.ToLower())"
  } else { Write-Output "$c : MISSING" }
}
