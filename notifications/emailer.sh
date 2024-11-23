#!/bin/bash

# Gmail credentials
EMAIL="testshell975@gmail.com"
APP_PASSWORD="ohvj mvfn sgus nfaq"  # Replace with your app password

# Email content
TO_EMAIL="narcis.karanfilov@gmail.com"  # Replace with the recipient's email
SUBJECT="PRISM Snapshot"
BODY="Attached are the latest snapshots."

# Directory for logs and captures
CAPTURE_DIR="./logs/captures"

# Find the latest camera snapshot and screenshot based on modification time
CAMERA_SNAPSHOT=$(ls -t "$CAPTURE_DIR"/camera_snapshot_*.jpg 2>/dev/null | head -n 1)
SCREENSHOT=$(ls -t "$CAPTURE_DIR"/screenshot_*.png 2>/dev/null | head -n 1)

# Debug: Print paths
echo "Latest camera snapshot: $CAMERA_SNAPSHOT"
echo "Latest screenshot: $SCREENSHOT"

# Check if the files exist
if [[ ! -f "$CAMERA_SNAPSHOT" ]]; then
    echo "Error: No camera snapshot file found in $CAPTURE_DIR"
    exit 1
fi

if [[ ! -f "$SCREENSHOT" ]]; then
    echo "Error: No screenshot file found in $CAPTURE_DIR"
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
    echo "--boundary1--"
) | msmtp --from=default -t "$TO_EMAIL"

# Check if the email was sent successfully
if [ $? -eq 0 ]; then
    echo "Email sent successfully to $TO_EMAIL."
else
    echo "Error sending email."
    exit 1
fi
