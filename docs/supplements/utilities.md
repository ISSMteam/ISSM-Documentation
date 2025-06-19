---
title: Utilities
layout: default
parent: Supplements
has_children: false
has_toc: false
---

# Utilities
Several utilities are available to help the user to set up models and analyze results. Many of these tools are described below. More in-depth information can be found by running `help <FUNCTION>` in the MATLAB prompt where `<FUNCTION>` is any of the following function names. Note that many of these utilities are also available in Python, but that coverage is not 100&#37;.

## Mesh

- `triangle` generate a mesh from a domain outline
- `bamg` anisotropic mesh generation and adaptation
- `yams` anisotropic mesh adaptation
- `meshexprefine` refine a region of a mesh
- `meshprocessrift` process mesh when rifts are present
- `MeshQuality` compute mesh quality
- `rifttiprefine` refine mesh near rift tips

## Model parameterization

- `extrude` vertically extrude a model
- `setmask` establish boundaries between grounded and floating ice
- `modelextract` extract the model over a subdomain
- `parameterize` model general parameterization
- `setflowequation` set stressbalance elements type
- `solversettoasm` set PETSc solver to ASM
- `solversettomumps` set PETSc solver to MUMPS
- `solversettosor` set PETSc solver to SOR
- `SetIceSheetBC` set ice sheet boundary conditions
- `SetIceShelfBC` set ice shelf boundary conditions
- `SetMarineIceSheetBC` set marine ice sheet boundary conditions

## Mask

- `contourenvelope` create a list of segments enveloping an ARGUS contour
- `ContourToMesh` get elements and/or nodes inside an ARGUS contour
- `GetAreas` compute the area of each element
- `xy2ll` convert (x,y) to lat/lon
- `ll2xy` convert lat/lon to (x,y)
- `utm2ll` convert UTM to lat/lon

## Interpolation

- `InterpFromGridToMesh` interpolation from a grid to a list of (x,y)
- `InterpFromMeshToGrid` interpolation from a 2D mesh to a grid
- `InterpFromMeshToMesh2d` interpolation from a 2D mesh to a list of (x,y)

## ARGUS files

- `expcoarsen` coarsen or refine the resolution a contour
- `exptool` create and manage ARGUS files
- `expread` read an ARGUS file
- `expwrite` write an ARGUS file

## Results analysis

- `averaging` data averaging over a mesh
- `basalstress` compute the basal stress
- `contourmassbalance` compute the mass balance of a contour
- `DepthAverage` depth averaging of a 3D field
- `drivingstress` compute the driving stress
- `flowlines` compute the coordinates of one or several flowlines
- `paterson` compute B from a temperature
- `project2d` project a 3D field on a layer
- `project3d` extrude a 2D field on every layer
- `SectionValues` compute the value of a field on a section or line
- `thicknessevolution` compute dh/dt

