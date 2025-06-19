---
title: Python Interface
layout: default
parent: Troubleshooting
nav_order: 5
has_children: false
has_toc: true
---

# Python Interface
## Indexing and Interfacing with the C/C++ Core
Many of the model fields represented in ISSM's C/C++ core use MATLAB-like, 1-based indexing. As such, when using the Python API, make sure to adjust field indices before requesting a solution, and then again before plotting and other processing of results.

