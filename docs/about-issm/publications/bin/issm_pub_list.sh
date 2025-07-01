#!/bin/bash
################################################################################
# Generates a series of strings formatted for inclusion on the ISSM 
# Documentation 'Publications' page 
# (https://issmteam.github.io/ISSM-Documentation/about-issm/publications) for all DOI's in 
# files in ../doi/.
#
# Intended to be run from parent of this directory (i.e. publications/).
#
# Example:
#
#	./bin/issm_pub_list.sh
#	./bin/issm_pub_list.sh 2023 2021
#
# Dependencies:
# - ./doi_to_issm_website_markup
#
# See also:
# - ../../../.github/workflows/publications.yml
################################################################################

## Functions
#
function generate_dois_for_year {
	if [[ $# -lt 1 ]]; then
		echo "Error: function generate_dois_for_year requires an argument YEAR that corresponds to a file in ./doi"
		exit 1
	fi

	YEAR=${1}

	echo # Print newline
	echo "## ${YEAR}"
	while read DOI; do
		echo "- $($(dirname "$0")/doi_to_issm_website_markup.sh ${DOI})"
	done < ./doi/${YEAR}
}

## Uncomment the following to print the number of articles
# TOTAL_DOIS=$(find ./doi -type f -exec wc -l {} \; | awk '{total += $1} END{print total}')
# echo "Total articles based on or referencing ISSM: ${TOTAL_DOIS}"

## Generate DOI's
#
if [[ $# -ne 0 ]]; then
	# Only generate DOI's for files in ./doi that match arguments
	for YEAR in "$@"
	do
		if [[ -f ./doi/${YEAR} ]]; then
			generate_dois_for_year ${YEAR}
		fi
	done
else
	# Iterate over all files in ./doi
	for YEAR in $(ls -1r ./doi); do
		generate_dois_for_year ${YEAR}
	done
fi
