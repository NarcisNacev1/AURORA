# PRISM – Personalized Real-time Information System Monitor

## Overview

PRISM is a Linux-based system monitoring tool designed for real-time diagnostics, activity tracking, and system snapshots. With its automated features, PRISM ensures critical system data is logged and monitored effectively. It provides alerts via email to keep users informed of system anomalies or updates.

### Features
- **System Diagnostics**: Real-time monitoring of CPU, memory, and disk usage.
- **Web Activity Tracking**: Logs URLs visited and time spent on websites.
- **Snapshot Capture**: Periodic screenshots and webcam snapshots to ensure comprehensive monitoring.
- **Email Notifications**: Automated alerts for anomalies or completed captures.

## USB Auto-Script Functionality
PRISM now includes a **USB automation script** for seamless execution of monitoring tasks from a USB drive. Simply plug in your USB and run the provided script to set up and begin monitoring instantly.

### How It Works
- Automatically detects the USB mount point and copies the PRISM folder to a designated location on your system.
- Executes all tasks, including:
  - Webcam capture.
  - Screenshot capture.
  - Key logging and decoding.
  - Sending email notifications.

### Prerequisites
- **Linux OS** (Ubuntu/Debian recommended).
- **Postfix**: For sending email notifications.
- **fswebcam**: For webcam captures.
- **scrot**: For screenshots.
- **mutt**: For sending emails via terminal.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/PRISM.git
   cd PRISM
   ```

2. Transfer the shell script and the `PRISM` folder to a USB drive.

3. Insert the USB into the system and navigate to its mount point in the terminal.

4. Run the script:
   ```bash
   bash usb-auto-script.sh
   ```

### Example Run
The USB automation script will:
- Copy all necessary files from the USB to the system.
- Execute the monitoring scripts and save logs, screenshots, and snapshots.
- Send email alerts once all tasks are complete.
