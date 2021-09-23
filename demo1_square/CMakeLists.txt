cmake_minimum_required(VERSION 3.19)
project(demo1_square)

set(CMAKE_CXX_STANDARD 14)

# packages
find_package(CUDA REQUIRED)
if(${CUDA_FOUND})
    set(CUDA_SOURCE_PROPERTY_FORMAT OBJ)
    set(CUDA_SEPARABLE_COMPILATION ON)
    include_directories(${CUDA_INCLUDE_DIRS})
    set(CUDA_PROPAGATE_HOST_FLAGS OFF)
    set(CUDA_NVCC_FLAGS -arch=sm_75;-O3;-G;-g;-std=c++11)# 根据具体GPU性能更改算力参数
    #SET(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS};-gencode arch=compute_61,code=sm_61;-std=c++11;-O3;-G;-g)
    link_directories($ENV{CUDA_PATH}/lib/x64)
    MESSAGE(STATUS "found cuda")
else(${CUDA_FOUND})
    MESSAGE(STATUS "cuda not found!")
endif(${CUDA_FOUND})

file(GLOB CURRENT_SOURCES  *.cpp *.cu)
file(GLOB_RECURSE CURRENT_HEADERS  *.h *.hpp *.cuh)

source_group("Source" FILES ${CURRENT_SOURCES})
source_group("Include" FILES ${CURRENT_HEADERS})

CUDA_ADD_EXECUTABLE(demo1_square ${CURRENT_HEADERS} ${CURRENT_SOURCES})