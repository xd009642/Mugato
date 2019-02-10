cmake_minimum_required(VERSION 3.12)

project(tests)

list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
find_package(ZLIB REQUIRED)
find_package(verilator)
find_package(Boost COMPONENTS system filesystem unit_test_framework REQUIRED)

if(NOT verilator_FOUND)
    message(FATAL_ERROR "Verilator was not found. Consider setting the VERILATOR_ROOT environment variable")
endif()

add_definitions(-DVL_THREADED)

set(TEST_SOURCE
    tests/audio_interface_tests.cpp)

set(COMMON_LIBS ${ZLIB_LIBRARIES} ${Boost_LIBRARIES} Threads::Threads)

include_directories(tests ${Boost_INCLUDE_DIRS})

add_executable(audio_interface_tests ${TEST_SOURCE})
target_link_libraries(audio_interface_tests ${COMMON_LIBS})
verilate(audio_interface_tests TRACE SOURCES src/audio_interface.v)

add_executable(cordic_tests tests/cordic_tests.cpp)
target_link_libraries(cordic_tests ${COMMON_LIBS})
verilate(cordic_tests TRACE SOURCES gen/cordic.v)
