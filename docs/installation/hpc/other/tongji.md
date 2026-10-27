---
title: Tongji
layout: default
parent: Other HPCs
machine_name: "Tongji University' HPC"
has_toc: false
---

# {{ page.machine_name }}
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Overview
Tongji University' Scientific Computing Platform can be used as a remote execution cluster for ISSM. The recommended workflow is:
1. prepare and inspect models with a local MATLAB or Python installation of ISSM;
2. submit simulations to a binary-only ISSM installation on {{ page.machine_name }}; and
3. retrieve the completed results for post-processing on the local workstation.

{: .highlight-title }
> Recommended platform
>
> Use the **AMD CPU nodes** for the standard {{ page.machine_name }} installation. The main instructions below therefore describe the AMD environment and AMD `configure.sh`.
>
> Intel CPU nodes remain supported as an alternative. Their module environment and `configure.sh` are provided in a separate section near the end of the installation instructions.

If you intend to use both CPU architectures, keep completely separate ISSM installations,
```text
/path/to/ISSM-amd
/path/to/ISSM-intel
```

Do not share the PETSc installation or compiled ISSM binaries between the AMD and Intel checkouts.

## Getting an account
See the [Tongji University Scientific Computing Service Platform documentation (use in-browser translation)](https://dev.tongji.edu.cn/hpc-doc/#/README){:target="_blank"} for account application and access information.

## SSH configuration
Follow [Tongji University Scientific Computing Service Platform account and SSH instructions (use in-browser translation)](https://dev.tongji.edu.cn/hpc-doc/#/pages/platformDes/account){:target="_blank"}. Password-less SSH is recommended for remote job submission from ISSM.

You may also define an SSH alias in `~/.ssh/config` on your local workstation,
```sh
Host tjhpc
    HostName <LOGIN_HOST>
    User <USERNAME>
```
replacing `<HOSTNAME>` with the {{ page.machine_name }} machine you will be connecting to and <USERNAME>` with your {{ page.machine_name }} username. Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh tjhpc
```

## AMD Nodes (recommended)
Add the following lines to `~/.bashrc` on {{ page.machine_name }}, or place them near the beginning of the AMD Slurm job script,
```sh
# Load modules
module purge
module load gcc/13.2.0
module load cmake/3.31.6

# ISSM
export ISSM_DIR=/path/to/ISSM-amd
export PETSC_PREFIX="${ISSM_DIR}/externalpackages/petsc/install"

source "${ISSM_DIR}/etc/environment.sh"

# Use the MPICH installation built together with PETSc.
export PATH="${PETSC_PREFIX}/bin:${PATH}"
export LD_LIBRARY_PATH="${PETSC_PREFIX}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
```

Replace `/path/to/ISSM-amd` with the absolute path to the AMD ISSM checkout, then reload the environment with,
```sh
source ~/.bashrc
```

{: .highlight-title }
> MPI requirement
>
> Do not load the cluster's `openmpi/5.0.6` module for this installation. PETSc is compiled with its downloaded MPICH 4.3.0. Mixing Open MPI with PETSc' MPICH may cause link-time or runtime errors.

Check the active MPI wrappers,
```sh
which mpicc
which mpicxx
which mpifort
which mpiexec

mpicc -show
```

After PETSc has been installed, also check its runtime dependencies,
```sh
ldd "${PETSC_PREFIX}/lib/libpetsc.so.3.23" \
    | grep -E "libmpi|libmpifort"
```

The MPI wrappers and shared libraries should resolve inside,
```sh
${ISSM_DIR}/externalpackages/petsc/install/
```

## Installing PETSc
This configuration uses PETSc 3.23.6 and the script,
```sh
externalpackages/petsc/install-3.23-tjhpc.sh
```

### Required Downloads
Because some external downloads may be inaccessible from {{ page.machine_name }} due to bandwidth restrictions, download the following archives manually and place them in,
```sh
${ISSM_DIR}/externalpackages/petsc/downloads/
```

Required packages:
- petsc-pkg-fblaslapack-e8a03f57d64c.tar.gz
- petsc-pkg-metis-69fb26dd0428.tar.gz
- mpich-4.3.0.tar.gz
- MUMPS_5.7.3.tar.gz
- petsc-pkg-parmetis-f5e3aab04fd5.tar.gz
- scalapack-0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz
- zlib-1.3.1.tar.gz

### Download Mirrors
The following upstream locations can be used to obtain the required packages. When the downloaded archive has a different name, save or rename it to the exact filename expected by `install-3.23-tjhpc.sh`.

#### MPICH
Expected filename: `mpich-4.3.0.tar.gz`

- [GitHub release](https://github.com/pmodels/mpich/releases/download/v4.3.0/mpich-4.3.0.tar.gz){:target="_blank"}
- [MPICH download server](https://www.mpich.org/static/downloads/4.3.0/mpich-4.3.0.tar.gz){:target="_blank"}
- [PETSc external-package mirror](https://web.cels.anl.gov/projects/petsc/download/externalpackages/mpich-4.3.0.tar.gz){:target="_blank"}

#### fblaslapack
Expected filename: `petsc-pkg-fblaslapack-e8a03f57d64c.tar.gz`

- Repository: `git clone https://bitbucket.org/petsc/pkg-fblaslapack`
- [Bitbucket release archive](https://bitbucket.org/petsc/pkg-fblaslapack/get/v3.4.2-p3.tar.gz){:target="_blank"}

For example,
```sh
curl -L \
    "https://bitbucket.org/petsc/pkg-fblaslapack/get/v3.4.2-p3.tar.gz" \
    -o petsc-pkg-fblaslapack-e8a03f57d64c.tar.gz
```

#### zlib
Expected filename: `zlib-1.3.1.tar.gz`

- [zlib download server](http://www.zlib.net/zlib-1.3.1.tar.gz){:target="_blank"}
- [GitHub release](https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz){:target="_blank"}
- [PETSc external-package mirror](https://web.cels.anl.gov/projects/petsc/download/externalpackages/zlib-1.3.1.tar.gz){:target="_blank"}

#### METIS
Expected filename: `petsc-pkg-metis-69fb26dd0428.tar.gz`

- Repository: `git clone https://bitbucket.org/petsc/pkg-metis.git`
- [Bitbucket release archive](https://bitbucket.org/petsc/pkg-metis/get/v5.1.0-p12.tar.gz){:target="_blank"}

For example,
```sh
curl -L \
    "https://bitbucket.org/petsc/pkg-metis/get/v5.1.0-p12.tar.gz" \
    -o petsc-pkg-metis-69fb26dd0428.tar.gz
```

#### ParMETIS
Expected filename: `petsc-pkg-parmetis-f5e3aab04fd5.tar.gz`

- Repository: `git clone https://bitbucket.org/petsc/pkg-parmetis.git`
- [Bitbucket release archive](https://bitbucket.org/petsc/pkg-parmetis/get/v4.0.3-p9.tar.gz){:target="_blank"}

For example,
```sh
curl -L \
    "https://bitbucket.org/petsc/pkg-parmetis/get/v4.0.3-p9.tar.gz" \
    -o petsc-pkg-parmetis-f5e3aab04fd5.tar.gz
```

#### MUMPS
Expected filename: `MUMPS_5.7.3.tar.gz`

- [MUMPS project server](https://mumps-solver.org/MUMPS_5.7.3.tar.gz){:target="_blank"}
- [PETSc external-package mirror](https://web.cels.anl.gov/projects/petsc/download/externalpackages/MUMPS_5.7.3.tar.gz){:target="_blank"}

#### ScaLAPACK
Expected filename: `scalapack-0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz`

- Repository: `git clone https://github.com/Reference-ScaLAPACK/scalapack`
- [GitHub commit archive](https://github.com/Reference-ScaLAPACK/scalapack/archive/0e8767285b7a201c7b1ff34d2c2bb009534145df.tar.gz){:target="_blank"}

### Downloading Directly Into the PETSc Downloads Directory

Create the directory first with,
```sh
mkdir -p "${ISSM_DIR}/externalpackages/petsc/downloads"
cd "${ISSM_DIR}/externalpackages/petsc/downloads"
```

You can then use any of the mirrors above with `curl -L -o <EXPECTED_FILENAME> <URL>`. For example,
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

The filenames must match exactly because they are passed directly to PETSc' `--download-*` options.

### PETSc Installation
Run the installation on an AMD compute node with,
```sh
cd "${ISSM_DIR}/externalpackages/petsc"
chmod +x install-3.23-tjhpc.sh
./install-3.23-tjhpc.sh
source "${ISSM_DIR}/etc/environment.sh"
```

The same PETSc procedure can also be used for the optional Intel installation, provided that it is run inside the separate Intel ISSM checkout.

## Installing ISSM on AMD nodes
Generate the Autotools files,
```sh
cd "${ISSM_DIR}"
autoreconf -ivf
```

Create `${ISSM_DIR}/configure.sh` with,
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
    --enable-development \
    --with-wrappers=no \
    --with-mpi-include="${PETSC_PREFIX}/include" \
    --with-mpi-libflags="-L${PETSC_PREFIX}/lib -lmpi -lmpifort" \
    --with-petsc-dir="${PETSC_PREFIX}" \
    --with-blas-lapack-dir="${PETSC_PREFIX}" \
    --with-metis-dir="${PETSC_PREFIX}" \
    --with-scalapack-dir="${PETSC_PREFIX}" \
    --with-mumps-dir="${PETSC_PREFIX}"
```

Run the configuration and compilation on an AMD compute node,
```sh
chmod +x configure.sh
./configure.sh
make -j20
make install
```

Confirm that the executable was created and that PETSc' MPICH is loaded,
```sh
ls -l "${ISSM_DIR}/bin/issm.exe"

ldd "${ISSM_DIR}/bin/issm.exe" \
    | grep -E "libpetsc|libmpi|libmpifort|libstdc\+\+"
```

All MPI libraries should resolve from,
```sh
${ISSM_DIR}/externalpackages/petsc/install/lib/
```

{: .highlight-title }
> MPI Runtime Errors
>
> If ISSM reports an error such as `undefined symbol: MPI_Type_get_envelope_c`, another MPI implementation is being loaded at runtime. Remove any Open MPI module and make sure `${PETSC_PREFIX}/lib` appears before other MPI library directories in `LD_LIBRARY_PATH`.

## Alternative Installation: Intel Nodes
The Intel installation is optional. Use a separate checkout, such as,
```sh
/path/to/ISSM-intel
```

Load the Intel environment,
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

Install PETSc using the same procedure described above, but from the Intel ISSM checkout. Then create `${ISSM_DIR}/configure.sh` with,
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
    --enable-development \
    --with-wrappers=no \
    --with-mpi-include="${PETSC_DIR}/include" \
    --with-mpi-libflags="-L${PETSC_DIR}/lib -lmpi -lmpifort" \
    --with-mkl-libflags="-L${MKL_LIBDIR} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl" \
    --with-petsc-dir="${PETSC_DIR}" \
    --with-metis-dir="${PETSC_DIR}" \
    --with-parmetis-dir="${PETSC_DIR}" \
    --with-scalapack-dir="${PETSC_DIR}" \
    --with-mumps-dir="${PETSC_DIR}"
```

Build the Intel installation on an Intel compute node,
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

## Cluster Class Settings
In order to connect to {{ page.machine_name }} from the machine that you are doing model setup and results analysis on, you will need to create a cluster class settings file for your chosen scripting interface.
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
Create `$ISSM_DIR/src/m/tjhpc_settings.m`, which might include,
```matlab
cluster.login = '<USERNAME>';
cluster.emailname = '<EMAIL>';
cluster.codepath = '<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath = '<PATH_TO_ISSM_ON_CLUSTER>/execution/';
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `tjhpc.py` still needs to be developed.
</div>
</div>
replacing `<USERNAME>` with your {{ page.machine_name }} username, `<EMAIL>` with the email address that you would like to receive notifications to when your job has completed, and entering your code path and execution path. These settings will be picked up automatically when you run `md.cluster = tjhpc()`.

If you receive any runtime errors, ensure the `tjhpc` cluster class is available at `$ISSM_DIR/src/m/classes/clusters/tjhpc.m`.

Set `cluster.codepath` and `cluster.executionpath` to the AMD installation unless you deliberately intend to run on Intel nodes.

## Storage
Your home directory has approximately 1.5 TB of storage. The higher-performance location `/ssdfs/datahome/<USERNAME>` has approximately 500 GB. Consult [Tongji University Scientific Computing Service Platform data transfer and storage documentation](https://dev.tongji.edu.cn/hpc-doc/#/pages/platformDes/dataTransfe){:target="_blank"} before selecting the execution directory.

For example,
```sh
mkdir -p /ssdfs/datahome/<USERNAME>/ISSM/execution
```

## Running Jobs on {{ page.machine_name }}
For example, to request one node and eight CPU cores from MATLAB, use,
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
```matlab
md.cluster = tjhpc('numnodes', 1, 'cpuspernode', 8);
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `tjhpc.py` still needs to be developed.
</div>
</div>

Use the AMD partition or AMD resource type in the {{ page.machine_name }} job configuration unless an Intel run is specifically required. Request only the resources needed by the model because larger node counts, longer wall times, and larger memory requests may increase queuing time.

See [Tongji University Scientific Computing Service Platform documentation for resource configuration](https://dev.tongji.edu.cn/hpc-doc/#/pages/quickStart/resourceConfig){:target="_blank"} and [job submission](https://dev.tongji.edu.cn/hpc-doc/#/pages/quickStart/jobSubmit){:target="_blank"}.

## Monitoring and Cancelling Jobs
A comparison of PBS and Slurm commands is available in the [Slurm Rosetta stone](https://slurm.schedmd.com/rosetta.pdf){:target="_blank"}. An [overview of Slurm on {{ page.machine_name }}](https://dev.tongji.edu.cn/hpc-doc/#/pages/quickStart/concept){:target="_blank"}.

If you want to check the status of your job and the node you are using on {{ page.machine_name }}, run,
```sh
squeue -u <USERNAME>
```
replacing `<USERNAME>` with your {{ page.machine_name }} username.

Inspect a job,
```sh
scontrol show job <JOBID>
```

Cancel a job,
```sh
scancel <JOBID>
```
where `<JOBID>` is the ID of the job indicated in the MATLAB session. MATLAB also indicates the directory where you job is running, which contains the files `<JOBNAME>.outlog` and `<JOBNAME>.errlog`. The `outlog` file contains any information that would appear if you were running your job on your local machine and the `errlog` file contains any information pertaining to errors that the job encounters.

## Loading Results Manually
If a network interruption prevents MATLAB from retrieving completed results automatically, use,
```matlab
md = loadresultsfromcluster(md, 'LAUNCHSTRING', 'JOBNAME');
```

When `md.settings.waitonlock > 0`, set the runtime name first,
```matlab
md.private.runtimename = 'LAUNCHSTRING';
md = loadresultsfromcluster(md, 'LAUNCHSTRING', 'JOBNAME');
```

## Slurm
A comparison of PBS and Slurm commands is available in the [Slurm Rosetta stone](https://slurm.schedmd.com/rosetta.pdf){:target="_blank"}. An overview of Slurm on {{ page.machine_name }} is available [here](https://dev.tongji.edu.cn/hpc-doc/#/pages/quickStart/concept){:target="_blank"}.
