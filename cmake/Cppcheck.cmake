macro(enable_cppcheck toggle)

    option(ENABLE_CPPCHECK "Enable static analysis with cppcheck" ${toggle})

    if(ENABLE_CPPCHECK)

        find_program(CPPCHECK cppcheck)

        if(CPPCHECK)

        	message(STATUS "Activated cppcheck")
            # add --suppress=unmatchedSuppression to remove cppcheck unwanted short report
            set(CMAKE_CXX_CPPCHECK ${CPPCHECK} --enable=all --suppress=missingInclude --inconclusive)
        else()

            message(SEND_ERROR "cppcheck requested but executable not found")
            return()

        endif()

    endif()

endmacro()
