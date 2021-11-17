#!/bin/sh

app_list=( # EDIT THIS BASED ON YOUR SETUP
  "myproject-api"
  "myproject-frontend"
  "gsheet-api"
)

dep_list=(
  "redis"
)

secret_list=(
  "app-staging"
  "app-production"
)

#####
echo "Adding argo projects..."
#####
kubectl apply -f ./charts/projects/argocd-production.yaml -n argocd
kubectl apply -f ./charts/projects/argocd-staging.yaml -n argocd
echo "Added all argo projects!"

#####
echo "Adding namespace..."
#####
kubectl create namespace staging
kubectl create namespace production
echo "Added all namespaces!"


#####
echo "Adding secrets..."
#####
DOCKERHUB_EMAIL=`cat ./init/id_dockerhub_email` # EDIT THIS
DOCKERHUB_USERNAME=`cat ./init/id_dockerhub_username` # EDIT THIS
DOCKERHUB_PASSWORD=`cat ./init/id_dockerhub_password` # EDIT THIS

kubectl create secret docker-registry dockerhub -n production --docker-username=$DOCKERHUB_USERNAME --docker-password=$DOCKERHUB_PASSWORD --docker-email=$DOCKERHUB_EMAIL
kubectl create secret docker-registry dockerhub -n staging --docker-username=$DOCKERHUB_USERNAME --docker-password=$DOCKERHUB_PASSWORD --docker-email=$DOCKERHUB_EMAIL

for value in "${secret_list[@]}"
do
  echo " [$value]"
  kubectl apply -f ./charts/secrets/$value.yaml
done
echo "Added all secrets!"


#####
echo "Adding dependencies to Argo..."
#####
for value in "${dep_list[@]}"
do
  echo " [$value]"
  kubectl apply -f ./charts/dep/$value/argo-staging.yaml
  kubectl apply -f ./charts/dep/$value/argo-production.yaml
done
echo "Added all dependencies to Argo!"

#####
echo "Adding app services to Argo..."
#####
for value in "${app_list[@]}"
do
echo " [$value]"
  kubectl apply -f ./charts/app/$value/argo-production.yaml
  kubectl apply -f ./charts/app/$value/argo-staging.yaml
done
echo "Added all app services to Argo!"

#####
echo "Adding app tasks to Argo..."
#####
echo "[$value]"
kubectl apply -f ./charts/tasks/argo-production.yaml
kubectl apply -f ./charts/tasks/argo-staging.yaml
echo "Added all app tasks to Argo!"
