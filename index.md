---
layout: default
title: Test
has_children: true
---

## Binaries
The easiest way to install ISSM is to download the
<a href="https://issm.jpl.nasa.gov/download/binaries/" target="_blank">pre-compiled binaries</a>. No need to compile the
code, just open the compressed file.


## Fonts
<small>Small text</small>

x<sup>2</sup>

H<sub>2</sub>O

Line with em dash&mdash;

Line break<br><br>

Some **bold** text

Some *italic* text


## Equations


<div align="center"><img src="https://latex.codecogs.com/gif.latex?	S(\theta,\phi,t) = \frac{R}{M} \left[ \mathcal{G}(\alpha) \otimes L(\theta',\phi',t) \right] +	\frac{1}{g} \sum_{m=0}^{2} \sum_{i=1}^{2} \Lambda_{2mi} (t) \mathcal{Y}_{2mi} (\theta,\phi) +	\mathcal{E}(t)"></div>

<div align="center"><img src="https://latex.codecogs.com/gif.latex?L(\theta,\phi,t) = \rho_I H(\theta,\phi,t) \mathcal{I}(\theta,\phi) + \rho_O S(\theta,\phi,t)	\mathcal{O}(\theta,\phi)"></div>

<div align="center"><img src="https://latex.codecogs.com/gif.latex?	S(\theta,\phi,t) = \frac{R}{M} \left[ \mathcal{G}(\alpha) \otimes L(\theta',\phi',t) \right] +	\frac{1}{g} \sum_{m=0}^{2} \sum_{i=1}^{2} \Lambda_{2mi} (t) \mathcal{Y}_{2mi} (\theta,\phi) +	\mathcal{E}(t)"></div>

<div align="center"><img src="https://latex.codecogs.com/gif.latex?S(\theta,\phi,t) = \frac{R}{M} \left[ \mathcal{G}(\alpha) \otimes L(\theta',\phi',t) \right] + \frac{1}{g} \sum_{m=0}^{2} \sum_{i=1}^{2} \Lambda_{2mi} (t) \mathcal{Y}_{2mi} (\theta,\phi) + \mathcal{E}(t)"></div>



## vspace

Some text followed by vspace
<div style="height:3cm"></div>
Some text following vspace


## Figures

Standard figure

<div style="display:flow-root">
<img style="float:left;width:100.00%" src="../../../images/issm/documentation/tutorials/uncertaintyquantification/SamplingResults.png" alt="SamplingResults">
</div>

Figure containing two figures

<div style="display:flow-root">
<img style="float:left;width:50.00%" src="../../../images/issm/documentation/tutorials/uncertaintyquantification/PlotSensitivities.png" alt="PlotSensitivities">
<img style="float:left;width:50.00%" src="../../../images/issm/documentation/tutorials/uncertaintyquantification/ImportanceFactors.png" alt="ImportanceFactors">
</div>

Figure with caption

<div style="display:flow-root">
<img style="float:left;width:100.00%" src="../../../images/issm/documentation/picop/picop.png" alt="picop">
</div>
<span style="display:block;width:100%;text-align:center"><small>Melt calculation in PICOP, adapted from [<a href="#references">*Pelle2019*</a>].</small></span>


## .bashrc

- Open `/c/msys64/home/<user>/.bashrc` for editing and add the following at the bottom of the file, 

````
## MATLAB
#
MATLAB_VER="<MATLAB_VER>" # Allows for easy resetting of MATLAB version added to path
export MATLAB_PATH=$(cygpath -u $(cygpath -ms "/c/Program Files/MATLAB/${MATLAB_VER}"))
export PATH="${MATLAB_PATH}/bin:${PATH}"

## ISSM
#
export ISSM_DIR=<ISSM_DIR>
export ISSM_DIR_WIN=$(cygpath -ms "${ISSM_DIR}") # Needed by MATLAB
````
where `<MATLAB_VER>` is the version of MATLAB that you have installed (for example, "R2023b")
and `<ISSM_DIR>` is the path to your local copy of the ISSM source code repository (for example, `/c/Users/<USER>/ISSM`, where <USER> is your username)
- Another item
	- Nested list item
	- Another nested list item

````
Another code block that follows a nested list
with different content but following text contains a new line
````
this is the following text preceded and followed by a new line

## Microsoft MPI

- Navigate to <a href="https://docs.microsoft.com/en-us/message-passing-interface/microsoft-mpi-release-notes" target="_top">https://docs.microsoft.com/en-us/message-passing-interface/microsoft-mpi-release-notes</a>
- Click the link for 'Microsoft Download Center' that corresponds with the latest release (take note of the version number that you download for the next step; it can also be found by going to 'Settings' / 'Apps & Features')
- Click the 'Download' button
	1. Redistributions of source code must retain the above copyright notice,
			this list of conditions and the following disclaimer.
	1. Redistributions in binary form must reproduce the above copyright
				notice, this list of conditions and the following disclaimer in the
				documentation and/or other materials provided with the distribution.
		- Ordered list item 1
		- Ordered list item 2
		- Ordered list item 3
	1. Neither the name of the California Institute of Technology (Caltech),
				its operating division the Jet Propulsion Laboratory (JPL), the National
				Aeronautics and Space Administration (NASA), nor the names of its
				contributors may be used to endorse or promote products derived from
				this software without specific prior written permission.
- Make sure both boxes are checked, then click the 'Next' button
- Click the 'Save File' button for each file
- When the download completes, run each installer
- Follow the prompts, using the default installation directories

## Source Code
If you would like to install ISSM from source, you will need to download the source code first. The
source code of ISSM is available on <a href="https://github.com/ISSMteam/ISSM" target="_blank">GitHub</a>. It can be
downloaded via https with,

````
git clone https://github.com/ISSMteam/ISSM.git
````
or `ssh` with,

````
git clone git@github.com:ISSMteam/ISSM.git
````
This will download the latest version of ISSM from the repository into the current local directory (or to the location of your choosing by passing a path as an optional argument to the command). 

If you downloaded the source code, you need to compile and install ISSM. Compilation of the ISSM
source code is theoretically possible on any platform. It has been successfully carried out on
Linux, macOS, and Windows. Here are some instructions to compile and install ISSM from the source
code:
<!--DATASETS LIST START-->

- <a href="https://issm.jpl.nasa.gov/download/unix" target="_blank">Linux/Mac</a>
- <a href="https://issm.jpl.nasa.gov/download/windows" target="_blank">Windows</a> (under development)
- <a href="https://issm.jpl.nasa.gov/download/autodiff" target="_blank">Installation with AD capability</a> (under development)
- <a href="https://issm.jpl.nasa.gov/download/se" target="_blank">Installation with Solid Earth capability</a> (under development)
<!--DATASETS LIST END-->
Compilation is a more involved process, which is not recommended for beginners or casual users.


## License
ISSM is released under a <a href="https://opensource.org/license/bsd-3-clause" target="_blank">BSD Three Clause License</a>.

Copyright (c) 2008-2024, California Institute of Technology.<br>
All rights reserved. Based on Government Sponsored Research under contracts NAS7-1407 and/or NAS7-03001.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:


1. Redistributions of source code must retain the above copyright notice,
		this list of conditions and the following disclaimer.
1. Redistributions in binary form must reproduce the above copyright
		notice, this list of conditions and the following disclaimer in the
		documentation and/or other materials provided with the distribution.
1. Neither the name of the California Institute of Technology (Caltech),
		its operating division the Jet Propulsion Laboratory (JPL), the National
		Aeronautics and Space Administration (NASA), nor the names of its
		contributors may be used to endorse or promote products derived from
		this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE CALIFORNIA INSTITUTE OF TECHNOLOGY BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## References
- 2019 T. Pelle, M. Morlighem, and J. H. Bondzio. Brief communication: PICOP, a new ocean melt parameterization under ice shelves combining PICO and a plume model. Cryosphere, 13(3):1043-1049, 2019.
