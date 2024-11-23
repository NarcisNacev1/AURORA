#!/bin/bash

# Set the filename for the snapshot
timestamp=$(date +"%Y%m%d%H%M%S")
output_dir="../captures"
output_file="$output_dir/camera_snapshot_$timestamp.jpg"

# Create the directory if it doesn't exist
mkdir -p "$output_dir"

# Capture the image using `fswebcam` (ensure fswebcam is installed)
fswebcam -r 640x480 --jpeg 85 -D 1 "$output_file"

# Check if the capture was successful
if [ $? -eq 0 ]; then
    echo "Camera snapshot saved to $output_file"
else
    echo "Error capturing camera snapshot"
    exit 1
fi
