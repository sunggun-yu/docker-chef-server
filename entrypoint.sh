#!/bin/bash

set -x

# For Postgres performance
sysctl -w kernel.shmmax=17179869184

# Start this so that `chef-server-ctl` sv-related commands can interact with its services via runsv
/opt/opscode/embedded/bin/runsvdir-start &

# Run all of the services
chef-server-ctl reconfigure

## Do initial installation and configuration
if [ ! -f /var/opt/chef-server/.configured ]; then

    # Create a default admin user
    chef-server-ctl user-create admin admin admin admin@example.com 'admin123' --filename /var/opt/chef-server/admin.pem

    # Create a default group
    chef-server-ctl org-create default 'Default' --association_user admin --filename /var/opt/chef-server/default-validator.pem

    # Install Chef Manage
    chef-server-ctl install chef-manage

    # Install Reporting
    chef-server-ctl install opscode-reporting

    # Reconfigure Chef Server
    chef-server-ctl reconfigure

    # Touch flag file that is indicating initial chef server configuration has been done
    date > /var/opt/chef-server/.configured
fi

# Start this so that `chef-manage-ctl` sv-related commands can interact with its services via runsv
/opt/chef-manage/embedded/bin/runsvdir-start &

# Reconfigure and start all the service for Chef Manage
chef-manage-ctl reconfigure --accept-license

# Start this so that `opscode-reporting-ctl` sv-related commands can interact with its services via runsv
/opt/opscode-reporting/embedded/bin/runsvdir-start &

# Reconfigure and start all the service for Reporting
opscode-reporting-ctl reconfigure --accept-license

tail -F /var/log/opscode/*/current

exec "$@"
