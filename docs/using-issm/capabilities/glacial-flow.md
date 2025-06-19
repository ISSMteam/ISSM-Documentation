---
title: Glacial Flow Approximation
layout: default
parent: Capabilities
has_children: false
has_toc: false
---

## Glacial Flow Approximation
ISSM has the capability to compute the flow of a glacier with 4 different models:

- Shallow Ice Approximation (SIA, 2d and 3d)
- MacAyeal/Morland's Shelfy Stream Approximation (SSA, 2d and 3d)
- Blatter/Pattyn's Higher-Order model (HO, 3d: extruded mesh only)
- Full-Stokes' model (FS, 3d: extruded mesh only)

The ice flow model is specified for each element of the mesh. To assign the models to the elements, as an example the following command can be used:
````
>> md = setflowequation(md, 'HO', 'Pattyn.exp', 'SSA', md.mask.ocean_levelset < 0., 'fill', 'SIA');
````
The routine `setflowequation` works like `plotmodel`: it requires an even number of arguments (without counting md itself). There are five possible options:

- `'SIA'`
- `'SSA'`
- `'HO'`
- `'FS'`
- `'fill'`

The first four options must be followed by one of the following arguments:

- An ARGUS file containing a closed contour, the elements inside the contour will be assigned to the model given by the option.  If user wants to assign the model to the elements outside the domain, add '~' to the name of the domain file (ex: '~Pattyn.exp')
- A vector of size `md.numberofelements` holding 0, and 1 on the elements that the user had flagged. The model given by the option will be assigned to the elements flagged only.
- `'all'` if the user wants to assign the model to all the elements

The last option `'fill'` must be followed by the name of the model that the user wants the other elements (that have not been flagged by the other options) assigned to. All options are not required to be used. The previous example assigns the model of Pattyn for the elements inside the contour `Pattyn.exp` and the model of  MacAyeal for the elements located on the ice shelf. The other elements are Hutter's elements. If the user wants to use MacAyeal's model only, type the following command: 
````
>> md = setflowequation(md, 'SSA', 'all');
````

