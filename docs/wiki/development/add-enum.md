---
title: Adding a New Enum
layout: default
parent: Development
nav_order: 6
---

# Adding a New `Enum` to the Model
## Introduction
The motivation for `Enums` is that comparing integers in C++ is easier and faster than comparing strings (which do not have a fixed size). So each model input/parameter is assigned an `Enum`. In the code, you will see `IceVolumeAboveFloatationEnum` but the code interprets this 'word' as the integer 68: each `Enum` has a number associated to it by the compiler at compile time. See the [Enumerated type Wikipedia page](https://en.wikipedia.org/wiki/Enumerated_type){:target="_blank"} for more info.

## Add a New `Enum`
If you want to add a new `Enum`, the *only* file that needs to be changed is `src/c/shared/Enum/EnumDefinitions.h`. Open it with you favorite editor (e.g., `vim`) and add your new `Enum`. Make sure that:
- It does not already exist (the compiler will tell you anyway)
- It finishes with `Enum,`
- It is in the right section:
  - If your `Enum` is for an `Input`, make sure it is between `InputsSTARTEnum` and `InputsENDEnum`
  - If your `Enum` is for a parameter, make sure it is between `ParametersSTARTEnum` and `ParametersENDEnum`

Then you can run THE synchronization script that will update the MATLAB and Python `Enum`, `StringToEnum` and `EnumToString` automatically,
```sh
cd $ISSM_DIR/src/c/shared/Enum/
./Synchronize.sh
```

You will then need to recompile `src/c` only, and there is no need to reconfigure,
```sh
cd $ISSM_DIR/src/c
make install
```
