---
title: Inversions
layout: default
parent: Advanced Features
grand_parent: Using ISSM
---

## Inversions
### Introduction
Inversions are used to constrain poorly known model parameters such as basal friction. The method consists of finding a set of model inputs that minimizes the cost function <img src="https://latex.codecogs.com/svg.latex?{\mathcal J}" alt="Equation 2"> that measures the misfit between model and observations. For example, inverse methods are used to infer the basal friction <img src="https://latex.codecogs.com/svg.latex?k" alt="Equation 1">:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\boldsymbol{\tau}_b = -k^2 N^r \|{\bf v}\|^{s-1} {\bf v}_b" alt="Equation 3"></div>
and/or the depth-averaged ice hardness, <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 4">, in Glen's flow law:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mu = \frac{B}{2\left( \dot{\varepsilon}_e^{1-\frac{1}{n}}\right) }\\" alt="Equation 5"></div>

This section explains how to launch an inverse method and how optimization parameters must be tuned.

### Cost functions
#### Absolute misfit
This is the classic way of calculating a misfit between a modeled and observed velocity field:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
{\mathcal J\left({\bf v}\right)}=\int_{S} \dfrac{1}{2}\left(\left(v_x-v_x^{\text{obs}}\right)^{2}+\left(v_y-v_y^{\text{obs}}\right)^{2}\right) dS" alt="Equation 6"></div>
where:

- v<sub>x</sub> is the x component of the glacier modeled velocity
- v<sub>y</sub> is the y component of the glacier modeled velocity
- v<sub>x</sub><a href="#footnotes" target="_top"><sup>obs</sup></a> is the x component of the glacier observed velocity
- v<sub>y</sub><a href="#footnotes" target="_top"><sup>obs</sup></a> is the y component of the glacier observed velocity

#### Relative misfit
The relative misfit is defined as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
{\mathcal J\left({\bf v}\right)}=\int_{S} \dfrac{1}{2}\left(\dfrac{\left(v_x-v_x^{\text{obs}}\right)^{2}}{\left(v_x^{\text{obs}}+\varepsilon\right)^{2}}+\dfrac{\left(v_y-v_y^{\text{obs}}\right)^{2}}{\left(v_y^{\text{obs}}+\varepsilon\right)^{2}}\right) dS" alt="Equation 7"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\varepsilon" alt="Equation 8"> is a minimum velocity used to avoid the observed velocity being equal to zero.

#### Logarithmic misfit

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
{\mathcal J\left({\bf v}\right)}=\int_{S} \left(\text{log}\left(\dfrac{\|{\bf v}\|+\varepsilon}{\|{\bf v}^{\text{obs}}\|+\varepsilon}\right) \right)^2 dS" alt="Equation 9"></div>
where:

- v is the glacier modeled velocity magnitude
- v<a href="#footnotes" target="_top"><sup>obs</sup></a> is the glacier observed velocity magnitude
- <img src="https://latex.codecogs.com/svg.latex?\varepsilon" alt="Equation 10"> is a minimum velocity used to avoid the observed velocity being equal to zero

#### Thickness misfit

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
{\mathcal J\left(H\right)}=\int_{\Omega} \dfrac{1}{2}\left(H-H^{\text{obs}}\right)^{2}d\Omega" alt="Equation 11"></div>
where:

- H is the ice thickness
- H<a href="#footnotes" target="_top"><sup>obs</sup></a> is the measured ice thickness

#### Drag gradient

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
{\mathcal J\left(k\right)}=\int_{B} \gamma \dfrac{1}{2}\|\nabla k \|^{2}dB" alt="Equation 12"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\gamma" alt="Equation 13"> is a Tikhonov regularization parameter

#### Thickness gradient

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
{\mathcal J\left(k\right)}=\int_{\Omega} \gamma \dfrac{1}{2}\|\nabla H \|^{2}d\Omega" alt="Equation 14"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\gamma" alt="Equation 15"> is a Tikhonov regularization parameter

### Model parameters
The parameters relevant to the stress balance solution can be displayed by typing:
````
>> md.inversion
````


- `md.inversion.iscontrol`: 1 if inversion is activated, 0 for a forward run (default)
- `md.inversion.incomplete_adjoint`: 1 linear viscosity, 0 non-linear viscosity
- `md.inversion.control_parameters`: parameters that are inferred (ex: `{'FrictionCoefficient'}` or `{'MaterialsRheologyBbar'}`
- `md.inversion.cost_functions`: list of individual cost functions that are summed to calculate the final cost function <img src="https://latex.codecogs.com/svg.latex?\mathcal J" alt="Equation 16"> to be minimized (ex: `[101, 501]`)
- `md.inversion.cost_functions_coefficients`: weight of each individual cost function previously defined for each vertex (more/no weight can be put on certain regions)
- `md.inversion.min_parameters`: minimum value for the inferred parameter
- `md.inversion.max_parameters`: maximum value for the inferred parameter
- `md.inversion.vx_obs`: x component of the surface velocity
- `md.inversion.vy_obs`: y component of the surface velocity
- `md.inversion.vel_obs`: surface velocity magnitude
- `md.inversion.thickness_obs`: measured ice thickness

### Minimization algorithms
Depending on the class of `md.inversion`, several optimization algorithm are available:

- Brent search algorithm (`md.inversion = inversion()`, the default)
- Toolkit for Advanced Optimization (TAO) (`md.inversion = taoinversion()`)
- M1QN3 algorithm (`md.inversion = m1qn3inversion()`)
Each minimizer has its own optimization parameters described below.

#### Brent search minimizers

- `md.inversion.nsteps`: number of optimization searches (gradient evaluations)
- `md.inversion.maxiter_per_step`: maximum iterations during each optimization step
- `md.inversion.step_threshold`: decrease threshold for next step (default is 30&#37;)
- `md.inversion.gradient_scaling`: scaling factor on gradient direction during optimization, for each optimization step

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\alpha\in\left[0,\text{\ttfamily gradient\_scaling} \right]\hspace{3em}p^{\text{new}}=p^{\text{old}}-\alpha\;\nabla_p {\mathcal J}/\|\nabla_p {\mathcal J}\|" alt="Equation 17"></div>

#### Toolkit for Advanced Optimization (TAO)
ISSM has an interface to the Toolkit for Advanced Optimization (TAO) [<a href="#references">*Munson2012*</a>]. Here is a list of the relevant parameters:

- `md.inversion.maxsteps`: maximum number of iterations (gradient computation)
- `md.inversion.maxiter`: maximum number of Function evaluation (forward run)
- `md.inversion.algorithm`: inimization algorithm. ex: `'tao_blmvm'`, `'tao_cg'`, `'tao_lmvm'`
- `md.inversion.fatol`: cost function absolute convergence criterion (defined below)
- `md.inversion.frtol`: cost function relative convergence criterion (defined below)
- `md.inversion.gatol`: gradient absolute convergence criterion (defined below)
- `md.inversion.grtol`: gradient relative convergence criterion (defined below)
- `md.inversion.gttol`: gradient relative convergence criterion 2 (defined below)
with the following convergence criteria:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{lcl}f(X) - f(X^*)                                 & < & \epsilon_{fatol} \\\left|f(X) - f(X^*\right|/\left|f(X^*)\right| & < & \epsilon_{frtol} \\\|g(X)\|                                      & < & \epsilon_{gatol} \\\|g(X)\|/\left|f(X)\right|                    & < & \epsilon_{grtol} \\\|g(X)\|/\|g(X_0)\|                           & < & \epsilon_{gttol} \\\end{array}" alt="Equation 18"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?f(X)" alt="Equation 20"> is the cost function at <img src="https://latex.codecogs.com/svg.latex?X" alt="Equation 19">
- <img src="https://latex.codecogs.com/svg.latex?g(X)" alt="Equation 22"> is the cost function gradient with respect to <img src="https://latex.codecogs.com/svg.latex?X" alt="Equation 21">
- <img src="https://latex.codecogs.com/svg.latex?X^*" alt="Equation 23"> is the estimated "true" minimum
- <img src="https://latex.codecogs.com/svg.latex?X_0" alt="Equation 24"> is the initial guess

#### M1QN3
ISSM has an interface to M1QN3 (Inria) [<a href="#references">*Gilbert1989*</a>]. This interface was largely based on [<a href="#references">*Nardi2009*</a>]. Here is a list of the relevant parameters:

- `md.inversion.maxsteps`: maximum number of iterations (gradient computation)
- `md.inversion.maxiter`: maximum number of Function evaluation (forward run)
- `md.inversion.dxmin`:  convergence criterion: two points less than dxmin from each other (sup-norm) are considered identical
- `md.inversion.gttol`: gradient relative convergence criterion 2 (defined below)

### Running an inversion
To launch an inversion, run a stress balance solution with `md.inversion.iscontrol = 1`:
````
>> md = solve(md, 'Stressbalance');
````


## References
