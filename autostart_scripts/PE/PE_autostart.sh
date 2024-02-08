
#!/bin/bash

# Set the Queue Manager and Node names
QUEUE_MANAGER="NPPPMTI1"
NODE_NAME="NPPPEXI1"
EMAIL_RECIPIENTS="npp-test-team@cuscal.com.au npp-dev@cuscal.com.au"

# Function to check the Queue Manager status
check_queue_manager_status() {
    echo "Checking Queue Manager status..."
    dspmq -m "$QUEUE_MANAGER"
}

# Function to check the Node status
check_node_status() {
    echo "Checking Node status..."
    mqsilist
}

# Function to start the Queue Manager
start_queue_manager() {
    echo "Starting Queue Manager: $QUEUE_MANAGER"
    strmqm "$QUEUE_MANAGER"
    if [ $? -ne 0 ]; then
        send_email_alert "Failed to start Queue Manager: $QUEUE_MANAGER"
    fi
}

# Function to start the Node
start_node() {
    echo "Starting Node: $NODE_NAME"
    mqsistart "$NODE_NAME"
    if [ $? -ne 0 ]; then
        send_email_alert "Failed to start Node: $NODE_NAME"
    fi
}

# Function to send email alert
send_email_alert() {
    local subject="Script Failure Alert"
    local body="$1"
    echo "$body" | mail -s "$subject" $EMAIL_RECIPIENTS
    echo "Email alert sent: $body"
}

# Main script execution
echo "Queue Manager: $QUEUE_MANAGER"
echo "Node Name: $NODE_NAME"

check_queue_manager_status
check_node_status
start_queue_manager
start_node

echo "Script completed."
