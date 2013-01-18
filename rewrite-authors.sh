#!/bin/sh

# Fixing the repo committers
# https://help.github.com/articles/changing-author-info
# to get list of authors to fix:
# $ git shortlog -sen

git filter-branch -f --env-filter '
	case "$GIT_AUTHOR_EMAIL:$GIT_AUTHOR_NAME" in
	*:"=?utf-8?q?Elan_Ruusam=C3=A4e?=" | \
	*:"Launchpad Translations on behalf of glen666" | \
	codehost@crowberry:"Launchpad Code Hosting" | \
	:glen | \
	glen@delfi.ee:glen | \
	_____ )
		export GIT_AUTHOR_NAME="Elan Ruusamäe"
		export GIT_AUTHOR_EMAIL="glen@delfi.ee"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	esac

	case "$GIT_AUTHOR_EMAIL:$GIT_AUTHOR_NAME" in
	:"mysql.com!bryan" | \
	:"balsdorf" | \
	:"jesushatesjava.com!bryan/balsdorf" | \
	:"jesushatesjava.com!balsdorf" | \
	:"!balsdorf" | \
	:"!bryan" | \
	bryan@achilles:"Bryan Alsdorf" | \
	bryan@montyprogram.com:"Bryan Alsdorf" | \
	_____ )
		export GIT_AUTHOR_NAME="Bryan Alsdorf"
		export GIT_AUTHOR_EMAIL="bryan@askmonty.org"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	esac

	case "$GIT_AUTHOR_EMAIL:$GIT_AUTHOR_NAME" in
	:"mysql.com!jpm")
		export GIT_AUTHOR_NAME="João Prado Maia"
		export GIT_AUTHOR_EMAIL="jpm@mysql.com"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	esac

	# debug
#	env | grep GIT_
' -- --all
