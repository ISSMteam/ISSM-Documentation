---
title: Pleiades (NASA NAS HECC)
layout: default
parent: High-Performance Computing (HPC)
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
