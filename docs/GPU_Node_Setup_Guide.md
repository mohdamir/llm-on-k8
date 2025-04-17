
# GPU Node Setup and Deployment Guide

## 1. Install NVIDIA Drivers and CUDA

### Step 1: Update the System

```bash
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install NVIDIA Driver

```bash
sudo apt install -y nvidia-driver-535
sudo reboot
```

### Step 3: Verify GPU Detection

```bash
nvidia-smi
```

### Step 4: Install CUDA

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update
sudo apt install -y cuda
```

### Step 5: Set Up Environment Variables

```bash
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## 2. Configure Docker with NVIDIA Runtime

### Step 1: Install Docker

```bash
sudo apt install -y docker.io
```

### Step 2: Install NVIDIA Container Toolkit

```bash
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt install -y nvidia-container-toolkit
```

### Step 3: Configure Docker to Use NVIDIA Runtime

```bash
sudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
```

#### Restart Docker:

```bash
sudo systemctl restart docker
```

### Step 4: Verify GPU Access in Docker

```bash
docker run --rm --gpus all nvidia/cuda:11.8.0-base nvidia-smi
```

---

## 3. Install NVIDIA GPU Plugin on Kubernetes

### Step 1: Add Helm Repository and Install Plugin

```bash
helm repo add nvidia https://nvidia.github.io/k8s-device-plugin
helm repo update
helm install --generate-name nvidia/k8s-device-plugin
```

### Step 2: Verify GPU Availability in Kubernetes

```bash
kubectl get nodes -o json | jq '.items[].status.allocatable'
```

---

## 4. Deploy a Model on Kubernetes

### Step 1: Apply Deployment

```bash
kubectl apply -f deployment.yaml
```

### Step 2: Check Logs and Running Pods

```bash
kubectl get pods -n default
kubectl logs <pod-name> -n default
```

---

## 5. Troubleshooting

### Check GPU Utilization

```bash
nvidia-smi
```

### Check Kubernetes GPU Resources

```bash
kubectl describe node <node-name>
```

### Restart NVIDIA Plugin

```bash
kubectl delete pod -n kube-system -l name=nvidia-device-plugin
```

---

This document provides all necessary steps to set up an NVIDIA GPU node, configure Kubernetes, and deploy a model using Kubernetes with GPU acceleration.
