#!/bin/bash

# Set up paths for key logging
timestamp=$(date +"%Y%m%d%H%M%S")
KEY_LOG_DIR="./logs/key_logs"
mkdir -p "$KEY_LOG_DIR"
KEY_LOG_FILE="$KEY_LOG_DIR/key_logs_$timestamp.log"

# Ensure required tools are installed
if ! command -v evtest &>/dev/null; then
    echo "Error: evtest is not installed. Please install it first (e.g., sudo apt install evtest)."
    exit 1
fi

# Function to find the keyboard device based on EV_KEY events
find_keyboard_device() {
    echo "Searching for keyboard input devices..."
    for device in /dev/input/event*; do
        # Check if the device is likely a keyboard using udevadm
        if udevadm info --query=all --name="$device" | grep -q "ID_INPUT_KEYBOARD"; then
            # Check for the EV_KEY event type using evtest (limit output to save time)
            echo "Checking device: $device"
            if sudo evtest "$device" | head -n 10 | grep -q "Event type 1 (EV_KEY)"; then
                echo "Keyboard device found: $device"
                echo "Device: $device" >> "$KEY_LOG_FILE"
                device_found="$device"
                return 0
            fi
        fi
    done
    echo "No keyboard device found. Exiting."
    exit 1
}

# Select the keyboard device
find_keyboard_device

# Start key logging
log_keys() {
    echo "Starting key logging on device $device_found..."
    echo "Logging to: $KEY_LOG_FILE"
    sudo evtest "$device_found" >> "$KEY_LOG_FILE" &
    LOG_PID=$!
    echo "Logging started. Process ID: $LOG_PID"
}

# Stop key logging after 2 minutes
stop_logging() {
    echo "Stopping key logging after 2 minutes..."
    sleep 120
    if ps -p $LOG_PID > /dev/null; then
        sudo kill $LOG_PID
        echo "Key logging stopped. Logs saved to $KEY_LOG_FILE."
    else
        echo "Error: Key logging process is not running."
    fi
}

# Run the decoder script
run_decoder() {
    echo "Running decoder script to process the key logs..."
    # Dynamically determine the path to `decoder.py`
    SCRIPT_DIR="$(dirname "$(realpath "$0")")"
    DECODER_PATH="$SCRIPT_DIR/decoder.py"
    if [ -f "$DECODER_PATH" ]; then
        python3 "$DECODER_PATH" "$KEY_LOG_FILE"
        if [ $? -ne 0 ]; then
            echo "Error: Decoder script failed!"
            exit 1
        fi
    else
        echo "Error: Decoder script not found at $DECODER_PATH!"
        exit 1
    fi
}

# Begin logging
log_keys

# Stop logging after 2 minutes
stop_logging

# Run the decoder
run_decoder
