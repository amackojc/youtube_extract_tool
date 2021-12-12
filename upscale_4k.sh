#!/bin/bash

WORKSPACE=$(pwd)
FRAME_OUTPUT_RESOLUTION='3840:2160'
INPUT_FOLDER='FRAMES'
OUTPUT_FOLDER="${WORKSPACE}/UPSCALED_FRAMES"
SET_SCALE_CONFIG="scale=${FRAME_OUTPUT_RESOLUTION}"
SETSAR_CONFIG="setsar=${DISPLAY_ASPECT_RATIO}"

DISPLAY_ASPECT_RATIO='1:1'
source "${WORKSPACE}/common.sh"

function upscale_frame {
    ffmpeg -i "${1}" \
           -vf "${SET_SCALE_CONFIG}","${SETSAR_CONFIG}" "${2}"
}

function prepare_output_directory {
    for directory in "${WORKSPACE}/${INPUT_FOLDER}/"*; do
        if [ -d "${directory}" ]; then
            directory_name=$(get_file_from_fullpath "${directory}")
            output_directory="${OUTPUT_FOLDER}/${directory_name}_UPSCALED"
            create_directory "${output_directory}"
        fi
    done

}

function frames_upscaling_process {
    for directory in "${WORKSPACE}/${INPUT_FOLDER}/"*; do
        if [ -d "${directory}" ];then
            directory_name=$(get_file_from_fullpath "${directory}")
            output_directory="${OUTPUT_FOLDER}/${directory_name}_UPSCALED"
            for frame in "${directory}"/*.png; do
                output_file_name=$(get_file_from_fullpath "${frame}")
                upscale_frame "${frame}" \
                              "${output_directory}/${output_file_name}"
            done
        fi
    done
}

function run {
    clean_up_content "${OUTPUT_FOLDER}"
    create_directory "${OUTPUT_FOLDER}"
    prepare_output_directory
    frames_upscaling_process
}

run
