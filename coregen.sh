#!/bin/sh

echo "Cleaning generated IP folder and regenerating"
rm -rf gen
mkdir gen
cd gen

python3 ../coregen/cordic_gen.py --stages 3 --phasebits 15 --out cordic.vhd
