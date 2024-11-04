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


static inline uint32_t sin_rocc(const int x) {
  uint32_t y;
  ROCC_INSTRUCTION_DS(1,y,x,0);
  return y;
}

static inline uint32_t cos_rocc(const int x) {
  uint32_t y;
  ROCC_INSTRUCTION_DS(1,y,x,1);
  return y;
}

static inline uint32_t hav_rocc(const int x) {
  uint32_t y;
  ROCC_INSTRUCTION_DS(1,y,x,2);
  return y;
}

static inline uint32_t fmul_rocc(const int x, const int y) {
  uint32_t r;
  ROCC_INSTRUCTION_DSS(1,r,x,y,3);
  return r;
}

void print_fp(int x) {
    if (x < 0) {
        putchar('-');
        x = -x;
    }
    printf("%d.%05u", x>>15, (x&0x7fff)*100000>>15);
}

int main(void) {
  printf("Hello\n");
  uint64_t cycle1 = r_cycle();
  asm volatile("fence");
  int result = sin_rocc(30 << 15);
  asm volatile("fence" ::: "memory");
  uint64_t cycle2 = r_cycle();
  printf("sin(30) = %d >> 15 or ", result);
  print_fp(result);
  
  cycle1 = r_cycle();
  asm volatile("fence");
  result = cos_rocc(30 << 15);
  asm volatile("fence" ::: "memory");
  cycle2 = r_cycle();
  printf("\ncos(30) = %d >> 15 or ", result);
  print_fp(result);

  cycle1 = r_cycle();
  asm volatile("fence");
  result = hav_rocc(30 << 15);
  asm volatile("fence" ::: "memory");
  cycle2 = r_cycle();
  printf("\nhav(30) = %d >> 5or ", result);
  print_fp(result);

  cycle1 = r_cycle();
  asm volatile("fence");
  result = fmul_rocc(30 << 15, 6 << 15);
  asm volatile("fence" ::: "memory");
  cycle2 = r_cycle();
  printf("\n30*6 = %d << 15 or", result >> 15);
  print_fp(result);

  return 0;
}
