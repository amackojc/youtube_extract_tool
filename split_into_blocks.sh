#!/bin/bash

WORKSPACE=$(pwd)
source "${WORKSPACE}/common.sh"

prepare_directories "BLOCKS"

HEIGHT_BLOCK=1000
WIDTH_BLOCK=1000

for image in "${WORKSPACE}/UPSCALED_FRAMES/"*png; do
    input_file=$(
        echo "${image}" | \
        awk -F "/" '{ print$NF }'
    ) 
    output_file=$(
        echo "${input_file}" | \
        sed  -e 's/:/_/g' \
             -e 's/ //g'
    )
    convert \
        -crop "${HEIGHT_BLOCK}"x"${WIDTH_BLOCK}" \
        "${WORKSPACE}/UPSCALED_FRAMES/${input_file}" \
        "${WORKSPACE}/BLOCKS/${output_file}"
    count+=1
done


