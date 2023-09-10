cmake_minimum_required(VERSION 3.20)

project(tests VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(AES_IMPL "aesni" CACHE STRING "Choose an AES Implementation")
set_property(CACHE AES_IMPL PROPERTY STRINGS auto portable aesni neon)

add_executable(tests tests.cpp)

if("${AES_IMPL}" STREQUAL "aesni")
    target_compile_definitions(tests PUBLIC USE_INTEL_AESNI)
    if(MSVC)
        target_compile_options(tests PRIVATE /arch:SSE2)
    else()
        target_compile_options(tests PRIVATE -maes)
    endif()
elseif("${AES_IMPL}" STREQUAL "neon")
    target_compile_definitions(tests PUBLIC USE_ARM_NEON_AES)
    target_compile_options(tests PRIVATE -march=armv8-a+crypto)
elseif("${AES_IMPL}" STREQUAL "portable")
    target_compile_definitions(tests PUBLIC USE_CXX_AES)
endif()