---
title: Modeling the Greenland Ice Sheet Using IceBridge Data
layout: default
parent: Tutorials
has_children: false
has_toc: false
---

## Modeling the Greenland Ice Sheet Using IceBridge Data
### Goals

- Follow an example of how to improve a coarse Greenland model by adding higher resolution Operation Icebridge (OIB) data
- Learn how to use the ISSM meshing tools to refine the Jakobshavn Isbr&#230; (JI) basin
- Learn how to insert higher resolution bedrock and surface elevation data from the OIB campaign into the model within the JI basin

Go to `<ISSM_DIR>/examples/IceBridge/` to do this tutorial.

### Introduction
Tutorial steps to be taken:

- Refine the Greenland mesh using given JI outline.
- Parameterize the model, and include the high-resolution OIB bedrock and surface data.
- Plot the ice base and surface data.
- Stress Balance: run 2 inverse method runs to solve for control drag (20 steps recommended).
- Transient: launch 20 year runs, with coarse and refined bedrock and surface elevation data.
- Plot the transient results.

### Mesh
We modify the experiment from 
<a href="./greenland" target="_top">the Greenland SeaRISE tutorial</a>,
and improve from there. Run the first step in `runme.m` file to mesh the Greenland domain (similar to the previous tutorial), and plot the model. Note that the code in step 1 is interrupted after making the default mesh. Plot the model:
````
>> plotmodel(md, 'data', 'mesh');
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/Mesh.png" alt="Figure 1: Mesh"></div>Now, we want to refine the mesh in JI area. An outline of this area `Jak_outline.exp` can be found in the current directory. Use the exptool command to view this outline:
````
>> exptool('Jak_outline.exp');
````

Next, we modify the `bamg` command by imposing a 3 km resolution within the JI area using `hmaxVertices`. Note that, to implement the changes noted above you must deactivate the first occurrence of the `bamg` command in step 1, as well as the `return` command. Do this by commenting out these lines, and running step 1 again. Plot the results.

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/Mesh2.png" alt="Figure 2: Mesh2"></div>Use MATLAB's zoom tool in the figure to make a close-up of the JI domain.
### Parameterization
We want to include high-resolution bedrock and surface elevation data acquired in the OIB mission. The data is accessible on University of Kansas' CReSIS <a href="https://data.cresis.ku.edu/data/grids/old_versions/Jakobshavn_2008_2011_Composite.zip" target="_blank">Open Polar Radar Data Products page</a>. Save the file in the `../Data/` directory.

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/Jakobshavn.png" alt="Figure 3: Jakobshavn"></div>To do this, the bedrock data is read, transformed into a usable grid, and interpolated to the mesh in the parameter file `Greenland.par`:
````
%Reading IceBridge data for Jakobshavn
disp('      reading IceBridge Jakobshavn bedrock');
fid  = fopen('../Data/Jakobshavn_2008_2011_Composite/grids/Jakobshavn_2008_2011_Composite_XYZGrid.txt');
titles = fgets(fid); 
data = fscanf(fid, '%g,%g,%g,%g,%g', [5 266400])';
fclose(fid);

[xi, yi] = ll2xy(md.mesh.lat, md.mesh.long, +1, 45, 70);
bed  = flipud(reshape(data(:, 5), [360 740])); bed(find(bed == -9999)) = NaN;
bedy = flipud(reshape(data(:, 1), [360 740]));
bedx = flipud(reshape(data(:, 2), [360 740]));

%Insert Icebridge bed and recalculate thickness
bed_jks = InterpFromGridToMesh(bedx(1, :)', bedy(:, 1), bed, xi, yi, NaN);
in = ContourToMesh(md.mesh.elements, md.mesh.x, md.mesh.y, ...
	'Jak_grounded.exp', 'node', 1);
bed_jks(~in) = NaN;
pos = find(~isnan(bed_jks));
md.geometry.base(pos) = bed_jks(pos);
md.geometry.thickness = md.geometry.surface - md.geometry.base;
````

Modify the `Greenland.par` file such that the surface elevation data is also included for the JI area.

#### Solution
````
%Reading IceBridge data for Jakobshavn
disp('      reading IceBridge Jakobshavn bedrock');
fid = fopen('../Data/Jakobshavn_2008_2011_Composite_XYZGrid.txt');
titles = fgets(fid); 
data = fscanf(fid,'%g,%g,%g,%g,%g',[5 266400])';
fclose(fid);

[xi, yi] = ll2xy(md.mesh.lat, md.mesh.long, +1, 45, 70);
bed = flipud(reshape(data(:, 5), [360 740])); bed(find(bed == -9999)) = NaN;
surf = flipud(reshape(data(:, 4), [360 740])); surf(find(surf == -9999)) = NaN;
bedy = flipud(reshape(data(:, 1), [360 740]));
bedx = flipud(reshape(data(:, 2), [360 740]));

%Insert Icebridge bed and recalculate thickness
bed_jks = InterpFromGridToMesh(bedx(1, :)', bedy(:, 1), bed, xi, yi, NaN);
surf_jks = InterpFromGridToMesh(bedx(1, :)', bedy(:, 1), surf, xi, yi, NaN);
in = ContourToMesh(md.mesh.elements, md.mesh.x, md.mesh.y, ...
	'Jak_grounded.exp', 'node', 1);
bed_jks(~in) = NaN;
surf_jks(~in) = NaN;
pos = find(~isnan(bed_jks));
md.geometry.base(pos) = bed_jks(pos);
md.geometry.surface(pos) = surf_jks(pos);
md.geometry.thickness = md.geometry.surface - md.geometry.base;
````

Next, let's plot the surface elevation, the ice thickness, and base:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/SurfaceElevation.png" alt="Figure 4: SurfaceElevation"></div><span style="display:block;width:100%;text-align:center"><small>plotmodel(md, 'data', md.geometry.surface)</small></span>

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/Thickness.png" alt="Figure 5: Thickness"></div><span style="display:block;width:100%;text-align:center"><small>plotmodel(md, 'data', md.geometry.thickness)</small></span>

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/Base.png" alt="Figure 6: Base"></div><span style="display:block;width:100%;text-align:center"><small>plotmodel(md, 'data', md.geometry.base)</small></span>To plot the difference in the ice base topography between SeaRISE and OIB datasets do (1) modify the parameterization step in your `runme.m` file by commenting out all the above lines which insert the OIB data, and change the name the model is saved under from `Greenland.Parameterization2` to `Greenland.Parameterization` and run step 2 again. A difference in the fields can be plotted using:
````
>> md2 = loadmodel('Models/Greenland.Parameterization2')
>> md = loadmodel('Models/Greenland.Parameterization')
>> plotmodel(md, 'data', md2.geometry.base - md.geometry.base)
````
Zoom to the JI basin for better visibility.

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/Differences.png" alt="Figure 7: Differences"></div>### Stress Balance
We now use inverse control methods to solve for Greenland friction coefficient. The velocity map below contains some gaps. Exclude the gaps from the inversion by creating a new `*.exp` file that outlines all the gaps in velocity data using the exptool:
````
>> exptool('data_gaps.exp')
````

Exclude these data gaps in the inversion by giving them zero weight during the inversion process:
````
in = ContourToMesh(md.mesh.elements, md.mesh.x, md.mesh.y, 'data_gaps.exp', 'node', 1);
md.inversion.cost_functions_coefficients(find(in), 1) = 0.0;
md.inversion.cost_functions_coefficients(find(in), 2) = 0.0;
````

Launch the stressbalance simulation, and plot velocity and basal friction coefficient. A logarithmic
plot scale reveals more highlights of the velocity field structure:
````
>> plotmodel(md, 'data', md.results.StressbalanceSolution.Vel, 'log', 10, 'caxis', [0.5 5000]);
>> plotmodel(md, 'data', md.results.StressbalanceSolution.FrictionCoefficient);
````

They should look like this:

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/using-issm/tutorials/icebridge/Velocity2.png" alt="Figure 8: Velocity2"><img style="float:left;width:50.00%" src="/assets/img/using-issm/tutorials/icebridge/FrictCoef.png" alt="Figure 8: FrictCoef"></div>Even at this coarse resolution we can identify the high friction values inland and lower values towards the coast, which may be related to the basal thermal regime of the ice sheet.

### Transient
Finally, do a transient run (step 4) for 20 years, and decrease the surface mass balance linearly by 1 m w.e./yr over the last 10 years (`ncdata = '../Data/Greenland_5km_dev1.2.nc';`).
````
%Set surface mass balance
x1 = ncread(ncdata, 'x1');
y1 = ncread(ncdata, 'y1');
smb = ncread(ncdata, 'smb');
smb = InterpFromGridToMesh(x1, y1, smb', md.mesh.x, md.mesh.y, 0) * 1000 / md.materials.rho_ice;
smb = [smb smb smb-1.0];
md.smb.mass_balance = [smb; 1 10 20];
````

Your results will be located in `md.results.TransientSolution`. Plot your results using step 5. First, plot the initial plan view of velocity, surface mass balance, thickness, and surface. They should look like this:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/TransientSolution.png" alt="Figure 9: TransientSolution"></div>You can plot time series of surface mass balance, mean velocity and ice volume:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/icebridge/MassVelocityVolume.png" alt="Figure 10: MassVelocityVolume"></div>
### Results
Well done! Here are some suggestions on what to explore further:

- How would you make a plot of time series of results from the SeaRISE and IceBridge experiments?
- How would you make a plot of the difference between final and initial ice thickness?

