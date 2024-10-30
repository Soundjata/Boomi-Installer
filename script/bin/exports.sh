
#!/bin/bash

# Mostly constants
export h1="Content-Type: application/json"
export h2="Accept: application/json"
export WORKSPACE=`pwd`

# Get values from user or parameter store
# The following credentials can be stored in parameter store and retrieved dynamically 
# Example to retrieve form an AWS store "$(aws ssm get-parameter --region xx --with-decryption --output text --query Parameter.Value --name /Parameter.name)

export atomType="ATOM"
export atomName="LOCAL_LNX_ATM_DEV_01"
export INSTALL_DIR="./dev-atom"


export accountName="Viseo"
export accountId="viseo-GKKV2Z"
export authToken="BOOMI_TOKEN.jean-marc.coupin@viseo.com:8bb5d5d1-d191-4f8d-a436-382f0ee8e5bb"
export regressionTestAuthToken=""

# Keys that can change
export VERBOSE="false" # Bash verbose output; set to true only for testing, will slow execution.
export SLEEP_TIMER=0.2 # Delays curl request to the platform to set the rate under 5 requests/second

# Derived keys
export baseURL=https://api.boomi.com/api/rest/v1/$accountId
export regressionTestURL=https://connect.boomi.com/ws/simple # URL for regression test suite framework.
