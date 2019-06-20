#include <iostream>

#define N 2560
#define M 512
#define BLOCK_SIZE (N/M)
#define RADIUS 5

__global__ void mykernel(void) {

}

__global__ void add(double *a, double *b, double *c, int n){
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < n){
        c[idx] = a[idx] + b[idx];
    }
}

__global__ void stencil_1D(int *in, int *out){
    // This is similar to a convolution in the neural network sense

    __shared__ int temp[BLOCK_SIZE + 2*RADIUS];  // Memory that is shared across threads within a block
    int gindex = threadIdx.x + blockIdx.x * blockDim.x;  // Global index (in)
    int lindex = threadIdx.x + RADIUS;  // Local index (temp)

    // Read inputs into shared memory
    temp[lindex] = in[gindex];
    if(threadIdx.x < RADIUS){
        temp[lindex - RADIUS] = in[gindex - RADIUS];
        temp[lindex + BLOCK_SIZE] = in[gindex + BLOCK_SIZE];
    }

    // Synchronize (ensure all threads have run above code before any proceed to following)
        // Necessary for filling temp
    __syncthreads();

    // Apply stencil
    int result = 0;
    for(int offset = -RADIUS; offset <= RADIUS; offset++){
        result += temp[lindex + offset];
    }

    // Store
    out[gindex] = result;
}

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

    return 12;
}