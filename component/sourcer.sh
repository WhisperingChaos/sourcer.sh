#!/bin/bash
###############################################################################
#
#	Purpose:
#		Thunk layer to construct an aggregrate "component" through hierarchical
#		see sourcer.source.sh for implementation.
#
###############################################################################

# compose source files from override directory to permit overrides for
# itself via different mechanism when boot stratping itself
source "$(dirname "${BASH_SOURCE[0]}")"/override/sourcer.source.sh 
#compose specified component
sourcer_compose "$1"
