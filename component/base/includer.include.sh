#!/bin/bash
###############################################################################
#
#	Purpose:
#		Construct an aggregrate "component" through hierarchical composition of other
#		components. A component represents a unit of reuse that can be reflected as
#		either an "includible" module or bash command.  An "includible" file
#		bounds a set of cohesive funtions packaged for reuse.
#
#		Creating an aggregrate component relies on first importing "base" component(s)
#		and when necessary, locally "overriding" the behavior of certain functions 
#		to produce the desired behavior of the resultant component.  The overriding
#		behavior is injected by encoding a function of the same name, that accepts
#		the same interface, in one or more includible files that are read in after
#		processing the base includible(s).
#		
#		Base includibles exist in a subdirectory named "base" associated to the
#		parent directory that encapsulates the aggregrate component.  Overriding
#		includibles exist in a subdirectory named "override".  When either a base
#		or overriding includible is itself an aggregrate component, this
#		aggregrate component should itself be comprised of base and potentially
#		overriding components.
#
#		The algorithm below, for a given component, will perform a depth first
#		search to identify the deepest base includible and its associated
#		overriding one before visiting includibles nearer to the component's
#		immediate base and overriding ones.
#
#		In situations involving elemental includibles, they can be deposited
#		directly into a component's base or override directories.
#
###############################################################################
includes_compose(){
	local -r parentPath="$1"
	# always deep dive base includibles before processing overrides
	incudes__visit "$parentPath" 'base'
	incudes__visit "$parentPath" 'override'
}
incudes__visit(){
	local -r parentPath="$1"
	local -r branch="$2"
	local subDir
	# handle composite component
	for subDir in $(ls -d "$parentPath/$branch/"*/ 2>/dev/null); do
		# should never be */$branch/$branch/* - must have interviening component name: */$branch/<componentname>/$branch/*
		if [ "$(basename "$subDir")" = "$branch" ]; then continue; fi
		# deeply dive into any immediate composite components 
		includes_compose "$subDir"
	done
	# one or more elemental components (include files) may exist in the $branch directory
	incudes__filepath_echo "$parentPath/$branch"
}
incudes__filepath_echo(){
	local -r includePath="$1"
	local incDir
	for incDir in $(ls "$includePath/"*.include.sh 2>/dev/null); do
		echo "$incDir"
	done
}
