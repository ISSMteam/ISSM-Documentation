---
title: Adaptive Mesh Refinement - AMR
layout: default
parent: Advanced Features
---

## Adaptive Mesh Refinement - AMR
The adaptive mesh refinement (AMR) in ISSM relies on two independent meshers: BAMG and NeoPZ. BAMG is a bidimensional anisotropic mesh generator developed by <a href="http://www.ann.jussieu.fr/~hecht/" target="_blank">Frederic Hecht</a> [<a href="#references">*Hecht2006*</a>] and NeoPZ is a finite element package developed by Philippe Devloo <a href="https://github.com/labmec/neopz" target="_blank">Philippe Devloo</a> [<a href="#references">*Devloo1997*</a>].

The current AMR is supported for 2D meshes (triangle elements) and for the SSA flow equations. The
features of each one of these meshers are described below:

### AMR using BAMG (default)
BAMG is the default mesher to run a simulation with AMR. AMR is executed specifying the required resolutions at the vertices of the mesh. The following properties can be defined by the user:

#### hmin/hmax
The minimum and maximum edge lengths can be specified by `'hmin'` and `'hmax'` options:
````
>> md.amr.hmin = 500;
>> md.amr.hmax = 5000;
````

#### field/err
The option `'field'` can be used with the option `'err'` to adapt the mesh to the field given as input for the error given as input:
````
>> md.amr.fieldname = 'Vel';
>> md.amr.err = 3;
````

#### gradation
The ratio of the lengths of two adjacent edges is controlled by the option `'gradation'`:
````
>> md.amr.gradation = 1.5;
````

#### resolution at the grounding line
One can specify the edge length around the grounding line. The user needs to specify the distance around the grounding line (the same distance is used upstream and downstream of the grounding line) where the imposed resolution will be applied:
````
>> md.amr.groundingline_resolution = 500;
>> md.amr.groundingline_distance = 10000;
````
Set `0` in the grounding distance if this refinement is not required.

#### resolution at the ice front
The ice front is another region where AMR can be applied. For this, the edge length around the ice front should be specified. As for the grounding line, the user needs to specify the distance around the ice front (the same distance is used upstream and downstream to the ice front) where the imposed resolution will be applied.
````
>> md.amr.icefront_resolution = 500;
>> md.amr.icefront_distance = 10000;
````
Set `0` in the ice front distance if this refinement is not required.

**Note:** users using Intel compilers (`icc`, `icpc`) should use the flag `-fp-model precise` to disable optimizations that are not value-safe on floating-point data. This will prevent `bamg` from being compiler dependent (see <a href="https://software.intel.com/en-us/node/522979" target="_blank">here</a>).
### AMR using NeoPZ (requires installation)
The mesh refinement with NeoPZ is based on levels of refinement: the initial coarse mesh is refined according to the user requirement and only nested meshes are generated (it means that the initial vertices positions are kept unchanged during all the AMR simulation). NeoPZ is an external package that needs to be installed before using in ISSM. Once installed, it is necessary setting NeoPZ as the AMR package:
````
>> md.amr = amrneopz();
````

#### level max
Users should define the maximum level of refinement to be applied:
````
>> md.amr.level_max = 2;
````

#### gradation
The ratio of the lengths of two adjacent edges is controlled by the option `'gradation'`:
````
>> md.amr.gradation = 1.5;
````

#### distance to the grounding line
User needs to specify the distance around the grounding line (the same distance is used upstream and downstream to the grounding line) where the elements will be refined according to the maximum level of refinement:
````
>> md.amr.groundingline_distance = 10000;
````
Set `0` as the grounding distance if this refinement is not required.

#### distance to the ice front
If the user wants to refine around the ice front, it is necessary to specify the distance in which the elements will be refined according to the maximum level of refinement (the same distance is used upstream and downstream to the ice front):
````
>> md.amr.icefront_distance = 10000;
````
Set `0` in the ice front distance if this refinement is not required.
#### Running with AMR
To ability the AMR process, one needs to define the AMR frequency in the transient field (can be 1 or larger depending on how often the mesh needs to be updated):
````
>> md.transient.amr_frequency = 1;
````


## References
