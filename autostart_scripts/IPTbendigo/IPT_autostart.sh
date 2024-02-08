
#!/bin/bash

# Define the path to the service executable
SERVICE_EXEC="/opt/tools/mqipt/bin/mqipt"

# Function to check if the service is running
is_service_running() {
    # Use 'pgrep' to check if the service is running
    pgrep -f "$SERVICE_EXEC" >/dev/null 2>&1
}

# Email recipients
EMAIL_RECIPIENTS="npp-test-team@cuscal.com.au npp-dev@cuscal.com.au"

# Function to send an email alert
send_email_alert() {
    local subject="Service Failed: $SERVICE_EXEC"
    local message="The service $SERVICE_EXEC has failed to start or is not running."
    echo "$message" | mail -s "$subject" $EMAIL_RECIPIENTS
}

# Start the service if it's not running
if ! is_service_running; then
    echo "Service is not running. Starting it..."
    nohup "$SERVICE_EXEC" /opt/tools/mqipt >/dev/null 2>&1 &
    sleep 2 # Sleep for a few seconds to allow the service to start
    if is_service_running; then
        echo "Service started successfully."
    else
        echo "Failed to start the service."
        # Send an email alert
        send_email_alert
    fi
else
    echo "Service is already running."
fi
