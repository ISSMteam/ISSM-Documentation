#!/bin/bash
################################################################################
# Generates the 'Publications' page for the ISSM Documentation 
# (https://issmteam.github.io/ISSM-Documentation/about-issm/publications).
#
# Intended to be run from parent of this directory (i.e. publications/).
#
# Example:
#
#	./bin/generate_publications_page
#
# Dependencies:
# - ./issm_pub_list
#
# See also:
# - ../../../.github/workflows/publications.yml
################################################################################

## Generate 'Publications' page markup
#
echo "---
title: Publications
layout: default
parent: About ISSM
nav_order: 4
has_children: false
has_toc: true
NOTE: This file was generated automatically by .github/workflows/publications.yml. To make changes, edit the workflow file and commit the changes to the repository.
---

# Publications

{: .note-title }
> Citing ISSM
>
> Larour, E., Seroussi, H., Morlighem, M., & Rignot, E. (2012). Continental scale, high order, high spatial resolution, ice sheet modeling using the Ice Sheet System Model (ISSM). Journal of Geophysical Research: Earth Surface, 117(F1). <a href=\"https://doi.org/10.1029/2011JF002140\" target=\"_blank\">https://doi.org/10.1029/2011JF002140</a>
----

The following is a list of articles that feature research conducted in whole or in part using ISSM, as well as articles that cite ISSM."
$(dirname "$0")/issm_pub_list.sh
