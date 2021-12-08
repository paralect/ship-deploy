#!/usr/bin/env bash
cd "$( dirname "${BASH_SOURCE[0]}" )"/../

sh ./dependencies/resources/bin/namespaces.sh
sh ./dependencies/ingress-nginx/bin/deploy-ingress-nginx.sh
sh ./dependencies/redis/bin/deploy-redis.sh
