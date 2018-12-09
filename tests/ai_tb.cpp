#include <testbench.h>
#include <Vaudio_interface.h>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    tb::testbench<Vaudio_interface> dut;

    dut.open_trace("audiointerface.vcd");

    while(!dut.done()) {
        dut.tick();
    }
    return 0;
}
