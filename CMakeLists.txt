cmake_minimum_required(VERSION 3.16)

project(tests VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(AES_IMPL "portable" CACHE STRING "Choose an AES Implementation")
set_property(CACHE AES_IMPL PROPERTY STRINGS portable aesni neon)

if(${AES_IMPL} STREQUAL "aesni")
    add_compile_options(-D_USE_INTEL_AESNI -maes)
elseif(${AES_IMPL} STREQUAL "neon")
    add_compile_options(-D_USE_ARM_NEON_AES -march=armv8-a+crypto)
elseif(NOT ${AES_IMPL} STREQUAL "portable")
    message(FATAL_ERROR "Invalid AES implementation option.")
endif()

add_executable(tests tests.cpp)
