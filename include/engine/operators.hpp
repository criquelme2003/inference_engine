#pragma once
#include "operation.hpp"
#include <string>

class Add : public Operation {
public:
  std::string input1, input2, output;
  using Operation::Operation; // hereda constructor
  void execute(std::vector<std::string> inputs,
               std::vector<std::string> outputs) override;
};

class Relu : public Operation {
public:
  std::string input, output;

  using Operation::Operation;
  void execute(std::vector<std::string> inputs,
               std::vector<std::string> outputs) override;
};

class Matmul : public Operation {
public:
  std::string input1, input2, output;
  using Operation::Operation;
  void execute(std::vector<std::string> inputs,
               std::vector<std::string> outputs) override;
};

class Softmax : public Operation {
public:
  std::string input, output;

  using Operation::Operation;
  void execute(std::vector<std::string> inputs,
               std::vector<std::string> outputs) override;
};