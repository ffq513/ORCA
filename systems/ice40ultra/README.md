## Overview

This is a sample project meant for the [ice40ultra breakout board](http://www.latticesemi.com/en/Products/DevelopmentBoardsAndKits/iCE40UltraBreakoutBoard.aspx)

To build the software, make sure you have the [riscv-gnu-toolchain](https://github.com/riscv/riscv-gnu-toolchain) in your path. Then run `make build-software` from this directory.

Make sure to compile the toolchain by disabling the floating point option, and enable compilation for 32bit. Follow the instructions in the above link with the following caveat:-

while running "./configure" run it with the following options:- 

    >./configure --enable-multilib --prefix=/opt/riscv
    
Note that because this core only implements RV32I them makefile uses some gcc flags to make 
sure the compiler does not generate any unimplemented instructions, notably `-m32 -march=RV32I`. 
When you write your own software be sure to use these flags. The Makefile is fairly straight forward 
to read and see how this works


To build you need the ICEcube2 toolchain from Lattice Semiconductor installed.
Then run the command `make ICECUBE2=${ICECUBE2_INSTALLATION_DIRECTORY} bit`
(note that this depends on test.mem which is generated by `make build-software` )

The system currently runs at 12 MHz, but the calculated fmax is above 20 MHz, so when
I get around to it I will insert a PLL and see how fast I can actually make it go.

## Peripherals
The system will automatically reset when a bitstream is loaded, but pin F6 is also
an active low reset as well if you find it necessary.

The high powered white led is controlled by hardware and blinks roughly once per second.

The RBG led is controlled by software by writing to the address 0x00010000. The lower
24 bits are used to produce a colour on the LED.

There is also a uart available for. I use this [PmodUSBUART](https://digilentinc.com/Products/Detail.cfm?NavPath=2,401,928&Prod=PMOD-USB-UART)
chip to connect to it. The rxd pin of the PmodUSBUART is connected to pin B2 on the board (listed
as txd in the pcf constraints file). For information on how to control the uart see softare/main.c
for an example, or take a look at [this datasheet](http://www.latticesemi.com/~/media/LatticeSemi/Documents/ReferenceDesigns/SZ/WISHBONEUART-Documentation.pdf?document_id=32336)

The rest of the pins (there are 12 left available) are used as general purpose IO.
There is a Data register located at 0x00030000, and a control register located at
0x00030004. When a bit a bit in the control register is set, then the pin is an output,
when it is clear the pin is an input. The following table shows how the bits are mapped
to pins on the FPGA.

|**GPIO BIT** | **PIN** |
|:---|:--:|
|0   |E2 |
|1   |F3 |
|2   |E3 |
|3   |F4 |
|4   |E4 |
|5   |F5 |
|6   |E5 |
|7   |B4 |
|8   |B5 |
|9   |D5 |
|10  |D6 |
|11  |E6 |


##Memory System
The system has 4K of instruction memory and 4K of Data memory, all of which is created
out of on chip block rams.The instruction and data memory are seperated completely,
the instruction port cannot access data and the data port cannot access instructions,
this is done for performance since these ICE chips block rams are only single ported.

The process is to initialize the block rams is sort of complicated but fortunately it
is now mostly automated.

First take a look at the floor planner page in the iCECube2 tool, and make note of the
names of the block rams. See the screenshot below:

![screenshot](../misc/ice_ram_screenshot)

Each of these block rams is initialized with it's own memory file. The mapping of files to
block ram is recorded in the imem.list and dmem.list files. In order to generate these
individual files we split up the test.mem that is generated by the software build process
into two files; dmem.mem and imem.mem. Theses files are then vertically split along each nibble
into init_00.imem, init_01.imem, ... init_07.imem. Then using the meminitializer tool from
lattice these files are used to initialize the block rams. For more information see the
iCECube2 User Guide.


## Future Features

* Add a PLL
* Add more GPIOs
* We should be able to use the USB programming cable for direct communication with the CPU.
  If anyone has ideas how to do this I would be happy to hear them.
