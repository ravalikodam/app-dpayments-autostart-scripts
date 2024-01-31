
#!/bin/bash

# Define the Queue Manager name
QUEUE_MANAGER_NAME="NPPCCGWI1"

# Email addresses to notify
EMAIL_RECIPIENTS="npp-test-team@cuscal.com.au npp-dev@cuscal.com.au"

# Function to send email notification
send_email_notification() {
    local subject="Queue Manager Failure Alert"
    local body="Failed to start Queue Manager $QUEUE_MANAGER_NAME."

    for recipient in $EMAIL_RECIPIENTS; do
        echo "$body" | mail -s "$subject" "$recipient"
    done
}

# Check if the Queue Manager is already running
if pgrep -x "strmqm" > /dev/null; then
    echo "Queue Manager $QUEUE_MANAGER_NAME is already running."
else
    # Start the Queue Manager
    strmqm "$QUEUE_MANAGER_NAME"
    if [ $? -eq 0 ]; then
        echo "Queue Manager $QUEUE_MANAGER_NAME has been started successfully."
    else
        echo "Failed to start Queue Manager $QUEUE_MANAGER_NAME."
        # Send email notification
        send_email_notification
    fi
fi
