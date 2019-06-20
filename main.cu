#include <iostream>

__global__ void mykernel(void) {

}

__global__ void add(double *a, double *b, double *c){
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    c[idx] = a[idx] + b[idx];
}

#define N 2560
#define THREADS_PER_BLOCK 512

int main(void){
    mykernel<<<1,1>>>();
    std::cout << "wow" << std::endl;

    double *a, *b, *c;  // Host variables
    double *x, *y, *z;  // Device variables
    int size = N * sizeof(double);

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
    add<<<N/THREADS_PER_BLOCK, THREADS_PER_BLOCK>>>(x, y, z);

    // Copy answer from device to host
    cudaMemcpy(c, z, size, cudaMemcpyDeviceToHost);

    // Clean device
    cudaFree(x);
    cudaFree(y);
    cudaFree(z);

    // Clean Host
    free(a);
    free(b);
    free(c);


    std::cout << "Answer: " << c[23] << std::endl;

    return 12;
}