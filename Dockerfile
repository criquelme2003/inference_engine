FROM nvidia/cuda:12.5.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    python3-pybind11 \
    pybind11-dev \
    libprotobuf-dev \
    protobuf-compiler \
    wget \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /workspace

COPY requirements.txt .
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --upgrade cmake && \
    python3 -m pip install --no-cache-dir -r requirements.txt
COPY . .

RUN mkdir -p extern && \
    cd extern && \
    git clone --depth 1 https://github.com/dmlc/dlpack.git && \
    git clone --recursive https://github.com/onnx/onnx.git && \
    cd onnx && mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release \
             -DONNX_ML=ON \
             -DONNX_USE_PROTOBUF_SHARED_LIBS=ON && \
    make -j$(nproc)