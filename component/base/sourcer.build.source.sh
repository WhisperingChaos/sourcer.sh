declare -g sourcer__BASE_DIR_NAME='base'
declare -g sourcer__build_SOURCER_SH_NAME='sourcer.sh'
declare -g sourcer__build_SOURCER_SH_NAME_DIR=${sourcer__build_SOURCER_SH_NAME%.*}


sourcer__build_parameter_check(){
	local -r sourcerShFilePathRtn=$1
	local -r sourceFilePathRtn=$2
	local -r sourceRoot="${4:-"$(dirname "$0")"}"
	local -r sourcerShDir="${3:-$sourceRoot/$sourcer__build_SOURCER_SH_NAME_DIR}"

	if ! [ -e "$sourcerShDir/$sourcer__build_SOURCER_SH_NAME" ]; then
		sourcer__build_sourcer_noexist "$sourcerShDir"
		return 1
	fi

	if ! [ -e "$sourceRoot/$sourcer__BASE_DIR_NAME" ]; then
		sourcer__build_source_noexist "$sourceRoot"
		return 1
	fi

	if ! command -v $sourcerShFilePathRtn; then
		eval $sourcerShFilePathRtn=\"\$sourcerShDir\/\$sourcer__build_SOURCER_SH_NAME\"
	fi
	if ! command -v $sourceFilePathRtn; then
		eval $sourceFilePathRtn=\"\$sourceRoot\"
	fi
}


sourcer__build_sourcer_noexist(){
	local -r sourcerShDir="$1"

	cat >&2<<SOURCER__SOURCER_SH_NOEXIST

Error: Unable to locate '$sourcer__build_SOURCER_SH_NAME' in directory: '$sourcerShDir'. 
SOURCER__SOURCER_SH_NOEXIST
}


sourcer__build_source_noexist(){
	local -r sourceRoot="$1"

	cat >&2<<SOURCER__BUILD_SOURCE_NOEXIST

Error: Unable to locate initial '$sourcer__BASE_DIR_NAME' source directory: '$sourceRoot/$sourcer__BASE_DIR_NAME'. 
SOURCER__BUILD_SOURCE_NOEXIST
}


sourcer__build_help(){

	cat <<SOURCER__BUILD_HELP

source [<path>]sourcer.build.source.sh [<pathToSourcer>] [<pathToComponentRoot>] [<pathToOverride>]

  <path>                     Path to directory containing 'sourcer.build.source.sh' - optional.  If not
                             specified then this module is available through \$PATH.

  <pathToSourcer>            Path to '$sourcer__build_SOURCER_SH_NAME' - optional. If not specified this script
                             will search within the directory defining the component
                             being constructed: "<pathToComponentRoot>/$sourcer__build_SOURCER_SH_NAME_DIR/$sourcer__build_SOURCER_SH_NAME".
                             This search mechanism enables each component to implement its own '$sourcer__build_SOURCER_SH_NAME'.
                             Usually Optional, unless any parameters are specified after it.

  <pathToComponentRoot>      Path to directory defining component - optional.  The following subdirectory: 
                             '$sourcer__BASE_DIR_NAME' must exist in this path.  If not specified script
                             will assume dirname "\$0": '$(dirname "$0").

  <pathToOverride>           Path to a file whose contents will override the implementation
                             of this source file: ${BASH_SOURCE[0]}. Optional.

SOURCER__BUILD_HELP
}


# allow implementation to be overwritten
if [ -n "$3" ]; then
	if ! source "$3"; then return 1; fi
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	sourcer__build_help
	return
fi
# include components required to create this executable without encapsulating
# the code in a function as 'declare'd variables, that would be considered global
# given their definition in the 'source'd file would be assigned a scope local to
# the encapsulating function.  Once this function terminates, the variables are 
# no longer in scope.  This would be considered unexpected behavior and probably
# reported as a bug. That said, the commands in this source not encapsulated inside
# a function function could be encapsulated in one as long as every globally
# 'declare'd variable included the -g option: 'declare -g <VariableName>' but
# one would have to remember to include the -g option, otherwise, one would
# experience unexpected results, that might consume much time to debug
# as a bash developer's knowledge would suggest the -g option was unnecessary.
declare -g sourcer__build_SOURCER_FILENAME
declare -g sourcer__build_SOURCE_COMPONENT_ROOT
if ! sourcer__build_parameter_check 'sourcer__build_SOURCER_FILENAME' 'sourcer__build_SOURCE_COMPONENT_ROOT'  "$@"; then
	return 1
fi
declare -g sourcer__build_MOD
for sourcer__build_MOD in $( "$sourcer__build_SOURCER_FILENAME" "$sourcer__build_SOURCE_COMPONENT_ROOT"); do
		source "$sourcer__build_MOD"
done
