BREW_LOCK="/tmp/brew.lock"
LOG_DIR="$HOME/.logs"
LOG_FILE="$LOG_DIR/.brew.log"

# Get the timestamp of the last run from the brew log (if it exists)
LAST_RUN_TIMESTAMP=$(grep -m 1 "Running brew update" "$LOG_FILE" | awk -F" > " '{print $1}' | tail -n 1)

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
  if [ ! -f "$BREW_LOCK" ]; then
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
      trap 'rm -f \"$BREW_LOCK\"' EXIT
      # Create the lock file to prevent multiple instances
      touch \"$BREW_LOCK\"
      # Log the steps with timestamp
      echo \"$timestamp > Running brew update\"
      brew update
      # Sync personal profile
      source ~/.zshify/profile.zsh
      echo \"$timestamp > Running brew upgrade\"
      brew upgrade
      echo \"$timestamp > Running brew cleanup\"
      brew cleanup --prune=1 -s
    " >>"$LOG_FILE" 2>&1 </dev/null &

    # Disown the background process so it doesn't block terminal
    disown
  else
    # If lock file exists, log that brew update is already running
    echo "$(date +"%Y-%m-%d %H:%M:%S") > Brew update is already running." >>"$LOG_FILE"
  fi
else
  # Ensure the log directory exists before writing
  mkdir -p "$LOG_DIR"

  # Log the message that 24 hours haven't passed yet
  echo "$(date +"%Y-%m-%d %H:%M:%S") > Brew update has already run in the last 24 hours." >>"$LOG_FILE"
fi
