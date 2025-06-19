---
title: Plotting in MATLAB
layout: default
parent: Plotting
nav_order: 1
has_children: false
has_toc: false
---

## Plotting in MATLAB
### plotmodel
`plotmodel` takes the model `md` as first argument and then an even number of options (as in the function `setelementstype`, or `solve`). To plot a given field, use the option `'data'` followed by the field one wants to plot. For the thickness:
````
>> plotmodel(md, 'data', md.geometry.thickness)
````
You can plot several fields at the same time but you have to add the argument `'data'` before each field you want to plot:
````
>> plotmodel(md, 'data', md.geometry.thickness, 'data', 'mesh', 'data', [1:md.mesh.numberofelements])
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/plot.png" alt="Figure 1: plot"></div>This can work for any field of length `md.mesh.numberofelements` or `md.mesh.numberofvertices`.
### Options
Options in `plotmodel` come as pairs: the option name must be followed by its value. For example, if one wants to remove the color bar, the option name is `'colorbar'` and the value `0`:
````
>> plotmodel(md, 'data', md.initialization.vel, 'colorbar', 0)
````
any options (except `'data'`) can be followed by `'#<i>'` where `<i>` is the subplot number, or `'#all'` if applied to all plots. For example:
````
>> plotmodel(md, 'data', md.initialization.vel, 'data', 'mesh', 'view#2', 3, 'colorbar#all', 'on', 'axis#1', 'off equal')
````

#### axis
Same as standard <a href="http://www.mathworks.com/help/techdoc/ref/axis.html" target="_blank">axis</a> MATLAB option:
````
>> plotmodel(md, 'data', md.vel, 'axis', 'tight')
````

#### view
Same as standard <a href="http://www.mathworks.com/help/techdoc/ref/view.html" target="_blank">view</a> MATLAB option:
````
>> plotmodel(md, 'data', md.vel, 'view', 2)
````

#### xlim, ylim, zlim
Same as standard <a href="http://www.mathworks.com/help/techdoc/ref/xlim.html" target="_blank">xlim</a> MATLAB option:
````
>> plotmodel(md, 'data', md.vel, 'xlim', [10^5 2*10^5])
````

#### caxis
Same as standard <a href="http://www.mathworks.com/access/helpdesk/help/techdoc/index.html?/access/helpdesk/help/techdoc/ref/caxis.html" target="_blank">caxis</a> MATLAB option (control the extreme values of the colorbar):
````
>> plotmodel(md, 'data', md.vel, 'caxis', [0 1000])
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/caxis.png" alt="Figure 2: caxis"></div>
#### colorbar
This option is used to control the colorbar display (`'on'` or `'off'`):
````
>> plotmodel(md, 'data', md.vel, 'colorbar', 'off')
````

#### colormap
Same as standard <a href="http://www.mathworks.com/access/helpdesk/help/techdoc/index.html?/access/helpdesk/help/techdoc/ref/colormap.html" target="_blank">colormap</a> MATLAB option (control the extreme values of the colorbar):
````
>> plotmodel(md, 'data', md.vel, 'colormap', 'hsv')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/colormap.png" alt="Figure 3: colormap"></div>
#### log
To get a logarithmic colorbar, use the `'log'` option followed by `10` for a decimal logarithm:
````
>> plotmodel(md, 'data', md.vel, 'log', 10)
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/log.png" alt="Figure 4: log"></div>
#### contourlevels
Contours of equi-value can be added to the plot by using the `'contourlevels'` option. The number of contours can be chosen by using the `'contourlevels'` options. The user can specify a number of levels or a cell containing the values of color changes. For example:
````
>> plotmodel(md, 'data', md.vel, 'contourlevels', 3)
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/contour3.png" alt="Figure 5: contour3"></div>````
>> plotmodel(md, 'data', md.vel, 'contourlevels', {100, 200, 500, 1000, 2000, 2500})
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/contourcell.png" alt="Figure 6: contourcell"></div>
#### contourticks
If the user does not want to display the contour levels ticks, use the `'contourticks'` set as `'off'`:
````
>> plotmodel(md, 'data', md.vel, 'contourlevels', {100, 200, 500, 1000, 2000, 2500}, 'contourticks', 'off')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/contourticks.png" alt="Figure 7: contourticks"></div>
#### contouronly
If the user wants to display the contours only, use the `'contouronly'` set as `'on'`:
````
>> plotmodel(md, 'data', 'vel', 'contourlevels', {100, 200, 500, 1000, 2000, 2500}, 'contouronly', 'on')
````

#### streamlines
Streamlines can be displayed by using the `'streamlines'` option followed by a number of streamlines or a cell containing the coordinates of seed points:
````
>> plotmodel(md, 'data', md.initialization.vel, 'streamlines', 50)
````
````
>> plotmodel(md, 'data', md.initialization.vel, 'streamlines', {10^6 * [-1.45 -0.27], 10^6 * [-1.6 0]})
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/streamlines50.png" alt="Figure 8: streamlines50"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/streamlinescell.png" alt="Figure 8: streamlinescell"></div>
NOTE: Streamlines use the velocities that are in `md.initialization`. Make sure you transfer the calculated velocities to `md.initialization` if you want to display the calculated streamlines.

#### edgecolor
The mesh can be superimposed onto the plot by using the `'edgecolor'` option followed by a color:
````
>> plotmodel(md, 'data', md.initialization.vel, 'edgecolor', 'w')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/edgecolor.png" alt="Figure 9: edgecolor"></div>
#### expdisp
Any ARGUS file can be displayed with the `'expdisp'` option followed by the name of the ARGUS file:
````
>> plotmodel(md, 'data', md.initialization.vel, 'expdisp', 'Iceshelves.exp')
````

#### expstyle
The style of the ARGUS profile can be controlled with the `'expstyle'` option, followed by the desired line style. Here is an example for a yellow dotted line:
````
>> plotmodel(md, 'data', md.initialization.vel, 'expdisp', 'Iceshelves.exp', 'expstyle', '--y')
````

#### mask
If one does not want to display the value of the field on a mask only, use the `'mask'` option followed by a vector that holds 0 for the vertices whose values are hidden:
````
>> plotmodel(md, 'data', md.initialization.vel, 'mask', md.mask.ocean_levelset < 0)
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/mask.png" alt="Figure 10: mask"></div>
#### northarrow
An arrow pointing North can be added with the `'northarrow'` option followed by `'on'`. The shape and position of the arrow can be controlled by using `[x0 y0 length [ratio [width]]]` 
instead of `'on'`:
````
>> plotmodel(md, 'data', md.initialization.vel, 'northarrow', 'on')
````

#### scaleruler
A scale ruler can be added. As for the North arrow, the default display is done by `'on'` but the shape and position of the scale ruler can be controlled by `[x0 y0 length width numberofticks]` where (x0,y0) are the coordinates of the lower left corner:
````
>> plotmodel(md, 'data', md.initialization.vel, 'scaleruler', 'on')
````

#### title
Same as standard <a href="http://www.mathworks.com/help/techdoc/ref/title.html" target="_blank">title</a> MATLAB option:
````
>> plotmodel(md, 'data', md.vel, 'title', 'Ice velocity [m/yr]')
````

#### fontsize
Same as standard <a href="http://www.mathworks.com/help/techdoc/ref/text_props.html" target="_blank">fontsize</a> MATLAB option:
````
>> plotmodel(md, 'data', md.vel, 'title', 'Ice velocity [m/yr]', 'fontsize', 8)
````

#### fontweight
Same as standard <a href="http://www.mathworks.com/help/techdoc/ref/text_props.html" target="_blank">fontweight</a> MATLAB option:
````
>> plotmodel(md, 'data', md.vel, 'title', 'Ice velocity [m/yr]', 'fontweight', 'b')
````

#### xlabel, ylabel
Same as standard <a href="http://www.mathworks.com/help/techdoc/ref/xlabel.html" target="_blank">xlabel</a> MATLAB option:
````
>> plotmodel(md, 'data', md.vel, 'xlabel', 'x axis [m]')
````
### Special plots
#### basaldrag
The special plot `'basal_drag'` displays the norm of the basal drag friction in kPa following formula:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\boldsymbol{\tau}_b = -k^2 N^r \|{\bf v}\|^{s-1} {\bf v}_b" alt="Equation 1"></div>
Basal drag relies on the velocity provided in `md.initialization`. The x and y components of the basal drag can be displayed with the `'basal_dragx'` or `'basal_dragy'` special plots:
````
>> plotmodel(md, 'data', 'basal_drag')
````
````
>> plotmodel(md, 'data', 'basal_dragx')
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/basaldrag.png" alt="Figure 11: basaldrag"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/basaldragcomp.png" alt="Figure 11: basaldragcomp"></div><span style="display:block;width:100%;text-align:center"><small>Basal friction norm and Basal friction x-component</small></span>
#### BC
The special plot `'BC'` displays all boundary conditions (Newmann and Dirichlet) for 2D and 3D meshes:
````
>> plotmodel(md, 'data', 'BC')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/BC.png" alt="Figure 12: BC"></div>#### driving\_stress
The special plot `'driving_stress'` displays the basal drag friction in kPa following formula:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\boldsymbol{\tau}_d = \rho g H\;\nabla s\label{plotspecial_driving_stress}" alt="Equation 2"></div>
````
>> plotmodel(md, 'data', 'driving_stress')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/driving_stress.png" alt="Figure 13: driving_stress"></div>#### elementnumbering
In the debugging process, it is often very useful to display all the elements next to their numbers. This is what the special plot `'elementnumbering'` does:
````
>> plotmodel(md, 'data', 'elementnumbering')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/elementnumbering.png" alt="Figure 14: elementnumbering"></div>A given list of elements can be highlighted with the `'highlight'` option:
````
>> plotmodel(md, 'data', 'elementnumbering', 'highlight', [3 4 5 6 7])
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/elementnumbering_highlight.png" alt="Figure 15: elementnumbering_highlight"></div>#### elements\_type
The special plot `'elements_type'` displays the elements with a specific color for each formulation:
````
>> plotmodel(md, 'data', 'elements_type')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/elements_type.png" alt="Figure 16: elements_type"></div>#### vertexnumbering
In the debugging process, it is often very useful to display all the vertices next to their numbers. This is what the special plot `'vertexnumbering'` does:
````
>> plotmodel(md, 'data', 'vertexnumbering')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/gridnumbering.png" alt="Figure 17: gridnumbering"></div>
A given list of vertices can be highlighted with the `'highlight'` option:
````
>> plotmodel(md, 'data', 'vertexnumbering', 'highlight', [2 5 7 12])
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/gridnumbering_highlight.png" alt="Figure 18: gridnumbering_highlight"></div>#### highlightelements
The special plot `'highlightelements'` is very similar to the plot `'elementnumbering'`. It is another possibility to highlight one or several grids, but without indicating the number of all the elements. It is a lot faster for large models:
````
>> plotmodel(md, 'data', 'highlightelements', 'highlight', 5)
````
````
>> plotmodel(md, 'data', 'highlightelements', 'highlight', [5 12])
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/highlightelements_highlight.png" alt="Figure 19: highlightelements_highlight"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/highlightelements_highlight3d.png" alt="Figure 19: highlightelements_highlight3d"></div>#### highlightgrids
The special plot `'highlightgrids'` is very similar to `'gridnumbering'`. It is another possibility to highlight grids without indicating all the grids numbers. It is a lot faster for big models:
````
>> plotmodel(md, 'data', 'highlightgrids', 'highlight', [12 20])
````
````
>> plotmodel(md, 'data', 'highlightgrids', 'highlight', [12 16 26])
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/highlightgrids_highlight.png" alt="Figure 20: highlightgrids_highlight"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/highlightgrids_highlight3d.png" alt="Figure 20: highlightgrids_highlight3d"></div>#### icefront
The special plot `'icefront'` displays the Neumann boundary conditions, i.e. all the segments on ice front and the normal to these segments, for a 2D or 3D mesh:
````
>> plotmodel(md, 'data', 'icefront')
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/icefront2d.png" alt="Figure 21: icefront2d"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/icefront3d.png" alt="Figure 21: icefront3d"></div>#### mesh
The special plot `'mesh'` displays the mesh of 2D or 3D model:
````
>> plotmodel(md, 'data', 'mesh')
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/mesh2d.png" alt="Figure 22: mesh2d"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/mesh3d.png" alt="Figure 22: mesh3d"></div>### Quiver plot
For 2D or 3D fields, a generic color plot cannot be used (except component by component). The `'data'` used by the function `plotmodel` must be a matrix of 2 or 3 columns. For example:
````
>> plotmodel(md, 'data', [md.vx md.vy])
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/plotquiver.png" alt="Figure 23: plotquiver"></div>
#### ColorLevels
The number of colors can be chosen by using the `'colorlevels'` options. The user can specify a number of levels or a cell containing the values of color changes. For example:
````
>> plotmodel(md, 'data', [md.vx md.vy], 'colorlevels', 3)
````
````
>> plotmodel(md, 'data', [md.vx md.vy], 'colorlevels', 100)
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/color3.png" alt="Figure 24: color3"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/color100.png" alt="Figure 24: color100"></div>````
>> plotmodel(md, 'data', [md.vx md.vy], 'colorlevels', {100, 200, 500, 1000, 2000, 2500})
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/colorcell.png" alt="Figure 25: colorcell"></div>
#### Scaling
The arrows length can be modified with the `'scaling'` options. The default value is 0.4. A higher scaling value will result in longer arrows:
````
>> plotmodel(md, 'data', [md.vx md.vy], 'scaling', 1)
````
````
>> plotmodel(md, 'data', [md.vx md.vy], 'scaling', 0.1)
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/scaling1.png" alt="Figure 26: scaling1"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/scaling01.png" alt="Figure 26: scaling01"></div>
#### Autoscale
If the user wants all the arrows to have the same length, use the option `'autoscale'` set as `'off'`:
````
>> plotmodel(md, 'data', [md.vx md.vy], 'autoscale', 'off')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/autoscale.png" alt="Figure 27: autoscale"></div>
#### Density
The number of arrows can be reduced with the option `'density'`. If the density is set as 3, only one arrow out of 3 will be displayed. This option is very useful when the mesh is very refined:
````
>> plotmodel(md, 'data', [md.vx md.vy], 'density', 3)
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/density3.png" alt="Figure 28: density3"></div>### Cross section
The section plot can be used to display the value of a field on a given track. The option `'sectionvalue'` must be followed by the name of an ARGUS file which contained the coordinates of the points describing the profile (this file can be generated by `exptool.m`). The resulting plot will be a curve in 2D and a colored surface in 3D. For example:
````
>> plotmodel(md, 'data', md.vel, 'expdisp', 'track.exp')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/track.png" alt="Figure 29: track"></div>````
>> plotmodel(md, 'data', md.vel, 'sectionvalue', 'track.exp')
````

<div style="display:flow-root"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/2d.png" alt="Figure 30: 2d"><img style="float:left;width:50.00%" src="/assets/img/getting-started/plotting/matlab/3d.png" alt="Figure 30: 3d"></div><span style="display:block;width:100%;text-align:center"><small>Section plot for 2D (left) and 3D (right) models</small></span>
#### Resolution
The horizontal and vertical (in 3D) resolution can be specified by the `'resolution'` option. It must be a list with the horizontal resolution followed by the vertical resolution (in meters). When not specified, the default resolution is displayed:
````
>> plotmodel(md, 'data', md.vel, 'sectionvalue', 'track.exp', 'resolution', [2*10^4 0])
````
````
>> plotmodel(md, 'data', md.vel, 'sectionvalue', 'track.exp', 'resolution', [10^3 0])
````

#### Show section
The profile used to create the section plot can be also plotted with the `'showsection'` option:
````
>> plotmodel(md, 'data', md.vel, 'showsection', 'on')
````

<div style="display:flow-root"><img style="float:left;width:100.00%" src="/assets/img/getting-started/plotting/matlab/show.png" alt="Figure 31: show"></div>
