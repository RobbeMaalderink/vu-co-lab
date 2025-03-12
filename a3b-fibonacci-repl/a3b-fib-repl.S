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
size_array:
    .quad 2
size_memory: 
    .quad 16 #in bytes



.text
askForIndex:
    .asciz "Enter an index:\n"
getIndex:
    .asciz "%lu"

printSequence:
    .asciz "F_<%lu> = %lu"

exiting:
    .asciz "Exiting..."

_main:
main:
    pushq %rbp
    movq %rsp, %rbp

    #hardcode first 2 numbers of fibonacci sequence
    movq $16, %rdi
    call malloc
    movq %rax, %r13 #r13 containts a pointer to the start of the memory address 
    movq $0, (%r13)
    movq $1, 1(%r13)
    

    #while read index is a numerical input, do loop
    loop:
        #ask for index
        leaq askForIndex(%rip), %rdi
        call printf
    
        #read index
        subq $16, %rsp
        leaq getIndex(%rip), %rdi
        leaq -8(%rbp), %rsi
        movb $0, %al
        call scanf
        movq -8(%rbp), %r12 #r12 contains the read index
        addq $16, %rsp

        cmpq ?, %r12
        jne end

        #call subroutine
        movq %r12, %rdi
        movq %r13,%rsi
        movq $size_array, %rdx
        call my_fib


        #get right number based on index
        imulq $8,%r12,%r11
        
        movq -%r11(%r13,$size_array,8),%r11
        

        #print result
        leaq printSequence(%rip), %rdi
        movq %r12, %rsi
        movq %r11, %rdx
        call printf

        #end of loop
        jmp loop

    end:

    #exit 'gracefully' with code 0
    leaq exiting(%rip), %rdi
    call printf

    movq %r13, %rdi
    call free

    movq $0, %r12
    movq $0, %r13
    movq $0, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

# uint64_t *my_fib(uint64_t n, uint64_t *arr, uint64_t size)
_my_fib:
my_fib:
    pushq %rbp
    movq %rsp, %rbp
    
    ##if size > index, fib number at index already calculated, otherwise still need to calculate it
    cmpq %rdi, %rdx
    jg alreadycalc:
    jmp notalreadycalc:


    alreadycalc:
        movq %rsi, %rax
        movq %rbp, %rsp
        popq %rbp
        ret   

    notalreadycalc:

        #create loop to compute and store the needed fibonacci numbers
        movq %rdx, %rcx #counter for while loop
        loop2:
            cmpq %rdi, %rcx
            jnl end2

            #compute fib. number size + 1 by adding fib. numbers size - 1 and size - 2
            movq -8(%r13,$size_array,8), %r11
            addq -16(%r13,$size_array,8), %r11

            #create space for fib. number size + 1
            movq %r13, %rdi
            incq $size_array
            addq $8, size_memory
            movq $size_memory, %rsi
            call realloc

            #store new fib. number at the last 8 bytes in memory
            movq %r11, -8(%r13,size_array,8)

            incq %rcx
            jmp loop2



        end2:
        movq %r13, %rax
        movq %rbp, %rsp
        popq %rbp
        ret