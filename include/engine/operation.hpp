#pragma once
#include <string>
#include <vector>
#include <unordered_map>
#include "tensor.hpp"

class Operation {
public:
  std::unordered_map<std::string, Tensor> tensorRepository;
  Operation(std::unordered_map<std::string, Tensor> &tensorRepository)
      : tensorRepository(tensorRepository) {

        };

  virtual void execute(std::vector<std::string> inputs, std::vector<std::string> outputs) {
    
  }
};