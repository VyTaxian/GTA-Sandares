# GTA San Andreas Overhaul — Pre-Flight Inspection Report

**Date:** 2026-11-24
**Status:** ⛔ **BLOCKED — no game files present. No mods installed. No files modified.**

---

## 1. Torrent file — inspected

**Path:** `C:\Users\ADMIN\Downloads\grand-theft-auto-san-andreas_20200630_1841shhs_archive.torrent`
**Size:** 36,469 bytes · **Infohash:** `c00784e6633693dd2c77a4b499dc26f02b67c02c`

### Contents (fully decoded bencode)

| # | File | Size | SHA-1 |
|---|------|------|-------|
| 1 | `Grand Theft Auto - San Andreas.iso` | 3,597,205,504 B (3.35 GiB) | `0835ef85e49b30b1e59191549bf6f53b9bffb251ed4` |
| 2 | `.____padding_file/0` | 1,507,328 B | — |
| 3 | `..._meta.sqlite` | 11,264 B | `6be374fbeef532314325de65e0e6baafebd96b9ded4` |
| 4 | `.____padding_file/1` | 2,088,888 B | — |
| 5 | `..._meta.xml` | 794 B | `f787b53b4df9a9929d02bc5c00f80f7bc0d5b617ed4` |
| 6 | `.____padding_file/2` | 2,096,358 B | — |

- Piece length 2 MiB, 1,718 pieces. Tracker: `bt1/bt2.archive.org:6969`. Web-seed URLs point to archive.org.
- **The torrent contains only an ISO.** There are no `.exe`, `.asi`, `.dll`, `modloader`, texture, audio, or model files in it — therefore **no existing modifications can be detected from the torrent alone.** The "checked for existing mods" step must be performed on the extracted installation.

### Internet Archive item metadata

- Identifier: `grand-theft-auto-san-andreas_20200630_1841shhs`
- Uploaded 2020-06-30 by `jonnys.sants@gmail.com`, creator field `canaldetestes`
- Collections: `cdromimages`, `vintagesoftware`; curated as "checked for malware"
- ⚠️ A review dated **2026-11-19** states: *"This is a repack of v1.01, not the original DVD."* This directly conflicts with the requirement to confirm the **original Classic PC release (v1.00)**. This cannot be resolved without inspecting the ISO's `gta_sa.exe`.

---

## 2. Game installation — inspected

**Result: none found anywhere on this machine.**

Checks performed:

- Recursive search of `C:\` for any directory named `*San Andreas*` → **no matches**
- Recursive search of `C:\Users\ADMIN\Downloads`, `Desktop`, and all of `D:\` for `*.iso` and `gta_sa.exe` → **no matches**
- `D:\Games` contains only `World_of_Warships`; `D:\SteamLibrary\steamapps\common` contains only `Rob Run`
- Installed-programs registry (HKLM/HKCU, both 32- and 64-bit) → **no GTA/Rockstar entries**
- No `Grand Theft Auto San Andreas` folder in Program Files, OneDrive Desktop, Documents, or any other scanned location

**Consequences:**

- Cannot verify the game version with SA Version Checker / executable analysis
- Cannot inspect `data\`, `models\`, `audio\`, `text\`, `gta3.img`, `gta_sa.set`, `d3d9.dll`, `*.asi`, `modloader\`, `cleo\`
- Cannot detect pre-existing mods, duplicate files, or conflicts
- **No backup was created** — there is nothing to back up yet
- No compatibility decisions can be finalized until the real installation exists

### Local tooling

- No torrent client installed (qBittorrent etc.)
- No ISO extractor/mounter installed (7-Zip, WinRAR, PowerISO, DAEMON Tools)
- Free space: `C:` ~87 GiB, `D:` ~823 GiB — sufficient for ISO + install + backups

---

## 3. Version facts established (for the decision ahead)

Source: GTAMods Wiki — https://gtamods.com/wiki/San_Andreas_Versions

| Version | Identity | Key traits |
|---------|----------|------------|
| **v1.00** | Original Classic PC release, 2005 | Unmarked title screen, disc required, several bugs |
| **v1.01** | Only official PC patch | Version number on title screen; fixes rain/thunder audio crash, dirty cars, destroyed car colours, DVD streaming, dual-monitor crash, etc. |
| **v2.0** | Later retail | Same fixes as 1.01 **plus hard-coded `gta3.img` size check**; saves incompatible with 1.0/1.01 |
| **v3.0** | Original Steam | Based on Xbox build, missing most 1.01 fixes, console-style UI |
| **newsteam r1/r2** | 2014 Steam updates | Removed radio songs, XInput-only, 5:4 blacklisted; r2 unlocked 16:9 |

**Version must be positively identified from `gta_sa.exe` before any mod is installed.** CLEO 3, for example, is known not to work on some 1.01 EU builds.

---

## 4. Required toolchain (planning only — nothing installed)

Core compatibility layer:

1. **Silent's ASI Loader** (`dinput8.dll`) — plugin loader
2. **CLEO 4.4 / CLEO+** — script mods
3. **San Andreas Modloader** — reversible `.mod` package installation
4. **Silent Patch** — mandatory bug-fix baseline
5. **Widescreen Fix** (ThirteenAG) — modern resolutions / HUD
6. **Open Limit Adjuster** — removes engine limits safely
7. **GInput** — modern controller/mouse input
8. **SkyGFX Extended**, improved streaming, limit/draw-distance fixes — visuals *without* changing identity

Authoring/inspection tools (only if deeper edits are needed):

- **Sanny Builder 4** (script decompilation)
- **Magic.TXD / TXD Workshop** (texture dictionaries)
- **IMG Tool / G-Tools** (`gta3.img` inspection)
- **SA Version Checker** (version confirmation)

### Strong candidate baseline modpack

**A Proper Port — San Andreas** (NexusMods ID 2884, v4.0, updated 2026-11-11) restores PS2-era sky/weather, draw distance, lighting fixes, radio songs, and includes a 1.0 downgrader plus Silent Patch / CLEO / Modloader / Widescreen Fix / Open Limit Adjuster / SkyGFX. ⚠️ It imports **PS2-version assets from the same game** and is **incompatible with old saves**. Whether that violates the "original PC version / no imported assets" rule is a decision for you.

---

## 5. Reality check on the objective

"Mafia: Definitive Edition quality" is **not achievable** in GTA San Andreas's 2004 RenderWare engine. What is achievable is a *cohesive, well-optimized "best-looking Classic SA"*: consistent HD textures, fixed lighting/skies/weather, modern input and bug fixes, cleaner UI, improved audio via fixes, and carefully chosen handling tweaks — while unmistakably remaining GTA San Andreas. PBR materials, ray-traced reflections, fully re-authored character models, and modern motion-capture animation sets would require rebuilding the game, which would violate the "preserve identity / no Frankenstein mod collection" rule.

---

## 6. Decisions required before any installation

1. **Game files:** provide the path to an installed copy or the ISO — or authorize downloading and extracting the 3.6 GB ISO (requires installing a torrent client and ISO tool).
2. **Licensing:** confirm you own a legitimate copy; the archive.org item is an unlicensed repack.
3. **Version policy:** strictly v1.00 Classic PC, or accept v1.01 if that is what the supplied media contains?
4. **Asset policy:** PC-only purist remaster, or allow PS2 assets from *the same game* (e.g. A Proper Port)?
5. **Hardware target:** GPU, CPU, RAM, and target resolution — needed to choose texture resolution and post-processing budget.
