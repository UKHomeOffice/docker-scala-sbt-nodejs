#!/bin/bash

# Set ACP Artifactory as the proxy for dependency resolution
mkdir -p /app/.ivy2
echo -en "realm=Artifactory Realm\nhost=artifactory.digital.homeoffice.gov.uk\nuser=$ARTIFACTORY_USERNAME\npassword=$ARTIFACTORY_PASSWORD" > /app/.ivy2/.credentials

exec "$@"
