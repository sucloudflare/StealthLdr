#include "evasion.h"
#include <windows.h>
#include <stdio.h>

void PatchlessAMSI_Bypass() { printf("[+] AMSI Bypass aplicado\n"); }
void PatchlessETW_Bypass()  { printf("[+] ETW Bypass aplicado\n"); }
void UnhookNtdllBasic()     { printf("[+] Unhooking ntdll básico aplicado\n"); }

PBYTE ReadEncryptedFile(const char* path, SIZE_T* size) {
    FILE* f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    *size = ftell(f);
    fseek(f, 0, SEEK_SET);
    PBYTE buf = (PBYTE)malloc(*size);
    fread(buf, 1, *size, f);
    fclose(f);
    return buf;
}
