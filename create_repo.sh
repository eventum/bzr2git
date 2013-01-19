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

# TODO:
# - use bare repo: https://github.com/termie/git-bzr-ng/issues/52
# Create repo
# mkdir, so it will fail if dir exists
mkdir eventum.git
cd eventum.git
git init

# Prepare for bzr
install -d .git/bzr/{map,repo}
bzr init-repo --no-trees .git/bzr/repo
bzr branch $bzr_upstream .git/bzr/repo/master

# Fast-export the bzr repo
test -s $dir/bzr-fast-export.raw || \
bzr fast-export --plain --export-marks=.git/bzr/map/master-bzr --git-branch=bzr/master .git/bzr/repo/master \
	> $dir/bzr-fast-export.raw

test -s $dir/bzr-fast-export || \
	bzr fast-import-filter --user-map=$dir/authors > $dir/bzr-fast-export < $dir/bzr-fast-export.raw

# Import into git
git fast-import --export-marks=.git/bzr/map/master-git < $dir/bzr-fast-export
rm -f $dir/bzr-fast-export*
git branch master bzr/master
git config bzr.master.bzr bzr/master
git config bzr.bzr/master.upstream $bzr_upstream

# make some space
# 115MiB -> 36MiB
git gc --prune=now --aggressive
#git gc --aggressive
git repack -a -d -f -F --window=250 --depth=250

git bzr sync
#git remote add github git@github.com:petterl/eventum.git
#git push github master
