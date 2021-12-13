#!/bin/bash

# There I will be storing repeated func from other scripts

function create_directory {
    if [[ ! -d "${1}" ]]; then
        mkdir -p "${1}"
    fi
}

function get_file_from_fullpath {
    echo "${1}" | \
    awk -F '/' '{ print$NF }'
}

function clean_up_content {
    if ! rm -r "${1}"/* 2> /dev/null; then
        echo "Nothing to clean..."
    fi
}

function prepare_output_directory {
    for directory in "${1}"/*; do
        if [ -d "${directory}" ]; then
            directory_name=$(get_file_from_fullpath "${directory}")
            output_directory="${2}/${directory_name}_${3}"
            create_directory "${output_directory}"
        fi
    done
}

function check_directory_is_empty {
    number_of_files=$(
        find "${1}" -type f | \
        wc -l
    )
    dir=$(get_file_from_fullpath "${1}")
    if [[ ${number_of_files} == 0 ]]; then
        echo "${directory} is empty!"
        return 0
    else
        return 1
    fi
}
