#include "neural.h"


layer_t cifar_golden[] = {
	{.conv={CONV, RELU, 0, 32, 32, 3, 64, 0, GOLDEN_FLASH_DATA_OFFSET+3072, 1, 1}},
	{.conv={CONV, RELU, 0, 32, 32, 64, 64, 1, GOLDEN_FLASH_DATA_OFFSET+69504, 1, 1}},
	{.conv={CONV, RELU, 0, 16, 16, 64, 128, 0, GOLDEN_FLASH_DATA_OFFSET+94592, 1, 1}},
	{.conv={CONV, RELU, 0, 16, 16, 128, 128, 1, GOLDEN_FLASH_DATA_OFFSET+144768, 1, 1}},
	{.conv={CONV, RELU, 0, 8, 8, 128, 256, 0, GOLDEN_FLASH_DATA_OFFSET+186752, 1, 1}},
	{.conv={CONV, RELU, 0, 8, 8, 256, 256, 1, GOLDEN_FLASH_DATA_OFFSET+270720, 1, 0}},
	{.dense={DENSE, RELU, 0, 4096, 256, GOLDEN_FLASH_DATA_OFFSET+420224, GOLDEN_FLASH_DATA_OFFSET+551296, 1, GOLDEN_FLASH_DATA_OFFSET+552320}},
	{.dense={DENSE, RELU, 0, 256, 256, GOLDEN_FLASH_DATA_OFFSET+554368, GOLDEN_FLASH_DATA_OFFSET+562560, 1, GOLDEN_FLASH_DATA_OFFSET+563584}},
	{.dense={DENSE, LINEAR, 1, 256, 10, GOLDEN_FLASH_DATA_OFFSET+565632, GOLDEN_FLASH_DATA_OFFSET+565952, 1, GOLDEN_FLASH_DATA_OFFSET+565992}},
};

#if 0 //n400
layer_t cifar_reduced[] = {
	{.conv={CONV, RELU, 0, 32, 32, 3, 32, 0, REDUCED_FLASH_DATA_OFFSET+0, 1, 1}},
	{.conv={CONV, RELU, 0, 32, 32, 32, 32, 1, REDUCED_FLASH_DATA_OFFSET+448, 1, 1}},
	{.conv={CONV, RELU, 0, 16, 16, 32, 48, 0, REDUCED_FLASH_DATA_OFFSET+2752, 1, 1}},
	{.conv={CONV, RELU, 0, 16, 16, 48, 48, 1, REDUCED_FLASH_DATA_OFFSET+6208, 1, 1}},
	{.conv={CONV, RELU, 0, 8, 8, 48, 64, 0, REDUCED_FLASH_DATA_OFFSET+11200, 1, 1}},
	{.conv={CONV, RELU, 0, 8, 8, 64, 64, 1, REDUCED_FLASH_DATA_OFFSET+17856, 1, 0}},
	{.dense={DENSE, RELU, 0, 1024, 64, REDUCED_FLASH_DATA_OFFSET+26560, REDUCED_FLASH_DATA_OFFSET+34752, 1, REDUCED_FLASH_DATA_OFFSET+35008}},
	{.dense={DENSE, RELU, 0, 64, 64, REDUCED_FLASH_DATA_OFFSET+35264, REDUCED_FLASH_DATA_OFFSET+35776, 1, REDUCED_FLASH_DATA_OFFSET+36032}},
	{.dense={DENSE, LINEAR, 1, 64, 2, REDUCED_FLASH_DATA_OFFSET+36288, REDUCED_FLASH_DATA_OFFSET+36304, 1, REDUCED_FLASH_DATA_OFFSET+36312}},
};
#elif 0 //n230
layer_t cifar_reduced[] = {
	{.conv={CONV, RELU, 0, 32, 32, 3, 16, 0, REDUCED_FLASH_DATA_OFFSET+0, 1, 1}},
	{.conv={CONV, RELU, 0, 32, 32, 16, 16, 1, REDUCED_FLASH_DATA_OFFSET+224, 1, 1}},
	{.conv={CONV, RELU, 0, 16, 16, 16, 32, 0, REDUCED_FLASH_DATA_OFFSET+864, 1, 1}},
	{.conv={CONV, RELU, 0, 16, 16, 32, 32, 1, REDUCED_FLASH_DATA_OFFSET+2144, 1, 1}},
	{.conv={CONV, RELU, 0, 8, 8, 32, 48, 0, REDUCED_FLASH_DATA_OFFSET+4448, 1, 1}},
	{.conv={CONV, RELU, 0, 8, 8, 48, 48, 1, REDUCED_FLASH_DATA_OFFSET+7904, 1, 0}},
	{.dense={DENSE, RELU, 0, 768, 64, REDUCED_FLASH_DATA_OFFSET+12896, REDUCED_FLASH_DATA_OFFSET+19040, 1, REDUCED_FLASH_DATA_OFFSET+19296}},
	{.dense={DENSE, RELU, 0, 64, 64, REDUCED_FLASH_DATA_OFFSET+19552, REDUCED_FLASH_DATA_OFFSET+20064, 1, REDUCED_FLASH_DATA_OFFSET+20320}},
	{.dense={DENSE, LINEAR, 1, 64, 2, REDUCED_FLASH_DATA_OFFSET+20576, REDUCED_FLASH_DATA_OFFSET+20592, 1, REDUCED_FLASH_DATA_OFFSET+20600}},
};
#elif 1 //n80??
layer_t cifar[] = {
	{.conv={CONV, RELU, 0, 32, 32, 3, 8, 0, REDUCED_FLASH_DATA_OFFSET+0, 1, 1}},
	{.conv={CONV, RELU, 0, 32, 32, 8, 8, 1, REDUCED_FLASH_DATA_OFFSET+112, 1, 1}},
	{.conv={CONV, RELU, 0, 16, 16, 8, 16, 0, REDUCED_FLASH_DATA_OFFSET+304, 1, 1}},
	{.conv={CONV, RELU, 0, 16, 16, 16, 16, 1, REDUCED_FLASH_DATA_OFFSET+688, 1, 1}},
	{.conv={CONV, RELU, 0, 8, 8, 16, 24, 0, REDUCED_FLASH_DATA_OFFSET+1328, 1, 1}},
	{.conv={CONV, RELU, 0, 8, 8, 24, 24, 1, REDUCED_FLASH_DATA_OFFSET+2288, 1, 0}},
	{.dense={DENSE, RELU, 0, 384, 64, REDUCED_FLASH_DATA_OFFSET+3632, REDUCED_FLASH_DATA_OFFSET+5168, 1, REDUCED_FLASH_DATA_OFFSET+5296}},
	{.dense={DENSE, RELU, 0, 32, 32, REDUCED_FLASH_DATA_OFFSET+5424, REDUCED_FLASH_DATA_OFFSET+5552, 1, REDUCED_FLASH_DATA_OFFSET+5680}},
	{.dense={DENSE, LINEAR, 1, 32, 2, REDUCED_FLASH_DATA_OFFSET+5808, REDUCED_FLASH_DATA_OFFSET+5816, 1, REDUCED_FLASH_DATA_OFFSET+5824}},
};
#endif
