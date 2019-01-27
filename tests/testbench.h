#ifndef TESTBENCH_H
#define TESTBENCH_H

#include <verilated_vcd_c.h>
#include <memory>

//! Module for all testbench functions
namespace tb {
    
    //! Generic test bench
    template<class T>
    class testbench {

    public:
        //! ctor
        testbench() {
            // enabled vcd traces
            Verilated::traceEverOn(true);
            core = std::make_unique<T>();
        }

        virtual void open_trace(const std::string& filename) {
            if(!trace) {
                trace = std::make_unique<VerilatedVcdC>();
                core->trace(trace.get(), 99);
                trace->open(filename.data());
            }
        }

        virtual void close_trace() {
            if(trace) {
                trace->close();
            }
            trace.reset();
        }
        
        //! Resets the core
        virtual void reset() {
            core->rst = 1;
            tick();
            core->rst = 0;
        }

        //! Pulses the clock causing an update
        virtual void tick() {
            ticks++;
            core->clk = 0;
            core->eval();
            
            if(trace) {
                trace->dump(10 * ticks - 2);
            }

            core->clk = 1;
            core->eval();

            if(trace) {
                trace->dump(10*ticks);
            }

            core->clk = 0;
            core->eval();
            if(trace) {
                trace->dump(10 * ticks + 5);
                trace->flush();
            }
        }
        
        //! Returns true if the test is finished
        virtual bool done() {
            return Verilated::gotFinish();
        }

        const T& ip_core() const {
            return *core;
        }

        T& ip_core() {
            return *core;
        }

    protected:
        //! Pointer to the IP core under test
        std::unique_ptr<T> core;
        //! handle to the vcd
        std::unique_ptr<VerilatedVcdC> trace;
        //! count of ticks
        size_t ticks;
    };

}


#endif
