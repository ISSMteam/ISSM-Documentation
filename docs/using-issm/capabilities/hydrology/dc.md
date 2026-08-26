---
title: Hydrology Solution - Dual Continuum Porous Equivalent Approach
layout: default
parent: Hydrology Solution
math: mathjax3
---

### Hydrology Solution - Dual Continuum Porous Equivalent Approach
#### Physical basis
Using the dual continuum porous equivalent approach, the inefficient and efficient drainage components are both modeled as sediment layers with the use of a specific activation scheme for the efficient drainage system. This approach defines in a continuous manner the location where the efficient drainage system is most likely to develop.

##### Water Distribution
The model consist of two analyses, one for the Inefficient Drainage System (IDS) and the other for the Efficient Drainage System(EDS). Each compute the water head by using a vertically integrated diffusion equation based on Darcy's law. The two are coupled through a transfer term, which is implicitly computed at the same time as the water head. In the following equation, the index $$j$$
(subscript or superscript) may either refer to the IDS ($$j=\text{i}$$) or to the EDS ($$j=\text{e}$$):

$$
S_j\frac{\partial h_j }{\partial t } - \nabla \cdot \left(T_j\, \nabla\,h_j \right) = Q_j.
$$
where:

- $$S_j$$ is the storage coefficient of porous media $$[SU]$$
- $$h_j$$ is the water head of the porous media $$[m]$$
- $$T_j$$ is the transmissivity of porous media $$[m^2\,s^{-1}]$$
- $$Q_j$$ is the water input $$[m\,s^{-1}]$$

Storage coefficient and transmissivities are the descriptive parameters of the porous layers. They are defined as:

$$
T_j = e_j K_j
$$
and:

$$
S_j = \rho_{w} \omega_j g e_j\left[ \beta_{w} - \frac{\alpha}{\omega_j}\right],
$$
where:

- $$e_j$$ is the thickness of the considered layer $$[m]$$
- $$K_j$$ is the permeability of the porous media $$[m\,s^{-1}]$$
- $$\rho_w$$ is the density of fresh water $$[kg\,m^{-3}]$$
- $$\omega_j$$ is the porosity of the media $$[SU]$$
- $$g$$ is the gravitational acceleration $$[m\,s^{-2}]$$
- $$\beta_w$$ is the compressibility of water $$[Pa^{-1}]$$
- $$\alpha$$ is the compressibility of the solid phase of the porous media $$[Pa^{-1}]$$

##### Specificities of the IDS
The main specificity of the IDS is that it allows us to set up a maximum limit for the water head. This is dealt with by a penalization method from which the residual is kept, in order to be re-injected into the EDS.

The source term for the IDS is the sum of three possible sources:

- surfacic input given by the melting at the base of the glacier $$[m]$$
- local input at a given point representing moulin input $$[m^{-3}\,s^{-1}]$$
- input due to the transfer between the two layers which is dealt with in an implicit matter (See Layer Transfer)

##### Specificities of the EDS
The model could be run without introducing this layer. In this case, it is possible that the model does not conserve the mass of water, depending on the setting of the upper limit for the IDS. If the layer is used, it is usually not active on the whole domain. The initial activation process is driven by the water head in the IDS and then by the water head in the EDS. More information about the activation process can be found in [<a href="#references">*Fleurian2014*</a>]. Improvements from the version presented in [<a href="#references">*Fleurian2014*</a>] include a varying thickness for the EDS layer, which allows us to close back the EDS when the water volume becomes too low and can be evacuated by the IDS only. The thickness evolution is defined as follows:

$$
\frac{\partial e_e}{\partial t}= g \frac{\rho_w e_e K_e}{\rho_{ice} L_{ice}} \left(\nabla\,h_e\right)^2 - 2\left[\frac{N}{Bn}\right]^{n}
$$
where:

- $$\rho_{ice}$$ is the density of the ice $$[kg\,m^{-3}]$$
- $$L_{ice}$$ is the latent heat of fusion for the ice $$[J\,kg^{-1}]$$
- $$N$$ is the effective pressure $$[Pa]$$
- $$B$$ is the ice hardness or rigidity $$[Pa\,s^{1/n}]$$
- $$n$$ is Glen's flow law exponent, generally taken as equal to 3 $$[SU]$$

#### Transfer equation
The transfer between the two layers is based on the water head difference in the two systems. The transfer term $$Q_t$$ is as follows:

$$
Q_{\mathrm{t}} = \varphi(h_i-h_e).
$$
where:

- $$\varphi$$ is the leakage time from one layer to the other $$[s^{-1}]$$

The leakage time $$\varphi$$ is a characteristic time needed for the water to pass from one drainage system to the other. This corresponds to the crossing of a less permeable layer in between the inefficient and efficient layers.

##### Boundary conditions
The natural boundary condition is a no flow condition, which is what is kept on the upstream model boundaries. The water head is then fixed at the snouts of glaciers.

#### Model parameters
The parameters relevant to the hydrology solution can be displayed by typing:
````
>> md.hydrology
````

These parameters are of three different types:
##### General parameters

- `md.hydrology.water_compressibility`: compressibility of water $$[Pa^-1]$$
- `md.hydrology.isefficientlayer`: do we use an efficient drainage system (1: true; 0: false)
- `md.hydrology.penalty_factor`: exponent of the value used in the penalization method (dimensionless)
- `md.hydrology.penalty_lock`: stabilize unstable constraints that keep zigzagging after n iteration (default is 0, no stabilization)
- `md.hydrology.rel_tol`: tolerance of the nonlinear iteration for the transfer between layers (dimensionless)
- `md.hydrology.max_iter`: maximum number of nonlinear iteration
- `md.hydrology.sedimentlimit_flag`: what kind of upper limit is applied for the inefficient layer
  - 0: no limit
  - 1: user defined: sedimentlimit
  - 2: hydrostatic pressure
  - 3: normal stress
- `md.hydrology.transfer_flag`: what kind of transfer method is applied between the layers
  - 0: no transfer
  - 1: constant leakage factor: leakage&#95;factor
- `md.hydrology.leakage_factor`: user defined leakage factor $$[m]$$
- `md.hydrology.basal_moulin_input`: water flux at a given point $$[m^3 s-1]$$


##### IDS parameters
Also called sediment layer


- `md.hydrology.spcsediment_head`: sediment water head constraints (`NaN` means no constraint) (m above MSL)
- `md.hydrology.sediment_compressibility`: sediment compressibility $$[Pa^-1]$$
- `md.hydrology.sediment_porosity`: sediment (dimensionless)
- `md.hydrology.sediment_thickness`: sediment thickness $$[m]$$
- `md.hydrology.sediment_transmitivity`: sediment transmitivity $$[m^2/s]$$

##### EDS parameters
Also called EPL layer (Equivalent Porous Layer)


- `md.hydrology.spcepl_head`: epl water head constraints (NaN means no constraint) [m above MSL]
- `md.hydrology.mask_eplactive_node`: active (1) or not (0) EPL
- `md.hydrology.epl_compressibility`: epl compressibility $$[Pa^-1]$$
- `md.hydrology.epl_porosity`: epl [dimensionless]
- `md.hydrology.epl_initial_thickness`: epl initial thickness $$[m]$$
- `md.hydrology.epl_max_thickness`: epl maximal thickness $$[m]$$
- `md.hydrology.epl_conductivity`: epl conductivity $$[m^2/s]$$

#### Running a simulation
To run a transient simulation, use the following command:
````
>> md = solve(md, 'Transient');
````

The first argument is the model, the second is the nature of the simulation one wants to run. The default for the transient simulation does not include the resolution of the hydrological model. One should introduce the following lines in the run launchers to enable the hydrology:

- For a standalone hydrology model:
  ````
>> md.transient = deactivateall(md.transient);
>> md.transient.ishydrology = 1;
  ````

- To add the hydrology to a transient simulation:
  ````
>> md.transient.ishydrology = 1;
  ````

Running a steady state simulation, is done with the following command:
````
>> md = solve(md, 'Hydrology');
````


## References
- B. de Fleurian, O. Gagliardini, T. Zwinger, G. Durand, E. Le Meur, D. Mair, and
   P. Raaback.
 A double continuum hydrological model for glacier applications.
 Cryosphere, 8(1):137-153, 2014.
