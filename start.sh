#!/bin/bash

# Start SSH server
/usr/sbin/sshd

# Create default JupyterLab workspace
mkdir -p /home/instructlab/.jupyter/lab/workspaces
echo '{}' > /home/instructlab/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace
chown -R instructlab:instructlab /home/instructlab/.jupyter

# Start FileBrowser
filebrowser users add instructlab instructlab --database /home/instructlab/filebrowser.db --perm.admin
chown -R instructlab:instructlab /home/instructlab/*
filebrowser -a 0.0.0.0 -p 8080 -r /home/instructlab --database /home/instructlab/filebrowser.db &

# Start JupyterLab as instructlab user
su - instructlab -c "jupyter lab --no-browser --ip=0.0.0.0 --port=8888 --ServerApp.token='' --ServerApp.password=''" &

# Start ttyd web terminal and expose it on 8822
su - instructlab -c "ttyd --port 8822 --writable --debug 7 /bin/bash" &

# Keep the container running
tail -f /dev/null
