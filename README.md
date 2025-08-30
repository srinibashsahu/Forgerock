# ForgeRock Deployment Guide

## Docker Images

### IG Base Image
Build the base IG image:
```bash
docker build . -f docker/Dockerfile -t ig-image
Main IG Image
Build the custom IG image:
docker build . -t ig-custom
DS Image
Build the ForgeRock Directory Services image:
docker build -t forgerock-ds:7.5.1 .
Deployment
Helm and Kind Cluster
Deploy and upgrade using Helm:
# Initial install
helm install ping-gateway ./

# Upgrade existing deployment
helm upgrade ping-gateway ./
NGINX Ingress Controller
Deploy the NGINX ingress controller:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
Kind Cluster Management
# Delete cluster
kind delete cluster

# Create new cluster
kind create cluster --config kind-config.yaml
MTLS Configuration
Generate certificates using mkcert:
mkcert ping.local
Create TLS Secrets
For Ping Gateway:
kubectl create secret tls ping-local-tls \
  --cert=ping.local.pem \
  --key=ping.local-key.pem
  For Directory Server:
  kubectl create secret tls ping-local-ds-tls \
  --cert=default.ds.example.com.pem \
  --key=default.ds.example.com
```
