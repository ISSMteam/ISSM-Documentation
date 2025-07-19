---
title: Interpolation Routines
layout: default
parent: Capabilities
---

## Interpolation Routines
Several interpolation routines can be used in order to interpolate datasets onto the mesh vertices.

`ContourToMesh` is used to flag the nodes and/or elements that are within a contour from an Argus contour and a mesh. For example,
````
gridinsidefront = ContourToMesh(md.mesh.elements, md.mesh.x, md.mesh.y, expread('Front.exp', 1), 'node');
````

To interpolate a field from a structured grid to an unstructured mesh (or any list of points), one can use `InterpFromGridToMesh`,
````
data_mesh = InterpFromGridToMesh(x_grid, y_grid, data, x_mesh, y_mesh)
````

To interpolate a field from a 2d mesh to a 2d mesh (or any list of points), one can use `InterpFromMeshToMesh2d`,
````
data_mesh2 = InterpFromMeshToMesh2d(index_mesh1, x_mesh1, y_mesh1, data, x_mesh2, y_mesh2)
````

To interpolate a field from a 3d mesh to a 3d mesh (or any list of points), one can use `InterpFromMeshToMesh3d`,
````
data_mesh2 = InterpFromMeshToMesh3d(index_mesh1, x_mesh1, y_mesh1, z_mesh1, data, x_mesh2, y_mesh2, z_mesh2)
````

