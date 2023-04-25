# About Cortex-M3 DesignStart Eval

Cortex-M3 DesignStart Eval is intended for system Verilog design and simulation of a prototype SoC based on the Cortex-M3 processor.

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
