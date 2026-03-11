#pragma once

#include <vector>
#include "types.hpp"

class Tensor{
  public:
    *void data;
    DataType dataType;
    std::vector<int> dims;
    DeviceType device;
    size_t total_size;

    virtual Tensor(*void &data,
      std::vector<int> &dims,
      size_t total_size;){}
      DataType dataType,
      DeviceType device,
}