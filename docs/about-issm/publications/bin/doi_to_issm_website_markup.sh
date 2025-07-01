#!/bin/bash
################################################################################
# Takes as an argument the DOI for a given publication and returns a string 
# formatted for inclusion on the ISSM Documentation 'Publications' page 
# (https://issmteam.github.io/ISSM-Documentation/publications).
#
# Example:
#
#	doi_to_issm_website_markup 10.1029/2020GL091741
#	doi_to_issm_website_markup "10.1029/2020GL091741"
#
# Sources:
# - https://citation.crosscite.org/docs.html
# - https://github.com/citation-style-language/styles
################################################################################

URL="https://dx.doi.org/${1}"
STYLE="american-geophysical-union"

# Get citation
REF=$(curl -sLH "Accept: text/x-bibliography; style=${STYLE}" "${URL}")

if [[ $(echo ${REF} | grep "invalidDoi") ]]; then
	echo "The DOI entered, ${1}, is not a valid DOI: it should start with 10 followed by a dot, and contain a slash with no preceding whitespace."
	exit 1
fi

if [[ $(echo ${REF} | grep "Resource not found") ]]; then
	echo "A resource was not found for DOI ${1}."
	exit 1
fi

# Cleanup
REF=$(echo ${REF} | sed -E 's; ;;g') # Remove
REF=$(echo ${REF} | sed -E 's; ; ;g') # Replace with single space

# Add link
LINK="https://doi.org/${1}"
REF=$(echo ${REF} | sed -E "s;(http[s]*://[^\S]*);<a href=\"${LINK}\" target="_blank">${LINK}</a>;")

echo ${REF}
