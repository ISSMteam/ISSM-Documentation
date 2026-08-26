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

Tongji University's Scientific Computing Platform can be used as a remote execution cluster for ISSM. The recommended workflow is:

1. prepare and inspect models with a local MATLAB or Python installation of ISSM;
2. submit simulations to a binary-only ISSM installation on Tongji HPC; and
3. retrieve the completed results for post-processing on the local workstation.

{: .highlight-title }
> Recommended platform
>
> Use the **AMD CPU nodes** for the standard Tongji HPC installation. The main instructions below therefore describe the AMD environment and AMD `configure.sh`.
>
> Intel CPU nodes remain supported as an alternative. Their module environment and `configure.sh` are provided in a separate section near the end of the installation instructions.

If you intend to use both CPU architectures, keep completely separate ISSM installations:

```text
/path/to/ISSM-amd
/path/to/ISSM-intel
```

Do not share the PETSc installation or compiled ISSM binaries between the AMD and Intel checkouts.

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

## AMD nodes (Recommended)

Add the following lines to `~/.bashrc` on Tongji HPC, or place them near the beginning of the AMD Slurm job script:

```sh
module purge
module load gcc/13.2.0
module load cmake/3.31.6

export ISSM_DIR=/path/to/ISSM-amd
export PETSC_PREFIX="${ISSM_DIR}/externalpackages/petsc/install"

source "${ISSM_DIR}/etc/environment.sh"

# Use the MPICH installation built together with PETSc.
export PATH="${PETSC_PREFIX}/bin:${PATH}"
export LD_LIBRARY_PATH="${PETSC_PREFIX}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
```

Replace `/path/to/ISSM-amd` with the absolute path to the AMD ISSM checkout, then reload the environment:

```sh
source ~/.bashrc
```

{: .highlight-title }
> MPI requirement
>
> Do not load the cluster's `openmpi/5.0.6` module for this installation. PETSc is compiled with its downloaded MPICH 4.3.0. Mixing Open MPI with PETSc's MPICH may cause link-time or runtime errors.

Check the active MPI wrappers:

```sh
which mpicc
which mpicxx
which mpifort
which mpiexec

mpicc -show
```

After PETSc has been installed, also check its runtime dependencies:

```sh
ldd "${PETSC_PREFIX}/lib/libpetsc.so.3.23" \
    | grep -E "libmpi|libmpifort"
```

The MPI wrappers and shared libraries should resolve inside:

```text
${ISSM_DIR}/externalpackages/petsc/install/
```

## Installing PETSc

This configuration uses PETSc 3.23.6 and the script:

```text
externalpackages/petsc/install-3.23-tjhpc.sh
```

### Required downloads

Because some external downloads may be inaccessible from Tongji HPC due to the bandwidth, download the following archives manually and place them in:

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

### PETSc installation

Run the installation on an AMD compute node with:

```sh
cd "${ISSM_DIR}/externalpackages/petsc"
chmod +x install-3.23-tjhpc.sh
./install-3.23-tjhpc.sh
source "${ISSM_DIR}/etc/environment.sh"
```

The same PETSc procedure can also be used for the optional Intel installation, provided that it is run inside the separate Intel ISSM checkout.


## Installing ISSM on AMD nodes

Generate the Autotools files:

```sh
cd "${ISSM_DIR}"
autoreconf -ivf
```

Create `${ISSM_DIR}/configure.sh` with:

```sh
#!/bin/bash
set -eu

PETSC_PREFIX="${ISSM_DIR}/externalpackages/petsc/install"

export CC="${PETSC_PREFIX}/bin/mpicc"
export CXX="${PETSC_PREFIX}/bin/mpicxx"
export FC="${PETSC_PREFIX}/bin/mpifort"

export CFLAGS="-g -O2"
export CXXFLAGS="-g -O2 -std=c++11"
export FCFLAGS="-g -O2"

export PATH="${PETSC_PREFIX}/bin:${PATH}"
export LD_LIBRARY_PATH="${PETSC_PREFIX}/lib:${LD_LIBRARY_PATH}"
export LDFLAGS="-Wl,-rpath,${PETSC_PREFIX}/lib"

./configure \
    --prefix="${ISSM_DIR}" \
    --with-wrappers=no \
    --with-petsc-dir="${PETSC_PREFIX}" \
    --with-mpi-include="${PETSC_PREFIX}/include" \
    --with-mpi-libflags="-L${PETSC_PREFIX}/lib -lmpi -lmpifort" \
    --with-blas-lapack-dir="${PETSC_PREFIX}" \
    --with-metis-dir="${PETSC_PREFIX}" \
    --with-scalapack-dir="${PETSC_PREFIX}" \
    --with-mumps-dir="${PETSC_PREFIX}" \
    --enable-development
```

Run the configuration and compilation on an AMD compute node:

```sh
chmod +x configure.sh
./configure.sh
make -j20
make install
```

Confirm that the executable was created and that PETSc's MPICH is loaded:

```sh
ls -l "${ISSM_DIR}/bin/issm.exe"

ldd "${ISSM_DIR}/bin/issm.exe" \
    | grep -E "libpetsc|libmpi|libmpifort|libstdc\+\+"
```

All MPI libraries should resolve from:

```text
${ISSM_DIR}/externalpackages/petsc/install/lib/
```

{: .highlight-title }
> Runtime MPI errors
>
> If ISSM reports an error such as `undefined symbol: MPI_Type_get_envelope_c`, another MPI implementation is being loaded at runtime. Remove any Open MPI module and make sure `${PETSC_PREFIX}/lib` appears before other MPI library directories in `LD_LIBRARY_PATH`.

## Alternative installation: Intel nodes

The Intel installation is optional. Use a separate checkout, such as:

```text
/path/to/ISSM-intel
```

Load the Intel environment:

```sh
module purge
module load intel/oneapi/24.0
module load gcc/13.2.0
module load cmake/3.31.6

export ISSM_DIR=/path/to/ISSM-intel
export PETSC_PREFIX="${ISSM_DIR}/externalpackages/petsc/install"
export MKL_LIBDIR="/share/apps/oneapi24.0/mkl/latest/lib/intel64"

source "${ISSM_DIR}/etc/environment.sh"

export PATH="${PETSC_PREFIX}/bin:${PATH}"
export LD_LIBRARY_PATH="${PETSC_PREFIX}/lib:${MKL_LIBDIR}${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
```

Install PETSc using the same procedure described above, but from the Intel ISSM checkout. Then create `${ISSM_DIR}/configure.sh` with:

```sh
#!/bin/bash
set -eu

PETSC_DIR="${ISSM_DIR}/externalpackages/petsc/install"
MKL_LIBDIR="/share/apps/oneapi24.0/mkl/latest/lib/intel64"

export CC="${PETSC_DIR}/bin/mpicc"
export CXX="${PETSC_DIR}/bin/mpicxx"
export FC="${PETSC_DIR}/bin/mpifort"

export CFLAGS="-g -O2 -fPIC"
export CXXFLAGS="-g -O2 -fPIC -std=c++11"
export FCFLAGS="-g -O2 -fPIC"

export PATH="${PETSC_DIR}/bin:${PATH}"
export LD_LIBRARY_PATH="${PETSC_DIR}/lib:${MKL_LIBDIR}${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
export LDFLAGS="-Wl,-rpath,${PETSC_DIR}/lib -Wl,-rpath,${MKL_LIBDIR}"

./configure \
    --prefix="${ISSM_DIR}" \
    --with-wrappers=no \
    --with-petsc-dir="${PETSC_DIR}" \
    --with-mpi-include="${PETSC_DIR}/include" \
    --with-mpi-libflags="-L${PETSC_DIR}/lib -lmpi -lmpifort" \
    --with-metis-dir="${PETSC_DIR}" \
    --with-parmetis-dir="${PETSC_DIR}" \
    --with-scalapack-dir="${PETSC_DIR}" \
    --with-mumps-dir="${PETSC_DIR}" \
    --with-mkl-libflags="-L${MKL_LIBDIR} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl" \
    --enable-development
```

Build the Intel installation on an Intel compute node:

```sh
cd "${ISSM_DIR}"
autoreconf -ivf
chmod +x configure.sh
./configure.sh
make -j20
make install
```

{: .highlight-title }
> Note
>
> Do not use the Intel executable on AMD nodes or the AMD executable on Intel nodes.

## `tjhpc_settings.m`

On the local ISSM installation used with MATLAB, create `$ISSM_DIR/src/m/tjhpc_settings.m`:

```matlab
cluster.login = 'yourLoginID_To_HPC';
cluster.emailname = 'yourEmailName';
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

Set `cluster.codepath` and `cluster.executionpath` to the AMD installation unless you deliberately intend to run on Intel nodes.

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

Use the AMD partition or AMD resource type in the Tongji job configuration unless an Intel run is specifically required. Request only the resources needed by the model, because larger node counts, longer wall times, and larger memory requests may increase queueing time.

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
