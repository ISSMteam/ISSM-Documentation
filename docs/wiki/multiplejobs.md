To perform parameter space studies, we need to submit multiple jobs with a parameter that changes value. Here is how you can do that for basal friction changing from 50 to 100 by increments of 1 (as an example).

We are going to use a variable in the MATLAB workspace called `friction` that will be changing within a loop. In your `runme.m` script, prepare your step with a dynamic step name:

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
   md.miscellaneous.name = org.steps(org.currentstep).string;

  %Submit job or download results, make sure that there is no runtime name (that includes the date)
   md=solve(md,'Transient','runtimename',false,'loadonly',loadonly);

   %Save model if necessary
   if  loadonly
      savemodel(org,md);
   end
end
```

Now, to submit jobs, set `loadonly = 0` and launch your jobs:

```m
for friction=50:100
   runme;
end
```

Once all the jobs are fully completed, you can set `loadonly = 1` and run the same loop, all the results will be downloaded and the model will be saved with a unique name. Good luck!
