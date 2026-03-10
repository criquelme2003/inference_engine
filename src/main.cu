#include <iostream>
#include <fstream>
#include "onnx/onnx-ml.pb.h"

int main() {

    onnx::ModelProto model;

    std::ifstream input("model.onnx", std::ios::binary);

    if (!model.ParseFromIstream(&input)) {
        std::cout << "Error loading ONNX\n";
        return 1;
    }

    std::cout << "Nodes: " << model.graph().node_size() << std::endl;

    return 0;
}