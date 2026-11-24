# GTA San Andreas Classic PC — Foundation & Final Mod State

Date: 2026-11-24

## Baseline

- Game: `D:\Games\GTA San Andreas\Game`
- Exact build: Euro v1.01, cracked DEViANCE
- `gta_sa.exe` SHA256: `CD885D84BCBDACDDC27BDBD6676E376557F118F090E71E0DB7C746E72C949064`
- Pristine backup: `D:\GTA_SA_Backups\Game_v1.01_EU_DEViANCE_pristine_2026-11-24`
- Pristine manifest: `inspection/pristine-manifest.csv`
- Clean baseline smoke test: launches successfully with no command-line arguments; window title `GTA: San Andreas`.
- `-windowed` caused an immediate exit on this executable, so all verification uses no arguments.

## Installed foundation

1. **Ultimate ASI Loader** — from `GTASA.WidescreenFix.zip`
   - Installed as `vorbisFile.dll`
   - SHA256: `D5A059AA467A7A7127C8F6169F79FA63FF0F55986EE9EB2FD9A281BEBF2AA2E6`
   - Original DLL remains in the pristine backup.
   - Provides ASI loading from `scripts/` and reversible asset overrides via `update/`.

2. **DirectX 9 D3DX runtime**
   - `d3dx9_43.dll`, extracted from Microsoft's official June 2010 DirectX End-User Runtime
   - SHA256: `0B28546BE22C71834501F7D7185EDE5D79742457331C7EE09EFC14490DD64F5F`
   - Required by `GTASA.WidescreenFix.asi`; adding it eliminated the ASI Loader error 126 startup dialog.

3. **SilentPatch SA 1.1 build 34.1**
   - `scripts/SilentPatchSA.asi`, `scripts/SilentPatchSA.ini`
   - Source explicitly recognizes 1.01 EU.
   - The hard-coded 1.01 “no longer supported” warning was patched out of this ASI only. The original ASI is backed up at `D:\GTA_SA_Mods\staging\SilentPatchSA.asi.original-warning`.
   - Patched ASI SHA256: `460B059EBD955CF77FECCC5401C4C314ED1EA934378C7323EB67F21E9DD20478`
   - All delayed 1.01 fixes remain active; only the warning dialog is skipped.

4. **CLEO 4.4.4**
   - `scripts/CLEO.asi`, root `bass.dll`, minimal `cleo/*.cleo` plugins
   - CLEO's own `vorbisFile.dll` and `vorbisHooked.dll` were **not** used.
   - Verification: `scripts/cleo.log` reports `Started on game of version: SA 1.01 eu`.

5. **GTASA Widescreen Fix**
   - `scripts/GTASA.WidescreenFix.asi`, `scripts/GTASA.WidescreenFix.ini`
   - Pattern-based hooks; no 1.0-only address table.
   - Conservative settings retained: SMAA on, MSAA off, hidden AA bug lines, fullscreen map, 60 FPS menu cap, 16:9 menu constraints, HQ radar disc.

6. **GTASA Widescreen Frontend**
   - Installed as `update/models/txd/LOADSCS.txd`
   - SHA256: `EEB3B14A47DBE01A8845D816756ACEC321B122E85FA284FF4669A233D8F1B548`
   - No original TXD was overwritten.

7. **RoSA generic vehicle texture salvage**
   - Installed as `update/models/generic/vehicle.txd`
   - SHA256: `8C1A437F79279B224844908D420C474F509193EA1AB5608215649E7100107B1A`
   - The rest of RoSA was not used.

## Exact installed file hashes

| File | Bytes | SHA256 |
|---|---:|---|
| `vorbisFile.dll` | 5,418,336 | `D5A059AA467A7A7127C8F6169F79FA63FF0F55986EE9EB2FD9A281BEBF2AA2E6` |
| `d3dx9_43.dll` | 1,998,168 | `0B28546BE22C71834501F7D7185EDE5D79742457331C7EE09EFC14490DD64F5F` |
| `bass.dll` | 139,128 | `6E1BF8EA63F9923687709F4E2F0DAC7FF558B2AB923E8C8AA147384746E05B1D` |
| `scripts/SilentPatchSA.asi` | 441,856 | `460B059EBD955CF77FECCC5401C4C314ED1EA934378C7323EB67F21E9DD20478` |
| `scripts/SilentPatchSA.ini` | 3,661 | `3A2288600762070F14434E30BB8F6C0FFF25CE59962A630F629EA2B83D7E1FF4` |
| `scripts/CLEO.asi` | 325,120 | `748EA0B36A1580652146C8B443066BDD81EF14556431805B2102F0F1F44CAA08` |
| `scripts/GTASA.WidescreenFix.asi` | 5,110,264 | `9F8A2B5C508010D0423BA9D712B203225A46A49998D5467F4A1BB9835580A513` |
| `scripts/GTASA.WidescreenFix.ini` | 2,038 | `5F4B5459296AA7534EBDEC581FAD371E322079E278532577784246CE994748E4` |
| `cleo/FileSystemOperations.cleo` | 98,304 | `B7B80BC1AAD995E7643127A978DFB56BDA7FE02AB54879327CFA7BACA71BCDDF` |
| `cleo/IniFiles.cleo` | 110,080 | `D9DDDE713211EB1341EC7181D0B2D7E487E8C816CED7AFADEE5D50EF3F37D168` |
| `cleo/IntOperations.cleo` | 76,800 | `5897BCD19AC9097F3B730C091623C556A176C82AF4F97E3A2C483F62F4819F4F` |
| `update/models/txd/LOADSCS.txd` | 157,596,072 | `EEB3B14A47DBE01A8845D816756ACEC321B122E85FA284FF4669A233D8F1B548` |
| `update/models/generic/vehicle.txd` | 7,149,372 | `8C1A437F79279B224844908D420C474F509193EA1AB5608215649E7100107B1A` |

## Excluded for this executable

- **Mod Loader 0.3.10** — its address translator only builds tables for SA 1.0 US/EU; SA 1.1 EU is detected but not translated. Asset overrides use the loader's `update` folder instead.
- **Open Limit Adjuster 2.0.7** — documentation states GTA SA 1.0 US only; other versions are left alone.
- **SALodLights / Project 2DFX** — documentation states GTA SA 1.0 US required.
- **GInputSA** — readme states GTA SA 1.0 only. Controller support should be handled via Steam Input or OS-level mapping.
- **A Proper Port** — excluded by the PC-only purist asset policy.
- **RoSA Project Evolved (full pack)** — excluded despite a valid archive; see below.
- **Proper Shaders 09-26** — optional and not installed. The ShareMods page is blocked by a Cloudflare Turnstile page and the author's public Google Drive mirror is currently quota-limited.

## RoSA evaluation

- Archive: `D:\GTA_SA_Mods\staging\RoSA.Evolved.September.7z`
- Size: `6,405,040,531` bytes
- Full 7-Zip test: `Everything is Ok` — 125 files, 14,382,134,507 bytes unpacked
- Parsed IMG headers:
  - Stock `models/gta3.img`: 16,316 entries, ~896 MB of entries
  - RoSA `gta3.img`: 13,557 entries, ~339 MB of entries; it is a strict subset of stock names
  - The missing 2,759 entries include `bistro.txd`, `hospital2.txd`, `libertyhi*.txd`, `snow.txd`, `station.txd`, `trees2.txd`, etc.
- `world_loader.txt` requires four additional multi-GB IMGs (`rosa_evolved_a/b/c/d.img`) plus `txdp.ide`.
- Its readme explicitly requires GTA SA 1.0 US, Mod Loader, Open Limit Adjuster/Improved Streaming/MixSets, and 1024 MB streaming memory.
- Conclusion: installing it on 1.01 EU would require unsupported loaders/limit adjusters and would remove stock entries if only the main IMG were swapped. Excluded for stability and fidelity. Only `generic/vehicle.txd` was salvaged via the `update` folder.

## Verification history and final state

Layer checks were performed after every install step:

- `inspection/baseline-default.png` — clean baseline
- `inspection/layer1-loader.png` — loader
- `inspection/layer2-silentpatch.png` — SilentPatch
- `inspection/layer3-cleo.png` — CLEO
- `inspection/layer4-widescreen.png` — Widescreen Fix
- `inspection/layer5-frontend.png` — frontend override
- `inspection/layer6-final.png` — vehicle TXD override
- `inspection/final-stable.png` — final 60-second validation

Final validation:

- No ASI Loader dependency dialog
- No SilentPatch 1.01 warning dialog
- PID stayed alive, responsive, window title `GTA: San Andreas` for 60 seconds
- CLEO log confirms `SA 1.01 eu`
- Robocopy comparison against the pristine backup shows no changed original files except the intentional `vorbisFile.dll` loader replacement; `bass.dll` and `d3dx9_43.dll` are new files.

## Restore

Use `restore-pristine.ps1` to return the game folder to the verified pristine state. It mirrors the backup into the game directory and removes all added mod files and folders.
