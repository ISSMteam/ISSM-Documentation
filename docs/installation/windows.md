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
> - ISSM is currently limited to basic capabilities on Windows. We will be working soon on supporting external packages such as Dakota and advanced capabilities like modelling of solid Earth processes.
> - Currently, only the MATLAB interface to ISSM is supported on Windows.

After downloading the distributable, unpack it with the 'Extract' feature and move it to the desired location on disk.

You are now ready to <a href="../using-issm/getting-started" target="_top">get started with ISSM</a>!

<hr>

## Compiling ISSM from Source
The following instructions detail how to create an environment for compiling ISSM from source on Windows. We rely on MSYS2 to provide a Linux-like interface and the MinGW compiler chain to generate native Windows executables and libraries. There may be other methods for achieving the above, which we invite you to share on <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">GitHub Discussions</a>.

{: .highlight-title }
> Note
>
> - This tutorial was written for Windows 10, but much of it is the same or can easily be adapted for Windows 11.
> - You will have to use an Administrator user account for some of the following to work as intended.

## MSYS2

### Install MSYS2
- Navigate to <a href="https://www.msys2.org" target="_blank">the MSYS2 website</a>
- Download the installer
- When the download completes, run the installer
- Use the default value for 'Installation Folder'
- Use the default value for 'Start Menu shortcuts'
- Uncheck 'Run MSYS now' and click the 'Finish' button

### Set Up MSYS2 UCRT64 Shell Launcher
- Open 'File Explorer' and navigate to 'This PC' > 'Local Disk (C:)' > 'msys64'
- Right-click the 'ucrt64' application and select 'Properties'
- Switch to the 'Compatibility' tab, check the 'Run this program as an administrator' check box, click the 'Apply' button, then close the window
- Right-click the 'ucrt64' application again and select 'Pin to taskbar'

### Update the Package Database and Install Required Packages
- Launch the MSYS2 UCRT64 Shell by clicking the taskbar icon
-  When prompted, "Do you want to allow this app from an unknown publisher to make changes to your device?" click the 'Yes' button
- At the resulting command prompt run,
```sh
pacman -Syu
```
to update the database and base packages, entering "Y" when prompted
- The previous step will result in the window being closed, so launch the MSYS UCRT64 Shell again
- At the resulting command prompt run,
```sh
pacman -Su
```
until the resulting output is,
```sh
:: Starting core system upgrade...
 there is nothing to do
:: Starting full system upgrade...
 there is nothing to do
```
- Install necessary packages with,
```sh
pacman -S --needed base-devel git openssh python python-setuptools subversion unzip mingw-w64-ucrt-x86_64-autotools mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-gcc-fortran mingw-w64-ucrt-x86_64-msmpi mingw-w64-ucrt-x86_64-toolchain
```
entering "Y" or simply hitting the return key as needed
- (Optional) Install Vim text editor with,
```sh
pacman -S vim
```

## Scripting Interfaces
Follow the instructions for setting up the interface that you wish to use with ISSM,
<div class="issm-api-tabs">
<div class="tab" data-api="matlab" markdown="1">
Download and install the desired version of MATLAB from the <a href="https://www.mathworks.com" target="_blank">MathWorks website</a>. Make sure to install the optional 'Mapping Toolbox'.
</div>
<div class="tab" data-api="python" markdown="1">
The Python interface to ISSM on Windows is currently under development.
</div>
</div>

## Edit Shell Profile Files

### .bash\_profile
- Open `/c/msys64/home/<USER>/.bash_profile` for editing (the easiest way to do this is with Vim if you installed it in the previous step)
- Add the following to the bottom of the file,
```sh
# Allow for NTFS symbolic links
export MSYS=winsymlinks:nativestrict
```

### .bashrc
Open `/c/msys64/home/<USER>/.bashrc` for editing and add the following at the bottom of the file,
```sh
## MATLAB
#
MATLAB_VER="<MATLAB_VER>" # Allows for easy resetting of MATLAB version added to path
export MATLAB_PATH=$(cygpath -u $(cygpath -ms "/c/Program Files/MATLAB/${MATLAB_VER}"))
export PATH="${MATLAB_PATH}/bin:${PATH}"

## ISSM
#
export ISSM_DIR=<PATH_TO_ISSM>
export ISSM_DIR_WIN=$(cygpath -ms "${ISSM_DIR}") # Needed by MATLAB
```
where `<MATLAB_VER>` is the version of MATLAB that you have installed (e.g. "{{ site.matlab_ver }}") and `<PATH_TO_ISSM>` is the path to the copy of the ISSM source code that you checked out (e.g. `/c/Users/<USER>/ISSM/src`, where `<USER>` is your username).

## Installing the Microsoft Distribution of MS-MPI
- Navigate to <a href="https://www.microsoft.com/en-us/download" target="_blank">the 'Microsoft Download Center' webpage</a>
- Search for "Microsoft MPI <MSMPI_VER>", where `<MSMPI_VER>` matches the version of the MS-MPI compilers that you installed via `pacman` (see 'Important' callout below)

{: .highlight-title }
> Important
>
> The version of the MS-MPI runtime and SDK that you download from Microsoft must agree with the version of the MS-MPI compilers that you installed via `pacman`. For example, if running,
```sh
pacman -Qi ucrt-w64-x86_64-msmpi
```
shows,
```sh
Version         : 10.1.1-23
```
then the correct Microsoft distribution to download is version 10.1.1 (`23` is the MSYS2 build/package revision).

- Click the 'Download' button
- Make sure both boxes are checked, then click the 'Download' button
- When the download completes, run each installer
- Follow the prompts, using the default installation directories

## (Optional) Fork the ISSM Source Code Repository
- If you will be contributing to ISSM' development, create a fork of <a href="https://github.com/ISSMteam/ISSM" target="_blank">the ISSM source code repository on GitHub</a>.
- Generate an SSH key in a MSYS2 UCRT64 shell instance with,
```sh
mkdir ~/.ssh 2> /dev/null
ssh-keygen -t ed25519 \
	-f ~/.ssh/github-deploy-key-<OWNER>-ISSM \
	-C "GitHub deploy key for <OWNER>/ISSM"
```
replacing `<OWNER>` with the name of the GitHub account that you forked the ISSM source code repository to.
- Do *not* enter a passphrase when prompted.
- On your fork of the ISSM source code repository on GitHub, switch to the 'Settings' tab.
- Click the 'Security and quality' > 'Deploy keys' link in the left sidebar.
- Click the 'Add deploy key' button.
- Supply a descriptive title for the key, copy the contents of the public key you just generated to the 'Key' field, check the 'Allow write access' checkbox, then click the 'Add key' button.

## Clone the ISSM Source Code Repository
- If you will be contributing to ISSM' development, clone your fork of the ISSM repository with,
```sh
GIT_SSH_COMMAND='ssh -i ~/.ssh/github-deploy-key-<OWNER>-ISSM -o IdentitiesOnly=yes' git clone git@github.com:<OWNER>/ISSM.git <PATH_TO_ISSM>
```
replacing `<OWNER>` as before and `<PATH_TO_ISSM>` with the directory on disk that you would like to clone the repository to.
- Otherwise, clone the [ISSM source code repository](https://github.com/ISSMteam/ISSM){:target="_blank"} following the instructions in the `README`.

## External Packages
The following packages and installation scripts are recommended for a basic installation of ISSM on Windows,
```sh
msmpi       install.sh
petsc       install-3.14-win-msys2-ucrt-msmpi.sh
triangle    install-win-msys2-ucrt.sh
```

{: .highlight-title }
> Important
>
> After successfully compiling and installing a package, run,
> ```
> source ${ISSM_DIR}/etc/environment.sh # bash, zsh
> ```
> or,
> ```
> source ${ISSM_DIR}/etc/environment.csh # csh
> ```
> so that the newly-installed package can be found by subsequent packages that may depend on it.

## Configuring and Compiling ISSM
We rely on the Autotools to allow us to configure and compile ISSM on a variety of systems. To begin, run,
```sh
cd ${ISSM_DIR}
autoreconf -ivf
```

Next, create a configuration file called `configure.sh` in `${ISSM_DIR}`. Its contents will depend on the interface you will be using, the external packages and capabilities you wish to use, and the location of certain libraries and executables on disk. The following examples can be used for an installation of ISSM with basic capabilities,
<div class="issm-api-tabs">
<div class="tab" data-api="matlab" markdown="1">
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --with-numthreads=<NUM_CPUS> \
    --with-matlab-dir="${MATLAB_PATH}" \
    --with-mpi-include="${MSMPI_ROOT}/include" \
    --with-mpi-libdir="-Wl,-L${MSMPI_ROOT}/lib" \
    --with-mpi-libflags="-Wl,-lmsmpi" \
    --with-fortran-lib="-Wl,-L/c/msys64/ucrt/lib -Wl,-lgfortran" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install"
```
Recall that `MATLAB_PATH` was defined previously in `.bashrc`.
</div>
<div class="tab" data-api="python" markdown="1">
The Python interface to ISSM on Windows is currently under development.
</div>
</div>

{: .highlight-title }
> Note
>
> - Replace `<NUM_CPUS>` with the number of available CPUs
> - `MSMPI_ROOT` will be defined after running,
> ```sh
> source ${ISSM_DIR}/etc/environment.sh
> ```
> - You may need to update the path to `libgfortran` in the `--with-fortran-lib` option

Again, you might need to make adjustments to the above configuration based on your system and needs. We have a number of resources to help here:
- Various external package install scripts and configurations in `${ISSM_DIR}/jenkins`
- <a href="hpc" target="_top">'High-Performance Computing' page</a>
- <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">GitHub Discussions</a>

If the configuration completed without any errors, ISSM can now be compiled with,
```sh
cd ${ISSM_DIR}
make
make install
```

You are now ready to 
<a href="../using-issm/getting-started" target="_top">get started with ISSM</a>!

## (Optional) Set Up SSHd
**NOTE**: The following is probably not applicable to most users.

- Navigate to <a href="https://www.msys2.org/wiki/Setting-up-SSHd" target="_blank">the MSYS2 'Setting up SSHd' webpage</a>
- Copy the contents of the code block and paste to a new text file
- Set the value of the variable `UNPRIV_NAME` to the desired user
- If the user does not already exist, it will be created
- If the user does already exist, note the default password is the same that is used to log in to the Windows user account
- Save the file out to the location of your choice
- In a MSYS2 UCRT 64-bit shell instance, run the script
- If errors occur with messages about missing packages, install those packages and run the script again
- You can disregard the message,
```sh
cygrunsrv: Error removing a service: OpenService: Win32 error 1060:
The specified service does not exist as an installed service.
```
- The following message indicates that setup was successful, 
```sh
The MSYS2 sshd service is starting.
The MSYS2 sshd service was started successfully.
```
- You can test that the service and your login are working correctly by running, 
```sh
ssh -l <UNPRIV_NAME> localhost
```
where `<UNPRIV_NAME>` is the same user that we authorized to use the service. You should be prompted to accept an ECDSA fingerprint, to which you respond "yes". Then, enter the password for this account. If all goes well, you should now have a prompt that reads, 

```sh
<UNPRIV_NAME>@<HOSTNAME> MSYS ~
```
- Once logged in to the target machine, open `/etc/ssh/sshd_config` for editing, add,
```sh
AcceptEnv MSYSTEM
```
then save out the changes. On the client machine, open `/etc/ssh/ssh_config` for editing, add,
```sh
SendEnv MSYSTEM
```
to the file (you can add `MSYSTEM` to the list of environment variables if `SendEnv` already exists), then save out the changes. You can now prefix your SSH commands like,
```sh
MSYSTEM=MINGW64 ssh [...]
```
in order to log in to the MSYS2 UCRT 64-bit shell (other possible values are MSYS2 and MINGW32).
- If an attempted SSH connection from a remote machine stalls out or is denied, it may be the case that you are running Windows Defender Firewall and need to open port 22. To do so,
- in the Windows search bar, search for "Defender" and select 'Windows Defender Firewall with Advanced Security'
- click 'Inbound Rules' in the left sidebar
- click 'New Rule...' in the right sidebar
- select 'Port', then click the 'Next' button
- select 'TCP'
- select 'Specific local ports', set the field to "22", then click the 'Next' button
- select 'Allow the connection', then click the 'Next' button (if you are using a third-party firewall application, it is up to you to determine how to open port 22)
- uncheck the 'Public' box (if a subsequent attempted connection stalls out or is denied, you may need to edit this rule, checking the 'Public' box, but try first without it), then click the 'Next' button
- set the 'Name' field to "SSH", then click the 'Next' button
- The `ssh-keygen` utility can be used to create a more secure SSH connection and to protect your Windows user password
- If you later decide that you want to stop the `sshd` service, you can do so with, 
```sh
net stop msys2_sshd
```
and can remove the service altogether with, 
```sh
cygrunsrv -R msys2_sshd
```
Sources:
- <a href="https://www.msys2.org/wiki/Setting-up-SSHd" target="_blank">MSYS2 'Setting up SSHd' webpage</a>
- <a href="https://gist.github.com/samhocevar/00eec26d9e9988d080ac" target="_blank">Sam Hocevar's GitHub Gist page on setting up SSHd under MSYS2</a>
