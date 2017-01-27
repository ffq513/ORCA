#ifndef __SCCB_H_
#define __SCCB_H_

#include "stdint.h"

#define OVM7692_ADDRESS 0x78
#define OVM7692_SUBADDRESS_GAIN  0x00
#define OVM7692_SUBADDRESS_BGAIN 0x01
#define OVM7692_SUBADDRESS_RGAIN 0x02
#define OVM7692_SUBADDRESS_GGAIN 0x03
#define OVM7692_SUBADDRESS_PIDH  0x0A
#define OVM7692_SUBADDRESS_PIDL  0x0B

#define OVM7692_EXPECTED_PIDH 0x76
#define OVM7692_EXPECTED_PIDL 0x92

#define PIO_SDA_BIT  0
#define PIO_SCL_BIT  1
#define PIO_SDA_MASK (1 << PIO_SDA_BIT)
#define PIO_SCL_MASK (1 << PIO_SCL_BIT)

#define PIO_DATA_REGISTER   0
#define PIO_ENABLE_REGISTER 1

#define SCCB_PIO_BASE   ((unsigned *)0x00050000)

void sccb_init(void *pioBase);
void sccb_write(void *pioBase, uint8_t slaveAddress, uint8_t subAddress, uint8_t data);
uint8_t sccb_read(void *pioBase, uint8_t slaveAddress, uint8_t subAddress);

#endif //def __SCCB_H_