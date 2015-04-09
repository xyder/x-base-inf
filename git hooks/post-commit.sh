#!/bin/bash

<<META
@Author: Xyder
@Description: Automatic script for git post-commit that will save commit, daily and weekly backups up to the limits set.
@Version: 1.2.1
META

<<INFO
- rename to post-commit and place in the hooks folder
naming:
    - daily, weekly - last commit before current or current if missing
    - latest - latest commit
    - prev - previous commits

TODO: maybe switch to differential backups someday
INFO

<<TESTS
- test if it works with multiple "latest"
- test if it maintains the latest bkps only, according to the max counts set
- test if "previous latest" is calculated correctly
    - it assumes the top of the prev stack
    - if that doesn't exist, it assumes the current latest
- test if daily and weekly are copied from the "previous latest"
TESTS

<<CHANGELOG
v1.2.1 - fixed bug printing minutes instead of months in log timestamp
v1.2 - added excluded directories from archiving
v1.1 - added IFS rule
CHANGELOG

# this will make a glob expand to null if no matching can be found
shopt -s nullglob

IFS=$'\n'

# paths
rep_name="${PWD##*/}"
rep_dir="${PWD}"
bkp_dir="${PWD%/*}/0.git-auto-bkps/$rep_name/"
log_file="backups.log"

# directories which will be excluded from backup archives. modify as needed.
ignored_dirs=("*/bin/*" "*/obj/*")

# max backups for commit, daily and weekly
cmt_max=3
daily_max=3
weekly_max=3

# suffixes and extensions for files
ext=".zip"
cmt_prev_suff=".prev"$ext
cmt_crt_suff=".latest"$ext
daily_suff=".daily"$ext
weekly_suff=".weekly"$ext

# suffixes with added timestamps
cmt_crt_ext=".$(date +"%Y%m%d%H%M%S")$cmt_crt_suff"
daily_ext=".$(date +"%Y%m%d")$daily_suff"
weekly_ext=".$(date +"%Y%W")$weekly_suff"

# create directory if not exist
mkdir -p "$bkp_dir"

# function that will push a message into the log file
function pmsg()
{
    echo $(date +"%Y/%m/%d - %H:%M:%S - ")$@$'\r' >>"$bkp_dir$log_file"
}

# function that will delete the first files in an array until the total length of the array satisfies a given limit
function delete_expired()
{
    # take the first parameter by name
    arr_name=$1[@]
    
    # expand to an array
    files=("${!arr_name}")
    
    # store array length
    n_files=${#files[@]}
    
    # calculate the number of files that need to be deleted
    n_overflow=$(($n_files-$2))
    
    # check if action is required
    if [ $n_overflow -gt 0 ]; then
        pmsg $3": Deleting $n_overflow expired backup(s).."
        i=0
        
        # delete the overflow
        for f in ${files[@]}; do
            if [ $i -lt $n_overflow ]; then
                rm -f ${files[$i]}
            else
                break
            fi
            ((++i))
        done
    fi
}

pmsg "===== BACKUP START ==================="

# rename every file ending with $cmt_prev_suff
latest_list=("$bkp_dir$rep_name"*"$cmt_crt_suff")

if [ ${#latest_list[@]} -ne 0 ]; then
    for f in ${latest_list[@]}; do
        pmsg "LTST: Renaming ${#latest_list[@]} backup(s).."
        mv "$f" "${f%$cmt_crt_suff}$cmt_prev_suff";
    done
fi

# get the list of files ending with $cmt_prev_suff
prev_list=("$bkp_dir$rep_name"*"$cmt_prev_suff")

# get the last in the list
if [ ${#prev_list[@]} -ne 0 ]; then
    prev_latest=${prev_list[${#prev_list[@]} - 1]}
fi

# delete from the backup list until it satisfies the limit
delete_expired prev_list $cmt_max "PREV"

# create a zip containing the current working directory
pmsg "LTST: \"$rep_name$cmt_crt_ext\" is created.."
zip -qr "$bkp_dir$rep_name$cmt_crt_ext" . -x "${ignored_dirs[@]}"

# if there were no files ending with $cmt_prev_suff, $prev_latest
# will contain the name of the zip with the current working directory
if [ -z $prev_latest ]; then
    prev_latest="$bkp_dir$rep_name$cmt_crt_ext"
fi

# create the current daily backup from the $prev_latest if needed
if [ ! -f "$bkp_dir$rep_name$daily_ext" ]; then
    pmsg "DALY: Latest created from \"${prev_latest##*/}\"."
    cp -f "$prev_latest" "$bkp_dir$rep_name$daily_ext"
fi

# delete from the daily list until it satisfies the limit
daily_list=("$bkp_dir$rep_name"*"$daily_suff")
delete_expired daily_list daily_max "DALY"

# create the current weekly backup from the $prev_latest if needed
if [ ! -f "$bkp_dir$rep_name$weekly_ext" ]; then
    pmsg "WKLY: Latest created from \"${prev_latest##*/}\"."
    cp -f "$prev_latest" "$bkp_dir$rep_name$weekly_ext"
fi

# delete from the weekly list until it satisfies the limit
weekly_list=("$bkp_dir$rep_name"*"$weekly_suff")
delete_expired weekly_list weekly_max "WKLY"

pmsg "===== BACKUP END ====================="