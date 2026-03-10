#include <iostream>

__global__
void test_kernel()
{
}

int main()
{
    test_kernel<<<1,1>>>();
    cudaDeviceSynchronize();

    std::cout << "CUDA project compiled successfully!" << std::endl;

    return 0;
}