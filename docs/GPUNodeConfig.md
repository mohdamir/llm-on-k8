GPU Node Setup and Deployment Guide1. 

Install NVIDIA Drivers and CUDAStep 1: Update the Systemsudo apt update && sudo apt upgrade -yStep 2: Install NVIDIA Driversudo apt install -y nvidia-driver-535
rebootStep 3: Verify GPU Detectionnvidia-smiStep 4: Install CUDAwget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update
sudo apt install -y cudaStep 5: Set Up Environment Variablesecho 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc2. Configure Docker with NVIDIA RuntimeStep 1: Install Dockersudo apt install -y docker.ioStep 2: Install NVIDIA Container Toolkitcurl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt install -y nvidia-container-toolkitStep 3: Configure Docker to Use NVIDIA Runtimesudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOFRestart Docker:
sudo systemctl restart dockerStep 4: Verify GPU Access in Dockerdocker run --rm --gpus all nvidia/cuda:11.8.0-base nvidia-smi3. Install NVIDIA GPU Plugin on KubernetesStep 1: Add Helm Repository and Install Pluginhelm repo add nvidia https://nvidia.github.io/k8s-device-plugin
helm repo update
helm install --generate-name nvidia/k8s-device-pluginStep 2: Verify GPU Availability in Kuberneteskubectl get nodes -o json | jq '.items[].status.allocatable'4. 
Deploy a Model on KubernetesDeployment YAML Example

Step 1: Apply Deploymentkubectl apply -f deployment.yamlStep 2: Check Logs and Running Podskubectl get pods -n default
kubectl logs <pod-name> -n default5. TroubleshootingCheck GPU Utilizationnvidia-smiCheck Kubernetes GPU Resourceskubectl describe node <node-name>Restart NVIDIA Pluginkubectl delete pod -n kube-system -l name=nvidia-device-pluginThis document provides all necessary steps to set up an NVIDIA GPU node, configure Kubernetes, and deploy a model using Kubernetes with GPU acceleration.
