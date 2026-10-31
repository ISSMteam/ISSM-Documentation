---
title: Adding a New Field
layout: default
parent: Development
nav_order: 5
---

# Adding a New Field to the Model
Let's use an example to illustrate how to add a field in the model. I want to add a field `melting_rate` to the class `calving` (`md.calving.melting_rate`), which will be defined by the user. 

## Modifying the User Interface
Go to `src/m/classes` and modify `calving.m` and its Python equivalent:
1. Declare the new field in `properties`,
```matlab
melting_rate = NaN;
```
in ISSM, we use `NaN` for vectors and `0` for scalars. The default value is added with some explanation in the `setdefaultparameters` function of the class.

2. Add a default value in  `setdefaultparameters` (optional, for scalars only; literature reference is encouraged).
3. Add a consistency check,
```matlab
md = checkfield(md,'fieldname','calving.meltingrate','NaN',1,'size',[md.mesh.numberofvertices 1],'>=',0);
```
which means that we want no `NaN`, the vector should be of size `numberofvertices` with positive values only.

4. Add description in `disp`
5. Add field to `marshall`

## Add New `Enums`
Now, you have to [add a new `Enum`](./addnewenum) corresponding to your new field whose `Enum` name will be `ClassnameFieldnameEnum` where,
- `Classname` is the name of the class with an upper case first letter (in this example, `Calving` and `Calvinglevermann` for `Classname`)
- `Fieldname` is the name of your field you put in the previous files with an upper case first letter (I put `meltingrate` in `calving.m`, so `Fieldname` is `Meltingrate`).

So I will add two `Enums`: `CalvingMeltingrateEnum` and `CalvinglevermannMeltingrateEnum`.

**NOTE**: Don't forget to synchronize the `Enums` after creating them.

## Implement the New Field in the Model
First, you have to fetch the data in the `UpdateElements` function,
```c
iomodel->FetchDataToInput(elements,CalvingMeltingrateEnum);
```

After, load the input in the computation function (i.e. wherever you need to use this input),
```c
Input* meltingrate_input = element->GetInput(CalvinglevermannMeltingrateEnum); _assert_(meltingrate_input); 
```

You can then use `meltingrate_input` like any other input.

## Add a Nightly Run Test
Now, you have to [add a new Nightly Run](./addnewnightlyrun) to check that your new field continues to work as new changes are committed.

**NOTE**: Don't forget to modify other tests that could be concerned by the addition of this new field. For example in my case, I have to add,
```c
md.calving.meltingrate=zeros(md.mesh.numberofvertices,1);
```
to some already existing tests.
