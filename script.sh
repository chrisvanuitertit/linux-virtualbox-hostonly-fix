#!/bin/bash

# Configuration - customize these variables as needed
ALLOWED_NETWORKS=(
    "192.168.0.0/16"
    "10.0.0.0/8"
    # Add more networks here in CIDR notation
    # "172.16.0.0/12"
)

VBOX_DIR="/etc/vbox"
CONFIG_FILE="$VBOX_DIR/networks.conf"

# Function to validate CIDR notation
validate_cidr() {
    local cidr_regex='^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$'
    if [[ ! $1 =~ $cidr_regex ]]; then
        return 1
    fi
    return 0
}

# Function to handle errors
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    error_exit "This script must be run as root (use sudo)."
fi

# Validate network entries
for network in "${ALLOWED_NETWORKS[@]}"; do
    if ! validate_cidr "$network"; then
        error_exit "Invalid CIDR notation: $network. Please use format like '192.168.0.0/16'"
    fi
done

# Create directory for VirtualBox configuration
echo "Creating $VBOX_DIR directory..."
if ! mkdir -p "$VBOX_DIR"; then
    error_exit "Failed to create $VBOX_DIR directory."
fi

# Prepare configuration content
CONFIG_CONTENT=""
for network in "${ALLOWED_NETWORKS[@]}"; do
    CONFIG_CONTENT+="* $network"$'\n'
done

# Create networks.conf file
echo "Configuring VirtualBox network permissions..."
if ! echo "$CONFIG_CONTENT" > "$CONFIG_FILE"; then
    error_exit "Failed to write to $CONFIG_FILE."
fi

# Verify the file was created
if [ ! -f "$CONFIG_FILE" ]; then
    error_exit "Configuration file was not created."
fi

# Set appropriate permissions
echo "Setting file permissions..."
if ! chmod 644 "$CONFIG_FILE"; then
    error_exit "Failed to set permissions on $CONFIG_FILE."
fi

# Confirm completion
echo -e "\nVirtualBox network configuration completed successfully."
echo "File created at $CONFIG_FILE with the following content:"
echo "----------------------------------------"
cat "$CONFIG_FILE"
echo "----------------------------------------"

exit 0