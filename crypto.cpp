#include "crypto.h"
#include "aes.h"
#include <string.h>

PBYTE AES_Decrypt(PBYTE encrypted, SIZE_T encSize, SIZE_T* outSize) {
    if (encSize < 16) return NULL;

    unsigned char key[] = "StealthLdr2026KeyAES256!!";
    unsigned char iv[16];
    memcpy(iv, encrypted, 16);

    *outSize = encSize - 16;
    PBYTE plaintext = (PBYTE)malloc(*outSize);

    struct AES_ctx ctx;
    AES_init_ctx_iv(&ctx, key, iv);
    AES_CBC_decrypt_buffer(&ctx, encrypted + 16, *outSize);

    unsigned char padding = plaintext[*outSize - 1];
    *outSize -= padding;

    memcpy(plaintext, encrypted + 16, *outSize);
    return plaintext;
}
