#!/bin/bash

# 1. Check if an argument (directory) was provided
if [ -z "$1" ]; then
    echo "Error: No log directory provided."
    echo "Usage: $0 <log-directory>"
    exit 1
fi

LOG_DIR="$1"

# 2. Check if the provided directory actually exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' does not exist."
    exit 1
fi

# 3. Define the destination directory for archives
ARCHIVE_DIR="./archived_logs"
mkdir -p "$ARCHIVE_DIR"

# 4. Generate the timestamp and file name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
# Extract the base name of the directory (e.g., 'log' from '/var/log')
DIR_NAME=$(basename "$LOG_DIR")
ARCHIVE_NAME="${DIR_NAME}_archive_${TIMESTAMP}.tar.gz"

# 5. Compress the logs
echo "Archiving logs from $LOG_DIR..."
tar -czf "$ARCHIVE_DIR/$ARCHIVE_NAME" -C "$(dirname "$LOG_DIR")" "$DIR_NAME"

# 6. Check if compression was successful and log it
if [ $? -eq 0 ]; then
    echo "Success: Archive created at $ARCHIVE_DIR/$ARCHIVE_NAME"
    
    # Log the date, time, and file name to a manifest file
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Archived $LOG_DIR to $ARCHIVE_NAME" >> "$ARCHIVE_DIR/archive_log.txt"
else
    echo "Error: Failed to create archive."
    exit 1
fi
