---
title: Transient Solution
layout: default
parent: Capabilities
---

## Transient Solution
### Physical basis
The transient solution is a combination of all the other solutions and modules that allow us to run a model forward in time (between a start time and a final time) using finite differences in time. At each time step of the simulation the following steps are performed in the order noted below,
 1. <a href="thermal">thermal solution</a>
 1. <a href="hydrology">hydrology solution</a>
 1. <a href="stress-balance">stress balance solution</a>
 1. <a href="damage">damage mechanics</a>
 1. <a href="mass-transport">mass transport solution</a>
 1. <a href="grounding-lines">grounding line migration (and geometry update)</a>
 1. <a href="gia">Glacial Isostatic Adjustment (GIA) solution</a>

Not all solutions have to be included in the transient runs, and each of these functionalities can be activated or deactivated prior to launching the simulation.

### Model parameters
The parameters relevant to the transient solution can be displayed by typing:
````
>> md.transient
````


- `md.transient.ismasstransport`: indicates whether a masstransport solution is used in the transient
- `md.transient.isstressbalance`: indicates whether a stressbalance solution is used in the transient
- `md.transient.isthermal`: indicates whether a thermal solution is used in the transient
- `md.transient.isgroundingline`: indicates whether a grounding line migration is used in the transient
- `md.transient.isgia`: indicates whether a postglacial solution is used in the transient
- `md.transient.isdamageevolution`: indicates whether damage evolution is used in the transient
- `md.transient.islevelset`: level set, not implemented yet
- `md.transient.ishydrology`: indicates whether a hydrology solution is used in the transient
- `md.transient.requested_outputs`: list of additional outputs requested

The solution will also use fields from the following classes for each of the solution used:

- `md.masstransport`: for parameters related to the masstransport solution
- `md.stressbalance`: for parameters related to the stressbalance solution
- `md.thermal`: for parameters related to the thermal solution
- `md.groundingline`: for parameters related to grounding line migration
- `md.gia`: for parameters related to the postglacial solution
- `md.damage`: for parameters related to damage evolution
- `md.hydrology`: for parameters related to the hydrology solution
- `md.initialization`: for initial values of model fields (velocity, temperature, ...)
- `md.timestepping`: for parameters related to time stepping (initial time, final time, length of time steps, ...)

#### Time stepping
Each solution requested is computed at each time step. The time step has either a fixed duration (specified by the user before the simulation is launched) or a varying duration based on the CFL (Courant–Friedrichs–Lewy) condition (necessary condition for the stability of certain partial differential equations).

The parameters relevant to the time stepping can be displayed by running:
````
>> md.timestepping
````


- `md.timestepping.start_time`: simulation starting time (year)
- `md.timestepping.final_start`: final time to stop the simulation (year)
- `md.timestepping.time_step`: length of time steps (year)
- `md.timestepping.time_adapt`: to indicate if the CFL condition is used to define time step?
- `md.timestepping.cfl_coefficient`: coefficient applied to cfl condition
- `md.timestepping.interp_forcings`: interpolate in time between requested forcing values? (0 or 1)

### Forcing a transient
To specify a transient forcing, the user must add a time value to the end (i.e. in the `end + 1` position) of the variable to be forced. This means that a transient forcing will no longer be a single column of length `n`. Instead, it will be a matrix (or a series of columns), and each column will be of length `n + 1`.

For example, let `smb` be values of surface mass balance. Below, we impose `smb` at year 10 and then impose a decrease of 1 m/yr in surface mass balance everywhere at year 20:
````
>> md.smb.mass_balance = [smb smb - 1];
>> md.smb.mass_balance = [md.smb.mass_balance; [10 20]];
````

Prior to first and after last imposed time, ISSM will impose constant surface mass balance values. In the example above, the surface mass balance is assumed constant prior to year 10, and again after year 20. Forcing values will be equal to `smb` prior to year 10 and `smb - 1` after year 20.

Between years 10 and 20, ISSM will treat all forcings according to the value set in the time stepping parameter `interp_forcings`.

By default, `md.timestepping.interp_forcings = 1`. This means that between the user-imposed times, forcings are linearly interpolated. For the example above, the model will linearly increase surface mass balance from `smb` to `smb - 1` between years 10 and 20.

The user must set `md.timestepping.interp_forcings = 0` to turn this feature off and impose a step-wise forcing. When `interp_forcings = 0`, the forcing value will change only at the times designated by the user. After the last user-specified time, the forcing will remain constant. In the example above, the surface mass balance will be equal to `smb` up until time 20. At time 20, the surface mass balance will be changed to `smb - 1`, and will remain at these values until the end of the simulation.

### Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Transient');
````
The first argument to `solve` is the model, the second is the nature of the simulation one wants to run.

