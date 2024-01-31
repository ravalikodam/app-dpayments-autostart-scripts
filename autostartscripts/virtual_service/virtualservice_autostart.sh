
#!/bin/bash

# Email addresses to notify when the script fails
EMAIL_LIST="npp-test-team@cuscal.com.au npp-dev@cuscal.com.au"

# Function to send an email
send_email() {
    local recipients="$1"
    local subject="$2"
    local message="$3"
    echo "$message" | mail -s "$subject" "$recipients"
}

# Function to check and start a service
check_and_start_service() {
    local service_dir="$1"
    local service_name="$2"

    cd "$service_dir" || exit 1
    if ./"$service_name" status; then
        echo "Service $service_name is already running."
    else
        echo "Starting service $service_name..."
        if ./"$service_name" start; then
            sleep 5 # Wait for a few seconds to allow the service to start
            if ./"$service_name" status; then
                echo "Service $service_name started successfully."
            else
                echo "Failed to start service $service_name."
                send_email "$EMAIL_LIST" "Service $service_name Failed" "Failed to start service $service_name on host $(hostname)."
            fi
        else
            echo "Failed to start service $service_name."
            send_email "$EMAIL_LIST" "Service $service_name Failed" "Failed to start service $service_name on host $(hostname)."
        fi
    fi
}

# Define the service directories and service names
services=(
    "/opt/CA/DevTest/IdentityAccessManager/bin IdentityAccessManagerService"
    "/opt/CA/DevTest/bin EnterpriseDashboardService"
    "/opt/CA/DevTest/bin RegistryService"
    "/opt/CA/DevTest/bin PortalService"
    "/opt/CA/DevTest/bin SimulatorService"
    "/opt/CA/DevTest/bin CoordinatorService"
    "/opt/CA/DevTest/bin VirtualServiceEnvironmentService"
)

# Loop through the services and start them
for service in "${services[@]}"; do
    read -r service_dir service_name <<< "$service"
    check_and_start_service "$service_dir" "$service_name"
done

echo "All services checked and started."
