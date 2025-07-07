#!/usr/bin/env bash

if [ $# -ne 2 ]; then
	echo "error: need 2 parameter. Usage: $0 <fire-directory> <text-to-write> " >&2
	exit 1
fi

writefile="$1"
writestr="$2"

dirpath=$(dirname "$writefile")

if [ ! -d "$dirpath" ]; then
	mkdir -p "$dirpath"

	if [ $? -ne 0 ]; then
		echo "error: cannot creat dir '$dirpath'" >&2
		exit 1
	fi
fi

echo "$writestr" > "$writefile" 2>/dev/null

if [ $? -ne 0 ]; then
	echo "error: cannot write to '$writefile'" >&2
	exit 1
fi
