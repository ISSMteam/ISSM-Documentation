---
title: Toolkits
layout: default
parent: Miscellaneous wiki
grand_parent: Using ISSM
---
This list of solvers that have worked fairly consistently, '''try them out locally''' and if the recovery solver is not activated, you should be safe for longer transient runs.

## Biconjugate Gradient with block Jacobi preconditioner

```m
md.toolkits.DefaultAnalysis=bcgslbjacobioptions();
```

Here is an example where biconjugate gradient with block Jacobi preconditioner (bcg) is used only for the stress balance analysis. The direct solver (MUMPS) is used for the rest (mass transport analysis, etc). Also, the recovery solver (MUMPS) is not called if bcg fails in a Picard iteration (linear solver step). The only criterion is the mechanical equilibrium, which controls the non-linear solver as a whole. This scheme may compromise the monotonicity and rate of convergence of the non-linear solver, but if the model is too big (>100,000 elements) it is faster than calling MUMPS every time bgc fails.

Note: SSA is very stable, so bcg should convert fast. For HO(3D), bcg may not converge even after 50 iterations. In this case, look at the stress balance convergence (md.verbose=verbose('convergence',true,'solution',true);) and check if it is necessary to relax a little bit the restol value. The scheme below have being used for SSA (~250,000 elements) and for HO (~1,000,000 elements).

```m
md.toolkits=toolkits(); % to be sure that MUMPS is the default solver for all analysis
md.toolkits=addoptions(md.toolkits,'StressbalanceAnalysis',bcgslbjacobioptions()); % add bcg for stress balance analysis only
md.settings.solver_residue_threshold=NaN; % the solver may fail during a Picard iteration (linear solver); no need to call the recovery solver (MUMPS)
md.stressbalance.maxiter=50;
md.stressbalance.restol=0.0001; % this is the default value and the only criterion used here
md.stressbalance.reltol=NaN; % no need
md.stressbalance.abstol=NaN; % no need
```

## GMRES with block jacobi preconditioner

```m
md.toolkits.DefaultAnalysis=gmresbjacobioptions();
md.toolkits.DefaultAnalysis.ksp_max_it=100;
```

## ASM

Primarily used for mass conservation but may work for other things:
```m
md.toolkits.DefaultAnalysis=asmoptions();
```

## Recovery mode and Misc
An iterative solver may work for one analysis and not another, you can assign a solver to each, like this:
```m
md.toolkits.StressbalanceAnalysis = gmresbjacobioptions();
md.toolkits.DefaultAnalysis = issmmumpssolver();
```
In some cases, the solver tolerance may need to be relaxed a little bit:
```m
md.settings.solver_residue_threshold = 1.e-4;
```

Make sure to always keep MUMPS as the recovery solver (it is slow but extremely robust). You probably don't need to do this because MUMPS should already be set as the recovery solver, but just in case:
```m
%Keep recovery mode as MUMPS
md.toolkits.RecoveryAnalysis=mumpsoptions();
```
