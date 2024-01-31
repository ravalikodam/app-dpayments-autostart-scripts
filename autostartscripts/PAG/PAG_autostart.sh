
#!/bin/bash

# Function to check and start a service
check_and_start_service() {
  local service_name="$1"
  local service_path="$2"
  local check_command="$3"
  local start_command="$4"

  echo "Checking $service_name status..."
  if [ "$($service_path/$check_command)" == "running" ]; then
    echo "$service_name is already running."
  else
    echo "Starting $service_name..."
    $service_path/$start_command
    sleep 2  # Give some time for the service to start
    if [ "$($service_path/$check_command)" == "running" ]; then
      echo "$service_name is now running."
    else
      echo "Failed to start $service_name."
    fi
  fi
}

# Emulator
emulator_name="Emulator"
emulator_path="/opt/swift/emu/bin"
emulator_check_command="emu getstatus"
emulator_start_command="emu start"

# PAG
pag_name="PAG"
pag_path="/opt/swift/pag/bin"
pag_check_command="pag getstatus"
pag_start_command="pag start"

# Check and start services
check_and_start_service "$emulator_name" "$emulator_path" "$emulator_check_command" "$emulator_start_command"
check_and_start_service "$pag_name" "$pag_path" "$pag_check_command" "$pag_start_command"
