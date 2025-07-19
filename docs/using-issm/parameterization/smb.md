---
title: Surface Mass Balance (SMB)
layout: default
parent: Parameterization
---

## Surface Mass Balance (SMB)

### SMB (default)
The default surface mass balance model applies the surface mass balance that's provided by the model without any modifications. This model can be selected by running:
````
>> md.smb = SMB();
````

One can display the following fields by running:
````
>> md.smb
````

- `md.smb.mass_balance`: surface mass balance (in m/yr ice equivalent)

### SMB components
The `SMBcomponents` model computes surface mass balance using the component parameters provided. The components expected are: accumulation, runoff, and evaporation. All components are typically expected to be given as positive values. In the model computation of surface mass balance, runoff and evaporation are considered as mass lost and accumulation is considered as mass gain.

The components model can be selected by running:
````
>> md.smb = SMBcomponents();
````

One can display the following fields by running:
````
>> md.smb
````
surface forcings parameters (SMB = accumulation - runoff - evaporation):

- `md.smb.accumulation`: accumulated snow [m/yr ice eq]
- `md.smb.runoff`      : amount of ice melt lost from the ice column [m/yr ice eq]
- `md.smb.evaporation` : amount of ice lost to evaporative processes [m/yr ice eq]

### SMB melt components
Like the SMBcomponents model, the SMBmeltcomponents model computes surface mass balance using the component parameters provided by the user. The components expected are: accumulation, evaporation, melt, and refreeze. All components are typically expected to be given as positive values.  In the model computation of surface mass balance, melt and evaporation are considered as mass lost while accumulation and refreeze are considered as mass gain.

The melt components model can be selected by running:
````
>> md.smb = SMBmeltcomponents();
````
````
>> md.smb
````
surface forcings parameters with melt (SMB = accumulation - evaporation - melt + refreeze)

- `md.smb.accumulation`: accumulated snow [m/yr ice eq]
- `md.smb.evaporation` : amount of ice lost to evaporative processes [m/yr ice eq]
- `md.smb.melt`        : amount of ice melt in ice column [m/yr ice eq]
- `md.smb.refreeze`    : amount of ice melt refrozen in ice column [m/yr ice eq]

### SMB gradients method
This surface mass balance model is based on the mass balance gradients method described in [<a href="#references">*Helsen2012*</a>]. To activate this method, the user must provide a climatology and a reference ice surface profile. The method will evolve the surface mass balance forcing through time, according to deviations of ice surface height. Required parameters include, at each vertex: (1) a reference surface mass balance field; (2) a reference ice elevation at each vertex; (3) a predetermined slope of the linear regression between positive surface mass balance and ice surface height; and (4) a predetermined slope of the linear regression between negative surface mass balance and ice surface height. Surface mass balance values are expected in units of millimeters of water equivalent per year and elevations are expected in meters.

The gradients model can be selected by running:
````
>> md.smb = SMBgradients();
````
````
>> md.smb
````

- `md.smb.href`  : reference elevation from which deviation is used to calculate SMB adjustment in smb (gradients method [m])
- `md.smb.smbref`: reference smb from which deviation is calculated in smb (gradients method [mm/yr water equiv])
- `md.smb.b_pos` : slope of hs - smb regression line for accumulation regime (required if smb gradients is activated)
- `md.smb.b_neg` : slope of hs - smb regression line for ablation regime (required if smb gradients is activated)


## References
