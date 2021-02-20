#!/bin/bash
source ../env.sh
export HOSTIP=`minikube -p ${CLUSTER} ip`

node server.js &
ngrok http 8123