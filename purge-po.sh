#!/bin/sh

#git clone file://`pwd`/eventum.git po2.git
#cd po2.git

#git filter-branch --subdirectory-filter localization -- --all
#


#localization/*.po
#eventum/misc/localization/*.po
#misc/localization/*.po


git filter-branch --index-filter '
	git rm --cached --ignore-unmatch \
		localization/*.po \
		eventum/misc/localization/*.po \
		misc/localization/*.po \
		localization/*.mo \
		eventum/misc/localization/*.mo \
		misc/localization/*.mo \
' -- --all

git for-each-ref --format="%(refname)" refs/original/ | xargs -r -n 1 git update-ref -d
git for-each-ref --format="%(refname)" refs/tags | xargs -r -n 1 git update-ref -d

git gc --aggressive --prune=now
