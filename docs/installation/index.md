---
title: Installation
layout: default
nav_order: 3
has_children: true
---

<h1>Installation</h1>
Most users should navigate to the page corresponding to their operating system and choose to either download and install a precompiled distributable or follow the instructions for configuring, compiling, and installing ISSM from source.

Known configurations and other notes for compiling and installing and running ISSM on a number of 
<a href="hpc" target="_top">'High-Performance Computing (HPC)'</a>
systems are available and updated as new configurations are discovered.

Configuring and compiling ISSM with extended capabilities (e.g. solid-earth, automatic differentiation) or for development is covered in the
<a href="advanced" target="_top">'Advanced Features' page</a>.

{: .highlight-title }
> A Note About Anaconda
>
> Anaconda environments can cause all sorts of toolchain conflicts at configuration and compile time that are hard to diagnose. If you use Anaconda and are having issues compiling the external packages, you might try disabling your Anaconda environment with,
> ````
> conda deactivate [<ENV_NAME>]
> ````
> If disabling your Anaconda environment resolves configuration/compilation issues, you might consider disabling it by default in your shell profile (after the `conda initialize` block).
>
> This and other compile time and runtime issues are covered on the <a href="../troubleshooting" target="_top">'Troubleshooting' pages</a>.

## Python Interface
There are currently two interfaces to ISSM: MATLAB (preferred) or Python (not fully supported). To run ISSM with a Python interface, you will need to install a few packages. The current best practice for achieving this is to do so through a virtual environment. Please see the page corresponding to your operating system for further instructions.

- <a href="linux#python-interface" target="_top">Linux</a>
- <a href="macos#python-interface" target="_top">macOS</a>
- <a href="windows#python-interface" target="_top">Windows</a>

## External Packages
Compiling ISSM requires a few external packages. Some of these may be installed via package manager, but we also provide installation scripts which include known, valid configurations for a variety of external packages on all major operating systems and architectures. These scripts are located in `${ISSM_DIR}/externalpackages/`.

There is no guarantee that compilation of a given external package will work on all systems. Some tweaking of the installation script may be necessary, especially the configuration. Some known gotchas are covered 
on the <a href="../troubleshooting" target="_top">'Troubleshooting' pages</a>.
Feel free as well to search or post troubleshooting questions and issues to the <a href="https://issm.ess.uci.edu/forum/" target="_blank">ISSM Forum</a>, or ISSM GitHub repository <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a> or <a href="https://github.com/ISSMteam/ISSM/issues" target="_blank">Issues</a>.

