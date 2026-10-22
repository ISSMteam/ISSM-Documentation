---
title: Solutions
layout: default
parent: Getting Started
nav_order: 3
---

# Solutions
After parameterizing your model, you are ready to request a solution. In MATLAB, this is done by running,
````
>> md = solve(md, <solution_type>);
````
and in Python,
````
>>> md = solve(md, <solution_type>)
````
where `<solution_type>` is a string representing a given solution type, for example, `'Stressbalance'`.

The following pages provide more in-depth information on the various solution types,
- [Thermal](../capabilities/thermal){:target="_top"}
- [Hydrology](../capabilities/hydrology){:target="_top"}
- [Stress Balance](../capabilities/stress-balance){:target="_top"}
- [Mass Transport](../capabilities/mass-transport){:target="_top"}
- [Glacial Isostatic Adjustment (GIA)](../capabilities/gia){:target="_top"}

Running one or more of the above solutions over time is detailed on the
[Transient Solutions page](../capabilities/transient){:target="_top"}.

