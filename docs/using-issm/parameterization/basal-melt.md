---
title: Basal Melt
layout: default
parent: Parameterization
math: mathjax3
---

# Basal Melt
## Physical basis
This model is described in [<a href="#references">*Reese2018*</a>] and [<a href="#references">*Pelle2019*</a>]. It consists of calculating basal melt rates under ice shelves based only on far field ocean temperature and salinity.

### PICO
PICO is a box model of ocean circulation under ice shelf cavities. Each ice shelf is divided into a set of boxes, and the temperature ($$T_k$$) and salinity ($$S_k$$) of each box is given by:

$$
\begin{array}{l c l}\displaystyle q\left(T_{k-1} - T_k\right) - A_k m_k \frac{\rho_i}{\rho_w} \frac{L}{c_p}& =& 0\\\\q\left(S_{k-1} - S_k\right) - A_k m_k S_k & =& 0\end{array}
$$
where:

- $$A_k$$ is the surface area of box $$k$$
- $$m_k$$ is the melt rate in box $$k$$
- $$q = C \left(\rho_0 - \rho_1\right)$$ is the strength of the overturning circulation


<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/docs/using-issm/parameterization/basal-melt/pico.png" alt="Figure 1: pico"></div><span style="display:block;width:100%;text-align:center"><small>Schematic view of the PICO model (taken from [<a href="#references">*Reese2018*</a>]).</small></span>
### PICOP
PICOP is described in [<a href="#references">*Pelle2019*</a>]. The idea is to use PICO to calculate the temperature and salinity in each box, but instead of using PICO's calculated melt, use these quantities to drive a plume model from [<a href="#references">*Lazeroms2018*</a>]:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/docs/using-issm/parameterization/basal-melt/picop.png" alt="Figure 2: picop"></div><span style="display:block;width:100%;text-align:center"><small>Melt calculation in PICOP, adapted from [<a href="#references">*Pelle2019*</a>].</small></span>
## Model parameters
To activate this melt parameterization, you need to use the class `basalforcingspico`:
````
>> md.basalforcings = basalforcingspico();
````
The parameters relevant to the calculation can be displayed by running:
````
>> md.basalforcings
````


- `md.basalforcings.num_basins`: number of basins the model domain is partitioned into [unitless]
- `md.basalforcings.basin_id`: basin number assigned to each node [unitless]
- `md.basalforcings.maxboxcount`: maximum number of boxes initialized under all ice shelves
- `md.basalforcings.overturning_coeff`: overturning strength [$$m^3$$/s]
- `md.basalforcings.gamma_T`: turbulent temperature exchange velocity [m/s]
- `md.basalforcings.farocean_temperature`: depth-averaged ocean temperature in front of the ice shelf for basin i [K]
- `md.basalforcings.farocean_salinity`: depth-averaged ocean salinity in front of the ice shelf for basin i [psu]
- `md.basalforcings.isplume`: boolean to use buoyant plume melt rate parameterization from Lazeroms et al., 2018 (PICOP, default false)

## Example: the Amundsen Sea
To set up a model of the Amundsen Sea using PICOP, we only need one basin:
````
>> md.basalforcings = basalforcingspico();
>> md.basalforcings.basin_id = ones(md.mesh.numberofelements, 1);
>> md.basalforcings.num_basins = 1;
````
We generally do not need to have more than 5 boxes per ice shelf:
````
>> md.basalforcings.maxboxcount = 5;
````
and finally, we can prescribe the far field ocean properties (they can be time series):
````
>> md.basalforcings.farocean_temperature = [0.47 + 273.15]; %0.47C converted to K
>> md.basalforcings.farocean_salinity = [34.73]; %PSU
````
To activate PICOP instead of PICO:
````
>> md.basalforcings.isplume = 1;
````
To run a simulation, use the following command:
````
>> md = solve(md, 'Transient');
````


# References
- W. M. J. Lazeroms, A. Jenkins, G. H. Gudmundsson, and R. S. W. van de Wal.
 Modelling present-day basal melt rates for Antarctic ice shelves
   using a parametrization of buoyant meltwater plumes.
 Cryosphere, 12:49-70, 2018.

- T. Pelle, M. Morlighem, and J. H. Bondzio.
 Brief communication: PICOP, a new ocean melt parameterization under
   ice shelves combining PICO and a plume model.
 Cryosphere, 13(3):1043-1049, 2019.

- R. Reese, T. Albrecht, M. Mengel, X. Asay-Davis, and R. Winkelmann.
 Antarctic sub-shelf melt rates via PICO.
 Cryosphere, 12:1969-1985, 2018.
