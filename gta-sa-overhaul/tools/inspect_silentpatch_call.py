import pefile
from pathlib import Path
p=Path(r'D:\Games\GTA San Andreas\Game\scripts\SilentPatchSA.asi')
data=p.read_bytes()
pe=pefile.PE(data=data)
base=pe.OPTIONAL_HEADER.ImageBase
print('base',hex(base))
for e in pe.DIRECTORY_ENTRY_IMPORT:
    for imp in e.imports:
        if imp.name and b'MessageBoxW' in imp.name:
            print('imp',e.dll,imp.name,'address',hex(imp.address),'iat_va',hex(base+imp.address))
pos=0x12824
print(data[pos-80:pos+180].hex(' '))
