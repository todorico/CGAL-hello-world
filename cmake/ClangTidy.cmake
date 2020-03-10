macro(enable_clang_tidy toggle)

    option(ENABLE_CLANG_TIDY "Enable static analysis with clang-tidy" ${toggle})

    if(ENABLE_CLANG_TIDY)

        find_program(CLANG_TIDY clang-tidy)

        if(CLANG_TIDY)

            message(STATUS "Activated clang-tidy")
            set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY})

        else()

            message(SEND_ERROR "clang-tidy requested but executable not found")
            return()

        endif()

    endif()

endmacro()
