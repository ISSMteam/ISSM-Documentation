---
title: Sea-level Fingerprints Solution
layout: default
parent: Capabilities
has_children: false
has_toc: false
---

## Sea-level Fingerprints Solution
### Physical basis
This module solves the so-called "sea-level equation" to compute spatial structure of ocean mass redistribution induced by land hydrological and cryospheric changes. Any redistribution of mass at the Earth's surface perturbs Earth's gravitational and rotational potentials; it also induces the solid Earth deformation. At timescales that are comparable to those of the main tidal constituents, such as the near-annual periods, solid Earth deformation is excellently approximated as an elastic response. This module therefore operates on a self gravitating, rotating, elastic Earth.

### Relative sea-level
Let <img src="https://latex.codecogs.com/svg.latex?L(\theta,\phi,t)" alt="Equation 1"> be a global mass-conserving load function, such that:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
L(\theta,\phi,t) = \rho_I H(\theta,\phi,t) \mathcal{I}(\theta,\phi) + \rho_O S(\theta,\phi,t)\mathcal{O}(\theta,\phi)" alt="Equation 2"></div>
where <img src="https://latex.codecogs.com/svg.latex?H" alt="Equation 12"> is the change in ice thickness on a (global or regional) land ice mask <img src="https://latex.codecogs.com/svg.latex?\mathcal{I}" alt="Equation 11">, <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 10"> is the associated change in sea level with ocean mask <img src="https://latex.codecogs.com/svg.latex?\mathcal{O}" alt="Equation 9">, <img src="https://latex.codecogs.com/svg.latex?(\theta,\phi)" alt="Equation 8"> represent the geographic coordinates, <img src="https://latex.codecogs.com/svg.latex?t" alt="Equation 7"> is time, <img src="https://latex.codecogs.com/svg.latex?\rho_I" alt="Equation 6"> is the ice density, and <img src="https://latex.codecogs.com/svg.latex?\rho_O" alt="Equation 5"> is the ocean water density. (Note: <img src="https://latex.codecogs.com/svg.latex?H" alt="Equation 4"> may be the (ice height equivalent of) land hydrological changes within hydrological domain <img src="https://latex.codecogs.com/svg.latex?\mathcal{I}" alt="Equation 3">.)

Mass changes in land ice, along with the associated variations in ocean loading, induce perturbations in the Earth’s gravitational and rotational potential fields, causing further redistribution of <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 14">, which is both gravitationally and deformationally self-consistent. For an elastically compressible rotating Earth, the gravitationally consistent <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 13"> is given by:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
S(\theta,\phi,t) = \frac{R}{M} \left[ \mathcal{G}(\alpha) \otimes L(\theta',\phi',t) \right] +\frac{1}{g} \sum_{m=0}^{2} \sum_{i=1}^{2} \Lambda_{2mi} (t) \mathcal{Y}_{2mi} (\theta,\phi) +\mathcal{E}(t)" alt="Equation 15"></div>
where <img src="https://latex.codecogs.com/svg.latex?\mathcal{G}" alt="Equation 27"> is a Green’s function that models the influence of a specific point load on relative sea-level evaluated at arc distance <img src="https://latex.codecogs.com/svg.latex?\alpha" alt="Equation 26"> from the load coordinate position <img src="https://latex.codecogs.com/svg.latex?(\theta',\phi')" alt="Equation 25">, <img src="https://latex.codecogs.com/svg.latex?\Lambda_{2mi}" alt="Equation 24"> are related to perturbations in rotational potential and associated solid Earth deformation induced by the applied loading, <img src="https://latex.codecogs.com/svg.latex?\mathcal{Y}_{2mi}" alt="Equation 23"> are analytic (degree-2, order-<img src="https://latex.codecogs.com/svg.latex?m" alt="Equation 22"> spherical harmonic) functions (<img src="https://latex.codecogs.com/svg.latex?i" alt="Equation 21">’s represent the cosine and sine terms), and <img src="https://latex.codecogs.com/svg.latex?\mathcal{E}" alt="Equation 20"> is a spatial invariant required to conserve the mass. Parameters <img src="https://latex.codecogs.com/svg.latex?R" alt="Equation 19">, <img src="https://latex.codecogs.com/svg.latex?M" alt="Equation 18">, and <img src="https://latex.codecogs.com/svg.latex?g" alt="Equation 17"> represent Earth’s global mean radius, mass, and gravitational acceleration, respectively. The operator <img src="https://latex.codecogs.com/svg.latex?\otimes" alt="Equation 16"> implies the spatial convolution on the surface of Earth.

### Numerical implementation
Solving the second equation above for <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 29"> requires a priori knowledge of <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 28"> itself (see the first equation above), and we therefore solve the system of equations iteratively, as in the original study of Farrell and Clark (1972). All of our calculations were based on a novel mesh-based approach [<a href="#references">*Adhikari2016*</a>], which, unlike contemporary pseudo-spectral methods, remained numerically accurate and computationally efficient as the resolution requirements approached those of contemporary ice sheets or ocean models (on the order of a few kilometers). For more details on this approach, including validation against other existing methods relying on spherical harmonics, we refer the reader to [<a href="#references">*Adhikari2016*</a>].

### Model parameters
The parameters relevant to the sea-level fingerprints (SLR) solution can be displayed by running:
````
>> md.slr
````


- `md.slr.deltathickness`: thickness change: ice height equivalent [m]
- `md.slr.sealevel`: current sea level (prior to computation) [m]
- `md.slr.reltol`: sea level rise relative convergence criterion
- `md.slr.maxiter`: maximum number of nonlinear iterations
- `md.slr.love_h`: load Love number for radial (vertical) displacement
- `md.slr.love_l`: load Love number for horizontal displacement
- `md.slr.love_k`: load Love number for gravitational potential perturbation
- `md.slr.rigid`: flag for rigid earth gravitational potential perturbation
- `md.slr.elastic`: flag for elastic earth gravitational potential perturbation
- `md.slr.rotation`: flag for earth rotational potential perturbation
- `md.slr.ocean_area_scaling`: correction for model representation of ocean area [default: No correction]
- `md.slr.steric_rate`: rate of steric ocean expansion [in mm/yr]

### Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Slr');
````
The first argument is the model, the second is the nature of the simulation one wants to run.


## References
