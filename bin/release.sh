#!/bin/bash

# current Git branch
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# v1.0.0, v1.5.2, etc.
versionLabel=$1

if [[ ! "$versionLabel" ]]; then
    read -p "Enter the new version number with no 'v' (for example '1.0.1'): " versionLabel
fi

# Error - no version specified
if [[ ! "$versionLabel" ]]; then
	echo "Aborting (no version specified)."
	exit 1
fi

# establish branch and tag name variables
devBranch=$branch
masterBranch=master
releaseBranch=release-$versionLabel
 
# create the release branch from the -develop branch
git checkout -b $releaseBranch $devBranch
 
# file in which to update version number
versionFile="version.txt"
 
# find version number assignment ("v1.5.5" for example)
# and replace it with newly specified version number
if [ -f $versionFile ]; then
    sed -i -E "s/\v*[a-Z0-9.-]+/\v$versionLabel/" $versionFile
else
    # If version file not exists, create it
    echo v$versionLabel > $versionFile
fi

# Cleaning not necessary files
git reset -- * .gitignore &&
git rm -r --cached * .gitignore &&
git add -f *.m bower.json LICENSE version.txt &&
git add -f src/* &&

# commit version number increment
git commit -am "Incrementing version number to $versionLabel"
 
# merge release branch with the new version number into master
git checkout $masterBranch
git merge --no-ff $releaseBranch
 
# create tag for new version from -master
git tag $versionLabel
 
# merge release branch with the new version number back into develop
git checkout $devBranch
git merge --no-ff $releaseBranch
 
# remove release branch
git branch -D $releaseBranch