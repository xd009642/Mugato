#include <testbench.h>
#include <Vaudio_interface.h>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    tb::testbench<Vaudio_interface> dut;

    dut.open_trace("audiointerface.vcd");
    int update_limit = 100;
    while(!dut.done() && update_limit) {
        dut.tick();
        update_limit--;
    }
    return 0;
}
