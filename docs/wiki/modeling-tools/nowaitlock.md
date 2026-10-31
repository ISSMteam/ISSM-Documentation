---
title: Submitting Jobs
layout: default
parent: Modeling Tools
nav_order: 5
---

# Submitting Jobs Without Waiting
It is sometimes convenient to submit jobs and let them run in the background (e.g., no SSH passthrough possible). The easiest way to do this is to run the same step twice, with a variable `loadonly` that indicates whether we want to submit the job (when it is 0) or load results once the job is completed (1).
It is also convenient to set `'runtimename'` to 0 so that the directory name is predictable since it will only be the model name, without the date and time (make sure to change the model name so that it is unique tough, submitting another job with the same name will overwrite the directory entirely),
```matlab
%Do we need to submit the job or download the results?
loadonly = 0;

if perform(org,'Stepname')
   loadmodel(org,'PreviousStepName');

   %Make sure jobs are submitted without MATLAB waiting for job completion 
   md.settings.waitonlock = 0;
   md.cluster.interactive = 0; %only needed if you are using the generic cluster
   md.miscellaneous.name = 'YourJobName'; 

  %Submit job or download results, make sure that there is no runtime name (that includes the date)
   md=solve(md,'Transient','runtimename',false,'loadonly',loadonly);

   %Save model if necessary
   if  loadonly
      savemodel(org,md);
   end
end
```

Now, to submit jobs, set `loadonly = 0` and launch your simulation. Once it is fully completed, you can set `loadonly = 1` and run the same script, all the results will be downloaded and the model will be saved with a unique name. Good luck!
