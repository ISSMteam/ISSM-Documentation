---
title: Stochastic Forcing with StISSM
layout: default
parent: Advanced Features
has_children: false
has_toc: false
---

## Stochastic Forcing with StISSM
### Introduction
The stochastic component of ISSM (StISSM) allows the user to include random time-dependent fluctuations in a range of ice sheet processes. When activated for a given variable or model parameter (or 'field'), stochastic perturbations are applied to this variable. The amplitude of stochastic variability and the frequency at which new perturbations are prescribed can be defined by the user and are independent of the simulation time steps. Stochastic perturbations are Gaussian noise terms. In other words, a stochastic variable is calculated as,

<div align="center"><img src="https://latex.codecogs.com/svg.latex? \label{eq1}
\begin{cases}y_{t} = \overline{y}_{t}+\epsilon_{y,t} \\\epsilon_{y,t} \sim N\left(0,\sigma^{2}_{y}\right)\end{cases}" alt="Equation 1"></div>
where <img src="https://latex.codecogs.com/svg.latex?y" alt="Equation 10"> is a generic variable, <img src="https://latex.codecogs.com/svg.latex?t" alt="Equation 9"> indicates the model time step, <img src="https://latex.codecogs.com/svg.latex?\overline{y}_{t}" alt="Equation 8"> is the deterministic component of <img src="https://latex.codecogs.com/svg.latex?y_{t}" alt="Equation 7">, and <img src="https://latex.codecogs.com/svg.latex?\epsilon_{y,t}" alt="Equation 6"> is the stochastic perturbation applied at <img src="https://latex.codecogs.com/svg.latex?t" alt="Equation 5"> to <img src="https://latex.codecogs.com/svg.latex?y" alt="Equation 4">. The distribution of <img src="https://latex.codecogs.com/svg.latex?\epsilon_{y}" alt="Equation 3"> at any time step is Normal with a variance <img src="https://latex.codecogs.com/svg.latex?\sigma^{2}_{y}" alt="Equation 2">.

The model domain can be separated into different subdomains, and different perturbations are applied separately in each subdomain. In other words, the amplitude of variability can be different in the different subdomains, and the perturbations in different subdomains throughout the simulation will be different random numbers. Covariance in the stochastic perturbations can be prescribed between subdomains, as the stochastic terms are sampled from a multivariate Gaussian distribution,

<div align="center"><img src="https://latex.codecogs.com/svg.latex? \label{eq2}
\boldsymbol{\epsilon}_{t} \sim N(\boldsymbol{0},\Sigma)" alt="Equation 11"></div>
where <img src="https://latex.codecogs.com/svg.latex?\Sigma" alt="Equation 15"> is the covariance matrix, and the bold font denotes vectors. If only the diagonal terms of <img src="https://latex.codecogs.com/svg.latex?\Sigma" alt="Equation 14"> are non-zero, all the individual entries of <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\epsilon}_{t}" alt="Equation 13"> are independent of each other. Covariance between the entries can be applied by adjusting the off-diagonal terms of <img src="https://latex.codecogs.com/svg.latex?\Sigma" alt="Equation 12">. Stochasticity can also be applied to several variables. In this case, covariance between the different stochastic variables, and their respective subdomains, can be prescribed. Regarding the temporal correlation (i.e., for a stochastic variable to exhibit autocorrelation in time), Autoregressive Moving Average (ARMA) models have been implemented for many variables. An ARMA process follows,

<div align="center"><img src="https://latex.codecogs.com/svg.latex? \label{eq3}
y_{t} = \mu_{t} + \sum_{i=1}^{p} \varphi_i \left(y_{t-i}-\mu_{t-i}\right) + \sum_{j=1}^{q} \theta_{j} \epsilon_{y,t-j} + \epsilon_{y,t}" alt="Equation 16"></div>
where <img src="https://latex.codecogs.com/svg.latex?\mu_{t}" alt="Equation 21"> is a deterministic function of time, <img src="https://latex.codecogs.com/svg.latex?\varphi" alt="Equation 20"> are the autoregressive (AR) coefficients, and <img src="https://latex.codecogs.com/svg.latex?\theta" alt="Equation 19"> are the moving-average coefficients (MA). The values of <img src="https://latex.codecogs.com/svg.latex?p" alt="Equation 18"> and <img src="https://latex.codecogs.com/svg.latex?q" alt="Equation 17"> are the orders of the AR and MA part of the ARMA model, respectively.

### White noise stochasticity
For variables without ARMA implementation, stochasticity is applied as Gaussian white noise (i.e., without temporal correlation, following Eq. (1)). The model parameters can be displayed by running `md.stochasticforcing`. This class includes the following fields,

- `isstochasticforcing`: determines whether the ISSM run allows for stochasticity (1) or not (0, default).
- `fields`: serves to specify which fields are modeled as stochastic variables. Note that all the available fields are automatically displayed when running `md.stochasticforcing`.
- `defaultdimension`: the number of subdomains with their separate stochastic perturbations. Note that different fields thus share the same division in subdomains. Only fields that are modeled as an ARMA process (see Section 2 below) can have their specific division in subdomains.
- `default_id`: the identification number corresponding to a given subdomain (e.g., 1, 2, 3, etc.) for each element of the mesh.
- `stochastictimestep`: this determines the frequency at which new stochastic perturbations are computed. For example, if it is set to 1 year, a stochastic perturbation is kept constant over a period of one year, after which a new stochastic perturbation is generated.
- `covariance`: this is the covariance matrix for the stochastic perturbations (in Eq. (2)). If only a single variable is modeled as stochastic, and with only a single subdomain, then the covariance is of size 1×1 (equivalent to in Eq. (1)). If there are several subdomains and/or several stochastic variables, then the covariance should be of size D×D, where D is the number of subdomains times the number of stochastic variables. The marginal variance of each variable in a given subdomain are the diagonal terms of the covariance matrix. The off-diagonal terms capture the covariance between different variables and different subdomains.

### ARMA processes
As mentioned above, several variables (or 'fields') have an ARMA model implemented. In general, the ARMA models have the same configuration of variables. First, we can focus on the parameters that are similar to the variables of `md.stochasticforcing`,

- `num_basins`: the number of subdomains for this particular variable (can be different than `md.stochasticforcing.defaultdimension`).
- `basin_id`: the identification number corresponding to a given subdomain (e.g., 1, 2, 3, etc.) for each element of the mesh.
- `arma_timestep`: the time resolution of the ARMA model. This thus corresponds to the temporal frequency at which Eq. (3) is recomputed. Note that epsilon in Eq. (3) is recomputed via Eq. (2) at the resolution given by `md.stochasticforcing.stochastictimestep`. Thus, Eq. (3) always uses the latest epsilon term computed. 
Note here that the covariance parameters determining the variability in an ARMA-modeled variable should be prescribed in `md.stochasticforcing.covariance`.
Second, we can focus on the parameters that are specific to ARMA-modeled variables. The deterministic background term of the ARMA process (<img src="https://latex.codecogs.com/svg.latex?\mu_{t}" alt="Equation 22"> in Eq.(3)) can be modeled as a piecewise function in time. The order of the background term function with respect to time is set by the user, for example: constant, linear, quadratic, etc. Similarly, the number of breakpoints in the background term function is set by the user, for example: no breakpoint, 1 breakpoint, 2 breakpoints, etc. The remaining parameters to be defined in the model are therefore,

- `num_breaks`: the number of breakpoints applied in the background term function.
- `datebreaks`: the dates at which the breakpoints occur.
- `ar_order`: the order of the autoregressive part of the ARMA model (i.e., in Eq. (3)).
- `ma_order`: the order of the moving-average part of the ARMA model (i.e., in Eq. (3)).
- `arlag_coefs`: the coefficients of the autoregressive part of the ARMA model (i.e., in Eq. (3)).
- `malag_coefs`: the coefficients of the moving-average part of the ARMA model (i.e., in Eq. (3)).
- `num_params`: the number of parameters in the polynomial for the background term function. `num_params` should be 1 for a constant term, 2 for a constant term and a linear trend, 3 for a constant term and a linear trend and a quadratic term, etc.
- `polynomialparams`: the parameters of the polynomial for the background term function. If several subdomains and one or more breakpoints are used, this parameter should be a three-dimensional array. The 1st dimension (along the rows) corresponds to the different subdomains. The 2nd dimension (along the columns) corresponds to the different periods separated by the breakpoints. The 3rd dimension corresponds to the polynomial terms and should be of the same size as specified in `num_params`.
Note that on top of these parameters, ARMA schemes for different variables also have different parameters that are specific to the given variable. Below are the specific parameters for some of these variables.

#### SMBarma
This class allows for lapse rate adjustments applied to the SMB values (i.e., elevation gradients). This is prescribed with the parameters,

- `elevationbins`: the different elevation ranges in which different lapse rate values apply. The `elevationbins` parameters are specific to the different basins of the SMBarma model.
- `lapserates`: the basin-specific lapse rate values applied in their corresponding elevation bin. Note that this parameter can have a third dimension of size 12 if monthly-varying lapse rate values are used (1 value per month should be provided in this case).

#### frontalforcingsrignotarma
This class uses the frontal melt parameterization of [<a href="#references">*Rignot2016*</a>] (similarly to class `frontalforcingsrignot`),

<div align="center"><img src="https://latex.codecogs.com/svg.latex? \label{eq4}
\dot{m} = \left(A h_{w} q_{sg}^{\alpha} + B\right)\emph{TF}^{\beta}" alt="Equation 23"></div>
where <img src="https://latex.codecogs.com/svg.latex?h_{w}" alt="Equation 26"> is the front height of the marine glacier, <img src="https://latex.codecogs.com/svg.latex?q_{sg}" alt="Equation 25"> is the subglacial discharge, and <img src="https://latex.codecogs.com/svg.latex?A,B,\alpha,\beta" alt="Equation 24"> are calibration parameters.

Here, the **TF** (thermal forcing) variable is simulated as an ARMA process. In addition,
sub-annual variability can be prescribed with the parameters `monthlyvals_`.
Specifically, each month can have its own effect on **TF** by being added to the annual **TF** value. Each one of the 12 monthly values can be prescribed as a piecewise-linear function in time. This is implemented with the parameters,

- `monthlyvals_numbreaks`: the number of breakpoints in the piecewise-linear functions (a single value for all basins and months).
- `monthlyvals_datebreaks`: the dates at which the breakpoints occur.
- `monthlyvals_intercepts`: the intercept terms in the piecewise-linear functions (one specific entry per month and per basin).
- `monthlyvals_trends`: the trend terms in the piecewise-linear functions (one specific entry per month and per basin).
As such, each month in the StISSM simulation has a given calculated monthly value (“monthlyval”). The value of monthlyval is entirely defined by the time step of the model run (as a function of the piecewise-linear function). It can be positive or negative. This is added to the ARMA-calculated **TF**. For example, if the ARMA-calculated **TF** is 5K and monthlyval is -2K, the **TF** at the timestep is 3K. In addition, for `frontalforcingsrignotarma`, the subglacial discharge variable (in Eq. (4)) can also optionally be modeled as an ARMA process. This is activated by setting,
````
md.frontalforcingsrignotarma.isdischargearma = 1
````
If it is activated, all the model parameters are the same as for a usual ARMA-modeled variable. Their name is differentiated from the parameters of **TF** because they start with `sd_` (for example: `sd_arma_timestep`).

The subglacial discharge also allows for a monthly refinement of the subglacial discharge values calculated with the ARMA model by using the parameter `sd_monthlyfrac`. As an example, the ARMA model can use a yearly step (`sd_arma_timestep = 1`) but the annual value is then adjusted for each month of the StISSM simulation as a function of `sd_monthlyfrac`. The parameter `sd_monthlyfrac` is the fraction of the annual subglacial discharge occurring in each month. It should have 12 entries per row, and one row per subdomain of the `frontalforcingsrignotarma` class. The 12 entries of each row must add up to 1. Suppose that the yearly ARMA-calculated subglacial discharge value is <img src="https://latex.codecogs.com/svg.latex?100" alt="Equation 29">m<img src="https://latex.codecogs.com/svg.latex?^{3}" alt="Equation 28"> d<img src="https://latex.codecogs.com/svg.latex?^{-1}" alt="Equation 27"> and the row entries of `sd_monthlyfrac` are `[0, 0, 0, 0, 0, 0.3, 0.5, 0.2, 0, 0, 0, 0]`. If the StISSM time step is in August, then the value of subglacial discharge is calculated as
<img src="https://latex.codecogs.com/svg.latex?0.2\times 100 = 20" alt="Equation 32"> m<img src="https://latex.codecogs.com/svg.latex?^{3}" alt="Equation 31"> d<img src="https://latex.codecogs.com/svg.latex?^{-1}" alt="Equation 30">

### Additional technical information
#### Model Sequence
Suppose that variables y and w are stochastic variables. At any timestep of ISSM, the following sequence is executed,

- Determine if timestep t is a stochastic timestep or not (depends on `md.stochasticforcing.stochastictimestep`)
- If timestep is a stochastic timestep: draw new stochastic perturbations,
  <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\epsilon}_{t} \sim N(\boldsymbol{0},\Sigma)" alt="Equation 33">
- If timestep is not a stochastic timestep: keep <img src="https://latex.codecogs.com/svg.latex?\boldsymbol{\epsilon}_{t}" alt="Equation 34"> unchanged.
- Perturb variables: <img src="https://latex.codecogs.com/svg.latex?y_{t} = \overline{y}_{t}+\epsilon_{y,t}" alt="Equation 35">
- All the other ISSM routines proceed as usual

#### Computing the stochastic terms
We use the Cholesky decomposition of the covariance matrix to compute the stochastic terms drawn from the multivariate Gaussian distribution with the specified covariance matrix. Let <img src="https://latex.codecogs.com/svg.latex?L" alt="Equation 37"> be the Cholesky decomposition of <img src="https://latex.codecogs.com/svg.latex?\Sigma" alt="Equation 36">,

<div align="center"><img src="https://latex.codecogs.com/svg.latex? \label{eq5}
\Sigma = LL^{T}" alt="Equation 38"></div>
We can first draw a random vector <img src="https://latex.codecogs.com/svg.latex?\kappa" alt="Equation 40"> from the multivariate Gaussian distribution with covariance matrix identity matrix (<img src="https://latex.codecogs.com/svg.latex?I" alt="Equation 39">),

<div align="center"><img src="https://latex.codecogs.com/svg.latex? \label{eq6}
\boldsymbol{\kappa} \sim N\left(\boldsymbol{0},I\right)" alt="Equation 41"></div>
Then, we can generate our correlated vector of stochastic perturbation through multiplication,

<div align="center"><img src="https://latex.codecogs.com/svg.latex? \label{eq6}
\boldsymbol{\epsilon} = L\boldsymbol{\kappa}" alt="Equation 42"></div>
Note that the random number generator implemented in ISSM to draw random numbers/vectors from univariate/multivariate Normal distributions is the linear congruential generator.

For more details about StISSM, please refer to [<a href="#references">*Verjans2022*</a>].


## References
