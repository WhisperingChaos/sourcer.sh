#!/bin/bash

declare -g pkga_var_DECLARE_G='-g'
declare pkga_var_DECLARE=''
export pkga_var_EXPORT='export'
pkga_var_SUBSHELL_ONLY='SUBSHELL_ONLY'

pkga_whoami_function_simple_define(){
	echo pkga simple_define
}

function pkga_whoami_function_function_define(){
	echo pkga function_define
}
