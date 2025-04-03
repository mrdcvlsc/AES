# AES - Lightweight Single Header AES C++ Library

![tests](https://github.com/mrdcvlsc/AES/actions/workflows/tests.yml/badge.svg)

This repository contains a **single header file C++** that provides AES encryption and decryption function that _**supports**_ both a **pure C++** implementation and optimized implementations that leverage **hardware acceleration technologies** such as; **AES-NI** for `x86-64`, `amd64` architectures and **ARM NEON** for arm `aarch64`or 64-bit arm architectures.

> [!IMPORTANT]  
> This library **focuses solely** on the **encryption** and **decryption** of **AES blocks** and _**does not include padding functions or block cipher encryption modes**_.
> 
> You need to code additional functions or incorporate libraries to handle padding and encryption modes such as CBC or CTR.
> 
> Here is a [CLI program for File Encryption](https://github.com/mrdcvlsc/bethela/blob/main/main.cpp) that uses some of the modules that I wrote ([AES](https://github.com/mrdcvlsc/AES), [BytePadding](https://github.com/mrdcvlsc/BytePadding), [BlockCipherModes](https://github.com/mrdcvlsc/BlockCipherModes)) which can be used as an example.

-----------

## What You’ll Need

Requires a C++ compiler that supports **C++17**, you need to compile it with the compilation flag `-std=c++17` or set the C++ version to 17 when using CMake.

## How to Use the Library

First download the headerfile and add `#include "AES.hpp"` or `#include "path/to/the/file/AES.hpp"` to your code.

Then you can choose how the library runs AES based on your device. Here are your **options**:

### 1. **Portable C++ Version**
- **What it is:** This is a version written entirely in C++ that should work on *any* computer.
- **How to use it:**  Add `-D USE_CXX_AES` and `-O3` when you compile.
- **Speed:** It’s slower than the other options but ensures the best compatibility.

### 2. **AES-NI for Intel/AMD Processors**
- **What it is:** A faster version that uses special instructions built into Intel or AMD processors (found in most PCs and laptops).
- **How to use it:** Add `-D USE_INTEL_AESNI -maes -O3` when you compile.
- **Speed:** Much faster than the portable C++ version if your computer supports it.

### 3. **NEON for ARM Processors**
- **What it is:** A faster version for devices with 64 bit ARM processors, like smartphones or tablets.
- **How to use it:** Add `-D USE_NEON_AES -march=armv8-a+crypto -O3` when you compile.
- **Speed:** Boosts performance on ARM devices, much faster that portable C++ version.

### **Automatic Detection and Manual Choice**

By default, the library will try to figure out the best option for your device after including the header file:
- For Intel/AMD processors, it picks AES-NI if supported.
- For ARM processors, it picks NEON if supported.
- If neither works, it uses the portable C++ version.

Although sometimes, the automatic detection might not work correctly. If that happens, you can force the library to use a specific version by adding the flags listed [above](#how-to-use-the-library) to your compile command. Just make sure your device and compiler support the option you picked.

-----------

# Sample Code to Get Started

**sample.cpp**

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
    aes.encrypt_block(data); // data is now encrypted in-place.
    aes.decrypt_block(data); // data is now decrypted in-place.
}
```

**Resulting Encrypted Value:**

```shell
0x69, 0xc4, 0xe0, 0xd8, 0x6a, 0x7b, 0x04, 0x30,
0xd8, 0xcd, 0xb7, 0x80, 0x70, 0xb4, 0xc5, 0x5a,
```
-----

## How to Compile Your Code

The example below will use the [program `sample.cpp` given above](#sample-code-to-get-started)

### Option 1: Using the Command Line
Run one of these commands in your terminal or command prompt. Replace `sample.cpp` with your file’s name.

- **Portable C++ Version:**
  ```
  g++ -o sample.exe sample.cpp -D USE_CXX_AES -O3 -std=c++17
  ```

- **AES-NI for Intel/AMD:**
  ```
  g++ -o sample.exe sample.cpp -D USE_INTEL_AESNI -maes -O3 -std=c++17
  ```

- **NEON for ARM:**
  ```
  g++ -o sample.exe sample.cpp -D USE_NEON_AES -march=armv8-a+crypto -O3 -std=c++17
  ```

### Option 2: Using CMake

1. On your `CMakeLists.txt` add this block:
    ```cmake
    cmake_minimum_required(VERSION 3.16)
    
    project(YourProjectName VERSION 1.0.0)
    
    # ...
    
    # add this block BEFORE `add_executable`
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED True)
    
    set(AES_IMPL "aesni" CACHE STRING "Choose an AES Implementation")
    set_property(CACHE AES_IMPL PROPERTY STRINGS auto portable aesni neon)
    # add this block BEFORE `add_executable`
    
    # ...
    
    add_executable(main Source.cpp)
    
    # ...
    
    # add this block to AFTER `add_executable(...)`
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
    # add this block to AFTER `add_executable(...)`
    ```

2. Run these commands in your terminal:
    ```
    cmake -S . -B . -D AES_IMPL=portable
    cmake --build . --config Release
    ```
    Replace `portable` with `aesni` or `neon` depending on what you want.

---
