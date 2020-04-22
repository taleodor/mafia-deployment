#!/bin/bash
# $1 - reliza hub instance api id, $2 - reliza hub instance api key, $3 argocd uri, $4 - argocd token https://argoproj.github.io/argo-cd/developer-guide/api-docs/
# require at least 2 params
if [ "$#" -lt 2 ]
then
        echo "Usage: api_id api_key argocd_uri argocd_token"
        exit 1
fi
argo_git_sha=$(curl -ks https://$3/api/v1/applications/mafia -H "Authorization: Bearer $4" | /snap/bin/jq -r ".status.sync.revision")
echo $argo_git_sha
docker pull relizaio/reliza-go-client
docker run --rm relizaio/reliza-go-client instdata -i $1 -k $2 --sender argocd --images "sha1:$argo_git_sha"