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

int main(void) {
  printf("Hello\n");
  int a = 1;
  int b = 2;
  int c = -1;
  uint64_t cycle1 = r_cycle();
  asm volatile("fence");
  ROCC_INSTRUCTION_DSS(0,c,a,b,0);
  asm volatile("fence" ::: "memory");
  uint64_t cycle2 = r_cycle();
  printf("addtwice = %d, in %ld cycle\n", c, cycle2 - cycle1);
  return 0;
}
