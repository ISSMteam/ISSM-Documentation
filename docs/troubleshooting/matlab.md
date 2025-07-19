---
title: MATLAB Interface
layout: default
parent: Troubleshooting
nav_order: 4
---

# MATLAB Interface
## MATLAB does not recognize any ISSM command
````
>> md=model;
??? Undefined function or variable 'model'.
````
This error message shows that ISSM tools have not been loaded by MATLAB. See the 
 <a href="../getting-started/loading-issm">'Loading ISSM' page</a>
for more info.
## MATLAB complains about missing symbols
In some cases, MATLAB complains about missing symbols in MEX files. If your environment is set correctly (for example, you have run `source ${ISSM_DIR}/etc/environment.sh` before starting MATLAB), the error could be due to the fact that MATLAB ships with its own copies of various libraries and manipulates the environment to prefer the location of its own libraries over the locations you have provided. We have experienced this error with the following libraries,

- Boost
- HDF5
- libgfortran
but any library that MATLAB ships with could potentially cause a conflict. There are various options for fixing the above case, but you may want to first run,
````
!ldd <PATH_TO_MEX_FILE>
````
in the MATLAB console to confirm that the cause is as described. After running the command, look through the resulting list of libraries for any that are loaded from the the MATLAB installation directory.

### Option 1 (preferred)
Locate your copy of the conflicting library and provide it to `LD_PRELOAD` before launching MATLAB. For example,
````
LD_PRELOAD="${ISSM_DIR}/externalpackages/petsc/libhdf5.so" matlab
````
or,
````
export LD_PRELOAD="${ISSM_DIR}/externalpackages/petsc/libhdf5.so"
matlab
````

NOTE:

- The full path to the library including its file extension must be provided.
- Multiple libraries can be supplied to `LD_PRELOAD` by separating them by a colon or single space. For example, `LD_PRELOAD="libfoo.so:libbar.so"`.
- Be careful to avoid overwriting previous changes to `LD_PRELOAD`. For example, `LD_PRELOAD="${LD_PRELOAD}:libfoo.dylib"`.

### Option 2
In some cases you may be able to provide the full path to the static copy of the library when configuring ISSM. For example, rather than providing generic link flags for libgfortran,
````
--with-fortran-lib="-L/usr/local/Cellar/gcc@10/10.4.0/lib/gcc/10 -lgfortran"
````
you might instead use,
````
--with-fortran-lib="/usr/local/Cellar/gcc@10/10.4.0/lib/gcc/10/libgfortran.a"
````

If the library in question is installed via external package using one of installation scripts provided by ISSM, you may need to reinstall the package using the appropriate installation script with suffix `-static` in order to have a static copy of the library. No further changes to the ISSM configuration or environment would have to be made in this case, but you would still have to recompile ISSM.

### Option 3 (advanced)
If both dynamic and static versions of the conflicting library are available to you and you do not want to manipulate `LD_PRELOAD` or your ISSM configuration, you can instead modify `${ISSM_DIR}/m4/issm_options.m4`: find the section of this file that handles the library in question and provided the full path to the static copy of the library rather than generic link flags (see Option 2). Then, reconfigure and recompile ISSM.

If this does not fix the problem, please search or post troubleshooting questions and issues to the <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>, or ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a> or <a href="https://github.com/ISSMteam/ISSM/issues" target="_blank">Issues</a>.

## MATLAB complains about missing \_\_gfortran\_transfer\_array\_write symbol
In some cases, MATLAB complains about missing symbols in MEX files. That is due to the fact that MATLAB uses its own libraries that are not the ones you compiled the MEX files with. For example, you might have the following error message:
````
Invalid MEX-file '/Users/rtwalker/ISSM/trunk/lib/TriMesh.mexmaci64':
dlopen(/Users/rtwalker/ISSM/trunk/lib/TriMesh.mexmaci64, 6): Symbol not found:
__gfortran_transfer_array_write
````

This problem has been reported under macOS. There are two ways to fix this problem:

### Option 1 (preferred)

1. Locate where your `gfortran` library is (for example: `/usr/local/gfortran/lib/`).
1. copy MATLAB's `.matlab7rc.sh` in your home directory. For example:
  ````
cp /Applications/MATLAB_R2014b.app/bin/.matlab7rc.sh ~
  ````
1. open `~/.matlab7rc.sh` with your favorite editor, you will see a `case` with different architecture: `glnx86/glnxa64` for Linux, `mac/maci/maci64` for macOS and `*` for other architectures (windows etc). 
1. Go to the case that corresponds to your machine's architecture and uncomment the following line:
  ````
#           LDPATH_PREFIX='$MATLAB/sys/opengl/lib/$ARCH'
  ````
  and change the path to reflect where your `libgfortran.so` is located (step 1). For example:
  ````
LDPATH_PREFIX='/usr/local/gfortran/lib/'
  ````

Restart MATLAB and it should now work.

### Option 2 (requires admin privileges)
The second fix consists of replacing MATLAB's library with the one that are on your system, but you will need to have admin privileges.

We show here the steps for the following MATLAB path: `/Applications/MATLAB_R2013a.app/` and `libgfortran` path: `/usr/local/gfortran/lib/`.

Before changing the libraries, make a backup:
````
cd /Applications/MATLAB_R2013a.app/sys/os/maci64/
mkdir orig
mv libgfortran.* orig
````

Then substitute these libraries by the current ones used by `gfortran` (copy or symlink),
````
ln -s /usr/local/gfortran/lib/libgfortran.dylib .
ln -s /usr/local/gfortran/lib/libgfortran.3.dylib.
````

If this does not fix the problem, please search or post troubleshooting questions and issues to the <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>, or ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a> or <a href="https://github.com/ISSMteam/ISSM/issues" target="_blank">Issues</a>.

## MATLAB complains about GLIBCXX libraries
In some cases, MATLAB complains about its own libraries. That is due to the fact that MATLAB uses its own libraries that might not be the ones you compiled the MEX files with. For example, you might have the following error message:
````
libstdc++.so.6: version 'GLIBCXX_3.4.9' not found
````

### Option 1
You should locate where your `libstdc++.so.6` is, and declare it using `LD_PRELOAD` before you launch MATLAB. For example:
````
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 matlab
````

### Option 2
We found a fix on an <a href="http://ubuntuforums.org/showthread.php?t=808045" target="_blank">Ubuntu forum</a> that we copied here. The idea is to replace MATLAB's library with the one that was used to compile the MEX files, but you will need to have admin privileges.

NOTE: The following uses MATLAB path `/usr/local/matlab80/` and GCC libraries in `/usr/lib` as an example. Modify the paths as needed.

Before changing the libraries, make a backup:
````
cd /usr/local/matlab80/sys/os/glnxa64
mkdir orig
mv libstdc++.so* orig
mv libgcc_s.so* orig
````

Then substitute the last two by the current ones used by `gcc` (copy or symlink):
````
ln -s /usr/lib/libstd* .
ln -s /lib/libgcc_s.so* .
````

## Error using gdaltransform
When making system calls to gdaltransform (or other GDAL binaries), you may run into something like,
````
Error using gdaltransform (line <num>)
gdaltransform: /usr/local/MATLAB/<MATLAB_VER>/bin/glnxa64/libtiff.so.<LIBTIFF_VER>: no version information available
````
Much like the previous issue, this can be solved with,
````
cd /usr/local/MATLAB/<MATLAB_VER>/bin/glnxa64
sudo mkdir bak
sudo mv libtiff.so* bak
sudo ln -s /usr/lib/libtiff.so* .
````
where `<MATLAB_VER>` is your MATLAB version and `<LIBTIFF_VER>` is the major version of `libtiff` identified in the error message.

## Windows: "Binary file <FILE>.outbin not found!"
You may encounter the following warning when running a solution,
````
Binary file <FILE>.outbin not found!

This typically happens when the run crashed.
Please check for error messages above or in the outlog
````
In many cases, this does indeed indicate a runtime error caused by changes made to the source code. However, if you have an unmodified copy of ISSM and you are running one of our Windows configurations, the cause may actually be the equivalent of the previous issue.

**NOTE**: The following is included in our 
 <a href="../installation/windows">Windows installation instructions</a>.

After starting a MSYS2 MinGW 64-bit shell instance, run,
````
find /c/msys64/mingw64/lib/gcc/x86_64-w64-mingw32 -name libstdc++*
````
to find all MSYS2 MinGW copies of `libstdc++*`. Then, run,
````
cd /c/Program\ Files/MATLAB/<MATLAB_VER>/bin/win64
mkdir orig
mv libstdc++<VER> orig
cp /c/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/<GCC_VER>/libstdc++.a .
cp /c/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/<GCC_VER>/libstdc++.dll.a .
````
where `<GCC_VER>` is the GCC version that is installed and `<MATLAB_VER>` is the version of MATLAB that you are running. Restart MATLAB to see if your solution now runs.

If this does not fix the problem, please search or post troubleshooting questions and issues to the <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>, or ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a> or <a href="https://github.com/ISSMteam/ISSM/issues" target="_blank">Issues</a>.

## Windows: MATLAB hangs (no GUI) or crashes with prompt "MATLAB has encountered an internal problem and needs to close." (GUI)
Although MATLAB hangs and crashes can have many causes, this may have to do with the fact that the ISSM build configuration for MEX files needs to be <a href="https://www.mathworks.com/help/matlab/matlab_external/upgrading-mex-files-to-use-64-bit-api.html" target="_blank">updated to use the new 64-bit API</a>.

In the case of a hang (no GUI), use the Windows Task Manager to exit the MATLAB instance.

In the case of a crash while using the MATLAB GUI,

- in the prompt that reads "MATLAB has encountered an internal problem and needs to close.", click the 'Show Report' button
- scroll down to the 'Stack Trace (from fault):' section
- look for a symbol that reads `'mexfile::Inspector::needs_upgrade'` to verify the likely cause of the crash
- click 'Don\'t Send' and exit MATLAB

## MATLAB complains about intel\_fast\_memm symbol
If you compile MEX files with intel compilers, MATLAB might complain about missing symbols. That is due to the fact that MATLAB uses its own `libirc.so` library that are not the ones you compiled the MEX files with. For example, you might have the following error message:
````
Invalid MEX-file '/users/username/test/issm/install/lib/IssmConfig.mexa64':
<ISSM_DIR>/externalpackages/petsc/install/lib/libmetis.so: undefined symbol:
_intel_fast_memmove
````

Here is how you can fix this problem:

1. Locate where your `libirc.so` library is (for example:  `/opt/share/intel/composer_xe_2013_sp1.3.174/compiler/lib/intel64/`).
1. Copy MATLAB's `.matlab7rc.sh` in your home directory. For example:
  ````
cp /nasa/mw/2013b/bin/.matlab7rc.sh ~/ 
  ````
1. open `~/.matlab7rc.sh` with your favorite editor, you will see a `case` with different architecture: `glnx86/glnxa64` for Linux, `mac/maci/maci64` for mac and `*` for other architectures (Windows etc). Go to the case that corresponds to your machine's architecture
1. Uncomment the following line:
  ````
#           LDPATH_PREFIX='$MATLAB/sys/opengl/lib/$ARCH'
  ````
  and change the path to reflect where your `libgfortran.so` is located (step 1). For example:
  ````
LDPATH_PREFIX='/opt/share/intel/composer_xe_2013_sp1.3.174/compiler/lib/intel64/'
  ````

Restart MATLAB and it should now work.

If this does not fix the problem, please search or post troubleshooting questions and issues to the <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>, or ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a> or <a href="https://github.com/ISSMteam/ISSM/issues" target="_blank">Issues</a>.
## Fatal error in MPI\_Init
You may encounter a runtime error that looks something like the following,
````
Fatal error in MPI_Init: Other MPI error, error stack:
MPIR_Init_thread(474)..............:
MPID_Init(190).....................: channel initialization failed
MPIDI_CH3_Init(89).................:
MPID_nem_init(320).................:
MPID_nem_tcp_init(173).............:
MPID_nem_tcp_get_business_card(420):
MPID_nem_tcp_init(379).............: gethostbyname failed, MT-<integers> (errno 1)
loading results from cluster
````
This issue has been observed on more recent versions of MacOS, on both the precompiled and compiled-from-source versions of ISSM.

The fix involves modifying the hosts file, `sudo vi /etc/hosts` and adding a line that reads,
````
127.0.0.1	MT-<integers>
````
where `MT-<integers>` is what is display in the original error message.

After saving the changes to `/etc/hosts` and restarting MATLAB, the issue should be resolved.
## MATLAB crashes unexpectedly
There are many causes that might make MATLAB crash. A possible cause is that PETSc is conflicting with Java (this happens on some Linux machines). The workaround is to use MATLAB in command line by deactivating the GUI,
````
matlab -nojvm
````
## Why can't I see what I am typing in the terminal after I exit MATLAB?
This is a bug of MATLAB when running with `-nojvm` or `-nodesktop` flags under bash. The solution <a href="http://www.mathworks.com/support/solutions/en/data/1-CFTJX8/index.html?product=ML" target="_blank">proposed by MathWorks</a> consists of resetting the terminal after MATLAB exits by running `reset` command in the terminal window,
````
reset
````
## The following message appears when I launch MATLAB
````
Warning: Executing startup failed in matlabrc.
This indicates a potentially serious problem in your MATLAB setup,
which should be resolved as soon as possible.  Error detected was:
MATLAB:m_illegal_reserved_keyword_usage
Error: File: trunk/src/m/classes/qmu/normal_uncertain.m Line: 38
Column: 5
Illegal use of reserved keyword "end".
> In matlabrc at 220
````
This message indicates that your MATLAB version is too old (less than 7.6), and does not support MATLAB's <a href="http://www.mathworks.com/help/matlab/matlab_oop/compatibility-with-previous-versions-.html" target="_blank">new Class-Definition syntax</a>. In this case, please search or post troubleshooting questions and issues to the <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>, or ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a> or <a href="https://github.com/ISSMteam/ISSM/issues" target="_blank">Issues</a>, and we will help you convert all ISSM's MATLAB classes to the older syntax.
## Invalid MEX-file [...] symbol not found in flat namespace `\_\_ZN14ToolkitOptions11toolkittypeE'
If you experience the above error (reportedly happens on macOS), add the following to your ISSM configuration,
````
--with-cxxoptflags="-D_DO_NOT_LOAD_GLOBALS_ -g -O2 -std=c++11"
````
reconfigure, recompile, and relaunch MATLAB.
## macOS: Invalid MEX-file
On running ISSM in MATLAB under macOS, you might receive an error such as,
````
Invalid MEX-file
<ISSM_DIR>/lib/IssmConfig_matlab.mexmaci64':
dlopen(<ISSM_DIR>/lib/IssmConfig_matlab.mexmaci64,
0x0006): Library not loaded: @rpath/libMatlabEngine.dylib
  Referenced from: <1523DDB9-0961-3ACC-AB28-1AC66F6E3204>
  <ISSM_DIR>/lib/IssmConfig_matlab.mexmaci64
````
This can be corrected by running,
````
sudo ln -s /Applications/<MATLAB_VER>.app/extern/bin/maci64/libMatlabEngine.dylib /Applications/<MATLAB_VER>.app/bin/maci64/libMatlabEngine.dylib
````
where `<MATLAB_VER>` is the version of MATLAB running when the error was encountered.

