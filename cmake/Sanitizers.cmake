
set(SANITIZERS "")

macro(enable_sanatizer_address toggle)
    option(ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${toggle})
    if(ENABLE_SANITIZER_ADDRESS)
        list(APPEND SANITIZERS "address")
    endif()
endmacro()

macro(enable_sanatizer_memory toggle)
    option(ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" ${toggle})
    if(ENABLE_SANITIZER_MEMORY)
        list(APPEND SANITIZERS "memory")
    endif()
endmacro()

macro(enable_sanatizer_undefined_behavior toggle)
    option(ENABLE_SANITIZER_UNDEFINED_BEHAVIOR "Enable undefined behavior sanitizer" ${toggle})
    if(ENABLE_SANITIZER_UNDEFINED_BEHAVIOR)
        list(APPEND SANITIZERS "undefined")
    endif()
endmacro()

macro(enable_sanatizer_thread toggle)
    option(ENABLE_SANITIZER_THREAD "Enable thread sanitizer" ${toggle})
    if(ENABLE_SANITIZER_THREAD)
        list(APPEND SANITIZERS "thread")
    endif()
endmacro()

# After first this macro do nothing
macro(try_add_sanitizers project_name)

    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

        if(SANITIZERS)
            list(JOIN SANITIZERS "," LIST_OF_SANITIZERS)
            message(STATUS "Activated sanatizers : ${LIST_OF_SANITIZERS}")
            target_compile_options(${project_name} INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
            target_link_libraries(${project_name} INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
        endif()

    else()
        message(STATUS "Sanatizers only supported for gcc / clang")
    endif()

endmacro()
