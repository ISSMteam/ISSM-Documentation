---
title: Running MATLAB on Pleiades (mcc)
layout: default
parent: Wiki
nav_order: 10
---

# Running MATLAB Scripts on Pleiades with `mcc`
Pleiades has only about 15 MATLAB licenses available on the cluster, and it does not allow MATLAB to run in batch jobs submitted through `qsub`. The alternative is to compile your MATLAB functions for deployment with <a href="https://www.mathworks.com/help/compiler/mcc.html" target="_blank">`mcc`</a>. First, precompile your MATLAB code into an executable, then submit that executable as a Pleiades job.

## Precompiling Your MATLAB Code
The following MATLAB script (`createMCC.m`) creates an executable from a MATLAB script. The executable can then be submitted to Pleiades.
```matlab
%file to be turned into an executable
filename = 'XXX.m'

%Get dependencies
files = matlab.codetools.requiredFilesAndProducts(filename);

%Create long string
deps = [];
for i=1:numel(files)
	if contains(files{i},'normfit_issm.m')
		continue
	elseif contains(files{i},'dakota_moments.m')
		continue
	elseif contains(files{i},'dakota_out_parse.m')
		continue
	else
		deps = [deps ' ' files{i}];
	end
end

%Create command
command = ['mcc -m ' filename deps ' -o MCCexecutable']

%Create executable
system(command);
```
Running this script in MATLAB generates two files: `run_MCCexecutable.sh` and `MCCexecutable`.

Potential problems:
- `mcc` must account for every `*.m` file used while your script runs. It cannot handle a new `*.m` file created on the fly, as `parameterize` does.
- It helps to remove dependencies that require special MATLAB licenses, because Pleiades has only a limited number. For instance, you can drop `normfit_issm.m`, `dakota_moments.m` and `dakota_out_parse.m` from the dependency list (as in the script above) if your code does not use them; the statistical toolbox license is then not required. Make sure the paths to these files match the correct ones on your machine.

## Submitting the Job
Change the paths/group ID/modules in the file below to match your configuration.
```bash
#PBS -S /bin/bash
#PBS -l select=1:ncpus=28:model=bro
#PBS -l walltime=100
#PBS -q devel
#PBS -W group_list=s1690
#PBS -m e
#PBS -o /home1/mmorligh/ISSM/test/NightlyRun/run.outlog
#PBS -e /home1/mmorligh/ISSM/test/NightlyRun/run.errlog

. /usr/share/modules/init/bash

#load modules
module load comp-intel/2018.3.222
module load mpi-hpe/mpt.2.17r13
module load matlab/2017b
module load netcdf/4.4.1.1_mpt

#Export some variables
export PATH="$PATH:."
export MPI_LAUNCH_TIMEOUT=520
export MPI_GROUP_MAX=64

#ISSM stuff
export ISSM_DIR="/u/mmorligh/issm/ISSM/"
source $ISSM_DIR/etc/environment.sh

#move and start simulation
cd /home1/mmorligh/ISSM/test/NightlyRun

#Run the precompiled code
./run_MCCexecutable.sh $ISSM_DIR/lib:$ISSM_DIR/externalpackages/gsl/install/lib:$ISSM_DIR/externalpackages/petsc/install/lib:/nasa/intel/Compiler/2016.2.181/mkl/lib/intel64/:/nasa/intel/Compiler/2016.2.181/compilers_and_libraries_2016.2.181/linux/compiler/lib/intel64/:/nasa/sgi/mpt/2.15r20/lib:/nasa/netcdf/4.4.1.1_mpt/lib:/nasa/matlab/2017b
```

Potential problems:
- If you get undefined symbols, you may need to add a path to the `./run_MCCexecutable.sh` command.
- If you get an error that the path to your ISSM is wrong once the code is deployed, you may have to hardcode the path into `src/m/os/issmdir.m`. Calls to `addpath` in your code can also cause this; remove them before compiling.
