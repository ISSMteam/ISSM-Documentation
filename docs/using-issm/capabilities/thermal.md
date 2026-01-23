---
title: Thermal Solution
layout: default
parent: Capabilities
math: mathjax3
---

## Thermal Solution
### Physical basis
#### Thermal state
The heat transport equation is derived from the balance equation of internal energy <img src="https://latex.codecogs.com/svg.latex?E" alt="Equation 1"> combined with Fourier's law of heat transfer and reads:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\rho \left(\frac{\partial E}{\partial t} + {\bf v} \cdot \nabla E \right)= - \nabla \left(\kappa(E) \nabla E \right) + \mbox{Tr} \left( \boldsymbol{\sigma} \cdot \dot{\boldsymbol{\varepsilon}}\right)" alt="Equation 2"></div>
where radiative sources have been neglected, and:

- <img src="https://latex.codecogs.com/svg.latex?{\bf v}" alt="Equation 3"> is the velocity vector
- <img src="https://latex.codecogs.com/svg.latex?\dot{\boldsymbol{\varepsilon}}" alt="Equation 4"> is the strain rate tensor
- <img src="https://latex.codecogs.com/svg.latex?E" alt="Equation 5"> is the internal energy density
- <img src="https://latex.codecogs.com/svg.latex?\kappa" alt="Equation 6"> is the specific heat conductivity, which can depend on the heat density
- <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\sigma}" alt="Equation 7"> is the Cauchy stress tensor.

For constant heat conductivity and heat capacity <img src="https://latex.codecogs.com/svg.latex?c_i" alt="Equation 8">, the previous equation becomes:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\rho c_i \left(\frac{\partial T}{\partial t} + {\bf v} \cdot \nabla T \right)= - c_i \kappa \Delta T + \mbox{Tr} \left( \boldsymbol{\sigma} \cdot\dot{\boldsymbol{\varepsilon}}\right)" alt="Equation 9"></div>

#### Boundary conditions
Dirichlet boundary conditions should be applied at the ice surface:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
T(z=s) = T_s," alt="Equation 10"></div>
and Neumann boundary conditions at the ice base:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
q(z=b) = - \kappa(E) \nabla E = q_{\mbox{geo}}" alt="Equation 11"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?s" alt="Equation 12"> is the elevation of the ice upper surface
- <img src="https://latex.codecogs.com/svg.latex?b" alt="Equation 13"> is the elevation of the floating ice lower surface
When using the enthalpy formulation, the basal boundary condition scheme from [<a href="#references">*Aschwanden2012*</a>], figure 5 is used instead of the previous equation.

NOTE: For regional model, make sure to set a Dirichlet condition on the inflow boundary (throughout the ice column) to avoid advection of noise.

At the ice/ocean interface, a heat flux is imposed. It mainly depends on the temperature difference between the ocean and the ice. Simple parameterizations can be used to specify this flux. Holland and Jenkins (1999) propose the following relation

$$
k \left.\nabla T\right|_b \cdot {\bf n} = -\rho_w c_{pM} \;\gamma\left(T_b - T_{pmp}\right)
$$
where:
- $T_b$ is the ice temperature on the ice shelf base
- $T_{pmp}$ is the pressure melting point
- $\rho_w$ is the sea water density
- $ c_{pM}$ is the mixed layer specific heat capacity
- $\gamma$ the thermal exchange velocity.

#### Numerical implementation
The heat equation is solved using linear finite elements in space, and implicit finite difference in time (time stepping should satisfy the CFL condition). To stabilize the equation, we either add an isotropic artificial diffusion to the left hand side:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\rho \left(\frac{\partial E}{\partial t} + {\bf v} \cdot \nabla E \right)+ \nabla \left(\kappa(E)  \nabla E \right) + {\color{red} \nabla \left(\mathfrak{D} \nabla E\right)}= \mbox{Tr} \left( \boldsymbol{\sigma} \cdot \dot{\boldsymbol{\varepsilon}}\right)" alt="Equation 14"></div>
where <img src="https://latex.codecogs.com/svg.latex?\mathfrak{D}" alt="Equation 15"> is the artificial diffusivity. We take:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mathfrak{D} = \frac{h}{2}\left(\begin{array}{ccc}\left|vx\right| & 0 & 0\\\\0 & \left|vy\right| & 0 \\\\0 & 0 & \left|vz\right|\end{array}\right)" alt="Equation 16"></div>
or rely on the Streamline upwind/Petrov-Galerkin formulation (SUPG) from [<a href="#references">*Franca2006*</a>].

### Model parameters
The parameters relevant to the heat equation solution can be displayed by running:
````
>> md.thermal
````


- `md.thermal.spctemperature`: temperature constraints (`NaN` means no constraint)
- `md.thermal.stabilization`: type of stabilization (0: no stabilization; 1: artificial diffusion; 2: Streamline-Upwind Petrov-Galerkin)
- `md.thermal.maxiter`: maximum number of iterations for thermal solver
- `md.thermal.penalty_lock`: stabilize unstable thermal constraints that keep zigzagging after n iteration (default is 0, no stabilization)
- `md.thermal.penalty_threshold`: threshold to declare convergence of thermal solution (default is 0)
- `md.thermal.penalty_factor`: offset used by penalties(default is 3):

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\kappa=10^{\text{penalty\_factor}} \max_{i,j}\left| K_{ij}\right|" alt="Equation 17"></div>

- `md.thermal.isenthalpy`: are we using the enthalpy formulation (Aschwanden et al., 2012)? (0: no, 1: yes)
- `md.thermal.isdynamicbasalspc`: are we allowing changing basal boundary conditions for transient runs?
- `md.thermal.requested_outputs`: specify further requested outputs here.

The solution will also use the following model fields:

- `md.initialization.temperature`: temperature field (in K)
- `md.initialization.waterfraction`: water fraction in ice (between <img src="https://latex.codecogs.com/svg.latex?0" alt="Equation 19"> and <img src="https://latex.codecogs.com/svg.latex?1" alt="Equation 18">)
- `md.basalforcings.geothermalflux`: geothermal heat flux (in <img src="https://latex.codecogs.com/svg.latex?\mbox{W}/\mbox{m}^2" alt="Equation 20">)
- `md.basalforcings.meltingrate`: basal melting rate (in m/yr w.e.)
- `md.timestepping.time_step`: length of time steps (in yrs)

### Running a simulation
To run a simulation solving only the thermal state, use the following command:
````
>> md = solve(md, 'Thermal');
````
This will compute **one time step only** of the thermal equation; use the 
 <a href="transient">transient solution</a>
for multiple time steps.

To run a thermal steady-state simulation  (i.e., $\partial T/\partial t = 0$), you need to first set the time stepping as 0:
````
>> md.timestepping.time_step = 0
>> md = solve(md, 'Thermal');
````
