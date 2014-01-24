#!/bin/sh
set -e

dir=$(dirname "$0")
dir=$(cd "$dir"; pwd)

# pull bzr and git changes
cd $dir/eventum.bzr
bzr pull

cd $dir/eventum.git
git pull

# first pull bzr->git
git bzr pull
# then push git->bzr
git bzr push || :

# and distribute changes
git push origin master
git push --tags
cd $dir/eventum.bzr
bzr push
