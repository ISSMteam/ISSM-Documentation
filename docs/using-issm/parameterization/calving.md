---
title: Calving
layout: default
parent: Parameterization
math: mathjax3
---

# Calving
## Physical basis
Calving (frontal ablation of icebergs) is one of the two processes, together with frontal melting, that determine the position of the ice front through time. In ISSM, calving is not resolved as a fracture process but is parameterized: at every time step, a calving rate $$c$$ [m/a] is computed everywhere along the ice front, from one of several calving laws described below. This rate then feeds into the level-set advection equation that tracks the ice front position (see the <a href="../capabilities/levelset">Ice Front Migration (Level Set Method)</a> page).

The calving law is selected by assigning the corresponding class to `md.calving`. All laws share the same enabling switch:
````
>> md.transient.ismovingfront = 1;
````

### Default/prescribed calving rate (calving)
The simplest option prescribes the calving rate directly, uniformly or spatially/temporally varying:
````
>> md.calving = calving();
````

- `md.calving.calvingrate`: calving rate at each vertex [m/a] (can be a time series)

### Von Mises stress calving law (calvingvonmises)
This law, from [<a href="#references">*Morlighem2016*</a>], relates the calving rate to the tensile von Mises stress $$\sigma_{vm}$$ and the ice velocity:

$$
c = \left|{\bf v}\right| \frac{\sigma_{vm}}{\sigma_{max}}
$$

where $$\sigma_{max}$$ is a threshold stress (calibrated separately for grounded and floating ice). No calving occurs where the bed is above sea level.
````
>> md.calving = calvingvonmises();
````

- `md.calving.stress_threshold_groundedice`: $$\sigma_{max}$$ applied to grounded ice [Pa] (default: $$10^6$$)
- `md.calving.stress_threshold_floatingice`: $$\sigma_{max}$$ applied to floating ice [Pa] (default: $$150\times10^3$$)
- `md.calving.min_thickness`: minimum ice thickness below which no ice is allowed [m] (disabled by default)

`calvingdev2` implements the same von Mises law, but additionally requires the ice tongue to reach a minimum height above flotation before it is allowed to calve (`md.calving.height_above_floatation`).

### Levermann calving law (calvinglevermann)
This law, from [<a href="#references">*Levermann2012*</a>], makes the calving rate proportional to the product of the principal strain rates along and across the flow direction, $$\dot{\varepsilon}_{\parallel}$$ and $$\dot{\varepsilon}_{\perp}$$:

$$
c = k \, \dot{\varepsilon}_{\parallel}\, \dot{\varepsilon}_{\perp}
$$

evaluated only where both strain rates are positive (extensional in both directions) and the bed is below sea level.
````
>> md.calving = calvinglevermann();
````

- `md.calving.coeff`: proportionality coefficient $$k$$ (default: $$2\times10^{13}$$)

### Crevasse-depth calving law (calvingcrevassedepth)
This law follows the crevasse-penetration concept of [<a href="#references">*Nick2010,Otero2010*</a>]: calving occurs where the combined depth of surface and basal crevasses reaches the full ice thickness. Surface and basal crevasse depths are computed from a balance between the opening (tensile) stress and the ice overburden/water pressure resisting crevasse penetration. `md.calving.crevasse_opening_stress` selects how the opening stress is estimated:

- 0: tensile deviatoric stress in the flow direction [<a href="#references">*Otero2010*</a>]
- 1: maximum principal stress [<a href="#references">*Todd2018*</a>]
- 2: a buttressing-based formulation

````
>> md.calving = calvingcrevassedepth();
````

- `md.calving.crevasse_opening_stress`: opening-stress formulation, 0, 1, or 2 (see above)
- `md.calving.crevasse_threshold`: fraction of the total ice thickness that the combined crevasse depth must reach for calving to occur (e.g., 0.75 for 75% of the thickness)
- `md.calving.water_height`: water height filling surface crevasses [m], which reduces the resisting stress and promotes deeper crevasse penetration (hydrofracture)

### Height above flotation (calvinghab)
Calving occurs wherever the ice tongue/shelf thins below a prescribed fraction of the flotation thickness at the terminus:
````
>> md.calving = calvinghab();
````

- `md.calving.flotation_fraction`: fraction of the flotation thickness allowed at the terminus before calving (default: 0.15)

### Minimum thickness (calvingminthickness)
Ice thinner than a prescribed threshold is removed from the domain:
````
>> md.calving = calvingminthickness();
````

- `md.calving.min_thickness`: minimum ice thickness allowed [m] (default: 100)

### Pollard and DeConto calving law (calvingpollard)
This law, from [<a href="#references">*Pollard2015*</a>], is based on a critical ratio between crevasse (or hydrofracture) depth and ice thickness:
````
>> md.calving = calvingpollard();
````

- `md.calving.rc`: critical depth/thickness ratio (default: 0.75)

### CalvingMIP laws (calvingcalvingmip)
This class implements the standardized calving laws and coefficients used in the CalvingMIP intercomparison experiments:
````
>> md.calving = calvingcalvingmip();
````

- `md.calving.experiment`: CalvingMIP experiment number
- `md.calving.min_thickness`: minimum ice thickness allowed [m]

## Frontal melt (undercutting)
In addition to calving, submarine/frontal melting contributes to the retreat (or slows the advance) of marine-terminating fronts. This is controlled by `md.frontalforcings`, independently of the calving law:
````
>> md.frontalforcings = frontalforcings();
````

- `md.frontalforcings.meltingrate`: frontal melt rate at each vertex [m/a] (can be a time series)
- `md.frontalforcings.ablationrate`: total frontal ablation rate [m/a] (calving and melting combined), used instead of `meltingrate` when only the combined rate is known

Alternatively, `frontalforcingsrignot` computes the frontal melt rate from ocean thermal forcing and subglacial discharge, following the parameterization of [<a href="#references">*Rignot2016*</a>]:
````
>> md.frontalforcings = frontalforcingsrignot();
````

- `md.frontalforcings.basin_id`: basin number assigned to each element [unitless]
- `md.frontalforcings.num_basins`: number of basins the domain is partitioned into [unitless]
- `md.frontalforcings.subglacial_discharge`: subglacial discharge for each basin [$$m^3$$/d]
- `md.frontalforcings.thermalforcing`: ocean thermal forcing [&#8451;]

## Running a simulation
To turn on calving and ice front migration in a simulation, use:
````
>> md.transient.ismovingfront = 1;
````
This also requires setting up the level-set function that tracks the ice front position, described on the <a href="../capabilities/levelset">Ice Front Migration (Level Set Method)</a> page. Then run the transient simulation:
````
>> md = solve(md, 'Transient');
````

# References
- M. Morlighem, J. Bondzio, H. Seroussi, E. Rignot, E. Larour, A. Humbert, and S. Rebuffi.
 Modeling of Store Gletscher's calving dynamics, West Greenland, in response to ocean thermal forcing.
 Geophys. Res. Lett., 43:2659-2666, 2016.

- A. Levermann, T. Albrecht, R. Winkelmann, M. A. Martin, M. Haseloff, and I. Joughin.
 Kinematic first-order calving law implies potential for abrupt ice-shelf retreat.
 Cryosphere, 6:273-286, 2012.

- F. M. Nick, C. J. Van der Veen, A. Vieli, and D. I. Benn.
 A physically based calving model applied to marine outlet glaciers and implications for the glacier dynamics.
 J. Glaciol., 56(199):781-794, 2010.

- J. Otero, F. J. Navarro, C. Martin, M. L. Cuadrado, and M. I. Corcuera.
 A three-dimensional calving model: numerical experiments on Johnsons Glacier, Livingston Island, Antarctica.
 J. Glaciol., 56(196):200-214, 2010.

- J. Todd, P. Christoffersen, T. Zwinger, P. Raback, N. Chauche, D. Benn, A. Luckman, J. Ryan, N. Toberg,
   D. Slater, and A. Hubbard.
 A Full-Stokes 3-D Calving Model Applied to a Large Greenlandic Glacier.
 J. Geophys. Res. - Earth Surface, 123(3):410-432, 2018.

- D. Pollard, R. M. DeConto, and R. B. Alley.
 Potential Antarctic Ice Sheet retreat driven by hydrofracturing and ice cliff failure.
 Earth Planet. Sci. Lett., 412:112-121, 2015.

- E. Rignot, Y. Xu, D. Menemenlis, J. Mouginot, B. Scheuchl, X. Li, M. Morlighem, H. Seroussi, M. van den
   Broeke, I. Fenty, C. Cai, L. An, and B. de Fleurian.
 Modeling of ocean-induced ice melt rates of five west Greenland glaciers over the past two decades.
 Geophys. Res. Lett., 43(12):6374-6382, 2016.

- J. H. Bondzio, H. Seroussi, M. Morlighem, T. Kleiner, M. Ruckamp, A. Humbert, and E. Y. Larour.
 Modelling calving front dynamics using a level-set method: application to Jakobshavn Isbrae, West Greenland.
 Cryosphere, 10(2):497-510, 2016.
