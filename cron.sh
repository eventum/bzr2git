#!/bin/sh
set -e

PROGRAM=eventum-sync
dir=$(dirname "$0")
cd "$dir"

lock=~/www/spool/eventum-sync.json

test -e $lock || exit 0

(
	flock -n 9 || { echo "$PROGRAM: locked"; exit 1; }

	# load deploy key to ssh agent that bzr/git can use
	eval `ssh-agent` >/dev/null
	ssh-add id_eventum 2>/dev/null
	trap "set -x; kill $SSH_AGENT_PID" 0 INT

	sh -x sync-repos.sh

	rm -f $lock
) 9<$lock
