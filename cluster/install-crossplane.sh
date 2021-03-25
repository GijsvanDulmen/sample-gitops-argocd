#!/bin/bash
kubectl create namespace crossplane-system

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane --namespace crossplane-system crossplane-stable/crossplane --version 1.0.0

# install gcp
kubectl apply -f ./crossplane/provider.yaml

kubectl wait --for=condition=healthy --timeout=30s -n crossplane-system provider/provider-gcp