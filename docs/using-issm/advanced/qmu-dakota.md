---
title: Quantifications of Margins and Uncertainties (QMU) with Dakota
layout: default
parent: Advanced Features
---

## Quantifications of Margins and Uncertainties (QMU) with Dakota
### Physical basis
The methods for Quantification of Margins and Uncertainties (QMU) are based on the Design Analysis Kit for Optimization and Terascale Applications (Dakota) software [<a href="#references">*Eldred2008*</a>], which is embedded within ISSM [<a href="#references">*Larour2012b,Larour2012a*</a>].  Available Dakota analyses include sensitivity and sampling analyses, which we respectfully rely on to: 1) understand the sensitivity of model diagnostics to local variations in model fields and 2) identify how variations in model fields impact uncertainty in model diagnostics.  Diagnostics of interest include ice volume, maximum velocity, and mass flux across user-specified profiles.

#### Mesh Partitioning
QMU analyses are carried out on partitions of the model domain. Each partition consists of a collection of vertices.  The ISSM partitioner is versatile. For example, the partitioner can assign one vertex for each partition (linear partitioning); the same number of vertices per partition (unweighted partitioning); or it can weight partitions by a specified amount (equal-area by default - to remove area-specific dependencies).  Advanced partitioning is accomplished using the Chaco Software for Partitioning Graphs [<a href="#references">*Hendrickson1995*</a>], prior to setting up the model parameters for QMU analysis.

#### Sensitivity
Sensitivity, or local reliability, analysis computes the local derivative of diagnostics with respect to model inputs. It is used to assess the spatial distribution of this derivative, for the purpose of spatially ranking the influence of various inputs.

Given a response <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 2"> that is a function of multiple variables <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 1"> in a local reliability analysis [<a href="#references">*Coleman1999*</a>], we have:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
r=r(x_1,x_2,...,x_n)" alt="Equation 3"></div>
where the sensitivities are defined as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\theta_i=\frac{\delta r}{\delta x_i}" alt="Equation 4"></div>

If each of the variables is independent, the error propagation equation defines the variance of <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 5"> as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\sigma_r^2=\sum_{i=1}^n\theta_i^2 \sigma_i^2" alt="Equation 6"></div>
where <img src="https://latex.codecogs.com/svg.latex?\sigma_i" alt="Equation 10"> is the standard deviation of <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 9"> and <img src="https://latex.codecogs.com/svg.latex?\sigma_r" alt="Equation 8"> is the standard deviation of <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 7">.

**Importance factors** for each <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 13"> are determined by dividing the error propagation equation by <img src="https://latex.codecogs.com/svg.latex?\sigma" alt="Equation 12"><sub>r</sub><a href="#footnotes" target="_top"><sup>2</sup></a>. Note that the mean of the response is taken to be the response for the nominal value of each variable <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 11">.

Sensitivities are computed from the function evaluations using finite differences. The finite difference step size is user-defined by a parameter in the ISSM model. This analysis imposes the finite-difference step size as a small perturbation to <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 14">. The resulting sensitivities quantify
how the location of errors impact a specified model diagnostic (<img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 15">).

First, Dakota calls one ISSM model solve for an un-perturbed control simulation. Then, for every <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 21">, ISSM perturbs each partition one at a time, and calls an ISSM solve for each. At every partition, <img src="https://latex.codecogs.com/svg.latex?p" alt="Equation 20">, a resulting sensitivity, <img src="https://latex.codecogs.com/svg.latex?\theta_i(p)" alt="Equation 19"> is assigned. Each <img src="https://latex.codecogs.com/svg.latex?\theta_i" alt="Equation 18"> (defined above) is dependent on how much the outcome diverges from the control run. The result is a spatial mapping of sensitivities and importance factors of <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 17"> for every <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 16">. For Transient solves, sensitivities are determined only at the completion of a forward run.

**Method inputs**: <img src="https://latex.codecogs.com/svg.latex?\sigma_i" alt="Equation 23"> for each <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 22"> at every partition and the finite difference step

**Method outputs**: sensitivities (<img src="https://latex.codecogs.com/svg.latex?\theta_i" alt="Equation 25">) and importance factors for each <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 24"> at every partition

#### Sampling
Sampling analysis quantifies how input errors propagate through a model to impact a specified diagnostic, <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 26">. It a Monte-Carlo-style method that relies upon repeated execution (samples) of the same model, where input variables are perturbed by different amounts at each partition for each individual run. Resulting statistics (mean, standard deviations, cumulative distribution functions) are calculated after the specified number of samples are run.

For a particular sample, every <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 27"> is perturbed by a different amount at each partition. Input values are perturbed randomly, per partition, within a prescribed range (described by a statistical distribution, e.g. normal or uniform). Once the variables are perturbed, the ISSM model solve is called.

**Distributions**: A normal distribution for a particular partition is fully described by an average, <img src="https://latex.codecogs.com/svg.latex?\mu_i" alt="Equation 31">, and a standard deviation, <img src="https://latex.codecogs.com/svg.latex?\sigma_i" alt="Equation 30">. By definition, normal distributions cluster around <img src="https://latex.codecogs.com/svg.latex?\mu_i" alt="Equation 29"> and decrease towards the tails, in a Gaussian bell curve ranging from <img src="https://latex.codecogs.com/svg.latex?\mu_i\pm 3\sigma_i" alt="Equation 28">. A uniform distribution places greater emphasis on values closer to the tails, where probability of occurrence is equal for any given value within a specified minimum and maximum value.

If a user chooses so, any <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 33"> can be treated as a scaled value. In this case, the distribution definitions are given in percentages, relative to a <img src="https://latex.codecogs.com/svg.latex?\mu_i" alt="Equation 32"> value of 1.

For example, at the beginning of a particular sample for a scaled <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 39">, Dakota chooses a random percentage perturbation <img src="https://latex.codecogs.com/svg.latex?P_i(p)" alt="Equation 38"> at each partition <img src="https://latex.codecogs.com/svg.latex?p" alt="Equation 37">. The value of the random percentage will fall within the defined error distribution, and the new value of <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 36"> for duration of this sample run is perturbed by <img src="https://latex.codecogs.com/svg.latex?x_iP_i(p)" alt="Equation 35">. The generation algorithm for <img src="https://latex.codecogs.com/svg.latex?P_i(p)" alt="Equation 34"> is user-specified (e.g. Monte-Carlo or LHS [<a href="#references">*Swiler2004*</a>]).

In the case where the user wants to sample <img src="https://latex.codecogs.com/svg.latex?n" alt="Equation 43"> variables at the same time, a <img src="https://latex.codecogs.com/svg.latex?P_i(p)" alt="Equation 42"> is chosen separately for each <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 41"> before a particular sample run. Resulting statistics reflect the combined effects of the errors due to <img src="https://latex.codecogs.com/svg.latex?x_1,x_2,...,x_n" alt="Equation 40">.

For Transient simulations, <img src="https://latex.codecogs.com/svg.latex?P_i(p)" alt="Equation 44"> remains constant for the duration of a particular sample run. Note that statistics are determined only at the completion of each forward run.

**Method inputs**: The number of samples to be run and for every <img src="https://latex.codecogs.com/svg.latex?x_i" alt="Equation 45">, a definition of error distribution (error ranges may vary spatially by partition)

**Method outputs**: For <img src="https://latex.codecogs.com/svg.latex?r" alt="Equation 47">, mean, standard deviations, and cumulative distribution functions resulting from errors due to <img src="https://latex.codecogs.com/svg.latex?x_1,x_2,...,x_n" alt="Equation 46">

### Model parameters
The parameters relevant to uncertainty quantification can be displayed by typing:
````
>> md.qmu
````


- `md.qmu.isdakota`: 1 to activate qmu analysis, or else 0
- `md.qmu.variables`: arrays of each `variable` class
- `md.qmu.responses`: arrays of each `diagnostics` class
- `md.qmu.numberofresponses`: number of responses
- `md.qmu.params`: array of method-independent parameters
- `md.qmu.results`: holder class for information from dakota result files
- `md.qmu.partition`: user provided, the partition each vertex belongs to
- `md.qmu.numberofpartitions`: number of partitions
- `md.qmu.variabledescriptors`: list of user-defined descriptors for variables
- `md.qmu.responsedescriptors`: list of user-defined descriptors for diagnostics
- `md.qmu.method`: array of `dakota_method` class
- `md.qmu.mass_flux_profile_directory`: directory for mass flux profiles
- `md.qmu.mass_flux_profiles`: list of `mass_flux` profiles
- `md.qmu.mass_flux_segments`: used by `process_qmu_response_data` to store processed profiles
- `md.qmu.adjacency`: adjacency matrix from connectivity table, partitioner computes it by default
- `md.qmu.vertex_weight`: weight for each vertex, partitioner sets it from connectivity by default

### Building the Chaco and Dakota packages
In order to run Dakota with ISSM, you must compile and install the external package Dakota (`${ISSM_DIR}/externalpackages/dakota`). In addition, for complex partitioning (more than one vertex per partition), you must compile and install the external package Chaco (`${ISSM_DIR}/externalpackages/chaco`).

In addition, your configure script should include the following:
````
--with-chaco-dir=${ISSM_DIR}/externalpackages/chaco/install \
--with-dakota-dir=${ISSM_DIR}/externalpackages}/dakota/install \
````

More recent versions of Dakota also require the external package Boost (`${ISSM_DIR}/externalpackages/boost`). If installed, it should also be added to your configure script:
````
--with-boost-dir=${ISSM_DIR}/externalpackages/boost/install/ \
````

### Partitioning a Mesh
To partition your mesh using Chaco, use the following commands:
````
>> md.qmu.numberofpartitions = 1000; % Note: Chaco can crash if too large
>> md = partitioner(md, 'package', 'chaco', 'npart', md.qmu.numberofpartitions, 'weighting', 'on');
%weighting on for weighted partitioning (equal-area by default), off for equal vertex partitioning
>> md.qmu.partition = md.qmu.partition - 1; %With chaco, partition numbers must be adjusted by 1
````
or, for a 1-to-1 mapping of vertices to partitions:
````
>> md.qmu.numberofpartitions = md.mesh.number_of_vertices;
>> md = partitioner(md, 'package', 'linear');
````

### Setting up the QMU
#### For sensitivity
````
>> md.qmu.method = dakota_method('nond_l');
````
This sets the method to local reliability (sensitivity). Other sensitivity settings:
````
>> md.qmu.params.fd_gradient_step_size = '0.1'; %finite difference step size, 0.001 by default
````

#### For sampling
````
>> md.qmu.method = dakota_method('nond_samp');
>> md.qmu.method(end) = ...
dmeth_params_set(md.qmu.method(end), 'seed', 1234, 'samples', 500, 'sample_type', 'lhs');
````
where `'seed'` is used for reproducibility of results and `'samples'` is the number of samples requested.

Other sampling settings:
````
>> md.qmu.params.tabular_graphics_data = true; %Output all the information needed to create histograms of results
````

#### Other simple default settings for both sampling and sensitivity
````
>> md.qmu.params.evaluation_concurrency = 1;
>> md.qmu.params.analysis_driver = '';
>> md.qmu.params.analysis_components = '';
>> md.qmu.params.direct = true;
````

### Setting your QMU variables
````
>> md.qmu.variables.drag_coefficient = normal_uncertain('scaled_FrictionCoefficient', 1, 0.1);
````

This sets the standard deviation to a constant value at every partition. After it is initialized as above, the standard deviation can be set manually, so that it varies spatially by partition:
````
md.qmu.variables.drag_coefficient.stddev = uncertainty_on_partition;
````

See also:
````
>> help normal_uncertain
>> help uniform_uncertain
>> help AreaAverageOntoPartition
````

### Setting your diagnostics
Example: Here, diagnostics of interest are (1) maximum velocity and (2) mass flux through two different gates. Mass flux gates are defined by the ARGUS files `'../Exp/MassFlux1.exp'` and `'../Exp/MassFlux2.exp'`:
````
%responses
md.qmu.responses.MaxVel = response_function('MaxVel', [], [0.01 0.25 0.5 0.75 0.99]);
md.qmu.responses.MassFlux1 = response_function('indexed_MassFlux_1', [], [0.01 0.25 0.5 0.75 0.99]);
md.qmu.responses.MassFlux2 = response_function('indexed_MassFlux_2', [], [0.01 0.25 0.5 0.75 0.99]);

%mass flux profiles
md.qmu.mass_flux_profiles = {'../Exp/MassFlux1.exp', '../Exp/MassFlux2.exp'};
md.qmu.mass_flux_profile_directory = pwd;
````

For more options see:
````
>> help response_function
````

### Running a simulation
Note: You must set your stress balance tolerance to <img src="https://latex.codecogs.com/svg.latex?10^{-5}" alt="Equation 48"> or smaller in order to avoid the accumulation of numerical residuals between consecutive samples:
````
>> md.stressbalance.restol = 10^-5;
````

To initiate the analysis of choice, use the following commands:
````
>> md.qmu.isdakota = 1;
>> md = solve(md, 'Masstransport');
````
The first argument is the model, the second is the nature of the simulation one wants to run.


## References
