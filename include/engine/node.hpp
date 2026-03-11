#pragma once

#include <vector>
#include <string>
#include "types.hpp"

class Node {
  public:
    std::vector<std::string> inputs;
    std::vector<std::string> outputs;
    OperationType operation;
}