---
title: PACE
layout: default
parent: Other HPCs
machine_name: "PACE"
has_toc: false
---

# {{ page.machine_name }} (Georgia Tech)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
[Apply for a PACE account](https://pace.gatech.edu/participation/){:target="_blank"}. However, it is typically easier to just email Alex, since he will have to email PACE Support to get you the correct permissions for the steps below.

## Installing ISSM on {{ page.machine_name }}
ISSM has been built on the PACE cluster at CODA as a module. This means that it is already "installed" and can be used by any PACE user without needing to configure anything (except what is needed for the specific simulation). A user with privileges in the `eas-robel` group can use the following instructions.

To run ISSM from the standard install on PACE requires a batch script, the MATLAB ISSM run script, and any input files that ISSM requires.

In the Ice & Climate group shared directory, there is a test script including the correct input files and batch file that can be copied (PLEASE DON'T MODIFY THIS IN THE SHARED DIRECTORY) to your personal directory and run to learn how ISSM is run.
1. Copy these files to your home directory with,
```sh
cd ~
mkdir ISSM
cd ISSM
cp /storage/coda1/p-arobel3/0/shared/ISSM/ISSMintro/* .
```
2. Run the test script on PACE with,
```sh
qsub batch_issm.pbs 
```
3. You can check the status of the run with,
```sh
qstat -u YOURPACEUSERNAME
```
4. An output text file should be created in the same directory as the batch file. You can have a quick look at the status of the run (which ISSM should output) using `vi` or `less`.
5. For other non-test ISSM runs, the batch script should generally look like:
```sh
#PBS -N JOBNAME
#PBS -A GT-arobel3-atlas
#PBS -o output.$PBS_JOBID
#PBS -j oe
#PBS -l nodes=NNODES:ppn=NPROC
#PBS -l walltime=DAYS:HOURS:MINS:00

cd $PBS_O_WORKDIR
module purge
module load intel/19.0.3
module load issm/4.16
source $ISSMROOT/etc/environment.sh

matlab -nodesktop -nosplash -r "NAMEOFSCRIPT; exit"
```

In this script, the only things that should be changed are lines 1, 5, 6, 14:
- (Line 1) JOBNAME is just the name of the job you pick (whatever you like) in the scheduler system.
- (Line 5) NNODES indicates the number of nodes and NPROC indicates the number of processors on each node to use. For very simple jobs, both can be 1. For more intensive jobs NNODES=1 and NPROC can be up to 28 (on the typical node architecture of phoenix). For very computationally intensive jobs, you can use more than one node, but talk to Alex first.
- (Line 6) The maximum time to allocate for the job is specified here in units of DAYS:HOURS:MINS:00. The phoenix cluster has a maximum walltime of 21 days.[[BR]]
- (Line 14) NAMEOFSCRIPT is the file name of the MATLAB script that you are using to run ISSM.

[More details on how to specify jobs on the PACE Phoenix cluster](https://pace.gatech.edu/phoenix-cluster/){:target="_blank"} (requires a GT Account).

## Compiling ISSM from Source on PACE
If the standard module install of ISSM on PACE is not sufficient for your needs (e.g. you need a different version of ISSM, or you need to modify the source code), then ISSM can also be built from source. The following instructions use some of the built in packages within the ISSM source, in addition to some of the existing modules on PACE to build ISSM locally. These instructions are current as of Jan. 13, 2021.

1. First, you must download or provide your own version of the source code in you local directory on PACE. You can do this using SVN run through a batch script, or simply by cloning the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} to your personal machine. In the Ice & Climate group shared directory, there is a build script (`build-with-mvapich.sh`), written by Dr. Fang Liu at PACE (who is the expert on all things related to ISSM builds on PACE) which can be used to build ISSM locally. Navigate into the location that you cloned the ISSM source code repository to, then copy this build script from the shared directory with,
```sh
cp /storage/coda1/p-arobel3/0/shared/ISSM/ISSMsrc/build-with-mvapich.sh .
```
2. The build script is organized into "batches". To build the packages and source code in the correct order, simply go through the build script and uncomment one batch at a time and then run the script (using the command ``./build-with-mvapich.sh` after uncommenting each batch individually).
3. Once you've successfully built ISSM, the batch script will look slightly different,
```sh
#PBS -N JOBNAME [[BR]]
#PBS -A GT-arobel3-atlas[[BR]] 
#PBS -o output.$PBS_JOBID[[BR]]
#PBS -j oe[[BR]]
#PBS -l nodes=NNODES:ppn=NPROC[[BR]]
#PBS -l walltime=DAYS:HOURS:MINS:00[[BR]]

ISSMROOT=$PBS_O_WORKDIR
cd $ISSMROOT
module purge
module load matlab
module load intel/19.0.5
module load mvapich2/2.3.2
source $PBS_O_WORKDIR/../../etc/environment.sh

matlab -nodesktop -nosplash -r "NAMEOFSCRIPT; exit"
```
4. If you are modifying source code and have previously built ISSM successfully, you should only need to run batch 6 which simply compiles the source code (and doesn't recompile all the dependencies).

