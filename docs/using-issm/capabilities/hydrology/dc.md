---
title: Hydrology Solution - Dual Continuum Porous Equivalent Approach
layout: default
parent: Hydrology Solution
has_children: false
has_toc: false
---

### Hydrology Solution - Dual Continuum Porous Equivalent Approach
#### Physical basis
Using the dual continuum porous equivalent approach, the inefficient and efficient drainage components are both modeled as sediment layers with the use of a specific activation scheme for the efficient drainage system. This approach defines in a continuous manner the location where the efficient drainage system is most likely to develop.

##### Water Distribution
The model consist of two analyses, one for the Inefficient Drainage System (IDS) and the other for the Efficient Drainage System(EDS). Each compute the water head by using a vertically integrated diffusion equation based on Darcy's law. The two are coupled through a transfer term, which is implicitly computed at the same time as the water head. In the following equation, the index <img src="https://latex.codecogs.com/svg.latex?j" alt="Equation 1">
(subscript or superscript) may either refer to the IDS (<img src="https://latex.codecogs.com/svg.latex?j=\text{i}" alt="Equation 3">) or to the EDS (<img src="https://latex.codecogs.com/svg.latex?j=\text{e}" alt="Equation 2">):

<div align="center"><img src="https://latex.codecogs.com/svg.latex?\label{eq:dif_int}
S_j\frac{\partial h_j }{\partial t } - \nabla \cdot \left(T_j\, \nabla\,h_j \right) = Q_j." alt="Equation 4"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?S_j" alt="Equation 6"> is the storage coefficient of porous media <img src="https://latex.codecogs.com/svg.latex?[SU]" alt="Equation 5">
- <img src="https://latex.codecogs.com/svg.latex?h_j" alt="Equation 8"> is the water head of the porous media <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 7">
- <img src="https://latex.codecogs.com/svg.latex?T_j" alt="Equation 10"> is the transmissivity of porous media <img src="https://latex.codecogs.com/svg.latex?[m^2\,s^{-1}]" alt="Equation 9">
- <img src="https://latex.codecogs.com/svg.latex?Q_j" alt="Equation 12"> is the water input <img src="https://latex.codecogs.com/svg.latex?[m\,s^{-1}]" alt="Equation 11">

Storage coefficient and transmissivities are the descriptive parameters of the porous layers. They are defined as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
T_j = e_j K_j" alt="Equation 13"></div>
and:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
S_j = \rho_{w} \omega_j g e_j\left[ \beta_{w} - \frac{\alpha}{\omega_j}\right]," alt="Equation 14"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?e_j" alt="Equation 16"> is the thickness of the considered layer <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 15">
- <img src="https://latex.codecogs.com/svg.latex?K_j" alt="Equation 18"> is the permeability of the porous media <img src="https://latex.codecogs.com/svg.latex?[m\,s^{-1}]" alt="Equation 17">
- <img src="https://latex.codecogs.com/svg.latex?\rho_w" alt="Equation 20"> is the density of fresh water <img src="https://latex.codecogs.com/svg.latex?[kg\,m^{-3}]" alt="Equation 19">
- <img src="https://latex.codecogs.com/svg.latex?\omega_j" alt="Equation 22"> is the porosity of the media <img src="https://latex.codecogs.com/svg.latex?[SU]" alt="Equation 21">
- <img src="https://latex.codecogs.com/svg.latex?g" alt="Equation 24"> is the gravitational acceleration <img src="https://latex.codecogs.com/svg.latex?[m\,s^{-2}]" alt="Equation 23">
- <img src="https://latex.codecogs.com/svg.latex?\beta_w" alt="Equation 26"> is the compressibility of water <img src="https://latex.codecogs.com/svg.latex?[Pa^{-1}]" alt="Equation 25">
- <img src="https://latex.codecogs.com/svg.latex?\alpha" alt="Equation 28"> is the compressibility of the solid phase of the porous media <img src="https://latex.codecogs.com/svg.latex?[Pa^{-1}]" alt="Equation 27">

##### Specificities of the IDS
The main specificity of the IDS is that it allows us to set up a maximum limit for the water head. This is dealt with by a penalization method from which the residual is kept, in order to be re-injected into the EDS.

The source term for the IDS is the sum of three possible sources:

- surfacic input given by the melting at the base of the glacier <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 29">
- local input at a given point representing moulin input <img src="https://latex.codecogs.com/svg.latex?[m^{-3}\,s^{-1}]" alt="Equation 30">
- input due to the transfer between the two layers which is dealt with in an implicit matter (See Layer Transfer)

##### Specificities of the EDS
The model could be run without introducing this layer. In this case, it is possible that the model does not conserve the mass of water, depending on the setting of the upper limit for the IDS. If the layer is used, it is usually not active on the whole domain. The initial activation process is driven by the water head in the IDS and then by the water head in the EDS. More information about the activation process can be found in [<a href="#references">*Fleurian2014*</a>]. Improvements from the version presented in [<a href="#references">*Fleurian2014*</a>] include a varying thickness for the EDS layer, which allows us to close back the EDS when the water volume becomes too low and can be evacuated by the IDS only. The thickness evolution is defined as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial e_e}{\partial t}= g \frac{\rho_w e_e K_e}{\rho_{ice} L_{ice}} \left(\nabla\,h_e\right)^2 - 2\left[\frac{N}{Bn}\right]^{n}" alt="Equation 31"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\rho_{ice}" alt="Equation 33"> is the density of the ice <img src="https://latex.codecogs.com/svg.latex?[kg\,m^{-3}]" alt="Equation 32">
- <img src="https://latex.codecogs.com/svg.latex?L_{ice}" alt="Equation 35"> is the latent heat of fusion for the ice <img src="https://latex.codecogs.com/svg.latex?[J\,kg^{-1}]" alt="Equation 34">
- <img src="https://latex.codecogs.com/svg.latex?N" alt="Equation 37"> is the effective pressure <img src="https://latex.codecogs.com/svg.latex?[Pa]" alt="Equation 36">
- <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 39"> is the ice hardness or rigidity <img src="https://latex.codecogs.com/svg.latex?[Pa\,s^{1/n}]" alt="Equation 38">
- <img src="https://latex.codecogs.com/svg.latex?n" alt="Equation 41"> is Glen's flow law exponent, generally taken as equal to 3 <img src="https://latex.codecogs.com/svg.latex?[SU]" alt="Equation 40">

#### Transfer equation
The transfer between the two layers is based on the water head difference in the two systems. The transfer term <img src="https://latex.codecogs.com/svg.latex?Q_t" alt="Equation 42"> is as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
Q_{\mathrm{t}} = \varphi(h_i-h_e)." alt="Equation 43"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\varphi" alt="Equation 45"> is the leakage time from one layer to the other <img src="https://latex.codecogs.com/svg.latex?[s^{-1}]" alt="Equation 44">

The leakage time <img src="https://latex.codecogs.com/svg.latex?\varphi" alt="Equation 46"> is a characteristic time needed for the water to pass from one drainage system to the other. This corresponds to the crossing of a less permeable layer in between the inefficient and efficient layers.

##### Boundary conditions
The natural boundary condition is a no flow condition, which is what is kept on the upstream model boundaries. The water head is then fixed at the snouts of glaciers.

#### Model parameters
The parameters relevant to the hydrology solution can be displayed by typing:
````
>> md.hydrology
````

These parameters are of three different types:
##### General parameters

- `md.hydrology.water_compressibility`: compressibility of water <img src="https://latex.codecogs.com/svg.latex?[Pa^-1]" alt="Equation 47">
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
- `md.hydrology.leakage_factor`: user defined leakage factor <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 48">
- `md.hydrology.basal_moulin_input`: water flux at a given point <img src="https://latex.codecogs.com/svg.latex?[m^3 s-1]" alt="Equation 49">


##### IDS parameters
Also called sediment layer


- `md.hydrology.spcsediment_head`: sediment water head constraints (`NaN` means no constraint) (m above MSL)
- `md.hydrology.sediment_compressibility`: sediment compressibility <img src="https://latex.codecogs.com/svg.latex?[Pa^-1]" alt="Equation 50">
- `md.hydrology.sediment_porosity`: sediment (dimensionless)
- `md.hydrology.sediment_thickness`: sediment thickness <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 51">
- `md.hydrology.sediment_transmitivity`: sediment transmitivity <img src="https://latex.codecogs.com/svg.latex?[m^2/s]" alt="Equation 52">

##### EDS parameters
Also called EPL layer (Equivalent Porous Layer)


- `md.hydrology.spcepl_head`: epl water head constraints (NaN means no constraint) [m above MSL]
- `md.hydrology.mask_eplactive_node`: active (1) or not (0) EPL
- `md.hydrology.epl_compressibility`: epl compressibility <img src="https://latex.codecogs.com/svg.latex?[Pa^-1]" alt="Equation 53">
- `md.hydrology.epl_porosity`: epl [dimensionless]
- `md.hydrology.epl_initial_thickness`: epl initial thickness <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 54">
- `md.hydrology.epl_max_thickness`: epl maximal thickness <img src="https://latex.codecogs.com/svg.latex?[m]" alt="Equation 55">
- `md.hydrology.epl_conductivity`: epl conductivity <img src="https://latex.codecogs.com/svg.latex?[m^2/s]" alt="Equation 56">

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
