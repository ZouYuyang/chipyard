#include "rocc.h"
#include <riscv-pk/encoding.h>
#include <stdio.h>

static inline unsigned long accum(int a, int b)
{
	unsigned long value;
	ROCC_INSTRUCTION_DSS(1, value, a, b, 1);
	return value;
}

int main(void)
{

	printf("Hello\r\n");

  unsigned long ret;
  
  ret = accum(1,2);  
  printf("ret = %ld\n", ret);
  ret = accum(3,4);
  printf("ret = %ld\n", ret);
  ret = accum(5,6);
  printf("ret = %ld\n", ret);
  ret = accum(7,8);
  
  // uint32_t rocc_csr = read_csr(0x800);
  // printf("read rocc_csr value %d\n", rocc_csr);

  printf("ret = %ld\n", ret);
}
