# ============================================================================
# ESRGAN ONNX Export Dockerfile
# NVIDIA CUDA 12.4 devel + PyTorch 2.4 + BasicSR + ONNX tools
#
# Build:  docker build -t esrgan-onnx:latest -f Dockerfile .
# Run:    docker run --gpus all -it -v $(pwd):/workspace esrgan-onnx:latest
# ============================================================================

FROM nvidia/cuda:12.4.0-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    CUDA_HOME=/usr/local/cuda \
    PATH=/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# ============================================================================
# System dependencies
# ============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake git wget curl ca-certificates \
    python3.10 python3.10-dev python3.10-distutils python3-pip \
    libopencv-dev python3-opencv \
    libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libxext6 \
    pkg-config ninja-build \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 && \
    python3.10 -m pip install --upgrade pip setuptools wheel

# ============================================================================
# PyTorch 2.4.0 + CUDA 12.4 + torchvision 0.19.0
# ============================================================================
RUN pip install --no-cache-dir \
    torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 \
    --index-url https://download.pytorch.org/whl/cu124

RUN python3 -c "import torch; print(f'✓ PyTorch {torch.__version__}'); print(f'✓ CUDA: {torch.cuda.is_available()}')"

# ============================================================================
# BasicSR from GitHub with torchvision compatibility patch
# ============================================================================
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/xinntao/BasicSR.git && cd BasicSR && \
    python3 << 'PATCH' && \
    pip install --no-cache-dir -e . && \
    python3 -c "from basicsr.archs.rrdbnet_arch import RRDBNet; print('✓ BasicSR RRDBNet imported')"
import sys, types
try:
    from torchvision.transforms.functional_tensor import rgb_to_grayscale
except ImportError:
    from torchvision.transforms.functional import rgb_to_grayscale
functional_tensor = types.ModuleType("torchvision.transforms.functional_tensor")
functional_tensor.rgb_to_grayscale = rgb_to_grayscale
sys.modules["torchvision.transforms.functional_tensor"] = functional_tensor
print("✓ Applied torchvision compatibility patch")
PATCH

# ============================================================================
# ONNX ecosystem + ML tools
# ============================================================================
RUN pip install --no-cache-dir \
    onnx==1.16.0 onnxruntime-gpu==1.18.0 onnx-simplifier==0.4.36 \
    numpy==1.24.3 pillow==10.0.0 opencv-python-headless==4.8.0.76 \
    scikit-image==0.21.0 scipy==1.11.2 imageio==2.32.0 \
    pyyaml==6.0 tqdm==4.66.1 requests==2.31.0 \
    jupyter tensorboard ipython

# ============================================================================
# Workspace setup
# ============================================================================
WORKDIR /workspace
RUN mkdir -p models inputs outputs

# Export helper script
RUN cat > export_esrgan.py << 'SCRIPT'
#!/usr/bin/env python3
import torch, argparse
from basicsr.archs.rrdbnet_arch import RRDBNet

def export_esrgan(model_path, output_path, scale=4, opset_version=11):
    model = RRDBNet(num_in_ch=3, num_out_ch=3, num_feat=64, num_block=23, num_grow_ch=32, scale=scale)
    ckpt = torch.load(model_path, map_location='cpu')
    if 'params_ema' in ckpt:
        model.load_state_dict(ckpt['params_ema'])
    elif 'params' in ckpt:
        model.load_state_dict(ckpt['params'])
    else:
        model.load_state_dict(ckpt)
    
    model.eval()
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    model = model.to(device)
    dummy_input = torch.randn(1, 3, 64, 64, device=device)
    
    print(f"📦 Loading: {model_path}")
    print(f"🔄 Exporting to ONNX...")
    torch.onnx.export(model, dummy_input, output_path, 
                     input_names=['input'], output_names=['output'],
                     dynamic_axes={'input': {2: 'height', 3: 'width'}, 
                                  'output': {2: 'height', 3: 'width'}},
                     opset_version=opset_version, do_constant_folding=True, verbose=False)
    print(f"✅ Exported to: {output_path}")
    print(f"   Input:  [1, 3, H, W]")
    print(f"   Output: [1, 3, {scale}*H, {scale}*W]")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Export ESRGAN to ONNX')
    parser.add_argument('--model-path', type=str, required=True, help='Path to ESRGAN .pth file')
    parser.add_argument('--output-path', type=str, default='models/esrgan.onnx', help='Output path')
    parser.add_argument('--scale', type=int, default=4, help='Upscale factor')
    parser.add_argument('--opset', type=int, default=11, help='ONNX opset version')
    args = parser.parse_args()
    export_esrgan(args.model_path, args.output_path, args.scale, args.opset)
SCRIPT

RUN chmod +x export_esrgan.py

# ============================================================================
# Verification
# ============================================================================
RUN python3 << 'VERIFY'
import torch, torchvision, onnx, onnxruntime
print("\n" + "="*60)
print("ESRGAN ONNX Export Environment")
print("="*60)
print(f"PyTorch:         {torch.__version__}")
print(f"torchvision:     {torchvision.__version__}")
print(f"ONNX:            {onnx.__version__}")
print(f"ONNX Runtime:    {onnxruntime.__version__}")
print(f"CUDA available:  {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA Device:     {torch.cuda.get_device_name(0)}")
    props = torch.cuda.get_device_properties(0)
    print(f"Compute Cap:     {props.major}.{props.minor}")
print("="*60)
print("✓ Ready for ESRGAN ONNX export!\n")
VERIFY

ENV PYTHONPATH=/workspace:${PYTHONPATH}
ENTRYPOINT ["/bin/bash"]
CMD ["-c", "python3 -c \"print('\\n📦 ESRGAN ONNX Export Container Ready!\\n'); print('Usage: python export_esrgan.py --model-path models/RealESRGAN_x4plus.pth --output-path models/esrgan_x4.onnx\\n')\" && /bin/bash"]