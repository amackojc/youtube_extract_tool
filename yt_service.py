#!/usr/bin/python

import os
from pytube import YouTube

YOUTUBE_SERVICE = 'https://www.youtube.com/watch?v='
CODEC='av01'

def list_possible_formats(yt_id, codec):
    yt_object = YouTube(YOUTUBE_SERVICE + yt_id)
    candidates_mp4 = yt_object.streams \
        .filter(file_extension='mp4').all()

    for video in candidates_mp4:
#        if any(codec in extension for extension in video.codecs):
        print(video)

def download_videos(yt_id, codec):
    yt_object = YouTube(YOUTUBE_SERVICE + yt_id)
    candidates_mp4 = yt_object.streams \
        .filter(file_extension='mp4').all()

    try:
        os.mkdir(f'{candidates_mp4[0].title}')
    except FileExistsError:
        print(f'Dictionary already exists in path {os.getcwd()}')

    os.chdir(f'{candidates_mp4[0].title}')

    for video in candidates_mp4:
        if any(codec in extension for extension in video.codecs):
            video.download(filename=f'{video.resolution}.mp4')

if __name__ == '__main__':
    list_possible_formats('rt-2cxAiPJk', CODEC)
#    download_videos('rt-2cxAiPJk', CODEC)
