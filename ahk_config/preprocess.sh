#! /bin/bash

# preprocess script to allow gitignore by line in ahk scripts
# Franklin Chou (franklin.chou@yahoo.com)
# 20 Nov. 2015

# usage:
# set up a directory structure as follows:

# project/
# --.gitignore
# --preprocess.sh
# --preprocess/

# the subdirectory, preprocess, will contain original unmodified files

# run the preprocess script which will examine the preprocess directory
# looking for files with the specified extension and replace lines surrounded
# by the tags:
# ; no-commit
# ; no-commit-end

# processed source code is commented to indicate number of lines omitted
# finally, processed source code is moved to the parent project directory

PREPROCESS_PATH='./preprocess'

FILE_EXT='ahk'

#------------------------------------------------------------------------------
# Extensible token
# Token can be adjusted based on the language; AHK uses ';'
# @TODO: Recognize source code language and change token

TOKEN='; '

#------------------------------------------------------------------------------

COMMIT_IGNORE_BEGIN=$TOKEN'no-commit'
COMMIT_IGNORE_END=$TOKEN'no-commit-end'

function search {
    if [ "$(ls -A $PREPROCESS_PATH)" ]; then
        n=0
        spacer='   '
        for file in $PREPROCESS_PATH/*; do
            if [ "${file##*.}" = "$FILE_EXT" ]; then
                n=$(( n+1 ))

                local file_lines_ignored=$(process $file)
                printf "Ignored %s%s lines in %s\n"\
                    $file_lines_ignored\
                    "${spacer:${#file_lines_ignored}}"\
                    $file

            fi
        done
        echo 
        echo "Process complete. $n file(s) processed."
    else
        echo "No files to process."
        return
    fi    
}

# @param string containing name of file to process
function process {

    local target=`basename "${1}"`
    install -D /dev/null "$target"    

    local ignore_flag=0
    local total_lines_ignored=0
    local lines_ignored=0

    # logic shamelessly stolen from cppcoder
    # see http://stackoverflow.com/a/10929511/778694
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [[ $ignore_flag -eq 1 && "$line" != "$COMMIT_IGNORE_END" ]]; then
            lines_ignored=$(( lines_ignored+1 ))
            continue
        elif [ "$line" = "$COMMIT_IGNORE_END" ]; then
            ignore_flag=0
            total_lines_ignored=$(( total_lines_ignored+lines_ignored ))
            echo $TOKEN"$lines_ignored lines omitted" >> "$target"
            lines_ignored=0
            continue
        fi

        if [ "$line" = "$COMMIT_IGNORE_BEGIN" ]; then
            ignore_flag=1
            lines_ignored=$(( lines_ignored+1 ))
            continue
        fi

        echo "$line" >> "$target"

    done < "$1"

    echo "$total_lines_ignored"
    
    return
}

#------------------------------------------------------------------------------
# EXECUTE HERE 
#------------------------------------------------------------------------------
search
