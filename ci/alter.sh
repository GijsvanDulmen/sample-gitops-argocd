#!/bin/bash
cd /tmp
rm -r sample-gitops-argocd

git clone git@github.com:GijsvanDulmen/sample-gitops-argocd.git
cd sample-gitops-argocd/resources/simple-app

export NR=`cat values-dev.yaml | yq e ".version" -`
export NEXTVERSION=$(($NR+1));

git checkout -b "update-to-version-${NEXTVERSION}"
yq e ".version = \"${NEXTVERSION}\"" -i values-dev.yaml

git add .
git commit -m "Update simple-app to version ${NEXTVERSION}"
git push --set-upstream origin "update-to-version-${NEXTVERSION}"

# create pr and enable auto-merge
gh pr create --base main --head "update-to-version-${NEXTVERSION}" --title "Updating to version ${NEXTVERSION}" --body "Please autoaccept!"
gh pr merge --auto --squash