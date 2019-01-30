import argparse
from math import atan2, pi, log2, floor

from veriloggen import *


def create_phase_table(module, stages, phasebits, wire_name='phase_table'):
    phases = [atan2(1, 2**i) for i in range(stages)]
    phases = tuple([int(x * (4.0 * (1<<(phasebits-2)))/(2.0*pi)) for x in phases])
    phase_table = module.Wire(wire_name, width=phasebits, length=stages, value=phases)
    for (wire, phase) in zip(phase_table, phases):
        wire.assign(phase)
    return phase_table


def make_cordic(name, phasebits, stages):
    mod = Module(name)

    clk = mod.Input('clk')
    rst = mod.Input('rst')
    enable = mod.Input('en')
    angle = mod.Input('angle', width=phasebits)
    done = mod.OutputReg('done')
    sin_out = mod.OutputReg('sin', width=phasebits)
    cos_out = mod.OutputReg('cos', width=phasebits)

    working = mod.Reg('working')
    phase = mod.Reg('phase', phasebits)
    x1 = mod.Reg('x_next', width=phasebits+1)
    y1 = mod.Reg('y_next', width=phasebits+1)
    p1 = mod.Reg('p_next', width=phasebits+1)
    x0 = mod.Reg('x', width=phasebits+1)
    y0 = mod.Reg('y', width=phasebits+1)
    p0 = mod.Reg('p', width=phasebits+1)
    i = mod.Reg('index', floor(log2(phasebits-1)+1))
    
    phase_table = create_phase_table(mod, stages, phasebits)
        
    # No floats in FPGA land. Keeping the old floats in case I can create comments
    # from them in future for generated VHDL
    # 360/45 = 8 so if we want to split into 45 degree blocks only need 3 bits
    # to represent a block 

    reset_seq = Seq(mod, 'update', clk, rst)
    
    reset_seq.If(rst == 1)(
        x0(0),
        x1(0),
        y0(0),
        y1(0),
        p0(0),
        p1(0),
        i(0),
        working(0)
    ).Else(
        x1(x0),
        y1(y0),
        p1(p0),
        sin_out(x1),
        cos_out(y1),
    )

    calculation = Seq(mod, 'calculation', clk, rst)

    rotation = Seq(mod, 'calculation', clk, rst)

    calculation.If(enable)(
            Case(angle[-3:-1])(
            When(0)(
                x0(1),
                y0(0),
                p0(angle)
            ),
            When(1)(
                x0(-1),
                y0(0),
                p0(angle)
            ),
            When(2)(
                x0(-1),
                y0(0),
                p0(angle)
            ),
            When(3)(
                x0(-1),
                y0(0),
                p0(angle)
            ),
            When(4)(
                x0(-1),
                y0(0),
                p0(angle)
            ),
            When(5)(
                x0(1),
                y0(0),
                p0(angle)
            ),
            When(6)(
                x0(1),
                y0(0),
                p0(angle)
            ),
            When(7)(
                x0(1),
                y0(0),
                p0(angle)
            )
        ),
        i(0),
        working(1),
        done(0)
    ).Elif(AndList(i==stages, working==1))(
        working(0),
        done(1),
        i(0)
    ).Elif(working==1)(
        i.inc(),
        done(0),
        If(p0[-1]==1)(
            x0(x0 + (y0>>i)),
            y0((x0>>i) - y0),
            p0(p0 + phase_table[i])
        ).Else(
            x0(x0 - (y0>>i)),
            y0((x0>>i) + y0),
            p0(p0 - phase_table[i])
        )
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

