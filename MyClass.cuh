class MyClass {
public:
    double hostParam;
    double *devParam;
    const size_t dubSize = sizeof(double);

    int nCudaBlocks = 1;
    int nCudaThreadsPerBlock = 1;

    MyClass(){
        cudaMalloc((void **)&devParam, dubSize);
    }

    ~MyClass(){
        cudaFree(devParam);
    }

    void set_param(double in){
        hostParam = in;
        cudaMemcpy(devParam, &hostParam, dubSize, cudaMemcpyHostToDevice);
    }

    double do_it_on_host(){
        double out;
        hostKernel(&hostParam, &out);
        return out;
    }

    double do_it_on_device(){
        double *devOut, out;
        cudaMalloc((void **)&devOut, dubSize);
        devKernel<<< nCudaBlocks, nCudaThreadsPerBlock >>>(devParam, devOut);
        cudaMemcpy(&out, devOut, dubSize, cudaMemcpyDeviceToHost);
        return out;
    }

    __global__ static void devKernel(double *param, double *ans){
        // Cuda implementation
        std::printf("Inside devKernel: ");
        *ans = *param + 3.14;
    }

    void hostKernel(double *param, double *ans){
        // Host implementation
        std::cout << "Inside hostKernel: " << "wow" << std::endl;
        *ans = *param + 3.14;
    }
};