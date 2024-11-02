#include "rocc.h"
#include <stdio.h>

static inline void accum_write(int idx, unsigned long data)
{
	ROCC_INSTRUCTION_SS(1, data, idx, 0);
}

static inline unsigned long accum_read(int idx)
{
	unsigned long value;
	ROCC_INSTRUCTION_DSS(1, value, 0, idx, 1);
	return value;
}

static inline void accum_load(int idx, void *ptr)
{
	asm volatile ("fence");
	ROCC_INSTRUCTION_SS(1, (uintptr_t) ptr, idx, 2);
}

static inline void accum_add(int idx, unsigned long addend)
{
	ROCC_INSTRUCTION_SS(1, addend, idx, 3);
}

unsigned long data = 0x3421L;

int main(void)
{

	printf("Hello, Accum\r\n");
	unsigned long result;

	accum_load(0, &data);
	accum_add(0, 2);
	result = accum_read(0);

	if (result != data + 2) {
		printf("[1] Fuck!\r\n");
		return 1;
	}

	accum_write(0, 3);
	accum_add(0, 1);
	result = accum_read(0);

	if (result != 4) {
		printf("[2] Fuck\r\n");
		return 2;
	}
	printf("[2] Passed\r\n");
	return 0;
}
