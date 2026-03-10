#include <pybind11/pybind11.h>

namespace py = pybind11;

int test()
{
    return 42;
}

PYBIND11_MODULE(forgethreads, m)
{
    m.def("test", &test);
}