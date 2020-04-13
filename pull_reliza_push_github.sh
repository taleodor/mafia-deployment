#!/bin/bash
docker pull relizaio/reliza-go-client
docker run --rm -v /home/rundocker/mafia-deployment/k8s_templates/:/indir -v /home/rundocker/mafia-deployment/k8s_test/:/outdir relizaio/reliza-go-client parsetemplate -i $RELIZA_API_ID -k $RELIZA_API_KEY --env TEST
lines=$(git status -s | wc -l)
if [ $lines -gt 0 ];then
  echo "committing"
  git add .
  git commit -m "fix: auto-update of deployment based on Reliza Hub details"
#  git push
else
  echo "no change, nothing to commit"
fi
