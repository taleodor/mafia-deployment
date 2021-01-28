#!/bin/bash
## $1 - reliza hub instance api key, $2 - reluza hub uri (optional)
# require at least 1 param
if [ "$#" -lt 1 ]
then
	echo "Usage: api_key uri(optional)"
	exit 1
fi
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
images=$(/usr/local/bin/kubectl get pods -n mafia -o jsonpath="{.items[*].status.containerStatuses[0].imageID}")
docker pull relizaio/reliza-cli
docker run --rm relizaio/reliza-cli instdata -u ${2-https://relizahub.com}  -i INSTANCE__cb584aff-fe0e-4f79-97f4-3a8c3a0d233e -k $1 --images "$images"