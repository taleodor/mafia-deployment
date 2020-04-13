#!/bin/bash
docker pull relizaio/reliza-go-client
docker run --rm -v /home/rundocker/mafia-deployment/k8s_templates/:/indir -v /home/rundocker/mafia-deployment/k8s_test/:/outdir relizaio/reliza-go-client parsetemplate -i $RELIZA_API_ID -k $RELIZA_API_KEY --env TEST
if [ "git status -s | wc -l" != 0 ];then
  echo "committing"
  git commit -am "fix: auto-update of deployment based on Reliza Hub details"
  git push
else
  echo "no change, nothing to commit"
fi
