---
title: macOS
layout: default
parent: Installation
nav_order: 2
has_children: false
has_toc: false
---

# macOS
## Precompiled Distributable
The quickest way to get started with ISSM is to download one of our precompiled distributables. They have been tested on the latest version of macOS.

Note that for the Python interface, you will also need to follow the setup instructions in the <a href="#macos-python-interface" target="_top">'Scripting Interfaces' &#8594; 'Python Interface' section</a>.

### Silicon-based Macs

- <a href="https://ross.ics.uci.edu/ISSM-macOS-Silicon-MATLAB.zip" target="_blank">MATLAB</a>
- <a href="https://ross.ics.uci.edu/ISSM-macOS-Silicon-Python-3.zip" target="_blank">Python 3</a> (currently compiled against Python 3.11)

### Intel-based Macs

- <a href="https://ross.ics.uci.edu/ISSM-macOS-Intel-MATLAB.zip" target="_blank">MATLAB</a>
- <a href="https://ross.ics.uci.edu/ISSM-macOS-Intel-Python-3.zip" target="_blank">Python 3</a> (currently compiled against Python 3.11)

After downloading the distributable, simply unzip it and move it to the desired location on disk.

You are now ready to 
<a href="../getting-started" target="_top">get started with ISSM</a>!

<hr>

## Compiling ISSM from Source
To get started, clone or fork a copy of the ISSM source code repository from <a href="https://github.com/ISSMteam/ISSM" target="_blank">GitHub</a>.

## Environment
Configuring, compiling, and running ISSM requires at least one environment variable, which can be achieved by running the following,

`bash, zsh`
````
export ISSM_DIR=<ISSM_PATH>
````

`csh`
````
setenv ISSM_DIR <ISSM_PATH>
````

where `<ISSM_PATH>` is the path to the copy of the ISSM source code that you checked out in the previous step (e.g. `${HOME}/ISSM/src`).

## System Packages
**NOTE**: The following assumes use of the GNU compiler collection (i.e. `gcc`, `gfortran`), the <a href="https://brew.sh" target="_blank">Homebrew package manager</a>, and `sudo` privileges.

In order to install ISSM on macOS, you will need the Xcode Command Line Tools, which can be installed with,
````
xcode-select --install
````
Alternatively, you can use the compiler and other build tools that come with <a href="https://developer.apple.com/xcode/" target="_blank">Xcode</a>, but if you do not otherwise use Xcode as an IDE, we recommend installing only the Command Line Tools.

{: .highlight-title }
> Important
>
> Having both the Command Line Tools and Xcode installed can cause toolchain conflicts in some cases. If you are experiencing difficult-to-debug issues during configuration or compilation, try the following, which will select the Command Line Tools as the default,
> ````
> sudo xcode-select --switch /Library/Developer/CommandLineTools
> ````

Unfortunately, both the Command Line Tools and Xcode lack a Fortran compiler, which is required for various external packages. We recommend either of the following methods for installing `gfortran`,

- <a href="https://github.com/fxcoudert/gfortran-for-macOS" target="_blank">FX Coudert's GitHub repository for macOS installers for GNU Fortran</a>.
- Via Homebrew with,
  ````
brew install gfortran
  ````

If you will be installing the PROJ external package, you can install dependencies via Homebrew with,
````
brew install sqlite3
````

## Scripting Interfaces
Follow the instructions for setting up the interface that you wish to use with ISSM.

### MATLAB Interface
Download and install the desired version of MATLAB from the <a href="https://www.mathworks.com" target="_blank">MathWorks website</a>. Make sure to install the optional 'Mapping Toolbox'.

<i id="macos-python-interface"></i>
### Python Interface
**NOTE**:
- We assume use of copy of Python 3 supplied by the Command Line Tools.
- There are various methods for installing the required packages. The following is our suggestion.

Create a Python virtual environment for ISSM and activate it with,
````
mkdir ${HOME}/.venv
python3 -m venv ${HOME}/.venv/ISSM
source ${HOME}/.venv/ISSM/bin/activate
````

{: .highlight-title }
> Important
>
> - You can create your virtual environment anywhere on disk that you have permission to write to.
> - You will have to activate this virtual environment for each session that you want to run ISSM in. Alternatively, you can add the activation command to your shell configuration file.

Then, use pip to install NumPy, SciPy, and dependencies,
````
pip install matplotlib netcdf4 nose numpy pyshp scipy
````

## External Packages
The following packages and installation scripts are recommended for a basic installation of ISSM on Linux,
````
autotools		install-linux.sh
cmake			install.sh
petsc			install-3.22-mac.sh
triangle		install-mac.sh
m1qn3			install.sh
````

{: .highlight-title }
> Important
>
> After successfully compiling and installing a package, run,
> ````
> source ${ISSM_DIR}/etc/environment.sh # bash, zsh
> ````
> or,
> ````
> source ${ISSM_DIR}/etc/environment.csh # csh
> ````
> so that the newly-installed package can be found by subsequent packages that may depend on it.

## Configuring and Compiling ISSM
We rely on the Autotools to allow us to configure and compile ISSM on a variety of systems. To begin, run,
````
cd ${ISSM_DIR}
autoreconf -ivf
````

Next, create a configuration file called `configure.sh` in `${ISSM_DIR}`. Its contents will depend on the interface you will be using, the external packages and capabilities you wish to use, and the location of certain libraries and executables on disk. 

**NOTE**: Both of the following interface configurations refer to `<LIBGFORTRAN_PATH>`, which should be substituted for the path to the parent directory of `libgfortran`. Common locations of `<LIBGFORTRAN_PATH>` on macOS are,

- `/usr/local/gfortran/lib` if you installed using one of the packages from FX Coudert's GitHub repository for macOS installers for GNU Fortran
- `/opt/homebrew/lib/gcc/current` if you installed via Homebrew on a Silicon-based Mac
- `/usr/local/Cellar/gcc/<VER>/lib/gcc/current` (where `<VER>` is the version of `gcc`) if you installed via Homebrew on an Intel-based Mac

The following examples can be used for an installation of ISSM with basic capabilities:

### MATLAB Interface
````
./configure \
	--prefix=${ISSM_DIR} \
	--with-matlab-dir="<MATLAB_PATH>" \
	--with-fortran-lib="-L<LIBGFORTRAN_PATH> -lgfortran" \
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
````
where `<MATLAB_PATH>` is the path to the MATLAB installation that you wish to use (e.g. `/Applications/MATLAB_R2024a.app`).

### Python Interface
````
./configure \
	--prefix="${ISSM_DIR}" \
	--with-python="${HOME}/.venv/issm/bin/python" \
	--with-fortran-lib="-L<LIBGFORTRAN_PATH> -lgfortran" \
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
````

Again, you might need to make adjustments to the above configurations based on your system and needs. We have a number of resources to help here:
- Various external package install scripts and configurations in `${ISSM_DIR}/jenkins`
- <a href="hpc" target="_top">'High-Performance Computing' page</a>
- <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>
- ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a>

If the configuration completed without any errors, ISSM can now be compiled with,
````
make
make install
````

You are now ready to 
<a href="../getting-started" target="_top">get started with ISSM</a>!

