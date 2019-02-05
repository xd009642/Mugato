import argparse
from math import atan2, pi, log2, floor, sqrt

from veriloggen import *

def min_width(max_value):
    return floor(log2(phasebits-1)+1) 

def cordic_submodule(stages, phase_bits, ww):
    mod = Module('cordic_inner')
    clk = mod.Input('clk')
    enable = mod.Input('ce')
    x_in = mod.Input('x_in', signed=True, width=ww)
    y_in = mod.Input('y_in', signed=True, width=ww)
    p_in = mod.Input('p_in', signed=True, width=phase_bits)
    p_d = mod.Input('p_d', signed=True, width=phase_bits)
    shift  = mod.Input('i', width=ww)
    x_out = mod.Output('x_out', signed=True, width=ww)
    y_out = mod.Output('y_out', signed=True, width=ww)
    p_out = mod.Output('p_out', signed=True, width=phase_bits)

    mod.Always(Posedge(clk))(
        If(enable)(
            If(p_in[-1])(
                x_out(x_in + (y_in>>shift)),
                y_out(y_in - (x_in>>shift)),
                p_out(p_in + p_d)
            ).Else(
                x_out(x_in - (y_in>>shift)),
                y_out(y_in + (x_in>>shift)),
                p_out(p_in - p_d)
            ),
        )
    )
    return mod;

def create_phase_table(module, stages, phasebits, wire_name='phase_table'):
    phases = [atan2(1, 2**i) for i in range(stages)]
    phases = tuple([int(x * (4.0 * (1<<(phasebits-2)))/(2.0*pi)) for x in phases])
    phase_table = module.Wire(wire_name, width=phasebits, length=stages, value=phases)
    for (wire, phase) in zip(phase_table, phases):
        wire.assign(phase)
    return phase_table

def make_cordic(name, phasebits, stages, margin):
    mod = Module(name)
    clk = mod.Input('clk')
    enable = mod.Input('ce')
    rst = mod.Input('rst')
    cordic_angles = create_phase_table(mod, stages, phasebits);
    ix = mod.Input('x_in', width=phasebits, signed=True)
    iy = mod.Input('y_in', width=phasebits, signed=True)
    iph = mod.Input('phase_in', width=phasebits)
    sin_out = mod.Output('sin', width=phasebits, signed=True)
    cos_out = mod.Output('cos', width=phasebits, signed=True)
    
    ww = phasebits + margin + 1
    temp_x = mod.Wire('temp_x', width=ww, signed=True)
    temp_y = mod.Wire('temp_y', width=ww, signed=True)

    temp_x.assign( (ix[-1]<<(ww-1)) | (ix<<margin))
    temp_y.assign( (iy[-1]<<(ww-1)) | (iy<<margin))
    
    xs = mod.Reg(name='x', width=ww, length=stages+1, signed=True)
    ys = mod.Reg(name='y', width=ww, length=stages+1, signed=True)
    phases = mod.Reg(name='phases', width=phasebits, length=stages+1, signed=True)

    
    mod.Always(Posedge(clk))(
        If(enable)(
            # I'm assuming here it will just truncate off the higher bits..
            sin_out(xs[stages-1]>>(margin+1)),
            cos_out(ys[stages-1]>>(margin+1)),
            # Initial rotations
            Case(iph[-3:])(
                When(0)(
                    xs[0](temp_x),
                    ys[0](temp_y),
                    phases[0](iph)
                ),
                When(1)(
                    xs[0](-temp_y),
                    ys[0](temp_x),
                    phases[0](iph - (0x01<<(phasebits-2)))
                ),
                When(2)(
                    xs[0](-temp_y),
                    ys[0](temp_x),
                    phases[0](iph - (0x01<<(phasebits-2)))
                ),
                When(3)(
                    xs[0](-temp_x),
                    ys[0](-temp_y),
                    phases[0](iph - (0x02<<(phasebits-2)))
                ),
                When(4)(
                    xs[0](-temp_x),
                    ys[0](-temp_y),
                    phases[0](iph - (0x02<<(phasebits-2)))
                ),
                When(5)(
                    xs[0](temp_y),
                    ys[0](-temp_x),
                    phases[0](iph - (0x03<<(phasebits-2)))
                ),
                When(6)(
                    xs[0](temp_y),
                    ys[0](-temp_x),
                    phases[0](iph - (0x03<<(phasebits-2)))
                ),
                When(7)(
                    xs[0](temp_x),
                    ys[0](temp_y),
                    phases[0](iph)
                )
            )
        ),
    )

    # For loop here
    i = mod.Genvar('i')

    gen_for = mod.GenerateFor(i(0), i<stages, i(i+1), scope='gen_for')
    cordic_inner = cordic_submodule(stages, phasebits, ww)
    params = []
    ports = [('clk', clk), ('ce', enable), ('x_in', xs[i]), ('y_in', ys[i]), ('p_in', phases[i]),
            ('x_out', xs[i+1]), ('y_out', ys[i+1]), ('p_out', phases[i+1]), 
            ('p_d', cordic_angles[i]), ('i', i)]
    
    gen_for.Instance(cordic_inner, 'generator_exp', params, ports)

    return mod

def cordic_gain(stages, phasebits):
    gain = 1.0
    for i in range(stages):
        gain = gain * sqrt(1.0 + 2.0**(-2.0*i))
    return gain

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument('--stages', '-s', help='Number of stages in the CORDIC processor', type=int, default = 10)
    parser.add_argument('--phasebits', '-p', help='Number of bits used to store phase values', type=int, default = 18)
    parser.add_argument('--out', '-o', help='Output filename', type=str, default='CORDIC.v')

    args = parser.parse_args()

    print(args)

    cgain = cordic_gain(args.stages, args.phasebits)
    print('cordic gain is: '+str(cgain))
    print('hex constant is: '+hex(round((2**args.phasebits) / cgain)))

    cordic2 = make_cordic('cordic', args.phasebits, args.stages, margin=13);
    cordic2.to_verilog(filename='../gen/cordic.v')

