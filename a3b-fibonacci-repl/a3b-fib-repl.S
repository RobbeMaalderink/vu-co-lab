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
    .space 256 #bytes

.data
# [initialized static variables]

.text
# [constants/strings]

prompt:         .asciz "Enter an index: "
result_format:  .asciz "F_%lu = %lu\n"
scan_format:    .asciz "%lu"
exit_message:   .asciz "Exiting...\n"

_main:
main:
# set up stack frame
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
    movq    $0, -8(%rbp) #pointer for fibnumber
    movq    $0, -16(%rbp) #array size
    
#loop for input
input_loop:
#print prompt
    leaq    prompt(%rip), %rdi
    movb    $0, %al
    call    printf
#put input index into var at -24
    leaq    -24(%rbp), %rsi
    leaq    scan_format(%rip), %rdi
    movb    $0, %al
    call    scanf
# If scanf returns integer, continue else exit
    cmpq    $1, %rax
    jne     exit_program
#call my_fib(uint64_t n, uint64_t *arr, uint64_t size)
    movq    -24(%rbp), %rdi
    movq    -8(%rbp), %rsi
    movq    -16(%rbp), %rdx
    call    my_fib
#update fibarray and increment array size
    movq    %rax, -8(%rbp)
    movq    -24(%rbp), %rax
    addq    $1, %rax
    movq    %rax, -16(%rbp)
#get calculated fibnumber and print
    movq    -24(%rbp), %rsi
    movq    -8(%rbp), %rax
    movq    -24(%rbp), %rcx
    movq    (%rax,%rcx,8), %rdx
    leaq    result_format(%rip), %rdi
    movb    $0, %al
    call    printf

    jmp     input_loop

#gracefully exiting the program
exit_program:
#print exit message
    leaq    exit_message(%rip), %rdi
    movb    $0, %al
    call    printf
#free fib array memory
    movq    -8(%rbp), %rdi
    call    free
#restore stack -> return
    movq    $0, %rax
    addq    $32, %rsp
    popq    %rbp
    ret

# uint64_t *my_fib(uint64_t n, uint64_t *arr, uint64_t size)
_my_fib:
my_fib:
#prologue
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
#save arguments
    movq    %rdi, -8(%rbp)
    movq    %rsi, -16(%rbp)
    movq    %rdx, -24(%rbp)
#If index already in rdx return array
    cmpq    %rdi, %rdx
    jg      return_array
   cmpq    $0, %rsi
    jne     resize_array
    #allocate memory for n+1 fibnumbers
    movq    -8(%rbp), %rdi
    addq    $1, %rdi
    imulq   $8, %rdi
    call    malloc
    movq    %rax, -16(%rbp)
    #f size is 0, initialize F_0 and F_1
    movq    -16(%rbp), %rax
    movq    $0, (%rax)
    cmpq    $0, -8(%rbp)
    je      return_array
    #initialize F_0 = 0, return if we only needed F_0
    movq    $1, 8(%rax)
    movq    $2, -24(%rbp)
    cmpq    $1, -8(%rbp)
    je      return_array
    jmp     calculate_fib

#handles resizing the existing array to fit new Fibnumbers
resize_array:
    #resize array to hold +1 elements 
    movq    -16(%rbp), %rdi
    movq    -8(%rbp), %rsi
    addq    $1, %rsi
    imulq   $8, %rsi
    call    realloc
    movq    %rax, -16(%rbp)
    #If size is nonzero check if there is one element
    cmpq    $0, -24(%rbp)
    jne     check_size_one
    #If unitialized set F-) and return if input is 0
    movq    -16(%rbp), %rax
    movq    $0, (%rax)
    cmpq    $0, -8(%rbp)
    je      return_array
    #set F-1 = 1 and update size to 2, if input is 1 return array
    movq    $1, 8(%rax)
    movq    $2, -24(%rbp)
    cmpq    $1, -8(%rbp)
    je      return_array
    jmp     calculate_fib
    
#checks if we only have F0 calculated and need to initialize F1
check_size_one:
    #If size not 1, continue calculations
    cmpq    $1, -24(%rbp)
    jne     calculate_fib
    #Else initialize f_1 and update size, if input is 1 return array
    movq    -16(%rbp), %rax
    movq    $1, 8(%rax)
    movq    $2, -24(%rbp)
    cmpq    $1, -8(%rbp)
    je      return_array

calculate_fib:
    movq    -24(%rbp), %rcx
    movq    -8(%rbp), %rdi

#main calculation loop that implements F_n = F_n-1 + F_n-2
calculate_loop:
    #If current size > n, return array
    cmpq    %rdi, %rcx
    jg      return_array
    movq    -16(%rbp), %rax
    movq    %rcx, %rdx
    subq    $1, %rdx
    movq    (%rax,%rdx,8), %rsi
    #load F_(n-1) into %rsi
    movq    %rcx, %rdx
    subq    $2, %rdx
    movq    (%rax,%rdx,8), %rdx
    #load F_(n-2) into %rdx
    addq    %rdx, %rsi
    movq    %rsi, (%rax,%rcx,8)
    #calculate F_n = F_n-1 + F_n-2 and store in array
    incq    %rcx
    jmp     calculate_loop

#returns the  array of fibnumbers
return_array:
    movq    -16(%rbp), %rax
    
    addq    $32, %rsp
    popq    %rbp
    ret