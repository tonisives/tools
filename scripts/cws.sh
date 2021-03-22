#!/bin/bash
#
# Usage: ./commit_everything.sh "Commit message"

BOLD=$(tput bold)
BLACK=$(tput setaf 0)
WHITE=$(tput setaf 7)
BLUE=$(tput setaf 4)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

# Figure out if the parent repo has changed and make a commit with the
# commit message that was passed in
STATUS=$(git status --porcelain --ignore-submodules | wc -l)
if [[ $STATUS -ne 0 ]]; then
  echo "🤓  ${GREEN}UPDATING PARENT REPO${NORMAL}"
  git add .
  git commit -am "$1"
  if [[ $? -ne 0 ]]; then
    exit 1;
  fi
fi

# Now go to each submodule and update those with the same commit message
SUBMODULES=($(git submodule | awk '{print $2}'))
SUBMODULES_UPDATED=0
for SUBMODULE in "${SUBMODULES[@]}"; do
  pushd $SUBMODULE > /dev/null
  STATUS=$(git status --porcelain | wc -l)
  if [[ $STATUS -ne 0 ]]; then
    echo "🤓  ${GREEN}UPDATING SUBMODULE:${WHITE} ${SUBMODULE}${NORMAL}"
    git add .
    git commit -am "$1"
    if [[ $? -ne 0 ]]; then
      exit 1;
    fi
    SUBMODULES_UPDATED=1
    git pull --rebase && git status --short --branch && git push
    # run again recursively
    sh cws.sh "$1"
  fi
  popd > /dev/null
done

# When submodules are updated, we need to commit that as well
if [[ $SUBMODULES_UPDATED -eq 1 ]]; then
  echo "🤓  ${GREEN}UPDATING SUBMODULES${NORMAL}"
  git add .
  git commit -am "Updated submodules"
fi

# Push everything
echo "🤓  ${GREEN}UPDATING EVERYTHING${NORMAL}"
git pull --rebase && git status --short --branch && git push