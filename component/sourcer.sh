#!/bin/bash
###############################################################################
#
#	Purpose:
#		Manually, statically compose sourcer so it can automatically,
#		dynamically compose other components.  Don't call this executable
#		component directly. Instead, insert at top of component being built
#		the command: 'source [<path>]sourcer.build.source.sh [<parameters>]'
#		along with appropriate <parameters>.  Use '--help' to determine
#		parameter values: 'source [<path>]sourcer.build.source.sh --help' 
#
###############################################################################

main(){
	# identify the actual directory location of this executable it's components
	# will always be in the 'base' subdirectory of this one.
	declare -r sourcer__EXECUTABLE_DIR="$(dirname "$(readlink -f "$0")")"
	source "$sourcer__EXECUTABLE_DIR/base/sourcer.source.sh"
	# manual overrides of implementation should be placed in 'override'
	if [ -e "$sourcer__EXECUTABLE_DIR/override/sourcer.source.sh" ]; then
		source "$sourcer__EXECUTABLE_DIR/override/sourcer.source.sh"
	fi

	sourcer_compose "$1"
}

main $@

