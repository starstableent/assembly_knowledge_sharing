cmake_minimum_required(VERSION 3.10)

project(Assembly_Knowledge_Sharing)

# Set C++ version and enable MASM
set(CMAKE_CXX_STANDARD 17)
enable_language(ASM_MASM)

# Examples
add_subdirectory(Examples/Branching)
add_subdirectory(Examples/Functions)
add_subdirectory(Examples/Common_Instructions)
add_subdirectory(Examples/Hello_World)
add_subdirectory(Examples/Interfacing_With_OS)