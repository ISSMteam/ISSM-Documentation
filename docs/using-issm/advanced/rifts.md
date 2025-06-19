---
title: Rifts
layout: default
parent: Advanced Features
has_children: false
has_toc: false
---

## Rifts
ISSM allows for the simulation of rifts. This section explains how to create a model that includes rifts, and how to control their behavior.

### Rifts creation
Rifts can be included right between the phase where the mesh is created, and the phase where the geography is setup. Rifts that should be included in the model must be present in an ARGUS type file. Each rift should be represented by an open loop set of points. Infinite numbers of rifts can be included, provided they do not intersect with the domain outline, or any other rift. This point is particularly important as there are no checks on intersections at the meshing phase. For example, a file including two straight rifts could look like, `Rifts.exp`:
````
## Name:Rift1
## Icon:0
# Points Count  Value
2 1.000000
# X pos Y pos
0 0
50000  0

## Name:Rift2
## Icon:0
# Points Count  Value
2 1.000000
# X pos Y pos
0 10000
50000  10000
````
this file includes two horizontal rifts of 50 km long, separated by 10 km. In order to create a
model with these rifts, one would do:
````
>> md = model;
>> md = triangle(md, 'DomainOutline.exp', 'Rifts.exp', 4000);
>> md = meshprocessrifts(md);
>> md = setmask(md, 'Iceshelves.exp', 'Islands.exp');
>> etc ...
````
The rest of the process is similar. This will create a `rifts` structure in the model `md`. The `rifts` structure holds as many members as there are rifts in `Rifts.exp`. The key fields in the rifts structure are the `fill` and `friction`. Fill can be either 1 (for water), 2 (for air) and 3 (for ice). Fill determines the pressure on each flank of the rifts that is being applied. Friction is a coefficient between the shear stress exerted on the rift flanks and the differential tangential velocity between both flanks.

### Rift tip refining
Rifts in a mesh will not modify the type of meshing occurring during the mesh phase. To impact the mesh, one can use the `riftstiprefine.m` routine. This routine will ensure that the rift tips are correctly refined, to take into account the tip stress singularity. Use of this routine is as follows:
````
>> md = model;
>> md = triangle(md, 'DomainOutline.exp', 'Rifts.exp', 4001);
>> md = rifttipsrefine(md, 2000, 30000);
>> md = meshprocessrifts(md);
>> md = setmask(md, 'Iceshelves.exp', 'Islands.exp');
>> etc ...
````
the first argument is the model, the second argument the tip area resolution, and the third is the
size of the circle around the tips where mesh refinement should occur.

### Rifts in parameter file
The structure of rifts can be modified in any parameter file. We do not advise touching anything except the fill and friction for each one of the rifts in the structure. For example, inclusion of the following lines in the parameter file should be enough:
````
>> for i = 1:md.numrifts,
>>    md.rifts.riftstruct(i).fill = 'Water';   %include water in the rifts
>>    md.rifts.riftstruct(i).friction = 10^11; %friction parameter sigma = 10^11 * dv_t
>> end
````

Of course, different frictions and fill could be applied, according to the physics being captured.

### Solving for rifts
Rifts are only allowed when using MacAyeal type elements, in 2D meshes. For now, 3D meshes are not supported. Nothing is needed to take rifts into account in the solve phase. A simple:
````
>> md = solve(md, 'Stressbalance');
````
will suffice. Bear in mind that rifts are handled using penalty methods to ensure that penetration of rift flanks does not occur. This can be very computationally expensive, as penalty methods tend to lead to zigzagging of contact. A stable set of constraints strategy has been implemented, which should guarantee convergence, but can be slow. Users should also try to minimize zigzagging by refining the mesh where needed. In case zigzagging becomes too intense, locking of the zigzagging penalties will occur, which ensures convergence, but which can lead to bad results in a physical sense. Detecting penalty locking should give users an idea on where to refine the mesh.

### Rifts plotting
Rifts can be plotted using the following special plots:
````
>> plotmodel(md, 'data', 'rifts', 'data', 'riftpenetration', 'data', 'riftvel', 'data', 'riftrelvel');
````
these three plots will give users a view of which parts of the rifts are opening, closing, at which relative speed, etc.

### Rifts when using Yams mesh adaptation
Rifts can be used in conjunction with the Yams mesh adaptation routine, by adding the `Rifts.exp` file defining rift contours to the `'riftoutline'` option of `yams`. For example:
````
>> md = yams(md, 'domainoutline', 'DomainOutline.exp', 'riftoutline', 'Rifts.exp', 'velocities', 'vel.mat');
````

### Adding rifts to an existing mesh
In case users want to use an existing mesh, rifts can still be added on. The format for the rifts file is in this case slightly different:
````
## Name:ContourAroundRift1
## Icon:0
# Points Count  Value
5 1
# X pos Y pos
-100 -100
50100 -100
50100 +100
-100 +100
-100 -100

## Name:Rift1
## Icon:0
# Points Count  Value
2 500
# X pos Y pos
0 0
50000  0

## Name:ContourAroundRift2
## Icon:0
# Points Count  Value
5 1
# X pos Y pos
-100 900
50100 900
50100 1100
-100 1100
-100 900

## Name:Rift2
## Icon:0
# Points Count  Value
2 1000
# X pos Y pos
0 10000
50000  10000
````

The format is made of pairs of rift contours with the corresponding rift profile. The rift contour is a closed contour that envelopes the rift. The rift that follows needs to be completely included in it. The rift density (here, 500 and 1000 respectively) is very important, as it will decide the density of the mesh around the rift. Do not specify 1, as this will try to include a rift in the mesh with a 1 m mesh density, which will probably result in a memory exhaustion problem for the local machine running ISSM.

