#!/bin/bash

set -e exit

source ./env.sh

minikube -p ${CLUSTER} delete