#include "executor.hpp"

// executor.cpp
void Executor::run(Graph &graph) {
  for (Node &node : graph.nodes) {
    Operation *op = graph.registry.getOperation(node.operation);
    op->execute(node.inputs, node.outputs);
  }
};
