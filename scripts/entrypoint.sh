#!/bin/bash

set -x

# For Postgres performance
sysctl -w kernel.shmmax=17179869184

# Disable IPv6
sysctl net.ipv6.conf.lo.disable_ipv6=0

# Start this so that `chef-server-ctl` sv-related commands can interact with its services via runsv
# Reconfigure and start all the service for Chef Server
(/opt/opscode/embedded/bin/runsvdir-start &) && chef-server-ctl reconfigure

# Start this so that `chef-manage-ctl` sv-related commands can interact with its services via runsv
# Reconfigure and start all the service for Chef Manage
(/opt/chef-manage/embedded/bin/runsvdir-start &) && chef-manage-ctl reconfigure --accept-license

# Start this so that `opscode-reporting-ctl` sv-related commands can interact with its services via runsv
# Reconfigure and start all the service for Reporting
(/opt/opscode-reporting/embedded/bin/runsvdir-start &) && opscode-reporting-ctl reconfigure --accept-license

## Create initial admin user if it is not existing
if [[ $(chef-server-ctl user-list) =~ 'admin' ]]; then
    echo "admin user is existing."
else
    # Create a default admin user
    chef-server-ctl user-create admin admin admin admin@example.com 'admin123' --filename /etc/opscode/admin.pem

    # Reconfigure Chef Server
    chef-server-ctl reconfigure
fi

# Install postfix for email notification
if [[ $(dpkg-query -l | grep postfix | wc -l) < 1 ]]; then
    apt-get update
    chmod +x /install_postfix.sh
    /install_postfix.sh
    rm -rf /var/lib/apt/lists/*
fi

# Restart the postfix service
service postfix restart

chef-server-ctl tail

exec "$@"
