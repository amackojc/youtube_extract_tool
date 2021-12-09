#!/bin/bash

WORKSPACE=$(pwd)
NUMBER_OF_FRAMES=2
source "${WORKSPACE}/common.sh"

prepare_directories "FRAMES"
excluded_directories=(
    "${WORKSPACE}/FRAMES \
     ${WORKSPACE}/BLOCKS \
     ${WORKSPACE}/UPSCALED_FRAMES")

function get_movie_duration() {
    ffprobe -loglevel error -i "${1}" \
            -show_format | \
            grep duration | \
            awk -F '=' '{ print$2 }'
}

function calculate_step_for_frames() {
    bc <<< "scale=4; 1/(${1}/${2})"
}

for dict in "${WORKSPACE}"/*; do
    #if [ -d "${dict}" ] && 
    #   [[ "${dict}" != "${WORKSPACE}/FRAMES" ]] &&
    #   [[ "${dict}" != "${WORKSPACE}/BLOCKS" ]] &&
    #   [[ "${dict}" != "${WORKSPACE}/UPSCALED_FRAMES" ]]; then
    if [ -d "${dict}" ] && [[ ! "${excluded_directories[*]}" =~ "${dict}" ]]; then
        # If dict if directory
        for file in "${dict}"/*; do
            duration=$(get_movie_duration "${file}")
            #step=$(bc <<< "scale=4; 1/(${duration}/2)")
            step=$(get_movie_duration "${duration}" "${NUMBER_OF_FRAMES}")
            file_name=$(
                echo ${dict} | \
                     awk -F '/' '{ print$NF }'
            )
            file_test=$(echo ${file%.*} | awk -F '/' '{ print$NF }')
            echo "${file_test}"
            ffmpeg -i "${file}" -ss 5 -vf fps=${step} "${WORKSPACE}/FRAMES/${file_name}_${file_test}"_%2d.png
        done
    fi
done

# Below command will display duration in sec of specific video
# ffprobe -loglevel error -i <video_name> -show_format | grep duration

# 1. Split video duration in list with 100 elements
# step=$(bc <<< "scale=4; ${duration}/6")
# list=($(seq 0 ${step} ${duration}))
# 2. Select 10-20 elements from above list randomly
# 3. Use these randomly chosen elemets to extract frames using ffmpeg

# 21.11
# - Split this only code to functions..
# - ffmpeg -ss 5 -i <video_file> <output_file.png> for extract frame
# - Additional folder for extracting frames
