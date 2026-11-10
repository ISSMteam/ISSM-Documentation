---
title: Shelfy-Stream Approximation
layout: default
math: mathjax3
parent: Wiki
has_toc: false
---

# Finite Element Formulation of the Shelfy Stream Approximation (SSA)
*Mathieu Morlighem, Helene Seroussi*

ISSM uses the finite element method to solve the SSA equations. This page explains how we built the finite element model. MacAyeal's model formulation is very detailed for those who are not very familiar with the finite element method. For more details, the reader is invited to consult Zienkiewicz, *The Finite Element Method, Fourth Edition*, 1994.

## MacAyeal's Shelfy-stream model

### Geometry and notations

<img src="/ISSM-Documentation/assets/img/wiki/femssa/schema5.png" alt="Geometry and notations" style="width:60%">

We adopt the following notations:

- $$\Omega$$ is the model domain
- $$\partial\Omega$$ is the model boundary
- $$\Gamma_i$$ is the ice front
- $$\Gamma_u=\partial\Omega\backslash\Gamma_i$$ are the points at the boundary where the velocity is prescribed, such that $$\Gamma_i\cup\Gamma_u=\partial\Omega$$

### Equations

The equations of MacAyeal's Shelfy-stream model are:

$$
\left\{ \begin{array}{l}
\displaystyle \frac{\partial}{\partial x} \left( 2H \mu \left( 2\frac{\partial u}{\partial x}+\frac{\partial v}{\partial y}\right) \right)
+\frac{\partial}{\partial y}\left( H\mu \left( \frac{\partial u}{\partial y}+\frac{\partial v}{\partial x}\right) \right)
-\rho g H \frac{\partial s}{\partial x} +\tau_x=0\\
\\
\displaystyle \frac{\partial}{\partial y} \left( 2H \mu \left( 2\frac{\partial v}{\partial y}+\frac{\partial u}{\partial x}\right) \right)
+\frac{\partial}{\partial x}\left( H\mu \left( \frac{\partial u}{\partial y}+\frac{\partial v}{\partial x}\right) \right)
-\rho g H \frac{\partial s}{\partial y}+\tau_y=0
\end{array} \right.
\tag{1}
$$

At the ice front, the boundary condition is:

$$
\sigma \cdot {\bf n} = -P_w {\bf n}
\tag{2}
$$

where $${\bf n}$$ is the outward pointing normal vector, and $$P_w= - \rho_w g z$$ is the water pressure ($$z\leq 0$$).

In the $$x$$ direction, this boundary condition is:

$$
\sigma_{xx} n_x + \sigma_{xy} n_y + \sigma_{xz} n_z = \rho_w g z n_x
$$

Using the deviatoric stress instead of the Cauchy stress tensor, and SSA's assumption that vertical shear is negligible:

$$
\sigma'_{xx} n_x + \sigma'_{xy} n_y -P\,n_x= \rho_w g z n_x
$$

The vertical equation of SSA, however, reads

$$
\frac{\partial \sigma'_{zz}}{\partial z} - \frac{\partial P}{\partial z} -\rho_i g = 0
$$

and so the pressure is defined as:

$$
P\left(z\right) = \sigma'_{zz} + \rho_i g \left(s-z\right) = -\sigma'_{xx} -\sigma'_{yy} + \rho_i g \left(s-z\right)
$$

Using this equation, the frontal boundary condition becomes:

$$
\sigma'_{xx} n_x + \sigma'_{xy} n_y + \left(\sigma'_{xx} +\sigma'_{yy} - \rho_i g \left(s-z\right)\right)\,n_x= \rho_w g z n_x
$$

or

$$
\left(2\sigma'_{xx} +\sigma'_{yy}\right)n_x + \sigma'_{xy} n_y
= \left(\rho_i g \left(s-z\right) + \rho_w g z\right) n_x
$$

Depth integrating this equation yields:

$$
\begin{aligned}
\left(2H\sigma'_{xx} +H\sigma'_{yy}\right)n_x + H\sigma'_{xy} n_y
&= \left( \int_b^s \rho g \left( s-z \right) dz+\int_b^0 \rho_w g z \, dz \right) n_x\\
&= \left( \frac{1}{2}\rho g H^2 -\frac{1}{2} \rho_w g b^2 \right) n_x
\end{aligned}
$$

A similar argument in the $$y$$ direction yields:

$$
\left(H\sigma'_{xx} +2H\sigma'_{yy}\right)n_y + H\sigma'_{xy} n_x
=\left( \frac{1}{2}\rho g H^2 -\frac{1}{2} \rho_w g b^2 \right) n_y
$$

These are the integrals that appear when we derive the weak formulation in the next section.

We assume that the Dirichlet condition on $$\Gamma_u$$ is $$0$$ for the sake of simplicity. At the end of the process, the velocity field is updated to take these constraints into account through the lifting method.

### Weak formulation

Now that we have the field equations and boundary conditions, we write the weak formulation to solve these equations using finite elements. We define a kinematically admissible velocity field $$\boldsymbol\phi$$:

$$
\boldsymbol\phi(x,y)\in\lbrace \left( H^{1}(\Omega\cup\partial\Omega) \right)^2 \quad | \quad
\boldsymbol\phi(x,y)={\bf 0}\quad (x,y)\in\Gamma_u\rbrace
$$

where $$H^{1}(\Omega\cup\partial\Omega)$$ is the Sobolev space of square-integrable functions that have a square-integrable first derivative, and each component $$(\phi_x,\phi_y)$$ of $$\boldsymbol\phi$$ is in $$H^{1}(\Omega\cup\partial\Omega)$$.

We take the scalar product of equations (1) with $$\boldsymbol\phi=\left(\phi_x,0 \right)$$ and $$\boldsymbol\phi=\left(0,\phi_y \right)$$, which are also kinematically admissible, and integrate over the domain:

$$
\iint_\Omega
\left( \frac{\partial}{\partial x} \left(2 H \mu \left( 2\frac{\partial u}{\partial x}+\frac{\partial v}{\partial y}\right) \right)\phi_x
+\frac{\partial}{\partial y}\left( H\mu \left( \frac{\partial u}{\partial y}+\frac{\partial v}{\partial x}\right) \right)\phi_x
-\rho g H \frac{\partial s}{\partial x}\phi_x +\tau_x\phi_x \right)  d\Omega =0
$$

$$
\iint_\Omega
\left(\frac{\partial}{\partial y} \left( 2H \mu \left( 2\frac{\partial v}{\partial y}+\frac{\partial u}{\partial x}\right) \right) \phi_y
+\frac{\partial}{\partial x}\left( H\mu \left( \frac{\partial u}{\partial y}+\frac{\partial v}{\partial x}\right) \right) \phi_y
-\rho g H \frac{\partial s}{\partial y}\phi_y +\tau_y\phi_y \right) d\Omega =0
$$

We integrate by parts the first two terms in order to include the force on the ice front $$\Gamma_i$$:

$$
\iint_\Omega
2H \mu \left( 2\frac{\partial u}{\partial x}+\frac{\partial v}{\partial y}\right) \frac{\partial \phi_x}{\partial x}
+ H\mu \left( \frac{\partial u}{\partial y}+\frac{\partial v}{\partial x}\right)  \frac{\partial \phi_x }{\partial y} -\tau_x\phi_x \, d\Omega
=\int_{\Gamma_i} F_x\phi_x \, d\Gamma -
\iint_\Omega
\rho g H \frac{\partial s}{\partial x}\phi_x \, d\Omega
\tag{3}
$$

$$
\iint_\Omega
2 H \mu \left( 2\frac{\partial v}{\partial y}+\frac{\partial u}{\partial x}\right) \frac{\partial \phi_y}{\partial y}
+ H\mu \left( \frac{\partial u}{\partial y}+\frac{\partial v}{\partial x}\right)  \frac{\partial \phi_y}{\partial x}  -\tau_y\phi_y \, d\Omega
=\int_{\Gamma_i} F_y\phi_y \, d\Gamma -
\iint_\Omega
\rho g H \frac{\partial s}{\partial y}\phi_y \, d\Omega
\tag{4}
$$

## Finite element discretisation, Galerkin method

The domain is meshed using triangles. There are $$nel$$ elements and $$nods$$ nodes. We use the nodal functions $$(\phi_i)_{1\leq i\leq nods}$$ of each node, which are continuous on the domain and affine on each element. We project the unknowns on the nodal functions:

$$
u\left( x,y\right) = \sum_{i=1}^{nods}u_{i}\phi_{i}\left( x,y\right), \qquad
v\left( x,y\right) = \sum_{i=1}^{nods}v_{i}\phi_{i}\left( x,y\right)
$$

We build a vector $$U$$ that holds all the unknowns of the velocity field:

$$
U=\left[ \begin{array}{c}
u_{1}\\
v_{1}\\
\vdots\\
u_{nods}\\
v_{nods}
\end{array} \right]
$$

With this new field and with $$\tau_x = -\alpha^2 u$$, $$\tau_y = -\alpha^2 v$$, we have, for all $$1 \leq i \leq nods$$:

$$
\sum_{j=1}^{nods} \iint_\Omega
2H \mu \left( 2 u_{j} \frac{\partial \phi_{j}}{\partial x}+v_j \frac{\partial \phi_{j}}{\partial y}\right) \frac{\partial \phi_i}{\partial x}
+ H\mu \left( u_j \frac{\partial \phi_{j}}{\partial y}+v_j \frac{\partial \phi_{j}}{\partial x}\right)  \frac{\partial \phi_i }{\partial y} +\alpha^2 u_j\phi_j \phi_i \, d\Omega
=\int_{\Gamma_i} F_x\phi_i \, d\Gamma -
\iint_\Omega
\rho g H \frac{\partial s}{\partial x}\phi_i \, d\Omega
$$

$$
\sum_{j=1}^{nods} \iint_\Omega
2 H \mu \left( 2 v_j \frac{\partial \phi_{j}}{\partial y}+u_j \frac{\partial \phi_{j}}{\partial x}\right) \frac{\partial \phi_i}{\partial y}
+ H\mu \left( u_j\frac{\partial \phi_{j}}{\partial y}+v_j\frac{\partial \phi_{j}}{\partial x}\right)  \frac{\partial \phi_i}{\partial x}  +\alpha^2 v_j\phi_j\phi_i \, d\Omega
=\int_{\Gamma_i} F_y\phi_i \, d\Gamma -
\iint_\Omega
\rho g H \frac{\partial s}{\partial y}\phi_i \, d\Omega
$$

By rearranging terms, for all $$1 \leq i \leq nods$$:

$$
\sum_{j=1}^{nods} \iint_\Omega
\left( 4 H \mu \frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_i}{\partial x}
+ H \mu \frac{\partial \phi_{j}}{\partial y} \frac{\partial \phi_i}{\partial y} +\alpha^2 \phi_j \phi_i \right)  u_j
+ \left( 2 H \mu \frac{\partial \phi_{j}}{\partial y}\frac{\partial \phi_i }{\partial x} +
H \mu\frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_{i}}{\partial y} \right) v_j  \, d\Omega
=\int_{\Gamma_i} F_x\phi_i \, d\Gamma -
\iint_\Omega
\rho g H \frac{\partial s}{\partial x}\phi_i \, d\Omega
$$

$$
\sum_{j=1}^{nods} \iint_\Omega
\left( 2 H \mu \frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_i}{\partial y}
+ H \mu \frac{\partial \phi_{j}}{\partial y} \frac{\partial \phi_i}{\partial x} \right)  u_j
+ \left( 4 H \mu \frac{\partial \phi_{j}}{\partial y}\frac{\partial \phi_i }{\partial y} +
H \mu\frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_{i}}{\partial x}+\alpha^2 \phi_j \phi_i  \right) v_j  \, d\Omega
=\int_{\Gamma_i} F_y\phi_i \, d\Gamma -
\iint_\Omega
\rho g H \frac{\partial s}{\partial y}\phi_i \, d\Omega
$$

We see the stiffness matrix $$K$$ and load vector $$F$$ appearing, so that the previous equation can be written in matrix form:

$$
\left[ K \right] U =F
$$

or

$$
\left[
\begin{array}{c c c c}
& \vdots & \vdots & \\
\cdots & K_{2i-1,2j-1} &  K_{2i-1,2j} & \cdots\\
&&& \\
\cdots & K_{2i,2j-1} &  K_{2i,2j} & \cdots\\
& \vdots & \vdots & \\
\end{array}
\right]
\left[
\begin{array}{c}
\vdots \\
u_j\\
\\
v_j\\
\vdots
\end{array}
\right]
=
\left[
\begin{array}{c}
\vdots \\
F_{2i-1}\\
\\
F_{2i}\\
\vdots
\end{array}
\right]
$$

We have the following expressions:

$$
\begin{aligned}
K_{2i-1,2j-1} &= \iint_\Omega
\left( 4 H \mu \frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_i}{\partial x}
+ H \mu \frac{\partial \phi_{j}}{\partial y} \frac{\partial \phi_i}{\partial y} +\alpha^2 \phi_j \phi_i \right) d\Omega\\
K_{2i-1,2j} &= \iint_\Omega
\left( 2 H \mu \frac{\partial \phi_{j}}{\partial y}\frac{\partial \phi_i }{\partial x} +
H \mu\frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_{i}}{\partial y} \right) d\Omega \\
K_{2i,2j-1} &= \iint_\Omega
\left( 2 H \mu \frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_i}{\partial y}
+ H \mu \frac{\partial \phi_{j}}{\partial y} \frac{\partial \phi_i}{\partial x} \right)  d\Omega\\
K_{2i,2j} &= \iint_\Omega
\left( 4 H \mu \frac{\partial \phi_{j}}{\partial y}\frac{\partial \phi_i }{\partial y} +
H \mu\frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_{i}}{\partial x}+\alpha^2 \phi_j \phi_i  \right)  d\Omega \\
F_{2i-1} &= \int_{\Gamma_i} F_x\phi_i \, d\Gamma -
\iint_\Omega \rho g H \frac{\partial s}{\partial x}\phi_i \, d\Omega\\
F_{2i} &= \int_{\Gamma_i} F_y\phi_i \, d\Gamma -
\iint_\Omega \rho g H \frac{\partial s}{\partial y}\phi_i \, d\Omega
\end{aligned}
$$

## Decomposition over the elements

The integrals over $$\Omega$$ can be divided into integrals over each element. Since the mesh contains $$nel$$ elements, the previous equations become, for all $$1 \leq i \leq nods$$:

$$
\sum_{E=1}^{nel} \sum_{j=1}^{nods} \iint_E
\left[ \left( 4 H \mu \frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_i}{\partial x}
+ H \mu \frac{\partial \phi_{j}}{\partial y} \frac{\partial \phi_i}{\partial y} +\alpha^2 \phi_j \phi_i \right)  u_j
+ \left( 2 H \mu \frac{\partial \phi_{j}}{\partial y}\frac{\partial \phi_i }{\partial x} +
H \mu\frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_{i}}{\partial y} \right) v_j \right]
dS
=\sum_{E=1}^{nel} \left(
\int_{E \cap\Gamma_i}
F_x\phi_i \, dl -
\iint_E
\rho g H \frac{\partial s}{\partial x}\phi_i \, dS
\right)
$$

$$
\sum_{E=1}^{nel} \sum_{j=1}^{nods}
\iint_E
\left[ \left( 2 H \mu \frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_i}{\partial y}
+ H \mu \frac{\partial \phi_{j}}{\partial y} \frac{\partial \phi_i}{\partial x} \right)  u_j
+ \left( 4 H \mu \frac{\partial \phi_{j}}{\partial y}\frac{\partial \phi_i }{\partial y} +
H \mu\frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_{i}}{\partial x}+\alpha^2 \phi_j \phi_i  \right) v_j \right]
dS
=\sum_{E=1}^{nel}\left(
\int_{E \cap\Gamma_i} F_y\phi_i \, dl -
\iint_E
\rho g H \frac{\partial s}{\partial y}\phi_i \, dS
\right)
$$

To compute $$K$$ and $$F$$, instead of calculating the integral over $$\Omega$$ directly, we first integrate over each element $$E$$ of the mesh to obtain several *elementary matrices*, which are assembled into the final stiffness matrix and load vector during the assembly process.

The nodal functions are built so that for all $$1\leq i \leq nods$$:

$$
\phi_i(N_j)=\delta_{ij}
$$

where $$\delta_{ij}$$ is the Kronecker symbol. The nodal function is equal to 1 at its node and 0 at every other node. So for one element $$E$$, the only nodal functions that contribute are those corresponding to the vertices of the element. Since the elements are triangles, only 3 nodal functions need to be taken into account.

One element $$E$$ gives 6 equations: we take 3 nodal functions for $$\phi_i(x,y)$$, and each $$\phi_i$$ gives 2 equations (one for the $$x$$-component and one for the $$y$$-component). Therefore, an element stiffness matrix $$K_E$$ is $$6 \times 6$$, and the elementary load vector has size $$6$$.

## Reference element and numerical integration

Rather than calculating these integrals for each element, one uses a *reference element* $$\hat{E}$$ and a transformation $$\varphi$$ that maps the reference element to the element $$E$$:

<img src="/ISSM-Documentation/assets/img/wiki/femssa/triaelem.png" alt="Transformation from the reference triangle to the current element of the mesh" style="width:100%">

For any function $$f(x,y)$$, the transformation imposes that:

$$
\iint_E f(x,y)dS = \iint_{\hat{E}} \hat{f}(r,s) \vert J \vert d\hat{S}
$$

where $$J$$ is the Jacobian of $$\varphi$$, which is constant over the element:

$$
J=
\left[
\begin{array}{c c}
\displaystyle
\frac{1}{2}\left( x_2-x_1 \right) & \displaystyle  \frac{\sqrt{3}}{6}\left(2x_3-x_1-x_2\right) \\
\\
\displaystyle
\frac{1}{2}\left( y_2- y_1\right)& \displaystyle  \frac{\sqrt{3}}{6}\left(2y_3-y_1-y_2\right)
\end{array}
\right]
$$

Since ISSM is a C++ code, the integrals cannot be calculated analytically. The numerical integration uses Gaussian quadrature to approximate the integral as a weighted sum of function values at specified points (Gauss points) within the domain:

$$
\iint_E f(x,y)dS = \iint_{\hat{E}} \hat{f}(r,s) \vert J\vert d\hat{S} \simeq \sum_{g=1}^{n} w_g \hat{f}(r_g,s_g)
$$

where $$w_g$$ are the quadrature weights and $$(r_g,s_g)$$ are the evaluation points, $$g=1,2,\dots,n$$. The Gauss quadrature is such that the computed integral is exact for all polynomials up to a certain degree. All the integrals that appear in the stiffness matrix and load vector involve polynomials since nodal functions are polynomials of degree 1. It is then easy to evaluate the degree of the polynomial to integrate (usually 2), and then find the Gauss quadrature that gives an exact result.

The integration points are given with their area coordinates:

$$
(r_g,s_g)\equiv \left(\frac{A_1}{A_1+A_2+A_3},\frac{A_2}{A_1+A_2+A_3},\frac{A_3}{A_1+A_2+A_3}\right)
$$

We use this system of coordinates because of the following property:

$$
1 \leq k \leq 3\quad \quad \frac{A_k}{A_1+A_2+A_3}=L_k(r_i,s_i)
$$

<img src="/ISSM-Documentation/assets/img/wiki/femssa/barycentric_tria.png" alt="Area coordinates" style="width:50%">

The number of Gauss points depends on the order of integration, which can be computed from the polynomial degree $$p$$ that needs to be integrated:

$$
order=\frac{p+1}{2}
$$

Here, the degree of the polynomial under the integral is $$2$$ (the drag involves $$\phi_j \phi_i$$, whose degree is 2). The order of integration is hence 2 (the order must be an integer). For this order, $$3$$ Gauss points are required:

| Gauss point | 1 | 2 | 3 |
|---|---|---|---|
| Weight | 0.577 | 0.577 | 0.577 |
| Area coordinates | $$(2/3,\ 1/6,\ 1/6)$$ | $$(1/6,\ 2/3,\ 1/6)$$ | $$(1/6,\ 1/6,\ 2/3)$$ |

## Element stiffness matrix

To compute the element stiffness matrix, we first remove the basal drag, which creates a first element stiffness matrix $$K1$$. The basal drag constitutes another stiffness matrix $$K2$$. The element stiffness matrix is the sum of $$K1$$ and $$K2$$ ($$K_E=K1+K2$$).

### Without basal drag

This matrix has the following shape, for $$1 \leq i \leq 3$$ and $$1 \leq j \leq 3$$:

$$
\begin{aligned}
K1_{2i-1,2j-1} &= \iint_E
\left( 4 H \mu \frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_i}{\partial x}
+ H \mu \frac{\partial \phi_{j}}{\partial y} \frac{\partial \phi_i}{\partial y}\right) d\Omega\\
K1_{2i-1,2j} &= \iint_E
\left( 2 H \mu \frac{\partial \phi_{j}}{\partial y}\frac{\partial \phi_i }{\partial x} +
H \mu\frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_{i}}{\partial y} \right) d\Omega \\
K1_{2i,2j-1} &= \iint_E
\left( 2 H \mu \frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_i}{\partial y}
+ H \mu \frac{\partial \phi_{j}}{\partial y} \frac{\partial \phi_i}{\partial x} \right)  d\Omega\\
K1_{2i,2j} &= \iint_E
\left( 4 H \mu \frac{\partial \phi_{j}}{\partial y}\frac{\partial \phi_i }{\partial y} +
H \mu\frac{\partial \phi_{j}}{\partial x} \frac{\partial \phi_{i}}{\partial x} \right)  d\Omega
\end{aligned}
$$

Using the reference element $$\hat{E}$$ and the Gauss points, this matrix becomes:

$$
\begin{aligned}
K1_{2i-1,2j-1} &\simeq
\sum_{g=1}^3  w_g \left( 4 H \mu \frac{\partial L_{j}}{\partial x} \frac{\partial L_i}{\partial x}
+ H \mu \frac{\partial L_{j}}{\partial y} \frac{\partial L_i}{\partial y}\right) \vert J \vert  \\
K1_{2i-1,2j} &\simeq
\sum_{g=1}^3  w_g
\left( 2 H \mu \frac{\partial L_{j}}{\partial y}\frac{\partial L_i }{\partial x} +
H \mu\frac{\partial L_{j}}{\partial x} \frac{\partial L_{i}}{\partial y} \right) \vert J \vert\\
K1_{2i,2j-1} &\simeq
\sum_{g=1}^3  w_g
\left( 2 H \mu \frac{\partial L_{j}}{\partial x} \frac{\partial L_i}{\partial y}
+ H \mu \frac{\partial L_{j}}{\partial y} \frac{\partial L_i}{\partial x} \right)
\vert J \vert\\
K1_{2i,2j} &\simeq
\sum_{g=1}^3  w_g
\left( 4 H \mu \frac{\partial L_{j}}{\partial y}\frac{\partial L_i }{\partial y} +
H \mu\frac{\partial L_{j}}{\partial x} \frac{\partial L_{i}}{\partial x} \right)
\vert J \vert
\end{aligned}
$$

where the derivatives $$\partial L_i/\partial x$$ and $$\partial L_i/\partial y$$ are evaluated at the Gauss point $$(r_g,s_g)$$.

#### Computation of nodal function derivatives

The computation of $$\displaystyle \frac{\partial L_i}{\partial x}$$ and $$\displaystyle \frac{\partial L_i}{\partial y}$$ is done using the Jacobian of $$\varphi$$. We have:

$$
\left[
\begin{array}{c}
\displaystyle
\frac{\partial L_i}{\partial x}\\
\\
\displaystyle
\frac{\partial L_i}{\partial y}
\end{array}
\right] = \left[
\begin{array}{c c}
\displaystyle
\frac{\partial r}{\partial x} & \displaystyle \frac{\partial s}{\partial x}\\
\\
\displaystyle
\frac{\partial r}{\partial y} & \displaystyle \frac{\partial s}{\partial y}
\end{array}
\right]
\left[
\begin{array}{c}
\displaystyle
\frac{\partial L_i}{\partial r}\\
\\
\displaystyle
\frac{\partial L_i}{\partial s}
\end{array}
\right]
$$

The Jacobian of $$\varphi$$ is:

$$
\left[ J_\varphi\right]=
\left[
\begin{array}{c c}
\displaystyle
\frac{\partial \varphi_x }{\partial r} & \displaystyle  \frac{\partial \varphi_x }{\partial s} \\
\\
\displaystyle
\frac{\partial \varphi_y }{\partial r} & \displaystyle  \frac{\partial \varphi_y }{\partial s}
\end{array}
\right]
$$

We have $$\left[ J_\varphi\right] ^{-1}=\left[ J_{\varphi^{-1}}\right]$$, which gives:

$$
\left[ J_\varphi\right] ^{-1}=
\left[
\begin{array}{c c}
\displaystyle
\frac{\partial r}{\partial x } & \displaystyle  \frac{\partial r }{\partial y } \\
\\
\displaystyle
\frac{\partial s }{\partial x } & \displaystyle  \frac{\partial s }{\partial y }
\end{array}
\right]
$$

And finally, we obtain:

$$
\left[
\begin{array}{c}
\displaystyle
\frac{\partial L_i}{\partial x}\\
\\
\displaystyle
\frac{\partial L_i}{\partial y}
\end{array}
\right] = \left( \left[
J
\right]^{-1} \right) ^{T}
\left[
\begin{array}{c}
\displaystyle
\frac{\partial L_i}{\partial r}\\
\\
\displaystyle
\frac{\partial L_i}{\partial s}
\end{array}
\right]
$$

### Basal drag

This matrix has the following shape:

$$
K2_{2i-1,2j-1}= K2_{2i,2j}=
\iint_E \alpha^2 \phi_j \phi_i  \, d\Omega, \qquad
K2_{2i-1,2j}= K2_{2i,2j-1}= 0
$$

Using the reference element $$\hat{E}$$ and the Gauss points, this matrix becomes:

$$
K2_{2i-1,2j-1}= K2_{2i,2j} =
\iint_{\hat{E}} \alpha^2 L_j(r,s) L_i(r,s) \vert J \vert d\hat{S}
\simeq \sum_{g=1}^3 w_g \alpha^2 L_j(r_g,s_g) L_i(r_g,s_g) \vert J \vert
$$

The values $$L_i(r_g,s_g)$$ are equal to the components of the area coordinates (e.g. $$L_1(r_2,s_2)=1/6$$).

## Element load vector

To compute the elementary load vector, we first calculate the force due to the driving stress only, and then add to this vector the force on the ice front due to the water pressure.

### Driving stress

The elementary load vector due to driving stress has the following shape:

$$
F1_{2i-1}= -\iint_E \rho g H \frac{\partial s}{\partial x}\phi_i \, d\Omega, \qquad
F1_{2i}= -\iint_E \rho g H \frac{\partial s}{\partial y}\phi_i \, dS
$$

The slopes $$\partial s/\partial x$$ and $$\partial s/\partial y$$ are constant on the element. Using the reference element $$\hat{E}$$ and the Gauss points, this vector becomes:

$$
\begin{aligned}
F1_{2i-1} &= -\iint_{\hat{E}} \rho g H \frac{\partial s}{\partial x}L_i(r,s) \vert J \vert d\hat{S}
\simeq \sum_{g=1}^3 - w_g \rho g H \frac{\partial s}{\partial x} L_i(r_g,s_g) \vert J \vert \\
F1_{2i} &= -\iint_{\hat{E}} \rho g H \frac{\partial s}{\partial y}L_i(r,s) \vert J \vert d\hat{S}
\simeq \sum_{g=1}^3 - w_g \rho g H \frac{\partial s}{\partial y} L_i(r_g,s_g) \vert J \vert
\end{aligned}
$$

### Ice front

The load on the ice front has the following shape:

$$
F2_{2i-1}=\int_{E \cap\Gamma_i}\left( \frac{1}{2}\rho g H^2 -\frac{1}{2}\rho_w g b^2\right)n_x\phi_i \, dl, \qquad
F2_{2i}=\int_{E \cap\Gamma_i} \left( \frac{1}{2}\rho g H^2 -\frac{1}{2}\rho_w g b^2\right)n_y\phi_i \, dl
$$

Here, the reference element is a segment. Using this reference element $$\hat{E}$$ and the Gauss points, this vector becomes:

$$
\begin{aligned}
F2_{2i-1} &\simeq \sum_{g=1}^2 w_g \left( \frac{1}{2}\rho g H(r_g)^2 -\frac{1}{2}\rho_w g b(r_g)^2\right)n_x L_i(r_g) \vert J \vert \\
F2_{2i} &\simeq \sum_{g=1}^2 w_g \left( \frac{1}{2}\rho g H(r_g)^2 -\frac{1}{2}\rho_w g b(r_g)^2\right)n_y L_i(r_g) \vert J \vert
\end{aligned}
$$

## Assembly

Once an element stiffness matrix or a load vector is computed, it is added to the global stiffness matrix or global load vector. That step requires the knowledge of the global degrees of freedom. Each component of the element stiffness matrix or load vector is initially indexed by local degrees of freedom, but each one of these is linked to a global degree of freedom. Once an element stiffness matrix is computed, each term is added to the corresponding term in the global stiffness matrix depending on the global degrees of freedom involved.

Let us illustrate this process with the figure below. There are 6 local degrees of freedom for a given triangle of the mesh (3 nodes and two degrees of freedom per node: one for $$x$$ and another for $$y$$). The local degree of freedom number $$5$$ corresponds to the global degree of freedom number $$809$$, and the local degree of freedom number $$1$$ is the global degree of freedom number $$12$$. Therefore, the component $$Ke_{1,5}$$ of the element stiffness matrix must be added to $$K_{12,809}$$ of the global stiffness matrix.

<img src="/ISSM-Documentation/assets/img/wiki/femssa/Assembly.png" alt="Assembly process" style="width:100%">

After the assembly process, one obtains a global stiffness matrix whose size is $$2nods \times 2nods$$, but to build the weak formulation, we made the assumption that $$\boldsymbol\phi$$ was kinematically admissible, i.e. zero on $$\Gamma_u$$. Therefore, all the nodal functions of the nodes located on $$\Gamma_u$$ that we used to build the global stiffness matrix are not kinematically admissible. We must reduce the global stiffness matrix $$K_{gg}$$ to the final stiffness matrix $$K_{ff}$$ by erasing all the rows and columns related to these nodal functions.

## Resolution

The velocity on each node can be calculated with $$U=K^{-1}F$$, but we assumed that the specified velocity $$U_s$$ of the nodes located on $$\Gamma_u$$ was $$0$$. To take into account the fact that the constraint can be different from $$0$$, the velocity field is calculated as follows:

$$
U_f = [K_{ff}]^{-1} \left(  F -K_{fs}U_s \right)
$$

where $$f$$ stands for "free" and $$s$$ for "single point constraint". We then add the single point constraints to the vector $$U_f$$ in order to have the velocity of all the nodes of the domain $$U_g$$.

## Summary

The computation of the velocity field is nonlinear since the viscosity depends directly on the solution. The following algorithm is used: an initial velocity field is assumed. Each element stiffness matrix and load vector is computed using Gauss quadratures. They are then plugged into the global stiffness matrix and global load vector. The global stiffness matrix and load vector are reduced depending on the constraints (the velocity of a constrained node is not computed, so the corresponding row and column in the stiffness matrix and load vector are deleted). Then the velocity field is computed and compared to the one of the previous iteration (for the first iteration, there is no convergence test, so a second iteration must be launched). If the convergence criterion is not fulfilled (i.e. the results are too different from one another), a new iteration is computed, using the velocity field of the previous iteration to compute the viscosity.

<img src="/ISSM-Documentation/assets/img/wiki/femssa/Algorithm.png" alt="Schematic algorithm used by ISSM" style="width:100%">
