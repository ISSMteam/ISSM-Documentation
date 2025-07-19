---
title: Modeling Jakobshavn Isbr&#230;
layout: default
parent: Tutorials
---

## Modeling Jakobshavn Isbr\ae
### Goals

- Construct a 2-dimensional model of Jakobshavn Isbr&#230;, West Greenland
- Follow a simple tutorial exercise: create and parametrize an ISSM model
- Use ISSM to invert for a basal friction parameter on a real-world domain

Change into `<ISSM_DIR>/examples/Jakobshavn/` to do this tutorial.

### Introduction
In this tutorial, we construct a 2-dimensional model of Jakobshavn Isbr&#230;, West Greenland, and use it to invert for the basal friction parameter.

#### Download
For this tutorial, we will use a dataset from the <a href="https://scholarworks.umt.edu/cgi/viewcontent.cgi?params=/context/cs_pubs/article/1020/&path_info=Ice_sheet_model.pdf" target="_blank">SeaRISE Initiative</a>: `Greenland_5km_v1.2.nc`. This data should be saved in the `examples/Data` directory (see 
 <a href="datasets">dataset download</a> page).

### runme file
The `runme.m` file in `<ISSM_DIR>/examples/Jakobshavn/` is a list of commands to be run in sequence at the MATLAB command prompt. The tutorial is decomposed into 4 steps:

1. Mesh generation (anisotropic adaptation)
1. Model parameterization (using the SeaRISE dataset)
1. Launch of the inversion for basal friction
1. Plotting of the results
We will follow these steps one by one by changing the selected step at the top in `runme.m`.

### Step 1: Mesh generation
Open `runme.m` and make sure that the first step is activated:
````
steps = [1];
````
In the first step, we create a triangle mesh with 2,000 meter resolution using the domain outline file `Domain.exp`. We then interpolate the observed velocity data onto the newly-created mesh. We use these observations to refine the mesh accordingly using `bamg`. In regions of fast flow we apply 1,200 m resolution, and in slow flowing areas we increase the resolution to up to 15 km:
````
md = bamg(md, 'hmin', 1200, 'hmax', 15000, 'field', vel, 'err', 5);
````

Go to `trunk/` and launch MATLAB and then go to `examples/Jakobshavn/`:
````
$ cd ${ISSM_DIR}
$ matlab
>> cd examples/Jakobshavn/
````

Then execute the first step:
````
>> runme
	Step 1: Mesh creation
		  Anisotropic mesh adaptation
		  WARNING: mesh present but no geometry found. Reconstructing...
		     new number of triangles = 3017
````

### Step 2: Model parameterization
In this step parameterize the model. We set for example the geometry and ice material parameters. We use the `setmask` command to define grounded and floating areas. All ice is considered grounded for now. Type `help setmask` to display documentation on how to use this command. The model is then parameterized using the `Jks.par` file. We soften the glacier's shear margins by reducing the model's ice hardness, <img src="https://latex.codecogs.com/svg.latex?B" alt="Equation 1">, in the area outlined by `WeakB.exp` to a factor 0.3.

Open `runme.m` and make sure that the second step is activated: `steps = [2];`
````
>> runme
   Step 2: Parameterization
   Loading SeaRISE data from NetCDF
   Interpolating thicknesses
   Interpolating bedrock topography
   Constructing surface elevation
   Interpolating velocities
   Interpolating temperatures
   Interpolating surface mass balance
   Construct basal friction parameters
   Construct ice rheological properties
   Set other boundary conditions
      boundary conditions for stressbalance model: spc set as observed velocities
      no smb.precipitation specified: values set as zero
      no basalforcings.melting_rate specified: values set as zero
      no balancethickness.thickening_rate specified: values set as zero
````

### Step 3: Control method
In the parameterization step, we applied a uniform friction coefficient of 30. Here, we use the basal friction coefficient as a control so that the modeled surface velocities match the observed ones. The mismatch between observation and modeled surface velocities is quantified by the value of a cost function. The type of cost function determines to a large degree the result of the inversion process. Different cost functions are available, type md.inversion to see a list of available cost functions:
````
Available cost functions:
101: SurfaceAbsVelMisfit
102: SurfaceRelVelMisfit
103: SurfaceLogVelMisfit
104: SurfaceLogVxVyMisfit
105: SurfaceAverageVelMisfit
201: ThicknessAbsMisfit
501: DragCoefficientAbsGradient
502: RheologyBbarAbsGradient
503: ThicknessAbsGradient
````
Inverting for basal drag, we can use the cost functions that start with a 1. The cost functions can be combined and weighted individually:
````
%Cost functions
md.inversion.cost_functions = [101 103];
md.inversion.cost_functions_coefficients = ones(md.mesh.numberofvertices, 2);
md.inversion.cost_functions_coefficients(:, 1) = 40;
md.inversion.cost_functions_coefficients(:, 2) = 1;
````
Our cost function is thus the sum of ``SurfaceAbsVelMisfit'`, the absolute of the velocity misfit, and ``SurfaceLogVelMisfit'`, the logarithm of the velocity misfit. We weigh the first cost function 40 times more than the latter one.

Open `runme.m`, make sure that the third step is activated (`steps = [3];`), then run `runme.m`:
````
>> runme
	Step 3: Control method friction
		  checking model consistency
		  marshalling file Jakobshavn.bin
		  uploading input file and queueing script
		  launching solution sequence on remote cluster
		  Launching solution sequence
		  call computational core:
		     preparing initial solution

			     control method step 1/20
				  ....
````

### Step 4: Display results
Here, we display the results. Open `runme.m` and make sure that step number 4 is activated. Your results should look like this:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/docs/using-issm/tutorials/jks/JKSModel.png" alt="Figure 1: JKSModel"></div>
