---
title: Basal Friction
layout: default
parent: Parameterization
math: mathjax3
---

## Basal Friction
### Introduction
All friction laws in ISSM are implemented as:

$$
\boldsymbol{\tau}_b = -f\left({\bf v}_b,N\right) \frac{ {\bf v}_b}{\left|{\bf v}_b\right|}
$$
where $$N$$ is the effective pressure, $$\boldsymbol{\tau}_b$$ and $${\bf v}_b$$ are the basal stress and
sliding velocities respectively. The friction laws described below describe the norm of the
basal stress for simplicity, but all implementations are such that they oppose motion (i.e., the
direction of the basal stress is the opposite of $${\bf v}_b$$).

Most friction laws use a switch to define how the effective pressure, $$N = p_{ice} - p_{water}$$ is
calculated (`md.friction.coupling`):

- 0: $$p_{water} = -\rho_w g b$$ uniform sheet (negative water pressure OK, default)
- 1: $$p_{water} = 0$$, so that $$N=p_{ice}=\rho_i g H$$ is equal to the overburden pressure
- 2: $$p_{water} = \max\left(0,-\rho_w g b\right)$$. Same as 0, but $$p_{water}\ge 0$$
- 3: Use effective pressure prescribed in `md.friction.effective_pressure`
- 4: Use effective pressure dynamically calculated by the hydrology model (i.e., fully
  coupled)

### Budd friction law (friction)
The default friction law is defined as [<a href="#references">*Paterson1994*</a>] (p. 151):

$$
v_b \propto N^{-q} {\tau}_b^p
$$
where:

- $$v_b$$ is the basal velocity magnitude
- $$\tau_b$$ is the basal stress magnitude
- $$N$$ is the effective pressure
- $$p$$ and $$q$$ are friction law exponents

In ISSM, this friction law is implemented in terms of basal stress, following [<a href="#references">*Budd1979*</a>]:

$$
\tau_b = C_b^2 N^r {v}_b^s
$$
where:

- $$C_b$$ is the friction coefficient
- $$r$$ and $$s$$ are friction law exponents:

$$
r=q/p \hspace{4em} s=1/p
$$

This friction law can be selected as follows:
````
>> md.friction = friction();
````

The following fields need to be specified:

- `md.friction.coefficient`: friction coefficient
- `md.friction.p`: p exponent
- `md.friction.q`: q exponent

### Weertman friction law (weertmanfriction)
The Weertman friction [<a href="#references">*Weertman1957*</a>] law reads:

$$
v_b  = C_w {\tau}_b^m
$$

- $$C_w$$ is a friction coefficient (variable in space)
- $$m$$ is a friction law exponent

In ISSM, this friction law is implemented in terms of basal stress:

$$
\boldsymbol{\tau}_b = C_w^{-1/m} \|{\bf v}_b\|^{1/m-1} {\bf v}_b
$$

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

$$
\tau_b = \min\left(C N ub , C_c^2 N \right)
$$

### Regularized Coulomb-limited sliding 1 (frictionregcoulomb)
Sliding law from [<a href="#references">*Joughin2019*</a>]:

$$
\tau_b = \frac{C u_b^{1/m}\alpha^2 N}{\left(\frac{u_b}{u_0} + 1\right)^{1/m}}
$$

### Coulomb-limited sliding 2 (frictioncoulomb2)
Coulomb-limited sliding law used in MISMIP+ [<a href="#references">*Cornford2020*</a>]:

$$
\tau_b = \frac{C u_b^{m}\alpha^2 N}{\left(C^{1/m}u_b + (\alpha^2N)^{1/m}\right)^{m}},
$$
where $$\alpha^2 = 0.5$$. Note that this friction law is exactly the same as `frictionschoof` described below, with $$C_{max} = 0.5$$.

### Regularized Coulomb-limited sliding 2 (frictionregcoulomb2)
Sliding law from [<a href="#references">*Helanow2021*</a>]:

$$
\tau_b = \frac{C\, N\, u_b^{1/m}}{\left(u_b + (K\,N)^{m}\right)^{1/m}}
$$

### Friction Tsai (frictiontsai)
From [<a href="#references">*Tsai2015*</a>]:

$$
\tau_b = \min\left(C ub^{m} , f N \right)
$$

### Friction Schoof (frictionschoof)
From [<a href="#references">*Schoof2005,Gagliardini2007*</a>] (note that we use $$C_s^2$$ to make sure it is a positive number):

$$
\tau_b = \frac{C_s^2 v_b^{m}}{\left(1 + \left(\frac{C_s^2}{C_{max}N}\right)^{1/m} v_b\right)^{m}},
$$

### Friction PISM (frictionpism)
Under construction

### Thin water layer friction law (frictionwaterlayer)
The thin water layer friction law is similar to the default friction law except that the effective pressure includes a specified layer of water at the bed:

$$
N= g \left( \rho_i H + \rho_w \left( b - w\right) \right)
$$
when the bedrock is below sea level, and:

$$
N= g \left( \rho_i H - \rho_w w \right)
$$
when the bedrock is above sea level, with:

- $$N$$ the effective pressure
- $$\rho_i$$ the ice density
- $$\rho_w$$ the water density
- $$H$$ and $$b$$ ice thickness and bed elevation
- $$w$$ the water thickness at the ice base

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
- W. F. Budd, P. L. Keage, and N. A. Blundy.
 Empirical studies of ice sliding.
 J. Glaciol., 23:157-170, 1979.

- S. L. Cornford, H. Seroussi, X. S. Asay-Davis, G. H. Gudmundsson, R. Arthern,
   C. Borstad, J. Christmann, T. Dias dos Santos, J. Feldmann, D. Goldberg,
   M. J. Hoffman, A. Humbert, T. Kleiner, G. Leguy, W. H. Lipscomb, N. Merino,
   G. Durand, M. Morlighem, D. Pollard, M. Ruckamp, C. R. Williams, and H. Yu.
 Results of the third Marine Ice Sheet Model Intercomparison Project
   (MISMIP+).
 Cryosphere, 14(7):2283-2301, 2020.

- O. Gagliardini, D. Cohen, P. Raback, and T. Zwinger.
 Finite-element modeling of subglacial cavities and related friction
   law.
 J. Geophys. Res. - Earth Surface, 112(F2):1-11, MAY 31 2007.

- Christian Helanow, Neal R. Iverson, Jacob B. Woodard, and Lucas K. Zoet.
 A slip law for hard-bedded glaciers derived from observed bed
   topography.
 Sci. Adv., 7(20):eabe7798, 2021.

- I. Joughin, B. E. Smith, and C. G. Schoof.
 Regularized Coulomb friction laws for ice sheet sliding: Application
   to Pine Island Glacier, Antarctica.
 Geophys. Res. Lett., 46, 2019.

- W. S. B. Paterson.
 The Physics of Glaciers.
 Pergamon Press, Oxford, London, New York, 3rd edition, 1994.

- C. Schoof.
 The effect of cavitation on glacier sliding.
 Proc. R. Soc. A, 461(2055):609-627, MAR 8 2005.

- V. C. Tsai, A. L. Stewart, and A. F. Thompson.
 Marine ice-sheet profiles and stability under Coulomb basal
   conditions.
 J. Glaciol., 61(226):205-215, 2015.

- J. Weertman.
 On the sliding of glaciers.
 J. Glaciol., 3:33-38, March 1957.
