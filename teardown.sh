#!/usr/bin/env bash

kubectl delete ns sample-app
kubectl delete clusterrolebinding sample-app-read-binding
kubectl delete clusterrole sample-app-read-access
