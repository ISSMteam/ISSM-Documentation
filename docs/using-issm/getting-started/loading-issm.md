---
title: Loading ISSM
layout: default
parent: Getting Started
nav_order: 1
---

# Loading ISSM
By default, MATLAB and Python cannot locate ISSM and its external packages. We outline here how to load ISSM in your chosen interface.

## Environment
First, we need to make sure our interface can find ISSM and its external packages by running,

`bash, zsh`
```sh
export ISSM_DIR=<ISSM_PATH>
source ${ISSM_DIR}/etc/environment.sh
````

`csh`
````
setenv ISSM_DIR <ISSM_PATH>
source ${ISSM_DIR}/etc/environment.csh
````

where `<ISSM_PATH>` is the path to ISSM on disk (ex: `${HOME}/ISSM/src`). This works whether you downloaded one of our precompiled distributables or compiled ISSM from source.

## Scripting Interfaces

### MATLAB


{: .highlight-title }
> Note
>
> There does not currently exist a method for starting the MATLAB GUI using its launcher icon with ISSM loaded.

Start MATLAB in a terminal by running,
````
matlab
````
If the `matlab` executable is not on your environment's path, you will need to add its parent directory to the `PATH` environment variable, create an alias for `matlab`, or start MATLAB with the full path to the `matlab` executable.

After starting MATLAB, you must tell it where to find ISSM's binaries and libraries by running,
````
addpath <ISSM_PATH>/bin <ISSM_PATH>/lib
````
again, where `<ISSM_PATH>` is the path to ISSM on disk. Alternatively, you can use the <a href="https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html" target="_blank">'Set Path' dialog</a> to add these paths manually. If you installed ISSM by downloading one of our precompiled distributables, you will also need to run,
````
addpath <ISSM_PATH>/share
````
Yet another alternative is to feel the `addpath` command as a statement to the `matlab` startup command, for example with,
````
matlab -r 'addpath ${ISSM_DIR}/bin ${ISSM_DIR}/lib'
````

You can verify that ISSM is findable by running,
````
issmversion
````
which should print a message similar to,
````
Ice-sheet and Sea-level System Model (ISSM) Version 4.22
(website: http://issm.jpl.nasa.gov contact:issm@jpl.nasa.gov)

Build date: Wed Sep 18 14:00:06 PDT 2023
Copyright (c) 2009-2023 California Institute of Technology

    to get started type: issmdoc
````

To avoid having to manually load ISSM each time you start up MATLAB, you might create an alias in your shell configuration file like,
````
alias matlab-issm="matlab -r 'addpath ${ISSM_DIR}/bin ${ISSM_DIR}/lib'"
````
If you will not be using MATLAB's GUI, you might create aliases like,
````
alias matlab_no_gui="matlab -nosplash -nodesktop -nodisplay"
alias matlab-no_gui-issm="matlab -r 'addpath ${ISSM_DIR}/bin ${ISSM_DIR}/lib'"
````

<hr>

### Python
Before starting Python, activate the virtual environment that you set up during installation with, for example,
````
source ${HOME}/.venv/ISSM/bin/activate
````

After starting Python, you must tell it where to find ISSM's binaries and libraries by running,
````
import os
import sys
ISSM_DIR = os.getenv('ISSM_DIR')
sys.path.append(ISSM_DIR + '/bin')
sys.path.append(ISSM_DIR + '/lib')
````
If you installed ISSM by downloading one of our precompiled distributables, you will also need to run,
````
sys.path.append(os.getenv('ISSM_DIR') + '/share')
````

You can verify that ISSM is findable by running,
````
from issmversion import issmversion
````
which should print a message similar to,
````
Ice-sheet and Sea-level System Model (ISSM) Version 4.22
(website: http://issm.jpl.nasa.gov contact:issm@jpl.nasa.gov)

Build date: Wed Sep 18 14:00:06 PDT 2023
Copyright (c) 2009-2023 California Institute of Technology
````

To avoid having to manually load ISSM each time you start up Python, you might create a startup script, for example, `${HOME}/ISSM/bin/sitecustomize.py` with the following contents,
````
#!/usr/bin/env python3
import os
import sys
ISSM_DIR = os.getenv('ISSM_DIR')
sys.path.append(ISSM_DIR + '/bin')
sys.path.append(ISSM_DIR + '/lib')
````
Then, add the following to the bottom of your virtual environment activation script (again, for example, `${HOME}/.venv/ISSM/bin/activate`):
````
export PYTHONPATH="${HOME}/ISSM/bin:${PYTHONPATH}"
````
ISSM should now be findable by Python whether you are in an interactive or non-interactive session as long as you have first activated your virtual environment.

<hr>

### Development Build
If you configured and compiled ISSM for development, you will have to load ISSM a bit differently.

#### MATLAB
```sh
addpath <ISSM_PATH>/src/m/dev
devpath
```
again, where `<ISSM_PATH>` is the path to ISSM on disk.

#### Python
Before starting Python, run,
```sh
export PYTHONPATH="${ISSM_DIR}/src/m/dev"
export PYTHONSTARTUP="${PYTHONPATH}/devpath.py"
```

For IPython users, instead launch the interface with,
```sh
ipython -i ${ISSM_DIR}/src/m/dev/devpath.py
```

