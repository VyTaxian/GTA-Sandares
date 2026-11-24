import pefile
import struct
from pathlib import Path

ASI = Path(r"D:\Games\GTA San Andreas\Game\scripts\SilentPatchSA.asi")
BACKUP = Path(r"D:\GTA_SA_Mods\staging\SilentPatchSA.asi.original-warning")
data = bytearray(ASI.read_bytes())
original = bytes(data)
pe = pefile.PE(data=original, fast_load=False)

msg_iat = None
for entry in pe.DIRECTORY_ENTRY_IMPORT:
    for imp in entry.imports:
        if imp.name and imp.name.decode(errors="ignore").lower() == "messageboxw":
            msg_iat = imp.address

needle = "You're using a 1.01 executable".encode("utf-16le")
pos = original.find(needle)
if pos < 0:
    raise SystemExit("1.01 warning string not found")
str_va = pe.OPTIONAL_HEADER.ImageBase + pe.get_rva_from_offset(pos)

push_text = b"\x68" + struct.pack("<I", str_va)
push_pos = original.find(push_text)
callpat = b"\xFF\x15" + struct.pack("<I", msg_iat)
call_pos = original.find(callpat, push_pos, push_pos + 100)
push_start = call_pos - 14
after_call = call_pos + 6

# Expected sequence: push 0x30; push caption; push text; push 0; call MessageBoxW
expected = original[push_start:call_pos]
if not (expected.startswith(b"\x6A\x30\x68") and expected.endswith(b"\x6A\x00")):
    raise SystemExit(f"Unexpected argument sequence: {expected.hex(' ')}")
if original[after_call:after_call+3] != b"\x83\xF8\x07":
    raise SystemExit("Unexpected post-call check; refusing to patch")

if not BACKUP.exists():
    BACKUP.write_bytes(original)

# Skip the four argument pushes and the MessageBoxW call. The jump lands just
# after the call; the three-byte stub sets EAX=1 (IDOK) with ZF cleared so the
# following `cmp eax, 7 / je` falls through into the normal patch path.
data[push_start:push_start+5] = b"\xE9" + struct.pack("<I", after_call - (push_start + 5))
data[after_call:after_call+3] = b"\x31\xC0\x40"

ASI.write_bytes(data)
print(f"Patched warning block at file offset 0x{push_start:X}")
print(f"Patched follow-up check at file offset 0x{after_call:X}")
