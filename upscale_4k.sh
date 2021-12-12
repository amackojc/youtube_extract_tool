#!/bin/bash


WORKSPACE=$(pwd)
FRAME_OUTPUT_RESOLUTION='3840:2160'
INPUT_FOLDER='FRAMES'
OUTPUT_FOLDER='UPSCALED_FRAMES'
DISPLAY_ASPECT_RATIO='1:1'
source "${WORKSPACE}/common.sh"

function upscale_frame {
    ffmpeg -i "${1}" \
           -vf scale="${FRAME_OUTPUT_RESOLUTION}",setsar="${DISPLAY_ASPECT_RATIO}" "${2}"
}

function run {
    prepare_directory "${WORKSPACE}/${OUTPUT_FOLDER}"
    for directory in "${WORKSPACE}/${INPUT_FOLDER}/"*; do
        if [ -d "${directory}" ];then
            output_directory_name=$(get_file_from_fullpath "${directory}")
            output_directory="${WORKSPACE}/${OUTPUT_FOLDER}/${output_directory_name}_UPSCALED"
            prepare_directory "${output_directory}"
            for frame in "${directory}"/*.png; do
                output_file_name=$(get_file_from_fullpath "${frame}")
                upscale_frame "${frame}" "${output_directory}/${output_file_name}"
                #upscale_frame "${frame}" "${directory}/${output_file_name}"
                #ffmpeg -i "${file}" -vf scale=3840:2160,setsar=1:1 "${WORKSPACE}/UPSCALED_FRAMES/${file_name}"
            done
        fi
    done
}

run
