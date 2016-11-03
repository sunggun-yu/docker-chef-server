#!/bin/bash

set -x

sysctl -w kernel.shmmax=17179869184

# Start this so that chef-server-ctl sv-related commands can interact with its services via runsv
/opt/opscode/embedded/bin/runsvdir-start &

# Run all of the services
chef-server-ctl reconfigure

## Do initial installation and configuration
if [ ! -f /var/opt/chef-server/.configured ]; then

    # Create a default admin user
    chef-server-ctl user-create admin FIRST_NAME LAST_NAME admin@example.com 'admin123' --filename /var/opt/chef-server/admin.pem

    # Touch flag file that is indicating initial chef server configuration has been done
    echo "configured" > /var/opt/chef-server/.configured
fi

tail -F /var/log/opscode/*/current

exec "$@"
