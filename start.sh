#!/bin/bash

# Start SSH server
/usr/sbin/sshd

# Start ttyd web terminal and expose it on 8822
su - instructlab -c "ttyd --port 8822 --writable --debug 7 /bin/bash" &

# Start FileBrowser
filebrowser users add instructlab instructlab --database /home/instructlab/filebrowser.db --perm.admin
chown instructlab:instructlab /home/instructlab/filebrowser.db
filebrowser -a 0.0.0.0 -p 8080 -r /home/instructlab --database /home/instructlab/filebrowser.db &


# Create default JupyterLab workspace
#su - instructlab -c "mkdir -p /home/instructlab/.jupyter/lab/workspaces"
#su - instructlab -c "echo '{}' > /home/instructlab/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace"
#chown instructlab:instructlab /home/instructlab/.jupyter

# Ensure secure permissions for Jupyter configuration files and directories
#find /home/instructlab/.jupyter -type d -exec chmod 700 {} \;  # Directories
#find /home/instructlab/.jupyter -type f -exec chmod 600 {} \;  # Files
# Set default umask
#umask 0027

# Set the variable
export JUPYTER_ALLOW_INSECURE_WRITES=True

# Start JupyterLab as instructlab user
su - instructlab -c "mkdir -p /home/instructlab/workspaces && cd /home/instructlab && \
    jupyter lab \
    --no-browser \
    --ip=0.0.0.0 \
    --port=8888 \
    --FileContentsManager.delete_to_trash=False \
    --ServerApp.token='' \
    --ServerApp.allow_origin='*' \
    --ServerApp.preferred_dir='/home/instructlab/workspaces'" &

# Keep the container running
tail -f /dev/null

