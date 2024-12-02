import os
import re
from glob import glob

# Define keycode-to-character mapping
key_mapping = {
    "KEY_ENTER": "\n",
    "KEY_LEFTALT": "[ALT]",
    "KEY_TAB": "\t",
    "KEY_BACKSPACE": "[BACKSPACE]",
    "KEY_SPACE": " ",
    "KEY_DOT": ".",
    "KEY_COMMA": ",",
    "KEY_A": "a", "KEY_B": "b", "KEY_C": "c", "KEY_D": "d", "KEY_E": "e",
    "KEY_F": "f", "KEY_G": "g", "KEY_H": "h", "KEY_I": "i", "KEY_J": "j",
    "KEY_K": "k", "KEY_L": "l", "KEY_M": "m", "KEY_N": "n", "KEY_O": "o",
    "KEY_P": "p", "KEY_Q": "q", "KEY_R": "r", "KEY_S": "s", "KEY_T": "t",
    "KEY_U": "u", "KEY_V": "v", "KEY_W": "w", "KEY_X": "x", "KEY_Y": "y",
    "KEY_Z": "z",
    "KEY_1": "1", "KEY_2": "2", "KEY_3": "3", "KEY_4": "4", "KEY_5": "5",
    "KEY_6": "6", "KEY_7": "7", "KEY_8": "8", "KEY_9": "9", "KEY_0": "0",
    "KEY_MINUS": "-", "KEY_EQUAL": "=", "KEY_LEFTBRACE": "[",
    "KEY_RIGHTBRACE": "]", "KEY_SEMICOLON": ";", "KEY_APOSTROPHE": "'",
    "KEY_GRAVE": "`", "KEY_BACKSLASH": "\\", "KEY_SLASH": "/",
    "KEY_CAPSLOCK": "[CAPSLOCK]", "KEY_LEFTSHIFT": "[SHIFT]",
    "KEY_RIGHTSHIFT": "[SHIFT]", "KEY_LEFTCTRL": "[CTRL]",
    "KEY_RIGHTCTRL": "[CTRL]", "KEY_LEFTMETA": "[META]",
    "KEY_RIGHTMETA": "[META]", "KEY_ESC": "[ESC]",
}

# Directory containing key log files
log_dir = "logs/key_logs"
output_dir = "logs/decrypted_key_logs"

# Ensure the output directory exists
os.makedirs(output_dir, exist_ok=True)

# Find the latest log file
log_files = glob(os.path.join(log_dir, "*.log"))
if not log_files:
    print(f"No log files found in {log_dir}.")
    exit()

latest_log_file = max(log_files, key=os.path.getctime)
print(f"Using latest log file: {latest_log_file}")

# Load the latest log file
try:
    with open(latest_log_file, "r") as f:
        logs = f.readlines()
except FileNotFoundError:
    print(f"Log file '{latest_log_file}' not found.")
    exit()

# Extract relevant key press events
key_presses = []
for line in logs:
    # Regex to match key press events
    match = re.search(r"type 1 \(EV_KEY\), code \d+ \((KEY_[A-Z0-9_]+)\), value 1", line)
    if match:
        key_code = match.group(1)
        key_presses.append(key_mapping.get(key_code, f"[UNKNOWN:{key_code}]"))

# Combine key presses into a readable format
result_text = "".join(key_presses)

# Save to a new file in logs/decrypted_key_logs
output_file = os.path.join(output_dir, "decoded_key_logs.txt")
with open(output_file, "w") as f:
    f.write(result_text)

print(f"Decoded key logs saved to {output_file}")
