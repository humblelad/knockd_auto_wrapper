#!/bin/bash

# Check if the script is running as root.
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as the root user." 
    exit 1
fi
# Check if knockd is installed, and install it if it's not.
if ! which knockd >/dev/null 2>&1; then
    echo "installing"
    sudo apt-get update
    sudo apt-get install knockd -y
fi
   echo "its installed"
# Remove the existing content of /etc/knockd.conf.
sudo rm /etc/knockd.conf

# Take user input for sequence values.
read -p "Enter sequence values (comma-separated, e.g., 7000,8000,9000): " sequence

# Take user input for port number.
read -p "Enter the port number (e.g., 22 for SSH): " port

# Take user input for cmd_timeout.
read -p "Enter cmd_timeout seconds value: " cmd_timeout

# Create a new knockd.conf with the provided settings.
cat <<EOL | sudo tee /etc/knockd.conf
[options]
UseSyslog

[instructions]
sequence    = $sequence
seq_timeout = 5
start_command = /sbin/iptables -A INPUT -s %IP% -p tcp --dport $port -j ACCEPT
tcpflags    = syn
cmd_timeout = $cmd_timeout
stop_command = /sbin/iptables -D INPUT -s %IP% -p tcp --dport $port -j ACCEPT
EOL

echo "knockd configuration has been updated in /etc/knockd.conf"
echo "Feedbacks @ github.com/humblelad"
sudo rm /etc/default/knockd
# Take interface
read -p "Enter interface (ifconfig): " interface
cat <<EOL | sudo tee /etc/default/knockd
START_KNOCKD=1
KNOCKD_OPTS="-i $interface"
EOL

sudo systemctl restart knockd
