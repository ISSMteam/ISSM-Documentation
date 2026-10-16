---
title: Babylon
layout: default
parent: HPC
machine_name: "Babylon"
---

# Babylon (hosted by Thayer)
{: .no_toc }
----

## Getting an account
Anyone with a Dartmouth NetID has an account. See [Thayer documentation](https://kb.thayer.dartmouth.edu/article/361-linux-services).

Babylon's home directory is on a very small drive. Make sure to install ISSM in `/jumbo/ice/ISSM/` (Ask Colin to give you permission)`:

```sh
cd /jumbo/ice/ISSM/
mkdir YOURUSERNAME
```
and replace YOURUSERNAME by your username. This is where you should checkout ISSM and do your work.

## Environment
On Babylon, add the following lines to ```~/.bashrc```:

```sh
#Unload paraview to avoid mpi conflicts
module unload paraview/6.1.0

#ISSM
export ISSM_DIR=PATHTODIR
source $ISSM_DIR/etc/environment.sh

#MATLAB alias
alias ma='matlab -nodesktop -nosplash -r "addpath $ISSM_DIR/src/m/dev; devpath;"'
```

Use:
```sh
source ~/.bashrc
```
or Log out and log back in to apply this change.

## Installing ISSM on Babylon
You can clone ISSM and install the following packages:
- PETSc 3.26 (`./install-3.26-babylon.sh`) or later
- triangle (`./install-linux.sh`)

Use the following configuration script (adapt to your needs):

```sh
./configure \
    --prefix=$ISSM_DIR \
    --with-fortran-lib="-L/usr/lib/gcc/x86_64-linux-gnu/15 -lgfortran" \
    --with-matlab-dir="/thayerfs/apps/matlabR2026a/" \
    --with-triangle-dir="$ISSM_DIR/externalpackages/triangle/install" \
    --with-mpi-include="/usr/lib/x86_64-linux-gnu/openmpi/include" \
    --with-mpi-libflags="-L/usr/lib/x86_64-linux-gnu/openmpi/lib -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi" \
    --with-petsc-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-metis-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-parmetis-dir="$ISSM_DIR/externalpackages/petsc/install/" \
    --with-blas-lapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
    --with-scalapack-dir="$ISSM_DIR/externalpackages/petsc/install/" \
    --with-mumps-dir="$ISSM_DIR/externalpackages/petsc/install/" \
    --with-numthreads=20 \
    --enable-development \
    --enable-debugging
```
