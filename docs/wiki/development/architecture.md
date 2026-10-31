---
title: ISSM' Architecture
layout: default
parent: Development
nav_order: 2
---

# ISSM' Architecture
## Model Inputs/Parameters
There are 4 types of model inputs:
1. Material parameters that are constant (water density, ice latent heat, ...)
2. Material parameters that vary in space (ice viscosity, damage, ...)
3. Other model parameters that are constant (convergence criterion, maximum number of iteration, ...)
4. Other model inputs that vary in space (ice thickness, surface elevation,...)

There are 3 placeholders in ISSM:
- element->inputs for everything that varies in space (2 and 4).
- Matpar for material constants (1). Will disappear soon!
- femmodel->parameters for solution constants (3).

## Numbering
Vertices, Elements and Nodes have different numberings:
- Id: random but unique across all partitions (it generally follows MATLAB indexing, i.e., same as `md`, but not always!).
- SId: serial Id. Starts at 0 and increases by increments of 1, this numbering is independent of the mesh partitioning (hence 'serial') and is the same as if there was only one CPU.
- PId: parallel Id. Starts at 0 and increases by increments of 1 but is such that we count the entities of the first partition first, then the second etc so that nodes that have a high Pid belong to a partition that has a high number. This is useful for parallel vector and matrices where we want each partition to insert values in its own memory slot.
- LId: local Id. Starts at 0 for each partition, increases by increments of 1, but is local to the partition. Each partition has a vertex of Lid 0, and its maximum Lid is the number of vertices in the partition -1.

## Solutions and Analyses
- An analysis is the solution of one PDE
- A solution might consist of the solution of one analysis or several analyses. For example in a `TransientSolution`, we solve `Stressbalanceanalysis`, `MasstransportAnalysis`, `ThermalAnalysis`, ...

Each analysis has one unique file in `src/c/analyses` and they all derive from the class `Analysis` with a list of functions they have to have (CreateKMatrix, NumberofDofs,...).

Each solution has one core in `src/c/cores`.
