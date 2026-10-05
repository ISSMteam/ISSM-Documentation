---
title: External Packages
layout: default
parent: Troubleshooting
nav_order: 1
---

# Configuring and Compiling External Packages

## Chaco Multilevel Graph Partitioning Tool

### Error compiling on macOS
When compiling <a href="https://github.com/sandialabs/Chaco" target="_blank">Chaco</a> on macOS (most likely using the `${ISSM_DIR}/externalpackages/chaco/install.sh` script), you may encounter an error that reads,
```sh
util/smalloc.c:6:10: fatal error: 'malloc.h' file not found
#include <malloc.h>
         ^~~~~~~~~~
1 error generated.
make: *** [util/smalloc.o] Error 1
```

To correct this, you will have to have either Xcode Command Line Tools (preferred) or Xcode installed:
- To install the Xcode Command Line Tools, run `xcode-select --install`
- You can install Xcode through the Mac App Store

You will then need to modify the `CPATH` environment variable in your shell profile (e.g. `~/.bashrc`),

- If you installed the Xcode Command Line Tools,
```sh
export CPATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/malloc:/usr/include"
```
- If you installed Xcode,
```Sh
export CPATH="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/malloc:/usr/include"
```

Then, source your shell profile again and rerun the installation script.

## PETSc

### Timeout: Unable to run MPI program

When downloading MPICH via PETSc, you may encounter an error after the configuration and make stages that reads something like,
```sh
=============================================================================================
  Trying to download
  https://github.com/pmodels/mpich/releases/download/v5.0.0/mpich-5.0.0.tar.gz for MPICH
=============================================================================================
=============================================================================================
                  Running configure on MPICH; this may take several minutes
=============================================================================================
=============================================================================================
                     Running make on MPICH; this may take several minutes
=============================================================================================
=============================================================================================
                 Running make install on MPICH; this may take several minutes
=============================================================================================
TESTING: configureMPIEXEC from config.packages.MPI(config/BuildSystem/config/packages/MPI.py:201)
*********************************************************************************************
           UNABLE to CONFIGURE with GIVEN OPTIONS (see configure.log for details):
---------------------------------------------------------------------------------------------
  Timeout: Unable to run MPI program with
  <ISSM_DIR>/externalpackages/petsc/install/bin/mpiexec -n 1
  (1) make sure this is the correct program to run MPI jobs
  (2) your network may be misconfigured; see
  https://petsc.org/release/faq/#mpi-network-misconfigure
  (3) you may have VPN running whose network settings may not play nice with MPI
********************************************************************************************
```

The <a href="https://petsc.org/release/faq/#mpi-network-misconfigure" target="_top">PETSc FAQ page</a> indicates that it may be a missing entry in the `/etc/hosts` file. However, if the issue persists, run `export HWLOC_COMPONENTS=stop` (or add it to the PETSc installation script *before* the configure step) and then rerun the PETSc installation script. If this fixes the issue where MPI hangs, add the following to your shell profile (e.g. `~/.bash_profile`) to create a persistent fix for MPICH,
```sh
export HWLOC_COMPONENTS=stop
```

### Error running make on <EXT\_PKG>
When using PETSc to install an external package you may encounter a failure that reads,
````
Error running make on <EXT_PKG>
````

Inspection of `src/configure.log` should reveal a line similar to,
```sh
Error running make on <EXT_PKG>: Could not execute "['<CMD_STRING>']":
```
This is usually not a very helpful error message. What you can do is copy `<CMD_STRING>` and run it manually on the command line to reveal and correct the underlying errors.

### Error running configure on MPICH

With GCC 10 and later, when using PETSc to install MPICH, you may encounter a failure that reads,
```sh
Error running configure on MPICH
```

Inspection of `src/configure.log` should reveal,
```sh
error: The Fortran compiler gfortran will not compile files that call
the same routine with arguments of different types.
```
One way to get around this is to add,
```sh
--FFLAGS="-fallow-argument-mismatch"
```
to the list of configuration arguments.

## C++ error! MPI\_Finalize() could not be located! / Error running make; make install on MPICH

When configuring and/or compiling MPICH via PETSc, it may fail with either of the above error messages. Inspection of `src/configure.log` should reveal something like,
```sh
Checking for program /opt/homebrew/bin/mpicc...found
```
The solution here is one of the following:
1. Uninstall the MPI compiler set installed via package manager (in this example, Homebrew)
1. Make sure that the path to the desired non-MPI compiler set (e.g. `gcc`, `g++`) appears in the `PATH` environment variable before the path to the offending MPI compiler set
1. Remove the `--download-mpich=1` option from the PETSc configuration and instead supply the appropriate options to use the alternate MPI implementation

