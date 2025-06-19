---
title: Parameter Files
layout: default
parent: Parameterization
has_children: false
has_toc: false
---

## Parameter Files
To run a simulation, the solution sequence needs many parameters: physical constants, number of iterations, relaxation constant, thickness and surface of the glacier, etc. All of this can be done during model setup in your `runme`. But for the sake of organization and/or reusability, you might want to store the parameterization commands in a separate file. For example, for the MATLAB interface, you might create a file `Parameters.par` with contents,
````
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GEOMETRY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('      reading thicknesses');
md.geometry.thickness = InterpFromFile(md.mesh.x, md.mesh.y, thicknesspath, 10);

disp('      reading dem');
md.geometry.surface = InterpFromFile(md.mesh.x, md.mesh.y, surfacepath, 10);

%get base
md.geometry.base = md.geometry.surface - md.geometry.thickness;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OBSERVATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('      reading velocities');
md = plugvelocities(md, velocitypath, 0);

disp('      loading temperature');
md.initialization.temperature = InterpFromFile(md.mesh.x, md.mesh.y, temperaturepath, 253);

disp('      creating mass balance rates');
md.smb.mass_balance = InterpFromFile(md.x, md.y, massbalancepath, 1);

disp('      loading geothermal flux'); 
load(heatfluxpath); 
md.basalforcings.geothermalflux = InterpFromGrid(x_m, y_m, heatflux, md.mesh.x, md.mesh.y, 80);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MATERIAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%flow law 
disp('      creating flow law parameters');
md.materials.rheology_n = 3 * ones(md.mesh.numberofelements, 1);
md.materials.rheology_B = paterson(md.initialization.temperature);

%%%%%%%%%%%%%%%%%%%%%%%%%%% BOUNDARY CONDITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%drag md.drag or stress
md.friction.coefficient = 300 * ones(md.mesh.numberofvertices, 1); %q=1.

%floating ice: no drag
md.friction.coefficient(find(md.mask.ocean_levelset < 0.)) = 0.;
md.friction.p = ones(md.mesh.numberofelements, 1);
md.friction.q = ones(md.mesh.numberofelements, 1);

%Create ice front
md = SetMarineIceSheetBC(md);
````
As you can see, even though the file extension is `par`, it is really just a MATLAB script. You can now parameterize your model in your `runme` with,
````
>> md = parameterize(md, 'Parameters.par');
````

For the Python interface, we similarly use Pickle files (`pkl`) and parameterize with,
````
>>> md = parameterize(md, 'Parameters.pkl')
````

{: .highlight-title }
> Note
>
> - The parameterization must be done on a two dimensional mesh.
> - The parameters will be automatically extruded if the mesh is extruded.


