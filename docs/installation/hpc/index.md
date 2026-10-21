---
title: HPC
layout: default
parent: Installation
nav_order: 4
has_toc: false
---

# High-Performance Computing (HPC)

## A Note About HPC Environments
MATLAB and Python are used only for model setup and post-processing of simulation results (e.g. plotting). As such, when leveraging the power of HPC, our general strategy is to install one copy of ISSM with the MATLAB and/or Python wrappers on a local machine, and a second copy of ISSM with only the binaries (e.g. `issm.exe`) on the cluster. We can achieve this second type of build by configuring ISSM with the `--without-wrappers` option. The MATLAB or Python interface can then send the binary input files to the cluster and fetch the output file once the run is completed.

Note as well that the 'local' machine in the above case may be one that is physically remote to you. For example, you might install ISSM with its Python interface so that it is available in a remote Jupyter Lab/Hub environment. This paradigm is becoming increasingly popular with computing centers that provide access to HPC environments.

## Configuring and Compiling ISSM

### Dartmouth College
- [Dartmouth' Andes](./dartmouth/andes)
- [Dartmouth' Babylon/Amundsen](./dartmouth/babylon)
- [Dartmouth' Discovery](./dartmouth/discovery)
- [Dartmouth' Epica](./dartmouth/epica)
- [Dartmouth' Totten](./dartmouth/totten)

### NASA
- [NCCS' Discover](./nasa/discover)
- [NAS HECC' Pleiades](./nasa/pleiades)

### Texas Advanced Computing Center (TACC)
- [TACC's Frontera](./tacc/frontera)
- [TACC's Lonestar](./tacc/lonestar)

### Norway' Sigma2
- [Sigma2' Fram](./sigma2/fram) (decommissioned)
- [Sigma2' Hexagon](./sigma2/hexagon) (decommissioned)
- [Sigma2' Stallo](./sigma2/stallo) (decommissioned)
- [Sigma2' Vilje](./sigma2/vilje) (decommissioned)

### University of California Irvine (UCI)
- [UCI' GreenPlanet](./uci/greenplanet)
- [UCI' HPC3](./uci/hpc3)
- [UCI' Ronne](./uci/ronne)

### Other HPCs
- [Penn State' ACI](./other/aci)
- [University of Cambridge' HPC](./other/cambridge)
- [Digital Research Alliance of Canada' HPCs](./other/ccdb)
- [Texas A&M International University' CEES](./other/cees)
- [New Zealand eScience Infrastructure' Māui](./other/maui) (decommissioned)
- [Georgia Tech' PACE](./other/pace)
- [National Computational Infrastructure of Australia' Raijin](./other/raijin) (decommissioned)
- [Stanford' Sherlock](./other/sherlock)
- [Tongji University' HPC](./other/tongji)
- [Massachusetts Green High Performance Computing Center' Unity](./other/unity)
