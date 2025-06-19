---
title: Elastostatic Adjustment Solution
layout: default
parent: Capabilities
has_children: false
has_toc: false
---

## Elastostatic Adjustment Solution
### Physical basis
Any redistribution of mass at the Earth's surface, such as snow, water, or atmosphere, loads and deforms the underlying solid Earth. At timescales that are comparable to those of the main tidal constituents, such as the near-annual periods, solid Earth deformation is excellently approximated as an elastic response. This module employs the classical Green's function approach to solving for interior Earth responses at the surface, following the so-called load Love number formalism for a radially stratified, seismologically constrained, elastically compressible Earth.

### 3-D crustal motions
Let <img src="https://latex.codecogs.com/svg.latex?U_i" alt="Equation 8"> (for <img src="https://latex.codecogs.com/svg.latex?i=1,2,3" alt="Equation 7">) be the components of the 3-D crustal displacement vector, <img src="https://latex.codecogs.com/svg.latex?\vec{U}(\theta,\phi,t)" alt="Equation 6">, evaluated at geographic coordinates <img src="https://latex.codecogs.com/svg.latex?(\theta,\phi)" alt="Equation 5"> at time <img src="https://latex.codecogs.com/svg.latex?t" alt="Equation 4">, where <img src="https://latex.codecogs.com/svg.latex?U_1" alt="Equation 3"> is the vertical displacement (up positive), <img src="https://latex.codecogs.com/svg.latex?U_2" alt="Equation 2"> is the north-south component of horizontal displacement (north positive), and <img src="https://latex.codecogs.com/svg.latex?U_3" alt="Equation 1"> is the east-west component of horizontal displacement (east positive).

For a given surface load, <img src="https://latex.codecogs.com/svg.latex?H(\theta,\phi,t)" alt="Equation 9">, with dimensions of ice equivalent height, these displacement components may be computed theoretically as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\vec{U}(\theta,\phi,t) = \int{ \vec{G}(\alpha,\beta) H(\theta',\phi',t) \text{d}\mathcal{S}'}," alt="Equation 10"></div>
where <img src="https://latex.codecogs.com/svg.latex?\vec{G}(\alpha,\beta)" alt="Equation 15"> is the 3-D Green's function vector that models the influence of a specified point load evaluated at an arc distance <img src="https://latex.codecogs.com/svg.latex?\alpha" alt="Equation 14"> and direction <img src="https://latex.codecogs.com/svg.latex?\beta" alt="Equation 13">, from load coordinate position (<img src="https://latex.codecogs.com/svg.latex?\theta',\phi'" alt="Equation 12">). The integral in the above equation is applied over the surface of a unit sphere <img src="https://latex.codecogs.com/svg.latex?\mathcal{S}" alt="Equation 11">.

The components of <img src="https://latex.codecogs.com/svg.latex?\vec{G}" alt="Equation 16"> are given by:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\left\{\begin{array}{l}G_1(\alpha,\beta) \\G_2(\alpha,\beta) \\G_3(\alpha,\beta)\end{array}\right\}=\frac{3}{4\pi} \frac{\rho_i}{\rho_e} \sum_{n=0}^\infty\left\{\begin{array}{l}h'_n P_n(\cos \alpha) \\l'_n \cos\phi \text{d}P_n(\cos \alpha) / \text{d} \alpha \\l'_n \sin\phi \text{d}P_n(\cos \alpha) / \text{d} \alpha\end{array}\right\}," alt="Equation 17"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\rho_i" alt="Equation 18"> is the ice density
- <img src="https://latex.codecogs.com/svg.latex?\rho_e" alt="Equation 19"> is the Earth's global mean density
- <img src="https://latex.codecogs.com/svg.latex?P_n" alt="Equation 21"> are the Legendre polynomials of degree <img src="https://latex.codecogs.com/svg.latex?n" alt="Equation 20">
- <img src="https://latex.codecogs.com/svg.latex?h'_n" alt="Equation 23"> and <img src="https://latex.codecogs.com/svg.latex?l'_n" alt="Equation 22"> are the load Love numbers

### Numerical implementation
We use Love numbers &#8212; provided by the International Association of Geodesy (available at http://www.srosat.com/iag-jsg/loveNb.php) &#8212; which are the solutions of the zero frequency momentum equations with self-gravitation for a spherically symmetric and seismologically constrained Earth structure model [see, e.g., Alterman et al., 1959]. Since <img src="https://latex.codecogs.com/svg.latex?h'_n" alt="Equation 26"> converges slowly toward a constant as <img src="https://latex.codecogs.com/svg.latex?n \rightarrow \infty" alt="Equation 25">, the requirement for generating an accurate solution for crustal deformation is stringent, demanding truncation of the series at high degree <img src="https://latex.codecogs.com/svg.latex?n = 10,000" alt="Equation 24">. See [<a href="#references">*Adhikari2017*</a>] for more details.

### Model parameters
The parameters relevant to the elastostatic adjustment (ESA) solution can be displayed by running:
````
>> md.esa
````


- `md.esa.deltathickness`: thickness change: ice height equivalent [m]
- `md.solidearth.lovenumbers`: loads required Love numbers for solid Earth deformation
- `md.esa.hemisphere`: North-south, East-west components of 2-D horiz displacement vector: -1 south, 1 north
- `md.esa.degacc`: accuracy (default .01 deg) for numerical discretization of the Green's functions

### Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Esa');
````
The first argument is the model, the second is the nature of the simulation one wants to run.


## References
