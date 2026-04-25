#pragma once
void PatchlessAMSI_Bypass();
void PatchlessETW_Bypass();
void UnhookNtdllBasic();
PBYTE ReadEncryptedFile(const char* path, SIZE_T* size);
