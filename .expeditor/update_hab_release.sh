#!/bin/bash
#
# Updates the Habitat version everywhere in this cookbook so it works with new
# versions of Habitat.
#
set -evx

if [[ -z $EXPEDITOR_VERSION ]]; then
  echo "ERROR: Version undefined, cannot continue, exiting"
  exit 1
fi

branch="expeditor/${EXPEDITOR_VERSION}"
git checkout -b ${branch}

sed -i "s/%r{^hab .*\/}/%r{^hab ${EXPEDITOR_VERSION}\/}/" test/integration/config/default_spec.rb
sed -i "s/%r{^hab .*\/}/%r{^hab ${EXPEDITOR_VERSION}\/}/" test/integration/package/default_spec.rb
sed -i "s/%r{^hab .*\/}/%r{^hab ${EXPEDITOR_VERSION}\/}/" test/integration/user-toml/default_spec.rb
sed -i "s/HAB_VERSION = '.*'.freeze/HAB_VERSION = '${EXPEDITOR_VERSION}'.freeze/" libraries/habitat_shared.rb
sed -i "s/^- Habitat version: .*/- Habitat version: ${EXPEDITOR_VERSION}/" README.md
sed -i "s/^version '.*'/version '${EXPEDITOR_VERSION}'/" metadata.rb

echo "${EXPEDITOR_VERSION}" > VERSION

git add .
git commit --message "Update to habitat $EXPEDITOR_VERSION" --message "This pull request was triggered automatically via Expeditor when Habitat $EXPEDITOR_VERSION was promoted to stable." --message "This change falls under the obvious fix policy so no Developer Certificate of Origin (DCO) sign-off is required."

. /helper_functions.sh
open_pull_request

git checkout -
git branch -D ${branch}
