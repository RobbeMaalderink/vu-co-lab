#ifdef MACOS
    .global _my_printf
    putchar: jmp _putchar
    #ifdef STANDALONE
        .global _main
    #endif
#else
    .global my_printf
    _putchar: jmp putchar
    #ifdef STANDALONE
        .global main
    #endif
#endif

.bss
# [unitialized static variables]

.data
numberOfArguments:
    .long 1
numberOfChars:
    .long 0


.text
test:
    .asciz "This is a %d %s"

_main:
main:
    # Implement some main function to locally test your printf.
    # The tests will only test my_printf() in isolation, not this main program.

    leaq test(%rip), %rdi

# void my_printf(const char *fmt, ...)
_my_printf:
my_printf:
    pushq %rbp
    movq %rsp, %rbp
    
    movq %rdi, %r13 #r13 is now a pointer to the address starting at the current byte 
    movq %rdi, %r14 #move the starting address also to r14 for use at the end
    

    loop2: #while there is no %s byte, we loop over each character
    
        movb (%r13), %al
        call putchar
        
        addb $1, %r13 #increment the address by 1 byte to get to the next character

        cmpb $37, %al
        je specialcases 

        jmp loop2

    specialcases: 
    ##if next character is a d, u, s or % we return the value of the register
    # that corresponds to that format specifier at the place of the format specifier

        # check whether the next character is a d, u, s or %
        incb %r13
        movb (%r13), %al
        call putchar
        decb %r13
        
        cmpb $100,%al
        je d
        cmpb $117, %al
        je u
        cmpb $115, %al
        je s
        cmpb $37, %al
        je percent

        d:
        #add 2 bytes of memory after the %u and replace
        #the 4 bytes it by a unsigned 32-bit integer


        call replace_format_specifier

        jmp loop2
        u:
        #add 2 bytes of memory after the %u and replace
        #the 4 bytes it by a unsigned 32-bit integer
        call replace_format_specifier

        jmp loop2
        s:
        #when encountering null-terminated string, we jump to the end and return the string
        jmp end_of_string
        percent:
        #when encountering %%, we shift each byte back by 1 byte, resulting in deletion of the second %
        movq %r13, %rdi
        call shift_byte_back
        jmp loop2


    
    
    end_of_string:
    movq %r14, %rax #move the address of start of memory into rax
    movq %rbp, %rsp
    popq %rbp
    ret

_replace_format_specifier: 
replace_format_specifier: # replace_format_specifier(), should delete format specifier, and in that place place the appropriate

_shift_byte_back:
shift_byte_back: #shift_byte takes address of memory, starting at the character after the %
    pushq %rbp
    movq %rsp, %rbp

    shift_loop:
        movb (%rdi+1), %al
        movb %al, (%rdi)
        incq %rdi
        
        call putchar

        cmpb $115, %al 
        jne shift_loop

        movb (%rdi-1), %al
        call putchar
        cmpb $37, %al
        jne shift_loop
    
    #return the part of the string after the %%, and r14 still points to the correct starting address
    movq %rdi, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

_shift_two_bytes_forward:
shift_two_bytes_forward: # %rdi contains the memory address of string format starting at the character after %u or %d
    pushq %rbp
    movq %rsp, %rbp

    call getNumChars
    shift_loop2:

        movb (%rdi), %al
        movb %al, (%rdi + 2)
        incq %rdi
        
        call putchar

        cmpb $115, %al 
        jne shift_loop2

        movb (%rdi+1), %al
        call putchar
        cmpb $37, %al
        jne shift_loop2
    
    addTwoBytes:

    
    movq %rdi, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

_getNumOfChars:
getNumOfChars: #input is a pointer to start of memory address, output is the amount of characters that are in the string after start of memory address
    pushq %rbp
    movq %rsp, %rbp

    incq %rdi
    movb (%rdi), %al
    call putchar

    cmpb $37, %al
    incq $numberOfChars
    jne getNumOfChars

    movb (%rdi + 1), %al
    call putchar
    cmpb $115, %al
    incq $numberOfChars
    jne getNumOfChars

    movq %rbp, %rsp
    popq %rbp
    ret



        




    



