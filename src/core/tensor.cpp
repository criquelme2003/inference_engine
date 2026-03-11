#include "tensor.hpp"

Tensor::Tensor(void *data, std::vector<int> &dims, std::size_t total_size,
               DataType dataType, DeviceType device)
    : data(data), dims(dims), total_size(total_size), dataType(dataType),
      device(device) {

      }

