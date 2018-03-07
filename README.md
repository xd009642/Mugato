# Mugato
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

## Debugging & Testing

Debugging the synthesiser via simulation is harder than it would be if I paid
for tools such as Questa, or were using a Vivado compatible chip. For debugging
I'm going to attempt to use GHDL to run my VHDL test benches and output nice
waveforms I can view in GtkWave. I did try ISE sim but the inability to show
vectors as analog signals makes debugging waveform synthesis a lot harder.

It's my eventual aim to make checkers in the testbench and then make use of
travis to automate the testing of IP blocks as GHDL takes an age to run on my
machine. UVM would be better but I want to spend my time designing and this is
more attainable for me.

## License
Mugato  is currently licensed under the terms of both the MIT license and the
Apache License (Version 2.0). See LICENSE-MIT and LICENSE-APACHE for more
details.
