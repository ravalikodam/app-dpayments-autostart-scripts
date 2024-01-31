
#!/bin/bash

# Define the Queue Manager name
QUEUE_MANAGER_NAME="NPPPAGI3"

# Define the recipient email addresses
EMAIL_RECIPIENTS="npp-test-team@cuscal.com.au npp-dev@cuscal.com.au"

# Function to send an email
send_email() {
    local subject="$1"
    local message="$2"
    local recipients="$3"

    echo "$message" | mail -s "$subject" $recipients
}

# Check if the Queue Manager is already running
if pgrep -x "strmqm" > /dev/null; then
    echo "Queue Manager $QUEUE_MANAGER_NAME is already running."
else
    # Start the Queue Manager
    strmqm $QUEUE_MANAGER_NAME
    if [ $? -eq 0 ]; then
        echo "Queue Manager $QUEUE_MANAGER_NAME has been started successfully."
    else
        error_message="Failed to start Queue Manager $QUEUE_MANAGER_NAME."
        echo "$error_message"

        # Send an email alert
        subject="Queue Manager Start Failure"
        send_email "$subject" "$error_message" "$EMAIL_RECIPIENTS"
    fi
fi
