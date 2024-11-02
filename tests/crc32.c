#include <stdio.h>
#include <riscv-pk/encoding.h>
#include <stdint.h>
#include "rocc.h"


static inline uint64_t
r_cycle()
{
  uint64_t x;
  asm volatile("csrr %0, cycle" : "=r" (x) );
  return x;
}


static inline uint32_t crc32(const int x) {
  uint32_t y;
  ROCC_INSTRUCTION_DS(0,y,x,0);
  return y;
}

int main(void) {
  printf("Hello\n");
  uint64_t cycle1 = r_cycle();
  asm volatile("fence");
  uint32_t result = crc32(123);
  asm volatile("fence" ::: "memory");
  uint64_t cycle2 = r_cycle();
  printf("crc32 = %u, in %ld cycle\n", result, cycle2 - cycle1);
  
  cycle1 = r_cycle();
  asm volatile("fence");
  result = crc32(234);
  asm volatile("fence" ::: "memory");
  cycle2 = r_cycle();
  printf("crc32 = %u, in %ld cycle\n", result, cycle2 - cycle1);
  return 0;
}
