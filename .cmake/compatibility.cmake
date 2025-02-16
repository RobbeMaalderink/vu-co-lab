# Your programs will run as standalone executables
add_compile_definitions(STANDALONE)

# Check if on macOS and add -DMACOS flag
if (APPLE)
    message(STATUS "Detected macOS, adding -DMACOS flag")
    add_compile_definitions(MACOS)
    set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE INTERNAL "" FORCE)
endif ()

# Check if on ARM64 and add -arch x86_64 flag
if (CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64" OR CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
    message(STATUS "Detected ARM64, adding -arch x86_64 flag")
    add_compile_options(-arch x86_64)
    add_link_options(-arch x86_64)
endif ()

# Please use WSL :(
if (WIN32)
    message(FATAL_ERROR "Windows is not supported")
endif ()
