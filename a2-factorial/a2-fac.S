#ifdef MACOS
    .global _my_factorial
    printf: jmp _printf
    scanf: jmp _scanf
    #ifdef STANDALONE
        .global _main
    #endif
#else
    .global my_factorial
    _printf: jmp printf
    _scanf: jmp scanf
    #ifdef STANDALONE
        .global main
    #endif
#endif

.bss


.data
# [initialized static variables]

.text
askForInt:
    .asciz "Enter a number:\n"
getInt:
    .asciz "%lu"
printFactorial:
    .asciz "%lu! =: %lu\n"

_main:
main:
    pushq %rbp
    movq %rsp, %rbp

    #ask for number
    leaq askForInt(%rip), %rdi
    call printf

    #read number
    subq $16, %rsp
    leaq getInt(%rip), %rdi
    leaq -8(%rbp), %rsi
    movb $0, %al
    call scanf
    movq -8(%rbp), %r12
    addq $16, %rsp

    #use read number in subroutine
    movq %r12, %rdi
    call my_factorial
    
    #display (read number)! and result
    leaq printFactorial(%rip), %rdi
    movq %r12, %rsi
    movq %rax, %rdx
    call printf

    #exit with code 0
    movq $0, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

# uint64_t my_factorial(uint64_t n)
_my_factorial:
my_factorial:
    pushq %rbp
    movq %rsp, %rbp

    ##if n =< 1, jump to ifcode, else to elsecode 
    cmpq $1, %rdi
    jnae ifcode
    jmp elsecode

    ifcode:
        jmp end1

    elsecode:
        #save input argument on the stack before recursive call, pop it after & multiply with result of recursive call
        pushq %rdi
        decq %rdi
        call my_factorial
        
        popq %rdi
        imulq %rdi, %rax
        jmp end2
    end1:
    movq $1, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

    end2:
    movq %rbp, %rsp
    popq %rbp
    ret