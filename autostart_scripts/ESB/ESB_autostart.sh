
#!/bin/bash

# Define the queue managers and nodes
QUEUE_MANAGERS=("CUSESBQMU1" "QMNRQ1")
NODES=("CUSESBINU1" "MBNRQ1")

# Email addresses to send alerts to
EMAIL_ADDRESSES=("npp-test-team@cuscal.com.au" "npp-dev@cuscal.com.au")

# Function to check the status of a queue manager
check_queue_manager_status() {
    for qm in "${QUEUE_MANAGERS[@]}"; do
        echo "Checking status of Queue Manager '$qm'"
        dspmq -m "$qm"
    done
}

# Function to check the status of a node
check_node_status() {
    for node in "${NODES[@]}"; do
        echo "Checking status of Integration Node '$node'"
        mqsilist "$node"
    done
}

# Function to start a queue manager
start_queue_manager1() {
    local qm_name="CUSESBQMU1"
    echo "Starting Queue Manager '$qm_name'"
    strmqm "$qm_name" || send_alert "Failed to start Queue Manager '$qm_name'"
}

# Function to start a node
start_node1() {
    local node_name="CUSESBINU1"
    echo "Starting Integration Node '$node_name'"
    mqsistart "$node_name" || send_alert "Failed to start Integration Node '$node_name'"
}

# Function to start a queue manager
start_queue_manager2() {
    local qm_name="QMNRQ1"
    echo "Starting Queue Manager '$qm_name'"
    strmqm "$qm_name" || send_alert "Failed to start Queue Manager '$qm_name'"
}

# Function to start a node
start_node2() {
    local node_name="MBNRQ1"
    echo "Starting Integration Node '$node_name'"
    mqsistart "$node_name" || send_alert "Failed to start Integration Node '$node_name'"
}

# Function to send an email alert
send_alert() {
    local message="$1"
    for email in "${EMAIL_ADDRESSES[@]}"; do
        echo "$message" | mail -s "Script Alert" "$email"
    done
}

# Main script
check_queue_manager_status
check_node_status
start_queue_manager1
start_node1
start_queue_manager2
start_node2
