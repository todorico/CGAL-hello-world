# check_ipo_supported need       : cmake_minimum 3.9.6
# target_precompile_headers need : cmake_minimum 3.16.4
cmake_minimum_required(VERSION 3.16.4)

project(CGAL-hello-world VERSION 0.1.0 LANGUAGES CXX)

#
# Build Settings
#

include(cmake/BuildSettings.cmake)
try_enable_ccache(OFF)
try_enable_ipo(OFF) # Slowdown linking and give better binaries (Unix only)

# Interface for build options (link this with target to set c++ standard / compile-time options etc...)
add_library(project_build_options INTERFACE)
# target_compile_features(project_build_options INTERFACE cxx_std_11)

#
# Compiler Warnings
#

include(cmake/CompilerWarnings.cmake)
add_compiler_warnings(project_build_options)

#
# Sanitizers
#

# Sanatizing address with memory or with thread is not combinable
include(cmake/Sanitizers.cmake)
enable_sanatizer_address(OFF)
enable_sanatizer_memory(OFF)
enable_sanatizer_thread(OFF)
enable_sanatizer_undefined_behavior(OFF)
try_add_sanitizers(project_build_options) # Must be called last

#
# Static Analyzers
#

include(cmake/Cppcheck.cmake)
enable_cppcheck(OFF)

include(cmake/ClangTidy.cmake)
enable_clang_tidy(OFF)

#
# Documentation
#

include(cmake/Doxygen.cmake)
enable_doxygen(OFF)

#
# Dependencies
#

if(NOT DEFINED CGAL_DIR)

	if(EXISTS ${CMAKE_SOURCE_DIR}/CGAL-5.0.1/build)
    	set(CGAL_DIR ${CMAKE_SOURCE_DIR}/CGAL-5.0.1/build) # CGAL shared
        message(STATUS "Found CGAL Shared lib directory, compilation will be faster !")
	else()
    	set(CGAL_DIR ${CMAKE_SOURCE_DIR}/CGAL-5.0.1) # CGAL header-only
    	message(STATUS "Cannot found CGAL Shared Lib directory, compilation will be slower !")
	endif()

endif()

message(STATUS "Using CGAL version from ${CGAL_DIR}")

add_definitions(-DCGAL_USE_BASIC_VIEWER -DQT_NO_KEYWORDS) # Required to use basic_viewer with CGAL

find_package(CGAL REQUIRED COMPONENTS Qt5)

if(NOT CGAL_FOUND OR NOT CGAL_Qt5_FOUND)
    message(STATUS "This project requires the CGAL library With Qt5 extention, and will not be compiled.")
    return()
endif()

find_package(Boost REQUIRED)

if(NOT Boost_FOUND)
    message(STATUS "This project requires the Boost library, and will not be compiled.")
    return()
endif()

target_link_libraries(project_build_options INTERFACE CGAL::CGAL CGAL::CGAL_Qt5)

#
# Project Building
#

add_executable(hello src/hello.cpp)

if(${CMAKE_VERSION} VERSION_LESS "3.16.4") 
    message(STATUS "CMake cannot precompile headers, please consider using CMake 3.16.4 for faster compilation !")
else()
    message(STATUS "CMake can precompile headers, compilation will be faster on second run !")
    target_precompile_headers(hello PUBLIC src/cgal_pch.hpp)
endif()

target_link_libraries(hello PRIVATE project_build_options)
