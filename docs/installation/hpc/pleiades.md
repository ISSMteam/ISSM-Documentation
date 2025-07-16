---
title: Pleiades (NASA NAS HECC)
layout: default
parent: High-Performance Computing (HPC)
has_children: false
has_toc: false
---

# Pleiades (NASA NAS HECC)
## Getting an Account
New users will have to ask a NASA- or JPL-employed PI to request an account for them on NASA NAS HECC. They will need the group ID of the PI in order to submit this request.

First, the PI should use the following procedure,
- navigate to the <a href="https://www.nas.nasa.gov/hecc/portal/accounts" target="_blank">NASA NAS HECC 'Account Request System' page</a>
- select option '3. I want to request a NASA identity for one of my new users'
- provide the requested information

Then, the user needs to request an account with the following procedure,
- navigate to the <a href="https://www.nas.nasa.gov/hecc/portal/accounts" target="_blank">NASA NAS HECC 'Account Request System' page</a>
- select option '2. I want to request and account for myself'
- provide the group ID for the PI that initiated the request
- the PI will then receive an email to approve the request

NOTE: All users must complete NASA's Basic IT Security Training

### Current Points of Contact
- Dartmouth security officer: <a href="mailto:Sean.R.McNamara@dartmouth.edu">Sean McNamara</a> (<a href="https://itc.dartmouth.edu/about/who-we-are/itc-leadership" target="_blank">Dartmouth ITC</a>)
- JPL IT security officer: <a href="mailto:Tomas.J.Soderstrom@jpl.nasa.gov">Tomas Soderstrom</a>
- UCI OIT security officer: <a href="mailto:jdrummon@uci.edu">Josh Drummond</a>

## Logging In
Please refer to the following documentation pages to log into NAS systems and make subsequent logins more seamless,
- <a href="https://www.nas.nasa.gov/hecc/support/kb/logging-into-nas-systems-for-the-first-time_539.html" target="_blank">Logging Into NAS Systems for the First Time</a>
- <a href="https://www.nas.nasa.gov/hecc/support/kb/setting-up-public-key-authentication_230.html" target="_blank">Setting Up Public Key Authentication</a>
- <a href="https://www.nas.nasa.gov/hecc/support/kb/setting-up-ssh-passthrough_232.html" target="_blank">Setting Up SSH Passthrough</a>
- <a href="https://www.nas.nasa.gov/hecc/support/kb/one-step-connection-using-public-key-and-passthrough_62.html" target="_blank">One-Step Connection Using Public Key and Passthrough</a>

## Checking Out a Copy of the ISSM Code Repository
Users should clone the ISSM code repository to their `/nobackup/` directory where they can save a lot more files than in their home directory.

## Environment
Add the following to `~/.bashrc` in order to set up the environment properly for compiling ISSM,
```sh
# Modules
module load mpi-hpe/mpt
module load comp-intel/2020.4.304
module load petsc/3.17.3_intel_mpt_py

# Variables
export CC=mpicc
export CXX=mpicxx
export F77=mpif77
export MPICC_CC=icx
export MPICXX_CXX=icpx
export MPF90_F90=ifort

export ISSM_DIR="<ISSM_DIR>"
```
replacing `<ISSM_DIR>` with the path to the local copy of the ISSM code repository. Run `source ~/.bashrc` to apply these changes to the current session.

{: .highlight-title }
> NOTE
>
> If `~/.bashrc` is not loaded when on login, add a new file, `~/.bash_login`, with the following content,
> ```sh
> if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
> ```

{: .highlight-title }
> NOTE
>
> The version of the `comp-intel` module as well as the corresponding value of variable `COMP_INTEL_ROOT` may need to be updated as recommended/available modules are updated on HECC. Please update this page or ask a project lead to do so when this occurs.

