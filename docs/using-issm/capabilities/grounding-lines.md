---
title: Grounding Lines
layout: default
parent: Capabilities
---

## Grounding Lines

### Physical basis
#### Hydrostatic equilibrium
The position of the grounding line is determined by a flotation criterion: ice is floating if its thickness, <img src="https://latex.codecogs.com/svg.latex?H" alt="Equation 2">, is equal or lower than the floating height <img src="https://latex.codecogs.com/svg.latex?H_f" alt="Equation 1"> defined as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
H_f = - \frac{\rho_w}{\rho_i} r , \; r<0" alt="Equation 3"></div>
where <img src="https://latex.codecogs.com/svg.latex?\rho_i" alt="Equation 7"> is the ice density, <img src="https://latex.codecogs.com/svg.latex?\rho_w" alt="Equation 6"> the ocean density and <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 5"> the bedrock elevation (negative if below sea level). Grounding line is therefore located where <img src="https://latex.codecogs.com/svg.latex?H = H_f" alt="Equation 4">:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{rcll}H & > & H_f & \text{ice is grounded}\\H & = & H_f & \text{grounding line position}\\H & < & H_f & \text{ice is floating}\end{array}" alt="Equation 8"></div>

Each element of the mesh is either grounded or floating: flotation criterion is determined on each vertex of the triangle and if at least one vertex of the triangle is floating, the element is considered floating and no friction is applied. Otherwise, if the three vertices are grounded, the element is considered grounded. We refer to this type of grounding line migration as `'SoftMigration'`.

Sub-element parameterization can also be used to track the position of the grounding line within an element and improve accuracy of the results. The floating condition is a 2D field and the grounding line position is determined by the line where <img src="https://latex.codecogs.com/svg.latex?H = H_f" alt="Equation 9">, so it is located anywhere within an element. Some elements are therefore partly grounded and partly floating. Two different schemes of sub-element parameterizations have been implemented.

In the first case, the basal friction coefficient <img src="https://latex.codecogs.com/svg.latex?C" alt="Equation 10"> is reduced to match the amount of grounded ice in the element as proposed by [<a href="#references">*Pattyn2006*</a>] and [<a href="#references">*Gladstone2010*</a>] but for a 2D element:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
C_g = C \;\frac{A_g}{A}" alt="Equation 11"></div>
where <img src="https://latex.codecogs.com/svg.latex?C_g" alt="Equation 14"> is the applied basal friction coefficient for the element partially grounded, <img src="https://latex.codecogs.com/svg.latex?A_g" alt="Equation 13"> is the area of grounded ice of this element and <img src="https://latex.codecogs.com/svg.latex?A" alt="Equation 12"> is the total area of the element. We refer to this type of grounding line parameterization as `'SubelementMigration'`.

In the second case, the basal friction computed for partly grounded elements is integrated only on the part of the element that is grounded. This can be done simply by changing the integration area from the initial element to the grounded part of the element, over which the basal friction is unchanged. We refer to this type of grounding line parameterization as `'SubelementMigration2'`.

The sub-element parameterizations are described in details in [<a href="#references">*Seroussi2014a*</a>].

#### Contact mechanics
Grounding line migration can be advantageously based on contact mechanics when solving the stress balance equations with a full-Stokes models [<a href="#references">*Nowicki2008,Durand2009*</a>].

This capability is currently under development.

### Model parameters
The parameters relevant to the grounding line migration can be displayed by running:
````
>> md.groundingline
````


- `md.groundingline.migration`: type of grounding line migration:
  `'SoftMigration'`, `'AgressiveMigration'`, `'SubelementMigration'`, `'SubelementMigration2'`, or `'None'`

### Running a simulation
To compute grounding line migration, the transient solution must be used and all solutions except the grounding line migration must be deactivated (see 
 <a href="transient">transient solution</a>):
````
>> md = solve(md, 'Transient');
````
The first argument to `solve` is the model, the second is the nature of the simulation one wants to run.


## References
