#!/bin/bash

# Source the exports file to get variable definitions
# source ./exports.sh

# Delete the user (this will fail if the user doesn't exist)
userdel "$service_user"
echo "Service user '$service_user' deleted (if it existed)."

# Delete the group (this will fail if the group doesn't exist or is still in use)
groupdel "$service_group"
echo "Service group '$service_group' deleted (if it existed and was not in use)."
