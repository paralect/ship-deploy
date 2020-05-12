# Getting Started

## Setup dependencies

To setup tiller, regcred, redis, nginx and mongodb run command:

```
sh ./bin/deploy-dependencies.sh
```

## Setup DNS records

To see cluster nginx external ip run command:

```
kubectl get services -n ingress-nginx-helm
```

## Setup cert manager

Run command:

```
sh ./bin/deploy-cert-manager.sh
```

## Setup CI

Update ci host

[ci values](dependencies/drone-ci/values/values.yml)

Create OAuth App on github (Settings -> Developer settings -> OAuth Apps -> New OAuth App)

Run command:

```
sh ./bin/deploy-ci.sh
```

Go to drone ci host and turn it on for your project repo. Add ci variables (kubernetes token, api server etc.)

## Update project specific variables

- update ingress hosts
- deployments (if needed)
- services (if needed)
- ports (if needed)
- namespace (if needed)
- environment (if needed)

[app values](app/values/values.yml)

## Manual deployment

Install dependences. In `script` folder run `npm i`

Update deploy config (if needed)

[config](script/src/config.js)

Run command:

```
node ./src/index.js
```
