#!/bin/zsh

INTERVAL=86400      # Time interval for running the background task
LOG_INTERVAL=604800 # Log entries older than this (in seconds) will be removed
LOCK_FILE="/tmp/background.lock"
LOG_DIR="$HOME/.logs"
LOG_FILE="$LOG_DIR/.brewlog"

mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

brewlog() {
  if [ -z "$1" ]; then
    cat "$LOG_FILE"
  elif [ "$1" = "code" ]; then
    code "$LOG_FILE"
  elif [ "$1" = "clear" ]; then
    echo "" >"$LOG_FILE"
  fi
}

# Get the timestamp of the last run from the log file
LAST_RUN_TIMESTAMP=$(grep -m 1 "ZSHIFY_BACKROUND_RUN" "$LOG_FILE" | awk -F" > " '{print $1}' | tail -n 1)

if [ -z "$LAST_RUN_TIMESTAMP" ]; then
  # No previous run timestamp
  TIME_DIFF=$((INTERVAL + 1))
else
  # Trim trailing spaces from the timestamp
  LAST_RUN_TIMESTAMP=$(echo "$LAST_RUN_TIMESTAMP" | sed 's/[[:space:]]*$//')

  # Check if timestamp has time (if not, append 00:00:00)
  if [[ "$LAST_RUN_TIMESTAMP" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    LAST_RUN_TIMESTAMP="$LAST_RUN_TIMESTAMP 00:00:00" # Adding default time
  fi

  # Convert timestamp to epoch (macOS-compatible)
  LAST_RUN_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$LAST_RUN_TIMESTAMP" +%s 2>/dev/null)

  if [ -z "$LAST_RUN_EPOCH" ]; then
    # If the conversion failed, fall back to a default timestamp (e.g., 1970-01-01)
    LAST_RUN_EPOCH=0
  fi

  TIME_DIFF=$(($(date +%s) - LAST_RUN_EPOCH))
fi

if [ $TIME_DIFF -gt $INTERVAL ]; then
  # Create a lock using `ln`
  if ln -s "$LOCK_FILE" "$LOCK_FILE.lock" 2>/dev/null; then
    # Set Zsh options to suppress job control notifications
    setopt NO_MONITOR NO_NOTIFY

    # Delete logs older than the log interval
    find "$LOG_DIR" -type f -name "*.log" -exec zsh -c '
      for file; do
        # Get the modification time of the file in seconds since the epoch
        FILE_TIMESTAMP=$(stat -f %m "$file")
        CURRENT_EPOCH=$(date +%s)
        AGE=$((CURRENT_EPOCH - FILE_TIMESTAMP))

        # If the file is older than the LOG_INTERVAL, remove it
        if [ $AGE -gt "$LOG_INTERVAL" ]; then
          rm "$file"
        fi
      done
    ' _ {} +

    # Start the background task with nohup
    nohup zsh -c "
      trap 'rm -f \"$LOCK_FILE.lock\"' EXIT

      # Log the start time
      echo \"$(date +"%Y-%m-%d %H:%M:%S") > ZSHIFY_BACKROUND_RUN\" >> \"$LOG_FILE\"

      # Source profile
      source ~/.zshify/config/profile.zsh
    " >>"$LOG_FILE" 2>&1 </dev/null &

    # Detach the process
    disown

    # Unset the options after the background task is started
    unsetopt NO_MONITOR NO_NOTIFY
  else
    # If the lock exists, log that background tasks are already running
    echo "$(date +"%Y-%m-%d %H:%M:%S") > Background tasks are already running." >>"$LOG_FILE"
  fi
else
  # Log that the background task last ran within the time interval
  echo "$(date +"%Y-%m-%d %H:%M:%S") > Background task last ran within the time interval." >>"$LOG_FILE"
fi
