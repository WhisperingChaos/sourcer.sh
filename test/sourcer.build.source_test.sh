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


test_sourcer__build_funcvar_exception_report()(
	source ./base/sourcer.build.source.sh '' '' ./file/build_funvar_exception_report/override.source.sh

	assert_output_true  test_sourcer__build_funcvar_exception_report_exist_output \
		--- assert_false  test_sourcer__build_funcvar_exception_report_exist
	assert_output_true  test_sourcer__build_funcvar_exception_report_noexist_output \
		--- assert_false  test_sourcer__build_funcvar_exception_report_noexist
)


test_sourcer__build_funcvar_exception_report_exist(){
	test_sourcer__build_funcvar_exception_report_messages \
	| sourcer__build_funcvar_exception_report 'false'  '/base/mockpackage.source.sh'
}


test_sourcer__build_funcvar_exception_report_messages(){

	cat <<TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_REPORT_MESSAGES
e:e:f:mockfunction_error
e:e:v:mockvariable_error
w:e:f:mockfunction_warning
w:e:v:mockvariable_warning
x:e:u:mockunknown_warning
TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_REPORT_MESSAGES
}


test_sourcer__build_funcvar_exception_report_exist_output(){

	cat <<TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_REPORT_EXIST
Error: Source file: '/base/mockpackage.source.sh' contains function 
  +    named: 'mockfunction_error' that should not already exist.
Error: Source file: '/base/mockpackage.source.sh' contains variable 
  +    named: 'mockvariable_error' that should not already exist.
Warning: Source file: '/base/mockpackage.source.sh' contains function 
  +    named: 'mockfunction_warning' that should not already exist.
Warning: Source file: '/base/mockpackage.source.sh' contains variable 
  +    named: 'mockvariable_warning' that should not already exist.
Warning: Source file: '/base/mockpackage.source.sh' contains unknown 
  +    named: 'mockunknown_warning' that should not already exist.
TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_REPORT_EXIST
}

test_sourcer__build_funcvar_exception_report_noexist(){
	test_sourcer__build_funcvar_exception_report_messages_noexist \
	| sourcer__build_funcvar_exception_report 'true'  '/base/mockpackage.source.sh'
}


test_sourcer__build_funcvar_exception_report_messages_noexist(){

	cat <<TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_REPORT_MESSAGES
e:n:f:mockfunction_error
e:n:v:mockvariable_error
w:n:f:mockfunction_warning
w:n:v:mockvariable_warning
x:n:u:mockunknown_warning
TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_REPORT_MESSAGES
}


test_sourcer__build_funcvar_exception_report_noexist_output(){

	cat <<TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_REPORT_NOEXIST
Error: Source file: '/base/mockpackage.source.sh' contains function 
  +    named: 'mockfunction_error' that should already exist.
Error: Source file: '/base/mockpackage.source.sh' contains variable 
  +    named: 'mockvariable_error' that should already exist.
Warning: Source file: '/base/mockpackage.source.sh' contains function 
  +    named: 'mockfunction_warning' that should already exist.
Warning: Source file: '/base/mockpackage.source.sh' contains variable 
  +    named: 'mockvariable_warning' that should already exist.
Warning: Source file: '/base/mockpackage.source.sh' contains unknown 
  +    named: 'mockunknown_warning' that should already exist.
TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_REPORT_NOEXIST
}


test_sourcer__build_funcvar_exception_tag()(
	source ./base/sourcer.build.source.sh '' '' ./file/build_funvar_exception_report/override.source.sh

	assert_output_true test_sourcer__build_funcvar_exception_tag_default_out \
		---	test_sourcer__build_funcvar_exception_tag_default
	
	assert_output_true echo "e:e:f:mockFunction" \
		---	test_sourcer__build_funcvar_exception_tag_custom_error

)


test_sourcer__build_funcvar_exception_tag_default(){
	test_sourcer__build_funcvar_exception_tag_default_in \
	| assert_true sourcer__build_funcvar_exception_tag
}


test_sourcer__build_funcvar_exception_tag_default_in(){

	cat <<TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_DEFAULT
e:f:mockfunction_warning
n:v:mockvariable_warning
TEST_SOURCER__BUILD_FUNCVAR_EXCEPTION_DEFAULT
}


test_sourcer__build_funcvar_exception_tag_default_out(){

	cat <<TEST_SOURCER__BUILD_FUNVAR_EXCEPTION_TAG_DEFAULT_OUTPUT
w:e:f:mockfunction_warning
w:n:v:mockvariable_warning
TEST_SOURCER__BUILD_FUNVAR_EXCEPTION_TAG_DEFAULT_OUTPUT
}


test_sourcer__build_funcvar_exception_tag_custom_error()(
	sourcer__build_funcvar_exception_categorize(){
		local shouldExist="$1"
		local typeInd="$2"
		local name="$3"
		local sourceFlPth="$4"
		
		assert_false '$shouldExist'
		assert_true	'[[ "$typeInd" = "f" ]]'
		assert_true '[[ "$name" = "mockFunction" ]]'
		assert_true '[[ "$sourceFlPth" = "/base/mockpackage.source.sh" ]]'
		return 1
	}

	echo 'e:f:mockFunction' \
	| assert_true "sourcer__build_funcvar_exception_tag 'false' '/base/mockpackage.source.sh'"
)


main(){
	assert_return_code_child_failure_relay  test_sourcer_build_help
	assert_return_code_child_failure_relay  test_sourcer_noexist
	assert_return_code_child_failure_relay  test_sourcer_default_exist
	assert_return_code_child_failure_relay  test_sourcer_build_source_noexist
	assert_return_code_child_failure_relay  test_sourcer_build_compose_pkgA_pkgB
	assert_return_code_child_failure_relay  test_sourcer_build_compose_override_pkgA
	assert_return_code_child_failure_relay  test_sourcer_build_compose_override_pkgA_compose_pkgB_1
	assert_return_code_child_failure_relay	test_sourcer__build_funcvar_exception_report
	assert_return_code_child_failure_relay	test_sourcer__build_funcvar_exception_tag
	assert_return_code_set
}

main
