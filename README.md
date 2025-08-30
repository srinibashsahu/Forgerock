IG-Base iamge (/app/docker/Dockerfile)
docker build . -f docker/Dockerfile -t ig-image
Main-IG iamge 
docker build . -t ig-custom

DS-Image
docker build -t forgerock-ds:7.5.1 .


deploy by helm and kind cluster
helm install ping-gateway ./
helm upgrade ping-gateway ./ 

nginix 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml


kind delete cluster
kind create cluster --config kind-config.yaml


Mtls

mkcert ping.local

kubectl create secret tls ping-local-tls `
  --cert=ping.local.pem `
  --key=ping.local-key.pem



kubectl create secret tls ping-local-ds-tls `
  --cert=default.ds.example.com.pem `
  --key=default.ds.example.coml-key.pem
