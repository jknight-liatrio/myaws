#!/bin/bash -eux

KUBECTL_COMMAND="kubectl"

KUBE_CONTEXT=$(kubectl config current-context)

if [[ "${KUBE_CONTEXT}" == arn:aws:* ]] ; then
    KUBECTL_COMMAND="myaws -- kubectl"
fi

$KUBECTL_COMMAND $@
