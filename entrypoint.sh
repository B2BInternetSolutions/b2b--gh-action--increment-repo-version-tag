#!/bin/sh
set -eu

# Set up .netrc file with GitHub credentials
git_setup ( ) {
    #git config --global user.email "actions@github.com"
    git config --global user.email "mike@mikeowen.co.uk"
    git config --global user.name "Incremental tag GitHub Action"
}

echo "###################"
echo "Tagging Parameters"
echo "###################"
echo "flag_branch: ${INPUT_FLAG_BRANCH}"
echo "message: ${INPUT_MESSAGE}"
echo "prev_tag: ${INPUT_PREV_TAG}"
echo "GITHUB_ACTOR: ${GITHUB_ACTOR}"
echo "GITHUB_TOKEN: ${GITHUB_TOKEN}"
echo "HOME: ${HOME}"
echo "###################"
echo ""
echo "Start process..."

echo "1) Setting up git machine..."
git_setup

echo "2) Ensuring all directories are trusted - Safely, in this case, gets over this check: https://github.com/git/git/commit/8959555cee7ec045958f9b6dd62e541affb7e7d9"
git config --system --add safe.directory '/github/workspace'
#git config --global --add safe.directory '*'

echo "3) Updating repository tags..."
git fetch origin --tags --quiet

last_tag=""
if [ "${INPUT_FLAG_BRANCH}" = true ];then
    branch=$(git rev-parse --abbrev-ref HEAD)
    echo "branch: ${branch}";

    last_tag=`git describe --tags $(git rev-list --tags) --always|egrep "${INPUT_PREV_TAG}${branch}\.[0-9]*\.[0-9]*$"|sort -V -r|head -n 1`
    echo "Last tag: ${last_tag}";
else
    last_tag=`git describe --tags $(git rev-list --tags --max-count=1)`
    echo "Last tag: ${last_tag}";
fi


if [ -z "${last_tag}" ];then
    if [ "${INPUT_FLAG_BRANCH}" != false ];then
        last_tag="${INPUT_PREV_TAG}${branch}.1.0";
    else
        last_tag="${INPUT_PREV_TAG}0.1.0";
    fi
    echo "Default Last tag: ${last_tag}";
fi

next_tag="${last_tag%.*}.$((${last_tag##*.}+1))"
echo "4) Next tag: ${next_tag}";

echo "5) Forcing tag update..."
git tag -a ${next_tag} -m "${INPUT_MESSAGE}" "${GITHUB_SHA}" -f
echo "6) Forcing tag push..."
git push --tags -f
