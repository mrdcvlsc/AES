# AES - Lightweight Single Header AES C++ Library

![tests](https://github.com/mrdcvlsc/AES/actions/workflows/tests.yml/badge.svg)

This repository contains a **single header file C++** that provides AES encryption and decryption function that _**supports**_ both a **pure C++** implementation and optimized implementations that leverage **hardware acceleration technologies** such as; `AES-NI` for `x86-64` architectures and `ARM NEON` for `ARM` architectures.

> [!IMPORTANT]  
> This library **focuses solely** on the **encryption** and **decryption** of **AES blocks** and _**does not include padding functions or block cipher encryption modes**_.
> 
> You need to code additional functions or incorporate libraries to handle padding and encryption modes such as CBC or CTR.
> 
> Here is a [CLI program for File Encryption](https://github.com/mrdcvlsc/bethela/blob/main/main.cpp) that uses some of the modules that I wrote ([AES](https://github.com/mrdcvlsc/AES), [BytePadding](https://github.com/mrdcvlsc/BytePadding), [BlockCipherModes](https://github.com/mrdcvlsc/BlockCipherModes)) which can be used as an example.

-----------

## Requirement

Requires C++17 so you need to compile it with the compilation flag `-std=c++17`.

## Enable Portable C++ AES Implementation

By simply including the main header file (`AES.hpp`), the code will be compiled using portable C++. Make sure to compile with the optimization flag `-O3`.

_Please note that the portable code is slower than the two alternatives mentioned below_.

**Additional Compiler Flag: `-D USE_CXX_AES`**

**CMake: `AES_IMPL=portable`**

## Enable AES-NI Hardware Acceleration

To achieve a significant speed-up performance, add the following flag when compiling for **`x86-64`** architecture.
  
_e.g. mid-range PCs & Laptops_.

**Additional Compiler Flag: `-D USE_INTEL_AESNI -maes`**

**CMake: `AES_IMPL=aesni`**

## Enable ARM neon Hardware Acceleration

To gain a speed-up performance, add the following flag when compiling for **`aarch64`**, **`armv8`** architecture.
  
 _e.g. modern android devices_.

**Additional Compiler Flag: `-D USE_NEON_AES -march=armv8-a+crypto`**

**CMake: `AES_IMPL=neon`**

# Sample Program

```c++
/*    sample.cpp    */
#include <iostream>
#include "AES.hpp"

int main()
{
    unsigned char data[16] = {
      0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
      0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff,
    };

    unsigned char key[] = {
      0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
      0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    };

    Cipher::Aes<128> aes(key);
    aes.encrypt_block(data); // data is now encrypted.
    aes.decrypt_block(data); // data is now decrypted.
}
```

**Encrypted Value:**

```shell
0x69, 0xc4, 0xe0, 0xd8, 0x6a, 0x7b, 0x04, 0x30,
0xd8, 0xcd, 0xb7, 0x80, 0x70, 0xb4, 0xc5, 0x5a,
```

# Compiling with CMake

To build with cmake while choosing what AES implementation to use, you can add the following cmake code below into your **CMakeLists.txt** file.

**cmake:**

```cmake
cmake_minimum_required(VERSION 3.16)

project(YourProjectName VERSION 1.0.0)

# ...

# add this block before `add_executable`
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(AES_IMPL "aesni" CACHE STRING "Choose an AES Implementation")
set_property(CACHE AES_IMPL PROPERTY STRINGS auto portable aesni neon)
# add this block before `add_executable`

# ...

add_executable(main Source.cpp)

# ...

# add this block to after `add_executable(...)`
if("${AES_IMPL}" STREQUAL "aesni")
    target_compile_definitions(main PUBLIC USE_INTEL_AESNI)
    if(MSVC)
        target_compile_options(main PRIVATE /arch:SSE2)
    else()
        target_compile_options(main PRIVATE -maes)
    endif()
elseif("${AES_IMPL}" STREQUAL "neon")
    target_compile_definitions(main PUBLIC USE_NEON_AES)
    target_compile_options(main PRIVATE -march=armv8-a+crypto)
elseif("${AES_IMPL}" STREQUAL "portable")
    target_compile_definitions(main PUBLIC USE_CXX_AES)
endif()
# add this block to after `add_executable(...)`
```

Then run **cmake-gui** choose which aes implementation you want to enable in the check-boxe of `AES_IMPL`.

Or use the terminal command for bash/cmd`.

```bash
cmake -S . -B . -D AES_IMPL=<CHOSEN_AES>
cmake --build . --config Release
```

The value of `<CHOSEN_AES>` could be `aesni`, `neon` or `portable`, .

# Compiling in the Command Line

1. **compile with [pure c/c++ code]**

  ```
  g++ -o sample.exe sample.cpp -D USE_CXX_AES -O3
  ```

2. **comple with [AES-NI]**

  ```
  g++ -o sample.exe sample.cpp -D USE_INTEL_AESNI -maes -O3
  ```

3. **comple with [Arm-NEON-AES]**

  ```
  g++ -o sample.exe sample.cpp -D USE_NEON_AES -march=armv8-a+crypto -O3
  ```