## Makefile for the project used to make tests

CXXFLAGS=-g -std=c++11

# Generate verilator files 
VERIGEN := verilator -cc 
VERIGENTRACE := verilator -trace -cc
# Make verilator generated files
VERIMAKE := $(MAKE) --no-print-directory -C obj_dir -f 


ifeq ($(VERILATOR_ROOT),)
VERILATOR_DIR := /usr/local/share/verilator
else
VERILATOR_DIR := $(VERILATOR_ROOT)
endif

VOBJ_DIR := obj_dir
TESTS_DIR := tests
INCLUDE_DIR := -Iobj_dir -I$(VERILATOR_DIR)/include -Itests
SOURCE_FILES := $(VERILATOR_DIR)/include/verilated.cpp $(VERILATOR_DIR)/include/verilated_vcd_c.cpp

$(VOBJ_DIR)/%.o: %.cpp
	$(CXX) $(INCLUDE_DIR) -c $< -o $@

.PHONY: all
all: tests 

.PHONY: clean
clean:
	rm -rf $(VOBJ_DIR)

.PHONY: tests
tests: clean
	# Generate test code then make.
	$(VERIGENTRACE) src/audio_interface.v	
	$(VERIGEN) src/mojo_top.v	
	
	$(VERIMAKE) Vaudio_interface.mk
	$(VERIMAKE) Vmojo_top.mk

	#$(MAKE) 
	
	$(CXX) $(INCLUDE_DIR) $(SOURCE_FILES) $(TESTS_DIR)/ai_tb.cpp -o audio_interface
