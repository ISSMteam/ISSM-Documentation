---
title: Configuring and Compiling ISSM
layout: default
parent: Troubleshooting
nav_order: 2
---

# Configuring and Compiling ISSM
## ld: library not found for -lflapack
If you get the following error: `ld: library not found for -lflapack` (generally happens on macOS), remove the line `--with-blas-lapack-dir` from your configuration and try compiling again.

## ld: file not found: @rpath/<LIBRARY\_NAME>.dylib for architecture <ARCH>
If you get a variation of the above error on macOS (where `<LIBRARY_NAME>` is a version of 'libquadmath' or 'libgcc'), you need to add the path to the GFortran libraries to your shell configuration file.

If you installed GFortran via FX Coudert's GitHub repository, you should add,
````
export LIBRARY_PATH="/usr/local/gfortran/lib:${LIBRARY_PATH}"
````

If you installed GFortran via Homebrew, you should add,
````
export LIBRARY_PATH="/usr/local/Cellar/gcc/<VER>/lib/gcc/current:${LIBRARY_PATH}"
````

