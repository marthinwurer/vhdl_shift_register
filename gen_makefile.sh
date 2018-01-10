#!/bin/bash

rm -r work
mkdir work
# --vcd=out.vcd
ghdl -i --workdir=work *.vhdl
ghdl --gen-makefile --workdir=work sr_tb > makefile
