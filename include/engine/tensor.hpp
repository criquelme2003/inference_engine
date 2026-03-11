#pragma once

#include "types.hpp"
#include <vector>

class Tensor {
public:
  void *data;
  std::vector<int> dims;
  std::size_t total_size;
  DeviceType device;
  DataType dataType;

  Tensor(void *data, std::vector<int> &dims, std::size_t total_size,
         DataType dataType, DeviceType device);
};