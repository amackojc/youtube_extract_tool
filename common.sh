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
    rm -r "${1}"
}
