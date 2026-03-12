#pragma once

#include "types.hpp"
#include <string>
#include <vector>

class Node {
public:
  std::vector<std::string> inputs;
  std::vector<std::string> outputs;
  OperationType operation;

  Node(std::vector<std::string> _inputs, std::vector<std::string> _outputs,
       OperationType _operation) {
    
    inputs = _inputs;
    outputs = _outputs;
    operation = _operation;
  }
};