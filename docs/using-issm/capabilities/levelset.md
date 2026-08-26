---
title: Ice Front Migration
layout: default
parent: Capabilities
math: mathjax3
---

## Ice Front Migration (Level Set Method)
### Physical basis
ISSM tracks the position of the calving front implicitly, using a level-set method [<a href="#references">*Bondzio2016*</a>]. The ice front is defined as the zero contour of a level-set function $$\phi$$, with the convention:

- $$\phi<0$$ inside the ice domain
- $$\phi>0$$ outside the ice domain (open ocean/no ice)
- $$\phi=0$$ at the ice front

The ice front is advected by solving the following transport equation for $$\phi$$:

$$
\frac{\partial \phi}{\partial t} + {\bf v_f}\cdot\nabla \phi = 0
$$

where $${\bf v_f}$$ is the frontal migration velocity, obtained by combining the horizontal ice velocity $${\bf v}$$ with the calving rate $$c$$ (see the <a href="../parameterization/calving">Calving</a> page) and the frontal melt rate $$m$$, both acting outward, normal to the front:

$$
{\bf v_f} = {\bf v} - \left(c + m\right)\frac{\nabla \phi}{\left|\nabla \phi\right|}
$$

This equation is solved with a Streamline Upwind Petrov&#8211;Galerkin (SUPG)-stabilized finite element scheme. Because $$\phi$$ can become distorted by the advection (steepening or flattening away from a signed distance function), it is periodically reset to a signed distance function away from the front (reinitialization).

At every time step during which the moving front module is active, ISSM:

1. Computes depth-averaged velocities (for 2D vertical/3D meshes) and smooths the gradient of $$\phi$$ to get a well-defined outward normal at the front
2. Extrapolates velocity, thickness, and temperature/enthalpy fields into the "no ice" region ahead of the front, so that these fields remain well defined as the front advances
3. Computes the calving rate (`md.calving`) and the frontal melt/undercutting rate (`md.frontalforcings`)
4. Computes the frontal migration velocity $${\bf v_f}$$ and solves the level-set advection equation above
5. Optionally removes floating icebergs that have been detached from the main ice body, to avoid spurious rigid-body motion
6. Reinitializes the level-set function to a signed distance function, either after killing icebergs or every `reinit_frequency` time steps
7. Updates the mask of vertices/elements that contain ice for the next time step

### Model parameters
This module is controlled through the `md.levelset` class. The following fields can be displayed by running:
````
>> md.levelset
````


- `md.levelset.stabilization`: stabilization scheme used to solve the level-set advection equation
  - 0: no stabilization (least stable, least diffusive)
  - 1: artificial diffusivity
  - 2: streamline upwinding
  - 5: SUPG (default, most accurate but can be unstable in some applications)
- `md.levelset.spclevelset`: prescribed values of the level-set function (`NaN` where unconstrained), which can be used to fix parts of the ice front in place or force a given calving front position/time series
- `md.levelset.reinit_frequency`: number of time steps between two reinitializations of the level-set function as a signed distance function (default: 10)
- `md.levelset.kill_icebergs`: if 1, detached floating ice (icebergs) is removed from the domain at each time step to prevent unconstrained rigid-body motion (default: 1)
- `md.levelset.migration_max`: maximum allowed migration rate of the ice front [m/a], used to cap unrealistically fast advance or retreat
- `md.levelset.fe`: finite element used to discretize the level-set function, `'P1'` (default) or `'P2'`

### Running a simulation
To turn on ice front migration in a transient simulation, activate the moving front module:
````
>> md.transient.ismovingfront = 1;
````
You must also select a calving law (see the <a href="../parameterization/calving">Calving</a> page) and, if applicable, a frontal melt/undercutting parameterization (`md.frontalforcings`):
````
>> md.calving = calvingvonmises();
>> md.frontalforcings = frontalforcings();
>> md.frontalforcings.meltingrate = zeros(md.mesh.numberofvertices, 1);
````
Finally, run the transient simulation:
````
>> md = solve(md, 'Transient');
````

## References
- J. H. Bondzio, H. Seroussi, M. Morlighem, T. Kleiner, M. Ruckamp, A. Humbert, and E. Y. Larour.
 Modelling calving front dynamics using a level-set method: application to Jakobshavn Isbrae, West Greenland.
 Cryosphere, 10(2):497-510, 2016.
