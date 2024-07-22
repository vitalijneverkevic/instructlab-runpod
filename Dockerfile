# Use the NVIDIA CUDA base image
FROM nvcr.io/nvidia/cuda:12.4.1-devel-ubi9

# Install necessary packages
RUN dnf update -y && dnf install -y \
    sudo \
    openssh-server \
    python3.11 \
    python3.11-devel \
    python3-pip \
    wget \
    vim \
    nodejs \
    && dnf clean all


# Create instructlab user
RUN useradd -m -s /bin/bash instructlab
RUN echo 'instructlab:instructlab' | chpasswd
RUN echo 'root:instructlab' | chpasswd
RUN usermod -aG wheel instructlab


# Set up a directory with correct ownership 
WORKDIR /home/instructlab
RUN chown -R instructlab:instructlab /home/instructlab


# Allow instructlab to use sudo without password
RUN echo "instructlab ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Set up SSH server
RUN mkdir /var/run/sshd
RUN ssh-keygen -A
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# Install JupyterLab
RUN pip3 install jupyterlab 
RUN pip3 install notebook
#RUN jupyter contrib nbextension install --user \
#    && jupyter nbextension enable --py widgetsnbextension


# Configure JupyterLab
RUN mkdir -p /home/instructlab/.jupyter
RUN echo "c.ServerApp.ip = '0.0.0.0'" >> /home/instructlab/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.port = 8888" >> /home/instructlab/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.token = ''" >> /home/instructlab/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.password = ''" >> /home/instructlab/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.allow_origin = '*'" >> /home/instructlab/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.allow_remote_access = True" >> /home/instructlab/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.disable_check_xsrf = True" >> /home/instructlab/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.authenticate_prometheus = False" >> /home/instructlab/.jupyter/jupyter_server_config.py


# Install Filebrowser.org to manage files 
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
RUN filebrowser config init
RUN filebrowser config set -a 0.0.0.0
RUN filebrowser config set -p 8080
RUN filebrowser config set -r /home/instructlab
RUN filebrowser users add instructlab instructlab --perm.admin


# Download and install ttyd web terminal 
RUN wget https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 -O /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

####################### INSTALATION OF INSTRUCTLAB ###############################################

# Install Python3.11 with other dependencies 
RUN dnf install -y python3.11 python3.11-devel git python3-pip make automake gcc gcc-c++

# Set the working dir and assign correct permissions 
WORKDIR /home/instructlab/instructlab
RUN chown -R instructlab:instructlab /home/instructlab/instructlab

# Ensure pip package manager is installed 
RUN python3.11 -m ensurepip

# Enable EPEL repository 
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# Enable CUDA repositories 
RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo \
    && dnf repolist \
    && dnf config-manager --set-enabled cuda-rhel9-x86_64 \
    && dnf config-manager --set-enabled cuda \
    && dnf config-manager --set-enabled epel && dnf update -y

# Install NVidia CUDA with dependencies 
RUN dnf install -y libcudnn8 nvidia-driver-NVML nvidia-driver-cuda-libs

# Install Python/CUDA 
RUN python3.11 -m pip install --force-reinstall nvidia-cuda-nvcc-cu12

# Set up CUDA on a correct path 
RUN export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64" \
    && export CUDA_HOME=/usr/local/cuda \
    && export PATH="/usr/local/cuda/bin:$PATH" \
    && export XLA_TARGET=cuda120 \
    && export XLA_FLAGS=--xla_gpu_cuda_data_dir=/usr/local/cuda

ARG GIT_TAG=stable

# Install InstructLab dependencies 
RUN if [[ "$(uname -m)" != "aarch64" ]]; then export CFLAGS="-mno-avx"; fi \
    && CMAKE_ARGS="-DLLAMA_CUBLAS=on" \
	python3.11 -m pip install -r https://raw.githubusercontent.com/instructlab/instructlab/${GIT_TAG}/requirements.txt --force-reinstall --no-cache-dir llama-cpp-python

# Install InstructLab software 
RUN python3.11 -m pip install git+https://github.com/instructlab/instructlab.git@${GIT_TAG}

LABEL com.redhat.component="instructlab"


##################################################################################################

# Copy a Welcome Message Script 
COPY motd /etc/motd

# Make sure message is being displayed to a user 
RUN echo 'cat /etc/motd' >> /home/instructlab/.bashrc
RUN echo 'cat /etc/motd' >> /root/.bashrc

# Copy the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports
EXPOSE 22 8888 8822 8080

# Set the start script as the entry point
CMD ["/start.sh"]
