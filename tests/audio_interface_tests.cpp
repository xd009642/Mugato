#include <boost/test/included/unit_test.hpp>
#include <iostream>
#include <testbench.h>
#include <Vaudio_interface.h>

namespace test = boost::unit_test;

BOOST_AUTO_TEST_CASE( basic_test) {
    //Verilated::commandArgs(argc, argv);
    tb::testbench<Vaudio_interface> dut;

    dut.open_trace("audiointerface-basic.vcd");
    int update_limit = 100;
    while(!dut.done() && update_limit) {
        dut.tick();
        update_limit--;
    }
    BOOST_CHECK(true);
}

BOOST_AUTO_TEST_CASE(reset_test) {
    //Verilated::commandArgs(argc, argv);
    tb::testbench<Vaudio_interface> dut;

    dut.open_trace("audiointerface-reset.vcd");
    int update_limit = 100;
    while(!dut.done() && update_limit) {
        if(update_limit == 50) {
            dut.reset();
        } else {
            dut.tick();
        }
        update_limit--;
    }
    BOOST_CHECK(true);
}

test::test_suite* init_unit_test_suite(int argc, char** argv) {
    test::framework::master_test_suite().p_name.value = "Audio interface test suite";
    Verilated::commandArgs(argc, argv);
    return nullptr;
}

