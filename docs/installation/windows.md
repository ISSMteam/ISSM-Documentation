---
title: Windows
layout: default
parent: Installation
nav_order: 3
---

# Windows
## Precompiled Distributable
The quickest way to get started with ISSM is to download one of our precompiled distributables. They have been tested on Windows 10 and 11.

- <a href="https://ross.ics.uci.edu/ISSM-Windows-MATLAB.tar.gz" target="_blank">MATLAB</a>

{: .highlight-title }
> Note
>
> - ISSM is currently limited to basic capabilities on Windows. We will be working soon on supporting external packages such as Dakota and advanced capabiltites like modelling of solid earth processes.
> - Currently, only the MATLAB interface to ISSM is supported on Windows.

After downloading the distributable, unpack it with the 'Extract' feature and move it to the desired location on disk.

You are now ready to 
<a href="../getting-started" target="_top">get started with ISSM</a>!

<hr>

## Compiling ISSM from Source
The following instructions detail how to create an environment for compiling ISSM from source on Windows. We rely on MSYS2 to provide a Linux-like interface and the MinGW compiler chain to generate native Windows executables and libraries. There may be other methods for achieving the above, which we invite you to share on <a href="https://issm.ess.uci.edu/forum" target="_blank">the ISSM forum</a>.

**NOTE**: You will have to use an Administrator user account for some of the following to work as intended

## MSYS2
### Install MSYS2

- Navigate to <a href="https://www.msys2.org" target="_blank">the MSYS2 website</a>
- Download the installer
- When the download completes, run the installer
- Use the default value for 'Installation Folder'
- Use the default value for 'Start Menu shortcuts'
- Deselect 'Run MSYS 64bit now' and click the 'Finish' button

### Set up shortcut for MSYS2 terminal emulator

- In the Windows 'Search Bar', search for "MSYS2"
- The 'Best match' should be 'MSYS2 MSYS'; click 'Open file location'
- In the resulting File Explorer window, right-click 'MSYS2 MinGW 64-bit' and select 'Send to' &#8594; 'Desktop (create shortcut)'
- Right-click on the newly-created desktop shortcut and select 'Properties'
- click the 'Advanced...' button
- check the box labeled 'Run as administrator'
- click the 'OK' button
- click the 'Apply' button
- click the 'OK' button

### Update the package database and install required packages

- Double-click the 'MSYS2 MinGW 64-bit' desktop shortcut
- At the resulting command prompt run, 
````
$ pacman -Syu
 ````
to update the database and base packages, entering "Y" when prompted
- The previous step will result in the window being closed, so double-click the 'MSYS2 MinGW 64-bit' desktop shortcut again
- At the resulting command prompt run,
````
$ pacman -Su
````
until the resulting output is,
````
:: Starting core system upgrade...
 there is nothing to do
:: Starting full system upgrade...
 there is nothing to do
````
- Install necessary packages with,
````
$ pacman -S --needed base-devel git openssh python python-setuptools subversion unzip mingw-w64-x86_64-autotools mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc-fortran mingw-w64-x86_64-toolchain
````
entering "Y" or simply hitting the return key as needed
- (Optional) Install Vim text editor with,
````
$ pacman -S vim
  ````

## Scripting Interfaces
Follow the instructions for setting up the interface that you wish to use with ISSM.

### MATLAB
Download and install the desired version of MATLAB from the <a href="https://www.mathworks.com" target="_blank">MathWorks website</a>. Make sure to install the optional 'Mapping Toolbox'.

### Python
The Python interface to ISSM on Windows is currently under development.

## Shell profile
### .bash\_profile

- Open `/c/msys64/home/<USER>/.bash_profile` for editing (the easiest way to do this is with vim if you installed it in the previous step)
- Add the following to the bottom of the file,
````
# Allow for NTFS symbolic links
export MSYS=winsymlinks:nativestrict
````

### .bashrc

- Open `/c/msys64/home/<USER>/.bashrc` for editing and add the following at the bottom of the file:
```sh
## MATLAB
#
MATLAB_VER="<MATLAB_VER>" # Allows for easy resetting of MATLAB version added to path
export MATLAB_PATH=$(cygpath -u $(cygpath -ms "/c/Program Files/MATLAB/${MATLAB_VER}"))
export PATH="${MATLAB_PATH}/bin:${PATH}"

## ISSM
#
export ISSM_DIR=<ISSM_PATH>
export ISSM_DIR_WIN=$(cygpath -ms "${ISSM_DIR}") # Needed by MATLAB
```
where `<MATLAB_VER>` is the version of MATLAB that you have installed (for example, "R2023b") and `<ISSM_DIR>` is the path to the copy of the ISSM source code that you checked out (e.g. `/c/Users/<USER>/ISSM/src`, where `<USER>` is your username)

## Microsoft MPI

- Navigate to <a href="https://docs.microsoft.com/en-us/message-passing-interface/microsoft-mpi-release-notes" target="_blank">the 'Microsoft MPI Release Notes' webpage</a>
- Click the link for 'Microsoft Download Center' that corresponds with the latest release (take note of the version number that you download for the next step; it can also be found by going to 'Settings' / 'Apps &#38; Features')
- Click the 'Download' button
- Make sure both boxes are checked, then click the 'Next' button
- Click the 'Save File' button for each file
- When the download completes, run each installer
- Follow the prompts, using the default installation directories

## External Packages
The following packages and installation scripts are recommended for a basic installation of ISSM on Windows,

````
msmpi			install.sh
petsc			install-3.14-win-msys2-mingw-msmpi.sh
triangle		install-win-msys2-mingw.sh
m1qn3			install-win-msys2-mingw.sh
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

**NOTE**:

- Replace `<NUM_CPUS>` with the number of available CPU's
- `MATLAB_PATH` was defined previously in `bashrc`.
- `MSMPI_ROOT` will be defined after running,
````
$ source ${ISSM_DIR}/etc/environment.sh
````
- You may need to update the path to `libgfortran` in the `--with-fortran-lib` option

Next, create a configuration file called `configure.sh` in `${ISSM_DIR}`. Its contents will depend on the interface you will be using, the external packages and capabilities you wish to use, and the location of certain libraries and executables on disk. The following examples can be used for an installation of ISSM with basic capabilities,

### MATLAB Interface
````
./configure \
	--prefix=${ISSM_DIR} \
	--with-numthreads=<NUM_CPUS> \
	--with-matlab-dir=${MATLAB_PATH} \
	--with-mpi-include="${MSMPI_ROOT}/include" \
	--with-mpi-libdir="-Wl,-L${MSMPI_ROOT}/lib" \
	--with-mpi-libflags="-Wl,-lmsmpi" \
	--with-fortran-lib="-Wl,-L/c/msys64/mingw64/lib -Wl,-lgfortran" \
	--with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
	--with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
	--with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
	--with-semic-dir="${ISSM_DIR}/externalpackages/semic/install"
````

Again, you might need to make adjustments to the above configurations based on your system and needs. We have a number of resources to help here:
- Various external package install scripts and configurations in `${ISSM_DIR}/jenkins`
- <a href="hpc" target="_top">'High-Performance Computing' page</a>
- <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>
- ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a>

If the configuration completed without any errors, ISSM can now be compiled,
````
$ cd ${ISSM_DIR}
$ make
$ make install
````

You are now ready to 
<a href="../getting-started" target="_top">get started with ISSM</a>!

## (Optional) SSHd
**NOTE**: The following is probably not applicable to most users.

- Navigate to <a href="https://www.msys2.org/wiki/Setting-up-SSHd" target="_blank">the MSYS2 'Setting up SSHd' webpage</a>
- Copy the contents of the code block and paste to a new text file
- Set the value of the variable `UNPRIV_NAME` to the desired user
- If the user does not already exist, it will be created
- If the user does already exist, note the default password is the same that is used to log in to the Windows user account
- Save the file out to the location of your choice
- In a MSYS2 MinGW 64-bit shell instance, run the script
- If errors occur with messages about missing packages, install those packages and run the script again
- You can disregard the message,
````
cygrunsrv: Error removing a service: OpenService: Win32 error 1060:
The specified service does not exist as an installed service.
````
- The following message indicates that setup was successful, 
````
The MSYS2 sshd service is starting.
The MSYS2 sshd service was started successfully.
````
- You can test that the service and your log in are working correctly by running, 
````
ssh -l <UNPRIV_NAME> localhost
````
where `<UNPRIV_NAME>` is the same user that we authorized to use the service. You should be prompted to accept an ECDSA fingerprint, you which you respond "yes". Then, enter the password for this account. If all goes well, you should now have a prompt that reads, 
````
<UNPRIV_NAME>@<HOSTNAME> MSYS ~
````
- Once logged in to the target machine, open `/etc/ssh/sshd_config` for editing, add,
````
AcceptEnv MSYSTEM
````
then save out the changes. On the client machine, open `/etc/ssh/ssh_config` for editing, add, 
````
SendEnv MSYSTEM
````
to the file (you can add `MSYSTEM` to the list of environment variables if `SendEnv` already exists), then save out the changes. You can now prefix your SSH commands like, 
````
MSYSTEM=MINGW64 ssh [...]
````
in order to log in to the MSYS2 MinGW 64-bit shell (other possible values are MSYS2 and MINGW32).
- If an attempted SSH connection from a remote machine stalls out or is denied, it may be the case that you are running Windows Defender Firewall and need to open port 22. To do so,
- in the Windows search bar, search for "Defender" and select 'Windows Defender Firewall with Advanced Security'
- click 'Inbound Rules' in the left sidebar
- click 'New Rule...' in the right sidebar
- select 'Port', then click the 'Next' button
- select 'TCP'
- select 'Specific local ports', set the field to "22", then click the 'Next' button
- select 'Allow the connection' then click the 'Next' button (if you are using a third-party firewall application, it is up to you to determine how to open port 22)
- uncheck the 'Public' box (if a subsequent attempted connection stalls out or is denied, you may need to edit this rule, checking the 'Public' box, but try first without it), then click the 'Next' button
- set the 'Name' field to "SSH", then click the 'Next' button
- The `ssh-keygen` utility can be used to create a more secure SSH connection and to protect your Windows user password
- If you later decide that you want to stop the `sshd` service, you can do so with, 
````
net stop msys2_sshd
````
and can remove the service altogether with, 
````
cygrunsrv -R msys2_sshd
````
Sources:

- <a href="https://www.msys2.org/wiki/Setting-up-SSHd" target="_blank">MSYS2 'Setting up SSHd' webpage</a>
- <a href="https://gist.github.com/samhocevar/00eec26d9e9988d080ac" target="_blank">Sam Hocevar's GitHub Gist page on setting up SSHd under MSYS2</a>
