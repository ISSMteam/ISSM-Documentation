---
title: Square Shelf
layout: default
parent: Tutorials
nav_order: 2
---

# Square Ice Shelf

<style>
.api-tabs { border: 1px solid #d0d7de; border-radius: 6px; margin: 1em 0; }
.api-tabs .tab-bar { display: flex; background: #f3f4f6; border-bottom: 1px solid #d0d7de; border-radius: 6px 6px 0 0; }
.api-tabs .tab-bar button { padding: 6px 18px; border: 0; background: none; cursor: pointer; font-size: 0.9em; font-weight: 600; color: #555; border-bottom: 3px solid transparent; }
.api-tabs .tab-bar button.active { color: #7253ed; border-bottom-color: #7253ed; background: #fff; }
.api-tabs .tab-body { display: none; }
.api-tabs .tab-body.active { display: block; }
.api-tabs .tab-body div.highlighter-rouge, .api-tabs .tab-body pre { margin: 0; }
.api-tabs .tab-body[data-tab=matlab], .api-tabs .tab-body[data-tab=matlab] div.highlighter-rouge, .api-tabs .tab-body[data-tab=matlab] pre { background: #fff4e5 !important; }
.api-tabs .tab-body[data-tab=python], .api-tabs .tab-body[data-tab=python] div.highlighter-rouge, .api-tabs .tab-body[data-tab=python] pre { background: #e8f1fb !important; }
.api-tabs .tab-bar button[data-tab=matlab].active { background: #fff4e5; color: #c25e00; border-bottom-color: #e97b00; }
.api-tabs .tab-bar button[data-tab=python].active { background: #e8f1fb; color: #1f5fa8; border-bottom-color: #3776ab; }
</style>

This is an example of velocity computation in steady state for a square ice shelf. First, launch MATLAB or Python. Then, navigate to `examples/SquareIceShelf` in `ISSM_DIR` (the directory in which ISSM is stored). In MATLAB you can do this via the left sidebar or by running the following in the Command Window; in Python, run the commands from a shell, script, or notebook started in that directory:

<div class="api-tabs">
<div class="tab-bar"><button type="button" class="active" data-tab="matlab">MATLAB</button><button type="button" data-tab="python">Python</button></div>
<div class="tab-body active" data-tab="matlab" markdown="1">
````
>> cd examples/SquareIceShelf
````
</div>
<div class="tab-body" data-tab="python" markdown="1">
````
$ cd $ISSM_DIR/examples/SquareIceShelf
````
</div>
</div>

You can create an empty model structure by running (in Python, first import the ISSM modules):

<div class="api-tabs">
<div class="tab-bar"><button type="button" class="active" data-tab="matlab">MATLAB</button><button type="button" data-tab="python">Python</button></div>
<div class="tab-body active" data-tab="matlab" markdown="1">
````
>> md = model;
````
</div>
<div class="tab-body" data-tab="python" markdown="1">
````
>>> from model import *
>>> from triangle import triangle
>>> from setmask import setmask
>>> from parameterize import parameterize
>>> from setflowequation import setflowequation
>>> from solve import solve
>>> from plotmodel import plotmodel
>>> md = model()
````
</div>
</div>

Create a mesh of the domain outline with a resolution of 50,000 meters:

<div class="api-tabs">
<div class="tab-bar"><button type="button" class="active" data-tab="matlab">MATLAB</button><button type="button" data-tab="python">Python</button></div>
<div class="tab-body active" data-tab="matlab" markdown="1">
````
>> md = triangle(md, 'DomainOutline.exp', 50000);
````
</div>
<div class="tab-body" data-tab="python" markdown="1">
````
>>> md = triangle(md, 'DomainOutline.exp', 50000)
````
</div>
</div>

Define the glacier system as an ice shelf (no island):

<div class="api-tabs">
<div class="tab-bar"><button type="button" class="active" data-tab="matlab">MATLAB</button><button type="button" data-tab="python">Python</button></div>
<div class="tab-body active" data-tab="matlab" markdown="1">
````
>> md = setmask(md, 'all', '');
````
</div>
<div class="tab-body" data-tab="python" markdown="1">
````
>>> md = setmask(md, 'all', '')
````
</div>
</div>

Parameterize the model with the file `Square.par` in MATLAB or `Square.py` in Python (which you can see exists in the current directory):

<div class="api-tabs">
<div class="tab-bar"><button type="button" class="active" data-tab="matlab">MATLAB</button><button type="button" data-tab="python">Python</button></div>
<div class="tab-body active" data-tab="matlab" markdown="1">
````
>> md = parameterize(md, 'Square.par');
````
</div>
<div class="tab-body" data-tab="python" markdown="1">
````
>>> md = parameterize(md, 'Square.py')
````
</div>
</div>

Define all elements as SSA:

<div class="api-tabs">
<div class="tab-bar"><button type="button" class="active" data-tab="matlab">MATLAB</button><button type="button" data-tab="python">Python</button></div>
<div class="tab-body active" data-tab="matlab" markdown="1">
````
>> md = setflowequation(md, 'SSA', 'all');
````
</div>
<div class="tab-body" data-tab="python" markdown="1">
````
>>> md = setflowequation(md, 'SSA', 'all')
````
</div>
</div>

Compute the velocity field of the ice shelf:

<div class="api-tabs">
<div class="tab-bar"><button type="button" class="active" data-tab="matlab">MATLAB</button><button type="button" data-tab="python">Python</button></div>
<div class="tab-body active" data-tab="matlab" markdown="1">
````
>> md = solve(md, 'Stressbalance');
````
</div>
<div class="tab-body" data-tab="python" markdown="1">
````
>>> md = solve(md, 'Stressbalance')
````
</div>
</div>

Finally, generate a plot of the velocity:

<div class="api-tabs">
<div class="tab-bar"><button type="button" class="active" data-tab="matlab">MATLAB</button><button type="button" data-tab="python">Python</button></div>
<div class="tab-body active" data-tab="matlab" markdown="1">
````
>> plotmodel(md, 'data', md.results.StressbalanceSolution.Vel);
````
</div>
<div class="tab-body" data-tab="python" markdown="1">
````
>>> plotmodel(md, 'data', md.results.StressbalanceSolution.Vel)
````
</div>
</div>

<script>
(function () {
  function show(name) {
    document.querySelectorAll('.api-tabs [data-tab]').forEach(function (el) {
      el.classList.toggle('active', el.dataset.tab === name);
    });
    try { localStorage.setItem('issm-api', name); } catch (e) {}
  }
  document.querySelectorAll('.api-tabs .tab-bar button').forEach(function (b) {
    b.addEventListener('click', function () { show(b.dataset.tab); });
  });
  try { var s = localStorage.getItem('issm-api'); if (s) show(s); } catch (e) {}
})();
</script>

<div style="display:flow-root"><img style="float:middle;width:50.00%" src="/ISSM-Documentation/assets/img/docs/tutorials/squareiceshelf/squarevel.png" alt="Figure 1: squarevel"></div>
