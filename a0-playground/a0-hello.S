#ifdef MACOS
    .global _main
    printf: jmp _printf
#else
    .global main
    _printf: jmp printf
#endif

.text
message:
    .asciz "Hello World!\n"

_main:
main:
    # [main function body]
    # Prologue (save the previous stack frame and set up the new one)
    pushq   %rbp
    movq    %rsp, %rbp

    leaq    message(%rip), %rdi     # Load the address of the message into rdi
    movb    $0, %al                 # We are using 0 vector registers, so we need to tell printf that
    call    printf                  # Call printf libc function, equivalent to printf("Hello World!\n");

    # Epilogue (restore the previous stack frame)
    movq    %rbp, %rsp
    popq    %rbp
    movq    $0, %rax                # %rax is the return register, we want to return 0
    ret                             # Return to the caller, equivalent to return 0;
