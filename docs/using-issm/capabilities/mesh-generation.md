---
title: Mesh Generation
layout: default
parent: Capabilities
has_children: false
has_toc: false
---

## Mesh Generation
### ARGUS file format
To mesh the domain, one needs a file containing all the coordinates of the domain outline in an <a href="http://www.argusint.com/" target="_blank">ARGUS</a> format. These files have a `*.exp` extension. Here is an example of such a file for a square glacier:
````
## Name:DomainOutline
## Icon:0
# Points Count  Value
5 1.000000
# X pos Y pos
0 0
1000000 0
1000000 1000000
0 1000000
0 0
````
The ARGUS format is used extensively by ISSM. One can use `exptool` to generate and manage <a href="http://www.argusint.com/" target="_blank">ARGUS</a> files.
### triangle
`triangle` is a wrapper of <a href="http://www.cs.cmu.edu/~quake/triangle.html" target="_blank">triangle</a> developed by <a href="http://www.cs.berkeley.edu/~jrs/" target="_blank">Jonathan Shewchuk</a> [<a href="#references">*Shewchuk1996*</a>]. It generates unstructured isotropic meshes:
````
>> md = triangle(md, 'DomainOutline.exp', 5000);
````
The first argument is the model you are working on, the second argument is the file from ARGUS containing the domain outline, and the last argument is the density of the mesh (the mean distance between two nodes). To see what the mesh looks like, one can run:
````
>> plotmodel(md, 'data', 'mesh');
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/capabilities/mesh/mesh.png" alt="Figure 1: mesh"></div><span style="display:block;width:100%;text-align:center"><small>Mesh</small></span>
ISSM includes a mesh adaptation capability embedded in the code, inspired by <a href="https://people.math.sc.edu/Burkardt/data/bamg/bamg.html" target="_blank">BAMG</a> developed by Frederic Hecht [<a href="#references">*Hecht2006*</a>], and YAMS developed by Pascal Frey [<a href="#references">*Frey2001*</a>].
### Bamg
#### Domain
To mesh the domain, you need a file containing all the coordinates of the domain outline in an ARGUS format. Assuming that this file is `DomainOutline.exp`, run:
````
>> md = bamg(md, 'DomainOutline.exp');
````

#### hmin/hmax
The minimum and maximum edge lengths can be specified by `'hmin'` and `'hmax'` options:
````
>> md = bamg(md, 'DomainOutline.exp', 'hmax', 1000);
````

#### hVertices
One can specify the edge length of domain outline vertices. Use `NaN` if an edge length value is not required/available:
````
>> h = [1000 100 100 100];
>> md = bamg(md, 'DomainOutline.exp', 'hmax', 1000, 'hVertices', h);
````

#### field/err
The option `'field'` can be used with the option `'err'` to generate a mesh adapted to the field given as input for the error given as input:
````
>> md = bamg(md, 'field', md.inversion.vel_obs, 'err', 1.5);
````
Multiple fields can also be used:
````
>> md = bamg(md, 'field', [md.inversion.vel_obs md.geometry.thickness], 'err', [1.5 20]);
````

#### gradation
The ratio of the lengths of two adjacent edges is controlled by the option `'gradation'`:
````
>> md = bamg(md, 'field', md.inversion.vel_obs, 'err', 1.5, 'gradation', 3);
````

#### anisomax
The factor of anisotropy (ratio between the lengths of two edges belonging to the same triangle) can be changed by the option `'aniso'`. A factor of anisotropy equal to 1 will result in an isotropic mesh generation:
````
>> md = bamg(md, 'field', md.vel_obs, 'err', 1.5, 'anisomax', 1);
````
NOTE: Users using Intel compilers (`icc`, `icpc`) shoud use the flag `-fp-model precise` to disable optimizations that are not value-safe on floating-point data. This will prevent bamg from being compiler dependent (see <a href="https://software.intel.com/en-us/node/522979" target="_blank">here</a>).

### Extrusion (3D)
One can extrude the mesh, in order to use a three-dimensional model (Pattyn's higher order model and Full Stokes model). This step is not mandatory. If the user wants to keep a 2D model, skip this section.

To extrude the mesh, run the following command:
````
>> md = extrude(md, 8, 3);
````
The first argument is the model, as usual. The second argument is the number of horizontal layers. A high number of layers gives a better precision for the simulations but creates more elements, which requires a longer computational time. Usually a number between 7 and 10 is a good balance. The third argument is called the extrusion exponent. Interesting things are usually happening near the bedrock and therefore users might want to refine the lower layers more than the upper ones. An extrusion exponent of 1 will create a mesh with layers equally distributed vertically. The higher the extrusion exponent, the more refined the base. An extrusion exponent of 3 or 4 is generally enough.

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/capabilities/mesh/extrusion.png" alt="Figure 2: extrusion"></div><span style="display:block;width:100%;text-align:center"><small>Extruded mesh</small></span>

## References
