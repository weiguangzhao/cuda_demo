/*
#_*_coding : UTF-8_*_
# Code writer: Weiguang.Zhao
# Writing time: 2021/10/3  下午7:09
# File Name: AdjacentPoint
# IDE: CLion
*/
#include <stdio.h>
#include <stdlib.h>

#include "cuda_config.h"
#include "AdjacentPoint.h"

// https://stackoverflow.com/a/14038590
#define CUDA_ERR_CHK(code) { cuda_err_chk((code), __FILE__, __LINE__); }
inline void cuda_err_chk(cudaError_t code, const char *file, int line, bool abort = true) {
    if (code != cudaSuccess) {
        fprintf(stderr, "\tCUDA ERROR: %s %s %d\n", cudaGetErrorString(code), file, line);
        if (abort) exit(code);
    }
}

__global__ void checkNearPoints_cuda(int *point_num_d, float *xyz_d, float *eps_d, int *ptsCnt_d){
    int th_index = blockIdx.x*blockDim.x + threadIdx.x;
    if (th_index >= *point_num_d) return ;

    ptsCnt_d[th_index] = 0;  // the number of adjacent points
    float o_x = xyz_d[th_index * 3 + 0];
    float o_y = xyz_d[th_index * 3 + 1];
    float o_z = xyz_d[th_index * 3 + 2];

    for (int k =0; k< *point_num_d; k++){
        if(th_index==k) continue;

        float k_x = xyz_d[k * 3 + 0];
        float k_y = xyz_d[k * 3 + 1];
        float k_z = xyz_d[k * 3 + 2];
        float l2 = sqrt((k_x-o_x)*(k_x-o_x)+(k_y-o_y)*(k_y-o_y)+(k_z-o_z)*(k_z-o_z));
        if (l2 <= *eps_d) {
            ptsCnt_d[th_index]= ptsCnt_d[th_index] + 1;
        }
    }
}

void checkNearPoints(const int point_num, float xyz[], const float radius){
    dim3 blocks(DIVUP(point_num, THREADS_PER_BLOCK));
    dim3 threads(THREADS_PER_BLOCK);


    int * ptsCnt_h;
    ptsCnt_h = (int *)malloc(point_num * sizeof(int));

    // define gpu variable
    int * point_num_d;
    float * xyz_d;
    float * radius_d;
    int * ptsCnt_d; //mark the number of adjacent points


    //generate gpu ram
    CUDA_ERR_CHK( cudaMalloc((void **) &point_num_d, sizeof(int)));
    CUDA_ERR_CHK(cudaMalloc((void **) &xyz_d, 3*point_num*sizeof(float)));
    CUDA_ERR_CHK(cudaMalloc((void **) &radius_d, sizeof(float)));
    CUDA_ERR_CHK(cudaMalloc((void **) &ptsCnt_d, point_num*sizeof(int)));


    // copy host to device
    CUDA_ERR_CHK(cudaMemcpy(point_num_d, &point_num, sizeof(int), cudaMemcpyHostToDevice));
    CUDA_ERR_CHK(cudaMemcpy(xyz_d, xyz, 3*point_num*sizeof(float), cudaMemcpyHostToDevice));
    CUDA_ERR_CHK(cudaMemcpy(radius_d, &radius, sizeof(float), cudaMemcpyHostToDevice));

    // start device kernel
    checkNearPoints_cuda<<<blocks, threads>>>(point_num_d, xyz_d, radius_d, ptsCnt_d);

    // copy device to host
    CUDA_ERR_CHK(cudaMemcpy(ptsCnt_h, ptsCnt_d, point_num*sizeof(float), cudaMemcpyDeviceToHost));

    // release gpu ram
    CUDA_ERR_CHK(cudaFree(point_num_d));
    CUDA_ERR_CHK(cudaFree(xyz_d));
    CUDA_ERR_CHK(cudaFree(radius_d));
    CUDA_ERR_CHK(cudaFree(ptsCnt_d));

    for (int i =0; i< point_num; i++){
        printf("index: %d adjacent point number: %d \n",i, ptsCnt_h[i]);
    }

}