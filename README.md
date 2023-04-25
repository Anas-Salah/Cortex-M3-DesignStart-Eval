# About Cortex-M3 DesignStart Eval

Cortex-M3 DesignStart Eval is intended for system Verilog design and simulation of a prototype SoC based on the Cortex-M3 processor.
<p align="center">
  <img width="720" height="720" src="https://user-images.githubusercontent.com/58098260/234245403-c78431fe-dd40-488d-88a5-0fa38be8b4b6.png">
</p>

Cortex-M3 DesignStart Eval includes:
* An ARM Cortex-M3 processor (as obfuscated RTL)
* An ARM cycle model of the Cortex-M3 processor.
* An example system-level design for the ARM Cortex-M3 processor, based around the ARM Cortex-M prototyping system FPGA platform.
* Reusable AMBA components for system-level development

Cortex-M3 DesignStart Eval uses a fixed configuration of the Cortex-M3 processor, enabling low cost easy access
to Cortex-M3 processor technology by offering a subset of the full product.

The processor in Cortex-M3 DesignStart Eval is delivered as a preconfigured and obfuscated, but synthesizable,
Verilog version of the full Cortex-M3 processor and is intended for integration and simulation purposes. It includes
debug and the Cortex-M3 ETM within the obfuscated integration level and is not intended for production silicon.

The other system level components and peripherals are provided in standard Verilog.
An FPGA bitstream is provided which you can load on the ARM® Versatile™ Express Cortex®-M Prototyping
System (MPS2+). This FPGA platform must be purchased separately.

The RTL system integration can be modified, allowing the user to customize logic surrounding the Cortex-M3
processor. Subject to the constraints of the FPGA, a modified system can be synthesized to an MPS2+ bitstream
using the Quartus Prime FPGA design tool (using the free or paid versions of this tool).

# System overview
The Soft Macro Model (SMM) is an FPGA implementation of an ARM processor or subsystem. The
SMM is based on the SSE-050 Subsystem. Extra peripherals that are required by the FPGA are placed on
the expansion of APB and AHB ports.

The following figure shows the block diagram of the FPGA design, indicating the Cortex-M3 processor
from DesignStart, the CMSDK components (peripherals and interconnect), and the interfaces to the
MPS2+ platform peripherals.

<p align="center">
  <img width="720" height="720" src="https://user-images.githubusercontent.com/58098260/234277030-fc686055-8466-4df2-abd6-7a73e8494ac5.png">
</p>

The example system is designed to be implemented on the ARM Versatile Express Cortex-M Prototyping System (V2M-MPS2+), and comes with a full simulation environment.

The example system is built around the Cortex-M3 processor and the CoreLink SSE-050 Subsystem. In addition to the standard peripherals provided by the MPS2+ board, the example system in Cortex-M3 DesignStart Eval provides the following peripherals:

* Two timers that are dedicated for mbed OS usage.
* Timers, UART, Watchdog, Real Time Clock (RTC), and True Random Number Generator (TRNG) for application use.
* SPI interface for microSD card, using the microSD card SPI adapter board.
