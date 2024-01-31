
#!/bin/bash

# Set the path to your Tomcat installation
TOMCAT_HOME="/opt/apache-tomcat-8.5.9"

# Change this variable to the username that owns the Tomcat process (e.g., the user who installed Tomcat)
TOMCAT_USER="tomcat"

# Email addresses to notify in case of failure
EMAIL_TO="npp-test-team@cuscal.com.au npp-dev@cuscal.com.au"

# Function to send an email alert
function send_email {
  local subject="Tomcat Alert"
  local message="Tomcat is not running. Attempting to start it."
  echo "$message" | mail -s "$subject" $EMAIL_TO
}

# Function to start Tomcat
function start_tomcat {
  echo "Starting Tomcat..."
  sudo -u $TOMCAT_USER "${TOMCAT_HOME}/bin/startup.sh"
}

# Function to check if Tomcat is running
function is_tomcat_running {
  ps -ef | grep tomcat  > /dev/null
}

# Check if the script is being run as the correct user
if [ "$(whoami)" != "$TOMCAT_USER" ]; then
  echo "This script must be run as $TOMCAT_USER"
  exit 1
fi

# Check if Tomcat is already running
if is_tomcat_running; then
  echo "Tomcat is already running."
else
  # Start Tomcat if it's not running
  start_tomcat
  # Check if Tomcat started successfully
  if is_tomcat_running; then
    echo "Tomcat has been started."
  else
    echo "Failed to start Tomcat. Sending email alert."
    send_email
  fi
fi
