#!/bin/bash
################################################################################
# Translates a collection of LaTeX-formatted documents to a collection of 
# Markdown-formatted documents. It is intended to be used to generate 
# documentation ready for deployment on GitHub Pages using Just The Docs 
# (assumes support for HTML tags; includes Just The Docs front matter).
#
# Works recursively on current working directory or the directory supplied as 
# an optional argument.
#
# Requires:
# - latex2md.py
#
# Usage:
#
#	latex2jtd.sh [<DIRECTORY>]
#
# NOTE:
# - Assumes BIBINPUTS environment variable is defined and points to parent 
#   directory of references.bib on disk
#
################################################################################

# Environment
#
path_to_script=$(dirname -- "$(readlink -f -- "${0}";)";)
export PATH="${PATH}:${path_to_script}"

# Constants
#
USAGE_MSG="Usage: latex2jtd.sh [<DIRECTORY>]"

# Variables
#
directory=""
files=()

# Check environment
#
if [ -z "${BIBINPUTS+x}" ] || [ ! -d "${BIBINPUTS}" ] || [ ! -f "${BIBINPUTS}/references.bib" ]; then
	echo "Error: BIBINPUTS should be defined and point to parent directory of references.bib on disk"
	exit 1
fi

# Handle arguments
#
if [[ $# -eq 0 ]]; then
	directory='.'
else
	if [[ ! -d "${1}" ]]; then
		echo ${USAGE_MSG}
		exit 1
	fi

	directory="${1}"
fi

# Gather all files to be processed
#
while IFS= read -r line || [ -n "${line}" ]; do
	# Do not add files in '_site/' subdirectory (they have already been processed)
	if [[ ! "${line}" =~ (.*)/_site/(.*) ]]; then
		files+=($(printf "${line}"))
	fi
done < <(find "${directory}" -name *.tex)

# Process each file
#
for file in "${files[@]}"; do
	latex2md.py "${file}"
done
