
#include "operation.hpp"
#include <string>
#include <vector>
#include "tensor.hpp"
class Matmul : public Operation {
private:
  std::string input1, input2, output;

public:
  using Operation::Operation; // CONSTRUCTOR
  void execute(std::vector<std::string> inputs,
               std::vector<std::string> outputs) {
    
    input1 = inputs[0];
    input2 = inputs[1];
    output = outputs[0];

    Tensor tInput1 = tensorRepository[input1];
    Tensor tInput2 = tensorRepository[input2];
    Tensor tOutput = tensorRepository[output];
    return;
  }
};