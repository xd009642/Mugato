import argparse
from math import atan2, pi, log2, floor

from veriloggen import *

def cordic_stages(phasebits, stages):
    mod = Module('cordic_update')
    clk = mod.Input('clk')
    rst = mod.Input('reset')
    out = mod.OutputReg('sin', width=phasebits)
    i = mod.Reg('index', floor(log2(phasebits-1)+1))

    x = mod.Reg('x', width=phasebits+1, length=stages, initval=0)
    y = mod.Reg('y', width=phasebits+1, length=stages, initval=0)
    p = mod.Reg('p', width=phasebits+1, length=stages, initval=0)
    


    return mod

def create_phase_table(module, stages, phasebits, wire_name='phase_table'):
    phases = [atan2(1, 2**i) for i in range(stages)]
    phases = tuple([int(x * (4.0 * (1<<(phasebits-2)))/(2.0*pi)) for x in phases])
    phase_table = module.Wire(wire_name, width=phasebits, length=stages, value=phases)
    for (wire, phase) in zip(phase_table, phases):
        wire.assign(phase)


def make_cordic(name, phasebits, stages):
    mod = Module(name)

    clk = mod.Input('clk')
    rst = mod.Input('reset')
    enable = mod.Input('en')
    ready = mod.OutputReg('done', initval=0)
    data = mod.OutputReg('sin', width=phasebits, initval=0)

    phase = mod.Reg('phase', phasebits, initval = 0)
    x = mod.Reg('x', width=phasebits+1, length=stages, initval=0)
    y = mod.Reg('y', width=phasebits+1, length=stages, initval=0)
    p = mod.Reg('p', width=phasebits+1, length=stages, initval=0)
    
    create_phase_table(mod, stages, phasebits)
        
    # No floats in FPGA land. Keeping the old floats in case I can create comments
    # from them in future for generated VHDL
    # 360/45 = 8 so if we want to split into 45 degree blocks only need 3 bits
    # to represent a block 
    i = mod.Genvar('i')
    generator = mod.GenerateFor(i(0), i<stages, i(i+1), scope='pipeline')
    submod = cordic_stages(phasebits, stages)
    params = ['index', i]
    ports = [('clk', clk), ('reset', rst), ('sin', data)]

    generator.Instance(submod, 'instance', params, ports)


    seq = Seq(mod, 'update', clk, rst)

    seq.If(enable == 1)(
    ).Else(
        x.add(y),
        y.sub(x)
    )


    return mod

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument('--stages', '-s', help='Number of stages in the CORDIC processor', type=int, default = 8)
    parser.add_argument('--phasebits', '-p', help='Number of bits used to store phase values', type=int, default = 15)
    parser.add_argument('--out-width', '-ow', help='Output width', type=int, default=5)
    parser.add_argument('--in-width', '-iw', help='Input data width', type=int, default=3)
    parser.add_argument('--out', '-o', help='Output filename', type=str, default='CORDIC.v')

    args = parser.parse_args()

    print(args)

    concrete_cordic = make_cordic('cordic', args.phasebits, args.stages)
    concrete_cordic.to_verilog(filename='../gen/cordic.v')

