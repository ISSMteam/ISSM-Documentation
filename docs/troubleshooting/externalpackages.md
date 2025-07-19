---
title: Configuring and Compiling External Packages
layout: default
parent: Troubleshooting
nav_order: 1
---

# Configuring and Compiling External Packages
## Chaco Multilevel Graph Partitioning Tool
### Error compiling on macOS
When compiling <a href="https://github.com/sandialabs/Chaco" target="_blank">Chaco</a> on macOS (most likely using the `${ISSM_DIR}/externalpackages/chaco/install.sh` script), you may encounter an error that reads,
````
util/smalloc.c:6:10: fatal error: 'malloc.h' file not found
#include <malloc.h>
         ^~~~~~~~~~
1 error generated.
make: *** [util/smalloc.o] Error 1
````

To correct this, you will have to have either Xcode Command Line Tools (preferred) or Xcode installed.

- To install the Xcode Command Line Tools, run `xcode-select --install`
- You can install Xcode through the Mac App Store

You will then need to modify the `CPATH` environment variable in your shell profile (e.g. `~/.bashrc`),

- If you installed the Xcode Command Line Tools, 
  ````
export CPATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/malloc:/usr/include"
  ````
- If you installed Xcode,
  ````
export CPATH="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/malloc:/usr/include"
  ````

Then, source your shell profile again and rerun the installation script.

## PETSc
## Error running make on <EXT\_PKG>
When using PETSc to install an external package you may encounter a failure that reads,
````
Error running make on <EXT_PKG>
````

Inspection of `src/configure.log` should reveal a line similiar to,
````
Error running make on <EXT_PKG>: Could not execute "['<CMD_STRING>']":
````
This is usually not a very helpful error message. What you can do is copy `<CMD_STRING>` and run it manually on the command line to reveal and correct the underlying errors.

### Error running configure on MPICH
With GCC 10 and later, when using PETSc to install MPICH, you may encounter a failure that reads,
````
Error running configure on MPICH
````

Inspection of `src/configure.log` should reveal,
````
error: The Fortran compiler gfortran will not compile files that call
the same routine with arguments of different types.
````
One way to get around this is to add,
````
--FFLAGS="-fallow-argument-mismatch"
````
to the list of configuration arguments.

## C++ error! MPI\_Finalize() could not be located! / Error running make; make install on MPICH
When configuring and/or compiling MPICH via PETSc, it may fail with either of the above error messages. Inspection of `src/configure.log` should reveal something like,
````
Checking for program /opt/homebrew/bin/mpicc...found
````
The solution here is one of the following,

1. Uninstall the MPI compiler set installed via package manager (in this example, Homebrew)
1. Make sure that the path to the desired non-MPI compiler set (e.g. `gcc`, `g++`) appears in the `PATH` environment variable before the path to the offending MPI compiler set
1. Remove the `--download-mpich=1` option from the PETSc configuration and instead supply the appropriate options to use the alternate MPI implementation

