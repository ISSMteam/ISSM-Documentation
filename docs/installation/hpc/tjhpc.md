---
title: Tongji
layout: default
parent: HPC
---

# Tongji University HPC
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Overview

Tongji University's Scientific Computing Platform can be used as a remote execution cluster for ISSM. The recommended setup is to use a local ISSM installation with MATLAB or Python for model preparation and post-processing, and a binary-only ISSM installation on Tongji HPC for simulations.

These instructions target the Intel CPU environment on Tongji HPC.

## Getting an account

See the <a href="https://dev.tongji.edu.cn/hpc-doc/#/README" target="_blank">Tongji University Scientific Computing Platform documentation</a> for account application and access information.

## SSH configuration

Follow Tongji's <a href="https://dev.tongji.edu.cn/hpc-doc/#/pages/platformDes/account" target="_blank">account and SSH instructions</a>. Password-less SSH is recommended for remote job submission from ISSM.

You may also define an SSH alias in `~/.ssh/config` on your local workstation:

```text
Host tjhpc
    HostName <LOGIN_HOST>
    User <USERNAME>
```

Replace the placeholders with the values assigned to your account. You can then connect with:

```sh
ssh tjhpc
```

## Environment

Add the following lines to `~/.bashrc` on Tongji HPC:

```sh
export ISSM_DIR=/path/to/ISSM
source "${ISSM_DIR}/etc/environment.sh"

module purge
module load cmake/3.31.6
module load OpenBLAS/0.3.26
module load openmpi/5.0.6
module load gcc/13.2.0
module load intel/oneapi/24.0
```

Replace `/path/to/ISSM` with the absolute path to your ISSM checkout, then apply the changes with:

```sh
source ~/.bashrc
```

{: .highlight-title }
> Important
>
> PETSc and ISSM must use a compatible MPI implementation. The PETSc script below downloads MPICH, while the module environment also loads Open MPI. After PETSc is installed and `${ISSM_DIR}/etc/environment.sh` is sourced, verify that `mpicc`, `mpicxx`, and `mpifort` point to the MPI wrappers intended for the PETSc installation. Mixing Open MPI wrappers with PETSc libraries built against MPICH may cause link-time or runtime failures.

Check the active wrappers with:

```sh
which mpicc
which mpicxx
which mpifort
mpicc -show
```

## Installing PETSc

Tongji HPC is used only to run ISSM binaries; MATLAB or Python wrappers should normally remain on the local workstation.

This configuration uses PETSc 3.23.6 and the script:

```text
externalpackages/petsc/install-3.23-tjhpc.sh
```

### Required downloads

Because some external downloads may be inaccessible from Tongji HPC, download the following archives manually and place them in:

```text
${ISSM_DIR}/externalpackages/petsc/downloads/
```

Required filenames:

```text
petsc-pkg-fblaslapack-e8a03f57d64c.tar.gz
petsc-pkg-metis-69fb26dd0428.tar.gz
mpich-4.3.0.tar.gz
MUMPS_5.7.3.tar.gz
petsc-pkg-parmetis-f5e3aab04fd5.tar.gz
scalapack-0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz
zlib-1.3.1.tar.gz
```

### Download mirrors

The following upstream locations can be used to obtain the required packages. When the downloaded archive has a different name, save or rename it to the exact filename expected by `install-3.23-tjhpc.sh`.

#### MPICH

Expected filename: `mpich-4.3.0.tar.gz`

- <a href="https://github.com/pmodels/mpich/releases/download/v4.3.0/mpich-4.3.0.tar.gz" target="_blank">GitHub release</a>
- <a href="https://www.mpich.org/static/downloads/4.3.0/mpich-4.3.0.tar.gz" target="_blank">MPICH download server</a>
- <a href="https://web.cels.anl.gov/projects/petsc/download/externalpackages/mpich-4.3.0.tar.gz" target="_blank">PETSc external-package mirror</a>

#### fblaslapack

Expected filename: `petsc-pkg-fblaslapack-e8a03f57d64c.tar.gz`

- Repository: `git clone https://bitbucket.org/petsc/pkg-fblaslapack`
- <a href="https://bitbucket.org/petsc/pkg-fblaslapack/get/v3.4.2-p3.tar.gz" target="_blank">Bitbucket release archive</a>

For example:

```sh
curl -L \
    "https://bitbucket.org/petsc/pkg-fblaslapack/get/v3.4.2-p3.tar.gz" \
    -o petsc-pkg-fblaslapack-e8a03f57d64c.tar.gz
```

#### zlib

Expected filename: `zlib-1.3.1.tar.gz`

- <a href="http://www.zlib.net/zlib-1.3.1.tar.gz" target="_blank">zlib download server</a>
- <a href="https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz" target="_blank">GitHub release</a>
- <a href="https://web.cels.anl.gov/projects/petsc/download/externalpackages/zlib-1.3.1.tar.gz" target="_blank">PETSc external-package mirror</a>

#### METIS

Expected filename: `petsc-pkg-metis-69fb26dd0428.tar.gz`

- Repository: `git clone https://bitbucket.org/petsc/pkg-metis.git`
- <a href="https://bitbucket.org/petsc/pkg-metis/get/v5.1.0-p12.tar.gz" target="_blank">Bitbucket release archive</a>

For example:

```sh
curl -L \
    "https://bitbucket.org/petsc/pkg-metis/get/v5.1.0-p12.tar.gz" \
    -o petsc-pkg-metis-69fb26dd0428.tar.gz
```

#### ParMETIS

Expected filename: `petsc-pkg-parmetis-f5e3aab04fd5.tar.gz`

- Repository: `git clone https://bitbucket.org/petsc/pkg-parmetis.git`
- <a href="https://bitbucket.org/petsc/pkg-parmetis/get/v4.0.3-p9.tar.gz" target="_blank">Bitbucket release archive</a>

For example:

```sh
curl -L \
    "https://bitbucket.org/petsc/pkg-parmetis/get/v4.0.3-p9.tar.gz" \
    -o petsc-pkg-parmetis-f5e3aab04fd5.tar.gz
```

#### MUMPS

Expected filename: `MUMPS_5.7.3.tar.gz`

- <a href="https://mumps-solver.org/MUMPS_5.7.3.tar.gz" target="_blank">MUMPS project server</a>
- <a href="https://web.cels.anl.gov/projects/petsc/download/externalpackages/MUMPS_5.7.3.tar.gz" target="_blank">PETSc external-package mirror</a>

#### ScaLAPACK

Expected filename: `scalapack-0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz`

- Repository: `git clone https://github.com/Reference-ScaLAPACK/scalapack`
- <a href="https://github.com/Reference-ScaLAPACK/scalapack/archive/0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz" target="_blank">GitHub commit archive</a>

### Downloading directly into the PETSc downloads directory

Create the directory first:

```sh
mkdir -p "${ISSM_DIR}/externalpackages/petsc/downloads"
cd "${ISSM_DIR}/externalpackages/petsc/downloads"
```

You can then use any of the mirrors above with `curl -L -o <EXPECTED_FILENAME> <URL>`. For example:

```sh
curl -L \
    "https://github.com/pmodels/mpich/releases/download/v4.3.0/mpich-4.3.0.tar.gz" \
    -o mpich-4.3.0.tar.gz

curl -L \
    "https://web.cels.anl.gov/projects/petsc/download/externalpackages/MUMPS_5.7.3.tar.gz" \
    -o MUMPS_5.7.3.tar.gz

curl -L \
    "https://github.com/Reference-ScaLAPACK/scalapack/archive/0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz" \
    -o scalapack-0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz
```

The filenames must match exactly because they are passed directly to PETSc's `--download-*` options.

### PETSc installation script

Create `externalpackages/petsc/install-3.23-tjhpc.sh` with:

```sh
#!/bin/bash
set -eu

VER="3.23.6"
PETSC_DIR="${ISSM_DIR}/externalpackages/petsc/src"
PREFIX="${ISSM_DIR}/externalpackages/petsc/install"

"${ISSM_DIR}/scripts/DownloadExternalPackage.sh" \
    "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${VER}.tar.gz" \
    "petsc-${VER}.tar.gz"

tar -zxvf "petsc-${VER}.tar.gz"
rm -rf "${PREFIX}" "${PETSC_DIR}"
mkdir -p "${PETSC_DIR}"
mv "petsc-${VER}"/* "${PETSC_DIR}"
rm -rf "petsc-${VER}"

cd "${PETSC_DIR}"
./configure \
    --prefix="${PREFIX}" \
    --PETSC_DIR="${PETSC_DIR}" \
    --with-make-np=20 \
    --with-debugging=0 \
    --with-valgrind=0 \
    --with-x=0 \
    --with-ssl=0 \
    --with-pic=1 \
    --download-fblaslapack="${ISSM_DIR}/externalpackages/petsc/downloads/petsc-pkg-fblaslapack-e8a03f57d64c.tar.gz" \
    --download-metis="${ISSM_DIR}/externalpackages/petsc/downloads/petsc-pkg-metis-69fb26dd0428.tar.gz" \
    --download-mpich="${ISSM_DIR}/externalpackages/petsc/downloads/mpich-4.3.0.tar.gz" \
    --download-mumps="${ISSM_DIR}/externalpackages/petsc/downloads/MUMPS_5.7.3.tar.gz" \
    --download-parmetis="${ISSM_DIR}/externalpackages/petsc/downloads/petsc-pkg-parmetis-f5e3aab04fd5.tar.gz" \
    --download-scalapack="${ISSM_DIR}/externalpackages/petsc/downloads/scalapack-0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz" \
    --download-zlib="${ISSM_DIR}/externalpackages/petsc/downloads/zlib-1.3.1.tar.gz"

make
make install
```

Run the installation with:

```sh
cd "${ISSM_DIR}/externalpackages/petsc"
chmod +x install-3.23-tjhpc.sh
./install-3.23-tjhpc.sh
source "${ISSM_DIR}/etc/environment.sh"
```

## Installing ISSM

Generate the Autotools files:

```sh
cd "${ISSM_DIR}"
autoreconf -ivf
```

Create `${ISSM_DIR}/configure_tjhpc.sh` with:

```sh
#!/bin/bash
set -eu

export CC=mpicc
export CXX=mpicxx
export FC=mpifort
export CXXFLAGS="-g -O2 -std=c++11"

./configure \
    --prefix="${ISSM_DIR}" \
    --with-wrappers=no \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
    --with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpifort" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mkl-libflags="-L/share/apps/oneapi24.0/mkl/latest/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --enable-development
```

Run the configuration and compilation:

```sh
chmod +x configure_tjhpc.sh
./configure_tjhpc.sh
make -j20
make install
```

Confirm that the executable was created:

```sh
ls -l "${ISSM_DIR}/bin/issm.exe"
ldd "${ISSM_DIR}/bin/issm.exe" | grep -E "mpi|mkl"
```

## `tjhpc_settings.m`

On the local ISSM installation used with MATLAB, create `$ISSM_DIR/src/m/tjhpc_settings.m`:

```matlab
cluster.login = 'yourLoginID';
cluster.codepath = '/path/to/ISSM/bin';
cluster.executionpath = '/path/to/ISSM/execution';
```

These settings are loaded when the cluster object is created:

```matlab
md.cluster = tjhpc();
```

The `tjhpc` cluster class must also be available as:

```text
src/m/classes/clusters/tjhpc.m
```

## Storage

Your home directory has approximately 1.5 TB of storage. The higher-performance location `/ssdfs/datahome/USERNAME` has approximately 500 GB. Consult Tongji's <a href="https://dev.tongji.edu.cn/hpc-doc/#/pages/platformDes/dataTransfer" target="_blank">data transfer and storage documentation</a> before selecting the execution directory.

For example:

```sh
mkdir -p /ssdfs/datahome/USERNAME/ISSM/execution
```

## Running jobs on Tongji HPC

For example, request one node and eight CPU cores from MATLAB:

```matlab
md.cluster = tjhpc('numnodes', 1, 'cpuspernode', 8);
```

Tongji HPC's Intel nodes provide up to 96 physical CPU cores per node. Request only the resources needed by the model, because larger node counts, longer wall times, and larger memory requests may increase queueing time.

See Tongji's documentation for <a href="https://dev.tongji.edu.cn/hpc-doc/#/pages/quickStart/resourceConfig" target="_blank">resource configuration</a> and <a href="https://dev.tongji.edu.cn/hpc-doc/#/pages/quickStart/jobSubmit" target="_blank">job submission</a>.

## Monitoring and cancelling jobs

List your jobs:

```sh
squeue -u USERNAME
```

Inspect a job:

```sh
scontrol show job JOBID
```

Cancel a job:

```sh
scancel JOBID
```

The execution directory contains `JOBNAME.outlog` and `JOBNAME.errlog`. The first contains standard output; the second contains errors from ISSM, MPI, or Slurm.

## Loading results manually

If a network interruption prevents MATLAB from retrieving completed results automatically, use:

```matlab
md = loadresultsfromcluster(md, 'LAUNCHSTRING', 'JOBNAME');
```

When `md.settings.waitonlock > 0`, set the runtime name first:

```matlab
md.private.runtimename = 'LAUNCHSTRING';
md = loadresultsfromcluster(md, 'LAUNCHSTRING', 'JOBNAME');
```

## Slurm

A comparison of PBS and Slurm commands is available in the <a href="https://slurm.schedmd.com/rosetta.pdf" target="_blank">Slurm Rosetta stone</a>. An overview of Slurm on Tongji HPC is available <a href="https://dev.tongji.edu.cn/hpc-doc/#/pages/quickStart/concept" target="_blank">here</a>.
