---
title: Mass Transport Solution
layout: default
parent: Capabilities
---

## Mass Transport Solution

### Physical basis
#### Conservation of mass
The mass transport equation is derived from the depth-integrated form of the mass conservation equation and reads:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial H}{\partial t} = - \nabla \cdot \left(H \bar{\bf v}\right) + \dot{M}_s - \dot{M}_b" alt="Equation 1"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\bar{\bf v}" alt="Equation 2"> is the depth-averaged velocity vector
- <img src="https://latex.codecogs.com/svg.latex?H" alt="Equation 3"> is the ice thickness
- <img src="https://latex.codecogs.com/svg.latex?\dot{M}_s" alt="Equation 4"> is the surface accumulation (in m/yr of ice equivalent, positive for accumulation)
- <img src="https://latex.codecogs.com/svg.latex?\dot{M}_b" alt="Equation 5"> is the basal melting (in m/yr of ice equivalent, positive for melting)

For full-Stokes models, free surface equations are solved for the upper surface and the base of floating ice:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial s}{\partial t}+ v_x\left(s\right) \dfrac{\partial s}{\partial x}+ v_y\left(s\right) \dfrac{\partial s}{\partial y}- v_z\left(s\right)= \dot{M}_s" alt="Equation 6"></div>
and:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial b}{\partial t}+ v_x\left(b\right) \dfrac{\partial b}{\partial x}+ v_y\left(b\right) \dfrac{\partial b}{\partial y}- v_z\left(b\right)= \dot{M}_b" alt="Equation 7"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?s" alt="Equation 8"> is the elevation of the ice upper surface
- <img src="https://latex.codecogs.com/svg.latex?b" alt="Equation 9"> is the elevation of the floating ice lower surface
- <img src="https://latex.codecogs.com/svg.latex?\left(v_x\left(s\right),v_y\left(s\right),v_z\left(s\right)\right)" alt="Equation 10"> are the ice velocity
  components at the upper surface <img src="https://latex.codecogs.com/svg.latex?s" alt="Equation 11">
- <img src="https://latex.codecogs.com/svg.latex?\left(v_x\left(b\right),v_y\left(b\right),v_z\left(b\right)\right)" alt="Equation 12"> are the ice velocity
  components at the base <img src="https://latex.codecogs.com/svg.latex?b" alt="Equation 13">

#### Boundary conditions
Ice thickness is imposed at the inflow boundary:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
H=H_{obs} \text{ on } \Gamma_{-}" alt="Equation 14"></div>

For free surfaces models, both <img src="https://latex.codecogs.com/svg.latex?b" alt="Equation 16"> and <img src="https://latex.codecogs.com/svg.latex?s" alt="Equation 15"> are constrained at the inflow boundary.

#### Numerical implementation
Mass transport is solved using finite elements in space, and implicit finite difference in time. To stabilize the equation, a stabilization term might be added to the left hand side, for example:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial H}{\partial t} + \nabla \cdot \left(H \bar{\bf v}\right)- {\color{red} \nabla \cdot \left(\mathfrak{D} \nabla H\right)}= \dot{M}_s - \dot{M}_b" alt="Equation 17"></div>
where <img src="https://latex.codecogs.com/svg.latex?\mathfrak{D}" alt="Equation 18"> is the artificial diffusivity. We take:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mathfrak{D} = \frac{h}{2}\left(\begin{array}{cc}\left|vx\right| & 0 \\\\0 & \left|vy\right|\end{array}\right)" alt="Equation 19"></div>

There are other stabilization schemes available in ISSM: (1) Artificial Diffusion, (2) Streamline Upwinding, (3) Discontinuous Galerkin (DG), (4) Flux Corrected Transport (FCT), and (5) Streamline Upwind Petrov-Galerlin (SUPG). They can used by setting:
````
>> md.masstransport.stabilization = 1;
````

### Model parameters
The parameters relevant to the mass transport solution can be displayed by running:
````
>> md.masstransport
````


- `md.masstransport.spcthickness`: thickness constraints (`NaN` means no constraint)
- `md.masstransport.hydrostatic_adjustment`: adjustment of ice shelves upper and lower
  surfaces: `'Incremental'` or `'Absolute'`
- `md.masstransport.stabilization`: 0: no stabilization, 1: artificial diffusion, 2: streamline upwinding 3:
  discontinuous Galerkin, 4: flux corrected transport (FCT), 5: streamline upwind Petrov-Galerkin (SUPG)
- `md.masstransport.penalty_factor`: offset used by penalties

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\kappa=10^{\text{penalty\_offset}} \max_{i,j}\left| K_{ij}\right|" alt="Equation 20"></div>

- `md.masstransport.vertex_pairing`: pairs of vertices that are penalized (for periodic
  boundary conditions only)

The solution will also use the following model fields:

- `md.smb.ablation_rate`: surface ablation rate (in meters)
- `md.smb.mass_balance`: surface mass balance (in meters)
- `md.initialization.vx`: x component of velocity
- `md.initialization.vy`: y component of velocity
- `md.basalforcings.groundedice_melting_rate`: basal melting rate applied on grounded ice (positive if melting)
- `md.basalforcings.floatingice_melting_rate`: basal melting rate applied on floating ice (positive if melting)
- `md.smb.mass_balance`: surface mass balance (in meters/year ice equivalent)
- `md.timestepping.time_step`: length of time steps (in years)

### Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md,'Masstransport');
````
The first argument is the model, the second is the nature of the simulation one wants to run. This will compute one time step of the mass transport equation; use the 
 <a href="transient">transient solution</a>
for multiple time steps.

