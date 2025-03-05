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
input:
    .asciz "%ld"

printinc:
    .asciz "The incremented number is: %ld\n"



_main:
main:
    #create a new stackframe
    pushq %rbp
    movq %rsp, %rbp

    #print "Enter a number:\n"
    leaq getnumber(%rip), %rdi #load the effective address as first parameter for printf
    movb $0, %al
    call printf

    #read input from keyboard using scanf
    subq $16, %rsp #create space for result of scanf + fix stack allignment
    leaq input(%rip), %rdi #load the effective address as first parameter for scanf
    leaq -8(%rbp), %rsi #make sure that the result of scanf gets stored on the stack, at one of the reserved spaces
    movb $0, %al #number of vector registers used
    call scanf
    movq -8(%rbp), %rax #move the number read from the terminal to rax
    addq $16, %rsp #delete the space for the result of scanf


    #call subroutine that increments the read number
    movq %rax, %rdi #move the result of scanf from rax to rdi, as the first parameter for the my_inc subroutine
    call my_inc
    
    #print incremented number   
    leaq printinc(%rip), %rdi #load the effective address as first parameter for printf
    movq %rax, %rsi #move the incremented number from rax to rsi as second parameter for printf, used to fill %ld
    movb $0, %al
    call printf
    
    #exit
    movl $0, %eax
    movq %rbp, %rsp
    popq %rbp
    ret

# int64_t my_inc(int64_t n)
_my_inc:
my_inc:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    #increment number and move it to rax for return statement
    incq %rdi
    movq %rdi, %rax
    
    #epilogue
    movq %rbp, %rsp
    popq %rbp    
    ret