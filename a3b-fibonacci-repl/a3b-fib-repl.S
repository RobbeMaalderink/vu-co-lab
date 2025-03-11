#ifdef MACOS
    .global _my_fib
    printf: jmp _printf
    scanf: jmp _scanf
    malloc: jmp _malloc
    calloc: jmp _calloc
    realloc: jmp _realloc
    free: jmp _free
    #ifdef STANDALONE
        .global _main
    #endif
#else
    .global my_fib
    _printf: jmp printf
    _scanf: jmp scanf
    _malloc: jmp malloc
    _calloc: jmp calloc
    _realloc: jmp realloc
    _free: jmp free
    #ifdef STANDALONE
        .global main
    #endif
#endif

.bss
# [unitialized static variables]

.data
# [initialized static variables]

.text
askForIndex:
    .asciz "Enter an index\n"
getIndex:
    .asciz "%lu"

printSequence:
    .asciz "F_<%lu> = %lu"

_main:
main:
    pushq %rbp
    movq %rsp, %rbp

    #while read index is a numerical input, do loop
    loop:
        condition!!
        jne end
        #ask for index
        leaq askForIndex(%rip), %rdi
        call printf
    
        #read index
        subq $16, %rsp
        leaq getIndex(%rip), %rdi
        leaq -8(%rbp), %rsi
        movb $0, %al
        call scanf
        movq -8(%rbp), %r12
        addq $16, %rsp

        #call subroutine
        movq %r12, %rdi
        movq ?,%rsi
        movq ?, %rdx
        call my_fib

        #print result
        leaq printSequence(%rip), %rdi
        movq %r12, %rsi
        movq %rax, %rdx
        call printf

        #end loop
        jmp loop

    end:
    #exit with code 0
    movq $0, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

# uint64_t *my_fib(uint64_t n, uint64_t *arr, uint64_t size)
_my_fib:
my_fib:
    pushq %rbp
    movq %rsp, %rbp

    cmpq %rdi, %rdx
    jg alreadycalc:
    jmp notalreadycalc:


    alreadycalc:
        movq %rsi, %rax
        movq %rbp, %rsp
        popq %rbp
        ret   

    notalreadycalc:


    movq %rbp, %rsp
    popq %rbp
    ret