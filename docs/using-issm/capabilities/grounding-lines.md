---
title: Grounding Lines
layout: default
parent: Capabilities
math: mathjax3
---

# Grounding Line Migration

## Physical basis
### Hydrostatic equilibrium
The position of the grounding line is determined by a flotation criterion: ice is floating if its thickness, $$H$$, is equal or lower than the floating height $$H_f$$ defined as:

$$
H_f = - \frac{\rho_w}{\rho_i} r , \; r<0
$$

where $$\rho_i$$ is the ice density, $$\rho_w$$ the ocean density and $$r$$ the bedrock elevation (negative if below sea level). Grounding line is therefore located where $$H = H_f$$:

$$
\begin{array}{rcll}H & > & H_f & \text{ice is grounded}\\H & = & H_f & \text{grounding line position}\\H & < & H_f & \text{ice is floating}\end{array}
$$

Each element of the mesh is either grounded or floating: flotation criterion is determined on each vertex of the triangle and if at least one vertex of the triangle is floating, the element is considered floating and no friction is applied. Otherwise, if the three vertices are grounded, the element is considered grounded. We refer to this type of grounding line migration as `'SoftMigration'`.

Sub-element parameterization can also be used to track the position of the grounding line within an element and improve accuracy of the results. The floating condition is a 2D field and the grounding line position is determined by the line where $$H = H_f$$, so it is located anywhere within an element. Some elements are therefore partly grounded and partly floating. Two different schemes of sub-element parameterizations have been implemented.

In the first case, the basal friction coefficient $$C$$ is reduced to match the amount of grounded ice in the element as proposed by [<a href="#references">*Pattyn2006*</a>] and [<a href="#references">*Gladstone2010*</a>] but for a 2D element:

$$
C_g = C \;\frac{A_g}{A}
$$

where $$C_g$$ is the applied basal friction coefficient for the element partially grounded, $$A_g$$ is the area of grounded ice of this element and $$A$$ is the total area of the element. We refer to this type of grounding line parameterization as `'SubelementMigration'`.

In the second case, the basal friction computed for partly grounded elements is integrated only on the part of the element that is grounded. This can be done simply by changing the integration area from the initial element to the grounded part of the element, over which the basal friction is unchanged. We refer to this type of grounding line parameterization as `'SubelementMigration2'`.

The sub-element parameterizations are described in detail in [<a href="#references">*Seroussi2014a*</a>].

### Contact mechanics
Grounding line migration can be advantageously based on contact mechanics when solving the stress balance equations with a full-Stokes model [<a href="#references">*Nowicki2008,Durand2009*</a>].

This capability is currently under development.

## Model parameters
The parameters relevant to the grounding line migration can be displayed by running:
````
>> md.groundingline
````

- `md.groundingline.migration`: type of grounding line migration:
  `'SoftMigration'`, `'AgressiveMigration'`, `'SubelementMigration'`, `'SubelementMigration2'`, or `'None'`

## Running a simulation
To compute grounding line migration, the transient solution must be used and all solutions except the grounding line migration must be deactivated (see 
 <a href="transient">transient solution</a>):
````
>> md = solve(md, 'Transient');
````
The first argument to `solve` is the model, the second is the nature of the simulation one wants to run.

# References
- G. Durand, O. Gagliardini, T. Zwinger, E. Le Meur, and R. C. A. Hindmarsh.
 Full Stokes modeling of marine ice sheets: influence of the grid
   size.
 Ann. Glaciol., 50(52):109-114, 2009.

- R. M. Gladstone, V. Lee, A. Vieli, and A. J. Payne.
 Grounding line migration in an adaptive mesh ice sheet model.
 J. Geophys. Res., 115:1-19, Oct 27 2010.

- S. M. J. Nowicki and D. J. Wingham.
 Conditions for a steady ice sheet-ice shelf junction.
 Earth Planet. Sci. Lett., 265(1-2):246-255, JAN 15 2008.

- F. Pattyn, A. Huyghe, S. De Brabander, and B. De Smedt.
 Role of transition zones in marine ice sheet dynamics.
 J. Geophys. Res. - Earth Surface, 111(F2):1-10, APR 26 2006.

- H. Seroussi, M. Morlighem, E. Larour, E. Rignot, and A. Khazendar.
 Hydrostatic grounding line parameterization in ice sheet models.
 Cryosphere, 8(6):2075-2087, Nov. 2014.
