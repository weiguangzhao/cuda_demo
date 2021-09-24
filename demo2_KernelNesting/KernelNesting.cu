/*
#_*_coding : UTF-8_*_
# Code writer: Weiguang.Zhao
# Writing time: 2021/9/24  下午10:56
# File Name: KernelNesting
# IDE: CLion
*/
#include <stdio.h>
__global__ void  sub_kernel( )
{
    int th_index = blockIdx.x*blockDim.x + threadIdx.x;
    printf("-------> sub_kernel thread number: %d \n", th_index);
}

__global__ void  kernel( )
{
    int th_index = blockIdx.x*blockDim.x + threadIdx.x;
    printf("-------> kernel thread number: %d \n", th_index);
//    sub_kernel<<<2,2>>>();
    kernel<<<2,2>>>();
}

int main(void )
{
    kernel<<<2,2>>>();
    cudaDeviceReset();
    return 0;
}