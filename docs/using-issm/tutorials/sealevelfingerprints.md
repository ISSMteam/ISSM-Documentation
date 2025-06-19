---
title: Sea-Level Fingerprints (GRACE)
layout: default
parent: Tutorials
has_children: false
has_toc: false
---

## Sea-Level Fingerprints (GRACE)
### Goals

- Setup a ISSM-SESAW model with GRACE-based forcing
- Run the model to compute sea-level fingerprints

Go to `<ISSM_DIR>/examples/SlrGRACE/` to do this tutorial.

### Mesh
Set `steps = 1` to create an unstructured global mesh. Choose `mindistance_coast`, `mindistance_lan`, and `maxdistance` as you wish for generating a mesh. The nominal parameters should generate the following mesh:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/sealevelfingerprints/Mesh.png" alt="Figure 1: Mesh"></div>### GRACE loads
Set `steps = 2` to load GRACE-based estimate of water equivalent height (WEH) change for a chosen month. Choose `year_month` as you wish. The nominal month is January 2007 and here is the load model (cf. `steps = 5` for plotting):

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/sealevelfingerprints/Weh.png" alt="Figure 2: Weh"></div>### Parameterization
In the next step, you will load the Earth model. The nominal model is PREM; `lovenumbers` reads the associated Love numbers. You will also have to set up some standard parameters regarding ice sheets for passing the consistency.
### Solve Model
In `steps = 4`, you will choose the solid-Earth physics (e.g., gravitation, viscoelasticity, and rotation) that you wish to consider. You may also request model outputs (e.g., sea level and bedrock motion). You must set `masstransport` and `slc` flags on before solving the `transient` model. See `steps = 6` for running a model with multiple (transient) loads.
### Some Results
Once the model run is completed, you may plot results. Some useful plotting scripts are located in `steps = 5` and `steps = 7`. In the latter, you can also find a script to make an animation. Here is an example result for January 2007:

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/using-issm/tutorials/sealevelfingerprints/Rsl.png" alt="Figure 3: Rsl"></div>
