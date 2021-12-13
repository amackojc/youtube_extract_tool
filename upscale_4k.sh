#!/bin/bash

WORKSPACE=$(pwd)

INPUT_FOLDER='FRAMES'
OUTPUT_FOLDER="${WORKSPACE}/UPSCALED_FRAMES"

FRAME_OUTPUT_RESOLUTION='3840:2160'
SET_SCALE_CONFIG="scale=${FRAME_OUTPUT_RESOLUTION}"
SETSAR_CONFIG="setsar=${DISPLAY_ASPECT_RATIO}"
DISPLAY_ASPECT_RATIO='1:1'

source "${WORKSPACE}/common.sh"

function upscale_frame {
    ffmpeg -i "${1}" \
           -vf "${SET_SCALE_CONFIG}","${SETSAR_CONFIG}" "${2}"
}

function frames_upscaling_process {
    for directory in "${1}"/*; do 
        if [ -d "${directory}" ];then
            directory_name=$(get_file_from_fullpath "${directory}")
            output_directory="${2}/${directory_name}_${3}"
            for frame in "${directory}"/*.png; do
                output_file_name=$(get_file_from_fullpath "${frame}")
                upscale_frame "${frame}" \
                              "${output_directory}/${output_file_name}"
            done
        fi
    done
}

function run {
    create_directory "${OUTPUT_FOLDER}"
    clean_up_content "${OUTPUT_FOLDER}"
    prepare_output_directory "${WORKSPACE}/${INPUT_FOLDER}" \
                             "${OUTPUT_FOLDER}" \
                             "UPSCALED"

    frames_upscaling_process "${WORKSPACE}/${INPUT_FOLDER}" \
                             "${OUTPUT_FOLDER}" \
                             "UPSCALED"
}

run
