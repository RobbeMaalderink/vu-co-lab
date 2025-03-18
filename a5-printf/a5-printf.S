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


.text
test:
    .asciz "This is a %d"

_main:
main:
    # Implement some main function to locally test your printf.
    # The tests will only test my_printf() in isolation, not this main program.

    leal test(%eip), %edi

# void my_printf(const char *fmt, ...)
_my_printf:
my_printf:
    pushl %ebp
    movl %esp, %ebp
    
    

    
    movl %edi, %r13d #move the starting address of the string to %r13d for later use
    

    loop2: #while there is no %s byte, we loop over each character
    
        movb (%r13d), %al
        call putchar
        #cmpb $0, %al
        #je end_of_string
        cmpb $37, %al
        je specialcases 

        addb, $1 %r13d #increment the address by 1 byte to get to the next character
        jmp loop2

    specialcases: 
    ##if next character is a d, u, s or % we return the value of the register
    # that corresponds to that format specifier at the place of the format specifier

        # check whether the next character is a d, u, s or %
        incb %r13d
        movb %r13d, %al
        call putchar
        decb %r13d
        
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
        movl %r13d, %esi
        call shift_bytes
        call replace_format_specifier
        jmp loop2


    
    
    end_of_string:
    movl #move the address of memory into rax or eax?
    movl %ebp, %esp
    popl %ebp
    ret

_replace_format_specifier: 
replace_format_specifier: # replace_format_specifier(), should delete format specifier, and in that place place the appropriate

_shift_bytes:
shift_bytes: #shift_byte takes address of memory, starting at the character after the %
    pushl %ebp
    movl %esp, %ebp

    shift_loop:
        movb (%edi+1), %al
        movb %al, (%edi)
        incl %edi

        cmpb $






    movl %ebp, %esp
    popl %ebp
    ret
    



