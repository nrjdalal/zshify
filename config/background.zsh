LOCK_FILE="/tmp/background.lock"
LOG_DIR="$HOME/.logs"
LOG_FILE="$LOG_DIR/.brew.log"

# Get the timestamp of the last run from the log file
LAST_RUN_TIMESTAMP=$(grep -m 1 "ZSHIFY_BACKROUND_RUN" "$LOG_FILE" | awk -F" > " '{print $1}' | tail -n 1)

# Check if 24 hours have passed since the last run
if [ -z "$LAST_RUN_TIMESTAMP" ]; then
  # If no last run timestamp exists, we assume it's the first time running
  TIME_DIFF=86401 # Set time difference to more than 24 hours
else
  # Convert the timestamp to epoch time (seconds since 1970-01-01)
  LAST_RUN_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$LAST_RUN_TIMESTAMP" +%s)
  CURRENT_EPOCH=$(date +%s)

  # Calculate time difference in seconds
  TIME_DIFF=$((CURRENT_EPOCH - LAST_RUN_EPOCH))
fi

# If 24 hours have passed or it's the first run
if [ $TIME_DIFF -gt 86400 ]; then
  # Check if the lock file exists to avoid running multiple instances
  if [ ! -f "$LOCK_FILE" ]; then
    # Set options to suppress job control notifications
    setopt NO_MONITOR NO_NOTIFY

    # Create log directory if it doesn't exist
    mkdir -p "$LOG_DIR"

    # Delete log files older than 7 days
    find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec rm {} \;

    # Define the timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Run brew update, upgrade, and cleanup in the background
    nohup bash -c "
      # Trap to ensure the lock file is removed even if commands fail
      trap 'rm -f \"$LOCK_FILE\"' EXIT

      # Create the lock file to prevent multiple instances
      touch \"$LOCK_FILE\"

      # Log the start of the background tasks
      echo \"$timestamp ZSHIFY_BACKROUND_RUN\"

      # Sync personal profile for background tasks
      source ~/.zshify/profile.zsh
    " >>"$LOG_FILE" 2>&1 </dev/null &

    # Disown the background process so it doesn't block terminal
    disown
  else
    # If lock file exists, log that background tasks are already running
    echo "$(date +"%Y-%m-%d %H:%M:%S") > Background tasks are already running." >>"$LOG_FILE"
  fi
else
  # Ensure the log directory exists before writing
  mkdir -p "$LOG_DIR"

  # Log the message that 24 hours haven't passed yet
  echo "$(date +"%Y-%m-%d %H:%M:%S") > 24 hours haven't passed since the last run." >>"$LOG_FILE"
fi
