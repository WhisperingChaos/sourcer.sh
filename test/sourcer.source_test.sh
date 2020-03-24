#!/bin/bash
source ./base/sourcer.source.sh
source ./base/assert.source.sh

test_sourcer__visit_filepath_echo(){
	# remember order matters!
	assert_output_true test_sourcer__visit_filepath_echo_pkgA_pkgB_output \
		---  sourcer__visit_filepath_echo ./file/compose_pkgA_pkgB/base 
}


test_sourcer_compose_pkgA_pkgB_success(){

	assert_output_true	'sourcer_compose ./file/compose_pkgA_pkgB' \
		--- test_sourcer__visit_filepath_echo_pkgA_pkgB_output
}


test_sourcer__visit_filepath_echo_pkgA_pkgB_output(){
	echo "./file/compose_pkgA_pkgB/base/pkgA.source.sh"
	echo "./file/compose_pkgA_pkgB/base/pkgB.source.sh"
}


test_sourcer_compose_level_max(){
	assert_true 'sourcer_compose ./file/compose_level_max'
}


test_sourcer_compose_level_max_exceeded(){
	assert_output_true assert_false 'sourcer_compose ./file/compose_level_max_exceeded' \
		--- test_sourcer_compose_level_max_exceeded_output
}

test_sourcer_compose_level_max_exceeded_output(){

	cat <<TEST_SOURCER_COMPOSE_LEVEL_MAX_EXCEEDED_OUTPUT

Error: Ignoring components located in subdirectory: './file/compose_level_max_exceeded/base/subcomponent_2//base/subcomponent_3//base/subcomponent_4//base/subcomponent_5//base/subcomponent_6/' because
  +    directory composition level depth: 5 was exceeded.  If 
  +    level depth beyond this maximum is desired, use Open/Close principle
  +    to override 'sourcer__VISIT_LEVEL_MAX' to reflect maximum for this
  +    component.
TEST_SOURCER_COMPOSE_LEVEL_MAX_EXCEEDED_OUTPUT
}


test_sourcer_compose_component_max_exceeded()(
	declare -gi sourcer__COMPONENTS_PER_LEVEL_MAX=3

	assert_output_true sourcer_compose ./file/component_max_exceeded \
		---  test_sourcer_compose_component_max_exceeded_output
	assert_return_code_set
)


test_sourcer_compose_component_max_exceeded_output(){

	cat <<TEST_SOURCER_COMPOSE_COMPONENT_MAX_EXCEEDED_OUTPUT

Error: Maximum component count: 3 exceeded for a given level
  +    while starting to process directory: './file/component_max_exceeded/base/component_4/'.  This and all
  +    component directories that sort after it were not processed.
  +    If you want to exceed this limit use SOLID Open/Close mechanism to
  +    change: 'sourcer__COMPONENTS_PER_LEVEL_MAX' for the desired resultant
  +    component.
TEST_SOURCER_COMPOSE_COMPONENT_MAX_EXCEEDED_OUTPUT
}


test_sourcer_compose_immediate_branch_error(){
	assert_output_true sourcer_compose ./file/compose_immediate_branch_error \
		---  test_sourcer_compose_immediate_branch_error_output
}


test_sourcer_compose_immediate_branch_error_output(){

	cat <<TEST_SOURCER_COMPOSE_IMMEDIATE_BRANCH_ERROR_OUTPUT

Error: Ignoring components located in subdirectory: 'base' of: './file/compose_immediate_branch_error/base/base/'.
  +    If you want compose a component within an existing component, create
  +    an intervening subdirectory whose name reflects a component name that
  +    is not: 'base' nor 'override'.
TEST_SOURCER_COMPOSE_IMMEDIATE_BRANCH_ERROR_OUTPUT
}


main(){
	test_sourcer__visit_filepath_echo
	test_sourcer_compose_pkgA_pkgB_success
	test_sourcer_compose_level_max
	test_sourcer_compose_level_max_exceeded
	assert_return_code_child_failure_relay test_sourcer_compose_component_max_exceeded
	test_sourcer_compose_immediate_branch_error
	assert_return_code_set
}

main
