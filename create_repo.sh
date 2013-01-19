#!/bin/sh
set -e

dir=$(dirname "$0")
dir=$(cd "$dir"; pwd)

# checkout bazaar locally, to cut down network traffic if want to restart process
test -d eventum.bzr || bzr branch lp:eventum eventum.bzr

# live one
#bzr_upstream=lp:eventum
# test one
bzr_upstream=$dir/eventum.bzr

# Create repo
# mkdir, so it will fail if dir exists
mkdir bzr2git
cd bzr2git
git init

# Prepare for bzr
install -d .git/bzr/{map,repo}
bzr init-repo --no-trees .git/bzr/repo
bzr branch $bzr_upstream .git/bzr/repo/master

# Fast-export the bzr repo
#--authors-file=authors
bzr fast-export --plain --export-marks=.git/bzr/map/master-bzr --git-branch=bzr/master .git/bzr/repo/master > bzr-fast-export

# Import into git
git fast-import --quiet --export-marks=.git/bzr/map/master-git < bzr-fast-export
#rm -f bzr-fast-export
git branch master bzr/master
git config bzr.master.bzr bzr/master
git config bzr.bzr/master.upstream $bzr_upstream
#git checkout master

git bzr sync
#git remote add github git@github.com:petterl/eventum.git
#git push github master
