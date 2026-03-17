---
title: Inversions
layout: default
parent: Advanced Features
grand_parent: Using ISSM
math: mathjax3
---

## Inversions
### Introduction
Inversions are used to constrain poorly known model parameters such as basal
friction. The method consists of finding a set of model inputs that minimizes
the cost function $${\mathcal J}$$ that measures the misfit between model and
observations. For example, inverse methods are used to infer the basal friction
$$k$$:

$$
\boldsymbol{\tau}_b = -k^2 N^r \|{\bf v}\|^{s-1} {\bf v}_b
$$

and/or the depth-averaged ice hardness, $$B$$, in Glen's flow law:

$$
\mu = \frac{B}{2\left( \dot{\varepsilon}_e^{1-\frac{1}{n}}\right) }
$$

This section explains how to solve inverse problems and how optimization parameters must be tuned.

### Cost functions
#### Absolute misfit
This is the classic way of calculating a misfit between a modeled and observed velocity field:

$$
{\mathcal J\left({\bf v}\right)}=\int_{S} \dfrac{1}{2}\left(\left(v_x-v_x^{\text{obs}}\right)^{2}+\left(v_y-v_y^{\text{obs}}\right)^{2}\right) dS
$$
where:

- v<sub>x</sub> is the x component of the glacier modeled velocity
- v<sub>y</sub> is the y component of the glacier modeled velocity
- v<sub>x</sub><sup>obs</sup> is the x component of the glacier observed velocity
- v<sub>y</sub><sup>obs</sup> is the y component of the glacier observed velocity

#### Relative misfit
The relative misfit is defined as follows:

$$
{\mathcal J\left({\bf v}\right)}=\int_{S} \dfrac{1}{2}\left(\dfrac{\left(v_x-v_x^{\text{obs}}\right)^{2}}{\left(v_x^{\text{obs}}+\varepsilon\right)^{2}}+\dfrac{\left(v_y-v_y^{\text{obs}}\right)^{2}}{\left(v_y^{\text{obs}}+\varepsilon\right)^{2}}\right) dS
$$

where:
- $$\varepsilon$$ is a minimum velocity used to avoid the observed velocity being equal to zero.

#### Logarithmic misfit

$$
{\mathcal J\left({\bf v}\right)}=\int_{S} \left(\text{log}\left(\dfrac{\|{\bf v}\|+\varepsilon}{\|{\bf v}^{\text{obs}}\|+\varepsilon}\right) \right)^2 dS
$$

where:
- v is the glacier modeled velocity magnitude
- v<sup>obs</sup> is the glacier observed velocity magnitude
- $$\varepsilon$$ is a minimum velocity used to avoid the observed velocity being equal to zero

#### Thickness misfit

$$
{\mathcal J\left(H\right)}=\int_{\Omega} \dfrac{1}{2}\left(H-H^{\text{obs}}\right)^{2}d\Omega
$$

where:
- H is the ice thickness
- H<sup>obs</sup> is the measured ice thickness

#### Drag gradient

$$
{\mathcal J\left(k\right)}=\int_{B} \gamma \dfrac{1}{2}\|\nabla k \|^{2}dB
$$

where:
- $$\gamma$$ is a Tikhonov regularization parameter

#### Thickness gradient

$$
{\mathcal J\left(k\right)}=\int_{\Omega} \gamma \dfrac{1}{2}\|\nabla H \|^{2}d\Omega
$$

where:
- $$\gamma$$ is a Tikhonov regularization parameter

### Model parameters
The parameters relevant to the stress balance solution can be displayed by typing:
````
>> md.inversion
````


- `md.inversion.iscontrol`: 1 if inversion is activated, 0 for a forward run (default)
- `md.inversion.incomplete_adjoint`: 1 linear viscosity, 0 non-linear viscosity
- `md.inversion.control_parameters`: parameters that are inferred (ex: `{'FrictionCoefficient'}` or `{'MaterialsRheologyBbar'}`
- `md.inversion.cost_functions`: list of individual cost functions that are summed to calculate the final cost function $$\mathcal J$$ to be minimized (ex: `[101, 501]`)
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
- `md.inversion.step_threshold`: decrease threshold for next step (default is 30)
- `md.inversion.gradient_scaling`: scaling factor on gradient direction during optimization, for each optimization step

$$
\alpha\in\left[0,\mbox{gradient\_scaling} \right]\hspace{3em}p^{\text{new}}=p^{\text{old}}-\alpha\;\nabla_p {\mathcal J}/\|\nabla_p {\mathcal J}\|
$$

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

$$
\begin{array}{lcl}
f(X) - f(X^*)  & < & \epsilon_{fatol} \\
 \left|f(X) - f(X^*\right|/\left|f(X^*)\right| & < & \epsilon_{frtol} \\
\|g(X)\| & < & \epsilon_{gatol} \\
\|g(X)\|/\left|f(X)\right|  & < & \epsilon_{grtol} \\
\|g(X)\|/\|g(X_0)\|  & < & \epsilon_{gttol} \\
\end{array}
$$

where:
- $$f(X)$$ is the cost function at $$X$$
- $$g(X)$$ is the cost function gradient with respect to $$X$$
- $$X^*$$ is the estimated "true" minimum
- $$X_0$$ is the initial guess

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
