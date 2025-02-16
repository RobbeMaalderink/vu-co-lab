# In this file you can define executables for your project
# The general syntax is:
#   add_executable(<name> <source0> <source1> ... <sourceN>)

add_executable(a0-hello a0-playground/a0-hello.S)
add_executable(a0-sandbox a0-playground/a0-sandbox.S)
add_executable(a0-sieve a0-playground/a0-sieve.S)
add_executable(a1 a1-inout/a1-inout.S)
add_executable(a2 a2-factorial/a2-fac.S)
add_executable(a3a-iter
        a3a-fibonacci-calculator/a3a-fib-main.S
        a3a-fibonacci-calculator/a3a-fib-iter.S
)
add_executable(a3a-rec
        a3a-fibonacci-calculator/a3a-fib-main.S
        a3a-fibonacci-calculator/a3a-fib-rec.S
)
add_executable(a3b a3b-fibonacci-repl/a3b-fib-repl.S)
add_executable(a4
        a4-diff/a4-diff-main.c
        a4-diff/a4-diff.S
)
add_executable(a5 a5-printf/a5-printf.S)
add_executable(a6 a6-hpc/a6-hpc.S)
add_executable(stream a6-hpc/stream.c)
add_executable(a7-encode
        a7-bmp/a7-bmp-encode.S
        a7-bmp/a7-bmp-shared.S
)
add_executable(a7-decode
        a7-bmp/a7-bmp-decode.S
        a7-bmp/a7-bmp-shared.S
)
