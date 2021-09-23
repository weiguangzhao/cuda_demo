//
// Created by bruno on 2021/7/2.
//
#include <stdio.h>
__global__ void  hellofromgpu(void )
{
    printf("Hello World from GPU\n");
}

int main(void )
{
    printf("hello from cpu\n");
    hellofromgpu<<<1,10>>>();
    cudaDeviceReset();
    return 0;
}