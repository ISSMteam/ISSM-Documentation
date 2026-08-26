---
title: Damage
layout: default
parent: Capabilities
math: mathjax3
---

# Damage Evolution

## Physical basis
Damage is a state variable introduced to account for the influence of fractures on ice flow, while maintaining a continuum representation of the ice domain. For purely viscous ice flow modeling, damage is linked to flow enhancement&#8212;specifically the increase in strain rate&#8212;due to a fracture or a multitude of fractures in the ice.

### Inferring damage from remote sensing data
Remote sensing data can be used to calculate damage from the static stress balance in the ice. At present, this is only implemented in two dimensions for the SSA approximations to ice flow. Damage can be inferred in one of two ways:

- Inverting for damage directly
- Inverting for ice rigidity $$B$$ and then post-processing to determine damage (and optionally backstress)

Make sure that you are using the `matdamageice` class for `md.materials`. You can do that conversion using:
````
md.materials = matdamageice(md.materials);
````

### Inverting for damage directly
For the SSA equations, the damage-dependent ice viscosity ($$\mu$$) is:

$$
\mu=\frac{\left(1-D\right)B}{2\dot{\varepsilon}_e^{\frac{n-1}{n}}}
$$

where:

- $$D$$ is damage
- $$B$$ is the ice rigidity
- $$\dot{\varepsilon}_e$$ is the effective strain rate
- $$n$$ is the flow law exponent

Damage can be calculated using an inverse control method in the same manner as an inversion for the ice rigidity $$B$$. Simply specify the following field in `md.inversion`:

- `md.inversion.control_parameters = {'DamageDbar'}` (MATLAB)
- `md.inversion.control_parameters = ['DamageDbar']` (Python)

The remainder of the inversion procedure is described on the <a href="../advanced/inversions">'Advanced Features' &#8594; 'Inversions' page</a>.
This was the procedure followed by [<a href="#references">*Borstad2012*</a>] in determining the damage for the Larsen B ice shelf prior to its collapse (see the <a href="../../publications">'Publications' page</a> for a link to the paper).

### Post-processing to determine damage
Damage can also be calculated from the results of an inverse method solution for ice rigidity $$B$$. This procedure uses the analytical solution for the strain rate of a damaged ice shelf, derived by [<a href="#references">*Borstad2013*</a>]:

$$
\dot{\varepsilon}_{xx}=\theta\left[\frac{1/2\rho_i\left(1-\rho_i/\rho_w\right)gH-\sigma_b}{\left(1-D\right)B}\right]^n
$$

where:

- $$\dot{\varepsilon}_{xx}$$ is the longitudinal strain rate
- $$\theta$$ accounts for the lateral and shear strain rate terms
- $$\rho_i$$ and $$\rho_w$$ are the densities of ice and seawater, respectively
- $$g$$ is gravitational acceleration
- $$H$$ is the ice thickness
- $$\sigma_b$$ is the backstress resisting the flow
- $$D$$ is the damage
- $$B$$ is the ice rigidity
- $$n$$ is the flow law exponent

To determine damage, an inverse control method solution for ice rigidity $$B$$ is first carried out. The initial guess $$B_{\circ}$$ for the control method (contained in `md.materials.rheology_B`) is assumed to be based on a temperature parameterization, given a reasonable estimate of the depth-averaged temperature of the ice. Damage is then calculated in locations where the inverse solution for $$B$$ is less than the ice rigidity appropriate for the local temperature of the ice. A post-processing function carries out this calculation directly:
````
>> D=damagefrominversion(md);
````

Additionally, the scalar backstress can be calculated from the inversion results:
````
>> backstress = backstressfrominversion(md);
````

This procedure for calculating damage and backstress was used in [<a href="#references">*Borstad2013*</a>] for the Larsen C ice shelf (see the <a href="../../publications">'Publications' page</a> for a link to the paper).

## Damage Evolution (Under Construction)
A differential equation describing damage evolution in time&#8212;both the advection of damage with ice flow as well as the evolution of damage as the stress state changes&#8212;is being implemented in ISSM. Check back for updates.

# References
- C. P. Borstad, A. Khazendar, E. Larour, M. Morlighem, E. Rignot, M. P.
   Schodlok, and H. Seroussi.
 A damage mechanics assessment of the Larsen B ice shelf prior to
   collapse: Toward a physically-based calving law.
 Geophys. Res. Lett., 39(L18502):1-5, 2012.

- C. P. Borstad, E. Rignot, J. Mouginot, and M. P. Schodlok.
 Creep deformation and buttressing capacity of damaged ice shelves:
   theory and application to Larsen C ice shelf.
 Cryosphere, 7:1931-1947, 2013.
