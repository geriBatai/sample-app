#!/usr/bin/env bash

#kubectl create ns sample-app
kubectl create secret generic git-private-key --from-file=key=./ro-priv --namespace=sample-app
kubectl create secret generic auth-token-file --from-file=token=./token --namespace=sample-app
kubectl create -f operator.yaml
