---
title: Damage Evolution
layout: default
parent: Capabilities
---

## Damage Evolution

### Physical basis
Damage is a state variable introduced to account for the influence of fractures on ice flow, while maintaining a continuum representation of the ice domain. For purely viscous ice flow modeling, damage is linked to flow enhancement&#8212;specifically the increase in strain rate&#8212;due to a fracture or a multitude of fractures in the ice.

#### Inferring damage from remote sensing data
Remote sensing data can be used to calculate damage from the static stress balance in the ice. At present, this is only implemented in two dimensions for the SSA approximations to ice flow. Damage can be inferred in one of two ways:

- Inverting for damage directly
- Inverting for ice rigidity <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 1"> and then post-processing to determine damage (and optionally backstress)

Make sure that you are using the `matdamageice` class for `md.materials`. You can do that conversion using:
````
md.materials = matdamageice(md.materials);
````

#### Inverting for damage directly
For the SSA equations, the damage-dependent ice viscosity (<img src="https://latex.codecogs.com/svg.latex?\mu" alt="Equation 2">) is:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mu=\frac{\left(1-D\right)B}{2\dot{\varepsilon}_e^{\frac{n-1}{n}}}" alt="Equation 3"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?D" alt="Equation 4"> is damage
- <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 5"> is the ice rigidity
- <img src="https://latex.codecogs.com/svg.latex?\dot{\varepsilon}_e" alt="Equation 6"> is the effective strain rate
- <img src="https://latex.codecogs.com/svg.latex?n" alt="Equation 7"> is the flow law exponent

Damage can be calculated using an inverse control method in the same manner as an inversion for the ice rigidity <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 8">. Simply specify the following field in `md.inversion`:

- `md.inversion.control_parameters = {'DamageDbar'}` (MATLAB)
- `md.inversion.control_parameters = ['DamageDbar']` (Python)

The remainder of the inversion procedure is described on the 
 on the <a href="../advanced/inversions">'Advanced Features' &#8594; 'Inversions' page</a>.
This was the procedure followed by [<a href="#references">*Borstad2012*</a>] in determining the damage for the Larsen B ice shelf prior to its collapse (see the 
 <a href="../../publications">'Publications' page</a>
for a link to the paper).

#### Post-processing to determine damage
Damage can also be calculated from the results of an inverse method solution for ice rigidity <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 9">. This procedure uses the analytical solution for the strain rate of a damaged ice shelf, derived by [<a href="#references">*Borstad2013*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\dot{\varepsilon}_{xx}=\theta\left[\frac{1/2\rho_i\left(1-\rho_i/\rho_w\right)gH-\sigma_b}{\left(1-D\right)B}\right]^n" alt="Equation 10"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\dot{\varepsilon}_{xx}" alt="Equation 11"> is the longitudinal strain rate
- <img src="https://latex.codecogs.com/svg.latex?\theta" alt="Equation 12"> accounts for the lateral and shear strain rate terms
- <img src="https://latex.codecogs.com/svg.latex?\rho_i" alt="Equation 14"> and <img src="https://latex.codecogs.com/svg.latex?\rho_w" alt="Equation 13"> are the densities of ice and seawater, respectively
- <img src="https://latex.codecogs.com/svg.latex?g" alt="Equation 15"> is gravitational acceleration
- <img src="https://latex.codecogs.com/svg.latex?H" alt="Equation 16"> is the ice thickness
- <img src="https://latex.codecogs.com/svg.latex?\sigma_b" alt="Equation 17"> is the backstress resisting the flow
- <img src="https://latex.codecogs.com/svg.latex?D" alt="Equation 18"> is the damage
- <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 19"> is the ice rigidity
- <img src="https://latex.codecogs.com/svg.latex?n" alt="Equation 20"> is the flow law exponent

To determine damage, an inverse control method solution for ice rigidity <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 22"> is first carried out. The initial guess <img src="https://latex.codecogs.com/svg.latex?B_{\circ}" alt="Equation 21"> for the control method (contained in `md.materials.rheology_B`) is assumed to be based on a temperature parameterization, given a reasonable estimate of the depth-averaged temperature of the ice. Damage is then calculated in locations where the inverse solution for <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 23"> is less than the ice rigidity appropriate for the local temperature of the ice. A post-processing function carries out this calculation directly:
````
>> D=damagefrominversion(md);
````

Additionally, the scalar backstress can be calculated from the inversion results:
````
>> backstress = backstressfrominversion(md);
````

This procedure for calculating damage and backstress was used in [<a href="#references">*Borstad2013*</a>] for the Larsen C ice shelf (see the 
 <a href="../../publications">'Publications' page</a>
for a link to the paper).

### Damage Evolution (Under Construction)
A differential equation describing damage evolution in time&#8212;both the advection of damage with ice flow as well as the evolution of damage as the stress state changes&#8212;is being implemented in ISSM. Check back for updates.


## References
