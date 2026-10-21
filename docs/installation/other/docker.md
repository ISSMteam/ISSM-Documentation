---
title: Docker
layout: default
parent: Other
has_toc: false
---

# Installing ISSM on Docker
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

This guide covers installing ISSM on Docker with MATLAB. The image built in this example is [available on Docker Hub](https://hub.docker.com/repository/docker/downsj/issm){:target="_blank"}.

## Installing MATLAB on Docker

To install Matlab on Docker we will create a directory containing the full MATLAB installation files, a license file, and a text file with the installer configuration options,
```sh
mkdir docker_matlab
```
(or another name of your choosing). For the remainder of this tutorial, whenever we refer to `<MATLAB_DOCKER_DIR>` you should replace this placeholder with the actual name of the working directory that we are building the Docker image in.

Under a MATLAB Total Academic Headcount license made available through the University of Montana, I was able to get an installation key and license by:
- logging into my MathWorks account
- clicking the account profile icon in the right top menu bar and selecting 'My Account'
- clicking the 'View All Licenses' button
- expanding the accordion fold for the desired license
- clicking the 'View License <LICENSE_NUMBER> Details' link
- clicking the 'Activate to Retrieve License File' link
- clicking the 'Activate a Computer' button

The MATLAB license is tied to a specific username and MAC address, so in order to get it to work in Docker:
- specify the login name as "root" (which is the Docker default)
- set the 'Host ID' to 02:42:ac:11:00:02

<img src="/ISSM-Documentation/assets/img/docs/installation/other/docker/mathworks-install-and-activate-1.png" alt="'Manually Activate Software on a Computer' form on MathWorks website 'License Center'" />

{: .highlight-title }
> Note
>
> The MAC address in the Docker container needs to match the MAC address in the license file; this can be specified at runtime.

Click the 'Continue' button. On the following form, select "No" in the 'Is the software installed?' radio buttons.

<img src="/ISSM-Documentation/assets/img/docs/installation/other/docker/mathworks-install-and-activate-2.png" alt="'Software Installation on' form on MathWorks website 'License Center'" />

Click the 'Continue' button. Take note of the 'File Installation Key' as you will need this for the MATLAB installation in the Docker image. Click the 'Download License File' button.

<img src="/ISSM-Documentation/assets/img/docs/installation/other/docker/mathworks-install-and-activate-3.png" alt="'Next Steps to use the software on' form on MathWorks website 'License Center'" />

Save the license file to `<MATLAB_DOCKER_DIR>`. Then, create a text file called `installer_input.txt` with the following contents,
```sh
fileInstallationKey=<FILE_INSTALLATION_KEY>
agreeToLicense=yes
outputFile=log.txt
licensePath=../license.lic
```
replacing `<FILE_INSTALLATION_KEY>` with the file installation key you received.

Download the MATLAB installer from the license center and run it. Login with your MathWorks account, accept the license agreement, then under advanced options, select 'I want to download without installing'. Download the files to `<MATLAB_DOCKER_DIR>/matlab`.

The `<MATLAB_DOCKER_DIR>` directory should now have a license file (`license.lic`), the `installer_input.txt` file, and a directory called `matlab` containing MATLAB' installation files. Create a `dockerfile` called "Dockerfile" in `<MATLAB_DOCKER_DIR>` with the following contents,
```sh
# Ubuntu parent image
FROM ubuntu:20.04

# Instal x11 libs
RUN apt-get update
RUN apt-get install -y libx11-6
RUN apt-get install -y emacs

# Copy the file from your host to your current location
WORKDIR /home/issm

# Add MATLAB files
ADD matlab ./matlab
ADD installer_input.txt ./
ADD license.lic license.lic ./

# Install MATLAB
WORKDIR /home/issm/matlab/
RUN ./install -inputFile  ../installer_input.txt

# Create MATLAB alias with desktop disabled
RUN echo 'alias matlab="/usr/local/MATLAB/<MATLAB_VER>/bin/matlab -nojvm -nodesktop"' >> ~/.bashrc
```
replacing `<MATLAB_VER>` with the version of the MATLAB installation files that you downloaded and installed to your Docker image working directory (`<MATLAB_DOCKER_DIR>/matlab/`).

{: .highlight-title }
> Note
>
> You can probably remove the line to install Emacs somehow. I did this because it's my preferred editor, and incidentally it installed some other dependencies that helped the MATLAB installation actually work. 

From the `<MATLAB_DOCKER_DIR>` directory, build the Docker image with,
```sh
docker build -f Dockerfile -t ubuntu/matlab .
```

Upon completion, you can verify the installation by starting an interactive session and running MATLAB,
```sh
docker run -t -i --mac-address 02:42:ac:11:00:02 ubuntu/issm
root@<MACHINE_NAME>:/home/issm/matlab# matlab
MATLAB is selecting SOFTWARE OPENGL rendering.

                                                    < M A T L A B (R) >
                                          Copyright 1984-2020 The MathWorks, Inc.
                                          R2020a (9.8.0.1323502) 64-bit (glnxa64)
                                                     February 25, 2020

 
For online documentation, see https://www.mathworks.com/support
For product information, visit www.mathworks.com.
 
>> 
```

## Installing ISSM on Docker

To install ISSM from source, create a new directory called `docker_issm` (or another name of your choosing). For the remainder of this tutorial, whenever we refer to `<ISSM_DOCKER_DIR>` you should replace this placeholder with the actual name of the working directory that we are building the ISSM Docker image in.

We'll build off the MATLAB Docker image that we built previously.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} into `<ISSM_DOCKER_DIR>`. Create a `dockerfile` called "Dockerfile" in `<ISSM_DOCKER_DIR>` with contents,
```sh
# Build on the MATLAB image
FROM ubuntu/matlab

# Dependencies
RUN apt-get install -y libtool cmake autotools-dev curl python python-numpy g++ gfortran unzip patch git

# Add ISSM source
WORKDIR /home/issm/
ADD trunk-jpl ./trunk-jpl

# Set environment var
ENV ISSM_DIR=/home/issm/trunk-jpl/
RUN ["/bin/bash", "-c", "source ${ISSM_DIR}/etc/environment.sh"]

# Install external packages
WORKDIR ${ISSM_DIR}/externalpackages/petsc
RUN ./install-3.12-linux.sh
WORKDIR ${ISSM_DIR}/externalpackages/triangle
RUN ./install-linux.sh
WORKDIR ${ISSM_DIR}/externalpackages/chaco
RUN ./install.sh
WORKDIR ${ISSM_DIR}/externalpackages/m1qn3
RUN ./install.sh
WORKDIR ${ISSM_DIR}/externalpackages/semic
RUN ./install.sh

# Configure and run
WORKDIR ${ISSM_DIR}
RUN autoreconf -ivf 
RUN ./configure \
    --prefix="${ISSM_DIR}" \
	--with-numthreads=2 \
	--with-matlab-dir="/usr/local/MATLAB/<MATLAB_VER>/" \
	--with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
	--with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib/ -lmpi -lmpicxx -lmpifort" \
	--with-fortran-lib="-L/usr/lib/x86_64-linux-gnu/ -lgfortran" \
	--with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
	--with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install"

RUN make
RUN make install

# A fix to get stuff to run in MATLAB
WORKDIR /usr/local/MATLAB/<MATLAB_VER>/sys/os/glnxa64/
RUN mkdir OLD
RUN mv libstdc++.so* OLD/
RUN mv libgcc_s.so* OLD/
RUN ln -s /usr/lib/libstd* .
RUN ln -s /lib/libgcc_s.so* .

WORKDIR /home/issm/
```
again, replacing `<MATLAB_VER>` with the version of the MATLAB installation files that you downloaded and installed to your MATLAB Docker image working directory (`<MATLAB_DOCKER_DIR>/matlab/`).

From the `<ISSM_DOCKER_DIR>` directory, build the Docker image with,
```sh
docker build -f Dockerfile -t ubuntu/issm .
```

To run an interactive session use,
```sh
docker run -t -i --mac-address 02:42:ac:11:00:02 ubuntu/issm
```
