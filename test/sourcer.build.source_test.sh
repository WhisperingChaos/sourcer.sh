#!/bin/bash
source ./base/assert.source.sh

test_sourcer_build_help()(
	assert_output_true test_sourcer_build_help_Get \
		--- assert_true 'source ./base/sourcer.build.source.sh --help'
)


test_sourcer_build_help_Get()(
	source ./base/sourcer.build.source.sh -h >/dev/null
	sourcer__build_help
)


test_sourcer_noexist()(
	assert_output_true test_sourcer_default_dir_noexist_output \
		---	assert_false 'source ./base/sourcer.build.source.sh'
	assert_output_true test_sourcer_noexist_output \
		---	assert_false 'source ./base/sourcer.build.source.sh ./file/sourcer_noexist'
	assert_return_code_set
)


test_sourcer_default_dir_noexist_output(){
	echo
	echo "Error: Unable to locate 'sourcer.sh' in directory: './sourcer'."
}


test_sourcer_noexist_output(){
	echo
	echo "Error: Unable to locate 'sourcer.sh' in directory: './file/sourcer_noexist'". 
}


test_sourcer_build_source_noexist()(
	assert_output_true test_sourcer_build_source_noexist_output \
		---	assert_false 'source ./base/sourcer.build.source.sh ./ ./file/build_source_noexist'
	assert_return_code_set
)


test_sourcer_build_source_noexist_output(){
	echo
	echo "Error: Unable to locate initial 'base' source directory: './file/build_source_noexist/base'."
}

test_sourcer_default_exist()(
	assert_true 'source ./base/sourcer.build.source.sh "" ./file/sourcer_exist'
	assert_return_code_set
)


test_sourcer_build_compose_pkgA_pkgB()(
	source ./base/sourcer.build.source.sh ./ ./file/compose_pkgA_pkgB
	assert_output_true echo "pkgA" --- pkgA_whoami
	assert_output_true echo "pkgB" --- pkgB_whoami
	assert_return_code_set
)


test_sourcer_build_compose_override_pkgA()(
	source ./base/sourcer.build.source.sh ./ ./file/build_compose_override_pkgA
	assert_output_true echo "pkgA overridden" --- pkgA_whoami
	assert_return_code_set
)


test_sourcer_build_compose_override_pkgA_compose_pkgB()(
	source ./base/sourcer.build.source.sh ./ ./file/build_compose_override_pkgA_compose_pkgB
	assert_output_true echo "pkgA overridden" --- pkgA_whoami
	assert_output_true echo "pkgB overridden" --- pkgB_whoami
	assert_true '[ $pkgB_ENVAR_VALUE = 5 ]' 
	assert_return_code_set
)


test_sourcer_build_compose_override_pkgA_compose_pkgB_1()(
	source ./base/sourcer.build.source.sh ./ ./file/build_compose_override_pkgA_compose_pkgB_1
	assert_output_true echo "pkgA overridden"   --- pkgA_whoami
	assert_output_true echo "pkgB_1 overridden" --- pkgB_whoami
	printenv | grep VALUE
	assert_true '[ $pkgB_ENVAR_VALUE = 5 ]' 
	assert_return_code_set
)

main(){
	assert_return_code_child_failure_relay  test_sourcer_build_help
	assert_return_code_child_failure_relay  test_sourcer_noexist
	assert_return_code_child_failure_relay  test_sourcer_default_exist
	assert_return_code_child_failure_relay  test_sourcer_build_source_noexist
	assert_return_code_child_failure_relay  test_sourcer_build_compose_pkgA_pkgB
	assert_return_code_child_failure_relay  test_sourcer_build_compose_override_pkgA
	assert_return_code_child_failure_relay  test_sourcer_build_compose_override_pkgA_compose_pkgB_1
	assert_return_code_set
}

main
