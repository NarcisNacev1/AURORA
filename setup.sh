#!/bin/bash

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo -e "${GREEN}Starting PRISM setup...${NC}"

# Step 1: Check for required tools
echo "Checking for required tools..."
REQUIRED_TOOLS=("mailutils" "fswebcam" "scrot")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${RED}Error: $tool is not installed.${NC}"
        echo "Installing $tool..."
        sudo apt-get install -y $tool
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Failed to install $tool. Please install it manually.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}$tool is already installed.${NC}"
    fi
done

# Step 2: Set permissions for scripts
echo "Setting permissions for scripts..."
chmod +x camera.sh
chmod +x screenshot.sh
chmod +x notifications/emailer.sh

# Step 3: Create required directories
echo "Creating necessary directories..."
DIRECTORIES=("logs/captures" "logs/system_logs" "logs/web_logs" "notifications" "capture")
for dir in "${DIRECTORIES[@]}"; do
    if [[ ! -d $dir ]]; then
        mkdir -p $dir
        echo -e "${GREEN}Created $dir.${NC}"
    else
        echo -e "${GREEN}$dir already exists.${NC}"
    fi
done

# Step 4: Set up .env file
if [[ ! -f ".env" ]]; then
    echo "Creating .env file from template..."
    cat > .env <<EOL
# Example .env file for PRISM
EMAIL_USER=your_email@example.com
EMAIL_PASS=your_password
SMTP_SERVER=smtp.example.com
SMTP_PORT=587
EOL
    echo -e "${GREEN}.env file created. Please update it with your configuration.${NC}"
else
    echo -e "${GREEN}.env file already exists.${NC}"
fi

# Final message
echo -e "${GREEN}PRISM setup completed successfully.${NC}"
echo "You can now run the scripts in this project. Don't forget to configure your .env file!"
