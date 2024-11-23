# PRISM – Personalized Real-time Information System Monitor

## Overview

PRISM is a comprehensive Linux-based system monitor designed to track system health, capture system snapshots, monitor web activity, and send notifications. It provides an automated way to ensure that system data and web usage are logged and monitored, along with taking periodic screenshots and camera snapshots. Email notifications are sent when anomalies are detected, ensuring that the user is always informed.

### Features
- **System Diagnostics & Health Monitoring**: Real-time monitoring of CPU, memory, and disk usage.
- **Web Activity Monitoring**: Tracks and logs URLs visited and time spent on websites.
- **Screenshot & Webcam Capture**: Periodic screenshots and webcam snapshots of the system.
- **Email Notifications**: Sends alerts when issues are detected or captures are made.

## Requirements
- Linux operating system (Ubuntu/Debian preferred)
- **Postfix** for email notifications
- **fswebcam** for capturing webcam photos
- **scrot** for capturing screenshots
- **mutt** for sending emails

## Installation
1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/PRISM.git
   cd PRISM
