---
title: Empirical Scalar Tertiary Anisotropy Regime (ESTAR)
layout: default
parent: Parameterization
has_children: false
has_toc: false
---

## Empirical Scalar Tertiary Anisotropy Regime (ESTAR)
### Description
The ESTAR (Empirical Scalar Tertiary Anisotropy Regime) flow relation [<a href="#references">*Budd2013,Graham2018*</a>] is a generalized constitutive relation for polycrystalline ice in steady-state (tertiary) flow. It is a scalar power law formulation based on tertiary creep rates from laboratory experiments of ice deformation under a variety of simple shear and compression stresses. While mathematically isotropic, the ESTAR flow relation describes the deformation of ice with a flow-compatible induced anisotropy &#8212; i.e. ice that has a developed anisotropic fabric that is a function of the underlying stress regime (i.e. the relative proportion of simple shear and compression stresses). The origins of ESTAR, including the laboratory experiments than contributed to its development, its derivation, and underlying assumptions are discussed in [<a href="#references">*Budd2013*</a>] and [<a href="#references">*Graham2018*</a>].

#### Equations
Ice is treated as a purely viscous incompressible material [<a href="#references">*Cuffey2010*</a>], such that its material constitutive relation can be written:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
{\boldsymbol\sigma'} = 2 \mu \dot{ {\boldsymbol\varepsilon}}," alt="Equation 1"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?{\boldsymbol\sigma'}" alt="Equation 2"> is the deviatoric stress tensor (Pa)
- <img src="https://latex.codecogs.com/svg.latex?\mu" alt="Equation 3"> is the ice effective viscosity (Pa~s)
- <img src="https://latex.codecogs.com/svg.latex?\dot{ {\boldsymbol\varepsilon}}" alt="Equation 4"> is the strain rate tensor (s<a href="#footnotes" target="_top"><sup>-1</sup></a>)

The ESTAR flow relation viscosity <img src="https://latex.codecogs.com/svg.latex?\mu" alt="Equation 5"> can be written:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mu = \frac{B}{2 E(\lambda_S)^{\frac{1}{3}}\dot{\varepsilon}_e^{\frac{2}{3}}},\label{eq:estar}" alt="Equation 6"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 10"> is the ice hardness or rigidity. Note that <img src="https://latex.codecogs.com/svg.latex?B=A(T')^{-1/3}" alt="Equation 9">, where <img src="https://latex.codecogs.com/svg.latex?A(T')" alt="Equation 8"> is the temperature-dependent flow rate parameter and <img src="https://latex.codecogs.com/svg.latex?T'" alt="Equation 7"> is the temperature relative to the pressure dependent melting point of ice.
- <img src="https://latex.codecogs.com/svg.latex?E(\lambda_S)" alt="Equation 12"> is an enhancement factor that characterizes the relative proportion of simple shear and compression stresses via the shear fraction <img src="https://latex.codecogs.com/svg.latex?\lambda_S" alt="Equation 11">

The most notable difference between the Glen and ESTAR flow relations is realized in the form of the enhancement factor, which for the ESTAR flow relation is <img src="https://latex.codecogs.com/svg.latex?E(\lambda_S)" alt="Equation 13">, given by:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
E(\lambda_S) = E_C + (E_S - E_C) \lambda_S^2." alt="Equation 14"></div>
Here, <img src="https://latex.codecogs.com/svg.latex?E_C" alt="Equation 20"> and <img src="https://latex.codecogs.com/svg.latex?E_S" alt="Equation 19"> are the enhancement factors above the minimum (secondary) deformation rate for isotropic ice under compression alone or simple shear alone, respectively. Laboratory evidence suggests that a suitable ratio of <img src="https://latex.codecogs.com/svg.latex?E_C/E_S" alt="Equation 18"> is <img src="https://latex.codecogs.com/svg.latex?3/8" alt="Equation 17"> [<a href="#references">*Treverrow2012*</a>]. The shear fraction <img src="https://latex.codecogs.com/svg.latex?\lambda_S" alt="Equation 16"> characterizes the contribution of simple shear to the effective stress. The collinear nature of the ESTAR flow relation allows <img src="https://latex.codecogs.com/svg.latex?\lambda_S" alt="Equation 15"> to be expressed equivalently in terms of stresses and strain rates. The strain rate formulation is more convenient for Stokes flow modeling, and can be written:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\lambda_S=\frac{\dot{\varepsilon}'}{\dot{\varepsilon}_e}," alt="Equation 21"></div>
where <img src="https://latex.codecogs.com/svg.latex?\dot{\varepsilon}'" alt="Equation 22"> (s<a href="#footnotes" target="_top"><sup>-1</sup></a>) is the magnitude of the shear strain rate on the local non-rotating shear plane. The local non-rotating shear plane contains the velocity vector and the vorticity vector associated solely with deformation, rather than local rigid body rotation. See [<a href="#references">*Graham2018*</a>] for details. 

For comparison with the ESTAR viscosity, the Glen flow relation viscosity <img src="https://latex.codecogs.com/svg.latex?\mu" alt="Equation 23"> can be written:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mu = \frac{B}{2 E^{\frac{1}{n}}\dot{\varepsilon}_e^{\frac{n-1}{n}}},\label{eq:glen}" alt="Equation 24"></div>
where <img src="https://latex.codecogs.com/svg.latex?E" alt="Equation 25"> is a constant enhancement factor. For the standard Glen flow relation (the `matice` class in ISSM), <img src="https://latex.codecogs.com/svg.latex?E=1" alt="Equation 27">; to specify values of <img src="https://latex.codecogs.com/svg.latex?E&#62;1" alt="Equation 26">, the `matenhancedice` class can be used.

### Model parameters
The parameters relevant to the ESTAR flow relation (the `matestar` class in ISSM) can be displayed by running:
````
>> md.materials
````


- `md.materials.rheology_B`: temperature-dependent flow relation parameter (`NaN` means no constraint)
- `md.materials.rheology_Ec`: compression enhancement factor
- `md.materials.rheology_Es`: simple shear enhancement factor
- `md.materials.rheology_law`: law for the temperature dependence of the rheology (`None` means no temperature dependence; default is `Paterson`)

### Using the ESTAR flow relation
The ESTAR flow relation may be specified by:
````
>> md.materials = matestar();
````
In this case, values for <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 30">, <img src="https://latex.codecogs.com/svg.latex?E_C" alt="Equation 29">, and <img src="https://latex.codecogs.com/svg.latex?E_S" alt="Equation 28"> should be explicitly set.

Alternatively, the ESTAR flow relation may be specified from conversion of a Glen type relation by the following:
````
>> md.materials = matestar(md.materials);
````
The argument is the materials class of the model. This will set the same value for <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 33"> as for the Glen flow model default, with <img src="https://latex.codecogs.com/svg.latex?E_S=1" alt="Equation 32"> and <img src="https://latex.codecogs.com/svg.latex?E_C=1" alt="Equation 31">.

### Using the enhanced Glen flow relation
It is possible to use an alternative Glen flow relation with an explicit enhancement factor, in a similar way to the ESTAR class, as follows:
````
>> md.materials = matenhancedice();
````
in which <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 35"> and <img src="https://latex.codecogs.com/svg.latex?E" alt="Equation 34"> should be explicitly set, or as:
````
>> md.materials = matenhancedice(md.materials);
````
in which <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 38"> is inherited from the default Glen flow model and <img src="https://latex.codecogs.com/svg.latex?E" alt="Equation 37"><img src="https://latex.codecogs.com/svg.latex?=" alt="Equation 36">1.


## References
