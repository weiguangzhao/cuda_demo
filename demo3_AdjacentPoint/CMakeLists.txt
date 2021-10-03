cmake_minimum_required(VERSION 3.19)
project(AdjacentPoint)

set(CMAKE_CXX_STANDARD 14)

# packages
find_package(CUDA REQUIRED)

if(${CUDA_FOUND})
    set(CUDA_SOURCE_PROPERTY_FORMAT OBJ)
    set(CUDA_SEPARABLE_COMPILATION ON)
    include_directories(${CUDA_INCLUDE_DIRS})
    set(CUDA_PROPAGATE_HOST_FLAGS OFF)

    #    set(CUDA_VERBOSE_BUILD ON)
    SET(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS};-gencode arch=compute_75,code=sm_75;-std=c++14; -rdc=true;  -lcudadevrt)

    link_directories(/usr/local/cuda/lib64)
    MESSAGE(STATUS "found cuda")
else(${CUDA_FOUND})
    MESSAGE(STATUS "cuda not found!")
endif(${CUDA_FOUND})


file(GLOB CURRENT_SOURCES  *.cpp *.cu)
file(GLOB_RECURSE CURRENT_HEADERS  *.h *.hpp *.cuh)

source_group("Source" FILES ${CURRENT_SOURCES})
source_group("Include" FILES ${CURRENT_HEADERS})

CUDA_ADD_EXECUTABLE(AdjacentPoint ${CURRENT_HEADERS} ${CURRENT_SOURCES} ${CUDA_INCLUDE_DIRS})
target_link_libraries(AdjacentPoint /usr/local/cuda/lib64/libcudadevrt.a)

