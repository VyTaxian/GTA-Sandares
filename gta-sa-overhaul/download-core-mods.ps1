$ErrorActionPreference = 'Stop'
$dir = 'D:\GTA_SA_Mods\staging'
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$downloads = @(
  @{ name = 'SilentPatchSA.zip'; url = 'https://github.com/CookiePLMonster/SilentPatch/releases/download/1.1-BUILD34.1-SA/SilentPatchSA.zip' },
  @{ name = 'SilentASILoader.zip'; url = 'https://silent.rockstarvision.com/uploads/silents_asi_loader_13.zip' },
  @{ name = 'GInputSA.zip'; url = 'https://silent.rockstarvision.com/uploads/GInputSA.zip' },
  @{ name = 'CLEO4.zip'; url = 'https://github.com/cleolibrary/CLEO4/releases/download/v4.4.4/CLEO4.zip' },
  @{ name = 'OpenLimitAdjuster.zip'; url = 'https://github.com/GTAmodding/III.VC.SA.LimitAdjuster/releases/download/v2.0.7/III.VC.SA.LimitAdjuster.zip' },
  @{ name = 'SA.Project2DFX.zip'; url = 'https://github.com/ThirteenAG/III.VC.SA.IV.Project2DFX/releases/download/gtasa/SA.Project2DFX.zip' },
  @{ name = 'GTASA.WidescreenFix.zip'; url = 'https://github.com/ThirteenAG/WidescreenFixesPack/releases/download/gtasa/GTASA.WidescreenFix.zip' },
  @{ name = 'GTASA.WidescreenFrontend.zip'; url = 'https://github.com/ThirteenAG/WidescreenFixesPack/releases/download/gtasa/GTASA.WidescreenFrontend.zip' }
)

foreach ($d in $downloads) {
  $out = Join-Path $dir $d.name
  if (Test-Path $out) {
    $item = Get-Item $out
    if ($item.Length -gt 0) { Write-Output "SKIP  $($d.name) ($($item.Length) bytes)"; continue }
  }
  Write-Output "DOWNLOAD $($d.name) <- $($d.url)"
  & curl.exe -f -L --retry 3 --connect-timeout 30 --output $out $d.url
  if ($LASTEXITCODE -ne 0) { throw "Failed to download $($d.name) (exit $LASTEXITCODE)" }
  Write-Output "OK    $($d.name) ($((Get-Item $out).Length) bytes)"
}

Write-Output "`n=== STAGED FILES ==="
Get-ChildItem $dir | Select-Object Name, Length | Format-Table -AutoSize | Out-String -Width 200
