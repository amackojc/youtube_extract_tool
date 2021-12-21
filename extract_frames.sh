#!/bin/bash

WORKSPACE=$(pwd)

INPUT_FOLDER='VIDEOS'
OUTPUT_FOLDER="${WORKSPACE}/FRAMES"

NUMBER_OF_FRAMES="${1}"
VIDEOS_DIR="${WORKSPACE}/${INPUT_FOLDER}"
source "${WORKSPACE}/common.sh"

function check_property_frames_parameter {
    if [[ ${NUMBER_OF_FRAMES} == 0 ]]; then
        echo "Frames to extract is equal to zero"
        echo "Change number of frames to extract"
        exit 1
    fi
}

function get_movie_duration() {
    ffprobe -loglevel error -i "${1}" \
            -show_format | \
            grep duration | \
            awk -F '=' '{ print$2 }'
}

function calculate_step_for_frames() {
    bc <<< "scale=4; 1/(${1}/${2})"
}

function check_amount_of_frames () {
    if [[ "$NUMBER_OF_FRAMES" == "${2}" ]]; then
        get_file_from_fullpath "${1}"
        echo "Amount of frames is appropriate"
        return 0
    else
        echo "Number of frames is not property"
        if [[ "${2}" == 0 ]]; then
            echo "There is nothing in this directory"
        else
            echo -e "Removing the content of directory!\n"
            rm -r "${1:?}"/*
        fi
        return 1
    fi

}

function create_output_directory() {
    if [ -d "${1}" ]; then
        # Count number of frames in dict
        actual_number_of_frames=$(
            find "${1}" -type f | \
            wc -l
        )

        check_property_frames_parameter
        if check_amount_of_frames "${1}" "${actual_number_of_frames}"; then
            return 0
        else
            return 1
        fi
    else
        mkdir "${1}"
        return 1
    fi
}

function run {
    clear
    create_directory "${OUTPUT_FOLDER}"
    for dict in "${VIDEOS_DIR}"/*; do
        if [ -d "${dict}" ]; then
            for video in "${dict}"/*; do
                duration=$(get_movie_duration "${video}")
                step=$(calculate_step_for_frames "${duration}" "${NUMBER_OF_FRAMES}")

                file_name=$(get_file_from_fullpath "${dict}")
                resolution_sufix=$(get_file_from_fullpath "${video%.*}")
                echo "${file_name}_${resolution_sufix}: extracing frames..."

                new_directory="${WORKSPACE}/FRAMES/${file_name}_${resolution_sufix}"
                if ! create_output_directory "${new_directory}"; then
                    ffmpeg -i "${video}" \
                           -ss 5 \
                           -r "${step}" \
                           -hide_banner \
                           -loglevel error \
                           "${new_directory}/${file_name}_${resolution_sufix}"_%2d.png
                fi
            done
        fi
    done
}

run
