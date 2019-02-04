#include <boost/test/included/unit_test.hpp>
#include <iostream>
#include <testbench.h>
#include <Vcordic.h>

namespace test = boost::unit_test;

BOOST_AUTO_TEST_CASE(basic_drive) {
    tb::testbench<Vcordic> dut;
    dut.open_trace("cordic_driven.vcd");
    uint16_t phase = 0;
    size_t update_limit = 1'000'000;
    dut.reset();
    dut.tick();
    dut.ip_core().x_in = 0;
    dut.ip_core().y_in = 1;

    dut.ip_core().phase_in = 0;
    while(!dut.done() && update_limit) {
        dut.tick();
        dut.ip_core().phase_in+=100;
        update_limit--;
    }
}


test::test_suite* init_unit_test_suite(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    return nullptr;
}

