#include <iostream>

__global__ void mykernel(void) {

}

__global__ void add(int *a, int *b, int *c){
    c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

#define N 512

int main(void){
    mykernel<<<1,1>>>();
    std::cout << "wow" << std::endl;

    int *a, *b, *c;  // Host variables
    int *x, *y, *z;  // Device variables
    int size = N * sizeof(int);

    cudaMalloc((void **)&x, size);
    cudaMalloc((void **)&y, size);
    cudaMalloc((void **)&z, size);

    // Set Input
    a = (int *)malloc(size);
    b = (int *)malloc(size);
    c = (int *)malloc(size);
    // std::random_ints(a, N);
    // std::random_ints(b, N);

    // Copy from host to device
    cudaMemcpy(x, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(y, b, size, cudaMemcpyHostToDevice);

    // Run the 'add' kernel
    add<<<N,1>>>(x, y, z);

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