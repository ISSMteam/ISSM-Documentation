---
title: Hydrology Solution - Shreve Approximation
layout: default
parent: Hydrology Solution
has_children: false
has_toc: false
---

### Hydrology Solution - Shreve Approximation

#### Physical basis
This model is the one described in [<a href="#references">*LeBrocq2009*</a>]. Here we present only the main equations.

##### Water column
The model applied here is the most simplistic form of the water-film model, as described by the Weertman theory [<a href="#references">*Weertman1957*</a>]. The model solves for the thickness <img src="https://latex.codecogs.com/svg.latex?w" alt="Equation 1"> of the water-film as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial w}{\partial t}=S - \nabla \cdot {\bf u}_{w} w" alt="Equation 2"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 4"> is the source term <img src="https://latex.codecogs.com/svg.latex?[m\,s^{-1}]" alt="Equation 3">
- <img src="https://latex.codecogs.com/svg.latex?{\bf u}_w" alt="Equation 6"> is the water velocity vector <img src="https://latex.codecogs.com/svg.latex?[m\,s^{-1}]" alt="Equation 5">

The water velocity vector <img src="https://latex.codecogs.com/svg.latex?{\bf u}_w" alt="Equation 7"> is a depth-averaged two dimensional horizontal vector, which is computed using a theoretical treatment of laminar flow between two parallel plates:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
{\bf u}_w = \frac{w^2}{12 \mu}\nabla \phi" alt="Equation 8"></div>

- <img src="https://latex.codecogs.com/svg.latex?\phi" alt="Equation 10"> is the hydraulic potential <img src="https://latex.codecogs.com/svg.latex?[Pa]" alt="Equation 9">
- <img src="https://latex.codecogs.com/svg.latex?\mu" alt="Equation 12"> is the water viscosity <img src="https://latex.codecogs.com/svg.latex?[Pa\,s]" alt="Equation 11">

In this model, the hydraulic potential <img src="https://latex.codecogs.com/svg.latex?\phi" alt="Equation 13"> is defined following the Shreve approximation [<a href="#references">*Shreve1972*</a>], which hypothesizes a null effective pressure. Assuming this null effective pressure gives the hydraulic potential gradient as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\nabla \phi=\rho_{ice} g \nabla s + \left(\rho_w - \rho_{ice}\right) g \nabla h" alt="Equation 14"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\rho_{ice}" alt="Equation 16"> is the density of the ice <img src="https://latex.codecogs.com/svg.latex?[kg\,m^{-3}]" alt="Equation 15">
- <img src="https://latex.codecogs.com/svg.latex?\rho_w" alt="Equation 18"> is the density of fresh water <img src="https://latex.codecogs.com/svg.latex?[kg\,m^{-3}]" alt="Equation 17">
- <img src="https://latex.codecogs.com/svg.latex?s" alt="Equation 20"> is the surface elevation <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 19">
- <img src="https://latex.codecogs.com/svg.latex?g" alt="Equation 22"> is the gravitational acceleration <img src="https://latex.codecogs.com/svg.latex?[m\,s^{-2}]" alt="Equation 21">
- <img src="https://latex.codecogs.com/svg.latex?h" alt="Equation 24"> is the bedrock elevation <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 23">

##### Numerical implementation
To stabilize the equation, artificial diffusion might be added to the left hand side:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial w}{\partial t} +{\color{red} \nabla \left(\mathfrak{D} \nabla w\right)} =S - \nabla \cdot {\bf u}_w w" alt="Equation 25"></div>
where <img src="https://latex.codecogs.com/svg.latex?\mathfrak{D}" alt="Equation 26"> is the artificial diffusivity. We take:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mathfrak{D} = \frac{h}{2}\left(\begin{array}{cc}\left|vx\right| & 0 \\\\0 & \left|vy\right|\end{array}\right)" alt="Equation 27"></div>

#### Model parameters
The parameters relevant to the water column solution can be displayed by running:
````
>> md.hydrology
````


- `md.hydrology.spcwatercolumn`: water thickness constraints (`NaN` means no constraint) <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 28">
- `md.hydrology.stabilization`: artificial diffusivity (default is 1).

#### Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Hydrology');
````


## References
