#!/usr/bin/env bash
cd "$( dirname "${BASH_SOURCE[0]}" )"/../

kubectl create namespace staging
kubectl create namespace production
