---
title: Basal Friction
layout: default
parent: Parameterization
---

## Basal Friction
### Introduction
All friction laws in ISSM are implemented as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\boldsymbol{\tau}_b = -f\left({\bf v}_b,N\right) \frac{ {\bf v}_b}{\left|{\bf v}_b\right|}" alt="Equation 1"></div>
where <img src="https://latex.codecogs.com/svg.latex?N" alt="Equation 4"> is the effective pressure, <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\tau}_b" alt="Equation 3"> and <img src="https://latex.codecogs.com/svg.latex?{\bf v}_b" alt="Equation 2"> are the basal stress and
sliding velocities respectively. The friction laws described below are describing the norm of the
basal stress for simplicity but all implementations are such that the oppose motion (i.e. the
direction of the basal stress is the opposite of <img src="https://latex.codecogs.com/svg.latex?{\bf v}_b" alt="Equation 5">).

Most friction laws use a switch to define how the effective pressure, <img src="https://latex.codecogs.com/svg.latex?N = p_{ice} - p_{water}" alt="Equation 6"> is
calculated: `md.friction.coupling`:

- 0: <img src="https://latex.codecogs.com/svg.latex?p_{water} = -\rho_w g b" alt="Equation 7">  uniform sheet (negative water pressure ok, default)
- 1: <img src="https://latex.codecogs.com/svg.latex?p_{water} = 0" alt="Equation 9">, so that <img src="https://latex.codecogs.com/svg.latex?N=p_{ice}=\rho_i g H" alt="Equation 8"> is equal to the overburden pressure
- 2: <img src="https://latex.codecogs.com/svg.latex?p_{water} = \max\left(0,-\rho_w g b\right)" alt="Equation 11">. Same as 0, but <img src="https://latex.codecogs.com/svg.latex?p_{water}\ge 0" alt="Equation 10">
- 3: Use effective pressure prescrived in `md.friction.effective_pressure`
- 4: Use effective pressure dynamically calculated by the hydrology model (i.e., fully
  coupled)

### Budd Friction law (friction)
The default friction law is defined as [<a href="#references">*Paterson1994*</a>] (p 151):

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
v_b \propto N^{-q} {\tau}_b^p" alt="Equation 12"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?v_b" alt="Equation 13"> is the basal velocity magnitude
- <img src="https://latex.codecogs.com/svg.latex?\tau_b" alt="Equation 14"> is the basal stress magnitude
- <img src="https://latex.codecogs.com/svg.latex?N" alt="Equation 15"> is the effective pressure
- <img src="https://latex.codecogs.com/svg.latex?p" alt="Equation 17"> and <img src="https://latex.codecogs.com/svg.latex?q" alt="Equation 16"> are friction law exponents

In ISSM, this friction law is implemented in terms of basal stress, following [<a href="#references">*Budd1979*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\tau_b = C_b^2 N^r {v}_b^s" alt="Equation 18"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?C_b" alt="Equation 19"> friction coefficient
- <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 21"> and <img src="https://latex.codecogs.com/svg.latex?s" alt="Equation 20"> are friction law exponents:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
r=q/p \hspace{4em} s=1/p" alt="Equation 22"></div>

This friction law can be selected as follows:
````
>> md.friction = friction();
````

The following fields need to be specified:

- `md.friction.coefficient`: friction coefficient
- `md.friction.p`: p exponent
- `md.friction.q`: q exponent

### Weertman Friction law (weertmanfriction)
The Weertman friction [<a href="#references">*Weertman1957*</a>] law reads:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
v_b  = C_w {\tau}_b^m" alt="Equation 23"></div>

- <img src="https://latex.codecogs.com/svg.latex?C_w" alt="Equation 24"> is a friction coefficient (variable in space)
- <img src="https://latex.codecogs.com/svg.latex?m" alt="Equation 25"> is a friction law exponent

In ISSM, this friction law is implemented in terms of basal stress:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\boldsymbol{\tau}_b = C_w^{-1/m} \|{\bf v}_b\|^{1/m-1} {\bf v}_b" alt="Equation 26"></div>

This friction law can be selected as follows:
````
>> md.friction = frictionweertman();
````

One can display the following fields by running:
````
>> md.friction
````

- `md.friction.C`: friction coefficient
- `md.friction.m`: m exponent

### Coulomb-limited sliding 1 (frictioncoulomb)

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\tau_b = \min\left(C N ub , C_c^2 N \right)" alt="Equation 27"></div>

### Regularized Coulomb-limited sliding 1 (frictionregcoulomb)
Sliding law from [<a href="#references">*Joughin2019*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\tau_b = \frac{C u_b^{1/m}\alpha^2 N}{\left(\frac{u_b}{u_0} + 1\right)^{1/m}}" alt="Equation 28"></div>

### Coulomb-limited sliding 2 (frictioncoulomb2)
Coulomb-limited sliding law used in MISMIP+ [<a href="#references">*Cornford2020*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\tau_b = \frac{C u_b^{m}\alpha^2 N}{\left(C^{1/m}u_b + (\alpha^2N)^{1/m}\right)^{m}}," alt="Equation 29"></div>
where <img src="https://latex.codecogs.com/svg.latex?\alpha^2 = 0.5" alt="Equation 30">. Note that this friction law is exactly the same as `frictionschoof` described below, with <img src="https://latex.codecogs.com/svg.latex?C_{max} = 0.5" alt="Equation 31">.

### Regularized Coulomb-limited sliding 2 (frictionregcoulomb2)
Sliding law from [<a href="#references">*Helanow2021*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\tau_b = \frac{C\, N\, u_b^{1/m}}{\left(u_b + (K\,N)^{m}\right)^{1/m}}" alt="Equation 32"></div>

### Friction Tsai (frictiontsai)
from [<a href="#references">*Tsai2015*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\tau_b = \min\left(C ub^{m} , f N \right)" alt="Equation 33"></div>

### Friction Schoof (frictionschoof)
from [<a href="#references">*Schoof2005,Gagliardini2007*</a>] (note that we use <img src="https://latex.codecogs.com/svg.latex?C_s^2" alt="Equation 34"> to make sure it is a positive number):

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\tau_b = \frac{C_s^2 v_b^{m}}{\left(1 + \left(\frac{C_s^2}{C_{max}N}\right)^{1/m} v_b\right)^{m}}," alt="Equation 35"></div>

### Friction PISM (frictionpism)
Under construction

### Thin water layer friction law (frictionwaterlayer)
The thin water layer friction law is similar to the default friction law except that the effective pressure includes a specified layer of water at the bed:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
N= g \left( \rho_i H + \rho_w \left( b - w\right) \right)" alt="Equation 36"></div>
when the bedrock is below sea level, and:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
N= g \left( \rho_i H - \rho_w w \right)" alt="Equation 37"></div>
when the bedrock is above sea level, with:

- <img src="https://latex.codecogs.com/svg.latex?N" alt="Equation 38"> the effective pressure
- <img src="https://latex.codecogs.com/svg.latex?\rho_i" alt="Equation 39"> the ice density
- <img src="https://latex.codecogs.com/svg.latex?\rho_w" alt="Equation 40"> the water density
- <img src="https://latex.codecogs.com/svg.latex?H" alt="Equation 42"> and <img src="https://latex.codecogs.com/svg.latex?b" alt="Equation 41"> ice thickness and bed elevation
- <img src="https://latex.codecogs.com/svg.latex?w" alt="Equation 43"> the water thickness at the ice base

This friction law can be selected as follows:
````
>> md.friction = frictionwaterlayer();
````

One can display all these fields by running:
````
>> md.friction
````

- `md.friction.coefficient`: friction coefficient
- `md.friction.p`: p exponent
- `md.friction.q`: q exponent
- `md.friction.water_layer`: thin water layer thickness (meters)


## References
