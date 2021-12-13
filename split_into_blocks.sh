#!/bin/bash

WORKSPACE=$(pwd)

INPUT_FOLDER='UPSCALED_FRAMES'
OUTPUT_FOLDER="${WORKSPACE}/BLOCKS"

HEIGHT_BLOCK=100
WIDTH_BLOCK=100

source "${WORKSPACE}/common.sh"

function split_into_block {
    convert \
        -crop "${HEIGHT_BLOCK}"x"${WIDTH_BLOCK}" \
        "${1}" \
        "${2}"
}

function splitting_process {
    echo "Splliting..."
    for directory in "${1}"/*; do
        if [ -d "${directory}" ]; then
            directory_name=$(get_file_from_fullpath "${directory}")
            output_directory="${2}/${directory_name}_${3}"
            if check_directory_is_empty "${directory}"; then
                continue
            fi
            for image in "${directory}"/*.png; do
                output_file=$(get_file_from_fullpath "${image}")
                echo "${output_file}"
                split_into_block "${image}" \
                                 "${output_directory}/${output_file}"
            done
        fi
    done
    echo "Done!"
}

function run {
    create_directory "${OUTPUT_FOLDER}"
    clean_up_content "${OUTPUT_FOLDER}"
    prepare_output_directory "${WORKSPACE}/${INPUT_FOLDER}" \
                             "${OUTPUT_FOLDER}" \
                             "BLOCKS"

    splitting_process "${WORKSPACE}/${INPUT_FOLDER}" \
                      "${OUTPUT_FOLDER}" \
                      "BLOCKS"
}

run
