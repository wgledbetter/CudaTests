#!/bin/sh

COMPILER=clang++
CPP_FLAGS="-std=c++17 -O3 -pthread -fPIC"
OUTPUT_FLAGS="-Wall" # -v"
CUDA_FLAGS="--cuda-gpu-arch=sm_61"
INCLUDE="-isystem /home/wgledbetter/Install/LLVM/include/c++/v1/"
LIBS="-L/opt/rh/devtoolset-7/root/usr/lib/gcc/x86_64-redhat-linux/7/ -L/usr/local/cuda-10.1/lib64 -lcudart_static -ldl -lrt -lc++"

CUDA_FNAME="clang_test.cu"

$COMPILER $OUTPUT_FLAGS $CPP_FLAGS $CUDA_FLAGS $INCLUDE $LIBS ./$CUDA_FNAME -o ./a.out

# clang++ -fPIC -isystem /home/wgledbetter/Install/LLVM/include/c++/v1/ clang_test.cu -o a.out --cuda-gpu-arch=sm_61 -L/opt/rh/devtoolset-7/root/usr/lib/gcc/x86_64-redhat-linux/7/ -L/usr/local/cuda-10.1/lib64 -lc++ -lcudart_static -ldl -lrt -pthread