#!/usr/bin/python

import sys
import logging
import os
import pathlib
from pytube import YouTube

WORKSPACE = os.getcwd()
INVALID_SIGNS = [
            '/',
            ':',
            ';',
            '.',
            ',',
            '|',
            '!'
        ]
EXCLUDED_RESOLUTIONS = [
            None,
            '4320p'
        ]
YOUTUBE_SERVICE = 'https://www.youtube.com/watch?v='
CODEC = 'av01'
VIDEO_STANDARD = 'mp4'


def list_possible_formats(yt_id, codec):
    yt_object = YouTube(YOUTUBE_SERVICE + yt_id)
    candidates_mp4 = select_video_standard(yt_object, VIDEO_STANDARD)
    video_name = prepare_video_name(candidates_mp4[0].title)
    print(video_name)

    for video in candidates_mp4:
        if any(codec in extension for extension in video.codecs):
            if video.resolution not in EXCLUDED_RESOLUTIONS:
                print(video)


def select_video_standard(yt_object, video_standard):
    video_candidates = yt_object.streams \
                                .filter(file_extension=video_standard)
    return video_candidates


def prepare_video_name(current_name):
    output_name = " ".join(current_name.split())
    for sign in INVALID_SIGNS:
        if sign in output_name:
            output_name = output_name.replace(sign, '')
    return output_name


def download_videos(yt_id, codec):
    yt_object = YouTube(YOUTUBE_SERVICE + yt_id)
    candidates_mp4 = select_video_standard(yt_object, VIDEO_STANDARD)

    video_name = prepare_video_name(candidates_mp4[0].title)
    pathlib.Path(f'VIDEOS/{video_name}').mkdir(parents=True, exist_ok=True)
    os.chdir(f'VIDEOS/{video_name}')

    print(f"Starting downloading {video_name}!")
    for video in candidates_mp4:
        if any(codec in extension for extension in video.codecs):
            if video.resolution not in EXCLUDED_RESOLUTIONS:
                print(f"Downloading in quality {video.resolution}...")
                video.download(filename=f'{video.resolution}.mp4')
                print("Succed!\n")
    os.chdir(WORKSPACE)


if __name__ == '__main__':
    try:
        list_of_videos=str(sys.argv[1])
    except:
        logging.exception("You haven't pass the necessary argument")
        raise

    try:
        with open(
                list_of_videos,
                encoding='utf-8') as videos_to_download:
            for video_id in videos_to_download:
                download_videos(video_id, CODEC)
    except:
        logging.exception("Invalid arguments... Check parameters you pass")
        raise
