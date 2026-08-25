---
title: ISSM organizer
layout: default
parent: Miscellaneous wiki
grand_parent: Using ISSM
---

## ISSM Organizer

ISSM's `organizer` is a class that supports automatic saving and loading of
multiple runs, and facilitates workflow in modeling scripts. It can save and load each step of constructing a
model and organize multiple ISSM models in bulk. Utilizing this structure
modularizes the steps used to create a model, meaning you can start from any
step while ensuring your previous steps remain saved.

### Initiating an organizer

You can start by creating an instance of the `organizer` class. For example, the following code builds an organizer instance, where the model files will be stored in the './Models/' folder with `prefix` ‘Greenland_’ in the filename. The `prefix` can be used to conveniently organize different ISSM models. The `steps` input accepts a list of numerical ids that tells the organizer which steps to run.

```m
org = organizer('repository','Models/', 'prefix', ['Greenland_'], 'steps', [1,2]);  
```

### Organizing steps in constructing an ISSM model

After the organizer is created, it can associate step names (defined as
strings) to each id in the `steps` array.

To set up the model using an organizer, call the `perform` function with two arguments: the organizer and the step's name (a string). When called, `perform(org, step_name)` increments the current step ID by 1 and associates the provided step name (a string) with that ID. If no current step ID exists yet, it initializes the current step ID to 1 and associates the provided step name with ID 1.

The function returns true only if both of the following conditions are met:
- The step name has never been used in a previous call to perform.
- The organizer's steps array (provided when the organizer was created) contains the assigned step ID.

For example, the following code will map id 1 to string 'Mesh'. If the `steps` array used to create the organizer contains 1, then `perform(org, 'Mesh')` will return true, and the code inside the if block will be performed. If the `steps` does not contain 1, then the code will be skipped.

```m
if perform(org,'Mesh')
	md = triangle(model(), './Exp/GlacierDomain.exp',100); %create a model
	...
	savemodel(org,md); %save the model
end
```

Then, if-clause structures allow you to run the steps specified when creating
the organizer. In the following code, because the `steps` array only contains
2, the first if-block will not be run, and the second if-block will be executed.

```m
org = organizer('repository','Models/', 'prefix', ['Greenland_'], 'steps', [2]);

if perform(org,'Mesh')
    md = triangle(model(), './Exp/GlacierDomain.exp',100); %create a model
    ...
    savemodel(org,md); 
end

if perform(org,'Parameterization')
	md=loadmodel(org,'Mesh');
    ...
	savemodel(org,md);
end
```
You can check the ids and step names by running your script once and then
execute `org` in MATLAB, or setting `'steps'` to 0 and running your script. In both cases 
all the step numbers and names will be printed to the screen.

### Saving and loading models

The function `savemodel` takes in the organizer and model as inputs. It will
save the model with the name prefix defined when creating the organizer,
 appended with the step name. For example, in the code above, the
 `savemodel(org,md);` will save the model in the filepath `./Models/Greenland_Mesh.mat`.

The function `loadmodel` takes in the organizer and the step name of the
previously saved model. For example, in the code above,
`md=loadmodel(org,'Mesh')` will load the model saved in the filepath
`./Models/Greenland_Mesh.mat`.

### Use the organizer to submit multiple jobs for parameter space studies

To perform parameter space studies, we need to submit multiple jobs with a
parameter that changes value. Here is how you can do that for basal friction
changing from 50 to 100 by increments of 1 (as an example).

We are going to use a variable in the MATLAB workspace called friction that
will be changing within a loop. In your `runme.m` script, prepare your step with
a dynamic step name:

```m
%Do we need to submit the job or download the results?
loadonly = 0;

if perform(org,['FrictionTest_' num2str(friction) ])
   loadmodel(org,'PreviousStepName');

   %Change friction according to friction variable
   md.friction.coefficient = friction;

   %Make sure jobs are submitted without MATLAB waiting for the results, and job name is unique
   md.settings.waitonlock = 0;
   md.cluster.interactive = 0; %only needed if you are using the generic cluster
   md.miscellaneous.name = ['FrictionTest_' num2str(friction) ];

  %Submit job or download results, make sure that there is no runtime name (that includes the date)
   md=solve(md,'Transient','runtimename',false,'loadonly',loadonly);

   %Save model if necessary
   if  loadonly
      savemodel(org,md);
   end
end
```

Now, to submit jobs, set loadonly = 0 and launch your jobs:

```m
for friction=50:100
   runme;
end
```

Once all the jobs are fully completed, you can set `loadonly = 1` and run the
same loop, all the results will be downloaded and the model will be saved with
a unique name. Good luck!
