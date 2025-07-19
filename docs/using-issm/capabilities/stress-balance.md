---
title: Stress Balance Solution
layout: default
parent: Capabilities
---

## Stress Balance Solution

### Physical basis
#### Conservation of linear momentum
The conservation of momentum reads:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\rho \frac{D {\bf v} }{Dt} = \nabla \cdot {\boldsymbol{\sigma}} + \rho {\bf b}" alt="Equation 1"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\rho" alt="Equation 2"> is the ice density
- <img src="https://latex.codecogs.com/svg.latex?{\bf v}" alt="Equation 3"> is the velocity vector
- <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\sigma}" alt="Equation 4"> is the Cauchy stress tensor
- <img src="https://latex.codecogs.com/svg.latex?{\bf b}" alt="Equation 5"> is a body force
Now if we assume that:

- The ice motion is a Stokes flow (acceleration negligible)
- The only body force is due to gravity (Coriolis effect negligible)
The equation of momentum conservation is reduced to:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\nabla \cdot \boldsymbol{\sigma} + \rho {\bf g} = {\bf 0}" alt="Equation 6"></div>
#### Conservation of angular momentum
For a non-polar material body, the balance of angular momentum imposes the stress tensor to be symmetrical:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\boldsymbol{\sigma} = \boldsymbol{\sigma}^T" alt="Equation 7"></div>
#### Ice constitutive equations
Ice is treated as a purely viscous incompressible material [<a href="#references">*Cuffey2010*</a>]. Its constitutive equation therefore only involves the deviatoric stress and the strain rate tensor:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\boldsymbol{\sigma}' = 2\,\mu\dot{\boldsymbol{\varepsilon}}" alt="Equation 8"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\sigma}'" alt="Equation 10"> is the deviatoric stress tensor (<img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\sigma}' = \boldsymbol{\sigma} + p {\bf I}" alt="Equation 9">)
- <img src="https://latex.codecogs.com/svg.latex?\mu" alt="Equation 11"> is the ice effective viscosity
- <img src="https://latex.codecogs.com/svg.latex?\dot{\boldsymbol{\varepsilon}}" alt="Equation 12"> is the strain rate tensor
Ice is a non-Newtonian fluid, its viscosity follows the generalized Glen's flow law [<a href="#references">*Glen1955*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mu = \frac{B}{2\,\dot{\varepsilon}_e^{\frac{n-1}{n}}}" alt="Equation 13"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 14"> is the ice hardness or rigidity
- <img src="https://latex.codecogs.com/svg.latex?n" alt="Equation 15"> is Glen's flow law exponent, generally taken as equal to 3
- <img src="https://latex.codecogs.com/svg.latex?\dot{\varepsilon}_e" alt="Equation 16"> is the effective strain rate
The effective strain rate is defined as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\dot{\varepsilon}_e = \sqrt{\frac{1}{2} \sum_{i,j} \dot{\varepsilon}_{ij}^2}= \frac{1}{\sqrt{2}} \|\dot{\boldsymbol{\varepsilon}}\|_F" alt="Equation 17"></div>
where <img src="https://latex.codecogs.com/svg.latex?\|\cdot\|_F" alt="Equation 18"> is the Frobenius norm.

#### Full-Stokes (FS) field equations
Without any further approximation, the previous system of equations are called the **Full-Stokes** model.

#### Higher-Order (HO) field equations
We make two assumptions:

1. Bridging effects are neglected
1. Horizontal gradient of vertical velocities are neglected compared to vertical gradients of horizontal velocities
With these two assumptions, the Full-Stokes equations are reduced to a system of 2 equations with 2 unknowns [<a href="#references">*Blatter1995, Pattyn2003*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{l}\nabla\cdot\left(2\mu\dot{\boldsymbol{\varepsilon}}_{HO1}\right) = \rho g \dfrac{\partial s}{\partial x} \\\\\nabla\cdot\left(2\mu\dot{\boldsymbol{\varepsilon}}_{HO2}\right) = \rho g \dfrac{\partial s}{\partial y}\end{array}" alt="Equation 19"></div>
with:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{l}\dot{\boldsymbol{\varepsilon}}_{HO1} = \left[\begin{array}{c}2\dfrac{\partial v_x}{\partial x} +  \dfrac{\partial v_y}{\partial y}\\\\\dfrac{1}{2}\left(\dfrac{\partial v_x}{\partial y} + \dfrac{\partial v_y}{\partial x}\right)\\\\\dfrac{1}{2}\dfrac{\partial v_x}{\partial z}\end{array}\right]\quad\dot{\boldsymbol{\varepsilon}}_{HO2} =\left[\begin{array}{c}\dfrac{1}{2}\left(\dfrac{\partial v_x}{\partial y} + \dfrac{\partial v_y}{\partial x}\right)\\\\\dfrac{\partial v_x}{\partial x} + 2\dfrac{\partial v_y}{\partial y}\\\\\dfrac{1}{2}\dfrac{\partial v_y}{\partial z}\end{array}\right]\end{array}" alt="Equation 20"></div>

#### Shelfy-Stream Approximation (SSA) field equations
We make the following assumption:

1. Vertical shear is negligible
With this assumption, we have a system of 2 equations with 2 unknowns in the horizontal plane
[<a href="#references">*Morland1987a, MacAyeal1989*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{l}\nabla\cdot\left(2\bar{\mu}H\dot{\boldsymbol{\varepsilon}}_{SSA1}\right) - \alpha^2 v_x= \rho g H \dfrac{\partial s}{\partial x} \\\\\nabla\cdot\left(2\bar{\mu}H\dot{\boldsymbol{\varepsilon}}_{SSA2}\right) - \alpha^2 v_y= \rho g H \dfrac{\partial s}{\partial y}\end{array}" alt="Equation 21"></div>
with:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{l}\dot{\boldsymbol{\varepsilon}}_{SSA1} = \left[\begin{array}{c}2\dfrac{\partial v_x}{\partial x} +  \dfrac{\partial v_y}{\partial y}\\\\\dfrac{1}{2}\left(\dfrac{\partial v_x}{\partial y} + \dfrac{\partial v_y}{\partial x}\right)\end{array}\right]\quad\dot{\boldsymbol{\varepsilon}}_{SSA2} =\left[\begin{array}{c}\dfrac{1}{2}\left(\dfrac{\partial v_x}{\partial y} + \dfrac{\partial v_y}{\partial x}\right)\\\\\dfrac{\partial v_x}{\partial x} + 2\dfrac{\partial v_y}{\partial y}\end{array}\right]\end{array}" alt="Equation 22"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\bar{\mu}" alt="Equation 23"> is the depth-averaged viscosity
- <img src="https://latex.codecogs.com/svg.latex?H" alt="Equation 24"> is the ice thickness
- <img src="https://latex.codecogs.com/svg.latex?\alpha" alt="Equation 25"> is the basal friction coefficient

#### Boundary conditions
At the surface of the ice sheet, <img src="https://latex.codecogs.com/svg.latex?\Gamma_s" alt="Equation 28">, we assume a stress-free boundary condition. A viscous friction law is applied at the base of the ice sheet, <img src="https://latex.codecogs.com/svg.latex?\Gamma_b" alt="Equation 27">, and water pressure is applied at the ice/water interface <img src="https://latex.codecogs.com/svg.latex?\Gamma_w" alt="Equation 26">. For FS, these boundary conditions are:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{rcll}\boldsymbol{\sigma}\cdot {\bf n} & = & \boldsymbol{0} & \text{ on } \Gamma_s\\\\\left(\boldsymbol{\sigma}\cdot {\bf n} \cdot {\bf n} + {\alpha}^2 {\bf v}\right)_{\parallel} & = & \boldsymbol{0} & \text{ on } \Gamma_b\\\\{\bf v} \cdot {\bf n}  & = & 0 & \text{ on } \Gamma_b\\\\\boldsymbol{\sigma}\cdot {\bf n} & = & \rho_w g z {\bf n} & \text{ on } \Gamma_w\end{array}" alt="Equation 29"></div>
where

- <img src="https://latex.codecogs.com/svg.latex?{\bf n}" alt="Equation 30"> is the outward-pointing unit normal vector
- <img src="https://latex.codecogs.com/svg.latex?\rho_w" alt="Equation 31"> is the water density
- <img src="https://latex.codecogs.com/svg.latex?z" alt="Equation 32"> is the vertical coordinate with respect to sea level

For HO, these boundary conditions become:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{rclrcll}\dot{\boldsymbol{\varepsilon}}_{HO1} \cdot {\bf n} & = & 0 &\dot{\boldsymbol{\varepsilon}}_{HO2} \cdot {\bf n} & = & 0 &\text{ on } \Gamma_s\\\\2\mu\,\dot{\boldsymbol{\varepsilon}}_{HO1} \cdot {\bf n} & = & -\alpha^2 v_x &2\mu\,\dot{\boldsymbol{\varepsilon}}_{HO2} \cdot {\bf n} & = & -\alpha^2 v_y &\text{ on } \Gamma_b\\\\2\mu\,\dot{\boldsymbol{\varepsilon}}_{HO1} \cdot {\bf n} & = & f_w n_x &2\mu\,\dot{\boldsymbol{\varepsilon}}_{HO2} \cdot {\bf n} & = & f_w n_y &\text{ on } \Gamma_w\end{array}" alt="Equation 33"></div>
where <img src="https://latex.codecogs.com/svg.latex?f_w=\rho g\left(s-z\right) +\rho_w g \min\left(z,0\right)" alt="Equation 34">.

For SSA, these boundary conditions are:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{rclrcll}\dot{\boldsymbol{\varepsilon}}_{SSA1} \cdot {\bf n} & = & 0 &\dot{\boldsymbol{\varepsilon}}_{SSA2} \cdot {\bf n} & = & 0 &\text{ on } \Gamma_s\end{array}" alt="Equation 35"></div>

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{rcl}2\bar{\mu}H\dot{\boldsymbol{\varepsilon}}_{SSA1} \cdot {\bf n} & = & \left(\frac{1}{2}\rho g H^2 - \frac{1}{2}\rho_w g b^2 \right) n_x \\\\2\bar{\mu}H\dot{\boldsymbol{\varepsilon}}_{SSA2} \cdot {\bf n} & = & \left(\frac{1}{2}\rho g H^2 - \frac{1}{2}\rho_w g b^2 \right) n_y\end{array}\text{ on } \Gamma_w" alt="Equation 36"></div>

### Model parameters
The parameters relevant to the stress balance solution can be displayed by typing:
````
>> md.stressbalance
````


- `md.stressbalance.restol`: mechanical equilibrium residue convergence criterion
- `md.stressbalance.reltol`: velocity relative convergence criterion, (`NaN` if not applied)
- `md.stressbalance.abstol`: velocity absolute convergence criterion, (`NaN` if not applied)
- `md.stressbalance.maxiter`: maximum number of nonlinear iterations (default is 100)
- `md.stressbalance.spcvx`: x-axis velocity constraint (`NaN` means no constraint)
- `md.stressbalance.spcvy`: y-axis velocity constraint (`NaN` means no constraint)
- `md.stressbalance.spcvz`: z-axis velocity constraint (`NaN` means no constraint)
- `md.stressbalance.rift_penalty_threshold`: threshold for instability of mechanical constraints
- `md.stressbalance.rift_penalty_lock`: number of iterations before rift penalties are locked
- `md.stressbalance.penalty_factor`: offset used by penalties:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\kappa=10^{\text{penalty\_factor}} \max_{i,j}\left| K_{ij}\right|" alt="Equation 37"></div>

- `md.stressbalance.vertex_pairing`: pairs of vertices that are penalized
- `md.stressbalance.shelf_dampening`: use dampening for floating ice? Only for Stokes model
- `md.stressbalance.referential`: local referential
- `md.stressbalance.requested_outputs`: additional outputs requested

The solution will also use the following model fields:

- `md.flowequations`: FS, HO or SSA
- `md.materials`: material parameters
- `md.initialization.vx`: x component of velocity (used as an initial guess)
- `md.initialization.vy`: y component of velocity (used as an initial guess)
- `md.initialization.vz`: y component of velocity (used as an initial guess)

### Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Stressbalance');
````
The first argument is the model, the second is the nature of the simulation one wants to run.


## References
