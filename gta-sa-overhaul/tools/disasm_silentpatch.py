import pefile
from capstone import Cs, CS_ARCH_X86, CS_MODE_32
from pathlib import Path

path = Path(r"D:\GTA_SA_Mods\staging\SilentPatchSA.asi.original-warning")
data = path.read_bytes()
pe = pefile.PE(data=data)
base = pe.OPTIONAL_HEADER.ImageBase
foff = 0x1282B
rva = pe.get_rva_from_offset(foff)
print(f"file offset 0x{foff:X} -> RVA 0x{rva:X}, VA 0x{base+rva:08X}")

md = Cs(CS_ARCH_X86, CS_MODE_32)
start_rva = rva - 40
start_off = pe.get_offset_from_rva(start_rva)
code = data[start_off : start_off + 140]
for ins in md.disasm(code, base + start_rva):
    marker = " <-- call site" if ins.address == base + rva else ""
    print(f"{ins.address:08X}: {ins.bytes.hex(' '):<24} {ins.mnemonic:<8} {ins.op_str}{marker}")
