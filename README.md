# Digilent Nexsys 4 DDR / SymbiFlow example project with simple UART loopback

This is a test project for the Digilent Nexsys 4 DDR development board using the [SymbiFlow](https://symbiflow.github.io/) open source toolchain instead of Xilinx Vivado.

* [Nexys 4 DDR - Digilent Reference](https://reference.digilentinc.com/reference/programmable-logic/nexys-4-ddr/start)

I run these commands to generate a bitstream:

```
export INSTALL_DIR=~/apps/symbiflow
export FPGA_FAM="xc7"
export PATH="$INSTALL_DIR/$FPGA_FAM/install/bin:$PATH"
source "$INSTALL_DIR/$FPGA_FAM/conda/etc/profile.d/conda.sh"
conda activate $FPGA_FAM
make
```

And this command to flash the board using `openocd`:

```
make flash
```

There are some customizations that may be needed for your system:

* change the `INSTALL_DIR` variable in the build commands above to match your SymbiFlow location (in my case it's `~/apps/symbiflow`)

This test project was loosely based on [symbiflow-examples](https://github.com/SymbiFlow/symbiflow-examples), specifically the [counter_test](https://github.com/SymbiFlow/symbiflow-examples/tree/master/xc7/counter_test) project.
