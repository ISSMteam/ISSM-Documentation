---
title: Elastostatic
layout: default
parent: Capabilities
math: mathjax3
---

# Elastostatic Adjustment Solution
## Physical basis
Any redistribution of mass at the Earth's surface, such as snow, water, or atmosphere, loads and deforms the underlying solid Earth. At timescales that are comparable to those of the main tidal constituents, such as the near-annual periods, solid Earth deformation is excellently approximated as an elastic response. This module employs the classical Green's function approach to solving for interior Earth responses at the surface, following the so-called load Love number formalism for a radially stratified, seismologically constrained, elastically compressible Earth.

## 3-D crustal motions
Let $$U_i$$ (for $$i=1,2,3$$) be the components of the 3-D crustal displacement vector, $$\vec{U}(\theta,\phi,t)$$, evaluated at geographic coordinates $$(\theta,\phi)$$ at time $$t$$, where $$U_1$$ is the vertical displacement (up positive), $$U_2$$ is the north-south component of horizontal displacement (north positive), and $$U_3$$ is the east-west component of horizontal displacement (east positive).

For a given surface load, $$H(\theta,\phi,t)$$, with dimensions of ice equivalent height, these displacement components may be computed theoretically as follows:

$$
\vec{U}(\theta,\phi,t) = \int{ \vec{G}(\alpha,\beta) H(\theta',\phi',t) \text{d}\mathcal{S}'},
$$

where $$\vec{G}(\alpha,\beta)$$ is the 3-D Green's function vector that models the influence of a specified point load evaluated at an arc distance $$\alpha$$ and direction $$\beta$$, from load coordinate position ($$\theta',\phi'$$). The integral in the above equation is applied over the surface of a unit sphere $$\mathcal{S}$$.

The components of $$\vec{G}$$ are given by:

$$
\left\{\begin{array}{l}G_1(\alpha,\beta) \\G_2(\alpha,\beta) \\G_3(\alpha,\beta)\end{array}\right\}=\frac{3}{4\pi} \frac{\rho_i}{\rho_e} \sum_{n=0}^\infty\left\{\begin{array}{l}h'_n P_n(\cos \alpha) \\l'_n \cos\phi \text{d}P_n(\cos \alpha) / \text{d} \alpha \\l'_n \sin\phi \text{d}P_n(\cos \alpha) / \text{d} \alpha\end{array}\right\},
$$

where:

- $$\rho_i$$ is the ice density
- $$\rho_e$$ is the Earth's global mean density
- $$P_n$$ are the Legendre polynomials of degree $$n$$
- $$h'_n$$ and $$l'_n$$ are the load Love numbers

## Numerical implementation
We use Love numbers &#8212; provided by the International Association of Geodesy (available at http://www.srosat.com/iag-jsg/loveNb.php) &#8212; which are the solutions of the zero frequency momentum equations with self-gravitation for a spherically symmetric and seismologically constrained Earth structure model [see, e.g., Alterman et al., 1959]. Since $$h'_n$$ converges slowly toward a constant as $$n \rightarrow \infty$$, the requirement for generating an accurate solution for crustal deformation is stringent, demanding truncation of the series at high degree $$n = 10,000$$. See [<a href="#references">*Adhikari2017*</a>] for more details.

## Model parameters
The parameters relevant to the elastostatic adjustment (ESA) solution can be displayed by running:
````
>> md.esa
````

- `md.esa.deltathickness`: thickness change: ice height equivalent [m]
- `md.solidearth.lovenumbers`: loads required Love numbers for solid Earth deformation
- `md.esa.hemisphere`: North-south, East-west components of 2-D horizontal displacement vector: -1 south, 1 north
- `md.esa.degacc`: accuracy (default .01 deg) for numerical discretization of the Green's functions

## Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Esa');
````
The first argument is the model, the second is the nature of the simulation one wants to run.

# References
- S. Adhikari, E. R. Ivins, and E. Larour.
 Mass transport waves amplified by intense Greenland melt and
   detected in solid Earth deformation.
 Geophys. Res. Lett., 44(10):4965-4975, 2017.

