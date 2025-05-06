
# Linux VirtualBox Host-Only Network Configuration Script

This script creates the necessary configuration file to manage VirtualBox host-only adapter networks. By default, VirtualBox doesn't create the /etc/vbox/networks.conf file on Linux, which restricts the ability to modify host-only adapter network settings.

## Prerequisites

- VirtualBox installed (Linux)
- sudo/root access
- Bash shell

## Features

- Creates the required directory structure (/etc/vbox)
- Generates the networks.conf configuration file
- Allows customization of permitted networks through easy-to-edit variable
- Includes proper error handling and input validation
- Sets correct file permissions automatically
## Deployment
Edit these variables at the top of the script to customize allowed networks:
```bash
  ALLOWED_NETWORKS=(
      "192.168.0.0/16"
      "10.0.0.0/24"
      # Add more networks as needed:
      # "172.16.0.0/12"
)
```
Make the script executable:
```bash
  chmod +x virtualbox.sh
```
Run the script with root privileges:
```bash
  sudo ./virtualbox.sh
```
Alternatively, run directly with bash:
```bash
  sudo bash virtualbox.sh
```
After successful execution, you should see:
```bash
└──╼ $sudo ./virtualbox.sh
Creating /etc/vbox directory...
Configuring VirtualBox network permissions...
Setting file permissions...

VirtualBox network configuration completed successfully.
File created at /etc/vbox/networks.conf with the following content:
----------------------------------------
* 192.168.0.0/16
* 10.0.0.0/8
----------------------------------------
```
## Authors

- [@chrisvanuitert](https://www.github.com/chrisvanuitertit)

