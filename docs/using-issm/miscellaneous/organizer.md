---
title: ISSM organizer
layout: default
parent: Miscellaneous wiki
grand_parent: Using ISSM
---

## ISSM Organizer

ISSM organizer is a module that supports automatic saving and loading of multiple runs as (.md) files. It can save and load each step of constructing a model and organize multiple ISSM models in bulk. Utilizing this structure modularizes the steps used to create a model, meaning you can start from any step while ensuring your previous steps remain saved.

### Initiating an organizer

You can start by creating an instance of the `organizer` class. For example, the following code builds an organizer instance, where the model files will be stored in the './Models/' folder with `prefix` ‘AGU2015’ in the filename. The `prefix` can be used to conveniently organize different ISSM models. The `steps` input accepts a list of numerical id that tells the organizer which steps to run.

```
>> org = organizer('repository',['Models/'],...
                'prefix',['AGU2015'],...
                'steps',[1,2]);  
%build an empty organizer object with a given repository
```

To check the current state of `org`, the `disp()` function can be used. For example, calling `disp(org)` immediately after creating the above organizer will results in the following output

```
>> disp(org)                                        
   Repository: 'Models/'
   Prefix:     'AGU2015'
   Color:      '41;37'
   skipio:     0
   no step
```

### Organizing steps in constructing an ISSM model

After the organizer is created, it can associate step names (strings) to each id in the `steps` array.

To set up the model using an organizer, call the `perform` function with two arguments: the organizer and the step's name (a string). When called, `perform(org, step_name)` increments the current step ID by 1 and associates the provided step name (a string) with that ID. If no current step ID exists yet, it initializes the current step ID to 1 and associates the provided step name with ID 1.

The function returns true only if both of the following conditions are met:
- The step name has never been used in a previous call to perform.
- The organizer's steps array (provided when the organizer was created) contains the assigned step ID.

For example, the following code will map id 1 to string 'Mesh'. If the `steps` array used to create the organizer contains 1, then `perform(org, ‘Mesh’)` will return True, and the code inside the if block will be performed. If the `steps` does not contain 1, then the code will be skipped.

```
if perform(org,'Mesh'),
	md=triangle(model,['./Data/GlacierDomain.exp'],100); %create a model
	...
	savemodel(org,md); %save the model
else
	disp('Mesh step skipped')
end
```

Then, if-clause structures allow you to run the steps specified when creating the organizer. In the following code, because the `steps` array only contains 2, the first if-block will not be run, and the second if-block will be executed.

```
org = organizer('repository',['Models/'],'prefix',['AGU2015'],'steps',[2]);  
% build an empty organizer object with a given repository

% associating id 1 with 'Mesh'. 
% id 1 is not in 'steps', return False and skip the if block
if perform(org,'Mesh'),
	md=triangle(model,['./Data/GlacierDomain.exp'],100); %create a model
        ...
	savemodel(org,md); %save the model
else
	disp('Mesh step skipped')
end

% associating id 2 with 'Parameterization'. 
% id 2 is in the 'steps', return true and execute the if block
if perform(org,'Parameterization'), 
	md=loadmodel(org,'Mesh')
        ...
	savemodel(org,md); %save the model
else
	disp('Mesh step skipped')
end
```

You can check the id and step names that have been run with the organizer using the following command:

```
org.steps.id
org.steps.string
```

You can check the current step the organizer using:

```
org.currentstep
```

### Saving and loading models

The function `savemodel` takes in the organizer and model. It will save the model with the name prefix defined when creating the organizer, appended with the step name. For example, in the code above, the `savemodel(org,md);` will save the model in the filepath './Models/AGU2015_Mesh.mat'.

The function `loadmodel` takes in the organizer and the step name of the previously saved model. For example, in the code above, `md=loadmodel(org,’Mesh’)` will load the model saved in the filepath './Models/AGU2015_Mesh.mat'.

### Setting up different models with the organizer

The following code creates multiple model with naming conventioned determined when initiating the organizer. An outer loop to run the script can easily iterate through each controlling variable (e.g. topo_code, fric_type, inversion_on), and the output will be organized with the naming convention you designed.

```
for topo_code = 1:3
  for fric_type = 1:5
    for inversion_on = [False,True]
    
      org=organizer('repository',['./Models'],...
      'prefix',['Thwaites_topo' num2str(topo_code) '_fric' num2str(fric_type) '_inv' num2str(inversion_on) '_'],...
      'steps',steps); clear steps;
			
      if perform(org,'Mesh')
		...
      end

      if perform(org,'Parameterization')
        if topo_code == 1
			...
        end
      end

    end
  end
end
```



