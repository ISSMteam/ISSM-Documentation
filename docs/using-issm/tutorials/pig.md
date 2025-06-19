---
title: Modeling Pine Island Glacier
layout: default
parent: Tutorials
has_children: false
has_toc: false
---

## Modeling Pine Island Glacier
### Goals

- Model Pine Island Glacier
- Follow an example of how to create a mesh and set up the floating ice shelf of a real-world glacier
- Use observational data to parameterize the model
- Learn how to use inversions to infer basal friction and plot the results

### Introduction
In this example, the main goal is to parameterize and model a real glacier. In order to build an operational simulation of Pine Island Glacier, we will follow these steps:

- Define the model region
- Create a mesh
- Apply masks
- Parameterize the model
- Invert friction coefficient
- Plot results
- Run higher-order simulation

Files needed for this tutorial can be found in `<ISSM_DIR>/examples/Pig/`. The `runme.m` file contains the structure of the simulation, while the `.par` file includes most parameters needed for the model set-up. The `.exp` files are shape files that define geometric boundaries of the simulation.

Observed datasets needed for the parameterization also need to be 
 <a href="datasets">downloaded</a>.
### Setting-up domain outline
We first draw the domain outline of Pine Island Glacier based on observed velocity map. First, run `PigRegion.m` in MATLAB. It produces a figure with the observed velocities:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/using-issm/tutorials/pig/exptool.png" alt="Figure 1: exptool"></div>
You can then use the `exptool` to draw the model domain:
````
>> exptool('PigDomain.exp')
````

NOTE: if you have not 
 <a href="datasets">downloaded the datasets</a>,
you will get the following error:
````
Could not open ../Data/Antarctica_ice_velocity.nc
````
If this occurs, go into the `Data` directory and run the script to download the datasets. You will not be able to proceed until you do so.

This example shows you how to create your own model boundary, but for the rest of the tutorial, we will be using the provided domain outline, which is `ModelDomain.bkp`. Rename this file `ModelDomain.exp` (which will, effectively, erase your contour):
````
>>!mv DomainOutline.bkp DomainOutline.exp
````
### Mesh
The first step is to create the mesh of the model domain.

In the `runme.m` file, the mesh is generated in a multi-step process. Open the `runme.m` file and make sure that the variable `steps`, at the top of the file, is set to `steps = [1]`. In the code, you will see that in step 1 the following actions are implemented:


- a uniform mesh is created
- the mesh is then refined using anisotropic mesh refinement. We use the surface velocity as a metric
- Set the mesh parameters
- Plot the model and load the velocities from `http://nsidc.org/data/nsidc-0484.html`
- Get the necessary data to build up the velocity grid
- Get velocities (note: You can use `ncdisp('file')` to see an `ncdump`)
- Interpolate the velocities onto a coarse mesh. Adapt the mesh to minimize error in velocity interpolation
- Plot the mesh
- Save the model

Execute the `runme.m` file to perform step 1. You should see the following figure:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/using-issm/tutorials/pig/Mesh.png" alt="Figure 2: Mesh"></div>### Mask
The second step of the `runme.m` creates the masks required to specify where there is ice in the domain, and where the ice is grounded.

First, we specify where the ice is grounded and floating in the domain:

- The field `md.mask.ocean_levelset` contains this information
  - Ice is grounded if `md.mask.ocean_levelset` is positive
  - Ice is floating if `md.mask.ocean_levelset` is negative
  - The grounding line lies where `md.mask.ocean_levelset` equals zero

Then we specify where ice is present:

- The field `md.mask.ice_levelset` contains this information
  - Ice is present if `md.mask.ice_levelset` is negative
  - There is no ice if `md.mask.ice_levelset` is positive
  - The ice front lies where `md.mask.ice_levelset` equals zero

Open `runme.m` and set `steps = [2]`. Now, execute the `runme.m` file to run step 2.

After executing step 2, you should see the following figure that represents the mask:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/using-issm/tutorials/pig/Mask2.png" alt="Figure 3: Mask2"></div>### Parameterization
Parameterization of models is usually done through a different file (`Pig.par`). Parameters which are unlikely to change for a given set of experiments are set there to lighten the `runme.m` file. In this example we use SeaRISE data to parameterize the following model fields:

- Geometry
- Initialization parameters
- Material parameters
- Forcings
- Friction coefficient
- Boundary conditions

Some parameters are adjusted in `runme.m`, as they are likely to be changed during the simulation. This is the case for the stress balance equation that is set-up using `setflowequation`.

Now, change the `runme.m` file as before, and run step 3 to perform the Parameterization.
### Inversion of basal friction
The friction coefficient is inferred from the surface velocity using the following friction law:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\mathbf{ \tau }_b = -\beta^{2} N^r \|\mathbf{v_b}\|^{s-1}\mathbf{v_b}" alt="Equation 1"></div>


- <img src="https://latex.codecogs.com/svg.latex?\mathbf{ \tau }_b" alt="Equation 2"> : Basal drag
- <img src="https://latex.codecogs.com/svg.latex?N" alt="Equation 3">: Effective pressure
- <img src="https://latex.codecogs.com/svg.latex?v_b" alt="Equation 4">: Basal velocity (equal surface in SSA approximation)
- <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 6">: Exponent (equals <img src="https://latex.codecogs.com/svg.latex?q/p" alt="Equation 5"> of the parameter file)
- <img src="https://latex.codecogs.com/svg.latex?s" alt="Equation 8">: Exponent (equals <img src="https://latex.codecogs.com/svg.latex?1/p" alt="Equation 7"> of the parameter file)

The procedure for the inversion is as follows:

- Velocity is computed from the SSA approximation
- Misfit of the cost function is computed
- Friction coefficient is modified following the gradient of the cost function

All the parameters that can be adjusted for the inversion are in `md.inversion`.

Run step 4 and look at the results, they should be similar to the figure below:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/using-issm/tutorials/pig/ControlMethod.png" alt="Figure 4: ControlMethod"></div>### Plot results
Plotting ability are mainly based on `plotmodel` for simple graphs. However, you can also use or create your own routines.

Change the step to 5 and run the simulation. It should create the following figure:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/using-issm/tutorials/pig/Plot.png" alt="Figure 5: Plot"></div>### Higher Order (HO) Ice Flow Model
The last step of this tutorial is to run a forward model of Pine Island Glacier with the Higher-Order stress balance approximation.

The following steps need to be performed in `step 7` of the `runme.m` file:

- Load the previous step
  - Model to load is `Control_drag`
- Disable the inversion process
  - Change `iscontrol` to zero the inversion flag (`md.inversion`)
- Extrude the mesh
  - `help extrude`
  - Keep the number of layers low to avoid long computational time
- Change the stress balance approximation
  - Use the function `setflowequation`
- Solve
  - We are still solving for a `StressBalanceSolution`
- Save the model as in the preceding steps

If you need help, the solution is provided below.

Step 7 provides a comparison of the Shelfy-Stream and Higher-Order approximations. The following figure should be created if you run step 7:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/using-issm/tutorials/pig/VelocityComparison.png" alt="Figure 6: VelocityComparison"></div>### Solution for step 6
````
if any(steps == 6)
	md = loadmodel('./Models/PIG_Control_drag');
	md.inversion.iscontrol = 0;

	disp('   Extruding mesh')
	number_of_layers = 3;
	md = extrude(md, number_of_layers, 1);

	disp('   Using HO Ice Flow Model')
	md = setflowequation(md, 'HO', 'all');

	md = solve(md, 'Stressbalance');

	save ./Models/PIG_ModelHO md;
end
````

