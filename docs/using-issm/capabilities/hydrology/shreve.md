---
title: Hydrology Solution - Shreve Approximation
layout: default
parent: Hydrology Solution
math: mathjax3
---

# Hydrology Solution - Shreve Approximation

## Physical basis
This model is the one described in [<a href="#references">*LeBrocq2009*</a>]. Here we present only the main equations.

### Water column
The model applied here is the most simplistic form of the water-film model, as described by the Weertman theory [<a href="#references">*Weertman1957*</a>]. The model solves for the thickness $$w$$ of the water-film as follows:

$$
\frac{\partial w}{\partial t}=S - \nabla \cdot {\bf u}_{w} w
$$
where:

- $$S$$ is the source term $$[m\,s^{-1}]$$
- $${\bf u}_w$$ is the water velocity vector $$[m\,s^{-1}]$$

The water velocity vector $${\bf u}_w$$ is a depth-averaged two dimensional horizontal vector, which is computed using a theoretical treatment of laminar flow between two parallel plates:

$$
{\bf u}_w = \frac{w^2}{12 \mu}\nabla \phi
$$

- $$\phi$$ is the hydraulic potential $$[Pa]$$
- $$\mu$$ is the water viscosity $$[Pa\,s]$$

In this model, the hydraulic potential $$\phi$$ is defined following the Shreve approximation [<a href="#references">*Shreve1972*</a>], which hypothesizes a null effective pressure. Assuming this null effective pressure gives the hydraulic potential gradient as follows:

$$
\nabla \phi=\rho_{ice} g \nabla s + \left(\rho_w - \rho_{ice}\right) g \nabla h
$$
where:

- $$\rho_{ice}$$ is the density of the ice $$[kg\,m^{-3}]$$
- $$\rho_w$$ is the density of fresh water $$[kg\,m^{-3}]$$
- $$s$$ is the surface elevation $$[m]$$
- $$g$$ is the gravitational acceleration $$[m\,s^{-2}]$$
- $$h$$ is the bedrock elevation $$[m]$$

### Numerical implementation
To stabilize the equation, artificial diffusion might be added to the left hand side:

$$
\frac{\partial w}{\partial t} +{\color{red} \nabla \left(\mathfrak{D} \nabla w\right)} =S - \nabla \cdot {\bf u}_w w
$$
where $$\mathfrak{D}$$ is the artificial diffusivity. We take:

$$
\mathfrak{D} = \frac{h}{2}\left(\begin{array}{cc}\left|vx\right| & 0 \\\\0 & \left|vy\right|\end{array}\right)
$$

## Model parameters
The parameters relevant to the water column solution can be displayed by running:
````
>> md.hydrology
````


- `md.hydrology.spcwatercolumn`: water thickness constraints (`NaN` means no constraint) $$[m]$$
- `md.hydrology.stabilization`: artificial diffusivity (default is 1).

## Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Hydrology');
````


# References
- A. M. Le Brocq, A. J. Payne, M. J. Siegert, and R. B. Alley.
 A subglacial water-flow model for West Antarctica.
 J. Glaciol., 55(193):879-888, 2009.

- R. L. Shreve.
 Movement of water in glaciers.
 J. Glaciol., 11(62):205-214, 1972.

- J. Weertman.
 On the sliding of glaciers.
 J. Glaciol., 3:33-38, March 1957.
