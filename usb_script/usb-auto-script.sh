#!/bin/bash

# Dynamically determine the USB mount point
USB_MOUNT_POINT=$(pwd)  # Assumes you're running the script directly from the USB
DEST_PATH="$HOME/USB_Files"  # Destination path for copied files

echo "Running from USB mount point: $USB_MOUNT_POINT"

# Check if the 'PRISM' folder exists on the USB
PRISM_PATH="$USB_MOUNT_POINT/PRISM"
if [ -d "$PRISM_PATH" ]; then
  echo "'PRISM' folder found. Starting file copy process..."
  
  # Create the destination folder if it doesn't exist
  mkdir -p "$DEST_PATH"

  # Copy the entire 'PRISM' directory to the destination
  if cp -r "$PRISM_PATH" "$DEST_PATH"; then
    echo "Files copied successfully to $DEST_PATH."
    
    # Locate and execute 'main.sh'
    MAIN_SCRIPT_PATH="$DEST_PATH/PRISM/engine/main.sh"
    if [ -f "$MAIN_SCRIPT_PATH" ]; then
      echo "Running main.sh..."
      bash "$MAIN_SCRIPT_PATH"
    else
      echo "main.sh not found in the expected location!"
    fi
  else
    echo "Failed to copy 'PRISM' directory."
  fi
else
  echo "'PRISM' folder not found at $PRISM_PATH."
fi
