---
title: Linux
layout: default
parent: Installation
nav_order: 1
---

# Linux
## Precompiled Distributable
The quickest way to get started with ISSM is to download one of our precompiled distributables. They have been tested on the latest Debian and Ubuntu distributions. Note that for the Python interface, you will also need to follow the setup instructions in the <a href="#linux-python-interface" target="_top">'Scripting Interfaces' &#8594; 'Python Interface' section</a>.

- <a href="https://ross.ics.uci.edu/ISSM-Linux-MATLAB.tar.gz" target="_blank">MATLAB</a>
- <a href="https://ross.ics.uci.edu/ISSM-Linux-Python-3.tar.gz" target="_blank">Python 3</a> (currently compiled against Python 3.11)

After downloading the distributable, unpack it with the Archive Manager (or similar utility) or in a terminal with,
```sh
tar -zxvf <DISTRIBUTABLE>
```
and move it to the desired location on disk.

You are now ready to 
<a href="../using-issm/getting-started" target="_top">get started with ISSM</a>!

<hr>

## Compiling ISSM from Source
To get started, clone or fork a copy of the ISSM source code repository from <a href="https://github.com/ISSMteam/ISSM" target="_blank">GitHub</a>.

## Environment
Configuring, compiling, and running ISSM requires at least one environment variable, which can be achieved by running the following,

`bash, zsh`
```sh
export ISSM_DIR=<ISSM_PATH>
```

`csh`
```sh
setenv ISSM_DIR <ISSM_PATH>
```

where `<ISSM_PATH>` is the path to the copy of the ISSM source code that you checked out in the previous step (ex: `${HOME}/ISSM/src`).

## System Packages
**NOTE**: The following assumes use of the GNU compiler collection (i.e. `gcc`, `gfortran`), the APT package manager, and `sudo` privileges.

Install a basic package set with,
```sh
sudo apt-get install build-essential gfortran libssl-dev
```

If you will be installing the GDAL external package, install dependencies with,
```sh
sudo apt-get install swig
```

If you will be installing the PROJ external package, install dependencies with,
```sh
sudo apt-get install libsqlite3-dev sqlite3
```

**NOTE**: Some systems may require a link to be created so that the linker can find `libstdc++`, which can be accomplished with,
```sh
sudo ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so
```

## Scripting Interfaces
Follow the instructions for setting up the interface that you wish to use with ISSM.

### MATLAB Interface
Download and install the desired version of MATLAB from the <a href="https://www.mathworks.com" target="_blank">MathWorks website</a>. Make sure to install the optional 'Mapping Toolbox'.

<i id="linux-python-interface"></i>
### Python Interface
**NOTE**: There are various methods for installing the required packages. The following is our suggestion.

Install Python 3 with,
```sh
sudo apt-get install python3-minimal
```
Install required Python 3 header files with,
```sh
sudo apt-get install python3-dev
```
Install `venv` module with,
```sh
sudo apt-get install python3-venv
```
Install pip with,
```sh
sudo apt-get install python3-pip
```
Create a Python virtual environment for ISSM and activate it with,
```sh
mkdir ${HOME}/.venv
python3 -m venv ${HOME}/.venv/ISSM
source ${HOME}/.venv/ISSM/bin/activate
```

{: .highlight-title }
> Important
>
> - You can create your virtual environment anywhere on disk that you have permission to write to.
> - You will have to activate this virtual environment for each session that you want to run ISSM in. Alternatively, you can add the activation command to your shell configuration file.

Then, use pip to install NumPy, SciPy, and dependencies,
```sh
pip install matplotlib netcdf4 nose numpy pyshp scipy
```

Alternatively, copy and paste the following to achieve all of the above,
```sh
sudo apt-get install python3-dev python3-minimal python3-pip python3-venv
mkdir ${HOME}/.venv
python3 -m venv ${HOME}/.venv/ISSM
source ${HOME}/.venv/ISSM/bin/activate
pip install matplotlib netcdf4 nose numpy pyshp scipy
```

## External Packages
The following packages and installation scripts are recommended for a basic installation of ISSM on Linux,
````
autotools		install-linux.sh
cmake			install.sh
petsc			install-3.22-linux.sh
triangle		install-linux.sh
m1qn3			install.sh
````

{: .highlight-title }
> Important
>
> After successfully compiling and installing a package, run,
> ```sh
> source ${ISSM_DIR}/etc/environment.sh # bash, zsh
> ```
> or,
> ```sh
> source ${ISSM_DIR}/etc/environment.csh # csh
> ```
> so that the newly-installed package can be found by subsequent packages that may depend on it.

## Configuring and Compiling ISSM
We rely on the Autotools to allow us to configure and compile ISSM on a variety of systems. To begin, run,
```sh
cd ${ISSM_DIR}
autoreconf -ivf
```

Next, create a configuration file called `configure.sh` in `${ISSM_DIR}`. Its contents will depend on the interface you will be using, the external packages and capabilities you wish to use, and the location of certain libraries and executables on disk. The following examples can be used for an installation of ISSM with basic capabilities:

### MATLAB Interface
```sh
./configure \
	--prefix=${ISSM_DIR} \
	--with-matlab-dir="<MATLAB_PATH>" \
	--with-fortran-lib="-L/usr/local/gfortran/lib -lgfortran" \
	--with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
	--with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpicxx -lmpifort" \
	--with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
	--with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install"
```
where `<MATLAB_PATH>` is the path to the MATLAB installation that you wish to use (e.g. `/usr/local/MATLAB/R2024a`).

### Python Interface
```sh
./configure \
	--prefix="${ISSM_DIR}" \
	--with-python="${HOME}/.venv/issm/bin/python" \
	--with-fortran-lib="-L/usr/local/gfortran/lib -lgfortran" \
	--with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
	--with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpicxx -lmpifort" \
	--with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
	--with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install"
```

Again, you might need to make adjustments to the above configurations based on your system and needs. We have a number of resources to help here:
- Various external package install scripts and configurations in `${ISSM_DIR}/jenkins`
- <a href="hpc" target="_top">'High-Performance Computing' page</a>
- <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>
- ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a>

If the configuration completed without any errors, ISSM can now be compiled with,
```sh
make
make install
```

You are now ready to 
<a href="../using-issm/getting-started" target="_top">get started with ISSM</a>!
