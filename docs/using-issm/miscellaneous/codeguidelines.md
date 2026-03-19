---
title: Coding guidelines
layout: default
parent: Miscellaneous wiki
grand_parent: Using ISSM
---

## General guidelines

- comment your code (everybody must understand what is being done)
- NEVER more than one blank line please!
- Align operators vertically to emphasize local program structure and semantics when possible
- Do not use excessive blank spaces (especially in equations)

## C/C++

- if/for should follow this:
- no space fetween if/for and its statement
- If an if/for holds on one line, then do not use brackets
- Otherwise, use brackets

```c
for(int i=0<i<n;i++)  A[i]=i;

for(int i=0<i<n;i++){
   A[i]=B[i];
   B[i]=0;
}

if(a==0) bool=true;

if(a==0)
   bool=true;
else if(a==1)
   bool=flase;
else
   _error_("a=" << a << " not supported");

if(a==0){
    output=true;
    c=b
}
else{
    output=false
    c=a;
}
```

 - Comments should follow the code indentation and there should not be any blank line between a comment and the code it is referring to

```c
   /*Assigning values of A*/
   for(int i=0<i<n;i++){

      /*The comment here is indented*/
      A[i]=i;
   }
```

 - Function declaration should hold on one line only

```c
bool Test(int a,double b,char* c){
```

## MATLAB

All MATLAB routines should start with a help (Example and See Also are not mandatory):

```matlab
function outputs=FunctionName(inputs)
%FUNCTIONNAME - one line description
%
%   Extensive description of what is being done, inputs
%   outputs, etc...
%
%   Usage:
%      outputs=FunctionName(inputs)
%
%   Example:
%      md.test=FunctionName(1);
%
%   See Also:
%      FunctionName2, FunctionName3, ...
```

At the very least, the first line and the Usage should be provided. Use indentations of 3 and 6 spaces. Example:

```matlab
function outputs=hello()
%HELLO - prints hello to the screen
%
%   Usage:
%      outputs=hello()
```

## Vim Folding
Classes, functions, and other logical blocks of code should be folded (note the exact formatting used below):

```matlab
function foo() % &#123;&#123;&#123;
...
end % &#125;&#125;&#125;
```

## Python

[PeP8 compliance](https://www.python.org/dev/peps/pep-0008/ PeP8 compliance) should be used throughout the code with the exceptions below (with flake8 codes):
- We allow lines of any length (E501)
- We don't enforce the space after "#" for comments (E262, E265)
- We still allow form module import * (F403) but we should avoid those if possible
- We bypass warning on undefined function (F405) this can probably be removed if we take care of the one above
flake8 allows you to track and highlight the syntax errors (through Elpy in Emacs, I guess it can be introduced in vim).

If you install flake8, you can also run it in standalone to check the files in a directory:

```sh
flake8  --ignore=E262,E265,F403,F405,E405,E501
```

## Docstrings
Adhering to [https://www.python.org/dev/peps/pep-0257/ PEP8 Docstring Conventions] while attempting to mirror the conventions we follow under MATLAB, modules, functions, classes, and method definitions should be documented according to the following protocol:

```py
def FunctionName(inputs):
    """FunctionName - one line description

    Extensive description of what is being done, inputs
    outputs, etc...

    Usage:
        outputs = FunctionName(inputs)

    Example:
        md.test = FunctionName(1)

    See Also:
        FunctionName2, FunctionName3, ...
    """
```

As with MATLAB, at the very least, the first line and the 'Usage' should be provided. Unlike MATLAB, use indentations of 4 and 8 spaces.

## Vim Folding
Classes, functions, and other logical blocks of code should be folded (note the exact formatting used below):

```py
def foo(): # &#123;&#123;&#123;
...
# &#125;&#125;&#125;
```

## MATLAB Built-In Equivalents
The following is a list of MATLAB built-in equivalents in Python:

| MATLAB | Python | Notes |
|:-------|:-------|:------|
| `s=num2str(A)` | `s=str(A)` | convert numbers to character array |

## NumPy/SciPy 
NumPy and SciPy are used extensively in the Python interface to ISSM to replicate MATLAB-native functionality. When translating modules or tests, for example, from MATLAB to Python, the following sources may come in handy:
- [NumPy for Matlab users](https://numpy.org/devdocs/user/numpy-for-matlab-users.html)
- [MATLAB to NumPy](http://mathesaurus.sourceforge.net/matlab-numpy.html)
Some notable omissions in the above sources are as follows:

| MATLAB | Python | Notes |
|:-------|:-------|:------|
| `<<cell_array>>{:}`  | `<<np.ndarray>>.flatten()` | Flatten a MATLAB cell array or NumPy `ndarray` |
| `find(a>0.5)` | `np.where(a>0.5)[0]` | Find the indices where (`a>0.5`).<br> <br>When only the `condition` parameter is provided, this function is a shorthand for `np.asarray(condition).nonzero()`.<br><br>See also [here](https://numpy.org/doc/stable/reference/generated/numpy.where.html)<br> - `a` must be of type `np.array` (or one of its subclasses): a `list` will not automatically be cast.<br> - Returns a tuple of arrays of indices, one for each dimension of the input array. Thus, when the input array is 1D, the indices can be retrieved simply by addressing the first element of the result (as in the example). |
| `find('cond1'&'cond2')` | `np.where(np.logical_and.reduce(('cond1','cond2'))[0]` | Find the indices where `'cond1'` and `'cond2'` are met.<br><br>The same protocol can be followed for MATLAB's `|` by instead using `logical_or`.<br><br>More than two conditions may be compounded. |
| `v=nonzeros(A)` | `v=A[np.nonzero(A)]` | Find the values of the nonzero elements |
| `B=sortrows(A,column)` | `B=A[A[:,column].argsort()]` | sort rows of matrix or table (MATLAB), or 2D array (NumPy) in ascending order based on the elements in 'column' |
| `sqrt(A)` | `A ** 0.5` | Element-wise square root (math.sqrt can only be applied to scalars) |

## Variable/Enum/Function Names

- variables should not use capital letters. Use underscores to make variables more understandable.
- Function names and enums should not use any underscore. Use capital letters to make names more understandable.

Example:

```c
  Input* vx_input=GetInput(inputs,VxInput);
```
