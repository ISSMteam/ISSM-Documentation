---
title: Hydrology Solution - SHAKTI
layout: default
parent: Hydrology Solution
---

### Hydrology Solution - SHAKTI
#### Description
SHAKTI (Subglacial Hydrology and Kinetic, Transient Interactions) is a transient subglacial hydrology model that has flexible geometry and treats the entire domain with one set of governing equations, allowing for any drainage configuration to arise, which can include efficient (channelized) and inefficient (distributed) features. [<a href="#references">*Sommers2018*</a>]

##### Equations
The SHAKTI model is based upon governing equations that describe conservation of water mass, evolution of the system geometry, basal water flux (approximate momentum equation), and internal melt generation (approximate energy equation).


- Continuity equation (water mass balance):

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?\frac{\partial b}{\partial t}+\frac{\partial b_e}{\partial t}+\nabla \cdot \vec{q}=\frac{\dot m}{\rho_w}+i_{e\rightarrow b}" alt="Equation 1"></div>
  where <img src="https://latex.codecogs.com/svg.latex?b" alt="Equation 6"> is subglacial gap height, <img src="https://latex.codecogs.com/svg.latex?b_e" alt="Equation 5"> is the volume of water stored englacially per unit area of bed, <img src="https://latex.codecogs.com/svg.latex?\vec{q}" alt="Equation 4"> is basal water flux, <img src="https://latex.codecogs.com/svg.latex?\dot{m}" alt="Equation 3"> is melt rate, and <img src="https://latex.codecogs.com/svg.latex?i_{e\rightarrow b}" alt="Equation 2"> is the input rate of water from the englacial to subglacial system.


- Basal gap dynamics (subglacial geometry):

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?\frac{\partial b}{\partial t}=\frac{\dot{m}}{\rho_i}+\beta u_b-A|p_i-p_w|^{n-1}(p_i-p_w)b" alt="Equation 7"></div>
  where <img src="https://latex.codecogs.com/svg.latex?b" alt="Equation 15"> is the subglacial gap height, <img src="https://latex.codecogs.com/svg.latex?\dot{m}" alt="Equation 14"> is melt rate, <img src="https://latex.codecogs.com/svg.latex?A" alt="Equation 13"> is the ice flow law parameter, <img src="https://latex.codecogs.com/svg.latex?n" alt="Equation 12"> is the flow law exponent, <img src="https://latex.codecogs.com/svg.latex?p_i" alt="Equation 11"> is the overburden pressure of ice, <img src="https://latex.codecogs.com/svg.latex?p_w" alt="Equation 10"> is water pressure, <img src="https://latex.codecogs.com/svg.latex?\beta" alt="Equation 9"> is a dimensionless parameter governing opening by sliding, and <img src="https://latex.codecogs.com/svg.latex?u_b" alt="Equation 8"> is sliding velocity. According to this equation, the subglacial gap height evolves with time by: opening by both melt and sliding over bumps on the bed, and closing due to ice creep.


- Basal water flux (approximate momentum equation):

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?\vec{q}=\frac{-b^3g}{12\nu(1+\omega Re)}\nabla h" alt="Equation 16"></div>
  where <img src="https://latex.codecogs.com/svg.latex?b" alt="Equation 22"> is subglacial gap height, <img src="https://latex.codecogs.com/svg.latex?g" alt="Equation 21"> is gravitational acceleration, <img src="https://latex.codecogs.com/svg.latex?\nu" alt="Equation 20"> is kinematic viscosity of water, <img src="https://latex.codecogs.com/svg.latex?\omega" alt="Equation 19"> is a dimensionless parameter controlling the nonlinear transition from laminar to turbulent flow (for turbulent flow, the flux becomes proportional to the square root of the head gradient), <img src="https://latex.codecogs.com/svg.latex?Re" alt="Equation 18"> is the Reynolds number, and <img src="https://latex.codecogs.com/svg.latex?h" alt="Equation 17"> is hydraulic head:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?h=\frac{p_w}{\rho_w g}+z_b" alt="Equation 23"></div>

Equation (3) is a key piece of our model formulation, in that it allows for a spatially and temporally variable hydraulic transmissivity in the system, and facilitates easeful transition between laminar and turbulent flow regimes. Most existing models prescribe a hydraulic conductivity and assume the flow to be turbulent everywhere. Our momentum equation acts to "unify" different drainage modes in a single model.


- Internal melt generation (energy balance at the bed):

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
\dot{m}=\frac{1}{L}(G+\vec{u_b}\cdot\vec{\tau_b}-\rho_wg\vec{q}\cdot\nabla h-c_t c_w \rho_w \vec{q}\cdot\nabla p_w)" alt="Equation 24"></div>
  where <img src="https://latex.codecogs.com/svg.latex?L" alt="Equation 34"> is latent heat of fusion of water, <img src="https://latex.codecogs.com/svg.latex?G" alt="Equation 33"> is geothermal flux, <img src="https://latex.codecogs.com/svg.latex?u_b" alt="Equation 32"> is basal sliding velocity, <img src="https://latex.codecogs.com/svg.latex?\tau_b" alt="Equation 31"> is the stress exerted by the bed onto the ice, <img src="https://latex.codecogs.com/svg.latex?\vec{q}" alt="Equation 30"> is basal water flux (discharge), <img src="https://latex.codecogs.com/svg.latex?h" alt="Equation 29"> is hydraulic head, <img src="https://latex.codecogs.com/svg.latex?c_t" alt="Equation 28"> is the pressure melt coefficient (Clapeyron constant), <img src="https://latex.codecogs.com/svg.latex?c_w" alt="Equation 27"> is the heat capacity of water, <img src="https://latex.codecogs.com/svg.latex?\rho_w" alt="Equation 26"> is density of water, and <img src="https://latex.codecogs.com/svg.latex?p_w" alt="Equation 25"> is water pressure. In words, melt is produced through a combination of geothermal flux, frictional heat due to sliding, and heat generated through internal dissipation (where mechanical energy is converted to thermal energy), minus the heat consumed due to changes in water pressure. We note that this form of the energy equation assumes that all heat produced is converted locally to melt and is not advected downstream. We assume that the ice and liquid water are consistently at the pressure melting point temperature. While these assumptions may not be strictly valid under certain real conditions that may have interesting implications, we leave that discussion for future work.

Following Werder et al. (2013), the englacial storage volume is a function of water pressure:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
b_e=e_v\frac{\rho_wgh-\rho_wgz_b}{\rho_wg}=e_v(h-z_b)" alt="Equation 35"></div>
where <img src="https://latex.codecogs.com/svg.latex?e_v" alt="Equation 36"> is the englacial void ratio (zero for no englacial storage).

Equations (1), (2), (3), and (5) are combined to form a nonlinear partial differential equation (PDE) in terms of hydraulic head, <img src="https://latex.codecogs.com/svg.latex?h" alt="Equation 37">:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\nabla\cdot\left[\frac{-b^3g}{12\nu(1+\omega Re)}\cdot\nabla h\right]+\frac{\partial e_v(h-z_b)}{\partial t}=\dot{m}\left[\frac{1}{\rho_w}-\frac{1}{\rho_i}\right]+A|p_i-p_w|^{n-1}(p_i-p_w)b-\beta u_b+i_{e\rightarrow b}" alt="Equation 38"></div>
With no englacial storage (<img src="https://latex.codecogs.com/svg.latex?e_v=0" alt="Equation 39">), Eq. (7) takes the form of an elliptic PDE.

Defining the hydraulic "transmissivity":

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\vec{K}=\frac{-b^3g}{12\nu(1+\omega Re)}" alt="Equation 40"></div>

Equation (7) can be written more compactly as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\nabla\cdot(\vec{K}\cdot\nabla h)+\frac{\partial e_v(h-z_b)}{\partial t}=\dot{m}(\frac{1}{\rho_w}-\frac{1}{\rho_i})+A|p_i-p_w|^{n-1}(p_i-p_w)b-\beta u_b+i_{e\rightarrow b}" alt="Equation 41"></div>
or simply as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\nabla\cdot(\vec{K}\cdot\nabla h)+\frac{\partial e_v(h-z_b)}{\partial t}=RHS" alt="Equation 42"></div>
where the forcing (<img src="https://latex.codecogs.com/svg.latex?RHS" alt="Equation 44">) is a function of the relevant dependent variables. Within each time step, this nonlinear PDE is solved using a Picard iteration to establish the head (<img src="https://latex.codecogs.com/svg.latex?h" alt="Equation 43">) distribution.

##### Boundary conditions
Boundary conditions can be applied as either prescribed head (Dirichlet) conditions or as flux (Neumann) conditions. We typically apply a Dirichlet boundary condition of atmospheric pressure at the edge of the ice sheet, and Neumann boundary conditions (no flux or prescribed flux, which can be constant or time-varying) on the other boundaries of the subglacial drainage domain.

#### Model parameters
The parameters relevant to the SHAKTI (hydrologyshakti) solution can be displayed by running:
````
>> md.hydrology
````


- `md.hydrology.head` subglacial hydrology water head (m)
- `md.hydrology.gap_height` height of gap separating ice to bed (m)
- `md.hydrology.bump_spacing` characteristic bedrock bump spacing (m)
- `md.hydrology.bump_height` characteristic bedrock bump height (m)
- `md.hydrology.englacial_input` liquid water input from englacial to subglacial system (m/yr)
- `md.hydrology.moulin_input` liquid water input from moulins (at the vertices) to subglacial system (m<a href="#footnotes" target="_top"><sup>3</sup></a>/s)
- `md.hydrology.reynolds` Reynolds' number
- `md.hydrology.neumannflux` water flux applied along the model boundary (m<a href="#footnotes" target="_top"><sup>2</sup></a>/s)
- `md.hydrology.spchead` water head constraints (NaN means no constraint) (m)
- `md.hydrology.relaxation` under-relaxation coefficient for nonlinear iteration
- `md.hydrology.storage` englacial storage coefficient (void ratio)

#### Running a simulation
To run a transient stand-alone subglacial hydrology simulation, use the following commands:
````
md.transient = deactivateall(md.transient);
md.transient.ishydrology = 1;

%Change hydrology class to SHAKTI
md.hydrology = hydrologyshakti();

%Set model paramters here

md = solve(md, 'Transient');
````


## References
