#!/bin/bash

# Set the filename for the screenshot
timestamp=$(date +"%Y%m%d%H%M%S")
output_dir="../captures"
output_file="$output_dir/screenshot_$timestamp.png"

# Create the directory if it doesn't exist
mkdir -p "$output_dir"

# Capture the screenshot using `scrot` (ensure scrot is installed)
scrot "$output_file"

# Check if the screenshot was successful
if [ $? -eq 0 ]; then
    echo "Screenshot saved to $output_file"
else
    echo "Error capturing screenshot"
    exit 1
fi
