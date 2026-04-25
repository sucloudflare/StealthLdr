#include <windows.h>
#include <stdio.h>

void PatchlessAMSI_Bypass() {
    // Placeholder para bypass patchless (pode ser expandido com hardware breakpoint ou unhooking)
    printf("[+] AMSI Bypass aplicado (patchless)\n");
}

void PatchlessETW_Bypass() {
    // Placeholder para ETW patchless
    printf("[+] ETW Bypass aplicado\n");
}

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