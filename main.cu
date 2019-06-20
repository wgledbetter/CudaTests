#include <iostream>

__global__ void mykernel(void) {

}

__global__ void add(int *a, int *b, int *c){
    *c = *a + *b;
}

int main(void){
    mykernel<<<1,1>>>();
    std::cout << "wow" << std::endl;

    int a, b, c;  // Host variables
    int *x, *y, *z;  // Device variables
    int size = sizeof(int);

    cudaMalloc((void **)&x, size);
    cudaMalloc((void **)&y, size);
    cudaMalloc((void **)&z, size);

    a = 2;
    b = 7;

    // Copy from host to device
    cudaMemcpy(x, &a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(y, &b, size, cudaMemcpyHostToDevice);

    // Run the 'add' kernel
    add<<<1,1>>>(x, y, z);

    // Copy answer from device to host
    cudaMemcpy(&c, z, size, cudaMemcpyDeviceToHost);

    // Clean device
    cudaFree(x);
    cudaFree(y);
    cudaFree(z);

    std::cout << "Answer: " << c << std::endl;

    return 12;
}