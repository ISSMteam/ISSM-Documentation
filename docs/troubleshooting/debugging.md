---
title: Debugging
layout: default
parent: Troubleshooting
nav_order: 6
has_children: false
has_toc: false
---

# Debugging
## How to debug a crash in issm.exe?
If there is crash during the solve phase, we strongly suggest using <a href="http://valgrind.org" target="_blank">Valgrind</a>. Install Valgrind using one of the script in the directory `${ISSM_DIR}/externalpackages/valgrind`. Valgrind will subsequently be embedded in ISSM and can detect segmentation faults as well as memory leaks. To do so, set the model debugging field to 1 and use only one CPU,
````
md.debug.valgrind = 1;
md.cluster.np = 1;
````
in your script, or, simply set,
````
valgrind = true;
````
in `src/m/classes/debug.m` to apply run Valgrind on all subsequently-run scripts.
Launch the solution sequence and read the `errlog` file that it outputs.

### When a build includes Boost
If your build includes the Boost C++ libraries, there are additional configuration steps needed to overcome a conflict when running Valgrind. Either,

1. install Valgrind with `externalpackages/valgrind/install-<OS>.sh`
1. set `#define BOOST_MATH_PROMOTE_DOUBLE_POLICY false` in  `externalpackages/valgrind/src/boost/math/tools/user.hpp` before running `bootstrap.sh` and `b2 install`
1. if you are using Dakota, this will need to be reinstalled as well

## Interfaces
### How to debug a MATLAB crash?
If there is a crash that is not in `issm.exe` (sometimes shown as by PETSc's error manager), one should also use Valgrind. Use the following command,
````
matlab -nojvm -nosplash -r "your matlab commands" -D"valgrind --error-limit=no --tool=memcheck -v --log-file=valgrind.log"
````
Valgrind's output file `valgrind.log` should help (look for Invalid read and Invalid write).

### How to debug a Python crash?
If there is a crash that is not in `issm.exe` (sometimes shown as by PETSc's error manager), one should also use Valgrind. Use the following command:
````
valgrind  --error-limit=no --tool=memcheck -v --log-file=valgrind.log python -E -tt ./yourpythonscript.py
````
Valgrind's output file `valgrind.log` should help (look for Invalid read and Invalid write).

**NOTE**: if line numbers are not displayed for Mac users, add the following option `--dsymutil=yes`

