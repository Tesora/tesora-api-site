#!/bin/bash -xe
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

PUBLISH=$1

if [[ -z "$PUBLISH" ]] ; then
    echo "usage $0 (build|publish)"
    exit 1
fi

mkdir -p publish-docs

# Build the www pages so that openstack-doc-test creates a link to
# www/www-index.html.
if [ "$PUBLISH" = "build" ] ; then
    python tools/www-generator.py --source-directory www/ \
        --output-directory publish-docs/www/
    rsync -a www/static/ publish-docs/www/
    # publish-docs/www-index.html is the trigger for openstack-doc-test
    # to include the file.
    mv publish-docs/www/www-index.html publish-docs/www-index.html
fi
if [ "$PUBLISH" = "publish" ] ; then

    # Publication happens from publish-docs/api-ref to
    # developer.openstack.org, so move content around
    mkdir -p publish-docs/api-ref/
    python tools/www-generator.py --source-directory www/ \
        --output-directory publish-docs/api-ref/
    rsync -a www/static/ publish-docs/api-ref/
    # Don't publish this file
    rm publish-docs/api-ref/www-index.html
fi
