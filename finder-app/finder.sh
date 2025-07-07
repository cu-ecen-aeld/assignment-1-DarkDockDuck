#!/usr/bin/env bash

#parameters check
if [ $# -ne 2 ]; then
	echo "Need 2 parameters. Usage: $0 <dir> <searching-string>" 
	exit 1
fi

filesdir="$1"
searchstr="$2"

#checking dir is validable

if [ ! -d "$filesdir" ]; then
	echo "error :$filesdir is not a directory" >&2
	exit 1
fi

#count file numbers X
file_count=$(find "$filesdir" -type f |wc -l)

#count string match Y
match_count=$(grep -r -- "$searchstr" "$filesdir" | wc -l)

echo "The number of files are $file_count and the number of matching lines are $match_count."
