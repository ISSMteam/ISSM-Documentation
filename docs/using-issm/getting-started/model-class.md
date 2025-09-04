---
title: Model Class
layout: default
parent: Getting Started
nav_order: 2
---

# Model Class
All the data belonging to a model (geometry, node coordinates, results, etc.) is held in the same object `model`. To create a new model in MATLAB, run,
```m
md = model()
```
and in Python,
```py
from model import *
md = model()
```
This will create a new model named `md` whose class is `model`. The information contained in the model `md` is grouped by class, each of which are comprised of fields related to that particular aspect of the model (e.g. mesh, material properties, friction, stressbalance solution, solution results). When one creates a new model, all of these fields are empty or `NaN` (not a number), but `md` is ready to be used as a model. The list of these classes is displayed by running, in MATLAB,

```m
>> md
md = 

               mesh: [1x1 mesh2d]           -- mesh properties
               mask: [1x1 mask]             -- defines grounded and floating elements
           geometry: [1x1 geometry]         -- surface elevation, bedrock topography, ice thickness,...
                     [...]
            results: [1x1 struct]           -- model results
       radaroverlay: [1x1 radaroverlay]     -- radar image for plot overlay
      miscellaneous: [1x1 miscellaneous]    -- miscellaneous fields
```
or, in Python,
```py
>>> print(md)
               mesh: [1x1 mesh2d]           -- mesh properties
               mask: [1x1 mask]             -- defines grounded and floating elements
           geometry: [1x1 geometry]         -- surface elevation, bedrock topography, ice thickness,...
                     [...]
       radaroverlay: [1x1 radaroverlay]      -- radar image for plot overlay
      miscellaneous: [1x1 miscellaneous]     -- miscellaneous fields
  stochasticforcing: [1x1 stochasticforcing] -- stochasticity applied to model forcings
```

Likewise, you can display all the fields associated with, for example, the model's mesh by running,
```m
>> md.mesh
````
or,
```py
>>> print(md.mesh)
```

## Saving/Loading a Model
You can save the model with all its fields so that the saved file contains all of the information in the model by running,
```m
save squaremodel md
```
This will create a file `squaremodel.mat` made from the model `md`. Likewise, to load this file, run,
```m
>> loadmodel squaremodel
```
The loaded model will be named `md`.
