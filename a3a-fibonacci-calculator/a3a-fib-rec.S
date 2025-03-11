#ifdef MACOS
    .global _my_fib
    printf: jmp _printf
    scanf: jmp _scanf
#else
    .global my_fib
    _printf: jmp printf
    _scanf: jmp scanf
#endif

.bss
# [unitialized static variables]

.data
# [initialized static variables]

.text
# [constants/strings]

# uint64_t my_fib(uint64_t n)
_my_fib:
my_fib:
    push %rbp
    movq %rsp, %rbp

    cmpq $1, %rdi
    je basecase1 

    cmpq $3, %rdi
    jnae basecase2

    jmp recursivecall

    basecase1:
    movq $0, %rax
    movq %rbp, %rsp
    pop %rbp
    ret

    basecase2:
    movq $1, %rax
    movq %rbp, %rsp
    pop %rbp
    ret

    recursivecall:
    decq %rdi
    call my_fib
    
    decq %rdi
    push %rax
    call my_fib
    
    popq %r11
    addq %r11, %rax

    movq %rbp, %rsp
    pop %rbp
    ret



