## Makefile for the project used to make tests

# Generate verilator files 
VERIGEN := verilator -cc 
VERIGENTRACE := verilator -trace -cc
# Make verilator generated files
VERIMAKE := $(MAKE) --no-print-directory -C obj_dir -f 


.PHONY: all
all: tests 

.PHONY: clean
clean:
	rm -rf obj_dir

.PHONY: tests
tests: clean
	# Generate test code then make.
	$(VERIGENTRACE) src/audio_interface.v	
	$(VERIMAKE) Vaudio_interface.mk
	$(VERIGEN) src/mojo_top.v	
	$(VERIMAKE) Vmojo_top.mk

	#$(MAKE) 
	
