#!/bin/bash
#
# Updates the Habitat version everywhere in this cookbook so it works with new
# versions of Habitat.
#
set -evx

if [[ -z $VERSION ]]; then
  echo "ERROR: Version undefined, cannot continue, exiting"
  exit 1
fi

branch="expeditor/${VERSION}"
git checkout -b ${branch}

sed -i "s/%r{^hab .*\/}/%r{^hab ${VERSION}\/}/" test/integration/config/default_spec.rb
sed -i "s/%r{^hab .*\/}/%r{^hab ${VERSION}\/}/" test/integration/package/default_spec.rb
sed -i "s/%r{^hab .*\/}/%r{^hab ${VERSION}\/}/" test/integration/user-toml/default_spec.rb
sed -i "s/HAB_VERSION = '.*'.freeze/HAB_VERSION = '${VERSION}'.freeze/" libraries/habitat_shared.rb
sed -i "s/^- Habitat version: .*/- Habitat version: ${VERSION}/" README.md
sed -i "s/^version '.*'/version '${VERSION}'/" metadata.rb

echo "${VERSION}" > VERSION

git add .
git commit --message "Update to habitat $VERSION" --message "This pull request was triggered automatically via Expeditor when Habitat $VERSION was promoted to stable." --message "This change falls under the obvious fix policy so no Developer Certificate of Origin (DCO) sign-off is required."

. /helper_functions.sh
open_pull_request

git checkout -
git branch -D ${branch}
