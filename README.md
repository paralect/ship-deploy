# Getting Started

Deploy scripts for Kubernetes. Install kubectl and helm client before using it

[Kubernetes concepts](https://kubernetes.io/docs/concepts/)

Kubectl is a command line tool for controlling Kubernetes clusters. To install kubectl follow kubectl installation docs:
[kubectl installation docs](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

Helm is the package manager for Kubernetes. Currently we are using helm v2. To install helm client follow helm installation docs (you do not need to install tiller):
[helm installation docs](https://v2.helm.sh/docs/install/)

## Deploy scripts structure

```
/app - helm chart for app
/bin - bash scripts
/dependencies - folder with app dependencies (you can read what dependency is below)
  /dependency-name - dependency helm chart
/script - script for service deployments
```

[helm chart structure](https://v2.helm.sh/docs/developing_charts/#charts)

## Setup dependencies

Dependencies include:
- cluster dependences (tiller (helm server), regcred (for pulling docker images from private dockerhub repos), nginx)
- app dependences (redis, mongodb)

[tiller](https://v2.helm.sh/docs/install/)
[regcred](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

To setup run command:

```
sh ./bin/deploy-dependencies.sh
```

mongodb connection string will look like `"mongodb://{mongodb user}:{mongodb user password}@{service name}.{mongodb namespace}.svc.cluster.local:{mongodb port}/{mongodb name}"`
Default values:
- mongodb user - `admin`
- service name - `mongodb`
- mongodb namespace - `mongodb`
- mongodb port - `27017`
- mongodb name - `staging-db`

To get mongodb password run command (note: password will be in base64. To use it you need to encode it. Use any encoder (ex. [this](https://www.base64decode.org/))):

```
kubectl get secret mongodb -n mongodb -o yaml
```

To connect to mongodb from outside you can use port forward:

```
kubectl port-forward mongodb --namespace mongodb 27017:27017
```

After that you can connect to mongodb using `localhost:27017`

If port forward doesn't fit you you can expose mongodb using command:

```
kubectl expose pod mongodb --type=LoadBalancer -n mongodb
```

## Setup DNS records

To see cluster nginx external ip run command (note: ip doesn't appear immediately after dependencies setup. It can take a few minutes):

```
kubectl get services -n ingress-nginx-helm
```

After that you can use this ip to setup DNS A records with DNS provider (ex. cloudflare) (note: the record doesn't start to work immediately. It can take some time)

## Configure https

If you don't want to use https skip this step
Otherwise, run command. This will setup cert-manager and cert-cluster-issuer:

```
sh ./bin/deploy-cert-manager.sh
```

[cert-manager docs](https://cert-manager.io/docs/installation/kubernetes/)

## Setup CI

If you don't want to use CI or want to use existing CI server skip this step

Currently we are using drone CI

[drone chart](https://github.com/helm/charts/tree/master/stable/drone)

Before setup update CI host

[CI values](dependencies/drone-ci/drone/values/values.yml)

Create OAuth App on github (Settings -> Developer settings -> OAuth Apps -> New OAuth App)

Run command:

```
sh ./bin/deploy-ci.sh
```

Go to drone CI host and turn it on for your project repo. Add CI variables (kubernetes token, api server etc.)

## Update project specific variables

By default app deploys in `app` namespace. If you want to use one Kubernetes cluster for several envs, you can change it by changing [app values](app/values/values.yml) and [script config](script/src/config.js)

- update ingress hosts
- deployments (if needed)
- services (if needed)
- ports (if needed)
- namespace (if needed)
- environment (if needed)

[app values](app/values/values.yml)

## Manual deployment

For manual deployments we are using script. This script will deploy only one service. It will build image, push it to dockerhub and then push it to Kubernetes cluser

Install dependences. In `script` folder run `npm i`

Update deploy config. Also, you can find env variables which using this script

[script config](script/src/config.js)

To deploy service run command:

```
node ./src/index.js
```
