/*
#_*_coding : UTF-8_*_
# Code writer: Weiguang.Zhao
# Writing time: 2021/9/23  下午2:29
# File Name: square
# IDE: CLion
 */

# include "square.h"
#include <stdio.h>


__global__ void square(float * d_out, float * d_in){
    int idx = threadIdx.x;
    float f =d_in[idx];
    d_out[idx] = f*f;
};

void square_test(){

    // 定义数组长度和位数
    int array_size = 64;
    int array_bytes = array_size * sizeof(float);

    // 产生数组
    float h_in[array_size];  //输入数组
    for (int  i=0; i< array_size; i++){
        h_in[i] = float(i);
    }
    float h_out[array_size]; //存储结果

    // 定义GPU内存指针
    float * d_in;
    float * d_out;

    // 分配GPU内存
    cudaMalloc((void **) &d_in, array_bytes);
    cudaMalloc((void **) &d_out, array_bytes);

    // 把CPU数据搬到GPU上
    cudaMemcpy(d_in, h_in, array_bytes, cudaMemcpyHostToDevice);

    // 运行cuda内核开始计算
    square<<<1, array_size>>>(d_out, d_in);

    // 把运算结果搬回CPU
    cudaMemcpy(h_out, d_out, array_bytes, cudaMemcpyDeviceToHost);

    // 打印结果
    for (int i =0; i< array_size; i++){
        printf("%f \n", h_out[i]);
    }

    // 释放GPU内存
    cudaFree(d_in);
    cudaFree(d_out);
}