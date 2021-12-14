#!/bin/bash

WORKSPACE=$(pwd)
INPUT_FOLDER='BLOCKS'
OUTPUT_FOLDER="${WORKSPACE}/DATASET"
source "${WORKSPACE}/common.sh"

RESOLUTIONS=(
    '2160p'
    '1440p'
    '1080p'
    '720p'
    '480p'
    '360p'
    '240p'
    '144p'
)

function prepare_dataset_folder {
    for label in ${1}; do
        create_directory "${2}/${label}"
    done
}

function copy_folders_to_dataset {
    for directory in "${1}"/*; do
        if [[ "${directory}" == *"2160p"* ]]; then
            cp -R "${directory}" "${OUTPUT_FOLDER}/2160p"
        elif [[ "${directory}" == *"1440p"* ]]; then
            cp -R "${directory}" "${OUTPUT_FOLDER}/1440p"
        elif [[ "${directory}" == *"1080p"* ]]; then
            cp -R "${directory}" "${OUTPUT_FOLDER}/1080p"
        elif [[ "${directory}" == *"720p"* ]]; then
            cp -R "${directory}" "${OUTPUT_FOLDER}/720p"
        elif [[ "${directory}" == *"480p"* ]]; then
            cp -R "${directory}" "${OUTPUT_FOLDER}/480p"
        elif [[ "${directory}" == *"360p"* ]]; then
            cp -R "${directory}" "${OUTPUT_FOLDER}/360p"
        elif [[ "${directory}" == *"240p"* ]]; then
            cp -R "${directory}" "${OUTPUT_FOLDER}/240p"
        elif [[ "${directory}" == *"144p"* ]]; then
            cp -R "${directory}" "${OUTPUT_FOLDER}/144p"
        fi
    done
}

function run {
    clear
    create_directory "${OUTPUT_FOLDER}"
    clean_up_content "${OUTPUT_FOLDER}"
    echo "Preparing DATASET folder..."
    prepare_dataset_folder "${RESOLUTIONS[*]}" \
                           "${OUTPUT_FOLDER}"
    copy_folders_to_dataset "${WORKSPACE}/${INPUT_FOLDER}"
    echo "Done!"
}

run
