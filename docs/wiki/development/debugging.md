---
title: Debugging
layout: default
parent: Development
nav_order: 3
---

# Debugging
## How to Debug a Crash in issm.exe?
If there is a crash during the solve phase, we strongly suggest using [Valgrind](http://valgrind.org){:target="_blank"}. Install Valgrind using one of the scripts in the directory `${ISSM_DIR}/externalpackages/valgrind`. Valgrind will subsequently be embedded in ISSM and can detect segmentation faults as well as memory leaks. To do so, set the model debugging field to 1 and use only one CPU,
```matlab
md.debug.valgrind = 1;
md.cluster.np = 1;
```
in your script, or, simply set,
```matlab
valgrind = true;
```
in `src/m/classes/debug.m` to run Valgrind on all subsequently-run scripts.
Launch the solution sequence and read the `errlog` file that it outputs.

### When a Build Includes Boost
If your build includes the Boost C++ libraries, there are additional configuration steps needed to overcome a conflict when running Valgrind. Either:
1. install Valgrind with `externalpackages/valgrind/install-<OS>.sh`
2. set `#define BOOST_MATH_PROMOTE_DOUBLE_POLICY false` in  `externalpackages/valgrind/src/boost/math/tools/user.hpp` before running `bootstrap.sh` and `b2 install`
3. if you are using Dakota, this will need to be reinstalled as well

## Interfaces
### How to Debug a MATLAB Crash?
If there is a crash that is not in `issm.exe` (sometimes shown by PETSc's error manager), one should also use Valgrind. Use the following command,
```sh
matlab -nojvm -nosplash -r "your matlab commands" -D"valgrind --error-limit=no --tool=memcheck -v --log-file=valgrind.log"
```

Valgrind's output file `valgrind.log` should help (look for Invalid read and Invalid write).

### How to Debug a Python Crash?
If there is a crash that is not in `issm.exe` (sometimes shown by PETSc's error manager), one should also use Valgrind. Use the following command,
```sh
valgrind  --error-limit=no --tool=memcheck -v --log-file=valgrind.log python -E -tt ./yourpythonscript.py
```

Valgrind's output file `valgrind.log` should help (look for Invalid read and Invalid write).

**NOTE**: if line numbers are not displayed for Mac users, add the following option `--dsymutil=yes`.

## Regression Tests
### Debugging Configurations
When debugging a given Jenkins build, one way to eliminate variables is by feeding its corresponding configuration file into the Jenkins driver script on a local machine,
```sh
cd $ISSM_DIR
./jenkins/jenkins.sh ./jenkins/<configuration_file>
```

As a bonus, you do not have to remember to run `source $ISSM_DIR/etc/environment.sh` after each external package installation. However, you might find yourself frequently removing more than one external package in the process of finding a combination that works well together. You can do so manually each time, but this can take time and you may miss one or more. Instead, run,
```sh
for i in {<PKG_1>,<PKG_2>,...,<PKG_N>}; do rm -rf $ISSM_DIR/externalpackages/$i/install; done
```
where `<PKG_N>` is the name of an external package that you wish to remove.

### Debugging Binary Files
Sometimes you may observe results from ISSM that exceed a given tolerance, differ depending on operating system and/or configuration, or seem to be incorrect altogether. It may be helpful in such cases to use a script designed for marshaling human-readable model settings from binary ISSM input files.

#### Running Tests
Individual regression tests (designed for our Jenkins testing suite, but available to all users through the source code repository) and the drivers for them are located at `test/NightlyRun`. With this as the working directory, tests can be run from within MATLAB with,
```matlab
runme('id',<N>)
```

Python tests can be run from a Unixy command line by setting first setting the environment with,
```sh
export PYTHONPATH="${ISSM_DIR}/src/m/dev"
export PYTHONSTARTUP="${PYTHONPATH}/devpath.py"
export PYTHONUNBUFFERED=1
```
then calling the Python test driver with options,
```sh
./runme.py -i <N>
```

Various input and output files are generated for such runs, and are located in `execution/test<N>-<DATE>-<TIME>-<PID>/`.

**NOTE**: It may be difficult to sort out which subdirectory of `execution/` corresponds to a given test run. As such, if you are doing multiple runs of the same test with the intention of comparing the results, it is recommended that you make note of the name of the new subdirectory.

#### Marshalling Binary Input Files
Now that we have run one or more tests, we can inspect contents of the binary input file by running,
```sh
$ISSM_DIR/scripts/BinRead.py -f <bin_file> [-o <output_file>]
```

If we wish to compare the input files for, say, MATLAB versus Python runs of the same test, we can redirect the output of `BinRead.py` to a text file, then run,
```sh
diff <output_file> <output_file>
```

#### Comparing Queue Scripts
It is worth noting here that it might also be helpful to compare the queue scripts for MATLAB vs Python runs of the same test, with,
```sh
diff execution/test-<MATLAB_TEST>/test<N>.queue execution/test-<PYTHON_TEST>/test<N>.queue
```

### Dakota
#### Testing Installation (NEEDS TO BE UPDATED)
A number of built-in tests can be run to validate the functionality of your Dakota installation,
```sh
cd <DAKOTA_ROOT>/share/dakota/test
./dakota_test.perl [options] [filename(s)] [test_number]
```
where `<DAKOTA_ROOT>` is the path to the directory Dakota is installed to.

Note that extended options for the above test script are not well-documented by Sandia. Said options can be exposed by running,
```sh
./dakota_test.perl --help
```

In particular, it is useful to run,
```sh
./dakota_test.perl --parallel
```
to validate that MPI has been properly linked to the Dakota binaries.

#### Sources
- [Running Dakota Tests](https://snl-dakota.github.io/docs/6.24.0/users/compiling/test.html){:target="_blank"}
