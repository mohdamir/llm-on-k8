#!/bin/bash

set -e

echo "🚀 Starting A100 Node Setup..."

# 1. Update & Upgrade System
echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# 2. Install NVIDIA Driver (535 is compatible with A100)
echo "🎯 Installing NVIDIA Driver 535..."
sudo apt install -y nvidia-driver-535
echo "✅ Driver installed. Please reboot after this script completes."

# 3. Verify GPU Access
echo "🖥️ Verifying GPU access (post-reboot)..."
nvidia-smi || echo "⚠️ Please reboot the system and re-run this step if nvidia-smi fails."

# 4. Install CUDA 12.1
echo "📦 Installing CUDA 12.1..."
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update
sudo apt install -y cuda-toolkit-12-1

# 5. Add CUDA to PATH
echo "⚙️ Setting CUDA environment variables..."
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# 6. Install Docker
echo "🐳 Installing Docker..."
sudo apt install -y docker.io

# 7. Install NVIDIA Container Toolkit for Docker GPU support
echo "🔌 Installing NVIDIA Container Toolkit..."
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt install -y nvidia-container-toolkit

# 8. Configure Docker runtime
echo "⚙️ Configuring Docker runtime to use NVIDIA GPU..."
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
EOF

echo "🔄 Restarting Docker..."
sudo systemctl restart docker

# 9. Test Docker with GPU
echo "🔍 Testing Docker GPU access..."
sudo docker run --rm --gpus all nvidia/cuda:12.1.0-base nvidia-smi

# 10. (Optional) Install NVIDIA K8s Device Plugin
read -p "❓ Do you want to install the NVIDIA Kubernetes GPU plugin? (y/n): " yn
if [[ "$yn" == "y" ]]; then
  echo "⎈ Installing NVIDIA device plugin on Kubernetes using Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  helm repo add nvidia https://nvidia.github.io/k8s-device-plugin
  helm repo update
  helm install --generate-name nvidia/k8s-device-plugin
  echo "✅ NVIDIA K8s plugin installed."
else
  echo "⏭️ Skipping Kubernetes GPU plugin installation."
fi

echo "🎉 Setup complete! Please reboot the machine if not already done."
