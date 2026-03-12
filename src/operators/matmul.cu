
#include "operators.hpp"
#include "tensor.hpp"
#include <string>
#include <vector>

void Matmul::execute(std::vector<std::string> inputs,
                     std::vector<std::string> outputs) {

  input1 = inputs[0];
  input2 = inputs[1];
  output = outputs[0];

  Tensor tInput1 = tensorRepository.at(input1);
  Tensor tInput2 = tensorRepository.at(input2);
  Tensor tOutput = tensorRepository.at(output);
  return;
};