#!/bin/bash
## $1 - reliza hub api id, $2 - reliza hub api key
# require at least 2 params
if [ "$#" -lt 2 ]
then
        echo "Usage: api_id api_key"
        exit 1
fi

# reset git repo to head
git fetch
git reset --hard origin/master

docker run --rm -v /mafia-deployment/k8s_templates/:/indir -v /mafia-deployment/k8s_production/:/outdir relizaio/reliza-go-client parsetemplate -i $1 -k $2 --env PRODUCTION
exitcode=$(echo $?)
if [ $exitcode -gt 0 ];then
  echo "Error retrieving data from Reliza Hub for production env, aborting"
  git reset --hard origin/master
  exit 1
fi

lines=$(git status -s | wc -l)
if [ $lines -gt 0 ];then
  echo "committing"
  git add .
  git commit -m "fix: auto-update of deployment based on Reliza Hub details for production env"
  git push
else
  echo "no change, nothing to commit"
fi
