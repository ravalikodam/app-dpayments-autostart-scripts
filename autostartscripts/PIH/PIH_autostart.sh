
#!/bin/bash

# Email addresses
TO="npp-test-team@cuscal.com.au npp-dev@cuscal.com.au"
SUBJECT="Docker Script Failed"

# Check if Docker service is running
if service docker status > /dev/null; then
    echo "Docker service is already running."
else
    echo "Docker service is not running. Starting Docker..."
    sudo service docker start
    if [ $? -eq 0 ]; then
        echo "Docker service started successfully."
    else
        echo "Failed to start Docker service."

        # Send an email alert
        MESSAGE="Failed to start Docker service. Please investigate."
        echo "$MESSAGE" | mail -s "$SUBJECT" "$TO"

        exit 1
    fi
fi

# View active containers
echo "Active Docker Containers:"
docker ps

# Check all container statuses
echo "All Docker Containers:"
docker ps -a
