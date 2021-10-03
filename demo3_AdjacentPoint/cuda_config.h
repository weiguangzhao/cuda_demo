/*
#_*_coding : UTF-8_*_
# Code writer: Weiguang.Zhao
# Writing time: 2021/9/23  下午6:40
# File Name: cuda_config
# IDE: CLion
*/
#ifndef CLUSTER_V1_CUDA_CONFIG_H
#define CLUSTER_V1_CUDA_CONFIG_H

#define TOTAL_THREADS 1024

#define THREADS_PER_BLOCK 512
#define DIVUP(m,n) ((m) / (n) + ((m) % (n) > 0))


#endif //CLUSTER_V1_CUDA_CONFIG_H
