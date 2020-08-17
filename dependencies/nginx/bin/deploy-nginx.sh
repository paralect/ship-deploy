#!/usr/bin/env bash
cd "$( dirname "${BASH_SOURCE[0]}" )"/../

kubectl create namespace ingress-nginx-helm

helm upgrade --install nginx-release stable/nginx-ingress --namespace=ingress-nginx-helm \
  -f ./values/values.yml
