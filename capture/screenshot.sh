#!/bin/bash

# Set the filename for the screenshot
timestamp=$(date +"%Y%m%d%H%M%S")
output_dir="./logs/captures"  # Save inside logs/captures folder
output_file="$output_dir/screenshot_$timestamp.png"

# Create the directory if it doesn't exist
mkdir -p "$output_dir"

# Ensure proper DISPLAY environment and permissions
export DISPLAY=:0  # Adjust this as necessary based on your display setup
xhost +SI:localuser:$(whoami)  # Allow access to the X session

# Unset GTK_PATH to resolve Wayland/Xorg conflicts
unset GTK_PATH

# Capture the screenshot using gnome-screenshot or fallback to scrot/import
if command -v gnome-screenshot &>/dev/null; then
    gnome-screenshot --file="$output_file"
elif command -v scrot &>/dev/null; then
    scrot "$output_file"
elif command -v import &>/dev/null; then
    import -window root "$output_file"
else
    echo "Error: No screenshot tool found (gnome-screenshot, scrot, or import)"
    exit 1
fi

# Check if the screenshot was successful
if [ $? -eq 0 ]; then
    echo "Screenshot saved to $output_file"
else
    echo "Error capturing screenshot"
    exit 1
fi
