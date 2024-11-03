#!/bin/bash

# Mostly constants
export h1="Content-Type: application/json"
export h2="Accept: application/json"
export WORKSPACE=`pwd`

# Get values from user or parameter store
# The following credentials can be stored in parameter store and retrieved dynamically 


export atomType="GATEWAY"
export atomName="LOCAL_LNX_GTW_DEV_01"
export INSTALL_DIR="/dev-gateway"

export service_user="boomiuser"
export service_group="boomigroup"


export accountName="Viseo"
export accountId="viseo-GKKV2Z"
export authToken="BOOMI_TOKEN.jean-marc.coupin@viseo.com:8bb5d5d1-d191-4f8d-a436-382f0ee8e5bb"

# Keys that can change
export VERBOSE="false" # Bash verbose output; set to true only for testing, will slow execution.
export SLEEP_TIMER=0.2 # Delays curl request to the platform to set the rate under 5 requests/second

# Derived keys
export baseURL=https://api.boomi.com/api/rest/v1/$accountId
