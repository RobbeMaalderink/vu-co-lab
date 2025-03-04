#ifdef MACOS
    .global _my_inc
    printf: jmp _printf
    scanf: jmp _scanf
    #ifdef STANDALONE
        .global _main
    #endif
#else
    .global my_inc
    _printf: jmp printf
    _scanf: jmp scanf
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
getnumber:
    .asciz "Enter a number:\n"
printinc:
    .asciz "The incremented number is: %ld\n"
input:
    .asciz "%ld"


_main:
main:
    #create a new stackframe
    pushq %rbp
    movq %rsp, %rbp

    #print "Enter a number:\n"
    leaq getnumber(%rip), %rdi
    movb $0, %al
    call printf

    #read input from keyboard using scanf
    leaq input(%rip), %rdi
    subq $8, %rsp
    movq %rsp, %rsi
    movb $0, %al
    call scanf
    addq $8, %rsp
    popq %rax

    #call subroutine that increments the read number
    movq %rax, %rdi
    call my_inc
    
    #print incremented number   
    leaq printinc(%rip), %rdi
    movq %rax, %rsi
    movb $0, %al
    call printf

    ret

# int64_t my_inc(int64_t n)
_my_inc:
my_inc:
    pushq %rbp
    movq %rsp, %rbp

    incq %rdi
    movq %rdi, %rax

    movq %rbp, %rsp
    popq %rbp    
    ret