#! /bin/bash
#Boolean if find and replace is performed
fandr=false

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
if [ $# -eq 0 -o $# -eq 1 -o $# -eq 3 ]
then
	echo "Missing argument"
	echo "Use: 'source_directory target_directory' or 'source_directory target_directory search_pattern substitution_pattern'"
elif [ ! -d $1 -o ! -r $1 ]
then
	echo "Source directory does not exist or is not readable"
elif [ ! -d $2 -o ! -w $2 ]
then
	echo "Target directory does not exist or is not writeable"
else
	path_source_dir=$(readlink -e $1)
	path_target_dir=$(readlink -e $2)
	source_dir_files=$(ls $1)
	#copy all files except directories from source into target directory
	for j in $source_dir_files
	do
		#if file in source directory is directory or not readable --> continue
		if [ -d $path_source_dir/$j ]
		then
			continue
		elif [ ! -r $path_source_dir/$j]
		then
			echo "$path_source_dir/$j is not readable."
			continue
		fi

		echo "Copy $path_source_dir/$j to $path_target_dir"
		copy $j
		
		#if 4 arguments are found the find and replace takes place
		if [ $fandr = true ]
		then
			#if Non-ASCII file finde and replace can not take place
			ascii_count=$(file $path_target_dir/$j | grep -c ASCII)
			if [ $ascii_count -eq 0 ]
			then
				echo "Could not perform find and replace. $path_target_dir/$j is Non-ASCII file."
				continue
			else
				echo "Find and replace in $path_target_dir/$j"
				find_replace $j $3 $4
			fi
		fi
	done
fi

