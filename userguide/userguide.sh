#!/bin/bash
################################################################################
# Generates a PDF version of the ISSM documentation from LaTeX file.
#
# Usage:
#
#	userguide.sh
#
# NOTE:
# - Assumes BIBINPUTS environment variable is defined and points to parent 
#   directory of references.bib on disk
# - Assumes TARGET environment variable is defined and is the basename of the 
#   source file and the output file 
#   (e.g TARGET="userguide": userguide.tex -> userguide.pdf)
# - Should be run from same directory as input file
#
################################################################################

pdflatex -interaction=errorstopmode -file-line-error -draftmode ${TARGET}.tex
bibtex ${TARGET}
pdflatex -interaction=errorstopmode -file-line-error -draftmode ${TARGET}.tex
pdflatex -interaction=errorstopmode -file-line-error            ${TARGET}.tex
