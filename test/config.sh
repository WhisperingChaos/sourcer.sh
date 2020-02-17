#/bin/bash
main(){
	declare ver='v1.1'
	declare repoVerUrl='https://raw.githubusercontent.com/WhisperingChaos/assert.source.sh/'"$ver"'/component/assert.source.sh'
	wget --dns-timeout=5 --connect-timeout=10 --read-timeout=60 -O ./base/assert.source.sh  "$repoVerUrl"
}
main

