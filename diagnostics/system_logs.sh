#!/bin/bash

# Ensure the script is executable
SCRIPT_PATH=$(realpath "$0")
chmod +x "$SCRIPT_PATH"

# Set the filename for the system logs
timestamp=$(date +"%Y%m%d%H%M%S")
output_dir="./logs/system_logs"  # Save inside logs/system_logs folder
output_file="$output_dir/system_logs_$timestamp.log"

# Create the directory if it doesn't exist
mkdir -p "$output_dir"

# Collect system diagnostics
{
    echo "===== System Information ====="
    uname -a
    echo ""

    echo "===== Disk Usage ====="
    df -h
    echo ""

    echo "===== Memory Usage ====="
    free -h
    echo ""

    echo "===== CPU Usage ====="
    top -b -n 1 | head -20
    echo ""

    echo "===== Active Network Connections ====="
    netstat -tulnp
    echo ""

    echo "===== Uptime ====="
    uptime
    echo ""

    echo "===== Last 10 Logins ====="
    last -n 10
    echo ""

    echo "===== Installed Updates ====="
    apt list --installed
} > "$output_file"

# Check if the log was successfully created
if [ $? -eq 0 ]; then
    echo "System logs saved to $output_file"
else
    echo "Error saving system logs"
    exit 1
fi
