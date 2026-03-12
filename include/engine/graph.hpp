#include "node.hpp"
#include "operator_registry.hpp"
#include "tensor.hpp"
#include <string>
#include <unordered_map>
#include <vector>

// graph.hpp

class Graph {
public:
    std::vector<Node> nodes;
    std::unordered_map<std::string, Tensor> tensors;
    OperatorRegistry registry;  // ← atributo directo

    Graph(std::vector<Node> nodes, 
          std::unordered_map<std::string, Tensor> tensors)
        : nodes(nodes), 
          tensors(tensors),
          registry(tensors)  // ← se inicializa con los tensores del grafo
    {}
};
