#!/bin/bash

WORKSPACE=$(pwd)
NUMBER_OF_FRAMES=3
VIDEOS_DICT="${WORKSPACE}/VIDEOS"
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

function create_output_directory() {
    if [ -d "${1}" ]; then
        # Count number of frames in dict
        actual_number_of_frames=$(
            find "${1}" -type f | \
            wc -l
        )
        echo "${actual_number_of_frames}"

        check_property_frames_parameter

        if [[ "$NUMBER_OF_FRAMES" == "${actual_number_of_frames}" ]]; then
            echo "Everything is good"
            return 0
        else
            echo "Number of frames is not property"
            echo "${actual_number_of_frames}"
            if [[ "${actual_number_of_frames}" == 0 ]]; then
                echo "There is nothing in this directory"
            else
                echo -e "Removing the content of directory!\n"
                rm -r "${1}"/*
            fi
        return 1
        fi
    else
        mkdir "${1}"
    fi
}

for dict in "${VIDEOS_DICT}"/*; do
    if [ -d "${dict}" ]; then
        for video in "${dict}"/*; do
            duration=$(get_movie_duration "${video}")
            step=$(calculate_step_for_frames "${duration}" "${NUMBER_OF_FRAMES}")

            file_name=$(get_file_from_fullpath "${dict}")
            resolution_sufix=$(get_file_from_fullpath "${video%.*}")

            new_directory="${WORKSPACE}/FRAMES/${file_name}_${resolution_sufix}"
            if ! create_output_directory "${new_directory}"; then
                ffmpeg -i "${video}" \
                       -ss 5 \
                       -vf fps=${step} \
                       -hide_banner \
                       "${new_directory}/${file_name}_${resolution_sufix}"_%2d.png
            fi
        done
    fi
done



