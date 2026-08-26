---
title: Stress Balance
layout: default
parent: Capabilities
math: mathjax3
---

# Stress Balance Solution

## Physical basis
### Conservation of linear momentum
The conservation of momentum reads:

$$
\rho \frac{D {\bf v} }{Dt} = \nabla \cdot {\boldsymbol{\sigma}} + \rho {\bf b}
$$
where:

- $$\rho$$ is the ice density
- $${\bf v}$$ is the velocity vector
- $$\boldsymbol{\sigma}$$ is the Cauchy stress tensor
- $${\bf b}$$ is a body force

Now if we assume that:

- The ice motion is a Stokes flow (acceleration negligible)
- The only body force is due to gravity (Coriolis effect negligible)

The equation of momentum conservation is reduced to:

$$
\nabla \cdot \boldsymbol{\sigma} + \rho {\bf g} = {\bf 0}
$$
### Conservation of angular momentum
For a non-polar material body, the balance of angular momentum imposes the stress tensor to be symmetrical:

$$
\boldsymbol{\sigma} = \boldsymbol{\sigma}^T
$$
### Ice constitutive equations
Ice is treated as a purely viscous incompressible material [<a href="#references">*Cuffey2010*</a>]. Its constitutive equation therefore only involves the deviatoric stress and the strain rate tensor:

$$
\boldsymbol{\sigma}' = 2\,\mu\dot{\boldsymbol{\varepsilon}}
$$
where:

- $$\boldsymbol{\sigma}'$$ is the deviatoric stress tensor ($$\boldsymbol{\sigma}' = \boldsymbol{\sigma} + p {\bf I}$$)
- $$\mu$$ is the ice effective viscosity
- $$\dot{\boldsymbol{\varepsilon}}$$ is the strain rate tensor
Ice is a non-Newtonian fluid, its viscosity follows the generalized Glen's flow law [<a href="#references">*Glen1955*</a>]:

$$
\mu = \frac{B}{2\,\dot{\varepsilon}_e^{\frac{n-1}{n}}}
$$
where:

- $$B$$ is the ice hardness or rigidity
- $$n$$ is Glen's flow law exponent, generally taken as equal to 3
- $$\dot{\varepsilon}_e$$ is the effective strain rate
The effective strain rate is defined as:

$$
\dot{\varepsilon}_e = \sqrt{\frac{1}{2} \sum_{i,j} \dot{\varepsilon}_{ij}^2}= \frac{1}{\sqrt{2}} \|\dot{\boldsymbol{\varepsilon}}\|_F
$$
where $$\|\cdot\|_F$$ is the Frobenius norm.

### Full-Stokes (FS) field equations
Without any further approximation, the previous system of equations is called the **Full-Stokes** model.

### Higher-Order (HO) field equations
We make two assumptions:

1. Bridging effects are neglected
1. Horizontal gradient of vertical velocities are neglected compared to vertical gradients of horizontal velocities

With these two assumptions, the Full-Stokes equations are reduced to a system of 2 equations with 2 unknowns [<a href="#references">*Blatter1995, Pattyn2003*</a>]:

$$
\begin{array}{l}\nabla\cdot\left(2\mu\dot{\boldsymbol{\varepsilon}}_{HO1}\right) = \rho g \dfrac{\partial s}{\partial x} \\\\\nabla\cdot\left(2\mu\dot{\boldsymbol{\varepsilon}}_{HO2}\right) = \rho g \dfrac{\partial s}{\partial y}\end{array}
$$
with:

$$
\begin{array}{l}\dot{\boldsymbol{\varepsilon}}_{HO1} = \left[\begin{array}{c}2\dfrac{\partial v_x}{\partial x} +  \dfrac{\partial v_y}{\partial y}\\\\\dfrac{1}{2}\left(\dfrac{\partial v_x}{\partial y} + \dfrac{\partial v_y}{\partial x}\right)\\\\\dfrac{1}{2}\dfrac{\partial v_x}{\partial z}\end{array}\right]\quad\dot{\boldsymbol{\varepsilon}}_{HO2} =\left[\begin{array}{c}\dfrac{1}{2}\left(\dfrac{\partial v_x}{\partial y} + \dfrac{\partial v_y}{\partial x}\right)\\\\\dfrac{\partial v_x}{\partial x} + 2\dfrac{\partial v_y}{\partial y}\\\\\dfrac{1}{2}\dfrac{\partial v_y}{\partial z}\end{array}\right]\end{array}
$$

### Shelfy-Stream Approximation (SSA) field equations
We make the following assumption:

1. Vertical shear is negligible

With this assumption, we have a system of 2 equations with 2 unknowns in the horizontal plane
[<a href="#references">*Morland1987a, MacAyeal1989*</a>]:

$$
\begin{array}{l}\nabla\cdot\left(2\bar{\mu}H\dot{\boldsymbol{\varepsilon}}_{SSA1}\right) - \alpha^2 v_x= \rho g H \dfrac{\partial s}{\partial x} \\\\\nabla\cdot\left(2\bar{\mu}H\dot{\boldsymbol{\varepsilon}}_{SSA2}\right) - \alpha^2 v_y= \rho g H \dfrac{\partial s}{\partial y}\end{array}
$$
with:

$$
\begin{array}{l}\dot{\boldsymbol{\varepsilon}}_{SSA1} = \left[\begin{array}{c}2\dfrac{\partial v_x}{\partial x} +  \dfrac{\partial v_y}{\partial y}\\\\\dfrac{1}{2}\left(\dfrac{\partial v_x}{\partial y} + \dfrac{\partial v_y}{\partial x}\right)\end{array}\right]\quad\dot{\boldsymbol{\varepsilon}}_{SSA2} =\left[\begin{array}{c}\dfrac{1}{2}\left(\dfrac{\partial v_x}{\partial y} + \dfrac{\partial v_y}{\partial x}\right)\\\\\dfrac{\partial v_x}{\partial x} + 2\dfrac{\partial v_y}{\partial y}\end{array}\right]\end{array}
$$
where:

- $$\bar{\mu}$$ is the depth-averaged viscosity
- $$H$$ is the ice thickness
- $$\alpha$$ is the basal friction coefficient

### Boundary conditions
At the surface of the ice sheet, $$\Gamma_s$$, we assume a stress-free boundary condition. A viscous friction law is applied at the base of the ice sheet, $$\Gamma_b$$, and water pressure is applied at the ice/water interface $$\Gamma_w$$. For FS, these boundary conditions are:

$$
\begin{array}{rcll}\boldsymbol{\sigma}\cdot {\bf n} & = & \boldsymbol{0} & \text{ on } \Gamma_s\\\\\left(\boldsymbol{\sigma}\cdot {\bf n} \cdot {\bf n} + {\alpha}^2 {\bf v}\right)_{\parallel} & = & \boldsymbol{0} & \text{ on } \Gamma_b\\\\{\bf v} \cdot {\bf n}  & = & 0 & \text{ on } \Gamma_b\\\\\boldsymbol{\sigma}\cdot {\bf n} & = & \rho_w g z {\bf n} & \text{ on } \Gamma_w\end{array}
$$
where

- $${\bf n}$$ is the outward-pointing unit normal vector
- $$\rho_w$$ is the water density
- $$z$$ is the vertical coordinate with respect to sea level

For HO, these boundary conditions become:

$$
\begin{array}{rclrcll}\dot{\boldsymbol{\varepsilon}}_{HO1} \cdot {\bf n} & = & 0 &\dot{\boldsymbol{\varepsilon}}_{HO2} \cdot {\bf n} & = & 0 &\text{ on } \Gamma_s\\\\2\mu\,\dot{\boldsymbol{\varepsilon}}_{HO1} \cdot {\bf n} & = & -\alpha^2 v_x &2\mu\,\dot{\boldsymbol{\varepsilon}}_{HO2} \cdot {\bf n} & = & -\alpha^2 v_y &\text{ on } \Gamma_b\\\\2\mu\,\dot{\boldsymbol{\varepsilon}}_{HO1} \cdot {\bf n} & = & f_w n_x &2\mu\,\dot{\boldsymbol{\varepsilon}}_{HO2} \cdot {\bf n} & = & f_w n_y &\text{ on } \Gamma_w\end{array}
$$
where $$f_w=\rho g\left(s-z\right) +\rho_w g \min\left(z,0\right)$$.

For SSA, these boundary conditions are:

$$
\begin{array}{rclrcll}\dot{\boldsymbol{\varepsilon}}_{SSA1} \cdot {\bf n} & = & 0 &\dot{\boldsymbol{\varepsilon}}_{SSA2} \cdot {\bf n} & = & 0 &\text{ on } \Gamma_s\end{array}
$$

$$
\begin{array}{rcl}2\bar{\mu}H\dot{\boldsymbol{\varepsilon}}_{SSA1} \cdot {\bf n} & = & \left(\frac{1}{2}\rho g H^2 - \frac{1}{2}\rho_w g b^2 \right) n_x \\\\2\bar{\mu}H\dot{\boldsymbol{\varepsilon}}_{SSA2} \cdot {\bf n} & = & \left(\frac{1}{2}\rho g H^2 - \frac{1}{2}\rho_w g b^2 \right) n_y\end{array}\text{ on } \Gamma_w
$$

## Model parameters
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

$$
\kappa=10^{\text{penalty\_factor}} \max_{i,j}\left| K_{ij}\right|
$$

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

## Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Stressbalance');
````
The first argument is the model, the second is the nature of the simulation one wants to run.


# References
- H. Blatter.
 Velocity And Stress-Fields In Grounded Glaciers: A Simple Algorithm
   For Including Deviatoric Stress Gradients.
 J. Glaciol., 41(138):333-344, 1995.

- K. M. Cuffey and W. S. B. Paterson.
 The Physics of Glaciers, 4th Edition.
 Elsevier, Oxford, 2010.

- J. W. Glen.
 The creep of polycrystalline ice.
 Proc. R. Soc. A, 228(1175):519-538, 1955.

- L. W. Morland.
 Unconfined ice shelf flow.
 Proceedings of Workshop on the Dynamics of the West Antarctic
   Ice Sheet, University of Utrecht, May 1985. Published by Reidel, ed. C.J.
   van der Veen and J. Oerlemans:99-116, 1987.
