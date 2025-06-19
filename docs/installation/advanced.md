---
title: Advanced Features
layout: default
parent: Installation
nav_order: 5
has_children: false
has_toc: false
---

# Advanced Features
## Development Build
If you plan on making changes to your installation of ISSM and/or contributions to the code base, you can enable development by adding the following to your configuration,
````
--enable-development
````
This prevents MATLAB/Python scripts from being copied from their respective locations in `${ISSM_DIR}/src` to `${ISSM_DIR}/bin` when ISSM is recompiled

## Debugging Build
Debugging features can be enabled by adding the following to your ISSM configuration with,
````
--enable-debugging
````
This will make several additional fields available for inspecting program state in certain modules of the ISSM core.

We can debug crashes during the solve phase by installing Valgrind using the appropriate installation script available at `${ISSM_DIR}/externalpackages/valgrind`.

See the 
<a href="../troubleshooting/debugging" target="_top">'Debugging' section</a>
for more info.

## Dakota
The <a href="https://dakota.sandia.gov/" target="_blank">Dakota project</a> delivers both state-of-the-art research and robust, usable software for optimization and UQ. Broadly, the Dakota software’s advanced parametric analyses enable design exploration, model calibration, risk analysis, and quantification of margins and uncertainty with computational models.

Dakota can be enabled by compiling and installing the following additional external packages,

#### Linux
````
gsl				install.sh
boost			install-1.7-linux.sh
dakota			install-6.2-linux.sh
chaco			install-linux.sh
````

#### macOS
````
gsl				install.sh
boost			install-1.7-mac.sh
dakota			install-6.2-mac.sh
chaco			install-mac.sh
````

and making the following additions to the ISSM configuration, reconfiguring, and recompiling,

````
--with-gsl-dir=${ISSM_DIR}/externalpackages/gsl/install \
--with-boost-dir=${ISSM_DIR}/externalpackages/boost/install \
--with-dakota-dir=${ISSM_DIR}/externalpackages/dakota/install \
--with-chaco-dir=${ISSM_DIR}/externalpackages/chaco/install
````

## Solid Earth
Capabilities for modelling solid earth processes can be enabled by compiling and installing the following additional external packages,

#### Linux
````
curl			install-7-mac.sh
hdf5			install-1.sh
netcdf			install-4.sh
proj			install-6.sh
gdal			install-3.sh
gshhg			install.sh
gmt				install-6-mac.sh
gmsh			install-4-mac.sh
````

#### macOS
````
curl			install-7-linux.sh
hdf5			install-1.sh
netcdf			install-4.sh
proj			install-6.sh
gdal			install-3.sh
gshhg			install.sh
gmt				install-6-linux.sh
gmsh			install-4-linux.sh
````

and making the following additions to the ISSM configuration, reconfiguring, and recompiling,

````
--with-hdf5-dir="${ISSM_DIR}/externalpackages/hdf5/install" \
--with-proj-dir="${ISSM_DIR}/externalpackages/proj/install"
````

{: .highlight-title }
> Important
>
> If you will be using the Python interface to ISSM, use the `install-3-python.sh` script to compile GDAL.

## Automatic Differentiation
Automatic differentiation is only supported under Linux and Mac. 

### CoDiPack installation (recommended)
CoDiPack can be enabled by compiling and installing the following additional external packages,

````
gsl				install.sh
codipack		install.sh
medipack		install-linux.sh
````

Note that the PETSc libraries are incompatible with automatic differentiation, but we still use PETSc to install other external packages to solve linear systems. As such, we remove the `--with-petsc-dir` option from the ISSM configuration. You will also need to deactivate
ISSM's kriging capability. The following is an example configuration script:

````
export CXXFLAGS="-g -O3 -fPIC -std=c++11 -DCODI_ForcedInlines"
./configure \
	--prefix=${ISSM_DIR} \
	--enable-tape-alloc \
	--without-kriging \
	--enable-debugging \
	--without-kml \
	--without-Love \
	--without-Sealevelchange \
	--with-numthreads=<NUM_CPUS> \
	--with-matlab-dir="<MATLAB_PATH>" \
	--with-fortran-lib="-L/usr/lib/x86_64-linux-gnu -lgfortran" \
	--with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpicxx -lmpifort" \
	--with-mpi-include=${ISSM_DIR}/externalpackages/petsc/install/include \
	--with-blas-lapack-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-metis-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-parmetis-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-scalapack-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-mumps-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-gsl-dir=${ISSM_DIR}/externalpackages/gsl/install \
	--with-triangle-dir=$ISSM_DIR/externalpackages/triangle/install \
	--with-m1qn3-dir="$ISSM_DIR/externalpackages/m1qn3/install" \
	--with-codipack-dir="$ISSM_DIR/externalpackages/codipack/install" \
	--with-medipack-dir="$ISSM_DIR/externalpackages/medipack/install"
````

where `<NUM_CPUS>` is the number of available CPU's.

Reconfigure and recompile ISSM and it will now be fully adjoinable.

### ADOL-C installation
ADOL-C can be enabled by compiling and installing the following additional external packages,

#### Linux
````
adjoinablempi	install-linux.sh
ADOL-C			install.sh
````

#### macOS
````
adjoinablempi	install-mac.sh
adolc			install.sh
````

Note that the PETSc libraries are incompatible with automatic differentiation, but we still use PETSc to install other external packages to solve linear systems. As such, we remove the `--with-petsc-dir` option from the ISSM configuration. You will also need to deactivate
ISSM's kriging capability. The following is an example configuration script:

````
./configure \
	--prefix=${ISSM_DIR} \
	--enable-debugging \
	--without-kriging \
	--without-kml \
	--without-Sealevelchange \
	--without-Love \
	--with-numthreads=<NUM_CPUS> \
	--with-matlab-dir="<MATLAB_PATH>" \
	--with-fortran-lib="-L/usr/lib/x86_64-linux-gnu -lgfortran" \
	--with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpicxx -lmpifort" \
	--with-mpi-include=${ISSM_DIR}/externalpackages/petsc/install/include \
	--with-blas-lapack-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-metis-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-parmetis-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-scalapack-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-mumps-dir=${ISSM_DIR}/externalpackages/petsc/install \
	--with-gsl-dir=${ISSM_DIR}/externalpackages/gsl/install \
	--with-triangle-dir=$ISSM_DIR/externalpackages/triangle/install \
	--with-m1qn3-dir="$ISSM_DIR/externalpackages/m1qn3/install" \
	--with-adolc-dir=$ISSM_DIR/externalpackages/adolc/install \
	--with-ampi-dir=$ISSM_DIR/externalpackages/adjoinablempi/install
````

where `<NUM_CPUS>` is the number of available CPU's.

Reconfigure and recompile ISSM and it will now be fully adjoinable.

