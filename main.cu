#include <iostream>
#include <stdio.h>

// #include "MyClass.h"
#include "MyCudaClass.cu"

#define N 2560
#define M 512
#define BLOCK_SIZE (N/M)
#define RADIUS 5

__host__ __device__ double hostSumFunction(int n, double m){
    return n+m;
}

struct MyStruct {
    __device__ __host__ MyStruct(int a, double b){
        x = a;
        y = b;
    }

    __device__ __host__ ~MyStruct(){

    }

    __device__ __host__ double get_sum(){
        return hostSumFunction(x, y);
    }

    int x;
    double y;
};

__global__ void add(double *a, double *b, double *c, int n){
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < n){
        c[idx] = a[idx] + b[idx];
    }
}

__global__ void cudaStructs(MyStruct *ms, double *ans){
    *ans = ms->get_sum();
}

int main(void){
    std::cout << "wow" << std::endl;

    double *a, *b, *c;  // Host variables
    double *x, *y, *z;  // Device variables
    const size_t size = size_t(N) * sizeof(double);

    cudaMalloc((void **)&x, size);
    cudaMalloc((void **)&y, size);
    cudaMalloc((void **)&z, size);

    // Set Input
    a = (double *)malloc(size);
    b = (double *)malloc(size);
    c = (double *)malloc(size);
    a[23] = 33.249;
    b[23] = -30.741;

    // Copy from host to device
    cudaMemcpy(x, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(y, b, size, cudaMemcpyHostToDevice);

    // Run the 'add' kernel
    add<<<N/M, M>>>(x, y, z, N);  // Asynchronous: CPU proceeds before this is finished

    // Copy answer from device to host
    cudaMemcpy(c, z, size, cudaMemcpyDeviceToHost);  // Waits until all previous CUDA calls have completed

    // Clean device
    cudaFree(x);
    cudaFree(y);
    cudaFree(z);

    // Clean Host
    free(a);
    free(b);
    free(c);

    std::cout << "Answer: " << c[23] << std::endl;

    //==============================================================

    MyStruct *devStruct;
    double hostAns;
    double *devAns;
    const size_t structSize = sizeof(MyStruct);
    const size_t ansSize = sizeof(double);

    cudaMalloc((void **)&devStruct, structSize);
    cudaMalloc((void **)&devAns, ansSize);

    // Set values
    MyStruct hostStruct(9, 3.14);
    std::cout << "Class member function on host: " << hostStruct.get_sum() << std::endl;

    // Copy struct to device
    cudaMemcpy(devStruct, &hostStruct, structSize, cudaMemcpyHostToDevice);
    
    // Run the kernel
    cudaStructs<<< 1, 1 >>>(devStruct, devAns);

    // Get answer back to host
    cudaMemcpy(&hostAns, devAns, ansSize, cudaMemcpyDeviceToHost);

    // Clean Device
    cudaFree(devStruct);
    cudaFree(devAns);

    // Answer
    std::cout << "Class member function on device: " << hostAns << std::endl;

    //===============================================================

    MyClass mc;
    mc.set_param(12.5);
    std::cout << "Calling Host class, Host member: " << mc.do_it_on_host() << std::endl;

    MyCudaClass mcc;
    mcc.set_param(12.5);
    std::cout << "Calling Cuda class, Host member: " << mcc.do_it_on_host() << std::endl;
    std::cout << "Calling Cuda class, Device member: " << mcc.do_it_on_device() << std::endl;


    return 12;
}