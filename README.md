# Mugato
[![Build Status](https://travis-ci.org/xd009642/Mugato.svg?branch=master)](https://travis-ci.org/xd009642/Mugato)
## Intro
Mugato is my attempt at making a small hardware synthesiser using a
[Mojo-V3](https://embeddedmicro.com/products/mojo-v3). Mugato named after an
alien in Star Trek The Original Series because how better to name a synth than
a sci-fi name? Also, it sounds a bit like legato!

## Development environment
As the Mojo uses a Xilinx Spartan 6 FPGA I'm using Xilinx's ISE as an IDE. I'm
also developing this using VHDL instead of Verilog or Lucid, partially because
of some past experience, partially because I love strong typesystems. 

Because the Mojo-IDE only supports Verilog or Lucid projects I'm generating
everything in ISE and using 
[mojo-loader](https://embeddedmicro.com/pages/mojo-loader) to program the board.

For the eventual CAD design I plan on using FreeCAD to create models which I'll
print with my own Prusa-i3 clone.

## Coregen

Some cores such as the CORDIC processor are fiddly to write and difficult to
write in a reconfigurable way. To this end there are some coregen scripts. These
are written in python 3 and make use of the myhdl python library to generate
the VHDL.

## Debugging & Testing

Debugging the synthesiser via simulation is harder than it would be if I paid
for tools such as Questa, or were using a Vivado compatible chip. For debugging
I'm going to attempt to use GHDL to run my VHDL test benches. For development,
and viewing waves I'll use ISE and dump the output to a vcd file I can then view
in gtkwave as analog signals.

To run in ISE sim and get a vcd file use the following tcl commands

```
vcd dumpfile <FILENAME>.vcd
vcd dumpvars -m /
vcd dumpon
run <TIME>
vcd dumpoff
vcd dumpflush
```

You should specify a time, mugato doesn't use a failure to exit tests as this
prevents travis from correctly recognising test failures. Therefore without
a time the test will run indefinitely.

It's my eventual aim to make checkers in the testbench and then make use of
travis to automate the testing of IP blocks as GHDL takes an age to run on my
machine. UVM would be better but I want to spend my time designing and this is
more attainable for me.

## License
Mugato  is currently licensed under the terms of both the MIT license and the
Apache License (Version 2.0). See LICENSE-MIT and LICENSE-APACHE for more
details.
