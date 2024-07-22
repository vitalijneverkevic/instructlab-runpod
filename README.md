![Banner](https://github.com/instructlab/.github/blob/main/assets/instructlab-banner.png)
# Instruct Lab Docker Image for RunPod GPU Instances

This repository contains the Dockerfile and instructions to build and run the Instruct Lab image, which is optimized for NVIDIA CUDA and designed to be used primarily on RunPod GPU instances.

## Features

- **NVIDIA CUDA enabled**: Optimized for GPU instances on RunPod.
- **Integrated Tools**:
  - **JupyterLab**: Accessible on port 8888.
  - **ttyd web terminal**: Accessible on port 8822.
  - **Filebrowser.org file browser**: Accessible on port 8080.
  - **Internal SSH server**: Accessible on port 22/tcp.

## Table of Contents

- [Getting Started](#getting-started)
- [Build the Docker Image](#build-the-docker-image)
- [Run the Docker Container](#run-the-docker-container)
- [Accessing the Services](#accessing-the-services)
- [Instruct Lab Commands](#instruct-lab-commands)

## Getting Started

To get started with the Instruct Lab Docker image, you need to have Docker installed on your system. For instructions on how to install Docker, refer to the [official Docker documentation](https://docs.docker.com/get-docker/).

## Build the Docker Image

Clone this repository and build the Docker image using the provided Dockerfile.

```bash
git clone https://github.com/yourusername/instructlab-docker.git
cd instructlab-docker
docker build -t instructlab:latest .

# Instruct Lab Docker Setup Guide
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

## Instruct Lab Commands

Instruct Lab provides a variety of commands for interacting with models, data, and configurations. Below is a summary of some key commands.

### General Commands

- **Initialize Environment**: `ilab init`
- **View System Information**: `ilab sysinfo`

### Data Commands

- **Generate Synthetic Data**: `ilab data generate`
  - **Command Options**:
    - `--model`: Name of the model used during generation.
    - `--num-cpus`: Number of processes to use.
    - `--chunk-word-count`: Number of words to chunk the document.
    - `--num-instructions`: Number of instructions to generate.
    - `--taxonomy-path`: Path to taxonomy.
    - `--taxonomy-base`: Base git-ref for taxonomy.
    - `--output-dir`: Output directory for generated files.

### Model Commands

- **Chat with Model**: `ilab model chat`
- **Convert Model**: `ilab model convert`
- **Download Model**: `ilab model download`
- **Serve Model**: `ilab model serve`
- **Test Model**: `ilab model test`
- **Train Model**: `ilab model train`

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue on the repository.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Acknowledgments

- Instruct Lab
- RunPod

For more details, refer to the official InstructLab documentation.





