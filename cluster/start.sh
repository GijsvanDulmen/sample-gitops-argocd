#!/bin/bash

set -e exit

source ./env.sh

minikube -p ${CLUSTER} start \
    --memory=5120 --cpus=4 --vm=true

minikube -p ${CLUSTER} addons enable ingress

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Set fixed password
# Password: admin
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$k.6AIfusiYu8z3BMKYcfLuolH/IeiHESZxCjC68TbPk254gYodAgm",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'",
    "webhook.github.secret": "totalsecret"
  }}'

export HOSTIP=`minikube -p ${CLUSTER} ip`

# use the following
cat config.yml | \
sed "s/HOSTIP/${HOSTIP}/" | \
kubectl apply -f -

# wait for both the be finished
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd

# apply applications
kubectl -n argocd apply -f ../applications

Open "http://argocd.${HOSTIP}.nip.io"