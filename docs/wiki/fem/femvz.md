---
title: Vertical Velocity
layout: default
math: mathjax3
parent: Wiki
nav_order: 1
---

# Finite Element Formulation of Vertical Speed for Depth Integrated Models
*Mathieu Morlighem, Helene Seroussi*

## Equations

We use incompressibility to calculate the vertical component of the velocity:

$$
\frac{\partial w}{\partial z}=-\frac{\partial u}{\partial x}-\frac{\partial v}{\partial y}
\tag{1}
$$

The boundary condition on the lower surface is $$w=w_b$$ with:

$$
w_b =\frac{\partial b}{\partial t} + u \frac{\partial b}{\partial x}+v \frac{\partial b}{\partial y} -\dot{M_b}
$$

We assume a quasistatic equilibrium so that the term $$\frac{\partial b}{\partial t}$$ is neglected:

$$
w_b =u \frac{\partial b}{\partial x}+v \frac{\partial b}{\partial y} -\dot{M_b}
$$

## Vertical velocity weak formulation

As usual, we define a kinematically admissible velocity field $$\phi$$:

$$
\phi(x,y,z)\in\lbrace H^{1}(\Omega\cup\partial\Omega) \rbrace
$$

If one integrates the product of equation (1) by a kinematically admissible velocity field:

$$
\iiint_\Omega \frac{\partial w}{\partial z}\phi \, d\Omega
=
- \iiint_\Omega
\frac{\partial u}{\partial x}\phi + \frac{\partial v}{\partial y}\phi \, d\Omega
$$

One can integrate by parts the left-hand side of the previous equation:

$$
\iiint_\Omega w \frac{\partial \phi}{\partial z} \, d\Omega
=
\iiint_\Omega
\frac{\partial u}{\partial x}\phi + \frac{\partial v}{\partial y}\phi \, d\Omega +
\iint_{\partial\Omega }
w\phi n_z \, d\Gamma
$$

where $$\overrightarrow{n}=( n_x, n_y, n_z)$$ is the unit normal vector pointing outward from the glacier. Since we work on a vertically extruded mesh, $$n_z$$ is equal to zero except on the upper and lower surfaces $$\Gamma_b \cup \Gamma_s$$.

$$
\iiint_\Omega w \frac{\partial \phi}{\partial z} \, d\Omega
=
\iiint_\Omega
\frac{\partial u}{\partial x}\phi + \frac{\partial v}{\partial y}\phi \, d\Omega +
\iint_{\Gamma_s} w\phi n_z \, d\Gamma + \iint_{\Gamma_b} w\phi n_z \, d\Gamma
$$

The term $$\displaystyle \iint_{ \Gamma_s} w\phi n_z \, d\Gamma$$ is unknown. Therefore, we put it in the left-hand side of the weak formulation and we use the lower boundary condition to determine $$w_b$$:

$$
\iiint_\Omega w \frac{\partial \phi}{\partial z} \, d\Omega
-
\iint_{\Gamma_s}
w\phi n_z \, d\Gamma
=
\iiint_\Omega
\frac{\partial u}{\partial x}\phi + \frac{\partial v}{\partial y}\phi \, d\Omega
+\iint_{\Gamma_b} u \frac{\partial b}{\partial x} \phi n_z +v \frac{\partial b}{\partial y} \phi
n_z \, d\Gamma
+\iint_{\Gamma_b} -\dot{M_b} \phi n_z \, d\Gamma
$$

## Finite element discretisation, Galerkin method

The domain is meshed using pentahedrons. There are $$nel$$ elements and $$nods$$ grids. We use the nodal functions of each grid, which are continuous on the domain and affine on each element.
We now project the unknown $$w$$ on the nodal functions $$(\phi_i)_{1\leq i\leq nods}$$:

$$
w\left( x,y,z\right) = \sum_{i=1}^{nods}w_{i}\phi_{i}\left( x,y,z\right)
$$

We build a vector $$W$$ that holds all the unknowns of the velocity field:

$$
W=\left[ \begin{array}{c}
w_{1}\\
\vdots\\
w_{nods}
\end{array} \right]
$$

With this new field, we replace the virtual function $$\phi$$ by the nodal functions. For all $$1 \leq i \leq nods$$:

$$
\sum_{j=1}^{nods}
\iiint_\Omega w_j \phi_j \frac{\partial \phi_i}{\partial z} \, d\Omega
-
\iint_{\Gamma_s}
w_j \phi_j\phi_i n_z \, d\Gamma
=
\iiint_\Omega
\frac{\partial u}{\partial x}\phi_i + \frac{\partial v}{\partial y}\phi_i \, d\Omega
+\iint_{\Gamma_b} u \frac{\partial b}{\partial x} \phi_i n_z +v \frac{\partial b}{\partial y}
\phi_i n_z \, d\Gamma
+\iint_{\Gamma_b} -\dot{M_b} \phi_i n_z \, d\Gamma
$$

We see the stiffness matrix $$K$$ and load vector $$F$$ appearing, so that the previous equations can be written as a system matrix:

$$
\left[ K \right] W =F
$$

We use the following index:

$$
\left[
\begin{array}{c c c}
& \vdots  &\\
\cdots & K & \cdots\\
& \vdots  &\\
\end{array}
\right]
\left[
\begin{array}{c}
\vdots \\
w_j\\
\vdots\\
\end{array}
\right]
=
\left[
\begin{array}{c}
\vdots \\
F_{i}\\
\vdots\\
\end{array}
\right]
$$

And we have the following expressions for the stiffness matrix and the load vector:

$$
\begin{aligned}
K_{i,j} &= \iiint_\Omega \phi_j \frac{\partial \phi_i}{\partial z} \, d\Omega
- \iint_{\Gamma_s} \phi_j \phi_i n_z \, d\Gamma \\
F_{i} &= \iiint_\Omega
\frac{\partial u}{\partial x}\phi_i + \frac{\partial v}{\partial y}\phi_i \, d\Omega
+\iint_{\Gamma_b} u \frac{\partial b}{\partial x} \phi_i n_z +v \frac{\partial b}{\partial y}
\phi_i n_z \, d\Gamma
+\iint_{\Gamma_b} -\dot{M_b} \phi_i n_z \, d\Gamma
\end{aligned}
$$

## Elementary stiffness matrix

To compute the elementary stiffness matrix, we first remove the integral over the upper surface, which creates a first elementary stiffness matrix $$K1$$. The upper surface integral constitutes another stiffness matrix $$K2$$. The elementary stiffness matrix is the sum of $$K1$$ and $$K2$$ ($$K_E=K1+K2$$).

### Without the upper surface

This matrix has the following shape, for $$1 \leq i \leq 6$$ and $$1 \leq j \leq 6$$:

$$
K1_{i,j}=
\iiint_E \phi_j \frac{\partial \phi_i}{\partial z} \, dV
$$

### Upper surface integral

The upper surface involves only the three nodes on the top of the upper pentahedrons of the mesh (which are the last three grids of the pentahedron grid lists). The elements are triangles and there are only three nodal functions to take into account. Therefore, this stiffness matrix is $$3 \times 3$$.

The upper-surface matrix has the following shape, for $$4 \leq i \leq 6$$ and $$4 \leq j \leq 6$$:

$$
K2_{i,j}=
-
\iint_{E\cap\Gamma_s}
\phi_j \phi_i n_z \, d\Gamma
$$

## Elementary load vector

### Volume term

The volume part of the elementary load vector has the following shape:

$$
F_{i} =
\iiint_E  \frac{\partial}{\partial x}\left( \sum_{k=1}^6 u_k \phi_k \right) \phi_i + \frac{\partial}{\partial y}\left( \sum_{k=1}^6 v_k \phi_k \right)\phi_i \, dV
$$

### Lower surface integral

The lower surface involves only the three lower nodes on the base of the lower pentahedrons of the mesh. So the elements are triangles and there are only three nodal functions to take into account. That is why the size of the elementary load vector is only three.

The load vector for the basal boundary condition is, for $$1 \leq i \leq 3$$:

$$
Fb_{i} =
+\iint_{\Gamma_b} \left( \sum_{k=1}^6 u_k \phi_k \right) \frac{\partial b}{\partial x} \phi_i n_z
+ \left( \sum_{k=1}^6 v_k \phi_k \right) \frac{\partial b}{\partial y} \phi_i n_z \, d\Gamma
+\iint_{\Gamma_b} -\dot{M_b} \phi_i n_z \, d\Gamma
$$
