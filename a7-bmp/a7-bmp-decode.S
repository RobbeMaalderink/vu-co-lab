#ifdef MACOS
    .global _bmp_decode
    printf: jmp _printf
    malloc: jmp _malloc
    calloc: jmp _calloc
    realloc: jmp _realloc
    free: jmp _free
    fopen: jmp _fopen
    fread: jmp _fread
    fwrite: jmp _fwrite
    fclose: jmp _fclose
    strcpy: jmp _strcpy
    strlen: jmp _strlen
    strncpy: jmp _strncpy
    strnlen: jmp _strnlen
    memset: jmp _memset
    memcpy: jmp _memcpy
    #ifdef STANDALONE
        .global _main
    #endif
#else
    .global bmp_decode
    _printf: jmp printf
    _malloc: jmp malloc
    _calloc: jmp calloc
    _realloc: jmp realloc
    _free: jmp free
    _fopen: jmp fopen
    _fread: jmp fread
    _fwrite: jmp fwrite
    _fclose: jmp fclose
    _strcpy: jmp strcpy
    _strlen: jmp strlen
    _strncpy: jmp strncpy
    _strnlen: jmp strnlen
    _memset: jmp memset
    _memcpy: jmp memcpy
    #ifdef STANDALONE
        .global main
    #endif
#endif

.bss
# [unitialized static variables]

.data
# [initialized static variables]

.text
# [constants/strings]
usage:
    .asciz "usage: ./a7-decode src key\n"

# usage ./a7-bmp-decode src key
_main:
main:
    # Implement me!
    ret

# void bmp_decode(char *buf, const char *key, FILE* file)
_bmp_decode:
bmp_decode:
    # Implement me!
    ret
