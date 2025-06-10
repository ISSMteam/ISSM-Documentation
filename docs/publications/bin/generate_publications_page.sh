#!/bin/bash
################################################################################
# Generates the 'Publications' page for the ISSM Documentation 
# (https://issmteam.github.io/ISSM-Documentation/publications).
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
nav_order: 7
has_children: false
has_toc: true
NOTE: This file was generated automatically by .github/workflows/publications.yml. To make changes, edit the workflow file and commit the changes to the repository.
---
# Publications"
$(dirname "$0")/issm_pub_list.sh
