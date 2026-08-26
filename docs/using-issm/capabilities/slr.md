---
title: Sea-level Fingerprints
layout: default
parent: Capabilities
math: mathjax3
---

## Sea-level Fingerprints Solution
### Physical basis
This module solves the so-called "sea-level equation" to compute spatial structure of ocean mass redistribution induced by land hydrological and cryospheric changes. Any redistribution of mass at the Earth's surface perturbs Earth's gravitational and rotational potentials; it also induces the solid Earth deformation. At timescales that are comparable to those of the main tidal constituents, such as the near-annual periods, solid Earth deformation is excellently approximated as an elastic response. This module therefore operates on a self-gravitating, rotating, elastic Earth.

### Relative sea-level
Let $$L(\theta,\phi,t)$$ be a global mass-conserving load function, such that:

$$
L(\theta,\phi,t) = \rho_I H(\theta,\phi,t) \mathcal{I}(\theta,\phi) + \rho_O S(\theta,\phi,t)\mathcal{O}(\theta,\phi)
$$
where $$H$$ is the change in ice thickness on a (global or regional) land ice mask $$\mathcal{I}$$, $$S$$ is the associated change in sea level with ocean mask $$\mathcal{O}$$, $$(\theta,\phi)$$ represent the geographic coordinates, $$t$$ is time, $$\rho_I$$ is the ice density, and $$\rho_O$$ is the ocean water density. (Note: $$H$$ may be the (ice height equivalent of) land hydrological changes within hydrological domain $$\mathcal{I}$$.)

Mass changes in land ice, along with the associated variations in ocean loading, induce perturbations in the Earth's gravitational and rotational potential fields, causing further redistribution of $$S$$, which is both gravitationally and deformationally self-consistent. For an elastically compressible rotating Earth, the gravitationally consistent $$S$$ is given by:

$$
S(\theta,\phi,t) = \frac{R}{M} \left[ \mathcal{G}(\alpha) \otimes L(\theta',\phi',t) \right] +\frac{1}{g} \sum_{m=0}^{2} \sum_{i=1}^{2} \Lambda_{2mi} (t) \mathcal{Y}_{2mi} (\theta,\phi) +\mathcal{E}(t)
$$
where $$\mathcal{G}$$ is a Green's function that models the influence of a specific point load on relative sea-level evaluated at arc distance $$\alpha$$ from the load coordinate position $$(\theta',\phi')$$, $$\Lambda_{2mi}$$ are related to perturbations in rotational potential and associated solid Earth deformation induced by the applied loading, $$\mathcal{Y}_{2mi}$$ are analytic (degree-2, order-$$m$$ spherical harmonic) functions ($$i$$'s represent the cosine and sine terms), and $$\mathcal{E}$$ is a spatial invariant required to conserve the mass. Parameters $$R$$, $$M$$, and $$g$$ represent Earth's global mean radius, mass, and gravitational acceleration, respectively. The operator $$\otimes$$ implies the spatial convolution on the surface of Earth.

### Numerical implementation
Solving the second equation above for $$S$$ requires a priori knowledge of $$S$$ itself (see the first equation above), and we therefore solve the system of equations iteratively, as in the original study of Farrell and Clark (1972). All of our calculations were based on a novel mesh-based approach [<a href="#references">*Adhikari2016*</a>], which, unlike contemporary pseudo-spectral methods, remained numerically accurate and computationally efficient as the resolution requirements approached those of contemporary ice sheets or ocean models (on the order of a few kilometers). For more details on this approach, including validation against other existing methods relying on spherical harmonics, we refer the reader to [<a href="#references">*Adhikari2016*</a>].

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
- S. Adhikari, E. R. Ivins, and E. Larour.
 ISSM-SESAW v1.0: mesh-based computation of gravitationally
   consistent sea-level and geodetic signatures caused by cryosphere and climate
   driven mass change.
 Geosci. Model Dev., 9(3):1087-1109, 2016.
