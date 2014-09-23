#! /bin/bash

#variable declaration
fandr=false
path_source_dir=$(readlink -e $1)
path_target_dir=$(readlink -e $2)
source_dir_files=$(ls $1)

#copy files from source into target directory
function copy(){
	cp -p $path_source_dir/$1 $path_target_dir
}

#in file: finds search pattern and replaces it with substitution pattern
function find_replace(){
	sed -i "s/$2/$3/g" $path_target_dir/$1
}

#if script is given 4 arguments find_replace is conducted
if [ $# -eq 4 ]
then
	fandr=true
fi

#check if source and target directory exist and if they are read- or writeable
if [ ! -r $1 ]
then
	echo "Source directory does not exist or is not readable"
elif [ ! -w $2 ]
then
	echo "Target directory does not exist or is not writeable"
else
	#copy all files except directories from source into target directory
	for j in $source_dir_files
	do
		if [ -d $path_source_dir/$j ]
		then
			continue
		fi

		echo "Copy $path_source_dir/$j to $path_target_dir"
		copy $j

		if [ $fandr = true ]
		then
			find_replace $j $3 $4
		fi
	done
fi

