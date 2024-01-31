
#!/bin/bash

# Define the path to the service script
SERVICE_SCRIPT="/opt/SecureSpan/Gateway/runtime/bin/gateway.sh"

# Email addresses to notify
EMAIL_RECIPIENTS="npp-test-team@cuscal.com.au npp-dev@cuscal.com.au"

# Function to send an email alert
send_email_alert() {
    local subject="Service Failure Alert"
    local message="The service script ($SERVICE_SCRIPT) has failed to start."
    echo "$message" | mail -s "$subject" $EMAIL_RECIPIENTS
}

# Function to check if the service is running
is_service_running() {
    if pgrep -f "$SERVICE_SCRIPT" >/dev/null 2>&1; then
        return 0  # Service is running
    else
        return 1  # Service is not running
    fi
}

# Check if the service is already running
if is_service_running; then
    echo "Service is already running."
else
    # If the service is not running, start it
    echo "Starting the service..."
    "$SERVICE_SCRIPT" start
    if [ $? -eq 0 ]; then
        echo "Service started successfully."
    else
        echo "Failed to start the service."
        # Send an email alert when the script fails
        send_email_alert
        exit 1
    fi
fi

exit 0
