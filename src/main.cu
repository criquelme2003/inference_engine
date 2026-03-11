#include <iostream>
#include <fstream>
#include "onnx/onnx-ml.pb.h"

int main() {

    onnx::ModelProto model;

    std::ifstream input("/workspace/models/model.onnx", std::ios::binary);

    if (!model.ParseFromIstream(&input)) {
        std::cout << "Error loading ONNX\n";
        return 1;
    }

    std::cout << "Producer_name " << model.producer_name() << std::endl;
    std::cout << "Producer_version: " << model.producer_version() << std::endl;

    return 0;
}