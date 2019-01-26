cmake_minimum_required(VERSION 3.8)

#Prefer VERILATOR_ROOT from environment
if (DEFINED ENV{VERILATOR_ROOT})
    set(VERILATOR_ROOT "$ENV{VERILATOR_ROOT}" CACHE PATH "VERILATOR_ROOT")
else()
    # if no environment one set the compiled in default
    set(VERILATOR_ROOT "/usr/local/share/verilator")
endif()

find_file(VERILATOR_BIN NAMES verilator_bin verilator_bin.exe HINTS ${VERILATOR_ROOT}/bin NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH)

if (NOT VERILATOR_ROOT)
    message(FATAL_ERROR "VERILATOR_ROOT cannot be detected. Set it to the appropriate directory (e.g. /usr/share/verilator) as an environment variable or CMake define.")
endif()


if (NOT VERILATOR_BIN)
    message(FATAL_ERROR "Cannot find verilator_bin excecutable.")
endif()

set(verilator_FOUND 1)

#Check flag support. Skip on MSVC, these are all GCC flags.
if (NOT (DEFINED VERILATOR_CFLAGS OR CMAKE_CXX_COMPILER_ID MATCHES MSVC))
    include(CheckCXXCompilerFlag)
    foreach (FLAG faligned-new fbracket-depth=4096 Qunused-arguments Wno-bool-operation Wno-parentheses-equality
                  Wno-sign-compare Wno-uninitialized Wno-unused-but-set-variable Wno-unused-parameter
                  Wno-unused-variable Wno-shadow)
        string(MAKE_C_IDENTIFIER ${FLAG} FLAGNAME)
        check_cxx_compiler_flag(-${FLAG} ${FLAGNAME})
        if (${FLAGNAME})
            set(VERILATOR_CFLAGS ${VERILATOR_CFLAGS} -${FLAG})
        endif()
    endforeach()
endif()

function(verilate TARGET)
    cmake_parse_arguments(VERILATE "TRACE;SYSTEMC" "NAME;TOP" "SOURCES;ARGS;INCLUDEDIRS;SLOW_FLAGS;FAST_FLAGS" ${ARGN})
    if (NOT VERILATE_TOP)
        list(GET VERILATE_SOURCES 0 TOPSRC)
        get_filename_component(VERILATE_TOP ${TOPSRC} NAME_WE)
    endif()
    if (NOT VERILATE_NAME)
        set(VERILATE_NAME V${VERILATE_TOP})
    endif()

    if (VERILATE_TRACE)
        set(VERILATE_ARGS -trace ${VERILATE_ARGS})
        #If any verilate() call specifies TRACE, define VM_TRACE in the final build
        set_property(TARGET ${TARGET} PROPERTY VERILATOR_TRACE TRUE)
    endif()
    get_property(TRACE TARGET ${TARGET} PROPERTY VERILATOR_TRACE SET)

    file(GLOB VERILATOR_SOURCE ${VERILATOR_ROOT}/include/*.cpp)
    
    if (VERILATE_SYSTEMC)
        set(VERILATE_ARGS ${VERILATE_ARGS} --sc)
        list(FILTER VERILATOR_SOURCE EXCLUDE REGEX ".*_c.cpp$")
    else()
        set(VERILATE_ARGS ${VERILATE_ARGS} --cc)
        list(FILTER VERILATOR_SOURCE EXCLUDE REGEX ".*_sc.cpp$")
        # Don't know what VPI is but it's giving me issues so removing it
        list(FILTER VERILATOR_SOURCE EXCLUDE REGEX ".*_vpi.cpp$")
    endif()

    foreach(D ${VERILATE_INCLUDEDIRS})
        set(VERILATE_ARGS ${VERILATE_ARGS} -y "${D}")
    endforeach()

    set(DIR ${CMAKE_CURRENT_BINARY_DIR}/${VERILATE_NAME})
    file(MAKE_DIRECTORY ${DIR})

    string(TOLOWER ${CMAKE_CXX_COMPILER_ID} COMPILER)
    if (NOT COMPILER MATCHES "msvc|clang")
        set(COMPILER gcc)
    endif()

    execute_process(
        COMMAND ${VERILATOR_BIN} -Wall -Wno-fatal --compiler ${COMPILER} 
        --top-module ${VERILATE_TOP} --prefix ${VERILATE_NAME} -Mdir ${DIR} 
        ${VERILATE_ARGS} ${VERILATE_SOURCES}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

    message(INFO " Executed process ${VERILATOR_SOURCE}")

    target_include_directories(${TARGET} PUBLIC
        ${DIR} 
        ${VERILATOR_ROOT}/include 
        ${VERILATOR_ROOT}/include/vltstd)

    file(GLOB VSRCS ${DIR}/*.cpp)
    # So all the recommended verilator stuff has you include the source and build it
    # instead of using it like a library. So I work under the assumption everyone
    # is doing that with their installs..

    message(INFO " ${VSRCS}")
    target_sources(${TARGET} PUBLIC
        ${VSRCS}
        ${VERILATOR_SOURCE}
    )
    
endfunction(verilate)
