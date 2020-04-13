#!/bin/bash
## $1 - reliza hub api id, $2 - reliza hub api key
# require at least 2 params
if [ "$#" -lt 2 ]
then
        echo "Usage: api_id api_key"
        exit 1
fi
docker pull relizaio/reliza-go-client
docker run --rm -v /home/rundocker/mafia-deployment/k8s_templates/:/indir -v /home/rundocker/mafia-deployment/k8s_test/:/outdir relizaio/reliza-go-client parsetemplate -i $1 -k $2 --env TEST
lines=$(git status -s | wc -l)
if [ $lines -gt 0 ];then
  echo "committing"
  git add .
  git commit -m "fix: auto-update of deployment based on Reliza Hub details"
#  git push
else
  echo "no change, nothing to commit"
fi
