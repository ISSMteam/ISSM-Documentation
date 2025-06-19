---
title: Setting a Mask
layout: default
parent: Capabilities
has_children: false
has_toc: false
---

## Setting a Mask
The solver will use two different boundary conditions depending on the nature of the ice sheet system. An ice shelf will slide on the water whereas there is friction between an ice sheet and the bedrock for the grounded ice. The model must contain this field that tells whether the element is on an ice shelf or on an ice sheet. If the whole domain is an ice shelf, the following command may be used,
````
>> md = setmask(md, 'all', '');
````
and for an ice sheet,
````
>> md = setmask(md, '', '');
````
If the geometry is more complex (marine ice sheet, ice shelf with ice rises), ARGUS files must be
used. The following command will set the geometry,
````
>> md = setmask(md, 'Iceshelves.exp', 'Islands.exp');
````
The first argument is the model and the two other arguments are the files containing the coordinates of the ice shelf included in the Domain Outline and the part of grounded ice included in the ice shelf part (islands or ice rises).

