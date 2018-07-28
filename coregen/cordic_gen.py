import argparse
from myhdl import *

@block
def cordic_gen(phasebits, stages, phases):
    raise NotImplemented



parser = argparse.ArgumentParser()
parser.add_argument('--stages', '-s', help='Number of stages in the CORDIC processor', type=int)
parser.add_argument('--phasebits', '-p', help='Number of bits used to store phase values', type=int)
parser.add_argument('--out', '-o', help='Output filename', type=str, default='CORDIC.vhd')

args = parser.parse_args()

print(args)
pb = Signal(intbv(0)[args.phasebits:])
s = Signal(intbv(0)[args.stages:])

concrete_cordic = cordic_gen(pb, s, [])

concrete_cordic.convert(hdl='VHDL')

print(args)
