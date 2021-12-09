#!/bin/bash

# There I will be storing repeated func from other scripts

function prepare_directories() {
    folder_name="${1}"
    if [[ -d "${WORKSPACE}/${folder_name}" ]]
    then
        echo "Directory already exists"
        if [[ ! -z "$(ls "${WORKSPACE}/${folder_name}")" ]]; then
            rm -r "${WORKSPACE}/${folder_name}"/*
        fi
    else
        mkdir -p "${WORKSPACE}/${folder_name}"
    fi
}

function get_file_from_fullpath () {
    echo "${1}" | \
    awk -F '/' '{ print$NF }'
}
