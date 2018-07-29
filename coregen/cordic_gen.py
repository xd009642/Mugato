import argparse
from myhdl import *
from math import atan2, pi


@block
def cordic_gen(clk, rst, phasebits, stages):

    phases = [atan2(1, 2**i) for i in range(stages)]
    phases = [x * (4.0 * (1<<(phasebits-2)))/(2.0*pi) for x in phases]
    # No floats in FPGA land. Keeping the old floats in case I can create comments
    # from them in future for generated VHDL
    int_phases = tuple([int(x) for x in phases])
    # 360/45 = 8 so if we want to split into 45 degree blocks only need 3 bits
    # to represent a block
    
    x = Signal(intbv(0)[args.stages:])
    y = Signal(intbv(0)[args.stages:])
    z = Signal(intbv(0)[args.stages:])
    @always(clk.posedge)
    def update():
        for i in range(stages):
            x[i] = int_phases[i]

    return update



parser = argparse.ArgumentParser()
parser.add_argument('--stages', '-s', help='Number of stages in the CORDIC processor', type=int, default = 5)
parser.add_argument('--phasebits', '-p', help='Number of bits used to store phase values', type=int, default = 15)
parser.add_argument('--out', '-o', help='Output filename', type=str, default='CORDIC.vhd')

args = parser.parse_args()

print(args)
clk = Signal(bool(0))
rst = Signal(bool(0))
pb = Signal(intbv(0)[args.phasebits:])
s = Signal(intbv(0)[args.stages:])

concrete_cordic = cordic_gen(clk, rst, args.phasebits, args.stages)

concrete_cordic.convert(hdl='VHDL')

print(args)
