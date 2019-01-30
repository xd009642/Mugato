#include <boost/test/included/unit_test.hpp>
#include <iostream>
#include <testbench.h>
#include <Vcordic.h>

namespace test = boost::unit_test;

BOOST_AUTO_TEST_CASE(basic_drive) {
    tb::testbench<Vcordic> dut;
    dut.open_trace("cordic_driven.vcd");
    uint16_t phase = 0;
    size_t update_limit = 500;
    dut.reset();
    dut.tick();
    dut.ip_core().angle = 0;
    dut.ip_core().en = 1;
    dut.tick();
    dut.ip_core().en = 0;
    while(!dut.done() && update_limit) {
        if(dut.ip_core().done) {
            phase++;
            dut.ip_core().en = 1;
            dut.ip_core().angle = phase;
            dut.tick();
            dut.ip_core().en = 0;
        }
        dut.tick();
        update_limit--;
    }
}


test::test_suite* init_unit_test_suite(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    return nullptr;
}

