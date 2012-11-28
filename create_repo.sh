# Create repo
mkdir eventum
cd eventum
git init 

# Prepare for bzr
mkdir .git/bzr
mkdir .git/bzr/repo
mkdir .git/bzr/map
bzr init-repo --no-trees .git/bzr/repo
bzr branch lp:eventum .git/bzr/repo/master

# Fast-export the bzr repo
bzr fast-export --plain --export-marks=.git/bzr/map/master-bzr --git-branch=bzr/master .git/bzr/repo/master > bzr-fast-export

# Fixing the repo committers
sed "s/^committer <Elan>/committer Elan Ruusamäe <glen@delfi.ee>/" bzr-fast-export > bzr-fast-export-fix
sed "s/^committer <>/committer Unknown <noreply@launchpad.net>/" bzr-fast-export-fix > bzr-fast-export
rm bzr-fast-export-fix

# Import into git
git fast-import --quiet --export-marks=.git/bzr/map/master-git < bzr-fast-export
rm bzr-fast-export
git branch master bzr/master
git config bzr.master.bzr bzr/master
git config bzr.bzr/master.upstream lp:eventum
git checkout master

git bzr sync
git remote add github git@github.com:petterl/eventum.git
git push github master
