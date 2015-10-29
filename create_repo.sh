#!/bin/sh
set -e

die() {
	echo >&2 "$*"
	exit 1
}

git --version >/dev/null || die "git not present"
bzr --version >/dev/null || die "bzr-fastimport not present"
bzr fast-export --usage >/dev/null 2>&1 || die "bzr-fastimport not present"

dir=$(dirname "$0")
dir=$(cd "$dir"; pwd)

# checkout bazaar locally, to cut down network traffic if want to restart process
test -d eventum.bzr || bzr branch lp:eventum eventum.bzr

bzr_upstream=$dir/eventum.bzr

# TODO:
# - use bare repo: https://github.com/termie/git-bzr-ng/issues/52
# Create repo
# mkdir, so it will fail if dir exists
install -d eventum.git
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

# checkout master, otherwise first merge will get confused
git checkout master

commits=$(git rev-list --all | wc -l)
du -sh .git

# make some space
# 125MiB -> 39MiB

# git gc may lose some loose refs that bzr2git needs
# avoid this at any cost for sake of slightly bigger repo
git config gc.auto 0
git gc --no-prune --aggressive
git repack -a -d -f -F --window=250 --depth=250

c=$(git rev-list --all | wc -l)
if [ "$commits" != "$c" ]; then
	echo >&2 "ERROR: commits changed from $commits to $c"
	exit 1
fi

du -sh .git

git remote add origin git@github.com:eventum/eventum.git
