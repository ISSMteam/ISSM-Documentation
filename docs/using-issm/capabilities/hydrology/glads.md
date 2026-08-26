---
title: Hydrology Solution - GlaDS
layout: default
parent: Hydrology Solution
math: mathjax3
---

### Hydrology Solution - GlaDS
#### Description
The two-dimensional Glacier Drainage System model (GlaDS, [<a href="#references">*Werder2013*</a>]) couples a distributed water sheet model &#8212; a continuum description of a linked cavity drainage system [<a href="#references">*Hewitt2011*</a>] &#8212; with a channelized water flow model &#8212; modeled as R channels [<a href="#references">*Rothlisberger1972,Nye1976*</a>]. The coupled system collectively describes the evolution of hydraulic potential $$\phi$$, water sheet thickness $$h$$, and water channel cross-sectional area $$S$$. 

##### Sheet model equations

- Mass conservation: The mass conservation equation describes water storage changes over longer timescales (dictated by cavity opening due to sliding) as well as shorter timescales (e.g. due to surface melt water input):

  $$
  \frac{e_v}{\rho_w g}\frac{\partial\phi}{\partial t} + \frac{\partial h}{\partial t} - \nabla\cdot\boldsymbol{q} - m_b = 0,
  $$
  where: $$e_v$$ is the englacial void ratio, $$\rho_w$$ is water density (kg~m<a href="#footnotes" target="_top"><sup>-3</sup></a>), $$g$$ is gravitational acceleration (kg~m<a href="#footnotes" target="_top"><sup>-3</sup></a>), $$\phi$$ is the hydraulic potential (Pa), and $$h$$ is the sheet thickness (m). The water discharge $$\boldsymbol{q}$$ (m<a href="#footnotes" target="_top"><sup>2</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>) is given by:

  $$
  \boldsymbol{q}=-k_s\;h^{\alpha_s}\left|\nabla\phi\right|^{\beta_s-2}\nabla\phi,
  $$
  where $$k_s$$ is the sheet conductivity (m~s~kg<a href="#footnotes" target="_top"><sup>-1</sup></a>), and $$\alpha_s=$$5/4 and $$\beta_s=$$3/2 are two constant exponents. Finally, the melt source term $$m_b$$ (m~s<a href="#footnotes" target="_top"><sup>-1</sup></a>) is given by:

  $$
  m_b=\frac{G+|\boldsymbol{\tau}_b\cdot\boldsymbol{u}_b|}{\rho_{i}L},
  $$
  where $$G$$ is the geothermal heat flux (W~m<a href="#footnotes" target="_top"><sup>-2</sup></a>), $$|\boldsymbol{\tau}_b\cdot\boldsymbol{u}_b|$$ is the frictional heating (W~m<a href="#footnotes" target="_top"><sup>-2</sup></a>), for basal stress $$\boldsymbol{\tau}_b$$ (Pa), $$\rho_i$$ is ice density (kg~m<a href="#footnotes" target="_top"><sup>-3</sup></a>), and $$L$$ is latent heating (J~kg<a href="#footnotes" target="_top"><sup>-1</sup></a>).


- Sheet thickness:

  $$
  \frac{\partial h}{\partial t} = w_s - v_s.
  $$
  Here, $$w_s$$ is the cavity opening rate due to sliding over bed topography (m~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), given by:

  $$
  w_s\left(h\right) =\begin{array}{ll}\displaystyle \frac{\left|\boldsymbol{u}_b\right|}{l_r}\left(h_r-h\right), & \text{if } h<h_r\\\\0, & \text{otherwise,}\end{array}
  $$
  where $$h_r$$ and $$l_r$$ are both constants (m), and $$\boldsymbol{u}_b$$ is the basal sliding velocity vector (provided by the ice flow model). The cavity closing rate due to ice creep $$v_s$$ (m~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), is given by:

  $$
  v_s\left(h,\phi\right) = \frac{2A}{n^n}h\left|N\right|^{n-1}N,
  $$
  where $$A$$ is the basal flow parameter (Pa<a href="#footnotes" target="_top"><sup>-3</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), related to the ice hardness by $$B=A$$<a href="#footnotes" target="_top"><sup>-1/3</sup></a>, $$n$$ is the Glen flow relation exponent, and $$N= \phi_0-\phi$$ is the effective pressure. The overburden hydraulic potential is given by $$\phi_0 = \phi_m+p$$, with the ice pressure $$p = \rho_i g H$$ and elevation potential $$\phi_m = \rho_w g b$$, all of which are given in units of Pa.

##### Channel model equations

- Channel discharge (along mesh edges):

  $$
  \frac{\partial Q}{\partial s} + \frac{\Xi-\Pi}{L}\left(\frac{1}{\rho_i} - \frac{1}{\rho_w}\right) - v_c - m_c = 0,
  $$
  where $$Q$$ is the channel discharge (m<a href="#footnotes" target="_top"><sup>3</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), which evolves with respect to the horizontal coordinate along the channel $$s$$, $$\Xi$$ is the channel potential energy dissipated per unit length and time (W~m<a href="#footnotes" target="_top"><sup>-1</sup></a>), $$\Pi$$ is the channel pressure melting/refreezing (W~m<a href="#footnotes" target="_top"><sup>-1</sup></a>), $$v_c$$ is the channel closing rate (m<a href="#footnotes" target="_top"><sup>2</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>) and $$m_c$$ is the source term (m<a href="#footnotes" target="_top"><sup>2</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>). The discharge $$Q$$ is defined as:

  $$
  Q= -\underbrace{k_cS^{\alpha_c}\left|\frac{\partial\phi}{\partial s}\right|^{\beta_c-2}}_{K_c}\frac{\partial\phi}{\partial s},
  $$
  where $$k_c$$ is the channel conductivity, and $$\alpha_c=$$3 and $$\beta_c=$$2 are two exponents. The term $$v_c$$ is the closing of the channels by ice creep, and is given by:

  $$
  v_c\left(S,\phi\right) = \frac{2A}{n^n}S\left|N\right|^{n-1}N,\\
  $$
  where $$S$$ is the channel cross-sectional area (m<a href="#footnotes" target="_top"><sup>2</sup></a>). Finally, $$m_c$$, the channel source term balancing the flow of water out of the adjacent sheet, is: 

  $$
  m_c = \boldsymbol{q}\cdot\boldsymbol{n}|_{\partial{\Omega_{i1}} } +\boldsymbol{q}\cdot\boldsymbol{n}|_{\partial{\Omega_{i2}} }.
  $$
  where $$\boldsymbol{n}$$ is the normal to the channel edge.


- Channel dissipation of potential energy:

  $$
  \Xi(S,\phi)=\Biggl|Q\frac{\partial\phi}{\partial s}\Biggr| +\left|l_cq_c\frac{\partial\phi}{\partial s}\right|,
  $$
  where $$l_c$$ is the channel width (m), and $$q_c$$ is the discharge in the sheet (flowing in the direction of the channel; m<a href="#footnotes" target="_top"><sup>2</sup></a>~s<a href="#footnotes" target="_top"><sup>-1</sup></a>), given by:

  $$
  q_c\left(h,\phi\right)= -\underbrace{k_s h^{\alpha_s} \left|\frac{\partial\phi}{\partial s}\right|^{\beta_s-2}}_{K_s}\frac{\partial\phi}{\partial s},
  $$
  with $$k_s$$, $$\alpha_s$$, and $$\beta_s$$ as given above.


- Channel melt/refreeze rate:

  $$
  \Pi(S,\phi)=-c_tc_w\rho_w(Q+f l_c q_c)\frac{\partial\phi-\partial\phi_m}{\partial s},
  $$
  Here, $$c_t$$ is the Clapeyron slope (K~Pa<a href="#footnotes" target="_top"><sup>-1</sup></a>), $$c_w$$ is the specific heat capacity of water (J~kg<a href="#footnotes" target="_top"><sup>-1</sup></a>~K<a href="#footnotes" target="_top"><sup>-1</sup></a>), and $$f$$ is a switch parameter that accounts for the fact that the channel area cannot be negative, turning off the sheet flow for refreezing as $$S\rightarrow0$$, i.e.:

  $$
  f =\left\{\begin{array}{ll}1, & \text{if }S>0 \text{ or } q_c\partial(\phi-\phi_m)\partial s>0\\0, & \text{otherwise}\end{array}\right.
  $$


- Cross-sectional channel area (defined along mesh edges):

  $$
  \frac{\partial S}{\partial t} = \frac{\Xi - \Pi}{\rho_i L} - v_c.
  $$

##### Boundary conditions
Boundary conditions for the evolution of hydraulic potential $$\phi$$ are applied on the domain boundary $$\partial\Omega$$, as either a prescribed pressure or water flux. The Dirichlet boundary condition is:

$$
\phi=\phi_D  \quad\text{on} \quad\partial\Omega_D,
$$
where $$\phi_D$$ is a specific potential, and the Neumann boundary condition is:

$$
\frac{\partial\phi}{\partial n}=\Phi_N  \quad\text{on} \quad\partial\Omega_N,
$$
corresponding to the specific discharge

$$
q_N=-k_s h^{\alpha_s}|\nabla\phi|^{\beta_s-2}\Phi_N.
$$
Channels are defined only on element edges and are not allowed to cross the domain boundary, so we do not require flux conditions. Since the evolution equations for $$h$$ and $$S$$ do not contain their spatial derivatives, we do not require any boundary conditions for their evolution equations.

#### Model parameters
The parameters relevant to the GlaDS (`hydrologyglads`) solution can be displayed by running:
````
>> md.hydrology
````


- `md.hydrology.pressure_melt_coefficient`: Pressure melt coefficient ($$c_t$$) [K Pa<a href="#footnotes" target="_top"><sup>-1</sup></a>]
- `md.hydrology.sheet_conductivity`: sheet conductivity ($$k$$) [m<a href="#footnotes" target="_top"><sup>7/4</sup></a> kg<a href="#footnotes" target="_top"><sup>-1/2</sup></a>]
- `md.hydrology.cavity_spacing`: cavity spacing ($$l_r$$) [m]
- `md.hydrology.bump_height`: typical bump height ($$h_r$$) [m]
- `md.hydrology.ischannels`: Do we allow for channels? 1: yes, 0: no
- `md.hydrology.channel_conductivity`: channel conductivity ($$k_c$$) [m<a href="#footnotes" target="_top"><sup>3/2</sup></a> kg<a href="#footnotes" target="_top"><sup>-1/2</sup></a>]
- `md.hydrology.spcphi`: Hydraulic potential Dirichlet constraints [Pa]
- `md.hydrology.neumannflux`: water flux applied along the model boundary (m<a href="#footnotes" target="_top"><sup>2</sup></a> s<a href="#footnotes" target="_top"><sup>-1</sup></a>)
- `md.hydrology.moulin_input`: moulin input ($$Q_s$$) [m<a href="#footnotes" target="_top"><sup>3</sup></a> s<a href="#footnotes" target="_top"><sup>-1</sup></a>]
- `md.hydrology.englacial_void_ratio`: englacial void ratio ($$e_v$$)
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
- Ian J. Hewitt.
 Modelling distributed and channelized subglacial drainage: the
   spacing of channels.
 J. Glaciol., 57(202):302-314, 2011.

- J. F. Nye.
 Water flow in glaciers: jokulhlaups, tunnels and veins.
 J. Glaciol., 17(76):181-207, 1976.

- H. Rothlisberger.
 Water pressure in intra-and subglacial channels.
 J. Glaciol., 11(62):177-203, 1972.

- Mauro A. Werder, Ian J. Hewitt, Christian G. Schoof, and Gwenn E. Flowers.
 Modeling channelized and distributed subglacial drainage in two
   dimensions.
 J. Geophys. Res., 118:1-19, 2013.
