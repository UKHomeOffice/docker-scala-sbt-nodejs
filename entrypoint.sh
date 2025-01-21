#!/bin/bash

# Set ACP Artifactory as the proxy for dependency resolution
mkdir -p /app/.ivy2
echo -en "realm=Artifactory Realm\nhost=artifactory.digital.homeoffice.gov.uk\nuser=$ARTIFACTORY_USERNAME\npassword=$ARTIFACTORY_PASSWORD" > /app/.ivy2/.credentials
#export SBT_CREDENTIALS="/app/.ivy2/.credentials"
#export SBT_OPTS="-Dsbt.override.build.repos=true"

exec "$@"
