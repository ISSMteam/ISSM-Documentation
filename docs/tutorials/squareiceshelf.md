---
title: Square Shelf
layout: default
parent: Tutorials
nav_order: 2
---

# Square Ice Shelf

This is an example of velocity computation in steady state for a square ice shelf. First, launch MATLAB or Python. Then, navigate to `examples/SquareIceShelf` in `ISSM_DIR` (the directory in which ISSM is stored). In MATLAB you can do this via the left sidebar or by running the following in the Command Window; in Python, run the commands from a shell, script, or notebook started in that directory:

```sh
cd $ISSM_DIR/examples/SquareIceShelf
```

You can create an empty model structure by running (in Python, first import the ISSM modules):

<div class="issm-api-tabs" markdown="1">
```matlab
>> md = model();
```
```py
>>> from model import *
>>> from triangle import triangle
>>> from setmask import setmask
>>> from parameterize import parameterize
>>> from setflowequation import setflowequation
>>> from solve import solve
>>> from plotmodel import plotmodel
>>> md = model()
```
</div>

Create a mesh of the domain outline with a resolution of 50,000 meters:

<div class="issm-api-tabs" markdown="1">
```matlab
>> md = triangle(md, 'DomainOutline.exp', 50000);
```
```py
>>> md = triangle(md, 'DomainOutline.exp', 50000)
```
</div>

Define the glacier system as an ice shelf (no island):

<div class="issm-api-tabs" markdown="1">
```matlab
>> md = setmask(md, 'all', '');
```
```py
>>> md = setmask(md, 'all', '')
```
</div>

Parameterize the model with the file `Square.par` in MATLAB or `Square.py` in Python (which you can see exists in the current directory):

<div class="issm-api-tabs" markdown="1">
```matlab
>> md = parameterize(md, 'Square.par');
```
```py
>>> md = parameterize(md, 'Square.py')
```
</div>

Define all elements as SSA:

<div class="issm-api-tabs" markdown="1">
```matlab
>> md = setflowequation(md, 'SSA', 'all');
```
```py
>>> md = setflowequation(md, 'SSA', 'all')
```
</div>

Compute the velocity field of the ice shelf:

<div class="issm-api-tabs" markdown="1">
```matlab
>> md = solve(md, 'Stressbalance');
```
```py
>>> md = solve(md, 'Stressbalance')
```
</div>

Finally, generate a plot of the velocity:

<div class="issm-api-tabs" markdown="1">
```matlab
>> plotmodel(md, 'data', md.results.StressbalanceSolution.Vel);
```
```py
>>> plotmodel(md, 'data', md.results.StressbalanceSolution.Vel)
```
</div>

<div style="display:flow-root"><img src="/ISSM-Documentation/assets/img/docs/tutorials/squareiceshelf/squarevel.png" alt="Figure 1: squarevel"></div>
