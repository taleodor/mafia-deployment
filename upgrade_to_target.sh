#!/bin/bash

## $1 - reliza hub instance api key, $2 uri - uri for reliza hub, $2 force - for force update
# require at least 1 params
if [ "$#" -lt 1 ]
then
	echo "Usage: api_key [uri - optional] [force - optional]"
	exit 1
fi

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
old_backend_image=$(/usr/local/bin/kubectl get pods --namespace mafia -l "name=mafia-backend" -o jsonpath="{.items[0].status.containerStatuses[0].imageID}")
old_ui_image=$(/usr/local/bin/kubectl get pods --namespace mafia -l "name=mafia-ui" -o jsonpath="{.items[0].status.containerStatuses[0].imageID}")
echo "old backend image = $old_backend_image"
echo "old ui image = $old_ui_image"
# TODO - wrap in a mapping props file instead
# establish target images from reliza hub
# note that sed is required to remove docker tag if supplied, since k8s doesn't have it
rlzclientout=$(docker run --rm relizaio/reliza-go-client    \
    getlatestrelease    \
    -u ${2-https://relizahub.com} \
    -i INSTANCE__cb584aff-fe0e-4f79-97f4-3a8c3a0d233e    \
    -k $1    \
    --project f3a3a0c2-9850-4341-b3d7-0570c5007b46    \
    --branch master    \
    --env PRODUCTION    \
    --instance cb584aff-fe0e-4f79-97f4-3a8c3a0d233e   \
    --namespace mafia);    \
    backend_image_hash=$(echo $rlzclientout | /usr/bin/jq -r .artifactDetails[0].digests[] | grep sha256);    \
    backend_image=$(echo $(echo $rlzclientout | /usr/bin/jq -r .artifactDetails[0].identifier)@$backend_image_hash | sed "s/:latest//")

rlzclientout=$(docker run --rm relizaio/reliza-go-client    \
    getlatestrelease    \
    -u ${2-https://relizahub.com} \
    -i INSTANCE__cb584aff-fe0e-4f79-97f4-3a8c3a0d233e    \
    -k $1    \
    --project a5bee672-016e-40c5-bbf1-06c54569b759    \
    --branch master    \
    --env PRODUCTION    \
    --instance cb584aff-fe0e-4f79-97f4-3a8c3a0d233e   \
    --namespace mafia);    \
    ui_image_hash=$(echo $rlzclientout | /usr/bin/jq -r .artifactDetails[0].digests[] | grep sha256);    \
    ui_image=$(echo $(echo $rlzclientout | /usr/bin/jq -r .artifactDetails[0].identifier)@$ui_image_hash | sed "s/:latest//")

echo "new ui image = $ui_image"
echo "new backend image = $backend_image"

if [ "$backend_image" != "$old_backend_image" ] || [ "$ui_image" != "$old_ui_image" ] || [ "$3" = "force" ]
then
	echo "New images detected, proceeding with upgrade"
	/usr/local/bin/helm upgrade mafia --kubeconfig /etc/rancher/k3s/k3s.yaml --set backend.image=$backend_image,ui.image=$ui_image -f ${0%/*}/helm/values_prod.yaml ${0%/*}/helm/
else
	echo "No new images, skipping upgrade"
fi
