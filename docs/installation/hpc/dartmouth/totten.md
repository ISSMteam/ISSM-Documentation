---
title: Totten
layout: default
parent: Dartmouth
machine_name: "Totten"
has_toc: false
---

# {{ page.machine_name }} (hosted by EAPS)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

{: .highlight-title }
> Important
>
> {{ page.machine_name }} has several drives. Your home directory is on a small drive (6 TB), so make sure to work on the big RAID system `/totten_1`, which has 83 TB. You will probably need to create a directory with,
> ```sh
> cd /totten_1
> mkdir <USERNAME>
> ```
> replacing `<USERNAME>` with your {{ page.machine_name }} username. This is were you should install ISSM and create your "projects" directory.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine:
```sh
Host totten totten.dartmouth.edu
    HostName totten.dartmouth.edu
    User <USERNAME>
```
replacing `<USERNAME> ` with your {{ page.machine_name }} username. Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh totten
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`:
```sh
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh

# MATLAB alias
alias ma='LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6:/usr/lib/x86_64-linux-gnu/libgfortran.so.5:$ISSM_DIR/externalpackages/petsc/install/lib/libmpi.so:$ISSM_DIR/externalpackages/petsc/install/lib/libmpifort.so:$ISSM_DIR/externalpackages/petsc/install/lib/libmpifort.so.12 /usr/local/MATLAB/{{ site.matlab_ver }}/bin/matlab -nodesktop -nosplash -r "addpath $ISSM_DIR/src/m/dev; devpath;"'
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to. Feel free to remove anything that you may have by default in this file. Log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
You can follow the [detailed instructions for compiling ISSM on Linux](../../linux). You will need to install the following packages:

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- autotools
- petsc        (use the latest available version)
- triangle
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --with-numthreads=32 \
    --without-kml \
    --with-matlab-dir="/usr/local/MATLAB/{{ site.matlab_ver }}" \
    --with-mpi-include="$ISSM_DIR/externalpackages/petsc/install/include" \
    --with-mpi-libflags="-L$ISSM_DIR/externalpackages/petsc/install/lib -lmpi -lmpifort"\
    --with-fortran-lib="-L/usr/lib/x86_64-linux-gnu -lgfortran" \
    --with-triangle-dir="$ISSM_DIR/externalpackages/triangle/install" \
    --with-metis-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-petsc-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-blas-lapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-scalapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-mumps-dir="$ISSM_DIR/externalpackages/petsc/install/" \
    --with-m1qn3-dir="$ISSM_DIR/externalpackages/m1qn3/install" \
    --with-parmetis-dir="$ISSM_DIR/externalpackages/petsc/install/"
```

## Installing ISSM with CoDiPack (AD)
You will need to install the following *additional* packages:
- cmake
- codipack
- medipack
- adjointpetsc

Use the following configuration script (adapt to your needs):
```sh
export CXXFLAGS="-g -O3 -fPIC -std=c++11 -DCODI_ForcedInlines"
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --enable-tape-alloc \
    --with-numthreads=32 \
    --without-kriging \
    --without-Love \
    --without-Sealevelchange \
    --with-matlab-dir="/usr/local/MATLAB/{{ site.matlab_ver }}" \
    --with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
    --with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpicxx -lmpifort" \
    --with-fortran-lib="-L/usr/lib/x86_64-linux-gnu -lgfortran" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-adjointpetsc-dir="${ISSM_DIR}/externalpackages/adjointpetsc/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-codipack-dir="${ISSM_DIR}/externalpackages/codipack/install" \
    --with-medipack-dir="${ISSM_DIR}/externalpackages/medipack/install" \
    --with-gsl-dir="${ISSM_DIR}/externalpackages/gsl/install" 
```

## Installing ISSM with Solid Earth Capabilities
For an installation of ISSM with Solid Earth capabilities, you will need to install the following *additional* packages:
```sh
autotools    install-linux.sh
zlib         install-1.sh
hdf5         install-1.sh
boost        install-1.7-linux.sh
chaco        install-linux.sh
curl         install-7-linux.sh
netcdf       install-4.sh
sqlite       install.sh
proj         install-6.sh
gdal         install-3-linux.sh
gshhg        install.sh
gmt          install-6-pleiades.sh
gmsh         install-4-pleiades.sh
m1qn3        install-linux.sh
```

Use the following configuration script for ISSM (adapt to your needs),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --with-numthreads=32 \
    --with-matlab-dir="/usr/local/MATLAB/{{ site.matlab_ver }}" \
    --with-mpi-include="$ISSM_DIR/externalpackages/petsc/install/include" \
    --with-mpi-libflags="-L$ISSM_DIR/externalpackages/petsc/install/lib -lmpi -lmpifort"\
    --with-fortran-lib="-L/usr/lib/x86_64-linux-gnu -lgfortran" \
    --with-triangle-dir="$ISSM_DIR/externalpackages/triangle/install" \
    --with-metis-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-petsc-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-blas-lapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-scalapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-mumps-dir="$ISSM_DIR/externalpackages/petsc/install/" \
    --with-m1qn3-dir="$ISSM_DIR/externalpackages/m1qn3/install" \
    --with-parmetis-dir="$ISSM_DIR/externalpackages/petsc/install/" \
    --with-hdf5-dir="${ISSM_DIR}/externalpackages/hdf5/install" \
    --with-boost-dir="${ISSM_DIR}/externalpackages/boost/install" \
    --with-chaco-dir="${ISSM_DIR}/externalpackages/chaco/install" \
    --with-proj-dir="${ISSM_DIR}/externalpackages/proj/install" \
    --with-semic-dir="${ISSM_DIR}/externalpackages/semic/install"
```

## Running a Jupyter Notebook on {{ page.machine_name }}
You can run a Jupyter Notebook on {{ page.machine_name }} with,
```sh
jupyter notebook --no-browser --port=8080
```
Keep this terminal alive, where you will need the token to access the Notebook.

To access your Notebook via web browser *on your local machine*, you need to link {{ page.machine_name }}' port `8080` to your `localhost:8080` by running the following on your local machine:
```sh
ssh -L 8080:localhost:8080 yourname@totten.dartmouth.edu
```
Then, open a web browser on your local machine and access the Jupyter Notebook from `http://localhost:8080/`. You might be asked to enter the token, which you can find in the terminal you kept alive for Jupyter Notebook.
