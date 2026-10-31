---
title: Regression Tests
layout: default
parent: Development
nav_order: 4
---

# Regression Tests
## Introduction
ISSM relies on regression tests to check that no bugs are introduced during code development. All of the tests are located in `$ISSM_DIR/test/test/NightlyRun` and are run on two platforms,
1. [GitHub Actions](https://github.com/ISSMteam/ISSM/actions){:target="_blank"} - quicker checks on Linux-based Runners
2. [Jenkins](https://ross.ics.uci.edu/jenkins){:target="_blank"} - slower, comprehensive checks on Linux, macOS, and Windows nodes

Regression test suites are run for various combinations of operating system, ISSM API, and ISSM capabilities. Each commit to the the ISSM code base repository on GitHub will trigger these test suites. See the [Jenkins wiki page][./jenkins] for more information.

If a new capability is being added to ISSM, it is *absolutely critical* that a new test is created.

These nightly runs are not meant to be realistic. They rely on very coarse meshes. We only want to check that the numerics have not changed, the results are obviously meaningless. Most tests should take less than 10 seconds to run (ideally 1 second).

## Running a Test
Tests are organized as follows:
- 1-999: 'Nightly' series:
  - 100s: Square ice shelf constrained (no ice front)
  - 200s: Square ice shelf with ice front
  - 300s: Square grounded ice constrained (no ice front)
  - 400s: Square grounded ice with ice front (some floating ice)
  - 500s: Pine Island Glacier (West Antarctica)
  - 600s: 79 North (Greenland)
  - 700s: flow band models
  - 800s: valley glaciers

- 1000-1999 'validation' series:
  - 1000s: ISMIP
  - 1200s: EISMINT
  - 1300s: Thermal validation
  - 1400s: Mesh
  - 1500s: Transient forcings
  - 1600s: Thermal validation

- 2000-2999: 'sea level' series
- 3000-3999: 'ADOLC' series

Go to `test/NightlyRun`. To run a test without checking whether it worked or not, just type: `test<N>` in MATLAB, where `<N>` is the test number. To check whether the results of that test are still consistent with the archive,
```matlab
>> runme('id',<N>)
```

For tests > 1000, you will need to specify that you want to use all the benchmarks,
```matlab
>> runme('id',<N>,'benchmark','all')
```

If you would like to test a specific feature, you can use the function `IdFromString`. For example, if you would like to run all the tests that use Dakota, run,
```matlab
>> runme('id',IdFromString('Dakota'))
```
You should see a list of results that say `SUCCESS`.

In very rare cases, you get an `ERROR` that requires you to update the tolerance for that. Check with the core ISSM development team before changing the tolerance though.

## Adding a New Test
### Files to Create/Change
You must create a new test file in `test/NightlyRun`. Make sure to be consistent with the series above.

Create a `test<N>.m` file with the simulation test. The very first line should be a comment with the test name (which should be unique),
```matlab
%Test Name: <TEST_NAME>
```

For example, for `test328.m`, we have,
```matlab
%Test Name: SquareSheetConstrainedSmbGradients2d 
```

At the end of the file make sure to include `field_names`, `field_tolerances` and `field_values`, which are the names (no space) of the fields you want to check for your test and their associated tolerances (which allows for reasonable variances among architecture, operating systems, and external packages).

Run the following command to create the archive (the archive gives the reference values for all the fields that are checked),
```matlab
>> runme('id',<N>,'procedure','update')
```

**NOTE**: The default benchmark used by the test driver is 'nightly', which includes only tests in the range 1-999. If you are manually running a test outside of this range, make sure to pass in the appropriate benchmark option.

The new/modified archive will be located in `$ISSM_DIR/test/Archives` in binary format (`.arch`) and is the same for the Python test if you create one as well. Now if you run,
```matlab
>> runme('id',<N>)
```
you should see 'SUCCESS' everywhere. If not, you have to adjust the tolerances slightly.

**NOTE:** Create/modify the corresponding `test<N>.py`. However, you do not need to create/update the archive again. There has been an increasing demand for and use of Python for over a decade. If this is not your scripting language of choice, or you are otherwise having difficulty translating the test from MATLAB to Python, please [reach out to the core ISSM developers on GitHub](https://github.com/ISSMteam/ISSM/issues){:target="_blank"} for assistance.

### Checking in the New Test
In the case of a brand new test,
```sh
git add ./test/NightlyRun/test<N>.m ./test/NightlyRun/test<N>.py ./test/Archives/Archive<N>.arch
```
then,
```sh
git commit –m "Added new regression test to check <CAPABILITIES>"
git push
```
with an appropriate message. Otherwise you can simply update the archive and commit the changes.
