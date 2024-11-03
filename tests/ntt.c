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


static inline void set_mod(const int x) {
  ROCC_INSTRUCTION_S(1, x, 0);
}

static inline uint64_t fadd(const int x, const int y) {
  uint64_t r;
  ROCC_INSTRUCTION_DSS(1,r,x,y,1);
  return r;
}

static inline uint64_t fsub(const int x, const int y) {
  uint64_t r;
  ROCC_INSTRUCTION_DSS(1,r,x,y,2);
  return r;
}

static inline uint64_t fmul(const int x, const int y) {
  uint64_t r;
  ROCC_INSTRUCTION_DSS(1,r,x,y,3);
  return r;
}

static inline uint32_t bitrev_load(void *x, uint64_t y) {
  uint32_t r;
  ROCC_INSTRUCTION_DSS(1,r,(uintptr_t)x,y,4);
  return r;
}

uint32_t a[4] = {0x1234, 0x2345, 0xabbc, 0xdeef};
int main(void) {
  printf("Hello\n");
  uint64_t result;
  set_mod(31);

  printf("Mod set!\n");
  
  result = fadd(123, 234);
  asm volatile("fence" ::: "memory");
  printf("[1] %ld\n", result);
  
  result = fsub(345, 123);
  asm volatile("fence" ::: "memory");
  printf("[2] %ld\n", result);

  result = fmul(24, 35);
  asm volatile("fence" ::: "memory");
  printf("[3] %ld\n", result);

  asm volatile("fence" ::: "memory");
  result = bitrev_load(a, 1);
  printf("[4] %d", result);

  return 0;

}
