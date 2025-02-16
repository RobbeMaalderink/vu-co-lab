# Do not modify the compile options
# We will test solely with these flags
set(CMAKE_C_COMPILER clang)
set(CMAKE_ASM_COMPILER clang)
set(CMAKE_C_STANDARD 11)
set(CMAKE_ASM_STANDARD 11)
set(CMAKE_C_FLAGS "-g -gdwarf-4 -fPIE -Wall -O0 -fsanitize=address -fno-omit-frame-pointer")
set(CMAKE_ASM_FLAGS ${CMAKE_C_FLAGS})
set(CMAKE_EXE_LINKER_FLAGS "-g -fsanitize=address -fno-omit-frame-pointer")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../)