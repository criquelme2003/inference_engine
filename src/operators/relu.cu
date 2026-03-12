
#include "operators.hpp"
#include "tensor.hpp"
#include <string>
#include <vector>

void Relu::execute(std::vector<std::string> inputs,
                   std::vector<std::string> outputs) {

  input = inputs[0];
  output = outputs[0];

  Tensor tInput1 = tensorRepository.at(input);
  Tensor tOutput = tensorRepository.at(output);

  return;
};