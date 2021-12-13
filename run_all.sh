#!/bin/bash

# 1. Downloading videos from YT (ID's prepared before)
python3 yt_service.py yt_videos_to_download.txt
# 1. Extracting frames
./extract_frames.sh
# 2. Upscaling extracted frames to the same resolution
./upscale_4k.sh
# 3. Splitting frames into 100x100 blocks
./split_into_blocks.sh
# 4. Preparing blocks to dataset folder
./prepare_data.sh
