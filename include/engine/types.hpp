#pragma once

enum class OperationType {
  MATMUL,
  ADD,
  RELU,
  SOFTMAX
};

enum class DataType {
  FLOAT16,
  INT,
};

enum class DeviceType {
  CUDAGPU,
  CPU,
};





