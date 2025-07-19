---
title: Glacial Isostatic Adjustment (GIA) Solution
layout: default
parent: Capabilities
---

## Glacial Isostatic Adjustment (GIA) Solution

### Physical basis
The ISSM/GIA model assumes that the ice sheet rests on top of the solid Earth, which is considered to be a simple two-layered incompressible continuum with upper elastic lithosphere floating on the viscoelastic (Maxwell material) mantle half-space. Coordinate transformations allow simple axisymmetric solutions for the deformation of pre-stressed solid Earth (subject to a normal surface traction of ice/ocean) to retrieve semi-analytical solutions of vertical displacement at the lithosphere surface.

### Vertical surface displacement
Vertical displacement at the lithosphere surface (i.e., ice/ocean-bedrock interface), <img src="https://latex.codecogs.com/svg.latex?w(r,t)" alt="Equation 1">, is the most relevant field variable for GIA assessment. For brevity, hereinafter, this is referred to as the GIA solution. Semi-analytical GIA solution is given by [<a href="#references">*Ivins1999*</a>]:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
w(r,t) = \int_{0}^{\infty} { k \left[ \frac{4 \mu_1^{e} \alpha}{2k\mu_1^e + \rho_1 g} \,\hat{Q}_0(k,t) J_1(k\alpha) \right] J_0(kr) \, \text{d}k }," alt="Equation 2"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 3"> is the radial distance from the center of the cylindrical disc load
- <img src="https://latex.codecogs.com/svg.latex?t" alt="Equation 4"> is the evaluation time
- <img src="https://latex.codecogs.com/svg.latex?k" alt="Equation 6"> is the Hankel transform variable of <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 5"> (or wavenumber)
- <img src="https://latex.codecogs.com/svg.latex?\alpha" alt="Equation 7"> is the radius of the cylindrical disc load
- <img src="https://latex.codecogs.com/svg.latex?\mu_1^{e}" alt="Equation 8"> is the shear modulus of elasticity of lithosphere
- <img src="https://latex.codecogs.com/svg.latex?\rho_1" alt="Equation 9"> is the lithosphere density
- <img src="https://latex.codecogs.com/svg.latex?g" alt="Equation 10"> is the vertical component of the gravity vector
- <img src="https://latex.codecogs.com/svg.latex?J_v(kr)" alt="Equation 12"> is the <img src="https://latex.codecogs.com/svg.latex?v" alt="Equation 11">-th order Bessel function of the first kind
- <img src="https://latex.codecogs.com/svg.latex?\hat{Q}_0(k,t)" alt="Equation 13"> accounts for the integrated influence of ice loading history
  (cf. Figure 1) at the evaluation time <img src="https://latex.codecogs.com/svg.latex?t" alt="Equation 14">.
  (Note that <img src="https://latex.codecogs.com/svg.latex?\hat{f}_v(k)" alt="Equation 17"> is the <img src="https://latex.codecogs.com/svg.latex?v" alt="Equation 16">-th order Hankel transform of function <img src="https://latex.codecogs.com/svg.latex?f(r)" alt="Equation 15">.)


<div style="display:flow-root"><img style="float:left;width:100.00%" src="/ISSM-Documentation/assets/img/docs/using-issm/capabilities/gia/Figure2_IJ99.jpg" alt="Figure 1: Figure2_IJ99"></div><span style="display:block;width:100%;text-align:center"><small>Schematic of evolution of piecewise continuous load height, $h_0$, with $J$ linear segments (from [<a href="#references">*Ivins1999*</a>]). For $j$-th segment, we can compute $m_j$ and $b_j$ (cf. Eqs. 3--4) based on the ice load at time $t_{j-1}$ and $t_j$. At $t_j$, for example, ice load at the lithosphere surface is given by $\rho_0 g h_{0j}$, where $\rho_0$ is the ice density.</small></span>
Assuming <img src="https://latex.codecogs.com/svg.latex?t_{J-1} &#60; t \leq t_J" alt="Equation 19">, the term <img src="https://latex.codecogs.com/svg.latex?\hat{Q}_0(k,t)" alt="Equation 18"> can be written as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\hat{Q}_0(k,t) = \sum_{j = 1}^{J} \,{_j\hat{Q}_0(k,t)}." alt="Equation 20"></div>
for <img src="https://latex.codecogs.com/svg.latex?j \leq (J-1)" alt="Equation 21">:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
_j\hat{Q}_0(k,t) = \sum_{p = 1}^{2} {\left\{ \frac{m_j \xi_p}{\gamma_p^2} \left[ \left( \gamma_p t_{j} -1 \right) \text{e}^{\gamma_p \left( t_{j} - t\right)} - \left( \gamma_p t_{j-1} -1 \right) \text{e}^{\gamma_p \left( t_{j-1} - t\right)} \right] + \frac{b_j \xi_p}{\gamma_p} \left[ \text{e}^{\gamma_p \left( t_{j} - t\right)} - \text{e}^{\gamma_p \left( t_{j-1} - t\right)} \right] \right\}}," alt="Equation 22"></div>
and for <img src="https://latex.codecogs.com/svg.latex?j = J" alt="Equation 23"> (i.e. the last load segment):

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
_j\hat{Q}_0(k,t) = \sum_{p = 1}^{2} {\left\{ \frac{m_j \xi_p}{\gamma_p^2} \left[ \left( \gamma_p t -1 \right) - \left( \gamma_p t_{j-1} -1 \right) \text{e}^{\gamma_p \left( t_{j-1} - t\right)} \right] + \frac{b_j \xi_p}{\gamma_p} \left[ 1 - \text{e}^{\gamma_p \left( t_{j-1} - t\right)} \right] \right\}} \, +\left( c_2 + \frac{1}{4k\mu_1^e} \right) \left( m_j t + b_j \right)," alt="Equation 24"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?m_j" alt="Equation 26"> is the slope of the linear <img src="https://latex.codecogs.com/svg.latex?j" alt="Equation 25">-th load segment
- <img src="https://latex.codecogs.com/svg.latex?b_j" alt="Equation 29"> is the <img src="https://latex.codecogs.com/svg.latex?y" alt="Equation 28">-intercept of the linear <img src="https://latex.codecogs.com/svg.latex?j" alt="Equation 27">-th load segment
- <img src="https://latex.codecogs.com/svg.latex?\gamma_p" alt="Equation 30"> is the inverse decay time
- <img src="https://latex.codecogs.com/svg.latex?\xi_p" alt="Equation 31"> is the amplitude factor

For <img src="https://latex.codecogs.com/svg.latex?p = 1,2" alt="Equation 32">, the inverse decay times are given by:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\gamma_p = \frac{d_1 \pm \sqrt{d_1^2 - 4 d_0} }{2}," alt="Equation 33"></div>
and the amplitude factors by:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\xi_p = \frac{\left( -1 \right)^p}{\left(\gamma_2 - \gamma_1\right)} \, \left[ \left(- c_2 \gamma_p + c_1\right) \gamma_p  -c_0 \right]." alt="Equation 34"></div>
Parameters appearing in Eqs. (5) and (6) are defined as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
c_0 = \frac{h_1}{\mu_2^e \tau_{m}^2} c_0^{\prime}, ~ c_1 = \frac{h_1}{\mu_2^e \tau_{m}} c_1^{\prime}, ~ c_2 = \frac{h_1}{\mu_2^e} c_2^{\prime}, ~ d_0 = \frac{1}{\tau_{m}^2} d_0^{\prime} ~ \text{and} ~ d_1 = \frac{1}{\tau_{m}} d_1^{\prime}," alt="Equation 35"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?h_1" alt="Equation 36"> is the lithosphere thickness
- <img src="https://latex.codecogs.com/svg.latex?\tau_m = \eta/\mu_2^e" alt="Equation 37"> is the Maxwell relaxation time
- <img src="https://latex.codecogs.com/svg.latex?\eta" alt="Equation 38"> is the effective viscosity of mantle
- <img src="https://latex.codecogs.com/svg.latex?\mu_2^e" alt="Equation 39"> is the shear modulus of elasticity of mantle
- parameters with primes, e.g. <img src="https://latex.codecogs.com/svg.latex?c_0^{\prime}" alt="Equation 40">, are dimensionless (listed in Table 1)
with the following dimensionless parameters:

- <img src="https://latex.codecogs.com/svg.latex?d_2^{\prime} = b_0^{\prime} + b_1^{\prime} + b_2^{\prime} + b_3^{\prime} + b_4^{\prime} + b_5^{\prime} + b_6^{\prime} + b_7^{\prime}" alt="Equation 41">
- <img src="https://latex.codecogs.com/svg.latex?d_1^{\prime} = \left[ b_2^{\prime} + b_3^{\prime} + b_4^{\prime} + 2 \left( b_5^{\prime} + b_6^{\prime} + b_7^{\prime} \right) \right] / d_2^{\prime}" alt="Equation 42">
- <img src="https://latex.codecogs.com/svg.latex?d_0^{\prime} = \left( b_5^{\prime} + b_6^{\prime} + b_7^{\prime} \right) / d_2^{\prime}" alt="Equation 43">
- <img src="https://latex.codecogs.com/svg.latex?c_2^{\prime} = \left( a_0^{\prime} + a_1^{\prime} + a_2^{\prime} + a_3^{\prime} \right) / d_2^{\prime}" alt="Equation 44">
- <img src="https://latex.codecogs.com/svg.latex?c_1^{\prime} = \left[ a_1^{\prime} + 2 \left( a_2^{\prime} + a_3^{\prime} \right) \right] / d_2^{\prime}" alt="Equation 45">
- <img src="https://latex.codecogs.com/svg.latex?c_0^{\prime} = \left( a_2^{\prime} + a_3^{\prime} \right) / d_2^{\prime}" alt="Equation 46">
where:

- <img src="https://latex.codecogs.com/svg.latex?a_0^{\prime} = -2k^{\prime} \left\{ 1 + \text{e}^{2k^{\prime}} \left[ 1 + 2k^{\prime} \left( 1 + k^{\prime} \right)  \right] \right\}" alt="Equation 47">
- <img src="https://latex.codecogs.com/svg.latex?a_1^{\prime} = 4k^{\prime} \, R_{\mu}^e - R_{\rho}^- \left\{ 1 + \text{e}^{2k^{\prime}} \left[ 1 + 2k^{\prime} \left( 1 + k^{\prime} \right)  \right] \right\}" alt="Equation 48">
- <img src="https://latex.codecogs.com/svg.latex?a_2^{\prime} = -2k^{\prime} \left( R_{\mu}^e \right)^2 \left[ 1 - \text{e}^{2k^{\prime}} - 2k^{\prime} \, \text{e}^{2k^{\prime}} \left( 1 + k^{\prime} \right) \right]" alt="Equation 49">
- <img src="https://latex.codecogs.com/svg.latex?a_3^{\prime} = R_{\mu}^e R_{\rho}^- \left[ 1 - \text{e}^{2k^{\prime}} \left( 1 + 2k^{\prime} \right) \right]" alt="Equation 50">
- <img src="https://latex.codecogs.com/svg.latex?b_0^{\prime} = 4 (k^{\prime})^2 R_{\mu}^e \left[ 1 + \text{e}^{4k^{\prime}} + 2 \, \text{e}^{2k^{\prime}} \left( 1 + 2 (k^{\prime})^2 \right) \right]" alt="Equation 51">
- <img src="https://latex.codecogs.com/svg.latex?b_1^{\prime} = - 2k^{\prime} R_{\rho}^1 \left( 1 -  \text{e}^{4k^{\prime}} + 4k^{\prime} \, \text{e}^{2k^{\prime}} \right)" alt="Equation 52">
- <img src="https://latex.codecogs.com/svg.latex?b_2^{\prime} = -8 (k^{\prime})^2 \left( R_{\mu}^e \right)^2 \left( 1- \text{e}^{4k^{\prime}}\right)" alt="Equation 53">
- <img src="https://latex.codecogs.com/svg.latex?b_3^{\prime} = 2k^{\prime} R_{\mu}^e \left[ R_{\rho}^+ \left( 1 + \text{e}^{4k^{\prime}} \right) + 2 R_{\rho}^- \, \text{e}^{2k^{\prime}} \left( 1 + 2 (k^{\prime})^2 \right) \right]" alt="Equation 54">
- <img src="https://latex.codecogs.com/svg.latex?b_4^{\prime} = - R_{\rho}^1 R_{\rho}^- \left( 1 - \text{e}^{4k^{\prime}} + 4k^{\prime} \, \text{e}^{2k^{\prime}} \right)" alt="Equation 55">
- <img src="https://latex.codecogs.com/svg.latex?b_5^{\prime} = 4 (k^{\prime})^2 \left( R_{\mu}^e \right)^3 \left[ \left( 1 - \text{e}^{2k^{\prime}} \right)^2 - 4 (k^{\prime})^2 \text{e}^{2k^{\prime}} \right]" alt="Equation 56">
- <img src="https://latex.codecogs.com/svg.latex?b_6^{\prime} = -2k^{\prime} \left( R_{\mu}^e \right)^2 R_{\rho}^2 \left( 1 - \text{e}^{4k^{\prime}} - 4k^{\prime} \, \text{e}^{2k^{\prime}} \right)" alt="Equation 57">
- <img src="https://latex.codecogs.com/svg.latex?b_7^{\prime} = R_{\mu}^e R_{\rho}^1 R_{\rho}^- \left( 1 - \text{e}^{2k^{\prime}} \right)^2" alt="Equation 58">

The following set of non-dimensionlized parameters are defined, as needed to express dimensionless terms listed in Table 2:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
k^{\prime} = kh_1, R_{\mu}^{e} = \frac{\mu_1^e}{\mu_2^e}, R_{\rho}^1 = \frac{g h_1 \rho_1}{\mu_2^e}, R_{\rho}^2 = \frac{g h_1 \rho_2}{\mu_2^e}, R_{\rho}^+ = \frac{g h_1 \left( \rho_2 + \rho_1 \right)}{\mu_2^e}, R_{\rho}^- = \frac{g h_1 \left( \rho_2 - \rho_1 \right)}{\mu_2^e}," alt="Equation 59"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?\rho_2" alt="Equation 60"> is the mantle density

### Numerical implementation
In the Cartesian frame of ISSM, we treat the size of ice load as the property of mesh element and compute the GIA solution at each node of the element [<a href="#references">*Adhikari2014*</a>]. Individual 2-D (<img src="https://latex.codecogs.com/svg.latex?xy" alt="Equation 62">-plane) mesh elements are defined as the equivalence of footprint (i.e., projection onto the <img src="https://latex.codecogs.com/svg.latex?xy" alt="Equation 61">-plane) of cylindrical disc loads, ensuring that the corresponding element and disc both share the same origin and plan-form area. The height of ice load is then assigned to each element such that the average normal tractional force on the corresponding area of bedrock is conserved. At each node within the domain, the final GIA solutions are computed by integrating the solutions due to individual disc loads, defined as the property of mesh elements.

### Model parameters
The parameters relevant to the GIA solution can be displayed by running:
````
>> md.gia
````


- `md.gia.mantle_viscosity`: mantle viscosity (in Pa s)
- `md.gia.lithosphere_thickness`: lithosphere thickness (in km)
- `md.gia.cross_section_shape`: shape of the cylindrical disc load; 1: square-edged (default) 2: elliptical

The solution will also use the following model fields:

- `md.materials.lithosphere_shear_modulus`: shear modulus of lithosphere (in Pa)
- `md.materials.lithosphere_density`: lithosphere density (in g/cm<img src="https://latex.codecogs.com/svg.latex?^3" alt="Equation 63">)
- `md.materials.mantle_shear_modulus`: shear modulus of mantle (in Pa)
- `md.materials.mantle_density`: mantle density (in g/cm<img src="https://latex.codecogs.com/svg.latex?^3" alt="Equation 64">)
- `md.timestepping.start_time`: GIA evaluation time <img src="https://latex.codecogs.com/svg.latex?t" alt="Equation 65"> (in yr)
- `md.timestepping.final_time`: <img src="https://latex.codecogs.com/svg.latex?t_J(&#62;t)" alt="Equation 66"> in Figure 1 (in yr).
- `md.geometry.thickness`: ice loading history in the <img src="https://latex.codecogs.com/svg.latex?J \times 2" alt="Equation 69"> matrix form; the <img src="https://latex.codecogs.com/svg.latex?j" alt="Equation 68">-th row, for example, should be defined as <img src="https://latex.codecogs.com/svg.latex?[h_{0j},t_j]" alt="Equation 67"> (cf. Figure 1).

### ISSM Configuration
To activate the GIA model, add the following in the configuration script and compile ISSM:
````
--with-math77-dir="${ISSM_DIR}/externalpackages/math77/install"
````

### Running a simulation
To run a simulation, use the following command:
````
>> md = solve(md, 'Gia');
````
The first argument is the model, the second is the nature of the simulation one wants to run.


## References
