#!/bin/bash

# Set ACP Artifactory as the proxy for dependency resolution
mkdir -p /root/.ivy2
echo -en "realm=Artifactory Realm\nhost=artifactory.digital.homeoffice.gov.uk\nuser=$ARTIFACTORY_USERNAME\npassword=$ARTIFACTORY_PASSWORD" > /root/.ivy2/.credentials

exec "$@"
