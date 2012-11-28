REPOBASE=$HOME/repos

for REPO in eventum; do
  cd $REPOBASE/$REPO/
  echo "Syncing $REPO repository from launchpad.."
  git bzr sync
  echo "Pushing $REPO repository to github.."
  git push github master
done
