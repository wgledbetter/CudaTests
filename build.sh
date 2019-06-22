#!/bin/sh

COMPILER=clang++
CPP_FLAGS="-std=c++17 -O3 -pedantic -Wall"
CUDA_FLAGS="--cuda-gpu-arch=sm_61"
INCLUDE="-I/opt/rh/devtoolset-7/root/usr/local/include/c++/7"

$COMPILER $CPP_FLAGS $CUDA_FLAGS $INCLUDE ./main.cu -o ./a.out