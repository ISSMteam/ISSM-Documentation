---
title: Kubeflow
layout: default
parent: Wiki
has_toc: false
---

# Kubeflow
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Rancher Desktop

<a href="https://rancherdesktop.io" target="_blank">Download Rancher Desktop</a> to your local machine, install it, and open it. 

## Docker Hub Account

<a href="https://app.docker.com/signup" target="_blank">Create a Docker Hub account</a>. You will also want to create a repository to push the custom images you build. Call it "deepxde".

Remember to log in to your Docker Hub account from your desktop. To do so, run,
```sh
docker login
```
then enter your password. You will only have to do this once. 

## Building a Custom Image

Make `deepxde/` your working directory, then create a `dockerfile` called "Dockerfile" with contents,
```sh
FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter-tensorflow-cuda-full:v1.3.0-rc.1

USER root

RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt-get install -y --no-install-recommends imagemagick libopenmpi-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER $NB_UID

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir  -f \
 https://www.paddlepaddle.org.cn/whl/linux/mkl/avx/stable.html \
 && rm -f /tmp/requirements.txt
```

In the same directory, create another file called "requirements.txt" with contents,
```sh
ipython
numpy
scipy
tensorflow
scikit-learn
matplotlib
scikit-optimize
seaborn
tensorflow-probability
torch
torchvision
torchaudio
jax
flax
optax
paddlepaddle-gpu==2.4.2.post112
jupyter
jupyterlab
notebook
pandas
mpi4py
deepxde
mat73
```
You can add or remove the packages as needed.

Now, to build the custom image for macOS, run,
```sh
docker buildx build --platform linux/amd64 -t <USERNAME>/deepxde:<TAG> .
```
replacing `<USERNAME>` with your Docker Hub username and `<TAG>` with the image tag of your choosing. For example, your image tag could be "v1" to indicate version one of the image you are building.

## Pushing to Docker Hub

After building the image, push to Docker Hub with,
```sh
docker push <USERNAME>/deepxde:<TAG>
```

## Kubeflow

Go to the Notebooks tab and create a new server. Select 'custom image' and enter `<USERNAME>/deepxde:<TAG>`. Choose the number of CPUs and GPUs (NVIDIA) you wish to use, and select your existing volume. Once this is done, you will be able to launch the server.

