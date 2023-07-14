# AES - Lightweight Single Header AES C++ Library

![tests](https://github.com/mrdcvlsc/AES/actions/workflows/tests.yml/badge.svg)

This repository contains a **single header file C++ library** that provides AES encryption and decryption functionality. The library _**supports**_ both a **pure C++** implementation and optimized implementations that leverage **hardware acceleration technologies**, such as `AES-NI` for `x86-64` architectures and `ARM NEON` for `ARM` architectures.

**Please note** that this library **focuses solely** on the **encryption** and **decryption** of **AES blocks** and _**does not include padding functions or encryption modes**_. You may need to incorporate additional functions or libraries to handle padding and implement specific encryption modes, such as CBC or CTR.

-----------

## **Requirements**

- Requires C++17 so you need to compile it with the compilation flag `-std=c++17`.

## **Performance Compilation D-Flags:**

+ **Portable**:

  By simply including the main header file (`AES.hpp`), the code will be compiled using portable C++. Make sure to compile with the optimization flag `-O3`.
  
  _Please note that the portable code is slower than the two alternatives mentioned below_.

+ **AES-NI:**

  To achieve a significant speed-up performance, add the following flag when compiling for `x86-64` architecture.
  
  _e.g. mid-range PCs & Laptops_.

  ```-D_USE_INTEL_AESNI -maes -O3```

+ **ARM neon:**

  To gain a speed-up performance, add the following flag when compiling for `aarch64 armv8` architecture.
  
  _e.g. modern android devices_.

  ```-D_USE_ARM_NEON_AES -march=armv8-a+crypto -O3```

## **Sample program:**

- **compile with [pure c/c++ code]**

  ```
  g++ -o sample.exe sample.cpp -O3
  ```

- **comple with [AES-NI]**

  ```
  g++ -o sample.exe sample.cpp -D_USE_INTEL_AESNI -maes -O3
  ```

- **comple with [Arm-NEON-AES]**

  ```
  g++ -o sample.exe sample.cpp -D_USE_ARM_NEON_AES -march=armv8-a+crypto -O3
  ```


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