# Mugato
## Intro
Mugato is my attempt at making a small hardware synthesiser using a 
[Mojo-V3](https://embeddedmicro.com/products/mojo-v3). Mugato named after an 
alien in Star Trek The Original Series because how better to name a synth than
a sci-fi name? Also, it sounds a bit like legato!

## Development environment
As the Mojo uses a Xilinx Spartan 6 FPGA I'm using Xilinx's ISE as an IDE. I'm
also switching languages capriciously, now trying out Haskell

Because the Mojo-IDE only supports Verilog or Lucid projects I'm generating 
everything in ISE and using 
[mojo-loader](https://embeddedmicro.com/pages/mojo-loader) to program the board.
However, I will be moving to using yosys for synthesis to minimise the amount
of ISE as it's not updated and I don't consider it a stable piece of software.

For the eventual CAD design I plan on using FreeCAD to create models which I'll
print with my own Prusa-i3 clone.

## License
Mugato  is currently licensed under the terms of both the MIT license and the 
Apache License (Version 2.0). See LICENSE-MIT and LICENSE-APACHE for more details.
