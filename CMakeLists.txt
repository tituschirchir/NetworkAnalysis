cmake_minimum_required(VERSION 3.5.1)
project(NetworkAnalysis)

set(CMAKE_CXX_STANDARD 11)

add_executable(NetworkAnalysis main.cpp Bank.cpp Bank.h Network.cpp Network.h)