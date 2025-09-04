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
- <a href="../capabilities/thermal" target="_top">thermal</a>
- <a href="../capabilities/hydrology" target="_top">hydrology</a>
- <a href="../capabilities/stress-balance" target="_top">stress-balance</a>
- <a href="../capabilities/mass-transport" target="_top">mass transport</a>
- <a href="../capabilities/gia" target="_top">Glacial Isostatic Adjustment (GIA)</a>

Running one or more of the above solutions over time is detailed on the 
<a href="../capabilities/transient" target="_top">Transient Solutions page</a>.

