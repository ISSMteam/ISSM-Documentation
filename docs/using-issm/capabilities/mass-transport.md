---
title: Mass Transport
layout: default
parent: Capabilities
math: mathjax3
---

# Mass Transport Solution

## Physical basis
### Conservation of mass
The mass transport equation is derived from the depth-integrated form of the mass conservation equation and reads:

$$
\frac{\partial H}{\partial t} = - \nabla \cdot \left(H \bar{\bf v}\right) + \dot{M}_s - \dot{M}_b
$$
where:

- $$\bar{\bf v}$$ is the depth-averaged velocity vector
- $$H$$ is the ice thickness
- $$\dot{M}_s$$ is the surface accumulation (in m/yr of ice equivalent, positive for accumulation)
- $$\dot{M}_b$$ is the basal melting (in m/yr of ice equivalent, positive for melting)

For full-Stokes models, free surface equations are solved for the upper surface and the base of floating ice:

$$
\frac{\partial s}{\partial t}+ v_x\left(s\right) \dfrac{\partial s}{\partial x}+ v_y\left(s\right) \dfrac{\partial s}{\partial y}- v_z\left(s\right)= \dot{M}_s
$$
and:

$$
\frac{\partial b}{\partial t}+ v_x\left(b\right) \dfrac{\partial b}{\partial x}+ v_y\left(b\right) \dfrac{\partial b}{\partial y}- v_z\left(b\right)= \dot{M}_b
$$
where:

- $$s$$ is the elevation of the ice upper surface
- $$b$$ is the elevation of the floating ice lower surface
- $$\left(v_x\left(s\right),v_y\left(s\right),v_z\left(s\right)\right)$$ are the ice velocity
  components at the upper surface $$s$$
- $$\left(v_x\left(b\right),v_y\left(b\right),v_z\left(b\right)\right)$$ are the ice velocity
  components at the base $$b$$

### Boundary conditions
Ice thickness is imposed at the inflow boundary:

$$
H=H_{obs} \text{ on } \Gamma_{-}
$$

For free surfaces models, both $$b$$ and $$s$$ are constrained at the inflow boundary.

### Numerical implementation
Mass transport is solved using finite elements in space, and implicit finite difference in time. To stabilize the equation, a stabilization term might be added to the left hand side, for example:

$$
\frac{\partial H}{\partial t} + \nabla \cdot \left(H \bar{\bf v}\right)- {\color{red} \nabla \cdot \left(\mathfrak{D} \nabla H\right)}= \dot{M}_s - \dot{M}_b
$$
where $$\mathfrak{D}$$ is the artificial diffusivity. We take:

$$
\mathfrak{D} = \frac{h}{2}\left(\begin{array}{cc}\left|vx\right| & 0 \\\\0 & \left|vy\right|\end{array}\right)
$$

There are other stabilization schemes available in ISSM: (1) Artificial Diffusion, (2) Streamline Upwinding, (3) Discontinuous Galerkin (DG), (4) Flux Corrected Transport (FCT), and (5) Streamline Upwind Petrov-Galerkin (SUPG). They can be used by setting:
````
>> md.masstransport.stabilization = 1;
````

## Model parameters
The parameters relevant to the mass transport solution can be displayed by running:
````
>> md.masstransport
````


- `md.masstransport.spcthickness`: thickness constraints (`NaN` means no constraint)
- `md.masstransport.hydrostatic_adjustment`: adjustment of ice shelves' upper and lower
  surfaces: `'Incremental'` or `'Absolute'`
- `md.masstransport.stabilization`: 0: no stabilization, 1: artificial diffusion, 2: streamline upwinding, 3:
  discontinuous Galerkin, 4: flux corrected transport (FCT), 5: streamline upwind Petrov-Galerkin (SUPG)
- `md.masstransport.penalty_factor`: offset used by penalties

$$
\kappa=10^{\text{penalty\_offset}} \max_{i,j}\left| K_{ij}\right|
$$

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

## Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md,'Masstransport');
````
The first argument is the model, the second is the nature of the simulation one wants to run. This will compute one time step of the mass transport equation; use the 
 <a href="transient">transient solution</a>
for multiple time steps.

