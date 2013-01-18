#!/bin/sh
REPOBASE=$(dirname "$0")
REPOBASE=$(cd "$REPOBASE"; pwd)

for REPO in eventum; do
	cd $REPOBASE/$REPO/
	echo "Syncing $REPO repository from launchpad.."
	git bzr pull
	echo "Pushing $REPO repository to github.."
	git push github master
done
