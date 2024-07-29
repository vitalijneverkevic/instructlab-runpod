![Banner](https://github.com/instructlab/.github/blob/main/assets/instructlab-banner.png)
# Instruct Lab Docker Image for RunPod GPU Instances

This is **experimental unofficial** repository that contains Dockerfile and instructions to build and run the Instruct Lab image, which is optimized for NVIDIA CUDA.
For official Instruct Lab repository please go to https://github.com/instructlab

## Features

- **NVIDIA CUDA enabled**: Optimized for GPU instances on RunPod.
- **Integrated Tools**:
  - **JupyterLab**: Accessible on port 8888.
  - **ttyd web terminal**: Accessible on port 8822.
  - **Filebrowser.org file browser**: Accessible on port 8080.
  - **Internal SSH server**: Accessible on port 22/tcp.


## Getting Started

To get started with the Instruct Lab Docker image, you need to have Docker installed on your system. For instructions on how to install Docker, refer to the [official Docker documentation](https://docs.docker.com/get-docker/).

## Build the Docker Image

Clone this repository and build the Docker image using the provided Dockerfile.

```bash
git clone https://github.com/yourusername/instructlab-docker.git
cd instructlab-docker
docker build -t instructlab:latest .

```

## Run the Docker Container

After building the Docker image, you can run a container with the following command:

```bash
docker run -d \
  -p 8888:8888 \
  -p 8080:8080 \
  -p 8822:8822 \
  -p 22:22 \
  --gpus all \
  --name instructlab \
  instructlab:latest
```

## Accessing the Services

Once the container is running, you can access the following services:

- **JupyterLab**: `http://<your-server-ip>:8888`
- **Filebrowser**: `http://<your-server-ip>:8080`
- **ttyd Terminal**: `http://<your-server-ip>:8822`
- **SSH**: Connect using your preferred SSH client to `ssh <your-server-ip> -p 22`


