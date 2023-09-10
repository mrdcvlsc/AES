#include <chrono>
#include <cstring>
#include <iostream>
#include <limits.h>
#include <limits>
#include <random>

#include "AES.hpp"

int main() {
  constexpr size_t MB = 16 * 1024 * 1024;
  constexpr size_t KEY_BIT_SIZE = 256;
  static_assert(MB % 16 == 0, "Divisible by AES block size");

  std::mt19937_64 engine(std::chrono::steady_clock::now().time_since_epoch().count());
  std::uniform_int_distribution<unsigned char> rng(
    std::numeric_limits<unsigned char>::min(), std::numeric_limits<unsigned char>::max()
  );

  unsigned char *data = new unsigned char[MB];
  unsigned char *save = new unsigned char[MB];

  for (size_t i = 0; i < MB; ++i) {
    data[i] = rng(engine);
    save[i] = data[i];
  }

  // benchmark start

  unsigned char key[32] = {
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x08, 0x09,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
  };

  Cipher::Aes<KEY_BIT_SIZE> aes_cipher(key);

  auto enc_start = std::chrono::high_resolution_clock::now();
  for (size_t i = 0; i < MB; i += 16) {
    aes_cipher.encrypt_block(&data[i]);
  }
  auto enc_end = std::chrono::high_resolution_clock::now();
  auto enc_dur = std::chrono::duration_cast<std::chrono::milliseconds>(enc_end - enc_start);

  std::cout << "| Encryption | " << KEY_BIT_SIZE << " | " << enc_dur.count() << "ms | " << (MB / 1024) / 1024 << "|\n";

  auto dec_start = std::chrono::high_resolution_clock::now();
  for (size_t i = 0; i < MB; i += 16) {
    aes_cipher.decrypt_block(&data[i]);
  }
  auto dec_end = std::chrono::high_resolution_clock::now();
  auto dec_dur = std::chrono::duration_cast<std::chrono::milliseconds>(dec_end - dec_start);

  std::cout << "| Decryption | " << KEY_BIT_SIZE << " | " << dec_dur.count() << "ms | " << (MB / 1024) / 1024 << "|\n";

  int result = std::memcmp(data, save, MB);
  // std::cout << "\n\nresult = " << result << "\n\n";
  delete[] data;
  delete[] save;
  return result;
}