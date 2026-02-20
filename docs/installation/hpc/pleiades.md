---
title: NASA NAS' Pleiades 
layout: default
parent: High-Performance Computing (HPC)
nav_exclude: true
---

# Pleiades (NASA NAS HECC)
{: .no_toc }
For comprehensive information on access to and use of NASA NAS High-End Computing Capability (HECC), please refer to <a href="https://www.nas.nasa.gov/hecc/support/kb" target="_blank">their knowledge base</a>.

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
New users will have to ask a NASA- or JPL-employed PI to request an account for them on NASA NAS HECC. They will need the group ID of the PI in order to submit this request.

First, the PI should use the following procedure,
- navigate to the <a href="https://www.nas.nasa.gov/hecc/portal/accounts" target="_blank">NASA NAS HECC 'Account Request System' page</a>
- select option '3. I want to request a NASA identity for one of my new users'
- provide the requested information

Then, the user needs to request an account with the following procedure,
- navigate to the <a href="https://www.nas.nasa.gov/hecc/portal/accounts" target="_blank">NASA NAS HECC 'Account Request System' page</a>
- select option '2. I want to request and account for myself'
- provide the group ID for the PI that initiated the request
- the PI will then receive an email to approve the request

NOTE: All users must complete NASA's Basic IT Security Training

### Current Points of Contact
{: .no_toc }
- Dartmouth security officer: <a href="mailto:Sean.R.McNamara@dartmouth.edu">Sean McNamara</a> (<a href="https://itc.dartmouth.edu/about/who-we-are/itc-leadership" target="_blank">Dartmouth ITC</a>)
- JPL IT security officer: <a href="mailto:Tomas.J.Soderstrom@jpl.nasa.gov">Tomas Soderstrom</a>
- UCI OIT security officer: <a href="mailto:jdrummon@uci.edu">Josh Drummond</a>

## Logging In
Please refer to the following documentation pages to log into NAS systems and make subsequent logins more seamless,
- <a href="https://www.nas.nasa.gov/hecc/support/kb/logging-into-nas-systems-for-the-first-time_539.html" target="_blank">Logging Into NAS Systems for the First Time</a>
- <a href="https://www.nas.nasa.gov/hecc/support/kb/setting-up-public-key-authentication_230.html" target="_blank">Setting Up Public Key Authentication</a>
- <a href="https://www.nas.nasa.gov/hecc/support/kb/setting-up-ssh-passthrough_232.html" target="_blank">Setting Up SSH Passthrough</a>
- <a href="https://www.nas.nasa.gov/hecc/support/kb/one-step-connection-using-public-key-and-passthrough_62.html" target="_blank">One-Step Connection Using Public Key and Passthrough</a>

## Checking Out a Copy of the ISSM Code Repository
Users should clone the ISSM code repository to their `/nobackup/` directory where they can save a lot more files than in their home directory.

## Environment
Add the following to `~/.bashrc` in order to set up the environment properly for compiling ISSM,
```sh
# Modules
module load mpi-hpe/mpt
module load comp-intel/2020.4.304
module load petsc/3.17.3_intel_mpt_py

# Variables
export CC=mpicc
export CXX=mpicxx
export F77=mpif77
export MPICC_CC=icx
export MPICXX_CXX=icpx
export MPF90_F90=ifort

export ISSM_DIR="<ISSM_DIR>"
```
replacing `<ISSM_DIR>` with the path to the local copy of the ISSM code repository. Run `source ~/.bashrc` to apply these changes to the current session.

{: .highlight-title }
> NOTE
>
> If `~/.bashrc` is not loaded when on login, add a new file, `~/.bash_login`, with the following content,
> ```sh
> if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
> ```

{: .highlight-title }
> NOTE
>
> The version of the `comp-intel` module as well as the corresponding value of variable `COMP_INTEL_ROOT` may need to be updated as recommended/available modules are updated on HECC. Please update this page or ask a project lead to do so when this occurs.

## Installing ISSM

{: .highlight-title }
> Important
>
> ISSM and external packages should not be compiled on the Pleiades front end. Please refer to the NAS HECC knowledge base article <a href="https://www.nas.nasa.gov/hecc/support/kb/reserving-a-dedicated-compute-node_556.html" target="_blank">'Reserving a Dedicated Compute Node'</a> for instructions on reserving a and logging into a compute node for the purpose of compiling.

{: .highlight-title }
> Important
>
> Do *not* install `mpich` and `petsc`. The MPI implementation (MPT) provided by HECC *must* be used. Pleiades will *only* be used to run solutions and the user's local machine for pre- and post-processing.

There are a number of configurations for ISSM provided below. Users may also refer to the recipes in `${ISSM_DIR}/jenkins/` prefixed with `pleiades-`.

### Installing ISSM with Basic Capabilities
For an installation of ISSM with basic capabilities, the only external packages required are,
```sh
autotools	install-linux.sh
triangle	install-linux.sh
m1qn3		install-linux.sh
semic		install.sh
```

Before configuring ISSM, run,
```sh
cd $ISSM_DIR
autoreconf -ivf
```

Then use the following configuring script (adapting it as needed),
```sh
export CFLAGS="-g -Ofast"
export CXXFLAGS="-g -Ofast -xCORE-AVX512,CORE-AVX2 -xAVX -std=c++11"

./configure \
	--prefix="${ISSM_DIR}" \
	--enable-development \
	--enable-standalone-libraries \
	--with-wrappers=no \
	--with-fortran-lib="-L${COMP_INTEL_ROOT}/compiler/lib/intel64_lin -lifcore -lifport -lgfortran" \
	--with-mkl-libflags="-L${COMP_INTEL_ROOT}/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
	--with-mpi-include="${MPI_ROOT}/include" \
	--with-mpi-libflags="-L${MPI_ROOT}/lib -lmpi" \
	--with-blas-lapack-lib="-L${COMP_INTEL_ROOT}/mkl/lib/intel64 -lmkl_blas95_lp64 -lmkl_lapack95_lp64" \
	--with-metis-dir="${PETSC_DIR}" \
	--with-parmetis-dir="${PETSC_DIR}" \
	--with-scalapack-lib="-L${COMP_INTEL_ROOT}/mkl/lib/intel64/libmkl_scalapack_lp64.so" \
	--with-mumps-dir="${PETSC_DIR}" \
	--with-petsc-dir="${PETSC_DIR}" \
	--with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
	--with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
	--with-semic-dir="${ISSM_DIR}/externalpackages/semic/install"
```

### Installing ISSM with Dakota
For an installation of ISSM with Dakota, the following external packages are required,
```sh
autotools	install-linux.sh
boost		install-1.7-linux.sh
dakota		install-6.2-pleiades.sh
chaco		install-linux.sh
triangle	install-linux.shwhic
m1qn3		install-linux.sh
semic		install.sh
```

Before configuring ISSM, run,
```sh
cd $ISSM_DIR
autoreconf -ivf
```

Then use the following configuring script (adapting it as needed),
```sh
export CFLAGS="-g -Ofast"
export CXXFLAGS="-g -Ofast -xCORE-AVX512,CORE-AVX2 -xAVX -std=c++11"

./configure \
	--prefix="${ISSM_DIR}" \
	--enable-development \
	--enable-standalone-libraries \
	--with-wrappers=no \
	--with-fortran-lib="-L${COMP_INTEL_ROOT}/compiler/lib/intel64_lin -lifcore -lifport -lgfortran" \
	--with-mkl-libflags="-L${COMP_INTEL_ROOT}/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
	--with-mpi-include="${MPI_ROOT}/include" \
	--with-mpi-libflags="-L${MPI_ROOT}/lib -lmpi" \
	--with-blas-lapack-lib="-L${COMP_INTEL_ROOT}/mkl/lib/intel64 -lmkl_blas95_lp64 -lmkl_lapack95_lp64" \
	--with-metis-dir="${PETSC_DIR}" \
	--with-parmetis-dir="${PETSC_DIR}" \
	--with-scalapack-lib="-L${COMP_INTEL_ROOT}/mkl/lib/intel64/libmkl_scalapack_lp64.so" \
	--with-mumps-dir="${PETSC_DIR}" \
	--with-petsc-dir="${PETSC_DIR}" \
	--with-boost-dir="${ISSM_DIR}/externalpackages/boost/install" \
	--with-dakota-dir="${ISSM_DIR}/externalpackages/dakota/install" \
	--with-chaco-dir="${ISSM_DIR}/externalpackages/chaco/install" \
	--with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
	--with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
	--with-semic-dir="${ISSM_DIR}/externalpackages/semic/install"
```

### Installing ISSM with Solid Earth Capabilities
For an installation of ISSM with solid Earth capabilities, the following external packages are required,
```sh
autotools	install-linux.sh
boost		install-1.7-linux.sh
dakota		install-6.2-pleiades.sh
chaco		install-linux.sh
zlib		install-1.sh
hdf5		install-1.sh
netcdf		install-4.sh
sqlite		install.sh
proj		install-6.sh
gdal		install-3-linux.sh
gshhg		install.sh
gmt			install-6-pleiades.sh
gmsh		install-4-pleiades.sh
triangle	install-linux.sh
m1qn3		install-linux.sh
semic		install.sh
```

Before configuring ISSM, run,
```sh
cd $ISSM_DIR
autoreconf -ivf
```

Then use the following configuring script (adapting it as needed),
```sh
export CFLAGS="-g -Ofast"
export CXXFLAGS="-g -Ofast -xCORE-AVX512,CORE-AVX2 -xAVX -std=c++11"

./configure \
	--prefix="${ISSM_DIR}" \
	--enable-development \
	--enable-standalone-libraries \
	--with-wrappers=no \
	--with-fortran-lib="-L${COMP_INTEL_ROOT}/compiler/lib/intel64_lin -lifcore -lifport -lgfortran" \
	--with-mkl-libflags="-L${COMP_INTEL_ROOT}/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
	--with-mpi-include="${MPI_ROOT}/include" \
	--with-mpi-libflags="-L${MPI_ROOT}/lib -lmpi" \
	--with-blas-lapack-lib="-L${COMP_INTEL_ROOT}/mkl/lib/intel64 -lmkl_blas95_lp64 -lmkl_lapack95_lp64" \
	--with-metis-dir="${PETSC_DIR}" \
	--with-parmetis-dir="${PETSC_DIR}" \
	--with-scalapack-lib="-L${COMP_INTEL_ROOT}/mkl/lib/intel64/libmkl_scalapack_lp64.so" \
	--with-mumps-dir="${PETSC_DIR}" \
	--with-hdf5-dir="${ISSM_DIR}/externalpackages/hdf5/install" \
	--with-petsc-dir="${PETSC_DIR}" \
	--with-boost-dir="${ISSM_DIR}/externalpackages/boost/install" \
	--with-dakota-dir="${ISSM_DIR}/externalpackages/dakota/install" \
	--with-chaco-dir="${ISSM_DIR}/externalpackages/chaco/install" \
	--with-proj-dir="${ISSM_DIR}/externalpackages/proj/install" \
	--with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
	--with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
	--with-semic-dir="${ISSM_DIR}/externalpackages/semic/install"
```

### Installing ISSM with CoDiPack
For an installation of ISSM with CoDiPack, the following external packages are required,
```sh
autotools	install-linux.sh
codipack
medipack
```

Before configuring ISSM, run,
```sh
cd $ISSM_DIR
autoreconf -ivf
```

Then use the following configuring script (adapting it as needed),
```sh
export CFLAGS="-g -Ofast -wd2196"
export CXXFLAGS="-g -Ofast -xCORE-AVX512,CORE-AVX2 -xAVX -std=c++11"

./configure \
	--prefix="${ISSM_DIR}" \
	--enable-development \
	--enable-standalone-libraries \
	--with-wrappers=no \
	--enable-tape-alloc \
	--without-kriging \
	--without-kml \
	--without-Sealevelchange \
	--without-Love \
	--with-fortran-lib="-L${COMP_INTEL_ROOT}/compiler/lib/intel64_lin -lifcore -lifport -lgfortran" \
	--with-mkl-libflags="-L${COMP_INTEL_ROOT}/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
	--with-mpi-include="${MPI_ROOT}/include" \
	--with-mpi-libflags="-L${MPI_ROOT}/lib -lmpi" \
	--with-metis-dir="${PETSC_DIR}" \
	--with-parmetis-dir="${PETSC_DIR}" \
	--with-mumps-dir="${PETSC_DIR}" \
	--with-codipack-lib="${ISSM_DIR}/externalpackages/codipack/install" \
	--with-medipack-lib="${ISSM_DIR}/externalpackages/medipack/install"
```

{: .highlight-title }
> NOTE
>
> You will get a lot of warnings while compiling (i.e. *warning #2196: routine is both "inline" and "noinline"*), which can be ignored.

## pfe_settings
You will have to add a file titled `pfe_settings.m` (or `pfe_settings.py`) in `$ISSM_DIR/src/m` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to Pleiades and retrieve results. For example, this file might include,
```
cluster.login='mmorligh';
cluster.queue='devel';
cluster.codepath='/nobackup/mmorligh/ISSM/bin';
cluster.executionpath='/nobackup/mmorligh/execution';
cluster.grouplist='s5692';
cluster.port=1099;
cluster.modules={'mpi-hpe/mpt', 'comp-intel/2020.4.304', 'petsc/3.17.3_intel_mpt_py'};
```

- `cluster.login` should be set to your NAS username
- `cluster.codepath` should be set to the `bin` directory of the installation of ISSM on Pleiades that you wish to use
- `cluster.executionpath` should be set to where the job should be run on Pleiades (should not be you home directory due to disk use quotas)
- `cluster.grouplist` should be set to the result of running `groups <USERNAME>` on Pleiades, where `<USERNAME>` is your NAS username
- `cluster.modules` should include the same modules that we set above in the 'Environment' step for compiling ISSM

The above settings will be found automatically by MATLAB (or Python) when setting the cluster class for your model, i.e.,
```
md.cluster=pfe();
```

## Running Jobs on Pleiades
On Pleiades, the more nodes and time requested, the longer your job will have to wait in the queue, so choose your settings accordingly. For example,
```
md.cluster=pfe('numnodes',1,'time',28,'processor','bro','queue','devel');
md.cluster.time=10;
```
will request a maximum job time of 10 minutes and one Broadwell node. If the run lasts more than 10 minutes, it will be killed and you will not be able to retrieve your results.

For more information on the available processor types, please refer to the NAS HECC knowledge base article <a href="https://www.nas.nasa.gov/hecc/support/kb/pleiades-configuration-details_77.html" target="_blank">'Pleiades Configuration Details'</a>.

If you want to check the status of your job and the queue that you are using, run,
```
qstat -u <USERNAME>
```
You can delete your job manually by typing,
```
qdel <JOB_ID>
```
where `<JOB_ID>` is the job ID reported on your local machine when you submitted your solution request. Also reported is the directory where you can find log files associated with the run (i.e. `<JOB_ID>.outlog` and `<JOB_ID>.errlog`). The `outlog` contains the information that would normally be printed to the console if you were running the job on your local machine. Likewise, the `errlog` contains any information printed in case of error.

If you would like to load results from the cluster manually (for example, if you encountered an error due to network disconnection), run,
```
md=loadresultsfromcluster(md,'runtimename','<EXEC_DIR>');
```
where `<EXEC_DIR>` is the parent of the job on your local machine, for example,
```
${ISSM_DIR}/execution/<EXEC_DIR>/<JOB_ID>.lock
```
