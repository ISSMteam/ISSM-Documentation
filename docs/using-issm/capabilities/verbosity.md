---
title: Verbosity
layout: default
parent: Capabilities
---

## Verbosity
The verbosity level is set by the field `md.verbose`. This field is a MATLAB object, which activates and deactivates different verbosity levels. By default, all verbosity levels are deactivated.

For a complete list of available levels,
````
>> help verbose
VERBOSE class definition

Available verbosity levels:
mprocessor  : model processing
module      : modules
solution    : solution sequence
solver      : solver info (extensive)
convergence : convergence criteria
control     : control method
qmu         : sensitivity analysis
````

To activate the levels `module` and `solution`, use,
````
>> md.verbose = verbose();
>> md.verbose = verbose('module', true, 'solution', true);
````

