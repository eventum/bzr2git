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
	:"mysql.com!bryan" | \
	:"balsdorf" | \
	:"jesushatesjava.com!bryan/balsdorf" | \
	:"jesushatesjava.com!balsdorf" | \
	:"!balsdorf" | \
	:"!bryan" | \
	bryan@achilles:"Bryan Alsdorf" | \
	bryan@askmonty.org:"Bryan Alsdorf" | \
	bryan@montyprogram.com:"Bryan Alsdorf" | \
	_____ )
		export GIT_AUTHOR_NAME="Bryan Alsdorf"
		export GIT_AUTHOR_EMAIL="balsdorf@gmail.com"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	:"mysql.com!jpm")
		export GIT_AUTHOR_NAME="João Prado Maia"
		export GIT_AUTHOR_EMAIL="jpm@pessoal.org"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	:mroszyk)
		export GIT_AUTHOR_NAME="Matt Roszyk"
		export GIT_AUTHOR_EMAIL="mrrozz@gmail.com"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	:kbrown)
		export GIT_AUTHOR_NAME="Kirk Brown"
		export GIT_AUTHOR_EMAIL="kirk@kirkbrown.com"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	:mysql.com!ebraswell2)
		export GIT_AUTHOR_NAME="Eric"
		export GIT_AUTHOR_EMAIL="eric@bitherder.net"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	:rlambe)
		export GIT_AUTHOR_NAME="Ray Lambe"
		export GIT_AUTHOR_EMAIL="ray.lambe@nf.sympatico.ca"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	:mysql.com!lgrimmer)
		export GIT_AUTHOR_NAME="Lenz Grimmer"
		export GIT_AUTHOR_EMAIL="lenz@grimmer.com"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	:mysql.com!jimw)
		export GIT_AUTHOR_NAME="Jim Winstead"
		export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
		;;
	*:"Harri Porten")
		export GIT_AUTHOR_EMAIL="porten@froglogic.com"
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	"Hartmut Holzgraefe":*)
		export GIT_AUTHOR_EMAIL="hartmut@php.net"
		export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
		;;
	esac

	# debug
#	env | grep GIT_
' -- --all
