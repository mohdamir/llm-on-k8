# LLM-on-K8 🚀

**Deployment templates to run Large Language Models (LLMs) efficiently on Kubernetes clusters.**  
Optimized for NVIDIA GPUs (A100/H100/RTX), autoscaling, and production-grade reliability.

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![NVIDIA](https://img.shields.io/badge/NVIDIA-GPU-76B900?logo=nvidia)
![LLM](https://img.shields.io/badge/LLM-Mixtral%2CLlama%2CBGE-blue)

---

## 📌 Features

- **🚀 GPU-Accelerated**  
  Templates for NVIDIA GPUs (A100, H100, RTX 4090) with CUDA-aware scheduling.
- **🔧 Multi-Model Support**  
  Pre-configured for:
  - Mixtral-8x7B (FP8/FP16)
  - Llama 3 70B (4-bit AWQ/GPTQ)
  - BGE-M3 embeddings
- **⚡ Optimized Inference**  
  Uses `vLLM`, `TensorRT-LLM`, and `TGI` for high throughput.
- **☸️ Kubernetes-Native**  
  Helm charts, Kustomize manifests, and GPU autoscaling.
- **🔒 Secure**  
  Built-in auth (OAuth2, API keys) and network policies.

---

## 🛠️ Quick Start

### Prerequisites
- Kubernetes cluster with **NVIDIA GPU nodes** (tested on GKE/EKS/AKS).
- `kubectl` and `docker` installed.
- NVIDIA drivers + `nvidia-device-plugin` deployed.

### Deploy Llama 3 70B (4-bit AWQ)
```bash
# Clone the repo
git clone https://github.com/your-username/llm-on-k8.git
cd llm-on-k8

# Deploy with K8


llm-on-k8/
├── deployments/          # Deployment files for different llms
│   ├── llama3-70b-awq/   # 4-bit quantized Llama 3
│   ├── mixtral-fp8/      # FP8 Mixtral-8x7B
│   └── bge-m3/           # BGE embedding model
└── docs/                 # Advanced configs

🤝 Contributing

Fork the repo.
Add your model configs
Submit a PR!


