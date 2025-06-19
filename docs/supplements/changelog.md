---
title: Changelog
layout: default
parent: Supplements
has_children: false
has_toc: false
---

# Changelog
## ISSM 4.23 (Release 2023-11-15)
### New features/enhancements

- Added support for more controls (Automatic Differentiation)
- SHAKTI now works also with 3D meshes
- Added interpolation routines for common datasets in `src/m/modeldata`
- GlaDS: added turbulent/laminar flag
### External packages

- Better partial support for Mac with Apple Silicon chips
- Added support for PETSc 3.19

## ISSM 4.22 (Release 2022-10-27)
### New features/enhancements

- Added adaptive time stepping support for GlaDS
- Added Debris modeling for mountain glaciers (still under development)
- Added autoregressive moving average statistical models for generation of SMB, thermal forcing, and floating ice melt rates
- Ability to couple thermal forcing between frontal forcings and Beckmann-Goosse floating ice melt rates

## ISSM 4.21 (Release 2022-08-26)
### New features/enhancements

- Glacier Energy and Mass Balance (GEMB v1.0): A model of firn processes for cryosphere research
Technical release, no other major change.

## ISSM 4.20 (Release 2022-06-01)
### New features/enhancements

- Improved detection of icebergs
- Added new stabilization methods for the level set equation
- Improved implementation of some discrete calving laws
- **NOTE**: `contourlevelzero.m` and `expcontourlevelzero.m` are now merged into `isoline.m`
- Improved usage of `plotmodel` for transient results. For example: `plotmodel(md, 'data', 'Vel', 'steps', 1, 'icefront', '-k', 'groundingline', '-r')`
- AD/CoDiPack now works with checkpointing with multiple cost functions
### External packages

- Added support for PETSc 3.16 and 3.17
- Partial support for Mac with Apple Silicon chips

## ISSM 4.19 (Release 2021-12-23)
### New features/enhancements

- Improved ISSM's performance and scalability
- Python 3 is now default python version
- Started stochastic forcings
- Starting Julia interface
### External packages

- Added support for PETSc 3.15
- Added support for CoDiPack 2.0

## ISSM 4.18 (Release 2020-12-08)
### Important Name change

- **NOTE**: we have simplified `md.mask` to accommodate sea level calculations `md.mask.groundedice_levelset` is now `md.mask.ocean_levelset` so that:
  - `md.mask.ocean_levelset > 0` and `md.mask.ice_levelset > 0` : ice-free land
  - `md.mask.ocean_levelset > 0` and `md.mask.ice_levelset < 0` : grounded ice
  - `md.mask.ocean_levelset < 0` and `md.mask.ice_levelset > 0` : ocean
  - `md.mask.ocean_levelset < 0` and `md.mask.ice_levelset < 0` : floating ice
  Old models are automatically converted to this new convention. Make sure to update your parameter files (you only need to rename `md.mask.groundedice_levelset` to `md.mask.ocean_levelset`, no change of sign required).

- For the Schoof friction law, we now use <img src="https://latex.codecogs.com/svg.latex?C^2" alt="Equation 2"> instead of <img src="https://latex.codecogs.com/svg.latex?C" alt="Equation 1"> so make sure to take the square root of `md.friction.C` if you are loading an old model.
### External packages

- Added support for PETSc 3.12, 3.13 and 3.14. mpich is now installed through PETSc
### Other

- Added checkpointing capability for CoDiPack

## ISSM 4.17 (Release 2020-04-01)
### Other

- Entirely rewrote the management of inputs in the C++ code, which should significantly improve the efficiency of 3D models.
- **NOTE**: You will need to recompile triangle in externalpackages (See <a href="https://issm.ess.uci.edu/forum/d/239-update-to-triangle" target="_blank">ISSM Forum</a> for instructions to update your configuration after updating).

## ISSM 4.16 (Release 2019-11-01)
### New features

- ocean undercutting now has its own class `md.frontalforcings`
- Added support for Python 3
- Added Schoof and Tsai friction law
- Added ISMIP6 sub-shelf melting rates
- Added ice front and grounding line flux as possible output (`'TotalCalvingFluxLevelset'` and `'GroundinglineMassFlux'`)
- Added GlaDS subglacial hydrology solver
### Other

- Significantly improved the scaling of ISSM thanks to feedback from Martin Rueckamp.

## ISSM 4.15 (Release 2018-10-05)
### New features

- Integrated CoDiPack and MeDiPack for automatic differentiation
- Added PDD Scheme from SICOPOLIS

## ISSM 4.14 (Release 2018-08-28)
### New features

- implemented sea level solver
- implemented different melt interpolation at elements crossing the grounding line
- Added PICO and PICOP melt parameterizations
### Other

- `hydrologysommers()` has been renamed `hydrologicalshakti()`
- **NOTE**: we now have to specify the melt and friction parameterization at the grounding line. You should use the defaults:
  - `md.groundingline.melt_interpolation = 'NoMeltOnPartiallyFloating';`
  - `md.groundingline.friction_interpolation = 'SubelementFriction1';`
- **NOTE**: Python users are now responsible for using their own Python package and make sure that SciPy and NumPy are correctly installed. The respective directories in `externalpackages/` will be removed. We have updated the instructions on the installation page.

## ISSM 4.13 (Release 2018-05-10)
### New features

- **NOTE**: material parameters B, D and E are not averaged over the elements anymore, if you have non-uniform fields, your results will be different with this new version of ISSM
- new capability to compute 3-D crustal motions induced by the applied surface loads (`md.esa`)
- new capability to compute sea-level "fingerprint" induced by land hydrological changes (including ice melting) on elastically-compressible, self-gravitating, rotating Earth (`md.slr`)
- new class for adaptive (bounded) time stepping: `timesteppingadaptive`
- new Adaptive mesh refinement capability, not fully supported yet
- Implemented PICO ice shelf melt rate parameterization
### Important bug fix

- Fixed a significant memory leak when `md.transient.output_frequency` is greater than 1
### Other

- class `settings` has been renamed `issmsettings` to avoid shadowing MATLAB's settings function. Make sure to change `md.settings.output_frequency` when you load old models as this field cannot be recovered.
- we removed `md.stressbalance.viscosity_overshoot`, which does not speed up simulations and makes FS crash

## ISSM 4.12 (Release 2017-05-19)
### New features

- Higher order finite elements for thermal models (P1xP2 and P1xP3)
- Adaptive mesh refinement (still under development)
### Other

- Upgraded to mpich 3.2

## ISSM 4.11 (Release 2016-11-04)
### New features

- Added new anisotropic rheology law ESTAR (publication in preparation)
### Important bug fix

- For flowline models, the SSA and HO effective strain rates were not accounting for <img src="https://latex.codecogs.com/svg.latex?\dot{\varepsilon}_{zz}" alt="Equation 3">. This is now fixed.
### Other

- **NOTE**: All Enums have been removed from MATLAB and python. When you want to call `solve`, you now need to replace the Enum by one of the following strings:
  - `'Stressbalance'`      or `'sb'`
  - `'Masstransport'`      or `'mt'`
  - `'Thermal'`            or `'th'`
  - `'Steadystate'`        or `'ss'`
  - `'Transient'`          or `'tr'`
  - `'Balancethickness'`   or `'mc'`
  - `'Balancevelocity'`    or `'bv'`
  - `'BedSlope'`           or `'bsl'`
  - `'SurfaceSlope'`       or `'ssl'`
  - `'Hydrology'`          or `'hy'`
  - `'DamageEvolution'`    or `'da'`
  - `'Gia'`                or `'gia'`
  - `'Sealevelrise'`       or `'slr'`
  For example: `md = solve(md, 'Stressbalance')` is now `md = solve(md, 'Stressbalance')` or simply `md = solve(md, 'sb')`
- upgraded to PETSc 3.7
- No need to install MATLAB anymore in externalpackages. You will potentially need to edit your configuring script (`configure.sh`) and include the path to MATLAB instead of `${ISSM_DIR}/externalpackages/matlab/install`. For example:
  ````
--with-matlab-dir="/Applications/MATLAB_R2015b.app/" \
  ````

## ISSM 4.10 (Release 2016-04-25)
### New features

- Added moving boundary capability based on level set method
- Added support for Dakota 6.2
### Important bug fix

- Time series of constraints for the vertical velocities were not treated correctly for SSA and HO
- 2D SIA has been fixed
### Other

- **NOTE**: `md.surfaceforcings` has been renamed `md.smb`

## ISSM 4.9 (Release 2015-02-12)

- Minor bug fixes and code enhancements
- Replaced `md.mesh.hemisphere` by `md.mesh.epsg` which gives the EPSG code of the projection being used

## ISSM 4.8 (Release 2014-07-30)

- **NOTE**: `md.basalforcings.melting_rate` is now split into:
  - `md.basalforcings.floatingice_melting_rate` that is applied to floating ice only
  - `md.basalforcings.groundedice_melting_rate` that is applied to grounded ice only
- Upgraded to PETSc 3.5
- Added support for MATLAB 2014
- Added analytical validation tests
- Added new surface mass balance parameterization classes
- Minor bug fixes

## ISSM 4.7 (Release: 2014-05-13)
Release for the ISSM workshop:

- Added m1qn3 optimization algorithm
- Minor bug fixes

## ISSM 4.6 (Release: 2014-04-22)
### New features

- Improved Taylor Hood Full-Stokes elements in 3d
- Implemented SSA and HO model in 2d flowband
- Added Cuffey and Paterson relationship between T and B (p75). One can use `cuffey.m` or `md.materials.rheology_law = 'Cuffey'`
- Damage evolution model
### Other

- **NOTE**: `md.geometry.bed` has been renamed `md.geometry.base`
- **NOTE**: `md.geometry.bathymetry` has been renamed `md.geometry.bed`
- **NOTE**: `md.mesh.vertexonbed` has been renamed `md.mesh.vertexonbase`
- the `surfaceforcings` class is now divided into different subclasses depending on the model of surface mass balance needed (`SMB`, `SMBpdd` and `SMBgradients`, more to come)
- the `mesh` class is now divided into different subclasses depending on the type of mesh (2d, 3d prisms, 3d tetras, etc)

## ISSM 4.5 (Release: 2013-10-28)
### New features

- We now have a Full-Stokes flowband model on a fully unstructured mesh (no grounding line dynamics yet)
- Damage evolution model. If you do not want to activate this functionality (default), you will need to add the following fields to the model:
````
md.damage.D = zeros(md.mesh.numberofvertices, 1);
md.damage.spcdamage = NaN * ones(md.mesh.numberofvertices, 1);
````
### Other

- `md.inversion.cost_functions` has now only one line (i.e., the cost function is no longer step dependent)
### Update conflict
You might get the following error message from svn:
````
Summary of conflicts:
  Tree conflicts: 1
  D     C      16566   trunk/src/c/analyses
>   local unversioned, incoming add upon update
````
which can be resolved using the following:
````
cd ${ISSM_DIR}/src/c
svn resolve --accept=working analyses
svn revert --depth=infinity analyses
````

## ISSM 4.4 (Release: 2013-09-16)
### Installation

- configure now checks that the directories provided exist (e.g. `--with-petsc`). Make sure to remove the lines that are not necessary in your configure file.
### New features

- SSA is now available with quadratic finite elements (P2 Lagrange), or with bubble functions (P1+ statically condensed or not)
- HO is now available with quadratic finite elements (P1xP2, P2xP1 and P2xP2 Lagrange), or with bubble functions (P1+ statically condensed or not)
- FS now available with Taylor-Hood finite elements (P2-P1)
### Other

- `setflowequation` now takes as argument `'SIA'`, `'SSA'`, `'HO'` or `'FS'` instead of `'hutter'`, `'macayeal'`, `'pattyn'` and `'stokes'` respectively.
- `diagnostic` is now `stressbalance` and `prognostic` is `masstransport`. Make sure to update model fields and Enums accordingly.
- `md.mask` has been entirely redesigned and now has only two fields:
  - `ice_levelset` (which is positive for the nodes where ice is present), and
  - `groundedice_levelset` (which is positive for grounded ice). Example:
    ````
md.friction.coefficient(find(md.mask.vertexonfloatingice)) = 0.;
    ````
    is now:
    ````
md.friction.coefficient(find(md.mask.groundedice_levelset < 0.)) = 0.;
    ````
- we removed the `startup.m` file. you now need to add the path manually when you start MATLAB or use the following command:
  ````
matlab -r "addpath ${ISSM_DIR}/bin/ ${ISSM_DIR}/lib/"
  ````
- Python users can use
  ````
import sys; sys.path.append('${ISSM_DIR}/bin/'); sys.path.append('${ISSM_DIR}/lib/')
  ````

## ISSM 4.3 (Release: 2013-07-02)
### Installation

- ISSM configuration file: `--with-mpi-lib` is now `--with-mpi-libflags`
- `externalpackages/mpich2` has been renamed `externalpackages/mpich`, you will need to reinstall `mpich` and `petsc` and recompile ISSM.
### New features

- `'googlemaps'` option for `plotmodel`, which overlays onto satellite image from Google.
- New GIA model from Ivins et al.
- Added support for PETSc 3.4 and mpich 3.0
- Sub-element support for grounding line dynamics
### Other

- `mpich2` is now `externalpackages/mpich`
- `md.petsc` is now `md.toolkits`

## ISSM 4.2 (Release: 2012-06-01)
### Installation

- `automake` and `autoconf` are now installed along with `libtool` in one single directory `autotools`. You can remove `externalpackages/autoconf` and `externalpackages/automake` and install `externalpackages/autotools`. You will need to `source ${ISSM_DIR}/etc/environment.sh` after the installation.
- You might need to reinstall `mpich2` and `petsc` so that shared libraries are available to libtool.
### Other

- The MATLAB code has been entirely reorganized
- PETSc 3.3 is now available (we still recommend PETSc 3.2 for now)

## ISSM 4.1 (Release: 2012-04-16)
### Installation

- `ISSM_TIER` was renamed `ISSM_DIR` throughout the code. You will need to update your `.bashrc` and change all `ISSM_TIER` to `ISSM_DIR`
- External packages are now downloaded from the ISSM website when installed. This does not change the current install but makes the download of ISSM much faster, and the svn repository lighter
### New features

- Newton's method available for SSA and HO
- Exact adjoint available for SSA and HO
- Added new Ordinary Kriging module
- Improved Python interface, still under development
### Other

- The serial code has been entirely stripped out. As a consequence, the cluster `none` cannot be used anymore. The installation is faster and the code cleaner.

