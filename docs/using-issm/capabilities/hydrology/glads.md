---
title: Hydrology Solution - GlaDS
layout: default
parent: Hydrology Solution
has_children: false
has_toc: false
---

### Hydrology Solution - GlaDS
#### Description
The two-dimensional Glacier Drainage System model (GlaDS, [<a href="#references">*Werder2013*</a>]) couples a distributed water sheet model &#8212; a continuum description of a linked cavity drainage system [<a href="#references">*Hewitt2011*</a>] &#8212; with a channelized water flow model &#8212; modeled as R channels [<a href="#references">*Rothlisberger1972,Nye1976*</a>]. The coupled system collectively describes the evolution of hydraulic potential <img src="https://latex.codecogs.com/svg.latex?\phi" alt="Equation 3">, water sheet thickness <img src="https://latex.codecogs.com/svg.latex?h" alt="Equation 2">, and water channel cross-sectional area <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 1">. 

##### Sheet model equations

- Mass conservation: The mass conservation equation describes water storage changes over longer timescales (dictated by cavity opening due to sliding) as well as shorter timescales (e.g. due to surface melt water input):

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{e_v}{\rho_w g}\frac{\partial\phi}{\partial t} + \frac{\partial h}{\partial t} - \nabla\cdot\boldsymbol{q} - m_b = 0," alt="Equation 4"></div>
  where: <img src="https://latex.codecogs.com/svg.latex?e_v" alt="Equation 10"> is the englacial void ratio, <img src="https://latex.codecogs.com/svg.latex?\rho_w" alt="Equation 9"> is water density (kg~m<a href="#footnotes" target="_top"><sup>-3</sup></a>), <img src="https://latex.codecogs.com/svg.latex?g" alt="Equation 8"> is gravitational acceleration (kg~m<a href="#footnotes" target="_top"><sup>-3</sup></a>), <img src="https://latex.codecogs.com/svg.latex?\phi" alt="Equation 7"> is the hydraulic potential (Pa), and <img src="https://latex.codecogs.com/svg.latex?h" alt="Equation 6"> is the sheet thickness (m). The water discharge <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{q}" alt="Equation 5"> (m<a href="#footnotes" target="_top"><sup>2</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>) is given by:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
\boldsymbol{q}=-k_s\;h^{\alpha_s}\left|\nabla\phi\right|^{\beta_s-2}\nabla\phi," alt="Equation 11"></div>
  where <img src="https://latex.codecogs.com/svg.latex?k_s" alt="Equation 17"> is the sheet conductivity (m~s~kg<a href="#footnotes" target="_top"><sup>-1</sup></a>), and <img src="https://latex.codecogs.com/svg.latex?\alpha_s" alt="Equation 16"><img src="https://latex.codecogs.com/svg.latex?=" alt="Equation 15">5/4 and <img src="https://latex.codecogs.com/svg.latex?\beta_s" alt="Equation 14"><img src="https://latex.codecogs.com/svg.latex?=" alt="Equation 13">3/2 are two constant exponents. Finally, the melt source term <img src="https://latex.codecogs.com/svg.latex?m_b" alt="Equation 12"> (m~s<a href="#footnotes" target="_top"><sup>-1</sup></a>) is given by:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
m_b=\frac{G+|\boldsymbol{\tau}_b\cdot\boldsymbol{u}_b|}{\rho_{i}L}," alt="Equation 18"></div>
  where <img src="https://latex.codecogs.com/svg.latex?G" alt="Equation 23"> is the geothermal heat flux (W~m<a href="#footnotes" target="_top"><sup>-2</sup></a>), <img src="https://latex.codecogs.com/svg.latex?|\boldsymbol{\tau}_b\cdot\boldsymbol{u}_b|" alt="Equation 22"> is the frictional heating (W~m<a href="#footnotes" target="_top"><sup>-2</sup></a>), for basal stress <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\tau}_b" alt="Equation 21"> (Pa), <img src="https://latex.codecogs.com/svg.latex?\rho_i" alt="Equation 20"> is ice density (kg~m<a href="#footnotes" target="_top"><sup>-3</sup></a>), and <img src="https://latex.codecogs.com/svg.latex?L" alt="Equation 19"> is latent heating (J~kg<a href="#footnotes" target="_top"><sup>-1</sup></a>).


- Sheet thickness:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial h}{\partial t} = w_s - v_s." alt="Equation 24"></div>
  Here, <img src="https://latex.codecogs.com/svg.latex?w_s" alt="Equation 25"> is the cavity opening rate due to sliding over bed topography (m~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), given by:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
w_s\left(h\right) =\begin{array}{ll}\displaystyle \frac{\left|\boldsymbol{u}_b\right|}{l_r}\left(h_r-h\right), & \text{if } h<h_r\\\\0, & \text{otherwise,}\end{array}" alt="Equation 26"></div>
  where <img src="https://latex.codecogs.com/svg.latex?h_r" alt="Equation 30"> and <img src="https://latex.codecogs.com/svg.latex?l_r" alt="Equation 29"> are both constants (m), and <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{u}_b" alt="Equation 28"> is the basal sliding velocity vector (provided by the ice flow model). The cavity closing rate due to ice creep <img src="https://latex.codecogs.com/svg.latex?v_s" alt="Equation 27"> (m~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), is given by:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
v_s\left(h,\phi\right) = \frac{2A}{n^n}h\left|N\right|^{n-1}N," alt="Equation 31"></div>
  where <img src="https://latex.codecogs.com/svg.latex?A" alt="Equation 38"> is the basal flow parameter (Pa<a href="#footnotes" target="_top"><sup>-3</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), related to the ice hardness by <img src="https://latex.codecogs.com/svg.latex?B=A" alt="Equation 37"><a href="#footnotes" target="_top"><sup>-1/3</sup></a>, <img src="https://latex.codecogs.com/svg.latex?n" alt="Equation 36"> is the Glen flow relation exponent, and <img src="https://latex.codecogs.com/svg.latex?N= \phi_0-\phi" alt="Equation 35"> is the effective pressure. The overburden hydraulic potential is given by <img src="https://latex.codecogs.com/svg.latex?\phi_0 = \phi_m+p" alt="Equation 34">, with the ice pressure <img src="https://latex.codecogs.com/svg.latex?p = \rho_i g H" alt="Equation 33"> and elevation potential <img src="https://latex.codecogs.com/svg.latex?\phi_m = \rho_w g b" alt="Equation 32">, all of which are given in units of Pa.

##### Channel model equations

- Channel discharge (along mesh edges):

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial Q}{\partial s} + \frac{\Xi-\Pi}{L}\left(\frac{1}{\rho_i} - \frac{1}{\rho_w}\right) - v_c - m_c = 0," alt="Equation 39"></div>
  where <img src="https://latex.codecogs.com/svg.latex?Q" alt="Equation 46"> is the channel discharge (m<a href="#footnotes" target="_top"><sup>3</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), which evolves with respect to the horizontal coordinate along the channel <img src="https://latex.codecogs.com/svg.latex?s" alt="Equation 45">, <img src="https://latex.codecogs.com/svg.latex?\Xi" alt="Equation 44"> is the channel potential energy dissipated per unit length and time (W~m<a href="#footnotes" target="_top"><sup>-1</sup></a>), <img src="https://latex.codecogs.com/svg.latex?\Pi" alt="Equation 43"> is the channel pressure melting/refreezing (W~m<a href="#footnotes" target="_top"><sup>-1</sup></a>), <img src="https://latex.codecogs.com/svg.latex?v_c" alt="Equation 42"> is the channel closing rate (m<a href="#footnotes" target="_top"><sup>2</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>) and <img src="https://latex.codecogs.com/svg.latex?m_c" alt="Equation 41"> is the source term (m<a href="#footnotes" target="_top"><sup>2</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>). The discharge <img src="https://latex.codecogs.com/svg.latex?Q" alt="Equation 40"> is defined as:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
Q= -\underbrace{k_cS^{\alpha_c}\left|\frac{\partial\phi}{\partial s}\right|^{\beta_c-2}}_{K_c}\frac{\partial\phi}{\partial s}," alt="Equation 47"></div>
  where <img src="https://latex.codecogs.com/svg.latex?k_c" alt="Equation 53"> is the channel conductivity, and <img src="https://latex.codecogs.com/svg.latex?\alpha_c" alt="Equation 52"><img src="https://latex.codecogs.com/svg.latex?=" alt="Equation 51">3 and <img src="https://latex.codecogs.com/svg.latex?\beta_c" alt="Equation 50"><img src="https://latex.codecogs.com/svg.latex?=" alt="Equation 49">2 are two exponents. The term <img src="https://latex.codecogs.com/svg.latex?v_c" alt="Equation 48"> is the closing of the channels by ice creep, and is given by:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
v_c\left(S,\phi\right) = \frac{2A}{n^n}S\left|N\right|^{n-1}N,\\" alt="Equation 54"></div>
  where <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 56"> is the channel cross-sectional area (m<a href="#footnotes" target="_top"><sup>2</sup></a>). Finally, <img src="https://latex.codecogs.com/svg.latex?m_c" alt="Equation 55">, the channel source term balancing the flow of water out of the adjacent sheet, is: 

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
m_c = \boldsymbol{q}\cdot\boldsymbol{n}|_{\partial{\Omega_{i1}} } +\boldsymbol{q}\cdot\boldsymbol{n}|_{\partial{\Omega_{i2}} }." alt="Equation 57"></div>
  where <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{n}" alt="Equation 58"> is the normal to the channel edge.


- Channel dissipation of potential energy:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
\Xi(S,\phi)=\Biggl|Q\frac{\partial\phi}{\partial s}\Biggr| +\left|l_cq_c\frac{\partial\phi}{\partial s}\right|," alt="Equation 59"></div>
  where <img src="https://latex.codecogs.com/svg.latex?l_c" alt="Equation 61"> is the channel width (m), and <img src="https://latex.codecogs.com/svg.latex?q_c" alt="Equation 60"> is the discharge in the sheet (flowing in the direction of the channel; m<a href="#footnotes" target="_top"><sup>2</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), given by:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
q_c\left(h,\phi\right)= -\underbrace{k_s h^{\alpha_s} \left|\frac{\partial\phi}{\partial s}\right|^{\beta_s-2}}_{K_s}\frac{\partial\phi}{\partial s}," alt="Equation 62"></div>
  with <img src="https://latex.codecogs.com/svg.latex?k_s" alt="Equation 65">, <img src="https://latex.codecogs.com/svg.latex?\alpha_s" alt="Equation 64">, and <img src="https://latex.codecogs.com/svg.latex?\beta_s" alt="Equation 63"> as given above.


- Channel melt/refreeze rate:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
\Pi(S,\phi)=-c_tc_w\rho_w(Q+f l_c q_c)\frac{\partial\phi-\partial\phi_m}{\partial s}," alt="Equation 66"></div>
  Here, <img src="https://latex.codecogs.com/svg.latex?c_t" alt="Equation 70"> is the Clapeyron slope (K~Pa<a href="#footnotes" target="_top"><sup>-1</sup></a>), <img src="https://latex.codecogs.com/svg.latex?c_w" alt="Equation 69"> is the specific heat capacity of water (J~kg<a href="#footnotes" target="_top"><sup>-1</sup></a>~K<a href="#footnotes" target="_top"><sup>-1</sup></a>), and <img src="https://latex.codecogs.com/svg.latex?f" alt="Equation 68"> is a switch parameter that accounts for the fact that the channel area cannot be negative, turning off the sheet flow for refreezing as <img src="https://latex.codecogs.com/svg.latex?S\rightarrow0" alt="Equation 67">, i.e.:

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
f =\left\{\begin{array}{ll}1, & \text{if }S>0 \text{ or } q_c\partial(\phi-\phi_m)\partial s>0\\0, & \text{otherwise}\end{array}\right." alt="Equation 71"></div>


- Cross-sectional channel area (defined along mesh edges):

  <div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial S}{\partial t} = \frac{\Xi - \Pi}{\rho_i L} - v_c." alt="Equation 72"></div>

##### Boundary conditions
Boundary conditions for the evolution of hydraulic potential <img src="https://latex.codecogs.com/svg.latex?\phi" alt="Equation 74"> are applied on the domain boundary <img src="https://latex.codecogs.com/svg.latex?\partial\Omega" alt="Equation 73">, as either a prescribed pressure or water flux. The Dirichlet boundary condition is:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\phi=\phi_D  \quad\text{on} \quad\partial\Omega_D," alt="Equation 75"></div>
where <img src="https://latex.codecogs.com/svg.latex?\phi_D" alt="Equation 76"> is a specific potential, and the Neumann boundary condition is:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\partial\phi}{\partial n}=\Phi_N  \quad\text{on} \quad\partial\Omega_N," alt="Equation 77"></div>
corresponding to the specific discharge

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
q_N=-k_s h^{\alpha_s}|\nabla\phi|^{\beta_s-2}\Phi_N." alt="Equation 78"></div>
Channels are defined only on element edges and are not allowed to cross the domain boundary, so we do not require flux conditions. Since the evolution equations for <img src="https://latex.codecogs.com/svg.latex?h" alt="Equation 80"> and <img src="https://latex.codecogs.com/svg.latex?S" alt="Equation 79"> do not contain their spatial derivatives, we do not require any boundary conditions for their evolution equations.

#### Model parameters
The parameters relevant to the GlaDS (`hydrologyglads`) solution can be displayed by running:
````
>> md.hydrology
````


- `md.hydrology.pressure_melt_coefficient`: Pressure melt coefficient (<img src="https://latex.codecogs.com/svg.latex?c_t" alt="Equation 81">) [K Pa<a href="#footnotes" target="_top"><sup>-1</sup></a>]
- `md.hydrology.sheet_conductivity`: sheet conductivity (<img src="https://latex.codecogs.com/svg.latex?k" alt="Equation 82">) [m<a href="#footnotes" target="_top"><sup>7/4</sup></a> kg<a href="#footnotes" target="_top"><sup>-1/2</sup></a>]
- `md.hydrology.cavity_spacing`: cavity spacing (<img src="https://latex.codecogs.com/svg.latex?l_r" alt="Equation 83">) [m]
- `md.hydrology.bump_height`: typical bump height (<img src="https://latex.codecogs.com/svg.latex?h_r" alt="Equation 84">) [m]
- `md.hydrology.ischannels`: Do we allow for channels? 1: yes, 0: no
- `md.hydrology.channel_conductivity`: channel conductivity (<img src="https://latex.codecogs.com/svg.latex?k_c" alt="Equation 85">) [m<a href="#footnotes" target="_top"><sup>3/2</sup></a> kg<a href="#footnotes" target="_top"><sup>-1/2</sup></a>]
- `md.hydrology.spcphi`: Hydraulic potential Dirichlet constraints [Pa]
- `md.hydrology.neumannflux`: water flux applied along the model boundary (m<a href="#footnotes" target="_top"><sup>2</sup></a> s<a href="#footnotes" target="_top"><sup>-1</sup></a>)
- `md.hydrology.moulin_input`: moulin input (<img src="https://latex.codecogs.com/svg.latex?Q_s" alt="Equation 86">) [m<a href="#footnotes" target="_top"><sup>3</sup></a> s<a href="#footnotes" target="_top"><sup>-1</sup></a>]
- `md.hydrology.englacial_void_ratio`: englacial void ratio (<img src="https://latex.codecogs.com/svg.latex?e_v" alt="Equation 87">)
- `md.hydrology.requested_outputs`: additional outputs requested?
- `md.hydrology.melt_flag`: User specified basal melt? 0: no (default), 1: use `md.basalforcings.groundedice_melting_rate`

#### Running a simulation
To run a transient standalone subglacial hydrology simulation, use the following commands:
````
md.transient = deactivateall(md.transient);
md.transient.ishydrology = 1;

%Change hydrology class to GlaDS;
md.hydrology = hydrologyglads();

%Set model parameters here;
md = solve(md, 'Transient');
````


## References
