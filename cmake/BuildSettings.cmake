set(CMAKE_CXX_FLAGS_DEBUGFAST
    "-Og"
    CACHE STRING "Flags used by the C++ compiler to compile optimise debugging." FORCE)

# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to 'RelWithDebInfo' as none was specified.")
    set(CMAKE_BUILD_TYPE
        RelWithDebInfo
        CACHE STRING "Choose the type of build." FORCE)
    # Set the possible values of build type for cmake-gui, ccmake
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo" "DebugFast")
endif()

# Generate compile_commands.json to make it easier to work with clang based tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Use ccache to build faster when developing
macro(try_enable_ccache toggle)

    option(ENABLE_CCACHE "help string describing ENABLE_CCACHE" ${toggle})

    if(ENABLE_CCACHE)
        find_program(CCACHE ccache)
        if(CCACHE)
            # message(STATUS "Detected ccache : compilation will be cached")
            message(STATUS "Found ccache : ${CCACHE}")
            set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE})
            # set(CCACHE_SLOPPINESS "pch_defines,time_macros") # Compatibility with precompiled headers
        else()
            message(STATUS "Cannot detect ccache : compilation will not be cached")
        endif()
    endif()

endmacro()

# Linking time optimisation (compilation is longer)
macro(try_enable_ipo toggle)

    option(ENABLE_IPO "Enable Iterprocedural Optimization, aka Link Time Optimization (LTO)" ${toggle})

    if(ENABLE_IPO)
        include(CheckIPOSupported)
        check_ipo_supported(RESULT result OUTPUT output)
        if(result)
            message(STATUS "Activated IPO")
            set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
        else()
            message(STATUS "IPO is not supported: ${output}")
        endif()
    endif()

endmacro()
