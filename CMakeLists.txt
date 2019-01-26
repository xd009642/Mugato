cmake_minimum_required(VERSION 3.12)

project(tests)

list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

find_package(verilator)
find_package(Boost COMPONENTS system filesystem unit_test_framework REQUIRED)

if(NOT verilator_FOUND)
    message(FATAL_ERROR "Verilator was not found. Consider setting the VERILATOR_ROOT environment variable")
endif()

set(TEST_SOURCE
    tests/ai_tb.cpp)

include_directories(tests ${Boost_INCLUDE_DIRS})

add_executable(test_main ${TEST_SOURCE})

target_link_libraries(test_main ${Boost_LIBRARIES})

verilate(test_main TRACE SOURCES src/audio_interface.v)
