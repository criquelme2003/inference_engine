
#include "operation.hpp"
#include "tensor.hpp"
#include <string>
#include <vector>

class Softmax : public Operation {
private:
  std::string input, output;

public:
  using Operation::Operation; // CONSTRUCTOR
  void execute(std::vector<std::string> inputs,
               std::vector<std::string> outputs) {

    input = inputs[0];
    output = outputs[0];

    Tensor tInput1 = tensorRepository[input];
    Tensor tOutput = tensorRepository[output];
    return;
  }
};