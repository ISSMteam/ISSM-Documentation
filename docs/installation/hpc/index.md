---
title: High-Performance Computing (HPC)
layout: default
parent: Installation
nav_order: 4
has_children: false
has_toc: false
---

# High-Performance Computing (HPC)
## A Note About HPC Environments
MATLAB and Python are used only for model setup and post-processing of simulation results (e.g. plotting). As such, when leveraging the power of HPC, our general strategy is to install one copy of ISSM with the MATLAB and/or Python wrappers on a local machine, and a second copy of ISSM with only the binaries (e.g. `issm.exe`) on the cluster. We can achieve this second type of build by configuring ISSM with the `--without-wrappers` option. The MATLAB or Python interface can then send the binary input files to the cluster and fetch the output file once the run is completed.

Note as well that the 'local' machine in the above case may be one that is physically remote to you. For example, you might install ISSM with its Python interface so that it is available in a remote Jupyter Lab/Hub environment. This paradigm is becoming increasingly popular with computing centers that provide access to HPC.

## Configuration and Compiling ISSM
Please see the <a href="https://issm.ess.uci.edu/trac/issm/wiki" target="_blank">ISSM Development Wiki</a> for notes on configuring and compiling on various HPC systems.

We will be working soon to migrate the content from the wiki to this documentation.

