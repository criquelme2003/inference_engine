
#include "operation.hpp"
#include "operators.hpp"
#include <functional>
#include <unordered_map>

class OperatorRegistry {
  public:
      // Constructor directo, sin getInstance ni init
      OperatorRegistry(std::unordered_map<std::string, Tensor>& repo) {
          registry = {
              { OperationType::ADD,     new Add(repo) },
              { OperationType::RELU,    new Relu(repo) },
              { OperationType::MATMUL,  new Matmul(repo) },
              { OperationType::SOFTMAX, new Softmax(repo) },
          };
      }
  
      Operation* getOperation(OperationType type) {
          return registry.at(type);
      }
  
  private:
      std::unordered_map<OperationType, Operation*> registry;
  };