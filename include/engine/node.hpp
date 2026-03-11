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
    // TODO: COMPROBAR EXISTENCIA DE INPUTS Y OUTPUTS EN GRAPH->REGISTRY (BUSCAR PATRON DE DISEÑO PARA HACERLO)
    
    inputs = _inputs;
    outputs = _outputs;
    operation = _operation;
  }
};