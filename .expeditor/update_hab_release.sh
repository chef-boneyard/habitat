#!/bin/sh
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
sed -i "s/HAB_VERSION = '.*'.freeze/HAB_VERSION = '${VERSION}'.freeze/" resources/install.rb
sed -i "s/^- Habitat version: .*/- Habitat version: ${VERSION}/" README.md
sed -i "s/^version '.*'/version '${VERSION}'/" metadata.rb

echo "${VERSION}" > VERSION

git add .
git commit -m "update to habitat $VERSION"

open_pull_request

git checkout -
git branch -D ${branch}
