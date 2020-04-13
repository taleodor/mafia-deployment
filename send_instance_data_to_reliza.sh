#!/bin/bash
# $1 - reliza hub instance api id, $2 - reliza hub instance api key
# require at least 2 params
if [ "$#" -lt 2 ]
then
        echo "Usage: api_id api_key"
        exit 1
fi
images=$(/snap/bin/microk8s.kubectl get pods -n mafia -o jsonpath="{.items[*].status.containerStatuses[0].imageID}")
docker pull relizaio/reliza-go-client
docker run --rm relizaio/reliza-go-client instdata -i $1 -k $2 --images $images