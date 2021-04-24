mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))
TOP:=uart_loopback
VERILOG:=${current_dir}/uart_loopback.v ${current_dir}/change_detector.v ${current_dir}/activity_led.v ${current_dir}/pulse_extender.v
#DEVICE  := xc7a50t_test
BITSTREAM_DEVICE := artix7
BUILDDIR:=build

PARTNAME:= xc7a100tcsg324-1
XDC:=${current_dir}/nexys4ddr.xdc
DEVICE:= xc7a100t_test
BOARD_BUILDDIR := ${BUILDDIR}/nexys4ddr

.DELETE_ON_ERROR:


all: ${BOARD_BUILDDIR}/${TOP}.bit

flash: ${BOARD_BUILDDIR}/${TOP}.bit
	openocd -f ${INSTALL_DIR}/${FPGA_FAM}/conda/envs/${FPGA_FAM}/share/openocd/scripts/board/digilent_arty.cfg -c "init; pld load 0 ${BOARD_BUILDDIR}/${TOP}.bit; exit"

${BOARD_BUILDDIR}:
	mkdir -p ${BOARD_BUILDDIR}

${BOARD_BUILDDIR}/${TOP}.eblif: ${VERILOG} ${XDC} | ${BOARD_BUILDDIR}
	cd ${BOARD_BUILDDIR} && symbiflow_synth -t ${TOP} -v ${VERILOG} -d ${BITSTREAM_DEVICE} -p ${PARTNAME} -x ${XDC} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.net: ${BOARD_BUILDDIR}/${TOP}.eblif
	cd ${BOARD_BUILDDIR} && symbiflow_pack -e ${TOP}.eblif -d ${DEVICE} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.place: ${BOARD_BUILDDIR}/${TOP}.net
	cd ${BOARD_BUILDDIR} && symbiflow_place -e ${TOP}.eblif -d ${DEVICE} -n ${TOP}.net -P ${PARTNAME} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.route: ${BOARD_BUILDDIR}/${TOP}.place
	cd ${BOARD_BUILDDIR} && symbiflow_route -e ${TOP}.eblif -d ${DEVICE} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.fasm: ${BOARD_BUILDDIR}/${TOP}.route
	cd ${BOARD_BUILDDIR} && symbiflow_write_fasm -e ${TOP}.eblif -d ${DEVICE}

${BOARD_BUILDDIR}/${TOP}.bit: ${BOARD_BUILDDIR}/${TOP}.fasm
	cd ${BOARD_BUILDDIR} && symbiflow_write_bitstream -d ${BITSTREAM_DEVICE} -f ${TOP}.fasm -p ${PARTNAME} -b ${TOP}.bit

clean:
	rm -rf ${BUILDDIR}

.PHONY: all clean flash
