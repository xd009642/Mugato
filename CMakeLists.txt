cmake_minimum_required(VERSION 3.12)

project(tests)

list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

find_package(verilator)
find_package(Boost COMPONENTS system filesystem unit_test_framework REQUIRED)

if(NOT verilator_FOUND)
    message(FATAL_ERROR "Verilator was not found. Consider setting the VERILATOR_ROOT environment variable")
endif()

set(TEST_SOURCE
    tests/audio_interface_tests.cpp)

include_directories(tests ${Boost_INCLUDE_DIRS})

add_executable(audio_interface_tests ${TEST_SOURCE})
target_link_libraries(audio_interface_tests ${Boost_LIBRARIES})
verilate(audio_interface_tests TRACE SOURCES src/audio_interface.v)

add_executable(cordic_tests tests/cordic_tests.cpp)
target_link_libraries(cordic_tests ${Boost_LIBRARIES})
verilate(cordic_tests TRACE SOURCES gen/cordic.v)
