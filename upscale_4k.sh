#!/bin/bash


WORKSPACE=$(pwd)

if [[ -d "${WORKSPACE}/UPSCALED_FRAMES" ]]
then
    echo "Directory already exists"
    rm -r "${WORKSPACE}/UPSCALED_FRAMES"/*
else
    mkdir -p "${WORKSPACE}/UPSCALED_FRAMES"
fi

for file in "${WORKSPACE}/FRAMES/"*.png; do
    file_name=$(echo "${file}" | awk -F "/" ' { print$NF } ')
    echo "${WORKSPACE}/UPSCALED_FRAMES/${file_name}"
    ffmpeg -i "${file}" -vf scale=3840:2160,setsar=1:1 "${WORKSPACE}/UPSCALED_FRAMES/${file_name}"
done

