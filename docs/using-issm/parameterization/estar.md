---
title: ESTAR
layout: default
parent: Parameterization
math: mathjax3
---

# Empirical Scalar Tertiary Anisotropy Regime (ESTAR)
## Description
The ESTAR (Empirical Scalar Tertiary Anisotropy Regime) flow relation [<a href="#references">*Budd2013,Graham2018*</a>] is a generalized constitutive relation for polycrystalline ice in steady-state (tertiary) flow. It is a scalar power-law formulation based on tertiary creep rates from laboratory experiments of ice deformation under a variety of simple shear and compression stresses. While mathematically isotropic, the ESTAR flow relation describes the deformation of ice with a flow-compatible induced anisotropy &#8212; i.e. ice that has a developed anisotropic fabric that is a function of the underlying stress regime (i.e. the relative proportion of simple shear and compression stresses). The origins of ESTAR, including the laboratory experiments that contributed to its development, its derivation, and underlying assumptions are discussed in [<a href="#references">*Budd2013*</a>] and [<a href="#references">*Graham2018*</a>].

### Equations
Ice is treated as a purely viscous incompressible material [<a href="#references">*Cuffey2010*</a>], such that its material constitutive relation can be written:

$$
{\boldsymbol\sigma'} = 2 \mu \dot{ {\boldsymbol\varepsilon}},
$$
where:

- $${\boldsymbol\sigma'}$$ is the deviatoric stress tensor (Pa)
- $$\mu$$ is the ice effective viscosity (Pa s)
- $$\dot{ {\boldsymbol\varepsilon}}$$ is the strain rate tensor (s<a href="#footnotes" target="_top"><sup>-1</sup></a>)

The ESTAR flow relation viscosity $$\mu$$ can be written:

$$
\mu = \frac{B}{2 E(\lambda_S)^{\frac{1}{3}}\dot{\varepsilon}_e^{\frac{2}{3}}},
$$
where:

- $$B$$ is the ice hardness or rigidity. Note that $$B=A(T')^{-1/3}$$, where $$A(T')$$ is the temperature-dependent flow rate parameter and $$T'$$ is the temperature relative to the pressure dependent melting point of ice.
- $$E(\lambda_S)$$ is an enhancement factor that characterizes the relative proportion of simple shear and compression stresses via the shear fraction $$\lambda_S$$

The most notable difference between the Glen and ESTAR flow relations is realized in the form of the enhancement factor, which for the ESTAR flow relation is $$E(\lambda_S)$$, given by:

$$
E(\lambda_S) = E_C + (E_S - E_C) \lambda_S^2.
$$
Here, $$E_C$$ and $$E_S$$ are the enhancement factors above the minimum (secondary) deformation rate for isotropic ice under compression alone or simple shear alone, respectively. Laboratory evidence suggests that a suitable ratio of $$E_C/E_S$$ is $$3/8$$ [<a href="#references">*Treverrow2012*</a>]. The shear fraction $$\lambda_S$$ characterizes the contribution of simple shear to the effective stress. The collinear nature of the ESTAR flow relation allows $$\lambda_S$$ to be expressed equivalently in terms of stresses and strain rates. The strain rate formulation is more convenient for Stokes flow modeling, and can be written:

$$
\lambda_S=\frac{\dot{\varepsilon}'}{\dot{\varepsilon}_e},
$$
where $$\dot{\varepsilon}'$$ (s<a href="#footnotes" target="_top"><sup>-1</sup></a>) is the magnitude of the shear strain rate on the local non-rotating shear plane. The local non-rotating shear plane contains the velocity vector and the vorticity vector associated solely with deformation, rather than local rigid body rotation. See [<a href="#references">*Graham2018*</a>] for details.

For comparison with the ESTAR viscosity, the Glen flow relation viscosity $$\mu$$ can be written:

$$
\mu = \frac{B}{2 E^{\frac{1}{n}}\dot{\varepsilon}_e^{\frac{n-1}{n}}},
$$
where $$E$$ is a constant enhancement factor. For the standard Glen flow relation (the `matice` class in ISSM), $$E=1$$; to specify values of $$E>1$$, the `matenhancedice` class can be used.

## Model parameters
The parameters relevant to the ESTAR flow relation (the `matestar` class in ISSM) can be displayed by running:
````
>> md.materials
````


- `md.materials.rheology_B`: temperature-dependent flow relation parameter (`NaN` means no constraint)
- `md.materials.rheology_Ec`: compression enhancement factor
- `md.materials.rheology_Es`: simple shear enhancement factor
- `md.materials.rheology_law`: law for the temperature dependence of the rheology (`None` means no temperature dependence; default is `Paterson`)

## Using the ESTAR flow relation
The ESTAR flow relation may be specified by:
````
>> md.materials = matestar();
````
In this case, values for $$B$$, $$E_C$$, and $$E_S$$ should be explicitly set.

Alternatively, the ESTAR flow relation may be specified from conversion of a Glen type relation by the following:
````
>> md.materials = matestar(md.materials);
````
The argument is the materials class of the model. This will set the same value for $$B$$ as for the Glen flow model default, with $$E_S=1$$ and $$E_C=1$$.

## Using the enhanced Glen flow relation
It is possible to use an alternative Glen flow relation with an explicit enhancement factor, in a similar way to the ESTAR class, as follows:
````
>> md.materials = matenhancedice();
````
in which $$B$$ and $$E$$ should be explicitly set, or as:
````
>> md.materials = matenhancedice(md.materials);
````
in which $$B$$ is inherited from the default Glen flow model and $$E=1$$.


# References
- William F. Budd, Roland C. Warner, T. H. Jacka, Jun Li, and Adam Treverrow.
 Ice flow relations for stress and strain-rate components from
   combined shear and compression laboratory experiments.
 J. Glaciol., 59(214):374-392, 2013.

- K. M. Cuffey and W. S. B. Paterson.
 The Physics of Glaciers, 4th Edition.
 Elsevier, Oxford, 2010.

- F. S. Graham, M. Morlighem, R. C. Warner, and A. Treverrow.
 Implementing an empirical scalar constitutive relation for ice with
   flow-induced polycrystalline anisotropy in large-scale ice sheet models.
 Cryosphere, 12(3):1047-1067, 2018.

- Adam Treverrow, William F. Budd, Tim H. Jacka, and Roland C. Warner.
 The tertiary creep of polycrystalline ice: experimental evidence for
   stress-dependent levels of strain-rate enhancement.
 J. Glaciol., 58(208):301-314, 2012.
